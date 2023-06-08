-----------------------------------------------------------------------------
--
--  Logical unit: InventoryPartPlanning
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ----------------------------------------------------------
--  210608  AwWelk  SC21R2-1447, Corrected the missing dynamic dependency check to invpla in Check_Update___().
--  210512  JiThlk  SCZ-14214, Change API for Get_Ipr_Active_Db to Site_Ipr_Info_API.
--  210329  WaSalk  Bug 158394 (SCZ-14010), Modified Check_Update___() to modify old_lot_size, old_order_point_qty, old_safety_stock if only corresponding new values get change.
--  210303  AwWelk  SC2020R1-6780, Modified Modify_Order_Point_Parameters() to only do the rounding for safety stock for parts having planning method B and
--  210303          order point model MANUAL or LEAD TIME DRIVEN. 
--  201027  JiThlk  SC2020R1-10720, reset Latest_Plan_Activity_Time to sysdate when safety_stock,order_point_qty or Lot size is changed.
--  201006  LEPESE  SC2020R1-6780, applied QtyCalcRounding to safety_stock and lot_size in Modify_Order_Point_Parameters.
--  200122  PamPlk  Bug 151926(SCZ-8684), Modified Check_Update___() in order to capture the proper planning methods and converted the error message to an info message.
--  190925  SURBLK  Added Raise_Pred_Negative_Error___ to handle error messages and avoid code duplication.
--  170929  SBalLK  Bug 138005, Modified Check_Update___() method to set old_lot_size, old_order_point_qty and old_safety_stock values when lot_size, order_point_qty or safety_stock attribute changed.
--  170823  AwWelk  STRSC-11632, Modified Get_Next_Order_Date___() to fetch the next order date, similar to the way latest order date is calculated in
--  170823          purchase order line.
--  170809  ErRalk  Bug 135979,Modified the ORDREQTYPESERROR error message to have a full stop at the end in Validate_Planning_Method___.
--  170606  AwWelk  STRSC-8620, Modified Insert___(), Update___(), Slow_Movers_Or_Croston___(), Auto_Update_Order_Point___(), Auto_Update_Safety_Stock___(),
--  170606          Auto_Update_Lot_Size___(), Get_Demand_Model_Db___(), Get_Historical_Daily_Demand___() and Check_Update___() to run loigc depending on
--  170606          site ipr activated or not. Added Handle_Site_Ipr_Active_Change() to handle site IPR_ACTIVE attribute change.
--  170526  AwWelk  STRSC-8620, Modified a cursor in Get_Next_Order_Date___() to only consider IPR active sites. Modified Update___() to set the invpla_info object latest
--  170526          plan activity time if the site is IPR active. Also reverted the changes made on STRSC-7084 since it was decided to take back the previous way of 
--  170526          calculating the next order date.
--  170427  AwWelk  STRSC-7084, Modified Get_Next_Order_Date___() to match with IPR excel sheet calculations.
--  170209  Maeelk  LIM-5375, Added default value of safety_lead_time to Check_Insert___.
--  161216  AwWelk  STRSC-5084, Modified the Insert___,Update___ methods to create inventory_part_invpla_info objects for planning methods 'A', 'B', 'D', 'E', 'F', 'G', 'M' .
--  161214  AwWelk  STRSC-4701, Modified Modify_Order_Point_Parameters to round the order point quantity according to the quantity calc rounding figure.
--  161208  SHEWLK  STRMF-8180, Added new procedure Modify_Safety_Lead_Time to update from Supply Chain Matrix.
--  161121  NISMLK  STRMF-8227, Added new parameter safety_lead_time_ to method Create_New_Part_Planning.
--  161009  RasDlk  Bug 131716, Modified Modify_Stockfactors() by passing 'ADD' for the action_ and TRUE for the ignore_unit_type_ when calculating the order point quantity
--  161009          so that it will be rounded upwards if the initial value rounded to "Qty Calc Rounding + 2" number of decimals is greater than zero.
--  160623  ManWlk  STRMF-5091, Modified Update___() to remove ddmrp logs when changing planning method from H to a different one.
--  160519  ManWlk  STRMF-4225, Modified Update___() and Insert___() to create DdmrpBufferPartAttrib record when setting planning method to 'H'.
--  160511  NISMLK  STRMF-4227, Modified Validate_Planning_Method___() and Check_Update___() to introduce validations related to H Part.  
--  160412  RaKalk  MATP-2090, Added Column Sched_Capacity.
--  151207  LaThlk  Bug 124427, Restructured two overloading procedures Create_New_Part_Planning() using New___() to be more efficient.
--  151020  JeLise  LIM-3893, Removed check on location type DELIVERY in Check_Update___.
--  151012  AwWelk  STRSC-78 Merge Bug 124749. Added new parameter vendor_no to the methods Get_Next_Order_Date___(), Next_Order_Analysis_Slow___(), Next_Order_Analysis_Others___(), 
--  151012          Make_Next_Order_Analysis(), Get_Days_To_Next_Order_Date() and Get_Next_Order_Date().
--  150818  AwWelk  GEN-673, Added Get_Next_Order_Date___ and Modified Next_Order_Analysis_Slow___, Next_Order_Analysis_Others___ to use that method.
--  141122  AwWelk  GEN-232, Modified Get_From_Abc_Frequency_Life___() to have a recursive call to itself and removed Get_From_Abc_Freq_All_Sites___().
--  141006  AwWelk  GEN-148, Modified Get_From_Abc_Frequency_Life___() and added Get_From_Abc_Freq_All_Sites___() to 
--  141006          calculate planning hierarchy parameters for all site configuration in Abc_Frequency_Lifecycle window. 
--  140923  UdGnlk  PRSC-3165, Corrected the deployment error adding parameter contract.
--  140218  THLILK  PBMF-5434, Modified procedure Check_Update___ to correct the call to Ms_Qty_Rate_By_Period_API.Check_Records_Exist.
--  130806  ChJalk  TIBE-882, Removed global variables inst_Level1Part_, inst_SuppSchedAgreement_, inst_ManufStructureUtil_, 
--  130806          inst_SalesPart_, inst_PurchasePart_, inst_ManufPartAtt_, inst_SupplySourcePartManager_, inst_QmanControlPlanManuf_, 
--  130806          inst_InventoryPartInvplaInfo_, inst_SupplierCompanyPurch_, inst_PurchasePartSupplier_ and inst_ForecastDay_.
--  130603  THLILK  PCM-2871, Modified Unpack_Check_Update___ to add an info message when trying to update multiple lot size of rate defined MS parts.  
--  130531  Asawlk  EBALL-37, Modified Validate_Planning_Method___() by calling Invent_Part_Quantity_Util_API.Check_Part_Exist() instead of 
--  130531          Inventory_Part_In_Stock_API.Check_Part_Exist() to check for parts in stock, in trasit and at customer. 
--  130515  IsSalk  Bug 106680, Replaced Installed_Component_SYS.<component> with Component_<component>_SYS.<component>.
--  130207  AyAmlk  Bug 107934, Modified Validate_Planning_Method___() to provide a clear error message when the planning method is other than B or C.
--  121231  SBalLK  Bug 107566, Modified Unpack_Check_Update___() by changing the AUTOFLAGS message to be more user friendly. 
--  121015  THLILK  Modified Unpack_Check_Update___ to call the method Check_Min_Order_Qty_Changes in Ms_Qty_Rate_By_Period_API.
--  120918  AyAmlk  Bug 101353, Modified Auto_Update_Planning_Method() to set the safety stock to zero automatically when planning
--  120918          method is changed from B to A.
--  120320  MaEelk  Replaced the usage of using General_SYS.Init_Method with pragma to some methods calling from client. 
--  120320          Converted some dynamic sql codes to conditionally compilable codes.
--  120319  AndDse  EASTRTM-1864, Removed carry_rate and setup_cost from Get function in order to avoid context switching due to performance reasons.
--  120315  MaEelk  Removed the last parameter TRUE in call General_SYS.Init_Method from  non-implementation methods
--  120208  HaPulk  Removed unused CONSTANTS.
--  110130  MaEelk  Modified the date format of last_activity_date and order_trip_date in view comments.
--  111220  LEPESE  Added fetch of stop_analysis_date in Make_Next_Order_Analysis. Use stop_analysis_date in
--  111220          Next_Order_Analysis_Others___ and Next_Order_Analysis_Slow___.
--  111202  LEPESE  Added logic in Next_Order_Analysis_Others___ so that we continue to collect projected_qty_onhand
--  111202          until the end of the lead time fence before deciding if we have a shortage or not.
--  110527  JeLise  Added in parameter max_order_qty_ to Validate_Planning_Method___ and changed the
--  110527          IF condition for planning_method 'D'.
--  110324  LEPESE  Modification in Unpack_Check_Update___ to use receipt_issue_serial_track flag.
--  110204  KiSalk  Moved 'User Allowed Site' Default Where condition from client to base view.
--  100507  KRPELK  Merge Rose Method Documentation.
--  100110  JENASE  Replaced calls to obsolete Manuf_Part_Attribute__Int_API with Manuf_Part_Attribute_API.
--  091223  JENASE  Replaced calls to obsolete Manuf_Structure_Int_API with other API:s.
--  090925  MaEelk  Removed unused view INVENTORY_PART_PLANNING_LOV1.
--  --------------------------------- 14.0.0 ------------------------------------
--  100209  SuSalk    Bug 88288, Modified Modify_Stockfactors method to call Inventory_Part_API.Get_Calc_Rounded_Qty
--  100209            method. Modified Get_Percent_Diff method to round up the return value to two decimal points.  
--  100112  Asawlk    Bug 88204, Moved call to Invalidate_Cache___() up in the code to be executed immediately after the UPDATE
--  100112            statement of the table inside Update() method.
--  091202  ShKolk    Bug 87224, Modified Unpack_Check_Update___ to pass correct value for min_order_qty.
--  091030  ShKolk    Bug 86768, Merge IPR to APP75 core.
--  090528  SaWjlk    Bug 83173, Removed the prog text duplications.
--  080110  SuSalk    Bug 70456, Removed function call General_SYS.Init_Method in function Get_Split_Manuf_Acquired_Db.
--  080109  WaJalk    Bug 69862,Made PERCENT_MANUFACTURED and PERCENT_ACQUIRED not null. Added Check_Manuf_Acquired_Split___
--  080109            to do validations for split_manuf_acquired, percent_manufactured and percent_acquired.
--  070810  NiDalk    Bug 66751, Modified the method Modify_Stockfactors to make sure that order_point_qty is never
--  070810            smaller than safety_stock for MRP order codes B and C.
--  070425  Haunlk   Checked and added assert_safe comments where necessary.
--  070316  LaRelk    Bug 60306, Called Qman_Control_Plan_manuf_API.Check_Order_Requisition_Change
--  070316            when field order_requisition is changed in Unpack_Check_Update___.
--  070206  NiDalk    Added Create_New_Part_Planning to add new record with default values entered in Assortment_Invent_Def_TAB for mass part creation.
--  060807  NaWilk    Modified LOV_VIEW1 by removing Part_Catalog_Pub.
--  060720  RoJalk    Centralized Part Desc - Use Inventory_Part_API.Get_Description.
--  060629  DaZase    Removed obsolete methods Get_Scrapping_Rounded_Qty___, Get_Scrapping_Rounded_Qty and Get_Shrinkage_Rounding.
--  060620  DaZase    Removed obsolete attribute shrinkage_rounding.
--  060619  DaZase    Changes in methods Get_Shrinkage_Rounding, Get_Scrapping_Rounded_Qty, Get_Scrap_Added_Qty
--                    and Get_Scrap_Removed_Qty so they use qty_calc_rounding on the inventory part instead.
--  060601  RoJalk    Enlarge Part Description - Changed view comments.
--  060508  IsWilk    Bug 56709, Added Level_1_Part_API.Check_Min_Order_Qty_Changes to checked against
--  060508            Max Cap/Day in MS level 1 when changing Min Lot Size on Inventory Part.
--  --------------------------------- 13.4.0 ------------------------------------
--  060320  SaJjlk    Added method Modify_Manuf_Acq_Percent.
--  060306  JaJalk    Added Assert safe annotation.
--  060124  NiDalk    Added Assert safe annotation.
--  051223  KAYOLK    Bug 54437, Modified Unpack_Check_Update___, such that MRP Order Code validations
--  051223            related to Manufacturing is via single point interface method call.
--  051223            Also moved the existing validations related to Manufacturing from Validate_Mrp_Code___
--  051003  KeFelk    Added Site_Invent_Info_API in relavant places where Site_API is used.
--  050921  NiDalk    Removed unused variables.
--  050323  DaZase    Added new mrp_order_code IN ('P', 'N') check in Unpack_Check_Update___.
--  050119  DaZase    Added call to Sales_Part_API.Check_Inv_Part_Planning_Data in method Unpack_Check_Update___.
--  041129  KanGlk    Modified the method Copy.
--  040909  RoJalk    Modified the procedure Modify_Stockfactors.
--  040906  RoJalk    Modified the procedure Modify_Stockfactors to get the correct value for lot_size when MRP Order Code is C.
--  040818  DhWilk    Inserted General_SYS.Init_Method to Get_Split_Manuf_Acquired_Db & Is_Manuf_Acquir_Split_Part.
--  040813  LoPrlk    Modified the method Update___ to create a purchase part when a manuf acquire split is defined on a manufactured part part.
--  040813            Miner changes were done to Unpack_Check_Insert___ and Unpack_Check_Update___ also.
--  040720  LaBolk    Modified Update___ to raise a warning to the user in multi-site MRP functionality.
--  040618  KeFelk    Modified validations relating to SPLIT in Unpack_Check_Update__.
--  040609  KeFelk    Inroduced some more validations relating to SPLIT in to Unpack_Check_Update___.
--  040609  KeFelk    Added part type 'Purchased' to the Split_Manuf_Acquired default value setup.
--  040608  WaJalk    Modified method Unpack_Check_Update___.
--  040527  LoPrlk    Modified the methods Prepare_Insert___, Unpack_Check_Insert___ and Unpack_Check_Update___.
--  040524  IsWilk    Modifiewd the Attributes PERCENT_MANUFACTURED, PERCENT_ACQUIRED as public.
--  040521  IsWilk    Added the FUNCTIONs Get_Split_Manuf_Acquired_Db , Is_Manuf_Acquir_Split_Part.
--  040521  LoPrlk    Modified the methods Prepare_Insert___, Unpack_Check_Insert___ and Unpack_Check_Update___.
--  040519  IsWilk    Modified the code according to changed db value NO_SPLIT.
--  040519  IsWilk    Added the conditions to the PROCEDURE Unpack_Check_Update___
--  040519            to make the basic validations of Manufactured/Acquired Split Functionality.
--  040518  IsWilk    Added the columns SPLIT_MANUF_ACQUIRED, PERCENT_MANUFACTURED,
--  040518            PERCENT_ACQUIRED, MANUF_SUPPLY_TYPE, ACQUIRED_SUPPLY_TYPE and
--  040518            added the default values in the PROCEDURE Prepare_insert___ and Unpack_Check_Insert___.
--  040302  GeKalk    Removed substrb from views for UNICODE modifications.
--  040129  NaWalk    Rewrote the DBMS_SQL to Native dynamic SQL for Unicode modification.
--  ---------------------------------- 13.3.0 -----------------------------------
--  031118  JoAnSe    Reversed previous correction made for DOP in Unpack_Check_Update___
--  031023  JOHESE    Added check on supply type DOP in Unpack_Check_Update___
--  030811  LEPESE    Changed values of parameters in call to method Get_Inventory_Value_By_Method.
--  030730  MaGulk    Merged SP4
--  030512  ThJalk    Bug 37249, Added error message in method Unpack_Check_Update___ and Unpack_Check_Insert___ to raise when the Scrap Factor not within 0 to 99 .
--  030507  ThPalk    Bug 37049, Changed Get_Shrinkage_Fac method to return zero when Null.
--  021205  SAMNLK    Bug fix 34467, Change the calculation of new_lot_size in Modify_Stockfactors.
--  021022  LEPESE    Added method Copy.
--  020816  ANLASE    Replaced Inventory_Part_Config_API.Get_Inventory_Value_By_Method with
--                    Inventory_Part_Unit_Cost_API.Get_Inventory_Value_By_Method.
--  ****************************  Take Off Baseline  *********************************
--  020312  HECESE    Bug 27591, Added check for supply type DOP and Default Location Pallet Delivery in Unpack_Check_Update___.
--  010627  SAMNLK    Bug fix 22074, Change the comments in Modify_Stockfactors.
--  010613  SAMNLK    Bug fix 22074,Change the Modify_Stockfactors.Interchange the calculations for  new_order_point_qty_ and  new_lot_size_.
--                    Change the value passing to the attribute string.
--  010612  SAMNLK    Bug fix 22074,Change the Modify_Stockfactors .Interchange the calculations for  new_order_point_qty_ and  new_lot_size_.
--  010525  JSAnse    Bug fix 21463, Added call to  General_SYS.Init_Method in Check_Mrp_Order_Code_K_O.
--  010410  DaJoLK    Bug fix 20598, Declared Global LU Constants to replace calls to TRANSACTION_SYS.Package_Is_Installed and
--                    TRANSACTION_SYS.Logical_Unit_Is_Installed in methods.
--  001219  PERK      Added call to Manuf_Structure_Int_API.Check_Order_Requis_Change in Update___
--  001218  JOHW      Changed to Check_Rep_Source_Location when validate mrp order code
--                    B and C and using Kanban.
--  001213  ANLASE    Added validation for configurable in Unpack_Check_Update___.
--  001211  ANLASE    Modified error message ORDREQTYPESERROR.
--  001204  PaLj      Made call to Supp_Sched_Agreement_API.Check_Sched_Generation dynamic.
--  001130  PaLj      Added check in to Supp_Sched_Agreement_API.Check_Sched_Generation in unpack_check_update___
--  001127  PEADSE    Changed Specific Cost to Ordering Cost
--  001023  ANLASE    Replaced call to Part_Catalog with part_cat_rec_ in Unpack_Check_Update.
--  001013  ANLASE    Replaced Part_Catalog_API.Get_Configurable with Part_Catalog_API.Get_Configurable_Db
--                    in validations for configurations.
--  001006  ANLASE    Added validation for configurations in method Unpack_Check_Update___.
--  001004  ANLASE    Added validation for configurations in method Validate_Mrp_Code___.
--  000925  JOHESE    Added undefines.
--  000920  JOHW      Added '*' as parameter sent from methods in Modify_Stockfactors.
--  000619  NISOSE    Corrected a validation in Unpack_Check_Update___.
--  000615  ANHO      Corrected the mix up of order point qty and order point in Modify_Stockfactors.
--  000602  NISOSE    Added the function Check_Mrp_Order_Code_K_O.
--  000419  SHVE      Removed obsolete method Get_Scrapping_Adjusted_Qty.
--  000414  NISOSE    Cleaned-up General_SYS.Init_Method.
--  000331  ANLASE    Replaced MPCCOM_SYSTEM_PARAMETER_API.Get_Parameter_Value1('PICKING_LEADTIME')
--                    with Site_API.Get_Picking_Leadtime in method Get_Part_Planning_Data.
--  000323  LEPE      Corrected minor error in view comments for INVENTORY_PART_PLANNING_LOV1.
--                    Added NVL handling when fetching min_periods from commodity_group
--                    in method Modify_Stockfactors.
--  000321  LEPE      Created LOV view INVENTORY_PART_PLANNING_LOV1.
--  000321  ANHO      Changed shrinkage_fac and carry_rate from NUMBER(3) to NUMBER.
--  000320  LEPE      Changed duplicate error message label NOTPURSALEPART into two
--                    separate labels NOTSALEPART and NOTPURPART.
--  000317  NISOSE    Allowed Order Point to be = Order Point Qty in frmInventoryPartPlanning.
--  000307  JOHW      Added Error_SYS if median value is zero or null in Modify_Stockfactors.
--  000307  LEPE      Correction in method Modify_Stockfactors.
--  000303  JOHW      Added validation for Kanban in Validate_Mrp_Code___.
--  000121  ROOD      Added update of flag in MASSCH upon changes of attribute proposal_release.
--  991220  ROOD      Added attribute proposal_release.
--  991111  FRDI      Bug fix 12287, Added check for negative qty_predicted_consumption
--                    Unpack_Check_insert___, Unpack_Check_update___.
--  991104  ROOD      Bug fix 12421, Added methods Get_Scrap_Added_Qty, Get_Scrap_Removed_Qty
--                    and Get_Scrapping_Rounded_Qty___.
--  990819  FRDI      Allowing MRP code 'K' and 'P' for supply type 'DOP',
--                    changes done in Validate_Mrp_Code___.
--  990607  SHVE      Changed priority of validations for supply type DOP.
--  990512  ROOD      Minor performance changes in method Modify_Service_Rate.
--  990510  ROOD      Changed method Modify_Stockfactors.
--  990504  SHVE      Moved the call to Statistic_Period_API.Get_Begin_Dates to
--                    Inventory_Part_Period_Hist_API.Get_History_Statistics.
--  990428  ANHO      Corrected IID-values.
--  990421  JOHW      General performance improvements.
--  990414  JOHW      Corrected Order_Requistion in Prepare_Insert.
--  990412  JOHW      Upgraded to performance optimized template.
--  990330  FRDI      Change check for sdt_order_qty in Unpack_Check_insert___.
--  990326  FRDI      Leadtime restrictions for MRP code 'K' are now removed in
--                    Unpack_Check_insert___,  Unpack_Check_update___.
--  990324  ANHO      Added method Get_Scrapping_Adjusted_Qty and Get_Scrapping_Rounded_Qty.
--  990322  ANHO      Added public attribute shrinkage_rounding.
--  990319  SHVE      CID 11640: Corrected validation for MRP code K.
--  990126  LEPE      Added method Get_Order_Requisition_Db.
--  990118  ROOD      Changed error messages in Validate_Order_Requisition and in Validate_Mrp_Code___.
--  990117  ROOD      Added method Validate_Order_Requisition, used in Unpack_Check_Update___
--                    and Unpack_Check_Insert___. Removed obsolete check for mrp_order_code 'S'
--                    in Validate_Mrp_Code___. Corrected call to Validate_Mrp_Code___.
--  990114  FRDI      Changed Sysdate to site dependent 'sysdate' - Site_API.Get_Site_Date(contract)
--  981122  FRDI      Full precision for UOM, change comments in tab for numbers,
--                    changed variabels in Modify_Stockfactors form number(12,4) to number.
--  981021  JOKE      Corrected call to Manuf_Structure_Int_API.Convert_Plan_Structure.
--  981012  JOKE      Added call to Manuf_Structure_Int_API.Convert_Plan_Structure
--                    in the update statement so that MFGSTD can verify that you are
--                    allowed to change to the new MRP_ORDER_CODE plus
--                    Moved Add_Attr for OldLotSize, OldOrderPointQty, OldSafetyStock
--                    into the update procedure.
--  980813  ANHO      Moved mrp_order_code from InventoryPart to InventoryPartPlanning.
--                    Removed inparameter mrp_order_code in Modify_Stockfactors. Added
--                    errormessages in Unpack_Check_Insert and Unpack_Check_Update.
--  980408  LEPE      Omitted combination check on minimum-, maximum- and
---                   standard lot size for mrp_codes B, C, O, T, M, N and S.
--  980320  JOHO      Added function Get_Percent_Diff.
--  980303  SHVE      Changed input parameters for Create_New_Part_Planning.
--  980227  JOHO      Corrections of error messages according to catwalk support id 434
--  980223  JOHO      Remove rounding on price/cost objects.
--  980212  GOPE      Correction of HEAD ID 3347, 3012, 2814
--  980210  FRDI      Format on Amount Columns
--  980120  GOPE      Connected order_requisition towards a new IID InventoryPartSupplyType
--  980120  JOHO/GOPE Added columns OldLotSize, OldOrderPointQty, OldSafetyStock
--  971201  GOPE      Upgrade to fnd 2.0
--  971107  JOHNI     Corrected error messages.
--  971104  JOKE      Changed error messages ('NOTPURSALEPART:') in Validate_Mrp_Code.
--  971031  JOKE      Added check for mrp_order_code_ 'K' in Validate_Mrp_Code.
--  970618  JOED      Changed public Get_.. methods. Added _db columns in the view.
--                    Beautified parts of the code.
--  970610  LEPE      Corrections for nice appearance in Developers Workbench.
--  970606  LEPE      Added get-functions for Mrp_Order_Code and Qty_Predicted_Consumption.
--                    Renamed procedure Modify_Rate_Cost to Modify_Planning_Attributes and added
--                    all public attribures to the argument list.
--  970603  LEPE      Added three get-functions for the auto-flags.
--  970520  MAJO      Error in dynamic call to Level_1_Part_API in the method
--                    Validate_Mrp_Code_Impl___.
--  970417  PEKR      Add Check_Exist.
--  970319  NAVE      Created public methods for some attributes
--  970313  MAGN      Changed tablename part_planning to inventory_part_planning_tab.
--  970220  JOKE      Uses column rowversion as objversion (timestamp).
--  970129  FRMA      Replaced Gen_Yes_No IIDs in Check_Auto_Flags.
--  970128  ASBE      Added not negative check in Unpack_Check_Update for some
--                    values.
--                    Also removed default value settings when update.
--  970123  ASBE      Added procedures Validate_Mrp_Code_Impl___ to validate the
--                    mrp_order_code on update.
--                    Also replaced Gen_Yes_No IID's in Unpack_Check_Update.
--  970110  FRMA      Replaced Gen_Yes_No IID's in Modify_Stockfactors.
--  961218  MAOR      Added check if not null in Modify_Rate_Cost.
--  961218  MAOR      Added check if not null in Create_New_Part_Planning.
--                    Changed service_rate_ from VARCHAR2 to NUMBER.
--  961217  AnAr      Moved Set_Avail_Activity_Status.
--  961217  AnAr      Fixed Create_New_Part_Planning.
--  961217  AnAr      Fixed flags on Qty_Predicted_Consumption and Order_Requisition.
--  961216  FRMA      Removed NOT NULL restriction for Qty_Predicted_Consumption
--                    and Order_Requisition.
--  961210  HP        Added default value for order_requisition.
--  961205  MAOR      Changed call to Inventory_Part_Cost_API.Get_Standard_Total
--                    to Get_Total_Standard.
--  961204  FRMA      Added predicted consumption in method Modify_Stockfactors
--  961202  HP        Added call to Inventory_Part_API.Set_Avail_Activity_Status
--                    to Update___.
--  961128  JOBI      Added procedure Modify_Service_Rate.
--  961124  MAOR      Changed order of part_no and contract in call to
--                    Inventory_Part_Period_Hist_API.
--  961121  MAOR      Added reference and cascade on column part_no. Removed
--                    procedure Delete_Planning_Info.
--  961118  JICE      Get_Scheduling_Flags added for increased performance.
--  961118  JOBE      Changed function call Mpccom_System_Parameter_API.Get_Value to
--                    Mpccom_System_Parameter_API.Get_Parameter_Value1.
--  961111  JICE      Modified for Rational Rose / Workbench.
--  961028  MAOR      Changed name of function Commodity_Group_API.Get_Com_Min_Periods
--                    to be Commodity_Group_API.Get_Min_Periods.
--  961009  LEPE      Moved a lot of error messages from exception to actual
--                    place where error occurs.
--  961007  VIVA      Added function Get_Std_Order_Size.
--  961004  LEPE      Corrected some error messages to get them translatable.
--  960911  HARH      Added procedure Get_Planning_Factors
--  960906  RaKu      Added functions Get_Safety_Stock & Get_Order_Point
--  960829  SHVE      Replaced call to Inventory_Part_Cost_API.Get_total_standard
--                    with call to Get_Standard_total.
--  960705  HARH      Added function Check_Auto_Flags, proc. Modify_Stockfactors
--  960624  PEOD      Added the procedure Get_Scheduling_Flags.
--  960607  JOBE      Added functionality to CONTRACT.
--  960606  SHVE      Replaced call to Mpc_Sysparam_Pkg with call to
--                    Mpccom_System_Parameter_Api.
--  960308  JICE      Renamed from PartPlanningInfo
--  951109  BJSA      Added procedure Get_part_planning_data
--  951102  JOBR      Base Table to Logical Unit Generator 1.0
--  951102  JOBR      Added functionality fro V10.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

