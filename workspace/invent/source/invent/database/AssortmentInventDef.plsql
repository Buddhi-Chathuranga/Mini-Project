-----------------------------------------------------------------------------
--
--  Logical unit: AssortmentInventDef
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  161123  PrYaLK   Bug 132773, Modified Create_Parts_Per_Site() in order to pass the correct value of order_requisition.
--  150721  ErFelk   Bug 121889, Modified Create_Parts_Per_Site() so that, if the unit_meas is NULL it is assigned with the value of part catalog unit_meas.
--  131105  UdGnlk   PBSC-194, Modified the base view comments to align with model file errors.
--  130730  UdGnlk   TIBE-825, Removed the dynamic code and modify to conditional compilation.
--  120629  ChFolk   Modified View to increased the length of customs_stat_no to VARCHAR2(15).
--  120425  IsSalk   Bug 102090, Added column catch_unit_meas to view ASSORTMENT_INVENT_DEF and modified methods Unpack_Check_Insert___,
--  120425           Unpack_Check_Update___, Insert___ and Update___ accordingly. Modified method Create_Parts_Per_Site in order to send the value of
--  120425           catch_unit_meas to the new inventory part.
--  120130  PraWlk   Bug 99404, Removed attribute superseded_by from ASSORTMENT_INVENT_DEF view and modified code accordingly.
--  101103  ShKolk   Removed gtin_no and gtin_series from method call to Inventory_Part_API.New_Part.
--  100629  ShKolk   Added column min_durab_days_planning.
--  100618  Asawlk   Bug 91327, Modified Assign_Defaults___ and Create_Parts_Per_Site methods to pass qty_calc_rounding 
--  100618           when creating an Inventory Part.
--  100519  HaYalk   Replaced Application_Country with Iso_Country in base view and Unpack_Check* menthods.
--  ---------------------------------------- 14.0.0 ----------------------------
--  100304  SuSalk   Bug 89167, Modified Assign_Defaults___ and Create_Parts_Per_Site methods to send
--  100304           part_cost_group_id when creating an inventory part.
--  091030  ShKolk   Bug 86768, Merge IPR to APP75 core.
--  090818  ShKolk   Renamed column min_durab_days_co_reserv to min_durab_days_co_deliv
--  090817  ShKolk   Changed NUMBER(4) to NUMBER in view comments of min_durab_days_co_reserv.
--  090812  ShKolk   Added column min_durab_days_co_reserv.
--  081020  PraWlk   Bug 77846, Modified Unpack_Check_Insert___ and Unpack_Check_Update___by making dynamic
--  081020           calls to Part_Cost_Group_API.
--  080923  PraWlk   Bug 77255, Modified Unpack_Check_Insert___ and Unpack_Check_Update___to validate the  
--  080923           REGION_OF_ORIGIN and PART_COST_GROUP_ID values being inserting.
--  080728  AmPalk   Removed weight_net.
--  080526  KiSalk   Removed ean_no.
--  ************************************ Nice Price **********************************
--  070214  NiDalk   Removed method Chk_Site_Cluster_Conn___.
--  070213  NiDalk   Modified Create_Parts_Per_Site to consider defaults entered for Site cluster node to which the site belongs.
--  070206  MiErlk   Added method Remove.
--  070206  NiDalk   Modified to create Inventory_Part_Planning entry according to the defaults.
--  070122  NiDalk   Added Notes field.
--  070119  NiDalk   Added OUT parameter create_status_ to the method Create_Parts_Per_Site.
--  070116  KeFelk   Changed the logic of Chk_Site_Cluster_Conn___ and CURSOR get_parents.
--  070110  NiDalk   Modified Create_Parts_Per_Site to pass correct decode values.
--  061227  KeFelk   Modified Unpack_Check_Insert___ for site_cluster_id and site_cluster_node_id.
--  061220  MiErlk   Modified the PROCEDURE Create_Parts_Per_Site.
--  061215  IsWilk   Modified the PROCEDURE Create_Parts_Per_Site.
--  061214  IsWilk   Modified the PROCEDURE Create_Parts_Per_Site.
--  061211  IsWilk   Added the PROCEDUREs Create_Parts_Per_Site, Chk_Site_Cluster_Conn___
--  061211           and Assign_Defaults___.
--  061124  IsWilk   Made the attributes as public.
--  061120  NiDalk   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Assign_Defaults___ (
   newrec_      IN OUT ASSORTMENT_INVENT_DEF_TAB%ROWTYPE,
   default_rec_ IN     ASSORTMENT_INVENT_DEF_TAB%ROWTYPE )
