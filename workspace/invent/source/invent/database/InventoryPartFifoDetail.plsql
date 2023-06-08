-----------------------------------------------------------------------------
--
--  Logical unit: InventoryPartFifoDetail
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  130801  ChJalk  TIBE-876, Removed the global variable inst_CostBucket_.
--  110707  MaEelk  Added user allowed site filter to INVENTORY_PART_FIFO_DETAIL.
--  100510  KRPELK  Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  071204  HoInlk  Bug 69255, Modified method New___ to check if zero cost is allowed. Added method
--  071204          Add_Dummy_Detail_If_Missing___ to add dummy record with zero cost when record
--  071204          does not exist. Modified methods Add_Cost_Details and Modify_Cost_Details to pass
--  071204          allow_zero_cost_ parameter in New___ and use method Add_Dummy_Detail_If_Missing___.
--  060208  LEPESE  Added method Cost_Bucket_Exist.
--  060123  NiDalk  Added Assert safe annotation. 
--  060116  LEPESE  Added parameter unit_cost in call to Inventory_Part_Unit_Cost_API.Check_Insert.
--  060104  IsAnlk  Added General_Sys.Init to Get_Cost_Details_And_Lock. 
--  051125  LEPESE  Added check to avoid calling exist check when cost source = '*'.
--  051121  JoAnSe  Updates allowed for unit_cost columns.
--  051116  JoEd    Changed column title (prompt) for accounting_year.
--  051031  JoAnSe  Added Modify_Unit_Cost.
--  051025  JoAnSe  Added new attribute cost_bucket_public_type and
--                  metod Get_Cost_Bucket_Type_Db___
--  050916  LEPESE  Added part_no_ in call to Inventory_Part_Unit_Cost_API.Check_Insert.
--  050830  LEPESE  Added methods Modify_Cost_Details, Modify___, Remove___, Get_Total_Unit_Cost.
--  050829  LEPESE  Added methods Add_Cost_Details, Get_Cost_Details and New___.
--  050824  LEPESE  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE New___ (
   contract_        IN VARCHAR2,
   part_no_         IN VARCHAR2,
   sequence_no_     IN NUMBER,
   accounting_year_ IN VARCHAR2,
   cost_bucket_id_  IN VARCHAR2,
   company_         IN VARCHAR2,
   cost_source_id_  IN VARCHAR2,
   unit_cost_       IN NUMBER,
   allow_zero_cost_ IN BOOLEAN )
IS
   attr_            VARCHAR2(2000);
   newrec_          INVENTORY_PART_FIFO_DETAIL_TAB%ROWTYPE;
   objid_           INVENTORY_PART_FIFO_DETAIL.objid%TYPE;
   objversion_      INVENTORY_PART_FIFO_DETAIL.objversion%TYPE;
   indrec_          Indicator_Rec;
BEGIN

   IF ((unit_cost_ > 0) OR (allow_zero_cost_)) THEN

      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('CONTRACT'         ,contract_         ,attr_);
      Client_SYS.Add_To_Attr('PART_NO'          ,part_no_          ,attr_);
      Client_SYS.Add_To_Attr('SEQUENCE_NO'      ,sequence_no_      ,attr_);
      Client_SYS.Add_To_Attr('ACCOUNTING_YEAR'  ,accounting_year_  ,attr_);
      Client_SYS.Add_To_Attr('COST_BUCKET_ID'   ,cost_bucket_id_   ,attr_);
      Client_SYS.Add_To_Attr('COMPANY'          ,company_          ,attr_);
      Client_SYS.Add_To_Attr('COST_SOURCE_ID'   ,cost_source_id_   ,attr_);
      Client_SYS.Add_To_Attr('UNIT_COST'        ,unit_cost_        ,attr_);

      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);
   END IF;

END New___;


PROCEDURE Modify___ (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   sequence_no_      IN NUMBER,
   accounting_year_  IN VARCHAR2,
   cost_bucket_id_   IN VARCHAR2,
   company_          IN VARCHAR2,
   cost_source_id_   IN VARCHAR2,
   unit_cost_        IN NUMBER )
IS
   attr_          VARCHAR2(2000);
   oldrec_        INVENTORY_PART_FIFO_DETAIL_TAB%ROWTYPE;
   newrec_        INVENTORY_PART_FIFO_DETAIL_TAB%ROWTYPE;
   objid_         INVENTORY_PART_FIFO_DETAIL.objid%TYPE;
   objversion_    INVENTORY_PART_FIFO_DETAIL.objversion%TYPE;
   remove_record_ BOOLEAN;
   indrec_        Indicator_Rec;
