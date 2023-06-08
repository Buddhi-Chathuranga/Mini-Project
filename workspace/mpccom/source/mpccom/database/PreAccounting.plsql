-----------------------------------------------------------------------------
--
--  Logical unit: PreAccounting
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  --------------------------------------------------------
--  201007  SBalLK  Bug 155870 (SCZ-11042), Added Validate_Code_Parts___() and Raise_Percentage_Null_Err___() method and modified Check_Insert___() and
--  201007          Check_Update___() methods to resolve MessageDefinitionValidation issues. Removed Raise_Account_Missing_Error___(), 
--``201007          Raise_Code_B_Missing_Error___(), Raise_Code_C_Missing_Error___(), Raise_Code_D_Missing_Error___(), Raise_Code_E_Missing_Error___(),
--  201007          Raise_Code_F_Missing_Error___(), Raise_Code_G_Missing_Error___(), Raise_Code_H_Missing_Error___(), Raise_Code_I_Missing_Error___(),
--  201007          Raise_Code_J_Missing_Error___(), Raise_Account_Man_Ent_Error___() and Raise_Lu_Act_Not_Inst_Error___.
--  201005  LEPESE  SC2021R1-324, added code for Work Task in method Get_Pre_Accounting_Id.
--  200324  SBalLK  Bug 152848 (SCZ-9452), Resolving automatic testing reported issues.
--  200208  NiEdlk  SCXTEND-3091, Added Get_Project_Code_Part() and External_Project().
--  190913  Asawlk  Bug 148569(SCZ-5458), Added Raise_Amount_Dist_Err___. Modified Check_Insert___ and Check_Update___ to raise error on invalid amount_distribution
--  190913          by calling Raise_Amount_Dist_Err___.
--  190829  DiKuLk  Bug 149681(SCZ-6585), Modified CHECK_PROJECT_CODE_VALUE___() to change the message content of error 'EXTPROJ'.
--  191001  DaZase  SCSPRING20-128, Added Raise_Account_Missing_Error___, Raise_Code_B_Missing_Error___, Raise_Code_C_Missing_Error___, Raise_Code_D_Missing_Error___, 
--  191001          Raise_Code_E_Missing_Error___, Raise_Code_F_Missing_Error___, Raise_Code_G_Missing_Error___, Raise_Code_H_Missing_Error___, 
--  191001          Raise_Code_I_Missing_Error___, Raise_Code_J_Missing_Error___, Raise_Account_Man_Ent_Error___, Raise_Lines_Perc_Alloc_Err___ and 
--  191001          Raise_Lu_Act_Not_Inst_Error___ to solve MessageDefinitionValidation issues.
--  190327  FANDSE  SCUXXW4-7665, Changed Set_Company_And_Total_Amount in order to skip code part validation at update.
--  190208  LEPESE  SCUXXW4-16267, Added method Check_Enabled.
--  190128  LEPESE  SCUXXW4-7665, Added method Cleanup_Distribution___ and called it from Insert___ and Update___.
--  190124  LEPESE  SCUXXW4-7665, Added method Set_Company_And_Total_Amount.
--  190124  LEPESE  SCUXXW4-7665, Replaced variable total_amount_ with newrec_.total_amount in Check_Insert___ and Check_Update___.
--  190116  LEPESE  SCUXXW4-7665, Replaced variable company_ with newrec_.company in Check_Insert___ and Check_Update___.
--  181206  FANDSE  SCUXXW4-7655, Initial Aurena implmentation of dlgGivenValue as PrePostingWithoutSourceAssistant. Added Get_Codeparts_Settings.
--  180125  MaEelk  STRSC-16116, Added DEFAULT FALSE parameter remove_external_project_ to Copy_Pre_Accounting. It will remove project related values from pre accounting if this parameter is TRUE.
--  170809  ErRalk  Bug 135979, Changed the text case in NOPO message content in Get_Pre_Accounting_Id to eliminate duplicated definitions for the same message.
--  170630  ShPrlk  Bug 135697, Added new parameter validate_code_parts_ to Copy_Pre_Accounting and Check_Insert___ to skip code part validation for Purchase orders created Manually.
--  170328  Raeklk  STRPJ-18958, Modified Get_Pre_Accounting_Id() handle pre posting for project delivarable item.
--  170303  DilMlk  Bug 133558, Modified procedure Set_Pre_Posting and added new parameter replace_with_null_ to replace pre postings 
--  170303          with project pre postings if it has value.
--  170131  MeAblk  Bug 133759, Added parameter skip_code_part_validation_ into the methods Remove_Proj_Pre_Posting(), Modify() and Set_Pre_Posting() to track the scenario of cancelling a PO/CO line.
--  160825  SBalLK  Bug 131056, Modified Get_Pre_Accounting_Id() method to fetch pre-accounting id from purchase order change order when required.
--  160725  Dinklk  APPUXX-2797, Added a new function Is_Allowed_Codepart to get code part is allowed or not by passing code part name.
--  150911  RoJalk  AFT-3386, Modified Get_Pre_Accounting_Id to fetch pre_accounting_id_ for CRO exchange lines.
--  150909  NaSalk  AFT-4521, Modifed Get_Fa_Object_Id to consider distributed pre posting.
--  150821  SuSalk  ORA-1143, Removed ACCRUL dynamic check from Get_Project_Code_Value___ method.
--  150623  NaSalk  RED-543, Added Get_Fa_Object_Id, which returns the FA accounting code part value.
--  150421  NaSalk  RED-124, Modified New_Distribution.
--  150409  NaSalk  RED-124, Modified New_Distribution and Distribution_Exist.
--  150407  NaSalk  RED-124, Added New_Distribution to create distribution posting lines with a given code string collection.
--  141124  JeLise  PRSC-4292, Changed the error message in Check_Allowed_Code_Parts___.
--  141122  MaEelk  PRSC-3144, Removed the deprecated method Is_Non_Inventory_Transaction__.
--  140915  RuLiLk  Bug 117599, Modified method Notify_Pre_Posting_Source___() to handle pre postings from purchase change order line.
--  140912  Asawlk  PRSC-1950, Replaced the usages of Mpccom_Accounting_API.Control_Type_Key_Rec with local variables or parameters of same type.
--  140729  Asawlk  PRSC-1949, Replaced the usages of Mpccom_Accounting_API.Codestring_Rec with parameters.
--  140411  LEPESE  PBSC-8358, assigned NULL to newrec_.rowkey in Copy_Pre_Accounting to avoid dup_val_on_index.
--  140303  SBalLK  Bug 114835, Set the Is_Non_Inventory_Transaction__() method as Deprecated since method is no longer used.
--  130920  MAWILK  BLACK-566, Replaced Component_Pcm_SYS.
--  130812  ChJalk  TIBE-937, Removed the global variables inst_ProjAccounting_, inst_RetMatLine_, inst_CustomerOrderLine_,
--  130812          inst_ShopMaterialAllocList_, inst_PurchaseOrderLinePart_, inst_PurchaseReqLine_, inst_PurchaseOrder_,
--  130812          inst_PurchaseOrderLine_, inst_CustomerOrder_, inst_ShopOrdUtil_, inst_MultiCompanyVoucherUtil_, 
--  130812          inst_AccountingCodeParts_, inst_Activity_, inst_ActiveWorkOrderUtil_, inst_HistoricalWorkOrder_ and inst_MaterialRequisLine_.
--  130711  ErFelk  Bug 111147, Added ignore return annotation in method Mandatory_Pre_Posting_Complete().
--  130618  IsSalk  Bug 110425, Added valid_from and valid_until to the view PRE_ACCOUNTING_CODEPART_A.
--  130516  IsSalk  Bug 106680, Replaced Installed_Component_SYS.<component> with Component_<component>_SYS.<component>.
--  120918  NipKlk  Bug 105135, Changed the External_Project___ methods conditions to consider all projects as externally created ones 
--  120918          when Accounting_Project_API is not installed. 
--  110919  HaPulk  Changed ConnectionPackage method calls to Conditional Compilation
--  110803  HimRlk  Bug 98044, Removed uninitialized variable pre_acc_rec_ from Compile_Codestrings(). Removed project_activity_seq_ 
--  110803          parameter from Prj_Pre_Posting_Required___.
--  110321  ShRalk  Modified Check_Mandatory_Code_Parts to add code to identify mandatory pre accounting for code part project is enabled.
--  110110  AwWelk  Bug 95008, Added Mandatory_Pre_Posting_Complete() method to check whether mandatory preposting
--  110110          has been enabled and required code parts have been entered.
--  100602  PraWlk  Bug 90261, Added valid_from and valid_until to PRE_ACCOUNTING_CODEPART_B, PRE_ACCOUNTING_CODEPART_C,
--  100602          PRE_ACCOUNTING_CODEPART_D, PRE_ACCOUNTING_CODEPART_E,PRE_ACCOUNTING_CODEPART_F,PRE_ACCOUNTING_CODEPART_G, 
--  100602          PRE_ACCOUNTING_CODEPART_H,PRE_ACCOUNTING_CODEPART_I and PRE_ACCOUNTING_CODEPART_J views.
--  100106  Asawlk  Bug 87196, Modified Notify_Pre_Posting_Source___() and Notify_Source_On_Update___() to support
--  100106          when pre_posting_source_ = 'PURCHASE REQUISITION'
--  100503  NuVelk  Merged Twin Peaks
--          090513  Ersruk  Pre posting source 'CUSTOMER ORDER' is used to pre post project in order header avoiding validation for activity seq.
--          090513          PA recommended changes, added Get_Project_Code_Part___ , External_Project___  and Remove_External_Project___.
--          090511  Ersruk  Added new parameter pre_posting_source_ in Check_Project_Code_Value___, Copy_Pre_Accounting, Set_Project_Code_Part.
--          090327  Ersruk  Merged product architect LEPESE recommonded changes for Twin Peaks,Balance Sheet by Project.
--  100430  Ajpelk  Merge rose method documentation
--  100120  MaMalk  Added global lu constants to replace the calls to Transaction_SYS.Logical_Unit_Is_Installed
--  100120          in the business logic.
--  100114  KAYOLK  Modified the method Get_Pre_Accounting_Id, such that the Shop_Order_Int_API
--  100114          calls were replaced BY Shop_Ord_Util_API
--  091222  KAYOLK  Modified the view PRE_ACCOUNTING and the methods Get_Project_Code_Value___(), Do_Pre_Accounting(),
--  091222          Get_Pre_Accounting(), Insert_Pre_Accounting(), New(), Set_Pre_Posting(), Notify_Source_On_Update___(),
--  091222          Pre_Accounting_Exist(), Distribution_Exist(), Is_Preacc_Similar (), Check_Mandatory_Code_Parts(),
--  091222          Compile_Codestrings(), Set_Project_Code_Part(), Modify(), Remove_Proj_Pre_Posting(), and Get() for
--  091222          renaming the code part cost_center, object_no, and project_no as codeno_b, codeno_e and codeno_f
--  091222          respectively. Also renamed the Get methods Get_Cost_Center(), Get_Object_No(), and Get_Project_No()
--  091222          to Get_Codeno_B(), Get_Codeno_E(), and Get_Codeno_F() respectively.
--  091008  HoInlk  Bug 86259, Modified Get_Pre_Accounting_Id to get pre_accounting_id from purchase requsition.
--  091006  ChFolk  Removed un us ed parameter project_activity_seq_ from Prj_Pre_Posting_Required___ and
--  091006          posting_type_ from Validate_Code_Parts___
--  ---------------------------------- 14.0.0 ------------------------------------------------
--  090619  PraWlk  Bug 84041, Modified procedure Validate_Code_Parts___to check code parts correctly.
--  090611  TiRalk  Bug 82563, Modified Remove_Proj_Pre_Posting by removing parameter check_allowed_code_parts_              
--  090611          and added logic to assigne NULL to all the code parts which are not allowed for the posting type. 
--  090610  TiRalk  Bug 82563, Modified Remove_Proj_Pre_Posting by adding a new parameter check_allowed_code_parts_.
--  090605  TiRalk  Bug 82563, Modified methods New, Modify and Set_Pre_Posting by adding a new parameter
--  090605          check_allowed_code_parts_ and the logic which checks allowed code parts in both new and 
--  090605          modify moved to new implementation methods Check_Allowed_Code_Parts___,Validate_Code_Parts___. 
--  090529  SaWjlk  Bug 83173, Removed the prog text duplications.
--  081010  RoJalk  Bug 77356, Modified Unpack_Check_Insert___/Unpack_Check_Update___ to prevent
--  081010          a stat account being used for pre posting.
--  080508  SuSalk  Bug 73410, Modified Unpack_Check_Update___ to correct the NOTPERCENTAGEUPD error message.
--  071031  MarSlk  Bug 67386, Modified Unpack_Check_Insert___ to set correct value for amount_distribution.
--  071031          Removed correction made for Unpack_Check_Update___.
--  071022  MarSlk  Bug 67386, Modified Unpack_Check_Update___ to set correct value for amount_distribution.    
--  070514  NiDalk  Bug 64134, Added function Get_Distributed_Amount__ to calculate amount distributed.
--  070514          Added derived columns line_amount, total_amount and removed existing column amount_percentage.
--  070514  RaKalk  Bug 60408, Added new column Amount_Percentage in base view and modified unpack_check_insert and
--  070514          Unpack_check_update methods. Added code in method Check_Distribution_Complete__ to round the total_ value.
--  070314  MalLlk  Bug 63796, Modified Notify_Source_On_Update___ by using NVL condition for
--  070314          IN parameter of EXECUTE IMMEDIATE stmt_.
--  070221  NaWilk  Added implementation methods Notify_Source_On_Update___ and Notify_Pre_Posting_Source___.
--  070221          Removed method Validate_Pur_Req_Change___ by moving the content into Notify_Source_On_Update___.
--  070102  NaWilk  Bug 60533, Added new derived attribut pre_posting_source to the VIEW. Modified Unpack_Check_Insert___,
--  070102          Unpack_Check_Update___ and Update___ to validate changes in pre posting in purchase requisiton line.
--  070102          Added method Validate_Pur_Req_Change___.
--  060327  MAJO    B136066 Fixes for Job Costing in Prj_Pre_Posting_Required___.
--  060123  JaJalk  Added Assert safe annotation.
--  060111  MiKulk  Modified the PROCEDURE Insert___ according to the new template.
--  050919  NaLrlk  Removed unused variables.
--  050509  Asawlk  Bug 50519, Added new paramter CONTRACT to method Copy_Pre_Accounting and changed the body
--  050509          inorder to support code part validations.
--  041117  SaNalk  Modified Get_Project_Code_Value.
--  041112  UsRalk  Modified [Remove_Proj_Pre_Posting] to assign NULL to lu_rec_.codeno_d when project code part is 'D'.
--  041013  SaNalk  Added Get_Project_Code_Value.
--  040929  Asawlk  Bug 46710, Added Voucher Date to Unpack_Check_Insert___ and Unpack_Check_Update___ methods
--  040929          and used it in code part validations in those methods.
--  040922  ChFolk  Bug 46993, Removed Security_SYS.Is_Method_Available checks in Check_Project_Code_Value___.
--  040723  JOHESE  Added default parameter skip_posting_type_check_ on Set_Project_Code_Part
--  040623  JOHESE  Modified Prj_Pre_Posting_Required___
--  040610  DiVelk  Modified Set_Pre_Posting and added Remove_Proj_Pre_Posting.
--  040519  UsRalk  Removed a condition on [activity_seq] to enable disconnect from activity.
--  040513  DiVelk  Modified procedure Set_Pre_Posting.
--  040202  IsWilk  Rewrote the DBMS_SQL to Native dynamic SQL for Unicode modification.
--  031030  AnLaSe  Call Id 99818, Added two new public methods, Modify and Set_Pre_Posting.
--  031013  PrJalk  Bug Fix 106224, Added missing General_Sys.Init_Method calls.
--  030916  SaRalk  Bug 38744, Modified function Get_Pre_Accounting_Id.
--  030804  MaEelk  Removed Red Code
--  030804  DAYJLK  Performed SP4 Merge.
--  030702  GEBOSE  Changed dynamic calls in method Get_Pre_Accounting_Id from directly calling
--  030702          calling Rotable_Pool_FA_Object_API to calling the intermediary package Fixass_Connection_V890_API
--  030611  JOHESE  Added code for fetching fixed asset object in Get_Pre_Accounting_Id
--  030305  ThPalk  Bug 35599, Added Function Check_Ord_Connected.
--  030214  WaJalk  Bug 35199, Added method Get_Distribution_Percentage.
--  030114  GaJalk  Bug 35004, Modified the function Get_Pre_Accounting_Id.
--  020923  ANLASE  **************** IceAge Merge Start *********************
--  020903  RAKOLK  Bug# 29967, chnaged the error msg.
--  020704  OLNISE  Bug# 31396 corrected, Handle distributed pre-accounting for non-inventory parts when
--                  registering transactions in Mpccom_Accounting_TAB.
--  020620  RAKOLK  Bug# 29967 Corrected.
--  ******************************** IceAge Merge End ***********************
--  011116  PuIllk  Bug 19099 , Earlier removed correction is re-appying after the system test.
--                  Get_Project_Code_Value___ to get the code_part from Logical Code Part when IFS/General Ledger is Not install.
--  011019  PuIllk  Bug REMOVE 19099, Removing the correction made since this bug cannot deliver for the service release.
--  011004  PEKR    Bug 19710. Project pre posting for WOISS. Prj_Pre_Posting_Required___ modified.
--  011004  PuIllk  Bug fix 19099, Check on the Procedure Get_Project_Code_Value___ to get the code_part from Logical Code Part
--                  when IFS/General Ledger is Not install.
--  011003  PuIllk  Bug fix 24658, Modify Company length to VARCHAR(20) in view comments of Views, Procedures Unpack_Check_Insert/Update,
--                  Check_Project_Code_Value, Do_Pre_Accounting, Compile_Codestrings and Function Get_Project_Code_Value.
--  010829  AnHose  Bug fix 22331, Added ledaccnt to view PRE_ACCOUNTING_CODEPART_A and checks in
--                  unpack_check_insert and unpack_check_update so no ledger accounts is manually entered.
--  010322  NAWALK  Modified the check for 'newrec_.amount_distribution =>1' to 'newrec_.amount_distribution > 1'
--                  in the function Unpack_Check_Update___()
--  010102  JOHW    Added check for order_type PUR ORDER in Prj_Pre_Posting_Required___ when
--                  activity_seq is > 0.
--  001212  JOHW    Changed handling for job costing in Check_Project_Code_Value___.
--  001127  SHVE    Replaced call to Project_Product_Structure_API.Get_Mrp_code with
--                  Transfer_shop_order_util_API.Get_Mp_Demand.
--  001124  JOHW    Corrected bind variable error in Shop_Material_Alloc_List_API.Is_DOP_Line_Pegged.
--  001116  JOHW    Corrected the dynamic call to Shop_Material_Alloc_List_API.Is_DOP_Line_Pegged
--  001106  JOHW    Corrected method Prj_Pre_Posting_Required___.
--  001103  SHVE    Added call to Shop_Material_Alloc_List_API.Is_Dop_Line_Pegged in
--                  method Prj_Pre_Posting_Required___.
--  001027  JOHW    Added funtionality for Job Costing in method Prj_Pre_Posting_Required___.
--  000925  JOHESE  Added undefines.
--  000728  ANLASE  Made attributes account_no, codeno_c, codeno_d, codeno_g, codeno_h,
--                  codeno_i, codeno_j, cost_center, object_no and project_no public.
--                  Corresponding get-methods were added.
--  000602  SHVE    Modified Get_Count_Ditribution to handle amount_distribution correctly.
--  000522  SHVE    Corrected handling of internal projects in Do_Pre_Accounting.
--  000515  SHVE    Wrong parameters in dynamic statements in  Prj_Pre_Posting_Required___.
--  000504  SHVE    Added method Get_Count_Distribution.
--  000427  SHVE    Added error_sys messages in Do_Pre_Accounting and Compile_Codestrings.
--  000418  NISOSE  Added General_SYS.Init_Method in Check_Distribution_Complete__, Execute_Accounting,
--                  Get_Allowed_Codeparts, Get_Pre_Accounting_Id and Validate_Codepart.
--  000412  SHVE    Added IN parameters pre_accounting_flag_db_, project_accounting_flag_db_
--                  to Do_Pre_Accounting and Compile_Codestrings.
--                  Added method Prj_Pre_Posting_Required___.
--  000306  LEPE    Bug correction in method Set_Project_Code_Part.
--  000218  LEPE    Developed method Mofify_Project_Code_Part and also changed name to
--                  Set_project_Code_Part because it now also inserts records.
--  000120  ROOD    Added method Distribution_Exist and used it in Pre_Accounting_Exist.
--  000118  LEPE    Added PROCEDURE Modify_Project_Code_Part.
--  000113  ROOD    Changed method Remove_Accounting_Id so that no errors occur if the accounting_id does not exist.
--  000104  ROOD    Corrected the usage of childrec_ and added a delete in Copy_Pre_Accounting.
--                  Added handling of deletion of children.
--  991206  ROOD    Made Check_Distribution_Complete private. Added Distribution functionality
--                  into Check_Mandatory_Code_Parts.
--  991201  ROOD    Added Methods Check_Distribution_Complete, Compile_Codestrings
--                  and Get_Allowed_Codeparts. Added parameter copy_distribution_
--                  in Copy_Pre_Accounting. Made method Execute_Accounting obsolete.
--  990614  SHVE    Added Get_Activity_Seq.
--  990610  DAZA    Rewrote Pre_Accounting_Exist and added a new Check_Exist that works
--                  like the old Pre_Accounting_Exist.
--  990609  ROOD    Moved code from Unpack_Check-methods to new method Check_Project_Code_Value___.
--  990601  ANHO    Removed comma from errormessages.
--  990601  ROOD    Added information about company in error messages in Unpack_Check_Update/Insert.
--  990415  JOHW    Upgraded to performance optimized template.
--  990414  JOHW    Corrected the dynamic call to AccountingCodeParts.
--  990401  JOHW    Added dynamic call to AccountingCodeParts.
--  990326  JOHW    Added checks on Activity_Seq.
--  990315  JOKE    Added method Get_Project_Code_Value___ plus validation in Unpack_Check_Insert.
--  980225  PaLj    Bug fix 7550, changed duplicate error labels from NOACCNT to NOACCNTINT and NOACCNTUPD respectively.
--  990219  JOKE    Added call to Activity_API.Get_Pre_Accounting_Id in Get_Pre_Accounting_Id.
--  990210  ROOD    Removed obsolete view PRE_ACCOUNTING_POSTING_CTRL and
--                  obsolete method Validate_Codepart_Value.
--  990205  ROOD    Added the new control type C58 in Check_Mandatory_Code_Parts.
--                  Added parameter source_identifier_ in Check_Mandatory_Code_Parts.
--  990127  LEPE    Added parameter ActivitySeq to method Insert_Pre_Accounting.
--                  Added validation for external projects in unpack_check_update___.
--                  Added new method Check_Mandatory_Code_Parts.
--  990114  JOKE    Added attribute (codepart) Activity_Seq.
--  990111  FRDI    Changed Sysdate to site dependent 'sysdate' - Site_API.Get_Site_Date(contract)
--                  And added new parameter to New and new derived column contract.
--  990103  ROOD    Added method Is_Preacc_Similar.
--  980417  GOPE    Added setting of rowverson in method Insert_Pre_Accounting
--  980126  FRDI    Clean up conection to Purchase requisition: WoOrder -> ActiveWorkOrderUtil
--  980123  FRDI    Clean up conection to Purchase requisition
--  980112  JOHO    Restructuring of shop order
--  971121  TOOS    Upgrade to F1 2.0
--  971009  JoAn    Changed Copy_Pre_Accounting not to create a new record
--                  if the record to copy from does not exist.
--  970909  GOPE    Added method New
--  970606  JOHNI   - Modified view PRE_ACCOUNTING_POSTING_CTRL to work in an
--                  upgraded database.
--                  - Removed substitution variable PRODUCT_CODE and hardcoded
--                  MPC4, this since it is not used in IFS Finance.
--  970515  GOPE    Added defered column COMPANY to get the LOV for code parts to work
--  970430  PEKR    Changed Get_Home_Company to Site_API.Get_Company(User_Default_API.Get_Contract).
--  970313  MAGN    Changed tablename mpc_pre_accounting to pre_accounting_tab.
--  970226  MAGN    Uses column rowversion as objversion(timestamp).
--  970123  GOPE    Made the call to Purchase_Order_Line to get pre acc id
--  970114  PEKR    Add VIEW2 -> VIEW12 to handle given value and pre postings.
--  961218  RaKu    Fixed bug in procedure Copy_Pre_Accounting.
--  961209  JOKE    Modified to workbench default template and added
--                  execute_Accounting plus changed the structure of
--                  copy_pre_accounting to use the base methods instead
--                  of making a direct insert.
--  961204  AnAr    Added Function Get_Next_Pre_Accounting_Id.
--  961121  ASBE    BUG 96-0004 Object_no and project_no reversed in
--                  procedure Do_Pre_Accounting.
--  960918  LEPE    Added exception handling for dynamic SQL.
--  960912  MAOS    Changed from SHOP_ORDER_API to SHOP_ORD_API.
--  960912  MAOS    Corrected dynamic SQL in Get_Pre_Accounting.
--  960911  PEKR    Change Mpc_Accounting_Pkg ==> Mpccom_Accounting_API.
--  960815  MAOS    Change work_order to wo_order in get_pre_accounting_id.
--  960815  MAOS    Added dynamic SQL in function Get_Pre_Accounting_Id.
--                  Removed cursor for SHOP_ORDER with function
--                  Shop_Order_API.Get_Pre_Accounting_Id.
--  960716  JICE    Added function Pre_Accounting_Exist.
--  960523  SHVE    Replaced table reference to oeorder_release with API call.
--  960517  AnAr    Added purpose comment to file.
--  960418  JOED    Added procedure Remove_Accounting_Id
--  960326  LEPE    Replaced several cursors with API-calls
--  960318  JICE    Modified and bugfixed calls to Error_SYS for localization
--  960307  SHVE    Changed LU Name GenPreAccounting.
--  951120  xxxx    Base Table to Logical Unit Generator 1.0
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE Codestring_Type IS RECORD (account_no            VARCHAR2(10),
                                   codeno_b              VARCHAR2(10),
                                   codeno_c              VARCHAR2(10),
                                   codeno_d              VARCHAR2(10),
                                   codeno_e              VARCHAR2(10),
                                   codeno_f              VARCHAR2(10),
                                   codeno_g              VARCHAR2(10),
                                   codeno_h              VARCHAR2(10),
                                   codeno_i              VARCHAR2(10),
                                   codeno_j              VARCHAR2(10),                                   
                                   activity_seq          VARCHAR2(10),
                                   amount_distribution   NUMBER);

