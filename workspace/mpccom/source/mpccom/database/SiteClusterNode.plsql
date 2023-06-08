-----------------------------------------------------------------------------
--
--  Logical unit: SiteClusterNode
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  170210  SURBLK  Added Get_Connected_Clusters().
--  161122  ChBnlk  STRSC-4283, Added INDEX BY clause to the definition of site_table.
--  100430  Ajpelk  Merge rose method documentation
--  091006  ChFolk  Removed unused variables.
--  ------------------------------- 14.0.0 ------------------------------------
--  071128  AmPalk  Bug 69403, Modified Remove__ to support node removal with all children. Method Remove_Immediate_Children___ added.
--  070427  ChBalk  Added SUBSTR for Basic_Data_Translation_API.Get_Basic_Data_Translation returning value.
--  070418  MaMalk  Changed the view comment for SITE_CLUSTER_NODE_LOV1.site_cluster_id.
--  070411  MaJalk  At SITE_CLUSTER_NODE_LOV1, changed view comment of node_level to Site Cluster Level Name.
--  070404  MaJalk  At SITE_CLUSTER_NODE_LOV1, changed view comment of node_level to Assortment Level Name.
--  070328  WaJalk  Modified SITE_CLUSTER_NODE_LOV1.
--  070326  NiDalk  Corrected parameter passing error in Check_Node_Exist_As_Child.
--  070320  ViWilk  Added SITE_CLUSTER_NODE_LOV1.
--  070314  AmPalk  Added SITE_CLUSTER_NODE_JOIN2.
--  070308  AmPalk  Altered START WITH statements by adding a condition to check Site_Cluster_ID as well.
--  070220  MoMalk  Modified Check_Node_Exist_As_Child.
--  070216  WaJalk  Added new methods Check_Node_Exist_As_Child and Get_Connected_Sites,
--  070216          Removed Check_Site_Exist_As_Child.
--  070214  WaJalk  Added new method Check_Site_Exist_As_Child.
--  070213  NiDalk  Added new method Is_Site_Belongs_To_Node.
--  070125  NiDalk  Modified veiw comments of SITE_CLUSTER_NODE_JOIN view.
--  070111  KeFelk  Removed NVL in the SITE_CLUSTER_NODE_JOIN view.
--  061120  IsWilk  Added the view SITE_CLUSTER_NODE_JOIN.
--  061120  NiDalk  Modified Get_Level_No.
--  061116  MiErlk  Added Method Get_Description().
--  061103  NiDalk  Create
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE Site_Rec IS RECORD
   (contract SITE_CLUSTER_NODE_TAB.contract%TYPE);

TYPE site_table IS TABLE OF Site_Rec INDEX BY PLS_INTEGER;


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Remove_Immediate_Children___
--   This will remove immediate children nodes with theire sub nodes of
--   a node given.
PROCEDURE Remove_Immediate_Children___ (
   site_cluster_id_ IN VARCHAR2,
   site_cluster_node_id_ IN VARCHAR2 )
IS
   CURSOR get_immediate_children IS
      SELECT site_cluster_node_id
      FROM SITE_CLUSTER_NODE_TAB
      WHERE site_cluster_id = site_cluster_id_
      AND parent_node = site_cluster_node_id_;
BEGIN
   FOR rec_ IN get_immediate_children LOOP
        Delete_Node__(site_cluster_id_,rec_.site_cluster_node_id);
   END LOOP;
END Remove_Immediate_Children___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@Override
PROCEDURE Remove__ (
   info_       OUT VARCHAR2,
   objid_      IN  VARCHAR2,
   objversion_ IN  VARCHAR2,
   action_     IN  VARCHAR2 )
IS
   remrec_ SITE_CLUSTER_NODE_TAB%ROWTYPE;
BEGIN
   remrec_ := Get_Object_By_Id___(objid_);
   super(info_, objid_, objversion_, action_);
   IF (action_ = 'DO') THEN
      Remove_Immediate_Children___(remrec_.site_cluster_id, remrec_.site_cluster_node_id);
   END IF;
   info_ := info_ || Client_SYS.Get_All_Info;
END Remove__;


-- Create_Sub_Node__
--   Creates a sub node for the given parent node
PROCEDURE Create_Sub_Node__ (
   site_cluster_id_      IN VARCHAR2,
   site_cluster_node_id_ IN VARCHAR2,
   description_          IN VARCHAR2,
   parent_node_          IN VARCHAR2,
   contract_             IN VARCHAR2)
IS
   attr_                 VARCHAR2(32000);
   objid_                SITE_CLUSTER_NODE.objid%TYPE;
   objversion_           SITE_CLUSTER_NODE.objversion%TYPE;
   newrec_               SITE_CLUSTER_NODE_TAB%ROWTYPE;
   indrec_               Indicator_Rec;
