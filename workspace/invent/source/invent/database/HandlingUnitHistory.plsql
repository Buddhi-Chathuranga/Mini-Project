-----------------------------------------------------------------------------
--
--  Logical unit: HandlingUnitHistory
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210728  RoJalk  Bug 159309(SCZ-15686),Added the method Get_By_Shipment_Id.
--  200728  Aabalk  SCXTEND-4364, Modified Create_Snapshot to copy operative_unit_tare_weight to the history object.
--  200316  Aabalk  Bug 152790(SCZ-8697), Modified Create_Snapshot to copy manual_tare_weight to the history object.
--  180716  ChJalk  Bug 142811(SCZ-509), Modified the method Create_Snapshot to copy the custom fields from LU HandlingUnit to the LU HandlingUnitHistory when inserting the records to Handling Unit History.
--  180716          Modified the method Remove_By_Shipment_Id to copy the custom fields from LU HandlingUnitHistory to the LU HandlingUnit if available when removing the records from Handling Unit History. 
--  180206  MaRalk  STRSC-16759, Modified Create_Snapshot in order to copy note_text to the history object.
--  171106  MaRalk  STRSC-12070, Modified Create_Snapshot in order to copy document text to the history object. 
--  170810  KoDelk  STRSC-11242, Skip assign value to composition attribute if handling unit is connected to a shipment
--  170221  Chfose  LIM-10450, Added new methods Shipment_Id_Exists & Remove_By_Shipment_Id.
--  170202  Chfose  LIM-10117, Added new methods Get_Top_Parent_Handl_Unit_Id & Get_No_Of_Children.
--  161221  UdGnlk  LIM-10045, Modified Create_Snapshot() to add logic when accessory exist to create history records;  
--  161118  MaEelk  LIM-9193. Created LU and added Create_Snapshot hat would create snapshots taken from HANDLING_UNIT_TAB
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Get_Node_And_Descendants___ (
   sequence_no_      IN NUMBER,
   handling_unit_id_ IN NUMBER ) RETURN Handling_Unit_API.Handling_Unit_Id_Tab
IS
   CURSOR get_all_nodes IS  
      SELECT handling_unit_id
      FROM HANDLING_UNIT_HISTORY_TAB
      WHERE SEQUENCE_NO = sequence_no_
      CONNECT BY PRIOR handling_unit_id = parent_handling_unit_id
      START WITH       handling_unit_id = handling_unit_id_;
   
   handling_unit_id_tab_ Handling_Unit_API.Handling_Unit_Id_Tab;
BEGIN   
   OPEN get_all_nodes;
   FETCH get_all_nodes BULK COLLECT INTO handling_unit_id_tab_;
   CLOSE get_all_nodes;
   RETURN handling_unit_id_tab_;
END Get_Node_And_Descendants___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


PROCEDURE Create_Snapshot (
   root_handling_unit_id_tab_  Handling_Unit_API.Handling_Unit_Id_Tab )
IS
   newrec_                    HANDLING_UNIT_HISTORY_TAB%ROWTYPE;
   nodes_and_descendants_tab_ Handling_Unit_API.Handling_Unit_Id_Tab;
   handling_unit_rec_         Handling_Unit_API.Public_Rec;
   sequence_no_               NUMBER := handling_unit_history_seq.nextval;   
   uom_for_weight_            VARCHAR2(30);
   uom_for_volume_            VARCHAR2(30);
