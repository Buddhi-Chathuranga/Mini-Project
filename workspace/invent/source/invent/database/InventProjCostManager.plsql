-----------------------------------------------------------------------------
--
--  Logical unit: InventProjCostManager
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210924  ChJalk  SC21R2-2857, Added method Get_Location_Type_And_Group to get the values of location type and location group of a part. Modified the method 
--  210924          Get_Project_Cost_Elements___ to get the values Location_Type and Location_Group using Get_Location_Type_And_Group.
--  180406  Chbnlk  Bug 140497, Modified the method signatures of Get_Project_Cost_Elements___() and Get_Elements_For_Purch() to get the value of condition_code_.
--  150826  SWiclk  Bug 122852, Modified Get_Project_Cost_Elements___() in order to pass location_group_ and location_type_db_ 
--  150826          of default location when calling Mpccom_Accounting_API.Get_Project_Cost_Elements().
--  131206  RuLiLk  Bug 114001, Modified method Get_Elements_For_Purch(). Only if unit cost is null Part cost is assigned to unit cost.
--  130730  AwWelk  TIBE-866, Removed unused global variables CostBucket_inst_ and PartCostBucket_inst_.
--  130708  ErSrLK  Bug 107012, Modified Get_Elements_From_Costing___(), redirected the call to Part_Cost_Bucket_One_API which concerns Cost Set 1.
--  130515  IsSalk  Bug 106680, Replaced Installed_Component_SYS.<component> with Component_<component>_SYS.<component>.
--  120918  disklk  BRZ-1356: Modified Get_Elements_From_Costing___,Get_Elements_For_Purch,Get_Project_Cost_Elements, Added new default true parameter include_cost_of_components_
--  120918  IRJALK  Bug 104826, Modified methods Get_Project_Cost_Elements___() and Get_Elements_For_Sales_Oh()  
--  120918          by adding parameter part_no to invoking function Inventory_Transaction_Hist_API.Create_Value_Detail_Tab().
--  110824  ChFolk  Merged HIGHPK-8508. Modified Fill_Temporary_Table___, Get_From_Temporary_Table. Included used_currency_amount values,
--  101118  RoJalk  Removed the parameter amount_as_positive_ and the usage  from the method Get_From_Temporary_Table. 
--  101025  RoJalk  Modified Get_From_Temporary_Table and added the parameter 
--  101025          amount_as_positive_ as an indicator to identify if amount and
--  101025          hours are needed to be selected as negative or positive values.
--  100505  KRPELK  Merge Rose Method Documentation.  
--  091224  KaEllk  Modified Fill_Temporary_Table___ to consider planned_committed_hours.
--  ------------------------------- Eagle -----------------------------------
--  100504  Nuvelk  TWIN PEAKS Merge.
            --  090818  RoJalk  Modified Fill_Temporary_Table___ to handle the NULL values when
            --  090818          inserting the values for project_cost_element_tmp inside Fill_Temporary_Table___.
            --  090806  RoJalk  Modified Fill_Temporary_Table___ to handle 0 and null values.
            --  090130  RoJalk  Changed the scope of Get_From_Temporary_Table___ to be public.
            --  090129  KaEllk  Modified Get_From_Temporary_Table___ and Fill_Temporary_Table___ to consider planned_hours.
            --  090126  KaEllk  Modified Get_From_Temporary_Table___ to add hours to select list.