TYPE Codestring_Table_Type IS TABLE OF Codestring_Type
        INDEX BY BINARY_INTEGER;

TYPE Codeparts_Settings_Rec IS RECORD    (all_codeparts_compiled VARCHAR2(9),
                                          account_no             VARCHAR2(9),
                                          codeno_b               VARCHAR2(9),
                                          codeno_c               VARCHAR2(9),
                                          codeno_d               VARCHAR2(9),
                                          codeno_e               VARCHAR2(9),
                                          codeno_f               VARCHAR2(9),
                                          codeno_g               VARCHAR2(9),
                                          codeno_h               VARCHAR2(9),
                                          codeno_i               VARCHAR2(9),
                                          codeno_j               VARCHAR2(9));

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Validate_Code_Parts___(
   newrec_           IN pre_accounting_tab%ROWTYPE,
   validation_date_  IN DATE)
IS
BEGIN
   IF ((newrec_.account_no IS NOT NULL) AND (NOT Account_API.Validate_Accnt( newrec_.company,
                                                                             newrec_.account_no,
                                                                             validation_date_))) THEN
      Error_SYS.Record_General(lu_name_, 'INVALIDACCOUNT: Account :P1 in company :P2 is missing or has an invalid time interval', newrec_.account_no, newrec_.company );
   END IF;
   IF (Account_API.Is_Ledger_Account(newrec_.company, newrec_.account_no)) THEN
      Error_SYS.Record_General(lu_name_, 'MANLEDGACCOUNT: Ledger Account :P1 is not permitted for manual entry', newrec_.account_no);
   END IF;
   IF (Account_API.Is_Stat_Account(newrec_.company, newrec_.account_no) = 'TRUE') THEN
      Error_SYS.Record_General(lu_name_, 'MANSTATACCOUNT: Account :P1 for which the Exclude from Voucher Balance check box is selected is not permitted for manual entry', newrec_.account_no);
   END IF;
   
   IF ((newrec_.codeno_b IS NOT NULL) AND (NOT Code_B_API.Validate_Code_Part( newrec_.company,
                                                                              newrec_.codeno_b,
                                                                              validation_date_))) THEN
      Error_SYS.Record_General(lu_name_, 'NOCODEB: Code B :P1 in company :P2 is missing or has an invalid time interval', newrec_.codeno_b, newrec_.company );
   END IF;

   IF ((newrec_.codeno_c IS NOT NULL) AND (NOT Code_C_API.Validate_Code_Part( newrec_.company,
                                                                              newrec_.codeno_c,
                                                                              validation_date_))) THEN
      Error_SYS.Record_General(lu_name_, 'NOCODEC: Code C :P1 in company :P2 is missing or has an invalid time interval', newrec_.codeno_c, newrec_.company );
   END IF;
   
   IF ((newrec_.codeno_d IS NOT NULL) AND (NOT Code_D_API.Validate_Code_Part( newrec_.company,
                                                                              newrec_.codeno_d,
                                                                              validation_date_))) THEN
      Error_SYS.Record_General(lu_name_, 'NOCODED: Code D :P1 in company :P2 is missing or has an invalid time interval', newrec_.codeno_d, newrec_.company );
   END IF;
   
   IF ((newrec_.codeno_e IS NOT NULL) AND (NOT Code_E_API.Validate_Code_Part( newrec_.company,
                                                                              newrec_.codeno_e,
                                                                              validation_date_))) THEN
      Error_SYS.Record_General(lu_name_, 'NOCODEE: Code E :P1 in company :P2 is missing or has an invalid time interval', newrec_.codeno_e, newrec_.company );
   END IF;

   IF ((newrec_.codeno_f IS NOT NULL) AND (NOT Code_F_API.Validate_Code_Part( newrec_.company,
                                                                              newrec_.codeno_f,
                                                                              validation_date_))) THEN
      Error_SYS.Record_General(lu_name_, 'NOCODEF: Code F :P1 in company :P2 is missing or has an invalid time interval', newrec_.codeno_f, newrec_.company );
   END IF;

   IF ((newrec_.codeno_g IS NOT NULL) AND (NOT Code_G_API.Validate_Code_Part( newrec_.company,
                                                                              newrec_.codeno_g,
                                                                              validation_date_))) THEN
      Error_SYS.Record_General(lu_name_, 'NOCODEG: Code G :P1 in company :P2 is missing or has an invalid time interval', newrec_.codeno_g, newrec_.company );
   END IF;

   IF ((newrec_.codeno_h IS NOT NULL) AND (NOT Code_H_API.Validate_Code_Part( newrec_.company,
                                                                              newrec_.codeno_h,
                                                                              validation_date_))) THEN
      Error_SYS.Record_General(lu_name_, 'NOCODEH: Code H :P1 in company :P2 is missing or has an invalid time interval', newrec_.codeno_h, newrec_.company );
   END IF;

   IF ((newrec_.codeno_i IS NOT NULL) AND (NOT Code_I_API.Validate_Code_Part( newrec_.company,
                                                                              newrec_.codeno_i,
                                                                              validation_date_))) THEN
      Error_SYS.Record_General(lu_name_, 'NOCODEI: Code I :P1 in company :P2 is missing or has an invalid time interval', newrec_.codeno_i, newrec_.company );
   END IF;

   IF ((newrec_.codeno_j IS NOT NULL) AND (NOT Code_J_API.Validate_Code_Part( newrec_.company,
                                                                              newrec_.codeno_j,
                                                                              validation_date_))) THEN
      Error_SYS.Record_General(lu_name_, 'NOCODEJ: Code J :P1 in company :P2 is missing or has an invalid time interval', newrec_.codeno_j, newrec_.company );
   END IF;
END Validate_Code_Parts___;

PROCEDURE Raise_Lines_Perc_Alloc_Err___
IS
BEGIN
   Error_SYS.Record_General(lu_name_, 'NODISTRIBUTIONINS: All lines must have a percentage allocation');
END Raise_Lines_Perc_Alloc_Err___; 

-- Get_Project_Code_Value___
--   Finds out which code part that holds the value of project no and
--   then return that value.
FUNCTION Get_Project_Code_Value___ (
   company_       IN VARCHAR2,
   newrec_        IN PRE_ACCOUNTING_TAB%ROWTYPE ) RETURN VARCHAR2
IS
   code_value_             VARCHAR2(10);
   code_part_              VARCHAR2(1);
   function_               VARCHAR2(5);
   logical_code_part_      VARCHAR2(10);
   dummy1_                 VARCHAR2(10);
   dummy2_                 VARCHAR2(15);
   dummy3_                 VARCHAR2(200);
BEGIN
   -- Get code_part that holds Project_Accounting (PRACC).
   function_ := 'PRACC';
   logical_code_part_ :='Project';
   $IF Component_Genled_SYS.INSTALLED $THEN        
      code_part_ := Accounting_Code_Parts_API.Get_Codepart_Function(company_,function_);           
   $ELSE
     -- When IFS/General Ledger IS NOT Install
     -- Checking a Logical Code is Used and get the Code Part from Logical Code Part
      IF Accounting_Code_Parts_API.Log_Code_Part_Used(company_, logical_code_part_) THEN
         Accounting_Code_Parts_API.Get_Log_Code_Part(code_part_,
                                                     dummy1_,
                                                     dummy2_,
                                                     dummy3_,
                                                     company_,
                                                     logical_code_part_);
      END IF;
   $END
   -- Get the value of that code part.
   IF code_part_ = 'A' THEN
      code_value_ := newrec_.account_no;
   ELSIF code_part_ = 'B' THEN
      code_value_ := newrec_.codeno_b;
   ELSIF code_part_ = 'C' THEN
      code_value_ := newrec_.codeno_c;
   ELSIF code_part_ = 'D' THEN
      code_value_ := newrec_.codeno_d;
   ELSIF code_part_ = 'E' THEN
      code_value_ := newrec_.codeno_e;
   ELSIF code_part_ = 'F' THEN
      code_value_ := newrec_.codeno_f;
   ELSIF code_part_ = 'G' THEN
      code_value_ := newrec_.codeno_g;
   ELSIF code_part_ = 'H' THEN
      code_value_ := newrec_.codeno_h;
   ELSIF code_part_ = 'I' THEN
      code_value_ := newrec_.codeno_i;
   ELSIF code_part_ = 'J' THEN
      code_value_ := newrec_.codeno_j;
   END IF;

   RETURN code_value_;
END Get_Project_Code_Value___;


-- Check_Project_Code_Value___
--   To check the different combinations allowed between Project code value and
--   its activity seq. concerning among other things if the project is external
--   or internal.
PROCEDURE Check_Project_Code_Value___ (
   company_             IN VARCHAR2,
   activity_seq_        IN NUMBER,
   code_value_          IN VARCHAR2,
   pre_posting_source_  IN VARCHAR2 )
IS
   project_id_            VARCHAR2(10);
BEGIN

   IF ((activity_seq_ IS NOT NULL) OR (code_value_ IS NOT NULL)) THEN
      IF code_value_ IS NOT NULL THEN
         IF (External_Project___(code_value_, company_)) THEN
            IF (activity_seq_ IS NOT NULL) THEN
               IF (activity_seq_ > 0) THEN
                  $IF Component_Proj_SYS.INSTALLED $THEN
                     BEGIN
                        project_id_ := Activity_API.Get_Project_Id(activity_seq_);
                     EXCEPTION
                        WHEN OTHERS THEN
                           Error_SYS.Record_General(lu_name_, 'DYNACTIVITY: The dynamic call to Activity_API.Get_Project_Id failed. Contact your system administrator.');
                     END;

                     IF ((project_id_ != code_value_) OR (project_id_ IS NULL)) THEN
                        Error_SYS.Record_General(lu_name_, 'ACTIVITY: The Activity Seq :P1 does not belong to Project :P2.', activity_seq_, code_value_);
                     END IF;
                  $ELSE
                     Error_SYS.Record_General(lu_name_, 'NOACTIVITY: You are not permitted to store values in Activity Seq because LU Activity is not installed.');
                  $END
                  END IF;
            ELSE
               IF (pre_posting_source_ != 'CUSTOMER ORDER') OR (pre_posting_source_ IS NULL) THEN
                  Error_SYS.Record_General(lu_name_, 'EXTPROJ: External Project must have a Project Activity connection.');
               END IF;
            END IF;
         ELSE
            IF (activity_seq_ IS NOT NULL) THEN
               Error_SYS.Record_General(lu_name_, 'INTPROJ: Internal Projects can not have any Activity Seq value.');
            END IF;
         END IF;
      ELSE
         Error_SYS.Record_General(lu_name_, 'NOCODEVALUE: You are not allowed to have a Activity Seq without a Project.');
      END IF;
   END IF;
END Check_Project_Code_Value___;

-- Prj_Pre_Posting_Required___
--   Checks if pre posting is required for the event.
PROCEDURE Prj_Pre_Posting_Required___ (
   prj_pre_posting_            OUT BOOLEAN,
   include_activity_seq_       OUT BOOLEAN,
   control_type_key_rec_       IN  Mpccom_Accounting_API.Control_Type_Key,
   project_accounting_flag_db_ IN  VARCHAR2,
   company_                    IN  VARCHAR2,
   codestring_rec_             IN  Accounting_Codestr_API.CodestrRec)
IS
   -- For job costing
   trans_code_pub_rec_ Mpccom_Transaction_Code_API.Public_Rec;
   job_id_             VARCHAR2(10);
   dop_line_pegged_    VARCHAR2(10):='FALSE';
   exclude_proj_followup_  VARCHAR2(5);

BEGIN

   prj_pre_posting_ := FALSE;
   IF (project_accounting_flag_db_ = 'EXCLUDE PROJECT PRE POSTING') THEN
      NULL;
   ELSIF (project_accounting_flag_db_ = 'INCLUDE PROJECT PRE POSTING') THEN
      prj_pre_posting_ := TRUE;
   ELSIF (project_accounting_flag_db_ = 'SITUATIONAL PROJECT PRE POSTING') THEN
      Trace_SYS.Message('TRACE Prj_pre-posting=> Situational Project Pre Posting');

      IF (NVL(control_type_key_rec_.activity_seq_, 0) > 0) THEN
         prj_pre_posting_ := TRUE;
      ELSIF control_type_key_rec_.activity_seq_ = 0 THEN
         -- Check if the order is related to Job Costing
         trans_code_pub_rec_ := Mpccom_Transaction_Code_API.Get(control_type_key_rec_.event_code_);

         IF (trans_code_pub_rec_.order_type = 'CUST ORDER') THEN
            $IF Component_Order_SYS.INSTALLED $THEN               
               job_id_ := Customer_Order_Line_API.Get_Job_Id(
                             control_type_key_rec_.oe_order_no_,
                             control_type_key_rec_.oe_line_no_,
                             control_type_key_rec_.oe_rel_no_,
                             control_type_key_rec_.oe_line_item_no_);
            $END

            IF job_id_ IS NOT NULL THEN
               prj_pre_posting_ := TRUE;
            END IF;

         ELSIF (trans_code_pub_rec_.order_type = 'PUR ORDER') THEN
            $IF Component_Purch_SYS.INSTALLED $THEN               
               job_id_ := Purchase_Order_Line_Part_API.Get_Job_Id(  control_type_key_rec_.pur_order_no_,
                                                                    control_type_key_rec_.pur_line_no_,
                                                                    control_type_key_rec_.pur_release_no_);               
            $END

            IF job_id_ IS NOT NULL THEN
               prj_pre_posting_ := TRUE;
            END IF;

         ELSIF (trans_code_pub_rec_.order_type = 'SHOP ORDER') THEN
            $IF Component_Shpord_SYS.INSTALLED $THEN               
               dop_line_pegged_ := Shop_Material_Alloc_List_API.Is_DOP_Line_Pegged(control_type_key_rec_.so_order_no_,
                                                                                   control_type_key_rec_.so_release_no_,
                                                                                   control_type_key_rec_.so_sequence_no_,
                                                                                   control_type_key_rec_.so_line_item_no_);
               IF (dop_line_pegged_ = 'TRUE') THEN
                  prj_pre_posting_ := TRUE;
               END IF;
            $ELSE
               NULL;
            $END
            END IF;
         END IF;
   ELSE
      Error_SYS.Record_General(lu_name_,'NOVALIDPRJACC: The posting event has an invalid project accounting flag. Contact your system administrator!');
   END IF;

   -- LEPESE -- This is the key of the new solution. 
   IF (prj_pre_posting_) THEN
      include_activity_seq_ := TRUE;
   ELSE
      IF (company_ IS NULL) OR (codestring_rec_.code_a IS NULL) THEN
         exclude_proj_followup_ := 'FALSE';
      ELSE
         exclude_proj_followup_ := Account_API.Get_Exclude_Proj_Followup(company_,
                                                                         codestring_rec_.code_a);
      END IF;

      IF (NVL(exclude_proj_followup_,'FALSE') = 'TRUE') THEN
         -- The setting of the two flags below gives us the desired functionality
         -- where project_id but not the activity_seq is added to the code string
         prj_pre_posting_      := TRUE;
         include_activity_seq_ := FALSE;
      END IF;
   END IF;
END Prj_Pre_Posting_Required___;


-- Notify_Source_On_Update___
--   This method used to notify pre posting source in pre accounting updates.
PROCEDURE Notify_Source_On_Update___ (
   oldrec_             IN PRE_ACCOUNTING_TAB%ROWTYPE,
   newrec_             IN PRE_ACCOUNTING_TAB%ROWTYPE,
   pre_posting_source_ IN VARCHAR2 )
IS
   dummy_char_         VARCHAR2(3) := CHR(1)||CHR(2)||CHR(3);
   dummy_num_          NUMBER      := -99999999999;
