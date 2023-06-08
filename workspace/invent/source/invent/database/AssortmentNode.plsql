-----------------------------------------------------------------------------
--
--  Logical unit: AssortmentNode
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210831  SBalLK  SC21R2-2442, Replaced Client_SYS.Add_To_Attr by assigning values directly to newrec_ throughout the file.
--  201009  LaDelk   PR2020R1-340, Added validation in Check_Common___ to see the new parent node is same as, or a child of the node being updated.
--  200702  LaDelk   PR2020R1-181, Adding Remove_Root_Node to be called when the Assortment Structure is removed.
--  200701  AyAmlk   PR2020R1-10, STRATEGIC_PROCUREMENT: Override Update___ so the representative setup inherited flag is updated when assortment nodes are moved.
--  200622  LaDelk   PR2020R1-172, Removed server validation for deleting root node.
--  200602  LaDeLK   PR2020R1-155, Added error message to validate inserting already connected part to assortment.
--  200526  LaDelk   PR2020R1-145, Fixed a bug in Remove__, added validations for delete and update of root node and modified get_level_no.
--  181214  LaThlk   Bug 145861(SCZ-2267), Modified the procedure Create_Part_Node__() by adding 3 parameters in order to create the part catalog record with lot quantity rule, sub lot rule and serial rule.
--  171013  AsZelk   Bug 138170, Modified Create_Part_Node__() by adding input_unit_meas_group_id_ in order to save INPUT_UNIT_MEAS_GROUP_ID.
--  170221  IsSalk   STRSC-6097, Added Copy_Node_Structure() to copy node structure to an another assortment.
--  170216  SURBLK   Added Connect_Parts_To_Assortments() to connect multiple parts to multiple assortments.
--  160726  ShPrlk   Bug 128508, Added Get_Class_UoM_By_Class_No() method to validate and retrive the classification uom related to the classification part no and clasification standard.
--  131105  UdGnlk   PBSC-195, Modified base view comments to align with model file errors.
--  130807  MeAblk   Removed the global constant inst_PartcaCompSalesPart_ and modified the method Create_Part_Node__     
--  130807           by removing the method call to  Partca_Company_Sal_Part_API.New_Freight_Information and the parameter order_freight_data_.
--  130731  UdGnlk   TIBE-826, Removed the dynamic code and modify to conditional compilation.
--  120229  GiSalk   Bug 101541, Modified view comments of ASSORTMENT_NODE_PART_CAT to make all the columns to be attributes. 
--  110325  Rakalk   Added receipt_issue_serial_track_db_ parameter to Create_Part_Node__ procedure.
--  100812  NaLrlk   Added method Check_Part_Exist_As_Child.
--  100714  KiSalk   Added parameter catch_unit_enabled_db_ to Create_Part_Node__.
--  090928  ChFolk   Removed unused variables in the package.
--  --------------------------------- 14.0.0 -----------------------------------
--  100312  NaLrlk   Added parameter auto_created_gtin_ to Create_Part_Node__.
--  090714  AmPalk   Bug 83121, Made gtin a varchar2, hence changed the gtin_no_ data type of Create_Part_Node__
--  090220  KiSalk   Added and modified parameters of Create_Part_Node__.
--  090122  MaHplk   Removed STD_CLASSIFICATION_CODE from LU.
--  081022  MiKulk   Modified the method Get_Classification_Defaults to give more meaningful messages.
--  081006  AmPalk   Added parameters to Create_Part_Node__.
--  080918  JeLise   Added view ASSORTMENT_NODE_REBATES.
--  080704  AmPalk   Merged APP75 SP2.
--  ---------------------   APP75 SP2 merge - End ------------------------------
--  080915  NiBalk   Bug 75203. Modified and added new default parameter multilevel_tracking_db_ to Create_Part_Node__().
--  080303  NiBalk   Bug 72023, Modified Get_No_Of_Part_Nodes, by removing an unwanted IF block.
--  ---------------------   APP75 SP2 merge - Start ------------------------------
--  080527  JeLise   Removed method Get_Parent_Node_For_Part.
--  080519  JeLise   Added method Get_Parent_Node_For_Part.
--  080326  KiSalk   Added method Validate_Classification___.
--  080326  KiSalk   Added view ASSORTMENT_NODE_CLASS_PART_LOV and method Get_Classification_Defaults.
--  080313  MaHplk   Added new columns classification_part_no and unit_code to ASSORTMENT_NODE_PART_CAT view.
--  080311  KiSalk   Merged APP75 SP1.
--  ---------------------   APP75 SP1 merge - End ------------------------------
--  071126  AmPalk   Bug 69403, Modified Remove__ to support node removal with all children. Added methods Remove_Immediate_Children___
--  071126           and Remove_Assortment_Defs___. Delete_Sub_Node__ method modified  with the call to Remove_Assortment_Defs___.
--  ---------------------   APP75 SP1 merge - Start ------------------------------
--  080310  MaHplk   Added new method Classification_Parts_Exist.
--  080305  MaHplk   Added classification_part_no and unit_code.
--  080225  AmPalk   Added view ASSORTMENT_NODE_LOV3.
--  080222  MaJalk   Added view ASSORTMENT_NODE_LOV2.
--  ************************************ Nice Price **********************************
--  070829  MiKulk   Modified the view  ASSORTMENT_NODE_LOV1 to increase the performance by removing the ORDER BY Clause.
--  070716  AmPalk   Added Check_Charac_On_Child__.
--  070716  AmPalk   Added code to remove Characteristics Defaults of a top node of a branch when end_attribute gets changed.
--  070712  AmPalk   Added method Update_Branch_Engattr___ to handle the Charach. Template updates.
--  070710  AmPalk   Removed redundant conditions in select statements, which includes CONNECT BY clause.
--  070427  ChBalk   Added SUBSTR for Basic_Data_Translation_API.Get_Basic_Data_Translation returning value.
--  070416  MaMalk   Call 142431, Changed the view comment for ASSORTMENT_NODE_LOV1.assortment_id.
--  070404  MaJalk   At ASSORTMENT_NODE_LOV1, changed view comment of node_level to Assortment Level Name.
--  070328  WaJalk   Modified ASSORTMENT_NODE_LOV1.
--  070321  ViWilk   Added LOV ASSORTMENT_NODE_LOV1 and method Get_Level_No.
--  070308  AmPalk   Altered START WITH statements by adding a condition to check Assortment_ID as well.
--  070226  AmPalk   Updation of both the eng_attribute and charac_tmp_defined_node will be in the method Update___. Inside it, the recursive method call remain same.
--  070226           The method Modify__ changed back to the default code as it was added by the F1 design tool in the begining. The recursive method call has been removed.
--  070226           The method Move_Sub_Node__ will call method Modify__ to update the charac_tmp_defined_node and parent_node, instead of calling method Update___ directly.
--  070220  MoMalk   Modified Check_Node_Exist_As_Child.
--  070216  WaJalk   Added Check_Node_Exist_As_Child and Get_Connected_Parts.
--  070216           Renamed Check_Part_Exist_As_Child as Is_Part_Belongs_To_Node.
--  070215  KeFelk   Changed the Get_Node_Level_Description for better performance.
--  070214  WaJalk   Added method Check_Part_Exist_As_Child.
--  070207  ViWilk   Enable LOV flag of description in the ASSORTMENT_NODE view.
--  070130  AmPalk   Modified Get_Node_Level_Description by adding Cursor get_root_node.
--  070119  KeFelk   Removed Validate_Charac_Template__, Validate_Charc_Temp_Move__, Get_Node_Level_Dtl and template related validation in Unpack_Check_Update___ and Modify__.
--  070117  MiErlk   Modified charac_tmp_defined_node  as Public.
--  070116  NiDalk   Modified where clause of hierarchical query statements.
--  070114  AmPalk   Made Validate_Charac_Template__ and Validate_Charc_Temp_Move__ procedures adhering standards.
--  070111  AmPalk   Characteristic Template Defined Node will be instered default from the parent node's.
--  070111  AmPalk   Restricted saving same Characteristic Template on a Node again and again.
--  070110  AmPalk   Changed Cursor named get_node_with_children, in all the places used to get all the sub nodes insted one level below. Renamed it as get_node_with_all_children.
--  070105  KeFelk   Changes to Delete_Sub_Node__ and Delete___ in order to solve the CASCADE issue.
--  061220  AmPalk   Call 140426. Modified courser used to fetch level in procedures Get_Node_Level_Description and Get_Node_Level_Dtl__.
--  061218  KeFelk   Added method Get_Node_Level_Description.
--  061218  AmPalk   Modified logic in Moving and Modifying Characteristics Template.
--  061213  AmPalk   Implemented method Copy_Node.
--  061211  IsWilk   Added the FUNCTION Get_No_Of_Part_Nodes.
--  061130  IsWilk   Modified the Get_Priority.
--  061125  AmPalk   Added method Check_Exist.
--  061125  NiDalk   Modified assortment_node_id for part nodes same as part_no.
--  061124  IsWilk   Added the Function Get_Priority.
--  061123  MiErlk   Added view ASSORTMENT_NODE_PART_CAT.
--  061121  AmPalk   Added fields and new functionality to maintain STD_CLASSIFICATION_CODE and ENG_ATTRIBUTE (Characteristic Template).
--  061116  AmPalk   Implemented Delete_Sub_Node__ and Move_Sub_Node__.
--  061116  AmPalk   Made methods Move_Sub_Node, Delete_Sub_Node,
--  061116           Create_Sub_Node, Create_Part_Node, Is_Part_Connected and Get_Node_Level_Dtl Private.
--  061113  MiErlk   Added Method Get_Description.
--  061113  MiErlk   Modified method call Get_Level_Name to Get_Name in Get_Node_Level_Dtl.
--  061109  AmPalk   Added method Get_Node_Level_Dtl.
--  061102  NiDalk   Added methods Is_Max_Level and Is_Part_Connected.
--  061031  NiDalk   Added methods Create_Sub_Node and Create_Part_Node.
--  061026  ISWILK   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE part_rec IS RECORD
   (part_no assortment_node_tab.part_no%TYPE);

