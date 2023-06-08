-----------------------------------------------------------------------------
--
--  Logical unit: InventoryPart
--  Component:    INVENT
--
--  Template:     3.0
--  Built by:     IFS Developer Studio (unit-test)
--
--  NOTE! Do not edit!! This file is completely generated and will be
--        overwritten next time the corresponding model is saved.
-----------------------------------------------------------------------------

layer Base;

-------------------- PUBLIC DECLARATIONS ------------------------------------

--TYPE Primary_Key_Rec IS RECORD
--  (contract                       INVENTORY_PART_TAB.contract%TYPE,
--   part_no                        INVENTORY_PART_TAB.part_no%TYPE);

TYPE Public_Rec IS RECORD
  (contract                       INVENTORY_PART_TAB.contract%TYPE,
   part_no                        INVENTORY_PART_TAB.part_no%TYPE,
   "rowid"                        rowid,
   rowversion                     INVENTORY_PART_TAB.rowversion%TYPE,
   rowkey                         INVENTORY_PART_TAB.rowkey%TYPE,
   accounting_group               INVENTORY_PART_TAB.accounting_group%TYPE,
   asset_class                    INVENTORY_PART_TAB.asset_class%TYPE,
   country_of_origin              INVENTORY_PART_TAB.country_of_origin%TYPE,
   hazard_code                    INVENTORY_PART_TAB.hazard_code%TYPE,
   note_id                        INVENTORY_PART_TAB.note_id%TYPE,
   part_product_code              INVENTORY_PART_TAB.part_product_code%TYPE,
   part_product_family            INVENTORY_PART_TAB.part_product_family%TYPE,
   part_status                    INVENTORY_PART_TAB.part_status%TYPE,
   planner_buyer                  INVENTORY_PART_TAB.planner_buyer%TYPE,
   prime_commodity                INVENTORY_PART_TAB.prime_commodity%TYPE,
   second_commodity               INVENTORY_PART_TAB.second_commodity%TYPE,
   unit_meas                      INVENTORY_PART_TAB.unit_meas%TYPE,
   catch_unit_meas                INVENTORY_PART_TAB.catch_unit_meas%TYPE,
   abc_class                      INVENTORY_PART_TAB.abc_class%TYPE,
   abc_class_locked_until         INVENTORY_PART_TAB.abc_class_locked_until%TYPE,
   count_variance                 INVENTORY_PART_TAB.count_variance%TYPE,
   create_date                    INVENTORY_PART_TAB.create_date%TYPE,
   cycle_code                     INVENTORY_PART_TAB.cycle_code%TYPE,
   cycle_period                   INVENTORY_PART_TAB.cycle_period%TYPE,
   dim_quality                    INVENTORY_PART_TAB.dim_quality%TYPE,
   durability_day                 INVENTORY_PART_TAB.durability_day%TYPE,
   expected_leadtime              INVENTORY_PART_TAB.expected_leadtime%TYPE,
   lead_time_code                 INVENTORY_PART_TAB.lead_time_code%TYPE,
   manuf_leadtime                 INVENTORY_PART_TAB.manuf_leadtime%TYPE,
   oe_alloc_assign_flag           INVENTORY_PART_TAB.oe_alloc_assign_flag%TYPE,
   onhand_analysis_flag           INVENTORY_PART_TAB.onhand_analysis_flag%TYPE,
   purch_leadtime                 INVENTORY_PART_TAB.purch_leadtime%TYPE,
   earliest_ultd_supply_date      INVENTORY_PART_TAB.earliest_ultd_supply_date%TYPE,
   supersedes                     INVENTORY_PART_TAB.supersedes%TYPE,
   supply_code                    INVENTORY_PART_TAB.supply_code%TYPE,
   type_code                      INVENTORY_PART_TAB.type_code%TYPE,
   customs_stat_no                INVENTORY_PART_TAB.customs_stat_no%TYPE,
   type_designation               INVENTORY_PART_TAB.type_designation%TYPE,
   zero_cost_flag                 INVENTORY_PART_TAB.zero_cost_flag%TYPE,
   avail_activity_status          INVENTORY_PART_TAB.avail_activity_status%TYPE,
   eng_attribute                  INVENTORY_PART_TAB.eng_attribute%TYPE,
   shortage_flag                  INVENTORY_PART_TAB.shortage_flag%TYPE,
   forecast_consumption_flag      INVENTORY_PART_TAB.forecast_consumption_flag%TYPE,
   stock_management               INVENTORY_PART_TAB.stock_management%TYPE,
   intrastat_conv_factor          INVENTORY_PART_TAB.intrastat_conv_factor%TYPE,
   part_cost_group_id             INVENTORY_PART_TAB.part_cost_group_id%TYPE,
   dop_connection                 INVENTORY_PART_TAB.dop_connection%TYPE,
   std_name_id                    INVENTORY_PART_TAB.std_name_id%TYPE,
   inventory_valuation_method     INVENTORY_PART_TAB.inventory_valuation_method%TYPE,
   negative_on_hand               INVENTORY_PART_TAB.negative_on_hand%TYPE,
   technical_coordinator_id       INVENTORY_PART_TAB.technical_coordinator_id%TYPE,
   invoice_consideration          INVENTORY_PART_TAB.invoice_consideration%TYPE,
   actual_cost_activated          INVENTORY_PART_TAB.actual_cost_activated%TYPE,
   max_actual_cost_update         INVENTORY_PART_TAB.max_actual_cost_update%TYPE,
   cust_warranty_id               INVENTORY_PART_TAB.cust_warranty_id%TYPE,
   sup_warranty_id                INVENTORY_PART_TAB.sup_warranty_id%TYPE,
   region_of_origin               INVENTORY_PART_TAB.region_of_origin%TYPE,
   inventory_part_cost_level      INVENTORY_PART_TAB.inventory_part_cost_level%TYPE,
   ext_service_cost_method        INVENTORY_PART_TAB.ext_service_cost_method%TYPE,
   supply_chain_part_group        INVENTORY_PART_TAB.supply_chain_part_group%TYPE,
   automatic_capability_check     INVENTORY_PART_TAB.automatic_capability_check%TYPE,
   input_unit_meas_group_id       INVENTORY_PART_TAB.input_unit_meas_group_id%TYPE,
   dop_netting                    INVENTORY_PART_TAB.dop_netting%TYPE,
   co_reserve_onh_analys_flag     INVENTORY_PART_TAB.co_reserve_onh_analys_flag%TYPE,
   qty_calc_rounding              INVENTORY_PART_TAB.qty_calc_rounding%TYPE,
   lifecycle_stage                INVENTORY_PART_TAB.lifecycle_stage%TYPE,
   life_stage_locked_until        INVENTORY_PART_TAB.life_stage_locked_until%TYPE,
   frequency_class                INVENTORY_PART_TAB.frequency_class%TYPE,
   freq_class_locked_until        INVENTORY_PART_TAB.freq_class_locked_until%TYPE,
   first_stat_issue_date          INVENTORY_PART_TAB.first_stat_issue_date%TYPE,
   latest_stat_issue_date         INVENTORY_PART_TAB.latest_stat_issue_date%TYPE,
   decline_date                   INVENTORY_PART_TAB.decline_date%TYPE,
   expired_date                   INVENTORY_PART_TAB.expired_date%TYPE,
   decline_issue_counter          INVENTORY_PART_TAB.decline_issue_counter%TYPE,
   expired_issue_counter          INVENTORY_PART_TAB.expired_issue_counter%TYPE,
   min_durab_days_co_deliv        INVENTORY_PART_TAB.min_durab_days_co_deliv%TYPE,
   min_durab_days_planning        INVENTORY_PART_TAB.min_durab_days_planning%TYPE,
   storage_width_requirement      INVENTORY_PART_TAB.storage_width_requirement%TYPE,
   storage_height_requirement     INVENTORY_PART_TAB.storage_height_requirement%TYPE,
   storage_depth_requirement      INVENTORY_PART_TAB.storage_depth_requirement%TYPE,
   storage_volume_requirement     INVENTORY_PART_TAB.storage_volume_requirement%TYPE,
   storage_weight_requirement     INVENTORY_PART_TAB.storage_weight_requirement%TYPE,
   min_storage_temperature        INVENTORY_PART_TAB.min_storage_temperature%TYPE,
   max_storage_temperature        INVENTORY_PART_TAB.max_storage_temperature%TYPE,
   min_storage_humidity           INVENTORY_PART_TAB.min_storage_humidity%TYPE,
   max_storage_humidity           INVENTORY_PART_TAB.max_storage_humidity%TYPE,
   standard_putaway_qty           INVENTORY_PART_TAB.standard_putaway_qty%TYPE,
   reset_config_std_cost          INVENTORY_PART_TAB.reset_config_std_cost%TYPE,
   mandatory_expiration_date      INVENTORY_PART_TAB.mandatory_expiration_date%TYPE,
   excl_ship_pack_proposal        INVENTORY_PART_TAB.excl_ship_pack_proposal%TYPE,
   statistical_code               INVENTORY_PART_TAB.statistical_code%TYPE,
   acquisition_origin             INVENTORY_PART_TAB.acquisition_origin%TYPE,
   acquisition_reason_id          INVENTORY_PART_TAB.acquisition_reason_id%TYPE);




-------------------- PRIVATE DECLARATIONS -----------------------------------

TYPE Indicator_Rec IS RECORD
  (contract                       BOOLEAN := FALSE,
   part_no                        BOOLEAN := FALSE,
   accounting_group               BOOLEAN := FALSE,
   asset_class                    BOOLEAN := FALSE,
   country_of_origin              BOOLEAN := FALSE,
   hazard_code                    BOOLEAN := FALSE,
   note_id                        BOOLEAN := FALSE,
   part_product_code              BOOLEAN := FALSE,
   part_product_family            BOOLEAN := FALSE,
   part_status                    BOOLEAN := FALSE,
   planner_buyer                  BOOLEAN := FALSE,
   prime_commodity                BOOLEAN := FALSE,
   second_commodity               BOOLEAN := FALSE,
   unit_meas                      BOOLEAN := FALSE,
   catch_unit_meas                BOOLEAN := FALSE,
   description                    BOOLEAN := FALSE,
   abc_class                      BOOLEAN := FALSE,
   abc_class_locked_until         BOOLEAN := FALSE,
   count_variance                 BOOLEAN := FALSE,
   create_date                    BOOLEAN := FALSE,
   cycle_code                     BOOLEAN := FALSE,
   cycle_period                   BOOLEAN := FALSE,
   dim_quality                    BOOLEAN := FALSE,
   durability_day                 BOOLEAN := FALSE,
   expected_leadtime              BOOLEAN := FALSE,
   last_activity_date             BOOLEAN := FALSE,
   lead_time_code                 BOOLEAN := FALSE,
   manuf_leadtime                 BOOLEAN := FALSE,
   note_text                      BOOLEAN := FALSE,
   oe_alloc_assign_flag           BOOLEAN := FALSE,
   onhand_analysis_flag           BOOLEAN := FALSE,
   purch_leadtime                 BOOLEAN := FALSE,
   earliest_ultd_supply_date      BOOLEAN := FALSE,
   supersedes                     BOOLEAN := FALSE,
   supply_code                    BOOLEAN := FALSE,
   type_code                      BOOLEAN := FALSE,
   customs_stat_no                BOOLEAN := FALSE,
   type_designation               BOOLEAN := FALSE,
   zero_cost_flag                 BOOLEAN := FALSE,
   avail_activity_status          BOOLEAN := FALSE,
   eng_attribute                  BOOLEAN := FALSE,
   shortage_flag                  BOOLEAN := FALSE,
   forecast_consumption_flag      BOOLEAN := FALSE,
   stock_management               BOOLEAN := FALSE,
   intrastat_conv_factor          BOOLEAN := FALSE,
   part_cost_group_id             BOOLEAN := FALSE,
   dop_connection                 BOOLEAN := FALSE,
   std_name_id                    BOOLEAN := FALSE,
   inventory_valuation_method     BOOLEAN := FALSE,
   negative_on_hand               BOOLEAN := FALSE,
   technical_coordinator_id       BOOLEAN := FALSE,
   invoice_consideration          BOOLEAN := FALSE,
   actual_cost_activated          BOOLEAN := FALSE,
   max_actual_cost_update         BOOLEAN := FALSE,
   cust_warranty_id               BOOLEAN := FALSE,
   sup_warranty_id                BOOLEAN := FALSE,
   region_of_origin               BOOLEAN := FALSE,
   inventory_part_cost_level      BOOLEAN := FALSE,
   ext_service_cost_method        BOOLEAN := FALSE,
   supply_chain_part_group        BOOLEAN := FALSE,
   automatic_capability_check     BOOLEAN := FALSE,
   input_unit_meas_group_id       BOOLEAN := FALSE,
   dop_netting                    BOOLEAN := FALSE,
   co_reserve_onh_analys_flag     BOOLEAN := FALSE,
   qty_calc_rounding              BOOLEAN := FALSE,
   lifecycle_stage                BOOLEAN := FALSE,
   life_stage_locked_until        BOOLEAN := FALSE,
   frequency_class                BOOLEAN := FALSE,
   freq_class_locked_until        BOOLEAN := FALSE,
   first_stat_issue_date          BOOLEAN := FALSE,
   latest_stat_issue_date         BOOLEAN := FALSE,
   decline_date                   BOOLEAN := FALSE,
   expired_date                   BOOLEAN := FALSE,
   decline_issue_counter          BOOLEAN := FALSE,
   expired_issue_counter          BOOLEAN := FALSE,
   min_durab_days_co_deliv        BOOLEAN := FALSE,
   min_durab_days_planning        BOOLEAN := FALSE,
   storage_width_requirement      BOOLEAN := FALSE,
   storage_height_requirement     BOOLEAN := FALSE,
   storage_depth_requirement      BOOLEAN := FALSE,
   storage_volume_requirement     BOOLEAN := FALSE,
   storage_weight_requirement     BOOLEAN := FALSE,
   min_storage_temperature        BOOLEAN := FALSE,
   max_storage_temperature        BOOLEAN := FALSE,
   min_storage_humidity           BOOLEAN := FALSE,
   max_storage_humidity           BOOLEAN := FALSE,
   standard_putaway_qty           BOOLEAN := FALSE,
   putaway_zone_refill_option     BOOLEAN := FALSE,
   reset_config_std_cost          BOOLEAN := FALSE,
   mandatory_expiration_date      BOOLEAN := FALSE,
   excl_ship_pack_proposal        BOOLEAN := FALSE,
   statistical_code               BOOLEAN := FALSE,
   acquisition_origin             BOOLEAN := FALSE,
   acquisition_reason_id          BOOLEAN := FALSE);

TYPE Micro_Cache_Rec IS RECORD
  (accounting_group               INVENTORY_PART_TAB.accounting_group%TYPE,
   asset_class                    INVENTORY_PART_TAB.asset_class%TYPE,
   note_id                        INVENTORY_PART_TAB.note_id%TYPE,
   part_product_code              INVENTORY_PART_TAB.part_product_code%TYPE,
   part_product_family            INVENTORY_PART_TAB.part_product_family%TYPE,
   part_status                    INVENTORY_PART_TAB.part_status%TYPE,
   planner_buyer                  INVENTORY_PART_TAB.planner_buyer%TYPE,
   prime_commodity                INVENTORY_PART_TAB.prime_commodity%TYPE,
   second_commodity               INVENTORY_PART_TAB.second_commodity%TYPE,
   unit_meas                      INVENTORY_PART_TAB.unit_meas%TYPE,
   abc_class                      INVENTORY_PART_TAB.abc_class%TYPE,
   abc_class_locked_until         INVENTORY_PART_TAB.abc_class_locked_until%TYPE,
   durability_day                 INVENTORY_PART_TAB.durability_day%TYPE,
   expected_leadtime              INVENTORY_PART_TAB.expected_leadtime%TYPE,
   lead_time_code                 INVENTORY_PART_TAB.lead_time_code%TYPE,
   manuf_leadtime                 INVENTORY_PART_TAB.manuf_leadtime%TYPE,
   purch_leadtime                 INVENTORY_PART_TAB.purch_leadtime%TYPE,
   earliest_ultd_supply_date      INVENTORY_PART_TAB.earliest_ultd_supply_date%TYPE,
   type_code                      INVENTORY_PART_TAB.type_code%TYPE,
   stock_management               INVENTORY_PART_TAB.stock_management%TYPE,
   invoice_consideration          INVENTORY_PART_TAB.invoice_consideration%TYPE,
   qty_calc_rounding              INVENTORY_PART_TAB.qty_calc_rounding%TYPE,
   lifecycle_stage                INVENTORY_PART_TAB.lifecycle_stage%TYPE,
   life_stage_locked_until        INVENTORY_PART_TAB.life_stage_locked_until%TYPE,
   frequency_class                INVENTORY_PART_TAB.frequency_class%TYPE,
   freq_class_locked_until        INVENTORY_PART_TAB.freq_class_locked_until%TYPE,
   min_durab_days_co_deliv        INVENTORY_PART_TAB.min_durab_days_co_deliv%TYPE,
   min_durab_days_planning        INVENTORY_PART_TAB.min_durab_days_planning%TYPE,
   storage_width_requirement      INVENTORY_PART_TAB.storage_width_requirement%TYPE,
   storage_height_requirement     INVENTORY_PART_TAB.storage_height_requirement%TYPE,
   storage_depth_requirement      INVENTORY_PART_TAB.storage_depth_requirement%TYPE,
   storage_volume_requirement     INVENTORY_PART_TAB.storage_volume_requirement%TYPE,
   storage_weight_requirement     INVENTORY_PART_TAB.storage_weight_requirement%TYPE,
   min_storage_temperature        INVENTORY_PART_TAB.min_storage_temperature%TYPE,
   max_storage_temperature        INVENTORY_PART_TAB.max_storage_temperature%TYPE,
   min_storage_humidity           INVENTORY_PART_TAB.min_storage_humidity%TYPE,
   max_storage_humidity           INVENTORY_PART_TAB.max_storage_humidity%TYPE,
   standard_putaway_qty           INVENTORY_PART_TAB.standard_putaway_qty%TYPE,
   putaway_zone_refill_option     INVENTORY_PART_TAB.putaway_zone_refill_option%TYPE,
   reset_config_std_cost          INVENTORY_PART_TAB.reset_config_std_cost%TYPE,
   mandatory_expiration_date      INVENTORY_PART_TAB.mandatory_expiration_date%TYPE,
   excl_ship_pack_proposal        INVENTORY_PART_TAB.excl_ship_pack_proposal%TYPE,
   statistical_code               INVENTORY_PART_TAB.statistical_code%TYPE,
   acquisition_origin             INVENTORY_PART_TAB.acquisition_origin%TYPE,
   acquisition_reason_id          INVENTORY_PART_TAB.acquisition_reason_id%TYPE);

micro_cache_id_                    VARCHAR2(4000);
micro_cache_value_                 Micro_Cache_Rec;
micro_cache_time_                  NUMBER := 0;
micro_cache_user_                  VARCHAR2(30);
max_cached_element_life_           CONSTANT NUMBER := 100;
-------------------- BASE METHODS -------------------------------------------

-- Invalidate_Cache___
--   Clears the micro cache so that a new update will be forced next
--   time the cache is read.
PROCEDURE Invalidate_Cache___
IS
   null_value_ Micro_Cache_Rec;
BEGIN
   micro_cache_id_ := NULL;
   micro_cache_value_ := null_value_;
   micro_cache_time_  := 0;
END Invalidate_Cache___;


-- Update_Cache___
--   Updates the micro cache with new data.
PROCEDURE Update_Cache___ (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 )
IS
   req_id_     VARCHAR2(1000) := contract_||'^'||part_no_;
   null_value_ Micro_Cache_Rec;
   time_       NUMBER;
   expired_    BOOLEAN;
BEGIN
   time_    := Database_SYS.Get_Time_Offset;
   expired_ := ((time_ - micro_cache_time_) > max_cached_element_life_);
   IF (expired_ OR (micro_cache_user_ IS NULL) OR (micro_cache_user_ != Fnd_Session_API.Get_Fnd_User)) THEN
      Invalidate_Cache___;
      micro_cache_user_ := Fnd_Session_API.Get_Fnd_User;
   END IF;
   IF (expired_ OR (micro_cache_id_ IS NULL) OR (micro_cache_id_ != req_id_)) THEN
      SELECT
              accounting_group, 
              asset_class, 
              note_id, 
              part_product_code, 
              part_product_family, 
              part_status, 
              planner_buyer, 
              prime_commodity, 
              second_commodity, 
              unit_meas, 
              abc_class, 
              abc_class_locked_until, 
              durability_day, 
              expected_leadtime, 
              lead_time_code, 
              manuf_leadtime, 
              purch_leadtime, 
              earliest_ultd_supply_date, 
              type_code, 
              stock_management, 
              invoice_consideration, 
              qty_calc_rounding, 
              lifecycle_stage, 
              life_stage_locked_until, 
              frequency_class, 
              freq_class_locked_until, 
              min_durab_days_co_deliv, 
              min_durab_days_planning, 
              storage_width_requirement, 
              storage_height_requirement, 
              storage_depth_requirement, 
              storage_volume_requirement, 
              storage_weight_requirement, 
              min_storage_temperature, 
              max_storage_temperature, 
              min_storage_humidity, 
              max_storage_humidity, 
              standard_putaway_qty, 
              putaway_zone_refill_option, 
              reset_config_std_cost, 
              mandatory_expiration_date, 
              excl_ship_pack_proposal, 
              statistical_code, 
              acquisition_origin, 
              acquisition_reason_id
      INTO  micro_cache_value_
      FROM  inventory_part_tab
      WHERE contract = contract_
      AND   part_no = part_no_;
      micro_cache_id_ := req_id_;
      micro_cache_time_ := time_;
   END IF;
EXCEPTION
   WHEN no_data_found THEN
      micro_cache_value_ := null_value_;
      micro_cache_id_    := NULL;
      micro_cache_time_  := time_;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(contract_, part_no_, 'Update_Cache___');
END Update_Cache___;


