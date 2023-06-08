-----------------------------------------------------------------------------
--
--  Logical unit: InventoryValueCalc
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  150512  IsSalk  KES-421, Passed new parameter to Inventory_Transaction_Hist_API.New().
--  140626  Asawlk  Bug 117596, Modified Initialize_Part_Hist_Period___() to set the last_stat_period_end_date_ to the day prior
--  140626          to the begin date of the period in question if it is NULL. 
--  130910  ChJalk  EBALL-144, Added NVL to the value qty_at_customer in the view INVENTORY_PART_VALUE_SNAPSHOT.
--  130801  ChJalk  TIBE-888, Removed the global variables first_calendar_date_ and last_calendar_date_.
--  130515  Asawlk  EBALL-37, Added new views inventory_value_calc_local_10 and inventory_value_calc_local_11.  Views inventory_part_value_intermed 
--  130515          and invepart_value_detail_intermed were replaced with views inventory_part_value_snapshot and invepart_value_detail_snapshot respectively.
--  130515          Creation of dummy views for inventory_part_value_snapshot and invepart_value_detail_snapshot was removed. Modified Modify_Inventory_Value___
--  130515          by reanming variable our_consign_direction_ to qty_at_customer_direction_. 
--  130514  Asawlk  EBALL-37, Modified Modify_Inventory_Value___() by re-structuring the conditions of defining 
--  130514          vendor consignment and customer consingment.
--  130508  Asawlk  EBALL-37, Replaced the reference towards Transit_Qty_Direction_API with Stock_Quantity_Direction_API in Modify_Inventory_Value___. 
--  121004  RoJalk  Bug 104595, Modified Calculate_Inventory_Value() by adding new default parameters max_date_applied_ and execution_offset_ and  
--  121004          using them when calculating inventory value. Also modified Validate_Params() and Calculate_Invent_Value_Priv__() accordingly.  
--  110622  Asawlk  Bug 97667, Modified Initialize_Part_Hist_Period___() to check against end_date of a period when
--  110622          creating new Inventory Part Period History records.
--  110203  KiSalk  Added 'User Allowed Site' condition to INVENTORY_PART_VALUE_SNAPSHOT and INVEPART_VALUE_DETAIL_SNAPSHOT.
--  100630  MaEelk  Removed the reference to inventory_part_stock_Owner_tab in inventory_value_calc_local_7.
--  100505  KRPELK  Merge Rose Method Documentation.
--  100406  MaRalk  Modified reference by name method call to Inventory_Transaction_Hist_API.New
--  100406          within Create_Value_Diff_Trans___ method.
--------------------------------------- 14.0.0 --------------------------------
--  091217  PraWlk  Bug 84712, Replaced inventory_part_cost_fifo_tab with inventory_part_cost_fifo_pub in views
--  091217          inventory_value_calc_local_2 and inventory_value_calc_local_6.
--  091210  LEPESE  Bug 85944, added call to method Inventory_Transaction_Hist_API.Include_Event_In_Statistics
--  091210          from Modify_Part_History___. Changed logic in Modify_Part_History___ to decide whether a
--  091210          specific inventory transaction should affect the event counters or not. This is not based
--  091210          on the output from Inventory_Transaction_Hist_API.Include_Event_In_Statistics.
--  091030  ShKolk  Bug 86768, Merge IPR to APP75 core.
--  090902  SuSalk  Bug 85609, Modified views inventory_part_value_intermed, inventory_part_value_snapshot,
--  090902          invepart_value_detail_intermed, and inventory_value_detail_snapshot. 
--  080901  NiBalk  Bug 75178, Modified Create_Value_Diff_Trans___() to add an OUT parameter to Modify_Date_Applied.
--  071026  MAEELK  Bug 68104, Modified Validate_Params and Calculate_Inventory_Value methods to
--  071026          consider wildcards in site. Modified Calculate_Inventory_Value method to use
--  071026          BULK COLLECT INTO instead of cursor for loop.
--  071019  MAEELK  Bug 67573, Added method Financial_Period_Is_Open___. Call this method from
--  071019          Initialize_Inv_Value_Period___ and pass result to Remove_Value_Part_Record___.
--  070605  LEPESE  Modifications in method Modify_Inventory_Value___ to update qty_in_transit
--  070605          on separate record when location_group != transit_location_group. This
--  070605          partly replaces the previous change, makes it more dynamic.
--  070530  LEPESE  Modifications in method Modify_Inventory_Value___ to update qty_in_transit
--  070530          on separate record for location group 'INT ORDER TRANSIT'.
--  070508  NaWilk  B143833, Modified message CALCINVVALUE. 
--  070424  MaJalk  Bug 64098, Created new view inventory_value_calc_local_9. Modified 
--  070424          inventory_value_calc_local_2 and used the newly created view. Modified
--  070424          inventory_value_calc_local_6 to fetch the correct quantity.
--  061121  LEPESE  Added NVL function around waiv_dev_rej_no in method Modify_Inventory_Value___.
--  061025  LEPESE  Location Group has been added as a new key column in table
--  061025          inventory_value_part_tab. Because of this I have added location_group as 
--  061025          a parameter to a lot of method calls towards Inventory_Value_Part_API.
--  061025          Location group has been added as parameter to methods Create_Value_Diff_Trans___,
--  061025          Handle_Remaining_Values___, Remove_Value_Part_Record___ (both versions),
--  061025          Added new method Similar_Value_Part_Exist___. Logical changes in methods
--  061025          Remove_Value_Part_Record___ (both versions) to deal with the fact that one
--  061025          record in invent_value_part_detail_tab can now belong to several records in
--  061025          inventory_value_part_tab having different location groups.
--  060810  ChJalk  Modified hard_coded dates to be able to use any calendar.
--  060309  LEPESE  Added new functions Remove_Value_Part_Record___ and 
--  060309          Non_Zero_Value_Detail_Exist___. Added call to function
--  060309          Remove_Value_Part_Record___ in procedure Initialize_Inv_Value_Period___.
--  060202  JoEd    Fixed the inventory_value_calc_local_2 and inventory_value_calc_local_6
--                  views to not cause "division by zero".
--  060123  NiDalk  Added Assert safe annotation. 
--  051222  LEPESE  Added view comments for all local views.
--  051216  LEPESE  Changed definition of view comments from dynamic to static.
--  051215  LEPESE  Added column qty_at_customer to view inventory_part_value_intermed.
--  051215          Made definition of view inventory_part_value_snapshot and
--  051215          invepart_value_detail_snapshot dynamic in order to avoid error message
--  051215          if views already exist in the database. They are not replaced in that case.
--  051215  LEPESE  Added views inventory_value_part_intermed and invepart_value_detail_intermed.
--  051213  LEPESE  Added column unit_cost to view invepart_value_detail_snapshot.
--  051208  LEPESE  Created views: inventory_value_calc_local_1,  inventory_value_calc_local_2,
--  051208                         inventory_value_calc_local_3,  inventory_value_calc_local_4,
--  051208                         inventory_value_calc_local_5,  inventory_value_calc_local_6,
--  051208                         inventory_value_calc_local_7,  inventory_value_calc_local_8,
--  051208                         inventory_part_value_snapshot, invepart_value_detail_snapshot.
--  051125  LEPESE  Change in method Modify_Inventory_Value___ to use the condition code from
--  051125          the inventory transaction history record when part cost level is COST PER
--  051125          LOT BATCH and COST PER SERIAL. 
--  051118  LEPESE  Added methods Remove_Value_Part_Record___, Handle_Remaining_Values___
--  051118          and Create_Value_Diff_Trans___.
--  051117  LEPESE  Major redesign because of new Cost Detail functionality. Methods
--  051117          Initialize_Inv_Value_Period___ and Modify_Inventory_Value___ totally rewritten.
--  050920  NiDalk  Removed unused variables.
--  050420  JaJalk  Removed the QTY_ADJUST_ISSUES QTY_ADJUST_RECEIPTS from the curser select list of 
--  050420          Get_Part_History in Modify_Part_History___ as they have been obsolete from the table. 
--  050405  AnLaSe  SCJP625: Added comment for consignment_stock for transactions DELCONF-IN and DELIVCONF.
--  050329  IsWilk  Added PROCEDURE Validate_Params to validate parameters when 
--  050329          executing the Schedule Inventory Part Statistics. 
--  041122  IsWilk  Modified the PROCEDURE Calculate_Invent_Value_Priv__ to add the removed defferred call.
--  040923  IsWilk  Modified the PROCEDURE Calculate_Invent_Value_Priv__ by removing the defferred call.
--  040820  Samnlk  Modify Calculate_Invent_Value_Priv__ use current_stat_year_no_,current_stat_period_no_
--  040820          instead of stat_year_no_,stat_period_no_.
--  040524  SHVESE  M4/Transibal Merge- Complete redesign of the method Modify_Part_History___.
--  040513  RoJalk  Bug 42037, Added parameters prev_stat_year_no_,prev_stat_period_no_ and
--  040513          removed date_applied_ and modified methods Initialize_Part_Hist_Period___ and
--  040513          Initialize_Inv_Value_Period___. Modified the method Calculate_Invent_Value_Priv__.
--  ***************************  Touchdown Merge Begin *************************
--  040115  LEPESE  Major redesign.
--  ***************************  Touchdown Merge End ***************************
--  040202  WaJalk  Bug 42272, Modified Calculate_Invent_Value_Priv__, added condition to give an error
--  040202          if matching Statistical Period is not found for a transaction.
--  040108  SaRalk  Bug 39365, Modified procedures Calculate_Inventory_Value, Calculate_Invent_Value_Priv__
--  040108          and Calculate_Up_To_Trans_Day. Moved the LOOP over user_allowed_site_pub from method
--  040108          Calculate_Invent_Value_Priv__ to method Calculate_Inventory_Value.
--  030930  SHVESE  Added logic to update the partstat and valuestat flag in inventory_transaction_hist
--  030930          for transactions that are externally owned.
--  030729  MaGulk  Merged SP4
--  030611  MaGulk  Modified Calculate_Invent_Value_Priv__ to exclude externally owned parts
--  030516  PrJalk  Bug 36428, Modified method Modify_Part_History___.
--  030217  BhRalk  Bug 35882, Modified the Method Modify_Inventory_Value___ .
--  021010  LEPESE  Added code in methods Calculate_Inventory_Value, Calculate_Up_To_Trans_Day
--                  and Calculate_Invent_Value_Priv__ in order to prevent extra periods from
--                  being created when the job is started as a part of the actual cost calculation.
--  020923  LEPESE  ***************** IceAge Merge Start *********************
--  020426  ANHO    Bug Id 26791. Added code to add periods where no transactions where created, in
--  020426          Calculate_Invent_Value_Priv__, Initialize_Part_Hist_Period___ and Initialize_Inv_Value_Period___.
--  020426  ANHO    Removed Bug fix 23818 and replaced it with the correction of bug id 26791.
--  020923  LEPESE  ***************** IceAge Merge End ***********************
--  020816  LEPESE  Replaced calls to Inventory_Part_Config_API.Get_Inventory_Value_By_Method
--                  to instead use Inventory_Part_Unit_Cost_API.Get_Inventory_Value_By_Config.
--  020619  LEPESE  Changed usage of inventory_part_config_tab to instead use a public view.
--  **********************  Take Off Baseline  ***********************************
--  010924  SaNalk  Bug fix 23818, Added while LOOP and added a call to 'Get_Previous_Period'
--                  in procedure Calculate_Invent_Value_Priv__.
--  001215  LEPE    Redesign of method Calculate_Invent_Value_Priv__ to loop over
--                  PL/SQL tables instead of having cursor FOR loops when updating.
--  001207  LEPE    Added new parameter transaction_code in call to method
--                  Mpccom_Accounting_API.Get_Inventory_Value_Direction.
--  001122  LEPE    Modifications to Modify_Inventory_Value___ for better performance
--                  and also in order to send an extra parameter when calling
--                  method Mpccom_Accounting_API.Get_Inventory_Value_Direction.
--  001017  JOKE    Added public method Is_Executing plus added validations that
--                  actual_cost_manager or another inventory_valuation isn't running
--                  in Calculate_Invent_Value_Priv__.
--  000927  JOKE    Changed parameter max_transaction_id_ in
--                  Calculate_Up_to_transaction to max_date_applied_. Also
--                  renamed the method to Calculate_Up_To_Trans_Day.
--  000925  JOKE    Added new public method Calculate_Up_to_transaction.
--  000921  JOKE    Added vendor_owned_qty and it's calculations.
--  000920  JOHW    Added configuration_id.
--  000911  LEPE    Changed package name in call to method Get_Inventory_Value_By_method.
--  000417  NISOSE  Added General_SYS.Init_Method in Calculate_Invent_Value_Priv__.
--  000217  LEPE    Redesigned cursor Get_Sites in method Calculate_Inventory_Value_Impl___
--                  to achieve better performance.
--  990919  ROOD    Replaced Utility_SYS.Get_User with Fnd_Session_API.Get_Fnd_User.
--  990520  ROOD    Added method Is_Executing___.
--  990505  SHVE    General performance improvements.
--                  Replaced selects to views with tables.
--  990414  SHVE    Upgraded to performance optimized template.
--  990404  JOKE    Added calculation of qty_in_transit and qty_at_customer.
--  990330  LEPE    Opened up the value and and statistic job for several contracts.
--  990305  JOKE    Added call to Get_Inventory_Value_Direction in Modify_inventory_Value.
--  990223  JOKE    Changed order of parameters in calls to InventoryValuePart.
--  990223  JOKE    Removed Total_Value from call to Inventory_Value_API.New.
--  990213  JOKE    Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Initialize_Part_Hist_Period___
--   This implementation methods initializes the part history period by
--   inserting all inventory parts that doesn't exist in this period.
PROCEDURE Initialize_Part_Hist_Period___ (
   contract_            IN VARCHAR2,
   stat_year_no_        IN NUMBER,
   stat_period_no_      IN NUMBER,
   prev_stat_year_no_   IN NUMBER,
   prev_stat_period_no_ IN NUMBER )