BEGIN
   IF ((NVL(oldrec_.account_no,dummy_char_) != NVL(newrec_.account_no,dummy_char_)) OR
      (NVL(oldrec_.codeno_b,dummy_char_) != NVL(newrec_.codeno_b,dummy_char_)) OR
      (NVL(oldrec_.codeno_c,dummy_char_) != NVL(newrec_.codeno_c,dummy_char_)) OR
      (NVL(oldrec_.codeno_d,dummy_char_) != NVL(newrec_.codeno_d,dummy_char_)) OR
      (NVL(oldrec_.codeno_e,dummy_char_) != NVL(newrec_.codeno_e,dummy_char_)) OR
      (NVL(oldrec_.codeno_f,dummy_char_) != NVL(newrec_.codeno_f,dummy_char_)) OR
      (NVL(oldrec_.codeno_g,dummy_char_) != NVL(newrec_.codeno_g,dummy_char_)) OR
      (NVL(oldrec_.codeno_h,dummy_char_) != NVL(newrec_.codeno_h,dummy_char_)) OR
      (NVL(oldrec_.codeno_i,dummy_char_) != NVL(newrec_.codeno_i,dummy_char_)) OR
      (NVL(oldrec_.codeno_j,dummy_char_) != NVL(newrec_.codeno_j,dummy_char_)) OR      
      (NVL(oldrec_.activity_seq,dummy_num_) != NVL(newrec_.activity_seq,dummy_num_))) THEN

      IF pre_posting_source_ = 'PURCHASE REQUISITION' THEN
         $IF Component_Purch_SYS.INSTALLED $THEN                     
            Purchase_Req_Line_API.Validate_Pre_Acc_Change(NVL(newrec_.parent_pre_accounting_id, newrec_.pre_accounting_id));
         $ELSE
            Error_SYS.Record_General(lu_name_ ,'NOPR: Purchase Requisition is not installed. Pre_accounting_id not found.');
         $END
         END IF;
      Notify_Pre_Posting_Source___(NVL(newrec_.parent_pre_accounting_id, newrec_.pre_accounting_id),
                                   pre_posting_source_ );
      
   ELSE
      IF (NVL(oldrec_.amount_distribution,dummy_num_) != NVL(newrec_.amount_distribution,dummy_num_)) THEN

         Notify_Pre_Posting_Source___(NVL(newrec_.parent_pre_accounting_id, newrec_.pre_accounting_id),
                                      pre_posting_source_ );
      END IF;
   END IF;
END Notify_Source_On_Update___;


-- Notify_Pre_Posting_Source___
--   This method is used to notify pre posting source.
PROCEDURE Notify_Pre_Posting_Source___ (
   pre_accounting_id_  IN NUMBER,
   pre_posting_source_ IN VARCHAR2 )
IS
BEGIN

   IF (pre_posting_source_ = 'PURCHASE ORDER') THEN
      $IF Component_Purch_SYS.INSTALLED $THEN
         Purchase_Order_API.Handle_Pre_Posting_Change(pre_accounting_id_);
      $ELSE
         Error_SYS.Record_General(lu_name_ ,'NOPO: Purchase Order is not installed. Pre_accounting_id not found.');
      $END
   ELSIF (pre_posting_source_ = 'PURCHASE ORDER LINE') THEN
      $IF Component_Purch_SYS.INSTALLED $THEN
         Purchase_Order_Line_API.Handle_Pre_Posting_Change(pre_accounting_id_);
      $ELSE
         Error_SYS.Record_General(lu_name_ ,'NOPOLINE: Purchase Order Line is not installed. Pre_accounting_id not found.');
      $END
   ELSIF (pre_posting_source_ = 'PURCH CHANGE ORDER LINE') THEN
      $IF Component_Purch_SYS.INSTALLED $THEN
         Purch_Chg_Ord_Line_API.Handle_Pre_Posting_Change(pre_accounting_id_);
      $ELSE
         Error_SYS.Record_General(lu_name_ ,'NOPOCOLINE: Purchase Change Order Line is not installed. Pre_accounting_id not found.');
      $END
   ELSIF (pre_posting_source_ = 'CUSTOMER ORDER') THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         Customer_Order_API.Handle_Pre_Posting_Change(pre_accounting_id_);
      $ELSE
         Error_SYS.Record_General(lu_name_ ,'NOCO: Customer Order is not installed. Pre_accounting_id not found.');
      $END
   ELSIF (pre_posting_source_ = 'CUSTOMER ORDER LINE') THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         Customer_Order_Line_API.Handle_Pre_Posting_Change(pre_accounting_id_);
      $ELSE
         Error_SYS.Record_General(lu_name_ ,'NOCOLINE: Customer Order Line is not installed. Pre_accounting_id not found.');
      $END
   ELSIF (pre_posting_source_ = 'PURCHASE REQUISITION') THEN
      $IF Component_Purch_SYS.INSTALLED $THEN
         Purchase_Req_Line_API.Handle_Pre_Posting_Change(pre_accounting_id_);
      $ELSE
         Error_SYS.Record_General(lu_name_ ,'NOPRLINE: Purchase Requisition Line is not installed. Pre_accounting_id not found.');
      $END
      END IF;
END Notify_Pre_Posting_Source___;


PROCEDURE Check_Allowed_Code_Parts___ (
   codeno_a_      IN VARCHAR2,
   codeno_b_      IN VARCHAR2,
   codeno_c_      IN VARCHAR2,
   codeno_d_      IN VARCHAR2,
   codeno_e_      IN VARCHAR2,
   codeno_f_      IN VARCHAR2,
   codeno_g_      IN VARCHAR2,
   codeno_h_      IN VARCHAR2,
   codeno_i_      IN VARCHAR2,
   codeno_j_      IN VARCHAR2,
   company_       IN VARCHAR2,
   posting_type_  IN VARCHAR2 )
IS
   is_code_a_            NUMBER;
   is_code_b_            NUMBER;
   is_code_c_            NUMBER;
   is_code_d_            NUMBER;
   is_code_e_            NUMBER;
   is_code_f_            NUMBER;
   is_code_g_            NUMBER;
   is_code_h_            NUMBER;
   is_code_i_            NUMBER;
   is_code_j_            NUMBER;
   error_code_part_      VARCHAR2(1);
   code_part_not_allowed EXCEPTION;
   code_part_name_       VARCHAR2(20);
BEGIN

   Get_Allowed_Codeparts(is_code_a_,
                         is_code_b_,
                         is_code_c_,
                         is_code_d_,
                         is_code_e_,
                         is_code_f_,
                         is_code_g_,
                         is_code_h_,
                         is_code_i_,
                         is_code_j_,
                         posting_type_,
                         NULL,
                         company_);

   IF (is_code_a_ = 0 AND (codeno_a_ IS NOT NULL)) THEN
      error_code_part_ := 'A';
      RAISE code_part_not_allowed;
   END IF;
   IF (is_code_b_ = 0 AND (codeno_b_ IS NOT NULL)) THEN
      error_code_part_ := 'B';
      RAISE code_part_not_allowed;
   END IF;
   IF (is_code_c_ = 0 AND (codeno_c_ IS NOT NULL)) THEN
      error_code_part_ := 'C';
      RAISE code_part_not_allowed;
   END IF;
   IF (is_code_d_ = 0 AND (codeno_d_ IS NOT NULL)) THEN
      error_code_part_ := 'D';
      RAISE code_part_not_allowed;
   END IF;
   IF (is_code_e_ = 0 AND (codeno_e_ IS NOT NULL)) THEN
      error_code_part_ := 'E';
      RAISE code_part_not_allowed;
   END IF;
   IF (is_code_f_ = 0 AND (codeno_f_ IS NOT NULL)) THEN
      error_code_part_ := 'F';
      RAISE code_part_not_allowed;
   END IF;
   IF (is_code_g_ = 0 AND (codeno_g_ IS NOT NULL)) THEN
      error_code_part_ := 'G';
      RAISE code_part_not_allowed;
   END IF;
   IF (is_code_h_ = 0 AND (codeno_h_ IS NOT NULL)) THEN
      error_code_part_ := 'H';
      RAISE code_part_not_allowed;
   END IF;
   IF (is_code_i_ = 0 AND (codeno_i_ IS NOT NULL)) THEN
      error_code_part_ := 'I';
      RAISE code_part_not_allowed;
   END IF;
   IF (is_code_j_ = 0 AND (codeno_j_ IS NOT NULL)) THEN
      error_code_part_ := 'J';
      RAISE code_part_not_allowed;
   END IF;

EXCEPTION
   WHEN code_part_not_allowed THEN
      code_part_name_ := Accounting_Code_Parts_API.Get_Name(company_, error_code_part_);
      Error_Sys.Record_General(lu_name_, 'CODEPARTNOTALLOWED: Code part :P1 is not allowed to have a pre-posting value since :P2 has not been enabled for code part :P1 in company :P3.', 
                               code_part_name_, posting_type_||' - '||Posting_Ctrl_Posting_Type_API.Get_Description(posting_type_), company_);
END Check_Allowed_Code_Parts___;


PROCEDURE Validate_Code_Parts___ (
   codeno_a_      IN VARCHAR2,
   codeno_b_      IN VARCHAR2,
   codeno_c_      IN VARCHAR2,
   codeno_d_      IN VARCHAR2,
   codeno_e_      IN VARCHAR2,
   codeno_f_      IN VARCHAR2,
   codeno_g_      IN VARCHAR2,
   codeno_h_      IN VARCHAR2,
   codeno_i_      IN VARCHAR2,
   codeno_j_      IN VARCHAR2,
   company_       IN VARCHAR2,
   contract_      IN VARCHAR2 )
IS
   today_         DATE;
BEGIN
   today_ := Site_API.Get_Site_Date(contract_);
   IF (codeno_a_ IS NOT NULL) THEN
      Validate_Codepart(codeno_a_, 'A', today_, company_);
   END IF;
   IF (codeno_b_ IS NOT NULL) THEN
      Validate_Codepart(codeno_b_, 'B', today_, company_);
   END IF;
   IF (codeno_c_ IS NOT NULL) THEN
      Validate_Codepart(codeno_c_, 'C', today_, company_);
   END IF;
   IF (codeno_d_ IS NOT NULL) THEN
      Validate_Codepart(codeno_d_, 'D', today_, company_);
   END IF;
   IF (codeno_e_ IS NOT NULL) THEN
      Validate_Codepart(codeno_e_, 'E', today_, company_);
   END IF;
   IF (codeno_f_ IS NOT NULL) THEN
      Validate_Codepart(codeno_f_, 'F', today_, company_);
   END IF;
   IF (codeno_g_ IS NOT NULL) THEN
      Validate_Codepart(codeno_g_, 'G', today_, company_);
   END IF;
   IF (codeno_h_ IS NOT NULL) THEN
      Validate_Codepart(codeno_h_, 'H', today_, company_);
   END IF;
   IF (codeno_i_ IS NOT NULL) THEN
      Validate_Codepart(codeno_i_, 'I', today_, company_);
   END IF;
   IF (codeno_j_ IS NOT NULL) THEN
      Validate_Codepart(codeno_j_, 'J', today_, company_);
   END IF;
END Validate_Code_Parts___;


FUNCTION Get_Project_Code_Part___ (
   company_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   testrec_             PRE_ACCOUNTING_TAB%ROWTYPE;
   project_code_part_   VARCHAR2(10);
BEGIN
   testrec_.account_no  := 'A';
   testrec_.codeno_b    := 'B';
   testrec_.codeno_c    := 'C';
   testrec_.codeno_d    := 'D';
   testrec_.codeno_e    := 'E';
   testrec_.codeno_f    := 'F';
   testrec_.codeno_g    := 'G';
   testrec_.codeno_h    := 'H';
   testrec_.codeno_i    := 'I';
   testrec_.codeno_j    := 'J';

   project_code_part_ := Get_Project_Code_Value___(company_, testrec_);

   RETURN project_code_part_;
END Get_Project_Code_Part___;


FUNCTION External_Project___ (
   project_no_ IN VARCHAR2,
   company_    IN VARCHAR2 ) RETURN BOOLEAN
IS
   external_project_flag_ VARCHAR2(10);
   external_project_      BOOLEAN := TRUE;
BEGIN
   $IF Component_Genled_SYS.INSTALLED $THEN
      external_project_flag_ := Accounting_Project_API.Get_Externally_Created(company_, project_no_);               
      IF (NVL(external_project_flag_,'N') = 'N') THEN
         external_project_ := FALSE;
      END IF;
   $END

   RETURN(external_project_);
END External_Project___;


PROCEDURE Remove_External_Project___ (
   pre_posting_rec_ IN OUT PRE_ACCOUNTING_TAB%ROWTYPE,
   company_         IN     VARCHAR2 )
IS
   project_code_part_  VARCHAR2(1);
   project_no_         PRE_ACCOUNTING_TAB.codeno_f%TYPE;
   exit_procedure_     EXCEPTION;
BEGIN

   project_code_part_ := Get_Project_Code_Part___(company_);

   IF (project_code_part_ IS NULL) THEN
      RAISE exit_procedure_;
   END IF;

   project_no_ :=
      CASE project_code_part_
         WHEN 'A' THEN pre_posting_rec_.account_no 
         WHEN 'B' THEN pre_posting_rec_.codeno_b
         WHEN 'C' THEN pre_posting_rec_.codeno_c   
         WHEN 'D' THEN pre_posting_rec_.codeno_d   
         WHEN 'E' THEN pre_posting_rec_.codeno_e  
         WHEN 'F' THEN pre_posting_rec_.codeno_f 
         WHEN 'G' THEN pre_posting_rec_.codeno_g   
         WHEN 'H' THEN pre_posting_rec_.codeno_h   
         WHEN 'I' THEN pre_posting_rec_.codeno_i   
         WHEN 'J' THEN pre_posting_rec_.codeno_j
      END;

   IF (project_no_ IS NULL) THEN
      RAISE exit_procedure_;
   END IF;

   IF (External_Project___(project_no_, company_)) THEN
      CASE project_code_part_
         WHEN 'A' THEN pre_posting_rec_.account_no  := NULL; 
         WHEN 'B' THEN pre_posting_rec_.codeno_b    := NULL; 
         WHEN 'C' THEN pre_posting_rec_.codeno_c    := NULL;     
         WHEN 'D' THEN pre_posting_rec_.codeno_d    := NULL; 
         WHEN 'E' THEN pre_posting_rec_.codeno_e    := NULL; 
         WHEN 'F' THEN pre_posting_rec_.codeno_f    := NULL; 
         WHEN 'G' THEN pre_posting_rec_.codeno_g    := NULL; 
         WHEN 'H' THEN pre_posting_rec_.codeno_h    := NULL; 
         WHEN 'I' THEN pre_posting_rec_.codeno_i    := NULL; 
         WHEN 'J' THEN pre_posting_rec_.codeno_j    := NULL;
      END CASE;
      IF (pre_posting_rec_.activity_seq IS NOT NULL) THEN
         pre_posting_rec_.activity_seq := NULL;   
      END IF;
   END IF;

EXCEPTION
   WHEN exit_procedure_ THEN
      NULL;
END Remove_External_Project___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT PRE_ACCOUNTING_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   pre_posting_source_     VARCHAR2(50);
BEGIN
   Cleanup_Distribution___(newrec_);
   
   super(objid_, objversion_, newrec_, attr_);
   pre_posting_source_ := Client_SYS.Get_Item_Value('PRE_POSTING_SOURCE',attr_);
   Client_SYS.Clear_Attr(attr_);

   Notify_Pre_Posting_Source___(NVL(newrec_.parent_pre_accounting_id, newrec_.pre_accounting_id),
                                pre_posting_source_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     PRE_ACCOUNTING_TAB%ROWTYPE,
   newrec_     IN OUT PRE_ACCOUNTING_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   pre_posting_source_     VARCHAR2(50);
BEGIN
   Cleanup_Distribution___(newrec_);
   
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   pre_posting_source_ := Client_SYS.Get_Item_Value('PRE_POSTING_SOURCE',attr_);
   Client_SYS.Clear_Attr(attr_);

   Notify_Source_On_Update___(oldrec_, newrec_, pre_posting_source_);

EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN PRE_ACCOUNTING_TAB%ROWTYPE )
IS
   info_ VARCHAR2(2000);

   CURSOR get_children(pre_accounting_id_ IN NUMBER) IS
      SELECT objid, objversion
      FROM PRE_ACCOUNTING
      WHERE parent_pre_accounting_id = pre_accounting_id_;
BEGIN
   -- To handle the special case of master detail for preaccounting distribution.
   FOR child_ IN get_children(remrec_.pre_accounting_id) LOOP
      Remove__(info_, child_.objid, child_.objversion, 'DO');
   END LOOP;
   super(objid_, remrec_);  
END Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_                 IN OUT pre_accounting_tab%ROWTYPE,
   indrec_                 IN OUT Indicator_Rec,
   attr_                   IN OUT VARCHAR2,
   validate_code_parts_    IN     BOOLEAN  DEFAULT TRUE     )
IS
   name_                  VARCHAR2(30);
   value_                 VARCHAR2(4000);
   contract_              VARCHAR2(5);
   code_value_            VARCHAR2(10);
   voucher_date_          DATE;
   validation_date_       DATE;
   pre_posting_source_    VARCHAR2(50);
   line_amount_           NUMBER;
   exit_procedure_        EXCEPTION;
BEGIN
   contract_ := Client_Sys.Get_Item_Value('CONTRACT', attr_);
   voucher_date_ := Client_SYS.Attr_Value_To_Date(Client_SYS.Get_Item_Value('VOUCHER_DATE', attr_));
   pre_posting_source_ := Client_Sys.Get_Item_Value('PRE_POSTING_SOURCE', attr_);   
   line_amount_ := Client_SYS.Attr_Value_To_Number(Client_Sys.Get_Item_Value('LINE_AMOUNT', attr_));   
    
   IF (newrec_.parent_pre_accounting_id IS NULL) THEN
      newrec_.amount_distribution := NULL;
   ELSE
      IF (newrec_.amount_distribution IS NULL) THEN
         IF (newrec_.total_amount IS NOT NULL) THEN
            IF (newrec_.total_amount = 0) THEN
               newrec_.amount_distribution := 0;
            ELSE
               newrec_.amount_distribution := (line_amount_ / newrec_.total_amount);
            END IF;
         END IF;
      END IF;
   END IF;
   super(newrec_, indrec_, attr_);

   Site_API.Exist(contract_);

   validation_date_ := NVL(voucher_date_, Site_API.Get_Site_Date(contract_));
   
   IF (NOT validate_code_parts_)THEN 
      RAISE exit_procedure_;
   END IF;
   
   Validate_Code_Parts___(newrec_, validation_date_);

   -- Get code_part that holds Project_Accounting (PRACC).
   code_value_ := Get_Project_Code_Value___(newrec_.company, newrec_);
   Check_Project_Code_Value___(newrec_.company, newrec_.activity_seq, code_value_, pre_posting_source_);
   IF newrec_.parent_pre_accounting_id IS NOT NULL THEN
      IF newrec_.amount_distribution IS NULL THEN
         Raise_Lines_Perc_Alloc_Err___;
      END IF;
   END IF;

   IF newrec_.amount_distribution IS NOT NULL THEN
      IF newrec_.amount_distribution <= 0 OR newrec_.amount_distribution > 1 THEN
         Raise_Amount_Dist_Err___;
      END IF;
   END IF;

   IF pre_posting_source_ IS NOT NULL THEN
      Client_SYS.Add_To_Attr('PRE_POSTING_SOURCE', pre_posting_source_,attr_);
   END IF;

EXCEPTION
   WHEN exit_procedure_ THEN
      Trace_SYS.Message('TRACE Preacc=> No validation done');
      NULL;   
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     pre_accounting_tab%ROWTYPE,
   newrec_ IN OUT pre_accounting_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_                   VARCHAR2(30);
   value_                  VARCHAR2(4000);
   contract_               VARCHAR2(5);
   project_no_changed_     BOOLEAN;
   activity_seq_changed_   BOOLEAN;
   new_code_value_         VARCHAR2(10);
   old_code_value_         VARCHAR2(10);
   dummy_char_             VARCHAR2(3) := CHR(1)||CHR(2)||CHR(3);
   dummy_num_              NUMBER      := -99999999999;
   voucher_date_           DATE;
   validation_date_        DATE;
   pre_posting_source_     VARCHAR2(50);
   line_amount_            NUMBER;
   skip_code_part_validation   EXCEPTION;
   skip_code_part_validation_  VARCHAR2(5) := 'FALSE';
