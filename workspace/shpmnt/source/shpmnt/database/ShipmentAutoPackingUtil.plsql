-----------------------------------------------------------------------------
--
--  Logical unit: ShipmentAutoPackingUtil
--  Component:    SHPMNT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  221103  AvWilk  SCDEV-17249, performance improvement,added Inventory_Event_Manager_API start and finish sessions into Auto_Pack_Shipment_Lines.
--  210818  Aabalk  SC21R2-1024, Added Update_Reservation_Rec___ method to update packing proposal collections when attaching a quantity.
--  210805  Aabalk  SC21R2-1652, Modified Pack_Acc_Pack_Proposal method by adding info messages.
--  210803  Aabalk  SC21R2-2187, Passed in biggest handling unit type values to pack by reservation method in Do_Pack_Acc_Pack_Proposal___ method.
--  210803          Modified Pack_By_Source_Object___ to delete big source refs which cannot be packed during the mix small source objects approach.
--  210803  Aabalk  SC21R2-2190, Moved Handling_Unit_Type_Rec and Handling_Unit_Type_Tab from Ship_Pack_Proposal_Hu_Type_API.
--  210731  Aabalk  SC21R2-2063, Added methods Check_Packable_By_Dimension_ and Get_Packable_Hu_Type_Id_. Modified Pack_By_Source_Object___ and 
--  210731          Pack_By_Reservation___ methods to add a dimension check to see if parts fit a handling unit type before packing.
--  210727  Aabalk  SC21R2-1028, Added new method Pack_By_Source_Object___ to implement source object packing method for shipment packing proposal.
--  210727  RoJalk  SC21R2-1034, Modified get_reservations_by_picklist cursor in Pack_Acc_Pack_Proposal method to support excl_fully_reserved_hu flag.
--  210727  RoJalk  SC21R2-1026, Modified the source_ref_type_db of Reservation_Rec to be VARCHAR2(20).
--  210723  RasDlk  SC21R2-1023, Modified Pack_Acc_Pack_Proposal by replacing the occurences of DB_RESERVATION_VOLUME by DB_RESERVATION_LINE_VOLUME.
--  210721  RoJalk  SC21R2-1034, Modified Pack_Acc_Pack_Proposal method to support exclude_fully_reserved_hu flag.
--  210720  Aabalk  SC21R2-1023, Modified Pack_Acc_Pack_Proposal and added sorting by descending reservation volume and 
--  210720          ascending route order for the reservations.
--  210717  Aabalk  SC21R2-1026, Implemented pack by reservation and by piece in Do_Pack_Acc_Pack_Proposal___ method.
--  210621  Aabalk  SC21R2-1022, Implemented Pack_Acc_Pack_Proposal with basic pick list group based packing.
--  210531  RoJalk  SC21R2-1030, Added the method Pack_Acc_Pack_Proposal.
--  160511  RoJalk  LIM-6964, Modified Auto_Pack_Shipment_Lines and removed conditional compilation when calling Shipment_Line_API.Connect_To_New_Handling_Units.
--  160503  RoJalk  LIM-7310, Renamed Shipment_Handling_Utility_API.Get_Remain_Parcel_Qty to Get_Remaining_Qty_To_Attach.
--  160420  RoJalk  LIM-6965, Modified Auto_Pack_Shipment_Lines and renamed order ref to source ref.
--  160330  RoJalk  LIM-6268, Modified Auto_Pack_Shipment_Lines to support 7 array items.
--  160308  MaRalk  LIM-5871, Modified method Auto_Pack_Shipment_Lines in order to reflect shipment_line_tab - source_ref4 
--  160308          data type change as varchar2.
--  160205  RoJalk  LIM-4246, Modified Auto_Pack_Shipment_Lines and included shipment_line_no in Shipment_Line_API.Get call.
--  160120  RoJalk  LIM-5910, modified Auto_Pack_Shipment_Lines, Auto_Pack_Shipment_Lines to handle shipment line no.
--  160106  MaIklk  LIM-5750, Passed source_ref_type paramter for the Shipment_Handling_Utility_API.Get_Remain_Parcel_Qty().
--  151216  MaEelk  LIM-5383, Removed the procedure Auto_Pack_Hu_In_Parent___ and moved its content in to 
--  151216          Handl_Unit_Auto_Pack_Util_API.Auto_Pack_Hu_In_Parent.
--  151216          Removed the private declarations Auto_Packing_Rec and Auto_Packing_Tab from the code
--  151202  RoJalk  LIM-5178, Rename ORDER_NO, LINE_NO, REL_NO, LINE_ITEM_NO to SOURCE_REF1,
--  151202          SOURCE_REF2, SOURCE_REF3, SOURCE_REF4 in ShipmentLine and ShipmentLineHandlUnit. 
--  151110  RoJalk  LIM-4610, Rename ShipmentOrderLine LU to ShipmentLine.
--  150901  MaEelk   Bug 124141, passed shipment_id_ to the method call shipment_id_ Handling_Unit_API.Modify_Parent_And_Shipment.
--  130506  JeLise   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
TYPE Handling_Unit_Type_Rec IS RECORD (
   handling_unit_type_id         VARCHAR2(25),
   max_volume_utilization        NUMBER,
   operative_volume_utilization  NUMBER,
   uom_for_volume                VARCHAR2(30),
   max_weight_capacity           NUMBER,
   uom_for_weight                VARCHAR2(30),
   width                         NUMBER,
   height                        NUMBER,
   depth                         NUMBER,
   uom_for_length                VARCHAR2(30)
);

TYPE Handling_Unit_Type_Tab IS TABLE OF Handling_Unit_Type_Rec INDEX BY PLS_INTEGER;   


-------------------- PRIVATE DECLARATIONS -----------------------------------
TYPE Ship_Pick_Res_Group_Rec IS RECORD (
   pick_list_no                  VARCHAR2(15),
   total_volume                  NUMBER,
   total_weight                  NUMBER
);
   
TYPE Ship_Pick_Res_Group_Tab IS TABLE OF Ship_Pick_Res_Group_Rec
   INDEX BY PLS_INTEGER;

TYPE Order_Group_Res_Rec IS RECORD (
   source_ref1                   VARCHAR2(50),
   source_ref_type_db            VARCHAR2(20),   
   order_volume                  NUMBER,
   order_weight                  NUMBER
);

TYPE Orders_Tab IS TABLE OF Order_Group_Res_Rec INDEX BY PLS_INTEGER;

TYPE Reservation_Rec IS RECORD (
   shipment_line_no              NUMBER, 
   conv_factor                   NUMBER, 
   inverted_conv_factor          NUMBER,
   qty_to_pack                   NUMBER,
   shipment_id                   NUMBER,
   source_ref1                   VARCHAR2(50),
   source_ref2                   VARCHAR2(50),
   source_ref3                   VARCHAR2(50),
   source_ref4                   VARCHAR2(50),    
   source_ref_type_db            VARCHAR2(20),
   source_ref_type               VARCHAR2(30),
   part_no                       VARCHAR2(25),
   contract                      VARCHAR2(5),
   configuration_id              VARCHAR2(50),
   location_no                   VARCHAR2(35),
   lot_batch_no                  VARCHAR2(20),
   serial_no                     VARCHAR2(50),
   waiv_dev_rej_no               VARCHAR2(15),
   eng_chg_level                 VARCHAR2(6),
   pick_list_no                  VARCHAR2(15),
   activity_seq                  NUMBER,
   handling_unit_id              NUMBER,
   sscc                          VARCHAR2(18),
   alt_handling_unit_label_id    VARCHAR2(25),
   expiration_date               DATE,
   catch_qty                     NUMBER,
   catch_qty_issued              NUMBER,
   part_volume                   NUMBER,
   part_weight                   NUMBER,
   storage_width_requirement     NUMBER,
   storage_height_requirement    NUMBER,
   storage_depth_requirement     NUMBER
);

TYPE Reservations_To_Pack_Tab IS TABLE OF Reservation_Rec INDEX BY PLS_INTEGER;

TYPE Part_Rec IS RECORD (
   contract                      VARCHAR2(5),
   part_no                       VARCHAR2(25),
   source_ref1                   VARCHAR2(50),
   source_ref_type_db            VARCHAR2(20),
   qty_to_pack                   NUMBER,
   storage_width_requirement     NUMBER,
   storage_height_requirement    NUMBER,
   storage_depth_requirement     NUMBER,
   fits_biggest_hu_type          VARCHAR2(5),
   smallest_packable_hu_type     VARCHAR2(25)
);

TYPE Parts_Tab IS TABLE OF Part_Rec INDEX BY PLS_INTEGER;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
PROCEDURE Do_Pack_Acc_Pack_Proposal___ (
   reservations_to_pack_tab_  IN OUT Reservations_To_Pack_Tab,
   ship_pick_res_group_rec_   IN OUT Ship_Pick_Res_Group_Rec,
   proposal_hu_types_tab_     IN Handling_Unit_Type_Tab,
   shipment_id_               IN NUMBER,
   comp_uom_for_volume_       IN VARCHAR2,
   comp_uom_for_weight_       IN VARCHAR2,
   comp_uom_for_length_       IN VARCHAR2,
   packing_proposal_id_       IN VARCHAR2,
   pack_by_source_object_     IN VARCHAR2,
   pack_by_reservation_line_  IN VARCHAR2,
   pack_by_piece_             IN VARCHAR2,
   allow_mix_source_object_   IN VARCHAR2,
   excl_fully_reserved_hu_    IN VARCHAR2)