IS
BEGIN

   IF (newrec_.accounting_group IS NULL) THEN
      newrec_.accounting_group := default_rec_.accounting_group;
   END IF;
   IF (newrec_.asset_class IS NULL) THEN
      newrec_.asset_class := default_rec_.asset_class;
   END IF;
   IF (newrec_.country_of_origin IS NULL) THEN
      newrec_.country_of_origin := default_rec_.country_of_origin;
   END IF;
   IF (newrec_.hazard_code IS NULL) THEN
      newrec_.hazard_code := default_rec_.hazard_code;
   END IF;
   IF (newrec_.part_product_code IS NULL) THEN
      newrec_.part_product_code := default_rec_.part_product_code;
   END IF;
   IF (newrec_.part_product_family IS NULL) THEN
      newrec_.part_product_family := default_rec_.part_product_family;
   END IF;
   IF (newrec_.part_status IS NULL) THEN
      newrec_.part_status := default_rec_.part_status;
   END IF;
   IF (newrec_.planner_buyer IS NULL) THEN
      newrec_.planner_buyer := default_rec_.planner_buyer;
   END IF;
   IF (newrec_.prime_commodity IS NULL) THEN
      newrec_.prime_commodity := default_rec_.prime_commodity;
   END IF;
   IF (newrec_.second_commodity IS NULL) THEN
      newrec_.second_commodity := default_rec_.second_commodity;
   END IF;
   IF (newrec_.unit_meas IS NULL) THEN
      newrec_.unit_meas := default_rec_.unit_meas;
   END IF;
   IF (newrec_.abc_class IS NULL) THEN
      newrec_.abc_class := default_rec_.abc_class;
   END IF;
   IF (newrec_.cycle_code IS NULL) THEN
      newrec_.cycle_code := default_rec_.cycle_code;
   END IF;
   IF (newrec_.cycle_period IS NULL) THEN
      newrec_.cycle_period := default_rec_.cycle_period;
   END IF;
   IF (newrec_.dim_quality IS NULL) THEN
      newrec_.dim_quality := default_rec_.dim_quality;
   END IF;
   IF (newrec_.durability_day IS NULL) THEN
      newrec_.durability_day := default_rec_.durability_day;
   END IF;
   IF (newrec_.expected_leadtime IS NULL) THEN
      newrec_.expected_leadtime := default_rec_.expected_leadtime;
   END IF;
   IF (newrec_.manuf_leadtime IS NULL) THEN
      newrec_.manuf_leadtime := default_rec_.manuf_leadtime;
   END IF;
   IF (newrec_.oe_alloc_assign_flag IS NULL) THEN
      newrec_.oe_alloc_assign_flag := default_rec_.oe_alloc_assign_flag;
   END IF;
   IF (newrec_.onhand_analysis_flag IS NULL) THEN
      newrec_.onhand_analysis_flag := default_rec_.onhand_analysis_flag;
   END IF;
   IF (newrec_.purch_leadtime IS NULL) THEN
      newrec_.purch_leadtime := default_rec_.purch_leadtime;
   END IF;
   IF (newrec_.supersedes IS NULL) THEN
      newrec_.supersedes := default_rec_.supersedes;
   END IF;
   IF (newrec_.supply_code IS NULL) THEN
      newrec_.supply_code := default_rec_.supply_code;
   END IF;
   IF (newrec_.type_code IS NULL) THEN
      newrec_.type_code := default_rec_.type_code;
   END IF;
   IF (newrec_.customs_stat_no IS NULL) THEN
      newrec_.customs_stat_no := default_rec_.customs_stat_no;
   END IF;
   IF (newrec_.type_designation IS NULL) THEN
      newrec_.type_designation := default_rec_.type_designation;
   END IF;
   IF (newrec_.zero_cost_flag IS NULL) THEN
      newrec_.zero_cost_flag := default_rec_.zero_cost_flag;
   END IF;
   IF (newrec_.forecast_consumption_flag IS NULL) THEN
      newrec_.forecast_consumption_flag := default_rec_.forecast_consumption_flag;
   END IF;
   IF (newrec_.intrastat_conv_factor IS NULL) THEN
      newrec_.intrastat_conv_factor := default_rec_.intrastat_conv_factor;
   END IF;
   IF (newrec_.invoice_consideration IS NULL) THEN
      newrec_.invoice_consideration := default_rec_.invoice_consideration;
   END IF;
   IF (newrec_.max_actual_cost_update IS NULL) THEN
      newrec_.max_actual_cost_update := default_rec_.max_actual_cost_update;
   END IF;
   IF (newrec_.shortage_flag IS NULL) THEN
      newrec_.shortage_flag := default_rec_.shortage_flag;
   END IF;
   IF (newrec_.inventory_part_cost_level IS NULL) THEN
      newrec_.inventory_part_cost_level := default_rec_.inventory_part_cost_level;
   END IF;
   IF (newrec_.std_name_id IS NULL) THEN
      newrec_.std_name_id := default_rec_.std_name_id;
   END IF;
   IF (newrec_.input_unit_meas_group_id IS NULL) THEN
      newrec_.input_unit_meas_group_id := default_rec_.input_unit_meas_group_id;
   END IF;
   IF (newrec_.dop_connection IS NULL) THEN
      newrec_.dop_connection := default_rec_.dop_connection;
   END IF;
   IF (newrec_.supply_chain_part_group IS NULL) THEN
      newrec_.supply_chain_part_group := default_rec_.supply_chain_part_group;
   END IF;
   IF (newrec_.ext_service_cost_method IS NULL) THEN
      newrec_.ext_service_cost_method := default_rec_.ext_service_cost_method;
   END IF;
   IF (newrec_.stock_management IS NULL) THEN
      newrec_.stock_management := default_rec_.stock_management;
   END IF;
   IF (newrec_.technical_coordinator_id IS NULL) THEN
      newrec_.technical_coordinator_id := default_rec_.technical_coordinator_id;
   END IF;
   IF (newrec_.estimated_material_cost IS NULL) THEN
      newrec_.estimated_material_cost := default_rec_.estimated_material_cost;
   END IF;
   IF (newrec_.automatic_capability_check IS NULL) THEN
      newrec_.automatic_capability_check := default_rec_.automatic_capability_check;
   END IF;
   IF (newrec_.inventory_valuation_method IS NULL) THEN
      newrec_.inventory_valuation_method := default_rec_.inventory_valuation_method;
   END IF;
   IF (newrec_.negative_on_hand IS NULL) THEN
      newrec_.negative_on_hand := default_rec_.negative_on_hand;
   END IF;
   IF (newrec_.planning_method IS NULL) THEN
      newrec_.planning_method := default_rec_.planning_method;
   END IF;
   IF (newrec_.min_order_qty IS NULL) THEN
      newrec_.min_order_qty := default_rec_.min_order_qty;
   END IF;
   IF (newrec_.max_order_qty IS NULL) THEN
      newrec_.max_order_qty := default_rec_.max_order_qty;
   END IF;
   IF (newrec_.mul_order_qty IS NULL) THEN
      newrec_.mul_order_qty := default_rec_.mul_order_qty;
   END IF;
   IF (newrec_.shrinkage_fac IS NULL) THEN
      newrec_.shrinkage_fac := default_rec_.shrinkage_fac;
   END IF;
   IF (newrec_.service_rate IS NULL) THEN
      newrec_.service_rate := default_rec_.service_rate;
   END IF;
   IF (newrec_.std_order_size IS NULL) THEN
      newrec_.std_order_size := default_rec_.std_order_size;
   END IF;
   IF (newrec_.carry_rate IS NULL) THEN
      newrec_.carry_rate := default_rec_.carry_rate;
   END IF;
   IF (newrec_.safety_stock IS NULL) THEN
      newrec_.safety_stock := default_rec_.safety_stock;
   END IF;
   IF (newrec_.safety_lead_time IS NULL) THEN
      newrec_.safety_lead_time := default_rec_.safety_lead_time;
   END IF;
   IF (newrec_.order_point_qty IS NULL) THEN
      newrec_.order_point_qty := default_rec_.order_point_qty;
   END IF;
   IF (newrec_.lot_size IS NULL) THEN
      newrec_.lot_size := default_rec_.lot_size;
   END IF;
   IF (newrec_.maxweek_supply IS NULL) THEN
      newrec_.maxweek_supply := default_rec_.maxweek_supply;
   END IF;
   IF (newrec_.maxweek_supply IS NULL) THEN
      newrec_.maxweek_supply := default_rec_.maxweek_supply;
   END IF;
   IF (newrec_.setup_cost IS NULL) THEN
      newrec_.setup_cost := default_rec_.setup_cost;
   END IF;
   IF (newrec_.qty_predicted_consumption IS NULL) THEN
      newrec_.qty_predicted_consumption := default_rec_.qty_predicted_consumption;
   END IF;
   IF (newrec_.proposal_release IS NULL) THEN
      newrec_.proposal_release := default_rec_.proposal_release;
   END IF;
   IF (newrec_.order_requisition IS NULL) THEN
      newrec_.order_requisition := default_rec_.order_requisition;
   END IF;
   IF (newrec_.min_durab_days_co_deliv IS NULL) THEN
      newrec_.min_durab_days_co_deliv := default_rec_.min_durab_days_co_deliv;
   END IF;
   IF (newrec_.min_durab_days_planning IS NULL) THEN
      newrec_.min_durab_days_planning := default_rec_.min_durab_days_planning;
   END IF;
   IF (newrec_.part_cost_group_id IS NULL) THEN
      newrec_.part_cost_group_id := default_rec_.part_cost_group_id;
   END IF;
   IF (newrec_.qty_calc_rounding IS NULL) THEN
      newrec_.qty_calc_rounding := default_rec_.qty_calc_rounding;
   END IF;
   IF (newrec_.catch_unit_meas IS NULL) THEN
      newrec_.catch_unit_meas := default_rec_.catch_unit_meas;
   END IF;
