-----------------------------------------------------------------------------
--
--  Logical unit: SiteClusterLevel
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  100430  Ajpelk   Merge rose method documentation
------------------------------Eagle------------------------------------------
--  070427  ChBalk   Added SUBSTR for Basic_Data_Translation_API.Get_Basic_Data_Translation returning value.
--  070125  NiDalk   Modified veiw comments of SITE_CLUSTER_LEVEL_LOV view.
--  061123  IsWilk   Added the view SITE_CLUSTER_LEVEL_LOV.
--  061120  NiDalk   Added Method Create_Level__.
--  061116  MiErlk   Modified Method Get_Description.
--  061103  NiDalk   Create
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Create_Level__
--   Creares a sub level to the Site cluster
PROCEDURE Create_Level__ (
   site_cluster_id_ IN VARCHAR2,
   cluster_level_   IN NUMBER,
   description_     IN VARCHAR2 )
IS
   attr_            VARCHAR2(32000);
   objid_           SITE_CLUSTER_LEVEL.objid%TYPE;
   objversion_      SITE_CLUSTER_LEVEL.objversion%TYPE;
   newrec_          SITE_CLUSTER_LEVEL_TAB%ROWTYPE;
   indrec_          Indicator_Rec;
BEGIN

   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('SITE_CLUSTER_ID' , site_cluster_id_ , attr_);
   Client_SYS.Add_To_Attr('CLUSTER_LEVEL'   , cluster_level_   , attr_);
   Client_SYS.Add_To_Attr('DESCRIPTION'     , description_     , attr_);
   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);
END Create_Level__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Description (
   site_cluster_id_ IN VARCHAR2,
   cluster_level_ IN NUMBER,
   language_code_ IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
   temp_ site_cluster_level_tab.description%TYPE;
BEGIN
   IF (site_cluster_id_ IS NULL OR cluster_level_ IS NULL) THEN
      RETURN NULL;
   END IF;
   temp_ := substr(Basic_Data_Translation_API.Get_Basic_Data_Translation(module_, lu_name_,
                                                                         site_cluster_id_||'^'||cluster_level_,
                                                                         language_code_), 1, 200);
   IF (temp_ IS NOT NULL) THEN
      RETURN temp_;
   END IF;
   SELECT description
      INTO  temp_
      FROM  site_cluster_level_tab
      WHERE site_cluster_id = site_cluster_id_
      AND   cluster_level = cluster_level_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(site_cluster_id_, cluster_level_, 'Get_Description');
END Get_Description;