IS
   CURSOR get_parts_to_pack(pick_list_no_    IN VARCHAR2, excl_fully_reserved_hu_ IN VARCHAR2, biggest_hu_type_width_    IN NUMBER, biggest_hu_type_height_     IN NUMBER, biggest_hu_type_depth_   IN NUMBER) IS
      SELECT contract, part_no, source_ref1, source_ref_type_db, SUM(qty_to_pack),
             storage_width_requirement, storage_height_requirement, storage_depth_requirement,
             Check_Packable_By_Dimension_(storage_width_requirement, storage_height_requirement, storage_depth_requirement, biggest_hu_type_width_, biggest_hu_type_height_, biggest_hu_type_depth_),
             Get_Packable_Hu_Type_Id_(part_volume, part_weight, storage_width_requirement, storage_height_requirement, storage_depth_requirement, proposal_hu_types_tab_, comp_uom_for_volume_, comp_uom_for_weight_, comp_uom_for_length_)
       FROM shipment_packable_reservation
      WHERE shipment_id = shipment_id_
        AND pick_list_no = pick_list_no_
        AND qty_to_pack > 0 
        AND ((handling_unit_id = 0) OR ((handling_unit_id != 0) 
                                       AND ((excl_fully_reserved_hu_ = 'FALSE') 
                                       OR ((excl_fully_reserved_hu_ = 'TRUE') AND (fully_reserved_hu = 'FALSE')))))
      GROUP BY contract, part_no, source_ref1, source_ref_type_db, part_volume, part_weight, storage_width_requirement, storage_height_requirement, storage_depth_requirement
      ORDER BY (storage_width_requirement + storage_height_requirement + storage_depth_requirement) DESC NULLS LAST;
      
   parts_tab_  Parts_Tab;
   
   CURSOR get_orders_to_pack(pick_list_no_  IN VARCHAR2, excl_fully_reserved_hu_ IN VARCHAR2) IS
      SELECT source_ref1, source_ref_type_db,
      SUM(qty_to_pack * part_volume) order_volume,
      SUM(qty_to_pack * part_weight) order_weight
       FROM Shipment_Packable_Reservation
      WHERE shipment_id = shipment_id_
        AND pick_list_no = pick_list_no_
        AND qty_to_pack > 0
        AND ((handling_unit_id = 0) OR ((handling_unit_id != 0) AND
                                       ((excl_fully_reserved_hu_ = 'FALSE') 
                                       OR ((excl_fully_reserved_hu_ = 'TRUE') AND (fully_reserved_hu = 'FALSE')))))
      GROUP BY source_ref1, source_ref_type_db
      ORDER BY SUM(qty_to_pack * part_volume) DESC;
      
   orders_tab_    Orders_Tab;
   
   new_handling_unit_id_            NUMBER := 0;
   handling_unit_type_id_to_pack_   VARCHAR2(25);
   biggest_handling_unit_type_      VARCHAR2(25);
   biggest_hu_type_vol_             NUMBER;
   biggest_hu_type_weight_          NUMBER;
   biggest_hu_type_width_           NUMBER;
   biggest_hu_type_height_          NUMBER;
   biggest_hu_type_depth_           NUMBER;
   hu_type_operative_vol_           NUMBER;
   hu_type_operative_weight_        NUMBER;
   hu_type_width_                   NUMBER;
   hu_type_height_                  NUMBER;
   hu_type_depth_                   NUMBER;
   m_                               PLS_INTEGER;
   packable_reservation_available_  BOOLEAN := FALSE; 
BEGIN
   IF ship_pick_res_group_rec_.total_volume > 0 THEN   
      IF comp_uom_for_volume_ = proposal_hu_types_tab_(proposal_hu_types_tab_.LAST).uom_for_volume 
         AND comp_uom_for_weight_ = proposal_hu_types_tab_(proposal_hu_types_tab_.LAST).uom_for_weight
         AND comp_uom_for_length_ = proposal_hu_types_tab_(proposal_hu_types_tab_.LAST).uom_for_length THEN
         biggest_handling_unit_type_  := proposal_hu_types_tab_(proposal_hu_types_tab_.LAST).handling_unit_type_id;
         biggest_hu_type_vol_         := proposal_hu_types_tab_(proposal_hu_types_tab_.LAST).operative_volume_utilization;
         biggest_hu_type_weight_      := proposal_hu_types_tab_(proposal_hu_types_tab_.LAST).max_weight_capacity;
         biggest_hu_type_width_       := proposal_hu_types_tab_(proposal_hu_types_tab_.LAST).width;
         biggest_hu_type_height_      := proposal_hu_types_tab_(proposal_hu_types_tab_.LAST).height;
         biggest_hu_type_depth_       := proposal_hu_types_tab_(proposal_hu_types_tab_.LAST).depth;
      ELSE
         biggest_handling_unit_type_  := proposal_hu_types_tab_(proposal_hu_types_tab_.LAST).handling_unit_type_id;
         biggest_hu_type_vol_         := Iso_Unit_API.Get_Unit_Converted_Quantity(proposal_hu_types_tab_(proposal_hu_types_tab_.LAST).operative_volume_utilization,
                                                                                  proposal_hu_types_tab_(proposal_hu_types_tab_.LAST).uom_for_volume,
                                                                                  comp_uom_for_volume_);
         biggest_hu_type_weight_      := Iso_Unit_API.Get_Unit_Converted_Quantity(proposal_hu_types_tab_(proposal_hu_types_tab_.LAST).max_weight_capacity,
                                                                                  proposal_hu_types_tab_(proposal_hu_types_tab_.LAST).uom_for_weight,
                                                                                  comp_uom_for_weight_);
         biggest_hu_type_width_       := Iso_Unit_API.Get_Unit_Converted_Quantity(proposal_hu_types_tab_(proposal_hu_types_tab_.LAST).width,
                                                                                  proposal_hu_types_tab_(proposal_hu_types_tab_.LAST).uom_for_length,
                                                                                  comp_uom_for_length_);
         biggest_hu_type_height_      := Iso_Unit_API.Get_Unit_Converted_Quantity(proposal_hu_types_tab_(proposal_hu_types_tab_.LAST).height,
                                                                                  proposal_hu_types_tab_(proposal_hu_types_tab_.LAST).uom_for_length,
                                                                                  comp_uom_for_length_);
         biggest_hu_type_depth_       := Iso_Unit_API.Get_Unit_Converted_Quantity(proposal_hu_types_tab_(proposal_hu_types_tab_.LAST).depth,
                                                                                  proposal_hu_types_tab_(proposal_hu_types_tab_.LAST).uom_for_length,
                                                                                  comp_uom_for_length_);
      END IF;
      
      IF parts_tab_.COUNT = 0 THEN
         OPEN get_parts_to_pack (ship_pick_res_group_rec_.pick_list_no, excl_fully_reserved_hu_, biggest_hu_type_width_, biggest_hu_type_height_, biggest_hu_type_depth_);
         FETCH get_parts_to_pack BULK COLLECT INTO parts_tab_;
         CLOSE get_parts_to_pack;
      END IF;
      
      IF pack_by_source_object_ = 'FALSE' THEN
         Get_Packable_Hu_Type_Id___(handling_unit_type_id_to_pack_, hu_type_operative_vol_, hu_type_operative_weight_, hu_type_width_, hu_type_height_, hu_type_depth_, 
         ship_pick_res_group_rec_.total_volume, ship_pick_res_group_rec_.total_weight, parts_tab_(parts_tab_.FIRST).storage_width_requirement, parts_tab_(parts_tab_.FIRST).storage_height_requirement, 
         parts_tab_(parts_tab_.FIRST).storage_depth_requirement, proposal_hu_types_tab_, comp_uom_for_volume_, comp_uom_for_weight_, comp_uom_for_length_);
         
         -- Cannot pack pick list grouping into HU types. Proceed to other packing methods
         IF handling_unit_type_id_to_pack_ IS NULL THEN            
            Pack_By_Reservation___(packable_reservation_available_, reservations_to_pack_tab_, ship_pick_res_group_rec_, orders_tab_, parts_tab_,
                                   new_handling_unit_id_, hu_type_operative_vol_, hu_type_operative_weight_, pack_by_reservation_line_, 
                                   pack_by_piece_, allow_mix_source_object_, biggest_handling_unit_type_, biggest_hu_type_vol_, 
                                   biggest_hu_type_weight_, NULL, NULL);
            
            -- More reservations exist 
            IF parts_tab_.COUNT > 0 THEN
               IF (reservations_to_pack_tab_.COUNT >= 1 AND (packable_reservation_available_)) 
                  OR Get_Packable_Hu_Type_Id_(ship_pick_res_group_rec_.total_volume, ship_pick_res_group_rec_.total_weight, parts_tab_(parts_tab_.FIRST).storage_width_requirement, 
                                              parts_tab_(parts_tab_.FIRST).storage_height_requirement, parts_tab_(parts_tab_.FIRST).storage_depth_requirement, proposal_hu_types_tab_, 
                                              comp_uom_for_volume_, comp_uom_for_weight_, comp_uom_for_length_) IS NOT NULL THEN
                  Do_Pack_Acc_Pack_Proposal___(reservations_to_pack_tab_, ship_pick_res_group_rec_, proposal_hu_types_tab_, shipment_id_, 
                                               comp_uom_for_volume_, comp_uom_for_weight_, comp_uom_for_length_, packing_proposal_id_, pack_by_source_object_, 
                                               pack_by_reservation_line_, pack_by_piece_, allow_mix_source_object_, excl_fully_reserved_hu_);
               END IF;
            END IF;
         ELSE
            m_ := reservations_to_pack_tab_.FIRST;
            WHILE m_ IS NOT NULL LOOP
               Attach_Reservation___(handling_unit_id_        => new_handling_unit_id_,
                                     handling_unit_type_id_to_pack_ => handling_unit_type_id_to_pack_,
                                     shipment_id_             => reservations_to_pack_tab_(m_).shipment_id,
                                     shipment_line_no_        => reservations_to_pack_tab_(m_).shipment_line_no,
                                     source_ref1_             => reservations_to_pack_tab_(m_).source_ref1,
                                     source_ref2_             => reservations_to_pack_tab_(m_).source_ref2,
                                     source_ref3_             => reservations_to_pack_tab_(m_).source_ref3,
                                     source_ref4_             => reservations_to_pack_tab_(m_).source_ref4,
                                     contract_                => reservations_to_pack_tab_(m_).contract, 
                                     part_no_                 => reservations_to_pack_tab_(m_).part_no, 
                                     location_no_             => reservations_to_pack_tab_(m_).location_no,
                                     lot_batch_no_            => reservations_to_pack_tab_(m_).lot_batch_no,
                                     serial_no_               => reservations_to_pack_tab_(m_).serial_no, 
                                     eng_chg_level_           => reservations_to_pack_tab_(m_).eng_chg_level, 
                                     waiv_dev_rej_no_         => reservations_to_pack_tab_(m_).waiv_dev_rej_no, 
                                     activity_seq_            => reservations_to_pack_tab_(m_).activity_seq, 
                                     reserv_handling_unit_id_ => NVL(reservations_to_pack_tab_(m_).handling_unit_id, 0), 
                                     configuration_id_        => reservations_to_pack_tab_(m_).configuration_id,
                                     pick_list_no_            => reservations_to_pack_tab_(m_).pick_list_no, 
                                     quantity_to_be_added_    => reservations_to_pack_tab_(m_).qty_to_pack,
                                     catch_qty_to_reassign_   => reservations_to_pack_tab_(m_).catch_qty,
                                     inverted_conv_factor_    => reservations_to_pack_tab_(m_).inverted_conv_factor,
                                     conv_factor_             => reservations_to_pack_tab_(m_).conv_factor);
               m_ := reservations_to_pack_tab_.NEXT(m_);
            END LOOP;
         END IF;
      ELSE                  
         IF orders_tab_.COUNT = 0 THEN
            OPEN get_orders_to_pack(ship_pick_res_group_rec_.pick_list_no, excl_fully_reserved_hu_);
            FETCH get_orders_to_pack BULK COLLECT INTO orders_tab_;
            CLOSE get_orders_to_pack;
         END IF;
         
         Pack_By_Source_Object___ (reservations_to_pack_tab_, ship_pick_res_group_rec_, orders_tab_, parts_tab_, proposal_hu_types_tab_, 
                                   comp_uom_for_volume_, comp_uom_for_weight_, comp_uom_for_length_, pack_by_reservation_line_, 
                                   pack_by_piece_, allow_mix_source_object_, biggest_handling_unit_type_, biggest_hu_type_vol_, biggest_hu_type_weight_,
                                   biggest_hu_type_width_, biggest_hu_type_height_, biggest_hu_type_depth_);
         
      END IF;
   END IF;
