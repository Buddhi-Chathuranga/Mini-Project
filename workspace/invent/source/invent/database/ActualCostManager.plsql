-----------------------------------------------------------------------------
--
--  Logical unit: ActualCostManager
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  160421  JoAnSe STRMF-1799, Added Part_Key_Tab defnition and processed_parts_tab_ to detect recursion in actual cost calculation.
--  150616  ManWlk MONO-355, Modified Calculate_Manufactured_Part() to simplify the code when fetching last_manuf_cost_calc date from 
--  150616         InventoryPartConfig.
--  150610  ManWlk MONO-300, Added method Set_Status_Message___() and modified Calculate_Actual_Cost_Priv__() to log status messages 
--  150610         for each step of the PWA calculation.
--  150603  MAJOSE MONO-278, Small change in Calculate_Manufactured_Part when it comes to condition with part_.actual_cost_activated.
--  150415  JoAnse MONO-188, Made changes in several methods to handle the manufacturing diff on cost detail level. 
--  150311  ErSrLK Modified Calculate_Actual_Cost_Priv__() to trigger the actual cost calculation for manufacturing
--  150311         operation transactions. Also removed ShpordInstalled and ProschInstalled params from Calculate_Manufactured_Part().
--  130730  AwWelk TIBE-824, Removed global variables and introduced conditional compilation.
--  100106  Chfolk Redirect method calls from obsolete package Shop_Order_Int_API.
--  090928  ChFolk Removed unused veriables in the package.
------------------------------------ 14.0.0 ----------------------------------
--  080409  NiBalk Bug 70198, Modified Calculate_Actual_Cost_Priv__, by calling 
--  080409         Inventory_Transaction_Hist_API.Refresh_Activity_Info.
--  070518  LEPESE A redesign to make it possible to revaluate the opening_stock per location_group.
--  070518         Location_Group_Qty_Tab is fetched from Inventory_Value_Part_API.Get_For_Configuration
--  070518         and passed on to Inventory_Part_Unit_Cost_API.Actual_Cost_Revalue. 
--  060810  ChJalk Modified hard_coded dates to be able to use any calendar.
--  060202  LEPESE Added parameter configuration_id_ to methods Calc_New_Purch_Std_Cost___ 
--  060202         and Calc_New_Manuf_Std_Cost___. Needed for calling 
--  060202         Inventory_Part_Unit_Cost_API.Generate_Cost_Details. 
--  060125  LEPESE Created methods Calc_New_Purch_Std_Cost___ and Calc_New_Manuf_Std_Cost___.
--  060125         New logic for purchase parts in order to appply the accumulated_purchase_diff_
--  060125         only on the Material part of the total_unit_cost. Delivery Overhead is separated.
--  060120  NiDalk  Added Assert safe annotation. 
--  051230  LEPESE Major redesign because of Cost Details.
--  051212  LEPESE Added NULL to new parameters in call to 
--  051212         Inventory_Part_Unit_Cost_API.Set_Actual_Cost.
--  051118  LEPESE Added call to Inventory_Value_Part_API.Get_For_Configuration().
--  051103  LEPESE Temporary change in method Set_New_Std_Cost___ to make the file compile.
--  051003   KeFelk  Added Site_Invent_Info_API in relavant places where Site_API is used.
--  050919  NiDalk  Removed unused variables
--  **************  Touchdown Merge Begin  *********************
--  040201  LEPESE Multilevel Actual Costing has now been renamed to Periodic Weigted Average.
--                 The old actual_cost flag on InventoryPart has been replaced with a new
--                 attribute called invoice_consideration. This new flag has three different
--                 values: 'IGNORE INVOICE PRICE', 'PERIODIC WEIGHTED AVERAGE' and 'TRANSACTION BASED'.
--  **************  Touchdown Merge End    *********************
--  040126  NaWalk  Rewrote the DBMS_SQL to Native dynamic SQL for Unicode modification.  
--  030811  LEPESE Changed values of parameters in call to method Get_Inventory_Value_By_Method.
--  020816  ANLASE Replaced Inventory_Part_Config_API.Get_Inventory_Value_By_Method with
--                 Inventory_Part_Unit_Cost_API.Get_Inventory_Value_By_Method. 
--  020630  LEPESE Changed package for call to method Set_Actual_Cost. 
--  ****************************  Take Off Baseline  *********************************
--  010410 DaJoLK  Bug fix 20598, Declared Global LU Constants to replace calls to TRANSACTION_SYS.Package_Is_Installed and 
--                 TRANSACTION_SYS.Logical_Unit_Is_Installed in methods.
--  001207  LEPE   Added test on closing_stock_ in method Calculate_Manufactured_Part
--                 to avoid division with zero in method Calculate_New_Std_Cost___.
--  001205  LEPE   New parameters to method Calculate_Manufactured_Part.
--  001205  LEPE   Redesigned method Calculate_Purchased_Average___ to avoid
--                 problems with rollback segments.
--  001204  LEPE   Various changes for increased performance.
--  001127  LEPE   Corrected previous_exec_date variable value.
--  001124  LEPE   Removed vendor_owned_qty from opening_stock_.
--  001123  LEPE   Changes to cursor get_configurations in method
--                 Calculate_Purchased_Average___. Also changed calculation of
--                 opening stock to be equal for purchase and manuf parts.
--  001114  LEPE   Minor corrections due to corrections in model.
--  001102  LEPE   Added check against Inventory Part attribute actual_cost_activated 
--                 in method Calculate_Manufactured_Part.
--  001102  LEPE   Added calls to Shop Order methods. 
--  001031  LEPE   Uncommented commit statement and deferred_call. 
--                 Changed name of method Calculate_Actual_Cost_Impl___ 
--                 to Calculate_Actual_Cost_Priv__.
--                 Added NVL functions in method Check_Actual_Cost_Closure.
--  000911  JoKe   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
-- Records used to keep track of parts for which actual cost calculation has already been initiated
TYPE Part_Key_Rec IS RECORD (
    contract         VARCHAR2(5),
    part_no          VARCHAR2(25),
    configuration_id VARCHAR2(50));

