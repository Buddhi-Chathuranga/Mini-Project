-----------------------------------------------------------------------------
--
--  Logical unit: PackingInstructionNode
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign     History
--  ------  ------   ---------------------------------------------------------
--  200528  UdGnlk   Bug 153793 (SCZ-10016), Modified Get_Flags_For_Node_And_Parents() to check NULL condition value before retrieval.
--  170404  Jhalse   LIM-11076, Modified Leaf_Node_For_Part_Exists to also check for inherited capacity groups.
--  170209  Maeelk   LIM-STRSC-5375, Added default value of PRINT_CONTENT_LABEL, PRINT_SHIPMENT_LABEL, NO_OF_CONTENT_LABELS and  NO_OF_SHIPMENT_LABELS to Check_Insert___.
--  161214  RALASE   LIM-9321, Added method Get_Nodes_From_Hu_Type_Id() which returns a node and child nodes from HANDLING_UNIT_TYPE_ID in a node structure.
--  161021  DaZase   LIM-7326, Added PRINT_CONTENT_LABEL_DB and PRINT_SHIPMENT_LABEL_DB to Get_Flags_For_Node_And_Parents and 
--  161021           Get_Flags_For_Node, plus also refactored these methods and removed unnessary Encode calls.
--  161020  DaZase   LIM-7326, Modified Prepare_Insert___() to add default values PRINT_CONTENT_LABEL_DB, NO_OF_CONTENT_LABELS,
--  161020           PRINT_SHIPMENT_LABEL_DB and NO_OF_SHIPMENT_LABELS. Added checks for NO_OF_CONTENT_LABELS and NO_OF_SHIPMENT_LABELS in Check_Insert___ and Check_Update___.
--  160727  RaKAlk   LIM-7993, Added PLSQL table Node_Tab.
--  160226  UdGnlk   LIM-6224, Renamed implementation method Child_Node_Exist___() to private method Child_Node_Exist__(). Moved Get_Handling_Unit_Type_Id()
--  160226           to PackingInstruction Lu and renamed it.
--  160118  UdGnlk   LIM-5364, Added Leaf_Node_For_Part_Exists() to get the lowest level Handling Unit Types and its existence in Handling Unit Capacities.  
--  160107  MaEelk   LIM-5388, Added Hu_Type_Exist_As_Leaf_Node to check if the Handling_Unit_Type_Id exists as a leaf node of the given packing instruction.
--  150901  MaEelk   Bug 124141, Passed shipment_id to the recursive method call Add_Handling_Unit_Struct_Node inside Add_Handling_Unit_Struct_Node.
--  140225  HimRlk   Modified Add_Handling_Unit_Struct_Node by adding default null parameter shipment_id.
--  140219  MAHPLK   Added new attribute no_of_handling_unit_labels.
--  130822  JeLise   Added new method Get_Flags_For_Node to get the flag for on specific node id.
--  130820  JeLise   Added packing_instruction_id_ as parameter in call to Handling_Unit_API.New.
--  130516  JeLise   Added new methods Get_Parent_Handl_Unit_Type_Id and Get_Node_Id. In Add_Handling_Unit_Struct_Node the call to Handling_Unit_API.New 
--  130516           has been changed and the call to Pack_Instr_Node_Accessory_API.Add_Accesories_To_Handl_Unit has been removed.
--  130516  MeAblk   Added new method Check_Handling_Unit_Type___ and modified Unpack_Check_Update___ and Unpack_Check_Insert___ in order to avoid inserting same Handling Unit Type more than once.
--  130422  JeLise   Added new methods Get_Handling_Unit_Type_Id and Child_Node_Exist___.
--  130327  MeAblk   Added new parameters into the method call Handling_Unit_API.New.
--  130308  MeAblk   Removed methods Modify_Child_Mix_Part_No___ , Modify_Child_Mix_Lot_Batch___ , Modify_Child_Mix_Cond_Code___ .
--  130223  MeAblk   Added methods Add_Handling_Unit_Struct_Node and Get_Root_Node_Id.
--  130123  MeAblk   Implemented new methods Modify_Parent_Node_Id___,Remove_Structure and Remove in order to handle the different ways of deleting nodes.
--  130123  MeAblk   And modified Delete___ accordingly.
--  130117  MeAblk   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE Node_Rec IS RECORD (
   node_id Packing_Instruction_Node_Tab.node_id%TYPE,
   parent_node_id Packing_Instruction_Node_Tab.parent_node_id%TYPE,
   handling_unit_type_id Packing_Instruction_Node_Tab.handling_unit_type_id%TYPE,
   quantity Packing_Instruction_Node_Tab.quantity%TYPE
   );