END Do_Pack_Acc_Pack_Proposal___;


-- Finds the smallest possible handling unit to fit parts into.
PROCEDURE Get_Packable_Hu_Type_Id___ (
   handling_unit_type_id_to_pack_   OUT VARCHAR2,
   hu_type_operative_vol_           OUT NUMBER,
   hu_type_operative_weight_        OUT NUMBER,
   hu_type_width_                   OUT NUMBER,
   hu_type_height_                  OUT NUMBER,
   hu_type_depth_                   OUT NUMBER,
   volume_to_pack_                  IN NUMBER,
   weight_to_pack_                  IN NUMBER,
   width_to_pack_                   IN NUMBER,
   height_to_pack_                  IN NUMBER,
   depth_to_pack_                   IN NUMBER,
   proposal_hu_types_tab_           IN Handling_Unit_Type_Tab,
   comp_uom_for_volume_             IN VARCHAR2,
   comp_uom_for_weight_             IN VARCHAR2,
   comp_uom_for_length_             IN VARCHAR2)
IS
BEGIN
   FOR k_ IN proposal_hu_types_tab_.FIRST..proposal_hu_types_tab_.LAST LOOP
      IF comp_uom_for_volume_ = proposal_hu_types_tab_(k_).uom_for_volume AND 
         comp_uom_for_weight_ = proposal_hu_types_tab_(k_).uom_for_weight AND 
         comp_uom_for_length_ = proposal_hu_types_tab_(k_).uom_for_length THEN
         hu_type_operative_vol_     := proposal_hu_types_tab_(k_).operative_volume_utilization;
         hu_type_operative_weight_  := proposal_hu_types_tab_(k_).max_weight_capacity;
         hu_type_width_             := proposal_hu_types_tab_(k_).width;
         hu_type_height_            := proposal_hu_types_tab_(k_).height;
         hu_type_depth_             := proposal_hu_types_tab_(k_).depth;
      ELSE
         hu_type_operative_vol_    := Iso_Unit_API.Get_Unit_Converted_Quantity(proposal_hu_types_tab_(k_).operative_volume_utilization,
                                                                               proposal_hu_types_tab_(k_).uom_for_volume,
                                                                               comp_uom_for_volume_);
         hu_type_operative_weight_ := Iso_Unit_API.Get_Unit_Converted_Quantity(proposal_hu_types_tab_(k_).max_weight_capacity,
                                                                               proposal_hu_types_tab_(k_).uom_for_weight,
                                                                               comp_uom_for_weight_);
         hu_type_width_            := Iso_Unit_API.Get_Unit_Converted_Quantity(proposal_hu_types_tab_(k_).width,
                                                                               proposal_hu_types_tab_(k_).uom_for_length,
                                                                               comp_uom_for_length_);
         hu_type_height_           := Iso_Unit_API.Get_Unit_Converted_Quantity(proposal_hu_types_tab_(k_).height,
                                                                               proposal_hu_types_tab_(k_).uom_for_length,
                                                                               comp_uom_for_length_);
         hu_type_depth_            := Iso_Unit_API.Get_Unit_Converted_Quantity(proposal_hu_types_tab_(k_).depth,
                                                                               proposal_hu_types_tab_(k_).uom_for_length,
                                                                               comp_uom_for_length_);
      END IF;
      IF volume_to_pack_ <= hu_type_operative_vol_ AND weight_to_pack_ <= hu_type_operative_weight_
         AND Check_Packable_By_Dimension_(width_to_pack_, height_to_pack_, depth_to_pack_, hu_type_width_, hu_type_height_, hu_type_depth_) = 'TRUE' THEN
         handling_unit_type_id_to_pack_ := proposal_hu_types_tab_(k_).handling_unit_type_id;
         EXIT;
      END IF;
   END LOOP;
END Get_Packable_Hu_Type_Id___;


PROCEDURE Pack_By_Source_Object___ (
   reservations_to_pack_tab_        IN OUT Reservations_To_Pack_Tab,
   ship_pick_res_group_rec_         IN OUT Ship_Pick_Res_Group_Rec,
   orders_tab_                      IN OUT Orders_Tab,
   parts_tab_                       IN OUT Parts_Tab,
   proposal_hu_types_tab_           IN Handling_Unit_Type_Tab,
   comp_uom_for_volume_             IN VARCHAR2,
   comp_uom_for_weight_             IN VARCHAR2,
   comp_uom_for_length_             IN VARCHAR2,
   pack_by_reservation_line_        IN VARCHAR2,
   pack_by_piece_                   IN VARCHAR2,
   allow_mix_source_object_         IN VARCHAR2,
   biggest_handling_unit_type_      IN VARCHAR2,
   biggest_hu_type_vol_             IN NUMBER,
   biggest_hu_type_weight_          IN NUMBER,
   biggest_hu_type_width_           IN NUMBER,
   biggest_hu_type_height_          IN NUMBER,
   biggest_hu_type_depth_           IN NUMBER
)
IS
   packable_reservation_available_  BOOLEAN;
   new_handling_unit_id_            NUMBER := 0;
   m_                               PLS_INTEGER;
   hu_type_remaining_volume_        NUMBER;
   hu_type_remaining_weight_        NUMBER;
   hu_type_width_                   NUMBER;
   hu_type_height_                  NUMBER;
   hu_type_depth_                   NUMBER;
   packable_qty_                    NUMBER;
   handling_unit_type_id_to_pack_   VARCHAR2(25);
   temp_pack_res_available_         BOOLEAN := FALSE;
   biggest_part_for_order_          Part_Rec;
