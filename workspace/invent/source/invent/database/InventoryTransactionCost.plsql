-----------------------------------------------------------------------------
--
--  Logical unit: InventoryTransactionCost
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  211101  ChJalk  SC21R2-5478, Reverted the modifications done under SCZ-15524.
--  210714  ChJalk  SCZ-15524, Modified Set_Delivery_Oh_Unit_Costs___ to accumulate the unit costs relevant to all the transactions
--  210714          for a receipt when calculating level unit cost.
--  201103  LEPESE  SCZ-12186, Redesigned Get_Level_Unit_Cost___ into Set_Delivery_Oh_Unit_Costs___ in order to facilitate a special handling for 
--  201103          transaction codes 'PODIRSH', 'PODIRINTEM', 'PURDIR', 'RETPODIRSH' where the disabling of the delivery overhead flag should lead to
--  201103          that the delivery overhead level unit cost should not be included at all on the transaction. No cost detail and no postings.
--  190519  Asawlk  Bug 145058, Modified Create_Or_Modify_Details() by restricting the creation of a new cost detail with zero unit cost 
--  190519          upon running the cascade postings.
--  130802  ChJalk  TIBE-886, Removed the global variables inst_CostBucket_ and inst_CostInt_.
--  120918  IRJALK  Bug 104826, Modified Get_Cost_Bucket_Group_And_Type() to get the values of temp_bucket_posting_group_id_,
--  120918          temp_cost_bucket_public_type_ from the method Standard_Cost_Bucket_API.Get_Postng_Grp_Id_And_Pub_Type().
--  110715  MaEelk  Added user allowed site filter to INVENTORY_TRANSACTION_COST.
--  110525  PraWlk  Bug 95365, Modified Create_Or_Modify_Details() by assigning a value to new_accounting_year
--  110525          only if a unique cost bucket is found, otherwise the accounting year from new_cost_detail_tab_
--  110525          is used. Modified Get_Account_Year_Not_Star___() by adding parameter cost_bucket_id_.
--  110525  NiBalk  Bug 93731, Modified procedure Create_Or_Modify_Details by assigning a value to
--  110525          new_cost_source_id_ only if a unique cost bucket is found, otherwise the cost source
--  110525          from new_cost_detail_tab_ is used. Added function Cost_Bucket_Unique___. Modified
--  110525          Get_Cost_Source_For_Bucket___ to return NULL when more than one cost source ID is found.
--  100507  KRPELK  Merge Rose Method Documentation.
--  090930  ChFolk  Removed unused variables in the package.
--  ------------------------------- 14.0.0 ----------------------------------
--  090316  PraWlk  Bug 81108, Modified Get_Transaction_Cost_Details to merge cost details having the same keys.
--  090305  SaWjlk  Bug 80199, Added default parameters include_added_details_ and include_normal_details_ 
--  090305          in the Get_Sum_Unit_Cost function.  
--  090305          Removed the cursor get_sum_unit_cost fetched the value from Inventory_Part_Unit_Cost_API.Get_Total_Unit_Cost  
--  080919  MaEelk  Bug 76467, Added default FALSE parameter replace_star_cost_bucket_
--  080919          to decide if the * value of cost bucket id should be replaced with 110 or not.
--  080508  MaEelk  Bug 73667, Increased the length of stmt_ to 2000 in Get_Cost_Bucket_Group_And_Type.
--  080508          Added variables temp_bucket_posting_group_id_ and temp_cost_bucket_public_type_ and used them
--  080508          as out parameters in execute immediate statement.  
--  080123  LEPESE  Bug 68763, added parameters purch_order_ref1_, purch_order_ref2_,
--  080123          purch_order_ref3_ and purch_order_ref4_ to methods New, Modify_Unit_Cost,
--  080123          Create_Or_Modify_Details, Get_Level_Unit_Cost___, Insert___, Update___ and
--  080123          Set_Unit_Cost_To_Zero___. Major redesign of Get_Level_Unit_Cost___ in order to
--  080123          support delivery overhead level_unit_cost for all valuation methods and cost
--  080123          levels. Added call to Inventory_Transaction_Hist_API.Get_Purch_Comp_Consume_Trans.
--  070820  ErSrLK  Bug 65666, Added parameters transaction_code_, part_no_, configuration_id_,
--  070820          quantity_, valuation_method_db_ and part_cost_level_db_ to methods New,
--  070820          Create_Or_Modify_Details, Modify_Unit_Cost and Set_Unit_Cost_To_Zero___.
--  070820          Added new attribute level_unit_cost. Added method Get_Level_Unit_Cost___.
--  070820          Added calls to Get_Level_Unit_Cost___ from Insert___ and Update___.
--  070820          Blocked methods New__ and Modify__ from usage since methods Insert___ and
--  070820          Update___ needs more parameters than New__ and Modify__ can provide.
--  070820          Modifications in method Create_Or_Modify_Details to call methods New,
--  070820          Modify_Unit_Cost and Set_Unit_Cost_To_Zero___ with these new parameters.
--  070820          Modifications in method Set_Unit_Cost_To_Zero___ to call method Update___
--  070820          with these new parameters. Modifications in method New to call Insert___
--  070820          with these new parameters. Modificaitons in method Modify_Unit_Cost to call
--  070820          method Update__ with these new parameters. 
--  070820          The purpose with all these changes is that we need to call Costing whenever
--  070820          a cost record with cost_bucket_public_type = DELOH is stored for a transaction
--  070820          having delivery_overhead_flag = 'Y'. We need Costing to tell us the level_unit_cost
--  070820          for the delivery overhead bucket. The return value is stored in level_unit_cost.
--  070820          this is used in method Inventory_Transaction_Hist_API.Do_Booking to make DELOH
--  070820          postings only for the level_unit_cost. The difference between level_unit_cost
--  070820          and unit_cost is posted on the base event of the transaction.
--  060207  LEPESE  Added parameters include_added_details_ and include_normal_details_ to
--  060207          method Get_Transaction_Cost_Details.
--  060123  NiDalk  Added Assert safe annotation. 
--  060105  LEPESE  Removed call to General_SYS.Init_Method from Get_Transaction_Cost_Details.
--  051213  LEPESE  Added parameter retain_acc_year_cost_source_ to method Create_Or_Modify_Details.
--  051128  LEPESE  Added parameter include_all_details_ to method Get_Transaction_Cost_Details.
--  051116  JoEd    Changed prompts for accounting_year and bucket_posting_group_id.
--  051028  LEPESE  Added methods Modify_Unit_Cost and Create_Or_Modify_Details.
--  051026  LEPESE  Added method Get_Accounting_Year.
--  051017  LEPESE  Added method Get_Transaction_Value_Details.
--  051014  LEPESE  Moved dynamic code from Insert___ into new public method 
--  051014          Get_Cost_Bucket_Group_And_Type.
--  051005  JoAnSe  Corrected dynamic call in Insert___.
--  051003  LEPESE  Added NVL function for return value in Get_Sum_Unit_Cost.
--  050919  LEPESE  Added new key column ADDED_TO_THIS_TRANSACTION.
--  050913  LEPESE  Added function Get_Cost_Minus_Deliv_Overhead.
--  050906  LEPESE  Changed column order of cursor in method Get_Transaction_Cost_Details.
--  050902  LEPESE  Extended length of stmt_ string in method Insert___.
--  050901  LEPESE  Added attribute cost_bucket_public_type.
--  050721  LEPESE  Added methods Get_Transaction_Cost_Details and Get_Sum_Unit_Cost.
--  050513  JoAnSe  Create
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