BEGIN

   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('SITE_CLUSTER_ID', site_cluster_id_, attr_);
   Client_SYS.Add_To_Attr('SITE_CLUSTER_NODE_ID', site_cluster_node_id_, attr_);
   Client_SYS.Add_To_Attr('DESCRIPTION', description_, attr_);
   Client_SYS.Add_To_Attr('PARENT_NODE', parent_node_, attr_);

   IF contract_ IS NOT NULL THEN
      Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_);
   END IF;

   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);
END Create_Sub_Node__;


-- Delete_Node__
--   Delete a node in Site Cluster and it's sub nodes
PROCEDURE Delete_Node__ (
   site_cluster_id_ IN VARCHAR2,
   site_cluster_node_id_ IN VARCHAR2 )
IS
   remrec_  SITE_CLUSTER_NODE_TAB%ROWTYPE;

   CURSOR get_connected_nodes IS
      SELECT rowid objid, to_char(rowversion,'YYYYMMDDHH24MISS') objversion
      FROM   SITE_CLUSTER_NODE_TAB
      WHERE  site_cluster_id = site_cluster_id_
      START WITH       site_cluster_node_id = site_cluster_node_id_
             AND       site_cluster_id = site_cluster_id_
      CONNECT BY PRIOR site_cluster_node_id = parent_node
      AND PRIOR        site_cluster_id = site_cluster_id
      AND              site_cluster_id = site_cluster_id_;
BEGIN

   FOR rec_ IN get_connected_nodes LOOP
      remrec_ := Lock_By_Id___(rec_.objid, rec_.objversion);
      Check_Delete___(remrec_);
      Delete___(rec_.objid, remrec_);
   END LOOP;
END Delete_Node__;


PROCEDURE Modify_Parent__ (
   site_cluster_id_ IN VARCHAR2,
   site_cluster_node_id_ IN VARCHAR2,
   parent_node_ IN VARCHAR2 )
IS
   oldrec_  SITE_CLUSTER_NODE_TAB%ROWTYPE;
   newrec_  SITE_CLUSTER_NODE_TAB%ROWTYPE;
   attr_    VARCHAR2(2000);
   indrec_  Indicator_Rec;

   CURSOR get_site_cluster_node IS
      SELECT rowid objid, to_char(rowversion,'YYYYMMDDHH24MISS') objversion
      FROM SITE_CLUSTER_NODE_TAB
      WHERE site_cluster_id = site_cluster_id_
      AND site_cluster_node_id = site_cluster_node_id_;

   rec_     get_site_cluster_node%ROWTYPE;
BEGIN

   OPEN get_site_cluster_node;
   FETCH get_site_cluster_node INTO rec_;

   IF get_site_cluster_node%FOUND THEN
      oldrec_ := Lock_By_Id___(rec_.objid, rec_.objversion);
      Client_SYS.Add_To_Attr('PARENT_NODE', parent_node_, attr_);
      newrec_ := oldrec_;      
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
      Update___(rec_.objid, oldrec_, newrec_, attr_, rec_.objversion);
   END IF;
   CLOSE get_site_cluster_node;
