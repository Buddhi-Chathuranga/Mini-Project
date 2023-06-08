-----------------------------------------------------------------------------
--
--  Logical unit: PreInventTransAvgCost
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  150519  BudKlk  Bug 122422, Modified the method New___() in order to make sure new records will be added dispite the unit_cost_ value.   
--  130801  ChJalk  TIBE-901, Removed the global variable inst_CostBucket_.
--  100505  KRPELK  Merge Rose Method Documentation.
--  ------------------------------- Eagle -----------------------------------
--  060213  LEPESE  Small correction in New___ to allow details with negative unit_cost.
--  060124  NiDalk  Added Assert safe annotation. 
--  060104  IsAnlk  Added General_SYS.Init to Get_Cost_Details.
--  051116  JoEd    Changed prompt for accounting_year.
--  051103  LEPESE  Bug correction in method Add_Cost_Details.
--  051101  LEPESE  Added method Get_Cost_Details.
--  051031  LEPESE  Added methods Remove___, Remove_Cost_Details___ and Replace_Cost_Details.
--  051025  JoAnSe  Added new attribute cost_bucket_public_type and 
--                  metod Get_Cost_Bucket_Type_Db___
--  050830  LEPESE  Added methods Add_Cost_Details and New___.
--  050829  JoAnSe  Create
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE New___ (
   transaction_id_  IN NUMBER,
   contract_        IN VARCHAR2,
   cost_bucket_id_  IN VARCHAR2,
   company_         IN VARCHAR2,
   cost_source_id_  IN VARCHAR2,
   accounting_year_ IN VARCHAR2,
   unit_cost_       IN NUMBER )
IS
   attr_            VARCHAR2(2000);
   newrec_          PRE_INVENT_TRANS_AVG_COST_TAB%ROWTYPE;
   objid_           PRE_INVENT_TRANS_AVG_COST.objid%TYPE;
   objversion_      PRE_INVENT_TRANS_AVG_COST.objversion%TYPE;
   indrec_          Indicator_Rec;
BEGIN

      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('TRANSACTION_ID'   ,transaction_id_   ,attr_);
      Client_SYS.Add_To_Attr('ACCOUNTING_YEAR'  ,accounting_year_  ,attr_);
      Client_SYS.Add_To_Attr('CONTRACT'         ,contract_         ,attr_);
      Client_SYS.Add_To_Attr('COST_BUCKET_ID'   ,cost_bucket_id_   ,attr_);
      Client_SYS.Add_To_Attr('COMPANY'          ,company_          ,attr_);
      Client_SYS.Add_To_Attr('COST_SOURCE_ID'   ,cost_source_id_   ,attr_);
      Client_SYS.Add_To_Attr('UNIT_COST'        ,unit_cost_        ,attr_);

      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);

END New___;


