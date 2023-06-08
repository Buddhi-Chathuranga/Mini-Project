-----------------------------------------------------------------------------
--
--  Logical unit: InventoryPartPeriodHist
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220104  MAJOSE  SC21R2-5107, Get rid of string manipulations in New() and Modify().
--  200702  DiJwlk  Bug 154639 (SCZ-10401), Modified Get_Avg_Inventory_Value() and Get_Issued_Value() by adding UncheckedAccess annotation
--  171019  MAJOSE  STRMF-15603, Added functions Get_Total_Received_Qty and Get_Total_Issued_Qty.
--  130911  PraWlk  Bug 107032, Modified Get_Total_Received() and Get_Total_Issued() by splitting the cursor get_total into two separete  
--  130911          cursors to execute depending on if any value for configuration_id_ is passed in the parameter.
--  111202  GayDLK  Bug 99977, Modified Get_Avg_Inventory_Value() and Get_Issued_Value() by passing the default condition
--  111202          code as the condition code value for Inventory_Part_Unit_Cost_API.Get_Default_Details() instead of NULL.          
--  110812  Asawlk  Bug 98035, Modified cursor Find_Latest_Qty_Onhand in Get_Previous_Qty_Onhand() to order the selected
--  110812          data in decsending order of end date of periods.
--  110225  ChJalk  Moved 'User Allowed Site' Default Where condition from client to base view.
--  100507  KRPELK  Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  091030  ShKolk  Bug 86768, Merge IPR to APP75 core.
--  080918  NiBalk  Bug 76761, Modified Get_Avg_Inventory_Value and Get_Issued_Value methods to avoid 
--  080918          changing the Turnover Ratio for past period even if the inventory quantity is zero. 
--  070918  NaLrlk  Bug 67467, Modified column comments of configuration_id of the view
--  070918          INVENTORY_PART_PERIOD_HIST to add CUSTOMLIST option as a reference type
--  070918          and added methods Check_Remove_Part_Config__, Do_Remove_Part_Config__
--  070918          and Remove_Part_Config___ to handle the logic.
--  050705  SaJjlk  Removed QTY_ADJUST_RECEIPTS and QTY_ADJUST_ISSUES from method New.
--  050420  JaJalk  Removed the obsolete columns QTY_ADJUST_RECEIPTS and QTY_ADJUST_ISSUES from the view 
--  050420          and the package. And modified the cursor get_grouped_data in the method Get_History_Statistics.
--  040513  RoJalk  Bug 42037, Added parameters prev_stat_year_no_,prev_stat_period_no_ 
--  040513          and removed date_applied_ and modified the method Get_Previous_Qty_Onhand. 
--  020918  LEPESE  ***************** IceAge Merge Start *********************
--  020426  ANHOSE  Bug Id 26791. Added stat_year_no_ and stat_period_no_ to Get_Previous_Qty_Onhand.
--  020918  LEPESE  ***************** IceAge Merge End ***********************
--  020816  LEPESE  Replaced calls to Inventory_Part_Config_API.Get_Inventory_Value_By_Method
--                  to instead use Inventory_Part_Unit_Cost_API.Get_Inventory_Value_By_Config.
--  **********************  Take Off Baseline  ***********************************
--  010109  SHVE    Added DESC clause to cursor in method Get_Previous_Qty_Onhand.
--  001006  ANLASE  Removed overload.
--  000928  ANLASE  Changed spelling to Configuration ID.
--  000925  ANLASE  Overload on methods Get_Qty_Onhand, Get_Total_Issued and Get_Total_Received.
--  000921  ANLASE  Modified function Check_Exist to return varchar, not boolean.
--  000920  ANLASE  CTO-adaptations. Added Configuration_Id as key column.
--                  Removed REF from inventory_part in view comments, added REF to inventory_part_config.
--  000811  LEPE    Replaced call to Inventory_Part_API.Get_Inventory_Value_By_Method
--                  by call to Inventory_Part_Config_API.Get_Inventory_Value_By_Method.
--  000417  NISOSE  Added General_SYS.Init_Method in Get_History_Statistics and
--                  Get_Previous_Qty_Onhand.
--  000413  NISOSE  Cleaned-up General_SYS.Init_Method.
--  000229  JOHW    Added sum on cursor in Get_Inventory_Value.
--  000225  JOHW    Removed the use of to_date.
--  990919  ROOD    Replaced Utility_SYS.Get_User with Fnd_Session_API.Get_Fnd_User.
--  990810  ASJA    Bug fix 11158, Added a code to replace the value with 0 for avg_mtd_issues_ if
--                  it gets a negative value in Get_History_Statistics.
--  990505  SHVE    Replace call to Inventory_Part_API.Get_Inventory_Value by
--                  Get_Inventory_Value_By_Method.
--  990504  SHVE    General performance improvements.
--  990415  SHVE    Upgraded to performance optimized template.
--  990224  JOKE    Removed method: Check_Period_Exists, Count_Parts_In_Period
--                  and Update_Part_History.
--  990212  JOKE    Added new method: get_Previous_Qty_Onhand.
--  990209  ROOD    Replaced call to obsolete method Check_Inv_Hist_Flag
--                  with the new Get_Invent_Stat_Direction_Db.
--  990114  FRDI    Changed Sysdate to site dependent 'sysdate' - Site_API.Get_Site_Date(contract)
--  980305  JICE    Bug 3651, JOHNIs 10.3.1-changes: Major changes in inventory
--                  statistics batch.
--                  Added functions Count_Parts_In_Period and Check_Exist;
--                  Modified Update_Part_History.
--  980227  JOHO    Correction of Heat Issue 3569.
--  971201  GOPE    Upgrade to fnd 2.0
--  970405  JOKE    Removed scrap characters.
--  970319  GOPE/NAVE Added methods Get_Total_Issues, Get_Total_Receipts
--  970313  MAGN    Changed tablename from mpc_part_period_history to inventory_part_period_hist_tab.
--  970220  JOKE    Uses column rowversion as objversion (timestamp).
--  970116  MAOR    Made changes in Update_Part_History. (changed call to
--                  check_exist___, use Mpccom_Transaction_Code_API.Get_Inv_Hist_Flag
--                  instead of Get_Inv_Hist_Flag.
--  961217  JOKE    Changed Get_Avg_Inventory_Value so that if number_of_periods_
--                  is zero the function will just return zero.
--  961214  MAOR    Removed user_ from New and Insert_Period_History.
--  961213  AnAr    Modified file for new template standard.
--  961205  MAOR    Changed order of parameters in call to
--                  Inventory_Part_Cost_API.Get_Standard_Total. Also changed name
--                  to Get_Total_Standard.
--  961124  MAOR    Modified file to Rational Rose Model and Workbench.
--  961122  MAOR    Moved Insert_Period_History__ to LU InventoryPart.
--                  Added function Get_Qty_Onhand and Check_Period_Exists and
--                  procedure New.
--  961015  MAOR    Added user_ in procedure Update_Part_History,
--                  Insert_Period_History__. Added check if batch_user is in
--                  attr_ in procedure Unpack_Check_Insert__. Also added check
--                  is User_Allowed_Site.Authorized in Unpack_Check_Insert__.
--  961014  GOPE    Changed the procedure Get_Avg_Inventory_Value to count on the
--                  total nr of periods.
--  960923  MAOR    Removed procedure Inventory_Abc_Analysis.
--  960918  JICE    Added procedures Get_Avg_Inventory_Value, Get_Inventory_Value
--                  and Get_Issued_Value
--  960906  MAOR    Translated dbms_output.put_line.
--  960829  MAOR    Added procedure Inventory_Abc_Analysis.
--  960829  JOKE    Splitted Get_Average procedure into two functions.
--  960827  MAOR    Moved call of Inventory_Part_API.Exist to be after loop in
--                  procedure Unpack_Check_Insert___.
--  960821  MAOR    Added procedure Insert_Period_History__ and
--                  Update_Part_History. Function Check_If_Period_History_Exists.
--  960802  JOKE    Added procedure get_average.
--  960702  HARH    Added procedure Get_History_Statistics
--  960612  JOBE    CREATE
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Remove_Part_Config___
--   This procedure will perform a check against InventoryTransactionHist
--   and perform actions 'CHECK' or 'DO' accordingly if no records were found
--   in InventoryTransactionHist for the part configuration.
PROCEDURE Remove_Part_Config___ (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   action_           IN VARCHAR2 )
IS
   objid_      INVENTORY_PART_PERIOD_HIST.objid%TYPE;
   objversion_ INVENTORY_PART_PERIOD_HIST.objversion%TYPE;

   CURSOR get_records IS
      SELECT *
      FROM   INVENTORY_PART_PERIOD_HIST_TAB
      WHERE  contract         = contract_
      AND    part_no          = part_no_
      AND    configuration_id = configuration_id_ ;
   
   CURSOR get_records_and_lock IS
      SELECT *
      FROM   INVENTORY_PART_PERIOD_HIST_TAB
      WHERE  contract         = contract_
      AND    part_no          = part_no_
      AND    configuration_id = configuration_id_
      FOR UPDATE;
BEGIN
   IF (Inventory_Transaction_Hist_API.Check_Part_Exist(contract_, part_no_, configuration_id_) = 'FALSE') THEN
      IF (action_ = 'CHECK') THEN
         FOR record_ IN get_records LOOP
            Check_Delete___(record_);
         END LOOP;
      ELSIF (action_ = 'DO') THEN
         FOR record_ IN get_records_and_lock LOOP
            Check_Delete___(record_);
            Get_Id_Version_By_Keys___(objid_, objversion_, record_.contract, record_.part_no,
                                      record_.configuration_id, record_.stat_year_no, record_.stat_period_no);
            Delete___(objid_, record_);
         END LOOP;
      END IF;
   END IF;
END Remove_Part_Config___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT inventory_part_period_hist_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(newrec_, indrec_, attr_);

   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User,newrec_.contract);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Check_Remove_Part_Config__