-- Key_Message___
--    Returns an error message containing the keys.
FUNCTION Key_Message___ (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2 
IS
   msg_ VARCHAR2(4000) := Message_SYS.Construct('ERROR_KEY');
BEGIN
   Message_SYS.Add_Attribute(msg_, 'CONTRACT', contract_);
   Message_SYS.Add_Attribute(msg_, 'PART_NO', part_no_);
   RETURN msg_;
END Key_Message___;

-- Formatted_Key___
--    Returns an error string containing the keys.
FUNCTION Formatted_Key___ (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   formatted_key_ VARCHAR2(4000) := Language_SYS.Translate_Item_Prompt_(lu_name_, 'CONTRACT', Fnd_Session_API.Get_Language) || ': ' || contract_ || ', ' ||
                                    Language_SYS.Translate_Item_Prompt_(lu_name_, 'PART_NO', Fnd_Session_API.Get_Language) || ': ' || part_no_;
BEGIN
   RETURN formatted_key_;
END Formatted_Key___;

-- Raise_Too_Many_Rows___
--    Raises error for: More then one row found for a single key.
PROCEDURE Raise_Too_Many_Rows___ (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2,
   methodname_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Set_Key_Values(Key_Message___(contract_, part_no_),
                            Formatted_Key___(contract_, part_no_));
   Error_SYS.Fnd_Too_Many_Rows(Inventory_Part_API.lu_name_, NULL, methodname_);
END Raise_Too_Many_Rows___;


-- Raise_Record_Not_Exist___
--    Raises error for: No data found for given key.
PROCEDURE Raise_Record_Not_Exist___ (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Set_Key_Values(Key_Message___(contract_, part_no_),
                            Formatted_Key___(contract_, part_no_));
   Error_SYS.Fnd_Record_Not_Exist(Inventory_Part_API.lu_name_);
END Raise_Record_Not_Exist___;


-- Raise_Record_Exist___
--    Raises error for: Data with given key value already exist.
PROCEDURE Raise_Record_Exist___ (
   rec_ IN inventory_part_tab%ROWTYPE )
IS
BEGIN
   Error_SYS.Set_Key_Values(Key_Message___(rec_.contract, rec_.part_no),
                            Formatted_Key___(rec_.contract, rec_.part_no));
   Error_SYS.Fnd_Record_Exist(Inventory_Part_API.lu_name_);
END Raise_Record_Exist___;

-- Raise_Constraint_Violated___
--    Raises error for: Data with given value for constraint that already exist.
--    constraint_ contains the violated constraint to be used when overriding the method.
PROCEDURE Raise_Constraint_Violated___ (
   rec_ IN inventory_part_tab%ROWTYPE,
   constraint_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Fnd_Record_Exist(Inventory_Part_API.lu_name_);
END Raise_Constraint_Violated___;


-- Raise_Item_Format___
--    Raises error for: Data value format is incorrect.
PROCEDURE Raise_Item_Format___ (
   name_ IN VARCHAR2,
   value_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Fnd_Item_Format(Inventory_Part_API.lu_name_, name_, value_);
END Raise_Item_Format___;

-- Raise_Record_Modified___
--    Raises error for: The database row is newer then the current.
PROCEDURE Raise_Record_Modified___ (
   rec_ IN inventory_part_tab%ROWTYPE )
IS
BEGIN
   Error_SYS.Set_Key_Values(Key_Message___(rec_.contract, rec_.part_no),
                            Formatted_Key___(rec_.contract, rec_.part_no));
   Error_SYS.Fnd_Record_Modified(Inventory_Part_API.lu_name_);
END Raise_Record_Modified___;


-- Raise_Record_Locked___
--    Raises error for: The database row is already locked.
PROCEDURE Raise_Record_Locked___ (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Set_Key_Values(Key_Message___(contract_, part_no_),
                            Formatted_Key___(contract_, part_no_));
   Error_SYS.Fnd_Record_Locked(Inventory_Part_API.lu_name_);
END Raise_Record_Locked___;


-- Raise_Record_Removed___
--    Raises error for: The database row is no longer present.
PROCEDURE Raise_Record_Removed___ (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Set_Key_Values(Key_Message___(contract_, part_no_),
                            Formatted_Key___(contract_, part_no_));
   Error_SYS.Fnd_Record_Removed(Inventory_Part_API.lu_name_);
END Raise_Record_Removed___;


-- Lock_By_Id___
--    Locks a database row based on the objid and objversion.
FUNCTION Lock_By_Id___ (
   objid_      IN VARCHAR2,
   objversion_ IN VARCHAR2 ) RETURN inventory_part_tab%ROWTYPE
IS
   row_locked  EXCEPTION;
   PRAGMA      EXCEPTION_INIT(row_locked, -0054);
   rec_        inventory_part_tab%ROWTYPE;
BEGIN
   SELECT *
      INTO  rec_
      FROM  inventory_part_tab
      WHERE rowid = objid_
      AND    to_char(rowversion,'YYYYMMDDHH24MISS') = objversion_
      FOR UPDATE NOWAIT;
   RETURN rec_;
EXCEPTION
   WHEN row_locked THEN
      Error_SYS.Fnd_Record_Locked(lu_name_);
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(NULL, NULL, 'Lock_By_Id___');
   WHEN no_data_found THEN
      BEGIN
         SELECT *
            INTO  rec_
            FROM  inventory_part_tab
            WHERE rowid = objid_;
         Raise_Record_Modified___(rec_);
      EXCEPTION
         WHEN no_data_found THEN
            Error_SYS.Fnd_Record_Removed(lu_name_);
         WHEN too_many_rows THEN
            Raise_Too_Many_Rows___(NULL, NULL, 'Lock_By_Id___');
      END;
END Lock_By_Id___;


-- Lock_By_Keys___
--    Locks a database row based on the primary key values.
--    Waits until record released if locked by another session.
FUNCTION Lock_By_Keys___ (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2) RETURN inventory_part_tab%ROWTYPE
IS
   rec_        inventory_part_tab%ROWTYPE;
BEGIN
   BEGIN
      SELECT *
         INTO  rec_
         FROM  inventory_part_tab
         WHERE contract = contract_
         AND   part_no = part_no_
         FOR UPDATE;
      RETURN rec_;
   EXCEPTION
      WHEN no_data_found THEN
         Raise_Record_Removed___(contract_, part_no_);
      WHEN too_many_rows THEN
         Raise_Too_Many_Rows___(contract_, part_no_, 'Lock_By_Keys___');
   END;
END Lock_By_Keys___;


-- Lock_By_Keys_Nowait___
--    Locks a database row based on the primary key values.
--    Raises exception if row already locked.
FUNCTION Lock_By_Keys_Nowait___ (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2) RETURN inventory_part_tab%ROWTYPE
IS
   row_locked  EXCEPTION;
   PRAGMA      EXCEPTION_INIT(row_locked, -0054);
   rec_        inventory_part_tab%ROWTYPE;
BEGIN
   BEGIN
      SELECT *
         INTO  rec_
         FROM  inventory_part_tab
         WHERE contract = contract_
         AND   part_no = part_no_
         FOR UPDATE NOWAIT;
      RETURN rec_;
   EXCEPTION
      WHEN row_locked THEN
         Raise_Record_Locked___(contract_, part_no_);
      WHEN too_many_rows THEN
         Raise_Too_Many_Rows___(contract_, part_no_, 'Lock_By_Keys___');
      WHEN no_data_found THEN
         Raise_Record_Removed___(contract_, part_no_);
   END;
END Lock_By_Keys_Nowait___;


-- Get_Object_By_Id___
--    Fetched a database row based on given the objid.
FUNCTION Get_Object_By_Id___ (
   objid_ IN VARCHAR2 ) RETURN inventory_part_tab%ROWTYPE
IS
   lu_rec_ inventory_part_tab%ROWTYPE;
BEGIN
   SELECT *
      INTO  lu_rec_
      FROM  inventory_part_tab
      WHERE rowid = objid_;
   RETURN lu_rec_;
EXCEPTION
   WHEN no_data_found THEN
      Error_SYS.Fnd_Record_Removed(lu_name_);
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(NULL, NULL, 'Get_Object_By_Id___');
END Get_Object_By_Id___;


-- Get_Object_By_Keys___
--    Fetched a database row based on given the primary key values.
@UncheckedAccess
FUNCTION Get_Object_By_Keys___ (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN inventory_part_tab%ROWTYPE
IS
   lu_rec_ inventory_part_tab%ROWTYPE;
BEGIN
   SELECT *
      INTO  lu_rec_
      FROM  inventory_part_tab
      WHERE contract = contract_
      AND   part_no = part_no_;
   RETURN lu_rec_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN lu_rec_;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(contract_, part_no_, 'Get_Object_By_Keys___');
END Get_Object_By_Keys___;


-- Check_Exist___
--    Checks if a database row is already stored based on the primary key values.
@UncheckedAccess
FUNCTION Check_Exist___ (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN FALSE;
   END IF;
   SELECT 1
      INTO  dummy_
      FROM  inventory_part_tab
      WHERE contract = contract_
      AND   part_no = part_no_;
   RETURN TRUE;
EXCEPTION
   WHEN no_data_found THEN
      RETURN FALSE;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(contract_, part_no_, 'Check_Exist___');
END Check_Exist___;





-- Get_Version_By_Id___
--    Fetched the objversion for a database row based on the objid.
PROCEDURE Get_Version_By_Id___ (
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2 )
IS
BEGIN
   SELECT to_char(rowversion,'YYYYMMDDHH24MISS')
      INTO  objversion_
      FROM  inventory_part_tab
      WHERE rowid = objid_;
EXCEPTION
   WHEN no_data_found THEN
      objversion_ := NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(NULL, NULL, 'Get_Version_By_Id___');
END Get_Version_By_Id___;


-- Get_Version_By_Keys___
--    Fetched the objversion for a database row based on the primary key.
PROCEDURE Get_Id_Version_By_Keys___ (
   objid_      IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 )
IS
BEGIN
   SELECT rowid, to_char(rowversion,'YYYYMMDDHH24MISS')
      INTO  objid_, objversion_
      FROM  inventory_part_tab
      WHERE contract = contract_
      AND   part_no = part_no_;
EXCEPTION
   WHEN no_data_found THEN
      objid_      := NULL;
      objversion_ := NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(contract_, part_no_, 'Get_Id_Version_By_Keys___');
END Get_Id_Version_By_Keys___;


-- Unpack___
--   Reads an attribute string and unpacks its contents into a record.
PROCEDURE Unpack___ (
   newrec_   IN OUT inventory_part_tab%ROWTYPE,
   indrec_   IN OUT Indicator_Rec,
   attr_     IN OUT VARCHAR2 )
IS
   ptr_   NUMBER;
   name_  VARCHAR2(30);
   value_ VARCHAR2(32000);
   msg_   VARCHAR2(32000);
BEGIN
   Reset_Indicator_Rec___(indrec_);
   Client_SYS.Clear_Attr(msg_);
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      CASE name_
      WHEN ('CONTRACT') THEN
         newrec_.contract := value_;
         indrec_.contract := TRUE;
      WHEN ('PART_NO') THEN
         newrec_.part_no := value_;
         indrec_.part_no := TRUE;
      WHEN ('ACCOUNTING_GROUP') THEN
         newrec_.accounting_group := value_;
         indrec_.accounting_group := TRUE;
      WHEN ('ASSET_CLASS') THEN
         newrec_.asset_class := value_;
         indrec_.asset_class := TRUE;
      WHEN ('COUNTRY_OF_ORIGIN') THEN
         newrec_.country_of_origin := value_;
         indrec_.country_of_origin := TRUE;
      WHEN ('HAZARD_CODE') THEN
         newrec_.hazard_code := value_;
         indrec_.hazard_code := TRUE;
      WHEN ('NOTE_ID') THEN
         newrec_.note_id := Client_SYS.Attr_Value_To_Number(value_);
         indrec_.note_id := TRUE;
      WHEN ('PART_PRODUCT_CODE') THEN
         newrec_.part_product_code := value_;
         indrec_.part_product_code := TRUE;
      WHEN ('PART_PRODUCT_FAMILY') THEN
         newrec_.part_product_family := value_;
         indrec_.part_product_family := TRUE;
      WHEN ('PART_STATUS') THEN
         newrec_.part_status := value_;
         indrec_.part_status := TRUE;
      WHEN ('PLANNER_BUYER') THEN
         newrec_.planner_buyer := value_;
         indrec_.planner_buyer := TRUE;
      WHEN ('PRIME_COMMODITY') THEN
         newrec_.prime_commodity := value_;
         indrec_.prime_commodity := TRUE;
      WHEN ('SECOND_COMMODITY') THEN
         newrec_.second_commodity := value_;
         indrec_.second_commodity := TRUE;
      WHEN ('UNIT_MEAS') THEN
         newrec_.unit_meas := value_;
         indrec_.unit_meas := TRUE;
      WHEN ('CATCH_UNIT_MEAS') THEN
         newrec_.catch_unit_meas := value_;
         indrec_.catch_unit_meas := TRUE;
      WHEN ('DESCRIPTION') THEN
         newrec_.description := value_;
         indrec_.description := TRUE;
      WHEN ('ABC_CLASS') THEN
         newrec_.abc_class := value_;
         indrec_.abc_class := TRUE;
      WHEN ('ABC_CLASS_LOCKED_UNTIL') THEN
         newrec_.abc_class_locked_until := Client_SYS.Attr_Value_To_Date(value_);
         indrec_.abc_class_locked_until := TRUE;
      WHEN ('COUNT_VARIANCE') THEN
         newrec_.count_variance := Client_SYS.Attr_Value_To_Number(value_);
         indrec_.count_variance := TRUE;
      WHEN ('CREATE_DATE') THEN
         newrec_.create_date := Client_SYS.Attr_Value_To_Date(value_);
         indrec_.create_date := TRUE;
      WHEN ('CYCLE_CODE') THEN
         newrec_.cycle_code := Inventory_Part_Count_Type_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.cycle_code IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.cycle_code := TRUE;
      WHEN ('CYCLE_CODE_DB') THEN
         newrec_.cycle_code := value_;
         indrec_.cycle_code := TRUE;
      WHEN ('CYCLE_PERIOD') THEN
         newrec_.cycle_period := Client_SYS.Attr_Value_To_Number(value_);
         indrec_.cycle_period := TRUE;
      WHEN ('DIM_QUALITY') THEN
         newrec_.dim_quality := value_;
         indrec_.dim_quality := TRUE;
      WHEN ('DURABILITY_DAY') THEN
         newrec_.durability_day := Client_SYS.Attr_Value_To_Number(value_);
         indrec_.durability_day := TRUE;
      WHEN ('EXPECTED_LEADTIME') THEN
         newrec_.expected_leadtime := Client_SYS.Attr_Value_To_Number(value_);
         indrec_.expected_leadtime := TRUE;
      WHEN ('LAST_ACTIVITY_DATE') THEN
         newrec_.last_activity_date := Client_SYS.Attr_Value_To_Date(value_);
         indrec_.last_activity_date := TRUE;
      WHEN ('LEAD_TIME_CODE') THEN
         newrec_.lead_time_code := Inv_Part_Lead_Time_Code_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.lead_time_code IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.lead_time_code := TRUE;
      WHEN ('LEAD_TIME_CODE_DB') THEN
         newrec_.lead_time_code := value_;
         indrec_.lead_time_code := TRUE;
      WHEN ('MANUF_LEADTIME') THEN
         newrec_.manuf_leadtime := Client_SYS.Attr_Value_To_Number(value_);
         indrec_.manuf_leadtime := TRUE;
      WHEN ('NOTE_TEXT') THEN
         newrec_.note_text := value_;
         indrec_.note_text := TRUE;
      WHEN ('OE_ALLOC_ASSIGN_FLAG') THEN
         newrec_.oe_alloc_assign_flag := Cust_Ord_Reservation_Type_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.oe_alloc_assign_flag IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.oe_alloc_assign_flag := TRUE;
      WHEN ('OE_ALLOC_ASSIGN_FLAG_DB') THEN
         newrec_.oe_alloc_assign_flag := value_;
         indrec_.oe_alloc_assign_flag := TRUE;
      WHEN ('ONHAND_ANALYSIS_FLAG') THEN
         newrec_.onhand_analysis_flag := Inventory_Part_Onh_Analys_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.onhand_analysis_flag IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.onhand_analysis_flag := TRUE;
      WHEN ('ONHAND_ANALYSIS_FLAG_DB') THEN
         newrec_.onhand_analysis_flag := value_;
         indrec_.onhand_analysis_flag := TRUE;
      WHEN ('PURCH_LEADTIME') THEN
         newrec_.purch_leadtime := Client_SYS.Attr_Value_To_Number(value_);
         indrec_.purch_leadtime := TRUE;
      WHEN ('EARLIEST_ULTD_SUPPLY_DATE') THEN
         newrec_.earliest_ultd_supply_date := Client_SYS.Attr_Value_To_Date(value_);
         indrec_.earliest_ultd_supply_date := TRUE;
      WHEN ('SUPERSEDES') THEN
         newrec_.supersedes := value_;
         indrec_.supersedes := TRUE;
      WHEN ('SUPPLY_CODE') THEN
         newrec_.supply_code := Material_Requis_Supply_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.supply_code IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.supply_code := TRUE;
      WHEN ('SUPPLY_CODE_DB') THEN
         newrec_.supply_code := value_;
         indrec_.supply_code := TRUE;
      WHEN ('TYPE_CODE') THEN
         newrec_.type_code := Inventory_Part_Type_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.type_code IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.type_code := TRUE;
      WHEN ('TYPE_CODE_DB') THEN
         newrec_.type_code := value_;
         indrec_.type_code := TRUE;
      WHEN ('CUSTOMS_STAT_NO') THEN
         newrec_.customs_stat_no := value_;
         indrec_.customs_stat_no := TRUE;
      WHEN ('TYPE_DESIGNATION') THEN
         newrec_.type_designation := value_;
         indrec_.type_designation := TRUE;
      WHEN ('ZERO_COST_FLAG') THEN
         newrec_.zero_cost_flag := Inventory_Part_Zero_Cost_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.zero_cost_flag IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.zero_cost_flag := TRUE;
      WHEN ('ZERO_COST_FLAG_DB') THEN
         newrec_.zero_cost_flag := value_;
         indrec_.zero_cost_flag := TRUE;
      WHEN ('AVAIL_ACTIVITY_STATUS') THEN
         newrec_.avail_activity_status := Inventory_Part_Avail_Stat_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.avail_activity_status IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.avail_activity_status := TRUE;
      WHEN ('AVAIL_ACTIVITY_STATUS_DB') THEN
         newrec_.avail_activity_status := value_;
         indrec_.avail_activity_status := TRUE;
      WHEN ('ENG_ATTRIBUTE') THEN
         newrec_.eng_attribute := value_;
         indrec_.eng_attribute := TRUE;
      WHEN ('SHORTAGE_FLAG') THEN
         newrec_.shortage_flag := Inventory_Part_Shortage_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.shortage_flag IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.shortage_flag := TRUE;
      WHEN ('SHORTAGE_FLAG_DB') THEN
         newrec_.shortage_flag := value_;
         indrec_.shortage_flag := TRUE;
      WHEN ('FORECAST_CONSUMPTION_FLAG') THEN
         newrec_.forecast_consumption_flag := Inv_Part_Forecast_Consum_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.forecast_consumption_flag IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.forecast_consumption_flag := TRUE;
      WHEN ('FORECAST_CONSUMPTION_FLAG_DB') THEN
         newrec_.forecast_consumption_flag := value_;
         indrec_.forecast_consumption_flag := TRUE;
      WHEN ('STOCK_MANAGEMENT') THEN
         newrec_.stock_management := Inventory_Part_Management_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.stock_management IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.stock_management := TRUE;
      WHEN ('STOCK_MANAGEMENT_DB') THEN
         newrec_.stock_management := value_;
         indrec_.stock_management := TRUE;
      WHEN ('INTRASTAT_CONV_FACTOR') THEN
         newrec_.intrastat_conv_factor := Client_SYS.Attr_Value_To_Number(value_);
         indrec_.intrastat_conv_factor := TRUE;
      WHEN ('PART_COST_GROUP_ID') THEN
         newrec_.part_cost_group_id := value_;
         indrec_.part_cost_group_id := TRUE;
      WHEN ('DOP_CONNECTION') THEN
         newrec_.dop_connection := Dop_Connection_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.dop_connection IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.dop_connection := TRUE;
      WHEN ('DOP_CONNECTION_DB') THEN
         newrec_.dop_connection := value_;
         indrec_.dop_connection := TRUE;
      WHEN ('STD_NAME_ID') THEN
         newrec_.std_name_id := Client_SYS.Attr_Value_To_Number(value_);
         indrec_.std_name_id := TRUE;
      WHEN ('INVENTORY_VALUATION_METHOD') THEN
         newrec_.inventory_valuation_method := Inventory_Value_Method_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.inventory_valuation_method IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.inventory_valuation_method := TRUE;
      WHEN ('INVENTORY_VALUATION_METHOD_DB') THEN
         newrec_.inventory_valuation_method := value_;
         indrec_.inventory_valuation_method := TRUE;
      WHEN ('NEGATIVE_ON_HAND') THEN
         newrec_.negative_on_hand := Negative_On_Hand_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.negative_on_hand IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.negative_on_hand := TRUE;
      WHEN ('NEGATIVE_ON_HAND_DB') THEN
         newrec_.negative_on_hand := value_;
         indrec_.negative_on_hand := TRUE;
      WHEN ('TECHNICAL_COORDINATOR_ID') THEN
         newrec_.technical_coordinator_id := value_;
         indrec_.technical_coordinator_id := TRUE;
      WHEN ('INVOICE_CONSIDERATION') THEN
         newrec_.invoice_consideration := Invoice_Consideration_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.invoice_consideration IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.invoice_consideration := TRUE;
      WHEN ('INVOICE_CONSIDERATION_DB') THEN
         newrec_.invoice_consideration := value_;
         indrec_.invoice_consideration := TRUE;
      WHEN ('ACTUAL_COST_ACTIVATED') THEN
         newrec_.actual_cost_activated := Client_SYS.Attr_Value_To_Date(value_);
         indrec_.actual_cost_activated := TRUE;
      WHEN ('MAX_ACTUAL_COST_UPDATE') THEN
         newrec_.max_actual_cost_update := Client_SYS.Attr_Value_To_Number(value_);
         indrec_.max_actual_cost_update := TRUE;
      WHEN ('CUST_WARRANTY_ID') THEN
         newrec_.cust_warranty_id := Client_SYS.Attr_Value_To_Number(value_);
         indrec_.cust_warranty_id := TRUE;
      WHEN ('SUP_WARRANTY_ID') THEN
         newrec_.sup_warranty_id := Client_SYS.Attr_Value_To_Number(value_);
         indrec_.sup_warranty_id := TRUE;
      WHEN ('REGION_OF_ORIGIN') THEN
         newrec_.region_of_origin := value_;
         indrec_.region_of_origin := TRUE;
      WHEN ('INVENTORY_PART_COST_LEVEL') THEN
         newrec_.inventory_part_cost_level := Inventory_Part_Cost_Level_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.inventory_part_cost_level IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.inventory_part_cost_level := TRUE;
      WHEN ('INVENTORY_PART_COST_LEVEL_DB') THEN
         newrec_.inventory_part_cost_level := value_;
         indrec_.inventory_part_cost_level := TRUE;
      WHEN ('EXT_SERVICE_COST_METHOD') THEN
         newrec_.ext_service_cost_method := Ext_Service_Cost_Method_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.ext_service_cost_method IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.ext_service_cost_method := TRUE;
      WHEN ('EXT_SERVICE_COST_METHOD_DB') THEN
         newrec_.ext_service_cost_method := value_;
         indrec_.ext_service_cost_method := TRUE;
      WHEN ('SUPPLY_CHAIN_PART_GROUP') THEN
         newrec_.supply_chain_part_group := value_;
         indrec_.supply_chain_part_group := TRUE;
      WHEN ('AUTOMATIC_CAPABILITY_CHECK') THEN
         newrec_.automatic_capability_check := Capability_Check_Allocate_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.automatic_capability_check IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.automatic_capability_check := TRUE;
      WHEN ('AUTOMATIC_CAPABILITY_CHECK_DB') THEN
         newrec_.automatic_capability_check := value_;
         indrec_.automatic_capability_check := TRUE;
      WHEN ('INPUT_UNIT_MEAS_GROUP_ID') THEN
         newrec_.input_unit_meas_group_id := value_;
         indrec_.input_unit_meas_group_id := TRUE;
      WHEN ('DOP_NETTING') THEN
         newrec_.dop_netting := Dop_Netting_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.dop_netting IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.dop_netting := TRUE;
      WHEN ('DOP_NETTING_DB') THEN
         newrec_.dop_netting := value_;
         indrec_.dop_netting := TRUE;
      WHEN ('CO_RESERVE_ONH_ANALYS_FLAG') THEN
         newrec_.co_reserve_onh_analys_flag := Inventory_Part_Onh_Analys_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.co_reserve_onh_analys_flag IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.co_reserve_onh_analys_flag := TRUE;
      WHEN ('CO_RESERVE_ONH_ANALYS_FLAG_DB') THEN
         newrec_.co_reserve_onh_analys_flag := value_;
         indrec_.co_reserve_onh_analys_flag := TRUE;
      WHEN ('QTY_CALC_ROUNDING') THEN
         newrec_.qty_calc_rounding := Client_SYS.Attr_Value_To_Number(value_);
         indrec_.qty_calc_rounding := TRUE;
      WHEN ('LIFECYCLE_STAGE') THEN
         newrec_.lifecycle_stage := Inv_Part_Lifecycle_Stage_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.lifecycle_stage IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.lifecycle_stage := TRUE;
      WHEN ('LIFECYCLE_STAGE_DB') THEN
         newrec_.lifecycle_stage := value_;
         indrec_.lifecycle_stage := TRUE;
      WHEN ('LIFE_STAGE_LOCKED_UNTIL') THEN
         newrec_.life_stage_locked_until := Client_SYS.Attr_Value_To_Date(value_);
         indrec_.life_stage_locked_until := TRUE;
      WHEN ('FREQUENCY_CLASS') THEN
         newrec_.frequency_class := Inv_Part_Frequency_Class_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.frequency_class IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.frequency_class := TRUE;
      WHEN ('FREQUENCY_CLASS_DB') THEN
         newrec_.frequency_class := value_;
         indrec_.frequency_class := TRUE;
      WHEN ('FREQ_CLASS_LOCKED_UNTIL') THEN
         newrec_.freq_class_locked_until := Client_SYS.Attr_Value_To_Date(value_);
         indrec_.freq_class_locked_until := TRUE;
      WHEN ('FIRST_STAT_ISSUE_DATE') THEN
         newrec_.first_stat_issue_date := Client_SYS.Attr_Value_To_Date(value_);
         indrec_.first_stat_issue_date := TRUE;
      WHEN ('LATEST_STAT_ISSUE_DATE') THEN
         newrec_.latest_stat_issue_date := Client_SYS.Attr_Value_To_Date(value_);
         indrec_.latest_stat_issue_date := TRUE;
      WHEN ('DECLINE_DATE') THEN
         newrec_.decline_date := Client_SYS.Attr_Value_To_Date(value_);
         indrec_.decline_date := TRUE;
      WHEN ('EXPIRED_DATE') THEN
         newrec_.expired_date := Client_SYS.Attr_Value_To_Date(value_);
         indrec_.expired_date := TRUE;
      WHEN ('DECLINE_ISSUE_COUNTER') THEN
         newrec_.decline_issue_counter := Client_SYS.Attr_Value_To_Number(value_);
         indrec_.decline_issue_counter := TRUE;
      WHEN ('EXPIRED_ISSUE_COUNTER') THEN
         newrec_.expired_issue_counter := Client_SYS.Attr_Value_To_Number(value_);
         indrec_.expired_issue_counter := TRUE;
      WHEN ('MIN_DURAB_DAYS_CO_DELIV') THEN
         newrec_.min_durab_days_co_deliv := Client_SYS.Attr_Value_To_Number(value_);
         indrec_.min_durab_days_co_deliv := TRUE;
      WHEN ('MIN_DURAB_DAYS_PLANNING') THEN
         newrec_.min_durab_days_planning := Client_SYS.Attr_Value_To_Number(value_);
         indrec_.min_durab_days_planning := TRUE;
      WHEN ('STORAGE_WIDTH_REQUIREMENT') THEN
         newrec_.storage_width_requirement := Client_SYS.Attr_Value_To_Number(value_);
         indrec_.storage_width_requirement := TRUE;
      WHEN ('STORAGE_HEIGHT_REQUIREMENT') THEN
         newrec_.storage_height_requirement := Client_SYS.Attr_Value_To_Number(value_);
         indrec_.storage_height_requirement := TRUE;
      WHEN ('STORAGE_DEPTH_REQUIREMENT') THEN
         newrec_.storage_depth_requirement := Client_SYS.Attr_Value_To_Number(value_);
         indrec_.storage_depth_requirement := TRUE;
      WHEN ('STORAGE_VOLUME_REQUIREMENT') THEN
         newrec_.storage_volume_requirement := Client_SYS.Attr_Value_To_Number(value_);
         indrec_.storage_volume_requirement := TRUE;
      WHEN ('STORAGE_WEIGHT_REQUIREMENT') THEN
         newrec_.storage_weight_requirement := Client_SYS.Attr_Value_To_Number(value_);
         indrec_.storage_weight_requirement := TRUE;
      WHEN ('MIN_STORAGE_TEMPERATURE') THEN
         newrec_.min_storage_temperature := Client_SYS.Attr_Value_To_Number(value_);
         indrec_.min_storage_temperature := TRUE;
      WHEN ('MAX_STORAGE_TEMPERATURE') THEN
         newrec_.max_storage_temperature := Client_SYS.Attr_Value_To_Number(value_);
         indrec_.max_storage_temperature := TRUE;
      WHEN ('MIN_STORAGE_HUMIDITY') THEN
         newrec_.min_storage_humidity := Client_SYS.Attr_Value_To_Number(value_);
         indrec_.min_storage_humidity := TRUE;
      WHEN ('MAX_STORAGE_HUMIDITY') THEN
         newrec_.max_storage_humidity := Client_SYS.Attr_Value_To_Number(value_);
         indrec_.max_storage_humidity := TRUE;
      WHEN ('STANDARD_PUTAWAY_QTY') THEN
         newrec_.standard_putaway_qty := Client_SYS.Attr_Value_To_Number(value_);
         indrec_.standard_putaway_qty := TRUE;
      WHEN ('PUTAWAY_ZONE_REFILL_OPTION') THEN
         newrec_.putaway_zone_refill_option := Putaway_Zone_Refill_Option_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.putaway_zone_refill_option IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.putaway_zone_refill_option := TRUE;
      WHEN ('PUTAWAY_ZONE_REFILL_OPTION_DB') THEN
         newrec_.putaway_zone_refill_option := value_;
         indrec_.putaway_zone_refill_option := TRUE;
      WHEN ('RESET_CONFIG_STD_COST') THEN
         newrec_.reset_config_std_cost := Fnd_Boolean_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.reset_config_std_cost IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.reset_config_std_cost := TRUE;
      WHEN ('RESET_CONFIG_STD_COST_DB') THEN
         newrec_.reset_config_std_cost := value_;
         indrec_.reset_config_std_cost := TRUE;
      WHEN ('MANDATORY_EXPIRATION_DATE') THEN
         newrec_.mandatory_expiration_date := Fnd_Boolean_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.mandatory_expiration_date IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.mandatory_expiration_date := TRUE;
      WHEN ('MANDATORY_EXPIRATION_DATE_DB') THEN
         newrec_.mandatory_expiration_date := value_;
         indrec_.mandatory_expiration_date := TRUE;
      WHEN ('EXCL_SHIP_PACK_PROPOSAL') THEN
         newrec_.excl_ship_pack_proposal := Fnd_Boolean_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.excl_ship_pack_proposal IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.excl_ship_pack_proposal := TRUE;
      WHEN ('EXCL_SHIP_PACK_PROPOSAL_DB') THEN
         newrec_.excl_ship_pack_proposal := value_;
         indrec_.excl_ship_pack_proposal := TRUE;
      WHEN ('STATISTICAL_CODE') THEN
         newrec_.statistical_code := value_;
         indrec_.statistical_code := TRUE;
      WHEN ('ACQUISITION_ORIGIN') THEN
         newrec_.acquisition_origin := Client_SYS.Attr_Value_To_Number(value_);
         indrec_.acquisition_origin := TRUE;
      WHEN ('ACQUISITION_REASON_ID') THEN
         newrec_.acquisition_reason_id := value_;
         indrec_.acquisition_reason_id := TRUE;
      ELSE
         Client_SYS.Add_To_Attr(name_, value_, msg_);
      END CASE;
   END LOOP;
   attr_ := msg_;
EXCEPTION
   WHEN value_error THEN
      Raise_Item_Format___(name_, value_);
END Unpack___;


-- Pack___
--   Reads a record and packs its contents into an attribute string.
--   This is intended to be the reverse of Unpack___
FUNCTION Pack___ (
   rec_ IN inventory_part_tab%ROWTYPE ) RETURN VARCHAR2
IS
   attr_ VARCHAR2(32000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   IF (rec_.contract IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('CONTRACT', rec_.contract, attr_);
   END IF;
   IF (rec_.part_no IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('PART_NO', rec_.part_no, attr_);
   END IF;
   IF (rec_.accounting_group IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('ACCOUNTING_GROUP', rec_.accounting_group, attr_);
   END IF;
   IF (rec_.asset_class IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('ASSET_CLASS', rec_.asset_class, attr_);
   END IF;
   IF (rec_.country_of_origin IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('COUNTRY_OF_ORIGIN', rec_.country_of_origin, attr_);
   END IF;
   IF (rec_.hazard_code IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('HAZARD_CODE', rec_.hazard_code, attr_);
   END IF;
   IF (rec_.note_id IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('NOTE_ID', rec_.note_id, attr_);
   END IF;
   IF (rec_.part_product_code IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('PART_PRODUCT_CODE', rec_.part_product_code, attr_);
   END IF;
   IF (rec_.part_product_family IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('PART_PRODUCT_FAMILY', rec_.part_product_family, attr_);
   END IF;
   IF (rec_.part_status IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('PART_STATUS', rec_.part_status, attr_);
   END IF;
   IF (rec_.planner_buyer IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('PLANNER_BUYER', rec_.planner_buyer, attr_);
   END IF;
   IF (rec_.prime_commodity IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('PRIME_COMMODITY', rec_.prime_commodity, attr_);
   END IF;
   IF (rec_.second_commodity IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('SECOND_COMMODITY', rec_.second_commodity, attr_);
   END IF;
   IF (rec_.unit_meas IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('UNIT_MEAS', rec_.unit_meas, attr_);
   END IF;
   IF (rec_.catch_unit_meas IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('CATCH_UNIT_MEAS', rec_.catch_unit_meas, attr_);
   END IF;
   IF (rec_.description IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('DESCRIPTION', rec_.description, attr_);
   END IF;
   IF (rec_.abc_class IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('ABC_CLASS', rec_.abc_class, attr_);
   END IF;
   IF (rec_.abc_class_locked_until IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('ABC_CLASS_LOCKED_UNTIL', rec_.abc_class_locked_until, attr_);
   END IF;
   IF (rec_.count_variance IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('COUNT_VARIANCE', rec_.count_variance, attr_);
   END IF;
   IF (rec_.create_date IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('CREATE_DATE', rec_.create_date, attr_);
   END IF;
   IF (rec_.cycle_code IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('CYCLE_CODE', Inventory_Part_Count_Type_API.Decode(rec_.cycle_code), attr_);
      Client_SYS.Add_To_Attr('CYCLE_CODE_DB', rec_.cycle_code, attr_);
   END IF;
   IF (rec_.cycle_period IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('CYCLE_PERIOD', rec_.cycle_period, attr_);
   END IF;
   IF (rec_.dim_quality IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('DIM_QUALITY', rec_.dim_quality, attr_);
   END IF;
   IF (rec_.durability_day IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('DURABILITY_DAY', rec_.durability_day, attr_);
   END IF;
   IF (rec_.expected_leadtime IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('EXPECTED_LEADTIME', rec_.expected_leadtime, attr_);
   END IF;
   IF (rec_.last_activity_date IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('LAST_ACTIVITY_DATE', rec_.last_activity_date, attr_);
   END IF;
   IF (rec_.lead_time_code IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('LEAD_TIME_CODE', Inv_Part_Lead_Time_Code_API.Decode(rec_.lead_time_code), attr_);
      Client_SYS.Add_To_Attr('LEAD_TIME_CODE_DB', rec_.lead_time_code, attr_);
   END IF;
   IF (rec_.manuf_leadtime IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('MANUF_LEADTIME', rec_.manuf_leadtime, attr_);
   END IF;
   IF (rec_.note_text IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('NOTE_TEXT', rec_.note_text, attr_);
   END IF;
   IF (rec_.oe_alloc_assign_flag IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('OE_ALLOC_ASSIGN_FLAG', Cust_Ord_Reservation_Type_API.Decode(rec_.oe_alloc_assign_flag), attr_);
      Client_SYS.Add_To_Attr('OE_ALLOC_ASSIGN_FLAG_DB', rec_.oe_alloc_assign_flag, attr_);
   END IF;
   IF (rec_.onhand_analysis_flag IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('ONHAND_ANALYSIS_FLAG', Inventory_Part_Onh_Analys_API.Decode(rec_.onhand_analysis_flag), attr_);
      Client_SYS.Add_To_Attr('ONHAND_ANALYSIS_FLAG_DB', rec_.onhand_analysis_flag, attr_);
   END IF;
   IF (rec_.purch_leadtime IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('PURCH_LEADTIME', rec_.purch_leadtime, attr_);
   END IF;
   IF (rec_.earliest_ultd_supply_date IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('EARLIEST_ULTD_SUPPLY_DATE', rec_.earliest_ultd_supply_date, attr_);
   END IF;
   IF (rec_.supersedes IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('SUPERSEDES', rec_.supersedes, attr_);
   END IF;
   IF (rec_.supply_code IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('SUPPLY_CODE', Material_Requis_Supply_API.Decode(rec_.supply_code), attr_);
      Client_SYS.Add_To_Attr('SUPPLY_CODE_DB', rec_.supply_code, attr_);
   END IF;
   IF (rec_.type_code IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('TYPE_CODE', Inventory_Part_Type_API.Decode(rec_.type_code), attr_);
      Client_SYS.Add_To_Attr('TYPE_CODE_DB', rec_.type_code, attr_);
   END IF;
   IF (rec_.customs_stat_no IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('CUSTOMS_STAT_NO', rec_.customs_stat_no, attr_);
   END IF;
   IF (rec_.type_designation IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('TYPE_DESIGNATION', rec_.type_designation, attr_);
   END IF;
   IF (rec_.zero_cost_flag IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('ZERO_COST_FLAG', Inventory_Part_Zero_Cost_API.Decode(rec_.zero_cost_flag), attr_);
      Client_SYS.Add_To_Attr('ZERO_COST_FLAG_DB', rec_.zero_cost_flag, attr_);
   END IF;
   IF (rec_.avail_activity_status IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('AVAIL_ACTIVITY_STATUS', Inventory_Part_Avail_Stat_API.Decode(rec_.avail_activity_status), attr_);
      Client_SYS.Add_To_Attr('AVAIL_ACTIVITY_STATUS_DB', rec_.avail_activity_status, attr_);
   END IF;
   IF (rec_.eng_attribute IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('ENG_ATTRIBUTE', rec_.eng_attribute, attr_);
   END IF;
   IF (rec_.shortage_flag IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('SHORTAGE_FLAG', Inventory_Part_Shortage_API.Decode(rec_.shortage_flag), attr_);
      Client_SYS.Add_To_Attr('SHORTAGE_FLAG_DB', rec_.shortage_flag, attr_);
   END IF;
   IF (rec_.forecast_consumption_flag IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('FORECAST_CONSUMPTION_FLAG', Inv_Part_Forecast_Consum_API.Decode(rec_.forecast_consumption_flag), attr_);
      Client_SYS.Add_To_Attr('FORECAST_CONSUMPTION_FLAG_DB', rec_.forecast_consumption_flag, attr_);
   END IF;
   IF (rec_.stock_management IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('STOCK_MANAGEMENT', Inventory_Part_Management_API.Decode(rec_.stock_management), attr_);
      Client_SYS.Add_To_Attr('STOCK_MANAGEMENT_DB', rec_.stock_management, attr_);
   END IF;
   IF (rec_.intrastat_conv_factor IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('INTRASTAT_CONV_FACTOR', rec_.intrastat_conv_factor, attr_);
   END IF;
   IF (rec_.part_cost_group_id IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('PART_COST_GROUP_ID', rec_.part_cost_group_id, attr_);
   END IF;
   IF (rec_.dop_connection IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('DOP_CONNECTION', Dop_Connection_API.Decode(rec_.dop_connection), attr_);
      Client_SYS.Add_To_Attr('DOP_CONNECTION_DB', rec_.dop_connection, attr_);
   END IF;
   IF (rec_.std_name_id IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('STD_NAME_ID', rec_.std_name_id, attr_);
   END IF;
   IF (rec_.inventory_valuation_method IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('INVENTORY_VALUATION_METHOD', Inventory_Value_Method_API.Decode(rec_.inventory_valuation_method), attr_);
      Client_SYS.Add_To_Attr('INVENTORY_VALUATION_METHOD_DB', rec_.inventory_valuation_method, attr_);
   END IF;
   IF (rec_.negative_on_hand IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('NEGATIVE_ON_HAND', Negative_On_Hand_API.Decode(rec_.negative_on_hand), attr_);
      Client_SYS.Add_To_Attr('NEGATIVE_ON_HAND_DB', rec_.negative_on_hand, attr_);
   END IF;
   IF (rec_.technical_coordinator_id IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('TECHNICAL_COORDINATOR_ID', rec_.technical_coordinator_id, attr_);
   END IF;
   IF (rec_.invoice_consideration IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('INVOICE_CONSIDERATION', Invoice_Consideration_API.Decode(rec_.invoice_consideration), attr_);
      Client_SYS.Add_To_Attr('INVOICE_CONSIDERATION_DB', rec_.invoice_consideration, attr_);
   END IF;
   IF (rec_.actual_cost_activated IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('ACTUAL_COST_ACTIVATED', rec_.actual_cost_activated, attr_);
   END IF;
   IF (rec_.max_actual_cost_update IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('MAX_ACTUAL_COST_UPDATE', rec_.max_actual_cost_update, attr_);
   END IF;
   IF (rec_.cust_warranty_id IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('CUST_WARRANTY_ID', rec_.cust_warranty_id, attr_);
   END IF;
   IF (rec_.sup_warranty_id IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('SUP_WARRANTY_ID', rec_.sup_warranty_id, attr_);
   END IF;
   IF (rec_.region_of_origin IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('REGION_OF_ORIGIN', rec_.region_of_origin, attr_);
   END IF;
   IF (rec_.inventory_part_cost_level IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('INVENTORY_PART_COST_LEVEL', Inventory_Part_Cost_Level_API.Decode(rec_.inventory_part_cost_level), attr_);
      Client_SYS.Add_To_Attr('INVENTORY_PART_COST_LEVEL_DB', rec_.inventory_part_cost_level, attr_);
   END IF;
   IF (rec_.ext_service_cost_method IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('EXT_SERVICE_COST_METHOD', Ext_Service_Cost_Method_API.Decode(rec_.ext_service_cost_method), attr_);
      Client_SYS.Add_To_Attr('EXT_SERVICE_COST_METHOD_DB', rec_.ext_service_cost_method, attr_);
   END IF;
   IF (rec_.supply_chain_part_group IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('SUPPLY_CHAIN_PART_GROUP', rec_.supply_chain_part_group, attr_);
   END IF;
   IF (rec_.automatic_capability_check IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('AUTOMATIC_CAPABILITY_CHECK', Capability_Check_Allocate_API.Decode(rec_.automatic_capability_check), attr_);
      Client_SYS.Add_To_Attr('AUTOMATIC_CAPABILITY_CHECK_DB', rec_.automatic_capability_check, attr_);
   END IF;
   IF (rec_.input_unit_meas_group_id IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('INPUT_UNIT_MEAS_GROUP_ID', rec_.input_unit_meas_group_id, attr_);
   END IF;
   IF (rec_.dop_netting IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('DOP_NETTING', Dop_Netting_API.Decode(rec_.dop_netting), attr_);
      Client_SYS.Add_To_Attr('DOP_NETTING_DB', rec_.dop_netting, attr_);
   END IF;
   IF (rec_.co_reserve_onh_analys_flag IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('CO_RESERVE_ONH_ANALYS_FLAG', Inventory_Part_Onh_Analys_API.Decode(rec_.co_reserve_onh_analys_flag), attr_);
      Client_SYS.Add_To_Attr('CO_RESERVE_ONH_ANALYS_FLAG_DB', rec_.co_reserve_onh_analys_flag, attr_);
   END IF;
   IF (rec_.qty_calc_rounding IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('QTY_CALC_ROUNDING', rec_.qty_calc_rounding, attr_);
   END IF;
   IF (rec_.lifecycle_stage IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('LIFECYCLE_STAGE', Inv_Part_Lifecycle_Stage_API.Decode(rec_.lifecycle_stage), attr_);
      Client_SYS.Add_To_Attr('LIFECYCLE_STAGE_DB', rec_.lifecycle_stage, attr_);
   END IF;
   IF (rec_.life_stage_locked_until IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('LIFE_STAGE_LOCKED_UNTIL', rec_.life_stage_locked_until, attr_);
   END IF;
   IF (rec_.frequency_class IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('FREQUENCY_CLASS', Inv_Part_Frequency_Class_API.Decode(rec_.frequency_class), attr_);
      Client_SYS.Add_To_Attr('FREQUENCY_CLASS_DB', rec_.frequency_class, attr_);
   END IF;
   IF (rec_.freq_class_locked_until IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('FREQ_CLASS_LOCKED_UNTIL', rec_.freq_class_locked_until, attr_);
   END IF;
   IF (rec_.first_stat_issue_date IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('FIRST_STAT_ISSUE_DATE', rec_.first_stat_issue_date, attr_);
   END IF;
   IF (rec_.latest_stat_issue_date IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('LATEST_STAT_ISSUE_DATE', rec_.latest_stat_issue_date, attr_);
   END IF;
   IF (rec_.decline_date IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('DECLINE_DATE', rec_.decline_date, attr_);
   END IF;
   IF (rec_.expired_date IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('EXPIRED_DATE', rec_.expired_date, attr_);
   END IF;
   IF (rec_.decline_issue_counter IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('DECLINE_ISSUE_COUNTER', rec_.decline_issue_counter, attr_);
   END IF;
   IF (rec_.expired_issue_counter IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('EXPIRED_ISSUE_COUNTER', rec_.expired_issue_counter, attr_);
   END IF;
   IF (rec_.min_durab_days_co_deliv IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('MIN_DURAB_DAYS_CO_DELIV', rec_.min_durab_days_co_deliv, attr_);
   END IF;
   IF (rec_.min_durab_days_planning IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('MIN_DURAB_DAYS_PLANNING', rec_.min_durab_days_planning, attr_);
   END IF;
   IF (rec_.storage_width_requirement IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('STORAGE_WIDTH_REQUIREMENT', rec_.storage_width_requirement, attr_);
   END IF;
   IF (rec_.storage_height_requirement IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('STORAGE_HEIGHT_REQUIREMENT', rec_.storage_height_requirement, attr_);
   END IF;
   IF (rec_.storage_depth_requirement IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('STORAGE_DEPTH_REQUIREMENT', rec_.storage_depth_requirement, attr_);
   END IF;
   IF (rec_.storage_volume_requirement IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('STORAGE_VOLUME_REQUIREMENT', rec_.storage_volume_requirement, attr_);
   END IF;
   IF (rec_.storage_weight_requirement IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('STORAGE_WEIGHT_REQUIREMENT', rec_.storage_weight_requirement, attr_);
   END IF;
   IF (rec_.min_storage_temperature IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('MIN_STORAGE_TEMPERATURE', rec_.min_storage_temperature, attr_);
   END IF;
   IF (rec_.max_storage_temperature IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('MAX_STORAGE_TEMPERATURE', rec_.max_storage_temperature, attr_);
   END IF;
   IF (rec_.min_storage_humidity IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('MIN_STORAGE_HUMIDITY', rec_.min_storage_humidity, attr_);
   END IF;
   IF (rec_.max_storage_humidity IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('MAX_STORAGE_HUMIDITY', rec_.max_storage_humidity, attr_);
   END IF;
   IF (rec_.standard_putaway_qty IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('STANDARD_PUTAWAY_QTY', rec_.standard_putaway_qty, attr_);
   END IF;
   IF (rec_.putaway_zone_refill_option IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('PUTAWAY_ZONE_REFILL_OPTION', Putaway_Zone_Refill_Option_API.Decode(rec_.putaway_zone_refill_option), attr_);
      Client_SYS.Add_To_Attr('PUTAWAY_ZONE_REFILL_OPTION_DB', rec_.putaway_zone_refill_option, attr_);
   END IF;
   IF (rec_.reset_config_std_cost IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('RESET_CONFIG_STD_COST', Fnd_Boolean_API.Decode(rec_.reset_config_std_cost), attr_);
      Client_SYS.Add_To_Attr('RESET_CONFIG_STD_COST_DB', rec_.reset_config_std_cost, attr_);
   END IF;
   IF (rec_.mandatory_expiration_date IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('MANDATORY_EXPIRATION_DATE', Fnd_Boolean_API.Decode(rec_.mandatory_expiration_date), attr_);
      Client_SYS.Add_To_Attr('MANDATORY_EXPIRATION_DATE_DB', rec_.mandatory_expiration_date, attr_);
   END IF;
   IF (rec_.excl_ship_pack_proposal IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('EXCL_SHIP_PACK_PROPOSAL', Fnd_Boolean_API.Decode(rec_.excl_ship_pack_proposal), attr_);
      Client_SYS.Add_To_Attr('EXCL_SHIP_PACK_PROPOSAL_DB', rec_.excl_ship_pack_proposal, attr_);
   END IF;
   IF (rec_.statistical_code IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('STATISTICAL_CODE', rec_.statistical_code, attr_);
   END IF;
   IF (rec_.acquisition_origin IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('ACQUISITION_ORIGIN', rec_.acquisition_origin, attr_);
   END IF;
   IF (rec_.acquisition_reason_id IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('ACQUISITION_REASON_ID', rec_.acquisition_reason_id, attr_);
   END IF;
   RETURN attr_;
END Pack___;


FUNCTION Pack___ (
   rec_ IN inventory_part_tab%ROWTYPE,
   indrec_ IN Indicator_Rec ) RETURN VARCHAR2
IS
   attr_ VARCHAR2(32000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   IF (indrec_.contract) THEN
      Client_SYS.Add_To_Attr('CONTRACT', rec_.contract, attr_);
   END IF;
   IF (indrec_.part_no) THEN
      Client_SYS.Add_To_Attr('PART_NO', rec_.part_no, attr_);
   END IF;
   IF (indrec_.accounting_group) THEN
      Client_SYS.Add_To_Attr('ACCOUNTING_GROUP', rec_.accounting_group, attr_);
   END IF;
   IF (indrec_.asset_class) THEN
      Client_SYS.Add_To_Attr('ASSET_CLASS', rec_.asset_class, attr_);
   END IF;
   IF (indrec_.country_of_origin) THEN
      Client_SYS.Add_To_Attr('COUNTRY_OF_ORIGIN', rec_.country_of_origin, attr_);
   END IF;
   IF (indrec_.hazard_code) THEN
      Client_SYS.Add_To_Attr('HAZARD_CODE', rec_.hazard_code, attr_);
   END IF;
   IF (indrec_.note_id) THEN
      Client_SYS.Add_To_Attr('NOTE_ID', rec_.note_id, attr_);
   END IF;
   IF (indrec_.part_product_code) THEN
      Client_SYS.Add_To_Attr('PART_PRODUCT_CODE', rec_.part_product_code, attr_);
   END IF;
   IF (indrec_.part_product_family) THEN
      Client_SYS.Add_To_Attr('PART_PRODUCT_FAMILY', rec_.part_product_family, attr_);
   END IF;
   IF (indrec_.part_status) THEN
      Client_SYS.Add_To_Attr('PART_STATUS', rec_.part_status, attr_);
   END IF;
   IF (indrec_.planner_buyer) THEN
      Client_SYS.Add_To_Attr('PLANNER_BUYER', rec_.planner_buyer, attr_);
   END IF;
   IF (indrec_.prime_commodity) THEN
      Client_SYS.Add_To_Attr('PRIME_COMMODITY', rec_.prime_commodity, attr_);
   END IF;
   IF (indrec_.second_commodity) THEN
      Client_SYS.Add_To_Attr('SECOND_COMMODITY', rec_.second_commodity, attr_);
   END IF;
   IF (indrec_.unit_meas) THEN
      Client_SYS.Add_To_Attr('UNIT_MEAS', rec_.unit_meas, attr_);
   END IF;
   IF (indrec_.catch_unit_meas) THEN
      Client_SYS.Add_To_Attr('CATCH_UNIT_MEAS', rec_.catch_unit_meas, attr_);
   END IF;
   IF (indrec_.description) THEN
      Client_SYS.Add_To_Attr('DESCRIPTION', rec_.description, attr_);
   END IF;
   IF (indrec_.abc_class) THEN
      Client_SYS.Add_To_Attr('ABC_CLASS', rec_.abc_class, attr_);
   END IF;
   IF (indrec_.abc_class_locked_until) THEN
      Client_SYS.Add_To_Attr('ABC_CLASS_LOCKED_UNTIL', rec_.abc_class_locked_until, attr_);
   END IF;
   IF (indrec_.count_variance) THEN
      Client_SYS.Add_To_Attr('COUNT_VARIANCE', rec_.count_variance, attr_);
   END IF;
   IF (indrec_.create_date) THEN
      Client_SYS.Add_To_Attr('CREATE_DATE', rec_.create_date, attr_);
   END IF;
   IF (indrec_.cycle_code) THEN
      Client_SYS.Add_To_Attr('CYCLE_CODE', Inventory_Part_Count_Type_API.Decode(rec_.cycle_code), attr_);
      Client_SYS.Add_To_Attr('CYCLE_CODE_DB', rec_.cycle_code, attr_);
   END IF;
   IF (indrec_.cycle_period) THEN
      Client_SYS.Add_To_Attr('CYCLE_PERIOD', rec_.cycle_period, attr_);
   END IF;
   IF (indrec_.dim_quality) THEN
      Client_SYS.Add_To_Attr('DIM_QUALITY', rec_.dim_quality, attr_);
   END IF;
   IF (indrec_.durability_day) THEN
      Client_SYS.Add_To_Attr('DURABILITY_DAY', rec_.durability_day, attr_);
   END IF;
   IF (indrec_.expected_leadtime) THEN
      Client_SYS.Add_To_Attr('EXPECTED_LEADTIME', rec_.expected_leadtime, attr_);
   END IF;
   IF (indrec_.last_activity_date) THEN
      Client_SYS.Add_To_Attr('LAST_ACTIVITY_DATE', rec_.last_activity_date, attr_);
   END IF;
   IF (indrec_.lead_time_code) THEN
      Client_SYS.Add_To_Attr('LEAD_TIME_CODE', Inv_Part_Lead_Time_Code_API.Decode(rec_.lead_time_code), attr_);
      Client_SYS.Add_To_Attr('LEAD_TIME_CODE_DB', rec_.lead_time_code, attr_);
   END IF;
   IF (indrec_.manuf_leadtime) THEN
      Client_SYS.Add_To_Attr('MANUF_LEADTIME', rec_.manuf_leadtime, attr_);
   END IF;
   IF (indrec_.note_text) THEN
      Client_SYS.Add_To_Attr('NOTE_TEXT', rec_.note_text, attr_);
   END IF;
   IF (indrec_.oe_alloc_assign_flag) THEN
      Client_SYS.Add_To_Attr('OE_ALLOC_ASSIGN_FLAG', Cust_Ord_Reservation_Type_API.Decode(rec_.oe_alloc_assign_flag), attr_);
      Client_SYS.Add_To_Attr('OE_ALLOC_ASSIGN_FLAG_DB', rec_.oe_alloc_assign_flag, attr_);
   END IF;
   IF (indrec_.onhand_analysis_flag) THEN
      Client_SYS.Add_To_Attr('ONHAND_ANALYSIS_FLAG', Inventory_Part_Onh_Analys_API.Decode(rec_.onhand_analysis_flag), attr_);
      Client_SYS.Add_To_Attr('ONHAND_ANALYSIS_FLAG_DB', rec_.onhand_analysis_flag, attr_);
   END IF;
   IF (indrec_.purch_leadtime) THEN
      Client_SYS.Add_To_Attr('PURCH_LEADTIME', rec_.purch_leadtime, attr_);
   END IF;
   IF (indrec_.earliest_ultd_supply_date) THEN
      Client_SYS.Add_To_Attr('EARLIEST_ULTD_SUPPLY_DATE', rec_.earliest_ultd_supply_date, attr_);
   END IF;
   IF (indrec_.supersedes) THEN
      Client_SYS.Add_To_Attr('SUPERSEDES', rec_.supersedes, attr_);
   END IF;
   IF (indrec_.supply_code) THEN
      Client_SYS.Add_To_Attr('SUPPLY_CODE', Material_Requis_Supply_API.Decode(rec_.supply_code), attr_);
      Client_SYS.Add_To_Attr('SUPPLY_CODE_DB', rec_.supply_code, attr_);
   END IF;
   IF (indrec_.type_code) THEN
      Client_SYS.Add_To_Attr('TYPE_CODE', Inventory_Part_Type_API.Decode(rec_.type_code), attr_);
      Client_SYS.Add_To_Attr('TYPE_CODE_DB', rec_.type_code, attr_);
   END IF;
   IF (indrec_.customs_stat_no) THEN
      Client_SYS.Add_To_Attr('CUSTOMS_STAT_NO', rec_.customs_stat_no, attr_);
   END IF;
   IF (indrec_.type_designation) THEN
      Client_SYS.Add_To_Attr('TYPE_DESIGNATION', rec_.type_designation, attr_);
   END IF;
   IF (indrec_.zero_cost_flag) THEN
      Client_SYS.Add_To_Attr('ZERO_COST_FLAG', Inventory_Part_Zero_Cost_API.Decode(rec_.zero_cost_flag), attr_);
      Client_SYS.Add_To_Attr('ZERO_COST_FLAG_DB', rec_.zero_cost_flag, attr_);
   END IF;
   IF (indrec_.avail_activity_status) THEN
      Client_SYS.Add_To_Attr('AVAIL_ACTIVITY_STATUS', Inventory_Part_Avail_Stat_API.Decode(rec_.avail_activity_status), attr_);
      Client_SYS.Add_To_Attr('AVAIL_ACTIVITY_STATUS_DB', rec_.avail_activity_status, attr_);
   END IF;
   IF (indrec_.eng_attribute) THEN
      Client_SYS.Add_To_Attr('ENG_ATTRIBUTE', rec_.eng_attribute, attr_);
   END IF;
   IF (indrec_.shortage_flag) THEN
      Client_SYS.Add_To_Attr('SHORTAGE_FLAG', Inventory_Part_Shortage_API.Decode(rec_.shortage_flag), attr_);
      Client_SYS.Add_To_Attr('SHORTAGE_FLAG_DB', rec_.shortage_flag, attr_);
   END IF;
   IF (indrec_.forecast_consumption_flag) THEN
      Client_SYS.Add_To_Attr('FORECAST_CONSUMPTION_FLAG', Inv_Part_Forecast_Consum_API.Decode(rec_.forecast_consumption_flag), attr_);
      Client_SYS.Add_To_Attr('FORECAST_CONSUMPTION_FLAG_DB', rec_.forecast_consumption_flag, attr_);
   END IF;
   IF (indrec_.stock_management) THEN
      Client_SYS.Add_To_Attr('STOCK_MANAGEMENT', Inventory_Part_Management_API.Decode(rec_.stock_management), attr_);
      Client_SYS.Add_To_Attr('STOCK_MANAGEMENT_DB', rec_.stock_management, attr_);
   END IF;
   IF (indrec_.intrastat_conv_factor) THEN
      Client_SYS.Add_To_Attr('INTRASTAT_CONV_FACTOR', rec_.intrastat_conv_factor, attr_);
   END IF;
   IF (indrec_.part_cost_group_id) THEN
      Client_SYS.Add_To_Attr('PART_COST_GROUP_ID', rec_.part_cost_group_id, attr_);
   END IF;
   IF (indrec_.dop_connection) THEN
      Client_SYS.Add_To_Attr('DOP_CONNECTION', Dop_Connection_API.Decode(rec_.dop_connection), attr_);
      Client_SYS.Add_To_Attr('DOP_CONNECTION_DB', rec_.dop_connection, attr_);
   END IF;
   IF (indrec_.std_name_id) THEN
      Client_SYS.Add_To_Attr('STD_NAME_ID', rec_.std_name_id, attr_);
   END IF;
   IF (indrec_.inventory_valuation_method) THEN
      Client_SYS.Add_To_Attr('INVENTORY_VALUATION_METHOD', Inventory_Value_Method_API.Decode(rec_.inventory_valuation_method), attr_);
      Client_SYS.Add_To_Attr('INVENTORY_VALUATION_METHOD_DB', rec_.inventory_valuation_method, attr_);
   END IF;
   IF (indrec_.negative_on_hand) THEN
      Client_SYS.Add_To_Attr('NEGATIVE_ON_HAND', Negative_On_Hand_API.Decode(rec_.negative_on_hand), attr_);
      Client_SYS.Add_To_Attr('NEGATIVE_ON_HAND_DB', rec_.negative_on_hand, attr_);
   END IF;
   IF (indrec_.technical_coordinator_id) THEN
      Client_SYS.Add_To_Attr('TECHNICAL_COORDINATOR_ID', rec_.technical_coordinator_id, attr_);
   END IF;
   IF (indrec_.invoice_consideration) THEN
      Client_SYS.Add_To_Attr('INVOICE_CONSIDERATION', Invoice_Consideration_API.Decode(rec_.invoice_consideration), attr_);
      Client_SYS.Add_To_Attr('INVOICE_CONSIDERATION_DB', rec_.invoice_consideration, attr_);
   END IF;
   IF (indrec_.actual_cost_activated) THEN
      Client_SYS.Add_To_Attr('ACTUAL_COST_ACTIVATED', rec_.actual_cost_activated, attr_);
   END IF;
   IF (indrec_.max_actual_cost_update) THEN
      Client_SYS.Add_To_Attr('MAX_ACTUAL_COST_UPDATE', rec_.max_actual_cost_update, attr_);
   END IF;
   IF (indrec_.cust_warranty_id) THEN
      Client_SYS.Add_To_Attr('CUST_WARRANTY_ID', rec_.cust_warranty_id, attr_);
   END IF;
   IF (indrec_.sup_warranty_id) THEN
      Client_SYS.Add_To_Attr('SUP_WARRANTY_ID', rec_.sup_warranty_id, attr_);
   END IF;
   IF (indrec_.region_of_origin) THEN
      Client_SYS.Add_To_Attr('REGION_OF_ORIGIN', rec_.region_of_origin, attr_);
   END IF;
   IF (indrec_.inventory_part_cost_level) THEN
      Client_SYS.Add_To_Attr('INVENTORY_PART_COST_LEVEL', Inventory_Part_Cost_Level_API.Decode(rec_.inventory_part_cost_level), attr_);
      Client_SYS.Add_To_Attr('INVENTORY_PART_COST_LEVEL_DB', rec_.inventory_part_cost_level, attr_);
   END IF;
   IF (indrec_.ext_service_cost_method) THEN
      Client_SYS.Add_To_Attr('EXT_SERVICE_COST_METHOD', Ext_Service_Cost_Method_API.Decode(rec_.ext_service_cost_method), attr_);
      Client_SYS.Add_To_Attr('EXT_SERVICE_COST_METHOD_DB', rec_.ext_service_cost_method, attr_);
   END IF;
   IF (indrec_.supply_chain_part_group) THEN
      Client_SYS.Add_To_Attr('SUPPLY_CHAIN_PART_GROUP', rec_.supply_chain_part_group, attr_);
   END IF;
   IF (indrec_.automatic_capability_check) THEN
      Client_SYS.Add_To_Attr('AUTOMATIC_CAPABILITY_CHECK', Capability_Check_Allocate_API.Decode(rec_.automatic_capability_check), attr_);
      Client_SYS.Add_To_Attr('AUTOMATIC_CAPABILITY_CHECK_DB', rec_.automatic_capability_check, attr_);
   END IF;
   IF (indrec_.input_unit_meas_group_id) THEN
      Client_SYS.Add_To_Attr('INPUT_UNIT_MEAS_GROUP_ID', rec_.input_unit_meas_group_id, attr_);
   END IF;
   IF (indrec_.dop_netting) THEN
      Client_SYS.Add_To_Attr('DOP_NETTING', Dop_Netting_API.Decode(rec_.dop_netting), attr_);
      Client_SYS.Add_To_Attr('DOP_NETTING_DB', rec_.dop_netting, attr_);
   END IF;
   IF (indrec_.co_reserve_onh_analys_flag) THEN
      Client_SYS.Add_To_Attr('CO_RESERVE_ONH_ANALYS_FLAG', Inventory_Part_Onh_Analys_API.Decode(rec_.co_reserve_onh_analys_flag), attr_);
      Client_SYS.Add_To_Attr('CO_RESERVE_ONH_ANALYS_FLAG_DB', rec_.co_reserve_onh_analys_flag, attr_);
   END IF;
   IF (indrec_.qty_calc_rounding) THEN
      Client_SYS.Add_To_Attr('QTY_CALC_ROUNDING', rec_.qty_calc_rounding, attr_);
   END IF;
   IF (indrec_.lifecycle_stage) THEN
      Client_SYS.Add_To_Attr('LIFECYCLE_STAGE', Inv_Part_Lifecycle_Stage_API.Decode(rec_.lifecycle_stage), attr_);
      Client_SYS.Add_To_Attr('LIFECYCLE_STAGE_DB', rec_.lifecycle_stage, attr_);
   END IF;
   IF (indrec_.life_stage_locked_until) THEN
      Client_SYS.Add_To_Attr('LIFE_STAGE_LOCKED_UNTIL', rec_.life_stage_locked_until, attr_);
   END IF;
   IF (indrec_.frequency_class) THEN
      Client_SYS.Add_To_Attr('FREQUENCY_CLASS', Inv_Part_Frequency_Class_API.Decode(rec_.frequency_class), attr_);
      Client_SYS.Add_To_Attr('FREQUENCY_CLASS_DB', rec_.frequency_class, attr_);
   END IF;
   IF (indrec_.freq_class_locked_until) THEN
      Client_SYS.Add_To_Attr('FREQ_CLASS_LOCKED_UNTIL', rec_.freq_class_locked_until, attr_);
   END IF;
   IF (indrec_.first_stat_issue_date) THEN
      Client_SYS.Add_To_Attr('FIRST_STAT_ISSUE_DATE', rec_.first_stat_issue_date, attr_);
   END IF;
   IF (indrec_.latest_stat_issue_date) THEN
      Client_SYS.Add_To_Attr('LATEST_STAT_ISSUE_DATE', rec_.latest_stat_issue_date, attr_);
   END IF;
   IF (indrec_.decline_date) THEN
      Client_SYS.Add_To_Attr('DECLINE_DATE', rec_.decline_date, attr_);
   END IF;
   IF (indrec_.expired_date) THEN
      Client_SYS.Add_To_Attr('EXPIRED_DATE', rec_.expired_date, attr_);
   END IF;
   IF (indrec_.decline_issue_counter) THEN
      Client_SYS.Add_To_Attr('DECLINE_ISSUE_COUNTER', rec_.decline_issue_counter, attr_);
   END IF;
   IF (indrec_.expired_issue_counter) THEN
      Client_SYS.Add_To_Attr('EXPIRED_ISSUE_COUNTER', rec_.expired_issue_counter, attr_);
   END IF;
   IF (indrec_.min_durab_days_co_deliv) THEN
      Client_SYS.Add_To_Attr('MIN_DURAB_DAYS_CO_DELIV', rec_.min_durab_days_co_deliv, attr_);
   END IF;
   IF (indrec_.min_durab_days_planning) THEN
      Client_SYS.Add_To_Attr('MIN_DURAB_DAYS_PLANNING', rec_.min_durab_days_planning, attr_);
   END IF;
   IF (indrec_.storage_width_requirement) THEN
      Client_SYS.Add_To_Attr('STORAGE_WIDTH_REQUIREMENT', rec_.storage_width_requirement, attr_);
   END IF;
   IF (indrec_.storage_height_requirement) THEN
      Client_SYS.Add_To_Attr('STORAGE_HEIGHT_REQUIREMENT', rec_.storage_height_requirement, attr_);
   END IF;
   IF (indrec_.storage_depth_requirement) THEN
      Client_SYS.Add_To_Attr('STORAGE_DEPTH_REQUIREMENT', rec_.storage_depth_requirement, attr_);
   END IF;
   IF (indrec_.storage_volume_requirement) THEN
      Client_SYS.Add_To_Attr('STORAGE_VOLUME_REQUIREMENT', rec_.storage_volume_requirement, attr_);
   END IF;
   IF (indrec_.storage_weight_requirement) THEN
      Client_SYS.Add_To_Attr('STORAGE_WEIGHT_REQUIREMENT', rec_.storage_weight_requirement, attr_);
   END IF;
   IF (indrec_.min_storage_temperature) THEN
      Client_SYS.Add_To_Attr('MIN_STORAGE_TEMPERATURE', rec_.min_storage_temperature, attr_);
   END IF;
   IF (indrec_.max_storage_temperature) THEN
      Client_SYS.Add_To_Attr('MAX_STORAGE_TEMPERATURE', rec_.max_storage_temperature, attr_);
   END IF;
   IF (indrec_.min_storage_humidity) THEN
      Client_SYS.Add_To_Attr('MIN_STORAGE_HUMIDITY', rec_.min_storage_humidity, attr_);
   END IF;
   IF (indrec_.max_storage_humidity) THEN
      Client_SYS.Add_To_Attr('MAX_STORAGE_HUMIDITY', rec_.max_storage_humidity, attr_);
   END IF;
   IF (indrec_.standard_putaway_qty) THEN
      Client_SYS.Add_To_Attr('STANDARD_PUTAWAY_QTY', rec_.standard_putaway_qty, attr_);
   END IF;
   IF (indrec_.putaway_zone_refill_option) THEN
      Client_SYS.Add_To_Attr('PUTAWAY_ZONE_REFILL_OPTION', Putaway_Zone_Refill_Option_API.Decode(rec_.putaway_zone_refill_option), attr_);
      Client_SYS.Add_To_Attr('PUTAWAY_ZONE_REFILL_OPTION_DB', rec_.putaway_zone_refill_option, attr_);
   END IF;
   IF (indrec_.reset_config_std_cost) THEN
      Client_SYS.Add_To_Attr('RESET_CONFIG_STD_COST', Fnd_Boolean_API.Decode(rec_.reset_config_std_cost), attr_);
      Client_SYS.Add_To_Attr('RESET_CONFIG_STD_COST_DB', rec_.reset_config_std_cost, attr_);
   END IF;
   IF (indrec_.mandatory_expiration_date) THEN
      Client_SYS.Add_To_Attr('MANDATORY_EXPIRATION_DATE', Fnd_Boolean_API.Decode(rec_.mandatory_expiration_date), attr_);
      Client_SYS.Add_To_Attr('MANDATORY_EXPIRATION_DATE_DB', rec_.mandatory_expiration_date, attr_);
   END IF;
   IF (indrec_.excl_ship_pack_proposal) THEN
      Client_SYS.Add_To_Attr('EXCL_SHIP_PACK_PROPOSAL', Fnd_Boolean_API.Decode(rec_.excl_ship_pack_proposal), attr_);
      Client_SYS.Add_To_Attr('EXCL_SHIP_PACK_PROPOSAL_DB', rec_.excl_ship_pack_proposal, attr_);
   END IF;
   IF (indrec_.statistical_code) THEN
      Client_SYS.Add_To_Attr('STATISTICAL_CODE', rec_.statistical_code, attr_);
   END IF;
   IF (indrec_.acquisition_origin) THEN
      Client_SYS.Add_To_Attr('ACQUISITION_ORIGIN', rec_.acquisition_origin, attr_);
   END IF;
   IF (indrec_.acquisition_reason_id) THEN
      Client_SYS.Add_To_Attr('ACQUISITION_REASON_ID', rec_.acquisition_reason_id, attr_);
   END IF;
   RETURN attr_;
END Pack___;



-- Pack_Table___
--   Reads a record and packs its contents into an attribute string.
--   Similar to Pack___ but just uses table column names and DB values
FUNCTION Pack_Table___ (
   rec_ IN inventory_part_tab%ROWTYPE ) RETURN VARCHAR2
IS
   attr_ VARCHAR2(32000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('CONTRACT', rec_.contract, attr_);
   Client_SYS.Add_To_Attr('PART_NO', rec_.part_no, attr_);
   Client_SYS.Add_To_Attr('ACCOUNTING_GROUP', rec_.accounting_group, attr_);
   Client_SYS.Add_To_Attr('ASSET_CLASS', rec_.asset_class, attr_);
   Client_SYS.Add_To_Attr('COUNTRY_OF_ORIGIN', rec_.country_of_origin, attr_);
   Client_SYS.Add_To_Attr('HAZARD_CODE', rec_.hazard_code, attr_);
   Client_SYS.Add_To_Attr('NOTE_ID', rec_.note_id, attr_);
   Client_SYS.Add_To_Attr('PART_PRODUCT_CODE', rec_.part_product_code, attr_);
   Client_SYS.Add_To_Attr('PART_PRODUCT_FAMILY', rec_.part_product_family, attr_);
   Client_SYS.Add_To_Attr('PART_STATUS', rec_.part_status, attr_);
   Client_SYS.Add_To_Attr('PLANNER_BUYER', rec_.planner_buyer, attr_);
   Client_SYS.Add_To_Attr('PRIME_COMMODITY', rec_.prime_commodity, attr_);
   Client_SYS.Add_To_Attr('SECOND_COMMODITY', rec_.second_commodity, attr_);
   Client_SYS.Add_To_Attr('UNIT_MEAS', rec_.unit_meas, attr_);
   Client_SYS.Add_To_Attr('CATCH_UNIT_MEAS', rec_.catch_unit_meas, attr_);
   Client_SYS.Add_To_Attr('DESCRIPTION', rec_.description, attr_);
   Client_SYS.Add_To_Attr('ABC_CLASS', rec_.abc_class, attr_);
   Client_SYS.Add_To_Attr('ABC_CLASS_LOCKED_UNTIL', rec_.abc_class_locked_until, attr_);
   Client_SYS.Add_To_Attr('COUNT_VARIANCE', rec_.count_variance, attr_);
   Client_SYS.Add_To_Attr('CREATE_DATE', rec_.create_date, attr_);
   Client_SYS.Add_To_Attr('CYCLE_CODE', rec_.cycle_code, attr_);
   Client_SYS.Add_To_Attr('CYCLE_PERIOD', rec_.cycle_period, attr_);
   Client_SYS.Add_To_Attr('DIM_QUALITY', rec_.dim_quality, attr_);
   Client_SYS.Add_To_Attr('DURABILITY_DAY', rec_.durability_day, attr_);
   Client_SYS.Add_To_Attr('EXPECTED_LEADTIME', rec_.expected_leadtime, attr_);
   Client_SYS.Add_To_Attr('LAST_ACTIVITY_DATE', rec_.last_activity_date, attr_);
   Client_SYS.Add_To_Attr('LEAD_TIME_CODE', rec_.lead_time_code, attr_);
   Client_SYS.Add_To_Attr('MANUF_LEADTIME', rec_.manuf_leadtime, attr_);
   Client_SYS.Add_To_Attr('NOTE_TEXT', rec_.note_text, attr_);
   Client_SYS.Add_To_Attr('OE_ALLOC_ASSIGN_FLAG', rec_.oe_alloc_assign_flag, attr_);
   Client_SYS.Add_To_Attr('ONHAND_ANALYSIS_FLAG', rec_.onhand_analysis_flag, attr_);
   Client_SYS.Add_To_Attr('PURCH_LEADTIME', rec_.purch_leadtime, attr_);
   Client_SYS.Add_To_Attr('EARLIEST_ULTD_SUPPLY_DATE', rec_.earliest_ultd_supply_date, attr_);
   Client_SYS.Add_To_Attr('SUPERSEDES', rec_.supersedes, attr_);
   Client_SYS.Add_To_Attr('SUPPLY_CODE', rec_.supply_code, attr_);
   Client_SYS.Add_To_Attr('TYPE_CODE', rec_.type_code, attr_);
   Client_SYS.Add_To_Attr('CUSTOMS_STAT_NO', rec_.customs_stat_no, attr_);
   Client_SYS.Add_To_Attr('TYPE_DESIGNATION', rec_.type_designation, attr_);
   Client_SYS.Add_To_Attr('ZERO_COST_FLAG', rec_.zero_cost_flag, attr_);
   Client_SYS.Add_To_Attr('AVAIL_ACTIVITY_STATUS', rec_.avail_activity_status, attr_);
   Client_SYS.Add_To_Attr('ENG_ATTRIBUTE', rec_.eng_attribute, attr_);
   Client_SYS.Add_To_Attr('SHORTAGE_FLAG', rec_.shortage_flag, attr_);
   Client_SYS.Add_To_Attr('FORECAST_CONSUMPTION_FLAG', rec_.forecast_consumption_flag, attr_);
   Client_SYS.Add_To_Attr('STOCK_MANAGEMENT', rec_.stock_management, attr_);
   Client_SYS.Add_To_Attr('INTRASTAT_CONV_FACTOR', rec_.intrastat_conv_factor, attr_);
   Client_SYS.Add_To_Attr('PART_COST_GROUP_ID', rec_.part_cost_group_id, attr_);
   Client_SYS.Add_To_Attr('DOP_CONNECTION', rec_.dop_connection, attr_);
   Client_SYS.Add_To_Attr('STD_NAME_ID', rec_.std_name_id, attr_);
   Client_SYS.Add_To_Attr('INVENTORY_VALUATION_METHOD', rec_.inventory_valuation_method, attr_);
   Client_SYS.Add_To_Attr('NEGATIVE_ON_HAND', rec_.negative_on_hand, attr_);
   Client_SYS.Add_To_Attr('TECHNICAL_COORDINATOR_ID', rec_.technical_coordinator_id, attr_);
   Client_SYS.Add_To_Attr('INVOICE_CONSIDERATION', rec_.invoice_consideration, attr_);
   Client_SYS.Add_To_Attr('ACTUAL_COST_ACTIVATED', rec_.actual_cost_activated, attr_);
   Client_SYS.Add_To_Attr('MAX_ACTUAL_COST_UPDATE', rec_.max_actual_cost_update, attr_);
   Client_SYS.Add_To_Attr('CUST_WARRANTY_ID', rec_.cust_warranty_id, attr_);
   Client_SYS.Add_To_Attr('SUP_WARRANTY_ID', rec_.sup_warranty_id, attr_);
   Client_SYS.Add_To_Attr('REGION_OF_ORIGIN', rec_.region_of_origin, attr_);
   Client_SYS.Add_To_Attr('INVENTORY_PART_COST_LEVEL', rec_.inventory_part_cost_level, attr_);
   Client_SYS.Add_To_Attr('EXT_SERVICE_COST_METHOD', rec_.ext_service_cost_method, attr_);
   Client_SYS.Add_To_Attr('SUPPLY_CHAIN_PART_GROUP', rec_.supply_chain_part_group, attr_);
   Client_SYS.Add_To_Attr('AUTOMATIC_CAPABILITY_CHECK', rec_.automatic_capability_check, attr_);
   Client_SYS.Add_To_Attr('INPUT_UNIT_MEAS_GROUP_ID', rec_.input_unit_meas_group_id, attr_);
   Client_SYS.Add_To_Attr('DOP_NETTING', rec_.dop_netting, attr_);
   Client_SYS.Add_To_Attr('CO_RESERVE_ONH_ANALYS_FLAG', rec_.co_reserve_onh_analys_flag, attr_);
   Client_SYS.Add_To_Attr('QTY_CALC_ROUNDING', rec_.qty_calc_rounding, attr_);
   Client_SYS.Add_To_Attr('LIFECYCLE_STAGE', rec_.lifecycle_stage, attr_);
   Client_SYS.Add_To_Attr('LIFE_STAGE_LOCKED_UNTIL', rec_.life_stage_locked_until, attr_);
   Client_SYS.Add_To_Attr('FREQUENCY_CLASS', rec_.frequency_class, attr_);
   Client_SYS.Add_To_Attr('FREQ_CLASS_LOCKED_UNTIL', rec_.freq_class_locked_until, attr_);
   Client_SYS.Add_To_Attr('FIRST_STAT_ISSUE_DATE', rec_.first_stat_issue_date, attr_);
   Client_SYS.Add_To_Attr('LATEST_STAT_ISSUE_DATE', rec_.latest_stat_issue_date, attr_);
   Client_SYS.Add_To_Attr('DECLINE_DATE', rec_.decline_date, attr_);
   Client_SYS.Add_To_Attr('EXPIRED_DATE', rec_.expired_date, attr_);
   Client_SYS.Add_To_Attr('DECLINE_ISSUE_COUNTER', rec_.decline_issue_counter, attr_);
   Client_SYS.Add_To_Attr('EXPIRED_ISSUE_COUNTER', rec_.expired_issue_counter, attr_);
   Client_SYS.Add_To_Attr('MIN_DURAB_DAYS_CO_DELIV', rec_.min_durab_days_co_deliv, attr_);
   Client_SYS.Add_To_Attr('MIN_DURAB_DAYS_PLANNING', rec_.min_durab_days_planning, attr_);
   Client_SYS.Add_To_Attr('STORAGE_WIDTH_REQUIREMENT', rec_.storage_width_requirement, attr_);
   Client_SYS.Add_To_Attr('STORAGE_HEIGHT_REQUIREMENT', rec_.storage_height_requirement, attr_);
   Client_SYS.Add_To_Attr('STORAGE_DEPTH_REQUIREMENT', rec_.storage_depth_requirement, attr_);
   Client_SYS.Add_To_Attr('STORAGE_VOLUME_REQUIREMENT', rec_.storage_volume_requirement, attr_);
   Client_SYS.Add_To_Attr('STORAGE_WEIGHT_REQUIREMENT', rec_.storage_weight_requirement, attr_);
   Client_SYS.Add_To_Attr('MIN_STORAGE_TEMPERATURE', rec_.min_storage_temperature, attr_);
   Client_SYS.Add_To_Attr('MAX_STORAGE_TEMPERATURE', rec_.max_storage_temperature, attr_);
   Client_SYS.Add_To_Attr('MIN_STORAGE_HUMIDITY', rec_.min_storage_humidity, attr_);
   Client_SYS.Add_To_Attr('MAX_STORAGE_HUMIDITY', rec_.max_storage_humidity, attr_);
   Client_SYS.Add_To_Attr('STANDARD_PUTAWAY_QTY', rec_.standard_putaway_qty, attr_);
   Client_SYS.Add_To_Attr('PUTAWAY_ZONE_REFILL_OPTION', rec_.putaway_zone_refill_option, attr_);
   Client_SYS.Add_To_Attr('RESET_CONFIG_STD_COST', rec_.reset_config_std_cost, attr_);
   Client_SYS.Add_To_Attr('MANDATORY_EXPIRATION_DATE', rec_.mandatory_expiration_date, attr_);
   Client_SYS.Add_To_Attr('EXCL_SHIP_PACK_PROPOSAL', rec_.excl_ship_pack_proposal, attr_);
   Client_SYS.Add_To_Attr('STATISTICAL_CODE', rec_.statistical_code, attr_);
   Client_SYS.Add_To_Attr('ACQUISITION_ORIGIN', rec_.acquisition_origin, attr_);
   Client_SYS.Add_To_Attr('ACQUISITION_REASON_ID', rec_.acquisition_reason_id, attr_);
   Client_SYS.Add_To_Attr('ROWKEY', rec_.rowkey, attr_);
   RETURN attr_;
END Pack_Table___;



-- Public_To_Table___
--   Reads values in the public_rec record and returns them in a table rowtype record.
FUNCTION Public_To_Table___ (
   public_ IN Public_Rec ) RETURN inventory_part_tab%ROWTYPE
IS
   rec_ inventory_part_tab%ROWTYPE;
BEGIN
   rec_.rowversion                     := public_.rowversion;
   rec_.rowkey                         := public_.rowkey;
   rec_.contract                       := public_.contract;
   rec_.part_no                        := public_.part_no;
   rec_.accounting_group               := public_.accounting_group;
   rec_.asset_class                    := public_.asset_class;
   rec_.country_of_origin              := public_.country_of_origin;
   rec_.hazard_code                    := public_.hazard_code;
   rec_.note_id                        := public_.note_id;
   rec_.part_product_code              := public_.part_product_code;
   rec_.part_product_family            := public_.part_product_family;
   rec_.part_status                    := public_.part_status;
   rec_.planner_buyer                  := public_.planner_buyer;
   rec_.prime_commodity                := public_.prime_commodity;
   rec_.second_commodity               := public_.second_commodity;
   rec_.unit_meas                      := public_.unit_meas;
   rec_.catch_unit_meas                := public_.catch_unit_meas;
   rec_.abc_class                      := public_.abc_class;
   rec_.abc_class_locked_until         := public_.abc_class_locked_until;
   rec_.count_variance                 := public_.count_variance;
   rec_.create_date                    := public_.create_date;
   rec_.cycle_code                     := public_.cycle_code;
   rec_.cycle_period                   := public_.cycle_period;
   rec_.dim_quality                    := public_.dim_quality;
   rec_.durability_day                 := public_.durability_day;
   rec_.expected_leadtime              := public_.expected_leadtime;
   rec_.lead_time_code                 := public_.lead_time_code;
   rec_.manuf_leadtime                 := public_.manuf_leadtime;
   rec_.oe_alloc_assign_flag           := public_.oe_alloc_assign_flag;
   rec_.onhand_analysis_flag           := public_.onhand_analysis_flag;
   rec_.purch_leadtime                 := public_.purch_leadtime;
   rec_.earliest_ultd_supply_date      := public_.earliest_ultd_supply_date;
   rec_.supersedes                     := public_.supersedes;
   rec_.supply_code                    := public_.supply_code;
   rec_.type_code                      := public_.type_code;
   rec_.customs_stat_no                := public_.customs_stat_no;
   rec_.type_designation               := public_.type_designation;
   rec_.zero_cost_flag                 := public_.zero_cost_flag;
   rec_.avail_activity_status          := public_.avail_activity_status;
   rec_.eng_attribute                  := public_.eng_attribute;
   rec_.shortage_flag                  := public_.shortage_flag;
   rec_.forecast_consumption_flag      := public_.forecast_consumption_flag;
   rec_.stock_management               := public_.stock_management;
   rec_.intrastat_conv_factor          := public_.intrastat_conv_factor;
   rec_.part_cost_group_id             := public_.part_cost_group_id;
   rec_.dop_connection                 := public_.dop_connection;
   rec_.std_name_id                    := public_.std_name_id;
   rec_.inventory_valuation_method     := public_.inventory_valuation_method;
   rec_.negative_on_hand               := public_.negative_on_hand;
   rec_.technical_coordinator_id       := public_.technical_coordinator_id;
   rec_.invoice_consideration          := public_.invoice_consideration;
   rec_.actual_cost_activated          := public_.actual_cost_activated;
   rec_.max_actual_cost_update         := public_.max_actual_cost_update;
   rec_.cust_warranty_id               := public_.cust_warranty_id;
   rec_.sup_warranty_id                := public_.sup_warranty_id;
   rec_.region_of_origin               := public_.region_of_origin;
   rec_.inventory_part_cost_level      := public_.inventory_part_cost_level;
   rec_.ext_service_cost_method        := public_.ext_service_cost_method;
   rec_.supply_chain_part_group        := public_.supply_chain_part_group;
   rec_.automatic_capability_check     := public_.automatic_capability_check;
   rec_.input_unit_meas_group_id       := public_.input_unit_meas_group_id;
   rec_.dop_netting                    := public_.dop_netting;
   rec_.co_reserve_onh_analys_flag     := public_.co_reserve_onh_analys_flag;
   rec_.qty_calc_rounding              := public_.qty_calc_rounding;
   rec_.lifecycle_stage                := public_.lifecycle_stage;
   rec_.life_stage_locked_until        := public_.life_stage_locked_until;
   rec_.frequency_class                := public_.frequency_class;
   rec_.freq_class_locked_until        := public_.freq_class_locked_until;
   rec_.first_stat_issue_date          := public_.first_stat_issue_date;
   rec_.latest_stat_issue_date         := public_.latest_stat_issue_date;
   rec_.decline_date                   := public_.decline_date;
   rec_.expired_date                   := public_.expired_date;
   rec_.decline_issue_counter          := public_.decline_issue_counter;
   rec_.expired_issue_counter          := public_.expired_issue_counter;
   rec_.min_durab_days_co_deliv        := public_.min_durab_days_co_deliv;
   rec_.min_durab_days_planning        := public_.min_durab_days_planning;
   rec_.storage_width_requirement      := public_.storage_width_requirement;
   rec_.storage_height_requirement     := public_.storage_height_requirement;
   rec_.storage_depth_requirement      := public_.storage_depth_requirement;
   rec_.storage_volume_requirement     := public_.storage_volume_requirement;
   rec_.storage_weight_requirement     := public_.storage_weight_requirement;
   rec_.min_storage_temperature        := public_.min_storage_temperature;
   rec_.max_storage_temperature        := public_.max_storage_temperature;
   rec_.min_storage_humidity           := public_.min_storage_humidity;
   rec_.max_storage_humidity           := public_.max_storage_humidity;
   rec_.standard_putaway_qty           := public_.standard_putaway_qty;
   rec_.reset_config_std_cost          := public_.reset_config_std_cost;
   rec_.mandatory_expiration_date      := public_.mandatory_expiration_date;
   rec_.excl_ship_pack_proposal        := public_.excl_ship_pack_proposal;
   rec_.statistical_code               := public_.statistical_code;
   rec_.acquisition_origin             := public_.acquisition_origin;
   rec_.acquisition_reason_id          := public_.acquisition_reason_id;
   RETURN rec_;
END Public_To_Table___;



-- Table_To_Public___
--   Reads values in the table rowtype record and returns them in a public_rec record.
FUNCTION Table_To_Public___ (
   rec_ IN inventory_part_tab%ROWTYPE ) RETURN Public_Rec
IS
   public_ Public_Rec;
BEGIN
   public_.rowversion                     := rec_.rowversion;
   public_.rowkey                         := rec_.rowkey;
   public_.contract                       := rec_.contract;
   public_.part_no                        := rec_.part_no;
   public_.accounting_group               := rec_.accounting_group;
   public_.asset_class                    := rec_.asset_class;
   public_.country_of_origin              := rec_.country_of_origin;
   public_.hazard_code                    := rec_.hazard_code;
   public_.note_id                        := rec_.note_id;
   public_.part_product_code              := rec_.part_product_code;
   public_.part_product_family            := rec_.part_product_family;
   public_.part_status                    := rec_.part_status;
   public_.planner_buyer                  := rec_.planner_buyer;
   public_.prime_commodity                := rec_.prime_commodity;
   public_.second_commodity               := rec_.second_commodity;
   public_.unit_meas                      := rec_.unit_meas;
   public_.catch_unit_meas                := rec_.catch_unit_meas;
   public_.abc_class                      := rec_.abc_class;
   public_.abc_class_locked_until         := rec_.abc_class_locked_until;
   public_.count_variance                 := rec_.count_variance;
   public_.create_date                    := rec_.create_date;
   public_.cycle_code                     := rec_.cycle_code;
   public_.cycle_period                   := rec_.cycle_period;
   public_.dim_quality                    := rec_.dim_quality;
   public_.durability_day                 := rec_.durability_day;
   public_.expected_leadtime              := rec_.expected_leadtime;
   public_.lead_time_code                 := rec_.lead_time_code;
   public_.manuf_leadtime                 := rec_.manuf_leadtime;
   public_.oe_alloc_assign_flag           := rec_.oe_alloc_assign_flag;
   public_.onhand_analysis_flag           := rec_.onhand_analysis_flag;
   public_.purch_leadtime                 := rec_.purch_leadtime;
   public_.earliest_ultd_supply_date      := rec_.earliest_ultd_supply_date;
   public_.supersedes                     := rec_.supersedes;
   public_.supply_code                    := rec_.supply_code;
   public_.type_code                      := rec_.type_code;
   public_.customs_stat_no                := rec_.customs_stat_no;
   public_.type_designation               := rec_.type_designation;
   public_.zero_cost_flag                 := rec_.zero_cost_flag;
   public_.avail_activity_status          := rec_.avail_activity_status;
   public_.eng_attribute                  := rec_.eng_attribute;
   public_.shortage_flag                  := rec_.shortage_flag;
   public_.forecast_consumption_flag      := rec_.forecast_consumption_flag;
   public_.stock_management               := rec_.stock_management;
   public_.intrastat_conv_factor          := rec_.intrastat_conv_factor;
   public_.part_cost_group_id             := rec_.part_cost_group_id;
   public_.dop_connection                 := rec_.dop_connection;
   public_.std_name_id                    := rec_.std_name_id;
   public_.inventory_valuation_method     := rec_.inventory_valuation_method;
   public_.negative_on_hand               := rec_.negative_on_hand;
   public_.technical_coordinator_id       := rec_.technical_coordinator_id;
   public_.invoice_consideration          := rec_.invoice_consideration;
   public_.actual_cost_activated          := rec_.actual_cost_activated;
   public_.max_actual_cost_update         := rec_.max_actual_cost_update;
   public_.cust_warranty_id               := rec_.cust_warranty_id;
   public_.sup_warranty_id                := rec_.sup_warranty_id;
   public_.region_of_origin               := rec_.region_of_origin;
   public_.inventory_part_cost_level      := rec_.inventory_part_cost_level;
   public_.ext_service_cost_method        := rec_.ext_service_cost_method;
   public_.supply_chain_part_group        := rec_.supply_chain_part_group;
   public_.automatic_capability_check     := rec_.automatic_capability_check;
   public_.input_unit_meas_group_id       := rec_.input_unit_meas_group_id;
   public_.dop_netting                    := rec_.dop_netting;
   public_.co_reserve_onh_analys_flag     := rec_.co_reserve_onh_analys_flag;
   public_.qty_calc_rounding              := rec_.qty_calc_rounding;
   public_.lifecycle_stage                := rec_.lifecycle_stage;
   public_.life_stage_locked_until        := rec_.life_stage_locked_until;
   public_.frequency_class                := rec_.frequency_class;
   public_.freq_class_locked_until        := rec_.freq_class_locked_until;
   public_.first_stat_issue_date          := rec_.first_stat_issue_date;
   public_.latest_stat_issue_date         := rec_.latest_stat_issue_date;
   public_.decline_date                   := rec_.decline_date;
   public_.expired_date                   := rec_.expired_date;
   public_.decline_issue_counter          := rec_.decline_issue_counter;
   public_.expired_issue_counter          := rec_.expired_issue_counter;
   public_.min_durab_days_co_deliv        := rec_.min_durab_days_co_deliv;
   public_.min_durab_days_planning        := rec_.min_durab_days_planning;
   public_.storage_width_requirement      := rec_.storage_width_requirement;
   public_.storage_height_requirement     := rec_.storage_height_requirement;
   public_.storage_depth_requirement      := rec_.storage_depth_requirement;
   public_.storage_volume_requirement     := rec_.storage_volume_requirement;
   public_.storage_weight_requirement     := rec_.storage_weight_requirement;
   public_.min_storage_temperature        := rec_.min_storage_temperature;
   public_.max_storage_temperature        := rec_.max_storage_temperature;
   public_.min_storage_humidity           := rec_.min_storage_humidity;
   public_.max_storage_humidity           := rec_.max_storage_humidity;
   public_.standard_putaway_qty           := rec_.standard_putaway_qty;
   public_.reset_config_std_cost          := rec_.reset_config_std_cost;
   public_.mandatory_expiration_date      := rec_.mandatory_expiration_date;
   public_.excl_ship_pack_proposal        := rec_.excl_ship_pack_proposal;
   public_.statistical_code               := rec_.statistical_code;
   public_.acquisition_origin             := rec_.acquisition_origin;
   public_.acquisition_reason_id          := rec_.acquisition_reason_id;
   RETURN public_;
END Table_To_Public___;


-- Reset_Indicator_Rec___
--   Resets all elements of given Indicator_Rec to FALSE.
PROCEDURE Reset_Indicator_Rec___ (
   indrec_ IN OUT Indicator_Rec )
IS
   empty_indrec_ Indicator_Rec;
BEGIN
   indrec_ := empty_indrec_;
END Reset_Indicator_Rec___;


-- Get_Indicator_Rec___
--   Returns an Indicator_Rec that reflects the content of a table record.
FUNCTION Get_Indicator_Rec___ (
   rec_ IN inventory_part_tab%ROWTYPE ) RETURN Indicator_Rec
IS
   indrec_ Indicator_Rec;
BEGIN
   indrec_.contract := rec_.contract IS NOT NULL;
   indrec_.part_no := rec_.part_no IS NOT NULL;
   indrec_.accounting_group := rec_.accounting_group IS NOT NULL;
   indrec_.asset_class := rec_.asset_class IS NOT NULL;
   indrec_.country_of_origin := rec_.country_of_origin IS NOT NULL;
   indrec_.hazard_code := rec_.hazard_code IS NOT NULL;
   indrec_.note_id := rec_.note_id IS NOT NULL;
   indrec_.part_product_code := rec_.part_product_code IS NOT NULL;
   indrec_.part_product_family := rec_.part_product_family IS NOT NULL;
   indrec_.part_status := rec_.part_status IS NOT NULL;
   indrec_.planner_buyer := rec_.planner_buyer IS NOT NULL;
   indrec_.prime_commodity := rec_.prime_commodity IS NOT NULL;
   indrec_.second_commodity := rec_.second_commodity IS NOT NULL;
   indrec_.unit_meas := rec_.unit_meas IS NOT NULL;
   indrec_.catch_unit_meas := rec_.catch_unit_meas IS NOT NULL;
   indrec_.description := rec_.description IS NOT NULL;
   indrec_.abc_class := rec_.abc_class IS NOT NULL;
   indrec_.abc_class_locked_until := rec_.abc_class_locked_until IS NOT NULL;
   indrec_.count_variance := rec_.count_variance IS NOT NULL;
   indrec_.create_date := rec_.create_date IS NOT NULL;
   indrec_.cycle_code := rec_.cycle_code IS NOT NULL;
   indrec_.cycle_period := rec_.cycle_period IS NOT NULL;
   indrec_.dim_quality := rec_.dim_quality IS NOT NULL;
   indrec_.durability_day := rec_.durability_day IS NOT NULL;
   indrec_.expected_leadtime := rec_.expected_leadtime IS NOT NULL;
   indrec_.last_activity_date := rec_.last_activity_date IS NOT NULL;
   indrec_.lead_time_code := rec_.lead_time_code IS NOT NULL;
   indrec_.manuf_leadtime := rec_.manuf_leadtime IS NOT NULL;
   indrec_.note_text := rec_.note_text IS NOT NULL;
   indrec_.oe_alloc_assign_flag := rec_.oe_alloc_assign_flag IS NOT NULL;
   indrec_.onhand_analysis_flag := rec_.onhand_analysis_flag IS NOT NULL;
   indrec_.purch_leadtime := rec_.purch_leadtime IS NOT NULL;
   indrec_.earliest_ultd_supply_date := rec_.earliest_ultd_supply_date IS NOT NULL;
   indrec_.supersedes := rec_.supersedes IS NOT NULL;
   indrec_.supply_code := rec_.supply_code IS NOT NULL;
   indrec_.type_code := rec_.type_code IS NOT NULL;
   indrec_.customs_stat_no := rec_.customs_stat_no IS NOT NULL;
   indrec_.type_designation := rec_.type_designation IS NOT NULL;
   indrec_.zero_cost_flag := rec_.zero_cost_flag IS NOT NULL;
   indrec_.avail_activity_status := rec_.avail_activity_status IS NOT NULL;
   indrec_.eng_attribute := rec_.eng_attribute IS NOT NULL;
   indrec_.shortage_flag := rec_.shortage_flag IS NOT NULL;
   indrec_.forecast_consumption_flag := rec_.forecast_consumption_flag IS NOT NULL;
   indrec_.stock_management := rec_.stock_management IS NOT NULL;
   indrec_.intrastat_conv_factor := rec_.intrastat_conv_factor IS NOT NULL;
   indrec_.part_cost_group_id := rec_.part_cost_group_id IS NOT NULL;
   indrec_.dop_connection := rec_.dop_connection IS NOT NULL;
   indrec_.std_name_id := rec_.std_name_id IS NOT NULL;
   indrec_.inventory_valuation_method := rec_.inventory_valuation_method IS NOT NULL;
   indrec_.negative_on_hand := rec_.negative_on_hand IS NOT NULL;
   indrec_.technical_coordinator_id := rec_.technical_coordinator_id IS NOT NULL;
   indrec_.invoice_consideration := rec_.invoice_consideration IS NOT NULL;
   indrec_.actual_cost_activated := rec_.actual_cost_activated IS NOT NULL;
   indrec_.max_actual_cost_update := rec_.max_actual_cost_update IS NOT NULL;
   indrec_.cust_warranty_id := rec_.cust_warranty_id IS NOT NULL;
   indrec_.sup_warranty_id := rec_.sup_warranty_id IS NOT NULL;
   indrec_.region_of_origin := rec_.region_of_origin IS NOT NULL;
   indrec_.inventory_part_cost_level := rec_.inventory_part_cost_level IS NOT NULL;
   indrec_.ext_service_cost_method := rec_.ext_service_cost_method IS NOT NULL;
   indrec_.supply_chain_part_group := rec_.supply_chain_part_group IS NOT NULL;
   indrec_.automatic_capability_check := rec_.automatic_capability_check IS NOT NULL;
   indrec_.input_unit_meas_group_id := rec_.input_unit_meas_group_id IS NOT NULL;
   indrec_.dop_netting := rec_.dop_netting IS NOT NULL;
   indrec_.co_reserve_onh_analys_flag := rec_.co_reserve_onh_analys_flag IS NOT NULL;
   indrec_.qty_calc_rounding := rec_.qty_calc_rounding IS NOT NULL;
   indrec_.lifecycle_stage := rec_.lifecycle_stage IS NOT NULL;
   indrec_.life_stage_locked_until := rec_.life_stage_locked_until IS NOT NULL;
   indrec_.frequency_class := rec_.frequency_class IS NOT NULL;
   indrec_.freq_class_locked_until := rec_.freq_class_locked_until IS NOT NULL;
   indrec_.first_stat_issue_date := rec_.first_stat_issue_date IS NOT NULL;
   indrec_.latest_stat_issue_date := rec_.latest_stat_issue_date IS NOT NULL;
   indrec_.decline_date := rec_.decline_date IS NOT NULL;
   indrec_.expired_date := rec_.expired_date IS NOT NULL;
   indrec_.decline_issue_counter := rec_.decline_issue_counter IS NOT NULL;
   indrec_.expired_issue_counter := rec_.expired_issue_counter IS NOT NULL;
   indrec_.min_durab_days_co_deliv := rec_.min_durab_days_co_deliv IS NOT NULL;
   indrec_.min_durab_days_planning := rec_.min_durab_days_planning IS NOT NULL;
   indrec_.storage_width_requirement := rec_.storage_width_requirement IS NOT NULL;
   indrec_.storage_height_requirement := rec_.storage_height_requirement IS NOT NULL;
   indrec_.storage_depth_requirement := rec_.storage_depth_requirement IS NOT NULL;
   indrec_.storage_volume_requirement := rec_.storage_volume_requirement IS NOT NULL;
   indrec_.storage_weight_requirement := rec_.storage_weight_requirement IS NOT NULL;
   indrec_.min_storage_temperature := rec_.min_storage_temperature IS NOT NULL;
   indrec_.max_storage_temperature := rec_.max_storage_temperature IS NOT NULL;
   indrec_.min_storage_humidity := rec_.min_storage_humidity IS NOT NULL;
   indrec_.max_storage_humidity := rec_.max_storage_humidity IS NOT NULL;
   indrec_.standard_putaway_qty := rec_.standard_putaway_qty IS NOT NULL;
   indrec_.putaway_zone_refill_option := rec_.putaway_zone_refill_option IS NOT NULL;
   indrec_.reset_config_std_cost := rec_.reset_config_std_cost IS NOT NULL;
   indrec_.mandatory_expiration_date := rec_.mandatory_expiration_date IS NOT NULL;
   indrec_.excl_ship_pack_proposal := rec_.excl_ship_pack_proposal IS NOT NULL;
   indrec_.statistical_code := rec_.statistical_code IS NOT NULL;
   indrec_.acquisition_origin := rec_.acquisition_origin IS NOT NULL;
   indrec_.acquisition_reason_id := rec_.acquisition_reason_id IS NOT NULL;
   RETURN indrec_;
END Get_Indicator_Rec___;


-- Get_Indicator_Rec___
--   Returns an Indicator_Rec that reflects the difference between two table records.
FUNCTION Get_Indicator_Rec___ (
   oldrec_ IN inventory_part_tab%ROWTYPE,
   newrec_ IN inventory_part_tab%ROWTYPE ) RETURN Indicator_Rec
IS
   indrec_ Indicator_Rec;
BEGIN
   indrec_.contract := Validate_SYS.Is_Changed(oldrec_.contract, newrec_.contract);
   indrec_.part_no := Validate_SYS.Is_Changed(oldrec_.part_no, newrec_.part_no);
   indrec_.accounting_group := Validate_SYS.Is_Changed(oldrec_.accounting_group, newrec_.accounting_group);
   indrec_.asset_class := Validate_SYS.Is_Changed(oldrec_.asset_class, newrec_.asset_class);
   indrec_.country_of_origin := Validate_SYS.Is_Changed(oldrec_.country_of_origin, newrec_.country_of_origin);
   indrec_.hazard_code := Validate_SYS.Is_Changed(oldrec_.hazard_code, newrec_.hazard_code);
   indrec_.note_id := Validate_SYS.Is_Changed(oldrec_.note_id, newrec_.note_id);
   indrec_.part_product_code := Validate_SYS.Is_Changed(oldrec_.part_product_code, newrec_.part_product_code);
   indrec_.part_product_family := Validate_SYS.Is_Changed(oldrec_.part_product_family, newrec_.part_product_family);
   indrec_.part_status := Validate_SYS.Is_Changed(oldrec_.part_status, newrec_.part_status);
   indrec_.planner_buyer := Validate_SYS.Is_Changed(oldrec_.planner_buyer, newrec_.planner_buyer);
   indrec_.prime_commodity := Validate_SYS.Is_Changed(oldrec_.prime_commodity, newrec_.prime_commodity);
   indrec_.second_commodity := Validate_SYS.Is_Changed(oldrec_.second_commodity, newrec_.second_commodity);
   indrec_.unit_meas := Validate_SYS.Is_Changed(oldrec_.unit_meas, newrec_.unit_meas);
   indrec_.catch_unit_meas := Validate_SYS.Is_Changed(oldrec_.catch_unit_meas, newrec_.catch_unit_meas);
   indrec_.description := Validate_SYS.Is_Changed(oldrec_.description, newrec_.description);
   indrec_.abc_class := Validate_SYS.Is_Changed(oldrec_.abc_class, newrec_.abc_class);
   indrec_.abc_class_locked_until := Validate_SYS.Is_Changed(oldrec_.abc_class_locked_until, newrec_.abc_class_locked_until);
   indrec_.count_variance := Validate_SYS.Is_Changed(oldrec_.count_variance, newrec_.count_variance);
   indrec_.create_date := Validate_SYS.Is_Changed(oldrec_.create_date, newrec_.create_date);
   indrec_.cycle_code := Validate_SYS.Is_Changed(oldrec_.cycle_code, newrec_.cycle_code);
   indrec_.cycle_period := Validate_SYS.Is_Changed(oldrec_.cycle_period, newrec_.cycle_period);
   indrec_.dim_quality := Validate_SYS.Is_Changed(oldrec_.dim_quality, newrec_.dim_quality);
   indrec_.durability_day := Validate_SYS.Is_Changed(oldrec_.durability_day, newrec_.durability_day);
   indrec_.expected_leadtime := Validate_SYS.Is_Changed(oldrec_.expected_leadtime, newrec_.expected_leadtime);
   indrec_.last_activity_date := Validate_SYS.Is_Changed(oldrec_.last_activity_date, newrec_.last_activity_date);
   indrec_.lead_time_code := Validate_SYS.Is_Changed(oldrec_.lead_time_code, newrec_.lead_time_code);
   indrec_.manuf_leadtime := Validate_SYS.Is_Changed(oldrec_.manuf_leadtime, newrec_.manuf_leadtime);
   indrec_.note_text := Validate_SYS.Is_Changed(oldrec_.note_text, newrec_.note_text);
   indrec_.oe_alloc_assign_flag := Validate_SYS.Is_Changed(oldrec_.oe_alloc_assign_flag, newrec_.oe_alloc_assign_flag);
   indrec_.onhand_analysis_flag := Validate_SYS.Is_Changed(oldrec_.onhand_analysis_flag, newrec_.onhand_analysis_flag);
   indrec_.purch_leadtime := Validate_SYS.Is_Changed(oldrec_.purch_leadtime, newrec_.purch_leadtime);
   indrec_.earliest_ultd_supply_date := Validate_SYS.Is_Changed(oldrec_.earliest_ultd_supply_date, newrec_.earliest_ultd_supply_date);
   indrec_.supersedes := Validate_SYS.Is_Changed(oldrec_.supersedes, newrec_.supersedes);
   indrec_.supply_code := Validate_SYS.Is_Changed(oldrec_.supply_code, newrec_.supply_code);
   indrec_.type_code := Validate_SYS.Is_Changed(oldrec_.type_code, newrec_.type_code);
   indrec_.customs_stat_no := Validate_SYS.Is_Changed(oldrec_.customs_stat_no, newrec_.customs_stat_no);
   indrec_.type_designation := Validate_SYS.Is_Changed(oldrec_.type_designation, newrec_.type_designation);
   indrec_.zero_cost_flag := Validate_SYS.Is_Changed(oldrec_.zero_cost_flag, newrec_.zero_cost_flag);
   indrec_.avail_activity_status := Validate_SYS.Is_Changed(oldrec_.avail_activity_status, newrec_.avail_activity_status);
   indrec_.eng_attribute := Validate_SYS.Is_Changed(oldrec_.eng_attribute, newrec_.eng_attribute);
   indrec_.shortage_flag := Validate_SYS.Is_Changed(oldrec_.shortage_flag, newrec_.shortage_flag);
   indrec_.forecast_consumption_flag := Validate_SYS.Is_Changed(oldrec_.forecast_consumption_flag, newrec_.forecast_consumption_flag);
   indrec_.stock_management := Validate_SYS.Is_Changed(oldrec_.stock_management, newrec_.stock_management);
   indrec_.intrastat_conv_factor := Validate_SYS.Is_Changed(oldrec_.intrastat_conv_factor, newrec_.intrastat_conv_factor);
   indrec_.part_cost_group_id := Validate_SYS.Is_Changed(oldrec_.part_cost_group_id, newrec_.part_cost_group_id);
   indrec_.dop_connection := Validate_SYS.Is_Changed(oldrec_.dop_connection, newrec_.dop_connection);
   indrec_.std_name_id := Validate_SYS.Is_Changed(oldrec_.std_name_id, newrec_.std_name_id);
   indrec_.inventory_valuation_method := Validate_SYS.Is_Changed(oldrec_.inventory_valuation_method, newrec_.inventory_valuation_method);
   indrec_.negative_on_hand := Validate_SYS.Is_Changed(oldrec_.negative_on_hand, newrec_.negative_on_hand);
   indrec_.technical_coordinator_id := Validate_SYS.Is_Changed(oldrec_.technical_coordinator_id, newrec_.technical_coordinator_id);
   indrec_.invoice_consideration := Validate_SYS.Is_Changed(oldrec_.invoice_consideration, newrec_.invoice_consideration);
   indrec_.actual_cost_activated := Validate_SYS.Is_Changed(oldrec_.actual_cost_activated, newrec_.actual_cost_activated);
   indrec_.max_actual_cost_update := Validate_SYS.Is_Changed(oldrec_.max_actual_cost_update, newrec_.max_actual_cost_update);
   indrec_.cust_warranty_id := Validate_SYS.Is_Changed(oldrec_.cust_warranty_id, newrec_.cust_warranty_id);
   indrec_.sup_warranty_id := Validate_SYS.Is_Changed(oldrec_.sup_warranty_id, newrec_.sup_warranty_id);
   indrec_.region_of_origin := Validate_SYS.Is_Changed(oldrec_.region_of_origin, newrec_.region_of_origin);
   indrec_.inventory_part_cost_level := Validate_SYS.Is_Changed(oldrec_.inventory_part_cost_level, newrec_.inventory_part_cost_level);
   indrec_.ext_service_cost_method := Validate_SYS.Is_Changed(oldrec_.ext_service_cost_method, newrec_.ext_service_cost_method);
   indrec_.supply_chain_part_group := Validate_SYS.Is_Changed(oldrec_.supply_chain_part_group, newrec_.supply_chain_part_group);
   indrec_.automatic_capability_check := Validate_SYS.Is_Changed(oldrec_.automatic_capability_check, newrec_.automatic_capability_check);
   indrec_.input_unit_meas_group_id := Validate_SYS.Is_Changed(oldrec_.input_unit_meas_group_id, newrec_.input_unit_meas_group_id);
   indrec_.dop_netting := Validate_SYS.Is_Changed(oldrec_.dop_netting, newrec_.dop_netting);
   indrec_.co_reserve_onh_analys_flag := Validate_SYS.Is_Changed(oldrec_.co_reserve_onh_analys_flag, newrec_.co_reserve_onh_analys_flag);
   indrec_.qty_calc_rounding := Validate_SYS.Is_Changed(oldrec_.qty_calc_rounding, newrec_.qty_calc_rounding);
   indrec_.lifecycle_stage := Validate_SYS.Is_Changed(oldrec_.lifecycle_stage, newrec_.lifecycle_stage);
   indrec_.life_stage_locked_until := Validate_SYS.Is_Changed(oldrec_.life_stage_locked_until, newrec_.life_stage_locked_until);
   indrec_.frequency_class := Validate_SYS.Is_Changed(oldrec_.frequency_class, newrec_.frequency_class);
   indrec_.freq_class_locked_until := Validate_SYS.Is_Changed(oldrec_.freq_class_locked_until, newrec_.freq_class_locked_until);
   indrec_.first_stat_issue_date := Validate_SYS.Is_Changed(oldrec_.first_stat_issue_date, newrec_.first_stat_issue_date);
   indrec_.latest_stat_issue_date := Validate_SYS.Is_Changed(oldrec_.latest_stat_issue_date, newrec_.latest_stat_issue_date);
   indrec_.decline_date := Validate_SYS.Is_Changed(oldrec_.decline_date, newrec_.decline_date);
   indrec_.expired_date := Validate_SYS.Is_Changed(oldrec_.expired_date, newrec_.expired_date);
   indrec_.decline_issue_counter := Validate_SYS.Is_Changed(oldrec_.decline_issue_counter, newrec_.decline_issue_counter);
   indrec_.expired_issue_counter := Validate_SYS.Is_Changed(oldrec_.expired_issue_counter, newrec_.expired_issue_counter);
   indrec_.min_durab_days_co_deliv := Validate_SYS.Is_Changed(oldrec_.min_durab_days_co_deliv, newrec_.min_durab_days_co_deliv);
   indrec_.min_durab_days_planning := Validate_SYS.Is_Changed(oldrec_.min_durab_days_planning, newrec_.min_durab_days_planning);
   indrec_.storage_width_requirement := Validate_SYS.Is_Changed(oldrec_.storage_width_requirement, newrec_.storage_width_requirement);
   indrec_.storage_height_requirement := Validate_SYS.Is_Changed(oldrec_.storage_height_requirement, newrec_.storage_height_requirement);
   indrec_.storage_depth_requirement := Validate_SYS.Is_Changed(oldrec_.storage_depth_requirement, newrec_.storage_depth_requirement);
   indrec_.storage_volume_requirement := Validate_SYS.Is_Changed(oldrec_.storage_volume_requirement, newrec_.storage_volume_requirement);
   indrec_.storage_weight_requirement := Validate_SYS.Is_Changed(oldrec_.storage_weight_requirement, newrec_.storage_weight_requirement);
   indrec_.min_storage_temperature := Validate_SYS.Is_Changed(oldrec_.min_storage_temperature, newrec_.min_storage_temperature);
   indrec_.max_storage_temperature := Validate_SYS.Is_Changed(oldrec_.max_storage_temperature, newrec_.max_storage_temperature);
   indrec_.min_storage_humidity := Validate_SYS.Is_Changed(oldrec_.min_storage_humidity, newrec_.min_storage_humidity);
   indrec_.max_storage_humidity := Validate_SYS.Is_Changed(oldrec_.max_storage_humidity, newrec_.max_storage_humidity);
   indrec_.standard_putaway_qty := Validate_SYS.Is_Changed(oldrec_.standard_putaway_qty, newrec_.standard_putaway_qty);
   indrec_.putaway_zone_refill_option := Validate_SYS.Is_Changed(oldrec_.putaway_zone_refill_option, newrec_.putaway_zone_refill_option);
   indrec_.reset_config_std_cost := Validate_SYS.Is_Changed(oldrec_.reset_config_std_cost, newrec_.reset_config_std_cost);
   indrec_.mandatory_expiration_date := Validate_SYS.Is_Changed(oldrec_.mandatory_expiration_date, newrec_.mandatory_expiration_date);
   indrec_.excl_ship_pack_proposal := Validate_SYS.Is_Changed(oldrec_.excl_ship_pack_proposal, newrec_.excl_ship_pack_proposal);
   indrec_.statistical_code := Validate_SYS.Is_Changed(oldrec_.statistical_code, newrec_.statistical_code);
   indrec_.acquisition_origin := Validate_SYS.Is_Changed(oldrec_.acquisition_origin, newrec_.acquisition_origin);
   indrec_.acquisition_reason_id := Validate_SYS.Is_Changed(oldrec_.acquisition_reason_id, newrec_.acquisition_reason_id);
   RETURN indrec_;
END Get_Indicator_Rec___;


-- Check_Common___
--   Perform validations on a record, that should be done for both insert and delete.
PROCEDURE Check_Common___ (
   oldrec_ IN     inventory_part_tab%ROWTYPE,
   newrec_ IN OUT inventory_part_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF (newrec_.region_of_origin IS NOT NULL
       AND indrec_.region_of_origin
       AND Validate_SYS.Is_Changed(oldrec_.region_of_origin, newrec_.region_of_origin)) THEN
      Error_SYS.Check_Upper(lu_name_, 'REGION_OF_ORIGIN', newrec_.region_of_origin);
   END IF;
   IF (newrec_.cycle_code IS NOT NULL)
   AND (indrec_.cycle_code)
   AND (Validate_SYS.Is_Changed(oldrec_.cycle_code, newrec_.cycle_code)) THEN
      Inventory_Part_Count_Type_API.Exist_Db(newrec_.cycle_code);
   END IF;
   IF (newrec_.lead_time_code IS NOT NULL)
   AND (indrec_.lead_time_code)
   AND (Validate_SYS.Is_Changed(oldrec_.lead_time_code, newrec_.lead_time_code)) THEN
      Inv_Part_Lead_Time_Code_API.Exist_Db(newrec_.lead_time_code);
   END IF;
   IF (newrec_.oe_alloc_assign_flag IS NOT NULL)
   AND (indrec_.oe_alloc_assign_flag)
   AND (Validate_SYS.Is_Changed(oldrec_.oe_alloc_assign_flag, newrec_.oe_alloc_assign_flag)) THEN
      Cust_Ord_Reservation_Type_API.Exist_Db(newrec_.oe_alloc_assign_flag);
   END IF;
   IF (newrec_.onhand_analysis_flag IS NOT NULL)
   AND (indrec_.onhand_analysis_flag)
   AND (Validate_SYS.Is_Changed(oldrec_.onhand_analysis_flag, newrec_.onhand_analysis_flag)) THEN
      Inventory_Part_Onh_Analys_API.Exist_Db(newrec_.onhand_analysis_flag);
   END IF;
   IF (newrec_.supply_code IS NOT NULL)
   AND (indrec_.supply_code)
   AND (Validate_SYS.Is_Changed(oldrec_.supply_code, newrec_.supply_code)) THEN
      Material_Requis_Supply_API.Exist_Subset1_Db(newrec_.supply_code);
   END IF;
   IF (newrec_.type_code IS NOT NULL)
   AND (indrec_.type_code)
   AND (Validate_SYS.Is_Changed(oldrec_.type_code, newrec_.type_code)) THEN
      Inventory_Part_Type_API.Exist_Db(newrec_.type_code);
   END IF;
   IF (newrec_.zero_cost_flag IS NOT NULL)
   AND (indrec_.zero_cost_flag)
   AND (Validate_SYS.Is_Changed(oldrec_.zero_cost_flag, newrec_.zero_cost_flag)) THEN
      Inventory_Part_Zero_Cost_API.Exist_Db(newrec_.zero_cost_flag);
   END IF;
   IF (newrec_.avail_activity_status IS NOT NULL)
   AND (indrec_.avail_activity_status)
   AND (Validate_SYS.Is_Changed(oldrec_.avail_activity_status, newrec_.avail_activity_status)) THEN
      Inventory_Part_Avail_Stat_API.Exist_Db(newrec_.avail_activity_status);
   END IF;
   IF (newrec_.shortage_flag IS NOT NULL)
   AND (indrec_.shortage_flag)
   AND (Validate_SYS.Is_Changed(oldrec_.shortage_flag, newrec_.shortage_flag)) THEN
      Inventory_Part_Shortage_API.Exist_Db(newrec_.shortage_flag);
   END IF;
   IF (newrec_.forecast_consumption_flag IS NOT NULL)
   AND (indrec_.forecast_consumption_flag)
   AND (Validate_SYS.Is_Changed(oldrec_.forecast_consumption_flag, newrec_.forecast_consumption_flag)) THEN
      Inv_Part_Forecast_Consum_API.Exist_Db(newrec_.forecast_consumption_flag);
   END IF;
   IF (newrec_.stock_management IS NOT NULL)
   AND (indrec_.stock_management)
   AND (Validate_SYS.Is_Changed(oldrec_.stock_management, newrec_.stock_management)) THEN
      Inventory_Part_Management_API.Exist_Db(newrec_.stock_management);
   END IF;
   IF (newrec_.dop_connection IS NOT NULL)
   AND (indrec_.dop_connection)
   AND (Validate_SYS.Is_Changed(oldrec_.dop_connection, newrec_.dop_connection)) THEN
      Dop_Connection_API.Exist_Db(newrec_.dop_connection);
   END IF;
   IF (newrec_.inventory_valuation_method IS NOT NULL)
   AND (indrec_.inventory_valuation_method)
   AND (Validate_SYS.Is_Changed(oldrec_.inventory_valuation_method, newrec_.inventory_valuation_method)) THEN
      Inventory_Value_Method_API.Exist_Db(newrec_.inventory_valuation_method);
   END IF;
   IF (newrec_.negative_on_hand IS NOT NULL)
   AND (indrec_.negative_on_hand)
   AND (Validate_SYS.Is_Changed(oldrec_.negative_on_hand, newrec_.negative_on_hand)) THEN
      Negative_On_Hand_API.Exist_Db(newrec_.negative_on_hand);
   END IF;
   IF (newrec_.invoice_consideration IS NOT NULL)
   AND (indrec_.invoice_consideration)
   AND (Validate_SYS.Is_Changed(oldrec_.invoice_consideration, newrec_.invoice_consideration)) THEN
      Invoice_Consideration_API.Exist_Db(newrec_.invoice_consideration);
   END IF;
   IF (newrec_.inventory_part_cost_level IS NOT NULL)
   AND (indrec_.inventory_part_cost_level)
   AND (Validate_SYS.Is_Changed(oldrec_.inventory_part_cost_level, newrec_.inventory_part_cost_level)) THEN
      Inventory_Part_Cost_Level_API.Exist_Db(newrec_.inventory_part_cost_level);
   END IF;
   IF (newrec_.ext_service_cost_method IS NOT NULL)
   AND (indrec_.ext_service_cost_method)
   AND (Validate_SYS.Is_Changed(oldrec_.ext_service_cost_method, newrec_.ext_service_cost_method)) THEN
      Ext_Service_Cost_Method_API.Exist_Db(newrec_.ext_service_cost_method);
   END IF;
   IF (newrec_.automatic_capability_check IS NOT NULL)
   AND (indrec_.automatic_capability_check)
   AND (Validate_SYS.Is_Changed(oldrec_.automatic_capability_check, newrec_.automatic_capability_check)) THEN
      Capability_Check_Allocate_API.Exist_Db(newrec_.automatic_capability_check);
   END IF;
   IF (newrec_.dop_netting IS NOT NULL)
   AND (indrec_.dop_netting)
   AND (Validate_SYS.Is_Changed(oldrec_.dop_netting, newrec_.dop_netting)) THEN
      Dop_Netting_API.Exist_Db(newrec_.dop_netting);
   END IF;
   IF (newrec_.co_reserve_onh_analys_flag IS NOT NULL)
   AND (indrec_.co_reserve_onh_analys_flag)
   AND (Validate_SYS.Is_Changed(oldrec_.co_reserve_onh_analys_flag, newrec_.co_reserve_onh_analys_flag)) THEN
      Inventory_Part_Onh_Analys_API.Exist_Db(newrec_.co_reserve_onh_analys_flag);
   END IF;
   IF (newrec_.lifecycle_stage IS NOT NULL)
   AND (indrec_.lifecycle_stage)
   AND (Validate_SYS.Is_Changed(oldrec_.lifecycle_stage, newrec_.lifecycle_stage)) THEN
      Inv_Part_Lifecycle_Stage_API.Exist_Db(newrec_.lifecycle_stage);
   END IF;
   IF (newrec_.frequency_class IS NOT NULL)
   AND (indrec_.frequency_class)
   AND (Validate_SYS.Is_Changed(oldrec_.frequency_class, newrec_.frequency_class)) THEN
      Inv_Part_Frequency_Class_API.Exist_Db(newrec_.frequency_class);
   END IF;
   IF (newrec_.putaway_zone_refill_option IS NOT NULL)
   AND (indrec_.putaway_zone_refill_option)
   AND (Validate_SYS.Is_Changed(oldrec_.putaway_zone_refill_option, newrec_.putaway_zone_refill_option)) THEN
      Putaway_Zone_Refill_Option_API.Exist_Db(newrec_.putaway_zone_refill_option);
   END IF;
   IF (newrec_.reset_config_std_cost IS NOT NULL)
   AND (indrec_.reset_config_std_cost)
   AND (Validate_SYS.Is_Changed(oldrec_.reset_config_std_cost, newrec_.reset_config_std_cost)) THEN
      Fnd_Boolean_API.Exist_Db(newrec_.reset_config_std_cost);
   END IF;
   IF (newrec_.mandatory_expiration_date IS NOT NULL)
   AND (indrec_.mandatory_expiration_date)
   AND (Validate_SYS.Is_Changed(oldrec_.mandatory_expiration_date, newrec_.mandatory_expiration_date)) THEN
      Fnd_Boolean_API.Exist_Db(newrec_.mandatory_expiration_date);
   END IF;
   IF (newrec_.excl_ship_pack_proposal IS NOT NULL)
   AND (indrec_.excl_ship_pack_proposal)
   AND (Validate_SYS.Is_Changed(oldrec_.excl_ship_pack_proposal, newrec_.excl_ship_pack_proposal)) THEN
      Fnd_Boolean_API.Exist_Db(newrec_.excl_ship_pack_proposal);
   END IF;
   IF (newrec_.contract IS NOT NULL)
   AND (indrec_.contract)
   AND (Validate_SYS.Is_Changed(oldrec_.contract, newrec_.contract)) THEN
      Site_API.Exist(newrec_.contract);
   END IF;
   IF (newrec_.part_no IS NOT NULL)
   AND (indrec_.part_no)
   AND (Validate_SYS.Is_Changed(oldrec_.part_no, newrec_.part_no)) THEN
      Part_Catalog_API.Exist(newrec_.part_no);
   END IF;
   IF (newrec_.accounting_group IS NOT NULL)
   AND (indrec_.accounting_group)
   AND (Validate_SYS.Is_Changed(oldrec_.accounting_group, newrec_.accounting_group)) THEN
      Accounting_Group_API.Exist(newrec_.accounting_group);
   END IF;
   IF (newrec_.asset_class IS NOT NULL)
   AND (indrec_.asset_class)
   AND (Validate_SYS.Is_Changed(oldrec_.asset_class, newrec_.asset_class)) THEN
      Asset_Class_API.Exist(newrec_.asset_class);
   END IF;
   IF (newrec_.country_of_origin IS NOT NULL)
   AND (indrec_.country_of_origin)
   AND (Validate_SYS.Is_Changed(oldrec_.country_of_origin, newrec_.country_of_origin)) THEN
      Iso_Country_API.Exist(newrec_.country_of_origin);
   END IF;
   IF (newrec_.hazard_code IS NOT NULL)
   AND (indrec_.hazard_code)
   AND (Validate_SYS.Is_Changed(oldrec_.hazard_code, newrec_.hazard_code)) THEN
      Safety_Instruction_API.Exist(newrec_.hazard_code);
   END IF;
   IF (newrec_.part_product_code IS NOT NULL)
   AND (indrec_.part_product_code)
   AND (Validate_SYS.Is_Changed(oldrec_.part_product_code, newrec_.part_product_code)) THEN
      Inventory_Product_Code_API.Exist(newrec_.part_product_code);
   END IF;
   IF (newrec_.part_product_family IS NOT NULL)
   AND (indrec_.part_product_family)
   AND (Validate_SYS.Is_Changed(oldrec_.part_product_family, newrec_.part_product_family)) THEN
      Inventory_Product_Family_API.Exist(newrec_.part_product_family);
   END IF;
   IF (newrec_.part_status IS NOT NULL)
   AND (indrec_.part_status)
   AND (Validate_SYS.Is_Changed(oldrec_.part_status, newrec_.part_status)) THEN
      Inventory_Part_Status_Par_API.Exist(newrec_.part_status);
   END IF;
   IF (newrec_.planner_buyer IS NOT NULL)
   AND (indrec_.planner_buyer)
   AND (Validate_SYS.Is_Changed(oldrec_.planner_buyer, newrec_.planner_buyer)) THEN
      Inventory_Part_Planner_API.Exist(newrec_.planner_buyer);
   END IF;
   IF (newrec_.prime_commodity IS NOT NULL)
   AND (indrec_.prime_commodity)
   AND (Validate_SYS.Is_Changed(oldrec_.prime_commodity, newrec_.prime_commodity)) THEN
      Commodity_Group_API.Exist(newrec_.prime_commodity);
   END IF;
   IF (newrec_.second_commodity IS NOT NULL)
   AND (indrec_.second_commodity)
   AND (Validate_SYS.Is_Changed(oldrec_.second_commodity, newrec_.second_commodity)) THEN
      Commodity_Group_API.Exist(newrec_.second_commodity);
   END IF;
   IF (newrec_.unit_meas IS NOT NULL)
   AND (indrec_.unit_meas)
   AND (Validate_SYS.Is_Changed(oldrec_.unit_meas, newrec_.unit_meas)) THEN
      Iso_Unit_API.Exist(newrec_.unit_meas);
   END IF;
   IF (newrec_.catch_unit_meas IS NOT NULL)
   AND (indrec_.catch_unit_meas)
   AND (Validate_SYS.Is_Changed(oldrec_.catch_unit_meas, newrec_.catch_unit_meas)) THEN
      Iso_Unit_API.Exist(newrec_.catch_unit_meas);
   END IF;
   IF (newrec_.abc_class IS NOT NULL)
   AND (indrec_.abc_class)
   AND (Validate_SYS.Is_Changed(oldrec_.abc_class, newrec_.abc_class)) THEN
      Abc_Class_API.Exist(newrec_.abc_class);
   END IF;
   IF (newrec_.customs_stat_no IS NOT NULL)
   AND (indrec_.customs_stat_no)
   AND (Validate_SYS.Is_Changed(oldrec_.customs_stat_no, newrec_.customs_stat_no)) THEN
      Customs_Statistics_Number_API.Exist(newrec_.customs_stat_no);
   END IF;
   IF (newrec_.eng_attribute IS NOT NULL)
   AND (indrec_.eng_attribute)
   AND (Validate_SYS.Is_Changed(oldrec_.eng_attribute, newrec_.eng_attribute)) THEN
      Characteristic_Template_API.Exist(newrec_.eng_attribute);
   END IF;
   IF (newrec_.std_name_id IS NOT NULL)
   AND (indrec_.std_name_id)
   AND (Validate_SYS.Is_Changed(oldrec_.std_name_id, newrec_.std_name_id)) THEN
      Standard_Names_API.Exist(newrec_.std_name_id);
   END IF;
   IF (newrec_.technical_coordinator_id IS NOT NULL)
   AND (indrec_.technical_coordinator_id)
   AND (Validate_SYS.Is_Changed(oldrec_.technical_coordinator_id, newrec_.technical_coordinator_id)) THEN
      Technical_Coordinator_API.Exist(newrec_.technical_coordinator_id);
   END IF;
   IF (newrec_.cust_warranty_id IS NOT NULL)
   AND (indrec_.cust_warranty_id)
   AND (Validate_SYS.Is_Changed(oldrec_.cust_warranty_id, newrec_.cust_warranty_id)) THEN
      Cust_Warranty_API.Exist(newrec_.cust_warranty_id);
   END IF;
   IF (newrec_.supply_chain_part_group IS NOT NULL)
   AND (indrec_.supply_chain_part_group)
   AND (Validate_SYS.Is_Changed(oldrec_.supply_chain_part_group, newrec_.supply_chain_part_group)) THEN
      Supply_Chain_Part_Group_API.Exist(newrec_.supply_chain_part_group);
   END IF;
   IF (newrec_.input_unit_meas_group_id IS NOT NULL)
   AND (indrec_.input_unit_meas_group_id)
   AND (Validate_SYS.Is_Changed(oldrec_.input_unit_meas_group_id, newrec_.input_unit_meas_group_id)) THEN
      Input_Unit_Meas_Group_API.Exist(newrec_.input_unit_meas_group_id);
   END IF;
   IF (Site_API.Get_Company(newrec_.contract) IS NOT NULL AND newrec_.statistical_code IS NOT NULL)
   AND (indrec_.contract OR indrec_.statistical_code)
   AND (Validate_SYS.Is_Changed(Site_API.Get_Company(oldrec_.contract), Site_API.Get_Company(newrec_.contract))
     OR Validate_SYS.Is_Changed(oldrec_.statistical_code, newrec_.statistical_code)) THEN
      Statistical_Code_API.Exist(Site_API.Get_Company(newrec_.contract), newrec_.statistical_code);
   END IF;
   IF (Site_API.Get_Company(newrec_.contract) IS NOT NULL AND newrec_.acquisition_origin IS NOT NULL)
   AND (indrec_.contract OR indrec_.acquisition_origin)
   AND (Validate_SYS.Is_Changed(Site_API.Get_Company(oldrec_.contract), Site_API.Get_Company(newrec_.contract))
     OR Validate_SYS.Is_Changed(oldrec_.acquisition_origin, newrec_.acquisition_origin)) THEN
      Acquisition_Origin_API.Exist(Site_API.Get_Company(newrec_.contract), newrec_.acquisition_origin);
   END IF;
   IF (Site_API.Get_Company(newrec_.contract) IS NOT NULL AND newrec_.acquisition_reason_id IS NOT NULL)
   AND (indrec_.contract OR indrec_.acquisition_reason_id)
   AND (Validate_SYS.Is_Changed(Site_API.Get_Company(oldrec_.contract), Site_API.Get_Company(newrec_.contract))
     OR Validate_SYS.Is_Changed(oldrec_.acquisition_reason_id, newrec_.acquisition_reason_id)) THEN
      Acquisition_Reason_API.Exist(Site_API.Get_Company(newrec_.contract), newrec_.acquisition_reason_id);
   END IF;
   Error_SYS.Check_Not_Null(lu_name_, 'CONTRACT', newrec_.contract);
   Error_SYS.Check_Not_Null(lu_name_, 'PART_NO', newrec_.part_no);
   Error_SYS.Check_Not_Null(lu_name_, 'ASSET_CLASS', newrec_.asset_class);
   Error_SYS.Check_Not_Null(lu_name_, 'PART_STATUS', newrec_.part_status);
   Error_SYS.Check_Not_Null(lu_name_, 'PLANNER_BUYER', newrec_.planner_buyer);
   Error_SYS.Check_Not_Null(lu_name_, 'UNIT_MEAS', newrec_.unit_meas);
   Error_SYS.Check_Not_Null(lu_name_, 'DESCRIPTION', newrec_.description);
   Error_SYS.Check_Not_Null(lu_name_, 'COUNT_VARIANCE', newrec_.count_variance);
   Error_SYS.Check_Not_Null(lu_name_, 'CYCLE_CODE', newrec_.cycle_code);
   Error_SYS.Check_Not_Null(lu_name_, 'CYCLE_PERIOD', newrec_.cycle_period);
   Error_SYS.Check_Not_Null(lu_name_, 'EXPECTED_LEADTIME', newrec_.expected_leadtime);
   Error_SYS.Check_Not_Null(lu_name_, 'LEAD_TIME_CODE', newrec_.lead_time_code);
   Error_SYS.Check_Not_Null(lu_name_, 'MANUF_LEADTIME', newrec_.manuf_leadtime);
   Error_SYS.Check_Not_Null(lu_name_, 'OE_ALLOC_ASSIGN_FLAG', newrec_.oe_alloc_assign_flag);
   Error_SYS.Check_Not_Null(lu_name_, 'ONHAND_ANALYSIS_FLAG', newrec_.onhand_analysis_flag);
   Error_SYS.Check_Not_Null(lu_name_, 'PURCH_LEADTIME', newrec_.purch_leadtime);
   Error_SYS.Check_Not_Null(lu_name_, 'SUPPLY_CODE', newrec_.supply_code);
   Error_SYS.Check_Not_Null(lu_name_, 'TYPE_CODE', newrec_.type_code);
   Error_SYS.Check_Not_Null(lu_name_, 'ZERO_COST_FLAG', newrec_.zero_cost_flag);
   Error_SYS.Check_Not_Null(lu_name_, 'AVAIL_ACTIVITY_STATUS', newrec_.avail_activity_status);
   Error_SYS.Check_Not_Null(lu_name_, 'SHORTAGE_FLAG', newrec_.shortage_flag);
   Error_SYS.Check_Not_Null(lu_name_, 'FORECAST_CONSUMPTION_FLAG', newrec_.forecast_consumption_flag);
   Error_SYS.Check_Not_Null(lu_name_, 'STOCK_MANAGEMENT', newrec_.stock_management);
   Error_SYS.Check_Not_Null(lu_name_, 'DOP_CONNECTION', newrec_.dop_connection);
   Error_SYS.Check_Not_Null(lu_name_, 'INVENTORY_VALUATION_METHOD', newrec_.inventory_valuation_method);
   Error_SYS.Check_Not_Null(lu_name_, 'NEGATIVE_ON_HAND', newrec_.negative_on_hand);
   Error_SYS.Check_Not_Null(lu_name_, 'INVOICE_CONSIDERATION', newrec_.invoice_consideration);
   Error_SYS.Check_Not_Null(lu_name_, 'INVENTORY_PART_COST_LEVEL', newrec_.inventory_part_cost_level);
   Error_SYS.Check_Not_Null(lu_name_, 'EXT_SERVICE_COST_METHOD', newrec_.ext_service_cost_method);
   Error_SYS.Check_Not_Null(lu_name_, 'AUTOMATIC_CAPABILITY_CHECK', newrec_.automatic_capability_check);
   Error_SYS.Check_Not_Null(lu_name_, 'DOP_NETTING', newrec_.dop_netting);
   Error_SYS.Check_Not_Null(lu_name_, 'CO_RESERVE_ONH_ANALYS_FLAG', newrec_.co_reserve_onh_analys_flag);
   Error_SYS.Check_Not_Null(lu_name_, 'QTY_CALC_ROUNDING', newrec_.qty_calc_rounding);
   Error_SYS.Check_Not_Null(lu_name_, 'MIN_DURAB_DAYS_CO_DELIV', newrec_.min_durab_days_co_deliv);
   Error_SYS.Check_Not_Null(lu_name_, 'MIN_DURAB_DAYS_PLANNING', newrec_.min_durab_days_planning);
   Error_SYS.Check_Not_Null(lu_name_, 'RESET_CONFIG_STD_COST', newrec_.reset_config_std_cost);
   Error_SYS.Check_Not_Null(lu_name_, 'MANDATORY_EXPIRATION_DATE', newrec_.mandatory_expiration_date);
   Error_SYS.Check_Not_Null(lu_name_, 'EXCL_SHIP_PACK_PROPOSAL', newrec_.excl_ship_pack_proposal);
END Check_Common___;


-- Prepare_Insert___
--   Set client default values into an attribute string.
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   Client_SYS.Clear_Attr(attr_);
END Prepare_Insert___;


-- Check_Insert___
--   Perform validations on a new record before it is insert.
PROCEDURE Check_Insert___ (
   newrec_ IN OUT inventory_part_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   oldrec_ inventory_part_tab%ROWTYPE;
BEGIN
   Validate_SYS.Item_Insert(lu_name_, 'COUNT_VARIANCE', indrec_.count_variance);
   Validate_SYS.Item_Insert(lu_name_, 'CREATE_DATE', indrec_.create_date);
   Validate_SYS.Item_Insert(lu_name_, 'LAST_ACTIVITY_DATE', indrec_.last_activity_date);
   Validate_SYS.Item_Insert(lu_name_, 'EARLIEST_ULTD_SUPPLY_DATE', indrec_.earliest_ultd_supply_date);
   Validate_SYS.Item_Insert(lu_name_, 'FIRST_STAT_ISSUE_DATE', indrec_.first_stat_issue_date);
   Validate_SYS.Item_Insert(lu_name_, 'LATEST_STAT_ISSUE_DATE', indrec_.latest_stat_issue_date);
   Validate_SYS.Item_Insert(lu_name_, 'DECLINE_DATE', indrec_.decline_date);
   Validate_SYS.Item_Insert(lu_name_, 'EXPIRED_DATE', indrec_.expired_date);
   Validate_SYS.Item_Insert(lu_name_, 'DECLINE_ISSUE_COUNTER', indrec_.decline_issue_counter);
   Validate_SYS.Item_Insert(lu_name_, 'EXPIRED_ISSUE_COUNTER', indrec_.expired_issue_counter);
   Check_Common___(oldrec_, newrec_, indrec_, attr_);
END Check_Insert___;


-- Insert___
--   Insert a record to the database.
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT inventory_part_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   value_too_large  EXCEPTION;
   PRAGMA           EXCEPTION_INIT(value_too_large, -12899);
BEGIN
   newrec_.rowversion := sysdate;
   newrec_.rowkey := sys_guid();
   Client_SYS.Add_To_Attr('OBJKEY', newrec_.rowkey, attr_);
   INSERT
      INTO inventory_part_tab
      VALUES newrec_
      RETURNING rowid INTO objid_;
   objversion_ := to_char(newrec_.rowversion,'YYYYMMDDHH24MISS');
EXCEPTION
   WHEN dup_val_on_index THEN
      DECLARE
         constraint_ VARCHAR2(4000) := Utility_SYS.Get_Constraint_From_Error_Msg(sqlerrm);
      BEGIN
         IF (constraint_ = 'INVENTORY_PART_RK') THEN
            Error_SYS.Fnd_Rowkey_Exist(lu_name_, newrec_.rowkey);
         ELSIF (constraint_ = 'INVENTORY_PART_PK') THEN
            Raise_Record_Exist___(newrec_);
         ELSE
            Raise_Constraint_Violated___(newrec_, constraint_);
         END IF;
      END;
   WHEN value_too_large THEN
      Error_SYS.Fnd_Item_Length(lu_name_, sqlerrm);
END Insert___;


-- Prepare_New___
--    Set default values for a table record.
PROCEDURE Prepare_New___ (
   newrec_ IN OUT inventory_part_tab%ROWTYPE )
IS
   attr_    VARCHAR2(32000);
   indrec_  Indicator_Rec;
BEGIN
   attr_ := Pack___(newrec_);
   Prepare_Insert___(attr_);
   Unpack___(newrec_, indrec_, attr_);
END Prepare_New___;


-- New___
--    Checks and creates a new record.
PROCEDURE New___ (
   newrec_ IN OUT inventory_part_tab%ROWTYPE )
IS
   objid_         VARCHAR2(20);
   objversion_    VARCHAR2(100);
   attr_          VARCHAR2(32000);
   indrec_        Indicator_Rec;
BEGIN
   indrec_ := Get_Indicator_Rec___(newrec_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);
END New___;


-- Check_Update___
--   Perform validations on a new record before it is updated.
PROCEDURE Check_Update___ (
   oldrec_ IN     inventory_part_tab%ROWTYPE,
   newrec_ IN OUT inventory_part_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   Validate_SYS.Item_Update(lu_name_, 'CONTRACT', indrec_.contract);
   Validate_SYS.Item_Update(lu_name_, 'PART_NO', indrec_.part_no);
   Validate_SYS.Item_Update(lu_name_, 'NOTE_ID', indrec_.note_id);
   Validate_SYS.Item_Update(lu_name_, 'UNIT_MEAS', indrec_.unit_meas);
   Validate_SYS.Item_Update(lu_name_, 'CREATE_DATE', indrec_.create_date);
   Validate_SYS.Item_Update(lu_name_, 'LAST_ACTIVITY_DATE', indrec_.last_activity_date);
   Check_Common___(oldrec_, newrec_, indrec_, attr_);
END Check_Update___;


-- Update___
--   Update a record in database with new data.
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     inventory_part_tab%ROWTYPE,
   newrec_     IN OUT inventory_part_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   value_too_large  EXCEPTION;
   PRAGMA           EXCEPTION_INIT(value_too_large, -12899);
BEGIN
   newrec_.rowversion := sysdate;
   IF by_keys_ THEN
      UPDATE inventory_part_tab
         SET ROW = newrec_
         WHERE contract = newrec_.contract
         AND   part_no = newrec_.part_no;
   ELSE
      UPDATE inventory_part_tab
         SET ROW = newrec_
         WHERE rowid = objid_;
   END IF;
   objversion_ := to_char(newrec_.rowversion,'YYYYMMDDHH24MISS');
   Invalidate_Cache___;
EXCEPTION
   WHEN dup_val_on_index THEN
      DECLARE
         constraint_ VARCHAR2(4000) := Utility_SYS.Get_Constraint_From_Error_Msg(sqlerrm);
      BEGIN
         IF (constraint_ = 'INVENTORY_PART_RK') THEN
            Error_SYS.Fnd_Rowkey_Exist(Inventory_Part_API.lu_name_, newrec_.rowkey);
         ELSIF (constraint_ = 'INVENTORY_PART_PK') THEN
            Raise_Record_Exist___(newrec_);
         ELSE
            Raise_Constraint_Violated___(newrec_, constraint_);
         END IF;
      END;
   WHEN value_too_large THEN
      Error_SYS.Fnd_Item_Length(lu_name_, sqlerrm);
END Update___;


-- Modify___
--    Modifies an existing instance of the logical unit.
PROCEDURE Modify___ (
   newrec_         IN OUT inventory_part_tab%ROWTYPE,
   lock_mode_wait_ IN     BOOLEAN DEFAULT TRUE )
IS
   objid_      VARCHAR2(20);
   objversion_ VARCHAR2(100);
   attr_       VARCHAR2(32000);
   indrec_     Indicator_rec;
   oldrec_     inventory_part_tab%ROWTYPE;
BEGIN
   IF (lock_mode_wait_) THEN
      oldrec_ := Lock_By_Keys___(newrec_.contract, newrec_.part_no);
   ELSE
      oldrec_ := Lock_By_Keys_Nowait___(newrec_.contract, newrec_.part_no);
   END IF;
   indrec_ := Get_Indicator_Rec___(oldrec_, newrec_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
END Modify___;


-- Check_Delete___
--   Perform validations on a new record before it is deleted.
PROCEDURE Check_Delete___ (
   remrec_ IN inventory_part_tab%ROWTYPE )
IS
   key_ VARCHAR2(2000);
BEGIN
   key_ := remrec_.contract||'^'||remrec_.part_no||'^';
   Reference_SYS.Check_Restricted_Delete(lu_name_, key_);
END Check_Delete___;


-- Delete___
--   Delete a record from the database.
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN inventory_part_tab%ROWTYPE )
IS
   key_ VARCHAR2(2000);
BEGIN
   key_ := remrec_.contract||'^'||remrec_.part_no||'^';
   Reference_SYS.Do_Cascade_Delete(lu_name_, key_);
   IF (objid_ IS NOT NULL) THEN
      DELETE
         FROM  inventory_part_tab
         WHERE rowid = objid_;
   ELSE
      DELETE
         FROM  inventory_part_tab
         WHERE contract = remrec_.contract
         AND   part_no = remrec_.part_no;
   END IF;
   Invalidate_Cache___;
END Delete___;


-- Delete___
--   Delete a record from the database.
@Deprecated
PROCEDURE Delete___ (
   remrec_ IN inventory_part_tab%ROWTYPE )
IS
BEGIN
   Delete___(NULL, remrec_);
END Delete___;


-- Remove___
--    Removes an existing instance of the logical unit.
PROCEDURE Remove___ (
   remrec_         IN OUT inventory_part_tab%ROWTYPE,
   lock_mode_wait_ IN     BOOLEAN DEFAULT TRUE )
IS
   oldrec_     inventory_part_tab%ROWTYPE;
BEGIN
   IF (lock_mode_wait_) THEN
      oldrec_ := Lock_By_Keys___(remrec_.contract, remrec_.part_no);
   ELSE
      oldrec_ := Lock_By_Keys_Nowait___(remrec_.contract, remrec_.part_no);
   END IF;
   Check_Delete___(oldrec_);
   Delete___(NULL, oldrec_);
END Remove___;


-- Lock__
--    Client-support to lock a specific instance of the logical unit.
@UncheckedAccess
PROCEDURE Lock__ (
   info_       OUT VARCHAR2,
   objid_      IN  VARCHAR2,
   objversion_ IN  VARCHAR2 )
IS
   dummy_ inventory_part_tab%ROWTYPE;
BEGIN
   dummy_ := Lock_By_Id___(objid_, objversion_);
   info_ := Client_SYS.Get_All_Info;
END Lock__;


-- New__
--    Client-support interface to create LU instances.
--       action_ = 'PREPARE'
--          Default values and handle of information to client.
--          The default values are set in procedure Prepare_Insert___.
--       action_ = 'CHECK'
--          Check all attributes before creating new object and handle of
--          information to client. The attribute list is unpacked, checked
--          and prepared (defaults) in procedures Unpack___ and Check_Insert___.
--       action_ = 'DO'
--          Creation of new instances of the logical unit and handle of
--          information to client. The attribute list is unpacked, checked
--          and prepared (defaults) in procedures Unpack___ and Check_Insert___
--          before calling procedure Insert___.
PROCEDURE New__ (
   info_       OUT    VARCHAR2,
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   newrec_   inventory_part_tab%ROWTYPE;
   indrec_   Indicator_Rec;
BEGIN
   IF (action_ = 'PREPARE') THEN
      Prepare_Insert___(attr_);
   ELSIF (action_ = 'CHECK') THEN
      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
   ELSIF (action_ = 'DO') THEN
      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);
   END IF;
   info_ := Client_SYS.Get_All_Info;
END New__;


-- Modify__
--    Client-support interface to modify attributes for LU instances.
--       action_ = 'CHECK'
--          Check all attributes before modifying an existing object and
--          handle of information to client. The attribute list is unpacked,
--          checked and prepared(defaults) in procedures Unpack___ and Check_Update___.
--       action_ = 'DO'
--          Modification of an existing instance of the logical unit. The
--          procedure unpacks the attributes, checks all values before
--          procedure Update___ is called.
PROCEDURE Modify__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   oldrec_   inventory_part_tab%ROWTYPE;
   newrec_   inventory_part_tab%ROWTYPE;
   indrec_   Indicator_Rec;
BEGIN
   IF (action_ = 'CHECK') THEN
      oldrec_ := Get_Object_By_Id___(objid_);
      newrec_ := oldrec_;
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
   ELSIF (action_ = 'DO') THEN
      oldrec_ := Lock_By_Id___(objid_, objversion_);
      newrec_ := oldrec_;
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
      Update___(objid_, oldrec_, newrec_, attr_, objversion_);
   END IF;
   info_ := Client_SYS.Get_All_Info;
END Modify__;


-- Remove__
--    Client-support interface to remove LU instances.
--       action_ = 'CHECK'
--          Check whether a specific LU-instance may be removed or not.
--          The procedure fetches the complete record by calling procedure
--          Get_Object_By_Id___. Then the check is made by calling procedure
--          Check_Delete___.
--       action_ = 'DO'
--          Remove an existing instance of the logical unit. The procedure
--          fetches the complete LU-record, checks for a delete and then
--          deletes the record by calling procedure Delete___.
PROCEDURE Remove__ (
   info_       OUT VARCHAR2,
   objid_      IN  VARCHAR2,
   objversion_ IN  VARCHAR2,
   action_     IN  VARCHAR2 )
IS
   remrec_ inventory_part_tab%ROWTYPE;
BEGIN
   IF (action_ = 'CHECK') THEN
      remrec_ := Get_Object_By_Id___(objid_);
      Check_Delete___(remrec_);
   ELSIF (action_ = 'DO') THEN
      remrec_ := Lock_By_Id___(objid_, objversion_);
      Check_Delete___(remrec_);
      Delete___(objid_, remrec_);
   END IF;
   info_ := Client_SYS.Get_All_Info;
END Remove__;


-- Get_Key_By_Rowkey
--   Returns a table record with only keys (other attributes are NULL) based on a rowkey.
@UncheckedAccess
FUNCTION Get_Key_By_Rowkey (
   rowkey_ IN VARCHAR2 ) RETURN inventory_part_tab%ROWTYPE
IS
   rec_ inventory_part_tab%ROWTYPE;
BEGIN
   IF (rowkey_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT contract, part_no
      INTO  rec_.contract, rec_.part_no
      FROM  inventory_part_tab
      WHERE rowkey = rowkey_;
   RETURN rec_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN rec_;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(rec_.contract, rec_.part_no, 'Get_Key_By_Rowkey');
END Get_Key_By_Rowkey;


-- Exist
--   Checks if given pointer (e.g. primary key) to an instance of this
--   logical unit exists. If not an exception will be raised.
@UncheckedAccess
PROCEDURE Exist (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 )
IS
BEGIN
   IF (NOT Check_Exist___(contract_, part_no_)) THEN
      Raise_Record_Not_Exist___(contract_, part_no_);
   END IF;
END Exist;


-- Exists
--   Same check as Exist, but returns a BOOLEAN value instead of exception.
@UncheckedAccess
FUNCTION Exists (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN Check_Exist___(contract_, part_no_);
END Exists;

-- Rowkey_Exist
--   Checks whether the rowkey exists
--   If not an exception will be raised.
@UncheckedAccess
PROCEDURE Rowkey_Exist (
   rowkey_ IN VARCHAR2 )
IS
   contract_ inventory_part_tab.contract%TYPE;
   part_no_ inventory_part_tab.part_no%TYPE;
BEGIN
   IF (rowkey_ IS NULL) THEN
      RAISE no_data_found;
   END IF;
   SELECT contract, part_no
   INTO  contract_, part_no_
   FROM  inventory_part_tab
   WHERE rowkey = rowkey_;
EXCEPTION
   WHEN no_data_found THEN
      Raise_Record_Not_Exist___(contract_, part_no_);
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(contract_, part_no_, 'Rowkey_Exist___');
END Rowkey_Exist;


-- Get_Accounting_Group
--   Fetches the AccountingGroup attribute for a record.
@UncheckedAccess
FUNCTION Get_Accounting_Group (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(contract_, part_no_);
   RETURN micro_cache_value_.accounting_group;
END Get_Accounting_Group;


-- Get_Asset_Class
--   Fetches the AssetClass attribute for a record.
@UncheckedAccess
FUNCTION Get_Asset_Class (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(contract_, part_no_);
   RETURN micro_cache_value_.asset_class;
END Get_Asset_Class;


-- Get_Country_Of_Origin
--   Fetches the CountryOfOrigin attribute for a record.
@UncheckedAccess
FUNCTION Get_Country_Of_Origin (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ inventory_part_tab.country_of_origin%TYPE;
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT country_of_origin
      INTO  temp_
      FROM  inventory_part_tab
      WHERE contract = contract_
      AND   part_no = part_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(contract_, part_no_, 'Get_Country_Of_Origin');
END Get_Country_Of_Origin;


-- Get_Hazard_Code
--   Fetches the HazardCode attribute for a record.
@UncheckedAccess
FUNCTION Get_Hazard_Code (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ inventory_part_tab.hazard_code%TYPE;
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT hazard_code
      INTO  temp_
      FROM  inventory_part_tab
      WHERE contract = contract_
      AND   part_no = part_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(contract_, part_no_, 'Get_Hazard_Code');
END Get_Hazard_Code;


-- Get_Note_Id
--   Fetches the NoteId attribute for a record.
@UncheckedAccess
FUNCTION Get_Note_Id (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(contract_, part_no_);
   RETURN micro_cache_value_.note_id;
END Get_Note_Id;


-- Get_Part_Product_Code
--   Fetches the PartProductCode attribute for a record.
@UncheckedAccess
FUNCTION Get_Part_Product_Code (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(contract_, part_no_);
   RETURN micro_cache_value_.part_product_code;
END Get_Part_Product_Code;


-- Get_Part_Product_Family
--   Fetches the PartProductFamily attribute for a record.
@UncheckedAccess
FUNCTION Get_Part_Product_Family (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(contract_, part_no_);
   RETURN micro_cache_value_.part_product_family;
END Get_Part_Product_Family;


-- Get_Part_Status
--   Fetches the PartStatus attribute for a record.
@UncheckedAccess
FUNCTION Get_Part_Status (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(contract_, part_no_);
   RETURN micro_cache_value_.part_status;
END Get_Part_Status;


-- Get_Planner_Buyer
--   Fetches the PlannerBuyer attribute for a record.
@UncheckedAccess
FUNCTION Get_Planner_Buyer (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(contract_, part_no_);
   RETURN micro_cache_value_.planner_buyer;
END Get_Planner_Buyer;


-- Get_Prime_Commodity
--   Fetches the PrimeCommodity attribute for a record.
@UncheckedAccess
FUNCTION Get_Prime_Commodity (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(contract_, part_no_);
   RETURN micro_cache_value_.prime_commodity;
END Get_Prime_Commodity;


-- Get_Second_Commodity
--   Fetches the SecondCommodity attribute for a record.
@UncheckedAccess
FUNCTION Get_Second_Commodity (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(contract_, part_no_);
   RETURN micro_cache_value_.second_commodity;
END Get_Second_Commodity;


-- Get_Unit_Meas
--   Fetches the UnitMeas attribute for a record.
@UncheckedAccess
FUNCTION Get_Unit_Meas (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(contract_, part_no_);
   RETURN micro_cache_value_.unit_meas;
END Get_Unit_Meas;


-- Get_Catch_Unit_Meas
--   Fetches the CatchUnitMeas attribute for a record.
@UncheckedAccess
FUNCTION Get_Catch_Unit_Meas (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ inventory_part_tab.catch_unit_meas%TYPE;
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT catch_unit_meas
      INTO  temp_
      FROM  inventory_part_tab
      WHERE contract = contract_
      AND   part_no = part_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(contract_, part_no_, 'Get_Catch_Unit_Meas');
END Get_Catch_Unit_Meas;


-- Get_Abc_Class
--   Fetches the AbcClass attribute for a record.
@UncheckedAccess
FUNCTION Get_Abc_Class (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(contract_, part_no_);
   RETURN micro_cache_value_.abc_class;
END Get_Abc_Class;


-- Get_Abc_Class_Locked_Until
--   Fetches the AbcClassLockedUntil attribute for a record.
@UncheckedAccess
FUNCTION Get_Abc_Class_Locked_Until (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN DATE
IS
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(contract_, part_no_);
   RETURN micro_cache_value_.abc_class_locked_until;
END Get_Abc_Class_Locked_Until;


-- Get_Count_Variance
--   Fetches the CountVariance attribute for a record.
@UncheckedAccess
FUNCTION Get_Count_Variance (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   temp_ inventory_part_tab.count_variance%TYPE;
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT count_variance
      INTO  temp_
      FROM  inventory_part_tab
      WHERE contract = contract_
      AND   part_no = part_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(contract_, part_no_, 'Get_Count_Variance');
END Get_Count_Variance;


-- Get_Create_Date
--   Fetches the CreateDate attribute for a record.
@UncheckedAccess
FUNCTION Get_Create_Date (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN DATE
IS
   temp_ inventory_part_tab.create_date%TYPE;
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT create_date
      INTO  temp_
      FROM  inventory_part_tab
      WHERE contract = contract_
      AND   part_no = part_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(contract_, part_no_, 'Get_Create_Date');
END Get_Create_Date;


-- Get_Cycle_Code
--   Fetches the CycleCode attribute for a record.
@UncheckedAccess
FUNCTION Get_Cycle_Code (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ inventory_part_tab.cycle_code%TYPE;
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT cycle_code
      INTO  temp_
      FROM  inventory_part_tab
      WHERE contract = contract_
      AND   part_no = part_no_;
   RETURN Inventory_Part_Count_Type_API.Decode(temp_);
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(contract_, part_no_, 'Get_Cycle_Code');
END Get_Cycle_Code;


-- Get_Cycle_Code_Db
--   Fetches the DB value of CycleCode attribute for a record.
@UncheckedAccess
FUNCTION Get_Cycle_Code_Db (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN inventory_part_tab.cycle_code%TYPE
IS
   temp_ inventory_part_tab.cycle_code%TYPE;
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT cycle_code
      INTO  temp_
      FROM  inventory_part_tab
      WHERE contract = contract_
      AND   part_no = part_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(contract_, part_no_, 'Get_Cycle_Code_Db');
END Get_Cycle_Code_Db;


-- Get_Cycle_Period
--   Fetches the CyclePeriod attribute for a record.
@UncheckedAccess
FUNCTION Get_Cycle_Period (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   temp_ inventory_part_tab.cycle_period%TYPE;
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT cycle_period
      INTO  temp_
      FROM  inventory_part_tab
      WHERE contract = contract_
      AND   part_no = part_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(contract_, part_no_, 'Get_Cycle_Period');
END Get_Cycle_Period;


-- Get_Dim_Quality
--   Fetches the DimQuality attribute for a record.
@UncheckedAccess
FUNCTION Get_Dim_Quality (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ inventory_part_tab.dim_quality%TYPE;
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT dim_quality
      INTO  temp_
      FROM  inventory_part_tab
      WHERE contract = contract_
      AND   part_no = part_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(contract_, part_no_, 'Get_Dim_Quality');
END Get_Dim_Quality;


-- Get_Durability_Day
--   Fetches the DurabilityDay attribute for a record.
@UncheckedAccess
FUNCTION Get_Durability_Day (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(contract_, part_no_);
   RETURN micro_cache_value_.durability_day;
END Get_Durability_Day;


-- Get_Expected_Leadtime
--   Fetches the ExpectedLeadtime attribute for a record.
@UncheckedAccess
FUNCTION Get_Expected_Leadtime (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(contract_, part_no_);
   RETURN micro_cache_value_.expected_leadtime;
END Get_Expected_Leadtime;


-- Get_Lead_Time_Code
--   Fetches the LeadTimeCode attribute for a record.
@UncheckedAccess
FUNCTION Get_Lead_Time_Code (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(contract_, part_no_);
   RETURN Inv_Part_Lead_Time_Code_API.Decode(micro_cache_value_.lead_time_code);
END Get_Lead_Time_Code;


-- Get_Lead_Time_Code_Db
--   Fetches the DB value of LeadTimeCode attribute for a record.
@UncheckedAccess
FUNCTION Get_Lead_Time_Code_Db (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN inventory_part_tab.lead_time_code%TYPE
IS
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(contract_, part_no_);
   RETURN micro_cache_value_.lead_time_code;
END Get_Lead_Time_Code_Db;


-- Get_Manuf_Leadtime
--   Fetches the ManufLeadtime attribute for a record.
@UncheckedAccess
FUNCTION Get_Manuf_Leadtime (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(contract_, part_no_);
   RETURN micro_cache_value_.manuf_leadtime;
END Get_Manuf_Leadtime;


-- Get_Oe_Alloc_Assign_Flag
--   Fetches the OeAllocAssignFlag attribute for a record.
@UncheckedAccess
FUNCTION Get_Oe_Alloc_Assign_Flag (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ inventory_part_tab.oe_alloc_assign_flag%TYPE;
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT oe_alloc_assign_flag
      INTO  temp_
      FROM  inventory_part_tab
      WHERE contract = contract_
      AND   part_no = part_no_;
   RETURN Cust_Ord_Reservation_Type_API.Decode(temp_);
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(contract_, part_no_, 'Get_Oe_Alloc_Assign_Flag');
END Get_Oe_Alloc_Assign_Flag;


-- Get_Oe_Alloc_Assign_Flag_Db
--   Fetches the DB value of OeAllocAssignFlag attribute for a record.
@UncheckedAccess
FUNCTION Get_Oe_Alloc_Assign_Flag_Db (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN inventory_part_tab.oe_alloc_assign_flag%TYPE
IS
   temp_ inventory_part_tab.oe_alloc_assign_flag%TYPE;
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT oe_alloc_assign_flag
      INTO  temp_
      FROM  inventory_part_tab
      WHERE contract = contract_
      AND   part_no = part_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(contract_, part_no_, 'Get_Oe_Alloc_Assign_Flag_Db');
END Get_Oe_Alloc_Assign_Flag_Db;


-- Get_Onhand_Analysis_Flag
--   Fetches the OnhandAnalysisFlag attribute for a record.
@UncheckedAccess
FUNCTION Get_Onhand_Analysis_Flag (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ inventory_part_tab.onhand_analysis_flag%TYPE;
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT onhand_analysis_flag
      INTO  temp_
      FROM  inventory_part_tab
      WHERE contract = contract_
      AND   part_no = part_no_;
   RETURN Inventory_Part_Onh_Analys_API.Decode(temp_);
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(contract_, part_no_, 'Get_Onhand_Analysis_Flag');
END Get_Onhand_Analysis_Flag;


-- Get_Onhand_Analysis_Flag_Db
--   Fetches the DB value of OnhandAnalysisFlag attribute for a record.
@UncheckedAccess
FUNCTION Get_Onhand_Analysis_Flag_Db (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN inventory_part_tab.onhand_analysis_flag%TYPE
IS
   temp_ inventory_part_tab.onhand_analysis_flag%TYPE;
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT onhand_analysis_flag
      INTO  temp_
      FROM  inventory_part_tab
      WHERE contract = contract_
      AND   part_no = part_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(contract_, part_no_, 'Get_Onhand_Analysis_Flag_Db');
END Get_Onhand_Analysis_Flag_Db;


-- Get_Purch_Leadtime
--   Fetches the PurchLeadtime attribute for a record.
@UncheckedAccess
FUNCTION Get_Purch_Leadtime (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(contract_, part_no_);
   RETURN micro_cache_value_.purch_leadtime;
END Get_Purch_Leadtime;


-- Get_Earliest_Ultd_Supply_Date
--   Fetches the EarliestUltdSupplyDate attribute for a record.
@UncheckedAccess
FUNCTION Get_Earliest_Ultd_Supply_Date (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN DATE
IS
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(contract_, part_no_);
   RETURN micro_cache_value_.earliest_ultd_supply_date;
END Get_Earliest_Ultd_Supply_Date;


-- Get_Supersedes
--   Fetches the Supersedes attribute for a record.
@UncheckedAccess
FUNCTION Get_Supersedes (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ inventory_part_tab.supersedes%TYPE;
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT supersedes
      INTO  temp_
      FROM  inventory_part_tab
      WHERE contract = contract_
      AND   part_no = part_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(contract_, part_no_, 'Get_Supersedes');
END Get_Supersedes;


-- Get_Supply_Code
--   Fetches the SupplyCode attribute for a record.
@UncheckedAccess
FUNCTION Get_Supply_Code (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ inventory_part_tab.supply_code%TYPE;
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT supply_code
      INTO  temp_
      FROM  inventory_part_tab
      WHERE contract = contract_
      AND   part_no = part_no_;
   RETURN Material_Requis_Supply_API.Decode(temp_);
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(contract_, part_no_, 'Get_Supply_Code');
END Get_Supply_Code;


-- Get_Supply_Code_Db
--   Fetches the DB value of SupplyCode attribute for a record.
@UncheckedAccess
FUNCTION Get_Supply_Code_Db (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN inventory_part_tab.supply_code%TYPE
IS
   temp_ inventory_part_tab.supply_code%TYPE;
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT supply_code
      INTO  temp_
      FROM  inventory_part_tab
      WHERE contract = contract_
      AND   part_no = part_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(contract_, part_no_, 'Get_Supply_Code_Db');
END Get_Supply_Code_Db;


-- Get_Type_Code
--   Fetches the TypeCode attribute for a record.
@UncheckedAccess
FUNCTION Get_Type_Code (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(contract_, part_no_);
   RETURN Inventory_Part_Type_API.Decode(micro_cache_value_.type_code);
END Get_Type_Code;


-- Get_Type_Code_Db
--   Fetches the DB value of TypeCode attribute for a record.
@UncheckedAccess
FUNCTION Get_Type_Code_Db (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN inventory_part_tab.type_code%TYPE
IS
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(contract_, part_no_);
   RETURN micro_cache_value_.type_code;
END Get_Type_Code_Db;


-- Get_Customs_Stat_No
--   Fetches the CustomsStatNo attribute for a record.
@UncheckedAccess
FUNCTION Get_Customs_Stat_No (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ inventory_part_tab.customs_stat_no%TYPE;
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT customs_stat_no
      INTO  temp_
      FROM  inventory_part_tab
      WHERE contract = contract_
      AND   part_no = part_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(contract_, part_no_, 'Get_Customs_Stat_No');
END Get_Customs_Stat_No;


-- Get_Type_Designation
--   Fetches the TypeDesignation attribute for a record.
@UncheckedAccess
FUNCTION Get_Type_Designation (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ inventory_part_tab.type_designation%TYPE;
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT type_designation
      INTO  temp_
      FROM  inventory_part_tab
      WHERE contract = contract_
      AND   part_no = part_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(contract_, part_no_, 'Get_Type_Designation');
END Get_Type_Designation;


-- Get_Zero_Cost_Flag
--   Fetches the ZeroCostFlag attribute for a record.
@UncheckedAccess
FUNCTION Get_Zero_Cost_Flag (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ inventory_part_tab.zero_cost_flag%TYPE;
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT zero_cost_flag
      INTO  temp_
      FROM  inventory_part_tab
      WHERE contract = contract_
      AND   part_no = part_no_;
   RETURN Inventory_Part_Zero_Cost_API.Decode(temp_);
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(contract_, part_no_, 'Get_Zero_Cost_Flag');
END Get_Zero_Cost_Flag;


-- Get_Zero_Cost_Flag_Db
--   Fetches the DB value of ZeroCostFlag attribute for a record.
@UncheckedAccess
FUNCTION Get_Zero_Cost_Flag_Db (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN inventory_part_tab.zero_cost_flag%TYPE
IS
   temp_ inventory_part_tab.zero_cost_flag%TYPE;
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT zero_cost_flag
      INTO  temp_
      FROM  inventory_part_tab
      WHERE contract = contract_
      AND   part_no = part_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(contract_, part_no_, 'Get_Zero_Cost_Flag_Db');
END Get_Zero_Cost_Flag_Db;


-- Get_Avail_Activity_Status
--   Fetches the AvailActivityStatus attribute for a record.
@UncheckedAccess
FUNCTION Get_Avail_Activity_Status (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ inventory_part_tab.avail_activity_status%TYPE;
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT avail_activity_status
      INTO  temp_
      FROM  inventory_part_tab
      WHERE contract = contract_
      AND   part_no = part_no_;
   RETURN Inventory_Part_Avail_Stat_API.Decode(temp_);
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(contract_, part_no_, 'Get_Avail_Activity_Status');
END Get_Avail_Activity_Status;


-- Get_Avail_Activity_Status_Db
--   Fetches the DB value of AvailActivityStatus attribute for a record.
@UncheckedAccess
FUNCTION Get_Avail_Activity_Status_Db (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN inventory_part_tab.avail_activity_status%TYPE
IS
   temp_ inventory_part_tab.avail_activity_status%TYPE;
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT avail_activity_status
      INTO  temp_
      FROM  inventory_part_tab
      WHERE contract = contract_
      AND   part_no = part_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(contract_, part_no_, 'Get_Avail_Activity_Status_Db');
END Get_Avail_Activity_Status_Db;


-- Get_Eng_Attribute
--   Fetches the EngAttribute attribute for a record.
@UncheckedAccess
FUNCTION Get_Eng_Attribute (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ inventory_part_tab.eng_attribute%TYPE;
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT eng_attribute
      INTO  temp_
      FROM  inventory_part_tab
      WHERE contract = contract_
      AND   part_no = part_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(contract_, part_no_, 'Get_Eng_Attribute');
END Get_Eng_Attribute;


-- Get_Shortage_Flag
--   Fetches the ShortageFlag attribute for a record.
@UncheckedAccess
FUNCTION Get_Shortage_Flag (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ inventory_part_tab.shortage_flag%TYPE;
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT shortage_flag
      INTO  temp_
      FROM  inventory_part_tab
      WHERE contract = contract_
      AND   part_no = part_no_;
   RETURN Inventory_Part_Shortage_API.Decode(temp_);
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(contract_, part_no_, 'Get_Shortage_Flag');
END Get_Shortage_Flag;


-- Get_Shortage_Flag_Db
--   Fetches the DB value of ShortageFlag attribute for a record.
@UncheckedAccess
FUNCTION Get_Shortage_Flag_Db (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN inventory_part_tab.shortage_flag%TYPE
IS
   temp_ inventory_part_tab.shortage_flag%TYPE;
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT shortage_flag
      INTO  temp_
      FROM  inventory_part_tab
      WHERE contract = contract_
      AND   part_no = part_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(contract_, part_no_, 'Get_Shortage_Flag_Db');
END Get_Shortage_Flag_Db;


-- Get_Forecast_Consumption_Flag
--   Fetches the ForecastConsumptionFlag attribute for a record.
@UncheckedAccess
FUNCTION Get_Forecast_Consumption_Flag (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ inventory_part_tab.forecast_consumption_flag%TYPE;
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT forecast_consumption_flag
      INTO  temp_
      FROM  inventory_part_tab
      WHERE contract = contract_
      AND   part_no = part_no_;
   RETURN Inv_Part_Forecast_Consum_API.Decode(temp_);
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(contract_, part_no_, 'Get_Forecast_Consumption_Flag');
END Get_Forecast_Consumption_Flag;


-- Get_Forecast_Consumption_Fl_Db
--   Fetches the DB value of ForecastConsumptionFlag attribute for a record.
@UncheckedAccess
FUNCTION Get_Forecast_Consumption_Fl_Db (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN inventory_part_tab.forecast_consumption_flag%TYPE
IS
   temp_ inventory_part_tab.forecast_consumption_flag%TYPE;
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT forecast_consumption_flag
      INTO  temp_
      FROM  inventory_part_tab
      WHERE contract = contract_
      AND   part_no = part_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(contract_, part_no_, 'Get_Forecast_Consumption_Fl_Db');
END Get_Forecast_Consumption_Fl_Db;


-- Get_Stock_Management
--   Fetches the StockManagement attribute for a record.
@UncheckedAccess
FUNCTION Get_Stock_Management (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(contract_, part_no_);
   RETURN Inventory_Part_Management_API.Decode(micro_cache_value_.stock_management);
END Get_Stock_Management;


-- Get_Stock_Management_Db
--   Fetches the DB value of StockManagement attribute for a record.
@UncheckedAccess
FUNCTION Get_Stock_Management_Db (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN inventory_part_tab.stock_management%TYPE
IS
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(contract_, part_no_);
   RETURN micro_cache_value_.stock_management;
END Get_Stock_Management_Db;


-- Get_Intrastat_Conv_Factor
--   Fetches the IntrastatConvFactor attribute for a record.
@UncheckedAccess
FUNCTION Get_Intrastat_Conv_Factor (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   temp_ inventory_part_tab.intrastat_conv_factor%TYPE;
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT intrastat_conv_factor
      INTO  temp_
      FROM  inventory_part_tab
      WHERE contract = contract_
      AND   part_no = part_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(contract_, part_no_, 'Get_Intrastat_Conv_Factor');
END Get_Intrastat_Conv_Factor;


-- Get_Part_Cost_Group_Id
--   Fetches the PartCostGroupId attribute for a record.
@UncheckedAccess
FUNCTION Get_Part_Cost_Group_Id (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ inventory_part_tab.part_cost_group_id%TYPE;
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT part_cost_group_id
      INTO  temp_
      FROM  inventory_part_tab
      WHERE contract = contract_
      AND   part_no = part_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(contract_, part_no_, 'Get_Part_Cost_Group_Id');
END Get_Part_Cost_Group_Id;


-- Get_Dop_Connection
--   Fetches the DopConnection attribute for a record.
@UncheckedAccess
FUNCTION Get_Dop_Connection (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ inventory_part_tab.dop_connection%TYPE;
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT dop_connection
      INTO  temp_
      FROM  inventory_part_tab
      WHERE contract = contract_
      AND   part_no = part_no_;
   RETURN Dop_Connection_API.Decode(temp_);
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(contract_, part_no_, 'Get_Dop_Connection');
END Get_Dop_Connection;


-- Get_Dop_Connection_Db
--   Fetches the DB value of DopConnection attribute for a record.
@UncheckedAccess
FUNCTION Get_Dop_Connection_Db (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN inventory_part_tab.dop_connection%TYPE
IS
   temp_ inventory_part_tab.dop_connection%TYPE;
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT dop_connection
      INTO  temp_
      FROM  inventory_part_tab
      WHERE contract = contract_
      AND   part_no = part_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(contract_, part_no_, 'Get_Dop_Connection_Db');
END Get_Dop_Connection_Db;


-- Get_Std_Name_Id
--   Fetches the StdNameId attribute for a record.
@UncheckedAccess
FUNCTION Get_Std_Name_Id (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   temp_ inventory_part_tab.std_name_id%TYPE;
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT std_name_id
      INTO  temp_
      FROM  inventory_part_tab
      WHERE contract = contract_
      AND   part_no = part_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(contract_, part_no_, 'Get_Std_Name_Id');
END Get_Std_Name_Id;


-- Get_Inventory_Valuation_Method
--   Fetches the InventoryValuationMethod attribute for a record.
@UncheckedAccess
FUNCTION Get_Inventory_Valuation_Method (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ inventory_part_tab.inventory_valuation_method%TYPE;
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT inventory_valuation_method
      INTO  temp_
      FROM  inventory_part_tab
      WHERE contract = contract_
      AND   part_no = part_no_;
   RETURN Inventory_Value_Method_API.Decode(temp_);
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(contract_, part_no_, 'Get_Inventory_Valuation_Method');
END Get_Inventory_Valuation_Method;


-- Get_Inventory_Valuation_Met_Db
--   Fetches the DB value of InventoryValuationMethod attribute for a record.
@UncheckedAccess
FUNCTION Get_Inventory_Valuation_Met_Db (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN inventory_part_tab.inventory_valuation_method%TYPE
IS
   temp_ inventory_part_tab.inventory_valuation_method%TYPE;
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT inventory_valuation_method
      INTO  temp_
      FROM  inventory_part_tab
      WHERE contract = contract_
      AND   part_no = part_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(contract_, part_no_, 'Get_Inventory_Valuation_Met_Db');
END Get_Inventory_Valuation_Met_Db;


-- Get_Negative_On_Hand
--   Fetches the NegativeOnHand attribute for a record.
@UncheckedAccess
FUNCTION Get_Negative_On_Hand (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ inventory_part_tab.negative_on_hand%TYPE;
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT negative_on_hand
      INTO  temp_
      FROM  inventory_part_tab
      WHERE contract = contract_
      AND   part_no = part_no_;
   RETURN Negative_On_Hand_API.Decode(temp_);
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(contract_, part_no_, 'Get_Negative_On_Hand');
END Get_Negative_On_Hand;


-- Get_Negative_On_Hand_Db
--   Fetches the DB value of NegativeOnHand attribute for a record.
@UncheckedAccess
FUNCTION Get_Negative_On_Hand_Db (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN inventory_part_tab.negative_on_hand%TYPE
IS
   temp_ inventory_part_tab.negative_on_hand%TYPE;
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT negative_on_hand
      INTO  temp_
      FROM  inventory_part_tab
      WHERE contract = contract_
      AND   part_no = part_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(contract_, part_no_, 'Get_Negative_On_Hand_Db');
END Get_Negative_On_Hand_Db;


-- Get_Technical_Coordinator_Id
--   Fetches the TechnicalCoordinatorId attribute for a record.
@UncheckedAccess
FUNCTION Get_Technical_Coordinator_Id (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ inventory_part_tab.technical_coordinator_id%TYPE;
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT technical_coordinator_id
      INTO  temp_
      FROM  inventory_part_tab
      WHERE contract = contract_
      AND   part_no = part_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(contract_, part_no_, 'Get_Technical_Coordinator_Id');
END Get_Technical_Coordinator_Id;


-- Get_Invoice_Consideration
--   Fetches the InvoiceConsideration attribute for a record.
@UncheckedAccess
FUNCTION Get_Invoice_Consideration (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(contract_, part_no_);
   RETURN Invoice_Consideration_API.Decode(micro_cache_value_.invoice_consideration);
END Get_Invoice_Consideration;


-- Get_Invoice_Consideration_Db
--   Fetches the DB value of InvoiceConsideration attribute for a record.
@UncheckedAccess
FUNCTION Get_Invoice_Consideration_Db (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN inventory_part_tab.invoice_consideration%TYPE
IS
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(contract_, part_no_);
   RETURN micro_cache_value_.invoice_consideration;
END Get_Invoice_Consideration_Db;


-- Get_Actual_Cost_Activated
--   Fetches the ActualCostActivated attribute for a record.
@UncheckedAccess
FUNCTION Get_Actual_Cost_Activated (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN DATE
IS
   temp_ inventory_part_tab.actual_cost_activated%TYPE;
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT actual_cost_activated
      INTO  temp_
      FROM  inventory_part_tab
      WHERE contract = contract_
      AND   part_no = part_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(contract_, part_no_, 'Get_Actual_Cost_Activated');
END Get_Actual_Cost_Activated;


-- Get_Max_Actual_Cost_Update
--   Fetches the MaxActualCostUpdate attribute for a record.
@UncheckedAccess
FUNCTION Get_Max_Actual_Cost_Update (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   temp_ inventory_part_tab.max_actual_cost_update%TYPE;
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT max_actual_cost_update
      INTO  temp_
      FROM  inventory_part_tab
      WHERE contract = contract_
      AND   part_no = part_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(contract_, part_no_, 'Get_Max_Actual_Cost_Update');
END Get_Max_Actual_Cost_Update;


-- Get_Cust_Warranty_Id
--   Fetches the CustWarrantyId attribute for a record.
@UncheckedAccess
FUNCTION Get_Cust_Warranty_Id (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   temp_ inventory_part_tab.cust_warranty_id%TYPE;
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT cust_warranty_id
      INTO  temp_
      FROM  inventory_part_tab
      WHERE contract = contract_
      AND   part_no = part_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(contract_, part_no_, 'Get_Cust_Warranty_Id');
END Get_Cust_Warranty_Id;


-- Get_Sup_Warranty_Id
--   Fetches the SupWarrantyId attribute for a record.
@UncheckedAccess
FUNCTION Get_Sup_Warranty_Id (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   temp_ inventory_part_tab.sup_warranty_id%TYPE;
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT sup_warranty_id
      INTO  temp_
      FROM  inventory_part_tab
      WHERE contract = contract_
      AND   part_no = part_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(contract_, part_no_, 'Get_Sup_Warranty_Id');
END Get_Sup_Warranty_Id;


-- Get_Region_Of_Origin
--   Fetches the RegionOfOrigin attribute for a record.
@UncheckedAccess
FUNCTION Get_Region_Of_Origin (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ inventory_part_tab.region_of_origin%TYPE;
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT region_of_origin
      INTO  temp_
      FROM  inventory_part_tab
      WHERE contract = contract_
      AND   part_no = part_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(contract_, part_no_, 'Get_Region_Of_Origin');
END Get_Region_Of_Origin;


-- Get_Inventory_Part_Cost_Level
--   Fetches the InventoryPartCostLevel attribute for a record.
@UncheckedAccess
FUNCTION Get_Inventory_Part_Cost_Level (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ inventory_part_tab.inventory_part_cost_level%TYPE;
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT inventory_part_cost_level
      INTO  temp_
      FROM  inventory_part_tab
      WHERE contract = contract_
      AND   part_no = part_no_;
   RETURN Inventory_Part_Cost_Level_API.Decode(temp_);
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(contract_, part_no_, 'Get_Inventory_Part_Cost_Level');
END Get_Inventory_Part_Cost_Level;


-- Get_Inventory_Part_Cost_Lev_Db
--   Fetches the DB value of InventoryPartCostLevel attribute for a record.
@UncheckedAccess
FUNCTION Get_Inventory_Part_Cost_Lev_Db (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN inventory_part_tab.inventory_part_cost_level%TYPE
IS
   temp_ inventory_part_tab.inventory_part_cost_level%TYPE;
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT inventory_part_cost_level
      INTO  temp_
      FROM  inventory_part_tab
      WHERE contract = contract_
      AND   part_no = part_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(contract_, part_no_, 'Get_Inventory_Part_Cost_Lev_Db');
END Get_Inventory_Part_Cost_Lev_Db;


-- Get_Ext_Service_Cost_Method
--   Fetches the ExtServiceCostMethod attribute for a record.
@UncheckedAccess
FUNCTION Get_Ext_Service_Cost_Method (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ inventory_part_tab.ext_service_cost_method%TYPE;
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT ext_service_cost_method
      INTO  temp_
      FROM  inventory_part_tab
      WHERE contract = contract_
      AND   part_no = part_no_;
   RETURN Ext_Service_Cost_Method_API.Decode(temp_);
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(contract_, part_no_, 'Get_Ext_Service_Cost_Method');
END Get_Ext_Service_Cost_Method;


-- Get_Ext_Service_Cost_Method_Db
--   Fetches the DB value of ExtServiceCostMethod attribute for a record.
@UncheckedAccess
FUNCTION Get_Ext_Service_Cost_Method_Db (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN inventory_part_tab.ext_service_cost_method%TYPE
IS
   temp_ inventory_part_tab.ext_service_cost_method%TYPE;
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT ext_service_cost_method
      INTO  temp_
      FROM  inventory_part_tab
      WHERE contract = contract_
      AND   part_no = part_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(contract_, part_no_, 'Get_Ext_Service_Cost_Method_Db');
END Get_Ext_Service_Cost_Method_Db;


-- Get_Supply_Chain_Part_Group
--   Fetches the SupplyChainPartGroup attribute for a record.
@UncheckedAccess
FUNCTION Get_Supply_Chain_Part_Group (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ inventory_part_tab.supply_chain_part_group%TYPE;
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT supply_chain_part_group
      INTO  temp_
      FROM  inventory_part_tab
      WHERE contract = contract_
      AND   part_no = part_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(contract_, part_no_, 'Get_Supply_Chain_Part_Group');
END Get_Supply_Chain_Part_Group;


-- Get_Automatic_Capability_Check
--   Fetches the AutomaticCapabilityCheck attribute for a record.
@UncheckedAccess
FUNCTION Get_Automatic_Capability_Check (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ inventory_part_tab.automatic_capability_check%TYPE;
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT automatic_capability_check
      INTO  temp_
      FROM  inventory_part_tab
      WHERE contract = contract_
      AND   part_no = part_no_;
   RETURN Capability_Check_Allocate_API.Decode(temp_);
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(contract_, part_no_, 'Get_Automatic_Capability_Check');
END Get_Automatic_Capability_Check;


-- Get_Automatic_Capability_Ch_Db
--   Fetches the DB value of AutomaticCapabilityCheck attribute for a record.
@UncheckedAccess
FUNCTION Get_Automatic_Capability_Ch_Db (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN inventory_part_tab.automatic_capability_check%TYPE
IS
   temp_ inventory_part_tab.automatic_capability_check%TYPE;
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT automatic_capability_check
      INTO  temp_
      FROM  inventory_part_tab
      WHERE contract = contract_
      AND   part_no = part_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(contract_, part_no_, 'Get_Automatic_Capability_Ch_Db');
END Get_Automatic_Capability_Ch_Db;


-- Get_Input_Unit_Meas_Group_Id
--   Fetches the InputUnitMeasGroupId attribute for a record.
@UncheckedAccess
FUNCTION Get_Input_Unit_Meas_Group_Id (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ inventory_part_tab.input_unit_meas_group_id%TYPE;
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT input_unit_meas_group_id
      INTO  temp_
      FROM  inventory_part_tab
      WHERE contract = contract_
      AND   part_no = part_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(contract_, part_no_, 'Get_Input_Unit_Meas_Group_Id');
END Get_Input_Unit_Meas_Group_Id;


-- Get_Dop_Netting
--   Fetches the DopNetting attribute for a record.
@UncheckedAccess
FUNCTION Get_Dop_Netting (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ inventory_part_tab.dop_netting%TYPE;
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT dop_netting
      INTO  temp_
      FROM  inventory_part_tab
      WHERE contract = contract_
      AND   part_no = part_no_;
   RETURN Dop_Netting_API.Decode(temp_);
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(contract_, part_no_, 'Get_Dop_Netting');
END Get_Dop_Netting;


-- Get_Dop_Netting_Db
--   Fetches the DB value of DopNetting attribute for a record.
@UncheckedAccess
FUNCTION Get_Dop_Netting_Db (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN inventory_part_tab.dop_netting%TYPE
IS
   temp_ inventory_part_tab.dop_netting%TYPE;
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT dop_netting
      INTO  temp_
      FROM  inventory_part_tab
      WHERE contract = contract_
      AND   part_no = part_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(contract_, part_no_, 'Get_Dop_Netting_Db');
END Get_Dop_Netting_Db;


-- Get_Co_Reserve_Onh_Analys_Flag
--   Fetches the CoReserveOnhAnalysFlag attribute for a record.
@UncheckedAccess
FUNCTION Get_Co_Reserve_Onh_Analys_Flag (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ inventory_part_tab.co_reserve_onh_analys_flag%TYPE;
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT co_reserve_onh_analys_flag
      INTO  temp_
      FROM  inventory_part_tab
      WHERE contract = contract_
      AND   part_no = part_no_;
   RETURN Inventory_Part_Onh_Analys_API.Decode(temp_);
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(contract_, part_no_, 'Get_Co_Reserve_Onh_Analys_Flag');
END Get_Co_Reserve_Onh_Analys_Flag;


-- Get_Co_Reserve_Onh_Analys_F_Db
--   Fetches the DB value of CoReserveOnhAnalysFlag attribute for a record.
@UncheckedAccess
FUNCTION Get_Co_Reserve_Onh_Analys_F_Db (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN inventory_part_tab.co_reserve_onh_analys_flag%TYPE
IS
   temp_ inventory_part_tab.co_reserve_onh_analys_flag%TYPE;
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT co_reserve_onh_analys_flag
      INTO  temp_
      FROM  inventory_part_tab
      WHERE contract = contract_
      AND   part_no = part_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(contract_, part_no_, 'Get_Co_Reserve_Onh_Analys_F_Db');
END Get_Co_Reserve_Onh_Analys_F_Db;


-- Get_Qty_Calc_Rounding
--   Fetches the QtyCalcRounding attribute for a record.
@UncheckedAccess
FUNCTION Get_Qty_Calc_Rounding (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(contract_, part_no_);
   RETURN micro_cache_value_.qty_calc_rounding;
END Get_Qty_Calc_Rounding;


-- Get_Lifecycle_Stage
--   Fetches the LifecycleStage attribute for a record.
@UncheckedAccess
FUNCTION Get_Lifecycle_Stage (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(contract_, part_no_);
   RETURN Inv_Part_Lifecycle_Stage_API.Decode(micro_cache_value_.lifecycle_stage);
END Get_Lifecycle_Stage;


-- Get_Lifecycle_Stage_Db
--   Fetches the DB value of LifecycleStage attribute for a record.
@UncheckedAccess
FUNCTION Get_Lifecycle_Stage_Db (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN inventory_part_tab.lifecycle_stage%TYPE
IS
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(contract_, part_no_);
   RETURN micro_cache_value_.lifecycle_stage;
END Get_Lifecycle_Stage_Db;


-- Get_Life_Stage_Locked_Until
--   Fetches the LifeStageLockedUntil attribute for a record.
@UncheckedAccess
FUNCTION Get_Life_Stage_Locked_Until (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN DATE
IS
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(contract_, part_no_);
   RETURN micro_cache_value_.life_stage_locked_until;
END Get_Life_Stage_Locked_Until;


-- Get_Frequency_Class
--   Fetches the FrequencyClass attribute for a record.
@UncheckedAccess
FUNCTION Get_Frequency_Class (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(contract_, part_no_);
   RETURN Inv_Part_Frequency_Class_API.Decode(micro_cache_value_.frequency_class);
END Get_Frequency_Class;


-- Get_Frequency_Class_Db
--   Fetches the DB value of FrequencyClass attribute for a record.
@UncheckedAccess
FUNCTION Get_Frequency_Class_Db (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN inventory_part_tab.frequency_class%TYPE
IS
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(contract_, part_no_);
   RETURN micro_cache_value_.frequency_class;
END Get_Frequency_Class_Db;


-- Get_Freq_Class_Locked_Until
--   Fetches the FreqClassLockedUntil attribute for a record.
@UncheckedAccess
FUNCTION Get_Freq_Class_Locked_Until (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN DATE
IS
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(contract_, part_no_);
   RETURN micro_cache_value_.freq_class_locked_until;
END Get_Freq_Class_Locked_Until;


-- Get_First_Stat_Issue_Date
--   Fetches the FirstStatIssueDate attribute for a record.
@UncheckedAccess
FUNCTION Get_First_Stat_Issue_Date (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN DATE
IS
   temp_ inventory_part_tab.first_stat_issue_date%TYPE;
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT first_stat_issue_date
      INTO  temp_
      FROM  inventory_part_tab
      WHERE contract = contract_
      AND   part_no = part_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(contract_, part_no_, 'Get_First_Stat_Issue_Date');
END Get_First_Stat_Issue_Date;


-- Get_Latest_Stat_Issue_Date
--   Fetches the LatestStatIssueDate attribute for a record.
@UncheckedAccess
FUNCTION Get_Latest_Stat_Issue_Date (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN DATE
IS
   temp_ inventory_part_tab.latest_stat_issue_date%TYPE;
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT latest_stat_issue_date
      INTO  temp_
      FROM  inventory_part_tab
      WHERE contract = contract_
      AND   part_no = part_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(contract_, part_no_, 'Get_Latest_Stat_Issue_Date');
END Get_Latest_Stat_Issue_Date;


-- Get_Decline_Date
--   Fetches the DeclineDate attribute for a record.
@UncheckedAccess
FUNCTION Get_Decline_Date (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN DATE
IS
   temp_ inventory_part_tab.decline_date%TYPE;
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT decline_date
      INTO  temp_
      FROM  inventory_part_tab
      WHERE contract = contract_
      AND   part_no = part_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(contract_, part_no_, 'Get_Decline_Date');
END Get_Decline_Date;


-- Get_Expired_Date
--   Fetches the ExpiredDate attribute for a record.
@UncheckedAccess
FUNCTION Get_Expired_Date (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN DATE
IS
   temp_ inventory_part_tab.expired_date%TYPE;
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT expired_date
      INTO  temp_
      FROM  inventory_part_tab
      WHERE contract = contract_
      AND   part_no = part_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(contract_, part_no_, 'Get_Expired_Date');
END Get_Expired_Date;


-- Get_Decline_Issue_Counter
--   Fetches the DeclineIssueCounter attribute for a record.
@UncheckedAccess
FUNCTION Get_Decline_Issue_Counter (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   temp_ inventory_part_tab.decline_issue_counter%TYPE;
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT decline_issue_counter
      INTO  temp_
      FROM  inventory_part_tab
      WHERE contract = contract_
      AND   part_no = part_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(contract_, part_no_, 'Get_Decline_Issue_Counter');
END Get_Decline_Issue_Counter;


-- Get_Expired_Issue_Counter
--   Fetches the ExpiredIssueCounter attribute for a record.
@UncheckedAccess
FUNCTION Get_Expired_Issue_Counter (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   temp_ inventory_part_tab.expired_issue_counter%TYPE;
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT expired_issue_counter
      INTO  temp_
      FROM  inventory_part_tab
      WHERE contract = contract_
      AND   part_no = part_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(contract_, part_no_, 'Get_Expired_Issue_Counter');
END Get_Expired_Issue_Counter;


-- Get_Min_Durab_Days_Co_Deliv
--   Fetches the MinDurabDaysCoDeliv attribute for a record.
@UncheckedAccess
FUNCTION Get_Min_Durab_Days_Co_Deliv (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(contract_, part_no_);
   RETURN micro_cache_value_.min_durab_days_co_deliv;
END Get_Min_Durab_Days_Co_Deliv;


-- Get_Min_Durab_Days_Planning
--   Fetches the MinDurabDaysPlanning attribute for a record.
@UncheckedAccess
FUNCTION Get_Min_Durab_Days_Planning (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(contract_, part_no_);
   RETURN micro_cache_value_.min_durab_days_planning;
END Get_Min_Durab_Days_Planning;


-- Get_Storage_Width_Requirement
--   Fetches the StorageWidthRequirement attribute for a record.
@UncheckedAccess
FUNCTION Get_Storage_Width_Requirement (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(contract_, part_no_);
   RETURN micro_cache_value_.storage_width_requirement;
END Get_Storage_Width_Requirement;


-- Get_Storage_Height_Requirement
--   Fetches the StorageHeightRequirement attribute for a record.
@UncheckedAccess
FUNCTION Get_Storage_Height_Requirement (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(contract_, part_no_);
   RETURN micro_cache_value_.storage_height_requirement;
END Get_Storage_Height_Requirement;


-- Get_Storage_Depth_Requirement
--   Fetches the StorageDepthRequirement attribute for a record.
@UncheckedAccess
FUNCTION Get_Storage_Depth_Requirement (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(contract_, part_no_);
   RETURN micro_cache_value_.storage_depth_requirement;
END Get_Storage_Depth_Requirement;


-- Get_Storage_Volume_Requirement
--   Fetches the StorageVolumeRequirement attribute for a record.
@UncheckedAccess
FUNCTION Get_Storage_Volume_Requirement (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(contract_, part_no_);
   RETURN micro_cache_value_.storage_volume_requirement;
END Get_Storage_Volume_Requirement;


-- Get_Storage_Weight_Requirement
--   Fetches the StorageWeightRequirement attribute for a record.
@UncheckedAccess
FUNCTION Get_Storage_Weight_Requirement (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(contract_, part_no_);
   RETURN micro_cache_value_.storage_weight_requirement;
END Get_Storage_Weight_Requirement;


-- Get_Min_Storage_Temperature
--   Fetches the MinStorageTemperature attribute for a record.
@UncheckedAccess
FUNCTION Get_Min_Storage_Temperature (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(contract_, part_no_);
   RETURN micro_cache_value_.min_storage_temperature;
END Get_Min_Storage_Temperature;


-- Get_Max_Storage_Temperature
--   Fetches the MaxStorageTemperature attribute for a record.
@UncheckedAccess
FUNCTION Get_Max_Storage_Temperature (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(contract_, part_no_);
   RETURN micro_cache_value_.max_storage_temperature;
END Get_Max_Storage_Temperature;


-- Get_Min_Storage_Humidity
--   Fetches the MinStorageHumidity attribute for a record.
@UncheckedAccess
FUNCTION Get_Min_Storage_Humidity (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(contract_, part_no_);
   RETURN micro_cache_value_.min_storage_humidity;
END Get_Min_Storage_Humidity;


-- Get_Max_Storage_Humidity
--   Fetches the MaxStorageHumidity attribute for a record.
@UncheckedAccess
FUNCTION Get_Max_Storage_Humidity (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(contract_, part_no_);
   RETURN micro_cache_value_.max_storage_humidity;
END Get_Max_Storage_Humidity;


-- Get_Standard_Putaway_Qty
--   Fetches the StandardPutawayQty attribute for a record.
@UncheckedAccess
FUNCTION Get_Standard_Putaway_Qty (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(contract_, part_no_);
   RETURN micro_cache_value_.standard_putaway_qty;
END Get_Standard_Putaway_Qty;


-- Get_Reset_Config_Std_Cost
--   Fetches the ResetConfigStdCost attribute for a record.
@UncheckedAccess
FUNCTION Get_Reset_Config_Std_Cost (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(contract_, part_no_);
   RETURN Fnd_Boolean_API.Decode(micro_cache_value_.reset_config_std_cost);
END Get_Reset_Config_Std_Cost;


-- Get_Reset_Config_Std_Cost_Db
--   Fetches the DB value of ResetConfigStdCost attribute for a record.
@UncheckedAccess
FUNCTION Get_Reset_Config_Std_Cost_Db (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN inventory_part_tab.reset_config_std_cost%TYPE
IS
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(contract_, part_no_);
   RETURN micro_cache_value_.reset_config_std_cost;
END Get_Reset_Config_Std_Cost_Db;


-- Get_Mandatory_Expiration_Date
--   Fetches the MandatoryExpirationDate attribute for a record.
@UncheckedAccess
FUNCTION Get_Mandatory_Expiration_Date (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(contract_, part_no_);
   RETURN Fnd_Boolean_API.Decode(micro_cache_value_.mandatory_expiration_date);
END Get_Mandatory_Expiration_Date;


-- Get_Mandatory_Expiration_Da_Db
--   Fetches the DB value of MandatoryExpirationDate attribute for a record.
@UncheckedAccess
FUNCTION Get_Mandatory_Expiration_Da_Db (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN inventory_part_tab.mandatory_expiration_date%TYPE
IS
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(contract_, part_no_);
   RETURN micro_cache_value_.mandatory_expiration_date;
END Get_Mandatory_Expiration_Da_Db;


-- Get_Excl_Ship_Pack_Proposal
--   Fetches the ExclShipPackProposal attribute for a record.
@UncheckedAccess
FUNCTION Get_Excl_Ship_Pack_Proposal (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(contract_, part_no_);
   RETURN Fnd_Boolean_API.Decode(micro_cache_value_.excl_ship_pack_proposal);
END Get_Excl_Ship_Pack_Proposal;


-- Get_Excl_Ship_Pack_Proposal_Db
--   Fetches the DB value of ExclShipPackProposal attribute for a record.
@UncheckedAccess
FUNCTION Get_Excl_Ship_Pack_Proposal_Db (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN inventory_part_tab.excl_ship_pack_proposal%TYPE
IS
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(contract_, part_no_);
   RETURN micro_cache_value_.excl_ship_pack_proposal;
END Get_Excl_Ship_Pack_Proposal_Db;


-- Get_Statistical_Code
--   Fetches the StatisticalCode attribute for a record.
@UncheckedAccess
FUNCTION Get_Statistical_Code (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(contract_, part_no_);
   RETURN micro_cache_value_.statistical_code;
END Get_Statistical_Code;


-- Get_Acquisition_Origin
--   Fetches the AcquisitionOrigin attribute for a record.
@UncheckedAccess
FUNCTION Get_Acquisition_Origin (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(contract_, part_no_);
   RETURN micro_cache_value_.acquisition_origin;
END Get_Acquisition_Origin;


-- Get_Acquisition_Reason_Id
--   Fetches the AcquisitionReasonId attribute for a record.
@UncheckedAccess
FUNCTION Get_Acquisition_Reason_Id (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(contract_, part_no_);
   RETURN micro_cache_value_.acquisition_reason_id;
END Get_Acquisition_Reason_Id;

-- Get_By_Rowkey
--   Fetches a record containing the public attributes by rowkey inparameter.
@UncheckedAccess
FUNCTION Get_By_Rowkey (
   rowkey_ IN VARCHAR2 ) RETURN Public_Rec
IS
   rowrec_ inventory_part_tab%ROWTYPE;
BEGIN
   rowrec_ := Get_Key_By_Rowkey(rowkey_);
   RETURN Get(rowrec_.contract, rowrec_.part_no);
END Get_By_Rowkey;

-- Get
--   Fetches a record containing the public attributes.
@UncheckedAccess
FUNCTION Get (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN Public_Rec
IS
   temp_ Public_Rec;
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT contract, part_no, rowid, rowversion, rowkey,
          accounting_group, 
          asset_class, 
          country_of_origin, 
          hazard_code, 
          note_id, 
          part_product_code, 
          part_product_family, 
          part_status, 
          planner_buyer, 
          prime_commodity, 
          second_commodity, 
          unit_meas, 
          catch_unit_meas, 
          abc_class, 
          abc_class_locked_until, 
          count_variance, 
          create_date, 
          cycle_code, 
          cycle_period, 
          dim_quality, 
          durability_day, 
          expected_leadtime, 
          lead_time_code, 
          manuf_leadtime, 
          oe_alloc_assign_flag, 
          onhand_analysis_flag, 
          purch_leadtime, 
          earliest_ultd_supply_date, 
          supersedes, 
          supply_code, 
          type_code, 
          customs_stat_no, 
          type_designation, 
          zero_cost_flag, 
          avail_activity_status, 
          eng_attribute, 
          shortage_flag, 
          forecast_consumption_flag, 
          stock_management, 
          intrastat_conv_factor, 
          part_cost_group_id, 
          dop_connection, 
          std_name_id, 
          inventory_valuation_method, 
          negative_on_hand, 
          technical_coordinator_id, 
          invoice_consideration, 
          actual_cost_activated, 
          max_actual_cost_update, 
          cust_warranty_id, 
          sup_warranty_id, 
          region_of_origin, 
          inventory_part_cost_level, 
          ext_service_cost_method, 
          supply_chain_part_group, 
          automatic_capability_check, 
          input_unit_meas_group_id, 
          dop_netting, 
          co_reserve_onh_analys_flag, 
          qty_calc_rounding, 
          lifecycle_stage, 
          life_stage_locked_until, 
          frequency_class, 
          freq_class_locked_until, 
          first_stat_issue_date, 
          latest_stat_issue_date, 
          decline_date, 
          expired_date, 
          decline_issue_counter, 
          expired_issue_counter, 
          min_durab_days_co_deliv, 
          min_durab_days_planning, 
          storage_width_requirement, 
          storage_height_requirement, 
          storage_depth_requirement, 
          storage_volume_requirement, 
          storage_weight_requirement, 
          min_storage_temperature, 
          max_storage_temperature, 
          min_storage_humidity, 
          max_storage_humidity, 
          standard_putaway_qty, 
          reset_config_std_cost, 
          mandatory_expiration_date, 
          excl_ship_pack_proposal, 
          statistical_code, 
          acquisition_origin, 
          acquisition_reason_id
      INTO  temp_
      FROM  inventory_part_tab
      WHERE contract = contract_
      AND   part_no = part_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(contract_, part_no_, 'Get');
END Get;


-- Get_Objkey
--   Fetches the objkey attribute for a record.
@UncheckedAccess
FUNCTION Get_Objkey (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   rowkey_ inventory_part_tab.rowkey%TYPE;
BEGIN
   IF (contract_ IS NULL OR part_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT rowkey
      INTO  rowkey_
      FROM  inventory_part_tab
      WHERE contract = contract_
      AND   part_no = part_no_;
   RETURN rowkey_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(contract_, part_no_, 'Get_Objkey');
END Get_Objkey;



-------------------- COMPLEX STRUCTURE METHODS ------------------------------------

-------------------- FOUNDATION1 METHODS ------------------------------------


-- Init
--   Framework method that initializes this package.
@UncheckedAccess
PROCEDURE Init
IS
BEGIN
   NULL;
END Init;