END Modify_Parent__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Level_No
--   Returns the Cluster Level Number of the node.
@UncheckedAccess
FUNCTION Get_Level_No (
   site_cluster_id_      IN VARCHAR2,
   site_cluster_node_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   site_cluster_level_     NUMBER := 1;
   parent_node_            SITE_CLUSTER_NODE_TAB.parent_node%TYPE;
BEGIN
   parent_node_ := Get_Parent_Node(site_cluster_id_, site_cluster_node_id_);

   WHILE parent_node_ IS NOT NULL LOOP
      parent_node_ := Get_Parent_Node(site_cluster_id_, parent_node_);
      site_cluster_level_ := site_cluster_level_ + 1;
   END LOOP;

   RETURN site_cluster_level_;
END Get_Level_No;


-- Check_Node_Exists
--   Checks if a node is already exists
@UncheckedAccess
FUNCTION Check_Node_Exists (
   site_cluster_id_      IN VARCHAR2,
   site_cluster_node_id_ IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   IF (Check_Exist___(site_cluster_id_, site_cluster_node_id_)) THEN
      RETURN 1;
   ELSE
       RETURN 0;
   END IF;
END Check_Node_Exists;


@UncheckedAccess
FUNCTION Get_Description (
   site_cluster_id_      IN VARCHAR2,
   site_cluster_node_id_ IN VARCHAR2,
   language_code_        IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
   description_      SITE_CLUSTER_NODE_TAB.description%TYPE;

   CURSOR get_description IS
      SELECT description
      FROM SITE_CLUSTER_NODE_TAB
      WHERE site_cluster_id = site_cluster_id_
      AND   site_cluster_node_id = site_cluster_node_id_;
BEGIN
   description_ := SUBSTR(Basic_Data_Translation_API.Get_Basic_Data_Translation('MPCCOM',
                                                                         'SiteClusterNode',
                                                                         site_cluster_id_ || '^' || site_cluster_node_id_ ,
                                                                         language_code_), 1, 200);

   IF (description_ IS NULL) THEN
      OPEN get_description;
      FETCH get_description INTO description_;
      CLOSE get_description;
   END IF;
   RETURN description_;
END Get_Description;


-- Is_Site_Belongs_To_Node
--   Checks if the site is connected a descendant node of the site cluster node.
@UncheckedAccess
FUNCTION Is_Site_Belongs_To_Node (
   site_cluster_id_      IN VARCHAR2,
   site_cluster_node_id_ IN VARCHAR2,
   contract_             IN VARCHAR2 ) RETURN VARCHAR2
IS
   site_connected_node_      SITE_CLUSTER_NODE_TAB.site_cluster_node_id%TYPE;
   result_                   VARCHAR2(10) := 'FALSE';
   CURSOR get_site_node IS
      SELECT site_cluster_node_id
      FROM   SITE_CLUSTER_NODE_TAB
      WHERE  site_cluster_id = site_cluster_id_
      AND    contract = contract_;
BEGIN
   OPEN get_site_node;
   FETCH get_site_node INTO site_connected_node_;
   IF (get_site_node%FOUND) THEN
      result_ := Check_Node_Exist_As_Child(site_cluster_id_ , site_cluster_node_id_, site_connected_node_);
   END IF;
   CLOSE get_site_node;
   RETURN result_;
END Is_Site_Belongs_To_Node;


-- Check_Node_Exist_As_Child
--   Checks if the child_node is connected as a descendant node of
--   the site_cluster_node or the site_cluster_node itself.
@UncheckedAccess
FUNCTION Check_Node_Exist_As_Child (
   site_cluster_id_      IN VARCHAR2,
   site_cluster_node_id_ IN VARCHAR2,
   child_node_id_        IN VARCHAR2 ) RETURN VARCHAR2
IS
  return_val_         VARCHAR2(5) := 'FALSE';
  parent_node_        SITE_CLUSTER_NODE_TAB.parent_node%TYPE;
BEGIN
   --Checks whether the parent node itself is passed as the child node
   IF (site_cluster_node_id_ = child_node_id_) THEN
      return_val_ := 'TRUE';
      RETURN return_val_;
   END IF;
   parent_node_ := Get_Parent_Node(site_cluster_id_, child_node_id_);
   WHILE parent_node_ IS NOT NULL LOOP
      IF parent_node_ = site_cluster_node_id_ THEN
         return_val_ := 'TRUE';
         RETURN return_val_;
      ELSE
         parent_node_ := Get_Parent_Node(site_cluster_id_, parent_node_);
      END IF;
   END LOOP;
   RETURN return_val_;
END Check_Node_Exist_As_Child;


-- Get_Connected_Sites
--   Returns the connected sites.
@UncheckedAccess
FUNCTION Get_Connected_Sites (
   site_cluster_id_      IN VARCHAR2,
   site_cluster_node_id_ IN VARCHAR2 ) RETURN site_table
IS
   site_tab_       site_table;
   CURSOR get_connected_sites IS
      SELECT            contract
      FROM              SITE_CLUSTER_NODE_TAB
      WHERE             contract IS NOT NULL
      AND               site_cluster_id = site_cluster_id_
      START WITH        site_cluster_node_id = site_cluster_node_id_
             AND        site_cluster_id = site_cluster_id_
      CONNECT BY PRIOR  site_cluster_node_id = parent_node
      AND PRIOR         site_cluster_id = site_cluster_id
      AND               site_cluster_id = site_cluster_id_;
BEGIN
   OPEN get_connected_sites;
   FETCH get_connected_sites BULK COLLECT INTO site_tab_;
   CLOSE get_connected_sites;
   RETURN site_tab_;
END Get_Connected_Sites;


-- Get_Connected_Clusters
--   Returns the site connected site_clusters.
@UncheckedAccess
FUNCTION Get_Connected_Clusters (
   contract_      IN VARCHAR2) RETURN VARCHAR2
IS
   cluster_msg_             VARCHAR2(32000);
   CURSOR get_connected_clusters IS
      SELECT site_cluster_id
        FROM SITE_CLUSTER_NODE_TAB
       WHERE contract = contract_;
BEGIN
   cluster_msg_ := Message_SYS.Construct('SITE_CLUSTERS');
   FOR rec_ IN get_connected_clusters LOOP
      Message_SYS.Add_Attribute(cluster_msg_, 'SITE_CLUSTER_ID',        rec_.site_cluster_id);
   END LOOP;
   RETURN cluster_msg_;
END Get_Connected_Clusters;