--   This procedure will call the method Remove_Part_Config___ to perform a
--   check to remove records from InventoryPartPeriodHist with respect to the
--   part configuration.
PROCEDURE Check_Remove_Part_Config__ (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2 )
IS
BEGIN
   Remove_Part_Config___(contract_, part_no_, configuration_id_, 'CHECK');
END Check_Remove_Part_Config__;


-- Do_Remove_Part_Config__
--   This procedure will call the method Remove_Part_Config___ to remove records
--   from InventoryPartPeriodHist with respect to the part configuration.
PROCEDURE Do_Remove_Part_Config__ (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2 )
IS
BEGIN
   Remove_Part_Config___(contract_, part_no_, configuration_id_, 'DO');
END Do_Remove_Part_Config__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- New
--   Inserts a new instance of inventory part period history.
PROCEDURE New (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   stat_year_no_     IN NUMBER,
   stat_period_no_   IN NUMBER,
   second_commodity_ IN VARCHAR2,
   qty_onhand_       IN NUMBER )
IS
   newrec_           INVENTORY_PART_PERIOD_HIST_TAB%ROWTYPE;
BEGIN
   newrec_.contract              := contract_;
   newrec_.part_no               := part_no_;
   newrec_.configuration_id      := configuration_id_;
   newrec_.stat_year_no          := stat_year_no_;
   newrec_.stat_period_no        := stat_period_no_;
   newrec_.second_commodity      := second_commodity_;
   newrec_.beg_balance           := qty_onhand_;
   newrec_.create_date           := Site_API.Get_Site_Date(contract_);
   newrec_.qty_onhand            := qty_onhand_;
   newrec_.mtd_adjust            := 0;
   newrec_.count_adjust          := 0;
   newrec_.mtd_receipts          := 0;
   newrec_.count_receipts        := 0;
   newrec_.mtd_issues            := 0;
   newrec_.count_issues          := 0;
   newrec_.mtd_abnormal_issues   := 0;
   newrec_.count_abnormal_issues := 0;
   New___(newrec_);
