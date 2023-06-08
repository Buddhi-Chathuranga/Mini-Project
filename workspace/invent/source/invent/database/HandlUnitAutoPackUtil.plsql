-----------------------------------------------------------------------------
--
--  Logical unit: HandlUnitAutoPackUtil
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200703  SBalLK  Bug 154469(SCZ-10454), Modified Auto_Pack_Hu_In_Parent___() and Pack_Stock_Record_Into_Hu_Type() method to generate
--  200703          SSCC numbers if Generate SSCC enabled for the handling unit.
--  180201  LEPESE  STRSC-16123, Moved code from Auto_Pack_Hu_Into_Parent to Auto_Pack_Hu_Into_Parent___. Added parameter parent_handling_unit_tab_.
--  171121  Mwerse  STRSC-8915: Modified Auto_Pack_Hu_In_Parent, Pack_Stock_Rec_Into_Hu_Types and Pack_Stock_Into_Pack_Instr to return the created handling units.
--  170404  Jhalse  LIM-11076, Modified Pack_Stock_Into_Pack_Instr to consider inherited capacity groups.
--  170104  NaSalk  LIM-10022, Modified Create_Handling_Unit_Struct___  and Get_No_Of_Pack_Instr_Top_Nodes.
--  161206  NaSalk  LIM-9757, Modified Create_Handling_Unit_Struct___ and Create_Handling_Unit_Structure method to add
--  161206          sscc and alt_handling_unit_label_id parameters.
--  161129  Thimlk  STRMF-8390, Modified Create_Handling_Unit_Structure to correct the order of parameters when, calling Create_Handling_Unit_Structure().
--  161123  NaSalk  LIM-9757, Modified Create_Handling_Unit_Struct___ and Create_Handling_Unit_Structure
--  161123          to return leaf node level handling unt ids.
--  160929  NaLrlk  LIM-8806, Modified Pack_Stock_Record_Into_Hu_Type() to correctly handle the error for receipt.
--  160905  Chfose  LIM-8398, Added new method Pack_Stock_Rec_Into_Hu_Types for calling multiple instances of Pack_Stock_Record_Into_Hu_Type with a message.
--  160902  Chfose  LIM-8408, Modified Auto_Pack_Hu_In_Parent__ to support CLOB instead of VARCHAR2.
--  160826  NaLrlk  LIM-8316, Modified Pack_Stock_Into_Pack_Instr(() to support for generic receipt location. 
--  160816  DAYJLK  LIM-8295, Added parameters source_ref1_, source_ref2_, source_ref3_, source_ref4_ and source_ref_type_db_ to Pack_Stock_Record_Into_Hu_Type.
--  160728  Chfose  LIM-7791, Added inventory_event_id_ in Pack_Stock_Into_Pack_Instr & Pack_Stock_Record_Into_Hu_Type.
--  160727  Rakalk  LIM-7993, Removed method Create_Child_Handling_Units___ and Create_Handling_Unit_For_Part.
--  160226  UdGnlk  LIM-6224, Modified Pack_Stock_Into_Pack_Instr() to redo corrections. 
--  160212  UdGnlk  LIM-6224, Modified Pack_Stock_Into_Pack_Instr() to support CLOB datatype for the parameter message.  
--  151222  UdGnlk  LIM-5364, Added Pack_Stock_Into_Pack_Instr() to apply packing instruction for parts functionality.  
--  151217  MaEelk  LIM-5384, Added method Auto_Pack_Hu_In_Parent_. This would unpack the MESSAGE containg HUs going to be packed
--  151217          and their and related information. This will call Auto_Pack_Hu_In_Parent to pack HUs according to Packing Instruction. 
--  151215  JeLise  LIM-3152, Added method Connect_To_New_Handling_Units to create and pack the lowest level.
--  151215  JeLise  LIM-3152, Added method Pack_Stock_Record_Into_Hu_Type to create and pack the lowest level.
--  151215  MaEelk  LIM-5383, Created the package and created the procedure Auto_Pack_Hu_In_Parent. 
--  151215          This method would pack handling units according to the given packing instruction.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


TYPE Auto_Packing_Rec IS RECORD (
   handling_unit_id       NUMBER,
   handling_unit_type_id  VARCHAR2(25),
   packing_instruction_id VARCHAR2(50));

TYPE Auto_Packing_Tab IS TABLE OF Auto_Packing_Rec INDEX BY PLS_INTEGER;


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Auto_Pack_Hu_In_Parent___ (
   message_                   IN OUT   CLOB,
   handling_unit_to_pack_tab_ IN Auto_Packing_Tab,
   parent_handling_unit_tab_  IN Auto_Packing_Tab,
   shipment_id_               IN NUMBER )
IS
   parent_handling_unit_type_id_  VARCHAR2(25);
   number_of_connected_children_  NUMBER; 
   node_id_                       NUMBER;
   no_of_hu_possible_to_connect_  NUMBER;
   available_parent_handlunit_id_ NUMBER;
   local_parent_handl_unit_tab_   Auto_Packing_Tab;
   local_handl_unit_to_pack_tab_  Auto_Packing_Tab;
   new_handling_unit_id_          NUMBER;
   parent_index_                  PLS_INTEGER;
   new_index_                     PLS_INTEGER := 0;
   handling_unit_rec_             Handling_Unit_API.Public_Rec;
BEGIN
   Inventory_Event_Manager_API.Start_Session;
   
   local_parent_handl_unit_tab_ := parent_handling_unit_tab_;
   parent_index_                := parent_handling_unit_tab_.COUNT;
   
   IF (handling_unit_to_pack_tab_.COUNT > 0) THEN
      FOR i IN handling_unit_to_pack_tab_.FIRST..handling_unit_to_pack_tab_.LAST LOOP
         Handling_Unit_API.Apply_Pack_Instr_Node_Settings(handling_unit_to_pack_tab_(i).handling_unit_id,
                                                          handling_unit_to_pack_tab_(i).packing_instruction_id);

         parent_handling_unit_type_id_ := Packing_Instruction_Node_API.Get_Parent_Handl_Unit_Type_Id(handling_unit_to_pack_tab_(i).packing_instruction_id,
                                                                                                     handling_unit_to_pack_tab_(i).handling_unit_type_id);
         IF (parent_handling_unit_type_id_ IS NOT NULL) THEN
            available_parent_handlunit_id_ := NULL;

            IF (local_parent_handl_unit_tab_.COUNT > 0) THEN 
               @ApproveTransactionStatement(2013-06-18,jelise)
               SAVEPOINT before_connecting_to_parent; 

               FOR j IN local_parent_handl_unit_tab_.FIRST..local_parent_handl_unit_tab_.LAST LOOP 
                  IF (handling_unit_to_pack_tab_(i).packing_instruction_id = local_parent_handl_unit_tab_(j).packing_instruction_id) THEN 
                     IF (parent_handling_unit_type_id_ = local_parent_handl_unit_tab_(j).handling_unit_type_id) THEN 
                        number_of_connected_children_ := Handling_Unit_API.Get_No_Of_Children(local_parent_handl_unit_tab_(j).handling_unit_id,
                                                                                              handling_unit_to_pack_tab_(i).handling_unit_type_id);
                        node_id_                      := Packing_Instruction_Node_API.Get_Node_Id(handling_unit_to_pack_tab_(i).packing_instruction_id,
                                                                                                  handling_unit_to_pack_tab_(i).handling_unit_type_id);
                        no_of_hu_possible_to_connect_ := Packing_Instruction_Node_API.Get_Quantity(handling_unit_to_pack_tab_(i).packing_instruction_id,
                                                                                                   node_id_);
                        IF (number_of_connected_children_ < no_of_hu_possible_to_connect_) THEN 
                           available_parent_handlunit_id_ := local_parent_handl_unit_tab_(j).handling_unit_id;
                           DECLARE
                              mix_of_blocked EXCEPTION;
                              PRAGMA         EXCEPTION_INIT(mix_of_blocked, -20110);
                              BEGIN
                              Handling_Unit_API.Modify_Parent_Handling_Unit_Id(handling_unit_to_pack_tab_(i).handling_unit_id, available_parent_handlunit_id_);
                              IF ( available_parent_handlunit_id_ IS NOT NULL ) THEN
                                 handling_unit_rec_ := Handling_Unit_API.Get(available_parent_handlunit_id_);
                                 IF (handling_unit_rec_.generate_sscc_no = Fnd_Boolean_API.DB_TRUE AND handling_unit_rec_.sscc IS NULL ) THEN
                                    Handling_Unit_API.Create_Sscc(available_parent_handlunit_id_);
                                 END IF;
                              END IF;
                           EXCEPTION
                              WHEN mix_of_blocked THEN
                                 available_parent_handlunit_id_ := NULL;

                                 @ApproveTransactionStatement(2013-06-18,jelise)
                                 ROLLBACK TO before_connecting_to_parent;
                           END;

                           IF (available_parent_handlunit_id_ IS NOT NULL) THEN 
                              EXIT;
                           END IF;
                        END IF;
                     END IF;
                  END IF;
               END LOOP;
            END IF;

            IF (available_parent_handlunit_id_ IS NULL) THEN
               Handling_Unit_API.New_With_Pack_Instr_Settings(handling_unit_id_       => new_handling_unit_id_,
                                                              handling_unit_type_id_  => parent_handling_unit_type_id_,
                                                              packing_instruction_id_ => handling_unit_to_pack_tab_(i).packing_instruction_id,
                                                              shipment_id_            => shipment_id_);
               parent_index_ := parent_index_ + 1;
               new_index_    := new_index_    + 1;
               local_parent_handl_unit_tab_(parent_index_).handling_unit_id       := new_handling_unit_id_;
               local_parent_handl_unit_tab_(parent_index_).handling_unit_type_id  := parent_handling_unit_type_id_;
               local_parent_handl_unit_tab_(parent_index_).packing_instruction_id := handling_unit_to_pack_tab_(i).packing_instruction_id;
               available_parent_handlunit_id_                                     := new_handling_unit_id_;
               local_handl_unit_to_pack_tab_(new_index_)                          := local_parent_handl_unit_tab_(parent_index_);
               Handling_Unit_API.Modify_Parent_Handling_Unit_Id(handling_unit_to_pack_tab_(i).handling_unit_id, available_parent_handlunit_id_);
               handling_unit_rec_ := Handling_Unit_API.Get(available_parent_handlunit_id_);
               IF (handling_unit_rec_.generate_sscc_no = Fnd_Boolean_API.DB_TRUE AND handling_unit_rec_.sscc IS NULL ) THEN
                  Handling_Unit_API.Create_Sscc(available_parent_handlunit_id_);
               END IF;
            END IF;
         END IF;
      END LOOP;
      
   END IF;

   IF (local_handl_unit_to_pack_tab_.COUNT > 0) THEN
      Auto_Pack_Hu_In_Parent___(message_, local_handl_unit_to_pack_tab_, local_parent_handl_unit_tab_, shipment_id_);
                                             
      FOR i_ IN local_handl_unit_to_pack_tab_.FIRST..local_handl_unit_to_pack_tab_.LAST LOOP
         Message_SYS.Add_Attribute(message_, 'HANDLING_UNIT_ID', local_handl_unit_to_pack_tab_(i_).handling_unit_id);
      END LOOP;
   END IF;
   
   Inventory_Event_Manager_API.Finish_Session;
END Auto_Pack_Hu_In_Parent___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


PROCEDURE Auto_Pack_Hu_In_Parent__ (
   message_     IN CLOB,
   shipment_id_ IN NUMBER DEFAULT NULL)
IS
   count_                     NUMBER;
   name_arr_                  Message_SYS.name_table_clob;
   value_arr_                 Message_SYS.line_table_clob;
   row_                       PLS_INTEGER := 0;
   handling_unit_to_pack_tab_ Auto_Packing_Tab;
   dummy_clob_                CLOB;
BEGIN
   Message_SYS.Get_Clob_Attributes(message_, count_, name_arr_, value_arr_);   
   
   FOR n_ IN 1..count_ LOOP
      IF (name_arr_(n_) = 'HANDLING_UNIT_ID') THEN
         row_ := row_ + 1;
         handling_unit_to_pack_tab_(row_).handling_unit_id := Client_SYS.Attr_Value_To_Number(value_arr_(n_));
      ELSIF (name_arr_(n_) = 'HANDLING_UNIT_TYPE_ID') THEN
         handling_unit_to_pack_tab_(row_).handling_unit_type_id := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'PACKING_INSTRUCTION_ID') THEN
         handling_unit_to_pack_tab_(row_).packing_instruction_id := value_arr_(n_);
      END IF;
      
   END LOOP;

   Auto_Pack_Hu_In_Parent(dummy_clob_, handling_unit_to_pack_tab_, shipment_id_);