TYPE Part_Key_Tab IS TABLE OF Part_Key_Rec INDEX BY VARCHAR2(100);

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Set_Progress_Message___ (
   message_   IN VARCHAR2,
   param1_    IN VARCHAR2 DEFAULT NULL,
   param2_    IN VARCHAR2 DEFAULT NULL,
   param3_    IN VARCHAR2 DEFAULT NULL )
IS
   progress_desc_  VARCHAR2(2000);
BEGIN

   -- Translate and set the progress message.
   progress_desc_ := Language_SYS.Translate_Constant (lu_name_, message_, TO_CHAR(NULL),param1_, param2_, param3_);
   Transaction_SYS.Log_Progress_Info( progress_desc_ );
   
   @ApproveTransactionStatement(2012-01-25,GanNLK)
   COMMIT;

END Set_Progress_Message___;

PROCEDURE Set_Status_Message___ (
   message_   IN VARCHAR2,
   param1_    IN VARCHAR2 DEFAULT NULL,
   param2_    IN VARCHAR2 DEFAULT NULL,
   param3_    IN VARCHAR2 DEFAULT NULL)
IS
   status_msg_ VARCHAR2(2000);
BEGIN
   status_msg_ := Language_SYS.Translate_Constant (lu_name_, message_, TO_CHAR(NULL),param1_, param2_, param3_);
   Transaction_SYS.Log_Status_Info(status_msg_, 'INFO');
END Set_Status_Message___;   


PROCEDURE Get_Start_Values_For_Part___ (
   closing_stock_          OUT    NUMBER,
   old_cost_detail_tab_    OUT    Inventory_Part_Unit_Cost_API.Cost_Detail_Tab,
   location_group_qty_tab_ OUT    Inventory_Value_Part_API.Location_Group_Quantities_Tab,
   contract_                   IN VARCHAR2,
   part_no_                    IN VARCHAR2,
   configuration_id_           IN VARCHAR2,
   to_transaction_id_          IN NUMBER,
   stat_year_no_               IN NUMBER,
   stat_period_no_             IN NUMBER,
   order_type_                 IN VARCHAR2 )
IS
   total_received_qty_  NUMBER;
   opening_stock_       NUMBER := 0;
BEGIN

   ---------------------------------------------------------------------------
   -- get quantity in stock for beginning of period.                        --
   ---------------------------------------------------------------------------
   -- The easiest way to find out what the opening stock were in the beginning
   -- of this period is to use the quantity in the part statistics. This can
   -- be done because we made sure that the inventory calculation has been 
   -- executed up to date and that it can't have been executed any further.

   location_group_qty_tab_ := Inventory_Value_Part_API.Get_For_Configuration(contract_,
                                                                             stat_year_no_,
                                                                             stat_period_no_,
                                                                             part_no_,
                                                                             configuration_id_);
   IF (location_group_qty_tab_.COUNT > 0) THEN
      FOR i IN location_group_qty_tab_.FIRST..location_group_qty_tab_.LAST LOOP
         opening_stock_ := opening_stock_ + location_group_qty_tab_(i).quantity
                                          + location_group_qty_tab_(i).qty_waiv_dev_rej
                                          + location_group_qty_tab_(i).qty_at_customer
                                          + location_group_qty_tab_(i).qty_in_transit;
      END LOOP;
   END IF;

   -- get standard_cost for this configuration. 
   -- The current can be used since no manual cost updates are allowed.
   old_cost_detail_tab_ := Inventory_Part_Unit_Cost_API.Get_Cost_Details_By_Method(
                                                                                 contract_,
                                                                                 part_no_,
                                                                                 configuration_id_,
                                                                                 NULL,
                                                                                 NULL);
   
   -- get the summarized quantity from receipts (for this configuration.) since 
   -- beginning of period up to the end.
   total_received_qty_ := inventory_Transaction_Hist_API.Get_Actual_Cost_Receipts (
                                            contract_,
                                            part_no_,
                                            configuration_id_,
                                            to_transaction_id_,
                                            order_type_ );

   -- Calculate the closing_stock for this period.
   closing_stock_ := opening_stock_ + total_received_qty_;

END Get_Start_Values_For_Part___;


PROCEDURE Calc_New_Purch_Std_Cost___ (
   new_cost_detail_tab_        OUT Inventory_Part_Unit_Cost_API.Cost_Detail_Tab,
   diff_                    IN OUT NUMBER,
   old_cost_detail_tab_     IN     Inventory_Part_Unit_Cost_API.Cost_Detail_Tab,
   closing_stock_           IN     NUMBER,
   zero_cost_flag_db_       IN     VARCHAR2,
   max_actual_cost_update_  IN     NUMBER,
   contract_                IN     VARCHAR2,
   part_no_                 IN     VARCHAR2,
   configuration_id_        IN     VARCHAR2 )
IS
   allowed_cost_           NUMBER;
   cost_limit_             NUMBER;
   old_total_unit_cost_    NUMBER;
   old_deliv_oh_unit_cost_ NUMBER;
   old_material_unit_cost_ NUMBER;
   new_total_unit_cost_    NUMBER;
   new_deliv_oh_unit_cost_ NUMBER;
   new_material_unit_cost_ NUMBER;
   empty_cost_detail_tab_  Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