BEGIN

   IF (unit_cost_ = 0) THEN
      IF ((accounting_year_ = '*')  AND
          (cost_bucket_id_  = '*')  AND
          (cost_source_id_  = '*')) THEN
         remove_record_ := FALSE;
      ELSE
         remove_record_ := TRUE;
      END IF;
   ELSE
      remove_record_ := FALSE;
   END IF;

   IF (remove_record_) THEN
      Remove___(contract_,
                part_no_,
                sequence_no_,
                accounting_year_,
                cost_bucket_id_,
                company_,
                cost_source_id_);
   ELSE
      oldrec_ := Lock_By_Keys___(contract_,
                                 part_no_,
                                 sequence_no_,
                                 accounting_year_,
                                 cost_bucket_id_,
                                 company_,
                                 cost_source_id_);
      newrec_ := oldrec_;
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('UNIT_COST', unit_cost_, attr_);
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
      Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE); -- Update by keys
   END IF;
END Modify___;


PROCEDURE Remove___ (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   sequence_no_      IN NUMBER,
   accounting_year_  IN VARCHAR2,
   cost_bucket_id_   IN VARCHAR2,
   company_          IN VARCHAR2,
   cost_source_id_   IN VARCHAR2 )
IS
   objid_         INVENTORY_PART_FIFO_DETAIL.objid%TYPE;
   objversion_    INVENTORY_PART_FIFO_DETAIL.objversion%TYPE;
   remrec_        INVENTORY_PART_FIFO_DETAIL_TAB%ROWTYPE;
BEGIN

   remrec_ := Lock_By_Keys___(contract_,
                              part_no_,
                              sequence_no_,
                              accounting_year_,
                              cost_bucket_id_,
                              company_,
                              cost_source_id_);

   Check_Delete___(remrec_);

   Get_Id_Version_By_Keys___(objid_,
                             objversion_,
                             remrec_.contract,
                             remrec_.part_no,
                             remrec_.sequence_no,
                             remrec_.accounting_year,
                             remrec_.cost_bucket_id,
                             remrec_.company,
                             remrec_.cost_source_id);

   Delete___(objid_, remrec_);
END Remove___;


-- Get_Cost_Bucket_Type_Db___
--   Retrive cost bucket public type for the specified cost bucket.
--   If cost_bucket_id = '*' return NULL
FUNCTION Get_Cost_Bucket_Type_Db___ (
   contract_       IN VARCHAR2,
   cost_bucket_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS   
   cost_bucket_type_db_ VARCHAR2(20) := NULL;
BEGIN
   $IF Component_Cost_SYS.INSTALLED $THEN
      IF (cost_bucket_id_ != '*') THEN     
         cost_bucket_type_db_ := Cost_Bucket_API.Get_Cost_Bucket_Public_Type_Db(contract_, cost_bucket_id_);
      END IF;
   $END
   RETURN (cost_bucket_type_db_);
END Get_Cost_Bucket_Type_Db___;


PROCEDURE Add_Dummy_Detail_If_Missing___ (
   contract_    IN VARCHAR2,
   part_no_     IN VARCHAR2,
   sequence_no_ IN NUMBER )
IS
   dummy_           NUMBER;
   details_missing_ BOOLEAN := FALSE;

   CURSOR exist_control IS
      SELECT 1
      FROM   INVENTORY_PART_FIFO_DETAIL_TAB
      WHERE contract = contract_
      AND   part_no = part_no_
      AND   sequence_no = sequence_no_;
BEGIN

   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%NOTFOUND) THEN
      details_missing_ := TRUE;
   END IF;
   CLOSE exist_control;

   IF (details_missing_) THEN
      New___(contract_        => contract_,
             part_no_         => part_no_,
             sequence_no_     => sequence_no_,
             accounting_year_ => '*',
             cost_bucket_id_  => '*',
             company_         => Site_API.Get_Company(contract_),
             cost_source_id_  => '*',
             unit_cost_       => 0,
             allow_zero_cost_ => TRUE);
   END IF;
END;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT INVENTORY_PART_FIFO_DETAIL_TAB%ROWTYPE,
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


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT inventory_part_fifo_detail_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN

   IF (newrec_.cost_source_id != '*' AND newrec_.cost_source_id IS NOT NULL) THEN
      Cost_Source_API.Exist(newrec_.company, newrec_.cost_source_id);
   END IF;
   IF (newrec_.cost_bucket_id != '*' AND newrec_.cost_bucket_id IS NOT NULL) THEN
      $IF Component_Cost_SYS.INSTALLED $THEN
         Cost_Bucket_API.Exist(newrec_.contract, newrec_.cost_bucket_id);
      $ELSE
         NULL;
      $END
   END IF;
   super(newrec_, indrec_, attr_);

   Inventory_Part_Unit_Cost_API.Check_Insert(newrec_.accounting_year,
                                             newrec_.contract,
                                             newrec_.part_no,
                                             newrec_.cost_bucket_id,
                                             newrec_.company,
                                             newrec_.cost_source_id,
                                             newrec_.unit_cost);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Add_Cost_Details
