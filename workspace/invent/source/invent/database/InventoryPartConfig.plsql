-----------------------------------------------------------------------------
--
--  Logical unit: InventoryPartConfig
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220104  DaZase  SC21R2-2952, Added method Create_Data_Capture_Lov for useage for wadaco processes.
--  210422  TiRalk  SC21R2-278, Modified Calc_Purch_Costs_Priv__() by moving, invoice related code, to Purchase_Receipt_API.Get_Present_Price 
--  210422          when calculating Latest Purchase Price.     
--  210126  SBalLK  Issue SC2020R1-11830, Modified methods with Client_SYS.Add/Set_To_Attr() by removing attr_ functionality to optimize the performance.
--  200214  WaSalk  GESPRING20-1793, Added Check_Deliv_Reason_Id_Ref___() to check company in Inventory_part_config related to localization WarehouseJouranl 
--  191201  Skanlk  Bug 151110(SCZ-8011), Modified Calc_Purch_Costs_Priv__() to calculate and update latest or average purchase price for expense part.
--  180927  HsJose  SCUXXW4-5774, Added date validation in Calc_Purch_Costs.
--  180417  ErRalk  Bug 141349, Modified ZEROCOST0 info message to correct misspelling in Last Param.
--  170628  JeLise  STRSC-7660, Added primary_supplier_ in Calc_Purch_Costs and in Calc_Purch_Costs_Priv___.
--  170522  DAYJLK  STRSC-7524, Modified Remove_Actual_Cost_Difference to create postings for PODIFF transactions.
--  160426  SudJlk  STRSC-2107, Modified Calculate_Est_Mtr_Cost to apply validity to purch and invent basic data.
--  150512  IsSalk  KES-421, Passed new parameter to Inventory_Transaction_Hist_API.New().
--  150505  JoAnSe  MONO-226, Changes in Remove_Actual_Cost_Difference and Check_Delete___ to handle manufacturing differences
--                  from periodic weighted average calculation on cost detail level.
--  140703  MaEdlk  Bug 117072, Removed rounding of variable config_net_weight_ in method Get_Net_Weight_And_Unit_Code.
--  140609  SWiclk  Bug 101957, Modified Calc_Purch_Costs_Priv__() by removing calls to Purchase_Order_Invoice_API.Get_Sum_Qty_Invoiced_Avg() and 
--  140609          Purchase_Order_Invoice_API.Get_Invoice_Price_Avg() because invoiced details are handled in Purchase_Receipt_API.Get_Average_Price().
--  130904  Asawlk  Bug 109541, Modified Get_Net_Weight_And_Unit_Code() to retrieve the weight_unit_code_ from Company_Invent_Info_API.
--  130805  UdGnlk  TIBE-875, Removed the dynamic code and modify to conditional compilation.
--  130529  Asawlk  EBALL-37, Modified Modify_Standard_Cost__() to use Invent_Part_Quantity_Util_API.Check_Quantity_Exist() instead of 
--  130529          Inventory_Part_In_Stock_API.Check_Quantity_Exist().
--  130426  MalLlk  Bug 109434, Modified column comment on INVENT_PART_CONFIG_STOCKABLE.part_no by adding NOCHECK option for reference.
--  121217  JuMaLK  Bug 107368, Added view INVENT_PART_CONFIG_STOCKABLE in order to connect to frmInvReceipt and frmIssue to support custom fields.
--  120301  GayDLK  Bug 101312, Modified Calculate_Est_Mtr_Cost_Priv__() by passing TRUE as the value for parameter modify_standard_cost_ 
--  120301          when calling Modify_Estimated_Material_Cost(). 
--  111012  MaHplk  Changed Check_Remove_Config_Spec__ and Do_Remove_Config_Spec__ private methods to public.
--  111007  MaHplk  Removed the Parent Key reference towards ConfigurationSpec.
--  110815  JeLise  Modified Calculate_Est_Mtr_Cost to call Part_Cost_Group_API.Exist dynamically.
--  110712  JICE    Added Remove_Config_Spec___, Check_Remove_Config_Spec__ and Do_Remove_Config_Spec__ as CUSTOM delete methods
--                  as multiple CASCADE deletes are not allowed.
--  110621  HimRlk  Bug 97585, Modified Calculate_Est_Mtr_Cost() by adding Exist checks for part_cost_group_, commodity_group2_, 
--  110621          product_code_ and product_family_.
--  110510  TiRalk  Bug 96057, Modified Get_Intrastat_Conv_Factor() to return intrastat conversion factor only
--  110510          which is based on configuration id.
--  110314  DaZase  Changed call to Inventory_Part_Pallet_API.Check_Exist so it uses Inventory_Part_API.Pallet_Handled_Num instead.
--  110204  KiSalk  Moved 'User Allowed Site' Default Where condition from client to VIEW2 and base view.
--  100927  PraWlk  Bug 93020, Added new method Get_Intrastat_Conv_Factor() to return intrastat conversion factor 
--  100927          fetched based on the configuration id.
--  100511  KRPELK  Merge Rose Method Documentation.
--  091030  ShKolk  Bug 86768, Merge IPR to APP75 core.
--  090925  MaEelk  Removed unused view INVENTORY_PART_CONFIG_ALL.
--  --------------------------------- 14.0.0 --------------------------------
--  091030  ShKolk  Bug 86768, Merge IPR to APP75 core.
--  090903  Asawlk  Bug 85557, Renamed parameter updated_from_client_ and it's usage to modify_standard_cost_ in Update___().
--  090903          Introduced new parameter modify_standard_cost_ to Modify_Estimated_Material_Cost() and used calling Update___(). 
--  090709  IrRalk  Bug 82835, Modified method Get_Net_Weight_And_Unit_Code to round weight to 4 decimals.
--  080303  NuVelk  Bug 71301, Added view INVENTORY_PART_COUNT_RESULT.
--  070522  RoJalk  Replaced the call to Inventory_Transaction_Hist_API.Do_Transaction_Booking with 
--  070522          Inventory_Transaction_Hist_API.Do_Booking in Remove_Actual_Cost_Difference  
--  070522          to avoid raising an implementation error when using the Remove Periodic WA Differences functionality.
--  070503  WaJalk  Bug 64016, Modified cursor get_allparts in method Calc_Purch_Costs_Priv__ and used NVL function.
--  070314  SuRalk  Bug 63689, Added in parameter valuation_method_db_ to Check_Zero_Cost_Flag.
--  070314          Added in parameter valuation_method_db_ in call to
--  070314          Inventory_Part_Unit_Cost_API.Check_Zero_Cost_Flag.
--  070313  MiKulk  Bug 63733, PL/SQL table was used to bulk fetch from Cursor get_allparts in method Calc_Purch_Costs_Priv__.
--  060727  RoJalk  Centralized Part Desc - Use Inventory_Part_API.Get_Description.
--  060601  RoJalk  Enlarge Part Description - Changed view comments.
--  --------------------------------- 13.4.0 --------------------------------
--  060217  LEPESE  Moved the code for updating Inventory_Part_Unit_Cost when estimated_material_cost
--  060217          changes from method Update___ to private method Modify_Standard_Cost__.
--  060127  JOHESE  Added where condition in view INVENTORY_PART_CONFIG_COUNT to fix partial join
--  060123  NiDalk  Added Assert safe annotation. 
--  060110  GeKalk  Changed the SELECT &OBJID statement to the RETURNING &OBJID in Insert___.
--  051222  HoInlk  Bug 55170, Modified view INVENTORY_PART_CONFIG_COUNT to exclude parts with mrp_order_codes O,K,T.
--  051011  LEPESE  Added parameter update_from_client_ to method Update___. This makes it possible
--  051011          to recognize if the estimated_material_cost has been modified by the client.
--  050927  LEPESE  Merged DMC changes below.
--  050922  ThGulk  Bug 52942, Modified column size of purch_leadtime, manuf_leadtime,expected_leadtime
--  ****************** DMC Merge Begin ***********************
--  050817  LEPESE  Removed obsolete method Modify_Inventory_Value.
--  050812  LEPESE  Replaced calls to method Inventory_Part_Unit_Cost_API.Modify_Inventory_Value
--  050812          with calls to method Inventory_Part_Unit_Cost_API.Modify_Standard_Cost in
--  050812          method Update___.
--  ****************** DMC Merge End ***********************
--  050920  NiDalk  Removed unused variables.
--  050513  ErSolk  Bug 50036, Added procedure Get_Net_Weight_And_Unit_Code.
--  041201  IsAnlk  Modified Calc_Purch_Costs_Priv__ to pass correct end_date_.
--  040921  HeWelk  Passed null to paramater catch_quantity in Inventory_Transaction_Hist_API.New.
--  040520  HeWelk  Modifications(Leadtime to Lead Time) according to 'Date & Lead Time Realignment'
--  040517  DaZaSe  Project Inventory: Added zero/null-parameters to call Inventory_Transaction_Hist_API.New,
--                  change these parameters to real Activity_Seq and Project_Id values if this functionality uses Project Inventory.
--  040428  IsWilk  Rewrote the DBMS_SQL to Native dynamic SQL inside FOR LOOPs.
--  **************  Touchdown Merge Begin  *********************
--  040129  LEPESE  Changed part_rec_.actual_cost to part_rec_.invoice_consideration in Update___.
--  **************  Touchdown Merge End    *********************
--  040301  GeKalk  Removed substrb from the view for UNICODE modifications.
--  040126  NaWalk  Rewrote the DBMS_SQL to Native dynamic SQL for Unicode modification.
--  -------------------------------- 13.3.0 ----------------------------------
--  030811  LEPESE  Changed hardcoded values in call to method Get_Inventory_Value_By_Method
--                  from '*' to NULL.
--  030804  DAYJLK  Performed SP4 Merge.
--  030707  MaEelk  Replaced the calls to Inventory_Part_In_Stock_API.Get_Aggregate_Qty_Onhand and Inventory_Part_In_Stock_API.Get_Total_Qty_In_Transit
--  030707          with the call to Inventory_Part_In_Stock_API.Check_Quantity_Exist in Procedure Update___.
--  030504  LEPESE  Replaced use of configuration_cost_method with inventory_part_cost_level
--                  in method Calculate_Est_Mtr_Cost_Priv__.
--  030430  LEPESE  Added check for part_cost_level in method Update___. Changed number
--                  of parameters in call to Inventory_Part_Unit_Cost_API.Modify_Inventory_Value.
--  030429  LEPESE  Added parameter part_cost_level_db_ to Check_Zero_Cost_Flag.
--                  Changed method call to Inventory_Part_Unit_Cost_API from Insert___.
--  030110  JaBalk  Bug 33892, Modified (ph_sum_costs_ IS NOT NULL OR mpi_sum_costs_ IS NOT NULL) to
--  030110          (ph_qty_ > 0 OR sum_qty_invoiced_ > 0) in Calc_Purch_Costs_Priv__ to calculate avg_price.
--  021231  JaBalk  Bug 33892, Updated the Latest Purchase Price,Average Purchase Price for the part
--  021231          which has been bought with zero price in Calc_Purch_Costs_Priv__.
--  020618  LEPESE  Removed methods Modify_Average_Cost, Set_Actual_Cost and
--                  Actual_Cost_Revalue.
--  020617  LEPESE  Changed method Modify_Inventory_Value to call method with same name
--                  in LU InventoryPartUnitCost.
--                  Removed method Init_Inventory_Value.
--  020614  LEPESE  Removed view INVENTORY_PART_ALTERNATE.
--  020613  LEPESE  Removed column inventory_value from views INVENTORY_PART_CONFIG_COUNT
--                  and INVENTORY_PART_CONFIG_ALL.
--                  Redesign of method Check_Zero_Cost_Allowed.
--  020610  SiJono  Added view INVENTORY_PART_ALTERNATE.
--  011005  DaJolk  Bug fix 19102, Changed Comments on Fields Part_No and configuration_id in VIEW INVENTORY_PART_CONFIG_ALL.
--  010913  DaJolk  Bug fix 19102, Modified View INVENTORY_PART_CONFIG_ALL to select from INVENTORY_PART_PUB instead of INVENTORY_PART_TAB.
--  010831  DaJolk  Bug fix 19102, Added new view INVENTORY_PART_CONFIG_ALL to increase performance.
--  010525  JSAnse  Bug fix 21463, Added call to General_SYS.Init_Method to prodedures Claculate_Est_Mtr_Cost_Priv__ and Claculate_Est_Mtr_Cost.
--  010411  DaJoLK  Bug fix 20598, Declared Global LU Constants to replace calls to TRANSACTION_SYS.Package_Is_Installed and
--                  TRANSACTION_SYS.Logical_Unit_Is_Installed in methods.
--  001220  PERK    Changed view comments
--  001218  ANLASE  Removed check for COST PER BASE PART in method update___ to enable correct
--                  update when changing flag configuration_cost_method. Added infomessages in
--                  method update___.
--  001214  PERK    Added view INVENTORY_PART_CONFIG_COUNT.
--  001213  JOHESE  Added checks on configurations in Calculate_Est_Mtr_Cost_Priv__
--  001212  ANLASE  Added check for configurable in Update___.
--  001207  LEPE    Removed public attribute last_purchase_diff.
--  001123  LEPE    Removed loop around configurations from method Set_Actual_Cost.
--  001121  ANLASE  Added REF for configuration_id on view comments. Added dynamic call to
--                  Configuration_Spec_API.Exist in unpack_check_insert___.
--  001115  LEPE    Corrected duplicate error message label in Set_Actual_Cost.
--  001114  JOHESE  Optimized Calculate_Est_Mtr_Cost_Priv__.
--  001030  LEPE    Added check for accumulated_purchase_diff and accumulated_manuf_diff
--                  in method Check_Delete___ to prevent removal of parts with variances.
--  001027  ANLASE  Added validation for Configuration_Cost_Method in Init_Inventory_Value.
--  001027  LEPE    Added public method Remove_Actual_Cost_Difference.
--  001026  JOKE    Added some extra validations for cost_configuration_method.
--  001025  JOKE    Changed actual_cost_revalue to handle manufacturing parts too.
--  001024  JOKE    Added public attribute last_manuf_cost_calc and methods
--                  to set and get the same.
--  001023  JOKE    Added attribute accumulated_manuf_diff and methods to set
--                  the same.
--  001023  ANLASE  Added validation for configuration cost method in update___.
--  001012  JOKE    Removed actual cost validation for inventory_value in
--                  insert, update and init_inventory_value.
--  001011  JOKE    Added new method Set_Actual_Cost plus validations to make
--                  sure that the inventory value for actual cost parts aren't
--                  updated.
--  001010  JOKE    Added quantity parameters to Revalue_Transaction_Impl___ and
--                  Actual_Cost_Revalue.
--  001010  JOHESE  Added procedures Calculate_Est_Mtr_Cost and Calculate_Est_Mtr_Cost_Priv__
--  001009  JOKE    Added procedures Add_To_Purchase_Diff, Actual_Cost_Revalue,
--                  Set_Last_Actual_Cost_Calc.
--  001005  JOHESE  Added procedures Calculate_Est_Mtr_Cost and Calculate_Est_Mtr_Cost_Priv__
--  001001  PERK    Added configuration_id to purchase method calls
--  000925  SHVE    Rewrote Modify_Inventory_Value to update configurations with the cost
--                  of the base item.
--                  Added a restriction where estimated material cost is not copied to
--                  inventory value if Interim Order is installed.
--  000925  PERK    Removed checks to see if a part was manufactured and using weighted
--                  average as valuation method
--  000911  JOKE    Added attributes needed for Actual Costing.
--                  Accumulated_Purchase_Diff, last_purchase_diff and
--                  last_actual_cost_calc.
--  000901  PaLj    Corrected error in Modify_Average_Cost.
--  000817  LEPE    Added dynamic call in unpack_check_insert___ to validate
--                  the combination of part_no and configuration_id.
--  000815  LEPE    Added public method Check_Exist.
--  000811  PaLj    Corrected small error in Init_Inventory_Value.
--  000726  LEPE    Changed name of LU to InventoryPartConfig.
--  000724  LEPE    Reworked the code copied from LU InventoryPart.
--  000720  LEPE    Added methods New, Modify_Estimated_Material_Cost and
--                  Check_Zero_Cost_Flag.
--  000719  LEPE    Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Remove_Config_Spec___ (
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   action_           IN VARCHAR2 )
IS
   objid_      INVENTORY_PART_CONFIG.objid%TYPE;
   objversion_ INVENTORY_PART_CONFIG.objversion%TYPE;

   CURSOR get_records IS
      SELECT *
      FROM   INVENTORY_PART_CONFIG_TAB
      WHERE  part_no          = part_no_
      AND    configuration_id = configuration_id_;
   
   CURSOR get_records_and_lock IS
      SELECT *
      FROM   INVENTORY_PART_CONFIG_TAB
      WHERE  part_no          = part_no_
      AND    configuration_id = configuration_id_
      FOR UPDATE;