BEGIN

   old_total_unit_cost_    := Inventory_Part_Unit_Cost_API.Get_Total_Unit_Cost(
                                                                             old_cost_detail_tab_);
   old_deliv_oh_unit_cost_ := Inventory_Part_Unit_Cost_API.Get_Deliv_Overhead_Unit_Cost(
                                                                             old_cost_detail_tab_);
   old_material_unit_cost_ := old_total_unit_cost_ - old_deliv_oh_unit_cost_;

   -- Calculate the periodic Average Cost according to the formula.
   new_material_unit_cost_ := ((ABS(closing_stock_) * old_material_unit_cost_) + diff_ ) 
                              / ABS(closing_stock_);

   new_cost_detail_tab_ := Inventory_Part_Unit_Cost_API.Generate_Cost_Details(
                                         cost_detail_tab_       => empty_cost_detail_tab_,
                                         unit_cost_             => new_material_unit_cost_,
                                         unit_cost_is_material_ => TRUE,
                                         company_               => Site_API.Get_Company(contract_),
                                         contract_              => contract_,
                                         part_no_               => part_no_,
                                         configuration_id_      => configuration_id_,
                                         source_ref1_           => NULL,
                                         source_ref2_           => NULL,
                                         source_ref3_           => NULL,
                                         source_ref4_           => NULL,
                                         source_ref_type_db_    => NULL);

   new_total_unit_cost_ := Inventory_Part_Unit_Cost_API.Get_Total_Unit_Cost(new_cost_detail_tab_);

   -- Make sure that the cost wasn't changed to below zero or zero if not allowed.
   -- (Zero Cost Only is not allowed with Actual Cost.)
   IF (new_total_unit_cost_ < 0) THEN
      IF (old_total_unit_cost_ < 0.01) THEN
         allowed_cost_ := old_total_unit_cost_;
      ELSE
         allowed_cost_ := 0.01;
      END IF; 
   ELSIF (new_total_unit_cost_ = 0 AND zero_cost_flag_db_ = 'N') THEN
      IF (old_total_unit_cost_ < 0.01) THEN
         allowed_cost_ := old_total_unit_cost_;
      ELSE
         allowed_cost_ := 0.01;
      END IF; 
   END IF;

   -- If the cost was changed recalculate the used price difference.               
   IF (allowed_cost_ IS NOT NULL) THEN
      new_total_unit_cost_ := allowed_cost_;

      new_cost_detail_tab_ := Inventory_Part_Unit_Cost_API.Generate_Cost_Details(
                                         cost_detail_tab_       => empty_cost_detail_tab_,
                                         unit_cost_             => new_total_unit_cost_,
                                         unit_cost_is_material_ => FALSE,
                                         company_               => Site_API.Get_Company(contract_),
                                         contract_              => contract_,
                                         part_no_               => part_no_,
                                         configuration_id_      => configuration_id_,
                                         source_ref1_           => NULL,
                                         source_ref2_           => NULL,
                                         source_ref3_           => NULL,
                                         source_ref4_           => NULL,
                                         source_ref_type_db_    => NULL);

      new_total_unit_cost_    := Inventory_Part_Unit_Cost_API.Get_Total_Unit_Cost(
                                                                             new_cost_detail_tab_);
      new_deliv_oh_unit_cost_ := Inventory_Part_Unit_Cost_API.Get_Deliv_Overhead_Unit_Cost(
                                                                             new_cost_detail_tab_);
      new_material_unit_cost_ := new_total_unit_cost_ - new_deliv_oh_unit_cost_;

      diff_ := ((ABS(closing_stock_) * new_material_unit_cost_) -
                (ABS(closing_stock_) * old_material_unit_cost_));
      allowed_cost_ := NULL;
   END IF;

   -- Make sure that the cost wasn't changed more than the max actual cost 
   -- update percentage allows.
   IF (max_actual_cost_update_ IS NOT NULL OR max_actual_cost_update_ != 0) THEN
      IF (diff_ > 0) THEN
         cost_limit_ := old_total_unit_cost_ * (1+max_actual_cost_update_);
         IF (new_total_unit_cost_ > cost_limit_) THEN
            allowed_cost_ := cost_limit_;
         END IF;
      ELSE
         cost_limit_ := old_total_unit_cost_ * (1-max_actual_cost_update_);
         IF (new_total_unit_cost_ < cost_limit_) THEN
            allowed_cost_ := cost_limit_;
         END IF;
      END IF;            
   END IF;

   -- If the cost was changed recalculate the used price difference.
   IF (allowed_cost_ IS NOT NULL) THEN
      new_total_unit_cost_ := allowed_cost_;

      new_cost_detail_tab_ := Inventory_Part_Unit_Cost_API.Generate_Cost_Details(
                                         cost_detail_tab_       => empty_cost_detail_tab_,
                                         unit_cost_             => new_total_unit_cost_,
                                         unit_cost_is_material_ => FALSE,
                                         company_               => Site_API.Get_Company(contract_),
                                         contract_              => contract_,
                                         part_no_               => part_no_,
                                         configuration_id_      => configuration_id_,
                                         source_ref1_           => NULL,
                                         source_ref2_           => NULL,
                                         source_ref3_           => NULL,
                                         source_ref4_           => NULL,
                                         source_ref_type_db_    => NULL);

      new_total_unit_cost_    := Inventory_Part_Unit_Cost_API.Get_Total_Unit_Cost(
                                                                             new_cost_detail_tab_);
      new_deliv_oh_unit_cost_ := Inventory_Part_Unit_Cost_API.Get_Deliv_Overhead_Unit_Cost(
                                                                             new_cost_detail_tab_);
      new_material_unit_cost_ := new_total_unit_cost_ - new_deliv_oh_unit_cost_;

      diff_ := ((ABS(closing_stock_) * new_material_unit_cost_) -
                (ABS(closing_stock_) * old_material_unit_cost_));
   END IF;