-- Get_Cost_Bucket_Type_Db___
--   Retrive cost bucket public type for the specified cost bucket.
--   If cost_bucket_id = '*' return NULL
FUNCTION Get_Cost_Bucket_Type_Db___ (
   contract_       IN VARCHAR2,
   cost_bucket_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS   
   cost_bucket_type_db_ VARCHAR2(20) := NULL;
BEGIN
   IF (cost_bucket_id_ != '*') THEN
      $IF Component_Cost_SYS.INSTALLED $THEN      
         cost_bucket_type_db_ := Cost_Bucket_API.Get_Cost_Bucket_Public_Type_Db(contract_, cost_bucket_id_);
      $ELSE
         NULL;
      $END      
   END IF;

   RETURN (cost_bucket_type_db_);
END Get_Cost_Bucket_Type_Db___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT PRE_INVENT_TRANS_AVG_COST_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   -- Retrieve cost_bucket_public_type from Cost Bucket
   newrec_.cost_bucket_public_type := Get_Cost_Bucket_Type_Db___(newrec_.contract,
                                                                 newrec_.cost_bucket_id);
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


PROCEDURE Remove___ (
   transaction_id_  IN NUMBER,
   contract_        IN VARCHAR2,
   cost_bucket_id_  IN VARCHAR2,
   company_         IN VARCHAR2,
   cost_source_id_  IN VARCHAR2,
   accounting_year_ IN VARCHAR2 )
IS
   objid_      PRE_INVENT_TRANS_AVG_COST.objid%TYPE;
   objversion_ PRE_INVENT_TRANS_AVG_COST.objversion%TYPE;
   remrec_     PRE_INVENT_TRANS_AVG_COST_TAB%ROWTYPE;
BEGIN

   remrec_ := Lock_By_Keys___(transaction_id_,
                              contract_,
                              cost_bucket_id_,
                              company_,
                              cost_source_id_,
                              accounting_year_);
   Check_Delete___(remrec_);
   Get_Id_Version_By_Keys___(objid_,
                             objversion_,
                             transaction_id_,
                             contract_,
                             cost_bucket_id_,
                             company_,
                             cost_source_id_,
                             accounting_year_);
   Delete___(objid_, remrec_);
END Remove___;


PROCEDURE Remove_Cost_Details___ (
   transaction_id_ IN NUMBER )
IS
   CURSOR get_details IS
      SELECT *
        FROM PRE_INVENT_TRANS_AVG_COST_TAB
       WHERE transaction_id = transaction_id_
         FOR UPDATE;
BEGIN
   FOR detail_rec_ IN get_details LOOP

      Remove___(detail_rec_.transaction_id,
                detail_rec_.contract,
                detail_rec_.cost_bucket_id,
                detail_rec_.company,
                detail_rec_.cost_source_id,
                detail_rec_.accounting_year);
   END LOOP;
END Remove_Cost_Details___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Add_Cost_Details
--   Add new cost details.
PROCEDURE Add_Cost_Details (
   transaction_id_  IN NUMBER,
   cost_detail_tab_ IN Inventory_Part_Unit_Cost_API.Cost_Detail_tab )
IS
BEGIN

   IF (cost_detail_tab_.COUNT > 0) THEN
      FOR i IN cost_detail_tab_.FIRST..cost_detail_tab_.LAST LOOP

         New___(transaction_id_,
                cost_detail_tab_(i).contract,
                cost_detail_tab_(i).cost_bucket_id,
                cost_detail_tab_(i).company,
                cost_detail_tab_(i).cost_source_id,
                cost_detail_tab_(i).accounting_year,
                cost_detail_tab_(i).unit_cost);
      END LOOP;
   END IF;
END Add_Cost_Details;


-- Modify_Unit_Cost
--   Update the unit cost for the specified cost detail.
PROCEDURE Modify_Unit_Cost (
   transaction_id_  IN NUMBER,
   contract_        IN VARCHAR2,
   cost_bucket_id_  IN VARCHAR2,
   company_         IN VARCHAR2,
   cost_source_id_  IN VARCHAR2,
   accounting_year_ IN VARCHAR2,
   unit_cost_       IN NUMBER )
IS
   oldrec_ PRE_INVENT_TRANS_AVG_COST_TAB%ROWTYPE;
   newrec_ PRE_INVENT_TRANS_AVG_COST_TAB%ROWTYPE;
   attr_   VARCHAR2(32000);
   objid_       PRE_INVENT_TRANS_AVG_COST.objid%TYPE;
   objversion_  PRE_INVENT_TRANS_AVG_COST.objversion%TYPE;
   indrec_      Indicator_Rec;
BEGIN
   oldrec_ := Lock_By_Keys___(transaction_id_, contract_, cost_bucket_id_,
                              company_, cost_source_id_, accounting_year_ );
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('UNIT_COST', unit_cost_, attr_);
   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);

END Modify_Unit_Cost;