IS
   CURSOR Get_Parts IS
      SELECT part_no, configuration_id
        FROM Inventory_Part_Config_Pub
       WHERE contract = contract_
     MINUS
      SELECT part_no, configuration_id
        FROM Inventory_Part_Period_Hist_Tab
       WHERE contract       = contract_
         AND stat_year_no   = stat_year_no_
         AND stat_period_no = stat_period_no_;

   qty_onhand_                NUMBER;
   second_commodity_          VARCHAR2(5);
   last_stat_year_no_         NUMBER;
   last_stat_period_no_       NUMBER;
   year_no_                   NUMBER;
   period_no_                 NUMBER;
   previous_year_no_          NUMBER;
   previuos_period_no_        NUMBER;
   last_stat_period_end_date_ DATE;
BEGIN
   -- Loop through parts that doesn't exist in this period and add them.
   FOR part_ IN Get_Parts LOOP
      -- get values from previous period
      Inventory_Part_Period_Hist_API.Get_Previous_Qty_Onhand( qty_onhand_,
                                                              last_stat_year_no_,
                                                              last_stat_period_no_,
                                                              contract_,
                                                              part_.part_no,
                                                              part_.configuration_id,
                                                              prev_stat_year_no_,
                                                              prev_stat_period_no_ );

      second_commodity_ := Inventory_Part_API.Get_Second_Commodity( contract_,
                                                                    part_.part_no );
      year_no_          := stat_year_no_;
      period_no_        := stat_period_no_;

      -- If last stat period end date becomes NULL then we take the day prior to the begin date of the period in question.
      -- last_stat_period_end_date_ becomes NULL when there is no period defined prior to the first period in question in
      -- statistic_period_tab. 
      last_stat_period_end_date_ := NVL(Statistic_Period_API.Get_End_Date(last_stat_year_no_, last_stat_period_no_),
                                        Statistic_Period_API.Get_Begin_Date(year_no_, period_no_) - 1);

      -- If an empty previos period exists, it will be added.
      WHILE (Statistic_Period_API.Get_End_Date(year_no_, period_no_) > last_stat_period_end_date_) LOOP

         Inventory_Part_Period_Hist_API.New( contract_,
                                             part_.part_no,
                                             part_.configuration_id,
                                             year_no_,
                                             period_no_,
                                             second_commodity_,
                                             qty_onhand_ );

         Statistic_Period_API.Get_Previous_Period( previous_year_no_,
                                                   previuos_period_no_,
                                                   year_no_,
                                                   period_no_ );

         -- Exit the loop if there is no previous stat period found, which is due to period has not been defined in statistic_period_tab. 
         EXIT WHEN previous_year_no_ IS NULL OR previuos_period_no_ IS NULL;  
         
         year_no_   := previous_year_no_;
         period_no_ := previuos_period_no_;
      END LOOP;
   END LOOP;
END Initialize_Part_Hist_Period___;


-- Initialize_Inv_Value_Period___
--   This implementation methods initializes the Inventory Value Part Class
--   by inserting all inventory parts that doesn't exist in this period.
PROCEDURE Initialize_Inv_Value_Period___ (
   contract_             IN VARCHAR2,
   trans_stat_year_no_   IN NUMBER,
   trans_stat_period_no_ IN NUMBER,
   site_date_            IN DATE )
IS
   period_already_initiated_ BOOLEAN;
   exit_procedure_           EXCEPTION;
   complete_flag_db_         VARCHAR2(1);
   max_stat_year_no_         NUMBER;
   max_stat_period_no_       NUMBER;
   financial_period_is_open_ BOOLEAN;

   CURSOR get_inventory_value_part (max_existing_stat_year_no_   IN NUMBER,
                                    max_existing_stat_period_no_ IN NUMBER,
                                    contract_                    IN VARCHAR2) IS
      SELECT *
      FROM inventory_value_part_tab
      WHERE contract       = contract_
        AND stat_year_no   = max_existing_stat_year_no_
        AND stat_period_no = max_existing_stat_period_no_;

   CURSOR get_invent_value_part_detail (max_existing_stat_year_no_   IN NUMBER,
                                        max_existing_stat_period_no_ IN NUMBER,
                                        contract_                    IN VARCHAR2) IS
      SELECT *
      FROM invent_value_part_detail_tab
      WHERE contract       = contract_
        AND stat_year_no   = max_existing_stat_year_no_
        AND stat_period_no = max_existing_stat_period_no_;

   CURSOR get_missing_site_periods (max_existing_stat_year_no_   IN NUMBER,
                                    max_existing_stat_period_no_ IN NUMBER,
                                    transaction_stat_year_no_    IN NUMBER,
                                    transaction_stat_period_no_  IN NUMBER) IS
      SELECT stat_year_no, stat_period_no
        FROM statistic_period_pub
       WHERE end_date > (SELECT end_date FROM statistic_period_pub
                          WHERE stat_year_no   = max_existing_stat_year_no_
                            AND stat_period_no = max_existing_stat_period_no_)
         AND end_date <= (SELECT end_date FROM statistic_period_pub
                          WHERE stat_year_no   = transaction_stat_year_no_
                            AND stat_period_no = transaction_stat_period_no_)
       ORDER BY end_date;

   TYPE Missing_Site_Period_Tab IS TABLE OF get_missing_site_periods%ROWTYPE;

   missing_site_period_tab_ Missing_Site_Period_Tab;