--   Add a new cost detail record to Fifo/Lifo cost details
PROCEDURE Add_Cost_Details (
   contract_        IN VARCHAR2,
   part_no_         IN VARCHAR2,
   sequence_no_     IN NUMBER,
   cost_detail_tab_ IN Inventory_Part_Unit_Cost_API.Cost_Detail_tab )
IS
BEGIN

   IF (cost_detail_tab_.COUNT > 0) THEN
      FOR i IN cost_detail_tab_.FIRST..cost_detail_tab_.LAST LOOP

         New___(contract_,
                part_no_,
                sequence_no_,
                cost_detail_tab_(i).accounting_year,
                cost_detail_tab_(i).cost_bucket_id,
                cost_detail_tab_(i).company,
                cost_detail_tab_(i).cost_source_id,
                cost_detail_tab_(i).unit_cost,
                FALSE);
      END LOOP;
   END IF;
   Add_Dummy_Detail_If_Missing___(contract_, part_no_, sequence_no_);
END Add_Cost_Details;


-- Get_Cost_Details
--   Return all cost details for a record in the FIFO/LIFO pile
@UncheckedAccess
FUNCTION Get_Cost_Details (
   contract_    IN VARCHAR2,
   part_no_     IN VARCHAR2,
   sequence_no_ IN NUMBER ) RETURN Inventory_Part_Unit_Cost_API.Cost_Detail_Tab
IS
   cost_detail_tab_ Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;

   CURSOR get_cost_detail IS
      SELECT accounting_year,
             contract,
             cost_bucket_id,
             company,
             cost_source_id,
             unit_cost
      FROM   INVENTORY_PART_FIFO_DETAIL_TAB
      WHERE  contract    = contract_
        AND  part_no     = part_no_
        AND  sequence_no = sequence_no_;
BEGIN
   OPEN  get_cost_detail;
   FETCH get_cost_detail BULK COLLECT INTO cost_detail_tab_;
   CLOSE get_cost_detail;

   RETURN(cost_detail_tab_);
END Get_Cost_Details;


-- Get_Total_Unit_Cost
--   Return the total unit cost for all cost details for a record in the FIFO/LIFO pile
@UncheckedAccess
FUNCTION Get_Total_Unit_Cost (
   contract_    IN VARCHAR2,
   part_no_     IN VARCHAR2,
   sequence_no_ IN NUMBER ) RETURN NUMBER
IS
   cost_detail_tab_ Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   total_unit_cost_ NUMBER;
BEGIN
   cost_detail_tab_ := Get_Cost_Details(contract_, part_no_, sequence_no_);
   total_unit_cost_ := Inventory_Part_Unit_Cost_API.Get_Total_Unit_Cost(cost_detail_tab_);
   RETURN (total_unit_cost_);
END Get_Total_Unit_Cost;


-- Get_Cost_Details_And_Lock
--   Return all cost details for a record in the FIFO/LIFO pile and
--   lock the records for update.
FUNCTION Get_Cost_Details_And_Lock (
   contract_    IN VARCHAR2,
   part_no_     IN VARCHAR2,
   sequence_no_ IN NUMBER ) RETURN Inventory_Part_Unit_Cost_API.Cost_Detail_Tab
IS
   cost_detail_tab_ Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;

   CURSOR get_cost_detail IS
      SELECT accounting_year,
             contract,
             cost_bucket_id,
             company,
             cost_source_id,
             unit_cost
      FROM   INVENTORY_PART_FIFO_DETAIL_TAB
      WHERE  contract    = contract_
        AND  part_no     = part_no_
        AND  sequence_no = sequence_no_
      FOR UPDATE;
BEGIN
   OPEN  get_cost_detail;
   FETCH get_cost_detail BULK COLLECT INTO cost_detail_tab_;
   CLOSE get_cost_detail;

   RETURN(cost_detail_tab_);
END Get_Cost_Details_And_Lock;


-- Modify_Cost_Details
--   Modify the cost details for a record in the FIFO/LIFO pile.
PROCEDURE Modify_Cost_Details (
   contract_            IN     VARCHAR2,
   part_no_             IN     VARCHAR2,
   sequence_no_         IN     NUMBER,
   old_cost_detail_tab_ IN     Inventory_Part_Unit_Cost_API.Cost_Detail_Tab,
   new_cost_detail_tab_ IN     Inventory_Part_Unit_Cost_API.Cost_Detail_Tab )
