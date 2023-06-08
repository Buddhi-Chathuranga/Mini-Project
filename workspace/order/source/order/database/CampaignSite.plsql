-----------------------------------------------------------------------------
--
--  Logical unit: CampaignSite
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210108  RavDlk  SC2020R1-11995, Modified Insert_Site_Cluster__ by removing unnecessary packing and unpacking of attrubute string
--  140120  Matkse  Modified Insert_Site_Cluster__ to return error message when site cluster could not be found. 
--  120314  DaZase  Removed last TRUE parameter in Init_Method call inside Check_Charge_Type_On_Targets
--  111116  ChJalk  Modified the view CAMPAIGN_SITE to use User_Finance_Auth_Pub instead of Company_Finance_Auth_Pub.
--  111026  ChJalk  Modified the base view CAMPAIGN_SITE to use the user allowed company filter.
--  110922  ChJalk  Modified the method Unpack_Check_Insert___ to check whether all the charge types in sales promotions exist in the site added in valid sites.
--  100714  NaLrlk  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT campaign_site_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   company_ VARCHAR2(20);
BEGIN
   super(newrec_, indrec_, attr_);

   Sales_Promotion_Deal_API.Check_Charge_Type_Exist(newrec_.campaign_id, newrec_.contract);  

   company_ := Campaign_API.Get_Company(newrec_.campaign_id);
   IF (Site_API.Get_Company(newrec_.contract) != company_) THEN
      Error_SYS.Record_General(lu_name_, 'INVALCAMPSITE: Site :P1 is not connected to company :P2 and cannot be added to the campaign.',newrec_.contract, company_);
   END IF;

END Check_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Insert_Site_Cluster__ (
   campaign_id_          IN NUMBER,
   site_cluster_id_      IN VARCHAR2,
   site_cluster_node_id_ IN VARCHAR2 )
IS
   counter_       NUMBER := 0;
   newrec_        campaign_site_tab%ROWTYPE;

   CURSOR get_connected_sites IS
      SELECT contract
        FROM site_cluster_node_tab
       WHERE contract IS NOT NULL
         AND site_cluster_id = site_cluster_id_
       START WITH site_cluster_node_id = site_cluster_node_id_
             AND  site_cluster_id = site_cluster_id_
     CONNECT BY PRIOR site_cluster_node_id = parent_node
         AND PRIOR site_cluster_id = site_cluster_id
         AND site_cluster_id = site_cluster_id_;
BEGIN
   FOR sites_ IN get_connected_sites LOOP
      IF (NOT Check_Exist___(sites_.contract, campaign_id_)) THEN
         newrec_.campaign_id := campaign_id_;
         newrec_.contract    := sites_.contract;
         New___(newrec_);
      END IF;
      counter_ := counter_ + 1;
   END LOOP;
   
   IF (counter_ = 0) THEN
      Error_SYS.Record_General(lu_name_, 'SITECLUSTERNOTFOUND: Site Cluster :P1 with Node :P2 not found.',site_cluster_id_, site_cluster_node_id_);
   END IF;
END Insert_Site_Cluster__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Check_Exist
--   Public interface for checking if campaign site exist.
--   Returns 1 for true and 0 for false
@UncheckedAccess
FUNCTION Check_Exist (
   campaign_id_ IN NUMBER,
   contract_    IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   IF (Check_Exist___(contract_, campaign_id_)) THEN
      RETURN 1;
   ELSE
      RETURN 0;
   END IF;
END Check_Exist;


-- New
--   Public interface for create new campaign site.
PROCEDURE New (
   info_ OUT    VARCHAR2,
   attr_ IN OUT VARCHAR2 )
IS
   newrec_     CAMPAIGN_SITE_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   indrec_   Indicator_Rec;
BEGIN
   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);
   info_ := Client_SYS.Get_All_Info;
END New;


PROCEDURE Check_Charge_Type_On_Targets (
   campaign_id_ IN NUMBER,
   charge_type_ IN VARCHAR2)
IS
   CURSOR get_sites IS
      SELECT contract
      FROM   CAMPAIGN_SITE_TAB
      WHERE  campaign_id = campaign_id_;
BEGIN
   FOR sites_ IN get_sites LOOP
      IF (Sales_Charge_Type_API.Check_Exist(sites_.contract, charge_type_) = 'FALSE') THEN
         Error_SYS.Record_General(lu_name_, 'INVCHARGE: Charge type :P1 is not defined for the target site :P2.', charge_type_, sites_.contract);
      ELSIF (Sales_Charge_Group_API.Get_Sales_Chg_Type_Category_Db(Sales_Charge_Type_Api.Get_Charge_Group(sites_.contract, charge_type_)) != 'PROMOTION') THEN
         Error_SYS.Record_General(lu_name_, 'INVCHARGE2: Charge type :P1 connected to site :P2 is not of Promotion charge type category.', charge_type_, sites_.contract);
      END IF;
   END LOOP;
END Check_Charge_Type_On_Targets;