BEGIN
   period_already_initiated_ := Inventory_Value_API.Check_Exist(contract_,
                                                                trans_stat_year_no_,
                                                                trans_stat_period_no_);
   IF (period_already_initiated_) THEN

      Inventory_Value_API.Reset_Complete_Flag(contract_,
                                              trans_stat_year_no_,
                                              trans_stat_period_no_);
      RAISE exit_procedure_;
   END IF;

   Inventory_Value_API.Get_Max_Year_Period(max_stat_year_no_,
                                           max_stat_period_no_,
                                           contract_);

   IF ((max_stat_year_no_ IS NULL) AND (max_stat_period_no_ IS NULL)) THEN
      -- There was no previous period for this particular site.
      Inventory_Value_API.New(contract_,
                              trans_stat_year_no_,
                              trans_stat_period_no_,
                              'N');
      RAISE exit_procedure_;
   END IF;

   OPEN get_missing_site_periods(max_stat_year_no_,
                                 max_stat_period_no_,
                                 trans_stat_year_no_,
                                 trans_stat_period_no_);
   FETCH get_missing_site_periods BULK COLLECT INTO missing_site_period_tab_;
   CLOSE get_missing_site_periods;

   IF (missing_site_period_tab_.COUNT > 0) THEN
      FOR i IN missing_site_period_tab_.FIRST..missing_site_period_tab_.LAST LOOP
         IF ((missing_site_period_tab_(i).stat_year_no   = trans_stat_year_no_) AND
             (missing_site_period_tab_(i).stat_period_no = trans_stat_period_no_)) THEN
            complete_flag_db_ := 'N';
         ELSE
            complete_flag_db_ := 'Y';
         END IF;
         Inventory_Value_API.New(contract_,
                                 missing_site_period_tab_(i).stat_year_no,
                                 missing_site_period_tab_(i).stat_period_no,
                                 complete_flag_db_);
      END LOOP;
   END IF;

   financial_period_is_open_ := Financial_Period_Is_Open___(contract_,
                                                            max_stat_year_no_,
                                                            max_stat_period_no_);

   FOR value_part_rec_ IN get_inventory_value_part (max_stat_year_no_,
                                                    max_stat_period_no_,
                                                    contract_ ) LOOP
      IF (Remove_Value_Part_Record___(value_part_rec_.contract,
                                      value_part_rec_.stat_year_no,
                                      value_part_rec_.stat_period_no,
                                      value_part_rec_.part_no,
                                      value_part_rec_.configuration_id,
                                      value_part_rec_.lot_batch_no,
                                      value_part_rec_.serial_no,
                                      value_part_rec_.condition_code,
                                      value_part_rec_.location_group,
                                      value_part_rec_.qty_waiv_dev_rej,
                                      value_part_rec_.quantity,
                                      value_part_rec_.qty_in_transit,
                                      value_part_rec_.qty_at_customer,
                                      value_part_rec_.vendor_owned_qty,
                                      financial_period_is_open_)) THEN

         Remove_Value_Part_Record___(value_part_rec_.contract,
                                     value_part_rec_.stat_year_no,
                                     value_part_rec_.stat_period_no,
                                     value_part_rec_.part_no,
                                     value_part_rec_.configuration_id,
                                     value_part_rec_.lot_batch_no,
                                     value_part_rec_.serial_no,
                                     value_part_rec_.condition_code,
                                     value_part_rec_.location_group);
      ELSE
         IF (missing_site_period_tab_.COUNT > 0) THEN
            FOR i IN missing_site_period_tab_.FIRST..missing_site_period_tab_.LAST LOOP

               Inventory_Value_Part_API.New(value_part_rec_.contract,
                                            missing_site_period_tab_(i).stat_year_no,
                                            missing_site_period_tab_(i).stat_period_no,
                                            value_part_rec_.part_no,
                                            value_part_rec_.configuration_id,
                                            value_part_rec_.lot_batch_no,
                                            value_part_rec_.serial_no,
                                            value_part_rec_.condition_code,
                                            value_part_rec_.location_group,
                                            value_part_rec_.qty_waiv_dev_rej,
                                            value_part_rec_.quantity,
                                            value_part_rec_.qty_in_transit,
                                            value_part_rec_.qty_at_customer,
                                            value_part_rec_.vendor_owned_qty,
                                            site_date_);
            END LOOP;
         END IF;
      END IF;
   END LOOP;

   FOR value_part_detail_rec_ IN get_invent_value_part_detail (max_stat_year_no_,         
                                                               max_stat_period_no_,       
                                                               contract_ )LOOP
      IF (value_part_detail_rec_.total_value = 0) THEN

         Invent_Value_Part_Detail_API.Remove(value_part_detail_rec_.contract,
                                             value_part_detail_rec_.stat_year_no,
                                             value_part_detail_rec_.stat_period_no,
                                             value_part_detail_rec_.part_no,
                                             value_part_detail_rec_.configuration_id,
                                             value_part_detail_rec_.lot_batch_no,
                                             value_part_detail_rec_.serial_no,
                                             value_part_detail_rec_.condition_code,
                                             value_part_detail_rec_.cost_source_id,
                                             value_part_detail_rec_.bucket_posting_group_id);
      ELSE
         IF (missing_site_period_tab_.COUNT > 0) THEN
            FOR i IN missing_site_period_tab_.FIRST..missing_site_period_tab_.LAST LOOP

               Invent_Value_Part_Detail_API.New(value_part_detail_rec_.contract,
                                                missing_site_period_tab_(i).stat_year_no,
                                                missing_site_period_tab_(i).stat_period_no,
                                                value_part_detail_rec_.part_no,
                                                value_part_detail_rec_.configuration_id,
                                                value_part_detail_rec_.lot_batch_no,
                                                value_part_detail_rec_.serial_no,
                                                value_part_detail_rec_.condition_code,
                                                value_part_detail_rec_.cost_source_id,
                                                value_part_detail_rec_.bucket_posting_group_id,
                                                value_part_detail_rec_.total_value,
                                                site_date_);
            END LOOP;
         END IF;
      END IF;
   END LOOP;
EXCEPTION
   WHEN exit_procedure_ THEN
      NULL;
END Initialize_Inv_Value_Period___;


-- Modify_Part_History___
--   This implementation method updates the part period history with the
--   quantity changes that were the consequence of the actual transaction.
PROCEDURE Modify_Part_History___ (
   contract_                IN VARCHAR2,
   stat_year_no_            IN NUMBER,
   stat_period_no_          IN NUMBER,
   part_no_                 IN VARCHAR2,
   configuration_id_        IN VARCHAR2,
   transaction_code_        IN VARCHAR2,
   quantity_                IN NUMBER,
   abnormal_demand_db_      IN VARCHAR2,
   source_ref1_             IN VARCHAR2,
   source_ref2_             IN VARCHAR2,
   source_ref3_             IN VARCHAR2,
   source_ref4_             IN NUMBER,
   source_ref_type_db_      IN VARCHAR2,
   date_applied_            IN DATE,
   original_transaction_id_ IN NUMBER )
IS
   CURSOR Get_Part_History IS
      SELECT second_commodity,
             beg_balance,
             count_adjust,
             count_issues,
             count_abnormal_issues,
             count_receipts,
             create_date,
             mtd_adjust,
             mtd_issues,
             mtd_abnormal_issues,
             mtd_receipts,
             qty_onhand
        FROM Inventory_Part_Period_Hist_Tab
       WHERE contract         = contract_
         AND part_no          = part_no_
         AND configuration_id = configuration_id_
         AND stat_year_no     = stat_year_no_
         AND stat_period_no   = stat_period_no_;

   parthist_                     Get_Part_History%ROWTYPE;
   second_commodity_             VARCHAR2(5);
   invent_stat_direction_db_     VARCHAR2(200);
   modification_is_needed_       BOOLEAN;
   event_counter_                NUMBER  := 0;
   include_event_in_statistics_  BOOLEAN := TRUE;
BEGIN

   -- Get Inventory Statistics direction.
   invent_stat_direction_db_ := Mpccom_Transaction_Code_API.Get_Invent_Stat_Direction_Db ( transaction_code_ );
   modification_is_needed_   := FALSE;

   IF (invent_stat_direction_db_ != 'UNAFFECTED') THEN

      OPEN  Get_Part_History;
      FETCH Get_Part_History INTO parthist_;
      CLOSE Get_Part_History;

      IF ((source_ref_type_db_ IS NOT NULL) AND (source_ref1_ IS NOT NULL)) THEN
         include_event_in_statistics_ := Inventory_Transaction_Hist_API.Include_Event_In_Statistics(contract_,
                                                                                                    part_no_,
                                                                                                    configuration_id_,
                                                                                                    source_ref1_,
                                                                                                    source_ref2_,
                                                                                                    source_ref3_,
                                                                                                    source_ref4_,
                                                                                                    source_ref_type_db_,
                                                                                                    date_applied_,
                                                                                                    invent_stat_direction_db_,
                                                                                                    quantity_,
                                                                                                    original_transaction_id_);
      END IF;

      IF (include_event_in_statistics_) THEN
         event_counter_ := 1;
      END IF;

      IF (invent_stat_direction_db_ = 'ADJUSTMENT IN') THEN
         parthist_.mtd_adjust   := parthist_.mtd_adjust + quantity_;
         parthist_.qty_onhand   := parthist_.qty_onhand + quantity_;
         parthist_.count_adjust := parthist_.count_adjust + event_counter_;
      ELSIF (invent_stat_direction_db_ = 'ADJUSTMENT OUT') THEN
         parthist_.mtd_adjust   := parthist_.mtd_adjust - quantity_;
         parthist_.qty_onhand   := parthist_.qty_onhand - quantity_;
         parthist_.count_adjust := parthist_.count_adjust + event_counter_;
      ELSIF (invent_stat_direction_db_ = 'RECEIPT') THEN
         parthist_.mtd_receipts   := parthist_.mtd_receipts + quantity_;
         parthist_.qty_onhand     := parthist_.qty_onhand + quantity_;
         parthist_.count_receipts := parthist_.count_receipts + event_counter_;
      ELSIF (invent_stat_direction_db_ = 'REVERSED RECEIPT') THEN
         parthist_.mtd_receipts   := parthist_.mtd_receipts - quantity_;
         parthist_.qty_onhand     := parthist_.qty_onhand - quantity_;
         parthist_.count_receipts := parthist_.count_receipts - event_counter_;
      ELSIF (invent_stat_direction_db_ = 'REVERSED ISSUE') THEN
         IF abnormal_demand_db_ = 'TRUE' THEN
            parthist_.mtd_abnormal_issues   := parthist_.mtd_abnormal_issues - quantity_;
            parthist_.count_abnormal_issues := parthist_.count_abnormal_issues - event_counter_;
         ELSE
            parthist_.mtd_issues   := parthist_.mtd_issues - quantity_;
            parthist_.count_issues := parthist_.count_issues - event_counter_;
         END IF;
         parthist_.qty_onhand     := parthist_.qty_onhand + quantity_;
      ELSIF (invent_stat_direction_db_ = 'ISSUE') THEN
         IF abnormal_demand_db_ = 'TRUE' THEN
            parthist_.mtd_abnormal_issues   := parthist_.mtd_abnormal_issues + quantity_;
            parthist_.count_abnormal_issues := parthist_.count_abnormal_issues + event_counter_;
         ELSE
            parthist_.mtd_issues   := parthist_.mtd_issues + quantity_;
            parthist_.count_issues := parthist_.count_issues + event_counter_;
         END IF;
         parthist_.qty_onhand := parthist_.qty_onhand - quantity_;
      END IF;

      modification_is_needed_ := TRUE;
   END IF;

   IF (modification_is_needed_) THEN
      -- Get second_commodity if updated.
      second_commodity_ := Inventory_Part_API.Get_Second_Commodity ( contract_,
                                                                     part_no_ );
      Inventory_Part_Period_Hist_API.Modify  ( contract_,
                                               part_no_,
                                               configuration_id_,
                                               stat_year_no_,
                                               stat_period_no_,
                                               second_commodity_,
                                               parthist_.mtd_adjust,
                                               parthist_.count_adjust,
                                               parthist_.mtd_receipts,
                                               parthist_.count_receipts,
                                               parthist_.mtd_issues,
                                               parthist_.count_issues,
                                               parthist_.mtd_abnormal_issues,
                                               parthist_.count_abnormal_issues,
                                               parthist_.qty_onhand );
   END IF;
END Modify_Part_History___;


-- Modify_Inventory_Value___
--   This implementation method updates the inventory Value Part class with
--   the quantity and cost changes that were the consequence of the actual transaction.
PROCEDURE Modify_Inventory_Value___ (
   contract_       IN VARCHAR2,
   stat_year_no_   IN NUMBER,
   stat_period_no_ IN NUMBER,
   date_applied_   IN DATE,
   record_type_    IN VARCHAR2,
   invtrans_rec_   IN Inventory_Transaction_Hist_API.Public_Rec,
   site_date_      IN DATE )
IS
   value_part_rec_             Inventory_Value_Part_API.Public_Rec;
   trancode_rec_               Mpccom_Transaction_Code_API.Public_Rec;
   vendor_consignment_         BOOLEAN;
   value_part_exist_           BOOLEAN;
   qty_at_customer_direction_  VARCHAR2(10);
   value_detail_tab_           Mpccom_Accounting_API.Value_Detail_Tab;
   transit_qty_direction_      VARCHAR2(50);
   inventory_direction_        VARCHAR2(10);
   local_configuration_id_     VARCHAR2(50);
   local_condition_code_       VARCHAR2(10);
   local_lot_batch_no_         VARCHAR2(20);
   local_serial_no_            VARCHAR2(50);
   local_qty_waiv_dev_rej_     NUMBER;
   local_quantity_             NUMBER;
   local_qty_in_transit_       NUMBER;
   local_qty_at_customer_      NUMBER;
   local_vendor_owned_qty_     NUMBER;
   local_total_value_          NUMBER;
   exit_procedure_             EXCEPTION;
   char_null_                  VARCHAR2(12) := 'varchar2null';
   increase_transit_loc_group_ BOOLEAN := FALSE;
   decrease_transit_loc_group_ BOOLEAN := FALSE;
