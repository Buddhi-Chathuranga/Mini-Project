-----------------------------------------------------------------------------
--
--  Logical unit: OrderSupplyDemand
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210908  MUSHLK  MF21R2-2395, Removed method Get_Total_Forecast() that was added as a temporary solution for Intraday Planning (due to a code genetaion error in DS).
--  210629  Shwtlk  MF21R2-2379, Added Negative_Projected_Qty_Exists() get the negative projected quantitiy indicator to be used in Inventory Parts Intraday Availability Client.
--  210629  MUSHLK  MF21R2-2394, Added method Get_Total_Forecast() that will call the method Get_Ms_Forecast() from MASSCH module(Temporary solution for DS code genetaion error).
--  210614  JoAnSe  MF21R2-2061, Added default parameter to Get_Total_Supply and Get_Total_Demand to consider only firm supplies and demands.
--  200706  BudKlk  SCXTEND-4457, Modified the methods Get_Ord_Supply_Demands___() and Check_If_Order___() by adding an optional parameter order_proposal_trigger_db 
--  200706          to handle values less than the order point quantity.
--  200214  ManWlk  Bug 147099, Increased the length of line_no column in Order_Supply_Demand_Ms_Rec to VARCHAR2(40).
--  191104  Dinklk  MFXTEND-1729, Moved procedure Generate_Snapshot___ from InventoryPartAvailabilityPlanningAnalysis.plsvc to this file as Generate_Availability_Snapshot.
--  191104          This public procedure will be used by Inventory Part Availability Planning page and Visual Inventory Part Availability Planning page.
--  190529  ChFolk  SCUXXW4-19189, Removd TRUNC(date_required) in Order By in Calc_Detail_Planning, Calc_Procurement_Planning and Calc_Plannable_Per_Part_Detail.
--  190314  ChFolk  SCUXXW4-17045, Added UncheckedAccess annotation into Calc_Detail_Planning, Calc_Sum_Detail_Planning, Calc_Procurement_Planning,
--  190314                         Calc_Sum_Procurement_Planning, Calc_Plannable_Per_Part_Detail and Calc_Plannable_Per_Part_Sum.
--  190225  ChFolk  SCUXXW4-5991, Added method Clear_Inv_Part_Avail_Sum_Qty__ which delete old records of INV_PART_AVAIL_SUM_QTY_TMP.
--  190222  ChFolk  SCUXXW4-7177, Added new method Calc_Plannable_Per_Part_Sum.
--  190222  ChFolk  SCUXXW4-7172, Added new method Calc_Plannable_Per_Part_Detail and record type Plannable_Per_Part_Rec.
--  190222  ChFolk  SCUXXW4-7302, Added new method Calc_Sum_Procurement_Planning.
--  190222  ChFolk  SCUXXW4-7182, Added new method Calc_Procurement_Planning.
--  190222  ChFolk  SCUXXW4-7297, Added new method Calc_Sum_Detail_Planning
--  190222  ChFolk  SCUXXW4-7317, Added new method Calc_Detail_Planning and record type Planning_Rec.
--  170308  VISALK  STRMF-10005, Modifed Get_Net_Expired_Date_And_Qty() to consider the unconsumed expired qty instead of projected on hand.
--  170307  Ospalk  STRMF-9952, Modified Get_Net_Expired_Date_And_Qty method. Get the Prior work day as calc_exp_date after reduce min_durab_days_planning_ from expiration date.
--  170131  AyAmlk  APPUXX-8858, Added configuration_id_ as a new parameter to Get_Sum_Quantity() methods.
--  170130  MAJOSE  STRMF-9433, Added method Get_Net_Expired_Date_And_Qty
--  161130  VISALK  STRMF-8312, Modified Generate_Next_Level_Demands() to consider the safety_time offset.
--  151216  AwWelk  GEN-749, Modified method Get_Sum_Supply_Demand_Per_Date by adding parameters configuration_id_, include_demands_, include_supplies_,
--  151216          from_date_ and to_date_ to facilitate more functionality.
--  160530  Jhalse  STRSC-2173, Fixed bug regarding with scrap factor not being considered in Generate_Next_Level_Demands.
--  160503  JeLise  STRSC-2175, Added check on component installed in Open_Projects_Exist.
--  160219  JeLise  STRSC-523, Made references to ORDER_SUPPLY_DEMAND_EXT dynamic since this view is created in POST section.
--  160218  JeLise  STRSC-522, Made references to ORDER_SUPPLY_DEMAND dynamic since this view is created in POST section.
--  160218  JeLise  STRSC-330, Made references to CUSTORD_SUPPLY_DEMAND dynamic since this view is created in POST section.
--  151026  HaPulk  STRSC-298, Make references ORDER_SUPPLY_DEMAND_MS as Dynamic since this object is created in POST section.
--  150331  SBalLK  Bug 120884, Modified Get_Qty_Plannable_Fast___() method to get plannable and CO plannable information according to the stop analysis date
--  150331          since the table contains maximum data according to the maximum date for Manufacture leadtime and  Expected Leadtime of the part.
--  140602  Rakalk  Replaced function Get_Total_Supply_Per_Type with Get_Supply_Demand_Per_Type
--  140314  MaEdlk  Bug 115505, Added Pragma to the method Get_Available_Balance_Tmp__.
--  140224  SeJalk  Bug 114739, Modified Get_Planned_Del_Date_Shell(), set Parameter exclude_reserved_ as TRUE in methods calls 
--  140224          Get_Available_Balance and Get_Planned_Delivery_Date.
--  130822  RaKalk  Added Get_Total_Supply_Per_Type method and Total_Supply_Per_Type_Tab PLSQL table.
--  -------------------------- MV ---------------------------------------
--  130911  PraWlk  Bug 107032, Removed the clause ORDER BY project_id from Views INVENTORY_PART_CONFIG_PROJECT and INV_PART_CONFIG_PROJECT_TM 
--  130911          as the soting logic moved to client side.
--  130813  Asawlk  TIBE-925, Added methods Clear_Old_Snapshots___() and Clear_Snapshot___(). Also modified Clear_Snapshot__() to use the above mentioned methods. 
--  130813  Asawlk  TIBE-925, Renamed methods Add_Sup_Dem_Info_Auto___() and Add_Sup_Dem_Plan_Info_Auto___() to Add_Sup_Dem_Info___() and Add_Sup_Dem_Plan_Info___() respectively. 
--  130813  Asawlk  TIBE-925, Made Add_Sup_Dem_Info_Auto___() and Add_Sup_Dem_Plan_Info_Auto___() ordinary methods by removing autonomous transaction handling. Added 
--  130813          rowversion to tables supply_demand_info_tmp and sup_dem_plannable_info_tmp.     
--  130809  ChJalk  TIBE-899, Removed the global variables inst_ShopOrderProp_, inst_PurchaseRequisition_, inst_PurchaseReqUtil_, inst_DistributionOrder_, inst_SupplySourcePartMan_ and last_calendar_date_.
--  130718  Asawlk  TIBE-925, Persistent tables supply_demand_info_tmp and sup_dem_plannable_info_tmp are used with "Inventory Part Availability Planning" 
--  130718          instead of existing session specific temporary tables. Code was modified accordingly. New autonomous transaction handling methods
--  130718          Add_Sup_Dem_Info_Auto___, Add_Sup_Dem_Plan_Info_Auto___ and Clear_Snapshot_Auto__ were introduced.
--  130711  AndDse  AB-361, Consolidated MPR and PMRP, PMRP_PART_SUPPLY_DEMAND_EXT data is now in MRP_PART_SUPPLY_DEMAND_EXT.
--  130530  PraWlk  Bug 109943, Removed the in parameter disp_qty_onhand_ from Generate_Next_Level_Demands() as the plannable on hand qty calculation logic  
--  130530          re-implemented. Also modified the cursor generate_demand to consider the condition code when fetching the supply_demand_.  
--  120925  PraWlk  Bug 104500, Modified Populate_Temporary_Tables__(), Get_Qty_Plannable_Fast___() and Clear_Snapshot__() to improve the performance.
--  120925          Also moved the record type Available_Balance declaration to the 'PACKAGES FOR METHODS' section.
--  120711  MaHplk  Added the parameter picking_leadtime to Get_Planned_Del_Date_Shell.
--  120706  SBallk  Bug 102069, Modified INV_PART_CONFIG_PROJECT_ALT view by adding qty_onhand, qty_supply and qty_demand columns and filtered for user allowed sites.
--  120405  HimRlk  Bug 100038, Added new view INV_PART_CONFIG_PROJECT_ALT.
--  120404  AyAmlk  Bug 100580, Added method Open_Projects_Exist() to check whether there exist open projects for a particular contract
--  120404          and modified the views INVENTORY_PART_CONFIG_PROJECT and INV_PART_CONFIG_PROJECT_TM to restrict populating  
--  120404          duplicate records with PROJECT ID = '#' when there are no open projects.
--  111219  Matkse  Added EARLIEST_ULTD_SUPPLY_DATE to the view INVENTORY_PART_CONFIG_PROJECT 
--  111216  LEPESE  Made sure that (earliest_ultd_supply_date - 1) becomes a work day.
--  111215  LEPESE  Added consideration of earliest_ultd_supply_date for purchased parts.
--  111031  NaEelk  Added UAS Filter to CUSTORD_SUPPLY_DEMAND_TMP_VIEW.
--  111031  MaEelk  Added UAS Filter to ORDER_SUPPLY_DEMAND_SUM.
--  111031  MaEelk  Added UAS Filter to ORDER_SUPPLY_DEMAND_TMP_VIEW
--  111031  MaEelk  Added UAS Filter to ORDER_SUPP_DEM_EXT_TMP_VIEW.
--  111028  NISMLK  SMA-285, Increased eng_chg_level_ length to VARCHAR2(6) in Generate_Next_Level_Demands method.
--  111027  MaEelk  Added UAS Filter to INVENTORY_PART_CONFIG_PROJECT.
--  110929  RaKalk  EASTTWO-12703, Added exclude_reserved_ and exclude_pegged_ parameters to Get_Planned_Delivery_Date
--  110907  RoJalk  Modified the cursor in Get_Sum_Quantity to check if end_date_ is not null.
--  110907          Modified Get_Total_Supply and removed inner NVL statement.
--  110830  MaEelk  Increased the length of rel_no to STRING(40) in CUSTORD_SUPPLY_DEMAND_TMP_VIEW.
--  110823  RoJalk  Removed the parameters include_standard_, include_project, activity_seq_ from Get_Net_Demand_Per_Demand_Type.
--  110822  Asawlk  Bug 98447, Modified view comment of rel_no to set the length to STRING(40) in views ORDER_SUPPLY_DEMAND and ORDER_SUPPLY_DEMAND_TMP_VIEW.
--  110818  RoJalk  Added the procedure Get_Sum_Quantity.
--  110816  RoJalk  Added NVL to the qty columns in Get_Order_Supply_Demand_Tab returning Order_Supply_Demand_Ext_Tab.
--  110815  PraWlk  Added new methods Check_If_Order_New___(), Get_Ord_Supply_Demands_Old___() and 
--  110815          Get_Ord_Supply_Demands_New___(). Modified the name of Check_If_Order___() to Check_If_Order_Old___().
--  110815          Modified Get_Order_Supply_Demands() to call Get_Ord_Supply_Demands_Old___() and Get_Ord_Supply_Demands_New___() 
--  110815          depending on the condition immediate replenishment true or false.
--  110812  RoJalk  Code improvements to the method Get_Order_Supply_Demand_Tab.
--  110812  RoJalk  Added the default null parameter order_supply_demand_type_ to the method 
--  110812          Get_Total_Supply.Removed the parameter include_all_demand_types from the
--  110812          Get_Net_Demand_Per_Demand_Type and modified the cursor get_demand. 
--  110721  RoJalk  Modified Get_Order_Supply_Demand_Tab returning Custord_Supply_Demand_Tab 
--  110721          to order the result set by date_required. 
--  110721  RoJalk  Added the method Get_Order_Supply_Demand_Tab returning Custord_Supply_Demand_Tab.
--  110721          Added the parameters specifying the order supply demand types to 
--  110721          Get_Order_Supply_Demand_Tab method returning Order_Supply_Demand_Ext_Tab.
--  110718  RoJalk  Renamed Get_Total_Demand with conditions to filter by the 
--  110718          order_supply_demand_type to Get_Net_Demand_Per_Demand_Type.
--  110715  RoJalk  Added Get_Total_Demand and overloaded methods Get_Order_Supply_Demand_Tab.
--  110708  RoJalk  Added the method Get_Sum_Quantity to support the requirements from MPRP/MRP and fix the 
--  110708          parallel deployment problem when accessing the ORDER_SUPPLY_DEMAND_EXT view directly.
--  110610  MAJOSE  Bug 97433, Reworked method Get_Total_Demand so that it is possible to include or exclude reserved
--                  demand. Added parameter exclude_reserved_ to this method.
--  110317  Umdolk  Added ORDER_SUPPLY_DEMAND_EXT_UIV.
--  ----------------------- Blackbird Merge End -----------------------------
--  110213  Nuwklk  Merge Blackbird Code
--  100610  SuThlk  BB08: Added views MAINT_ORDER_MATR_DEMAND, MAINT_ORDER_MATR_DEMAND_OE, MAINT_ORDER_MATR_DEMAND_MS, MAINT_ORDER_MATR_DEMAND_EXT.
--  ----------------------- Blackbird Merge Start -----------------------------
--  110203  KiSalk  Moved 'User Allowed Site' Default Where condition from client to base VIEW2_TM.
--  101025  MAJOSE  Bug 93773, Changed parameterlist of Get_Supply_Demand_Info.
--  101015  GayDLK  Bug 93374, Changed the place where the comments were added from the previous correction of the same bug.
--  101005  GayDLK  Bug 93374, Added a '-' as the Lov Flag for DESCRIPTION column in CUSTORD_SUPPLY_DEMAND view. Added a '-' as the 
--  101005          Lov Flag for INFO and STATUS_DESC columns in ORDER_SUPPLY_DEMAND_EXT view. Added a '-' as the Lov Flag for STATUS_DESC 
--  101005          column in ORDER_SUPPLY_DEMAND_MS view. 
--  100511  DAYJLK  Bug 90486, Added function Convert_Graph_Label_Format__ to set appropriate date format on graph labels in client.
--  100505  KRPELK  Merge Rose Method Documentation.
--  100426  NuVelk  Merged TWIN PEAKS.
--  090218  RoJalk  Removed the parameter project_id_ from Get_Sum_Pegged_Per_Date_Proj__. 
--  090218          Removed the columns part_no_, contract_, configuration_id_ 
--  090218          and project_id_, include_standard_ and include_project_ from views 
--  090218          ORDER_SUPPLY_DEMAND_SUM_PROJ and ORDER_SUPPLY_DEMAND_SUM.  
--  090120  RoJalk  Removed the assignment of '#' as project_id inside Populate_Temporary_Tables__.  
--  090120  RoJalk  Modified the Get_Sum_Pegged_Per_Date_Proj__ and Get_Sum_Pegged_Per_Date__
--  090120          and removed the usage of contract_, part_no_ and configuration_id_.
--  090115  RoJalk  Modified the scope of Get_Sum_Pegged_Per_Date and Get_Sum_Pegged_Per_Date_Proj
--  090115          to be private, added the parameter snapshot_id_.  
--  090112  RoJalk  Removed the parameter include_all_ from Populate_Temporary_Tables__. 
--  081229  RoJalk  Modified INV_PART_CONFIG_PROJECT_TM and INVENTORY_PART_CONFIG_PROJECT
--  081229          to support '#' as project id.Added the parameter include_all_
--  081229          to Populate_Temporary_Tables__.
--  100108  KiSalk  Replaced Shop_Order_Prop_Int_API calls with other APIs.
--  091218  SaWjlk   Bug 85239, Modified view INVENTORY_PART_CONFIG_PROJECT by adding attribute lead_time_code_db.
--  091030  ShKolk  Bug 86768, Merge IPR to APP75 core.
--  090930  ChFolk  Removed unused global constant first_calendar_date_. Removed unused parameter picking_leadtime_ from
--  090930          Get_Qty_Plannable_Fast___.
--  ------------------------------- 14.0.0 ------------------------------------
--  090810  HoInlk  Bug 83043, Modified Check_If_Order___  to use previous work day instead of next.
--  090522  MalLlk  Bug 82626, Created views ORDER_SUPPLY_DEMAND_SUM_PROJ2 and ORDER_SUPPLY_DEMAND_SUM2 to support web client without
--  090522          using temporary tables. Added two overloaded methods Get_Sum_Pegged_Per_Date_Proj__ and Get_Sum_Pegged_Per_Date__ 
--  090522          to get the values without using order supply demand temporary tables in order to support web client.
--  090522          Added methods Get_Sum_Pgd_Per_Date_Proj___ and Get_Sum_Pegged_Per_Date___ by moving the logic from  
--  090522          Get_Sum_Pegged_Per_Date_Proj__ and Get_Sum_Pegged_Per_Date__ respectivly and by handling non temporary table logic.
--  090205  HaPulk  Bug 80139, Changed methods Get_Sum_Pegged_Per_Date_Proj/Get_Sum_Pegged_Per_Date_Proj as private 
--  090205          and read temporary tables instead of ordinary views.
--  081023  UTSWLK  Bug 76572, Added new functions Get_Total_Demand and Get_Total_Supply.
--  080925  HaPulk  Bug 76499, Added Populate_Temporary_Tables to insert records to temporary tables, Clear_Snapshot__  
--  080925          to clear temporay tables and function Get_Available_Balance_Tmp to return values from Temporary tables.
--  080925          Created view ORDER_SUPPLY_DEMAND_SUM based on temporary data in ORDER_SUPPLY_DEMAND_TMP_VIEW and 
--  080925          view ORDER_SUPPLY_DEMAND_SUM_PROJ based on ORDER_SUPP_DEM_EXT_TMP_VIEW. 
--  080925          Added view INV_PART_CONFIG_PROJECT_TM the simplest version of INVENTORY_PART_CONFIG_PROJECT 
--  080925          to populate combo box of frmAvailabilityPlanning.
--  080925          Added fields site_date, dist_calendar_id and manuf_calendar_id to INVENTORY_PART_CONFIG_PROJECT.
--  080925          Added snapshot_id to GROUP BY clause in views ORDER_SUPPLY_DEMAND_SUM and ORDER_SUPPLY_DEMAND_SUM_PROJ.
--  080925          Added columns include_standard and include_project to INVENTORY_PART_CONFIG_PROJECT, ORDER_SUPPLY_DEMAND_SUM_PROJ
--  080925          Added Get_Qty_Plannable_Fast_Tmp__ to return plannable quantity based on order supply demand temporary tables.
--  080925          Added Get_Qty_Plannable_Fast___ to encapsulate logic in Get_Qty_Plannable_Fast/Get_Qty_Plannable_Fast_Tmp__.
--  080909  JaBalk  Bug 76568, Renamed the views MODULE_VIEW20, MODULE_VIEW20_CUSTORD, MODULE_VIEW24_MS, MODULE_VIEW35_EXT.
--  080908  ChFolk  Bug 76568, Included views of purchase order charge component supply and demand to the main views.
--  080801  NiBalk  Bug 74688, Modified Generate_Next_Level_Demands to handle next level demands.
--  080701  NiBalk  Bug 73254, Modified the from clause of view INVENTORY_PART_CONFIG_PROJECT  
--  080701          by replacing the use of ORDER_SUPPLY_DEMAND_EXT and  
--  080701          INVENTORY_PART_IN_STOCK_TAB and instead using view OPEN_PROJECT_SITE 
--  080701          in a join with INVENTORY_PART_CONFIG_TAB.
--  080510  HoInlk  Bug 73474, Modified method Get_Qty_Plannable_Shell by setting exclude_reserved_ to TRUE
--  080510          when calling methods Get_Available_Balance and Get_Qty_Plannable_Fast.
--  080425  MAJOSE  Bug 73405, Corrected Get_Supply_Demand_Info. When calculating qty_demand info from CUSTORD_SUPPLY_DEMAND we must
--                  also reduce qty_demand with qty_reserved in this function.
--  070914  MiKulk  Modified the method Get_Qty_Plannable_Shell to correcly handle the stop_analysis_date_, when it reaches the last_Calendar_date_.
--  070913  KaDilk  Bug 67116, Increase the length of the column order_supply_demand_type in views ORDER_SUPPLY_DEMAND_EXT. ORDER_SUPPLY_DEMAND_MS and CUSTORD_SUPPLY_DEMAND.
--  070712  KaDilk  Bug 66312, Modified the method Check_If_Order___. When the from_order_date_ is not a working day,
--  070705          used the next working day to calculate the to_order_date_.
--  070727  MiKulk  Changed planned_due_date_ to IN OUT parameter in the call to method Distribution_Order_API.Create_Distribution_Order.
--  070512  Kaellk  Bug 61731, Included views of transport task supply & demand to the main views.
--  070425  NaLrlk  Bug 64414, Modified method Get_Qty_Plannable_Fast. Removed "IF i_ = 0" statement.
--  070419  KaDilk  Merge 64116, Modification in view INVENTORY_PART_CONFIG_PROJECT to Select from TABs instead of public views, 
--  070419          Removed outer-join and Distinct keywords in the view.
--  070208  ViWilk  Added infinite_leadtime_ parameter to Get_Qty_Plannable_Shell.
--  070206  NuVelk  Bug 63114, Used CHR(31) as the field separater in INVENTORY_PART_CONFIG_PROJECT.objid.
--  061126  ChBalk  Bug 60516, Made changes to the Get_Balance cursor in method Get_Avail_Balance_Per_Date.
--  061125  NiDalk  Bug 61254, Modified method Calc_Make_Buy_Split_Qty inorder to create Purchase and
--  061024          Shop Order requisitions correctly, specially when no primary supplier is found. 
--  060810  ChJalk  Modified hard_coded dates to be able to use any calendar.
--  060727  RoJalk  Centralized Part Desc - Use Inventory_Part_API.Get_Description.
--  060628  DaZase  Replaced calls to obsolete method Inventory_Part_Planning_API.Get_Scrapping_Rounded_Qty with Inventory_Part_API.Get_Calc_Rounded_Qty.
--  060601  RoJalk  Enlarge Part Description - Changed view comments.
--  060508  HaPulk  Bug 57351, Added columns second_commodity and part_status to view inventory_part_config_project.
--  060424  IsAnlk  Enlarge supplier - Changed variable definitions.
--  --------------------------------------13.4.0-----------------------------------
--  060321  JOHESE  Added condition in Get_Qty_Plannable_Fast to return null if no data is available
--  060303  IsWilk  (LCS 54729)Increased the length demand_release_ to 12 in PROCEDURE Generate_Next_Level_Demands.
--  060124  NiDalk  Added Assert safe annotation. 
--  060112  Asawlk  Bug 55356, Modified Get_Qty_Plannable_Shell and Get_Planned_Del_Date_Shell in order
--  060112          to exclude the check for inventory part status.
--  051229  JOHESE  Changed data type on parameter requisition_no_ in Add_Order_To_Attr___
--  051003  KeFelk  Added Site_Invent_Info_API in relavant places where Site_API is used.
--  050921  NiDalk  Removed unused variables.
--  050818  ARAMLK  Add view MATERIAL_TRANS_REQUISITION_EXT.
--  050815  VeMolk  Bug 50869, Modified the call to the method Inventory_Part_In_Stock_API.Make_Onhand_Analysis in Get_Qty_Plannable.
--  050802  RaSilk  Added Dop Netted Demand to EXT views.
--  050711  CHASLK  Bug 51646, Modified method Get_Supply_Demand_Info to include include Purchase Requisitions in supply
--  050704  ARAMLK  Rename PDSM_PART_SUPPLY_DEMAND_EXT and PDSM_MTR_DEMAND_EXT to PMRP_PART_SUPPLY_DEMAND_EXT and PMRP_MTR_DEMAND_EXT
--  050617  MICIUS  Fixed MODULE_VIEW30_EXT and MODULE_VIEW31_EXT so they don't use configuration_id '*'.
--  050511  JOHESE  Added reserved_qty to CUSTORD_SUPPLY_DEMAND_SUM
--  050331  MICIUS  Added INTERIM_ORDER_DEMAND_CTP_EXT and INTERIM_ORDER_SUPPLY_CTP_EXT.
--  050317  JOHESE  Added view CUSTORD_SUPPLY_DEMAND_SUM
--  050228  WaJalk  Added new views PDSM_PART_SUPPLY_DEMAND_EXT and PDSM_MTR_DEMAND_EXT to ORDER_SUPPLY_DEMAND_EXT.
--  050225  JOHESE  Added 3 new parameters on Get_Qty_Plannable_Fast and Get_Available_Balance to enable the use off different
--                  data sources and different calculations to include reserved/pegged orders or not.
--  050221  MICIUS  Added INTERIM_ORDER_SUPPLY_OE and INTERIM_ORDER_DEMAND_OE as CUSTORD_SUPPLY_DEMAND views.
--  050214  Anlase  Added view ORDER_SUPPLY_DEMAND_SUM_PROJ and method Get_Sum_Pegged_Per_Date_Proj.
--  050207  Anlase  Modified view ORDER_SUPPLY_DEMAND_SUM.
--  050201  AnLaSe  Added view ORDER_SUPPLY_DEMAND_SUM and method Get_Sum_Pegged_Per_Date.
--  050118  JOHESE  Added view INVENTORY_PART_CONFIG_PROJECT
--  041125  JOHESE  Modified Get_Available_Balance, Get_Qty_Plannable_Fast, Get_Planned_Delivery_Date, Get_Avail_Balance_Per_Date and Get_Supply_Demand_Info
--  041108  IsWilk  Modified the FUNCTION Get_Project_Date_Supply_Demand.
--  041104  JOHESE  Added project_id and activity_seq to VIEW_CUSTORD and VIEW_EXT
--  041021  Asawlk  Bug 47224, Modified method Check_If_Order___ to add leadtime in   
--  041021          working days for manufactured parts to calculate to_order_date_.
--  041020  IsWilk  Added the FUNCTION Get_Project_Date_Supply_Demand and Project_Date_Supply_Demand_Rec.
--  040803  HaPulk  Removed dummy views PROMISE_INVENTORY_MS, PROMISE_INVENTORY_EXT,
--  040803          PROMISE_INVENTORY_DEMAND and PROMISE_INVENTORY_OE.
--  040729  KiSalk  In Calc_Make_Buy_Split_Qty, calls to Inventory_Part_Planning_API's Get_Scrap_Added_Qty changed to Get_Scrapping_Rounded_Qty.
--  040714  KiSalk  Added method Calc_Make_Buy_Split_Qty and modified Generate_Next_Level_Demands for multisite MRP.
--  040520  NaWalk  Added sub views, DIST_ORDER_SUPPLY_DEMAND,DIST_ORDER_SUPPLY_DEMAND_OE,DIST_ORDER_SUPPLY_DEMAND_MS,DIST_ORDER_SUPPLY_DEMAND_EXT.
--  040427  AnHose  Bug 44254, Changed back lenght on line_no to 12 in ORDER_SUPPLY_DEMAND and ORDER_SUPPLY_DEMAND_EXT.
--  040423  DaRulk  SCHT603 Modified ORDER_SUPPLY_DEMAND_EXT.
--  040421  KiSalk  SCHT603 Supply Demand Views - Removed all SIM views.
--  040421  NaWalk  Added the column qty_pegged,qty_reserved to views ORDER_SUPPLY_DEMAND, CUSTORD_SUPPLY_DEMAND, ORDER_SUPPLY_DEMAND_MS and ORDER_SUPPLY_DEMAND_EXT.
--  040421  LoPrlk  Added the column condition_code to views ORDER_SUPPLY_DEMAND, CUSTORD_SUPPLY_DEMAND, ORDER_SUPPLY_DEMAND_MS and ORDER_SUPPLY_DEMAND_EXT.
--  040419  DaRulk  SCHT603, Added new views ARRIVED_PUR_ORDER_SUPPLY, ARRIVED_PUR_ORDER_SUPPLY_OE,
--                  ARRIVED_PUR_ORDER_MS,ARRIVED_PUR_ORDER_EXT
--  040308  NaWilk  Bug 38982, Added procedure Get_Supply_Demand_Info.
--  040129  NaWalk  Rewrote the DBMS_SQL to Native dynamic SQL for Unicode modification.
--  040119  HaPulk  Removed connections to module HPM. Drop views HPM_PART_SUPPLY_DEMAND_MS and
--  040119          HPM_PART_SUPPLY_DEMAND_EXT.
--  ------------------------------- 13.3.0 ------------------------------------------------------
--  030820  KiSalk  ***************** CR Merge End ***************************
--  030716  NaWalk  Removed Bug coments.
--  030706  NaWalk  Merged Bug 34773.
--  030630  WaJalk  Added new views related to sourcing.
--  030820  KiSalk  ***************** CR Merge Start *************************
--  030804  DAYJLK  Performed SP4 Merge.
--  030725  SaAblk  Removed references to obsolete view CUSTOMER_ORDER_LINE_MS2
--  030609  SaAblk  Removed references to obsolete view SALES_QUOTATION_LINE_MS2
--  030224  AnLaSe  Merged modifications in Generate_Next_Level_Demands from TakeOff1.
--  030221  Shvese  Removed view definition VIEW_AVB for ORDER_SUPPLY_DEMAND_AVB.
--  **************************** TSO Merge **********************************
--  030127  CaRa    Bug 34773, Removed views created in Bug 27992. Alter originally view PROJECT_DELIVERY_DEMAND.
--  021031  DaZa    Bug 33769, removed view ORDER_SUPPLY_DEMAND_AVB.
--  020924  LEPESE  ***************** IceAge Merge Start *********************
--  020830  GeKaLk  Bug 32159, Included a new view SHOP_ORDER_PROP_SUPPLY and use in the main view ORDER_SUPPLY_DEMAND.
--  020823  ThJalk  Bug 27992, Called PROJECT_DELIVERY_DEMAND_EXT2 and PROJECT_DELIVERY_DEMAND2 insted of
--  020823          PROJECT_DELIVERY_DEMAND_EXT and PROJECT_DELIVERY_DEMAND increased length of line_no to 300
--  020823          for ORDER_SUPPLY_DEMAND_AVB and ORDER_SUPPLY_DEMAND_EXT.
--  020821  GeKaLk  Bug 32159, Include view SHOP_ORDER_PROP_EXT to the main view ORDER_SUPPLY_DEMAND.
--  020924  LEPESE  ***************** IceAge Merge End ***********************
--  020828  BEHAUS  Call 88263 Adjusted Generate_Next_Level_Demands to not account planning supply_demand qty
--                  when condition_code is NOT NULL.
--  020827  BEHAUS  Call 88263 Added condition_code to overloaded Generate_Next_Level_Demands
--  010910  CHAG    Bug 23629, Inclusion of demand SO in status planned in the calculation of planneble qty using
--                  a new view  ORDER_SUPPLY_DEMAND_AVB.
--  010522  JSAnse  Bug fix 21587, Removed dbms_output from PROCEDURE Generate_Next_Level_Demands.
--  010419  SOPRUS  Bug Fix 21257, Join new view from DOP for MS.
--  010410  DaJoLK  Bug fix 20598, Declared Global LU Constants to replace calls to TRANSACTION_SYS.Package_Is_Installed and
--                  TRANSACTION_SYS.Logical_Unit_Is_Installed in methods.
--  001215  PaLj    Changed methods to handele configuration_id IS NULL
--  001215  PaLj    Removed Overloading of: Get_Available_Balance, Get_Sum_Qty_Supply
--                  Get_Qty_Plannable_fast, Get_Planned_Delivery_Date,
--                  Get_Avail_Balance_Per_Date, Get_Order_Supply_Demands.
--                  Changed all overloaded methods.
--  001128  ANLASE  Added method Check_Part_Exist.
--  001121  JOHESE  Moved Purchase_Req_Util_API.Activate_Requisition call.
--  001108  PaLj    Replaced '*' with configuration_id for view SALES_QUOTATION_LINE_DEMAND,
--                  SALES_QUOTATION_LINE_DEMAND_OE, SALES_QUOTATION_LINE_SIM, SALES_QUOTATION_LINE_MS,
--                  SALES_QUOTATION_LINE_EXT, SALES_QUOTATION_LINE_MS2
--  001106  PaLj    Replaced '*' with configuration_id for view DOP_ORDER_DEMAND_EXT,
--                  DOP_ORDER_SUPPLY_EXT, LINE_SCHED_COMP_DEMAND, LINE_SCHED_COMP_DEMAND_OE,
--                  LINE_SCHED_COMP_SIM, LINE_SCHED_COMP_MS, LINE_SCHED_COMP_EXT, LINE_SCHED_SUPPLY,
--                  LINE_SCHED_SUPPLY_OE, LINE_SCHED_SIM, LINE_SCHED_MS, LINE_SCHED_EXT,
--                  SHOP_ORD_SUPPLY, SHOP_ORDER_SIM, SHOP_ORDER_MS, SHOP_ORDER_EXT,
--                  SHOP_ORD_SUPPLY_OE, SHOP_MATERIAL_ALLOC_DEMAND, SHOP_MATERIAL_ALLOC_DEMAND_OE,
--                  SHOP_MATERIAL_ALLOC_SIM, SHOP_MATERIAL_ALLOC_MS, SHOP_MATERIAL_ALLOC_EXT
--  001103  PaLj    Replaced '*' with configuration_id for view CUSTOMER_ORDER_LINE_EXT
--                  CUSTOMER_ORDER_LINE_DEMAND, CUSTOMER_ORDER_LINE_DEMAND_OE,
--                  CUSTOMER_ORDER_LINE_SIM, CUSTOMER_ORDER_LINE_MS, CUSTOMER_ORDER_LINE_MS2,
--  001103  PaLj    Replaced '*' with configuration_id for view PURCHASE_REQUIS_LINE_SUPPLY,
--                  PURCHASE_REQUIS_LINE_SUPPLY_OE, PURCHASE_REQUIS_LINE_SIM,
--                  PURCHASE_REQUIS_LINE_MS and PURCHASE_REQUIS_LINE_EXT
--  001101  PaLj    Replaced '*' with configuration_id for view PURCHASE_ORDER_LINE_SUPPLY,
--                  PURCHASE_ORDER_LINE_SUPPLY_OE, PURCHASE_ORDER_LINE_SIM,
--                  PURCHASE_ORDER_LINE_MS and PURCHASE_ORDER_LINE_EXT
--  001027  ANLASE  Added views PROMISE_INVENTORY_DEMAND, PROMISE_INVENTORY_OE, PROMISE_INVENTORY_SIM,
--                  PROMISE_INVENTORY_MS, and PROMISE_INVENTORY_EXT for CTP.
--  001026  ANLASE  Increased datatype length for line_no and rel_no to 12 in view comments.
--  000925  JOHESE  Added undefines.
--  000918  PaLj    Added overloading with configuration_id as extra parameter to all
--                  public functions and procedures.
--  000901  PaLj    CTO adaptions. Configuration id added to all views but coded as '*' until
--                  we know which views that will have configuration_id.
--  000717  GBO     Merged from Chameleon
--                  Added demand for Order_Quotations with and without sales config options in OrderSupplyDemandMS
--  --------------------------- 12.10 ----------------------------------------
--  000418  NISOSE  Added General_SYS.Init_Method in Generate_Next_Level_Demands.
--  000417  SHVE    Replaced reference to obsolete method Inventory_Part_Planning_API.Get_Scrapping_Adjusted_Qty
--                  with Inventory_Part_Planning_API.Get_Scrap_Added_Qty.
--  000414  NISOSE  Cleaned-up General_SYS.Init_Method.
--  000331  ANLASE  Replaced Mpccom_System_Parameter_API.Get_Parameter_Value1
--                  with Site_API.Get_Picking_Leadtime.
--  000225  ANLASE  Changed length of contract (to 5) in Generate_Next_Level_Demands.
--  991207  JOHW    Changed name from CELL_SCHED_... to LINE_SCHED_...
--  990922  LEPE    Bug fix 11720. Corrections in method Get_Order_Supply_Demands.
--  990920  ROOD    Added Get_Planned_Delivery_Date, Get_Planned_Del_Date_Shell
--                  and Get_Qty_Plannable_Shell.
--                  Replaced Utility_SYS.Get_User with Fnd_Session_API.Get_Fnd_User.
--  990615  LEPE    Improved performance in Get_Qty_Plannable_Fast.
--  990518  ROOD    Added Get_Qty_Plannable_Fast.
--  990503  FRDI    General performance improvements and
--                  added MODULE_VIEW21_EXT to SUPP_SCHED_PLAN_DEMAND_EXT
--  990325  ANHO    Added Inventory_Part_Planning_API.Get_Scrapping_Adjusted_Qty in
--                  Generate_Next_Level_Demands.
--  990315  FRDI    Added the procedure Add_Order_To_Attr__ and the arrib_ parameter to
--                  Get_Order_Supply_Demands whith is used to print all requisitions/orders created.
--  990215  PaLj    Bug 7150. Changed Transaction_SYS.Logical_Unit_Is_Installed('PurchaseRequisLine')
--                  to Transaction_SYS.Logical_Unit_Is_Installed('PurchaseReqUtil')
--                  in Generate_Next_Level_Demands
--  990208  JAKH    Removed period_no in calls to Shop_Order_Prop_Int_API.Generate_proposal
--  990202  ROOD    Added views HPM_PART_SUPPLY_DEMAND_MS and HPM_PART_SUPPLY_DEMAND_EXT.
--  990126  JICE    Added a view CUSTOMER_ORDER_LINE_MS2 to ORDER_SUPPLY_DEMAND
--                  for configured customer order lines.
--  990112  FRDI    Changed Sysdate to site dependent 'sysdate' - Site_API.Get_Site_Date(contract)
--  981228  JOKE    Added sub views project_delivery_demand and project_delivery_demand_ext.
--  981127  FRDI    Full precision for UOM, round result of scrap calculation
--                  up to the next adjacent number with 12 decimals.
--  980930  JOHW    Removed the last parameter in call Inventory_Part_Location_API.Make_Onhand_Analysis.
--  980823  GOPE    Added sub view SPARE_PART_FORECAST_EXT
--  980423  GOPE    Added sub view WO_ORDER_REPAIR_DEMAND to ORDER_SUPPLY_DEMAND
--  980317  JOHNI   Removed exception in procedure Get_Order_Supply_Demands.
--                  This is taken care of in order point calculation.
--  980306  GOPE    Added wo repair sub views to the the views
--  980306  GOPE    Changed the comments for order_sypply_demand_type to string(20)
--  980227  SHVE    Added requisition_no as a parameter to procedure Get_Order_Supply_Demands
--  980130  GOPE    Added views for Wo repair
--  980122  JOHO    Restructuring of shop order.
--  980121  GOPE    Added views for repetitive
--  980112  FRDI    Clean up conection to Purchase requisition, exeption.
--  980112  FRDI    Replace UNION whith UNION ALL to inc. preformance
--                  Clean up conection to Purchase requisition
--  971201  GOPE    Upgrade 10 fnd 2.0
--  971104  RaKu    Added(union) view PURCHASE_REQUIS_LINE_SIM in view ORDER_SUPPLY_DEMAND_SIM.
--  971003  LEPE    Removed check against inventory_part_planning.order_requisition in
--                  procedure Generate_Next_Level_Demands.
--  970930  JoAn    Set line_no and release_no to NULL before call to
--                  Purchase_Requis_Line_API.New_Requis_Line in
--                  Generate_Next_Level_Demands.
--  970911  ANTA    Added scrapping algorithm to Generate_Next_Level_Demands.
--  970908  NABE    Changed references from UnitOfMeasure to IsoUnit LU.
--  970718  ASBE    BUG 97-0077 Order date not correct on printout. Added
--                  parameter in proc. Get_Order_Supply_Demand.
--  970710  JOMU    Added QTY_SHORT column to order_supply_demand and
--                  order_supply_demand_ext views.  Corrected spelling of
--                  LEVEL_1_FORCAST_EXT to FORECAST.  Dummy view never replaced
--                  by actual MS view.
--  970613  GOPE    Added DOP view to order_supply_demand_ext
--  97-606  Neno    Fixed bugg 1400 (next level demand)
--  970520  FRMA    Added Purchase_Requis_Line to Order_Supply_Demand.
--  970506  NAVE    Added function Get_Net_Qty_To_Date and procedure Generate_Next_Level_Demands
--  970423  FRMA    Removed Purchase_Requis_Line from Order_Supply_Demand.
--  970421  FRMA    Added parameter lu_shp_exist for Get_Order_Supply_Demands.
--                  Renamed parameter purchase_leadtime to leadtime for
--                  Get_Order_Supply_Demands.
--  970318  GOPE    Added _SIM, _MS, _EXT
--  970127  MAOR    Added field description in views MODULE_VIEW%.
--  970114  RaKu    Replaced all function calls for description in VIEW_CUSTORD.
--  970113  LEPE    Changed function Get_Qty_Plannable to be a procedure.
--  970107  FRMA    Changed exception in Get_Order_Supply_Demands.
--  961223  PEKR    Bug 96-0027 Add dummy views PURCHASE_REQUIS_LINE_SUPPLY[_OE]
--  961211  HP      Added parameter went_ok to Get_Order_Supply_Demands.
--  961209  PEKR    ROSE and Workbench adaptation.
--  961125  HP      Added authorize_code as a parameter to procedure
--                  Get_Order_Supply_Demand and passed them on to
--                  Qty_To_Order.
--  961119  MAOR    Changed order of arguments in call to
--                  Inventory_Part_API.Qty_To_Order.
--  961015  SHVE    Added user as a parameter to procedure Get_Order_Supply_Demands.
--  961009  GOPE    Correction in check_if_order when disp_qty_onhand_ < order_point_qty_
--                  set order_ := TRUE
--  960923  AnAr    Added Qty_ordered_ to procedure Get_Order_Supply_Demands.
--  960913  RaKu    Added procedure Get_Qty_Plannable.
--  960911  HARH    Added procedures Check_If_Order, Get_Order_Supply_Demands
--  960826  JOLA    Added function Get_Available_Balance_Start.
--                  Added public cursor get_available_balance.
--                  Removed dummy procedure Init.
--  960819  JOLA    Added view CustordSupplyDemand.
--  960731  JOHNI   Moved the creation of the dummy views to ordsupde.cre.
--  960617  JOHNI   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE Avail_Balance_Qty_Tab IS TABLE OF NUMBER
   INDEX BY BINARY_INTEGER;