END Auto_Pack_Hu_In_Parent__;


PROCEDURE Create_Handling_Unit_Struct___ (   
   handling_unit_id_           OUT NUMBER,
   leaf_handling_unit_id_tab_  IN OUT Handling_Unit_API.Handling_Unit_Id_Tab,
   quantity_                   IN OUT VARCHAR2,
   leaf_handling_unit_type_id_ IN OUT VARCHAR2,
   part_no_                    IN VARCHAR2,
   source_ref_type_db_         IN VARCHAR2,
   source_ref1_                IN VARCHAR2,
   source_ref2_                IN VARCHAR2,
   source_ref3_                IN VARCHAR2,
   unit_code_                  IN VARCHAR2,            
   parent_handling_unit_id_    IN NUMBER,
   packing_instruction_id_     IN VARCHAR2,
   parent_node_id_             IN NUMBER,
   node_structure_tab_         IN PACKING_INSTRUCTION_NODE_API.Node_Tab,
   sscc_                       IN VARCHAR2,
   alt_handling_unit_label_id_ IN VARCHAR2)
IS
   child_handling_unit_id_ NUMBER;
   max_qty_capacity_       NUMBER;
   leaf_node_tab_index_    NUMBER;
   
BEGIN
   handling_unit_id_ := NULL;
   
   FOR i_ IN node_structure_tab_.FIRST .. node_structure_tab_.LAST LOOP
      --Find the nodes with correct parent and create units
      IF ((parent_node_id_ IS NOT NULL) AND (node_structure_tab_(i_).parent_node_id = parent_node_id_)) OR 
         ((parent_node_id_ IS NULL) AND (node_structure_tab_(i_).parent_node_id IS NULL)) THEN 
         -- leaf_handling_unit_type_id_ stores type of handling unit used for packing in the lowest level.
         -- If leaf_handling_unit_type_id_ has a value, any other handling unit types in the lowest level
         -- are ignored.
         IF ((Packing_Instruction_Node_API.Child_Node_Exist__(packing_instruction_id_, node_structure_tab_(i_).node_id) = 0) AND
             (NVL(leaf_handling_unit_type_id_, node_structure_tab_(i_).handling_unit_type_id) != node_structure_tab_(i_).handling_unit_type_id)) THEN 
            CONTINUE;
         END IF;   
         FOR j_ IN 1 .. node_structure_tab_(i_).quantity LOOP
            --Create HU
            Handling_Unit_API.New_With_Pack_Instr_Settings(handling_unit_id_,
                                                           node_structure_tab_(i_).handling_unit_type_id,
                                                           packing_instruction_id_,
                                                           parent_handling_unit_id_,
                                                           sscc_                       => CASE WHEN parent_node_id_ IS NULL THEN sscc_ ELSE NULL END,
                                                           alt_handling_unit_label_id_ => CASE WHEN parent_node_id_ IS NULL THEN alt_handling_unit_label_id_ ELSE NULL END,
                                                           source_ref_type_db_         => source_ref_type_db_,
                                                           source_ref1_                => source_ref1_,
                                                           source_ref2_                => source_ref2_,
                                                           source_ref3_                => source_ref3_);            

            --Create Children
            Create_Handling_Unit_Struct___(child_handling_unit_id_,
                                           leaf_handling_unit_id_tab_,
                                           quantity_,
                                           leaf_handling_unit_type_id_,
                                           part_no_,
                                           source_ref_type_db_,
                                           source_ref1_,
                                           source_ref2_,
                                           source_ref3_,
                                           unit_code_,                                                                                
                                           handling_unit_id_,
                                           packing_instruction_id_,
                                           node_structure_tab_(i_).node_id,
                                           node_structure_tab_,
                                           sscc_,
                                           alt_handling_unit_label_id_);
                                 
            -- If no children are created this unit can hold parts, so we reduce quantity
            IF (child_handling_unit_id_ IS NULL) THEN
               IF (leaf_handling_unit_type_id_ IS NULL) THEN 
                  leaf_handling_unit_type_id_ := node_structure_tab_(i_).handling_unit_type_id;   
               END IF;
    
               max_qty_capacity_ := Part_Handling_Unit_API.Get_Max_Quantity_Capacity(part_no_, node_structure_tab_(i_).handling_unit_type_id, unit_code_);
               quantity_ := quantity_ - max_qty_capacity_;
               leaf_node_tab_index_ := leaf_handling_unit_id_tab_.COUNT + 1;

               IF ((quantity_ <= 0) AND (source_ref_type_db_ = Handl_Unit_Source_Ref_Type_API.DB_SHOP_ORDER)) THEN
                  Handling_Unit_API.Modify_Source_Ref_Part_Qty(handling_unit_id_, max_qty_capacity_ + quantity_);
               END IF;
               
               leaf_handling_unit_id_tab_(leaf_node_tab_index_).handling_unit_id := handling_unit_id_;
               leaf_node_tab_index_ := leaf_node_tab_index_ + 1;
            END IF;     
            
            --Exit if we have created all the units we need
            EXIT WHEN quantity_ <= 0;
         END LOOP;
         
      END IF;    
      --Exit if we have created all the units we need
      EXIT WHEN quantity_ <= 0;
   END LOOP;
   
   IF (quantity_ <= 0) THEN
      quantity_ := 0;
   END IF;
