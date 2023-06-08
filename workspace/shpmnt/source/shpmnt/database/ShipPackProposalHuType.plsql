-----------------------------------------------------------------------------
--
--  Logical unit: ShipPackProposalHuType
--  Component:    SHPMNT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210803  Aabalk  SC21R2-2190, Moved Handling_Unit_Type_Rec and Handling_Unit_Type_Tab to Shipment_Auto_Packing_Util_API.
--  210621  Aabalk  SC21R2-1022, Added Handling_Unit_Type_Rec and Handling_Unit_Type_Tab. Added Get_Hu_Types method to 
--  210621          return the handling unit types connected to a packing proposal.
--  210528  Aabalk  SC21R2-1019, Created. Modified Check_Common___ to validate max_volume_utilization percentage.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     ship_pack_proposal_hu_type_tab%ROWTYPE,
   newrec_ IN OUT ship_pack_proposal_hu_type_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   IF  (newrec_.max_volume_utilization < 0) THEN
       Error_SYS.Record_General(lu_name_, 'PERCENTAGE_NEGATIVE: Percentage cannot be negative.');
   END IF;
   IF (newrec_.max_volume_utilization > 1) THEN
       Error_SYS.Record_General(lu_name_, 'PERCENTAGE_TOOBIG: Percentage cannot be greater than 100.');
   END IF;
END Check_Common___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
@UncheckedAccess
FUNCTION Get_Hu_Types (
   packing_proposal_id_ IN VARCHAR2) RETURN Shipment_Auto_Packing_Util_API.Handling_Unit_Type_Tab
IS
   CURSOR get_hu_types IS
      SELECT spp.handling_unit_type_id, spp.max_volume_utilization, 
             (spp.max_volume_utilization * Handling_Unit_Type_API.Get_Max_Volume_Capacity(spp.handling_unit_type_id)) operative_volume
        FROM ship_pack_proposal_hu_type_tab spp
       WHERE spp.packing_proposal_id = packing_proposal_id_
      ORDER BY operative_volume ASC;
      
   TYPE Hu_Type_Id_Tab IS TABLE OF get_hu_types%ROWTYPE INDEX BY PLS_INTEGER;
   hu_type_tab_               Hu_Type_Id_Tab;
   usable_hu_type_tab_        Shipment_Auto_Packing_Util_API.Handling_Unit_Type_Tab; 
   j_                         PLS_INTEGER := 1;
   handling_unit_type_rec_    Handling_Unit_Type_API.Public_Rec;
BEGIN
   OPEN get_hu_types;
   FETCH get_hu_types BULK COLLECT INTO hu_type_tab_;
   CLOSE get_hu_types;
   
   IF hu_type_tab_.COUNT > 0 THEN
      FOR i_ IN hu_type_tab_.FIRST..hu_type_tab_.LAST LOOP
         IF hu_type_tab_(i_).operative_volume IS NOT NULL THEN
            handling_unit_type_rec_ := Handling_Unit_Type_API.Get(hu_type_tab_(i_).handling_unit_type_id);
            IF handling_unit_type_rec_.max_weight_capacity IS NOT NULL THEN
               usable_hu_type_tab_(j_).handling_unit_type_id         := hu_type_tab_(i_).handling_unit_type_id;
               usable_hu_type_tab_(j_).max_volume_utilization        := hu_type_tab_(i_).max_volume_utilization;
               usable_hu_type_tab_(j_).operative_volume_utilization  := hu_type_tab_(i_).operative_volume;
               usable_hu_type_tab_(j_).uom_for_volume                := handling_unit_type_rec_.uom_for_volume;
               usable_hu_type_tab_(j_).max_weight_capacity           := handling_unit_type_rec_.max_weight_capacity;
               usable_hu_type_tab_(j_).uom_for_weight                := handling_unit_type_rec_.uom_for_weight;
               usable_hu_type_tab_(j_).width                         := handling_unit_type_rec_.width;
               usable_hu_type_tab_(j_).height                        := handling_unit_type_rec_.height;
               usable_hu_type_tab_(j_).depth                         := handling_unit_type_rec_.depth;
               usable_hu_type_tab_(j_).uom_for_length                := handling_unit_type_rec_.uom_for_length;
               j_ := j_ + 1;
            END IF;
         END IF;
      END LOOP;
   END IF;
   
   RETURN usable_hu_type_tab_;
END Get_Hu_Types;