BEGIN
   IF (action_ = 'CHECK') THEN
      FOR record_ IN get_records LOOP
         Check_Delete___(record_);
      END LOOP;
   ELSIF (action_ = 'DO') THEN
      FOR record_ IN get_records_and_lock LOOP
         Check_Delete___(record_);
         Get_Id_Version_By_Keys___(objid_, objversion_, record_.contract, record_.part_no, record_.configuration_id);
         Delete___(objid_, record_);
      END LOOP;
   END IF;
END Remove_Config_Spec___;


-- Check_Estimated_Mtrl_Cost___
--   Method is used for validating modifications of attribute
--   EstimatedMaterialCost against attribute ZeroCostFlag in LU InventoryPart.
PROCEDURE Check_Estimated_Mtrl_Cost___ (
   zero_cost_flag_db_       IN VARCHAR2,
   estimated_material_cost_ IN NUMBER )
IS
BEGIN

   IF (estimated_material_cost_ < 0) THEN
      Error_SYS.Record_General(lu_name_, 'NEGATIVEESTMATCOST: Negative estimated material cost is not allowed.');
   END IF;

   $IF NOT (Component_Cost_SYS.INSTALLED) $THEN
      IF ((zero_cost_flag_db_ = 'N') AND (estimated_material_cost_ = 0)) THEN
         Error_SYS.Record_General(lu_name_, 'NOZEROALLOWED: Cost of the part cannot be 0 when :P1.', Inventory_Part_Zero_Cost_API.Decode(zero_cost_flag_db_));
      ELSIF ((zero_cost_flag_db_ = 'O') AND (estimated_material_cost_ != 0)) THEN
         Error_SYS.Record_General(lu_name_, 'ZEROCOSTONLY: Cost of the part has to be 0 when :P1.', Inventory_Part_Zero_Cost_API.Decode(zero_cost_flag_db_));
      END IF;
   $END
