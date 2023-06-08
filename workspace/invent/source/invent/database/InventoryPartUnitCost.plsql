-----------------------------------------------------------------------------
--
--  Logical unit: InventoryPartUnitCost
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210602  SADELK  SM2020R1-5866, Added Get_Max_Objversion.
--  200921  LEPESE  SC2021R1-291. added source_ref_type 'WORK_TASK' in methods Get_Details_From_Costing___ and Complete_Cost_Details___.
--  200824  RoJalk  SC2020R1-9252,Modified get_quantity_in_order_transit cursor in Revalue_Inventory___ and added a check to filter COMPANY OWNED stock 
--  200824          and also select activity_seq from inventory_part_in_transit_pub.
--  191216  ErRalk  SCSPRING20-1108, Renamed Purchase_Requisitioner_API.Get_Requisitioner_Code into Requisitioner_API.Get_Requisitioner_Code.
--  190925  SURBLK  Added Validate_Cost_Level() to handle error messages and avoid code duplication.
--  161108  ChJalk  Bug 132475, Modified Cond_Lot_Ser_Std_Cost_Exist___ to avoid checking the records with '*' lot_batch_no.
--  160524  ErFelk  Bug 128143, Modified Complete_Cost_Details___() by adding a new source_ref_type_db_ 'INTER_COMPANY_MOVE' to the condition.
--  150727  Asawlk  Bug 121753, Modified New_Configuration() by adding a condition to check COST PER CONFIGURATION.
--  150512  IsSalk  KES-422, Passed new parameter source_ref5_ to Inventory_Transaction_Hist_API. Create_And_Account.
--  150519  BudKlk  Bug 122422, Modified the method Create_Cost_Diff_Tables() to make sure not to create diff tables when the unit_cost of the transaction is zero.
--  150414  JoAnSe  MONO-188, Made Non_Zero_Cost_Detail_Exist___ public.
--  141113  SeJalk  Bug 119633, Modified Get_Details_From_Last_Trans___ by returning the estimated material cost if no transactions available for the part and the
--  141117          calling process is IPR UNIT COST SNAPSHOT.
--  140626  MaEelk  Modified Get_Default_Cond_Details___, Get_Default_Lot_Details___ and Get_Default_Serial_Details___ 
--  140626          to fetch estimated condition cost in these methods when calling_process_ = 'CRO CONFIRMATION' also.
--  140613  AwWElk  PRSC-1451, Modified Generate_New_Cost_Details___() by adding conditional compilation for PURCH methods.
--  140522  LEPESE  PBSC-9810, post-merge corrections to adapt bug 115023 to new ownership types and new code structure in Apps9.
--  140522  UdGnlk  PBSC-9810, Merged Bug 115023, Added parameter zero_cost_flag_db_ to the methods Get_Default_Part_Details___() and 
--  140522          Get_Default_Config_Details___. Modified methods Get_Default_Serial_Details___(), Get_Default_Details(), Get_Default_Part_Details___()
--  140522          and Get_Default_Config_Details___ in order to consider the company owned stock for the part, if Zero cost is allowed.
--  140520  IsSalk  Bug 113974, Added parameter put_to_transit_ to the methods Manage_Standard_Cost() and Manage_Part_Config_Std_Cost___(). Added method
--  140520          Modify_Configuration_Cost___(). Modified methods Manage_Part_Config_Std_Cost___, Manage_Standard_Cost and Modify_Level_Cost_Details() in
--  140520          order to transfer standard cost per configuration from one site to another in intersite flows and to allow modifications of Level Cost Details
--  140520          for configured parts. Added Method Raise_Cost_Level_Error___() in order to raise error message for wrong Inventory Part Cost Level. Modified methods
--  140520          Modify_Serial_Cost___(), Modify_Condition_Cost___(), Modify_Lot_Batch_Cost___() and Modify_Part_Cost___() in order to use Raise_Level_Error().
--  140424  GayDLK  Bug 116092, Modified Modify_Cost_Details___(), Add_Zero_Default_And_Check___() and Check_Zero_Cost_Flag___() by adding
--  140424          new parameter valuation_method_db_ to pass the inventory_valuation_method used. Added validation logics to check
--  140424          whether standard costs exist if the valuation method used is standard cost. 
--  140409  LEPESE  PBSC-8249, Added methods Check_Remove_Part_Config__, Do_Remove_Part_Config__, Remove_Part_Config___.
--  140129  UdGnlk  Merged Bug 113089, Modified Check_Insert() and Check_Cost_Bucket_Id___() to include the part no and contract 
--  140129          in the error BUCKETERR2 to make it more informative.
--  130801  ChJalk  TIBE-884, Removed the global variables.
--  130529  GanNlk  Bug 110303, Added two additional parameters to display part_no and site in the messages NOZEROALLOWED and ZEROCOSTONLY.
--  130515  IsSalk  Bug 106680, Replaced Installed_Component_SYS.<component> with Component_<component>_SYS.<component>.
--  130530  Asawlk  EBALL-37, Replaced the calls to Inventory_Part_In_Stock_API.Get_Company_Owned_Inventory() with a call to 
--  130530          Invent_Part_Quantity_Util_API.Get_Company_Owned_Inventory().
--  130528  Asawlk  EBALL-37, Modified methods Check_Zero_Cost_Flag___, Manage_Part_Config_Std_Cost___, Part_Config_Std_Cost_Exist___, 
--  130528          Check_Delete_From_Client___, and Remove, to use Invent_Part_Quantity_Util_API.Check_Quantity_Exist(). 
--  130517  Asawlk  EBALL-37, Modified Revalue_Inventory___() to include the quantities at customer.
--  130322  Asawlk  EBALL-37, Modified Revalue_Inventory___(), Manage_Part_Config_Std_Cost___(), Part_Config_Std_Cost_Exist___(),
--  130322          Check_Delete_From_Client___() and Get_Tot_Company_Owned_Stock() to make the calls to Inventory_Part_At_Customer_API static.
--  130322          Also removed constant inst_InventoryPartAtCustomer_.  
--  121122  NaLrlk  Modified Check_Zero_Cost_Flag___, Manage_Part_Config_Std_Cost___ and Part_Config_Std_Cost_Exist___ to exclude
--  121122          the Supplier Rented and Company Rental Asset ownerships from Inventory_Part_In_Stock_API.Check_Quantity_Exist.
--  120220  Asawlk  Bug 100479, Modified Generate_New_Cost_Details___() by changing the condition to retrieve the details 
--  120220          from costing when unit_cost != 0. 
--  120111  Asawlk  Bug 100131, Modified Manage_Part_Config_Std_Cost___() and Part_Config_Std_Cost_Exist___() to check whether
--  120111          cost set one has been calculated with value zero. If so used zero as the standard cost.
--  120106  LEPESE  Added calls to Mpccom_Transaction_Code_API.Is_Vendor_Consignment in Make_Revalue_Transaction___
--  120106          in order to set the correct ownership on the revaluation transactions.
--  111201  AwWelk  Bug 99756, Added conditions in Manage_Part_Config_Std_Cost___ and Part_Config_Std_Cost_Exist___ 
--  111201          functions to check for the existence of any inventory transaction for a part/configuration with 
--  111201          ownership COMPANY OWNED or CONSIGNMENT.
--  110929  RoJalk  Modified Complete_Cost_Details___, Get_Details_From_Costing___ to 
--  110929          support the source ref type PUR ORDER CHG ORDER.  
--  110908  MalLlk  Correct the spelling mistake on error messages in Check_Accounting_Year___ and Check_Cost_Source_Id___.
--  110209  THIMLK  Removed the logic added to handle salvage part receipt.
--  110204  KiSalk  Moved 'User Allowed Site' Default Where condition from client to VIEW_SUM and base view.
--  110112  THIMLK  Added a new implementation method, Get_Estim_Cond_Cost_Details___() and modified the method
--  110112          Get_Default_Cond_Details___() to calculate cost when the calling process is 'SALVAGE PART RECEIPT'.
--  100715  GayDLK  Bug 89478, Modified methods Get_Wa_Config_Cost_Details___() and 
--  100715          Get_Cond_Lot_Ser_Level_Cost___() for performance optimizations.
--  100507  KRPELK  Merge Rose Method Documentation.
--  100420  MaRalk  Modified reference by name method call to Inventory_Transaction_Hist_API.Create_And_Account
--  100420          within Make_Revalue_Transaction___ method.
--  100409  MaRalk  Removed NVL for stock.part_ownership_db from the where condition in cursor get_company_owned_inventory in Revalue_Inventory___ method.
--  100401  MaRalk  Modified cursors get_company_owned_inventory and get_vendor_consignment_stock 
--  100401          in Revalue_Inventory___ method to remove the usage of INVENTORY_PART_STOCK_OWNER_PUB view.
--  091202  SaWjlk  Bug 86900, Modified methods Modify_Part_Avg_Cost___(), Modify_Condition_Avg_Cost___ 
--  091202          and Modify_Lot_Batch_Avg_Cost___ for performance improvements.
--  090930  ChFolk  Removed parameter company_ from Make_Revalue_Transaction___ as it is not used.
--  090930          Removed unused variables in the package.
--  090924  ChFolk  Removed function Decode_Cost_Bucket_Type___ which is no longer used.
--  ----------------------------------------- 14.0.0 ------------------------------------------------------
--  090316  PraWlk  Bug 81108, Removed General_SYS.Init_Method from function Merge_Cost_Details.
--  081013  AMDILK  Bug 73884, Merge the solution from Peak App7SP4.Modified Get_Details_From_Costing___ and 
--  081008          Complete_Cost_Details___ to support source_ref_type_db_ 'WORK ORDER'.
--  080919  MaEelk  Bug 76467, Modified Get_Details_From_Last_Trans___ to pass replace_star_cost_bucket_
--  080919          to the method call Inventory_Transaction_Cost_API.Get_Transaction_Cost_Details.
--  080709  RoJalk  Bug 74811, Added vendor_no_ parameter to Generate_Cost_Details,
--  080709          Generate_Cost_Details___ and Generate_New_Cost_Details___.
--  080709          Changed source_ref parameters of Generate_New_Cost_Details___
--  080709          to be DEFAULT NULL and modified usage.
--  080507  RoJalk  Bug 73185, Added the parameters contract_, part_no_ to the
--  080507          Get_Buyer_Code___ and replaced the method call with Purchase_Buyer_API.
--  080507          Get_Buyer_Code. Repaced the method call in Get_Requisitioner_Code___
--  080507          and used Purchase_Requisitioner_API.Get_Requisitioner_Code. 
--  080507          Modified Get_Details_From_Costing___, Complete_Cost_Details___  
--  080507          to support source ref types 'PUR REQ', 'PROJECT', 'CUST ORDER'. 
--  080507          Added the parameter trans_quantity_ to Generate_Cost_Details.
--  080212  HoInlk  Bug 71082, Modified method Create_Cost_Diff_Tables to allow
--  080212          single cost details with a negative value in inventory_value.
--  080123  LEPESE  Bug 68763, Moved implementation of method Get_Cost_Bucket_Type_Db___ to method
--  080123          Invent_Cost_Bucket_Manager_API.Get_Cost_Bucket_Type_Db and call that instead.
--  080123  LEPESE  Bug 68763, Added method Generate_Cost_Details___. Added call to this method
--  080123          from Modify_Condition_Avg_Cost___, Modify_Lot_Batch_Avg_Cost___,
--  080123          Modify_Config_Avg_Cost___, Modify_Part_Avg_Cost___, Manage_Con_Lot_Ser_Std_Cost___,
--  080123          Manage_Part_Config_Std_Cost___ and Generate_Cost_Details.
--  080123  LEPESE  Changed method Non_Star_Cost_Bucket_Exist___ into a public 
--  080123          method Non_Star_Cost_Bucket_Exist.
--  080123  LEPESE  Added method Cost_To_Value_Details.
--  071204  IsAnlk  Bug 69466, Modified IF condition to check revalue_inventory_ before setting 
--                  local_revalue_inventory_ in Modify_Serial_Cost___. 
--  070912  MaMalk  Bug 67232, Replaced the call to Get_Cost_Details_And_Lock___ with 
--  070912          Get_Cost_Detail_Tab___ in Manage_Part_Config_Std_Cost___ to avoid unnecessary locks. 
--  070712  AmPalk  Bug 64893, Added parameters calling_process and last_attempt to function
--  070712          Get_Details_From_Last_Trans___ and modified all methods accordingly.
--  070516  LEPESE  Changed the parameter list for method Actual_Cost_Revalue: Removed parameters
--  070516          opening_stock_onhand_, opening_stock_cons_ and opening_stock_trans_. Replaced
--  070516          them with parameter location_group_qty_tab_. Implemented a loop over new parameter
--  070516          location_group_qty_tab_ inside the method to create revaluation transactions
--  070516          for each location_group individually.
--  070314  SuRalk  Bug 63689, Reversed the previous correction (Replaced method call
--  070314          Get_Cost_Details_By_Method with Get_Cost_Detail_Tab___). Modified method
--  070314          Check_Zero_Cost_Flag by adding cursor get_fifo_stack_key, in parameter
--  070314          valuation_method_db_ and if condition to handle FIFO/LIFO situations separately. 
--  070214  SuRalk  Bug 63689, Modified method Check_Zero_Cost_Flag by replacing method call
--  070214          Get_Cost_Detail_Tab___ with Get_Cost_Details_By_Method.
--  070124  ErSrlk  MFIT1028: Added trans_quantity_ to the param list of Generate_New_Cost_Details___ and modifed it.
--  070124          Added order_size and vendor_no to the param list of Get_Details_From_Costing___.
--  061227  RaKalk  Modified Check_Cost_Bucket_Id___ method to to give an erorr message
--  061227          if the cost bucket is of type SALESOH.
--  061219  RaKalk  Modified Overhead_Cost_Bucket_Type___ and Complete_Cost_Details___ methods
--  061219          to handle the SALESOH cost bucket type. 
--  061129  LEPESE  Added a section for inventory_part_cost_level = 'COST PER PART' in method
--  061129          Modify_Level_Cost_Details. Added method Modify_Part_Cost___.
--  061129          Modifications to enhance performance in methods Modify_Lot_Batch_Cost___,
--  061129          Modify_Condition_Cost___, Modify_Serial_Cost___, Modify_Serial_Cost and
--  061129          Find_And_Modify_Serial_Cost.
--  060210  LEPESE  Made method Get_Tot_Company_Owned_Stock public.
--  060210  LEPESE  Major changes in order to remove all implementation for the TRANSIBAL
--  060210          transactions. Removed methods Level_Transit_Account_Balance and
--  060210          Level_Transit_Acc_Balance___. Modifications in methods Modify_Average_Cost,
--  060210          Modify_Condition_Avg_Cost___, Modify_Config_Avg_Cost___, 
--  060210          Modify_Lot_Batch_Avg_Cost___, Modify_Part_Avg_Cost___.
--  060208  LEPESE  Added method Cost_Bucket_Exist.
--  060202  LEPESE  A requirement to pass configuration_id_ as parameter when calling
--  060202          Part_Cost_Sim_API.Split_Cost_Into_Buckets has lead to configuration_id_
--  060202          being added as parameter to a lot of implementation methods and also to
--  060202          public method Generate_Cost_Details.
--  060201  LEPESE  Modification in method Modify_Estimated_Mtrl_Cost___ to avoid setting the 
--  060201          estimated material cost for manufactured parts if costing is installed.
--  060131  JoAnSe  Split Get_Year_And_Source_Merged into two functions:
--  060131          Clear_Details_Year_And_Source and Merge_Cost_Details. 
--  060127  LEPESE  Redesign of method Complete_Cost_Details___ in order to assign correct
--  060127          accounting_year on all types of overhead cost buckets regardless if
--  060127          the source_source_id_ is NULL or not. Created method Overhead_Cost_Bucket_Type___.
--  060125  LEPESE  Added FUNCTION Get_Deliv_Overhead_Unit_Cost.
--  060123  LEPESE  Changed method Get_Year_And_Source_Merged___ into a public method 
--  060123          Get_Year_And_Source_Merged.
--  060123  NiDalk  Added Assert safe annotation. 
--  060120  LEPESE  Bug corrections in methods Cond_Lot_Ser_Std_Cost_Exist___ and
--  060120          Get_Condition_Cost_Details___ to get a correct result when calling
--  060120          Standard_Cost_Exist for parts having cost level = 'COST PER CONDITION'.
--  060119  IsAnlk  Added General_SYS.Init to Default_Cost_Exist method.
--  060117  LEPESE  Added methods Handle_Valuation_Method_Change and Get_Year_And_Source_Merged___.
--  060116  LEPESE  Filled methods Check_Cost_Bucket_Id___ and Check_Cost_Source_Id___ with 
--  060116  LEPESE  validation logic. Added parameter unit_cost_ to method Check_Insert.
--  060116  LEPESE  Redesign of method Check_Insert. New parameters when calling impl-methods.
--  060116  LEPESE  Moved cost_bucket_id validation from unpack_check_insert___ to Check_Insert.
--  060116  LEPESE  Redesigned method interface for Check_Accounting_Year___.
--  060112  LEPESE  Added server commit to method Enable_Cost_Details. Created method
--  060112          Non_Star_Cost_Bucket_Exist___ to make Enable_Cost_Details safe to rerun.
--  060112          Changed method Get_Wa_Cond_Cost_Details___ into Get_Wa_Condition_Cost_Details.
--  060111  LEPESE  Major redesign of all methods created to enable or disable the cost details
--  060111          functionality. Since we will always run with cost details then method
--  060111          Enable_Cost_Details with related implementation methods has been redesigned
--  060111          in order to be executed only once for the complete database during upgrade.
--  060111          It will only be executed during upgrade if Costing is installed.
--  060104  IsAnlk  Added General_SYS.Init to methods.  
--  060104  LEPESE  Changes in Modify_Lot_Batch_Avg_Cost___  and Modify_Condition_Avg_Cost___
--  060104          to get the correct values in parameter prior_avg_cost_detail_tab_.
--  051230  LEPESE  Major redesign of method Actual_Cost_Revalue because of Cost Details.
--  051227  LEPESE  A lot of method interface changes in order to be able to pass the 
--  051227          inventory valuation method down to method Make_Revalue_Transactions___.
--  051227          By passing this info as a parameter it was possible to avoid an extra db call.
--  051223  LEPESE  Made method Get_Lot_Batch_Cost_Details___ public (Get_Lot_Batch_Cost_Details).
--  051223          Changed condition for parameter quantity_ in method Add_To_Value_Detail_Tab.
--  051214  LEPESE  Changes in methods Handle_Lot_Condition_Change and 
--  051214          Handle_Serial_Condition_Change to avoid making revaule transactions when
--  051214          changing the unit cost details due to a condition code change. 
--  051214  LEPESE  Major changes in inventory revaluation logic to create the revaulation
--  051214          transactions per condition code. Big changes in methods Revalue_Inventory___
--  051214          and Level_Transit_Acc_Balance___. 
--  051212  LEPESE  Added parameters lot_batch_no_ and condition_code_ to method Set_Actual_Cost.
--  051212          Added new methods Set_Part_Actual_Cost___, Set_Config_Actual_Cost___,
--  051212          Set_Lot_Batch_Actual_Cost___ and Set_Condition_Actual_Cost___.
--  051122  LEPESE  Added parameter source_ref_type_db_ when calling method
--  051122          Standard_Cost_Bucket_API.Split_Unit_Cost_Into_Buckets().
--  051116  LEPESE  Added method Get_Cost_Details_By_Condition.
--  051116  JoEd    Changed column title (prompt) for accounting_year and the ACYEAR* messsages.
--  051104  LEPESE  Added cost_source_date_ when calling for cost_source_id_ in Complete_Cost_Details___.
--  051102  LEPESE  Changed impl method Modify___ into private method Modify_Cost_Detail__.
--  051101  LEPESE  Changed method Get_Weight_Avg_Cost_Details___ to public Get_Weighted_Avg_Cost_Details.
--  051101          Adapted method Set_Actual_Cost to Cost Details functionality.
--  051028  LEPESE  Modifications in method Complete_Cost_Details___ to avoid getting an error
--  051028          message when trying to fetch cost source ID for a cost bucket type for which
--  051028          we can't do that in Inventory. Also a temporary fix to avoid calling PURCH
--  051028          when having another source ref type than PUR ORDER for new material details.
--  051028          Removed method Check_Unit_Cost___. Removed all calls to this method. 
--  051028          Removed parameter unit_cost_ from method Check_Insert.
--  051028          Change in method Get_Default_Part_Details___ to ignore zero value details.
--  051028          Added error message in Get_Default_Cond_Details___ when condition_code_ = NULL.
--  051026  LEPESE  Added method Get_Wa_Condition_Cost.
--  051025  LEPESE  Added attribute cost_bucket_public_type.
--  051021  LEPESE  Changes in Cond_Lot_Ser_Std_Cost_Exist___ to make sure that method returns
--  051021          FALSE whenever executed for serial_no = '*' and COST PER SERIAL.
--  051018  LEPESE  Made method Create_Cost_Diff_Tables___ public (Create_Cost_Diff_Tables).
--  051017  LEPESE  Added parameter calling_process_ to methods Get_Default_Details,
--  051017          Default_Cost_Exist, Get_Default_Cond_Details___, Get_Default_Lot_Details___
--  051017          and Get_Default_Serial_Details___. Implemented calls to fetch estimated
--  051017          condition cost in these methods when calling_process_ = 'WORK ORDER RECEIPT'.
--  051013  LEPESE  Added part_no_ to Merge_And_Compete_Details and Complete_Cost_Details___.
--  051013          Added method Get_Requisitioner_Code___ and expanded parameter lists in
--  051013          calls to Cost_Type_Source_Indicator_API methods.
--  051006  LEPESE  Added method Check_Delete_From_Client___.
--  051006  LEPESE  Modifications in method Make_Revalue_Transaction___. Called new method
--  051006          Inventory_Transaction_Hist_API.Create_And_Account which replaces two calls,
--  051006          one to method New and one to method Do_Transaction_Booking.
--  050930  LEPESE  Removed all code connected to the company parameter for enabling and
--  050930          disabling the cost details functionality. From now on we regards the cost
--  050930          details functionality as "always enabled".
--  050928  LEPESE  Merged DMC changes below.
--  ********************* DMC Merge Begin ************************
--  050909  LEPESE  A lot of changes in different methods to pass inventory_part_rec_ down to
--  050909          method Complete_Cost_Details___. In this method code is added to always
--  050909          assign * to accounting_year and cost_source_id when using Standard Cost
--  050909          valuation for COST PER PART or COST PER CONFIGURATON.
--  050907  LEPESE  Correction in method Add_To_Value_Detail_Tab to not include row when qty = 0.
--  050829  LEPESE  A total redesign of the LU because of the Cost Details functionality.
--  050517  LEPESE  Added new key columns accounting_year, cost_bucket_id, company and cost_source_id.
--  ********************* DMC Merge End ************************
--  041101  Samnlk  Added a another TRUE value to call Inventory_Part_In_Stock_API.Check_Quantity_Exist in methods Check_Inventory_Value___
--  041101          and Init_Inventory_Value.
--  040921  HeWelk  Passed null to paramater catch_quantity in Inventory_Transaction_Hist_API.New.
--  040827  DAYJLK  Call ID 117232, Modified Modify_Condition_Avg_Cost___ by modifying the parameters to call Level_Transit_Account_Balance.
--  040617  SHVESE  M4/Transibal- Added new method Level_Transit_Account_Balance. Modified methods
--  040617          Revalue_Inventory___, Modify_Condition_Avg_Cost___,Modify_Config_Avg_Cost___,Modify_Part_Avg_Cost___.
--  040617          Added parameter transit_qty_direction_db_ to Modify_Average_Cost.
--  040517  DaZaSe  Project Inventory: Added zero/null-parameters to call Inventory_Transaction_Hist_API.New,
--                  change these parameters to real Activity_Seq and Project_Id values if this functionality uses Project Inventory.
--  ************************  Touchdown Merge Begin  **************************
--  040302  LEPESE  Modifications in method Set_Actual_Cost to make it possible to
--                  use this method when running transaction based supplier invoice
--                  consideration for weighted average valuated parts.
--  040225  LEPESE  Modifications in methods Modify_Average_Cost, Modify_Condition_Avg_Cost___,
--                  Modify_Config_Avg_Cost___ and Modify_Part_Avg_Cost___ in order to pass
--                  prior_average_qty and prior_average_cost back to calling methods.
--  040219  JoAnSe  Added Lock_By_Keys_Wait and Lock_By_Keys_No_Wait
--  040215  LEPESE  Moved implementation of method Modify_Serial_Cost to new
--                  implementation method Modify_Serial_Cost___.
--  040208  LEPESE  Added method Find_And_Modify_Serial_Cost.
--  040129  LEPESE  Replaced actual_cost with invoice_consideration.
--  ************************  Touchdown Merge End  *****************************
--  031211  LEPESE  Bug 41430. Change in method Generate_Lot_Batch_Serial___ to only create
--                  new records for lots/batches and serials currently in stock.
--  031019  LEPESE  Added call to Inventory_Part_Config_API.Get_Estimated_Material_Cost in
--                  method Get_Cond_Lot_Ser_Level_Cost___.
--  031017  LEPESE  Added parameter part_cost_level_db_ to method Get_Cond_Lot_Ser_Level_Cost___.
--                  When no cost record is found for part having COST PER CONDITION then
--                  check if already existing in PartCatalog, then use CC from PartCatalog.
--  031017  LEPESE  Minor modification to method Get_Cond_Lot_Ser_Level_Cost___ to call method
--                  recursively if no record is found will all five keys.
--  031010  LEPESE  Minor modification to method Remove in order to check for existence before
--                  trying to remove the record. To prevent errors when issuing customer owned stock.
--  031010  LEPESE  Modification to method Get_Invent_Value_By_Condition in order to fetch
--                  a value from the "estimated cost per condition" basic data when no records
--                  with a corresponding condition code can be found in this LU.
--  031006  LEPESE  Added method Remove.
--  030904  LEPESE  Reimplementation of bug ID 32465. Complete redesign of the methods that
--                  creates revaluation transactions and postings when a change of
--                  inventory value occurs. New methods are Revalue_Inventory___ and
--                  Make_Revalue_Transaction___. Complete redesign of method Actual_Cost_Revalue.
--  030813  LEPESE  Corrected bug in method Modify_Condition_Cost__.
--  030812  LEPESE  Minor modification of method Get_Invent_Value_By_Condition.
--  030806  LEPESE  Removed the two latest changes made by SuAmlk.
--                  Added three new implemenation methods; Get_Part_Level_Cost___,
--                  Get_Config_Level_Cost___ and Get_Cond_Lot_Ser_Level_Cost___.
--                  Complete remake of method Get_Inventory_Value_By_Method.
--                  Replaced business logic in method Get_Inventory_Value_By_Config with call
--                  to Get_Inventory_By_Method.
--                  Complete remake of method Get_Invent_Value_By_Condition.
--  030716  SuAmlk  Modified FUNCTION Get_Cost_Per_Condition to handle the condition estimated_cost is null.
--  030715  SuAmlk  Added FUNCTION Get_Cost_Per_Condition and modified FUNCTION Get_Inventory_Value_By_Method to fetch estimated cost when inventory value is null.
--  030707  MaEelk  Removed the call Inventory_Part_In_Stock_API.Get_Aggregate_Qty_Consignment from Get_INventory_Value_By Config.
--  030702  MaGulk  Replaced calls to Inventory_Part_In_Stock_API.Get_Aggregate_Qty_Onhand & Inventory_Part_In_Stock_API.Get_Total_Qty_In_Transit with
--  030702          Inventory_Part_In_Stock_API.Get_Company_Owned_Inventory, Inventory_Part_In_Stock_API.Check_Exist & Inventory_Part_In_Stock_API.Get_Externally_Owned_Inventory in
--  030702          in Revalue_Impl___, Check_Delete___, Check_Inventory_Value___, Modify_Part_Avg_Cost___,
--  030702          Modify_Config_Avg_Cost___, Modify_Condition_Avg_Cost___, Get_Inventory_Value_By_Config & Init_Inventory_Value.
--  030613  KiSalk  Call 98532 - For calculating new_inventory_value_ in Modify_Part_Avg_Cost___,
--                  oldrec_.inventory_value replaced by old_inventory_value_
--  030502  LEPESE  Redesign of methods Handle_Lot_Condition_Change and
--                  Handle_Serial_Condition_Change in order to work also for Standard Cost.
--                  Created method Check___ for common validations (both insert and update).
--                  Added methods Modify_Lot_Batch_Cost and Modify_Serial_Cost.
--  030430  LEPESE  Removed parameters lot_batch_no_ and serial_no_ from Modify_Inventory_Value.
--                  Changed interface of method Modify_Config_Avg_Cost___. Created new
--                  Method Modify_Part_Avg_Cost___.
--  030429  LEPESE  Added parameter part_cost_level_db_ to method Check_Zero_Cost_Flag.
--                  Renamed method New to New_Configuration and removed two parameters.
--  030428  LEPESE  Added parameters condition_code_, valuation_method_db_
--                  and part_cost_level_db_ to method Init_Inventory_Value.
--  030427  LEPESE  Added parameters lot_batch_no and serial_no to method Init_Inventory_Value.
--  030416  LEPESE  Changed name of method from Handle_Average_Level_Change to
--                  Handle_Part_Cost_Level_Change. Added methods
--                  Generate_Lot_Batch_Serial___ and Remove_Lot_Batch_Serial___.
--  030415  LEPESE  Further implementation in method Handle_Average_Level_Change in order to
--                  take care of the change from "WA per configuration" to "WA per condition".
--  021009  LEPESE  Modification of method Modify_Inventory_Value to avoid hard error
--                  when receiving a actual cost part into inventory for the first time.
--  020913  LEPESE  Added methods Modify_Condition_Cost, Modify_Condition_Cost__,
--                  Is_Executing___ and Handle_Lot_Batch_Removal.
--  020906  LEPESE  Added NVL to return value for Get_Invent_Value_By_Condition and
--                  Get_Inventory_Value_By_Config.
--  020826  LEPESE  Added validations in Check_Delete___.
--  020823  LEPESE  Added public method Handle_Average_Level_Change.
--  020822  LEPESE  Added public method Handle_Serial_Removal.
--  020822  LEPESE  Removed reference to PartSerialCatalog from base view.
--  020822  LEPESE  Added check for condition_code_ NULL in Modify_Condition_Avg_Cost___.
--  020815  LEPESE  Added public function Get_Invent_Value_By_Condition. Bug correction
--                  in methods Handle_Lot_Condition_Change and Handle_Serial_Condition_Change.
--                  Added public function Get_Inventory_Value_By_Config.
--  020814  LEPESE  Removed latest modification by SAABLK.
--  020814  LEPESE  Added validations in methods Handle_Lot_Condition_Change and
--                  Handle_Serial_Condition_Change in order to prevent change of
--                  condition code for lots and serials that are reserved in inventory.
--  020813  SAABLK  Modified parameters to New as requested by ARAMLK.
--  020813  LEPESE  Completed implementation of functionality for Condition Code change.
--                  This is now handled by methods Handle_Lot_Condition_Change and
--                  Handle_Serial_Condition_Change. These two methods must not be called
--                  from ANY other place than the update___ methods in PartSerialCatalog
--                  and LotBatchMaster.
--  020620  LEPESE  Created the new Weighted Average calculation method for
--                   "Weighted Average Per Condition". New implementation methods are
--                   Modify_Condition_Avg_Cost___ and Modify_Config_Avg_Cost___.
--  020613  LEPESE  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE Cost_Detail_Rec IS RECORD (
   accounting_year            inventory_part_unit_cost_tab.accounting_year%TYPE,
   contract                   inventory_part_unit_cost_tab.contract%TYPE,
   cost_bucket_id             inventory_part_unit_cost_tab.cost_bucket_id%TYPE,
   company                    inventory_part_unit_cost_tab.company%TYPE,
   cost_source_id             inventory_part_unit_cost_tab.cost_source_id%TYPE,
   unit_cost                  inventory_part_unit_cost_tab.inventory_value%TYPE);

TYPE Cost_Detail_Tab IS TABLE OF Cost_Detail_Rec
INDEX BY PLS_INTEGER;


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Check_Zero_Cost_Flag___
--   This method will call CheckInventoryValue method to do checks for valid
--   combinations of part cost level, zero cost flag and unit cost.
PROCEDURE Check_Zero_Cost_Flag___ (
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   configuration_id_    IN VARCHAR2,
   lot_batch_no_        IN VARCHAR2,
   serial_no_           IN VARCHAR2,
   zero_cost_flag_db_   IN VARCHAR2,
   part_cost_level_db_  IN VARCHAR2,
   valuation_method_db_ IN VARCHAR2,
   cost_detail_tab_     IN Cost_Detail_Tab )
IS
   lot_batch_no_temp_         INVENTORY_PART_UNIT_COST_TAB.lot_batch_no%TYPE;
   serial_no_temp_            INVENTORY_PART_UNIT_COST_TAB.serial_no%TYPE;
   total_unit_cost_           NUMBER;
   standard_cost_exist_       VARCHAR2(5);
   company_owned_stock_exist_ BOOLEAN;
BEGIN
   total_unit_cost_ := Get_Total_Unit_Cost(cost_detail_tab_);

   IF ((zero_cost_flag_db_ = 'N') AND (total_unit_cost_ = 0)) THEN
      IF (part_cost_level_db_ IN ('COST PER PART',
                                  'COST PER CONFIGURATION')) THEN
         lot_batch_no_temp_ := NULL;
         serial_no_temp_    := NULL;
      ELSE
         -- Cost Level is 'COST PER CONDITION' or 'COST PER LOT BATCH' or 'COST PER SERIAL'.
         lot_batch_no_temp_ := lot_batch_no_;
         serial_no_temp_    := serial_no_;
      END IF;
      
      IF (valuation_method_db_ = Inventory_Value_Method_API.DB_STANDARD_COST) THEN
         standard_cost_exist_ := Standard_Cost_Exist(contract_,
                                                     part_no_,
                                                     configuration_id_,
                                                     lot_batch_no_,
                                                     serial_no_,
                                                     condition_code_ => NULL);
      ELSE    
         company_owned_stock_exist_ := Invent_Part_Quantity_Util_API.Check_Quantity_Exist(
                                                                   contract_                      => contract_,
                                                                   part_no_                       => part_no_,
                                                                   configuration_id_              => configuration_id_,
                                                                   lot_batch_no_                  => lot_batch_no_temp_,
                                                                   serial_no_                     => serial_no_temp_,
                                                                   exclude_customer_owned_stock_  => 'TRUE',
                                                                   exclude_supplier_loaned_stock_ => 'TRUE',
                                                                   exclude_supplier_owned_stock_  => 'TRUE',
                                                                   exclude_supplier_rented_stock_ => 'TRUE',
                                                                   exclude_company_rental_stock_  => 'TRUE');         
      END IF;

      IF ((standard_cost_exist_ = Fnd_Boolean_API.DB_TRUE) OR (company_owned_stock_exist_)) THEN
          Error_SYS.Record_General(lu_name_, 'NOZEROALLOWED: Cost of the part cannot be 0 for part :P1 on Site :P2 when :P3.',part_no_, contract_, Inventory_Part_Zero_Cost_API.Decode(zero_cost_flag_db_));
      END IF;
   END IF;

   IF ((zero_cost_flag_db_ = 'O') AND (total_unit_cost_ != 0)) THEN
      Error_SYS.Record_General(lu_name_, 'ZEROCOSTONLY: Cost of the part has to be 0 for part :P1 on Site :P2 when :P3.', part_no_, contract_, Inventory_Part_Zero_Cost_API.Decode(zero_cost_flag_db_));
   END IF;
END Check_Zero_Cost_Flag___;


-- Revalue_Inventory___
--   This method takes care of the revaluation of existing quantities in
--   stock when the unit cost is changed.
PROCEDURE Revalue_Inventory___ (
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   configuration_id_    IN VARCHAR2,
   lot_batch_no_        IN VARCHAR2,
   serial_no_           IN VARCHAR2,
   part_cost_level_db_  IN VARCHAR2,
   valuation_method_db_ IN VARCHAR2,
   old_cost_detail_tab_ IN Cost_Detail_Tab,
   new_cost_detail_tab_ IN Cost_Detail_Tab )