--  080711  RoJalk  Bug 74811, Removed transaction_id_, pre_accounting_id_, activity_seq_,
--  080711          project_id_ parameters when calliing Mpccom_Accounting_API.
--  080711          Get_Project_Cost_Elements.Removed the parameters transaction_id_,
--  080711          pre_accounting_id_, activity_seq_, project_id_ and added vendor_no_
--  080711          to the Get_Project_Cost_Elements___. Removed pre_accounting_id_,
--  080711          activity_seq_, project_id_ parameters and added vendor_no_ to
--  080711          Get_Project_Cost_Elements, Get_Elements_For_Purch.
--  080528  KaEllk  Bug 74045, Added function Get_Elements_For_Sales_Oh.
--  080501  RoJalk  Bug 73185, Create
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Get_Project_Cost_Elements___ (
   part_no_                      IN VARCHAR2,
   contract_                     IN VARCHAR2,
   source_ref_type_db_           IN VARCHAR2,
   source_ref1_                  IN VARCHAR2,
   source_ref2_                  IN VARCHAR2,
   source_ref3_                  IN VARCHAR2,
   source_ref4_                  IN NUMBER,
   part_related_                 IN BOOLEAN,
   charge_type_                  IN VARCHAR2,
   charge_group_                 IN VARCHAR2,
   error_when_element_not_exist_ IN BOOLEAN,
   include_charge_               IN BOOLEAN,
   supp_grp_                     IN VARCHAR2,
   stat_grp_                     IN VARCHAR2,
   assortment_                   IN VARCHAR2,
   unit_cost_                    IN NUMBER,
   unit_cost_is_material_        IN BOOLEAN,
   quantity_                     IN NUMBER,
   vendor_no_                    IN VARCHAR2,
   condition_code_               IN VARCHAR2) RETURN Mpccom_Accounting_API.Project_Cost_Element_Tab
IS
   cost_detail_tab_              Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   value_detail_tab_             Mpccom_Accounting_API.Value_Detail_Tab;
   project_cost_element_tab_     Mpccom_Accounting_API.Project_Cost_Element_Tab;
   trans_quantity_               NUMBER;
   location_type_db_             INVENTORY_LOCATION_GROUP_TAB.inventory_location_type%TYPE;
   location_group_               INVENTORY_LOCATION_GROUP_TAB.location_group%TYPE;
BEGIN
   IF source_ref_type_db_ IN ('PUR REQ', 'PUR ORDER') THEN
      trans_quantity_ := quantity_;
   END IF;

   cost_detail_tab_ := Inventory_Part_Unit_Cost_API.Generate_Cost_Details( cost_detail_tab_,
                                                                           unit_cost_,
                                                                           unit_cost_is_material_,
                                                                           Site_API.Get_Company(contract_),
                                                                           contract_,
                                                                           part_no_,
                                                                           '*',
                                                                           source_ref1_,
                                                                           source_ref2_,
                                                                           source_ref3_,
                                                                           source_ref4_,
                                                                           source_ref_type_db_,
                                                                           NULL,
                                                                           trans_quantity_,
                                                                           vendor_no_ );

   value_detail_tab_ := Inventory_Transaction_Hist_API.Create_Value_Detail_Tab(cost_detail_tab_, quantity_, part_no_);

   IF (value_detail_tab_.COUNT > 0) THEN
      Get_Location_Type_And_Group(location_type_db_, location_group_, contract_, part_no_);
      project_cost_element_tab_ := Mpccom_Accounting_API.Get_Project_Cost_Elements(
                                                         part_no_                      => part_no_,
                                                         contract_                     => contract_,
                                                         source_ref_type_db_           => source_ref_type_db_,
                                                         source_ref1_                  => source_ref1_,
                                                         source_ref2_                  => source_ref2_,
                                                         source_ref3_                  => source_ref3_,
                                                         source_ref4_                  => source_ref4_,
                                                         part_related_                 => part_related_,
                                                         charge_type_                  => charge_type_,
                                                         charge_group_                 => charge_group_,
                                                         error_when_element_not_exist_ => error_when_element_not_exist_ ,
                                                         include_charge_               => include_charge_,
                                                         supp_grp_                     => supp_grp_,
                                                         stat_grp_                     => stat_grp_,
                                                         assortment_                   => assortment_,
                                                         value_detail_tab_             => value_detail_tab_,
                                                         location_type_                => location_type_db_,
                                                         location_group_               => location_group_,
                                                         condition_code_               => condition_code_);
   END IF;

   RETURN project_cost_element_tab_;
END Get_Project_Cost_Elements___;


-- Fill_Temporary_Table___
--   Fills temporary table project_cost_element_tmp with data from received
--   project_cost_element_tab_for the given cost type
PROCEDURE Fill_Temporary_Table___ (
   project_cost_element_tab_ IN Mpccom_Accounting_API.Project_Cost_Element_Tab,
   cost_type_                IN VARCHAR2 )
IS
   record_ project_cost_element_tmp%ROWTYPE;
