-----------------------------------------------------------------------------
--
--  Logical unit: TemporaryPartCostDetail
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  211005  Asawlk  Bug 161139 (SCZ-16509), Modified Validate_Cost_Structure__ to only validate PURCHASED and MANUFACTURED parts.
--  210709  Asawlk  Bug 159948(SCZ-15412), Added new method Validate_Cost_Structure__ to validate the defined cost structure
--  210709          when the COST module is installed.
--  130805  ChJalk  TIBE-908, Removed the global variable inst_CostBucket_.
--  130521  AwWelk  EBALL-73, Added Generate_Auto_Split_Details() to split the cost according to part cost structure.
--  119715  MaEelk  Added user allowed site filter to TEMPORARY_PART_COST_DETAIL.
--  100826  PraWlk  Bug 92629, Modified Modify__() to execute validations that stops negative unit_cost only
--  100826          if unit_cost is really changed.
--  100505  KRPELK  Merge Rose Method Documentation.
--  091001  ChFolk  Removed unused variables in the package.
--  -------------------------------- 14.0.0 -----------------------------------
--  060228  JoEd    Added method Validate_Cost_Bucket___.
--  060202  LEPESE  Added parameter configuration_id_ to method Generate_Details_From_Total.
--  060124  NiDalk  Added Assert safe annotation. 
--  060116  LEPESE  Added parameter unit_cost in call to Inventory_Part_Unit_Cost_API.Check_Insert.
--  051221  JoEd    Removed default value for accounting_year. Added method Get_Default_Accounting_Year.
--  051116  JoEd    Changed prompt for accounting_year and changed message ACCYEAR.
--  051109  RaKalk  Added method Duplicate_Cost_Details.
--  051109  JoEd    Added validate of accounting year in New__.
--  051104  JoEd    Added same kind of validation for accounting year as for cost source.
--  051102  JoEd    Added dummy attribute Client_name to be used when validating cost source
--                  from the Modify... and Define Cost Details dialogs.
--  051101  JoEd    Added check on cost_source_id * for Standard Cost and Cost Per Part.
--  051031  LEPESE  Added method Check_Unit_Cost___ and added call to this method from 
--  051031          methods New__ and Modify__ in order to check manually entered unit_cost values.
--  051021  LEPESE  Additional logic in method Remove_Details to check in CountingResult.
--  051017  LEPESE  Added parameter calling_process_ to method Generate_Default_Details.
--  051013  LEPESE  Added method Generate_Details_From_Total.
--  051013  JoEd    Changed the primary key.
--  050915  LEPESE  Added part_no as attribute.
--  050914  LEPESE  Added logic in method Remove_Details to remove all details older than 7 days.
--  050906  LEPESE  Avoid Exist-check in Unpack_Check_Insert___ when cost_source_id = '*'.
--  050803  LEPESE  Removed call to General_SYS.Init_Method from method Get_Details.
--  050802  LEPESE  Added methods Get_Total_Unit_Cost and Get_Total_Unit_Cost___.
--  050802  LEPESE  Added method Cost_Detail_Id_Exist.
--  050722  LEPESE  Added methods Add_Details___ and Generate_Default_Details.
--  050722          Redesign of method Add_Details to use Add_Details___.
--  050721  LEPESE  Changed method Get_Next_Cost_Detail_Id___ to be public.
--  050622  LEPESE  New parameter in call to Inventory_Part_Unit_Cost_API.Check_Insert.
--  050621  LEPESE  Added methods Get_And_Remove_Details and Get_Next_Cost_Detail_Id___.
--  050620  LEPESE  Added methods Add_Details, Get_Details and Remove_Details.
--  050617  LEPESE  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

FUNCTION Validate_Cost_Structure__ (
   cost_detail_id_  IN NUMBER) RETURN VARCHAR2   
IS
   CURSOR get_inv_part_and_cost_buckets IS
      SELECT contract, part_no, cost_bucket_id
      FROM temporary_part_cost_detail_tab
      WHERE cost_detail_id = cost_detail_id_;
      
      part_type_fetched_      BOOLEAN := FALSE;
      part_type_              inventory_part_tab.type_code%TYPE;
      valid_cost_structure_   VARCHAR2(5):= Fnd_Boolean_API.DB_FALSE;