END Check_Estimated_Mtrl_Cost___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);

   Client_SYS.Add_To_Attr('ESTIMATED_MATERIAL_COST', 0, attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT INVENTORY_PART_CONFIG_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN

   super(objid_, objversion_, newrec_, attr_);
   Inventory_Part_Unit_Cost_API.New_Configuration(newrec_.contract,
                                                  newrec_.part_no,
                                                  newrec_.configuration_id);

EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_                IN     VARCHAR2,
   oldrec_               IN     INVENTORY_PART_CONFIG_TAB%ROWTYPE,
   newrec_               IN OUT INVENTORY_PART_CONFIG_TAB%ROWTYPE,
   attr_                 IN OUT VARCHAR2,
   objversion_           IN OUT VARCHAR2,
   by_keys_              IN     BOOLEAN DEFAULT FALSE,
   modify_standard_cost_ IN     BOOLEAN DEFAULT TRUE )
IS
BEGIN
   IF ((newrec_.estimated_material_cost != oldrec_.estimated_material_cost) AND
       (modify_standard_cost_)) THEN

      Modify_Standard_Cost__(newrec_.contract,
                             newrec_.part_no,
                             newrec_.configuration_id,
                             newrec_.estimated_material_cost);
   END IF;

   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN INVENTORY_PART_CONFIG_TAB%ROWTYPE )
IS
   purch_diff_         NUMBER;
   manuf_diff_details_ Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
BEGIN
   purch_diff_ := NVL(remrec_.accumulated_purchase_diff,0);
   manuf_diff_details_ := Inv_Part_Config_Manuf_Diff_API.Get_Cost_Detail_Tab(remrec_.contract, remrec_.part_no, remrec_.configuration_id);

   IF (purch_diff_ != 0) THEN
      Error_SYS.Record_General(lu_name_, 'ACCPURCHDIFF: The accumulated price difference is not equal to zero for part :P2 on site :P3.',remrec_.configuration_id,remrec_.part_no,remrec_.contract);
   ELSIF (Inventory_Part_Unit_Cost_API.Non_Zero_Cost_Detail_Exist(manuf_diff_details_)) THEN
      Error_SYS.Record_General(lu_name_, 'ACCMANUFDIFF: The accumulated cost variance is not equal to zero for part :P2 on site :P3.',remrec_.configuration_id,remrec_.part_no,remrec_.contract);
   END IF;

   super(remrec_);
END Check_Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT inventory_part_config_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_     VARCHAR2(30);
   value_    VARCHAR2(2000);   

BEGIN
   IF NOT(indrec_.latest_purchase_price)THEN 
      newrec_.latest_purchase_price   := 0;
   END IF;
   IF NOT(indrec_.average_purchase_price)THEN 
      newrec_.average_purchase_price   := 0;
   END IF;
   IF NOT(indrec_.estimated_material_cost)THEN 
      newrec_.estimated_material_cost  := 0;
   END IF;
   --  Since ConfigurationSpec is not always installed this must be a dynamic call.
   --  Configuration_Spec_API.Exist(newrec_.part_no, newrec_.configuration_id);
   IF (newrec_.configuration_id != '*') THEN
      $IF (Component_Cfgchr_SYS.INSTALLED) $THEN
         Configuration_Spec_API.Exist(newrec_.part_no, newrec_.configuration_id);          
      $ELSE
         Error_SYS.Record_General(lu_name_, 'CONFNOTINST: Configurations may not be received into inventory since ConfigurationSpec is not installed.');
      $END
   END IF;
   
   super(newrec_, indrec_, attr_);

   IF (newrec_.configuration_id != '*') THEN
      $IF (Component_Cfgchr_SYS.INSTALLED) $THEN
         Configuration_Spec_API.Exist_Valid_Part_Configuration(newrec_.part_no, newrec_.configuration_id);      
      $ELSE
         Error_SYS.Record_General(lu_name_, 'CONFNOTINST: Configurations may not be received into inventory since ConfigurationSpec is not installed.');
      $END
   END IF;

   IF (newrec_.estimated_material_cost < 0) THEN
      Error_SYS.Record_General(lu_name_, 'NEGATIVEESTMATCOST: Negative estimated material cost is not allowed.');
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     inventory_part_config_tab%ROWTYPE,
   newrec_ IN OUT inventory_part_config_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_     VARCHAR2(30);
   value_    VARCHAR2(2000);
   part_rec_ Inventory_Part_API.Public_Rec;

BEGIN
   super(oldrec_, newrec_, indrec_, attr_);

   IF (newrec_.estimated_material_cost != oldrec_.estimated_material_cost) THEN
      part_rec_ := Inventory_Part_API.Get(newrec_.contract, newrec_.part_no);

      Check_Estimated_Mtrl_Cost___(part_rec_.zero_cost_flag,
                                   newrec_.estimated_material_cost);
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Calc_Purch_Costs_Priv__
--   Implementation method for CalcPurchaseCosts.
PROCEDURE Calc_Purch_Costs_Priv__ (
   attrib_ IN VARCHAR2 )
IS
   contract_                  VARCHAR2(5);
   latest_purchase_price_     NUMBER := 0;
   average_purchase_price_    NUMBER := 0;

   ph_sum_costs_              NUMBER;
   ph_qty_                    NUMBER;   
   last_act_cost_             NUMBER;
   qty_invoice_               NUMBER;

   rows_changed_              NUMBER;
   attr_                      VARCHAR2(32000);
   oldrec_                    INVENTORY_PART_CONFIG_TAB%ROWTYPE;
   newrec_                    INVENTORY_PART_CONFIG_TAB%ROWTYPE;
   objid_                     INVENTORY_PART_CONFIG.objid%TYPE;
   objversion_                INVENTORY_PART_CONFIG.objversion%TYPE;

   place_no_                  NUMBER;
   order_no_                  VARCHAR2(12);
   line_no_                   VARCHAR2(4);
   release_no_                VARCHAR2(4);
   receipt_no_                NUMBER;  
   lu_purch_exists_           BOOLEAN;

   ptr_                       NUMBER;
   name_                      VARCHAR2(30);
   value_                     VARCHAR2(2000);

   cost_set_type_             VARCHAR2(30);
   begin_date_                DATE;
   end_date_                  DATE;
   primary_supplier_          VARCHAR2(5);
   transaction_text_          VARCHAR2(2000);

   update_avg_purch_price_    BOOLEAN;
   update_latest_purch_price_ BOOLEAN;
   
   CURSOR get_allparts IS
      SELECT ipc.part_no, ipc.contract, ipc.configuration_id
      FROM INVENTORY_PART_CONFIG_TAB ipc, inventory_part_pub ip, user_allowed_site_pub ual
      WHERE ipc.contract = ip.contract
      AND   ipc.part_no  = ip.part_no
      AND   ip.contract  = ual.site
      AND   (ip.contract LIKE NVL(contract_, '%'))
      AND   ip.type_code_db IN ('3', '4', '6');

   TYPE Inventory_Part_Table IS TABLE OF get_allparts%ROWTYPE
      INDEX BY PLS_INTEGER;

   inv_part_tab_ Inventory_Part_Table; 
   indrec_       Indicator_Rec;