BEGIN

   value_detail_tab_ := Mpccom_Accounting_API.Get_Acc_Value_Not_Included(
                                                                       invtrans_rec_.accounting_id,
                                                                       date_applied_);

   IF (record_type_ = 'T') THEN
      trancode_rec_          := Mpccom_Transaction_Code_API.Get(invtrans_rec_.transaction_code);
      transit_qty_direction_ := trancode_rec_.transit_qty_direction;
      inventory_direction_   := invtrans_rec_.direction;

      -- Check if transaction is of consignment Stock type.
      -- And if so, is it owned by a Vendor or is it Ours ?
      -- Check if transaction is delivery confirmation, handle it similar to
      -- consignment to make inventory value statistics correct.
      IF (trancode_rec_.consignment_stock = Consignment_Stock_Trans_API.DB_VENDOR_CONSIGNMENT_STOCK) THEN
         vendor_consignment_        := TRUE;
         qty_at_customer_direction_ := '0';
      END IF;

      IF (trancode_rec_.qty_at_customer_direction = Stock_Quantity_Direction_API.DB_INCREASE_QUANTITY) THEN
         vendor_consignment_        := FALSE;
         qty_at_customer_direction_ := '+';
      ELSIF (trancode_rec_.qty_at_customer_direction = Stock_Quantity_Direction_API.DB_DECREASE_QUANTITY) THEN
         vendor_consignment_        := FALSE;
         qty_at_customer_direction_ := '-';
      END IF;

      IF (trancode_rec_.consignment_stock = Consignment_Stock_Trans_API.DB_NOT_CONSIGNMENT_STOCK AND 
          trancode_rec_.qty_at_customer_direction = Stock_Quantity_Direction_API.DB_UNAFFECTED_QUANTITY) THEN
         vendor_consignment_        := FALSE;
         qty_at_customer_direction_ := '0';
      END IF;
   ELSE
      -- When record_type_ is 'A' then there is no effect on quantities.
      transit_qty_direction_     := Stock_Quantity_Direction_API.DB_UNAFFECTED_QUANTITY;
      qty_at_customer_direction_ := '0';
      inventory_direction_       := '0';
      vendor_consignment_        := FALSE;
   END IF;

   -----------------------------------------------------------------------
   -- Check if this transaction changes either quantity or value.       --
   -- otherwise do nothing!                                             --
   -----------------------------------------------------------------------
   -- (You only have to verify if transaction is "consignment stock"    --
   -- if the quantity changes. Since "Consignment Stock" doesn't affect --
   -- the value of M1 until consumed.)                                  --
   -----------------------------------------------------------------------
   IF ((value_detail_tab_.COUNT     = 0)                     AND
       (transit_qty_direction_      = 'UNAFFECTED QUANTITY') AND
       (inventory_direction_        = '0')                   AND
       (qty_at_customer_direction_  = '0'))                  THEN
      RAISE exit_procedure_;
   END IF;

   IF (invtrans_rec_.inventory_part_cost_level IS NULL) THEN
      Error_SYS.Record_General(lu_name_,'COSTLEVERR1: Inventory Part Cost Level must have a value.');
   END IF;

   IF (invtrans_rec_.inventory_part_cost_level = 'COST PER PART') THEN
      local_configuration_id_ := '*';
      local_condition_code_   := '*';
      local_lot_batch_no_     := '*';
      local_serial_no_        := '*';
   ELSIF (invtrans_rec_.inventory_part_cost_level = 'COST PER CONFIGURATION') THEN
      local_configuration_id_ := invtrans_rec_.configuration_id;
      local_condition_code_   := '*';
      local_lot_batch_no_     := '*';
      local_serial_no_        := '*';
   ELSIF (invtrans_rec_.inventory_part_cost_level = 'COST PER CONDITION') THEN
      local_configuration_id_ := invtrans_rec_.configuration_id;
      local_condition_code_   := NVL(invtrans_rec_.condition_code,'*');
      local_lot_batch_no_     := '*';
      local_serial_no_        := '*';
   ELSIF (invtrans_rec_.inventory_part_cost_level = 'COST PER LOT BATCH') THEN
      local_configuration_id_ := invtrans_rec_.configuration_id;
      IF (NVL(invtrans_rec_.serial_no,'*') = '*') THEN
         local_condition_code_ := NVL(invtrans_rec_.condition_code,'*');
      ELSE
         local_condition_code_ := '*';
      END IF;
      local_lot_batch_no_     := NVL(invtrans_rec_.lot_batch_no,'*');
      local_serial_no_        := '*';
   ELSIF (invtrans_rec_.inventory_part_cost_level = 'COST PER SERIAL') THEN
      local_configuration_id_ := invtrans_rec_.configuration_id;
      local_condition_code_   := NVL(invtrans_rec_.condition_code,'*');
      local_lot_batch_no_     := NVL(invtrans_rec_.lot_batch_no,'*');
      local_serial_no_        := NVL(invtrans_rec_.serial_no,'*');
   ELSE
      Error_SYS.Record_General(lu_name_,'COSTLEVERR2: Inventory Part Cost Level :P1 is not supported.', Inventory_Part_Cost_Level_API.Decode(invtrans_rec_.inventory_part_cost_level));
   END IF;

   value_part_rec_ := Inventory_Value_Part_API.Get(contract_,
                                                   stat_year_no_,
                                                   stat_period_no_,
                                                   invtrans_rec_.part_no,
                                                   local_configuration_id_,
                                                   local_lot_batch_no_,
                                                   local_serial_no_,
                                                   local_condition_code_,
                                                   invtrans_rec_.location_group);
   IF (value_part_rec_.quantity IS NULL) THEN
      local_qty_waiv_dev_rej_ := 0;
      local_quantity_         := 0;
      local_qty_in_transit_   := 0;
      local_qty_at_customer_  := 0;
      local_vendor_owned_qty_ := 0;
      value_part_exist_ := FALSE;
   ELSE
      local_qty_waiv_dev_rej_ := value_part_rec_.qty_waiv_dev_rej;
      local_quantity_         := value_part_rec_.quantity;       
      local_qty_in_transit_   := value_part_rec_.qty_in_transit;
      local_qty_at_customer_  := value_part_rec_.qty_at_customer;
      local_vendor_owned_qty_ := value_part_rec_.vendor_owned_qty;
      value_part_exist_   := TRUE;
   END IF;

   -- Check if this transaction shall affect either the inventory Quantity,
   -- qty_at_customer or vendor_owned_qty.
   IF qty_at_customer_direction_ != '0' AND NOT vendor_consignment_ THEN
      IF qty_at_customer_direction_ = ('+') THEN
         local_qty_at_customer_ := local_qty_at_customer_ + invtrans_rec_.quantity;
      ELSIF qty_at_customer_direction_ = ('-') THEN
         local_qty_at_customer_ := local_qty_at_customer_ - invtrans_rec_.quantity;
      END IF;
   ELSIF inventory_direction_ != '0' AND NOT vendor_consignment_ THEN
      IF inventory_direction_ = ('+') THEN
         IF NVL(invtrans_rec_.waiv_dev_rej_no, char_null_) = '*' THEN
            local_quantity_ := local_quantity_ + invtrans_rec_.quantity;
         ELSE
            local_qty_waiv_dev_rej_ := local_qty_waiv_dev_rej_ + invtrans_rec_.quantity;
         END IF;
      ELSIF inventory_direction_ = ('-') THEN
            IF NVL(invtrans_rec_.waiv_dev_rej_no, char_null_) = '*' THEN
            local_quantity_ := local_quantity_ - invtrans_rec_.quantity;
         ELSE
            local_qty_waiv_dev_rej_ := local_qty_waiv_dev_rej_ - invtrans_rec_.quantity;
         END IF;
      END IF;
   ELSIF vendor_consignment_ THEN
      IF inventory_direction_ = ('+') THEN
         local_vendor_owned_qty_ := local_vendor_owned_qty_ + invtrans_rec_.quantity;
      ELSIF inventory_direction_ = ('-') THEN
         local_vendor_owned_qty_ := local_vendor_owned_qty_ - invtrans_rec_.quantity;
      END IF;
   END IF;

   -- Check if this transaction has moved inventory quantity into transit.
   -- This if statement is seperate since the same transaction will remove
   -- the quantity from the inventory.
   IF (transit_qty_direction_ != 'UNAFFECTED QUANTITY') THEN
      IF (transit_qty_direction_ = 'INCREASE QUANTITY') THEN
         IF (invtrans_rec_.transit_location_group = invtrans_rec_.location_group) THEN
            local_qty_in_transit_ := local_qty_in_transit_ + invtrans_rec_.quantity;
         ELSE
            increase_transit_loc_group_ := TRUE;
         END IF;
      ELSIF (transit_qty_direction_ = 'DECREASE QUANTITY') THEN
         IF (invtrans_rec_.transit_location_group = invtrans_rec_.location_group) THEN
            local_qty_in_transit_ := local_qty_in_transit_ - invtrans_rec_.quantity;
         ELSE
            decrease_transit_loc_group_ := TRUE;
         END IF;
      ELSE
         Error_SYS.Record_General(lu_name_,'TRANSITQTYDIR: Transit Qty Direction :P1 is not supported.', Stock_Quantity_Direction_API.Decode(transit_qty_direction_));
      END IF;
   END IF;

   IF (value_part_exist_) THEN
      Inventory_Value_Part_API.Modify(contract_,
                                      stat_year_no_,
                                      stat_period_no_,
                                      invtrans_rec_.part_no,
                                      local_configuration_id_,
                                      local_lot_batch_no_,
                                      local_serial_no_,
                                      local_condition_code_,
                                      invtrans_rec_.location_group,
                                      local_qty_waiv_dev_rej_,
                                      local_quantity_,
                                      local_qty_in_transit_,
                                      local_qty_at_customer_,
                                      local_vendor_owned_qty_);
   ELSE
      Inventory_Value_Part_API.NEW(contract_,
                                   stat_year_no_,
                                   stat_period_no_,
                                   invtrans_rec_.part_no,  
                                   local_configuration_id_, 
                                   local_lot_batch_no_,     
                                   local_serial_no_,        
                                   local_condition_code_,
                                   invtrans_rec_.location_group,
                                   local_qty_waiv_dev_rej_, 
                                   local_quantity_,         
                                   local_qty_in_transit_,   
                                   local_qty_at_customer_,  
                                   local_vendor_owned_qty_,
                                   site_date_);
   END IF;

   IF ((increase_transit_loc_group_)  OR
       (decrease_transit_loc_group_)) THEN
      value_part_rec_ := Inventory_Value_Part_API.Get(contract_,
                                                      stat_year_no_,
                                                      stat_period_no_,
                                                      invtrans_rec_.part_no,
                                                      local_configuration_id_,
                                                      local_lot_batch_no_,
                                                      local_serial_no_,
                                                      local_condition_code_,
                                                      invtrans_rec_.transit_location_group);
      IF (value_part_rec_.quantity IS NULL) THEN
         local_qty_waiv_dev_rej_ := 0;
         local_quantity_         := 0;
         local_qty_in_transit_   := 0;
         local_qty_at_customer_  := 0;
         local_vendor_owned_qty_ := 0;
         value_part_exist_       := FALSE;
      ELSE
         local_qty_waiv_dev_rej_ := value_part_rec_.qty_waiv_dev_rej;
         local_quantity_         := value_part_rec_.quantity;       
         local_qty_in_transit_   := value_part_rec_.qty_in_transit;
         local_qty_at_customer_  := value_part_rec_.qty_at_customer;
         local_vendor_owned_qty_ := value_part_rec_.vendor_owned_qty;
         value_part_exist_       := TRUE;
      END IF;

      IF (increase_transit_loc_group_) THEN
         local_qty_in_transit_ := local_qty_in_transit_ + invtrans_rec_.quantity;
      ELSE
         local_qty_in_transit_ := local_qty_in_transit_ - invtrans_rec_.quantity;
      END IF;

      IF (value_part_exist_) THEN
         Inventory_Value_Part_API.Modify(contract_,
                                         stat_year_no_,
                                         stat_period_no_,
                                         invtrans_rec_.part_no,
                                         local_configuration_id_,
                                         local_lot_batch_no_,
                                         local_serial_no_,
                                         local_condition_code_,
                                         invtrans_rec_.transit_location_group,
                                         local_qty_waiv_dev_rej_,
                                         local_quantity_,
                                         local_qty_in_transit_,
                                         local_qty_at_customer_,
                                         local_vendor_owned_qty_);
      ELSE
         Inventory_Value_Part_API.NEW(contract_,
                                      stat_year_no_,
                                      stat_period_no_,
                                      invtrans_rec_.part_no,  
                                      local_configuration_id_, 
                                      local_lot_batch_no_,     
                                      local_serial_no_,        
                                      local_condition_code_,
                                      invtrans_rec_.transit_location_group,
                                      local_qty_waiv_dev_rej_, 
                                      local_quantity_,         
                                      local_qty_in_transit_,   
                                      local_qty_at_customer_,  
                                      local_vendor_owned_qty_,
                                      site_date_);
      END IF;
   END IF;

   IF (value_detail_tab_.COUNT = 0) THEN
      RAISE exit_procedure_;
   END IF;

   FOR i IN value_detail_tab_.FIRST..value_detail_tab_.LAST LOOP
      local_total_value_ := Invent_Value_Part_Detail_API.Get_Total_Value(
                                                     contract_,              
                                                     stat_year_no_,          
                                                     stat_period_no_,        
                                                     invtrans_rec_.part_no,  
                                                     local_configuration_id_,
                                                     local_lot_batch_no_,    
                                                     local_serial_no_,       
                                                     local_condition_code_,  
                                                     value_detail_tab_(i).cost_source_id,
                                                     value_detail_tab_(i).bucket_posting_group_id);
      IF (local_total_value_ IS NULL) THEN
         Invent_Value_Part_Detail_API.New(contract_,
                                          stat_year_no_,
                                          stat_period_no_,
                                          invtrans_rec_.part_no,
                                          local_configuration_id_,
                                          local_lot_batch_no_,
                                          local_serial_no_,
                                          local_condition_code_,
                                          value_detail_tab_(i).cost_source_id,
                                          value_detail_tab_(i).bucket_posting_group_id,
                                          value_detail_tab_(i).value,
                                          site_date_);
      ELSE
         Invent_Value_Part_Detail_API.Modify_Total_Value(
                                                  contract_,                                 
                                                  stat_year_no_,                             
                                                  stat_period_no_,                           
                                                  invtrans_rec_.part_no,                     
                                                  local_configuration_id_,                   
                                                  local_lot_batch_no_,                       
                                                  local_serial_no_,                          
                                                  local_condition_code_,
                                                  value_detail_tab_(i).cost_source_id,
                                                  value_detail_tab_(i).bucket_posting_group_id, 
                                                  local_total_value_ + value_detail_tab_(i).value);
      END IF;
   END LOOP;