TYPE Node_Tab IS TABLE OF Node_Rec INDEX BY PLS_INTEGER;
-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Single_Node_Exist___
--   This method check whether atleast a single node availabe in the packing instruction.
FUNCTION Single_Node_Exist___ (
   packing_instruction_id_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   number_of_nodes_   NUMBER;
   single_node_exist_ BOOLEAN := FALSE;
   CURSOR exist_node IS
      SELECT COUNT(node_id)
      FROM PACKING_INSTRUCTION_NODE_TAB
      WHERE packing_instruction_id = packing_instruction_id_;     
BEGIN
   OPEN exist_node;
   FETCH exist_node INTO number_of_nodes_ ;
   IF (number_of_nodes_ = 1) THEN
      single_node_exist_ := TRUE;
   END IF;
   CLOSE exist_node;
   RETURN(single_node_exist_);
END Single_Node_Exist___;   


-- Check_Structure___
--   Gives an error if a handling unit is parent/child of its own structure.
PROCEDURE Check_Structure___ (
   packing_instruction_id_ IN VARCHAR2,
   node_id_                IN NUMBER,
   parent_node_id_         IN NUMBER,
   handling_unit_type_id_  IN VARCHAR2 )
IS
   temp_              NUMBER;
   CURSOR check_node IS
      SELECT 1
      FROM dual
      WHERE handling_unit_type_id_ IN
         (SELECT handling_unit_type_id
          FROM  (SELECT * FROM PACKING_INSTRUCTION_NODE_TAB WHERE packing_instruction_id = packing_instruction_id_)
          CONNECT BY     PRIOR parent_node_id = node_id   
          START WITH     node_id              = parent_node_id_) 
         OR
          handling_unit_type_id_ IN
          (SELECT handling_unit_type_id
           FROM  (SELECT * FROM packing_instruction_node_tab WHERE packing_instruction_id = packing_instruction_id_)
           CONNECT BY     PRIOR node_id    = parent_node_id   
           START WITH     parent_node_id   = node_id_);
BEGIN
   IF (node_id_ = parent_node_id_) THEN
      Error_Sys.Record_General(lu_name_, 'SELFPARENTNODE: A node cannot have itself as a parent.');
   ELSE
      OPEN  check_node;
      FETCH check_node INTO temp_;
      IF (check_node%FOUND) THEN
         CLOSE check_node;
         Error_Sys.Record_General(lu_name_, 'CHILDPARENTNODE: This Handling Unit Type ID cannot be added to this level of the structure since it is already added in other levels.');
      ELSE
         CLOSE check_node;
      END IF;
   END IF;
END Check_Structure___;


PROCEDURE Modify_Parent_Node_Id___ (
   packing_instruction_id_ IN VARCHAR2,
   node_id_                IN NUMBER,
   new_parent_node_id_     IN NUMBER,
   check_structure_        IN BOOLEAN )
IS
   oldrec_      PACKING_INSTRUCTION_NODE_TAB%ROWTYPE;
   newrec_      PACKING_INSTRUCTION_NODE_TAB%ROWTYPE;
   attr_        VARCHAR2(2000);
   objid_       PACKING_INSTRUCTION_NODE.objid%TYPE;
   objversion_  PACKING_INSTRUCTION_NODE.objversion%TYPE;
   number_null_ CONSTANT NUMBER := -9999999999;
   indrec_      Indicator_Rec;
BEGIN
   
   oldrec_ := Lock_By_Keys___(packing_instruction_id_, node_id_);
   IF (NVL(new_parent_node_id_, number_null_) != NVL(oldrec_.parent_node_id, number_null_)) THEN
      newrec_ := oldrec_;
      Client_SYS.Add_to_Attr('PARENT_NODE_ID', new_parent_node_id_, attr_);
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_, check_structure_);
      Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
   END IF;
END Modify_Parent_Node_Id___;  


