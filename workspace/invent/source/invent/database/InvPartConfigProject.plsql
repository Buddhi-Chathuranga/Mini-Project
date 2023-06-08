-----------------------------------------------------------------------------
--
--  Logical unit: InvPartConfigProject
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  190315  ChFolk  SCUXXW4-5991, Renamed Get_Inventory_Quantities and Part_Config_Proj_Quantity_Rec as Get_Part_Config_Details and Part_Config_Proj_Details_Rec
--  190315          as it gives more information to be used by the respective client window.
--  190314  ChFolk  SCUXXW4-17044, Added UncheckedAccess annotation into Get_Inventory_Quantities.
--  190305  ChFolk  SCUXXW4-5991, Modified Get_Inventory_Quantities to add latest snapshot id into the pipeline method.
--  190302  ChFolk  SCUXXW4-5991, Modified Get_Inventory_Quantities to include latest snapshot_id into the return rec.
--  190302          Added Snapshot_id into Part_Config_Proj_Quantity_Rec.
--  190222  ChFolk  SCUXXW4-5991, Added new record type Part_Config_Proj_Quantity_Rec and method Get_Inventory_Quantities.
--  171023  ChFolk  STRSC-6, Created LU and added public method New. Override Raise_Record_Exist___.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
TYPE Part_Config_Proj_Details_Rec IS RECORD (
   onhand_qty                  NUMBER,
   in_transit_qty              NUMBER,
   usable_qty                  NUMBER,
   available_qty               NUMBER,
   cost_per_unit               NUMBER,
   alternate_part_exist        VARCHAR2(5),
   picking_leadtime            NUMBER,
   unlimited_purch_leadtime    DATE,
   unlimited_manuf_leadtime    DATE,
   unlimited_expected_leadtime DATE,
   unlimited_picking_leadtime  DATE,
   last_year_out               NUMBER,
   last_year_in                NUMBER,
   abc_percent                 NUMBER,
   current_year_out            NUMBER,
   current_year_in             NUMBER,
   primary_supplier            VARCHAR2(20),
   main_vendor_name            VARCHAR2(100),
   snapshot_id                 NUMBER);

TYPE Part_Config_Proj_Details_Arr IS TABLE OF Part_Config_Proj_Details_Rec;

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Raise_Record_Exist___ (
   rec_ inv_part_config_project_tab%ROWTYPE )
IS
   exit_procedure EXCEPTION;
BEGIN
   RAISE exit_procedure;   
   super(rec_);
   
   EXCEPTION 
      WHEN exit_procedure THEN
         NULL;      
END Raise_Record_Exist___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
PROCEDURE New (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   project_id_       IN VARCHAR2 )
IS
   newrec_   inv_part_config_project_tab%ROWTYPE;
BEGIN
   newrec_.contract           := contract_;
   newrec_.part_no            := part_no_;
   newrec_.configuration_id   := configuration_id_;
   newrec_.project_id         := project_id_;
   New___(newrec_);         
END New;

@UncheckedAccess
FUNCTION Get_Part_Config_Details (
   contract_           IN VARCHAR2,
   part_no_            IN VARCHAR2,
   configuration_id_   IN VARCHAR2,
   project_id_         IN VARCHAR2,
   site_date_          IN DATE,
   dist_calendar_id_   IN VARCHAR2,
   manuf_calendar_id_  IN VARCHAR2,   
   leadtime_code_db_   IN VARCHAR2 ) RETURN Part_Config_Proj_Details_Arr PIPELINED
  
IS 
   rec_                     Part_Config_Proj_Details_Rec;
   physical_qty_            NUMBER;
   dummy_                   NUMBER;
   qty_in_transit_          NUMBER;
   qty_onhand_              NUMBER;
   qty_reserved_            NUMBER;
   qty_in_transit_exp_and_sup_control_ NUMBER;
   include_standard_        VARCHAR2(5) := 'TRUE';
   include_project_         VARCHAR2(5) := 'TRUE';
   local_project_id_        VARCHAR2(10);
   local_configuration_id_  VARCHAR2(50);
   stat_year_no_            NUMBER;
   
   CURSOR get_max_snapshot_id IS
      SELECT MAX(snapshot_id)
         FROM INV_PART_AVAIL_SUM_QTY_TMP
         WHERE contract = contract_
         AND part_no = part_no_
         AND configuration_id = configuration_id_
         AND project_id = project_id_;