BEGIN
   ptr_ := NULL;

   WHILE (Client_SYS.Get_Next_From_Attr(attrib_, ptr_, name_, value_)) LOOP
      IF (name_ = 'CONTRACT') THEN
          contract_ := value_;
      ELSIF (name_ = 'COST_SET_TYPE') THEN
          cost_set_type_ := value_;
      ELSIF (name_ = 'BEGIN_DATE') THEN
          begin_date_ := Client_SYS.Attr_Value_To_Date(value_);
      ELSIF (name_ = 'END_DATE') THEN
          end_date_ := Client_SYS.Attr_Value_To_Date(value_);
      ELSIF (name_ = 'PRIMARY_SUPPLIER') THEN
          primary_supplier_ := value_;
      ELSE
         Error_SYS.Item_Not_Exist(lu_name_, name_, value_);
      END IF;
   END LOOP;

   place_no_     := 1;
   rows_changed_ := 0;
   IF contract_ IS NOT NULL THEN
      transaction_text_ := Language_SYS.Translate_Constant(lu_name_,'PURCOST1: Calculating the :P1 for parts on site :P2', NULL, cost_set_type_, contract_);
   ELSE
      transaction_text_ := Language_SYS.Translate_Constant(lu_name_,'PURCOST2: Calculating the :P1 for parts on all allowed sites', NULL, cost_set_type_);
   END IF;
   Transaction_SYS.Set_Progress_Info(transaction_text_);
   Trace_SYS.Message('Calc_Purch_Costs. Place: '||to_char(place_no_)||
                     ' Begin_Date: '||begin_date_||
                     ' End_Date: '||end_date_ ||
                     ' Contract: '||contract_);

   lu_purch_exists_ := FALSE;
   IF (Component_Purch_SYS.INSTALLED) THEN
      lu_purch_exists_ := TRUE;
   END IF;

   IF ((cost_set_type_ IS NOT NULL) AND lu_purch_exists_) THEN
      place_no_ := 10;      
   
      OPEN get_allparts;
      FETCH get_allparts BULK COLLECT INTO inv_part_tab_;
      CLOSE get_allparts;

      IF (inv_part_tab_.COUNT > 0) THEN
         FOR i IN inv_part_tab_.FIRST..inv_part_tab_.LAST LOOP
            place_no_ := 100;
            Trace_SYS.Message('Calc_Purch_Costs. Place: '||to_char(place_no_)||
                              ' Contr: '||inv_part_tab_(i).contract||
                              ' Part: '||inv_part_tab_(i).part_no||
                              ' Conf: '||inv_part_tab_(i).configuration_id);
            transaction_text_ := Language_SYS.Translate_Constant(lu_name_,'PURCOST3: Processing configuration :P3 of part :P1 on site :P2', NULL, inv_part_tab_(i).part_no, inv_part_tab_(i).contract, inv_part_tab_(i).configuration_id);
            Transaction_SYS.Set_Progress_Info(transaction_text_);

            latest_purchase_price_  := 0;
            average_purchase_price_ := 0;

            update_latest_purch_price_ := FALSE;
            update_avg_purch_price_    := FALSE;

            IF (cost_set_type_ = Cost_Set_Type_Api.Decode('LA')) THEN
               -- Latest Purchase Price
               -- Prices are fetched from PURCHASE_RECEIPT
               -- or from PURCHASE_ORDER_INVOICE if the invoiced qty
               -- in PURCHASE_RECEIPT > 0.
               place_no_ := 200;

               $IF (Component_Purch_SYS.INSTALLED) $THEN
                  Purchase_Receipt_API.Get_Present_Price(order_no_,
                                                         line_no_,
                                                         release_no_,
                                                         receipt_no_,
                                                         qty_invoice_,
                                                         last_act_cost_,
                                                         inv_part_tab_(i).contract,
                                                         inv_part_tab_(i).part_no,
                                                         inv_part_tab_(i).configuration_id,
                                                         begin_date_,
                                                         end_date_,
                                                         primary_supplier_);
               $END  
              
               place_no_ := 210;
               Trace_SYS.Message(last_act_cost_||' - '||place_no_);

               IF (last_act_cost_ IS NOT NULL) THEN
                  update_latest_purch_price_ := TRUE;
               ELSE
                  update_latest_purch_price_ := FALSE;
                  last_act_cost_ := 0;
               END IF;
               latest_purchase_price_ := nvl(last_act_cost_, 0);               
            ELSE
               -- Average Purchase Price
               -- Prices are being fetched from PURCHASE_RECEIPT
               -- and from PURCHASE_ORDER_INVOICE. The average value
               -- is calculated on the total sum from both tables.
               place_no_ := 300;
               Trace_SYS.Message('Calc_Purch_Costs. Place: '||to_char(place_no_));
               $IF (Component_Purch_SYS.INSTALLED) $THEN
                  Purchase_Receipt_API.Get_Average_Price(ph_sum_costs_,
                                                         ph_qty_,
                                                         inv_part_tab_(i).contract,
                                                         inv_part_tab_(i).part_no,
                                                         inv_part_tab_(i).configuration_id,
                                                         begin_date_,
                                                         end_date_,
                                                         primary_supplier_);
                  place_no_ := 310;
                  Trace_SYS.Message('Calc_Purch_Costs. Place: '||to_char(place_no_));
               $END             

               place_no_ := 320;
               Trace_SYS.Message('Calc_Purch_Costs. Place: '||to_char(place_no_));
               
               IF (ph_qty_ > 0) THEN
                  update_avg_purch_price_ := TRUE;
               END IF;

               IF ph_qty_ = 0 THEN
                  ph_qty_ := 1;
               END IF;

               average_purchase_price_ := NVL(ph_sum_costs_ / ph_qty_, 0);
   
               place_no_ := 320;
               Trace_SYS.Message('Calc_Purch_Costs. Place: '||to_char(place_no_));
            END IF;

            Client_SYS.Clear_Attr(attr_);

            IF (NVL(latest_purchase_price_, 0) >= 0 AND update_latest_purch_price_) THEN
               Client_SYS.Add_To_Attr('LATEST_PURCHASE_PRICE', latest_purchase_price_, attr_);
               place_no_     := 420;
               rows_changed_ := rows_changed_ + 1;
               Trace_SYS.Message('Calc_Purch_Costs. Place: '||to_char(place_no_)||
                                 ' Latest purchase price: '||to_char(latest_purchase_price_)||
                                 ' UPDATED ');
            ELSIF (NVL(average_purchase_price_, 0) >= 0 AND update_avg_purch_price_) THEN
               Client_SYS.Add_To_Attr('AVERAGE_PURCHASE_PRICE', average_purchase_price_, attr_);
               place_no_     := 450;
               rows_changed_ := rows_changed_ + 1;
               Trace_SYS.Message('Calc_Purch_Costs. Place: '||to_char(place_no_)||
                                 ' Average purchase price: '||to_char(average_purchase_price_)||
                                 ' UPDATED ');
            END IF;

            IF (latest_purchase_price_ >= 0 AND update_latest_purch_price_) OR ((average_purchase_price_ >= 0 AND update_avg_purch_price_)) THEN
               oldrec_ := Lock_By_Keys___(inv_part_tab_(i).contract, inv_part_tab_(i).part_no, inv_part_tab_(i).configuration_id);
               newrec_ := oldrec_;
               Unpack___(newrec_, indrec_, attr_);
               Check_Update___(oldrec_, newrec_, indrec_, attr_);
               Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE, FALSE); -- Update by keys
            END IF;
         END LOOP;
      END IF;
   ELSE
      IF lu_purch_exists_ THEN
       Trace_SYS.Message('Calc_Purch_Costs. Place: '||to_char(place_no_)||
                         ' Cost_Set_type is NULL. No rows fetched or updated ');
          -- No rows updated, Cost set is null
      ELSE
       Trace_SYS.Message('Calc_Purch_Costs. Place: '||to_char(place_no_)||
                         ' Purchase LU:s PurchaseReceipt, PurchaseOrderInvoice not found');
      END IF;
   END IF;
   Trace_SYS.Message('Calc_Purch_Costs ended.'||' Changed: '||to_char(rows_changed_));
   IF contract_ IS NOT NULL THEN
      transaction_text_ := Language_SYS.Translate_Constant(lu_name_,'PURCOST4: Calculation done for :P1 on site :P2', NULL, cost_set_type_, contract_);
   ELSE
      transaction_text_ := Language_SYS.Translate_Constant(lu_name_,'PURCOST5: Calculation done for :P1 on all allowed sites', NULL, cost_set_type_);
   END IF;
   Transaction_SYS.Set_Progress_Info(transaction_text_);
END Calc_Purch_Costs_Priv__;


-- Calculate_Est_Mtr_Cost_Priv__
--   Implementation method for CalculateEstMtrCost.
PROCEDURE Calculate_Est_Mtr_Cost_Priv__ (
   attr_ IN VARCHAR2 )
IS
   ptr_               NUMBER := NULL;
   name_              VARCHAR2(30);
   value_             VARCHAR2(2000);

   contract_          inventory_part_pub.contract%type;
   part_cost_group_   inventory_part_pub.part_cost_group_id%type;
   commodity_group2_  inventory_part_pub.second_commodity%type;
   lead_time_code_    inventory_part_pub.lead_time_code%type;
   product_code_      inventory_part_pub.part_product_code%type;
   product_family_    inventory_part_pub.part_product_family%type;
   cost_type_         VARCHAR2(100);
   cost_type_db_      VARCHAR2(100);
   percentage_change_ NUMBER;

   CURSOR get_parts IS
      SELECT ipc.contract,
             ipc.part_no,
             ipc.configuration_id,
             ip.inventory_part_cost_level_db,
             Part_Configuration_API.Encode(Part_Catalog_API.Get_Configurable(ip.part_no)) configurable_db,
             ipc.estimated_material_cost,
             ipc.latest_purchase_price,
             ipc.average_purchase_price
      FROM INVENTORY_PART_CONFIG_TAB ipc, inventory_part_pub ip
      WHERE ipc.contract = ip.contract
      AND ipc.part_no = ip.part_no
      AND ip.contract = contract_
      AND (ip.part_cost_group_id = part_cost_group_ OR part_cost_group_ IS NULL)
      AND (ip.second_commodity = commodity_group2_ OR commodity_group2_ IS NULL)
      AND ip.lead_time_code = lead_time_code_
      AND (ip.part_product_code = product_code_ OR product_code_ IS NULL)
      AND (ip.part_product_family = product_family_ OR product_family_ IS NULL);