TYPE Avail_Balance_Date_Tab IS TABLE OF DATE
   INDEX BY BINARY_INTEGER;
TYPE Part_Supply_Qty_Record IS RECORD (
   source_category_db   VARCHAR2(10),
   vendor_no            SUPPLIER_INFO_PUBLIC.supplier_id%TYPE,
   supplying_site       VARCHAR2(10),
   supply_qty           NUMBER );
TYPE Part_Supply_Qty_Collection IS TABLE OF Part_Supply_Qty_Record  INDEX BY BINARY_INTEGER;
TYPE Project_Date_Supply_Demand_Rec IS RECORD (
   project_id     VARCHAR2(10),
   date_required  DATE,
   qty_supply     NUMBER,
   qty_demand     NUMBER );
TYPE Proj_Date_Supply_Demand_Table IS TABLE OF Project_Date_Supply_Demand_Rec INDEX BY BINARY_INTEGER;
TYPE Supply_Demand_Date_Rec IS RECORD (
   date_required DATE,
   qty_supply    NUMBER,
   qty_demand    NUMBER );
TYPE Supply_Demand_Date_Tab IS TABLE OF Supply_Demand_Date_Rec INDEX BY PLS_INTEGER;

TYPE Order_Supply_Demand_Ms_Rec IS RECORD (
      order_no                   VARCHAR2(40),
      line_no                    VARCHAR2(40),
      rel_no                     VARCHAR2(40), 
      line_item_no               NUMBER,
      date_required              DATE,
      qty_demand                 NUMBER,   
      qty_supply                 NUMBER,   
      status_code                VARCHAR2(4000),
      order_supply_demand_type   VARCHAR2(4000));
TYPE Order_Supply_Demand_Ms_Tab IS TABLE OF Order_Supply_Demand_Ms_Rec INDEX BY PLS_INTEGER;
TYPE Order_Supply_Demand_Ext_Rec IS RECORD (
      order_no                   VARCHAR2(40),
      line_no                    VARCHAR2(4000),
      rel_no                     VARCHAR2(40), 
      line_item_no               NUMBER,
      date_required              DATE,
      qty_demand                 NUMBER, 
      qty_reserved               NUMBER,  
      qty_supply                 NUMBER,   
      qty_pegged                 NUMBER,
      project_id                 VARCHAR2(10),
      activity_seq               NUMBER,
      order_supply_demand_type   VARCHAR2(4000),
      status_code                VARCHAR2(4000),
      status_desc                VARCHAR2(4000),
      info                       VARCHAR2(4000));
TYPE Order_Supply_Demand_Ext_Tab IS TABLE OF Order_Supply_Demand_Ext_Rec INDEX BY PLS_INTEGER;
TYPE Custord_Supply_Demand_Rec is RECORD (
      order_no                   VARCHAR2(40),
      line_no                    VARCHAR2(20),
      rel_no                     VARCHAR2(40), 
      order_supply_demand_type   VARCHAR2(4000),
      qty_supply                 NUMBER,   
      qty_pegged                 NUMBER,
      date_required              DATE);
TYPE Custord_Supply_Demand_Tab IS TABLE OF Custord_Supply_Demand_Rec INDEX BY PLS_INTEGER;

TYPE Supply_Demand_Per_Type_Rec IS RECORD (
      order_supply_demand_type   VARCHAR2(4000),
      date_required              DATE,
      qty_supply                 NUMBER,
      qty_demand                 NUMBER,
      qty_reserved               NUMBER  );


TYPE Supply_Demand_Per_Type_Tab IS TABLE OF Supply_Demand_Per_Type_Rec INDEX BY PLS_INTEGER;

TYPE Demand_Date_Qty_Rec IS RECORD (
      contract      VARCHAR2(5),
      part_no       VARCHAR2(25),
      date_required DATE,
      qty_demand    NUMBER );
TYPE Demand_Date_Qty_Tab IS TABLE OF Demand_Date_Qty_Rec INDEX BY PLS_INTEGER;

TYPE Remaining_Expired_Rec IS RECORD (
      expiration_date        DATE,
      activity_seq           NUMBER,
      lot_batch_no           VARCHAR2(20),
      qty_expired            NUMBER,   -- this will be used as FYI by the caller
      remaining_qty_expired  NUMBER);  -- this is the demand qty
TYPE Remaining_Expired_Tab IS TABLE OF Remaining_Expired_Rec INDEX BY PLS_INTEGER;

TYPE Planning_Rec IS RECORD (
   projected_qty             NUMBER,
   plannable_qty             NUMBER,
   proj_not_res_qty          NUMBER,
   plan_not_res_qty          NUMBER,
   proj_not_peg_qty          NUMBER,
   plan_not_peg_qty          NUMBER,
   proj_not_res_or_peg_qty   NUMBER,
   plan_not_res_or_peg_qty   NUMBER,
   co_plannable_qty          NUMBER);
   
TYPE Planning_Arr IS TABLE OF Planning_Rec;

TYPE Plannable_Per_Part_Rec IS RECORD (
   projected_qty       NUMBER,
   co_plannable_qty    NUMBER);

TYPE Plannable_Per_Part_Arr IS TABLE OF Plannable_Per_Part_Rec;

-------------------- PRIVATE DECLARATIONS -----------------------------------

TYPE Available_Balance_Rec IS RECORD (
   date_required           DATE,
   balance                 NUMBER,
   balance_not_reserved    NUMBER,
   balance_not_pegged      NUMBER,
   balance_not_res_not_peg NUMBER);
TYPE Available_Balance IS TABLE OF Available_Balance_Rec INDEX BY BINARY_INTEGER;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Check_If_Order___ (
   order_            IN OUT BOOLEAN,
   disp_qty_onhand_  IN OUT NUMBER,
   min_order_date_   IN OUT DATE,
   leadtime_         IN     NUMBER,
   order_point_qty_  IN     NUMBER,
   part_no_          IN     VARCHAR2,
   contract_         IN     VARCHAR2,
   configuration_id_ IN     VARCHAR2,
   from_order_date_  IN     DATE,
   to_order_date_    IN     DATE )
IS
   date_required_             DATE;
   supply_                    NUMBER;
   order_proposal_trigger_db_ VARCHAR2(30);

   CURSOR get_data IS
     SELECT TO_DATE(TO_CHAR(date_required,'YYYYMMDD'),'YYYYMMDD'),
            NVL(SUM(NVL(qty_supply,0)),0)
      FROM  ORDER_SUPPLY_DEMAND
      WHERE contract             = contract_
      AND   part_no              = part_no_
      AND   (configuration_id    = configuration_id_ OR configuration_id_ IS NULL)
      AND   TRUNC(date_required)
            BETWEEN (from_order_date_+1)
            AND      to_order_date_
      GROUP BY TO_CHAR(date_required,'YYYYMMDD')
      ORDER BY TO_CHAR(date_required,'YYYYMMDD');
BEGIN
   Trace_Sys.Message('ORDER_SUPPLY_DEMAND_API.'||'Check_If_Order. Started.'||
      ' Min_Order_Date: '||to_char(min_order_date_,'yyyymmdd')||
      ' Disp_qty_onhand: '||to_char(disp_qty_onhand_));
      
   order_proposal_trigger_db_ := Company_Invent_Info_API.Get_Order_Proposal_Trigger_Db(Site_API.Get_Company(contract_));
   
   -- Check including purchase leadtime
   OPEN get_data;
   LOOP
      date_required_ := NULL;
      supply_        := 0;
      FETCH get_data
      INTO  date_required_, supply_;
      EXIT WHEN get_data%NOTFOUND;

      min_order_date_  := date_required_;
      disp_qty_onhand_ := disp_qty_onhand_ + supply_;

   END LOOP;
   CLOSE get_data;
   
   IF (order_proposal_trigger_db_ = Order_Proposal_Trigger_API.DB_STOCK_BELOW_ORDER_POINT) THEN 
      IF disp_qty_onhand_ < order_point_qty_ THEN
         min_order_date_ := to_order_date_;
         order_          := TRUE;
      END IF;
   ELSIF (order_proposal_trigger_db_ = Order_Proposal_Trigger_API.DB_STOCK_AT_ORDER_POINT) THEN 
      IF disp_qty_onhand_ <= order_point_qty_ THEN
         min_order_date_ := to_order_date_;
         order_          := TRUE;
      END IF;
   END IF;
END Check_If_Order___;


-- Add_Order_To_Attr___
--   This function adds information about the created requisitions/orders
--   to an attribute string. This atribute string is used in
--   INV_PART_ORDER_PNT_REP_RPI to knew wich requsitions where made.
PROCEDURE Add_Order_To_Attr___ (
   attrib_           IN OUT VARCHAR2,
   contract_         IN     VARCHAR2,
   part_no_          IN     VARCHAR2,
   configuration_id_ IN     VARCHAR2,
   requisition_no_   IN     VARCHAR2,
   qty_ordered_      IN     NUMBER,
   date_req_         IN     DATE )
IS
BEGIN
   Client_SYS.Add_To_Attr('CONTRACT', contract_, attrib_);
   Client_SYS.Add_To_Attr('PART_NO', part_no_, attrib_);
   Client_SYS.Add_To_Attr('CONFIGURATION_ID', configuration_id_, attrib_);
   Client_SYS.Add_To_Attr('REQUISITION_NO',requisition_no_, attrib_);
   Client_SYS.Add_To_Attr('QTY_ORDERED', qty_ordered_, attrib_);
   Client_SYS.Add_To_Attr('DATE_REQ', date_req_, attrib_);
END Add_Order_To_Attr___;


-- Get_Qty_Plannable_Fast___
--   This method is used to encapsulate logic in Get_Qty_Plannable_Fast/Get_Qty_Plannable_Fast_Tmp__
--   Returns the plannable quantity for a part on a given date. A faster
--   version of Get_Qty_Plannable. It is used from the client Inventory
--   Part Availability Planning.
FUNCTION Get_Qty_Plannable_Fast___ (
   contract_           IN VARCHAR2,
   part_no_            IN VARCHAR2,
   configuration_id_   IN VARCHAR2,
   include_standard_   IN VARCHAR2,
   include_project_    IN VARCHAR2,
   project_id_         IN VARCHAR2,
   activity_seq_       IN NUMBER,
   dist_calendar_id_   IN VARCHAR2,
   starting_balance_   IN NUMBER,
   available_balance_  IN NUMBER,
   planned_due_date_   IN DATE,
   stop_analysis_date_ IN DATE,
   site_date_          IN DATE,
   source_             IN VARCHAR2,
   exclude_reserved_   IN VARCHAR2,
   exclude_pegged_     IN VARCHAR2,
   snapshot_id_        IN NUMBER DEFAULT NULL ) RETURN NUMBER
IS
   balance_tab_               Available_Balance;
   available_balance_tab_     Order_Supply_Demand_API.Avail_Balance_Qty_Tab;
   available_balancedate_tab_ Order_Supply_Demand_API.Avail_Balance_Date_Tab;
   plannable_balance_tab_     Order_Supply_Demand_API.Avail_Balance_Qty_Tab;
   i_                         BINARY_INTEGER := 0;
   infinity_                  NUMBER         := 999999999.99;
   orig_planned_due_date_     DATE;
   qty_possible_              NUMBER;

   CURSOR Get_Balance_Custord IS
      SELECT TRUNC(date_required) date_required,
             SUM(qty_supply - qty_demand) balance,
             SUM(qty_supply - (qty_demand - qty_reserved)) balance_not_reserved,
             SUM(decode(qty_demand, 0, qty_supply - qty_pegged, -(qty_demand - qty_pegged))) balance_not_pegged,
             SUM(decode(qty_demand, 0, qty_supply - qty_pegged, -(qty_demand - qty_reserved - qty_pegged))) balance_not_res_not_peg
        FROM custord_supply_demand
       WHERE TRUNC(date_required) <= stop_analysis_date_
         AND TRUNC(date_required) > Trunc(site_date_)
         AND part_no = part_no_
         AND contract = contract_
         AND (configuration_id = configuration_id_  OR configuration_id_ IS NULL)
         AND ((include_standard_ = 'TRUE'    AND project_id  = '*')
          OR (include_project_  = 'TRUE'     AND project_id != '*'
         AND (project_id    = project_id_    OR  project_id_   IS NULL)
         AND (activity_seq  = activity_seq_  OR  activity_seq_ IS NULL)))
    GROUP BY TRUNC(date_required)
    ORDER BY TRUNC(date_required);

   CURSOR Get_Balance_Ext IS
      SELECT TRUNC(date_required) date_required,
             SUM(qty_supply - qty_demand) balance,
             SUM(qty_supply - (qty_demand - qty_reserved)) balance_not_reserved,
             SUM(decode(qty_demand, 0, qty_supply - qty_pegged, -(qty_demand - qty_pegged))) balance_not_pegged,
             SUM(decode(qty_demand, 0, qty_supply - qty_pegged, -(qty_demand - qty_reserved - qty_pegged))) balance_not_res_not_peg
        FROM order_supply_demand_ext
       WHERE TRUNC(date_required) <= stop_analysis_date_
         AND TRUNC(date_required) > Trunc(site_date_)
         AND part_no = part_no_
         AND contract = contract_
         AND (configuration_id = configuration_id_  OR configuration_id_ IS NULL)
         AND ((include_standard_ = 'TRUE'    AND project_id  = '*')
          OR (include_project_  = 'TRUE'     AND project_id != '*'
         AND (project_id    = project_id_    OR  project_id_   IS NULL)
         AND (activity_seq  = activity_seq_  OR  activity_seq_ IS NULL)))
    GROUP BY TRUNC(date_required)
    ORDER BY TRUNC(date_required);

   CURSOR Get_Balance IS
      SELECT TRUNC(date_required) date_required,
             SUM(qty_supply - qty_demand) balance,
             SUM(qty_supply - (qty_demand - qty_reserved)) balance_not_reserved,
             SUM(decode(qty_demand, 0, qty_supply - qty_pegged, -(qty_demand - qty_pegged))) balance_not_pegged,
             SUM(decode(qty_demand, 0, qty_supply - qty_pegged, -(qty_demand - qty_reserved - qty_pegged))) balance_not_res_not_peg
        FROM order_supply_demand
       WHERE TRUNC(date_required) <= stop_analysis_date_
         AND TRUNC(date_required) > Trunc(site_date_)
         AND part_no = part_no_
         AND contract = contract_
         AND (configuration_id = configuration_id_  OR configuration_id_ IS NULL)
    GROUP BY TRUNC(date_required)
    ORDER BY TRUNC(date_required);

   CURSOR Get_Balance_Custord_Tmp IS
      SELECT date_required, balance, balance_not_reserved, balance_not_pegged, balance_not_res_not_peg
        FROM sup_dem_plannable_info_tmp
       WHERE snapshot_id = snapshot_id_
         AND supply_demand_source = 'CUSTORD_SUPPLY_DEMAND'
         AND TRUNC(date_required) <= stop_analysis_date_
    ORDER BY TRUNC(date_required);

   CURSOR Get_Balance_Ext_Tmp IS
      SELECT date_required, balance, balance_not_reserved, balance_not_pegged, balance_not_res_not_peg
        FROM sup_dem_plannable_info_tmp
       WHERE snapshot_id = snapshot_id_
         AND supply_demand_source= 'ORDER_SUPPLY_DEMAND_EXT'
         AND TRUNC(date_required) <= stop_analysis_date_
    ORDER BY TRUNC(date_required);

   CURSOR Get_Balance_Tmp IS
      SELECT date_required, balance, balance_not_reserved, balance_not_pegged, balance_not_res_not_peg
        FROM sup_dem_plannable_info_tmp
       WHERE snapshot_id = snapshot_id_
         AND supply_demand_source = 'ORDER_SUPPLY_DEMAND'
         AND TRUNC(date_required) <= stop_analysis_date_
    ORDER BY TRUNC(date_required);