BEGIN
   contract_ := Client_Sys.Get_Item_Value('CONTRACT', attr_);
   voucher_date_ := Client_SYS.Attr_Value_To_Date(Client_SYS.Get_Item_Value('VOUCHER_DATE', attr_));
   pre_posting_source_ := Client_Sys.Get_Item_Value('PRE_POSTING_SOURCE', attr_);   
   line_amount_ := Client_SYS.Attr_Value_To_Number(Client_Sys.Get_Item_Value('LINE_AMOUNT', attr_));   
   skip_code_part_validation_ := NVL(Client_Sys.Get_Item_Value('SKIP_CODE_PART_VALIDATION', attr_), 'FALSE');
   
   IF (newrec_.total_amount IS NULL) THEN
      newrec_.amount_distribution := NULL;
   ELSE
      IF (newrec_.total_amount = 0) THEN
         newrec_.amount_distribution := 0;
      ELSE
         newrec_.amount_distribution := (line_amount_ / newrec_.total_amount);
      END IF;
   END IF;
   
   super(oldrec_, newrec_, indrec_, attr_);
   Error_SYS.Check_Not_Null(lu_name_, 'PRE_ACCOUNTING_ID', newrec_.pre_accounting_id);

   Site_API.Exist(contract_);

   IF (skip_code_part_validation_ = 'TRUE') THEN
      RAISE skip_code_part_validation;
   END IF;  
   validation_date_ := NVL(voucher_date_, Site_API.Get_Site_Date(contract_));

   Validate_Code_Parts___(newrec_, validation_date_);

   -- Get code_part that holds Project_Accounting (PRACC).
   old_code_value_ := Get_Project_Code_Value___(newrec_.company, oldrec_);
   new_code_value_ := Get_Project_Code_Value___(newrec_.company, newrec_);

   project_no_changed_   := FALSE;
   activity_seq_changed_ := FALSE;

   IF NVL(old_code_value_, dummy_char_) != NVL(new_code_value_, dummy_char_) THEN
      project_no_changed_ := TRUE;
   END IF;

   IF NVL(oldrec_.activity_seq, dummy_num_) != NVL(newrec_.activity_seq, dummy_num_) THEN
      activity_seq_changed_ := TRUE;
   END IF;

   IF project_no_changed_ OR activity_seq_changed_ THEN
      Check_Project_Code_Value___(newrec_.company, newrec_.activity_seq, new_code_value_, pre_posting_source_);
   END IF;

   IF newrec_.parent_pre_accounting_id IS NOT NULL THEN
      IF newrec_.amount_distribution IS NULL THEN
         Raise_Lines_Perc_Alloc_Err___;
      END IF;
   END IF;

   IF (newrec_.amount_distribution IS NOT NULL) AND (Validate_SYS.Is_Changed(oldrec_.amount_distribution, newrec_.amount_distribution)) THEN
      IF newrec_.amount_distribution <= 0 OR newrec_.amount_distribution > 1 THEN
         Raise_Amount_Dist_Err___;
      END IF;
   END IF;

   IF pre_posting_source_ IS NOT NULL THEN
      Client_SYS.Add_To_Attr('PRE_POSTING_SOURCE', pre_posting_source_,attr_);
   END IF;

EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
   WHEN skip_code_part_validation THEN
      IF pre_posting_source_ IS NOT NULL THEN
         Client_SYS.Add_To_Attr('PRE_POSTING_SOURCE', pre_posting_source_,attr_);
      END IF;
END Check_Update___;


PROCEDURE Cleanup_Distribution___ (
   newrec_ IN OUT pre_accounting_tab%ROWTYPE )
IS
BEGIN
   IF (newrec_.parent_pre_accounting_id IS NOT NULL) THEN
      -- No need to store this for the children since we have it on the parent.
      newrec_.company      := NULL;
      newrec_.total_amount := NULL;
   END IF;
END Cleanup_Distribution___;


PROCEDURE Raise_Amount_Dist_Err___
IS BEGIN
   Error_SYS.Record_General(lu_name_, 'NOTPERCENTAGEUPD: The percentage must be greater than 0 and not exceed 100%');
END Raise_Amount_Dist_Err___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Check_Distribution_Complete__
--   To check if a distributed pre accounting is complete.
--   Meaning that the amount_distribution of the
--   underlaying rows add up to exactly 100%.
PROCEDURE Check_Distribution_Complete__ (
   pre_accounting_id_ IN NUMBER )
IS
   total_        NUMBER;
   check_ok_     BOOLEAN;

   CURSOR get_distribution(parent_pre_accounting_id_ IN NUMBER) IS
   SELECT SUM(NVL(amount_distribution, 0))
   FROM PRE_ACCOUNTING_TAB
   WHERE parent_pre_accounting_id = parent_pre_accounting_id_
   GROUP BY parent_pre_accounting_id;
BEGIN
   OPEN get_distribution(pre_accounting_id_);
   FETCH get_distribution INTO total_;
   total_ := ROUND(total_, 12);
   IF get_distribution%FOUND THEN
      IF total_ = 1 THEN
         check_ok_ := TRUE;
      ELSE
         check_ok_ := FALSE;
      END IF;
   ELSE
      -- no distribution found is ok!
      check_ok_ := TRUE;
   END IF;
   CLOSE get_distribution;
   IF NOT check_ok_ THEN
      Error_SYS.Record_General(lu_name_, 'NOTCOMPLETE: The Pre Posting is not completed. The distribution has to add to 100%');
   END IF;
END Check_Distribution_Complete__;


-- Get_Distributed_Amount__
--   This method is used to calculate the Distributed amount of the line
--   based on the percentage and the total amount.
@UncheckedAccess
FUNCTION Get_Distributed_Amount__ (
   pre_accounting_id_ IN NUMBER,
   total_amount_ IN NUMBER ) RETURN NUMBER
IS
   CURSOR get_amount_distribution IS
      SELECT amount_distribution
        FROM PRE_ACCOUNTING_TAB
       WHERE pre_accounting_id = pre_accounting_id_;

   amount_distribution_ NUMBER;
   line_amount_         NUMBER;
BEGIN
   OPEN get_amount_distribution;
   FETCH get_amount_distribution INTO amount_distribution_;
   CLOSE get_amount_distribution;
   line_amount_ := (NVL(amount_distribution_, 0) * total_amount_);
   RETURN line_amount_;
END Get_Distributed_Amount__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Pre_Accounting
--   Get pre accounting.
PROCEDURE Get_Pre_Accounting (
   account_no_            IN OUT VARCHAR2,
   account_no_desc_       IN OUT VARCHAR2,
   codeno_b_              IN OUT VARCHAR2,
   codeno_b_desc_         IN OUT VARCHAR2,
   codeno_c_              IN OUT VARCHAR2,
   codeno_c_desc_         IN OUT VARCHAR2,
   codeno_d_              IN OUT VARCHAR2,
   codeno_d_desc_         IN OUT VARCHAR2,
   codeno_e_              IN OUT VARCHAR2,
   codeno_e_desc_         IN OUT VARCHAR2,
   codeno_f_              IN OUT VARCHAR2,
   codeno_f_desc_         IN OUT VARCHAR2,
   codeno_g_              IN OUT VARCHAR2,
   codeno_g_desc_         IN OUT VARCHAR2,
   codeno_h_              IN OUT VARCHAR2,
   codeno_h_desc_         IN OUT VARCHAR2,
   codeno_i_              IN OUT VARCHAR2,
   codeno_i_desc_         IN OUT VARCHAR2,
   codeno_j_              IN OUT VARCHAR2,
   codeno_j_desc_         IN OUT VARCHAR2,
   pre_accounting_id_     IN     NUMBER,
   company_               IN     VARCHAR2 )
IS
   CURSOR get_pre_accounting IS
   SELECT account_no, codeno_b, codeno_c, codeno_d, codeno_e, codeno_f,
          codeno_g, codeno_h, codeno_i, codeno_j
   FROM PRE_ACCOUNTING
   WHERE pre_accounting_id = pre_accounting_id_;
   --
BEGIN
   --
      OPEN  get_pre_accounting;
      FETCH get_pre_accounting INTO account_no_,
                                    codeno_b_,
                                    codeno_c_,
                                    codeno_d_,
                                    codeno_e_,
                                    codeno_f_,
                                    codeno_g_,
                                    codeno_h_,
                                    codeno_i_,
                                    codeno_j_;
      CLOSE get_pre_accounting;

      IF account_no_ IS NOT NULL THEN
         Account_API.Get_description ( account_no_desc_,
                                       company_,
                                       account_no_);
      END IF;

      IF codeno_b_ IS NOT NULL THEN
         Code_B_Api.Get_description ( codeno_b_desc_,
                                      company_,
                                      codeno_b_);
      END IF;

      IF codeno_c_ IS NOT NULL THEN
         Code_C_API.Get_description ( codeno_c_desc_,
                                      company_,
                                      codeno_c_);
      END IF;

      IF codeno_d_ IS NOT NULL THEN
         Code_D_API.Get_description ( codeno_d_desc_,
                                      company_,
                                      codeno_d_);
      END IF;

      IF codeno_e_ IS NOT NULL THEN
         Code_E_API.Get_description ( codeno_e_desc_,
                                      company_,
                                      codeno_e_);
      END IF;

      IF codeno_f_ IS NOT NULL THEN
         Code_F_API.Get_description ( codeno_f_desc_,
                                      company_,
                                      codeno_f_);
      END IF;

      IF codeno_g_ IS NOT NULL THEN
         Code_G_API.Get_description ( codeno_g_desc_,
                                      company_,
                                      codeno_g_);
      END IF;

      IF codeno_h_ IS NOT NULL THEN
         Code_H_API.Get_description ( codeno_h_desc_,
                                      company_,
                                      codeno_h_);
      END IF;

      IF codeno_i_ IS NOT NULL THEN
         Code_I_API.Get_description ( codeno_i_desc_,
                                      company_,
                                      codeno_i_);
      END IF;

      IF codeno_j_ IS NOT NULL THEN
         Code_J_API.Get_description ( codeno_j_desc_,
                                      company_,
                                      codeno_j_);
      END IF;
   --
EXCEPTION
   WHEN no_data_found THEN
     null;
END Get_Pre_Accounting;


-- Insert_Pre_Accounting
--   Inserts or updates pre accounting.
PROCEDURE Insert_Pre_Accounting (
   pre_accounting_id_     IN  NUMBER,
   account_no_            IN  VARCHAR2,
   codeno_b_              IN  VARCHAR2,
   codeno_c_              IN  VARCHAR2,
   codeno_d_              IN  VARCHAR2,
   codeno_e_              IN  VARCHAR2,
   codeno_f_              IN  VARCHAR2,
   codeno_g_              IN  VARCHAR2,
   codeno_h_              IN  VARCHAR2,
   codeno_i_              IN  VARCHAR2,
   codeno_j_              IN  VARCHAR2,
   activity_seq_          IN  NUMBER DEFAULT Null )
IS
BEGIN

      IF Check_Exist___(pre_accounting_id_) THEN
         UPDATE pre_accounting_tab
         SET    account_no = account_no_,
                codeno_b = codeno_b_,
                codeno_c = codeno_c_,
                codeno_d = codeno_d_,
                codeno_e = codeno_e_,
                codeno_f = codeno_f_,
                codeno_g = codeno_g_,
                codeno_h = codeno_h_,
                codeno_i = codeno_i_,
                codeno_j = codeno_j_,                
                activity_seq = activity_seq_,
                rowversion = sysdate
         WHERE  pre_accounting_id = pre_accounting_id_;
      ELSE
         INSERT INTO
         pre_accounting_tab (pre_accounting_id,
                             account_no,
                             codeno_b,
                             codeno_c,
                             codeno_d,
                             codeno_e,
                             codeno_f,
                             codeno_g,
                             codeno_h,
                             codeno_i,
                             codeno_j,                             
                             activity_seq,
                             rowversion)
         VALUES
                            (pre_accounting_id_,
                             account_no_,
                             codeno_b_,
                             codeno_c_,
                             codeno_d_,
                             codeno_e_,
                             codeno_f_,
                             codeno_g_,
                             codeno_h_,
                             codeno_i_,
                             codeno_j_,                             
                             activity_seq_,
                             sysdate);
      END IF;
END Insert_Pre_Accounting;


-- New
--   Creates a new instance of pre accounting.
PROCEDURE New (
   pre_accounting_id_         IN NUMBER,
   account_no_                IN VARCHAR2,
   codeno_b_                  IN VARCHAR2,
   codeno_c_                  IN VARCHAR2,
   codeno_d_                  IN VARCHAR2,
   codeno_e_                  IN VARCHAR2,
   codeno_f_                  IN VARCHAR2,
   codeno_g_                  IN VARCHAR2,
   codeno_h_                  IN VARCHAR2,
   codeno_i_                  IN VARCHAR2,
   codeno_j_                  IN VARCHAR2,
   company_                   IN VARCHAR2,
   posting_type_              IN VARCHAR2,
   contract_                  IN VARCHAR2,
   activity_seq_              IN NUMBER DEFAULT Null,
   check_allowed_code_parts_  IN BOOLEAN DEFAULT TRUE )
IS
   attr_           VARCHAR2(32000);
   newrec_         PRE_ACCOUNTING_TAB%ROWTYPE;
   objid_          PRE_ACCOUNTING.objid%TYPE;
   objversion_     PRE_ACCOUNTING.objversion%TYPE;
   indrec_         Indicator_Rec;
BEGIN
   IF (check_allowed_code_parts_) THEN
      Check_Allowed_Code_Parts___(account_no_,
                                  codeno_b_,
                                  codeno_c_,
                                  codeno_d_,
                                  codeno_e_,
                                  codeno_f_,
                                  codeno_g_,
                                  codeno_h_,
                                  codeno_i_,
                                  codeno_j_,
                                  company_,
                                  posting_type_);
   END IF;

   Validate_Code_Parts___(account_no_,
                          codeno_b_,
                          codeno_c_,
                          codeno_d_,
                          codeno_e_,
                          codeno_f_,
                          codeno_g_,
                          codeno_h_,
                          codeno_i_,
                          codeno_j_,
                          company_,
                          contract_);
   
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr( 'PRE_ACCOUNTING_ID', pre_accounting_id_, attr_ );
   Client_SYS.Add_To_Attr( 'ACCOUNT_NO', account_no_, attr_ );
   Client_SYS.Add_To_Attr( 'CODENO_B', codeno_b_, attr_ );
   Client_SYS.Add_To_Attr( 'CODENO_C', codeno_c_, attr_ );
   Client_SYS.Add_To_Attr( 'CODENO_D', codeno_d_, attr_ );
   Client_SYS.Add_To_Attr( 'CODENO_E', codeno_e_, attr_ );
   Client_SYS.Add_To_Attr( 'CODENO_F', codeno_f_, attr_ );
   Client_SYS.Add_To_Attr( 'CODENO_G', codeno_g_, attr_ );
   Client_SYS.Add_To_Attr( 'CODENO_H', codeno_h_, attr_ );
   Client_SYS.Add_To_Attr( 'CODENO_I', codeno_i_, attr_ );
   Client_SYS.Add_To_Attr( 'CODENO_J', codeno_j_, attr_ );
   Client_SYS.Add_To_Attr( 'COMPANY', company_, attr_ );
   Client_SYS.Add_To_Attr( 'CONTRACT', contract_, attr_ );
   Client_SYS.Add_To_Attr( 'ACTIVITY_SEQ', activity_seq_, attr_ );

   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);
END New;


-- Copy_Pre_Accounting
--   Copy pre accounting.
PROCEDURE Copy_Pre_Accounting (
   old_pre_accounting_id_    IN NUMBER,
   new_pre_accounting_id_    IN NUMBER,
   contract_                 IN VARCHAR2,
   copy_distribution_        IN BOOLEAN DEFAULT NULL,
   pre_posting_source_       IN VARCHAR2 DEFAULT NULL,
   validate_code_parts_      IN BOOLEAN  DEFAULT TRUE,
   remove_external_project_  IN BOOLEAN  DEFAULT FALSE)
IS
   newrec_     PRE_ACCOUNTING_TAB%ROWTYPE;
   attr_       VARCHAR2(2000);
   objid_      PRE_ACCOUNTING.objid%TYPE;
   objversion_ PRE_ACCOUNTING.objversion%TYPE;
   childrec_   PRE_ACCOUNTING_TAB%ROWTYPE;
   indrec_     Indicator_Rec;
   CURSOR get_children (parent_pre_accounting_id_ IN NUMBER) IS
      SELECT pre_accounting_id
      FROM PRE_ACCOUNTING_TAB
      WHERE parent_pre_accounting_id = parent_pre_accounting_id_;
BEGIN

   -- Delete if there are any already present occurence of the new pre_accounting_id.
   IF (Check_Exist___(new_pre_accounting_id_)) THEN
      Remove_Accounting_Id(new_pre_accounting_id_);
   END IF;

   -- Fetches old pre_accounting and change to the new pre_accounting_id.
   IF (Check_Exist___(old_pre_accounting_id_)) THEN
      newrec_ := Get_Object_By_Keys___(old_pre_accounting_id_);
      newrec_.pre_accounting_id := new_pre_accounting_id_;
      IF (pre_posting_source_ = 'CUSTOMER ORDER') AND (newrec_.activity_seq IS NULL OR remove_external_project_) THEN
         Remove_External_Project___(newrec_, Site_API.Get_Company(contract_));
      END IF;
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_);
      Client_SYS.Add_To_Attr('COMPANY', Site_API.Get_Company(contract_), attr_);
      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_, validate_code_parts_);

      -- Insert the new pre_accounting using the insert base method.
      newrec_.rowkey := NULL;
      Insert___ (objid_, objversion_, newrec_, attr_);
   END IF;

   -- Copy the children in the distribution if conditions are met.
   IF copy_distribution_ AND copy_distribution_ IS NOT NULL THEN
      FOR child IN get_children(old_pre_accounting_id_) LOOP
         -- Fetch all info about current child.
         childrec_ := Get_Object_By_Keys___(child.pre_accounting_id);
         -- Change the old id's to the correct new ones.
         childrec_.pre_accounting_id := Get_Next_Pre_Accounting_Id;
         childrec_.parent_pre_accounting_id := new_pre_accounting_id_;

         Client_SYS.Clear_Attr(attr_);
         Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_);
         Client_SYS.Add_To_Attr('COMPANY', Site_API.Get_Company(contract_), attr_);
         Unpack___(newrec_, indrec_, attr_);
         Check_Insert___(newrec_, indrec_, attr_);

         -- Insert the new pre_accounting child using the insert base method.
         newrec_.rowkey := NULL;
         Insert___ (objid_, objversion_, childrec_, attr_);
      END LOOP;
   END IF;

END Copy_Pre_Accounting;


-- Set_Pre_Posting
--   This public method can be used to set code part vales.
PROCEDURE Set_Pre_Posting (
   pre_accounting_id_        IN NUMBER,
   contract_                 IN VARCHAR2,
   posting_type_             IN VARCHAR2,
   codeno_a_                 IN VARCHAR2,
   codeno_b_                 IN VARCHAR2,
   codeno_c_                 IN VARCHAR2,
   codeno_d_                 IN VARCHAR2,
   codeno_e_                 IN VARCHAR2,
   codeno_f_                 IN VARCHAR2,
   codeno_g_                 IN VARCHAR2,
   codeno_h_                 IN VARCHAR2,
   codeno_i_                 IN VARCHAR2,
   codeno_j_                 IN VARCHAR2,
   activity_seq_             IN NUMBER,
   replace_pre_posting_      IN VARCHAR2,
   replace_proj_pre_posting_ IN VARCHAR2,
   check_allowed_code_parts_ IN BOOLEAN DEFAULT TRUE,
   replace_with_null_        IN BOOLEAN DEFAULT FALSE,
   skip_code_part_validation_ IN BOOLEAN DEFAULT FALSE )
IS
   company_               VARCHAR2(20);
   oldrec_                PRE_ACCOUNTING_TAB%ROWTYPE;
   project_code_part_     VARCHAR2(10);