BEGIN
   -- It is required to validate the defined cost structure only when COST module is installed.
   $IF Component_Cost_SYS.INSTALLED $THEN      
      FOR rec_ IN get_inv_part_and_cost_buckets LOOP      
         IF (NOT part_type_fetched_) THEN
            part_type_ := Inventory_Part_API.Get_Type_Code_Db(rec_.contract, rec_.part_no);
            part_type_fetched_ := TRUE;
         END IF;
         IF (part_type_ = Inventory_Part_Type_API.DB_PURCHASED) THEN
            IF (Cost_Bucket_API.Get_Cost_Bucket_Public_Type_Db(rec_.contract, rec_.cost_bucket_id) = Cost_Bucket_Public_Type_API.DB_MATERIAL_COST) THEN
               valid_cost_structure_ := Fnd_Boolean_API.DB_TRUE;
               EXIT;
            END IF;   
         ELSIF (part_type_ = Inventory_Part_Type_API.DB_MANUFACTURED) THEN
            IF (Cost_Bucket_API.Get_Cost_Bucket_Public_Type_Db(rec_.contract, rec_.cost_bucket_id) IN (Cost_Bucket_Public_Type_API.DB_MATERIAL_COST, 
                                                                                                       Cost_Bucket_Public_Type_API.DB_LABOR_COST, 
                                                                                                       Cost_Bucket_Public_Type_API.DB_SUBCONTRACTING_COST)) THEN
               valid_cost_structure_ := Fnd_Boolean_API.DB_TRUE;
               EXIT;
            END IF;
         ELSE
            valid_cost_structure_ := Fnd_Boolean_API.DB_TRUE;
            EXIT;   
         END IF;         
      END LOOP;
   $ELSE
      valid_cost_structure_ := Fnd_Boolean_API.DB_TRUE;
   $END
   RETURN valid_cost_structure_;    
END Validate_Cost_Structure__;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Get_Total_Unit_Cost___ (
   cost_detail_tab_ IN Inventory_Part_Unit_Cost_API.Cost_Detail_Tab ) RETURN NUMBER
IS
   total_unit_cost_ NUMBER := 0;
BEGIN
   IF (cost_detail_tab_.COUNT > 0) THEN
      FOR i IN cost_detail_tab_.FIRST..cost_detail_tab_.LAST LOOP
         total_unit_cost_ := total_unit_cost_ + cost_detail_tab_(i).unit_cost;
      END LOOP;
   END IF;

   RETURN total_unit_cost_;
END Get_Total_Unit_Cost___;


PROCEDURE Check_Unit_Cost___ (
   unit_cost_ IN NUMBER )
IS
BEGIN

   IF (unit_cost_ < 0) THEN
      Error_SYS.Record_General(lu_name_, 'NEGATIVECOST: A manually entered unit cost is not allowed to be negative.');
   END IF;
END Check_Unit_Cost___;


PROCEDURE Validate_Cost_Source___ (
   company_        IN VARCHAR2,
   contract_       IN VARCHAR2,
   part_no_        IN VARCHAR2,
   cost_source_id_ IN VARCHAR2 )
IS
   partrec_  Inventory_Part_API.Public_Rec;
BEGIN

   partrec_ := Inventory_Part_API.Get(contract_, part_no_);

   IF ((partrec_.inventory_valuation_method = 'ST') AND
       (partrec_.inventory_part_cost_level IN ('COST PER PART',
                                               'COST PER CONFIGURATION'))) THEN
      -- standard cost + cost per part/configuration must always have cost source '*'
      IF (cost_source_id_ != '*') THEN
         Error_SYS.Record_General(lu_name_, 'STANDARDCOST: Cost Source may only be '':P1'' when Standard Cost per Part or Configuration is used.', '*');
      END IF;
   -- Mandatory cost source doesn't allow cost source '*'
   ELSIF (Company_Distribution_Info_API.Get_Mandatory_Cost_Source_Db(company_) = 'TRUE') THEN
      IF (cost_source_id_ = '*') THEN
         Error_SYS.Record_General(lu_name_, 'CS_MANDATORY: Cost Source may not be '':P1'' when it is Mandatory to Use Cost Source.', '*');
      END IF;
   END IF;