IS
   lot_batch_no_temp_    INVENTORY_PART_UNIT_COST_TAB.lot_batch_no%TYPE;
   serial_no_temp_       INVENTORY_PART_UNIT_COST_TAB.serial_no%TYPE;
   location_group_       VARCHAR2(20);
   

   CURSOR get_company_owned_inventory (contract_         IN VARCHAR2,
                                       part_no_          IN VARCHAR2,
                                       configuration_id_ IN VARCHAR2,
                                       lot_batch_no_     IN VARCHAR2,
                                       serial_no_        IN VARCHAR2) IS
      SELECT location.location_group,
             stock.activity_seq,
             CASE stock.serial_no
                WHEN '*' THEN
                   CASE stock.lot_batch_no
                      WHEN '*' THEN NULL ELSE lot.condition_code END
                ELSE serial.condition_code END condition_code,
             SUM(stock.qty_onhand)          sum_qty_onhand,
             SUM(stock.qty_in_transit)      sum_qty_in_transit
       FROM  inventory_part_in_stock_pub    stock,
             inventory_location_pub         location,             
             rotable_part_pool_tab          pool,
             part_serial_catalog_pub        serial,
             lot_batch_master_pub           lot
      WHERE  stock.contract         = location.contract
        AND  stock.location_no      = location.location_no
        AND  stock.part_no          = serial.part_no (+)
        AND  stock.serial_no        = serial.serial_no (+)
        AND  stock.part_no          = lot.part_no (+)
        AND  stock.lot_batch_no     = lot.lot_batch_no (+)        
        AND  stock.part_ownership_db = 'COMPANY OWNED'
        AND  stock.rotable_part_pool_id = pool.rotable_part_pool_id (+)
        AND  NVL(pool.rotable_pool_asset_type,'INVENTORY ASSET') = 'INVENTORY ASSET'
        AND (stock.lot_batch_no     = lot_batch_no_ OR lot_batch_no_ IS NULL)
        AND (stock.serial_no        = serial_no_    OR serial_no_    IS NULL)
        AND  stock.configuration_id = configuration_id_
        AND  stock.contract         = contract_
        AND  stock.part_no          = part_no_
      GROUP BY location.location_group,
               stock.activity_seq,
               CASE stock.serial_no
                  WHEN '*' THEN
                     CASE stock.lot_batch_no
                        WHEN '*' THEN NULL ELSE lot.condition_code END
                  ELSE serial.condition_code END;

   CURSOR get_vendor_consignment_stock (contract_         IN VARCHAR2,
                                        part_no_          IN VARCHAR2,
                                        configuration_id_ IN VARCHAR2,
                                        lot_batch_no_     IN VARCHAR2,
                                        serial_no_        IN VARCHAR2) IS
      SELECT location.location_group,
             stock.activity_seq,
             CASE stock.serial_no
                WHEN '*' THEN
                   CASE stock.lot_batch_no
                      WHEN '*' THEN NULL ELSE lot.condition_code END
                ELSE serial.condition_code END condition_code,
             SUM(stock.qty_onhand)          sum_qty_onhand
       FROM  inventory_part_in_stock_pub    stock,
             inventory_location_pub         location,             
             part_serial_catalog_pub        serial,
             lot_batch_master_pub           lot
      WHERE  stock.contract         = location.contract
        AND  stock.location_no      = location.location_no
        AND  stock.part_no          = serial.part_no (+)
        AND  stock.serial_no        = serial.serial_no (+)
        AND  stock.part_no          = lot.part_no (+)
        AND  stock.lot_batch_no     = lot.lot_batch_no (+)        
        AND  stock.part_ownership_db   = 'CONSIGNMENT'
        AND (stock.lot_batch_no     = lot_batch_no_ OR lot_batch_no_ IS NULL)
        AND (stock.serial_no        = serial_no_    OR serial_no_    IS NULL)
        AND  stock.configuration_id = configuration_id_
        AND  stock.contract         = contract_
        AND  stock.part_no          = part_no_
      GROUP BY location.location_group,
               stock.activity_seq,
               CASE stock.serial_no
                  WHEN '*' THEN
                     CASE stock.lot_batch_no
                        WHEN '*' THEN NULL ELSE lot.condition_code END
                  ELSE serial.condition_code END;

   CURSOR get_quantity_in_order_transit (contract_         IN VARCHAR2,
                                         part_no_          IN VARCHAR2,
                                         configuration_id_ IN VARCHAR2,
                                         lot_batch_no_     IN VARCHAR2,
                                         serial_no_        IN VARCHAR2) IS
      SELECT transit.activity_seq,
             CASE transit.serial_no
                WHEN '*' THEN
                   CASE transit.lot_batch_no
                      WHEN '*' THEN NULL ELSE lot.condition_code END
                ELSE serial.condition_code END condition_code,
             SUM(transit.quantity)          sum_qty_in_transit
       FROM  inventory_part_in_transit_pub  transit,
             part_serial_catalog_pub        serial,
             lot_batch_master_pub           lot
      WHERE  transit.part_no           = serial.part_no (+)
        AND  transit.serial_no         = serial.serial_no (+)
        AND  transit.part_no           = lot.part_no (+)
        AND  transit.lot_batch_no      = lot.lot_batch_no (+)
        AND  transit.part_ownership_db = 'COMPANY OWNED'
        AND (transit.lot_batch_no      = lot_batch_no_ OR lot_batch_no_ IS NULL)
        AND (transit.serial_no         = serial_no_    OR serial_no_    IS NULL)
        AND  transit.configuration_id  = configuration_id_
        AND  transit.contract          = contract_
        AND  transit.part_no           = part_no_
      GROUP BY transit.activity_seq,
               CASE transit.serial_no
                  WHEN '*' THEN
                     CASE transit.lot_batch_no
                        WHEN '*' THEN NULL ELSE lot.condition_code END
                  ELSE serial.condition_code END;

   CURSOR get_quantity_at_customer (contract_         IN VARCHAR2,
                                    part_no_          IN VARCHAR2,
                                    configuration_id_ IN VARCHAR2,
                                    lot_batch_no_     IN VARCHAR2,
                                    serial_no_        IN VARCHAR2) IS
      SELECT at_customer.process_type,
             at_customer.activity_seq,
             CASE at_customer.serial_no
                WHEN '*' THEN
                   CASE at_customer.lot_batch_no
                      WHEN '*' THEN NULL ELSE lot.condition_code END
                ELSE serial.condition_code END condition_code,
             SUM(at_customer.quantity)         sum_qty_at_customer
       FROM  inventory_part_at_customer_tab at_customer,
             part_serial_catalog_pub        serial,
             lot_batch_master_pub           lot
      WHERE  at_customer.part_no          = serial.part_no (+)
        AND  at_customer.serial_no        = serial.serial_no (+)
        AND  at_customer.part_no          = lot.part_no (+)
        AND  at_customer.lot_batch_no     = lot.lot_batch_no (+)
        AND (at_customer.lot_batch_no     = lot_batch_no_ OR lot_batch_no_ IS NULL)
        AND (at_customer.serial_no        = serial_no_    OR serial_no_    IS NULL)
        AND  at_customer.configuration_id = configuration_id_
        AND  at_customer.contract         = contract_
        AND  at_customer.part_no          = part_no_
      GROUP BY at_customer.process_type,
               at_customer.activity_seq,
               CASE at_customer.serial_no
                  WHEN '*' THEN
                     CASE at_customer.lot_batch_no
                        WHEN '*' THEN NULL ELSE lot.condition_code END
                  ELSE serial.condition_code END;

BEGIN

   IF (part_cost_level_db_ IN ('COST PER PART',
                               'COST PER CONFIGURATION')) THEN
      lot_batch_no_temp_ := NULL;
      serial_no_temp_    := NULL;
   ELSE
      -- Cost Level is 'COST PER CONDITION' or 'COST PER LOT BATCH' or 'COST PER SERIAL'.
      lot_batch_no_temp_ := lot_batch_no_;
      serial_no_temp_    := serial_no_;
   END IF;

   FOR company_owned_rec_ IN get_company_owned_inventory (contract_,
                                                          part_no_,
                                                          configuration_id_,
                                                          lot_batch_no_temp_,
                                                          serial_no_temp_) LOOP
      Make_Revalue_Transactions___(contract_,
                                   part_no_,
                                   configuration_id_,
                                   lot_batch_no_temp_,
                                   serial_no_temp_,
                                   old_cost_detail_tab_,
                                   new_cost_detail_tab_,
                                   'INVREVAL+',
                                   'INVREVAL-',
                                   NVL(company_owned_rec_.sum_qty_onhand,0),
                                   company_owned_rec_.location_group,
                                   company_owned_rec_.activity_seq,
                                   company_owned_rec_.condition_code,
                                   valuation_method_db_);

      Make_Revalue_Transactions___(contract_,
                                   part_no_,
                                   configuration_id_,
                                   lot_batch_no_temp_,
                                   serial_no_temp_,
                                   old_cost_detail_tab_,
                                   new_cost_detail_tab_,
                                   'INVREVTR+',
                                   'INVREVTR-',
                                   NVL(company_owned_rec_.sum_qty_in_transit,0),
                                   company_owned_rec_.location_group,
                                   company_owned_rec_.activity_seq,
                                   company_owned_rec_.condition_code,
                                   valuation_method_db_);
   END LOOP;

   FOR vendor_consignment_rec_ IN get_vendor_consignment_stock (contract_,
                                                                part_no_,
                                                                configuration_id_,
                                                                lot_batch_no_temp_,
                                                                serial_no_temp_) LOOP
      Make_Revalue_Transactions___(contract_,
                                   part_no_,
                                   configuration_id_,
                                   lot_batch_no_temp_,
                                   serial_no_temp_,
                                   old_cost_detail_tab_,
                                   new_cost_detail_tab_,
                                   'CO-INVREV+',
                                   'CO-INVREV-',
                                   NVL(vendor_consignment_rec_.sum_qty_onhand,0),
                                   vendor_consignment_rec_.location_group,
                                   vendor_consignment_rec_.activity_seq,
                                   vendor_consignment_rec_.condition_code,
                                   valuation_method_db_);
   END LOOP;

   FOR order_transit_rec_ IN get_quantity_in_order_transit (contract_,
                                                            part_no_,
                                                            configuration_id_,
                                                            lot_batch_no_temp_,
                                                            serial_no_temp_) LOOP
      Make_Revalue_Transactions___(contract_,
                                   part_no_,
                                   configuration_id_,
                                   lot_batch_no_temp_,
                                   serial_no_temp_,
                                   old_cost_detail_tab_,
                                   new_cost_detail_tab_,
                                   'INVREVTR+',
                                   'INVREVTR-',
                                   NVL(order_transit_rec_.sum_qty_in_transit,0),
                                   'INT ORDER TRANSIT',
                                   0,
                                   order_transit_rec_.condition_code,
                                   valuation_method_db_);
   END LOOP;

   FOR part_at_customer_rec_ IN get_quantity_at_customer (contract_,
                                                          part_no_,
                                                          configuration_id_,
                                                          lot_batch_no_temp_,
                                                          serial_no_temp_) LOOP
      IF (part_at_customer_rec_.process_type = Stock_At_Cust_Process_Type_API.DB_DELIVERY_CONFIRMATION) THEN
         location_group_ := 'DELIVERY CONFIRM';
      END IF;
      IF (part_at_customer_rec_.process_type = Stock_At_Cust_Process_Type_API.DB_CUSTOMER_CONSIGNMENT) THEN
         location_group_ := 'CONSIGNMENT'; 
      END IF;
      IF (part_at_customer_rec_.process_type = Stock_At_Cust_Process_Type_API.DB_PART_EXCHANGE) THEN
         location_group_ := 'PART EXCHANGE';
      END IF;

      Make_Revalue_Transactions___(contract_,
                                   part_no_,
                                   configuration_id_,
                                   lot_batch_no_temp_,
                                   serial_no_temp_,
                                   old_cost_detail_tab_,
                                   new_cost_detail_tab_,
                                   'INVREVAL+',
                                   'INVREVAL-',
                                   NVL(part_at_customer_rec_.sum_qty_at_customer, 0),
                                   location_group_,
                                   part_at_customer_rec_.activity_seq,
                                   part_at_customer_rec_.condition_code,
                                   valuation_method_db_);
   END LOOP;
END Revalue_Inventory___;


-- Make_Revalue_Transaction___
--   This method creates the transactions and postings when revaluating
--   quantities in stock.
PROCEDURE Make_Revalue_Transaction___ (
   transaction_id_     OUT NUMBER,
   contract_           IN  VARCHAR2,
   part_no_            IN  VARCHAR2,
   configuration_id_   IN  VARCHAR2,
   lot_batch_no_       IN  VARCHAR2,
   serial_no_          IN  VARCHAR2,
   cost_diff_tab_      IN  Cost_Detail_Tab,
   positive_cost_diff_ IN  BOOLEAN,
   transaction_pos_    IN  VARCHAR2,
   transaction_neg_    IN  VARCHAR2,
   quantity_           IN  NUMBER,
   location_group_     IN  VARCHAR2,
   activity_seq_       IN  NUMBER,
   condition_code_     IN  VARCHAR2 )
IS
   dummy_number_      NUMBER := 0;
   transaction_code_  VARCHAR2(20);
   part_ownership_db_ VARCHAR2(20);
BEGIN

   IF (quantity_ < 0) THEN
      -- NEGATIVE Quantity Onhand
      IF (positive_cost_diff_) THEN
         transaction_code_ := transaction_neg_;
      ELSE
         transaction_code_ := transaction_pos_;
      END IF;
   ELSE
      -- POSITIVE Quantity Onhand
      IF (positive_cost_diff_) THEN
         transaction_code_ := transaction_pos_;
      ELSE
         transaction_code_ := transaction_neg_;
      END IF;
   END IF;

   IF (Mpccom_Transaction_Code_API.Is_Vendor_Consignment(transaction_code_)) THEN
      part_ownership_db_ := Part_Ownership_API.DB_CONSIGNMENT;
   ELSE
      part_ownership_db_ := Part_Ownership_API.DB_COMPANY_OWNED;
   END IF;

   Inventory_Transaction_Hist_API.Create_And_Account(transaction_id_     =>  transaction_id_,
                                                     accounting_id_      =>  dummy_number_,
                                                     value_              =>  dummy_number_,
                                                     transaction_code_   =>  transaction_code_,
                                                     contract_           =>  contract_,
                                                     part_no_            =>  part_no_,
                                                     configuration_id_   =>  configuration_id_,
                                                     location_no_        =>  NULL,
                                                     lot_batch_no_       =>  lot_batch_no_,
                                                     serial_no_          =>  serial_no_,
                                                     waiv_dev_rej_no_    =>  NULL,
                                                     eng_chg_level_      =>  NULL,
                                                     activity_seq_       =>  activity_seq_,
                                                     project_id_         =>  NULL,
                                                     source_ref1_        =>  NULL,
                                                     source_ref2_        =>  NULL,
                                                     source_ref3_        =>  NULL,
                                                     source_ref4_        =>  NULL,
                                                     source_ref5_        =>  NULL,
                                                     reject_code_        =>  NULL,
                                                     cost_detail_tab_    =>  cost_diff_tab_,
                                                     unit_cost_          =>  NULL,
                                                     quantity_           =>  ABS(quantity_),
                                                     qty_reversed_       =>  0,
                                                     catch_quantity_     =>  NULL,
                                                     source_             =>  NULL,
                                                     source_ref_type_    =>  NULL,
                                                     owning_vendor_no_   =>  NULL,
                                                     condition_code_     =>  condition_code_,
                                                     location_group_     =>  location_group_,
                                                     part_ownership_db_  =>  part_ownership_db_,
                                                     owning_customer_no_ =>  NULL,
                                                     expiration_date_    =>  NULL);
END Make_Revalue_Transaction___;


-- Modify_Condition_Avg_Cost___
--   An implementation method used by public method Modify_Average_Cost to
--   calculate a new weighted average purchase cost when the part cost level
--   is Cost per Condition.
PROCEDURE Modify_Condition_Avg_Cost___ (
   pre_trans_level_qty_in_stock_     OUT NUMBER,
   pre_trans_level_qty_in_transi_    OUT NUMBER,
   pre_trans_avg_cost_detail_tab_    OUT Cost_Detail_Tab,
   trans_cost_detail_tab_         IN OUT Cost_Detail_Tab,
   trans_unit_cost_               IN     NUMBER,
   trans_quantity_                IN     NUMBER,
   contract_                      IN     VARCHAR2,
   part_no_                       IN     VARCHAR2,
   configuration_id_              IN     VARCHAR2,
   lot_batch_no_                  IN     VARCHAR2,
   serial_no_                     IN     VARCHAR2,
   condition_code_                IN     VARCHAR2,
   inventory_part_rec_            IN     Inventory_Part_API.Public_Rec,
   source_ref1_                   IN     VARCHAR2,
   source_ref2_                   IN     VARCHAR2,
   source_ref3_                   IN     VARCHAR2,
   source_ref4_                   IN     NUMBER,
   source_ref_type_db_            IN     VARCHAR2,
   company_                       IN     VARCHAR2 )
IS
   qty_onhand_                  NUMBER;
   qty_in_transit_              NUMBER;
   tot_qty_onhand_              NUMBER := 0;
   tot_qty_in_transit_          NUMBER := 0;
   tot_company_owned_stock_     NUMBER;
   current_condition_code_      VARCHAR2(50);
   old_cost_detail_tab_         Cost_Detail_Tab;
   new_cost_detail_tab_         Cost_Detail_Tab;
   char_null_                   VARCHAR2(12) := 'VARCHAR2NULL';
   old_cost_detail_tab_fetched_ BOOLEAN := FALSE;
   index_                       PLS_INTEGER := 1;

   CURSOR get_lot_serial IS
   SELECT DISTINCT lot_batch_no, serial_no
      FROM INVENTORY_PART_UNIT_COST_TAB
      WHERE part_no          = part_no_
        AND contract         = contract_
        AND configuration_id = configuration_id_;

   TYPE Lot_Serial_Tab IS TABLE OF get_lot_serial%ROWTYPE
     INDEX BY PLS_INTEGER;

   lot_serial_tab_ Lot_Serial_Tab;
BEGIN

   IF (condition_code_ IS NULL) THEN
      IF (serial_no_ != '*') THEN
         Error_SYS.Record_General(lu_name_, 'CCWANULLSER: A condition code must be specified for part no :P1 serial no :P2 in Part Serial Catalog', part_no_, serial_no_);
      ELSE
         Error_SYS.Record_General(lu_name_, 'CCWANULLLOT: A condition code must be specified for part no :P1 lot batch no :P2 in Lot Batch Master', part_no_, lot_batch_no_);
      END IF;
   END IF;

   FOR lot_serial_rec_ IN get_lot_serial LOOP
      current_condition_code_ := Condition_Code_Manager_API.Get_Condition_Code(
                                                                     part_no_,
                                                                     lot_serial_rec_.serial_no,
                                                                     lot_serial_rec_.lot_batch_no);

      IF (NVL(condition_code_, char_null_) = NVL(current_condition_code_, char_null_)) THEN

         lot_serial_tab_(index_) := lot_serial_rec_;
         index_                  := index_ + 1;

         -- EBALL-37, Modified the call to use Invent_Part_Quantity_Util_API.Get_Company_Owned_Inventory(). 
         Invent_Part_Quantity_Util_API.Get_Company_Owned_Inventory(qty_onhand_,
                                                                   qty_in_transit_,
                                                                   contract_,
                                                                   part_no_,
                                                                   configuration_id_,
                                                                   lot_serial_rec_.lot_batch_no,
                                                                   lot_serial_rec_.serial_no);

         tot_qty_onhand_     := tot_qty_onhand_     + qty_onhand_;
         tot_qty_in_transit_ := tot_qty_in_transit_ + qty_in_transit_;

         IF NOT (old_cost_detail_tab_fetched_) THEN
            old_cost_detail_tab_ := Get_Cost_Details_And_Lock___(contract_,
                                                                 part_no_,
                                                                 configuration_id_,
                                                                 lot_serial_rec_.lot_batch_no,
                                                                 lot_serial_rec_.serial_no);
            old_cost_detail_tab_fetched_ := TRUE;
         END IF;
      END IF;
   END LOOP;

   pre_trans_level_qty_in_stock_  := tot_qty_onhand_;
   pre_trans_level_qty_in_transi_ := tot_qty_in_transit_;
   pre_trans_avg_cost_detail_tab_ := old_cost_detail_tab_;
   tot_company_owned_stock_       := tot_qty_onhand_ + tot_qty_in_transit_;

   trans_cost_detail_tab_ := Generate_Cost_Details___(trans_cost_detail_tab_,
                                                      trans_unit_cost_,
                                                      TRUE,
                                                      company_,
                                                      contract_,
                                                      part_no_,
                                                      configuration_id_,
                                                      source_ref1_,
                                                      source_ref2_,
                                                      source_ref3_,
                                                      source_ref4_,
                                                      source_ref_type_db_,
                                                      NULL,
                                                      inventory_part_rec_,
                                                      trans_quantity_,
                                                      NULL);

   IF (tot_company_owned_stock_ + trans_quantity_ != 0) THEN
      -- We only recalculate the weighted average inventory value if the total
      -- quantity in stock is unequal to zero after the transaction. Otherwise
      -- it is not meaningful to do this, the result would be an inventory value
      -- equal to zero, which will only lead to problems when validating
      -- against the Zero Cost Forbidden flag in unpack_check_update___.

      new_cost_detail_tab_ := Get_Weighted_Avg_Cost_Details(old_cost_detail_tab_,
                                                            trans_cost_detail_tab_,
                                                            tot_company_owned_stock_,
                                                            trans_quantity_);

      IF (lot_serial_tab_.COUNT > 0) THEN
         FOR i IN lot_serial_tab_.FIRST..lot_serial_tab_.LAST LOOP

            Modify_Cost_Details___(new_cost_detail_tab_,
                                   old_cost_detail_tab_,
                                   contract_,
                                   part_no_,
                                   configuration_id_,
                                   lot_serial_tab_(i).lot_batch_no,
                                   lot_serial_tab_(i).serial_no,
                                   inventory_part_rec_.zero_cost_flag,
                                   inventory_part_rec_.inventory_part_cost_level,
                                   inventory_part_rec_.inventory_valuation_method);
         END LOOP;
      END IF;
   END IF;

   old_cost_detail_tab_ := Get_Cost_Detail_Tab___(contract_,
                                                  part_no_,
                                                  configuration_id_,
                                                  lot_batch_no_,
                                                  serial_no_);
   IF (old_cost_detail_tab_.COUNT = 0) THEN
      IF (new_cost_detail_tab_.COUNT = 0) THEN
         new_cost_detail_tab_ := trans_cost_detail_tab_;
      END IF;

      Modify_Cost_Details___(new_cost_detail_tab_,
                             old_cost_detail_tab_,
                             contract_,
                             part_no_,
                             configuration_id_,
                             lot_batch_no_,
                             serial_no_,
                             inventory_part_rec_.zero_cost_flag,
                             inventory_part_rec_.inventory_part_cost_level,
                             inventory_part_rec_.inventory_valuation_method);
   END IF;

END Modify_Condition_Avg_Cost___;


PROCEDURE Modify_Lot_Batch_Avg_Cost___ (
   pre_trans_level_qty_in_stock_     OUT NUMBER,
   pre_trans_level_qty_in_transi_    OUT NUMBER,
   pre_trans_avg_cost_detail_tab_    OUT Cost_Detail_Tab,
   trans_cost_detail_tab_         IN OUT Cost_Detail_Tab,
   trans_unit_cost_               IN     NUMBER,
   trans_quantity_                IN     NUMBER,
   contract_                      IN     VARCHAR2,
   part_no_                       IN     VARCHAR2,
   configuration_id_              IN     VARCHAR2,
   lot_batch_no_                  IN     VARCHAR2,
   serial_no_                     IN     VARCHAR2,
   inventory_part_rec_            IN     Inventory_Part_API.Public_Rec,
   source_ref1_                   IN     VARCHAR2,
   source_ref2_                   IN     VARCHAR2,
   source_ref3_                   IN     VARCHAR2,
   source_ref4_                   IN     NUMBER,
   source_ref_type_db_            IN     VARCHAR2,
   company_                       IN     VARCHAR2 )
IS
   qty_onhand_              NUMBER;
   qty_in_transit_          NUMBER;
   tot_company_owned_stock_ NUMBER;
   old_cost_detail_tab_     Cost_Detail_Tab;
   new_cost_detail_tab_     Cost_Detail_Tab;
   
   CURSOR get_serial_no IS
      SELECT DISTINCT serial_no
      FROM INVENTORY_PART_UNIT_COST_TAB
      WHERE part_no          = part_no_
        AND contract         = contract_
        AND configuration_id = configuration_id_
        AND lot_batch_no     = lot_batch_no_;

   TYPE Serial_No_Tab IS TABLE OF get_serial_no%ROWTYPE
     INDEX BY PLS_INTEGER;

   serial_no_tab_ Serial_No_Tab;
BEGIN
   Invent_Part_Quantity_Util_API.Get_Company_Owned_Inventory(qty_onhand_,
                                                             qty_in_transit_,
                                                             contract_,
                                                             part_no_,
                                                             configuration_id_,
                                                             lot_batch_no_);

   tot_company_owned_stock_ := qty_onhand_ + qty_in_transit_;

   trans_cost_detail_tab_ := Generate_Cost_Details___(trans_cost_detail_tab_,
                                                      trans_unit_cost_,
                                                      TRUE,
                                                      company_,
                                                      contract_,
                                                      part_no_,
                                                      configuration_id_,
                                                      source_ref1_,
                                                      source_ref2_,
                                                      source_ref3_,
                                                      source_ref4_,
                                                      source_ref_type_db_,
                                                      NULL,
                                                      inventory_part_rec_,
                                                      trans_quantity_,
                                                      NULL);

   old_cost_detail_tab_ := Get_Lot_Batch_Cost_Details(contract_,
                                                      part_no_,
                                                      configuration_id_,
                                                      lot_batch_no_,
                                                      TRUE);
   pre_trans_avg_cost_detail_tab_ := old_cost_detail_tab_;
   pre_trans_level_qty_in_stock_  := qty_onhand_;
   pre_trans_level_qty_in_transi_ := qty_in_transit_;

   IF (tot_company_owned_stock_ + trans_quantity_ != 0) THEN
      -- We only recalculate the weighted average inventory value if the total
      -- quantity in stock is unequal to zero after the transaction. Otherwise
      -- it is not meaningful to do this, the result would be an inventory value
      -- equal to zero, which will only lead to problems when validating
      -- against the Zero Cost Forbidden flag in unpack_check_update___.
      new_cost_detail_tab_ := Get_Weighted_Avg_Cost_Details(old_cost_detail_tab_,
                                                            trans_cost_detail_tab_,
                                                            tot_company_owned_stock_,
                                                            trans_quantity_);
      
      OPEN get_serial_no;
      FETCH get_serial_no BULK COLLECT INTO serial_no_tab_;
      CLOSE get_serial_no;

      IF (serial_no_tab_.COUNT > 0) THEN
         FOR i IN serial_no_tab_.FIRST..serial_no_tab_.LAST LOOP

            Modify_Cost_Details___(new_cost_detail_tab_,
                                   old_cost_detail_tab_,
                                   contract_,
                                   part_no_,
                                   configuration_id_,
                                   lot_batch_no_,
                                   serial_no_tab_(i).serial_no,
                                   inventory_part_rec_.zero_cost_flag,
                                   inventory_part_rec_.inventory_part_cost_level,
                                   inventory_part_rec_.inventory_valuation_method);
         END LOOP;
      END IF;
   END IF;

   old_cost_detail_tab_ := Get_Cost_Detail_Tab___(contract_,
                                                  part_no_,
                                                  configuration_id_,
                                                  lot_batch_no_,
                                                  serial_no_);
   IF (old_cost_detail_tab_.COUNT = 0) THEN
      IF (new_cost_detail_tab_.COUNT = 0) THEN
         new_cost_detail_tab_ := trans_cost_detail_tab_;
      END IF;

      Modify_Cost_Details___(new_cost_detail_tab_,
                             old_cost_detail_tab_,
                             contract_,
                             part_no_,
                             configuration_id_,
                             lot_batch_no_,
                             serial_no_,
                             inventory_part_rec_.zero_cost_flag,
                             inventory_part_rec_.inventory_part_cost_level,
                             inventory_part_rec_.inventory_valuation_method);
   END IF;
END Modify_Lot_Batch_Avg_Cost___;


-- Modify_Part_Avg_Cost___
--   An implementation method used by public method Modify_Average_Cost
--   to calculate a new weighted average purchase cost when the part cost
--   level is Cost per Part.
PROCEDURE Modify_Part_Avg_Cost___ (
   pre_trans_level_qty_in_stock_     OUT NUMBER,
   pre_trans_level_qty_in_transi_    OUT NUMBER,
   pre_trans_avg_cost_detail_tab_    OUT Cost_Detail_Tab,
   trans_cost_detail_tab_         IN OUT Cost_Detail_Tab,
   trans_unit_cost_               IN     NUMBER,
   trans_quantity_                IN     NUMBER,
   contract_                      IN     VARCHAR2,
   part_no_                       IN     VARCHAR2,
   configuration_id_              IN     VARCHAR2,
   inventory_part_rec_            IN     Inventory_Part_API.Public_Rec,
   source_ref1_                   IN     VARCHAR2,
   source_ref2_                   IN     VARCHAR2,
   source_ref3_                   IN     VARCHAR2,
   source_ref4_                   IN     NUMBER,
   source_ref_type_db_            IN     VARCHAR2,
   company_                       IN     VARCHAR2 )
IS
   qty_on_hand_             NUMBER := 0;
   qty_in_transit_          NUMBER := 0;
   tot_company_owned_stock_ NUMBER;
   old_cost_detail_tab_     Cost_Detail_Tab;
   new_cost_detail_tab_     Cost_Detail_Tab;
   
   CURSOR get_configurations (contract_ IN VARCHAR2,
                              part_no_  IN VARCHAR2) IS
      SELECT DISTINCT configuration_id
        FROM INVENTORY_PART_UNIT_COST_TAB
       WHERE contract = contract_
         AND part_no  = part_no_
         AND configuration_id != '*';
BEGIN

   Get_Tot_Company_Owned_Stock(qty_on_hand_,
                               qty_in_transit_,
                               contract_,
                               part_no_);

   tot_company_owned_stock_ := qty_on_hand_ + qty_in_transit_;
   old_cost_detail_tab_     := Get_Cost_Details_And_Lock___(contract_,
                                                            part_no_,
                                                            '*',
                                                            '*',
                                                            '*');
   trans_cost_detail_tab_ := Generate_Cost_Details___(trans_cost_detail_tab_,
                                                      trans_unit_cost_,
                                                      TRUE,
                                                      company_,
                                                      contract_,
                                                      part_no_,
                                                      configuration_id_,
                                                      source_ref1_,
                                                      source_ref2_,
                                                      source_ref3_,
                                                      source_ref4_,
                                                      source_ref_type_db_,
                                                      NULL,
                                                      inventory_part_rec_,
                                                      trans_quantity_,
                                                      NULL);

   IF (tot_company_owned_stock_ + trans_quantity_ != 0) THEN
      -- We only recalculate the weighted average inventory value if the total
      -- quantity in stock is unequal to zero after the transaction. Otherwise
      -- it is not meaningful to do this, the result would be an inventory value
      -- equal to zero, which will only lead to problems when validating
      -- against the Zero Cost Forbidden flag in unpack_check_update___.

      new_cost_detail_tab_ := Get_Weighted_Avg_Cost_Details(old_cost_detail_tab_,
                                                            trans_cost_detail_tab_,
                                                            tot_company_owned_stock_,
                                                            trans_quantity_);

      Modify_Cost_Details___(new_cost_detail_tab_,
                             old_cost_detail_tab_,
                             contract_,
                             part_no_,
                             '*',
                             '*',
                             '*',
                             inventory_part_rec_.zero_cost_flag,
                             inventory_part_rec_.inventory_part_cost_level,
                             inventory_part_rec_.inventory_valuation_method);
      -- Handle configured parts.
      FOR config_rec_ IN get_configurations(contract_, part_no_) LOOP
         old_cost_detail_tab_ := Get_Cost_Details_And_Lock___(contract_,
                                                              part_no_,
                                                              config_rec_.configuration_id,
                                                              '*',
                                                              '*');
         Modify_Cost_Details___(new_cost_detail_tab_,
                                old_cost_detail_tab_,
                                contract_,
                                part_no_,
                                config_rec_.configuration_id,
                                '*',
                                '*',
                                inventory_part_rec_.zero_cost_flag,
                                inventory_part_rec_.inventory_part_cost_level,
                                inventory_part_rec_.inventory_valuation_method);
      END LOOP;
   END IF;

   pre_trans_level_qty_in_stock_  := qty_on_hand_;
   pre_trans_level_qty_in_transi_ := qty_in_transit_;
   pre_trans_avg_cost_detail_tab_ := old_cost_detail_tab_;
END Modify_Part_Avg_Cost___;


-- Is_Executing___
--   This method is used by method Modify_Conditon_Cost__ to check if there
--   is already a background job executing Modify_Conditon_Cost__ for the
--   given parameters. We can not allow parallell execution of Modify_Condition_Cost__
--   for the same part number on a site.
FUNCTION Is_Executing___ (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   condition_code_   IN VARCHAR2 ) RETURN BOOLEAN
IS
   count_                  NUMBER;
   job_id_tab_             Message_Sys.name_table;
   attrib_tab_             Message_Sys.line_table;
   my_job_id_              NUMBER;
   local_contract_         INVENTORY_PART_UNIT_COST_TAB.contract%TYPE;
   local_part_no_          INVENTORY_PART_UNIT_COST_TAB.part_no%TYPE;
   local_configuration_id_ INVENTORY_PART_UNIT_COST_TAB.configuration_id%TYPE;
   local_condition_code_   VARCHAR2(50);
   msg_                    VARCHAR2 (32000);
   deferred_call_          CONSTANT VARCHAR2(200) := 'INVENTORY_PART_UNIT_COST_API'||'.MODIFY_CONDITION_COST__';
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
         -- Get the parameter values for the job under investigation.
         local_contract_         := Client_SYS.Get_Item_Value ('CONTRACT'        , attrib_tab_(count_));
         local_part_no_          := Client_SYS.Get_Item_Value ('PART_NO'         , attrib_tab_(count_));
         local_configuration_id_ := Client_SYS.Get_Item_Value ('CONFIGURATION_ID', attrib_tab_(count_));
         local_condition_code_   := Client_SYS.Get_Item_Value ('CONDITION_CODE'  , attrib_tab_(count_));

         -- When we find the first disqualifying case, stop processing and return TRUE.
         IF ((local_contract_         = contract_)         AND
             (local_part_no_          = part_no_)          AND
             (local_configuration_id_ = configuration_id_) AND
             (local_condition_code_   = condition_code_))  THEN
            -- matching parameter values
            RETURN TRUE;
         END IF;
      END IF;
      count_ := count_ - 1;
   END LOOP;
   RETURN FALSE;
END Is_Executing___;


-- Generate_Lot_Batch_Serial___
--   This method creates a record in InventoryPartUnitCost for each
--   configuration_id, lot_batch_no and serial_no combination that can
--   be found in LU InventoryPartInStock for a specific InventoryPart record.
PROCEDURE Generate_Lot_Batch_Serial___ (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 )
IS
   cost_detail_tab_ Cost_Detail_Tab;
   dummy_tab_       Cost_Detail_Tab;
   part_rec_        Inventory_Part_API.Public_Rec;

   CURSOR get_config_records (contract_ IN VARCHAR2,
                              part_no_  IN VARCHAR2) IS
      SELECT configuration_id
        FROM inventory_part_config_pub
       WHERE contract = contract_
         AND part_no  = part_no_;

   CURSOR get_lot_serial_records (contract_         IN VARCHAR2,
                                  part_no_          IN VARCHAR2,
                                  configuration_id_ IN VARCHAR2) IS
      SELECT DISTINCT lot_batch_no, serial_no
        FROM inventory_part_in_stock_pub
       WHERE  contract         = contract_
         AND  part_no          = part_no_
         AND  configuration_id = configuration_id_
         AND (serial_no        != '*' OR
              lot_batch_no     != '*')
         AND (qty_onhand       != 0 OR
              qty_in_transit   != 0);
BEGIN
   part_rec_ := Inventory_Part_API.Get(contract_, part_no_);

   FOR config_rec_ IN get_config_records (contract_, part_no_) LOOP
      cost_detail_tab_ := Get_Cost_Details_By_Method(contract_,
                                                     part_no_,
                                                     config_rec_.configuration_id,
                                                     '*',
                                                     '*');

      FOR lot_serial_rec_ IN get_lot_serial_records (contract_,
                                                     part_no_,
                                                     config_rec_.configuration_id) LOOP

         Modify_Cost_Details___(new_cost_detail_tab_ => cost_detail_tab_,
                                old_cost_detail_tab_ => dummy_tab_,
                                contract_            => contract_,
                                part_no_             => part_no_,
                                configuration_id_    => config_rec_.configuration_id,
                                lot_batch_no_        => lot_serial_rec_.lot_batch_no,
                                serial_no_           => lot_serial_rec_.serial_no,
                                zero_cost_flag_db_   => part_rec_.zero_cost_flag,
                                part_cost_level_db_  => part_rec_.inventory_part_cost_level,
                                valuation_method_db_ => part_rec_.inventory_valuation_method);
      END LOOP;
   END LOOP;
END Generate_Lot_Batch_Serial___;


-- Remove_Lot_Batch_Serial___
--   This method removes all records in InventoryPartUnitCost having either a
--   lot_batch_no or a serial no not equal to * for a specific InventoryPart record.
PROCEDURE Remove_Lot_Batch_Serial___ (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 )
IS

   CURSOR get_keys (contract_ IN VARCHAR2,
                    part_no_  IN VARCHAR2) IS
      SELECT DISTINCT configuration_id, lot_batch_no, serial_no
        FROM INVENTORY_PART_UNIT_COST_TAB
       WHERE  contract     = contract_
         AND  part_no      = part_no_
         AND (serial_no    != '*' OR
              lot_batch_no != '*');
BEGIN

   FOR key_rec_ IN get_keys(contract_, part_no_) LOOP

      Remove_All_Cost_Details___(contract_,
                                 part_no_,
                                 key_rec_.configuration_id,
                                 key_rec_.lot_batch_no,
                                 key_rec_.serial_no);
   END LOOP;
END Remove_Lot_Batch_Serial___;


-- Apply_Part_Level_Cost___
--   Sets inventory_value of all records having the same contract and
--   part_no to the same value.
PROCEDURE Apply_Part_Level_Cost___ (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 )
IS
   new_cost_detail_tab_ Cost_Detail_Tab;
   part_rec_            Inventory_Part_API.Public_Rec;

   CURSOR get_keys (contract_ IN VARCHAR2,
                    part_no_  IN VARCHAR2) IS
      SELECT DISTINCT configuration_id, lot_batch_no, serial_no
        FROM INVENTORY_PART_UNIT_COST_TAB
       WHERE contract          = contract_
         AND part_no           = part_no_
         AND configuration_id != '*';
BEGIN
   part_rec_        := Inventory_Part_API.Get(contract_,
                                              part_no_);

   new_cost_detail_tab_ := Get_Cost_Details_By_Method(contract_,
                                                      part_no_,
                                                      '*',
                                                      '*',
                                                      '*') ;

   FOR key_rec_ IN get_keys(contract_, part_no_) LOOP

      Modify_Details_And_Revalue___(contract_,
                                    part_no_,
                                    key_rec_.configuration_id,
                                    key_rec_.lot_batch_no,
                                    key_rec_.serial_no,
                                    part_rec_.inventory_part_cost_level,
                                    part_rec_.inventory_valuation_method,
                                    part_rec_.invoice_consideration,
                                    part_rec_.zero_cost_flag,
                                    new_cost_detail_tab_);
   END LOOP;
END Apply_Part_Level_Cost___;


-- Apply_Condition_Level_Cost___
--   Sets inventory_value of all records having the same contract,
--   part_no, configuration_id and condition_code to the same value.
PROCEDURE Apply_Condition_Level_Cost___ (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 )
IS
   condition_code_found_   BOOLEAN;
   part_rec_               Inventory_Part_API.Public_Rec;
   char_null_              VARCHAR2(12) := 'VARCHAR2NULL';
   current_condition_code_ VARCHAR2(50);
   rows_                   PLS_INTEGER;
   new_cost_detail_tab_    Cost_Detail_Tab;

   TYPE Condition_Cost_Rec_Type IS RECORD
      (configuration_id_ INVENTORY_PART_UNIT_COST_TAB.configuration_id%TYPE,
       condition_code_   VARCHAR2(50),
       cost_detail_tab_  Cost_Detail_Tab);

   TYPE Condition_Cost_Tab_Type IS TABLE OF Condition_Cost_Rec_Type
     INDEX BY PLS_INTEGER;
   condition_cost_tab_   Condition_Cost_Tab_Type;

   CURSOR get_keys (contract_ IN VARCHAR2,
                    part_no_  IN VARCHAR2) IS
      SELECT DISTINCT configuration_id, lot_batch_no, serial_no
        FROM INVENTORY_PART_UNIT_COST_TAB
       WHERE  contract     = contract_
         AND  part_no      = part_no_
         AND (serial_no    != '*' OR
              lot_batch_no != '*');
BEGIN

   part_rec_ := Inventory_Part_API.Get(contract_, part_no_);
   rows_     := 0;

   FOR key_rec_ IN get_keys(contract_, part_no_) LOOP

      current_condition_code_ := Condition_Code_Manager_API.Get_Condition_Code(
                                                                            part_no_,
                                                                            key_rec_.serial_no,
                                                                            key_rec_.lot_batch_no);
      condition_code_found_ := FALSE;
      FOR i IN 1..rows_ LOOP
         IF ((NVL(current_condition_code_, char_null_) =
             NVL(condition_cost_tab_(i).condition_code_, char_null_)) AND
            (key_rec_.configuration_id = condition_cost_tab_(i).configuration_id_)) THEN
            condition_code_found_ := TRUE;
            new_cost_detail_tab_  := condition_cost_tab_(i).cost_detail_tab_;
         END IF;
      END LOOP;

      IF (condition_code_found_) THEN

         Modify_Details_And_Revalue___(contract_,
                                       part_no_,
                                       key_rec_.configuration_id,
                                       key_rec_.lot_batch_no,
                                       key_rec_.serial_no,
                                       part_rec_.inventory_part_cost_level,
                                       part_rec_.inventory_valuation_method,
                                       part_rec_.invoice_consideration,
                                       part_rec_.zero_cost_flag,
                                       new_cost_detail_tab_);
      ELSE
         rows_ := rows_ + 1;
         condition_cost_tab_(rows_).configuration_id_ := key_rec_.configuration_id;
         condition_cost_tab_(rows_).condition_code_   := current_condition_code_;
         condition_cost_tab_(rows_).cost_detail_tab_  := Get_Cost_Detail_Tab___(
                                                                          contract_,
                                                                          part_no_,
                                                                          key_rec_.configuration_id,
                                                                          key_rec_.lot_batch_no,
                                                                          key_rec_.serial_no);
      END IF;
   END LOOP;