BEGIN
   IF (project_cost_element_tab_.COUNT > 0) THEN

      FOR i IN project_cost_element_tab_.FIRST..project_cost_element_tab_.LAST LOOP
         IF ((NVL(project_cost_element_tab_(i).amount, 0) != 0) OR (NVL(project_cost_element_tab_(i).hours, 0) != 0)) THEN
            record_.project_cost_element     := project_cost_element_tab_(i).project_cost_element;
            record_.planned_amount           := 0;
            record_.planned_committed_amount := 0;
            record_.committed_amount         := 0;
            record_.used_amount              := 0;
            record_.used_currency_amount     := 0;
            record_.planned_hours            := 0;
   
            IF (cost_type_ = 'PLANNED') THEN
               record_.planned_amount           := project_cost_element_tab_(i).amount;
               record_.planned_hours            := project_cost_element_tab_(i).hours;
            ELSIF (cost_type_ = 'PLANNED_COMMITTED') THEN
               record_.planned_committed_amount := project_cost_element_tab_(i).amount;
               record_.planned_committed_hours  := project_cost_element_tab_(i).hours;
            ELSIF (cost_type_ = 'COMMITTED') THEN
               record_.committed_amount         := project_cost_element_tab_(i).amount;
            ELSIF (cost_type_ = 'USED') THEN
               record_.used_amount              := project_cost_element_tab_(i).amount;
               record_.used_currency_amount     := project_cost_element_tab_(i).currency_amount;
            ELSE
               Error_SYS.Record_General(lu_name_, 'COSTTYPEERR: Unsupported Cost Type.');
            END IF;
   
            INSERT INTO project_cost_element_tmp
               (project_cost_element,
                planned_amount,
                planned_committed_amount,
                committed_amount,
                used_amount,
                used_currency_amount,
                planned_hours,
                planned_committed_hours)
            VALUES
               (record_.project_cost_element, 
                NVL(record_.planned_amount          ,0),
                NVL(record_.planned_committed_amount,0),
                NVL(record_.committed_amount        ,0),
                NVL(record_.used_amount             ,0),
                NVL(record_.used_currency_amount    ,0),
                NVL(record_.planned_hours           ,0),
                NVL(record_.planned_committed_hours ,0));
         END IF;
      END LOOP;
   END IF;
END Fill_Temporary_Table___;


-- Get_Elements_From_Costing___
--   Returns a Mpccom_Accounting_API.Project_Cost_Element_Tab with data from cost set 1
--   Returns project cost elements from Cost set 1 if available
FUNCTION Get_Elements_From_Costing___ (
   contract_                   IN VARCHAR2,
   part_no_                    IN VARCHAR2,
   source_ref_type_db_         IN VARCHAR2,
   source_ref1_                IN VARCHAR2,
   source_ref2_                IN VARCHAR2,
   source_ref3_                IN VARCHAR2,
   source_ref4_                IN NUMBER,
   quantity_                   IN NUMBER,
   include_cost_of_components_ IN BOOLEAN) RETURN Mpccom_Accounting_API.Project_Cost_Element_Tab
IS
   project_cost_element_tab_  Mpccom_Accounting_API.Project_Cost_Element_Tab;
BEGIN
   $IF (Component_Cost_SYS.INSTALLED) $THEN 
      project_cost_element_tab_:= Part_Cost_Bucket_One_API.Get_Project_Cost_Elements(contract_                   => contract_, 
                                                                                     part_no_                    => part_no_,
                                                                                     source_ref_type_db_         => source_ref_type_db_,
                                                                                     source_ref1_                => source_ref1_,
                                                                                     source_ref2_                => source_ref2_,
                                                                                     source_ref3_                => source_ref3_,
                                                                                     source_ref4_                => source_ref4_,
                                                                                     required_qty_               => quantity_, 
                                                                                     include_cost_of_components_ => include_cost_of_components_) ;      
   $END
   RETURN (project_cost_element_tab_);
END Get_Elements_From_Costing___;


-- Clear_Temporary_Table___
--   Clears data in temporary table project_cost_element_tmp
PROCEDURE Clear_Temporary_Table___
IS
BEGIN
   DELETE FROM project_cost_element_tmp;