END Validate_Cost_Source___;


PROCEDURE Validate_Accounting_Year___ (
   company_         IN VARCHAR2,
   accounting_year_ IN VARCHAR2 )
IS
BEGIN

   -- When "Use OH Accounting Year" flag is checked you can enter any accounting year (even *).
   -- When unchecked only * is allowed!
   IF (accounting_year_ != '*') THEN
      IF (Company_Distribution_Info_API.Get_Use_Accounting_Year_Db(company_) = 'FALSE') THEN
         Error_SYS.Record_General(lu_name_, 'ACCYEAR: OH Accounting Year may only be '':P1'' since "Use OH Accounting Year" is unchecked for company :P2.', '*', company_);
      END IF;
   END IF;
END Validate_Accounting_Year___;


PROCEDURE Validate_Cost_Bucket___ (
   contract_       IN VARCHAR2,
   cost_bucket_id_ IN VARCHAR2 )
IS   
   bucket_type_ VARCHAR2(20);
   buckets_     VARCHAR2(200);
BEGIN
   IF (cost_bucket_id_ != '*') THEN
      $IF Component_Cost_SYS.INSTALLED $THEN
         -- It's not allowed to use "Bucket of Buckets"
         bucket_type_ := Cost_Bucket_API.Get_Cost_Bucket_Type_Db(contract_, cost_bucket_id_);
         buckets_ := Cost_Bucket_Type_API.Decode('BUCKETS');
     
         IF (bucket_type_ = 'BUCKETS') THEN
            Error_SYS.Record_General(lu_name_, 'BUCKETS: Cost buckets of type '':P1'' may not be used.', buckets_);
         END IF;
      $ELSE
         NULL;
      $END      
   END IF;