BEGIN
   orig_planned_due_date_ := Trunc(planned_due_date_);

   IF (orig_planned_due_date_ < Trunc(site_date_)) THEN
      RETURN(NULL);
   END IF;
   IF (stop_analysis_date_ IS NULL) THEN
      RETURN(NULL);
   END IF;

   orig_planned_due_date_  := Work_Time_Calendar_API.get_nearest_work_day(dist_calendar_id_, orig_planned_due_date_);

   IF (orig_planned_due_date_ >= stop_analysis_date_ + 1) THEN
      RETURN(infinity_);
   END IF;

   available_balance_tab_(i_)     := available_balance_ + starting_balance_;
   available_balancedate_tab_(i_) := Trunc(site_date_);

   IF snapshot_id_ IS NULL THEN
      IF source_ = 'ORDER_SUPPLY_DEMAND_EXT' THEN
         OPEN Get_Balance_Ext;
         FETCH Get_Balance_Ext BULK COLLECT INTO balance_tab_;
         CLOSE Get_Balance_Ext;
      ELSIF source_ = 'ORDER_SUPPLY_DEMAND' THEN
         OPEN Get_Balance;
         FETCH Get_Balance BULK COLLECT INTO balance_tab_;
         CLOSE Get_Balance;
      ELSE
         OPEN Get_Balance_Custord;
         FETCH Get_Balance_Custord BULK COLLECT INTO balance_tab_;
         CLOSE Get_Balance_Custord;
      END IF;
   ELSE
      IF source_ = 'ORDER_SUPPLY_DEMAND_EXT' THEN
         OPEN Get_Balance_Ext_Tmp;
         FETCH Get_Balance_Ext_Tmp BULK COLLECT INTO balance_tab_;
         CLOSE Get_Balance_Ext_Tmp;
      ELSIF source_ = 'ORDER_SUPPLY_DEMAND' THEN
         OPEN Get_Balance_Tmp;
         FETCH Get_Balance_Tmp BULK COLLECT INTO balance_tab_;
         CLOSE Get_Balance_Tmp;
      ELSE
         OPEN Get_Balance_Custord_Tmp;
         FETCH Get_Balance_Custord_Tmp BULK COLLECT INTO balance_tab_;
         CLOSE Get_Balance_Custord_Tmp;
      END IF;
   END IF;

   IF (balance_tab_.COUNT >0) THEN
      FOR Balance_Rec_ IN balance_tab_.FIRST..balance_tab_.LAST LOOP
         i_ := i_ + 1;
         IF exclude_reserved_ = 'TRUE' AND exclude_pegged_ = 'TRUE' THEN
            available_balance_tab_(i_) := available_balance_tab_(i_-1) + balance_tab_(Balance_Rec_).balance_not_res_not_peg;
         ELSIF exclude_reserved_ = 'TRUE' AND exclude_pegged_ != 'TRUE' THEN
            available_balance_tab_(i_) := available_balance_tab_(i_-1) + balance_tab_(Balance_Rec_).balance_not_reserved;
         ELSIF exclude_reserved_ != 'TRUE' AND exclude_pegged_ = 'TRUE' THEN
            available_balance_tab_(i_) := available_balance_tab_(i_-1) + balance_tab_(Balance_Rec_).balance_not_pegged;
         ELSE
            available_balance_tab_(i_) := available_balance_tab_(i_-1) + balance_tab_(Balance_Rec_).balance;
         END IF;
         available_balancedate_tab_(i_) := balance_tab_(Balance_Rec_).date_required;
      END LOOP;
   END IF;

   i_ := i_ + 1;
   available_balance_tab_(i_)     := infinity_;
   available_balancedate_tab_(i_) := stop_analysis_date_ +1;
   plannable_balance_tab_(i_+1)   := available_balance_tab_(i_);

   WHILE (i_ >= 0) LOOP
      plannable_balance_tab_(i_) := Least(plannable_balance_tab_(i_+1), available_balance_tab_(i_));
      i_ := i_ - 1;
   END LOOP;

   IF (orig_planned_due_date_ < Trunc(site_date_)) THEN
      qty_possible_ := 0;
   ELSE
      i_ := 0;
      LOOP
         EXIT WHEN (orig_planned_due_date_ < available_balancedate_tab_(i_));
         i_ := i_ + 1;
      END LOOP;
      IF (i_ = 0) THEN
         qty_possible_ := plannable_balance_tab_(0);
      ELSE
         qty_possible_ := plannable_balance_tab_(i_ - 1);
      END IF;
   END IF;

   IF (qty_possible_ > 999999999.99) THEN
         qty_possible_ := 999999999.99;
   END IF;
   RETURN(qty_possible_);
END Get_Qty_Plannable_Fast___;


FUNCTION Get_Sum_Pgd_Per_Date_Proj___ (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2, 
   project_id_       IN VARCHAR2,
   date_required_    IN DATE,
   snapshot_id_      IN NUMBER DEFAULT NULL ) RETURN NUMBER
IS
   qty_supply_pegged_   NUMBER := 0;
   qty_demand_pegged_   NUMBER := 0;
   sum_pegged_          NUMBER := 0;

   CURSOR get_sum_supply IS
      SELECT NVL(SUM(NVL(qty_pegged,0)), 0) qty_pegged
      FROM   ORDER_SUPPLY_DEMAND_EXT
      WHERE  contract = contract_
      AND    part_no = part_no_
      AND    (configuration_id = configuration_id_ OR configuration_id_ IS NULL)
      AND    project_id = project_id_
      AND    TRUNC(date_required) = TRUNC(date_required_)
      AND    qty_supply <> 0;

   CURSOR get_sum_demand IS
      SELECT NVL(SUM(NVL(qty_pegged,0)), 0) qty_pegged
      FROM   ORDER_SUPPLY_DEMAND_EXT
      WHERE  contract = contract_
      AND    part_no = part_no_
      AND    (configuration_id = configuration_id_ OR configuration_id_ IS NULL)
      AND    project_id = project_id_
      AND    TRUNC(date_required) = TRUNC(date_required_)
      AND    qty_demand <> 0;

   CURSOR get_sum_supply_tmp IS
      SELECT NVL(SUM(NVL(qty_pegged,0)), 0) qty_pegged
      FROM   supply_demand_info_tmp
      WHERE  snapshot_id = snapshot_id_
      AND    supply_demand_source = 'ORDER_SUPPLY_DEMAND_EXT'
      AND    TRUNC(date_required) = TRUNC(date_required_)
      AND    qty_supply <> 0;

   CURSOR get_sum_demand_tmp IS
      SELECT NVL(SUM(NVL(qty_pegged,0)), 0) qty_pegged
      FROM   supply_demand_info_tmp
      WHERE  snapshot_id = snapshot_id_
      AND    supply_demand_source = 'ORDER_SUPPLY_DEMAND_EXT'
      AND    TRUNC(date_required) = TRUNC(date_required_)
      AND    qty_demand <> 0;
BEGIN
   IF snapshot_id_ IS NULL THEN
      OPEN get_sum_supply;
      FETCH get_sum_supply INTO qty_supply_pegged_;
      CLOSE get_sum_supply;

      OPEN get_sum_demand;
      FETCH get_sum_demand INTO qty_demand_pegged_;
      CLOSE get_sum_demand;
   ELSE
      OPEN get_sum_supply_tmp;
      FETCH get_sum_supply_tmp INTO qty_supply_pegged_;
      CLOSE get_sum_supply_tmp;

      OPEN get_sum_demand_tmp;
      FETCH get_sum_demand_tmp INTO qty_demand_pegged_;
      CLOSE get_sum_demand_tmp;
   END IF;
   
   sum_pegged_ := qty_supply_pegged_ - qty_demand_pegged_;   
   RETURN sum_pegged_;
END Get_Sum_Pgd_Per_Date_Proj___;


FUNCTION Get_Sum_Pegged_Per_Date___ (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2, 
   date_required_    IN DATE,
   snapshot_id_      IN NUMBER DEFAULT NULL ) RETURN NUMBER
IS
   qty_supply_pegged_   NUMBER := 0;
   qty_demand_pegged_   NUMBER := 0;
   sum_pegged_          NUMBER := 0;

   CURSOR get_sum_supply IS
      SELECT NVL(SUM(NVL(qty_pegged,0)), 0) qty_pegged
      FROM   ORDER_SUPPLY_DEMAND
      WHERE  contract = contract_
      AND    part_no = part_no_
      AND    (configuration_id = configuration_id_ OR configuration_id_ IS NULL)
      AND    TRUNC(date_required) = TRUNC(date_required_)
      AND    qty_supply <> 0;

   CURSOR get_sum_demand IS
      SELECT NVL(SUM(NVL(qty_pegged,0)), 0) qty_pegged
      FROM   ORDER_SUPPLY_DEMAND
      WHERE  contract = contract_
      AND    part_no = part_no_
      AND    (configuration_id = configuration_id_ OR configuration_id_ IS NULL)
      AND    TRUNC(date_required) = TRUNC(date_required_)
      AND    qty_demand <> 0;
   
   CURSOR get_sum_supply_tmp IS
      SELECT NVL(SUM(NVL(qty_pegged,0)), 0) qty_pegged
      FROM   supply_demand_info_tmp   
      WHERE  snapshot_id = snapshot_id_
      AND    supply_demand_source= 'ORDER_SUPPLY_DEMAND'
      AND    TRUNC(date_required) = TRUNC(date_required_)
      AND    qty_supply <> 0;
   
   CURSOR get_sum_demand_tmp IS
      SELECT NVL(SUM(NVL(qty_pegged,0)), 0) qty_pegged
      FROM   supply_demand_info_tmp 
      WHERE  snapshot_id = snapshot_id_
      AND    supply_demand_source= 'ORDER_SUPPLY_DEMAND'
      AND    TRUNC(date_required) = TRUNC(date_required_)
      AND    qty_demand <> 0;
BEGIN
   IF snapshot_id_ IS NULL THEN
      OPEN get_sum_supply;
      FETCH get_sum_supply INTO qty_supply_pegged_;
      CLOSE get_sum_supply;

      OPEN get_sum_demand;
      FETCH get_sum_demand INTO qty_demand_pegged_;
      CLOSE get_sum_demand;
   ELSE
      OPEN get_sum_supply_tmp;
      FETCH get_sum_supply_tmp INTO qty_supply_pegged_;
      CLOSE get_sum_supply_tmp;

      OPEN get_sum_demand_tmp;
      FETCH get_sum_demand_tmp INTO qty_demand_pegged_;
      CLOSE get_sum_demand_tmp;
   END IF;

   sum_pegged_ := qty_supply_pegged_ - qty_demand_pegged_;   
   RETURN sum_pegged_;
END Get_Sum_Pegged_Per_Date___;


PROCEDURE Get_Ord_Supply_Demands___ (
   attrib_           IN OUT VARCHAR2,
   requisition_no_   IN OUT VARCHAR2,
   disp_qty_onhand_  IN OUT NUMBER,
   qty_ordered_      IN OUT NUMBER,
   went_ok_          IN OUT VARCHAR2,
   date_req_         IN OUT DATE,
   leadtime_         IN     NUMBER,
   safety_stock_     IN     NUMBER,
   order_point_qty_  IN     NUMBER,
   type_code_        IN     VARCHAR2,
   lu_req_exists_    IN     BOOLEAN,
   lu_shp_exists_    IN     BOOLEAN,
   create_req_       IN     NUMBER,
   part_no_          IN     VARCHAR2,
   contract_         IN     VARCHAR2,
   configuration_id_ IN     VARCHAR2,
   user_             IN     VARCHAR2,
   authorize_code_   IN     VARCHAR2 )
IS
   from_order_date_           DATE;
   to_order_date_             DATE;
   earliest_to_order_date_    DATE;
   date_required_             DATE;
   current_date_              DATE;
   earliest_ultd_supply_date_ DATE;
   supply_demand_             NUMBER;
   order_                     BOOLEAN;
   manuf_cal_id_              VARCHAR2(10);
   distribution_calendar_id_  VARCHAR2(10);
   counter_                   NUMBER;
   revised_ord_date_          DATE;
   local_order_point_qty_     NUMBER;
   predicted_leadtime_demand_ NUMBER;
   actual_leadtime_demand_    NUMBER;

   CURSOR get_supply_demand IS
      SELECT NVL(SUM(NVL(qty_supply,0)-NVL(qty_demand,0)),0)
      FROM  ORDER_SUPPLY_DEMAND
      WHERE contract            = contract_
      AND   part_no             = part_no_
      AND   (configuration_id   = configuration_id_ OR configuration_id_ IS NULL)
      AND TRUNC(date_required) <= current_date_;

   CURSOR get_actual_leadtime_demand IS
     SELECT NVL(SUM(NVL(qty_demand,0)),0)
      FROM  ORDER_SUPPLY_DEMAND
      WHERE contract              = contract_
      AND   part_no               = part_no_
      AND   (configuration_id     = configuration_id_ OR configuration_id_ IS NULL)
      AND   TRUNC(date_required)
            BETWEEN (from_order_date_+1)
            AND      to_order_date_;
BEGIN
   Trace_Sys.Message('ORDER_SUPPLY_DEMAND_API.'||'Get_Order_Supply_Demands.  Started. '||part_no_);

   current_date_      := TRUNC(Site_API.Get_Site_Date(contract_));
   date_req_          := NULL;
   Client_SYS.Clear_Attr(attrib_);
   qty_ordered_       := 0;
   supply_demand_     := 0;
--
-- Start fetch: Check current levels (=check for immediate need)
-- (sum of qty_supply - qty_demand, where date_required < Site_API.Get_Site_Date(contract_))
--
   OPEN get_supply_demand;
   FETCH get_supply_demand INTO supply_demand_;
   IF get_supply_demand%NOTFOUND THEN
      supply_demand_    := 0;
   END IF;
   CLOSE get_supply_demand;
--
   disp_qty_onhand_  := disp_qty_onhand_ + supply_demand_;
   date_required_    := TO_DATE(TO_CHAR(Site_API.Get_Site_Date(contract_),'YYYYMMDD'),'YYYYMMDD');
--
   order_ := FALSE;

   from_order_date_  := TRUNC(date_required_);
   IF (Inventory_Part_API.Get_Type_Code_Db(contract_, part_no_) = 1) THEN  
      manuf_cal_id_ := Site_API.Get_Manuf_Calendar_Id(contract_);
      
      -- If from_order_date_ is not a working day, use the next working day
      IF (Work_Time_Calendar_Api.Is_Working_Day(manuf_cal_id_, from_order_date_) = 1) THEN
         revised_ord_date_ := from_order_date_;
      ELSE
         revised_ord_date_ := Work_Time_Calendar_API.Get_Previous_Work_Day(manuf_cal_id_, from_order_date_);
      END IF;
      counter_       := Work_Time_Calendar_API.Get_Work_Day_Counter(manuf_cal_id_, revised_ord_date_);
     
      counter_       := counter_ + leadtime_; 
      to_order_date_ := Work_Time_Calendar_API.Get_Work_Day(manuf_cal_id_, counter_);   
   ELSE   
      earliest_ultd_supply_date_ := Inventory_Part_API.Get_Earliest_Ultd_Supply_Date(contract_, part_no_);
      to_order_date_             := from_order_date_ + leadtime_;

      IF (earliest_ultd_supply_date_ IS NULL) THEN
         earliest_to_order_date_ := to_order_date_;
      ELSE
         distribution_calendar_id_ := Site_API.Get_Dist_Calendar_Id(contract_);
         earliest_to_order_date_   := Work_Time_Calendar_API.Get_Previous_Work_Day(distribution_calendar_id_,
                                                                                   earliest_ultd_supply_date_);
      END IF;
      to_order_date_ := GREATEST(to_order_date_, earliest_to_order_date_);
   END IF;

   predicted_leadtime_demand_ := order_point_qty_ - safety_stock_;

   OPEN  get_actual_leadtime_demand;
   FETCH get_actual_leadtime_demand INTO actual_leadtime_demand_;
   CLOSE get_actual_leadtime_demand;

   -- If actual demand is greater than predicted demand then add the difference to the Order Point
   local_order_point_qty_ := order_point_qty_ + GREATEST(actual_leadtime_demand_ - predicted_leadtime_demand_,0);

   Trace_Sys.Message('ORDER_SUPPLY_DEMAND_API.'||'Get_Order_Supply_Demands.'||
      ' Current status '||
      ' Disp_qty: '||to_char(disp_qty_onhand_)||
      ' <= Order_Point_Qty: '||to_char(local_order_point_qty_));

   -- Modified the condition to make sure that the values less than or equal to local_order_point_qty_ will consider.
   IF (disp_qty_onhand_ <= local_order_point_qty_) THEN
      Trace_Sys.Message('disp_qty_onhand_ <= local_order_point_qty_');
      Check_If_Order___(order_,
                        disp_qty_onhand_,
                        date_required_,
                        leadtime_,
                        local_order_point_qty_,
                        part_no_,
                        contract_,
                        configuration_id_,
                        from_order_date_,
                        to_order_date_);

      IF order_ THEN
         Trace_Sys.Message('order TRUE');
         Inventory_Part_API.Qty_To_Order (
            requisition_no_,
            qty_ordered_    ,
            disp_qty_onhand_,
            contract_       ,
            part_no_        ,
            date_required_  ,
            type_code_      ,
            lu_req_exists_  ,
            lu_shp_exists_  ,
            create_req_     ,
            authorize_code_ ,
            local_order_point_qty_);
         order_   := FALSE;
         Trace_Sys.Message('order done');
         date_req_ := date_required_;
         Add_order_to_Attr___ (
            attrib_ ,
            contract_,
            part_no_,
            configuration_id_,
            requisition_no_,
            qty_ordered_,
            date_req_);
      END IF;
   ELSE
      went_ok_ := 'N';
   END IF;
END Get_Ord_Supply_Demands___;


PROCEDURE Add_Sup_Dem_Info___ (
   contract_             IN VARCHAR2,
   part_no_              IN VARCHAR2,
   configuration_id_     IN VARCHAR2,
   project_id_           IN VARCHAR2,
   include_standard_     IN VARCHAR2,
   include_project_      IN VARCHAR2,
   snapshot_id_          IN NUMBER,
   supply_demand_source_ IN VARCHAR2)
IS
BEGIN
   IF (supply_demand_source_ = 'ORDER_SUPPLY_DEMAND') THEN
      INSERT INTO supply_demand_info_tmp (order_no, line_no, rel_no, line_item_no, order_supply_demand_type,
                                           part_no, contract, configuration_id, qty_short, qty_supply, qty_demand, qty_reserved,
                                           qty_pegged, condition_code, status_code, date_required, description, snapshot_id, supply_demand_source, rowversion)
         (SELECT order_no, line_no, rel_no, line_item_no, order_supply_demand_type,
                 part_no, contract, configuration_id, qty_short, qty_supply, qty_demand, qty_reserved,
                 qty_pegged, condition_code, status_code, date_required, description, snapshot_id_, 'ORDER_SUPPLY_DEMAND', SYSDATE
            FROM order_supply_demand
           WHERE contract = contract_
             AND part_no = part_no_
             AND (configuration_id = configuration_id_ ));
   ELSIF (supply_demand_source_ = 'ORDER_SUPPLY_DEMAND_EXT') THEN
      INSERT INTO supply_demand_info_tmp (order_no, line_no, rel_no, line_item_no, order_supply_demand_type,
                                               part_no, contract, configuration_id, project_id, qty_short, qty_supply, qty_demand, qty_reserved,
                                               qty_pegged, condition_code, status_code, date_required, activity_seq, info, status_desc, snapshot_id, supply_demand_source, rowversion)
         (SELECT order_no, line_no, rel_no, line_item_no, order_supply_demand_type,
                 part_no, contract, configuration_id, project_id, qty_short, qty_supply, qty_demand, qty_reserved,
                 qty_pegged, condition_code, status_code, date_required, activity_seq, info, status_desc, snapshot_id_, 'ORDER_SUPPLY_DEMAND_EXT', SYSDATE
            FROM order_supply_demand_ext
           WHERE contract = contract_
             AND part_no = part_no_
             AND (configuration_id = configuration_id_)
             AND ((include_standard_ = 'TRUE' AND project_id  = '*') OR  
                  (include_project_  = 'TRUE' AND project_id != '*' AND (project_id = project_id_ OR project_id_ IS NULL ))));

   ELSIF (supply_demand_source_ = 'CUSTORD_SUPPLY_DEMAND') THEN
      INSERT INTO supply_demand_info_tmp (order_no, line_no, rel_no, line_item_no, order_supply_demand_type,
                                          part_no, contract, configuration_id, project_id, qty_supply, qty_demand, qty_reserved,
                                          qty_pegged, condition_code, status_code, date_required, activity_seq, sort_order, description, snapshot_id, supply_demand_source, rowversion)
      (SELECT order_no, line_no, rel_no, line_item_no, order_supply_demand_type,
              part_no, contract, configuration_id, project_id, qty_supply, qty_demand, qty_reserved,
              qty_pegged, condition_code, status_code, date_required, activity_seq, sort_order, description, snapshot_id_, 'CUSTORD_SUPPLY_DEMAND', SYSDATE
         FROM custord_supply_demand
        WHERE contract = contract_
          AND part_no = part_no_
          AND (configuration_id = configuration_id_ )
          AND ((include_standard_ = 'TRUE' AND project_id  = '*') OR 
               (include_project_   = 'TRUE' AND project_id != '*' AND (project_id    = project_id_ OR project_id_ IS NULL ))));
   END IF;
END Add_Sup_Dem_Info___;


PROCEDURE Add_Sup_Dem_Plan_Info___ (
   balance_tab_          IN Available_Balance,
   snapshot_id_          IN NUMBER,
   supply_demand_source_ IN VARCHAR2 )
IS
BEGIN
   IF balance_tab_.COUNT > 0 THEN
      FORALL i_ IN balance_tab_.FIRST..balance_tab_.LAST
         INSERT INTO sup_dem_plannable_info_tmp (
            date_required, 
            balance, 
            balance_not_reserved, 
            balance_not_pegged, 
            balance_not_res_not_peg, 
            snapshot_id,
            supply_demand_source,
            rowversion)
         VALUES (
            balance_tab_(i_).date_required, 
            balance_tab_(i_).balance, 
            balance_tab_(i_).balance_not_reserved, 
            balance_tab_(i_).balance_not_pegged, 
            balance_tab_(i_).balance_not_res_not_peg, 
            snapshot_id_,
            supply_demand_source_,
            SYSDATE);
   END IF;
END Add_Sup_Dem_Plan_Info___;


PROCEDURE Clear_Old_Snapshots___
IS
   CURSOR get_old_snapshot_id IS
      SELECT snapshot_id 
        FROM supply_demand_info_tmp
       WHERE TRUNC(rowversion) < TRUNC(SYSDATE) - 1;
   
   CURSOR get_old_plan_snapshot_id IS
      SELECT snapshot_id 
        FROM sup_dem_plannable_info_tmp
       WHERE TRUNC(rowversion) < TRUNC(SYSDATE) - 1;
BEGIN
   FOR rec_ IN get_old_snapshot_id LOOP
      Clear_Snapshot___(rec_.snapshot_id);
   END LOOP;
   
   FOR rec_ IN get_old_plan_snapshot_id LOOP
      Clear_Snapshot___(rec_.snapshot_id);
   END LOOP;
END Clear_Old_Snapshots___;


PROCEDURE Clear_Snapshot___ (
   snapshot_id_          IN NUMBER )
IS
BEGIN
   DELETE FROM supply_demand_info_tmp
         WHERE snapshot_id = snapshot_id_;

   DELETE FROM sup_dem_plannable_info_tmp
         WHERE snapshot_id = snapshot_id_;
END Clear_Snapshot___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@UncheckedAccess
FUNCTION Get_Sum_Pegged_Per_Date__ (
   date_required_    IN DATE,
   snapshot_id_      IN NUMBER ) RETURN NUMBER
IS
   qty_supply_pegged_   NUMBER := 0;
   qty_demand_pegged_   NUMBER := 0;
   sum_pegged_          NUMBER := 0;

   CURSOR get_sum_supply IS
      SELECT NVL(SUM(NVL(qty_pegged,0)), 0) qty_pegged
        FROM supply_demand_info_tmp
       WHERE TRUNC(date_required) = TRUNC(date_required_)
         AND qty_supply <> 0
         AND snapshot_id = snapshot_id_
         AND supply_demand_source = 'ORDER_SUPPLY_DEMAND';

   CURSOR get_sum_demand IS
      SELECT NVL(SUM(NVL(qty_pegged,0)), 0) qty_pegged
        FROM supply_demand_info_tmp
       WHERE TRUNC(date_required) = TRUNC(date_required_)
         AND qty_demand <> 0
         AND snapshot_id = snapshot_id_
         AND supply_demand_source = 'ORDER_SUPPLY_DEMAND';
BEGIN
   OPEN get_sum_supply;
   FETCH get_sum_supply INTO qty_supply_pegged_;
   CLOSE get_sum_supply;

   OPEN get_sum_demand;
   FETCH get_sum_demand INTO qty_demand_pegged_;
   CLOSE get_sum_demand;

   sum_pegged_ := qty_supply_pegged_ - qty_demand_pegged_;
   RETURN sum_pegged_;
END Get_Sum_Pegged_Per_Date__;


@UncheckedAccess
FUNCTION Get_Sum_Pegged_Per_Date__ (
   snapshot_id_   IN NUMBER,
   date_required_ IN DATE ) RETURN NUMBER
IS
BEGIN                 
   RETURN Get_Sum_Pegged_Per_Date___ (NULL, NULL, NULL, date_required_, snapshot_id_);
END Get_Sum_Pegged_Per_Date__;


@UncheckedAccess
FUNCTION Get_Sum_Pegged_Per_Date__ (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2, 
   date_required_    IN DATE     ) RETURN NUMBER
IS
BEGIN
   RETURN Get_Sum_Pegged_Per_Date___ (contract_, part_no_, configuration_id_, date_required_);
END Get_Sum_Pegged_Per_Date__;


@UncheckedAccess
FUNCTION Get_Sum_Pegged_Per_Date_Proj__ (
   date_required_    IN DATE,
   snapshot_id_      IN NUMBER ) RETURN NUMBER
IS 
   qty_supply_pegged_   NUMBER := 0;
   qty_demand_pegged_   NUMBER := 0;
   sum_pegged_          NUMBER := 0;

   CURSOR get_sum_supply IS
      SELECT NVL(SUM(NVL(qty_pegged,0)), 0) qty_pegged
        FROM supply_demand_info_tmp
       WHERE TRUNC(date_required) = TRUNC(date_required_)
         AND qty_supply <> 0
         AND snapshot_id = snapshot_id_
         AND supply_demand_source = 'ORDER_SUPPLY_DEMAND_EXT';
   
   CURSOR get_sum_demand IS
      SELECT NVL(SUM(NVL(qty_pegged,0)), 0) qty_pegged
        FROM supply_demand_info_tmp
       WHERE TRUNC(date_required) = TRUNC(date_required_)
         AND qty_demand <> 0
         AND snapshot_id = snapshot_id_
         AND supply_demand_source = 'ORDER_SUPPLY_DEMAND_EXT';
BEGIN
   OPEN get_sum_supply;
   FETCH get_sum_supply INTO qty_supply_pegged_;
   CLOSE get_sum_supply;

   OPEN get_sum_demand;
   FETCH get_sum_demand INTO qty_demand_pegged_;
   CLOSE get_sum_demand;

   sum_pegged_ := qty_supply_pegged_ - qty_demand_pegged_;
   RETURN sum_pegged_;
END Get_Sum_Pegged_Per_Date_Proj__;



@UncheckedAccess
FUNCTION Get_Sum_Pegged_Per_Date_Proj__ (
   snapshot_id_   IN NUMBER,
   date_required_ IN DATE ) RETURN NUMBER
IS
BEGIN
   RETURN Get_Sum_Pgd_Per_Date_Proj___ (NULL, NULL, NULL, NULL, date_required_, snapshot_id_);
END Get_Sum_Pegged_Per_Date_Proj__;


@UncheckedAccess
FUNCTION Get_Sum_Pegged_Per_Date_Proj__ (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2, 
   project_id_       IN VARCHAR2,
   date_required_    IN DATE     ) RETURN NUMBER
IS
BEGIN
   RETURN Get_Sum_Pgd_Per_Date_Proj___ (contract_, part_no_, configuration_id_, project_id_, date_required_);
END Get_Sum_Pegged_Per_Date_Proj__;



PROCEDURE Populate_Temporary_Tables__ (
   snapshot_id_        IN OUT NUMBER,
   contract_           IN     VARCHAR2,
   part_no_            IN     VARCHAR2,
   configuration_id_   IN     VARCHAR2,
   project_id_         IN     VARCHAR2,
   include_standard_   IN     VARCHAR2,
   include_project_    IN     VARCHAR2,
   stop_analysis_date_ IN     DATE,
   site_date_          IN     DATE,
   source_             IN     VARCHAR2 DEFAULT NULL )