END Create_Handling_Unit_Struct___;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


FUNCTION Pack_Stock_Rec_Into_Hu_Types (
   message_                       IN CLOB,
   contract_                      IN VARCHAR2,
   part_no_                       IN VARCHAR2,
   configuration_id_              IN VARCHAR2,
   location_no_                   IN VARCHAR2,
   lot_batch_no_                  IN VARCHAR2,
   serial_no_                     IN VARCHAR2,
   eng_chg_level_                 IN VARCHAR2,
   waiv_dev_rej_no_               IN VARCHAR2,
   activity_seq_                  IN NUMBER,
   packing_instruction_id_        IN VARCHAR2 DEFAULT NULL,
   parent_handling_unit_id_       IN NUMBER   DEFAULT NULL,
   source_ref1_                   IN VARCHAR2 DEFAULT NULL,
   source_ref2_                   IN VARCHAR2 DEFAULT NULL,
   source_ref3_                   IN VARCHAR2 DEFAULT NULL,
   source_ref4_                   IN VARCHAR2 DEFAULT NULL,
   inv_trans_source_ref_type_db_  IN VARCHAR2 DEFAULT NULL ) RETURN CLOB
IS
   count_                  NUMBER;
   name_arr_               Message_SYS.name_table_clob;
   value_arr_              Message_SYS.line_table_clob;
   
   qty_to_pack_            NUMBER;
   handling_unit_type_id_  VARCHAR2(25);
   handling_unit_id_tab_   Handling_Unit_API.Handling_Unit_Id_Tab;
   message_out_            CLOB;