END Validate_Cost_Bucket___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('COST_SOURCE_ID', '*', attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT TEMPORARY_PART_COST_DETAIL_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   CURSOR get_sequence IS
      SELECT NVL(MAX(cost_detail_seq) + 1, 1)
      FROM TEMPORARY_PART_COST_DETAIL_TAB
      WHERE cost_detail_id = newrec_.cost_detail_id;
BEGIN
   OPEN get_sequence;
   FETCH get_sequence INTO newrec_.cost_detail_seq;
   CLOSE get_sequence;
   Client_SYS.Add_To_Attr('COST_DETAIL_SEQ', newrec_.cost_detail_seq, attr_);

   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


PROCEDURE Add_Details___ (
   cost_detail_id_  IN NUMBER,
   cost_detail_tab_ IN Inventory_Part_Unit_Cost_API.Cost_Detail_Tab,
   part_no_         IN VARCHAR2 )
IS
   attr_          VARCHAR2(2000);
   newrec_        TEMPORARY_PART_COST_DETAIL_TAB%ROWTYPE;
   objid_         TEMPORARY_PART_COST_DETAIL.objid%TYPE;
   objversion_    TEMPORARY_PART_COST_DETAIL.objversion%TYPE;
   indrec_        Indicator_Rec;
BEGIN

   IF (cost_detail_tab_.COUNT > 0) THEN
      FOR i IN cost_detail_tab_.FIRST..cost_detail_tab_.LAST LOOP

         Client_SYS.Clear_Attr(attr_);
         Client_SYS.Add_To_Attr('COST_DETAIL_ID',  cost_detail_id_,                     attr_);
         Client_SYS.Add_To_Attr('PART_NO',         part_no_,                            attr_);
         Client_SYS.Add_To_Attr('ACCOUNTING_YEAR', cost_detail_tab_(i).accounting_year, attr_);
         Client_SYS.Add_To_Attr('CONTRACT',        cost_detail_tab_(i).contract,        attr_);
         Client_SYS.Add_To_Attr('COST_BUCKET_ID',  cost_detail_tab_(i).cost_bucket_id,  attr_);
         Client_SYS.Add_To_Attr('COMPANY',         cost_detail_tab_(i).company,         attr_);
         Client_SYS.Add_To_Attr('COST_SOURCE_ID',  cost_detail_tab_(i).cost_source_id,  attr_);
         Client_SYS.Add_To_Attr('UNIT_COST',       cost_detail_tab_(i).unit_cost,       attr_);
         
         Unpack___(newrec_, indrec_, attr_);
         Check_Insert___(newrec_, indrec_, attr_, FALSE);
         Insert___(objid_, objversion_, newrec_, attr_);
      END LOOP;
   END IF;
END Add_Details___;


@Override
PROCEDURE Check_Insert___ (
   newrec_         IN OUT temporary_part_cost_detail_tab%ROWTYPE,
   indrec_         IN OUT Indicator_Rec,
   attr_           IN OUT VARCHAR2,
   validate_       IN     BOOLEAN DEFAULT TRUE)
IS
   name_        VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   IF NOT (indrec_.cost_source_id) THEN 
      newrec_.cost_source_id := '*';
   END IF;
   
   super(newrec_, indrec_, attr_);

   Inventory_Part_Unit_Cost_API.Check_Insert(newrec_.accounting_year,
                                             newrec_.contract,
                                             newrec_.part_no,
                                             newrec_.cost_bucket_id,
                                             newrec_.company,
                                             newrec_.cost_source_id,
                                             newrec_.unit_cost);
   IF (validate_)THEN
      Check_Unit_Cost___(newrec_.unit_cost);
      Validate_Cost_Bucket___(newrec_.contract, newrec_.cost_bucket_id);
      Validate_Cost_Source___(newrec_.company, newrec_.contract, newrec_.part_no, newrec_.cost_source_id);
      Validate_Accounting_Year___(newrec_.company, newrec_.accounting_year);
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_         IN     temporary_part_cost_detail_tab%ROWTYPE,
   newrec_         IN OUT temporary_part_cost_detail_tab%ROWTYPE,
   indrec_         IN OUT Indicator_Rec,
   attr_           IN OUT VARCHAR2,
   validate_       IN     BOOLEAN DEFAULT TRUE)
IS
   name_           VARCHAR2(30);
   value_          VARCHAR2(4000);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);

   Inventory_Part_Unit_Cost_API.Check_Insert(newrec_.accounting_year,
                                             newrec_.contract,
                                             newrec_.part_no,
                                             newrec_.cost_bucket_id,
                                             newrec_.company,
                                             newrec_.cost_source_id,
                                             newrec_.unit_cost);
   IF (validate_)THEN
      IF (newrec_.unit_cost != oldrec_.unit_cost) THEN
         Check_Unit_Cost___(newrec_.unit_cost);
      END IF;
      -- if the update call is made from the "Modify Cost Level Details" dialog,
      -- there should NOT be a cost source nor accounting year validation...
      IF NOT(Client_SYS.Item_Exist('CLIENT_NAME', attr_) AND (Client_SYS.Get_Item_Value('CLIENT_NAME', attr_) = 'MODIFY')) THEN
         Validate_Cost_Bucket___(newrec_.contract, newrec_.cost_bucket_id);
         Validate_Cost_Source___(newrec_.company, newrec_.contract, newrec_.part_no, newrec_.cost_source_id);
         Validate_Accounting_Year___(newrec_.company, newrec_.accounting_year);
      END IF;
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Add_Details
--   Inserts a set of cost details into the table and returns a common Id
--   for these details.
PROCEDURE Add_Details (
   cost_detail_id_  OUT NUMBER,
   cost_detail_tab_ IN  Inventory_Part_Unit_Cost_API.Cost_Detail_Tab,
   part_no_         IN  VARCHAR2 )
IS
   next_cost_detail_id_ NUMBER;
BEGIN

   next_cost_detail_id_ := Get_Next_Cost_Detail_Id;
   cost_detail_id_      := next_cost_detail_id_;

   Add_Details___(next_cost_detail_id_, cost_detail_tab_, part_no_);