BEGIN
   IF (root_handling_unit_id_tab_.COUNT > 0)THEN
      FOR i IN root_handling_unit_id_tab_.FIRST..root_handling_unit_id_tab_.LAST LOOP
         IF (Handling_Unit_API.Get_Parent_HAndling_Unit_id(root_handling_unit_id_tab_(i).handling_unit_id) IS NOT NULL) THEN
            Error_SYS.Record_General(lu_name_, 'PARENTEXIST: :P1 has a parent and it cannot be taken as a root when creating a History Snapshot', handling_unit_rec_.handling_unit_id);   
         END IF;
         nodes_and_descendants_tab_ := Handling_Unit_API.Get_Node_And_Descendants(root_handling_unit_id_tab_(i).handling_unit_id);
         
         FOR j IN nodes_and_descendants_tab_.FIRST..nodes_and_descendants_tab_.LAST LOOP
            handling_unit_rec_                  := Handling_Unit_API.Get(nodes_and_descendants_tab_(j).handling_unit_id);
            uom_for_weight_                     := Handling_Unit_API.Get_Uom_For_Weight(handling_unit_rec_.handling_unit_id);
            uom_for_volume_                     := Handling_Unit_API.Get_Uom_For_Volume(handling_unit_rec_.handling_unit_id);
            newrec_.sequence_no                 := sequence_no_;           
            newrec_.handling_unit_id            := handling_unit_rec_.handling_unit_id;
            newrec_.handling_unit_type_id       := handling_unit_rec_.handling_unit_type_id;
            newrec_.parent_handling_unit_id     := handling_unit_rec_.parent_handling_unit_id;
            newrec_.shipment_id                 := handling_unit_rec_.shipment_id;            
            newrec_.width                       := handling_unit_rec_.width;
            newrec_.height                      := handling_unit_rec_.height;
            newrec_.uom_for_length              := handling_unit_rec_.uom_for_length;
            newrec_.uom_for_weight              := uom_for_weight_;
            newrec_.manual_tare_weight          := handling_unit_rec_.manual_tare_weight;
            newrec_.manual_gross_weight         := handling_unit_rec_.manual_gross_weight;
            newrec_.generate_sscc_no            := handling_unit_rec_.generate_sscc_no;
            newrec_.print_label                 := handling_unit_rec_.print_label;
            newrec_.print_content_label         := handling_unit_rec_.print_content_label;
            newrec_.print_shipment_label        := handling_unit_rec_.print_shipment_label;
            newrec_.mix_of_part_no_blocked      := handling_unit_rec_.mix_of_part_no_blocked;
            newrec_.mix_of_lot_batch_blocked    := handling_unit_rec_.mix_of_lot_batch_blocked;
            newrec_.mix_of_cond_code_blocked    := handling_unit_rec_.mix_of_cond_code_blocked;
            newrec_.manual_volume               := handling_unit_rec_.manual_volume;
            newrec_.uom_for_volume              := uom_for_volume_;
            newrec_.sscc                        := handling_unit_rec_.sscc;
            newrec_.alt_handling_unit_label_id  := handling_unit_rec_.alt_handling_unit_label_id;
            newrec_.depth                       := handling_unit_rec_.depth;
            newrec_.no_of_handling_unit_labels  := handling_unit_rec_.no_of_handling_unit_labels;
            newrec_.no_of_content_labels        := handling_unit_rec_.no_of_content_labels;
            newrec_.no_of_shipment_labels       := handling_unit_rec_.no_of_shipment_labels;
            newrec_.contract                    := handling_unit_rec_.contract;
            newrec_.location_no                 := handling_unit_rec_.location_no;
            newrec_.source_ref_type             := handling_unit_rec_.source_ref_type;
            newrec_.source_ref1                 := handling_unit_rec_.source_ref1;
            newrec_.source_ref2                 := handling_unit_rec_.source_ref2;
            newrec_.source_ref3                 := handling_unit_rec_.source_ref3;
            newrec_.source_ref_part_qty         := handling_unit_rec_.source_ref_part_qty;
            newrec_.has_stock_reservation       := handling_unit_rec_.has_stock_reservation;
            newrec_.structure_level             := Handling_Unit_API.Get_Structure_Level(handling_unit_rec_.handling_unit_id);
            IF(handling_unit_rec_.shipment_id IS NULL) THEN
               newrec_.composition                 := Handling_Unit_Composition_API.Encode(Handling_Unit_API.Get_Composition(handling_unit_rec_.handling_unit_id));
            END IF;
            newrec_.net_weight                  := Handling_Unit_API.Get_Net_Weight(handling_unit_rec_.handling_unit_id,uom_for_weight_, 'FALSE');
            newrec_.adjusted_net_weight         := Handling_Unit_API.Get_Net_Weight(handling_unit_rec_.handling_unit_id,uom_for_weight_, 'TRUE');
            newrec_.operative_unit_tare_weight  := Handling_Unit_API.Get_Operative_Unit_Tare_Weight(handling_unit_rec_.handling_unit_id, uom_for_weight_);
            newrec_.tare_weight                 := Handling_Unit_API.Get_Tare_Weight(handling_unit_rec_.handling_unit_id,uom_for_weight_);
            newrec_.operative_gross_weight      := Handling_Unit_API.Get_Operative_Gross_Weight(handling_unit_rec_.handling_unit_id,uom_for_weight_, 'FALSE');
            newrec_.adjust_operat_gross_weight  := Handling_Unit_API.Get_Operative_Gross_Weight(handling_unit_rec_.handling_unit_id,uom_for_weight_, 'TRUE');
            newrec_.operative_volume            := Handling_Unit_API.Get_Operative_Volume(handling_unit_rec_.handling_unit_id,uom_for_volume_);
            newrec_.category_id                 := Handling_Unit_Type_API.Get_Handling_Unit_Category_Id(handling_unit_rec_.handling_unit_type_id);
            newrec_.additive_volume             := Handling_Unit_Type_API.Get_Additive_Volume_Db(handling_unit_rec_.handling_unit_type_id);
            newrec_.max_volume_capacity         := Handling_Unit_API.Get_Max_Volume_Capacity(handling_unit_rec_.handling_unit_id, uom_for_volume_);
            newrec_.max_weight_capacity         := Handling_Unit_API.Get_Max_Weight_Capacity(handling_unit_rec_.handling_unit_id, uom_for_weight_);
            newrec_.stackable                   := Handling_Unit_Type_API.Get_Stackable_Db(handling_unit_rec_.handling_unit_type_id);
            newrec_.note_id                     := Document_Text_API.Get_Next_Note_Id;
            Document_Text_API.Copy_All_Note_Texts(handling_unit_rec_.note_id, newrec_.note_id);  
            newrec_.note_text                   := handling_unit_rec_.note_text;
            New___(newrec_);
            Accessory_On_Hu_History_API.Create_Snapshot(sequence_no_, handling_unit_rec_.handling_unit_id);               
            Custom_Objects_SYS.Copy_Between_Lu_Cf_Instance('HandlingUnit', handling_unit_rec_.rowkey, 'HandlingUnitHistory', newrec_.rowkey);                        
         END LOOP;
      END LOOP;
   END IF;   