END New;


-- Get_Average_Issues
--   Fetches and calculates Avg_Issues.
@UncheckedAccess
FUNCTION Get_Average_Issues (
   contract_         IN   VARCHAR2,
   part_no_          IN   VARCHAR2,
   configuration_id_ IN   VARCHAR2,
   stat_year_no_     IN   NUMBER,
   stat_period_no_   IN   NUMBER,
   mtd_issues_       IN   NUMBER ) RETURN NUMBER
IS
   lu_rec_             INVENTORY_PART_PERIOD_HIST_TAB%ROWTYPE;
   avg_issues_         NUMBER;
BEGIN
   lu_rec_ := Get_Object_By_Keys___(contract_, part_no_, configuration_id_, stat_year_no_, stat_period_no_);
   IF (lu_rec_.part_no IS NULL) THEN
      avg_issues_   := NULL;
   ELSE
     IF (lu_rec_.count_issues = 0) THEN
        avg_issues_ := mtd_issues_;
     ELSE
        avg_issues_ := mtd_issues_ / nvl(lu_rec_.count_issues + lu_rec_.count_abnormal_issues,1);
     END IF;
   END IF;
   RETURN avg_issues_;
END Get_Average_Issues;


-- Get_Average_Receipts
--   Calculates Avg_receipts.
@UncheckedAccess
FUNCTION Get_Average_Receipts (
   contract_         IN  VARCHAR2,
   part_no_          IN  VARCHAR2,
   configuration_id_ IN  VARCHAR2,
   stat_year_no_     IN  NUMBER,
   stat_period_no_   IN  NUMBER,
   mtd_receipts_     IN  NUMBER ) RETURN NUMBER
