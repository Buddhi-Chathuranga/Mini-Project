-----------------------------------------------------------------------------
--
--  Logical unit: CompanyStructureUtil
--  Component:    ACCRUL
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
PROCEDURE Refresh_Structure_Cache___(
   structure_id_  IN VARCHAR2)
IS
BEGIN
   
   DELETE FROM analytic_comp_struct_cache_tab
      WHERE structure_id = structure_id_;
      
   INSERT 
      INTO analytic_comp_struct_cache_tab(
         structure_id,
         structure_node,
         item_value,
         structure_node_desc,
         level_id,
         level_id_desc,
         rowversion)
      SELECT
         a.structure_id,
         a.structure_node,
         item_value,
         a.structure_node_desc,
         a.level_id,
         a.level_id_desc,
         SYSDATE
      FROM company_structure_det_tab a
      WHERE a.structure_id = structure_id_;

END Refresh_Structure_Cache___;

PROCEDURE Insert_Det___ (
   newrec_     IN OUT company_structure_det_tab%ROWTYPE)
IS
   dummy_             NUMBER;
   CURSOR check_exist IS
      SELECT 1
      FROM   company_structure_det_tab
      WHERE  structure_id    = newrec_.structure_id
      AND    level_id        = newrec_.level_id
      AND    structure_node  = newrec_.structure_node
      AND    item_value      = newrec_.item_value;
BEGIN
   OPEN  check_exist;
   FETCH check_exist INTO dummy_;
   IF (check_exist%FOUND) THEN
      CLOSE check_exist;
   ELSE
      CLOSE check_exist;
      newrec_.rowversion := SYSDATE;
      INSERT
         INTO company_structure_det_tab (
            structure_id,
            level_id,
            level_id_desc,
            structure_node,
            item_value,
            structure_node_desc,
            item_below,
            item_below_desc,
            item_below_type,
            item_above,
            level_seq,
            rowversion)
         VALUES (
            newrec_.structure_id,
            newrec_.level_id,
            newrec_.level_id_desc,
            newrec_.structure_node,
            newrec_.item_value,
            newrec_.structure_node_desc,
            newrec_.item_below,
            newrec_.item_below_desc,
            newrec_.item_below_type,
            newrec_.item_above,
            newrec_.level_seq,
            newrec_.rowversion);
   END IF;
END Insert_Det___;
-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
PROCEDURE Refresh_Structure_Cache (
   structure_id_ IN VARCHAR2)
IS
   level_id_                        company_structure_level_tab.level_id%TYPE;
   structure_node_desc_             company_structure_item_tab.description%TYPE;
   structure_node_                  company_structure_item_tab.name_value%TYPE;
   item_above_                      company_structure_item_tab.item_above%TYPE;
   item_below_                      company_structure_item_tab.name_value%TYPE;
   empty_detrec_                    company_structure_det_tab%ROWTYPE;
   detrec_                          company_structure_det_tab%ROWTYPE;
   level_id_desc_                   company_structure_level_tab.description%TYPE;
   level_seq_                       company_structure_level_tab.level_no%TYPE;
   item_type_element_db_val_        VARCHAR2(20) := Struct_Item_Type_API.DB_ELEMENT;
   item_type_node_db_val_           VARCHAR2(20) := Struct_Item_Type_API.DB_NODE;
   item_type_element_db_decode_val_ VARCHAR2(20) := Struct_Item_Type_API.Decode(item_type_element_db_val_);
   item_type_node_db_decode_val_    VARCHAR2(20) := Struct_Item_Type_API.Decode(item_type_node_db_val_);

   CURSOR get_items IS
      SELECT l.level_id,
             l.description level_desc,
             i.description,
             i.name_value,
             i.item_above,
             l.level_no
      FROM   company_structure_item_tab i, company_structure_level_tab l
      WHERE  i.structure_id        = structure_id_
      AND    i.structure_item_type = item_type_element_db_val_
      AND    i.level_no = l.level_no
      AND    i.structure_id = l.structure_id;