FUNCTION Get_Next_Node_Id___ (
   packing_instruction_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   next_node_id_ NUMBER;
   dummy_        NUMBER;
   CURSOR get_node_id IS
      SELECT NVL(max(node_id), 0)
      FROM PACKING_INSTRUCTION_NODE_TAB
      WHERE packing_instruction_id = packing_instruction_id_;
BEGIN
   OPEN get_node_id;
   FETCH get_node_id INTO dummy_;
   CLOSE get_node_id;
   next_node_id_ := dummy_ + 1;
   RETURN next_node_id_;    
END Get_Next_Node_Id___;   


FUNCTION Get_Old_Root_Node_Id___ (
   packing_instruction_id_ IN VARCHAR2,
   new_root_node_id_       IN NUMBER ) RETURN NUMBER
IS
   node_id_ NUMBER;
   CURSOR  get_root_node IS
      SELECT node_id
      FROM PACKING_INSTRUCTION_NODE_TAB
      WHERE packing_instruction_id = packing_instruction_id_
      AND   node_id               != new_root_node_id_
      AND   parent_node_id        IS NULL;     
BEGIN
   OPEN get_root_node;
   FETCH get_root_node INTO node_id_;
   CLOSE get_root_node;
   RETURN node_id_;
END Get_Old_Root_Node_Id___;    


PROCEDURE Check_Root_Node_Delete___ (
   packing_instruction_id_ IN VARCHAR2 )
IS
   delete_root_ BOOLEAN := TRUE;
   child_count_ NUMBER := 0;
   CURSOR get_children IS
      SELECT node_id, quantity
      FROM PACKING_INSTRUCTION_NODE_TAB
      WHERE packing_instruction_id = packing_instruction_id_ 
      AND   parent_node_id IS NOT NULL 
      AND   parent_node_id IN (SELECT node_id
                               FROM PACKING_INSTRUCTION_NODE_TAB
                               WHERE packing_instruction_id = packing_instruction_id_
                               AND   parent_node_id         IS NULL);
BEGIN
   FOR child_rec_ IN get_children LOOP
      IF (child_rec_.quantity > 1) THEN
         delete_root_ := FALSE;
         EXIT;
      ELSIF (child_count_ > 1) THEN
         delete_root_ := FALSE;
         EXIT;         
      END IF;   
      child_count_ := child_count_ + 1;
   END LOOP;  
   IF (child_count_ > 1) THEN
       delete_root_ := FALSE;
   END IF;       
   IF (NOT delete_root_) THEN
      Error_SYS.Record_General(lu_name_, 'ROOTNODEREMOVE: Cannot remove the root node since the sub-level consists of more than one child node or the quantity on the child node is bigger than 1.');
   END IF;   
END Check_Root_Node_Delete___;   


PROCEDURE Remove___ (
   packing_instruction_id_ IN VARCHAR2,
   node_id_                IN NUMBER )
IS
   objid_      PACKING_INSTRUCTION_NODE.objid%TYPE;
   objversion_ PACKING_INSTRUCTION_NODE.objversion%TYPE;
   remrec_     PACKING_INSTRUCTION_NODE_TAB%ROWTYPE;
BEGIN

   remrec_ := Lock_By_Keys___(packing_instruction_id_, node_id_);

   Check_Delete___(remrec_);
   Get_Id_Version_By_Keys___(objid_, objversion_, packing_instruction_id_, node_id_);
   Delete___(objid_, remrec_);
END Remove___;   


PROCEDURE Remove_Structure___ (
   packing_instruction_id_ IN VARCHAR2,
   node_id_                IN NUMBER )
IS
   CURSOR get_children IS
      SELECT node_id
      FROM PACKING_INSTRUCTION_NODE_TAB
      WHERE packing_instruction_id = packing_instruction_id_
      AND   parent_node_id = node_id_;
BEGIN
   
   FOR rec_ IN get_children LOOP
      Remove_Structure___(packing_instruction_id_, rec_.node_id);
   END LOOP;
   Remove___(packing_instruction_id_, node_id_);
END Remove_Structure___;   


PROCEDURE Check_Quantity___ (
   parent_node_id_ IN NUMBER,
   quantity_       IN NUMBER)
IS
BEGIN
   
   IF (parent_node_id_ IS NULL AND quantity_ != 1) THEN
      Error_SYS.Record_General(lu_name_, 'IDENTICALROOTNODES: Number of units of the root node must be 1.');   
   ELSIF ((quantity_ <= 0) OR (quantity_ != ROUND(quantity_))) THEN
      Error_SYS.Record_General(lu_name_, 'NODEQTYFORMAT: Number of units must be a positive integer.');       
   END IF;   
END Check_Quantity___;   


FUNCTION Root_Node_Exist___ (
   packing_instruction_id_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_      NUMBER;
   root_exist_ BOOLEAN := FALSE;
   CURSOR check_root_node IS
      SELECT 1
      FROM PACKING_INSTRUCTION_NODE_TAB
      WHERE packing_instruction_id = packing_instruction_id_
      AND   parent_node_id         IS NULL;      
BEGIN
   OPEN check_root_node;
   FETCH check_root_node INTO dummy_;
   IF (check_root_node%FOUND) THEN
      root_exist_ := TRUE;
   END IF;  
   CLOSE check_root_node;
   RETURN root_exist_;
END Root_Node_Exist___;  


FUNCTION Get_Root_Node_Count___ (
   packing_instruction_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   count_ NUMBER;
   CURSOR get_root_node_count IS
      SELECT COUNT(node_id)
      FROM PACKING_INSTRUCTION_NODE_TAB
      WHERE packing_instruction_id = packing_instruction_id_
      AND   parent_node_id         IS NULL;       
BEGIN
   OPEN get_root_node_count;
   FETCH get_root_node_count INTO count_;
   CLOSE get_root_node_count;
   RETURN count_;
END Get_Root_Node_Count___;   


FUNCTION Get_Root_Node_Id___ (
   packing_instruction_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   node_id_ NUMBER;
   CURSOR  get_root_node IS
      SELECT NVL(node_id, 0)
      FROM PACKING_INSTRUCTION_NODE_TAB
      WHERE packing_instruction_id = packing_instruction_id_
      AND   parent_node_id         IS NULL;     
BEGIN
   OPEN get_root_node;
   FETCH get_root_node INTO node_id_;
   CLOSE get_root_node;
   RETURN node_id_;
END Get_Root_Node_Id___;   


FUNCTION Get_Parent_Node_Id___ (
   packing_instruction_id_ IN VARCHAR2,
   node_id_                IN NUMBER ) RETURN NUMBER
IS
   dummy_ NUMBER;
   CURSOR get_parent_node_id IS
      SELECT parent_node_id
      FROM PACKING_INSTRUCTION_NODE_TAB
      WHERE packing_instruction_id = packing_instruction_id_
      AND   node_id                = node_id_;
BEGIN
   OPEN get_parent_node_id;
   FETCH get_parent_node_id INTO dummy_;
   CLOSE get_parent_node_id;
   RETURN dummy_;
END Get_Parent_Node_Id___;   


PROCEDURE Check_Handling_Unit_Type___ (
   packing_instruction_id_ IN VARCHAR2,
   handling_unit_type_id_  IN VARCHAR2 )
IS
   temp_ NUMBER;
   CURSOR check_handling_unit IS
      SELECT 1
      FROM PACKING_INSTRUCTION_NODE_TAB
      WHERE packing_instruction_id = packing_instruction_id_
      AND   handling_unit_type_id  = handling_unit_type_id_;
BEGIN
   OPEN  check_handling_unit;
   FETCH check_handling_unit INTO temp_;
   IF (check_handling_unit%FOUND) THEN
      Error_SYS.Record_General(lu_name_, 'HANDLINGUNITTYPEEXIST: Handling Unit Type :P1 already exist in the Packing Instruction :P2.', handling_unit_type_id_, packing_instruction_id_);      
   END IF;   
   CLOSE check_handling_unit;
END Check_Handling_Unit_Type___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('GENERATE_SSCC_NO_DB',         Fnd_Boolean_API.DB_FALSE, attr_);
   Client_SYS.Add_To_Attr('MIX_OF_PART_NO_BLOCKED_DB',   Fnd_Boolean_API.DB_FALSE, attr_);
   Client_SYS.Add_To_Attr('MIX_OF_LOT_BATCH_BLOCKED_DB', Fnd_Boolean_API.DB_FALSE, attr_);
   Client_SYS.Add_To_Attr('MIX_OF_COND_CODE_BLOCKED_DB', Fnd_Boolean_API.DB_FALSE, attr_);
   Client_SYS.Add_To_Attr('PRINT_LABEL_DB',              Fnd_Boolean_API.DB_FALSE, attr_);
   Client_SYS.Add_To_Attr('NO_OF_HANDLING_UNIT_LABELS',  1,                        attr_);
   Client_SYS.Add_To_Attr('PRINT_CONTENT_LABEL_DB',      Fnd_Boolean_API.DB_FALSE, attr_);
   Client_SYS.Add_To_Attr('NO_OF_CONTENT_LABELS',        1,                        attr_);
   Client_SYS.Add_To_Attr('PRINT_SHIPMENT_LABEL_DB',     Fnd_Boolean_API.DB_FALSE, attr_);
   Client_SYS.Add_To_Attr('NO_OF_SHIPMENT_LABELS',       1,                        attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT PACKING_INSTRUCTION_NODE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   old_root_node_id_ NUMBER;
BEGIN
   newrec_.node_id    := Get_Next_Node_Id___(newrec_.packing_instruction_id);  
   super(objid_, objversion_, newrec_, attr_);
   
   IF (newrec_.parent_node_id IS NULL AND (NOT Single_Node_Exist___(newrec_.packing_instruction_id))) THEN
      old_root_node_id_ := Get_Old_Root_Node_Id___(newrec_.packing_instruction_id, newrec_.node_id); 
      IF (old_root_node_id_ IS NOT NULL) THEN
         Modify_Parent_Node_Id___(newrec_.packing_instruction_id, old_root_node_id_, newrec_.node_id, TRUE);         
      END IF;         
   END IF;   
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN PACKING_INSTRUCTION_NODE_TAB%ROWTYPE )
IS
BEGIN
   IF (remrec_.parent_node_id IS NULL) THEN
      Check_Root_Node_Delete___(remrec_.packing_instruction_id);
   END IF;   
   super(remrec_);
END Check_Delete___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN PACKING_INSTRUCTION_NODE_TAB%ROWTYPE )
IS
   CURSOR get_children IS
      SELECT node_id
      FROM PACKING_INSTRUCTION_NODE_TAB
      WHERE packing_instruction_id = remrec_.packing_instruction_id
      AND   parent_node_id         = remrec_.node_id;
BEGIN
   super(objid_, remrec_);
   
   FOR rec_ IN get_children LOOP
      -- This transfers the parent reference of the removed node to its children.
      -- IF the removed node did not have any parent then the children will be new top nodes
      Modify_Parent_Node_Id___(remrec_.packing_instruction_id, rec_.node_id, remrec_.parent_node_id, FALSE);
   END LOOP;
END Delete___;


   


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT packing_instruction_node_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_             VARCHAR2(30);
   value_            VARCHAR2(4000);
   old_root_node_id_ NUMBER;
BEGIN
   IF NOT(indrec_.print_content_label) THEN
      newrec_.print_content_label := Fnd_Boolean_API.DB_FALSE;
   END IF;
   
   IF NOT(indrec_.no_of_content_labels) THEN
      newrec_.no_of_content_labels := 1;
   END IF;
   
   IF NOT(indrec_.print_shipment_label) THEN
      newrec_.print_shipment_label := Fnd_Boolean_API.DB_FALSE;
   END IF;
   
   IF NOT(indrec_.no_of_shipment_labels) THEN
      newrec_.no_of_shipment_labels := 1;
   END IF;   
   
   super(newrec_, indrec_, attr_);
   
   Check_Quantity___(newrec_.parent_node_id, newrec_.quantity); 
   Check_Handling_Unit_Type___(newrec_.packing_instruction_id, newrec_.handling_unit_type_id);
   
   IF (newrec_.parent_node_id IS NOT NULL) THEN
      Check_Structure___(newrec_.packing_instruction_id, newrec_.node_id, newrec_.parent_node_id, newrec_.handling_unit_type_id);   
   ELSE
      old_root_node_id_ := Get_Root_Node_Id___(newrec_.packing_instruction_id);
      Check_Structure___(newrec_.packing_instruction_id, newrec_.node_id, old_root_node_id_, newrec_.handling_unit_type_id);      
   END IF;   
   IF (newrec_.no_of_handling_unit_labels < 1) THEN
      Error_SYS.Record_General(lu_name_, 'NOHULABELFORMAT: No of Handling Unit Labels must be greater than or equal to 1.');   
   END IF;
   IF (newrec_.no_of_content_labels < 1) THEN
      Error_SYS.Record_General(lu_name_, 'NOHUCONTENTLABELFORMAT: No of Handling Unit Content Labels must be greater than or equal to 1.');   
   END IF;
   IF (newrec_.no_of_shipment_labels < 1) THEN
      Error_SYS.Record_General(lu_name_, 'NOSHIPMENTHULABELFORMAT: No of Shipment Handling Unit Labels must be greater than or equal to 1.');   
   END IF;

EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     packing_instruction_node_tab%ROWTYPE,
   newrec_ IN OUT packing_instruction_node_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2,
   check_structure_ IN     BOOLEAN DEFAULT TRUE )
IS
   name_            VARCHAR2(30);
   value_           VARCHAR2(4000);
   number_null_     NUMBER := -9999999;
   root_node_count_ NUMBER;
   root_node_exist_ BOOLEAN := FALSE;
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   
   IF (newrec_.parent_node_id IS NOT NULL AND oldrec_.parent_node_id IS NULL) THEN
      root_node_count_ := Get_Root_Node_Count___(newrec_.packing_instruction_id);
      IF (root_node_count_ != 2) THEN
         Error_Sys.Record_General(lu_name_, 'CHANGEROOTNODE: The root node cannot be converted into a sub-node.');   
      END IF;   
   END IF;    
   
   IF (newrec_.parent_node_id IS NULL AND oldrec_.parent_node_id IS NOT NULL) THEN
      root_node_exist_ := Root_Node_Exist___(newrec_.packing_instruction_id);
      IF (root_node_exist_) THEN
         Error_Sys.Record_General(lu_name_, 'CONVERTROOTNODE: A sub-node cannot be converted into a root node.');  
      END IF;         
   END IF;      
   
   IF (newrec_.quantity != oldrec_.quantity) THEN
      Check_Quantity___(newrec_.parent_node_id,  newrec_.quantity);
   END IF;   
   IF (newrec_.handling_unit_type_id != oldrec_.handling_unit_type_id) THEN   
      Check_Handling_Unit_Type___(newrec_.packing_instruction_id, newrec_.handling_unit_type_id);
   END IF;
   
   IF (check_structure_ AND (NVL(newrec_.parent_node_id, number_null_) != NVL(oldrec_.parent_node_id, number_null_) 
   AND newrec_.parent_node_id IS NOT NULL AND oldrec_.parent_node_id IS NOT NULL) 
   OR (newrec_.handling_unit_type_id != oldrec_.handling_unit_type_id)) THEN
      Check_Structure___(newrec_.packing_instruction_id, newrec_.node_id, newrec_.parent_node_id, newrec_.handling_unit_type_id);            
   END IF;   
   IF (oldrec_.no_of_handling_unit_labels != newrec_.no_of_handling_unit_labels) AND (newrec_.no_of_handling_unit_labels < 1) THEN
      Error_SYS.Record_General(lu_name_, 'NOHULABELFORMAT: No of Handling Unit Labels must be greater than or equal to 1.');   
   END IF;
   IF (oldrec_.no_of_content_labels != newrec_.no_of_content_labels) AND (newrec_.no_of_content_labels < 1) THEN
      Error_SYS.Record_General(lu_name_, 'NOHUCONTENTLABELFORMAT: No of Handling Unit Content Labels must be greater than or equal to 1.');   
   END IF;
   IF (oldrec_.no_of_shipment_labels != newrec_.no_of_shipment_labels) AND (newrec_.no_of_shipment_labels < 1) THEN
      Error_SYS.Record_General(lu_name_, 'NOSHIPMENTHULABELFORMAT: No of Shipment Handling Unit Labels must be greater than or equal to 1.');   
   END IF;

EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@Override
PROCEDURE Remove__ (
   info_       OUT VARCHAR2,
   objid_      IN  VARCHAR2,
   objversion_ IN  VARCHAR2,
   action_     IN  VARCHAR2 )
IS
   remrec_             PACKING_INSTRUCTION_NODE_TAB%ROWTYPE;
   dummy_              PACKING_INSTRUCTION_NODE.objid%TYPE;
   current_objversion_ PACKING_INSTRUCTION_NODE.objversion%TYPE;
BEGIN
   IF (action_ = 'DO') THEN
      remrec_ := Get_Object_By_Id___(objid_);
      Get_Id_Version_By_Keys___(dummy_, current_objversion_, remrec_.packing_instruction_id, remrec_.node_id);      
   END IF;
   super(info_, objid_, current_objversion_, action_);
END Remove__;

FUNCTION Child_Node_Exist__ (
   packing_instruction_id_ IN VARCHAR2,
   node_id_                IN NUMBER ) RETURN NUMBER
IS
   dummy_ NUMBER;
   CURSOR exist_child IS
      SELECT 1
      FROM PACKING_INSTRUCTION_NODE_TAB
      WHERE packing_instruction_id = packing_instruction_id_
      AND   parent_node_id         = node_id_;
BEGIN
   OPEN exist_child;
   FETCH exist_child INTO dummy_;
   CLOSE exist_child;
   RETURN NVL(dummy_, 0);   
END Child_Node_Exist__;
-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Remove_Complete_Structure (
   packing_instruction_id_ IN VARCHAR2 )
IS
   root_node_id_ PACKING_INSTRUCTION_NODE_TAB.node_id%TYPE;

   CURSOR get_root_node_id IS
      SELECT node_id
      FROM PACKING_INSTRUCTION_NODE_TAB
      WHERE packing_instruction_id = packing_instruction_id_
      AND   parent_node_id         IS NULL;
BEGIN

   OPEN get_root_node_id;
   FETCH get_root_node_id INTO root_node_id_;
   CLOSE get_root_node_id;

   IF (root_node_id_ IS NOT NULL) THEN
      Remove_Structure___(packing_instruction_id_, root_node_id_);
   END IF;
END Remove_Complete_Structure;


@UncheckedAccess
FUNCTION Get_Level_No (
   packing_instruction_id_ IN VARCHAR2,
   node_id_                IN NUMBER ) RETURN NUMBER
IS
   level_no_ NUMBER;
   CURSOR get_node_hierarchy IS
      SELECT COUNT(node_id)
      FROM (SELECT * FROM PACKING_INSTRUCTION_NODE_TAB WHERE packing_instruction_id =  packing_instruction_id_) 
      CONNECT BY node_id = PRIOR parent_node_id
      START WITH node_id = node_id_;      
BEGIN
   OPEN get_node_hierarchy;
   FETCH get_node_hierarchy INTO level_no_;
   CLOSE get_node_hierarchy;
   RETURN level_no_;  
END  Get_Level_No;  


@UncheckedAccess
FUNCTION Node_Exist (
   packing_instruction_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   node_exist_ NUMBER := 0;
   CURSOR check_node IS
      SELECT 1
      FROM PACKING_INSTRUCTION_NODE_TAB
      WHERE packing_instruction_id = packing_instruction_id_
      AND   node_id                IS NOT NULL;      
BEGIN
   OPEN check_node;
   FETCH check_node INTO node_exist_;
   CLOSE check_node;
   RETURN node_exist_;
END Node_Exist;    


PROCEDURE Add_Handling_Unit_Struct_Node (
   handling_unit_id_        OUT NUMBER,
   packing_instruction_id_  IN  VARCHAR2,
   node_id_                 IN  NUMBER,
   parent_handling_unit_id_ IN  NUMBER,
   shipment_id_             IN  NUMBER DEFAULT NULL )
IS
   node_rec_ packing_instruction_node_tab%ROWTYPE;
   dummy_    NUMBER;

   CURSOR get_children IS
      SELECT  node_id
      FROM PACKING_INSTRUCTION_NODE_TAB
      WHERE packing_instruction_id = packing_instruction_id_
      AND   parent_node_id         = node_id_;    
BEGIN

   node_rec_ := Get_Object_By_Keys___(packing_instruction_id_, node_id_);
   
   FOR counter_ IN 1..node_rec_.quantity LOOP
      Handling_Unit_API.New_With_Pack_Instr_Settings(handling_unit_id_        => handling_unit_id_, 
                                                     handling_unit_type_id_   => node_rec_.handling_unit_type_id, 
                                                     packing_instruction_id_  => packing_instruction_id_,
                                                     parent_handling_unit_id_ => parent_handling_unit_id_, 
                                                     shipment_id_             => shipment_id_);

      FOR child_rec_ IN get_children LOOP
         Add_Handling_Unit_Struct_Node(dummy_, 
                                       packing_instruction_id_, 
                                       child_rec_.node_id, 
                                       handling_unit_id_,
                                       shipment_id_);
      END LOOP;      
   END LOOP;
END Add_Handling_Unit_Struct_Node;


@UncheckedAccess
FUNCTION Get_Root_Node_Id (
   packing_instruction_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   root_node_id_ NUMBER;
BEGIN
   root_node_id_ := Get_Root_Node_Id___(packing_instruction_id_);  
   RETURN root_node_id_; 
END Get_Root_Node_Id;   


@UncheckedAccess
FUNCTION Get_Node_Id (
   packing_instruction_id_ IN VARCHAR2,
   handling_unit_type_id_  IN VARCHAR2 ) RETURN NUMBER 
IS
   node_id_ PACKING_INSTRUCTION_NODE_TAB.node_id%TYPE;
   CURSOR get_node_id IS
      SELECT node_id
      FROM PACKING_INSTRUCTION_NODE_TAB
      WHERE packing_instruction_id = packing_instruction_id_
      AND   handling_unit_type_id  = handling_unit_type_id_;
BEGIN
   OPEN get_node_id;
   FETCH get_node_id INTO node_id_;
   CLOSE get_node_id;
   
   RETURN node_id_;
END Get_Node_Id;


@UncheckedAccess
FUNCTION Get_Parent_Handl_Unit_Type_Id (
   packing_instruction_id_ IN VARCHAR2,
   handling_unit_type_id_  IN VARCHAR2 ) RETURN VARCHAR2 
IS
   node_id_                      PACKING_INSTRUCTION_NODE_TAB.node_id%TYPE;
   parent_node_id_               PACKING_INSTRUCTION_NODE_TAB.node_id%TYPE;
   parent_handling_unit_type_id_ PACKING_INSTRUCTION_NODE_TAB.handling_unit_type_id%TYPE;
BEGIN
   node_id_                      := Get_Node_Id(packing_instruction_id_,
                                                handling_unit_type_id_);
   parent_node_id_               := Get_Parent_Node_Id___(packing_instruction_id_,
                                                          node_id_);
   parent_handling_unit_type_id_ := Get_Handling_Unit_Type_Id(packing_instruction_id_, 
                                                              parent_node_id_);
   
   RETURN parent_handling_unit_type_id_;
END Get_Parent_Handl_Unit_Type_Id;


PROCEDURE Get_Flags_For_Node_And_Parents (
   generate_sscc_no_db_         IN OUT VARCHAR2, 
   print_label_db_              IN OUT VARCHAR2,
   print_content_label_db_      IN OUT VARCHAR2,
   print_shipment_label_db_     IN OUT VARCHAR2,
   mix_of_cond_code_blocked_db_ IN OUT VARCHAR2,
   mix_of_lot_batch_blocked_db_ IN OUT VARCHAR2,
   mix_of_part_no_blocked_db_   IN OUT VARCHAR2,
   packing_instruction_id_      IN     VARCHAR2,
   node_id_                     IN     NUMBER )
IS
   parent_node_id_ PACKING_INSTRUCTION_NODE_TAB.node_id%TYPE;
BEGIN
   
   IF (generate_sscc_no_db_ = Fnd_Boolean_API.DB_FALSE OR generate_sscc_no_db_ IS NULL) THEN 
      generate_sscc_no_db_ := Get_Generate_Sscc_No_Db(packing_instruction_id_, node_id_);
   END IF;
   IF (print_label_db_ = Fnd_Boolean_API.DB_FALSE OR print_label_db_ IS NULL) THEN 
      print_label_db_ := Get_Print_Label_Db(packing_instruction_id_,node_id_);
   END IF;
   IF (print_content_label_db_ = Fnd_Boolean_API.DB_FALSE OR print_content_label_db_ IS NULL) THEN 
      print_content_label_db_ := Get_Print_Content_Label_Db(packing_instruction_id_, node_id_);
   END IF;
   IF (print_shipment_label_db_ = Fnd_Boolean_API.DB_FALSE OR print_shipment_label_db_ IS NULL) THEN 
      print_shipment_label_db_ := Get_Print_Shipment_Label_Db(packing_instruction_id_, node_id_);
   END IF;
   IF (mix_of_part_no_blocked_db_ = Fnd_Boolean_API.DB_FALSE OR mix_of_part_no_blocked_db_ IS NULL) THEN 
      mix_of_part_no_blocked_db_ := Get_Mix_Of_Part_No_Blocked_Db(packing_instruction_id_, node_id_);
   END IF;
   IF (mix_of_lot_batch_blocked_db_ = Fnd_Boolean_API.DB_FALSE OR mix_of_lot_batch_blocked_db_ IS NULL) THEN 
      mix_of_lot_batch_blocked_db_ := Get_Mix_Of_Lot_Batch_Blocke_Db(packing_instruction_id_, node_id_);
   END IF;
   IF (mix_of_cond_code_blocked_db_ = Fnd_Boolean_API.DB_FALSE OR mix_of_cond_code_blocked_db_ IS NULL) THEN 
      mix_of_cond_code_blocked_db_ := Get_Mix_Of_Cond_Code_Blocke_Db(packing_instruction_id_, node_id_);
   END IF;

   IF ((generate_sscc_no_db_         = Fnd_Boolean_API.DB_FALSE) OR 
       (print_label_db_              = Fnd_Boolean_API.DB_FALSE) OR 
       (print_content_label_db_      = Fnd_Boolean_API.DB_FALSE) OR
       (print_shipment_label_db_     = Fnd_Boolean_API.DB_FALSE) OR
       (mix_of_part_no_blocked_db_   = Fnd_Boolean_API.DB_FALSE) OR 
       (mix_of_lot_batch_blocked_db_ = Fnd_Boolean_API.DB_FALSE) OR 
       (mix_of_cond_code_blocked_db_ = Fnd_Boolean_API.DB_FALSE)) THEN 
      parent_node_id_ := Get_Parent_Node_Id___(packing_instruction_id_, 
                                               node_id_);
      IF (parent_node_id_ IS NOT NULL) THEN 
         Get_Flags_For_Node_And_Parents(generate_sscc_no_db_,
                                        print_label_db_,
                                        print_content_label_db_,
                                        print_shipment_label_db_,
                                        mix_of_cond_code_blocked_db_,
                                        mix_of_lot_batch_blocked_db_,
                                        mix_of_part_no_blocked_db_,
                                        packing_instruction_id_,
                                        parent_node_id_);
      END IF;
   END IF;
END Get_Flags_For_Node_And_Parents;


PROCEDURE Get_Flags_For_Node (
   generate_sscc_no_db_         OUT VARCHAR2, 
   print_label_db_              OUT VARCHAR2,
   print_content_label_db_      OUT VARCHAR2,
   print_shipment_label_db_     OUT VARCHAR2,
   mix_of_cond_code_blocked_db_ OUT VARCHAR2,
   mix_of_lot_batch_blocked_db_ OUT VARCHAR2,
   mix_of_part_no_blocked_db_   OUT VARCHAR2,
   packing_instruction_id_      IN  VARCHAR2,
   node_id_                     IN  NUMBER )
IS
   pub_rec_   Public_Rec;
BEGIN
   pub_rec_ := Get(packing_instruction_id_, node_id_);
   generate_sscc_no_db_         := pub_rec_.generate_sscc_no;
   print_label_db_              := pub_rec_.print_label;
   print_content_label_db_      := pub_rec_.print_content_label;
   print_shipment_label_db_     := pub_rec_.print_shipment_label;
   mix_of_part_no_blocked_db_   := pub_rec_.mix_of_part_no_blocked;
   mix_of_lot_batch_blocked_db_ := pub_rec_.mix_of_lot_batch_blocked;
   mix_of_cond_code_blocked_db_ := pub_rec_.mix_of_cond_code_blocked;
END Get_Flags_For_Node;

@UncheckedAccess
FUNCTION Hu_Type_Exist_As_Leaf_Node (
   packing_instruction_id_ IN VARCHAR2,
   handling_unit_type_id_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM  packing_instruction_node_tab pin1
      WHERE pin1.packing_instruction_id = packing_instruction_id_
      AND   pin1.handling_unit_type_id  = handling_unit_type_id_
      AND   NOT EXISTS (select 1 
                  FROM packing_instruction_node_tab pin2
                  WHERE pin2.packing_instruction_id = pin1.packing_instruction_id
                  AND   pin2.parent_node_id         = pin1.node_id);
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO temp_;
   IF(exist_control%NOTFOUND) THEN
      CLOSE exist_control;
      RETURN Fnd_Boolean_API.DB_FALSE;
   ELSE
      CLOSE exist_control;
      RETURN Fnd_Boolean_API.DB_TRUE;
   END IF;      
END Hu_Type_Exist_As_Leaf_Node;

-- Leaf_Node_For_Part_Exists
-- This would return TRUE or FALSE by checking the lowest level hu types with handling unit capacities of parts
@UncheckedAccess
FUNCTION Leaf_Node_For_Part_Exists (
   packing_instruction_id_ IN VARCHAR2,
   part_no_                IN VARCHAR2,
   unit_code_              IN VARCHAR2) RETURN VARCHAR2
IS    
   handling_unit_type_tab_     Handling_Unit_Type_API.Unit_Type_Tab;   
   leaf_node_for_part_exists_  VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;
   CURSOR get_lowest_hu_types IS
      SELECT pin1.handling_unit_type_id
         FROM  packing_instruction_node_tab pin1
         WHERE pin1.packing_instruction_id = packing_instruction_id_                 
         AND   NOT EXISTS (SELECT 1 
                           FROM  packing_instruction_node_tab pin2
                           WHERE pin2.packing_instruction_id = pin1.packing_instruction_id
                           AND   pin2.parent_node_id         = pin1.node_id);      
BEGIN   
   OPEN get_lowest_hu_types;
   FETCH get_lowest_hu_types BULK COLLECT INTO handling_unit_type_tab_;
   CLOSE get_lowest_hu_types;

   IF (handling_unit_type_tab_.COUNT > 0) THEN
      FOR i IN handling_unit_type_tab_.FIRST..handling_unit_type_tab_.LAST LOOP
         IF (Part_Handling_Unit_API.Check_Operative(part_no_, handling_unit_type_tab_(i).handling_unit_type_id, unit_code_)) THEN
            leaf_node_for_part_exists_ := Fnd_Boolean_API.DB_TRUE;
            EXIT;
         END IF;  
      END LOOP;        
   END IF;
   RETURN leaf_node_for_part_exists_;
END Leaf_Node_For_Part_Exists;
   

FUNCTION Get_Nodes_From_Hu_Type_Id (
   packing_instruction_id_ IN VARCHAR2,
   handling_unit_type_id_  IN VARCHAR2 ) RETURN Packing_Instruction_Node_API.Node_Tab
IS
   pack_instruction_node_tab_ Packing_Instruction_Node_API.Node_Tab;

   CURSOR get_nodes IS
      SELECT node_id, parent_node_id, handling_unit_type_id, quantity
      FROM  PACKING_INSTRUCTION_NODE_TAB
      WHERE packing_instruction_id  = packing_instruction_id_
      START WITH node_id = (SELECT node_id
                            FROM  PACKING_INSTRUCTION_NODE_TAB
                            WHERE packing_instruction_id  = packing_instruction_id_
                            AND   handling_unit_type_id = handling_unit_type_id_)
      CONNECT BY packing_instruction_id = PRIOR packing_instruction_id
      AND parent_node_id = PRIOR node_id;
BEGIN
   OPEN get_nodes;
   FETCH get_nodes BULK COLLECT INTO pack_instruction_node_tab_;
   CLOSE get_nodes;
   RETURN pack_instruction_node_tab_;   
END Get_Nodes_From_Hu_Type_Id;