END Clear_Temporary_Table___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Project_Cost_Elements
--   Returns a Mpccom_Accounting_API.Project_Cost_Element_Tab for Standard
--   Planned Inventory items
FUNCTION Get_Project_Cost_Elements (
   contract_                    IN VARCHAR2,
   part_no_                     IN VARCHAR2,
   source_ref_type_db_          IN VARCHAR2,
   source_ref1_                 IN VARCHAR2,
   source_ref2_                 IN VARCHAR2,
   source_ref3_                 IN VARCHAR2,
   source_ref4_                 IN NUMBER,
   quantity_                    IN NUMBER,
   condition_code_              IN VARCHAR2,
   part_related_                IN BOOLEAN DEFAULT FALSE,
   vendor_no_                   IN VARCHAR2 DEFAULT NULL,
   include_cost_of_components_  IN BOOLEAN DEFAULT TRUE) RETURN Mpccom_Accounting_API.Project_Cost_Element_Tab
IS
   project_cost_element_tab_  Mpccom_Accounting_API.Project_Cost_Element_Tab;
   unit_cost_                 NUMBER  := 0;
   unit_cost_is_material_     BOOLEAN := FALSE;
BEGIN
   -- Get unit cost from Cost set 1
   project_cost_element_tab_ := Get_Elements_From_Costing___(contract_,
                                                             part_no_,
                                                             source_ref_type_db_,
                                                             source_ref1_,
                                                             source_ref2_,
                                                             source_ref3_,
                                                             source_ref4_,
                                                             quantity_,
                                                             include_cost_of_components_);

   IF (project_cost_element_tab_.count = 0) THEN
      -- Get weighted averaged unit cost
      unit_cost_ := Inventory_Part_Unit_Cost_API.Get_Invent_Value_By_Condition (contract_, part_no_, '*', condition_code_ );

      -- Get estimated unit cost
      IF (unit_cost_ = 0) THEN
         unit_cost_ := Inventory_Part_Config_API.Get_Estimated_Material_Cost(contract_, part_no_, '*');
         unit_cost_is_material_ := TRUE;
      END IF;
      project_cost_element_tab_ := Get_Project_Cost_Elements___( part_no_                       => part_no_,
                                                                 contract_                      => contract_,
                                                                 source_ref_type_db_            => source_ref_type_db_,
                                                                 source_ref1_                   => source_ref1_,
                                                                 source_ref2_                   => source_ref2_,
                                                                 source_ref3_                   => source_ref3_,
                                                                 source_ref4_                   => source_ref4_,
                                                                 part_related_                  => part_related_,
                                                                 charge_type_                   => NULL,
                                                                 charge_group_                  => NULL,
                                                                 error_when_element_not_exist_  => TRUE,
                                                                 include_charge_                => NULL,
                                                                 supp_grp_                      => NULL,
                                                                 stat_grp_                      => NULL,
                                                                 assortment_                    => NULL,
                                                                 unit_cost_                     => unit_cost_,
                                                                 unit_cost_is_material_         => unit_cost_is_material_,
                                                                 quantity_                      => quantity_,
                                                                 vendor_no_                     => vendor_no_,
                                                                 condition_code_                => NULL );
   END IF;

   RETURN project_cost_element_tab_;
END Get_Project_Cost_Elements;


FUNCTION Get_From_Temporary_Table RETURN Mpccom_Accounting_API.Project_Cost_Element_Tab
IS
   project_cost_element_tab_ Mpccom_Accounting_API.Project_Cost_Element_Tab;

   CURSOR get_proj_cost_elements IS
      SELECT project_cost_element, (planned_amount + planned_committed_amount + committed_amount + used_amount) amount, used_currency_amount currency_amount, planned_hours
      FROM project_cost_element_tmp;
BEGIN
   OPEN  get_proj_cost_elements;
   FETCH get_proj_cost_elements BULK COLLECT INTO project_cost_element_tab_;
   CLOSE get_proj_cost_elements;
   Clear_Temporary_Table___;

   RETURN (project_cost_element_tab_);
END Get_From_Temporary_Table;