EXCEPTION
   WHEN exit_procedure_ THEN
      NULL;
END Modify_Inventory_Value___;         


-- Close_Previous_Period___
--   Set complete flag and total_value for period in the Inventory Value Class.
PROCEDURE Close_Previous_Period___ (
   contract_           IN VARCHAR2,
   old_stat_year_no_   IN NUMBER,
   old_stat_period_no_ IN NUMBER )
IS
BEGIN
   -- Set_Complete_Flag.
   Inventory_Value_API.Set_Complete_Flag ( contract_,
                                           old_stat_year_no_,
                                           old_stat_period_no_ );
END Close_Previous_Period___;


-- Is_Executing___
--   Return TRUE if another Inventory value calculation is currently executing
--   on any of the contracts concerned. To be able to avoid simultaneously
--   executing two similar calculations which could create inconsistence.
FUNCTION Is_Executing___ (
   contract_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   count_            NUMBER;
   job_id_tab_       Message_Sys.name_table;
   attrib_tab_       Message_Sys.line_table;
   my_job_id_        NUMBER;
   local_contract_   VARCHAR2 (5);
   msg_              VARCHAR2 (32000);
   deferred_call_    CONSTANT VARCHAR2(200) := 'INVENTORY_VALUE_CALC_API'||'.CALCULATE_INVENT_VALUE_PRIV__';
BEGIN
   -- Find the parameters and job id's for the currently executing jobs with
   -- the procedure name that is defined in deferred_call_.
   Transaction_SYS.Get_Executing_Job_Arguments(msg_, deferred_call_);
   -- Store in internal tables.
   Message_Sys.Get_Attributes(msg_, count_, job_id_tab_, attrib_tab_);

   -- Get the job id of the job we are executing.
   my_job_id_ := Transaction_SYS.Get_Current_Job_Id;

   WHILE (count_ > 0) LOOP
      IF (my_job_id_ != job_id_tab_(count_)) THEN
         -- Get the contract that is passed on as a parameter to the job under investigation.
         local_contract_ := Client_SYS.Get_Item_Value ('CONTRACT', attrib_tab_(count_));

         -- When we find the first disqualifying case, stop processing and return TRUE.
         IF (contract_ IS NULL) OR (contract_ = '%') THEN
            -- cannot differentiate contracts but my
            -- job is using wildcards and wants to process for all contracts.
            RETURN TRUE;
         ELSIF (local_contract_ IS NULL) OR (local_contract_ = '%') THEN
            -- cannot differentiate contracts but another
            -- job is using wildcards and is processing for all contracts.
            RETURN TRUE;
         ELSIF (local_contract_ = contract_) THEN
            -- matching contracts
            RETURN TRUE;
         END IF;
      END IF;
      count_ := count_ - 1;
   END LOOP;
   RETURN FALSE;
END Is_Executing___;


-- Financial_Period_Is_Open___
--   This method is used check whether a given Statistic Year and the
--   Statistic Period is open for a particular user on a given site
FUNCTION Financial_Period_Is_Open___ (
   contract_       IN VARCHAR2,
   stat_year_no_   IN NUMBER,
   stat_period_no_ IN NUMBER ) RETURN BOOLEAN
IS
   date_applied_      DATE;
   company_           VARCHAR2(20);
   user_group_        VARCHAR2(30);
   open_              VARCHAR2(5);
   accounting_year_   NUMBER;
   accounting_period_ NUMBER;
   period_is_open_    BOOLEAN := TRUE;
BEGIN
   company_      := Site_API.Get_Company(contract_);
   user_group_   := User_Group_Member_Finance_API.Get_User_Group(company_,
                                                                 Fnd_Session_API.Get_Fnd_User);
   date_applied_ := TRUNC(Statistic_Period_API.Get_End_Date(stat_year_no_, stat_period_no_));

   Accounting_Period_API.Get_Accounting_Year(accounting_year_,
                                             accounting_period_,
                                             company_,
                                             date_applied_,
                                             user_group_);

   open_ := User_Group_Period_API.Is_Period_Open(company_,
                                                 accounting_year_,
                                                 accounting_period_,
                                                 user_group_);
   IF (open_ = 'FALSE') THEN
      period_is_open_ := FALSE;
   END IF;

   RETURN (period_is_open_);
END Financial_Period_Is_Open___;


PROCEDURE Remove_Value_Part_Record___ (
   contract_         IN VARCHAR2,
   stat_year_no_     IN NUMBER,
   stat_period_no_   IN NUMBER,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   condition_code_   IN VARCHAR2,
   location_group_   IN VARCHAR2 )
IS
   value_detail_tab_ Mpccom_Accounting_API.Value_Detail_Tab;
   index_            PLS_INTEGER := 1;

   CURSOR get_invent_value_part_detail IS
      SELECT bucket_posting_group_id, cost_source_id, total_value
        FROM invent_value_part_detail_tab
       WHERE contract         = contract_
         AND stat_year_no     = stat_year_no_
         AND stat_period_no   = stat_period_no_
         AND part_no          = part_no_
         AND configuration_id = configuration_id_
         AND lot_batch_no     = lot_batch_no_
         AND serial_no        = serial_no_
         AND condition_code   = condition_code_;
BEGIN

   IF NOT (Similar_Value_Part_Exist___(contract_,
                                       stat_year_no_,
                                       stat_period_no_,
                                       part_no_,
                                       configuration_id_,
                                       lot_batch_no_,
                                       serial_no_,
                                       condition_code_,
                                       location_group_)) THEN

      FOR value_detail_rec_ IN get_invent_value_part_detail LOOP

         IF (value_detail_rec_.total_value != 0) THEN
            value_detail_tab_(index_).bucket_posting_group_id
                                                     := value_detail_rec_.bucket_posting_group_id;
            value_detail_tab_(index_).cost_source_id := value_detail_rec_.cost_source_id;
            value_detail_tab_(index_).value          := value_detail_rec_.total_value;
            index_ := index_ + 1;
         END IF;

         Invent_Value_Part_Detail_API.Remove(contract_,         
                                             stat_year_no_,     
                                             stat_period_no_,   
                                             part_no_,          
                                             configuration_id_, 
                                             lot_batch_no_,     
                                             serial_no_,        
                                             condition_code_,
                                             value_detail_rec_.cost_source_id,
                                             value_detail_rec_.bucket_posting_group_id);
      END LOOP;
   END IF;

   Inventory_Value_Part_API.Remove(contract_,                  
                                   stat_year_no_,  
                                   stat_period_no_,
                                   part_no_,                   
                                   configuration_id_,          
                                   lot_batch_no_,              
                                   serial_no_,                 
                                   condition_code_,
                                   location_group_);

   IF (value_detail_tab_.COUNT > 0) THEN

      Handle_Remaining_Values___(contract_,         
                                 stat_year_no_,     
                                 stat_period_no_,   
                                 part_no_,          
                                 configuration_id_, 
                                 lot_batch_no_,     
                                 serial_no_,        
                                 condition_code_,
                                 location_group_,
                                 value_detail_tab_);
   END IF;
END Remove_Value_Part_Record___;


FUNCTION Remove_Value_Part_Record___ (
   contract_                 IN VARCHAR2,
   stat_year_no_             IN NUMBER,
   stat_period_no_           IN NUMBER,
   part_no_                  IN VARCHAR2,
   configuration_id_         IN VARCHAR2,
   lot_batch_no_             IN VARCHAR2,
   serial_no_                IN VARCHAR2,
   condition_code_           IN VARCHAR2,
   location_group_           IN VARCHAR2,
   qty_waiv_dev_rej_         IN NUMBER,
   quantity_                 IN NUMBER,
   qty_in_transit_           IN NUMBER,
   qty_at_customer_          IN NUMBER,
   vendor_owned_qty_         IN NUMBER,
   financial_period_is_open_ IN BOOLEAN ) RETURN BOOLEAN
IS
   remove_value_part_record_  BOOLEAN := FALSE;
   rounddiff_inactivity_days_ NUMBER;
   period_begin_date_         DATE;
   period_end_date_           DATE;
   local_configuration_id_    inventory_value_part_tab.configuration_id%TYPE;
   local_lot_batch_no_        inventory_value_part_tab.lot_batch_no%TYPE;
   local_serial_no_           inventory_value_part_tab.serial_no%TYPE;
   local_condition_code_      inventory_value_part_tab.condition_code%TYPE;
BEGIN

   IF ((qty_waiv_dev_rej_ = 0)  AND
       (quantity_         = 0)  AND
       (qty_in_transit_   = 0)  AND
       (qty_at_customer_  = 0)  AND
       (vendor_owned_qty_ = 0)) THEN

      IF (Similar_Value_Part_Exist___(contract_,
                                      stat_year_no_,
                                      stat_period_no_,
                                      part_no_,
                                      configuration_id_,
                                      lot_batch_no_,
                                      serial_no_,
                                      condition_code_,
                                      location_group_)) THEN
         remove_value_part_record_ := TRUE;
      ELSE
         -- if the financial period is closed and we cannot create ROUNDDIFF transactions.
         IF (Non_Zero_Value_Detail_Exist___(contract_,
                                            stat_year_no_,
                                            stat_period_no_,
                                            part_no_,
                                            configuration_id_,
                                            lot_batch_no_,
                                            serial_no_,
                                            condition_code_)) THEN
            IF (financial_period_is_open_) THEN
               rounddiff_inactivity_days_ := Site_Invent_Info_API.Get_Rounddiff_Inactivity_Days(contract_);

               IF (rounddiff_inactivity_days_ = 0) THEN
                  remove_value_part_record_ := TRUE;
               ELSE
                  period_end_date_   := TRUNC(Statistic_Period_API.Get_End_Date(stat_year_no_,
                                                                                stat_period_no_));
                  period_begin_date_ := period_end_date_ - rounddiff_inactivity_days_;

                  IF (configuration_id_ = '*') THEN
                     local_configuration_id_ := NULL;
                  ELSE
                     local_configuration_id_ := configuration_id_;
                  END IF;

                  IF (lot_batch_no_ = '*') THEN
                     local_lot_batch_no_ := NULL;
                  ELSE
                     local_lot_batch_no_ := lot_batch_no_;
                  END IF;

                  IF (serial_no_ = '*') THEN
                     local_serial_no_ := NULL;
                  ELSE
                     local_serial_no_ := serial_no_;
                  END IF;

                  IF (condition_code_ = '*') THEN
                     local_condition_code_ := NULL;
                  ELSE
                     local_condition_code_ := condition_code_;
                  END IF;

                  IF NOT (Inventory_Transaction_Hist_API.Transaction_In_Period_Exist(
                                                                              contract_,
                                                                              part_no_,
                                                                              local_configuration_id_,
                                                                              local_lot_batch_no_,
                                                                              local_serial_no_,
                                                                              local_condition_code_,
                                                                              period_begin_date_,
                                                                              period_end_date_)) THEN

                     remove_value_part_record_ := TRUE;
                  END IF;
               END IF;
            END IF;
         ELSE
            remove_value_part_record_ := TRUE;
         END IF;
      END IF;
   END IF;

   RETURN (remove_value_part_record_);
END Remove_Value_Part_Record___;


FUNCTION Similar_Value_Part_Exist___ (
   contract_         IN VARCHAR2,
   stat_year_no_     IN NUMBER,
   stat_period_no_   IN NUMBER,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   condition_code_   IN VARCHAR2,
   location_group_   IN VARCHAR2 ) RETURN BOOLEAN
IS
  similar_value_part_exist_ BOOLEAN := FALSE;
  dummy_                    NUMBER;

   CURSOR exist_control IS
      SELECT 1
        FROM inventory_value_part_tab
       WHERE contract         = contract_
         AND stat_year_no     = stat_year_no_
         AND stat_period_no   = stat_period_no_
         AND part_no          = part_no_
         AND configuration_id = configuration_id_
         AND lot_batch_no     = lot_batch_no_
         AND serial_no        = serial_no_
         AND condition_code   = condition_code_
         AND location_group  != location_group_;
BEGIN

   OPEN  exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      similar_value_part_exist_ := TRUE;
   END IF;
   CLOSE exist_control;

   RETURN (similar_value_part_exist_);
END Similar_Value_Part_Exist___;


PROCEDURE Create_Value_Diff_Trans___ (
   contract_         IN VARCHAR2,
   stat_year_no_     IN NUMBER,
   stat_period_no_   IN NUMBER,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   condition_code_   IN VARCHAR2,
   location_group_   IN VARCHAR2,
   value_detail_tab_ IN Mpccom_Accounting_API.Value_Detail_Tab,
   transaction_code_ IN VARCHAR2 )
IS
   transaction_id_        NUMBER;
   accounting_id_         NUMBER;
   dummy_number_          NUMBER;
   empty_cost_detail_tab_ Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   new_date_applied_      DATE;
   local_condition_code_  VARCHAR2(10);
   dummy_char_            VARCHAR2(2000);
BEGIN

   IF (condition_code_ = '*') THEN
      local_condition_code_ := NULL;
   ELSE
      local_condition_code_ := condition_code_;
   END IF;

   Inventory_Transaction_Hist_API.New(transaction_id_     => transaction_id_,
                                      accounting_id_      => accounting_id_,
                                      value_              => dummy_number_,
                                      transaction_code_   => transaction_code_,
                                      contract_           => contract_,
                                      part_no_            => part_no_,
                                      configuration_id_   => configuration_id_,
                                      location_no_        => NULL,
                                      lot_batch_no_       => lot_batch_no_,
                                      serial_no_          => serial_no_,
                                      waiv_dev_rej_no_    => NULL,
                                      eng_chg_level_      => NULL,
                                      activity_seq_       => 0,
                                      project_id_         => NULL,
                                      source_ref1_        => NULL,
                                      source_ref2_        => NULL,
                                      source_ref3_        => NULL,
                                      source_ref4_        => NULL,
                                      source_ref5_        => NULL,
                                      reject_code_        => NULL,
                                      cost_detail_tab_    => empty_cost_detail_tab_,
                                      unit_cost_          => 0,
                                      quantity_           => 0,
                                      qty_reversed_       => 0,
                                      catch_quantity_     => NULL,
                                      source_             => NULL,
                                      source_ref_type_    => NULL,
                                      owning_vendor_no_   => NULL,
                                      condition_code_     => local_condition_code_,
                                      location_group_     => location_group_,
                                      part_ownership_db_  => 'COMPANY OWNED',
                                      owning_customer_no_ => NULL,
                                      expiration_date_    => NULL);

   Inventory_Transaction_Hist_API.Do_Booking(transaction_id_     => transaction_id_,
                                             company_            => NULL,
                                             event_code_         => NULL,
                                             complete_flag_      => 'Y',
                                             external_value_tab_ => value_detail_tab_);

   new_date_applied_ := TRUNC(Statistic_Period_API.Get_End_Date(stat_year_no_, stat_period_no_));
   
   Inventory_Transaction_Hist_API.Modify_Date_Applied(dummy_char_, transaction_id_, new_date_applied_);

   Inventory_Transaction_Hist_API.Set_Partstat_Flag(transaction_id_);

   Inventory_Transaction_Hist_API.Set_Valuestat_Flag(transaction_id_);

   Mpccom_Accounting_API.Set_Acc_Value_Included(accounting_id_, new_date_applied_);

END Create_Value_Diff_Trans___;


PROCEDURE Handle_Remaining_Values___ (
   contract_         IN VARCHAR2,
   stat_year_no_     IN NUMBER,
   stat_period_no_   IN NUMBER,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   condition_code_   IN VARCHAR2,
   location_group_   IN VARCHAR2,
   value_detail_tab_ IN Mpccom_Accounting_API.Value_Detail_Tab )
IS
   pos_diff_tab_                  Mpccom_Accounting_API.Value_Detail_Tab;
   neg_diff_tab_                  Mpccom_Accounting_API.Value_Detail_Tab;
   pos_ix_                        PLS_INTEGER := 1;
   neg_ix_                        PLS_INTEGER := 1;
   exit_procedure_                EXCEPTION;
   local_bucket_posting_group_id_ VARCHAR2(20);
   local_cost_source_id_          VARCHAR2(20);
BEGIN

   IF (value_detail_tab_.COUNT = 0) THEN
      RAISE exit_procedure_;
   END IF;

   FOR i IN value_detail_tab_.FIRST..value_detail_tab_.LAST LOOP

      IF (value_detail_tab_(i).bucket_posting_group_id = '*') THEN
         local_bucket_posting_group_id_ := NULL;
      ELSE
         local_bucket_posting_group_id_ := value_detail_tab_(i).bucket_posting_group_id;
      END IF;

      IF (value_detail_tab_(i).cost_source_id = '*') THEN
         local_cost_source_id_ := NULL;
      ELSE
         local_cost_source_id_ := value_detail_tab_(i).cost_source_id;
      END IF;

      IF (value_detail_tab_(i).value > 0) THEN

         pos_diff_tab_(pos_ix_).bucket_posting_group_id := local_bucket_posting_group_id_;
         pos_diff_tab_(pos_ix_).cost_source_id          := local_cost_source_id_;
         pos_diff_tab_(pos_ix_).value                   := value_detail_tab_(i).value ;
         pos_ix_                                        := pos_ix_ + 1;
      ELSE
         neg_diff_tab_(neg_ix_).bucket_posting_group_id := local_bucket_posting_group_id_;
         neg_diff_tab_(neg_ix_).cost_source_id          := local_cost_source_id_;
         neg_diff_tab_(neg_ix_).value                   := value_detail_tab_(i).value * -1;
         neg_ix_                                        := neg_ix_ + 1;
      END IF;
   END LOOP;

   IF (pos_diff_tab_.COUNT > 0) THEN

      Create_Value_Diff_Trans___(contract_,            
                                 stat_year_no_,        
                                 stat_period_no_,      
                                 part_no_,             
                                 configuration_id_,    
                                 lot_batch_no_,        
                                 serial_no_,           
                                 condition_code_,
                                 location_group_,
                                 pos_diff_tab_,
                                 'ROUNDDIFF+');
   END IF;

   IF (neg_diff_tab_.COUNT > 0) THEN
      Create_Value_Diff_Trans___(contract_,            
                                 stat_year_no_,        
                                 stat_period_no_,      
                                 part_no_,             
                                 configuration_id_,    
                                 lot_batch_no_,        
                                 serial_no_,           
                                 condition_code_,
                                 location_group_,
                                 neg_diff_tab_,
                                 'ROUNDDIFF-');
   END IF;
EXCEPTION
   WHEN exit_procedure_ THEN
      NULL;
END Handle_Remaining_Values___;


FUNCTION Non_Zero_Value_Detail_Exist___ (
   contract_         IN VARCHAR2,
   stat_year_no_     IN NUMBER,
   stat_period_no_   IN NUMBER,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   condition_code_   IN VARCHAR2 ) RETURN BOOLEAN
IS
  non_zero_value_detail_exist_ BOOLEAN := FALSE;
  dummy_                       NUMBER;

   CURSOR exist_control IS
      SELECT 1
        FROM invent_value_part_detail_tab
       WHERE contract         = contract_
         AND stat_year_no     = stat_year_no_
         AND stat_period_no   = stat_period_no_
         AND part_no          = part_no_
         AND configuration_id = configuration_id_
         AND lot_batch_no     = lot_batch_no_
         AND serial_no        = serial_no_
         AND condition_code   = condition_code_
         AND total_value     != 0;
BEGIN

   OPEN  exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      non_zero_value_detail_exist_ := TRUE;
   END IF;
   CLOSE exist_control;

   RETURN (non_zero_value_detail_exist_);
END Non_Zero_Value_Detail_Exist___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Calculate_Invent_Value_Priv__
--   This method goes through all transactions and updates the inventory
--   value and part statistics by calling implementation methods from within a loop.
PROCEDURE Calculate_Invent_Value_Priv__ (
   attr_ IN VARCHAR2 )
IS

   contract_               VARCHAR2(5);
   old_stat_year_no_       NUMBER;
   old_stat_period_no_     NUMBER;
   old_date_applied_       DATE;
   old_transaction_id_     NUMBER;
   old_record_type_        VARCHAR2(20);
   stat_year_no_           NUMBER;
   stat_period_no_         NUMBER;
   max_date_applied_       DATE;
   current_stat_year_no_   NUMBER;
   current_stat_period_no_ NUMBER;
   site_date_              DATE;
   invtrans_rec_           Inventory_Transaction_Hist_API.Public_Rec;
   trans_rows_             BINARY_INTEGER;
   extown_rows_            BINARY_INTEGER;
   period_completion_      VARCHAR2(20);

   prev_stat_year_no_      NUMBER;
   prev_stat_period_no_    NUMBER;
   first_calendar_date_    DATE := Database_Sys.first_calendar_date_;

   CURSOR get_transaction_history (contract_         IN VARCHAR2,
                                   max_date_applied_ IN DATE) IS
      SELECT 'TRANSACTION' record_type, transaction_id,
             date_applied, part_ownership
      FROM   inventory_transaction_hist_tab
      WHERE  date_applied <= max_date_applied_
      AND  ((partstat_flag  = 'N') OR (valuestat_flag = 'N'))
      AND    contract = contract_
      UNION ALL
      SELECT DISTINCT 'ACCOUNTING' record_type, transaction_id,
                       acc.date_applied date_applied, part_ownership
      FROM mpccom_accounting_pub acc, inventory_transaction_hist_tab trans
      WHERE  acc.accounting_id = trans.accounting_id
      AND    acc.date_applied <= max_date_applied_
      AND    acc.inventory_value_status = 'NOT INCLUDED'
      AND    acc.contract = contract_
      ORDER BY date_applied, transaction_id;

   TYPE Transaction_History_Rec_Type IS RECORD
      (record_type_    VARCHAR2(1),
       transaction_id_ NUMBER,
       date_applied_   DATE);

   TYPE Transaction_History_Tab_Type IS TABLE OF Transaction_History_Rec_Type
     INDEX BY BINARY_INTEGER;

   trans_hist_tab_        Transaction_History_Tab_Type;
   empty_trans_hist_tab_  Transaction_History_Tab_Type;

   TYPE Extown_Trans_Id_Tab_Type IS TABLE OF NUMBER
     INDEX BY BINARY_INTEGER;

   extown_trans_id_tab_       Extown_Trans_Id_Tab_Type;
   empty_extown_trans_id_tab_ Extown_Trans_Id_Tab_Type;   
BEGIN

   contract_           := Client_SYS.Get_Item_Value( 'CONTRACT', attr_ );
   site_date_          := Site_API.Get_Site_Date(contract_);
   max_date_applied_   := Client_SYS.Attr_Value_To_Date(Client_SYS.Get_Item_Value( 'MAX_DATE_APPLIED', attr_ ));
   period_completion_  := Client_SYS.Get_Item_Value( 'PERIOD_COMPLETION', attr_ );

   -- To avoid simultaneous execution of Inventory Value Calculation.
   Is_Executing(contract_);
   -- To avoid simultaneous execution with Actual Cost Calculation.
   Actual_Cost_Manager_API.Is_Executing(contract_);

------------------------------------------------------------------------------
-- For each transaction, verify that the period is up to date, i.e. check that
-- all inventory parts has been transferred to the statistics LU:s in a new period.
-- This check is done once for each period involved in this batch.
------------------------------------------------------------------------------

   trans_rows_         := 0;
   extown_rows_        := 0;
   old_date_applied_   := first_calendar_date_;
   old_transaction_id_ := 0;
   old_record_type_    := 'NULL';

   FOR tran_hist_rec_ IN get_transaction_history (contract_,
                                                  max_date_applied_) LOOP
      IF (tran_hist_rec_.part_ownership IN ('COMPANY OWNED','CONSIGNMENT')) THEN
         IF (tran_hist_rec_.record_type = 'TRANSACTION') THEN
            trans_rows_ := trans_rows_ + 1;
            trans_hist_tab_(trans_rows_).transaction_id_ := tran_hist_rec_.transaction_id;
            trans_hist_tab_(trans_rows_).date_applied_   := tran_hist_rec_.date_applied;
            -- 'T' means 'TRANSACTION'
            trans_hist_tab_(trans_rows_).record_type_ := 'T';
            old_transaction_id_ := tran_hist_rec_.transaction_id;
            old_date_applied_   := tran_hist_rec_.date_applied;
            old_record_type_    := tran_hist_rec_.record_type;
         ELSE
            IF ((old_transaction_id_ != tran_hist_rec_.transaction_id) OR
               (old_date_applied_    != tran_hist_rec_.date_applied  ) OR
               (old_record_type_     != 'TRANSACTION')) THEN
               trans_rows_ := trans_rows_ + 1;
               trans_hist_tab_(trans_rows_).transaction_id_ := tran_hist_rec_.transaction_id;
               trans_hist_tab_(trans_rows_).date_applied_   := tran_hist_rec_.date_applied;
               -- 'A' means 'ACCOUNTING'
               trans_hist_tab_(trans_rows_).record_type_ := 'A';
               old_transaction_id_ := tran_hist_rec_.transaction_id;
               old_date_applied_   := tran_hist_rec_.date_applied;
               old_record_type_    := tran_hist_rec_.record_type;
            END IF;
         END IF;
         -- Use only one character to represent record_type
         -- in order to minimize memory usage.
      ELSE
      -- part ownership is customer owned or supplied owned and is not to be included in inventory valuation
         extown_rows_ := extown_rows_ + 1;
         extown_trans_id_tab_(extown_rows_) := tran_hist_rec_.transaction_id;
      END IF;
   END LOOP;

   -- make sure that validation always is performed in first period.
   old_stat_year_no_   := 0;
   old_stat_period_no_ := 0;
   old_date_applied_   := first_calendar_date_;

   FOR j IN 1..trans_rows_ LOOP

      IF (trans_hist_tab_(j).date_applied_ != old_date_applied_) THEN
         -- Get period for this transaction
         Statistic_Period_API.Get_Statistic_Period (stat_year_no_,
                                                    stat_period_no_,
                                                    trans_hist_tab_(j).date_applied_);

         IF (stat_year_no_ IS NULL) OR (stat_period_no_ IS NULL) THEN
            Error_SYS.Record_General(lu_name_,'STATPERIODNOTDEFINED: Matching Statistical Period was not found for the transaction date :P1. Statistical Period/(s) should be defined to cover all transaction dates.',trans_hist_tab_(j).date_applied_);
         END IF;

         old_date_applied_ := trans_hist_tab_(j).date_applied_;

         -- This is only necessary if this period has not been verified before.
         IF (stat_year_no_||stat_period_no_ != old_stat_year_no_||old_stat_period_no_) THEN

            Statistic_Period_API.Get_Previous_Period ( prev_stat_year_no_,
                                                       prev_stat_period_no_,
                                                       trans_hist_tab_(j).date_applied_ );

            Inventory_Value_Calc_API.Initialize_Part_Hist_Period___(contract_,
                                                                    stat_year_no_,
                                                                    stat_period_no_,
                                                                    prev_stat_year_no_,
                                                                    prev_stat_period_no_);
            @ApproveTransactionStatement(2012-01-25,GanNLK)
            COMMIT;

            Inventory_Value_Calc_API.Initialize_Inv_Value_Period___(contract_,
                                                                    stat_year_no_,
                                                                    stat_period_no_,
                                                                    site_date_);

            IF (old_stat_year_no_ != 0 AND old_stat_period_no_ != 0) THEN
               -- Set_Complete_Flag and Total_Value for InventoryValue (Master).
               Inventory_Value_Calc_API.Close_Previous_Period___ ( contract_,
                                                                   old_stat_year_no_,
                                                                   old_stat_period_no_ );
            END IF;
            @ApproveTransactionStatement(2012-01-25,GanNLK)
            COMMIT;
            old_stat_year_no_   := stat_year_no_;
            old_stat_period_no_ := stat_period_no_;
         END IF;
      END IF;

      invtrans_rec_ := Inventory_Transaction_Hist_API.Get(trans_hist_tab_(j).transaction_id_);

      -- Update InventoryPartPeriodHist with this transaction.
      IF ((trans_hist_tab_(j).record_type_  = 'T') AND (invtrans_rec_.partstat_flag = 'N')) THEN
         Modify_Part_History___(contract_,
                                stat_year_no_,
                                stat_period_no_,
                                invtrans_rec_.part_no,
                                invtrans_rec_.configuration_id,
                                invtrans_rec_.transaction_code,
                                invtrans_rec_.quantity,
                                invtrans_rec_.abnormal_demand,
                                invtrans_rec_.source_ref1,
                                invtrans_rec_.source_ref2,
                                invtrans_rec_.source_ref3,
                                invtrans_rec_.source_ref4,
                                invtrans_rec_.source_ref_type,
                                invtrans_rec_.date_applied,
                                invtrans_rec_.original_transaction_id);

         Inventory_Transaction_Hist_API.Set_Partstat_Flag (trans_hist_tab_(j).transaction_id_);
      END IF;

      IF (((trans_hist_tab_(j).record_type_  = 'T') AND (invtrans_rec_.valuestat_flag = 'N')) OR
          (trans_hist_tab_(j).record_type_  = 'A')) THEN
         Inventory_Value_Calc_API.Modify_Inventory_Value___(contract_,
                                                            stat_year_no_,
                                                            stat_period_no_,
                                                            trans_hist_tab_(j).date_applied_,
                                                            trans_hist_tab_(j).record_type_,
                                                            invtrans_rec_,
                                                            site_date_);

         IF (trans_hist_tab_(j).record_type_  = 'T') THEN
            Inventory_Transaction_Hist_API.Set_Valuestat_Flag (trans_hist_tab_(j).transaction_id_);
         END IF;
         Mpccom_Accounting_API.Set_Acc_Value_Included(invtrans_rec_.accounting_id,
                                                      trans_hist_tab_(j).date_applied_);
      END IF;
      @ApproveTransactionStatement(2012-01-25,GanNLK)
      COMMIT;
   END LOOP;
   -- loop over all externally owned transactions and update the partstat flag and valuestat
   -- flag in inventory transaction history
   FOR j IN 1..extown_rows_ LOOP
      Inventory_Transaction_Hist_API.Set_Partstat_Flag (extown_trans_id_tab_(j));
      Inventory_Transaction_Hist_API.Set_Valuestat_Flag (extown_trans_id_tab_(j));
      @ApproveTransactionStatement(2012-01-25,GanNLK)
      COMMIT;
   END LOOP;
   -- Delete all rows from trans_hist_tab_ and extown_trans_id_tab_.
   trans_hist_tab_      := empty_trans_hist_tab_;
   trans_rows_          := 0;
   extown_trans_id_tab_ := empty_extown_trans_id_tab_;
   extown_rows_         := 0;

   -- Close last period.
   IF (old_stat_year_no_ != 0 AND old_stat_period_no_ != 0) THEN
      Inventory_Value_Calc_API.Close_Previous_Period___ ( contract_,
                                                          old_stat_year_no_,
                                                          old_stat_period_no_ );
   END IF;

   -- *********************** WARNING ******************************
   -- *                                                            *
   -- *      DO NOT CHANGE OR REMOVE THE IF-STATEMENT BELOW.       *
   -- *      IT WILL SECURE THAT EXTRA PERIODS WILL NOT BE         *
   -- *      CREATED WHEN THIS JOB IS STARTED FROM ACTUAL COSTING. *
   -- *                                                            *
   -- *********************** WARNING ******************************
   IF (period_completion_ = 'DO_COMPLETE') THEN

      STATISTIC_PERIOD_API.Get_Statistic_Period (current_stat_year_no_,
                                                 current_stat_period_no_,
                                                 max_date_applied_ );

      IF (current_stat_year_no_ IS NULL) OR (current_stat_period_no_ IS NULL) THEN
         Error_SYS.Record_General(lu_name_,'STATPERIODNOTDEFINED: Matching Statistical Period was not found for the transaction date :P1. Statistical Period/(s) should be defined to cover all transaction dates.', site_date_);
      END IF;

      -- Check if the current period exists, if not it (and earlier empty periods) will be added.
      IF NOT Inventory_Value_API.Check_Exist ( contract_,
                                               current_stat_year_no_,
                                               current_stat_period_no_ ) THEN
         
         Statistic_Period_API.Get_Previous_Period ( prev_stat_year_no_,
                                                    prev_stat_period_no_,
                                                    max_date_applied_ );

         Inventory_Value_Calc_API.Initialize_Part_Hist_Period___ ( contract_,
                                                                   current_stat_year_no_,
                                                                   current_stat_period_no_,
                                                                   prev_stat_year_no_,
                                                                   prev_stat_period_no_ );

         Inventory_Value_Calc_API.Initialize_Inv_Value_Period___ ( contract_,
                                                                   current_stat_year_no_,
                                                                   current_stat_period_no_,
                                                                   site_date_);

         Inventory_Value_Calc_API.Close_Previous_Period___ ( contract_,
                                                             current_stat_year_no_,
                                                             current_stat_period_no_ );
      END IF;
   END IF;
   @ApproveTransactionStatement(2012-01-25,GanNLK)
   COMMIT;
END Calculate_Invent_Value_Priv__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Calculate_Inventory_Value
--   This public method starts the batch job that updates both Inventory Value
--   and Inventory Part Period Hist.
PROCEDURE Calculate_Inventory_Value (
   contract_         IN VARCHAR2,
   deferred_call_    IN VARCHAR2 DEFAULT 'TRUE',
   max_date_applied_ IN DATE     DEFAULT NULL,
   execution_offset_ IN NUMBER   DEFAULT NULL )
IS
   attr_                   VARCHAR2(32000);
   batch_desc_             VARCHAR2(100);
   current_contract_       VARCHAR2(5);
   local_max_date_applied_ DATE;

   CURSOR get_contracts (in_contract_ IN VARCHAR2) IS
      SELECT site contract
      FROM user_allowed_site_pub
      WHERE site LIKE NVL(in_contract_,'%');

   TYPE Contract_Tab_Type IS TABLE OF get_contracts%ROWTYPE
     INDEX BY BINARY_INTEGER;
   contract_tab_       Contract_Tab_Type;
BEGIN

   User_Allowed_Site_API.Exist_With_Wildcard(contract_);
   
   OPEN get_contracts(contract_);
   FETCH get_contracts BULK COLLECT INTO contract_tab_;
   CLOSE get_contracts;

   FOR i IN contract_tab_.FIRST..contract_tab_.LAST LOOP
      current_contract_ := contract_tab_(i).contract;
      Client_SYS.Clear_Attr(attr_);

      IF (execution_offset_ IS NULL) THEN
         IF (max_date_applied_ IS NULL) THEN
            local_max_date_applied_ := TRUNC(Site_API.Get_Site_Date(current_contract_));
         ELSE
            local_max_date_applied_ := TRUNC(max_date_applied_);
         END IF;
      ELSE
         IF (max_date_applied_ IS NULL) THEN
            local_max_date_applied_ := TRUNC(Site_API.Get_Site_Date(current_contract_)) - execution_offset_;
         ELSE
            local_max_date_applied_ := LEAST((TRUNC(Site_API.Get_Site_Date(current_contract_)) - execution_offset_),
                                             (TRUNC(max_date_applied_)));
         END IF;
      END IF;

      Client_SYS.Add_To_Attr('CONTRACT', current_contract_, attr_);
      Client_SYS.Add_To_Attr('MAX_DATE_APPLIED', local_max_date_applied_, attr_);

      -- *********************** WARNING **************************
      -- *                                                        *
      -- *     DO NOT CHANGE OR REMOVE THE STATEMENT BELOW.       *
      -- *                                                        *
      -- *********************** WARNING **************************
      Client_SYS.Add_To_Attr('PERIOD_COMPLETION', 'DO_COMPLETE', attr_);

      IF (deferred_call_ = 'TRUE') THEN
         batch_desc_ := Language_SYS.Translate_Constant(lu_name_,'CALCINVVALUE: Aggregate Inventory Transactions per Period for site ');
         batch_desc_ := batch_desc_ || ' ' || current_contract_;
         Transaction_SYS.Deferred_Call('INVENTORY_VALUE_CALC_API.Calculate_Invent_Value_Priv__', attr_, batch_desc_);
      ELSE
         Calculate_Invent_Value_Priv__(attr_);
      END IF;
   END LOOP;
END Calculate_Inventory_Value;


-- Calculate_Up_To_Trans_Day
--   This method is used to start the inventory value calculation (and
--   Inventory Part Period Hist) up to a specific day in time  which is
--   defined by the transaction date applied. Only transaction that has
--   a date_applied less or equal to max_date_applied will be calculated.
PROCEDURE Calculate_Up_To_Trans_Day (
   contract_         IN VARCHAR2,
   max_date_applied_ IN DATE )
IS
   attr_ VARCHAR2(32000);
BEGIN

   Site_API.Exist(contract_);
   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, contract_);

   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_);
   Client_SYS.Add_To_Attr('MAX_DATE_APPLIED', max_date_applied_, attr_);

   -- *********************** WARNING **************************
   -- *                                                        *
   -- *     DO NOT CHANGE OR REMOVE THE STATEMENT BELOW.       *
   -- *                                                        *
   -- *********************** WARNING **************************
   Client_SYS.Add_To_Attr('PERIOD_COMPLETION', 'DO_NOT_COMPLETE', attr_);

   -- This method call can not be deferred since actual cost is dependent on
   -- that this is executed before the actual cost calculation is done.
   -- But the call to this method is done by another method that is started
   -- in deferred mode so that shouldn't matter.
   Inventory_Value_Calc_API.Calculate_Invent_Value_Priv__( attr_);