BEGIN
   Inventory_Event_Manager_API.Start_Session;
   
   Message_SYS.Get_Clob_Attributes(message_, count_, name_arr_, value_arr_);   
   FOR n_ IN 1..count_ LOOP
      IF (name_arr_(n_) = 'HANDLING_UNIT_TYPE_ID') THEN
         handling_unit_type_id_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'QTY_TO_PACK') THEN
         qty_to_pack_ := Client_SYS.Attr_Value_To_Number(value_arr_(n_));
         Pack_Stock_Record_Into_Hu_Type(handling_unit_id_tab_,
                                        contract_,
                                        part_no_,
                                        configuration_id_,
                                        location_no_,
                                        lot_batch_no_,
                                        serial_no_,
                                        eng_chg_level_,
                                        waiv_dev_rej_no_,
                                        activity_seq_,
                                        handling_unit_type_id_,
                                        qty_to_pack_,
                                        packing_instruction_id_,
                                        parent_handling_unit_id_,
                                        source_ref1_,
                                        source_ref2_,
                                        source_ref3_,
                                        source_ref4_,
                                        inv_trans_source_ref_type_db_);
         FOR i_ IN handling_unit_id_tab_.FIRST..handling_unit_id_tab_.LAST LOOP
            Message_SYS.Add_Attribute(message_out_, 'HANDLING_UNIT_ID', handling_unit_id_tab_(i_).handling_unit_id);
         END LOOP;
      END IF;
   END LOOP;
   
   Inventory_Event_Manager_API.Finish_Session;
   RETURN message_out_;
END Pack_Stock_Rec_Into_Hu_Types;


PROCEDURE Pack_Stock_Record_Into_Hu_Type (
   handling_unit_id_tab_          OUT Handling_Unit_API.Handling_Unit_Id_Tab,
   contract_                      IN  VARCHAR2,
   part_no_                       IN  VARCHAR2,
   configuration_id_              IN  VARCHAR2,
   location_no_                   IN  VARCHAR2,
   lot_batch_no_                  IN  VARCHAR2, 
   serial_no_                     IN  VARCHAR2, 
   eng_chg_level_                 IN  VARCHAR2, 
   waiv_dev_rej_no_               IN  VARCHAR2, 
   activity_seq_                  IN  NUMBER, 
   handling_unit_type_id_         IN  VARCHAR2,
   qty_to_connect_                IN  NUMBER,
   packing_instruction_id_        IN  VARCHAR2 DEFAULT NULL,
   parent_handling_unit_id_       IN  NUMBER   DEFAULT NULL,
   source_ref1_                   IN  VARCHAR2 DEFAULT NULL,
   source_ref2_                   IN  VARCHAR2 DEFAULT NULL,
   source_ref3_                   IN  VARCHAR2 DEFAULT NULL,
   source_ref4_                   IN  VARCHAR2 DEFAULT NULL,
   inv_trans_source_ref_type_db_  IN  VARCHAR2 DEFAULT NULL )