TYPE part_table IS TABLE OF part_rec;


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Update_Branch_Engattr___ (
   assortment_id_      IN VARCHAR2,
   assortment_node_id_ IN VARCHAR2,
   eng_attribute_      IN VARCHAR2 )
IS
   TYPE Branch_Node_List IS TABLE OF assortment_node_tab%ROWTYPE;
   oldrec_               assortment_node_tab%ROWTYPE;
   newrec_               assortment_node_tab%ROWTYPE;
   temp_defined_node_    assortment_node_tab.assortment_node_id%TYPE;

   CURSOR get_branch_nodes IS
      SELECT *
      FROM assortment_node_tab
      START WITH       assortment_id      = assortment_id_
             AND       assortment_node_id = assortment_node_id_
      CONNECT BY PRIOR assortment_id      = assortment_id
      AND PRIOR        assortment_node_id = parent_node
      FOR UPDATE;

      branch_nodes_         Branch_Node_List;
BEGIN
   OPEN get_branch_nodes;
   FETCH get_branch_nodes BULK COLLECT INTO branch_nodes_;
   CLOSE get_branch_nodes;

   FOR i_ IN branch_nodes_.FIRST .. branch_nodes_.LAST LOOP
      oldrec_ := branch_nodes_(i_);
      newrec_ := oldrec_;
      IF eng_attribute_ IS NOT NULL THEN
         temp_defined_node_ := assortment_node_id_;
      ELSE
         temp_defined_node_ := NULL;
      END IF;
      newrec_.eng_attribute           := eng_attribute_;
      newrec_.charac_tmp_defined_node := temp_defined_node_;
      Modify___(newrec_);
      IF (oldrec_.eng_attribute IS NOT NULL) AND (newrec_.eng_attribute IS NULL OR oldrec_.eng_attribute != newrec_.eng_attribute) THEN
         -- Note : the top most node does not get updated at this point
          Assortment_Inv_Char_Def_API.Remove(newrec_.assortment_id, newrec_.assortment_node_id);
      END IF;
   END LOOP;
END Update_Branch_Engattr___;


-- Remove_Assortment_Defs___
--   This will remove the Assortment_Inv_Char_Def, Assortment_Invent_Def,
--   Assortment_Part_Supp_Def, Assortment_Purch_Def, Assortment_Sales_Def records of a given assortment node.
PROCEDURE Remove_Assortment_Defs___ (
   assortment_id_ IN VARCHAR2,
   assortment_node_id_ IN VARCHAR2 )
IS   
BEGIN
   Assortment_Inv_Char_Def_API.Remove(assortment_id_, assortment_node_id_);
   Assortment_Invent_Def_API.Remove(assortment_id_, assortment_node_id_);
   
   $IF (Component_Purch_SYS.INSTALLED) $THEN
      Assortment_Part_Supp_Def_API.Remove(assortment_id_,
                                          assortment_node_id_ );
      Assortment_Purch_Def_API.Remove(assortment_id_,
                                      assortment_node_id_ );
   $END   
  
  $IF (Component_Order_SYS.INSTALLED) $THEN
     Assortment_Sales_Def_API.Remove(assortment_id_,
                                     assortment_node_id_ );
  $END 
 END Remove_Assortment_Defs___;