IS
   avg_receipts_       NUMBER;
   lu_rec_             INVENTORY_PART_PERIOD_HIST_TAB%ROWTYPE;
BEGIN
   lu_rec_ := Get_Object_By_Keys___(contract_, part_no_, configuration_id_, stat_year_no_, stat_period_no_);
   IF (lu_rec_.part_no IS NULL) THEN
      avg_receipts_ := NULL;
   ELSE
     IF (lu_rec_.count_receipts = 0) THEN
        avg_receipts_ := mtd_receipts_;
     ELSE
        avg_receipts_ := mtd_receipts_ / nvl(lu_rec_.count_receipts,1);
     END IF;
   END IF;
   RETURN avg_receipts_;
END Get_Average_Receipts;


PROCEDURE Get_History_Statistics (
   count_periods_       OUT NUMBER,
   stddev_mtd_issues_   OUT NUMBER,
   avg_mtd_issues_      OUT NUMBER,
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   configuration_id_    IN VARCHAR2,
   periods_             IN  NUMBER )
IS
   begin_date_first_    DATE;
   begin_date_last_     DATE;

   CURSOR get_grouped_data IS
      SELECT NVL(COUNT(mtd_issues),0),
             NVL(STDDEV(mtd_issues),0),
             NVL(AVG(mtd_issues),0)
       FROM INVENTORY_PART_PERIOD_HIST_TAB
       WHERE part_no          = part_no_
         AND contract         = contract_
         AND configuration_id = configuration_id_
         AND (stat_year_no,stat_period_no) IN
             (SELECT stat_year_no,stat_period_no FROM STATISTIC_PERIOD_PUB
              WHERE Trunc(begin_date)       >= Trunc(begin_date_first_)
                AND Trunc(begin_date)       <= Trunc(begin_date_last_));

BEGIN
   count_periods_          := 0;
   stddev_mtd_issues_      := 0.0;
   avg_mtd_issues_         := 0.0;

   -- Retrieve the Begin_dates for the first and last period
   -- in the desired interval.
   Statistic_Period_API.Get_Begin_Dates(begin_date_first_, begin_date_last_, periods_);

   OPEN  get_grouped_data;
   FETCH get_grouped_data
   INTO  count_periods_,
         stddev_mtd_issues_,
         avg_mtd_issues_;
   CLOSE get_grouped_data;
   IF avg_mtd_issues_ < 0 THEN
      avg_mtd_issues_ := 0;
   END IF;

END Get_History_Statistics;


-- Get_Avg_Inventory_Value
--   Fetches and calculates Avg_value for a specified statistic_period.
@UncheckedAccess
FUNCTION Get_Avg_Inventory_Value (
 contract_            IN VARCHAR2,
 part_no_             IN VARCHAR2,
 configuration_id_    IN VARCHAR2,
 from_stat_year_no_   IN NUMBER,
 from_stat_period_no_ IN NUMBER,
 to_stat_year_no_     IN NUMBER,
 to_stat_period_no_   IN NUMBER ) RETURN NUMBER
