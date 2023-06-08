-----------------------------------------------------------------------------
--
--  Logical unit: SiteInventInfo
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  --------------------------------------------------------
--  210628  RaMolk  SC21R2-1626, Added function Get_Ipr_Active
--  210615  LEPESE  SC21R2-794, Replaced temporary coding in Get_First_Viable_Posting_Date with call to User_Group_Period_API.Get_Min_Open_User_Grp_Date.
--  210610  LEPESE  SC21R2-794, Added defaults for attribute trans_cost_adj_post_date in Prepare_Insert___ and Check_Insert___.
--  210511  JiThlk  SCZ-14214, Remove attribute IprActive and all implementations related to this attribute.
--	 210430  LEPESE  SC21R2-794, added method Get_First_Viable_Posting_Date.
--  200114  SBalLK  Bug 151810(SCZ-8466), Modified Prepare_Insert___() and Check_Insert___() method to set 'FALSE' as default values for new 
--  200114          'EXEC_TRANSP_TASK_BACKGROUND' attribute which renamed from 'EXECUTE_TRANSPORT_ONLINE'.
--  191221  SBalLK  Bug 151508(SCZ-7902), Modified Prepare_Insert___() and Check_Insert___() method to set 'TRUE' as default values for new 
--  191221          'EXECUTE_TRANSPORT_ONLINE' attribute.
--  191202  SBalLK  Bug 151217 (SCZ-7215), Modified Get_Volume_Uom() method to return company defined volume UOM when connected base UOM have valid
--  191202          relationship defined for length and volume.
--  171128  DAYJLK  STRSC-13918, Modified Check_Insert___ and Prepare_Insert___ to set default values for new attribute reserv_from_transp_task.
--  170606  AwWelk  STRSC-8620, Modified Check_Insert___ to add values to ipr_active attribue. Added Modify_Ipr_Active___,
--  170606          Activate_Ipr() and Deactivate_Ipr(). Modified Check_Update___() by adding new parameter to skip user allowed check.
--  170606          Also modified Update___ to call Inventory_Part_Planning_API.Handle_Site_Ipr_Active_Change().
--  170310  LEPESE  LIM-3740, Added attributes auto_reserve_hu_optimized and auto_reserve_receipt_time. 
--  170306  LEPESE  LIM-3740, Removed obsolete attribute USE_ZONE_RANK_AUTO_RESERV.
--  170302  LEPESE  LIM-3740, Added attributes auto_reserve_prio1..auto_reserve_prio5.
--  170113  Khvese  LIM-10365, Modified methods Prepare_Insert___ and Check_Insert___ to set default value for PICK_BY_CHOICE_OPTION
--  161018  UdGnlk  LIM-8619, Added MOVE_RESERVATION_OPTION column and the default values.
--  160928  DaZase  LIM-7717, Default value has been introduced to COUNTING_PRINT_REPORT_OPT column.
--  160902  IzShlk  STRSC-4007, Default value has been introduced to FREEZE_STOCK_COUNT_REPORT column.
--  151120  JeLise  LIM-4369, Removed parameter pallet_drop_off_location_no_ and renamed nopall_drop_off_location_no_ in Clear_Whse_Storage_Chars__.
--  141022  AwWelk  GEN-42, Added UPPER_LIMIT_VERYSLOW_MOVER field and modified the validations in Check_Upper_Limits___().
--  140911  Erlise  PRSC-2475, Put to empty. Added attribute receipt_to_occupied_blocked.
--  140911          Added method Get_Receipt_To_Occup_Blkd_Src.
--  140528  JeLise  PBSC-9682, Changed the text for error message INVALIDCOUNTRY, in Check_Country_Region___.
--  140513  AwWelk  PBSC-8814, Modified New_Planning_Parameters__() to avoid duplicate inserts.
--  131017  Matkse  Added methods Get_Transport_From_Whse_Lvl_Db and Get_Transport_To_Whse_Lvl_Db.
--  130823  Erlise  Added ALLOW_DEVIATING_AVAIL_CTRL.
--  130822  Matkse  Modified Prepare_Insert___ and Unpack_Check_Insert___ to use new enumeration value for putaway refill option.
--  130620  Matkse  Modified Clear_Whse_Storage_Chars__ to accept flag for availability_control_id and drop-off bins.
--  130617  RiLase  Added AUTO_DROPOF_MAN_TRANS_TASK.
--  120904  JeLise  Changed from calling Part_Catalog_API methods to call the same methods in Part_Catalog_Invent_Attrib_API.
--  120830  Matkse  Modified Get_Bin_Volume_Capacity to only return capacity when volume uom is not null.
--  120829  Matkse  Added check for cubic capacity of bin_volume in Unpack_Check_Insert___ and Unpack_Check_Update___.
--  120823  MeAblk  Removed shipment_type and accordingly modified the respective methods.
--  120822  MeAblk  Unit test corrections done of the task BI-478.
--  120820  MeAblk  Added shipment_type and function Get_Shipment_Type. 
--  120810  Matkse  Modified Get_Bin_Volume_Cap_Source_Db_ to consider both operative and manual values when determine if volume is present
--  120608  MaEelk  Replaced the usage of Company_Distribution_Info_API with Company_Invent_Info_API.
--  120531  Matkse  Added bin_volume_capacity
--  120417  MaEelk  Modified Get_Bin_Volume_Capacity to return LEAST(bin_volume_capacity_,999999999999999999999999999) to avoid client errors
--  120417          when the return vlue exceeds 29 digits.
--  120315  MaEelk  Gave the correct name of check_Remove__ and Do_Remove__ when calling General_SYS.Init_Method.
--  120309  LEPESE  Added methods Get_Bin_Height_Cap_Source_Db, Get_Bin_Width_Cap_Source_Db, Get_Bin_Dept_Cap_Source_Db,
--  120309          Get_Bin_Carry_Cap_Source_Db, Get_Bin_Min_Temp_Source_Db, Get_Bin_Max_Temp_Source_Db, Get_Bin_Min_Humidity_Source_Db
--  120309          Get_Bin_Max_Humidity_Source_Db, Get_Bay_Carry_Cap_Source_Db, Get_Row_Carry_Cap_Source_Db, Get_Tier_Carry_Cap_Source_Db.
--  120208  Matkde  Added attribute putaway_zone_refill_option
--  120126  JeLise  Added attributes transport_from_whse_level, transport_to_whse_level, transport_part_cons_level,
--  120126          transport_ref_cons_level and transport_max_pallets.
--  111129  JeLise  Added use_zone_rank_auto_reserv.
--  111121  Jelise  Added method Clear_Whse_Storage_Chars__.
--  111103  JeLise  Added exclude_storage_req_val.
--  110916  DaZase  Added more parameters to Copy_Warehouses__.
--  110905  DaZase  Added method Get_Bin_Volume_Capacity.
--  110823  SurBlk  Bug 97779, Split the attribute inventory_value_method into two, by renaming existing one to  
--  110823          'manuf_inv_value_method' and adding attribute 'purch_inv_value_method' in to SITE_INVENT_INFO view.
--  110627  AwWelk  Bug 94516, Modified Prepare_Insert___() to set value to ABC_CLASS_PER_ASSET_CLASS_DB.
--  110405  DaZase  Added mix_of_lot_batch_no_blocked.
--  110302  ChJalk  Added user_allowed_site_pub filtering to the view VIEW_PLANNING.
--  101013  JeLise  Added mix_of_part_number_blocked and mix_of_cond_codes_blocked.
--  100922  JeLise  Moved Incorrect_Temperature_Range and Incorrect_Humidity_Range to Part_Catalog_API.
--  100902  DaZase  Added method Get_Volume_Uom.
--  100824  JeLise  Changed from calling Warehouse_Bay_Bin_API.Check_Humidity to Part_Catalog_API.Check_Humidity.
--  100630  PraWlk  Bug 90664, Modified reference for column contract in view SITE_INVENT_INFO to CUSTOMLIST.
--  100512  MaEelk  Added not null column ALLOW_PARTLOC_OWNER_MIX to SITE_INVENT_INFO_TAB. This will decide if the mix ownership is allowed
--  100512          in the location level or not. Added function Get_Allow_Partloc_Owner_Mix_Db.
--  100505  KRPELK  Merge Rose Method Documentation.
--  100630          Added new methods Check_Remove__() and Do_Remove__(). 
--  100212  Asawlk  Bug 88330, Modified Update___() to place the call to Invalidate_Cache___ right after the UPDATE clause.
--  ------------------------------- Eagle -----------------------------------
--  100115  DaZase  Added methods Get_Receipts_Blocked, Get_Receipts_Blocked_Db and Get_Receipts_Blocked_Source.
--  100114  RILASE  Added receipts_blocked.
--  091030  ShKolk  Bug 86768, Merge IPR to APP75 core.
--  090813  HoInlk  Bug 85273, Modified Prepare_Insert___ to set value to USE_PARTCA_DESC_INVENT_DB.
--  091027  LEPESE  Added calls from Unpack_Check_Insert___ and Unpack_Check_Update___
--  091027          to methods Warehouse_Bay_Bin_API.Check_Humidity,
--  091027          Warehouse_Bay_Bin_API.Check_Carrying_Capacity and
--  091027          Warehouse_Bay_Bin_API.Check_Cubic_Capacity where checks are centralized.
--  091021  LEPESE  Added methods Incorrect_Temperature_Range and Incorrect_Humidity_Range.
--  091021          Renamed Check_Bin_Humidity_Interval___ and Check_Bin_Temp_Interval___ into
--  091021          Check_Bin_Humidity_Range___ and Check_Bin_Temperature_Range___
--  091021          Modifications in Check_Bin_Humidity_Range___ and Check_Bin_Temperature_Range___
--  091021          to use the two new above mentioned methods.
--  091019  NaLrlk  Modified method Copy_Warehouses__ to check from_contract is user allowed site.
--  090904  LEPESE  Added methods Check_Bin_Temp_Interval___, Check_Bin_Humidity_Interval___,
--  090904          Check_Warehouse_Temperature___ and Check_Warehouse_Humidity___.
--  090904          Added calls to Check_Bin_Temp_Interval___ and Check_Bin_Humidity_Interval___
--  090904          from Unpack_Check_Insert___ and Unpack_Check_Update___. Added calls to 
--  090904          Check_Warehouse_Temperature___ and Check_Warehouse_Humidity___ from Update___. 
--  090825  LEPESE  Added method Copy_Warehouses__.
--  090819  NaLrlk  Added max weight bay, row and tier columns.
--  090707  NaLrlk  Added warehouse bin characteristics public columns and respective source functions.
--  090707          Implemented Micro Cache. Added new methods Invalidate_Cache___ and Update_Cache___.
--  090512  HoInlk  Bug 82673, Added public attribute default_qty_calc_round.
--  090512          Added method Check_Def_Qty_Calc_Round___.
--  060904  RoJalk  Modified Update___ to handle use_partca_desc_invent change.
--  060711  SeNslk  Added column use_partca_desc_invent.
--  060308  JoEd    Added column rounddiff_inactivity_days.
--  060109  MiKulk  Added the function Check_Exist.
--  051031  IsAnlk  Modified Check_Country_Region___ to check the country code.
--  051025  IsAnlk  Modified ILLEGAL_INVENT_VAL error message.
--  051013  JoEd    Added column cost_defaults_manually.
--  051012  IsAnlk  Modified method New.
--  051012  IsAnlk  Added method New.
--  051003  KeFelk  Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Check_Invoice_Consideration___
--   This method validates the Supplier Invoice Consideration attribute.
--   It is called during insert and update of sites.
PROCEDURE Check_Invoice_Consideration___ (
   contract_                  IN VARCHAR2,
   company_                   IN VARCHAR2,
   invoice_consideration_db_  IN VARCHAR2,
   purch_inv_value_method_db_ IN VARCHAR2,
   manuf_inv_value_method_db_ IN VARCHAR2  )