char_null_ CONSTANT VARCHAR2(12) := 'VARCHAR2NULL';


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


PROCEDURE Set_Delivery_Oh_Unit_Costs___ (
   newrec_              IN OUT INVENTORY_TRANSACTION_COST_TAB%ROWTYPE,
   valuation_method_db_ IN     VARCHAR2,
   part_cost_level_db_  IN     VARCHAR2,
   transaction_code_    IN     VARCHAR2,
   part_no_             IN     VARCHAR2,
   configuration_id_    IN     VARCHAR2,
   quantity_            IN     NUMBER,
   purch_order_ref1_    IN     VARCHAR2,
   purch_order_ref2_    IN     VARCHAR2,
   purch_order_ref3_    IN     VARCHAR2,
   purch_order_ref4_    IN     NUMBER )
IS
   level_unit_cost_           NUMBER;
   delivery_overhead_flag_db_ VARCHAR2(1);
   comp_cons_trans_id_        INVENTORY_TRANSACTION_COST_TAB.transaction_id%TYPE;
   purch_cons_consume_rec_    INVENTORY_TRANSACTION_COST_TAB%ROWTYPE;   
BEGIN
   newrec_.level_unit_cost := NULL;
   
   $IF Component_Cost_SYS.INSTALLED $THEN   
      IF (NVL(newrec_.cost_bucket_public_type, char_null_) = 'DELOH') THEN

         delivery_overhead_flag_db_ := Accounting_Event_API.Get_Delivery_Overhead_Flag_Db(
                                                                             transaction_code_);
         IF ((delivery_overhead_flag_db_ = 'Y') OR (transaction_code_ IN ('PODIRSH', 'PODIRINTEM', 'PURDIR', 'RETPODIRSH'))) THEN
            -- For the specifically mentioned transaction codes we need to fetch the level_unit_cost even though the overhead flag is 'N' because
            -- we need to know whether the unit_cost refers to the level itself or is a contribution from components.

            IF ((valuation_method_db_ = 'ST') AND (part_cost_level_db_ IN ('COST PER PART', 'COST PER CONFIGURATION'))) THEN
               newrec_.level_unit_cost := Cost_Int_API.Get_Delivery_Oh_Cost(newrec_.contract,
                                                                            part_no_,
                                                                            configuration_id_,
                                                                            newrec_.cost_bucket_id,
                                                                            quantity_,
                                                                            part_cost_level_db_);
               newrec_.level_unit_cost := LEAST(newrec_.unit_cost, newrec_.level_unit_cost);
            ELSE
               -- All other combinations of Valuation Method and Part Cost Level
               comp_cons_trans_id_ := Inventory_Transaction_Hist_API.Get_Purch_Comp_Consume_Trans(
                                                                                     purch_order_ref1_,
                                                                                     purch_order_ref2_,
                                                                                     purch_order_ref3_,
                                                                                     purch_order_ref4_);
                                                                                                                                                                                         
               purch_cons_consume_rec_ := Get_Object_By_Keys___(comp_cons_trans_id_,
                                                                newrec_.contract,
                                                                newrec_.cost_bucket_id,
                                                                newrec_.company,
                                                                newrec_.cost_source_id,
                                                                newrec_.accounting_year,
                                                                newrec_.added_to_this_transaction);

               level_unit_cost_ := newrec_.unit_cost - NVL(purch_cons_consume_rec_.unit_cost,0);
               IF (newrec_.level_unit_cost < 0) THEN
                  newrec_.level_unit_cost := 0;
               END IF;
            END IF;
            IF (delivery_overhead_flag_db_ = 'N') THEN
               -- The delivery overhead unit cost added to this level is not supposed to be posted at all (special handling for the direct
               -- delivery to external customer situation). So we reduce the unit cost with the level unit cost and set the level unit cost to zero.
               newrec_.unit_cost       := newrec_.unit_cost - newrec_.level_unit_cost;
               newrec_.level_unit_cost := 0;
            END IF;
         END IF;
      END IF;
   $END