END Create_Snapshot;


FUNCTION Shipment_Id_Exists (
   shipment_id_      IN NUMBER ) RETURN BOOLEAN
IS
   CURSOR get_shipment_exists IS
      SELECT 1
        FROM HANDLING_UNIT_HISTORY_TAB
       WHERE shipment_id = shipment_id_;
       
   dummy_            NUMBER;
   shipment_exists_  BOOLEAN := FALSE;
BEGIN
   OPEN get_shipment_exists;
   FETCH get_shipment_exists INTO dummy_;
   IF (get_shipment_exists%FOUND) THEN
      shipment_exists_ := TRUE;
   END IF;
   
   RETURN shipment_exists_;
END Shipment_Id_Exists;


PROCEDURE Remove_By_Shipment_Id (
   shipment_id_      IN NUMBER ) 
IS
   CURSOR get_hu_history IS
      SELECT *
        FROM HANDLING_UNIT_HISTORY_TAB
       WHERE shipment_id = shipment_id_;
   
   hu_objkey_    Handling_Unit_TAB.rowkey%TYPE;
BEGIN
   FOR rec_ IN get_hu_history LOOP
      hu_objkey_ := Handling_Unit_API.Get_Objkey(rec_.handling_unit_id);
      Custom_Objects_SYS.Copy_Between_Lu_Cf_Instance('HandlingUnitHistory', rec_.rowkey, 'HandlingUnit', hu_objkey_);                        
      Remove___(rec_);
   END LOOP;
END Remove_By_Shipment_Id;


@UncheckedAccess
FUNCTION Get_By_Shipment_Id (
   handling_unit_id_ IN NUMBER,
   shipment_id_      IN NUMBER ) RETURN Public_Rec