IS
   company_invent_rec_ Company_Invent_Info_API.Public_Rec;
BEGIN

   IF (invoice_consideration_db_ = 'PERIODIC WEIGHTED AVERAGE') THEN 
      IF (purch_inv_value_method_db_ != 'ST') OR (manuf_inv_value_method_db_ != 'ST') THEN
         Error_SYS.Record_General(lu_name_,'INCOPEWE: Supplier Invoice Consideration method Periodic Weighted Average is only allowed in combination with inventory valuation method Standard Cost.');
      END IF;
   END IF;

   IF (invoice_consideration_db_ = 'TRANSACTION BASED') THEN
      IF (purch_inv_value_method_db_ NOT IN ('ST', 'AV')) OR (manuf_inv_value_method_db_ NOT IN ('ST', 'AV')) THEN
         Error_SYS.Record_General(lu_name_,'NOSTACTCST: Supplier Invoice Consideration method Transaction Based is only allowed in combination with inventory valuation methods Weighted Average and Standard Cost.');
      END IF;
      company_invent_rec_ := Company_Invent_Info_API.Get(company_);
      IF (company_invent_rec_.ownership_transfer_point = 'RECEIPT INTO INVENTORY') THEN
         Error_SYS.Record_General(lu_name_, 'TRBARECININ: You cannot use Transaction Based Supplier Invoice Consideration on site :P1 since the Ownership Transfer Point on company :P2 is :P3.', contract_, company_, Ownership_Transfer_Point_API.Decode(company_invent_rec_.ownership_transfer_point));
      END IF;
   END IF;
END Check_Invoice_Consideration___;


-- Check_Country_Region___
--   This will handle region and country validations.
PROCEDURE Check_Country_Region___ (
   company_          IN VARCHAR2,
   region_code_      IN VARCHAR2,
   country_code_     IN VARCHAR2,
   delivery_address_ IN VARCHAR2 )
IS
   company_address_rec_ Company_Address_API.Public_Rec;
   dummy_               NUMBER;

   CURSOR check_region_country IS
      SELECT 1
        FROM country_region_tab
       WHERE country_code = country_code_;
BEGIN
   IF (country_code_ IS NOT NULL) THEN
      OPEN check_region_country;
      FETCH check_region_country INTO dummy_;

      IF (check_region_country%NOTFOUND) THEN
         CLOSE check_region_country;
         Error_SYS.Record_General(lu_name_,'INVALIDCOUNTRY: The country code for Special Intrastat Data can only be one of the countries found in the LOV.');
      ELSE
         CLOSE check_region_country;
      END IF;
   END IF;

   IF (region_code_ IS NULL) THEN
      IF (country_code_ IS NOT NULL) THEN
         Error_SYS.Record_General(lu_name_,'NOREGCODE: Country code cannot be saved without a region code.');
      END IF;
   ELSE
      IF (delivery_address_ IS NULL) THEN
         Error_SYS.Record_General(lu_name_,'NODELIVADDR: A region cannot be saved for this site without first specifying a delivery address.');
      ELSE
         company_address_rec_ := Company_Address_API.Get(company_, delivery_address_);
         IF (company_address_rec_.country != country_code_) THEN
            Error_SYS.Record_General(lu_name_,'NOTSAMECOUNTRY: You can only select a region belonging to country :P1.', company_address_rec_.country);
         END IF;
      END IF;
   END IF;
END Check_Country_Region___;


PROCEDURE Check_Def_Qty_Calc_Round___ (
   default_qty_calc_round_ IN NUMBER )
IS
BEGIN
   IF ((default_qty_calc_round_ > 20) OR (default_qty_calc_round_ < 0)
       OR (MOD(default_qty_calc_round_, 1) != 0)) THEN
      Error_SYS.Record_General(lu_name_, 'INVALIDQTYCALCROUND: Default Qty Calc Rounding must be an integer between 0 and 20.');
   END IF;
END Check_Def_Qty_Calc_Round___;


FUNCTION Get_Attr_With_Keys_Removed___ (
   attr_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   new_attr_ VARCHAR2(2000);
   ptr_      NUMBER;
   name_     VARCHAR2(30);
   value_    VARCHAR2(2000);
BEGIN
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ NOT IN ('CONTRACT', 'COMPANY')) THEN
         Client_SYS.Add_To_Attr(name_, value_, new_attr_);
      END IF;
   END LOOP;
   RETURN new_attr_;
END Get_Attr_With_Keys_Removed___;


FUNCTION Inactive_Planning_Attr___ (
   record_ IN SITE_INVENT_INFO_TAB%ROWTYPE ) RETURN BOOLEAN
IS
   inactive_ BOOLEAN := FALSE;
BEGIN
   IF ((record_.service_level_rate      IS NULL) AND
       (record_.ordering_cost           IS NULL) AND
       (record_.inventory_interest_rate IS NULL)) THEN
      inactive_ := TRUE;
   END IF;

   RETURN inactive_;
END Inactive_Planning_Attr___;


PROCEDURE Error_If_Plan_Attr_Inactive___ (
   record_ IN SITE_INVENT_INFO_TAB%ROWTYPE )
IS
BEGIN

   IF (Inactive_Planning_Attr___(record_)) THEN
      Error_SYS.Record_General(lu_name_,'INACTIVE: At least one of the columns must have a value.');
   END IF;
END Error_If_Plan_Attr_Inactive___;


PROCEDURE Modify___ (
   info_                       OUT    VARCHAR2,
   objid_                      IN     VARCHAR2,
   objversion_                 IN OUT VARCHAR2,
   attr_                       IN OUT VARCHAR2,
   action_                     IN     VARCHAR2,
   check_inactive_plan_params_ IN     BOOLEAN)
IS
   oldrec_ SITE_INVENT_INFO_TAB%ROWTYPE;
   newrec_ SITE_INVENT_INFO_TAB%ROWTYPE;
   indrec_ Indicator_Rec;
BEGIN
   IF (action_ = 'CHECK') THEN
      newrec_ := Get_Object_By_Id___(objid_);
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_, check_inactive_plan_params_);
   ELSIF (action_ = 'DO') THEN
      oldrec_ := Lock_By_Id___(objid_, objversion_);
      newrec_ := oldrec_;
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_, check_inactive_plan_params_);
      Update___(objid_, oldrec_, newrec_, attr_, objversion_);
   END IF;
   info_ := Client_SYS.Get_All_Info;
END Modify___;


PROCEDURE Check_Upper_Limits___(
   upper_limit_veryslow_mover_  IN NUMBER,
   upper_limit_slow_mover_      IN NUMBER,
   upper_limit_medium_mover_    IN NUMBER)
IS
BEGIN
   -- Validate that limits. 
   IF (upper_limit_veryslow_mover_ != ROUND(upper_limit_veryslow_mover_) OR
       upper_limit_slow_mover_     != ROUND(upper_limit_slow_mover_) OR
       upper_limit_medium_mover_   != ROUND(upper_limit_medium_mover_) OR
       upper_limit_veryslow_mover_ < 0 OR upper_limit_slow_mover_ < 0 OR upper_limit_medium_mover_ < 0) THEN
      Error_SYS.Record_General(lu_name_,'ERRORFREQLIMITSINTEGER: Upper frequency limits must be integers greater than or equal to 0');
   END IF;
  -- Check that slow movers limit is not equal or greater than medium movers limit.
   IF (upper_limit_veryslow_mover_ >= upper_limit_slow_mover_) THEN 
      Error_SYS.Record_General(lu_name_,'ERRORFREQLIMITSVSLOWMOVER: Upper Frequency Limit - Slow Movers must be larger than Upper Frequency Limit - Very Slow Movers.');
   ELSIF(upper_limit_slow_mover_ >= upper_limit_medium_mover_) THEN
      Error_SYS.Record_General(lu_name_,'ERRORFREQLIMITS: Upper Frequency Limit - Medium Movers must be larger than Upper Frequency Limit - Slow Movers.');
   END IF;
END Check_Upper_Limits___;


PROCEDURE Check_Negative_On_Hand___(
   negative_on_hand_db_       IN VARCHAR2,
   purch_inv_value_method_db_ IN VARCHAR2,
   manuf_inv_value_method_db_ IN VARCHAR2 )
IS
    value_method_error_         BOOLEAN := FALSE;
    erroneus_validation_method_ VARCHAR2(20);
BEGIN
   IF (negative_on_hand_db_ = 'NEG ONHAND OK') THEN
      IF (purch_inv_value_method_db_ IN ('AV', 'FIFO', 'LIFO')) THEN
         value_method_error_         := TRUE;
         erroneus_validation_method_ := Inventory_Value_Method_API.Decode(purch_inv_value_method_db_);
      ELSIF (manuf_inv_value_method_db_ IN ('AV', 'FIFO', 'LIFO')) THEN
         value_method_error_         := TRUE;
         erroneus_validation_method_ := Inventory_Value_Method_API.Decode(manuf_inv_value_method_db_);
      END IF;
      IF (value_method_error_) THEN
         Error_SYS.Record_General(lu_name_, 'ILLEGAL_INVENT_VAL: Negative quantity onhand is not allowed for inventory valuation method :P1.', erroneus_validation_method_);
      END IF;        
   END IF;
END Check_Negative_On_Hand___ ;


PROCEDURE Check_Ext_Servi_Cost_Method___(
   ext_service_cost_method_db_   IN VARCHAR2,
   purch_inv_value_method_db_    IN VARCHAR2,
   manuf_inv_value_method_db_    IN VARCHAR2)
IS
BEGIN
   IF (purch_inv_value_method_db_ = 'ST') OR (manuf_inv_value_method_db_ = 'ST') THEN 
      IF (ext_service_cost_method_db_ = 'INCLUDE SERVICE COST') THEN
         Error_SYS.Record_General(lu_name_,'INVALSCOMETHOD: The combination of External Service Cost Method "Include Service Cost" and the Inventory Valuation Method "Standard Cost" is not allowed as a default setting');
      END IF;
   END IF;
END Check_Ext_Servi_Cost_Method___ ;


PROCEDURE Check_Bin_Temperature_Range___ (
   bin_min_temperature_ IN NUMBER,
   bin_max_temperature_ IN NUMBER )