IS
   avg_value_      NUMBER;
   total_standard_ NUMBER;
   no_of_periods_  NUMBER;

   cost_detail_tab_       Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;

   CURSOR get_avg_val IS
    SELECT (SUM(qty_onhand) * total_standard_)/no_of_periods_
    FROM INVENTORY_PART_PERIOD_HIST_TAB
    WHERE part_no = part_no_
    AND contract = contract_
    AND configuration_id = configuration_id_
    AND ((stat_year_no > from_stat_year_no_ AND stat_year_no < to_stat_year_no_)
    OR (stat_year_no = from_stat_year_no_  AND stat_year_no < to_stat_year_no_ AND stat_period_no >= from_stat_period_no_)
    OR (stat_year_no = to_stat_year_no_ AND stat_year_no > from_stat_year_no_ AND stat_period_no <= to_stat_period_no_)
    OR (stat_year_no = to_stat_year_no_ AND stat_year_no = from_stat_year_no_ AND stat_period_no >= from_stat_period_no_ AND stat_period_no <= to_stat_period_no_));

BEGIN

   total_standard_ := Inventory_Part_Unit_Cost_API.Get_Inventory_Value_By_Method(contract_,
                                                                                 part_no_,
                                                                                 configuration_id_,
                                                                                 NULL,
                                                                                 NULL);
   IF (total_standard_ = 0) THEN
      cost_detail_tab_ := Inventory_Part_Unit_Cost_API.Get_Default_Details(contract_,
                                                                           part_no_,
                                                                           configuration_id_,
                                                                           NULL,
                                                                           NULL,
                                                                           Condition_Code_API.Get_Default_Condition_Code,
                                                                           NULL);
      total_standard_ :=  Inventory_Part_Unit_Cost_API.Get_Total_Unit_Cost(cost_detail_tab_);                                       
   END IF;                  

   no_of_periods_ := Statistic_Period_API.Get_Num_Of_Periods(from_stat_year_no_,
                                                             from_stat_period_no_,
                                                             to_stat_year_no_,
                                                             to_stat_period_no_);

   if (no_of_periods_ = 0) THEN
      RETURN 0;
   END IF;

   OPEN get_avg_val;
   FETCH get_avg_val INTO avg_value_;
   IF get_avg_val%NOTFOUND THEN
      avg_value_ := 0;
   END IF;

   CLOSE get_avg_val;

   RETURN avg_value_;

END Get_Avg_Inventory_Value;


-- Get_Inventory_Value
--   Returns inventory value within a specified Statistic_period.
@UncheckedAccess
FUNCTION Get_Inventory_Value (
 contract_            IN VARCHAR2,
 part_no_             IN VARCHAR2,
 configuration_id_    IN VARCHAR2,
 from_stat_year_no_   IN NUMBER,
 from_stat_period_no_ IN NUMBER,
 to_stat_year_no_     IN NUMBER,
 to_stat_period_no_   IN NUMBER ) RETURN NUMBER
IS
   value_          NUMBER;
   total_standard_ NUMBER;

   CURSOR get_val IS
    SELECT Sum(qty_onhand) * total_standard_
    FROM INVENTORY_PART_PERIOD_HIST_TAB
    WHERE part_no = part_no_
    AND contract = contract_
    AND configuration_id = configuration_id_
    AND ((stat_year_no > from_stat_year_no_ AND stat_year_no < to_stat_year_no_)
    OR (stat_year_no = from_stat_year_no_  AND stat_year_no < to_stat_year_no_ AND stat_period_no >= from_stat_period_no_)
    OR (stat_year_no = to_stat_year_no_ AND stat_year_no > from_stat_year_no_ AND stat_period_no <= to_stat_period_no_)
    OR (stat_year_no = to_stat_year_no_ AND stat_year_no = from_stat_year_no_ AND stat_period_no >= from_stat_period_no_ AND stat_period_no <= to_stat_period_no_));

BEGIN
   total_standard_ := Inventory_Part_Unit_Cost_API.Get_Inventory_Value_By_Config(contract_,
                                                                                 part_no_,
                                                                                 configuration_id_);

   OPEN get_val;
   FETCH get_val INTO value_;
   IF get_val%NOTFOUND THEN
      value_ := 0;
   END IF;
   CLOSE get_val;
   RETURN value_;
END Get_Inventory_Value;


-- Get_Issued_Value
--   Returns total issued within a specified statistic_period.
@UncheckedAccess
FUNCTION Get_Issued_Value (
 contract_            IN VARCHAR2,
 part_no_             IN VARCHAR2,
 configuration_id_    IN VARCHAR2,
 from_stat_year_no_   IN NUMBER,
 from_stat_period_no_ IN NUMBER,
 to_stat_year_no_     IN NUMBER,
 to_stat_period_no_   IN NUMBER ) RETURN NUMBER