BEGIN
   WHILE(Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'CONTRACT') THEN
         contract_ := value_;
      ELSIF (name_ = 'PART_COST_GROUP') THEN
         part_cost_group_ := value_;
      ELSIF (name_ = 'COMMODITY_GROUP2') THEN
         commodity_group2_ := value_;
      ELSIF (name_ = 'LEAD_TIME_CODE') THEN
         lead_time_code_ := value_;
      ELSIF (name_ = 'PRODUCT_CODE') THEN
         product_code_ := value_;
      ELSIF (name_ = 'PRODUCT_FAMILY') THEN
         product_family_ := value_;
      ELSIF (name_ = 'COST_TYPE') THEN
         cost_type_ := value_;
      ELSIF (name_ = 'PERCENTAGE_CHANGE') THEN
         percentage_change_ := value_;
      ELSE
         Error_SYS.Item_Not_Exist(lu_name_, name_, value_);
      END IF;
   END LOOP;

   percentage_change_ := percentage_change_ / 100;
   cost_type_db_      := INVENTORY_BASE_COST_API.Encode(cost_type_);

   FOR rec IN get_parts LOOP
      IF (NOT ((rec.configurable_db = 'CONFIGURED' AND rec.inventory_part_cost_level_db = 'COST PER CONFIGURATION' AND rec.configuration_id = '*') OR (rec.configurable_db = 'CONFIGURED' AND rec.inventory_part_cost_level_db = 'COST PER PART' AND rec.configuration_id != '*'))) THEN
         IF (cost_type_db_ = 'ESTIMATED_MATERIAL_COST') THEN
            IF (rec.estimated_material_cost != 0) THEN
               Modify_Estimated_Material_Cost(rec.contract, rec.part_no, rec.configuration_id, rec.estimated_material_cost + (rec.estimated_material_cost * percentage_change_),TRUE);
            END IF;
         ELSIF (cost_type_db_ = 'LATEST_PURCHASE_PRICE') THEN
            IF (rec.latest_purchase_price != 0) THEN
               Modify_Estimated_Material_Cost(rec.contract, rec.part_no, rec.configuration_id, rec.latest_purchase_price + (rec.latest_purchase_price * percentage_change_),TRUE);
            END IF;
         ELSIF (cost_type_db_ = 'AVERAGE_PURCHASE_PRICE') THEN
            IF (rec.average_purchase_price != 0) THEN
               Modify_Estimated_Material_Cost(rec.contract, rec.part_no, rec.configuration_id, rec.average_purchase_price + (rec.average_purchase_price * percentage_change_),TRUE);
            END IF;
         END IF;
      END IF;
   END LOOP;
END Calculate_Est_Mtr_Cost_Priv__;


-- Modify_Standard_Cost__
--   Method contains all logic needed to decide if the modification of
--   the estimated material cost on the configuration also should lead
--   to a modification of the standard cost for the configuration.
PROCEDURE Modify_Standard_Cost__ (
   contract_                IN VARCHAR2,
   part_no_                 IN VARCHAR2,
   configuration_id_        IN VARCHAR2,
   estimated_material_cost_ IN NUMBER )
IS 
   part_rec_               Inventory_Part_API.Public_Rec;
   costing_cost_           NUMBER;   
   local_configuration_id_ INVENTORY_PART_CONFIG_TAB.configuration_id%TYPE;
   configurable_           VARCHAR2(20);
BEGIN
   part_rec_     := Inventory_Part_API.Get(contract_, part_no_);
   configurable_ := Part_Catalog_API.Get_Configurable_Db(part_no_);

   IF ((part_rec_.inventory_valuation_method = 'ST') AND
       (part_rec_.inventory_part_cost_level IN ('COST PER PART','COST PER CONFIGURATION')) AND
       (part_rec_.invoice_consideration = 'IGNORE INVOICE PRICE')) THEN
   -- Standard cost

      IF ((Component_Cost_SYS.INSTALLED) AND (configuration_id_ = '*')) THEN
         -- Costing does not handle configured parts (configuration_id != '*')
         -- so this check against Costing is not valid for configurations
         IF (configurable_ = 'CONFIGURED') THEN
           local_configuration_id_ := NULL;
         ELSE
           local_configuration_id_ := configuration_id_;
         END IF;

         -- Copy estimated_material_cost to inventory_value as default cost.
         IF NOT ((Invent_Part_Quantity_Util_API.Check_Quantity_Exist(contract_,
                                                                     part_no_,
                                                                     local_configuration_id_)))  THEN
            IF ((part_rec_.zero_cost_flag        = 'N') AND
                (estimated_material_cost_ =  0 )) THEN
               Client_SYS.Add_Info(lu_name_, 'ZEROCOSTN: Inventory value cannot be 0 since :P1 is used.', Inventory_Part_Zero_Cost_API.Decode('N'));               
            ELSIF ((part_rec_.zero_cost_flag         = 'O') AND
                   (estimated_material_cost_ !=  0 )) THEN
               Client_SYS.Add_Info(lu_name_, 'ZEROCOST0: Inventory value must be 0 since :P1 is used.', Inventory_Part_Zero_Cost_API.Decode('O'));              
            ELSE
               $IF (Component_Cost_SYS.INSTALLED) $THEN
                  costing_cost_ := Part_Cost_API.Get_Total_Accum_Cost(contract_, part_no_, 1, '*', '*');
               $END   
             
               -- Only allow the change of inventory value if the value in costing is 0.
               IF (costing_cost_ = 0) THEN
                  --  Inventory Valuation Method:   Standard Cost
                  --  Configuration Id          :   *
                  --  Costing is                :   Installed
                  --  Cost in Costing           :   0
                  --  Quantity On Hand          :   0
                  --  Quantity In Transit       :   0
                  Inventory_Part_Unit_Cost_API.Modify_Standard_Cost(
                                                               contract_,
                                                               part_no_,
                                                               configuration_id_,
                                                               estimated_material_cost_);
               END IF;
            END IF;
         END IF;
      ELSIF ((Component_Ordstr_SYS.INSTALLED) AND
             (configuration_id_ != '*')) THEN
         -- Estimated material cost cannot be copied to Inventory value for a configured part
         -- if Interim Order is installed.
         Client_SYS.Add_Info(lu_name_, 'INTERIM: Estimated material cost is not copied into inventory value for a configuration if Interim Order is installed.');
      ELSE
         -- Costing is not installed OR this is a configuration
         Inventory_Part_Unit_Cost_API.Modify_Standard_Cost(contract_,
                                                           part_no_,
                                                           configuration_id_,
                                                           estimated_material_cost_);
      END IF;
   END IF;
END Modify_Standard_Cost__;
-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Inventory_Value_By_Method
--   Returns the inventory value based on the inventory valuation method being used.
@UncheckedAccess
FUNCTION Get_Inventory_Value_By_Method (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   RETURN (Inventory_Part_Unit_Cost_API.Get_Inventory_Value_By_Method(contract_,
                                                                      part_no_,
                                                                      configuration_id_,
                                                                      NULL,
                                                                      NULL));
END Get_Inventory_Value_By_Method;


-- Calc_Purch_Costs
--   Calculate purchase costs for all parts.
PROCEDURE Calc_Purch_Costs (
   contract_         IN VARCHAR2,
   cost_set_type_    IN VARCHAR2,
   begin_date_       IN DATE,
   end_date_         IN DATE,
   primary_supplier_ IN VARCHAR2 DEFAULT 'FALSE' )
IS
   attr_       VARCHAR2(2000);
   batch_desc_ VARCHAR2(100);
BEGIN
   -- IF the contract is specified then this check kan be performed here.
   -- Else the control will be taken care of in the main method.
   IF contract_ IS NOT NULL THEN
      Site_API.Exist(contract_);
      User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, contract_);
   END IF;

   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_);
   Client_SYS.Add_To_Attr('COST_SET_TYPE', cost_set_type_, attr_);
   Client_SYS.Add_To_Attr('BEGIN_DATE', begin_date_, attr_);
   Client_SYS.Add_To_Attr('END_DATE', end_date_, attr_);
   Client_SYS.Add_To_Attr('PRIMARY_SUPPLIER', primary_supplier_, attr_);
   batch_desc_:= Language_SYS.Translate_Constant(lu_name_,'BDESCCALC: Calculate Purchase Costs');
   Trace_SYS.Message('begin date'||begin_date_ ||' end date-'||end_date_);
   
   IF (TRUNC(begin_date_) > TRUNC(Site_API.Get_Site_Date(contract_))) THEN
         Error_SYS.Record_General(lu_name_, 'BEGINAFTERSYSDATE: The From Date cannot be later than today.');
   END IF;
   
   IF (TRUNC(begin_date_) > TRUNC(end_date_)) THEN
         Error_SYS.Record_General(lu_name_, 'BEGINAFTERENDDATE: The From Date cannot be later than the To Date.');
   END IF;

   Transaction_SYS.Deferred_Call('Inventory_Part_Config_API.Calc_Purch_Costs_Priv__' , attr_, batch_desc_);