BEGIN
   stat_year_no_ := Statistic_Period_API.Get_Stat_Year_No(site_date_);
   local_project_id_ := project_id_;
   local_configuration_id_ := configuration_id_;
   IF (project_id_ = '*') THEN
      include_project_ := 'FALSE';
   ELSIF (project_id_ = '#') THEN
      local_project_id_ := NULL;
   ELSE   
      include_standard_ := 'FALSE';
   END IF;
   IF (configuration_id_ = '#') THEN
      local_configuration_id_ := NULL;
   END IF;   
   Inventory_Part_In_Stock_API.Get_Inventory_Quantity(qty_onhand_		      => physical_qty_,
                                                      qty_reserved_	      => dummy_,
                                                      qty_in_transit_	   => qty_in_transit_,
                                                      contract_		      => contract_,
                                                      part_no_		         => part_no_,
                                                      configuration_id_	   => local_configuration_id_,
                                                      expiration_control_  => NULL,
                                                      supply_control_db_	=> NULL,
                                                      ownership_type1_db_  => 'CONSIGNMENT',
                                                      ownership_type2_db_  => 'COMPANY OWNED',
                                                      location_type1_db_	=> 'PICKING',
                                                      location_type2_db_	=> 'F',
                                                      location_type3_db_   => 'MANUFACTURING',
                                                      location_type4_db_	=> 'SHIPMENT',
                                                      include_standard_	   => include_standard_,
                                                      include_project_	   => include_project_,
                                                      project_id_		      => local_project_id_);
                                                      
   Inventory_Part_In_Stock_API.Get_Inventory_Quantity(qty_onhand_		      => qty_onhand_,
                                                      qty_reserved_	      => qty_reserved_,
                                                      qty_in_transit_	   => qty_in_transit_exp_and_sup_control_,
                                                      contract_		      => contract_,
                                                      part_no_		         => part_no_,
                                                      configuration_id_	   => local_configuration_id_,
                                                      expiration_control_  => 'NOT EXPIRED',
                                                      supply_control_db_	=> 'NETTABLE',
                                                      ownership_type1_db_	=> 'CONSIGNMENT',
                                                      ownership_type2_db_	=> 'COMPANY OWNED',
                                                      location_type1_db_	=> 'PICKING',
                                                      location_type2_db_	=> 'F',
                                                      location_type3_db_   => 'MANUFACTURING',
                                                      location_type4_db_	=> 'SHIPMENT',
                                                      include_standard_	   => include_standard_,
                                                      include_project_	   => include_project_,
                                                      project_id_		      => local_project_id_);
   
   rec_.onhand_qty := NVL(physical_qty_, 0);
   rec_.in_transit_qty := NVL(qty_in_transit_, 0);
   rec_.usable_qty := NVL(qty_onhand_, 0) + NVL(qty_in_transit_exp_and_sup_control_, 0);
   rec_.available_qty := NVL(qty_onhand_, 0) - NVL(qty_reserved_, 0) + NVL(qty_in_transit_exp_and_sup_control_, 0);
   rec_.cost_per_unit := Inventory_Part_Unit_Cost_API.Get_Inventory_Value_By_Config(contract_, part_no_, configuration_id_);
   rec_.alternate_part_exist := Inventory_Part_API.Check_If_Alternate_Part(contract_, part_no_);
   rec_.picking_leadtime := Site_Invent_Info_API.Get_Picking_Leadtime(contract_);
   rec_.unlimited_purch_leadtime := Inventory_Part_API.Get_Ultd_Purch_Supply_Date__(contract_, part_no_, dist_calendar_id_, site_date_);
   rec_.unlimited_manuf_leadtime := Inventory_Part_API.Get_Ultd_Manuf_Supply_Date__(contract_, part_no_, manuf_calendar_id_, site_date_);
   rec_.unlimited_expected_leadtime := Inventory_Part_API.Get_Ultd_Expect_Supply_Date__(contract_, part_no_, leadtime_code_db_, dist_calendar_id_, manuf_calendar_id_, site_date_);
   rec_.unlimited_picking_leadtime := Work_Time_Calendar_API.Get_End_Date(dist_calendar_id_, site_date_, rec_.picking_leadtime+ 1);
   rec_.last_year_out := Inventory_Part_Period_Hist_API.Get_Total_Issued(contract_, part_no_, configuration_id_, Statistic_Period_API.Get_Previous_Year(stat_year_no_), null);
   rec_.last_year_in := Inventory_Part_Period_Hist_API.Get_Total_Received(contract_, part_no_, configuration_id_, Statistic_Period_API.Get_Previous_Year(stat_year_no_), null);
   rec_.abc_percent := Abc_Class_API.Get_Abc_Percent(Inventory_Part_API.Get_Abc_Class(contract_, part_no_));
   rec_.current_year_out := Inventory_Part_Period_Hist_API.Get_Total_Issued(contract_, part_no_, configuration_id_, stat_year_no_, null);
   rec_.current_year_in := Inventory_Part_Period_Hist_API.Get_Total_Received(contract_, part_no_, configuration_id_, stat_year_no_, null);
   $IF Component_Purch_SYS.INSTALLED $THEN
      rec_.primary_supplier := Purchase_Part_Supplier_API.Get_Primary_Supplier_No(contract_, part_no_);
      rec_.main_vendor_name := Supplier_API.Get_Vendor_Name(rec_.primary_supplier);
   $END   
   OPEN get_max_snapshot_id;
   FETCH get_max_snapshot_id INTO rec_.snapshot_id;
   CLOSE get_max_snapshot_id;
          
   PIPE ROW (rec_);
END Get_Part_Config_Details;