-- Get_Elements_For_Purch
--   Handles the project cost element generation for the PO flow.
FUNCTION Get_Elements_For_Purch (
   part_no_                    IN VARCHAR2,
   contract_                   IN VARCHAR2,
   source_ref_type_db_         IN VARCHAR2,
   source_ref1_                IN VARCHAR2,
   source_ref2_                IN VARCHAR2,
   source_ref3_                IN VARCHAR2,
   source_ref4_                IN NUMBER,
   unit_cost_                  IN NUMBER,
   quantity_                   IN NUMBER,
   vendor_no_                  IN VARCHAR2,
   include_cost_of_components_ IN BOOLEAN  DEFAULT TRUE,
   condition_code_             IN VARCHAR2 DEFAULT NULL) RETURN Mpccom_Accounting_API.Project_Cost_Element_Tab
IS
   project_cost_element_tab_   Mpccom_Accounting_API.Project_Cost_Element_Tab;
BEGIN
   IF (unit_cost_ IS NOT NULL) THEN
      project_cost_element_tab_ := Get_Project_Cost_Elements___( part_no_                      => part_no_,
                                                                 contract_                     => contract_,
                                                                 source_ref_type_db_           => source_ref_type_db_,
                                                                 source_ref1_                  => source_ref1_,
                                                                 source_ref2_                  => source_ref2_,
                                                                 source_ref3_                  => source_ref3_,
                                                                 source_ref4_                  => source_ref4_,
                                                                 part_related_                 => TRUE,
                                                                 charge_type_                  => NULL,
                                                                 charge_group_                 => NULL,
                                                                 error_when_element_not_exist_ => TRUE,
                                                                 include_charge_               => NULL,
                                                                 supp_grp_                     => NULL,
                                                                 stat_grp_                     => NULL,
                                                                 assortment_                   => NULL,
                                                                 unit_cost_                    => unit_cost_,
                                                                 unit_cost_is_material_        => TRUE,
                                                                 quantity_                     => quantity_,
                                                                 vendor_no_                    => vendor_no_,
                                                                 condition_code_               => condition_code_ );
   ELSE
      project_cost_element_tab_ := Get_Project_Cost_Elements( contract_                   => contract_,
                                                              part_no_                    => part_no_,
                                                              source_ref_type_db_         => source_ref_type_db_,
                                                              source_ref1_                => source_ref1_,
                                                              source_ref2_                => source_ref2_,
                                                              source_ref3_                => source_ref3_,
                                                              source_ref4_                => source_ref4_,
                                                              quantity_                   => quantity_,
                                                              condition_code_             => NULL,
                                                              part_related_               => TRUE,
                                                              vendor_no_                  => vendor_no_,
                                                              include_cost_of_components_ => include_cost_of_components_ );
   END IF;
   RETURN project_cost_element_tab_;
END Get_Elements_For_Purch;


-- Fill_Project_Cost_Element_Tmp
--   Fills temporary table project_cost_element_tmp with data from recevied
--   Project Cost element Tabs
PROCEDURE Fill_Project_Cost_Element_Tmp (
   planned_amount_tab_           IN Mpccom_Accounting_API.Project_Cost_Element_Tab,
   planned_committed_amount_tab_ IN Mpccom_Accounting_API.Project_Cost_Element_Tab,
   committed_amount_tab_         IN Mpccom_Accounting_API.Project_Cost_Element_Tab,
   used_amount_tab_              IN Mpccom_Accounting_API.Project_Cost_Element_Tab )
IS
BEGIN
   Clear_Temporary_Table___;
   Fill_Temporary_Table___(planned_amount_tab_          , 'PLANNED');
   Fill_Temporary_Table___(planned_committed_amount_tab_, 'PLANNED_COMMITTED');
   Fill_Temporary_Table___(committed_amount_tab_        , 'COMMITTED');
   Fill_Temporary_Table___(used_amount_tab_             , 'USED');
END Fill_Project_Cost_Element_Tmp;


-- Get_Elements_For_Reservations
--   Handles the project cost element generation when parts are reserved.
FUNCTION Get_Elements_For_Reservations (
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN NUMBER,
   source_ref_type_db_ IN VARCHAR2 ) RETURN Mpccom_Accounting_API.Project_Cost_Element_Tab
IS
BEGIN
   RETURN (Inv_Part_Stock_Reservation_API.Get_Project_Cost_Elements(source_ref1_,
                                                                    source_ref2_,
                                                                    source_ref3_,
                                                                    source_ref4_,
                                                                    source_ref_type_db_));