IS
BEGIN

   IF (Part_Catalog_Invent_Attrib_API.Incorrect_Temperature_Range(bin_min_temperature_, bin_max_temperature_)) THEN
      Error_SYS.Record_General(lu_name_, 'TEMPRANGE: Incorrect Temperature Range.');
   END IF;
END Check_Bin_Temperature_Range___;


PROCEDURE Check_Bin_Humidity_Range___ (
   bin_min_humidity_ IN NUMBER,
   bin_max_humidity_ IN NUMBER )
IS
BEGIN

   IF (Part_Catalog_Invent_Attrib_API.Incorrect_Humidity_Range(bin_min_humidity_, bin_max_humidity_)) THEN
      Error_SYS.Record_General(lu_name_, 'HUMIDRANGE: Incorrect Humidity Range.');
   END IF;
END Check_Bin_Humidity_Range___;


PROCEDURE Check_Warehouse_Temperature___ (
   contract_ IN VARCHAR2)
IS
   CURSOR get_warehouses IS
      SELECT warehouse_id
        FROM warehouse_tab
       WHERE contract = contract_
         AND (bin_min_temperature IS NULL OR bin_max_temperature IS NULL);
BEGIN

   FOR warehouse_rec_ IN get_warehouses LOOP
      Warehouse_API.Check_Bin_Temperature_Range(contract_, warehouse_rec_.warehouse_id);
   END LOOP;
END Check_Warehouse_Temperature___;


PROCEDURE Check_Warehouse_Humidity___ (
   contract_ IN VARCHAR2)
IS
   CURSOR get_warehouses IS
      SELECT warehouse_id
        FROM warehouse_tab
       WHERE contract = contract_
         AND (bin_min_humidity IS NULL OR bin_max_humidity IS NULL);
BEGIN

   FOR warehouse_rec_ IN get_warehouses LOOP
      Warehouse_API.Check_Bin_Humidity_Range(contract_, warehouse_rec_.warehouse_id);
   END LOOP;
END Check_Warehouse_Humidity___;


PROCEDURE Cleanup_Auto_Reserve_Prio___ (
   newrec_ IN OUT site_invent_info_tab%ROWTYPE )
IS
BEGIN
   -- Remove Handling Unit related values if Handling Unit Optimization is not selected
   IF (newrec_.auto_reserve_hu_optimized = Fnd_Boolean_API.DB_FALSE) THEN
      IF (newrec_.auto_reserve_prio1 IN (Invent_Auto_Reserve_Prio_API.DB_HANDLING_UNIT_QTY,
                                         Invent_Auto_Reserve_Prio_API.DB_HANDLING_UNIT_LEVEL)) THEN
         newrec_.auto_reserve_prio1 := NULL;
      END IF;
      IF (newrec_.auto_reserve_prio2 IN (Invent_Auto_Reserve_Prio_API.DB_HANDLING_UNIT_QTY,
                                         Invent_Auto_Reserve_Prio_API.DB_HANDLING_UNIT_LEVEL)) THEN
         newrec_.auto_reserve_prio2 := NULL;
      END IF;
      IF (newrec_.auto_reserve_prio3 IN (Invent_Auto_Reserve_Prio_API.DB_HANDLING_UNIT_QTY,
                                         Invent_Auto_Reserve_Prio_API.DB_HANDLING_UNIT_LEVEL)) THEN
         newrec_.auto_reserve_prio3 := NULL;
      END IF;
      IF (newrec_.auto_reserve_prio4 IN (Invent_Auto_Reserve_Prio_API.DB_HANDLING_UNIT_QTY,
                                         Invent_Auto_Reserve_Prio_API.DB_HANDLING_UNIT_LEVEL)) THEN
         newrec_.auto_reserve_prio4 := NULL;
      END IF;
      IF (newrec_.auto_reserve_prio5 IN (Invent_Auto_Reserve_Prio_API.DB_HANDLING_UNIT_QTY,
                                         Invent_Auto_Reserve_Prio_API.DB_HANDLING_UNIT_LEVEL)) THEN
         newrec_.auto_reserve_prio5 := NULL;
      END IF;
   END IF;
   -- Remove duplicate values
   IF (newrec_.auto_reserve_prio2 = newrec_.auto_reserve_prio1) THEN
      newrec_.auto_reserve_prio2 := NULL;
   END IF;
   IF (newrec_.auto_reserve_prio3 = newrec_.auto_reserve_prio1) THEN
      newrec_.auto_reserve_prio3 := NULL;
   END IF;
   IF (newrec_.auto_reserve_prio4 = newrec_.auto_reserve_prio1) THEN
      newrec_.auto_reserve_prio4 := NULL;
   END IF;
   IF (newrec_.auto_reserve_prio5 = newrec_.auto_reserve_prio1) THEN
      newrec_.auto_reserve_prio5 := NULL;
   END IF;
   IF (newrec_.auto_reserve_prio3 = newrec_.auto_reserve_prio2) THEN
      newrec_.auto_reserve_prio3 := NULL;
   END IF;
   IF (newrec_.auto_reserve_prio4 = newrec_.auto_reserve_prio2) THEN
      newrec_.auto_reserve_prio4 := NULL;
   END IF;
   IF (newrec_.auto_reserve_prio5 = newrec_.auto_reserve_prio2) THEN
      newrec_.auto_reserve_prio5 := NULL;
   END IF;
   IF (newrec_.auto_reserve_prio4 = newrec_.auto_reserve_prio3) THEN
      newrec_.auto_reserve_prio4 := NULL;
   END IF;
   IF (newrec_.auto_reserve_prio5 = newrec_.auto_reserve_prio3) THEN
      newrec_.auto_reserve_prio5 := NULL;
   END IF;
   IF (newrec_.auto_reserve_prio5 = newrec_.auto_reserve_prio4) THEN
      newrec_.auto_reserve_prio5 := NULL;
   END IF;
   -- Move values upwards so that no gaps exist between values in the list.
   IF (newrec_.auto_reserve_prio1 IS NULL) THEN
      IF (newrec_.auto_reserve_prio2 IS NOT NULL) THEN
         newrec_.auto_reserve_prio1 := newrec_.auto_reserve_prio2;
         newrec_.auto_reserve_prio2 := NULL;
      ELSIF (newrec_.auto_reserve_prio3 IS NOT NULL) THEN
         newrec_.auto_reserve_prio1 := newrec_.auto_reserve_prio3;
         newrec_.auto_reserve_prio3 := NULL;
      ELSIF (newrec_.auto_reserve_prio4 IS NOT NULL) THEN
         newrec_.auto_reserve_prio1 := newrec_.auto_reserve_prio4;
         newrec_.auto_reserve_prio4 := NULL;
      ELSIF (newrec_.auto_reserve_prio5 IS NOT NULL) THEN
         newrec_.auto_reserve_prio1 := newrec_.auto_reserve_prio5;
         newrec_.auto_reserve_prio5 := NULL;
      END IF;
   END IF;

   IF (newrec_.auto_reserve_prio2 IS NULL) THEN
      IF (newrec_.auto_reserve_prio3 IS NOT NULL) THEN
         newrec_.auto_reserve_prio2 := newrec_.auto_reserve_prio3;
         newrec_.auto_reserve_prio3 := NULL;
      ELSIF (newrec_.auto_reserve_prio4 IS NOT NULL) THEN
         newrec_.auto_reserve_prio2 := newrec_.auto_reserve_prio4;
         newrec_.auto_reserve_prio4 := NULL;
      ELSIF (newrec_.auto_reserve_prio5 IS NOT NULL) THEN
         newrec_.auto_reserve_prio2 := newrec_.auto_reserve_prio5;
         newrec_.auto_reserve_prio5 := NULL;
      END IF;
   END IF;

   IF (newrec_.auto_reserve_prio3 IS NULL) THEN
      IF (newrec_.auto_reserve_prio4 IS NOT NULL) THEN
         newrec_.auto_reserve_prio3 := newrec_.auto_reserve_prio4;
         newrec_.auto_reserve_prio4 := NULL;
      ELSIF (newrec_.auto_reserve_prio5 IS NOT NULL) THEN
         newrec_.auto_reserve_prio3 := newrec_.auto_reserve_prio5;
         newrec_.auto_reserve_prio5 := NULL;
      END IF;
   END IF;

   IF (newrec_.auto_reserve_prio4 IS NULL) THEN
      IF (newrec_.auto_reserve_prio5 IS NOT NULL) THEN
         newrec_.auto_reserve_prio4 := newrec_.auto_reserve_prio5;
         newrec_.auto_reserve_prio5 := NULL;
      END IF;
   END IF;