END Set_Delivery_Oh_Unit_Costs___;


FUNCTION Get_Account_Year_Not_Star___ (
   transaction_id_               IN NUMBER,
   cost_bucket_id_               IN VARCHAR2,
   added_to_this_transaction_db_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   accounting_year_ INVENTORY_TRANSACTION_COST_TAB.accounting_year%TYPE;
   bucket_counter_ NUMBER := 0;

   CURSOR get_accounting_year IS
      SELECT accounting_year
        FROM INVENTORY_TRANSACTION_COST_TAB
       WHERE transaction_id            = transaction_id_
         AND cost_bucket_id            = cost_bucket_id_
         AND added_to_this_transaction = added_to_this_transaction_db_
         AND accounting_year          != '*';
BEGIN
   FOR rec_ IN get_accounting_year LOOP
      accounting_year_ := rec_.accounting_year;
      bucket_counter_  := bucket_counter_ + 1;
   END LOOP;
   IF (bucket_counter_ > 1) THEN
      -- Cannot find one unique accounting year for a cost bucket.
      accounting_year_ := NULL;
   END IF;

   RETURN (accounting_year_);
END Get_Account_Year_Not_Star___;


@Override
PROCEDURE Insert___ (
   objid_                  OUT VARCHAR2,
   objversion_             OUT VARCHAR2,
   newrec_              IN OUT INVENTORY_TRANSACTION_COST_TAB%ROWTYPE,
   attr_                IN OUT VARCHAR2,
   transaction_code_    IN     VARCHAR2 DEFAULT NULL,
   part_no_             IN     VARCHAR2 DEFAULT NULL,
   configuration_id_    IN     VARCHAR2 DEFAULT NULL,
   quantity_            IN     NUMBER   DEFAULT NULL,
   valuation_method_db_ IN     VARCHAR2 DEFAULT NULL,
   part_cost_level_db_  IN     VARCHAR2 DEFAULT NULL,
   purch_order_ref1_    IN     VARCHAR2 DEFAULT NULL,
   purch_order_ref2_    IN     VARCHAR2 DEFAULT NULL,
   purch_order_ref3_    IN     VARCHAR2 DEFAULT NULL,
   purch_order_ref4_    IN     NUMBER   DEFAULT NULL )
IS
BEGIN
   Get_Cost_Bucket_Group_And_Type(newrec_.bucket_posting_group_id,
                                  newrec_.cost_bucket_public_type,
                                  newrec_.contract,
                                  newrec_.cost_bucket_id,
                                  part_no_);
   
   Set_Delivery_Oh_Unit_Costs___(newrec_,
                                 valuation_method_db_,
                                 part_cost_level_db_,
                                 transaction_code_,
                                 part_no_,
                                 configuration_id_,
                                 quantity_,
                                 purch_order_ref1_,
                                 purch_order_ref2_,
                                 purch_order_ref3_,
                                 purch_order_ref4_);

   IF ((NVL(newrec_.unit_cost      , 0) != 0) OR
       (NVL(newrec_.level_unit_cost, 0) != 0)) THEN
      -- The adjustments of delivery overhead unit costs done in Set_Delivery_Oh_Unit_Costs___ can lead to a situation where
      -- nothing needs to be posted. In that case there is no need for the cost detail record to be stored.
      super(objid_, objversion_, newrec_, attr_);
   END IF;

END Insert___;


@Override
PROCEDURE Update___ (
   objid_               IN     VARCHAR2,
   oldrec_              IN     INVENTORY_TRANSACTION_COST_TAB%ROWTYPE,
   newrec_              IN OUT INVENTORY_TRANSACTION_COST_TAB%ROWTYPE,
   attr_                IN OUT VARCHAR2,
   objversion_          IN OUT VARCHAR2,
   by_keys_             IN     BOOLEAN  DEFAULT FALSE,
   transaction_code_    IN     VARCHAR2 DEFAULT NULL,
   part_no_             IN     VARCHAR2 DEFAULT NULL,
   configuration_id_    IN     VARCHAR2 DEFAULT NULL,
   quantity_            IN     NUMBER   DEFAULT NULL,
   valuation_method_db_ IN     VARCHAR2 DEFAULT NULL,
   part_cost_level_db_  IN     VARCHAR2 DEFAULT NULL,
   purch_order_ref1_    IN     VARCHAR2 DEFAULT NULL,
   purch_order_ref2_    IN     VARCHAR2 DEFAULT NULL,
   purch_order_ref3_    IN     VARCHAR2 DEFAULT NULL,
   purch_order_ref4_    IN     NUMBER   DEFAULT NULL )
IS
BEGIN
   Set_Delivery_Oh_Unit_Costs___(newrec_,
                                 valuation_method_db_,
                                 part_cost_level_db_,
                                 transaction_code_,
                                 part_no_,
                                 configuration_id_,
                                 quantity_,
                                 purch_order_ref1_,
                                 purch_order_ref2_,
                                 purch_order_ref3_,
                                 purch_order_ref4_);

   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
END Update___;


PROCEDURE Set_Unit_Cost_To_Zero___ (
   transaction_id_               IN NUMBER,
   added_to_this_transaction_db_ IN VARCHAR2,
   transaction_code_             IN VARCHAR2,
   part_no_                      IN VARCHAR2,
   configuration_id_             IN VARCHAR2,
   quantity_                     IN NUMBER,
   valuation_method_db_          IN VARCHAR2,
   part_cost_level_db_           IN VARCHAR2,
   purch_order_ref1_             IN VARCHAR2,
   purch_order_ref2_             IN VARCHAR2,
   purch_order_ref3_             IN VARCHAR2,
   purch_order_ref4_             IN NUMBER )
IS
   newrec_     INVENTORY_TRANSACTION_COST_TAB%ROWTYPE;
   attr_       VARCHAR2(2000);
   objid_      INVENTORY_TRANSACTION_COST.objid%TYPE;
   objversion_ INVENTORY_TRANSACTION_COST.objversion%TYPE;
   indrec_     Indicator_Rec;

   CURSOR get_cost_details IS
      SELECT *
        FROM INVENTORY_TRANSACTION_COST_TAB
       WHERE transaction_id = transaction_id_
         AND added_to_this_transaction = added_to_this_transaction_db_
         FOR UPDATE;
BEGIN

   FOR oldrec_ IN get_cost_details LOOP
      newrec_ := oldrec_;
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('UNIT_COST', 0, attr_);
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);      
      Update___(objid_,
                oldrec_,
                newrec_,
                attr_,
                objversion_,
                TRUE,
                transaction_code_,
                part_no_,
                configuration_id_,
                quantity_,
                valuation_method_db_,
                part_cost_level_db_,
                purch_order_ref1_,
                purch_order_ref2_,
                purch_order_ref3_,
                purch_order_ref4_);
   END LOOP;