BEGIN

   company_ := Site_API.Get_Company(contract_);
   IF (Check_Exist___(pre_accounting_id_)) THEN

      project_code_part_ := Get_Project_Code_Part___(company_);

      IF (project_code_part_ IS NULL) THEN
          -- Possible values for code parts are from A...J
          project_code_part_ := 'X';
      END IF;

      oldrec_ := Get_Object_By_Keys___(pre_accounting_id_);

      IF ((oldrec_.account_no IS NULL) OR
            ((project_code_part_  = 'A') AND (replace_proj_pre_posting_ = 'TRUE')) OR
            ((project_code_part_ != 'A') AND (replace_pre_posting_      = 'TRUE'))) THEN
            IF ((codeno_a_ IS NOT NULL) OR (replace_with_null_)) THEN
               oldrec_.account_no := codeno_a_;
            END IF;
      END IF;

      IF ((oldrec_.codeno_b IS NULL) OR
            ((project_code_part_  = 'B') AND (replace_proj_pre_posting_ = 'TRUE')) OR
            ((project_code_part_ != 'B') AND (replace_pre_posting_      = 'TRUE'))) THEN
            IF ((codeno_b_ IS NOT NULL) OR (replace_with_null_)) THEN
               oldrec_.codeno_b := codeno_b_;
            END IF;
      END IF;

      IF ((oldrec_.codeno_c IS NULL) OR
            ((project_code_part_  = 'C') AND (replace_proj_pre_posting_ = 'TRUE')) OR
            ((project_code_part_ != 'C') AND (replace_pre_posting_      = 'TRUE'))) THEN
            IF ((codeno_c_ IS NOT NULL) OR (replace_with_null_)) THEN
               oldrec_.codeno_c := codeno_c_;
            END IF;
      END IF;

      IF ((oldrec_.codeno_d IS NULL) OR
            ((project_code_part_  = 'D') AND (replace_proj_pre_posting_ = 'TRUE')) OR
            ((project_code_part_ != 'D') AND (replace_pre_posting_      = 'TRUE'))) THEN
            IF ((codeno_d_ IS NOT NULL) OR (replace_with_null_)) THEN
               oldrec_.codeno_d := codeno_d_;
            END IF;
      END IF;

      IF ((oldrec_.codeno_e IS NULL) OR
            ((project_code_part_  = 'E') AND (replace_proj_pre_posting_ = 'TRUE')) OR
            ((project_code_part_ != 'E') AND (replace_pre_posting_      = 'TRUE'))) THEN
            IF ((codeno_e_ IS NOT NULL) OR (replace_with_null_)) THEN
               oldrec_.codeno_e := codeno_e_ ;
            END IF;
      END IF;

      IF ((oldrec_.codeno_f IS NULL) OR
            ((project_code_part_  = 'F') AND (replace_proj_pre_posting_ = 'TRUE')) OR
            ((project_code_part_ != 'F') AND (replace_pre_posting_      = 'TRUE'))) THEN
            IF ((codeno_f_ IS NOT NULL) OR (replace_with_null_)) THEN
               oldrec_.codeno_f := codeno_f_;
            END IF;
      END IF;

      IF ((oldrec_.codeno_g IS NULL) OR
            ((project_code_part_  = 'G') AND (replace_proj_pre_posting_ = 'TRUE')) OR
            ((project_code_part_ != 'G') AND (replace_pre_posting_      = 'TRUE'))) THEN
            IF ((codeno_g_ IS NOT NULL) OR (replace_with_null_)) THEN
               oldrec_.codeno_g  := codeno_g_;
            END IF;
      END IF;

      IF ((oldrec_.codeno_h IS NULL) OR
            ((project_code_part_  = 'H') AND (replace_proj_pre_posting_ = 'TRUE')) OR
            ((project_code_part_ != 'H') AND (replace_pre_posting_      = 'TRUE'))) THEN
            IF ((codeno_h_ IS NOT NULL) OR (replace_with_null_)) THEN
               oldrec_.codeno_h := codeno_h_;
            END IF;
      END IF;

      IF ((oldrec_.codeno_i IS NULL) OR
            ((project_code_part_  = 'I') AND (replace_proj_pre_posting_ = 'TRUE')) OR
            ((project_code_part_ != 'I') AND (replace_pre_posting_      = 'TRUE'))) THEN
            IF ((codeno_i_ IS NOT NULL) OR (replace_with_null_)) THEN
               oldrec_.codeno_i := codeno_i_;
            END IF;
      END IF;

      IF ((oldrec_.codeno_j IS NULL) OR
            ((project_code_part_  = 'J') AND (replace_proj_pre_posting_ = 'TRUE')) OR
            ((project_code_part_ != 'J') AND (replace_pre_posting_      = 'TRUE'))) THEN
            IF ((codeno_j_ IS NOT NULL) OR (replace_with_null_)) THEN
               oldrec_.codeno_j := codeno_j_;
            END IF;
      END IF;

      IF ((oldrec_.activity_seq IS NULL) OR
            (replace_proj_pre_posting_ = 'TRUE')) THEN

            oldrec_.activity_seq := activity_seq_;
      END IF;
      
      Modify(pre_accounting_id_,
             oldrec_.account_no,
             oldrec_.codeno_b,
             oldrec_.codeno_c,
             oldrec_.codeno_d,
             oldrec_.codeno_e,
             oldrec_.codeno_f,
             oldrec_.codeno_g,
             oldrec_.codeno_h,
             oldrec_.codeno_i,
             oldrec_.codeno_j,
             company_,
             posting_type_,
             contract_,
             oldrec_.activity_seq,
             check_allowed_code_parts_,
             skip_code_part_validation_ => skip_code_part_validation_);
   ELSE
      New(pre_accounting_id_,
          codeno_a_,
          codeno_b_,
          codeno_c_,
          codeno_d_,
          codeno_e_,
          codeno_f_,
          codeno_g_,
          codeno_h_,
          codeno_i_,
          codeno_j_,
          company_,
          posting_type_,
          contract_,
          activity_seq_,
          check_allowed_code_parts_);
   END IF;

END Set_Pre_Posting;

-- Do_Pre_Accounting
--   Do pre accounting.
PROCEDURE Do_Pre_Accounting (
   activity_seq_               OUT    NUMBER,
   codestring_rec_             IN OUT Accounting_Codestr_API.CodestrRec,
   control_type_key_rec_       IN     Mpccom_Accounting_API.Control_Type_Key,
   pre_accounting_id_          IN     NUMBER,
   pre_accounting_flag_db_     IN     VARCHAR2,
   project_accounting_flag_db_ IN     VARCHAR2)
IS
   company_                 VARCHAR2(20);
   pre_acc_rec_             PRE_ACCOUNTING_TAB%ROWTYPE;
   project_code_part_       VARCHAR2(1):= NULL;

   project_pre_posting_     BOOLEAN :=FALSE;
   other_pre_posting_       BOOLEAN:=FALSE;
   include_activity_seq_    BOOLEAN := FALSE;
   all_is_ready_            EXCEPTION;

BEGIN

   IF ((pre_accounting_flag_db_ IS NULL) OR (pre_accounting_flag_db_ NOT IN ('Y','N'))) THEN
      Error_SYS.Record_General(lu_name_,'NOVALIDPREACC: The posting event has an invalid preaccounting flag. Contact your system administrator.');
   END IF;

   pre_acc_rec_ := Get_Object_By_Keys___(pre_accounting_id_);

   IF pre_acc_rec_.pre_accounting_id IS NULL THEN
      --Cannot find a preaccounting record, exit!
      RAISE all_is_ready_;
   END IF;

   IF ((pre_accounting_flag_db_ ='N') AND
       (project_accounting_flag_db_ = 'EXCLUDE PROJECT PRE POSTING') AND
       (pre_acc_rec_.activity_seq IS NULL)) THEN
      --no preaccounting required, exit!
      RAISE all_is_ready_;
   END IF;

   IF pre_accounting_flag_db_ ='Y' THEN
      Trace_SYS.Message('TRACE PreAcc=> Pre-acc-flag TRUE');
      other_pre_posting_ := TRUE;
   END IF;

   IF (pre_acc_rec_.activity_seq IS NULL) THEN
      --Not an external project
      project_pre_posting_ := FALSE;
   ELSE
      --External project, check if project requires preaccounting
      company_ := Site_API.Get_Company(control_type_key_rec_.contract_);            
      Prj_Pre_Posting_Required___(project_pre_posting_,
                                  include_activity_seq_,
                                  control_type_key_rec_,
                                  project_accounting_flag_db_,
                                  company_,
                                  codestring_rec_);
   END IF;

   IF ((NOT project_pre_posting_) AND (NOT other_pre_posting_)) THEN
      --no preaccounting required, exit!
      RAISE all_is_ready_;
   END IF;

   IF (((project_pre_posting_) AND (NOT other_pre_posting_)) OR
       ((other_pre_posting_)   AND (NOT project_pre_posting_))) THEN
      IF (pre_acc_rec_.activity_seq IS NULL) THEN
         --Internal project
         project_code_part_ := NULL;
      ELSE
         IF (company_ IS NULL) THEN
            company_ := Site_API.Get_Company(control_type_key_rec_.contract_);
         END IF;

         --Get the project code part
         project_code_part_ := Get_Project_Code_Part___(company_);
      END IF;
   END IF;

   IF (project_code_part_ IS NULL) THEN
       -- Possible values for code parts are from A...J
       project_code_part_ := 'X';
   END IF;

   Trace_SYS.Message('TRACE PreAcc=> Project code part-'||project_code_part_);

-- LEPESE This is a cornerstone in the solution. We have a separate flag to indicathe whether the activity_seq should be included.
   IF (include_activity_seq_) THEN
       activity_seq_ := pre_acc_rec_.activity_seq;
   END IF;

   -- Assign pre_accounting values to the code parts
   IF (pre_acc_rec_.account_no IS NOT NULL) THEN
      IF (((project_code_part_  = 'A') AND (project_pre_posting_)) OR
          ((project_code_part_ != 'A') AND (other_pre_posting_  ))) THEN
            codestring_rec_.code_a := pre_acc_rec_.account_no;
      END IF;
   END IF;

   IF (pre_acc_rec_.codeno_b IS NOT NULL) THEN
      IF (((project_code_part_  = 'B') AND (project_pre_posting_)) OR
          ((project_code_part_ != 'B') AND (other_pre_posting_  ))) THEN
         codestring_rec_.code_b := pre_acc_rec_.codeno_b;
      END IF;
   END IF;

   IF (pre_acc_rec_.codeno_c IS NOT NULL) THEN
      IF (((project_code_part_  = 'C') AND (project_pre_posting_)) OR
          ((project_code_part_ != 'C') AND (other_pre_posting_  ))) THEN
            codestring_rec_.code_c := pre_acc_rec_.codeno_c;
      END IF;
   END IF;

   IF (pre_acc_rec_.codeno_d IS NOT NULL) THEN
      IF (((project_code_part_  = 'D') AND (project_pre_posting_)) OR
          ((project_code_part_ != 'D') AND (other_pre_posting_  ))) THEN
          codestring_rec_.code_d := pre_acc_rec_.codeno_d;
      END IF;
   END IF;

   IF (pre_acc_rec_.codeno_e IS NOT NULL) THEN
      IF (((project_code_part_  = 'E') AND (project_pre_posting_)) OR
          ((project_code_part_ != 'E') AND (other_pre_posting_  ))) THEN
         codestring_rec_.code_e := pre_acc_rec_.codeno_e;
      END IF;
   END IF;

   Trace_SYS.Message('TRACE Preacc=> codeno_f'||pre_acc_rec_.codeno_f);
   IF (pre_acc_rec_.codeno_f IS NOT NULL) THEN
      IF (((project_code_part_  = 'F') AND (project_pre_posting_)) OR
          ((project_code_part_ != 'F') AND (other_pre_posting_  ))) THEN
         codestring_rec_.code_f := pre_acc_rec_.codeno_f;
      END IF;
   END IF;

   IF (pre_acc_rec_.codeno_g IS NOT NULL) THEN
      IF (((project_code_part_  = 'G') AND (project_pre_posting_)) OR
          ((project_code_part_ != 'G') AND (other_pre_posting_  ))) THEN
          codestring_rec_.code_g := pre_acc_rec_.codeno_g;
      END IF;
   END IF;

   IF (pre_acc_rec_.codeno_h IS NOT NULL) THEN
      IF (((project_code_part_  = 'H') AND (project_pre_posting_)) OR
          ((project_code_part_ != 'H') AND (other_pre_posting_  ))) THEN
          codestring_rec_.code_h := pre_acc_rec_.codeno_h;
      END IF;
   END IF;

   IF (pre_acc_rec_.codeno_i IS NOT NULL) THEN
      IF (((project_code_part_  = 'I') AND (project_pre_posting_)) OR
          ((project_code_part_ != 'I') AND (other_pre_posting_  ))) THEN
          codestring_rec_.code_i := pre_acc_rec_.codeno_i;
      END IF;
   END IF;
   
   IF (pre_acc_rec_.codeno_j IS NOT NULL) THEN
      IF (((project_code_part_  = 'J') AND (project_pre_posting_)) OR
          ((project_code_part_ != 'J') AND (other_pre_posting_  ))) THEN
          codestring_rec_.code_j := pre_acc_rec_.codeno_j;
      END IF;
   END IF;
EXCEPTION
   WHEN all_is_ready_ THEN
      Trace_SYS.Message('TRACE Preacc=> No pre acc done');
      NULL;
END Do_Pre_Accounting;


FUNCTION Get_Pre_Accounting_Id (
   control_type_key_rec_   IN   Mpccom_Accounting_API.Control_Type_Key) RETURN NUMBER
IS
   pre_accounting_id_   NUMBER:=NULL;
   rma_no_              NUMBER;
   rma_line_no_         NUMBER;

BEGIN
   IF (control_type_key_rec_.pur_order_no_ is not null) THEN
--  Check that LU is installed before continuing with preaccounting
      $IF Component_Purch_SYS.INSTALLED $THEN
         pre_accounting_id_ := Purchase_Order_Line_API.Get_Pre_Accounting_Id(control_type_key_rec_.pur_order_no_,
                                                                             control_type_key_rec_.pur_line_no_,
                                                                             control_type_key_rec_.pur_release_no_);
      $ELSE
         Error_SYS.Record_General('PreAccounting','NOPO: Purchase Order is not installed. Pre_accounting_id not found.');
      $END
   ELSIF
      (control_type_key_rec_.oe_order_no_ IS NOT NULL) THEN

      --  Check that LU is installed before continuing with preaccounting
      $IF Component_Order_SYS.INSTALLED $THEN
         pre_accounting_id_ := Customer_Order_Line_API.Get_Pre_Accounting_Id( control_type_key_rec_.oe_order_no_,
                                                                              control_type_key_rec_.oe_line_no_,
                                                                              control_type_key_rec_.oe_rel_no_,
                                                                              control_type_key_rec_.oe_line_item_no_);         
      $ELSE
         Error_SYS.Record_General('PreAccounting','NOOE: Customer order is not installed. Pre_accounting_id not found.');
      $END
   ELSIF
      (control_type_key_rec_.so_order_no_ is not null) THEN
--  Check that LU is installed before continuing with preaccounting
      $IF Component_Shpord_SYS.INSTALLED $THEN
         pre_accounting_id_ := Shop_Ord_Util_API.Get_Pre_Accounting_Id( control_type_key_rec_.so_order_no_,
                                                                        control_type_key_rec_.so_release_no_,
                                                                        control_type_key_rec_.so_sequence_no_);
      $ELSE
         Error_SYS.Record_General('PreAccounting','NOSO: Shop order is not installed. Pre_accounting_id not found.');
      $END
   ELSIF
      (control_type_key_rec_.wo_task_seq_ is not null) THEN

      --  Check that LU is installed before continuing with preaccounting
      $IF Component_Wo_SYS.INSTALLED $THEN
         pre_accounting_id_ := Jt_Task_Accounting_Util_API.Get_Pre_Accounting_Id(source_ref1_ => control_type_key_rec_.wo_work_order_no_,
                                                                                 source_ref2_ => control_type_key_rec_.wo_task_seq_,
                                                                                 source_ref3_ => control_type_key_rec_.wo_mtrl_order_no_,
                                                                                 source_ref4_ => control_type_key_rec_.wo_line_item_no_);
      $ELSE
         Error_SYS.Record_General('PreAccounting','NOWO: Work order is not installed. Pre_accounting_id not found.');
      $END

   ELSIF
      (control_type_key_rec_.wt_task_seq_ IS NOT NULL) THEN
      $IF Component_Wo_SYS.INSTALLED $THEN
         pre_accounting_id_ := Jt_Task_Accounting_Util_API.Get_Pre_Accounting_Id(source_ref1_ => NULL,
                                                                                 source_ref2_ => control_type_key_rec_.wt_task_seq_,
                                                                                 source_ref3_ => control_type_key_rec_.wt_mtrl_order_no_,
                                                                                 source_ref4_ => control_type_key_rec_.wt_line_item_no_);
      $ELSE
         Error_SYS.Component_Not_Exist('WO');
      $END

   ELSIF
      (control_type_key_rec_.int_order_no_ is not null) THEN
      --  Check for correct module being installed before continuing with preaccounting
      $IF Component_Invent_SYS.INSTALLED $THEN
         pre_accounting_id_ := Material_Requis_Line_API.Get_Pre_Accounting_Id(control_type_key_rec_.int_order_no_,
                                                                              control_type_key_rec_.int_line_no_,
                                                                              control_type_key_rec_.int_release_no_);
      $ELSE
         Error_SYS.Record_General('PreAccounting','NOIO: Material requisition is not installed. Pre_accounting_id not found.');
      $END

   ELSIF (control_type_key_rec_.prj_project_id_ is not null) THEN
      $IF Component_Proj_SYS.INSTALLED $THEN
         pre_accounting_id_ := Activity_API.Get_Pre_Accounting_Id( control_type_key_rec_.prj_activity_seq_ );
      $ELSE
         Error_SYS.Record_General('PreAccounting','NORML: Logical Unit Return Material Line is not installed. Pre_accounting_id not found.');
      $END
   ELSIF (control_type_key_rec_.oe_rma_no_ IS NOT NULL) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         rma_no_      := control_type_key_rec_.oe_rma_no_;
         rma_line_no_ := control_type_key_rec_.oe_rma_line_no_;
         pre_accounting_id_ := Return_Material_Line_API.Get_Pre_Accounting_Id( rma_no_, rma_line_no_ );                   
      $ELSE
        Error_SYS.Record_General('PreAccounting','NORML: Logical Unit Return Material Line is not installed. Pre_accounting_id not found.');
      $END 
   ELSIF (control_type_key_rec_.fa_object_id_ is not null) THEN
      $IF Component_Fixass_SYS.INSTALLED $THEN
         IF (control_type_key_rec_.event_code_ = 'SCRAPPOOL') THEN
            pre_accounting_id_ := Rotable_Pool_Fa_Object_API.Get_Pre_Accounting_Id_Scrap(control_type_key_rec_.company_, 
                                                                                         control_type_key_rec_.fa_object_id_);
         ELSE
            pre_accounting_id_ := Rotable_Pool_Fa_Object_API.Get_Pre_Accounting_Id(control_type_key_rec_.company_, 
                                                                                   control_type_key_rec_.fa_object_id_);
         END IF;
      $ELSE
         Error_SYS.Record_General('PreAccounting','NORPFAO: Logical Unit Rotable Pool Fa Object is not installed. Pre_accounting_id not found.');
      $END
      
   ELSIF (control_type_key_rec_.pur_req_no_ IS NOT NULL) THEN
      $IF Component_Purch_SYS.INSTALLED $THEN
         pre_accounting_id_ := Purchase_Req_Line_API.Get_Pre_Accounting_Id(control_type_key_rec_.pur_req_no_,
                                                                           control_type_key_rec_.pur_req_line_no_,
                                                                           control_type_key_rec_.pur_req_rel_no_);
      $ELSE
         NULL;
      $END  
   ELSIF (control_type_key_rec_.cro_exchange_line_no_ IS NOT NULL) THEN
      $IF Component_Cromfg_SYS.INSTALLED $THEN
         pre_accounting_id_ := Cro_Exchange_Line_API.Get_Pre_Accounting_Id(control_type_key_rec_.cro_no_,
                                                                           control_type_key_rec_.cro_exchange_line_no_);
      $ELSE
         NULL;
      $END         
   ELSIF ( control_type_key_rec_.chg_pur_order_no_ IS NOT NULL ) THEN
      $IF Component_Purch_SYS.INSTALLED $THEN
         pre_accounting_id_ := Purch_Chg_Ord_Line_API.Get_Pre_Accounting_Id(control_type_key_rec_.chg_pur_order_no_,
                                                                            control_type_key_rec_.chg_order_no_,
                                                                            control_type_key_rec_.chg_line_no_,
                                                                            control_type_key_rec_.chg_release_no_);
      $ELSE
         Error_SYS.Record_General('PreAccounting','NOPO: Purchase Order is not installed. Pre_accounting_id not found.');
      $END
   ELSIF ( control_type_key_rec_.prjdel_item_no_ IS NOT NULL ) THEN
      $IF Component_Prjdel_SYS.INSTALLED $THEN
         pre_accounting_id_ := Planning_Shipment_API.Get_Pre_Accounting_Id(control_type_key_rec_.prjdel_item_no_,
                                                                           control_type_key_rec_.prjdel_Item_revision_,
                                                                           control_type_key_rec_.prjdel_planning_no_);
      $ELSE
         Error_SYS.Component_Not_Exist('PRJDEL');
      $END 
   END IF;

   RETURN pre_accounting_id_;
END Get_Pre_Accounting_Id;


-- Remove_Accounting_Id
--   Remove pre accounting.
PROCEDURE Remove_Accounting_Id (
   pre_accounting_id_ IN NUMBER )
IS
   info_       VARCHAR2(2000);
   CURSOR get_accounting IS
      SELECT objid, objversion
      FROM PRE_ACCOUNTING
      WHERE pre_accounting_id = pre_accounting_id_;
BEGIN
   FOR accounting_rec_ IN get_accounting LOOP
       Remove__(info_, accounting_rec_.objid, accounting_rec_.objversion, 'DO');
   END LOOP;
END Remove_Accounting_Id;


@UncheckedAccess
FUNCTION Get_Next_Pre_Accounting_Id RETURN NUMBER
IS
   CURSOR next_id_ IS
      SELECT mpc_pre_accounting_id.nextval
      FROM DUAL;
   pre_accounting_id_ PRE_ACCOUNTING.pre_accounting_id%TYPE;
BEGIN
   OPEN next_id_;
   FETCH next_id_ INTO pre_accounting_id_;
   CLOSE next_id_;
   RETURN pre_accounting_id_;
END Get_Next_Pre_Accounting_Id;


-- Execute_Accounting
--   This method is obsolete and will be removed. --
--   Use Get_Allowed_Codeparts instead.           --
PROCEDURE Execute_Accounting (
   code_a_       IN OUT NUMBER,
   code_b_       IN OUT NUMBER,
   code_c_       IN OUT NUMBER,
   code_d_       IN OUT NUMBER,
   code_e_       IN OUT NUMBER,
   code_f_       IN OUT NUMBER,
   code_g_       IN OUT NUMBER,
   code_h_       IN OUT NUMBER,
   code_i_       IN OUT NUMBER,
   code_j_       IN OUT NUMBER,
   str_code_     IN VARCHAR2,
   control_type_ IN VARCHAR2,
   company_      IN VARCHAR2 )
IS
BEGIN
   Get_Allowed_Codeparts(code_a_,
                         code_b_,
                         code_c_,
                         code_d_,
                         code_e_,
                         code_f_,
                         code_g_,
                         code_h_,
                         code_i_,
                         code_j_,
                         str_code_,
                         control_type_,
                         company_);
END Execute_Accounting;