END Apply_Condition_Level_Cost___;


-- Apply_Lot_Batch_Level_Cost___
--   Sets inventory_value of all records having the same contract,
--   part_no, configuration_id and lot_batch_no to the same value.
PROCEDURE Apply_Lot_Batch_Level_Cost___ (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 )
IS
   lot_batch_config_found_ BOOLEAN;
   part_rec_               Inventory_Part_API.Public_Rec;
   rows_                   PLS_INTEGER;
   new_cost_detail_tab_    Cost_Detail_Tab;

   TYPE Lot_Batch_Cost_Rec_Type IS RECORD
      (configuration_id_ INVENTORY_PART_UNIT_COST_TAB.configuration_id%TYPE,
       lot_batch_no_     INVENTORY_PART_UNIT_COST_TAB.lot_batch_no%TYPE,
       cost_detail_tab_  Cost_Detail_Tab);

   TYPE Lot_Batch_Cost_Tab_Type IS TABLE OF Lot_Batch_Cost_Rec_Type
     INDEX BY PLS_INTEGER;
   lot_batch_cost_tab_   Lot_Batch_Cost_Tab_Type;

   CURSOR get_keys (contract_ IN VARCHAR2,
                    part_no_  IN VARCHAR2) IS
      SELECT DISTINCT configuration_id, lot_batch_no, serial_no
        FROM INVENTORY_PART_UNIT_COST_TAB
       WHERE  contract     = contract_
         AND  part_no      = part_no_;
BEGIN

   part_rec_ := Inventory_Part_API.Get(contract_, part_no_);
   rows_     := 0;

   FOR key_rec_ IN get_keys(contract_, part_no_) LOOP
      lot_batch_config_found_ := FALSE;
      FOR i IN 1..rows_ LOOP
         IF ((key_rec_.configuration_id = lot_batch_cost_tab_(i).configuration_id_)  AND
             (key_rec_.lot_batch_no     = lot_batch_cost_tab_(i).lot_batch_no_    )) THEN
            lot_batch_config_found_ := TRUE;
            new_cost_detail_tab_    := lot_batch_cost_tab_(i).cost_detail_tab_;
         END IF;
      END LOOP;

      IF (lot_batch_config_found_) THEN
         Modify_Details_And_Revalue___(contract_,
                                       part_no_,
                                       key_rec_.configuration_id,
                                       key_rec_.lot_batch_no,
                                       key_rec_.serial_no,
                                       part_rec_.inventory_part_cost_level,
                                       part_rec_.inventory_valuation_method,
                                       part_rec_.invoice_consideration,
                                       part_rec_.zero_cost_flag,
                                       new_cost_detail_tab_);
      ELSE
         rows_ := rows_ + 1;
         lot_batch_cost_tab_(rows_).configuration_id_ := key_rec_.configuration_id;
         lot_batch_cost_tab_(rows_).lot_batch_no_     := key_rec_.lot_batch_no;
         lot_batch_cost_tab_(rows_).cost_detail_tab_  := Get_Cost_Detail_Tab___(
                                                                          contract_,
                                                                          part_no_,
                                                                          key_rec_.configuration_id,
                                                                          key_rec_.lot_batch_no,
                                                                          key_rec_.serial_no);
      END IF;
   END LOOP;
END Apply_Lot_Batch_Level_Cost___;


-- Modify_Config_Avg_Cost___
--   An implementation method used by public method Modify_Average_Cost to
--   calculate a new weighted average purchase cost when the part cost level
--   is Cost per Configuration.
PROCEDURE Modify_Config_Avg_Cost___ (
   pre_trans_level_qty_in_stock_     OUT NUMBER,
   pre_trans_level_qty_in_transi_    OUT NUMBER,
   pre_trans_avg_cost_detail_tab_    OUT Cost_Detail_Tab,
   trans_cost_detail_tab_         IN OUT Cost_Detail_Tab,
   trans_unit_cost_               IN     NUMBER,
   trans_quantity_                IN     NUMBER,
   contract_                      IN     VARCHAR2,
   part_no_                       IN     VARCHAR2,
   configuration_id_              IN     VARCHAR2,
   inventory_part_rec_            IN     Inventory_Part_API.Public_Rec,
   source_ref1_                   IN     VARCHAR2,
   source_ref2_                   IN     VARCHAR2,
   source_ref3_                   IN     VARCHAR2,
   source_ref4_                   IN     NUMBER,
   source_ref_type_db_            IN     VARCHAR2,
   company_                       IN     VARCHAR2 )
IS
   qty_on_hand_             NUMBER := 0;
   qty_in_transit_          NUMBER := 0;
   tot_company_owned_stock_ NUMBER;
   old_cost_detail_tab_     Cost_Detail_Tab;
   new_cost_detail_tab_     Cost_Detail_Tab;
BEGIN

   old_cost_detail_tab_ := Get_Cost_Details_And_Lock___(contract_,
                                                        part_no_,
                                                        configuration_id_,
                                                        '*',
                                                        '*');

   Invent_Part_Quantity_Util_API.Get_Company_Owned_Inventory(qty_on_hand_,
                                                             qty_in_transit_,
                                                             contract_,
                                                             part_no_,
                                                             configuration_id_);

   tot_company_owned_stock_ := NVL((qty_on_hand_ + qty_in_transit_),0);

   trans_cost_detail_tab_ := Generate_Cost_Details___(trans_cost_detail_tab_,
                                                      trans_unit_cost_,
                                                      TRUE,
                                                      company_,
                                                      contract_,
                                                      part_no_,
                                                      configuration_id_,
                                                      source_ref1_,
                                                      source_ref2_,
                                                      source_ref3_,
                                                      source_ref4_,
                                                      source_ref_type_db_,
                                                      NULL,
                                                      inventory_part_rec_,
                                                      trans_quantity_,
                                                      NULL);

   IF (tot_company_owned_stock_ + trans_quantity_ != 0) THEN
      -- We only recalculate the weighted average inventory value if the total
      -- quantity in stock is unequal to zero after the transaction. Otherwise
      -- it is not meaningful to do this, the result would be an inventory value
      -- equal to zero, which will only lead to problems when validating
      -- against the Zero Cost Forbidden flag in unpack_check_update___.
      new_cost_detail_tab_ := Get_Weighted_Avg_Cost_Details(old_cost_detail_tab_,
                                                            trans_cost_detail_tab_,
                                                            tot_company_owned_stock_,
                                                            trans_quantity_);
      Modify_Cost_Details___(new_cost_detail_tab_,
                             old_cost_detail_tab_,
                             contract_,
                             part_no_,
                             configuration_id_,
                             '*',
                             '*',
                             inventory_part_rec_.zero_cost_flag,
                             inventory_part_rec_.inventory_part_cost_level,
                             inventory_part_rec_.inventory_valuation_method);
   END IF;

   pre_trans_level_qty_in_stock_  := NVL(qty_on_hand_,0);
   pre_trans_level_qty_in_transi_ := NVL(qty_in_transit_,0);
   pre_trans_avg_cost_detail_tab_ := old_cost_detail_tab_;
END Modify_Config_Avg_Cost___;


FUNCTION Get_Part_Level_Cost___ (
   contract_                   IN VARCHAR2,
   part_no_                    IN VARCHAR2,
   configuration_id_           IN VARCHAR2,
   inventory_valuation_method_ IN VARCHAR2 ) RETURN Cost_Detail_Tab
IS
   cost_detail_tab_ Cost_Detail_Tab;
BEGIN
   IF (inventory_valuation_method_ IN ('FIFO','LIFO')) THEN
      cost_detail_tab_ := Inventory_Part_Cost_Fifo_API.Get_Average_Cost_Details(contract_,
                                                                                part_no_);
   ELSE
      -----------------------------------------------------
      --  Inventory valuation method is STANDARD COST    --
      --  or WEIGTHED AVERAGE PURCHASE PRICE.            --
      -----------------------------------------------------
      IF (configuration_id_ IS NULL) THEN
         cost_detail_tab_ := Get_Cost_Detail_Tab___(contract_,
                                                    part_no_,
                                                    '*',
                                                    '*',
                                                    '*');
      ELSE
         cost_detail_tab_ := Get_Cost_Detail_Tab___(contract_,
                                                    part_no_,
                                                    configuration_id_,
                                                    '*',
                                                    '*');
      END IF;
   END IF;
   RETURN (cost_detail_tab_);
END Get_Part_Level_Cost___;


FUNCTION Get_Config_Level_Cost___ (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2 ) RETURN Cost_Detail_Tab
IS
   qty_on_hand_      NUMBER := 0;
   qty_in_transit_   NUMBER := 0;
   total_qty_        NUMBER := 0;
   grand_total_qty_  NUMBER := 0;
   cost_detail_tab_  Cost_Detail_Tab;
   value_detail_tab_ Cost_Detail_Tab;

   CURSOR get_configurations IS
   SELECT DISTINCT configuration_id
      FROM INVENTORY_PART_UNIT_COST_TAB
      WHERE part_no  = part_no_
        AND contract = contract_;
BEGIN
   IF (configuration_id_ IS NULL) THEN
      grand_total_qty_   := 0;
      FOR config_rec_ IN get_configurations LOOP
         Invent_Part_Quantity_Util_API.Get_Company_Owned_Inventory(qty_on_hand_,
                                                                   qty_in_transit_,
                                                                   contract_,
                                                                   part_no_,
                                                                   config_rec_.configuration_id);
         total_qty_       := qty_on_hand_ + qty_in_transit_;
         grand_total_qty_ := grand_total_qty_ + total_qty_;

         cost_detail_tab_ := Get_Cost_Detail_Tab___(contract_,
                                                    part_no_,
                                                    configuration_id_,
                                                    '*',
                                                    '*');

         value_detail_tab_ := Add_To_Value_Detail_Tab(value_detail_tab_,
                                                      cost_detail_tab_,
                                                      total_qty_);
      END LOOP;
      IF (grand_total_qty_ > 0) THEN
         cost_detail_tab_ := Value_To_Cost_Details(value_detail_tab_,
                                                   grand_total_qty_);
      ELSE
         cost_detail_tab_ := Get_Cost_Detail_Tab___(contract_,
                                                    part_no_,
                                                    '*',
                                                    '*',
                                                    '*');
      END IF;
   ELSE
      cost_detail_tab_ := Get_Cost_Detail_Tab___(contract_,
                                                 part_no_,
                                                 configuration_id_,
                                                 '*',
                                                 '*');
   END IF;

   RETURN (cost_detail_tab_);
END Get_Config_Level_Cost___;


FUNCTION Get_Cond_Lot_Ser_Level_Cost___ (
   contract_           IN VARCHAR2,
   part_no_            IN VARCHAR2,
   configuration_id_   IN VARCHAR2,
   lot_batch_no_       IN VARCHAR2,
   serial_no_          IN VARCHAR2,
   part_cost_level_db_ IN VARCHAR2 ) RETURN Cost_Detail_Tab
IS
   grand_total_qty_   NUMBER := 0;
   unit_cost_         NUMBER;
   condition_code_    VARCHAR2(50);
   cost_detail_tab_   Cost_Detail_Tab;

BEGIN
   IF ((lot_batch_no_     IS NULL)  OR
       (serial_no_        IS NULL)  OR
       (configuration_id_ IS NULL)) THEN
      
      grand_total_qty_ := 0;
      cost_detail_tab_ := Get_Wa_Config_Cost_Details___(contract_,
                                                        part_no_,
                                                        configuration_id_);
      IF (cost_detail_tab_.COUNT = 0) THEN
         cost_detail_tab_ := Get_Cost_Detail_Tab___(contract_,
                                                    part_no_,
                                                    NVL(configuration_id_, '*'),
                                                    '*',
                                                    '*');
         IF (cost_detail_tab_.COUNT = 0) THEN
            unit_cost_ := Inventory_Part_Config_API.Get_Estimated_Material_Cost(contract_,
                                                                                part_no_,
                                                                                NVL(configuration_id_, '*'));
            cost_detail_tab_(1).accounting_year := '*';
            cost_detail_tab_(1).contract        := contract_;
            cost_detail_tab_(1).cost_bucket_id  := '*';
            cost_detail_tab_(1).company         := Site_API.Get_Company(contract_);
            cost_detail_tab_(1).cost_source_id  := '*';
            cost_detail_tab_(1).unit_cost       := unit_cost_;
         END IF;
      END IF;
   ELSE
      cost_detail_tab_ := Get_Cost_Detail_Tab___(contract_,
                                                 part_no_,
                                                 configuration_id_,
                                                 lot_batch_no_,
                                                 serial_no_);
      IF (cost_detail_tab_.COUNT = 0) THEN
         IF (part_cost_level_db_ = 'COST PER CONDITION') THEN
            condition_code_ := Condition_Code_Manager_API.Get_Condition_Code(part_no_,
                                                                             serial_no_,
                                                                             lot_batch_no_);
            IF (condition_code_ IS NULL) THEN
               cost_detail_tab_ := Get_Cond_Lot_Ser_Level_Cost___(contract_,
                                                                  part_no_,
                                                                  configuration_id_,
                                                                  NULL,
                                                                  NULL,
                                                                  part_cost_level_db_);
            ELSE
               cost_detail_tab_ := Get_Cost_Details_By_Condition(contract_,
                                                                 part_no_,
                                                                 configuration_id_,
                                                                 condition_code_);
            END IF;
         ELSE
            cost_detail_tab_ := Get_Cond_Lot_Ser_Level_Cost___(contract_,
                                                               part_no_,
                                                               configuration_id_,
                                                               NULL,
                                                               NULL,
                                                               part_cost_level_db_);
         END IF;
      END IF;
   END IF;
   RETURN (cost_detail_tab_);
END Get_Cond_Lot_Ser_Level_Cost___;


-- Modify_Serial_Cost___
--   method can be used to modify the unit cost of a specific individual
--   (serial) of a part on a site. It can only be used when the part cost
--   level is Cost per Serial.
PROCEDURE Modify_Serial_Cost___ (
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   inventory_part_rec_  IN Inventory_Part_API.Public_Rec,
   configuration_id_    IN VARCHAR2,
   lot_batch_no_        IN VARCHAR2,
   serial_no_           IN VARCHAR2,
   new_cost_detail_tab_ IN Cost_Detail_Tab,
   revalue_inventory_   IN BOOLEAN )
IS
   old_cost_detail_tab_       Cost_Detail_Tab;
   local_new_cost_detail_tab_ Cost_Detail_Tab;
   local_revalue_inventory_   BOOLEAN := FALSE;
BEGIN
   Inventory_Part_Config_API.Exist(contract_, part_no_, configuration_id_);

   IF (inventory_part_rec_.inventory_part_cost_level != 'COST PER SERIAL') THEN
      Raise_Cost_Level_Error___(Inventory_Part_Cost_Level_API.DB_COST_PER_SERIAL);
   END IF;

   IF (inventory_part_rec_.inventory_valuation_method = 'ST') THEN
      IF (inventory_part_rec_.invoice_consideration IN ('IGNORE INVOICE PRICE', 'TRANSACTION BASED')) THEN 
         IF (revalue_inventory_) THEN 
            local_revalue_inventory_ := TRUE; 
         END IF;
      ELSE
         Error_SYS.Record_General(lu_name_,'SICERROR: This operation is only allowed when Supplier Invoice Consideration is set to :P1 or :P2.', Invoice_Consideration_API.Decode('IGNORE INVOICE PRICE'), Invoice_Consideration_API.Decode('TRANSACTION BASED'));
      END IF;
   ELSIF (inventory_part_rec_.inventory_valuation_method = 'AV') THEN
         local_revalue_inventory_ := TRUE;
   ELSE
      Raise_Value_Method_Error___;
   END IF;

   local_new_cost_detail_tab_ := Merge_And_Complete_Details(new_cost_detail_tab_,
                                                            inventory_part_rec_,
                                                            contract_,
                                                            part_no_,
                                                            Site_API.Get_Company(contract_),
                                                            '*',
                                                            NULL,
                                                            NULL,
                                                            NULL,
                                                            NULL,
                                                            NULL);

   old_cost_detail_tab_ := Get_Cost_Details_And_Lock___(contract_,
                                                        part_no_,
                                                        configuration_id_,
                                                        lot_batch_no_,
                                                        serial_no_);

   IF (local_revalue_inventory_) THEN
      Revalue_Inventory___(contract_,
                           part_no_,
                           configuration_id_,
                           lot_batch_no_,
                           serial_no_,
                           inventory_part_rec_.inventory_part_cost_level,
                           inventory_part_rec_.inventory_valuation_method,
                           old_cost_detail_tab_,
                           local_new_cost_detail_tab_);
   END IF;

   Modify_Cost_Details___(local_new_cost_detail_tab_,
                          old_cost_detail_tab_,
                          contract_,
                          part_no_,
                          configuration_id_,
                          lot_batch_no_,
                          serial_no_,
                          inventory_part_rec_.zero_cost_flag,
                          inventory_part_rec_.inventory_part_cost_level,
                          inventory_part_rec_.inventory_valuation_method);
END Modify_Serial_Cost___;


FUNCTION Get_Cost_Detail_Tab___ (
   contract_          IN VARCHAR2,
   part_no_           IN VARCHAR2,
   configuration_id_  IN VARCHAR2,
   lot_batch_no_      IN VARCHAR2,
   serial_no_         IN VARCHAR2 ) RETURN Cost_Detail_Tab
IS
   cost_detail_tab_ Cost_Detail_Tab;

   CURSOR get_cost_detail IS
      SELECT accounting_year,
             contract,
             cost_bucket_id,
             company,
             cost_source_id,
             inventory_value
      FROM   INVENTORY_PART_UNIT_COST_TAB
      WHERE contract         = contract_
      AND   part_no          = part_no_
      AND   configuration_id = configuration_id_
      AND   lot_batch_no     = lot_batch_no_
      AND   serial_no        = serial_no_;
BEGIN
   OPEN get_cost_detail;
   FETCH get_cost_detail BULK COLLECT INTO cost_detail_tab_;
   CLOSE get_cost_detail;

   RETURN(cost_detail_tab_);
END Get_Cost_Detail_Tab___;


FUNCTION Get_Cost_Details_And_Lock___ (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   serial_no_        IN VARCHAR2 ) RETURN Cost_Detail_Tab
IS
   cost_detail_tab_ Cost_Detail_Tab;

   CURSOR get_cost_details_and_lock IS
      SELECT accounting_year,
             contract,
             cost_bucket_id,
             company,
             cost_source_id,
             inventory_value
      FROM   INVENTORY_PART_UNIT_COST_TAB
      WHERE contract         = contract_
      AND   part_no          = part_no_
      AND   configuration_id = configuration_id_
      AND   lot_batch_no     = lot_batch_no_
      AND   serial_no        = serial_no_
      FOR UPDATE;
BEGIN
   OPEN get_cost_details_and_lock;
   FETCH get_cost_details_and_lock BULK COLLECT INTO cost_detail_tab_;
   CLOSE get_cost_details_and_lock;

   RETURN(cost_detail_tab_);
END Get_Cost_Details_And_Lock___;


PROCEDURE Manage_Con_Lot_Ser_Std_Cost___ (
   cost_detail_tab_     IN OUT Cost_Detail_Tab,
   unit_cost_           IN     NUMBER,
   contract_            IN     VARCHAR2,
   part_no_             IN     VARCHAR2,
   configuration_id_    IN     VARCHAR2,
   lot_batch_no_        IN     VARCHAR2,
   serial_no_           IN     VARCHAR2,
   condition_code_      IN     VARCHAR2,
   inventory_part_rec_  IN     Inventory_Part_API.Public_Rec,
   source_ref1_         IN     VARCHAR2,
   source_ref2_         IN     VARCHAR2,
   source_ref3_         IN     VARCHAR2,
   source_ref4_         IN     NUMBER,
   source_ref_type_db_  IN     VARCHAR2,
   company_             IN     VARCHAR2 )
IS
   temp_cost_detail_tab_  Cost_Detail_Tab;
   dummy_tab_             Cost_Detail_Tab;
   exit_procedure_        EXCEPTION;
   external_cost_details_ BOOLEAN := TRUE;
BEGIN

   temp_cost_detail_tab_ := Get_Cost_Detail_Tab___(contract_,
                                                   part_no_,
                                                   configuration_id_,
                                                   lot_batch_no_,
                                                   serial_no_);
   IF (temp_cost_detail_tab_.COUNT > 0) THEN
      cost_detail_tab_ := temp_cost_detail_tab_;
      RAISE exit_procedure_;
   END IF;

   IF (inventory_part_rec_.inventory_part_cost_level = 'COST PER CONDITION') THEN
      temp_cost_detail_tab_ := Get_Condition_Cost_Details___(contract_,
                                                             part_no_,
                                                             configuration_id_,
                                                             condition_code_);
      IF (temp_cost_detail_tab_.count > 0) THEN
         cost_detail_tab_       := temp_cost_detail_tab_;
         external_cost_details_ := FALSE;
      END IF;
   ELSIF (inventory_part_rec_.inventory_part_cost_level = 'COST PER LOT BATCH') THEN
      temp_cost_detail_tab_ := Get_Lot_Batch_Cost_Details(contract_,
                                                          part_no_,
                                                          configuration_id_,
                                                          lot_batch_no_,
                                                          TRUE);
      IF (temp_cost_detail_tab_.count > 0) THEN
         cost_detail_tab_       := temp_cost_detail_tab_;
         external_cost_details_ := FALSE;
      END IF;
   ELSE
      NULL;
   END IF;

   IF ((cost_detail_tab_.COUNT = 0) OR
       (external_cost_details_)) THEN
      cost_detail_tab_ := Generate_Cost_Details___(cost_detail_tab_,
                                                   unit_cost_,
                                                   TRUE,
                                                   company_,
                                                   contract_,
                                                   part_no_,
                                                   configuration_id_,
                                                   source_ref1_,
                                                   source_ref2_,
                                                   source_ref3_,
                                                   source_ref4_,
                                                   source_ref_type_db_,
                                                   NULL,
                                                   inventory_part_rec_,
                                                   NULL,
                                                   NULL);
   END IF;

   Modify_Cost_Details___(new_cost_detail_tab_ => cost_detail_tab_,
                          old_cost_detail_tab_ => dummy_tab_,
                          contract_            => contract_,
                          part_no_             => part_no_,
                          configuration_id_    => configuration_id_,
                          lot_batch_no_        => lot_batch_no_,
                          serial_no_           => serial_no_,
                          zero_cost_flag_db_   => inventory_part_rec_.zero_cost_flag,
                          part_cost_level_db_  => inventory_part_rec_.inventory_part_cost_level,
                          valuation_method_db_ => inventory_part_rec_.inventory_valuation_method);

   Modify_Estimated_Mtrl_Cost___(contract_,
                                 part_no_,
                                 configuration_id_,
                                 cost_detail_tab_,
                                 inventory_part_rec_.lead_time_code);
EXCEPTION
   WHEN exit_procedure_ THEN
      NULL;
END Manage_Con_Lot_Ser_Std_Cost___;


PROCEDURE Make_Revalue_Transactions___ (
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   configuration_id_    IN VARCHAR2,
   lot_batch_no_        IN VARCHAR2,
   serial_no_           IN VARCHAR2,
   old_cost_detail_tab_ IN Cost_Detail_Tab,
   new_cost_detail_tab_ IN Cost_Detail_Tab,
   transaction_pos_     IN VARCHAR2,
   transaction_neg_     IN VARCHAR2,
   quantity_            IN NUMBER,
   location_group_      IN VARCHAR2,
   activity_seq_        IN NUMBER,
   condition_code_      IN VARCHAR2,
   valuation_method_db_ IN VARCHAR2 )
IS
   exit_procedure_         EXCEPTION;
   company_                INVENTORY_PART_UNIT_COST_TAB.company%TYPE;
   positive_cost_diff_tab_ Cost_Detail_Tab;
   negative_cost_diff_tab_ Cost_Detail_Tab;
   transaction_id_         NUMBER;
BEGIN

   IF (quantity_ = 0) THEN
      RAISE exit_procedure_;
   END IF;

   Create_Cost_Diff_Tables(positive_cost_diff_tab_,
                           negative_cost_diff_tab_,
                           old_cost_detail_tab_,
                           new_cost_detail_tab_);

   IF (positive_cost_diff_tab_.COUNT > 0) THEN

      company_ := Site_API.Get_Company(contract_);

      Make_Revalue_Transaction___(transaction_id_,
                                  contract_,
                                  part_no_,
                                  configuration_id_,
                                  lot_batch_no_,
                                  serial_no_,
                                  positive_cost_diff_tab_,
                                  TRUE,
                                  transaction_pos_,
                                  transaction_neg_,
                                  quantity_,
                                  location_group_,
                                  activity_seq_,
                                  condition_code_);

      IF (valuation_method_db_ = 'AV') THEN
         Pre_Invent_Trans_Avg_Cost_API.Replace_Cost_Details(transaction_id_,
                                                            old_cost_detail_tab_);
      END IF;
   END IF;

   IF (negative_cost_diff_tab_.COUNT > 0) THEN

      IF (company_ IS NULL) THEN
         company_ := Site_API.Get_Company(contract_);
      END IF;

      Make_Revalue_Transaction___(transaction_id_,
                                  contract_,
                                  part_no_,
                                  configuration_id_,
                                  lot_batch_no_,
                                  serial_no_,
                                  negative_cost_diff_tab_,
                                  FALSE,
                                  transaction_pos_,
                                  transaction_neg_,
                                  quantity_,
                                  location_group_,
                                  activity_seq_,
                                  condition_code_);

      IF (valuation_method_db_ = 'AV') THEN
         Pre_Invent_Trans_Avg_Cost_API.Replace_Cost_Details(transaction_id_,
                                                            old_cost_detail_tab_);
      END IF;
   END IF;

EXCEPTION
   WHEN exit_procedure_ THEN
      NULL;
END Make_Revalue_Transactions___;


PROCEDURE Modify_Cost_Details___ (
   new_cost_detail_tab_ IN OUT Cost_Detail_Tab,
   old_cost_detail_tab_ IN     Cost_Detail_Tab,
   contract_            IN     VARCHAR2,
   part_no_             IN     VARCHAR2,
   configuration_id_    IN     VARCHAR2,
   lot_batch_no_        IN     VARCHAR2,
   serial_no_           IN     VARCHAR2,
   zero_cost_flag_db_   IN     VARCHAR2,
   part_cost_level_db_  IN     VARCHAR2,
   valuation_method_db_ IN     VARCHAR2 )
IS
   missing_in_old_detail_tab_ BOOLEAN;
   missing_in_new_detail_tab_ BOOLEAN;
BEGIN

   IF (old_cost_detail_tab_.COUNT > 0) THEN
      FOR i IN old_cost_detail_tab_.FIRST..old_cost_detail_tab_.LAST LOOP

         missing_in_new_detail_tab_ := TRUE;

         IF (new_cost_detail_tab_.COUNT > 0) THEN
            FOR j IN new_cost_detail_tab_.FIRST..new_cost_detail_tab_.LAST LOOP
               IF ((old_cost_detail_tab_(i).accounting_year =
                    new_cost_detail_tab_(j).accounting_year) AND
                   (old_cost_detail_tab_(i).contract =
                    new_cost_detail_tab_(j).contract)        AND
                   (old_cost_detail_tab_(i).cost_bucket_id =
                    new_cost_detail_tab_(j).cost_bucket_id)  AND
                   (old_cost_detail_tab_(i).company =
                    new_cost_detail_tab_(j).company)         AND
                   (old_cost_detail_tab_(i).cost_source_id  =
                    new_cost_detail_tab_(j).cost_source_id)) THEN

                  IF (old_cost_detail_tab_(i).unit_cost !=
                      new_cost_detail_tab_(j).unit_cost) THEN

                     Modify_Cost_Detail__(contract_,
                                          part_no_,
                                          configuration_id_,
                                          lot_batch_no_,
                                          serial_no_,
                                          old_cost_detail_tab_(i).accounting_year,
                                          old_cost_detail_tab_(i).cost_bucket_id,
                                          old_cost_detail_tab_(i).company,
                                          old_cost_detail_tab_(i).cost_source_id,
                                          new_cost_detail_tab_(j).unit_cost);
                  END IF;

                  missing_in_new_detail_tab_ := FALSE;
               END IF;
            END LOOP;
         END IF;
         IF (missing_in_new_detail_tab_) THEN

            Remove___(contract_,
                      part_no_,
                      configuration_id_,
                      lot_batch_no_,
                      serial_no_,
                      old_cost_detail_tab_(i).accounting_year,
                      old_cost_detail_tab_(i).cost_bucket_id,
                      old_cost_detail_tab_(i).company,
                      old_cost_detail_tab_(i).cost_source_id);
         END IF;
      END LOOP;
   END IF;

   IF (new_cost_detail_tab_.COUNT > 0) THEN
      FOR i IN new_cost_detail_tab_.FIRST..new_cost_detail_tab_.LAST LOOP

         IF (contract_ != new_cost_detail_tab_(i).contract) THEN
            Error_SYS.Record_General(lu_name_, 'CONTRACTERR2: Cost Bucket ID :P1 is connected to Site :P2. Only cost buckets connected to site :P3 are allowed.',new_cost_detail_tab_(i).cost_bucket_id, new_cost_detail_tab_(i).contract, contract_);
         END IF;

         missing_in_old_detail_tab_ := TRUE;

         IF (old_cost_detail_tab_.COUNT > 0) THEN
            FOR j IN old_cost_detail_tab_.FIRST..old_cost_detail_tab_.LAST LOOP
               IF ((new_cost_detail_tab_(i).accounting_year =
                    old_cost_detail_tab_(j).accounting_year) AND
                   (new_cost_detail_tab_(i).contract        =
                    old_cost_detail_tab_(j).contract)        AND
                   (new_cost_detail_tab_(i).cost_bucket_id  =
                    old_cost_detail_tab_(j).cost_bucket_id)  AND
                   (new_cost_detail_tab_(i).company         =
                    old_cost_detail_tab_(j).company)         AND
                   (new_cost_detail_tab_(i).cost_source_id  =
                    old_cost_detail_tab_(j).cost_source_id)) THEN

                  missing_in_old_detail_tab_ := FALSE;
               END IF;
            END LOOP;
         END IF;
         IF (missing_in_old_detail_tab_) THEN

            New___(contract_,
                   part_no_,
                   configuration_id_,
                   lot_batch_no_,
                   serial_no_,
                   new_cost_detail_tab_(i).accounting_year,
                   new_cost_detail_tab_(i).cost_bucket_id,
                   new_cost_detail_tab_(i).company,
                   new_cost_detail_tab_(i).cost_source_id,
                   new_cost_detail_tab_(i).unit_cost);
         END IF;
      END LOOP;
   END IF;

   Add_Zero_Default_And_Check___(new_cost_detail_tab_,
                                 contract_,
                                 part_no_,
                                 configuration_id_,
                                 lot_batch_no_,
                                 serial_no_,
                                 zero_cost_flag_db_,
                                 part_cost_level_db_,
                                 valuation_method_db_);
END Modify_Cost_Details___;


PROCEDURE Remove_All_Cost_Details___ (
   contract_          IN VARCHAR2,
   part_no_           IN VARCHAR2,
   configuration_id_  IN VARCHAR2,
   lot_batch_no_      IN VARCHAR2,
   serial_no_         IN VARCHAR2 )
IS
   cost_detail_tab_ Cost_Detail_Tab;
BEGIN

   cost_detail_tab_ := Get_Cost_Details_And_Lock___(contract_,
                                                    part_no_,
                                                    configuration_id_,
                                                    lot_batch_no_,
                                                    serial_no_);
   IF (cost_detail_tab_.COUNT > 0) THEN
      FOR i IN cost_detail_tab_.FIRST..cost_detail_tab_.LAST LOOP
         Remove___(contract_,
                   part_no_,
                   configuration_id_,
                   lot_batch_no_,
                   serial_no_,
                   cost_detail_tab_(i).accounting_year,
                   cost_detail_tab_(i).cost_bucket_id,
                   cost_detail_tab_(i).company,
                   cost_detail_tab_(i).cost_source_id);
      END LOOP;
   END IF;
END Remove_All_Cost_Details___;


PROCEDURE Modify_Details_And_Revalue___ (
   contract_                 IN VARCHAR2,
   part_no_                  IN VARCHAR2,
   configuration_id_         IN VARCHAR2,
   lot_batch_no_             IN VARCHAR2,
   serial_no_                IN VARCHAR2,
   part_cost_level_db_       IN VARCHAR2,
   valuation_method_db_      IN VARCHAR2,
   invoice_consideration_db_ IN VARCHAR2,
   zero_cost_flag_db_        IN VARCHAR2,
   new_cost_detail_tab_      IN Cost_Detail_Tab )
IS
   old_cost_detail_tab_       Cost_Detail_Tab;
   local_new_cost_detail_tab_ Cost_Detail_Tab;
   revalue_inventory_         BOOLEAN;
BEGIN

   old_cost_detail_tab_ := Get_Cost_Details_And_Lock___(contract_,
                                                        part_no_,
                                                        configuration_id_,
                                                        lot_batch_no_,
                                                        serial_no_);

   IF (valuation_method_db_ = 'ST') THEN
      IF (invoice_consideration_db_ = 'IGNORE INVOICE PRICE') THEN
         revalue_inventory_ := TRUE;
      ELSE
         revalue_inventory_ := FALSE;
      END IF;
   ELSIF (valuation_method_db_ = 'AV') THEN
         revalue_inventory_ := TRUE;
   ELSE
      Raise_Value_Method_Error___;
   END IF;

   IF (revalue_inventory_) THEN
      Revalue_Inventory___(contract_,
                           part_no_,
                           configuration_id_,
                           lot_batch_no_,
                           serial_no_,
                           part_cost_level_db_,
                           valuation_method_db_,
                           old_cost_detail_tab_,
                           new_cost_detail_tab_);
   END IF;

   local_new_cost_detail_tab_ := new_cost_detail_tab_;

   Modify_Cost_Details___(local_new_cost_detail_tab_,
                          old_cost_detail_tab_,
                          contract_,
                          part_no_,
                          configuration_id_,
                          lot_batch_no_,
                          serial_no_,
                          zero_cost_flag_db_,
                          part_cost_level_db_,
                          valuation_method_db_);

END Modify_Details_And_Revalue___;


FUNCTION Generate_New_Cost_Details___ (
   unit_cost_             IN NUMBER,
   unit_cost_is_material_ IN BOOLEAN,
   contract_              IN VARCHAR2,
   part_no_               IN VARCHAR2,
   configuration_id_      IN VARCHAR2,
   inventory_part_rec_    IN Inventory_Part_API.Public_Rec,
   source_ref1_           IN VARCHAR2 DEFAULT NULL,
   source_ref2_           IN VARCHAR2 DEFAULT NULL,
   source_ref3_           IN VARCHAR2 DEFAULT NULL,
   source_ref4_           IN NUMBER   DEFAULT NULL,
   source_ref_type_db_    IN VARCHAR2 DEFAULT NULL,
   cost_source_date_      IN DATE     DEFAULT NULL,
   trans_quantity_        IN NUMBER   DEFAULT NULL,
   vendor_no_             IN VARCHAR2 DEFAULT NULL ) RETURN Cost_Detail_Tab
IS
   company_         INVENTORY_PART_UNIT_COST_TAB.company%TYPE;
   cost_detail_tab_ Cost_Detail_Tab;
   local_vendor_no_ VARCHAR2(20);
   order_size_      NUMBER;   
BEGIN
   company_ := Site_API.Get_Company(contract_);

   IF (vendor_no_ IS NOT NULL) THEN
      local_vendor_no_ := vendor_no_;
   END IF;
   
   $IF Component_Cost_SYS.INSTALLED $THEN
      IF (unit_cost_ != 0) THEN
         IF (source_ref_type_db_ = 'PUR ORDER' AND local_vendor_no_ IS NULL ) THEN
            $IF (Component_Purch_SYS.INSTALLED) $THEN
                local_vendor_no_  := Purchase_Order_API.Get_Vendor_No(source_ref1_); 
            $ELSE
                Error_SYS.Component_Not_Exist('PURCH');
            $END 
         END IF;

         order_size_ := NVL(trans_quantity_, 0);
         IF order_size_ = 0 THEN
            order_size_ := 1;
         END IF;

         cost_detail_tab_ := Get_Details_From_Costing___(contract_,
                                                         part_no_,
                                                         configuration_id_,
                                                         unit_cost_,
                                                         unit_cost_is_material_,
                                                         source_ref_type_db_,
                                                         local_vendor_no_,
                                                         order_size_);

         cost_detail_tab_ := Merge_And_Complete_Details(cost_detail_tab_,
                                                        inventory_part_rec_,
                                                        contract_,
                                                        part_no_,
                                                        company_,
                                                        '*',
                                                        source_ref1_,
                                                        source_ref2_,
                                                        source_ref3_,
                                                        source_ref4_,
                                                        source_ref_type_db_,
                                                        cost_source_date_); 
      ELSE
         cost_detail_tab_(1).accounting_year := '*';
         cost_detail_tab_(1).contract        := contract_;
         cost_detail_tab_(1).cost_bucket_id  := '*';
         cost_detail_tab_(1).company         := company_;
         cost_detail_tab_(1).cost_source_id  := '*';
         cost_detail_tab_(1).unit_cost       := unit_cost_;
      END IF;
   $ELSE
      cost_detail_tab_(1).accounting_year := '*';
      cost_detail_tab_(1).contract        := contract_;
      cost_detail_tab_(1).cost_bucket_id  := '*';
      cost_detail_tab_(1).company         := company_;
      cost_detail_tab_(1).cost_source_id  := '*';
      cost_detail_tab_(1).unit_cost       := unit_cost_;           
   $END

   RETURN (cost_detail_tab_);
END Generate_New_Cost_Details___;


FUNCTION Get_Wa_Config_Cost_Details___ (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2 ) RETURN Cost_Detail_Tab
IS
   grand_total_qty_       NUMBER := 0;
   cost_detail_tab_       Cost_Detail_Tab;
   value_detail_tab_      Cost_Detail_Tab;
   config_lot_serial_tab_ Inventory_Part_In_Stock_API.Config_Lot_Serial_Tab;       

BEGIN
   grand_total_qty_       := 0;

   config_lot_serial_tab_ := Invent_Part_Quantity_Util_API.Get_Company_Owned_Inventory(contract_,
                                                                                       part_no_,
                                                                                       configuration_id_);

   IF (config_lot_serial_tab_.COUNT > 0) THEN
       FOR i IN config_lot_serial_tab_.FIRST..config_lot_serial_tab_.LAST LOOP
          grand_total_qty_ := grand_total_qty_ + config_lot_serial_tab_(i).quantity;
          cost_detail_tab_ := Get_Cost_Detail_Tab___(contract_,
                                                     part_no_,
                                                     config_lot_serial_tab_(i).configuration_id,
                                                     config_lot_serial_tab_(i).lot_batch_no,
                                                     config_lot_serial_tab_(i).serial_no);
                
          value_detail_tab_ := Add_To_Value_Detail_Tab(value_detail_tab_,
                                                       cost_detail_tab_,
                                                       config_lot_serial_tab_(i).quantity);
       END LOOP;
   END IF;

   IF (grand_total_qty_ > 0) THEN
      cost_detail_tab_ := Value_To_Cost_Details(value_detail_tab_,
                                                grand_total_qty_);
   ELSE
      cost_detail_tab_.DELETE;
   END IF;

   RETURN (cost_detail_tab_);