END Set_Unit_Cost_To_Zero___;


FUNCTION Get_Cost_Source_For_Bucket___ (
   transaction_id_               IN NUMBER,
   cost_bucket_id_               IN VARCHAR2,
   added_to_this_transaction_db_ IN VARCHAR2) RETURN VARCHAR2
IS
   cost_source_id_ INVENTORY_TRANSACTION_COST_TAB.cost_source_id%TYPE;
   bucket_counter_ NUMBER := 0;

   CURSOR get_cost_source_id IS
      SELECT cost_source_id
       FROM INVENTORY_TRANSACTION_COST_TAB
      WHERE transaction_id            = transaction_id_
        AND cost_bucket_id            = cost_bucket_id_
        AND added_to_this_transaction = added_to_this_transaction_db_;
BEGIN
   FOR rec_ IN get_cost_source_id LOOP
      cost_source_id_ := rec_.cost_source_id;
      bucket_counter_ := bucket_counter_ + 1;
   END LOOP;

   IF (bucket_counter_ > 1) THEN
      -- Cannot find one unique cost source ID for a cost bucket.
      cost_source_id_ := NULL;
   END IF;

   RETURN (cost_source_id_);
END Get_Cost_Source_For_Bucket___;


FUNCTION Cost_Bucket_Unique___ (
   cost_bucket_id_  IN VARCHAR2,
   cost_detail_tab_ IN Inventory_Part_Unit_Cost_API.Cost_Detail_Tab ) RETURN BOOLEAN