END Cleanup_Auto_Reserve_Prio___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('NEGATIVE_ON_HAND',              Negative_On_Hand_API.Decode('NEG ONHAND OK'),               attr_);
   Client_SYS.Add_To_Attr('PURCH_INV_VALUE_METHOD',        Inventory_Value_Method_API.Decode('ST'),                    attr_);
   Client_SYS.Add_To_Attr('MANUF_INV_VALUE_METHOD',        Inventory_Value_Method_API.Decode('ST'),                    attr_);
   Client_SYS.Add_To_Attr('PICKING_LEADTIME',              0,                                                          attr_);
   Client_SYS.Add_To_Attr('INVOICE_CONSIDERATION',         Invoice_Consideration_API.Decode('IGNORE INVOICE PRICE'),   attr_);
   Client_SYS.Add_To_Attr('INVOICE_CONSIDERATION_DB',      'IGNORE INVOICE PRICE',                                     attr_);
   Client_SYS.Add_To_Attr('EXT_SERVICE_COST_METHOD',       Ext_Service_Cost_Method_API.Decode('EXCLUDE SERVICE COST'), attr_);
   Client_SYS.Add_To_Attr('AVG_WORK_DAYS_PER_WEEK',        5,                                                          attr_);
   Client_SYS.Add_To_Attr('COST_DEFAULTS_MANUALLY_DB',     Fnd_Boolean_API.db_false,                                   attr_);
   Client_SYS.Add_To_Attr('ROUNDDIFF_INACTIVITY_DAYS',     0,                                                          attr_);
   Client_SYS.Add_To_Attr('USE_PARTCA_DESC_INVENT_DB',     Fnd_Boolean_API.db_false,                                   attr_);
   Client_SYS.Add_To_Attr('DEFAULT_QTY_CALC_ROUND',        16,                                                         attr_);
   Client_SYS.Add_To_Attr('ABC_CLASS_PER_ASSET_CLASS_DB',  Fnd_Boolean_API.db_false,                                   attr_);
   Client_SYS.Add_To_Attr('UPPER_LIMIT_VERYSLOW_MOVER',    1,                                                          attr_);
   Client_SYS.Add_To_Attr('UPPER_LIMIT_SLOW_MOVER',        10,                                                         attr_);
   Client_SYS.Add_To_Attr('UPPER_LIMIT_MEDIUM_MOVER',      100,                                                        attr_);
   Client_SYS.Add_To_Attr('ALLOW_PARTLOC_OWNER_MIX_DB',    Fnd_Boolean_API.db_false,                                   attr_);
   Client_SYS.Add_To_Attr('TRANSPORT_FROM_WHSE_LEVEL_DB',  Warehouse_Structure_Level_API.db_bin,                       attr_);
   Client_SYS.Add_To_Attr('TRANSPORT_TO_WHSE_LEVEL_DB',    Warehouse_Structure_Level_API.db_bin,                       attr_);
   Client_SYS.Add_To_Attr('TRANSPORT_PART_CONS_LEVEL_DB',  Transport_Part_Cons_Level_API.db_single_configuration,      attr_);
   Client_SYS.Add_To_Attr('TRANSPORT_REF_CONS_LEVEL_DB',   Transport_Ref_Cons_Level_API.db_single_reference,           attr_);
   Client_SYS.Add_To_Attr('PUTAWAY_ZONE_REFILL_OPTION',    Putaway_Zone_Refill_Option_API.Decode('NO_AUTO_REFILL'),    attr_);
   Client_SYS.Add_To_Attr('PUTAWAY_ZONE_REFILL_OPTION_DB', Putaway_Zone_Refill_Option_API.DB_NO_REFILL,                attr_);
   Client_SYS.Add_To_Attr('AUTO_DROPOF_MAN_TRANS_TASK',    Fnd_Boolean_API.db_true,                                    attr_);
   Client_SYS.Add_To_Attr('ALLOW_DEVIATING_AVAIL_CTRL',    Fnd_Boolean_API.db_false,                                   attr_);
   Client_SYS.Add_To_Attr('EXEC_TRANSP_TASK_BACKGROUND_DB',   Fnd_Boolean_API.DB_FALSE,                                attr_);
   Client_SYS.Add_To_Attr('RESET_CONFIG_STD_COST_DB',      Fnd_Boolean_API.db_false,                                   attr_);
   Client_SYS.Add_To_Attr('FREEZE_STOCK_COUNT_REPORT_DB',  Fnd_Boolean_API.DB_TRUE,                                    attr_);
   Client_SYS.Add_To_Attr('COUNTING_PRINT_REPORT_OPT',     Invent_Report_Print_Option_API.Decode('DETAILED'),          attr_);
   Client_SYS.Add_To_Attr('COUNTING_PRINT_REPORT_OPT_DB',  Invent_Report_Print_Option_API.db_detailed,                 attr_);
   Client_SYS.Add_To_Attr('MOVE_RESERVATION_OPTION_DB',    Reservat_Adjustment_Option_API.db_not_allowed,              attr_);
   Client_SYS.Add_To_Attr('PICK_BY_CHOICE_OPTION_DB',      Reservat_Adjustment_Option_API.db_not_allowed,              attr_);
   Client_SYS.Add_To_Attr('AUTO_RESERVE_PRIO1_DB',         Invent_Auto_Reserve_Prio_API.DB_PUTAWAY_ZONE_RANKING,       attr_);
   Client_SYS.Add_To_Attr('AUTO_RESERVE_PRIO2_DB',         Invent_Auto_Reserve_Prio_API.DB_EXPIRATION_DATE,            attr_);
   Client_SYS.Add_To_Attr('AUTO_RESERVE_PRIO3_DB',         Invent_Auto_Reserve_Prio_API.DB_RECEIPT_DATE,               attr_);
   Client_SYS.Add_To_Attr('AUTO_RESERVE_PRIO4_DB',         Invent_Auto_Reserve_Prio_API.DB_HANDLING_UNIT_QTY,          attr_);
   Client_SYS.Add_To_Attr('AUTO_RESERVE_PRIO5_DB',         Invent_Auto_Reserve_Prio_API.DB_HANDLING_UNIT_LEVEL,        attr_);
   Client_SYS.Add_To_Attr('AUTO_RESERVE_HU_OPTIMIZED_DB',  Fnd_Boolean_API.DB_TRUE,                                    attr_);
   Client_SYS.Add_To_Attr('AUTO_RESERVE_RECEIPT_TIME_DB',  Fnd_Boolean_API.DB_FALSE,                                   attr_);
   Client_SYS.Add_To_Attr('RESERV_FROM_TRANSP_TASK',       Reserve_From_Transp_Task_API.DB_NO,                         attr_);
   Client_SYS.Add_To_Attr('CASCAD_POSTING_DATE_OPTION_DB', Adjust_Posting_Date_Option_API.DB_SYSTEM_DATE,              attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT SITE_INVENT_INFO_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.latest_plan_activity_time := sysdate;
   super(objid_, objversion_, newrec_, attr_);

   Client_SYS.Add_To_Attr('AUTO_RESERVE_PRIO1_DB', newrec_.auto_reserve_prio1, attr_);
   Client_SYS.Add_To_Attr('AUTO_RESERVE_PRIO2_DB', newrec_.auto_reserve_prio2, attr_);
   Client_SYS.Add_To_Attr('AUTO_RESERVE_PRIO3_DB', newrec_.auto_reserve_prio3, attr_);
   Client_SYS.Add_To_Attr('AUTO_RESERVE_PRIO4_DB', newrec_.auto_reserve_prio4, attr_);
   Client_SYS.Add_To_Attr('AUTO_RESERVE_PRIO5_DB', newrec_.auto_reserve_prio5, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     SITE_INVENT_INFO_TAB%ROWTYPE,
   newrec_     IN OUT SITE_INVENT_INFO_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   number_null_ NUMBER := -9999999;
   batch_desc_   VARCHAR2(500);
   attrib_       VARCHAR2(200);
BEGIN
   IF ((NVL(newrec_.service_level_rate,      number_null_) !=
        NVL(oldrec_.service_level_rate,      number_null_))   OR
       (NVL(newrec_.ordering_cost,           number_null_) !=
        NVL(oldrec_.ordering_cost,           number_null_))   OR
       (NVL(newrec_.inventory_interest_rate, number_null_) !=
        NVL(oldrec_.inventory_interest_rate, number_null_)))  THEN
      -- As soon as any of the above attributes are updated we need to set a new
      -- time stamp in latest_plan_activity_time.
      newrec_.latest_plan_activity_time := sysdate;
   END IF;

   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);

   IF ((NVL(newrec_.bin_min_temperature, number_null_) != NVL(oldrec_.bin_min_temperature, number_null_)) OR
       (NVL(newrec_.bin_max_temperature, number_null_) != NVL(oldrec_.bin_max_temperature, number_null_))) THEN
      Check_Warehouse_Temperature___(newrec_.contract);
   END IF;

   IF ((NVL(newrec_.bin_min_humidity, number_null_) != NVL(oldrec_.bin_min_humidity, number_null_)) OR
       (NVL(newrec_.bin_max_humidity, number_null_) != NVL(oldrec_.bin_max_humidity, number_null_))) THEN
      Check_Warehouse_Humidity___(newrec_.contract);
   END IF;
   
   IF (newrec_.use_partca_desc_invent != oldrec_.use_partca_desc_invent) THEN
      Inventory_Part_API.Handle_Partca_Desc_Flag_Change(newrec_.contract);
   END IF;

   Client_SYS.Add_To_Attr('AUTO_RESERVE_PRIO1_DB', newrec_.auto_reserve_prio1, attr_);
   Client_SYS.Add_To_Attr('AUTO_RESERVE_PRIO2_DB', newrec_.auto_reserve_prio2, attr_);
   Client_SYS.Add_To_Attr('AUTO_RESERVE_PRIO3_DB', newrec_.auto_reserve_prio3, attr_);
   Client_SYS.Add_To_Attr('AUTO_RESERVE_PRIO4_DB', newrec_.auto_reserve_prio4, attr_);
   Client_SYS.Add_To_Attr('AUTO_RESERVE_PRIO5_DB', newrec_.auto_reserve_prio5, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
   WHEN OTHERS THEN
      Invalidate_Cache___;
      RAISE;
END Update___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     site_invent_info_tab%ROWTYPE,
   newrec_ IN OUT NOCOPY site_invent_info_tab%ROWTYPE,
   indrec_ IN OUT NOCOPY Indicator_Rec,
   attr_   IN OUT NOCOPY VARCHAR2 )
IS
   site_rec_    Site_API.Public_Rec;
BEGIN
   Cleanup_Auto_Reserve_Prio___(newrec_);

   IF ((Validate_SYS.Is_Changed(newrec_.auto_reserve_hu_optimized, oldrec_.auto_reserve_hu_optimized)) AND
       (newrec_.auto_reserve_hu_optimized = Fnd_Boolean_API.DB_TRUE)) THEN
      -- Reintroduce the Handling Unit related priority rules when Handling Unit optimized reservation is enable.
      IF (newrec_.auto_reserve_prio1 IS NULL) THEN
         newrec_.auto_reserve_prio1 := Invent_Auto_Reserve_Prio_API.DB_HANDLING_UNIT_QTY;
      ELSIF (newrec_.auto_reserve_prio2 IS NULL) THEN
         newrec_.auto_reserve_prio2 := Invent_Auto_Reserve_Prio_API.DB_HANDLING_UNIT_QTY;
      ELSIF (newrec_.auto_reserve_prio3 IS NULL) THEN
         newrec_.auto_reserve_prio3 := Invent_Auto_Reserve_Prio_API.DB_HANDLING_UNIT_QTY;
      ELSIF (newrec_.auto_reserve_prio4 IS NULL) THEN
         newrec_.auto_reserve_prio4 := Invent_Auto_Reserve_Prio_API.DB_HANDLING_UNIT_QTY;
      ELSIF (newrec_.auto_reserve_prio5 IS NULL) THEN
         newrec_.auto_reserve_prio5 := Invent_Auto_Reserve_Prio_API.DB_HANDLING_UNIT_QTY;
      END IF;
      IF (newrec_.auto_reserve_prio2 IS NULL) THEN
         newrec_.auto_reserve_prio2 := Invent_Auto_Reserve_Prio_API.DB_HANDLING_UNIT_LEVEL;
      ELSIF (newrec_.auto_reserve_prio3 IS NULL) THEN
         newrec_.auto_reserve_prio3 := Invent_Auto_Reserve_Prio_API.DB_HANDLING_UNIT_LEVEL;
      ELSIF (newrec_.auto_reserve_prio4 IS NULL) THEN
         newrec_.auto_reserve_prio4 := Invent_Auto_Reserve_Prio_API.DB_HANDLING_UNIT_LEVEL;
      ELSIF (newrec_.auto_reserve_prio5 IS NULL) THEN
         newrec_.auto_reserve_prio5 := Invent_Auto_Reserve_Prio_API.DB_HANDLING_UNIT_LEVEL;
      END IF;
      Cleanup_Auto_Reserve_Prio___(newrec_);
   END IF;

   super(oldrec_, newrec_, indrec_, attr_);

   Check_Negative_On_Hand___(newrec_.negative_on_hand, newrec_.purch_inv_value_method, newrec_.manuf_inv_value_method);

   IF (newrec_.picking_leadtime != trunc(newrec_.picking_leadtime)) OR (newrec_.picking_leadtime < 0)  THEN
      Error_SYS.Item_General(lu_name_, 'PICKING_LEADTIME', 'VALUEINTEGER: [:NAME] must be an integer. Negative values not allowed.');
   END IF;

   IF ((newrec_.count_diff_percentage < 0) OR (newrec_.count_diff_amount < 0)) THEN
      Error_Sys.Record_General(lu_name_,'COUNTDIFFINTEGER: Negative values not allowed');
   END IF;

   IF (newrec_.rounddiff_inactivity_days != trunc(newrec_.rounddiff_inactivity_days)) OR (newrec_.rounddiff_inactivity_days < 0) THEN
      Error_SYS.Item_General(lu_name_, 'ROUNDDIFF_INACTIVITY_DAYS', 'VALUEINTEGER: [:NAME] must be an integer. Negative values not allowed.');
   END IF;

   Check_Bin_Temperature_Range___(newrec_.bin_min_temperature, newrec_.bin_max_temperature);
   Check_Bin_Humidity_Range___   (newrec_.bin_min_humidity, newrec_.bin_max_humidity);
   Check_Def_Qty_Calc_Round___   (newrec_.default_qty_calc_round);

   site_rec_ := Site_API.Get(newrec_.contract);

   IF ((Validate_SYS.Is_Different(newrec_.invoice_consideration , oldrec_.invoice_consideration))  OR
       (Validate_SYS.Is_Different(newrec_.purch_inv_value_method, oldrec_.purch_inv_value_method)) OR 
       (Validate_SYS.Is_Different(newrec_.manuf_inv_value_method, oldrec_.manuf_inv_value_method))) THEN

      Check_Invoice_Consideration___(newrec_.contract,
                                     site_rec_.company,
                                     newrec_.invoice_consideration,
                                     newrec_.purch_inv_value_method,
                                     newrec_.manuf_inv_value_method);
   END IF;

   Check_Ext_Servi_Cost_Method___(newrec_.ext_service_cost_method, newrec_.purch_inv_value_method, newrec_.manuf_inv_value_method);

   IF (newrec_.avg_work_days_per_week < 0) THEN
      Error_Sys.Record_General(lu_name_, 'NEGATIVEAWDAYS: Negative values not allowed for average working days per week.');
   ELSIF (newrec_.avg_work_days_per_week > 7) THEN
      Error_Sys.Record_General(lu_name_, 'INVALIDAWDAYS: The average working days per week cannot be greater than 7.');
   END IF;

   Check_Country_Region___(site_rec_.company,
                           newrec_.region_code,
                           newrec_.country_code,
                           site_rec_.delivery_address );

   Company_Invent_Info_API.Check_Hierarchy_Attributes(newrec_.service_level_rate,
                                                      newrec_.ordering_cost,
                                                      newrec_.inventory_interest_rate,
                                                      oldrec_.service_level_rate,
                                                      oldrec_.ordering_cost,
                                                      oldrec_.inventory_interest_rate);

   Check_Upper_Limits___(newrec_.upper_limit_veryslow_mover, newrec_.upper_limit_slow_mover, newrec_.upper_limit_medium_mover);
   
   Part_Catalog_Invent_Attrib_API.Check_Cubic_Capacity   (newrec_.bin_height_capacity);
   Part_Catalog_Invent_Attrib_API.Check_Cubic_Capacity   (newrec_.bin_width_capacity);
   Part_Catalog_Invent_Attrib_API.Check_Cubic_Capacity   (newrec_.bin_dept_capacity);
   Part_Catalog_Invent_Attrib_API.Check_Cubic_Capacity   (newrec_.bin_volume_capacity);
   Part_Catalog_Invent_Attrib_API.Check_Carrying_Capacity(newrec_.bay_carrying_capacity);
   Part_Catalog_Invent_Attrib_API.Check_Carrying_Capacity(newrec_.row_carrying_capacity);
   Part_Catalog_Invent_Attrib_API.Check_Carrying_Capacity(newrec_.tier_carrying_capacity);
   Part_Catalog_Invent_Attrib_API.Check_Carrying_Capacity(newrec_.bin_carrying_capacity);
   Part_Catalog_Invent_Attrib_API.Check_Humidity         (newrec_.bin_min_humidity);
   Part_Catalog_Invent_Attrib_API.Check_Humidity         (newrec_.bin_max_humidity);

END Check_Common___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT site_invent_info_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_     VARCHAR2(30);
   value_    VARCHAR2(4000);
BEGIN
   IF NOT (indrec_.negative_on_hand) THEN
      newrec_.negative_on_hand            := 'NEG ONHAND OK';
   END IF;
   IF NOT (indrec_.purch_inv_value_method) THEN
      newrec_.purch_inv_value_method      := 'ST';
   END IF;
   IF NOT (indrec_.manuf_inv_value_method) THEN
      newrec_.manuf_inv_value_method      := 'ST';
   END IF;
   IF NOT (indrec_.picking_leadtime) THEN
      newrec_.picking_leadtime            := 0;
   END IF;
   IF NOT (indrec_.invoice_consideration) THEN
      newrec_.invoice_consideration       := 'IGNORE INVOICE PRICE';
   END IF;
   IF NOT (indrec_.ext_service_cost_method) THEN
      newrec_.ext_service_cost_method     := 'EXCLUDE SERVICE COST';
   END IF;
   IF NOT (indrec_.avg_work_days_per_week) THEN
      newrec_.avg_work_days_per_week      := 5;
   END IF;
   IF NOT (indrec_.cost_defaults_manually) THEN
      newrec_.cost_defaults_manually      := Fnd_Boolean_API.db_false;
   END IF;
   IF NOT (indrec_.rounddiff_inactivity_days) THEN
      newrec_.rounddiff_inactivity_days   := 0;
   END IF;
   IF NOT (indrec_.use_partca_desc_invent) THEN
      newrec_.use_partca_desc_invent      := Fnd_Boolean_API.db_false;
   END IF;
   IF NOT (indrec_.default_qty_calc_round) THEN
      newrec_.default_qty_calc_round      := 16;
   END IF;
   IF NOT (indrec_.receipts_blocked) THEN
      newrec_.receipts_blocked            := Fnd_Boolean_API.db_false;
   END IF;
   IF NOT (indrec_.receipt_to_occupied_blocked) THEN
      newrec_.receipt_to_occupied_blocked := Fnd_Boolean_API.db_false;
   END IF;
   IF NOT (indrec_.abc_class_per_asset_class) THEN
      newrec_.abc_class_per_asset_class   := Fnd_Boolean_API.db_false;
   END IF;
   IF NOT (indrec_.upper_limit_veryslow_mover) THEN
      newrec_.upper_limit_veryslow_mover    := 1;
   END IF;
   IF NOT (indrec_.upper_limit_slow_mover) THEN
      newrec_.upper_limit_slow_mover      := 10;
   END IF;
   IF NOT (indrec_.upper_limit_medium_mover) THEN
      newrec_.upper_limit_medium_mover    := 100;
   END IF;
   IF NOT (indrec_.mix_of_part_number_blocked) THEN
      newrec_.mix_of_part_number_blocked  := Fnd_Boolean_API.db_false;
   END IF;
   IF NOT (indrec_.mix_of_cond_codes_blocked) THEN
      newrec_.mix_of_cond_codes_blocked   := Fnd_Boolean_API.db_false;
   END IF;
   IF NOT (indrec_.mix_of_lot_batch_no_blocked) THEN
      newrec_.mix_of_lot_batch_no_blocked := Fnd_Boolean_API.db_false;
   END IF;
   IF NOT (indrec_.allow_partloc_owner_mix) THEN
      newrec_.allow_partloc_owner_mix     := Fnd_Boolean_API.db_false;
   END IF;
   IF NOT (indrec_.exclude_storage_req_val) THEN
      newrec_.exclude_storage_req_val     := Fnd_Boolean_API.db_false;
   END IF;
   IF NOT (indrec_.transport_from_whse_level) THEN
      newrec_.transport_from_whse_level   := Warehouse_Structure_Level_API.db_bin;
   END IF;
   IF NOT (indrec_.transport_to_whse_level) THEN
      newrec_.transport_to_whse_level     := Warehouse_Structure_Level_API.db_bin;
   END IF;
   IF NOT (indrec_.transport_part_cons_level) THEN
      newrec_.transport_part_cons_level   := Transport_Part_Cons_Level_API.db_single_configuration;
   END IF;
   IF NOT (indrec_.transport_ref_cons_level) THEN
      newrec_.transport_ref_cons_level    := Transport_Ref_Cons_Level_API.db_single_reference;
   END IF;
   IF NOT (indrec_.putaway_zone_refill_option) THEN
      newrec_.putaway_zone_refill_option  := Putaway_Zone_Refill_Option_API.DB_NO_REFILL;
   END IF;
   IF NOT (indrec_.auto_dropof_man_trans_task) THEN
      newrec_.auto_dropof_man_trans_task  := Fnd_Boolean_API.db_true;
   END IF;
   IF NOT (indrec_.allow_deviating_avail_ctrl) THEN
      newrec_.allow_deviating_avail_ctrl  := Fnd_Boolean_API.db_false;
   END IF;
   IF NOT (indrec_.exec_transp_task_background) THEN
      newrec_.exec_transp_task_background  := Fnd_Boolean_API.DB_FALSE;
   END IF;
   IF NOT (indrec_.reset_config_std_cost) THEN
      newrec_.reset_config_std_cost       := Fnd_Boolean_API.db_false;
   END IF;
   IF NOT (indrec_.counting_print_report_opt) THEN
      newrec_.counting_print_report_opt   := Invent_Report_Print_Option_API.db_detailed;
   END IF;
   IF NOT (indrec_.move_reservation_option) THEN 
      newrec_.move_reservation_option     := Reservat_Adjustment_Option_API.db_not_allowed;
   END IF;
   IF NOT (indrec_.pick_by_choice_option) THEN 
      newrec_.pick_by_choice_option       := Reservat_Adjustment_Option_API.db_not_allowed;
   END IF;
   IF NOT (indrec_.auto_reserve_prio1) THEN 
      newrec_.auto_reserve_prio1          := Invent_Auto_Reserve_Prio_API.DB_PUTAWAY_ZONE_RANKING;
   END IF;
   IF NOT (indrec_.auto_reserve_prio2) THEN 
      newrec_.auto_reserve_prio2          := Invent_Auto_Reserve_Prio_API.DB_EXPIRATION_DATE;
   END IF;
   IF NOT (indrec_.auto_reserve_prio3) THEN 
      newrec_.auto_reserve_prio3          := Invent_Auto_Reserve_Prio_API.DB_RECEIPT_DATE;
   END IF;
   IF NOT (indrec_.auto_reserve_prio4) THEN 
      newrec_.auto_reserve_prio4          := Invent_Auto_Reserve_Prio_API.DB_HANDLING_UNIT_QTY;
   END IF;
   IF NOT (indrec_.auto_reserve_prio5) THEN 
      newrec_.auto_reserve_prio5          := Invent_Auto_Reserve_Prio_API.DB_HANDLING_UNIT_LEVEL;
   END IF;
   IF NOT (indrec_.auto_reserve_hu_optimized) THEN
      newrec_.auto_reserve_hu_optimized  := Fnd_Boolean_API.DB_TRUE;
   END IF;
   IF NOT (indrec_.auto_reserve_receipt_time) THEN
      newrec_.auto_reserve_receipt_time  := Fnd_Boolean_API.DB_FALSE;
   END IF;
   IF NOT (indrec_.reserv_from_transp_task) THEN
      newrec_.reserv_from_transp_task  := Reserve_From_Transp_Task_API.DB_NO;
   END IF;
   IF NOT (indrec_.cascad_posting_date_option) THEN
      newrec_.cascad_posting_date_option  := Adjust_Posting_Date_Option_API.DB_SYSTEM_DATE;
   END IF;
   
   super(newrec_, indrec_, attr_);
   
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_                     IN     site_invent_info_tab%ROWTYPE,
   newrec_                     IN OUT site_invent_info_tab%ROWTYPE,
   indrec_                     IN OUT Indicator_Rec,
   attr_                       IN OUT VARCHAR2,
   check_inactive_plan_params_ IN     BOOLEAN  DEFAULT FALSE,
   validate_user_allowed_site_ IN     BOOLEAN  DEFAULT TRUE)