END Get_Wa_Config_Cost_Details___;


FUNCTION Get_Condition_Cost_Details___ (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   condition_code_   IN VARCHAR2 ) RETURN Cost_Detail_Tab
IS
   cost_detail_tab_        Cost_Detail_Tab;
   char_null_              VARCHAR2(12) := 'VARCHAR2NULL';
   current_condition_code_ VARCHAR2(50);

   CURSOR get_lot_serial (contract_         IN VARCHAR2,
                          part_no_          IN VARCHAR2,
                          configuration_id_ IN VARCHAR2) IS
      SELECT DISTINCT lot_batch_no, serial_no
        FROM  INVENTORY_PART_UNIT_COST_TAB
       WHERE  contract         = contract_
         AND  part_no          = part_no_
         AND  configuration_id = configuration_id_
         AND (serial_no != '*' OR lot_batch_no != '*');
BEGIN
   FOR lot_serial_rec_ IN get_lot_serial (contract_,
                                          part_no_,
                                          configuration_id_) LOOP
      current_condition_code_ := Condition_Code_Manager_API.Get_Condition_Code(part_no_,
                                                                               lot_serial_rec_.serial_no,
                                                                               lot_serial_rec_.lot_batch_no);

      IF (NVL(condition_code_, char_null_) = NVL(current_condition_code_, char_null_)) THEN
         -- There is already at least one record in the table with identical values for
         -- contract, part_no, configuration_id and condition_code.
         cost_detail_tab_ := Get_Cost_Detail_Tab___(contract_,
                                                    part_no_,
                                                    configuration_id_,
                                                    lot_serial_rec_.lot_batch_no,
                                                    lot_serial_rec_.serial_no);
         EXIT;
      END IF;
   END LOOP;

   RETURN(cost_detail_tab_);
END Get_Condition_Cost_Details___;


PROCEDURE Modify_Estimated_Mtrl_Cost___ (
   contract_          IN VARCHAR2,
   part_no_           IN VARCHAR2,
   configuration_id_  IN VARCHAR2,
   cost_detail_tab_   IN Cost_Detail_Tab,
   lead_time_code_db_ IN VARCHAR2 )
IS
   estimated_material_cost_   NUMBER;
   accumulated_material_cost_ NUMBER;
   exit_procedure_            EXCEPTION;
BEGIN

   IF (lead_time_code_db_ = 'M') THEN
      $IF Component_Cost_SYS.INSTALLED $THEN
         RAISE exit_procedure_;
      $ELSE 
         NULL;
      $END      
   END IF;

   estimated_material_cost_ := Inventory_Part_Config_API.Get_Estimated_Material_Cost(contract_,
                                                                                     part_no_,
                                                                                     configuration_id_);
   IF (estimated_material_cost_ = 0) THEN
      accumulated_material_cost_ := Get_Accumulated_Mtrl_Cost___(cost_detail_tab_);
   END IF;

   IF (accumulated_material_cost_ > 0) THEN
      Inventory_Part_Config_API.Modify_Estimated_Material_Cost(contract_,
                                                               part_no_,
                                                               configuration_id_,
                                                               accumulated_material_cost_);
   END IF;
EXCEPTION
   WHEN exit_procedure_ THEN
      NULL;
END Modify_Estimated_Mtrl_Cost___;


PROCEDURE Remove___ (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   accounting_year_  IN VARCHAR2,
   cost_bucket_id_   IN VARCHAR2,
   company_          IN VARCHAR2,
   cost_source_id_   IN VARCHAR2 )
IS
   objid_         INVENTORY_PART_UNIT_COST.objid%TYPE;
   objversion_    INVENTORY_PART_UNIT_COST.objversion%TYPE;
   remrec_        INVENTORY_PART_UNIT_COST_TAB%ROWTYPE;
BEGIN

   remrec_ := Lock_By_Keys___(contract_,
                              part_no_,
                              configuration_id_,
                              lot_batch_no_,
                              serial_no_,
                              accounting_year_,
                              cost_bucket_id_,
                              company_,
                              cost_source_id_);

   Check_Delete___(remrec_, false);

   Get_Id_Version_By_Keys___(objid_,
                             objversion_,
                             remrec_.contract,
                             remrec_.part_no,
                             remrec_.configuration_id,
                             remrec_.lot_batch_no,
                             remrec_.serial_no,
                             remrec_.accounting_year,
                             remrec_.cost_bucket_id,
                             remrec_.company,
                             remrec_.cost_source_id);

   Delete___(objid_, remrec_);
END Remove___;