END Calc_Purch_Costs;


-- New
--   Method creates a new instance of the object.
PROCEDURE New (
   contract_                IN VARCHAR2,
   part_no_                 IN VARCHAR2,
   configuration_id_        IN VARCHAR2,
   estimated_material_cost_ IN NUMBER )
IS
   newrec_     INVENTORY_PART_CONFIG_TAB%ROWTYPE;
BEGIN
   newrec_.contract                := contract_;
   newrec_.part_no                 := part_no_;
   newrec_.configuration_id        := configuration_id_;
   newrec_.estimated_material_cost := estimated_material_cost_;
   New___(newrec_);
END New;


-- Modify_Estimated_Material_Cost
--   Method used to modify the value of attribute EstimatedMaterialCost.
PROCEDURE Modify_Estimated_Material_Cost (
   contract_                IN VARCHAR2,
   part_no_                 IN VARCHAR2,
   configuration_id_        IN VARCHAR2,
   estimated_material_cost_ IN NUMBER,
   modify_standard_cost_    IN BOOLEAN DEFAULT FALSE )
IS
   objid_      inventory_part_config.objid%TYPE;
   objversion_ inventory_part_config.objversion%TYPE;
   newrec_     inventory_part_config_tab%ROWTYPE;
   oldrec_     inventory_part_config_tab%ROWTYPE;
   attr_       VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN
   oldrec_ := Lock_By_Keys___(contract_, part_no_, configuration_id_);

   IF (estimated_material_cost_ != oldrec_.estimated_material_cost) THEN
      newrec_ := oldrec_;
      newrec_.estimated_material_cost := estimated_material_cost_;
      indrec_ := Get_Indicator_Rec___(oldrec_, newrec_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
      Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE, modify_standard_cost_); -- By keys.
   END IF;
END Modify_Estimated_Material_Cost;


-- Check_Zero_Cost_Flag
--   Method is used for validating modifications of zero_cost_flag in LU InventoryPart.
PROCEDURE Check_Zero_Cost_Flag (
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   zero_cost_flag_db_   IN VARCHAR2,
   part_cost_level_db_  IN VARCHAR2,
   valuation_method_db_ IN VARCHAR2 )
IS
   CURSOR get_records IS
      SELECT configuration_id, estimated_material_cost
      FROM INVENTORY_PART_CONFIG_TAB
      WHERE contract = contract_
      AND   part_no  = part_no_;
BEGIN

   FOR rec_ IN get_records LOOP
      Check_Estimated_Mtrl_Cost___(zero_cost_flag_db_,
                                   rec_.estimated_material_cost);
      
      Inventory_Part_Unit_Cost_API.Check_Zero_Cost_Flag(contract_,
                                                        part_no_,
                                                        rec_.configuration_id,
                                                        zero_cost_flag_db_,
                                                        part_cost_level_db_,
                                                        valuation_method_db_);
   END LOOP;
END Check_Zero_Cost_Flag;


-- Check_Exist
--   Method returns TRUE if an instance of this class with given keys exist.
--   Otherwise returns FALSE.
@UncheckedAccess
FUNCTION Check_Exist (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN Check_Exist___(contract_, part_no_, configuration_id_);
END Check_Exist;


-- Calculate_Est_Mtr_Cost
--   Calculate Estimated Material Cost for all parts.
PROCEDURE Calculate_Est_Mtr_Cost (
   contract_          IN VARCHAR2,
   part_cost_group_   IN VARCHAR2,
   commodity_group2_  IN VARCHAR2,
   lead_time_code_    IN VARCHAR2,
   product_code_      IN VARCHAR2,
   product_family_    IN VARCHAR2,
   cost_type_         IN VARCHAR2,
   percentage_change_ IN NUMBER )
IS   
   attr_       VARCHAR2(2000);
   batch_desc_ VARCHAR2(100);
BEGIN
   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User(), contract_);
   Inv_Part_Lead_Time_Code_API.Exist(lead_time_code_);
   Inventory_Base_Cost_API.Exist(cost_type_);
   IF (part_cost_group_ IS NOT NULL) THEN
      $IF (Component_Cost_SYS.INSTALLED) $THEN
          Part_Cost_Group_API.Exist(contract_, 
                                    part_cost_group_);
      $ELSE
         NULL;
      $END 
   END IF;
   IF (commodity_group2_ IS NOT NULL) THEN
      Commodity_Group_API.Exist(commodity_group2_, true);
   END IF;
   IF (product_family_ IS NOT NULL) THEN
      Inventory_Product_Family_API.Exist(product_family_, true);
   END IF;
   IF (product_code_ IS NOT NULL) THEN
      Inventory_Product_Code_API.Exist(product_code_, true);
   END IF;

   IF (INV_PART_LEAD_TIME_CODE_API.Encode(lead_time_code_) = 'M' AND INVENTORY_BASE_COST_API.Encode(cost_type_) IN('LATEST_PURCHASE_PRICE', 'AVERAGE_PURCHASE_PRICE')) THEN
      Error_SYS.Record_General(lu_name_, 'CANNOT: Cost type :P1 cannot be used when lead time code is :P2.', cost_type_, lead_time_code_);
   END IF;

   Client_SYS.Clear_Attr(attr_);

   Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_);
   Client_SYS.Add_To_Attr('PART_COST_GROUP', part_cost_group_, attr_);
   Client_SYS.Add_To_Attr('COMMODITY_GROUP2', commodity_group2_, attr_);
   Client_SYS.Add_To_Attr('LEAD_TIME_CODE', lead_time_code_, attr_);
   Client_SYS.Add_To_Attr('PRODUCT_CODE', product_code_, attr_);
   Client_SYS.Add_To_Attr('PRODUCT_FAMILY', product_family_, attr_);
   Client_SYS.Add_To_Attr('COST_TYPE', cost_type_, attr_);
   Client_SYS.Add_To_Attr('PERCENTAGE_CHANGE', percentage_change_, attr_);

   trace_sys.field('attr_', attr_);

   batch_desc_:= Language_SYS.Translate_Constant(lu_name_,'UEMC: Update Estimated Material Cost');
   Transaction_SYS.Deferred_Call('Inventory_Part_Config_API.Calculate_Est_Mtr_Cost_Priv__', attr_, batch_desc_);

END Calculate_Est_Mtr_Cost;


-- Add_To_Purchase_Diff
--   Adds a new purchase diff to the accumulated purchase diff value.
--   This can be either a positive or a negative value.
PROCEDURE Add_To_Purchase_Diff (
   contract_                  IN VARCHAR2,
   part_no_                   IN VARCHAR2,
   configuration_id_          IN VARCHAR2,
   accumulated_purchase_diff_ IN NUMBER )
IS
   attr_       VARCHAR2(2000);
   oldrec_     INVENTORY_PART_CONFIG_TAB%ROWTYPE;
   newrec_     INVENTORY_PART_CONFIG_TAB%ROWTYPE;
   objid_      INVENTORY_PART_CONFIG.objid%TYPE;
   objversion_ INVENTORY_PART_CONFIG.objversion%TYPE;
   indrec_     Indicator_Rec;
BEGIN
   oldrec_ := Lock_By_Keys___(contract_, part_no_, configuration_id_);
   newrec_ := oldrec_;
   newrec_.accumulated_purchase_diff := NVL(oldrec_.accumulated_purchase_diff,0) + NVL(accumulated_purchase_diff_,0);
   indrec_ := Get_Indicator_Rec___(oldrec_, newrec_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE, FALSE);
END Add_To_Purchase_Diff;


-- Set_Last_Actual_Cost_Calc
--   Sets the last actual cost calc date.
PROCEDURE Set_Last_Actual_Cost_Calc (
   contract_              IN VARCHAR2,
   part_no_               IN VARCHAR2,
   configuration_id_      IN VARCHAR2,
   last_actual_cost_calc_ IN DATE )
IS
   attr_       VARCHAR2(2000);
   oldrec_     INVENTORY_PART_CONFIG_TAB%ROWTYPE;
   newrec_     INVENTORY_PART_CONFIG_TAB%ROWTYPE;
   objid_      INVENTORY_PART_CONFIG.objid%TYPE;
   objversion_ INVENTORY_PART_CONFIG.objversion%TYPE;
   indrec_     Indicator_Rec;
BEGIN
   oldrec_ := Lock_By_Keys___(contract_, part_no_, configuration_id_);
   newrec_ := oldrec_;
   newrec_.last_actual_cost_calc := last_actual_cost_calc_;
   indrec_ := Get_Indicator_Rec___(oldrec_, newrec_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE, FALSE);
