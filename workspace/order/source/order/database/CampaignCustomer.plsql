-----------------------------------------------------------------------------
--
--  Logical unit: CampaignCustomer
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210108  RavDlk  SC2020R1-11995, Modified New by removing unnecessary packing and unpacking of attrubute string
--  150916  MaRalk  AFT-5289, Added Check_Customer_No_Ref___ in order to allow 'Prospect' customers.
--  111116  ChJalk  Modified the view CAMPAIGN_CUSTOMER to use User_Finance_Auth_Pub instead of Company_Finance_Auth_Pub.
--  111026  ChJalk  Modified the base view CAMPAIGN_CUSTOMER to use the user allowed company filter.
--  100714  NaLrlk  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Check_Customer_No_Ref___ (
   newrec_ IN OUT NOCOPY campaign_customer_tab%ROWTYPE )
IS
   customer_category_ CUSTOMER_INFO_TAB.customer_category%TYPE;
BEGIN
   IF (newrec_.customer_no IS NOT NULL) THEN
      customer_category_ := Customer_Info_API.Get_Customer_Category_Db(newrec_.customer_no);
      IF customer_category_ = Customer_Category_API.DB_CUSTOMER THEN
         Cust_Ord_Customer_API.Exist(newrec_.customer_no);         
      ELSIF (customer_category_ = Customer_Category_API.DB_END_CUSTOMER) THEN  
         Error_SYS.Record_General(lu_name_,'CAMPAIGNENDCUSTERR: Customer :P1 is not of category Prospect or Customer.', newrec_.customer_no); 
      ELSE   
         Customer_Info_API.Exist(newrec_.customer_no, customer_category_);
      END IF;
   END IF;
END Check_Customer_No_Ref___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Insert_Cust_From_Hierarchy__ (
   campaign_id_    IN NUMBER,
   hierarchy_id_   IN VARCHAR2,
   customer_level_ IN NUMBER )
IS
   newrec_    campaign_customer_tab%ROWTYPE;

   CURSOR get_customers IS
      SELECT customer_no
        FROM cust_hierarchy_struct_tab
       WHERE hierarchy_id = hierarchy_id_
         AND (customer_level_ IS NULL OR Cust_Hierarchy_Struct_API.Get_Level_No(hierarchy_id, customer_no) = customer_level_);
BEGIN
   FOR cust_rec_ IN get_customers LOOP
      IF (NOT Check_Exist___(cust_rec_.customer_no, campaign_id_)) THEN
         newrec_.campaign_id := campaign_id_;
         newrec_.customer_no := cust_rec_.customer_no;
         New___(newrec_);
      END IF;
   END LOOP;
END Insert_Cust_From_Hierarchy__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Check_Exist
--   Public interface for checking if campaign site exist.
--   Returns 1 for true and 0 for false
@UncheckedAccess
FUNCTION Check_Exist (
   customer_no_ IN VARCHAR2,
   campaign_id_ IN NUMBER ) RETURN NUMBER
IS
BEGIN
   IF (Check_Exist___(customer_no_, campaign_id_)) THEN
      RETURN 1;
   ELSE
      RETURN 0;
   END IF;
END Check_Exist;


-- New
--   Public interface for create new campaign customer.
PROCEDURE New (
   info_ OUT VARCHAR2,
   attr_ IN OUT VARCHAR2 )
IS
   newrec_     CAMPAIGN_CUSTOMER_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   indrec_   Indicator_Rec;
BEGIN
   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);
   info_ := Client_SYS.Get_All_Info;
END New;


-- Remove_All_Customers
--   Remove all customers connected to specified campaign id.
PROCEDURE Remove_All_Customers (
   campaign_id_ IN VARCHAR2 )
IS
   objid_       VARCHAR2(2000);
   objversion_  VARCHAR2(2000);
   remrec_      CAMPAIGN_CUSTOMER_TAB%ROWTYPE;

   CURSOR get_rec IS
      SELECT customer_no
        FROM CAMPAIGN_CUSTOMER_TAB
       WHERE campaign_id = campaign_id_;
BEGIN
   FOR cust_rec_ IN get_rec LOOP
      Get_Id_Version_By_Keys___(objid_, objversion_, cust_rec_.customer_no, campaign_id_);
      remrec_ := Lock_By_Id___(objid_, objversion_);
      Check_Delete___(remrec_);
      Delete___(objid_, remrec_);
   END LOOP;
END Remove_All_Customers;



