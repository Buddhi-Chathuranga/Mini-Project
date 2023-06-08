-----------------------------------------------------------------------------
--
--  Logical unit: Campaign
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  201013  OsAllk   SC2020R1-10455, Replaced Component_Is_Installed with Component_Is_Active to check component ACTIVE/INACTIVE.
--  190930  DaZase  SCSPRING20-149, Added Raise_Inval_Supply_Site_Err___, Raise_Inval_Ref_Site_Error___ and Raise_Assortm_Not_Act_Error___ to solve MessageDefinitionValidation issues.
--  170926  RaVdlk  STRSC-11152, Removed Get_State and Get_Objstate functions, since they are generated from the foundation
--  160601  MAHPLK  FINHR-2018, Removed Validate_Tax_Calc_Basis___.
--  140329  HimRlk  Added new methods Do_Set_Activate___ and Check_Approvable___. Added new validation for state machine when Activating a Campaign.
--- 140305  SURBLK  Change Site_Discom_Info_API.Get_Use_Price_Incl_Tax_Db in to Site_Discom_Info_API.Get_Use_Price_Incl_Tax_Ord_Db.
--  130703  MaIklk  TIBE-945, Removed inst_SupplierBlanket_  and inst_DistributionAllocation_ global constants and used conditional compilation.
--  130508  KiSalk  Bug 106680, Replaced Installed_Component_SYS.<component> with Component_<component>_SYS.<component>.
--  130213  JeeJlk  Modified Get_Campaign_Price_Info to fetche price incl tax values.
--  130212  JeeJlk  Added new method Validate_Tax_Calc_Basis___
--  130211  JeeJlk  Added new column USE_PRICE_INCL_TAX.
--  130128  ErFelk  Bug 108054, Added OBJSTATE to CAMPAIGN_PER_SITE_JOIN, CAMPAIGN_PER_CUSTOMER_JOIN and CAMP_PER_CUST_PRICE_GRP_JOIN views.
--  121016  NipKlk  Bug 105987, Added Conditional Compilation for the dynamic call and assigned null for variables when no primary supplier found to avoid wrong values assignments
--  121016          and removed the constant inst_PurchasePartSupplier_. 
--  120706  RuLiLk  Bug 103857, Added column priority and method Validate_Priority___.
--  120627  NWeelk  Bug 103544, Modified methods Set_Approved_Date___ and Unpack_Check_Update___ to raise an error message when updating the campaign 
--  120627          when the status is Closed. 
--  111215  MaMalk  Modified Insert___ to move the setting of objversion_ to the end of this procedure.
--  111116  ChJalk  Modified the views CAMPAIGN and CAMPAIGN_PER_SITE_JOIN to use User_Finance_Auth_Pub instead of Company_Finance_Auth_Pub.
--  111025  ChJalk  Modified the view CAMPAIGN_PER_SITE_JOIN to use the user allowed company filter.
--  111021  ChJalk  Modified the base view CAMPAIGN to use the user allowed company filter.
--  110928  ChJalk  Modified the method Create_Camp_Alloc_Lines___ to create allocations for sales promotions. Modified Create_Allocation to raise an error if there are no parts for creating allocations.
--  110926  ChJalk  Modified procedure Activate_Allowed to prioritize the check against incomplete sales promotion deals for allowing "activate" in campaigns.
--  110915  NaLrlk  Modified the method Create_Allocation to rollback the allocation creation when no lines exists.
--  110915          Changed the method Create_Camp_Alloc_Lines__ to Create_Camp_Alloc_Lines___.
--  110906  MaMalk  Aligned the state machine with the model and also called Set_Approved_Date___ when the state becomes Planned from Active and Closed.
--  110906          Also modified the Set_Approved_Date___ accordingly.
--  110526  ShKolk  Added General_SYS for Insert_Discounts().
--  110422  NaLrlk  Modified the methods Get_Price_Campaign_For_Part___, Get_Price_Grp_Camp_For_Part___, Get_Campaign_Disc_Info
--  110422          and Get_Campaign_Price_Info to correct the contract usages.
--  100913  NaLrlk  Added method Log_Event___ and modified the method Finite_State_Machine___.
--  100826  NaLrlk  Rename the method Can_Approve to Activate_Allowed.
--  100729  NaLrlk  Added parameter currency_code to Get_Campaign_Price_Info and Get_Campaign_Disc_Info.
--  100720  NaLrlk  Added the method Get_Price_Grp_Camp_For_Part___ and Get_Pr_Grp_Camp_For_Assort___,
--  100720          Get_Dis_Grp_Camp_For_Assort___ and Rename the method Find_Disc_On_Campaign_Part___to Get_Disc_On_Campaign_Part___.
--  100720          Modified the method Get_Price_Camp_For_Assort___, Get_Campaign_Price_Info and Get_Campaign_Disc_Info.
--  100720          Changed the functions Get_Price_Campaign_For_Part___procedure.
--  100720          Removed method Get_Disc_Campaign_For_Part___.
--  100716  NaLrlk  Added view CAMP_PER_CUST_PRICE_GRP_JOIN.
--  100708  NaLrlk  Added column currency_code.
--  100707  NaLrlk  Modified the method Create_Camp_Alloc_Lines__.
--  100705  NaLrlk  Modified the Campaign state to Active^Closed^Planned and events to Activate^Close^Plan.
--  100427  NaLrlk  Added column ignore_if_low_price_found. Modified the method Create_Camp_Alloc_Lines__ and 
--  100427          Create_Allocation to change the server calls to dynamic calls.
--  100423  NaLrlk  Added method Fill_Camp_Assort_Part_Tmp___.
--  100415  NaLrlk  Removed the method Insert_Valid_Sites__. Modified the methods Exist_Blanket_Line and Create_Supplier_Blanket.
--  100326  NaLrlk  Removed columns hierarchy_id and customer_level.
--  100126  NaLrlk  Modified the method Create_Supplier_Blanket.
--  100121  KiSalk  Added new parameters customer_level_db_ and customer_level_id_ to Get_Price_Camp_For_Assort___
--  100121          and Get_Campaign_Price_Info. Also removed some obsolete codes.
--  100119  ShKolk  Renamed Blanket to Supplier Agreement.
--  091228  MaHplk  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE part_rec IS RECORD
   (catalog_no CAMPAIGN_PART_TAB.CATALOG_NO%TYPE);

TYPE part_table IS TABLE OF part_rec;


-------------------- PRIVATE DECLARATIONS -----------------------------------

state_separator_   CONSTANT VARCHAR2(1)   := Client_SYS.field_separator_;