IS
   populate_all_ BOOLEAN := FALSE;
   balance_tab_  Available_Balance;

   CURSOR Get_Balance_Custord_Tmp IS
      SELECT TRUNC(date_required) date_required,
             SUM(qty_supply - qty_demand) balance,
             SUM(qty_supply - (qty_demand - qty_reserved)) balance_not_reserved,
             SUM(decode(qty_demand, 0, qty_supply - qty_pegged, -(qty_demand - qty_pegged))) balance_not_pegged,
             SUM(decode(qty_demand, 0, qty_supply - qty_pegged, -(qty_demand - qty_reserved - qty_pegged))) balance_not_res_not_peg
        FROM supply_demand_info_tmp
       WHERE snapshot_id = snapshot_id_
         AND supply_demand_source = 'CUSTORD_SUPPLY_DEMAND'
         AND TRUNC(date_required) <= stop_analysis_date_
         AND TRUNC(date_required) > Trunc(site_date_)
    GROUP BY TRUNC(date_required);

   CURSOR Get_Balance_Ext_Tmp IS
      SELECT TRUNC(date_required) date_required,
             SUM(qty_supply - qty_demand) balance,
             SUM(qty_supply - (qty_demand - qty_reserved)) balance_not_reserved,
             SUM(decode(qty_demand, 0, qty_supply - qty_pegged, -(qty_demand - qty_pegged))) balance_not_pegged,
             SUM(decode(qty_demand, 0, qty_supply - qty_pegged, -(qty_demand - qty_reserved - qty_pegged))) balance_not_res_not_peg
        FROM supply_demand_info_tmp
       WHERE snapshot_id = snapshot_id_
         AND supply_demand_source = 'ORDER_SUPPLY_DEMAND_EXT'
         AND TRUNC(date_required) <= stop_analysis_date_
         AND TRUNC(date_required) > Trunc(site_date_)
    GROUP BY TRUNC(date_required);

   CURSOR Get_Balance_Tmp IS
      SELECT TRUNC(date_required) date_required,
             SUM(qty_supply - qty_demand) balance,
             SUM(qty_supply - (qty_demand - qty_reserved)) balance_not_reserved,
             SUM(decode(qty_demand, 0, qty_supply - qty_pegged, -(qty_demand - qty_pegged))) balance_not_pegged,
             SUM(decode(qty_demand, 0, qty_supply - qty_pegged, -(qty_demand - qty_reserved - qty_pegged))) balance_not_res_not_peg
        FROM supply_demand_info_tmp
       WHERE snapshot_id = snapshot_id_
         AND supply_demand_source = 'ORDER_SUPPLY_DEMAND'
         AND TRUNC(date_required) <= stop_analysis_date_
         AND TRUNC(date_required) > Trunc(site_date_)
    GROUP BY TRUNC(date_required);
BEGIN
   IF snapshot_id_ IS NULL THEN
      -- Generate new snapshot_id when populate the window first time
      SELECT supply_demand_snapshot_id_seq.NEXTVAL
        INTO snapshot_id_
        FROM dual;
   ELSE
      -- When repopulate, delete previous snapshot info and reuse the same snapshot_id
      Clear_Snapshot__ (snapshot_id_);
   END IF;

   -- Insert data to temporary tables
   IF (source_ IS NULL) THEN
      populate_all_ := TRUE;
   END IF;

   IF (populate_all_ OR source_ = 'ORDER_SUPPLY_DEMAND') THEN
      Add_Sup_Dem_Info___(contract_,
                          part_no_,
                          configuration_id_,
                          project_id_,
                          include_standard_,
                          include_project_,
                          snapshot_id_,
                          'ORDER_SUPPLY_DEMAND');
      
      balance_tab_.DELETE; 

      OPEN Get_Balance_Tmp;
      FETCH Get_Balance_Tmp BULK COLLECT INTO balance_tab_;
      CLOSE Get_Balance_Tmp;

      Add_Sup_Dem_Plan_Info___(balance_tab_,
                               snapshot_id_,
                               'ORDER_SUPPLY_DEMAND'); 
   END IF;

   IF (populate_all_ OR source_ = 'ORDER_SUPPLY_DEMAND_EXT') THEN
      Add_Sup_Dem_Info___(contract_,
                          part_no_,
                          configuration_id_,
                          project_id_,
                          include_standard_,
                          include_project_,
                          snapshot_id_,
                          'ORDER_SUPPLY_DEMAND_EXT');
      
      balance_tab_.DELETE;

      OPEN Get_Balance_Ext_Tmp;
      FETCH Get_Balance_Ext_Tmp BULK COLLECT INTO balance_tab_;
      CLOSE Get_Balance_Ext_Tmp;

      Add_Sup_Dem_Plan_Info___(balance_tab_,
                               snapshot_id_,
                               'ORDER_SUPPLY_DEMAND_EXT'); 
   END IF;

   IF (populate_all_ OR source_ = 'CUSTORD_SUPPLY_DEMAND') THEN
      Add_Sup_Dem_Info___(contract_,
                          part_no_,
                          configuration_id_,
                          project_id_,
                          include_standard_,
                          include_project_,
                          snapshot_id_,
                          'CUSTORD_SUPPLY_DEMAND');
      balance_tab_.DELETE;

      OPEN Get_Balance_Custord_Tmp;
      FETCH Get_Balance_Custord_Tmp BULK COLLECT INTO balance_tab_;
      CLOSE Get_Balance_Custord_Tmp;

      Add_Sup_Dem_Plan_Info___(balance_tab_,
                               snapshot_id_,
                               'CUSTORD_SUPPLY_DEMAND'); 
   END IF;
END Populate_Temporary_Tables__;


PROCEDURE Clear_Snapshot__ (
   snapshot_id_ IN NUMBER )
IS
BEGIN
   Clear_Snapshot___(snapshot_id_);
   Clear_Old_Snapshots___;
END Clear_Snapshot__;

@UncheckedAccess
PROCEDURE Get_Available_Balance_Tmp__ (
   balance_              OUT NUMBER,
   balance_not_reserved_ OUT NUMBER,
   balance_not_pegged_   OUT NUMBER,
   balance_not_res_peg_  OUT NUMBER,
   source_               IN  VARCHAR2,
   site_date_            IN  DATE,
   snapshot_id_          IN  NUMBER )
IS
   CURSOR getrec IS
      SELECT
            NVL(SUM(qty_supply - qty_demand), 0),
            NVL(SUM(qty_supply - (qty_demand - qty_reserved)), 0),
            NVL(SUM(decode(qty_demand, 0, qty_supply - qty_pegged, -(qty_demand - qty_pegged))), 0),
            NVL(SUM(decode(qty_demand, 0, qty_supply - qty_pegged, -(qty_demand - qty_reserved - qty_pegged))), 0)
       FROM supply_demand_info_tmp
      WHERE snapshot_id = snapshot_id_
        AND supply_demand_source = 'ORDER_SUPPLY_DEMAND'
        AND TRUNC(date_required) <= TRUNC(site_date_);

   CURSOR getrec_ext IS
      SELECT
            NVL(SUM(qty_supply - qty_demand), 0),
            NVL(SUM(qty_supply - (qty_demand - qty_reserved)), 0),
            NVL(SUM(decode(qty_demand, 0, qty_supply - qty_pegged, -(qty_demand - qty_pegged))), 0),
            NVL(SUM(decode(qty_demand, 0, qty_supply - qty_pegged, -(qty_demand - qty_reserved - qty_pegged))), 0)
       FROM supply_demand_info_tmp
      WHERE snapshot_id = snapshot_id_
        AND supply_demand_source = 'ORDER_SUPPLY_DEMAND_EXT'
        AND TRUNC(date_required) <= TRUNC(site_date_);

   CURSOR getrec_custord IS
      SELECT
            NVL(SUM(qty_supply - qty_demand), 0),
            NVL(SUM(qty_supply - (qty_demand - qty_reserved)), 0),
            NVL(SUM(decode(qty_demand, 0, qty_supply - qty_pegged, -(qty_demand - qty_pegged))), 0),
            NVL(SUM(decode(qty_demand, 0, qty_supply - qty_pegged, -(qty_demand - qty_reserved - qty_pegged))), 0)
       FROM supply_demand_info_tmp
      WHERE snapshot_id = snapshot_id_
        AND supply_demand_source = 'CUSTORD_SUPPLY_DEMAND'
        AND TRUNC(date_required) <= TRUNC(site_date_);
BEGIN
   IF source_ = 'ORDER_SUPPLY_DEMAND_EXT' THEN
      OPEN getrec_ext;
      FETCH getrec_ext INTO balance_, balance_not_reserved_, balance_not_pegged_, balance_not_res_peg_;
      CLOSE getrec_ext;
   ELSIF source_ = 'ORDER_SUPPLY_DEMAND' THEN
      OPEN getrec;
      FETCH getrec INTO balance_, balance_not_reserved_, balance_not_pegged_, balance_not_res_peg_;
      CLOSE getrec;
   ELSE
      OPEN getrec_custord;
      FETCH getrec_custord INTO balance_, balance_not_reserved_, balance_not_pegged_, balance_not_res_peg_;
      CLOSE getrec_custord;
   END IF;
END Get_Available_Balance_Tmp__;


-- Get_Qty_Plannable_Fast_Tmp__
--   This method is used to return plannable quantity for a part
--   based on the order supply demand temporary tables.
--   Returns the plannable quantity for a part on a given date. A faster
--   version of Get_Qty_Plannable. It is used from the client Inventory Part
--   Availability Planning.
@UncheckedAccess
FUNCTION Get_Qty_Plannable_Fast_Tmp__ (
   dist_calendar_id_   IN VARCHAR2,
   starting_balance_   IN NUMBER,
   available_balance_  IN NUMBER,
   picking_leadtime_   IN NUMBER,
   planned_due_date_   IN DATE,
   stop_analysis_date_ IN DATE,
   site_date_          IN DATE,
   source_             IN VARCHAR2,
   exclude_reserved_   IN VARCHAR2,
   exclude_pegged_     IN VARCHAR2,
   snapshot_id_        IN NUMBER ) RETURN NUMBER
IS
BEGIN   
   RETURN Get_Qty_Plannable_Fast___ (NULL, NULL, NULL, NULL, NULL, NULL, NULL,
                                     dist_calendar_id_, starting_balance_, available_balance_,
                                     planned_due_date_, stop_analysis_date_, site_date_, source_,
                                     exclude_reserved_, exclude_pegged_, snapshot_id_);
END Get_Qty_Plannable_Fast_Tmp__;



@UncheckedAccess
FUNCTION Convert_Graph_Label_Format__( 
   attr_          IN VARCHAR2,
   output_format_ IN VARCHAR2,
   date_format_   IN VARCHAR2 ) RETURN VARCHAR2 
IS
   field_separator_     CONSTANT VARCHAR2(1) := Client_SYS.field_separator_;
   input_string_        VARCHAR2(32000);
   result_string_       VARCHAR2(32000);
   date_temp_           VARCHAR2(50);
   pos_                 NUMBER;
BEGIN
   input_string_ := attr_;
   pos_ := instr(input_string_,field_separator_,1);

   WHILE pos_ > 0 LOOP
      date_temp_ := substr(input_string_, 0, pos_-1);

      IF date_temp_ IS NOT NULL THEN
         result_string_ := result_string_||to_char(to_date(date_temp_, date_format_), output_format_)||field_separator_;
      ELSE
         result_string_ := result_string_||field_separator_;
      END IF;

      input_string_ := substr(input_string_, pos_+1, length(input_string_)-pos_);
      pos_ := instr(input_string_, field_separator_, 1);      
   END LOOP;
   
   IF input_string_ IS NOT NULL THEN
      result_string_ := result_string_||to_char(to_date(input_string_, date_format_), output_format_);
   END IF;

   RETURN result_string_;
END Convert_Graph_Label_Format__;

PROCEDURE Clear_Inv_Part_Avail_Sum_Qty__
IS
   CURSOR get_old_snapshot_ids IS
      SELECT snapshot_id 
        FROM INV_PART_AVAIL_SUM_QTY_TMP
       WHERE TRUNC(rowversion) < TRUNC(SYSDATE) - 1;
BEGIN
   FOR rec_ IN get_old_snapshot_ids LOOP
      DELETE FROM INV_PART_AVAIL_SUM_QTY_TMP
         WHERE snapshot_id = rec_.snapshot_id;
   END LOOP;   
END Clear_Inv_Part_Avail_Sum_Qty__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Generate_Availability_Snapshot (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   project_id_       IN VARCHAR2,
   snapshot_id_      IN OUT NUMBER )
IS
   local_snapshot_id_              NUMBER;
   site_date_                      DATE;
   dist_calendar_id_               VARCHAR2(10);
   manuf_calendar_id_              VARCHAR2(10);
   picking_leadtime_               NUMBER;
   tmp_stop_analysis_date_         DATE;
   tmp_stop_analysis_date_exp_     DATE;
   stop_anlysis_date_              DATE;
   local_project_id_               VARCHAR2(10);
   local_configuration_id_         VARCHAR2(50);
   include_project_                VARCHAR2(5) := 'TRUE';
   include_standard_               VARCHAR2(5) := 'TRUE';
   physical_qty_                   NUMBER;
   qty_in_transit_                 NUMBER;
   qty_onhand_                     NUMBER;
   qty_reserved_                   NUMBER;
   local_onhand_qty_               NUMBER;
   local_in_transit_qty_           NUMBER;
   local_usable_qty_               NUMBER;
   local_available_qty_            NUMBER;
   qty_in_transit_exp_and_sup_control_ NUMBER;
   avail_balance_                  NUMBER;
   avail_balance_not_res_          NUMBER;
   avail_balance_not_peg_          NUMBER;
   avail_balance_not_res_peg_      NUMBER;
   avail_balance_proc_             NUMBER;
   avail_balance_not_res_proc_     NUMBER;
   avail_balance_not_peg_proc_     NUMBER;
   avail_balance_not_res_peg_proc_ NUMBER;
   avail_balance_co_               NUMBER;
   avail_balance_not_res_co_       NUMBER;
   dummy_                          NUMBER;
    
BEGIN
   IF (contract_ IS NOT NULL AND part_no_ IS NOT NULL AND configuration_id_ IS NOT NULL AND project_id_ IS NOT NULL) THEN
      -- Security
      User_Allowed_Site_API.Is_Authorized(contract_);
      Inv_Part_Config_Project_API.New(contract_, part_no_, configuration_id_, project_id_);
      local_snapshot_id_ := snapshot_id_;

      Order_Supply_Demand_API.Clear_Inv_Part_Avail_Sum_Qty__;

      DELETE FROM INV_PART_AVAIL_SUM_QTY_TMP
         WHERE snapshot_id = local_snapshot_id_;

      site_date_ := Site_API.Get_Site_Date(contract_);
      dist_calendar_id_:= Site_API.Get_Dist_Calendar_Id(contract_);
      manuf_calendar_id_ := Site_API.Get_Manuf_Calendar_Id(contract_);
      picking_leadtime_ := Site_Invent_Info_API.Get_Picking_Leadtime(contract_);

      tmp_stop_analysis_date_exp_ := Inventory_Part_API.Get_Stop_Analysis_Date(contract_                    => contract_,
                                                                               part_no_                     => part_no_, 
                                                                               site_date_                   => site_date_, 
                                                                               dist_calendar_id_            => dist_calendar_id_, 
                                                                               manuf_calendar_id_           => manuf_calendar_id_, 
                                                                               detect_supplies_not_allowed_ => 'TRUE');
      tmp_stop_analysis_date_ := Inventory_Part_API.Get_Stop_Analysis_Date(contract_                    => contract_,
                                                                           part_no_                     => part_no_, 
                                                                           site_date_                   => site_date_, 
                                                                           dist_calendar_id_            => dist_calendar_id_, 
                                                                           manuf_calendar_id_           => manuf_calendar_id_, 
                                                                           detect_supplies_not_allowed_ => 'FALSE',
                                                                           use_expected_leadtime_       => 'FALSE');                                                                            

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
      stop_anlysis_date_ := GREATEST(tmp_stop_analysis_date_exp_, tmp_stop_analysis_date_);   

      Order_Supply_Demand_API.Populate_Temporary_Tables__(local_snapshot_id_,
                                                          contract_,
                                                          part_no_,
                                                          local_configuration_id_,
                                                          local_project_id_,
                                                          include_standard_,
                                                          include_project_,
                                                          stop_anlysis_date_,
                                                          site_date_);

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

      local_onhand_qty_ := NVL(physical_qty_, 0);
      local_in_transit_qty_ := NVL(qty_in_transit_, 0);
      local_usable_qty_ := NVL(qty_onhand_, 0) + NVL(qty_in_transit_exp_and_sup_control_, 0);
      local_available_qty_ := NVL(qty_onhand_, 0) - NVL(qty_reserved_, 0) + NVL(qty_in_transit_exp_and_sup_control_, 0);                                                    

      Order_Supply_Demand_API.Get_Available_Balance_Tmp__(avail_balance_,
                                                          avail_balance_not_res_,
                                                          avail_balance_not_peg_,
                                                          avail_balance_not_res_peg_,
                                                          'ORDER_SUPPLY_DEMAND_EXT',
                                                          site_date_,
                                                          local_snapshot_id_);
      Order_Supply_Demand_API.Get_Available_Balance_Tmp__(avail_balance_proc_,
                                                          avail_balance_not_res_proc_,
                                                          avail_balance_not_peg_proc_,
                                                          avail_balance_not_res_peg_proc_,
                                                          'ORDER_SUPPLY_DEMAND',
                                                          site_date_,
                                                          local_snapshot_id_);                                                       
      Order_Supply_Demand_API.Get_Available_Balance_Tmp__(avail_balance_co_,
                                                          avail_balance_not_res_co_,
                                                          dummy_,
                                                          dummy_,
                                                          'CUSTORD_SUPPLY_DEMAND',
                                                          site_date_,
                                                          local_snapshot_id_);

      INSERT INTO INV_PART_AVAIL_SUM_QTY_TMP (contract, part_no, configuration_id, project_id, snapshot_id,
                                              onhand_qty, in_transit_qty, usable_qty, available_qty,
                                              avail_balance, avail_balance_not_res, avail_balance_not_peg, avail_balance_not_res_peg,
                                              avail_balance_proc, avail_balance_not_res_proc, avail_balance_not_peg_proc, avail_balance_not_res_peg_proc,
                                              avail_balance_co, avail_balance_not_res_co, dist_calendar_id, manuf_calendar_id,
                                              site_date, picking_leadtime, stop_analysis_date, stop_analysis_date_exp, rowversion)
      VALUES(contract_, part_no_, configuration_id_, project_id_, local_snapshot_id_,
             local_onhand_qty_, local_in_transit_qty_, local_usable_qty_, local_available_qty_,
             avail_balance_, avail_balance_not_res_, avail_balance_not_peg_, avail_balance_not_res_peg_,
             avail_balance_proc_, avail_balance_not_res_proc_, avail_balance_not_peg_proc_, avail_balance_not_res_peg_proc_,
             avail_balance_co_, avail_balance_not_res_co_, dist_calendar_id_, manuf_calendar_id_,
             site_date_, picking_leadtime_, tmp_stop_analysis_date_, tmp_stop_analysis_date_exp_, SYSDATE);
      snapshot_id_ := local_snapshot_id_;
   END IF;
END Generate_Availability_Snapshot;

PROCEDURE Get_Order_Supply_Demands (
   attrib_           IN OUT VARCHAR2,
   requisition_no_   IN OUT VARCHAR2,
   disp_qty_onhand_  IN OUT NUMBER,
   qty_ordered_      IN OUT NUMBER,
   went_ok_          IN OUT VARCHAR2,
   date_req_         IN OUT DATE,
   leadtime_         IN     NUMBER,
   safety_stock_     IN     NUMBER,
   order_point_qty_  IN     NUMBER,
   type_code_        IN     VARCHAR2,
   lu_req_exists_    IN     BOOLEAN,
   lu_shp_exists_    IN     BOOLEAN,
   create_req_       IN     NUMBER,
   part_no_          IN     VARCHAR2,
   contract_         IN     VARCHAR2,
   configuration_id_ IN     VARCHAR2,
   user_             IN     VARCHAR2,
   authorize_code_   IN     VARCHAR2 )
IS
BEGIN
   Get_Ord_Supply_Demands___(attrib_,
                             requisition_no_,
                             disp_qty_onhand_,
                             qty_ordered_,
                             went_ok_,
                             date_req_,
                             leadtime_,
                             safety_stock_,
                             order_point_qty_,
                             type_code_,
                             lu_req_exists_,
                             lu_shp_exists_,
                             create_req_,
                             part_no_,
                             contract_,
                             configuration_id_,
                             user_,
                             authorize_code_);
END Get_Order_Supply_Demands;


-- Get_Available_Balance
--   Returns the available balance for customer order.
--   include_standard_ : values are 'TRUE' or 'FALSE'
--   include_project_  : values are 'TRUE' or 'FALSE'
--   source_           : values are 'CUSTORD_SUPPLY_DEMAND', 'ORDER_SUPPLY_DEMAND_EXT' or 'ORDER_SUPPLY_DEMAND'
--   exclude_reserved_ : values are 'TRUE' or 'FALSE'
--   exclude_pegged_   : values are 'TRUE' or 'FALSE'
@UncheckedAccess
FUNCTION Get_Available_Balance (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   include_standard_ IN VARCHAR2,
   include_project_  IN VARCHAR2,
   project_id_       IN VARCHAR2,
   activity_seq_     IN NUMBER,
   row_id_           IN VARCHAR2,
   source_           IN VARCHAR2,
   exclude_reserved_ IN VARCHAR2,
   exclude_pegged_   IN VARCHAR2) RETURN NUMBER
IS
   balance_                NUMBER;
   balance_not_reserved_   NUMBER;
   balance_not_pegged_     NUMBER;
   balance_not_res_peg_    NUMBER;
   current_date_           DATE;

   CURSOR getrec IS
      SELECT 
         NVL(SUM(qty_supply - qty_demand), 0),
         NVL(SUM(qty_supply - (qty_demand - qty_reserved)), 0),
         NVL(SUM(decode(qty_demand, 0, qty_supply - qty_pegged, -(qty_demand - qty_pegged))), 0),
         NVL(SUM(decode(qty_demand, 0, qty_supply - qty_pegged, -(qty_demand - qty_reserved - qty_pegged))), 0)
      FROM ORDER_SUPPLY_DEMAND
      WHERE TRUNC(date_required) <= current_date_
      AND     contract = contract_
      AND     part_no = part_no_
      AND    (configuration_id  = configuration_id_ OR configuration_id_ IS NULL);

   CURSOR getrec_ext IS
      SELECT 
         NVL(SUM(qty_supply - qty_demand), 0),
         NVL(SUM(qty_supply - (qty_demand - qty_reserved)), 0),
         NVL(SUM(decode(qty_demand, 0, qty_supply - qty_pegged, -(qty_demand - qty_pegged))), 0),
         NVL(SUM(decode(qty_demand, 0, qty_supply - qty_pegged, -(qty_demand - qty_reserved - qty_pegged))), 0)
      FROM ORDER_SUPPLY_DEMAND_EXT
      WHERE TRUNC(date_required) <= current_date_
      AND     contract = contract_
      AND     part_no = part_no_
      AND    (configuration_id  = configuration_id_ OR configuration_id_ IS NULL)      
      AND   ((include_standard_ = 'TRUE'     AND project_id  = '*')
         OR  (include_project_  = 'TRUE'     AND project_id != '*'
         AND (project_id    = project_id_    OR  project_id_   IS NULL)
         AND (activity_seq  = activity_seq_  OR  activity_seq_ IS NULL)));

   CURSOR getrec_custord IS
      SELECT 
         NVL(SUM(qty_supply - qty_demand), 0),
         NVL(SUM(qty_supply - (qty_demand - qty_reserved)), 0),
         NVL(SUM(decode(qty_demand, 0, qty_supply - qty_pegged, -(qty_demand - qty_pegged))), 0),
         NVL(SUM(decode(qty_demand, 0, qty_supply - qty_pegged, -(qty_demand - qty_reserved - qty_pegged))), 0)
      FROM CUSTORD_SUPPLY_DEMAND
      WHERE TRUNC(date_required) <= current_date_
      AND     contract = contract_
      AND     part_no = part_no_
      AND    (configuration_id  = configuration_id_ OR configuration_id_ IS NULL)      
      AND   ((include_standard_ = 'TRUE'     AND project_id  = '*')
         OR  (include_project_  = 'TRUE'     AND project_id != '*'
         AND (project_id    = project_id_    OR  project_id_   IS NULL)
         AND (activity_seq  = activity_seq_  OR  activity_seq_ IS NULL)))         
      AND    row_id != nvl(row_id_,'ROWID');
BEGIN
   current_date_ := TRUNC(Site_API.Get_Site_Date(contract_));
   
   IF source_ = 'ORDER_SUPPLY_DEMAND_EXT' THEN
      OPEN getrec_ext;
      FETCH getrec_ext INTO balance_, balance_not_reserved_, balance_not_pegged_, balance_not_res_peg_;
      IF (getrec_ext%NOTFOUND) THEN
         balance_              := 0;
         balance_not_reserved_ := 0;
         balance_not_pegged_   := 0;
         balance_not_res_peg_  := 0;
      END IF;
      CLOSE getrec_ext;
   ELSIF source_ = 'ORDER_SUPPLY_DEMAND' THEN
      OPEN getrec;
      FETCH getrec INTO balance_, balance_not_reserved_, balance_not_pegged_, balance_not_res_peg_;
      IF (getrec%NOTFOUND) THEN
         balance_              := 0;
         balance_not_reserved_ := 0;
         balance_not_pegged_   := 0;
         balance_not_res_peg_  := 0;
      END IF;
      CLOSE getrec;
   ELSE
      OPEN getrec_custord;
      FETCH getrec_custord INTO balance_, balance_not_reserved_, balance_not_pegged_, balance_not_res_peg_;
      IF (getrec_custord%NOTFOUND) THEN
         balance_              := 0;
         balance_not_reserved_ := 0;
         balance_not_pegged_   := 0;
         balance_not_res_peg_  := 0;
      END IF;
      CLOSE getrec_custord;
   END IF;
   
   IF exclude_reserved_ = 'TRUE' AND exclude_pegged_ = 'TRUE' THEN
      RETURN balance_not_res_peg_;
   ELSIF exclude_reserved_ = 'TRUE' AND exclude_pegged_ != 'TRUE' THEN
      RETURN balance_not_reserved_;
   ELSIF exclude_reserved_ != 'TRUE' AND exclude_pegged_ = 'TRUE' THEN
      RETURN balance_not_pegged_;
   ELSE
      RETURN balance_;
   END IF;
END Get_Available_Balance;