END Get_Elements_For_Reservations;


-- Get_Elements_For_Sales_Oh
--   Returns project cost elements for Sales Overhead, for a given project
--   connected order line.
FUNCTION Get_Elements_For_Sales_Oh (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   oe_order_no_      IN VARCHAR2,
   oe_line_no_       IN VARCHAR2,
   oe_rel_no_        IN VARCHAR2,
   oe_line_item_no_  IN NUMBER,
   sales_qty_        IN NUMBER) RETURN Mpccom_Accounting_API.Project_Cost_Element_Tab
IS
   unit_cost_                 NUMBER;
   sales_oh_cost_detail_tab_  Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   sales_oh_value_detail_tab_ Mpccom_Accounting_API.Value_Detail_Tab;
   sales_oh_cost_elements_    Mpccom_Accounting_API.Project_Cost_Element_Tab;
BEGIN
   unit_cost_ := Inventory_Part_Unit_Cost_API.Get_Inventory_Value_By_Method (contract_, part_no_, '*', NULL, NULL);

   sales_oh_cost_detail_tab_ := Inventory_Transaction_Hist_API.Get_Sales_Overhead_Details (contract_,
                                                                                           part_no_,
                                                                                           oe_order_no_,
                                                                                           oe_line_no_,
                                                                                           oe_rel_no_,
                                                                                           oe_line_item_no_,
                                                                                           unit_cost_);
   sales_oh_value_detail_tab_ := Inventory_Transaction_Hist_API.Create_Value_Detail_Tab( sales_oh_cost_detail_tab_,
                                                                                         sales_qty_,
                                                                                         part_no_ );
   sales_oh_cost_elements_ := Mpccom_Accounting_API.Get_Project_Cost_Elements(part_no_                      => part_no_,
                                                                              contract_                     => contract_,
                                                                              source_ref_type_db_           => 'CUST ORDER',
                                                                              source_ref1_                  => oe_order_no_,
                                                                              source_ref2_                  => oe_line_no_,
                                                                              source_ref3_                  => oe_rel_no_,
                                                                              source_ref4_                  => oe_line_item_no_,
                                                                              part_related_                 => TRUE,
                                                                              charge_type_                  => NULL,
                                                                              charge_group_                 => NULL,
                                                                              error_when_element_not_exist_ => TRUE,
                                                                              include_charge_               => NULL,
                                                                              supp_grp_                     => NULL,
                                                                              stat_grp_                     => NULL,
                                                                              assortment_                   => NULL,
                                                                              value_detail_tab_             => sales_oh_value_detail_tab_,
                                                                              location_type_                => NULL,
                                                                              location_group_               => NULL,
                                                                              sales_overhead_               => TRUE);

   RETURN sales_oh_cost_elements_;
END Get_Elements_For_Sales_Oh;

-- Get_Location_Type_And_Group
--   Returns the location type and location group of a part hierarchically.
PROCEDURE Get_Location_Type_And_Group (
   location_type_db_             OUT VARCHAR2,
   location_group_               OUT VARCHAR2,
   contract_                     IN  VARCHAR2,
   part_no_                      IN  VARCHAR2 )
IS
   location_no_                  warehouse_bay_bin_tab.location_no%TYPE;
BEGIN
   location_no_ := Inventory_Part_Def_Loc_API.Get_Location_No(contract_, part_no_);
   IF (location_no_ IS NULL) THEN
      -- Note: If a location_no not found fetch the location no for the part for location type Arrival.
      location_no_ := Inventory_Part_Def_Loc_API.Get_Arrival_Location_No(contract_, part_no_);
      IF (location_no_ IS NULL) THEN
         -- Note: If a location_no not found fetch the location no for the part for location type QA. 
         location_no_ := Inventory_Part_Def_Loc_API.Get_Qa_Location_No(contract_, part_no_);                         
      END IF;
   END IF;
   location_group_           := Inventory_Location_API.Get_Location_Group(contract_, location_no_);
   location_type_db_         := Inventory_Location_Group_API.Get_Inventory_Location_Type_Db(location_group_);   
END Get_Location_Type_And_Group;