IS
   total_issued_   NUMBER;
   total_standard_ NUMBER;
   cost_detail_tab_       Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;

   CURSOR get_iss_val IS
    SELECT SUM(mtd_issues + mtd_abnormal_issues) * total_standard_
    FROM INVENTORY_PART_PERIOD_HIST_TAB
    WHERE part_no = part_no_
    AND contract = contract_
    AND configuration_id = configuration_id_
    AND ((stat_year_no > from_stat_year_no_ AND stat_year_no < to_stat_year_no_)
    OR (stat_year_no = from_stat_year_no_  AND stat_year_no < to_stat_year_no_ AND stat_period_no >= from_stat_period_no_)
    OR (stat_year_no = to_stat_year_no_ AND stat_year_no > from_stat_year_no_ AND stat_period_no <= to_stat_period_no_)
    OR (stat_year_no = to_stat_year_no_ AND stat_year_no = from_stat_year_no_ AND stat_period_no >= from_stat_period_no_ AND stat_period_no <= to_stat_period_no_));

BEGIN

   total_standard_ := Inventory_Part_Unit_Cost_API.Get_Inventory_Value_By_Method(contract_,
                                                                                 part_no_,
                                                                                 configuration_id_,
                                                                                 NULL,
                                                                                 NULL);
   IF (total_standard_ = 0) THEN
      cost_detail_tab_ := Inventory_Part_Unit_Cost_API.Get_Default_Details(contract_,
                                                                           part_no_,
                                                                           configuration_id_,
                                                                           NULL,
                                                                           NULL,
                                                                           Condition_Code_API.Get_Default_Condition_Code,
                                                                           NULL);
      total_standard_ :=  Inventory_Part_Unit_Cost_API.Get_Total_Unit_Cost(cost_detail_tab_);                                       
   END IF;                  

   OPEN get_iss_val;
   FETCH get_iss_val INTO total_issued_;
   IF get_iss_val%NOTFOUND THEN
      total_issued_ := 0;
   END IF;
   CLOSE get_iss_val;
   RETURN total_issued_;
END Get_Issued_Value;


-- Get_Total_Issued
--   Return the quantity issued for a period or year.
--   If no period is specified then the issues for the whole year is returned.
@UncheckedAccess
FUNCTION Get_Total_Issued (
   contract_          IN VARCHAR2,
   part_no_           IN VARCHAR2,
   configuration_id_  IN VARCHAR2,
   year_              IN NUMBER,
   period_            IN NUMBER DEFAULT Null ) RETURN NUMBER
IS
   total_issues_ NUMBER := 0;

   -- if any value for configuration_id_ is passed in the parameter.
   CURSOR get_total IS
      SELECT SUM(mtd_issues + mtd_abnormal_issues)
        FROM INVENTORY_PART_PERIOD_HIST_TAB
       WHERE part_no = part_no_
         AND contract = contract_
         AND stat_year_no = year_
         AND stat_period_no = NVL(period_, stat_period_no);

   CURSOR get_total_config IS
      SELECT SUM(mtd_issues + mtd_abnormal_issues)
        FROM INVENTORY_PART_PERIOD_HIST_TAB
       WHERE configuration_id = configuration_id_ 
         AND part_no = part_no_
         AND contract = contract_
         AND stat_year_no = year_
         AND stat_period_no = NVL(period_, stat_period_no);

BEGIN
   IF (configuration_id_ IS NULL) THEN
      OPEN get_total;
      FETCH get_total INTO total_issues_;
      CLOSE get_total;
   ELSE
      OPEN get_total_config;
      FETCH get_total_config INTO total_issues_;
      CLOSE get_total_config;
   END IF;

   RETURN total_issues_;
END Get_Total_Issued;


-- Get_Total_Received
--   Return the quantity received for a period or year.
--   If no period is specified then the receipts for the whole year is returned.
@UncheckedAccess
FUNCTION Get_Total_Received (
   contract_          IN VARCHAR2,
   part_no_           IN VARCHAR2,
   configuration_id_  IN VARCHAR2,
   year_              IN NUMBER,
   period_            IN NUMBER DEFAULT Null ) RETURN NUMBER