BEGIN
   -- Mix small orders or never mix order methods
   IF allow_mix_source_object_ != Mix_Source_Object_API.DB_ALWAYS THEN
      FOR j_ IN orders_tab_.FIRST..orders_tab_.LAST LOOP
         IF orders_tab_(j_).order_volume > biggest_hu_type_vol_ OR orders_tab_(j_).order_weight > biggest_hu_type_weight_ 
            OR allow_mix_source_object_ = Mix_Source_Object_API.DB_NEVER THEN
            packable_reservation_available_ := TRUE;
            WHILE packable_reservation_available_ LOOP
               packable_reservation_available_ := FALSE;
               handling_unit_type_id_to_pack_ := NULL;
               
               -- Find biggest part for order
               FOR i_ IN parts_tab_.FIRST..parts_tab_.LAST LOOP
                  IF NOT parts_tab_.EXISTS(i_) THEN
                     CONTINUE;
                  END IF;
                  IF parts_tab_(i_).source_ref1 = orders_tab_(j_).source_ref1 AND parts_tab_(i_).source_ref_type_db = orders_tab_(j_).source_ref_type_db THEN
                     biggest_part_for_order_ := parts_tab_(i_);
                     EXIT;
                  END IF;
               END LOOP;
               
               -- Check if complete order fits any handling unit
               Get_Packable_Hu_Type_Id___(handling_unit_type_id_to_pack_, hu_type_remaining_volume_, hu_type_remaining_weight_, hu_type_width_, hu_type_height_, hu_type_depth_, 
                                          orders_tab_(j_).order_volume, orders_tab_(j_).order_weight, biggest_part_for_order_.storage_width_requirement, biggest_part_for_order_.storage_height_requirement, 
                                          biggest_part_for_order_.storage_depth_requirement, proposal_hu_types_tab_, comp_uom_for_volume_, comp_uom_for_weight_, 
                                          comp_uom_for_length_);
                                          
               IF handling_unit_type_id_to_pack_ IS NULL THEN                  
                  Pack_By_Reservation___(packable_reservation_available_, reservations_to_pack_tab_, ship_pick_res_group_rec_, orders_tab_, parts_tab_,
                                         new_handling_unit_id_, hu_type_remaining_volume_, hu_type_remaining_weight_, pack_by_reservation_line_, 
                                         pack_by_piece_, allow_mix_source_object_, biggest_handling_unit_type_, biggest_hu_type_vol_, 
                                         biggest_hu_type_weight_, orders_tab_(j_).source_ref1, orders_tab_(j_).source_ref_type_db);
                  
                  -- Find biggest part for order
                  IF orders_tab_(j_).order_volume != 0 AND orders_tab_(j_).order_weight != 0 AND parts_tab_.COUNT > 0 THEN
                     FOR i_ IN parts_tab_.FIRST..parts_tab_.LAST LOOP
                        IF NOT parts_tab_.EXISTS(i_) THEN
                           CONTINUE;
                        END IF;
                        IF parts_tab_(i_).source_ref1 = orders_tab_(j_).source_ref1 AND parts_tab_(i_).source_ref_type_db = orders_tab_(j_).source_ref_type_db THEN
                           biggest_part_for_order_ := parts_tab_(i_);
                           EXIT;
                        END IF;
                     END LOOP;
                     
                     -- Check if remaining reservations in order fit in any handling unit
                     packable_qty_      := LEAST(FLOOR(biggest_hu_type_vol_ / orders_tab_(j_).order_volume), FLOOR(biggest_hu_type_weight_ / orders_tab_(j_).order_weight));
                     IF packable_qty_ >= 1 AND pack_by_reservation_line_ = 'FALSE' AND pack_by_piece_ = 'FALSE' 
                        AND Get_Packable_Hu_Type_Id_(orders_tab_(j_).order_volume, orders_tab_(j_).order_weight, biggest_part_for_order_.storage_width_requirement, 
                        biggest_part_for_order_.storage_height_requirement, biggest_part_for_order_.storage_depth_requirement, 
                        proposal_hu_types_tab_, comp_uom_for_volume_, comp_uom_for_weight_, comp_uom_for_length_) IS NOT NULL THEN
                        packable_reservation_available_ := TRUE;
                     END IF;
                  END IF;
               ELSE
                  -- All reservations in order fit
                  m_ := reservations_to_pack_tab_.FIRST;
                  WHILE m_ IS NOT NULL LOOP
                     IF reservations_to_pack_tab_(m_).source_ref1 = orders_tab_(j_).source_ref1
                        AND reservations_to_pack_tab_(m_).source_ref_type_db = orders_tab_(j_).source_ref_type_db THEN
                        Attach_Reservation___(handling_unit_id_        => new_handling_unit_id_,
                                              handling_unit_type_id_to_pack_ => handling_unit_type_id_to_pack_,
                                              shipment_id_             => reservations_to_pack_tab_(m_).shipment_id,
                                              shipment_line_no_        => reservations_to_pack_tab_(m_).shipment_line_no,
                                              source_ref1_             => reservations_to_pack_tab_(m_).source_ref1,
                                              source_ref2_             => reservations_to_pack_tab_(m_).source_ref2,
                                              source_ref3_             => reservations_to_pack_tab_(m_).source_ref3,
                                              source_ref4_             => reservations_to_pack_tab_(m_).source_ref4,
                                              contract_                => reservations_to_pack_tab_(m_).contract, 
                                              part_no_                 => reservations_to_pack_tab_(m_).part_no, 
                                              location_no_             => reservations_to_pack_tab_(m_).location_no,
                                              lot_batch_no_            => reservations_to_pack_tab_(m_).lot_batch_no,
                                              serial_no_               => reservations_to_pack_tab_(m_).serial_no, 
                                              eng_chg_level_           => reservations_to_pack_tab_(m_).eng_chg_level, 
                                              waiv_dev_rej_no_         => reservations_to_pack_tab_(m_).waiv_dev_rej_no, 
                                              activity_seq_            => reservations_to_pack_tab_(m_).activity_seq, 
                                              reserv_handling_unit_id_ => NVL(reservations_to_pack_tab_(m_).handling_unit_id, 0), 
                                              configuration_id_        => reservations_to_pack_tab_(m_).configuration_id,
                                              pick_list_no_            => reservations_to_pack_tab_(m_).pick_list_no, 
                                              quantity_to_be_added_    => reservations_to_pack_tab_(m_).qty_to_pack,
                                              catch_qty_to_reassign_   => reservations_to_pack_tab_(m_).catch_qty,
                                              inverted_conv_factor_    => reservations_to_pack_tab_(m_).inverted_conv_factor,
                                              conv_factor_             => reservations_to_pack_tab_(m_).conv_factor);
                        hu_type_remaining_volume_     := hu_type_remaining_volume_ - (reservations_to_pack_tab_(m_).qty_to_pack * reservations_to_pack_tab_(m_).part_volume);
                        hu_type_remaining_weight_  := hu_type_remaining_weight_ - (reservations_to_pack_tab_(m_).qty_to_pack * reservations_to_pack_tab_(m_).part_weight);
                        ship_pick_res_group_rec_.total_volume := ship_pick_res_group_rec_.total_volume - (reservations_to_pack_tab_(m_).qty_to_pack * reservations_to_pack_tab_(m_).part_volume);
                        ship_pick_res_group_rec_.total_weight := ship_pick_res_group_rec_.total_weight - (reservations_to_pack_tab_(m_).qty_to_pack * reservations_to_pack_tab_(m_).part_weight);
                        reservations_to_pack_tab_.DELETE(m_);
                     END IF;
                     m_ := reservations_to_pack_tab_.NEXT(m_);
                  END LOOP;
                  packable_reservation_available_ := FALSE;
               END IF;
               new_handling_unit_id_ := 0;
            END LOOP;
            m_ := reservations_to_pack_tab_.FIRST;
            WHILE m_ IS NOT NULL LOOP
               IF reservations_to_pack_tab_(m_).source_ref1 = orders_tab_(j_).source_ref1
                  AND reservations_to_pack_tab_(m_).source_ref_type_db = orders_tab_(j_).source_ref_type_db THEN
                  ship_pick_res_group_rec_.total_volume := ship_pick_res_group_rec_.total_volume - (reservations_to_pack_tab_(m_).qty_to_pack * reservations_to_pack_tab_(m_).part_volume);
                  ship_pick_res_group_rec_.total_weight := ship_pick_res_group_rec_.total_weight - (reservations_to_pack_tab_(m_).qty_to_pack * reservations_to_pack_tab_(m_).part_weight);
                  reservations_to_pack_tab_.DELETE(m_);
               END IF;
               m_ := reservations_to_pack_tab_.NEXT(m_);
            END LOOP;
            orders_tab_.DELETE(j_);
         ELSIF orders_tab_(j_).order_volume <= biggest_hu_type_vol_ AND orders_tab_(j_).order_weight <= biggest_hu_type_weight_ THEN
            packable_reservation_available_ := TRUE;
            EXIT;
         END IF;
      END LOOP;
   END IF;
   
   -- Mix small orders or mix always methods
   IF allow_mix_source_object_ != Mix_Source_Object_API.DB_NEVER THEN
      IF allow_mix_source_object_ = Mix_Source_Object_API.DB_ALWAYS THEN
         packable_reservation_available_ := TRUE;
      END IF;
      WHILE packable_reservation_available_ LOOP
         handling_unit_type_id_to_pack_ := NULL;
         packable_reservation_available_ := FALSE;
         temp_pack_res_available_ := packable_reservation_available_;
         new_handling_unit_id_ := 0;
         
         Get_Packable_Hu_Type_Id___(handling_unit_type_id_to_pack_, hu_type_remaining_volume_, hu_type_remaining_weight_, hu_type_width_, hu_type_height_, hu_type_depth_, 
                                    ship_pick_res_group_rec_.total_volume, ship_pick_res_group_rec_.total_weight, parts_tab_(parts_tab_.FIRST).storage_width_requirement, parts_tab_(parts_tab_.FIRST).storage_height_requirement, 
                                    parts_tab_(parts_tab_.FIRST).storage_depth_requirement, proposal_hu_types_tab_, comp_uom_for_volume_, comp_uom_for_weight_, 
                                    comp_uom_for_length_);
         
         IF handling_unit_type_id_to_pack_ IS NULL THEN
            hu_type_remaining_volume_    := biggest_hu_type_vol_;
            hu_type_remaining_weight_ := biggest_hu_type_weight_;
            
            FOR j_ IN orders_tab_.FIRST..orders_tab_.LAST LOOP
               --Find biggest part for order
               FOR i_ IN parts_tab_.FIRST..parts_tab_.LAST LOOP
                  IF NOT parts_tab_.EXISTS(i_) THEN
                     CONTINUE;
                  END IF;
                  IF parts_tab_(i_).source_ref1 = orders_tab_(j_).source_ref1 AND parts_tab_(i_).source_ref_type_db = orders_tab_(j_).source_ref_type_db THEN
                     biggest_part_for_order_ := parts_tab_(i_);
                     EXIT;
                  END IF;
               END LOOP;
               
               -- Check if order fits biggest handling unit type
               IF orders_tab_(j_).order_volume <= hu_type_remaining_volume_ AND orders_tab_(j_).order_weight <= hu_type_remaining_weight_ 
                  AND Check_Packable_By_Dimension_(biggest_part_for_order_.storage_width_requirement, biggest_part_for_order_.storage_height_requirement, biggest_part_for_order_.storage_depth_requirement, 
                                        biggest_hu_type_width_, biggest_hu_type_height_, biggest_hu_type_depth_) = 'TRUE' THEN
                  m_ := reservations_to_pack_tab_.FIRST;
                  WHILE m_ IS NOT NULL LOOP
                     IF reservations_to_pack_tab_(m_).source_ref1 = orders_tab_(j_).source_ref1
                        AND reservations_to_pack_tab_(m_).source_ref_type_db = orders_tab_(j_).source_ref_type_db THEN
                        Attach_Reservation___(handling_unit_id_        => new_handling_unit_id_,
                                              handling_unit_type_id_to_pack_ => biggest_handling_unit_type_,
                                              shipment_id_             => reservations_to_pack_tab_(m_).shipment_id,
                                              shipment_line_no_        => reservations_to_pack_tab_(m_).shipment_line_no,
                                              source_ref1_             => reservations_to_pack_tab_(m_).source_ref1,
                                              source_ref2_             => reservations_to_pack_tab_(m_).source_ref2,
                                              source_ref3_             => reservations_to_pack_tab_(m_).source_ref3,
                                              source_ref4_             => reservations_to_pack_tab_(m_).source_ref4,
                                              contract_                => reservations_to_pack_tab_(m_).contract, 
                                              part_no_                 => reservations_to_pack_tab_(m_).part_no, 
                                              location_no_             => reservations_to_pack_tab_(m_).location_no,
                                              lot_batch_no_            => reservations_to_pack_tab_(m_).lot_batch_no,
                                              serial_no_               => reservations_to_pack_tab_(m_).serial_no, 
                                              eng_chg_level_           => reservations_to_pack_tab_(m_).eng_chg_level, 
                                              waiv_dev_rej_no_         => reservations_to_pack_tab_(m_).waiv_dev_rej_no, 
                                              activity_seq_            => reservations_to_pack_tab_(m_).activity_seq, 
                                              reserv_handling_unit_id_ => NVL(reservations_to_pack_tab_(m_).handling_unit_id, 0), 
                                              configuration_id_        => reservations_to_pack_tab_(m_).configuration_id,
                                              pick_list_no_            => reservations_to_pack_tab_(m_).pick_list_no, 
                                              quantity_to_be_added_    => reservations_to_pack_tab_(m_).qty_to_pack,
                                              catch_qty_to_reassign_   => reservations_to_pack_tab_(m_).catch_qty,
                                              inverted_conv_factor_    => reservations_to_pack_tab_(m_).inverted_conv_factor,
                                              conv_factor_             => reservations_to_pack_tab_(m_).conv_factor);
                        hu_type_remaining_volume_     := hu_type_remaining_volume_ - (reservations_to_pack_tab_(m_).qty_to_pack * reservations_to_pack_tab_(m_).part_volume);
                        hu_type_remaining_weight_  := hu_type_remaining_weight_ - (reservations_to_pack_tab_(m_).qty_to_pack * reservations_to_pack_tab_(m_).part_weight);
                        ship_pick_res_group_rec_.total_volume := ship_pick_res_group_rec_.total_volume - (reservations_to_pack_tab_(m_).qty_to_pack * reservations_to_pack_tab_(m_).part_volume);
                        ship_pick_res_group_rec_.total_weight := ship_pick_res_group_rec_.total_weight - (reservations_to_pack_tab_(m_).qty_to_pack * reservations_to_pack_tab_(m_).part_weight);
                        reservations_to_pack_tab_.DELETE(m_);
                     END IF;
                     m_ := reservations_to_pack_tab_.NEXT(m_);
                  END LOOP;
               ELSE
                  -- Check if remaining reservations in order fit in any handling unit
                  IF orders_tab_(j_).order_volume != 0 AND orders_tab_(j_).order_weight != 0 AND parts_tab_.COUNT > 0 THEN
                     packable_qty_      := LEAST(FLOOR(biggest_hu_type_vol_ / orders_tab_(j_).order_volume), FLOOR(biggest_hu_type_weight_ / orders_tab_(j_).order_weight));
                     handling_unit_type_id_to_pack_ := Get_Packable_Hu_Type_Id_(orders_tab_(j_).order_volume, orders_tab_(j_).order_weight, 
                                                                                biggest_part_for_order_.storage_width_requirement, biggest_part_for_order_.storage_height_requirement, 
                                                                                biggest_part_for_order_.storage_depth_requirement, proposal_hu_types_tab_, comp_uom_for_volume_, comp_uom_for_weight_, comp_uom_for_length_);
                     IF packable_qty_ >= 1 AND pack_by_reservation_line_ = 'FALSE' AND pack_by_piece_ = 'FALSE' 
                        AND handling_unit_type_id_to_pack_ IS NOT NULL THEN
                        packable_reservation_available_ := TRUE;
                     END IF;
                  END IF;
               END IF;
            END LOOP;
            -- Do pack by reservation and pack by piece methods per order
            IF pack_by_reservation_line_ = 'TRUE' OR pack_by_piece_ = 'TRUE' THEN
               FOR j_ IN orders_tab_.FIRST..orders_tab_.LAST LOOP
                  Pack_By_Reservation___(packable_reservation_available_, reservations_to_pack_tab_, ship_pick_res_group_rec_, orders_tab_, parts_tab_,
                                         new_handling_unit_id_, hu_type_remaining_volume_, hu_type_remaining_weight_, pack_by_reservation_line_, 
                                         pack_by_piece_, allow_mix_source_object_, biggest_handling_unit_type_, biggest_hu_type_vol_, 
                                         biggest_hu_type_weight_, orders_tab_(j_).source_ref1, orders_tab_(j_).source_ref_type_db);
                  IF packable_reservation_available_ THEN
                     temp_pack_res_available_ := packable_reservation_available_;
                  END IF;
               END LOOP;
               IF temp_pack_res_available_ THEN
                  packable_reservation_available_ := temp_pack_res_available_;
               END IF;
               
               -- Check if remaining reservations in picklist fit in any handling unit
               IF parts_tab_.COUNT > 0 THEN
                  IF Get_Packable_Hu_Type_Id_(ship_pick_res_group_rec_.total_volume, ship_pick_res_group_rec_.total_weight, parts_tab_(parts_tab_.FIRST).storage_width_requirement, parts_tab_(parts_tab_.FIRST).storage_height_requirement, 
                                              parts_tab_(parts_tab_.FIRST).storage_depth_requirement, proposal_hu_types_tab_, comp_uom_for_volume_, comp_uom_for_weight_, 
                                              comp_uom_for_length_) IS NOT NULL THEN
                     packable_reservation_available_ := TRUE;
                  END IF;
               END IF;
            END IF;
         ELSE
            -- All reservations in pick list fit
            packable_reservation_available_ :=  FALSE;
            m_ := reservations_to_pack_tab_.FIRST;
            WHILE m_ IS NOT NULL LOOP
               Attach_Reservation___(handling_unit_id_        => new_handling_unit_id_,
                                     handling_unit_type_id_to_pack_ => handling_unit_type_id_to_pack_,
                                     shipment_id_             => reservations_to_pack_tab_(m_).shipment_id,
                                     shipment_line_no_        => reservations_to_pack_tab_(m_).shipment_line_no,
                                     source_ref1_             => reservations_to_pack_tab_(m_).source_ref1,
                                     source_ref2_             => reservations_to_pack_tab_(m_).source_ref2,
                                     source_ref3_             => reservations_to_pack_tab_(m_).source_ref3,
                                     source_ref4_             => reservations_to_pack_tab_(m_).source_ref4,
                                     contract_                => reservations_to_pack_tab_(m_).contract, 
                                     part_no_                 => reservations_to_pack_tab_(m_).part_no, 
                                     location_no_             => reservations_to_pack_tab_(m_).location_no,
                                     lot_batch_no_            => reservations_to_pack_tab_(m_).lot_batch_no,
                                     serial_no_               => reservations_to_pack_tab_(m_).serial_no, 
                                     eng_chg_level_           => reservations_to_pack_tab_(m_).eng_chg_level, 
                                     waiv_dev_rej_no_         => reservations_to_pack_tab_(m_).waiv_dev_rej_no, 
                                     activity_seq_            => reservations_to_pack_tab_(m_).activity_seq, 
                                     reserv_handling_unit_id_ => NVL(reservations_to_pack_tab_(m_).handling_unit_id, 0), 
                                     configuration_id_        => reservations_to_pack_tab_(m_).configuration_id,
                                     pick_list_no_            => reservations_to_pack_tab_(m_).pick_list_no, 
                                     quantity_to_be_added_    => reservations_to_pack_tab_(m_).qty_to_pack,
                                     catch_qty_to_reassign_   => reservations_to_pack_tab_(m_).catch_qty,
                                     inverted_conv_factor_    => reservations_to_pack_tab_(m_).inverted_conv_factor,
                                     conv_factor_             => reservations_to_pack_tab_(m_).conv_factor);
               m_ := reservations_to_pack_tab_.NEXT(m_);
            END LOOP;
         END IF;
      END LOOP;
   END IF;