-- Get_Allowed_Codeparts
--   Returns the allowed code parts regarding the settings in posting control.
--   1 -> Codepart is allowed, 0 -> Code part is not allowed.
PROCEDURE Get_Allowed_Codeparts (
   code_a_       IN OUT NUMBER,
   code_b_       IN OUT NUMBER,
   code_c_       IN OUT NUMBER,
   code_d_       IN OUT NUMBER,
   code_e_       IN OUT NUMBER,
   code_f_       IN OUT NUMBER,
   code_g_       IN OUT NUMBER,
   code_h_       IN OUT NUMBER,
   code_i_       IN OUT NUMBER,
   code_j_       IN OUT NUMBER,
   str_code_     IN VARCHAR2,
   control_type_ IN VARCHAR2,
   company_      IN VARCHAR2 )
IS
BEGIN
   Accounting_Codestr_API.Execute_Accounting (
      code_a_,
      code_b_,
      code_c_,
      code_d_,
      code_e_,
      code_f_,
      code_g_,
      code_h_,
      code_i_,
      code_j_,
      'MPC4',
      company_,
      str_code_,
      control_type_);
END Get_Allowed_Codeparts;


-- Validate_Codepart
--   Validates code part.
PROCEDURE Validate_Codepart (
   codevalue_    IN VARCHAR2,
   code_part_    IN VARCHAR2,
   voucher_date_ IN DATE,
   company_      IN VARCHAR2 )
IS
BEGIN
   Accounting_Code_Parts_API.Validate_CodePart (
      company_,
      codevalue_,
      code_part_,
      voucher_date_ );
END Validate_Codepart;


-- Pre_Accounting_Exist
--   Check if pre accounting exists and at least one code part is not NULL.
@UncheckedAccess
FUNCTION Pre_Accounting_Exist (
  pre_accounting_id_ IN NUMBER ) RETURN NUMBER
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   PRE_ACCOUNTING_TAB
      WHERE pre_accounting_id = pre_accounting_id_
      AND   (account_no   IS NOT NULL OR
             codeno_b     IS NOT NULL OR
             codeno_c     IS NOT NULL OR
             codeno_d     IS NOT NULL OR
             codeno_e     IS NOT NULL OR
             codeno_f     IS NOT NULL OR
             codeno_g     IS NOT NULL OR
             codeno_h     IS NOT NULL OR
             codeno_i     IS NOT NULL OR
             codeno_j     IS NOT NULL OR             
             activity_seq IS NOT NULL);
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN(1);
   END IF;
   CLOSE exist_control;
   RETURN(Distribution_Exist(pre_accounting_id_));
END Pre_Accounting_Exist;


-- Mandatory_Pre_Posting_Complete
--   Checks if all the mandatory preposting code parts have been entered.
--   When a value is missing for any of the mandatory code parts, this will
--   return FALSE otherwise this will return TRUE.
FUNCTION Mandatory_Pre_Posting_Complete (
  pre_accounting_id_ IN NUMBER,
  posting_type_      IN VARCHAR2,
  company_           IN VARCHAR2 ) RETURN BOOLEAN
IS 
  mandatory_preposting_complete_ BOOLEAN := TRUE;
BEGIN

  BEGIN
     Check_Mandatory_Code_Parts(pre_accounting_id_,
                                posting_type_,
                                company_,
                                NULL);
  EXCEPTION
     WHEN OTHERS THEN
        mandatory_preposting_complete_ := FALSE;
  END;

  RETURN (mandatory_preposting_complete_);
END Mandatory_Pre_Posting_Complete;


-- Distribution_Exist
--   Check if a pre accounting distribution exists and
--   at least one of its code part is not NULL.
@UncheckedAccess
FUNCTION Distribution_Exist (
  pre_accounting_id_ IN NUMBER,
  code_part_         IN VARCHAR2 DEFAULT NULL) RETURN NUMBER
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   PRE_ACCOUNTING_TAB
      WHERE parent_pre_accounting_id = pre_accounting_id_
      AND   amount_distribution IS NOT NULL
      AND  ((NVL(code_part_, 'A') = 'A' AND account_no   IS NOT NULL) OR
            (NVL(code_part_, 'B') = 'B' AND codeno_b     IS NOT NULL) OR
            (NVL(code_part_, 'C') = 'C' AND codeno_c     IS NOT NULL) OR
            (NVL(code_part_, 'D') = 'D' AND codeno_d     IS NOT NULL) OR
            (NVL(code_part_, 'E') = 'E' AND codeno_e     IS NOT NULL) OR
            (NVL(code_part_, 'F') = 'F' AND codeno_f     IS NOT NULL) OR
            (NVL(code_part_, 'G') = 'G' AND codeno_g     IS NOT NULL) OR
            (NVL(code_part_, 'H') = 'H' AND codeno_h     IS NOT NULL) OR
            (NVL(code_part_, 'I') = 'I' AND codeno_i     IS NOT NULL) OR
            (NVL(code_part_, 'J') = 'J' AND codeno_j     IS NOT NULL) OR 
            activity_seq IS NOT NULL);
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN(1);
   END IF;
   CLOSE exist_control;
   RETURN(0);
END Distribution_Exist;


-- Is_Preacc_Similar
--   To check if the pre accounting of two orders are identical or not.
@UncheckedAccess
FUNCTION Is_Preacc_Similar (
   pre_accounting_id_ IN NUMBER,
   pre_acc_temp_      IN NUMBER ) RETURN VARCHAR2
IS
   value_      VARCHAR2(5);
   dummy_      BOOLEAN;
   dummy2_     BOOLEAN;

   CURSOR get_pre_accounting IS
   SELECT account_no, codeno_b, codeno_c, codeno_d, codeno_e, codeno_f,
          codeno_g, codeno_h, codeno_i, codeno_j
   FROM  PRE_ACCOUNTING
   WHERE pre_accounting_id = pre_accounting_id_;

   nr1_   get_pre_accounting%ROWTYPE;

   CURSOR check_cursor IS
   SELECT account_no, codeno_b, codeno_c, codeno_d, codeno_e, codeno_f,
          codeno_g, codeno_h, codeno_i, codeno_j
   FROM  PRE_ACCOUNTING
   WHERE pre_accounting_id = pre_acc_temp_
   AND   nvl(account_no, 'X')   = nvl(nr1_.account_no, 'X')
   AND   nvl(codeno_b, 'X')     = nvl(nr1_.codeno_b, 'X')
   AND   nvl(codeno_c, 'X')     = nvl(nr1_.codeno_c, 'X')
   AND   nvl(codeno_d, 'X')     = nvl(nr1_.codeno_d, 'X')
   AND   nvl(codeno_e, 'X')     = nvl(nr1_.codeno_e, 'X')
   AND   nvl(codeno_f, 'X')     = nvl(nr1_.codeno_f, 'X')
   AND   nvl(codeno_g, 'X')     = nvl(nr1_.codeno_g, 'X')
   AND   nvl(codeno_h, 'X')     = nvl(nr1_.codeno_h, 'X')
   AND   nvl(codeno_i, 'X')     = nvl(nr1_.codeno_i, 'X')
   AND   nvl(codeno_j, 'X')     = nvl(nr1_.codeno_j, 'X');

   nr2_   check_cursor%ROWTYPE;

BEGIN
   value_  := 'TRUE';
   dummy_  := Check_Exist___(pre_accounting_id_);
   dummy2_ := Check_Exist___(pre_acc_temp_);
   IF (dummy_ = dummy2_) AND (dummy_ = FALSE) THEN
      value_  := 'TRUE';
   ELSE
      OPEN  get_pre_accounting;
      FETCH get_pre_accounting INTO nr1_;
      CLOSE get_pre_accounting;
      OPEN  check_cursor;
      FETCH check_cursor INTO nr2_;
      IF check_cursor%FOUND THEN
        value_ := 'TRUE';
      ELSE
        value_ := 'FALSE';
      END IF;
      CLOSE check_cursor;
   END IF;
   RETURN value_;
END Is_Preacc_Similar;


-- Check_Mandatory_Code_Parts
--   Method is used to verify that all code parts that are enabled
--   for mandatory pre accounting have been assigned values.
--   If there is a NULL value in a mandatory code part
--   the method will display an error message.
PROCEDURE Check_Mandatory_Code_Parts (
   pre_accounting_id_            IN NUMBER,
   posting_type_                 IN VARCHAR2,
   company_                      IN VARCHAR2,
   source_identifier_            IN VARCHAR2,
   check_only_project_code_part_ IN BOOLEAN DEFAULT FALSE )
IS
   code_a_flag_       NUMBER;  -- for account_no
   code_b_flag_       NUMBER;  -- for codeno_b
   code_c_flag_       NUMBER;  -- for codeno_c
   code_d_flag_       NUMBER;  -- for codeno_d
   code_e_flag_       NUMBER;  -- for codeno_e
   code_f_flag_       NUMBER;  -- for codeno_f
   code_g_flag_       NUMBER;  -- for codeno_g
   code_h_flag_       NUMBER;  -- for codeno_h
   code_i_flag_       NUMBER;  -- for codeno_i
   code_j_flag_       NUMBER;  -- for codeno_j
   error_code_part_   VARCHAR2(1);
   code_part_missing  EXCEPTION;
   code_part_name_    VARCHAR2(20);
   main_rec_          PRE_ACCOUNTING_TAB%ROWTYPE;
   current_rec_       PRE_ACCOUNTING_TAB%ROWTYPE;
   dummy_rec_         PRE_ACCOUNTING_TAB%ROWTYPE;
   children_          BOOLEAN;
   testrec_           PRE_ACCOUNTING_TAB%ROWTYPE;
   project_code_part_ VARCHAR2(10);

   CURSOR get_children(parent_pre_accounting_id_ IN NUMBER) IS
   SELECT *
   FROM PRE_ACCOUNTING_TAB
   WHERE parent_pre_accounting_id = parent_pre_accounting_id_;
BEGIN

   -- Find the mandatory code parts.
   Get_Allowed_Codeparts(code_a_flag_,
                         code_b_flag_,
                         code_c_flag_,
                         code_d_flag_,
                         code_e_flag_,
                         code_f_flag_,
                         code_g_flag_,
                         code_h_flag_,
                         code_i_flag_,
                         code_j_flag_,
                         posting_type_,
                         'C58',
                         company_);

   IF (check_only_project_code_part_) THEN
      testrec_.account_no  := 'A';
      testrec_.codeno_b    := 'B';
      testrec_.codeno_c    := 'C';
      testrec_.codeno_d    := 'D';
      testrec_.codeno_e    := 'E';
      testrec_.codeno_f    := 'F';
      testrec_.codeno_g    := 'G';
      testrec_.codeno_h    := 'H';
      testrec_.codeno_i    := 'I';
      testrec_.codeno_j    := 'J';

      project_code_part_   := Get_Project_Code_Value___(company_, testrec_);

      IF (project_code_part_ != 'A') THEN
         code_a_flag_ := 0;
      END IF;
      IF (project_code_part_ != 'B') THEN
         code_b_flag_ := 0;
      END IF;
      IF (project_code_part_ != 'C') THEN
         code_c_flag_ := 0;
      END IF;
      IF (project_code_part_ != 'D') THEN
         code_d_flag_ := 0;
      END IF;
      IF (project_code_part_ != 'E') THEN
         code_e_flag_ := 0;
      END IF;
      IF (project_code_part_ != 'F') THEN
         code_f_flag_ := 0;
      END IF;
      IF (project_code_part_ != 'G') THEN
         code_g_flag_ := 0;
      END IF;
      IF (project_code_part_ != 'H') THEN
         code_h_flag_ := 0;
      END IF;
      IF (project_code_part_ != 'I') THEN
         code_i_flag_ := 0;
      END IF;
      IF (project_code_part_ != 'J') THEN
         code_j_flag_ := 0;
      END IF;
   END IF;
   -- Fetch the main pre accounting.
   main_rec_ := Get_Object_By_Keys___(pre_accounting_id_);

   -- Check if split rows (children) exist.
   OPEN get_children(pre_accounting_id_);
   FETCH get_children INTO dummy_rec_;
   IF get_children%FOUND THEN
      children_ := TRUE;
   ELSE
      children_ := FALSE;
   END IF;
   CLOSE get_children;

   IF NOT children_ THEN
      -- Check the main pre accounting.
      IF ((code_a_flag_ = 1) AND (main_rec_.account_no IS NULL)) THEN
         error_code_part_ := 'A';
         RAISE code_part_missing;
      END IF;
      IF ((code_b_flag_ = 1) AND (main_rec_.codeno_b IS NULL)) THEN
         error_code_part_ := 'B';
         RAISE code_part_missing;
      END IF;
      IF ((code_c_flag_ = 1) AND (main_rec_.codeno_c IS NULL)) THEN
         error_code_part_ := 'C';
         RAISE code_part_missing;
      END IF;
      IF ((code_d_flag_ = 1) AND (main_rec_.codeno_d IS NULL)) THEN
         error_code_part_ := 'D';
         RAISE code_part_missing;
      END IF;
      IF ((code_e_flag_ = 1) AND (main_rec_.codeno_e IS NULL)) THEN
         error_code_part_ := 'E';
         RAISE code_part_missing;
      END IF;
      IF ((code_f_flag_ = 1) AND (main_rec_.codeno_f IS NULL)) THEN
         error_code_part_ := 'F';
         RAISE code_part_missing;
      END IF;
      IF ((code_g_flag_ = 1) AND (main_rec_.codeno_g IS NULL)) THEN
         error_code_part_ := 'G';
         RAISE code_part_missing;
      END IF;
      IF ((code_h_flag_ = 1) AND (main_rec_.codeno_h IS NULL)) THEN
         error_code_part_ := 'H';
         RAISE code_part_missing;
      END IF;
      IF ((code_i_flag_ = 1) AND (main_rec_.codeno_i IS NULL)) THEN
         error_code_part_ := 'I';
         RAISE code_part_missing;
      END IF;
      IF ((code_j_flag_ = 1) AND (main_rec_.codeno_j IS NULL)) THEN
         error_code_part_ := 'J';
         RAISE code_part_missing;
      END IF;
   ELSE
      -- Fetch the children, create a code string and check it for every child.
      FOR child IN get_children(pre_accounting_id_) LOOP

         current_rec_ := main_rec_;

         -- Paste with the contents of the child pre accounting
         IF child.account_no IS NOT NULL THEN
            current_rec_.account_no   := child.account_no;
         END IF;
         IF child.codeno_b IS NOT NULL THEN
            current_rec_.codeno_b     := child.codeno_b;
         END IF;
         IF child.codeno_c IS NOT NULL THEN
            current_rec_.codeno_c     := child.codeno_c;
         END IF;
         IF child.codeno_d IS NOT NULL THEN
            current_rec_.codeno_d     := child.codeno_d;
         END IF;
         IF child.codeno_e IS NOT NULL THEN
            current_rec_.codeno_e    := child.codeno_e;
         END IF;
         IF child.codeno_f IS NOT NULL THEN
            current_rec_.codeno_f   := child.codeno_f;
         END IF;
         IF child.codeno_g IS NOT NULL THEN
            current_rec_.codeno_g     := child.codeno_g;
         END IF;
         IF child.codeno_h IS NOT NULL THEN
            current_rec_.codeno_h     := child.codeno_h;
         END IF;
         IF child.codeno_i IS NOT NULL THEN
            current_rec_.codeno_i     := child.codeno_i;
         END IF;
         IF child.codeno_j IS NOT NULL THEN
            current_rec_.codeno_j     := child.codeno_j;
         END IF;         

         -- Check the compiled row.
         IF ((code_a_flag_ = 1) AND (current_rec_.account_no IS NULL)) THEN
            error_code_part_ := 'A';
            RAISE code_part_missing;
         END IF;
         IF ((code_b_flag_ = 1) AND (current_rec_.codeno_b IS NULL)) THEN
            error_code_part_ := 'B';
            RAISE code_part_missing;
         END IF;
         IF ((code_c_flag_ = 1) AND (current_rec_.codeno_c IS NULL)) THEN
            error_code_part_ := 'C';
            RAISE code_part_missing;
         END IF;
         IF ((code_d_flag_ = 1) AND (current_rec_.codeno_d IS NULL)) THEN
            error_code_part_ := 'D';
            RAISE code_part_missing;
         END IF;
         IF ((code_e_flag_ = 1) AND (current_rec_.codeno_e IS NULL)) THEN
            error_code_part_ := 'E';
            RAISE code_part_missing;
         END IF;
         IF ((code_f_flag_ = 1) AND (current_rec_.codeno_f IS NULL)) THEN
            error_code_part_ := 'F';
            RAISE code_part_missing;
         END IF;
         IF ((code_g_flag_ = 1) AND (current_rec_.codeno_g IS NULL)) THEN
            error_code_part_ := 'G';
            RAISE code_part_missing;
         END IF;
         IF ((code_h_flag_ = 1) AND (current_rec_.codeno_h IS NULL)) THEN
            error_code_part_ := 'H';
            RAISE code_part_missing;
         END IF;
         IF ((code_i_flag_ = 1) AND (current_rec_.codeno_i IS NULL)) THEN
            error_code_part_ := 'I';
            RAISE code_part_missing;
         END IF;
         IF ((code_j_flag_ = 1) AND (current_rec_.codeno_j IS NULL)) THEN
            error_code_part_ := 'J';
            RAISE code_part_missing;
         END IF;
      END LOOP;
   END IF;
EXCEPTION
   WHEN code_part_missing THEN
      code_part_name_ := Accounting_Code_Parts_API.Get_Name(company_, error_code_part_);
      Error_Sys.Record_General(lu_name_, 'CODEPARTMANDATORY: Code part :P1 must have a value for :P2', code_part_name_, source_identifier_);
   WHEN OTHERS THEN
      RAISE;
END Check_Mandatory_Code_Parts;


-- Check_Exist
--   Check if pre accounting exits.
@UncheckedAccess
FUNCTION Check_Exist (
  pre_accounting_id_ IN     NUMBER ) RETURN NUMBER
IS
BEGIN
   IF (Check_Exist___(pre_accounting_id_)) THEN
      RETURN 1;
   ELSE
      RETURN 0;
   END IF;
END Check_Exist;

-- Compile_Codestrings
--   Given a pre accounting id this method compiles the code strings using
--   the information about the posting control, the original pre accounting
--   and the underlaying distribution.
--   The result is delivered in an array, codestring_tab_
PROCEDURE Compile_Codestrings (
   codestring_tab_             IN OUT Codestring_Table_Type,
   codestring_rec_             IN OUT Accounting_Codestr_API.CodestrRec,
   control_type_key_rec_       IN     Mpccom_Accounting_API.Control_Type_Key,
   pre_accounting_id_          IN     NUMBER,
   pre_accounting_flag_db_     IN     VARCHAR2,
   project_accounting_flag_db_ IN     VARCHAR2)
IS
   parent_rec_ PRE_ACCOUNTING_TAB%ROWTYPE;
   counter_    NUMBER := 0;
   --
   company_                 VARCHAR2(20);
   project_code_part_       VARCHAR2(1):= NULL;

   project_pre_posting_     BOOLEAN :=FALSE;
   other_pre_posting_       BOOLEAN:=FALSE;
   include_activity_seq_    BOOLEAN := FALSE;
   all_is_ready_            EXCEPTION;
   --
   CURSOR get_children(parent_pre_accounting_id_ IN NUMBER) IS
   SELECT *
   FROM PRE_ACCOUNTING_TAB
   WHERE parent_pre_accounting_id = parent_pre_accounting_id_;