IS
   inventory_unit_meas_           VARCHAR2(10);   
   rec_order_source_ref_type_db_  VARCHAR2(20);
   stock_rec_                     Inventory_Part_In_Stock_API.Public_Rec;
   max_quantity_capacity_         NUMBER;
   qty_left_to_connect_           NUMBER;
   handling_unit_id_              NUMBER;
   qty_to_be_added_               NUMBER;
   qty_available_                 NUMBER;
   rows_                          PLS_INTEGER := 1;
   location_type_db_              VARCHAR2(20);
   handling_unit_rec_             Handling_Unit_API.Public_Rec;
BEGIN
   inventory_unit_meas_   := Inventory_Part_API.Get_Unit_Meas(contract_, part_no_);
   location_type_db_      := Inventory_Location_API.Get_Location_Type_Db(contract_, location_no_);
   IF (location_type_db_ IN (Inventory_Location_Type_API.DB_ARRIVAL, Inventory_Location_Type_API.DB_QUALITY_ASSURANCE)) THEN
      $IF Component_Rceipt_SYS.INSTALLED $THEN
         rec_order_source_ref_type_db_ := Receive_Order_API.Get_Source_Ref_Type_Db(inv_trans_source_ref_type_db_);
         qty_available_ := Receipt_Inv_Location_API.Get_Inv_Qty_In_Store_By_Source(source_ref1_        => source_ref1_,
                                                                                   source_ref2_        => source_ref2_,
                                                                                   source_ref3_        => source_ref3_,
                                                                                   source_ref4_        => NULL,
                                                                                   source_ref_type_db_ => rec_order_source_ref_type_db_,
                                                                                   receipt_no_         => source_ref4_,
                                                                                   contract_           => contract_,
                                                                                   part_no_            => part_no_,
                                                                                   configuration_id_   => configuration_id_,
                                                                                   location_no_        => location_no_,
                                                                                   lot_batch_no_       => lot_batch_no_,
                                                                                   serial_no_          => serial_no_,
                                                                                   eng_chg_level_      => eng_chg_level_,
                                                                                   waiv_dev_rej_no_    => waiv_dev_rej_no_,
                                                                                   activity_seq_       => activity_seq_,
                                                                                   handling_unit_id_   => 0);
      $ELSE
        Error_SYS.Component_Not_Exist('RCEIPT');
      $END
   ELSE
      stock_rec_  := Inventory_Part_In_Stock_API.Get(contract_         => contract_, 
                                                     part_no_          => part_no_, 
                                                     configuration_id_ => configuration_id_, 
                                                     location_no_      => location_no_, 
                                                     lot_batch_no_     => lot_batch_no_, 
                                                     serial_no_        => serial_no_, 
                                                     eng_chg_level_    => eng_chg_level_,
                                                     waiv_dev_rej_no_  => waiv_dev_rej_no_,
                                                     activity_seq_     => activity_seq_, 
                                                     handling_unit_id_ => 0);
      qty_available_ := stock_rec_.qty_onhand - stock_rec_.qty_reserved;                                                     
   END IF;                                                             
                                                             
   IF (qty_to_connect_ > qty_available_) THEN
      Error_Sys.Record_General(lu_name_, 'TOMUCHTOPACK: Quantity to pack :P1 cannot be greater than the available quantity :P2.', 
                               qty_to_connect_, qty_available_);   

   END IF;
   
   max_quantity_capacity_ := Part_Handling_Unit_API.Get_Max_Quantity_Capacity(part_no_,
                                                                              handling_unit_type_id_,
                                                                              inventory_unit_meas_);
   
   IF (max_quantity_capacity_ > 0) THEN
      qty_left_to_connect_ := qty_to_connect_;
      
      LOOP
         IF (max_quantity_capacity_ <= qty_left_to_connect_) THEN
            qty_to_be_added_ := max_quantity_capacity_;
         ELSE
            qty_to_be_added_ := qty_left_to_connect_;
         END IF;
         
         Handling_Unit_API.New_With_Pack_Instr_Settings(handling_unit_id_        => handling_unit_id_,
                                                        handling_unit_type_id_   => handling_unit_type_id_,
                                                        packing_instruction_id_  => packing_instruction_id_, 
                                                        parent_handling_unit_id_ => parent_handling_unit_id_);
             
         Inventory_Part_In_Stock_API.Change_Handling_Unit_Id(contract_                      => contract_, 
                                                             part_no_                       => part_no_, 
                                                             configuration_id_              => configuration_id_, 
                                                             location_no_                   => location_no_, 
                                                             lot_batch_no_                  => lot_batch_no_, 
                                                             serial_no_                     => serial_no_, 
                                                             eng_chg_level_                 => eng_chg_level_,
                                                             waiv_dev_rej_no_               => waiv_dev_rej_no_,
                                                             activity_seq_                  => activity_seq_, 
                                                             old_handling_unit_id_          => 0, 
                                                             new_handling_unit_id_          => handling_unit_id_, 
                                                             quantity_                      => qty_to_be_added_, 
                                                             catch_quantity_                => NULL,
                                                             source_ref1_                   => source_ref1_,
                                                             source_ref2_                   => source_ref2_,
                                                             source_ref3_                   => source_ref3_,
                                                             source_ref4_                   => source_ref4_,
                                                             inv_trans_source_ref_type_db_  => inv_trans_source_ref_type_db_);
         handling_unit_rec_ := Handling_Unit_API.Get(handling_unit_id_);
         IF (handling_unit_rec_.generate_sscc_no = Fnd_Boolean_API.DB_TRUE AND handling_unit_rec_.sscc IS NULL ) THEN
            Handling_Unit_API.Create_Sscc(handling_unit_id_);
         END IF;
         
         qty_left_to_connect_                          := (qty_left_to_connect_ - qty_to_be_added_);
         handling_unit_id_tab_(rows_).handling_unit_id := handling_unit_id_;
         rows_ := rows_ + 1;
         EXIT WHEN qty_left_to_connect_ = 0;
      END LOOP;
   ELSE
      Error_SYS.Record_General(lu_name_, 'NOHUCAPACITY: No handling unit capacity defined for this combination of part number, unit of measure and handling unit type.');
   END IF;