the_service_level_rate_       CONSTANT NUMBER := 1;

the_ordering_cost_            CONSTANT NUMBER := 2;

the_inventory_interest_rate_  CONSTANT NUMBER := 3;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Validate_Planning_Method___ (
   contract_                IN VARCHAR2,
   part_no_                 IN VARCHAR2,
   planning_method_         IN VARCHAR2,
   order_point_qty_         IN NUMBER,
   lot_size_                IN NUMBER,
   safety_stock_            IN NUMBER,   
   min_order_qty_           IN NUMBER,
   max_order_qty_           IN NUMBER,
   mul_order_qty_           IN NUMBER,
   maxweek_supply_          IN NUMBER,
   order_point_qty_auto_db_ IN VARCHAR2,
   lot_size_auto_db_        IN VARCHAR2,
   order_requisition_db_    IN VARCHAR2 )
IS
   found_     NUMBER := 0;
   found_qty_ BOOLEAN;
BEGIN   
   IF (planning_method_ NOT IN ('A', 'K', 'P')) THEN
      IF (Part_Catalog_API.Get_Configurable_Db(part_no_) = 'CONFIGURED') THEN
         Error_SYS.Record_General(lu_name_,'ISCONFIGURED: This part is configurable and only Planning Method A, K or P is allowed.');
      END IF;
   END IF;

   IF (planning_method_ NOT IN ('A', 'D', 'K', 'P')) THEN
      IF (order_requisition_db_ = 'D') THEN
         Error_SYS.Record_General('InventoryPartPlanning', 'MRPCODENOTADERROR: Planning Method :P1 not allowed when Supply Type is :P2.', planning_method_, Inventory_Part_Supply_Type_API.Decode(order_requisition_db_));
      END IF;
   END IF;
   
   IF (planning_method_ = 'B') THEN
      IF order_requisition_db_ = 'S' THEN
         Error_SYS.Record_General('InventoryPartPlanning', 'ORDREQTYPESERROR: Planning Method :P1 - not allowed when Supply Type = :P2.', planning_method_, Inventory_Part_Supply_Type_API.Decode('S'));
      END IF;
      IF (order_point_qty_ < 0) THEN
         Error_SYS.Record_General('InventoryPartPlanning', 'BORDPNTLESSZERO: Planning Method B - Order Point Qty < 0 is not allowed.');
      END IF;
      IF (lot_size_ <= 0) THEN
         Error_SYS.Record_General('InventoryPartPlanning', 'BLOTSIZELESSEQZERO: Planning Method B - Lot Size <= 0 is not allowed.');
      END IF;
      IF (order_point_qty_ < safety_stock_) THEN
         Error_SYS.Record_General('InventoryPartPlanning', 'BORDPNTLESSSFSTOCK: Planning Method B - Order Point < safety Stock is not allowed.');
      END IF;
   ELSIF (planning_method_ = 'C') THEN
      IF order_requisition_db_ = 'S' THEN
         Error_SYS.Record_General('InventoryPartPlanning', 'ORDREQTYPESERROR: Planning Method :P1 - not allowed when Supply Type = :P2.', planning_method_, Inventory_Part_Supply_Type_API.Decode('S'));
      END IF;
      IF (order_point_qty_ < 0) THEN
         Error_SYS.Record_General('InventoryPartPlanning', 'CORDPNTLESSZERO: Planning Method C - Order Point < 0 is not allowed.');
      END IF;
      IF (lot_size_ <= 0) THEN
         Error_SYS.Record_General('InventoryPartPlanning', 'CLOTSIZELESSEQZERO: Planning Method C - Lot Size <= 0 is not allowed.');
      END IF;
      IF (order_point_qty_ < safety_stock_) THEN
         Error_SYS.Record_General('InventoryPartPlanning', 'CORDPNTLESSSFSTOCK: Planning Method C - Order point < Safety Stock is not allowed.');
      END IF;
      IF (order_point_qty_ > lot_size_) THEN
         Error_SYS.Record_General('InventoryPartPlanning', 'CORDPNTGELOTSIZE: Planning Method C - Order Point > Lot Size is not allowed.');
      END IF;
   ELSIF (planning_method_ = 'D') THEN
      IF (min_order_qty_ != max_order_qty_ OR min_order_qty_ != mul_order_qty_) THEN 
         Error_SYS.Record_General('InventoryPartPlanning', 'ERROR_MRP_D: Planning Method D - Min and Max and Multiple Lot Size must be the same.');
      END IF;
   ELSIF (planning_method_ = 'G') THEN
      IF (maxweek_supply_ <= 0 ) THEN
         Error_SYS.Record_General('InventoryPartPlanning', 'GMAXWEEKSUPLEZERO: Planning Method G - Order Cover Time <= 0 is not allowed.');
      END IF;
   ELSIF (planning_method_ = 'N') THEN
      IF order_requisition_db_ = 'S' THEN
         Error_SYS.Record_General('InventoryPartPlanning', 'ORDREQTYPESERROR: Planning Method :P1 - not allowed when Supply Type = :P2.', planning_method_, Inventory_Part_Supply_Type_API.Decode('S'));
      END IF;
   END IF;
   IF (planning_method_ IN ('O', 'T','K')) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         found_ := Sales_Part_API.Exist_Inventory_Part(contract_, part_no_);
         IF found_ = 1 THEN
            Error_SYS.Record_General('InventoryPartPlanning', 'NOTSALEPART: Planning Method K/T/O - Not allowed for parts included in the sales part register.');
         END IF;
      $END
      
      $IF Component_Purch_SYS.INSTALLED $THEN      
         found_ := Purchase_Part_API.Check_Exist(contract_, part_no_);
         IF found_ = 1 THEN
            Error_SYS.Record_General('InventoryPartPlanning', 'NOTPURPART: Planning Method K/T/O - Not allowed for parts included in the purchase part register.');
         END IF;
      $END
      
      -- EBALL-37, Modified the call to use the Invent_Part_Quantity_Util_API instead of Inventory_Part_In_Stock_API. 
      found_qty_ := Invent_Part_Quantity_Util_API.Check_Part_Exist(contract_, part_no_);
      IF found_qty_ = TRUE THEN
         Error_SYS.Record_General('InventoryPartPlanning', 'QTYONHANDEXIST: Quantity on hand exists for this part. That is not allowed for Planning Method T, O or K.');
      END IF;
   END IF;

   IF (planning_method_ NOT IN ('B', 'C')) THEN
      IF order_point_qty_auto_db_ = 'Y' THEN
         Error_SYS.Record_General('InventoryPartPlanning', 'NO_ORD_POINT_AUTO: You are not allowed to automatically update the order point for the part(s) when the planning method is set as :P1.', planning_method_);
      END IF;
      IF lot_size_auto_db_ = 'Y' THEN
         Error_SYS.Record_General('InventoryPartPlanning', 'NO_LOT_SIZE_AUTO: You are not allowed to automatically update the lot size for the part(s) when the planning method is set as :P1.', planning_method_);
      END IF;
   END IF;
   
   IF planning_method_ = 'H' THEN
      $IF Component_Massch_SYS.INSTALLED $THEN
         found_ := Level_1_Part_API.Check_Exist_Client(contract_, part_no_, NULL);         
         IF found_ = 1 THEN            
            Error_SYS.Record_General('InventoryPartPlanning', 'BUFFER_PART_NOT_ALLOW: Planning Method H - Not allowed for active MS Level 1 Parts. You need to remove the MS Level 1 Part or set it to inactive in MS Level 1 Part.');
         END IF;
      $ELSE
         NULL;      
      $END 
   END IF;    
END Validate_Planning_Method___;


-- Check_Manuf_Acquired_Split___
--   This method is used for validations of columns split_manuf_acquired,
--   percent_manufactured and percent_acquired.
PROCEDURE Check_Manuf_Acquired_Split___ (
   part_no_              IN VARCHAR2,
   planning_method_db_   IN VARCHAR2,
   type_code_db_         IN VARCHAR2,
   split_manuf_acquired_ IN VARCHAR2,
   percent_manufactured_ IN NUMBER,
   percent_acquired_     IN NUMBER )
IS
BEGIN
   IF (split_manuf_acquired_ = 'SPLIT') THEN
      IF (planning_method_db_ IN ('K', 'T', 'O')) THEN
         Error_SYS.Record_General('InventoryPartPlanning', 'MRPMASPLIT: Manufactured/Acquired split is not allowed for Planning Method K , T and O.');
      END IF;
      IF (Part_Catalog_API.Get_Position_Part_Db(part_no_) = 'POSITION PART') THEN
         Error_SYS.Record_General('InventoryPartPlanning', 'POSISMASPLIT: Manufactured/Acquired split is not allowed for Position Part.');
      END IF;
      IF (type_code_db_ IN ('3', '6')) THEN
         Error_SYS.Record_General('InventoryPartPlanning', 'MANUFSPLIT: Manufactured/Acquired split cannot be defined for parts of type Purchase Raw or Expense.');
      END IF;
      IF (percent_manufactured_ > 99) OR (percent_manufactured_ < 1) OR 
         (percent_acquired_ > 99) OR (percent_acquired_ < 1) THEN
         Error_SYS.Record_General('InventoryPartPlanning', 'SPLITOUTRANGE: Manufactured / Acquired split percentages must be between 1 and 99.');
      END IF;
   END IF;
   IF( NVL(percent_manufactured_ + percent_acquired_, 0) !=100 ) THEN
      Error_SYS.Record_General('InventoryPartPlanning', 'SPLITTOTOUTRANGE: Manufactured and Acquired split percentages must add up to 100.');
   END IF;
END Check_Manuf_Acquired_Split___;


PROCEDURE Get_From_Hierarchy___ (
   numeric_value_        OUT NUMBER,
   value_source_db_      OUT VARCHAR2,
   latest_activity_time_ OUT DATE,
   contract_             IN  VARCHAR2,
   part_no_              IN  VARCHAR2,
   attribute_            IN  NUMBER )
IS
   activity_time_       DATE;
   company_             VARCHAR2(20);
   supplier_id_         VARCHAR2(20);
   prime_commodity_     VARCHAR2(5);
   second_commodity_    VARCHAR2(5);
   asset_class_         VARCHAR2(2);
   abc_class_           VARCHAR2(1);
   frequency_class_db_  VARCHAR2(20);
   lifecycle_stage_db_  VARCHAR2(20);