END Pack_By_Source_Object___;


-- This method will handle the packing by reservation and pack by piece logic.
PROCEDURE Pack_By_Reservation___ (
   packable_reservation_available_  OUT BOOLEAN,
   reservations_to_pack_tab_        IN OUT Reservations_To_Pack_Tab,
   ship_pick_res_group_rec_         IN OUT Ship_Pick_Res_Group_Rec,
   orders_tab_                      IN OUT Orders_Tab,
   parts_tab_                       IN OUT Parts_Tab,
   new_handling_unit_id_            IN OUT NUMBER,
   remaining_hu_vol_                IN OUT NUMBER,
   remaining_hu_weight_             IN OUT NUMBER,
   pack_by_reservation_line_        IN VARCHAR2,
   pack_by_piece_                   IN VARCHAR2,
   allow_mix_source_object_         IN VARCHAR2,
   biggest_handling_unit_type_      IN VARCHAR2,
   biggest_hu_type_vol_             IN NUMBER,
   biggest_hu_type_weight_          IN NUMBER,
   source_ref1_                     IN VARCHAR2,
   source_ref_type_db_              IN VARCHAR2)
IS
   part_volume_                  NUMBER;
   part_weight_                  NUMBER;
   part_width_                   NUMBER;
   part_height_                  NUMBER;
   part_depth_                   NUMBER;
   reservation_volume_           NUMBER;
   reservation_weight_           NUMBER;
   packable_qty_                 NUMBER;
   m_                            PLS_INTEGER;
   do_pack_by_reservation_       BOOLEAN;
   do_pack_by_piece_             BOOLEAN;
   fits_biggest_hu_type_         BOOLEAN;
   part_packable_                BOOLEAN;