END Pack_Stock_Record_Into_Hu_Type;


FUNCTION Pack_Stock_Into_Pack_Instr (
   message_                   IN CLOB,
   packing_instruction_id_    IN VARCHAR2) RETURN CLOB
IS
   count_                      NUMBER;
   name_arr_                   Message_SYS.name_table_clob;
   value_arr_                  Message_SYS.line_table_clob;
   row_                        PLS_INTEGER := 0;   
   stock_record_packed_        BOOLEAN;
   inventory_unit_meas_        INVENTORY_PART_TAB.unit_meas%TYPE;   
   handling_unit_id_tab_       Handling_Unit_API.Handling_Unit_Id_Tab;
   handling_unit_type_tab_     Handling_Unit_Type_API.Unit_Type_Tab;
   handling_unit_to_pack_tab_  Auto_Packing_Tab;
   
   TYPE Packing_Stock_Rec IS RECORD (
      contract                       inventory_part_in_stock_tab.contract%TYPE,
      part_no                        inventory_part_in_stock_tab.part_no%TYPE,
      configuration_id               inventory_part_in_stock_tab.configuration_id%TYPE,
      location_no                    inventory_part_in_stock_tab.location_no%TYPE,
      lot_batch_no                   inventory_part_in_stock_tab.lot_batch_no%TYPE,
      serial_no                      inventory_part_in_stock_tab.serial_no%TYPE,
      eng_chg_level                  inventory_part_in_stock_tab.eng_chg_level%TYPE,
      waiv_dev_rej_no                inventory_part_in_stock_tab.waiv_dev_rej_no%TYPE,
      activity_seq                   inventory_part_in_stock_tab.activity_seq%TYPE,      
      quantity                       inventory_part_in_stock_tab.qty_onhand%TYPE,
      source_ref1                    VARCHAR2(50),
      source_ref2                    VARCHAR2(50),
      source_ref3                    VARCHAR2(50),
      source_ref4                    VARCHAR2(50),
      inv_trans_source_ref_type_db_  VARCHAR2(50));
      
   TYPE Packing_Stock_Tab IS TABLE OF Packing_Stock_Rec
      INDEX BY PLS_INTEGER;
  
   packing_stock_tab_                Packing_Stock_Tab;
   message_out_                      CLOB;