IS
   missing_in_old_detail_tab_ BOOLEAN;
   missing_in_new_detail_tab_ BOOLEAN;
BEGIN

   IF (old_cost_detail_tab_.COUNT > 0) THEN
      FOR i IN old_cost_detail_tab_.FIRST..old_cost_detail_tab_.LAST LOOP

         missing_in_new_detail_tab_ := TRUE;

         IF (new_cost_detail_tab_.COUNT > 0) THEN
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

                     Modify___(contract_,
                               part_no_,
                               sequence_no_,
                               old_cost_detail_tab_(i).accounting_year,
                               old_cost_detail_tab_(i).cost_bucket_id,
                               old_cost_detail_tab_(i).company,
                               old_cost_detail_tab_(i).cost_source_id,
                               new_cost_detail_tab_(j).unit_cost);
                  END IF;

                  missing_in_new_detail_tab_ := FALSE;
               END IF;
            END LOOP;
         END IF;
         IF (missing_in_new_detail_tab_) THEN

            Remove___(contract_,
                      part_no_,
                      sequence_no_,
                      old_cost_detail_tab_(i).accounting_year,
                      old_cost_detail_tab_(i).cost_bucket_id,
                      old_cost_detail_tab_(i).company,
                      old_cost_detail_tab_(i).cost_source_id);
         END IF;
      END LOOP;
   END IF;

   IF (new_cost_detail_tab_.COUNT > 0) THEN
      FOR i IN new_cost_detail_tab_.FIRST..new_cost_detail_tab_.LAST LOOP

         IF (contract_ != new_cost_detail_tab_(i).contract) THEN
            Error_SYS.Record_General(lu_name_, 'CONTRACTERR2: Cost Bucket ID :P1 is connected to Site :P2. Only cost buckets connected to site :P3 are allowed.',new_cost_detail_tab_(i).cost_bucket_id, new_cost_detail_tab_(i).contract, contract_);
         END IF;

         missing_in_old_detail_tab_ := TRUE;

         IF (old_cost_detail_tab_.COUNT > 0) THEN
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
         END IF;
         IF (missing_in_old_detail_tab_) THEN

            New___(contract_,
                   part_no_,
                   sequence_no_,
                   new_cost_detail_tab_(i).accounting_year,
                   new_cost_detail_tab_(i).cost_bucket_id,
                   new_cost_detail_tab_(i).company,
                   new_cost_detail_tab_(i).cost_source_id,
                   new_cost_detail_tab_(i).unit_cost,
                   FALSE);
         END IF;
      END LOOP;
   END IF;
   Add_Dummy_Detail_If_Missing___(contract_, part_no_, sequence_no_);
END Modify_Cost_Details;


-- Modify_Unit_Cost
--   Modify the unit cost for one cost detail.
PROCEDURE Modify_Unit_Cost (
   contract_        IN VARCHAR2,
   part_no_         IN VARCHAR2,
   sequence_no_     IN NUMBER,
   accounting_year_ IN VARCHAR2,
   cost_bucket_id_  IN VARCHAR2,
   company_         IN VARCHAR2,
   cost_source_id_  IN VARCHAR2,
   unit_cost_       IN NUMBER )
IS
   oldrec_     INVENTORY_PART_FIFO_DETAIL_TAB%ROWTYPE;
   newrec_     INVENTORY_PART_FIFO_DETAIL_TAB%ROWTYPE;
   attr_       VARCHAR2(32000);
   objid_      INVENTORY_PART_FIFO_DETAIL.objid%TYPE;
   objversion_ INVENTORY_PART_FIFO_DETAIL.objversion%TYPE;
   indrec_     Indicator_Rec;
BEGIN
   oldrec_ := Lock_By_Keys___(contract_, part_no_, sequence_no_, accounting_year_,
                              cost_bucket_id_, company_, cost_source_id_);
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('UNIT_COST', unit_cost_, attr_);
   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);

END Modify_Unit_Cost;


-- Cost_Bucket_Exist
--   Check if the specified cost bucket is used on any of the cost details
--   in the FIFO/LIFO pile.
@UncheckedAccess
FUNCTION Cost_Bucket_Exist (
   contract_       IN VARCHAR2,
   cost_bucket_id_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   cost_bucket_exist_ BOOLEAN := FALSE;
   dummy_             NUMBER;

   CURSOR exist_control IS
      SELECT 1
      FROM   INVENTORY_PART_FIFO_DETAIL_TAB
      WHERE contract       = contract_
      AND   cost_bucket_id = cost_bucket_id_;
BEGIN
   OPEN  exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      cost_bucket_exist_ := TRUE;
   END IF;
   CLOSE exist_control;

   RETURN(cost_bucket_exist_);
END Cost_Bucket_Exist;