END Calculate_Up_To_Trans_Day;


-- Is_Executing
--   Gives an exception if another Inventory value calculation is currently
--   executing on any of the contracts concerned. To be able to avoid
--   simultaneously executing two similar calculations which could create inconsistence.
PROCEDURE Is_Executing (
   contract_ IN VARCHAR2 )
IS
BEGIN
   -- To avoid simultaneous execution of Inventory Value Calculation
   IF Is_Executing___(contract_) THEN
      IF (contract_ = '%') OR contract_ IS NULL THEN
         Error_Sys.Appl_General(lu_name_, 'CALCEXECALLSITES: Inventory Value Calculation is already executing on at least one of the Sites and must complete first.');
      ELSE
         Error_Sys.Appl_General(lu_name_, 'CALCEXEC: Inventory Value Calculation is already executing on Site :P1 and must complete first.', contract_);
      END IF;
   END IF;
END Is_Executing;


-- Validate_Params
--   Validates the parameters when running the Schedule for Update
--   Inventory Part Statistics.
PROCEDURE Validate_Params (
   message_ IN VARCHAR2 )
IS
   count_                NUMBER;
   name_arr_             Message_SYS.name_table;
   value_arr_            Message_SYS.line_table;
   contract_             VARCHAR2(5);
   max_date_applied_     DATE;
   execution_offset_     NUMBER; 
   first_calendar_date_  DATE := Database_Sys.first_calendar_date_;
