-----------------------------------------------------------------------------
--
--  Logical unit: CompanyStructureItem
--  Component:    ACCRUL
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  211224  Tiralk  FI21R2-8199, Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@IgnoreUnitTest MethodOverride
@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     company_structure_item_tab%ROWTYPE,
   newrec_     IN OUT company_structure_item_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN BOOLEAN DEFAULT FALSE)
IS
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   
   IF (newrec_.name_value != oldrec_.name_value AND oldrec_.name_value IS NOT NULL) THEN
      UPDATE company_structure_item_tab
      SET    item_above   = newrec_.name_value
      WHERE  structure_id = newrec_.structure_id
      AND    item_above   = oldrec_.name_value;
   END IF;
END Update___;


@IgnoreUnitTest MethodOverride
@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     company_structure_item_tab%ROWTYPE,
   newrec_ IN OUT NOCOPY company_structure_item_tab%ROWTYPE,
   indrec_ IN OUT NOCOPY Indicator_Rec,
   attr_   IN OUT NOCOPY VARCHAR2 )
IS
BEGIN
   Validate_Record___(oldrec_, newrec_);
   super(oldrec_, newrec_, indrec_, attr_);
END Check_Common___;


@IgnoreUnitTest MethodOverride
@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN company_structure_item_tab%ROWTYPE )
IS
BEGIN
   super(objid_, remrec_);   
   Company_Structure_Level_API.Delete_Unused_Levels__(remrec_.structure_id);
   Reorder_Sequence__(remrec_.structure_id, remrec_.item_above, remrec_.sort_order);
END Delete___;


@IgnoreUnitTest MethodOverride
@Override 
PROCEDURE Check_Delete___ (
   remrec_ IN company_structure_item_tab%ROWTYPE )
IS
BEGIN
   Company_Structure_API.Validate_Structure_Modify(remrec_.structure_id);
   Client_SYS.Add_Warning(lu_name_, 'DELETEWARNING: Selected node will be deleted along with connected nodes.');
   super(remrec_);
END Check_Delete___;


@IgnoreUnitTest NoOutParams
PROCEDURE Validate_Record___ (
   oldrec_ IN company_structure_item_tab%ROWTYPE,
   newrec_ IN company_structure_item_tab%ROWTYPE )
IS
   top_node_exist_   NUMBER;
   
   CURSOR check_top_node_exist IS
      SELECT 1
      FROM   company_structure_item_tab
      WHERE  structure_id  = newrec_.structure_id
      AND    name_value   != newrec_.name_value
      AND    structure_item_type  = newrec_.structure_item_type
      AND    item_above IS NULL;
