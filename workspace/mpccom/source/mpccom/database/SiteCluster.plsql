-----------------------------------------------------------------------------
--
--  Logical unit: SiteCluster
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  100430 Ajpelk  Merge rose method documentation
-- ----------------------------Eagle------------------------------------------
--  070427 ChBalk  Added SUBSTR for Basic_Data_Translation_API.Get_Basic_Data_Translation returning value.
--  061120 NiDalk  Modified Insert___ to insert first level to the Site Cluster when creating a Site Cluster.
--  061113 MiErlk  Added Method Get_Description.
--  061103 NiDalk  Create
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT SITE_CLUSTER_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   super(objid_, objversion_, newrec_, attr_);
   -- Creating root node to the Site cluster
   Site_Cluster_Node_API.Create_Sub_Node__(newrec_.site_cluster_id,
                                           newrec_.site_cluster_id,
                                           newrec_.description,
                                           NULL,
                                           NULL);
   -- Creating the first level to the cluster
   Site_Cluster_Level_API.Create_Level__(newrec_.site_cluster_id,
                                         1,
                                        'Root Level');   
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Description
--   Fetches the Description attribute for a record.
@UncheckedAccess
FUNCTION Get_Description (
   site_cluster_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ site_cluster_tab.description%TYPE;
BEGIN
   IF (site_cluster_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   temp_ := substr(Basic_Data_Translation_API.Get_Basic_Data_Translation(module_, lu_name_,
      site_cluster_id_), 1, 200);
   IF (temp_ IS NOT NULL) THEN
      RETURN temp_;
   END IF;
   SELECT description
      INTO  temp_
      FROM  site_cluster_tab
      WHERE site_cluster_id = site_cluster_id_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(site_cluster_id_, 'Get_Description');
END Get_Description;