BEGIN
   Get_From_Inventory_Part___(numeric_value_,
                              latest_activity_time_,
                              contract_,
                              part_no_,
                              attribute_);

   value_source_db_ := 'INVENTORY PART';

   IF (numeric_value_ IS NULL) THEN
      supplier_id_ := Get_Primary_Supplier___(contract_, part_no_);
      company_     := Site_API.Get_Company(contract_);

      IF (supplier_id_ IS NOT NULL) THEN
         Get_From_Supplier___(numeric_value_,
                              activity_time_,
                              supplier_id_,
                              company_,
                              attribute_);
         latest_activity_time_ := GREATEST(latest_activity_time_, activity_time_);
         value_source_db_      := 'PRIMARY SUPPLIER';
      END IF;

      IF (numeric_value_ IS NULL) THEN

         second_commodity_ := Inventory_Part_API.Get_Second_Commodity(contract_, part_no_);

         IF (second_commodity_ IS NOT NULL) THEN
            Get_From_Commodity_Group___(numeric_value_,
                                        activity_time_,
                                        second_commodity_,
                                        company_,
                                        attribute_);
            latest_activity_time_ := GREATEST(latest_activity_time_, activity_time_);
            value_source_db_      := 'SECONDARY COMMODITY GROUP';
         END IF;
      END IF;

      IF (numeric_value_ IS NULL) THEN

         prime_commodity_ := Inventory_Part_API.Get_Prime_Commodity(contract_, part_no_);

         IF (prime_commodity_ IS NOT NULL) THEN
            Get_From_Commodity_Group___(numeric_value_,
                                        activity_time_,
                                        prime_commodity_,
                                        company_,
                                        attribute_);
            latest_activity_time_ := GREATEST(latest_activity_time_, activity_time_);
            value_source_db_      := 'PRIMARY COMMODITY GROUP';
         END IF;
      END IF;
      IF (numeric_value_ IS NULL) THEN

         asset_class_ := Inventory_Part_API.Get_Asset_Class(contract_, part_no_);

         Get_From_Asset_Class___(numeric_value_,
                                 activity_time_,
                                 asset_class_,
                                 company_,
                                 attribute_);
         latest_activity_time_ := GREATEST(latest_activity_time_, activity_time_);
         value_source_db_      := 'ASSET CLASS';
      END IF;
      IF (numeric_value_ IS NULL) THEN
         -- Three separate calls because they are reading from micro cache. Will be very fast anyway.
         abc_class_          := Inventory_Part_API.Get_Abc_Class         (contract_, part_no_);
         frequency_class_db_ := Inventory_Part_API.Get_Frequency_Class_Db(contract_, part_no_);
         lifecycle_stage_db_ := Inventory_Part_API.Get_Lifecycle_Stage_Db(contract_, part_no_);

         Get_From_Abc_Frequency_Life___(numeric_value_,
                                        activity_time_,
                                        abc_class_,
                                        frequency_class_db_,
                                        lifecycle_stage_db_,
                                        company_,
                                        contract_,
                                        attribute_);
            latest_activity_time_ := GREATEST(latest_activity_time_, activity_time_);
            value_source_db_      := 'ABC FREQUENCY LIFECYCLE';
      END IF;
      IF (numeric_value_ IS NULL) THEN
         Get_From_Site___(numeric_value_,
                          activity_time_,
                          contract_,
                          attribute_);
         latest_activity_time_ := GREATEST(latest_activity_time_, activity_time_);
         value_source_db_      := 'SITE';
      END IF;
      IF (numeric_value_ IS NULL) THEN
         Get_From_Company___(numeric_value_,
                             activity_time_,
                             company_,
                             attribute_);
         latest_activity_time_ := GREATEST(latest_activity_time_, activity_time_);
         value_source_db_      := 'COMPANY';
      END IF;
   END IF;
END Get_From_Hierarchy___;


PROCEDURE Get_Forecasted_Daily_Demand___ (
   forecasted_demand_expiry_date_    OUT DATE,
   forecasted_daily_demand_       IN OUT NUMBER,
   contract_                      IN     VARCHAR2,
   part_no_                       IN     VARCHAR2,
   date_of_interest_              IN     DATE )
IS   
   old_forecasted_daily_demand_ NUMBER;
BEGIN

   old_forecasted_daily_demand_ := forecasted_daily_demand_;
   forecasted_daily_demand_     := NULL;
   
   $IF Component_Demand_SYS.INSTALLED $THEN
      Forecast_Day_API.Get_Forecasted_Daily_Demand(forecasted_daily_demand_,forecasted_demand_expiry_date_,contract_,part_no_, date_of_interest_);
   $ELSE
      NULL;
   $END
   
   IF (forecasted_daily_demand_ IS NULL) THEN
      forecasted_daily_demand_       := old_forecasted_daily_demand_;
      forecasted_demand_expiry_date_ := Database_SYS.last_calendar_date_;
   END IF;

END Get_Forecasted_Daily_Demand___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
   contract_    Inventory_Part_Planning_TAB.Contract%TYPE;
   part_no_     Inventory_Part_Planning_TAB.Part_No%TYPE;