END Set_Last_Actual_Cost_Calc;


-- Set_Last_Manuf_Cost_Calc
--   Sets the last manuf cost calc date.
PROCEDURE Set_Last_Manuf_Cost_Calc (
   contract_             IN VARCHAR2,
   part_no_              IN VARCHAR2,
   configuration_id_     IN VARCHAR2,
   last_manuf_cost_calc_ IN DATE )
IS
   attr_       VARCHAR2(2000);
   oldrec_     INVENTORY_PART_CONFIG_TAB%ROWTYPE;
   newrec_     INVENTORY_PART_CONFIG_TAB%ROWTYPE;
   objid_      INVENTORY_PART_CONFIG.objid%TYPE;
   objversion_ INVENTORY_PART_CONFIG.objversion%TYPE;
   indrec_     Indicator_Rec;
BEGIN
   oldrec_ := Lock_By_Keys___(contract_, part_no_, configuration_id_);
   newrec_ := oldrec_;
   newrec_.last_manuf_cost_calc := last_manuf_cost_calc_;
   indrec_ := Get_Indicator_Rec___(oldrec_, newrec_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE, FALSE);
END Set_Last_Manuf_Cost_Calc;


-- Remove_Actual_Cost_Difference
--   This method looks at the values in attributes AccumulatedManufDiff
--   and AccumulatedPurchaseDiff. If the values these attributes are not
--   equal to zero then the method creates price difference and cost
--   variance transactions and posting in order to set them to zero.
PROCEDURE Remove_Actual_Cost_Difference (
   contract_             IN VARCHAR2,
   part_no_              IN VARCHAR2,
   configuration_id_     IN VARCHAR2 )
IS
   attr_                  VARCHAR2(2000);
   oldrec_                INVENTORY_PART_CONFIG_TAB%ROWTYPE;
   newrec_                INVENTORY_PART_CONFIG_TAB%ROWTYPE;
   objid_                 INVENTORY_PART_CONFIG.objid%TYPE;
   objversion_            INVENTORY_PART_CONFIG.objversion%TYPE;
   purch_diff_            NUMBER;
   manuf_diff_details_    Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   empty_cost_details_    Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   pos_cost_diff_details_ Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   neg_cost_diff_details_ Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   transaction_code_      VARCHAR2(10);
   company_               VARCHAR2(20);
   currency_rounding_     NUMBER;
   order_type_            VARCHAR2(200);
   value_                 NUMBER;
   transaction_id_        NUMBER := 0;
   accounting_id_         NUMBER := 0;
   indrec_                Indicator_Rec;
   accounting_value_      NUMBER;   
   accounting_value_tab_  Mpccom_Accounting_API.Value_Detail_Tab;   

   CURSOR get_configuration IS
      SELECT configuration_id
        FROM INVENTORY_PART_CONFIG_TAB
      WHERE (configuration_id = configuration_id_ OR configuration_id_ IS NULL)
        AND contract = contract_
        AND part_no  = part_no_;
BEGIN

   FOR config_rec_ IN get_configuration LOOP
      oldrec_ := Lock_By_Keys___(contract_, part_no_, config_rec_.configuration_id);

      purch_diff_ := NVL(oldrec_.accumulated_purchase_diff,0);
      manuf_diff_details_ := Inv_Part_Config_Manuf_Diff_API.Get_Cost_Detail_Tab(contract_, part_no_, configuration_id_);

      IF (purch_diff_ != 0) THEN
         newrec_ := oldrec_;
         newrec_.accumulated_purchase_diff := 0;
         indrec_ := Get_Indicator_Rec___(oldrec_, newrec_);
         Check_Update___(oldrec_, newrec_, indrec_, attr_);
         Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE, FALSE);

         company_           := Site_API.Get_Company(contract_);
         currency_rounding_ := Currency_Code_API.Get_Currency_Rounding(company_, Company_Finance_API.Get_Currency_Code(company_));

         IF (ROUND(ABS(purch_diff_), currency_rounding_) > 0) THEN
            IF (purch_diff_ < 0) THEN
               transaction_code_ := 'PODIFF+';
               value_            := (purch_diff_ * (-1));
            ELSE
               transaction_code_ := 'PODIFF-';
               value_            := purch_diff_;
            END IF;
            
            accounting_value_ := value_;
            order_type_ := NULL;

            Inventory_Transaction_Hist_API.New( transaction_id_     =>  transaction_id_,
                                                accounting_id_      =>  accounting_id_,
                                                value_              =>  value_,
                                                transaction_code_   =>  transaction_code_,
                                                contract_           =>  contract_,
                                                part_no_            =>  part_no_,
                                                configuration_id_   =>  config_rec_.configuration_id,
                                                location_no_        =>  NULL,
                                                lot_batch_no_       =>  NULL,
                                                serial_no_          =>  NULL,
                                                waiv_dev_rej_no_    =>  NULL,
                                                eng_chg_level_      =>  NULL,
                                                activity_seq_       =>  0,
                                                project_id_         =>  NULL,
                                                source_ref1_        =>  NULL,
                                                source_ref2_        =>  NULL,
                                                source_ref3_        =>  NULL,
                                                source_ref4_        =>  NULL,
                                                source_ref5_        =>  NULL,
                                                reject_code_        =>  NULL,
                                                cost_detail_tab_    =>  empty_cost_details_,
                                                unit_cost_          =>  NULL,
                                                quantity_           =>  0,
                                                qty_reversed_       =>  0,
                                                catch_quantity_     =>  NULL,
                                                source_             =>  NULL,
                                                source_ref_type_    =>  order_type_,
                                                owning_vendor_no_   =>  NULL,
                                                condition_code_     =>  NULL,
                                                location_group_     =>  NULL,
                                                part_ownership_db_  =>  'COMPANY OWNED',
                                                owning_customer_no_ =>  NULL,
                                                expiration_date_    =>  NULL );

            accounting_value_tab_(1).bucket_posting_group_id := NULL;
            accounting_value_tab_(1).cost_source_id          := NULL;
            accounting_value_tab_(1).value                   := accounting_value_;

            Inventory_Transaction_Hist_API.Do_Booking(transaction_id_     => transaction_id_,
                                                      company_            => company_,
                                                      event_code_         => transaction_code_,
                                                      complete_flag_      => 'Y',
                                                      external_value_tab_ => accounting_value_tab_);
         END IF;
      END IF;

      IF (Inventory_Part_Unit_Cost_API.Non_Zero_Cost_Detail_Exist(manuf_diff_details_)) THEN
         -- Split the cost details into two tables with positive and negative differences
         Inventory_Part_Unit_Cost_API.Create_Cost_Diff_Tables(pos_cost_diff_details_,
                                                              neg_cost_diff_details_,
                                                              empty_cost_details_,
                                                              manuf_diff_details_);


         order_type_ := Order_Type_API.Decode('SHOP ORDER');
                  
         IF (Inventory_Part_Unit_Cost_API.Non_Zero_Cost_Detail_Exist(neg_cost_diff_details_)) THEN
            transaction_code_ := 'SODIFF+';

            Inventory_Transaction_Hist_API.Create_And_Account(transaction_id_     =>  transaction_id_,
                                                              accounting_id_      =>  accounting_id_,
                                                              value_              =>  value_,
                                                              transaction_code_   =>  transaction_code_,
                                                              contract_           =>  contract_,
                                                              part_no_            =>  part_no_,
                                                              configuration_id_   =>  config_rec_.configuration_id,
                                                              location_no_        =>  NULL,
                                                              lot_batch_no_       =>  NULL,
                                                              serial_no_          =>  NULL,
                                                              waiv_dev_rej_no_    =>  NULL,
                                                              eng_chg_level_      =>  NULL,
                                                              activity_seq_       =>  0,
                                                              project_id_         =>  NULL,
                                                              source_ref1_        =>  NULL,
                                                              source_ref2_        =>  NULL,
                                                              source_ref3_        =>  NULL,
                                                              source_ref4_        =>  NULL,
                                                              source_ref5_        =>  NULL,
                                                              reject_code_        =>  NULL,
                                                              cost_detail_tab_    =>  neg_cost_diff_details_,
                                                              unit_cost_          =>  NULL,
                                                              quantity_           =>  1,
                                                              qty_reversed_       =>  0,
                                                              catch_quantity_     =>  NULL,
                                                              source_             =>  NULL,
                                                              source_ref_type_    =>  order_type_,
                                                              owning_vendor_no_   =>  NULL,
                                                              condition_code_     =>  NULL,
                                                              location_group_     =>  NULL,
                                                              part_ownership_db_  =>  'COMPANY OWNED',
                                                              owning_customer_no_ =>  NULL,
                                                              expiration_date_    =>  NULL);

         END IF;
         IF (Inventory_Part_Unit_Cost_API.Non_Zero_Cost_Detail_Exist(pos_cost_diff_details_)) THEN
            transaction_code_ := 'SODIFF-';

            Inventory_Transaction_Hist_API.Create_And_Account(transaction_id_     =>  transaction_id_,
                                                              accounting_id_      =>  accounting_id_,
                                                              value_              =>  value_,
                                                              transaction_code_   =>  transaction_code_,
                                                              contract_           =>  contract_,
                                                              part_no_            =>  part_no_,
                                                              configuration_id_   =>  config_rec_.configuration_id,
                                                              location_no_        =>  NULL,
                                                              lot_batch_no_       =>  NULL,
                                                              serial_no_          =>  NULL,
                                                              waiv_dev_rej_no_    =>  NULL,
                                                              eng_chg_level_      =>  NULL,
                                                              activity_seq_       =>  0,
                                                              project_id_         =>  NULL,
                                                              source_ref1_        =>  NULL,
                                                              source_ref2_        =>  NULL,
                                                              source_ref3_        =>  NULL,
                                                              source_ref4_        =>  NULL,
                                                              source_ref5_        =>  NULL,
                                                              reject_code_        =>  NULL,
                                                              cost_detail_tab_    =>  pos_cost_diff_details_,
                                                              unit_cost_          =>  NULL,
                                                              quantity_           =>  1,
                                                              qty_reversed_       =>  0,
                                                              catch_quantity_     =>  NULL,
                                                              source_             =>  NULL,
                                                              source_ref_type_    =>  order_type_,
                                                              owning_vendor_no_   =>  NULL,
                                                              condition_code_     =>  NULL,
                                                              location_group_     =>  NULL,
                                                              part_ownership_db_  =>  'COMPANY OWNED',
                                                              owning_customer_no_ =>  NULL,
                                                              expiration_date_    =>  NULL);

         END IF;

         -- Clear the diff details
         Inv_Part_Config_Manuf_Diff_API.Clear_Manuf_Diff_Details(contract_, part_no_, config_rec_.configuration_id);

      END IF;

   END LOOP;