IS
   cost_bucket_unique_ BOOLEAN := TRUE;
   bucket_counter_     NUMBER  := 0;
BEGIN

   IF (cost_detail_tab_.COUNT > 0) THEN
      FOR i IN cost_detail_tab_.FIRST..cost_detail_tab_.LAST LOOP
         IF (cost_detail_tab_(i).cost_bucket_id = cost_bucket_id_) THEN
            bucket_counter_ := bucket_counter_ + 1;
         END IF;
      END LOOP;
   END IF;

   IF (bucket_counter_ > 1) THEN
      cost_bucket_unique_ := FALSE;
   END IF;

   RETURN (cost_bucket_unique_);
END Cost_Bucket_Unique___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- New
--   This method inserts one new transaction cost detail into the database.
PROCEDURE New (
   transaction_id_               IN NUMBER,
   contract_                     IN VARCHAR2,
   cost_bucket_id_               IN VARCHAR2,
   company_                      IN VARCHAR2,
   cost_source_id_               IN VARCHAR2,
   accounting_year_              IN VARCHAR2,
   added_to_this_transaction_db_ IN VARCHAR2,
   unit_cost_                    IN NUMBER,
   transaction_code_             IN VARCHAR2,
   part_no_                      IN VARCHAR2,
   configuration_id_             IN VARCHAR2,
   quantity_                     IN NUMBER,
   valuation_method_db_          IN VARCHAR2,
   part_cost_level_db_           IN VARCHAR2,
   purch_order_ref1_             IN VARCHAR2,
   purch_order_ref2_             IN VARCHAR2,
   purch_order_ref3_             IN VARCHAR2,
   purch_order_ref4_             IN NUMBER )
IS
   newrec_       INVENTORY_TRANSACTION_COST_TAB%ROWTYPE;
   objid_        INVENTORY_TRANSACTION_COST.objid%TYPE;
   objversion_   INVENTORY_TRANSACTION_COST.objversion%TYPE;
   attr_         VARCHAR2(32000);
   indrec_       Indicator_Rec;
BEGIN
   Client_SYS.Add_To_Attr('TRANSACTION_ID',               transaction_id_,               attr_);
   Client_SYS.Add_To_Attr('CONTRACT',                     contract_,                     attr_);
   Client_SYS.Add_To_Attr('COST_BUCKET_ID',               cost_bucket_id_,               attr_);
   Client_SYS.Add_To_Attr('COMPANY',                      company_,                      attr_);
   Client_SYS.Add_To_Attr('COST_SOURCE_ID',               cost_source_id_,               attr_);
   Client_SYS.Add_To_Attr('ACCOUNTING_YEAR',              accounting_year_,              attr_);
   Client_SYS.Add_To_Attr('ADDED_TO_THIS_TRANSACTION_DB', added_to_this_transaction_db_, attr_);
   Client_SYS.Add_To_Attr('UNIT_COST',                    unit_cost_,                    attr_);

   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);      
   Insert___(objid_,
             objversion_,
             newrec_,
             attr_,
             transaction_code_,
             part_no_,
             configuration_id_,
             quantity_,
             valuation_method_db_,
             part_cost_level_db_,
             purch_order_ref1_,
             purch_order_ref2_,
             purch_order_ref3_,
             purch_order_ref4_);
END New;


-- Get_Sum_Unit_Cost
--   Returns the sum of unit cost for all transaction cost details of a
--   specific transaction id.
@UncheckedAccess
FUNCTION Get_Sum_Unit_Cost (
   transaction_id_         IN NUMBER, 
   include_added_details_  IN VARCHAR2 DEFAULT 'FALSE',
   include_normal_details_ IN VARCHAR2 DEFAULT 'TRUE' ) RETURN NUMBER
IS
   sum_unit_cost_               NUMBER;
   include_added_details_bool_  BOOLEAN := FALSE;
   include_normal_details_bool_ BOOLEAN := FALSE;
   cost_detail_tab_             Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