IS
   name_        VARCHAR2(30);
   value_       VARCHAR2(4000);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
      
   IF (validate_user_allowed_site_) THEN   
      User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, newrec_.contract);
   END IF;

   IF (check_inactive_plan_params_) THEN
      Error_If_Plan_Attr_Inactive___(newrec_);
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE New_Planning_Parameters__ (
   info_       OUT    VARCHAR2,
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   rec_                    SITE_INVENT_INFO_TAB%ROWTYPE;
   contract_               SITE_INVENT_INFO_TAB.contract%TYPE;
   company_                VARCHAR2(20);
   attr_with_keys_removed_ VARCHAR2(2000);
BEGIN
   -- Checking company/site connection here because Unpack_Check... is used in other situations
   -- where company/site connection check isn't needed.
   contract_ := Client_SYS.Get_Item_Value('CONTRACT', attr_);
   company_  := Client_SYS.Get_Item_Value('COMPANY', attr_);
   IF company_ != Site_API.Get_Company(contract_) THEN
      Error_SYS.Record_General(lu_name_,'WRONGCOMPANY: Site :P1 does not belong to company :P2.', contract_, company_);
   END IF;
   
   rec_ := Get_Object_By_Keys___(contract_);
   IF (rec_.service_level_rate IS NOT NULL OR rec_.ordering_cost IS NOT NULL OR rec_.inventory_interest_rate IS NOT NULL) THEN
      Error_SYS.Record_Exist('SiteInventInfoPlanning');
   END IF;
   
   -- Getting the record to update
   Get_Id_Version_By_Keys___(objid_, objversion_, contract_);
   -- Removing keys from attr_ since keys can't be updated
   attr_with_keys_removed_ := Get_Attr_With_Keys_Removed___(attr_);
   Modify___(info_, objid_, objversion_, attr_with_keys_removed_, action_, TRUE);
END New_Planning_Parameters__;


PROCEDURE Copy_Warehouses__ (
   from_contract_          IN VARCHAR2,
   to_contract_            IN VARCHAR2,
   copy_cubic_capacity_    IN BOOLEAN,
   copy_carrying_capacity_ IN BOOLEAN,
   copy_temperatures_      IN BOOLEAN )
IS
   CURSOR get_warehouses IS
      SELECT warehouse_id
        FROM warehouse_tab
       WHERE contract = from_contract_;
BEGIN

   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, from_contract_);
   FOR warehouse_rec_ IN get_warehouses LOOP
      Warehouse_API.Copy__(from_contract_,
                           warehouse_rec_.warehouse_id,
                           to_contract_,
                           warehouse_rec_.warehouse_id,
                           copy_bays_ => TRUE,
                           copy_cubic_capacity_ => copy_cubic_capacity_,
                           copy_carrying_capacity_ => copy_carrying_capacity_,
                           copy_temperatures_ => copy_temperatures_);
   END LOOP;