END Add_Details;


-- Get_Details
--   Returns the cost details for a specific cost detail ID.
@UncheckedAccess
FUNCTION Get_Details (
   cost_detail_id_ IN NUMBER ) RETURN Inventory_Part_Unit_Cost_API.Cost_Detail_Tab
IS
   cost_detail_tab_ Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;

   CURSOR get_cost_detail IS
      SELECT accounting_year,
             contract,
             cost_bucket_id,
             company,
             cost_source_id,
             unit_cost
      FROM TEMPORARY_PART_COST_DETAIL_TAB
      WHERE cost_detail_id = cost_detail_id_;
BEGIN
   OPEN get_cost_detail;
   FETCH get_cost_detail BULK COLLECT INTO cost_detail_tab_;
   CLOSE get_cost_detail;

   RETURN cost_detail_tab_;
END Get_Details;


-- Remove_Details
--   Deletes all details having a specific cost detail ID from the table.
PROCEDURE Remove_Details (
   cost_detail_id_  IN NUMBER )
IS
   objid_      TEMPORARY_PART_COST_DETAIL.objid%TYPE;
   objversion_ TEMPORARY_PART_COST_DETAIL.objversion%TYPE;

   CURSOR get_records (cost_detail_id_ IN NUMBER) IS
      SELECT *
      FROM TEMPORARY_PART_COST_DETAIL_TAB
      WHERE cost_detail_id = cost_detail_id_
      FOR UPDATE;

   CURSOR get_old_cost_detail_id IS
      SELECT DISTINCT cost_detail_id
      FROM TEMPORARY_PART_COST_DETAIL_TAB
      WHERE TRUNC(rowversion) < TRUNC(SYSDATE) - 7;
BEGIN

   FOR remrec_ IN get_records (cost_detail_id_) LOOP
      Check_Delete___(remrec_);
      Get_Id_Version_By_Keys___(objid_,
                                objversion_,
                                remrec_.cost_detail_id,
                                remrec_.cost_detail_seq);
      Delete___(objid_, remrec_);
   END LOOP;

   FOR old_id_rec_ IN get_old_cost_detail_id LOOP
      IF NOT (Counting_Result_API.Cost_Detail_Id_Is_On_Rejected(old_id_rec_.cost_detail_id)) THEN

         FOR remrec_ IN get_records (old_id_rec_.cost_detail_id) LOOP
            Check_Delete___(remrec_);
            Get_Id_Version_By_Keys___(objid_,
                                      objversion_,
                                      remrec_.cost_detail_id,
                                      remrec_.cost_detail_seq);
            Delete___(objid_, remrec_);
         END LOOP;
      END IF;
   END LOOP;
END Remove_Details;


-- Get_And_Remove_Details
--   Method returns the cost details stored for the given cost detail
--   ID and at the same time deletes these details from the table.
PROCEDURE Get_And_Remove_Details (
   cost_detail_tab_ OUT Inventory_Part_Unit_Cost_API.Cost_Detail_Tab,
   cost_detail_id_  IN  NUMBER )
IS
BEGIN

   cost_detail_tab_ := Get_Details(cost_detail_id_);

   Remove_Details(cost_detail_id_);
END Get_And_Remove_Details;


FUNCTION Get_Next_Cost_Detail_Id RETURN NUMBER
IS
   CURSOR get_id IS
      SELECT temporary_part_cost_detail_id.nextval
      FROM dual;

   cost_detail_id_ NUMBER;
BEGIN

   OPEN get_id;
   FETCH get_id INTO cost_detail_id_;
   CLOSE get_id;

   RETURN cost_detail_id_;
END Get_Next_Cost_Detail_Id;


-- Generate_Default_Details
--   Fetches the default cost details from LU InventoryPartUnitCost and
--   stores them connected to a new cost detail ID
PROCEDURE Generate_Default_Details (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   condition_code_   IN VARCHAR2,
   cost_detail_id_   IN NUMBER,
   calling_process_  IN VARCHAR2 )
IS
   cost_detail_tab_ Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