TYPE tab_customer_no IS TABLE OF VARCHAR2(20) INDEX BY BINARY_INTEGER;


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Raise_Inval_Supply_Site_Err___ (
   supply_site_  IN VARCHAR2,
   company_      IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Record_General(lu_name_, 'INVALIDSUPPSITE: Supply site :P1 is not connected to Company :P2 and can not be added to the Campaign.',supply_site_, company_);
END Raise_Inval_Supply_Site_Err___;   

PROCEDURE Raise_Inval_Ref_Site_Error___ (
   reference_site_  IN VARCHAR2,
   company_         IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Record_General(lu_name_, 'INVALIDREFSITE: Reference site :P1 is not connected to Company :P2 and can not be added to the Campaign.', reference_site_, company_);   
END Raise_Inval_Ref_Site_Error___;   

PROCEDURE Raise_Assortm_Not_Act_Error___ (
   assortment_id_ IN VARCHAR2 )
IS   
BEGIN   
   Error_SYS.Record_General(lu_name_, 'CONASSORTACTERR: Assortment :P1 connected to this campaign is not active.', assortment_id_);
END Raise_Assortm_Not_Act_Error___;

PROCEDURE Do_Set_Activate___ (
   rec_  IN OUT CAMPAIGN_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS

BEGIN
   Validate_Approvable___(rec_, attr_);
   Set_Approved_Date___(rec_, attr_);
END Do_Set_Activate___;

-- -----------------------------------------------------------------------------
-- Validate_Approvable___
-- Validate whether there exist deals which has no value for one of price columns or discount columns.
-- If found fire an error message with the incorrect deal ids.
-- -----------------------------------------------------------------------------
PROCEDURE Validate_Approvable___ (
   rec_  IN OUT CAMPAIGN_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   deal_ids_ VARCHAR2(30);
      CURSOR get_promotion IS      
      SELECT LISTAGG(spd.deal_id , ', ') WITHIN GROUP (ORDER BY spd.deal_id)
         FROM   sales_promotion_deal_tab spd, sales_promotion_deal_buy_tab spdb, sales_promotion_deal_get_tab spdg
         WHERE  spd.campaign_id = rec_.campaign_id
         AND spd.deal_id = spdb.deal_id
         AND spd.deal_id = spdg.deal_id
         AND spdb.campaign_id = rec_.campaign_id
         AND spdg.campaign_id = rec_.campaign_id
         AND spd.price_excl_tax IS NULL
         AND spd.price_incl_tax IS NULL
         AND spd.discount_gross_amount IS NULL
         AND spd.discount_net_amount IS NULL
         AND spd.discount IS NULL;
BEGIN
   OPEN get_promotion;
   FETCH get_promotion INTO deal_ids_;
   IF ((get_promotion%FOUND) AND (deal_ids_ != ', ') )THEN
      CLOSE get_promotion;
      Error_SYS.Record_General(lu_name_, 'DEALNOTVALID: Deal(s) :P1 must have one of price including tax, price excluding tax, discount net amount, discount gross amount or discount set.', deal_ids_);   
   END IF;
   CLOSE get_promotion;      
END Validate_Approvable___;
   
PROCEDURE Log_Event___ (
   rec_  IN OUT CAMPAIGN_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS   
BEGIN
   Campaign_History_API.New( rec_.campaign_id );
END Log_Event___;


FUNCTION Get_Next_Campaign_Id___ RETURN NUMBER
IS
   temp_ NUMBER;
   CURSOR get_campaign_id IS
      SELECT NVL(MAX(Campaign_id),0)
        FROM CAMPAIGN_TAB;
BEGIN
   OPEN get_campaign_id;
   FETCH get_campaign_id INTO temp_;
   CLOSE get_campaign_id;
   RETURN (temp_ + 1);
END Get_Next_Campaign_Id___;


PROCEDURE Set_Approved_Date___ (
   rec_  IN OUT CAMPAIGN_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   oldrec_          CAMPAIGN_TAB%ROWTYPE;
   newrec_          CAMPAIGN_TAB%ROWTYPE;
   temp_attr_       VARCHAR2(50);
   temp_objversion_ VARCHAR2(20);
   date_changed_    BOOLEAN := FALSE;
   indrec_          Indicator_Rec;
BEGIN
   oldrec_ := Lock_By_Keys___(rec_.campaign_id);
   newrec_ := oldrec_;
   Client_SYS.Clear_Attr(temp_attr_);
   -- When activating the campaign the approved date should be set
   -- when it's set to Planned the apporved date should be removed
   IF (rec_.rowstate = 'Planned') THEN
      rec_.approved_date := SYSDATE;
      date_changed_      := TRUE;
   ELSIF (rec_.approved_date IS NOT NULL) THEN
      rec_.approved_date := NULL;
      date_changed_      := TRUE;
   END IF;
   IF date_changed_ THEN
      Client_SYS.Add_To_Attr('APPROVED_DATE', rec_.approved_date, temp_attr_);
      Unpack___(newrec_, indrec_, temp_attr_);
      Check_Update___(oldrec_, newrec_, indrec_, temp_attr_);
      Update___(NULL, oldrec_, newrec_, temp_attr_, temp_objversion_, TRUE);
   END IF;
   Client_SYS.Add_To_Attr('APPROVED_DATE', rec_.approved_date, attr_);
END Set_Approved_Date___;


-- Get_Disc_On_Campaign_Part___
--   Return discounts on campaign parts.
PROCEDURE Get_Disc_On_Campaign_Part___ (
   discount_type_ OUT VARCHAR2,
   discount_      OUT NUMBER,
   campaign_id_   IN  NUMBER,
   contract_      IN  VARCHAR2,
   catalog_no_    IN  VARCHAR2 )
IS
   CURSOR get_discount IS
      SELECT sales_discount, discount_type
        FROM CAMPAIGN_PART_TAB 
       WHERE campaign_id = campaign_id_
         AND contract = contract_
         AND catalog_no = catalog_no_
         AND sales_discount IS NOT NULL;
BEGIN
   OPEN get_discount;
   FETCH get_discount INTO discount_, discount_type_;
   CLOSE get_discount;
END Get_Disc_On_Campaign_Part___;


-- Get_Price_Camp_For_Assort___
--   Search a valid campaign with the assortment that has the part node
--   for the customer which exist on camaign customers.
PROCEDURE Get_Price_Camp_For_Assort___ (
   campaign_id_            OUT NUMBER,
   assortment_id_          OUT VARCHAR2,
   assort_node_id_         OUT VARCHAR2,
   customer_no_            IN  VARCHAR2,
   contract_               IN  VARCHAR2,
   part_no_                IN  VARCHAR2,
   currency_code_          IN  VARCHAR2,
   price_unit_meas_        IN  VARCHAR2,
   price_effectivity_date_ IN DATE )
IS
   -- This cursor will return valid campaign for the customer
   -- which have an assortment defined on them
   CURSOR get_valid_campaigns IS
      SELECT c.campaign_id, c.assortment_id
        FROM CAMPAIGN_TAB c
       WHERE c.assortment_id IS NOT NULL
         AND c.rowstate = 'Active'
         AND c.currency_code = currency_code_
         AND TRUNC(price_effectivity_date_) BETWEEN c.sales_start AND c.sales_end
         AND (customer_no_ IN (SELECT cc.customer_no
                                 FROM CAMPAIGN_CUSTOMER_TAB cc
                                WHERE cc.campaign_id = c.campaign_id)
              OR (c.valid_for_all_customers = 'TRUE'))
         AND (contract_ IN (SELECT cs.contract
                              FROM CAMPAIGN_SITE_TAB cs
                              WHERE cs.campaign_id = c.campaign_id ))
         ORDER BY c.priority;

   -- Once a valid campaign-assortment selected, check whether the campaign's assortment tab
   -- has a valid entry for the part.
   CURSOR get_valid_sale_price_entry (campaign_id_ IN VARCHAR2, assortment_id_ IN VARCHAR2) IS
      SELECT t.assortment_node_id
        FROM assortment_node_tab t
       WHERE EXISTS (SELECT 1
                       FROM CAMPAIGN_ASSORTMENT_TAB cat
                      WHERE cat.assortment_id = t.assortment_id
                        AND cat.assortment_node_id = t.assortment_node_id
                        AND cat.campaign_id = campaign_id_
                        AND (cat.price_unit_meas = '*' OR cat.price_unit_meas = price_unit_meas_) 
                        AND cat.sales_price IS NOT NULL)
       START WITH t.assortment_id = assortment_id_
             AND  t.assortment_node_id = part_no_
      CONNECT BY PRIOR  t.assortment_id = t.assortment_id
             AND PRIOR t.parent_node = t.assortment_node_id;

BEGIN
   -- Check all the valid campaigns (with an assortment in it) of the customer, 
   -- whether any assortment node defined in assortment tab.
   FOR rec_ IN get_valid_campaigns LOOP
       OPEN  get_valid_sale_price_entry (rec_.campaign_id , rec_.assortment_id);
        FETCH get_valid_sale_price_entry INTO assort_node_id_;
        CLOSE get_valid_sale_price_entry;

		IF (assort_node_id_ IS NOT NULL) THEN
           campaign_id_       := rec_.campaign_id;
           assortment_id_     := rec_.assortment_id;
        END IF;
        EXIT WHEN assort_node_id_ IS NOT NULL;
   END LOOP;
END Get_Price_Camp_For_Assort___;


-- Get_Disc_Camp_For_Assort___
--   Search a valid campaign discount with the assortment that has the part node
--   for the given part and customer, exist on camaign customers.
PROCEDURE Get_Disc_Camp_For_Assort___ (
   campaign_id_            OUT NUMBER,
   assortment_id_          OUT VARCHAR2,
   assort_node_id_         OUT VARCHAR2,
   customer_no_            IN  VARCHAR2,
   contract_               IN  VARCHAR2,
   part_no_                IN  VARCHAR2,
   currency_code_          IN  VARCHAR2,
   price_unit_meas_        IN  VARCHAR2,
   price_effectivity_date_ IN DATE )
IS
   -- This cursor will return valid campaign for the customer
   -- Which have an assortment defined on them
   -- and in those assortment trees the part exist as a sub part node.
   CURSOR get_valid_campaigns IS
      SELECT c.campaign_id, c.assortment_id
        FROM CAMPAIGN_TAB c
       WHERE c.rowstate = 'Active'
         AND c.currency_code = currency_code_
         AND c.assortment_id IS NOT NULL
         AND TRUNC(price_effectivity_date_) BETWEEN c.sales_start AND c.sales_end
         AND (customer_no_ IN (SELECT cc.customer_no
                                 FROM CAMPAIGN_CUSTOMER_TAB cc
                                WHERE cc.campaign_id = c.campaign_id)
             OR (c.valid_for_all_customers = 'TRUE'))
         AND (contract_ IN (SELECT cs.contract
                              FROM CAMPAIGN_SITE_TAB cs
                              WHERE cs.campaign_id = c.campaign_id ))
         ORDER BY c.priority;


   -- Once a valid campaign-assortment found,
   -- Check whether the assortment has a valid entry for the part.
   CURSOR get_valid_sale_price_entry (campaign_id_ IN VARCHAR2, assortment_id_ IN VARCHAR2) IS
      SELECT t.assortment_node_id
        FROM ASSORTMENT_NODE_TAB t
       WHERE EXISTS (SELECT 1 
                       FROM CAMPAIGN_ASSORTMENT_TAB eat
                      WHERE eat.assortment_id = t.assortment_id
                        AND eat.assortment_node_id = t.assortment_node_id
                        AND eat.campaign_id = campaign_id_
                        AND (eat.price_unit_meas = '*' OR eat.price_unit_meas = price_unit_meas_)
                        AND eat.sales_price IS NULL
                        AND eat.sales_discount IS NOT NULL)
       START WITH        t.assortment_id = assortment_id_
             AND        t.assortment_node_id = part_no_
     CONNECT BY PRIOR  t.assortment_id = t.assortment_id
             AND PRIOR  t.parent_node = t.assortment_node_id;
BEGIN
   -- Check all the valid campaigns (with an assortment in it) of the customer, 
   -- with assortment node defined in assortment tab.
   FOR rec_ IN get_valid_campaigns LOOP
      OPEN get_valid_sale_price_entry (rec_.campaign_id , rec_.assortment_id);
      FETCH get_valid_sale_price_entry INTO assort_node_id_;
      CLOSE get_valid_sale_price_entry;

      IF (assort_node_id_ IS NOT NULL) THEN
          assortment_id_ := rec_.assortment_id;
         campaign_id_   := rec_.campaign_id;
      END IF;
      EXIT WHEN assort_node_id_ IS NOT NULL;
   END LOOP;
END Get_Disc_Camp_For_Assort___;


-- Get_Price_Campaign_For_Part___
--   Search a valid campaign_id for a specified sales part and customer
--   which exist on a campaign customers.
PROCEDURE Get_Price_Campaign_For_Part___ (
   campaign_id_            OUT NUMBER,
   customer_no_            IN  VARCHAR2,
   contract_               IN  VARCHAR2,
   catalog_no_             IN  VARCHAR2,
   currency_code_          IN  VARCHAR2,
   price_effectivity_date_ IN  DATE )
IS
   CURSOR get_part_price_campaign IS
      SELECT c.campaign_id
        FROM CAMPAIGN_TAB c, CAMPAIGN_PART_TAB cp
       WHERE c.campaign_id = cp.campaign_id
         AND c.rowstate ='Active'
         AND c.currency_code = currency_code_
         AND TRUNC(price_effectivity_date_) BETWEEN c.sales_start AND c.sales_end
         AND cp.catalog_no = catalog_no_
         AND cp.sales_price IS NOT NULL
         AND (customer_no_ IN (SELECT cc.customer_no
                                 FROM CAMPAIGN_CUSTOMER_TAB cc
                                WHERE cc.campaign_id = c.campaign_id)
              OR (c.valid_for_all_customers = 'TRUE'))
         AND (contract_ IN (SELECT cs.contract
                              FROM CAMPAIGN_SITE_TAB cs
                             WHERE cs.campaign_id = c.campaign_id))
         ORDER BY c.priority, c.campaign_id DESC ;
BEGIN
   
   OPEN get_part_price_campaign;
   FETCH get_part_price_campaign INTO campaign_id_;
   CLOSE get_part_price_campaign;
   
   
END Get_Price_Campaign_For_Part___;


PROCEDURE Post_Insert_Actions___ (
   attr_   IN OUT VARCHAR2,
   newrec_ IN OUT CAMPAIGN_TAB%ROWTYPE )
IS
   site_info_ VARCHAR2(2000);
   site_attr_ VARCHAR2(2000);
BEGIN
   IF (newrec_.supply_site IS NOT NULL ) THEN
      Client_SYS.Add_To_Attr('CAMPAIGN_ID', newrec_.campaign_id, site_attr_);
      Client_SYS.Add_To_Attr('CONTRACT',    newrec_.supply_site, site_attr_);
      Campaign_Site_API.New(site_info_, site_attr_);
   END IF;
END Post_Insert_Actions___;


-- Fill_Camp_Assort_Part_Tmp___
--   Purpose: This method is used to insert the connected parts in the assortment nodes to a
--   campaign_assort_part_tmp temporary table. Parts are added from assortment leaf node to root node.
--   It is not allow to duplicate the parts records in the temporary table,
--   If purchase price is defined per assortment node then there should be a validation to check whether that
--   all the parts belong to a node have the same primary supplier, price uom and currency code.
PROCEDURE Fill_Camp_Assort_Part_Tmp___ (
   campaign_id_ IN NUMBER )
IS
   assort_part_tab_          Assortment_Node_API.part_table;
   dummy_                    NUMBER;
   primary_supplier_no_      VARCHAR2(20);
   purchase_currency_code_   VARCHAR2(3);
   purchase_price_uom_       VARCHAR2(10);
   current_supplier_id_      VARCHAR2(20);
   current_currency_code_    VARCHAR2(3);
   current_price_uom_        VARCHAR2(10); 
   supply_site_              CAMPAIGN_TAB.supply_site%TYPE;
   $IF Component_Purch_SYS.INSTALLED $THEN
      supp_part_rec_         Purchase_Part_Supplier_API.Public_Rec;
   $END

   CURSOR get_assortment IS
      SELECT assortment_id, assortment_node_id, price_unit_meas, purchase_price, purchase_discount
        FROM CAMPAIGN_ASSORTMENT_TAB
       WHERE campaign_id = campaign_id_
         AND purchase_price IS NOT NULL 
      ORDER BY Assortment_Node_API.Get_Level_No(assortment_id, assortment_node_id) DESC;

   CURSOR exist_part(part_no_ VARCHAR2) IS
      SELECT 1
        FROM campaign_assort_part_tmp
       WHERE part_no = part_no_;  
BEGIN
   supply_site_ := Get_Supply_Site(campaign_id_);

   FOR assort_rec_ IN get_assortment LOOP
      assort_part_tab_ := Assortment_Node_API.Get_Connected_Parts(assort_rec_.assortment_id, 
                                                               assort_rec_.assortment_node_id);
      current_supplier_id_   := NULL; 
      current_currency_code_ := NULL;
      current_price_uom_     := NULL;
      IF (assort_part_tab_.COUNT > 0) THEN
         FOR i IN assort_part_tab_.FIRST..assort_part_tab_.LAST LOOP
            IF (Inventory_Part_API.Check_Exist(supply_site_, assort_part_tab_(i).part_no) = FALSE) THEN
               Error_SYS.Record_General(lu_name_, 'NOINVPART: There exists no inventory part for the part :P1 in assortment node id :P2.', assort_part_tab_(i).part_no, assort_rec_.assortment_node_id);
            END IF;
            $IF Component_Purch_SYS.INSTALLED $THEN
               primary_supplier_no_  := Purchase_Part_Supplier_API.Get_Primary_Supplier_No(supply_site_, assort_part_tab_(i).part_no);
               IF (primary_supplier_no_ IS NOT NULL) THEN
                  supp_part_rec_          := Purchase_Part_Supplier_API.Get(supply_site_, assort_part_tab_(i).part_no, primary_supplier_no_);
                  purchase_currency_code_ := supp_part_rec_.currency_code;
                  purchase_price_uom_     := supp_part_rec_.price_unit_meas;
               ELSE
                  purchase_currency_code_ := NULL;
                  purchase_price_uom_     := NULL;
               END IF;
            $END

            IF (primary_supplier_no_ IS NULL) THEN
               Error_SYS.Record_General(lu_name_, 'NOPRIMARYSUPP: There exists no primary supplier for the part :P1 in assortment node id :P2.', assort_part_tab_(i).part_no, assort_rec_.assortment_node_id);
            END IF;

            -- Check whether the assortment part record is already added to the
            -- campaign_assort_part_tmp temporary table.
            OPEN exist_part(assort_part_tab_(i).part_no);
            FETCH exist_part INTO dummy_;
            IF (exist_part%NOTFOUND) THEN
               IF (current_supplier_id_   IS NOT NULL AND current_supplier_id_   != primary_supplier_no_) OR
                  (current_currency_code_ IS NOT NULL AND current_currency_code_ != purchase_currency_code_) OR
                  (current_price_uom_     IS NOT NULL AND current_price_uom_     != purchase_price_uom_) THEN
                  Error_SYS.Record_General(lu_name_, 'NOTSAMESUPPNODE: All parts connected to the assortment node id :P1 must have the same primary supplier, currency, and price unit of measure.', assort_rec_.assortment_node_id);
               END IF;
               current_supplier_id_   := primary_supplier_no_; 
               current_currency_code_ := purchase_currency_code_;
               current_price_uom_     := purchase_price_uom_;

               INSERT INTO campaign_assort_part_tmp
                  (assortment_node_id,
                   part_no,
                   vendor_no,
                   currency_code,
                   purchase_price,
                   purchase_discount)
               VALUES
                  (assort_rec_.assortment_node_id,
                   assort_part_tab_(i).part_no,
                   primary_supplier_no_,
                   purchase_currency_code_,
                   assort_rec_.purchase_price,
                   assort_rec_.purchase_discount);
            END IF;
            CLOSE exist_part;
         END LOOP;
      END IF;
   END LOOP;
END Fill_Camp_Assort_Part_Tmp___;


-- Get_Price_Grp_Camp_For_Part___
--   Return valid campaign for a specified sales part and
--   customer price group which exist on a campaign customer price groups.
PROCEDURE Get_Price_Grp_Camp_For_Part___ (
   campaign_id_            OUT NUMBER,
   cust_price_group_id_    IN  VARCHAR2,
   contract_               IN  VARCHAR2,
   catalog_no_             IN  VARCHAR2,
   currency_code_          IN  VARCHAR2,
   price_effectivity_date_ IN  DATE )
IS
   CURSOR get_price_grp_campaign IS
      SELECT c.campaign_id
        FROM CAMPAIGN_TAB c, CAMPAIGN_PART_TAB cp
       WHERE c.campaign_id = cp.campaign_id
         AND c.rowstate ='Active'
         AND c.currency_code = currency_code_
         AND TRUNC(price_effectivity_date_) BETWEEN c.sales_start AND c.sales_end
         AND cp.catalog_no = catalog_no_
         AND cp.sales_price IS NOT NULL
         AND (cust_price_group_id_ IN (SELECT cpg.cust_price_group_id
                                         FROM CAMPAIGN_CUST_PRICE_GROUP_TAB cpg
                                        WHERE cpg.campaign_id = c.campaign_id))
         AND (contract_ IN (SELECT cs.contract
                              FROM CAMPAIGN_SITE_TAB cs
                             WHERE cs.campaign_id = c.campaign_id))
         ORDER BY c.priority, c.campaign_id DESC ;
BEGIN
   OPEN get_price_grp_campaign;
   FETCH get_price_grp_campaign INTO campaign_id_;
   CLOSE get_price_grp_campaign;
      
END Get_Price_Grp_Camp_For_Part___;


-- Get_Pr_Grp_Camp_For_Assort___
--   Return valid campaign with the assortment that has the part node
--   for a specified sales part and customer price group
--   which exist on a campaign customer price groups.
PROCEDURE Get_Pr_Grp_Camp_For_Assort___ (
   campaign_id_            OUT NUMBER,
   assortment_id_          OUT VARCHAR2,
   assort_node_id_         OUT VARCHAR2,
   cust_price_group_id_    IN  VARCHAR2,
   contract_               IN  VARCHAR2,
   part_no_                IN  VARCHAR2,
   currency_code_          IN  VARCHAR2,
   price_unit_meas_        IN  VARCHAR2,
   price_effectivity_date_ IN DATE )
IS
   -- This cursor will return valid campaign with customer price group define
   -- which have an assortment defined on them
   CURSOR get_valid_campaigns IS
      SELECT c.campaign_id, c.assortment_id
        FROM CAMPAIGN_TAB c
       WHERE c.assortment_id IS NOT NULL
         AND c.rowstate = 'Active'
         AND c.currency_code = currency_code_
         AND TRUNC(price_effectivity_date_) BETWEEN c.sales_start AND c.sales_end
         AND (cust_price_group_id_ IN (SELECT cpg.cust_price_group_id
                                         FROM CAMPAIGN_CUST_PRICE_GROUP_TAB cpg
                                        WHERE cpg.campaign_id = c.campaign_id))
         AND (contract_ IN (SELECT cs.contract
                              FROM CAMPAIGN_SITE_TAB cs
                              WHERE cs.campaign_id = c.campaign_id ))
         ORDER BY c.priority;

   -- Once a valid campaign-assortment selected, check whether the campaign's assortment tab
	-- has a valid entry for the part.
   CURSOR get_valid_sale_price_entry (campaign_id_ IN VARCHAR2, assortment_id_ IN VARCHAR2) IS
      SELECT t.assortment_node_id
        FROM assortment_node_tab t
       WHERE EXISTS (SELECT 1
                       FROM CAMPAIGN_ASSORTMENT_TAB cat
                      WHERE cat.assortment_id = t.assortment_id
                        AND cat.assortment_node_id = t.assortment_node_id
                        AND cat.campaign_id = campaign_id_
                        AND (cat.price_unit_meas = '*' OR cat.price_unit_meas = price_unit_meas_)
                        AND cat.sales_price IS NOT NULL)
       START WITH t.assortment_id = assortment_id_
             AND  t.assortment_node_id = part_no_
      CONNECT BY PRIOR  t.assortment_id = t.assortment_id
             AND PRIOR t.parent_node = t.assortment_node_id;

BEGIN
   -- Check all the valid campaigns (with an assortment in it) with cust price group exist, 
   -- whether any assortment node defined in assortment tab.
   FOR rec_ IN get_valid_campaigns LOOP
       OPEN  get_valid_sale_price_entry (rec_.campaign_id , rec_.assortment_id);
        FETCH get_valid_sale_price_entry INTO assort_node_id_;
        CLOSE get_valid_sale_price_entry;

		IF (assort_node_id_ IS NOT NULL) THEN
           campaign_id_       := rec_.campaign_id;
           assortment_id_     := rec_.assortment_id;
        END IF;
        EXIT WHEN assort_node_id_ IS NOT NULL;
   END LOOP;
END Get_Pr_Grp_Camp_For_Assort___;


-- Get_Dis_Grp_Camp_For_Assort___
--   Returns valid discount campaign with the assortment that has the part node
--   for a specified sales part and customer price group which exist on a
--   campaign customer price groups.
PROCEDURE Get_Dis_Grp_Camp_For_Assort___ (
   campaign_id_            OUT NUMBER,
   assortment_id_          OUT VARCHAR2,
   assort_node_id_         OUT VARCHAR2,
   cust_price_group_id_    IN  VARCHAR2,
   contract_               IN  VARCHAR2,
   part_no_                IN  VARCHAR2,
   currency_code_          IN  VARCHAR2,
   price_unit_meas_        IN  VARCHAR2,
   price_effectivity_date_ IN  DATE )
IS
   -- This cursor will return valid campaign for the cust price group
   -- Which have an assortment defined on them
   -- and in those assortment trees the part exist as a sub part node.
   CURSOR get_valid_campaigns IS
      SELECT c.campaign_id, c.assortment_id
        FROM CAMPAIGN_TAB c
       WHERE c.rowstate = 'Active'
         AND c.currency_code = currency_code_
         AND c.assortment_id IS NOT NULL
         AND TRUNC(price_effectivity_date_) BETWEEN c.sales_start AND c.sales_end
         AND (cust_price_group_id_ IN (SELECT cpg.cust_price_group_id
                                         FROM CAMPAIGN_CUST_PRICE_GROUP_TAB cpg
                                        WHERE cpg.campaign_id = c.campaign_id))
         AND (contract_ IN (SELECT cs.contract
                              FROM CAMPAIGN_SITE_TAB cs
                              WHERE cs.campaign_id = c.campaign_id ))
         ORDER BY c.priority;


   -- Once a valid campaign-assortment selected,
   -- Check whether the assortment has a valid entry for the part.
   CURSOR get_valid_sale_price_entry (campaign_id_ IN VARCHAR2, assortment_id_ IN VARCHAR2) IS
      SELECT t.assortment_node_id
        FROM ASSORTMENT_NODE_TAB t
       WHERE EXISTS (SELECT 1 
                       FROM CAMPAIGN_ASSORTMENT_TAB eat
                      WHERE eat.assortment_id = t.assortment_id
                        AND eat.assortment_node_id = t.assortment_node_id
                        AND eat.campaign_id = campaign_id_
                        AND (eat.price_unit_meas = '*' OR eat.price_unit_meas = price_unit_meas_)
                        AND eat.sales_price IS NULL
                        AND eat.sales_discount IS NOT NULL)
       START WITH        t.assortment_id = assortment_id_
             AND        t.assortment_node_id = part_no_
     CONNECT BY PRIOR  t.assortment_id = t.assortment_id
             AND PRIOR  t.parent_node = t.assortment_node_id;
BEGIN

   -- Check all the valid campaigns (with an assortment in it) with cust price group exist, 
   -- whether any assortment node defined in assortment tab.
   FOR rec_ IN get_valid_campaigns LOOP
      OPEN get_valid_sale_price_entry (rec_.campaign_id , rec_.assortment_id);
      FETCH get_valid_sale_price_entry INTO assort_node_id_;
      CLOSE get_valid_sale_price_entry;

      IF (assort_node_id_ IS NOT NULL) THEN
         assortment_id_ := rec_.assortment_id;
         campaign_id_   := rec_.campaign_id;
      END IF;
      EXIT WHEN assort_node_id_ IS NOT NULL;
   END LOOP;
END Get_Dis_Grp_Camp_For_Assort___;


-- Create_Camp_Alloc_Lines___
--   Creates allocation lines for the allocation created from campaign
PROCEDURE Create_Camp_Alloc_Lines___ (
   lines_created_ OUT BOOLEAN,                                      
   campaign_id_   IN  NUMBER,
   allocation_id_ IN  VARCHAR2 )
IS
   stmt_            VARCHAR2(10000);
   supply_site_     VARCHAR2(5);
   inv_part_no_     VARCHAR2(25);
   assort_part_tab_ Assortment_Node_API.part_table;

   CURSOR get_site IS
      SELECT contract
        FROM CAMPAIGN_SITE_TAB
       WHERE campaign_id = campaign_id_;

   CURSOR get_part IS
      SELECT catalog_no, contract
        FROM CAMPAIGN_PART_TAB
       WHERE campaign_id = campaign_id_
      UNION
      SELECT catalog_no, contract
        FROM sales_promotion_deal_buy_tab  
       WHERE campaign_id = campaign_id_
      UNION
      SELECT catalog_no, contract
        FROM sales_promotion_deal_get_tab
       WHERE campaign_id = campaign_id_;

   CURSOR get_assortments IS
      SELECT assortment_id, assortment_node_id
        FROM campaign_assortment_tab
       WHERE campaign_id = campaign_id_
      UNION
      SELECT assortment_id, assortment_node_id
        FROM sales_promotion_deal_buy_tab  
       WHERE campaign_id = campaign_id_
      UNION
      SELECT assortment_id, assortment_node_id
        FROM sales_promotion_deal_get_tab
       WHERE campaign_id = campaign_id_;
BEGIN

   lines_created_ := FALSE;
   IF (Dictionary_SYS.Component_Is_Active('DISORD')) THEN
      supply_site_ := Get_Supply_Site(campaign_id_);

      FOR part_rec_ IN get_part LOOP
         inv_part_no_ := Sales_Part_API.Get_Part_No(part_rec_.contract, part_rec_.catalog_no);
         -- Allocations created only the parts with a connected inventory part in the supply site considered.
         IF (Inventory_Part_API.Check_Exist(supply_site_,  inv_part_no_)) THEN
            stmt_  := 'DECLARE
                          info_        VARCHAR2(32000);
                          attr_        VARCHAR2(5000);
                       BEGIN
                          -- Check whether the allocation part record is already created
                          IF (Dist_Allocation_Part_API.Check_Exist(:allocation_id, :supply_site, :part_no) = 0) THEN
                             Client_SYS.Clear_Attr(attr_);
                             Client_SYS.Add_To_Attr(''ALLOCATION_NO'', :allocation_id,  attr_);
                             Client_SYS.Add_To_Attr(''SUPPLY_SITE'',   :supply_site,    attr_);
                             Client_SYS.Add_To_Attr(''PART_NO'',       :part_no,       attr_);
                             Dist_Allocation_Part_API.New (info_, attr_);
                          END IF;
                       END;';
            @ApproveDynamicStatement(2010-04-27,NaLrlk)
            EXECUTE IMMEDIATE stmt_
               USING IN  allocation_id_,
                     IN  supply_site_,
                     IN  part_rec_.catalog_no;
            -- When an allocatin part line is created, 
            -- lines_created_ should be set to TRUE.
            lines_created_ := TRUE;

            FOR site_rec_ IN get_site LOOP
               -- Check if the supply site is same as the destination site
               IF (site_rec_.contract != supply_site_) THEN
                  stmt_  := 'DECLARE
                                info_       VARCHAR2(32000);
                                attr_       VARCHAR2(5000);
                             BEGIN
                                -- Check whether the line is already created.
                                IF (Dist_Allocation_Line_API.Get_Line_No_For_Site_And_Part(:allocation_id, :part_no, :destination_site) = -1) THEN
                                   Client_SYS.Clear_Attr(attr_);
                                   Client_SYS.Add_To_Attr(''ALLOCATION_NO'',    :allocation_id,     attr_);
                                   Client_SYS.Add_To_Attr(''SUPPLY_SITE'',      :supply_site,       attr_);
                                   Client_SYS.Add_To_Attr(''PART_NO'',          :part_no,           attr_);
                                   Client_SYS.Add_To_Attr(''DESTINATION_SITE'', :destination_site,  attr_);
                                   Dist_Allocation_Line_API.New (info_, attr_);
                                END IF;
                             END;';
                  @ApproveDynamicStatement(2010-04-23,NaLrlk)
                  EXECUTE IMMEDIATE stmt_
                     USING IN  allocation_id_, 
                           IN  part_rec_.catalog_no,
                           IN  site_rec_.contract,
                           IN  supply_site_;
               END IF;
            END LOOP;
         END IF;
      END LOOP;
      FOR assort_rec_ IN get_assortments LOOP
         assort_part_tab_ := Assortment_Node_API.Get_Connected_Parts(assort_rec_.assortment_id, assort_rec_.assortment_node_id);
         IF (assort_part_tab_.COUNT > 0) THEN
            FOR i IN assort_part_tab_.FIRST..assort_part_tab_.LAST LOOP
               IF (Inventory_Part_API.Check_Exist(supply_site_,  assort_part_tab_(i).part_no)) THEN
                  stmt_  := 'DECLARE
                                info_        VARCHAR2(32000);
                                attr_        VARCHAR2(5000);
                             BEGIN
                                -- Check whether the allocation part record is already created
                                IF (Dist_Allocation_Part_API.Check_Exist(:allocation_id, :supply_site, :part_no) = 0) THEN
                                   Client_SYS.Clear_Attr(attr_);
                                   Client_SYS.Add_To_Attr(''ALLOCATION_NO'', :allocation_id,  attr_);
                                   Client_SYS.Add_To_Attr(''SUPPLY_SITE'',   :supply_site,    attr_);
                                   Client_SYS.Add_To_Attr(''PART_NO'',       :part_no,        attr_);
                                   Dist_Allocation_Part_API.New (info_, attr_);
                                END IF;
                             END;';
                  @ApproveDynamicStatement(2010-04-27,NaLrlk)
                  EXECUTE IMMEDIATE stmt_
                     USING IN  allocation_id_,
                           IN  supply_site_,
                           IN  assort_part_tab_(i).part_no;

                  -- When an allocatin part line is created, 
                  -- lines_created_ should be set to TRUE.
                  lines_created_ := TRUE;

                  FOR site_rec_ IN get_site LOOP
                     -- Check if the supply site is same as the destination site
                     IF (site_rec_.contract != supply_site_) THEN
                        stmt_  := 'DECLARE
                                      info_       VARCHAR2(32000);
                                      attr_       VARCHAR2(5000);
                                   BEGIN
                                      -- Check whether the line is already created.
                                      IF (Dist_Allocation_Line_Api.Get_Line_No_For_Site_And_Part(:allocation_id, :part_no, :destination_site) = -1) THEN
                                         Client_SYS.Clear_Attr(attr_);
                                         Client_SYS.Add_To_Attr(''ALLOCATION_NO'',    :allocation_id,     attr_);
                                         Client_SYS.Add_To_Attr(''SUPPLY_SITE'',      :supply_site,       attr_);
                                         Client_SYS.Add_To_Attr(''PART_NO'',          :part_no,           attr_);
                                         Client_SYS.Add_To_Attr(''DESTINATION_SITE'', :destination_site,  attr_);
                                         Dist_Allocation_Line_API.New (info_, attr_);
                                      END IF;
                                   END;';
                        @ApproveDynamicStatement(2010-04-23,NaLrlk)
                        EXECUTE IMMEDIATE stmt_
                           USING IN  allocation_id_, 
                                 IN  assort_part_tab_(i).part_no,
                                 IN  site_rec_.contract,
                                 IN  supply_site_;
                     END IF;
                  END LOOP;
               END IF;
            END LOOP;
         END IF;
      END LOOP;
   END IF;
END Create_Camp_Alloc_Lines___;


PROCEDURE Validate_Priority___ (
   priority_   IN  NUMBER )
IS
BEGIN
   IF (priority_ < 1) THEN
      Error_SYS.Record_general(lu_name_, 'PRIORITYERROR: Priority cannot be less than or equal to zero.');
   END IF;
   IF (priority_  != TRUNC(priority_) ) THEN
      Error_SYS.Record_general(lu_name_, 'PRIORDECIERROR: Priority cannot have a decimal value.');
   END IF;
END Validate_Priority___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('AUTHORIZE_CODE',                User_Default_API.Get_Authorize_Code, attr_);
   Client_SYS.Add_To_Attr('REBATE_BUILDER_DB',             'TRUE',                              attr_);
   Client_SYS.Add_To_Attr('VALID_FOR_ALL_CUSTOMERS_DB',    'FALSE',                             attr_);
   Client_SYS.Add_To_Attr('REFERENCE_SITE',                User_Default_API.Get_Contract(),     attr_);
   Client_SYS.Add_To_Attr('IGNORE_IF_LOW_PRICE_FOUND_DB',  'TRUE',                              attr_);
   Client_SYS.Add_To_Attr('USE_PRICE_INCL_TAX_DB',  Site_Discom_Info_API.Get_Use_Price_Incl_Tax_Ord_Db(User_Default_API.Get_Contract()), attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT CAMPAIGN_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.created_date := SYSDATE;
   Client_SYS.Add_To_Attr('CREATED_DATE', newrec_.Created_Date, attr_);
   super(objid_, objversion_, newrec_, attr_);
   Post_Insert_Actions___(attr_, newrec_);   
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     CAMPAIGN_TAB%ROWTYPE,
   newrec_     IN OUT CAMPAIGN_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   site_info_  VARCHAR2(2000);
   site_attr_  VARCHAR2(2000);
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   IF (oldrec_.supply_site IS NULL AND newrec_.supply_site IS NOT NULL)THEN
      IF (Campaign_Site_API.Check_Exist(newrec_.campaign_id, newrec_.supply_site) = 0) THEN
         Client_SYS.Add_To_Attr('CAMPAIGN_ID', newrec_.campaign_id, site_attr_);
         Client_SYS.Add_To_Attr('CONTRACT',    newrec_.supply_site, site_attr_);
         Campaign_Site_API.New(site_info_, site_attr_);
      END IF;
      Campaign_Part_API.Update_Purch_Part_Supplier(newrec_.campaign_id);
   END IF;

   IF (newrec_.valid_for_all_customers = 'TRUE' AND NVL(oldrec_.valid_for_all_customers, 'FALSE') = 'FALSE') THEN
      Campaign_Customer_API.Remove_All_Customers(newrec_.campaign_id);
      Campaign_Cust_Price_Group_API.Remove_All_Cust_Price_Group(newrec_.campaign_id);
   END IF;
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT campaign_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   dummy_currtype_     VARCHAR2(10);
   dummy_conv_factor_  NUMBER;
   dummy_rate_         NUMBER;
BEGIN
   IF (newrec_.use_price_incl_tax IS NULL) THEN
      newrec_.use_price_incl_tax := 'FALSE';
   END IF;
   super(newrec_, indrec_, attr_);
   
   IF (newrec_.valid_for_all_customers IS NULL) THEN
      newrec_.valid_for_all_customers := 'FALSE';
   END IF;

   IF (newrec_.sales_start > newrec_.sales_end OR newrec_.purchase_start > newrec_.purchase_end OR
      newrec_.receiving_start > newrec_.receiving_end OR newrec_.delivery_start > newrec_.delivery_end) THEN
      Error_SYS.Record_General(lu_name_,'STARTGTEND: End Date should be ahead of Start Date');
   END IF;

   IF (newrec_.supply_site IS NOT NULL ) THEN
      IF (Site_API.Get_Company(newrec_.supply_site) != newrec_.company) THEN
         Raise_Inval_Supply_Site_Err___(newrec_.supply_site, newrec_.company);
      END IF;
      User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, newrec_.supply_site);
   END IF;

   IF (newrec_.reference_site IS NOT NULL ) THEN
      IF (Site_API.Get_Company(newrec_.reference_site) != newrec_.company) THEN
         Raise_Inval_Ref_Site_Error___(newrec_.reference_site, newrec_.company);
      END IF;
      User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, newrec_.reference_site);
   END IF;
   Validate_Priority___(newrec_.priority);
   
   newrec_.campaign_id := Get_Next_Campaign_Id___;
   Client_SYS.Add_To_Attr('CAMPAIGN_ID', newrec_.campaign_id, attr_);
   -- Checking if the currency code has a valid currency rate for this company, this method gives an error no valid currency rate exist for this company/currency code
   Invoice_Library_API.Get_Currency_Rate_Defaults(dummy_currtype_, dummy_conv_factor_, dummy_rate_, newrec_.company, newrec_.currency_code, SYSDATE, 'CUSTOMER', NULL);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     campaign_tab%ROWTYPE,
   newrec_ IN OUT campaign_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   dummy_currtype_     VARCHAR2(10);
   dummy_conv_factor_  NUMBER;
   dummy_rate_         NUMBER;
BEGIN
   IF (newrec_.use_price_incl_tax IS NULL) THEN
      newrec_.use_price_incl_tax := 'FALSE';
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);
   
   IF (indrec_.supply_site) THEN
         IF Get_Objstate(newrec_.campaign_id) != 'Planned' THEN
            Error_Sys.Appl_General(lu_name_,'SUPPLYSITECANTUPDATE: The campaign is not in status planned, you cannot update the supply site.');
         END IF;
   END IF;
   IF (newrec_.rowstate = 'Closed') AND (NVL(oldrec_.approved_date, Database_SYS.last_calendar_date_) = NVL(newrec_.approved_date, Database_SYS.last_calendar_date_)) THEN
      Error_SYS.Record_General(lu_name_, 'UPDATENOTALLOW: Update not allowed when status is closed.');
   END IF;
   
   IF (newrec_.sales_start > newrec_.sales_end OR newrec_.purchase_start > newrec_.purchase_end OR
      newrec_.receiving_start > newrec_.receiving_end OR newrec_.delivery_start > newrec_.delivery_end) THEN
      Error_SYS.Record_General(lu_name_,'STARTGTEND: End Date should be ahead of Start Date');
   END IF;

   IF (newrec_.supply_site IS NOT NULL ) THEN
      IF (Site_API.Get_Company(newrec_.supply_site) != newrec_.company) THEN
         Raise_Inval_Supply_Site_Err___(newrec_.supply_site, newrec_.company);
      END IF;
      User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, newrec_.supply_site);
   END IF;

   IF (newrec_.reference_site IS NOT NULL ) THEN
      IF (Site_API.Get_Company(newrec_.reference_site) != newrec_.company) THEN
         Raise_Inval_Ref_Site_Error___(newrec_.reference_site, newrec_.company);
      END IF;
      User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, newrec_.reference_site);
   END IF;

   IF (oldrec_.reference_site != newrec_.reference_site) AND
      ((NOT Get_Objstate(newrec_.campaign_id) = 'Planned') OR (Sales_Promotion_Deal_API.Campaign_Has_Sales_Promo_Deal(newrec_.campaign_id))) THEN
      Error_SYS.Record_General(lu_name_, 'CANNOTCHANGEREFSITE: The reference site can only be changed when the campaign is in status Planned and there are no sales promotion deals connected.');
   END IF;

   IF (newrec_.assortment_id != oldrec_.assortment_id AND Sales_Promotion_Deal_API.Has_Assortment_Based_Deal(newrec_.campaign_id)) THEN
      Error_SYS.Record_General(lu_name_, 'CANNOTCHANGEASSORT: The Assortment ID (:P1) cannot be changed when there are assortment based sales promotion deals connected to the campaign.', oldrec_.assortment_id);
   END IF;

   IF (newrec_.rowstate = 'Active' AND newrec_.assortment_id IS NOT NULL) THEN
      IF (Assortment_Structure_API.Get_Objstate(newrec_.assortment_id) != 'Active') THEN
         Raise_Assortm_Not_Act_Error___(newrec_.assortment_id);
      END IF;
   END IF;
   Validate_Priority___(newrec_.priority);
   
   -- Checking if the currency code has a valid currency rate for this company, this method gives an error no valid currency rate exist for this company/currency code
   Invoice_Library_API.Get_Currency_Rate_Defaults(dummy_currtype_, dummy_conv_factor_, dummy_rate_, newrec_.company, newrec_.currency_code, SYSDATE, 'CUSTOMER', NULL);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@Override
PROCEDURE Activate__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   rec_ CAMPAIGN_TAB%ROWTYPE;
BEGIN
   IF (action_ = 'DO') THEN
      rec_ := Lock_By_Id___(objid_, objversion_);
      IF (rec_.assortment_id IS NOT NULL) THEN
         IF (Assortment_Structure_API.Get_Objstate(rec_.assortment_id) != 'Active') THEN
            Raise_Assortm_Not_Act_Error___(rec_.assortment_id);
         END IF;
      END IF;
   END IF;
   super(info_, objid_, objversion_, attr_, action_);
END Activate__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------



-- Create_Supplier_Blanket
--   Creates Supplier agreements for the specified campaign.
PROCEDURE Create_Supplier_Blanket (
   info_           OUT VARCHAR2,
   campaign_id_    IN  NUMBER,
   agreement_type_ IN  VARCHAR2 )
IS
   site_exist_              NUMBER;
   part_exist_              NUMBER;
   assortment_exist_        NUMBER;
   no_part_supp_exist_      NUMBER;
   stmt_                    VARCHAR2(2000);
   blanket_created_         VARCHAR2(5) := 'FALSE';
   campaign_rec_            Public_Rec;

   CURSOR site_exist IS
      SELECT 1
        FROM CAMPAIGN_SITE_TAB
       WHERE campaign_id = campaign_id_;

   CURSOR part_exist IS
      SELECT 1
        FROM CAMPAIGN_PART_TAB
       WHERE campaign_id = campaign_id_;

   CURSOR assortment_exist IS
      SELECT 1
        FROM CAMPAIGN_ASSORTMENT_TAB
       WHERE campaign_id = campaign_id_;

   CURSOR exist_no_supp_part IS
      SELECT 1
        FROM CAMPAIGN_PART_TAB t
       WHERE campaign_id = campaign_id_
         AND (supplier_id IS NULL OR purchase_price IS NULL);

BEGIN
   OPEN site_exist;
   FETCH site_exist INTO site_exist_;
   IF (site_exist%NOTFOUND) THEN
      site_exist_ := 0;
   END IF;
   CLOSE site_exist;

   OPEN part_exist;
   FETCH part_exist INTO part_exist_;
   IF (part_exist%NOTFOUND) THEN
      part_exist_ := 0;
   END IF;
   CLOSE part_exist;

   OPEN assortment_exist;
   FETCH assortment_exist INTO assortment_exist_;
   IF (assortment_exist%NOTFOUND) THEN
      assortment_exist_ := 0;
   END IF;
   CLOSE assortment_exist;

   IF ((site_exist_ = 0) AND (part_exist_ = 0 OR assortment_exist_ = 0 )) THEN
      Error_SYS.Record_General(lu_name_, 'NOTPARTORSITE: There are no parts or sites defined for the campaign.');
   END IF;

   -- IF there exist any campaign parts with supplier or purchase price is not defined, 
   -- This can be informed to user via information message.
   OPEN exist_no_supp_part;
   FETCH exist_no_supp_part INTO no_part_supp_exist_;
   IF (exist_no_supp_part%NOTFOUND) THEN
      no_part_supp_exist_ := 0;
   END IF;
   CLOSE exist_no_supp_part;

   campaign_rec_ := Get(campaign_id_);
   
   -- Insert campaign part records to the campaign_supplier_blk_tmp temporary table.
   IF (Dictionary_SYS.Component_Is_Active('PURCH')) THEN
      stmt_ := 'BEGIN
                   INSERT INTO campaign_supplier_blk_tmp (
                      vendor_no,  contract, part_no, currency_code,
                      start_date, end_date, buy_unit_price, unit_price_incl_tax, discount, use_price_incl_tax)
                      SELECT cpt.supplier_id,
                             cpt.supply_contract,
                             cpt.purchase_part_no,
                             cpt.purchase_currency_code,
                             ct.purchase_start,
                             ct.purchase_end,
                             NVL(cpt.purchase_price, 0),
                             NVL(cpt.purchase_price_incl_tax, 0),
                             NVL(cpt.purchase_discount, 0),
                             ct.use_price_incl_tax
                        FROM campaign_part_tab cpt, campaign_tab ct
                       WHERE cpt.campaign_id = :campaign_id
                         AND cpt.campaign_id = ct.campaign_id
                         AND (cpt.supplier_id IS NOT NULL AND cpt.purchase_price IS NOT NULL);
                END;';

      @ApproveDynamicStatement(2013-03-14,JeeJlk)
      EXECUTE IMMEDIATE stmt_
         USING IN  campaign_id_;
   END IF;

   -- Insert all parts in the assortment nodes to the temporary table campaign_assort_part_tmp.
   Fill_Camp_Assort_Part_Tmp___(campaign_id_);
   
   -- Insert part records from campaign_assort_part_tmp temporary table to campaign_supplier_blk_tmp table.
   -- When there exist a record with same supplier and part in the temporary table, it is not allow to insert again in order to get the
   -- priority to the campaign parts rather than parts in the assortment nodes.
   IF (Dictionary_SYS.Component_Is_Active('PURCH')) THEN
      stmt_ := 'BEGIN
                   INSERT INTO campaign_supplier_blk_tmp (
                      vendor_no, contract, part_no, currency_code, 
                      start_date, end_date, buy_unit_price, unit_price_incl_tax, discount, use_price_incl_tax)
                      SELECT cap.vendor_no,
                             ct.supply_site,          
                             cap.part_no, 
                             cap.currency_code, 
                             ct.purchase_start,
                             ct.purchase_end,
                             NVL(cap.purchase_price, 0), 
                             NVL(cap.purchase_price, 0), 
                             NVL(cap.purchase_discount, 0),
                             ct.use_price_incl_tax
                        FROM campaign_assort_part_tmp cap, campaign_tab ct
                       WHERE ct.campaign_id = :campaign_id
                         AND NOT EXISTS (SELECT 1
                                           FROM campaign_supplier_blk_tmp csb
                                          WHERE csb.part_no   = cap.part_no
                                            AND csb.vendor_no = cap.vendor_no);
                END;';
      @ApproveDynamicStatement(2013-03-14,JeeJlk)
      EXECUTE IMMEDIATE stmt_
         USING IN  campaign_id_;
   END IF;

   $IF (Component_Purch_SYS.INSTALLED) $THEN      
      Supplier_Blanket_API.Create_Blanket_From_Campaign(blanket_created_,
                                                        campaign_id_,
                                                        agreement_type_);   
   $END

   IF (blanket_created_ = 'TRUE') THEN
      -- IF there exist at least one campaign part with supplier and purchase part not defined, but supplier agreement created for others
      IF (no_part_supp_exist_ = 1) THEN      
         Client_Sys.Add_Info(lu_name_, 'PARTSUPBLKCREATED: The supplier agreement(s) is created successfully. One or more campaign parts exist without a supplier and/or purchase price.');
      ELSE
         Client_Sys.Add_Info(lu_name_, 'SUPBLKCREATED: The supplier agreement(s) is created successfully.');
      END IF;
   ELSE
      Client_Sys.Add_Info(lu_name_, 'NOSUPBLKCREATED: No campaign part lines or campaign assortment lines are found with a purchase price.');
   END IF;
   info_ := Client_Sys.Get_All_Info;
END Create_Supplier_Blanket;


@UncheckedAccess
FUNCTION Activate_Allowed (
   campaign_id_ IN NUMBER ) RETURN NUMBER
IS
   dummy_ NUMBER;
   CURSOR get_part IS
      SELECT 1
        FROM CAMPAIGN_PART_TAB
       WHERE campaign_id = campaign_id_;
   CURSOR get_site IS
      SELECT 1
        FROM CAMPAIGN_SITE_TAB
       WHERE campaign_id = campaign_id_;
   CURSOR get_assortment IS
      SELECT 1
        FROM CAMPAIGN_ASSORTMENT_TAB
       WHERE campaign_id = campaign_id_;
   CURSOR get_customer IS
      SELECT 1
        FROM CAMPAIGN_CUSTOMER_TAB
       WHERE campaign_id = campaign_id_;
   CURSOR get_cust_price_group IS
      SELECT 1
       FROM  CAMPAIGN_CUST_PRICE_GROUP_TAB
      WHERE campaign_id = campaign_id_;
BEGIN

   IF (Sales_Promotion_Deal_API.Campaign_Has_Sales_Promo_Deal(campaign_id_)) THEN
      IF (NOT Sales_Promotion_Util_API.Check_If_Approvable(campaign_id_)) THEN
         RETURN 0;
      END IF;
   ELSE
      OPEN get_part;
      FETCH get_part INTO dummy_;
      IF (get_part%NOTFOUND) THEN
         OPEN get_assortment;
         FETCH get_assortment INTO dummy_;
         IF (get_assortment%NOTFOUND) THEN
            CLOSE get_assortment;
            CLOSE get_part;
            RETURN 0;
         END IF;
         CLOSE get_assortment;
      END IF;
      CLOSE get_part;
   END IF;
   
   OPEN get_site;
   FETCH get_site INTO dummy_;
   IF (get_site%NOTFOUND) THEN
      CLOSE get_site;
      RETURN 0;
   END IF;
   CLOSE get_site;

   OPEN get_customer;
   FETCH get_customer INTO dummy_;
   IF (get_customer%NOTFOUND) THEN
      IF (NVL(Get_Valid_For_All_Customers_Db(campaign_id_), ' ') != 'TRUE') THEN
         OPEN get_cust_price_group;
         FETCH get_cust_price_group INTO dummy_;
         IF (get_cust_price_group%NOTFOUND) THEN
            CLOSE get_cust_price_group;
            CLOSE get_customer;
            RETURN 0;
         END IF;
         CLOSE get_cust_price_group;
      END IF;
   END IF;
   CLOSE get_customer;
   RETURN 1;
END Activate_Allowed;




@UncheckedAccess
FUNCTION Get_Invalid_Part (
   campaign_id_ IN NUMBER ) RETURN VARCHAR2
IS
   inv_part_no_  VARCHAR2(25);
   CURSOR get_part IS
      SELECT catalog_no, contract
        FROM CAMPAIGN_PART_TAB
       WHERE campaign_id = campaign_id_;
   CURSOR get_site IS
      SELECT contract
        FROM CAMPAIGN_SITE_TAB
       WHERE campaign_id = campaign_id_;
BEGIN
   FOR part_rec_ IN get_part LOOP
      inv_part_no_ := Sales_Part_API.Get_Part_No(part_rec_.contract, part_rec_.catalog_no);
      FOR site_rec_ IN get_site LOOP
         IF NOT Inventory_Part_API.Check_Exist(site_rec_.contract, inv_part_no_) THEN
            RETURN part_rec_.catalog_no;
         END IF;
      END LOOP;
   END LOOP;
   RETURN NULL;
END Get_Invalid_Part;




-- Get_Id_In_Assortment
--   This will return the assortment id if there are records found on assortment tab for the campaign.
@UncheckedAccess
FUNCTION Get_Id_In_Assortment (
   campaign_id_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ CAMPAIGN_ASSORTMENT_TAB.assortment_id%TYPE;
   CURSOR get_attr IS
      SELECT assortment_id
        FROM CAMPAIGN_ASSORTMENT_TAB
       WHERE campaign_id = campaign_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Id_In_Assortment;


-- Get_Campaign_Price_Info
--   Returns price information from campaigns.
PROCEDURE Get_Campaign_Price_Info (
   sale_unit_price_        OUT NUMBER,
   unit_price_incl_tax_    OUT NUMBER,
   discount_type_          OUT VARCHAR2,
   discount_               OUT NUMBER,
   price_source_db_        OUT VARCHAR2,
   price_source_id_        OUT VARCHAR2,
   part_level_db_          OUT VARCHAR2,
   part_level_id_          OUT VARCHAR2,
   customer_level_db_      OUT VARCHAR2,
   customer_level_id_      OUT VARCHAR2,
   net_price_              OUT VARCHAR2,
   customer_no_            IN  VARCHAR2,
   contract_               IN  VARCHAR2,
   catalog_no_             IN  VARCHAR2,
   currency_code_          IN  VARCHAR2,
   price_unit_meas_        IN  VARCHAR2,
   price_effectivity_date_ IN  DATE )
IS
   campaign_id_                NUMBER;
   hierarchy_id_               VARCHAR2(20);
   campaign_assort_id_         VARCHAR2(50);
   campaign_assort_node_id_    VARCHAR2(50);
   campaign_price_unit_meas_   VARCHAR2(30);
   cust_price_group_id_        VARCHAR2(10);
   prnt_cust_price_group_id_   VARCHAR2(10);
   rec_                        CAMPAIGN_TAB%ROWTYPE;
   camp_parts_rec_             Campaign_Part_API.Public_Rec;
   campaign_assort_rec_        Campaign_Assortment_API.Public_Rec;
   prnt_cust_                  cust_hierarchy_struct_tab.customer_parent%TYPE;
   found_sales_price           EXCEPTION;
BEGIN

   ---------------------------------------------------------------------------------------------------
   -- Priority 01. Price defined per part in a campaign connected to the same customer.
   -- Priority 02. Price defined per part in a campaign connected to a customer in customer hierarchy.
   ---------------------------------------------------------------------------------------------------
   Get_Price_Campaign_For_Part___(campaign_id_, customer_no_, contract_, catalog_no_, currency_code_, price_effectivity_date_);
   IF (campaign_id_ IS NOT NULL) THEN
      part_level_db_     := 'PART';
      part_level_id_     := catalog_no_;
      customer_level_db_ := 'CUSTOMER';
      customer_level_id_ := customer_no_;
      RAISE found_sales_price;
   ELSE
      hierarchy_id_  := Cust_Hierarchy_Struct_API.Get_Hierarchy_Id(customer_no_);
      IF (hierarchy_id_ IS NOT NULL) THEN
         prnt_cust_ := Cust_Hierarchy_Struct_API.Get_Parent_Cust(hierarchy_id_, customer_no_);
         -- Search till top parent for a valid campaign definition for the part.,
         WHILE (prnt_cust_ IS NOT NULL) LOOP
            Get_Price_Campaign_For_Part___(campaign_id_, prnt_cust_, contract_, catalog_no_, currency_code_, price_effectivity_date_);
            IF (campaign_id_ IS NOT NULL) THEN
               part_level_db_       := 'PART';
               part_level_id_       := catalog_no_;
               customer_level_db_   := 'HIERARCHY';
               customer_level_id_   := prnt_cust_;
               RAISE found_sales_price;
            ELSE
               -- prnt_cust_ for next iteration of loop
               prnt_cust_ := Cust_Hierarchy_Struct_API.Get_Parent_Cust(hierarchy_id_, prnt_cust_);
            END IF;
         END LOOP;
      END IF;
   END IF;

   -------------------------------------------------------------------------------------------------------------------------------
   -- Priority 03. Price defined per part in a campaign connected to the customer price group of the customer.
   -- Priority 04. Price defined per part in a campaign connected to the customer price group of a customer in customer hierarchy.
   -------------------------------------------------------------------------------------------------------------------------------
   cust_price_group_id_ := Cust_Ord_Customer_API.Get_Cust_Price_Group_Id(customer_no_);
   IF (cust_price_group_id_ IS NOT NULL) THEN
      Get_Price_Grp_Camp_For_Part___(campaign_id_, cust_price_group_id_, contract_, catalog_no_, currency_code_, price_effectivity_date_);
   END IF;
   IF (campaign_id_ IS NOT NULL) THEN
      part_level_db_       := 'PART';
      part_level_id_       := catalog_no_;
      customer_level_db_   := 'CUSTOMER_PRICE_GROUP';
      customer_level_id_   := customer_no_ || ' - ' || cust_price_group_id_;
      RAISE found_sales_price;
   ELSE
      hierarchy_id_  := Cust_Hierarchy_Struct_API.Get_Hierarchy_Id(customer_no_);
      IF (hierarchy_id_ IS NOT NULL) THEN
         prnt_cust_ := Cust_Hierarchy_Struct_API.Get_Parent_Cust(hierarchy_id_, customer_no_);

         -- Search till top parent for a valid campaign definition for the part.,
         WHILE (prnt_cust_ IS NOT NULL) LOOP
            prnt_cust_price_group_id_ := Cust_Ord_Customer_API.Get_Cust_Price_Group_Id(prnt_cust_);
            IF (prnt_cust_price_group_id_ IS NOT NULL) THEN
               Get_Price_Grp_Camp_For_Part___(campaign_id_, prnt_cust_price_group_id_, contract_, catalog_no_, currency_code_, price_effectivity_date_);
            END IF;
            IF (campaign_id_ IS NOT NULL) THEN
               part_level_db_       := 'PART';
               part_level_id_       := catalog_no_;
               customer_level_db_   := 'HIERARCHY_PRICE_GROUP';
               customer_level_id_   := prnt_cust_ || ' - ' || prnt_cust_price_group_id_;
               RAISE found_sales_price;
            ELSE
               -- prnt_cust_ for next iteration of loop
               prnt_cust_ := Cust_Hierarchy_Struct_API.Get_Parent_Cust(hierarchy_id_, prnt_cust_);
            END IF;
         END LOOP;
      END IF;
   END IF;

   -- Note: IF a valid price is not found from campaign part lines for the customer or any of the parents
   -- then we look for the campaign assortment lines.

   --------------------------------------------------------------------------------------------------------------
   -- Priority 05: Price defined per assortment node in a campaign connected to the same customer.
   -- Priority 06: Price defined per assortment node in a campaign connected to a customer in customer hierarchy.
   --------------------------------------------------------------------------------------------------------------
   Get_Price_Camp_For_Assort___(campaign_id_,   campaign_assort_id_,  campaign_assort_node_id_, 
                                customer_no_,   contract_,            catalog_no_, 
                                currency_code_, price_unit_meas_,     price_effectivity_date_ );

   IF (campaign_id_ IS NOT NULL) THEN
      part_level_db_     := 'ASSORTMENT';
      part_level_id_     := campaign_assort_id_ || ' - ' || campaign_assort_node_id_;
      customer_level_db_ := 'CUSTOMER';
      customer_level_id_ := customer_no_;
      RAISE found_sales_price;
   ELSE
      hierarchy_id_  := Cust_Hierarchy_Struct_API.Get_Hierarchy_Id(customer_no_);
      IF (hierarchy_id_ IS NOT NULL) THEN
         prnt_cust_ := Cust_Hierarchy_Struct_API.Get_Parent_Cust(hierarchy_id_, customer_no_);
         -- Search till top parent for a valid campaign definition for the part.,
         WHILE (prnt_cust_ IS NOT NULL) LOOP
            Get_Price_Camp_For_Assort___(campaign_id_,    campaign_assort_id_,  campaign_assort_node_id_, 
                                         prnt_cust_,      contract_,            catalog_no_, 
                                         currency_code_,  price_unit_meas_,     price_effectivity_date_ );
            IF (campaign_id_ IS NOT NULL) THEN
               part_level_db_       := 'ASSORTMENT';
               part_level_id_       := campaign_assort_id_ || ' - ' || campaign_assort_node_id_;
               customer_level_db_   := 'HIERARCHY';
               customer_level_id_   := prnt_cust_;
               RAISE found_sales_price;
            ELSE
               -- prnt_cust_ for next iteration of loop
               prnt_cust_ := Cust_Hierarchy_Struct_API.Get_Parent_Cust(hierarchy_id_, prnt_cust_);
            END IF;
         END LOOP;
      END IF;
   END IF;

   --------------------------------------------------------------------------------------------------------------
   -- Priority 07: Price defined per assortment node in a campaign connected to the customer price group of the customer.
   -- Priority 08: Price defined per assortment node in a campaign connected to the customer price group of a customer in customer hierarchy.
   --------------------------------------------------------------------------------------------------------------
   cust_price_group_id_ := Cust_Ord_Customer_API.Get_Cust_Price_Group_Id(customer_no_);
   IF (cust_price_group_id_ IS NOT NULL) THEN
      Get_Pr_Grp_Camp_For_Assort___(campaign_id_,          campaign_assort_id_,  campaign_assort_node_id_, 
                                    cust_price_group_id_,  contract_,            catalog_no_, 
                                    currency_code_,        price_unit_meas_,     price_effectivity_date_ );
   END IF;
   IF (campaign_id_ IS NOT NULL) THEN
      part_level_db_       := 'ASSORTMENT';
      part_level_id_       := campaign_assort_id_ || ' - ' || campaign_assort_node_id_;
      customer_level_db_   := 'CUSTOMER_PRICE_GROUP';
      customer_level_id_   := customer_no_ || ' - ' || cust_price_group_id_;
      RAISE found_sales_price;
   ELSE
      hierarchy_id_  := Cust_Hierarchy_Struct_API.Get_Hierarchy_Id(customer_no_);
      IF (hierarchy_id_ IS NOT NULL) THEN
         prnt_cust_ := Cust_Hierarchy_Struct_API.Get_Parent_Cust(hierarchy_id_, customer_no_);

         -- Search till top parent for a valid campaign definition for the part.,
         WHILE (prnt_cust_ IS NOT NULL) LOOP
            prnt_cust_price_group_id_ := Cust_Ord_Customer_API.Get_Cust_Price_Group_Id(prnt_cust_);
            IF (prnt_cust_price_group_id_ IS NOT NULL) THEN
               Get_Pr_Grp_Camp_For_Assort___(campaign_id_,               campaign_assort_id_,  campaign_assort_node_id_, 
                                             prnt_cust_price_group_id_,  contract_,            catalog_no_, 
                                             currency_code_,             price_unit_meas_,     price_effectivity_date_ );
            END IF;
            IF (campaign_id_ IS NOT NULL) THEN
               part_level_db_       := 'ASSORTMENT';
               part_level_id_       := campaign_assort_id_ || ' - ' || campaign_assort_node_id_;
               customer_level_db_   := 'HIERARCHY_PRICE_GROUP';
               customer_level_id_   := prnt_cust_ || ' - ' || prnt_cust_price_group_id_;
               RAISE found_sales_price;
            ELSE
               -- prnt_cust_ for next iteration of loop
               prnt_cust_ := Cust_Hierarchy_Struct_API.Get_Parent_Cust(hierarchy_id_, prnt_cust_);
            END IF;
         END LOOP;
      END IF;
   END IF;
EXCEPTION
   WHEN found_sales_price THEN
      -- IF a valid campaign is found, update with price data.
      price_source_db_   := 'CAMPAIGN';
      price_source_id_   := campaign_id_;
      CASE part_level_db_
         WHEN 'PART' THEN
            rec_ := Get_Object_By_Keys___(campaign_id_);
            -- Price fetch from campaign part
            camp_parts_rec_  := Campaign_Part_API.Get(campaign_id_, rec_.reference_site, catalog_no_);
            sale_unit_price_ := camp_parts_rec_.sales_price;
            unit_price_incl_tax_ := camp_parts_rec_.sales_price_incl_tax;
            discount_type_   := camp_parts_rec_.discount_type;
            discount_        := camp_parts_rec_.sales_discount;
            net_price_       := camp_parts_rec_.net_price;
            Trace_SYS.Message('Price searched until campaign part line ...');
            Trace_SYS.Field('Price campaign : ', campaign_id_);
            Trace_SYS.Field('Price campaign sales part no : ', catalog_no_);
         WHEN 'ASSORTMENT' THEN
            -- Price fetch from campaign assortment
            campaign_price_unit_meas_ := price_unit_meas_;
            IF (Campaign_Assortment_API.Check_Exist(campaign_id_, campaign_assort_id_, campaign_assort_node_id_, price_unit_meas_) = 0) THEN
               campaign_price_unit_meas_ := '*';
            END IF;
            campaign_assort_rec_ := Campaign_Assortment_API.Get(campaign_id_, campaign_assort_id_, campaign_assort_node_id_, campaign_price_unit_meas_);
            sale_unit_price_     := campaign_assort_rec_.sales_price;
            unit_price_incl_tax_ := campaign_assort_rec_.sales_price;
            discount_type_       := campaign_assort_rec_.discount_type;
            discount_            := campaign_assort_rec_.sales_discount;
            net_price_           := campaign_assort_rec_.net_price;
            Trace_SYS.Message('Price searched until campaign assortment ....');
            Trace_SYS.Field('Price campaign ID : ', campaign_id_);
            Trace_SYS.Field('Price campaign assortment : ', campaign_assort_id_);
            Trace_SYS.Field('Price campaign assortment node : ', campaign_assort_node_id_);
      END CASE;
END Get_Campaign_Price_Info;


-- Get_Campaign_Disc_Info
--   Returns discount information from campaigns. Additional discount source
--   is fetched from sources where price is not defined.
PROCEDURE Get_Campaign_Disc_Info (
   discount_found_         OUT     NUMBER,
   discount_type_          OUT     VARCHAR2,
   assortment_id_          OUT     VARCHAR2,
   assortment_node_id_     OUT     VARCHAR2,
   customer_level_db_      OUT     VARCHAR2,
   customer_level_id_      OUT     VARCHAR2,
   campaign_id_            IN  OUT NUMBER,
   customer_no_            IN      VARCHAR2,
   contract_               IN      VARCHAR2,
   catalog_no_             IN      VARCHAR2,
   currency_code_          IN      VARCHAR2,
   price_unit_meas_        IN      VARCHAR2,
   price_effectivity_date_ IN      DATE )
IS
   rec_                       CAMPAIGN_TAB%ROWTYPE;
   camp_assort_rec_           Campaign_Assortment_API.Public_Rec;
   prnt_cust_                 cust_hierarchy_struct_tab.customer_parent%TYPE;
   hierarchy_id_              cust_hierarchy_struct_tab.hierarchy_id%TYPE;
   cust_price_group_id_       VARCHAR2(10);
   prnt_cust_price_group_id_  VARCHAR2(10);
   disc_price_unit_meas_      VARCHAR2(30);
   discount_method_db_        VARCHAR2(30);
   discount_                  NUMBER;
   discount_campaign_         NUMBER := NULL;
   found_discount             EXCEPTION;
BEGIN

   rec_ := Get_Object_By_Keys___(campaign_id_);

   discount_method_db_ := Cust_Order_Discount_Method_API.Encode(Site_Discom_Info_API.Get_Cust_Order_Discount_Method(contract_));
   ---------------------------------------------------------------------------------------------
   -- When discount defined in campaign part line for the given campaign and a part, stop the further search.
   -- (When multiple discount allowed, search for the additional discount.)
   -- Otherwise check for the given campaign has discount for assortments or other campaign assortment with discounts.
   -- Note that when finding discount from other campaigns, we can ignore the discounts on campaign parts since price is defined.
   ---------------------------------------------------------------------------------------------
   Get_Disc_On_Campaign_Part___(discount_type_, discount_, campaign_id_, rec_.reference_site, catalog_no_);
   IF (discount_ IS NOT NULL) AND (discount_method_db_ = 'SINGLE_DISCOUNT') THEN
      RAISE found_discount;
   END IF;

   -----------------------------------------------------------------------------------------------------------------------
   -- 1. Discount defined per assortment node without a price in a campaign connected to the customer.
   -- 2. Discount defined per assortment node without a price in a campaign connected to a customer in customer hierarchy.
   -----------------------------------------------------------------------------------------------------------------------
   Get_Disc_Camp_For_Assort___(discount_campaign_, assortment_id_,    assortment_node_id_, 
                               customer_no_,       contract_,         catalog_no_,  
                               currency_code_,     price_unit_meas_,  price_effectivity_date_);
   IF (discount_campaign_ IS NOT NULL) THEN
      customer_level_db_ := 'CUSTOMER';
      customer_level_id_ := customer_no_;
      RAISE found_discount;
   ELSE
      hierarchy_id_  := Cust_Hierarchy_Struct_API.Get_Hierarchy_Id(customer_no_);
      IF (hierarchy_id_ IS NOT NULL) THEN
         prnt_cust_ := Cust_Hierarchy_Struct_API.Get_Parent_Cust(hierarchy_id_, customer_no_);
         -- Loop through the hierarchy and select discount from first customer that has valid campaign.
         WHILE (prnt_cust_ IS NOT NULL) LOOP
            Get_Disc_Camp_For_Assort___(discount_campaign_,  assortment_id_,    assortment_node_id_,
                                        prnt_cust_,          contract_,         catalog_no_,
                                        currency_code_,      price_unit_meas_,  price_effectivity_date_ );
            IF (discount_campaign_ IS NOT NULL) THEN
               customer_level_db_   := 'HIERARCHY';
               customer_level_id_   := prnt_cust_;
               RAISE found_discount;
            ELSE
               -- prnt_cust_ for next iteration of loop
               prnt_cust_ := Cust_Hierarchy_Struct_API.Get_Parent_Cust(hierarchy_id_, prnt_cust_);
            END IF;
         END LOOP;
      END IF;
   END IF;

   ---------------------------------------------------------------------------------------------------------------------------------------------------
   -- 3. Discount defined per assortment node without a price in a campaign connected to the customer price group of the customer.
   -- 4. Discount defined per assortment node without a price in a campaign connected to the customer price group of a customer in customer hierarchy.
   ---------------------------------------------------------------------------------------------------------------------------------------------------
   cust_price_group_id_ := Cust_Ord_Customer_API.Get_Cust_Price_Group_Id(customer_no_);
   IF (cust_price_group_id_ IS NOT NULL) THEN
      Get_Dis_Grp_Camp_For_Assort___(discount_campaign_,    assortment_id_,    assortment_node_id_,
                                     cust_price_group_id_,  contract_,         catalog_no_,
                                     currency_code_,        price_unit_meas_,  price_effectivity_date_ );
   END IF;
   IF (discount_campaign_ IS NOT NULL) THEN
      customer_level_db_   := 'CUSTOMER_PRICE_GROUP';
      customer_level_id_   := customer_no_ || ' - ' || cust_price_group_id_;
      RAISE found_discount;
   ELSE
      hierarchy_id_  := Cust_Hierarchy_Struct_API.Get_Hierarchy_Id(customer_no_);
      IF (hierarchy_id_ IS NOT NULL) THEN
         prnt_cust_ := Cust_Hierarchy_Struct_API.Get_Parent_Cust(hierarchy_id_, customer_no_);

         -- Search till top parent for a valid campaign definition for the part.,
         WHILE (prnt_cust_ IS NOT NULL) LOOP
            prnt_cust_price_group_id_ := Cust_Ord_Customer_API.Get_Cust_Price_Group_Id(prnt_cust_);
            IF (prnt_cust_price_group_id_ IS NOT NULL) THEN
               Get_Dis_Grp_Camp_For_Assort___(discount_campaign_,         assortment_id_,    assortment_node_id_,
                                              prnt_cust_price_group_id_,  contract_,         catalog_no_,
                                              currency_code_,             price_unit_meas_,  price_effectivity_date_ );
            END IF;
            IF (discount_campaign_ IS NOT NULL) THEN
               customer_level_db_   := 'HIERARCHY_PRICE_GROUP';
               customer_level_id_   := prnt_cust_ || ' - ' || prnt_cust_price_group_id_;
               RAISE found_discount;
            ELSE
               -- prnt_cust_ for next iteration of loop
               prnt_cust_ := Cust_Hierarchy_Struct_API.Get_Parent_Cust(hierarchy_id_, prnt_cust_);
            END IF;
         END LOOP;
      END IF;
   END IF;
EXCEPTION
   WHEN found_discount THEN
      IF (discount_campaign_ IS NOT NULL) THEN
         campaign_id_          := discount_campaign_;
         disc_price_unit_meas_ := price_unit_meas_;
         IF (Campaign_Assortment_API.Check_Exist(campaign_id_, assortment_id_, assortment_node_id_, price_unit_meas_) = 0) THEN
            disc_price_unit_meas_ := '*';
         END IF;
         camp_assort_rec_ := Campaign_Assortment_API.Get(campaign_id_,
                                                         assortment_id_, 
                                                         assortment_node_id_, 
                                                         disc_price_unit_meas_);
         discount_found_  := camp_assort_rec_.sales_discount;
         discount_type_   := camp_assort_rec_.discount_type;
         Trace_SYS.Message('Discount searched until campaign assortment ....');
         Trace_SYS.Field('Discount campaign ID : ', campaign_id_);
         Trace_SYS.Field('Discount campaign assortment : ', assortment_id_);
         Trace_SYS.Field('Discount campaign assortment node : ', assortment_node_id_);
      END IF;
END Get_Campaign_Disc_Info;


@UncheckedAccess
FUNCTION Exist_Allocation_Line (
   campaign_id_ IN NUMBER ) RETURN VARCHAR2
IS
   found_  NUMBER;
   CURSOR exist_lines IS
      SELECT 1
        FROM CAMPAIGN_ALLOCATION_PLAN_TAB
       WHERE campaign_id = campaign_id_;
BEGIN
   OPEN exist_lines;
   FETCH exist_lines INTO found_;
   IF (exist_lines%NOTFOUND) THEN
      CLOSE exist_lines;
      RETURN 'FALSE';
   END IF;
   CLOSE exist_lines;
   RETURN 'TRUE';
END Exist_Allocation_Line;


@UncheckedAccess
FUNCTION Exist_Blanket_Line (
   campaign_id_ IN NUMBER ) RETURN VARCHAR2
IS
   exist_lines_  VARCHAR2(5) := 'FALSE';   
BEGIN
   $IF (Component_Purch_SYS.INSTALLED) $THEN
      exist_lines_ := Supplier_Blanket_API.Exist_Campaign_Blanket_Line(campaign_id_);      
   $END
   RETURN exist_lines_;
END Exist_Blanket_Line;


@UncheckedAccess
FUNCTION Check_Active_Camp_Per_Assort (
   assortment_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   dummy_ NUMBER;
   CURSOR exist_campaign IS
      SELECT count(*)
        FROM CAMPAIGN_TAB
       WHERE rowstate = 'Active'
         AND assortment_id = assortment_id_;
BEGIN
   OPEN exist_campaign;
   FETCH exist_campaign INTO dummy_;
   CLOSE exist_campaign;

   IF (dummy_ > 0) THEN
      dummy_ := 1;
   END IF;
   RETURN dummy_;
END Check_Active_Camp_Per_Assort;


PROCEDURE Create_Allocation (
   campaign_id_      IN NUMBER,
   supply_site_      IN VARCHAR2,
   sales_start_date_ IN DATE,
   coordinator_      IN VARCHAR2 )
IS
   sites_exist_      NUMBER;
   parts_exist_      NUMBER;
   assortment_exist_ NUMBER;   
   allocation_no_    VARCHAR2(50) := NULL;
   info_             VARCHAR2(32000);
   objid_            VARCHAR2(2000);
   objversion_       VARCHAR2(2000);
   attr_             VARCHAR2(2000);
   lines_created_    BOOLEAN := FALSE;
   no_lines_created_ EXCEPTION;
   promotions_exist_ NUMBER;

   CURSOR sites_exist IS
      SELECT 1
        FROM CAMPAIGN_SITE_TAB
       WHERE campaign_id = campaign_id_;

   CURSOR parts_exist IS
      SELECT 1
        FROM CAMPAIGN_PART_TAB
       WHERE campaign_id = campaign_id_;

   CURSOR assortment_exist IS
      SELECT 1
        FROM CAMPAIGN_ASSORTMENT_TAB
       WHERE campaign_id = campaign_id_;

   CURSOR sales_promotions_exist IS
      SELECT 1
        FROM sales_promotion_deal_tab
       WHERE campaign_id = campaign_id_;
BEGIN

   OPEN sites_exist;
   FETCH sites_exist INTO sites_exist_;
   IF (sites_exist%NOTFOUND) THEN
      sites_exist_ := 0;
   END IF;
   CLOSE sites_exist;

   OPEN parts_exist;
   FETCH parts_exist INTO parts_exist_;
   IF (parts_exist%NOTFOUND) THEN
      parts_exist_ := 0;
   END IF;
   CLOSE parts_exist;

   OPEN assortment_exist;
   FETCH assortment_exist INTO assortment_exist_;
   IF (assortment_exist%NOTFOUND) THEN
      assortment_exist_ := 0;
   END IF;
   CLOSE assortment_exist;

   OPEN sales_promotions_exist;
   FETCH sales_promotions_exist INTO promotions_exist_;
   IF (sales_promotions_exist%NOTFOUND) THEN
      promotions_exist_ := 0;
   END IF;
   CLOSE sales_promotions_exist;

   IF (supply_site_ IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'NOSUPPLYSITE: There exists no supply site defined for the campaign :P1.', campaign_id_);
   END IF;

   IF ((sites_exist_ = 0) OR (parts_exist_ = 0 AND assortment_exist_ = 0 AND promotions_exist_ = 0)) THEN
      Error_SYS.Record_General(lu_name_, 'NOTPARTORSITE: There are no parts or sites defined for the campaign.');
   END IF;

   @ApproveTransactionStatement(2012-01-24,GanNLK)
   SAVEPOINT before_header_creation;

   $IF (Component_Disord_SYS.INSTALLED) $THEN
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('SUPPLY_SITE',      supply_site_,      attr_);
      Client_SYS.Add_To_Attr('PLANNED_DUE_DATE', sales_start_date_, attr_);
      Client_SYS.Add_To_Attr('AUTHORIZE_CODE',   coordinator_,      attr_);
      Client_SYS.Add_To_Attr('CAMPAIGN_ID',      campaign_id_,      attr_);
      Distribution_Allocation_API.New(info_, attr_);      
      allocation_no_ := Client_SYS.Get_Item_Value('ALLOCATION_NO', attr_);
   $END
   IF (allocation_no_ IS NOT NULL) THEN
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('CAMPAIGN_ID', campaign_id_, attr_);
      Client_SYS.Add_To_Attr('ALLOCATION_NO', allocation_no_, attr_);
      Campaign_Allocation_Plan_API.New__(info_, objid_, objversion_, attr_, 'DO');
      Create_Camp_Alloc_Lines___(lines_created_, campaign_id_, allocation_no_);
   END IF;
   -- IF no allocation lines are created, raise an expection 
   -- so that we can rollback the creation of header.
   IF NOT (lines_created_) THEN
      RAISE no_lines_created_;
   END IF;
EXCEPTION
WHEN no_lines_created_ THEN
   @ApproveTransactionStatement(2012-01-24,GanNLK)
   ROLLBACK TO before_header_creation;
   Error_SYS.Record_General(lu_name_, 'NOALLOCLINES: Allocation lines are not available to create an allocation.');
END Create_Allocation;


PROCEDURE Insert_Discounts (
   order_no_             IN VARCHAR2,
   line_no_              IN VARCHAR2,
   rel_no_               IN VARCHAR2,
   line_item_no_         IN NUMBER,
   contract_             IN VARCHAR2,
   catalog_no_           IN VARCHAR2,
   found_                IN VARCHAR2 )
IS
   discount_found_        NUMBER;
   discount_type_         VARCHAR2(25);
   discount_source_id_    VARCHAR2(25);
   campaign_id_           NUMBER;
   assortment_id_         VARCHAR2(50):= NULL;
   assortment_node_id_    VARCHAR2(50):= NULL;

   CURSOR old_discount_line IS
      SELECT *
      FROM CUST_ORDER_LINE_DISCOUNT_TAB
      WHERE  order_no = order_no_
      AND  line_no = line_no_
      AND  rel_no  = rel_no_
      AND  line_item_no = line_item_no_;

   CURSOR get_assortment_id IS
      SELECT ant.assortment_id, assortment_node_id
      FROM  ASSORTMENT_NODE_TAB ant, ASSORTMENT_STRUCTURE_TAB ast
      WHERE ant.assortment_id = ast.assortment_id
      AND   ast.rowstate = 'Active'
      AND   part_no = catalog_no_;

   camp_part_rec_    Campaign_Part_API.Public_Rec;
   camp_assort_rec_  Campaign_Assortment_API.Public_Rec;
BEGIN
   IF (Campaign_Part_API.Check_Exist(campaign_id_, contract_, catalog_no_) = 'TRUE') THEN
      camp_part_rec_ := Campaign_Part_API.Get(campaign_id_, 
                                              contract_, 
                                              catalog_no_);
      discount_found_   := camp_part_rec_.sales_discount;
      discount_type_    := camp_part_rec_.discount_type;
   ELSE
      OPEN get_assortment_id;
      FETCH get_assortment_id INTO assortment_id_, assortment_node_id_;
      CLOSE get_assortment_id;

      camp_assort_rec_ := Campaign_Assortment_API.Get(campaign_id_, 
                                                      assortment_id_, 
                                                      assortment_node_id_, 
                                                      Customer_Order_Line_API.Get_Price_Unit_Meas(order_no_, line_no_, rel_no_, line_item_no_));
      discount_type_     := camp_assort_rec_.discount_type;
      discount_found_    := camp_assort_rec_.sales_discount;
   END IF;

   discount_source_id_   := campaign_id_;
   FOR disc_rec_ IN old_discount_line LOOP
      Cust_Order_Line_Discount_API.Remove_Discount_Row(order_no_,
                                                       line_no_,
                                                       rel_no_,
                                                       line_item_no_,
                                                       disc_rec_.discount_no);
   END LOOP;
   IF (found_ = 'Y') THEN
      Cust_Order_Line_Discount_API.New(order_no_,
                                       line_no_,
                                       rel_no_,
                                       line_item_no_,
                                       discount_type_,
                                       discount_found_,
                                       'MANUAL',
                                       'NOT PARTIAL SUM',
                                       0,
                                       discount_source_id_,
                                       null,
                                       NULL,
                                       NULL,
                                       NULL,
                                       NULL);
   END IF;
END Insert_Discounts;