END Assign_Defaults___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('COMPANY', '*', attr_);
   Client_SYS.Add_To_Attr('SITE_CLUSTER_ID', '*', attr_);
   Client_SYS.Add_To_Attr('SITE_CLUSTER_NODE_ID', '*', attr_);
   Client_SYS.Add_To_Attr('CONTRACT', '*', attr_);
   Client_SYS.Add_To_Attr('COUNTRY_CODE', '*', attr_);
END Prepare_Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT assortment_invent_def_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   IF NOT (newrec_.site_cluster_id = '*' AND newrec_.site_cluster_node_id = '*') THEN
      IF (newrec_.site_cluster_id = '*' OR newrec_.site_cluster_node_id = '*') THEN
         Error_SYS.Record_General(lu_name_, 'CLUSTERNODEMISMATCH: IF you specify one of the fields Site Cluster ID or Site Cluster Node ID, you must specify the other.');
      ELSE
         Site_Cluster_Node_API.Exist(newrec_.site_cluster_id, newrec_.site_cluster_node_id);
      END IF;
   END IF;
   IF (newrec_.contract != '*') THEN
      IF (newrec_.site_cluster_id != '*' OR newrec_.site_cluster_node_id != '*' OR newrec_.country_code != '*' OR newrec_.company != '*') THEN
         Error_SYS.Record_General(lu_name_, 'INVENTEFERR: Company, Country, and Site Cluster Node must be * when you specify a value for Site.');
      END IF;
   END IF;
   newrec_.priority := Create_Parts_Per_Site_Util_API.Get_Priority(newrec_.site_cluster_node_id,
                                                                 newrec_.contract,
                                                                 newrec_.country_code,
                                                                 newrec_.company,
                                                                 NULL);   
   
   super(newrec_, indrec_, attr_);

  IF (newrec_.region_of_origin IS NOT NULL) THEN
     Country_Region_API.Exist(newrec_.country_code, newrec_.region_of_origin);
  END IF;

  IF (newrec_.part_cost_group_id IS NOT NULL) THEN
     $IF (Component_Cost_SYS.INSTALLED) $THEN
        Part_Cost_Group_API.Exist(newrec_.contract,
                                  newrec_.part_cost_group_id);
     $ELSE
        Error_SYS.Record_General(lu_name_, 'PARTCOSTGROUPINST: LU PartCostGroup is not installed. Execution aborted.');
     $END 
  END IF;

EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     assortment_invent_def_tab%ROWTYPE,
   newrec_ IN OUT assortment_invent_def_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   Error_SYS.Check_Not_Null(lu_name_, 'PRIORITY', newrec_.priority);

   IF (newrec_.region_of_origin IS NOT NULL) THEN
      Country_Region_API.Exist(newrec_.country_code, newrec_.region_of_origin);
   END IF;

   IF (newrec_.part_cost_group_id IS NOT NULL) THEN
      $IF (Component_Cost_SYS.INSTALLED) $THEN
         Part_Cost_Group_API.Exist(newrec_.contract,
                                   newrec_.part_cost_group_id);
      $ELSE
         Error_SYS.Record_General(lu_name_, 'PARTCOSTGROUPINST: LU PartCostGroup is not installed. Execution aborted.');
      $END      
   END IF;

EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Create_Parts_Per_Site
--   Creates inventory part according to the defaults enterd. Defaults are assigned
--   considering following criteria.
--   1. Priority
--   2. Assortment node level. (close Parents have high priority)
--   3. Site Cluster Node defaults for which the site belongs
PROCEDURE Create_Parts_Per_Site (
   create_status_      OUT VARCHAR2,
   assortment_id_      IN  VARCHAR2,
   assortment_node_id_ IN  VARCHAR2,
   contract_           IN  VARCHAR2,
   company_            IN  VARCHAR2,
   country_code_       IN  VARCHAR2,
   part_no_            IN  VARCHAR2 )