-- Get_Sum_Qty_Supply
--   Returns the sum of the attribute qty_supply for a part.
@UncheckedAccess
FUNCTION Get_Sum_Qty_Supply (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   qty_supply_ NUMBER := 0;

   CURSOR getrec IS
      SELECT nvl(sum(qty_supply),0)
      FROM ORDER_SUPPLY_DEMAND
      WHERE contract = contract_
      AND part_no = part_no_
      AND (configuration_id = configuration_id_ OR configuration_id_ IS NULL);
BEGIN
   OPEN getrec;
   FETCH getrec INTO qty_supply_;
   IF (getrec%NOTFOUND) THEN
      qty_supply_ := 0;
   END IF;
   CLOSE getrec;
   RETURN qty_supply_;
END Get_Sum_Qty_Supply;


-- Get_Sum_Qty_Demand
--   Returns the sum of the attribute qty_demand for a part.
@UncheckedAccess
FUNCTION Get_Sum_Qty_Demand (
   contract_  IN VARCHAR2,
   part_no_   IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   RETURN Get_Sum_Qty_Demand(contract_, part_no_, '*');
END Get_Sum_Qty_Demand;



-- Get_Sum_Qty_Demand
--   Returns the sum of the attribute qty_demand for a part.
@UncheckedAccess
FUNCTION Get_Sum_Qty_Demand (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2 )  RETURN NUMBER
   IS
   qty_demand_ NUMBER := 0;

   CURSOR getrec IS
      SELECT nvl(sum(qty_demand),0)
      FROM ORDER_SUPPLY_DEMAND
      WHERE contract = contract_
      AND   part_no = part_no_
      AND   (configuration_id = configuration_id_ OR configuration_id_ IS NULL);
BEGIN
   OPEN getrec;
   FETCH getrec INTO qty_demand_;
   IF (getrec%NOTFOUND) THEN
      qty_demand_ := 0;
   END IF;
   CLOSE getrec;
   RETURN qty_demand_;
END Get_Sum_Qty_Demand;


-- Get_Qty_Plannable
--   Returns the plannable quantity for a part on a given date.
PROCEDURE Get_Qty_Plannable (
   qty_plannable_ IN OUT NUMBER,
   contract_      IN     VARCHAR2,
   part_no_       IN     VARCHAR2,
   date_required_ IN     DATE )
IS
BEGIN
   Get_Qty_Plannable(qty_plannable_, contract_, part_no_, '*', date_required_);
END Get_Qty_Plannable;


-- Get_Qty_Plannable
--   Returns the plannable quantity for a part on a given date.
PROCEDURE Get_Qty_Plannable (
   qty_plannable_       IN OUT NUMBER,
   contract_            IN     VARCHAR2,
   part_no_             IN     VARCHAR2,
   configuration_id_    IN     VARCHAR2,
   date_required_       IN     DATE )
IS
   rowid_               ROWID   := NULL;
   dummy_date_          DATE    := NULL;
   test_date_           DATE    := date_required_ ;
   result_              VARCHAR2(80);
BEGIN
   trace_sys.field('Date_required', date_required_);
   IF (date_required_ < TRUNC(Site_API.Get_Site_Date(contract_))) THEN
      qty_plannable_ := NULL;
   ELSE
      Inventory_Part_In_Stock_API.Make_Onhand_Analysis(
         result_,
         qty_plannable_,
         dummy_date_,
         dummy_date_,
         test_date_,
         contract_,
         part_no_,
         configuration_id_,
         'TRUE',
         'TRUE',
         NULL,
         NULL,
         rowid_,
         0);

      IF (qty_plannable_ > 999999999.99) THEN
         qty_plannable_ := 999999999.99;
      END IF;
   END IF;
END Get_Qty_Plannable;


-- Get_Qty_Plannable_Fast
--   Returns the plannable quantity for a part on a given date. A faster
--   version of Get_Qty_Plannable. It is used from the client Inventory
--   Part Availability Planning.
--   include_standard_   : values are 'TRUE' or 'FALSE'
--   include_project_    : values are 'TRUE' or 'FALSE'
--   source_             : values are 'CUSTORD_SUPPLY_DEMAND', 'ORDER_SUPPLY_DEMAND_EXT' or 'ORDER_SUPPLY_DEMAND'
--   exclude_reserved_   : values are 'TRUE' or 'FALSE'
--   exclude_pegged_     : values are 'TRUE' or 'FALSE'
@UncheckedAccess
FUNCTION Get_Qty_Plannable_Fast (
   contract_           IN VARCHAR2,
   part_no_            IN VARCHAR2,
   configuration_id_   IN VARCHAR2,
   include_standard_   IN VARCHAR2,
   include_project_    IN VARCHAR2,
   project_id_         IN VARCHAR2,
   activity_seq_       IN NUMBER,
   dist_calendar_id_   IN VARCHAR2,
   starting_balance_   IN NUMBER,
   available_balance_  IN NUMBER,
   picking_leadtime_   IN NUMBER,
   planned_due_date_   IN DATE,
   stop_analysis_date_ IN DATE,
   site_date_          IN DATE,
   source_             IN VARCHAR2,
   exclude_reserved_   IN VARCHAR2,
   exclude_pegged_     IN VARCHAR2) RETURN NUMBER
IS
BEGIN
   RETURN Get_Qty_Plannable_Fast___ (contract_, part_no_, configuration_id_, include_standard_, include_project_,
                                     project_id_, activity_seq_, dist_calendar_id_, starting_balance_, available_balance_,
                                     planned_due_date_, stop_analysis_date_, site_date_, source_,
                                     exclude_reserved_, exclude_pegged_);
END Get_Qty_Plannable_Fast;



-- Get_Qty_Plannable_Shell
--   The shell for the method Get_Qty_Plannable_Fast. Returns the plannable
--   quantity for a part on a given date. Intended for use from Customer Order.
@UncheckedAccess
FUNCTION Get_Qty_Plannable_Shell (
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   planned_due_date_    IN DATE,
   include_floor_stock_ IN VARCHAR2,
   infinite_leadtime_   IN VARCHAR2 DEFAULT 'FALSE'  ) RETURN NUMBER
IS
BEGIN
   RETURN Get_Qty_Plannable_Shell(contract_, part_no_, '*', planned_due_date_, include_floor_stock_);
END Get_Qty_Plannable_Shell;



-- Get_Qty_Plannable_Shell
--   The shell for the method Get_Qty_Plannable_Fast. Returns the plannable
--   quantity for a part on a given date. Intended for use from Customer Order.
@UncheckedAccess
FUNCTION Get_Qty_Plannable_Shell (
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   configuration_id_    IN VARCHAR2,
   planned_due_date_    IN DATE,
   include_floor_stock_ IN VARCHAR2,
   infinite_leadtime_   IN VARCHAR2 DEFAULT 'FALSE'  ) RETURN NUMBER
IS
   dist_calendar_id_    VARCHAR2(10);
   manuf_calendar_id_   VARCHAR2(10);
   starting_balance_    NUMBER;
   available_balance_   NUMBER;
   picking_leadtime_    NUMBER;
   stop_analysis_date_  DATE;
   site_date_           DATE;
   return_value_        NUMBER;
   last_calendar_date_  DATE      := Database_Sys.last_calendar_date_;
BEGIN
   -- Get hold of a lot of information that is needed before calling the main method.
   picking_leadtime_  := Site_Invent_Info_API.Get_Picking_Leadtime(contract_);
   site_date_         := Site_API.Get_Site_Date(contract_);
   dist_calendar_id_  := Site_API.Get_Dist_Calendar_Id(contract_);
   available_balance_ := Get_Available_Balance(contract_         => contract_,
                                               part_no_          => part_no_,
                                               configuration_id_ => configuration_id_,
                                               include_standard_ => 'TRUE',
                                               include_project_  => 'TRUE',
                                               project_id_       => NULL,
                                               activity_seq_     => NULL,
                                               row_id_           => NULL,
                                               source_           => 'CUSTORD_SUPPLY_DEMAND',
                                               exclude_reserved_ => 'TRUE',
                                               exclude_pegged_   => 'FALSE');

   starting_balance_ := Inventory_Part_In_Stock_API.Get_Starting_Balance(contract_            => contract_,
                                                                         part_no_             => part_no_,
                                                                         configuration_id_    => configuration_id_,
                                                                         include_standard_    => 'TRUE',
                                                                         include_project_     => 'TRUE',
                                                                         project_id_          => NULL,
                                                                         activity_seq_        => NULL,
                                                                         include_floor_stock_ => include_floor_stock_);

   manuf_calendar_id_ := Site_API.Get_Manuf_Calendar_Id(contract_);

   IF (infinite_leadtime_) = 'TRUE' THEN
      -- (last_calendar_date_ -1) is used below, unless in the Get_Qty_Plannable_Fast method, when you add up 1 it will end up with an ORA error.
      stop_analysis_date_ := last_calendar_date_ - 1;
   ELSE
      stop_analysis_date_ := Inventory_Part_API.Get_Stop_Analysis_Date(contract_,
                                                                       part_no_,
                                                                       site_date_,
                                                                       dist_calendar_id_,
                                                                       manuf_calendar_id_,
                                                                       'TRUE');
   END IF;
   return_value_ := Get_Qty_Plannable_Fast(contract_           => contract_,
                                           part_no_            => part_no_ ,
                                           configuration_id_   => configuration_id_,
                                           include_standard_   => 'TRUE', 
                                           include_project_    => 'TRUE', 
                                           project_id_         => NULL, 
                                           activity_seq_       => NULL, 
                                           dist_calendar_id_   => dist_calendar_id_,
                                           starting_balance_   => starting_balance_,
                                           available_balance_  => available_balance_,
                                           picking_leadtime_   => picking_leadtime_,
                                           planned_due_date_   => planned_due_date_,
                                           stop_analysis_date_ => stop_analysis_date_,
                                           site_date_          => site_date_,
                                           source_             => 'CUSTORD_SUPPLY_DEMAND',
                                           exclude_reserved_   => 'TRUE',
                                           exclude_pegged_     =>'FALSE');
   RETURN return_value_;
END Get_Qty_Plannable_Shell;



-- Get_Planned_Delivery_Date
--   Returns the date when all the quantity asked for can be delivered.
--   include_standard_   : values are 'TRUE' or 'FALSE'
--   include_project_    : values are 'TRUE' or 'FALSE'
@UncheckedAccess
FUNCTION Get_Planned_Delivery_Date (
   contract_           IN VARCHAR2,
   part_no_            IN VARCHAR2,
   configuration_id_   IN VARCHAR2,
   include_standard_   IN VARCHAR2,
   include_project_    IN VARCHAR2,
   project_id_         IN VARCHAR2,
   activity_seq_       IN NUMBER,
   dist_calendar_id_   IN VARCHAR2,
   starting_balance_   IN NUMBER,
   available_balance_  IN NUMBER,
   picking_leadtime_   IN NUMBER,
   qty_desired_        IN NUMBER,
   stop_analysis_date_ IN DATE,
   site_date_          IN DATE,
   exclude_reserved_   IN VARCHAR2 DEFAULT 'FALSE',   
   exclude_pegged_     IN VARCHAR2 DEFAULT 'FALSE' ) RETURN DATE
IS
   available_balance_tab_     Order_Supply_Demand_API.Avail_Balance_Qty_Tab;
   available_balancedate_tab_ Order_Supply_Demand_API.Avail_Balance_Date_Tab;
   plannable_balance_tab_     Order_Supply_Demand_API.Avail_Balance_Qty_Tab;
   i_                         BINARY_INTEGER := 0;
   infinity_                  NUMBER         := 99999999999.99999;
   limited_qty_desired_       NUMBER;
   planned_due_date_          DATE;
   planned_delivery_date_     DATE;

   CURSOR get_balance IS
      SELECT TRUNC(date_required) date_required,
             SUM(qty_supply - qty_demand) balance,
             SUM(DECODE(qty_supply,0,0,(qty_supply-qty_reserved))                - DECODE(qty_demand,0,0,qty_demand - qty_reserved)) balance_ex_res,
             SUM(DECODE(qty_supply,0,0,(qty_supply-qty_pegged))                  - DECODE(qty_demand,0,0,qty_demand - qty_pegged)) balance_ex_peg,
             SUM(DECODE(qty_supply,0,0,(qty_supply-(qty_reserved + qty_pegged))) - DECODE(qty_demand,0,0,qty_demand - (qty_reserved + qty_pegged))) balance_ex_peg_res
      FROM   CUSTORD_SUPPLY_DEMAND
      WHERE   TRUNC(date_required) <= stop_analysis_date_
      AND     TRUNC(date_required) > Trunc(site_date_)
      AND     part_no = part_no_
      AND     contract = contract_
      AND     configuration_id = configuration_id_
      AND   ((include_standard_ = 'TRUE'     AND project_id  = '*')
         OR  (include_project_  = 'TRUE'     AND project_id != '*'
         AND (project_id    = project_id_    OR  project_id_   IS NULL)
         AND (activity_seq  = activity_seq_  OR  activity_seq_ IS NULL)))     
      GROUP BY TRUNC(date_required)
      ORDER BY TRUNC(date_required);
BEGIN
   IF ((stop_analysis_date_  IS NULL) OR
       (qty_desired_         IS NULL) OR
       (contract_            IS NULL) OR
       (part_no_             IS NULL) OR
       (configuration_id_    IS NULL)) THEN
      RETURN(NULL);
   END IF;

   -- Avoid to large qty_desired
   limited_qty_desired_ := Least(qty_desired_,infinity_);

   -- Initiate first row in the tables with current status
   available_balance_tab_(i_) := available_balance_ + starting_balance_;
   available_balancedate_tab_(i_) := Trunc(site_date_);

   -- Fill the tables with fetched data
   FOR balance_rec IN get_balance LOOP
      i_ := i_ + 1;
      IF exclude_reserved_ = 'TRUE' AND exclude_pegged_ = 'TRUE' THEN
         available_balance_tab_(i_) := available_balance_tab_(i_-1) + balance_rec.balance_ex_peg_res;
      ELSIF exclude_reserved_ = 'TRUE' THEN
         available_balance_tab_(i_) := available_balance_tab_(i_-1) + balance_rec.balance_ex_res;
      ELSIF exclude_pegged_ = 'TRUE' THEN
         available_balance_tab_(i_) := available_balance_tab_(i_-1) + balance_rec.balance_ex_peg;
      ELSE
         available_balance_tab_(i_) := available_balance_tab_(i_-1) + balance_rec.balance;
      END IF;

      available_balancedate_tab_(i_) := balance_rec.date_required;
   END LOOP;

   -- Set last row in the tables to "infinity" status
   i_ := i_ + 1;
   available_balance_tab_(i_)     := infinity_;
   available_balancedate_tab_(i_) := stop_analysis_date_ +1;
   plannable_balance_tab_(i_+1)   := infinity_;

   -- Insert smoothened data (without peaks) into Plannable_Balance_Tab
   WHILE (i_ >= 0) LOOP
      plannable_balance_tab_(i_) := Least(plannable_balance_tab_(i_+1), available_balance_tab_(i_));
      i_ := i_ - 1;
   END LOOP;

   -- Find the first date when the desired demand can be met
   i_ := 0;
   LOOP
      EXIT WHEN (plannable_balance_tab_(i_) >= limited_qty_desired_);
      i_ := i_ + 1;
   END LOOP;

   planned_due_date_      := available_balancedate_tab_(i_);
   -- Add the time for picking
   planned_due_date_      := Work_Time_Calendar_API.Get_Nearest_Work_Day(dist_calendar_id_, planned_due_date_);
   planned_delivery_date_ := Work_Time_Calendar_API.Get_End_Date(dist_calendar_id_,
                                                                 planned_due_date_,
                                                                 picking_leadtime_);
   RETURN(planned_delivery_date_);
END Get_Planned_Delivery_Date;



-- Get_Planned_Del_Date_Shell
--   The shell for the method Get_Planned_Delivery_Date. Returns the date
--   when all the quantity asked for can be delivered. Intended for use
--   from Customer Order.
@UncheckedAccess
FUNCTION Get_Planned_Del_Date_Shell (
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   qty_desired_         IN NUMBER,
   include_floor_stock_ IN VARCHAR2,
   picking_leadtime_    IN NUMBER ) RETURN DATE
IS
BEGIN
   RETURN Get_Planned_Del_Date_Shell(contract_, part_no_, '*', qty_desired_, include_floor_stock_, picking_leadtime_);
END Get_Planned_Del_Date_Shell;



-- Get_Planned_Del_Date_Shell
--   The shell for the method Get_Planned_Delivery_Date. Returns the date
--   when all the quantity asked for can be delivered. Intended for use
--   from Customer Order.
@UncheckedAccess
FUNCTION Get_Planned_Del_Date_Shell (
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   configuration_id_    IN VARCHAR2,
   qty_desired_         IN NUMBER,
   include_floor_stock_ IN VARCHAR2,
   picking_leadtime_    IN NUMBER ) RETURN DATE
IS
   dist_calendar_id_       VARCHAR2(10);
   manuf_calendar_id_      VARCHAR2(10);
   starting_balance_       NUMBER;
   available_balance_      NUMBER;
   local_picking_leadtime_ NUMBER;
   stop_analysis_date_     DATE;
   site_date_              DATE;
   return_value_           DATE;
BEGIN
   -- Get hold of a lot of information that is needed before calling the main method.
   local_picking_leadtime_  := NVL(picking_leadtime_, Site_Invent_Info_API.Get_Picking_Leadtime(contract_));
   site_date_               := Site_API.Get_Site_Date(contract_);
   dist_calendar_id_        := Site_API.Get_Dist_Calendar_Id(contract_);
   available_balance_       := Get_Available_Balance(contract_         => contract_,
                                                     part_no_          => part_no_,
                                                     configuration_id_ => configuration_id_,
                                                     include_standard_ => 'TRUE',
                                                     include_project_  => 'TRUE',
                                                     project_id_       => NULL,
                                                     activity_seq_     => NULL,
                                                     row_id_           => NULL,
                                                     source_           => 'CUSTORD_SUPPLY_DEMAND',
                                                     exclude_reserved_ => 'TRUE',
                                                     exclude_pegged_   => 'FALSE');
   starting_balance_   := Inventory_Part_In_Stock_API.Get_Starting_Balance(contract_, part_no_, configuration_id_, 'TRUE', 'TRUE', NULL, NULL, include_floor_stock_);

   -- stop_analysis_date
   manuf_calendar_id_  := Site_API.Get_Manuf_Calendar_Id(contract_);
   stop_analysis_date_ := Inventory_Part_API.Get_Stop_Analysis_Date(contract_,
                                                                    part_no_,
                                                                    site_date_,
                                                                    dist_calendar_id_,
                                                                    manuf_calendar_id_,
                                                                    'TRUE');
   return_value_ := Get_Planned_Delivery_Date(contract_,
                                              part_no_ ,
                                              configuration_id_,
                                              'TRUE', 
                                              'TRUE', 
                                              NULL, 
                                              NULL, 
                                              dist_calendar_id_,
                                              starting_balance_,
                                              available_balance_,
                                              local_picking_leadtime_,
                                              qty_desired_,
                                              stop_analysis_date_,
                                              site_date_,
                                              exclude_reserved_   => 'TRUE');
   RETURN return_value_;
END Get_Planned_Del_Date_Shell;



-- Get_Avail_Balance_Per_Date
--   Returns the available balance for each day until stop_analysis_date.
--   include_standard_       : values are 'TRUE' or 'FALSE'
--   include_project_        : values are 'TRUE' or 'FALSE'
PROCEDURE Get_Avail_Balance_Per_Date (
   avail_balance_qty_tab_  IN OUT Avail_Balance_Qty_Tab,
   avail_balance_date_tab_ IN OUT Avail_Balance_Date_Tab,
   counter_                IN OUT NUMBER,
   contract_               IN     VARCHAR2,
   part_no_                IN     VARCHAR2,
   configuration_id_       IN     VARCHAR2,
   include_standard_       IN     VARCHAR2,
   include_project_        IN     VARCHAR2,
   project_id_             IN     VARCHAR2,
   activity_seq_           IN     NUMBER,
   row_id_                 IN     VARCHAR2,
   stop_analysis_date_     IN     DATE )
IS
   i_            BINARY_INTEGER;
   current_date_ DATE;

   CURSOR Get_Balance IS
      SELECT TRUNC(date_required) date_required,
             SUM(qty_supply - (qty_demand - qty_reserved)) balance
      FROM   CUSTORD_SUPPLY_DEMAND
      WHERE   TRUNC(date_required) <= stop_analysis_date_
      AND     TRUNC(date_required) > current_date_
      AND     part_no = part_no_
      AND     contract = contract_
      AND    (configuration_id = configuration_id_ OR configuration_id_ IS NULL)
      AND   ((include_standard_ = 'TRUE'     AND project_id  = '*')
         OR  (include_project_  = 'TRUE'     AND project_id != '*'
         AND (project_id    = project_id_    OR  project_id_   IS NULL)
         AND (activity_seq  = activity_seq_  OR  activity_seq_ IS NULL)))     
      AND    row_id != NVL(row_id_,'ROWID')
      GROUP BY TRUNC(date_required)
      ORDER BY TRUNC(date_required);
BEGIN
   current_date_ := TRUNC(Site_API.Get_Site_Date(contract_));
   i_ := counter_;
   FOR Balance_Rec IN Get_Balance LOOP
      i_ := i_ + 1;
      avail_balance_qty_tab_(i_)  := avail_balance_qty_tab_(i_-1) + Balance_Rec.balance;
      avail_balance_date_tab_(i_) := Balance_Rec.date_required;
   END LOOP;
   counter_ := i_;
END Get_Avail_Balance_Per_Date;


@UncheckedAccess
FUNCTION Get_Net_Qty_To_Date (
   contract_      IN VARCHAR2,
   part_no_       IN VARCHAR2,
   date_required_ IN DATE ) RETURN NUMBER
IS
BEGIN
   RETURN Get_Net_Qty_To_Date(contract_, part_no_, '*', date_required_);
END Get_Net_Qty_To_Date;

@UncheckedAccess
FUNCTION Get_Net_Qty_To_Date (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   date_required_    IN DATE ) RETURN NUMBER
IS
   last_calendar_date_  DATE      := Database_Sys.last_calendar_date_;
   
   CURSOR calculate_net IS
      SELECT nvl(sum(nvl(qty_supply, 0) - nvl(qty_demand, 0)), 0)
      FROM ORDER_SUPPLY_DEMAND
      WHERE contract = contract_
      AND   part_no  = part_no_
      AND   (configuration_id = configuration_id_ OR configuration_id_ IS NULL)
      AND   trunc(date_required) <= nvl(date_required_, last_calendar_date_);
   
   net_qty_  NUMBER := 0;   
BEGIN
   OPEN calculate_net;
   FETCH calculate_net INTO net_qty_;
   IF (calculate_net%NOTFOUND) THEN
      net_qty_ := 0;
   END IF;
   CLOSE calculate_net;
   RETURN net_qty_;
END Get_Net_Qty_To_Date;



-- Generate_Next_Level_Demands
--   Used to see if purchase requisition or shop order proposals should be
--   generated for parts on the next level demands (Purchase Requisition or
--   Shop Order Proposals) when an order is created and the part on the
--   order consists of other parts.
PROCEDURE Generate_Next_Level_Demands (
   qty_ordered_   IN NUMBER,
   date_required_ IN DATE,
   contract_      IN VARCHAR2,
   part_no_       IN VARCHAR2 )
IS
BEGIN
   Generate_Next_Level_Demands(qty_ordered_, date_required_, contract_, part_no_, '*');
END Generate_Next_Level_Demands;


-- Generate_Next_Level_Demands
--   Used to see if purchase requisition or shop order proposals should be
--   generated for parts on the next level demands (Purchase Requisition or
--   Shop Order Proposals) when an order is created and the part on the
--   order consists of other parts.
PROCEDURE Generate_Next_Level_Demands (
   qty_ordered_      IN NUMBER,
   date_required_    IN DATE,
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   condition_code_   IN VARCHAR2 DEFAULT NULL )
IS
   to_order_date_             DATE;   
   supply_demand_             NUMBER := 0;
   leadtime_                  NUMBER;
   req_no_                    VARCHAR2(12);
   demand_code_               VARCHAR2(20);
   order_code_                VARCHAR2(3);
   req_code_                  VARCHAR2(3);
   unit_meas_                 VARCHAR2(10);
   release_no_                VARCHAR2(4);
   line_no_                   NUMBER;
   counter_                   NUMBER;
   shop_prop_type_            VARCHAR2(40);
   prop_no_                   VARCHAR2(12);
   qty_onhand_                NUMBER;
   order_qty_                 NUMBER;
   invrec_                    Inventory_Part_API.Public_Rec;

   vendor_no_                 Supplier_Info_Public.supplier_id%TYPE := NULL;
   qty_balance_               VARCHAR2(2)    := NULL;
   qty_on_order_              NUMBER         := NULL;
   curr_code_                 VARCHAR2(3)    := NULL;
   curr_rate_                 NUMBER         := NULL;
   eng_chg_level_             VARCHAR2(6)    := NULL;
   description_               VARCHAR2(4000) := NULL;
   latest_order_date_         DATE           := NULL;
   note_text_                 VARCHAR2(2000) := NULL;
   buy_unit_meas_             VARCHAR2(10)   := NULL;
   supplier_split_            VARCHAR2(20)   := NULL;
   requested_qty_             NUMBER         := NULL;
   split_percentage_          NUMBER         := NULL;
   process_type_              VARCHAR2(3)    := NULL;
   demand_order_no_           VARCHAR2(12)   := NULL;
   demand_release_            VARCHAR2(12)   := NULL;
   demand_sequence_no_        VARCHAR2(4)    := NULL;
   demand_order_code_         VARCHAR2(1)    := NULL;
   demand_order_type_         VARCHAR2(3)    := NULL;
   demand_operation_no_       VARCHAR2(3)    := NULL;
   technical_coordinator_id_  VARCHAR2(20);
   part_supply_qty_coll_      Part_Supply_Qty_Collection;
   planned_due_date_          DATE;
   plannable_qty_on_hand_     NUMBER;
   last_calendar_date_        DATE      := Database_Sys.last_calendar_date_;
   safety_lead_time_          NUMBER;
   local_date_required_       DATE;
   dist_calendar_id_          VARCHAR2(10);
   manuf_calendar_id_         VARCHAR2(10);

   CURSOR generate_demand IS
      SELECT NVL(SUM(NVL(qty_supply,0)-NVL(qty_demand,0)),0)
      FROM  ORDER_SUPPLY_DEMAND
      WHERE contract          = contract_
      AND   part_no           = part_no_
      AND   (configuration_id = configuration_id_ OR configuration_id_ IS NULL)
      AND   (condition_code   = condition_code_ OR condition_code_ IS NULL)
      AND TRUNC(date_required) <= NVL(to_order_date_,
                                      last_calendar_date_);
BEGIN
   invrec_ := Inventory_Part_API.get(contract_, part_no_);
   dist_calendar_id_  := Site_API.Get_Dist_Calendar_Id(contract_);
   manuf_calendar_id_ := Site_API.Get_Manuf_Calendar_Id(contract_);
   
   IF (invrec_.lead_time_code = 'M') THEN
      leadtime_   := invrec_.manuf_leadtime;
   ELSIF (invrec_.lead_time_code = 'P') THEN
      leadtime_   := invrec_.purch_leadtime;
   END IF;
   to_order_date_  := date_required_ + leadtime_;
      
   plannable_qty_on_hand_ := Inventory_Part_In_Stock_API.Get_Inventory_Quantity(
                                                  contract_               => contract_,
                                                  part_no_                => part_no_,
                                                  configuration_id_       => configuration_id_,
                                                  qty_type_               => 'ONHAND_PLUS_TRANSIT',
                                                  expiration_control_     => 'NOT EXPIRED',
                                                  supply_control_db_      => 'NETTABLE',
                                                  ownership_type1_db_     => 'CONSIGNMENT',
                                                  ownership_type2_db_     => 'COMPANY OWNED',
                                                  include_project_        => 'FALSE',
                                                  condition_code_         => condition_code_);

   OPEN  generate_demand;
   FETCH generate_demand INTO  supply_demand_;     
   CLOSE generate_demand;

   qty_onhand_ := plannable_qty_on_hand_ + supply_demand_;
   
   IF (qty_onhand_ < 0) THEN      
      safety_lead_time_ := Inventory_Part_Planning_API.Get_Safety_Lead_Time(contract_, part_no_);
      IF (safety_lead_time_ > 0) THEN      
         IF (invrec_.lead_time_code = 'P') THEN
            local_date_required_ := Work_Time_Calendar_API.Get_Prior_Work_Day (dist_calendar_id_, date_required_); 
            local_date_required_ := Work_Time_Calendar_API.Get_Work_Day(dist_calendar_id_, (Work_Time_Calendar_API.Get_Work_Day_Counter(dist_calendar_id_, local_date_required_)) - safety_lead_time_);
         ELSIF (invrec_.lead_time_code = 'M') THEN
            local_date_required_ := Work_Time_Calendar_API.Get_Prior_Work_Day (manuf_calendar_id_, date_required_); 
            local_date_required_ := Work_Time_Calendar_API.Get_Work_Day(manuf_calendar_id_, (Work_Time_Calendar_API.Get_Work_Day_Counter(manuf_calendar_id_, local_date_required_)) - safety_lead_time_);
         END IF;
      ELSE
         local_date_required_ := date_required_;
      END IF;
      
      order_qty_ := LEAST((qty_onhand_ * -1), qty_ordered_);
      order_qty_  := Inventory_Part_Planning_API.Get_Scrap_Added_Qty(contract_, part_no_, order_qty_);

      Calc_Make_Buy_Split_Qty(part_supply_qty_coll_,
                              order_qty_,
                              to_order_date_,
                              contract_,
                              part_no_);   

      IF (part_supply_qty_coll_.COUNT > 0) THEN
         FOR n IN part_supply_qty_coll_.FIRST..part_supply_qty_coll_.LAST LOOP
            req_no_           := NULL;
            
            IF (part_supply_qty_coll_(n).source_category_db = 'DO') THEN
               $IF Component_Disord_SYS.INSTALLED $THEN
                  -- Create distribution order
                  req_code_         := 'NLD';                  
                  Distribution_Order_API.Create_Distribution_Order(
                                             planned_due_date_,
                                             req_no_,
                                             part_supply_qty_coll_(n).supply_qty,
                                             part_supply_qty_coll_(n).supplying_site,                                             
                                             contract_,
                                             part_no_,
                                             req_code_,
                                             NULL,
                                             local_date_required_,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             condition_code_);
               $ELSE
                  NULL;
               $END               
            ELSIF (part_supply_qty_coll_(n).source_category_db = 'PUR') THEN
               $IF Component_Purch_SYS.INSTALLED $THEN
                  order_code_       := '1';
                  req_code_         := 'NLD';
                  
                  -- Create requisition
                  Purchase_Req_Util_API.New_Requisition(
                                                   req_no_,
                                                   order_code_,
                                                   part_supply_qty_coll_(n).supplying_site,
                                                   req_code_);
                  -- Create requisition lines
                  unit_meas_        := invrec_.unit_meas;
                  demand_code_      := Order_Supply_Type_API.Decode('IO');
                  release_no_       := NULL;
                  line_no_          := NULL;
                  
                  Purchase_Req_Util_API.New_Line_Part(
                                                line_no_,
                                                release_no_,
                                                req_no_,
                                                part_supply_qty_coll_(n).supplying_site,
                                                part_no_,
                                                unit_meas_,
                                                part_supply_qty_coll_(n).supply_qty,
                                                local_date_required_,
                                                demand_code_,
                                                vendor_no_,
                                                order_code_,
                                                qty_balance_,
                                                qty_on_order_,
                                                curr_code_,
                                                curr_rate_,
                                                eng_chg_level_,
                                                description_,
                                                latest_order_date_,
                                                note_text_,
                                                buy_unit_meas_,
                                                supplier_split_,
                                                requested_qty_,
                                                split_percentage_,
                                                process_type_,
                                                1            ,
                                                demand_order_no_,
                                                demand_release_,
                                                demand_sequence_no_,
                                                demand_order_code_,
                                                demand_order_type_,
                                                demand_operation_no_,
                                                configuration_id_,
                                                technical_coordinator_id_,
                                                condition_code_);
                  
                  Purchase_Req_Util_API.Activate_Requisition(req_no_);
               $ELSE
                  NULL;
               $END               
            ELSIF (part_supply_qty_coll_(n).source_category_db = 'MFG') THEN
               $IF Component_Shpord_SYS.INSTALLED $THEN
                  counter_          := NULL;
                  prop_no_          := NULL; 
                  
                  -- Get Shop Proposal Type
                  shop_prop_type_ := Shop_Proposal_Type_API.Get_Client_Value(4);
                  -- Create Shop Order Proposal
                  Shop_Order_Prop_API.Generate_Proposal(
                                                   prop_no_,
                                                   part_no_,
                                                   contract_,
                                                   counter_,
                                                   local_date_required_,
                                                   part_supply_qty_coll_(n).supply_qty,
                                                   shop_prop_type_,
                                                   NULL,
                                                   NULL,
                                                   NULL,
                                                   condition_code_);
               $ELSE
                  NULL;
               $END
            END IF;            
         END LOOP;
      END IF;
   END IF;
END Generate_Next_Level_Demands;


@UncheckedAccess
FUNCTION Check_Part_Exist (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN NUMBER
IS
   dummy_   NUMBER;

   CURSOR getrec IS
      SELECT 1
      FROM ORDER_SUPPLY_DEMAND
      WHERE contract = contract_
      AND   part_no  = part_no_;
BEGIN
   OPEN getrec;
   FETCH getrec INTO dummy_;
   IF (getrec%NOTFOUND) THEN
      CLOSE getrec;
      RETURN 0;
   END IF;
   CLOSE getrec;
   RETURN 1;
END Check_Part_Exist;



-- Get_Supply_Demand_Info
--   This method returns the available and projected demands supplies
--   of a particular Part for a given period.
--   include_standard_       : values are 'TRUE' or 'FALSE'
--   include_project_        : values are 'TRUE' or 'FALSE'
--   source_                 : values are 'CUSTORD_SUPPLY_DEMAND' or 'ORDER_SUPPLY_DEMAND_EXT'
PROCEDURE Get_Supply_Demand_Info (
   total_demand_           OUT NUMBER,
   total_reserved_         OUT NUMBER,
   total_supply_           OUT NUMBER,
   contract_               IN  VARCHAR2,
   part_no_                IN  VARCHAR2,
   configuration_id_       IN  VARCHAR2,
   include_standard_       IN  VARCHAR2,
   include_project_        IN  VARCHAR2,
   project_id_             IN  VARCHAR2,
   activity_seq_           IN  NUMBER,
   date_required_          IN  DATE,
   source_                 IN  VARCHAR2 )
IS
   last_calendar_date_  DATE      := Database_Sys.last_calendar_date_;
   -- Note: Qty Demand is equal to "Revised Qty - Qty Shipped" or "Revised Qty - Qty Issued"
   CURSOR get_available IS
      SELECT NVL(SUM(NVL(qty_demand,0)), 0),
             NVL(SUM(NVL(qty_reserved,0)), 0),
             NVL(SUM(NVL(qty_supply,0)), 0)
      FROM CUSTORD_SUPPLY_DEMAND
      WHERE   contract = contract_
      AND     part_no = part_no_
      AND    (configuration_id = configuration_id_ OR configuration_id_ IS NULL)
      AND   ((include_standard_ = 'TRUE'     AND project_id  = '*')
         OR  (include_project_  = 'TRUE'     AND project_id != '*'
         AND (project_id    = project_id_    OR  project_id_   IS NULL)
         AND (activity_seq  = activity_seq_  OR  activity_seq_ IS NULL)))
      AND trunc(date_required) <= NVL(date_required_,last_calendar_date_);

   -- Note: Qty Demand is equal to "Revised Qty - Qty Shipped" or "Revised Qty - Qty Issued"
   CURSOR get_projected IS
      SELECT NVL(SUM(NVL(qty_demand,0)), 0),
             NVL(SUM(NVL(qty_reserved,0)), 0),
             NVL(SUM(NVL(qty_supply,0)), 0)
      FROM ORDER_SUPPLY_DEMAND_EXT
      WHERE   contract = contract_
      AND     part_no = part_no_
      AND    (configuration_id = configuration_id_ OR configuration_id_ IS NULL)
      AND   ((include_standard_ = 'TRUE'     AND project_id  = '*')
         OR  (include_project_  = 'TRUE'     AND project_id != '*'
         AND (project_id    = project_id_    OR  project_id_   IS NULL)
         AND (activity_seq  = activity_seq_  OR  activity_seq_ IS NULL)))
      AND trunc(date_required) <= NVL(date_required_,last_calendar_date_);
BEGIN
   IF source_ = 'CUSTORD_SUPPLY_DEMAND' THEN
      OPEN get_available;
      FETCH get_available INTO total_demand_, total_reserved_, total_supply_;
      CLOSE get_available;
   ELSIF source_ = 'ORDER_SUPPLY_DEMAND_EXT' THEN
      OPEN get_projected;
      FETCH get_projected INTO total_demand_, total_reserved_, total_supply_;
      CLOSE get_projected;
   ELSE -- This should not happen
      total_supply_   := NULL;
      total_demand_   := NULL;
      total_reserved_ := NULL;
   END IF;
END Get_Supply_Demand_Info;


-- Calc_Make_Buy_Split_Qty
--   Determine Supplier split for net requirement and set an out
--   parameter of type Part_Supply_Qty_Collection.
PROCEDURE Calc_Make_Buy_Split_Qty (
    part_supply_qty_coll_ IN OUT Part_Supply_Qty_Collection,
    net_demand_qty_       IN     NUMBER,
    demand_date_          IN     DATE,
    contract_             IN     VARCHAR2,
    part_no_              IN     VARCHAR2 )
IS
   type_code_db_              VARCHAR2(8);
   part_planning_rec_         Inventory_Part_Planning_API.Public_Rec;
   mfg_supply_qty_            NUMBER;
   acq_supply_qty_            NUMBER;   
   cur_row_                   PLS_INTEGER;
   site_collection_empty_     VARCHAR2(5) := 'TRUE';
   part_supply_qty_coll_temp_ Part_Supply_Qty_Collection;
BEGIN
   --Inventory part type:
   type_code_db_ := Inventory_Part_API.Get_Type_Code_Db(contract_,part_no_);
   part_planning_rec_  := Inventory_Part_Planning_API.Get(contract_, part_no_);

   IF (type_code_db_ IN('1','2')) THEN
      -- Inventory part type Manufactured or Manufactured Recipe
      IF part_planning_rec_.split_manuf_acquired = 'SPLIT' THEN
         mfg_supply_qty_ := (net_demand_qty_ * part_planning_rec_.percent_manufactured)/100;
      ELSE
         mfg_supply_qty_ := net_demand_qty_;
      END IF;
      -- Scrap rounding Mfg Supply Qty
      mfg_supply_qty_ := Inventory_Part_API.Get_Calc_Rounded_Qty(contract_, part_no_, mfg_supply_qty_);
      acq_supply_qty_ := net_demand_qty_ - mfg_supply_qty_;
   ELSE
      IF part_planning_rec_.split_manuf_acquired = 'SPLIT' THEN
         acq_supply_qty_ := (net_demand_qty_ * part_planning_rec_.percent_acquired)/100;
      ELSE
         acq_supply_qty_ := net_demand_qty_;
      END IF;
   END IF;
   -- Scrap rounding acq_supply_qty_
   acq_supply_qty_ := Inventory_Part_API.Get_Calc_Rounded_Qty(contract_, part_no_, acq_supply_qty_);
   
   IF acq_supply_qty_>0 THEN   
      $IF Component_Purch_SYS.INSTALLED $THEN
         DECLARE
            site_collection_         Supply_Source_Part_Manager_API.Part_Supplier_Collection;
            acq_supply_qty_share_    NUMBER;
            acq_supp_qty_            NUMBER;
            leftover_qty_acq_        NUMBER;
            non_multisite_share_qty_ NUMBER:=0;
            std_multiple_qty_        NUMBER;
            local_temp_              Order_Supply_Demand_API.Part_Supply_Qty_Collection;
            cur_row_                 PLS_INTEGER;
            site_coll_empty_         VARCHAR2(5) := 'TRUE';
         BEGIN
            Supply_Source_Part_Manager_API.collect_supplier_list(site_collection_, contract_, part_no_, demand_date_, NULL);
            acq_supp_qty_     := acq_supply_qty_;
            leftover_qty_acq_ := acq_supp_qty_;
            FOR i IN 1..site_collection_.COUNT LOOP
               site_coll_empty_ := 'FALSE';
               IF site_collection_(i).multisite_planned_part_db = 'MULTISITE_PLAN'
                         AND site_collection_(i).split_percentage > 0 THEN
                  std_multiple_qty_ := NVL(site_collection_(i).std_multiple_qty, 1);
                  IF i = site_collection_.LAST THEN
                     acq_supply_qty_share_ := leftover_qty_acq_;
                  ELSE
                     acq_supply_qty_share_ := site_collection_(i).split_percentage * acq_supp_qty_ /100;
                  END IF;
                  acq_supply_qty_share_ := std_multiple_qty_ * CEIL(acq_supply_qty_share_ / std_multiple_qty_);
                  cur_row_ := NVL(local_temp_.LAST, 0) + 1;
                  local_temp_(cur_row_).source_category_db :='DO';
                  local_temp_(cur_row_).vendor_no :=site_collection_(i).vendor_no;
                  local_temp_(cur_row_).supplying_site := site_collection_(i).supplying_site;
                  local_temp_(cur_row_).supply_qty := acq_supply_qty_share_;
               ELSE
                  IF i = site_collection_.LAST THEN
                     acq_supply_qty_share_ := leftover_qty_acq_;
                  ELSE
                     acq_supply_qty_share_ := site_collection_(i).split_percentage * acq_supp_qty_ /100;
                  END IF;
                  non_multisite_share_qty_ := non_multisite_share_qty_ + acq_supply_qty_share_;
               END IF;
               leftover_qty_acq_ := leftover_qty_acq_ - acq_supply_qty_share_;
            END LOOP;
            site_collection_empty_ := site_coll_empty_; 
            IF (non_multisite_share_qty_ > 0) THEN
               cur_row_ := NVL(local_temp_.LAST, 0) + 1;
               local_temp_(cur_row_).source_category_db := 'PUR';
               local_temp_(cur_row_).supplying_site := contract_;
               local_temp_(cur_row_).supply_qty := non_multisite_share_qty_;
            END IF;
            part_supply_qty_coll_temp_ := local_temp_;
         END;
         part_supply_qty_coll_ := part_supply_qty_coll_temp_;
         part_supply_qty_coll_temp_.DELETE;
      $ELSE
         NULL;
      $END
   END IF;   

   -- No primary supplier is found
   IF (site_collection_empty_ = 'TRUE') AND (acq_supply_qty_ > 0) THEN
      cur_row_ := NVL(part_supply_qty_coll_.LAST, 0) + 1;
      part_supply_qty_coll_(cur_row_).source_category_db := 'PUR';
      part_supply_qty_coll_(cur_row_).supplying_site := contract_;
      part_supply_qty_coll_(cur_row_).supply_qty := acq_supply_qty_;      
   END IF;

   IF (type_code_db_='4')  THEN
      -- Inventory part type Purchased
      mfg_supply_qty_ := net_demand_qty_ - acq_supply_qty_;
   END IF;

   IF mfg_supply_qty_ >0 THEN
      cur_row_ := NVL(part_supply_qty_coll_.LAST, 0) + 1;
      part_supply_qty_coll_(cur_row_).source_category_db := 'MFG';
      part_supply_qty_coll_(cur_row_).supply_qty := mfg_supply_qty_;
   END IF;
END Calc_Make_Buy_Split_Qty;


-- Get_Project_Date_Supply_Demand
--   This function returns the total qty supply, total qty demand,
--   project id and date required for a particular part.
@UncheckedAccess
FUNCTION Get_Project_Date_Supply_Demand (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   project_id_       IN VARCHAR2 ) RETURN Proj_Date_Supply_Demand_Table
IS
   CURSOR get_proj_date_supply_demand IS
      SELECT  NVL(project_id,'*'),
              TRUNC(date_required) date_required,
              SUM(qty_supply)      qty_supply,
              SUM(qty_demand)      qty_demand
        FROM  ORDER_SUPPLY_DEMAND_EXT
       WHERE  part_no                = part_no_
         AND  contract               = contract_
         AND  configuration_id       = configuration_id_
         AND (project_id             = project_id_ OR project_id_ IS NULL)
      GROUP BY project_id, TRUNC(date_required)
      ORDER BY project_id, TRUNC(date_required);
   supply_demand_tab_ Proj_Date_Supply_Demand_Table;
BEGIN
   OPEN get_proj_date_supply_demand;
   FETCH get_proj_date_supply_demand BULK COLLECT INTO supply_demand_tab_;
   CLOSE get_proj_date_supply_demand;
   RETURN supply_demand_tab_;
END Get_Project_Date_Supply_Demand;



-- Get_Total_Demand
--   This function returns the total_demand_ until a given date.
--   The source_ parameter controls which of supply demand views that should be used.
--   Values for source_are 'CUSTORD_SUPPLY_DEMAND' or 'ORDER_SUPPLY_DEMAND_EXT'.
--   exclude_reserved_ controls whether a reserved order qty should reduce the total demand.
--   Values are 'TRUE' or 'FALSE', 'TRUE' means "qty_demand - qty_reserved".
--   When source is 'ORDER_SUPPLY_DEMAND_EXT' the parameter only_firm_demands_ can be used to select all demands or only the ones considered as firm.
@UncheckedAccess
FUNCTION Get_Total_Demand (
   contract_               IN VARCHAR2,
   part_no_                IN VARCHAR2,
   configuration_id_       IN VARCHAR2,
   include_standard_       IN VARCHAR2,     
   include_project_        IN VARCHAR2,   
   project_id_             IN VARCHAR2,
   activity_seq_           IN NUMBER,
   date_required_          IN DATE,
   source_                 IN VARCHAR2,
   exclude_reserved_       IN VARCHAR2,
   only_firm_demands_      IN VARCHAR2 DEFAULT Fnd_Boolean_API.DB_FALSE) RETURN NUMBER
IS
   total_demand_           NUMBER := 0;
   total_reserved_demand_  NUMBER := 0;
   last_calendar_date_     DATE   := Database_Sys.last_calendar_date_;  
   
   CURSOR get_demand IS
      SELECT NVL(SUM(NVL(qty_demand,0)), 0),
             NVL(SUM(NVL(qty_reserved,0)), 0)
      FROM CUSTORD_SUPPLY_DEMAND
      WHERE contract = contract_
      AND   part_no = part_no_
      AND   (configuration_id = configuration_id_ OR configuration_id_ IS NULL)
      AND   ((include_standard_ = 'TRUE'     AND project_id  = '*')
         OR (include_project_  = 'TRUE'     AND project_id != '*'
            AND (project_id    = project_id_    OR  project_id_   IS NULL)
            AND (activity_seq  = activity_seq_  OR  activity_seq_ IS NULL)))
      AND trunc(date_required) <= NVL(date_required_,last_calendar_date_);

   CURSOR get_demand_ext IS
      SELECT NVL(SUM(NVL(qty_demand,0)), 0),
             NVL(SUM(NVL(qty_reserved,0)), 0)
      FROM ORDER_SUPPLY_DEMAND_EXT
      WHERE contract = contract_
      AND   part_no = part_no_
      AND   (configuration_id = configuration_id_ OR configuration_id_ IS NULL)
      AND   ((include_standard_ = 'TRUE'     AND project_id  = '*')
         OR (include_project_  = 'TRUE'     AND project_id != '*'
            AND (project_id    = project_id_    OR  project_id_   IS NULL)
            AND (activity_seq  = activity_seq_  OR  activity_seq_ IS NULL)))
      AND   (only_firm_demands_ = 'FALSE' OR firm_db = 'TRUE')      
      AND trunc(date_required) <= NVL(date_required_, last_calendar_date_);
BEGIN
   IF(source_ = 'CUSTORD_SUPPLY_DEMAND') THEN
      OPEN get_demand;
      FETCH get_demand INTO total_demand_, total_reserved_demand_;
      CLOSE get_demand;
   ELSIF (source_ = 'ORDER_SUPPLY_DEMAND_EXT') THEN
      OPEN get_demand_ext;
      FETCH get_demand_ext INTO total_demand_, total_reserved_demand_;
      CLOSE get_demand_ext;
   END IF;

   IF exclude_reserved_ = 'TRUE' THEN
      RETURN total_demand_ - total_reserved_demand_;
   ELSE
      RETURN total_demand_;
   END IF;
END Get_Total_Demand;

@UncheckedAccess
FUNCTION Get_Net_Demand_Per_Demand_Type (
   contract_                     IN VARCHAR2,
   part_no_                      IN VARCHAR2,
   configuration_id_             IN VARCHAR2, 
   project_id_                   IN VARCHAR2,
   date_required_                IN DATE,
   include_cust_order_           IN VARCHAR2 DEFAULT 'FALSE',
   include_ext_cust_order_       IN VARCHAR2 DEFAULT 'FALSE',
   include_prod_schedule_demand_ IN VARCHAR2 DEFAULT 'FALSE',
   include_purch_order_res_      IN VARCHAR2 DEFAULT 'FALSE',
   include_material_req_         IN VARCHAR2 DEFAULT 'FALSE',
   include_sales_quotation_      IN VARCHAR2 DEFAULT 'FALSE',  
   include_work_order_           IN VARCHAR2 DEFAULT 'FALSE',
   include_sourced_order_        IN VARCHAR2 DEFAULT 'FALSE',
   include_ext_sourced_order_    IN VARCHAR2 DEFAULT 'FALSE' ) RETURN NUMBER
IS
   total_demand_           NUMBER := 0;

   cust_order_             VARCHAR2(2000):= Order_Supply_Demand_Type_API.Decode('1');
   purch_order_res_        VARCHAR2(2000):= Order_Supply_Demand_Type_API.Decode('2');
   material_req_           VARCHAR2(2000):= Order_Supply_Demand_Type_API.Decode('3');
   work_order_             VARCHAR2(2000):= Order_Supply_Demand_Type_API.Decode('6');
   prod_schedule_demand_   VARCHAR2(2000):= Order_Supply_Demand_Type_API.Decode('16');
   sales_quotation_        VARCHAR2(2000):= Order_Supply_Demand_Type_API.Decode('21');
   ext_cust_order_         VARCHAR2(2000):= Order_Supply_Demand_Type_API.Decode('23');
   ext_sourced_order_      VARCHAR2(2000):= Order_Supply_Demand_Type_API.Decode('24');
   sourced_order_          VARCHAR2(2000):= Order_Supply_Demand_Type_API.Decode('25');

   CURSOR get_demand IS
      SELECT NVL(SUM(NVL(qty_demand, 0) - NVL(qty_pegged, 0) - NVL(qty_reserved, 0)), 0) qty_demand
        FROM CUSTORD_SUPPLY_DEMAND
       WHERE contract = contract_
         AND part_no = part_no_
         AND (configuration_id = configuration_id_ OR configuration_id_ IS NULL)
         AND (project_id = project_id_ OR project_id_ IS NULL)
         AND (TRUNC(date_required) < TRUNC(date_required_) OR date_required_ IS NULL)  
         AND ((include_cust_order_           = 'TRUE' AND order_supply_demand_type = cust_order_)            
          OR (include_ext_cust_order_        = 'TRUE' AND order_supply_demand_type = ext_cust_order_)       
          OR (include_prod_schedule_demand_  = 'TRUE' AND order_supply_demand_type = prod_schedule_demand_) 
          OR (include_purch_order_res_       = 'TRUE' AND order_supply_demand_type = purch_order_res_)      
          OR (include_material_req_          = 'TRUE' AND order_supply_demand_type = material_req_)         
          OR (include_sales_quotation_       = 'TRUE' AND order_supply_demand_type = sales_quotation_)      
          OR (include_work_order_            = 'TRUE' AND order_supply_demand_type = work_order_)           
          OR (include_sourced_order_         = 'TRUE' AND order_supply_demand_type = sourced_order_)        
          OR (include_ext_sourced_order_     = 'TRUE' AND order_supply_demand_type = ext_sourced_order_));
BEGIN
   OPEN get_demand;
   FETCH get_demand INTO total_demand_;
   CLOSE get_demand;
   
   RETURN total_demand_;
END Get_Net_Demand_Per_Demand_Type;



-- Get_Total_Supply
--   This function returns the total supply until a given date.
--   The source_ parameter controls which of supply demand views that should be used.
--   Values for source_are 'CUSTORD_SUPPLY_DEMAND' or 'ORDER_SUPPLY_DEMAND_EXT'.
--   When source is 'ORDER_SUPPLY_DEMAND_EXT' the parameter only_firm_supplies_ can be used to select all supplies or only the ones considered as firm.
@UncheckedAccess
FUNCTION Get_Total_Supply (
   contract_                 IN VARCHAR2,
   part_no_                  IN VARCHAR2,
   configuration_id_         IN VARCHAR2,
   include_standard_         IN VARCHAR2,     
   include_project_          IN VARCHAR2,
   project_id_               IN VARCHAR2,
   activity_seq_             IN NUMBER,
   date_required_            IN DATE,
   source_                   IN VARCHAR2,
   order_supply_demand_type_ IN VARCHAR2 DEFAULT NULL,
   only_firm_supplies_       IN VARCHAR2 DEFAULT Fnd_Boolean_API.DB_FALSE) RETURN NUMBER
IS
   total_supply_           NUMBER := 0;
   last_calendar_date_     DATE   := Database_Sys.last_calendar_date_;
   
   CURSOR get_supply IS
      SELECT NVL(SUM(qty_supply), 0) qty_supply
      FROM CUSTORD_SUPPLY_DEMAND
      WHERE contract = contract_
      AND   part_no = part_no_
      AND   (configuration_id = configuration_id_ OR configuration_id_ IS NULL)
      AND   ((include_standard_ = 'TRUE'     AND project_id  = '*')
         OR (include_project_  = 'TRUE'     AND project_id != '*'
            AND (project_id    = project_id_    OR  project_id_   IS NULL)
            AND (activity_seq  = activity_seq_  OR  activity_seq_ IS NULL)))
      AND trunc(date_required) <= NVL(date_required_, last_calendar_date_)
      AND (order_supply_demand_type = order_supply_demand_type_ OR order_supply_demand_type_ IS NULL);

   CURSOR get_supply_ext IS
      SELECT NVL(SUM(qty_supply), 0) qty_supply
      FROM ORDER_SUPPLY_DEMAND_EXT
      WHERE contract = contract_
      AND   part_no = part_no_
      AND   (configuration_id = configuration_id_ OR configuration_id_ IS NULL)
      AND   ((include_standard_ = 'TRUE'     AND project_id  = '*')
         OR (include_project_  = 'TRUE'     AND project_id != '*'
            AND (project_id    = project_id_    OR  project_id_   IS NULL)
            AND (activity_seq  = activity_seq_  OR  activity_seq_ IS NULL)))
      AND (only_firm_supplies_ = 'FALSE' OR firm_db = 'TRUE')      
      AND trunc(date_required) <= NVL(date_required_, last_calendar_date_)
      AND (order_supply_demand_type = order_supply_demand_type_ OR order_supply_demand_type_ IS NULL);
BEGIN
   IF (source_ = 'CUSTORD_SUPPLY_DEMAND')THEN
      OPEN get_supply;
      FETCH get_supply INTO total_supply_;
      CLOSE get_supply;
   ELSIF (source_ = 'ORDER_SUPPLY_DEMAND_EXT') THEN
      OPEN get_supply_ext;
      FETCH get_supply_ext INTO total_supply_;
      CLOSE get_supply_ext;
   END IF;
   RETURN total_supply_;
END Get_Total_Supply;


-- Negative_Projected_Qty_Exists
-- This function returns whether there is a negative projected qty in the sublist of the Inventory Parts Intraday Availability client.
@UncheckedAccess
FUNCTION Negative_Projected_Qty_Exists (
   contract_                        IN VARCHAR2,
   part_no_                         IN VARCHAR2,
   configuration_id_                IN VARCHAR2,
   project_id_                      IN VARCHAR2,
   only_firm_supplies_              IN VARCHAR2,
   only_firm_demands_               IN VARCHAR2,
   include_usable_qty_              IN VARCHAR2,
   time_horizon_date_               IN DATE) RETURN VARCHAR2
IS
   negative_projection_exists_      VARCHAR2(5) := 'FALSE';
   starting_balance_                NUMBER;
   projected_qty_                   NUMBER;
   
   CURSOR get_supply_demand_qty IS
      SELECT qty_supply, qty_demand
      FROM order_supply_demand_ext
      WHERE contract = contract_
      AND part_no = part_no_
      AND configuration_id = configuration_id_
      AND project_id = project_id_
      AND (firm_db = Fnd_Boolean_API.DB_TRUE OR (qty_supply > 0 AND only_firm_supplies_ = Fnd_Boolean_API.DB_FALSE) OR (qty_demand > 0 AND only_firm_demands_ = Fnd_Boolean_API.DB_FALSE))
      AND TRUNC(date_required)<= TRUNC(time_horizon_date_)
      ORDER BY date_time_required, qty_demand;

BEGIN
   
   IF (include_usable_qty_ = Fnd_Boolean_API.DB_TRUE) THEN
      starting_balance_ := Inventory_Part_In_Stock_API.Get_Inventory_Quantity(contract_            => contract_,
                                                                              part_no_             => part_no_,
                                                                              configuration_id_    => configuration_id_,
                                                                              qty_type_            => 'ONHAND_PLUS_TRANSIT',
                                                                              expiration_control_  => 'NOT EXPIRED',
                                                                              supply_control_db_   => 'NETTABLE',
                                                                              ownership_type1_db_  => 'COMPANY OWNED',
                                                                              ownership_type2_db_  => 'CONSIGNMENT',
                                                                              location_type1_db_	=> 'PICKING',
                                                                              location_type2_db_	=> 'F',
                                                                              location_type3_db_   => 'MANUFACTURING',
                                                                              location_type4_db_	=> 'SHIPMENT',
                                                                              include_standard_    => 'TRUE',
                                                                              include_project_     => 'FALSE');
      projected_qty_ := starting_balance_;
   ELSE
      projected_qty_:= 0;
   END IF;
      
   FOR next_rec_ IN get_supply_demand_qty LOOP
      projected_qty_ := projected_qty_ + next_rec_.qty_supply - next_rec_.qty_demand;
      IF (projected_qty_ < 0 ) THEN
         negative_projection_exists_ := 'TRUE';
         EXIT;
      END IF;
   END LOOP;
   
   RETURN negative_projection_exists_;
 	
END Negative_Projected_Qty_Exists;


@UncheckedAccess
FUNCTION Get_Supply_Demand_Per_Type (
   contract_                 IN VARCHAR2,
   part_no_                  IN VARCHAR2,
   configuration_id_         IN VARCHAR2,
   include_standard_         IN VARCHAR2,     
   include_project_          IN VARCHAR2,
   project_id_               IN VARCHAR2,
   activity_seq_             IN NUMBER,
   date_required_            IN DATE,
   source_                   IN VARCHAR2 ) RETURN Supply_Demand_Per_Type_Tab
IS
   date_required_tmp_           DATE := NVL(date_required_, Database_Sys.last_calendar_date_);   
   supply_demand_per_type_tab_  Supply_Demand_Per_Type_Tab;

   CURSOR get_supply_demand IS
      SELECT order_supply_demand_type,
             TRUNC(date_required) date_required,
             NVL(SUM(qty_supply), 0) qty_supply,
             NVL(SUM(qty_demand), 0) qty_demand,
             NVL(SUM(qty_reserved), 0) qty_reserved
      FROM CUSTORD_SUPPLY_DEMAND
      WHERE contract = contract_
      AND   part_no = part_no_
      AND   (configuration_id = configuration_id_ OR configuration_id_ IS NULL)
      AND   ((include_standard_ = 'TRUE'     AND project_id  = '*')
         OR (include_project_  = 'TRUE'     AND project_id != '*'
            AND (project_id    = project_id_    OR  project_id_   IS NULL)
            AND (activity_seq  = activity_seq_  OR  activity_seq_ IS NULL)))
      AND TRUNC(date_required) <= date_required_tmp_
      AND (qty_supply > 0 OR qty_demand > 0 OR qty_reserved > 0)
      GROUP BY TRUNC(date_required), order_supply_demand_type
      ORDER BY TRUNC(date_required);

   CURSOR get_supply_demand_ext IS
      SELECT order_supply_demand_type,
             TRUNC(date_required) date_required,
             NVL(SUM(qty_supply), 0) qty_supply,
             NVL(SUM(qty_demand), 0) qty_demand,
             NVL(SUM(qty_reserved), 0) qty_reserved
      FROM ORDER_SUPPLY_DEMAND_EXT
      WHERE contract = contract_
      AND   part_no = part_no_
      AND   (configuration_id = configuration_id_ OR configuration_id_ IS NULL)
      AND   ((include_standard_ = 'TRUE'     AND project_id  = '*')
         OR (include_project_  = 'TRUE'     AND project_id != '*'
            AND (project_id    = project_id_    OR  project_id_   IS NULL)
            AND (activity_seq  = activity_seq_  OR  activity_seq_ IS NULL)))
      AND TRUNC(date_required) <= date_required_tmp_
      AND (qty_supply > 0 OR qty_demand > 0 OR qty_reserved > 0)
      GROUP BY TRUNC(date_required), order_supply_demand_type
      ORDER BY TRUNC(date_required);
BEGIN
   IF (source_ = 'CUSTORD_SUPPLY_DEMAND')THEN
      OPEN get_supply_demand;
      FETCH get_supply_demand BULK COLLECT INTO supply_demand_per_type_tab_;
      CLOSE get_supply_demand;
   ELSIF (source_ = 'ORDER_SUPPLY_DEMAND_EXT') THEN
      OPEN get_supply_demand_ext;
      FETCH get_supply_demand_ext BULK COLLECT INTO supply_demand_per_type_tab_;
      CLOSE get_supply_demand_ext;
   END IF;
   RETURN supply_demand_per_type_tab_;
END Get_Supply_Demand_Per_Type;



@UncheckedAccess
FUNCTION Get_Sum_Quantity (
   contract_           IN VARCHAR2,
   part_no_            IN VARCHAR2,
   configuration_id_   IN VARCHAR2,
   include_standard_   IN VARCHAR2,     
   include_project_    IN VARCHAR2,
   project_id_         IN VARCHAR2,
   activity_seq_       IN NUMBER,
   begin_date_         IN DATE,
   end_date_           IN DATE,
   qty_type_           IN VARCHAR2 ) RETURN NUMBER
IS
   qty_demand_     NUMBER:=0;
   qty_supply_     NUMBER:=0;
   qty_short_      NUMBER:=0;
   qty_            NUMBER:=0;
BEGIN
   Get_Sum_Quantity(qty_demand_, 
                    qty_supply_, 
                    qty_short_,
                    contract_,
                    part_no_,
                    configuration_id_,
                    include_standard_ ,     
                    include_project_,
                    project_id_,
                    activity_seq_,
                    begin_date_,
                    end_date_);

   
   IF (qty_type_ = 'QTYDEMAND') THEN
      qty_ := qty_demand_;
   ELSIF (qty_type_ = 'QTYSUPPLY') THEN
      qty_ := qty_supply_;
   ELSIF (qty_type_ = 'QTYSHORT') THEN
      qty_ := qty_short_;
   ELSE
      -- To indicate illegal value of inparameter qty_type_.
      qty_ := (-9999999999); 
   END IF;
   
   RETURN qty_;
END Get_Sum_Quantity;



@UncheckedAccess
PROCEDURE Get_Sum_Quantity (
   qty_demand_         OUT NUMBER,
   qty_supply_         OUT NUMBER,
   qty_short_          OUT NUMBER,
   contract_           IN  VARCHAR2,
   part_no_            IN  VARCHAR2,
   configuration_id_   IN  VARCHAR2,
   include_standard_   IN  VARCHAR2,     
   include_project_    IN  VARCHAR2,
   project_id_         IN  VARCHAR2,
   activity_seq_       IN  NUMBER,
   begin_date_         IN  DATE,
   end_date_           IN  DATE ) 
IS
   CURSOR getrec IS
      SELECT NVL(SUM(qty_demand), 0), NVL(SUM(qty_supply), 0), NVL(SUM(qty_short), 0)
      FROM ORDER_SUPPLY_DEMAND_EXT
      WHERE contract = contract_
      AND part_no = part_no_
      AND (configuration_id = configuration_id_ OR configuration_id_ IS NULL)
      AND ((include_standard_ = 'TRUE' AND project_id  = '*')
         OR (include_project_ = 'TRUE' AND project_id != '*'
            AND (project_id   = project_id_    OR  project_id_   IS NULL)
            AND (activity_seq = activity_seq_  OR  activity_seq_ IS NULL)))
      AND (((begin_date_ IS NOT NULL) AND (end_date_ IS NOT NULL) AND (TRUNC(date_required) BETWEEN TRUNC(begin_date_) AND TRUNC(end_date_)))
         OR ((begin_date_ IS NULL) AND (end_date_ IS NOT NULL) AND (TRUNC(date_required) < TRUNC(end_date_))));
BEGIN
   OPEN getrec;
   FETCH getrec INTO qty_demand_, qty_supply_, qty_short_;
   CLOSE getrec;
END Get_Sum_Quantity;


@UncheckedAccess
FUNCTION Get_Sum_Supply_Demand_Per_Date (
   contract_          IN VARCHAR2,
   part_no_           IN VARCHAR2,
   configuration_id_  IN VARCHAR2 DEFAULT NULL,
   include_demands_   IN BOOLEAN  DEFAULT TRUE,
   include_supplies_  IN BOOLEAN  DEFAULT TRUE,
   from_date_         IN DATE     DEFAULT NULL,
   to_date_           IN DATE     DEFAULT NULL ) RETURN Supply_Demand_Date_Tab
IS
   supply_demand_date_tab_ Supply_Demand_Date_Tab;
   include_supplies_char_  VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;
   include_demands_char_   VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;

   CURSOR get_sum_supply_demand_per_date IS
      SELECT TRUNC(date_required),
             SUM(NVL(qty_supply,0)),
             SUM(NVL(qty_demand,0))
      FROM  ORDER_SUPPLY_DEMAND
      WHERE contract = contract_
      AND   part_no  = part_no_
   AND (configuration_id = configuration_id_ OR configuration_id_ IS NULL)
   AND ((qty_supply != 0 AND include_supplies_char_ = Fnd_Boolean_API.DB_TRUE) OR
        (qty_demand != 0 AND include_demands_char_  = Fnd_Boolean_API.DB_TRUE))
   AND TRUNC(date_required) BETWEEN NVL(from_date_, Database_SYS.first_calendar_date_) AND
                                    NVL(to_date_  , Database_SYS.last_calendar_date_)
      GROUP BY TRUNC(date_required)
      ORDER BY TRUNC(date_required);
BEGIN
   IF (include_supplies_) THEN
      include_supplies_char_ := Fnd_Boolean_API.DB_TRUE;
   END IF;
   IF (include_demands_) THEN
      include_demands_char_  := Fnd_Boolean_API.DB_TRUE;
   END IF; 
  
   OPEN get_sum_supply_demand_per_date;
   FETCH get_sum_supply_demand_per_date BULK COLLECT INTO supply_demand_date_tab_;
   CLOSE get_sum_supply_demand_per_date;
   RETURN (supply_demand_date_tab_);
END Get_Sum_Supply_Demand_Per_Date;


@UncheckedAccess
FUNCTION Get_Order_Supply_Demand_Tab (
   contract_           IN VARCHAR2,
   part_no_            IN VARCHAR2 ) RETURN Order_Supply_Demand_Ms_Tab
IS
   order_supply_demand_ms_tab_   Order_Supply_Demand_Ms_Tab;   
   
   CURSOR get_order_supply_demand IS
      SELECT order_no, line_no, rel_no, line_item_no,
             date_required, qty_demand, qty_supply, status_code, order_supply_demand_type
        FROM ORDER_SUPPLY_DEMAND_MS
       WHERE contract = contract_
         AND part_no  = part_no_;
BEGIN   
   OPEN get_order_supply_demand;
   FETCH get_order_supply_demand BULK COLLECT INTO order_supply_demand_ms_tab_;
   CLOSE get_order_supply_demand;
   RETURN (order_supply_demand_ms_tab_);
END Get_Order_Supply_Demand_Tab;



@UncheckedAccess
FUNCTION Get_Order_Supply_Demand_Tab (
   contract_                        IN VARCHAR2,
   part_no_                         IN VARCHAR2,
   configuration_id_                IN VARCHAR2,
   include_standard_                IN VARCHAR2,     
   include_project_                 IN VARCHAR2,
   project_id_                      IN VARCHAR2,
   activity_seq_                    IN NUMBER ) RETURN Order_Supply_Demand_Ext_Tab
IS
   order_supply_demand_ext_tab_   Order_Supply_Demand_Ext_Tab;
   
   CURSOR get_order_supply_demand IS
      SELECT order_no, line_no, rel_no, line_item_no, date_required,
             NVL(qty_demand, 0), NVL(qty_reserved, 0), NVL(qty_supply, 0), NVL(qty_pegged, 0), project_id,
             activity_seq, order_supply_demand_type, status_code, status_desc, info 
        FROM ORDER_SUPPLY_DEMAND_EXT
       WHERE contract = contract_
         AND part_no  = part_no_
         AND (configuration_id = configuration_id_ OR configuration_id_ IS NULL)
         AND ((include_standard_ = 'TRUE' AND project_id  = '*')
          OR (include_project_  = 'TRUE'  AND project_id != '*'
         AND (project_id    = project_id_   OR  project_id_   IS NULL)
         AND (activity_seq  = activity_seq_ OR  activity_seq_ IS NULL)))
    ORDER BY date_required;
BEGIN
   OPEN get_order_supply_demand;
   FETCH get_order_supply_demand BULK COLLECT INTO order_supply_demand_ext_tab_;
   CLOSE get_order_supply_demand;
   RETURN (order_supply_demand_ext_tab_);
END Get_Order_Supply_Demand_Tab;



@UncheckedAccess
FUNCTION Get_Order_Supply_Demand_Tab (
   contract_                    IN VARCHAR2,
   part_no_                     IN VARCHAR2,
   configuration_id_            IN VARCHAR2,
   project_id_                  IN VARCHAR2 ) RETURN Custord_Supply_Demand_Tab
IS
   custord_supply_demand_tab_  Custord_Supply_Demand_Tab;

   CURSOR get_ord_sup_demand_by_date IS
      SELECT order_no, line_no, rel_no, order_supply_demand_type, qty_supply, qty_pegged, date_required
        FROM CUSTORD_SUPPLY_DEMAND
       WHERE contract = contract_
         AND part_no  = part_no_
         AND (configuration_id = configuration_id_ OR configuration_id_ IS NULL)
         AND (project_id = project_id_ OR project_id_ IS NULL)
    ORDER BY date_required;
BEGIN 
   OPEN get_ord_sup_demand_by_date;
   FETCH get_ord_sup_demand_by_date BULK COLLECT INTO custord_supply_demand_tab_;
   CLOSE get_ord_sup_demand_by_date;
   RETURN (custord_supply_demand_tab_);
END Get_Order_Supply_Demand_Tab;



-- Open_Projects_Exist
--   Check if there is any open projects for contract
@UncheckedAccess
FUNCTION Open_Projects_Exist (
   contract_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_               NUMBER;
   open_projects_exist_ VARCHAR2(5) := 'FALSE';

   $IF Component_Proj_SYS.INSTALLED $THEN
      CURSOR exist_control IS
         SELECT 1
         FROM open_project_site
         WHERE site = contract_;
   $END
BEGIN
   $IF Component_Proj_SYS.INSTALLED $THEN
      OPEN exist_control;
      FETCH exist_control INTO dummy_;
      IF (exist_control%FOUND) THEN
         open_projects_exist_ := 'TRUE';
      END IF;
      CLOSE exist_control;
   $END
   RETURN(open_projects_exist_);
END Open_Projects_Exist;



-- Get_Net_Expired_Date_And_Qty
--   Returns an array of expired inventory for an inventory part
--   which is not likely to be used by earlier actual demands.
--   The open demands (CO Lines etc) are passed in through the demand_date_qty_tab_ parameter.
--   Open demands that are prior inventory lot expiration are considered to be able to "use up" the later lot expirations.
FUNCTION Get_Net_Expired_Date_And_Qty (
   expired_date_qty_tab_      IN Inventory_Part_In_Stock_API.Expired_Date_Qty_Tab,
   demand_date_qty_tab_       IN Demand_Date_Qty_Tab,
   today_                     IN DATE,
   min_durab_days_planning_   IN NUMBER,
   calendar_id_               IN VARCHAR2 ) RETURN Remaining_Expired_Tab
IS
   
   demand_exist_prior_expiration_   BOOLEAN;
   row_index_                       PLS_INTEGER := 1;
   max_index_                       PLS_INTEGER := 0;
   calc_exp_date_                   DATE;
   remaining_expired_tab_           Remaining_Expired_Tab;
   unconsume_qty_expired_           NUMBER;
   
   TYPE Local_Demand_Date_Qty_Rec IS RECORD (
         date_required     DATE,
         qty_demand        NUMBER,
         is_projected_calc BOOLEAN );
   TYPE Local_Demand_Date_Qty_Rec_Tab IS TABLE OF Local_Demand_Date_Qty_Rec INDEX BY PLS_INTEGER;
   l_demand_date_qty_tab_           Local_Demand_Date_Qty_Rec_Tab;
   
   TYPE Local_Remaining_Expired_Rec IS RECORD (
         expiration_date        DATE,
         activity_seq           NUMBER,
         lot_batch_no           VARCHAR2(20),
         qty_expired            NUMBER,   -- this will be used as FYI for the caller
         unconsumed_qty_expired NUMBER,   -- internal use
         remaining_qty_expired  NUMBER);  -- remaining_qty_expired is the gross requirement
   TYPE Local_Remaining_Expired_Tab IS TABLE OF Local_Remaining_Expired_Rec INDEX BY PLS_INTEGER;
   l_remaining_expired_tab_         Local_Remaining_Expired_Tab;
   
BEGIN
   
   IF (expired_date_qty_tab_.COUNT > 0) THEN
      FOR i IN expired_date_qty_tab_.FIRST .. expired_date_qty_tab_.LAST LOOP
         IF (demand_date_qty_tab_.COUNT > 0) THEN
            FOR j IN demand_date_qty_tab_.FIRST .. demand_date_qty_tab_.LAST LOOP
               -- Perform a simple sanity check so that we do not compare "apple with pears"
               IF demand_date_qty_tab_(j).contract != expired_date_qty_tab_(i).contract OR
                  demand_date_qty_tab_(j).part_no != expired_date_qty_tab_(i).part_no THEN
                  Error_SYS.Record_General(lu_name_,'EXPIREDDEMANDMISMATCH: The Expired Inventory Part :P1 is not equal to the Inventory Part :P2 of the Open Demand', 
                     expired_date_qty_tab_(i).contract||'/'||expired_date_qty_tab_(i).part_no, demand_date_qty_tab_(j).contract||'/'||demand_date_qty_tab_(j).part_no);
               END IF;         
            END LOOP;
         END IF;
         -- Copy to local array 
         -- Some fields will be used by the consumption logic here below
         IF expired_date_qty_tab_(i).expiration_date > (today_ + min_durab_days_planning_) THEN 
            l_remaining_expired_tab_(row_index_).expiration_date        := expired_date_qty_tab_(i).expiration_date;
            l_remaining_expired_tab_(row_index_).activity_seq           := expired_date_qty_tab_(i).activity_seq;
            l_remaining_expired_tab_(row_index_).lot_batch_no           := expired_date_qty_tab_(i).lot_batch_no;
            l_remaining_expired_tab_(row_index_).qty_expired            := expired_date_qty_tab_(i).qty_expired;
            l_remaining_expired_tab_(row_index_).unconsumed_qty_expired := expired_date_qty_tab_(i).qty_expired;
            l_remaining_expired_tab_(row_index_).remaining_qty_expired  := expired_date_qty_tab_(i).qty_expired;
            row_index_ := row_index_ + 1;
         END IF;
      END LOOP;
   END IF;
   
   IF (l_remaining_expired_tab_.COUNT > 0) THEN
      IF (demand_date_qty_tab_.COUNT > 0) THEN
         -- Initialize a local array which is identical to demand_date_qty_tab_, except that is has a boolean flag
         -- that indicates if row has been part of the "projected onhand" calculation
         FOR j IN demand_date_qty_tab_.FIRST .. demand_date_qty_tab_.LAST LOOP
            l_demand_date_qty_tab_(j).date_required := TRUNC(demand_date_qty_tab_(j).date_required);
            l_demand_date_qty_tab_(j).qty_demand := demand_date_qty_tab_(j).qty_demand;
            l_demand_date_qty_tab_(j).is_projected_calc := FALSE;
         END LOOP;
      END IF;
      
      FOR i IN l_remaining_expired_tab_.FIRST .. l_remaining_expired_tab_.LAST LOOP
         demand_exist_prior_expiration_ := FALSE;
         unconsume_qty_expired_ := l_remaining_expired_tab_(i).unconsumed_qty_expired;
         IF (demand_date_qty_tab_.COUNT > 0) THEN
            FOR j IN l_demand_date_qty_tab_.FIRST .. l_demand_date_qty_tab_.LAST LOOP
               calc_exp_date_ := l_remaining_expired_tab_(i).expiration_date - min_durab_days_planning_;
               calc_exp_date_ := Work_Time_Calendar_API.Get_Prior_Work_Day(calendar_id_, calc_exp_date_);
               -- We can only consume the actual demands that are before l_remaining_expired_tab_(i).date_expired with offset min_durab_days_planning_ 
               IF (l_demand_date_qty_tab_(j).date_required < calc_exp_date_) THEN
                  IF (l_demand_date_qty_tab_(j).qty_demand > 0 AND unconsume_qty_expired_ > 0) THEN
                     demand_exist_prior_expiration_ := TRUE;
                     IF NOT l_demand_date_qty_tab_(j).is_projected_calc THEN
                        unconsume_qty_expired_ := unconsume_qty_expired_ - l_demand_date_qty_tab_(j).qty_demand;
                        IF (unconsume_qty_expired_ < 0) THEN 
                           unconsume_qty_expired_ := 0;
                        ELSE
                           l_demand_date_qty_tab_(j).is_projected_calc := TRUE;
                        END IF;                        
                     END IF;

                     l_remaining_expired_tab_(i).remaining_qty_expired := GREATEST(l_remaining_expired_tab_(i).unconsumed_qty_expired - l_demand_date_qty_tab_(j).qty_demand, 0);

                     IF l_demand_date_qty_tab_(j).qty_demand >= l_remaining_expired_tab_(i).unconsumed_qty_expired THEN
                        -- reduce the demand, for next outer iteration of l_remaining_expired_tab_
                        l_demand_date_qty_tab_(j).qty_demand := l_demand_date_qty_tab_(j).qty_demand - l_remaining_expired_tab_(i).unconsumed_qty_expired;
                        l_remaining_expired_tab_(i).unconsumed_qty_expired := 0;
                     ELSE                        
                        -- Reduce the unconsumed portion of qty expired
                        l_remaining_expired_tab_(i).unconsumed_qty_expired := l_remaining_expired_tab_(i).unconsumed_qty_expired - l_demand_date_qty_tab_(j).qty_demand;
                        -- and ... no more remaining actual demand to consume of.
                        l_demand_date_qty_tab_(j).qty_demand := 0;
                     END IF;
                  END IF;
               END IF;
            END LOOP;
         END IF;
         max_index_ := i;
      END LOOP;
   END IF;
   
   IF max_index_ > 0 THEN
      FOR i IN 1 .. max_index_ LOOP 
         remaining_expired_tab_(i).expiration_date       := l_remaining_expired_tab_(i).expiration_date;
         remaining_expired_tab_(i).activity_seq          := l_remaining_expired_tab_(i).activity_seq;
         remaining_expired_tab_(i).lot_batch_no          := l_remaining_expired_tab_(i).lot_batch_no;
         remaining_expired_tab_(i).qty_expired           := l_remaining_expired_tab_(i).qty_expired; -- FYI
         remaining_expired_tab_(i).remaining_qty_expired := l_remaining_expired_tab_(i).remaining_qty_expired;
      END LOOP;
   END IF; 
   
   RETURN remaining_expired_tab_;
END Get_Net_Expired_Date_And_Qty;

@UncheckedAccess
FUNCTION Calc_Detail_Planning (
   snapshot_id_                IN NUMBER,
   contract_                   IN VARCHAR2,
   part_no_                    IN VARCHAR2,
   usable_qty_                 IN NUMBER,
   available_qty_              IN NUMBER,
   dist_calendar_id_           IN VARCHAR2,
   manuf_calendar_id_          IN VARCHAR2,
   avail_balance_              IN NUMBER,
   avail_balance_not_res_      IN NUMBER,
   avail_balance_not_peg_      IN NUMBER,
   avail_balance_not_res_peg_  IN NUMBER,
   avail_balance_not_res_co_   IN NUMBER,
   picking_leadtime_           IN NUMBER,
   stop_analysis_date_         IN DATE,
   stop_analysis_date_exp_     IN DATE,
   site_date_                  IN DATE,
   date_required_              IN DATE,
   supply_qty_                 IN NUMBER,
   demand_qty_                 IN NUMBER,
   reserved_qty_               IN NUMBER,
   pegged_qty_                 IN NUMBER,
   order_no_                   IN VARCHAR2,
   line_no_                    IN VARCHAR2,
   rel_no_                     IN VARCHAR2,
   line_item_no_               IN NUMBER,
   order_supply_demand_type_   IN VARCHAR2,
   project_id_                 IN VARCHAR2 ) RETURN Planning_Arr PIPELINED  
IS 
   rec_                                Planning_Rec;
   first_row_date_required_            DATE;
   first_row_qty_demand_               NUMBER;
   first_row_order_no_                 VARCHAR2(40);
   first_row_line_no_                  VARCHAR2(12);
   first_row_rel_no_                   VARCHAR2(40);
   first_row_line_item_no_             NUMBER;
   first_row_project_id_               VARCHAR2(10);
   first_row_order_supply_demand_type_ VARCHAR2(4000);
   current_row_num_                    NUMBER;
   previous_supply_qty_sum_            NUMBER;
   previous_demand_qty_sum_            NUMBER;
   previous_only_demand_qty_sum_       NUMBER;
   prev_reserved_qty_for_demand_sum_   NUMBER;
   previous_res_peg_qty_reserved_sum_  NUMBER;
   previous_pegged_qty_sum_            NUMBER;
   
   CURSOR get_first_record IS
      SELECT date_required, qty_demand, order_no, line_no, rel_no, line_item_no, order_supply_demand_type, project_id
      FROM ORDER_SUPP_DEM_EXT_TMP_VIEW
      WHERE snapshot_id = snapshot_id_
      AND rownum = 1;
   
   CURSOR get_current_rownum IS
      SELECT sorted_row_no
      FROM (SELECT date_required, qty_demand, order_no, line_no, rel_no, line_item_no, order_supply_demand_type, project_id, rownum sorted_row_no
            FROM ORDER_SUPP_DEM_EXT_TMP_VIEW
            WHERE snapshot_id = snapshot_id_
            ORDER BY date_required, DECODE(qty_demand,0,0,1), order_no, line_no, rel_no, line_item_no, order_supply_demand_type, project_id ASC)
      WHERE  TRUNC(date_required) = TRUNC(date_required_)
      AND  qty_demand = demand_qty_
      AND  order_no = order_no_
      AND  (line_no = line_no_ OR line_no_ IS NULL)
      AND  (rel_no = rel_no_ OR rel_no_ IS NULL)
      AND  (line_item_no = line_item_no_ OR line_item_no_ IS NULL)
      AND  order_supply_demand_type = order_supply_demand_type_
      AND  project_id = project_id_;   
      
   CURSOR get_previous_record_sum IS
      SELECT SUM(qty_supply), SUM(qty_demand), SUM(only_qty_demand), SUM(qty_reserved_for_demand), SUM(res_peg_qty_reserved), SUM(local_qty_pegged)
      FROM (SELECT order_no, line_no, rel_no, line_item_no, order_supply_demand_type, qty_supply, qty_demand, project_id,
            CASE 
               WHEN qty_supply > 0 AND qty_demand > 0 THEN
                 0
               WHEN qty_supply = 0 AND qty_demand > 0 THEN
                 qty_demand   
               END only_qty_demand,
            CASE 
               WHEN qty_demand > 0 THEN
                 qty_reserved
               WHEN qty_demand = 0 THEN
                 0                
               END qty_reserved_for_demand,
            CASE 
               WHEN qty_supply > 0 THEN
                 0   
               WHEN qty_supply = 0 THEN
                 qty_reserved 
               END res_peg_qty_reserved,   
            CASE 
               WHEN qty_supply > 0 THEN
                 qty_pegged
               WHEN qty_supply = 0 THEN
                 qty_pegged * -1 
               END local_qty_pegged
            FROM ORDER_SUPP_DEM_EXT_TMP_VIEW
            WHERE snapshot_id = snapshot_id_ )
      WHERE rownum <= current_row_num_;   
 
BEGIN  
   OPEN get_first_record;
   FETCH get_first_record INTO first_row_date_required_, first_row_qty_demand_, first_row_order_no_, first_row_line_no_, first_row_rel_no_, first_row_line_item_no_, first_row_order_supply_demand_type_, first_row_project_id_;
   CLOSE get_first_record;
   
   IF (TRUNC(first_row_date_required_) = TRUNC(date_required_) AND
      (NVL(first_row_qty_demand_, 0) = NVL(demand_qty_, 0)) AND
      first_row_order_no_ = order_no_ AND
      NVL(first_row_line_no_, '') = NVL(line_no_, '') AND
      NVL(first_row_rel_no_, '') = NVL(rel_no_, '') AND
      NVL(first_row_line_item_no_, '') = NVL(line_item_no_, '') AND
      first_row_order_supply_demand_type_ = order_supply_demand_type_ AND
      first_row_project_id_ = project_id_) THEN
     
      rec_.projected_qty := usable_qty_ + supply_qty_ - demand_qty_;
      rec_.proj_not_res_qty := available_qty_ + supply_qty_ - (demand_qty_ - reserved_qty_);
      IF (supply_qty_ > 0) THEN
         rec_.proj_not_peg_qty := usable_qty_ + supply_qty_ - pegged_qty_;
         rec_.proj_not_res_or_peg_qty := available_qty_ + supply_qty_ - pegged_qty_;
      ELSE
         rec_.proj_not_peg_qty := usable_qty_ - (demand_qty_ - pegged_qty_);
         rec_.proj_not_res_or_peg_qty := available_qty_ - (demand_qty_ - reserved_qty_ - pegged_qty_);
      END IF;   
   ELSE
      OPEN get_current_rownum;
      FETCH get_current_rownum INTO current_row_num_;
      CLOSE get_current_rownum;
      
      OPEN get_previous_record_sum;
      FETCH get_previous_record_sum INTO previous_supply_qty_sum_, previous_demand_qty_sum_, previous_only_demand_qty_sum_, prev_reserved_qty_for_demand_sum_, previous_res_peg_qty_reserved_sum_, previous_pegged_qty_sum_;
      CLOSE get_previous_record_sum;
      
      rec_.projected_qty := usable_qty_ + previous_supply_qty_sum_ - previous_demand_qty_sum_;     
      rec_.proj_not_res_qty := available_qty_ + previous_supply_qty_sum_ - previous_demand_qty_sum_ + prev_reserved_qty_for_demand_sum_;
      rec_.proj_not_peg_qty := usable_qty_ + previous_supply_qty_sum_ - previous_only_demand_qty_sum_ - previous_pegged_qty_sum_;
      rec_.proj_not_res_or_peg_qty := available_qty_ + previous_supply_qty_sum_ - previous_only_demand_qty_sum_ + previous_res_peg_qty_reserved_sum_ - previous_pegged_qty_sum_;
   
   END IF;
   rec_.plannable_qty := Order_Supply_Demand_API.Get_Qty_Plannable_Fast_Tmp__(dist_calendar_id_,
                                                                               usable_qty_,
                                                                               avail_balance_,
                                                                               picking_leadtime_,
                                                                               TRUNC(date_required_),
                                                                               stop_analysis_date_,
                                                                               site_date_,
                                                                               'ORDER_SUPPLY_DEMAND_EXT',
                                                                               'FALSE',
                                                                               'FALSE',
                                                                               snapshot_id_);
   
   rec_.plan_not_res_qty := Order_Supply_Demand_API.Get_Qty_Plannable_Fast_Tmp__(dist_calendar_id_,
                                                                                 available_qty_,
                                                                                 avail_balance_not_res_,
                                                                                 picking_leadtime_,
                                                                                 TRUNC(date_required_),
                                                                                 stop_analysis_date_,
                                                                                 site_date_,
                                                                                 'ORDER_SUPPLY_DEMAND_EXT',
                                                                                 'TRUE',
                                                                                 'FALSE',
                                                                                 snapshot_id_);
                                                                                    
   rec_.plan_not_peg_qty := Order_Supply_Demand_API.Get_Qty_Plannable_Fast_Tmp__(dist_calendar_id_,
                                                                                 usable_qty_,
                                                                                 avail_balance_not_peg_,
                                                                                 picking_leadtime_,
                                                                                 TRUNC(date_required_),
                                                                                 stop_analysis_date_,
                                                                                 site_date_,
                                                                                 'ORDER_SUPPLY_DEMAND_EXT',
                                                                                 'FALSE',
                                                                                 'TRUE',
                                                                                 snapshot_id_);
   
   rec_.plan_not_res_or_peg_qty := Order_Supply_Demand_API.Get_Qty_Plannable_Fast_Tmp__(dist_calendar_id_,
                                                                                      available_qty_,
                                                                                      avail_balance_not_res_peg_,
                                                                                      picking_leadtime_,
                                                                                      TRUNC(date_required_),
                                                                                      stop_analysis_date_,
                                                                                      site_date_,
                                                                                      'ORDER_SUPPLY_DEMAND_EXT',
                                                                                      'TRUE',
                                                                                      'TRUE',
                                                                                      snapshot_id_);
   rec_.co_plannable_qty := Order_Supply_Demand_API.Get_Qty_Plannable_Fast_Tmp__(dist_calendar_id_,
                                                                                 available_qty_,
                                                                                 avail_balance_not_res_co_,
                                                                                 picking_leadtime_,
                                                                                 TRUNC(date_required_),
                                                                                 stop_analysis_date_exp_,
                                                                                 site_date_,
                                                                                 'CUSTORD_SUPPLY_DEMAND',
                                                                                 'TRUE',
                                                                                 'FALSE',
                                                                                 snapshot_id_);

   PIPE ROW (rec_);
END Calc_Detail_Planning;

@UncheckedAccess
FUNCTION Calc_Sum_Detail_Planning (
   snapshot_id_                    IN NUMBER,
   contract_                       IN VARCHAR2,
   part_no_                        IN VARCHAR2,
   usable_qty_                     IN NUMBER,
   available_qty_                  IN NUMBER,
   dist_calendar_id_               IN VARCHAR2,
   manuf_calendar_id_              IN VARCHAR2,
   avail_balance_                  IN NUMBER,
   avail_balance_not_res_          IN NUMBER,
   avail_balance_not_peg_          IN NUMBER,
   avail_balance_not_res_peg_      IN NUMBER,
   avail_balance_not_res_co_       IN NUMBER,
   picking_leadtime_               IN NUMBER,
   stop_analysis_date_             IN DATE,
   stop_analysis_date_exp_         IN DATE,
   site_date_                      IN DATE,
   date_required_                  IN DATE,
   supply_qty_                     IN NUMBER,
   demand_qty_                     IN NUMBER,
   reserved_qty_                   IN NUMBER ) RETURN Planning_Arr PIPELINED  
IS 
   rec_                       Planning_Rec;
   first_date_required_       DATE;
   previous_supply_qty_sum_   NUMBER;
   previous_demand_qty_sum_   NUMBER;
   previous_reserved_qty_sum_ NUMBER;
   previous_pegged_qty_       NUMBER;
   previous_pegged_qty_sum_   NUMBER := 0;
   pegged_qty_                NUMBER;
   
   CURSOR get_first_record IS
      SELECT date_required
      FROM ORDER_SUPPLY_DEMAND_SUM_PROJ
      WHERE snapshot_id = snapshot_id_  
      AND   rownum = 1;     
       
   CURSOR get_previous_record_sum IS
      SELECT SUM(supply_qty), SUM(demand_qty), SUM(reserved_qty)
      FROM ORDER_SUPPLY_DEMAND_SUM_PROJ
      WHERE snapshot_id = snapshot_id_
      AND  TRUNC(date_required) <= TRUNC(date_required_);
      
   CURSOR get_previous_records IS
      SELECT date_required
      FROM ORDER_SUPPLY_DEMAND_SUM_PROJ
      WHERE snapshot_id = snapshot_id_
      AND TRUNC(date_required) < TRUNC(date_required_);
    
BEGIN  
   OPEN get_first_record;
   FETCH get_first_record INTO first_date_required_;
   CLOSE get_first_record;
   pegged_qty_ := Order_Supply_Demand_API.Get_Sum_Pegged_Per_Date__(snapshot_id_, date_required_);
   
   IF first_date_required_ = date_required_ THEN
      rec_.projected_qty := usable_qty_ + supply_qty_ - demand_qty_;
      rec_.proj_not_res_qty := available_qty_ + supply_qty_ - (demand_qty_ - reserved_qty_);
      rec_.proj_not_peg_qty := usable_qty_ + supply_qty_ - demand_qty_ - pegged_qty_;
      rec_.proj_not_res_or_peg_qty := ((available_qty_ + supply_qty_) - (demand_qty_ - reserved_qty_)) - pegged_qty_;
   ELSE
      OPEN get_previous_record_sum;
      FETCH get_previous_record_sum INTO previous_supply_qty_sum_, previous_demand_qty_sum_, previous_reserved_qty_sum_;
      CLOSE get_previous_record_sum;     
      
      rec_.projected_qty := usable_qty_ + previous_supply_qty_sum_ - previous_demand_qty_sum_;
      rec_.proj_not_res_qty := available_qty_ + previous_supply_qty_sum_ - (previous_demand_qty_sum_ - previous_reserved_qty_sum_);
      FOR pre_date_rec_ IN get_previous_records LOOP
         previous_pegged_qty_ := Order_Supply_Demand_API.Get_Sum_Pegged_Per_Date__(snapshot_id_, pre_date_rec_.date_required);
         previous_pegged_qty_sum_ := previous_pegged_qty_sum_ + NVL(previous_pegged_qty_, 0);
      END LOOP;   
      rec_.proj_not_peg_qty := usable_qty_ + previous_supply_qty_sum_ - previous_demand_qty_sum_ - previous_pegged_qty_sum_;
      rec_.proj_not_res_or_peg_qty := available_qty_ + previous_supply_qty_sum_ - previous_demand_qty_sum_ + previous_reserved_qty_sum_ - previous_pegged_qty_sum_;
   END IF;
   
   rec_.plannable_qty := Order_Supply_Demand_API.Get_Qty_Plannable_Fast_Tmp__(dist_calendar_id_,
                                                                              usable_qty_,
                                                                              avail_balance_,
                                                                              picking_leadtime_,
                                                                              TRUNC(date_required_),
                                                                              stop_analysis_date_,
                                                                              site_date_,
                                                                              'ORDER_SUPPLY_DEMAND_EXT',
                                                                              'FALSE',
                                                                              'FALSE',
                                                                              snapshot_id_);
   
   rec_.plan_not_res_qty := Order_Supply_Demand_API.Get_Qty_Plannable_Fast_Tmp__(dist_calendar_id_,
                                                                                 available_qty_,
                                                                                 avail_balance_not_res_,
                                                                                 picking_leadtime_,
                                                                                 TRUNC(date_required_),
                                                                                 stop_analysis_date_,
                                                                                 site_date_,
                                                                                 'ORDER_SUPPLY_DEMAND_EXT',
                                                                                 'TRUE',
                                                                                 'FALSE',
                                                                                 snapshot_id_);
  
   rec_.plan_not_peg_qty := ORDER_SUPPLY_DEMAND_API.Get_Qty_Plannable_Fast_Tmp__(dist_calendar_id_,
                                                                                 usable_qty_,
                                                                                 avail_balance_not_peg_,
                                                                                 picking_leadtime_,
                                                                                 TRUNC(date_required_),
                                                                                 stop_analysis_date_,
                                                                                 site_date_,
                                                                                 'ORDER_SUPPLY_DEMAND_EXT',
                                                                                 'FALSE',
                                                                                 'TRUE',
                                                                                 snapshot_id_);                                                                                 
  
   rec_.plan_not_res_or_peg_qty := ORDER_SUPPLY_DEMAND_API.Get_Qty_Plannable_Fast_Tmp__(dist_calendar_id_,
                                                                                      available_qty_,
                                                                                      avail_balance_not_res_peg_,
                                                                                      picking_leadtime_,
                                                                                      TRUNC(date_required_),
                                                                                      stop_analysis_date_,
                                                                                      site_date_,
                                                                                      'ORDER_SUPPLY_DEMAND_EXT',
                                                                                      'TRUE',
                                                                                      'TRUE',
                                                                                      snapshot_id_);
   
   rec_.co_plannable_qty := ORDER_SUPPLY_DEMAND_API.Get_Qty_Plannable_Fast_Tmp__(dist_calendar_id_,
                                                                                 available_qty_,
                                                                                 avail_balance_not_res_co_,
                                                                                 picking_leadtime_,
                                                                                 TRUNC(date_required_),
                                                                                 stop_analysis_date_exp_,
                                                                                 site_date_,
                                                                                 'CUSTORD_SUPPLY_DEMAND',
                                                                                 'TRUE',
                                                                                 'FALSE',
                                                                                 snapshot_id_);
   PIPE ROW (rec_);
END Calc_Sum_Detail_Planning;

@UncheckedAccess
FUNCTION Calc_Procurement_Planning (
   snapshot_id_                    IN NUMBER,
   contract_                       IN VARCHAR2,
   part_no_                        IN VARCHAR2,
   usable_qty_                     IN NUMBER,
   available_qty_                  IN NUMBER,
   dist_calendar_id_               IN VARCHAR2,
   manuf_calendar_id_              IN VARCHAR2,
   avail_balance_proc_             IN NUMBER,
   avail_balance_not_res_proc_     IN NUMBER,
   avail_balance_not_peg_proc_     IN NUMBER,
   avail_balance_not_res_peg_proc_ IN NUMBER,
   avail_balance_co_               IN NUMBER,
   picking_leadtime_               IN NUMBER,
   stop_analysis_date_             IN DATE,
   stop_analysis_date_exp_         IN DATE,
   site_date_                      IN DATE,
   date_required_                  IN DATE,
   supply_qty_                     IN NUMBER,
   demand_qty_                     IN NUMBER,
   reserved_qty_                   IN NUMBER,
   pegged_qty_                     IN NUMBER,
   order_no_                       IN VARCHAR2,
   line_no_                        IN VARCHAR2,
   rel_no_                         IN VARCHAR2,
   line_item_no_                   IN NUMBER,
   order_supply_demand_type_       IN VARCHAR2 ) RETURN Planning_Arr PIPELINED  
IS 
   rec_                       Planning_Rec;
   first_row_date_required_   DATE;
   first_row_qty_demand_      NUMBER;
   first_row_order_no_        VARCHAR2(40);
   first_row_line_no_         VARCHAR2(12);
   first_row_rel_no_          VARCHAR2(40);
   first_row_line_item_no_    NUMBER;
   first_row_order_supply_demand_type_ VARCHAR2(4000);
   current_row_num_           NUMBER;
   previous_supply_qty_sum_   NUMBER;
   previous_demand_qty_sum_   NUMBER;
   previous_reserved_qty_sum_ NUMBER;
   previous_pegged_qty_sum_   NUMBER;
   
   CURSOR get_first_record IS
      SELECT date_required, qty_demand, order_no, line_no, rel_no, line_item_no, order_supply_demand_type
      FROM ORDER_SUPPLY_DEMAND_TMP_VIEW
      WHERE snapshot_id = snapshot_id_
      AND rownum = 1;
         
   CURSOR get_current_rownum IS
      SELECT sorted_row_no
      FROM (SELECT date_required, qty_demand, order_no, line_no, rel_no, line_item_no, order_supply_demand_type, rownum sorted_row_no
            FROM ORDER_SUPPLY_DEMAND_TMP_VIEW
            WHERE snapshot_id = snapshot_id_
            ORDER BY date_required, DECODE(qty_demand,0,0,1), order_no, line_no, rel_no, line_item_no, order_supply_demand_type ASC)
      WHERE  TRUNC(date_required) = TRUNC(date_required_)
      AND  qty_demand = demand_qty_
      AND  order_no = order_no_
      AND  (line_no = line_no_ OR line_no_ IS NULL)
      AND  (rel_no = rel_no_ OR rel_no_ IS NULL)
      AND  (line_item_no = line_item_no_ OR line_item_no_ IS NULL)
      AND  order_supply_demand_type = order_supply_demand_type_;  
      
   CURSOR get_previous_record_sum IS
      SELECT SUM(qty_supply), SUM(qty_demand), SUM(local_qty_reserved), SUM(local_qty_pegged)
      FROM (SELECT date_required, order_no, line_no, rel_no, line_item_no, order_supply_demand_type, qty_supply, qty_demand,
            CASE 
               WHEN qty_supply > 0 THEN
                 0
               WHEN qty_supply = 0 THEN
                 qty_reserved 
               END local_qty_reserved,
            CASE 
               WHEN qty_supply > 0 THEN
                 qty_pegged
               WHEN qty_supply = 0 THEN
                 qty_pegged * -1 
               END local_qty_pegged 
            FROM ORDER_SUPPLY_DEMAND_TMP_VIEW
            WHERE snapshot_id = snapshot_id_)         
      WHERE rownum <= current_row_num_;   
 
BEGIN  
   OPEN get_first_record;
   FETCH get_first_record INTO first_row_date_required_, first_row_qty_demand_, first_row_order_no_, first_row_line_no_, first_row_rel_no_, first_row_line_item_no_, first_row_order_supply_demand_type_;
   CLOSE get_first_record;
 
   IF (TRUNC(first_row_date_required_) = TRUNC(date_required_) AND
      (NVL(first_row_qty_demand_, 0) = NVL(demand_qty_, 0)) AND
      first_row_order_no_ = order_no_ AND
      NVL(first_row_line_no_, '') = NVL(line_no_, '') AND
      NVL(first_row_rel_no_, '') = NVL(rel_no_, '') AND
      NVL(first_row_line_item_no_, '') = NVL(line_item_no_, '') AND
      first_row_order_supply_demand_type_ = order_supply_demand_type_) THEN
      
      rec_.projected_qty := usable_qty_ + supply_qty_ - demand_qty_;
      rec_.proj_not_res_qty := available_qty_ + supply_qty_ - (demand_qty_ - reserved_qty_);
      rec_.proj_not_peg_qty := usable_qty_ + supply_qty_ - demand_qty_ - pegged_qty_;
      rec_.proj_not_res_or_peg_qty := available_qty_ + supply_qty_ - demand_qty_ + reserved_qty_ - pegged_qty_;
   ELSE
      OPEN get_current_rownum;
      FETCH get_current_rownum INTO current_row_num_;
      CLOSE get_current_rownum;
   
      OPEN get_previous_record_sum;
      FETCH get_previous_record_sum INTO previous_supply_qty_sum_, previous_demand_qty_sum_, previous_reserved_qty_sum_, previous_pegged_qty_sum_;
      CLOSE get_previous_record_sum;     
      rec_.projected_qty := usable_qty_ + previous_supply_qty_sum_ - previous_demand_qty_sum_; 
      rec_.proj_not_res_qty := available_qty_ + previous_supply_qty_sum_ - (previous_demand_qty_sum_ - previous_reserved_qty_sum_);
      rec_.proj_not_peg_qty := usable_qty_ + previous_supply_qty_sum_ - previous_demand_qty_sum_ - previous_pegged_qty_sum_;
      rec_.proj_not_res_or_peg_qty := available_qty_ + previous_supply_qty_sum_ - previous_demand_qty_sum_ + previous_reserved_qty_sum_ - previous_pegged_qty_sum_;
   END IF; 
   rec_.co_plannable_qty := Order_Supply_Demand_API.Get_Qty_Plannable_Fast_Tmp__(dist_calendar_id_, 
                                                                                 usable_qty_, 
                                                                                 avail_balance_co_, 
                                                                                 picking_leadtime_, 
                                                                                 TRUNC(date_required_),
                                                                                 stop_analysis_date_exp_, 
                                                                                 site_date_, 
                                                                                 'CUSTORD_SUPPLY_DEMAND', 
                                                                                 'FALSE', 
                                                                                 'FALSE', 
                                                                                 snapshot_id_);

   
   PIPE ROW (rec_);
END Calc_Procurement_Planning;

@UncheckedAccess
FUNCTION Calc_Sum_Procurement_Planning (
   snapshot_id_                    IN NUMBER,
   contract_                       IN VARCHAR2,
   part_no_                        IN VARCHAR2,
   usable_qty_                     IN NUMBER,
   available_qty_                  IN NUMBER,
   dist_calendar_id_               IN VARCHAR2,
   manuf_calendar_id_              IN VARCHAR2,
   avail_balance_proc_             IN NUMBER,
   avail_balance_not_res_proc_     IN NUMBER,
   avail_balance_not_peg_proc_     IN NUMBER,
   avail_balance_not_res_peg_proc_ IN NUMBER,
   avail_balance_co_               IN NUMBER,
   picking_leadtime_               IN NUMBER,
   stop_analysis_date_             IN DATE,
   stop_analysis_date_exp_         IN DATE,
   site_date_                      IN DATE,
   date_required_                  IN DATE,
   supply_qty_                     IN NUMBER,
   demand_qty_                     IN NUMBER,
   reserved_qty_                   IN NUMBER ) RETURN Planning_Arr PIPELINED  
IS 
   rec_                       Planning_Rec;
   first_date_required_       DATE;
   previous_supply_qty_sum_   NUMBER;
   previous_demand_qty_sum_   NUMBER;
   previous_reserved_qty_sum_ NUMBER;
   previous_pegged_qty_       NUMBER;
   previous_pegged_qty_sum_   NUMBER := 0;
   pegged_qty_                NUMBER;
   
   CURSOR get_first_record IS
      SELECT date_required
      FROM ORDER_SUPPLY_DEMAND_SUM
      WHERE snapshot_id = snapshot_id_
      AND rownum = 1;     
    
   CURSOR get_previous_record_sum IS
      SELECT SUM(supply_qty), SUM(demand_qty), SUM(reserved_qty)
      FROM ORDER_SUPPLY_DEMAND_SUM
      WHERE snapshot_id = snapshot_id_
      AND  TRUNC(date_required) <= TRUNC(date_required_);
      
   CURSOR get_previous_records IS
      SELECT date_required   
      FROM ORDER_SUPPLY_DEMAND_SUM
      WHERE snapshot_id = snapshot_id_ 
      AND TRUNC(date_required) < TRUNC(date_required_);
   
BEGIN  
   OPEN get_first_record;
   FETCH get_first_record INTO first_date_required_;
   CLOSE get_first_record;
   pegged_qty_ := Order_Supply_Demand_API.Get_Sum_Pegged_Per_Date__(snapshot_id_, date_required_);
   
   IF first_date_required_ = date_required_ THEN
      rec_.projected_qty := usable_qty_ + supply_qty_ - demand_qty_;
      rec_.proj_not_res_qty := available_qty_ + supply_qty_ - (demand_qty_ - reserved_qty_);
      rec_.proj_not_peg_qty := usable_qty_ + supply_qty_ - demand_qty_ - pegged_qty_;
      rec_.proj_not_res_or_peg_qty := ((available_qty_ + supply_qty_) - (demand_qty_ - reserved_qty_)) - pegged_qty_;
   ELSE
      OPEN get_previous_record_sum;
      FETCH get_previous_record_sum INTO previous_supply_qty_sum_, previous_demand_qty_sum_, previous_reserved_qty_sum_;
      CLOSE get_previous_record_sum;     
      
      rec_.projected_qty := usable_qty_ + previous_supply_qty_sum_ - previous_demand_qty_sum_;
      rec_.proj_not_res_qty := available_qty_ + previous_supply_qty_sum_ - (previous_demand_qty_sum_ - previous_reserved_qty_sum_);
      FOR pre_date_rec_ IN get_previous_records LOOP
         previous_pegged_qty_ := Order_Supply_Demand_API.Get_Sum_Pegged_Per_Date__(snapshot_id_, pre_date_rec_.date_required);
         previous_pegged_qty_sum_ := previous_pegged_qty_sum_ + NVL(previous_pegged_qty_, 0);
      END LOOP;   
      rec_.proj_not_peg_qty := usable_qty_ + previous_supply_qty_sum_ - previous_demand_qty_sum_ - previous_pegged_qty_sum_;
      rec_.proj_not_res_or_peg_qty := available_qty_ + previous_supply_qty_sum_ - previous_demand_qty_sum_ + previous_reserved_qty_sum_ - previous_pegged_qty_sum_;
   END IF;
   rec_.plannable_qty := Order_Supply_Demand_API.Get_Qty_Plannable_Fast_Tmp__(dist_calendar_id_, 
                                                                              usable_qty_, 
                                                                              avail_balance_proc_, 
                                                                              picking_leadtime_, 
                                                                              TRUNC(date_required_),
                                                                              stop_analysis_date_, 
                                                                              site_date_, 
                                                                              'ORDER_SUPPLY_DEMAND', 
                                                                              'FALSE', 
                                                                              'FALSE', 
                                                                              snapshot_id_);
   rec_.plan_not_res_qty := Order_Supply_Demand_API.Get_Qty_Plannable_Fast_Tmp__(dist_calendar_id_, 
                                                                                 available_qty_, 
                                                                                 avail_balance_not_res_proc_, 
                                                                                 picking_leadtime_, 
                                                                                 TRUNC(date_required_),
                                                                                 stop_analysis_date_, 
                                                                                 site_date_, 
                                                                                 'ORDER_SUPPLY_DEMAND', 
                                                                                 'TRUE', 
                                                                                 'FALSE', 
                                                                                 snapshot_id_);
   rec_.plan_not_peg_qty := Order_Supply_Demand_API.Get_Qty_Plannable_Fast_Tmp__(dist_calendar_id_, 
                                                                                 usable_qty_, 
                                                                                 avail_balance_not_peg_proc_, 
                                                                                 picking_leadtime_, 
                                                                                 TRUNC(date_required_),
                                                                                 stop_analysis_date_, 
                                                                                 site_date_, 
                                                                                 'ORDER_SUPPLY_DEMAND', 
                                                                                 'FALSE', 
                                                                                 'TRUE', 
                                                                                 snapshot_id_);
  rec_.plan_not_res_or_peg_qty := Order_Supply_Demand_API.Get_Qty_Plannable_Fast_Tmp__(dist_calendar_id_, 
                                                                                    available_qty_, 
                                                                                    avail_balance_not_res_peg_proc_, 
                                                                                    picking_leadtime_, 
                                                                                    TRUNC(date_required_),
                                                                                    stop_analysis_date_, 
                                                                                    site_date_, 
                                                                                    'ORDER_SUPPLY_DEMAND', 
                                                                                    'TRUE', 
                                                                                    'TRUE', 
                                                                                    snapshot_id_);
   rec_.co_plannable_qty := Order_Supply_Demand_API.Get_Qty_Plannable_Fast_Tmp__(dist_calendar_id_, 
                                                                                 usable_qty_, 
                                                                                 avail_balance_co_, 
                                                                                 picking_leadtime_, 
                                                                                 TRUNC(date_required_),
                                                                                 stop_analysis_date_exp_, 
                                                                                 site_date_, 
                                                                                 'CUSTORD_SUPPLY_DEMAND', 
                                                                                 'FALSE', 
                                                                                 'FALSE', 
                                                                                 snapshot_id_);
   
   PIPE ROW (rec_);
END Calc_Sum_Procurement_Planning;

@UncheckedAccess
FUNCTION Calc_Plannable_Per_Part_Detail (
   snapshot_id_                IN NUMBER,
   contract_                   IN VARCHAR2,
   part_no_                    IN VARCHAR2,
   available_qty_              IN NUMBER,
   dist_calendar_id_           IN VARCHAR2,
   manuf_calendar_id_          IN VARCHAR2,
   avail_balance_not_res_co_   IN NUMBER,
   picking_leadtime_           IN NUMBER,
   stop_analysis_date_exp_     IN DATE,
   site_date_                  IN DATE,
   date_required_              IN DATE,
   supply_qty_                 IN NUMBER,
   demand_qty_                 IN NUMBER,
   reserved_qty_               IN NUMBER,
   sort_order_                 IN NUMBER,
   order_no_                   IN VARCHAR2,
   line_no_                    IN VARCHAR2,
   rel_no_                     IN VARCHAR2,
   line_item_no_               IN NUMBER,
   order_supply_demand_type_   IN VARCHAR2,
   project_id_                 IN VARCHAR2 ) RETURN Plannable_Per_Part_Arr PIPELINED  
IS 
   rec_                       Plannable_Per_Part_Rec;
   first_row_date_required_   DATE;
   first_row_sort_order_      NUMBER;
   first_row_order_no_        VARCHAR2(40);
   first_row_line_no_         VARCHAR2(12);
   first_row_rel_no_          VARCHAR2(40);
   first_row_line_item_no_    NUMBER;
   first_row_order_supply_demand_type_ VARCHAR2(4000);
   first_row_project_id_               VARCHAR2(10);
   current_row_num_           NUMBER;
   previous_supply_qty_sum_   NUMBER;
   previous_demand_qty_sum_   NUMBER;
   previous_reserved_qty_sum_ NUMBER;
   
   CURSOR get_first_record IS
      SELECT date_required, sort_order, order_no, line_no, rel_no, line_item_no, order_supply_demand_type, project_id
      FROM CUSTORD_SUPPLY_DEMAND_TMP_VIEW
      WHERE snapshot_id = snapshot_id_
      AND rownum = 1;
         
   CURSOR get_current_rownum IS
      SELECT sorted_row_no
      FROM (SELECT date_required, sort_order, order_no, line_no, rel_no, line_item_no, order_supply_demand_type, project_id, rownum sorted_row_no
            FROM CUSTORD_SUPPLY_DEMAND_TMP_VIEW
            WHERE snapshot_id = snapshot_id_
            ORDER BY date_required, sort_order, order_no, line_no, rel_no, line_item_no, order_supply_demand_type, project_id ASC)
      WHERE  TRUNC(date_required) = TRUNC(date_required_)
      AND  sort_order = sort_order_
      AND  order_no = order_no_
      AND  (line_no = line_no_ OR line_no_ IS NULL)
      AND  (rel_no = rel_no_ OR rel_no_ IS NULL)
      AND  (line_item_no = line_item_no_ OR line_item_no_ IS NULL)
      AND  order_supply_demand_type = order_supply_demand_type_
      AND  project_id = project_id_;
        
   CURSOR get_previous_record_sum IS
      SELECT SUM(qty_supply), SUM(qty_demand), SUM(qty_reserved)
      FROM (SELECT date_required, sort_order, order_no, line_no, rel_no, line_item_no, order_supply_demand_type, qty_supply, qty_demand, qty_reserved
            FROM CUSTORD_SUPPLY_DEMAND_TMP_VIEW
            WHERE snapshot_id = snapshot_id_         
            ORDER BY date_required, sort_order, order_no, line_no, rel_no, line_item_no, order_supply_demand_type ASC)
      WHERE rownum <= current_row_num_;   
 
BEGIN
   OPEN get_first_record;
   FETCH get_first_record INTO first_row_date_required_, first_row_sort_order_, first_row_order_no_, first_row_line_no_, first_row_rel_no_, first_row_line_item_no_, first_row_order_supply_demand_type_, first_row_project_id_;
   CLOSE get_first_record;
   
   IF (TRUNC(first_row_date_required_) = TRUNC(date_required_) AND
      first_row_sort_order_ = sort_order_ AND
      first_row_order_no_ = order_no_ AND
      NVL(first_row_line_no_, '') = NVL(line_no_, '') AND
      NVL(first_row_rel_no_, '') = NVL(rel_no_, '') AND
      NVL(first_row_line_item_no_, '') = NVL(line_item_no_, '') AND
      first_row_order_supply_demand_type_ = order_supply_demand_type_ AND
      first_row_project_id_ = project_id_) THEN 
  
      rec_.projected_qty := available_qty_ + supply_qty_ - (demand_qty_ - reserved_qty_);
   ELSE
      OPEN get_current_rownum;
      FETCH get_current_rownum INTO current_row_num_;
      CLOSE get_current_rownum;
     
      OPEN get_previous_record_sum;
      FETCH get_previous_record_sum INTO previous_supply_qty_sum_, previous_demand_qty_sum_, previous_reserved_qty_sum_;
      CLOSE get_previous_record_sum;     
      
      rec_.projected_qty := available_qty_ + previous_supply_qty_sum_ - (previous_demand_qty_sum_ - previous_reserved_qty_sum_);
   END IF;   
   rec_.co_plannable_qty := Order_Supply_Demand_API.Get_Qty_Plannable_Fast_Tmp__(dist_calendar_id_, 
                                                                                 available_qty_, 
                                                                                 avail_balance_not_res_co_, 
                                                                                 picking_leadtime_, 
                                                                                 TRUNC(date_required_),
                                                                                 stop_analysis_date_exp_, 
                                                                                 site_date_, 
                                                                                 'CUSTORD_SUPPLY_DEMAND', 
                                                                                 'TRUE', 
                                                                                 'FALSE', 
                                                                                 snapshot_id_);

   
   PIPE ROW (rec_);
END Calc_Plannable_Per_Part_Detail;

@UncheckedAccess
FUNCTION Calc_Plannable_Per_Part_Sum (
   snapshot_id_                IN NUMBER,
   contract_                   IN VARCHAR2,
   part_no_                    IN VARCHAR2,
   available_qty_              IN NUMBER,
   dist_calendar_id_           IN VARCHAR2,
   manuf_calendar_id_          IN VARCHAR2,
   avail_balance_not_res_co_   IN NUMBER,
   picking_leadtime_           IN NUMBER,
   stop_analysis_date_exp_     IN DATE,
   site_date_                  IN DATE,
   date_required_              IN DATE,
   supply_qty_                 IN NUMBER,
   demand_qty_                 IN NUMBER,
   reserved_qty_               IN NUMBER ) RETURN Plannable_Per_Part_Arr PIPELINED  
IS 
   rec_                       Plannable_Per_Part_Rec;
   previous_supply_qty_sum_   NUMBER;
   previous_demand_qty_sum_   NUMBER;
   previous_reserved_qty_sum_ NUMBER;
   first_date_required_     DATE;
   
   CURSOR get_first_record IS
      SELECT date_required   
      FROM CUSTORD_SUPPLY_DEMAND_SUM
      WHERE snapshot_id = snapshot_id_
      AND rownum = 1;   
       
   CURSOR get_previous_record_sum IS
      SELECT SUM(supply_qty), SUM(demand_qty), SUM(reserved_qty)
      FROM CUSTORD_SUPPLY_DEMAND_SUM
      WHERE snapshot_id = snapshot_id_
      AND  TRUNC(date_required) <= TRUNC(date_required_);

BEGIN 
   OPEN get_first_record;
   FETCH get_first_record INTO first_date_required_;
   CLOSE get_first_record;
     
   IF first_date_required_ = date_required_ THEN
      rec_.projected_qty := available_qty_ + supply_qty_ - (demand_qty_ - reserved_qty_);
   ELSE
      OPEN get_previous_record_sum;
      FETCH get_previous_record_sum INTO previous_supply_qty_sum_, previous_demand_qty_sum_, previous_reserved_qty_sum_;
      CLOSE get_previous_record_sum;     
      
      rec_.projected_qty := available_qty_ + previous_supply_qty_sum_ - (previous_demand_qty_sum_ - previous_reserved_qty_sum_);
   END IF;   
   rec_.co_plannable_qty := Order_Supply_Demand_API.Get_Qty_Plannable_Fast_Tmp__(dist_calendar_id_, 
                                                                                 available_qty_, 
                                                                                 avail_balance_not_res_co_, 
                                                                                 picking_leadtime_, 
                                                                                 TRUNC(date_required_),
                                                                                 stop_analysis_date_exp_, 
                                                                                 site_date_, 
                                                                                 'CUSTORD_SUPPLY_DEMAND', 
                                                                                 'TRUE', 
                                                                                 'FALSE', 
                                                                                 snapshot_id_);

   
   PIPE ROW (rec_);
END ;