BEGIN
   do_pack_by_reservation_    := pack_by_reservation_line_ = 'TRUE';
   do_pack_by_piece_          := pack_by_piece_ = 'TRUE';
   
   -- If a handling unit doesn't exist, use biggest handling unit type values.
   IF new_handling_unit_id_ = 0 THEN
      remaining_hu_vol_    := biggest_hu_type_vol_;
      remaining_hu_weight_ := biggest_hu_type_weight_;
   END IF;
   
   WHILE do_pack_by_piece_ OR do_pack_by_reservation_ LOOP   
      packable_reservation_available_ := FALSE;
      
      m_ := reservations_to_pack_tab_.FIRST;
      WHILE m_ IS NOT NULL LOOP 
         IF source_ref1_ IS NOT NULL AND source_ref_type_db_ IS NOT NULL THEN 
            IF reservations_to_pack_tab_(m_).source_ref1 != source_ref1_ OR reservations_to_pack_tab_(m_).source_ref_type_db != source_ref_type_db_ THEN
               m_ := reservations_to_pack_tab_.NEXT(m_);
               IF m_ IS NULL THEN
                  IF NOT do_pack_by_reservation_ THEN
                     do_pack_by_piece_ := FALSE;
                  END IF;
               
                  do_pack_by_reservation_ := FALSE;
               END IF;
               CONTINUE;
            END IF;
         END IF;

         part_volume_          := reservations_to_pack_tab_(m_).part_volume;
         part_weight_          := reservations_to_pack_tab_(m_).part_weight;
         part_width_           := reservations_to_pack_tab_(m_).storage_width_requirement;
         part_height_          := reservations_to_pack_tab_(m_).storage_height_requirement;
         part_depth_           := reservations_to_pack_tab_(m_).storage_depth_requirement;
         reservation_volume_   := reservations_to_pack_tab_(m_).qty_to_pack * part_volume_;
         reservation_weight_   := reservations_to_pack_tab_(m_).qty_to_pack * part_weight_;
         part_packable_        := FALSE;
         fits_biggest_hu_type_ := FALSE;
         
         IF parts_tab_.COUNT > 0 THEN
            FOR p_ IN parts_tab_.FIRST..parts_tab_.LAST LOOP
               IF NOT(parts_tab_.EXISTS(p_)) THEN
                  CONTINUE;
               END IF;
               IF parts_tab_(p_).source_ref1 = reservations_to_pack_tab_(m_).source_ref1 
                  AND parts_tab_(p_).source_ref_type_db = reservations_to_pack_tab_(m_).source_ref_type_db 
                  AND parts_tab_(p_).contract = reservations_to_pack_tab_(m_).contract
                  AND parts_tab_(p_).part_no = reservations_to_pack_tab_(m_).part_no THEN
                  part_packable_ := parts_tab_(p_).smallest_packable_hu_type IS NOT NULL;
                  fits_biggest_hu_type_ := parts_tab_(p_).fits_biggest_hu_type = 'TRUE';
                  
                  IF NOT part_packable_ THEN
                     ship_pick_res_group_rec_.total_volume := ship_pick_res_group_rec_.total_volume - (reservations_to_pack_tab_(m_).qty_to_pack * part_volume_);
                     ship_pick_res_group_rec_.total_weight := ship_pick_res_group_rec_.total_weight - (reservations_to_pack_tab_(m_).qty_to_pack * part_weight_);
                     IF source_ref1_ IS NOT NULL AND source_ref_type_db_ IS NOT NULL THEN 
                        FOR n_ IN orders_tab_.FIRST..orders_tab_.LAST LOOP
                           IF NOT(orders_tab_.EXISTS(n_)) THEN
                              CONTINUE;
                           END IF;
                           IF orders_tab_(n_).source_ref1 = reservations_to_pack_tab_(m_).source_ref1 
                              AND orders_tab_(n_).source_ref_type_db = reservations_to_pack_tab_(m_).source_ref_type_db THEN
                              orders_tab_(n_).order_volume := orders_tab_(n_).order_volume - (reservations_to_pack_tab_(m_).qty_to_pack * part_volume_);
                              orders_tab_(n_).order_weight := orders_tab_(n_).order_weight - (reservations_to_pack_tab_(m_).qty_to_pack * part_weight_);
                           END IF;
                        END LOOP;
                     END IF;
                     parts_tab_(p_).qty_to_pack := parts_tab_(p_).qty_to_pack - reservations_to_pack_tab_(m_).qty_to_pack;
                     IF parts_tab_(p_).qty_to_pack = 0 THEN
                        parts_tab_.DELETE(p_);
                     END IF;
                     reservations_to_pack_tab_.DELETE(m_);
                  END IF;
                  EXIT;
               END IF;
            END LOOP;
         END IF;
         
         IF NOT fits_biggest_hu_type_ OR NOT part_packable_ THEN
            m_ := reservations_to_pack_tab_.NEXT(m_);
            IF m_ IS NULL THEN
               IF NOT do_pack_by_reservation_ THEN
                  do_pack_by_piece_ := FALSE;
               END IF;
            
               do_pack_by_reservation_ := FALSE;
            END IF;
            CONTINUE;
         END IF;
         
         IF reservation_volume_ <= remaining_hu_vol_ AND reservation_weight_ <= remaining_hu_weight_ THEN
            Attach_Reservation___(handling_unit_id_        => new_handling_unit_id_,
                                  handling_unit_type_id_to_pack_ => biggest_handling_unit_type_,
                                  shipment_id_             => reservations_to_pack_tab_(m_).shipment_id,
                                  shipment_line_no_        => reservations_to_pack_tab_(m_).shipment_line_no,
                                  source_ref1_             => reservations_to_pack_tab_(m_).source_ref1,
                                  source_ref2_             => reservations_to_pack_tab_(m_).source_ref2,
                                  source_ref3_             => reservations_to_pack_tab_(m_).source_ref3,
                                  source_ref4_             => reservations_to_pack_tab_(m_).source_ref4,
                                  contract_                => reservations_to_pack_tab_(m_).contract, 
                                  part_no_                 => reservations_to_pack_tab_(m_).part_no, 
                                  location_no_             => reservations_to_pack_tab_(m_).location_no,
                                  lot_batch_no_            => reservations_to_pack_tab_(m_).lot_batch_no,
                                  serial_no_               => reservations_to_pack_tab_(m_).serial_no, 
                                  eng_chg_level_           => reservations_to_pack_tab_(m_).eng_chg_level, 
                                  waiv_dev_rej_no_         => reservations_to_pack_tab_(m_).waiv_dev_rej_no, 
                                  activity_seq_            => reservations_to_pack_tab_(m_).activity_seq, 
                                  reserv_handling_unit_id_ => NVL(reservations_to_pack_tab_(m_).handling_unit_id, 0), 
                                  configuration_id_        => reservations_to_pack_tab_(m_).configuration_id,
                                  pick_list_no_            => reservations_to_pack_tab_(m_).pick_list_no, 
                                  quantity_to_be_added_    => reservations_to_pack_tab_(m_).qty_to_pack,
                                  catch_qty_to_reassign_   => reservations_to_pack_tab_(m_).catch_qty,
                                  inverted_conv_factor_    => reservations_to_pack_tab_(m_).inverted_conv_factor,
                                  conv_factor_             => reservations_to_pack_tab_(m_).conv_factor);
            
            
            Update_Reservation_Rec___(reservations_to_pack_tab_(m_), ship_pick_res_group_rec_, orders_tab_, parts_tab_, remaining_hu_vol_, 
                                      remaining_hu_weight_, source_ref1_, source_ref_type_db_, reservations_to_pack_tab_(m_).qty_to_pack);
            reservations_to_pack_tab_.DELETE(m_);
         ELSE
            packable_qty_    := LEAST(FLOOR(remaining_hu_vol_ / part_volume_), FLOOR(remaining_hu_weight_ / part_weight_));
            IF packable_qty_ >= 1 AND do_pack_by_piece_ THEN 
               packable_reservation_available_ := TRUE;
               
               -- Do pack by piece only when pack by reservation method has been completed
               IF do_pack_by_piece_ AND NOT do_pack_by_reservation_ THEN
                  Attach_Reservation___(handling_unit_id_        => new_handling_unit_id_,
                                        handling_unit_type_id_to_pack_ => biggest_handling_unit_type_,
                                        shipment_id_             => reservations_to_pack_tab_(m_).shipment_id,
                                        shipment_line_no_        => reservations_to_pack_tab_(m_).shipment_line_no,
                                        source_ref1_             => reservations_to_pack_tab_(m_).source_ref1,
                                        source_ref2_             => reservations_to_pack_tab_(m_).source_ref2,
                                        source_ref3_             => reservations_to_pack_tab_(m_).source_ref3,
                                        source_ref4_             => reservations_to_pack_tab_(m_).source_ref4,
                                        contract_                => reservations_to_pack_tab_(m_).contract, 
                                        part_no_                 => reservations_to_pack_tab_(m_).part_no, 
                                        location_no_             => reservations_to_pack_tab_(m_).location_no,
                                        lot_batch_no_            => reservations_to_pack_tab_(m_).lot_batch_no,
                                        serial_no_               => reservations_to_pack_tab_(m_).serial_no, 
                                        eng_chg_level_           => reservations_to_pack_tab_(m_).eng_chg_level, 
                                        waiv_dev_rej_no_         => reservations_to_pack_tab_(m_).waiv_dev_rej_no, 
                                        activity_seq_            => reservations_to_pack_tab_(m_).activity_seq, 
                                        reserv_handling_unit_id_ => NVL(reservations_to_pack_tab_(m_).handling_unit_id, 0), 
                                        configuration_id_        => reservations_to_pack_tab_(m_).configuration_id,
                                        pick_list_no_            => reservations_to_pack_tab_(m_).pick_list_no, 
                                        quantity_to_be_added_    => packable_qty_,
                                        catch_qty_to_reassign_   => reservations_to_pack_tab_(m_).catch_qty,
                                        inverted_conv_factor_    => reservations_to_pack_tab_(m_).inverted_conv_factor,
                                        conv_factor_             => reservations_to_pack_tab_(m_).conv_factor);
                  
                  Update_Reservation_Rec___(reservations_to_pack_tab_(m_), ship_pick_res_group_rec_, orders_tab_, parts_tab_, remaining_hu_vol_, 
                                            remaining_hu_weight_, source_ref1_, source_ref_type_db_, packable_qty_);
                  packable_qty_ := 0;
               END IF;
            ELSE
               -- Check if the reservation/piece will fit the biggest handling unit type when empty.
               packable_qty_      := LEAST(FLOOR(biggest_hu_type_vol_ / part_volume_), FLOOR(biggest_hu_type_weight_ / part_weight_));
               IF packable_qty_ >= 1 THEN
                  IF do_pack_by_piece_ OR (do_pack_by_reservation_ AND packable_qty_ >= reservations_to_pack_tab_(m_).qty_to_pack) THEN 
                     packable_reservation_available_ := TRUE;
                  END IF;
               END IF;
            END IF;
         END IF;
         m_ := reservations_to_pack_tab_.NEXT(m_);
         IF m_ IS NULL THEN
            IF NOT do_pack_by_reservation_ THEN
               do_pack_by_piece_ := FALSE;
            END IF;

            do_pack_by_reservation_ := FALSE;
         END IF;
      END LOOP;
      IF reservations_to_pack_tab_.COUNT = 0 THEN
         EXIT;
      END IF;
   END LOOP;
   IF source_ref1_ IS NULL AND source_ref_type_db_ IS NULL OR allow_mix_source_object_ NOT IN (Mix_Source_Object_API.DB_ALWAYS, Mix_Source_Object_API.DB_SMALL_SOURCE_OBJECTS) THEN
      new_handling_unit_id_ := 0;
   END IF;
END Pack_By_Reservation___;


-- Updates a single reservation rec from the Reservations_To_Pack_Tab and 
-- all other collections used for the Shipment Packing Proposal.
PROCEDURE Update_Reservation_Rec___ (
   reservation_to_pack_rec_         IN OUT Reservation_Rec,
   ship_pick_res_group_rec_         IN OUT Ship_Pick_Res_Group_Rec,
   orders_tab_                      IN OUT Orders_Tab,
   parts_tab_                       IN OUT Parts_Tab,
   remaining_hu_vol_                IN OUT NUMBER,
   remaining_hu_weight_             IN OUT NUMBER,
   source_ref1_                     IN VARCHAR2,
   source_ref_type_db_              IN VARCHAR2,
   qty_to_pack_                     IN NUMBER
)
IS
   part_volume_                  NUMBER;
   part_weight_                  NUMBER;
   part_width_                   NUMBER;
   part_height_                  NUMBER;
   part_depth_                   NUMBER;
   reservation_volume_           NUMBER;
   reservation_weight_           NUMBER;
BEGIN
   part_volume_          := reservation_to_pack_rec_.part_volume;
   part_weight_          := reservation_to_pack_rec_.part_weight;
   part_width_           := reservation_to_pack_rec_.storage_width_requirement;
   part_height_          := reservation_to_pack_rec_.storage_height_requirement;
   part_depth_           := reservation_to_pack_rec_.storage_depth_requirement;
   reservation_volume_   := qty_to_pack_ * part_volume_;
   reservation_weight_   := qty_to_pack_ * part_weight_;
   
   remaining_hu_vol_     := remaining_hu_vol_ - (qty_to_pack_ * part_volume_);
   remaining_hu_weight_  := remaining_hu_weight_ - (qty_to_pack_ * part_weight_);
   ship_pick_res_group_rec_.total_volume := ship_pick_res_group_rec_.total_volume - (qty_to_pack_ * part_volume_);
   ship_pick_res_group_rec_.total_weight := ship_pick_res_group_rec_.total_weight - (qty_to_pack_ * part_weight_);
   IF source_ref1_ IS NOT NULL AND source_ref_type_db_ IS NOT NULL THEN 
      FOR n_ IN orders_tab_.FIRST..orders_tab_.LAST LOOP
         IF NOT(orders_tab_.EXISTS(n_)) THEN
            CONTINUE;
         END IF;
         IF orders_tab_(n_).source_ref1 = reservation_to_pack_rec_.source_ref1 
            AND orders_tab_(n_).source_ref_type_db = reservation_to_pack_rec_.source_ref_type_db THEN
            orders_tab_(n_).order_volume := orders_tab_(n_).order_volume - (qty_to_pack_ * part_volume_);
            orders_tab_(n_).order_weight := orders_tab_(n_).order_weight - (qty_to_pack_ * part_weight_);
         END IF;
      END LOOP;
   END IF;
   FOR p_ IN parts_tab_.FIRST..parts_tab_.LAST LOOP
      IF NOT(parts_tab_.EXISTS(p_)) THEN
         CONTINUE;
      END IF;
      IF parts_tab_(p_).source_ref1 = reservation_to_pack_rec_.source_ref1 
         AND parts_tab_(p_).source_ref_type_db = reservation_to_pack_rec_.source_ref_type_db 
         AND parts_tab_(p_).contract = reservation_to_pack_rec_.contract
         AND parts_tab_(p_).part_no = reservation_to_pack_rec_.part_no THEN
         parts_tab_(p_).qty_to_pack := parts_tab_(p_).qty_to_pack - qty_to_pack_;
         IF parts_tab_(p_).qty_to_pack = 0 THEN
            parts_tab_.DELETE(p_);
         END IF;
      END IF;
   END LOOP;
   reservation_to_pack_rec_.qty_to_pack := reservation_to_pack_rec_.qty_to_pack - qty_to_pack_;