END Remove_Actual_Cost_Difference;


-- Get_Net_Weight_And_Unit_Code
--   Returns net weight and unit code fetched based on the configuration_id.
PROCEDURE Get_Net_Weight_And_Unit_Code (
   net_weight_       OUT NUMBER,
   weight_unit_code_ OUT VARCHAR2,
   contract_         IN  VARCHAR2,
   part_no_          IN  VARCHAR2,
   configuration_id_ IN  VARCHAR2 )
IS
   fetch_from_inventory_part_ BOOLEAN := FALSE;
   config_net_weight_         NUMBER;
   config_weight_unit_code_   VARCHAR2(10);   
BEGIN
   IF (NVL(configuration_id_,'*') = '*') THEN
      fetch_from_inventory_part_ := TRUE;
   ELSE
      $IF (Component_Cfgchr_SYS.INSTALLED) $THEN
         DECLARE
            config_spec_rec_   Configuration_Spec_API.Public_Rec;
         BEGIN
            config_spec_rec_         := Configuration_Spec_API.Get(part_no_, configuration_id_);
            config_net_weight_       := config_spec_rec_.net_weight;
            config_weight_unit_code_ := config_spec_rec_.weight_unit_code;
         END;   
              
         IF (config_net_weight_ IS NULL) THEN
            fetch_from_inventory_part_ := TRUE;
         ELSE
            net_weight_       := config_net_weight_;
            weight_unit_code_ := config_weight_unit_code_;
         END IF;
      $ELSE
         fetch_from_inventory_part_ := TRUE;
      $END
   END IF;
 
   IF (fetch_from_inventory_part_) THEN
      net_weight_       := Inventory_Part_API.Get_Weight_Net(contract_, part_no_);
      weight_unit_code_ := Company_Invent_Info_API.Get_Uom_For_Weight(Site_API.Get_Company(contract_));
   END IF;
END Get_Net_Weight_And_Unit_Code;


-- Get_Intrastat_Conv_Factor
--   Returns intrastat conversion factor fetched based on the configuration_id.
FUNCTION Get_Intrastat_Conv_Factor (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   intrastat_conv_factor_ NUMBER;
BEGIN

   IF ((NVL(configuration_id_, '*') != '*')) THEN
      $IF (Component_Cfgchr_SYS.INSTALLED) $THEN
         intrastat_conv_factor_ := Configuration_Spec_API.Get_Intrastat_Conv_Factor(part_no_, configuration_id_);     
      $ELSE
         NULL;
      $END
   END IF;   
   RETURN intrastat_conv_factor_;
END Get_Intrastat_Conv_Factor;


-- Check_Remove_Config_Spec
--   This procedure will call the method Remove_Part_Config___ to perform a
--   check to remove records from InventoryPartConfig with respect to the
--   part configuration.
PROCEDURE Check_Remove_Config_Spec (
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2 )
IS
BEGIN
   Remove_Config_Spec___(part_no_, configuration_id_, 'CHECK');
END Check_Remove_Config_Spec;


-- Do_Remove_Config_Spec
--   This procedure will call the method Remove_Config_Spec___ to remove records
--   from InventoryPartConfig with respect to the part configuration.
PROCEDURE Do_Remove_Config_Spec (
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2 )
IS
BEGIN
   Remove_Config_Spec___(part_no_, configuration_id_, 'DO');
END Do_Remove_Config_Spec;


-- This method is used by DataCaptAddLineCntRep  
@ServerOnlyAccess
PROCEDURE Create_Data_Capture_Lov (
   contract_                   IN VARCHAR2,
   part_no_                    IN VARCHAR2,
   configuration_id_           IN VARCHAR2,
   capture_session_id_         IN NUMBER,
   column_name_                IN VARCHAR2,
   lov_type_db_                IN VARCHAR2 )
IS
   TYPE Get_Lov_Values       IS REF CURSOR;
   get_lov_values_           Get_Lov_Values;
   stmt_                     VARCHAR2(32000);
   TYPE Lov_Value_Tab        IS TABLE OF VARCHAR2(2000) INDEX BY PLS_INTEGER;
   lov_value_tab_            Lov_Value_Tab;
   session_rec_              Data_Capture_Common_Util_API.Session_Rec;
   lov_row_limitation_       NUMBER;
   exit_lov_                 BOOLEAN := FALSE;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);    
      lov_row_limitation_ := Data_Capture_Config_API.Get_Lov_Row_Limitation(session_rec_.capture_process_id, session_rec_.capture_config_id);

      -- extra column check to be sure we have no risk for sql injection into column_name/data_item_id
      Assert_SYS.Assert_Is_View_Column('INVENTORY_PART_CONFIG_PUB', column_name_);
      stmt_ := ' FROM  INVENTORY_PART_CONFIG_PUB
                 WHERE EXISTS (SELECT 1 FROM user_allowed_site_pub WHERE site = contract) ';
      IF (contract_ IS NOT NULL) THEN 
         stmt_ := stmt_ || ' AND contract = :contract_ ';
      ELSE
         stmt_ := stmt_ || ' AND :contract_ IS NULL ';
      END IF;
      IF (part_no_ IS NOT NULL) THEN 
         stmt_ := stmt_ || ' AND part_no = :part_no_ ';
      ELSE
         stmt_ := stmt_ || ' AND :part_no_ IS NULL ';
      END IF;
      IF (configuration_id_ IS NOT NULL) THEN 
         stmt_ := stmt_ || ' AND configuration_id = :configuration_id_ ';
      ELSE
         stmt_ := stmt_ || ' AND :configuration_id_ IS NULL ';
      END IF;
      
      IF (lov_type_db_  = Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN
         -- Don't use DISTINCT select for AUTO PICK 
         stmt_ := 'SELECT ' || column_name_ || stmt_ || ' ORDER BY Utility_SYS.String_To_Number(' || column_name_ || '), ' || column_name_ || ' ASC' ;
      ELSE
         stmt_ := 'SELECT DISTINCT ' || column_name_ || stmt_ || ' ORDER BY Utility_SYS.String_To_Number(' || column_name_ || '), ' || column_name_ || ' ASC';
      END IF;
      @ApproveDynamicStatement(2021-12-09,DAZASE)
      OPEN get_lov_values_ FOR stmt_ USING contract_,
                                           part_no_,
                                           configuration_id_;
      IF (lov_type_db_  = Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN
         -- Only 1 value for AUTO PICK
         FETCH get_lov_values_ INTO lov_value_tab_(1);
      ELSE
         FETCH get_lov_values_ BULK COLLECT INTO lov_value_tab_;
      END IF;
      CLOSE get_lov_values_;

      IF (lov_value_tab_.COUNT > 0) THEN
         FOR i IN lov_value_tab_.FIRST..lov_value_tab_.LAST LOOP
            Data_Capture_Session_Lov_API.New(exit_lov_              => exit_lov_,
                                             capture_session_id_    => capture_session_id_,
                                             lov_item_value_        => lov_value_tab_(i),
                                             lov_item_description_  => NULL,
                                             lov_row_limitation_    => lov_row_limitation_, 
                                             session_rec_           => session_rec_);
            EXIT WHEN exit_lov_;
         END LOOP;
      END IF;
   $ELSE
      NULL;
   $END
END Create_Data_Capture_Lov;