-- Remove_Immediate_Children___
--   This will remove immediate children nodes with theire sub nodes of a node given.
PROCEDURE Remove_Immediate_Children___ (
   assortment_id_ IN VARCHAR2,
   assortment_node_id_ IN VARCHAR2 )
IS   
   CURSOR get_immediate_children IS
      SELECT *
      FROM assortment_node_tab
      WHERE assortment_id = assortment_id_
      AND parent_node = assortment_node_id_;
BEGIN
   FOR rec_ IN get_immediate_children LOOP
      Remove___(rec_, FALSE);
   END LOOP;
END Remove_Immediate_Children___;


-- Validate_Classification___
--   Check if Classification Part and UoM are not duplicated for the assortment.
PROCEDURE Validate_Classification___ (
   rec_ IN assortment_node_tab%ROWTYPE )
IS
   temp_  assortment_node_tab.part_no%TYPE;
   CURSOR get_existing_rec (assortment_id_ VARCHAR2, classification_part_no_ VARCHAR2, classification_unit_meas_ VARCHAR2) IS
      SELECT part_no
      FROM   assortment_node_tab
      WHERE  assortment_id = assortment_id_
      AND    classification_part_no = classification_part_no_
      AND    unit_code = classification_unit_meas_;
BEGIN
   IF (Assortment_Structure_API.Get_Classification_Standard(rec_.assortment_id) IS NULL) THEN
      IF (rec_.classification_part_no IS NOT NULL OR rec_.classification_part_no IS NOT NULL) THEN
         Error_SYS.Record_General(lu_name_, 'CLASSSTDNULLERR: Classification part number and classification UoM cannot be entered without a valid classification standard.');
      END IF;
   ELSE
      IF (rec_.classification_part_no IS NOT NULL) THEN
         IF (rec_.unit_code IS NULL) THEN
            Error_SYS.Record_General(lu_name_, 'NOUNITCODE: Classification UoM does not exist.');
         ELSE
            OPEN get_existing_rec (rec_.assortment_id, rec_.classification_part_no, rec_.unit_code);
            FETCH get_existing_rec INTO temp_;
            IF (get_existing_rec%FOUND) THEN
               IF (rec_.part_no != temp_) THEN
                  CLOSE get_existing_rec;
                  Error_SYS.Record_General(lu_name_, 'CLASSUOMDUPLIERR: Classification part number :P1 with UoM :P2 already exist. Please use different UoM.', rec_.classification_part_no, rec_.unit_code);
               END IF;
            END IF;
            CLOSE get_existing_rec;
         END IF;
      END IF;
   END IF;
END Validate_Classification___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT assortment_node_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_                 VARCHAR2(30);
   value_                VARCHAR2(2000);
   parent_eng_attribute_ assortment_node_tab.eng_attribute%TYPE;