BEGIN

   IF (include_added_details_ = 'TRUE') THEN
      include_added_details_bool_ := TRUE;
   END IF; 

   IF (include_normal_details_= 'TRUE') THEN
      include_normal_details_bool_ := TRUE;
   END IF; 

   cost_detail_tab_ := Get_Transaction_Cost_Details(transaction_id_, 
                                                    include_added_details_bool_, 
                                                    include_normal_details_bool_);
   sum_unit_cost_   := Inventory_Part_Unit_Cost_API.Get_Total_Unit_Cost(cost_detail_tab_);
   RETURN sum_unit_cost_;

END Get_Sum_Unit_Cost;


-- Get_Transaction_Cost_Details
--   Returns the cost detail tab for a specific transaction id.
@UncheckedAccess
FUNCTION Get_Transaction_Cost_Details (
   transaction_id_           IN NUMBER,
   include_added_details_    IN BOOLEAN DEFAULT FALSE,
   include_normal_details_   IN BOOLEAN DEFAULT TRUE,
   replace_star_cost_bucket_ IN BOOLEAN DEFAULT FALSE ) 
                                                 RETURN Inventory_Part_Unit_Cost_API.Cost_Detail_Tab
IS
   cost_detail_tab_             Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   include_added_details_char_  VARCHAR2(5);
   include_normal_details_char_ VARCHAR2(5);

   CURSOR get_cost_details IS
      SELECT accounting_year,
             contract,
             cost_bucket_id,
             company,
             cost_source_id,
             unit_cost
      FROM INVENTORY_TRANSACTION_COST_TAB
      WHERE  transaction_id = transaction_id_
      AND ((added_to_this_transaction = 'TRUE'  AND include_added_details_char_  = 'TRUE') OR
           (added_to_this_transaction = 'FALSE' AND include_normal_details_char_ = 'TRUE'));
BEGIN

   IF (include_added_details_) THEN
      include_added_details_char_ := 'TRUE';
   ELSE
      include_added_details_char_ := 'FALSE';
   END IF;
   IF (include_normal_details_) THEN
      include_normal_details_char_ := 'TRUE';
   ELSE
      include_normal_details_char_ := 'FALSE';
   END IF;

   OPEN  get_cost_details;
   FETCH get_cost_details BULK COLLECT INTO cost_detail_tab_;
   CLOSE get_cost_details;
   
   $IF Component_Cost_SYS.INSTALLED $THEN
      IF ((replace_star_cost_bucket_) AND (cost_detail_tab_.COUNT > 0)) THEN
         FOR i IN cost_detail_tab_.FIRST..cost_detail_tab_.LAST  LOOP
            IF (cost_detail_tab_(i).cost_bucket_id = '*') THEN
               cost_detail_tab_(i).cost_bucket_id := '110';
            END IF;
         END LOOP;
         cost_detail_tab_ := Inventory_Part_Unit_Cost_API.Merge_Cost_Details(cost_detail_tab_);
      END IF;
   $END
   RETURN (cost_detail_tab_);

END Get_Transaction_Cost_Details;


-- Get_Transaction_Value_Details
--   Returns the value detail tab for a specific transaction id.
--   The values are calculated from the unit costs on the details multiplied
--   with the quantiy on the transaction itself.
FUNCTION Get_Transaction_Value_Details (
   transaction_id_ IN NUMBER,
   quantity_       IN NUMBER ) RETURN Mpccom_Accounting_API.Value_Detail_Tab
IS
   value_detail_tab_ Mpccom_Accounting_API.Value_Detail_Tab;

   CURSOR get_transaction_value_details IS
      SELECT    NVL(bucket_posting_group_id,'*') bucket_posting_group,
                cost_source_id,
                SUM(unit_cost * quantity_) value
        FROM    INVENTORY_TRANSACTION_COST_TAB
       WHERE    transaction_id = transaction_id_
         AND    added_to_this_transaction = 'FALSE'
       GROUP BY NVL(bucket_posting_group_id,'*'),
                cost_source_id;
BEGIN
    OPEN  get_transaction_value_details;
    FETCH get_transaction_value_details BULK COLLECT INTO value_detail_tab_;
    CLOSE get_transaction_value_details;

    RETURN (value_detail_tab_);

END Get_Transaction_Value_Details;


-- Get_Cost_Minus_Deliv_Overhead
--   Returns the sum of unit cost for all transaction cost details except
--   delivery overhead details.
@UncheckedAccess
FUNCTION Get_Cost_Minus_Deliv_Overhead (
   transaction_id_ IN NUMBER ) RETURN NUMBER