BEGIN
   Message_SYS.Get_Clob_Attributes(message_, count_, name_arr_, value_arr_);   

   FOR n_ IN 1..count_ LOOP           
      IF (name_arr_(n_) = 'CONTRACT') THEN
         row_ := row_ + 1;
         packing_stock_tab_(row_).contract := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'PART_NO') THEN
         packing_stock_tab_(row_).part_no := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'CONFIGURATION_ID') THEN
         packing_stock_tab_(row_).configuration_id := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'LOCATION_NO') THEN
         packing_stock_tab_(row_).location_no := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'LOT_BATCH_NO') THEN
         packing_stock_tab_(row_).lot_batch_no := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'SERIAL_NO') THEN
         packing_stock_tab_(row_).serial_no := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'ENG_CHG_LEVEL') THEN
         packing_stock_tab_(row_).eng_chg_level := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'WAIV_DEV_REJ_NO') THEN
         packing_stock_tab_(row_).waiv_dev_rej_no := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'ACTIVITY_SEQ') THEN
         packing_stock_tab_(row_).activity_seq := Client_SYS.Attr_Value_To_Number(value_arr_(n_));
      ELSIF (name_arr_(n_) = 'QTY_ONHAND') THEN
         packing_stock_tab_(row_).quantity := Client_SYS.Attr_Value_To_Number(value_arr_(n_));
      ELSIF (name_arr_(n_) = 'SOURCE_REF1') THEN
         packing_stock_tab_(row_).source_ref1 := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'SOURCE_REF2') THEN
         packing_stock_tab_(row_).source_ref2 := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'SOURCE_REF3') THEN
         packing_stock_tab_(row_).source_ref3 := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'SOURCE_REF4') THEN
         packing_stock_tab_(row_).source_ref4 := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'INV_TRANS_SOURCE_REF_TYPE_DB') THEN
         packing_stock_tab_(row_).inv_trans_source_ref_type_db_ := value_arr_(n_);
      ELSE
         Error_SYS.Record_General(lu_name_, 'INVALID_ELEMENT: Message element :P1 is not valid when packing stock according to packing instruction.', name_arr_(n_));
      END IF;
   END LOOP;

   Inventory_Event_Manager_API.Start_Session;
   IF (packing_stock_tab_.COUNT > 0) THEN
      handling_unit_type_tab_ := Packing_Instruction_API.Get_Leaf_Nodes(packing_instruction_id_);
      IF (handling_unit_type_tab_.COUNT > 0) THEN
         row_ := 1;
         FOR i IN packing_stock_tab_.FIRST..packing_stock_tab_.LAST LOOP
            inventory_unit_meas_ := Inventory_Part_API.Get_Unit_Meas(packing_stock_tab_(i).contract, packing_stock_tab_(i).part_no);
            stock_record_packed_ := FALSE;
            FOR j IN handling_unit_type_tab_.FIRST..handling_unit_type_tab_.LAST LOOP
               IF (Part_Handling_Unit_API.Check_Operative(packing_stock_tab_(i).part_no,
                                                          handling_unit_type_tab_(j).handling_unit_type_id,
                                                          inventory_unit_meas_)) THEN
                  IF (stock_record_packed_) THEN
                     Error_SYS.Record_General('HandlUnitAutoPackUtil','HUTYPEDUPLICATE: There is more than one valid handling unit type for inventory unit :P1 of part :P2 in packing instruction :P3',
                                                                       inventory_unit_meas_, packing_stock_tab_(i).part_no, packing_instruction_id_);
                  END IF;                               
                  Pack_Stock_Record_Into_Hu_Type (handling_unit_id_tab_          => handling_unit_id_tab_,
                                                  contract_                      => packing_stock_tab_(i).contract,
                                                  part_no_                       => packing_stock_tab_(i).part_no,
                                                  configuration_id_              => packing_stock_tab_(i).configuration_id,
                                                  location_no_                   => packing_stock_tab_(i).location_no,
                                                  lot_batch_no_                  => packing_stock_tab_(i).lot_batch_no, 
                                                  serial_no_                     => packing_stock_tab_(i).serial_no, 
                                                  eng_chg_level_                 => packing_stock_tab_(i).eng_chg_level, 
                                                  waiv_dev_rej_no_               => packing_stock_tab_(i).waiv_dev_rej_no, 
                                                  activity_seq_                  => packing_stock_tab_(i).activity_seq, 
                                                  handling_unit_type_id_         => handling_unit_type_tab_(j).handling_unit_type_id,
                                                  qty_to_connect_                => packing_stock_tab_(i).quantity,
                                                  packing_instruction_id_        => packing_instruction_id_,
                                                  source_ref1_                   => packing_stock_tab_(i).source_ref1,
                                                  source_ref2_                   => packing_stock_tab_(i).source_ref2,
                                                  source_ref3_                   => packing_stock_tab_(i).source_ref3,
                                                  source_ref4_                   => packing_stock_tab_(i).source_ref4,
                                                  inv_trans_source_ref_type_db_  => packing_stock_tab_(i).inv_trans_source_ref_type_db_);
                  stock_record_packed_ := TRUE;                            
                                             
                  IF (handling_unit_id_tab_.COUNT > 0) THEN                  
                     FOR k IN handling_unit_id_tab_.FIRST..handling_unit_id_tab_.LAST LOOP 
                        handling_unit_to_pack_tab_(row_).handling_unit_id       := handling_unit_id_tab_(k).handling_unit_id;
                        handling_unit_to_pack_tab_(row_).handling_unit_type_id  := handling_unit_type_tab_(j).handling_unit_type_id;
                        handling_unit_to_pack_tab_(row_).packing_instruction_id := packing_instruction_id_;
                        row_ := row_ + 1;
                     END LOOP;
                  END IF;
                  EXIT;
               END IF;
            END LOOP;
            IF NOT (stock_record_packed_) THEN
               Error_SYS.Record_General('HandlUnitAutoPackUtil','NOHUTYPE: There is no valid handling unit type for inventory unit :P1 of part :P2 in packing instruction :P3',
                                                                 inventory_unit_meas_, packing_stock_tab_(i).part_no, packing_instruction_id_);
            END IF;
         END LOOP;
         
      END IF;   
   END IF;      

   IF (handling_unit_to_pack_tab_.COUNT > 0) THEN
      Auto_Pack_Hu_In_Parent(message_out_, handling_unit_to_pack_tab_, NULL);
   END IF;    
   
   FOR i_ IN handling_unit_id_tab_.FIRST..handling_unit_id_tab_.LAST LOOP
      Message_SYS.Add_Attribute(message_out_, 'HANDLING_UNIT_ID', handling_unit_id_tab_(i_).handling_unit_id);
   END LOOP;
            
   Inventory_Event_Manager_API.Finish_Session;
   RETURN message_out_;
END Pack_Stock_Into_Pack_Instr;

PROCEDURE Create_Handling_Unit_Structure (
   handling_unit_id_          OUT NUMBER,
   quantity_                  IN OUT VARCHAR2,
   part_no_                   IN VARCHAR2,
   source_ref_type_db_        IN VARCHAR2,
   source_ref1_               IN VARCHAR2,
   source_ref2_               IN VARCHAR2,
   source_ref3_               IN VARCHAR2,
   unit_code_                 IN VARCHAR2,
   packing_instruction_id_    IN VARCHAR2,
   parent_handling_unit_id_   IN NUMBER )
IS   
   leaf_handling_unit_id_tab_   Handling_Unit_API.Handling_Unit_Id_Tab;
   leaf_handling_unit_type_id_  VARCHAR2(25);
BEGIN
   Create_Handling_Unit_Structure(handling_unit_id_, 
                                  leaf_handling_unit_id_tab_,
                                  quantity_,
                                  leaf_handling_unit_type_id_,
                                  part_no_,
                                  source_ref_type_db_,
                                  source_ref1_,
                                  source_ref2_,
                                  source_ref3_,
                                  unit_code_,                                                                    
                                  packing_instruction_id_,
                                  parent_handling_unit_id_);
END Create_Handling_Unit_Structure;

PROCEDURE Create_Handling_Unit_Structure (
   handling_unit_id_           OUT NUMBER,
   leaf_handling_unit_id_tab_  IN OUT Handling_Unit_API.Handling_Unit_Id_Tab,
   quantity_                   IN OUT VARCHAR2,
   leaf_handling_unit_type_id_ IN OUT VARCHAR2,
   part_no_                    IN VARCHAR2,
   source_ref_type_db_         IN VARCHAR2,
   source_ref1_                IN VARCHAR2,
   source_ref2_                IN VARCHAR2,
   source_ref3_                IN VARCHAR2,
   unit_code_                  IN VARCHAR2,
   packing_instruction_id_     IN VARCHAR2,
   parent_handling_unit_id_    IN NUMBER,
   sscc_                       IN VARCHAR2 DEFAULT NULL,
   alt_handling_unit_label_id_ IN VARCHAR2 DEFAULT NULL)