END Update_Reservation_Rec___;


PROCEDURE Attach_Reservation___ (
   handling_unit_id_                IN OUT NUMBER,
   handling_unit_type_id_to_pack_   IN VARCHAR2,
   shipment_id_                     IN NUMBER,
   shipment_line_no_                IN NUMBER,
   source_ref1_                     IN VARCHAR2,
   source_ref2_                     IN VARCHAR2,
   source_ref3_                     IN VARCHAR2,
   source_ref4_                     IN VARCHAR2,
   contract_                        IN VARCHAR2, 
   part_no_                         IN VARCHAR2, 
   location_no_                     IN VARCHAR2,
   lot_batch_no_                    IN VARCHAR2,
   serial_no_                       IN VARCHAR2, 
   eng_chg_level_                   IN VARCHAR2, 
   waiv_dev_rej_no_                 IN VARCHAR2, 
   activity_seq_                    IN NUMBER, 
   reserv_handling_unit_id_         IN NUMBER, 
   configuration_id_                IN VARCHAR2,
   pick_list_no_                    IN VARCHAR2, 
   quantity_to_be_added_            IN NUMBER,
   catch_qty_to_reassign_           IN NUMBER,
   inverted_conv_factor_            IN NUMBER,
   conv_factor_                     IN NUMBER)
IS
BEGIN
   IF handling_unit_id_ = 0 THEN
      Handling_Unit_API.New(handling_unit_id_       => handling_unit_id_,
                            handling_unit_type_id_  => handling_unit_type_id_to_pack_,
                            shipment_id_            => shipment_id_);
   END IF;
   
   Shipment_Line_Handl_Unit_API.New_Or_Add_To_Existing(shipment_id_          => shipment_id_,
                                                       shipment_line_no_     => shipment_line_no_,
                                                       handling_unit_id_     => handling_unit_id_, 
                                                       quantity_to_be_added_ => (quantity_to_be_added_ * inverted_conv_factor_ / conv_factor_));
   
   Shipment_Reserv_Handl_Unit_API.New_Or_Add_To_Existing(source_ref1_, 
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
                                                         pick_list_no_ , 
                                                         shipment_id_, 
                                                         shipment_line_no_, 
                                                         handling_unit_id_, 
                                                         quantity_to_be_added_, 
                                                         catch_qty_to_reassign_);
END Attach_Reservation___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------
FUNCTION Check_Packable_By_Dimension_ (
   width_to_pack_       IN NUMBER,
   height_to_pack_      IN NUMBER,
   depth_to_pack_       IN NUMBER,
   hu_width_            IN NUMBER,
   hu_height_           IN NUMBER,
   hu_depth_            IN NUMBER) RETURN VARCHAR2
IS
   can_pack_         VARCHAR2(5) := 'FALSE';
   max_value_        NUMBER;
   median_value_     NUMBER;
   min_value_        NUMBER;
   max_hu_value_     NUMBER;
   median_hu_value_  NUMBER;
   min_hu_value_     NUMBER;
   
BEGIN
   max_value_     := NVL(GREATEST(width_to_pack_, height_to_pack_, depth_to_pack_), 0);
   min_value_     := NVL(LEAST(width_to_pack_, height_to_pack_, depth_to_pack_), 0);
   median_value_  := NVL((width_to_pack_ + height_to_pack_ + depth_to_pack_ - max_value_ - min_value_), 0);
   
   max_hu_value_     := GREATEST(hu_width_, hu_height_, hu_depth_);
   min_hu_value_     := LEAST(hu_width_, hu_height_, hu_depth_);
   median_hu_value_  := (hu_width_ + hu_height_ + hu_depth_) - max_hu_value_ - min_hu_value_;
   
   IF (max_value_ <= max_hu_value_ AND median_value_ <= median_hu_value_ AND min_value_ <= min_hu_value_) 
      OR (max_value_ IS NULL OR median_value_ IS NULL OR min_value_ IS NULL)
      OR (max_hu_value_ IS NULL OR median_hu_value_ IS NULL OR min_hu_value_ IS NULL) THEN
      can_pack_ := 'TRUE';
   END IF;

   RETURN can_pack_;
END Check_Packable_By_Dimension_;

FUNCTION Get_Packable_Hu_Type_Id_ (
   volume_to_pack_                  IN NUMBER,
   weight_to_pack_                  IN NUMBER,
   width_to_pack_                   IN NUMBER,
   height_to_pack_                  IN NUMBER,
   depth_to_pack_                   IN NUMBER,
   proposal_hu_types_tab_           IN Handling_Unit_Type_Tab,
   comp_uom_for_volume_             IN VARCHAR2,
   comp_uom_for_weight_             IN VARCHAR2,
   comp_uom_for_length_             IN VARCHAR2) RETURN VARCHAR2
IS
   handling_unit_type_id_to_pack_   VARCHAR2(25);
   dummy_                           NUMBER;
BEGIN
   Get_Packable_Hu_Type_Id___(handling_unit_type_id_to_pack_, dummy_, dummy_, dummy_, dummy_, dummy_, 
                              volume_to_pack_, weight_to_pack_, width_to_pack_, height_to_pack_, 
                              depth_to_pack_, proposal_hu_types_tab_, comp_uom_for_volume_, comp_uom_for_weight_, comp_uom_for_length_);
   RETURN handling_unit_type_id_to_pack_;
END Get_Packable_Hu_Type_Id_;


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Auto_Pack_Shipment_Lines (
   info_    OUT VARCHAR2,
   message_  IN VARCHAR2 )
IS
   count_                   NUMBER;
   name_arr_                Message_SYS.name_table;
   value_arr_               Message_SYS.line_table;
   row_                     PLS_INTEGER := 1;
   shipment_line_tab_       Shipment_Line_API.Line_Tab;
BEGIN
   
   Message_SYS.Get_Attributes(message_, count_, name_arr_, value_arr_);
   FOR n_ IN 1..count_ LOOP
      IF (name_arr_(n_) = 'SHIPMENT_ID') THEN
         shipment_line_tab_(row_).shipment_id := Client_SYS.Attr_Value_To_Number(value_arr_(n_));
      ELSIF (name_arr_(n_) = 'SHIPMENT_LINE_NO') THEN
         shipment_line_tab_(row_).shipment_line_no := Client_SYS.Attr_Value_To_Number(value_arr_(n_));   
      ELSIF (name_arr_(n_) = 'SOURCE_REF1') THEN
         shipment_line_tab_(row_).source_ref1 := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'SOURCE_REF2') THEN
         shipment_line_tab_(row_).source_ref2 := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'SOURCE_REF3') THEN
         shipment_line_tab_(row_).source_ref3 := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'SOURCE_REF4') THEN
         shipment_line_tab_(row_).source_ref4 := value_arr_(n_);
       ELSIF (name_arr_(n_) = 'SOURCE_REF_TYPE') THEN
         shipment_line_tab_(row_).source_ref_type := value_arr_(n_);
      END IF;
      
      IF (MOD(n_, 7) = 0) THEN
         row_ := row_ + 1;
      END IF;
   END LOOP;
   
   Auto_Pack_Shipment_Lines(info_, shipment_line_tab_);
END Auto_Pack_Shipment_Lines;


PROCEDURE Auto_Pack_Shipment_Lines (
   info_                OUT VARCHAR2,
   shipment_line_tab_    IN Shipment_Line_API.Line_Tab )
IS
   shipment_line_rec_          Shipment_Line_API.Public_Rec;
   quantity_to_connect_        NUMBER;
   handling_unit_id_tab_       Handling_Unit_API.Handling_Unit_Id_Tab;
   handling_units_to_pack_tab_ Handl_Unit_Auto_Pack_Util_API.Auto_Packing_Tab;
   row_                        PLS_INTEGER := 1;
   shipment_id_                NUMBER;
   dummy_clob_                 CLOB;
BEGIN
   Inventory_Event_Manager_API.Start_Session;
   
   FOR i IN shipment_line_tab_.FIRST..shipment_line_tab_.LAST LOOP
      -- Key Change: shipment_line_no included in the tab
      shipment_line_rec_   := Shipment_Line_API.Get(shipment_line_tab_(i).shipment_id,
                                                    shipment_line_tab_(i).shipment_line_no);
      quantity_to_connect_ := Shipment_Handling_Utility_API.Get_Remaining_Qty_To_Attach(shipment_line_tab_(i).shipment_id,
                                                                                        shipment_line_tab_(i).source_ref1,
                                                                                        shipment_line_tab_(i).source_ref2,
                                                                                        shipment_line_tab_(i).source_ref3,
                                                                                        shipment_line_tab_(i).source_ref4,
                                                                                        shipment_line_tab_(i).source_ref_type);
                                                                               
      Shipment_Line_API.Connect_To_New_Handling_Units(info_,
                                                      handling_unit_id_tab_,
                                                      shipment_line_tab_(i).shipment_id,
                                                      shipment_line_tab_(i).source_ref1,
                                                      shipment_line_tab_(i).source_ref2,
                                                      shipment_line_tab_(i).source_ref3,
                                                      shipment_line_tab_(i).source_ref4,
                                                      shipment_line_rec_.handling_unit_type_id,
                                                      quantity_to_connect_,
                                                      shipment_line_rec_.packing_instruction_id,
                                                      shipment_line_tab_(i).shipment_line_no );
                                                      
      IF (handling_unit_id_tab_.COUNT > 0) THEN
         FOR j IN handling_unit_id_tab_.FIRST..handling_unit_id_tab_.LAST LOOP 
            handling_units_to_pack_tab_(row_).handling_unit_id       := handling_unit_id_tab_(j).handling_unit_id;
            handling_units_to_pack_tab_(row_).handling_unit_type_id  := shipment_line_rec_.handling_unit_type_id;
            handling_units_to_pack_tab_(row_).packing_instruction_id := shipment_line_rec_.packing_instruction_id;
            row_ := row_ + 1;
         END LOOP;
      END IF; 
      IF (shipment_id_ IS NULL) THEN
         shipment_id_ := shipment_line_tab_(i).shipment_id;
      END IF;
   END LOOP;
   
   IF (handling_units_to_pack_tab_.COUNT > 0) THEN
      Handl_Unit_Auto_Pack_Util_API.Auto_Pack_Hu_In_Parent(dummy_clob_,
                                                           handling_units_to_pack_tab_,
                                                           shipment_id_);
   END IF;
   
   Inventory_Event_Manager_API.Start_Session;