END Calc_New_Purch_Std_Cost___;


-- Calc_New_Manuf_Std_Cost___
--    Calculate the new standard cost for a manufactured part.
--    The value returned in the parameter cost_diff_detail_ will be the cost diff that was used when
--    calculating the new standard cost, this might be only a part of the diff that was passed in initially.
PROCEDURE Calc_New_Manuf_Std_Cost___ (
   new_cost_calculated_        OUT BOOLEAN,
   new_cost_detail_tab_        OUT Inventory_Part_Unit_Cost_API.Cost_Detail_Tab,
   cost_diff_detail_tab_    IN OUT Inventory_Part_Unit_Cost_API.Cost_Detail_Tab,
   old_cost_detail_tab_     IN     Inventory_Part_Unit_Cost_API.Cost_Detail_Tab,
   closing_stock_           IN     NUMBER,
   zero_cost_flag_db_       IN     VARCHAR2,
   max_actual_cost_update_  IN     NUMBER )
IS
   old_total_unit_cost_   NUMBER;
   new_total_unit_cost_   NUMBER;
   used_cost_diff_tab_    Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   cost_diff_             NUMBER;
   max_diff_              NUMBER;
   diff_percentage_used_  NUMBER;
BEGIN

   old_total_unit_cost_ := Inventory_Part_Unit_Cost_API.Get_Total_Unit_Cost(old_cost_detail_tab_);
   cost_diff_           := Inventory_Part_Unit_Cost_API.Get_Total_Unit_Cost(cost_diff_detail_tab_);

   new_total_unit_cost_ := ((ABS(closing_stock_) * old_total_unit_cost_) + cost_diff_ ) / ABS(closing_stock_);

   -- Make sure that the cost wasn't changed to below zero or zero if not allowed.
   -- (Zero Cost Only is not allowed with Actual Cost.)
   IF (new_total_unit_cost_ < 0) OR (new_total_unit_cost_ = 0 AND zero_cost_flag_db_ = 'N') THEN
      -- No cost diff will be applied, used_cost_diff_tab_ will be empty
      new_cost_calculated_ := FALSE;
   ELSE
      -- We might not be able to apply the full cost difference on the closing stock, check how much that can be used
      IF (max_actual_cost_update_ IS NOT NULL OR max_actual_cost_update_ != 0) THEN

         max_diff_ := old_total_unit_cost_ * max_actual_cost_update_ * closing_stock_;

         cost_diff_ := ABS(cost_diff_);

         IF (cost_diff_ > max_diff_) THEN
            diff_percentage_used_ := max_diff_ / cost_diff_;
            used_cost_diff_tab_ := Inventory_Part_Unit_Cost_API.Add_To_Value_Detail_Tab(used_cost_diff_tab_, cost_diff_detail_tab_, diff_percentage_used_);
         ELSE
            used_cost_diff_tab_ := cost_diff_detail_tab_;
         END IF;
      ELSE
         -- The whole cost diff passed in will be used.
         used_cost_diff_tab_  := cost_diff_detail_tab_;
      END IF;

      new_cost_detail_tab_ := Inventory_Part_Unit_Cost_API.Add_To_Value_Detail_Tab(old_cost_detail_tab_, used_cost_diff_tab_, (1 / closing_stock_));

      new_cost_calculated_ := TRUE;
   END IF;

   -- The returned value in cost_diff_detail_tab_ should be the used cost diff details 
   cost_diff_detail_tab_ := used_cost_diff_tab_;
   
END Calc_New_Manuf_Std_Cost___;


PROCEDURE Set_New_Std_Cost___ (
   contract_               IN VARCHAR2,
   part_no_                IN VARCHAR2,
   configuration_id_       IN VARCHAR2,
   used_diff_              IN NUMBER,
   used_diff_detail_tab_   IN Inventory_Part_Unit_Cost_API.Cost_Detail_Tab,
   new_cost_detail_tab_    IN Inventory_Part_Unit_Cost_API.Cost_Detail_Tab,
   old_cost_detail_tab_    IN Inventory_Part_Unit_Cost_API.Cost_Detail_Tab,
   location_group_qty_tab_ IN Inventory_Value_Part_API.Location_Group_Quantities_Tab,
   from_date_              IN DATE,
   to_transaction_id_      IN NUMBER,
   order_type_             IN VARCHAR2 )
IS
BEGIN

   -- Remove the price variance that has been used for this new cost calculation. So that
   -- it isn't recalculated with the next execution.
   IF (order_type_ = 'PURCH') THEN
      Inventory_Part_Config_API.Add_To_Purchase_Diff(contract_,
                                                     part_no_,
                                                     configuration_id_,
                                                     -used_diff_);
   ELSE
      -- Store diff as cost details
      Inv_Part_Config_Manuf_Diff_API.Subtract_From_Manuf_Diff(contract_, part_no_, configuration_id_, used_diff_detail_tab_);
   END IF;
   
   -- Set the new Inventory Value for this configuration without creating INVREVAL postings.

   Inventory_Part_Unit_Cost_API.Set_Actual_Cost (contract_,
                                                 part_no_,
                                                 configuration_id_,
                                                 NULL,
                                                 NULL,
                                                 new_cost_detail_tab_);

   -- Calculate the standard cost variance and revalue the opening stock.
   -- Create a Inventory Revalueation transactions for Actual Costing. (M1 - M18 and M60 - M61)
   Inventory_Part_Unit_Cost_API.Actual_Cost_Revalue(contract_,
                                                    part_no_,
                                                    configuration_id_,
                                                    old_cost_detail_tab_,
                                                    new_cost_detail_tab_,
                                                    location_group_qty_tab_,
                                                    order_type_);
   
   -- Update all transactions from beginning of period (until the end.) for this 
   -- part and set actual_cost_flag.
   Inventory_Transaction_Hist_API.Update_Cost_For_Part(contract_,
                                                       part_no_,
                                                       configuration_id_,
                                                       from_date_,
                                                       to_transaction_id_,
                                                       new_cost_detail_tab_);

