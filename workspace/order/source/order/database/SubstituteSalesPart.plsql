-----------------------------------------------------------------------------
--
--  Logical unit: SubstituteSalesPart
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  161128  ChBnlk  STRSC-4290, STRSC-4291, STRSC-4284, Added new methods Create_Substitute_Parts(), Is_Registered_Substitute_part(), Check_Priority_Exists()
--  161128          Find_Substitutable_Part() and Allow_Auto_Substitution() to suport the automatic substitution of sales parts. 
--  110712  ChJalk  Added user_allowed_site filter to the view SUBSTITUTE_SALES_PART2.
--  110131  Nekolk EANE-3744  added where clause to View SUBSTITUTE_SALES_PART.
--  100113  MaRalk  Modified SUBSTITUTE_SALES_PART - contract, catalog_no, substitute_sales_part column comments as not updatable and modified Unpack_Check_Update___.
--  060112  MiKulk  Modified the PROCEDURE Insert___ according to the new template.
--  040114  IsAnlk   Changed the code to use local cursor get_all_alternative_part instead of public cursor in Copy_Alternate_Parts__.
--  -----------------------------------Version 13.3.0 ----------------------- 
--  020924  UdGnlk Modified Unpack_Check_Insert___ warning message ALTNOTEXIST correcting the parameters order.
--  020807  SaAblk Corrected Call Id 87231.
--  020630  sijo   Added method Check_If_Alternate_Used.
--  020625  SiJono Added call to Part_Catalog_Alternative_API.Create_Alternative in
--                 method Insert___ to create valid alternate if not exist.
--                 Also added method Copy_Alternate_Parts__.
--  010528  JSAnse Bug fix 21463, added call to General_SYS.Init_Method in procedure Check_Substitute_Part_Exist.
--  001219  CaSt   Added Check_Substitute_Part_Exist.
--  000215  SaMi   Check if a sales_part/substitute_sales_part exists for a particular
--                 contract in Unpack_Check_Update
--  000215  SaMi   Added User_Allowed_Site_API.Exist() in Unpack_check_update
--  000207  SaMi   NOCHEK added to view comments for SUBSTITUTE_SALES_PART2
--  000202  SaMi   SUBSTITUTE_SALES_PART2 added for retriving both salespart and
--                 substitute_sales_part.
--  000111  SaMi   substitute_sales_part create
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('CONTRACT', User_Default_API.Get_Contract, attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT SUBSTITUTE_SALES_PART_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   super(objid_, objversion_, newrec_, attr_);
   -- create alternative in part catalog if not exist
   IF (Part_Catalog_Alternative_API.Is_The_Part_Legal(newrec_.catalog_no, newrec_.substitute_sales_part) = 'FALSE') THEN
      Part_Catalog_Alternative_API.Create_Alternative(newrec_.catalog_no, newrec_.substitute_sales_part);
   END IF;
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT substitute_sales_part_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS   
BEGIN
   super(newrec_, indrec_, attr_);   
   -- check if alternative exist in part catalog alternative, create if not
   IF (Part_Catalog_Alternative_API.Is_The_Part_Legal(newrec_.catalog_no, newrec_.substitute_sales_part) = 'FALSE') THEN
      Client_SYS.Add_Warning(lu_name_, 'ALTNOTEXIST: According to the part catalog record for :P1 this alternate part relationship does not exist. By clicking Yes you will save the line you entered and save the alternate parts information for :P2 and :P3 in Part Catalog.'
                             , newrec_.catalog_no, newrec_.catalog_no, newrec_.substitute_sales_part);
   END IF;
END Check_Insert___;

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     substitute_sales_part_tab%ROWTYPE,
   newrec_ IN OUT substitute_sales_part_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS 
BEGIN
   --Add pre-processing code here
   super(oldrec_, newrec_, indrec_, attr_);
   --Add post-processing code here
   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, newrec_.contract);
END Check_Common___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Copy_Alternate_Parts__
--   - Copy valid alternate parts from part catalog alternative.
PROCEDURE Copy_Alternate_Parts__ (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 )
IS
   
   CURSOR  get_all_alternative_part IS
      SELECT   part_no, alternative_part_no
      FROM  part_catalog_alternative_pub
      WHERE part_no = part_no_;

   attr_        VARCHAR2(2000);
   info_        VARCHAR2(2000);
   objid_       VARCHAR2(50);
   objversion_  VARCHAR2(260);
