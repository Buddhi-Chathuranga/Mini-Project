-----------------------------------------------------------------------------
--
--  Logical unit: CampaignAllocationPlan
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  130703  MaIklk  TIBE-944, Removed inst_DistributionAllocation_ global constant and used conditional compilation instead.
--  111116  ChJalk  Modified the view CAMPAIGN_ALLOCATION_PLAN to use User_Finance_Auth_Pub instead of Company_Finance_Auth_Pub.
--  111021  ChJalk  Modified the base view CAMPAIGN_ALLOCATION_PLAN to use the user allowed company filter.
--  091228  MaHplk  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN CAMPAIGN_ALLOCATION_PLAN_TAB%ROWTYPE )
IS
   attr_        VARCHAR2(32000);   
   campaign_id_ NUMBER;
BEGIN
   $IF (Component_Disord_SYS.INSTALLED) $THEN
      campaign_id_ := Distribution_Allocation_API.Get_Campaign_Id(remrec_.allocation_no); 
   $END

   IF (campaign_id_ IS NOT NULL) THEN
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('CAMPAIGN_ID', '', attr_);
      $IF (Component_Disord_SYS.INSTALLED) $THEN        
         Distribution_Allocation_API.Modify(attr_, remrec_.allocation_no);      
      $END
   END IF;

   super(objid_, remrec_);
END Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT campaign_allocation_plan_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   contract_    VARCHAR2(5);  
   supply_site_ VARCHAR2(5);
   state_       VARCHAR2(30);
BEGIN
   super(newrec_, indrec_, attr_);
   
   contract_ := Campaign_API.Get_Supply_Site(newrec_.campaign_id);

   $IF (Component_Disord_SYS.INSTALLED) $THEN
      supply_site_ := Distribution_Allocation_API.Get_Supply_Site(newrec_.allocation_no);
      state_       := Distribution_Allocation_API.Get_Objstate(newrec_.allocation_no);               
   $END

   IF contract_ IS NULL THEN
      Error_SYS.Record_General(lu_name_, 'SUPPSITENULL: The distribution allocation cannot be connected because the supply site of the campaign does not exist.');
   ELSIF (NVL(supply_site_,CHR(32)) != NVL(contract_,CHR(32))) THEN
      Error_SYS.Record_General(lu_name_, 'DIFFSUPPSITE: The supply site of distribution allocation should be same as supply site of campaign.');
   ELSIF (state_ = 'Cancelled') THEN
      Error_SYS.Record_General(lu_name_, 'CANCELALLOC: The distribution allocation :P1 is cancelled and cannot be used in this campaign.', newrec_.allocation_no);
   END IF;
END Check_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Allocation_No (
   campaign_id_   IN NUMBER,
   allocation_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ CAMPAIGN_ALLOCATION_PLAN_TAB.allocation_no%TYPE;
   CURSOR get_attr IS
      SELECT allocation_no
      FROM CAMPAIGN_ALLOCATION_PLAN_TAB
      WHERE campaign_id = campaign_id_
      AND   allocation_no = allocation_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Allocation_No;