BEGIN

   IF ((pre_accounting_flag_db_ IS NULL) OR (pre_accounting_flag_db_ NOT IN ('Y','N'))) THEN
      Error_SYS.Record_General(lu_name_,'NOVALIDPREACC: The posting event has an invalid preaccounting flag. Contact your system administrator.');
   END IF;

   -- Fetch the main pre accounting.
   parent_rec_ := Get_Object_By_Keys___(pre_accounting_id_);

   IF parent_rec_.pre_accounting_id IS NULL THEN
      --Cannot find a preaccounting record, exit!
      RAISE all_is_ready_;
   END IF;

   IF ((pre_accounting_flag_db_ ='N') AND
      (project_accounting_flag_db_ = 'EXCLUDE PROJECT PRE POSTING') AND
       parent_rec_.activity_seq IS NULL) THEN
      --no preaccounting required, exit!
      RAISE all_is_ready_;
   END IF;

   IF pre_accounting_flag_db_ ='Y' THEN
      other_pre_posting_ := TRUE;
   END IF;

   IF (parent_rec_.activity_seq IS NULL) THEN
      --Not an external project
   project_pre_posting_ := FALSE;
   ELSE      
      --External project, check if project requires preaccounting
      company_ := Site_API.Get_Company(control_type_key_rec_.contract_);      
      Prj_Pre_Posting_Required___(project_pre_posting_,
                                  include_activity_seq_,
                                  control_type_key_rec_,
                                  project_accounting_flag_db_,
                                  company_,
                                  codestring_rec_);
   END IF;

   IF ((NOT project_pre_posting_) AND (NOT other_pre_posting_)) THEN
      --no preaccounting required, exit!
      RAISE all_is_ready_;
   END IF;


   IF (((project_pre_posting_) AND (NOT other_pre_posting_)) OR
       ((other_pre_posting_)   AND (NOT project_pre_posting_))) THEN
      IF (parent_rec_.activity_seq IS NULL) THEN
         --Internal project
         project_code_part_ := NULL;
      ELSE
         IF (company_ IS NULL) THEN            
            company_ := Site_API.Get_Company(control_type_key_rec_.contract_);
         END IF;
         --Get the project code part
         project_code_part_ := Get_Project_Code_Part___(company_);
      END IF;
   END IF;

   IF (project_code_part_ IS NULL) THEN
      -- Possible values for code parts are from A...J
      project_code_part_ := 'X';
   END IF;

   -- Fetch the children and create a new row in the codestring_tab for every child.
   FOR child IN get_children(pre_accounting_id_) LOOP

      codestring_tab_(counter_).account_no   := codestring_rec_.code_a;
      codestring_tab_(counter_).codeno_b     := codestring_rec_.code_b;
      codestring_tab_(counter_).codeno_c     := codestring_rec_.code_c;
      codestring_tab_(counter_).codeno_d     := codestring_rec_.code_d;
      codestring_tab_(counter_).codeno_e     := codestring_rec_.code_e;
      codestring_tab_(counter_).codeno_f     := codestring_rec_.code_f;
      codestring_tab_(counter_).codeno_g     := codestring_rec_.code_g;
      codestring_tab_(counter_).codeno_h     := codestring_rec_.code_h;
      codestring_tab_(counter_).codeno_i     := codestring_rec_.code_i;
      codestring_tab_(counter_).codeno_j     := codestring_rec_.code_j;      
      -- activity_seq is not present in the posting control

      -- Paste with the contents of the main pre accounting
      IF (parent_rec_.account_no IS NOT NULL) THEN
         IF (((project_code_part_  = 'A') AND (project_pre_posting_)) OR
             ((project_code_part_ != 'A') AND (other_pre_posting_  ))) THEN
             codestring_tab_(counter_).account_no   := parent_rec_.account_no;
         END IF;
      END IF;

      IF (parent_rec_.codeno_b IS NOT NULL) THEN
         IF (((project_code_part_  = 'B') AND (project_pre_posting_)) OR
             ((project_code_part_ != 'B') AND (other_pre_posting_  ))) THEN
            codestring_tab_(counter_).codeno_b     := parent_rec_.codeno_b;
         END IF;
      END IF;

      IF (parent_rec_.codeno_c IS NOT NULL) THEN
         IF (((project_code_part_  = 'C') AND (project_pre_posting_)) OR
             ((project_code_part_ != 'C') AND (other_pre_posting_  ))) THEN
            codestring_tab_(counter_).codeno_c     := parent_rec_.codeno_c;
         END IF;
      END IF;

      IF (parent_rec_.codeno_d IS NOT NULL) THEN
         IF (((project_code_part_  = 'D') AND (project_pre_posting_)) OR
             ((project_code_part_ != 'D') AND (other_pre_posting_  ))) THEN
            codestring_tab_(counter_).codeno_d     := parent_rec_.codeno_d;
         END IF;
      END IF;

      IF (parent_rec_.codeno_e IS NOT NULL) THEN
         IF (((project_code_part_  = 'E') AND (project_pre_posting_)) OR
             ((project_code_part_ != 'E') AND (other_pre_posting_  ))) THEN
            codestring_tab_(counter_).codeno_e     := parent_rec_.codeno_e;
         END IF;
      END IF;

      IF (parent_rec_.codeno_f IS NOT NULL) THEN
         IF (((project_code_part_  = 'F') AND (project_pre_posting_)) OR
             ((project_code_part_ != 'F') AND (other_pre_posting_  ))) THEN
            codestring_tab_(counter_).codeno_f     := parent_rec_.codeno_f;
         END IF;
      END IF;

      IF (parent_rec_.codeno_g IS NOT NULL) THEN
         IF (((project_code_part_  = 'G') AND (project_pre_posting_)) OR
             ((project_code_part_ != 'G') AND (other_pre_posting_  ))) THEN
            codestring_tab_(counter_).codeno_g     := parent_rec_.codeno_g;
         END IF;
      END IF;

      IF (parent_rec_.codeno_h IS NOT NULL) THEN
         IF (((project_code_part_  = 'H') AND (project_pre_posting_)) OR
             ((project_code_part_ != 'H') AND (other_pre_posting_  ))) THEN
            codestring_tab_(counter_).codeno_h     := parent_rec_.codeno_h;
         END IF;
      END IF;

      IF (parent_rec_.codeno_i IS NOT NULL) THEN
         IF (((project_code_part_  = 'I') AND (project_pre_posting_)) OR
             ((project_code_part_ != 'I') AND (other_pre_posting_  ))) THEN
            codestring_tab_(counter_).codeno_i     := parent_rec_.codeno_i;
         END IF;
      END IF;

      IF (parent_rec_.codeno_j IS NOT NULL) THEN
         IF (((project_code_part_  = 'J') AND (project_pre_posting_)) OR
             ((project_code_part_ != 'J') AND (other_pre_posting_  ))) THEN
            codestring_tab_(counter_).codeno_j     := parent_rec_.codeno_j;
         END IF;
      END IF;

      IF ((parent_rec_.activity_seq IS NOT NULL) AND (include_activity_seq_)) THEN
         codestring_tab_(counter_).activity_seq := parent_rec_.activity_seq;
      END IF;

      -- Finally paste with the contents of the child pre accounting
      IF child.account_no IS NOT NULL THEN
         IF (((project_code_part_  = 'A') AND (project_pre_posting_)) OR
             ((project_code_part_ != 'A') AND (other_pre_posting_  ))) THEN
            codestring_tab_(counter_).account_no   := child.account_no;
         END IF;
      END IF;

      IF child.codeno_b IS NOT NULL THEN
         IF (((project_code_part_  = 'B') AND (project_pre_posting_)) OR
             ((project_code_part_ != 'B') AND (other_pre_posting_  ))) THEN
            codestring_tab_(counter_).codeno_b  := child.codeno_b;
         END IF;
      END IF;

      IF child.codeno_c IS NOT NULL THEN
         IF (((project_code_part_  = 'C') AND (project_pre_posting_)) OR
             ((project_code_part_ != 'C') AND (other_pre_posting_  ))) THEN
            codestring_tab_(counter_).codeno_c     := child.codeno_c;
         END IF;
      END IF;

      IF child.codeno_d IS NOT NULL THEN
         IF (((project_code_part_  = 'D') AND (project_pre_posting_)) OR
             ((project_code_part_ != 'D') AND (other_pre_posting_  ))) THEN
            codestring_tab_(counter_).codeno_d     := child.codeno_d;
         END IF;
      END IF;

      IF child.codeno_e IS NOT NULL THEN
         IF (((project_code_part_  = 'E') AND (project_pre_posting_)) OR
             ((project_code_part_ != 'E') AND (other_pre_posting_  ))) THEN
            codestring_tab_(counter_).codeno_e    := child.codeno_e;
         END IF;
      END IF;

      IF child.codeno_f IS NOT NULL THEN
         IF (((project_code_part_  = 'F') AND (project_pre_posting_)) OR
             ((project_code_part_ != 'F') AND (other_pre_posting_  ))) THEN
            codestring_tab_(counter_).codeno_f   := child.codeno_f;
         END IF;
      END IF;

      IF child.codeno_g IS NOT NULL THEN
         IF (((project_code_part_  = 'G') AND (project_pre_posting_)) OR
             ((project_code_part_ != 'G') AND (other_pre_posting_  ))) THEN
            codestring_tab_(counter_).codeno_g     := child.codeno_g;
         END IF;
      END IF;

      IF child.codeno_h IS NOT NULL THEN
         IF (((project_code_part_  = 'H') AND (project_pre_posting_)) OR
             ((project_code_part_ != 'H') AND (other_pre_posting_  ))) THEN
            codestring_tab_(counter_).codeno_h     := child.codeno_h;
         END IF;
      END IF;

      IF child.codeno_i IS NOT NULL THEN
         IF (((project_code_part_  = 'I') AND (project_pre_posting_)) OR
             ((project_code_part_ != 'I') AND (other_pre_posting_  ))) THEN
            codestring_tab_(counter_).codeno_i     := child.codeno_i;
         END IF;
      END IF;

      IF child.codeno_j IS NOT NULL THEN
         IF (((project_code_part_  = 'J') AND (project_pre_posting_)) OR
             ((project_code_part_ != 'J') AND (other_pre_posting_  ))) THEN
            codestring_tab_(counter_).codeno_j     := child.codeno_j;
         END IF;
      END IF;

      IF ((child.activity_seq IS NOT NULL) AND (include_activity_seq_)) THEN
         codestring_tab_(counter_).activity_seq := child.activity_seq;
      END IF;

      -- Add the amount distribution to the resulting code string.
      codestring_tab_(counter_).amount_distribution := child.amount_distribution;

      counter_ := counter_ + 1;
   END LOOP;
EXCEPTION
   WHEN all_is_ready_ THEN
      -- Assign code parts from posting control
      codestring_tab_(counter_).account_no   := codestring_rec_.code_a;
      codestring_tab_(counter_).codeno_b     := codestring_rec_.code_b;
      codestring_tab_(counter_).codeno_c     := codestring_rec_.code_c;
      codestring_tab_(counter_).codeno_d     := codestring_rec_.code_d;
      codestring_tab_(counter_).codeno_e     := codestring_rec_.code_e;
      codestring_tab_(counter_).codeno_f     := codestring_rec_.code_f;
      codestring_tab_(counter_).codeno_g     := codestring_rec_.code_g;
      codestring_tab_(counter_).codeno_h     := codestring_rec_.code_h;
      codestring_tab_(counter_).codeno_i     := codestring_rec_.code_i;
      codestring_tab_(counter_).codeno_j     := codestring_rec_.code_j;      
      codestring_tab_(counter_).activity_seq := NULL;
END Compile_Codestrings;


-- Set_Project_Code_Part
--   Public method to use when you want to set or change the value of
--   the project code part for a given pre accounting id.
--   If the code part value refers to an externally created project
--   you also need to set the corresponding activity sec.
--   For internally defined projects the value of activity sec must be null.
PROCEDURE Set_Project_Code_Part (
   pre_accounting_id_         IN NUMBER,
   company_                   IN VARCHAR2,
   contract_                  IN VARCHAR2,
   posting_type_              IN VARCHAR2,
   project_no_                IN VARCHAR2,
   activity_seq_              IN NUMBER,
   skip_posting_type_check_   IN BOOLEAN DEFAULT FALSE,
   pre_posting_source_        IN VARCHAR2 DEFAULT NULL  )
IS
   a_is_allowed_         NUMBER;
   b_is_allowed_         NUMBER;
   c_is_allowed_         NUMBER;
   d_is_allowed_         NUMBER;
   e_is_allowed_         NUMBER;
   f_is_allowed_         NUMBER;
   g_is_allowed_         NUMBER;
   h_is_allowed_         NUMBER;
   i_is_allowed_         NUMBER;
   j_is_allowed_         NUMBER;

   project_code_part_    VARCHAR2(10);
   oldrec_               PRE_ACCOUNTING_TAB%ROWTYPE;
   newrec_               PRE_ACCOUNTING_TAB%ROWTYPE;
   attr_                 VARCHAR2(2000);
   objid_                PRE_ACCOUNTING.objid%TYPE;
   objversion_           PRE_ACCOUNTING.objversion%TYPE;
   code_part_not_allowed EXCEPTION;
   code_part_name_       VARCHAR2(10);
   false_                NUMBER := 0;
   indrec_               Indicator_Rec;
BEGIN

   project_code_part_ := Get_Project_Code_Part___(company_);

   IF (project_no_ IS NOT NULL AND NOT skip_posting_type_check_) THEN
      Validate_Codepart(project_no_,
                        project_code_part_,
                        Site_API.Get_Site_Date(contract_),
                        company_);

      Get_Allowed_Codeparts(a_is_allowed_,
                            b_is_allowed_,
                            c_is_allowed_,
                            d_is_allowed_,
                            e_is_allowed_,
                            f_is_allowed_,
                            g_is_allowed_,
                            h_is_allowed_,
                            i_is_allowed_,
                            j_is_allowed_,
                            posting_type_,
                            NULL,
                            company_);

      IF (((project_code_part_ = 'A') AND (a_is_allowed_ = false_)) OR
          ((project_code_part_ = 'B') AND (b_is_allowed_ = false_)) OR
          ((project_code_part_ = 'C') AND (c_is_allowed_ = false_)) OR
          ((project_code_part_ = 'D') AND (d_is_allowed_ = false_)) OR
          ((project_code_part_ = 'E') AND (e_is_allowed_ = false_)) OR
          ((project_code_part_ = 'F') AND (f_is_allowed_ = false_)) OR
          ((project_code_part_ = 'G') AND (g_is_allowed_ = false_)) OR
          ((project_code_part_ = 'H') AND (h_is_allowed_ = false_)) OR
          ((project_code_part_ = 'I') AND (i_is_allowed_ = false_)) OR
          ((project_code_part_ = 'J') AND (j_is_allowed_ = false_))) THEN
         -- Attempt to insert a value into a code part not open for pre posting.
         RAISE code_part_not_allowed;
      END IF;
   END IF;

   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr( 'COMPANY',      company_,      attr_ );
   Client_SYS.Add_To_Attr( 'CONTRACT',     contract_,     attr_ );
   Client_SYS.Add_To_Attr( 'ACTIVITY_SEQ', activity_seq_, attr_ );
   IF (pre_posting_source_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr( 'PRE_POSTING_SOURCE', pre_posting_source_, attr_ );
   END IF;
   IF    project_code_part_ = 'A' THEN
      Client_SYS.Add_To_Attr( 'ACCOUNT_NO',  project_no_, attr_ );
   ELSIF project_code_part_ = 'B' THEN
      Client_SYS.Add_To_Attr( 'CODENO_B',    project_no_, attr_ );
   ELSIF project_code_part_ = 'C' THEN
      Client_SYS.Add_To_Attr( 'CODENO_C',    project_no_, attr_ );
   ELSIF project_code_part_ = 'D' THEN
      Client_SYS.Add_To_Attr( 'CODENO_D',    project_no_, attr_ );
   ELSIF project_code_part_ = 'E' THEN
      Client_SYS.Add_To_Attr( 'CODENO_E',    project_no_, attr_ );
   ELSIF project_code_part_ = 'F' THEN
      Client_SYS.Add_To_Attr( 'CODENO_F',    project_no_, attr_ );
   ELSIF project_code_part_ = 'G' THEN
      Client_SYS.Add_To_Attr( 'CODENO_G',    project_no_, attr_ );
   ELSIF project_code_part_ = 'H' THEN
      Client_SYS.Add_To_Attr( 'CODENO_H',    project_no_, attr_ );
   ELSIF project_code_part_ = 'I' THEN
      Client_SYS.Add_To_Attr( 'CODENO_I',    project_no_, attr_ );
   ELSIF project_code_part_ = 'J' THEN
      Client_SYS.Add_To_Attr( 'CODENO_J',    project_no_, attr_ );
   END IF;

   IF (Check_Exist___(pre_accounting_id_)) THEN
      oldrec_ := Lock_By_Keys___ (pre_accounting_id_);
      newrec_ := oldrec_;
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
      Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE); -- Update by keys
   ELSE
      Client_SYS.Add_To_Attr( 'PRE_ACCOUNTING_ID', pre_accounting_id_, attr_ );
      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);
   END IF;

EXCEPTION
   WHEN code_part_not_allowed THEN
      code_part_name_ := Accounting_Code_Parts_API.Get_Name(company_, project_code_part_);
      IF (Posting_Ctrl_API.Get_Control_Type(company_,posting_type_) IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'PRPNTALLOWED1: Posting type :P1 must be set up to allow pre posting on code part :P2.', posting_type_, code_part_name_);
      ELSE
         Error_SYS.Record_General(lu_name_, 'PRPNOTALLOWED: Pre posting is not allowed on code part :P1 for posting type :P2.', code_part_name_, posting_type_);
      END IF;
END Set_Project_Code_Part;


-- Get_Count_Distribution
--   Check if a pre accounting distribution exists and
--   at least one of its code part is not NULL and
--   returns the count of the number of preaccounting distribution.
@UncheckedAccess
FUNCTION Get_Count_Distribution (
  pre_accounting_id_ IN NUMBER ) RETURN NUMBER
IS
   count_distribution_ NUMBER;
   CURSOR count_control IS
      SELECT count(*)
      FROM   PRE_ACCOUNTING_TAB
      WHERE parent_pre_accounting_id = pre_accounting_id_
      AND   amount_distribution IS NOT NULL;
BEGIN
   OPEN count_control;
   FETCH count_control INTO count_distribution_;
   IF (count_control%FOUND) THEN
      CLOSE count_control;
      RETURN(count_distribution_);
   END IF;
   CLOSE count_control;
   RETURN(0);
END Get_Count_Distribution;


-- Get_Distribution_Percentage
--   To obtain Distribution Percentage in each line.
@UncheckedAccess
FUNCTION Get_Distribution_Percentage (
   parent_pre_accounting_id_ IN NUMBER ) RETURN VARCHAR2
IS
   attr_        VARCHAR2(2000);
   CURSOR get_distribution_percentage IS
      SELECT amount_distribution
      FROM PRE_ACCOUNTING_TAB
      WHERE parent_pre_accounting_id = parent_pre_accounting_id_;
BEGIN
   FOR line_percentage IN get_distribution_percentage LOOP
      attr_ := attr_ ||TO_CHAR(line_percentage.amount_distribution)||';';
   END LOOP;
   RETURN attr_;
END Get_Distribution_Percentage;


-- Check_Ord_Connected
--   This method is used to check whether a customer order is connected to
--   a given activity.
@UncheckedAccess
FUNCTION Check_Ord_Connected (
   pre_accounting_id_ IN NUMBER,
   activity_seq_      IN NUMBER ) RETURN NUMBER
IS
   dummy_ NUMBER;

   CURSOR get_cust_conn IS
   SELECT 1 FROM PRE_ACCOUNTING_TAB
   WHERE activity_seq = activity_seq_
   AND   pre_accounting_id = pre_accounting_id_;
BEGIN
   OPEN get_cust_conn;
   FETCH get_cust_conn INTO dummy_;
   IF (get_cust_conn%FOUND) THEN
      CLOSE get_cust_conn;
      RETURN 1;
   END IF;
   CLOSE get_cust_conn;
   RETURN 0;
END Check_Ord_Connected;


-- Modify
--   This public method is used to modify records.
PROCEDURE Modify (
   pre_accounting_id_         IN NUMBER,
   codeno_a_                  IN VARCHAR2,
   codeno_b_                  IN VARCHAR2,
   codeno_c_                  IN VARCHAR2,
   codeno_d_                  IN VARCHAR2,
   codeno_e_                  IN VARCHAR2,
   codeno_f_                  IN VARCHAR2,
   codeno_g_                  IN VARCHAR2,
   codeno_h_                  IN VARCHAR2,
   codeno_i_                  IN VARCHAR2,
   codeno_j_                  IN VARCHAR2,
   company_                   IN VARCHAR2,
   posting_type_              IN VARCHAR2,
   contract_                  IN VARCHAR2,
   activity_seq_              IN NUMBER DEFAULT NULL,
   check_allowed_code_parts_  IN BOOLEAN DEFAULT TRUE,
   skip_code_part_validation_ IN BOOLEAN DEFAULT FALSE )
IS
   attr_           VARCHAR2(32000);
   newrec_         PRE_ACCOUNTING_TAB%ROWTYPE;
   oldrec_         PRE_ACCOUNTING_TAB%ROWTYPE;
   objid_          PRE_ACCOUNTING.objid%TYPE;
   objversion_     PRE_ACCOUNTING.objversion%TYPE;
   indrec_         Indicator_Rec;
BEGIN
   IF (check_allowed_code_parts_) THEN
      Check_Allowed_Code_Parts___(codeno_a_,
                                  codeno_b_,
                                  codeno_c_,
                                  codeno_d_,
                                  codeno_e_,
                                  codeno_f_,
                                  codeno_g_,
                                  codeno_h_,
                                  codeno_i_,
                                  codeno_j_,
                                  company_,
                                  posting_type_);
   END IF;
   
   IF (NOT skip_code_part_validation_) THEN
      Validate_Code_Parts___(codeno_a_,
                             codeno_b_,
                             codeno_c_,
                             codeno_d_,
                             codeno_e_,
                             codeno_f_,
                             codeno_g_,
                             codeno_h_,
                             codeno_i_,
                             codeno_j_,
                             company_,
                             contract_);
   END IF;
   
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr( 'ACCOUNT_NO', codeno_a_, attr_ );
   Client_SYS.Add_To_Attr( 'CODENO_B', codeno_b_, attr_ );
   Client_SYS.Add_To_Attr( 'CODENO_C', codeno_c_, attr_ );
   Client_SYS.Add_To_Attr( 'CODENO_D', codeno_d_, attr_ );
   Client_SYS.Add_To_Attr( 'CODENO_E', codeno_e_, attr_ );
   Client_SYS.Add_To_Attr( 'CODENO_F', codeno_f_, attr_ );
   Client_SYS.Add_To_Attr( 'CODENO_G', codeno_g_, attr_ );
   Client_SYS.Add_To_Attr( 'CODENO_H', codeno_h_, attr_ );
   Client_SYS.Add_To_Attr( 'CODENO_I', codeno_i_, attr_ );
   Client_SYS.Add_To_Attr( 'CODENO_J', codeno_j_, attr_ );
   Client_SYS.Add_To_Attr( 'COMPANY', company_, attr_ );
   Client_SYS.Add_To_Attr( 'CONTRACT', contract_, attr_ );
   Client_SYS.Add_To_Attr( 'ACTIVITY_SEQ', activity_seq_, attr_ );
   IF (skip_code_part_validation_) THEN
      Client_SYS.Add_To_Attr('SKIP_CODE_PART_VALIDATION', 'TRUE', attr_ );
   END IF;   
   oldrec_ := Lock_By_Keys___(pre_accounting_id_);
   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_,TRUE);