BEGIN
   IF (newrec_.part_no IS NOT NULL) THEN
      IF Check_Exist(newrec_.assortment_id, newrec_.part_no) = 1 THEN
         Error_SYS.Record_General(lu_name_, 'DUPLICATEPART: The part is already connected to a node in assortment :P1.', newrec_.assortment_id);
      END IF;
      newrec_.assortment_node_id := newrec_.part_no;
      newrec_.description        := Part_Catalog_API.Get_Description(newrec_.part_no);
   END IF;

   IF (newrec_.parent_node IS NOT NULL) THEN
      parent_eng_attribute_ := Get_Eng_Attribute(newrec_.assortment_id,newrec_.parent_node);
   END IF;

   IF (newrec_.eng_attribute IS NOT NULL AND parent_eng_attribute_ IS NOT NULL) THEN
      IF parent_eng_attribute_ != NVL(newrec_.eng_attribute, CHR(32)) THEN
         Error_SYS.Record_General(lu_name_, 'INVALIDENGATTRIBUTE: The Characteristic Template for a node and a sub node cannot be different.');
      END IF;
   END IF;

   -- if parent has a Template take it and save for the child
   IF (parent_eng_attribute_ IS NOT NULL) THEN
      newrec_.eng_attribute := parent_eng_attribute_;
      newrec_.charac_tmp_defined_node := Get_Charac_Tmp_Defined_Node(newrec_.assortment_id, newrec_.parent_node);
   END IF;

   Validate_Classification___(newrec_);
   super(newrec_, indrec_, attr_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     assortment_node_tab%ROWTYPE,
   newrec_ IN OUT assortment_node_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_   VARCHAR2(30);
   value_  VARCHAR2(4000);
BEGIN
   IF oldrec_.parent_node IS NULL AND newrec_.parent_node IS NOT NULL THEN
      Error_SYS.Record_General(lu_name_, 'ROOTNODEUPDATE: Root node''s parent node cannot be updated.');
   END IF; 
   Validate_Classification___(newrec_);
   super(oldrec_, newrec_, indrec_, attr_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     assortment_node_tab%ROWTYPE,
   newrec_ IN OUT assortment_node_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   --Add pre-processing code here
   super(oldrec_, newrec_, indrec_, attr_);
   IF Validate_SYS.Is_Changed(oldrec_.parent_node, newrec_.parent_node) AND 
      Check_Node_Exist_As_Child(newrec_.assortment_id, newrec_.assortment_node_id, newrec_.parent_node)= 1 THEN
      Error_SYS.Record_General(lu_name_, 'INVALIDPARENTNODE: A node cannot be moved to the same node or to a child node.');
   END IF;
END Check_Common___;

@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     assortment_node_tab%ROWTYPE,
   newrec_     IN OUT assortment_node_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   --Add pre-processing code here
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   
   -- STRATEGIC_PROCUREMENT: start
   $IF (Component_Srm_SYS.INSTALLED) $THEN
   -- Update the representative setup inheritance when a node is moved
   IF Validate_SYS.Is_Changed(oldrec_.parent_node, newrec_.parent_node) AND
      Assortment_Structure_API.Get_Proc_Category_Assortmen_Db(newrec_.assortment_id) = Fnd_Boolean_API.DB_TRUE THEN
      
      Proc_Category_Rep_Setup_API.Handle_Move_Assortment_Node(newrec_.assortment_id, newrec_.assortment_node_id, newrec_.parent_node);
   END IF;
   $END
   -- STRATEGIC_PROCUREMENT: end
END Update___;

-- Delete_Node___
--   Method call to delete a node. All its sub nodes will be automatically deleted.
PROCEDURE Delete_Node___ (
   assortment_id_      IN VARCHAR2,
   assortment_node_id_ IN VARCHAR2 )
IS
   remrec_  assortment_node_tab%ROWTYPE;   
BEGIN
   remrec_ := Get_Object_By_Keys___(assortment_id_, assortment_node_id_);
   Remove___(remrec_, FALSE);
END Delete_Node___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@Override
PROCEDURE Modify__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   oldrec_  assortment_node_tab%ROWTYPE;
   newrec_  assortment_node_tab%ROWTYPE;
BEGIN
   IF (action_ = 'DO')THEN
      oldrec_ := Lock_By_Id___(objid_, objversion_);
      super(info_, objid_, objversion_, attr_, action_);   
      newrec_ := Get_Object_By_Id___(objid_);
      
      IF (oldrec_.eng_attribute IS NOT NULL) AND (newrec_.eng_attribute IS NULL OR oldrec_.eng_attribute != newrec_.eng_attribute) THEN
          Assortment_Inv_Char_Def_API.Remove(newrec_.assortment_id, newrec_.assortment_node_id);
      END IF;
      IF (NVL(newrec_.eng_attribute,CHR(32)) != NVL(oldrec_.eng_attribute,CHR(32))) THEN
         Update_Branch_Engattr___(newrec_.assortment_id, newrec_.assortment_node_id, newrec_.eng_attribute);
      END IF;
   ELSIF (action_ = 'CHECK') THEN
      super(info_, objid_, objversion_, attr_, action_); 
   END IF;
END Modify__;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN assortment_node_tab%ROWTYPE )
IS
   
BEGIN
   Remove_Assortment_Defs___(remrec_.assortment_id, remrec_.assortment_node_id);
   -- Removal with all children. Rdcursively delete all sub nodes in the tree.
   Remove_Immediate_Children___(remrec_.assortment_id, remrec_.assortment_node_id);
   super(objid_, remrec_);
END Delete___;

-- Move_Sub_Node__
--   Method call to move a node and all its sub nodes.
PROCEDURE Move_Sub_Node__ (
   assortment_id_ IN VARCHAR2,
   old_node_id_   IN VARCHAR2,
   new_node_id_   IN VARCHAR2 )
IS
   attr_             VARCHAR2(2000);
   info_             VARCHAR2(2000);

   CURSOR get_nodes IS
      SELECT rowid objid, to_char(rowversion,'YYYYMMDDHH24MISS') objversion
      FROM assortment_node_tab
      WHERE assortment_node_id = old_node_id_
      AND assortment_id = assortment_id_;

   rec_     get_nodes%ROWTYPE;
BEGIN

   OPEN get_nodes;
   FETCH get_nodes INTO rec_;

   IF get_nodes%FOUND THEN
      Client_SYS.Clear_Attr(attr_);
      IF ( NVL(Get_Eng_Attribute(assortment_id_, new_node_id_), CHR(32)) != NVL(Get_Eng_Attribute(assortment_id_,old_node_id_), CHR(32))) THEN
         Error_SYS.Record_General(lu_name_, 'INVALIDENGATTRIBUTE: The Characteristic Template for a node and a sub node cannot be different.');
      END IF;
      Client_Sys.Add_To_Attr('PARENT_NODE',new_node_id_,attr_);
      Client_Sys.Add_To_Attr('CHARAC_TMP_DEFINED_NODE',Get_Charac_Tmp_Defined_Node(assortment_id_, new_node_id_),attr_);

      Modify__(info_, rec_.objid, rec_.objversion,attr_, 'DO');
   ELSE
      Trace_SYS.Message('Assortment ''' || old_node_id_ || ''' not found');
   END IF;
   CLOSE get_nodes;
END Move_Sub_Node__;


-- Delete_Sub_Node__
--   Method used by client to delete a node. Sub nodes will be automatically deleted.
PROCEDURE Delete_Sub_Node__ (
   assortment_id_      IN VARCHAR2,
   assortment_node_id_ IN VARCHAR2 )
IS
BEGIN
   Delete_Node___(assortment_id_, assortment_node_id_);
END Delete_Sub_Node__;


PROCEDURE Create_Sub_Node__ (
   assortment_id_      IN VARCHAR2,
   assortment_node_id_ IN VARCHAR2,
   description_        IN VARCHAR2,
   parent_node_        IN VARCHAR2,
   part_no_            IN VARCHAR2 )
IS
   newrec_        assortment_node_tab%ROWTYPE;
BEGIN
   newrec_.assortment_id      := assortment_id_;
   newrec_.assortment_node_id := assortment_node_id_;
   newrec_.description        := description_;
   newrec_.parent_node        := parent_node_;
   newrec_.part_no            := part_no_;
   New___(newrec_);
END Create_Sub_Node__;

PROCEDURE Create_Part_Node__ (
   assortment_id_                   IN VARCHAR2,
   part_no_                         IN VARCHAR2,
   description_                     IN VARCHAR2,
   unit_code_                       IN VARCHAR2,
   parent_node_                     IN VARCHAR2,
   std_name_id_                     IN NUMBER,
   info_text_                       IN VARCHAR2,
   part_main_group_                 IN VARCHAR2,
   eng_serial_tracking_code_        IN VARCHAR2,
   serial_tracking_code_            IN VARCHAR2,
   configurable_db_                 IN VARCHAR2,
   condition_code_usage_db_         IN VARCHAR2,
   lot_tracking_code_db_            IN VARCHAR2,
   position_part_db_                IN VARCHAR2,
   gtin_no_                         IN VARCHAR2,
   gtin_series_db_                  IN VARCHAR2,
   weight_net_                      IN NUMBER,
   uom_for_weight_net_              IN VARCHAR2,
   volume_net_                      IN NUMBER,
   uom_for_volume_net_              IN VARCHAR2,
   freight_factor_                  IN NUMBER,
   catch_unit_enabled_db_           IN VARCHAR2 DEFAULT 'FALSE',
   multilevel_tracking_db_          IN VARCHAR2 DEFAULT 'TRACKING OFF',
   auto_created_gtin_               IN VARCHAR2 DEFAULT 'FALSE', 
   receipt_issue_serial_track_db_   IN VARCHAR2 DEFAULT 'FALSE',
   input_unit_meas_group_id_        IN VARCHAR2 DEFAULT NULL,
   lot_quantity_rule_               IN VARCHAR2 DEFAULT NULL,
   sub_lot_rule_                    IN VARCHAR2 DEFAULT NULL,
   serial_rule_                     IN VARCHAR2 DEFAULT NULL)
IS
   assortment_node_id_       ASSORTMENT_NODE.assortment_node_id%TYPE;
   assortment_node_desc_     ASSORTMENT_NODE.description%TYPE;   
BEGIN
   
   Part_Catalog_API.Create_Part(part_no_                       => part_no_,
                                description_                   => description_,
                                unit_code_                     => unit_code_,
                                std_name_id_                   => std_name_id_,
                                info_text_                     => info_text_,
                                part_main_group_               => part_main_group_,
                                eng_serial_tracking_code_      => eng_serial_tracking_code_,
                                serial_tracking_code_          => serial_tracking_code_,
                                configurable_db_               => NVL(configurable_db_, 'NOT CONFIGURED'),
                                condition_code_usage_db_       => NVL(condition_code_usage_db_, 'NOT_ALLOW_COND_CODE'),
                                lot_tracking_code_db_          => NVL(lot_tracking_code_db_, 'NOT LOT TRACKING'),
                                position_part_db_              => NVL(position_part_db_, 'NOT POSITION PART'),
                                catch_unit_enabled_db_         => catch_unit_enabled_db_,
                                multilevel_tracking_db_        => multilevel_tracking_db_,
                                gtin_no_                       => gtin_no_,
                                gtin_series_db_                => gtin_series_db_,
                                weight_net_                    => weight_net_,
                                uom_for_weight_net_            => uom_for_weight_net_,
                                volume_net_                    => volume_net_,
                                uom_for_volume_net_            => uom_for_volume_net_,
                                freight_factor_                => freight_factor_,
                                auto_created_gtin_             => auto_created_gtin_,
                                receipt_issue_serial_track_db_ => receipt_issue_serial_track_db_,
                                input_unit_meas_group_id_      => input_unit_meas_group_id_,
                                lot_quantity_rule_             => lot_quantity_rule_,
                                sub_lot_rule_                  => sub_lot_rule_,
                                serial_rule_                   => serial_rule_);

   assortment_node_id_ := part_no_;
   assortment_node_desc_ := description_;
   Create_Sub_Node__(assortment_id_,
                     assortment_node_id_,
                     assortment_node_desc_,
                     parent_node_,
                     part_no_ );
END Create_Part_Node__;


-- Check_Charac_On_Child__
--   Return 1 if a child node has a eng attr (Charach. Template) defined on it.
@UncheckedAccess
FUNCTION Check_Charac_On_Child__ (
   assortment_id_ IN VARCHAR2,
   assortment_node_id_ IN VARCHAR2,
   eng_attribute_ IN VARCHAR2 ) RETURN NUMBER
IS
  return_val_         NUMBER;
   CURSOR get_child_with_template IS
      SELECT 1
      FROM   assortment_node_tab
      WHERE  eng_attribute IS NOT NULL
      AND    eng_attribute != NVL(eng_attribute_, CHR(32))
      START WITH       assortment_id = assortment_id_
             AND       assortment_node_id = assortment_node_id_
      CONNECT BY PRIOR assortment_id = assortment_id
      AND PRIOR        assortment_node_id = parent_node;
BEGIN
   OPEN get_child_with_template;
   FETCH get_child_with_template INTO return_val_;
      IF (get_child_with_template%NOTFOUND) THEN
         return_val_ := 0;
      END IF;
   CLOSE get_child_with_template;
   RETURN return_val_;
END Check_Charac_On_Child__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Unit_Code (
   assortment_id_ IN VARCHAR2,
   assortment_node_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ assortment_node_tab.unit_code%TYPE;
   CURSOR get_attr IS
      SELECT unit_code
      FROM assortment_node_tab
      WHERE assortment_id = assortment_id_
      AND   assortment_node_id = assortment_node_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Unit_Code;


@UncheckedAccess
FUNCTION Get_Description (
   assortment_id_      IN VARCHAR2,
   assortment_node_id_ IN VARCHAR2,
   language_code_      IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
   description_  assortment_node_tab.description%TYPE;

   CURSOR get_description IS
      SELECT description
         FROM assortment_node_tab
         WHERE assortment_id = assortment_id_
         AND assortment_node_id = assortment_node_id_;
BEGIN
   description_ := SUBSTR(Basic_Data_Translation_API.Get_Basic_Data_Translation('INVENT',
                                                                                'AssortmentNode',
                                                                                 assortment_id_ || '^' || assortment_node_id_ ,
                                                                                 language_code_), 1, 200);
   IF (description_ IS NULL) THEN
      OPEN get_description;
      FETCH get_description INTO description_;
      CLOSE get_description;
   END IF;
   RETURN description_;
END Get_Description;


FUNCTION Check_Exist (
   assortment_id_      IN VARCHAR2,
   assortment_node_id_ IN VARCHAR2 ) RETURN NUMBER
IS
  return_val_   NUMBER := 0;
BEGIN
   IF (Check_Exist___(assortment_id_, assortment_node_id_)) THEN
      return_val_ := 1;
   END IF;
   RETURN return_val_;
END Check_Exist;


PROCEDURE Copy_Node (
   assortment_id_      IN VARCHAR2,
   assortment_node_id_ IN VARCHAR2,
   new_assort_id_      IN VARCHAR2,
   new_node_id_        IN VARCHAR2,
   new_node_desc_      IN VARCHAR2 )
IS
   newrec_                assortment_node_tab%ROWTYPE;
   temp_node_id_          assortment_node_tab.assortment_node_id%TYPE;
   temp_parent_node_      assortment_node_tab.parent_node%TYPE;
   temp_node_desc_        assortment_node_tab.description%TYPE;
   CURSOR get_node IS
      SELECT parent_node, part_no, eng_attribute, charac_tmp_defined_node
      FROM assortment_node_tab
      WHERE assortment_id = assortment_id_
      AND assortment_node_id = assortment_node_id_;
   rec_     get_node%ROWTYPE;
BEGIN
   newrec_.assortment_id := new_assort_id_;
   -- The Root Node of the new Assortment Structure will be the Assortment Structure ID.
   IF (new_node_id_ = assortment_id_) THEN
      temp_node_id_  := new_assort_id_;
      temp_node_desc_ := Assortment_Structure_API.Get_Description(new_assort_id_);
   ELSE
      temp_node_id_  := new_node_id_;
      temp_node_desc_  := Get_Description(assortment_id_,assortment_node_id_);
   END IF;
   newrec_.assortment_node_id := temp_node_id_;
   newrec_.description        := NVL(new_node_desc_,temp_node_desc_);

   OPEN get_node;
   FETCH get_node INTO rec_;
   CLOSE get_node;

   -- The Root Node of the new Assortment Structure will be the Assortment Structure ID.
   IF (rec_.parent_node IS NOT NULL) THEN
      IF (rec_.parent_node = assortment_id_) THEN
         temp_parent_node_  := new_assort_id_;
      ELSE
         temp_parent_node_  := rec_.parent_node;
      END IF;
      newrec_.parent_node := temp_parent_node_;
   END IF;
   newrec_.part_no                 := rec_.part_no;
   newrec_.eng_attribute           := rec_.eng_attribute;
   newrec_.charac_tmp_defined_node := rec_.charac_tmp_defined_node;
   New___(newrec_);
END Copy_Node;


-- Copy_Nodes_To_Assortment
--    Copy node structure to an another assortment.
PROCEDURE Copy_Node_Structure (
   from_assortment_id_  IN VARCHAR2,
   from_assort_node_id_ IN VARCHAR2,
   to_assortment_id_    IN VARCHAR2,
   to_assortment_desc_  IN VARCHAR2,
   to_assort_node_id_   IN VARCHAR2,
   new_assortment_      IN VARCHAR2)
IS
   parent_node_           assortment_node_tab.parent_node%TYPE; 
   rec_                   assortment_node_tab%ROWTYPE;
   
   CURSOR get_sub_nodes IS
      SELECT *
      FROM   assortment_node_tab
      START WITH       assortment_id = from_assortment_id_
             AND       assortment_node_id = from_assort_node_id_
      CONNECT BY PRIOR assortment_id = assortment_id
      AND PRIOR        assortment_node_id = parent_node;
BEGIN
   IF (new_assortment_ = 'TRUE') THEN
      parent_node_ := to_assortment_id_;
   ELSE
      IF (to_assort_node_id_ IS NOT NULL) THEN
         Exist(to_assortment_id_, to_assort_node_id_);
         IF (Check_Part_Exist_As_Child(to_assortment_id_, to_assort_node_id_, to_assort_node_id_) = 1) THEN
            Error_SYS.Record_General(lu_name_, 'CANNOTCOPY: Cannot copy to an assortment node that is connected to a part');
         END IF;
         parent_node_ := to_assort_node_id_;
      ELSE
         parent_node_ := to_assortment_id_;
      END IF;
   END IF;
   
   FOR node_rec_ IN get_sub_nodes LOOP
      IF (node_rec_.assortment_node_id != from_assort_node_id_) THEN
         parent_node_ := node_rec_.parent_node;
      END IF;
      rec_.assortment_id := to_assortment_id_;
      rec_.assortment_node_id := node_rec_.assortment_node_id;
      rec_.description := node_rec_.description;
      rec_.parent_node := parent_node_;
      rec_.part_no := node_rec_.part_no;
      rec_.eng_attribute := node_rec_.eng_attribute;
      rec_.charac_tmp_defined_node := node_rec_.charac_tmp_defined_node;
      New___(rec_);
   END LOOP;
   
END Copy_Node_Structure;


@UncheckedAccess
FUNCTION Get_No_Of_Part_Nodes (
   assortment_id_      IN VARCHAR2,
   assortment_node_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   no_of_all_part_nodes_ NUMBER := 0;

   CURSOR get_child_all_part_nodes IS
      SELECT COUNT(part_no)
      FROM   assortment_node_tab
      WHERE  part_no IS NOT NULL
      START WITH       assortment_id = assortment_id_
             AND       assortment_node_id = assortment_node_id_
      CONNECT BY PRIOR assortment_id = assortment_id
      AND PRIOR        assortment_node_id = parent_node;

BEGIN
   OPEN get_child_all_part_nodes;
   FETCH get_child_all_part_nodes INTO no_of_all_part_nodes_;
   CLOSE get_child_all_part_nodes;
   RETURN no_of_all_part_nodes_;
END Get_No_Of_Part_Nodes;


@UncheckedAccess
FUNCTION Get_Node_Level_Description (
   assortment_id_      IN VARCHAR2,
   assortment_node_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   structure_level_    NUMBER;
BEGIN
   structure_level_ := Get_Level_No(assortment_id_,assortment_node_id_);

   RETURN Assortment_Structure_Level_API.Get_Name(assortment_id_,structure_level_);
END Get_Node_Level_Description;


-- Is_Part_Belongs_To_Node
--   Checks if the part is connected a descendant node of the assortment node.
@UncheckedAccess
FUNCTION Is_Part_Belongs_To_Node (
   assortment_id_      IN VARCHAR2,
   assortment_node_id_ IN VARCHAR2,
   part_no_            IN VARCHAR2 ) RETURN NUMBER
IS
   return_val_   NUMBER;
   node_         assortment_node_tab.Assortment_Node_Id%TYPE;

   CURSOR get_node_for_part IS
      SELECT assortment_node_id
      FROM   assortment_node_tab
      WHERE  assortment_id = assortment_id_
      AND    part_no = part_no_;
BEGIN
   OPEN get_node_for_part;
   FETCH get_node_for_part INTO node_;
   IF (get_node_for_part%NOTFOUND) THEN
      return_val_ := 0;
   END IF;
   CLOSE get_node_for_part;
   return_val_ := Check_Node_Exist_As_Child(assortment_id_, assortment_node_id_, node_);
   RETURN return_val_;
END Is_Part_Belongs_To_Node;


-- Check_Node_Exist_As_Child
--   Checks if the child_node is connected as a descendant node of
--   the assortment_node or the assortment_node itself.
@UncheckedAccess
FUNCTION Check_Node_Exist_As_Child (
   assortment_id_      IN VARCHAR2,
   assortment_node_id_ IN VARCHAR2,
   child_node_id_      IN VARCHAR2 ) RETURN NUMBER
IS
   return_val_   NUMBER :=0;
   parent_node_        assortment_node_tab.parent_node%TYPE;
BEGIN
   --Checks whether the parent node itself is passed as the child node
   IF assortment_node_id_ = child_node_id_ THEN
      return_val_ := 1;
      RETURN return_val_;
   END IF;
   parent_node_ := Get_Parent_Node(assortment_id_, child_node_id_);
   WHILE parent_node_ IS NOT NULL LOOP
      IF parent_node_ = assortment_node_id_ THEN
         return_val_ := 1;
         RETURN return_val_;
      ELSE
         parent_node_ := Get_Parent_Node(assortment_id_, parent_node_);
      END IF;
   END LOOP;
   RETURN return_val_;
END Check_Node_Exist_As_Child;


@UncheckedAccess
FUNCTION Get_Connected_Parts (
   assortment_id_      IN VARCHAR2,
   assortment_node_id_ IN VARCHAR2 ) RETURN part_table
IS
   CURSOR get_parts IS
      SELECT part_no
      FROM   assortment_node_tab
      WHERE  part_no IS NOT NULL
      START WITH        assortment_id = assortment_id_
             AND        assortment_node_id = assortment_node_id_
      CONNECT BY PRIOR  assortment_id = assortment_id
      AND PRIOR         assortment_node_id = parent_node;

   parts_tab_     part_table;
BEGIN
   OPEN get_parts;
   FETCH get_parts BULK COLLECT INTO parts_tab_;
   CLOSE get_parts;
   RETURN parts_tab_;
END Get_Connected_Parts;


-- Get_Level_No
--   Returns the Cluster Level Number of the node.
@UncheckedAccess
FUNCTION Get_Level_No (
   assortment_id_      IN VARCHAR2,
   assortment_node_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   assortment_cluster_level_  NUMBER := 0;
   parent_node_               assortment_node_tab.parent_node%TYPE;
BEGIN
   IF assortment_id_ IS NOT NULL AND assortment_node_id_ IS NOT NULL THEN    
      assortment_cluster_level_ := assortment_cluster_level_ + 1;
      parent_node_ := Get_Parent_Node(assortment_id_, assortment_node_id_);

      WHILE parent_node_ IS NOT NULL LOOP
         parent_node_ := Get_Parent_Node(assortment_id_, parent_node_);
         assortment_cluster_level_ := assortment_cluster_level_ + 1;
      END LOOP;
   END IF;
   RETURN assortment_cluster_level_;
END Get_Level_No;


@UncheckedAccess
FUNCTION Classification_Parts_Exist (
   assortment_id_      IN VARCHAR2) RETURN NUMBER
IS
   return_val_         NUMBER:=1;
   temp_               NUMBER;
   CURSOR get_classification_part IS
      SELECT 1
      FROM   assortment_node_tab
      WHERE  assortment_id = assortment_id_
      AND    classification_part_no IS NOT NULL;
BEGIN
   OPEN get_classification_part;
   FETCH get_classification_part INTO temp_;
   IF (get_classification_part%NOTFOUND)THEN
      return_val_ := 0;
   END IF;
   CLOSE get_classification_part;
   RETURN return_val_;
END Classification_Parts_Exist;

-- Get_Class_UoM_By_Class_No
--   Returns the respective UoM if the classificatoin_part_no_ is only connected to one UoM


PROCEDURE Get_Class_UoM_By_Class_No(
   classification_unit_meas_  IN OUT VARCHAR2,
   classification_part_no_    IN VARCHAR2, 
   classification_standard_   IN VARCHAR2 ) 
IS    
   dummy_          NUMBER;
   count_parts_    NUMBER :=0;
   temp_uom_       assortment_node_tab.unit_code%TYPE;        
   assortment_id_  assortment_node_tab.assortment_id%TYPE;
   
   CURSOR check_exist IS 
      SELECT 1
      FROM  assortment_node_tab ant
      WHERE ant.classification_part_no  = classification_part_no_
      AND   ant.unit_code               = classification_unit_meas_
      AND   ant.assortment_id           = assortment_id_;
   
   CURSOR get_classification_uom IS      
      SELECT ant.unit_code,ant.assortment_id
      FROM   assortment_node_tab ant
      WHERE  ant.classification_part_no = classification_part_no_
      AND    ant.assortment_id          = assortment_id_;       
BEGIN   
   
   assortment_id_ := Assortment_Structure_API.Get_Assort_For_Classification(classification_standard_);
   
   OPEN  check_exist;
   FETCH check_exist INTO dummy_;
   IF check_exist%NOTFOUND THEN   
      FOR rec_ IN get_classification_uom LOOP
         count_parts_:= count_parts_+1;             
         temp_uom_   := rec_.unit_code;       
         EXIT WHEN count_parts_ > 1; 
      END LOOP; 
      IF(count_parts_ = 1) THEN 
         classification_unit_meas_ :=temp_uom_;
      END IF;      
   END IF; 
   CLOSE check_exist;
   
END Get_Class_UoM_By_Class_No;

-- Get_Classification_Defaults
--   If part_no_ has a value, fetches classification_part_no_ and classification_unit_meas_.
--   If no part_no_ and both classification_part_no_ and classification_unit_meas_ have a values,
--   fetches part_no_ when unique value is found; gives error otherwise.
--   If no part_no_ and only classification_part_no_ has a value, fetches part_no_ and
--   classification_unit_meas_ when unique values are found; gives error otherwise.
PROCEDURE Get_Classification_Defaults (
   classification_unit_meas_ IN OUT VARCHAR2,
   part_no_                  IN OUT VARCHAR2,
   classification_part_no_   IN OUT VARCHAR2,
   classification_standard_  IN     VARCHAR2,
   show_all_errors_          IN     VARCHAR2 )
IS
  assortment_id_  assortment_node_tab.assortment_id%TYPE;
  record_count_   NUMBER;
  exist_classification_part_ NUMBER;

   CURSOR get_default_values IS
      SELECT classification_part_no, part_no, unit_code
      FROM   assortment_node_tab
      WHERE  assortment_id = assortment_id_
      AND    (part_no = part_no_ OR ( part_no_ IS NULL
                                      AND classification_part_no = classification_part_no_
                                      AND unit_code = NVL(classification_unit_meas_,unit_code)));

   CURSOR get_record_count IS
      SELECT count(part_no)
      FROM   assortment_node_tab
      WHERE  assortment_id = assortment_id_
      AND    classification_part_no = classification_part_no_
      AND    unit_code = NVL(classification_unit_meas_,unit_code);

   CURSOR check_classification_part_no IS
      SELECT 1
      FROM   assortment_node_tab
      WHERE  assortment_id = assortment_id_
      AND    classification_part_no = classification_part_no_;

BEGIN

   -- get the assortment id  for the given  classification standard
   assortment_id_ := Assortment_Structure_API.Get_Assort_For_Classification(classification_standard_);

   IF  assortment_id_ IS NULL AND classification_standard_ IS NOT NULL THEN
      Error_SYS.Record_General(lu_name_, 'NOACTIVEASSORT: An Active Assortment does not exist for the given Classification Standard.');
   END IF;

   IF classification_unit_meas_ IS NOT NULL THEN
      Iso_Unit_API.Exist(classification_unit_meas_);
   END IF;

   IF classification_part_no_ IS NOT NULL THEN
      OPEN check_classification_part_no;
      FETCH check_classification_part_no INTO exist_classification_part_;
      IF  check_classification_part_no%NOTFOUND THEN
         CLOSE check_classification_part_no;
         Error_SYS.Record_General(lu_name_, 'NOCLASSPARTSNULL: The classification part number does not exist for assortment :P1, Classification standard :P2.', assortment_id_, classification_standard_);
      END IF;
      CLOSE check_classification_part_no;
   END IF;

   -- The classification part no is given and there could be many part nos connected to that class part no
   IF (classification_part_no_ IS NOT NULL AND part_no_ IS NULL) THEN
      OPEN get_record_count;
      FETCH get_record_count INTO record_count_;
      CLOSE get_record_count;
      IF (record_count_ > 1)THEN
         IF (show_all_errors_ = 'TRUE') THEN
            Error_SYS.Record_General(lu_name_, 'MULTIPLEPARTNOS: The classification part number :P1 is defined for more than one sales part in the assortment :P2 of classification standard :P3.', classification_part_no_, assortment_id_, classification_standard_);
         ELSE
            RETURN;
         END IF;
      ELSIF (record_count_ = 0) THEN
         Error_SYS.Record_General(lu_name_, 'NOTVALIDUNITCODE: The classification unit of measure :P1 does not exist for classification part number :P2 in classification standard :P3.',classification_unit_meas_, classification_part_no_, classification_standard_);
      END IF;
   END IF;

   IF (part_no_ IS NOT NULL OR classification_part_no_ IS NOT NULL) THEN
      OPEN get_default_values;
      FETCH get_default_values INTO classification_part_no_, part_no_, classification_unit_meas_;
      CLOSE get_default_values;
   END IF;
END Get_Classification_Defaults;


-- Check_Part_Exist_As_Child
--   Checks if the given part or parts likes the given part no is connected as a descendant node of
--   the assortment_id and assortment_node.
@UncheckedAccess
FUNCTION Check_Part_Exist_As_Child (
   assortment_id_      IN VARCHAR2,
   assortment_node_id_ IN VARCHAR2,
   part_no_            IN VARCHAR2 ) RETURN NUMBER
IS
   part_exists_   NUMBER := 0;
   CURSOR get_node_for_part IS
      SELECT assortment_node_id
        FROM assortment_node_tab
       WHERE assortment_id = assortment_id_
         AND part_no LIKE part_no_;
BEGIN
   FOR part_rec_ IN get_node_for_part LOOP
      IF (Check_Node_Exist_As_Child(assortment_id_, assortment_node_id_, part_rec_.assortment_node_id) = 1) THEN
         part_exists_ := 1;
         EXIT;
      END IF;
   END LOOP;
   RETURN part_exists_;
END Check_Part_Exist_As_Child;


-- Connect_Parts_To_Assortments
--   Add multiple parts to multiple assortments.
@UncheckedAccess
PROCEDURE Connect_Parts_To_Assortments(    
   parts_assortment_list_  IN CLOB )
IS
   names_msg_               Message_SYS.name_table_clob;
   values_msg_              Message_SYS.line_table_clob;
   name_assorts_            Message_SYS.name_table;
   values_assorts_          Message_SYS.line_table; 
   name_assorts_eliment_    Message_SYS.name_table;
   values_assorts_eliment_  Message_SYS.line_table;
   name_parts_              Message_SYS.name_table;
   values_parts_            Message_SYS.line_table; 
   part_list_               CLOB;
   assortment_list_         CLOB;
   count_                   NUMBER;
   assort_count_            NUMBER;
   eliment_count_           NUMBER;
   part_count_              NUMBER;
   assortment_id_           VARCHAR2(20);
   assortment_node_id_      VARCHAR2(20);
   description_             VARCHAR2(100);
   parent_node_             assortment_node_tab.parent_node%TYPE;
   least_parent_node_       assortment_node_tab.parent_node%TYPE;
BEGIN
   Message_SYS.Get_Clob_Attributes( parts_assortment_list_, count_, names_msg_, values_msg_ ); 
   assortment_list_      := values_msg_(1);
   part_list_            := values_msg_(2);
   
   Message_SYS.Get_Attributes(assortment_list_, assort_count_, name_assorts_, values_assorts_);  
   FOR i_ IN 1..assort_count_ LOOP    
      Message_SYS.Get_Attributes(values_assorts_(i_), eliment_count_, name_assorts_eliment_, values_assorts_eliment_);
      
      assortment_id_ := values_assorts_eliment_(1);
      assortment_node_id_ := values_assorts_eliment_(2);
      description_ := values_assorts_eliment_(3);
      parent_node_ := values_assorts_eliment_(4);
        
      Message_SYS.Get_Attributes(part_list_, part_count_, name_parts_, values_parts_); 
      @ApproveTransactionStatement(2017-04-06,SURBLK)
      SAVEPOINT event_processed;
      IF Check_Exist___(assortment_id_, assortment_node_id_) THEN
         FOR n_ IN 1..part_count_ LOOP 
            IF NOT Check_Exist___(assortment_id_, values_parts_(n_)) THEN
               Create_Sub_Node__ (assortment_id_ , values_parts_(n_), description_, assortment_node_id_ , values_parts_(n_) );
            ELSE
               least_parent_node_ := Get_Parent_Node(assortment_id_, values_parts_(n_));
               IF least_parent_node_ != assortment_node_id_ THEN
                  @ApproveTransactionStatement(2017-04-06,SURBLK)
                  ROLLBACK to event_processed;
                  Error_SYS.Record_General(lu_name_, 'DUPLICATENODE: The Assortment Node already exist.');
                  EXIT; 
               END IF;
            END IF;
         END LOOP;
      ELSE
         @ApproveTransactionStatement(2017-05-09,SURBLK)
         ROLLBACK to event_processed;
         Error_SYS.Record_General(lu_name_, 'NODEDOESNOTEXIT: The Assortment Node :P2 does not exist in Assortment :P1.', assortment_id_, assortment_node_id_);
      END IF;   
   END LOOP;

END Connect_Parts_To_Assortments;

-- Remove_Root_Node
--   Remove root node of an Assortment Structure.
PROCEDURE Remove_Root_Node (
   assortment_id_ IN VARCHAR2)
IS
BEGIN
   Delete_Node___(assortment_id_, assortment_id_);
END Remove_Root_Node;