IS
   defaults_rec_           ASSORTMENT_INVENT_DEF_TAB%ROWTYPE;
   newrec_                 ASSORTMENT_INVENT_DEF_TAB%ROWTYPE;
   description_            VARCHAR2(200);
   eng_attribute_          VARCHAR2(20);
   site_belong_to_node_    VARCHAR2(10);
   parent_node_            ASSORTMENT_NODE_TAB.parent_node%TYPE;

   CURSOR get_invent_assortment_defaults(selected_node_id_ IN VARCHAR2) IS
      SELECT *
      FROM   ASSORTMENT_INVENT_DEF_TAB
      WHERE  assortment_id = assortment_id_
      AND    assortment_node_id = selected_node_id_
      AND    contract IN (contract_,'*')
      AND    country_code IN (country_code_,'*')
      AND    company IN (company_,'*')
      ORDER BY priority ASC, (Site_Cluster_Node_API.Get_Level_No(site_cluster_id, site_cluster_node_id)) DESC;
BEGIN

   create_status_ := 'FALSE';

   IF NOT (Inventory_Part_API.Check_Exist(contract_, part_no_)) THEN
      parent_node_ := assortment_node_id_;
      -- To get the defaults of the parents.
      WHILE parent_node_ IS NOT NULL LOOP
         OPEN get_invent_assortment_defaults(parent_node_);
         FETCH get_invent_assortment_defaults INTO defaults_rec_;
         WHILE get_invent_assortment_defaults%FOUND LOOP
            site_belong_to_node_ := Site_Cluster_Node_API.Is_Site_Belongs_To_Node(defaults_rec_.site_cluster_id, defaults_rec_.site_cluster_node_id, contract_);
            IF (defaults_rec_.site_cluster_node_id = '*' OR
                 (defaults_rec_.site_cluster_node_id !='*' AND site_belong_to_node_ = 'TRUE')) THEN
               Assign_Defaults___(newrec_, defaults_rec_);
            END IF;
            FETCH get_invent_assortment_defaults INTO defaults_rec_;
         END LOOP;
         CLOSE get_invent_assortment_defaults;
         parent_node_ := Assortment_Node_API.Get_Parent_Node(assortment_id_, parent_node_);
      END LOOP;

      eng_attribute_ :=Assortment_Node_API.Get_Eng_Attribute(assortment_id_,assortment_node_id_);
      
      -- Assign Part Catalog default attributes.
      description_ := Part_Catalog_API.Get_Description(part_no_);
      IF (newrec_.unit_meas IS NULL) THEN
         newrec_.unit_meas := Part_Catalog_API.Get_Unit_Code(part_no_); 
      END IF;      
      
      Inventory_Part_API.New_Part (contract_,
                                   part_no_,
                                   newrec_.accounting_group ,
                                   newrec_.asset_class,
                                   newrec_.country_of_origin,
                                   newrec_.hazard_code,
                                   newrec_.part_product_code,
                                   newrec_.part_product_family,
                                   newrec_.part_status,
                                   newrec_.planner_buyer,
                                   newrec_.prime_commodity,
                                   newrec_.second_commodity,
                                   newrec_.unit_meas,
                                   description_,
                                   NULL, -- abc_class,
                                   NULL, -- count_variance_,
                                   NULL, -- create_date,
                                   Inventory_Part_Count_Type_API.Decode(newrec_.cycle_code),
                                   newrec_.cycle_period,
                                   newrec_.dim_quality,
                                   newrec_.durability_day,
                                   newrec_.expected_leadtime,
                                   NULL, -- inactive_obs_flag,
                                   NULL, -- last_activity_date,
                                   NULL, -- lead_time_code,
                                   newrec_.manuf_leadtime,
                                   NULL, -- note_text,
                                   Cust_Ord_Reservation_Type_API.Decode(newrec_.oe_alloc_assign_flag),
                                   Inventory_Part_Onh_Analys_API.Decode(newrec_.onhand_analysis_flag),
                                   newrec_.purch_leadtime,
                                   newrec_.supersedes,
                                   Material_Requis_Supply_API.Decode(newrec_.supply_code),
                                   Inventory_Part_Type_API.Decode(newrec_.type_code),
                                   newrec_.customs_stat_no,
                                   newrec_.type_designation,
                                   Inventory_Part_Zero_Cost_API.Decode(newrec_.zero_cost_flag),
                                   NULL, -- avail_activity_status,
                                   eng_attribute_,
                                   Inv_Part_Forecast_Consum_API.Decode(newrec_.forecast_consumption_flag),
                                   newrec_.intrastat_conv_factor,
                                   Invoice_Consideration_API.Decode(newrec_.invoice_consideration),
                                   newrec_.max_actual_cost_update,
                                   Inventory_Part_Shortage_API.Decode(newrec_.shortage_flag),
                                   Inventory_Part_Cost_Level_API.Decode(newrec_.inventory_part_cost_level),
                                   newrec_.std_name_id,
                                   newrec_.input_unit_meas_group_id,
                                   Dop_Connection_API.Decode(newrec_.dop_connection),
                                   newrec_.supply_chain_part_group,
                                   Ext_Service_Cost_Method_API.Decode(newrec_.ext_service_cost_method),
                                   Inventory_Part_Management_API.Decode(newrec_.stock_management),
                                   newrec_.technical_coordinator_id,
                                   NULL, -- sup_warranty_id,
                                   NULL, -- cust_warranty_id,
                                   newrec_.estimated_material_cost,
                                   Capability_Check_Allocate_API.Decode(newrec_.automatic_capability_check),
                                   'FALSE', -- create_purchase_part,
                                   Inventory_Value_Method_API.Decode(newrec_.inventory_valuation_method),
                                   Negative_On_Hand_API.Decode(newrec_.negative_on_hand),
                                   'FALSE', -- create part planning default record
                                   newrec_.catch_unit_meas,
                                   newrec_.part_cost_group_id,    -- part_cost_group_id_
                                   newrec_.qty_calc_rounding,
                                   newrec_.min_durab_days_co_deliv,
                                   newrec_.min_durab_days_planning ); 

      -- create part planning default record
      Inventory_Part_Planning_API.Create_New_Part_Planning(contract_,
                                                           part_no_,
                                                           newrec_.second_commodity,
                                                           newrec_.planning_method,
                                                           newrec_.min_order_qty,
                                                           newrec_.max_order_qty,
                                                           newrec_.mul_order_qty,
                                                           newrec_.shrinkage_fac,
                                                           newrec_.service_rate,
                                                           newrec_.std_order_size,
                                                           newrec_.carry_rate,
                                                           newrec_.safety_stock,
                                                           newrec_.safety_lead_time,
                                                           newrec_.order_point_qty,
                                                           newrec_.lot_size,
                                                           newrec_.maxweek_supply,
                                                           newrec_.setup_cost,
                                                           newrec_.qty_predicted_consumption,
                                                           Order_Proposal_Release_API.Decode(newrec_.proposal_release),
                                                           newrec_.order_requisition);
      create_status_ := 'TRUE';
      END IF;