END Copy_Warehouses__;


PROCEDURE Modify_Planning_Parameters__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
BEGIN
   Modify___(info_, objid_, objversion_, attr_, action_, TRUE);
END Modify_Planning_Parameters__;


PROCEDURE Remove_Planning_Parameters__ (
   info_       OUT VARCHAR2,
   objid_      IN  VARCHAR2,
   objversion_ IN  VARCHAR2,
   action_     IN  VARCHAR2 )
IS
   attr_           VARCHAR2(2000);
   new_objversion_ VARCHAR2(2000) := objversion_;
BEGIN

   Client_SYS.Add_To_Attr('SERVICE_LEVEL_RATE',       to_char(NULL), attr_);
   Client_SYS.Add_To_Attr('ORDERING_COST',            to_char(NULL), attr_);
   Client_SYS.Add_To_Attr('INVENTORY_INTEREST_RATE',  to_char(NULL), attr_);

   Modify___(info_, objid_, new_objversion_, attr_, action_, FALSE);
END Remove_Planning_Parameters__;


PROCEDURE Check_Remove__ (
   contract_ IN VARCHAR2 )
IS
   remrec_ SITE_INVENT_INFO_TAB%ROWTYPE;
BEGIN
   remrec_ := Get_Object_By_Keys___(contract_);
   Check_Delete___(remrec_);
END Check_Remove__ ;


PROCEDURE Do_Remove__ (
   contract_ IN VARCHAR2 )
IS 
   remrec_     SITE_INVENT_INFO_TAB%ROWTYPE;
   objid_      SITE_INVENT_INFO.objid%TYPE;
   objversion_ SITE_INVENT_INFO.objversion%TYPE;
BEGIN
   remrec_ := Lock_By_Keys___(contract_);
   Get_Id_Version_By_Keys___(objid_, objversion_, contract_); 
   Check_Delete___(remrec_);
   Delete___(objid_, remrec_);
END Do_Remove__ ;


PROCEDURE Clear_Whse_Storage_Chars__ (
   contract_                    IN VARCHAR2,
   receipts_blocked_            IN NUMBER,
   receipt_to_occupied_blocked_ IN NUMBER,
   mix_of_part_number_blocked_  IN NUMBER,
   mix_of_cond_codes_blocked_   IN NUMBER,
   mix_of_lot_batch_blocked_    IN NUMBER,
   exclude_storage_req_val_     IN NUMBER,
   hide_in_whse_navigator_      IN NUMBER,
   bin_width_capacity_          IN NUMBER,
   bin_height_capacity_         IN NUMBER,
   bin_dept_capacity_           IN NUMBER,
   bin_volume_capacity_         IN NUMBER,
   bay_carrying_capacity_       IN NUMBER,
   row_carrying_capacity_       IN NUMBER,
   tier_carrying_capacity_      IN NUMBER,
   bin_carrying_capacity_       IN NUMBER,
   bin_min_temperature_         IN NUMBER,
   bin_max_temperature_         IN NUMBER,
   bin_min_humidity_            IN NUMBER,
   bin_max_humidity_            IN NUMBER,
   capabilities_                IN NUMBER,
   all_capabilities_            IN NUMBER,
   availability_control_id_     IN NUMBER,
   drop_off_location_           IN NUMBER )
IS
   capability_tab_ Storage_Capability_API.Capability_Tab;
   
   CURSOR get_warehouses IS
      SELECT warehouse_id
      FROM warehouse_tab
      WHERE contract = contract_;
BEGIN

   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, contract_);
   
   IF (capabilities_ = 1) THEN
      IF (all_capabilities_ = 0) THEN 
         capability_tab_ := Warehouse_Bin_Capability_API.Get_Operative_Capabilities(contract_, NULL, NULL, NULL, NULL, NULL);
      END IF;
   END IF;
      
   FOR warehouse_rec_ IN get_warehouses LOOP
      Warehouse_API.Clear_Storage_Chars__(contract_,
                                          warehouse_rec_.warehouse_id,
                                          CASE receipts_blocked_            WHEN 1 THEN TRUE ELSE FALSE END,
                                          CASE receipt_to_occupied_blocked_ WHEN 1 THEN TRUE ELSE FALSE END,
                                          CASE mix_of_part_number_blocked_  WHEN 1 THEN TRUE ELSE FALSE END,
                                          CASE mix_of_cond_codes_blocked_   WHEN 1 THEN TRUE ELSE FALSE END,
                                          CASE mix_of_lot_batch_blocked_    WHEN 1 THEN TRUE ELSE FALSE END,
                                          CASE exclude_storage_req_val_     WHEN 1 THEN TRUE ELSE FALSE END,
                                          CASE hide_in_whse_navigator_      WHEN 1 THEN TRUE ELSE FALSE END,
                                          CASE bin_width_capacity_          WHEN 1 THEN TRUE ELSE FALSE END,
                                          CASE bin_height_capacity_         WHEN 1 THEN TRUE ELSE FALSE END,
                                          CASE bin_dept_capacity_           WHEN 1 THEN TRUE ELSE FALSE END,
                                          CASE bin_volume_capacity_         WHEN 1 THEN TRUE ELSE FALSE END,
                                          CASE bay_carrying_capacity_       WHEN 1 THEN TRUE ELSE FALSE END,
                                          CASE row_carrying_capacity_       WHEN 1 THEN TRUE ELSE FALSE END,
                                          CASE tier_carrying_capacity_      WHEN 1 THEN TRUE ELSE FALSE END,
                                          CASE bin_carrying_capacity_       WHEN 1 THEN TRUE ELSE FALSE END,
                                          CASE bin_min_temperature_         WHEN 1 THEN TRUE ELSE FALSE END,
                                          CASE bin_max_temperature_         WHEN 1 THEN TRUE ELSE FALSE END,
                                          CASE bin_min_humidity_            WHEN 1 THEN TRUE ELSE FALSE END,
                                          CASE bin_max_humidity_            WHEN 1 THEN TRUE ELSE FALSE END,
                                          CASE capabilities_                WHEN 1 THEN TRUE ELSE FALSE END,
                                          CASE all_capabilities_            WHEN 1 THEN TRUE ELSE FALSE END,
                                          capability_tab_,
                                          CASE availability_control_id_     WHEN 1 THEN TRUE ELSE FALSE END,
                                          CASE drop_off_location_           WHEN 1 THEN TRUE ELSE FALSE END);
   END LOOP; 
END Clear_Whse_Storage_Chars__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
@UncheckedAccess
FUNCTION Get_Last_Actual_Cost_Calc (
   contract_ IN VARCHAR2 ) RETURN DATE
IS
   temp_ SITE_INVENT_INFO_TAB.last_actual_cost_calc%TYPE;
   CURSOR get_attr IS
      SELECT last_actual_cost_calc
      FROM SITE_INVENT_INFO_TAB
      WHERE contract = contract_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Last_Actual_Cost_Calc;


@Override
@UncheckedAccess
FUNCTION Get_Bin_Volume_Capacity (
   contract_ IN VARCHAR2 ) RETURN NUMBER