IS
   cost_minus_deliv_oh_ NUMBER;

   CURSOR get_sum_cost IS
      SELECT SUM(unit_cost)
   FROM INVENTORY_TRANSACTION_COST_TAB
      WHERE transaction_id = transaction_id_
      AND NVL(cost_bucket_public_type, char_null_) != 'DELOH'
      AND added_to_this_transaction = 'FALSE';
BEGIN
   OPEN get_sum_cost;
   FETCH get_sum_cost INTO cost_minus_deliv_oh_;
   CLOSE get_sum_cost;

   RETURN (NVL(cost_minus_deliv_oh_,0));
END Get_Cost_Minus_Deliv_Overhead;


-- Get_Cost_Bucket_Group_And_Type
--   Fetches the posting cost group Id and the public bucket type for
--   the bucket from LU CostBucket in Costing.
PROCEDURE Get_Cost_Bucket_Group_And_Type (
   bucket_posting_group_id_ OUT VARCHAR2,
   cost_bucket_public_type_ OUT VARCHAR2,
   contract_                IN  VARCHAR2,
   cost_bucket_id_          IN  VARCHAR2,
   part_no_                 IN  VARCHAR2)
IS
   temp_bucket_posting_group_id_ VARCHAR2(20);
   temp_cost_bucket_public_type_ VARCHAR2(20);
BEGIN

   IF (cost_bucket_id_ != '*') THEN
      $IF Component_Cost_SYS.INSTALLED $THEN                                                                                                                                                         
         Standard_Cost_Bucket_API.Get_Postng_Grp_Id_And_Pub_Type (temp_bucket_posting_group_id_,
                                                                  temp_cost_bucket_public_type_,                               
                                                                  contract_, 
                                                                  part_no_, 
                                                                  cost_bucket_id_);   
         bucket_posting_group_id_ := temp_bucket_posting_group_id_;
         cost_bucket_public_type_ := temp_cost_bucket_public_type_;
      $ELSE
         NULL;
      $END
   END IF;
END Get_Cost_Bucket_Group_And_Type;


-- Create_Or_Modify_Details
--   Method takes care of updating the cost details for a specific
--   transaction id. the value of old details are set to zero, they
--   should not be deleted.
PROCEDURE Create_Or_Modify_Details (
   transaction_id_               IN NUMBER,
   new_cost_detail_tab_          IN Inventory_Part_Unit_Cost_API.Cost_Detail_Tab,
   added_to_this_transaction_db_ IN VARCHAR2,
   retain_acc_year_cost_source_  IN BOOLEAN,
   transaction_code_             IN VARCHAR2,
   part_no_                      IN VARCHAR2,
   configuration_id_             IN VARCHAR2,
   quantity_                     IN NUMBER,
   valuation_method_db_          IN VARCHAR2,
   part_cost_level_db_           IN VARCHAR2,
   purch_order_ref1_             IN VARCHAR2,
   purch_order_ref2_             IN VARCHAR2,
   purch_order_ref3_             IN VARCHAR2,
   purch_order_ref4_             IN NUMBER )
IS
   cost_detail_exist_   BOOLEAN;
   old_accounting_year_ INVENTORY_TRANSACTION_COST_TAB.accounting_year%TYPE;
   new_accounting_year_ INVENTORY_TRANSACTION_COST_TAB.accounting_year%TYPE;
   old_cost_source_id_  INVENTORY_TRANSACTION_COST_TAB.cost_source_id%TYPE;
   new_cost_source_id_  INVENTORY_TRANSACTION_COST_TAB.cost_source_id%TYPE;