END Set_New_Std_Cost___;


PROCEDURE Calculate_Purchased_Average___ (
   contract_           IN VARCHAR2,
   from_date_          IN DATE,
   to_transaction_id_  IN NUMBER,
   execute_date_       IN DATE,
   stat_year_no_       IN NUMBER,
   stat_period_no_     IN NUMBER )
IS
   closing_stock_          NUMBER;
   old_cost_detail_tab_    Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   new_cost_detail_tab_    Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   empty_cost_detail_tab_  Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   location_group_qty_tab_ Inventory_Value_Part_API.Location_Group_Quantities_Tab;
   old_total_unit_cost_    NUMBER;
   new_total_unit_cost_    NUMBER;
   cost_diff_              NUMBER;
   rows_                   BINARY_INTEGER;

   CURSOR get_configuration_keys (contract_ IN VARCHAR2) IS
     SELECT part_no,
            configuration_id
       FROM inventory_part_config_pub
      WHERE nvl(accumulated_purchase_diff,0) != 0
        AND contract = contract_;

   TYPE Configuration_Key_Tab IS TABLE OF get_configuration_keys%ROWTYPE
     INDEX BY BINARY_INTEGER;
   config_key_tab_      Configuration_Key_Tab;

   CURSOR get_configuration_data (contract_         IN VARCHAR2,
                                  part_no_          IN VARCHAR2,
                                  configuration_id_ IN VARCHAR2) IS
     SELECT nvl(conf.accumulated_purchase_diff,0) accumulated_purchase_diff,
            part.zero_cost_flag_db,
            part.actual_cost_activated,
            part.max_actual_cost_update
       FROM inventory_part_config_pub conf, 
            inventory_part_pub part
      WHERE part.part_no          = conf.part_no
        AND part.contract         = conf.contract
        AND conf.contract         = contract_
        AND conf.part_no          = part_no_
        AND conf.configuration_id = configuration_id_;

   config_rec_            get_configuration_data%ROWTYPE;
BEGIN

   -- Find and store database keys for all configurations with purchase differences.
   rows_ := 0;
   FOR key_rec_ IN get_configuration_keys (contract_) LOOP
      rows_ := rows_ + 1;
      config_key_tab_(rows_) := key_rec_;
   END LOOP;

   -- Loop through all configurations with purchase differences.
   FOR i IN 1..rows_ LOOP

      OPEN  get_configuration_data(contract_,
                                   config_key_tab_(i).part_no,
                                   config_key_tab_(i).configuration_id);
      FETCH get_configuration_data INTO config_rec_;
      IF (get_configuration_data%NOTFOUND) THEN
         CLOSE get_configuration_data;
         Error_SYS.Record_Removed(lu_name_,'PARTREMOVED: Configuration :P1 of part :P2 on site :P3 has been removed by another user.',config_key_tab_(i).configuration_id,config_key_tab_(i).part_no,contract_);
      END IF;
      CLOSE get_configuration_data;

      -- Make sure that this part has been actual cost handled since the beginning of this
      -- actual cost period. If not there might be inventory revalue transactions.
      IF (config_rec_.actual_cost_activated < from_date_ OR config_rec_.actual_cost_activated = Database_SYS.First_Calendar_Date_) THEN 
      
         -- Get Start values for part.
         Get_Start_Values_For_Part___ (closing_stock_,
                                       old_cost_detail_tab_,
                                       location_group_qty_tab_,
                                       contract_,
                                       config_key_tab_(i).part_no,
                                       config_key_tab_(i).configuration_id,
                                       to_transaction_id_,
                                       stat_year_no_,
                                       stat_period_no_,
                                       'PURCH');

         -- Calculate new average standard_cost. This can only be done if the opening stock plus
         -- the "actual cost real receipts" is not equal to zero. If not we would have division
         -- by zero. To avoid that the cost variance is saved to the next period when the closing
         -- stock hopefully isn't zero anymore.
         IF (closing_stock_ != 0) THEN
         
            Calc_New_Purch_Std_Cost___(new_cost_detail_tab_,
                                       config_rec_.accumulated_purchase_diff,
                                       old_cost_detail_tab_,
                                       closing_stock_,
                                       config_rec_.zero_cost_flag_db,
                                       config_rec_.max_actual_cost_update,
                                       contract_,
                                       config_key_tab_(i).part_no,
                                       config_key_tab_(i).configuration_id);

            old_total_unit_cost_ := Inventory_Part_Unit_Cost_API.Get_Total_Unit_Cost(
                                                                             old_cost_detail_tab_);
            new_total_unit_cost_ := Inventory_Part_Unit_Cost_API.Get_Total_Unit_Cost(
                                                                             new_cost_detail_tab_);
            -- If the cost has changed revalue the inventory and update the transaction postings.
            cost_diff_ := new_total_unit_cost_ - old_total_unit_cost_;
            
            IF (cost_diff_ != 0) THEN
            
               Set_New_Std_Cost___ (contract_,
                                    config_key_tab_(i).part_no,
                                    config_key_tab_(i).configuration_id,
                                    config_rec_.accumulated_purchase_diff,
                                    empty_cost_detail_tab_, 
                                    new_cost_detail_tab_,
                                    old_cost_detail_tab_,
                                    location_group_qty_tab_,
                                    from_date_,
                                    to_transaction_id_,
                                    'PURCH' );
    
               -- set last_actual_cost_calc for this configuration to the execution date for this
               -- actual cost calculation. This value is used to verify that this part isn't recalculated
               -- more then once in the same calculation.
               Inventory_Part_Config_API.Set_Last_Actual_Cost_Calc(
                                                 contract_,
                                                 config_key_tab_(i).part_no,
                                                 config_key_tab_(i).configuration_id,
                                                 execute_date_);

               -- Commit and set progress message.
               Set_Progress_Message___ ('ACTCOSTCONF: Periodic Weighted Average Cost has been calculated for part :P1 on site :P2 with configuration id :P3.',
                                        config_key_tab_(i).part_no,
                                        contract_,
                                        config_key_tab_(i).configuration_id);
                                                                       
            END IF;   
         END IF;
      END IF;
   END LOOP;