BEGIN

   Remove_Details(cost_detail_id_);

   cost_detail_tab_ := Inventory_Part_Unit_Cost_API.Get_Default_Details(contract_,
                                                                        part_no_,
                                                                        configuration_id_,
                                                                        lot_batch_no_,
                                                                        serial_no_,
                                                                        condition_code_,
                                                                        calling_process_);
   Add_Details___(cost_detail_id_, cost_detail_tab_, part_no_);

END Generate_Default_Details;


-- Generate_Details_From_Total
--   Receives a total unit cost which is splitted into details through a call
--   to Costing. The new details are stored under existing cost detail ID passed in.
--   EBALL, start.
--   EBALL, end.
PROCEDURE Generate_Details_From_Total (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   total_unit_cost_  IN NUMBER,
   cost_detail_id_   IN NUMBER )
IS
   cost_detail_tab_ Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
BEGIN

   Remove_Details(cost_detail_id_);

   cost_detail_tab_ := Inventory_Part_Unit_Cost_API.Generate_Cost_Details(
                                                                   cost_detail_tab_,
                                                                   total_unit_cost_,
                                                                   FALSE,
                                                                   Site_API.Get_Company(contract_),
                                                                   contract_,
                                                                   part_no_,
                                                                   configuration_id_,
                                                                   NULL,
                                                                   NULL,
                                                                   NULL,
                                                                   NULL,
                                                                   NULL);
   Add_Details___(cost_detail_id_, cost_detail_tab_, part_no_);

END Generate_Details_From_Total;


PROCEDURE Generate_Auto_Split_Details (
   contract_             IN VARCHAR2,
   part_no_              IN VARCHAR2,
   configuration_id_     IN VARCHAR2,
   lot_batch_no_         IN VARCHAR2,
   serial_no_            IN VARCHAR2,
   condition_code_       IN VARCHAR2,
   new_total_unit_cost_  IN NUMBER,
   cost_detail_id_       IN NUMBER)
IS
   old_total_unit_cost_    NUMBER;
   new_cost_bucket_cost_   NUMBER;
   structure_exist_        BOOLEAN := FALSE;
   attr_                   VARCHAR2(2000);
   newrec_                 TEMPORARY_PART_COST_DETAIL_TAB%ROWTYPE;
   oldrec_                 TEMPORARY_PART_COST_DETAIL_TAB%ROWTYPE;
   objid_                  TEMPORARY_PART_COST_DETAIL.objid%TYPE;
   objversion_             TEMPORARY_PART_COST_DETAIL.objversion%TYPE;
   indrec_                 Indicator_Rec;
   
   CURSOR get_cost_detail IS
      SELECT cost_detail_id, cost_detail_seq, unit_cost
        FROM TEMPORARY_PART_COST_DETAIL_TAB
       WHERE cost_detail_id = cost_detail_id_;
BEGIN
   
   -- Generate and fill the temporary_part_cost_detail_tab with existing part cost structure.
   Generate_Default_Details(contract_,
                            part_no_,
                            configuration_id_,
                            lot_batch_no_,
                            serial_no_,
                            condition_code_,
                            cost_detail_id_,
                            NULL);
   
   -- Get the previous total unit cost before updating the part cost with new cost.
   old_total_unit_cost_ := Get_Total_Unit_Cost(cost_detail_id_);
   
   -- Loop through the existing  part cost structure and proportionately distribute
   -- the new cost among the cost buckets found.
   FOR cost_rec_ IN get_cost_detail LOOP
      structure_exist_ := TRUE;
      oldrec_ := Lock_By_Keys___(cost_rec_.cost_detail_id,
                                 cost_rec_.cost_detail_seq);
      newrec_ := oldrec_;
      
      new_cost_bucket_cost_ := round((cost_rec_.unit_cost/old_total_unit_cost_) * new_total_unit_cost_, 2);
      
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('UNIT_COST', new_cost_bucket_cost_, attr_);
      
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
      Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE); -- Update by keys
   END LOOP;
   
   -- IF there is no cost structure for the part, generate the default cost structure
   -- by taking new cost as estimate material cost.
   IF NOT structure_exist_ THEN 
      Generate_Details_From_Total(contract_,
                                  part_no_,
                                  configuration_id_,
                                  new_total_unit_cost_,
                                  cost_detail_id_);
   END IF;
   