-- Check_Exist
--   Return TRUE if the specified record exists FALSE if not.
@UncheckedAccess
FUNCTION Check_Exist (
   transaction_id_  IN NUMBER,
   contract_        IN VARCHAR2,
   cost_bucket_id_  IN VARCHAR2,
   company_         IN VARCHAR2,
   cost_source_id_  IN VARCHAR2,
   accounting_year_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN Check_Exist___(transaction_id_, contract_, cost_bucket_id_,
                         company_, cost_source_id_, accounting_year_);
END Check_Exist;


-- Replace_Cost_Details
--   Replace the existing cost details with the ones passed to the method.
PROCEDURE Replace_Cost_Details (
   transaction_id_      IN NUMBER,
   new_cost_detail_tab_ IN Inventory_Part_Unit_Cost_API.Cost_Detail_tab )
IS
   old_cost_detail_tab_       Inventory_Part_Unit_Cost_API.Cost_Detail_tab;
   exit_procedure_            EXCEPTION;
   missing_in_old_detail_tab_ BOOLEAN;
   missing_in_new_detail_tab_ BOOLEAN;

   CURSOR get_old_details IS
      SELECT accounting_year,
             contract,
             cost_bucket_id,
             company,
             cost_source_id,
             unit_cost
        FROM PRE_INVENT_TRANS_AVG_COST_TAB
       WHERE transaction_id = transaction_id_;

BEGIN

   IF (new_cost_detail_tab_.COUNT = 0) THEN
      Remove_Cost_Details___(transaction_id_);
      RAISE exit_procedure_;
   END IF;

   OPEN  get_old_details;
   FETCH get_old_details BULK COLLECT INTO old_cost_detail_tab_;
   CLOSE get_old_details;

   IF (old_cost_detail_tab_.COUNT = 0) THEN
      Add_Cost_Details(transaction_id_, new_cost_detail_tab_);
      RAISE exit_procedure_;
   END IF;

   FOR i IN old_cost_detail_tab_.FIRST..old_cost_detail_tab_.LAST LOOP

      missing_in_new_detail_tab_ := TRUE;

      FOR j IN new_cost_detail_tab_.FIRST..new_cost_detail_tab_.LAST LOOP
         IF ((old_cost_detail_tab_(i).accounting_year =
              new_cost_detail_tab_(j).accounting_year) AND
             (old_cost_detail_tab_(i).contract =
              new_cost_detail_tab_(j).contract)        AND
             (old_cost_detail_tab_(i).cost_bucket_id =
              new_cost_detail_tab_(j).cost_bucket_id)  AND
             (old_cost_detail_tab_(i).company =
              new_cost_detail_tab_(j).company)         AND
             (old_cost_detail_tab_(i).cost_source_id  =
              new_cost_detail_tab_(j).cost_source_id)) THEN

            IF (old_cost_detail_tab_(i).unit_cost !=
                new_cost_detail_tab_(j).unit_cost) THEN

               Modify_Unit_Cost(transaction_id_,
                                old_cost_detail_tab_(i).contract,
                                old_cost_detail_tab_(i).cost_bucket_id,
                                old_cost_detail_tab_(i).company,
                                old_cost_detail_tab_(i).cost_source_id,
                                old_cost_detail_tab_(i).accounting_year,
                                new_cost_detail_tab_(j).unit_cost);
            END IF;

            missing_in_new_detail_tab_ := FALSE;
         END IF;
      END LOOP;
      IF (missing_in_new_detail_tab_) THEN

         Remove___(transaction_id_,
                   old_cost_detail_tab_(i).contract,
                   old_cost_detail_tab_(i).cost_bucket_id,
                   old_cost_detail_tab_(i).company,
                   old_cost_detail_tab_(i).cost_source_id,
                   old_cost_detail_tab_(i).accounting_year);
      END IF;
   END LOOP;

   FOR i IN new_cost_detail_tab_.FIRST..new_cost_detail_tab_.LAST LOOP

      missing_in_old_detail_tab_ := TRUE;

      FOR j IN old_cost_detail_tab_.FIRST..old_cost_detail_tab_.LAST LOOP
         IF ((new_cost_detail_tab_(i).accounting_year =
              old_cost_detail_tab_(j).accounting_year) AND
             (new_cost_detail_tab_(i).contract        =
              old_cost_detail_tab_(j).contract)        AND
             (new_cost_detail_tab_(i).cost_bucket_id  =
              old_cost_detail_tab_(j).cost_bucket_id)  AND
             (new_cost_detail_tab_(i).company         =
              old_cost_detail_tab_(j).company)         AND
             (new_cost_detail_tab_(i).cost_source_id  =
              old_cost_detail_tab_(j).cost_source_id)) THEN

            missing_in_old_detail_tab_ := FALSE;
         END IF;
      END LOOP;
      IF (missing_in_old_detail_tab_) THEN

         New___(transaction_id_,
                new_cost_detail_tab_(i).contract,
                new_cost_detail_tab_(i).cost_bucket_id,
                new_cost_detail_tab_(i).company,
                new_cost_detail_tab_(i).cost_source_id,
                new_cost_detail_tab_(i).accounting_year,
                new_cost_detail_tab_(i).unit_cost);
      END IF;
   END LOOP;

EXCEPTION
   WHEN exit_procedure_ THEN
      NULL;
END Replace_Cost_Details;


-- Get_Cost_Details
--   Returns a table with all cost details
FUNCTION Get_Cost_Details (
   transaction_id_ IN NUMBER ) RETURN Inventory_Part_Unit_Cost_API.Cost_Detail_Tab
IS
   cost_detail_tab_ Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;

   CURSOR get_cost_details IS
      SELECT accounting_year,
             contract,
             cost_bucket_id,
             company,
             cost_source_id,
             unit_cost
      FROM PRE_INVENT_TRANS_AVG_COST_TAB
      WHERE  transaction_id = transaction_id_;
BEGIN

    OPEN  get_cost_details;
    FETCH get_cost_details BULK COLLECT INTO cost_detail_tab_;
    CLOSE get_cost_details;

    RETURN (cost_detail_tab_);
END Get_Cost_Details;