IS
   CURSOR get_sequence_no IS
      SELECT sequence_no
        FROM HANDLING_UNIT_HISTORY_TAB
       WHERE handling_unit_id = handling_unit_id_
         AND shipment_id      = shipment_id_;
         
   sequence_no_               HANDLING_UNIT_HISTORY_TAB.sequence_no%TYPE;
   handling_unit_history_rec_ Public_Rec;
BEGIN
   OPEN get_sequence_no;
   FETCH get_sequence_no INTO sequence_no_;
   CLOSE get_sequence_no;
   
   handling_unit_history_rec_ := Get(sequence_no_, handling_unit_id_);
   
   RETURN handling_unit_history_rec_;  
END Get_By_Shipment_Id;


@UncheckedAccess
FUNCTION Get_Top_Parent_Handl_Unit_Id (
   sequence_no_      IN NUMBER,
   handling_unit_id_ IN NUMBER ) RETURN NUMBER
IS
   parent_handling_unit_id_      NUMBER;
   top_parent_handling_unit_id_  NUMBER;
BEGIN
   parent_handling_unit_id_ := Get_Parent_Handling_Unit_Id(sequence_no_, handling_unit_id_);
   
   IF (parent_handling_unit_id_ IS NULL) THEN
      top_parent_handling_unit_id_ := handling_unit_id_;
   ELSE
      top_parent_handling_unit_id_ := Get_Top_Parent_Handl_Unit_Id(sequence_no_, parent_handling_unit_id_);
   END IF;
   
   RETURN top_parent_handling_unit_id_;
END Get_Top_Parent_Handl_Unit_Id;


@UncheckedAccess
FUNCTION Get_No_Of_Children (
   sequence_no_           IN NUMBER,
   handling_unit_id_      IN NUMBER,
   handling_unit_type_id_ IN VARCHAR2 DEFAULT NULL) RETURN NUMBER 
IS
   number_of_children_ NUMBER;
   CURSOR get_number_of_children IS 
      SELECT count(*)
        FROM HANDLING_UNIT_HISTORY_TAB
       WHERE sequence_no = sequence_no_
         AND parent_handling_unit_id = handling_unit_id_
         AND handling_unit_type_id   = NVL(handling_unit_type_id_, handling_unit_type_id);
BEGIN
   OPEN get_number_of_children;
   FETCH get_number_of_children INTO number_of_children_;
   CLOSE get_number_of_children;
   
   RETURN number_of_children_;
END Get_No_Of_Children;


@UncheckedAccess
FUNCTION Get_Composition (
   sequence_no_      IN NUMBER,
   handling_unit_id_ IN NUMBER ) RETURN VARCHAR2
IS            
   handling_unit_id_tab_         Handling_Unit_API.Handling_Unit_Id_Tab;  
   mixed_part_numbers_connected_ BOOLEAN := FALSE; 
   composition_db_               handling_unit_history_tab.composition%TYPE;
   rec_                          handling_unit_history_tab%ROWTYPE;
BEGIN
   rec_ := Get_Object_By_Keys___(sequence_no_, handling_unit_id_);
   
   IF (rec_.shipment_id IS NULL) THEN 
      composition_db_ := rec_.composition;
   ELSE
      handling_unit_id_tab_ := Get_Node_And_Descendants___(sequence_no_, handling_unit_id_);
      IF (handling_unit_id_tab_.COUNT > 0) THEN
         $IF (Component_Shpmnt_SYS.INSTALLED) $THEN
            mixed_part_numbers_connected_ := Shipment_Line_Handl_Unit_API.Mixed_Part_Numbers_Connected(handling_unit_id_tab_);
         $ELSE
            Error_SYS.Component_Not_Exist('SHPMNT');
         $END
         IF (mixed_part_numbers_connected_) THEN
           composition_db_ := Handling_Unit_Composition_API.DB_MIXED;
         ELSIF (handling_unit_id_tab_.COUNT > 1) THEN
           composition_db_ := Handling_Unit_Composition_API.DB_HOMOGENEOUS;
         ELSE
           composition_db_ := Handling_Unit_Composition_API.DB_SIMPLIFIED;
         END IF;
      END IF;
   END IF;

   RETURN Handling_Unit_Composition_API.Decode(composition_db_);
END Get_Composition;



-------------------- LU  NEW METHODS -------------------------------------