END Create_Parts_Per_Site;


PROCEDURE Remove (
   assortment_id_ IN VARCHAR2,
   assortment_node_id_ IN VARCHAR2 )
IS
   remrec_      ASSORTMENT_INVENT_DEF_TAB%ROWTYPE;
   objid_       ASSORTMENT_INVENT_DEF.objid%TYPE;
   objversion_  ASSORTMENT_INVENT_DEF.objversion%TYPE;

   CURSOR get_data IS
      SELECT company,country_code, site_cluster_id, site_cluster_node_id, contract
      FROM   ASSORTMENT_INVENT_DEF_TAB
      WHERE  assortment_id = assortment_id_
      AND    assortment_node_id = assortment_node_id_;

BEGIN

   FOR rec_ IN  get_data LOOP
    remrec_ := Get_Object_By_Keys___(assortment_id_,
                                     assortment_node_id_,
                                     rec_.site_cluster_id,
                                     rec_.site_cluster_node_id,
                                     rec_.contract,
                                     rec_.company,
                                     rec_.country_code);

    Get_Id_Version_By_Keys___(objid_,
                              objversion_,
                              assortment_id_,
                              assortment_node_id_,
                              rec_.site_cluster_id,
                              rec_.site_cluster_node_id,
                              rec_.contract,
                              rec_.company,
                              rec_.country_code);
    Check_Delete___(remrec_);
    Delete___(objid_, remrec_);
   END LOOP;

END Remove;