BEGIN   
   Company_Structure_API.Validate_Structure_Modify(newrec_.structure_id);
   
   IF ((INSTR(newrec_.name_value, '&') > 0) OR (INSTR(newrec_.name_value, '''') > 0) OR (INSTR(newrec_.name_value, '^') > 0)) THEN
      Error_SYS.Record_General(lu_name_, 'INVALCHAR: You have entered an invalid character in this field.');
   END IF;
   
   IF (newrec_.structure_item_type = Struct_Item_Type_API.DB_NODE) THEN
      IF ((NVL(oldrec_.item_above, Database_SYS.string_null_) != NVL(newrec_.item_above, Database_SYS.string_null_)) AND newrec_.item_above IS NULL) THEN
         OPEN  check_top_node_exist;
         FETCH check_top_node_exist INTO top_node_exist_;
         CLOSE check_top_node_exist;
         
         IF (NVL(top_node_exist_, 0) = 1) THEN
            Error_SYS.Record_general(lu_name_, 'NOTOP: Top Node already exists.');
         ELSE
            Error_SYS.Check_Not_Null(lu_name_, 'ITEM_ABOVE', '');
         END IF;         
      END IF;
   ELSE
      Company_API.Exist(newrec_.name_value);
   END IF;
END Validate_Record___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@IgnoreUnitTest DMLOperation
PROCEDURE New_Node__ (
   structure_id_  IN VARCHAR2,
   name_value_    IN VARCHAR2,
   description_   IN VARCHAR2,
   item_above_    IN VARCHAR2,
   level_no_      IN NUMBER )
IS   
   newrec_  company_structure_item_tab%ROWTYPE;

BEGIN
   Company_Structure_Level_API.Insert_Level__(structure_id_, level_no_);
   
   newrec_.structure_id          := structure_id_;
   newrec_.name_value            := name_value_;
   newrec_.description           := description_;
   newrec_.item_above            := item_above_;
   newrec_.structure_item_type   := Struct_Item_Type_API.DB_NODE;
   newrec_.level_no              := level_no_ + 1;
   newrec_.sort_order            := Get_Sort_Order_Sequence(newrec_.structure_id, newrec_.item_above);
   New___(newrec_);   
END New_Node__;


@IgnoreUnitTest DMLOperation
PROCEDURE New_Top_Node__(
   structure_id_  IN VARCHAR2,
   name_value_    IN VARCHAR2,
   description_   IN VARCHAR2,
   level_no_      IN NUMBER )
IS
BEGIN   
   IF (level_no_ != 1) THEN
      Error_SYS.Record_General(lu_name_, 'CANTCHANGETOPNODE: You cannot create a new top node if the selected node''s level is not 1.');
   END IF;
   
   UPDATE company_structure_item_tab
   SET    level_no = level_no + 1
   WHERE  structure_id = structure_id_;

   UPDATE company_structure_item_tab
   SET    item_above = name_value_
   WHERE  structure_id = structure_id_
   AND    item_above IS NULL;

   New_Node__(structure_id_, name_value_, description_, NULL, 0);
END New_Top_Node__;


@IgnoreUnitTest DMLOperation
PROCEDURE New_Element__ (
   structure_id_  IN VARCHAR2,
   source_node_   IN VARCHAR2,
   new_element_   IN VARCHAR2,
   description_   IN VARCHAR2 )
IS
   newrec_  company_structure_item_tab%ROWTYPE;
BEGIN   
   newrec_.structure_id          := structure_id_;
   newrec_.name_value            := new_element_;
   newrec_.description           := description_;
   newrec_.item_above            := source_node_;
   newrec_.structure_item_type   := Struct_Item_Type_API.DB_ELEMENT;
   newrec_.level_no              := Get_Level_No(structure_id_, Struct_Item_Type_API.Decode(Struct_Item_Type_API.DB_NODE), source_node_);
   newrec_.sort_order            := Get_Sort_Order_Sequence(newrec_.structure_id, newrec_.item_above);
   New___(newrec_);   
END New_Element__;


@IgnoreUnitTest DMLOperation
PROCEDURE Remove_Element__ (
   structure_id_  IN VARCHAR2,
   element_       IN VARCHAR2 )
IS
   remrec_  company_structure_item_tab%ROWTYPE;
BEGIN
   remrec_ := Get_Object_By_Keys___(structure_id_, Struct_Item_Type_API.DB_ELEMENT, element_);
   Remove___(remrec_);  
END Remove_Element__;


@IgnoreUnitTest DMLOperation
PROCEDURE Reorder_Sequence__ (
   structure_id_  IN VARCHAR2,
   item_above_    IN VARCHAR2,
   sort_order_    IN NUMBER)
IS   
BEGIN
   UPDATE company_structure_item_tab
   SET    sort_order = sort_order - 1
   WHERE  structure_id = structure_id_
   AND    item_above   = item_above_
   AND    sort_order   > sort_order_;
END Reorder_Sequence__;


@IgnoreUnitTest DMLOperation
PROCEDURE Change_Node_Above__ (
   structure_id_        IN VARCHAR2,
   name_value_          IN VARCHAR2,
   structure_item_type_ IN VARCHAR2,
   current_level_no_    IN NUMBER,
   current_item_above_  IN VARCHAR2,
   new_item_above_      IN VARCHAR2 )
IS
   newrec_                    company_structure_item_tab%ROWTYPE;
   new_item_above_level_no_   company_structure_item_tab.level_no%TYPE;
BEGIN   
   IF (structure_item_type_ = Struct_Item_Type_API.DB_NODE AND current_level_no_ > 2) THEN
      IF (new_item_above_ IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'NODEABOVEIDNULL: Node Above is empty.');
      END IF;
      new_item_above_level_no_ := Get_Level_No(structure_id_, Struct_Item_Type_API.Decode(structure_item_type_), new_item_above_);
      IF (NOT(Check_Exist___(structure_id_, structure_item_type_, new_item_above_))) THEN
         Error_SYS.Record_General(lu_name_, 'INVALIDNODEABOVE: The "Node Above" value [:P1] does not exist in the structure!.' , new_item_above_);
      ELSIF (current_item_above_ = new_item_above_) THEN
         Error_SYS.Record_General(lu_name_, 'SAMENODEABOVE: The selected node is already connected.');
      ELSIF ((new_item_above_level_no_ < current_level_no_) AND new_item_above_level_no_ != 0) THEN
         newrec_ := Get_Object_By_Keys___(structure_id_, structure_item_type_, name_value_);
         newrec_.item_above := new_item_above_;
         Modify___(newrec_);
      ELSIF (new_item_above_level_no_ >= current_level_no_ OR new_item_above_level_no_ = 0) THEN
         Error_SYS.Record_General(lu_name_, 'INVALIDPARENTNODE: The parent cannot be on the same or on a lower level than the node itself.');
      END IF;
   ELSE
      Error_SYS.Record_General(lu_name_, 'CANTCHANGENODEABOVE: You cannot change the node above if the selected node''s level is less than 2 or the Structure Item Type is a Company.');
   END IF;   
END Change_Node_Above__;


@IgnoreUnitTest DMLOperation
PROCEDURE Delete_Node__ (
   info_                OUT VARCHAR2,
   structure_id_        IN  VARCHAR2,
   name_value_          IN  VARCHAR2,
   structure_item_type_ IN  VARCHAR2,
   level_no_            IN  NUMBER )
IS   
   any_item_connected_  NUMBER;
   objid_               company_structure_item.objid%TYPE;
   objversion_          company_structure_item.objversion%TYPE;
   
   CURSOR check_for_connected_elements(structure_id_ VARCHAR2, name_value_ VARCHAR2) IS
      SELECT 1
      FROM   company_structure_item_tab
      WHERE  structure_id = structure_id_
      AND    item_above   = name_value_
      AND    structure_item_type = 'ELEMENT';  
      
   CURSOR get_connected_item IS
      SELECT     *
      FROM       company_structure_item_tab
      WHERE      structure_id        = structure_id_
      START WITH name_value          = name_value_
      AND        structure_item_type = 'NODE'
      CONNECT BY structure_id        = PRIOR structure_id
      AND        item_above          = PRIOR name_value
      AND        PRIOR structure_item_type = 'NODE'
      FOR UPDATE;
BEGIN
   IF (structure_item_type_ = Struct_Item_Type_API.DB_NODE) THEN
      IF (level_no_ > 1) THEN
         FOR rec_ IN get_connected_item LOOP
            OPEN  check_for_connected_elements(rec_.structure_id, rec_.name_value);
            FETCH check_for_connected_elements INTO any_item_connected_;
            CLOSE check_for_connected_elements;
            IF (any_item_connected_ = 1) THEN
               Error_SYS.Record_General(lu_name_, 'DELETEERROR: Not possible to delete node with connected companies.');
            END IF;
            Get_Id_Version_By_Keys___(objid_, objversion_, rec_.structure_id, rec_.structure_item_type, rec_.name_value);
            Remove__(info_, objid_, objversion_, 'DO');        
         END LOOP;
      ELSE
         Error_SYS.Record_General(lu_name_, 'CANTDELETENODE: You cannot delete this node if it is the root node or the Structure Item Type is a Company.'); 
      END IF;
   END IF;
END Delete_Node__;


@IgnoreUnitTest DMLOperation
PROCEDURE Rename_node__(
   structure_id_  IN VARCHAR2,
   old_node_id_   IN VARCHAR2,
   node_id_       IN VARCHAR2,
   description_   IN VARCHAR2)
IS
   struct_item_type_    company_structure_item_tab.structure_item_type%TYPE;
   oldrec_              company_structure_item_tab%ROWTYPE;
   newrec_              company_structure_item_tab%ROWTYPE;
BEGIN   
   
   IF (node_id_ IS NULL) THEN 
      Error_SYS.Record_General(lu_name_, 'NDIDNULL: Node ID should have a value');
   END IF;
   IF (description_ IS NULL) THEN 
      Error_SYS.Record_General(lu_name_, 'NDDESNULL: Node Description should have a value');
   END IF;
   
   IF (node_id_ != old_node_id_ AND old_node_id_ IS NOT NULL) THEN
      struct_item_type_ := Struct_Item_Type_API.DB_NODE;
      oldrec_ := Lock_By_Keys___(structure_id_, struct_item_type_, old_node_id_);
      newrec_ := oldrec_;
      newrec_.name_value   := node_id_;
      newrec_.description  := description_;
      Validate_Record___(oldrec_, newrec_);     

      IF (NOT(Check_Exist___(structure_id_, struct_item_type_, node_id_))) THEN
         UPDATE company_structure_item_tab
         SET    name_value  = node_id_,
                description = description_
         WHERE  structure_id = structure_id_
         AND    structure_item_type = struct_item_type_
         AND    name_value = old_node_id_;

         UPDATE company_structure_item_tab
         SET    item_above   = node_id_
         WHERE  structure_id = structure_id_
         AND    item_above   = old_node_id_;
      ELSE       
         Error_SYS.Record_General(lu_name_, 'ITEMEXISTS: The Company Structure Item already exists.');
      END IF;   
   END IF;
END Rename_node__;


@IgnoreUnitTest DMLOperation
PROCEDURE Connect_All_Elements__ (
   structure_id_        IN  VARCHAR2,
   name_value_          IN  VARCHAR2,
   structure_item_type_ IN  VARCHAR2,
   level_no_            IN  NUMBER )
IS
   sort_order_ NUMBER;
BEGIN
   Company_Structure_API.Validate_Structure_Modify(structure_id_);
   sort_order_ := Get_Sort_Order_Sequence(structure_id_, name_value_) - 1;
   
   IF (structure_item_type_ = Struct_Item_Type_API.DB_NODE) THEN
      INSERT INTO company_structure_item_tab (
            structure_id,
            name_value,
            description,
            structure_item_type,
            item_above,
            level_no,
            sort_order,
            rowversion )
      SELECT   
            structure_id_,
            company,
            name,
            'ELEMENT',
            name_value_,
            level_no_,
            sort_order_ + (ROW_NUMBER() OVER(ORDER BY company)),
            SYSDATE
      FROM  company_tab
      WHERE NOT EXISTS (SELECT 1
                        FROM   company_structure_item_tab
                        WHERE  structure_id = structure_id_
                        AND    name_value   = company
                        AND    structure_item_type = 'ELEMENT');
   END IF;
END Connect_All_Elements__;


@IgnoreUnitTest DMLOperation
PROCEDURE Disconnect_All_Elements__ (
   structure_id_        IN  VARCHAR2,
   name_value_          IN  VARCHAR2,
   structure_item_type_ IN  VARCHAR2 )
IS
BEGIN
   Company_Structure_API.Validate_Structure_Modify(structure_id_);
   -- Disconnect companies which are connected to a particular node
   IF (structure_item_type_ = Struct_Item_Type_API.DB_NODE) THEN
      DELETE
      FROM   company_structure_item_tab
      WHERE  structure_id = structure_id_
      AND    item_above   = name_value_
      AND    structure_item_type = 'ELEMENT';
   ELSE
      Error_SYS.Record_General(lu_name_, 'ERRORDISCONALL: Cannot Disconnect All companies when a company is selected in the Tree.');
   END IF;
END Disconnect_All_Elements__;


@IgnoreUnitTest DMLOperation
PROCEDURE Copy__ (
   source_structure_id_    IN  VARCHAR2,
   new_structure_id_       IN  VARCHAR2,
   include_company_values_ IN  VARCHAR2)
IS  
   
BEGIN
   IF (include_company_values_ = 'TRUE') THEN
      INSERT INTO company_structure_item_tab (
            structure_Id,
            structure_item_type,
            name_value,
            description,
            level_no,
            item_above,
            sort_order,
            rowversion )
      SELECT
            new_structure_id_,
            structure_item_type,
            name_value,
            description,
            level_no,
            item_above,
            sort_order,
            SYSDATE
      FROM  company_structure_item_tab
      WHERE structure_id = source_structure_id_;
   ELSE
      INSERT INTO company_structure_item_tab (
            structure_Id,
            structure_item_type,
            name_value,
            description,
            level_no,
            item_above,
            sort_order,
            rowversion )
      SELECT
            new_structure_id_,
            'NODE',
            name_value,
            description,
            level_no,
            item_above,
            sort_order,
            SYSDATE
      FROM  company_structure_item_tab
      WHERE structure_id = source_structure_id_
      AND   structure_item_type = 'NODE';
   END IF; 
END Copy__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@IgnoreUnitTest DMLOperation
PROCEDURE Modify_Sort_Order (
  structure_id_             IN VARCHAR2,
  structure_item_type_list_ IN VARCHAR2,
  name_value_list_          IN VARCHAR2 )
IS
   attr_                VARCHAR2(32000);
   objid_               VARCHAR2(200);
   objversion_          VARCHAR2(2000);
   info_                VARCHAR2(2000);
   sort_order_          NUMBER ;
   p_delim_             VARCHAR2(1)   := '^';
   name_value_          VARCHAR2(200) := '';
   struct_value_        VARCHAR2(200) := '';
   name_list_           VARCHAR2(32000);
   name_delimpos_       NUMBER ;
   name_delimlen_       NUMBER;
   struct_list_         VARCHAR2(32000);
   struct_delimpos_     NUMBER;
   struct_delimlen_     NUMBER;
    
BEGIN
   name_list_       := name_value_list_;
   name_delimpos_   := INSTR(name_value_list_, p_delim_);
   name_delimlen_   := LENGTH(p_delim_);
   struct_list_     := structure_item_type_list_;
   struct_delimpos_ := INSTR(structure_item_type_list_, p_delim_);
   struct_delimlen_ := LENGTH(p_delim_);
   sort_order_      := 1;
   
   WHILE name_delimpos_ > 0
   LOOP
      name_value_    := SUBSTR(name_list_, 1, name_delimpos_ - 1);
      name_list_     := SUBSTR(name_list_, name_delimpos_ + name_delimlen_);
      name_delimpos_ := INSTR(name_list_, p_delim_);
      
      struct_value_    := SUBSTR(struct_list_, 1, struct_delimpos_ - 1);
      struct_list_     := SUBSTR(struct_list_, struct_delimpos_ + struct_delimlen_);
      struct_delimpos_ := INSTR(struct_list_, p_delim_);
      
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('SORT_ORDER', sort_order_ , attr_);
      Get_Id_Version_By_Keys___ (objid_, objversion_, structure_id_, struct_value_, name_value_);
      Modify__(info_, objid_, objversion_, attr_, 'DO');
      sort_order_:= sort_order_ + 1;
   END LOOP;   
END Modify_Sort_Order;

 
@IgnoreUnitTest DMLOperation
PROCEDURE Move_Branch (
   structure_id_        IN VARCHAR2,
   item_above_          IN VARCHAR2,
   source_item_         IN VARCHAR2,
   source_item_type_    IN VARCHAR2,
   target_item_         IN VARCHAR2,
   target_item_type_    IN VARCHAR2 )
IS
   oldrec_                 company_structure_item_tab%ROWTYPE;
   newrec_                 company_structure_item_tab%ROWTYPE;
   source_level_           NUMBER;
   structure_max_level_    NUMBER;
   source_item_max_level_  NUMBER;
   new_max_level_          NUMBER;
   diff_in_tree_           NUMBER;
   target_level_           NUMBER;
   required_no_of_levels_  NUMBER;
   index_                  NUMBER;
   item_level_increment_   NUMBER;
   new_structure_level_no_ NUMBER;
   sort_order_             NUMBER;
   source_item_above_      VARCHAR2(20);

   CURSOR get_structure_max_level IS
      SELECT MAX(level_no)
      FROM   company_structure_level_tab
      WHERE  structure_id = structure_id_;

   CURSOR get_source_item_max_level IS
      SELECT MAX(level_no) 
      FROM   company_structure_item_tab a
      WHERE  structure_id = structure_id_
      AND    name_value IN (SELECT name_value
                            FROM   company_structure_item_tab b
                            WHERE  a.structure_id       = b.structure_id
                            AND    a.structure_item_type= b.structure_item_type
                            START WITH name_value       = source_item_
                            AND    structure_item_type  = newrec_.structure_item_type
                            CONNECT BY structure_id     = PRIOR structure_id
                            AND    item_above           = PRIOR name_value
                            AND    structure_item_type  = PRIOR structure_item_type
                            AND    structure_id         = structure_id_
                            AND    structure_item_type  = source_item_type_);

BEGIN
   IF (item_above_ IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'CANTMOVETOTOP: You cannot move items to the top node.');
   END IF;
   IF (target_item_type_ = Struct_Item_Type_API.DB_ELEMENT) THEN
      Error_SYS.Record_General(lu_name_, 'CANTMOVEITEM: Item move is only allowed to a node.');
   END IF;
   
   oldrec_ := Get_Object_By_Keys___(structure_id_, source_item_type_, source_item_);
   newrec_ := oldrec_;
   source_level_        := newrec_.level_no;
   source_item_above_   := newrec_.item_above;
   sort_order_          := newrec_.sort_order;

   newrec_.item_above   := target_item_;
   newrec_.sort_order   := Get_Sort_Order_Sequence(structure_id_, target_item_);
   target_level_        := Get_Level_No(structure_id_, Struct_Item_Type_API.Decode(newrec_.structure_item_type), target_item_);
   IF (newrec_.structure_item_type = Struct_Item_Type_API.DB_NODE) THEN
      newrec_.level_no  := target_level_ + 1;
   ELSE
      newrec_.level_no  := target_level_;
   END IF;

   IF (NOT(newrec_.level_no = source_level_ AND newrec_.structure_item_type = Struct_Item_Type_API.DB_ELEMENT)) THEN
      OPEN  get_structure_max_level;
      FETCH get_structure_max_level INTO structure_max_level_;
      CLOSE get_structure_max_level;
      
      OPEN  get_source_item_max_level;
      FETCH get_source_item_max_level INTO source_item_max_level_;
      CLOSE get_source_item_max_level;      
      
      -- Check the level difference between source item and destination item
      diff_in_tree_           := (source_item_max_level_ - source_level_) + 1;
      new_max_level_          := target_level_ + diff_in_tree_;
      required_no_of_levels_  := new_max_level_ - structure_max_level_;
      item_level_increment_   := (target_level_ - source_level_) + 1;
      
      -- Update level numbers of source item
      UPDATE company_structure_item_tab a
      SET    level_no = level_no + item_level_increment_
      WHERE  structure_id = structure_id_
      AND    (name_value, structure_item_type) IN (SELECT name_value, structure_item_type
                                                   FROM   company_structure_item_tab b
                                                   WHERE  a.structure_id = b.structure_id
                                                   START WITH name_value           = source_item_
                                                   AND        structure_item_type  = source_item_type_
                                                   CONNECT BY structure_id         = PRIOR structure_id
                                                   AND        item_above           = PRIOR name_value
                                                   AND        (item_above ||Decode(structure_item_type, 'ELEMENT', 'NODE', structure_item_type) = PRIOR (name_value || structure_item_type))
                                                   AND        structure_id         = structure_id_);

      -- If more levels need to be added when moving
      IF (required_no_of_levels_ > 0 AND newrec_.structure_item_type = Struct_Item_Type_API.DB_NODE) THEN
         index_  := 0;
         new_structure_level_no_ := structure_max_level_;
         WHILE (index_ < required_no_of_levels_) LOOP
            Company_Structure_Level_API.Insert_Level__(structure_id_, new_structure_level_no_);
            index_ := index_ + 1;
            new_structure_level_no_ := new_structure_level_no_ + 1;
         END LOOP;
      END IF;
      
      -- If levels need to be deleted when moving
      IF (required_no_of_levels_ <= 0) THEN
         Company_Structure_Level_API.Delete_Unused_Levels__(structure_id_);
      END IF;      
   END IF;
   
   Modify___(newrec_);
   Reorder_Sequence__(structure_id_, source_item_above_, sort_order_);
END Move_Branch;


@UncheckedAccess
FUNCTION Get_Sort_Order_Sequence (
   structure_id_  IN VARCHAR2,
   item_above_    IN VARCHAR2 ) RETURN NUMBER
IS 
   sort_order_ NUMBER;
   
   CURSOR max_order_no IS
      SELECT NVL(MAX(sort_order), 0)
      FROM   company_structure_item_tab
      WHERE  structure_id  = structure_id_
      AND    item_above    = item_above_;
BEGIN   
   IF (item_above_ IS NOT NULL) THEN
      OPEN  max_order_no;
      FETCH max_order_no INTO sort_order_;
      CLOSE max_order_no;
      
      RETURN sort_order_ + 1;
   ELSE
      RETURN 1;
   END IF;   
END Get_Sort_Order_Sequence;