IS
   bin_volume_capacity_ site_invent_info_tab.bin_volume_capacity%TYPE;
BEGIN
   IF (Get_Volume_Uom(contract_) IS NOT NULL) THEN 
      bin_volume_capacity_ := super(contract_);
      IF (bin_volume_capacity_ IS NULL) THEN
         bin_volume_capacity_ := micro_cache_value_.bin_height_capacity * 
                                 micro_cache_value_.bin_width_capacity * 
                                 micro_cache_value_.bin_dept_capacity;
      ELSE
         bin_volume_capacity_ := micro_cache_value_.bin_volume_capacity;
      END IF;
   END IF;   
   RETURN (LEAST(bin_volume_capacity_, 999999999999999999999999999));
END Get_Bin_Volume_Capacity;


@UncheckedAccess
FUNCTION Get_Bin_Volume_Cap_Source_Db (
   contract_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   bin_volume_cap_source_db_ VARCHAR2(20);
BEGIN   
   IF (Get_Bin_Volume_Capacity(contract_) IS NOT NULL) THEN
      bin_volume_cap_source_db_ := Warehouse_Structure_Level_API.DB_SITE;
   END IF;
   RETURN bin_volume_cap_source_db_;
END Get_Bin_Volume_Cap_Source_Db;


@UncheckedAccess
FUNCTION Get_Bin_Volume_Capacity_Source (
   contract_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN (Warehouse_Structure_Level_API.Decode(Get_Bin_Volume_Cap_Source_Db(contract_)));
END Get_Bin_Volume_Capacity_Source;


-- Set_Last_Actual_Cost_Calc
--   Public method to set a value to attribute LastActualCostCalc.
PROCEDURE Set_Last_Actual_Cost_Calc (
   contract_              IN VARCHAR2,
   last_actual_cost_calc_ IN DATE )
IS
   oldrec_     SITE_INVENT_INFO_TAB%ROWTYPE;
   newrec_     SITE_INVENT_INFO_TAB%ROWTYPE;
   attr_       VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN
   oldrec_ := Lock_By_Keys___(contract_);
   newrec_ := oldrec_;
   Client_SYS.Add_To_Attr('LAST_ACTUAL_COST_CALC', last_actual_cost_calc_, attr_);
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
END Set_Last_Actual_Cost_Calc;


-- Check_Ownership_Transfer_Point
--   This method validates the combination of ownerhip transfer point
--   (stored on LU CompanyDistributionInfo) with Supplier Invoice Consideration.
PROCEDURE Check_Ownership_Transfer_Point (
   company_                     IN VARCHAR2,
   ownership_transfer_point_db_ IN VARCHAR2 )
IS
   contract_ SITE_INVENT_INFO_TAB.contract%TYPE;

   CURSOR get_site IS
      SELECT sii.contract
        FROM SITE_INVENT_INFO_TAB sii, site_tab s
       WHERE sii.contract              = s.contract
         AND s.company                 = company_
         AND sii.invoice_consideration = 'TRANSACTION BASED';
BEGIN

   IF (ownership_transfer_point_db_ = 'RECEIPT INTO INVENTORY') THEN
      OPEN get_site;
      FETCH get_site INTO contract_;
      IF (get_site%FOUND) THEN
         CLOSE get_site;
         Error_SYS.Record_General(lu_name_, 'TRANBASSEPARR: You cannot use Receipt Into Inventory as Ownership Transfer Point on company :P1 since Transaction Based Invoice Consideration is activated on site :P2.', company_, contract_);
      END IF;
      CLOSE get_site;
   END IF;
END Check_Ownership_Transfer_Point;


-- New
--   Create new record with minimum required details.
PROCEDURE New (
   contract_ IN VARCHAR2 )
IS
   attr_       VARCHAR2(32000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   newrec_     SITE_INVENT_INFO_TAB%ROWTYPE;
   indrec_     Indicator_Rec;
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_);
   Client_SYS.Add_To_Attr('FREEZE_STOCK_COUNT_REPORT_DB', Fnd_Boolean_API.DB_TRUE, attr_);
   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);
END New;


@UncheckedAccess
FUNCTION Check_Exist (
   contract_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN Check_Exist___(contract_);
END Check_Exist;


@UncheckedAccess
FUNCTION Get_Bin_Height_Capacity_Source (
   contract_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN (Warehouse_Structure_Level_API.Decode(Get_Bin_Height_Cap_Source_Db(contract_)));
END Get_Bin_Height_Capacity_Source;


@UncheckedAccess
FUNCTION Get_Bin_Width_Capacity_Source (
   contract_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN (Warehouse_Structure_Level_API.Decode(Get_Bin_Width_Cap_Source_Db(contract_)));
END Get_Bin_Width_Capacity_Source;


@UncheckedAccess
FUNCTION Get_Bin_Dept_Capacity_Source (
   contract_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN (Warehouse_Structure_Level_API.Decode(Get_Bin_Dept_Cap_Source_Db(contract_)));
END Get_Bin_Dept_Capacity_Source;


@UncheckedAccess
FUNCTION Get_Bin_Carry_Capacity_Source (
   contract_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN (Warehouse_Structure_Level_API.Decode(Get_Bin_Carry_Cap_Source_Db(contract_)));
END Get_Bin_Carry_Capacity_Source;


@UncheckedAccess
FUNCTION Get_Bin_Min_Temperature_Source (
   contract_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN (Warehouse_Structure_Level_API.Decode(Get_Bin_Min_Temp_Source_Db(contract_)));
END Get_Bin_Min_Temperature_Source;


@UncheckedAccess
FUNCTION Get_Bin_Max_Temperature_Source (
   contract_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN (Warehouse_Structure_Level_API.Decode(Get_Bin_Max_Temp_Source_Db(contract_)));
END Get_Bin_Max_Temperature_Source;


@UncheckedAccess
FUNCTION Get_Bin_Min_Humidity_Source (
   contract_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN (Warehouse_Structure_Level_API.Decode(Get_Bin_Min_Humidity_Source_Db(contract_)));
END Get_Bin_Min_Humidity_Source;


@UncheckedAccess
FUNCTION Get_Bin_Max_Humidity_Source (
   contract_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN (Warehouse_Structure_Level_API.Decode(Get_Bin_Max_Humidity_Source_Db(contract_)));
END Get_Bin_Max_Humidity_Source;


@UncheckedAccess
FUNCTION Get_Bay_Carry_Capacity_Source (
   contract_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN (Warehouse_Structure_Level_API.Decode(Get_Bay_Carry_Cap_Source_Db(contract_)));
END Get_Bay_Carry_Capacity_Source;


@UncheckedAccess
FUNCTION Get_Row_Carry_Capacity_Source (
   contract_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN (Warehouse_Structure_Level_API.Decode(Get_Row_Carry_Cap_Source_Db(contract_)));
END Get_Row_Carry_Capacity_Source;


@UncheckedAccess
FUNCTION Get_Tier_Carry_Capacity_Source (
   contract_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN (Warehouse_Structure_Level_API.Decode(Get_Tier_Carry_Cap_Source_Db(contract_)));
END Get_Tier_Carry_Capacity_Source;


@UncheckedAccess
FUNCTION Get_Bin_Height_Cap_Source_Db (
   contract_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   bin_height_capacity_source_db_ VARCHAR2(20);
BEGIN
   Update_Cache___(contract_);
   IF (micro_cache_value_.bin_height_capacity IS NOT NULL) THEN
      bin_height_capacity_source_db_ := Warehouse_Structure_Level_API.DB_SITE;
   END IF;
   RETURN (bin_height_capacity_source_db_);
END Get_Bin_Height_Cap_Source_Db;


@UncheckedAccess
FUNCTION Get_Bin_Width_Cap_Source_Db (
   contract_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   bin_width_capacity_source_db_ VARCHAR2(20);
BEGIN
   Update_Cache___(contract_);
   IF (micro_cache_value_.bin_width_capacity IS NOT NULL) THEN
      bin_width_capacity_source_db_ := Warehouse_Structure_Level_API.DB_SITE;
   END IF;
   RETURN (bin_width_capacity_source_db_);
END Get_Bin_Width_Cap_Source_Db;


@UncheckedAccess
FUNCTION Get_Bin_Dept_Cap_Source_Db (
   contract_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   bin_dept_capacity_source_db_ VARCHAR2(20);
BEGIN
   Update_Cache___(contract_);
   IF (micro_cache_value_.bin_dept_capacity IS NOT NULL) THEN
      bin_dept_capacity_source_db_ := Warehouse_Structure_Level_API.DB_SITE;
   END IF;
   RETURN (bin_dept_capacity_source_db_);
END Get_Bin_Dept_Cap_Source_Db;


@UncheckedAccess
FUNCTION Get_Bin_Carry_Cap_Source_Db (
   contract_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   bin_carry_capacity_source_db_ VARCHAR2(20);
BEGIN
   Update_Cache___(contract_);
   IF (micro_cache_value_.bin_carrying_capacity IS NOT NULL) THEN
      bin_carry_capacity_source_db_ := Warehouse_Structure_Level_API.DB_SITE;
   END IF;
   RETURN (bin_carry_capacity_source_db_);
END Get_Bin_Carry_Cap_Source_Db;


@UncheckedAccess
FUNCTION Get_Bin_Min_Temp_Source_Db (
   contract_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   bin_min_temperature_source_db_ VARCHAR2(20);
BEGIN
   Update_Cache___(contract_);
   IF (micro_cache_value_.bin_min_temperature IS NOT NULL) THEN
      bin_min_temperature_source_db_ := Warehouse_Structure_Level_API.DB_SITE;
   END IF;
   RETURN (bin_min_temperature_source_db_);
END Get_Bin_Min_Temp_Source_Db;


@UncheckedAccess
FUNCTION Get_Bin_Max_Temp_Source_Db (
   contract_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   bin_max_temperature_source_db_ VARCHAR2(20);
BEGIN
   Update_Cache___(contract_);
   IF (micro_cache_value_.bin_max_temperature IS NOT NULL) THEN
      bin_max_temperature_source_db_ := Warehouse_Structure_Level_API.DB_SITE;
   END IF;
   RETURN (bin_max_temperature_source_db_);
END Get_Bin_Max_Temp_Source_Db;


@UncheckedAccess
FUNCTION Get_Bin_Min_Humidity_Source_Db (
   contract_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   bin_min_humidity_source_db_ VARCHAR2(20);
BEGIN
   Update_Cache___(contract_);
   IF (micro_cache_value_.bin_min_humidity IS NOT NULL) THEN
      bin_min_humidity_source_db_ := Warehouse_Structure_Level_API.DB_SITE;
   END IF;
   RETURN (bin_min_humidity_source_db_);
END Get_Bin_Min_Humidity_Source_Db;


@UncheckedAccess
FUNCTION Get_Bin_Max_Humidity_Source_Db (
   contract_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   bin_max_humidity_source_db_ VARCHAR2(20);
BEGIN
   Update_Cache___(contract_);
   IF (micro_cache_value_.bin_max_humidity IS NOT NULL) THEN
      bin_max_humidity_source_db_ := Warehouse_Structure_Level_API.DB_SITE;
   END IF;
   RETURN (bin_max_humidity_source_db_);
END Get_Bin_Max_Humidity_Source_Db;


@UncheckedAccess
FUNCTION Get_Bay_Carry_Cap_Source_Db (
   contract_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   bay_carry_capacity_source_db_ VARCHAR2(20);
BEGIN
   Update_Cache___(contract_);
   IF (micro_cache_value_.bay_carrying_capacity IS NOT NULL) THEN
      bay_carry_capacity_source_db_ := Warehouse_Structure_Level_API.DB_SITE;
   END IF;
   RETURN (bay_carry_capacity_source_db_);
END Get_Bay_Carry_Cap_Source_Db;


@UncheckedAccess
FUNCTION Get_Row_Carry_Cap_Source_Db (
   contract_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   row_carry_capacity_source_db_ VARCHAR2(20);
BEGIN
   Update_Cache___(contract_);
   IF (micro_cache_value_.row_carrying_capacity IS NOT NULL) THEN
      row_carry_capacity_source_db_ := Warehouse_Structure_Level_API.DB_SITE;
   END IF;
   RETURN (row_carry_capacity_source_db_);
END Get_Row_Carry_Cap_Source_Db;


@UncheckedAccess
FUNCTION Get_Tier_Carry_Cap_Source_Db (
   contract_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   tier_carry_capacity_source_db_ VARCHAR2(20);
BEGIN
   Update_Cache___(contract_);
   IF (micro_cache_value_.tier_carrying_capacity IS NOT NULL) THEN
      tier_carry_capacity_source_db_ := Warehouse_Structure_Level_API.DB_SITE;
   END IF;
   RETURN (tier_carry_capacity_source_db_);
END Get_Tier_Carry_Cap_Source_Db;


@UncheckedAccess
FUNCTION Get_Receipts_Blocked_Source (
   contract_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   Update_Cache___(contract_);
   IF (micro_cache_value_.receipts_blocked = Fnd_Boolean_API.db_false) THEN
     RETURN NULL;
   ELSE
     RETURN Warehouse_Structure_Level_API.Decode(Warehouse_Structure_Level_API.DB_SITE);
   END IF;
END Get_Receipts_Blocked_Source;


@UncheckedAccess
FUNCTION Get_Receipt_To_Occup_Blkd_Src (
   contract_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   Update_Cache___(contract_);
   IF (micro_cache_value_.receipt_to_occupied_blocked = Fnd_Boolean_API.db_false) THEN
     RETURN NULL;
   ELSE
     RETURN Warehouse_Structure_Level_API.Decode(Warehouse_Structure_Level_API.DB_SITE);
   END IF;
END Get_Receipt_To_Occup_Blkd_Src;


@UncheckedAccess
FUNCTION Get_Volume_Uom (
   contract_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   volume_uom_ VARCHAR2(30);
   company_inv_rec_  Company_Invent_Info_API.Public_Rec;
   base_length_uom_        VARCHAR2(30);
   base_volume_uom_        VARCHAR2(30);
   calc_base_volume_uom_   VARCHAR2(30);
BEGIN
   company_inv_rec_ := Company_Invent_Info_API.Get(Site_API.Get_Company(contract_));
   volume_uom_      := company_inv_rec_.uom_for_length || '3';
   IF (Iso_Unit_API.Check_Exist(volume_uom_) = Fnd_Boolean_API.DB_TRUE) THEN
      RETURN volume_uom_;
   ELSE
      -- When user has not defined length related volume unit of measure for the system then the system evaluates against the length and volume defined
      -- in the site information inside the company and validate they have defined as representation of any base unit of measures in the system.
      -- This configuration highly recommends not to use since this consume more resources which might lead to performance issues and solution applied according to the
      -- legal requirement came through connected 151217 bug.
      --
      -- e.g. when user want to represent 'm' as 'mtr' and 'm3' as 'mtq' then the system validates the relationship with 'm' an 'mtr' along with 'm3'
      -- with 'mtq' as define with conversion factor '1' to corresponding base uom.

      base_length_uom_      := Iso_Unit_API.Get_Base_Unit(company_inv_rec_.uom_for_length);
      base_volume_uom_      := Iso_Unit_API.Get_Base_Unit(company_inv_rec_.uom_for_volume);
      calc_base_volume_uom_ := base_length_uom_ || '3';
      IF ( base_volume_uom_ = calc_base_volume_uom_ AND Iso_Unit_API.Check_Exist(calc_base_volume_uom_) = Fnd_Boolean_API.DB_TRUE ) THEN
         IF(Iso_Unit_API.Get_Factor(company_inv_rec_.uom_for_length) = 1 AND Iso_Unit_API.Get_Factor(company_inv_rec_.uom_for_volume) = 1 ) THEN
            RETURN company_inv_rec_.uom_for_volume;
         END IF;
      END IF;
   END IF;
   RETURN NULL;
END Get_Volume_Uom;


@UncheckedAccess
FUNCTION Get_Mix_Of_Parts_Blocked_Db (
   contract_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   Update_Cache___(contract_);
   RETURN micro_cache_value_.mix_of_part_number_blocked;
END Get_Mix_Of_Parts_Blocked_Db;


@UncheckedAccess
FUNCTION Get_Mix_Of_Part_Blocked_Source (
   contract_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   Update_Cache___(contract_);
   IF (micro_cache_value_.mix_of_part_number_blocked = Fnd_Boolean_API.db_false) THEN
     RETURN NULL;
   ELSE
     RETURN Warehouse_Structure_Level_API.Decode(Warehouse_Structure_Level_API.DB_SITE);
   END IF;
END Get_Mix_Of_Part_Blocked_Source;


@UncheckedAccess
FUNCTION Get_Mix_Of_Cond_Blocked_Db (
   contract_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   Update_Cache___(contract_);
   RETURN micro_cache_value_.mix_of_cond_codes_blocked;
END Get_Mix_Of_Cond_Blocked_Db;


@UncheckedAccess
FUNCTION Get_Mix_Of_Cond_Blocked_Source (
   contract_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   Update_Cache___(contract_);
   IF (micro_cache_value_.mix_of_cond_codes_blocked = Fnd_Boolean_API.db_false) THEN
     RETURN NULL;
   ELSE
     RETURN Warehouse_Structure_Level_API.Decode(Warehouse_Structure_Level_API.DB_SITE);
   END IF;
END Get_Mix_Of_Cond_Blocked_Source;


@UncheckedAccess
FUNCTION Get_Mix_Of_Lot_Blocked_Source (
   contract_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   Update_Cache___(contract_);
   IF (micro_cache_value_.mix_of_lot_batch_no_blocked = Fnd_Boolean_API.db_false) THEN
     RETURN NULL;
   ELSE
     RETURN Warehouse_Structure_Level_API.Decode(Warehouse_Structure_Level_API.DB_SITE);
   END IF;
END Get_Mix_Of_Lot_Blocked_Source;


@UncheckedAccess
FUNCTION Get_Excl_Storage_Req_Val_Src (
   contract_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   Update_Cache___(contract_);
   IF (micro_cache_value_.exclude_storage_req_val = Fnd_Boolean_API.db_false) THEN
     RETURN NULL;
   ELSE
     RETURN Warehouse_Structure_Level_API.Decode(Warehouse_Structure_Level_API.DB_SITE);
   END IF;
END Get_Excl_Storage_Req_Val_Src;


@UncheckedAccess
FUNCTION Get_Transport_From_Whse_Lvl_Db (
   contract_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   Update_Cache___(contract_);
   RETURN micro_cache_value_.transport_from_whse_level;
END Get_Transport_From_Whse_Lvl_Db;

@UncheckedAccess
FUNCTION Get_Transport_To_Whse_Lvl_Db (
   contract_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   Update_Cache___(contract_);
   RETURN micro_cache_value_.transport_to_whse_level;
END Get_Transport_To_Whse_Lvl_Db;


@UncheckedAccess
FUNCTION Get_First_Viable_Posting_Date (
   contract_ IN VARCHAR2 ) RETURN DATE
IS
   latest_stat_year_no_         NUMBER;
   latest_stat_period_no_       NUMBER;   
   open_acc_period_begin_date_  DATE;
   open_stat_period_begin_date_ DATE;
   today_                       DATE;
   first_viable_posting_date_   DATE;
BEGIN   
   today_ := TRUNC(Site_API.Get_Site_Date(contract_));
   
   IF (Get_Cascad_Posting_Date_Opt_Db(contract_) = Adjust_Posting_Date_Option_API.DB_SYSTEM_DATE) THEN
      RETURN(today_);
   END IF;
   
   -- First try to find the first viable posting allowed by the financial periods. We want to find a date that marks the begin date
   -- of a date interval of unbroken open periods that stretches all the way up until todays date. 
   open_acc_period_begin_date_ := User_Group_Period_API.Get_Min_Open_User_Grp_Date(company_    => Site_API.Get_Company(contract_),
                                                                                   user_group_ => NULL,
                                                                                   date_       => today_);

   -- Just as a safety net if the check against open period begin date fails for some reason.
   open_acc_period_begin_date_ := NVL(open_acc_period_begin_date_, today_);
        
   -- Now we know how far back in time we can create financial postings before we reach into closed financial periods. So we can never
   -- create a posting with an earlier date than open_acc_period_begin_date_. And we also know that it is safe to create postings on any
   -- date between open_acc_period_begin_date_ and today, considering open and closed financial periods. 

   -- Now it is time to find out about closed statistical periods in Inventory. We can only create postings with a posting date that is
   -- inside, or later than, the latest aggregated period in Inventory.   
   Inventory_Value_API.Get_Max_Year_Period(latest_stat_year_no_, latest_stat_period_no_, contract_);
   
   IF (latest_stat_year_no_ IS NOT NULL AND latest_stat_period_no_ IS NOT NULL) THEN
      -- fetch the start date of the latest aggregated statistic period
      open_stat_period_begin_date_ := Statistic_Period_API.Get_Begin_Date(latest_stat_year_no_, latest_stat_period_no_);
   ELSE
      -- Assigning an early date on stat_period_begin_date since there has not been any aggregation done on the site yet.
      open_stat_period_begin_date_ := Database_SYS.first_calendar_date_;
   END IF;
   
   -- Return the latest of the open accounting period begin date and open stat period begin date. 
   first_viable_posting_date_ := GREATEST(open_acc_period_begin_date_, open_stat_period_begin_date_);
   
   RETURN(first_viable_posting_date_);
END Get_First_Viable_Posting_Date;

FUNCTION Get_Ipr_Active(
   contract_ IN VARCHAR2 ) RETURN VARCHAR2
IS   
BEGIN
   $IF Component_Invpla_SYS.INSTALLED $THEN
      RETURN Site_Ipr_Info_API.Get_Ipr_Active_Db(contract_);
   $ELSE
      RETURN Fnd_Boolean_API.DB_FALSE;
   $END
END Get_Ipr_Active;   