IS
   total_receipts_ NUMBER := 0;

   -- if any value for configuration_id_ is passed in the parameter.
   CURSOR get_total IS
      SELECT sum(mtd_receipts)
        FROM INVENTORY_PART_PERIOD_HIST_TAB
       WHERE part_no = part_no_
         AND contract = contract_
         AND stat_year_no = year_
         AND stat_period_no = NVL(period_, stat_period_no);

   CURSOR get_total_config IS
   SELECT sum(mtd_receipts)
     FROM INVENTORY_PART_PERIOD_HIST_TAB
    WHERE configuration_id = configuration_id_
      AND part_no = part_no_
      AND contract = contract_
      AND stat_year_no = year_
      AND stat_period_no = NVL(period_, stat_period_no);

BEGIN
   IF (configuration_id_ IS NULL) THEN
      OPEN get_total;
      FETCH get_total INTO total_receipts_;
      CLOSE get_total;
   ELSE
      OPEN get_total_config;
      FETCH get_total_config INTO total_receipts_;
      CLOSE get_total_config;
   END IF;

   RETURN total_receipts_;
END Get_Total_Received;


-- Get_Previous_Qty_Onhand
--   Get Qty On hand for the latest period.
PROCEDURE Get_Previous_Qty_Onhand (
   qty_onhand_          OUT NUMBER,
   stat_year_no_        OUT NUMBER,
   stat_period_no_      OUT NUMBER,
   contract_            IN  VARCHAR2,
   part_no_             IN  VARCHAR2,
   configuration_id_    IN  VARCHAR2,
   prev_stat_year_no_   IN  NUMBER,
   prev_stat_period_no_ IN  NUMBER )
IS
   CURSOR Get_Qty_Onhand IS
      SELECT qty_onhand,
             stat_year_no,
             stat_period_no
      FROM   INVENTORY_PART_PERIOD_HIST_TAB
      WHERE  contract         = contract_
      AND    part_no          = part_no_
      AND    configuration_id = configuration_id_
      AND    stat_year_no     = prev_stat_year_no_
      AND    stat_period_no   = prev_stat_period_no_;

   CURSOR Find_Latest_Qty_Onhand IS
      SELECT a.qty_onhand,
             a.stat_year_no,
             a.stat_period_no
      FROM   INVENTORY_PART_PERIOD_HIST_TAB a, statistic_period_pub b
      WHERE  a.contract         = contract_
      AND    a.part_no          = part_no_
      AND    a.configuration_id = configuration_id_
      AND    a.stat_year_no     = b.stat_year_no
      AND    a.stat_period_no   = b.stat_period_no
      ORDER BY b.end_date DESC;
BEGIN

   OPEN Get_Qty_Onhand;
   FETCH Get_Qty_Onhand INTO qty_onhand_, stat_year_no_, stat_period_no_;

   -- IF no transaction at all were made the previous period.
   IF (Get_Qty_Onhand%NOTFOUND) THEN
      OPEN Find_Latest_Qty_Onhand;
      FETCH Find_Latest_Qty_Onhand INTO qty_onhand_, stat_year_no_, stat_period_no_;
      IF (Find_Latest_Qty_Onhand%NOTFOUND) THEN
         qty_onhand_ := 0;
         stat_year_no_ := prev_stat_year_no_;
         stat_period_no_ := prev_stat_period_no_;
      END IF;
      CLOSE Find_Latest_Qty_Onhand;
   END IF;
   CLOSE Get_Qty_Onhand;
END Get_Previous_Qty_Onhand;


-- Modify
--   Public Modify Method.
PROCEDURE Modify (
   contract_              IN VARCHAR2,
   part_no_               IN VARCHAR2,
   configuration_id_      IN VARCHAR2,
   stat_year_no_          IN NUMBER,
   stat_period_no_        IN NUMBER,
   second_commodity_      IN VARCHAR2,
   mtd_adjust_            IN NUMBER,
   count_adjust_          IN NUMBER,
   mtd_receipts_          IN NUMBER,
   count_receipts_        IN NUMBER,
   mtd_issues_            IN NUMBER,
   count_issues_          IN NUMBER,
   mtd_abnormal_issues_   IN NUMBER,
   count_abnormal_issues_ IN NUMBER,
   qty_onhand_            IN NUMBER )