END Auto_Pack_Shipment_Lines;


PROCEDURE Pack_Acc_Pack_Proposal (
   shipment_id_   IN  NUMBER )
IS
   CURSOR get_reservations_to_pack(excl_fully_reserved_hu_ IN VARCHAR2) IS
      SELECT spr.pick_list_no, SUM(spr.qty_to_pack * spr.part_volume), SUM(spr.qty_to_pack * spr.part_weight)
        FROM Shipment_Packable_Reservation spr
       WHERE spr.shipment_id = shipment_id_
         AND spr.qty_to_pack > 0
         AND ((spr.handling_unit_id = 0) OR ((spr.handling_unit_id != 0)
                                            AND ((excl_fully_reserved_hu_ = 'FALSE') 
                                            OR ((excl_fully_reserved_hu_ = 'TRUE') AND (spr.fully_reserved_hu = 'FALSE')))))
   GROUP BY spr.shipment_id, spr.pick_list_no;
   
   CURSOR get_reservations_by_picklist(pick_list_no_   IN VARCHAR2, sort_priority1_ IN VARCHAR2, sort_priority2_ IN VARCHAR2, excl_fully_reserved_hu_ IN VARCHAR2 ) IS
      SELECT shipment_line_no, conv_factor, inverted_conv_factor, qty_to_pack,
             shipment_id, source_ref1, source_ref2, source_ref3,
             source_ref4, source_ref_type_db, source_ref_type, part_no,
             contract, configuration_id, location_no, lot_batch_no,
             serial_no, waiv_dev_rej_no, eng_chg_level, pick_list_no,
             activity_seq, handling_unit_id, sscc, alt_handling_unit_label_id,
             expiration_date, catch_qty, catch_qty_issued, part_volume, 
             part_weight, storage_width_requirement, storage_height_requirement, storage_depth_requirement
      FROM Shipment_Packable_Reservation spr
      WHERE spr.pick_list_no = pick_list_no_
      AND spr.shipment_id = shipment_id_
      AND spr.qty_to_pack > 0
      AND ((spr.handling_unit_id = 0) OR ((spr.handling_unit_id != 0)
                                         AND ((excl_fully_reserved_hu_ = 'FALSE') 
                                         OR ((excl_fully_reserved_hu_ = 'TRUE') AND (spr.fully_reserved_hu = 'FALSE')))))
      ORDER BY 
      CASE WHEN sort_priority1_ = Ship_Pack_Proposal_Sorting_API.DB_RESERVATION_LINE_VOLUME THEN spr.qty_to_pack * part_volume END DESC,
      CASE WHEN Ship_Pack_Proposal_Sorting_API.DB_ROUTE_ORDER IN (sort_priority1_, sort_priority2_) THEN Utility_SYS.String_To_Number(WAREHOUSE_ROUTE_ORDER) END ASC,
      CASE WHEN Ship_Pack_Proposal_Sorting_API.DB_ROUTE_ORDER IN (sort_priority1_, sort_priority2_) THEN UPPER(WAREHOUSE_ROUTE_ORDER) END ASC,             
      CASE WHEN Ship_Pack_Proposal_Sorting_API.DB_ROUTE_ORDER IN (sort_priority1_, sort_priority2_) THEN Utility_SYS.String_To_Number(BAY_ROUTE_ORDER) END ASC,
      CASE WHEN Ship_Pack_Proposal_Sorting_API.DB_ROUTE_ORDER IN (sort_priority1_, sort_priority2_) THEN UPPER(decode(BAY_ROUTE_ORDER, '  -', Database_SYS.Get_Last_Character, BAY_ROUTE_ORDER)) END ASC,             
      CASE WHEN Ship_Pack_Proposal_Sorting_API.DB_ROUTE_ORDER IN (sort_priority1_, sort_priority2_) THEN Utility_SYS.String_To_Number(ROW_ROUTE_ORDER) END ASC,
      CASE WHEN Ship_Pack_Proposal_Sorting_API.DB_ROUTE_ORDER IN (sort_priority1_, sort_priority2_) THEN UPPER(decode(ROW_ROUTE_ORDER, '  -', Database_SYS.Get_Last_Character,ROW_ROUTE_ORDER)) END ASC,             
      CASE WHEN Ship_Pack_Proposal_Sorting_API.DB_ROUTE_ORDER IN (sort_priority1_, sort_priority2_) THEN Utility_SYS.String_To_Number(TIER_ROUTE_ORDER) END ASC,
      CASE WHEN Ship_Pack_Proposal_Sorting_API.DB_ROUTE_ORDER IN (sort_priority1_, sort_priority2_) THEN UPPER(decode(TIER_ROUTE_ORDER, '  -', Database_SYS.Get_Last_Character, TIER_ROUTE_ORDER)) END ASC,             
      CASE WHEN Ship_Pack_Proposal_Sorting_API.DB_ROUTE_ORDER IN (sort_priority1_, sort_priority2_) THEN Utility_SYS.String_To_Number(BIN_ROUTE_ORDER) END ASC,
      CASE WHEN Ship_Pack_Proposal_Sorting_API.DB_ROUTE_ORDER IN (sort_priority1_, sort_priority2_) THEN UPPER(decode(BIN_ROUTE_ORDER, '  -', Database_SYS.Get_Last_Character, BIN_ROUTE_ORDER)) END ASC,
      CASE WHEN Ship_Pack_Proposal_Sorting_API.DB_ROUTE_ORDER IN (sort_priority1_, sort_priority2_) THEN LOCATION_NO END,
      CASE WHEN sort_priority2_ = Ship_Pack_Proposal_Sorting_API.DB_RESERVATION_LINE_VOLUME THEN spr.qty_to_pack * part_volume END DESC;
      
   reservations_to_pack_tab_ Reservations_To_Pack_Tab;

   proposal_hu_types_tab_        Handling_Unit_Type_Tab;
   ship_pick_res_group_tab_      Ship_Pick_Res_Group_Tab;   
   packing_proposal_id_          VARCHAR2(50);
   comp_uom_for_volume_          VARCHAR2(30); 
   comp_uom_for_weight_          VARCHAR2(30);
   comp_uom_for_length_          VARCHAR2(30);
   contract_                     VARCHAR2(5);
   info_                         VARCHAR2(2000);
   company_invent_info_rec_      Company_Invent_Info_API.Public_Rec;
   ship_pack_proposal_rec_       Ship_Pack_Proposal_API.Public_Rec;
BEGIN
   packing_proposal_id_    := Shipment_API.Get_Packing_Proposal_Id(shipment_id_);
   ship_pack_proposal_rec_ := Ship_Pack_Proposal_API.Get(packing_proposal_id_);
   proposal_hu_types_tab_  := Ship_Pack_Proposal_Hu_Type_API.Get_Hu_Types(packing_proposal_id_);
   
   --No usable HU Types to pack into
   IF proposal_hu_types_tab_.COUNT = 0 THEN
      info_ := 'NOUSABLEHUTYPES: No usable handling unit types specified for the shipment packing proposal on shipment ID ' || shipment_id_;
      Client_SYS.Add_Info(lu_name_, info_);
      IF (Transaction_SYS.Is_Session_Deferred = TRUE) THEN
         Transaction_SYS.Log_Status_Info(Language_SYS.Translate_Constant(lu_name_, info_), 'INFO');
      END IF;
      RETURN;
   END IF;
   
   OPEN get_reservations_to_pack(ship_pack_proposal_rec_.excl_fully_reserved_hu);
   FETCH get_reservations_to_pack BULK COLLECT INTO ship_pick_res_group_tab_;
   CLOSE get_reservations_to_pack;
   
   IF ship_pick_res_group_tab_.COUNT > 0 THEN
      contract_                := Shipment_API.Get_Contract(shipment_id_);
      company_invent_info_rec_ := Company_Invent_Info_API.Get(Site_API.Get_Company(contract_));
      comp_uom_for_volume_     := company_invent_info_rec_.uom_for_volume;
      comp_uom_for_weight_     := company_invent_info_rec_.uom_for_weight;
      comp_uom_for_length_     := company_invent_info_rec_.uom_for_length;
      
      -- Pack pick lists
      FOR j_ IN ship_pick_res_group_tab_.FIRST..ship_pick_res_group_tab_.LAST LOOP
         OPEN get_reservations_by_picklist(ship_pick_res_group_tab_(j_).pick_list_no, ship_pack_proposal_rec_.sort_priority1, 
                                           ship_pack_proposal_rec_.sort_priority2, ship_pack_proposal_rec_.excl_fully_reserved_hu);
         FETCH get_reservations_by_picklist BULK COLLECT INTO reservations_to_pack_tab_;
         CLOSE get_reservations_by_picklist;
         
         Do_Pack_Acc_Pack_Proposal___(reservations_to_pack_tab_, ship_pick_res_group_tab_(j_), proposal_hu_types_tab_, shipment_id_, 
                          comp_uom_for_volume_, comp_uom_for_weight_, comp_uom_for_length_, packing_proposal_id_, 
                          ship_pack_proposal_rec_.pack_by_source_object, ship_pack_proposal_rec_.pack_by_reservation_line, ship_pack_proposal_rec_.pack_by_piece, 
                          ship_pack_proposal_rec_.allow_mix_source_object, ship_pack_proposal_rec_.excl_fully_reserved_hu);
      END LOOP;
   ELSE
      info_ := 'NOPACKABLEQTY: No reserved quantity qualifies to be packed for shipment ID ' || shipment_id_;
      Client_SYS.Add_Info(lu_name_, info_);
      IF (Transaction_SYS.Is_Session_Deferred = TRUE) THEN
         Transaction_SYS.Log_Status_Info(Language_SYS.Translate_Constant(lu_name_, info_), 'INFO');
      END IF;
   END IF;
END Pack_Acc_Pack_Proposal;