END Calculate_Purchased_Average___;


FUNCTION Is_Executing___ (
   contract_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   count_            NUMBER;
   job_id_tab_       Message_Sys.name_table;
   attrib_tab_       Message_Sys.line_table;
   my_job_id_        NUMBER;
   local_contract_   VARCHAR2 (5);
   msg_              VARCHAR2 (32000);
   deferred_call_    CONSTANT VARCHAR2(200) := 'ACTUAL_COST_MANAGER_API'||'.CALCULATE_ACTUAL_COST_PRIV__';
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


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Calculate_Actual_Cost_Priv__ (
   attr_ IN VARCHAR2 )
IS
   ptr_                      NUMBER;
   name_                     VARCHAR2(30);
   value_                    VARCHAR2(2000);
   contract_                 VARCHAR2(5);
   period_start_day_         DATE;
   execute_date_             DATE;
   previous_exec_date_       DATE;
   to_transaction_id_        NUMBER;
   stat_year_no_             NUMBER;
   stat_period_no_           NUMBER;
   processed_parts_tab_      Part_Key_Tab;
   
BEGIN

   ------------------------------------------------------------------------------
   -- Fetch inparameters and verify that the correct parameters were passed.   --
   ------------------------------------------------------------------------------
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'CONTRACT') THEN
         contract_ := value_;
      ELSE
         Error_SYS.Appl_general(lu_name_,'INVPAR: Passed argument :P1 is not a parameter in method Calculate_actual_cost.',name_);
      END IF;
   END LOOP;

   -- Verify that there are no other actual cost jobs running on this site to 
   -- avoid simultaneous execution of the Actual Cost Calculation
   Is_Executing(contract_);
   -- Verify that there are no inventory value job running on this site to 
   -- avoid simultaneous execution with Inventory Value Calculation
   Inventory_Value_Calc_API.Is_Executing(contract_);

   ------------------------------------------------------------------------------
   -- Get last execution dates and other default values before the calc starts.--
   ------------------------------------------------------------------------------
   
   -- Store the last execution date in a variable.
   previous_exec_date_ := trunc(Site_Invent_Info_API.Get_Last_Actual_Cost_Calc(contract_) - 1);
   -- Get current execute date and store in a variable.
   execute_date_ := Site_API.Get_Site_Date( contract_ );

   -- Find out what the current transaction_id_ is. This will be used as the end of
   -- this actual cost period. This way it doesn't matter if there occurs new transactions
   -- while this job is running.
   to_transaction_id_ := Inventory_Transaction_Hist_API.Get_Current_Transaction_Id;
 
   ------------------------------------------------------------------------------
   -- Updating part statistics up to the beginning of this actual cost period. --
   ------------------------------------------------------------------------------

   Set_Progress_Message___ ('PARTINVVAL: Updating part statistics up to the beginning of this Periodic Weighted Average period.');
                                 
   -- Find out where this actual cost period starts so that we can make sure that the part 
   -- statistics are up to date until this transaction. This is very important since the quantity
   -- in the part statistics will be used as the opening stock for the actual cost period.
   period_start_day_ := Inventory_Transaction_Hist_API.Get_last_non_updatable_day( contract_ );
   
   Set_Status_Message___('PARTSTATUPDATE: Update of part statistics upto :P1 starting from :P2', period_start_day_, TO_CHAR(sysdate, 'yyyy-mm-dd hh24:mi:ss'));
   Inventory_Value_Calc_API.Calculate_Up_To_Trans_Day( contract_, period_start_day_ );

   Set_Progress_Message___ ('PARTINVVALCOMP: Update of part statistics completed.');

   -- Find the latest statistic period in which there are inventory value records.
   Inventory_Value_API.Get_Max_Year_Period(stat_year_no_, stat_period_no_, contract_);

   ------------------------------------------------------------------------------
   -- Start the actual cost calculation. Start with Single and then Multilevel.--
   ------------------------------------------------------------------------------
   -- Now when we have the start and the end of the actual cost period we can 
   -- start the actual calculation. 
   
   -- First calculate a new standard cost for all configurations that has a purchase order 
   -- diff in this period. These purchased parts has to be calculated first since they can
   -- be used in a shop order structure.
   Set_Status_Message___('PWAFORPURCHPARTS: Periodic weighted average calculation for purchased parts starting from :P1', TO_CHAR(sysdate, 'yyyy-mm-dd hh24:mi:ss'));
   Calculate_Purchased_Average___ ( contract_,
                                    period_start_day_,
                                    to_transaction_id_,
                                    execute_date_,
                                    stat_year_no_,
                                    stat_period_no_);

   -- Secondly, use calculated actual cost rates for Work Centers and Labor Classes in order to
   -- re-post operation transactions - Labor and Machine with actual rates. This has to be done
   -- before Shop Order main parts are recalculated.
   $IF (Component_Mfgstd_SYS.INSTALLED) $THEN
      Set_Status_Message___('RECALCMACHLABTRANS: Recalculation of machine and labor transactions starting from :P1', TO_CHAR(sysdate, 'yyyy-mm-dd hh24:mi:ss'));
      Operation_Actual_Cost_Calc_API.Calculate_Actual_Costs(contract_, period_start_day_);
   $END
   
   -- Thirdly update all shop order structures with those new costs and calculate a 
   -- new cost for the main part. 
   $IF (Component_Shpord_SYS.INSTALLED) $THEN
      Set_Status_Message___('PWAFORSOPARTS: Periodic weighted average calculation for shop orders starting from :P1', TO_CHAR(sysdate, 'yyyy-mm-dd hh24:mi:ss'));
      Shop_Ord_Util_API.Calculate_Actual_Cost_Average(processed_parts_tab_,
                                                      contract_, 
                                                      period_start_day_, 
                                                      to_transaction_id_, 
                                                      execute_date_, 
                                                      previous_exec_date_, 
                                                      stat_year_no_,
                                                      stat_period_no_);
   $END

   -- And then update all production schedule structures with those new costs and calculate a 
   -- new cost for the main part.
   $IF (Component_Prosch_SYS.INSTALLED) $THEN
      NULL;
      --   Production_Schedule_API.Calculate_Actual_Cost_Average( contract_, 
      --                                                          period_start_day_, 
      --                                                          to_transaction_id_, 
      --                                                          execute_date_, 
      --                                                          previous_exec_date_,
      --                                                          shop_order_is_installed_,
      --                                                          prosch_is_installed_ );   
      --                                                   
   $END

   -- Set current execute date so that it can be used as previous execute date for 
   -- the next actual cost calculation.
   Site_Invent_Info_API.Set_Last_Actual_Cost_Calc( contract_, execute_date_ );

   Inventory_Transaction_Hist_API.Refresh_Activity_Info(contract_);

   -- The actual Cost calculation has completed.
   Set_Progress_Message___ ('ACTCOSTCOMP: The Periodic Weighted Average Invoice Consideration calculation has completed.');