BEGIN
   Message_SYS.Get_Attributes(message_, count_, name_arr_, value_arr_);

   FOR n_ IN 1..count_ LOOP
      IF (name_arr_(n_) = 'CONTRACT_') THEN
         contract_ := NVL(value_arr_(n_), '%');
      ELSIF (name_arr_(n_) = 'MAX_DATE_APPLIED_') THEN
         max_date_applied_ := NVL(TO_DATE(SUBSTR(value_arr_(n_), 1,10), 'YYYY-MM-DD'), TRUNC(SYSDATE));
      ELSIF (name_arr_(n_) = 'EXECUTION_OFFSET_') THEN
         execution_offset_ := NVL(value_arr_(n_), 0);
      END IF;
   END LOOP;

   User_Allowed_Site_API.Exist_With_Wildcard(contract_);

   IF (max_date_applied_ > TRUNC(SYSDATE)) OR (max_date_applied_ < first_calendar_date_ ) THEN
      Error_Sys.Record_General(lu_name_, 'DATERANGE: To date can not be a future date or should not be earlier than the first calender date.');
   END IF;

   IF (execution_offset_ < 0 OR execution_offset_ != ROUND(execution_offset_)) THEN
      Error_Sys.Record_General(lu_name_, 'NEGOFFSET: The execution offset should be a positive integer.');
   END IF;
END Validate_Params;