END Modify;


-- Remove_Proj_Pre_Posting
--   The method sets the code part for project and activity_seq to NULL.
PROCEDURE Remove_Proj_Pre_Posting (
   pre_accounting_id_         IN NUMBER,
   contract_                  IN VARCHAR2,
   posting_type_              IN VARCHAR2,
   skip_code_part_validation_ IN BOOLEAN DEFAULT FALSE )
IS

   company_               VARCHAR2(20);
   lu_rec_                PRE_ACCOUNTING_TAB%ROWTYPE;
   project_code_part_     VARCHAR2(10);
   is_code_a_             NUMBER;
   is_code_b_             NUMBER;
   is_code_c_             NUMBER;
   is_code_d_             NUMBER;
   is_code_e_             NUMBER;
   is_code_f_             NUMBER;
   is_code_g_             NUMBER;
   is_code_h_             NUMBER;
   is_code_i_             NUMBER;
   is_code_j_             NUMBER;

BEGIN


   company_ := Site_API.Get_Company(contract_);

   project_code_part_ := Get_Project_Code_Part___(company_);

   IF (project_code_part_ IS NULL) THEN
      Error_SYS.Record_General('PreAccounting', 'NOPROJEXIST: No code part is set as Project, cannot remove project preposting.');
   END IF;

   lu_rec_ := Get_Object_By_Keys___(pre_accounting_id_);
   Get_Allowed_Codeparts(is_code_a_,
                         is_code_b_,
                         is_code_c_,
                         is_code_d_,
                         is_code_e_,
                         is_code_f_,
                         is_code_g_,
                         is_code_h_,
                         is_code_i_,
                         is_code_j_,
                         posting_type_,
                         NULL,
                         company_);

   IF ((project_code_part_  = 'A') OR (is_code_a_ = 0)) THEN
      lu_rec_.account_no   := NULL;
   END IF;

   IF ((project_code_part_  = 'B') OR (is_code_b_ = 0)) THEN
      lu_rec_.codeno_b   := NULL;
   END IF;

   IF ((project_code_part_  = 'C') OR (is_code_c_ = 0)) THEN
      lu_rec_.codeno_c   := NULL;
   END IF;

   IF ((project_code_part_  = 'D') OR (is_code_d_ = 0)) THEN
      lu_rec_.codeno_d   := NULL;
   END IF;

   IF ((project_code_part_  = 'E') OR (is_code_e_ = 0)) THEN
      lu_rec_.codeno_e   := NULL;
   END IF;

   IF ((project_code_part_  = 'F') OR (is_code_f_ = 0)) THEN
      lu_rec_.codeno_f   := NULL;
   END IF;

   IF ((project_code_part_  = 'G') OR (is_code_g_ = 0)) THEN
      lu_rec_.codeno_g   := NULL;
   END IF;

   IF ((project_code_part_  = 'H') OR (is_code_h_ = 0)) THEN
      lu_rec_.codeno_h   := NULL;
   END IF;

   IF ((project_code_part_  = 'I') OR (is_code_i_ = 0)) THEN
      lu_rec_.codeno_i   := NULL;
   END IF;

   IF ((project_code_part_  = 'J') OR (is_code_j_ = 0)) THEN
      lu_rec_.codeno_j   := NULL;
   END IF;

   Modify(pre_accounting_id_,
          lu_rec_.account_no,
          lu_rec_.codeno_b,
          lu_rec_.codeno_c,
          lu_rec_.codeno_d,
          lu_rec_.codeno_e,
          lu_rec_.codeno_f,
          lu_rec_.codeno_g,
          lu_rec_.codeno_h,
          lu_rec_.codeno_i,
          lu_rec_.codeno_j,
          company_,
          posting_type_,
          contract_,
          NULL,
          skip_code_part_validation_  => skip_code_part_validation_);

END Remove_Proj_Pre_Posting;


-- Get_Project_Code_Value
--   Returns the Value of the Project code part
PROCEDURE Get_Project_Code_Value (
   proj_code_value_       OUT VARCHAR2,
   distr_proj_code_value_ OUT VARCHAR2,
   company_               IN VARCHAR2,
   pre_accounting_id_     IN NUMBER )
IS
   pre_acc_rec_           PRE_ACCOUNTING_TAB%ROWTYPE;
   CURSOR get_distribute(pre_accounting_id_ IN NUMBER) IS
     SELECT *
     FROM PRE_ACCOUNTING_TAB
     WHERE PARENT_PRE_ACCOUNTING_ID = pre_accounting_id_;
BEGIN
   pre_acc_rec_ := Get_Object_By_Keys___(pre_accounting_id_);
   proj_code_value_ := Get_Project_Code_Value___(company_,pre_acc_rec_);
   FOR code_row_ IN get_distribute(pre_accounting_id_) LOOP
      pre_acc_rec_ := Get_Object_By_Keys___(code_row_.pre_accounting_id);
      distr_proj_code_value_ := Get_Project_Code_Value___(company_,pre_acc_rec_);
      IF distr_proj_code_value_ IS NOT NULL THEN
         EXIT;
      END IF;
   END LOOP;
END Get_Project_Code_Value;

PROCEDURE New_Distribution (
   parent_pre_accounting_id_ IN NUMBER,
   codestring_tab_           IN Codestring_Table_Type,
   company_                  IN VARCHAR2,
   posting_type_             IN VARCHAR2,
   contract_                 IN VARCHAR2,
   check_allowed_code_parts_ IN BOOLEAN DEFAULT TRUE )
IS
   newrec_        pre_accounting_tab%ROWTYPE;
   emptyrec_      pre_accounting_tab%ROWTYPE;
   objid_         VARCHAR2(20);
   objversion_    VARCHAR2(100);
   attr_          VARCHAR2(32000);
   indrec_        Indicator_Rec;
 BEGIN
   IF (codestring_tab_.COUNT > 0) THEN
      FOR i IN codestring_tab_.FIRST..codestring_tab_.LAST LOOP
         IF (check_allowed_code_parts_) THEN
            Check_Allowed_Code_Parts___(codestring_tab_(i).account_no,
                                        codestring_tab_(i).codeno_b,
                                        codestring_tab_(i).codeno_c,
                                        codestring_tab_(i).codeno_d,
                                        codestring_tab_(i).codeno_e,
                                        codestring_tab_(i).codeno_f,
                                        codestring_tab_(i).codeno_g,
                                        codestring_tab_(i).codeno_h,
                                        codestring_tab_(i).codeno_i,
                                        codestring_tab_(i).codeno_j,
                                        company_,
                                        posting_type_);
         END IF;
         Validate_Code_Parts___(codestring_tab_(i).account_no, 
                                codestring_tab_(i).codeno_b,   
                                codestring_tab_(i).codeno_c,   
                                codestring_tab_(i).codeno_d,   
                                codestring_tab_(i).codeno_e,   
                                codestring_tab_(i).codeno_f,   
                                codestring_tab_(i).codeno_g,   
                                codestring_tab_(i).codeno_h,   
                                codestring_tab_(i).codeno_i,   
                                codestring_tab_(i).codeno_j,   
                                company_,
                                contract_);
         Client_SYS.Clear_Attr(attr_);
         Reset_Indicator_Rec___(indrec_);
         newrec_ := emptyrec_;
         Client_SYS.Add_To_Attr( 'PRE_ACCOUNTING_ID'       , Get_Next_Pre_Accounting_Id            , attr_);
         Client_SYS.Add_To_Attr( 'PARENT_PRE_ACCOUNTING_ID', parent_pre_accounting_id_             , attr_);
         Client_SYS.Add_To_Attr( 'ACCOUNT_NO'              , codestring_tab_(i).account_no         , attr_);
         Client_SYS.Add_To_Attr( 'CODENO_B'                , codestring_tab_(i).codeno_b           , attr_);
         Client_SYS.Add_To_Attr( 'CODENO_C'                , codestring_tab_(i).codeno_c           , attr_);
         Client_SYS.Add_To_Attr( 'CODENO_D'                , codestring_tab_(i).codeno_d           , attr_);
         Client_SYS.Add_To_Attr( 'CODENO_E'                , codestring_tab_(i).codeno_e           , attr_);
         Client_SYS.Add_To_Attr( 'CODENO_F'                , codestring_tab_(i).codeno_f           , attr_);
         Client_SYS.Add_To_Attr( 'CODENO_G'                , codestring_tab_(i).codeno_g           , attr_);
         Client_SYS.Add_To_Attr( 'CODENO_H'                , codestring_tab_(i).codeno_h           , attr_);
         Client_SYS.Add_To_Attr( 'CODENO_I'                , codestring_tab_(i).codeno_i           , attr_);
         Client_SYS.Add_To_Attr( 'CODENO_J'                , codestring_tab_(i).codeno_j           , attr_);
         Client_SYS.Add_To_Attr( 'ACTIVITY_SEQ'            , codestring_tab_(i).activity_seq       , attr_);
         Client_SYS.Add_To_Attr( 'COMPANY'                 , company_                              , attr_);
         Client_SYS.Add_To_Attr( 'CONTRACT'                , contract_                             , attr_);
         Client_SYS.Add_To_Attr( 'LINE_AMOUNT'             , codestring_tab_(i).amount_distribution, attr_);
         Client_SYS.Add_To_Attr( 'TOTAL_AMOUNT'            , 1                                     , attr_);
         Unpack___(newrec_, indrec_, attr_);
         Check_Insert___(newrec_, indrec_, attr_);
         Insert___(objid_, objversion_, newrec_, attr_);
      END LOOP;
      Check_Distribution_Complete__(parent_pre_accounting_id_);
   END IF;

END New_Distribution;

--Get_Fa_Object_Id
-- This method returns the code part value of FA accounting code part.
-- If distributed postings exist, if will return the code part which is not already connected to a serial.
@UncheckedAccess
FUNCTION Get_Fa_Object_Id(
   company_               IN VARCHAR2,
   pre_accounting_id_     IN NUMBER ) RETURN VARCHAR2 
IS
   code_part_          VARCHAR2(1);
   code_part_value_    VARCHAR2(10);
   distribution_exist_ NUMBER;
   
   CURSOR get_pre_accounting IS
      SELECT 
         CASE code_part_
            WHEN 'A' THEN account_no 
            WHEN 'B' THEN codeno_b
            WHEN 'C' THEN codeno_c   
            WHEN 'D' THEN codeno_d   
            WHEN 'E' THEN codeno_e  
            WHEN 'F' THEN codeno_f 
            WHEN 'G' THEN codeno_g   
            WHEN 'H' THEN codeno_h   
            WHEN 'I' THEN codeno_i   
            WHEN 'J' THEN codeno_j
         END AS object_id        
      FROM   PRE_ACCOUNTING_TAB
      WHERE (distribution_exist_ = 1 AND parent_pre_accounting_id = pre_accounting_id_) OR
            (distribution_exist_ = 0 AND pre_accounting_id = pre_accounting_id_);
BEGIN
   code_part_ := Accounting_Code_Parts_API.Get_Codepart_Function(company_, Accounting_Code_Part_Fu_API.DB_FA_ACCOUNTING);
   distribution_exist_ := Distribution_Exist(pre_accounting_id_);
   FOR rec_ IN get_pre_accounting LOOP 
      IF (distribution_exist_ = 0) THEN 
         code_part_value_ := rec_.object_id;
      ELSE
         IF (Part_Serial_Catalog_API.Serials_With_Fa_Object_Exists(company_, rec_.object_id) = 'FALSE') THEN 
            code_part_value_ := rec_.object_id;
            EXIT;
         END IF;
      END IF;   
   END LOOP;
   RETURN code_part_value_;
END;

FUNCTION Is_Allowed_Codepart(
   code_name_    IN VARCHAR2,
   str_code_     IN VARCHAR2,
   control_type_ IN VARCHAR2,
   company_     IN VARCHAR2 ) RETURN NUMBER
IS
   code_a_ NUMBER := 0;
   code_b_ NUMBER := 0;
   code_c_ NUMBER := 0;
   code_d_ NUMBER := 0;
   code_e_ NUMBER := 0;
   code_f_ NUMBER := 0;
   code_g_ NUMBER := 0;
   code_h_ NUMBER := 0;
   code_i_ NUMBER := 0;
   code_j_ NUMBER := 0;
BEGIN
   Get_Allowed_Codeparts(code_a_, code_b_, code_c_, code_d_, code_e_, code_f_, code_g_, code_h_, code_i_, code_j_, str_code_, control_type_, company_);
   CASE code_name_
      WHEN 'A' THEN RETURN code_a_;
      WHEN 'B' THEN RETURN code_b_;
      WHEN 'C' THEN RETURN code_c_;
      WHEN 'D' THEN RETURN code_d_;
      WHEN 'E' THEN RETURN code_e_;
      WHEN 'F' THEN RETURN code_f_;
      WHEN 'G' THEN RETURN code_g_;
      WHEN 'H' THEN RETURN code_h_;
      WHEN 'I' THEN RETURN code_i_;
      WHEN 'J' THEN RETURN code_j_;
   END CASE;
   RETURN 0;
END Is_Allowed_Codepart;

PROCEDURE Prj_Pre_Posting_Required (
   prj_pre_posting_            OUT BOOLEAN,
   include_activity_seq_       OUT BOOLEAN,
   control_type_key_rec_       IN  Mpccom_Accounting_API.Control_Type_Key,
   project_accounting_flag_db_ IN  VARCHAR2,
   company_                    IN  VARCHAR2,
   codestring_rec_             IN  Accounting_Codestr_API.CodestrRec )
IS
BEGIN
   Prj_Pre_Posting_Required___( prj_pre_posting_,
                                include_activity_seq_ ,
                                control_type_key_rec_,
                                project_accounting_flag_db_,
                                company_ ,
                                codestring_rec_);
END Prj_Pre_Posting_Required;

-- Get_Codeparts_Settings 
-- Can be used to get the full picture of allowed and mandatory code parts for a certain posting type and company.
-- For each code part you either get 'Disabled', 'Allowed' or 'Mandatory'
-- In addition there is a all_codeparts_compiled attribute that will be 'Disabled' if no code parts are allowed or mandatory, 
-- 'Allowed' if any code part is allowed and no one mandatory or 'Mandatory' id any code part is mandatory.
FUNCTION Get_Codeparts_Settings(
   str_code_      IN VARCHAR2,
   company_       IN VARCHAR2) RETURN Codeparts_Settings_Rec
IS
   any_mandatory_      BOOLEAN := FALSE;
   any_allowed_        BOOLEAN := FALSE;
   code_a_             NUMBER := 0;
   code_b_             NUMBER := 0;
   code_c_             NUMBER := 0;
   code_d_             NUMBER := 0;
   code_e_             NUMBER := 0;
   code_f_             NUMBER := 0;
   code_g_             NUMBER := 0;
   code_h_             NUMBER := 0;
   code_i_             NUMBER := 0;
   code_j_             NUMBER := 0;
   mandatory_code_a_   NUMBER := 0;
   mandatory_code_b_   NUMBER := 0;
   mandatory_code_c_   NUMBER := 0;
   mandatory_code_d_   NUMBER := 0;
   mandatory_code_e_   NUMBER := 0;
   mandatory_code_f_   NUMBER := 0;
   mandatory_code_g_   NUMBER := 0;
   mandatory_code_h_   NUMBER := 0;
   mandatory_code_i_   NUMBER := 0;
   mandatory_code_j_   NUMBER := 0;
   disabled_           VARCHAR2(9) := 'DISABLED';
   rec_                Codeparts_Settings_Rec;
   
   PROCEDURE Check_Enabled___ (
      value_               IN OUT VARCHAR2,
      any_mandatory_       IN OUT BOOLEAN,
      any_allowed_         IN OUT BOOLEAN,
      mandatory_field_     IN NUMBER,
      non_mandatory_field_ IN NUMBER )
   IS 
   BEGIN
      IF (mandatory_field_ = 1) THEN
         value_ := 'MANDATORY';
         IF NOT any_mandatory_ THEN
            any_mandatory_ := TRUE;
         END IF;
      ELSIF (non_mandatory_field_ = 1) THEN
         value_ := 'ALLOWED';
         IF NOT any_allowed_ THEN
            any_allowed_ := TRUE;
         END IF;
      END IF;
   END Check_Enabled___;
BEGIN
   rec_.all_codeparts_compiled := disabled_;
   rec_.account_no             := disabled_;
   rec_.codeno_b               := disabled_;
   rec_.codeno_c               := disabled_;
   rec_.codeno_d               := disabled_;
   rec_.codeno_e               := disabled_;
   rec_.codeno_f               := disabled_;
   rec_.codeno_g               := disabled_;
   rec_.codeno_h               := disabled_;
   rec_.codeno_i               := disabled_;
   rec_.codeno_j               := disabled_;
   Get_Allowed_Codeparts(mandatory_code_a_, mandatory_code_b_, mandatory_code_c_, mandatory_code_d_, mandatory_code_e_, mandatory_code_f_, 
                         mandatory_code_g_, mandatory_code_h_, mandatory_code_i_, mandatory_code_j_, str_code_, 'C58', company_);
   Get_Allowed_Codeparts(code_a_, code_b_, code_c_, code_d_, code_e_, code_f_, 
                         code_g_, code_h_, code_i_, code_j_, str_code_, 'AC2', company_);
   Check_Enabled___(rec_.account_no, any_mandatory_, any_allowed_, mandatory_code_a_, code_a_);
   Check_Enabled___(rec_.codeno_b, any_mandatory_, any_allowed_, mandatory_code_b_, code_b_);
   Check_Enabled___(rec_.codeno_c, any_mandatory_, any_allowed_, mandatory_code_c_, code_c_);
   Check_Enabled___(rec_.codeno_d, any_mandatory_, any_allowed_, mandatory_code_d_, code_d_);
   Check_Enabled___(rec_.codeno_e, any_mandatory_, any_allowed_, mandatory_code_e_, code_e_);
   Check_Enabled___(rec_.codeno_f, any_mandatory_, any_allowed_, mandatory_code_f_, code_f_);
   Check_Enabled___(rec_.codeno_g, any_mandatory_, any_allowed_, mandatory_code_g_, code_g_);
   Check_Enabled___(rec_.codeno_h, any_mandatory_, any_allowed_, mandatory_code_h_, code_h_);
   Check_Enabled___(rec_.codeno_i, any_mandatory_, any_allowed_, mandatory_code_i_, code_i_);
   Check_Enabled___(rec_.codeno_j, any_mandatory_, any_allowed_, mandatory_code_j_, code_j_);
   IF (any_mandatory_) THEN
      rec_.all_codeparts_compiled := 'MANDATORY';
   ELSIF (any_allowed_) THEN
      rec_.all_codeparts_compiled := 'ALLOWED';
   END IF;
   RETURN rec_;
END Get_Codeparts_Settings;

PROCEDURE Set_Company_And_Total_Amount (
   pre_accounting_id_ IN NUMBER,
   contract_          IN VARCHAR2,
   total_amount_      IN NUMBER )
IS
   objid_         VARCHAR2(20);
   objversion_    VARCHAR2(100);
   attr_          VARCHAR2(32000);
   indrec_        Indicator_Rec;
   newrec_        pre_accounting_tab%ROWTYPE;
   oldrec_        pre_accounting_tab%ROWTYPE;
   company_       pre_accounting_tab.company%TYPE;
BEGIN
   IF (contract_ IS NOT NULL) THEN
      company_ := Site_API.Get_Company(contract_);
      Client_SYS.Add_To_Attr('COMPANY' , company_ , attr_ );
      Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_ );
   END IF;
   Client_SYS.Add_To_Attr( 'TOTAL_AMOUNT', total_amount_, attr_ );

   Get_Id_Version_By_Keys___(objid_, objversion_, pre_accounting_id_);

   IF (objid_ IS NULL) THEN
      Client_SYS.Add_To_Attr('PRE_ACCOUNTING_ID', pre_accounting_id_, attr_ );
      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);
   ELSE
      Client_SYS.Add_To_Attr('SKIP_CODE_PART_VALIDATION', 'TRUE', attr_ );       
      oldrec_ := Lock_By_Id___(objid_, objversion_);
      newrec_ := oldrec_;
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
      Update___(objid_, oldrec_, newrec_, attr_, objversion_);
   END IF;   
END Set_Company_And_Total_Amount;


PROCEDURE Check_Enabled (
   company_      IN VARCHAR2,
   posting_type_ IN VARCHAR2 )
IS
   settings_rec_ Codeparts_Settings_Rec;
BEGIN
   settings_rec_ := Get_Codeparts_Settings(posting_type_, company_);
   IF (settings_rec_.all_codeparts_compiled = 'DISABLED') THEN
      Error_SYS.Record_General(lu_name_, 'NOTENABLED: :P1 (posting type :P2) is not enabled in company :P3', Posting_Ctrl_Posting_Type_API.Get_Description(posting_type_), posting_type_, company_);
   END IF;
END Check_Enabled;


FUNCTION Get_Project_Code_Part (
   company_ IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Project_Code_Part___(company_);
END Get_Project_Code_Part;


FUNCTION External_Project (
   project_no_ IN VARCHAR2,
   company_    IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN External_Project___(project_no_, company_);
END External_Project;