BEGIN
   -- get all valid alternative parts
   FOR rec_ IN get_all_alternative_part LOOP
      IF (Sales_Part_API.Check_Exist(contract_, rec_.alternative_part_no) = 1) THEN
         IF (NOT Check_Exist___(contract_, part_no_, rec_.alternative_part_no)) THEN
            Client_SYS.Clear_Attr(attr_);
            --
            Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_);
            Client_SYS.Add_To_Attr('CATALOG_NO', part_no_, attr_);
            Client_SYS.Add_To_Attr('SUBSTITUTE_SALES_PART', rec_.alternative_part_no, attr_);
            --
            New__(info_, objid_, objversion_, attr_, 'DO');
         END IF;
      END IF;
   END LOOP;
END Copy_Alternate_Parts__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

FUNCTION Check_Substitute_Part_Exist (
   contract_              IN VARCHAR2,
   catalog_no_            IN VARCHAR2,
   substitute_sales_part_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   SUBSTITUTE_SALES_PART_TAB
      WHERE contract = contract_
      AND   catalog_no = catalog_no_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN(TRUE);
   END IF;
   CLOSE exist_control;
   RETURN(FALSE);
END Check_Substitute_Part_Exist;


-- Check_If_Alternate_Used
--   - Check if given part is used as alternative
PROCEDURE Check_If_Alternate_Used (
   catalog_no_            IN VARCHAR2,
   substitute_sales_part_ IN VARCHAR2 )
IS
   dummy_ NUMBER;
   CURSOR c_alternate IS
      SELECT 1
      FROM SUBSTITUTE_SALES_PART_TAB
      WHERE catalog_no = catalog_no_
      AND   substitute_sales_part = substitute_sales_part_;
BEGIN
   --
   OPEN c_alternate;
   FETCH c_alternate INTO dummy_;
   IF (c_alternate%FOUND) THEN
      CLOSE c_alternate;
      Error_SYS.Record_General(lu_name_, 'ALTPARTEXIST: Alternate part (:P1) is used in Substitute Sales Part.', substitute_sales_part_);
   END IF;
   CLOSE c_alternate;
END Check_If_Alternate_Used;


-- Create_Substitute_Parts
-- Creates substitute sales parts for a perticular sales part.
PROCEDURE Create_Substitute_Parts (
   registered_          OUT    NUMBER,
   contract_            IN     VARCHAR2,
   site_cluster_        IN     VARCHAR2,
   site_cluster_node_   IN     VARCHAR2,
   attr_                IN     VARCHAR2 )
IS
   newrec_            substitute_sales_part_tab%ROWTYPE;
   ptr_               NUMBER := NULL;
   name_              VARCHAR2(30);
   value_             VARCHAR2(2000);
   site_tab_          Site_Cluster_Node_API.site_table;
BEGIN
   registered_ := 0;
   IF (contract_ IS NOT NULL) THEN
     site_tab_(1).contract := contract_;   
   ELSIF ((site_cluster_ IS NOT NULL) AND (site_cluster_node_ IS NOT NULL)) THEN
       site_tab_ := Site_Cluster_Node_API.Get_Connected_Sites(site_cluster_, site_cluster_node_);     
   END IF;
   
   IF site_tab_.COUNT >0 THEN
      FOR i IN site_tab_.FIRST..site_tab_.LAST LOOP
         newrec_.contract := site_tab_(i).contract;
         ptr_ := NULL;
         WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP       
            IF (name_ = 'CATALOG_NO')THEN
               newrec_.catalog_no := value_;
            ELSIF (name_  = 'SUBSTITUTE_SALES_PART') THEN
               newrec_.substitute_sales_part := value_;
            ELSIF (name_ = 'END_OF_LINE') THEN 
               IF NOT Is_Registered_Substitute_part(contract_, newrec_.catalog_no, newrec_.substitute_sales_part) THEN
                  BEGIN
                     New___(newrec_);                  
                     registered_ := registered_ + 1;
                  EXCEPTION 
                     WHEN OTHERS THEN
                        NULL;
                  END;
               END IF; 
            END IF;     
         END LOOP;
      END LOOP;
   END IF;
       
END Create_Substitute_Parts;


-- Is_Registered_Substitute_part
-- Checks whether a perticulart part is registered
-- as a substitute sales part under the given sales part.
FUNCTION Is_Registered_Substitute_part (
   contract_              IN VARCHAR2,
   catalog_no_            IN VARCHAR2,
   substitute_sales_part_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   SUBSTITUTE_SALES_PART_TAB
      WHERE contract = contract_
      AND   catalog_no = catalog_no_
      AND   substitute_sales_part = substitute_sales_part_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN(TRUE);
   END IF;
   CLOSE exist_control;
   RETURN(FALSE);
END Is_Registered_Substitute_part;


-- Check_Priority_Exists
-- Checks whether the given priority number already
-- exists for another substitute sales part
-- under the same original sales part.
FUNCTION Check_Priority_Exists (
   contract_               IN VARCHAR2,
   catalog_no_             IN VARCHAR2,   
   priority_               IN NUMBER ) RETURN NUMBER
IS
   dummy_  NUMBER ;
   
   CURSOR exist_priority IS
   SELECT 1 
   FROM SUBSTITUTE_SALES_PART_TAB
   WHERE contract =  contract_
   AND catalog_no = catalog_no_
   AND priority = priority_;
   
BEGIN
	OPEN exist_priority;
   FETCH exist_priority INTO dummy_;
   IF (exist_priority%FOUND) THEN
      CLOSE exist_priority;
      RETURN 1;
   END IF;
   CLOSE exist_priority;
	RETURN 0;
END Check_Priority_Exists;


-- Find_Substitutable_Part
-- Finding the best suitable part that can be used to 
-- substitute a sales part automatically.
FUNCTION Find_Substitutable_Part (
   contract_         IN  VARCHAR2,
   catalog_no_       IN  VARCHAR2,
   order_no_         IN  VARCHAR2,
   line_no_          IN  VARCHAR2,
   rel_no_           IN  VARCHAR2,
   line_item_no_     IN  VARCHAR2,
   customer_no_      IN  VARCHAR2,   
   qty_to_assign_    IN  NUMBER,   
   supply_code_db_   IN  VARCHAR2,
   picking_leadtime_ IN  NUMBER,
   part_ownership_   IN  VARCHAR2) RETURN VARCHAR2
IS  
   TYPE catalog_no_table IS TABLE OF VARCHAR2(25) INDEX BY BINARY_INTEGER;
   
   catalog_no_list_    catalog_no_table;
   substitutable_part_  VARCHAR2(25) := NULL;
   i_ NUMBER  := 1;
   
   CURSOR get_substitute_parts IS
   SELECT substitute_sales_part
   FROM SUBSTITUTE_SALES_PART_TAB
   WHERE contract =  contract_
   AND catalog_no = catalog_no_
   AND priority IS NOT NULL
   ORDER BY priority;
   
   CURSOR get_sub_part_with_no_Priority IS
   SELECT substitute_sales_part
   FROM SUBSTITUTE_SALES_PART_TAB
   WHERE contract =  contract_
   AND catalog_no = catalog_no_
   AND priority IS NULL;
   
BEGIN
   
   catalog_no_list_(0) := catalog_no_;
   
   FOR rec_ IN get_substitute_parts LOOP
      catalog_no_list_(i_) := rec_.substitute_sales_part;
      i_ := i_+1;      
   END LOOP;
   
   OPEN get_sub_part_with_no_Priority;
   FETCH get_sub_part_with_no_Priority INTO catalog_no_list_(i_) ;
   CLOSE get_sub_part_with_no_Priority;
      
   substitutable_part_ := catalog_no_;
   
   FOR j_ IN catalog_no_list_.FIRST..catalog_no_list_.LAST LOOP      
      IF ((Inventory_Part_API.Get_Onhand_Analysis_Flag_Db(contract_, catalog_no_list_(j_)) = 'Y') OR 
                                                Inventory_Part_API.Get_Oe_Alloc_Assign_Flag_Db(contract_, catalog_no_list_(j_)) = 'Y') THEN
         IF (Reserve_Customer_Order_API.Check_Available_To_Reserve(qty_to_assign_, contract_, catalog_no_list_(j_), order_no_, line_no_, rel_no_, line_item_no_,
                                                                  customer_no_, supply_code_db_, picking_leadtime_, part_ownership_)) THEN
         
            substitutable_part_ := catalog_no_list_(j_);
            EXIT;         
         END IF;
      ELSE         
         EXIT;
      END IF;   
   END LOOP;   
   RETURN substitutable_part_;   
	
END Find_Substitutable_Part;


-- Allow_Auto_Substitution
-- Checks the flags in the Site and Customer
-- that enable the automatic substitution of
-- a sales part.
FUNCTION Allow_Auto_Substitution (
   contract_      IN  VARCHAR2,
   customer_no_   IN  VARCHAR2) RETURN BOOLEAN
IS
BEGIN
	IF ((Site_Discom_Info_API.Get_Allow_Auto_Sub_Of_Parts_Db(contract_) = 'TRUE') AND 
                                         (Cust_Ord_Customer_API.Get_Allow_Auto_Sub_Of_Parts_Db(customer_no_) = 'TRUE'))THEN
      RETURN TRUE;
   ELSE
      RETURN FALSE;
   END IF;	
END Allow_Auto_Substitution;