END Generate_Auto_Split_Details;


-- Cost_Detail_Id_Exist
--   Checks if a specific cost detail ID exists in the table.
@UncheckedAccess
FUNCTION Cost_Detail_Id_Exist (
   cost_detail_id_ IN NUMBER ) RETURN BOOLEAN
IS
   dummy_                NUMBER;
   cost_detail_id_exist_ BOOLEAN := FALSE;

   CURSOR exist_control IS
      SELECT 1
      FROM   TEMPORARY_PART_COST_DETAIL_TAB
      WHERE cost_detail_id = cost_detail_id_;
BEGIN
   OPEN  exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      cost_detail_id_exist_ := TRUE;
   END IF;
   CLOSE exist_control;

   RETURN cost_detail_id_exist_;
END Cost_Detail_Id_Exist;


-- Get_Total_Unit_Cost
--   Returns the total unit cost for a specific cost detail ID.
@UncheckedAccess
FUNCTION Get_Total_Unit_Cost (
   cost_detail_id_ IN NUMBER ) RETURN NUMBER
IS
   cost_detail_tab_ Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   total_unit_cost_ NUMBER;
BEGIN
   cost_detail_tab_ := Get_Details(cost_detail_id_);
   total_unit_cost_ := Get_Total_Unit_Cost___(cost_detail_tab_);
   RETURN total_unit_cost_;
END Get_Total_Unit_Cost;


-- Duplicate_Cost_Details
--   Copies the cost details from one cost detail ID to another.
PROCEDURE Duplicate_Cost_Details (
   new_cost_detail_id_ OUT NUMBER,
   cost_detail_id_     IN NUMBER,
   part_no_            IN VARCHAR2 )
IS
BEGIN

   Add_Details(new_cost_detail_id_,
               Get_Details(cost_detail_id_),
               part_no_);
END Duplicate_Cost_Details;


-- Get_Default_Accounting_Year
--   Returns the appropriate default accounting year for a specific cost bucket.
FUNCTION Get_Default_Accounting_Year (
   company_        IN VARCHAR2,
   contract_       IN VARCHAR2,
   part_no_        IN VARCHAR2,
   cost_bucket_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   public_type_db_  VARCHAR2(20);
   part_rec_        Inventory_Part_API.Public_Rec;
   accounting_year_ TEMPORARY_PART_COST_DETAIL_TAB.accounting_year%TYPE := '*';
BEGIN
   
   $IF Component_Cost_SYS.INSTALLED $THEN
      IF (nvl(cost_bucket_id_, '*') != '*') THEN
         IF (nvl(Company_Distribution_Info_API.Get_Use_Accounting_Year_Db(company_), ' ') = 'TRUE') THEN
            part_rec_ := Inventory_Part_API.Get(contract_, part_no_);
            IF ((part_rec_.inventory_valuation_method = 'ST') AND
                 (part_rec_.inventory_part_cost_level IN ('COST PER PART', 'COST PER CONFIGURATION'))) THEN
               -- must be * !
               NULL;
            ELSE
               public_type_db_ := Cost_Bucket_API.Get_Cost_Bucket_Public_Type_Db(contract_, cost_bucket_id_);                  
               Trace_SYS.Field('cost bucket public type', public_type_db_);
               -- only overhead types
               IF (nvl(public_type_db_, ' ') IN ('GENERAL', 'DELOH', 'MATOH', 'LABOROH', 'MACH1', 'MACH2', 'SUBCONTRACTING OH')) THEN
                  -- fetch current accounting year from Accrul
                  accounting_year_ := to_char(Accounting_Period_API.Get_Accounting_Year(company_, trunc(Site_API.Get_Site_Date(contract_))));
               END IF;
            END IF;
         END IF;
      END IF;      
   $END  

   RETURN accounting_year_;
END Get_Default_Accounting_Year;