IS 
   -- cursor returns the node structure for the given packing instruction id.
   -- the hierarchical structure starts with handling unit types defined in PART_HANDLING_UNIT_OPERATIVE
   -- which are defined in the lowest level in the packing instruction. hierarchy starts from the bottom 
   -- moves its way to the top. DISTINCT is used to limit same parent reaching from two leaf nodes. 
   CURSOR node_structure IS
      SELECT DISTINCT node_id,
                   parent_node_id,
                   handling_unit_type_id, 
                   quantity                
      FROM PACKING_INSTRUCTION_NODE_TAB t
      WHERE t.packing_instruction_id = packing_instruction_id_
      START WITH (t.handling_unit_type_id IN (SELECT handling_unit_type_id
                                                FROM PART_HANDLING_UNIT_OPERATIVE phu
                                               WHERE phu.part_no = part_no_
                                                 AND phu.unit_code = unit_code_) 
                  AND NOT EXISTS( SELECT 1 
                                    FROM PACKING_INSTRUCTION_NODE_TAB c 
                                   WHERE c.packing_instruction_id = t.packing_instruction_id 
                                     AND c.parent_node_id = t.node_id))
      CONNECT BY PRIOR t.parent_node_id = t.node_id AND PRIOR t.packing_instruction_id = t.packing_instruction_id
      ORDER SIBLINGS BY node_id;
   
   node_structure_tab_ PACKING_INSTRUCTION_NODE_API.Node_Tab;   
BEGIN
   IF (quantity_ > 0) THEN
      OPEN node_structure;
      FETCH node_structure BULK COLLECT INTO node_structure_tab_;
      CLOSE node_structure;  

      IF (node_structure_tab_.COUNT > 0) THEN
         Create_Handling_Unit_Struct___(handling_unit_id_,
                                        leaf_handling_unit_id_tab_,
                                        quantity_,
                                        leaf_handling_unit_type_id_,
                                        part_no_,
                                        source_ref_type_db_,
                                        source_ref1_,
                                        source_ref2_,
                                        source_ref3_,
                                        unit_code_,                                                                    
                                        parent_handling_unit_id_,
                                        packing_instruction_id_,
                                        NULL,
                                        node_structure_tab_,
                                        sscc_,
                                        alt_handling_unit_label_id_);
      END IF;
   END IF;
END Create_Handling_Unit_Structure;

@UncheckedAccess
FUNCTION Get_No_Of_Pack_Instr_Top_Nodes (
   packing_instruction_id_     IN VARCHAR2,
   part_no_                    IN VARCHAR2,
   unit_code_                  IN VARCHAR2,
   quantity_to_pack_           IN NUMBER) RETURN NUMBER
IS 
   max_quantity_capacity_   NUMBER;
   no_of_handling_units_    NUMBER;
   no_of_parent_handling_units_    NUMBER;
   handling_unit_type_tab_  Handling_Unit_Type_API.Unit_Type_Tab;
   handling_unit_type_id_   VARCHAR2(25);
   node_id_                 NUMBER;
   packing_node_rec_        Packing_Instruction_Node_API.Public_Rec;
BEGIN
   handling_unit_type_tab_ := Packing_Instruction_API.Get_Leaf_Nodes(packing_instruction_id_);
   IF (handling_unit_type_tab_.COUNT > 0) THEN
      FOR i IN handling_unit_type_tab_.FIRST..handling_unit_type_tab_.LAST LOOP
         max_quantity_capacity_ := Part_Handling_Unit_API.Get_Max_Quantity_Capacity(part_no_,
                                                                                    handling_unit_type_tab_(i).handling_unit_type_id,
                                                                                    unit_code_);
         IF (max_quantity_capacity_ IS NOT NULL) THEN   
            handling_unit_type_id_ := handling_unit_type_tab_(i).handling_unit_type_id; 
            EXIT;
         END IF;
      END LOOP;   
   END IF;
   IF (NVL(max_quantity_capacity_, 0) != 0) THEN 
      no_of_handling_units_ := CEIL(quantity_to_pack_ / max_quantity_capacity_);
      node_id_ := Packing_Instruction_Node_API.Get_Node_Id(packing_instruction_id_, handling_unit_type_id_);
      packing_node_rec_ := Packing_Instruction_Node_API.Get(packing_instruction_id_, node_id_);
      WHILE (packing_node_rec_.node_id IS NOT NULL) LOOP
         no_of_parent_handling_units_ :=  CEIL(no_of_handling_units_ / packing_node_rec_.quantity);  
         packing_node_rec_ := Packing_Instruction_Node_API.Get(packing_instruction_id_, packing_node_rec_.parent_node_id);
         no_of_handling_units_ := no_of_parent_handling_units_;
      END LOOP;
   END IF;
   RETURN no_of_handling_units_;  
END Get_No_Of_Pack_Instr_Top_Nodes;

    
PROCEDURE Auto_Pack_Hu_In_Parent (
   message_                    IN OUT   CLOB,
   handling_unit_to_pack_tab_  IN Auto_Packing_Tab,
   shipment_id_                IN NUMBER )
IS
   dummy_tab_ Auto_Packing_Tab;
BEGIN
   Auto_Pack_Hu_In_Parent___(message_, handling_unit_to_pack_tab_, dummy_tab_, shipment_id_);
END Auto_Pack_Hu_In_Parent;