END Calculate_Actual_Cost_Priv__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Calculate_Actual_Cost (
   contract_ IN VARCHAR2 )
IS
   attr_        VARCHAR2(2000);
   batch_desc_  VARCHAR2(200);
BEGIN

   Site_API.Exist(contract_);
   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, contract_);

   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_);

   batch_desc_:= Language_SYS.Translate_Constant(lu_name_,'CALCACTUAL: Run Periodic Weighted Average Invoice Consideration calculation.');
   Transaction_SYS.Deferred_Call('ACTUAL_COST_MANAGER_API.Calculate_Actual_Cost_Priv__', attr_, batch_desc_);
END Calculate_Actual_Cost;


PROCEDURE Calculate_Manufactured_Part (
   processed_parts_tab_     IN OUT NOCOPY Part_Key_Tab,
   contract_                IN     VARCHAR2,
   part_no_                 IN     VARCHAR2,
   configuration_id_        IN     VARCHAR2,
   execute_date_            IN     DATE,
   previous_exec_date_      IN     DATE,
   from_date_               IN     DATE,
   to_transaction_id_       IN     NUMBER,
   stat_year_no_            IN     NUMBER,
   stat_period_no_          IN     NUMBER )
IS
   part_                   Inventory_Part_API.Public_Rec;
   closing_stock_          NUMBER;
   old_cost_detail_tab_    Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   new_cost_detail_tab_    Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   location_group_qty_tab_ Inventory_Value_Part_API.Location_Group_Quantities_Tab;
   cost_diff_detail_tab_   Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   new_cost_calculated_    BOOLEAN;
   accum_diff_detail_tab_  Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   parts_tab_index_        VARCHAR2(100) := contract_ ||'^'||part_no_||'^'||configuration_id_; 
   reworked_qty_           NUMBER;