FUNCTION Get_Cost_Bucket_Type_Db___ (
   contract_       IN VARCHAR2,
   cost_bucket_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN (Invent_Cost_Bucket_Manager_API.Get_Cost_Bucket_Type_Db(contract_,cost_bucket_id_));
END Get_Cost_Bucket_Type_Db___;


FUNCTION Get_Accumulated_Mtrl_Cost___ (
   cost_detail_tab_ IN Cost_Detail_Tab ) RETURN NUMBER
IS
   accumulated_mtrl_cost_ NUMBER := 0;
   cost_bucket_type_db_   VARCHAR2(20);
BEGIN
   IF (cost_detail_tab_.COUNT > 0) THEN
      FOR i IN cost_detail_tab_.FIRST..cost_detail_tab_.LAST LOOP

         cost_bucket_type_db_ := Get_Cost_Bucket_Type_Db___(cost_detail_tab_(i).contract,
                                                            cost_detail_tab_(i).cost_bucket_id);

         IF (cost_bucket_type_db_ = 'MATERIAL') THEN
            accumulated_mtrl_cost_ := accumulated_mtrl_cost_ + cost_detail_tab_(i).unit_cost;
         END IF;
      END LOOP;
   END IF;

   RETURN (accumulated_mtrl_cost_);
END Get_Accumulated_Mtrl_Cost___;


-- Add_Zero_Default_And_Check___
--   Adds a zero cost default detail if no details exist and then make
--   validations against zero cost flag.
PROCEDURE Add_Zero_Default_And_Check___ (
   cost_detail_tab_     OUT Cost_Detail_Tab,
   contract_            IN  VARCHAR2,
   part_no_             IN  VARCHAR2,
   configuration_id_    IN  VARCHAR2,
   lot_batch_no_        IN  VARCHAR2,
   serial_no_           IN  VARCHAR2,
   zero_cost_flag_db_   IN  VARCHAR2,
   part_cost_level_db_  IN  VARCHAR2,
   valuation_method_db_ IN  VARCHAR2 )
IS
   positive_cost_diff_tab_    Cost_Detail_Tab;
   negative_cost_diff_tab_    Cost_Detail_Tab;
   base_part_cost_detail_tab_ Cost_Detail_Tab;
BEGIN

   cost_detail_tab_ := Get_Cost_Detail_Tab___(contract_,
                                              part_no_,
                                              configuration_id_,
                                              lot_batch_no_,
                                              serial_no_);
   IF (cost_detail_tab_.COUNT = 0) THEN
      cost_detail_tab_(1).accounting_year := '*';
      cost_detail_tab_(1).contract        := contract_;
      cost_detail_tab_(1).cost_bucket_id  := '*';
      cost_detail_tab_(1).company         := Site_API.Get_Company(contract_);
      cost_detail_tab_(1).cost_source_id  := '*';
      cost_detail_tab_(1).unit_cost       := 0;

      New___(contract_,
             part_no_,
             configuration_id_,
             lot_batch_no_,
             serial_no_,
             cost_detail_tab_(1).accounting_year,
             cost_detail_tab_(1).cost_bucket_id,
             cost_detail_tab_(1).company,
             cost_detail_tab_(1).cost_source_id,
             cost_detail_tab_(1).unit_cost);
   ELSE
      IF (Non_Zero_Cost_Detail_Exist(cost_detail_tab_)) THEN
         FOR i IN cost_detail_tab_.FIRST..cost_detail_tab_.LAST LOOP
            IF (cost_detail_tab_(i).unit_cost = 0) THEN
               Remove___(contract_,
                         part_no_,
                         configuration_id_,
                         lot_batch_no_,
                         serial_no_,
                         cost_detail_tab_(i).accounting_year,
                         cost_detail_tab_(i).cost_bucket_id,
                         cost_detail_tab_(i).company,
                         cost_detail_tab_(i).cost_source_id);
            END IF;
         END LOOP;
      END IF;
   END IF;

   cost_detail_tab_ := Get_Cost_Detail_Tab___(contract_,
                                              part_no_,
                                              configuration_id_,
                                              lot_batch_no_,
                                              serial_no_);
   Check_Zero_Cost_Flag___(contract_,
                           part_no_,
                           configuration_id_,
                           lot_batch_no_,
                           serial_no_,
                           zero_cost_flag_db_,
                           part_cost_level_db_,
                           valuation_method_db_,
                           cost_detail_tab_);

   IF ((part_cost_level_db_ = 'COST PER PART') AND (configuration_id_ != '*')) THEN

      base_part_cost_detail_tab_ := Get_Cost_Details_By_Method(contract_,
                                                               part_no_,
                                                               '*',
                                                               '*',
                                                               '*');
      Create_Cost_Diff_Tables(positive_cost_diff_tab_,
                              negative_cost_diff_tab_,
                              base_part_cost_detail_tab_,
                              cost_detail_tab_);

      IF ((positive_cost_diff_tab_.COUNT > 0) OR
          (negative_cost_diff_tab_.COUNT > 0)) THEN
         Error_SYS.Record_General(lu_name_,
                                  'CONFIGITEMI: Unit Cost for the configuration must be the same as for the configurable part when using Cost Level :P1.',
                                  Inventory_Part_Cost_Level_API.Decode(part_cost_level_db_));
      END IF;
   END IF;
END Add_Zero_Default_And_Check___;


-- Get_Details_From_Last_Trans___
--   This method gets the cost details from the last transaction.
FUNCTION Get_Details_From_Last_Trans___ (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   condition_code_   IN VARCHAR2,
   calling_process_  IN VARCHAR2,
   last_attempt_     IN BOOLEAN ) RETURN Cost_Detail_Tab
IS
   latest_transaction_id_ NUMBER;
   cost_detail_tab_       Cost_Detail_Tab;
   estimated_material_cost_ NUMBER;
BEGIN
   latest_transaction_id_ := Inventory_Transaction_Hist_API.Get_Latest_Transaction_Id(
                                                     contract_                => contract_,
                                                     part_no_                 => part_no_,
                                                     configuration_id_        => configuration_id_,
                                                     lot_batch_no_            => lot_batch_no_,
                                                     serial_no_               => serial_no_,
                                                     condition_code_          => condition_code_,
                                                     include_plus_direction_  => TRUE,
                                                     include_minus_direction_ => TRUE,
                                                     include_zero_direction_  => FALSE);
   
   IF ((latest_transaction_id_ IS NULL) AND (last_attempt_) AND
      (calling_process_ = 'RETURN MATERIAL AUTHORIZATION')) THEN

      latest_transaction_id_ := Inventory_Transaction_Hist_API.Get_Latest_Transaction_Id(
                                                     contract_                => contract_,
                                                     part_no_                 => part_no_,
                                                     configuration_id_        => configuration_id_,
                                                     lot_batch_no_            => lot_batch_no_,
                                                     serial_no_               => serial_no_,
                                                     condition_code_          => condition_code_,
                                                     include_plus_direction_  => FALSE,
                                                     include_minus_direction_ => FALSE,
                                                     include_zero_direction_  => TRUE);
   END IF;
   
   IF (latest_transaction_id_ IS NULL) THEN
      -- If there are no transactions and calling process is IPR UNIT COST SNAPSHOT
      -- then consider the estimated material cost as the unit cast of the part.
      IF ((last_attempt_) AND (calling_process_ = 'IPR UNIT COST SNAPSHOT')) THEN

         estimated_material_cost_ := Inventory_Part_Config_API.Get_Estimated_Material_Cost(contract_,
                                                                                           part_no_,
                                                                                           NVL(configuration_id_, '*'));
         IF (estimated_material_cost_ IS NOT NULL ) THEN
            cost_detail_tab_ := Generate_New_Cost_Details___(estimated_material_cost_,
                                                             TRUE,
                                                             contract_,
                                                             part_no_,
                                                             NVL(configuration_id_, '*'),
                                                             Inventory_Part_API.Get(contract_, part_no_));
         END IF;
      END IF;
   ELSE
      cost_detail_tab_ := Inventory_Transaction_Cost_API.Get_Transaction_Cost_Details(
                                                                           transaction_id_           => latest_transaction_id_,
                                                                           include_added_details_    => FALSE,
                                                                           include_normal_details_   => TRUE,
                                                                           replace_star_cost_bucket_ => TRUE);
   END IF;
   RETURN (cost_detail_tab_);
END Get_Details_From_Last_Trans___;


PROCEDURE Modify_Condition_Cost___ (
   contract_           IN VARCHAR2,
   part_no_            IN VARCHAR2,
   inventory_part_rec_ IN Inventory_Part_API.Public_Rec,
   configuration_id_   IN VARCHAR2,
   condition_code_     IN VARCHAR2,
   cost_detail_id_     IN NUMBER )
IS
   attr_                   VARCHAR2(2000);
   batch_desc_             VARCHAR2(200);
   old_cost_detail_tab_    Cost_Detail_Tab;
   new_cost_detail_tab_    Cost_Detail_Tab;
   positive_cost_diff_tab_ Cost_Detail_Tab;
   negative_cost_diff_tab_ Cost_Detail_Tab;
   new_total_unit_cost_    NUMBER;
BEGIN

   Inventory_Part_Config_API.Exist(contract_, part_no_, configuration_id_);
   Condition_Code_API.Exist(condition_code_);

   IF (inventory_part_rec_.inventory_part_cost_level != 'COST PER CONDITION') THEN
      Raise_Cost_Level_Error___(Inventory_Part_Cost_Level_API.DB_COST_PER_CONDITION);
   END IF;

   old_cost_detail_tab_ := Get_Cost_Details_By_Condition(contract_,
                                                         part_no_,
                                                         configuration_id_,
                                                         condition_code_);

   new_cost_detail_tab_ := Temporary_Part_Cost_Detail_API.Get_Details(cost_detail_id_);

   new_total_unit_cost_ := Get_Total_Unit_Cost(new_cost_detail_tab_);

   IF (new_total_unit_cost_ = 0) THEN
      IF (inventory_part_rec_.zero_cost_flag = 'N') THEN
         Error_SYS.Record_General(lu_name_, 'MCCZEROCOST2: Cost of the part cannot be 0 when :P1.',Inventory_Part_Zero_Cost_API.Decode(inventory_part_rec_.zero_cost_flag));
      END IF;
   ELSE
      IF (inventory_part_rec_.zero_cost_flag = 'O') THEN
         Error_SYS.Record_General(lu_name_, 'MCCZEROCOST1: Cost of the part has to be 0 when :P1.',Inventory_Part_Zero_Cost_API.Decode(inventory_part_rec_.zero_cost_flag));
      END IF;
   END IF;

   Create_Cost_Diff_Tables(positive_cost_diff_tab_,
                           negative_cost_diff_tab_,
                           old_cost_detail_tab_,
                           new_cost_detail_tab_);

   IF ((positive_cost_diff_tab_.COUNT = 0) AND
       (negative_cost_diff_tab_.COUNT = 0)) THEN
      Error_SYS.Record_General(lu_name_, 'EQUALCOST: New cost is equal to current cost.');
   END IF;

   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('CONTRACT'        , contract_        , attr_);
   Client_SYS.Add_To_Attr('PART_NO'         , part_no_         , attr_);
   Client_SYS.Add_To_Attr('CONFIGURATION_ID', configuration_id_, attr_);
   Client_SYS.Add_To_Attr('CONDITION_CODE'  , condition_code_  , attr_);
   Client_SYS.Add_To_Attr('COST_DETAIL_ID'  , cost_detail_id_  , attr_);

   batch_desc_:= Language_SYS.Translate_Constant(lu_name_,'MODCONDCOST: Modify Condition Average Cost for Inventory Part.');
   Transaction_SYS.Deferred_Call('INVENTORY_PART_UNIT_COST_API.Modify_Condition_Cost__', attr_, batch_desc_);

END Modify_Condition_Cost___;


PROCEDURE Modify_Lot_Batch_Cost___ (
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   inventory_part_rec_  IN Inventory_Part_API.Public_Rec,
   configuration_id_    IN VARCHAR2,
   lot_batch_no_        IN VARCHAR2,
   new_cost_detail_tab_ IN Cost_Detail_Tab )
IS
   CURSOR get_serial_number IS
   SELECT DISTINCT serial_no
      FROM INVENTORY_PART_UNIT_COST_TAB
      WHERE part_no          = part_no_
        AND contract         = contract_
        AND configuration_id = configuration_id_
        AND lot_batch_no     = lot_batch_no_;
BEGIN

   IF (inventory_part_rec_.inventory_valuation_method NOT IN ('ST','AV')) THEN
      Raise_Value_Method_Error___;
   END IF;

   IF (inventory_part_rec_.inventory_part_cost_level != 'COST PER LOT BATCH') THEN
      Raise_Cost_Level_Error___(Inventory_Part_Cost_Level_API.DB_COST_PER_LOT_BATCH);
   END IF;

   Inventory_Part_Config_API.Exist(contract_, part_no_, configuration_id_);

   FOR serial_rec_ IN get_serial_number LOOP
      Modify_Details_And_Revalue___(contract_,
                                    part_no_,
                                    configuration_id_,
                                    lot_batch_no_,
                                    serial_rec_.serial_no,
                                    inventory_part_rec_.inventory_part_cost_level,
                                    inventory_part_rec_.inventory_valuation_method,
                                    inventory_part_rec_.invoice_consideration,
                                    inventory_part_rec_.zero_cost_flag,
                                    new_cost_detail_tab_);
   END LOOP;
END Modify_Lot_Batch_Cost___;


FUNCTION Cond_Lot_Ser_Std_Cost_Exist___ (
   contract_           IN VARCHAR2,
   part_no_            IN VARCHAR2,
   configuration_id_   IN VARCHAR2,
   lot_batch_no_       IN VARCHAR2,
   serial_no_          IN VARCHAR2,
   condition_code_     IN VARCHAR2,
   part_cost_level_db_ IN VARCHAR2 ) RETURN BOOLEAN
IS
  standard_cost_exist_  BOOLEAN := FALSE;
  cost_detail_tab_      Cost_Detail_Tab;
  get_cost_detail_tab_  BOOLEAN := TRUE;
  local_condition_code_ VARCHAR2(10);
BEGIN
   CASE (part_cost_level_db_)
      WHEN ('COST PER SERIAL') THEN
         IF (serial_no_ = '*') THEN
            get_cost_detail_tab_ := FALSE;
         END IF;
      WHEN ('COST PER LOT BATCH') THEN
         IF (lot_batch_no_ = '*') THEN
            get_cost_detail_tab_ := FALSE;
         END IF;
      WHEN ('COST PER CONDITION') THEN
         IF ((serial_no_ = '*') AND (lot_batch_no_ = '*')) THEN
            get_cost_detail_tab_ := FALSE;
         END IF;
   END CASE;

   IF (get_cost_detail_tab_) THEN
      cost_detail_tab_ := Get_Cost_Detail_Tab___(contract_,
                                                 part_no_,
                                                 configuration_id_,
                                                 lot_batch_no_,
                                                 serial_no_);
   END IF;

   IF (cost_detail_tab_.COUNT > 0) THEN
      standard_cost_exist_ := TRUE;
   ELSE
      IF (part_cost_level_db_ = 'COST PER CONDITION') THEN
         IF (condition_code_ IS NULL) THEN
            local_condition_code_ := Condition_Code_API.Get_Default_Condition_Code;
         ELSE
            local_condition_code_ := condition_code_;
         END IF;

         cost_detail_tab_ := Get_Condition_Cost_Details___(contract_,
                                                           part_no_,
                                                           configuration_id_,
                                                           local_condition_code_);

         IF (cost_detail_tab_.count > 0) THEN
            standard_cost_exist_ := TRUE;
         END IF;

      ELSIF (part_cost_level_db_ = 'COST PER LOT BATCH') THEN
         IF (lot_batch_no_ != '*') THEN
            cost_detail_tab_ := Get_Lot_Batch_Cost_Details(contract_,
                                                           part_no_,
                                                           configuration_id_,
                                                           lot_batch_no_,
                                                           FALSE);
            IF (cost_detail_tab_.count > 0) THEN
               standard_cost_exist_ := TRUE;
            END IF;
         END IF;
      ELSE
         NULL;
      END IF;
   END IF;

   RETURN (standard_cost_exist_);
END Cond_Lot_Ser_Std_Cost_Exist___;


FUNCTION Part_Config_Std_Cost_Exist___ (
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   configuration_id_    IN VARCHAR2,
   part_cost_level_db_  IN VARCHAR2 ) RETURN BOOLEAN
IS
   standard_cost_exist_       BOOLEAN := FALSE;
   configuration_id_temp_     INVENTORY_PART_UNIT_COST_TAB.configuration_id%TYPE;
   cost_detail_tab_           Cost_Detail_Tab;
   company_owned_trans_exist_ BOOLEAN;
   std_cost_established_      VARCHAR2(5) := 'FALSE';

BEGIN
   IF (part_cost_level_db_ = 'COST PER PART') THEN
      configuration_id_temp_ := NULL;
   ELSE
      configuration_id_temp_ := configuration_id_;
   END IF;

   cost_detail_tab_ := Get_Cost_Detail_Tab___(contract_,
                                              part_no_,
                                              NVL(configuration_id_temp_,'*'),
                                              '*',
                                              '*');

   IF (Non_Zero_Cost_Detail_Exist(cost_detail_tab_)) THEN
      standard_cost_exist_ := TRUE;
   ELSE
      $IF (Component_Cost_SYS.INSTALLED) $THEN
         std_cost_established_ := Part_Cost_History_API.Check_Std_Cost_Established(contract_,
                                                                                   part_no_,
                                                                                   NVL(configuration_id_temp_,'*')); 
      $END

      IF (std_cost_established_ = 'TRUE') THEN
         standard_cost_exist_ := TRUE;
      ELSE
         -- EBALL-37, Modified method call to use the fully encapsulated method from Invent_Part_Quantity_Util_API.
         IF Invent_Part_Quantity_Util_API.Check_Quantity_Exist(contract_                      => contract_,
                                                               part_no_                       => part_no_,
                                                               configuration_id_              => configuration_id_temp_,
                                                               exclude_customer_owned_stock_  => 'TRUE',
                                                               exclude_supplier_loaned_stock_ => 'TRUE',
                                                               exclude_supplier_owned_stock_  => 'TRUE',
                                                               exclude_supplier_rented_stock_ => 'TRUE',
                                                               exclude_company_rental_stock_  => 'TRUE' ) THEN 
            standard_cost_exist_ := TRUE;
         ELSE
            company_owned_trans_exist_ := Inventory_Transaction_Hist_API.Trans_With_Ownership_Exist(
                                                                  contract_                      => contract_,
                                                                  part_no_                       => part_no_,
                                                                  configuration_id_              => configuration_id_temp_,
                                                                  lot_batch_no_                  => NULL,
                                                                  serial_no_                     => NULL,
                                                                  include_customer_owned_        => FALSE,
                                                                  include_supplier_loaned_       => FALSE,
                                                                  include_supplier_owned_        => FALSE,
                                                                  include_supplier_consignment_  => TRUE,
                                                                  include_company_owned_         => TRUE,
                                                                  include_supplier_rented_       => FALSE,
                                                                  include_company_rental_asset_  => FALSE,
                                                                  include_plus_direction_        => TRUE,
                                                                  include_minus_direction_       => FALSE,
                                                                  include_zero_direction_        => FALSE,
                                                                  include_reversed_transactions_ => FALSE);
   
            IF (company_owned_trans_exist_) THEN
               standard_cost_exist_ := TRUE;
            END IF;   
         END IF;
      END IF;
   END IF;

   RETURN (standard_cost_exist_);
END Part_Config_Std_Cost_Exist___;


PROCEDURE Raise_Value_Method_Error___
IS
BEGIN

   Error_SYS.Record_General(lu_name_, 'VALUEMETERROR: This operation is only allowed when the inventory valuation method is :P1 or :P2.',Inventory_Value_Method_API.Decode('ST'),Inventory_Value_Method_API.Decode('AV'));
END Raise_Value_Method_Error___;


PROCEDURE Raise_Value_Method_Not_Supp___ (
   inventory_valuation_method_db_ IN VARCHAR2 )
IS
BEGIN

   Error_SYS.Record_General(lu_name_, 'INVVALMETERR: Inventory Valuation Method :P1 is not supported in this operation.', Inventory_Value_Method_API.Decode(inventory_valuation_method_db_));
END Raise_Value_Method_Not_Supp___;


PROCEDURE Raise_Cost_Level_Not_Supp___ (
   inventory_part_cost_level_db_ IN VARCHAR2 )
IS
BEGIN

   Error_SYS.Record_General(lu_name_, 'LEVELNOTSUPP: Inventory Part Cost Level :P1 is not supported in this operation.',Inventory_Part_Cost_Level_API.Decode(inventory_part_cost_level_db_));
END Raise_Cost_Level_Not_Supp___;


FUNCTION Get_Buyer_Code___ (
   contract_           IN VARCHAR2,
   part_no_            IN VARCHAR2,
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   stmt_       VARCHAR2(500);
   buyer_code_ VARCHAR2(20);
BEGIN

   stmt_ := 'BEGIN '                                                                    ||
               ':buyer_code := Purchase_Buyer_API.Get_Buyer_Code(:contract, '           ||
                                                                ':part_no_, '           || 
                                                                ':source_ref1, '        ||
                                                                ':source_ref2, '        ||
                                                                ':source_ref3, '        ||
                                                                ':source_ref_type_db); '||
            'END; ';

   @ApproveDynamicStatement(2008-04-28,RoJalk)
   EXECUTE IMMEDIATE stmt_ USING OUT buyer_code_,
                                 IN  contract_,
                                 IN  part_no_,
                                 IN  source_ref1_,
                                 IN  source_ref2_,
                                 IN  source_ref3_,
                                 IN  source_ref_type_db_;
   RETURN (buyer_code_);
END Get_Buyer_Code___;


FUNCTION Get_Requisitioner_Code___ (
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   stmt_               VARCHAR2(500);
   requisitioner_code_ VARCHAR2(20);
BEGIN
   stmt_ := 'BEGIN '                                                                              ||
               ':requisitioner_code := Requisitioner_API.Get_Requisitioner_Code( '                ||
                                                                         ':source_ref1, '         ||
                                                                         ':source_ref2, '         ||
                                                                         ':source_ref3, '         ||
                                                                         ':source_ref_type_db); ' ||
            'END;';

   @ApproveDynamicStatement(2008-05-07,RoJalk)
   EXECUTE IMMEDIATE stmt_ USING OUT requisitioner_code_,
                                 IN  source_ref1_,
                                 IN  source_ref2_,
                                 IN  source_ref3_,
                                 IN  source_ref_type_db_;
   RETURN (requisitioner_code_);
END Get_Requisitioner_Code___;


FUNCTION Get_Accounting_Year___ (
   contract_ IN VARCHAR2,
   company_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   user_group_          VARCHAR2(20);
   accounting_year_     VARCHAR2(4);
   dummy_               NUMBER;
   use_accounting_year_ VARCHAR2(5);
BEGIN
   use_accounting_year_ := Company_Distribution_Info_API.Get_Use_Accounting_Year_Db(company_);

   IF (use_accounting_year_ = 'TRUE') THEN
      user_group_ := User_Group_Member_Finance_API.Get_User_Group(company_,
                                                                  Fnd_Session_API.Get_Fnd_User);
      Accounting_Period_API.Get_Accounting_Year(accounting_year_,
                                                dummy_,
                                                company_,
                                                TRUNC(Site_API.Get_Site_Date(contract_)),
                                                user_group_);
   ELSE
      accounting_year_ := '*';
   END IF;

   RETURN (accounting_year_);
END Get_Accounting_Year___;


PROCEDURE Enable_Cost_Details___ (
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   configuration_id_    IN VARCHAR2,
   lot_batch_no_        IN VARCHAR2,
   serial_no_           IN VARCHAR2,
   sequence_no_         IN NUMBER,
   inventory_part_rec_  IN Inventory_Part_API.Public_Rec )
IS
   old_cost_detail_tab_ Cost_Detail_Tab;
   new_cost_detail_tab_ Cost_Detail_Tab;
   old_total_unit_cost_ NUMBER;
   exit_procedure_      EXCEPTION;
BEGIN

   IF (inventory_part_rec_.inventory_valuation_method IN ('FIFO','LIFO')) THEN
      old_cost_detail_tab_ := Inventory_Part_Fifo_Detail_API.Get_Cost_Details_And_Lock(
                                                                                     contract_,
                                                                                     part_no_,
                                                                                     sequence_no_);
   ELSE
      old_cost_detail_tab_ := Get_Cost_Details_And_Lock___(contract_,
                                                           part_no_,
                                                           configuration_id_,
                                                           lot_batch_no_,
                                                           serial_no_);
   END IF;

   IF (Non_Star_Cost_Bucket_Exist(old_cost_detail_tab_)) THEN
      RAISE exit_procedure_;
   END IF;

   old_total_unit_cost_ := Get_Total_Unit_Cost(old_cost_detail_tab_);

   IF (old_total_unit_cost_ = 0) THEN
      RAISE exit_procedure_;
   END IF;

   new_cost_detail_tab_ := Generate_New_Cost_Details___(old_total_unit_cost_,
                                                        FALSE,
                                                        contract_,
                                                        part_no_,
                                                        configuration_id_,
                                                        inventory_part_rec_ );

   IF (inventory_part_rec_.inventory_valuation_method IN ('FIFO','LIFO')) THEN

      Inventory_Part_Fifo_Detail_API.Modify_Cost_Details(contract_,
                                                         part_no_,
                                                         sequence_no_,
                                                         old_cost_detail_tab_,
                                                         new_cost_detail_tab_);
   ELSE
      Modify_Cost_Details___(new_cost_detail_tab_,
                             old_cost_detail_tab_,
                             contract_,
                             part_no_,
                             configuration_id_,
                             lot_batch_no_,
                             serial_no_,
                             inventory_part_rec_.zero_cost_flag,
                             inventory_part_rec_.inventory_part_cost_level,
                             inventory_part_rec_.inventory_valuation_method);
   END IF;
EXCEPTION
   WHEN exit_procedure_ THEN
      NULL;
END Enable_Cost_Details___;


-- Check_Delete_From_Client___
--   Validates if it is ok for the user to delete one record in the LU
PROCEDURE Check_Delete_From_Client___ (
   remrec_ IN INVENTORY_PART_UNIT_COST_TAB%ROWTYPE )
IS
   lot_batch_no_          INVENTORY_PART_UNIT_COST_TAB.lot_batch_no%TYPE;
   serial_no_             INVENTORY_PART_UNIT_COST_TAB.serial_no%TYPE;
   configuration_id_      INVENTORY_PART_UNIT_COST_TAB.configuration_id%TYPE;
BEGIN

   IF ((remrec_.lot_batch_no = '*') AND
       (remrec_.serial_no    = '*')) THEN
      lot_batch_no_ := NULL;
      serial_no_    := NULL;
   ELSE
      lot_batch_no_ := remrec_.lot_batch_no;
      serial_no_    := remrec_.serial_no;
   END IF;

   IF (remrec_.configuration_id = '*') THEN
      configuration_id_ := NULL;
   ELSE
      configuration_id_ := remrec_.configuration_id;
   END IF;
   -- EBALL-37, Modified method call to use the fully encapsulated method from Invent_Part_Quantity_Util_API.
   IF (Invent_Part_Quantity_Util_API.Check_Quantity_Exist(remrec_.contract,
                                                          remrec_.part_no,
                                                          configuration_id_,
                                                          lot_batch_no_,
                                                          serial_no_)) THEN
      Error_SYS.Record_General(lu_name_, 'ILLEGALDELETE: The unit cost record for part :P1 on site :P2 must not be deleted.',remrec_.part_no, remrec_.contract);
   END IF;
END Check_Delete_From_Client___;


FUNCTION Overhead_Cost_Bucket_Type___ (
   cost_bucket_type_db_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   overhead_cost_bucket_type_ BOOLEAN := FALSE;
BEGIN

   IF (cost_bucket_type_db_ IN ('GENERAL','DELOH','MATOH','LABOROH','MACH1','MACH2',
                                'SUBCONTRACTING OH','SALESOH')) THEN
      overhead_cost_bucket_type_ := TRUE;
   END IF;

   RETURN (overhead_cost_bucket_type_);
END Overhead_Cost_Bucket_Type___;


FUNCTION Generate_Cost_Details___ (
   cost_detail_tab_       IN Cost_Detail_Tab,
   unit_cost_             IN NUMBER,
   unit_cost_is_material_ IN BOOLEAN,
   company_               IN VARCHAR2,
   contract_              IN VARCHAR2,
   part_no_               IN VARCHAR2,
   configuration_id_      IN VARCHAR2,
   source_ref1_           IN VARCHAR2,
   source_ref2_           IN VARCHAR2,
   source_ref3_           IN VARCHAR2,
   source_ref4_           IN NUMBER,
   source_ref_type_db_    IN VARCHAR2,
   cost_source_date_      IN DATE,
   inventory_part_rec_    IN Inventory_Part_API.Public_Rec,
   trans_quantity_        IN NUMBER,
   vendor_no_             IN VARCHAR2 ) RETURN Cost_Detail_Tab
IS
   first_cost_detail_tab_  Cost_Detail_Tab;
   second_cost_detail_tab_ Cost_Detail_Tab;
   total_cost_detail_tab_  Cost_Detail_Tab;
BEGIN

   IF (cost_detail_tab_.COUNT > 0) THEN
      first_cost_detail_tab_ := Merge_And_Complete_Details(cost_detail_tab_,
                                                           inventory_part_rec_,
                                                           contract_,
                                                           part_no_,
                                                           company_,
                                                           '*',
                                                           source_ref1_,
                                                           source_ref2_,
                                                           source_ref3_,
                                                           source_ref4_,
                                                           source_ref_type_db_,
                                                           cost_source_date_);
   END IF;

   IF (unit_cost_ IS NOT NULL) THEN
      second_cost_detail_tab_ := Generate_New_Cost_Details___(unit_cost_,
                                                              unit_cost_is_material_,
                                                              contract_,
                                                              part_no_,
                                                              configuration_id_,
                                                              inventory_part_rec_,
                                                              source_ref1_,
                                                              source_ref2_,
                                                              source_ref3_,
                                                              source_ref4_,
                                                              source_ref_type_db_,
                                                              cost_source_date_,
                                                              trans_quantity_,
                                                              vendor_no_);
   END IF;

   IF (first_cost_detail_tab_.COUNT = 0) THEN
      total_cost_detail_tab_ := second_cost_detail_tab_;
   ELSIF (second_cost_detail_tab_.COUNT = 0) THEN
      total_cost_detail_tab_ := first_cost_detail_tab_;
   ELSE
      total_cost_detail_tab_ := Add_To_Value_Detail_Tab(first_cost_detail_tab_,
                                                        second_cost_detail_tab_,
                                                        1);
   END IF;

   RETURN (total_cost_detail_tab_);
END Generate_Cost_Details___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);

   Client_SYS.Add_To_Attr('INVENTORY_VALUE', 0, attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT INVENTORY_PART_UNIT_COST_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN

   IF (newrec_.cost_bucket_id != '*') THEN
      newrec_.cost_bucket_public_type := Get_Cost_Bucket_Type_Db___(newrec_.contract,
                                                                    newrec_.cost_bucket_id);
   END IF;

   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN INVENTORY_PART_UNIT_COST_TAB%ROWTYPE,
   del_from_client_ IN BOOLEAN  DEFAULT TRUE)
IS
BEGIN
   IF del_from_client_ THEN
      Check_Delete_From_Client___(remrec_);
   END IF;
   super(remrec_);
END Check_Delete___;


PROCEDURE Manage_Part_Config_Std_Cost___ (
   cost_detail_tab_    IN OUT Cost_Detail_Tab,
   unit_cost_          IN     NUMBER,
   contract_           IN     VARCHAR2,
   part_no_            IN     VARCHAR2,
   configuration_id_   IN     VARCHAR2,
   inventory_part_rec_ IN     Inventory_Part_API.Public_Rec,
   source_ref1_        IN     VARCHAR2,
   source_ref2_        IN     VARCHAR2,
   source_ref3_        IN     VARCHAR2,
   source_ref4_        IN     NUMBER,
   source_ref_type_db_ IN     VARCHAR2,
   company_            IN     VARCHAR2,
   put_to_transit_     IN     BOOLEAN )
IS
   configuration_id_temp_         INVENTORY_PART_UNIT_COST_TAB.configuration_id%TYPE;
   cost_detail_temp_tab_          Cost_Detail_Tab;
   old_cost_detail_tab_           Cost_Detail_Tab;
   exit_procedure_                EXCEPTION;
   company_owned_trans_exist_     BOOLEAN;
   std_cost_established_          VARCHAR2(5) := 'FALSE';
   preserve_established_std_cost_ BOOLEAN := TRUE;

   CURSOR get_configurations (contract_         IN VARCHAR2,
                              part_no_          IN VARCHAR2,
                              configuration_id_ IN VARCHAR2) IS
      SELECT DISTINCT configuration_id
        FROM INVENTORY_PART_UNIT_COST_TAB
       WHERE  contract         = contract_
         AND  part_no          = part_no_
         AND (configuration_id = configuration_id_ OR configuration_id_ IS NULL);
BEGIN
   --  There always exists a record for each configuration in this table. They are
   --  created when the configuration gets created in InventoryPartConfig.

   IF (inventory_part_rec_.inventory_part_cost_level = 'COST PER PART') THEN
      configuration_id_temp_ := NULL;
   ELSE
      configuration_id_temp_ := configuration_id_;
      IF ((put_to_transit_) AND (inventory_part_rec_.reset_config_std_cost = Fnd_Boolean_API.DB_TRUE)) THEN
         -- We are receiving a configuration with cost level COST PER CONFIGURATION into transit from a
         -- supply site within the same company. The setting on the part indicates that the configuration
         -- cost sent from the supply site should be used to establish a new standard cost for the configuration
         -- in case that we currently don't have any company owned stock of this configuration, regardless if
         -- there is an existing standard cost and/or old transactions for this configuration.
         preserve_established_std_cost_ := FALSE;
      END IF;
   END IF;

   cost_detail_temp_tab_ := Get_Cost_Detail_Tab___(contract_,
                                                   part_no_,
                                                   NVL(configuration_id_temp_,'*'),
                                                   '*',
                                                   '*');

   IF (preserve_established_std_cost_) THEN
      IF (Non_Zero_Cost_Detail_Exist(cost_detail_temp_tab_)) THEN
         cost_detail_tab_ := cost_detail_temp_tab_;
         RAISE exit_procedure_;
      END IF;

      $IF (Component_Cost_SYS.INSTALLED) $THEN
         std_cost_established_ := Part_Cost_History_API.Check_Std_Cost_Established(contract_,
                                                                                   part_no_,
                                                                                   configuration_id_); 

         IF (std_cost_established_ = 'TRUE') THEN
            cost_detail_tab_ := cost_detail_temp_tab_;
            RAISE exit_procedure_;
         END IF;
      $END
   END IF;
   
   -- Added Rental parameters
   -- EBALL-37, Modified method call to use the fully encapsulated method from Invent_Part_Quantity_Util_API. 
   IF (Invent_Part_Quantity_Util_API.Check_Quantity_Exist(contract_                      => contract_,
                                                          part_no_                       => part_no_,
                                                          configuration_id_              => configuration_id_temp_,
                                                          exclude_customer_owned_stock_  => 'TRUE',
                                                          exclude_supplier_loaned_stock_ => 'TRUE',
                                                          exclude_supplier_owned_stock_  => 'TRUE',
                                                          exclude_supplier_rented_stock_ => 'TRUE',
                                                          exclude_company_rental_stock_  => 'TRUE' )) THEN   
      cost_detail_tab_ := cost_detail_temp_tab_;
      RAISE exit_procedure_;
   END IF;
   
   IF (preserve_established_std_cost_) THEN
      company_owned_trans_exist_ := Inventory_Transaction_Hist_API.Trans_With_Ownership_Exist(
                                                             contract_                      => contract_,
                                                             part_no_                       => part_no_,
                                                             configuration_id_              => configuration_id_temp_,
                                                             lot_batch_no_                  => NULL,
                                                             serial_no_                     => NULL,
                                                             include_customer_owned_        => FALSE,
                                                             include_supplier_loaned_       => FALSE,
                                                             include_supplier_owned_        => FALSE,
                                                             include_supplier_consignment_  => TRUE,
                                                             include_company_owned_         => TRUE,
                                                             include_supplier_rented_       => FALSE,
                                                             include_company_rental_asset_  => FALSE,
                                                             include_plus_direction_        => TRUE,
                                                             include_minus_direction_       => FALSE,
                                                             include_zero_direction_        => FALSE,
                                                             include_reversed_transactions_ => FALSE);
      IF (company_owned_trans_exist_) THEN
         cost_detail_tab_ := cost_detail_temp_tab_;
         RAISE exit_procedure_;
      END IF;
   END IF;

   cost_detail_tab_ := Generate_Cost_Details___(cost_detail_tab_,
                                                unit_cost_,
                                                TRUE,
                                                company_,
                                                contract_,
                                                part_no_,
                                                configuration_id_,
                                                source_ref1_,
                                                source_ref2_,
                                                source_ref3_,
                                                source_ref4_,
                                                source_ref_type_db_,
                                                NULL,
                                                inventory_part_rec_,
                                                NULL,
                                                NULL);

   FOR config_rec_ IN get_configurations(contract_,
                                         part_no_,
                                         configuration_id_temp_) LOOP

      old_cost_detail_tab_ := Get_Cost_Details_And_Lock___(contract_,
                                                           part_no_,
                                                           config_rec_.configuration_id,
                                                           '*',
                                                           '*');
      Modify_Cost_Details___(cost_detail_tab_,
                             old_cost_detail_tab_,
                             contract_,
                             part_no_,
                             config_rec_.configuration_id,
                             '*',
                             '*',
                             inventory_part_rec_.zero_cost_flag,
                             inventory_part_rec_.inventory_part_cost_level,
                             inventory_part_rec_.inventory_valuation_method);

      Modify_Estimated_Mtrl_Cost___(contract_,
                                    part_no_,
                                    config_rec_.configuration_id,
                                    cost_detail_tab_,
                                    inventory_part_rec_.lead_time_code);
   END LOOP;
EXCEPTION
   WHEN exit_procedure_ THEN
      NULL;
END Manage_Part_Config_Std_Cost___;


PROCEDURE New___ (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   accounting_year_  IN VARCHAR2,
   cost_bucket_id_   IN VARCHAR2,
   company_          IN VARCHAR2,
   cost_source_id_   IN VARCHAR2,
   unit_cost_        IN NUMBER )
IS
   save_new_record_ BOOLEAN;
   attr_            VARCHAR2(2000);
   newrec_          INVENTORY_PART_UNIT_COST_TAB%ROWTYPE;
   objid_           INVENTORY_PART_UNIT_COST.objid%TYPE;
   objversion_      INVENTORY_PART_UNIT_COST.objversion%TYPE;
   indrec_          Indicator_Rec;
BEGIN

   IF (unit_cost_ = 0) THEN
      IF ((accounting_year_ = '*')  AND
          (cost_bucket_id_  = '*')  AND
          (cost_source_id_  = '*')) THEN
         save_new_record_ := TRUE;
      ELSE
         save_new_record_ := FALSE;
      END IF;
   ELSE
      save_new_record_ := TRUE;
   END IF;

   IF (save_new_record_) THEN
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('CONTRACT'         ,contract_         ,attr_);
      Client_SYS.Add_To_Attr('PART_NO'          ,part_no_          ,attr_);
      Client_SYS.Add_To_Attr('CONFIGURATION_ID' ,configuration_id_ ,attr_);
      Client_SYS.Add_To_Attr('LOT_BATCH_NO'     ,lot_batch_no_     ,attr_);
      Client_SYS.Add_To_Attr('SERIAL_NO'        ,serial_no_        ,attr_);
      Client_SYS.Add_To_Attr('ACCOUNTING_YEAR'  ,accounting_year_  ,attr_);
      Client_SYS.Add_To_Attr('COST_BUCKET_ID'   ,cost_bucket_id_   ,attr_);
      Client_SYS.Add_To_Attr('COMPANY'          ,company_          ,attr_);
      Client_SYS.Add_To_Attr('COST_SOURCE_ID'   ,cost_source_id_   ,attr_);
      Client_SYS.Add_To_Attr('INVENTORY_VALUE'  ,unit_cost_        ,attr_);

      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);
   END IF;
END New___;


FUNCTION Get_Details_From_Costing___ (
   contract_              IN VARCHAR2,
   part_no_               IN VARCHAR2,
   configuration_id_      IN VARCHAR2,
   unit_cost_             IN NUMBER,
   unit_cost_is_material_ IN BOOLEAN,
   source_ref_type_db_    IN VARCHAR2,
   vendor_no_             IN VARCHAR2 DEFAULT NULL,
   order_size_            IN NUMBER DEFAULT NULL ) RETURN Cost_Detail_Tab
IS
   cost_detail_tab_          Cost_Detail_Tab;
   stmt_                     VARCHAR2(500);
   local_source_ref_type_db_ VARCHAR2(100);
   char_null_                VARCHAR2(12) := 'VARCHAR2NULL';
BEGIN
   IF (unit_cost_is_material_) THEN
      IF (NVL(source_ref_type_db_, char_null_) IN ('PUR REQ', 'PROJECT', 'CUST ORDER', 'WORK ORDER', 'WORK_TASK', 'PUR ORDER CHG ORDER')) THEN
         local_source_ref_type_db_ := 'PUR ORDER';
      ELSE
         local_source_ref_type_db_ := source_ref_type_db_;
      END IF;

      stmt_ := 'DECLARE '                                                                              ||
                  'cost_detail_tab_ Inventory_Part_Unit_Cost_API.Cost_Detail_Tab; '                    ||
               'BEGIN '                                                                                ||
                  'cost_detail_tab_ := '                                                               ||
                          'Standard_Cost_Bucket_API.Split_Unit_Cost_Into_Buckets( '                    ||
                                                                        ':contract, '                  ||
                                                                        ':part_no, '                   ||
                                                                        ':unit_cost, '                 ||
                                                                        ':local_source_ref_type_db, '  ||
                                                                        ':order_size, '                ||
                                                                        ':vendor_no); '                ||       
                  'Inventory_Part_Unit_Cost_API.Fill_Temporary_Table__(cost_detail_tab_); '            ||
               'END;';

      @ApproveDynamicStatement(2007-01-24,ersrlk)
      EXECUTE IMMEDIATE stmt_ USING IN contract_,
                                    IN part_no_,
                                    IN unit_cost_,
                                    IN local_source_ref_type_db_,
                                    IN order_size_,
                                    IN vendor_no_;
   ELSE
      stmt_ := 'DECLARE '                                                                   ||
                  'cost_detail_tab_ Inventory_Part_Unit_Cost_API.Cost_Detail_Tab; '         ||
               'BEGIN '                                                                     ||
                  'cost_detail_tab_ := '                                                    ||
                          'Part_Cost_Sim_API.Split_Cost_Into_Buckets(:contract, '           ||
                                                                    ':part_no, '            ||
                                                                    ':configuration_id, '   ||
                                                                    ':unit_cost); '         ||
                  'Inventory_Part_Unit_Cost_API.Fill_Temporary_Table__(cost_detail_tab_); ' ||
               'END;';

      @ApproveDynamicStatement(2006-01-23,nidalk)
      EXECUTE IMMEDIATE stmt_ USING IN contract_,
                                    IN part_no_,
                                    IN configuration_id_,
                                    IN unit_cost_;
   END IF;

   cost_detail_tab_ := Get_From_Temporary_Table__;

   RETURN (cost_detail_tab_);
END Get_Details_From_Costing___;


FUNCTION Complete_Cost_Details___ (
   cost_detail_tab_    IN Cost_Detail_Tab,
   inventory_part_rec_ IN Inventory_Part_API.Public_Rec,
   contract_           IN VARCHAR2,
   part_no_            IN VARCHAR2,
   company_            IN VARCHAR2,
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN NUMBER,
   source_ref_type_db_ IN VARCHAR2,
   cost_source_date_   IN DATE ) RETURN Cost_Detail_Tab
IS
   cost_detail_temp_tab_          Cost_Detail_Tab;
   buyer_code_                    VARCHAR2(20);
   requisitioner_code_            VARCHAR2(20);
   accounting_year_               INVENTORY_PART_UNIT_COST_TAB.accounting_year%TYPE;
   fetched_accounting_year_       INVENTORY_PART_UNIT_COST_TAB.accounting_year%TYPE;
   accounting_year_fetched_       BOOLEAN := FALSE;
   purchase_info_fetched_         BOOLEAN := FALSE;
   material_cost_source_decided_  BOOLEAN := FALSE;
   deliv_oh_cost_source_decided_  BOOLEAN := FALSE;
   variable_material_cost_source_ BOOLEAN := FALSE;
   variable_deliv_oh_cost_source_ BOOLEAN := FALSE;
   mtrl_oh_cost_source_fetched_   BOOLEAN := FALSE;
   sales_oh_cost_source_fetched_  BOOLEAN := FALSE;
   cost_bucket_type_db_           VARCHAR2(20);
   material_cost_source_id_       INVENTORY_PART_UNIT_COST_TAB.cost_source_id%TYPE;
   delivery_oh_cost_source_id_    INVENTORY_PART_UNIT_COST_TAB.cost_source_id%TYPE;
   material_oh_cost_source_id_    INVENTORY_PART_UNIT_COST_TAB.cost_source_id%TYPE;
   sales_oh_cost_source_id_       INVENTORY_PART_UNIT_COST_TAB.cost_source_id%TYPE;
   cost_source_id_                INVENTORY_PART_UNIT_COST_TAB.cost_source_id%TYPE;
   std_cost_per_part_or_config_   BOOLEAN := FALSE;
   char_null_                     VARCHAR2(12) := 'VARCHAR2NULL';
BEGIN
   cost_detail_temp_tab_ := cost_detail_tab_;

   IF ((inventory_part_rec_.inventory_valuation_method = 'ST') AND
       (inventory_part_rec_.inventory_part_cost_level IN ('COST PER PART',
                                                          'COST PER CONFIGURATION'))) THEN
      std_cost_per_part_or_config_ := TRUE;
   END IF;

   IF (NVL(source_ref_type_db_, char_null_) IN ('PUR ORDER','PUR REQ','PROJECT','CUST ORDER', 'WORK ORDER', 'WORK_TASK', 'PUR ORDER CHG ORDER', 'INTER_COMPANY_MOVE')) THEN
      variable_material_cost_source_ := TRUE;
      variable_deliv_oh_cost_source_ := TRUE;
   END IF;

   FOR i IN cost_detail_temp_tab_.FIRST..cost_detail_temp_tab_.LAST LOOP
      IF ((cost_detail_temp_tab_(i).cost_bucket_id = '*') OR
          (std_cost_per_part_or_config_)) THEN

         cost_source_id_  := '*';
         accounting_year_ := '*';
      ELSE
         IF ((cost_detail_temp_tab_(i).cost_source_id  IS NULL) OR
             (cost_detail_temp_tab_(i).accounting_year IS NULL)) THEN
            cost_bucket_type_db_ := Get_Cost_Bucket_Type_Db___(
                                                          cost_detail_temp_tab_(i).contract,
                                                          cost_detail_temp_tab_(i).cost_bucket_id);
         END IF;

         IF (cost_detail_temp_tab_(i).accounting_year IS NULL) THEN
            IF (Overhead_Cost_Bucket_Type___(cost_bucket_type_db_)) THEN
               IF NOT (accounting_year_fetched_) THEN
                  fetched_accounting_year_ := Get_Accounting_Year___(contract_, company_);
                  accounting_year_fetched_ := TRUE;
               END IF;
               accounting_year_ := fetched_accounting_year_;
            ELSE
               accounting_year_ := '*';
            END IF;
         END IF;

         IF (cost_detail_temp_tab_(i).cost_source_id  IS NULL) THEN
            IF (cost_bucket_type_db_ = 'MATERIAL') THEN
               IF NOT (material_cost_source_decided_) THEN
                  IF (variable_material_cost_source_) THEN
                     IF NOT (purchase_info_fetched_) THEN
                        buyer_code_ := Get_Buyer_Code___(contract_,
                                                         part_no_,
                                                         source_ref1_,
                                                         source_ref2_,
                                                         source_ref3_,
                                                         source_ref_type_db_);

                        requisitioner_code_ := Get_Requisitioner_Code___(source_ref1_,
                                                                         source_ref2_,
                                                                         source_ref3_,
                                                                         source_ref_type_db_);
                        purchase_info_fetched_ := TRUE;
                     END IF;
                     material_cost_source_id_ :=
                                 Cost_Type_Source_Indicator_API.Get_Material_Cost_Source(
                                                                               contract_,
                                                                               company_,
                                                                               buyer_code_,
                                                                               requisitioner_code_,
                                                                               part_no_,
                                                                               cost_source_date_);
                  ELSE
                     material_cost_source_id_ := '*';
                  END IF;
                  material_cost_source_decided_ := TRUE;
               END IF;
               cost_source_id_ := material_cost_source_id_;
            ELSIF (cost_bucket_type_db_ = 'DELOH') THEN
               IF NOT (deliv_oh_cost_source_decided_) THEN
                  IF (variable_deliv_oh_cost_source_) THEN
                     IF NOT (purchase_info_fetched_) THEN
                        buyer_code_ := Get_Buyer_Code___(contract_,
                                                         part_no_,
                                                         source_ref1_,
                                                         source_ref2_,
                                                         source_ref3_,
                                                         source_ref_type_db_);

                        requisitioner_code_ := Get_Requisitioner_Code___(source_ref1_,
                                                                         source_ref2_,
                                                                         source_ref3_,
                                                                         source_ref_type_db_);
                        purchase_info_fetched_ := TRUE;
                     END IF;
                     delivery_oh_cost_source_id_ :=
                              Cost_Type_Source_Indicator_API.Get_Delivery_Oh_Cost_Source(
                                                                               contract_,
                                                                               company_,
                                                                               buyer_code_,
                                                                               requisitioner_code_,
                                                                               part_no_,
                                                                               cost_source_date_);
                  ELSE
                     delivery_oh_cost_source_id_ := '*';
                  END IF;
                  deliv_oh_cost_source_decided_ := TRUE;
               END IF;
               cost_source_id_  := delivery_oh_cost_source_id_;
            ELSIF (cost_bucket_type_db_ = 'MATOH') THEN
               IF NOT (mtrl_oh_cost_source_fetched_) THEN
                  material_oh_cost_source_id_ :=
                             Cost_Type_Source_Indicator_API.Get_Material_Oh_Cost_Source(
                                                                                contract_,
                                                                                part_no_,
                                                                                cost_source_date_);
                  mtrl_oh_cost_source_fetched_ := TRUE;
               END IF;
               cost_source_id_  := material_oh_cost_source_id_;
            ELSIF (cost_bucket_type_db_ = 'SALESOH') THEN
               IF NOT (sales_oh_cost_source_fetched_) THEN
                  sales_oh_cost_source_id_ :=
                             Cost_Type_Source_Indicator_API.Get_Sales_Oh_Cost_Source(contract_,
                                                                                     part_no_,
                                                                                     cost_source_date_);
                  sales_oh_cost_source_fetched_ := TRUE;
               END IF;
               cost_source_id_  := sales_oh_cost_source_id_;
            ELSE
               cost_source_id_  := '*';
            END IF;
         END IF;
      END IF;

      IF (cost_detail_temp_tab_(i).company IS NULL) THEN
         cost_detail_temp_tab_(i).company := company_;
      END IF;
      IF (cost_detail_temp_tab_(i).cost_source_id IS NULL) THEN
         cost_detail_temp_tab_(i).cost_source_id  := cost_source_id_;
      END IF;
      IF (cost_detail_temp_tab_(i).accounting_year IS NULL) THEN
         cost_detail_temp_tab_(i).accounting_year := accounting_year_;
      END IF;
   END LOOP;

   RETURN (cost_detail_temp_tab_);
END Complete_Cost_Details___;


-- Get_Default_Part_Details___
--   Returns a cost detail tab containing data for a part.
FUNCTION Get_Default_Part_Details___ (
   contract_          IN VARCHAR2,
   part_no_           IN VARCHAR2,
   calling_process_   IN VARCHAR2,
   zero_cost_flag_db_ IN VARCHAR2 ) RETURN Cost_Detail_Tab
IS
   cost_detail_tab_            Cost_Detail_Tab;
   company_owned_stock_exists_ BOOLEAN := FALSE;
BEGIN
   cost_detail_tab_ := Get_Cost_Details_By_Method(contract_,
                                                  part_no_,
                                                  '*',
                                                  '*',
                                                  '*');

   IF NOT (Non_Zero_Cost_Detail_Exist(cost_detail_tab_)) THEN
      -- The cost that we have stored for the part is zero. If Zero cost is allowed for the part then it might be so that
      -- there exist actually company owned stock for the part and then we can conclude that the cost is zero.
      -- but if there is no company owned stock for the part then we must go and look at the transactions.
      IF (zero_cost_flag_db_ = 'Y') THEN
         company_owned_stock_exists_ := Invent_Part_Quantity_Util_API.Check_Quantity_Exist(
                                                                    contract_                      => contract_,
                                                                    part_no_                       => part_no_,
                                                                    configuration_id_              => NULL,
                                                                    exclude_customer_owned_stock_  => 'TRUE',
                                                                    exclude_supplier_loaned_stock_ => 'TRUE',
                                                                    exclude_supplier_owned_stock_  => 'TRUE',
                                                                    exclude_supplier_rented_stock_ => 'TRUE',
                                                                    exclude_company_rental_stock_  => 'TRUE');
      END IF;
      -- Added a condition to check for the existence of the company owned stock for the part.
      IF NOT (company_owned_stock_exists_) THEN     
         cost_detail_tab_ := Get_Details_From_Last_Trans___(contract_,
                                                            part_no_,
                                                            NULL,
                                                            NULL,
                                                            NULL,
                                                            NULL,
                                                            calling_process_,
                                                            TRUE);
      END IF;
   END IF;

   RETURN (cost_detail_tab_);
END Get_Default_Part_Details___;


-- Get_Default_Config_Details___
--   Returns a cost detail tab containing data for a part.
FUNCTION Get_Default_Config_Details___ (
   contract_          IN VARCHAR2,
   part_no_           IN VARCHAR2,
   configuration_id_  IN VARCHAR2,
   calling_process_   IN VARCHAR2,
   zero_cost_flag_db_ IN VARCHAR2 ) RETURN Cost_Detail_Tab
IS
   cost_detail_tab_            Cost_Detail_Tab;
   company_owned_stock_exists_ BOOLEAN := FALSE;
BEGIN
   cost_detail_tab_ := Get_Cost_Details_By_Method(contract_,
                                                  part_no_,
                                                  configuration_id_,
                                                  '*',
                                                  '*');

   IF NOT (Non_Zero_Cost_Detail_Exist(cost_detail_tab_)) THEN
      -- The cost that we have stored for the configuration is zero, or we have no cost stored at all.
      -- If Zero cost is allowed for the part then it might be so that there exist actually company owned stock
      -- for the configuration and then we can conclude that the cost is zero.
      -- but if there is no company owned stock for the configuration then we must go and look at the transactions.
      IF (zero_cost_flag_db_ = 'Y') THEN
         company_owned_stock_exists_ := Invent_Part_Quantity_Util_API.Check_Quantity_Exist(
                                                                    contract_                      => contract_,
                                                                    part_no_                       => part_no_,
                                                                    configuration_id_              => configuration_id_,
                                                                    exclude_customer_owned_stock_  => 'TRUE',
                                                                    exclude_supplier_loaned_stock_ => 'TRUE',
                                                                    exclude_supplier_owned_stock_  => 'TRUE',
                                                                    exclude_supplier_rented_stock_ => 'TRUE',
                                                                    exclude_company_rental_stock_  => 'TRUE');
      END IF;
      
      -- Added condition to check for the existence of the company owned stock for the part.
      IF NOT (company_owned_stock_exists_) THEN     
         cost_detail_tab_ := Get_Details_From_Last_Trans___(contract_,
                                                            part_no_,
                                                            configuration_id_,
                                                            NULL,
                                                            NULL,
                                                            NULL,
                                                            calling_process_,
                                                            TRUE);
      END IF;
   END IF;

   RETURN (cost_detail_tab_);
END Get_Default_Config_Details___;


FUNCTION Get_Default_Cond_Details___ (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   condition_code_   IN VARCHAR2,
   calling_process_  IN VARCHAR2 ) RETURN Cost_Detail_Tab
IS
   cost_detail_tab_          Cost_Detail_Tab;
   estimated_condition_cost_ NUMBER;
BEGIN

   IF (condition_code_ IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'CONDNOVALUE: Condition Code must have a value.');
   END IF;

   IF (calling_process_ IN ('WORK ORDER RECEIPT', 'CRO CONFIRMATION')) THEN
      estimated_condition_cost_ := Inv_Part_Config_Condition_API.Get_Estimated_Cost(
                                                                                condition_code_,
                                                                                contract_,
                                                                                part_no_,
                                                                                configuration_id_);
      IF (estimated_condition_cost_ IS NOT NULL ) THEN
         cost_detail_tab_ := Generate_New_Cost_Details___(
                                                       estimated_condition_cost_,
                                                       FALSE,
                                                       contract_,
                                                       part_no_,
                                                       configuration_id_,
                                                       Inventory_Part_API.Get(contract_, part_no_));
      END IF;
   END IF;

   IF (cost_detail_tab_.COUNT = 0) THEN
      cost_detail_tab_ := Get_Condition_Cost_Details___(contract_,
                                                        part_no_,
                                                        configuration_id_,
                                                        condition_code_);
      IF (cost_detail_tab_.COUNT = 0) THEN
         cost_detail_tab_ := Get_Details_From_Last_Trans___(contract_,
                                                            part_no_,
                                                            configuration_id_,
                                                            NULL,
                                                            NULL,
                                                            condition_code_,
                                                            calling_process_,
                                                            FALSE);
         IF (cost_detail_tab_.COUNT = 0) THEN
            cost_detail_tab_ := Get_Wa_Config_Cost_Details___(contract_,
                                                              part_no_,
                                                              configuration_id_);
            IF (cost_detail_tab_.COUNT = 0) THEN
               cost_detail_tab_ := Get_Details_From_Last_Trans___(contract_,
                                                                  part_no_,
                                                                  configuration_id_,
                                                                  NULL,
                                                                  NULL,
                                                                  NULL,
                                                                  calling_process_,
                                                                  TRUE);
            END IF;
         END IF;
      END IF;
   END IF;

   RETURN (cost_detail_tab_);
END Get_Default_Cond_Details___;


FUNCTION Get_Default_Lot_Details___ (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   condition_code_   IN VARCHAR2,
   calling_process_  IN VARCHAR2 ) RETURN Cost_Detail_Tab
IS
   cost_detail_tab_          Cost_Detail_Tab;
   partcat_rec_              Part_Catalog_API.Public_Rec;
   partcat_rec_fetched_      BOOLEAN := FALSE;
   estimated_condition_cost_ NUMBER;
BEGIN
   IF (calling_process_ IN ('WORK ORDER RECEIPT', 'CRO CONFIRMATION')) THEN
      partcat_rec_         := Part_Catalog_API.Get(part_no_);
      partcat_rec_fetched_ := TRUE;

      IF (partcat_rec_.condition_code_usage = 'ALLOW_COND_CODE') THEN
         estimated_condition_cost_ := Inv_Part_Config_Condition_API.Get_Estimated_Cost(
                                                                                condition_code_,
                                                                                contract_,
                                                                                part_no_,
                                                                                configuration_id_);
         IF (estimated_condition_cost_ IS NOT NULL ) THEN
            cost_detail_tab_ := Generate_New_Cost_Details___(
                                                       estimated_condition_cost_,
                                                       FALSE,
                                                       contract_,
                                                       part_no_,
                                                       configuration_id_,
                                                       Inventory_Part_API.Get(contract_, part_no_));
         END IF;
      END IF;
   END IF;

   IF (cost_detail_tab_.COUNT = 0) THEN
      cost_detail_tab_ := Get_Lot_Batch_Cost_Details(contract_,
                                                     part_no_,
                                                     configuration_id_,
                                                     lot_batch_no_,
                                                     FALSE);
      IF (cost_detail_tab_.COUNT = 0) THEN
         cost_detail_tab_ := Get_Details_From_Last_Trans___(contract_,
                                                            part_no_,
                                                            configuration_id_,
                                                            lot_batch_no_,
                                                            NULL,
                                                            NULL,
                                                            calling_process_,
                                                            FALSE);
         IF (cost_detail_tab_.COUNT = 0) THEN
            IF NOT (partcat_rec_fetched_) THEN
               partcat_rec_ := Part_Catalog_API.Get(part_no_);
            END IF;

            IF (partcat_rec_.condition_code_usage = 'ALLOW_COND_CODE') THEN
               cost_detail_tab_ := Get_Wa_Condition_Cost_Details(contract_,
                                                                 part_no_,
                                                                 configuration_id_,
                                                                 condition_code_);
               IF (cost_detail_tab_.COUNT = 0) THEN
                  cost_detail_tab_ := Get_Details_From_Last_Trans___(contract_,
                                                                     part_no_,
                                                                     configuration_id_,
                                                                     NULL,
                                                                     NULL,
                                                                     condition_code_,
                                                                     calling_process_,
                                                                     FALSE);
               END IF;
            END IF;
            IF (cost_detail_tab_.COUNT = 0) THEN
               cost_detail_tab_ := Get_Wa_Config_Cost_Details___(contract_,
                                                                 part_no_,
                                                                 configuration_id_);
               IF (cost_detail_tab_.COUNT = 0) THEN
                  cost_detail_tab_ := Get_Details_From_Last_Trans___(contract_,
                                                                     part_no_,
                                                                     configuration_id_,
                                                                     NULL,
                                                                     NULL,
                                                                     NULL,
                                                                     calling_process_,
                                                                     TRUE);
               END IF;
            END IF;
         END IF;
      END IF;
   END IF;

   RETURN (cost_detail_tab_);
END Get_Default_Lot_Details___;


FUNCTION Get_Default_Serial_Details___ (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   condition_code_   IN VARCHAR2,
   calling_process_  IN VARCHAR2 ) RETURN Cost_Detail_Tab
IS
   cost_detail_tab_            Cost_Detail_Tab;
   partcat_rec_                Part_Catalog_API.Public_Rec;
   partcat_rec_fetched_        BOOLEAN := FALSE;
   estimated_condition_cost_   NUMBER;
   company_owned_stock_exists_ BOOLEAN := FALSE;
BEGIN
   IF (calling_process_ IN ('WORK ORDER RECEIPT', 'CRO CONFIRMATION')) THEN
      partcat_rec_         := Part_Catalog_API.Get(part_no_);
      partcat_rec_fetched_ := TRUE;

      IF (partcat_rec_.condition_code_usage = 'ALLOW_COND_CODE') THEN
         estimated_condition_cost_ := Inv_Part_Config_Condition_API.Get_Estimated_Cost(
                                                                                condition_code_,
                                                                                contract_,
                                                                                part_no_,
                                                                                configuration_id_);
         IF (estimated_condition_cost_ IS NOT NULL ) THEN
            cost_detail_tab_ := Generate_New_Cost_Details___(
                                                       estimated_condition_cost_,
                                                       FALSE,
                                                       contract_,
                                                       part_no_,
                                                       configuration_id_,
                                                       Inventory_Part_API.Get(contract_, part_no_));
         END IF;
      END IF;
   ELSIF (calling_process_ = 'COUNTING') THEN
      company_owned_stock_exists_ := Invent_Part_Quantity_Util_API.Check_Quantity_Exist(
                                                                 contract_                      => contract_,
                                                                 part_no_                       => part_no_,
                                                                 configuration_id_              => configuration_id_,
                                                                 lot_batch_no_                  => lot_batch_no_,
                                                                 serial_no_                     => serial_no_,
                                                                 exclude_customer_owned_stock_  => 'TRUE',
                                                                 exclude_supplier_loaned_stock_ => 'TRUE',
                                                                 exclude_supplier_owned_stock_  => 'TRUE',
                                                                 exclude_supplier_rented_stock_ => 'TRUE',
                                                                 exclude_company_rental_stock_  => 'TRUE');
      IF (company_owned_stock_exists_) THEN
         -- If the serials exists as company owned in stock then we should use its currect cost.
         cost_detail_tab_ := Get_Cost_Details_By_Method(contract_,
                                                        part_no_,
                                                        configuration_id_,
                                                        lot_batch_no_,
                                                        serial_no_);
      END IF;   
   END IF;

   IF (cost_detail_tab_.COUNT = 0) THEN
      cost_detail_tab_ := Get_Details_From_Last_Trans___(contract_,
                                                         part_no_,
                                                         configuration_id_,
                                                         lot_batch_no_,
                                                         serial_no_,
                                                         NULL,
                                                         calling_process_,
                                                         FALSE);
      IF (cost_detail_tab_.COUNT = 0) THEN
         IF NOT (partcat_rec_fetched_) THEN
            partcat_rec_ := Part_Catalog_API.Get(part_no_);
         END IF;

         IF (partcat_rec_.condition_code_usage = 'ALLOW_COND_CODE') THEN
            cost_detail_tab_ := Get_Wa_Condition_Cost_Details(contract_,
                                                              part_no_,
                                                              configuration_id_,
                                                              condition_code_);
            IF (cost_detail_tab_.COUNT = 0) THEN
               cost_detail_tab_ := Get_Details_From_Last_Trans___(contract_,
                                                                  part_no_,
                                                                  configuration_id_,
                                                                  NULL,
                                                                  NULL,
                                                                  condition_code_,
                                                                  calling_process_,
                                                                  FALSE);
            END IF;
         END IF;

         IF (cost_detail_tab_.COUNT = 0) THEN
            cost_detail_tab_ := Get_Wa_Config_Cost_Details___(contract_,
                                                              part_no_,
                                                              configuration_id_);
            IF (cost_detail_tab_.COUNT = 0) THEN
               cost_detail_tab_ := Get_Details_From_Last_Trans___(contract_,
                                                                  part_no_,
                                                                  configuration_id_,
                                                                  NULL,
                                                                  NULL,
                                                                  NULL,
                                                                  calling_process_,
                                                                  TRUE);
            END IF;
         END IF;
      END IF;
   END IF;

   RETURN (cost_detail_tab_);
END Get_Default_Serial_Details___;


PROCEDURE Enable_For_Fifolifo___ (
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   inventory_part_rec_  IN Inventory_Part_API.Public_Rec )
IS
   CURSOR get_sequence_no (contract_ IN VARCHAR2,
                           part_no_  IN VARCHAR2) IS
      SELECT sequence_no
        FROM inventory_part_cost_fifo_tab
       WHERE  contract = contract_
         AND  part_no  = part_no_;

   TYPE Sequence_No_Tab IS TABLE OF get_sequence_no%ROWTYPE
      INDEX BY PLS_INTEGER;

   sequence_no_tab_ Sequence_No_Tab;
BEGIN

   OPEN  get_sequence_no(contract_, part_no_);
   FETCH get_sequence_no BULK COLLECT INTO sequence_no_tab_;
   CLOSE get_sequence_no;

   IF (sequence_no_tab_.COUNT > 0) THEN
      FOR i IN sequence_no_tab_.FIRST..sequence_no_tab_.LAST LOOP

         Enable_Cost_Details___(contract_,
                                part_no_,
                                '*',
                                NULL,
                                NULL,
                                sequence_no_tab_(i).sequence_no,
                                inventory_part_rec_);
      END LOOP;
   END IF;
END Enable_For_Fifolifo___;


PROCEDURE Enable_For_Std_Avg___ (
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   inventory_part_rec_  IN Inventory_Part_API.Public_Rec )
IS
   CURSOR get_keys (contract_ IN VARCHAR2,
                    part_no_  IN VARCHAR2) IS
      SELECT DISTINCT configuration_id, lot_batch_no, serial_no
        FROM INVENTORY_PART_UNIT_COST_TAB
       WHERE  contract     = contract_
         AND  part_no      = part_no_;

   TYPE Key_Tab IS TABLE OF get_keys%ROWTYPE
      INDEX BY PLS_INTEGER;

   key_tab_ Key_Tab;
BEGIN

   OPEN  get_keys(contract_, part_no_);
   FETCH get_keys BULK COLLECT INTO key_tab_;
   CLOSE get_keys;

   IF (key_tab_.COUNT > 0) THEN
      FOR i IN key_tab_.FIRST..key_tab_.LAST LOOP

         Enable_Cost_Details___(contract_,
                                part_no_,
                                key_tab_(i).configuration_id,
                                key_tab_(i).lot_batch_no,
                                key_tab_(i).serial_no,
                                NULL,
                                inventory_part_rec_);
      END LOOP;
   END IF;
END Enable_For_Std_Avg___;


-- Check_Accounting_Year___
--   Validates the value of key attribute AccountinYear during
--   insert of a new record.
PROCEDURE Check_Accounting_Year___ (
   valuation_method_db_  IN OUT VARCHAR2,
   part_cost_level_db_   IN OUT VARCHAR2,
   accounting_year_      IN     VARCHAR2,
   contract_             IN     VARCHAR2,
   part_no_              IN     VARCHAR2,
   cost_bucket_id_       IN     VARCHAR2 )
IS
   accounting_year_number_ NUMBER;
   inventory_part_rec_     Inventory_Part_API.Public_Rec;
   cost_bucket_type_db_    VARCHAR2(20);
BEGIN

   BEGIN
      accounting_year_number_ := To_Number(accounting_year_);

      IF (accounting_year_number_ NOT BETWEEN 2000 AND 3000) THEN
         Error_Sys.Record_General(lu_name_, 'ACCYEARINV: OH Accounting Year must be a valid four digit year number.');
      END IF;

   EXCEPTION
      WHEN OTHERS THEN
         IF (accounting_year_ != '*') THEN
            Error_Sys.Record_General(lu_name_, 'ACYEARERR1: OH Accounting Year can only be * or a four digit number.');
         END IF;
   END;

   IF (accounting_year_ != '*') THEN
      IF (valuation_method_db_ IS NULL) THEN
         inventory_part_rec_  := Inventory_Part_API.Get(contract_, part_no_);
         valuation_method_db_ := inventory_part_rec_.inventory_valuation_method;
         part_cost_level_db_  := inventory_part_rec_.inventory_part_cost_level;
      END IF;

      IF ((valuation_method_db_ = 'ST') AND
          (part_cost_level_db_ IN ('COST PER PART', 'COST PER CONFIGURATION'))) THEN
         Error_Sys.Record_General(lu_name_, 'ACYEARERR4: OH Accounting Year must be * when using :P1 in combination with :P2.',Inventory_Value_Method_API.Decode(valuation_method_db_),Inventory_Part_Cost_Level_API.Decode(part_cost_level_db_));
      END IF;

      cost_bucket_type_db_ := Get_Cost_Bucket_Type_Db___(contract_,
                                                         cost_bucket_id_);

      IF NOT (Overhead_Cost_Bucket_Type___(cost_bucket_type_db_)) THEN
         Error_Sys.Record_General(lu_name_, 'ACYEARERR3: OH Accounting Year must be * when the cost bucket is not an overhead bucket.');
      END IF;
   END IF;
END Check_Accounting_Year___;


-- Check_Cost_Source_Id___
--   Validates the value of key attribute CostSourceId during
--   insert of a new record.
PROCEDURE Check_Cost_Source_Id___ (
   valuation_method_db_ IN OUT VARCHAR2,
   part_cost_level_db_  IN OUT VARCHAR2,
   contract_            IN     VARCHAR2,
   part_no_             IN     VARCHAR2,
   cost_source_id_      IN     VARCHAR2 )
IS
   inventory_part_rec_ Inventory_Part_API.Public_Rec;
BEGIN

   IF (cost_source_id_ != '*') THEN
      IF (valuation_method_db_ IS NULL) THEN
         inventory_part_rec_  := Inventory_Part_API.Get(contract_, part_no_);
         valuation_method_db_ := inventory_part_rec_.inventory_valuation_method;
         part_cost_level_db_  := inventory_part_rec_.inventory_part_cost_level;
      END IF;

      IF ((valuation_method_db_ = 'ST') AND
          (part_cost_level_db_ IN ('COST PER PART', 'COST PER CONFIGURATION'))) THEN
         Error_Sys.Record_General(lu_name_, 'COSTSOURCEERR: Cost Source ID must be * when using :P1 in combination with :P2.',Inventory_Value_Method_API.Decode(valuation_method_db_),Inventory_Part_Cost_Level_API.Decode(part_cost_level_db_));
      END IF;
   END IF;
END Check_Cost_Source_Id___;


-- Check_Cost_Bucket_Id___
--   Validates the value of key attribute CostBucketId during
--   insert of a new record.
PROCEDURE Check_Cost_Bucket_Id___ (
   contract_       IN VARCHAR2,
   cost_bucket_id_ IN VARCHAR2,
   cost_source_id_ IN VARCHAR2,
   unit_cost_      IN NUMBER,
   part_no_        IN VARCHAR2 )
IS
BEGIN

   IF (cost_bucket_id_ = '*') THEN
      IF (cost_source_id_ != '*') THEN
         Error_Sys.Record_General(lu_name_, 'BUCKETERR1: Cost Bucket ID equal to '':P1'' is only allowed when Cost Source ID is equal to *.', cost_bucket_id_);
      END IF;
      $IF (Component_Cost_SYS.INSTALLED) $THEN      
         IF (unit_cost_ != 0) THEN
            Error_Sys.Record_General(lu_name_, 'BUCKETERR2: Cost Bucket ID equal to '':P1'' is only allowed when Unit Cost is zero. This erroneous situation has now been detected for part :P2 at site :P3.', cost_bucket_id_, part_no_, contract_);
         END IF;
      $END
   ELSE
      $IF NOT(Component_Cost_SYS.INSTALLED) $THEN      
         Error_SYS.Record_General(lu_name_, 'COSTNOTINST: The only allowed Cost Bucket ID is '':P1'' since Costing is not installed.','*');
      $ELSE
         NULL;
      $END
   END IF;
   
   IF (Get_Cost_Bucket_Type_Db___(contract_, cost_bucket_id_) = 'SALESOH') THEN
      Error_SYS.Record_General(lu_name_,'SALESOHNOTALLOWED: Sales Overhead cost buckets are not allowed in Inventory Part Cost Details.');
   END IF;
END Check_Cost_Bucket_Id___;


PROCEDURE Set_Part_Actual_Cost___ (
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   part_rec_            IN Inventory_Part_API.Public_Rec,
   new_cost_detail_tab_ IN Cost_Detail_Tab )
IS
   old_cost_detail_tab_       Cost_Detail_Tab;
   local_new_cost_detail_tab_ Cost_Detail_Tab;

   CURSOR get_configurations (contract_ IN VARCHAR2,
                              part_no_  IN VARCHAR2) IS
      SELECT DISTINCT configuration_id
        FROM INVENTORY_PART_UNIT_COST_TAB
       WHERE  contract= contract_
         AND  part_no = part_no_;
BEGIN

   local_new_cost_detail_tab_ := new_cost_detail_tab_;

   FOR config_rec_ IN get_configurations(contract_,
                                         part_no_) LOOP

      old_cost_detail_tab_ := Get_Cost_Details_And_Lock___(contract_,
                                                           part_no_,
                                                           config_rec_.configuration_id,
                                                           '*',
                                                           '*');
      Modify_Cost_Details___(local_new_cost_detail_tab_,
                             old_cost_detail_tab_,
                             contract_,
                             part_no_,
                             config_rec_.configuration_id,
                             '*',
                             '*',
                             part_rec_.zero_cost_flag,
                             part_rec_.inventory_part_cost_level,
                             part_rec_.inventory_valuation_method);
   END LOOP;
END Set_Part_Actual_Cost___;


PROCEDURE Set_Config_Actual_Cost___ (
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   configuration_id_    IN VARCHAR2,
   part_rec_            IN Inventory_Part_API.Public_Rec,
   new_cost_detail_tab_ IN Cost_Detail_Tab )
IS
   old_cost_detail_tab_       Cost_Detail_Tab;
   local_new_cost_detail_tab_ Cost_Detail_Tab;
BEGIN

   local_new_cost_detail_tab_ := new_cost_detail_tab_;

   old_cost_detail_tab_ := Get_Cost_Details_And_Lock___(contract_,
                                                        part_no_,
                                                        configuration_id_,
                                                        '*',
                                                        '*');
   Modify_Cost_Details___(local_new_cost_detail_tab_,
                          old_cost_detail_tab_,
                          contract_,
                          part_no_,
                          configuration_id_,
                          '*',
                          '*',
                          part_rec_.zero_cost_flag,
                          part_rec_.inventory_part_cost_level,
                          part_rec_.inventory_valuation_method);
END Set_Config_Actual_Cost___;


PROCEDURE Set_Lot_Batch_Actual_Cost___ (
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   configuration_id_    IN VARCHAR2,
   lot_batch_no_        IN VARCHAR2,
   part_rec_            IN Inventory_Part_API.Public_Rec,
   new_cost_detail_tab_ IN Cost_Detail_Tab )
IS
   old_cost_detail_tab_       Cost_Detail_Tab;
   local_new_cost_detail_tab_ Cost_Detail_Tab;

   CURSOR get_serial_no IS
      SELECT DISTINCT serial_no
      FROM INVENTORY_PART_UNIT_COST_TAB
      WHERE part_no          = part_no_
        AND contract         = contract_
        AND configuration_id = configuration_id_
        AND lot_batch_no     = lot_batch_no_;

   TYPE Serial_No_Tab IS TABLE OF get_serial_no%ROWTYPE
     INDEX BY PLS_INTEGER;

   serial_no_tab_ Serial_No_Tab;
BEGIN

   local_new_cost_detail_tab_ := new_cost_detail_tab_;

   OPEN get_serial_no;
   FETCH get_serial_no BULK COLLECT INTO serial_no_tab_;
   CLOSE get_serial_no;

   IF (serial_no_tab_.COUNT > 0) THEN
      FOR i IN serial_no_tab_.FIRST..serial_no_tab_.LAST LOOP

         old_cost_detail_tab_ := Get_Cost_Details_And_Lock___(contract_,
                                                              part_no_,
                                                              configuration_id_,
                                                              lot_batch_no_,
                                                              serial_no_tab_(i).serial_no);
         Modify_Cost_Details___(local_new_cost_detail_tab_,
                                old_cost_detail_tab_,
                                contract_,
                                part_no_,
                                configuration_id_,
                                lot_batch_no_,
                                serial_no_tab_(i).serial_no,
                                part_rec_.zero_cost_flag,
                                part_rec_.inventory_part_cost_level,
                                part_rec_.inventory_valuation_method);
      END LOOP;
   END IF;
END Set_Lot_Batch_Actual_Cost___;


PROCEDURE Set_Condition_Actual_Cost___ (
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   configuration_id_    IN VARCHAR2,
   condition_code_      IN VARCHAR2,
   part_rec_            IN Inventory_Part_API.Public_Rec,
   new_cost_detail_tab_ IN Cost_Detail_Tab )
IS
   old_cost_detail_tab_         Cost_Detail_Tab;
   local_new_cost_detail_tab_   Cost_Detail_Tab;
   current_condition_code_      VARCHAR2(50);
   char_null_                   VARCHAR2(12) := 'VARCHAR2NULL';
   old_cost_detail_tab_fetched_ BOOLEAN := FALSE;
   index_                       PLS_INTEGER := 1;

   CURSOR get_lot_serial IS
      SELECT DISTINCT lot_batch_no, serial_no
      FROM INVENTORY_PART_UNIT_COST_TAB
      WHERE part_no          = part_no_
        AND contract         = contract_
        AND configuration_id = configuration_id_;

   TYPE Lot_Serial_Tab IS TABLE OF get_lot_serial%ROWTYPE
     INDEX BY PLS_INTEGER;

   lot_serial_tab_ Lot_Serial_Tab;
BEGIN

   local_new_cost_detail_tab_ := new_cost_detail_tab_;

   FOR lot_serial_rec_ IN get_lot_serial LOOP
      current_condition_code_ := Condition_Code_Manager_API.Get_Condition_Code(
                                                                     part_no_,
                                                                     lot_serial_rec_.serial_no,
                                                                     lot_serial_rec_.lot_batch_no);

      IF (NVL(condition_code_, char_null_) = NVL(current_condition_code_, char_null_)) THEN

         lot_serial_tab_(index_) := lot_serial_rec_;
         index_ := index_ + 1;

         IF NOT (old_cost_detail_tab_fetched_) THEN
            old_cost_detail_tab_ := Get_Cost_Details_And_Lock___(contract_,
                                                                 part_no_,
                                                                 configuration_id_,
                                                                 lot_serial_rec_.lot_batch_no,
                                                                 lot_serial_rec_.serial_no);
            old_cost_detail_tab_fetched_ := TRUE;
         END IF;
      END IF;
   END LOOP;

   IF (lot_serial_tab_.COUNT > 0) THEN
      FOR i IN lot_serial_tab_.FIRST..lot_serial_tab_.LAST LOOP

         Modify_Cost_Details___(local_new_cost_detail_tab_,
                                old_cost_detail_tab_,
                                contract_,
                                part_no_,
                                configuration_id_,
                                lot_serial_tab_(i).lot_batch_no,
                                lot_serial_tab_(i).serial_no,
                                part_rec_.zero_cost_flag,
                                part_rec_.inventory_part_cost_level,
                                part_rec_.inventory_valuation_method);
      END LOOP;
   END IF;
END Set_Condition_Actual_Cost___;


PROCEDURE Modify_Part_Cost___ (
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   inventory_part_rec_  IN Inventory_Part_API.Public_Rec,
   new_cost_detail_tab_ IN Cost_Detail_Tab )
IS
   CURSOR get_configuration_id IS
      SELECT DISTINCT configuration_id
      FROM INVENTORY_PART_UNIT_COST_TAB
      WHERE part_no  = part_no_
        AND contract = contract_;
BEGIN

   IF (inventory_part_rec_.inventory_valuation_method != 'AV') THEN
      Raise_Value_Method_Error___;
   END IF;

   IF (inventory_part_rec_.inventory_part_cost_level != 'COST PER PART') THEN
      Raise_Cost_Level_Error___(Inventory_Part_Cost_Level_API.DB_COST_PER_PART);
   END IF;

   FOR config_rec_ IN get_configuration_id LOOP

      Modify_Details_And_Revalue___(contract_,
                                    part_no_,
                                    config_rec_.configuration_id,
                                    '*',
                                    '*',
                                    inventory_part_rec_.inventory_part_cost_level,
                                    inventory_part_rec_.inventory_valuation_method,
                                    inventory_part_rec_.invoice_consideration,
                                    inventory_part_rec_.zero_cost_flag,
                                    new_cost_detail_tab_);
   END LOOP;
END Modify_Part_Cost___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT inventory_part_unit_cost_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   IF (indrec_.inventory_value = FALSE) THEN
      newrec_.inventory_value := 0;
   END IF;
                                       
   super(newrec_, indrec_, attr_);
      Check_Insert(newrec_.accounting_year,
                newrec_.contract,
                newrec_.part_no,
                newrec_.cost_bucket_id,
                newrec_.company,
                newrec_.cost_source_id,
                newrec_.inventory_value);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;

-- Remove_Part_Config___
--   This procedure will perform a check against InventoryPartUnitCost
--   and perform actions 'CHECK' or 'DO' accordingly if no records were found
--   in InventoryPartUnitCost for the part configuration.
PROCEDURE Remove_Part_Config___ (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   action_           IN VARCHAR2 )
IS
   objid_      inventory_part_unit_cost.objid%TYPE;
   objversion_ inventory_part_unit_cost.objversion%TYPE;

   CURSOR get_records IS
      SELECT *
      FROM   inventory_part_unit_cost_tab
      WHERE  contract         = contract_
      AND    part_no          = part_no_
      AND    configuration_id = configuration_id_ ;
   
   CURSOR get_records_and_lock IS
      SELECT *
      FROM   inventory_part_unit_cost_tab
      WHERE  contract         = contract_
      AND    part_no          = part_no_
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
         Get_Id_Version_By_Keys___(objid_,
                                   objversion_,
                                   record_.contract,
                                   record_.part_no,
                                   record_.configuration_id,
                                   record_.lot_batch_no,
                                   record_.serial_no,
                                   record_.accounting_year,
                                   record_.cost_bucket_id,
                                   record_.company,
                                   record_.cost_source_id);
         Delete___(objid_, record_);
      END LOOP;
   END IF;
END Remove_Part_Config___;

PROCEDURE Raise_Cost_Level_Error___ (
   inventory_part_cost_level_db_ IN  VARCHAR2 )
IS
BEGIN
   Error_SYS.Record_General(lu_name_, 'COSTLEVELERROR: This operation is only allowed when the part cost level is :P1.', Inventory_Part_Cost_Level_API.Decode(inventory_part_cost_level_db_));
END Raise_Cost_Level_Error___;

PROCEDURE Modify_Configuration_Cost___ (
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   inventory_part_rec_  IN Inventory_Part_API.Public_Rec,
   configuration_id_    IN VARCHAR2,
   new_cost_detail_tab_ IN Cost_Detail_Tab )
IS
BEGIN
   IF (inventory_part_rec_.inventory_valuation_method != Inventory_Value_Method_API.DB_STANDARD_COST) THEN
      Raise_Value_Method_Error___;
   END IF;

   IF (inventory_part_rec_.inventory_part_cost_level != Inventory_Part_Cost_Level_API.DB_COST_PER_CONFIGURATION) THEN
      Raise_Cost_Level_Error___(Inventory_Part_Cost_Level_API.DB_COST_PER_CONFIGURATION);
   END IF;
   
   Modify_Details_And_Revalue___(contract_,
                                 part_no_,
                                 configuration_id_,
                                 '*',
                                 '*',
                                 inventory_part_rec_.inventory_part_cost_level,
                                 inventory_part_rec_.inventory_valuation_method,
                                 inventory_part_rec_.invoice_consideration,
                                 inventory_part_rec_.zero_cost_flag,
                                 new_cost_detail_tab_);
END Modify_Configuration_Cost___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Modify_Condition_Cost__
--   The implementation of the functionality for public method Modify_Condition_Cost.
--   This method which is executed as a background job modifies the unit cost for
--   all lots and serials of a part having a specific condition code.
PROCEDURE Modify_Condition_Cost__ (
   attr_ IN VARCHAR2 )
IS
   part_rec_               Inventory_Part_API.Public_Rec;
   char_null_              VARCHAR2(12) := 'VARCHAR2NULL';
   current_condition_code_ VARCHAR2(50);
   ptr_                    NUMBER;
   name_                   VARCHAR2(30);
   value_                  VARCHAR2(2000);
   contract_               INVENTORY_PART_UNIT_COST_TAB.contract%TYPE;
   part_no_                INVENTORY_PART_UNIT_COST_TAB.part_no%TYPE;
   configuration_id_       INVENTORY_PART_UNIT_COST_TAB.configuration_id%TYPE;
   condition_code_         VARCHAR2(50);
   cost_detail_id_         NUMBER;
   new_cost_detail_tab_    Cost_Detail_Tab;

   CURSOR get_keys IS
      SELECT DISTINCT lot_batch_no, serial_no
      FROM INVENTORY_PART_UNIT_COST_TAB
      WHERE part_no          = part_no_
        AND contract         = contract_
        AND configuration_id = configuration_id_;
BEGIN
   ------------------------------------------------------------------------------
   -- Fetch inparameters and verify that the correct parameters were passed.   --
   ------------------------------------------------------------------------------
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'CONTRACT') THEN
         contract_ := value_;
      ELSIF (name_ = 'PART_NO') THEN
         part_no_ := value_;
      ELSIF (name_ = 'CONFIGURATION_ID') THEN
         configuration_id_ := value_;
      ELSIF (name_ = 'CONDITION_CODE') THEN
         condition_code_ := value_;
      ELSIF (name_ = 'COST_DETAIL_ID') THEN
         cost_detail_id_ := Client_SYS.Attr_Value_To_Number(value_);
      ELSE
         Error_SYS.Appl_general(lu_name_,'INVPAR: Passed argument :P1 is not a parameter in method Modify_Condition_Cost__.',name_);
      END IF;
   END LOOP;

   -- Verify that there are no other modify condition cost jobs running on the same parameter values
   -- to avoid simultaneous execution of the Modify Condition Cost calculation.
   IF Is_Executing___(contract_, part_no_, configuration_id_, condition_code_) THEN
      Error_Sys.Appl_General(lu_name_, 'ALREXEC: The Modify Condition Average Cost job is already executing for Configuration :P1 of Part :P2 on Site :P3 and must complete first.', configuration_id_, part_no_, contract_);
   END IF;

   Temporary_Part_Cost_Detail_API.Get_And_Remove_Details(new_cost_detail_tab_,
                                                         cost_detail_id_);

   part_rec_ := Inventory_Part_API.Get(contract_, part_no_);

   FOR key_rec_ IN get_keys LOOP
      current_condition_code_ := Condition_Code_Manager_API.Get_Condition_Code(part_no_,
                                                                               key_rec_.serial_no,
                                                                               key_rec_.lot_batch_no);

      IF (NVL(condition_code_, char_null_) = NVL(current_condition_code_, char_null_)) THEN

         Modify_Details_And_Revalue___(contract_,
                                       part_no_,
                                       configuration_id_,
                                       key_rec_.lot_batch_no,
                                       key_rec_.serial_no,
                                       part_rec_.inventory_part_cost_level,
                                       part_rec_.inventory_valuation_method,
                                       part_rec_.invoice_consideration,
                                       part_rec_.zero_cost_flag,
                                       new_cost_detail_tab_);
      END IF;
   END LOOP;
END Modify_Condition_Cost__;


-- Fill_Temporary_Table__
--   Stores the content of parameter cost detail tab into a temporary oracle table.
PROCEDURE Fill_Temporary_Table__ (
   cost_detail_tab_ IN  Cost_Detail_Tab )
IS
BEGIN

   DELETE FROM inventory_part_unit_cost_tmp;

   IF (cost_detail_tab_.COUNT > 0) THEN
      FOR i IN cost_detail_tab_.FIRST..cost_detail_tab_.LAST LOOP
         INSERT INTO inventory_part_unit_cost_tmp
            (accounting_year,
             contract,
             cost_bucket_id,
             company,
             cost_source_id,
             unit_cost)
         VALUES
            (cost_detail_tab_(i).accounting_year,
             cost_detail_tab_(i).contract,
             cost_detail_tab_(i).cost_bucket_id,
             cost_detail_tab_(i).company,
             cost_detail_tab_(i).cost_source_id,
             cost_detail_tab_(i).unit_cost);
      END LOOP;
   END IF;
END Fill_Temporary_Table__;


FUNCTION Get_From_Temporary_Table__ RETURN Cost_Detail_Tab
IS
   cost_detail_tab_ Cost_Detail_Tab;

   CURSOR get_cost_details IS
   SELECT * FROM inventory_part_unit_cost_tmp;
BEGIN
   OPEN  get_cost_details;
   FETCH get_cost_details BULK COLLECT INTO cost_detail_tab_;
   CLOSE get_cost_details;

   DELETE FROM inventory_part_unit_cost_tmp;

   RETURN (cost_detail_tab_);
END Get_From_Temporary_Table__;


-- Modify_Cost_Detail__
--   Makes the appropriate modifications in the database for one single cost detail.
PROCEDURE Modify_Cost_Detail__ (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   accounting_year_  IN VARCHAR2,
   cost_bucket_id_   IN VARCHAR2,
   company_          IN VARCHAR2,
   cost_source_id_   IN VARCHAR2,
   unit_cost_        IN NUMBER )
IS
   attr_          VARCHAR2(2000);
   oldrec_        INVENTORY_PART_UNIT_COST_TAB%ROWTYPE;
   newrec_        INVENTORY_PART_UNIT_COST_TAB%ROWTYPE;
   objid_         INVENTORY_PART_UNIT_COST.objid%TYPE;
   objversion_    INVENTORY_PART_UNIT_COST.objversion%TYPE;
   remove_record_ BOOLEAN;
   indrec_        Indicator_Rec;
BEGIN

   IF (unit_cost_ = 0) THEN
      IF ((accounting_year_ = '*')  AND
          (cost_bucket_id_  = '*')  AND
          (cost_source_id_  = '*')) THEN
         remove_record_ := FALSE;
      ELSE
         remove_record_ := TRUE;
      END IF;
   ELSE
      remove_record_ := FALSE;
   END IF;

   IF (remove_record_) THEN
      Remove___(contract_,
                part_no_,
                configuration_id_,
                lot_batch_no_,
                serial_no_,
                accounting_year_,
                cost_bucket_id_,
                company_,
                cost_source_id_);
   ELSE
      oldrec_ := Lock_By_Keys___(contract_,
                                 part_no_,
                                 configuration_id_,
                                 lot_batch_no_,
                                 serial_no_,
                                 accounting_year_,
                                 cost_bucket_id_,
                                 company_,
                                 cost_source_id_);
      newrec_ := oldrec_;
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('INVENTORY_VALUE', unit_cost_, attr_);
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
      Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE); -- Update by keys
   END IF;
END Modify_Cost_Detail__;

-- Check_Remove_Part_Config__
--   This procedure will call the method Remove_Part_Config___ to perform a
--   check to remove records from InventoryPartUnitCost with respect to the
--   part configuration.
PROCEDURE Check_Remove_Part_Config__ (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2 )
IS
BEGIN
   Remove_Part_Config___(contract_, part_no_, configuration_id_, 'CHECK');
END Check_Remove_Part_Config__;

-- Do_Remove_Part_Config__
--   This procedure will call the method Remove_Part_Config___ to remove records
--   from InventoryPartUnitCost with respect to the part configuration.
PROCEDURE Do_Remove_Part_Config__ (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2 )
IS
BEGIN
   Remove_Part_Config___(contract_, part_no_, configuration_id_, 'DO');
END Do_Remove_Part_Config__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Actual_Cost_Revalue
--   This method takes care of the revaluation of beginning inventory when
--   an actual cost calculation is started.
PROCEDURE Actual_Cost_Revalue (
   contract_               IN VARCHAR2,
   part_no_                IN VARCHAR2,
   configuration_id_       IN VARCHAR2,
   old_cost_detail_tab_    IN Cost_Detail_Tab,
   new_cost_detail_tab_    IN Cost_Detail_Tab,
   location_group_qty_tab_ IN Inventory_Value_Part_API.Location_Group_Quantities_Tab,
   order_type_             IN VARCHAR2 )
IS
   transaction_pos_     VARCHAR2(10);
   transaction_neg_     VARCHAR2(10);
   quantity_            NUMBER;
   exit_procedure_      EXCEPTION;
   order_type_is_purch_ BOOLEAN := FALSE;
BEGIN
   -- update inventory value

   -- The actual cost revaluation should only revalue the quantity that existed
   -- in the beginning of the actual cost period. Since the revalue transaction
   -- actually occured at that point of time.

   -- Purchase Orders should be revalued towards the M10 account. Manufacturing
   -- on the other hand should be revalued towards M40. That is so that the
   -- revaluation will balance the cost variance.

   IF (location_group_qty_tab_.COUNT = 0) THEN
      RAISE exit_procedure_;
   END IF;

   IF (order_type_ = 'PURCH') THEN
      order_type_is_purch_ := TRUE;
   END IF;

   FOR i IN location_group_qty_tab_.FIRST..location_group_qty_tab_.LAST LOOP
      FOR j IN 1..3 LOOP
         IF (j = 1) THEN
            IF (order_type_is_purch_) THEN
               transaction_pos_ := 'AC-INVREV+';
               transaction_neg_ := 'AC-INVREV-';
            ELSE
               transaction_pos_ := 'AC-MFGREV+';
               transaction_neg_ := 'AC-MFGREV-';
            END IF;
            quantity_ := location_group_qty_tab_(i).quantity +
                         location_group_qty_tab_(i).qty_waiv_dev_rej +
                         location_group_qty_tab_(i).qty_at_customer;
         ELSIF (j = 2) THEN
            IF (order_type_is_purch_) THEN
               transaction_pos_ := 'CO-AC-INV+';
               transaction_neg_ := 'CO-AC-INV-';
            ELSE
               transaction_pos_ := 'CO-AC-REV+';
               transaction_neg_ := 'CO-AC-REV-';
            END IF;
            quantity_ := location_group_qty_tab_(i).vendor_owned_qty;
         ELSIF (j = 3) THEN
            IF (order_type_is_purch_) THEN
               transaction_pos_ := 'AC-INVRTR+';
               transaction_neg_ := 'AC-INVRTR-';
            ELSE
               transaction_pos_ := 'AC-MFGRTR+';
               transaction_neg_ := 'AC-MFGRTR-';
            END IF;
            quantity_ := location_group_qty_tab_(i).qty_in_transit;
         ELSE
            Error_SYS.Record_General(lu_name_, 'NOTSUPPORTED: The Periodic Weighted Average Invoice Consideration calculation is trying to perform and unsupported operation. Contact system support.');
         END IF;

         Make_Revalue_Transactions___(
                                 contract_            => contract_,
                                 part_no_             => part_no_,
                                 configuration_id_    => configuration_id_,
                                 lot_batch_no_        => NULL,
                                 serial_no_           => NULL,
                                 old_cost_detail_tab_ => old_cost_detail_tab_,
                                 new_cost_detail_tab_ => new_cost_detail_tab_,
                                 transaction_pos_     => transaction_pos_,
                                 transaction_neg_     => transaction_neg_,
                                 quantity_            => quantity_,
                                 location_group_      => location_group_qty_tab_(i).location_group,
                                 activity_seq_        => NULL,
                                 condition_code_      => NULL,
                                 valuation_method_db_ => 'ST');
      END LOOP;
   END LOOP;
EXCEPTION
   WHEN exit_procedure_ THEN
      NULL;
END Actual_Cost_Revalue;


-- Check_Exist
--   This method will check whether a record exists with a given contract,
--   part no, configuration id, lot batch no and serial no combination.
@UncheckedAccess
FUNCTION Check_Exist (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   accounting_year_  IN VARCHAR2,
   cost_bucket_id_   IN VARCHAR2,
   company_          IN VARCHAR2,
   cost_source_id_   IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN Check_Exist___(contract_, part_no_, configuration_id_, lot_batch_no_, serial_no_, accounting_year_, cost_bucket_id_, company_, cost_source_id_);
END Check_Exist;


-- Check_Zero_Cost_Flag
--   Validates unit cost for the part against the Zero Cost flag on the InventoryPart.
PROCEDURE Check_Zero_Cost_Flag (
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   configuration_id_    IN VARCHAR2,
   zero_cost_flag_db_   IN VARCHAR2,
   part_cost_level_db_  IN VARCHAR2,
   valuation_method_db_ IN VARCHAR2 )
IS
   cost_detail_tab_ Cost_Detail_Tab;

   CURSOR get_keys IS
      SELECT DISTINCT lot_batch_no, serial_no
        FROM INVENTORY_PART_UNIT_COST_TAB
       WHERE contract         = contract_
         AND part_no          = part_no_
         AND configuration_id = configuration_id_;

   
   CURSOR get_fifo_stack_key IS
      SELECT sequence_no
        FROM inventory_part_cost_fifo_tab
       WHERE part_no  = part_no_
         AND contract = contract_
         AND quantity > 0;
   
BEGIN
   
   IF (valuation_method_db_ IN ('FIFO','LIFO')) THEN
      FOR key_rec_ IN get_fifo_stack_key LOOP
         cost_detail_tab_ := Inventory_Part_Fifo_Detail_API.Get_Cost_Details(contract_,
                                                                             part_no_,
                                                                             key_rec_.sequence_no);
         Check_Zero_Cost_Flag___(contract_,
                                 part_no_,
                                 configuration_id_,
                                 '*',
                                 '*',
                                 zero_cost_flag_db_,
                                 part_cost_level_db_,
                                 valuation_method_db_,
                                 cost_detail_tab_);
      END LOOP;
   ELSE
      FOR key_rec_ IN get_keys LOOP
         cost_detail_tab_ := Get_Cost_Detail_Tab___(contract_,
                                                    part_no_,
                                                    configuration_id_,
                                                    key_rec_.lot_batch_no,
                                                    key_rec_.serial_no);
         Check_Zero_Cost_Flag___(contract_,
                                  part_no_,
                                  configuration_id_,
                                  key_rec_.lot_batch_no,
                                  key_rec_.serial_no,
                                  zero_cost_flag_db_,
                                  part_cost_level_db_,
                                  valuation_method_db_,
                                  cost_detail_tab_);
      END LOOP;
   END IF;
END Check_Zero_Cost_Flag;


@UncheckedAccess
FUNCTION Get_Inventory_Value_By_Config (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   inventory_value_ INVENTORY_PART_UNIT_COST_TAB.inventory_value%TYPE;
BEGIN
   inventory_value_ := Get_Inventory_Value_By_Method(contract_,
                                                     part_no_,
                                                     configuration_id_,
                                                     NULL,
                                                     NULL);
   RETURN(NVL(inventory_value_,0));
END Get_Inventory_Value_By_Config;


@UncheckedAccess
FUNCTION Get_Inventory_Value_By_Method (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   serial_no_        IN VARCHAR2 ) RETURN NUMBER
IS
   cost_detail_tab_ Cost_Detail_Tab;
   total_unit_cost_ NUMBER;
BEGIN
   cost_detail_tab_ := Get_Cost_Details_By_Method(contract_,
                                                  part_no_,
                                                  configuration_id_,
                                                  lot_batch_no_,
                                                  serial_no_);

   total_unit_cost_ := Get_Total_Unit_Cost(cost_detail_tab_);

   RETURN nvl(total_unit_cost_, 0);
END Get_Inventory_Value_By_Method;


-- Get_Invent_Value_By_Condition
--   A very important method that can be used in all situations when
--   the current or estimated inventory value is need for a unique
--   combination of contract, part_no, configuration_id and condition_code.
--   It works for all part cost levels.
@UncheckedAccess
FUNCTION Get_Invent_Value_By_Condition (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   condition_code_   IN VARCHAR2 ) RETURN NUMBER
IS
   cost_detail_tab_ Cost_Detail_Tab;
   total_unit_cost_ NUMBER;
BEGIN

   cost_detail_tab_ := Get_Cost_Details_By_Condition(contract_,
                                                     part_no_,
                                                     configuration_id_,
                                                     condition_code_);

   total_unit_cost_ := Get_Total_Unit_Cost(cost_detail_tab_);

   RETURN nvl(total_unit_cost_, 0);
END Get_Invent_Value_By_Condition;


-- Handle_Lot_Condition_Change
--   This public method must only be used from InventConditionCodeUtil in
--   Invent when the condition code has been changed on a LotBatchMaster record.
PROCEDURE Handle_Lot_Condition_Change (
   part_no_            IN VARCHAR2,
   lot_batch_no_       IN VARCHAR2,
   new_condition_code_ IN VARCHAR2 )
IS
   new_cost_detail_tab_       Cost_Detail_Tab;
   old_cost_detail_tab_       Cost_Detail_Tab;
   condition_code_keys_found_ BOOLEAN;
   lot_batch_reserved_        BOOLEAN;
   part_rec_                  Inventory_Part_API.Public_Rec;
   cc_lot_batch_no_           INVENTORY_PART_UNIT_COST_TAB.lot_batch_no%TYPE;
   cc_serial_no_              INVENTORY_PART_UNIT_COST_TAB.serial_no%TYPE;

   CURSOR get_keys (part_no_      IN VARCHAR2,
                    lot_batch_no_ IN VARCHAR2) IS
      SELECT DISTINCT contract, configuration_id, serial_no
      FROM  INVENTORY_PART_UNIT_COST_TAB
      WHERE part_no      = part_no_
        AND lot_batch_no = lot_batch_no_;

   CURSOR get_condition_code_keys (contract_             IN VARCHAR2,
                                   part_no_              IN VARCHAR2,
                                   configuration_id_     IN VARCHAR2,
                                   condition_code_       IN VARCHAR2,
                                   current_lot_batch_no_ IN VARCHAR2) IS
      SELECT ipuc.lot_batch_no, ipuc.serial_no
      FROM  INVENTORY_PART_UNIT_COST_TAB ipuc, lot_batch_master_pub lbmp
      WHERE ipuc.part_no          = lbmp.part_no
        AND ipuc.lot_batch_no     = lbmp.lot_batch_no
        AND ipuc.configuration_id = configuration_id_
        AND ipuc.contract         = contract_
        AND lbmp.part_no          = part_no_
        AND lbmp.lot_batch_no    != current_lot_batch_no_
        AND lbmp.condition_code   = condition_code_;
BEGIN
   lot_batch_reserved_ := Inventory_Part_In_Stock_API.Is_Reserved_At_Any_Location(part_no_,
                                                                                  NULL,
                                                                                  lot_batch_no_);
   IF (lot_batch_reserved_) THEN
      Error_SYS.Record_General(lu_name_, 'LOTRESERVED: There exists at least one reservation in inventory for lot :P1 of part :P2 . Condition code can not be changed.',lot_batch_no_, part_no_);
   END IF;

   FOR key_rec_ IN get_keys(part_no_, lot_batch_no_) LOOP
      IF (key_rec_.serial_no != '*') THEN
         Error_SYS.Record_General(lu_name_, 'SERIALANDLOT: part :P1 is serial tracked. Change of condition code can only be made on the serial level.',part_no_);
      END IF;

      part_rec_ := Inventory_Part_API.Get(key_rec_.contract, part_no_);

      IF (part_rec_.inventory_part_cost_level = 'COST PER CONDITION') THEN
         Validate_Cost_Level(part_rec_);

         OPEN get_condition_code_keys(key_rec_.contract,
                                      part_no_,
                                      key_rec_.configuration_id,
                                      new_condition_code_,
                                      lot_batch_no_);

         FETCH get_condition_code_keys INTO cc_lot_batch_no_, cc_serial_no_;

         IF (get_condition_code_keys%FOUND) THEN
            condition_code_keys_found_ := TRUE;
         ELSE
            condition_code_keys_found_ := FALSE;
         END IF;

         CLOSE get_condition_code_keys;

         IF (condition_code_keys_found_) THEN
            old_cost_detail_tab_ := Get_Cost_Detail_Tab___(key_rec_.contract,
                                                           part_no_,
                                                           key_rec_.configuration_id,
                                                           lot_batch_no_,
                                                           key_rec_.serial_no);

            new_cost_detail_tab_ := Get_Cost_Detail_Tab___(key_rec_.contract,
                                                           part_no_,
                                                           key_rec_.configuration_id,
                                                           cc_lot_batch_no_,
                                                           cc_serial_no_);
            Modify_Cost_Details___(new_cost_detail_tab_,
                                   old_cost_detail_tab_,
                                   key_rec_.contract,
                                   part_no_,
                                   key_rec_.configuration_id,
                                   lot_batch_no_,
                                   key_rec_.serial_no,
                                   part_rec_.zero_cost_flag,
                                   part_rec_.inventory_part_cost_level,
                                   part_rec_.inventory_valuation_method);
         END IF;
      END IF;
   END LOOP;
END Handle_Lot_Condition_Change;


-- Handle_Serial_Condition_Change
--   This public method must only be used from InventConditionCodeUtil in
--   Invent when the condition code has been changed on a PartSerialCatalog record.
PROCEDURE Handle_Serial_Condition_Change (
   part_no_            IN VARCHAR2,
   serial_no_          IN VARCHAR2,
   new_condition_code_ IN VARCHAR2 )
IS
   new_cost_detail_tab_       Cost_Detail_Tab;
   old_cost_detail_tab_       Cost_Detail_Tab;
   condition_code_keys_found_ BOOLEAN;
   serial_reserved_           BOOLEAN;
   part_rec_                  Inventory_Part_API.Public_Rec;
   cc_lot_batch_no_           INVENTORY_PART_UNIT_COST_TAB.lot_batch_no%TYPE;
   cc_serial_no_              INVENTORY_PART_UNIT_COST_TAB.serial_no%TYPE;

   CURSOR get_keys (part_no_   IN VARCHAR2,
                    serial_no_ IN VARCHAR2) IS
      SELECT DISTINCT contract, configuration_id, lot_batch_no
      FROM  INVENTORY_PART_UNIT_COST_TAB
      WHERE part_no   = part_no_
        AND serial_no = serial_no_;

   CURSOR get_condition_code_keys (contract_          IN VARCHAR2,
                                   part_no_           IN VARCHAR2,
                                   configuration_id_  IN VARCHAR2,
                                   condition_code_    IN VARCHAR2,
                                   current_serial_no_ IN VARCHAR2) IS
      SELECT ipuc.lot_batch_no, ipuc.serial_no
      FROM  INVENTORY_PART_UNIT_COST_TAB ipuc, part_serial_catalog_pub pscp
      WHERE ipuc.part_no          = pscp.part_no
        AND ipuc.serial_no        = pscp.serial_no
        AND ipuc.configuration_id = configuration_id_
        AND ipuc.contract         = contract_
        AND pscp.part_no          = part_no_
        AND pscp.serial_no       != current_serial_no_
        AND pscp.condition_code   = condition_code_;
BEGIN
   serial_reserved_ := Inventory_Part_In_Stock_API.Is_Reserved_At_Any_Location(part_no_,
                                                                               serial_no_,
                                                                               NULL);
   IF (serial_reserved_) THEN
      Error_SYS.Record_General(lu_name_, 'SERIALRESERVED: Serial :P1 of part :P2 is reserved in inventory. Condition code can not be changed.', serial_no_, part_no_);
   END IF;

   FOR key_rec_ IN get_keys(part_no_, serial_no_) LOOP
      part_rec_ := Inventory_Part_API.Get(key_rec_.contract, part_no_);

      IF (part_rec_.inventory_part_cost_level = 'COST PER CONDITION') THEN
         Validate_Cost_Level(part_rec_);
         
         OPEN get_condition_code_keys(key_rec_.contract,
                                      part_no_,
                                      key_rec_.configuration_id,
                                      new_condition_code_,
                                      serial_no_);

         FETCH get_condition_code_keys INTO cc_lot_batch_no_, cc_serial_no_;

         IF (get_condition_code_keys%FOUND) THEN
            condition_code_keys_found_ := TRUE;
         ELSE
            condition_code_keys_found_ := FALSE;
         END IF;

         CLOSE get_condition_code_keys;

         IF (condition_code_keys_found_) THEN
            old_cost_detail_tab_ := Get_Cost_Detail_Tab___(key_rec_.contract,
                                                           part_no_,
                                                           key_rec_.configuration_id,
                                                           key_rec_.lot_batch_no,
                                                           serial_no_);

            new_cost_detail_tab_ := Get_Cost_Detail_Tab___(key_rec_.contract,
                                                           part_no_,
                                                           key_rec_.configuration_id,
                                                           cc_lot_batch_no_,
                                                           cc_serial_no_);
            Modify_Cost_Details___(new_cost_detail_tab_,
                                   old_cost_detail_tab_,
                                   key_rec_.contract,
                                   part_no_,
                                   key_rec_.configuration_id,
                                   key_rec_.lot_batch_no,
                                   serial_no_,
                                   part_rec_.zero_cost_flag,
                                   part_rec_.inventory_part_cost_level,
                                   part_rec_.inventory_valuation_method);
         END IF;
      END IF;
   END LOOP;
END Handle_Serial_Condition_Change;

PROCEDURE Validate_Cost_Level (
   part_rec_    Inventory_Part_API.Public_Rec )
   IS
   BEGIN                                 
      IF (part_rec_.inventory_valuation_method NOT IN ('ST','AV')) THEN
         Error_SYS.Record_General(lu_name_, 'METLEVELERR: This operation can not handle part cost level :P1 for inventory valuation method :P2.',
                                  Inventory_Part_Cost_Level_API.Decode(part_rec_.inventory_part_cost_level),
                                  Inventory_Value_Method_API.Decode(part_rec_.inventory_valuation_method));
      END IF;      

   END Validate_Cost_Level;


-- Manage_Standard_Cost
--   This method deals with all aspects of maintaining the correct standard
--   cost details for an inventory part, or configuraton, or lot, or serial.
--   The method takes care of the standard cost maintenance for all cost levels.
--   If a standard cost is already established for the parameter sent in, then
--   the method will return the standard cost. Otherwise it will use the
--   unit_cost passed in to create the appropriate standard cost details
--   by calling Costing and the adding correct cost source ID's and OH
--   accounting year to the details.
PROCEDURE Manage_Standard_Cost (
   cost_detail_tab_    IN OUT Cost_Detail_Tab,
   unit_cost_          IN     NUMBER,
   contract_           IN     VARCHAR2,
   part_no_            IN     VARCHAR2,
   configuration_id_   IN     VARCHAR2,
   lot_batch_no_       IN     VARCHAR2,
   serial_no_          IN     VARCHAR2,
   condition_code_     IN     VARCHAR2,
   inventory_part_rec_ IN     Inventory_Part_API.Public_Rec,
   source_ref1_        IN     VARCHAR2,
   source_ref2_        IN     VARCHAR2,
   source_ref3_        IN     VARCHAR2,
   source_ref4_        IN     NUMBER,
   source_ref_type_db_ IN     VARCHAR2,
   company_            IN     VARCHAR2,
   put_to_transit_     IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   IF (inventory_part_rec_.inventory_valuation_method != 'ST') THEN
      Error_SYS.Record_General(lu_name_, 'VALMETERR: This operation is only allowed when the :P1 valuation method is used.', Inventory_Value_Method_API.Decode('ST'));
   END IF;

   IF (inventory_part_rec_.inventory_part_cost_level IN ('COST PER CONDITION',
                                                         'COST PER LOT BATCH',
                                                         'COST PER SERIAL'    )) THEN
      Manage_Con_Lot_Ser_Std_Cost___(cost_detail_tab_,
                                     unit_cost_,
                                     contract_,
                                     part_no_,
                                     configuration_id_,
                                     lot_batch_no_,
                                     serial_no_,
                                     condition_code_,
                                     inventory_part_rec_,
                                     source_ref1_,
                                     source_ref2_,
                                     source_ref3_,
                                     source_ref4_,
                                     source_ref_type_db_,
                                     company_);

   ELSIF (inventory_part_rec_.inventory_part_cost_level IN ('COST PER PART',
                                                            'COST PER CONFIGURATION')) THEN
      Manage_Part_Config_Std_Cost___(cost_detail_tab_,
                                     unit_cost_,
                                     contract_,
                                     part_no_,
                                     configuration_id_,
                                     inventory_part_rec_,
                                     source_ref1_,
                                     source_ref2_,
                                     source_ref3_,
                                     source_ref4_,
                                     source_ref_type_db_,
                                     company_,
                                     put_to_transit_);
   ELSE
      Raise_Cost_Level_Not_Supp___(inventory_part_rec_.inventory_part_cost_level);
   END IF;
END Manage_Standard_Cost;


-- Modify_Average_Cost
--   A single purpose method designed to be used from InventoryTransactionHist.
--   The method performs recalculation of the weighted average purchase cost for the part.
PROCEDURE Modify_Average_Cost (
   pre_trans_level_qty_in_stock_     OUT NUMBER,
   pre_trans_level_qty_in_transi_    OUT NUMBER,
   pre_trans_avg_cost_detail_tab_    OUT Cost_Detail_Tab,
   trans_cost_detail_tab_         IN OUT Cost_Detail_Tab,
   trans_unit_cost_               IN     NUMBER,
   trans_quantity_                IN     NUMBER,
   contract_                      IN     VARCHAR2,
   part_no_                       IN     VARCHAR2,
   configuration_id_              IN     VARCHAR2,
   lot_batch_no_                  IN     VARCHAR2,
   serial_no_                     IN     VARCHAR2,
   condition_code_                IN     VARCHAR2,
   inventory_part_rec_            IN     Inventory_Part_API.Public_Rec,
   source_ref1_                   IN     VARCHAR2,
   source_ref2_                   IN     VARCHAR2,
   source_ref3_                   IN     VARCHAR2,
   source_ref4_                   IN     NUMBER,
   source_ref_type_db_            IN     VARCHAR2,
   company_                       IN     VARCHAR2 )
IS
BEGIN
   IF (inventory_part_rec_.inventory_valuation_method != 'AV') THEN
      Raise_Value_Method_Not_Supp___(inventory_part_rec_.inventory_valuation_method);
   END IF;

   IF (inventory_part_rec_.inventory_part_cost_level = 'COST PER CONDITION') THEN

      Modify_Condition_Avg_Cost___(pre_trans_level_qty_in_stock_,
                                   pre_trans_level_qty_in_transi_,
                                   pre_trans_avg_cost_detail_tab_,
                                   trans_cost_detail_tab_,
                                   trans_unit_cost_,
                                   trans_quantity_,
                                   contract_,
                                   part_no_,
                                   configuration_id_,
                                   lot_batch_no_,
                                   serial_no_,
                                   condition_code_,
                                   inventory_part_rec_,
                                   source_ref1_,
                                   source_ref2_,
                                   source_ref3_,
                                   source_ref4_,
                                   source_ref_type_db_,
                                   company_);

   ELSIF (inventory_part_rec_.inventory_part_cost_level = 'COST PER CONFIGURATION') THEN
      Modify_Config_Avg_Cost___(pre_trans_level_qty_in_stock_,
                                pre_trans_level_qty_in_transi_,
                                pre_trans_avg_cost_detail_tab_,
                                trans_cost_detail_tab_,
                                trans_unit_cost_,
                                trans_quantity_,
                                contract_,
                                part_no_,
                                configuration_id_,
                                inventory_part_rec_,
                                source_ref1_,
                                source_ref2_,
                                source_ref3_,
                                source_ref4_,
                                source_ref_type_db_,
                                company_);

   ELSIF (inventory_part_rec_.inventory_part_cost_level = 'COST PER LOT BATCH') THEN
      Modify_Lot_Batch_Avg_Cost___(pre_trans_level_qty_in_stock_,
                                   pre_trans_level_qty_in_transi_,
                                   pre_trans_avg_cost_detail_tab_,
                                   trans_cost_detail_tab_,
                                   trans_unit_cost_,
                                   trans_quantity_,
                                   contract_,
                                   part_no_,
                                   configuration_id_,
                                   lot_batch_no_,
                                   serial_no_,
                                   inventory_part_rec_,
                                   source_ref1_,
                                   source_ref2_,
                                   source_ref3_,
                                   source_ref4_,
                                   source_ref_type_db_,
                                   company_);

   ELSIF (inventory_part_rec_.inventory_part_cost_level = 'COST PER PART') THEN
      Modify_Part_Avg_Cost___(pre_trans_level_qty_in_stock_,
                              pre_trans_level_qty_in_transi_,
                              pre_trans_avg_cost_detail_tab_,
                              trans_cost_detail_tab_,
                              trans_unit_cost_,
                              trans_quantity_,
                              contract_,
                              part_no_,
                              configuration_id_,
                              inventory_part_rec_,
                              source_ref1_,
                              source_ref2_,
                              source_ref3_,
                              source_ref4_,
                              source_ref_type_db_,
                              company_);
   ELSE
      Raise_Cost_Level_Not_Supp___(inventory_part_rec_.inventory_part_cost_level);
   END IF;
END Modify_Average_Cost;


-- New_Configuration
--   Creates a record for a new configuration.
PROCEDURE New_Configuration (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2 )
IS
   part_rec_            Inventory_Part_API.Public_Rec;
   unit_cost_           NUMBER  := 0;
   use_est_mtrl_cost_   BOOLEAN :=FALSE;
   old_cost_detail_tab_ Cost_Detail_Tab;
   new_cost_detail_tab_ Cost_Detail_Tab;
BEGIN
   part_rec_ := Inventory_Part_API.Get(contract_, part_no_);

   IF (part_rec_.inventory_valuation_method IN ('ST', 'AV')) THEN
      IF (part_rec_.inventory_part_cost_level = 'COST PER PART') THEN
         IF (configuration_id_ != '*') THEN
            -- IF the cost level is 'COST PER PART' then all configurations
            -- must have the same inventory_value as the '*' configuration.
            new_cost_detail_tab_ := Get_Cost_Detail_Tab___(contract_,
                                                           part_no_,
                                                           '*',
                                                           '*',
                                                           '*');
         ELSE
            IF ((part_rec_.inventory_valuation_method = 'ST') AND
                (part_rec_.zero_cost_flag IN ('Y','N'))) THEN
               -- Valuation method is Standard Cost, cost level is Cost Per Part,
               -- configuration_id is = '*' and it is allowed to have an inventory_value
               -- greater than zero. Use estimated material and get details from Costing.
               use_est_mtrl_cost_ := TRUE;
            END IF;
         END IF;
      ELSIF (part_rec_.inventory_part_cost_level = 'COST PER CONFIGURATION') THEN
         IF ((part_rec_.inventory_valuation_method = 'ST') AND
             (part_rec_.zero_cost_flag IN ('Y','N'))) THEN
            -- Valuation method is Standard Cost, cost level is Cost Per Configuration,
            -- and it is allowed to have an inventory_value greater than zero.
            -- Use estimated material cost and get details from Costing.
            use_est_mtrl_cost_ := TRUE;
         END IF;
      END IF;
   END IF;

   IF (use_est_mtrl_cost_) THEN
      unit_cost_ := Inventory_Part_Config_API.Get_Estimated_Material_Cost(contract_,
                                                                          part_no_,
                                                                          configuration_id_);
   END IF;

   IF (new_cost_detail_tab_.COUNT = 0) THEN
      new_cost_detail_tab_ := Generate_New_Cost_Details___(unit_cost_,
                                                           TRUE,
                                                           contract_,
                                                           part_no_,
                                                           configuration_id_,
                                                           part_rec_ );
   END IF;

   old_cost_detail_tab_ := Get_Cost_Details_And_Lock___(contract_,
                                                        part_no_,
                                                        configuration_id_,
                                                        '*',
                                                        '*');
   Modify_Cost_Details___(new_cost_detail_tab_,
                          old_cost_detail_tab_,
                          contract_,
                          part_no_,
                          configuration_id_,
                          '*',
                          '*',
                          part_rec_.zero_cost_flag,
                          part_rec_.inventory_part_cost_level,
                          part_rec_.inventory_valuation_method);
END New_Configuration;


-- Set_Actual_Cost
--   This is a single purpose method that must only be used by the Actual
--   Costing calculation. It is used to modify the unit cost of a part
--   having inventory valution method Standard Cost and that is Actual
--   Costing enabled. This method must not under any circumstances be used
--   for any other purpose than the Actual Costing calculation background job.
PROCEDURE Set_Actual_Cost (
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   configuration_id_    IN VARCHAR2,
   lot_batch_no_        IN VARCHAR2,
   condition_code_      IN VARCHAR2,
   new_cost_detail_tab_ IN Cost_Detail_Tab )
IS
   part_rec_ Inventory_Part_API.Public_Rec;
BEGIN

   part_rec_ := Inventory_Part_API.Get(contract_, part_no_);

   IF (((part_rec_.inventory_valuation_method = 'ST') AND
        (part_rec_.invoice_consideration = 'PERIODIC WEIGHTED AVERAGE')) OR
       (part_rec_.inventory_valuation_method = 'AV')) THEN
      -- Everything is ok.
      NULL;
   ELSE
      Error_SYS.Record_General(lu_name_, 'STANDACONLY: Set_Actual_Cost should only be used to modify the inventory value as part of the periodic weighted average or transaction based invoice consideration processes.');
   END IF;

   IF (part_rec_.inventory_part_cost_level = 'COST PER PART') THEN
      Set_Part_Actual_Cost___(contract_,
                              part_no_,
                              part_rec_,
                              new_cost_detail_tab_);

   ELSIF (part_rec_.inventory_part_cost_level = 'COST PER CONFIGURATION') THEN
      Set_Config_Actual_Cost___(contract_,
                                part_no_,
                                configuration_id_,
                                part_rec_,
                                new_cost_detail_tab_);

   ELSIF (part_rec_.inventory_part_cost_level = 'COST PER LOT BATCH') THEN
      Set_Lot_Batch_Actual_Cost___(contract_,
                                   part_no_,
                                   configuration_id_,
                                   lot_batch_no_,
                                   part_rec_,
                                   new_cost_detail_tab_);

   ELSIF (part_rec_.inventory_part_cost_level = 'COST PER CONDITION') THEN
      Set_Condition_Actual_Cost___(contract_,
                                   part_no_,
                                   configuration_id_,
                                   condition_code_,
                                   part_rec_,
                                   new_cost_detail_tab_);
   ELSE
      Error_SYS.Record_General(lu_name_, 'SACLEVERR: Method Set_Actual_Cost does not support parts having :P1.',Inventory_Part_Cost_Level_API.Decode(part_rec_.inventory_part_cost_level));
   END IF;
END Set_Actual_Cost;


-- Handle_Lot_Batch_Removal
--   This public method must only be used from LotBatchMaster in
--   PartCatalog when a LotBatchMaster record has been removed.
PROCEDURE Handle_Lot_Batch_Removal (
   part_no_      IN VARCHAR2,
   lot_batch_no_ IN VARCHAR2 )
IS
   CURSOR get_keys (part_no_      IN VARCHAR2,
                    lot_batch_no_ IN VARCHAR2) IS
      SELECT DISTINCT contract, configuration_id, serial_no
        FROM INVENTORY_PART_UNIT_COST_TAB
       WHERE part_no      = part_no_
         AND lot_batch_no = lot_batch_no_;
BEGIN

   FOR key_rec_ IN get_keys(part_no_, lot_batch_no_) LOOP
      Remove_All_Cost_Details___(key_rec_.contract,
                                 part_no_,
                                 key_rec_.configuration_id,
                                 lot_batch_no_,
                                 key_rec_.serial_no);
   END LOOP;
END Handle_Lot_Batch_Removal;


-- Handle_Serial_Removal
--   This public method must only be used from PartSerialCatalog in
--   PartCatalog when aPartSerialCatalog has been removed.
PROCEDURE Handle_Serial_Removal (
   part_no_   IN VARCHAR2,
   serial_no_ IN VARCHAR2 )
IS

   CURSOR get_keys (part_no_   IN VARCHAR2,
                    serial_no_ IN VARCHAR2) IS
      SELECT DISTINCT contract, configuration_id, lot_batch_no
        FROM INVENTORY_PART_UNIT_COST_TAB
       WHERE part_no   = part_no_
         AND serial_no = serial_no_;
BEGIN

   FOR key_rec_ IN get_keys(part_no_, serial_no_) LOOP

      Remove_All_Cost_Details___(key_rec_.contract,
                                 part_no_,
                                 key_rec_.configuration_id,
                                 key_rec_.lot_batch_no,
                                 serial_no_);
   END LOOP;
END Handle_Serial_Removal;


-- Handle_Part_Cost_Level_Change
--   This method is called from LU InventoryPart every time a value change
--   occurs on attribute inventory_part_cost_level.
PROCEDURE Handle_Part_Cost_Level_Change (
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   old_part_cost_level_ IN VARCHAR2,
   new_part_cost_level_ IN VARCHAR2 )
IS
BEGIN

   Inventory_Part_Cost_Level_API.Exist_Db(old_part_cost_level_);
   Inventory_Part_Cost_Level_API.Exist_Db(new_part_cost_level_);

   IF (old_part_cost_level_ = 'COST PER PART') THEN
      IF (new_part_cost_level_ = 'COST PER CONFIGURATION') THEN
--       **********************************************************
--       *  Nothing needs to be done when changing level from     *
--       *  'COST PER PART' to 'COST PER CONFIGURATION' since we  *
--       *  store a separate cost record for each configuration   *
--       *  also when the cost level is 'COST PER PART'.          *
--       **********************************************************
         NULL;
      END IF;
      IF (new_part_cost_level_ IN ('COST PER CONDITION',
                                   'COST PER LOT BATCH',
                                   'COST PER SERIAL'    )) THEN
         Generate_Lot_Batch_Serial___(contract_, part_no_);
      END IF;
   END IF;

   IF (old_part_cost_level_ = 'COST PER CONFIGURATION') THEN
      IF (new_part_cost_level_ = 'COST PER PART') THEN
         Apply_Part_Level_Cost___(contract_, part_no_);
      END IF;
      IF (new_part_cost_level_ IN ('COST PER CONDITION',
                                   'COST PER LOT BATCH',
                                   'COST PER SERIAL'    )) THEN
         Generate_Lot_Batch_Serial___(contract_, part_no_);
      END IF;
   END IF;

   IF (old_part_cost_level_ = 'COST PER CONDITION') THEN
      IF (new_part_cost_level_ = 'COST PER PART') THEN
         Remove_Lot_Batch_Serial___(contract_, part_no_);
         Apply_Part_Level_Cost___(contract_, part_no_);
      END IF;
      IF (new_part_cost_level_ = 'COST PER CONFIGURATION') THEN
         Remove_Lot_Batch_Serial___(contract_, part_no_);
      END IF;
      IF (new_part_cost_level_ IN ('COST PER LOT BATCH',
                                   'COST PER SERIAL'    )) THEN
--       **********************************************************
--       *  Nothing needs to be done when changing level from     *
--       *  'COST PER CONDITION' to 'COST PER LOT BATCH' or       *
--       *  'COST PER SERIAL' since we store a separate cost      *
--       *  record for each lot/serial/configuration combination  *
--       *  also when the cost level is 'COST PER CONDITION'.     *
--       **********************************************************
         NULL;
      END IF;
   END IF;

   IF (old_part_cost_level_ = 'COST PER LOT BATCH') THEN
      IF (new_part_cost_level_ = 'COST PER PART') THEN
         Remove_Lot_Batch_Serial___(contract_, part_no_);
         Apply_Part_Level_Cost___(contract_, part_no_);
      END IF;
      IF (new_part_cost_level_ = 'COST PER CONFIGURATION') THEN
         Remove_Lot_Batch_Serial___(contract_, part_no_);
      END IF;
      IF (new_part_cost_level_ = 'COST PER CONDITION') THEN
         Apply_Condition_Level_Cost___(contract_, part_no_);
      END IF;
      IF (new_part_cost_level_ = 'COST PER SERIAL') THEN
--       **********************************************************
--       *  Nothing needs to be done when changing level from     *
--       *  'COST PER LOT BATCH' to 'COST PER SERIAL' since we    *
--       *  store a separate cost record for each                 *
--       *  lot/serial/configuration combination also when the    *
--       *  cost level is 'COST PER LOT BATCH'.                   *
--       **********************************************************
         NULL;
      END IF;
   END IF;

   IF (old_part_cost_level_ = 'COST PER SERIAL') THEN
      IF (new_part_cost_level_ = 'COST PER PART') THEN
         Remove_Lot_Batch_Serial___(contract_, part_no_);
         Apply_Part_Level_Cost___(contract_, part_no_);
      END IF;
      IF (new_part_cost_level_ = 'COST PER CONFIGURATION') THEN
         Remove_Lot_Batch_Serial___(contract_, part_no_);
      END IF;
      IF (new_part_cost_level_ = 'COST PER CONDITION') THEN
         Apply_Condition_Level_Cost___(contract_, part_no_);
      END IF;
      IF (new_part_cost_level_ = 'COST PER LOT BATCH') THEN
         Apply_Lot_Batch_Level_Cost___(contract_, part_no_);
      END IF;
   END IF;
END Handle_Part_Cost_Level_Change;


-- Modify_Serial_Cost
--   method can be used to modify the unit cost of a specific individual
--   (serial) of a part on a site. It can only be used when the part cost
--   level is Cost per Serial.
PROCEDURE Modify_Serial_Cost (
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   configuration_id_    IN VARCHAR2,
   lot_batch_no_        IN VARCHAR2,
   serial_no_           IN VARCHAR2,
   new_cost_detail_tab_ IN Cost_Detail_Tab )
IS
   inventory_part_rec_ Inventory_Part_API.Public_Rec;
BEGIN

   Site_API.Exist(contract_);
   Part_Catalog_API.Exist(part_no_);
   Inventory_Part_API.Exist(contract_, part_no_);

   inventory_part_rec_ := Inventory_Part_API.Get(contract_, part_no_);

   Modify_Serial_Cost___(contract_,
                         part_no_,
                         inventory_part_rec_,
                         configuration_id_,
                         lot_batch_no_,
                         serial_no_,
                         new_cost_detail_tab_,
                         TRUE);
END Modify_Serial_Cost;


-- Remove
--   If a record exists, this method will remove that record from the database
PROCEDURE Remove (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   serial_no_        IN VARCHAR2 )
IS
   part_rec_       Inventory_Part_API.Public_Rec;
   exit_procedure_ EXCEPTION;
BEGIN

   IF ((lot_batch_no_ = '*') AND
       (serial_no_    = '*')) THEN
      RAISE exit_procedure_;
   END IF;

   part_rec_ := Inventory_Part_API.Get(contract_, part_no_);

   IF (part_rec_.inventory_valuation_method NOT IN ('ST','AV')) THEN
      RAISE exit_procedure_;
   END IF;

   IF (part_rec_.inventory_part_cost_level NOT IN ('COST PER CONDITION',
                                                   'COST PER LOT BATCH',
                                                   'COST PER SERIAL')) THEN
      RAISE exit_procedure_;
   END IF;
   
   IF (Invent_Part_Quantity_Util_API.Check_Quantity_Exist(contract_,
                                                          part_no_,
                                                          configuration_id_,
                                                          lot_batch_no_,
                                                          serial_no_)) THEN
      RAISE exit_procedure_;
   END IF;

   Remove_All_Cost_Details___(contract_,
                              part_no_,
                              configuration_id_,
                              lot_batch_no_,
                              serial_no_);
EXCEPTION
   WHEN exit_procedure_ THEN
      NULL;
END Remove;


-- Find_And_Modify_Serial_Cost
--   method can be used to modify the unit cost of a specific individual
--   (serial) of a part on a site. It can only be used when the part cost
--   level is Cost per Serial.
PROCEDURE Find_And_Modify_Serial_Cost (
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   serial_no_           IN VARCHAR2,
   new_cost_detail_tab_ IN Cost_Detail_Tab,
   revalue_inventory_   IN BOOLEAN )
IS
   inventory_part_rec_ Inventory_Part_API.Public_Rec;

   CURSOR get_serial_records IS
      SELECT DISTINCT configuration_id, lot_batch_no
      FROM INVENTORY_PART_UNIT_COST_TAB
      WHERE contract  = contract_
        AND part_no   = part_no_
        AND serial_no = serial_no_;
BEGIN

   Site_API.Exist(contract_);
   Part_Catalog_API.Exist(part_no_);
   Inventory_Part_API.Exist(contract_, part_no_);

   inventory_part_rec_ := Inventory_Part_API.Get(contract_, part_no_);

   FOR rec_ IN get_serial_records LOOP
      -- There should always only be zero or one record found by the cursor
      -- The FOR LOOP is used because it makes the code ceaner and easier to read.
      Modify_Serial_Cost___(contract_,
                            part_no_,
                            inventory_part_rec_,
                            rec_.configuration_id,
                            rec_.lot_batch_no,
                            serial_no_,
                            new_cost_detail_tab_,
                            revalue_inventory_);
   END LOOP;
END Find_And_Modify_Serial_Cost;


-- Lock_By_Keys_Wait
--   this method locks all cost details for a specific contract, part_no,
--   configuration_id, lot_batch_no and serial_no combination for update nowait.
--   If the record is already locked the method will wait until the previous
--   lock is released.
PROCEDURE Lock_By_Keys_Wait (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   serial_no_        IN VARCHAR2 )
IS
   dummy_ Cost_Detail_Tab;
BEGIN

   dummy_ := Get_Cost_Details_And_Lock___(contract_,
                                          part_no_,
                                          configuration_id_,
                                          lot_batch_no_,
                                          serial_no_);
END Lock_By_Keys_Wait;


-- Lock_By_Keys_No_Wait
--   this method locks all cost details for a specific contract, part_no,
--   configuration_id, lot_batch_no and serial_no combination for update nowait.
PROCEDURE Lock_By_Keys_No_Wait (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   serial_no_        IN VARCHAR2 )
IS
   objid_           INVENTORY_PART_UNIT_COST.objid%TYPE;
   objversion_      INVENTORY_PART_UNIT_COST.objversion%TYPE;
   dummy_           INVENTORY_PART_UNIT_COST_TAB%ROWTYPE;
   cost_detail_tab_ Cost_Detail_Tab;
BEGIN

   cost_detail_tab_ := Get_Cost_Detail_Tab___(contract_,
                                              part_no_,
                                              configuration_id_,
                                              lot_batch_no_,
                                              serial_no_);
   IF (cost_detail_tab_.COUNT > 0) THEN
      FOR i IN cost_detail_tab_.FIRST..cost_detail_tab_.LAST LOOP

         Get_Id_Version_By_Keys___(objid_,
                                   objversion_,
                                   contract_,
                                   part_no_,
                                   configuration_id_,
                                   lot_batch_no_,
                                   serial_no_,
                                   cost_detail_tab_(i).accounting_year,
                                   cost_detail_tab_(i).cost_bucket_id,
                                   cost_detail_tab_(i).company,
                                   cost_detail_tab_(i).cost_source_id);

         dummy_ := Lock_By_Id___(objid_, objversion_);
      END LOOP;
   END IF;
END Lock_By_Keys_No_Wait;


-- Modify_Standard_Cost
--   This method creates and store new standard cost details for a part
--   or a configuration. The unit cost that is passed in is transformed
--   into a cost detail tab by the help of Costing.
PROCEDURE Modify_Standard_Cost (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   unit_cost_        IN NUMBER )
IS
   new_cost_detail_tab_ Cost_Detail_Tab;
   inventory_part_rec_  Inventory_Part_API.Public_Rec;
BEGIN

   inventory_part_rec_ := Inventory_Part_API.Get(contract_, part_no_);

   new_cost_detail_tab_ := Generate_New_Cost_Details___(unit_cost_,
                                                        TRUE,
                                                        contract_,
                                                        part_no_,
                                                        configuration_id_,
                                                        inventory_part_rec_ );
   Modify_Standard_Cost_Details(contract_,
                                part_no_,
                                configuration_id_,
                                new_cost_detail_tab_);
END Modify_Standard_Cost;


-- Modify_Standard_Cost_Details
--   This method modifies the standard cost details for a part or a
--   configuration. Revaulation of inventory takes place if necessary.
--   Transactions and postings are created accordingly.
PROCEDURE Modify_Standard_Cost_Details (
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   configuration_id_    IN VARCHAR2,
   new_cost_detail_tab_ IN Cost_Detail_Tab )
IS
   local_new_cost_detail_tab_ Cost_Detail_Tab;
   part_rec_                  Inventory_Part_API.Public_Rec;
   configuration_id_temp_     INVENTORY_PART_UNIT_COST_TAB.configuration_id%TYPE;

   CURSOR get_keys (contract_         IN VARCHAR2,
                    part_no_          IN VARCHAR2,
                    configuration_id_ IN VARCHAR2) IS
      SELECT DISTINCT configuration_id, lot_batch_no, serial_no
        FROM INVENTORY_PART_UNIT_COST_TAB
       WHERE  contract         = contract_
         AND  part_no          = part_no_
         AND (configuration_id = configuration_id_ OR configuration_id_ IS NULL);
BEGIN

   part_rec_ := Inventory_Part_API.Get(contract_, part_no_);

   IF (part_rec_.inventory_valuation_method != 'ST') THEN
      Error_SYS.Record_General(lu_name_, 'VALUEMETERR: This operation is only allowed when the inventory valuation method is :P1.',Inventory_Value_Method_API.Decode('ST'));
   END IF;

   IF (part_rec_.inventory_part_cost_level NOT IN ('COST PER PART','COST PER CONFIGURATION')) THEN
      Error_SYS.Record_General(lu_name_, 'LEVELERR: This operation is only allowed when the part cost level is :P1 or :P2.',
                               Inventory_Part_Cost_Level_API.Decode('COST PER PART'),
                               Inventory_Part_Cost_Level_API.Decode('COST PER CONFIGURATION'));
   END IF;

   IF (part_rec_.invoice_consideration != 'IGNORE INVOICE PRICE') THEN
      Error_SYS.Record_General(lu_name_,'ACERROR: This operation is only allowed when Supplier Invoice Consideration is set to :P1.', Invoice_Consideration_API.Decode('IGNORE INVOICE PRICE'));
   END IF;

   IF ((part_rec_.inventory_part_cost_level = 'COST PER PART') AND (configuration_id_ = '*')) THEN
      configuration_id_temp_ := NULL;
   ELSE
      configuration_id_temp_ := configuration_id_;
   END IF;

   local_new_cost_detail_tab_ := Merge_And_Complete_Details(new_cost_detail_tab_,
                                                            part_rec_,
                                                            contract_,
                                                            part_no_,
                                                            Site_API.Get_Company(contract_),
                                                            '*',
                                                            NULL,
                                                            NULL,
                                                            NULL,
                                                            NULL,
                                                            NULL);
   FOR key_rec_ IN get_keys(contract_,
                            part_no_,
                            configuration_id_temp_) LOOP

      Modify_Details_And_Revalue___(contract_,
                                    part_no_,
                                    key_rec_.configuration_id,
                                    key_rec_.lot_batch_no,
                                    key_rec_.serial_no,
                                    part_rec_.inventory_part_cost_level,
                                    part_rec_.inventory_valuation_method,
                                    part_rec_.invoice_consideration,
                                    part_rec_.zero_cost_flag,
                                    local_new_cost_detail_tab_);
   END LOOP;
END Modify_Standard_Cost_Details;


PROCEDURE Enable_Cost_Details
IS
   inventory_part_rec_ Inventory_Part_API.Public_Rec;

   CURSOR get_parts IS
      SELECT contract, part_no
      FROM inventory_part_tab;

   TYPE Part_Tab IS TABLE OF get_parts%ROWTYPE
      INDEX BY PLS_INTEGER;

   part_tab_ Part_Tab;
BEGIN

   OPEN  get_parts;
   FETCH get_parts BULK COLLECT INTO part_tab_;
   CLOSE get_parts;

   IF (part_tab_.COUNT > 0) THEN
      FOR i IN part_tab_.FIRST..part_tab_.LAST LOOP

         inventory_part_rec_ := Inventory_Part_API.Get(part_tab_(i).contract,
                                                       part_tab_(i).part_no);

         IF (inventory_part_rec_.inventory_valuation_method IN ('FIFO','LIFO')) THEN
            Enable_For_Fifolifo___(part_tab_(i).contract,
                                   part_tab_(i).part_no,
                                   inventory_part_rec_);

         ELSIF (inventory_part_rec_.inventory_valuation_method IN ('ST','AV')) THEN
            Enable_For_Std_Avg___(part_tab_(i).contract,
                                  part_tab_(i).part_no,
                                  inventory_part_rec_);

         ELSE
            Raise_Value_Method_Not_Supp___(inventory_part_rec_.inventory_valuation_method);
         END IF;

         @ApproveTransactionStatement(2012-01-25,GanNLK)
         COMMIT;
      END LOOP;
   END IF;
END Enable_Cost_Details;


-- Check_Insert
--   Validates a new record.
PROCEDURE Check_Insert (
   accounting_year_ IN VARCHAR2,
   contract_        IN VARCHAR2,
   part_no_         IN VARCHAR2,
   cost_bucket_id_  IN VARCHAR2,
   company_         IN VARCHAR2,
   cost_source_id_  IN VARCHAR2,
   unit_cost_       IN NUMBER )
IS
   site_company_        INVENTORY_PART_UNIT_COST_TAB.company%TYPE;
   valuation_method_db_ VARCHAR2(50);
   part_cost_level_db_  VARCHAR2(50);
BEGIN

   site_company_ := Site_API.Get_Company(contract_);

   IF (site_company_ != company_) THEN
      Error_Sys.Record_General(lu_name_, 'COMPANYERR: A company mismatch has occured. Site :P1 is connected to company :P2 but the Cost Source is connected to company :P3.', contract_, site_company_, company_);
   END IF;

   Check_Cost_Bucket_Id___(contract_,
                           cost_bucket_id_,
                           cost_source_id_,
                           unit_cost_,
                           part_no_);

   Check_Accounting_Year___(valuation_method_db_,
                            part_cost_level_db_,
                            accounting_year_,
                            contract_,
                            part_no_,
                            cost_bucket_id_);

   Check_Cost_Source_Id___(valuation_method_db_,
                           part_cost_level_db_,
                           contract_,
                           part_no_,
                           cost_source_id_);
END Check_Insert;


@UncheckedAccess
FUNCTION Get_Cost_Details_By_Method (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   serial_no_        IN VARCHAR2 ) RETURN Cost_Detail_Tab
IS
   part_rec_        Inventory_Part_API.Public_Rec;
   cost_detail_tab_ Cost_Detail_Tab;
BEGIN
   part_rec_ := Inventory_Part_API.Get(contract_, part_no_);

   IF (part_rec_.inventory_part_cost_level = 'COST PER PART') THEN
      cost_detail_tab_ := Get_Part_Level_Cost___(contract_,
                                                 part_no_,
                                                 configuration_id_,
                                                 part_rec_.inventory_valuation_method);

   ELSIF (part_rec_.inventory_part_cost_level = 'COST PER CONFIGURATION') THEN
      cost_detail_tab_ := Get_Config_Level_Cost___(contract_,
                                                   part_no_,
                                                   configuration_id_);

   ELSIF (part_rec_.inventory_part_cost_level IN ('COST PER CONDITION',
                                                  'COST PER LOT BATCH',
                                                  'COST PER SERIAL')) THEN
      cost_detail_tab_ := Get_Cond_Lot_Ser_Level_Cost___(contract_,
                                                         part_no_,
                                                         configuration_id_,
                                                         lot_batch_no_,
                                                         serial_no_,
                                                         part_rec_.inventory_part_cost_level);
   ELSE
      NULL;
   END IF;

   RETURN (cost_detail_tab_);
END Get_Cost_Details_By_Method;


-- Get_Default_Details
--   Returns a cost detail tab containing data that is proper to use
--   as default for a new receipt.
FUNCTION Get_Default_Details (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   condition_code_   IN VARCHAR2,
   calling_process_  IN VARCHAR2 ) RETURN Cost_Detail_Tab
IS
   cost_detail_tab_ Cost_Detail_Tab;
   invepart_rec_    Inventory_Part_API.Public_Rec;
BEGIN
   invepart_rec_ := Inventory_Part_API.Get(contract_, part_no_);

   IF (invepart_rec_.zero_cost_flag = 'O') THEN
      cost_detail_tab_(1).accounting_year := '*';
      cost_detail_tab_(1).contract        := contract_;
      cost_detail_tab_(1).cost_bucket_id  := '*';
      cost_detail_tab_(1).company         := Site_API.Get_Company(contract_);
      cost_detail_tab_(1).cost_source_id  := '*';
      cost_detail_tab_(1).unit_cost       := 0;
   ELSE
      IF (invepart_rec_.inventory_part_cost_level = 'COST PER PART') THEN
         cost_detail_tab_ := Get_Default_Part_Details___(contract_,
                                                         part_no_,
                                                         calling_process_,
                                                         invepart_rec_.zero_cost_flag);
   
      ELSIF (invepart_rec_.inventory_part_cost_level = 'COST PER CONFIGURATION') THEN
         cost_detail_tab_ := Get_Default_Config_Details___(contract_,
                                                           part_no_,
                                                           configuration_id_,
                                                           calling_process_,
                                                           invepart_rec_.zero_cost_flag);
   
      ELSIF (invepart_rec_.inventory_part_cost_level = 'COST PER CONDITION') THEN
         cost_detail_tab_ := Get_Default_Cond_Details___(contract_,
                                                         part_no_,
                                                         configuration_id_,
                                                         condition_code_,
                                                         calling_process_);
   
      ELSIF (invepart_rec_.inventory_part_cost_level = 'COST PER LOT BATCH') THEN
         cost_detail_tab_ := Get_Default_Lot_Details___(contract_,
                                                        part_no_,
                                                        configuration_id_,
                                                        lot_batch_no_,
                                                        condition_code_,
                                                        calling_process_);
   
      ELSIF (invepart_rec_.inventory_part_cost_level = 'COST PER SERIAL') THEN
         cost_detail_tab_ := Get_Default_Serial_Details___(contract_,
                                                           part_no_,
                                                           configuration_id_,
                                                           lot_batch_no_,
                                                           serial_no_,
                                                           condition_code_,
                                                           calling_process_);
      ELSE
         Raise_Cost_Level_Not_Supp___(invepart_rec_.inventory_part_cost_level);
      END IF;
   END IF;

   RETURN (cost_detail_tab_);
END Get_Default_Details;


-- Copy_Cost_Details_To_Temporary
--   Fetches a cost detail tab from the database and stores in
--   LU TemporaryPartCostDetail.
PROCEDURE Copy_Cost_Details_To_Temporary (
   cost_detail_id_   OUT NUMBER,
   contract_         IN  VARCHAR2,
   part_no_          IN  VARCHAR2,
   configuration_id_ IN  VARCHAR2,
   lot_batch_no_     IN  VARCHAR2,
   serial_no_        IN  VARCHAR2 )
IS
   cost_detail_tab_ Cost_Detail_Tab;
BEGIN

   cost_detail_tab_ := Get_Cost_Details_By_Method(contract_,
                                                  part_no_,
                                                  configuration_id_,
                                                  lot_batch_no_,
                                                  serial_no_);

   Temporary_Part_Cost_Detail_API.Add_Details(cost_detail_id_,
                                              cost_detail_tab_,
                                              part_no_);
END Copy_Cost_Details_To_Temporary;


-- Standard_Cost_Exist
--   This method checks if a standard cost is already established for
--   the cost level set on the part.
FUNCTION Standard_Cost_Exist (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   condition_code_   IN VARCHAR2 ) RETURN VARCHAR2
IS
   part_rec_                     Inventory_Part_API.Public_Rec;
   standard_cost_exist_          BOOLEAN := FALSE;
   standard_cost_exist_varchar2_ VARCHAR2(5);
BEGIN
   
   part_rec_ := Inventory_Part_API.Get(contract_, part_no_);

   IF (part_rec_.inventory_valuation_method = 'ST') THEN
      IF (part_rec_.inventory_part_cost_level IN ('COST PER CONDITION',
                                                  'COST PER LOT BATCH',
                                                  'COST PER SERIAL'    )) THEN
         standard_cost_exist_ := Cond_Lot_Ser_Std_Cost_Exist___(
                                                              contract_,
                                                              part_no_,
                                                              configuration_id_,
                                                              lot_batch_no_,
                                                              serial_no_,
                                                              condition_code_,
                                                              part_rec_.inventory_part_cost_level);
      ELSE
         standard_cost_exist_ := Part_Config_Std_Cost_Exist___(
                                                              contract_,
                                                              part_no_,
                                                              configuration_id_,
                                                              part_rec_.inventory_part_cost_level);
      END IF;
   END IF;

   IF (standard_cost_exist_) THEN
      standard_cost_exist_varchar2_ := 'TRUE';
   ELSE
      standard_cost_exist_varchar2_ := 'FALSE';
   END IF;

   RETURN (standard_cost_exist_varchar2_);
END Standard_Cost_Exist;


-- Default_Cost_Exist
--   Checks if a default cost exist for the cost level in question.
FUNCTION Default_Cost_Exist (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   condition_code_   IN VARCHAR2,
   calling_process_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   cost_detail_tab_    Cost_Detail_Tab;
   default_cost_exist_ VARCHAR2(5) := 'FALSE';
   inventory_part_rec_ Inventory_Part_API.Public_Rec;
BEGIN

   cost_detail_tab_ := Get_Default_Details(contract_,
                                           part_no_,
                                           configuration_id_,
                                           lot_batch_no_,
                                           serial_no_,
                                           condition_code_,
                                           calling_process_);

   IF (cost_detail_tab_.COUNT > 0) THEN
      IF (Non_Zero_Cost_Detail_Exist(cost_detail_tab_)) THEN
         default_cost_exist_ := 'TRUE';
      ELSE
         inventory_part_rec_ := Inventory_Part_API.Get(contract_, part_no_);
         IF (inventory_part_rec_.zero_cost_flag = 'O') THEN
            default_cost_exist_ := 'TRUE';
         END IF;
      END IF;
   END IF;
   
   RETURN (default_cost_exist_);
END Default_Cost_Exist;


-- Get_Total_Unit_Cost
--   Returns the sum of unit cost on all details in the cost detail tab.
@UncheckedAccess
FUNCTION Get_Total_Unit_Cost (
   cost_detail_tab_ IN Cost_Detail_Tab ) RETURN NUMBER
IS
   total_unit_cost_ NUMBER := 0;
BEGIN
   IF (cost_detail_tab_.COUNT > 0) THEN
      FOR i IN cost_detail_tab_.FIRST..cost_detail_tab_.LAST LOOP
         total_unit_cost_ := total_unit_cost_ + cost_detail_tab_(i).unit_cost;
      END LOOP;
   END IF;

   RETURN (total_unit_cost_);
END Get_Total_Unit_Cost;


-- Modify_Level_Cost
--   Obsolete method that will be removed.
PROCEDURE Modify_Level_Cost (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   condition_code_   IN VARCHAR2,
   new_level_cost_   IN NUMBER )
IS
   inventory_part_rec_  Inventory_Part_API.Public_Rec;
   new_cost_detail_tab_ Cost_Detail_Tab;
   cost_detail_id_      NUMBER;
BEGIN

   Error_Sys.Record_General(lu_name_, 'LEVELDETAIL2: Modification of the part cost on an aggregated level is not allowed the Cost Details functionality is enabled.');

   inventory_part_rec_ := Inventory_Part_API.Get(contract_, part_no_);

   new_cost_detail_tab_ := Generate_New_Cost_Details___(new_level_cost_,
                                                        FALSE,
                                                        contract_,
                                                        part_no_,
                                                        configuration_id_,
                                                        inventory_part_rec_ );

   Temporary_Part_Cost_Detail_API.Add_Details(cost_detail_id_,
                                              new_cost_detail_tab_,
                                              part_no_);

   Modify_Level_Cost_Details(contract_,
                             part_no_,
                             configuration_id_,
                             lot_batch_no_,
                             serial_no_,
                             condition_code_,
                             cost_detail_id_);
END Modify_Level_Cost;


-- Modify_Level_Cost_Details
--   This method is valid for cost levels Cost per Condition, Cost per Lot
--   and Cost per Serial. It modifies the current cost details using the
--   cost details stored in LU TemporaryPartCostDetail.
PROCEDURE Modify_Level_Cost_Details (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   condition_code_   IN VARCHAR2,
   cost_detail_id_   IN NUMBER )
IS
   new_cost_detail_tab_ Cost_Detail_Tab;
   inventory_part_rec_  Inventory_Part_API.Public_Rec;
BEGIN

   inventory_part_rec_ := Inventory_Part_API.Get(contract_, part_no_);

   IF (inventory_part_rec_.inventory_part_cost_level = 'COST PER PART') THEN
      Temporary_Part_Cost_Detail_API.Get_And_Remove_Details(new_cost_detail_tab_,
                                                            cost_detail_id_);
      Modify_Part_Cost___(contract_,
                          part_no_,
                          inventory_part_rec_,
                          new_cost_detail_tab_);

   ELSIF (inventory_part_rec_.inventory_part_cost_level = 'COST PER CONDITION') THEN
      Modify_Condition_Cost___(contract_,
                               part_no_,
                               inventory_part_rec_,
                               configuration_id_,
                               condition_code_,
                               cost_detail_id_);

   ELSIF (inventory_part_rec_.inventory_part_cost_level = 'COST PER LOT BATCH') THEN
      Temporary_Part_Cost_Detail_API.Get_And_Remove_Details(new_cost_detail_tab_,
                                                            cost_detail_id_);
      Modify_Lot_Batch_Cost___(contract_,
                               part_no_,
                               inventory_part_rec_,
                               configuration_id_,
                               lot_batch_no_,
                               new_cost_detail_tab_);

   ELSIF (inventory_part_rec_.inventory_part_cost_level = 'COST PER SERIAL') THEN
      Temporary_Part_Cost_Detail_API.Get_And_Remove_Details(new_cost_detail_tab_,
                                                            cost_detail_id_);
      Modify_Serial_Cost___(contract_,
                            part_no_,
                            inventory_part_rec_,
                            configuration_id_,
                            lot_batch_no_,
                            serial_no_,
                            new_cost_detail_tab_,
                            revalue_inventory_ => TRUE);
                            
   ELSIF (inventory_part_rec_.inventory_part_cost_level = Inventory_Part_Cost_Level_API.DB_COST_PER_CONFIGURATION) THEN
      Temporary_Part_Cost_Detail_API.Get_And_Remove_Details(new_cost_detail_tab_,
                                                            cost_detail_id_);
      Modify_Configuration_Cost___(contract_,
                                   part_no_,
                                   inventory_part_rec_,
                                   configuration_id_,
                                   new_cost_detail_tab_);
                                   
   ELSIF (inventory_part_rec_.inventory_part_cost_level IS NULL) THEN
      Site_API.Exist(contract_);
      Part_Catalog_API.Exist(part_no_);
      Inventory_Part_API.Exist(contract_, part_no_);
      Raise_Cost_Level_Not_Supp___(inventory_part_rec_.inventory_part_cost_level);
   ELSE
      Raise_Cost_Level_Not_Supp___(inventory_part_rec_.inventory_part_cost_level);
   END IF;
END Modify_Level_Cost_Details;


-- Generate_Cost_Details
--   Creates a complete cost detail tab for the given parameters.
FUNCTION Generate_Cost_Details (
   cost_detail_tab_       IN Cost_Detail_Tab,
   unit_cost_             IN NUMBER,
   unit_cost_is_material_ IN BOOLEAN,
   company_               IN VARCHAR2,
   contract_              IN VARCHAR2,
   part_no_               IN VARCHAR2,
   configuration_id_      IN VARCHAR2,
   source_ref1_           IN VARCHAR2,
   source_ref2_           IN VARCHAR2,
   source_ref3_           IN VARCHAR2,
   source_ref4_           IN NUMBER,
   source_ref_type_db_    IN VARCHAR2,
   cost_source_date_      IN DATE     DEFAULT NULL,
   trans_quantity_        IN NUMBER   DEFAULT NULL,
   vendor_no_             IN VARCHAR2 DEFAULT NULL ) RETURN Cost_Detail_Tab
IS
   local_cost_detail_tab_ Cost_Detail_Tab;
   inventory_part_rec_    Inventory_Part_API.Public_Rec;
BEGIN
   inventory_part_rec_ := Inventory_Part_API.Get(contract_, part_no_);

   local_cost_detail_tab_ := Generate_Cost_Details___(cost_detail_tab_,
                                                      unit_cost_,
                                                      unit_cost_is_material_,
                                                      company_,
                                                      contract_,
                                                      part_no_,
                                                      configuration_id_,
                                                      source_ref1_,
                                                      source_ref2_,
                                                      source_ref3_,
                                                      source_ref4_,
                                                      source_ref_type_db_,
                                                      cost_source_date_,
                                                      inventory_part_rec_,
                                                      trans_quantity_,
                                                      vendor_no_ );
   RETURN (local_cost_detail_tab_);
END Generate_Cost_Details;


-- Add_To_Value_Detail_Tab
--   Adds data to an existing value detail tab.
@UncheckedAccess
FUNCTION Add_To_Value_Detail_Tab (
   old_value_detail_tab_ IN Cost_Detail_Tab,
   cost_detail_tab_      IN Cost_Detail_Tab,
   quantity_             IN NUMBER ) RETURN Cost_Detail_Tab
IS
   value_ix_                    PLS_INTEGER;
   missing_in_value_detail_tab_ BOOLEAN;
   value_detail_tab_            Cost_Detail_Tab;
BEGIN
   value_detail_tab_ := old_value_detail_tab_;

   IF ((cost_detail_tab_.COUNT > 0) AND (quantity_ != 0)) THEN
      FOR i IN cost_detail_tab_.FIRST..cost_detail_tab_.LAST LOOP
         missing_in_value_detail_tab_ := TRUE;
         value_ix_ := 0;
         IF (value_detail_tab_.COUNT > 0) THEN
            FOR j IN value_detail_tab_.FIRST..value_detail_tab_.LAST LOOP
               IF ((cost_detail_tab_(i).accounting_year = value_detail_tab_(j).accounting_year) AND
                   (cost_detail_tab_(i).contract        = value_detail_tab_(j).contract)        AND
                   (cost_detail_tab_(i).cost_bucket_id  = value_detail_tab_(j).cost_bucket_id)  AND
                   (cost_detail_tab_(i).company         = value_detail_tab_(j).company)         AND
                   (cost_detail_tab_(i).cost_source_id  = value_detail_tab_(j).cost_source_id)) THEN

                  value_detail_tab_(j).unit_cost := value_detail_tab_(j).unit_cost +
                                                    (cost_detail_tab_(i).unit_cost * quantity_);
                  missing_in_value_detail_tab_ := FALSE;
               END IF;
               value_ix_ := j;
            END LOOP;
         END IF;
         IF (missing_in_value_detail_tab_) THEN
            value_ix_ := value_ix_ + 1;
            value_detail_tab_(value_ix_)           := cost_detail_tab_(i);
            value_detail_tab_(value_ix_).unit_cost := cost_detail_tab_(i).unit_cost * quantity_;
         END IF;
      END LOOP;
   END IF;

   RETURN (value_detail_tab_);
END Add_To_Value_Detail_Tab;


-- Value_To_Cost_Details
--   This method transforms a value_detail_tab into a cost_detail_tab using quantity.
@UncheckedAccess
FUNCTION Value_To_Cost_Details (
   value_detail_tab_ IN Cost_Detail_Tab,
   quantity_         IN NUMBER ) RETURN Cost_Detail_Tab
IS
   cost_detail_tab_ Cost_Detail_Tab;
BEGIN
   IF (value_detail_tab_.COUNT > 0) THEN
      FOR i IN value_detail_tab_.FIRST..value_detail_tab_.LAST LOOP
           cost_detail_tab_(i) := value_detail_tab_(i);
           cost_detail_tab_(i).unit_cost := value_detail_tab_(i).unit_cost / quantity_;
      END LOOP;
   END IF;
   RETURN (cost_detail_tab_);
END Value_To_Cost_Details;


-- Merge_And_Complete_Details
--   This method adds the correct Cost Source ID's and OH Accounting Years
--   to the cost details passed in, and returns the completed cost detail tab.
FUNCTION Merge_And_Complete_Details (
   cost_detail_tab_        IN Cost_Detail_Tab,
   inventory_part_rec_     IN Inventory_Part_API.Public_Rec,
   contract_               IN VARCHAR2,
   part_no_                IN VARCHAR2,
   company_                IN VARCHAR2,
   default_cost_bucket_id_ IN VARCHAR2,
   source_ref1_            IN VARCHAR2,
   source_ref2_            IN VARCHAR2,
   source_ref3_            IN VARCHAR2,
   source_ref4_            IN NUMBER,
   source_ref_type_db_     IN VARCHAR2,
   cost_source_date_       IN DATE DEFAULT NULL ) RETURN Cost_Detail_Tab
IS
   local_cost_detail_tab_ Cost_Detail_Tab;
BEGIN
   local_cost_detail_tab_ := cost_detail_tab_;

   IF (cost_detail_tab_.COUNT > 0) THEN
      local_cost_detail_tab_ := Complete_Cost_Details___(local_cost_detail_tab_,
                                                         inventory_part_rec_,
                                                         contract_,
                                                         part_no_,
                                                         company_,
                                                         source_ref1_,
                                                         source_ref2_,
                                                         source_ref3_,
                                                         source_ref4_,
                                                         source_ref_type_db_,
                                                         cost_source_date_);
   END IF;
   RETURN (local_cost_detail_tab_);
END Merge_And_Complete_Details;


-- Create_Cost_Diff_Tables
--   Compares two cost detail tables and returns the differences in to
--   cost diff details tables.
PROCEDURE Create_Cost_Diff_Tables (
   positive_cost_diff_tab_ OUT Cost_Detail_Tab,
   negative_cost_diff_tab_ OUT Cost_Detail_Tab,
   old_cost_detail_tab_    IN  Cost_Detail_Tab,
   new_cost_detail_tab_    IN  Cost_Detail_Tab )
IS
   pos_ix_                    PLS_INTEGER := 1;
   neg_ix_                    PLS_INTEGER := 1;
   missing_in_old_detail_tab_ BOOLEAN;
   missing_in_new_detail_tab_ BOOLEAN;
BEGIN

   IF (old_cost_detail_tab_.COUNT > 0) THEN
      FOR i IN old_cost_detail_tab_.FIRST..old_cost_detail_tab_.LAST LOOP
         missing_in_new_detail_tab_ := TRUE;

         IF (new_cost_detail_tab_.COUNT > 0) THEN
            FOR j IN new_cost_detail_tab_.FIRST..new_cost_detail_tab_.LAST LOOP
               IF ((old_cost_detail_tab_(i).accounting_year =
                                                     new_cost_detail_tab_(j).accounting_year) AND
                   (old_cost_detail_tab_(i).contract        =
                                                     new_cost_detail_tab_(j).contract)        AND
                   (old_cost_detail_tab_(i).cost_bucket_id  =
                                                     new_cost_detail_tab_(j).cost_bucket_id)  AND
                   (old_cost_detail_tab_(i).company         =
                                                     new_cost_detail_tab_(j).company)         AND
                   (old_cost_detail_tab_(i).cost_source_id  =
                                                     new_cost_detail_tab_(j).cost_source_id)) THEN

                  IF (old_cost_detail_tab_(i).unit_cost > new_cost_detail_tab_(j).unit_cost) THEN
                     negative_cost_diff_tab_(neg_ix_) := old_cost_detail_tab_(i);
                     negative_cost_diff_tab_(neg_ix_).unit_cost :=
                           old_cost_detail_tab_(i).unit_cost - new_cost_detail_tab_(j).unit_cost;
                     neg_ix_ := neg_ix_ + 1;

                  ELSIF (old_cost_detail_tab_(i).unit_cost < new_cost_detail_tab_(j).unit_cost) THEN
                     positive_cost_diff_tab_(pos_ix_) := old_cost_detail_tab_(i);
                     positive_cost_diff_tab_(pos_ix_).unit_cost :=
                           new_cost_detail_tab_(j).unit_cost - old_cost_detail_tab_(i).unit_cost;
                     pos_ix_ := pos_ix_ + 1;

                  ELSE
                     NULL;
                  END IF;

                  missing_in_new_detail_tab_ := FALSE;
               END IF;
            END LOOP;
         END IF;
         IF (missing_in_new_detail_tab_) THEN
            IF (old_cost_detail_tab_(i).unit_cost < 0) THEN
               positive_cost_diff_tab_(pos_ix_) := old_cost_detail_tab_(i);
               positive_cost_diff_tab_(pos_ix_).unit_cost := ABS(old_cost_detail_tab_(i).unit_cost);
               pos_ix_ := pos_ix_ + 1;
            ELSIF (old_cost_detail_tab_(i).unit_cost > 0) THEN 
               negative_cost_diff_tab_(neg_ix_) := old_cost_detail_tab_(i);
               neg_ix_ := neg_ix_ + 1;
            END IF;
         END IF;
      END LOOP;
   END IF;

   IF (new_cost_detail_tab_.COUNT > 0) THEN
      FOR i IN new_cost_detail_tab_.FIRST..new_cost_detail_tab_.LAST LOOP
         missing_in_old_detail_tab_ := TRUE;

         IF (old_cost_detail_tab_.COUNT > 0) THEN
            FOR j IN old_cost_detail_tab_.FIRST..old_cost_detail_tab_.LAST LOOP
               IF ((new_cost_detail_tab_(i).accounting_year =
                                                     old_cost_detail_tab_(j).accounting_year) AND
                   (new_cost_detail_tab_(i).contract        =
                                                     old_cost_detail_tab_(j).contract)        AND
                   (new_cost_detail_tab_(i).cost_bucket_id  =
                                                     old_cost_detail_tab_(j).cost_bucket_id)  AND
                   (new_cost_detail_tab_(i).company         =
                                                     old_cost_detail_tab_(j).company)         AND
                   (new_cost_detail_tab_(i).cost_source_id  =
                                                     old_cost_detail_tab_(j).cost_source_id)) THEN

                  missing_in_old_detail_tab_ := FALSE;
               END IF;
            END LOOP;
         END IF;
         IF (missing_in_old_detail_tab_) THEN
            IF (new_cost_detail_tab_(i).unit_cost < 0) THEN
               negative_cost_diff_tab_(neg_ix_) := new_cost_detail_tab_(i);
               negative_cost_diff_tab_(neg_ix_).unit_cost := ABS(new_cost_detail_tab_(i).unit_cost);
               neg_ix_ := neg_ix_ + 1;
            ELSIF (new_cost_detail_tab_(i).unit_cost > 0) THEN 
               positive_cost_diff_tab_(pos_ix_) := new_cost_detail_tab_(i);
               pos_ix_ := pos_ix_ + 1;
            END IF;
         END IF;
      END LOOP;
   END IF;
END Create_Cost_Diff_Tables;


-- Get_Wa_Condition_Cost
--   Summarizes the output from method GetWaConditionCostDetails into one value.
@UncheckedAccess
FUNCTION Get_Wa_Condition_Cost (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   condition_code_   IN VARCHAR2 ) RETURN NUMBER
IS
   cost_detail_tab_ Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   total_unit_cost_ NUMBER;
BEGIN
   cost_detail_tab_ := Get_Wa_Condition_Cost_Details(contract_,
                                                     part_no_,
                                                     configuration_id_,
                                                     condition_code_);

   total_unit_cost_ := Get_Total_Unit_Cost(cost_detail_tab_);

   RETURN (total_unit_cost_);
END Get_Wa_Condition_Cost;


-- Get_Weighted_Avg_Cost_Details
--   This method makes a recalculation of the weighted average cost details.
FUNCTION Get_Weighted_Avg_Cost_Details (
   old_cost_detail_tab_     IN Cost_Detail_Tab,
   trans_cost_detail_tab_   IN Cost_Detail_Tab,
   tot_company_owned_stock_ IN NUMBER,
   trans_quantity_          IN NUMBER ) RETURN Cost_Detail_Tab
IS
   new_cost_detail_tab_         Cost_Detail_Tab;
   k_                           PLS_INTEGER := 1;
   trans_cost_detail_unit_cost_ NUMBER;
   missing_in_old_detail_tab_   BOOLEAN;
BEGIN

   IF (old_cost_detail_tab_.COUNT > 0) THEN
      FOR i IN old_cost_detail_tab_.FIRST..old_cost_detail_tab_.LAST LOOP
         new_cost_detail_tab_(k_)      := old_cost_detail_tab_(i);
         trans_cost_detail_unit_cost_ := 0;

         IF (trans_cost_detail_tab_.COUNT > 0) THEN
            FOR j IN trans_cost_detail_tab_.FIRST..trans_cost_detail_tab_.LAST LOOP
               IF ((old_cost_detail_tab_(i).accounting_year =
                                                    trans_cost_detail_tab_(j).accounting_year) AND
                   (old_cost_detail_tab_(i).contract        =
                                                    trans_cost_detail_tab_(j).contract)        AND
                   (old_cost_detail_tab_(i).cost_bucket_id  =
                                                    trans_cost_detail_tab_(j).cost_bucket_id)  AND
                   (old_cost_detail_tab_(i).company         =
                                                    trans_cost_detail_tab_(j).company)         AND
                   (old_cost_detail_tab_(i).cost_source_id  =
                                                    trans_cost_detail_tab_(j).cost_source_id)) THEN

                  trans_cost_detail_unit_cost_ := trans_cost_detail_tab_(j).unit_cost;
               END IF;
            END LOOP;
         END IF;

         new_cost_detail_tab_(k_).unit_cost :=
                                  ((old_cost_detail_tab_(i).unit_cost * tot_company_owned_stock_) +
                                   (trans_cost_detail_unit_cost_ * trans_quantity_)) /
                                   (tot_company_owned_stock_ + trans_quantity_);
         k_ := k_ + 1;
      END LOOP;
   END IF;

   IF (trans_cost_detail_tab_.COUNT > 0) THEN
      FOR i IN trans_cost_detail_tab_.FIRST..trans_cost_detail_tab_.LAST LOOP
         missing_in_old_detail_tab_ := TRUE;

         IF (old_cost_detail_tab_.COUNT > 0) THEN
            FOR j IN old_cost_detail_tab_.FIRST..old_cost_detail_tab_.LAST LOOP
               IF ((trans_cost_detail_tab_(i).accounting_year =
                                                     old_cost_detail_tab_(j).accounting_year) AND
                   (trans_cost_detail_tab_(i).contract        =
                                                     old_cost_detail_tab_(j).contract)        AND
                   (trans_cost_detail_tab_(i).cost_bucket_id  =
                                                     old_cost_detail_tab_(j).cost_bucket_id)  AND
                   (trans_cost_detail_tab_(i).company         =
                                                     old_cost_detail_tab_(j).company)         AND
                   (trans_cost_detail_tab_(i).cost_source_id  =
                                                     old_cost_detail_tab_(j).cost_source_id)) THEN

                  missing_in_old_detail_tab_ := FALSE;
               END IF;
            END LOOP;
         END IF;
         IF (missing_in_old_detail_tab_) THEN
            new_cost_detail_tab_(k_)           := trans_cost_detail_tab_(i);
            new_cost_detail_tab_(k_).unit_cost :=
                                          (trans_cost_detail_tab_(i).unit_cost * trans_quantity_) /
                                          (tot_company_owned_stock_ + trans_quantity_);
            k_ := k_ + 1;
         END IF;
      END LOOP;
   END IF;

   RETURN (new_cost_detail_tab_);
END Get_Weighted_Avg_Cost_Details;


-- Get_Cost_Details_By_Condition
--   fetches the cost detail tab for a specific condition of a part.
@UncheckedAccess
FUNCTION Get_Cost_Details_By_Condition (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   condition_code_   IN VARCHAR2 ) RETURN Cost_Detail_Tab
IS
   part_rec_               Inventory_Part_API.Public_Rec;
   cost_detail_tab_        Cost_Detail_Tab;
   current_condition_code_ VARCHAR2(50);
   cost_details_found_     BOOLEAN;
   unit_cost_              NUMBER;

   CURSOR get_unit_cost_rec IS
      SELECT DISTINCT serial_no, lot_batch_no
      FROM INVENTORY_PART_UNIT_COST_TAB
      WHERE part_no          = part_no_
        AND contract         = contract_
        AND configuration_id = configuration_id_;
BEGIN
   part_rec_ := Inventory_Part_API.Get(contract_, part_no_);

   IF (part_rec_.inventory_part_cost_level = 'COST PER CONDITION') THEN
      cost_details_found_ := FALSE;

      FOR unit_cost_rec_ IN get_unit_cost_rec LOOP
         current_condition_code_ := Condition_Code_Manager_API.Get_Condition_Code(part_no_,
                                                                                  unit_cost_rec_.serial_no,
                                                                                  unit_cost_rec_.lot_batch_no);

         IF (NVL(condition_code_,'NOT_NULL') = NVL(current_condition_code_,'NOT_NULL')) THEN
            cost_detail_tab_ := Get_Cost_Details_By_Method(contract_,
                                                           part_no_,
                                                           configuration_id_,
                                                           unit_cost_rec_.lot_batch_no,
                                                           unit_cost_rec_.serial_no);
            cost_details_found_ := TRUE;
            EXIT;
         END IF;
      END LOOP;

      IF (NOT cost_details_found_) THEN
         unit_cost_ := Inv_Part_Config_Condition_API.Get_Estimated_Cost(condition_code_,
                                                                        contract_,
                                                                        part_no_,
                                                                        configuration_id_);
         IF (unit_cost_ IS NULL) THEN
            cost_detail_tab_ := Get_Cost_Details_By_Method(contract_,
                                                           part_no_,
                                                           configuration_id_,
                                                           NULL,
                                                           NULL);
         ELSE
            cost_detail_tab_(1).accounting_year := '*';
            cost_detail_tab_(1).contract        := contract_;
            cost_detail_tab_(1).cost_bucket_id  := '*';
            cost_detail_tab_(1).company         := Site_API.Get_Company(contract_);
            cost_detail_tab_(1).cost_source_id  := '*';
            cost_detail_tab_(1).unit_cost       := unit_cost_;
         END IF;
      END IF;
   ELSE
      cost_detail_tab_ := Get_Cost_Details_By_Method(contract_,
                                                     part_no_,
                                                     configuration_id_,
                                                     NULL,
                                                     NULL);
   END IF;

   RETURN (cost_detail_tab_);
END Get_Cost_Details_By_Condition;


-- Get_Lot_Batch_Cost_Details
--   Returns the cost detail tab for a specific lot of an inventory part configuration.
FUNCTION Get_Lot_Batch_Cost_Details (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   lock_for_update_  IN BOOLEAN ) RETURN Cost_Detail_Tab
IS
   cost_detail_tab_ Cost_Detail_Tab;
   local_serial_no_ INVENTORY_PART_UNIT_COST_TAB.serial_no%TYPE;

   CURSOR get_serial_no (contract_         IN VARCHAR2,
                         part_no_          IN VARCHAR2,
                         configuration_id_ IN VARCHAR2,
                         lot_batch_no_     IN VARCHAR2) IS
      SELECT serial_no
        FROM INVENTORY_PART_UNIT_COST_TAB
       WHERE contract         = contract_
         AND part_no          = part_no_
         AND configuration_id = configuration_id_
         AND lot_batch_no     = lot_batch_no_;
BEGIN
   
   OPEN get_serial_no(contract_,
                      part_no_,
                      configuration_id_,
                      lot_batch_no_);
   FETCH get_serial_no INTO local_serial_no_;

   IF (get_serial_no%FOUND) THEN
      -- There is already at least one record in the table with identical values for
      -- contract, part_no, configuration_id and lot_batch_no.
      IF (lock_for_update_) THEN
         cost_detail_tab_ := Get_Cost_Details_And_Lock___(contract_,
                                                          part_no_,
                                                          configuration_id_,
                                                          lot_batch_no_,
                                                          local_serial_no_);
      ELSE
         cost_detail_tab_ := Get_Cost_Detail_Tab___(contract_,
                                                    part_no_,
                                                    configuration_id_,
                                                    lot_batch_no_,
                                                    local_serial_no_);
      END IF;
   END IF;
   CLOSE get_serial_no;

   RETURN(cost_detail_tab_);
END Get_Lot_Batch_Cost_Details;


-- Get_Wa_Condition_Cost_Details
--   Returns a cost detail tab containing the weighted average cost details
--   for this particular condition code amongst all lots and serials of
--   this part in currently in stock.
@UncheckedAccess
FUNCTION Get_Wa_Condition_Cost_Details (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   condition_code_   IN VARCHAR2 ) RETURN Cost_Detail_Tab
IS
   qty_on_hand_            NUMBER := 0;
   qty_in_transit_         NUMBER := 0;
   total_qty_              NUMBER := 0;
   grand_total_qty_        NUMBER := 0;
   cost_detail_tab_        Cost_Detail_Tab;
   value_detail_tab_       Cost_Detail_Tab;
   current_condition_code_ VARCHAR2(50);
   char_null_              VARCHAR2(12) := 'VARCHAR2NULL';

   CURSOR get_config_unit_cost_rec IS
   SELECT DISTINCT lot_batch_no, serial_no
      FROM INVENTORY_PART_UNIT_COST_TAB
      WHERE part_no          = part_no_
        AND contract         = contract_
        AND configuration_id = configuration_id_;
BEGIN
   grand_total_qty_   := 0;
   FOR unit_cost_rec_ IN get_config_unit_cost_rec LOOP
      current_condition_code_ := Condition_Code_Manager_API.Get_Condition_Code(
                                                                      part_no_,
                                                                      unit_cost_rec_.serial_no,
                                                                      unit_cost_rec_.lot_batch_no);

      IF (NVL(condition_code_, char_null_) = NVL(current_condition_code_, char_null_)) THEN
         -- EBALL-37, Modified the call to use Invent_Part_Quantity_Util_API.Get_Company_Owned_Inventory(). 
         Invent_Part_Quantity_Util_API.Get_Company_Owned_Inventory(qty_on_hand_,
                                                                   qty_in_transit_,
                                                                   contract_,
                                                                   part_no_,
                                                                   configuration_id_,
                                                                   unit_cost_rec_.lot_batch_no,
                                                                   unit_cost_rec_.serial_no);
         total_qty_          := qty_on_hand_ + qty_in_transit_;
         grand_total_qty_    := grand_total_qty_ + total_qty_;
         cost_detail_tab_    := Get_Cost_Detail_Tab___(contract_,
                                                       part_no_,
                                                       configuration_id_,
                                                       unit_cost_rec_.lot_batch_no,
                                                       unit_cost_rec_.serial_no);

         value_detail_tab_ := Add_To_Value_Detail_Tab(value_detail_tab_,
                                                      cost_detail_tab_,
                                                      total_qty_);
      END IF;
   END LOOP;
   IF (grand_total_qty_ > 0) THEN
      cost_detail_tab_ := Value_To_Cost_Details(value_detail_tab_,
                                                grand_total_qty_);
   ELSE
      cost_detail_tab_.DELETE;
   END IF;

   RETURN (cost_detail_tab_);
END Get_Wa_Condition_Cost_Details;


-- Handle_Valuation_Method_Change
--   This method clears out cost source ID and OH accounting year on
--   the cost details when inventory valuation method is changed into
--   Standard Cost, if the cost level is Cost Per Part or Cost Per Configuration.
PROCEDURE Handle_Valuation_Method_Change (
   contract_                IN VARCHAR2,
   part_no_                 IN VARCHAR2,
   part_cost_level_db_      IN VARCHAR2,
   old_valuation_method_db_ IN VARCHAR2,
   new_valuation_method_db_ IN VARCHAR2 )
IS
   exit_procedure_   EXCEPTION;
   configuration_id_ VARCHAR2(50);
   cost_detail_tab_  Cost_Detail_Tab;

   CURSOR get_configuration (contract_         IN VARCHAR2,
                             part_no_          IN VARCHAR2,
                             configuration_id_ IN VARCHAR2) IS
      SELECT DISTINCT configuration_id
        FROM INVENTORY_PART_UNIT_COST_TAB
       WHERE  contract         = contract_
         AND  part_no          = part_no_
         AND (configuration_id = configuration_id_ OR configuration_id_ IS NULL);
BEGIN

   IF (old_valuation_method_db_ != 'AV') THEN
      RAISE exit_procedure_;
   END IF;

   IF (new_valuation_method_db_ != 'ST') THEN
      RAISE exit_procedure_;
   END IF;

   IF (part_cost_level_db_ NOT IN ('COST PER PART', 'COST PER CONFIGURATION')) THEN
      RAISE exit_procedure_;
   END IF;

   IF (part_cost_level_db_ = 'COST PER PART') THEN
      configuration_id_ := '*';
   END IF;

   FOR config_rec_ IN get_configuration (contract_,
                                         part_no_,
                                         configuration_id_) LOOP

      cost_detail_tab_ := Get_Cost_Detail_Tab___(contract_,
                                                 part_no_,
                                                 config_rec_.configuration_id,
                                                 '*',
                                                 '*');

      -- First clear out accounting year and cost source for the new cost details
      cost_detail_tab_ := Clear_Details_Year_And_Source(cost_detail_tab_);

      -- Now merge cost details having the same keys
      cost_detail_tab_ := Merge_Cost_Details(cost_detail_tab_);

      Modify_Standard_Cost_Details(contract_,
                                   part_no_,
                                   config_rec_.configuration_id,
                                   cost_detail_tab_);
   END LOOP;
EXCEPTION
   WHEN exit_procedure_ THEN
      NULL;
END Handle_Valuation_Method_Change;


-- Clear_Details_Year_And_Source
--   Adds data to an existing value detail tab.
FUNCTION Clear_Details_Year_And_Source (
   old_cost_detail_tab_ IN Cost_Detail_Tab ) RETURN Cost_Detail_Tab
IS
   new_cost_detail_tab_ Cost_Detail_Tab;
BEGIN

   IF (old_cost_detail_tab_.COUNT > 0) THEN
      FOR i IN old_cost_detail_tab_.FIRST..old_cost_detail_tab_.LAST LOOP
         new_cost_detail_tab_(i).accounting_year := '*';
         new_cost_detail_tab_(i).cost_source_id  := '*';
         new_cost_detail_tab_(i).contract        := old_cost_detail_tab_(i).contract;
         new_cost_detail_tab_(i).company         := old_cost_detail_tab_(i).company;
         new_cost_detail_tab_(i).cost_bucket_id  := old_cost_detail_tab_(i).cost_bucket_id;
         new_cost_detail_tab_(i).unit_cost       := old_cost_detail_tab_(i).unit_cost;
      END LOOP;
   END IF;
   RETURN (new_cost_detail_tab_);
END Clear_Details_Year_And_Source;


-- Merge_Cost_Details
--   This method merges the unit cost for all details having the same
--   contract, cost bucket ID, company, cost source ID and OH accounting year.
@UncheckedAccess
FUNCTION Merge_Cost_Details (
   old_cost_detail_tab_ IN Cost_Detail_Tab ) RETURN Cost_Detail_Tab
IS
   new_cost_detail_tab_ Cost_Detail_Tab;
   cost_detail_found_   BOOLEAN;
   index_               PLS_INTEGER := 1;
BEGIN
   IF (old_cost_detail_tab_.COUNT > 0) THEN
      FOR i IN old_cost_detail_tab_.FIRST..old_cost_detail_tab_.LAST LOOP
         cost_detail_found_ := FALSE;
         IF (new_cost_detail_tab_.COUNT > 0) THEN
            FOR j IN new_cost_detail_tab_.FIRST..new_cost_detail_tab_.LAST LOOP

               IF ((old_cost_detail_tab_(i).company  = new_cost_detail_tab_(j).company)  AND
                   (old_cost_detail_tab_(i).contract = new_cost_detail_tab_(j).contract) AND
                   (old_cost_detail_tab_(i).cost_bucket_id
                                                     = new_cost_detail_tab_(j).cost_bucket_id) AND

                   (old_cost_detail_tab_(i).accounting_year
                                                     = new_cost_detail_tab_(j).accounting_year) AND
                   (old_cost_detail_tab_(i).cost_source_id
                                                     = new_cost_detail_tab_(j).cost_source_id)) THEN

                  new_cost_detail_tab_(j).unit_cost := new_cost_detail_tab_(j).unit_cost +
                                                       old_cost_detail_tab_(i).unit_cost;
                  cost_detail_found_ := TRUE;
                  EXIT;
               END IF;
            END LOOP;
         END IF;
         IF NOT (cost_detail_found_) THEN
            new_cost_detail_tab_(index_).accounting_year := old_cost_detail_tab_(i).accounting_year;
            new_cost_detail_tab_(index_).cost_source_id  := old_cost_detail_tab_(i).cost_source_id;
            new_cost_detail_tab_(index_).contract        := old_cost_detail_tab_(i).contract;
            new_cost_detail_tab_(index_).company         := old_cost_detail_tab_(i).company;
            new_cost_detail_tab_(index_).cost_bucket_id  := old_cost_detail_tab_(i).cost_bucket_id;
            new_cost_detail_tab_(index_).unit_cost       := old_cost_detail_tab_(i).unit_cost;
            index_ := index_ + 1;
         END IF;
      END LOOP;
   END IF;

   RETURN (new_cost_detail_tab_);
END Merge_Cost_Details;


-- Get_Deliv_Overhead_Unit_Cost
--   Returns the total unit cost for all Delivery Overhead details in the
--   cost detail tab sent in.
FUNCTION Get_Deliv_Overhead_Unit_Cost (
   cost_detail_tab_ IN Cost_Detail_Tab ) RETURN NUMBER
IS
   deliv_overhead_unit_cost_ NUMBER := 0;
   cost_bucket_type_db_      VARCHAR2(20);
BEGIN

   IF (cost_detail_tab_.COUNT > 0) THEN
      FOR i IN cost_detail_tab_.FIRST..cost_detail_tab_.LAST LOOP
         cost_bucket_type_db_ := Get_Cost_Bucket_Type_Db___(
                                                       cost_detail_tab_(i).contract,
                                                       cost_detail_tab_(i).cost_bucket_id);
         IF (cost_bucket_type_db_ = 'DELOH') THEN
            deliv_overhead_unit_cost_ := deliv_overhead_unit_cost_ + cost_detail_tab_(i).unit_cost;
         END IF;
      END LOOP;
   END IF;

   RETURN (deliv_overhead_unit_cost_);
END Get_Deliv_Overhead_Unit_Cost;


-- Cost_Bucket_Exist
--   Checks if a specific cost bucket has been used in this LU or in
--   LU InventoryPartFifoDetail.
@UncheckedAccess
FUNCTION Cost_Bucket_Exist (
   contract_       IN VARCHAR2,
   cost_bucket_id_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   cost_bucket_exist_ BOOLEAN := FALSE;
   dummy_             NUMBER;

   CURSOR exist_control IS
      SELECT 1
      FROM   INVENTORY_PART_UNIT_COST_TAB
      WHERE contract       = contract_
      AND   cost_bucket_id = cost_bucket_id_;
BEGIN
   OPEN  exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      cost_bucket_exist_ := TRUE;
   END IF;
   CLOSE exist_control;

   IF NOT (cost_bucket_exist_) THEN
      cost_bucket_exist_ := Inventory_Part_Fifo_Detail_API.Cost_Bucket_Exist(contract_,
                                                                             cost_bucket_id_);
   END IF;

   RETURN(cost_bucket_exist_);
END Cost_Bucket_Exist;


PROCEDURE Get_Tot_Company_Owned_Stock(
   qty_on_hand_    OUT NUMBER,
   qty_in_transit_ OUT NUMBER,
   contract_       IN  VARCHAR2,
   part_no_        IN  VARCHAR2 )
IS
BEGIN
   Invent_Part_Quantity_Util_API.Get_Company_Owned_Inventory(qty_on_hand_,
                                                             qty_in_transit_,
                                                             contract_,
                                                             part_no_,
                                                             NULL);
END Get_Tot_Company_Owned_Stock;


@UncheckedAccess
FUNCTION Non_Zero_Cost_Detail_Exist (
   cost_detail_tab_ IN Cost_Detail_Tab ) RETURN BOOLEAN
IS
   non_zero_cost_detail_exist_ BOOLEAN := FALSE;
BEGIN
   IF (cost_detail_tab_.COUNT > 0) THEN
      FOR i IN cost_detail_tab_.FIRST..cost_detail_tab_.LAST LOOP
         IF (cost_detail_tab_(i).unit_cost != 0) THEN
            non_zero_cost_detail_exist_ := TRUE;
            EXIT;
         END IF;
      END LOOP;
   END IF;
   RETURN(non_zero_cost_detail_exist_);
END Non_Zero_Cost_Detail_Exist;


@UncheckedAccess
FUNCTION Non_Star_Cost_Bucket_Exist (
   cost_detail_tab_ IN Cost_Detail_Tab ) RETURN BOOLEAN
IS
   non_star_cost_bucket_exist_ BOOLEAN := FALSE;
BEGIN
   IF (cost_detail_tab_.COUNT > 0) THEN
      FOR i IN cost_detail_tab_.FIRST..cost_detail_tab_.LAST LOOP
         IF (cost_detail_tab_(i).cost_bucket_id != '*') THEN
            non_star_cost_bucket_exist_ := TRUE;
            EXIT;
         END IF;
      END LOOP;
   END IF;
   RETURN(non_star_cost_bucket_exist_);
END Non_Star_Cost_Bucket_Exist;


@UncheckedAccess
FUNCTION Cost_To_Value_Details (
   cost_detail_tab_ IN Cost_Detail_Tab,
   quantity_        IN NUMBER ) RETURN Cost_Detail_Tab
IS
   value_detail_tab_ Cost_Detail_Tab;
BEGIN
   IF (cost_detail_tab_.COUNT > 0) THEN
      FOR i IN cost_detail_tab_.FIRST..cost_detail_tab_.LAST LOOP
           value_detail_tab_(i) := cost_detail_tab_(i);
           value_detail_tab_(i).unit_cost := cost_detail_tab_(i).unit_cost * quantity_;
      END LOOP;
   END IF;
   RETURN (value_detail_tab_);
END Cost_To_Value_Details;


-- This method is used for FSM IFS Integration process.
FUNCTION Get_Max_Objversion (
   contract_      VARCHAR2,
   part_no_       VARCHAR2) RETURN VARCHAR2
IS
   
   CURSOR max_objversion IS
   SELECT to_char(max(rowversion),'YYYYMMDDHH24MISS') FROM inventory_part_unit_cost_tab
   WHERE contract = contract_ AND part_no = part_no_;
   
   objversion_    INVENTORY_PART_UNIT_COST.objversion%TYPE;
BEGIN
   OPEN max_objversion;
   FETCH max_objversion INTO objversion_;
   CLOSE max_objversion;
   RETURN objversion_;
END Get_Max_Objversion;
