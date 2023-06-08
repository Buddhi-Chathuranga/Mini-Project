-----------------------------------------------------------------------------
--
--  Logical unit: InventoryValueSimLine
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  111024  MaEelk  Added UAS filter to INVENTORY_VALUE_SIM_LINE_EXT.
--  110531  JeLise  Commented the check on inventory_part_cost_level_db in cursor get_part_configurations in Create_Simulation_Line,
--  110531          so that the inventory value simulation will show a summary of all parts inventory value including parts having
--  110531          all different part cost level (including cost per lot batch, cost per serial etc.) Note that simulated inventory
--  110531          values will be grouped per part and configuration level.
--  100505  KRPELK  Merge Rose Method Documentation.
--  ------------------------------- Eagle -----------------------------------
--  060727  RoJalk  Centralized Part Desc - Use Inventory_Part_API.Get_Description.
--  060601  RoJalk  Enlarge Part Description - Changed view comments.
--  --------------------------------- 13.4.0 ----------------------------------
--  060123  NiDalk  Added Assert safe annotation. 
--  051122  LEPESE  Minor adjustments because of Cost Details in inventory_value_part_tab.
--  050209  DAYJLK  Bug 49407, Added new attributes qty_in_transit and qty_at_customer to the LU
--  050209          and modified Create_Simulation_Line to include this.
--  040428  IsWilk  Rewrote the DBMS_SQL to Native dynamic SQL inside FOR LOOPs.
--  040301  GeKalk  Removed substrb from the view for UNICODE modifications.
--  040202  NaWalk  Removed the fourth variable of DBMS_SQL inside the while loop,for Unicode modification.
--  -------------------------------- 13.3.0 ----------------------------------
--  031022  LEPESE  Redesign of method Create_Simulation_Line because of new functionality
--                  with new part cost levels in InventoryPartUnitCost. Only parts with
--                  part_cost_level = COST PER PART or COST PER CONFIGURATION can be considered.
--  020816  LEPESE  Replaced calls to Inventory_Part_Config_API.Get_Inventory_Value_By_Method
--                  to instead use Inventory_Part_Unit_Cost_API.Get_Inventory_Value_By_Config.
--  **********************  Take Off Baseline  ***********************************
--  011016  OSALLK  Bug Fix 23778,Replaced round(abs(value2_ * partrec_.quantity) with  round(value2_ * partrec_.quantity) to get the correct value for total_value2_
--                    in procedure Create_Simulation_Line.
--  010917  SAHALK  Corrected bug 23778. changed procedure Create_Simulation_Line.
--  001114  JOHW    Corrected handling when comparing two cost sets.
--  000928  JOHW    Changed from Id to ID.
--  000925  JOHESE  Added undefines.
--  000921  JOHW    Removed validation if configuration id is not a star before calling costing.
--  000920  JOHW    Added configuration_id.
--  000811  LEPE    Replaced calls to Inventory_Part_API methods with calls
--                  to Inventory_Part_Config_API methods when fetching costs.
--  000414  NISOSE  Cleaned-up General_SYS.Init_Method.
--  990505  SHVE    Replaced Get_Inventory_Value with Get_Inventory_Value_By_Method.
--  990503  SHVE    General performance improvements.
--  990427  ROOD    Changed usage of public view from LU InventoryPart.
--  990412  SHVE    Upgraded to new performance optimized template.
--  990223  JOKE    Changed parameter order in call to InventoryValuePart.Exist.
--  990215  SHVE    Fixed handling of value1 and value2.
--  990214  SHVE    Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Create_Simulation_Line
--   To save the simulation line information.
PROCEDURE Create_Simulation_Line (
   contract_       IN VARCHAR2,
   stat_year_no_   IN NUMBER,
   stat_period_no_ IN NUMBER,
   simulation_id_  IN NUMBER,
   parameter1_db_  IN VARCHAR2,
   cost_set1_      IN NUMBER,
   parameter2_db_  IN VARCHAR2,
   cost_set2_      IN NUMBER )
IS
   newrec_                 INVENTORY_VALUE_SIM_LINE_TAB%ROWTYPE;
   attr_                   VARCHAR2 (32000);
   objid_                  ROWID;
   objversion_             VARCHAR2(2000);
   stmt_                   VARCHAR2(2000);
   transaction_text_       VARCHAR2(2000);
   value1_                 NUMBER;
   value2_                 NUMBER;
   total_value1_           NUMBER;
   total_value2_           NUMBER;
   amount_diff_            NUMBER;
   percentage_diff_        NUMBER;
   inventory_value_        NUMBER;
   latest_purchase_price_  NUMBER;
   average_purchase_price_ NUMBER;
   count_                  NUMBER;
   currency_rounding_      NUMBER;
   company_                VARCHAR2(20);
   cost_set_value_         NUMBER;
   actual_cost_set_        NUMBER;
   part_config_rec_        Inventory_Part_Config_API.Public_Rec;
   cost_set1_used_         BOOLEAN;
   cost_set2_used_         BOOLEAN;
   value1_used_            BOOLEAN;
   value2_used_            BOOLEAN;
   total_quantity_         NUMBER;
   indrec_                 Indicator_Rec;

   --   The check on inventory_part_cost_level_db has been commented so that the inventory value simulation
   -- will show a summary of all parts inventory value including parts having all different part cost level
   -- (including cost per lot batch, cost per serial etc.) Note that simulated inventory values will be
   -- grouped per part and configuration level.
   CURSOR get_part_configurations(contract_       IN VARCHAR2,
                                  stat_year_no_   IN NUMBER,
                                  stat_period_no_ IN NUMBER) IS
      SELECT ivp.part_no,
             ivp.configuration_id,
             SUM(ivp.quantity)         quantity,
             SUM(ivp.qty_waiv_dev_rej) qty_waiv_dev_rej, 
             SUM(ivp.qty_in_transit)   qty_in_transit,
             SUM(ivp.qty_at_customer)  qty_at_customer
        FROM inventory_value_part_pub ivp, inventory_part_pub ip
       WHERE ivp.contract       = contract_
         AND ivp.stat_year_no   = stat_year_no_
         AND ivp.stat_period_no = stat_period_no_
         AND ivp.contract       = ip.contract
         AND ivp.part_no        = ip.part_no
--         AND ip.inventory_part_cost_level_db IN ('COST PER PART', 'COST PER CONFIGURATION')
         GROUP BY ivp.part_no, ivp.configuration_id;
BEGIN
   transaction_text_ := Language_SYS.Translate_Constant(lu_name_,'SIMLINE: Save the simulated line information', NULL);
   Transaction_SYS.Set_Progress_Info(transaction_text_);

   company_           := Site_API.Get_Company(contract_);
   currency_rounding_ := Currency_Code_API.Get_Currency_Rounding(company_,
                                                                 Company_Finance_API.Get_Currency_Code(company_));

   -- fetch all parts from InventoryValuePart.
   FOR cursor_rec_ IN get_part_configurations(contract_,
                                              stat_year_no_,
                                              stat_period_no_) LOOP
      value1_ := 0;
      value2_ := 0;

      inventory_value_ := Inventory_Part_Unit_Cost_API.Get_Inventory_Value_By_Method(
                                                        contract_,
                                                        cursor_rec_.part_no,
                                                        cursor_rec_.configuration_id,
                                                        NULL,
                                                        NULL);

      part_config_rec_ := Inventory_Part_Config_API.Get(contract_,
                                                        cursor_rec_.part_no,
                                                        cursor_rec_.configuration_id);

      latest_purchase_price_  := part_config_rec_.latest_purchase_price;
      average_purchase_price_ := part_config_rec_.average_purchase_price;

      IF (parameter1_db_ = 'INVENTORY VALUE') THEN
         value1_ := inventory_value_;
      ELSIF (parameter1_db_ = 'LATEST PURCHASE PRICE') THEN
         value1_ := latest_purchase_price_;
      ELSIF (parameter1_db_ = 'AVERAGE PURCHASE PRICE') THEN
         value1_ := average_purchase_price_;
      END IF;

      IF (parameter2_db_ = 'INVENTORY VALUE') THEN
         value2_ := inventory_value_;
      ELSIF (parameter2_db_ = 'LATEST PURCHASE PRICE') THEN
         value2_ := latest_purchase_price_;
      ELSIF (parameter2_db_ = 'AVERAGE PURCHASE PRICE') THEN
         value2_ := average_purchase_price_;
      END IF;

      count_ := 0;
      IF (cost_set1_ > 0 AND cost_set2_ > 0) THEN
         count_ := 2;
      ELSIF (cost_set1_ > 0 OR cost_set2_ > 0) THEN
         count_ := 1;
      END IF;

      cost_set1_used_ := FALSE;
      cost_set2_used_ := FALSE;
      value1_used_    := FALSE;
      value2_used_    := FALSE;

      WHILE (count_ > 0) LOOP
         stmt_ := 'BEGIN :cost_set_value := Cost_Int_API.Get_Total_Cost_Per_Cost_Set(:contract, :part_no,:cost_set); END;';

         IF (cost_set1_ > 0 AND NOT cost_set1_used_) THEN
            actual_cost_set_ := cost_set1_;
            cost_set1_used_  := TRUE;
         ELSIF (cost_set2_ > 0 AND NOT cost_set2_used_) THEN
            actual_cost_set_ := cost_set2_;
            cost_set2_used_  := TRUE;
         END IF;

         @ApproveDynamicStatement(2006-01-23,nidalk)
         EXECUTE IMMEDIATE stmt_
            USING OUT cost_set_value_,
                  IN  contract_,
                  IN  cursor_rec_.part_no,
                  IN  actual_cost_set_;

            IF (cost_set1_ > 0 AND NOT value1_used_) THEN
               value1_      := Nvl(cost_set_value_,0);
               value1_used_ := TRUE;
            ELSIF (cost_set2_ > 0 AND NOT value2_used_) THEN
               value2_      := Nvl(cost_set_value_,0);
               value2_used_ := TRUE;
            END IF;
            count_ := count_ -1;
      END LOOP;

      total_quantity_ := cursor_rec_.quantity + 
                         cursor_rec_.qty_waiv_dev_rej + 
                         cursor_rec_.qty_in_transit + 
                         cursor_rec_.qty_at_customer;

       
      total_value1_ := round(value1_ * total_quantity_, currency_rounding_);
      total_value2_ := round(value2_ * total_quantity_, currency_rounding_);
      amount_diff_  := abs(total_value1_) - abs(total_value2_);

      IF (total_value1_ = 0 AND total_value2_ != 0) THEN
         percentage_diff_ := -100;
      ELSIF (total_value1_ = 0 AND total_value2_ = 0) THEN
         percentage_diff_ := 0;
      ELSE
         percentage_diff_ := round(100 * (amount_diff_/abs(total_value1_)),0);
      END IF;
        
      Trace_sys.message('>>>>>>..total_value1_'||total_value1_);
      Trace_sys.message('>>>>>>..total_value2_'||total_value2_);

      -- save simulation detail info
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_);
      Client_SYS.Add_To_Attr('STAT_YEAR_NO', stat_year_no_, attr_);
      Client_SYS.Add_To_Attr('STAT_PERIOD_NO', stat_period_no_, attr_);
      Client_SYS.Add_To_Attr('SIMULATION_ID', simulation_id_, attr_);
      Client_SYS.Add_To_Attr('PART_NO', cursor_rec_.part_no, attr_);
      Client_SYS.Add_To_Attr('CONFIGURATION_ID', cursor_rec_.configuration_id, attr_);
      Client_SYS.Add_To_Attr('QUANTITY', cursor_rec_.quantity, attr_);
      Client_SYS.Add_To_Attr('QTY_WAIV_DEV_REJ', cursor_rec_.qty_waiv_dev_rej, attr_);
      Client_SYS.Add_To_Attr('VALUE1', total_value1_, attr_);
      Client_SYS.Add_To_Attr('VALUE2', total_value2_, attr_);
      Client_SYS.Add_To_Attr('AMOUNT_DIFF', amount_diff_, attr_);
      Client_SYS.Add_To_Attr('PERCENTAGE_DIFF', percentage_diff_, attr_);
      Client_SYS.Add_To_Attr('QTY_IN_TRANSIT', cursor_rec_.qty_in_transit, attr_);
      Client_SYS.Add_To_Attr('QTY_AT_CUSTOMER', cursor_rec_.qty_at_customer, attr_);

      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);
   END LOOP;
END Create_Simulation_Line;