BEGIN

   Set_Unit_Cost_To_Zero___(transaction_id_,
                            added_to_this_transaction_db_,
                            transaction_code_,
                            part_no_,
                            configuration_id_,
                            quantity_,
                            valuation_method_db_,
                            part_cost_level_db_,
                            purch_order_ref1_,
                            purch_order_ref2_,
                            purch_order_ref3_,
                            purch_order_ref4_);

   IF (new_cost_detail_tab_.COUNT > 0) THEN
      FOR i IN new_cost_detail_tab_.FIRST..new_cost_detail_tab_.LAST LOOP
         IF (retain_acc_year_cost_source_) THEN
            IF (Cost_Bucket_Unique___(new_cost_detail_tab_(i).cost_bucket_id, new_cost_detail_tab_)) THEN
               IF (new_cost_detail_tab_(i).accounting_year = '*') THEN
                  new_accounting_year_ := '*';
               ELSE
                  old_accounting_year_ := Get_Account_Year_Not_Star___(transaction_id_,
                                                                       new_cost_detail_tab_(i).cost_bucket_id,
                                                                       added_to_this_transaction_db_);
                  new_accounting_year_ := NVL(old_accounting_year_,
                                              new_cost_detail_tab_(i).accounting_year);
               END IF;

               old_cost_source_id_ := Get_Cost_Source_For_Bucket___(transaction_id_,
                                                                    new_cost_detail_tab_(i).cost_bucket_id,
                                                                    added_to_this_transaction_db_);

               new_cost_source_id_ := NVL(old_cost_source_id_, new_cost_detail_tab_(i).cost_source_id);
            ELSE
               new_cost_source_id_  := new_cost_detail_tab_(i).cost_source_id;
               new_accounting_year_ := new_cost_detail_tab_(i).accounting_year;
            END IF;
         ELSE
            new_cost_source_id_  := new_cost_detail_tab_(i).cost_source_id;
            new_accounting_year_ := new_cost_detail_tab_(i).accounting_year;
         END IF;

         cost_detail_exist_ := Check_Exist___(transaction_id_,
                                              new_cost_detail_tab_(i).contract,
                                              new_cost_detail_tab_(i).cost_bucket_id,
                                              new_cost_detail_tab_(i).company,
                                              new_cost_source_id_,
                                              new_accounting_year_,
                                              added_to_this_transaction_db_);
         IF (cost_detail_exist_) THEN
            Modify_Unit_Cost(transaction_id_,
                             new_cost_detail_tab_(i).contract,
                             new_cost_detail_tab_(i).cost_bucket_id,
                             new_cost_detail_tab_(i).company,
                             new_cost_source_id_,
                             new_accounting_year_,
                             added_to_this_transaction_db_,
                             new_cost_detail_tab_(i).unit_cost,
                             transaction_code_,
                             part_no_,
                             configuration_id_,
                             quantity_,
                             valuation_method_db_,
                             part_cost_level_db_,
                             purch_order_ref1_,
                             purch_order_ref2_,
                             purch_order_ref3_,
                             purch_order_ref4_);
         ELSE
            IF (new_cost_detail_tab_(i).unit_cost != 0) THEN
               New(transaction_id_,
                   new_cost_detail_tab_(i).contract,
                   new_cost_detail_tab_(i).cost_bucket_id,
                   new_cost_detail_tab_(i).company,
                   new_cost_source_id_,
                   new_accounting_year_,
                   added_to_this_transaction_db_,
                   new_cost_detail_tab_(i).unit_cost,
                   transaction_code_,
                   part_no_,
                   configuration_id_,
                   quantity_,
                   valuation_method_db_,
                   part_cost_level_db_,
                   purch_order_ref1_,
                   purch_order_ref2_,
                   purch_order_ref3_,
                   purch_order_ref4_);
            END IF;       
         END IF;
      END LOOP;
   END IF;
END Create_Or_Modify_Details;


-- Modify_Unit_Cost
--   This method modifies the unit cost of one specific existing
--   transaction cost detail.
PROCEDURE Modify_Unit_Cost (
   transaction_id_               IN NUMBER,
   contract_                     IN VARCHAR2,
   cost_bucket_id_               IN VARCHAR2,
   company_                      IN VARCHAR2,
   cost_source_id_               IN VARCHAR2,
   accounting_year_              IN VARCHAR2,
   added_to_this_transaction_db_ IN VARCHAR2,
   unit_cost_                    IN NUMBER,
   transaction_code_             IN VARCHAR2,
   part_no_                      IN VARCHAR2,
   configuration_id_             IN VARCHAR2,
   quantity_                     IN NUMBER,
   valuation_method_db_          IN VARCHAR2,
   part_cost_level_db_           IN VARCHAR2,
   purch_order_ref1_             IN VARCHAR2,
   purch_order_ref2_             IN VARCHAR2,
   purch_order_ref3_             IN VARCHAR2,
   purch_order_ref4_             IN NUMBER )
IS
   oldrec_     INVENTORY_TRANSACTION_COST_TAB%ROWTYPE;
   newrec_     INVENTORY_TRANSACTION_COST_TAB%ROWTYPE;
   attr_       VARCHAR2(2000);
   objid_      INVENTORY_TRANSACTION_COST.objid%TYPE;
   objversion_ INVENTORY_TRANSACTION_COST.objversion%TYPE;
   indrec_     Indicator_Rec;
BEGIN

   oldrec_ := Lock_By_Keys___(transaction_id_,
                              contract_,
                              cost_bucket_id_,
                              company_,
                              cost_source_id_,
                              accounting_year_,
                              added_to_this_transaction_db_);
   newrec_ := oldrec_;
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('UNIT_COST', unit_cost_, attr_);
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);         
   Update___(objid_,
             oldrec_,
             newrec_,
             attr_,
             objversion_,
             TRUE,
             transaction_code_,
             part_no_,
             configuration_id_,
             quantity_,
             valuation_method_db_,
             part_cost_level_db_,
             purch_order_ref1_,
             purch_order_ref2_,
             purch_order_ref3_,
             purch_order_ref4_);

END Modify_Unit_Cost;