BEGIN
   
   -- Don't run the calculation for this part again if calculation has already been initiated in this very same execution.   
   IF (NOT processed_parts_tab_.EXISTS(parts_tab_index_)) THEN

      processed_parts_tab_(parts_tab_index_).contract         := contract_;
      processed_parts_tab_(parts_tab_index_).part_no          := part_no_;
      processed_parts_tab_(parts_tab_index_).configuration_id := configuration_id_;


      -- Now that we know that this part hasn't been calculated in this execution.
      -- Get all the information on the part.
      part_ := Inventory_Part_API.Get(contract_, part_no_);
      -- Get the current manufacturing diff as cost details
      accum_diff_detail_tab_ := Inv_Part_Config_Manuf_Diff_API.Get_Cost_Detail_Tab(contract_, part_no_, configuration_id_);
      
      $IF Component_Shpord_SYS.INSTALLED $THEN

         Shop_Ord_Util_API.Calculate_Actual_Cost_Per_Part(processed_parts_tab_,
                                                          accum_diff_detail_tab_,
                                                          contract_,
                                                          part_no_,
                                                          configuration_id_,
                                                          part_.invoice_consideration,
                                                          from_date_,
                                                          to_transaction_id_,
                                                          execute_date_,
                                                          previous_exec_date_,
                                                          stat_year_no_,
                                                          stat_period_no_ );

         
         cost_diff_detail_tab_ := accum_diff_detail_tab_;
                                           
      $END

      $IF Component_Prosch_SYS.INSTALLED $THEN
         NULL;
         --Production_Schedule_API.Calculate_Actual_Cost_Per_Part;
      $END
                            
      -- The cost variance for this part and all the parts lower in the shop order structures has been
      -- calculated. We can now calculate the new standard cost for this part.
      IF ((part_.invoice_consideration = 'PERIODIC WEIGHTED AVERAGE') AND
          Inventory_Part_Unit_Cost_API.Non_Zero_Cost_Detail_Exist(cost_diff_detail_tab_) AND
          (part_.actual_cost_activated < from_date_ OR part_.actual_cost_activated = Database_SYS.First_Calendar_Date_)) THEN

         -- Get Start values for part.
         Get_Start_Values_For_Part___ (closing_stock_,
                                       old_cost_detail_tab_,
                                       location_group_qty_tab_,
                                       contract_,
                                       part_no_,
                                       configuration_id_,
                                       to_transaction_id_,
                                       stat_year_no_,
                                       stat_period_no_,
                                       'MANUF');

         -- If the part has been reworked on any rework orders in the period then we should reduce the closing stock with
         -- the quantity that has been recycled on rework orders
         $IF Component_Shpord_SYS.INSTALLED $THEN
            reworked_qty_ := Shop_Ord_Util_API.Get_Reworked_Qty(contract_, part_no_, configuration_id_, from_date_, previous_exec_date_);
         $ELSE
            reworked_qty_ := 0;
         $END

         closing_stock_ := closing_stock_ - reworked_qty_;

         -- Calculate new average standard_cost. This can only be done if the opening stock plus
         -- the "actual cost real receipts" is not equal to zero. If not we would have division
         -- by zero. To avoid that the cost variance is saved to the next period when the closing
         -- stock hopefully isn't zero anymore.
         IF (closing_stock_ > 0) THEN

            Calc_New_Manuf_Std_Cost___(new_cost_calculated_,
                                       new_cost_detail_tab_,
                                       cost_diff_detail_tab_,
                                       old_cost_detail_tab_,
                                       closing_stock_,
                                       part_.zero_cost_flag,
                                       part_.max_actual_cost_update);

            IF (new_cost_calculated_) THEN
            
               Set_New_Std_Cost___(contract_,
                                   part_no_,
                                   configuration_id_,
                                   0, 
                                   cost_diff_detail_tab_,
                                   new_cost_detail_tab_,
                                   old_cost_detail_tab_,
                                   location_group_qty_tab_,
                                   from_date_,
                                   to_transaction_id_,
                                   'MANUF' );
            END IF;
         END IF;
      END IF;                                  

      $IF Component_Shpord_SYS.INSTALLED $THEN
         Shop_Ord_Util_API.Calculate_Balanced_Variance(contract_,
                                                       part_no_,
                                                       configuration_id_,
                                                       from_date_,
                                                       previous_exec_date_ );
      $END

      $IF Component_Prosch_SYS.INSTALLED $THEN
         NULL;
         -- Prosch_Fake_API.Calculate_balanced_variance();
      $END

      -- Calculation is completed for this part.
      Inventory_Part_Config_API.Set_Last_Manuf_Cost_Calc(contract_,
                                                         part_no_,
                                                         configuration_id_,
                                                         execute_date_ );
                                                      
      -- Commit and set progress message.
      Set_Progress_Message___ ('ACTCOSTCONF: Periodic Weighted Average Cost has been calculated for part :P1 on site :P2 with configuration id :P3.',
                               part_no_,
                               contract_,
                               configuration_id_);
   END IF; 
END Calculate_Manufactured_Part;


PROCEDURE Check_Actual_Cost_Closure (
   contract_        IN VARCHAR2,
   part_no_         IN VARCHAR2 )
IS
   purch_diff_           NUMBER;
   manuf_diff_           NUMBER;
   
   CURSOR get_purchase_price_diff IS
      SELECT SUM(ABS(NVL(accumulated_purchase_diff,0)))
        FROM inventory_Part_Config_pub
       WHERE contract = contract_
         AND part_no  = part_no_;

   CURSOR get_manuf_diff IS
      SELECT COUNT(*)
      FROM   inv_part_config_manuf_diff_tab
      WHERE  contract = contract_
      AND    part_no = part_no_
      AND    accumulated_manuf_diff != 0;
BEGIN
   
   OPEN get_purchase_price_diff;
   FETCH get_purchase_price_diff INTO purch_diff_;
   IF (get_purchase_price_diff%FOUND) THEN
      CLOSE get_purchase_price_diff;
      IF (purch_diff_ != 0) THEN
         Error_SYS.Record_General(lu_name_, 'ACCPURCHDIFF: There are still accumulated purchase differences that has not been calculated in the Periodic Weighted Average Cost Calculation.');      
      END IF;
   ELSE
      CLOSE get_purchase_price_diff;
   END IF;

   OPEN get_manuf_diff;
   FETCH get_manuf_diff INTO manuf_diff_;
   CLOSE get_manuf_diff;

   IF (manuf_diff_ != 0) THEN
      Error_SYS.Record_General(lu_name_, 'ACCMANUFDIFF: There are still accumulated Manufactured variances that has not been calculated in the Periodic Weighted Average Cost Calculation.');
   END IF;
   
END Check_Actual_Cost_Closure;


PROCEDURE Is_Executing (
   contract_ IN VARCHAR2 )
IS
BEGIN

   -- To avoid simultaneous execution with Inventory Value Calculation
   IF Is_Executing___(contract_) THEN
      IF (contract_ = '%') OR contract_ IS NULL THEN
         Error_Sys.Appl_General(lu_name_, 'ACTCOEXECALLSITES: A Periodic Weighted Average Invoice Consideration Calculation is already executing on at least one of the Sites and must complete first.');
      ELSE
         Error_Sys.Appl_General(lu_name_, 'ACTCOEXEC: Periodic Weighted Average Invoice Consideration Calculation is already executing on Site :P1 and must complete first.', contract_);
      END IF;
   END IF;
   
END Is_Executing;



