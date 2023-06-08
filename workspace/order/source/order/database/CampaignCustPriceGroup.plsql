-----------------------------------------------------------------------------
--
--  Logical unit: CampaignCustPriceGroup
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  111116  ChJalk  Modified the view CAMPAIGN_CUST_PRICE_GROUP to use User_Finance_Auth_Pub instead of Company_Finance_Auth_Pub.
--  111021  ChJalk  Modified the base view CAMPAIGN_CUST_PRICE_GROUP to use the user allowed company filter.
--  100714  NaLrlk  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Check_Exist
--   Public interface for checking if campaign customer price group exist.
--   Returns 1 for true and 0 for false
@UncheckedAccess
FUNCTION Check_Exist (
   cust_price_group_id_ IN VARCHAR2,
   campaign_id_         IN NUMBER ) RETURN NUMBER
IS
BEGIN
   IF (Check_Exist___(cust_price_group_id_, campaign_id_)) THEN
      RETURN 1;
   ELSE
      RETURN 0;
   END IF;
END Check_Exist;


-- Remove_All_Cust_Price_Group
--   Remove all customer price groups connected to specified campaign id.
PROCEDURE Remove_All_Cust_Price_Group (
   campaign_id_ IN VARCHAR2 )
IS
   objid_       VARCHAR2(2000);
   objversion_  VARCHAR2(2000);
   remrec_      CAMPAIGN_CUST_PRICE_GROUP_TAB%ROWTYPE;

   CURSOR get_rec IS
      SELECT cust_price_group_id
        FROM CAMPAIGN_CUST_PRICE_GROUP_TAB
       WHERE campaign_id = campaign_id_;
BEGIN
   FOR rec_ IN get_rec LOOP
      Get_Id_Version_By_Keys___(objid_, objversion_, rec_.cust_price_group_id, campaign_id_);
      remrec_ := Lock_By_Id___(objid_, objversion_);
      Check_Delete___(remrec_);
      Delete___(objid_, remrec_);
   END LOOP;
END Remove_All_Cust_Price_Group;