BEGIN
   DELETE 
   FROM   company_structure_det_tab
   WHERE  structure_id = structure_id_;
   
   FOR recb_ IN get_items LOOP
      level_id_desc_ := Company_Structure_Level_API.Get_Description(structure_id_, recb_.level_no);
      structure_node_desc_ := Company_Structure_Item_API.Get_Description(structure_id_, item_type_node_db_decode_val_, recb_.item_above);
      detrec_.structure_id         := structure_id_; 
      detrec_.level_id             := recb_.level_id;
      detrec_.level_id_desc        := level_id_desc_;
      detrec_.structure_node_desc  := structure_node_desc_;
      detrec_.structure_node       := recb_.item_above;
      detrec_.item_value           := recb_.name_value;
      detrec_.item_below           := recb_.name_value;
      detrec_.item_below_desc      := recb_.description;
      detrec_.item_below_type      := item_type_element_db_val_;
      
      level_seq_                   := recb_.level_no;
      detrec_.level_seq            := level_seq_;
      Insert_Det___ ( detrec_ );

      detrec_ := empty_detrec_;
      
      item_above_ := recb_.item_above;
      structure_node_ := item_above_;
      item_below_ := structure_node_;
      
      -- Setting next structure_node_, based on the parent node of the current node
      structure_node_ := Company_Structure_Item_API.Get_Item_Above(structure_id_, item_type_node_db_decode_val_, structure_node_);
      -- Start loop to traverse upwards in the structure, the currenct node is kept in structure_node_ variable. 
      -- item_below_ holds the node below the current node.
      -- item_above_ holds the node above the current node.
      
      LOOP
         -- Get the level_seq (level_no) using a method to handle asymetric structures
         level_seq_ := Company_Structure_Item_API.Get_Level_No(structure_id_, item_type_node_db_decode_val_, structure_node_);
         level_id_ := Company_Structure_Level_API.Get_Level_Id(structure_id_, level_seq_);
         level_id_desc_ := Company_Structure_Level_API.Get_Description(structure_id_, level_seq_);
         
         detrec_.item_below_desc := structure_node_desc_;
         structure_node_desc_ := Company_Structure_Item_API.Get_Description(structure_id_, item_type_node_db_decode_val_, structure_node_);
         
         detrec_.structure_id        := structure_id_; 
         detrec_.level_id            := level_id_;
         detrec_.level_id_desc       := level_id_desc_;
         detrec_.structure_node      := structure_node_;
         detrec_.structure_node_desc := structure_node_desc_;
         detrec_.item_below          := item_below_;
         detrec_.item_value          := recb_.name_value;
         detrec_.item_below_type     := item_type_node_db_val_;  -- Structure Node
         detrec_.level_seq           := level_seq_;
         
         -- Get the parent node (the node above) of the current node
         item_above_ := Company_Structure_Item_API.Get_Item_Above(structure_id_, item_type_node_db_decode_val_, detrec_.structure_node);
         detrec_.item_above := item_above_;
         -- store the current node as item below when moving up (using the loop) in the structure
         item_below_ := detrec_.structure_node;
         IF (detrec_.structure_node IS NOT NULL) THEN
            Insert_Det___(detrec_);
            detrec_ := empty_detrec_;
         END IF;
         -- If item_above is null then we have reached the top of the structure and can exit the inner loop
         IF (NVL(item_above_, ' ') = ' ') THEN
            EXIT;
         ELSE 
             -- Setting the current item above as next structure node when moving up (using the loop) in the structure.
            structure_node_ := item_above_;
         END IF;         
      END LOOP;
   END LOOP;
   Refresh_Structure_Cache___(structure_id_); 
END Refresh_Structure_Cache;

PROCEDURE Remove_Structure_Cache(
   structure_id_   IN VARCHAR2)
IS
   
BEGIN
   DELETE FROM COMPANY_STRUCTURE_DET_TAB
   WHERE structure_id = structure_id_;   
END Remove_Structure_Cache;
-------------------- LU  NEW METHODS -------------------------------------