BEGIN
   contract_ := Client_Sys.Get_Item_Value('CONTRACT', attr_);
   part_no_  := Client_Sys.Get_Item_Value('PART_NO', attr_);

   super(attr_);
   Client_SYS.Add_To_Attr('ORDER_REQUISITION', Inventory_Part_Supply_Type_API.Decode('R'), attr_);
   Client_SYS.Add_To_Attr('PROPOSAL_RELEASE', Order_Proposal_Release_API.Decode('RELEASE'), attr_);
   Client_SYS.Add_To_Attr('SPLIT_MANUF_ACQUIRED', Split_Manuf_Acquired_API.Decode('NO_SPLIT'), attr_);
   Client_SYS.Add_To_Attr('MANUF_SUPPLY_TYPE', Inventory_Part_Supply_Type_API.Decode('R'), attr_);
   Client_SYS.Add_To_Attr('ACQUIRED_SUPPLY_TYPE', Inventory_Part_Supply_Type_API.Decode('R'), attr_);

   -- '1', '2' = Manufactured, Manufactured Recipe
   IF Inventory_Part_API.Get_Type_Code_Db(contract_, part_no_) IN ('1', '2') THEN
      Client_SYS.Add_To_Attr('PERCENT_MANUFACTURED', 100, attr_);
      Client_SYS.Add_To_Attr('PERCENT_ACQUIRED', 0, attr_);
   ELSE
      Client_SYS.Add_To_Attr('PERCENT_MANUFACTURED', 0, attr_);
      Client_SYS.Add_To_Attr('PERCENT_ACQUIRED', 100, attr_);
   END IF;
   Client_SYS.Add_To_Attr('PLANNING_METHOD_AUTO', Fnd_Boolean_API.Decode('TRUE'), attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT INVENTORY_PART_PLANNING_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS   
BEGIN
   IF (newrec_.order_requisition IS NULL) THEN
      newrec_.order_requisition := Inventory_Part_Supply_Type_API.DB_REQUISITION;
   END IF;
   
   super(objid_, objversion_, newrec_, attr_);
   Client_SYS.Add_To_Attr('OLD_SAFETY_STOCK', newrec_.old_safety_stock, attr_);
   Client_SYS.Add_To_Attr('OLD_ORDER_POINT_QTY', newrec_.old_order_point_qty, attr_);
   
   $IF Component_Invpla_SYS.INSTALLED $THEN
      IF (Inv_Part_Planning_Method_API.Is_Order_Point_Or_Tpss(newrec_.planning_method)) AND 
         (Site_Ipr_Info_API.Get_Ipr_Active_Db(newrec_.contract) = Fnd_Boolean_API.DB_TRUE) THEN 
         Inventory_Part_Invpla_Info_API.New(newrec_.contract, newrec_.part_no, newrec_.planning_method);     
      END IF;
   $END
   $IF (Component_Mrp_SYS.INSTALLED) $THEN
      IF newrec_.planning_method = 'H' THEN
         Ddmrp_Buffer_Part_Attrib_API.New(newrec_.contract, newrec_.part_no); 
      END IF;
   $END
END Insert___;


@Override
PROCEDURE Update___ (
   objid_                           IN     VARCHAR2,
   oldrec_                          IN     INVENTORY_PART_PLANNING_TAB%ROWTYPE,
   newrec_                          IN OUT INVENTORY_PART_PLANNING_TAB%ROWTYPE,
   attr_                            IN OUT VARCHAR2,
   objversion_                      IN OUT VARCHAR2,
   by_keys_                         IN     BOOLEAN DEFAULT FALSE,
   set_latest_plan_activity_time_   IN     BOOLEAN DEFAULT TRUE )
IS   
   check_multisite_  BOOLEAN := FALSE;
   raise_warning_    NUMBER;
   part_rec_         Inventory_Part_API.Public_Rec;
   part_rec_fetched_ BOOLEAN := FALSE;
   status_rec_       Inventory_Part_Status_Par_API.Public_Rec;
BEGIN
   
   $IF Component_Invpla_SYS.INSTALLED $THEN
      IF (newrec_.planning_method = 'B') AND 
         (Site_Ipr_Info_API.Get_Ipr_Active_Db(newrec_.contract) = Fnd_Boolean_API.DB_TRUE) THEN
            newrec_.lot_size_auto        := 'N';      
            newrec_.order_point_qty_auto := 'N';
            newrec_.safety_stock_auto    := 'N';
      END IF;
   $END
   
   IF oldrec_.order_requisition != newrec_.order_requisition THEN
      IF (oldrec_.order_requisition = 'D') OR  (newrec_.order_requisition = 'D') THEN
         $IF Component_Mfgstd_SYS.INSTALLED $THEN         
            Manuf_Structure_Util_API.Check_Order_Requis_Change ( newrec_.contract, newrec_.part_no, newrec_.order_requisition);
         $ELSE   
            NULL;
         $END
      END IF;
   END IF;

   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   Invalidate_Cache___;

   Inventory_Part_API.Set_Avail_Activity_Status(newrec_.contract, newrec_.part_no);
   IF oldrec_.planning_method != newrec_.planning_method THEN
      $IF Component_Mfgstd_SYS.INSTALLED $THEN
         Manuf_Structure_Util_API.Convert_Plan_Structure ( newrec_.contract, newrec_.part_no, oldrec_.planning_method, newrec_.planning_method );         
      $ELSE
         NULL;
      $END
   END IF;

   $IF Component_Massch_SYS.INSTALLED $THEN
      IF newrec_.proposal_release = 'DO NOT RELEASE' AND newrec_.proposal_release != oldrec_.proposal_release THEN
         -- A change of the proposal release flag to 'DO NOT RELEASE' has taken place
         -- and update of Create Requisition Flag in MASSCH has to be done as well.
         Level_1_Part_API.Modify_Create_Req(newrec_.contract, newrec_.part_no, 'N');
      END IF;
      IF newrec_.shrinkage_fac != oldrec_.shrinkage_fac THEN
         Level_1_Part_API.Modify_MS_Receipt(newrec_.contract, newrec_.part_no);
      END IF;
   $END

   -- Multi-site MRP
   $IF Component_Purch_SYS.INSTALLED $THEN   
      check_multisite_ := (Validate_SYS.Is_Changed(oldrec_.split_manuf_acquired, newrec_.split_manuf_acquired))
                          OR
                          ((newrec_.split_manuf_acquired = 'SPLIT') AND (Validate_SYS.Is_Changed(oldrec_.acquired_supply_type, newrec_.acquired_supply_type)))
                          OR
                          ((newrec_.split_manuf_acquired = 'NO_SPLIT') AND (Validate_SYS.Is_Changed(oldrec_.order_requisition, newrec_.order_requisition)));

      IF (check_multisite_) THEN
         raise_warning_ := Supply_Source_Part_Manager_API.Is_Multisite_Supp_Sched_Part(newrec_.contract, newrec_.part_no);        

         IF (raise_warning_ = 1) THEN
            Client_SYS.Add_Info(lu_name_,'DO_GENERATE: DO supply will be generated instead of Supplier Schedule for multi-site schedule part :P1', newrec_.part_no);
         END IF;
      END IF;
   $END

   IF (set_latest_plan_activity_time_) THEN
      -- set_latest_plan_activity_time_ is FALSE when the attributes below are updated from the
      -- Demand Planning server (IPR). In that case there is no point in adding the old values
      -- to the attribute string.
      
      IF (Validate_SYS.Is_Changed(oldrec_.lot_size, newrec_.lot_size)) THEN
         Client_SYS.Add_To_Attr('OLD_LOT_SIZE', newrec_.old_lot_size, attr_);
      END IF;
      IF (Validate_SYS.Is_Changed(oldrec_.safety_stock, newrec_.safety_stock))THEN
         Client_SYS.Add_To_Attr('OLD_SAFETY_STOCK', newrec_.old_safety_stock, attr_);
      END IF;
      IF (Validate_SYS.Is_Changed(oldrec_.order_point_qty, newrec_.order_point_qty))THEN
         Client_SYS.Add_To_Attr('OLD_ORDER_POINT_QTY', newrec_.old_order_point_qty, attr_);
      END IF;
   END IF;
   
   $IF Component_Purch_SYS.INSTALLED $THEN
      IF (oldrec_.split_manuf_acquired = 'NO_SPLIT') AND (newrec_.split_manuf_acquired = 'SPLIT') THEN
         IF NOT (part_rec_fetched_) THEN
            part_rec_         := Inventory_Part_API.Get(newrec_.contract, newrec_.part_no);
            part_rec_fetched_ := TRUE;
         END IF;

         IF (part_rec_.lead_time_code='M') THEN         
            IF (Purchase_Part_API.Check_Exist(newrec_.contract, newrec_.part_no) = 1) THEN
               Purchase_Part_API.Set_Inventory_Flag(newrec_.contract, newrec_.part_no, Inventory_Flag_API.Decode('Y'));
            ELSE
               Purchase_Part_API.New(newrec_.contract, newrec_.part_no, Inventory_Part_API.Get_Description(newrec_.contract, newrec_.part_no), part_rec_.unit_meas);
            END IF;                  
         END IF;
      END IF;
   $END
   
   $IF Component_Invpla_SYS.INSTALLED $THEN
      IF (Validate_SYS.Is_Changed(oldrec_.service_rate, newrec_.service_rate)  OR
          Validate_SYS.Is_Changed(oldrec_.setup_cost, newrec_.setup_cost) OR
          Validate_SYS.Is_Changed(oldrec_.carry_rate, newrec_.carry_rate) OR
          Validate_SYS.Is_Changed(oldrec_.qty_predicted_consumption, newrec_.qty_predicted_consumption) OR
          Validate_SYS.Is_Changed(oldrec_.min_order_qty, newrec_.min_order_qty) OR
          Validate_SYS.Is_Changed(oldrec_.safety_stock, newrec_.safety_stock) OR
          Validate_SYS.Is_Changed(oldrec_.order_point_qty, newrec_.order_point_qty) OR
          Validate_SYS.Is_Changed(oldrec_.lot_size, newrec_.lot_size) OR
          Validate_SYS.Is_Changed(oldrec_.max_order_qty, newrec_.max_order_qty) OR
          Validate_SYS.Is_Changed(oldrec_.mul_order_qty, newrec_.mul_order_qty) OR
          Validate_SYS.Is_Changed(oldrec_.planning_method, newrec_.planning_method)) AND
          (Site_Ipr_Info_API.Get_Ipr_Active_Db(oldrec_.contract) = Fnd_Boolean_API.DB_TRUE) THEN

         IF (Inv_Part_Planning_Method_API.Is_Order_Point_Or_Tpss(oldrec_.planning_method) OR 
             Inv_Part_Planning_Method_API.Is_Order_Point_Or_Tpss(newrec_.planning_method))THEN
            IF (Inv_Part_Planning_Method_API.Is_Order_Point_Or_Tpss(newrec_.planning_method) AND Validate_SYS.Is_Changed(oldrec_.planning_method, newrec_.planning_method)) THEN 
               -- the part has become a eligible for Order Point Planning or Time Phased Safety Stock Planning.               
               Inventory_Part_Invpla_Info_API.New(newrec_.contract, newrec_.part_no, newrec_.planning_method);   
            ELSIF(Validate_SYS.Is_Changed(oldrec_.safety_stock, newrec_.safety_stock) OR
                  Validate_SYS.Is_Changed(oldrec_.order_point_qty, newrec_.order_point_qty) OR
                  Validate_SYS.Is_Changed(oldrec_.lot_size, newrec_.lot_size)) THEN
               Inventory_Part_Invpla_Info_API.Set_Latest_Plan_Activity_Time( newrec_.contract, newrec_.part_no);
            END IF;

            IF (set_latest_plan_activity_time_ AND (Site_Ipr_Info_API.Get_Ipr_Active_Db(newrec_.contract) = Fnd_Boolean_API.DB_TRUE)) THEN
               IF NOT (part_rec_fetched_) THEN
                  part_rec_         := Inventory_Part_API.Get(newrec_.contract, newrec_.part_no);
                  part_rec_fetched_ := TRUE;
               END IF;

               IF (part_rec_.stock_management = 'SYSTEM MANAGED INVENTORY') THEN
                  status_rec_ := Inventory_Part_Status_Par_API.Get(part_rec_.part_status);

                  IF ((status_rec_.onhand_flag = 'Y') AND (status_rec_.supply_flag = 'Y')) THEN
                     Inventory_Part_Invpla_Info_API.Set_Latest_Plan_Activity_Time( newrec_.contract, newrec_.part_no);                             
                  END IF;
               END IF;
            END IF;
         END IF;
      END IF;
   $END

    $IF (Component_Cbsint_SYS.INSTALLED) $THEN
      IF newrec_.sched_capacity != oldrec_.sched_capacity THEN
         Cbs_So_Int_API.Material_Capacity_Changed(newrec_.contract,
                                                      newrec_.part_no,
                                                      oldrec_.sched_capacity,
                                                      newrec_.sched_capacity);   
      END IF;
   $END
   
   $IF (Component_Mrp_SYS.INSTALLED) $THEN
      IF ((oldrec_.planning_method != 'H') AND
          (newrec_.planning_method  = 'H')) THEN
         Ddmrp_Buffer_Part_Attrib_API.New(newrec_.contract, newrec_.part_no);
      ELSIF ((oldrec_.planning_method = 'H') AND
             (newrec_.planning_method != 'H')) THEN
         Ddmrp_Log_API.Remove_Logs(newrec_.contract, newrec_.part_no);
      END IF;
   $END
   
END Update___;


PROCEDURE Get_From_Asset_Class___ (
   numeric_value_        OUT NUMBER,
   latest_activity_time_ OUT DATE,
   asset_class_          IN  VARCHAR2,
   company_              IN  VARCHAR2,
   attribute_            IN  NUMBER )
IS
   asset_class_rec_  Asset_Class_Company_API.Public_Rec;
BEGIN
   asset_class_rec_      := Asset_Class_Company_API.Get(asset_class_, company_);
   latest_activity_time_ := NVL(asset_class_rec_.rowversion,
                                Database_SYS.first_calendar_date_);
   numeric_value_        :=
      CASE attribute_
         WHEN the_service_level_rate_        THEN asset_class_rec_.service_level_rate
         WHEN the_ordering_cost_             THEN asset_class_rec_.ordering_cost
         WHEN the_inventory_interest_rate_   THEN asset_class_rec_.inventory_interest_rate
         ELSE NULL END;
END Get_From_Asset_Class___;


PROCEDURE Get_From_Commodity_Group___ (
   numeric_value_        OUT NUMBER,
   latest_activity_time_ OUT DATE,
   commodity_code_       IN  VARCHAR2,
   company_              IN  VARCHAR2,
   attribute_            IN  NUMBER )
IS
   commodity_rec_ Commodity_Group_Company_API.Public_Rec;
BEGIN
   commodity_rec_        := Commodity_Group_Company_API.Get(commodity_code_, company_);
   latest_activity_time_ := NVL(commodity_rec_.rowversion,
                                Database_SYS.first_calendar_date_);
   numeric_value_        :=
      CASE attribute_
         WHEN the_service_level_rate_        THEN commodity_rec_.service_level_rate
         WHEN the_ordering_cost_             THEN commodity_rec_.ordering_cost
         WHEN the_inventory_interest_rate_   THEN commodity_rec_.inventory_interest_rate
         ELSE NULL END;
END Get_From_Commodity_Group___;


PROCEDURE Get_From_Company___ (
   numeric_value_        OUT NUMBER,
   latest_activity_time_ OUT DATE,
   company_              IN  VARCHAR2,
   attribute_            IN  NUMBER )
IS
   company_rec_ Company_Invent_Info_API.Public_Rec;
BEGIN
   company_rec_          := Company_Invent_Info_API.Get(company_);
   latest_activity_time_ := company_rec_.rowversion;
   numeric_value_        :=
      CASE attribute_
         WHEN the_service_level_rate_        THEN company_rec_.service_level_rate
         WHEN the_ordering_cost_             THEN company_rec_.ordering_cost
         WHEN the_inventory_interest_rate_   THEN company_rec_.inventory_interest_rate
         ELSE NULL END;
END Get_From_Company___;


PROCEDURE Get_From_Inventory_Part___ (
   numeric_value_        OUT NUMBER,
   latest_activity_time_ OUT DATE,
   contract_             IN  VARCHAR2,
   part_no_              IN  VARCHAR2,
   attribute_            IN  NUMBER )
IS
BEGIN
   Update_Cache___(contract_, part_no_);
   latest_activity_time_ := Database_SYS.first_calendar_date_;

   numeric_value_        :=
      CASE attribute_
         WHEN the_service_level_rate_        THEN micro_cache_value_.service_rate
         WHEN the_ordering_cost_             THEN micro_cache_value_.setup_cost
         WHEN the_inventory_interest_rate_   THEN micro_cache_value_.carry_rate
         ELSE NULL END;
END Get_From_Inventory_Part___;


PROCEDURE Get_From_Site___ (
   numeric_value_        OUT NUMBER,
   latest_activity_time_ OUT DATE,
   contract_             IN  VARCHAR2,
   attribute_            IN  NUMBER )
IS
   site_rec_   Site_Invent_Info_API.Public_Rec;
BEGIN
   site_rec_             := Site_Invent_Info_API.Get(contract_);
   latest_activity_time_ := NVL(site_rec_.latest_plan_activity_time, Database_SYS.first_calendar_date_);
   numeric_value_        :=
      CASE attribute_
         WHEN the_service_level_rate_        THEN site_rec_.service_level_rate
         WHEN the_ordering_cost_             THEN site_rec_.ordering_cost
         WHEN the_inventory_interest_rate_   THEN site_rec_.inventory_interest_rate
         ELSE NULL END;
END Get_From_Site___;


PROCEDURE Get_From_Supplier___ (
   numeric_value_        OUT NUMBER,
   latest_activity_time_ OUT DATE,
   supplier_id_          IN  VARCHAR2,
   company_              IN  VARCHAR2,
   attribute_            IN  NUMBER )
IS   
   latest_activity_           DATE;
   service_level_rate_        NUMBER;
   ordering_cost_             NUMBER;
   inventory_interest_rate_   NUMBER;
BEGIN

   $IF Component_Purch_SYS.INSTALLED $THEN
      DECLARE
         supplier_rec_  Supplier_Company_Purch_API.Public_Rec;
      BEGIN
         supplier_rec_  := Supplier_Company_Purch_API.Get(supplier_id_, company_);
         latest_activity_           := supplier_rec_.latest_activity_time;
         service_level_rate_        := supplier_rec_.service_level_rate;
         ordering_cost_             := supplier_rec_.ordering_cost;
         inventory_interest_rate_   := supplier_rec_.inventory_interest_rate;
      END;      
      latest_activity_time_ := NVL(latest_activity_,
                                   Database_SYS.first_calendar_date_);
      numeric_value_        :=
         CASE attribute_
            WHEN the_service_level_rate_        THEN service_level_rate_
            WHEN the_ordering_cost_             THEN ordering_cost_
            WHEN the_inventory_interest_rate_   THEN inventory_interest_rate_
            ELSE NULL END;
   $ELSE
      numeric_value_          := NULL;
      latest_activity_time_   := Database_SYS.first_calendar_date_;
   $END
END Get_From_Supplier___;


FUNCTION Get_Primary_Supplier___ (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN VARCHAR2
IS   
   supplier_id_ VARCHAR2(20);
BEGIN
   $IF Component_Purch_SYS.INSTALLED $THEN
      supplier_id_ := Purchase_Part_Supplier_API.Get_Primary_Supplier_No(contract_, part_no_);
   $ELSE
      supplier_id_ := NULL;
   $END
   RETURN (supplier_id_);
END Get_Primary_Supplier___;


PROCEDURE Get_From_Abc_Frequency_Life___ (
   numeric_value_        OUT NUMBER,
   latest_activity_time_ OUT DATE,
   abc_class_            IN  VARCHAR2,
   frequency_class_db_   IN  VARCHAR2,
   lifecycle_stage_db_   IN  VARCHAR2,
   company_              IN  VARCHAR2,
   contract_             IN  VARCHAR2,
   attribute_            IN  NUMBER )
IS
   abc_freq_life_rec_ Abc_Frequency_Lifecycle_API.Public_Rec;
BEGIN
   abc_freq_life_rec_    := Abc_Frequency_Lifecycle_API.Get(abc_class_,
                                                            company_,
                                                            contract_,
                                                            frequency_class_db_,
                                                            lifecycle_stage_db_);

   latest_activity_time_ := NVL(abc_freq_life_rec_.rowversion,
                                Database_SYS.first_calendar_date_);
   numeric_value_        :=
      CASE attribute_
         WHEN the_service_level_rate_        THEN abc_freq_life_rec_.service_level_rate
         WHEN the_ordering_cost_             THEN abc_freq_life_rec_.ordering_cost
         WHEN the_inventory_interest_rate_   THEN abc_freq_life_rec_.inventory_interest_rate
         ELSE NULL END;
         
   IF (numeric_value_ IS NULL AND (contract_ != Abc_Frequency_Lifecycle_API.all_sites_config_)) THEN 
      Get_From_Abc_Frequency_Life___(numeric_value_,
                                     latest_activity_time_,
                                     abc_class_,
                                     frequency_class_db_,
                                     lifecycle_stage_db_,
                                     company_,
                                     Abc_Frequency_Lifecycle_API.all_sites_config_,
                                     attribute_);
   END IF;
END Get_From_Abc_Frequency_Life___;

FUNCTION Get_Next_Order_Date___(
   contract_          IN VARCHAR2,
   part_no_           IN VARCHAR2,
   shortage_date_     IN DATE,
   today_             IN DATE,
   expected_leadtime_ IN NUMBER,
   vendor_no_         IN VARCHAR2) RETURN DATE
IS
   next_order_date_             DATE;
   latest_possible_ord_date_    DATE;

BEGIN
   next_order_date_ := NVL(shortage_date_, today_) - expected_leadtime_;
   $IF Component_Purch_SYS.INSTALLED $THEN
      -- **************************************************************************************
      -- *  This will fetch the latest  possible order date, we need to place the order       *
      -- *  in order to get the goods delivered by the shortage date. This will calculate the *
      -- *  date according to the purchasing lead times. (Similar to the latest order date    *
      -- *  calcualtion in purchase order line)                                               *
      -- **************************************************************************************
      latest_possible_ord_date_ := Pur_Ord_Date_Calculation_API.Get_Latest_Possible_Order_Date(contract_                   => contract_,
                                                                                               part_no_                    => part_no_,
                                                                                               vendor_no_                  => vendor_no_,
                                                                                               addr_no_                    => NULL,
                                                                                               ship_via_code_              => NULL,
                                                                                               ext_transport_calendar_id_  => NULL,
                                                                                               receipt_date_               => shortage_date_,
                                                                                               po_internal_control_time_   => NULL,
                                                                                               route_id_                   => NULL,
                                                                                               date_entered_               => today_,
                                                                                               show_errors_                => FALSE);
         
      IF latest_possible_ord_date_ IS NOT NULL THEN 
         next_order_date_ := LEAST(next_order_date_, latest_possible_ord_date_);
      END IF;
   $END 
   
   RETURN next_order_date_;
END Get_Next_Order_Date___;

PROCEDURE Next_Order_Analysis_Slow___ (
   next_order_date_              OUT     DATE,
   projected_qty_onhand_         OUT     NUMBER,
   estimated_daily_demand_       IN  OUT NUMBER,
   estimated_demand_expiry_date_ IN  OUT DATE,
   contract_                     IN      VARCHAR2,
   part_no_                      IN      VARCHAR2,
   today_                        IN      DATE,
   stop_analysis_date_           IN      DATE,
   order_point_qty_              IN      INVENTORY_PART_PLANNING_TAB.order_point_qty%TYPE,
   expected_leadtime_            IN      NUMBER,
   current_qty_on_hand_          IN      NUMBER,
   supply_demand_date_tab_       IN      Order_Supply_Demand_API.Supply_Demand_Date_Tab,
   vendor_no_                    IN      VARCHAR2)
IS
   shortage_date_                DATE;
   analysis_date_                DATE;
   late_supply_demand_qty_       NUMBER := 0;
   analysis_date_qty_supply_     NUMBER;
   analysis_date_qty_demand_     NUMBER;
   index_                        PLS_INTEGER;
   future_supply_demand_exists_  BOOLEAN := FALSE;
   on_or_below_order_point_      BOOLEAN := FALSE;
   qty_onhand_on_shortage_date_  NUMBER;
BEGIN

   next_order_date_ := Database_Sys.last_calendar_date_;

   IF (supply_demand_date_tab_.COUNT > 0) THEN
      FOR i IN supply_demand_date_tab_.FIRST..supply_demand_date_tab_.LAST LOOP

         IF (supply_demand_date_tab_(i).date_required > today_) THEN
            future_supply_demand_exists_ := TRUE;
            index_                       := i;
            EXIT;
         END IF;

         late_supply_demand_qty_ := late_supply_demand_qty_ +
                                    supply_demand_date_tab_(i).qty_supply -
                                    supply_demand_date_tab_(i).qty_demand;
      END LOOP;
   END IF;

   projected_qty_onhand_ := current_qty_on_hand_ + late_supply_demand_qty_;

   FOR date_counter_ IN 1..365 LOOP

      analysis_date_            := today_ + date_counter_;
      analysis_date_qty_supply_ := 0;
      analysis_date_qty_demand_ := 0;

      IF (analysis_date_ > estimated_demand_expiry_date_) THEN

         Get_Forecasted_Daily_Demand___(estimated_demand_expiry_date_,
                                        estimated_daily_demand_,
                                        contract_,
                                        part_no_,
                                        analysis_date_);
      END IF;

      IF (future_supply_demand_exists_) THEN
         future_supply_demand_exists_ := FALSE;
         FOR i IN index_..supply_demand_date_tab_.LAST LOOP

            IF (supply_demand_date_tab_(i).date_required = analysis_date_) THEN

               analysis_date_qty_supply_ := supply_demand_date_tab_(i).qty_supply;
               analysis_date_qty_demand_ := supply_demand_date_tab_(i).qty_demand;

            ELSIF (supply_demand_date_tab_(i).date_required > analysis_date_) THEN
               future_supply_demand_exists_ := TRUE;
               index_                       := i;
               EXIT;
            END IF;

         END LOOP;
      END IF;

      projected_qty_onhand_ := projected_qty_onhand_ + analysis_date_qty_supply_ - 
                               GREATEST(estimated_daily_demand_, analysis_date_qty_demand_);

      IF (projected_qty_onhand_ <= order_point_qty_) THEN
         IF (on_or_below_order_point_) THEN
            IF (analysis_date_ > GREATEST((shortage_date_ + expected_leadtime_), stop_analysis_date_)) THEN
               projected_qty_onhand_ := qty_onhand_on_shortage_date_;
               EXIT;
            END IF;
         ELSE
            on_or_below_order_point_     := TRUE;
            shortage_date_               := analysis_date_;
            qty_onhand_on_shortage_date_ := projected_qty_onhand_;
         END IF;
      ELSE
         on_or_below_order_point_ := FALSE;
      END IF;
   END LOOP;

   IF (projected_qty_onhand_ <= order_point_qty_) THEN
      next_order_date_ := Get_Next_Order_Date___(contract_, part_no_, (NVL(shortage_date_, today_) + expected_leadtime_), today_, expected_leadtime_, vendor_no_);
   END IF;

END Next_Order_Analysis_Slow___;


PROCEDURE Next_Order_Analysis_Others___ (
   next_order_date_              OUT     DATE,
   projected_qty_onhand_         OUT     NUMBER,
   estimated_daily_demand_       IN  OUT NUMBER,
   estimated_demand_expiry_date_ IN  OUT DATE,
   contract_                     IN      VARCHAR2,
   part_no_                      IN      VARCHAR2,
   today_                        IN      DATE,
   stop_analysis_date_           IN      DATE,
   safety_stock_                 IN      INVENTORY_PART_PLANNING_TAB.safety_stock%TYPE,
   expected_leadtime_            IN      NUMBER,
   current_qty_on_hand_          IN      NUMBER,
   supply_demand_date_tab_       IN      Order_Supply_Demand_API.Supply_Demand_Date_Tab,
   vendor_no_                    IN      VARCHAR2)
IS
   shortage_date_                 DATE;
   analysis_date_                 DATE;
   estimate_projected_qty_onhand_ NUMBER;
   order_projected_qty_onhand_    NUMBER;
   late_supply_demand_qty_        NUMBER := 0;
   index_                         PLS_INTEGER;
   future_supply_demand_exists_   BOOLEAN := FALSE;
BEGIN

   next_order_date_ := Database_Sys.last_calendar_date_;

   IF (supply_demand_date_tab_.COUNT > 0) THEN
      FOR i IN supply_demand_date_tab_.FIRST..supply_demand_date_tab_.LAST LOOP

         IF (supply_demand_date_tab_(i).date_required > today_) THEN
            future_supply_demand_exists_ := TRUE;
            index_                       := i;
            EXIT;
         END IF;

         late_supply_demand_qty_ := late_supply_demand_qty_ +
                                    supply_demand_date_tab_(i).qty_supply -
                                    supply_demand_date_tab_(i).qty_demand;
      END LOOP;
   END IF;

   estimate_projected_qty_onhand_  := current_qty_on_hand_ + late_supply_demand_qty_;
   order_projected_qty_onhand_     := current_qty_on_hand_ + late_supply_demand_qty_;

   FOR date_counter_ IN 1..365 LOOP

      analysis_date_ := today_ + date_counter_;

      IF (analysis_date_ > estimated_demand_expiry_date_) THEN

         Get_Forecasted_Daily_Demand___(estimated_demand_expiry_date_,
                                        estimated_daily_demand_,
                                        contract_,
                                        part_no_,
                                        analysis_date_);
      END IF;

      estimate_projected_qty_onhand_ := estimate_projected_qty_onhand_ - estimated_daily_demand_;

      IF (future_supply_demand_exists_) THEN
         future_supply_demand_exists_ := FALSE;
         FOR i IN index_..supply_demand_date_tab_.LAST LOOP

            IF (supply_demand_date_tab_(i).date_required = analysis_date_) THEN

               estimate_projected_qty_onhand_ := estimate_projected_qty_onhand_ + 
                                                 supply_demand_date_tab_(i).qty_supply;

               order_projected_qty_onhand_    := order_projected_qty_onhand_ + 
                                                 supply_demand_date_tab_(i).qty_supply -
                                                 supply_demand_date_tab_(i).qty_demand;

            ELSIF (supply_demand_date_tab_(i).date_required > analysis_date_) THEN
               future_supply_demand_exists_ := TRUE;
               index_                       := i;
               EXIT;
            END IF;

         END LOOP;
      END IF;

      IF ((estimate_projected_qty_onhand_ <= safety_stock_) OR 
          (order_projected_qty_onhand_    <= safety_stock_)) THEN

         IF (shortage_date_ IS NULL) THEN
            -- Save the date for the first detected shortage
            shortage_date_ := analysis_date_;
         END IF;

         IF (analysis_date_ >= stop_analysis_date_) THEN
            -- Don't end the analysis until we have passed the lead time fence
            EXIT;
         END IF;
      ELSE
         -- IF the projected on hand qty gets above safety stock the disregard any earlier
         -- detected shortage within the lead time fence.
         shortage_date_ := NULL;
      END IF;
   END LOOP;

   IF ((estimate_projected_qty_onhand_ <= safety_stock_) OR 
       (order_projected_qty_onhand_    <= safety_stock_)) THEN
      next_order_date_ := Get_Next_Order_Date___(contract_, part_no_, shortage_date_, today_, expected_leadtime_, vendor_no_);
   END IF;

   projected_qty_onhand_ := LEAST(estimate_projected_qty_onhand_, order_projected_qty_onhand_);

END Next_Order_Analysis_Others___;


FUNCTION Slow_Movers_Or_Croston___ (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN BOOLEAN
IS
   order_point_model_db_   VARCHAR2(25);
   slow_movers_or_croston_ BOOLEAN := FALSE;
BEGIN
   $IF Component_Invpla_SYS.INSTALLED $THEN
      IF (Site_Ipr_Info_API.Get_Ipr_Active_Db(contract_) = Fnd_Boolean_API.DB_TRUE) THEN 
         order_point_model_db_ := Inventory_Part_Invpla_Info_API.Get_Order_Point_Model_Db(contract_, part_no_);
         IF (order_point_model_db_ IN ('SLOW MOVERS - LIFECYCLE', 'SLOW MOVERS - LEAD TIME', 
                                       'CROSTON - LIFECYCLE', 'CROSTON - LEAD TIME')) THEN
            slow_movers_or_croston_ := TRUE;
         END IF;
      END IF;
   $ELSE
      NULL;
   $END
 
   RETURN (slow_movers_or_croston_);
END Slow_Movers_Or_Croston___;


FUNCTION Auto_Update_Order_Point___ (
   record_ IN INVENTORY_PART_PLANNING_TAB%ROWTYPE ) RETURN BOOLEAN
IS   
   auto_update_order_point_   BOOLEAN := FALSE;
BEGIN
   $IF Component_Invpla_SYS.INSTALLED $THEN
      IF (Site_Ipr_Info_API.Get_Ipr_Active_Db(record_.contract) = Fnd_Boolean_API.DB_TRUE) THEN 
         IF (record_.planning_method = 'B') THEN
            auto_update_order_point_ := Inventory_Part_Invpla_Info_API.Auto_Update_Order_Point(record_.contract, record_.part_no);
         ELSE
            IF (record_.order_point_qty_auto = 'Y') THEN
               auto_update_order_point_ := TRUE;
            END IF;
         END IF;
      END IF;
   $END
   RETURN (auto_update_order_point_);
END Auto_Update_Order_Point___;


FUNCTION Auto_Update_Safety_Stock___ (
   record_ IN INVENTORY_PART_PLANNING_TAB%ROWTYPE ) RETURN BOOLEAN
IS
   auto_update_safety_stock_  BOOLEAN := FALSE;
BEGIN
   $IF Component_Invpla_SYS.INSTALLED $THEN
      IF (Site_Ipr_Info_API.Get_Ipr_Active_Db(record_.contract) = Fnd_Boolean_API.DB_TRUE) THEN 
         IF (Inv_Part_Planning_Method_API.Is_Order_Point_Or_Tpss(record_.planning_method))THEN
            auto_update_safety_stock_ := Inventory_Part_Invpla_Info_API.Auto_Update_Safety_Stock(record_.contract, record_.part_no);
         ELSE
            IF (record_.safety_stock_auto = 'Y') THEN
               auto_update_safety_stock_ := TRUE;
            END IF;
         END IF;
      END IF;
   $END
   RETURN (auto_update_safety_stock_);
END Auto_Update_Safety_Stock___;


FUNCTION Auto_Update_Lot_Size___ (
   record_ IN INVENTORY_PART_PLANNING_TAB%ROWTYPE ) RETURN BOOLEAN
IS  
   auto_update_lot_size_   BOOLEAN := FALSE;
BEGIN
   $IF Component_Invpla_SYS.INSTALLED $THEN
      IF (Site_Ipr_Info_API.Get_Ipr_Active_Db(record_.contract) = Fnd_Boolean_API.DB_TRUE) THEN 
         IF (record_.planning_method = 'B') THEN
            auto_update_lot_size_ := Inventory_Part_Invpla_Info_API.Auto_Update_Lot_Size(record_.contract, record_.part_no);
         ELSE
            IF (record_.lot_size_auto = 'Y') THEN
               auto_update_lot_size_ := TRUE;
            END IF;
         END IF;
      END IF;
   $END
   RETURN (auto_update_lot_size_);
END Auto_Update_Lot_Size___;


FUNCTION Get_Demand_Model_Db___ (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN VARCHAR2
IS   
   demand_model_db_ VARCHAR2(25);
BEGIN
   $IF Component_Invpla_SYS.INSTALLED $THEN
      IF (Site_Ipr_Info_API.Get_Ipr_Active_Db(contract_) = Fnd_Boolean_API.DB_TRUE) THEN 
         demand_model_db_ := Inventory_Part_Invpla_Info_API.Get_Demand_Model_Db(contract_, part_no_);
      END IF;
   $ELSE
      demand_model_db_ := NULL;
   $END

   RETURN (demand_model_db_);
END Get_Demand_Model_Db___;


FUNCTION Get_Historical_Daily_Demand___ (
   contract_          IN VARCHAR2,
   part_no_           IN VARCHAR2,
   expected_leadtime_ IN NUMBER,
   today_             IN DATE ) RETURN NUMBER
IS   
   historical_daily_demand_ NUMBER;
BEGIN
   $IF Component_Invpla_SYS.INSTALLED $THEN
      IF (Site_Ipr_Info_API.Get_Ipr_Active_Db(contract_) = Fnd_Boolean_API.DB_TRUE) THEN 
         historical_daily_demand_ := Inventory_Part_Invpla_Info_API.Get_Historical_Daily_Demand(contract_, part_no_,expected_leadtime_,today_);
      END IF;
   $ELSE
      historical_daily_demand_ := NULL;
   $END
  
   RETURN (historical_daily_demand_);
END Get_Historical_Daily_Demand___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     inventory_part_planning_tab%ROWTYPE,
   newrec_ IN OUT NOCOPY inventory_part_planning_tab%ROWTYPE,
   indrec_ IN OUT NOCOPY Indicator_Rec,
   attr_   IN OUT NOCOPY VARCHAR2 )
IS
   inv_part_rec_   Inventory_Part_API.Public_Rec;
BEGIN    
   super(oldrec_,newrec_,indrec_,attr_);
   
   IF (newrec_.sched_capacity != oldrec_.sched_capacity) THEN
      
      inv_part_rec_ := Inventory_Part_API.Get(newrec_.contract, newrec_.part_no );
      
      IF newrec_.sched_capacity = 'F' THEN
         IF inv_part_rec_.type_code IN ('3','4','6') THEN
            IF inv_part_rec_.purch_leadtime = 0 THEN
               Error_SYS.Record_General(lu_name_, 'FPURCHZEROLT: Leadtime for purchased part with finite capacity cannot be zero.');
            END IF;
         ELSIF inv_part_rec_.type_code IN ('1','2') THEN
            $IF Component_Mfgstd_SYS.INSTALLED $THEN
               IF NVL(Manuf_Part_Attribute_API.Get_Cum_Leadtime(newrec_.contract, newrec_.part_no),0) = 0 THEN
                  Error_SYS.Record_General(lu_name_, 'FMFGZEROLT: Cummulative leadtime for manufactured part with finite capacity cannot be zero.');
               END IF;
            $ELSE
               NULL;
            $END
         END IF;
      END IF;   
   END IF;
END Check_Common___;

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT inventory_part_planning_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   type_code_db_     VARCHAR2(8);
   
BEGIN
   -- Set default values.
   IF NOT(indrec_.planning_method) THEN
      newrec_.planning_method := 'A';
   END IF;
   
   IF NOT(indrec_.proposal_release) THEN
      newrec_.proposal_release := 'RELEASE';
   END IF;
   
   IF NOT(indrec_.split_manuf_acquired) THEN
      newrec_.split_manuf_acquired := 'NO_SPLIT';
   END IF;
   
   IF NOT(indrec_.manuf_supply_type) THEN
      newrec_.manuf_supply_type := 'R';
   END IF;
   
   IF NOT(indrec_.acquired_supply_type) THEN
      newrec_.acquired_supply_type := 'R';
   END IF;
   
   IF NOT(indrec_.planning_method_auto) THEN
      newrec_.planning_method_auto := 'TRUE';
   END IF;

   
   type_code_db_ := Inventory_Part_API.Get_Type_Code_Db(newrec_.contract, newrec_.part_no);
   IF newrec_.Split_Manuf_Acquired = 'NO_SPLIT' THEN
      -- '1', '2' = Manufactured, Manufactured Recipe
      IF type_code_db_ IN ('1', '2') THEN
         newrec_.percent_manufactured := 100;
         newrec_.percent_acquired     := 0;
      ELSE
         newrec_.percent_manufactured := 0;
         newrec_.percent_acquired     := 100;
      END IF;
   END IF;

   newrec_.old_lot_size := newrec_.lot_size;
   newrec_.old_order_point_qty := newrec_.order_point_qty;
   newrec_.old_safety_stock := newrec_.safety_stock;
   
   IF newrec_.sched_capacity IS NULL THEN
      newrec_.sched_capacity := 'I';
   END IF;    

   IF NOT(indrec_.safety_lead_time) THEN
      newrec_.safety_lead_time := 0;
   END IF;

   super(newrec_, indrec_, attr_);  
  

   IF newrec_.shrinkage_fac >= 100 THEN
      Error_SYS.Record_General (lu_name_,'SCRAPLT100: Scrap factor must be less than 100.');
   END IF;
   IF newrec_.shrinkage_fac < 0 THEN
      Error_SYS.Record_General (lu_name_,'SCRAPGE0: Scrap factor must be greater than or equal to 0.');
   END IF;

   Validate_Order_Requisition(newrec_.contract,
                              newrec_.part_no,
                              Inventory_Part_Supply_Type_API.Decode(newrec_.order_requisition),
                              Inventory_Part_API.Get_Type_Code(newrec_.contract, newrec_.part_no));

   Check_Manuf_Acquired_Split___(newrec_.part_no, 
                                 newrec_.planning_method, 
                                 type_code_db_,
                                 newrec_.split_manuf_acquired, 
                                 newrec_.percent_manufactured, 
                                 newrec_.percent_acquired);

   IF (newrec_.qty_predicted_consumption < 0) THEN
     Raise_Pred_Negative_Error___();
   END IF;

   -- Attribute mapping in Check_Hierarchy_attributes call:
   -- service_rate = service_level_rate
   -- setup_cost = ordering_cost
   -- carry_rate = inventory_interest_rate
   Company_Invent_Info_API.Check_Hierarchy_Attributes(newrec_.service_rate,
                                                      newrec_.setup_cost,
                                                      newrec_.carry_rate);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     inventory_part_planning_tab%ROWTYPE,
   newrec_ IN OUT inventory_part_planning_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   part_cat_rec_               Part_Catalog_API.Public_Rec;  
   type_code_db_               VARCHAR2(8);
   automatic_capability_check_ VARCHAR2(200);
BEGIN
   IF( oldrec_.lot_size != newrec_.lot_size) THEN
      newrec_.old_lot_size := oldrec_.lot_size;
   END IF;
   IF (oldrec_.order_point_qty != newrec_.order_point_qty) THEN
      newrec_.old_order_point_qty := oldrec_.order_point_qty;
   END IF;
   IF (oldrec_.safety_stock != newrec_.safety_stock) THEN 
      newrec_.old_safety_stock := oldrec_.safety_stock;
   END IF;

   super(oldrec_, newrec_, indrec_, attr_);
   
   type_code_db_ := Inventory_Part_API.Get_Type_Code_Db(newrec_.contract, newrec_.part_no);

   IF (newrec_.split_manuf_acquired = 'NO_SPLIT') THEN
      IF (newrec_.split_manuf_acquired != oldrec_.split_manuf_acquired ) THEN
         IF type_code_db_ IN ('1', '2') THEN
            newrec_.percent_manufactured := 100;
            newrec_.percent_acquired     := 0;
         ELSE
            newrec_.percent_manufactured := 0;
            newrec_.percent_acquired     := 100;
         END IF;
      END IF;
   END IF;

   IF newrec_.shrinkage_fac >= 100 THEN
      Error_SYS.Record_General (lu_name_,'SCRAPLT100: Scrap factor must be less than 100.');
   END IF;
   IF newrec_.shrinkage_fac < 0 THEN
      Error_SYS.Record_General (lu_name_,'SCRAPGE0: Scrap factor must be greater than or equal to 0.');
   END IF;

   part_cat_rec_ := Part_Catalog_API.Get(newrec_.part_no);

   IF newrec_.order_requisition = 'S'  THEN
      IF (part_cat_rec_.configurable = 'CONFIGURED') THEN
         Error_SYS.Record_General('InventoryPartPlanning','CONFIGNOSCHED: Supply Type :P1 is not allowed for configurable parts.', Inventory_Part_Supply_Type_API.Decode('S'));
      END IF;
      $IF Component_Supsch_SYS.INSTALLED $THEN
         Supp_Sched_Agreement_API.Check_Sched_Generation(newrec_.contract, newrec_.part_no, newrec_.proposal_release);
      $END
   END IF;

   IF (newrec_.order_requisition != oldrec_.order_requisition) THEN
      $IF Component_Quaman_SYS.INSTALLED $THEN      
         Qman_Control_Plan_Manuf_API.Check_Order_Requisition_Change(newrec_.contract, newrec_.part_no, newrec_.order_requisition);
      $ELSE
         NULL;
      $END
   END IF;

   IF (newrec_.lot_size_auto = 'Y') OR (newrec_.order_point_qty_auto = 'Y') OR (newrec_.safety_stock_auto = 'Y') THEN
      IF (part_cat_rec_.configurable = 'CONFIGURED') THEN
         Error_SYS.Record_General('InventoryPartPlanning','CONFIGNOAUTO: This part is configurable and cannot use auto update.');
      END IF;
   END IF;

   IF (newrec_.lot_size < 0) THEN
      Error_SYS.Record_General('InventoryPartPlanning','LOT_SIZE_NEG: Lot Size cannot have a negative value.');
   END IF;

   IF (newrec_.maxweek_supply < 0) THEN
      Error_SYS.Record_General('InventoryPartPlanning','MAX_WEEK_NEG: Order cover time cannot have a negative value.');
   END IF;

   IF (newrec_.max_order_qty < 0) THEN
      Error_SYS.Record_General('InventoryPartPlanning','MAX_ORDER_NEG: Maximum O cannot have a negative value.');
   END IF;

   IF (newrec_.min_order_qty < 0) THEN
      Error_SYS.Record_General('InventoryPartPlanning','MIN_ORDER_NEG: Minimum lot size cannot have a negative value.');
   END IF;

   IF (newrec_.order_point_qty < 0) THEN
      Error_SYS.Record_General('InventoryPartPlanning','ORDER_POINT_NEG: Order point cannot have a negative value.');
   END IF;

   IF (newrec_.shrinkage_fac < 0) THEN
      Error_SYS.Record_General('InventoryPartPlanning','SHRINK_FAC_NEG: Scrap Factor cannot have a negative value.');
   END IF;

   IF (newrec_.mul_order_qty < 0) THEN
      Error_SYS.Record_General('InventoryPartPlanning','MUL_ORDER_NEG: Multiple lot size cannot have a negative value.');
   END IF;

   IF (newrec_.std_order_size < 0) THEN
      Error_SYS.Record_General('InventoryPartPlanning','STD_ORDER_NEG: Standard lot size cannot have a negative value.');
   END IF;

   IF (newrec_.safety_stock < 0) THEN
      Error_SYS.Record_General('InventoryPartPlanning','SAFETY_STOCK_NEG: Safety stock cannot have a negative value.');
   END IF;

   IF (newrec_.safety_lead_time < 0) THEN
      Error_SYS.Record_General('InventoryPartPlanning','SAFETY_LEAD_TIME_NEG: Safety lead time cannot have a negative value.');
   END IF;
   
   IF (newrec_.qty_predicted_consumption < 0) THEN
     Raise_Pred_Negative_Error___();
   END IF;

   IF ((newrec_.max_order_qty > 0 AND newrec_.max_order_qty < newrec_.min_order_qty ) OR
        (newrec_.max_order_qty > 0 and newrec_.max_order_qty < newrec_.mul_order_qty )) THEN
      Error_SYS.Record_General('InventoryPartPlanning','LOT_QTY_MIN: Maximum lot size must be > than minimum and mulitple lot size.');
   END IF;
   IF (newrec_.planning_method IN ('A', 'D', 'M', 'E', 'F', 'G', 'H')) THEN
      IF ((newrec_.std_order_size > 0 AND newrec_.std_order_size < newrec_.min_order_qty ) OR
          (newrec_.std_order_size > 0 AND newrec_.max_order_qty > 0 AND
            newrec_.std_order_size > newrec_.max_order_qty )) THEN
         Client_SYS.Add_Info('InventoryPartPlanning','LOT_QTY_STDMAXMIN: Standard lot size should normally be between maximum and minimum lot size.');
      END IF;
   END IF;

   Validate_Order_Requisition(newrec_.contract,
                              newrec_.part_no,
                              Inventory_Part_Supply_Type_API.Decode(newrec_.order_requisition),
                              Inventory_Part_API.Get_Type_Code(newrec_.contract, newrec_.part_no));

   Validate_Planning_Method___(newrec_.contract, 
                               newrec_.part_no, 
                               newrec_.planning_method,
                               newrec_.order_point_qty, 
                               newrec_.lot_size, 
                               newrec_.safety_stock,
                               newrec_.min_order_qty, 
                               newrec_.max_order_qty,
                               newrec_.mul_order_qty, 
                               newrec_.maxweek_supply, 
                               newrec_.order_point_qty_auto,
                               newrec_.lot_size_auto, 
                               newrec_.order_requisition);
   
   IF ((indrec_.safety_stock OR indrec_.safety_lead_time) AND ((newrec_.safety_stock > 0) AND (newrec_.safety_lead_time > 0))) THEN   
      Client_SYS.Add_Info(lu_name_,'SS_SLT_ENTERED: Safety Stock and Safety Lead Time both will be considered in planning.');
   END IF;

   $IF Component_Mfgstd_SYS.INSTALLED $THEN
      IF (oldrec_.planning_method != newrec_.planning_method) THEN     
         Manuf_Part_Attribute_API.Check_Mrp_Code_Change(newrec_.contract, newrec_.part_no, newrec_.planning_method);                   
      END IF;
   $END
   
   IF newrec_.planning_method = 'H' AND newrec_.proposal_release = 'DO NOT RELEASE'  THEN
      Error_SYS.Record_General('InventoryPartPlanning', 'BUFFER_PART_KANBAN: Planning method H is handled by MRP, Proposal Release should be set to Release.');
   END IF;
   
   newrec_.last_activity_date := Site_API.Get_Site_Date(newrec_.contract) ;

   -- check if any related sales parts have a correct sourcing_option depending of the inventory part planning_method and order_requisition
   IF (newrec_.planning_method IN ('P', 'N') OR newrec_.order_requisition = 'D' ) THEN
      $IF Component_Order_SYS.INSTALLED $THEN      
         Sales_Part_API.Check_Inv_Part_Planning_Data(newrec_.contract, newrec_.part_no, newrec_.order_requisition, newrec_.planning_method);
      $ELSE
         NULL;
      $END
   END IF;

   IF (newrec_.planning_method IN ('P', 'N')) THEN
      automatic_capability_check_ :=Inventory_Part_API.Get_Automatic_Capability_Check(newrec_.contract, newrec_.part_no);
      IF (Capability_Check_Allocate_API.Encode(automatic_capability_check_)
         IN ('RESERVE AND ALLOCATE','ALLOCATE ONLY','NEITHER RESERVE NOR ALLOCATE'))  THEN
         Error_SYS.Record_General(lu_name_, 'PPAOCCYESANDMRPPN: Planning Method cannot be P or N if Automatic Capability Check on inventory part is ":P1".',automatic_capability_check_);
      END IF;
   END IF;

   IF (newrec_.planning_method IN ('K', 'O')) THEN
      IF ((part_cat_rec_.receipt_issue_serial_track = Fnd_Boolean_API.db_true) OR
          (part_cat_rec_.eng_serial_tracking_code   = Part_Serial_Tracking_API.db_serial_tracking)) THEN
         Error_SYS.Record_General('InventoryPartPlanning','SERIALTRACKING: Planning Method K and O is not allowed if serial tracking is used.');
      END IF;
   END IF;

   -- moved code inside method Check_Manuf_Acquired_Split___
   Check_Manuf_Acquired_Split___(newrec_.part_no, 
                                 newrec_.planning_method, 
                                 type_code_db_,
                                 newrec_.split_manuf_acquired, 
                                 newrec_.percent_manufactured, 
                                 newrec_.percent_acquired);
   
   $IF Component_Massch_SYS.INSTALLED $THEN
      IF (newrec_.min_order_qty != oldrec_.min_order_qty) THEN
         Ms_Qty_Rate_By_Period_API.Check_Min_Order_Qty_Changes(newrec_.contract, newrec_.part_no, newrec_.min_order_qty);
      END IF;
      IF (newrec_.mul_order_qty > 0 AND newrec_.mul_order_qty != oldrec_.mul_order_qty AND Ms_Qty_Rate_By_Period_API.Check_Records_Exist(newrec_.contract, newrec_.part_no, '*')) THEN
         Client_SYS.Add_Info('InventoryPartPlanning', 'MULIGNOREDFORRATE: Multiple lot size will be ignored for MS proposals within defined rate periods.');
      END IF;     
   $END    

   -- Attribute mapping in Check_Hierarchy_attributes call:
   -- service_rate = service_level_rate
   -- setup_cost = ordering_cost
   -- carry_rate = inventory_interest_rate
   Company_Invent_Info_API.Check_Hierarchy_Attributes(newrec_.service_rate,
                                                      newrec_.setup_cost,
                                                      newrec_.carry_rate,
                                                      oldrec_.service_rate,
                                                      oldrec_.setup_cost,
                                                      oldrec_.carry_rate);
         
   $IF Component_Invpla_SYS.INSTALLED $THEN
      IF (Site_Ipr_Info_API.Get_Ipr_Active_Db(newrec_.contract) = Fnd_Boolean_API.DB_TRUE) AND
         (newrec_.planning_method = 'B') THEN
         IF ((oldrec_.lot_size_auto       != newrec_.lot_size_auto)        OR
            (oldrec_.order_point_qty_auto != newrec_.order_point_qty_auto) OR
            (oldrec_.safety_stock_auto    != newrec_.safety_stock_auto))   THEN
            Error_SYS.Record_General('InventoryPartPlanning','AUTOFLAGS: When the Site is IPR Active and the IFS/INVPLA module is installed, you are not allowed to automatically update the safety stock, order point or lot size for planning method B part(s).');
         END IF;
      END IF;  
   $END 
   END Check_Update___;
   
   
   PROCEDURE Raise_Pred_Negative_Error___
   IS
   BEGIN
      Error_SYS.Record_General(lu_name_, 'NEGPREDCONSINS: Pred Year Consumption may not be negative.');
   END Raise_Pred_Negative_Error___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Carry_Rate (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   RETURN Get_Inventory_Interest_Rate(contract_, part_no_);
END Get_Carry_Rate;


@UncheckedAccess
FUNCTION Get_Setup_Cost (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   RETURN Get_Ordering_Cost(contract_, part_no_);
END Get_Setup_Cost;


@UncheckedAccess
FUNCTION Get_Service_Rate (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   RETURN Get_Service_Level_Rate(contract_, part_no_);
END Get_Service_Rate;


-- Create_New_Part_Planning
--   Creates a new record according to the defaults values enterd in
--   Assortment_Invent_Def_Tab. Insert a new part planning instance.
--   This method is used to create a new part planning record in mass part
--   creation using default vlues in Assortment_Invent_Def_Tab.
PROCEDURE Create_New_Part_Planning (
   contract_               IN VARCHAR2,
   part_no_                IN VARCHAR2 )
IS
  newrec_                INVENTORY_PART_PLANNING_TAB%ROWTYPE;
BEGIN
   newrec_.part_no               := part_no_;
   newrec_.contract              := contract_;
   newrec_.lot_size_auto         := 'N';
   newrec_.order_point_qty_auto  := 'N';
   newrec_.safety_stock_auto     := 'N';
   newrec_.lot_size              := 0;
   newrec_.maxweek_supply        := 0;
   newrec_.max_order_qty         := 0;
   newrec_.min_order_qty         := 0;
   newrec_.mul_order_qty         := 0;
   newrec_.order_point_qty       := 0;
   newrec_.safety_stock          := 0;
   newrec_.safety_lead_time      := NVL(Asset_Class_API.Get_Safety_Lead_Time(Inventory_Part_API.Get_Asset_Class(contract_, part_no_)), 0);
   newrec_.shrinkage_fac         := 0;
   newrec_.std_order_size        := 0;
   newrec_.last_activity_date    := Site_API.Get_Site_Date(contract_);
   
   New___(newrec_);
END Create_New_Part_Planning;


-- Create_New_Part_Planning
--   Creates a new record according to the defaults values enterd in
--   Assortment_Invent_Def_Tab. Insert a new part planning instance.
--   This method is used to create a new part planning record in mass part
--   creation using default vlues in Assortment_Invent_Def_Tab.
PROCEDURE Create_New_Part_Planning (
   contract_                  IN VARCHAR2,
   part_no_                   IN VARCHAR2,
   second_commodity_          IN VARCHAR2,
   planning_method_           IN VARCHAR2,
   min_order_qty_             IN NUMBER,
   max_order_qty_             IN NUMBER,
   mul_order_qty_             IN NUMBER,
   shrinkage_fac_             IN NUMBER,
   service_rate_              IN NUMBER,
   std_order_size_            IN NUMBER,
   carry_rate_                IN NUMBER,
   safety_stock_              IN NUMBER,
   safety_lead_time_          IN NUMBER,
   order_point_qty_           IN NUMBER,
   lot_size_                  IN NUMBER,
   maxweek_supply_            IN NUMBER,
   setup_cost_                IN NUMBER,
   qty_predicted_consumption_ IN NUMBER,
   proposal_release_          IN VARCHAR2,
   order_requisition_         IN VARCHAR2 )
IS
   newrec_                INVENTORY_PART_PLANNING_TAB%ROWTYPE;
   attr_                  VARCHAR2(32000);
BEGIN
   Client_SYS.Set_Item_Value('CONTRACT', contract_, attr_);
   Client_SYS.Set_Item_Value('PART_NO', part_no_, attr_);
   Prepare_Insert___(attr_);  
   
   newrec_.part_no               := part_no_;
   newrec_.contract              := contract_;
   newrec_.lot_size_auto         := 'N';
   newrec_.order_point_qty_auto  := 'N';
   newrec_.safety_stock_auto     := 'N';
   newrec_.lot_size              := NVL(lot_size_, 0);
   newrec_.maxweek_supply        := NVL(maxweek_supply_, 0);
   newrec_.max_order_qty         := NVL(max_order_qty_,0);
   newrec_.min_order_qty         := NVL(min_order_qty_,0);
   newrec_.mul_order_qty         := NVL(mul_order_qty_,0);
   newrec_.order_point_qty       := NVL(order_point_qty_,0);
   newrec_.safety_stock          := NVL(safety_stock_, 0);
   newrec_.safety_lead_time      := NVL(NVL(safety_lead_time_, Asset_Class_API.Get_Safety_Lead_Time(Inventory_Part_API.Get_Asset_Class(contract_, part_no_))), 0);
   newrec_.shrinkage_fac         := NVL(shrinkage_fac_, 0);
   newrec_.std_order_size        := NVL(std_order_size_, 0);
   newrec_.last_activity_date    := Site_API.Get_Site_Date(contract_);
   
   IF (carry_rate_ IS NOT NULL) THEN
      newrec_.carry_rate                := carry_rate_;
   END IF;
   IF (setup_cost_ IS NOT NULL) THEN
      newrec_.setup_cost                := setup_cost_; 
   END IF;  
   IF (service_rate_ IS NOT NULL) THEN
      newrec_.service_rate              := service_rate_;
   END IF;
   
   IF (planning_method_ IS NOT NULL) THEN
      newrec_.planning_method           := planning_method_;
   END IF;
   IF (qty_predicted_consumption_ IS NOT NULL) THEN
      newrec_.qty_predicted_consumption := qty_predicted_consumption_;
   END IF;
   IF (proposal_release_ IS NOT NULL) THEN
      newrec_.proposal_release          := proposal_release_;
   END IF;
   IF (order_requisition_ IS NOT NULL) THEN
      newrec_.order_requisition         := order_requisition_;
   END IF;

   New___(newrec_);
END Create_New_Part_Planning;


-- Get_Part_Planning_Data
--   Fetches safety_stock_, order_point_qty_ and pick_time_.
PROCEDURE Get_Part_Planning_Data (
   safety_stock_     OUT NUMBER,
   order_point_qty_  OUT NUMBER,
   pick_time_        OUT VARCHAR2,
   contract_         IN  VARCHAR2,
   part_no_          IN  VARCHAR2 )
IS
   CURSOR get_data IS
    SELECT safety_stock, order_point_qty
    FROM INVENTORY_PART_PLANNING_TAB
    WHERE part_no =  part_no_
    AND   contract = contract_;
BEGIN
   OPEN get_data;
   FETCH get_data INTO safety_stock_, order_point_qty_;
   CLOSE get_data;
   pick_time_ := Site_Invent_Info_API.Get_Picking_Leadtime(contract_);
END Get_Part_Planning_Data;


PROCEDURE Modify_Planning_Attributes (
   contract_                  IN VARCHAR2,
   part_no_                   IN VARCHAR2,
   carry_rate_                IN NUMBER,
   service_rate_              IN NUMBER,
   setup_cost_                IN NUMBER,
   lot_size_                  IN NUMBER,
   lot_size_auto_             IN VARCHAR2,
   maxweek_supply_            IN NUMBER,
   max_order_qty_             IN NUMBER,
   min_order_qty_             IN NUMBER,
   mul_order_qty_             IN NUMBER,
   order_point_qty_           IN NUMBER,
   order_point_qty_auto_      IN VARCHAR2,
   safety_stock_              IN NUMBER,
   safety_stock_auto_         IN VARCHAR2,
   shrinkage_fac_             IN NUMBER,
   std_order_size_            IN NUMBER,
   order_requisition_         IN VARCHAR2,
   qty_predicted_consumption_ IN NUMBER,
   planning_method_           IN VARCHAR2 DEFAULT NULL,
   mrp_order_code_            IN VARCHAR2 DEFAULT NULL )
 IS
   attr_               VARCHAR2(32000);
   objid_              INVENTORY_PART_PLANNING.objid%TYPE;
   objversion_         INVENTORY_PART_PLANNING.objversion%TYPE;
   oldrec_             INVENTORY_PART_PLANNING_TAB%ROWTYPE;
   newrec_             INVENTORY_PART_PLANNING_TAB%ROWTYPE;
   obsolete_parameter_ EXCEPTION;
   parameter_name_     VARCHAR2(30);
   indrec_             Indicator_Rec;
BEGIN

   -- Mrp Order Code has been replaced by Planning Method. IF mrp_order_code_ has any other value than NULL then it is wrong!
   IF mrp_order_code_ IS NOT NULL THEN
      parameter_name_ := 'MRP_ORDER_CODE';
      RAISE obsolete_parameter_;
   END IF;
   
   
   IF (carry_rate_ IS NOT NULL) THEN
      parameter_name_ := 'CARRY_RATE';
      RAISE obsolete_parameter_;
   END IF;
   IF (service_rate_ IS NOT NULL) THEN
      parameter_name_ := 'SERVICE_RATE';
      RAISE obsolete_parameter_;
   END IF;
   IF (setup_cost_ IS NOT NULL) THEN
      parameter_name_ := 'SETUP_COST';
      RAISE obsolete_parameter_;
   END IF;
   IF (lot_size_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('LOT_SIZE', lot_size_, attr_);
   END IF;
   IF (lot_size_auto_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('LOT_SIZE_AUTO', lot_size_auto_, attr_);
   END IF;
   IF (maxweek_supply_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('MAXWEEK_SUPPLY', maxweek_supply_, attr_);
   END IF;
   IF (max_order_qty_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('MAX_ORDER_QTY', max_order_qty_, attr_);
   END IF;
   IF (min_order_qty_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('MIN_ORDER_QTY', min_order_qty_, attr_);
   END IF;
   IF (mul_order_qty_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('MUL_ORDER_QTY', mul_order_qty_, attr_);
   END IF;
   IF (order_point_qty_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('ORDER_POINT_QTY', order_point_qty_, attr_);
   END IF;
   IF (order_point_qty_auto_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('ORDER_POINT_QTY_AUTO', order_point_qty_auto_, attr_);
   END IF;
   IF (safety_stock_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('SAFETY_STOCK', safety_stock_, attr_);
   END IF;
   IF (safety_stock_auto_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('SAFETY_STOCK_AUTO', safety_stock_auto_, attr_);
   END IF;   
   IF (shrinkage_fac_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('SHRINKAGE_FAC', shrinkage_fac_, attr_);
   END IF;
   IF (std_order_size_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('STD_ORDER_SIZE', std_order_size_, attr_);
   END IF;
   IF (order_requisition_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('ORDER_REQUISITION', order_requisition_, attr_);
   END IF;
   IF (qty_predicted_consumption_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('QTY_PREDICTED_CONSUMPTION', qty_predicted_consumption_, attr_);
   END IF;
   IF (planning_method_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('PLANNING_METHOD', planning_method_, attr_);
   END IF;

   oldrec_ := Lock_By_Keys___(contract_, part_no_);
   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);   
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE); -- By keys.
EXCEPTION
   WHEN obsolete_parameter_ THEN
      Error_SYS.Record_General(lu_name_, 'OBSOLETEPARAM: Parameter :P1 is obsolete and is not allowed to have a value. Contact system support.', parameter_name_);
END Modify_Planning_Attributes;


-- Check_Auto_Flags
--   Returns part_no if at least one of the three auto flags are on.
--   Else returns null.
@UncheckedAccess
FUNCTION Check_Auto_Flags (
   contract_    IN VARCHAR2,
   part_no_     IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_       NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   INVENTORY_PART_PLANNING_TAB
      WHERE  part_no              = part_no_
        AND  contract             = contract_
        AND (safety_stock_auto    = 'Y'
         OR  order_point_qty_auto = 'Y'
         OR  lot_size_auto        = 'Y');
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN part_no_;
   END IF;
   CLOSE exist_control;
   RETURN NULL;
END Check_Auto_Flags;


PROCEDURE Modify_Stockfactors (
   rows_changed_        OUT NUMBER,
   contract_            IN  VARCHAR2,
   part_no_             IN  VARCHAR2,
   second_commodity_    IN  VARCHAR2,
   periods_             IN  NUMBER,
   work_days_           IN  NUMBER,
   manuf_median_period_ IN  NUMBER,
   purch_median_period_ IN  NUMBER,
   periods_per_year_    IN  NUMBER,
   lead_time_code_db_   IN  VARCHAR2,
   manuf_leadtime_      IN  NUMBER,
   purch_leadtime_      IN  NUMBER,
   force_auto_update_   IN  BOOLEAN DEFAULT FALSE )
IS
   service_rate_           INVENTORY_PART_PLANNING_TAB.service_rate%TYPE;
   safety_stock_auto_      INVENTORY_PART_PLANNING_TAB.safety_stock_auto%TYPE;
   order_point_qty_auto_   INVENTORY_PART_PLANNING_TAB.order_point_qty_auto%TYPE;
   lot_size_auto_          INVENTORY_PART_PLANNING_TAB.lot_size_auto%TYPE;
   planning_method_        INVENTORY_PART_PLANNING_TAB.planning_method%TYPE;
   count_periods_          NUMBER;
   qty_pred_consump_       NUMBER;
   use_pred_consump_       BOOLEAN;
   stddev_mtd_issues_      NUMBER;
   avg_mtd_issues_         NUMBER;
   setup_cost_             NUMBER;
   leadtime_               NUMBER;
   upkeep_cost_            NUMBER;
   new_safety_stock_       NUMBER;
   new_order_point_qty_    NUMBER;
   new_lot_size_           NUMBER;
   update_row_             BOOLEAN;
   newrec_                 INVENTORY_PART_PLANNING_TAB%ROWTYPE;
   oldrec_                 INVENTORY_PART_PLANNING_TAB%ROWTYPE;
   objid_                  INVENTORY_PART_PLANNING.objid%TYPE;
   objversion_             INVENTORY_PART_PLANNING.objversion%TYPE;
   attr_                   VARCHAR2(2000);
   actual_periods_per_year_ NUMBER;
   actual_median_period_   NUMBER;
   indrec_                 Indicator_Rec;
   CURSOR get_specific_data IS
      SELECT safety_stock_auto,
             order_point_qty_auto,
             lot_size_auto,
             qty_predicted_consumption,
             safety_stock,
             planning_method
      FROM INVENTORY_PART_PLANNING_TAB
      WHERE part_no     = part_no_
      AND contract      = contract_;
BEGIN
   rows_changed_ := 0;
   update_row_   := FALSE;
   -- To be able to use modified versions of these parameter if necessary.
   actual_periods_per_year_ := periods_per_year_;
   IF lead_time_code_db_ = 'M' THEN
      IF manuf_median_period_ = 0 OR manuf_median_period_ IS NULL THEN
         Error_SYS.Record_General(lu_name_, 'ERRDAYS: The median value for number of work days in a statistic period is zero. Calculation cannot be performed.');
      END IF;
      actual_median_period_ := manuf_median_period_;
   ELSIF lead_time_code_db_ = 'P' THEN
      IF purch_median_period_ = 0 OR purch_median_period_ IS NULL THEN
         Error_SYS.Record_General(lu_name_, 'ERRWORKDAYS: The median value for number of days in a statistic period is zero. Calculation cannot be performed.');
      END IF;
      actual_median_period_ := purch_median_period_;
   END IF;

   Inventory_Part_Period_Hist_API.Get_History_Statistics(count_periods_,
                                                         stddev_mtd_issues_,
                                                         avg_mtd_issues_,
                                                         contract_,
                                                         part_no_,
                                                         '*',
                                                         periods_);
   -- Only perform for those part/site:s that have data registered
   -- for more than a minimum number of months. Otherwise the
   -- predicted annual consumption (Qty_Predicted_Consumption) is used,
   use_pred_consump_ := FALSE;
   IF (count_periods_ < NVL(Commodity_Group_API.Get_Min_Periods (second_commodity_),3)) THEN
      actual_periods_per_year_ := 12;
      IF lead_time_code_db_ = 'M' THEN
         actual_median_period_ := ((365/actual_periods_per_year_) * work_days_)/7;
      ELSIF lead_time_code_db_ = 'P' THEN
         actual_median_period_ := 365/actual_periods_per_year_;
      END IF;
      use_pred_consump_ := TRUE;
   END IF;

   IF lead_time_code_db_ = 'M' THEN
      leadtime_     := manuf_leadtime_/actual_median_period_;
   ELSIF lead_time_code_db_ = 'P' THEN
      leadtime_     := purch_leadtime_/actual_median_period_;
   END IF;

   setup_cost_   := Get_Ordering_Cost          (contract_, part_no_);
   upkeep_cost_  := Get_Inventory_Interest_Rate(contract_, part_no_);
   service_rate_ := Get_Service_Level_Rate     (contract_, part_no_);
   
   
   OPEN  get_specific_data;
   FETCH get_specific_data INTO  safety_stock_auto_,
                                 order_point_qty_auto_,
                                 lot_size_auto_,
                                 qty_pred_consump_,
                                 new_safety_stock_,
                                 planning_method_;
   IF ((get_specific_data%NOTFOUND) OR
       (qty_pred_consump_ IS NULL AND use_pred_consump_ )) THEN
      Trace_Sys.Message('Notfound');
      CLOSE get_specific_data;
   ELSE
      CLOSE get_specific_data;

      IF (force_auto_update_) THEN
         safety_stock_auto_    := 'Y';
         order_point_qty_auto_ := 'Y';
         lot_size_auto_        := 'Y';
      END IF;


      upkeep_cost_ := ((upkeep_cost_/100) * Inventory_Part_Unit_Cost_API.Get_Inventory_Value_By_Method(contract_, part_no_, NULL, NULL, NULL));
      IF use_pred_consump_ = TRUE THEN
         avg_mtd_issues_ := qty_pred_consump_/actual_periods_per_year_;
         safety_stock_auto_ := 'N';
      END IF;

      -- Start building the attribute string for possible update of the record.
      Client_SYS.Clear_Attr(attr_);
      IF safety_stock_auto_ = 'Y' THEN
         new_safety_stock_ := NVL(Service_Rate_API.Get_Safety_Factor(service_rate_) * stddev_mtd_issues_ * SQRT(leadtime_), 0);
         new_safety_stock_ := Inventory_Part_API.Get_Calc_Rounded_Qty(contract_,
                                                                      part_no_, 
                                                                      new_safety_stock_,
                                                                      'ROUND');
         update_row_       := TRUE;
         Client_SYS.Add_To_Attr('SAFETY_STOCK', new_safety_stock_, attr_);
      END IF;
      -- Checking order point in the client  order_point_qty_auto_ is set to 'Y' then Order Point in the client (order_point_qty in the table) should be uppdated.
      IF order_point_qty_auto_ = 'Y' THEN
         new_order_point_qty_ := NVL(avg_mtd_issues_ * leadtime_ + new_safety_stock_, 0);
         new_order_point_qty_ := Inventory_Part_API.Get_Calc_Rounded_Qty(contract_, 
                                                                         part_no_,  
                                                                         new_order_point_qty_, 
                                                                         'ADD',
                                                                         TRUE);
         update_row_          := TRUE;
      END IF;
      -- Checking Lot Size  lot_size_auto_ is set to 'Y' then lot_size should be uppdated.
      IF ((planning_method_  = 'B') OR (planning_method_  = 'C')) AND
          (lot_size_auto_   = 'Y') AND (upkeep_cost_     > 0) THEN
         new_lot_size_ := NVL(SQRT((2 * setup_cost_ * avg_mtd_issues_ * actual_periods_per_year_) / upkeep_cost_ ), 0);

         new_lot_size_ := Inventory_Part_API.Get_Calc_Rounded_Qty(contract_, 
                                                                  part_no_,
                                                                  new_lot_size_,
                                                                  'ROUND');

         IF new_lot_size_  = 0 THEN
            new_lot_size_ := 1;
         END IF;
         update_row_      := TRUE;
      END IF;
      -- Only update if necessary.
      IF update_row_ THEN
         oldrec_ := Lock_By_Keys___(contract_, part_no_);
         ---------------------------------------------------------------------------------------------
         -- This code block ensures that lot_size is always greater than order_point_qty (Order     --
         -- Point in the client) for Planning Method C to prevent hard errors in method             --
         -- Validate_Planning_Method___.                                                            --
         ---------------------------------------------------------------------------------------------
         IF (planning_method_  = 'C') THEN
            IF (NVL(new_lot_size_, oldrec_.lot_size) <
                NVL(new_order_point_qty_, oldrec_.order_point_qty)) THEN
               new_lot_size_ := NVL(new_order_point_qty_, oldrec_.order_point_qty) + 1;
            END IF;
         END IF;
         --             end of code block 
         ---------------------------------------------------------------------------------------------

         ---------------------------------------------------------------------------------------------
         -- This code block ensures that order_point_qty is never smaller than safety_stock for     --
         -- Planning Methods B and C to prevent hard errors in method Validate_Planning_Method___.  --
         ---------------------------------------------------------------------------------------------
         IF (planning_method_ IN ('B','C')) THEN
            IF (NVL(new_order_point_qty_, oldrec_.order_point_qty)) <
                (NVL(new_safety_stock_, oldrec_.safety_stock)) THEN
               new_order_point_qty_ := NVL(new_safety_stock_, oldrec_.safety_stock);
            END IF;
         END IF;
         --             end of code block
         ---------------------------------------------------------------------------------------------

         IF (new_order_point_qty_ IS NOT NULL) THEN
            Client_SYS.Add_To_Attr('ORDER_POINT_QTY',new_order_point_qty_ , attr_);
         END IF;
         IF (new_lot_size_ IS NOT NULL) THEN
            Client_SYS.Add_To_Attr('LOT_SIZE',new_lot_size_ , attr_);
         END IF;

         newrec_ := oldrec_;
         Unpack___(newrec_, indrec_, attr_);
         Check_Update___(oldrec_, newrec_, indrec_, attr_);            
         Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE); -- Update by keys
         rows_changed_    := 1;
      END IF;
   END IF;
END Modify_Stockfactors;


-- Get_Scheduling_Flags
--   Fetches max_order_qty_, min_order_qty_, mul_order_qty_, safety_stock_
--   for a part_no and contract.
PROCEDURE Get_Scheduling_Flags (
   max_order_qty_    OUT NUMBER,
   min_order_qty_    OUT NUMBER,
   mul_order_qty_    OUT NUMBER,
   safety_stock_     OUT NUMBER,
   contract_         IN  VARCHAR2,
   part_no_          IN  VARCHAR2 )
IS
   CURSOR get_data IS
    SELECT max_order_qty, min_order_qty, mul_order_qty, safety_stock
    FROM INVENTORY_PART_PLANNING_TAB
    WHERE part_no =  part_no_
    AND   contract = contract_;
BEGIN
   OPEN get_data;
   FETCH get_data INTO max_order_qty_, min_order_qty_,
                       mul_order_qty_, safety_stock_;
   CLOSE get_data;
END Get_Scheduling_Flags;


-- Check_Exist
--   Public check without error message if a part exists in this LU.
--   Returns 1 if it exists else 0.
@UncheckedAccess
FUNCTION Check_Exist (
   contract_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   IF (NOT Check_Exist___(contract_, part_no_)) THEN
      RETURN 0;
   ELSE
      RETURN 1;
   END IF;
END Check_Exist;


-- Get_Percent_Diff
--   Calculates the change in percent between old and new value.
@UncheckedAccess
FUNCTION Get_Percent_Diff (
   old_ IN NUMBER,
   new_ IN NUMBER ) RETURN NUMBER
IS
BEGIN
   IF (old_ =0 AND new_ !=0) THEN
      RETURN 999999999;
   ELSIF (old_ =0 AND new_ =0) THEN
      RETURN 0;
   ELSE
      RETURN ROUND((((new_ - old_)/old_)*100),2);
   END IF;
END Get_Percent_Diff;


-- Validate_Order_Requisition
--   Method for validating allowed combinations of the attribute
--   OrderRequisition (Also known as SupplyType) and attribute TypeCode
--   that is retrieved from LU InventoryPart.
PROCEDURE Validate_Order_Requisition (
   contract_          IN VARCHAR2,
   part_no_           IN VARCHAR2,
   order_requisition_ IN VARCHAR2,
   type_code_         IN VARCHAR2 )
IS
   order_requisition_db_   VARCHAR2(20);
   type_code_db_           VARCHAR2(20);

BEGIN

   -- Get db-values to use in comparisons
   order_requisition_db_ := Inventory_Part_Supply_Type_API.Encode(order_requisition_);
   type_code_db_         := Inventory_Part_Type_API.Encode(type_code_);
   IF order_requisition_db_ = 'D' THEN
      IF type_code_db_ IN ('2', '6') THEN
         Error_SYS.Record_General('InventoryPartPlanning', 'TYPECODE25ERROR: Type Code :P1 not allowed when Supply Type is :P2.', type_code_, order_requisition_);
      END IF;
   END IF;
END Validate_Order_Requisition;




-- Get_Scrap_Added_Qty
--   Adjust the original quantity according to the scrap factor. Add the
--   expected scrap to the original quantity and round quantity up according
--   to the shrinkage_rounding.
@UncheckedAccess
FUNCTION Get_Scrap_Added_Qty (
   contract_     IN VARCHAR2,
   part_no_      IN VARCHAR2,
   original_qty_ IN NUMBER ) RETURN NUMBER
IS
   shrinkage_fac_      INVENTORY_PART_PLANNING_TAB.shrinkage_fac%TYPE;
   adjusted_qty_       NUMBER;
   notrounded_qty_     NUMBER;

   CURSOR get_attr IS
      SELECT shrinkage_fac
      FROM   INVENTORY_PART_PLANNING_TAB
      WHERE  contract = contract_
      AND    part_no = part_no_;
BEGIN
   OPEN  get_attr;
   FETCH get_attr INTO shrinkage_fac_;
   IF (get_attr%NOTFOUND) THEN
      adjusted_qty_ := original_qty_;
   ELSE
      IF (shrinkage_fac_ = 0) THEN
         adjusted_qty_ := original_qty_;
      ELSE
         notrounded_qty_ := original_qty_ / (1 - (shrinkage_fac_ / 100));
         adjusted_qty_ := Inventory_Part_API.Get_Calc_Rounded_Qty(contract_,
                                                                  part_no_,
                                                                  notrounded_qty_,
                                                                  'ADD');
      END IF;
   END IF;
   CLOSE get_attr;
   adjusted_qty_ := Nvl(adjusted_qty_, 0);
   RETURN adjusted_qty_;
END Get_Scrap_Added_Qty;


-- Get_Scrap_Removed_Qty
--   Remove the expected scrap from the original quantity and round quantity
--   down according to the shrinkage_rounding.
@UncheckedAccess
FUNCTION Get_Scrap_Removed_Qty (
   contract_     IN VARCHAR2,
   part_no_      IN VARCHAR2,
   original_qty_ IN NUMBER ) RETURN NUMBER
IS
   shrinkage_fac_      INVENTORY_PART_PLANNING_TAB.shrinkage_fac%TYPE;
   adjusted_qty_       NUMBER;
   notrounded_qty_     NUMBER;

   CURSOR get_attr IS
      SELECT shrinkage_fac
      FROM   INVENTORY_PART_PLANNING_TAB
      WHERE  contract = contract_
      AND    part_no = part_no_;
BEGIN
   OPEN  get_attr;
   FETCH get_attr INTO shrinkage_fac_;
   IF (get_attr%NOTFOUND) THEN
      adjusted_qty_ := original_qty_;
   ELSE
      IF (shrinkage_fac_ = 0) THEN
         adjusted_qty_ := original_qty_;
      ELSE
         notrounded_qty_ := original_qty_ * (1 - (shrinkage_fac_ / 100));
         adjusted_qty_ := Inventory_Part_API.Get_Calc_Rounded_Qty(contract_,
                                                                  part_no_,
                                                                  notrounded_qty_,
                                                                  'REMOVE');
      END IF;
   END IF;
   CLOSE get_attr;
   adjusted_qty_ := Nvl(adjusted_qty_, 0);
   RETURN adjusted_qty_;
END Get_Scrap_Removed_Qty;


FUNCTION Check_Planning_Method_K_O (
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_ NUMBER;
   CURSOR exist_planning_method IS
      SELECT 1
      FROM   INVENTORY_PART_PLANNING_TAB
      WHERE part_no = part_no_
      AND   planning_method IN ('K','O');
BEGIN
   OPEN exist_planning_method;
   FETCH exist_planning_method INTO dummy_;
   IF (exist_planning_method%FOUND) THEN
      CLOSE exist_planning_method;
      RETURN 'TRUE';
   END IF;
   CLOSE exist_planning_method;
   RETURN 'FALSE';
END Check_Planning_Method_K_O;


-- Copy
--   Method creates new instance and copies all public attributes from
--   old part. The copying can be overriden by sending in specific values
--   via the attribute string.
PROCEDURE Copy (
   to_contract_   IN VARCHAR2,
   to_part_no_    IN VARCHAR2,
   from_contract_ IN VARCHAR2,
   from_part_no_  IN VARCHAR2 )
IS
   objid_              INVENTORY_PART_PLANNING.objid%TYPE;
   objversion_         INVENTORY_PART_PLANNING.objversion%TYPE;
   attr_               VARCHAR2(2000);
   fromrec_            INVENTORY_PART_PLANNING_TAB%ROWTYPE;
   oldrec_             INVENTORY_PART_PLANNING_TAB%ROWTYPE;
   newrec_             INVENTORY_PART_PLANNING_TAB%ROWTYPE;
   curr_setup_cost_    INVENTORY_PART_PLANNING_TAB.setup_cost%TYPE;
   indrec_             Indicator_Rec;

BEGIN

   Exist(from_contract_, from_part_no_);

   fromrec_ := Get_Object_By_Keys___(from_contract_, from_part_no_);
   oldrec_  := Lock_By_Keys___(to_contract_, to_part_no_);
   newrec_  := oldrec_;

   Client_SYS.Clear_Attr(attr_);


   --------------------------------------------------------------------------
   --------------------------------------------------------------------------
   --                                                                      --
   --  A problem when coping planning data is the attribute setup_cost.    --
   --  This is a cost stored in the base currency of the company to which  --
   --  the site belongs. IF planning data is copied between two different  --
   --  companies we have to check if different currencies are involved.    --
   --  IF that is the case then we need to do a currency calculation       --
   --  to transfer the setup cost from one base currency to another.       --
   --  Call Site_API.Caculate_To_Currency to convert the cost.             --
   --------------------------------------------------------------------------
   --------------------------------------------------------------------------
   IF (fromrec_.setup_cost IS NOT NULL) THEN
      curr_setup_cost_ := fromrec_.setup_cost;
   
      curr_setup_cost_ := Site_API.Get_Currency_Converted_Amount(from_contract_,
                                                                 to_contract_,
                                                                 curr_setup_cost_);
      Client_SYS.Add_To_Attr('SETUP_COST'               , curr_setup_cost_                  , attr_);
   END IF;

   IF (fromrec_.carry_rate IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('CARRY_RATE'               , fromrec_.carry_rate               , attr_);
   END IF;

   IF (fromrec_.service_rate IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('SERVICE_RATE', fromrec_.service_rate, attr_);
   END IF;


   Client_SYS.Add_To_Attr('LOT_SIZE'                 , fromrec_.lot_size                 , attr_);
   Client_SYS.Add_To_Attr('LOT_SIZE_AUTO_DB'         , fromrec_.lot_size_auto            , attr_);
   Client_SYS.Add_To_Attr('MAXWEEK_SUPPLY'           , fromrec_.maxweek_supply           , attr_);
   Client_SYS.Add_To_Attr('MAX_ORDER_QTY'            , fromrec_.max_order_qty            , attr_);
   Client_SYS.Add_To_Attr('MIN_ORDER_QTY'            , fromrec_.min_order_qty            , attr_);
   Client_SYS.Add_To_Attr('MUL_ORDER_QTY'            , fromrec_.mul_order_qty            , attr_);
   Client_SYS.Add_To_Attr('ORDER_POINT_QTY'          , fromrec_.order_point_qty          , attr_);
   Client_SYS.Add_To_Attr('ORDER_POINT_QTY_AUTO_DB'  , fromrec_.order_point_qty_auto     , attr_);
   Client_SYS.Add_To_Attr('ORDER_TRIP_DATE'          , fromrec_.order_trip_date          , attr_);
   Client_SYS.Add_To_Attr('SAFETY_STOCK'             , fromrec_.safety_stock             , attr_);
   Client_SYS.Add_To_Attr('SAFETY_LEAD_TIME'         , fromrec_.safety_lead_time         , attr_);
   Client_SYS.Add_To_Attr('SAFETY_STOCK_AUTO_DB'     , fromrec_.safety_stock_auto        , attr_);
   Client_SYS.Add_To_Attr('SHRINKAGE_FAC'            , fromrec_.shrinkage_fac            , attr_);
   Client_SYS.Add_To_Attr('STD_ORDER_SIZE'           , fromrec_.std_order_size           , attr_);
   Client_SYS.Add_To_Attr('ORDER_REQUISITION_DB'     , fromrec_.order_requisition        , attr_);
   Client_SYS.Add_To_Attr('QTY_PREDICTED_CONSUMPTION', fromrec_.qty_predicted_consumption, attr_);
   Client_SYS.Add_To_Attr('PLANNING_METHOD'          , fromrec_.planning_method          , attr_);
   Client_SYS.Add_To_Attr('PROPOSAL_RELEASE_DB'      , fromrec_.proposal_release         , attr_);
   Client_SYS.Add_To_Attr('SCHED_CAPACITY_DB'        , fromrec_.sched_capacity           , attr_);

   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);               
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE); -- By keys.
END Copy;


-- Is_Manuf_Acquir_Split_Part
--   Return 1 If Exist the part with SplitManufAcquired flag on.
FUNCTION Is_Manuf_Acquir_Split_Part (
   part_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   temp_          NUMBER :=0;
   CURSOR get_split_part IS
      SELECT contract
      FROM INVENTORY_PART_PLANNING_TAB
      WHERE part_no = part_no_;
BEGIN
   FOR rec_ IN get_split_part LOOP
      IF (Get_Split_Manuf_Acquired_Db(rec_.contract, part_no_) = 'SPLIT') THEN
         temp_ := 1;
      END IF;
      RETURN temp_;
   END LOOP;
   RETURN temp_;
END Is_Manuf_Acquir_Split_Part;


-- Modify_Manuf_Acq_Percent
--   This method is used to update the manufactured and acquired percentages
--   when the Split Manuf Acquired is not selected.
PROCEDURE Modify_Manuf_Acq_Percent (
   contract_     IN VARCHAR2,
   part_no_      IN VARCHAR2,
   type_code_db_ IN VARCHAR2 )
IS
   newrec_          INVENTORY_PART_PLANNING_TAB%ROWTYPE;
   oldrec_          INVENTORY_PART_PLANNING_TAB%ROWTYPE;
   objid_           INVENTORY_PART_PLANNING.objid%TYPE;
   objversion_      INVENTORY_PART_PLANNING.objversion%TYPE;
   attr_            VARCHAR2(2000);
   indrec_          Indicator_Rec;
BEGIN
   IF type_code_db_ IN ('1', '2') THEN
      newrec_.percent_manufactured := 100;
      newrec_.percent_acquired     := 0;
   ELSE
      newrec_.percent_manufactured := 0;
      newrec_.percent_acquired     := 100;
   END IF;

   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('PERCENT_MANUFACTURED', newrec_.percent_manufactured, attr_);
   Client_SYS.Add_To_Attr('PERCENT_ACQUIRED', newrec_.percent_acquired, attr_);

   oldrec_ := Lock_By_Keys___(contract_, part_no_);
   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);               
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
END Modify_Manuf_Acq_Percent;


PROCEDURE Modify_Order_Point_Parameters (
   contract_     IN VARCHAR2,
   part_no_      IN VARCHAR2,
   order_point_  IN NUMBER,
   lot_size_     IN NUMBER,
   safety_stock_ IN NUMBER )
IS
   attr_                 VARCHAR2(2000);
   objid_                INVENTORY_PART_PLANNING.objid%TYPE;
   objversion_           INVENTORY_PART_PLANNING.objversion%TYPE;
   oldrec_               INVENTORY_PART_PLANNING_TAB%ROWTYPE;
   newrec_               INVENTORY_PART_PLANNING_TAB%ROWTYPE;
   update_needed_        BOOLEAN := FALSE;
   exit_procedure_       EXCEPTION;
   new_order_point_      INVENTORY_PART_PLANNING_TAB.order_point_qty%TYPE;
   rounded_order_point_  INVENTORY_PART_PLANNING_TAB.order_point_qty%TYPE;
   new_lot_size_         INVENTORY_PART_PLANNING_TAB.lot_size%TYPE;
   rounded_lot_size_     INVENTORY_PART_PLANNING_TAB.lot_size%TYPE;
   rounded_safety_stock_ INVENTORY_PART_PLANNING_TAB.safety_stock%TYPE;
   new_safety_stock_     INVENTORY_PART_PLANNING_TAB.safety_stock%TYPE;
   indrec_               Indicator_Rec;
   is_ipr_activated      BOOLEAN := FALSE;
BEGIN
   -- First read the record without locking it and check if modification is needed
   oldrec_ := Get_Object_By_Keys___(contract_, part_no_);
   
   IF (NOT Inv_Part_Planning_Method_API.Is_Order_Point_Or_Tpss(oldrec_.planning_method)) THEN 
      RAISE exit_procedure_;
   END IF;
   
   rounded_order_point_  := Inventory_Part_API.Get_Calc_Rounded_Qty(contract_, part_no_, order_point_ , 'ADD', TRUE);
   rounded_lot_size_     := Inventory_Part_API.Get_Calc_Rounded_Qty(contract_, part_no_, lot_size_    ,'ROUND');
   
   $IF Component_Invpla_SYS.INSTALLED $THEN
      is_ipr_activated      := (Site_Ipr_Info_API.Get_Ipr_Active_Db(contract_) = Fnd_Boolean_API.db_TRUE);
   $END
   
   IF ((NOT is_ipr_activated) OR 
      (Inv_Part_Planning_Method_API.Is_Order_Point(oldrec_.planning_method) AND (NOT Slow_Movers_Or_Croston___(contract_, part_no_)))) THEN
      -- when the site IPR is active we need to do the rounding only for parts having planning method B and 
      -- order point model manual or lead time driven (non slow_movers_or_croston). This is to avoid relative large
      -- rounding errors for slow moving items .
      rounded_safety_stock_ := Inventory_Part_API.Get_Calc_Rounded_Qty(contract_, part_no_, safety_stock_,'ROUND');
   ELSE 
      rounded_safety_stock_ := safety_stock_;
   END IF;
   
   IF ((rounded_order_point_  = oldrec_.order_point_qty) AND
       (rounded_lot_size_     = oldrec_.lot_size       ) AND
       (rounded_safety_stock_ = oldrec_.safety_stock   )) THEN
      RAISE exit_procedure_;
   END IF;

   -- Only lock the record if modification has proven to be needed
   oldrec_ := Lock_By_Keys___(contract_, part_no_);

   -- Recheck the values in the table after having locked the record
   IF (rounded_order_point_ != oldrec_.order_point_qty) THEN
      IF (Auto_Update_Order_Point___(oldrec_)) THEN
         new_order_point_ := rounded_order_point_;
      END IF;
   END IF;

   IF (rounded_lot_size_ != oldrec_.lot_size) THEN
      IF (Auto_Update_Lot_Size___(oldrec_)) THEN
         new_lot_size_ := rounded_lot_size_;
      END IF;
   END IF;

   IF (rounded_safety_stock_ != oldrec_.safety_stock) THEN
      IF (Auto_Update_Safety_Stock___(oldrec_)) THEN
         new_safety_stock_ := rounded_safety_stock_;
      END IF;
   END IF;

   IF (NVL(new_order_point_, oldrec_.order_point_qty)) <
       (NVL(new_safety_stock_, oldrec_.safety_stock)) THEN
      new_order_point_ := NVL(new_safety_stock_, oldrec_.safety_stock);
   END IF;

   IF (new_order_point_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('ORDER_POINT_QTY', new_order_point_, attr_);
      update_needed_ := TRUE;
   END IF;

   IF (new_lot_size_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('LOT_SIZE', new_lot_size_, attr_);
      update_needed_ := TRUE;
   END IF;

   IF (new_safety_stock_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('SAFETY_STOCK', new_safety_stock_, attr_);
      update_needed_ := TRUE;
   END IF;

   IF NOT update_needed_ THEN
      RAISE exit_procedure_;
   END IF;

   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);               
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE, FALSE); -- By keys.

EXCEPTION
   WHEN exit_procedure_ THEN
      NULL;
END Modify_Order_Point_Parameters;


@UncheckedAccess
FUNCTION Get_Service_Level_Rate (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN NUMBER
IS
   service_level_rate_  INVENTORY_PART_PLANNING_TAB.service_rate%TYPE;
   string_dummy_        VARCHAR2(50);
   date_dummy_          DATE;
BEGIN
   Get_From_Hierarchy___(numeric_value_        => service_level_rate_,
                         value_source_db_      => string_dummy_,
                         latest_activity_time_ => date_dummy_,
                         contract_             => contract_,
                         part_no_              => part_no_,
                         attribute_            => the_service_level_rate_);
   RETURN (service_level_rate_);
END Get_Service_Level_Rate;


@UncheckedAccess
FUNCTION Get_Ordering_Cost (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN NUMBER
IS
   ordering_cost_ INVENTORY_PART_PLANNING_TAB.setup_cost%TYPE;
   string_dummy_  VARCHAR2(50);
   date_dummy_    DATE;
BEGIN
   Get_From_Hierarchy___(numeric_value_        => ordering_cost_,
                         value_source_db_      => string_dummy_,
                         latest_activity_time_ => date_dummy_,
                         contract_             => contract_,
                         part_no_              => part_no_,
                         attribute_            => the_ordering_cost_);
   RETURN (ordering_cost_);
END Get_Ordering_Cost;


@UncheckedAccess
FUNCTION Get_Service_Level_Rate_Source (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   numeric_dummy_   INVENTORY_PART_PLANNING_TAB.service_rate%TYPE;
   date_dummy_      DATE;
   value_source_db_ VARCHAR2(50);
BEGIN
   Get_From_Hierarchy___(numeric_value_        => numeric_dummy_,
                         value_source_db_      => value_source_db_,
                         latest_activity_time_ => date_dummy_,
                         contract_             => contract_,
                         part_no_              => part_no_,
                         attribute_            => the_service_level_rate_);
   RETURN Planning_Hierarchy_Source_API.Decode(value_source_db_);
END Get_Service_Level_Rate_Source;


@UncheckedAccess
FUNCTION Get_Ordering_Cost_Source (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   numeric_dummy_   INVENTORY_PART_PLANNING_TAB.setup_cost%TYPE;
   date_dummy_      DATE;
   value_source_db_ VARCHAR2(50);
BEGIN
   Get_From_Hierarchy___(numeric_value_        => numeric_dummy_,
                         value_source_db_      => value_source_db_,
                         latest_activity_time_ => date_dummy_,
                         contract_             => contract_,
                         part_no_              => part_no_,
                         attribute_            => the_ordering_cost_);
   RETURN Planning_Hierarchy_Source_API.Decode(value_source_db_);
END Get_Ordering_Cost_Source;


@UncheckedAccess
FUNCTION Get_Inventory_Interest_Rate (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN NUMBER
IS
   inventory_interest_rate_   INVENTORY_PART_PLANNING_TAB.carry_rate%TYPE;
   string_dummy_              VARCHAR2(50);
   date_dummy_                DATE;
BEGIN
   Get_From_Hierarchy___(numeric_value_        => inventory_interest_rate_,
                         value_source_db_      => string_dummy_,
                         latest_activity_time_ => date_dummy_,
                         contract_             => contract_,
                         part_no_              => part_no_,
                         attribute_            => the_inventory_interest_rate_);
   RETURN (inventory_interest_rate_);
END Get_Inventory_Interest_Rate;


@UncheckedAccess
FUNCTION Get_Inv_Interest_Rate_Source (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   numeric_dummy_   INVENTORY_PART_PLANNING_TAB.carry_rate%TYPE;
   date_dummy_      DATE;
   value_source_db_ VARCHAR2(50);
BEGIN
   Get_From_Hierarchy___(numeric_value_        => numeric_dummy_,
                         value_source_db_      => value_source_db_,
                         latest_activity_time_ => date_dummy_,
                         contract_             => contract_,
                         part_no_              => part_no_,
                         attribute_            => the_inventory_interest_rate_);
   RETURN Planning_Hierarchy_Source_API.Decode(value_source_db_);
END Get_Inv_Interest_Rate_Source;


@UncheckedAccess
FUNCTION Get_Latest_Activity_Time (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN DATE
IS
   activity_time_        DATE;
   latest_activity_time_ DATE := Database_SYS.first_calendar_date_;
   string_dummy_         VARCHAR2(50);
   numeric_dummy_        NUMBER;
BEGIN
   FOR i IN 1..3 LOOP
      Get_From_Hierarchy___(numeric_value_        => numeric_dummy_,
                            value_source_db_      => string_dummy_,
                            latest_activity_time_ => activity_time_,
                            contract_             => contract_,
                            part_no_              => part_no_,
                            attribute_            => i);
      latest_activity_time_ := GREATEST(latest_activity_time_, activity_time_);
   END LOOP;

   RETURN (latest_activity_time_);
END Get_Latest_Activity_Time;


PROCEDURE Auto_Update_Planning_Method (
   contract_           IN VARCHAR2,
   part_no_            IN VARCHAR2,
   abc_class_          IN VARCHAR2,
   frequency_class_db_ IN VARCHAR2,
   lifecycle_stage_db_ IN VARCHAR2,
   invepart_rec_       IN Inventory_Part_API.Public_Rec )
IS
   attr_                          VARCHAR2(2000);
   objid_                         INVENTORY_PART_PLANNING.objid%TYPE;
   objversion_                    INVENTORY_PART_PLANNING.objversion%TYPE;
   oldrec_                        INVENTORY_PART_PLANNING_TAB%ROWTYPE;
   newrec_                        INVENTORY_PART_PLANNING_TAB%ROWTYPE;
   exit_procedure_                EXCEPTION;
   new_planning_method_           VARCHAR2(1);
   recalc_order_point_parameters_ BOOLEAN := FALSE;
   dummy_number_                  NUMBER;
   average_period_                NUMBER;
   work_days_                     NUMBER;
   periods_per_year_              NUMBER;
   manuf_median_period_           NUMBER;
   purch_median_period_           NUMBER;
   abc_freq_life_rec_             Abc_Frequency_Lifecycle_API.Public_Rec;
   indrec_   Indicator_Rec;   
BEGIN

   abc_freq_life_rec_ := Abc_Frequency_Lifecycle_API.Get(abc_class_,
                                                         Site_API.Get_Company(contract_),
                                                         Abc_Frequency_Lifecycle_API.all_sites_config_,
                                                         frequency_class_db_,
                                                         lifecycle_stage_db_);
   new_planning_method_ := abc_freq_life_rec_.planning_method_a_b_swap;
   IF (new_planning_method_ IS NULL) THEN
      RAISE exit_procedure_;
   END IF;

   -- First read the record without locking it and check if modification is needed
   oldrec_ := Get_Object_By_Keys___(contract_, part_no_);

   IF (oldrec_.planning_method NOT IN ('A','B')) THEN
      RAISE exit_procedure_;
   END IF;

   IF (oldrec_.planning_method_auto = 'FALSE') THEN
      RAISE exit_procedure_;
   END IF;

   IF (new_planning_method_ = oldrec_.planning_method) THEN
      RAISE exit_procedure_;
   END IF;

   IF ((new_planning_method_ = 'B') AND (oldrec_.order_requisition IN ('S','D'))) THEN
         RAISE exit_procedure_;
   END IF;

   IF (Part_Catalog_API.Get_Configurable_Db(part_no_) = 'CONFIGURED') THEN
      RAISE exit_procedure_;
   END IF;

   -- Only lock the record when modification has proven to be needed
   oldrec_ := Lock_By_Keys___(contract_, part_no_);

   Client_SYS.Add_To_Attr('PLANNING_METHOD', new_planning_method_, attr_);

   IF (new_planning_method_ = 'A') THEN
      IF ((oldrec_.std_order_size > 0 AND oldrec_.std_order_size < oldrec_.min_order_qty ) OR
          (oldrec_.std_order_size > 0 AND oldrec_.max_order_qty > 0 AND
            oldrec_.std_order_size > oldrec_.max_order_qty )) THEN
         Client_SYS.Add_To_Attr('STD_ORDER_SIZE', oldrec_.min_order_qty, attr_);
      END IF;

      IF (oldrec_.order_point_qty_auto = 'Y') THEN
         Client_SYS.Add_To_Attr('ORDER_POINT_QTY_AUTO_DB', 'N', attr_);
      END IF;
      IF (oldrec_.lot_size_auto = 'Y') THEN
         Client_SYS.Add_To_Attr('LOT_SIZE_AUTO_DB', 'N', attr_);
      END IF;
      -- Added a condition to set safety stock automatically to zero.
      IF (abc_freq_life_rec_.set_safety_stock_to_zero = 'TRUE') THEN
         Client_SYS.Add_To_Attr('SAFETY_STOCK', 0, attr_);
      END IF;
   ELSE
      -- new planning method is 'B'
      IF (oldrec_.lot_size <= 0) THEN
         Client_SYS.Add_To_Attr('LOT_SIZE', 1, attr_);
         recalc_order_point_parameters_ := TRUE;
      END IF;

      IF (oldrec_.order_point_qty < oldrec_.safety_stock) THEN
         Client_SYS.Add_To_Attr('ORDER_POINT_QTY', oldrec_.safety_stock, attr_);
         recalc_order_point_parameters_ := TRUE;
      END IF;
   END IF;

   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);               
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE); -- By keys.

   IF (recalc_order_point_parameters_) THEN
      work_days_        := Site_Invent_Info_API.Get_Avg_Work_Days_Per_Week(contract_);
      average_period_   := Statistic_Period_API.Get_Average_Period;
      periods_per_year_ := Statistic_Period_API.Get_Periods_Per_Year;

      Statistic_Period_API.Get_Median_Period(manuf_median_period_,average_period_,work_days_,'M');
      Statistic_Period_API.Get_Median_Period(purch_median_period_,average_period_,work_days_,'P');

      Modify_Stockfactors(rows_changed_        => dummy_number_,
                          contract_            => contract_,
                          part_no_             => part_no_,
                          second_commodity_    => invepart_rec_.second_commodity,
                          periods_             => 6,
                          work_days_           => work_days_,
                          manuf_median_period_ => manuf_median_period_,
                          purch_median_period_ => purch_median_period_,
                          periods_per_year_    => periods_per_year_,
                          lead_time_code_db_   => invepart_rec_.lead_time_code,
                          manuf_leadtime_      => invepart_rec_.manuf_leadtime,
                          purch_leadtime_      => invepart_rec_.purch_leadtime,
                          force_auto_update_   => TRUE);
   END IF;
EXCEPTION
   WHEN exit_procedure_ THEN
      NULL;
END Auto_Update_Planning_Method;


@UncheckedAccess
FUNCTION Get_Next_Order_Date(
   contract_  IN VARCHAR2,
   part_no_   IN VARCHAR2, 
   vendor_no_ IN VARCHAR2 DEFAULT NULL) RETURN DATE
IS
   next_order_date_ DATE;
   dummy_number_    NUMBER;
BEGIN
   Make_Next_Order_Analysis (next_order_date_         => next_order_date_,
                             next_order_qty_          => dummy_number_,
                             days_to_next_order_date_ => dummy_number_,
                             contract_                => contract_,
                             part_no_                 => part_no_,
                             vendor_no_               => vendor_no_);

   RETURN (next_order_date_);
END Get_Next_Order_Date;


@UncheckedAccess
FUNCTION Get_Days_To_Next_Order_Date (
   contract_  IN VARCHAR2,
   part_no_   IN VARCHAR2,
   vendor_no_ IN VARCHAR2 DEFAULT NULL) RETURN NUMBER
IS
   days_to_next_order_date_ NUMBER;
   dummy_number_            NUMBER;
   dummy_date_              DATE;
BEGIN
   Make_Next_Order_Analysis (next_order_date_         => dummy_date_,
                             next_order_qty_          => dummy_number_,
                             days_to_next_order_date_ => days_to_next_order_date_,
                             contract_                => contract_,
                             part_no_                 => part_no_,
                             vendor_no_               => vendor_no_);

   RETURN days_to_next_order_date_;
END Get_Days_To_Next_Order_Date;


@UncheckedAccess
FUNCTION Get_Next_Order_Qty (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN NUMBER
IS
   next_order_qty_ NUMBER;
   dummy_number_   NUMBER;
   dummy_date_     DATE;
BEGIN
   Make_Next_Order_Analysis (next_order_date_         => dummy_date_,
                             next_order_qty_          => next_order_qty_,
                             days_to_next_order_date_ => dummy_number_,
                             contract_                => contract_,
                             part_no_                 => part_no_);

   RETURN next_order_qty_;
END Get_Next_Order_Qty;


@UncheckedAccess
PROCEDURE Make_Next_Order_Analysis (
   next_order_date_         OUT DATE,
   next_order_qty_          OUT NUMBER,
   days_to_next_order_date_ OUT NUMBER,
   contract_                IN  VARCHAR2,
   part_no_                 IN  VARCHAR2,
   vendor_no_               IN  VARCHAR2 DEFAULT NULL)
IS
   today_                        DATE;
   stop_analysis_date_           DATE;
   projected_qty_on_hand_        NUMBER;
   current_qty_on_hand_          NUMBER;
   expected_leadtime_            NUMBER;
   supply_demand_date_tab_       Order_Supply_Demand_API.Supply_Demand_Date_Tab;
   lot_count_                    NUMBER := 0;
   lot_size_                     INVENTORY_PART_PLANNING_TAB.lot_size%TYPE;
   exit_procedure_               EXCEPTION;
   demand_model_db_              VARCHAR2(25);
   estimated_daily_demand_       NUMBER;
   estimated_demand_expiry_date_ DATE;
   order_point_compensator_      NUMBER := 0;
   dist_calendar_id_             VARCHAR2(10);
   manuf_calendar_id_            VARCHAR2(10);
BEGIN
   Update_Cache___(contract_, part_no_);
   
   IF (micro_cache_value_.planning_method IS NULL) THEN
      -- this means that the record was not found in the table
      RAISE exit_procedure_;
   END IF;
   
   today_             := TRUNC(Site_API.Get_Site_Date(contract_));
   dist_calendar_id_  := Site_API.Get_Dist_Calendar_Id(contract_);
   manuf_calendar_id_ := Site_API.Get_Manuf_Calendar_Id(contract_);

   IF ((micro_cache_value_.planning_method IN ('B','C')) AND
       (micro_cache_value_.order_point_qty = 0)) THEN

      next_order_qty_          := 0;
      next_order_date_         := Database_SYS.last_calendar_date_;
      days_to_next_order_date_ := next_order_date_ - today_;
      RAISE exit_procedure_;

   END IF;

   current_qty_on_hand_ := Inventory_Part_In_Stock_API.Get_Inventory_Quantity(
                                                        contract_               => contract_,
                                                        part_no_                => part_no_,
                                                        configuration_id_       => NULL,
                                                        qty_type_               => 'ONHAND',
                                                        expiration_control_     => 'NOT EXPIRED',
                                                        supply_control_db_      => 'NETTABLE',
                                                        ownership_type1_db_     => 'CONSIGNMENT',
                                                        ownership_type2_db_     => 'COMPANY OWNED',
                                                        include_project_        => 'FALSE');

   expected_leadtime_      := Inventory_Part_API.Get_Expected_Leadtime(contract_, part_no_);
   supply_demand_date_tab_ := Order_Supply_Demand_API.Get_Sum_Supply_Demand_Per_Date(contract_,
                                                                                     part_no_);
   stop_analysis_date_     := Inventory_Part_API.Get_Stop_Analysis_Date(
                                                             contract_                    => contract_,
                                                             part_no_                     => part_no_,
                                                             site_date_                   => today_,
                                                             dist_calendar_id_            => dist_calendar_id_,
                                                             manuf_calendar_id_           => manuf_calendar_id_,
                                                             detect_supplies_not_allowed_ => Fnd_Boolean_API.db_false,
                                                             use_expected_leadtime_       => Fnd_Boolean_API.db_true);
   IF (micro_cache_value_.planning_method = 'B') THEN
      demand_model_db_ := Get_Demand_Model_Db___(contract_, part_no_);
   END IF;

   CASE NVL(demand_model_db_,'FORECAST')
      WHEN 'YEARLY PREDICTION' THEN
         estimated_demand_expiry_date_ := Database_SYS.last_calendar_date_;
         estimated_daily_demand_       := NVL(micro_cache_value_.qty_predicted_consumption, 0) / 365;
      WHEN 'HISTORY' THEN
         estimated_demand_expiry_date_ := Database_SYS.last_calendar_date_;
         estimated_daily_demand_       := Get_Historical_Daily_Demand___(contract_,
                                                                         part_no_,
                                                                         expected_leadtime_,
                                                                         today_);
      WHEN 'FORECAST' THEN
         estimated_daily_demand_       := NULL;

         Get_Forecasted_Daily_Demand___(estimated_demand_expiry_date_,
                                        estimated_daily_demand_,
                                        contract_,
                                        part_no_,
                                        today_ + 1);

         IF (estimated_daily_demand_ IS NULL) THEN
            estimated_demand_expiry_date_ := Database_SYS.last_calendar_date_;
            estimated_daily_demand_       := Get_Historical_Daily_Demand___(contract_,
                                                                            part_no_,
                                                                            expected_leadtime_,
                                                                            today_);
         END IF;
   END CASE;

   IF (Slow_Movers_Or_Croston___(contract_, part_no_)) THEN
      Next_Order_Analysis_Slow___(next_order_date_,
                                  projected_qty_on_hand_,
                                  estimated_daily_demand_,
                                  estimated_demand_expiry_date_,
                                  contract_,
                                  part_no_,
                                  today_,
                                  stop_analysis_date_,
                                  micro_cache_value_.order_point_qty,
                                  expected_leadtime_,
                                  current_qty_on_hand_,
                                  supply_demand_date_tab_,
                                  vendor_no_);
   ELSE
      Next_Order_Analysis_Others___(next_order_date_,
                                    projected_qty_on_hand_,
                                    estimated_daily_demand_,
                                    estimated_demand_expiry_date_,
                                    contract_,
                                    part_no_,
                                    today_,
                                    stop_analysis_date_,
                                    micro_cache_value_.safety_stock,
                                    expected_leadtime_,
                                    current_qty_on_hand_,
                                    supply_demand_date_tab_,
                                    vendor_no_);

      order_point_compensator_ := micro_cache_value_.order_point_qty - micro_cache_value_.safety_stock;
   END IF;

   days_to_next_order_date_ := TRUNC(next_order_date_) - today_;

   IF (micro_cache_value_.planning_method = 'B') THEN
      lot_size_ := CASE micro_cache_value_.lot_size WHEN 0 THEN 1 ELSE micro_cache_value_.lot_size END;

      WHILE ((lot_count_ * lot_size_ + projected_qty_on_hand_) <= 
                                 (micro_cache_value_.order_point_qty - order_point_compensator_)) LOOP
         lot_count_ := lot_count_ + 1;
      END LOOP;

      next_order_qty_ := lot_count_ * lot_size_;

   ELSIF (micro_cache_value_.planning_method = 'C') THEN
      next_order_qty_ := lot_size_ - projected_qty_on_hand_ - order_point_compensator_;
   END IF;

EXCEPTION
   WHEN exit_procedure_ THEN
      NULL;
END Make_Next_Order_Analysis;

PROCEDURE Modify_Safety_Lead_Time (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   safety_lead_time_ IN NUMBER )
IS
   record_ inventory_part_planning_tab%ROWTYPE;
BEGIN
   record_                  := Lock_By_Keys___(contract_, part_no_);
   record_.safety_lead_time := safety_lead_time_;
   Modify___(record_);
END Modify_Safety_Lead_Time;

PROCEDURE Handle_Site_Ipr_Activation(
   attr_ IN VARCHAR2)
IS 
   TYPE Inv_Part_Planning_Tab_Type IS TABLE OF inventory_part_planning_tab%ROWTYPE INDEX BY PLS_INTEGER;  
   inventory_part_planning_tab_  Inv_Part_Planning_Tab_Type; 
   
   oldrec_     inventory_part_planning_tab%ROWTYPE;
   newrec_     inventory_part_planning_tab%ROWTYPE;
   contract_   inventory_part_planning_tab.contract%TYPE;
   
   CURSOR get_planning_parts IS 
      SELECT *
      FROM inventory_part_planning_tab
      WHERE contract = contract_
      FOR UPDATE;
BEGIN
   $IF Component_Invpla_SYS.INSTALLED $THEN
   contract_ := Client_SYS.Get_Item_Value('CONTRACT', attr_);
   OPEN get_planning_parts;
   LOOP   
      FETCH get_planning_parts BULK COLLECT INTO inventory_part_planning_tab_ LIMIT 10000;
      EXIT WHEN inventory_part_planning_tab_.COUNT = 0;

      FOR i_ IN inventory_part_planning_tab_.FIRST .. inventory_part_planning_tab_.LAST LOOP

         IF Inv_Part_Planning_Method_API.Is_Order_Point_Or_Tpss(inventory_part_planning_tab_(i_).planning_method) THEN 

            Inventory_Part_Invpla_Info_API.New(inventory_part_planning_tab_(i_).contract,
                                               inventory_part_planning_tab_(i_).part_no,
                                               inventory_part_planning_tab_(i_).planning_method); 

            IF Inv_Part_Planning_Method_API.Is_Order_Point(inventory_part_planning_tab_(i_).planning_method) AND 
               ((inventory_part_planning_tab_(i_).safety_stock_auto    = Inventory_Part_Safe_Stock_API.DB_AUTO_SAFETY_STOCK) OR 
                (inventory_part_planning_tab_(i_).order_point_qty_auto = Inventory_Part_Order_Point_API.DB_AUTO_ORDER_POINT)OR 
                (inventory_part_planning_tab_(i_).lot_size_auto        = Inventory_Part_Lot_Size_API.DB_AUTO_LOT_SIZE))THEN 
                
               oldrec_ := inventory_part_planning_tab_(i_); 
               newrec_ := oldrec_;
               newrec_.safety_stock_auto    := Inventory_Part_Safe_Stock_API.DB_MANUAL_SAFETY_STOCK;
               newrec_.order_point_qty_auto := Inventory_Part_Order_Point_API.DB_MANUAL_ORDER_POINT;
               newrec_.lot_size_auto        := Inventory_Part_Lot_Size_API.DB_MANUAL_LOT_SIZE;

               newrec_.safety_stock    := 0;
               newrec_.order_point_qty := 0;
               newrec_.lot_size        := 1;
               
               Modify___(newrec_);
               
            END IF;
         END IF;
      END LOOP; -- Collection loop inventory_part_planning_tab_.    
   END LOOP; -- Bulk collect cursor loop get_planning_parts.
   CLOSE get_planning_parts;
   $ELSE
      NULL;
   $END 
END Handle_Site_Ipr_Activation;