IS
   newrec_     INVENTORY_PART_PERIOD_HIST_TAB%ROWTYPE;
BEGIN
   newrec_ := Get_Object_By_Keys___(contract_, part_no_, configuration_id_, stat_year_no_, stat_period_no_);

   newrec_.create_date           := Site_API.Get_Site_Date(contract_);
   newrec_.second_commodity      := second_commodity_;
   newrec_.mtd_adjust            := mtd_adjust_;
   newrec_.count_adjust          := count_adjust_;
   newrec_.mtd_receipts          := mtd_receipts_;
   newrec_.count_receipts        := count_receipts_;
   newrec_.mtd_issues            := mtd_issues_;
   newrec_.count_issues          := count_issues_;
   newrec_.mtd_abnormal_issues   := mtd_abnormal_issues_;
   newrec_.count_abnormal_issues := count_abnormal_issues_;
   newrec_.qty_onhand            := qty_onhand_;
   
   Modify___(newrec_);
END Modify;


-- Check_Exist
--   Public check exist
@UncheckedAccess
FUNCTION Check_Exist (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   stat_year_no_     IN NUMBER,
   stat_period_no_   IN NUMBER ) RETURN  VARCHAR2
IS
BEGIN
   IF (Check_Exist___(contract_,part_no_,configuration_id_,stat_year_no_,stat_period_no_)) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Check_Exist;


@UncheckedAccess
FUNCTION Period_Exist (
   contract_         IN VARCHAR2,
   stat_year_no_     IN NUMBER,
   stat_period_no_   IN NUMBER ) RETURN BOOLEAN
IS
   dummy_        NUMBER;
   period_exist_ BOOLEAN := FALSE;

   CURSOR exist_control IS
      SELECT 1
        FROM INVENTORY_PART_PERIOD_HIST_TAB
       WHERE contract       = contract_
         AND stat_year_no   = stat_year_no_
         AND stat_period_no = stat_period_no_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      period_exist_ := TRUE;
   END IF;
   CLOSE exist_control;
   RETURN(period_exist_);
END Period_Exist;

@UncheckedAccess
FUNCTION Get_Total_Qty_Onhand (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   stat_year_no_     IN NUMBER,
   stat_period_no_   IN NUMBER ) RETURN NUMBER
IS
   temp_ INVENTORY_PART_PERIOD_HIST_TAB.qty_onhand%TYPE;
   CURSOR get_attr IS
      SELECT SUM(qty_onhand)
      FROM INVENTORY_PART_PERIOD_HIST_TAB
      WHERE (configuration_id = configuration_id_ OR configuration_id_ IS NULL)
      AND   contract       = contract_
      AND   part_no        = part_no_
      AND   stat_year_no   = stat_year_no_
      AND   stat_period_no = stat_period_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Total_Qty_Onhand;

@UncheckedAccess
FUNCTION Get_Total_Received_Qty (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   stat_year_no_     IN NUMBER,
   stat_period_no_   IN NUMBER ) RETURN NUMBER
IS
   temp_ INVENTORY_PART_PERIOD_HIST_TAB.mtd_receipts%TYPE;
   CURSOR get_attr IS
      SELECT SUM(mtd_receipts)
      FROM INVENTORY_PART_PERIOD_HIST_TAB
      WHERE (configuration_id = configuration_id_ OR configuration_id_ IS NULL)
      AND   contract       = contract_
      AND   part_no        = part_no_
      AND   stat_year_no   = stat_year_no_
      AND   stat_period_no = stat_period_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Total_Received_Qty;

@UncheckedAccess
FUNCTION Get_Total_Issued_Qty (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   stat_year_no_     IN NUMBER,
   stat_period_no_   IN NUMBER ) RETURN NUMBER
IS
   temp_ INVENTORY_PART_PERIOD_HIST_TAB.mtd_issues%TYPE;
   CURSOR get_attr IS
      SELECT SUM(mtd_issues + mtd_abnormal_issues)
      FROM INVENTORY_PART_PERIOD_HIST_TAB
      WHERE (configuration_id = configuration_id_ OR configuration_id_ IS NULL)
      AND   contract       = contract_
      AND   part_no        = part_no_
      AND   stat_year_no   = stat_year_no_
      AND   stat_period_no = stat_period_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Total_Issued_Qty;
