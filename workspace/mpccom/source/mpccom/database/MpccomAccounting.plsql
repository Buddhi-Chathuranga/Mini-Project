-----------------------------------------------------------------------------
--
--  Logical unit: MpccomAccounting
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  --------------------------------------------------------
--  211208  JaThlk  Bug 161723 (SC21R2-6478), Modified Control_Type_Key to increase the length of wo_work_order_no_ and wo_task_seq_ 
--  211208          to avoid errors due to length limitation.
--  211201  Asawlk  SC21R2-6382, Modified Get_Curr_Amount_Details() to get all the posted currency information, which altimately prevents the creation of unnecessary BALINVOIC transaction.
--  211102  MaEelk  SC21R2-5668, Replaced oe_tax_code_with tax_code_ in the Control_Type_Key and other used places.
--  211102          Removed the code written inside Get_Str_Code_Vat___ to handle control_type_name_tab_(25) and moved it to Get_Code_String_Values___.
--  211001  Asawlk  Bug 160509 (SC21R2-2545), Modified Do_Accounting___ in order to not to create postings with negative values for events 'POINV-WIP', 'RETWOR-WIP' and 'RETCRE-WIP' 
--  211001          when correction_type = 'REVERSE'. Instead the postings will be created by swapping the debit and credit.
--  210927  fiallk  FI21R2-4055, Added Get_Str_Code_Business_Transaction_Code___() to add value to control_value_tab for control type C128 and modified method Get_Code_String_Values___.
--  210923  Asawlk  SC21R2-2748, Modified Get_Curr_Amount_Details() in a way that it always returns the currency information of the 
--  210923          latest posting at the end in the collection. 
--  210909  Asawlk  SC21R2-1895, Modified Do_Curr_Amt_Diff_Posting() to exit the execution if the base, receipt and invoice currencies are the same.
--  210817  LEPESE  MF21R2-2533, renamed data source for C117 from Manuf_Wip_Posting_Event_API to Manuf_Wip_Material_Action_API.
--  210812  LEPESE  MF21R2-2533, added logic for control type C127 in method Get_Code_String_Values___.
--  210726  LEPESE  MF21R2-2533, Added by-product logic in Get_Str_Code_Manu_Wip_Event___ for Production Schedules and Periodic WA transactions.
--  210726          Added ps_line_item_no_ to Control_Type_Key_Rec and initialize it from source_ref4 in Set_Control_Type_Key.
--  210710  LEPESE  MF21R2-2533, Added methods Get_Str_Code_Manu_Wip_Event___ and Get_Str_Code_Component_Part___. Added logic in Get_Code_String_Values___ for
--  210710          Control Types C117-C126. Added consideration to event codes MATCOST, PRODCOST and PRODCOST- that comes from Polish Localization follow_up_mat_prod_cost
--  210710          in methods Get_Total_Cost and Get_Total_Abs_Value to avoid errors for customers upgrading from GET to 21R2 Core. Also added code in
--  210710          Get_Code_String_Values___ and Get_Str_Code_Part___ to be backwards compatible for MATCOST, PRODCOST, PRODCOST-, C113, C114, C115, M281 and M283
--  210710          so that we can recreate the code string for postings coming from the polish localization follow_up_mat_prod_cost. 
--  210527  LEPESE  SC21R2-794, Added parameter date_posted_ to method Do_Curr_Amt_Balance_Posting.
--  210512  Asawlk  AM21R2-1446, Added new method Get_Code_String_By_Keys(). 
--  210105  LEPESE  SC2020R1-11856, Replaced usage of attribute string with direct assignment to records throughout the file.
--  201015  RoJalk  Bug 148960(SCZ-11815), Modified Get_Code_String_Values___() and Get_Str_Code_Order___() in order to consider C13 and C14 when creating postings. 
--  201015  SBALLK  Bug 155515(SCZ-11330), Modified Reverse_Accounting() and added Validate_Fa_Object_Account___() methods to validate FA OBJECTS when canceling the purchase order receipt.
--  200922  LEPESE  SC2021R1-291, added wt_task_seq_, wt_mtrl_order_no_ and wt_line_item_no_ to Control_Type_Key_Rec. Renamed method Get_Str_Code_Woorder___ into
--  200922          Get_Str_Code_Work_Task___. Renamed Is_Work_Order_Posting__ into Is_Work_Task_Posting___. Adapted Get_Str_Code_Work_Task___ to handle the set
--  200922          of control_typ_key_rec_ references that we have for Work Task transactions and postings. Opened up Send_Posting_To_Pcm___ for Work Task postings.
--  200917  LEPESE  SC2021R1-291, added transactions WTRENT+ and WTRENT- to method Send_Posting_To_Pcm___. Replaced WORENT+ with WTRENT+ in Get_Project_Cost_Elements.
--  200723  MalLlk  GESPRING20-4618, Modified Get_Code_String_Values___() to add control type 116 as well to get str code for Customer Order. 
--  200723          Modified Get_Str_Code_Order___() to add value to control_value_tab_ for control type 116.  
--  200715  MaEelk  Bug 154252(SCZ-10306), Modified Do_Curr_Amt_Balance_Posting and stopped creating unnecessary M189 postings 
--  200715          for Purchase Order Lines having Transaction Based Parts and charges distributed per amount.
--  200611  LEPESE  SC2021R1-294, Adding consideration to order type WORK-TASK and accounting event WTISS in Get_Project_Cost_Elements.
--  200511  SBalLK  Bug 153643(SCZ-9813), Modified Control_Type_Key, Set_Control_Type_Key(), Do_Accounting___() methods by removing rental related functionality
--  200511          since the functionality implemented incorporate to relevant source objects.
--  200311  ManWlk  Bug 149518(MFZ-1957), Modified Get_Project_Cost_Elements() to fetch accounting_id using mpc_sim_accounting_id sequence.
--  191227  BudKlk  Bug 151163,(SCZ-7983), Modified the method Transfer_To_Finance___() to increase the size of the variable order_no_ to 50 in order to avoid errors.
--  191226  Asawlk  Bug 151032(SCZ-7882), Modified Do_Curr_Amt_Balance_Posting(), by adding default NULL parameter control_type_key_rec_. Also modified Do_Curr_Amount_Posting___()
--  191226          by adding parameter control_type_key_rec_. Passed control_type_key_rec_ from Do_Curr_Amt_Balance_Posting() to Do_Accounting() through Do_Curr_Amount_Posting___().   
--  190913  Asawlk  Bug 149952(PJZ-2839), Modified Get_Project_Cost_Elements() to pass a not NULL unrealistic value (-9999) to activity_seq_ upon calling Set_Control_Type_Key()
--  190913          when the control type AC22 is being used in the company. Otherwise the activity_seq_ will be NULL.
--  180815  ChFolk  SCUXXW4-6792, Added new method Accounting_Have_Errors_Str which returns string result for the method Accounting_Have_Errors.
--  190115  Asawlk  Bug 146239 (SCZ-2624), Modified Do_Accounting___ to stop the creation of postings with negative values(when correction_type = 'REVERSE') for value adjustments as well as  
--  190115          different types of charges. Instead, now such postings will be created by swapping the debit and credit.
--  181017  Cpeilk  Bug 143569, Reversed the previous correction and Modified Do_Curr_Amt_Balance_Posting to ignore RETREVAL postings when looking for previous postings.
--  180926  Cpeilk  Bug 143569, Modified Do_Curr_Amt_Balance_Posting to consider invoice cancel when calculating currency_amount_ for reverse posting creation.
--  180914  Asawlk  Bug 144172, Added new method Get_Suppl_Invoic_Matching_Info___ and called inside Transfer_To_Finance___.
--  180904  Kisalk  Bug 144036 (SCZ-1014), Modified Get_Str_Code_Rma___ to set region_code and district_code from delivery address of customer irrespective of single occurrence flag.
--  180406  ChBnlk  Bug 140497, Modified the method signatures of Get_Control_Type_Values___(), Get_Code_String___(), Do_Accounting___(), Get_Project_Cost_Elements(), Get_Project_Cost_Elements()
--  180406          to have the new parameter condition_code_ and passed it to the respective method calls. Modified Get_Code_String___() to assign the value of condition_code_
--  180406          as the control type value when posting simulation is run with control type C89.
--  180130  ChFolk  STRSC-16523, Modified booking id to 1 instead of 2 as it is changed to 1 from STRSC-14899. 
--  171220  KiSalk  STRSC-15152 (Bug 139039), Modified Get_Str_Code_Vat___ to fetch posting value C59 through Tax_Handling_Order_Util_API.Get_First_Tax_Code to have a value when multiple tax lines exist.
--  171206  UdGnlk  Bug 138862, Extended the correction done earlier for event codes RETREVAL+ and RETREVAL-.
--  171206          Modified Set_Po_Line_Keys_From_Rma___ to call Return_Material_Line_API.Get_Demand_Purchase_Order_Info which encapsulates fetching PO line infomation.
--  171206          Modified Get_Code_String_Values___ to call Set_Po_Line_Keys_From_Rma___ for event codes 'RETPODIRSH' and 'RETPODSINT'.
--  171206  JoAnSe  STRMF-16413, Bug 139106 Made changes in Reverse_Accounting to avoid creating postings with negative values when correction_type = 'REVERSE'
--  170901  UdGnlk  Bug 136645, Modifid Get_Str_Code_Part___() to take care transaction 'PURTRAN'. 
--  170808  ChFolk  STRSC-11197, Added new IN parameter base_currency_code_ to Remove_Accounting. 
--  170703  ChFolk  STRSC-9304, Added table type Curr_Amount_Posting_Tab which consists of Curr_Amount_Posting_Rec. Added new overloaded method Remove_Accounting
--  170703          which is used to return the old postings with currency amount information. This is used in posting transaction curr_amount in periodic weighted average.
--  170615  DAYJLK  STRSC-9028, Renamed method Get_Po_Arrival_Curr_Info to Get_Currency_Info.
--  170607  ChFolk  STRSC-8803, Modified Do_Curr_Amt_Balance_Posting to get the correct str_code and event_code from the parameter values instead of previous posted rec. 
--  170601  ChFolk  STRSC-7108, Renamed variable only_arrival_ as skip_trans_reval_postings_ in Get_Sum_Amounts_Posted and restructure the method.
--  170601          Renamed variable create_new_posting_ as generate_code_string_ in Do_Curr_Amount_Posting___
--  170531  ChFolk  STRSC-8512, Renamed variable charge_cost_in_receipt_curr_ with unit_cost_in_receipt_curr_ as it is common for both part and charge postings.
--  170531          unit_cost_in_receipt_curr_ contains the value is receipt currency to be posted when invoicing is done in differenet currency.
--  170529  ChFolk  STRSC-8610, Added new parameter receipt_curr_code_ to Do_Curr_Amt_Balance_Posting which is needded to handle third currency senario.
--  170529          Modified Do_Curr_Amt_Balance_Posting to use avg_chg_value_in_inv_curr_ for charges curr postings as the amount posted in mpccom_accouting
--  170529          is not for individual charge line instead of sum of charge in a receipt.
--  170524  ChFolk  STRSC-8610, Modified Do_Curr_Amt_Balance_Posting by adding a new parameter charge_cost_in_receipt_curr_ which has the value to be posted
--  170524          for reversing the receipt charge cost which can not be taken from the previous postings in mpccom accounting.
--  170516  ChFolk  STRSC-7592, Modified Do_Curr_Amt_Balance_Posting to reverse sum_curr_amount_posted_ when handling returns. 
--  170512  ChFolk  STRSC-7592, Modified Do_Curr_Amt_Diff_Posting to change event code when reversing the receipt currency values.
--  170511  ChFolk  STRSC-7925, Modified Do_Curr_Amt_Diff_Posting to to adjust the posting event code when posting the currency diffs in receipt currency.
--  170507  ChFolk  STRSC-7925, Added new parameter create_new_posting_ to Do_Curr_Amount_Posting___ which is used to check creating new postings is needed.
--  170507          Modified Do_Curr_Amt_Diff_Posting to support creating new currency diff posting even if no diff posting is created in base currency.
--  170506  ChFolk  STRSC-7585, Modified Reverse_Accounting to allow creating reverse posting even if the value is 0 but curr_amount is not zero.
--  170506  ChFolk  STRSC-7108  Added new method Do_Curr_Amount_Posting___ to use it in Do_Curr_Amt_Balance_Posting and Do_Curr_Amt_Diff_Posting.
--  170506          Aded exception handling for Do_Curr_Amt_Balance_Posting and Do_Curr_Amt_Diff_Posting when previous record is not found.
--  170505  LEPESE  STRSC-6688, Added parameter check_restricted_delete_ to method Check_Delete___. Passed FALSE in call from Remove_Accounting to skip super call.
--  170503  ChFolk  STRSC-7583, Modified Get_Sum_Amounts_Posted by adding a new parameter only_arrival_ which implies whether to consider only the arrival or cascades as well.
--  170502  ChFolk  STRSC-7593, Modified Do_Curr_Amt_Diff_Posting to add condition for currency_amount_ when creating postings.
--  170426  ChFolk  STRSC-7476, Added new method Do_Curr_Amt_Diff_Posting to create new postings for price diff postings in transaction currency.
--  170424  ChFolk  STRSC-7046, Added currency_code as a parameter to method Get_Total_Curr_Amount. Added new method Do_Curr_Amt_Balance_Posting which supports postings in currency amounts.
--  170412  ChFolk  STRSC-7108, Renamed the method Get_Latest_Trans_Currency_Code as Get_Currency_Code_From_Latest. Modified Do_Accounting___ to remove changing debit_credit_db flag
--  170412          for curr_amount and move that logic to the calling method. Modified Get_Curr_Amount_Details to remove condition trans_reval_event_id IS NULL in cursor get_curr_amount_details in Get_Curr_Amount_Details.  
--  170402  ChFolk  STRSC-4972, Replaced method Get_Sum_Curr_Amount_Posted with Get_Sum_Amounts_Posted which returns posted sum amounts in both base and transaction currencies.
--  170402          Added new method Get_Latest_Trans_Currency_Code which returns the latest transaction currency code
--  170328  Raeklk  STRPJ-18958, Added prjdel_item_no_, prjdel_item_revision_ and prjdel_planning_no_ to Control_Type_Key.
--  170328          Modified Do_Accounting___() add condition on local_control_type_key_rec_.item_no.
--  170328          Modified Set_Control_Type_Key() to add data for prjdel_item_no_, prjdel_item_revision_ and prjdel_planning_no_ in Control_Type_Key.
--  170328          Modified Get_Project_Cost_Elements() handle source_ref_type_db_ 'PROJECT_DELIVERABLES'.
--  170327  ChFolk  STRSC-4971, Added new method Get_Sum_Curr_Amount_Posted which returns curr_amount sum posted for the given currency code. Modifed Do_Accounting___
--  170327          to allow posting negative values for curr_amount_posted_ when base amount is positive. Also add code to change the debit credit flag for a postings only with curr_amount.
--  170327          Added new method Get_Sum_Curr_Amount_Posted which returns sum posted for curr_amount for a given currency code.
--  170209  AmPalk  STRMF-6864, Added reb_aggr_posting_id_ to Control_Type_Key to track flexible postings under rebate created invoices.
--  170209          Moved Get_Ctrl_Type_Value_Oeorder___ to CustomerOrderCtrlUtil LU.
--  170209          Modified Get_Str_Code_Order___, Get_Str_Code_Part___, Get_Str_Code_Salespart___, Get_Str_Code_Oeaddress___, Get_Str_Code_Countrycode___, 
--  170209          Get_Str_Code_Statecode___, Get_Str_Code_Customergroup___, Get_Str_Code_Rebate_Group___ by moving Order related method calls and logic to OrderControlTypeValues LU.
--  170209  Asawlk  STRMF-8027, Modified Get_Code_String___() by splitting the method and placing the control type value retrieval section in
--  170209          new method Get_Control_Type_Values___(). Also added Get_Control_Type_Values() and Validate_Str_Code___.
--  170207  ErFelk  Bug 134069, Modified Transfer_To_Finance() by increasing the length of batch_desc_ and batch_desc_site_ variables to 1000 from 100. 
--  170206  DAYJLK  STRSC-4957, Modified Get_Curr_Amount_Details to consider all postings for posting type M10.
--  160923  MeAblk  GG-72, Added method Get_Str_Code_Fsmtranshist___() and modified Get_Code_String_Values___() to handle FSM transaction code string values.
--  160923  Cpeilk  GG-93, Modified transfer to finance methods to handle FSM transactions. Added FSM as a function group.
--  160913  MeAblk  GG-72, Modified methods Redo_Error_Postings___() and Redo_Error_Bookings_Deferred__() to implement rerun erroneous FSM postings.
--  170117  NiDalk  Bug 125382, Modified Get_Ctrl_Type_Value_Oeorder___ to to call Customer_Order_Inv_Item_API.Get_Ctrl_Type_Values to fetch order related control type values.
--  170106  ChFolk  STRSC-5303, Added new method Get_Total_Curr_Amount which retuns the currency_amount sum for the given curr_amount_detail_tab.
--  170104  DAYJLK  STRSC-4946, Added methods Get_Curr_Amount_Details, Get_Merged_Curr_Amount_Tab, and Get_Merged_Curr_Amount_Tab___.
--  161213  HASTSE  STRSA-15700, Fixed handling of material transactions from work tasks(S&A) in Send_Posting_To_Pcm___
--  161130  HASTSE  STRSA-15888, Posting control Generalizations in S&A
--  161107  ErFelk  Bug 130948, Modified Get_Str_Code_Woorder___() by passing values to new parameters wo_release_no_ and wo_system_ident_ when calling
--  161107          Active_Work_Order_Util_API.Get_Values_For_Accounting().
--  161012  Nuwklk  STRSA-6879, Modified Send_Posting_To_Pcm___.
--  160729  Hecolk  FINLIFE-118, Identify Project Inventory separately in rev. recognition - Modified Set_Control_Type_Key, Get_Code_String_Values___, Init_Control_Type_Name_Tab___
--  160614  DAYJLK  Bug 127849, Modified Get_Str_Code_Part___() to use the part_no from the transaction if the relevant shop order is missing in the system due to deletion. 
--  160325  Asawlk  Bug 125059, Modified method Reverse_Accounting() by changing cursor get_accounting to exclude events 'INVREVAL+' and 'INVREVAL-' upon selecting postings to reverse.
--  160129  ErFelk  Bug 125682, Modified Do_Accounting___ and Modify_Control_Type_Key_Rec___ to set the PO line information on Control_Type_Key_Rec when event_code = 'ARRCHG-DIR' 
--  160129          and posting_type = 'M189' to enable the retrieval of Purch related information when such control types are being used. 
--  160107  NipKlk  Bug 125434, Modified the procedure Transfer_To_Finance() to execute Transfer_To_Finance__() online when a single user allowed site is used.
--  151228  HiFelk  STRFI-20, Replaced Customer_Info_api.Get_Country_Code with Customer_Info_api.Get_Country_Db
--  151113  LEPESE  LIM-4838, changed LOOP control for control_type_tab_ in method Get_Code_String_Values___.
--  151111  PrYaLK  Bug 125509, Modified Redo_Error_Bookings_Deferred__() by checking whether the components INVENT, MFGSTD and SHPORD are installed
--  151111          so that to execute Redo_Error_Postings___().
--  151103  IsSalk  FINHR-316, Renamed attribute FEE_CODE to TAX_CODE in Customer Order Line.
--  150911  RoJalk  Added cro_no_, cro_exchange_line_no_ to Control_Type_Key, modified Set_Control_Type_Key and included the 
--  150911          handling for source_ref_type_db_COMP_REPAIR_EXCHANGE to support pre posting from CRO exchange Line.
--  150703  BhKalk  RED-517, Modified Send_Posting_To_Pcm___ and Is_Work_Order_Posting___ to support inter site rental transactions posting generation.
--  150629  BhKalk  RED-513, Added a new parameter, accounting_id_ to Is_Work_Order_Posting___().
--  150623  BhKalk  RED-513, Modified Send_Posting_To_Pcm___ and Is_Work_Order_Posting___ to support wo direct rental transactions posting generation. 
--  150608  NaSalk  RED-303, Modifed Get_Project_Cost_Element to add pre_accounting_id parameter.
--  150512  IsSalk  KES-402, Renamed usages of order_no, release_no, sequence_no, line_item_no, order_type attributes of 
--  150512          InventoryTransactionHist to source_ref1, source_ref2, source_ref3, source_ref4, source_ref_type.
--  150608  BhKalk  RED-454, Modified Send_Posting_To_Pcm___.
--  150605  NaSalk  RED-303, Modified Get_Project_Cost_Elements and Send_Posting_To_Pcm___ to support project cost reporting for 
--  150605          work order rentals.
--  150528  BhKalk  RED-282, Introduced the new posting type 'M261' to Is_Work_Order_Posting___ and modified Send_Posting_To_Pcm___ to handle WO rental transactions postings.
--  150825  AyAmlk  Bug 114937, Added public attribute trans_reval_event_id. Added the parameter trans_reval_event_id_ to Do_Accounting() Do_New___() 
--  150825          and Do_Accounting___(), and pass the value accordingly.
--  150826  SWiclk  Bug 122852, Added Init_Control_Type_Value_Tab___(). Modified Get_Code_String_Values___() in order to initialize control_type_value_tab_. 
--  150727  Disklk  Bug 121762, Modified Refresh_Activity_Info___,Transfer_To_Finance___,Redo_Error_Postings___ to pass values to transfer_to_fianance_ and transfer_to_finance_date_.
--  150723  ShKolk  Bug 121289, Modified Get_Code_String___ to return process_code for mandatory code part demand validations.
--  150716  ErFelk  Bug 121019, Restructured the method All_Postings_Transferred() to improve performance.
--  150506  Asawlk  Bug 122377, Modified Check_Insert___ to set the default values for inventory_value_status and date_of_origin correctly.
--  150331  SBalLK  Bug 121394, Modified Is_Code_Part_Value_In_Status() method cursors to use company instead of contract since company stored in the table.
--  150114  JeLise  PRSC-5083, Removed . after :P1 in error message ACCNTFORPOSTTYPE in Get_Project_Cost_Elements.
--  141205  RasDlk  Bug 119926, Modified Accounting_Transfer() by locking the accountings in the cursor level in order to prevent any chance of creating duplicate voucher rows.
--  141124  Asawlk  Bug 119717, Added parameter pre_accounting_id_ to method Get_Project_Cost_Elements() and passed it to Set_Control_Type_Key() in order to set the correct 
--  141124          pre_accounting_id_ for the cost simulation.
--  141107  SBalLK  Bug 119551, Modified Is_Code_Part_Value_In_Status() method by separating the cursor to increase the performance when closing projects.
--  141030  NaLrlk  Added condition compilation check for rentals in method Redo_Error_Bookings_Deferred__().
--  141020  NaSalk  Updated Get_Project_Cost_Elements().
--  140924  Vwloza  Updated Get_Project_Cost_Elements() with new events and posting types.
--  140912  Asawlk  PRSC-1950, Removed the global variable Control_Type_Key_Rec. Replaced its usages with local variables or parameters of same type.
--  140912          Removed obsolete method Clear_Control_Type_Key() and change the Set_Control_Type_Key() to be a function.
--  140804  BudKlk  Bug 118149, Modified the method Redo_Error_Bookings__() by adding a cursor to allow the process of Rerun Erroneous Accountings for all the user allowed sites.
--  140729  Asawlk  PRSC-1949, Removed global variable Codestring_Rec. Replaced its usages with local variables or parameters of same type.
--  140612  LEPESE  PRSC-1449, added ApproveGlobalVariable annotation for global variables Control_Type_Key_Rec and Codestring_Rec.
--  140516  Vwloza  Added 'PUR ORDER CHG ORDER' to RENTAL source ref list in Get_Project_Cost_Elements().
--  140508  NaSalk  Modified Get_Project_Cost_Elements to use new posting types for rentals.
--  140407  ChFolk  Modified Do_New___ to set value TRUE for inverted_currency_rate column when inverted currency rate is used. 
--  140319  UdGnlk  Merged Bug 115678, Modified Do_Accounting___() to consider the existing M7 postings after the upgrade,if a cascade update is running on 184. 
--  140310  MaEdlk  Bug 115613, Modified the method Do_Accounting___() to support distributed preposting for stage payments.
--  140223  SBalLK  Bug 114835, Added Get_Project_Cost_Elements() method to get cost elements for the Distribution Pre Posting. Added Destribution Pre Posting for 'M93' Posting Type by 
--  140232          modifying Do_Accounting___() and modified Get_Project_Cost_Element(), Get_Project_Cost_Elements() methods to aligned with the changes.
--  130920  MAWILK  BLACK-566, Replaced Component_Pcm_SYS.
--  130920  RuLiLk  Bug 112419, Modified method Get_Str_Code_Oecharge__. Moved logic of fetching charge data to ORDER module. 
--  130903  Asawlk  Bug 106401, Modified Get_Project_Cost_Element() by calling Complete_Check_Accounting() to perform the code string completion.
--  130828  NaSalk  Modified Get_Project_Cost_Element to add rental_type_db_ parameter.
--  130822  NaSalk  Modified Do_Accounting___ to consider pre posting for rentals.
--  130325  NaSalk  Modifed Modify_Source_Record___, Refresh_Activity_Info___ and Transfer_To_Finance. Moved code related to determining the function group to
--                  Get_Function_Group___ from Transfer_To_Finance___ and Complete_Check_Accounting. Removed obsolete cosntants inst_OperationHistoryUtil_,
--                  inst_ShopOrderOhHistory_ and inst_CustomerOrderPurOrder_   
--  130213  NaSalk  Modified Unpack_Check_Insert___, Modify_Source_Record___, Redo_Error_Postings___, Transfer_To_Finance___, Refresh_Activity_Info___, 
--                  Redo_Error_Bookings_Deferred__, Transfer_To_Finance__, Complete_Check_Accounting and Transfer_To_Finance. Used MpccomTransactionSource
--                  db constants for existing booking sources. Added logic to new booking source Rental.
--  130826  Asawlk  TIBE-2517, Removed obsolete method End_Booking().
--  130823  Asawlk  TIBE-2517, Removed global PLSQL collection VoucherRow_Rec and defined voucher_row_rec_ inside Accounting_Transfer() and replaced the usage of
--  130823          VoucherRow_Rec with voucher_row_rec_. 
--  130821  Asawlk  TIBE-2515, Removed global PLSQL collection Control_Value_Tab and defined control_value_tab_ inside Get_Code_String___(). Passed it to the methods 
--  130821          where it is needed. 
--  130816  Asawlk  TIBE-2513, Removed global PLSQL collection Control_Type_Tab and defined control_type_tab_ inside Get_Code_String___(). Passed it to the methods 
--  130816          where it is needed. 
--  130815  Asawlk  TIBE-2512, Removed global PLSQL collection Control_Type_Name_Tab and moved the type definition of Control_Type_Name from package specification 
--  130815          to body by making it private. Defined control_type_name_tab_ inside Get_Code_String___() and pased it to relevant methods where it is needed.
--  130812  MaIklk  TIBE-932, Removed global constants and used conditional compilation instead.
--  130729  Asawlk  TIBE-2510, Removed global PLSQL collection Control_Type_Value_Tab and moved the type definition of Control_Type_Value to package body making it
--  130729          private. Defined private PLSQL collection control_type_value_tab_ inside Get_Code_String_Values___() and passed it to methods where its needed.
--  130703  AyAmlk  Bug 111019, Removed Updatable flag of conversion_factor from the MPCCOM_ACCOUNTING view comments.
--  130628  ErFelk  Bug 110763, Restructured the code by adding methods Set_Purch_Order_Line_Ref___, Clear_Purch_Order_Line_Ref___ and Modify_Control_Type_Key_Rec___
--  130628          to handle PODIRSH, PODIRINTEM, DS-DELIVOH, 'IDS-DELOH', PRICEDIFF+ and PRICEDIFF- event codes. Added a condition to check 
--  130628          Control_Type_Key_Rec.oe_order_no_ in Modify_Control_Type_Key_Rec___ so that only PRICEDIFF+/- transactions which has CO references are pass through.    
--  130612  ErFelk  Bug 109671, Added conversion_factor as a new attribute to mpccom_accounting entity. Therefore modified the code accordingly. Also it was added as a 
--  130612          parameter to Do_accounting(),Do_Accounting___() and Do_New___(). Modified Redo_Error_Postings___() by removing currency_code and currency_rate.
--  130612          Made Currency_Code, Currency_Rate and Conversion_Factor public. Therefore Added relevant Get methods. 
--  130516  IsSalk  Bug 106680, Replaced Installed_Component_SYS.<component> with Component_<component>_SYS.<component>.
--  130422  SWiclk  Bug 109617, Modified Reverse_Accounting() by removing the re-calculation of value_ and fetched it from stored data.
--  130130  ChFolk  Modified Get_Str_Code_Rma___ to replace the use of customer_no with return_from_customer_no in rma for fetching delivery related information.
--  130313  Asawlk  CUJO-690, Modified Accounting_Transfer() to pass parallel_amount, parallel_currency_rate and parallel_conversion_factor when creating voucher rows.  
--  130304  Asawlk  CUJO-661, Added three new public attributes parallel_amount, parallel_currency_rate, parallel_conversion_factor to the LU. Added them as
--  130304          parameters to methods Do_New___(), Do_Accounting___() and Do_Accounting(). Also passed values to them when the above methods are being called.
--  121210  Maaylk  PEPA-183, Increased length of voucher_id_ variable
--  121207  MalLlk  Bug 106997, Modified Do_Accounting___() such a way that a specific transaction now can have both debit and credit postings for 
--  121207          one specific Posting Type and Accounting Event.
--  121204  AyAmlk  Bug 106914, Rolled back previous correction done for the bug 106914 in Set_Control_Type_Key() and modified the method to prevent using the
--  121204          pre_accounting_id_ used in the inventory transaction new record when source_ref_type_db_ is 'FIXED ASSET OBJECT'.
--  121122  Raablk  Bug 106914, Modified PROCEDURE Set_Control_Type_Key by adding new parameter event_code_.
--  121005  ChFolk  Modified Get_Str_Code_Rma___ to get country code, ship_via_code and delivery_terms fom RMA when it uses single occurence address.
--  121009  RuLiLk  Bug 105501, Modified method Accounting_Transfer(). Added parameter vendor_no_.
--  120927  Asawlk  Bug 104123, Modified Init_Control_Type_Name_Tab___() by adding control types 'PR6', 'PR8' and 'PR9' which were added from Woodpecker project but
--  120927          have gone missing from support track.
--  120615  ErSrLK  Bug 103394, Modified Transfer_To_Finance___(), redirected the call from Shop_Ord_Transaction_Util_API to Operation_History_Util_API.
--  120615          Also removed unused global LU variable inst_SiteMfgstdInfo_.
--  120410  AyAmlk  Bug 100608, Increased the length of delivery_terms_ in Get_Control_Type_Value_Pur1___(), Get_Control_Type_Value_Pur2___(), 
--  120410          Get_Ctrl_Type_Value_Oeorder___(), Get_Str_Code_Rma___().
--  120326  HaPuLK  Removed unused CONSTANT inst_TimePersDiary_
--  120314  ErSrLK  Replaced the code blocks for manufacturing related booking sources with calls to Shop_Ord_Transaction_Util_API and
--  120314          changed dynamic statements to use conditional compilation in Transfer_To_Finance___().
--  120309  PraWlk  Bug 101612, Modified Get_Str_Code_Labhist___() by concatenating labour class no with contract to avoid erroneous postings 
--  120309          for control type C48. 
--  120228  PraWlk  Bug 101147, Modified Get_Str_Code_Rma___() by concatenating charge type with contract to avoid erroneous postings 
--  120228          for control type C74.
--  110824  ChFolk  Merged HIGHPK-8508. Modified Get_Merged_Cost_Element_Tab___, Get_Activity_Costs_By_Status. Added currency_amount values to project_cost_element_tab_.
--  110721  RoJalk  Modified Get_Project_Cost_Element to find the base code part and raise any errors
--  110721          related to posting control setup if the base code part value is not null.
--  110627  PraWlk  Bug 94552, Modified Complete_Check_Accounting() to fetch the user group correctly.  
--  110526  Asawlk  Bug 94974, Added new parameter to_date_ to Get_Sum_Value_Details() and added new methods
--  110526          Get_Merged_Value_Detail_Tab() and Get_Total_Value(). Removed method Add_Value_Details().
--  110526  PraWlk  Bug 95280, Modified Set_Control_Type_Key() by adding code to check source_ref_type_db_ and assigned a value to pre_accounting_id_.
--  110526          Modified Do_Accounting___() by adding a IF condition to check only pre_accounting_flag_db_ before the separate block 
--  110526          which catches the exception when mandatory pre accounting is missing. And added a check for pre_accounting_id_ and performed 
--  110526          validation of mandatory preposting independent of if the pre-accounting_id is fetched at that time or in an earlier phase.
--  110518  matkse  Corrected merging of LCS patch for bug 95615
--  110517  Cpeilk  Bug 95615, Modified method Transfer_To_Finance___ to commit the transactions after Voucher_End is called. Moved the
--                  call Refresh_Activity_Info___ below in the code, to make sure all the created vouchers have been closed and committed.
--  110514  MaEelk  Added missing assert safe comment to Get_Str_Code_Rebate_Group___
--  110506  ErFelk  Bug 96668, Modified Redo_Reverse_Accounting to call Modify_Source_Record___ if erroneous posting exist. 
--  110506  JoAnSe  Changed check for old_quantity_ = 0 in Reverse_Accounting
--  110428  SudJlk  Bug 96728, Added new method Set_Po_Line_Keys_From_Rma___ and modified Get_Str_Code_Purch___ to fetch PO references to Control_Type_Key_Rec 
--  110428          when event_code is OERET-NC or OERET-SPNC and str_code is M15.
--  110324  PraWlk  Bug 95556, Modified Init_Control_Type_Name_Tab___() by removing the errorneous code which supports control types  
--  110324          'C1', 'C3', 'C4' and 'C25' in an upgraded database.
--  110322  WYRALK  Added method Activity_Postings_Transferred()to check whether all postings for a particular activity seq has been transferred to finance.
--                  Modified Is_Code_Part_Value_In_Status() to handle activity_seq passed in through parameter code_part_.
--  110331  LEPESE  Code cleanup in Transfer_To_Finance___. Added local variable transfer_posting_.
--  111005  DeKoLK  EANE-3742, Moved 'User Allowed Site' in Default Where condition from client.
--  101118  RoJalk  Added the function Get_Sign_Shifted_Cost_Elements.
--  101118  RoJalk  Code improvements to the method Get_Control_Type_Value_Pur1___. 
--  101028  RoJalk  Modified Get_Control_Type_Value_Pur1___, Get_Control_Type_Value_Pur2___, 
--  101028          Get_Control_Type_Value_Pur3___ Set_Control_Type_Key, and Get_Project_Cost_Element
--  101028          to support the source ref type 'PUR ORDER CHG ORDER'.
--  101216  JoAnSe  Initialized date_of_origin to site date instead of date_applied in Unpack_Check_Insert___
--  100914  ErSrLK  Changed Transfer_To_Finance___() to transfer only authorized indirect transactions
--  100914          when the site is configured as 'Authorization Required'.
--  100909  JoAnSe  Implemented posting and transfer to finance for indirect labor time transactions
--                  Renamed Get_Str_Code_Labhist___ to Get_Str_Code_Labor_Class___ and
--                  Get_Str_Code_Machophist___ to Get_Str_Code_Work_Center___ and added support for 
--                  Indirect Labor Transactions in these.
--  100907  JoAnSe  Expanded Control_Type_Name_Tab and added handling for 'PR6', 'PR8' and 'PR9' in
--                  Init_Control_Type_Name_Tab__.
--                  Added get_Str_Code_Indirect_Labor___ and Get_Str_Code_Person___.
--  100723  ErSrLK  Changed Transfer_To_Finance___() to transfer LABOR accountings only if transactions are
--  100723          authorized when the site is configured as 'Authorization Required'.
--  100429  Ajpelk  Merge rose method documentation
--  100630  Nsillk  EAFH-3285 , modified the places where correction type was referred
--  100609  UdGnlk  Modified Is_Work_Order_Posting___() by adding posting types 'M207' and 'M208' for repair on work order functionality.
--  100920  PraWlk  Bug 92965, Modified Get_Str_Code_Oecharge___() by concatenating charge type with contract in order to avoid  
--  100920          erroneous postings for control type C62.
--  100618  GayDLK  Bug 89723, Modified the PROCEDURE Do_Accounting___() to call Inventory_Transaction_Hist_API.Get() instead of 
--  100618          Customer_Order_Pur_Order_API.Get_Purord_For_Custord_Int() to get the Purchase Order information when Customer Order
--  100618          line is cancelled.
--  100429  Ajpelk  Merge rose method documentation
--  100120  Nuvelk  TWIN PEAKS Merge.
--  100308  ErFelk  Bug 87080, Added function Has_Posting_In_Status.
--  100202  SuSalk  Bug 88534, Added new parameter to Get_Str_Code_Purch___ and Get_Control_Type_Value_Pur1___ methods. Modified
--  100202          Get_Control_Type_Value_Pur1___ method to fetch invoiced supplier for the charge line when posting type is M65.
--  091029  RoJalk  Modified Get_Project_Cost_Element and replaced local_bucket_posting_group_id_ with
--  091029          bucket_posting_group_id_ if it is not equal to * to avoid incorrect accounting behavior.
--  091028  RoJalk  Modified Get_Project_Cost_Element and replaced code_part_values_rec_.account_no with NULL if 
--  091028          simulation results * when calling the method Cost_Element_To_Account_API.Get_Project_Follow_Up_Element.
--  090818  RoJalk  Modified Get_Merged_Value_Detail_Tab___ to handle the records with NULL values.
--  090806  RoJalk  Modified Get_Project_Cost_Elements to stop the project cost simulation when zero  
--  090806          (or null) values in merged_value_detail_tab_(i).value.
--  090420  Makrlk  Modified Get_Activity_Costs_By_Status() and Get_Project_Cost_Element() 
--  090420          to use the new interface Get_Project_Follow_Up_Element().
--  090327  Ersruk  Merged product architect LEPESE recommonded changes for Twin Peaks,Balance Sheet by Project.
--  090324  RoJalk  Added the parameter event_code_ to the method Get_Activity_Costs_By_Status. 
--  090224  Ersruk  Added validation on Exclude Project Pre Posting.
--  090129  Kaellk  Modified Get_Merged_Cost_Element_Tab and Get_Merged_Cost_Element_Tab___ to store hours.
         --  090121  Ersruk  Added new function  All_Postings_Transferred_Acc.
--  091217  JENASE  Removed usage of obsolete LU OperationHistoryInt.
--  091217  PraWlk  Bug 87550, Modified Get_Related_Invtrans_Values___() by calling Get_Transaction_Contract() instead of Get_Contract().
--  091211  PraWlk  Bug 87201, Made Check_Date_Applied___() public and modified the logic to raise errors when user is not connected to a 
--  091211          user group or a user group is not connected to a financial period.
--  091210  KAYOLK  Modified the view MPCCOM_ACCOUNTING and the methods Do_New___(), Insert__(), Unpack_Check_Update__(),
--  091210          Update___(), Accounting_Transfer(), Complete_Check_Accounting(), Reverse_Accounting(),
--  091210          Inherit_Code_Parts(), Get_Code_Parts(), Is_Code_Part_Value_In_Status(), and  Redo_Reverse_Accounting()
--  091210          for renaming the code part cost_center, object_no, and project_no as codeno_b, codeno_e and codeno_f respectively.
--  091208  PraWlk  Bug 86988, Modified Get_Code_String___() by adding if condition to check the availability of control type
--  091208          before calling Posting_Ctrl_API.Posting_Type_Exist.
--  091112  PraWlk  Bug 86273, Moved the code of handling control type C4 from method Get_Str_Code_Invtranshist___ to a new method 
--  091112          named Get_Related_Invtrans_Values___ and modified Get_Code_String_Values___ accordingly.
--  091021  KAYOLK  Added Transaction_Statement_Approved Tag for COMMIT, ROLLBACK, and SAVEPOINT statements.
--  091008  HoInlk  Bug 86259, Modified Get_Control_Type_Value_Pur3___ to use purchase requisiton details if available.
--  091008          Modified Set_Control_Type_Key to set values for purchase requsition.
--  091005  ChFolk  Removed un used global constants and veriables.
--  090917  SaWjlk  Bug 85614, Modified the pre accounting logic in the procedure Do_Accounting to adjust the last distributed 
--  090917          posting created so that the total sum of the M92 postings equals the receipt cost.
--  090910  PraWlk  Bug 85741, Modified Get_Code_String___ to specify the code part name Account in the check and 
--  090910          to make the error message more descriptive when a posting type has been removed in posting control.
--  090907  PraWlk  Bug 85741, Modified Get_Code_String___ to include a sufficient error message when a posting type
--  090907          has been removed in posting control.
--  090819  Asawlk  Bug 85234, Modified Get_Project_Cost_Elements() to stop the project cost simulation when zero in 
--  090819          merged_value_detail_tab_(i).value. Also modified Get_Merged_Value_Detail_Tab___() to handle NULL
--  090819          values found in value_detail_tab_(i).value. 
--  ------------------------------------------ 14.0.0 -----------------------------------------
--  090529  SaWjlk  Bug 83173, Removed the prog text duplications.
--  090218  PraWlk  Bug 80291, Modified Do_Accounting___to avoid error created for posting type M19/M20 
--  080117          and control type C30, for PRICEDIFF- and PRICEDIFF+ transactions.
--  081022  NuVelk  Bug 75662, Added method Get_Str_Code_Mtrl_Requis___ and called it from  
--  081022          Get_Code_String_Values___ to fetch string codes for C98, C99.
--  080812  SuSalk  Bug 75557, Added charge_type_,charge_group_,supp_grp_,stat_grp_,assortment_,location_type_ 
--  080812          and location_group_ parameters to Get_Code_String___. Newly added Do_Accounting___ method.
--  080812          Modified Get_Code_String___,Get_Str_Code_Purpart___,Get_Control_Type_Value_Pur1___,
--  080812          Get_Control_Type_Value_Pur2___ and Get_Str_Code_Purcharge___ methods.
--  080714  MaEelk  Bug 74637, Added OUT parameter activity_transferred_ to the Procedure Accounting_Transfer
--  080714          in order to decide if a project activity is transfered or not. Passed FALSE to Voucher_Api.Add_Voucher_Row
--  080714          since project connections are not created at this stage in Transfer process. 
--  080714          Modified Transfer_To_Finance___ to handle new parameters in Accounting_Transfer 
--  080714          and Voucher_Api.Voucher_End.
--  080710  RoJalk  Bug 74811, Removed project_id_ from Set_Control_Type_Key, and passed NULL for transaction_id_, 
--  080710          pre_accounting_id_, activity_seq_. Removed the parameters transaction_id_, pre_accounting_id_, 
--  080710          activity_seq_ and project_id_from Get_Project_Cost_Element and Get_Project_Cost_Elements.
--  080710  MAANLK  Bug 74646, Modified Transfer_To_Finance___ to pass negative quantity for reversed Manufacturing transactons.
--  080624  NiBalk  Bug 74166, Modified Do_Accounting by rounding the amounts to avoid creating incorrect cascade postings.
--  080701  MaHplk  Merged APP75 SP2.
--  ------  ----    ---------APP75 SP2 merge - End-------------------------------------------
--  080528  KaEllk  Bug 74045, Added parameter sales_overhead_ to Get_Project_Cost_Element and Get_Project_Cost_Elements.
--  080508  SuSalk  Bug 73410, Modified Do_Accounting method to avoid duplicated postings 
--  080508          when 0% exists in Distributed Pre-posting.
--  080506  RoJalk  Bug 73185, Modified Get_Str_Code_Invtranshist___ to support handling of location_group.
--  080506  RoJalk  Bug 73185, Added method Refresh_Activity_Info___ and called from Redo_Error_Postings___ and Transfer_To_Finance___.
--  080506          Modified methods Get_Project_Cost_Element, Get_Location_Type_Db___ to support location_type_ and location_group_
--  080506          in project cost handling.
--  080506  HoInlk  Bug 73185, Added methods Get_Merged_Value_Detail_Tab___, Get_Merged_Cost_Element_Tab___,
--  080506          Get_Activity_Costs_By_Status, Get_Project_Cost_Elements, Project_Activity_Posting and Get_Merged_Cost_Element_Tab.
--  080506          Added new parameter cost_source_id_ to Get_Project_Cost_Element.
--  080408  NiBalk  Bug 70198, Modified methods Transfer_To_Finance___ and Update___ by refreshing project activitiy for project  
--  080408          connected transactions. Added new methods Clear_Temporary_Table, Fill_Temporary_Table and Get_From_Temporary_Table.
--  080408          Removed an unwanted call to Operation_History_Util_API.Calculate_Cost_And_Progress in Transfer_To_Finance___.
--  ------  ----    ----------APP75 SP2 merge - Start--------------------------------------------
--  080604  JeLise  Updated Get_Str_Code_Rebate_Group___ to get info for rebate settlements.
--  080313  MaHplk  Merged APP75 SP1
--  --------------------------APP75 SP1 merge - End ---------------------------------------------
--  080117  NiBalk  Bug 70136, Modified Complete_Check_Accounting, to add a dummy text to codesting_rec_.text.
--  080117  NiBalk  Bug 70394, Modified Do_Accounting, to avoid error created for posting type M57 
--  080117          and control type C38, for PODIRSH transactions. 
--  080112  NiBalk  Bug 66733, Rearranged function Get_Total_Abs_Value, to avoid getting Negative Misc Cost.
--  071219  MaEelk  Bug 70098, Increased the length of the variable org_code_ in Get_Str_Code_Woorder___
--  071219          to 16 to fetch the maximum length.
--  071217  NuVelk  Bug 69809, Rearrangd the code of Get_Project_Cost_Element to get the correct cost_element_.
--  071206  NuVelk  Bug 69636, Removed dynamic call Purchase_Order_Line_Part_API.Is_Part in 
--  071206          Do_Accounting and added a new dynamic call Inventory_Part_API.Check_Exist 
--  071206          to make sure posting_type_ M102 is set only for non inventory purchases parts. 
--  071031  RoJalk  Bug 68811, Increased the length to 2000 of source_ in Get_Str_Code_Invtranshist___. 
--  071019  MarSlk  Bug 67178, Modified Get_Str_Code_Part___ to use parent part for PURSHIP and CO-PURSHIP
--  071019          transactions when posting type is M15.
--  071017  MaEelk  Bug 66682, Added Default NULL parameter date_applied_ to the Reverse_Accounting and 
--  071017          date_applied was set to the created postings according to the parameter value. Created
--  071017          Check_Date_Applied___ and called it from Unpack_Check_Insert___ and Unpack_Check_Update___.         
--  --------------------------- APP75 SP1 merge - Start------------------------------------------------
--  080301  RiLase  Added procedure Get_Str_Code_Rebate_Group___ and call to procedure in in Get_Code_String_Values___.
--  *************************** Nice Price ******************************
--  070920  DAYJLK  Added parameters supp_grp_, stat_grp_, and assortment_ to function Get_Project_Cost_Element and set appropriate control type values using the same.
--  070920          Modified methods Get_Str_Code_Purpart___, Get_Control_Type_Value_Pur1___ and Get_Control_Type_Value_Pur2___.
--  070917  ChBalk  Bug 67512, Modified Reverse_Accounting and Redo_Reverse_Accounting by changing status code from 1 to 2.
--  070911  LEPESE  Enhanced the error messages in method Get_Project_Cost_Element.
--  070906  DAYJLK  Modified condition which checks for variable include_charge_ in function Get_Project_Cost_Element.
--  070903  DAYJLK  Added parameter include_charge_ to function Get_Project_Cost_Element.
--  070717  ChBalk  Bug 65941, Modified function Get_Total_Abs_Value, to avoid getting Negative Misc Cost.
--  070717          Rearranged function Get_Total_Abs_Value, to omit the negative values when event code
--  070717          'INVREVAL+' is exist in posting controls for the given transaction. In all the other cases ABS 
--  070717          function will be applied for the total cost. 
--  070710  NuVelk  Bug 65594, Modified Send_Posting_To_Pcm___ to make the call to 
--  070710          Work_Order_Coding_Utility_API.Handle_Inventory_Posting only if the order type is of WORK ORDER. 
--  070704  DAYJLK  Added parameter Error_When_Element_Not_Exist_ to function Get_Project_Cost_Element.
--  070627  DAYJLK  Project Enterprise Merge.
--  070626  WaJalk  Bug 65560, Added parameter date_applied_ to method Redo_Reverse_Accounting
--  070626          and used this when calling Do_New___.
--  070626  WaJalk  Added a condition for zero quantities to make it 1 in method Reverse_Accounting.
--  070605  LEPESE  Modification in method Get_Str_Code_Invtranshist___ to always use transit_location_group
--  070605          as control_type_value for control type 'C83' when posting type is 'M3'.
--  070529  LEPESE  Modification in method Get_Str_Code_Invtranshist___ in order to set 'INT ORDER TRANSIT'
--  070529          as location group for M3 postings on ARRTRAN and OERET-INT.
--  070523  ViGalk  Bug 62275, Modified Get_Str_Code_Part___ to retrieve part_no when source_for_part_no
--                  is from_production_receipt.
--  070405  RaKalk  Modified Transfer_To_Finance___ procedure to fetch transaction from mpccom_transaction_code_api
--  070312  LEPESE  Renamed method Get_Str_Code_Invloc___ to Get_Location_Type_Db___. Moved code
--  070312          for fetching location group from Get_Str_Code_Invloc___ to
--  070312          Get_Str_Code_Invtranshist___. Now location group is always fetched from the
--  070312          inventory transaction history record.
--  070214  ChBalk  Bug 62767, Modified method Do_Accounting to process all pre-accounting lines before raising the error.
--  070213  SuSalk  LCS Merge 62073, Modified Remove_Accounting() to lock the records correctly. Modified
--  070213          Update_Error_Status() by moving some code segments inside the LOOP. Also did
--  070213          some modifications which will improve the performace in both methods.
--  070129  RaKalk  Bug 54532, Added a public method Check_Accounting_Exist().
--  061206  SuSalk  LCS Merge 60902, Modified procedures Get_Code_String_Values___ and Get_Str_Code_Invtranshist___.
--  061024  RaKalk  Added order_type_db_ parameter to Accounting_Transfer procedure. Modified the Transfer_To_Finance___
--  061024          to pass the order_type to the Accounting_Transfer method. Remove the DEFAULT NULL from the date_applied_
--  061024          parameter of the Accounting_Transfer method.
--  061024  RaKalk  Changed the position of methods Get_Str_Code_Purtranshist___, Get_Str_Code_Customergroup___, and Get_Str_Code_Usergroup___
--  061024          To remove the red code in the design tool
--  060921  OsAllk  Bug 59804, Modified Get_Str_Code_Part___ method and restructured code to get the part_no from the correct source.
--  060818  SaRalk  Removed Hint in cursor get_seq in procedure Do_New___.
--  060808  MalLlk  Replaced the date 1/1/1920 and 2/1/0001 with the date of Database_SYS.first_calendar_date_ in
--  060808          Transfer_To_Finance___ and Get_Max_Date_Transferred methods.
--  060713  ChBalk  Removed obsolete public cursor Get_Event_Code
--  060508  GeKalk  Bug 57365, Modified Get_Str_Code_Oeaddress___ to fetch country code using
--  060508          Customer_order_Address_API.Get_Country_Code instead of using Customer_Order_API.Get_Country_Code.
--  060504  UsRalk  Bug 57556, Reversed the previous change and added new logic.
--  060428  ISWILK  Bug 56874, Modified Get_Str_Code_Part___ by adding event codes OOREC, SUNREC and PSRECEIVE.
--  060427  UsRalk  Bug 57556, Modified PROCEDURE Get_Str_Code_Invtranshist___ to use correct contract value to fetch company.
--  060420  IsAnlk  Enlarge supplier - Changed variable definitions.
--  060420  IsAnlk  Enlarge customer - Changed variable definitions.
--  ------------------------- 13.4.0 ----------------------------------------------------------
--  060328  JaJalk  Added Assert safe annotation.
--  060323  JaBalk  Made the call to Operation_History_API.Refresh_Activity_Info in Update___
--  060323          if newrec_.booking_source IN ('OPERATION', 'LABOR').
--  060315  LEPESE  Added functions Error_Posting_Exists_String and Transferred_Posting_Exists_Str.
--  060310  SaJjlk  Changed the length of the sql error message to 2000 in methods Get_Code_String___,
--  060310          Accounting_Transfer, Do_Accounting and Complete_Check_Accounting.
--  060227  IsWilk  Remove the % from the cursor get_all_contracts_ in PROCEDURE Transfer_To_Finance
--  060227          modified the PROCEDURE Validate_Params to handle null values.
--  060223  IsWilk  Modified the cursor get_all_contracts_ in PROCEDURE Transfer_To_Finance to
--  060223          handle all sites.And also modified the PROCEDURE Validate_Params to modify the condition.
--  060223  ChAsLk  Added missing Parenthesis in Transfer_To_Finance___.
--  060216  JoAnSe  Added new paramener event_code_ to Get_Sum_Value_Details.
--  060216          Added Add_Value_Details.
--  060215  JoAnSe  Added condition for TRANSIBAL+/- in cursor in Reverse_Accounting
--  060202  JoEd    Added missing logic for the debit_credit_amount column
--  060202  SeNslk  Replaced column names debit_value, credit_value and debit_credit_value with
--  060202          debit_amount, credit_amount and debit_credit_amount to be consistent with the
--  060202          client field labels.
--  060126  JoEd    Added column debit_credit_value.
--  060120  JaJalk  Added Assert safe annotation.
--  060112  SeNslk  Modified the PROCEDURE Insert___ according to the new template.
--  060105  LEPESE  Added condition on original_accounting_id in method Redo_Reverse_Accounting.
--  051228  RoJalk  Bug 55039, Modified Complete_Check_Accounting and set a default value to
--  051228          codestring_rec_.quantity to prevent the validation failure.
--  051228  JaBalk  Added to_date_ parameter to Get_Sum_Event_And_Type_Value and default null to Get_Sum_Value.
--  051221  ThAylk  Bug 55141, Modified if condition in procedure Get_Str_Code_Part___ by adding
--  051221          event_code 'CO-SOISS'.
--  051221  MAJOSE  Performance work in Transfer_To_Finance___.
--                  General performance work; use PLS_INTEGER instead of BINARY_INTEGER.
--  051219  DiAmlk  Modified the method signature of Send_Posting_To_Pcm___.(Relate to spec AMAD124 - Periodic Adjustment)
--  051122  GEKALK  Modified method Get_Code_String_Values___, Get_Ctrl_Type_Value_Oeorder___
--  051122          and Get_Str_Code_Order___ for the control type C92..
--  051116  LEPESE  Modified method Get_Acc_Value_Not_Included to return a Value_Detail_Tab.
--  051114  JoAnSe  Changed logic for retrieval of connected transaction in Get_Control_Type_Value_Pur1___
--  051114  MAJO    SCAD674: Now Transfer_To_Finance and sub-methods also handles LABOR, OPERATION and
--                  SO GENERAL booking sources. Similar changes in Redo_Error_Postings___.
--                  Introduced SO GENERAL booking source for Shop Order General OH postings.
--  051027  JoAnSe  Added new attributes company and per_oh_adjustment_id
--  051027  DAYJLK  Bug 53604, Added PC-DELIVOH to the list of excluded events in cursor Get_Event_Code.
--  051024  HoInlk  Bug 53584, Removed truncation of date_voucher in cursor in method All_Postings_Transferred.
--  051017  JoAnSe  Added handling of cost_source_id and bucket_posting_group_id to cursor
--                  get_sum_posted in Do_Accounting
--  051017  LEPESE  Added methods Get_Sign_Shifted_Value_Tab and Get_Abs_Value_Detail_Tab.
--  051017  LEPESE  Added method Create_Value_Diff_Tables.
--  051005  JoAnSe  Corrected Get_Sum_Value_Details.
--  050927  JoAnSe  Merged DMC changes below.
--  ******************************  DMC Begin *********************************
--  050919  JoAnSe  Added Get_Sum_Value_Details
--  050824  JoAnSe  Added new attributes bucket_posting_group_id and cost_source_id, also added
--                  these as parameters to Do_Accounting, Do_New___ and Get_Code_String_Values___.
--                  Moved implementation of Get_Code_String to new implementation method.
--  ******************************  DMC Begin *********************************
--  050919  NaLrlk  Removed unused variables.
--  050906  JaBalk  Removed SUBSTRB from the base view.
--  050905  AnLaSe  Added handling of C89.
--  050819  JOHESE  Modified fetch of control type values in Get_Ctrl_Type_Value_Oeorder___
--  050819  AnLaSe  CID126477, changed stmt_ to 2000 in Get_Str_Code_Oediscount___.
--  050810  RoJalk  Bug 52585, Modified Inherit_Code_Parts to handle the situation where record
--  050810          was not found for cursors from_acc and to_acc.
--  050614  reanpl  FIAD376 Actual Costing modifications in Get_Code_String
--  050506  JOHESE  Modified fetch of vat code in Get_Str_Code_Vat___
--  050502  JOHESE  Added methods Get_Str_Code_Countrycode___, Get_Str_Code_Customergroup___, Get_Str_Code_Statecode___ and Get_Str_Code_Usergroup___
--                  to fetch string codes for C85, C86, C87 and C88.
--                  Modified fetch of Payment Terms and Discount Type in Get_Ctrl_Type_Value_Oeorder___ and Get_Str_Code_Oediscount___
--  050421  HaPulk  Modification in OUT parametrs in EXECUTE IMMEDIATE statements.
--  050329  IsWilk  Added the PROCEDURE Validate_Params to validate parameters when executing
--  050329          the Schedule Transfer Inventory Transactions.
--  050208  SaMelk  Declare CONSTANT BOOLEANs for all the LU s and Replaced the Transaction_SYS.Logical_Unit_Is_Installed calls with them.
--  050203  IsAnlk  Modified assignment of outvar_ variable to Control_Type_Value_Tab(83) in Get_Str_Code_Invloc___ .
--  050202  SaMelk  Replaced the Transaction_SYS.Logical_Unit_Is_Installed calls with CONSTANT BOOLEANs.
--  050117  DAYJLK  Bug 48769, Modified Do_Accounting to check mandatory postings of M102 and M108 for Part Order Lines and No Part Order Lines respectively.
--  041222  JOHESE  Modified procedure Update___
--  041213  Samnlk  Rename the method Get_Event_Value to Get_Sum_Event_And_Type_Value.
--  041207  Asawlk  Bug 47855, Modified procedure Reverse_Accounting to stop creating postings with value 0.
--  041203  HaPulk  Removed old interfaces in Financials.
--  041125  IsWilk  Replaced the SYSDATE with Site Date in the PROCEDURE Transfer_To_Finance__.
--  041124  Samnlk  Added new function Get_Event_Value.
--  041122  IsWilk  Removed the PROCEDURE Invent_Transfer_To_Finance__ ,added
--  041122          parameter execution_offset_ PROCEDURE Transfer_To_Finance and modified it
--  041122          to use from the "Scheduled Tasks" client framework.
--  041101  AnHose  Bug 46466, Added attribute userid and function Get_Userid. Added in parameter userid to methods
--  041101          Do_New___ and Do_Accounting and in call to Do_New___.
--  041015  SeJalk  LCS Bug 46940, Modified if condition in procedure Get_Str_Code_Part___.
--  041018  IsWilk  Added the PROCEDURE Invent_Transfer_To_Finance__ and modified Transfer_To_Finance__.
--  040927  MaEelk  Modified Do_Accounting.
--  040818  DhWilk  Inserted the General_SYS.Init_Method to Get_Status_Per_Accounting_Id.
--  040716  SaNalk  Modified Get_Activity_Cost_By_Status.
--  040716  NuFilk  Added Method Check_Credit_Str_Code_Exist.
--  040701  JOHESE  Modified Clear_Control_Type_Key
--  040630  NuFilk  Modified method Transfer_To_Finance___, Added the necessary out parameter for the call Accounting_Transfer.
--  040615  HaPulk  Added date_applied instead of date_voucher in All_Postings_Transferred.
--  040507  IsAnlk  Removed date_voucher from All_Postings_Transferred.
--  040407  JoAnSe  Merged Touch Down changes below.
--  ******************************* Touch Down Merge Begin ************************************
--  040304  JoAnSe  Added code to send Work Order Material postings to PCM in Insert___ and Update___
--  040220  JoEd    Added columns debit_value and credit_value for client presentation only.
--  040209  JoAnSe  Changed Reverse_Accounting to handle creation of new additional postings for
--                  already existing reversal transactions.
--  040202  JoAnSe  Added Get_Committed_Or_Actual_Value
--  040127  JoAnSe  Removed obsolete call to Operation_History_Int_API.Redo_Labor_Error_Booking in
--                  Redo_Error_Bookings_Deferred__
--  040121  JoAnSe  Changed the way credit and reversal postings are created.
--                  Depending on the value of the correction type attribute on Company
--                  reversals will now be created either with a negativa amount or by
--                  swapping the credit/debit flag on the postings created.
--                  Removed obsolete cursor Get_Accounting_Value
--                  Replaced Get_Total_Value with Check_Postings_In_Balance
--  040520  JoAnSe  Added Get_Acc_Value_Not_Included and Set_Acc_Value_Included,
--                  Removed Get_Inventory_Value_Direction
--  040115  JoAnSe  Bug corrections, added Get_Max_Date_Tranferred
--  040107  JoAnSe  Corrected cursor in Redo_Error_Postings___
--  031222  JoAnSe  Added implementation for Redo_Reverse_Accounting
--  031219  JoAnSe  Major Redesign for Inventory Revaluation
--  ******************************* Touch Down Merge End **************************************
--  040317  ThPalk  Bug 43506, Modified the procedures Get_Ctrl_Type_Value_Oeorder___,Get_Str_Code_Oeaddress___.
--  040304  Asawlk  Bug 38485, Assinged the value of accounting_id_ to VoucherRow_Rec.mpccom_accounting_id in procedure Accounting_Transfer.
--  040225  ThPalk  Bug 36308, Added method Get_Activity_Cost_By_Status.
--  040220  JOHESE  Bug 40241, Major redesign of method Accounting_Transfer in order to perform
--                  rollback when Finance returns an error from the voucher row creation process.
--  040202  GeKalk  Rewrote DBMS_SQL using Native dynamic SQL for UNICODE modifications.
--  040126  RaSilk  Bug 40214, Added method Get_Str_Code_Purtranshist___ to handle new control type C84.
--  040127  JeLise  Bug 40240, Added method All_Postings_Transferred.
--  040121  ChBalk  Bug 38752, Modified the PROCEDURE Do_Accounting to include the new transaction code 'PODIRINTEM'.
--  040114  LaBolk  Removed call to public cursor get_distributed_cost in Do_Accounting and used a local cursor instead.
--  040114  LaBolk  Removed public cursor Get_Event_Code_Manuf_Oh.
--  040113  LaBolk  Removed public cursor Get_Accounting_Value.
--  040109  JOHESE  Bug 40873, Added procedure Get_Status_Per_Accounting_Id
--  040102  ChIwlk  Bug 40493, Modified method Do_Accounting to set Control_Type_Key_Rec.pre_accounting_id_ to NULL for event PODIRSH,
--  040102          to prevent overruling of M10 and M24 postings incorrectly.
--  ------------------------------------ 13.3.0 ---------------------------------------------------------------
--  031105  DAYJLK  Merged Bug 40050, Modified the procedures Get_Ctrl_Type_Value_Oeorder___,Get_Str_Code_Order___,Get_Code_String_Values and added the
--  031105          procedure Get_Str_Code_Oeaddress___ to fetch the country,region,district, ship via and the delivery terms from the order line.
--  031030  BhRalk  Modified the method Get_Control_Type_Value_Pur2___ by adding the variable line_exist_.
--  031030  SeKalk  Changed Get_Control_Type_Value_Pur2___  to include the line ship via and line del terms
--  031016  MaGulk  Merged Bug 39247, Added function Is_Code_Part_Value_In_Status.
--  031013  PrJalk  Bug Fix 106224, Added missing and changed wrong General_Sys.Init_Method calls.
--  030918  JaBalk  Bug 38380, Added Get_contract method and not null contract column.Remove Get_Accounting_Contract___
--  030918          from Accounting_Transfer, Complete_Check_Acc_Batch, and removed contract_,contract_trans_ variables
--  030918          Added contract_ parameter to Do_New_ method.
--  030917  KiSalk  Call 103427-In Get_Control_Type_Value_Pur1___, changed invtrans_rec_.consignment_vendor_no to invtrans_rec_.owning_vendor_no
--  030917          and call to Inventory_Transaction_Hist_API.Get_Consignment_Vendor_No to Get_Owning_Vendor_No of same API.
--  030916  SaRalk  Bug 38744, Modified procedure Complete_Check_Accounting by updating codestring_rec_
--  030916          with relevant values for function group.
--  030911  ThPalk  Bug 38133, Modified function call Accounting_Codestr_API.Validate_Codestring_ to
--  030911          Accounting_Codestr_API.Validate_Codestring_Mpccom in the procedure Complete_Check_Accounting.
--  030911  ChJalk  Bug 37627, Modified cursor get_accounting and the assignment to VoucherRow_Rec.trans_code in Procedure Accounting_Transfer.
--  030910  ThPalk  Bug 37335, Removed the code that was used to update the attribute DATE_VOUCHER in method Accounting_Transfer
--  030801  KiSalk  SP4 Merge.
--  030616  JOHESE  Added fa_object_id_ and company_ to procedure Clear_Control_Type_Key
--  030514  LEPESE  Bug 33933, Additional code in method Get_Control_Type_Value_Pur1___ to
--                  fetch vendor_no from InventoryTransactionHist.
--  030508  JeLise  Bug 35121, Removed Norwegian Investment Tax.
--  030506  JaBalk  Bug 37131, Reverse the bug 35745.
--  030221  NaWilk  Bug 33568, Remove earlier correction done on bug 33568.
--  030214  MaGulk  Bug 35745, Modified Do_Accounting to enable vouchers to be created and transferred
--                  when inventory transaction value is zero.
--  030211  NaWilk  Bug 33568, Modified function call Accounting_Codestr_API.Validate_Codestring_ to
--                  Accounting_Codestr_API.Validate_Codestring_Mpccom in the procedure Complete_Check_Accounting.
--  021025  LEPESE  Bug 32465, Redesign of method Get_Str_Code_Invloc___ in order to fetch
--                  location_type from the inventory_transaction_hist record when no
--                  location_no is available in the control_type_key_rec record.
--  020923  ANLASE  **************** IceAge Merge Start *********************
--  020620  OlNiSe  Bug# 31396 corrected, Handle distributed pre-accounting for non-inventory parts when
--                  registering transactions in Mpccom_Accounting_TAB.
--  ******************************** IceAge Merge End ***********************
--  040325  ThJaLk  Bug fix 27403, Modified dynamic sql code in Procedure Get_Ctrl_Type_Value_Oeorder
--                  to fetch ship via code from co lines.
--  020301  LEPESE  Added calls to Purchase_Transaction_Hist_API in methods Modify_Source_Record___,
--                  Get_Accounting_Contract___ and Redo_Error_Bookings_Deferred__.
--                  Modified fetch of accounting_contract in method Accounting_Transfer.
--  020215  LEPESE  Added functionality for new control type C83 (Inventory Location Group) to
--                  methods Get_Str_Code_Invloc___ and Get_Code_String_Values___.
--  020207  JOHESE  Added Norwegian Investment Fee code
--  020121  LePeSe  Method Get_Code_String redesigned to make use of new accrul interface methods.
--                  Major cleanup of Trace_SYS.Message and General_SYS.Init_Method usage
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE Accounting_Id_Tab IS TABLE OF MPCCOM_ACCOUNTING_TAB.accounting_id%TYPE
   INDEX BY PLS_INTEGER;

TYPE Control_Type_Key IS RECORD
        (part_no_              VARCHAR2(25),
         contract_             VARCHAR2(5),
         transaction_id_       NUMBER,
         pre_accounting_id_    NUMBER,
         event_code_           VARCHAR2(10),
         oe_invoice_id_        NUMBER,
         oe_invoice_item_id_   NUMBER,
         oe_order_no_          VARCHAR2(12),
         oe_line_no_           VARCHAR2(4),
         oe_rel_no_            VARCHAR2(4),
         oe_line_item_no_      NUMBER,
         oe_charge_seq_no_     NUMBER,
         oe_discount_type_     VARCHAR2(25),
         oe_discount_no_       NUMBER,
         oe_rma_no_            NUMBER,
         oe_rma_line_no_       NUMBER,
         oe_rma_charge_no_     NUMBER,
         tax_code_             VARCHAR2(20),
         catalog_no_           VARCHAR2(25),
         pur_order_no_         VARCHAR2(12),
         pur_line_no_          VARCHAR2(4),
         pur_release_no_       VARCHAR2(4),
         pur_charge_seq_no_    NUMBER,
         so_order_no_          VARCHAR2(12),
         so_release_no_        VARCHAR2(4),
         so_sequence_no_       VARCHAR2(4),
         so_line_item_no_      NUMBER,
         wo_work_order_no_     VARCHAR2(50),
         wo_task_seq_          VARCHAR2(50),
         wo_mtrl_order_no_     VARCHAR2(12),
         wo_line_item_no_      NUMBER,
         int_order_no_         VARCHAR2(12),
         int_line_no_          VARCHAR2(4),
         int_release_no_       VARCHAR2(4),
         int_line_item_no_     NUMBER,
         ps_order_no_          VARCHAR2(12),
         ps_release_no_        VARCHAR2(4),
         ps_sequence_no_       VARCHAR2(4),
         ps_line_item_no_      NUMBER,
         prj_project_id_       VARCHAR2(10),
         prj_activity_seq_     NUMBER,
         project_mtrl_seq_no_  NUMBER,
         pur_req_no_           VARCHAR2(12),
         pur_req_line_no_      VARCHAR2(4),
         pur_req_rel_no_       VARCHAR2(4),
         fa_object_id_         VARCHAR2(10),
         company_              VARCHAR2(20),
         activity_seq_         NUMBER,
         chg_pur_order_no_     VARCHAR2(12),
         chg_order_no_         VARCHAR2(4),
         chg_line_no_          VARCHAR2(4),
         chg_release_no_       VARCHAR2(4),
         cro_no_               VARCHAR2(25),
         cro_exchange_line_no_ NUMBER,
         reb_aggr_posting_id_  NUMBER,
         prjdel_item_no_       NUMBER,
         prjdel_item_revision_ VARCHAR2(10),
         prjdel_planning_no_   NUMBER,
         wt_task_seq_          NUMBER,
         wt_mtrl_order_no_     NUMBER,
         wt_line_item_no_      NUMBER);

TYPE Value_Detail_Rec IS RECORD (
      bucket_posting_group_id mpccom_accounting_tab.bucket_posting_group_id%TYPE,
      cost_source_id          mpccom_accounting_tab.cost_source_id%TYPE,
      value                   mpccom_accounting_tab.value%TYPE);

TYPE Value_Detail_Tab IS TABLE OF Value_Detail_Rec
      INDEX BY PLS_INTEGER;

TYPE Project_Cost_Element_Rec IS RECORD (
      project_cost_element    VARCHAR2(100),
      amount                  NUMBER,
      currency_amount         NUMBER,
	  hours                   NUMBER);

TYPE Project_Cost_Element_Tab IS TABLE OF Project_Cost_Element_Rec
      INDEX BY PLS_INTEGER;

TYPE Curr_Amount_Detail_Rec IS RECORD (
      currency_code           mpccom_accounting_tab.currency_code%TYPE,
      currency_rate           mpccom_accounting_tab.currency_rate%TYPE,
      conversion_factor       mpccom_accounting_tab.conversion_factor%TYPE,
      inverted_currency_rate  mpccom_accounting_tab.inverted_currency_rate%TYPE,
      curr_amount             mpccom_accounting_tab.curr_amount%TYPE,
      value                   mpccom_accounting_tab.value%TYPE);

TYPE Curr_Amount_Detail_Tab IS TABLE OF Curr_Amount_Detail_Rec
      INDEX BY PLS_INTEGER;
      
TYPE Control_Type_Value IS TABLE OF VARCHAR2(50)
     INDEX BY PLS_INTEGER;      

TYPE Curr_Amount_Posting_Rec IS RECORD (
      currency_code            mpccom_accounting_tab.currency_code%TYPE,
      curr_amount              mpccom_accounting_tab.curr_amount%TYPE,
      conversion_factor        mpccom_accounting_tab.conversion_factor%TYPE,
      bucket_posting_group_id  mpccom_accounting_tab.bucket_posting_group_id%TYPE,
      event_code               mpccom_accounting_tab.event_code%TYPE);

TYPE Curr_Amount_Posting_Tab IS TABLE OF Curr_Amount_Posting_Rec
      INDEX BY PLS_INTEGER;
-------------------- PRIVATE DECLARATIONS -----------------------------------

TYPE Control_Type_Name IS TABLE OF VARCHAR2(10)
     INDEX BY PLS_INTEGER;


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Do_New___
--   Create a new posting
--   Do new accounting
PROCEDURE Do_New___ (
   default_seq_                IN NUMBER,
   company_                    IN VARCHAR2,
   accounting_id_              IN NUMBER,
   account_no_in_              IN VARCHAR2,
   codeno_b_                   IN VARCHAR2,
   codeno_c_                   IN VARCHAR2,
   codeno_d_                   IN VARCHAR2,
   codeno_e_                   IN VARCHAR2,
   codeno_f_                   IN VARCHAR2,
   codeno_g_                   IN VARCHAR2,
   codeno_h_                   IN VARCHAR2,
   codeno_i_                   IN VARCHAR2,
   codeno_j_                   IN VARCHAR2,   
   event_code_                 IN VARCHAR2,
   str_code_in_                IN VARCHAR2,
   debit_credit_               IN VARCHAR2,
   value_in_                   IN NUMBER,
   booking_source_             IN VARCHAR2,
   currency_code_              IN VARCHAR2,
   currency_rate_              IN NUMBER,
   curr_amount_                IN NUMBER,
   date_applied_               IN DATE,
   error_desc_                 IN VARCHAR2,
   status_code_                IN VARCHAR2,
   activity_seq_               IN NUMBER,
   contract_                   IN VARCHAR2,
   userid_                     IN VARCHAR2,
   date_of_origin_             IN DATE,
   inventory_value_status_db_  IN VARCHAR2,
   original_accounting_id_     IN NUMBER,
   original_seq_               IN NUMBER,
   cost_source_id_             IN VARCHAR2,
   bucket_posting_group_id_    IN VARCHAR2,
   per_oh_adjustment_id_       IN NUMBER,
   conversion_factor_          IN NUMBER,
   parallel_amount_            IN NUMBER,
   parallel_currency_rate_     IN NUMBER,
   parallel_conversion_factor_ IN NUMBER,
   trans_reval_event_id_       IN NUMBER )
IS
   seq_                     NUMBER;
   newrec_                  mpccom_accounting_tab%ROWTYPE;
   voucher_type_            mpccom_accounting_tab.voucher_type%TYPE;
   voucher_no_              mpccom_accounting_tab.voucher_no%TYPE;
   account_no_              mpccom_accounting_tab.account_no%TYPE;
   str_code_                mpccom_accounting_tab.str_code%TYPE;
   value_                   mpccom_accounting_tab.value%TYPE;
   curr_amount_round_       mpccom_accounting_tab.curr_amount%TYPE;
   company_fin_rec_         Company_Finance_API.Public_Rec;
   parallel_amount_rounded_ mpccom_accounting_tab.parallel_amount%TYPE;
   base_curr_rec_           Currency_Code_API.Public_Rec;
   
   CURSOR get_seq IS
      SELECT seq+1
      FROM mpccom_accounting_tab
      WHERE accounting_id = accounting_id_
      ORDER BY accounting_id DESC, seq DESC;
BEGIN
   Trace_SYS.Message('TRACE=> accounting 1');
   IF (default_seq_ IS NOT NULL) THEN
      seq_ := default_seq_;
   ELSE
      OPEN  get_seq;
      FETCH get_seq INTO seq_;
      IF get_seq%NOTFOUND THEN
         seq_ := 1;
      END IF;
      CLOSE get_seq;
   END IF;
   IF (account_no_in_ IS NULL) THEN
      account_no_ := '*';
   ELSE
      account_no_ := account_no_in_;
   END IF;
   IF (str_code_in_ IS NULL) THEN
      str_code_ := '*';
   ELSE
      str_code_ := str_code_in_;
   END IF;
   
   company_fin_rec_         := Company_Finance_API.Get(company_);
   base_curr_rec_           := Currency_Code_API.Get(company_, company_fin_rec_.currency_code);   
   value_                   := round(value_in_, base_curr_rec_.currency_rounding);
   curr_amount_round_       := round(curr_amount_, Currency_Code_API.Get_Currency_Rounding(company_, currency_code_));   
   parallel_amount_rounded_ := ROUND(parallel_amount_, Currency_Code_API.Get_Currency_Rounding(company_, company_fin_rec_.parallel_acc_currency));
   
   Trace_SYS.Message('TRACE=> 1 ' || to_char(accounting_id_));
   Trace_SYS.Message('TRACE=> 2 ' || to_char(seq_));
   Trace_SYS.Message('TRACE=> 3 ' || str_code_);
   Trace_SYS.Message('TRACE=> 3 ' || event_code_);
   Trace_SYS.Message('TRACE=> 4 ' || debit_credit_);
   Trace_SYS.Message('TRACE=> 5 ' || to_char(value_));
   Trace_SYS.Message('TRACE=> 6 ' || status_code_);

   newrec_.accounting_id              := accounting_id_;
   newrec_.seq                        := seq_;
   newrec_.company                    := company_;
   newrec_.account_no                 := account_no_;
   newrec_.codeno_b                   := codeno_b_;
   newrec_.codeno_c                   := codeno_c_;
   newrec_.codeno_d                   := codeno_d_;
   newrec_.codeno_e                   := codeno_e_;
   newrec_.codeno_f                   := codeno_f_;
   newrec_.codeno_g                   := codeno_g_;
   newrec_.codeno_h                   := codeno_h_;
   newrec_.codeno_i                   := codeno_i_;
   newrec_.codeno_j                   := codeno_j_;
   newrec_.str_code                   := str_code_;
   newrec_.activity_seq               := activity_seq_;
   newrec_.event_code                 := event_code_;
   newrec_.voucher_no                 := voucher_no_;
   newrec_.voucher_type               := voucher_type_;
   newrec_.currency_code              := currency_code_;
   newrec_.status_code                := status_code_;
   newrec_.booking_source             := booking_source_;
   newrec_.curr_amount                := curr_amount_round_;
   newrec_.currency_rate              := currency_rate_;
   newrec_.conversion_factor          := conversion_factor_;
   newrec_.date_applied               := date_applied_;
   newrec_.debit_credit               := debit_credit_;
   newrec_.error_desc                 := error_desc_;
   newrec_.value                      := value_;
   newrec_.contract                   := contract_;
   newrec_.userid                     := userid_;
   newrec_.date_of_origin             := date_of_origin_;
   newrec_.inventory_value_status     := inventory_value_status_db_;
   newrec_.original_accounting_id     := original_accounting_id_;
   newrec_.original_seq               := original_seq_;
   newrec_.cost_source_id             := cost_source_id_;
   newrec_.bucket_posting_group_id    := bucket_posting_group_id_;
   newrec_.per_oh_adjustment_id       := per_oh_adjustment_id_;
   newrec_.parallel_amount            := parallel_amount_rounded_;
   newrec_.parallel_currency_rate     := parallel_currency_rate_;   
   newrec_.parallel_conversion_factor := parallel_conversion_factor_;
   newrec_.inverted_currency_rate     := base_curr_rec_.inverted;
   newrec_.trans_reval_event_id       := trans_reval_event_id_;
   
   New___(newrec_);

   Trace_SYS.Message('TRACE=> accounting 2');
END Do_New___;

PROCEDURE Get_Code_String___ (
   account_err_desc_        OUT    VARCHAR2,
   account_err_status_      OUT    VARCHAR2,
   codestring_rec_          OUT    Accounting_Codestr_API.CodestrRec,
   control_type_key_rec_    IN     Mpccom_Accounting_API.Control_Type_Key,
   company_                 IN     VARCHAR2,
   str_code_                IN     VARCHAR2,
   accounting_date_         IN     DATE,
   cost_source_id_          IN     VARCHAR2,
   bucket_posting_group_id_ IN     VARCHAR2,
   charge_type_             IN     VARCHAR2,
   charge_group_            IN     VARCHAR2,
   supp_grp_                IN     VARCHAR2,
   stat_grp_                IN     VARCHAR2,  
   assortment_              IN     VARCHAR2,
   location_type_           IN     VARCHAR2,
   location_group_          IN     VARCHAR2,
   condition_code_          IN     VARCHAR2 )
IS
   control_type_value_table_  Posting_Ctrl_Public_API.control_type_value_table;
   code_string_               Accounting_Codestr_API.Codestrrec;
   ac_error                   EXCEPTION;
   ac_error2                  EXCEPTION;
   PRAGMA                     EXCEPTION_INIT(ac_error,-20105);
   PRAGMA                     EXCEPTION_INIT(ac_error2,-20110);   
BEGIN
   Get_Control_Type_Values___(control_type_value_table_,
                              str_code_,
                              company_,
                              accounting_date_,
                              control_type_key_rec_,
                              cost_source_id_,
                              bucket_posting_group_id_,
                              supp_grp_,
                              stat_grp_,
                              location_type_,
                              charge_type_,
                              charge_group_,
                              assortment_,
                              location_group_,
                              condition_code_);
   -------------------------------------------------------------------
   --  We have retrieved the values for all the control types       --
   --  that are in use for this specific posting_type and company.  --
   --  Now we can ask ACCRUL to translate the control type values   --
   --  into code part values, and thereby create the actual code    --
   --  string. This method returns the code_string.                 --
   -------------------------------------------------------------------
   Posting_Ctrl_Public_API.Build_Codestring_Rec(code_string_,
                                                control_type_value_table_,
                                                accounting_date_,
                                                str_code_,
                                                company_);

   --------------------------------------------------------
   --  Copy the code part values from the local record   --
   --  code_string_to the record codestring_rec_.        --
   --------------------------------------------------------
   codestring_rec_.code_a       := code_string_.code_a;
   codestring_rec_.code_b       := code_string_.code_b;
   codestring_rec_.code_c       := code_string_.code_c;
   codestring_rec_.code_d       := code_string_.code_d;
   codestring_rec_.code_e       := code_string_.code_e;
   codestring_rec_.code_f       := code_string_.code_f;
   codestring_rec_.code_g       := code_string_.code_g;
   codestring_rec_.code_h       := code_string_.code_h;
   codestring_rec_.code_i       := code_string_.code_i;
   codestring_rec_.code_j       := code_string_.code_j;
   codestring_rec_.process_code := code_string_.process_code;

   account_err_desc_   := NULL;
   account_err_status_ := '1';
EXCEPTION
   WHEN ac_error OR ac_error2 THEN
      Trace_SYS.Message('TRACE=> Get_Code_String___ (ac-error BEGIN)');
      account_err_desc_ := SUBSTR(sqlerrm,Instr(sqlerrm,':', 1, 2)+2,2000);
      account_err_status_ := '99';
      Trace_SYS.Message('TRACE=>'||SUBSTR(sqlerrm,Instr(sqlerrm,':')+2,2000));
      Trace_SYS.Message('TRACE=> Get_Code_String___ (ac-error END)');
END Get_Code_String___;

PROCEDURE Get_Control_Type_Values___ (
   control_type_value_table_ OUT    Posting_Ctrl_Public_API.control_type_value_table,
   str_code_                 IN     VARCHAR2,
   company_                  IN     VARCHAR2,
   accounting_date_          IN     DATE,
   control_type_key_rec_     IN     Mpccom_Accounting_API.Control_Type_Key,
   cost_source_id_           IN     VARCHAR2,
   bucket_posting_group_id_  IN     VARCHAR2,
   supp_grp_                 IN     VARCHAR2,
   stat_grp_                 IN     VARCHAR2,
   location_type_            IN     VARCHAR2,
   charge_type_              IN     VARCHAR2,
   charge_group_             IN     VARCHAR2,
   assortment_               IN     VARCHAR2,
   location_group_           IN     VARCHAR2,
   condition_code_           IN     VARCHAR2 )
IS
   control_type_name_tab_     Control_Type_Name;
   j_                         VARCHAR2(20);
   count_ct_                  PLS_INTEGER := 1;
   control_type_tab_          Posting_Ctrl_API.CtrlTypTab;
   control_value_tab_         Posting_Ctrl_API.CtrlValTab;
   
BEGIN
   Validate_Str_Code___(str_code_,
                        company_);  
   
   ---------------------------------------------------------------
   --  Loads the name of all control types (C1 - C99) into the  --
   --  table control_type_name_tab_ for later use in            --
   --  method Get_Code_String_Values___.                        --
   ---------------------------------------------------------------   
   Init_Control_Type_Name_Tab___(control_type_name_tab_);
   
   ------------------------------------------------------------------
   --  Ask ACCRUL to tell us which control types that are in use   --
   --  for this specific posting_type at this company. The result  --
   --  is returned in the PL-table control_type_value_table_       --
   --  PL-table is indexed by string - control_type                --
   ------------------------------------------------------------------
   
   Posting_Ctrl_Public_API.Get_Control_Type(control_type_value_table_,
                                            str_code_,
                                            company_,
                                            accounting_date_);
   ---------------------------------------------------------
   --  Move the list of control_types that we received    --
   --  from ACCRUL to the table control_type_tab_.        --
   ---------------------------------------------------------
   j_ := control_type_value_table_.FIRST;
   count_ct_ := 0;
   WHILE j_ IS NOT NULL LOOP
      count_ct_ := count_ct_ + 1;
      control_type_tab_(count_ct_) := control_type_value_table_(j_);
      j_ := control_type_value_table_.NEXT(j_);
   END LOOP;
   
   --------------------------------------------------------------
   --  Find the correct values to return to ACCRUL for each    --
   --  control_type specified in the PL-table                  --
   --  control_type_name_tab_. The values are put into another --
   --  PL-table control_value_tab_.                            --
   --------------------------------------------------------------
   Get_Code_String_Values___(control_value_tab_,
                             control_type_key_rec_,
                             company_,
                             str_code_,
                             cost_source_id_,
                             bucket_posting_group_id_,
                             control_type_name_tab_,
                             control_type_tab_);
   
   -----------------------------------------------------------------------
   --  Now the control type values are stored in the                    --
   --  PL-table control_value_tab_. We must copy those values            --
   --  to the table control_type_value_table_ (indexed by control_type) --
   -----------------------------------------------------------------------   
   FOR i_ IN 1..count_ct_ LOOP
      j_ := control_type_tab_(i_);
      control_type_value_table_(j_) := 
      CASE j_ 
         WHEN control_type_name_tab_(30) THEN NVL(supp_grp_,       control_value_tab_(i_))
         WHEN control_type_name_tab_(31) THEN NVL(stat_grp_,       control_value_tab_(i_))
         WHEN control_type_name_tab_(46) THEN NVL(location_type_,  control_value_tab_(i_))
         WHEN control_type_name_tab_(60) THEN NVL(charge_type_,    control_value_tab_(i_))
         WHEN control_type_name_tab_(61) THEN NVL(charge_group_,   control_value_tab_(i_))
         WHEN control_type_name_tab_(82) THEN NVL(assortment_,     control_value_tab_(i_))
         WHEN control_type_name_tab_(83) THEN NVL(location_group_, control_value_tab_(i_))
         WHEN control_type_name_tab_(89) THEN NVL(condition_code_, control_value_tab_(i_))
         ELSE control_value_tab_(i_)
      END;
   END LOOP;
END Get_Control_Type_Values___;

PROCEDURE Validate_Str_Code___ (
   str_code_ IN VARCHAR2,
   company_  IN VARCHAR2 )
IS
   code_part_name_            VARCHAR2(20);
   
BEGIN
   IF (Posting_Ctrl_Allowed_Comb_API.Any_Posting_Type_Exist(str_code_) = 'TRUE') THEN
      IF NOT (Posting_Ctrl_API.Posting_Type_Exist(company_, 'A', str_code_)) THEN
         code_part_name_ := Accounting_Code_Parts_API.Get_Name(company_, 'A');
         Error_SYS.Appl_General(lu_name_, 'NOPOSTINGTYPE: Posting type :P1 is missing in Posting Control for company :P2 and code part :P3.', str_code_, company_, code_part_name_);
      END IF;
   END IF;
END Validate_Str_Code___;



-- Get_Code_String_Values___
--   Gets code string values.
PROCEDURE Get_Code_String_Values___ (
   control_value_tab_       IN OUT Posting_Ctrl_API.CtrlValTab,
   control_type_key_rec_    IN     Mpccom_Accounting_API.Control_Type_Key,
   company_                 IN     VARCHAR2,
   str_code_                IN     VARCHAR2,
   cost_source_id_          IN     VARCHAR2,
   bucket_posting_group_id_ IN     VARCHAR2,
   control_type_name_tab_   IN     Control_Type_Name,
   control_type_tab_        IN     Posting_Ctrl_API.CtrlTypTab)
IS
   part_fetched_               BOOLEAN := FALSE;
   component_part_fetched_     BOOLEAN := FALSE;
   oeorder_fetched_            BOOLEAN := FALSE;
   oesales_fetched_            BOOLEAN := FALSE;
   oediscount_fetched_         BOOLEAN := FALSE;
   oecharge_fetched_           BOOLEAN := FALSE;
   vat_fetched_                BOOLEAN := FALSE;
   rma_fetched_                BOOLEAN := FALSE;
   pur_fetched_                BOOLEAN := FALSE;
   purpart_fetched_            BOOLEAN := FALSE;
   purcharge_fetched_          BOOLEAN := FALSE;
   invtrans_fetched_           BOOLEAN := FALSE;
   location_type_fetched_      BOOLEAN := FALSE;
   opt_fetched_                BOOLEAN := FALSE;
   lab_fetched_                BOOLEAN := FALSE;
   work_task_fetched_          BOOLEAN := FALSE;
   dop_fetched_                BOOLEAN := FALSE;
   countrycode_fetched_        BOOLEAN := FALSE;
   usergroup_fetched_          BOOLEAN := FALSE;
   statecode_fetched_          BOOLEAN := FALSE;
   customergroup_fetched_      BOOLEAN := FALSE;
   oeaddress_fetched_          BOOLEAN := FALSE;
   purtrans_fetched_           BOOLEAN := FALSE;
   rebate_group_fetched_       BOOLEAN := FALSE;
   mtrl_req_fetched_           BOOLEAN := FALSE;
   related_invtrans_fetched_   BOOLEAN := FALSE;
   indirect_labor_fetched_     BOOLEAN := FALSE;
   person_fetched_             BOOLEAN := FALSE;
   fsmtrans_fetched_           BOOLEAN := FALSE;
   busines_trans_code_fetched_ BOOLEAN := FALSE;
   control_type_value_tab_     Control_Type_Value;   
   local_control_type_key_rec_ Mpccom_Accounting_API.Control_Type_Key := control_type_key_rec_;
BEGIN
   -- Note: control_type_value_tab_ must be initialized before executing further logic in order to avoid no_data_found exception 
   --       because there will be situations where values of control_type_value_tab_ be accessed (e.g: Get_Str_Code_Invtranshist___()).  
   Init_Control_Type_Value_Tab___ (control_type_value_tab_);

   IF (control_type_tab_.COUNT > 0) THEN
      FOR i IN control_type_tab_.FIRST..control_type_tab_.LAST LOOP
   -- Constant Value
         IF (control_type_tab_(i) = control_type_name_tab_(1)) THEN
            control_value_tab_(i) := '*';
   -- Given Value
         ELSIF (control_type_tab_(i) = control_type_name_tab_(2)) THEN
            control_value_tab_(i) := '*';
   -- Contract
         ELSIF (control_type_tab_(i) = control_type_name_tab_(5)) THEN
               control_value_tab_(i) := local_control_type_key_rec_.contract_;
   -- Inventory Parts         
         ELSIF (control_type_tab_(i) = control_type_name_tab_(112)) THEN
            IF (local_control_type_key_rec_.part_no_ IS NOT NULL AND (nvl(local_control_type_key_rec_.activity_seq_, 0) != 0)) THEN
               control_value_tab_(i) := 'CONNECTED';
            ELSE
               control_value_tab_(i) := 'NOTCONNECTED';    
            END IF;
   -- Part Values
         ELSIF (control_type_tab_(i) IN
            (control_type_name_tab_(6),
             control_type_name_tab_(7),
             control_type_name_tab_(8),
             control_type_name_tab_(9),
             control_type_name_tab_(10),
             control_type_name_tab_(11),
             control_type_name_tab_(12),
             control_type_name_tab_(32),
             control_type_name_tab_(49),
             control_type_name_tab_(50),
             control_type_name_tab_(113),  -- 113, 114 and 115 added to support upgrading from Polish localization follow_up_mat_prod_cost
             control_type_name_tab_(114),
             control_type_name_tab_(115))) THEN

            Get_Str_Code_Part___(part_fetched_, control_type_value_tab_, control_value_tab_, local_control_type_key_rec_, i, str_code_, control_type_name_tab_, control_type_tab_);
   -- Component Part Values
         ELSIF (control_type_tab_(i) IN
            (control_type_name_tab_(118),
             control_type_name_tab_(119),
             control_type_name_tab_(120),
             control_type_name_tab_(121),
             control_type_name_tab_(122),
             control_type_name_tab_(123),
             control_type_name_tab_(124),
             control_type_name_tab_(125),
             control_type_name_tab_(126))) THEN

            Get_Str_Code_Component_Part___(component_part_fetched_, control_type_value_tab_, control_value_tab_, local_control_type_key_rec_, i, control_type_name_tab_, control_type_tab_);
   -- Oeorder values
         ELSIF (control_type_tab_(i) IN
            (control_type_name_tab_(13),
             control_type_name_tab_(14),
             control_type_name_tab_(16),
             control_type_name_tab_(19),
             control_type_name_tab_(20),
             control_type_name_tab_(21),
             control_type_name_tab_(22),
             control_type_name_tab_(23),
             control_type_name_tab_(24),
             control_type_name_tab_(26),
             control_type_name_tab_(27),
             control_type_name_tab_(28),
             control_type_name_tab_(29),
             control_type_name_tab_(92),
             control_type_name_tab_(116))) THEN
               -- IF this is a call from RMA, no order keys are known yet. Find them from the RMA keys.
            IF (local_control_type_key_rec_.oe_order_no_ IS NULL AND local_control_type_key_rec_.oe_rma_no_ IS NOT NULL) AND (NOT oeorder_fetched_) THEN         
                  -- Call this method only if the order_keys aren't initiated and the rma keys are initiated.
                  Prepare_Rma_Order_Keys___ (local_control_type_key_rec_.oe_order_no_,
                                             local_control_type_key_rec_.oe_line_no_,
                                             local_control_type_key_rec_.oe_rel_no_,
                                             local_control_type_key_rec_.oe_line_item_no_,
                                             local_control_type_key_rec_.oe_rma_no_,
                                             local_control_type_key_rec_.oe_rma_line_no_);
               END IF;
            Get_Str_Code_Order___ (oeorder_fetched_, control_type_value_tab_, control_value_tab_, local_control_type_key_rec_, i, control_type_name_tab_, control_type_tab_);
   -- Oesales values
         ELSIF (control_type_tab_(i) IN
            (control_type_name_tab_(15),
             control_type_name_tab_(17))) THEN         

               -- IF this is a call from RMA, no order keys are known yet. Find them from the RMA keys.
            IF (local_control_type_key_rec_.oe_order_no_ IS NULL AND local_control_type_key_rec_.oe_rma_no_ IS NOT NULL) AND (NOT oesales_fetched_) THEN         
                  -- Call this method only if the order_keys aren't initiated and the rma keys are initiated.
                  Prepare_Rma_Order_Keys___ (local_control_type_key_rec_.oe_order_no_,
                                             local_control_type_key_rec_.oe_line_no_,
                                             local_control_type_key_rec_.oe_rel_no_,
                                             local_control_type_key_rec_.oe_line_item_no_,
                                             local_control_type_key_rec_.oe_rma_no_,
                                             local_control_type_key_rec_.oe_rma_line_no_);
               END IF;
            Get_Str_Code_Salespart___ (oesales_fetched_, control_type_value_tab_, control_value_tab_, local_control_type_key_rec_, i, control_type_name_tab_, control_type_tab_);
   -- Customer Order Discount Type
         ELSIF (control_type_tab_(i) =
            (control_type_name_tab_(80))) THEN

             -- The key and the desired value are the same. There is no need to call a function in this case.
             control_value_tab_(i) := local_control_type_key_rec_.oe_discount_type_;
   -- Customer Order Discount value
         ELSIF (control_type_tab_(i) IN
            (control_type_name_tab_(81))) THEN                  

            Get_Str_Code_Oediscount___ (oediscount_fetched_, control_type_value_tab_, control_value_tab_, local_control_type_key_rec_, company_, i, control_type_name_tab_, control_type_tab_);
   -- Customer Order Charge value
         ELSIF (control_type_tab_(i) IN
            (control_type_name_tab_(62),
             control_type_name_tab_(63))) THEN         

            Get_Str_Code_Oecharge___ (oecharge_fetched_, control_type_value_tab_, control_value_tab_, local_control_type_key_rec_, i, control_type_name_tab_, control_type_tab_);
   -- Customer Order Line Country Code value
         ELSIF (control_type_tab_(i) =
            (control_type_name_tab_(18))) THEN                  

               -- IF this is a call from RMA, no order keys are known yet. Find them from the RMA keys.
            IF (local_control_type_key_rec_.oe_order_no_ IS NULL AND local_control_type_key_rec_.oe_rma_no_ IS NOT NULL) AND (NOT oeaddress_fetched_) THEN         
                  -- Call this method only if the order_keys aren't initiated and the rma keys are initiated.
                  Prepare_Rma_Order_Keys___ (local_control_type_key_rec_.oe_order_no_,
                                             local_control_type_key_rec_.oe_line_no_,
                                             local_control_type_key_rec_.oe_rel_no_,
                                             local_control_type_key_rec_.oe_line_item_no_,
                                             local_control_type_key_rec_.oe_rma_no_,
                                             local_control_type_key_rec_.oe_rma_line_no_);
               END IF;
            Get_Str_Code_Oeaddress___ (oeaddress_fetched_, control_type_value_tab_, control_value_tab_, local_control_type_key_rec_, i, control_type_name_tab_, control_type_tab_);
   -- Tax Code
         ELSIF (control_type_tab_(i) = control_type_name_tab_(25)) THEN
            control_value_tab_(i) := control_type_key_rec_.tax_code_;
   -- VAT value
         ELSIF (control_type_tab_(i) IN
            (control_type_name_tab_(59),
             control_type_name_tab_(64))) THEN         

            -- IF this is a call from RMA, no order keys are known yet. Find them from the RMA keys.
            IF (local_control_type_key_rec_.oe_order_no_ IS NULL AND local_control_type_key_rec_.oe_rma_no_ IS NOT NULL) AND (NOT vat_fetched_) THEN         
               -- Call this method only if the order_keys aren't initiated and the rma keys are initiated.
               Prepare_Rma_Order_Keys___ (local_control_type_key_rec_.oe_order_no_,
                                          local_control_type_key_rec_.oe_line_no_,
                                          local_control_type_key_rec_.oe_rel_no_,
                                          local_control_type_key_rec_.oe_line_item_no_,
                                          local_control_type_key_rec_.oe_rma_no_,
                                          local_control_type_key_rec_.oe_rma_line_no_);
            END IF;          
            Get_Str_Code_Vat___ (vat_fetched_, control_type_value_tab_, control_value_tab_, local_control_type_key_rec_, company_, i, control_type_name_tab_, control_type_tab_);
   -- Return Material Authorization (RMA) values
         ELSIF (control_type_tab_(i) IN
            (control_type_name_tab_(65),
             control_type_name_tab_(66),
             control_type_name_tab_(67),
             control_type_name_tab_(68),
             control_type_name_tab_(69),
             control_type_name_tab_(70),
             control_type_name_tab_(71),
             control_type_name_tab_(72),
             control_type_name_tab_(73),
             control_type_name_tab_(74),
             control_type_name_tab_(75),
             control_type_name_tab_(76),
             control_type_name_tab_(77),
             control_type_name_tab_(78),
             control_type_name_tab_(79))) THEN         

             Get_Str_Code_Rma___ (rma_fetched_, control_type_value_tab_, control_value_tab_, local_control_type_key_rec_, i, control_type_name_tab_, control_type_tab_);
   -- Pur values
         ELSIF (control_type_tab_(i) IN
            (control_type_name_tab_(30),
             control_type_name_tab_(33),
             control_type_name_tab_(34),
             control_type_name_tab_(35),
             control_type_name_tab_(37),
             control_type_name_tab_(38),
             control_type_name_tab_(39),
             control_type_name_tab_(40),
             control_type_name_tab_(41),
             control_type_name_tab_(42),
             control_type_name_tab_(43),
             control_type_name_tab_(82))) THEN          

            IF (local_control_type_key_rec_.pur_order_no_ IS NULL) AND (local_control_type_key_rec_.oe_rma_no_ IS NOT NULL) AND
               (local_control_type_key_rec_.event_code_ IN ('OERET-NC', 'OERET-SPNC', 'RETPODIRSH', 'RETPODSINT', 'RETREVAL+', 'RETREVAL-')) AND (NOT pur_fetched_) THEN
               Set_Po_Line_Keys_From_Rma___(local_control_type_key_rec_.pur_order_no_,
                                                local_control_type_key_rec_.pur_line_no_,
                                                local_control_type_key_rec_.pur_release_no_,
                                                local_control_type_key_rec_.oe_rma_no_,
                                                local_control_type_key_rec_.oe_rma_line_no_);
               END IF;
            Get_Str_Code_Purch___ (pur_fetched_, control_type_value_tab_, control_value_tab_, local_control_type_key_rec_, i, str_code_, control_type_name_tab_, control_type_tab_);
   -- Purpart values
         ELSIF (control_type_tab_(i) IN
            (control_type_name_tab_(31))) THEN

            Get_Str_Code_Purpart___ (purpart_fetched_, control_type_value_tab_, control_value_tab_, local_control_type_key_rec_, i, control_type_name_tab_, control_type_tab_);
   -- Purchase Order Charge value
         ELSIF (control_type_tab_(i) IN
            (control_type_name_tab_(60),
             control_type_name_tab_(61))) THEN         

            Get_Str_Code_Purcharge___(purcharge_fetched_, control_type_value_tab_, control_value_tab_, local_control_type_key_rec_, i, control_type_name_tab_, control_type_tab_);
   -- Inventory Transaction History values
         ELSIF (control_type_tab_(i) IN
            (control_type_name_tab_(45),
             control_type_name_tab_(83),
             control_type_name_tab_(89),
             control_type_name_tab_(95))) THEN         

            Get_Str_Code_Invtranshist___ (invtrans_fetched_, control_type_value_tab_, control_value_tab_, local_control_type_key_rec_, i, str_code_, control_type_name_tab_, control_type_tab_);
         ELSIF (control_type_tab_(i) IN
            (control_type_name_tab_(4))) THEN         

            Get_Related_Invtrans_Values___ (related_invtrans_fetched_, control_type_value_tab_, control_value_tab_, local_control_type_key_rec_, i, control_type_name_tab_, control_type_tab_); 
   -- Loc values
         ELSIF (control_type_tab_(i) IN
            (control_type_name_tab_(46))) THEN         

            Get_Location_Type_Db___ (location_type_fetched_, invtrans_fetched_, control_type_value_tab_, control_value_tab_, local_control_type_key_rec_, i, str_code_, control_type_name_tab_, control_type_tab_);
   -- Operation History or Indirect Labor History work_center
         ELSIF (control_type_tab_(i) IN
            (control_type_name_tab_(47))) THEN         

            Get_Str_Code_Work_Center___(opt_fetched_, control_type_value_tab_, control_value_tab_, local_control_type_key_rec_, i, str_code_, control_type_name_tab_, control_type_tab_);
   -- Operation History or Indirect Labor History labor_class
         ELSIF (control_type_tab_(i) IN
            (control_type_name_tab_(48))) THEN                  

            Get_Str_Code_Labor_Class___(lab_fetched_, control_type_value_tab_, control_value_tab_, local_control_type_key_rec_, i, str_code_, control_type_name_tab_, control_type_tab_);
   -- Work order values
         ELSIF (control_type_tab_(i) IN
            (control_type_name_tab_(51),
             control_type_name_tab_(52),
             control_type_name_tab_(53),
             control_type_name_tab_(54),
             control_type_name_tab_(55),
             control_type_name_tab_(106))) THEN         
            
            Get_Str_Code_Work_Task___ (work_task_fetched_, control_type_value_tab_, control_value_tab_, local_control_type_key_rec_, i, control_type_name_tab_, control_type_tab_);
   -- Dop order values
         ELSIF (control_type_tab_(i) IN
            (control_type_name_tab_(56),
             control_type_name_tab_(57))) THEN         

            Get_Str_Code_Dop___ (dop_fetched_, control_type_value_tab_, control_value_tab_, local_control_type_key_rec_, i, control_type_name_tab_, control_type_tab_);
   -- Purchase Transaction History values
         ELSIF (control_type_tab_(i) IN
            (control_type_name_tab_(84))) THEN         

            Get_Str_Code_purtranshist___ (purtrans_fetched_, control_type_value_tab_, control_value_tab_, local_control_type_key_rec_, i, control_type_name_tab_, control_type_tab_);
   -- Country Code values
         ELSIF (control_type_tab_(i) IN
            (control_type_name_tab_(85))) THEN         

            Get_Str_Code_Countrycode___(countrycode_fetched_, control_type_value_tab_, control_value_tab_, local_control_type_key_rec_, i, control_type_name_tab_, control_type_tab_);
        -- Local values in MpccomAccounting
         ELSIF (control_type_tab_(i) = control_type_name_tab_(90)) THEN
            control_value_tab_(i) := cost_source_id_;
         ELSIF (control_type_tab_(i) = control_type_name_tab_(91)) THEN
            control_value_tab_(i) := bucket_posting_group_id_;
   -- User Group values
         ELSIF (control_type_tab_(i) IN
            (control_type_name_tab_(86))) THEN

            Get_Str_Code_Usergroup___(usergroup_fetched_, control_type_value_tab_, control_value_tab_, company_, i, control_type_name_tab_, control_type_tab_);
   -- State Code values
         ELSIF (control_type_tab_(i) IN
            (control_type_name_tab_(87))) THEN         

            Get_Str_Code_Statecode___(statecode_fetched_, control_type_value_tab_, control_value_tab_, local_control_type_key_rec_, i, control_type_name_tab_, control_type_tab_);
   -- Material Requisition values
         ELSIF (control_type_tab_(i) IN
            (control_type_name_tab_(98), (control_type_name_tab_(99)))) THEN         

            Get_Str_Code_Mtrl_Requis___(mtrl_req_fetched_, control_type_value_tab_, control_value_tab_, local_control_type_key_rec_, i, control_type_name_tab_, control_type_tab_);
   -- Customer Group values
         ELSIF (control_type_tab_(i) IN
            (control_type_name_tab_(88))) THEN        

            Get_Str_Code_Customergroup___(customergroup_fetched_, control_type_value_tab_, control_value_tab_, local_control_type_key_rec_, i, control_type_name_tab_, control_type_tab_);
   -- Rebate Group values
         ELSIF (control_type_tab_(i) IN
            (control_type_name_tab_(96),
             control_type_name_tab_(97))) THEN         

            Get_Str_Code_Rebate_Group___(rebate_group_fetched_, control_type_value_tab_, control_value_tab_, local_control_type_key_rec_, i, control_type_name_tab_, control_type_tab_);
   -- Indirect Labor History
         ELSIF (control_type_tab_(i) IN
            (control_type_name_tab_(100),
             control_type_name_tab_(104))) THEN         

            Get_Str_Code_Indirect_Labor___(indirect_labor_fetched_, control_type_value_tab_, control_value_tab_, local_control_type_key_rec_, i, control_type_name_tab_, control_type_tab_);
   -- Employee data retrieved from PERSON module 
         ELSIF (control_type_tab_(i) IN
            (control_type_name_tab_(101), 
             control_type_name_tab_(102), 
             control_type_name_tab_(103))) THEN

            Get_Str_Code_Person___(person_fetched_, control_type_value_tab_, control_value_tab_, local_control_type_key_rec_, i, control_type_name_tab_, control_type_tab_);
   -- FSM transaction type retrieved from FSMAPP module.
         ELSIF (control_type_tab_(i) IN 
            (control_type_name_tab_(105))) THEN
            Get_Str_Code_Fsmtranshist___(fsmtrans_fetched_, control_type_value_tab_, control_value_tab_, local_control_type_key_rec_, i, control_type_name_tab_, control_type_tab_);   
   -- Manufacturing WIP Posting Event
         ELSIF (control_type_tab_(i) IN 
            (control_type_name_tab_(117))) THEN
            Get_Str_Code_Manu_Wip_Event___(control_type_value_tab_, control_value_tab_, local_control_type_key_rec_, i, control_type_name_tab_, control_type_tab_);   
   -- Manufacturing WIP Business Event
         ELSIF (control_type_tab_(i) IN 
            (control_type_name_tab_(127))) THEN
            control_value_tab_(i) := local_control_type_key_rec_.event_code_;
   -- Business Transaction Code      
         ELSIF (control_type_tab_(i) IN 
            (control_type_name_tab_(128))) THEN
            Get_Str_Code_Business_Transaction_Code___(busines_trans_code_fetched_, control_type_value_tab_, control_value_tab_, local_control_type_key_rec_, i, control_type_name_tab_, control_type_tab_);         
         END IF;
      END LOOP;
   END IF;
END Get_Code_String_Values___;


-- Get_Control_Type_Value_Pur1___
--   Gets control type value from purchase.
PROCEDURE Get_Control_Type_Value_Pur1___ (
   control_type_value_tab_ IN OUT Control_Type_Value,
   control_type_key_rec_   IN     Mpccom_Accounting_API.Control_Type_Key,
   str_code_               IN     VARCHAR2 )
IS
   vendor_no_                 SUPPLIER_INFO_PUBLIC.supplier_id%TYPE;
   transaction_code_          VARCHAR2(10);
   connected_transaction_id_  NUMBER;
   stmt_                      VARCHAR2(2000);
   buyer_code_                VARCHAR2(20);
   authorize_code_            VARCHAR2(20);
   delivery_terms_            VARCHAR2(5);
   ship_via_code_             VARCHAR2(3);
   currency_code_             VARCHAR2(3);
BEGIN

   IF (control_type_key_rec_.chg_pur_order_no_ IS NOT NULL) THEN
      stmt_ := 'DECLARE
                   purch_chg_ord_rec_  Purch_Chg_Ord_API.Public_rec;
                BEGIN
                   purch_chg_ord_rec_ := Purch_Chg_Ord_API.Get(:order_no, :chg_order_no);
                   :vendor_no         := Purchase_Order_API.Get_Vendor_No(:order_no);

                   :delivery_terms := purch_chg_ord_rec_.delivery_terms;
                   :ship_via_code  := purch_chg_ord_rec_.ship_via_code;
                   :currency_code  := purch_chg_ord_rec_.currency_code;
                   :buyer_code     := purch_chg_ord_rec_.buyer_code;
                   :authorize_code := purch_chg_ord_rec_.authorize_code;
                END;';
      @ApproveDynamicStatement(2010-10-27,RoJalk)
      EXECUTE IMMEDIATE stmt_
         USING IN  control_type_key_rec_.chg_pur_order_no_,
               IN  control_type_key_rec_.chg_order_no_,
               OUT vendor_no_,
               OUT delivery_terms_,
               OUT ship_via_code_,
               OUT currency_code_,
               OUT buyer_code_,
               OUT authorize_code_ ;

   ELSIF (control_type_key_rec_.pur_order_no_ IS NOT NULL) THEN
      -- purchase_header  
      -- Use Purchase_Order_API.Get() to avoid use of multiple get-functions.
      stmt_ := 'DECLARE
                   purchase_order_rec_  Purchase_Order_API.Public_rec;
                BEGIN
                   purchase_order_rec_ := Purchase_Order_API.Get(:order_no);

                   :delivery_terms := purchase_order_rec_.delivery_terms;
                   :ship_via_code  := purchase_order_rec_.ship_via_code;
                   :currency_code  := purchase_order_rec_.currency_code;
                   :buyer_code     := purchase_order_rec_.buyer_code;
                   :authorize_code := purchase_order_rec_.authorize_code;
                   :vendor_no      := purchase_order_rec_.vendor_no;
                END;';
      @ApproveDynamicStatement(2006-01-20,JaJalk)
      EXECUTE IMMEDIATE stmt_
         USING IN  control_type_key_rec_.pur_order_no_,
               OUT delivery_terms_,
               OUT ship_via_code_,
               OUT currency_code_,
               OUT buyer_code_,
               OUT authorize_code_,
               OUT vendor_no_;
   ELSE
      stmt_ := 'DECLARE
                   invtrans_rec_  Inventory_Transaction_Hist_API.Public_rec;
                BEGIN
                   invtrans_rec_ := Inventory_Transaction_Hist_API.Get(:transaction_id);

                   :transaction_code          := invtrans_rec_.transaction_code;
                   :vendor_no                 := invtrans_rec_.owning_vendor_no;
                   :connected_transaction_id  := Invent_Trans_Interconnect_API.Get_Connected_Transaction_Id(:transaction_id, ''INTERSITE TRANSFER'');
                END;';
         @ApproveDynamicStatement(2006-01-20,JaJalk)
         EXECUTE IMMEDIATE stmt_
            USING IN  control_type_key_rec_.transaction_id_,
                  OUT transaction_code_,
                  OUT vendor_no_,
                  OUT connected_transaction_id_;

      IF (transaction_code_ = 'CO-CONS-IN') THEN
         -- 'CO-CONS-IN' = Internal Transfer - Receipt - Consignment Stock.
         -- Use connected_transaction_id to get consignment_vendor_no
         -- from the corresponding 'CO-INVM-IS' transaction.
         -- 'CO-INVM-IS' = Inter Site Transfer - Issue - Consignment Stock
         stmt_ := 'BEGIN
                      :vendor_no := Inventory_Transaction_Hist_API.Get_Owning_Vendor_No(:connected_transaction_id);
                   END;';

            @ApproveDynamicStatement(2006-01-20,JaJalk)
         EXECUTE IMMEDIATE stmt_ USING OUT vendor_no_,
                                       IN connected_transaction_id_;
      END IF;
   END IF;

   IF (control_type_key_rec_.chg_pur_order_no_ IS NOT NULL) OR (control_type_key_rec_.pur_order_no_ IS NOT NULL) THEN 
      control_type_value_tab_(34) := delivery_terms_;
      control_type_value_tab_(35) := ship_via_code_;
      control_type_value_tab_(37) := currency_code_;
      control_type_value_tab_(38) := buyer_code_;
      control_type_value_tab_(41) := authorize_code_;

      IF (str_code_ = 'M65') THEN
         stmt_ := 'BEGIN
                      :vendor_no_ := Purchase_Order_Charge_API.Get_Charge_By_Supplier(:order_no, :sequence_no);
                   END;';
         @ApproveDynamicStatement(2010-02-02,SuSalk)
         EXECUTE IMMEDIATE stmt_
            USING OUT  vendor_no_,
                  IN   control_type_key_rec_.pur_order_no_,
                  IN   control_type_key_rec_.pur_charge_seq_no_;                  
      END IF;  
      -- authorize
      control_type_value_tab_(42) := Order_Coordinator_API.Get_Authorize_Group(control_type_value_tab_(41));
   END IF;

   -- supplier
   stmt_ := 'BEGIN :supp_grp := Supplier_API.Get_Supp_Grp(
                      :vendor_no); END;';
   @ApproveDynamicStatement(2010-11-18,RoJalk)
   EXECUTE IMMEDIATE stmt_
      USING OUT control_type_value_tab_(30),
            IN  vendor_no_;
END Get_Control_Type_Value_Pur1___;


-- Get_Control_Type_Value_Pur2___
--   Gets control type value from purchase.
PROCEDURE Get_Control_Type_Value_Pur2___ (
   control_type_value_tab_ IN OUT Control_Type_Value,
   control_type_key_rec_   IN     Mpccom_Accounting_API.Control_Type_Key)
IS
   stmt_              VARCHAR2(2000);
   line_exist_        VARCHAR2(6);
   inspection_code_   VARCHAR2(20);
   assortment_        VARCHAR2(20);
   delivery_terms_    VARCHAR2(5);
   ship_via_code_     VARCHAR2(3);
BEGIN

   IF (control_type_key_rec_.chg_pur_order_no_ IS NOT NULL) THEN
      -- Check whether the POCO line exist
      stmt_ := 'BEGIN
                   :line_exist_ := Purch_Chg_Ord_Line_API.Check_Exist(:order_no, :chg_order_no, :line_no, :release_no);
                END;';
      @ApproveDynamicStatement(2010-10-27,RoJalk)
      EXECUTE IMMEDIATE stmt_ USING OUT line_exist_,
                                    IN  control_type_key_rec_.chg_pur_order_no_,
                                    IN  control_type_key_rec_.chg_order_no_,
                                    IN  control_type_key_rec_.chg_line_no_,
                                    IN  control_type_key_rec_.chg_release_no_;

      IF (line_exist_ = 'TRUE') THEN
         stmt_ := 'DECLARE
                      purch_chg_ord_line_rec_ Purch_Chg_Ord_Line_API.Public_rec;
                   BEGIN
                      purch_chg_ord_line_rec_ := Purch_Chg_Ord_Line_API.Get(:order_no, :chg_order_no, :line_no, :release_no);
                      :assortment             := purch_chg_ord_line_rec_.assortment;
                      :delivery_terms         := purch_chg_ord_line_rec_.delivery_terms;
                      :ship_via_code          := purch_chg_ord_line_rec_.ship_via_code;
                   END;';
         @ApproveDynamicStatement(2010-10-27,RoJalk)
         EXECUTE IMMEDIATE stmt_ USING IN  control_type_key_rec_.chg_pur_order_no_,
                                       IN  control_type_key_rec_.chg_order_no_,
                                       IN  control_type_key_rec_.chg_line_no_,
                                       IN  control_type_key_rec_.chg_release_no_,
                                       OUT assortment_,
                                       OUT delivery_terms_,
                                       OUT ship_via_code_;

      END IF;
   ELSIF (control_type_key_rec_.pur_order_no_ IS NOT NULL) THEN
      -- Check whether the PO line exist
      stmt_ := 'BEGIN
                   :line_exist_ := Purchase_Order_Line_API.Check_Exist(:order_no, :line_no, :release_no);
                END;';

      @ApproveDynamicStatement(2006-01-20,JaJalk)
      EXECUTE IMMEDIATE stmt_ USING OUT line_exist_,
                                    IN  control_type_key_rec_.pur_order_no_,
                                    IN  control_type_key_rec_.pur_line_no_,
                                    IN  control_type_key_rec_.pur_release_no_;

      IF (line_exist_ = 'TRUE') THEN
         -- Use Purchase_Order_Line_API.Get() to avoid use of multiple get-functions.
         stmt_ := 'DECLARE
                      purchase_order_line_rec_ Purchase_Order_Line_API.Public_rec;
                   BEGIN
                      purchase_order_line_rec_ := Purchase_Order_Line_API.Get(:order_no, :line_no, :release_no);                      
                      :inspection_code         := purchase_order_line_rec_.inspection_code;
                      :assortment              := purchase_order_line_rec_.assortment;
                      :delivery_terms          := purchase_order_line_rec_.delivery_terms;
                      :ship_via_code           := purchase_order_line_rec_.ship_via_code;
                   END;';
         @ApproveDynamicStatement(2006-01-20,JaJalk)
         EXECUTE IMMEDIATE stmt_ USING IN  control_type_key_rec_.pur_order_no_,
                                       IN  control_type_key_rec_.pur_line_no_,
                                       IN  control_type_key_rec_.pur_release_no_,                                       
                                       OUT inspection_code_,
                                       OUT assortment_,
                                       OUT delivery_terms_,
                                       OUT ship_via_code_;
      END IF;
   END IF;

   control_type_value_tab_(40) := inspection_code_;
   control_type_value_tab_(82) := assortment_;
   control_type_value_tab_(34) := delivery_terms_;
   control_type_value_tab_(35) := ship_via_code_;

   --Qc_code
   stmt_ := 'BEGIN :qc_code := Purchase_Order_Line_Part_API.Get_Qc_Code(
                                          :order_no,
                                          :line_no,
                                          :release_no); END;';
      @ApproveDynamicStatement(2006-01-20,JaJalk)
   EXECUTE IMMEDIATE stmt_
      USING OUT control_type_value_tab_(39),
            IN  control_type_key_rec_.pur_order_no_,
            IN  control_type_key_rec_.pur_line_no_,
            IN  control_type_key_rec_.pur_release_no_;
END Get_Control_Type_Value_Pur2___;


-- Get_Control_Type_Value_Pur3___
--   Gets control type value from purchase.
PROCEDURE Get_Control_Type_Value_Pur3___ (
   control_type_value_tab_ IN OUT Control_Type_Value,
   control_type_key_rec_   IN     Mpccom_Accounting_API.Control_Type_Key)
IS
   req_no_  VARCHAR2(12);
   stmt_    VARCHAR2(500);
BEGIN
   IF (control_type_key_rec_.pur_req_no_ IS NULL) THEN
      IF (control_type_key_rec_.chg_pur_order_no_ IS NOT NULL) THEN
         stmt_ := 'BEGIN :req_no := Purch_Chg_Ord_Line_API.Get_Requisition_No(
                                       :order_no,
                                       :chg_order_no,
                                       :line_no,
                                       :release_no); END;';
         @ApproveDynamicStatement(2010-10-27,RoJalk)
         EXECUTE IMMEDIATE stmt_
            USING OUT req_no_,
                  IN  control_type_key_rec_.chg_pur_order_no_,
                  IN  control_type_key_rec_.chg_order_no_,
                  IN  control_type_key_rec_.chg_line_no_,
                  IN  control_type_key_rec_.chg_release_no_;
      ELSIF (control_type_key_rec_.pur_order_no_ IS NOT NULL) THEN
            stmt_ := 'BEGIN :req_no := Purchase_Order_Line_API.Get_Requisition_No(
                                          :order_no,
                                          :line_no,
                                          :release_no); END;';
            @ApproveDynamicStatement(2006-01-20,JaJalk)
            EXECUTE IMMEDIATE stmt_
               USING OUT req_no_,
                     IN  control_type_key_rec_.pur_order_no_,
                     IN  control_type_key_rec_.pur_line_no_,
                     IN  control_type_key_rec_.pur_release_no_;
      END IF;
   ELSE
      req_no_ := control_type_key_rec_.pur_req_no_;
   END IF;   

   stmt_ := 'BEGIN :req_code := Purchase_Req_Util_API.Get_Requisitioner(
                                   :req_no); END;';
   @ApproveDynamicStatement(2006-01-20,JaJalk)
   EXECUTE IMMEDIATE stmt_
      USING OUT control_type_value_tab_(43),
            IN  req_no_;
END Get_Control_Type_Value_Pur3___;





PROCEDURE Get_Location_Type_Db___ (
   location_type_fetched_  IN OUT BOOLEAN,
   invtrans_fetched_       IN OUT BOOLEAN,
   control_type_value_tab_ IN OUT Control_Type_Value,
   control_value_tab_      IN OUT Posting_Ctrl_API.CtrlValTab,
   control_type_key_rec_   IN     Mpccom_Accounting_API.Control_Type_Key,
   i_                      IN     NUMBER,
   str_code_               IN     VARCHAR2,
   control_type_name_tab_  IN     Control_Type_Name,
   control_type_tab_       IN     Posting_Ctrl_API.CtrlTypTab )
IS
BEGIN
   -- Inventory Location values
   IF ((NOT invtrans_fetched_) AND (control_type_key_rec_.transaction_id_ IS NOT NULL)) THEN
      IF (control_type_key_rec_.event_code_ = 'CO-DELV-IN') THEN
      -- For Consignment Stock at Customer
         control_type_value_tab_(46) := 'CONSIGNMENT';
      ELSE
         IF NOT (invtrans_fetched_) THEN
            Get_Str_Code_Invtranshist___ (invtrans_fetched_, control_type_value_tab_, control_value_tab_, control_type_key_rec_, i_, str_code_, control_type_name_tab_, control_type_tab_);
         END IF;
         $IF (Component_Invent_SYS.INSTALLED) $THEN
            control_type_value_tab_(46) := Inventory_Location_Group2_API.Get_Inventory_Location_Type_Db(control_type_value_tab_(83));                     
         $ELSE
            Error_SYS.Component_Not_Exist('INVENT');
         $END
         END IF;
      location_type_fetched_ := TRUE;
   END IF;

   IF (control_type_tab_(i_) = control_type_name_tab_(46)) THEN
     control_value_tab_(i_) := control_type_value_tab_(46);
   END IF;
END Get_Location_Type_Db___;


-- Get_Str_Code_Invtranshist___
--   Get str code for Inventory Transaction History.
PROCEDURE Get_Str_Code_Invtranshist___ (
   invtrans_fetched_       IN OUT BOOLEAN,
   control_type_value_tab_ IN OUT Control_Type_Value,
   control_value_tab_      IN OUT Posting_Ctrl_API.CtrlValTab,
   control_type_key_rec_   IN     Mpccom_Accounting_API.Control_Type_Key,
   i_                      IN     NUMBER,
   str_code_               IN     VARCHAR2,
   control_type_name_tab_  IN     Control_Type_Name,
   control_type_tab_       IN     Posting_Ctrl_API.CtrlTypTab )
IS
   location_group_         VARCHAR2(20);
   transit_location_group_ VARCHAR2(20);
BEGIN
   IF ((NOT invtrans_fetched_) AND (control_type_key_rec_.transaction_id_ IS NOT NULL)) THEN
      $IF (Component_Invent_SYS.INSTALLED) $THEN
         DECLARE
            invtrans_rec_  Inventory_Transaction_Hist_API.Public_rec;
         BEGIN
            invtrans_rec_                := Inventory_Transaction_Hist_API.Get(control_type_key_rec_.transaction_id_);
            control_type_value_tab_(45)  := invtrans_rec_.reject_code;
            location_group_              := invtrans_rec_.location_group;
            transit_location_group_      := invtrans_rec_.transit_location_group;
            control_type_value_tab_(89)  := invtrans_rec_.condition_code;
         END;

         IF (str_code_ = 'M3') THEN
            control_type_value_tab_(83) := transit_location_group_;
         ELSE
            control_type_value_tab_(83) := location_group_;
         END IF;

         control_type_value_tab_(95) := control_type_value_tab_(45);
      $ELSE
         Error_SYS.Component_Not_Exist('INVENT');
      $END
      invtrans_fetched_ := TRUE;
   END IF;
   
   IF (control_type_tab_(i_) = control_type_name_tab_(45)) THEN
      control_value_tab_(i_) := control_type_value_tab_(45);
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(83)) THEN
     control_value_tab_(i_) := control_type_value_tab_(83);
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(89)) THEN
      control_value_tab_(i_) := control_type_value_tab_(89);
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(95)) THEN
      control_value_tab_(i_) := control_type_value_tab_(95);
   END IF;
END Get_Str_Code_Invtranshist___;

PROCEDURE Get_Related_Invtrans_Values___ (
   related_invtrans_fetched_ IN OUT BOOLEAN,
   control_type_value_tab_   IN OUT Control_Type_Value,
   control_value_tab_        IN OUT Posting_Ctrl_API.CtrlValTab,
   control_type_key_rec_     IN     Mpccom_Accounting_API.Control_Type_Key,
   i_                        IN     NUMBER,
   control_type_name_tab_    IN     Control_Type_Name,
   control_type_tab_         IN     Posting_Ctrl_API.CtrlTypTab )
IS
   stmt_     VARCHAR2(2000);
   contract_ MPCCOM_ACCOUNTING_TAB.contract%TYPE;
BEGIN
   IF (NOT related_invtrans_fetched_) THEN
      stmt_ := 'DECLARE
                   connected_transaction_id_ NUMBER;
                BEGIN
                   connected_transaction_id_ := Invent_Trans_Interconnect_API.Get_Connected_Transaction_Id(:transaction_id, ''INTERSITE TRANSFER'');
                   :contract := Inventory_Transaction_Hist_API.Get_Transaction_Contract(connected_transaction_id_);
                END;';
      @ApproveDynamicStatement(2009-12-17,PraWlk)
      EXECUTE IMMEDIATE stmt_
         USING IN  control_type_key_rec_.transaction_id_,
               OUT contract_; 

      control_type_value_tab_(4) := Site_API.Get_Company(contract_);
      related_invtrans_fetched_ := TRUE;
   END IF;

   IF (control_type_tab_(i_) = control_type_name_tab_(4)) THEN
      control_value_tab_(i_) := control_type_value_tab_(4);
   END IF;
END Get_Related_Invtrans_Values___;


PROCEDURE Get_Str_Code_Labor_Class___ (
   lab_fetched_            IN OUT BOOLEAN,
   control_type_value_tab_ IN OUT Control_Type_Value,
   control_value_tab_      IN OUT Posting_Ctrl_API.CtrlValTab,
   control_type_key_rec_   IN     Mpccom_Accounting_API.Control_Type_Key,
   i_                      IN     NUMBER,
   str_code_               IN     VARCHAR2,
   control_type_name_tab_  IN     Control_Type_Name,
   control_type_tab_       IN     Posting_Ctrl_API.CtrlTypTab )
IS
BEGIN
   -- Labor class no values
   IF NOT lab_fetched_ THEN
      IF (str_code_ IN ('M209', 'M210')) THEN
         $IF (Component_Shpord_SYS.INSTALLED) $THEN
            control_type_value_tab_(48) := Indirect_Labor_History_API.Get_Labor_Class_No(control_type_key_rec_.transaction_id_);                                                  
         $ELSE
            Error_SYS.Component_Not_Exist('SHPORD');
         $END
      ELSE
         $IF (Component_Mfgstd_SYS.INSTALLED) $THEN
            control_type_value_tab_(48):= Operation_History_API.Get_Labor_Class_No(control_type_key_rec_.transaction_id_);                                                  
         $ELSE
            Error_SYS.Component_Not_Exist('MFGSTD');
         $END
         END IF;
      lab_fetched_ := TRUE;
   END IF;

   IF (control_type_tab_(i_) = control_type_name_tab_(48)) THEN
      control_value_tab_(i_) := control_type_key_rec_.contract_ ||' | '|| control_type_value_tab_(48);
   END IF;
END Get_Str_Code_Labor_Class___;


PROCEDURE Get_Str_Code_Work_Center___ (
   opt_fetched_            IN OUT BOOLEAN,
   control_type_value_tab_ IN OUT Control_Type_Value,
   control_value_tab_      IN OUT Posting_Ctrl_API.CtrlValTab,
   control_type_key_rec_   IN     Mpccom_Accounting_API.Control_Type_Key,
   i_                      IN     NUMBER,
   str_code_               IN     VARCHAR2,
   control_type_name_tab_  IN     Control_Type_Name,
   control_type_tab_       IN     Posting_Ctrl_API.CtrlTypTab )
IS
BEGIN
   -- Machine Operation History values
   IF NOT opt_fetched_ THEN
      IF (str_code_ IN ('M209', 'M210')) THEN
         $IF (Component_Shpord_SYS.INSTALLED) $THEN
            control_type_value_tab_(47):= Indirect_Labor_History_API.Get_Work_Center_No(control_type_key_rec_.transaction_id_);                                                  
         $ELSE
            Error_SYS.Component_Not_Exist('SHPORD');
         $END
      ELSE
         $IF (Component_Mfgstd_SYS.INSTALLED) $THEN
            control_type_value_tab_(47) := Operation_History_API.Get_Work_Center_No(control_type_key_rec_.transaction_id_);                                               
         $ELSE
            Error_SYS.Component_Not_Exist('MFGSTD');
         $END
         END IF;
      opt_fetched_ := TRUE;
   END IF;

   IF (control_type_tab_(i_) = control_type_name_tab_(47)) THEN
      control_value_tab_(i_) := control_type_value_tab_(47);
   END IF;
END Get_Str_Code_Work_Center___;


-- Get_Str_Code_Mtrl_Requis___
--   Get str code for Material Requisition.
PROCEDURE Get_Str_Code_Mtrl_Requis___ (
   mtrl_req_fetched_       IN OUT BOOLEAN,
   control_type_value_tab_ IN OUT Control_Type_Value,
   control_value_tab_      IN OUT Posting_Ctrl_API.CtrlValTab,
   control_type_key_rec_   IN     Mpccom_Accounting_API.Control_Type_Key,
   i_                      IN     NUMBER,
   control_type_name_tab_  IN     Control_Type_Name,
   control_type_tab_       IN     Posting_Ctrl_API.CtrlTypTab )
IS
BEGIN
   IF NOT (mtrl_req_fetched_) THEN
      $IF (Component_Invent_SYS.INSTALLED) $THEN
         DECLARE
            material_requis_rec_ Material_Requisition_API.Public_Rec;
         BEGIN   
            material_requis_rec_  := Material_Requisition_API.Get('INT', control_type_key_rec_.int_order_no_);
            control_type_value_tab_(98) := material_requis_rec_.int_customer_no;
            control_type_value_tab_(99) := material_requis_rec_.destination_id;
            mtrl_req_fetched_ := TRUE;
         END;      
      $ELSE
         Error_SYS.Component_Not_Exist('INVENT');
      $END
   END IF;

   IF (control_type_tab_(i_) = control_type_name_tab_(98)) THEN
      control_value_tab_(i_) := control_type_value_tab_(98);
   ELSIF (control_type_tab_(i_) = control_type_name_tab_(99)) THEN
      control_value_tab_(i_) := control_type_value_tab_(99);
   END IF; 
END Get_Str_Code_Mtrl_Requis___;


-- Get_Str_Code_Order___
--   Get str code for Customer Order.
PROCEDURE Get_Str_Code_Order___ (
   oeorder_fetched_        IN OUT BOOLEAN,
   control_type_value_tab_ IN OUT Control_Type_Value,
   control_value_tab_      IN OUT Posting_Ctrl_API.CtrlValTab,
   control_type_key_rec_   IN     Mpccom_Accounting_API.Control_Type_Key,
   i_                      IN     NUMBER,
   control_type_name_tab_  IN     Control_Type_Name,
   control_type_tab_       IN     Posting_Ctrl_API.CtrlTypTab)
IS
BEGIN
   -- Customer Order values
   $IF (Component_Order_SYS.INSTALLED) $THEN
      IF NOT oeorder_fetched_ THEN            
         Order_Control_Type_Values_API.Get_Ctrl_Type_Value_Order(control_type_value_tab_, control_type_key_rec_);
         oeorder_fetched_ := TRUE;
      END IF;
   $ELSE
         Error_SYS.Component_Not_Exist('ORDER');
   $END
   
   IF (control_type_tab_(i_) = control_type_name_tab_(13)) THEN
      control_value_tab_(i_) := control_type_value_tab_(13);
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(14)) THEN
      control_value_tab_(i_) := control_type_value_tab_(14);
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(16)) THEN
      control_value_tab_(i_) := control_type_value_tab_(16);
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(19)) THEN
      control_value_tab_(i_) := control_type_value_tab_(19);
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(20)) THEN
      control_value_tab_(i_) := control_type_value_tab_(20);
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(21)) THEN
      control_value_tab_(i_) := control_type_value_tab_(21);
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(22)) THEN
      control_value_tab_(i_) := control_type_value_tab_(22);
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(23)) THEN
      control_value_tab_(i_) := control_type_value_tab_(23);
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(24)) THEN
      control_value_tab_(i_) := control_type_value_tab_(24);
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(26)) THEN
      control_value_tab_(i_) := control_type_value_tab_(26);
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(27)) THEN
      control_value_tab_(i_) := control_type_value_tab_(27);
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(28)) THEN
      control_value_tab_(i_) := control_type_value_tab_(28);
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(29)) THEN
      control_value_tab_(i_) := control_type_value_tab_(29);
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(92)) THEN
      control_value_tab_(i_) := control_type_value_tab_(92);
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(116)) THEN
      control_value_tab_(i_) := control_type_value_tab_(116);
   END IF;
END Get_Str_Code_Order___;


-- Get_Str_Code_Oecharge___
--   Get str code for Customer Order Charge.
PROCEDURE Get_Str_Code_Oecharge___ (
   oecharge_fetched_       IN OUT BOOLEAN,
   control_type_value_tab_ IN OUT Control_Type_Value,
   control_value_tab_      IN OUT Posting_Ctrl_API.CtrlValTab,
   control_type_key_rec_   IN     Mpccom_Accounting_API.Control_Type_Key,
   i_                      IN     NUMBER,
   control_type_name_tab_  IN     Control_Type_Name,
   control_type_tab_       IN     Posting_Ctrl_API.CtrlTypTab )
IS
   charge_type_ VARCHAR2(50);
BEGIN   
   -- Order charge values
   IF NOT oecharge_fetched_ THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         Invoice_Customer_Order_API.Get_Invoice_Charge_Data(charge_type_  => charge_type_, 
                                                            charge_group_ => control_type_value_tab_(63),
                                                            company_      => control_type_key_rec_.company_, 
                                                            invoice_id_   => control_type_key_rec_.oe_invoice_id_,
                                                            item_id_      => control_type_key_rec_.oe_invoice_item_id_);
         
         control_type_value_tab_(62) := control_type_key_rec_.contract_  || ' | ' || charge_type_;
      $ELSE
         Error_SYS.Component_Not_Exist('ORDER');
      $END
      oecharge_fetched_ := TRUE;
   END IF;

   IF (control_type_tab_(i_) = control_type_name_tab_(62)) THEN
      control_value_tab_(i_) := control_type_value_tab_(62);
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(63)) THEN
      control_value_tab_(i_) := control_type_value_tab_(63);
   END IF;
END Get_Str_Code_Oecharge___;


-- Get_Str_Code_Oediscount___
--   Get str code for Customer Order Discount.
PROCEDURE Get_Str_Code_Oediscount___ (
   oediscount_fetched_     IN OUT BOOLEAN,
   control_type_value_tab_ IN OUT Control_Type_Value,
   control_value_tab_      IN OUT Posting_Ctrl_API.CtrlValTab,
   control_type_key_rec_   IN     Mpccom_Accounting_API.Control_Type_Key,
   company_                IN     VARCHAR2,
   i_                      IN     NUMBER,
   control_type_name_tab_  IN     Control_Type_Name,
   control_type_tab_       IN     Posting_Ctrl_API.CtrlTypTab )
IS
BEGIN
   -- Order discount values
   IF NOT oediscount_fetched_ THEN
      $IF (Component_Order_SYS.INSTALLED) $THEN
         IF (control_type_key_rec_.oe_invoice_id_ IS NOT NULL) THEN
            control_type_value_tab_(81) := Cust_Invoice_Item_Discount_API.Get_Discount_Source_Db(company_, control_type_key_rec_.oe_invoice_id_, control_type_key_rec_.oe_invoice_item_id_, control_type_key_rec_.oe_discount_no_);
         ELSE
            control_type_value_tab_(81) := Cust_Order_Line_Discount_API.Get_Discount_Source_Db(control_type_key_rec_.oe_order_no_, control_type_key_rec_.oe_line_no_, control_type_key_rec_.oe_rel_no_, control_type_key_rec_.oe_line_item_no_, control_type_key_rec_.oe_discount_no_);
         END IF;
      $ELSE
         Error_SYS.Component_Not_Exist('ORDER');
      $END
      oediscount_fetched_ := TRUE;
   END IF;

   IF (control_type_tab_(i_) = control_type_name_tab_(81)) THEN
      control_value_tab_(i_) := control_type_value_tab_(81);
   END IF;
END Get_Str_Code_Oediscount___;


-- Get_Str_Code_Part___
--   Get str code for Inventory Part.
-- All code relating to 'MATCOST','PRODCOST', 'PRODCOST-' and C113, C114, C115 and M281, M283 are just added to be backwards compatible with 
-- polish localization follow_up_mat_prod_cost which was brought into core in 2021R2 using a completely different solution. 
-- The above mentioned event codes and control types cannot be created by the core solution itself.
PROCEDURE Get_Str_Code_Part___ (
   part_fetched_           IN OUT BOOLEAN,
   control_type_value_tab_ IN OUT Control_Type_Value,
   control_value_tab_      IN OUT Posting_Ctrl_API.CtrlValTab,
   control_type_key_rec_   IN     Mpccom_Accounting_API.Control_Type_Key,
   i_                      IN     NUMBER,
   posting_type_           IN     VARCHAR2,
   control_type_name_tab_  IN     Control_Type_Name,
   control_type_tab_       IN     Posting_Ctrl_API.CtrlTypTab)
IS
   part_no_                   VARCHAR2(25);
   planner_buyer_             VARCHAR2(20);
   type_code_                 VARCHAR2(2);
   prime_commodity_           VARCHAR2(5);
   second_commodity_          VARCHAR2(5);
   accounting_group_          VARCHAR2(5);
   part_product_family_       VARCHAR2(5);
   part_product_code_         VARCHAR2(5);
   asset_class_               VARCHAR2(2);
   abc_class_                 VARCHAR2(1);
   engineering_group_         VARCHAR2(1); -- store NULL value.
   source_for_part_no_        VARCHAR2(30);
   from_shop_order_                VARCHAR2(10) := 'SHOP_ORDER';
   from_production_receipt_        VARCHAR2(18) := 'PRODUCTION_RECEIPT';
   from_control_type_key_rec_      VARCHAR2(20) := 'CONTROL_TYPE_KEY_REC';
   from_purchase_order_line_       VARCHAR2(19) := 'PURCHASE_ORDER_LINE';
   from_purchase_order_line_comp_  VARCHAR2(24) := 'PURCHASE_ORDER_LINE_COMP';
BEGIN
   -- Part values
   $IF (Component_Order_SYS.INSTALLED) $THEN
      -- Part values from rebate aggregation line postings.
      IF ((control_type_key_rec_.reb_aggr_posting_id_ IS NOT NULL) AND (NOT part_fetched_)) THEN
         Order_Control_Type_Values_API.Get_Ctrl_Type_Value_Reb_Agg(control_type_value_tab_, control_type_key_rec_);
         part_fetched_ := TRUE;
      END IF;
   $END
   
   -- Part values
   IF ( NOT part_fetched_ OR ((control_type_value_tab_(6) IS NULL) 
                               AND (control_type_value_tab_(7) IS NULL)
                               AND (control_type_value_tab_(8) IS NULL)
                               AND (control_type_value_tab_(9) IS NULL)
                               AND (control_type_value_tab_(10) IS NULL)
                               AND (control_type_value_tab_(11) IS NULL)
                               AND (control_type_value_tab_(12) IS NULL)
                               AND (control_type_value_tab_(32) IS NULL)
                               AND (control_type_value_tab_(49) IS NULL)
                               AND (control_type_value_tab_(50) IS NULL)
                               AND (control_type_value_tab_(113) IS NULL)
                               AND (control_type_value_tab_(114) IS NULL)
                               AND (control_type_value_tab_(115) IS NULL)))THEN
      source_for_part_no_ := from_control_type_key_rec_;
      IF (posting_type_ IN ('M40', 'M281', 'M283')) THEN
      -- IF these event codes the should WIP account for parent part be used.
         IF (control_type_key_rec_.event_code_ IN ('SOISS','BACFLUSH','UNISS', 'MATCOST', 'PRODCOST', 'PRODCOST-',
                                                  'CO-BACFLSH','CO-SOISS', 'OOREC', 'SUNREC')) THEN
            source_for_part_no_ := from_shop_order_;
         ELSIF (control_type_key_rec_.event_code_ IN ('PSBKFL','RPSBKFL', 'PSRECEIVE')) THEN
            source_for_part_no_ := from_production_receipt_;
         ELSIF (control_type_key_rec_.event_code_ = 'MTRL-ADD') THEN
            IF (control_type_key_rec_.so_order_no_ IS NULL) THEN
               source_for_part_no_ := from_production_receipt_;
            ELSE
               source_for_part_no_ := from_shop_order_;
            END IF;
         END IF;
      ELSIF (posting_type_ = 'M15') THEN
         IF (control_type_key_rec_.event_code_ IN ('PURSHIP', 'CO-PURSHIP')) THEN
            source_for_part_no_ := from_purchase_order_line_;
         END IF;
      ELSIF (posting_type_ = 'M4') THEN
         IF (control_type_key_rec_.event_code_ IN ('PURTRAN')) THEN
            source_for_part_no_ := from_purchase_order_line_comp_;
         END IF;   
      END IF;

      IF (source_for_part_no_ = from_shop_order_) THEN
         $IF (Component_Shpord_SYS.INSTALLED) $THEN
            IF control_type_key_rec_.event_code_ = 'SOISS' AND control_type_key_rec_.so_order_no_ IS NULL THEN
               -- IF above is satisfied then we know we are simulating a posting for getting a
               -- Project_Cost_Element
               part_no_ := control_type_key_rec_.part_no_;
            ELSE
               part_no_ := Shop_Ord_API.Get_Part_No(control_type_key_rec_.so_order_no_,
                                                    control_type_key_rec_.so_release_no_,
                                                    control_type_key_rec_.so_sequence_no_);
               IF (part_no_ IS NULL) THEN
                  part_no_ := control_type_key_rec_.part_no_;   
               END IF;                                                    
            END IF;
         $ELSE            
            Error_SYS.Component_Not_Exist('SHPORD');
         $END
      ELSIF (source_for_part_no_ = from_production_receipt_) THEN
         $IF (Component_Prosch_SYS.INSTALLED) $THEN
            part_no_ := Production_Receipt_Manager_API.Get_Part_No_For_Receipt(control_type_key_rec_.ps_order_no_); 
         $ELSE
            Error_SYS.Component_Not_Exist('PROSCH');
         $END
      ELSIF (source_for_part_no_ = from_purchase_order_line_) THEN
         $IF (Component_Purch_SYS.INSTALLED) $THEN
            part_no_ := Purchase_Order_Line_Part_API.Get_Part_No(control_type_key_rec_.pur_order_no_,
                                                                 control_type_key_rec_.pur_line_no_,
                                                                 control_type_key_rec_.pur_release_no_);            
         $ELSE
            Error_SYS.Component_Not_Exist('PURCH');
         $END
      ELSIF (source_for_part_no_ = from_purchase_order_line_comp_) THEN
         $IF (Component_Invent_SYS.INSTALLED) $THEN
            part_no_ := Inventory_Transaction_Hist_API.Get_Part_No(control_type_key_rec_.transaction_id_);
         $ELSE
            Error_SYS.Component_Not_Exist('INVENT');
         $END   
      ELSE
         part_no_ := control_type_key_rec_.part_no_;
      END IF;
      
      $IF (Component_Invent_SYS.INSTALLED) $THEN
         Inventory_Part_API.Get_Values_For_Accounting(type_code_,
                                                      prime_commodity_,
                                                      second_commodity_,
                                                      asset_class_,
                                                      abc_class_,
                                                      engineering_group_,
                                                      planner_buyer_,
                                                      accounting_group_,
                                                      part_product_family_,
                                                      part_product_code_,
                                                      control_type_key_rec_.contract_,
                                                      part_no_);        

         control_type_value_tab_(6)  := type_code_;
         control_type_value_tab_(7)  := prime_commodity_;
         control_type_value_tab_(8)  := second_commodity_;
         control_type_value_tab_(9)  := asset_class_;
         control_type_value_tab_(10) := abc_class_;
         control_type_value_tab_(11) := engineering_group_;
         control_type_value_tab_(12) := planner_buyer_;
         control_type_value_tab_(32) := accounting_group_;
         control_type_value_tab_(49) := part_product_family_;
         control_type_value_tab_(50) := part_product_code_;
         control_type_value_tab_(113) := accounting_group_;
         control_type_value_tab_(114) := part_product_family_;
         control_type_value_tab_(115) := part_product_code_;
         
         part_fetched_ := TRUE;
         
      $ELSE
         Error_SYS.Component_Not_Exist('INVENT');
      $END
   END IF;

   IF (control_type_tab_(i_) = control_type_name_tab_(6)) THEN
      control_value_tab_(i_) := control_type_value_tab_(6);
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(7)) THEN
      control_value_tab_(i_) := control_type_value_tab_(7);
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(8)) THEN
      control_value_tab_(i_) := control_type_value_tab_(8);
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(9)) THEN
      control_value_tab_(i_) := control_type_value_tab_(9);
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(10)) THEN
      control_value_tab_(i_) := control_type_value_tab_(10);
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(11)) THEN
      control_value_tab_(i_) := control_type_value_tab_(11);
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(12)) THEN
      control_value_tab_(i_) := control_type_value_tab_(12);
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(32)) THEN
      control_value_tab_(i_) := control_type_value_tab_(32);
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(49)) THEN
      control_value_tab_(i_) := control_type_value_tab_(49);
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(50)) THEN
      control_value_tab_(i_) := control_type_value_tab_(50);
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(113)) THEN
      control_value_tab_(i_) := control_type_value_tab_(113);
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(114)) THEN
      control_value_tab_(i_) := control_type_value_tab_(114);
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(115)) THEN
      control_value_tab_(i_) := control_type_value_tab_(115);
   END IF;
END Get_Str_Code_Part___;

-- Get_Str_Code_Component_Part___
--   Get str code for Component Inventory Part.
PROCEDURE Get_Str_Code_Component_Part___ (
   component_part_fetched_ IN OUT BOOLEAN,
   control_type_value_tab_ IN OUT Control_Type_Value,
   control_value_tab_      IN OUT Posting_Ctrl_API.CtrlValTab,
   control_type_key_rec_   IN     Mpccom_Accounting_API.Control_Type_Key,
   i_                      IN     NUMBER,
   control_type_name_tab_  IN     Control_Type_Name,
   control_type_tab_       IN     Posting_Ctrl_API.CtrlTypTab)
IS
   planner_buyer_             VARCHAR2(20);
   type_code_                 VARCHAR2(2);
   prime_commodity_           VARCHAR2(5);
   second_commodity_          VARCHAR2(5);
   accounting_group_          VARCHAR2(5);
   part_product_family_       VARCHAR2(5);
   part_product_code_         VARCHAR2(5);
   asset_class_               VARCHAR2(2);
   abc_class_                 VARCHAR2(1);
   dummy_                     VARCHAR2(1); -- store NULL value.
BEGIN
   -- Component Part values
   IF ((NOT component_part_fetched_) AND
       (control_type_key_rec_.event_code_ IN ('SOISS', 'BACFLUSH', 'CO-BACFLSH', 'CO-SOISS', 'PSBKFL', 'CO-PSBKFL'))) THEN
                                                    
      $IF (Component_Invent_SYS.INSTALLED) $THEN
         Inventory_Part_API.Get_Values_For_Accounting(type_code_,
                                                      prime_commodity_,
                                                      second_commodity_,
                                                      asset_class_,
                                                      abc_class_,
                                                      dummy_,
                                                      planner_buyer_,
                                                      accounting_group_,
                                                      part_product_family_,
                                                      part_product_code_,
                                                      control_type_key_rec_.contract_,
                                                      control_type_key_rec_.part_no_);        

         control_type_value_tab_(118) := type_code_;
         control_type_value_tab_(119) := prime_commodity_;
         control_type_value_tab_(120) := second_commodity_;
         control_type_value_tab_(121) := asset_class_;
         control_type_value_tab_(122) := abc_class_;
         control_type_value_tab_(123) := planner_buyer_;
         control_type_value_tab_(124) := accounting_group_;
         control_type_value_tab_(125) := part_product_family_;
         control_type_value_tab_(126) := part_product_code_;
         
         component_part_fetched_ := TRUE;
         
      $ELSE
         Error_SYS.Component_Not_Exist('INVENT');
      $END
   END IF;
   
   IF (control_type_tab_(i_) = control_type_name_tab_(118)) THEN
      control_value_tab_(i_) := control_type_value_tab_(118);
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(119)) THEN
      control_value_tab_(i_) := control_type_value_tab_(119);
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(120)) THEN
      control_value_tab_(i_) := control_type_value_tab_(120);
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(121)) THEN
      control_value_tab_(i_) := control_type_value_tab_(121);
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(122)) THEN
      control_value_tab_(i_) := control_type_value_tab_(122);
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(123)) THEN
      control_value_tab_(i_) := control_type_value_tab_(123);
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(124)) THEN
      control_value_tab_(i_) := control_type_value_tab_(124);
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(125)) THEN
      control_value_tab_(i_) := control_type_value_tab_(125);
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(126)) THEN
      control_value_tab_(i_) := control_type_value_tab_(126);
   END IF;
END Get_Str_Code_Component_Part___;


-- Get_Str_Code_Purch___
--   Get str code for Purchase Order.
PROCEDURE Get_Str_Code_Purch___ (
   pur_fetched_            IN OUT BOOLEAN,
   control_type_value_tab_ IN OUT Control_Type_Value,
   control_value_tab_      IN OUT Posting_Ctrl_API.CtrlValTab,
   control_type_key_rec_   IN     Mpccom_Accounting_API.Control_Type_Key,
   i_                      IN     NUMBER,
   str_code_               IN     VARCHAR2,
   control_type_name_tab_  IN     Control_Type_Name,
   control_type_tab_       IN     Posting_Ctrl_API.CtrlTypTab )
IS   
BEGIN
   -- Purchase values
   IF NOT pur_fetched_ THEN            
      Get_Control_Type_Value_Pur1___(control_type_value_tab_, control_type_key_rec_, str_code_);
      Get_Control_Type_Value_Pur2___(control_type_value_tab_, control_type_key_rec_);
      Get_Control_Type_Value_Pur3___(control_type_value_tab_, control_type_key_rec_);
      pur_fetched_ := TRUE;
   END IF;

   IF (control_type_tab_(i_) = control_type_name_tab_(30)) THEN
      control_value_tab_(i_) := control_type_value_tab_(30);
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(33)) THEN
      control_value_tab_(i_) := control_type_value_tab_(33);
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(34)) THEN
      control_value_tab_(i_) := control_type_value_tab_(34);
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(35)) THEN
      control_value_tab_(i_) := control_type_value_tab_(35);
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(37)) THEN
      control_value_tab_(i_) := control_type_value_tab_(37);
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(38)) THEN
      control_value_tab_(i_) := control_type_value_tab_(38);
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(39)) THEN
      control_value_tab_(i_) := control_type_value_tab_(39);
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(40)) THEN
      control_value_tab_(i_) := control_type_value_tab_(40);
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(41)) THEN
      control_value_tab_(i_) := control_type_value_tab_(41);
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(42)) THEN
      control_value_tab_(i_) := control_type_value_tab_(42);
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(43)) THEN
      control_value_tab_(i_) := control_type_value_tab_(43);
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(82)) THEN
      control_value_tab_(i_) := control_type_value_tab_(82);
   END IF;
END Get_Str_Code_Purch___;


-- Get_Str_Code_Salespart___
--   Get str code for Sales Part.
PROCEDURE Get_Str_Code_Salespart___ (
   oesales_fetched_        IN OUT BOOLEAN,
   control_type_value_tab_ IN OUT Control_Type_Value,
   control_value_tab_      IN OUT Posting_Ctrl_API.CtrlValTab,
   control_type_key_rec_   IN     Mpccom_Accounting_API.Control_Type_Key,
   i_                      IN     NUMBER,
   control_type_name_tab_  IN     Control_Type_Name,
   control_type_tab_       IN     Posting_Ctrl_API.CtrlTypTab)
IS
   
BEGIN
   
   $IF (Component_Order_SYS.INSTALLED) $THEN
      BEGIN
         IF NOT oesales_fetched_ THEN      
            Order_Control_Type_Values_API.Get_Ctrl_Type_Value_Salespart(control_type_value_tab_, control_type_key_rec_);
            oesales_fetched_ := TRUE;                                                                         
         END IF;
      END;
   $ELSE
      Error_SYS.Component_Not_Exist('ORDER');
   $END
   
   IF (control_type_tab_(i_) = control_type_name_tab_(15)) THEN
      control_value_tab_(i_) := control_type_value_tab_(15);
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(17)) THEN
      control_value_tab_(i_) := control_type_value_tab_(17);
   END IF;
END Get_Str_Code_Salespart___;


-- Get_Str_Code_Vat___
--   Get str code for VAT.
PROCEDURE Get_Str_Code_Vat___ (
   vat_fetched_            IN OUT BOOLEAN,
   control_type_value_tab_ IN OUT Control_Type_Value,
   control_value_tab_      IN OUT Posting_Ctrl_API.CtrlValTab,
   control_type_key_rec_   IN     Mpccom_Accounting_API.Control_Type_Key,
   company_                IN     VARCHAR2,
   i_                      IN     NUMBER,
   control_type_name_tab_  IN     Control_Type_Name,
   control_type_tab_       IN     Posting_Ctrl_API.CtrlTypTab )
IS
   vat_code_ VARCHAR2(20);
BEGIN
   --  VAT values
   -- Do not use the "regular" boolean handling here since the extended controls
   -- in this method will take care of the situation.
   IF (control_type_tab_(i_) = control_type_name_tab_(64)) THEN
      Trace_SYS.Message('TRACE=> Vat from Customer Order Invoice Item for order line or for order charge line');
      $IF (Component_Order_SYS.INSTALLED) $THEN
         vat_code_ := Customer_Order_Inv_Item_API.Get_Vat_Code(company_,
                                                               control_type_key_rec_.oe_invoice_id_,
                                                               control_type_key_rec_.oe_invoice_item_id_); 
         control_type_value_tab_(64) := vat_code_;
      $ELSE
         Error_SYS.Component_Not_Exist('ORDER');
      $END
   ELSIF (control_type_tab_(i_) = control_type_name_tab_(59)) THEN
      Trace_SYS.Message('TRACE=> Vat from Customer Order Line');
      $IF (Component_Order_SYS.INSTALLED) $THEN
         control_type_value_tab_(59) := Tax_Handling_Order_Util_API.Get_First_Tax_Code(company_,
                                                                                       Tax_Source_API.DB_CUSTOMER_ORDER_LINE,
                                                                                       control_type_key_rec_.oe_order_no_,
                                                                                       control_type_key_rec_.oe_line_no_,
                                                                                       control_type_key_rec_.oe_rel_no_,
                                                                                       control_type_key_rec_.oe_line_item_no_); 
      $ELSE
         Error_SYS.Component_Not_Exist('ORDER');
      $END
      END IF;
   vat_fetched_ := TRUE;

   IF (control_type_tab_(i_) = control_type_name_tab_(59)) THEN
      control_value_tab_(i_) := control_type_value_tab_(59);
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(64)) THEN
      control_value_tab_(i_) := control_type_value_tab_(64);
   END IF;
END Get_Str_Code_Vat___;


-- Get_Str_Code_Rma___
--   Get str code for Return Material Authorization.
PROCEDURE Get_Str_Code_Rma___ (
   rma_fetched_            IN OUT BOOLEAN,
   control_type_value_tab_ IN OUT Control_Type_Value,
   control_value_tab_      IN OUT Posting_Ctrl_API.CtrlValTab,
   control_type_key_rec_   IN     Mpccom_Accounting_API.Control_Type_Key,
   i_                      IN     NUMBER,
   control_type_name_tab_  IN     Control_Type_Name,
   control_type_tab_       IN     Posting_Ctrl_API.CtrlTypTab )
IS
   line_fee_code_       VARCHAR2(20);
   charge_fee_code_     VARCHAR2(20);
   charge_type_         VARCHAR2(25);
   charge_group_        VARCHAR2(25);
   customer_group_      VARCHAR2(10);
   market_code_         VARCHAR2(10);
   salesman_code_       VARCHAR2(20);
   country_code_        VARCHAR2(10);
   region_code_         VARCHAR2(10);
   district_code_       VARCHAR2(10);
   sales_group_         VARCHAR2(10);
   return_reason_code_  VARCHAR2(10);
   delivery_terms_      VARCHAR2(5);
   ship_via_code_       VARCHAR2(3);
   currency_code_       VARCHAR2(3);
BEGIN
   -- Rma values
   IF NOT rma_fetched_ THEN
      $IF (Component_Order_SYS.INSTALLED) $THEN
         -- Use the general xxx_API.Get() to avoid use of multiple get-functions.
         DECLARE
            rma_rec_              Return_Material_API.Public_rec;
            rma_line_rec_         Return_Material_Line_API.Public_rec;
            rma_charge_rec_       Return_Material_Charge_API.Public_rec;
            customer_rec_         Cust_Ord_Customer_API.Public_rec;
            customer_address_rec_ Cust_Ord_Customer_Address_API.Public_rec;
         BEGIN
            rma_rec_       := Return_Material_API.Get(control_type_key_rec_.oe_rma_no_);
            currency_code_ := rma_rec_.currency_code;

            rma_line_rec_       := Return_Material_Line_API.Get(control_type_key_rec_.oe_rma_no_, control_type_key_rec_.oe_rma_line_no_);
            return_reason_code_ := rma_line_rec_.return_reason_code;
            line_fee_code_      := rma_line_rec_.fee_code;

            rma_charge_rec_  := Return_Material_Charge_API.Get(control_type_key_rec_.oe_rma_no_, control_type_key_rec_.oe_rma_charge_no_);
            charge_fee_code_ := rma_charge_rec_.fee_code;
            charge_type_     := rma_charge_rec_.charge_type;

            charge_group_ := Sales_Charge_Type_API.Get_Charge_Group(rma_charge_rec_.contract, rma_charge_rec_.charge_type);

            customer_rec_   := Cust_Ord_Customer_API.Get(rma_rec_.customer_no);
            customer_group_ := customer_rec_.cust_grp;
            market_code_    := customer_rec_.market_code;
            salesman_code_  := customer_rec_.salesman_code;

            customer_address_rec_ := Cust_Ord_Customer_Address_API.Get(rma_rec_.return_from_customer_no, rma_rec_.ship_addr_no);
            region_code_          := customer_address_rec_.region_code;
            district_code_        := customer_address_rec_.district_code;

            IF (rma_rec_.ship_addr_flag = 'N') THEN
               country_code_   := Cust_Ord_Customer_Address_API.Get_Country_Code(rma_rec_.return_from_customer_no, rma_rec_.ship_addr_no);
               delivery_terms_ := NVL(rma_rec_.delivery_terms, customer_address_rec_.delivery_terms);
               ship_via_code_  := NVL(rma_rec_.ship_via_code, customer_address_rec_.ship_via_code);
            ELSE
               country_code_   := rma_rec_.ship_addr_country_code;
               delivery_terms_ := rma_rec_.delivery_terms;
               ship_via_code_  := rma_rec_.ship_via_code;
            END IF;
            sales_group_ := Sales_Part_API.Get_Catalog_Group(rma_rec_.contract, rma_line_rec_.catalog_no);
         END;

         control_type_value_tab_(70) := currency_code_;
         control_type_value_tab_(72) := return_reason_code_;
         control_type_value_tab_(73) := line_fee_code_;
         control_type_value_tab_(76) := charge_fee_code_;
         control_type_value_tab_(74) := control_type_key_rec_.contract_ ||' | '|| charge_type_;
         control_type_value_tab_(75) := charge_group_;
         control_type_value_tab_(65) := customer_group_;
         control_type_value_tab_(67) := market_code_;
         control_type_value_tab_(71) := salesman_code_;
         control_type_value_tab_(66) := country_code_;
         control_type_value_tab_(68) := region_code_;
         control_type_value_tab_(69) := district_code_;
         control_type_value_tab_(77) := delivery_terms_;
         control_type_value_tab_(78) := ship_via_code_;
         control_type_value_tab_(79) := sales_group_;
      $ELSE
         Error_SYS.Component_Not_Exist('ORDER');
      $END
      rma_fetched_ := TRUE;
   END IF;

   IF (control_type_tab_(i_) = control_type_name_tab_(65)) THEN
      control_value_tab_(i_) := control_type_value_tab_(65);
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(66)) THEN
      control_value_tab_(i_) := control_type_value_tab_(66);
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(67)) THEN
      control_value_tab_(i_) := control_type_value_tab_(67);
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(68)) THEN
      control_value_tab_(i_) := control_type_value_tab_(68);
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(69)) THEN
      control_value_tab_(i_) := control_type_value_tab_(69);
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(70)) THEN
      control_value_tab_(i_) := control_type_value_tab_(70);
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(71)) THEN
      control_value_tab_(i_) := control_type_value_tab_(71);
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(72)) THEN
      control_value_tab_(i_) := control_type_value_tab_(72);
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(73)) THEN
      control_value_tab_(i_) := control_type_value_tab_(73);
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(74)) THEN
      control_value_tab_(i_) := control_type_value_tab_(74);
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(75)) THEN
      control_value_tab_(i_) := control_type_value_tab_(75);
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(76)) THEN
      control_value_tab_(i_) := control_type_value_tab_(76);
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(77)) THEN
      control_value_tab_(i_) := control_type_value_tab_(77);
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(78)) THEN
      control_value_tab_(i_) := control_type_value_tab_(78);
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(79)) THEN
      control_value_tab_(i_) := control_type_value_tab_(79);
   END IF;
END Get_Str_Code_Rma___;

-- Get_Str_Code_Work_Task___
--   Get str code for Work Order.
PROCEDURE Get_Str_Code_Work_Task___ (
   work_task_fetched_      IN OUT BOOLEAN,
   control_type_value_tab_ IN OUT Control_Type_Value,
   control_value_tab_      IN OUT Posting_Ctrl_API.CtrlValTab,
   control_type_key_rec_   IN     Mpccom_Accounting_API.Control_Type_Key,
   i_                      IN     NUMBER,
   control_type_name_tab_  IN     Control_Type_Name,
   control_type_tab_       IN     Posting_Ctrl_API.CtrlTypTab )
IS
   source_ref1_ VARCHAR2(50);
   source_ref2_ VARCHAR2(50);
   source_ref3_ VARCHAR2(50);
   source_ref4_ VARCHAR2(50);
   
$IF (Component_Wo_SYS.INSTALLED) $THEN
   control_rec_           Jt_Task_Accounting_Util_Api.control_values;
$END

BEGIN
   -- Work Task values
   IF NOT work_task_fetched_ THEN
     $IF (Component_Wo_SYS.INSTALLED) $THEN
         IF (control_type_key_rec_.wt_task_seq_ IS NULL) THEN
            source_ref1_ := control_type_key_rec_.wo_work_order_no_;
            source_ref2_ := control_type_key_rec_.wo_task_seq_;
            source_ref3_ := control_type_key_rec_.wo_mtrl_order_no_;
            source_ref4_ := control_type_key_rec_.wo_line_item_no_;
         ELSE
            source_ref1_ := NULL;
            source_ref2_ := control_type_key_rec_.wt_task_seq_;
            source_ref3_ := control_type_key_rec_.wt_mtrl_order_no_;
            source_ref4_ := control_type_key_rec_.wt_line_item_no_;
         END IF;
         control_rec_ := Jt_Task_Accounting_Util_Api.Get_Values_For_Accounting(source_ref1_        => source_ref1_,
                                                                               source_ref2_        => source_ref2_,
                                                                               source_ref3_        => source_ref3_,
                                                                               source_ref4_        => source_ref4_,
                                                                               inv_transaction_id_ => control_type_key_rec_.transaction_id_); 
         control_type_value_tab_(51) := control_rec_.call_code;
         control_type_value_tab_(52) := control_rec_.equip_group_id;
         control_type_value_tab_(53) := control_rec_.vendor_no;
         control_type_value_tab_(54) := control_rec_.work_type_id;
         control_type_value_tab_(55) := control_rec_.org_and_site;
         control_type_value_tab_(106) := control_rec_.cost_code;
      $ELSE
         Error_SYS.Component_Not_Exist('WO');
      $END
      work_task_fetched_ := TRUE;
   END IF;

   IF (control_type_tab_(i_) = control_type_name_tab_(51)) THEN
      control_value_tab_(i_) := control_type_value_tab_(51);
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(52)) THEN
      control_value_tab_(i_) := control_type_value_tab_(52);
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(53)) THEN
      control_value_tab_(i_) := control_type_value_tab_(53);
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(54)) THEN
      control_value_tab_(i_) := control_type_value_tab_(54);
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(55)) THEN
      control_value_tab_(i_) := control_type_value_tab_(55);
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(106)) THEN
      control_value_tab_(i_) := control_type_value_tab_(106);
   END IF;
END Get_Str_Code_Work_Task___;

-- Init_Control_Type_Name_Tab___
--   Initialize global control_type_name_tab_.
PROCEDURE Init_Control_Type_Name_Tab___ (
   control_type_name_tab_  IN OUT Control_Type_Name )
IS
   control_type_ VARCHAR2(10);
BEGIN
-- Initialize the table with all other control types C2 - C99.
   FOR i_ IN 1..199 LOOP
      control_type_ := 'C'||to_char(i_);
      control_type_name_tab_(i_) := control_type_;
   END LOOP;

   control_type_name_tab_(1)   := 'AC1';
   control_type_name_tab_(3)   := 'AC2';
   control_type_name_tab_(4)   := 'AC8';
   control_type_name_tab_(25)  := 'AC7';
   control_type_name_tab_(101) := 'PR6'; 
   control_type_name_tab_(102) := 'PR8'; 
   control_type_name_tab_(103) := 'PR9';
   control_type_name_tab_(112) := 'AC22';
END Init_Control_Type_Name_Tab___;

PROCEDURE Init_Control_Type_Value_Tab___(
   control_type_value_tab_ IN OUT  Control_Type_Value)
IS     
BEGIN
   FOR i_ IN 1..199 LOOP
      control_type_value_tab_(i_) := NULL;
   END LOOP;
END Init_Control_Type_Value_Tab___;

-- Modify_Source_Record___
--   Modify status code on source LU.
PROCEDURE Modify_Source_Record___ (
   accounting_id_  IN NUMBER,
   booking_source_ IN VARCHAR2 )
IS
BEGIN
   --status updates are made only for purchase transactions.
   IF (booking_source_ = Mpccom_Transaction_Source_API.DB_PURCHASE) THEN
      $IF Component_Purch_SYS.INSTALLED $THEN
         Purchase_Transaction_Hist_API.Modify_Status_Code_Acc(accounting_id_,
                                                              Transaction_History_Status_API.Decode('99'));
      $ELSE
         Error_SYS.Component_Not_Exist('PURCH');
      $END
      END IF;
END Modify_Source_Record___;


-- Get_Str_Code_Purpart___
--   Get string code for Purchase Part.
PROCEDURE Get_Str_Code_Purpart___ (
   purpart_fetched_        IN OUT BOOLEAN,
   control_type_value_tab_ IN OUT Control_Type_Value,
   control_value_tab_      IN OUT Posting_Ctrl_API.CtrlValTab,
   control_type_key_rec_   IN     Mpccom_Accounting_API.Control_Type_Key,
   i_                      IN     NUMBER,
   control_type_name_tab_  IN     Control_Type_Name,
   control_type_tab_       IN     Posting_Ctrl_API.CtrlTypTab )
IS
BEGIN
   -- Purchase part values
   IF NOT purpart_fetched_ THEN
      IF control_type_key_rec_.part_no_ IS NOT NULL THEN
         -- Purchase Order is of type: Part.
         $IF (Component_Purch_SYS.INSTALLED) $THEN
            control_type_value_tab_(31) := Purchase_Part_API.Get_Stat_Grp(control_type_key_rec_.contract_,
                                                                          control_type_key_rec_.part_no_);            
         $ELSE
            Error_SYS.Component_Not_Exist('PURCH');
         $END
      ELSE
         -- Purchase Order is of type: No Part.
         $IF (Component_Purch_SYS.INSTALLED) $THEN
            control_type_value_tab_(31) := Purchase_Order_Line_Nopart_API.Get_Stat_Grp(control_type_key_rec_.pur_order_no_,
                                                                                       control_type_key_rec_.pur_line_no_,
                                                                                       control_type_key_rec_.pur_release_no_ );                   
         $ELSE
            Error_SYS.Component_Not_Exist('PURCH');
         $END
         END IF;
      purpart_fetched_ := TRUE;
   END IF;

   IF (control_type_tab_(i_) = control_type_name_tab_(31)) THEN
      control_value_tab_(i_) := control_type_value_tab_(31);
   END IF;
END Get_Str_Code_Purpart___;

-- Get_Str_Code_Purcharge___
--   Get str code for Purchase Order Charge.
PROCEDURE Get_Str_Code_Purcharge___ (
   purcharge_fetched_      IN OUT BOOLEAN,
   control_type_value_tab_ IN OUT Control_Type_Value,
   control_value_tab_      IN OUT Posting_Ctrl_API.CtrlValTab,
   control_type_key_rec_   IN     Mpccom_Accounting_API.Control_Type_Key,
   i_                      IN     NUMBER,
   control_type_name_tab_  IN     Control_Type_Name,
   control_type_tab_       IN     Posting_Ctrl_API.CtrlTypTab )
IS
   charge_type_       VARCHAR2(35);
BEGIN
   -- Purchase charge values
   IF NOT purcharge_fetched_ THEN
      $IF (Component_Purch_SYS.INSTALLED) $THEN
         -- Cannot use Purchase_Order_Charge_API.Get here since charge_group is not actually an attribute of this LU.
         charge_type_  := Purchase_Order_Charge_API.Get_Charge_Type(control_type_key_rec_.pur_order_no_, control_type_key_rec_.pur_charge_seq_no_);
         control_type_value_tab_(61) := Purchase_Charge_Type_API.Get_Charge_Group(Purchase_Order_API.Get_Contract(control_type_key_rec_.pur_order_no_), charge_type_);                 
         control_type_value_tab_(60) := charge_type_;
      $ELSE
         Error_SYS.Component_Not_Exist('PURCH');
      $END
      purcharge_fetched_ := TRUE;
   END IF;

   IF (control_type_tab_(i_) = control_type_name_tab_(60)) THEN
      control_value_tab_(i_) := control_type_value_tab_(60);
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(61)) THEN
      control_value_tab_(i_) := control_type_value_tab_(61);
   END IF;
END Get_Str_Code_Purcharge___;

-- Get_Str_Code_Dop___
--   Get str code for DOP. Method is required for the
--   financial functionality for DOP.
PROCEDURE Get_Str_Code_Dop___ (
   dop_fetched_            IN OUT BOOLEAN,
   control_type_value_tab_ IN OUT Control_Type_Value,
   control_value_tab_      IN OUT Posting_Ctrl_API.CtrlValTab,
   control_type_key_rec_   IN     Mpccom_Accounting_API.Control_Type_Key,
   i_                      IN     NUMBER,
   control_type_name_tab_  IN     Control_Type_Name,
   control_type_tab_       IN     Posting_Ctrl_API.CtrlTypTab )
IS
BEGIN
   IF NOT dop_fetched_ THEN      
      Get_Control_Type_Value_Dop___ (control_type_value_tab_, control_type_key_rec_);
      dop_fetched_ := TRUE;
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(56)) THEN
      control_value_tab_(i_) := control_type_value_tab_(56);
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(57)) THEN
      control_value_tab_(i_) := control_type_value_tab_(57);
   END IF;
END Get_Str_Code_Dop___;

-- Get_Control_Type_Value_Dop___
--   Gets control type value from DOP. Method is required for the
--   financial functionality for DOP.
PROCEDURE Get_Control_Type_Value_Dop___ (
   control_type_value_tab_ IN OUT Control_Type_Value,
   control_type_key_rec_   IN     Mpccom_Accounting_API.Control_Type_Key)
IS
BEGIN
   $IF (Component_Dop_SYS.INSTALLED) $THEN      
      Dop_Head_API.Get_Values_For_Accounting(control_type_value_tab_(56), control_type_value_tab_(57), control_type_key_rec_); 
   $ELSE
      Error_SYS.Component_Not_Exist('DOP');
   $END
END Get_Control_Type_Value_Dop___;

-- Prepare_Rma_Order_Keys___
--   Method to get hold of the Customer Order keys from Rma keys.
--   Needed to be able to find control type values from a customer order
--   as well as from an RMA when the RMA is the calling source
PROCEDURE Prepare_Rma_Order_Keys___ (
   oe_order_no_     OUT VARCHAR2,
   oe_line_no_      OUT VARCHAR2,
   oe_rel_no_       OUT VARCHAR2,
   oe_line_item_no_ OUT NUMBER,
   oe_rma_no_       IN  NUMBER,
   oe_rma_line_no_  IN  NUMBER )
IS
BEGIN  
   $IF (Component_Order_SYS.INSTALLED) $THEN
      -- Use Return_Material_Line_API.Get() to avoid use of multiple get-functions.
      DECLARE
         return_material_line_rec_    Return_Material_Line_API.Public_rec;
      BEGIN
         return_material_line_rec_ := Return_Material_Line_API.Get(oe_rma_no_, oe_rma_line_no_);
         oe_order_no_     := return_material_line_rec_.order_no;
         oe_line_no_      := return_material_line_rec_.line_no;
         oe_rel_no_       := return_material_line_rec_.rel_no;
         oe_line_item_no_ := return_material_line_rec_.line_item_no;
      END;
   $ELSE
      Error_SYS.Component_Not_Exist('ORDER');
   $END      
END Prepare_Rma_Order_Keys___;

-- Get_Str_Code_Oeaddress___
--   Get str code for Customer Order Line Country Code
PROCEDURE Get_Str_Code_Oeaddress___ (
   oeaddress_fetched_      IN OUT BOOLEAN,
   control_type_value_tab_ IN OUT Control_Type_Value,
   control_value_tab_      IN OUT Posting_Ctrl_API.CtrlValTab,
   control_type_key_rec_   IN     Mpccom_Accounting_API.Control_Type_Key,
   i_                      IN     NUMBER,
   control_type_name_tab_  IN     Control_Type_Name,
   control_type_tab_       IN     Posting_Ctrl_API.CtrlTypTab )
IS
BEGIN
   $IF (Component_Order_SYS.INSTALLED) $THEN
      BEGIN
         IF NOT oeaddress_fetched_ THEN
            Order_Control_Type_Values_API.Get_Ctrl_Type_Value_Coaddress(control_type_value_tab_, control_type_key_rec_);
            oeaddress_fetched_ := TRUE;  
         END IF;
      END;
   $ELSE
      Error_SYS.Component_Not_Exist('ORDER');
   $END
   
   IF (control_type_tab_(i_) = control_type_name_tab_(18)) THEN
      control_value_tab_(i_) := control_type_value_tab_(18);
   END IF;
END Get_Str_Code_Oeaddress___;


-- Set_Inventory_Value_Status___
--   Set the value of inventory_value_status to 'INCLUDED'.
--   Should be called when a record has been included in the calculation for
--   inventory value.
PROCEDURE Set_Inventory_Value_Status___ (
   accounting_id_ IN NUMBER,
   seq_           IN NUMBER )
IS
   record_     MPCCOM_ACCOUNTING_TAB%ROWTYPE;
BEGIN
   record_ := Lock_By_Keys___(accounting_id_, seq_);
   record_.inventory_value_status := Inventory_Value_Status_API.DB_INCLUDED;
   Modify___(record_);
END Set_Inventory_Value_Status___;


-- Redo_Error_Postings___
--   Recreate all postings for the specified site and booking_source which
--   have received an error status.
--   The last_date_applied_ parameter can be used to restrict the recreation
--   to only postings with date_applied <= last_date_applied_.
PROCEDURE Redo_Error_Postings___ (
   contract_          IN VARCHAR2,
   booking_source_    IN VARCHAR2,
   last_date_applied_ IN DATE DEFAULT NULL )
IS
   company_       VARCHAR2(20);
   no_booking_    EXCEPTION;

   CURSOR get_error_accountings IS
      SELECT DISTINCT accounting_id
      FROM   MPCCOM_ACCOUNTING_TAB
      WHERE  booking_source = booking_source_
      AND    contract = contract_
      AND    date_applied <= NVL(last_date_applied_, date_applied)
      AND    status_code = '99';
BEGIN

   -- For now only INVENTORY, LABOR, OPERATION and SO GENERAL postings may be recreated by this method
   IF booking_source_ NOT IN (Mpccom_Transaction_Source_API.DB_INVENTORY,
                              Mpccom_Transaction_Source_API.DB_LABOR,
                              Mpccom_Transaction_Source_API.DB_OPERATION,
                              Mpccom_Transaction_Source_API.DB_SHOP_ORDER_GENERAL,
                              Mpccom_Transaction_Source_API.DB_INDIRECT_LABOR,
                              Mpccom_Transaction_Source_API.DB_RENTAL,
                              Mpccom_Transaction_Source_API.DB_FIELD_SERVICE_MANAGEMENT) THEN
      Error_SYS.Record_General('MpccomAccounting','REDO_NYI: Fatal Error. Redo_Error_Postings___ not yet implemented for booking_source :P1.', booking_source_);
   END IF;

   company_       := Site_API.Get_Company(contract_);

   FOR next_accounting_ IN get_error_accountings LOOP
      IF (booking_source_ = Mpccom_Transaction_Source_API.DB_INVENTORY) THEN
         $IF Component_Invent_SYS.INSTALLED $THEN
            Inventory_Transaction_Hist_API.Redo_Error_Booking(next_accounting_.accounting_id,
                                                              company_);
         $ELSE
            Error_SYS.Component_Not_Exist('INVENT');
         $END
      ELSIF (booking_source_ IN (Mpccom_Transaction_Source_API.DB_LABOR, 
                                 Mpccom_Transaction_Source_API.DB_OPERATION)) THEN
         $IF Component_Mfgstd_SYS.INSTALLED $THEN
            Operation_History_Util_API.Redo_Error_Booking(next_accounting_.accounting_id,
                                                          company_);

         $ELSE
            Error_SYS.Component_Not_Exist('MFGSTD');
         $END
      ELSIF (booking_source_ = Mpccom_Transaction_Source_API.DB_SHOP_ORDER_GENERAL) THEN
         $IF Component_Shpord_SYS.INSTALLED $THEN
            Shop_Order_Oh_History_API.Redo_Error_Booking(next_accounting_.accounting_id,
                                                         company_);               

         $ELSE
            Error_SYS.Component_Not_Exist('SHPORD');
         $END
      ELSIF (booking_source_ = Mpccom_Transaction_Source_API.DB_INDIRECT_LABOR) THEN
         $IF Component_Shpord_SYS.INSTALLED $THEN
            Indirect_Labor_History_API.Redo_Error_Booking(next_accounting_.accounting_id,
                                                         company_);                 
         $ELSE
            Error_SYS.Component_Not_Exist('SHPORD');
         $END
      ELSIF (booking_source_ = Mpccom_Transaction_Source_API.DB_RENTAL) THEN
         $IF Component_Rental_SYS.INSTALLED $THEN
            Rental_Transaction_API.Redo_Error_Booking(next_accounting_.accounting_id,
                                                      company_); 
         $ELSE
            Error_SYS.Component_Not_Exist('RENTAL');
         $END
      ELSIF (booking_source_ = Mpccom_Transaction_Source_API.DB_FIELD_SERVICE_MANAGEMENT) THEN
         $IF Component_Fsmapp_SYS.INSTALLED $THEN
            Fsm_Transaction_Hist_API.Redo_Error_Booking(next_accounting_.accounting_id,
                                                        company_); 
         $ELSE
            Error_SYS.Component_Not_Exist('FSMAPP');
         $END
      ELSE   
         RAISE no_booking_;
      END IF;
   END LOOP;

   Refresh_Activity_Info___(contract_, booking_source_,FALSE,NULL);

EXCEPTION
   WHEN no_booking_ THEN
      NULL;
END Redo_Error_Postings___;


-- Transfer_To_Finance___
--   Implements the actual transfer of postings to Finance.
PROCEDURE Transfer_To_Finance___ (
   contract_       IN VARCHAR2,
   date_applied_   IN DATE,
   booking_source_ IN VARCHAR2 )
IS
    transfer_id_           VARCHAR2(20);
    previous_date_applied_ DATE;
    voucher_type_          VARCHAR2(30);
    voucher_no_            NUMBER;
    voucher_id_            VARCHAR2(300);
    dummy_                 VARCHAR2(30);
    accounting_year_       NUMBER;
    accounting_period_     NUMBER;
    company_               VARCHAR2(20);
    user_group_            VARCHAR2(50);
    voucher_needs_closing_ BOOLEAN;
    transfer_initiated_    BOOLEAN;
    transaction_code_      VARCHAR2(10);
    order_no_              VARCHAR2(50);
    quantity_              NUMBER;
    result_code_           VARCHAR2(80);
    function_group_        VARCHAR2(10);
    order_type_            VARCHAR2(20);
    activity_transferred_  BOOLEAN;
    object_conn_handling_  VARCHAR2(10) := 'NOT CREATE';
    transfer_posting_      BOOLEAN;
    first_calendar_date_   DATE  := Database_SYS.first_calendar_date_;
    matching_info_         VARCHAR2(200);

   -- Make sure no error postings exist for this accounting
   -- therefore the not exists filter
   CURSOR get_accountings (contract_     IN VARCHAR2,
                           date_applied_ IN DATE ) IS
      SELECT DISTINCT acc1.date_applied, acc1.accounting_id
      FROM   MPCCOM_ACCOUNTING_TAB acc1
      WHERE  acc1.date_applied  <= trunc(date_applied_)
      AND    acc1.contract       = contract_
      AND    acc1.booking_source = booking_source_
      AND    acc1.status_code    = '2'
      AND    NOT EXISTS (SELECT 1 FROM MPCCOM_ACCOUNTING_TAB acc2
                         WHERE acc2.accounting_id = acc1.accounting_id
                         AND   acc2.status_code = '99')
      ORDER BY acc1.date_applied, acc1.accounting_id;

   TYPE Accounting_Tab_Type IS TABLE OF get_accountings%ROWTYPE
     INDEX BY PLS_INTEGER;

   accnt_tab_ Accounting_Tab_Type;
BEGIN

   transfer_initiated_    := FALSE;
   voucher_id_            := '';
   voucher_needs_closing_ := FALSE;
   previous_date_applied_ := first_calendar_date_;
   company_               := Site_API.Get_Company(contract_);
   user_group_            := User_Group_Member_Finance_API.Get_User_Group(company_,
                                                           Fnd_Session_API.Get_Fnd_User);

   IF (booking_source_ NOT IN (Mpccom_Transaction_Source_API.DB_INVENTORY,
                               Mpccom_Transaction_Source_API.DB_LABOR,
                               Mpccom_Transaction_Source_API.DB_OPERATION,
                               Mpccom_Transaction_Source_API.DB_SHOP_ORDER_GENERAL,
                               Mpccom_Transaction_Source_API.DB_INDIRECT_LABOR,
                               Mpccom_Transaction_Source_API.DB_RENTAL,
                               Mpccom_Transaction_Source_API.DB_FIELD_SERVICE_MANAGEMENT
                               )) THEN
      Error_SYS.Record_General(lu_name_, 'BSOURCEERR: Method Transfer_To_Finance___ is not yet supporting booking source :P1. Contact system support.', booking_source_);
   END IF;
   function_group_ := Get_Function_Group___(booking_source_);

   OPEN get_accountings(contract_, date_applied_);
   FETCH get_accountings BULK COLLECT INTO accnt_tab_;
   CLOSE get_accountings;

   IF accnt_tab_.COUNT > 0 THEN
      FOR i_ IN accnt_tab_.FIRST .. accnt_tab_.LAST LOOP

         transfer_posting_ := TRUE;

         IF NOT (transfer_initiated_) THEN
            Voucher_API.Transfer_Init(transfer_id_, company_);
            transfer_initiated_ := TRUE;
         END IF;

         IF (NOT Check_Postings_In_Balance(accnt_tab_(i_).accounting_id)) THEN
            Update_Error_Status(accnt_tab_(i_).accounting_id);
         ELSE
            IF (accnt_tab_(i_).date_applied != previous_date_applied_) THEN
               previous_date_applied_ := accnt_tab_(i_).date_applied;
               IF (voucher_needs_closing_) THEN
                  Voucher_API.Voucher_End(voucher_id_,TRUE,object_conn_handling_);
                  @ApproveTransactionStatement(2012-01-25,GanNLK)
                  COMMIT;
                  object_conn_handling_ := 'NOT CREATE';
                  voucher_needs_closing_ := FALSE;
               END IF;
               -- This block of code has the purpose of finding the correct voucher type. --
               User_Group_Period_API.Get_Period(accounting_year_,
                                                accounting_period_,
                                                company_,
                                                user_group_,
                                                accnt_tab_(i_).date_applied);

               Voucher_Type_User_Group_API.Get_Default_Voucher_Type(voucher_type_,
                                                                    company_,
                                                                    user_group_,
                                                                    accounting_year_,
                                                                    function_group_);
               voucher_no_        := 0;
               voucher_id_        := to_char(NULL);
               accounting_year_   := to_number(NULL);
               accounting_period_ := to_number(NULL);
               Voucher_Api.New_Voucher(voucher_type_        => voucher_type_,
                                       voucher_no_          => voucher_no_,
                                       voucher_id_          => voucher_id_,
                                       accounting_year_     => accounting_year_,
                                       accounting_period_   => accounting_period_,
                                       company_             => company_,
                                       transfer_id_         => transfer_id_,
                                       voucher_date_        => accnt_tab_(i_).date_applied,
                                       voucher_group_       => function_group_,
                                       user_group_          => dummy_,
                                       correction_          => 'N',
                                       voucher_type_ref_    => TO_CHAR(NULL),
                                       accounting_year_ref_ => TO_NUMBER(NULL),
                                       voucher_no_ref_      => TO_NUMBER(NULL));

               voucher_needs_closing_ := TRUE;
            END IF;
            IF (booking_source_ = Mpccom_Transaction_Source_API.DB_INVENTORY) THEN
               $IF Component_Invent_SYS.INSTALLED $THEN
                  DECLARE
                     transaction_id_ NUMBER;
                     invtrans_rec_   Inventory_Transaction_Hist_API.Public_Rec;
                  BEGIN
                     transaction_id_   := Inventory_Transaction_Hist_API.Get_Transaction_Id_For_Accting(accnt_tab_(i_).accounting_id);
                     invtrans_rec_     := Inventory_Transaction_Hist_API.Get(transaction_id_);
                     transaction_code_ := invtrans_rec_.transaction_code;
                     order_no_         := invtrans_rec_.source_ref1;
                     quantity_         := invtrans_rec_.quantity;
                     order_type_       := invtrans_rec_.source_ref_type;
                     matching_info_    := Get_Suppl_Invoic_Matching_Info___(invtrans_rec_.source_ref1,
                                                                            invtrans_rec_.source_ref2,
                                                                            invtrans_rec_.source_ref3,
                                                                            invtrans_rec_.source_ref_type,
                                                                            invtrans_rec_.alt_source_ref1,
                                                                            invtrans_rec_.alt_source_ref2,
                                                                            invtrans_rec_.alt_source_ref3,
                                                                            invtrans_rec_.alt_source_ref_type);
                  END;
               $ELSE
                  Error_SYS.Component_Not_Exist('INVENT');
               $END
            ELSIF (booking_source_ IN (Mpccom_Transaction_Source_API.DB_LABOR,
                                       Mpccom_Transaction_Source_API.DB_OPERATION)) THEN
               $IF Component_Mfgstd_SYS.INSTALLED $THEN
                  Operation_History_Util_API.Prepare_Transfer_To_Finance(transaction_code_,
                                                                         order_no_,
                                                                         quantity_,
                                                                         order_type_,
                                                                         contract_,
                                                                         booking_source_,
                                                                         accnt_tab_(i_).accounting_id);
                  IF (transaction_code_ IS NULL) THEN
                     transfer_posting_ := FALSE;
                  END IF;
                  IF (Get_Sum_Value(accnt_tab_(i_).accounting_id, 'M40') < 0) THEN
                     quantity_ := quantity_ * -1;
                  END IF;
               $ELSE
                  Error_SYS.Component_Not_Exist('MFGSTD');
               $END

            ELSIF (booking_source_ = Mpccom_Transaction_Source_API.DB_SHOP_ORDER_GENERAL) THEN
               $IF Component_Shpord_SYS.INSTALLED $THEN
                  Shop_Ord_Transaction_Util_API.Prepare_Transfer_To_Finance(transaction_code_,
                                                                            order_no_,
                                                                            quantity_,
                                                                            order_type_,
                                                                            contract_,
                                                                            booking_source_,
                                                                            accnt_tab_(i_).accounting_id);
                  IF (Get_Sum_Value(accnt_tab_(i_).accounting_id, 'M40') < 0) THEN
                     quantity_ := quantity_ * -1;
                  END IF;
               $ELSE
                  Error_SYS.Component_Not_Exist('SHPORD');
               $END
            ELSIF (booking_source_ = Mpccom_Transaction_Source_API.DB_INDIRECT_LABOR) THEN
               $IF Component_Shpord_SYS.INSTALLED $THEN
                  Shop_Ord_Transaction_Util_API.Prepare_Transfer_To_Finance(transaction_code_,
                                                                            order_no_,
                                                                            quantity_,
                                                                            order_type_,
                                                                            contract_,
                                                                            booking_source_,
                                                                            accnt_tab_(i_).accounting_id);
                  IF (transaction_code_ IS NULL) THEN
                     transfer_posting_ := FALSE;
                  END IF;
                  -- Set quantity negative for reversal transactions
                  IF (Get_Sum_Value(accnt_tab_(i_).accounting_id, 'M209') < 0) THEN
                     quantity_ := quantity_ * -1;
                  END IF;
               $ELSE
                  Error_SYS.Component_Not_Exist('SHPORD');
               $END
            ELSIF (booking_source_ = Mpccom_Transaction_Source_API.DB_RENTAL) THEN
               $IF Component_Rental_SYS.INSTALLED $THEN
                  Rental_Transaction_Manager_API.Prepare_Transfer_To_Finance(transaction_code_,
                                                                             order_no_,
                                                                             quantity_,
                                                                             order_type_,
                                                                             accnt_tab_(i_).accounting_id);
                  IF (transaction_code_ IS NULL) THEN
                     transfer_posting_ := FALSE;
                  END IF;
               $ELSE
                  Error_SYS.Component_Not_Exist('RENTAL');
               $END
            ELSIF (booking_source_ = Mpccom_Transaction_Source_API.DB_FIELD_SERVICE_MANAGEMENT) THEN
               $IF Component_Fsmapp_SYS.INSTALLED $THEN
                  Fsm_Transaction_Hist_API.Prepare_Transfer_To_Finance(transaction_code_,
                                                                       order_no_,
                                                                       quantity_,
                                                                       order_type_,
                                                                       accnt_tab_(i_).accounting_id);
                  IF (transaction_code_ IS NULL) THEN
                     transfer_posting_ := FALSE;
                  END IF;
               $ELSE
                  Error_SYS.Component_Not_Exist('FSMAPP');
               $END   
            END IF;
            IF (transfer_posting_) THEN
               Accounting_Transfer(result_code_,
                                   activity_transferred_,
                                   accnt_tab_(i_).accounting_id,
                                   voucher_type_,
                                   voucher_no_,
                                   accounting_year_,
                                   accounting_period_,
                                   Mpccom_Transaction_Code_API.Get_Transaction(transaction_code_),
                                   order_no_,
                                   quantity_,
                                   transfer_id_,
                                   voucher_id_,
                                   accnt_tab_(i_).date_applied,
                                   order_type_,
                                   vendor_no_ => NULL,
                                   party_type_db_ => NULL,
                                   matching_info_ => matching_info_);
               IF (activity_transferred_) THEN
                  object_conn_handling_ := 'CREATE';
               END IF;
            END IF;
         END IF;
         -- Method executed on a background job.
         @ApproveTransactionStatement(2009-10-21,kayolk)
         COMMIT;
      END LOOP;

      IF ((transfer_initiated_) AND (voucher_needs_closing_)) THEN
         Voucher_Api.Voucher_End(voucher_id_, TRUE, object_conn_handling_);
         @ApproveTransactionStatement(2012-01-25,GanNLK)
         COMMIT;
      END IF;

      Refresh_Activity_Info___(contract_, booking_source_, TRUE, date_applied_);
   END IF; 
END Transfer_To_Finance___;


-- Is_Work_Task_Posting___
--   Return TRUE if a posting is connected to a work order material issue
--   or unissue, else return FALSE.
FUNCTION Is_Work_Task_Posting___ (
   str_code_      IN VARCHAR2,
   accounting_id_ IN NUMBER) RETURN BOOLEAN
IS
   work_task_posting_   BOOLEAN := FALSE;
BEGIN
   IF (str_code_ IN ('M50', 'M51', 'M144', 'M207', 'M208', 'M261')) THEN
      work_task_posting_ := TRUE;
   ELSIF (str_code_ IN ('M217', 'M224', 'M253', 'M255')) THEN
      $IF (Component_Rental_SYS.INSTALLED) $THEN
         work_task_posting_ :=  Rental_Transaction_API.Is_Work_Order_Posting(accounting_id_);
      $ELSE
         NULL;
      $END
   END IF;
   RETURN work_task_posting_;
END Is_Work_Task_Posting___;

PROCEDURE Prepare_Codestring_Rec___ (
   codestr_rec_ OUT Accounting_Codestr_API.CodestrRec,
   newrec_      IN MPCCOM_ACCOUNTING_TAB%ROWTYPE)
IS
BEGIN
   codestr_rec_.code_a := newrec_.account_no;
   codestr_rec_.code_b := newrec_.codeno_b;
   codestr_rec_.code_c := newrec_.codeno_c;
   codestr_rec_.code_d := newrec_.codeno_d;
   codestr_rec_.code_e := newrec_.codeno_e;
   codestr_rec_.code_f := newrec_.codeno_f;
   codestr_rec_.code_g := newrec_.codeno_g;
   codestr_rec_.code_h := newrec_.codeno_h;
   codestr_rec_.code_i := newrec_.codeno_i;
   codestr_rec_.code_j := newrec_.codeno_j;
   codestr_rec_.project_activity_id := newrec_.activity_seq;
END Prepare_Codestring_Rec___;

-- Send_Posting_To_Pcm___
--   Notify PCM when a new material posting has been created or when
--   a posting has been updated.
PROCEDURE Send_Posting_To_Pcm___ (
   newrec_     IN MPCCOM_ACCOUNTING_TAB%ROWTYPE,
   ctrl_flag_  IN VARCHAR2 )
IS
   transaction_id_     NUMBER;
   exit_procedure      EXCEPTION;
   codestr_rec_        Accounting_Codestr_API.CodestrRec;
   
$IF (Component_Invent_SYS.INSTALLED) $THEN
   invtrans_rec_       Inventory_Transaction_Hist_API.Public_Rec;
$END

BEGIN
   Trace_SYS.Message('Dynamic call to RentalTransaction');
   IF (newrec_.event_code IN ('WORENT+', 'WORENT-', 'WTRENT+', 'WTRENT-', 'RENTIN+', 'RENTIN-', 'RENTIN-NI+',
                              'RENTIN-NI-', 'INTRNTCOS+', 'INTRNTCOS-', 'INTRNTCNI+', 'INTRNTCNI-')) THEN      
      $IF (Component_Rental_SYS.INSTALLED) $THEN
         transaction_id_ := Rental_Transaction_API.Get_Trans_Id_For_Accounting(newrec_.accounting_id);
      $ELSE
         NULL;
      $END 
      IF (transaction_id_ IS NULL) THEN
         RAISE exit_procedure;
      END IF;
      $IF (Component_Wo_SYS.INSTALLED) $THEN           
         Jt_Task_Cost_Line_Util_API.Handle_Rental_Cost(transaction_id_,
                                                       newrec_.accounting_id,
                                                       newrec_.seq,
                                                       newrec_.activity_seq,
                                                       newrec_.str_code,
                                                       newrec_.value,
                                                       ctrl_flag_,
                                                       newrec_.voucher_type,
                                                       newrec_.voucher_no,
                                                       newrec_.accounting_year,
                                                       newrec_.accounting_period,
                                                       newrec_.date_applied,
                                                       newrec_.debit_credit);      
      $ELSE
         NULL;
      $END
   ELSE  
      -- Retrive the Work Order keys from the inventory transaction
      Trace_SYS.Message('Dynamic call to InventoryTransactionHistory');
      $IF (Component_Invent_SYS.INSTALLED) $THEN
            transaction_id_ := Inventory_Transaction_Hist_API.Get_Transaction_Id_For_Accting(newrec_.accounting_id);
            invtrans_rec_   := Inventory_Transaction_Hist_API.Get(transaction_id_);
         IF (transaction_id_ IS NULL) THEN
            RAISE exit_procedure;
         END IF;
         Trace_SYS.Message('Dynamic call toWorkOrderCodingUtility');
         IF (invtrans_rec_.source_ref_type IN (Order_Type_API.DB_WORK_ORDER, Order_Type_API.DB_WORK_TASK)) THEN
            $IF (Component_Wo_SYS.INSTALLED) $THEN
               Prepare_Codestring_Rec___(codestr_rec_, newrec_);
               Jt_Task_Cost_Line_Util_API.Handle_Inventory_Cost ( source_ref_type_   => invtrans_rec_.source_ref_type,
                                                                  source_ref1_       => invtrans_rec_.source_ref1,
                                                                  source_ref2_       => invtrans_rec_.source_ref2,
                                                                  source_ref3_       => invtrans_rec_.source_ref3,
                                                                  source_ref4_       => invtrans_rec_.source_ref4,
                                                                  source_ref5_       => invtrans_rec_.source_ref5,
                                                                  transaction_id_    => transaction_id_,
                                                                  accounting_id_     => newrec_.accounting_id,
                                                                  seq_               => newrec_.seq,
                                                                  activity_seq_      => newrec_.activity_seq,
                                                                  str_code_          => newrec_.str_code,
                                                                  voucher_type_      => newrec_.voucher_type,
                                                                  voucher_no_        => newrec_.voucher_no,
                                                                  accounting_year_   => newrec_.accounting_year,
                                                                  accounting_period_ => newrec_.accounting_period,
                                                                  voucher_date_      => newrec_.date_applied,
                                                                  value_             => newrec_.value,
                                                                  debit_credit_      => newrec_.debit_credit,
                                                                  transaction_code_  => invtrans_rec_.transaction_code,
                                                                  error_desc_        => newrec_.error_desc,
                                                                  codestr_rec_       => codestr_rec_);                                           
                                                                
            $ELSE
               NULL;
            $END
         END IF;
      $ELSE
         NULL;
      $END
   END IF;  
EXCEPTION
   WHEN exit_procedure THEN
      NULL;
END Send_Posting_To_Pcm___;


-- Get_Str_Code_Purtranshist___
--   Method to get scrapping cause from Purchase Transaction History.
PROCEDURE Get_Str_Code_Purtranshist___ (
   purtrans_fetched_       IN OUT BOOLEAN,
   control_type_value_tab_ IN OUT Control_Type_Value,
   control_value_tab_      IN OUT Posting_Ctrl_API.CtrlValTab,
   control_type_key_rec_   IN     Mpccom_Accounting_API.Control_Type_Key,
   i_                      IN     NUMBER,
   control_type_name_tab_  IN     Control_Type_Name,
   control_type_tab_       IN     Posting_Ctrl_API.CtrlTypTab )
IS
BEGIN
   IF NOT (purtrans_fetched_) THEN
      $IF (Component_Purch_SYS.INSTALLED) $THEN
         control_type_value_tab_(84) := Purchase_Transaction_Hist_API.Get_Reject_Code(control_type_key_rec_.transaction_id_);                  
      $ELSE
         Error_SYS.Component_Not_Exist('PURCH');
      $END
      purtrans_fetched_ := TRUE;
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(84)) THEN
      control_value_tab_(i_) := control_type_value_tab_(84);
   END IF;
END Get_Str_Code_Purtranshist___;

PROCEDURE Get_Str_Code_Countrycode___ (
   countrycode_fetched_    IN OUT BOOLEAN,
   control_type_value_tab_ IN OUT Control_Type_Value,
   control_value_tab_      IN OUT Posting_Ctrl_API.CtrlValTab,
   control_type_key_rec_   IN     Mpccom_Accounting_API.Control_Type_Key,
   i_                      IN     NUMBER,
   control_type_name_tab_  IN     Control_Type_Name,
   control_type_tab_       IN     Posting_Ctrl_API.CtrlTypTab )
IS
BEGIN
   $IF (Component_Order_SYS.INSTALLED) $THEN
      BEGIN
         IF NOT countrycode_fetched_ THEN      
            Order_Control_Type_Values_API.Get_Ctrl_Type_Value_Country(control_type_value_tab_, control_type_key_rec_);
            countrycode_fetched_ := TRUE;
         END IF;
      END;
   $ELSE
      Error_SYS.Component_Not_Exist('ORDER');
   $END
   
   IF (control_type_tab_(i_) = control_type_name_tab_(85)) THEN
      control_value_tab_(i_) := control_type_value_tab_(85);
   END IF;
END Get_Str_Code_Countrycode___;


PROCEDURE Get_Str_Code_Usergroup___ (
   usergroup_fetched_      IN OUT BOOLEAN,
   control_type_value_tab_ IN OUT Control_Type_Value,
   control_value_tab_      IN OUT Posting_Ctrl_API.CtrlValTab,
   company_                IN     VARCHAR2,
   i_                      IN     NUMBER,
   control_type_name_tab_  IN     Control_Type_Name,
   control_type_tab_       IN     Posting_Ctrl_API.CtrlTypTab )
IS
BEGIN
   IF NOT (usergroup_fetched_) THEN
      control_type_value_tab_(86) := User_Group_Member_Finance_API.Get_Default_Group(company_, Fnd_Session_API.Get_Fnd_User);
      usergroup_fetched_ := TRUE;
   END IF;

   IF (control_type_tab_(i_) = control_type_name_tab_(86)) THEN
      control_value_tab_(i_) := control_type_value_tab_(86);
   END IF;
END Get_Str_Code_Usergroup___;

PROCEDURE Get_Str_Code_Statecode___ (
   statecode_fetched_      IN OUT BOOLEAN,
   control_type_value_tab_ IN OUT Control_Type_Value,
   control_value_tab_      IN OUT Posting_Ctrl_API.CtrlValTab,
   control_type_key_rec_   IN     Mpccom_Accounting_API.Control_Type_Key,
   i_                      IN     NUMBER,
   control_type_name_tab_  IN     Control_Type_Name,
   control_type_tab_       IN     Posting_Ctrl_API.CtrlTypTab )
IS
BEGIN
   $IF (Component_Order_SYS.INSTALLED) $THEN
      DECLARE
         state_code_            VARCHAR2(35);
      BEGIN
         IF NOT statecode_fetched_ THEN      

            state_code_ := Invoice_Customer_Order_Api.Get_Cust_Ord_Location_Code(control_type_key_rec_.oe_order_no_, 
                                                                                  control_type_key_rec_.oe_line_no_,  
                                                                                  control_type_key_rec_.oe_rel_no_, 
                                                                                  control_type_key_rec_.oe_line_item_no_, 
                                                                                  NULL, 
                                                                                  NULL);
                                                                              
            control_type_value_tab_(87) :=  state_code_; 
            statecode_fetched_ := TRUE;
         END IF;
      END;
   $ELSE
      Error_SYS.Component_Not_Exist('ORDER');
   $END
 
   IF (control_type_tab_(i_) = control_type_name_tab_(87)) THEN
      control_value_tab_(i_) := control_type_value_tab_(87);
   END IF;
END Get_Str_Code_Statecode___;

PROCEDURE Get_Str_Code_Customergroup___ (
   customergroup_fetched_  IN OUT BOOLEAN,
   control_type_value_tab_ IN OUT Control_Type_Value,
   control_value_tab_      IN OUT Posting_Ctrl_API.CtrlValTab,
   control_type_key_rec_   IN     Mpccom_Accounting_API.Control_Type_Key,
   i_                      IN     NUMBER,
   control_type_name_tab_  IN     Control_Type_Name,
   control_type_tab_       IN     Posting_Ctrl_API.CtrlTypTab )
IS
BEGIN
   $IF (Component_Order_SYS.INSTALLED) $THEN
      BEGIN
         IF NOT customergroup_fetched_ THEN
            Order_Control_Type_Values_API.Get_Ctrl_Type_Value_Custgrp(control_type_value_tab_, control_type_key_rec_);
            customergroup_fetched_ := TRUE;  
         END IF;
      END;
   $ELSE
      Error_SYS.Component_Not_Exist('ORDER');
   $END
   
   IF (control_type_tab_(i_) = control_type_name_tab_(88)) THEN
      control_value_tab_(i_) := control_type_value_tab_(88);
   END IF;
END Get_Str_Code_Customergroup___;


PROCEDURE Get_Str_Code_Rebate_Group___ (
   rebate_group_fetched_   IN OUT BOOLEAN,
   control_type_value_tab_ IN OUT Control_Type_Value,
   control_value_tab_      IN OUT Posting_Ctrl_API.CtrlValTab,
   control_type_key_rec_   IN     Mpccom_Accounting_API.Control_Type_Key,
   i_                      IN     NUMBER,
   control_type_name_tab_  IN     Control_Type_Name,
   control_type_tab_       IN     Posting_Ctrl_API.CtrlTypTab )
IS
BEGIN
   IF NOT (rebate_group_fetched_) THEN
      $IF (Component_Order_SYS.INSTALLED) $THEN
         Order_Control_Type_Values_API.Get_Ctrl_Type_Value_Rebgrp(control_type_value_tab_, control_type_key_rec_);
         rebate_group_fetched_ := TRUE;
      $ELSE
         Error_SYS.Component_Not_Exist('ORDER');
      $END
   END IF;

   IF (control_type_tab_(i_) = control_type_name_tab_(96)) THEN
      control_value_tab_(i_) := control_type_value_tab_(96);
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(97)) THEN
      control_value_tab_(i_) := control_type_value_tab_(97);
   END IF;

END Get_Str_Code_Rebate_Group___;


-- Get_Str_Code_Indirect_Labor___
--   Get str code for Indirect Labor Transactions
PROCEDURE Get_Str_Code_Indirect_Labor___ (
   indirect_labor_fetched_ IN OUT BOOLEAN,
   control_type_value_tab_ IN OUT Control_Type_Value,
   control_value_tab_      IN OUT Posting_Ctrl_API.CtrlValTab,
   control_type_key_rec_   IN     Mpccom_Accounting_API.Control_Type_Key,
   i_                      IN     NUMBER,
   control_type_name_tab_  IN     Control_Type_Name,
   control_type_tab_       IN     Posting_Ctrl_API.CtrlTypTab )
IS
   indirect_job_id_ VARCHAR2(10);
   contract_        VARCHAR2(5);
BEGIN
   IF NOT (indirect_labor_fetched_) AND (control_type_key_rec_.transaction_id_ IS NOT NULL) THEN
      $IF (Component_Shpord_SYS.INSTALLED) $THEN
         DECLARE
            indirect_labor_hist_rec_ Indirect_Labor_History_API.Public_Rec;
         BEGIN
            indirect_labor_hist_rec_     := Indirect_Labor_History_API.Get(control_type_key_rec_.transaction_id_);
            control_type_value_tab_(100) := indirect_labor_hist_rec_.employee_id;
            contract_                    := indirect_labor_hist_rec_.contract;
            indirect_job_id_             := indirect_labor_hist_rec_.indirect_job_id;
         END;
         -- The control type value for indirect job is stored in posting control concatenated with site
         control_type_value_tab_(104) := contract_ || CHR(32) ||'|'|| CHR(32) || indirect_job_id_;
      $ELSE
         Error_SYS.Component_Not_Exist('SHPORD');
      $END
      indirect_labor_fetched_ := TRUE;
   END IF;

   IF (control_type_tab_(i_) = control_type_name_tab_(100)) THEN
      control_value_tab_(i_) := control_type_value_tab_(100);
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(104)) THEN
     control_value_tab_(i_) := control_type_value_tab_(104);
   END IF;
END Get_Str_Code_Indirect_Labor___;


-- Get_Str_Code_Person___
--   Get str code for employee data in PERSON
PROCEDURE Get_Str_Code_Person___ (
   person_fetched_         IN OUT BOOLEAN,
   control_type_value_tab_ IN OUT Control_Type_Value,
   control_value_tab_      IN OUT Posting_Ctrl_API.CtrlValTab,
   control_type_key_rec_   IN     Mpccom_Accounting_API.Control_Type_Key,
   i_                      IN     NUMBER,
   control_type_name_tab_  IN     Control_Type_Name,
   control_type_tab_       IN     Posting_Ctrl_API.CtrlTypTab )
IS
BEGIN
   IF NOT (person_fetched_) THEN
      $IF (Component_Shpord_SYS.INSTALLED) AND (Component_Person_SYS.INSTALLED) $THEN
         DECLARE
            indirect_labor_hist_rec_ Indirect_Labor_History_API.Public_Rec;
         BEGIN
            indirect_labor_hist_rec_     := Indirect_Labor_History_API.Get(control_type_key_rec_.transaction_id_);
            control_type_value_tab_(101) := Company_Pers_Assign_API.Get_Org_Code(indirect_labor_hist_rec_.company,
                                                                                 indirect_labor_hist_rec_.employee_id,
                                                                                 indirect_labor_hist_rec_.date_applied);
            control_type_value_tab_(102) := Company_Pers_Assign_API.Get_Pos_Code(indirect_labor_hist_rec_.company,
                                                                                 indirect_labor_hist_rec_.employee_id,
                                                                                 indirect_labor_hist_rec_.date_applied);
            control_type_value_tab_(103) := Company_Emp_Category_API.Get_Accrul_Name(
                                                     indirect_labor_hist_rec_.company,
                                                     Company_Person_API.Get_Emp_Cat_Name(indirect_labor_hist_rec_.company,
                                                                                         indirect_labor_hist_rec_.employee_id));
         END;
      $ELSE
         Error_SYS.Component_Not_Exist('PERSON');
      $END
      person_fetched_ := TRUE;
   END IF;

   IF (control_type_tab_(i_) = control_type_name_tab_(101)) THEN
      control_value_tab_(i_) := control_type_value_tab_(101);
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(102)) THEN
     control_value_tab_(i_) := control_type_value_tab_(102);
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(103)) THEN
     control_value_tab_(i_) := control_type_value_tab_(103);
   END IF;
END Get_Str_Code_Person___;


-- Get_Str_Code_Fsmtranshist___
--   Method to get fsm transaction code from Fsm Transaction History.
PROCEDURE Get_Str_Code_Fsmtranshist___ (
   fsmtrans_fetched_       IN OUT BOOLEAN,
   control_type_value_tab_ IN OUT Control_Type_Value,
   control_value_tab_      IN OUT Posting_Ctrl_API.CtrlValTab,
   control_type_key_rec_   IN     Mpccom_Accounting_API.Control_Type_Key,
   i_                      IN     NUMBER,
   control_type_name_tab_  IN     Control_Type_Name,
   control_type_tab_       IN     Posting_Ctrl_API.CtrlTypTab )
IS
BEGIN
   IF NOT (fsmtrans_fetched_) THEN
      $IF (Component_Fsmapp_SYS.INSTALLED) $THEN
         control_type_value_tab_(105) := Fsm_Transaction_Hist_API.Get_Fsm_Transaction_Code(control_type_key_rec_.transaction_id_);                  
      $ELSE
         Error_SYS.Component_Not_Exist('FSMAPP');
      $END
      fsmtrans_fetched_ := TRUE;
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(105)) THEN
      control_value_tab_(i_) := control_type_value_tab_(105);
   END IF;
END Get_Str_Code_Fsmtranshist___;


PROCEDURE Get_Str_Code_Manu_Wip_Event___ (
   control_type_value_tab_ IN OUT Control_Type_Value,
   control_value_tab_      IN OUT Posting_Ctrl_API.CtrlValTab,
   control_type_key_rec_   IN     Mpccom_Accounting_API.Control_Type_Key,
   i_                      IN     NUMBER,
   control_type_name_tab_  IN     Control_Type_Name,
   control_type_tab_       IN     Posting_Ctrl_API.CtrlTypTab )
IS
   low_level_     NUMBER  := 0;
   is_by_product_ BOOLEAN := FALSE;
BEGIN
   $IF (Component_Mfgstd_SYS.INSTALLED) $THEN

      IF (control_type_key_rec_.event_code_ IN ('SOISS', 'BACFLUSH', 'CO-BACFLSH', 'CO-SOISS', 'PSBKFL', 'CO-PSBKFL')) THEN
         control_type_value_tab_(117) := Manuf_Wip_Material_Action_API.DB_ISSUE_MATERIAL;
      ELSIF (control_type_key_rec_.event_code_ IN ('OOREC', 'PSRECEIVE', 'AC-MFGREV+', 'AC-MFGRTR+', 'OPFEED-SCP', 'AC-MFGREV-', 'AC-MFGRTR-')) THEN

         low_level_ := Manuf_Part_Attribute_API.Get_Low_Level(control_type_key_rec_.contract_, control_type_key_rec_.part_no_);

         IF (control_type_key_rec_.so_order_no_ IS NOT NULL) THEN
            $IF (Component_Shpord_SYS.INSTALLED) $THEN
               is_by_product_ := Manufactured_Part_API.Is_Byproduct(control_type_key_rec_.so_order_no_,
                                                                    control_type_key_rec_.so_release_no_,
                                                                    control_type_key_rec_.so_sequence_no_,
                                                                    control_type_key_rec_.part_no_);
            $ELSE
               Error_SYS.Component_Not_Exist('SHPORD');
            $END
         ELSIF ((control_type_key_rec_.ps_order_no_     IS NOT NULL) AND 
                (control_type_key_rec_.ps_line_item_no_ IS NOT NULL)) THEN 
            -- For Production Schedules it is only the receipts of by-products that have a value in line_item_no.
            is_by_product_ := TRUE;
         ELSIF (control_type_key_rec_.event_code_ IN ('AC-MFGREV+', 'AC-MFGRTR+', 'AC-MFGREV-', 'AC-MFGRTR-')) THEN
            -- No order info available so we look at the latest shop order
            $IF (Component_Shpord_SYS.INSTALLED) $THEN
               is_by_product_ := Manufactured_Part_API.Is_Byproduct_On_Latest_Order(control_type_key_rec_.contract_,
                                                                                    control_type_key_rec_.part_no_);
            $ELSE
               Error_SYS.Component_Not_Exist('SHPORD');
            $END
         END IF;         

         IF (is_by_product_) THEN
            control_type_value_tab_(117) := Manuf_Wip_Material_Action_API.DB_RECEIVE_BYPRODUCT;
         ELSE
            IF (low_level_ = 0) THEN
               control_type_value_tab_(117) := Manuf_Wip_Material_Action_API.DB_RECEIVE_PRODUCT;
            ELSE
               control_type_value_tab_(117) := Manuf_Wip_Material_Action_API.DB_RECEIVE_SUB_ASSEMBLY;
            END IF;
         END IF;
      ELSE
         control_type_value_tab_(117) := Manuf_Wip_Material_Action_API.DB_OTHER;
      END IF;

      IF (control_type_tab_(i_) = control_type_name_tab_(117)) THEN
         control_value_tab_(i_) := control_type_value_tab_(117);
      END IF;

   $ELSE
      Error_SYS.Component_Not_Exist('MFGSTD');
   $END

END Get_Str_Code_Manu_Wip_Event___;

-- gelr: brazilian_specific_attributes, begin
PROCEDURE Get_Str_Code_Business_Transaction_Code___ (
   busines_trans_code_fetched_ IN OUT BOOLEAN,
   control_type_value_tab_     IN OUT Control_Type_Value,
   control_value_tab_          IN OUT Posting_Ctrl_API.CtrlValTab,
   control_type_key_rec_       IN     Mpccom_Accounting_API.Control_Type_Key,
   i_                          IN     NUMBER,
   control_type_name_tab_      IN     Control_Type_Name,
   control_type_tab_           IN     Posting_Ctrl_API.CtrlTypTab )
IS
BEGIN
   IF NOT busines_trans_code_fetched_ THEN      
      IF (control_type_key_rec_.oe_order_no_ IS NOT NULL)THEN
         $IF (Component_Order_SYS.INSTALLED) $THEN
            control_type_value_tab_(128) := Customer_Order_API.Get_Business_Transaction_Id(control_type_key_rec_.oe_order_no_);
         $ELSE
            Error_SYS.Component_Not_Exist('ORDER');
         $END
      END IF;
      busines_trans_code_fetched_ := TRUE;
   END IF;
   IF (control_type_tab_(i_) = control_type_name_tab_(128)) THEN
      control_value_tab_(i_) := control_type_value_tab_(128);
   END IF;
END Get_Str_Code_Business_Transaction_Code___;
-- gelr: brazilian_specific_attributes, end

PROCEDURE Refresh_Activity_Info___ (
   contract_                 IN VARCHAR2,
   booking_source_           IN VARCHAR2,
   transfer_to_finance_      IN BOOLEAN,
   transfer_to_finance_date_ IN DATE)
IS
BEGIN
    
   IF (booking_source_ = Mpccom_Transaction_Source_API.DB_INVENTORY) THEN
      $IF Component_Invent_SYS.INSTALLED $THEN
         Inventory_Transaction_Hist_API.Refresh_Activity_Info(contract_, NULL, transfer_to_finance_, transfer_to_finance_date_);
      $ELSE
         Error_SYS.Component_Not_Exist('INVENT');
      $END
   ELSIF (booking_source_ IN (Mpccom_Transaction_Source_API.DB_OPERATION, Mpccom_Transaction_Source_API.DB_LABOR)) THEN
      $IF Component_Mfgstd_SYS.INSTALLED $THEN
         Operation_History_API.Refresh_Activity_Info(contract_, booking_source_);
      $ELSE
         Error_SYS.Component_Not_Exist('MFGSTD');
      $END
   ELSIF (booking_source_ = Mpccom_Transaction_Source_API.DB_SHOP_ORDER_GENERAL) THEN
      $IF Component_Shpord_SYS.INSTALLED $THEN
         Shop_Order_Oh_History_API.Refresh_Activity_Info(contract_);
      $ELSE
         Error_SYS.Component_Not_Exist('SHPORD');
      $END
   ELSIF (booking_source_ = Mpccom_Transaction_Source_API.DB_RENTAL) THEN
       $IF Component_Rental_SYS.INSTALLED $THEN
         Rental_Transaction_API.Refresh_Activity_Info(contract_);
      $ELSE
         Error_SYS.Component_Not_Exist('RENTAL');
      $END      
   END IF;
END Refresh_Activity_Info___;


FUNCTION Get_Merged_Value_Detail_Tab___ (
   value_detail_tab_ IN Value_Detail_Tab ) RETURN Value_Detail_Tab
IS
   merged_value_detail_tab_ Value_Detail_Tab;
   row_no_                  PLS_INTEGER := 1;
   detail_found_            BOOLEAN;
   char_null_               CONSTANT VARCHAR2(12) := 'VARCHAR2NULL';
BEGIN
   IF (value_detail_tab_.COUNT > 0) THEN
      FOR i IN value_detail_tab_.FIRST..value_detail_tab_.LAST LOOP
         detail_found_ := FALSE;
         IF (merged_value_detail_tab_.COUNT > 0) THEN
            FOR j IN merged_value_detail_tab_.FIRST..merged_value_detail_tab_.LAST LOOP
               IF ((NVL(value_detail_tab_(i).bucket_posting_group_id,char_null_) = 
                           NVL(merged_value_detail_tab_(j).bucket_posting_group_id,char_null_)) AND
                   (NVL(value_detail_tab_(i).cost_source_id,char_null_) = 
                           NVL(merged_value_detail_tab_(j).cost_source_id,char_null_))) THEN
                  merged_value_detail_tab_(j).value := merged_value_detail_tab_(j).value +
                                                       NVL(value_detail_tab_(i).value, 0);
                  detail_found_ := TRUE;
                  EXIT;
               END IF;
            END LOOP;
         END IF;
         IF NOT (detail_found_) THEN
            merged_value_detail_tab_(row_no_).bucket_posting_group_id := value_detail_tab_(i).bucket_posting_group_id;
            merged_value_detail_tab_(row_no_).cost_source_id          := value_detail_tab_(i).cost_source_id;
            merged_value_detail_tab_(row_no_).value                   := NVL(value_detail_tab_(i).value,0);
            row_no_ := row_no_ + 1;
         END IF;
      END LOOP;
   END IF;

   RETURN (merged_value_detail_tab_);
END Get_Merged_Value_Detail_Tab___;


FUNCTION Get_Merged_Cost_Element_Tab___ (
   project_cost_element_tab_ IN Project_Cost_Element_Tab ) RETURN Project_Cost_Element_Tab
IS
   merged_cost_element_tab_ Project_Cost_Element_Tab;
   row_no_                  PLS_INTEGER := 1;
   detail_found_            BOOLEAN;
BEGIN
   IF (project_cost_element_tab_.COUNT > 0) THEN
      FOR i IN project_cost_element_tab_.FIRST..project_cost_element_tab_.LAST LOOP
         IF (project_cost_element_tab_(i).project_cost_element IS NOT NULL) THEN
            detail_found_ := FALSE;
            IF (merged_cost_element_tab_.COUNT > 0) THEN
               FOR j IN merged_cost_element_tab_.FIRST..merged_cost_element_tab_.LAST LOOP
                  IF (project_cost_element_tab_(i).project_cost_element = 
                              merged_cost_element_tab_(j).project_cost_element) THEN
                     merged_cost_element_tab_(j).amount :=  nvl(merged_cost_element_tab_(j).amount, 0) +
                                                            nvl(project_cost_element_tab_(i).amount, 0);
                     merged_cost_element_tab_(j).currency_amount := nvl(merged_cost_element_tab_(j).currency_amount, 0) +
                                                                    nvl(project_cost_element_tab_(i).currency_amount, 0);
                     merged_cost_element_tab_(j).hours :=   nvl(merged_cost_element_tab_(j).hours, 0) +
                                                            nvl(project_cost_element_tab_(i).hours, 0);
                     detail_found_ := TRUE;
                     EXIT;
                  END IF;
               END LOOP;
            END IF;
            IF NOT (detail_found_) THEN
               merged_cost_element_tab_(row_no_) := project_cost_element_tab_(i);
               row_no_ := row_no_ + 1;
            END IF;
         END IF;
      END LOOP;
   END IF;

   RETURN (merged_cost_element_tab_);
END Get_Merged_Cost_Element_Tab___;


PROCEDURE Do_Accounting___ (
   rcode_                      OUT VARCHAR2,   
   company_                    IN  VARCHAR2,
   event_code_                 IN  VARCHAR2,
   str_code_                   IN  VARCHAR2,
   pre_accounting_flag_db_     IN  VARCHAR2,
   accounting_id_              IN  NUMBER,
   debit_credit_db_            IN  VARCHAR2,
   value_                      IN  NUMBER,
   booking_source_             IN  VARCHAR2,
   currency_code_              IN  VARCHAR2,
   currency_rate_              IN  NUMBER,
   curr_amount_                IN  NUMBER,
   accounting_date_            IN  DATE,
   project_accounting_flag_db_ IN  VARCHAR2,
   contract_                   IN  VARCHAR2,
   userid_                     IN  VARCHAR2,
   date_of_origin_             IN  DATE,
   cost_source_id_             IN  VARCHAR2,
   bucket_posting_group_id_    IN  VARCHAR2,
   inventory_value_status_db_  IN  VARCHAR2,
   seq_                        IN  NUMBER,
   value_adjustment_           IN  BOOLEAN,
   per_oh_adjustment_id_       IN  NUMBER,
   charge_type_                IN  VARCHAR2,
   charge_group_               IN  VARCHAR2,
   supp_grp_                   IN  VARCHAR2,
   stat_grp_                   IN  VARCHAR2,  
   assortment_                 IN  VARCHAR2,
   location_type_              IN  VARCHAR2,
   location_group_             IN  VARCHAR2,
   conversion_factor_          IN  NUMBER,   
   control_type_key_rec_       IN  Control_Type_Key,
   parallel_amount_            IN  NUMBER,
   parallel_currency_rate_     IN  NUMBER,
   parallel_conversion_factor_ IN  NUMBER,
   trans_reval_event_id_       IN  NUMBER,
   condition_code_             IN  VARCHAR2 )
IS
   secondary_str_code_         MPCCOM_ACCOUNTING_TAB.str_code%TYPE;
   
   CURSOR get_sum_posted IS
      SELECT SUM(value       * (DECODE(debit_credit, 'C', -1, 1))),
             SUM(curr_amount     * (DECODE(debit_credit, 'C', -1, 1))),
             SUM(parallel_amount * (DECODE(debit_credit, 'C', -1, 1))) 
      FROM   MPCCOM_ACCOUNTING_TAB
      WHERE  event_code = event_code_
      AND    (str_code = str_code_ OR str_code = secondary_str_code_)
      AND    accounting_id = accounting_id_
      AND    NVL(cost_source_id, '*') = NVL(cost_source_id_, '*')
      AND    NVL(bucket_posting_group_id, '*') = NVL(bucket_posting_group_id_, '*')
      AND    value != 0; 
      
   stmt_                       VARCHAR2(2000);
   no_accounting               EXCEPTION;
   error_accounting            EXCEPTION;
   local_debit_credit_db_      MPCCOM_ACCOUNTING_TAB.debit_credit%TYPE;
   accounting_value_           NUMBER := 0.0;
   accounting_curr_amount_     NUMBER := 0.0;
   ac_error_flag_              BOOLEAN := FALSE;
   pre_ac_error_flag_          BOOLEAN := FALSE;
   prj_pre_posting_            BOOLEAN := FALSE;
   include_activity_seq_       BOOLEAN := FALSE;      
   account_err_desc_           MPCCOM_ACCOUNTING_TAB.error_desc%TYPE;
   account_err_status_         MPCCOM_ACCOUNTING_TAB.status_code%TYPE;
   value_round_                NUMBER;
   activity_seq_               NUMBER;
   posting_type_               VARCHAR2(10);
   source_identifier_          VARCHAR2(200);
   distributed_acc_done_       BOOLEAN := FALSE;
   sum_posted_                 NUMBER;
   sum_curr_amount_posted_     NUMBER;
   value_posted_               NUMBER;
   curr_amount_posted_         NUMBER;
   parent_activity_seq_        NUMBER;
   is_inventory_part_          NUMBER := 0;
   base_currency_rounding_     NUMBER;
   currency_rounding_          NUMBER;
   negative_when_credit_       NUMBER;
   sum_posted_parallel_amount_ NUMBER;
   parallel_amount_posted_     NUMBER := 0;
   parallel_currency_rounding_ NUMBER;
   accounting_parallel_amount_ NUMBER := 0;
   company_fin_rec_            Company_Finance_API.Public_Rec;
   codestring_rec_             Accounting_Codestr_API.CodestrRec;   
   local_control_type_key_rec_ Mpccom_Accounting_API.Control_Type_Key := control_type_key_rec_;
   curr_amount_round_          NUMBER;
   local_currency_rate_        NUMBER;
   
BEGIN
   company_fin_rec_            := Company_Finance_API.Get(company_);
   base_currency_rounding_     := Currency_Code_API.Get_Currency_Rounding(company_, company_fin_rec_.currency_code);
   currency_rounding_          := Currency_Code_API.Get_Currency_Rounding(company_, currency_code_);
   parallel_currency_rounding_ := Currency_Code_API.Get_Currency_Rounding(company_, company_fin_rec_.parallel_acc_currency); 
   local_debit_credit_db_      := debit_credit_db_;
   negative_when_credit_       := CASE local_debit_credit_db_ WHEN 'C' THEN -1 ELSE 1 END;   
   local_currency_rate_        := currency_rate_;
   
   IF (value_adjustment_) THEN     
      IF (str_code_ = 'M184') THEN
         -- In version 7.5 we replaced M7 with M184 for Negative Counting Difference. When a counting transaction
         -- created in version 7 or earlier is included in a Transaction Based Revaluation that is executed
         -- after an upgrade from version 7 or earlier to version 7 or later we need to consider both M7 and M184
         -- in order to find all the existing amounts posted on the Debit side of events 'COUNT-OUT' and 'CO-COUN-OU'.
         secondary_str_code_ := 'M7';
      END IF;
      
      -- Retrieve the total already posted for this posting event, posting_type, cost_source_id and bucket_posting_group_id
      OPEN get_sum_posted;
      FETCH get_sum_posted INTO sum_posted_, sum_curr_amount_posted_, sum_posted_parallel_amount_;  
      CLOSE get_sum_posted;
       
      sum_posted_                 := NVL(sum_posted_, 0);
      sum_curr_amount_posted_     := NVL(sum_curr_amount_posted_, 0);
      sum_posted_parallel_amount_ := NVL(sum_posted_parallel_amount_, 0);
      -- Only the difference between what has been already posted and the new value should
      -- be posted when creating the new posting
      value_posted_               := ROUND((value_       * negative_when_credit_), base_currency_rounding_) - sum_posted_;
      IF ((curr_amount_ = 0) AND (trans_reval_event_id_ IS NOT NULL) AND (currency_code_ != company_fin_rec_.currency_code)) THEN
         curr_amount_posted_ := 0;
         local_currency_rate_ := 0;
      ELSE   
         curr_amount_posted_         := ROUND((curr_amount_ * negative_when_credit_), currency_rounding_     ) - sum_curr_amount_posted_;
      END IF;   
      parallel_amount_posted_     := ROUND((parallel_amount_ * negative_when_credit_), parallel_currency_rounding_) - sum_posted_parallel_amount_;

      value_posted_               := value_posted_       * negative_when_credit_;
      curr_amount_posted_         := curr_amount_posted_ * negative_when_credit_;
      parallel_amount_posted_     := parallel_amount_posted_ * negative_when_credit_;

   ELSE
      value_posted_           := value_;
      curr_amount_posted_     := curr_amount_;
      parallel_amount_posted_ := parallel_amount_;
   END IF;

   IF (value_posted_ < 0) THEN
      -- Bug 160509, Added events 'POINV-WIP', 'RETWOR-WIP' and 'RETCRE-WIP' to handle negative posting values.
      IF ((value_adjustment_) OR (event_code_ IN ('ARRCHG', 'ARRCHG-DIR', 'ARRCHGIDIR', 'PURDIR-CHG','ARRCHG-REP', 'POINV-WIP', 'RETWOR-WIP', 'RETCRE-WIP'))) THEN
         IF (company_fin_rec_.correction_type = 'REVERSE') THEN
            value_posted_       := ABS(value_posted_);
            curr_amount_posted_ := ABS(curr_amount_posted_);
            parallel_amount_posted_ := ABS(parallel_amount_posted_);

            IF (local_debit_credit_db_ = 'C') THEN
               local_debit_credit_db_ := 'D';
            ELSE
               local_debit_credit_db_ := 'C';
            END IF;
         END IF;
      END IF;
   END IF;
    
   value_round_ := ROUND(value_posted_, base_currency_rounding_);
   curr_amount_round_ := ROUND(curr_amount_posted_, currency_rounding_);
   
   IF (value_round_ = 0 AND curr_amount_round_ = 0) THEN
      RAISE no_accounting;
   END IF;
   IF ( event_code_ IN ('PODIRSH', 'PODIRINTEM', 'DS-DELIVOH', 'IDS-DELOH', 'PRICEDIFF-', 'PRICEDIFF+', 'ARRCHG-DIR')) THEN
      Modify_Control_Type_Key_Rec___(local_control_type_key_rec_, event_code_, str_code_);
   END IF;
   local_control_type_key_rec_.event_code_ := event_code_;
   
   IF (local_control_type_key_rec_.pre_accounting_id_ IS NULL) THEN      
      local_control_type_key_rec_.pre_accounting_id_ := Pre_Accounting_API.Get_Pre_Accounting_Id(local_control_type_key_rec_);
   END IF;

   IF (str_code_ IN ('M1', 'M3', 'M4', 'M15', 'M16', 'M40', 'M183')) AND
      (nvl(local_control_type_key_rec_.activity_seq_, 0) = 0) AND 
      (pre_accounting_flag_db_ ='Y') AND 
      (local_control_type_key_rec_.pre_accounting_id_ IS NOT NULL) THEN
      Pre_Accounting_API.Prj_Pre_Posting_Required(prj_pre_posting_,
                                                  include_activity_seq_,
                                                  local_control_type_key_rec_,
                                                  project_accounting_flag_db_,
                                                  company_,
                                                  codestring_rec_);
      IF include_activity_seq_ THEN
         local_control_type_key_rec_.activity_seq_ := Pre_Accounting_API.Get_Activity_Seq(local_control_type_key_rec_.pre_accounting_id_);
      END IF;                                                
   END IF;    

   -- location_type_ and location_group_.
   Get_Code_String___(account_err_desc_,
                      account_err_status_,
                      codestring_rec_,
                      local_control_type_key_rec_,
                      company_,
                      str_code_,
                      accounting_date_,
                      cost_source_id_,
                      bucket_posting_group_id_,
                      charge_type_,
                      charge_group_,
                      supp_grp_, 
                      stat_grp_,
                      assortment_,
                      location_type_,
                      location_group_,
                      condition_code_);
                      
   IF (account_err_status_ = '99') THEN
      ac_error_flag_ := TRUE;
   END IF;
   accounting_value_           := value_posted_;
   accounting_curr_amount_     := curr_amount_posted_;
   accounting_parallel_amount_ := parallel_amount_posted_;
   Trace_SYS.Message('TRACE=> ********** Codestring FOR posting type '||str_code_||' as created FROM accounting rules. **********');
   Trace_SYS.Message('TRACE=> codestring.code_a: '||codestring_rec_.code_a);
   Trace_SYS.Message('TRACE=> codestring.code_b: '||codestring_rec_.code_b);
   Trace_SYS.Message('TRACE=> codestring.code_c: '||codestring_rec_.code_c);
   Trace_SYS.Message('TRACE=> codestring.code_d: '||codestring_rec_.code_d);
   Trace_SYS.Message('TRACE=> codestring.code_e: '||codestring_rec_.code_e);
   Trace_SYS.Message('TRACE=> codestring.code_f: '||codestring_rec_.code_f);
   Trace_SYS.Message('TRACE=> codestring.code_g: '||codestring_rec_.code_g);
   Trace_SYS.Message('TRACE=> codestring.code_h: '||codestring_rec_.code_h);
   Trace_SYS.Message('TRACE=> codestring.code_i: '||codestring_rec_.code_i);
   Trace_SYS.Message('TRACE=> codestring.code_j: '||codestring_rec_.code_j);

   IF (pre_accounting_flag_db_ ='Y') THEN
      -- Separate block to be able to catch the exception that do occur if a mandatory
      -- pre accounting is missing. Such an error should not stop the execution,
      -- but result in a status_code = 99.
      BEGIN
         posting_type_ := NULL;
         source_identifier_ := NULL;
         IF (local_control_type_key_rec_.pur_order_no_ IS NOT NULL) THEN
            -- Only the rows can result in a transaction. M101 does not have to be checked...
            -- Check M102 for Part Order Lines and M108 for No Part Order Lines
            IF (local_control_type_key_rec_.part_no_ IS NULL) THEN
               posting_type_ := 'M108';
            ELSE
               stmt_ := 'BEGIN
                            IF Inventory_Part_API.Check_Exist( :contract, :part_no) THEN
                               :is_inventory_part := 1;
                            END IF;
                         END;';
               @ApproveDynamicStatement(2007-12-06,NuVelk)
               EXECUTE IMMEDIATE stmt_
                  USING IN local_control_type_key_rec_.contract_,
                        IN local_control_type_key_rec_.part_no_,
                        OUT is_inventory_part_;
               IF (is_inventory_part_ = 0) THEN          
                  posting_type_ := 'M102';
               END IF;
            END IF;
            -- The identifier have to be translated BEFORE it is passed on.
            source_identifier_ := Language_SYS.Translate_Constant(lu_name_,
                                          'SOURCEIDPOLINE: line :P1 IN Purchase Order :P2',
                                          Language_SYS.Get_Language,
                                          local_control_type_key_rec_.pur_line_no_,
                                          local_control_type_key_rec_.pur_order_no_);
         ELSIF (local_control_type_key_rec_.oe_order_no_ IS NOT NULL) THEN
            -- Only the rows can result in a transaction. M103 does not have to be checked...
            posting_type_ := 'M104';
            source_identifier_ := Language_SYS.Translate_Constant(lu_name_,
                                          'SOURCEIDORDERLINE: line :P1 IN Customer Order :P2',
                                          Language_SYS.Get_Language,
                                          local_control_type_key_rec_.oe_line_no_,
                                          local_control_type_key_rec_.oe_order_no_);
         ELSIF (local_control_type_key_rec_.so_order_no_ IS NOT NULL) THEN
            posting_type_ := 'M105';
            source_identifier_ := Language_SYS.Translate_Constant(lu_name_,
                                          'SOURCEIDSOLINE: Shop Order :P1',
                                          Language_SYS.Get_Language,
                                          local_control_type_key_rec_.so_order_no_);
         ELSIF (local_control_type_key_rec_.int_order_no_ IS NOT NULL) THEN
                  posting_type_ := 'M107';
            source_identifier_ := Language_SYS.Translate_Constant(lu_name_,
                                          'SOURCEIDMRLINE: line :P1 IN Material Requisition :P2',
                                          Language_SYS.Get_Language,
                                          local_control_type_key_rec_.int_line_no_,
                                          local_control_type_key_rec_.int_order_no_);
         ELSIF (local_control_type_key_rec_.prj_project_id_ IS NOT NULL) THEN
            posting_type_ := 'M113';
            source_identifier_ := Language_SYS.Translate_Constant(lu_name_,
                                          'SOURCEIDPROJECT: activity :P1 IN Project Id :P2',
                                          Language_SYS.Get_Language,
                                          local_control_type_key_rec_.prj_activity_seq_,
                                          local_control_type_key_rec_.prj_project_id_);
         ELSIF (local_control_type_key_rec_.prjdel_item_no_ IS NOT NULL) THEN
            posting_type_ := 'M113';
            source_identifier_ := Language_SYS.Translate_Constant(lu_name_,
                                          'SOURCEIDPRJDELITEM: Shipment Plan :P1 in Project Deliverables Item :P2',
                                          Language_SYS.Get_Language,
                                          local_control_type_key_rec_.prjdel_planning_no_,
                                          local_control_type_key_rec_.prjdel_item_no_);
         END IF;
         IF posting_type_ IS NOT NULL THEN
            Pre_Accounting_API.Check_Mandatory_Code_Parts(local_control_type_key_rec_.pre_accounting_id_,
                                                          posting_type_,
                                                          company_,
                                                          source_identifier_);
         END IF;
      EXCEPTION
         WHEN OTHERS THEN
            pre_ac_error_flag_  := TRUE;
            account_err_desc_   := SUBSTR(sqlerrm,Instr(sqlerrm,':', 1, 2)+2,2000);
            account_err_status_ := '99';
      END;
   END IF;
   Trace_SYS.Message('TRACE=> pre_accounting_id: '||local_control_type_key_rec_.pre_accounting_id_);
   --
   -- Do pre accounting if exists.
   IF (local_control_type_key_rec_.pre_accounting_id_ IS NOT NULL) THEN            
      Pre_Accounting_API.Do_Pre_Accounting(activity_seq_, 
                                           codestring_rec_,
                                           local_control_type_key_rec_,
                                           local_control_type_key_rec_.pre_accounting_id_,
                                           pre_accounting_flag_db_,
                                           project_accounting_flag_db_);

      parent_activity_seq_ := activity_seq_;
      Trace_SYS.Message('TRACE=> ********** Codestring FOR posting type '||str_code_||' with preposting values added. **********');
      Trace_SYS.Message('TRACE=> codestring.code_a: '||codestring_rec_.code_a);
      Trace_SYS.Message('TRACE=> codestring.code_b: '||codestring_rec_.code_b);
      Trace_SYS.Message('TRACE=> codestring.code_c: '||codestring_rec_.code_c);
      Trace_SYS.Message('TRACE=> codestring.code_d: '||codestring_rec_.code_d);
      Trace_SYS.Message('TRACE=> codestring.code_e: '||codestring_rec_.code_e);
      Trace_SYS.Message('TRACE=> codestring.code_f: '||codestring_rec_.code_f);
      Trace_SYS.Message('TRACE=> codestring.code_g: '||codestring_rec_.code_g);
      Trace_SYS.Message('TRACE=> codestring.code_h: '||codestring_rec_.code_h);
      Trace_SYS.Message('TRACE=> codestring.code_i: '||codestring_rec_.code_i);
      Trace_SYS.Message('TRACE=> codestring.code_j: '||codestring_rec_.code_j);

      DECLARE
         codestring_rec2_         Accounting_Codestr_API.CodestrRec := codestring_rec_;
         split_value_             NUMBER;
         value_used_              NUMBER;
         split_value_curr_        NUMBER;
         value_used_curr_         NUMBER;
         distribution_count_      NUMBER;
         number_of_distributions_ NUMBER;
         split_value_parallel_    NUMBER;
         value_used_parallel_     NUMBER;
         
         CURSOR get_distributed_cost (pre_acc_id_  NUMBER) IS
            SELECT pre_accounting_id, amount_distribution
            FROM PRE_ACCOUNTING_PUB
            WHERE parent_pre_accounting_id = pre_acc_id_;
      BEGIN
         IF str_code_ IN ( 'M92', 'M93', 'M199') THEN
            -- IF the pre-accounting has been split up we must handle it here,
            -- otherwise we can let the 'old' routines take care of it.
            number_of_distributions_ := Pre_Accounting_API.Get_Count_Distribution(local_control_type_key_rec_.pre_accounting_id_);
            IF (number_of_distributions_ > 0) THEN            
               distributed_acc_done_ := TRUE;
               value_used_           := 0;
               value_used_curr_      := 0;
               distribution_count_   := 0;
               value_used_parallel_  := 0;
               -- Loop over the different combinations of pre-accounting that has been
               -- registered for the purchase order line
               FOR distribution_rec_ IN get_distributed_cost (local_control_type_key_rec_.pre_accounting_id_) LOOP
                  distribution_count_ := distribution_count_ + 1;
                  IF ( number_of_distributions_ = distribution_count_ ) THEN
                     split_value_          := accounting_value_ - value_used_;                  -- Use the reminder of the value not
                     split_value_curr_     := accounting_curr_amount_ - value_used_curr_;  -- distributed so far, to avoid rounding problems.
                     split_value_parallel_ := accounting_parallel_amount_ - value_used_parallel_;
                  ELSE
                     split_value_          := Round((accounting_value_ * distribution_rec_.amount_distribution), base_currency_rounding_);
                     split_value_curr_     := Round((accounting_curr_amount_ * distribution_rec_.amount_distribution), currency_rounding_);
                     split_value_parallel_ := ROUND((accounting_parallel_amount_ * distribution_rec_.amount_distribution), parallel_currency_rounding_);
                  END IF;

                  value_used_          := value_used_ + split_value_;
                  value_used_curr_     := value_used_curr_ + split_value_curr_;
                  value_used_parallel_ := value_used_parallel_ + split_value_parallel_; 
                  
                  Pre_Accounting_API.Do_Pre_Accounting (activity_seq_, 
                                                        codestring_rec_,
                                                        local_control_type_key_rec_,
                                                        distribution_rec_.pre_accounting_id,
                                                        pre_accounting_flag_db_,
                                                        project_accounting_flag_db_);
                  Trace_SYS.Message('TRACE=> ********** Codestring FOR posting type '||str_code_||' with distributed preposting values added. **********');
                  Trace_SYS.Message('TRACE=> codestring.code_a: '||codestring_rec_.code_a ||', codestring.code_b: '||codestring_rec_.code_b);
                  Trace_SYS.Message('TRACE=> codestring.code_c: '||codestring_rec_.code_c ||', codestring.code_d: '||codestring_rec_.code_d);
                  Trace_SYS.Message('TRACE=> codestring.code_e: '||codestring_rec_.code_e ||', codestring.code_f: '||codestring_rec_.code_f);
                  Trace_SYS.Message('TRACE=> codestring.code_g: '||codestring_rec_.code_g ||', codestring.code_h: '||codestring_rec_.code_h);
                  Trace_SYS.Message('TRACE=> codestring.code_i: '||codestring_rec_.code_i ||', codestring.code_j: '||codestring_rec_.code_j);
                  IF (activity_seq_ IS NULL) AND (parent_activity_seq_ > 0) THEN
                     activity_seq_ := parent_activity_seq_;
                  END IF;
                  
                  Do_New___ (seq_,
                             company_,
                             accounting_id_,
                             codestring_rec_.code_a,
                             codestring_rec_.code_b,
                             codestring_rec_.code_c,
                             codestring_rec_.code_d,
                             codestring_rec_.code_e,
                             codestring_rec_.code_f,
                             codestring_rec_.code_g,
                             codestring_rec_.code_h,
                             codestring_rec_.code_i,
                             codestring_rec_.code_j,
                             event_code_,
                             str_code_,
                             local_debit_credit_db_,
                             split_value_,
                             booking_source_,
                             currency_code_,
                             local_currency_rate_,
                             split_value_curr_,
                             accounting_date_,
                             account_err_desc_,
                             account_err_status_,
                             activity_seq_,
                             contract_,
                             userid_,
                             date_of_origin_,
                             inventory_value_status_db_,
                             NULL,
                             NULL,
                             cost_source_id_,
                             bucket_posting_group_id_,
                             per_oh_adjustment_id_,
                             conversion_factor_,
                             split_value_parallel_,
                             parallel_currency_rate_,
                             parallel_conversion_factor_,
                             trans_reval_event_id_);

                  codestring_rec_ := codestring_rec2_;
               END LOOP;
               IF (pre_ac_error_flag_ OR ac_error_flag_) THEN
                  RAISE error_accounting;
               END IF;
               rcode_ := 'SUCCESS';
            END IF;
         END IF;
      END;
   END IF;
   IF (NOT distributed_acc_done_) THEN
      Do_New___ (seq_,
                 company_,
                 accounting_id_,
                 codestring_rec_.code_a,
                 codestring_rec_.code_b,
                 codestring_rec_.code_c,
                 codestring_rec_.code_d,
                 codestring_rec_.code_e,
                 codestring_rec_.code_f,
                 codestring_rec_.code_g,
                 codestring_rec_.code_h,
                 codestring_rec_.code_i,
                 codestring_rec_.code_j,                 
                 event_code_,
                 str_code_,
                 local_debit_credit_db_,
                 accounting_value_,
                 booking_source_,
                 currency_code_,
                 local_currency_rate_,
                 accounting_curr_amount_,
                 accounting_date_,
                 account_err_desc_,
                 account_err_status_,
                 activity_seq_,
                 contract_,
                 userid_,
                 date_of_origin_,
                 inventory_value_status_db_,
                 NULL,
                 NULL,
                 cost_source_id_,
                 bucket_posting_group_id_,
                 per_oh_adjustment_id_,
                 conversion_factor_,
                 accounting_parallel_amount_,
                 parallel_currency_rate_,
                 parallel_conversion_factor_,
                 trans_reval_event_id_);

      IF (pre_ac_error_flag_ OR ac_error_flag_) THEN
         RAISE error_accounting;
      END IF;
      rcode_ := 'SUCCESS';
   END IF;
EXCEPTION
   WHEN no_accounting THEN
      NULL;
   WHEN error_accounting THEN
      rcode_ := 'ERROR';
END Do_Accounting___;


PROCEDURE Set_Po_Line_Keys_From_Rma___(
   pur_order_no_    OUT VARCHAR2,
   pur_line_no_     OUT VARCHAR2,
   pur_release_no_  OUT VARCHAR2,
   oe_rma_no_       IN  NUMBER,
   oe_rma_line_no_  IN  NUMBER )   
IS   
BEGIN   
   $IF (Component_Order_SYS.INSTALLED) $THEN
      Return_Material_Line_API.Get_Demand_Purchase_Order_Info(pur_order_no_,
                                                              pur_line_no_,
                                                              pur_release_no_,
                                                              oe_rma_no_,
                                                              oe_rma_line_no_);
   $ELSE
      Error_SYS.Component_Not_Exist('ORDER');
   $END   
END Set_Po_Line_Keys_From_Rma___;


PROCEDURE Set_Purch_Order_Line_Ref___ (
   control_type_key_rec_ IN OUT Mpccom_Accounting_API.Control_Type_Key)
IS
   stmt_  VARCHAR2(2000);
BEGIN
   stmt_ := 'DECLARE
                invtrans_rec_ Inventory_Transaction_Hist_API.Public_rec;
             BEGIN
                invtrans_rec_ := Inventory_Transaction_Hist_API.Get(:transaction_id); 
                :po_order_no  := invtrans_rec_.alt_source_ref1;
                :po_line_no   := invtrans_rec_.alt_source_ref2;
                :po_rel_no    := invtrans_rec_.alt_source_ref3;
             END;';
         @ApproveDynamicStatement(2013-06-28,ErFelk)
         EXECUTE IMMEDIATE stmt_
            USING IN  control_type_key_rec_.transaction_id_, 
                  OUT control_type_key_rec_.pur_order_no_,
                  OUT control_type_key_rec_.pur_line_no_,
                  OUT control_type_key_rec_.pur_release_no_;
END Set_Purch_Order_Line_Ref___;


PROCEDURE Clear_Purch_Order_Line_Ref___ (
   control_type_key_rec_ IN OUT Mpccom_Accounting_API.Control_Type_Key)
IS
BEGIN
   control_type_key_rec_.pur_order_no_   := NULL;
   control_type_key_rec_.pur_line_no_    := NULL;
   control_type_key_rec_.pur_release_no_ := NULL;
END Clear_Purch_Order_Line_Ref___;


PROCEDURE Modify_Control_Type_Key_Rec___ (
   control_type_key_rec_ IN OUT Mpccom_Accounting_API.Control_Type_Key,
   event_code_           IN     VARCHAR2,
   posting_type_         IN     VARCHAR2 )
IS
BEGIN

   control_type_key_rec_.pre_accounting_id_ := NULL;

   IF (event_code_ IN ('PRICEDIFF+', 'PRICEDIFF-')) THEN
      -- PRICEDIFF+/- can be used on both transactions with PURCH and ORDER reference.

      IF (control_type_key_rec_.oe_order_no_ IS NOT NULL) THEN
         -- This time it is a transaction with a Customer Order Line reference  
         IF (posting_type_ IN ('M10', 'M19', 'M20')) THEN
            -- This is a 'Customer Order' event but you'll need Purchase Order data for the M10 posting type.
            Set_Purch_Order_Line_Ref___(control_type_key_rec_);
         ELSE
            -- Remove the Purchase Order Line reference from control_type_key_rec_.
            Clear_Purch_Order_Line_Ref___(control_type_key_rec_);
         END IF;
      END IF;
   ELSE 
      IF posting_type_ IN ('M10', 'M57', 'M189') THEN
         -- This is a 'Customer Order' event but you'll need Purchase Order data for the M10 posting type.
         Set_Purch_Order_Line_Ref___(control_type_key_rec_);
      ELSIF posting_type_ IN ('M24', 'M4') THEN
         -- Clear the Purchase Order data to avoid incorrect fetching
         -- of pre_accounting_id for the M24 posting for this special event.
         Clear_Purch_Order_Line_Ref___(control_type_key_rec_);
      END IF;
   END IF;
END Modify_Control_Type_Key_Rec___;


FUNCTION Get_Function_Group___ (
   booking_source_db_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   function_group_ VARCHAR2(3);
BEGIN
   function_group_ := CASE booking_source_db_
                         WHEN Mpccom_Transaction_Source_API.DB_INVENTORY                 THEN 'L'
                         WHEN Mpccom_Transaction_Source_API.DB_PURCHASE                  THEN '0'
                         WHEN Mpccom_Transaction_Source_API.DB_OPERATION                 THEN 'O'
                         WHEN Mpccom_Transaction_Source_API.DB_LABOR                     THEN 'O'
                         WHEN Mpccom_Transaction_Source_API.DB_SHOP_ORDER_GENERAL        THEN 'O'
                         WHEN Mpccom_Transaction_Source_API.DB_INDIRECT_LABOR            THEN 'TI'
                         WHEN Mpccom_Transaction_Source_API.DB_RENTAL                    THEN 'RT'
                         WHEN Mpccom_Transaction_Source_API.DB_FIELD_SERVICE_MANAGEMENT  THEN 'FSM'      
                      END;
   RETURN (function_group_);
END Get_Function_Group___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT MPCCOM_ACCOUNTING_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   super(objid_, objversion_, newrec_, attr_);
   -- Check if the posting is connected to a work order
   -- Work Order postings should be passed on to the Work Order
   IF (Is_Work_Task_Posting___(newrec_.str_code, newrec_.accounting_id)) THEN
      Send_Posting_To_Pcm___(newrec_,'INSERT');
   END IF;

   IF (newrec_.debit_credit = 'D') THEN
      Client_SYS.Add_To_Attr('DEBIT_AMOUNT', newrec_.value, attr_);
      Client_SYS.Add_To_Attr('CREDIT_AMOUNT', to_number(NULL), attr_);
      Client_SYS.Add_To_Attr('DEBIT_CREDIT_AMOUNT', newrec_.value, attr_);
   ELSE
      Client_SYS.Add_To_Attr('DEBIT_AMOUNT', to_number(NULL), attr_);
      Client_SYS.Add_To_Attr('CREDIT_AMOUNT', newrec_.value, attr_);
      Client_SYS.Add_To_Attr('DEBIT_CREDIT_AMOUNT', newrec_.value * -1, attr_);
   END IF;
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     MPCCOM_ACCOUNTING_TAB%ROWTYPE,
   newrec_     IN OUT MPCCOM_ACCOUNTING_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   -- Check if the posting is connected to a work task
   -- Work Order postings should be passed on to the Work Task
   IF (Is_Work_Task_Posting___(newrec_.str_code, newrec_.accounting_id)) THEN
      Send_Posting_To_Pcm___(newrec_,'UPDATE');
   END IF;

   IF (newrec_.debit_credit = 'D') THEN
      Client_SYS.Add_To_Attr('DEBIT_AMOUNT', newrec_.value, attr_);
      Client_SYS.Add_To_Attr('CREDIT_AMOUNT', to_number(NULL), attr_);
      Client_SYS.Add_To_Attr('DEBIT_CREDIT_AMOUNT', newrec_.value, attr_);
   ELSE
      Client_SYS.Add_To_Attr('DEBIT_AMOUNT', to_number(NULL), attr_);
      Client_SYS.Add_To_Attr('CREDIT_AMOUNT', newrec_.value, attr_);
      Client_SYS.Add_To_Attr('DEBIT_CREDIT_AMOUNT', newrec_.value * -1, attr_);
   END IF;

   IF (oldrec_.status_code != '3' AND newrec_.status_code = '3') THEN
      IF (NVL(newrec_.activity_seq,0) != 0) THEN
         Project_Refresh_Accounting_API.New(newrec_.accounting_id, newrec_.contract, newrec_.booking_source);
      END IF;
   END IF;
END Update___;


@Override
PROCEDURE Check_Delete___ (
   remrec_                  IN MPCCOM_ACCOUNTING_TAB%ROWTYPE,
   check_restricted_delete_ IN BOOLEAN DEFAULT TRUE )
IS
   exit_procedure EXCEPTION;
BEGIN
   -- Make sure the posting has not been transferred to Finance
   IF (remrec_.status_code = '3') THEN
      Error_SYS.Record_General('MpccomAccounting','NO_REMOVE: Posting has been transferred to Finance and may not be removed');
   END IF;

   IF NOT (check_restricted_delete_) THEN
      RAISE exit_procedure;
   END IF;

   super(remrec_);
EXCEPTION
   WHEN exit_procedure THEN
      NULL;
END Check_Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT mpccom_accounting_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   site_rec_       Site_API.Public_Rec;
BEGIN
   IF NOT (indrec_.date_of_origin) THEN 
      -- Initialize date_of_origin to current date.
      -- A different date may be passed in when postings are recreated when for
      -- instance modifying date_applied on a inventory transaction
      IF (newrec_.contract IS NOT NULL) THEN
         newrec_.date_of_origin := TRUNC(Site_API.Get_Site_Date(newrec_.contract));
      END IF;
   END IF;

   IF NOT (indrec_.inventory_value_status) THEN   
      -- Only postings from inventory with posting type M1 and M3
      -- should affect inventory value calculations
      IF (newrec_.booking_source = Mpccom_Transaction_Source_API.DB_INVENTORY AND newrec_.str_code IN ('M1', 'M3')) THEN
         newrec_.inventory_value_status := 'NOT INCLUDED';
      ELSE
         newrec_.inventory_value_status := 'NOT APPLICABLE';
      END IF;
   END IF;
   super(newrec_, indrec_, attr_);
   
   Error_SYS.Check_Not_Null(lu_name_, 'CONVERSION_FACTOR', newrec_.conversion_factor);

   site_rec_ := Site_API.Get(newrec_.contract);
   -- Make sure the site is connected to the specified company
   IF (site_rec_.company != newrec_.company) THEN
      Error_Sys.Record_General(lu_name_, 'COMPANYERR: A company mismatch has occured. Site :P1 is connected to company :P2 but the company saved on the accounting is :P3.', newrec_.contract, site_rec_.company, newrec_.company);
   END IF;

   -- Truncate dates to make sure that only the date is saved
   newrec_.date_applied   := TRUNC(newrec_.date_applied);
   newrec_.date_of_origin := TRUNC(newrec_.date_of_origin);
   IF (newrec_.date_applied != TRUNC(SYSDATE + (site_rec_.offset/24))) THEN
      Check_Date_Applied(newrec_.company, newrec_.date_applied);
   END IF;
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     mpccom_accounting_tab%ROWTYPE,
   newrec_ IN OUT mpccom_accounting_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   site_date_ DATE;
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);

   -- Truncate date_applied to make sure that only the date is saved
   newrec_.date_applied := TRUNC(newrec_.date_applied);
   IF (newrec_.date_applied != oldrec_.date_applied) THEN
      site_date_ := Site_API.Get_Site_Date(newrec_.contract);
      IF (newrec_.date_applied != TRUNC(site_date_)) THEN
         Check_Date_Applied(newrec_.company, newrec_.date_applied);
      END IF;
   END IF;
END Check_Update___;

FUNCTION Get_Merged_Curr_Amount_Tab___ (
   curr_amount_detail_tab_ IN Curr_Amount_Detail_Tab ) RETURN Curr_Amount_Detail_Tab
IS
   merged_curr_amount_tab_  Curr_Amount_Detail_Tab;
   row_no_                  PLS_INTEGER := 1;
   detail_found_            BOOLEAN;
   char_null_               CONSTANT VARCHAR2(12) := 'VARCHAR2NULL';
   number_null_             CONSTANT VARCHAR2(12) := '-9999';
BEGIN
   IF (curr_amount_detail_tab_.COUNT > 0) THEN
      FOR i IN curr_amount_detail_tab_.FIRST..curr_amount_detail_tab_.LAST LOOP
         detail_found_ := FALSE;
         IF (merged_curr_amount_tab_.COUNT > 0) THEN
            FOR j IN merged_curr_amount_tab_.FIRST..merged_curr_amount_tab_.LAST LOOP
               IF ((curr_amount_detail_tab_(i).currency_code = merged_curr_amount_tab_(j).currency_code) AND
                   (curr_amount_detail_tab_(i).currency_rate = merged_curr_amount_tab_(j).currency_rate) AND
                   (NVL(curr_amount_detail_tab_(i).conversion_factor,number_null_) = NVL(merged_curr_amount_tab_(j).conversion_factor,number_null_)) AND
                   (NVL(curr_amount_detail_tab_(i).inverted_currency_rate,char_null_) = NVL(merged_curr_amount_tab_(j).inverted_currency_rate,char_null_))) THEN
                   
                  merged_curr_amount_tab_(j).curr_amount := merged_curr_amount_tab_(j).curr_amount + curr_amount_detail_tab_(i).curr_amount;
                  merged_curr_amount_tab_(j).value := merged_curr_amount_tab_(j).value + curr_amount_detail_tab_(i).value;
                  detail_found_ := TRUE;
                  EXIT;
                  
               END IF;
            END LOOP;
         END IF;
         IF NOT (detail_found_) THEN
            merged_curr_amount_tab_(row_no_)                   := curr_amount_detail_tab_(i);
            row_no_ := row_no_ + 1;
         END IF;
      END LOOP;
   END IF;

   RETURN (merged_curr_amount_tab_);
END Get_Merged_Curr_Amount_Tab___;


PROCEDURE Do_Curr_Amount_Posting___ (
   new_postings_created_  IN OUT BOOLEAN,
   accounting_id_         IN     NUMBER,
   prev_posted_rec_       IN     mpccom_accounting_tab%ROWTYPE,
   company_               IN     VARCHAR2,
   trans_reval_event_id_  IN     NUMBER,
   event_code_            IN     VARCHAR2,
   str_code_              IN     VARCHAR2,
   debit_credit_db_       IN     VARCHAR2,
   currency_amount_       IN     NUMBER,
   currency_code_         IN     VARCHAR2,
   contract_              IN     VARCHAR2,
   date_posted_           IN     DATE,
   from_old_posting_      IN     BOOLEAN,
   generate_code_string_  IN     BOOLEAN,
   control_type_key_rec_  IN     Control_Type_Key)
IS
   pre_accounting_flag_db_     VARCHAR2(1);
   project_accounting_flag_db_ VARCHAR2(200);
   rcode_                      VARCHAR2(80);
   dummy_                      VARCHAR2(80);
   local_event_code_           MPCCOM_ACCOUNTING_TAB.event_code%TYPE;
   local_str_code_             MPCCOM_ACCOUNTING_TAB.str_code%TYPE;
BEGIN
   IF (from_old_posting_ OR generate_code_string_) THEN
      IF (generate_code_string_) THEN
         local_event_code_ := event_code_;
         local_str_code_ := str_code_;
      ELSE
         local_event_code_ := prev_posted_rec_.event_code;
         local_str_code_ := prev_posted_rec_.str_code;
      END IF;   
      -- No reval postings created in base currency. But the transaction currency diff postings are to be created
      pre_accounting_flag_db_ := Acc_Event_Posting_Type_API.Get_Pre_Accounting_Flag_Db(local_event_code_, local_str_code_, debit_credit_db_);
      project_accounting_flag_db_ := Acc_Event_Posting_Type_API.Get_Project_Accounting_Flag_Db(local_event_code_, local_str_code_, debit_credit_db_);

      Do_Accounting(rcode_                      => rcode_,
                    company_                    => company_,
                    event_code_                 => event_code_,
                    str_code_                   => str_code_,
                    pre_accounting_flag_db_     => pre_accounting_flag_db_,
                    accounting_id_              => accounting_id_,
                    debit_credit_db_            => debit_credit_db_,
                    value_                      => 0,
                    booking_source_             => 'INVENTORY',
                    currency_code_              => currency_code_,
                    currency_rate_              => 0,
                    curr_amount_                => currency_amount_,
                    accounting_date_            => date_posted_,
                    project_accounting_flag_db_ => project_accounting_flag_db_,
                    contract_                   => contract_,
                    userid_                     => Fnd_Session_API.Get_Fnd_User,
                    conversion_factor_          => 1,
                    control_type_key_rec_       => control_type_key_rec_,
                    date_of_origin_             => date_posted_,
                    trans_reval_event_id_       => trans_reval_event_id_);      
      
      Complete_Check_Accounting(dummy_,
                                company_,
                                date_posted_,
                                accounting_id_);
      new_postings_created_ := TRUE;                                        
   ELSE                          
      Do_New___ (default_seq_                => NULL,
                 company_                    => company_,
                 accounting_id_              => accounting_id_,
                 account_no_in_              => prev_posted_rec_.account_no,
                 codeno_b_                   => prev_posted_rec_.codeno_b,
                 codeno_c_                   => prev_posted_rec_.codeno_c,
                 codeno_d_                   => prev_posted_rec_.codeno_d,
                 codeno_e_                   => prev_posted_rec_.codeno_e,
                 codeno_f_                   => prev_posted_rec_.codeno_f,
                 codeno_g_                   => prev_posted_rec_.codeno_g,
                 codeno_h_                   => prev_posted_rec_.codeno_h,
                 codeno_i_                   => prev_posted_rec_.codeno_i,
                 codeno_j_                   => prev_posted_rec_.codeno_j,   
                 event_code_                 => event_code_,
                 str_code_in_                => str_code_,
                 debit_credit_               => debit_credit_db_,
                 value_in_                   => 0,
                 booking_source_             => prev_posted_rec_.booking_source,
                 currency_code_              => currency_code_,
                 currency_rate_              => 0,
                 curr_amount_                => currency_amount_,
                 date_applied_               => prev_posted_rec_.date_applied,
                 error_desc_                 => prev_posted_rec_.error_desc,
                 status_code_                => prev_posted_rec_.status_code,
                 activity_seq_               => prev_posted_rec_.activity_seq,
                 contract_                   => contract_,
                 userid_                     => prev_posted_rec_.userid,
                 date_of_origin_             => prev_posted_rec_.date_of_origin,
                 inventory_value_status_db_  => NULL,
                 original_accounting_id_     => prev_posted_rec_.original_accounting_id,
                 original_seq_               => prev_posted_rec_.original_seq,
                 cost_source_id_             => prev_posted_rec_.cost_source_id,
                 bucket_posting_group_id_    => prev_posted_rec_.bucket_posting_group_id,
                 per_oh_adjustment_id_       => prev_posted_rec_.per_oh_adjustment_id,
                 conversion_factor_          => 1,
                 parallel_amount_            => NULL,
                 parallel_currency_rate_     => NULL,
                 parallel_conversion_factor_ => NULL,
                 trans_reval_event_id_       => trans_reval_event_id_);      
      
   END IF;
            
END Do_Curr_Amount_Posting___;

-- This method is used to extract account matching information that is passed to the financials through voucher row.
FUNCTION Get_Suppl_Invoic_Matching_Info___(
   source_ref1_            VARCHAR2,
   source_ref2_            VARCHAR2,
   source_ref3_            VARCHAR2,
   source_ref_type_db_     VARCHAR2,
   alt_source_ref1_        VARCHAR2,
   alt_source_ref2_        VARCHAR2,
   alt_source_ref3_        VARCHAR2,
   alt_source_ref_type_db_ VARCHAR2) RETURN VARCHAR2 
IS
   matching_info_       VARCHAR2(200);   
BEGIN
   IF (source_ref_type_db_ = Order_Type_API.DB_PURCHASE_ORDER) THEN  
      matching_info_:= source_ref_type_db_||'^'||source_ref1_||'^'||source_ref2_||'^'||source_ref3_;
   ELSE
      IF (alt_source_ref_type_db_ = Order_Type_API.DB_CUSTOMER_ORDER_DIRECT) THEN         
         matching_info_ := Order_Type_API.DB_PURCHASE_ORDER||'^'||alt_source_ref1_||'^'||alt_source_ref2_||'^'||alt_source_ref3_;      
      END IF;
   END IF;
   RETURN matching_info_;
END Get_Suppl_Invoic_Matching_Info___;

PROCEDURE Validate_Fa_Object_Account___(
   company_    IN VARCHAR2,
   code_a_     IN mpccom_accounting_tab.account_no%TYPE,
   code_b_     IN mpccom_accounting_tab.codeno_b%TYPE,
   code_c_     IN mpccom_accounting_tab.codeno_c%TYPE,
   code_d_     IN mpccom_accounting_tab.codeno_d%TYPE,
   code_e_     IN mpccom_accounting_tab.codeno_e%TYPE,
   code_f_     IN mpccom_accounting_tab.codeno_f%TYPE,
   code_g_     IN mpccom_accounting_tab.codeno_g%TYPE,
   code_h_     IN mpccom_accounting_tab.codeno_h%TYPE,
   code_i_     IN mpccom_accounting_tab.codeno_i%TYPE,
   code_j_     IN mpccom_accounting_tab.codeno_j%TYPE )
IS
   acc_code_str_rec_ Accounting_Codestr_API.CodestrRec;
   record_general    EXCEPTION;
   PRAGMA            EXCEPTION_INIT(record_general, -20110);
   error_code_       VARCHAR2(30) := 'FaObject.CHKACQ3:';
   error_message_    VARCHAR2(2000);
   start_position_   NUMBER;
BEGIN
   $IF Component_Fixass_SYS.INSTALLED $THEN
      acc_code_str_rec_.code_a := code_a_;
      acc_code_str_rec_.code_b := code_b_;
      acc_code_str_rec_.code_c := code_c_;
      acc_code_str_rec_.code_d := code_d_;
      acc_code_str_rec_.code_e := code_e_;
      acc_code_str_rec_.code_f := code_f_;
      acc_code_str_rec_.code_g := code_g_;
      acc_code_str_rec_.code_h := code_h_;
      acc_code_str_rec_.code_i := code_i_;
      acc_code_str_rec_.code_j := code_j_;
      acc_code_str_rec_.function_group := '0';
   
      Fa_Object_API.Check_Acquisition(company_, acc_code_str_rec_);
   $ELSE
      NULL;
      -- FIXASS component is not installed.
   $END
EXCEPTION
   WHEN record_general THEN
      IF (INSTR(sqlerrm, error_code_) != 0) THEN
         start_position_ := INSTR(sqlerrm, error_code_) + length(error_code_);
         error_message_  := SUBSTR(sqlerrm, start_position_ , length(sqlerrm)- start_position_ );
         Error_SYS.Record_General(lu_name_, 'FAOBJECTACTIVE: Cannot cancel a receipt or undo inspection results. :P1', error_message_);
      END IF;
   WHEN OTHERS THEN
      RAISE;
END Validate_Fa_Object_Account___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Control_Codestrings__
--   Completes accountings.
PROCEDURE Control_Codestrings__ (
   contract_ IN VARCHAR2 )
IS
   attr_        VARCHAR2(32000);
   batch_desc_  VARCHAR2(100);
BEGIN
   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, contract_);
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_);
   batch_desc_:= Language_SYS.Translate_Constant(lu_name_,'BDESCCONT: Codestring Completion');
   Transaction_SYS.Deferred_Call('Mpccom_Accounting_API.Control_Codestrings_Deferred__',attr_,batch_desc_);
END Control_Codestrings__;


-- Redo_Error_Bookings__
--   Reruns error bookings.
PROCEDURE Redo_Error_Bookings__ (
   contract_ IN VARCHAR2 )
IS
   attr_        VARCHAR2(32000);
   batch_desc_  VARCHAR2(100);
   CURSOR get_all_contracts_ IS
      SELECT site
      FROM user_allowed_site_pub
      WHERE (site LIKE NVL(contract_,'%'));
BEGIN
   User_Allowed_Site_API.Exist_With_Wildcard (contract_);

   FOR contract_rec_ IN get_all_contracts_ LOOP
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('CONTRACT', contract_rec_.site, attr_);
      batch_desc_:= Language_SYS.Translate_Constant(lu_name_,'BDESCRUN: Rerun erroneous accountings for site :P1. ',Language_SYS.Get_Language, contract_rec_.site);
      Transaction_SYS.Deferred_Call('Mpccom_Accounting_API.Redo_Error_Bookings_Deferred__',attr_,batch_desc_);
   END LOOP;
END Redo_Error_Bookings__;


PROCEDURE Redo_Error_Bookings_Deferred__ (
  attrib_ IN VARCHAR2 )
IS
  ptr_      NUMBER;
  name_     VARCHAR2(35);
  value_    VARCHAR2(2000);
  contract_ VARCHAR2(5);
BEGIN
   WHILE (Client_SYS.Get_Next_From_Attr(attrib_, ptr_, name_, value_)) LOOP
      IF (name_ = 'CONTRACT') THEN
         contract_ := value_;
      ELSE
         Error_SYS.Item_Not_Exist(lu_name_, name_, value_);
      END IF;
   END LOOP;
   --
   -- Due to the fact that new postings may be added to existing inventory transactions
   -- when registering a supplier invoice the recreation of inventory postings
   -- has to be driven from MpccomAccounting.
   -- The reason is that some of the postings connected to a transaction
   -- might already be transferred to Financials.
   --
   $IF (Component_Invent_SYS.INSTALLED) $THEN
      Redo_Error_Postings___(contract_, Mpccom_Transaction_Source_API.DB_INVENTORY);
      -- Method executed on a background job.
      @ApproveTransactionStatement(2009-10-21,kayolk)
      COMMIT;
   $END

   $IF (Component_Purch_SYS.INSTALLED) $THEN
      Purchase_Transaction_Hist_Api.Redo_Error_Booking(contract_);
      -- Method executed on a background job.
      @ApproveTransactionStatement(2009-10-21,kayolk)
      COMMIT;
   $END

   $IF (Component_Mfgstd_SYS.INSTALLED) $THEN
      Redo_Error_Postings___(contract_, Mpccom_Transaction_Source_API.DB_LABOR);
      -- Method executed on a background job.
      @ApproveTransactionStatement(2009-10-21,kayolk)
      COMMIT;
      Redo_Error_Postings___(contract_, Mpccom_Transaction_Source_API.DB_OPERATION);
      -- Method executed on a background job.
      @ApproveTransactionStatement(2009-10-21,kayolk)
      COMMIT;
   $END
   $IF (Component_Shpord_SYS.INSTALLED) $THEN
      Redo_Error_Postings___(contract_, Mpccom_Transaction_Source_API.DB_SHOP_ORDER_GENERAL);
      -- Method executed on a background job.
      @ApproveTransactionStatement(2009-10-21,kayolk)
      COMMIT;
      Redo_Error_Postings___(contract_, Mpccom_Transaction_Source_API.DB_INDIRECT_LABOR);
      -- Method executed on a background job.
      @ApproveTransactionStatement(2010-09-08,joanse)
      COMMIT;
   $END
   $IF Component_Rental_SYS.INSTALLED $THEN
      Redo_Error_Postings___(contract_, Mpccom_Transaction_Source_API.DB_RENTAL);
      -- Method executed on a background job.
      @ApproveTransactionStatement(2013-02-12,nasalk)
      COMMIT;
   $END
   $IF Component_Fsmapp_SYS.INSTALLED $THEN
      Redo_Error_Postings___(contract_, Mpccom_Transaction_Source_API.DB_FIELD_SERVICE_MANAGEMENT);
      -- Method executed on a background job.
      @ApproveTransactionStatement(2016-09-13,meablk)
      COMMIT;
   $END
END Redo_Error_Bookings_Deferred__;


-- Control_Codestrings_Deferred__
--   Completes accountings.
PROCEDURE Control_Codestrings_Deferred__ (
   attr_ IN VARCHAR2 )
IS
   contract_ VARCHAR2(5);
   ptr_      NUMBER;
   name_     VARCHAR2(35);
   value_    VARCHAR2(2000);
BEGIN
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'CONTRACT') THEN
         contract_ := value_;
      ELSE
         Error_SYS.Item_Not_Exist(lu_name_, name_, value_);
      END IF;
   END LOOP;

   Complete_Check_Acc_Batch(contract_);
END Control_Codestrings_Deferred__;


-- Transfer_To_Finance__
--   Recreate error postings, execute code string completion and start the
--   transfer of postings to Finance for a specified site and booking source.
PROCEDURE Transfer_To_Finance__ (
   attrib_ IN VARCHAR2 )
IS
   ptr_                NUMBER;
   name_               VARCHAR2(30);
   value_              VARCHAR2(2000);
   date_applied_       DATE;
   contract_           MPCCOM_ACCOUNTING_TAB.contract%TYPE;
   booking_source_     MPCCOM_ACCOUNTING_TAB.booking_source%TYPE;
   count_              NUMBER;
   job_id_tab_         Message_SYS.Name_Table;
   attrib_tab_         Message_SYS.Line_Table;
   job_id_value_       VARCHAR2 (30);
   attrib_value_       VARCHAR2 (32000);
   msg_                VARCHAR2 (32000);
   deferred_call_      VARCHAR2 (200) := 'Mpccom_Accounting_API.Transfer_To_Finance__';
   job_contract_       MPCCOM_ACCOUNTING_TAB.contract%TYPE;
   job_booking_source_ MPCCOM_ACCOUNTING_TAB.booking_source%TYPE;
   current_job_id_     NUMBER;
   execution_offset_   NUMBER;
BEGIN
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attrib_, ptr_, name_, value_)) LOOP
      IF (name_ = 'DATE_APPLIED') THEN
         date_applied_ := Client_SYS.Attr_Value_To_Date(value_);
      ELSIF (name_ = 'EXECUTION_OFFSET') THEN
         execution_offset_ := value_;
      ELSIF (name_ = 'CONTRACT') THEN
         contract_ := value_;
      ELSIF (name_ = 'BOOKING_SOURCE') THEN
         booking_source_ := value_;
      ELSE
         Error_SYS.Item_Not_Exist(lu_name_, name_, value_);
      END IF;
   END LOOP;

   IF (execution_offset_ IS NOT NULL) AND (date_applied_ IS NULL) THEN
      date_applied_ := TRUNC(Site_API.Get_Site_Date(contract_)) - execution_offset_;
   END IF;

   -- Stop this process if the same process is executing for the entered Site (contract).
   current_job_id_ := Transaction_SYS.Get_Current_Job_Id;
   Transaction_SYS.Get_Executing_Job_Arguments(msg_, deferred_call_);
   Message_SYS.Get_Attributes(msg_, count_, job_id_tab_, attrib_tab_);
   FOR i_ IN 1..count_ LOOP
      job_id_value_       := job_id_tab_(i_);
      attrib_value_       := attrib_tab_(i_);
      job_contract_       := Client_SYS.Get_Item_Value('CONTRACT',attrib_value_);
      job_booking_source_ := Client_SYS.Get_Item_Value('BOOKING_SOURCE',attrib_value_);
      -- Check to see if another job of this type is executing
      IF ((current_job_id_    != job_id_value_  ) AND
          (job_contract_       = contract_      ) AND
          (job_booking_source_ = booking_source_)) THEN
         -- The word 'already' implies that you are trying to run it for the same site.
         IF (booking_source_ = Mpccom_Transaction_Source_API.DB_INVENTORY) THEN
            Error_SYS.Record_General(lu_name_, 'INV_TRANSF_RUNNING: Transfer of Inventory postings to Finance is already running for site :P1. Aborting this process.', contract_);
         ELSIF (booking_source_ = Mpccom_Transaction_Source_API.DB_PURCHASE) THEN
            Error_SYS.Record_General(lu_name_, 'PUR_TRANSF_RUNNING: Transfer of Purchase postings to Finance is already running for site :P1. Aborting this process.', contract_);
         ELSIF (booking_source_ = Mpccom_Transaction_Source_API.DB_LABOR) THEN
            Error_SYS.Record_General(lu_name_, 'LAB_TRANSF_RUNNING: Transfer of Labor postings to Finance is already running for site :P1. Aborting this process.', contract_);
         ELSIF (booking_source_ = Mpccom_Transaction_Source_API.DB_OPERATION ) THEN
            Error_SYS.Record_General(lu_name_, 'OP_TRANSF_RUNNING: Transfer of Operation postings to Finance is already running for site :P1. Aborting this process.', contract_);
         ELSIF (booking_source_ = Mpccom_Transaction_Source_API.DB_SHOP_ORDER_GENERAL) THEN
            Error_SYS.Record_General(lu_name_, 'SOGEN_TRANSF_RUNNING: Transfer of Shop Order General OH posting to Finance is already running for site :P1. Aborting this process.', contract_);
         ELSIF (booking_source_ = Mpccom_Transaction_Source_API.DB_INDIRECT_LABOR) THEN
            Error_SYS.Record_General(lu_name_, 'INDLAB_TRANSF_RUNNING: Transfer of Indirect Labor postings to Finance is already running for site :P1. Aborting this process.', contract_);
         ELSIF (booking_source_ = Mpccom_Transaction_Source_API.DB_RENTAL) THEN
            Error_SYS.Record_General(lu_name_, 'RENTAL_TRANSF_RUNNING: Transfer of Rental postings to Finance is already running for site :P1. Aborting this process.', contract_);
         ELSIF (booking_source_ = Mpccom_Transaction_Source_API.DB_FIELD_SERVICE_MANAGEMENT) THEN
            Error_SYS.Record_General(lu_name_, 'FSM_TRANSF_RUNNING: Transfer of Fsm postings to Finance is already running for site :P1. Aborting this process.', contract_);
         
         END IF;
      END IF;
   END LOOP;

   Redo_Error_Postings___(contract_, booking_source_, date_applied_);
      
   -- Method executed on a background job.
   @ApproveTransactionStatement(2009-10-21,kayolk)
   COMMIT;

   Complete_Check_Acc_Batch(contract_);

   -- Method executed on a background job.
   @ApproveTransactionStatement(2009-10-21,kayolk)
   COMMIT;

   Transfer_To_Finance___(contract_, date_applied_, booking_source_);

END Transfer_To_Finance__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Check_Postings_In_Balance
--   Check if postings for the specified accounting id are in balance or not
@UncheckedAccess
FUNCTION Check_Postings_In_Balance (
   accounting_id_ IN NUMBER ) RETURN BOOLEAN
IS
   CURSOR get_sum IS
      SELECT SUM(value * (DECODE(debit_credit, 'C', -1, 1)))
      FROM   MPCCOM_ACCOUNTING_TAB
      WHERE  accounting_id = accounting_id_;

   value_  NUMBER;
BEGIN
   OPEN get_sum;
   FETCH get_sum INTO value_;
   CLOSE get_sum;

   -- The total sum of all credit postings should match the total sum of all debit postings
   IF (NVL(value_, 0) = 0) THEN
      RETURN TRUE;
   ELSE
      RETURN FALSE;
   END IF;
END Check_Postings_In_Balance;


-- Check_Voucher_Accounting
--   Checks if specific accounting exists where voucher number is null
--   Get accounting_id from mpccom_accounting_tab.
@UncheckedAccess
FUNCTION Check_Voucher_Accounting (
   accounting_id_ IN NUMBER ) RETURN NUMBER
IS
   temp_accounting_id_    NUMBER;
   CURSOR get_accounting IS
      SELECT  accounting_id
      FROM    MPCCOM_ACCOUNTING_TAB
      WHERE   accounting_id = accounting_id_
      AND     voucher_no IS NULL;
BEGIN
   temp_accounting_id_ := 0;
   OPEN get_accounting;
   FETCH get_accounting INTO temp_accounting_id_;
   CLOSE get_accounting;
   RETURN(temp_accounting_id_);
END Check_Voucher_Accounting;


-- Update_Error_Status
--   Set error status on postings.
--   Called from Inventory_Transaction_Hist when postings are not in balance.
--   Error status is only set on postings not already transferred to Finance.
PROCEDURE Update_Error_Status (
    accounting_id_ IN NUMBER )
IS
   message_text_ VARCHAR2(255);

   CURSOR get_acc IS
      SELECT *
      FROM   MPCCOM_ACCOUNTING_TAB
      WHERE  accounting_id = accounting_id_
      AND status_code IN ('1', '2', '99')
      FOR UPDATE;
BEGIN
   message_text_ := 'NOTBALANCED: This accounting is not balanced.'; --1491

   FOR record_ IN get_acc LOOP
      record_.status_code := '99';
      record_.error_desc  := message_text_;
      Modify___(record_);
   END LOOP;
END Update_Error_Status;


-- Accounting_Transfer
--   Procedure to insert record to IFS Finance when transfer inventory.
--   The date_applied_ parameter can be used to restrict the transfer to
--   only postings for a specific date.
PROCEDURE Accounting_Transfer (
   result_code_          OUT VARCHAR2,
   activity_transferred_ OUT BOOLEAN,
   accounting_id_        IN  NUMBER,
   voucher_type_         IN  VARCHAR2,
   voucher_no_           IN  NUMBER,
   accounting_year_      IN  NUMBER,
   accounting_period_    IN  NUMBER,
   transaction_          IN  VARCHAR2,
   order_no_             IN  VARCHAR2,
   quantity_             IN  NUMBER,
   transfer_id_          IN  VARCHAR2,
   voucher_id_           IN  VARCHAR2,
   date_applied_         IN  DATE,
   order_type_db_        IN  VARCHAR2,
   vendor_no_            IN  VARCHAR2,
   party_type_db_        IN  VARCHAR2,
   matching_info_        IN  VARCHAR2)
IS
   accounting_rec_   mpccom_accounting_tab%ROWTYPE;
   perform_rollback_ BOOLEAN := FALSE;
   voucher_row_rec_  Voucher_API.VoucherRowRecType;

   CURSOR get_accountings  IS
      SELECT *
      FROM   MPCCOM_ACCOUNTING_TAB
      WHERE  accounting_id = accounting_id_
      AND    status_code = '2'
      AND    date_applied = NVL(date_applied_, date_applied)
      FOR UPDATE;
   --2(Completed)

   TYPE Accounting_Tab IS TABLE OF MPCCOM_ACCOUNTING_TAB%ROWTYPE
   INDEX BY PLS_INTEGER;

   accounting_tab_        Accounting_Tab;
BEGIN

   OPEN get_accountings;
   FETCH get_accountings BULK COLLECT INTO accounting_tab_;
   CLOSE get_accountings;  

   IF (accounting_tab_.COUNT > 0) THEN
      result_code_          := 'SUCCESS';
      perform_rollback_     := FALSE;
      activity_transferred_ := FALSE;
      -- Method executed on a background job.
      @ApproveTransactionStatement(2009-10-21,kayolk)
      SAVEPOINT before_voucher_row_creation;

      FOR i IN accounting_tab_.FIRST..accounting_tab_.LAST LOOP
         accounting_rec_ := accounting_tab_(i); 

         voucher_row_rec_.company                 := to_char(NULL);
         voucher_row_rec_.voucher_type            := to_char(NULL);
         voucher_row_rec_.accounting_year         := accounting_year_;
         voucher_row_rec_.voucher_no              := to_number(NULL);
         voucher_row_rec_.row_no                  := to_number(NULL);
         voucher_row_rec_.Codestring_Rec.code_a   := accounting_rec_.account_no;
         voucher_row_rec_.Codestring_Rec.code_b   := accounting_rec_.codeno_b;
         voucher_row_rec_.Codestring_Rec.code_c   := accounting_rec_.codeno_c;
         voucher_row_rec_.Codestring_Rec.code_d   := accounting_rec_.codeno_d;
         voucher_row_rec_.Codestring_Rec.code_e   := accounting_rec_.codeno_e;
         voucher_row_rec_.Codestring_Rec.code_f   := accounting_rec_.codeno_f;
         voucher_row_rec_.Codestring_Rec.code_g   := accounting_rec_.codeno_g;
         voucher_row_rec_.Codestring_Rec.code_h   := accounting_rec_.codeno_h;
         voucher_row_rec_.Codestring_Rec.code_i   := accounting_rec_.codeno_i;
         voucher_row_rec_.Codestring_Rec.code_j   := accounting_rec_.codeno_j;
         voucher_row_rec_.quantity                := quantity_;
         voucher_row_rec_.correction              := 'N';

         IF accounting_rec_.debit_credit = 'D' THEN
            voucher_row_rec_.currency_debet_amount        := accounting_rec_.curr_amount;
            voucher_row_rec_.currency_credit_amount       := to_number(NULL);
            voucher_row_rec_.debet_amount                 := accounting_rec_.value;
            voucher_row_rec_.credit_amount                := to_number(NULL);
            voucher_row_rec_.currency_amount              := accounting_rec_.curr_amount;
            voucher_row_rec_.third_currency_debit_amount  := accounting_rec_.parallel_amount;
            voucher_row_rec_.third_currency_credit_amount := to_number(NULL);
         ELSE
            voucher_row_rec_.currency_debet_amount        := to_number(NULL);
            voucher_row_rec_.currency_credit_amount       := accounting_rec_.curr_amount;
            voucher_row_rec_.debet_amount                 := to_number(NULL);
            voucher_row_rec_.credit_amount                := accounting_rec_.value;
            voucher_row_rec_.currency_amount              := (-1) * accounting_rec_.curr_amount;
            voucher_row_rec_.third_currency_debit_amount  := to_number(NULL);
            voucher_row_rec_.third_currency_credit_amount := accounting_rec_.parallel_amount;
         END IF;

         voucher_row_rec_.amount                       := to_number(NULL);
         voucher_row_rec_.third_currency_amount        := to_number(NULL);
         voucher_row_rec_.currency_code                := accounting_rec_.currency_code;
         voucher_row_rec_.quantity                     := quantity_;
         voucher_row_rec_.process_code                 := to_char(NULL);
         voucher_row_rec_.optional_code                := to_char(NULL);
         voucher_row_rec_.project_activity_id          := accounting_rec_.activity_seq;
         voucher_row_rec_.text                         := transaction_;
         voucher_row_rec_.party_type                   := party_type_db_;
         voucher_row_rec_.party_type_id                := vendor_no_;
         voucher_row_rec_.reference_serie              := to_char(NULL);
         voucher_row_rec_.reference_number             := order_no_;
         voucher_row_rec_.trans_code                   := accounting_rec_.str_code;
         voucher_row_rec_.update_error                 := to_char(NULL);
         voucher_row_rec_.transfer_id                  := transfer_id_;
         voucher_row_rec_.corrected                    := 'N';
         voucher_row_rec_.mpccom_accounting_id         := accounting_id_;
         voucher_row_rec_.reference_serie              := order_type_db_;
         voucher_row_rec_.parallel_currency_rate       := accounting_rec_.parallel_currency_rate;
         voucher_row_rec_.parallel_curr_conv_fac       := accounting_rec_.parallel_conversion_factor;
         voucher_row_rec_.matching_info                := matching_info_;
         
         DECLARE
            ac_error    EXCEPTION;
            ac_error2   EXCEPTION;
            PRAGMA      EXCEPTION_INIT(ac_error, -20105);
            PRAGMA      EXCEPTION_INIT(ac_error2, -20110);
         BEGIN
            Voucher_Api.Add_Voucher_Row(voucher_row_rec_,
                                        transfer_id_,
                                        voucher_id_,
                                        FALSE);
            IF (perform_rollback_) THEN
               -- Method executed on a background job.
               @ApproveTransactionStatement(2009-10-21,kayolk)
               ROLLBACK TO before_voucher_row_creation;
            ELSE
               accounting_rec_.status_code       := '3';
               accounting_rec_.voucher_no        := voucher_no_;
               accounting_rec_.voucher_type      := voucher_type_;
               accounting_rec_.accounting_year   := accounting_year_;
               accounting_rec_.accounting_period := accounting_period_;
               Modify___(accounting_rec_);

               IF (NVL(accounting_rec_.activity_seq,0) > 0) THEN
                  activity_transferred_ := TRUE;
               END IF;
            END IF;
         EXCEPTION
            WHEN ac_error OR ac_error2 THEN
               -- Method executed on a background job.
               @ApproveTransactionStatement(2009-10-21,kayolk)
               ROLLBACK TO before_voucher_row_creation;

               accounting_rec_.error_desc  := SUBSTR(sqlerrm, Instr(sqlerrm, ':', 1, 2)+2, 2000);
               accounting_rec_.status_code := '99';
               Modify___(accounting_rec_);

               -- Method executed on a background job.
               @ApproveTransactionStatement(2009-10-21,kayolk)
               SAVEPOINT before_voucher_row_creation;
               result_code_      := 'ERROR';
               perform_rollback_ := TRUE;
               activity_transferred_ := FALSE;
         END;
      END LOOP;
   END IF; 
END Accounting_Transfer;

-- Do_Accounting
--   Based on specified posting event (event_code), posting_type (str_code_)
--   pre accounting information and the accounting rule setup this method
--   retrieves the code string values and creates a new posting record
--   Note that this method should not be used for creating postings for
--   Cancel transactions
PROCEDURE Do_Accounting (
   rcode_                      OUT VARCHAR2,
   company_                    IN  VARCHAR2,
   event_code_                 IN  VARCHAR2,
   str_code_                   IN  VARCHAR2,
   pre_accounting_flag_db_     IN  VARCHAR2,
   accounting_id_              IN  NUMBER,
   debit_credit_db_            IN  VARCHAR2,
   value_                      IN  NUMBER,
   booking_source_             IN  VARCHAR2,
   currency_code_              IN  VARCHAR2,
   currency_rate_              IN  NUMBER,
   curr_amount_                IN  NUMBER,
   accounting_date_            IN  DATE,
   project_accounting_flag_db_ IN  VARCHAR2,
   contract_                   IN  VARCHAR2,
   userid_                     IN  VARCHAR2,
   conversion_factor_          IN  NUMBER,
   control_type_key_rec_       IN  Mpccom_Accounting_API.Control_Type_Key,
   date_of_origin_             IN  DATE DEFAULT NULL,
   cost_source_id_             IN  VARCHAR2 DEFAULT NULL,
   bucket_posting_group_id_    IN  VARCHAR2 DEFAULT NULL,
   inventory_value_status_db_  IN  VARCHAR2 DEFAULT NULL,
   seq_                        IN  NUMBER DEFAULT NULL,
   value_adjustment_           IN  BOOLEAN DEFAULT FALSE,
   per_oh_adjustment_id_       IN  NUMBER DEFAULT NULL,
   parallel_amount_            IN  NUMBER DEFAULT NULL,
   parallel_currency_rate_     IN  NUMBER DEFAULT NULL,
   parallel_conversion_factor_ IN  NUMBER DEFAULT NULL,
   trans_reval_event_id_       IN  NUMBER DEFAULT NULL)
IS   
BEGIN
   Do_Accounting___(rcode_,                    
                    company_,
                    event_code_,
                    str_code_,
                    pre_accounting_flag_db_,
                    accounting_id_,
                    debit_credit_db_,
                    value_,
                    booking_source_,
                    currency_code_,
                    currency_rate_,
                    curr_amount_,
                    accounting_date_,
                    project_accounting_flag_db_,
                    contract_,
                    userid_,
                    date_of_origin_,
                    cost_source_id_,
                    bucket_posting_group_id_,
                    inventory_value_status_db_,
                    seq_,
                    value_adjustment_,
                    per_oh_adjustment_id_,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    conversion_factor_,
                    control_type_key_rec_,
                    parallel_amount_,
                    parallel_currency_rate_,
                    parallel_conversion_factor_,
                    trans_reval_event_id_,
                    NULL);
END Do_Accounting;


-- Accounting_Have_Errors
--   Check if postings within the accounting_id has errors.
--   If the PrePostingOnly flag is TRUE, this method will only check
--   the postings that do allow pre posting.
--   Else, all postings within the accounting id is checked.
@UncheckedAccess
FUNCTION Accounting_Have_Errors (
   accounting_id_    IN NUMBER,
   pre_posting_only_ IN BOOLEAN DEFAULT NULL ) RETURN BOOLEAN
IS
   result_                 BOOLEAN;
   dummy_                  NUMBER;
   local_pre_posting_only_ BOOLEAN;

   CURSOR error_control IS
      SELECT 1
      FROM   MPCCOM_ACCOUNTING_TAB
      WHERE  accounting_id = accounting_id_
      AND    status_code = '99';

   CURSOR error_control_pp IS
      SELECT 1
      FROM   MPCCOM_ACCOUNTING_TAB
      WHERE  Acc_Event_Posting_Type_API.Get_Pre_Accounting_Flag_Db(event_code, str_code, debit_credit) = 'Y'
      AND    accounting_id = accounting_id_
      AND    status_code = '99';
BEGIN
   -- To avoid problems with boolean default value this interpretation is made.
   IF (pre_posting_only_ IS NULL) THEN
      local_pre_posting_only_ := FALSE;
   ELSE
      local_pre_posting_only_ := pre_posting_only_;
   END IF;

   IF local_pre_posting_only_ THEN
      OPEN  error_control_pp;
      FETCH error_control_pp INTO dummy_;
      IF (error_control_pp%FOUND) THEN
         result_ := TRUE;
      ELSE
         result_ := FALSE;
      END IF;
      CLOSE error_control_pp;
   ELSE
      OPEN  error_control;
      FETCH error_control INTO dummy_;
      IF (error_control%FOUND) THEN
         result_ := TRUE;
      ELSE
         result_ := FALSE;
      END IF;
      CLOSE error_control;
   END IF;
   RETURN result_;
END Accounting_Have_Errors;

@UncheckedAccess
FUNCTION Accounting_Have_Errors_Str (
   accounting_id_    IN NUMBER,
   pre_posting_only_ IN BOOLEAN DEFAULT NULL ) RETURN VARCHAR2
IS
   result_ VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;   
BEGIN
   IF (Accounting_Have_Errors(accounting_id_, pre_posting_only_)) THEN
      result_ := Fnd_Boolean_API.DB_TRUE;
   END IF;   
   RETURN result_;
END Accounting_Have_Errors_Str;

-- Complete_Check_Accounting
--   Complete and validate code string.
PROCEDURE Complete_Check_Accounting (
   rcode_         OUT VARCHAR2,
   company_       IN  VARCHAR2,
   voucher_date_  IN  DATE,
   accounting_id_ IN  NUMBER )
IS
   record_          MPCCOM_ACCOUNTING_TAB%ROWTYPE;
   codestring_rec_  Accounting_Codestr_API.CodestrRec;

   complete_error   EXCEPTION;
   complete_error2  EXCEPTION;
   PRAGMA           EXCEPTION_INIT(complete_error,-20105);
   PRAGMA           EXCEPTION_INIT(complete_error2,-20110);
   user_group_      VARCHAR2(30);

   CURSOR get_accounting IS
      SELECT account_no, codeno_b, codeno_c, codeno_d, codeno_e,
             codeno_f, codeno_g, codeno_h, codeno_i, codeno_j,
             str_code,seq, activity_seq, booking_source, userid
      FROM   MPCCOM_ACCOUNTING_TAB
      WHERE  accounting_id = accounting_id_
      AND    status_code = '1';
BEGIN
   rcode_ := 'SUCCESS';
   FOR acc_rec IN get_accounting LOOP
      record_ := Lock_By_Keys___(accounting_id_,acc_rec.seq);

      codestring_rec_.code_a := acc_rec.account_no;
      codestring_rec_.code_b := acc_rec.codeno_b;
      codestring_rec_.code_c := acc_rec.codeno_c;
      codestring_rec_.code_d := acc_rec.codeno_d;
      codestring_rec_.code_e := acc_rec.codeno_e;
      codestring_rec_.code_f := acc_rec.codeno_f;
      codestring_rec_.code_g := acc_rec.codeno_g;
      codestring_rec_.code_h := acc_rec.codeno_h;
      codestring_rec_.code_i := acc_rec.codeno_i;
      codestring_rec_.code_j := acc_rec.codeno_j;

      codestring_rec_.quantity := 1;
      codestring_rec_.text := 'DUMMY';

      Accounting_Codestr_API.Complete_Codestring(
         codestring_rec_,
         company_,
         acc_rec.str_code,
         voucher_date_);

      codestring_rec_.project_activity_id := acc_rec.activity_seq;
      codestring_rec_.function_group := Get_Function_Group___ (acc_rec.booking_source);
      IF (acc_rec.userid IS NULL) THEN
         user_group_ := User_Group_Member_Finance_API.Get_User_Group(company_, Fnd_Session_API.Get_Fnd_User);
      ELSE
         user_group_ := User_Group_Member_Finance_API.Get_User_Group(company_, acc_rec.userid);
         IF (user_group_ IS NULL) THEN
            IF NOT (User_Finance_API.Check_User(company_, acc_rec.userid)) THEN
               user_group_ := User_Group_Member_Finance_API.Get_User_Group(company_, Fnd_Session_API.Get_Fnd_User);
            END IF;
         END IF;
      END IF;

      Accounting_Codestr_API.Validate_Codestring_Mpccom(
         codestring_rec_,
         company_,
         voucher_date_,
         user_group_);

      record_.account_no  := codestring_rec_.code_a;
      record_.codeno_b    := codestring_rec_.code_b;
      record_.codeno_c    := codestring_rec_.code_c;
      record_.codeno_d    := codestring_rec_.code_d;
      record_.codeno_e    := codestring_rec_.code_e;
      record_.codeno_f    := codestring_rec_.code_f;
      record_.codeno_g    := codestring_rec_.code_g;
      record_.codeno_h    := codestring_rec_.code_h;
      record_.codeno_i    := codestring_rec_.code_i;
      record_.codeno_j    := codestring_rec_.code_j;      
      record_.status_code := '2';
      Modify___(record_);

      Trace_SYS.Message('TRACE=> ********** Codestring for posting type '||acc_rec.str_code||' completed and validated. **********');
      Trace_SYS.Message('TRACE=> code_a: '||codestring_rec_.code_a);
      Trace_SYS.Message('TRACE=> code_b: '||codestring_rec_.code_b);
      Trace_SYS.Message('TRACE=> code_c: '||codestring_rec_.code_c);
      Trace_SYS.Message('TRACE=> code_d: '||codestring_rec_.code_d);
      Trace_SYS.Message('TRACE=> code_e: '||codestring_rec_.code_e);
      Trace_SYS.Message('TRACE=> code_f: '||codestring_rec_.code_f);
      Trace_SYS.Message('TRACE=> code_g: '||codestring_rec_.code_g);
      Trace_SYS.Message('TRACE=> code_h: '||codestring_rec_.code_h);
      Trace_SYS.Message('TRACE=> code_i: '||codestring_rec_.code_i);
      Trace_SYS.Message('TRACE=> code_j: '||codestring_rec_.code_j);
   END LOOP;
EXCEPTION
   WHEN complete_error OR complete_error2 THEN
      -- the current record is already locked and record_ have details of the record.
      record_.error_desc  := SUBSTR(sqlerrm,Instr(sqlerrm,':', 1, 2)+2,2000);
      record_.status_code := '99';
      Modify___(record_);

      rcode_ := 'ERROR';
END Complete_Check_Accounting;


-- Complete_Check_Acc_Batch
--   Complete and validate code string.
PROCEDURE Complete_Check_Acc_Batch (
   contract_ IN VARCHAR2 )
IS
   rcode_          VARCHAR2(80);

   CURSOR get_accounting IS
      SELECT accounting_id, company, date_applied, booking_source
      FROM   MPCCOM_ACCOUNTING_TAB
      WHERE  status_code = '1'
      AND    contract = contract_;
BEGIN

   FOR acc_rec IN get_accounting LOOP
      Complete_Check_Accounting(rcode_,
                                acc_rec.company,
                                acc_rec.date_applied,
                                acc_rec.accounting_id );
      IF (rcode_ != 'SUCCESS') THEN
          Modify_Source_Record___(acc_rec.accounting_id,
                                  acc_rec.booking_source);
      END IF;
   END LOOP;
END Complete_Check_Acc_Batch;


-- Remove_Accounting
--   Removes accounting.
PROCEDURE Remove_Accounting (
   accounting_id_      IN NUMBER )
IS
   dummy_curr_amt_posting_tab_  Curr_Amount_Posting_Tab;

BEGIN
   Remove_Accounting(dummy_curr_amt_posting_tab_, accounting_id_, NULL);

END Remove_Accounting;

PROCEDURE Remove_Accounting (
   old_curr_amount_posting_tab_  OUT Curr_Amount_Posting_Tab,
   accounting_id_                IN  NUMBER,
   base_currency_code_           IN  VARCHAR2 )
IS
   objid_      MPCCOM_ACCOUNTING.objid%TYPE;
   objversion_ MPCCOM_ACCOUNTING.objversion%TYPE;
   index_      NUMBER := 0;
   
   CURSOR get_acc IS
      SELECT *
      FROM  MPCCOM_ACCOUNTING_TAB
      WHERE accounting_id = accounting_id_
      FOR UPDATE;
BEGIN
   FOR acc_rec_ IN get_acc LOOP
      IF (Acc_Event_Posting_Type_API.Posting_Type_Needs_Trans_Curr(acc_rec_.str_code) AND base_currency_code_ IS NOT NULL AND base_currency_code_ != acc_rec_.currency_code) THEN
         old_curr_amount_posting_tab_(index_).currency_code := acc_rec_.currency_code;
         old_curr_amount_posting_tab_(index_).curr_amount := acc_rec_.curr_amount;
         old_curr_amount_posting_tab_(index_).conversion_factor := acc_rec_.curr_amount;
         old_curr_amount_posting_tab_(index_).bucket_posting_group_id := acc_rec_.bucket_posting_group_id;       
         old_curr_amount_posting_tab_(index_).event_code := acc_rec_.event_code;
         index_ := index_ + 1;
      END IF;     
      Get_Id_Version_By_Keys___(objid_, objversion_, accounting_id_, acc_rec_.seq);
      Check_Delete___(acc_rec_, check_restricted_delete_ => FALSE);
      Delete___(objid_, acc_rec_);
   END LOOP;
END Remove_Accounting;   

-- Reverse_Accounting
--   Create postings to reverse the postings created for the specified original
--   accounting id. For each reversal posting created the reference to the
--   original posting is stored in the fields original_accounting_id
--   and original_seq
PROCEDURE Reverse_Accounting (
   accounting_id_                IN NUMBER,
   old_accounting_id_            IN NUMBER,
   quantity_                     IN NUMBER,
   old_quantity_                 IN NUMBER,
   date_applied_                 IN DATE DEFAULT NULL,
   validate_fa_object_account_   IN BOOLEAN DEFAULT FALSE)
IS
   status_code_           MPCCOM_ACCOUNTING_TAB.status_code%TYPE;
   booking_source_        MPCCOM_ACCOUNTING_TAB.booking_source%TYPE;
   value_                 MPCCOM_ACCOUNTING_TAB.value%TYPE;
   comp_fin_rec_          Company_Finance_API.Public_Rec;
   debit_credit_          MPCCOM_ACCOUNTING_TAB.debit_credit%TYPE;
   curr_amount_           NUMBER;
   reversal_found_        NUMBER;
   value_round_           NUMBER;
   qty_                   NUMBER;
   old_qty_               NUMBER;
   local_date_applied_    DATE;
   parallel_amount_       NUMBER;
   curr_amount_round_     NUMBER;
   base_curr_rounding_    NUMBER;
   curr_amount_rounding_  NUMBER;
   
   CURSOR get_accounting IS
      SELECT account_no, company, codeno_b, codeno_c, codeno_d, codeno_e, codeno_f,
             codeno_g, codeno_h, codeno_i, codeno_j,
             activity_seq, event_code, str_code,
             debit_credit, currency_code, currency_rate, NVL(conversion_factor, currency_rate) conversion_factor,
             curr_amount*(qty_/old_qty_) curr_amount,
             booking_source, status_code, date_applied, error_desc, seq, contract, userid,
             cost_source_id, bucket_posting_group_id, per_oh_adjustment_id,
             value*(qty_/old_qty_) value, parallel_amount*(qty_/old_qty_) parallel_amount,
             parallel_currency_rate, parallel_conversion_factor, trans_reval_event_id 
      FROM  MPCCOM_ACCOUNTING_TAB
      WHERE accounting_id = old_accounting_id_
        AND event_code NOT IN ('TRANSIBAL+', 'TRANSIBAL-', 'INVREVAL+', 'INVREVAL-')
      ORDER BY seq DESC;

   CURSOR check_accounting_error IS
      SELECT booking_source
      FROM   MPCCOM_ACCOUNTING_TAB
      WHERE  accounting_id = accounting_id_
      AND    status_code   = '99';

   CURSOR check_already_reversed(original_accounting_id_ IN NUMBER,
                                 original_seq_ IN NUMBER) IS
      SELECT 1
      FROM MPCCOM_ACCOUNTING_TAB
      WHERE accounting_id = accounting_id_
      AND   original_accounting_id = original_accounting_id_
      AND   original_seq = original_seq_;
BEGIN

   -- IF there was no quantity on the original transaction then do a complete reversal
   IF (old_quantity_ = 0) THEN
      qty_     := 1;
      old_qty_ := 1;
   ELSE
      qty_     := quantity_;
      old_qty_ := old_quantity_;
   END IF;

   -- Loop over all posting created for the accounting which should be reversed
   FOR acc_rec_ IN get_accounting LOOP
      -- First check if a reversal already exists for the current posting.
      -- This could be the case when additional postings are added to transactions
      -- by the Transaction Based Inventory Revaluation process when matching
      -- a supplier invoice
      OPEN check_already_reversed(old_accounting_id_, acc_rec_.seq);
      FETCH check_already_reversed INTO reversal_found_;
      IF (check_already_reversed%FOUND) THEN
         CLOSE check_already_reversed;
      ELSE
         CLOSE check_already_reversed;
         IF (date_applied_ IS NULL) THEN
            local_date_applied_ := Site_API.Get_Site_Date(acc_rec_.contract);
         ELSE
            local_date_applied_ := date_applied_;
         END IF;

         comp_fin_rec_ := Company_Finance_API.Get(acc_rec_.company);

         -- If correction type = 'REVERSE' we do not want to have negative values on the postings
         -- If a negative value would be found for a posting being reversed then create the reversal as a 'CORRECTION' 
         IF ((comp_fin_rec_.correction_type = 'REVERSE') AND ((acc_rec_.value > 0) OR (acc_rec_.curr_amount > 0))) THEN
            -- Reverse postings should be created by swapping the debit credit flag on the postings
            curr_amount_     := acc_rec_.curr_amount;
            value_           := acc_rec_.value;
            parallel_amount_ := acc_rec_.parallel_amount; 
            IF (acc_rec_.debit_credit = 'C') THEN
               debit_credit_ := 'D';
            ELSE
               debit_credit_ := 'C';
            END IF;
         ELSE
            -- Reverse postings should be created by changing sign on the amount
            curr_amount_     := acc_rec_.curr_amount * (-1);
            parallel_amount_ := acc_rec_.parallel_amount * (-1); 
            debit_credit_    := acc_rec_.debit_credit;
            value_           := acc_rec_.value * (-1);
         END IF;
         
         base_curr_rounding_ := Currency_Code_API.Get_Currency_Rounding(acc_rec_.company, comp_fin_rec_.currency_code);
         value_round_ := ROUND(value_, base_curr_rounding_);
         IF (comp_fin_rec_.currency_code != acc_rec_.currency_code) THEN
            curr_amount_rounding_ := Currency_Code_API.Get_Currency_Rounding(acc_rec_.company, acc_rec_.currency_code);
         ELSE
            curr_amount_rounding_ := base_curr_rounding_;
         END IF;   
         curr_amount_round_ := ROUND(curr_amount_, curr_amount_rounding_);
         
         IF (value_round_ != 0 OR curr_amount_round_ != 0) THEN
            -- No reversal posting has been created yet, create a new.
            IF (acc_rec_.status_code = '3') THEN
               status_code_ := '2';
            ELSE
               status_code_ := acc_rec_.status_code;
            END IF;
            
            IF (validate_fa_object_account_) THEN
               Validate_Fa_Object_Account___( acc_rec_.company, 
                                              acc_rec_.account_no, 
                                              acc_rec_.codeno_b,
                                              acc_rec_.codeno_c,
                                              acc_rec_.codeno_d,
                                              acc_rec_.codeno_e,
                                              acc_rec_.codeno_f,
                                              acc_rec_.codeno_g,
                                              acc_rec_.codeno_h,
                                              acc_rec_.codeno_i,
                                              acc_rec_.codeno_j);
            END IF;
            
            Do_New___(
                     NULL,
                     acc_rec_.company,
                     accounting_id_,
                     acc_rec_.account_no,
                     acc_rec_.codeno_b,
                     acc_rec_.codeno_c,
                     acc_rec_.codeno_d,
                     acc_rec_.codeno_e,
                     acc_rec_.codeno_f,
                     acc_rec_.codeno_g,
                     acc_rec_.codeno_h,
                     acc_rec_.codeno_i,
                     acc_rec_.codeno_j,
                     acc_rec_.event_code,
                     acc_rec_.str_code,
                     debit_credit_,
                     value_,
                     acc_rec_.booking_source,
                     acc_rec_.currency_code,
                     acc_rec_.currency_rate,
                     curr_amount_,
                     local_date_applied_,
                     acc_rec_.error_desc,
                     status_code_,
                     acc_rec_.activity_seq,
                     acc_rec_.contract,
                     acc_rec_.userid,
                     NULL,
                     NULL,
                     old_accounting_id_,
                     acc_rec_.seq,
                     acc_rec_.cost_source_id,
                     acc_rec_.bucket_posting_group_id,
                     acc_rec_.per_oh_adjustment_id,
                     acc_rec_.conversion_factor,
                     parallel_amount_,
                     acc_rec_.parallel_currency_rate,
                     acc_rec_.parallel_conversion_factor,
                     acc_rec_.trans_reval_event_id);
         END IF;
      END IF;
   END LOOP;
   -- Check if any record in mpccom_accounting_tab for a specific accounting_id
   -- have error status. In that case should source table also sets to
   -- error status.
   OPEN  check_accounting_error;
   FETCH check_accounting_error INTO booking_source_;
   IF check_accounting_error%FOUND THEN
      Modify_Source_Record___(
         accounting_id_,
         booking_source_);
   END IF;
   CLOSE check_accounting_error;
END Reverse_Accounting;

-- Get_Code_String
--   Gets code string.
PROCEDURE Get_Code_String (
   account_err_desc_     OUT VARCHAR2,
   account_err_status_   OUT VARCHAR2,
   codestring_rec_       OUT Accounting_Codestr_API.CodestrRec,  
   control_type_key_rec_ IN  Mpccom_Accounting_API.Control_Type_Key,
   company_              IN  VARCHAR2,
   str_code_             IN  VARCHAR2,
   accounting_date_      IN  DATE )
IS
BEGIN
   -- Call the implementation method passing NULL values for cost_source_id and bucket_posting_group_id
   Get_Code_String___(account_err_desc_,
                      account_err_status_,
                      codestring_rec_,
                      control_type_key_rec_,
                      company_,
                      str_code_,
                      accounting_date_,
                      NULL,
                      NULL,
                      NULL,
                      NULL,
                      NULL,
                      NULL,
                      NULL,
                      NULL,
                      NULL,
                      NULL);
END Get_Code_String;

-- Get_Code_String_By_Keys
--   Gets code string using the keys.
PROCEDURE Get_Code_String_By_Keys (
   account_err_desc_     OUT VARCHAR2,
   account_err_status_   OUT VARCHAR2,
   codestring_rec_       OUT Accounting_Codestr_API.CodestrRec,
   accounting_id_        IN  NUMBER,
   seq_                  IN  NUMBER,
   control_type_key_rec_ IN  Mpccom_Accounting_API.Control_Type_Key,
   accounting_date_      IN  DATE )
IS
   rec_  mpccom_accounting_tab%ROWTYPE;     
BEGIN 
   rec_ := Get_Object_By_Keys___(accounting_id_, seq_);
   
   -- Usage of cost_source_id and bucket_posting_group_id from the created postings, will enable them to be used as
   -- control types (C90 and C91).
   Get_Code_String___(account_err_desc_,
                      account_err_status_,
                      codestring_rec_,
                      control_type_key_rec_,
                      rec_.company,
                      rec_.str_code,
                      TRUNC(NVL(accounting_date_, Site_API.Get_Site_Date(rec_.contract))),
                      rec_.cost_source_id,
                      rec_.bucket_posting_group_id,
                      NULL,
                      NULL,
                      NULL,
                      NULL,
                      NULL,
                      NULL,
                      NULL,
                      NULL);
END Get_Code_String_By_Keys;

-- Get_Sum_Value
--   Gets sum of value for accounting.
@UncheckedAccess
FUNCTION Get_Sum_Value (
   accounting_id_ IN NUMBER,
   str_code_      IN VARCHAR2,
   to_date_       IN DATE DEFAULT NULL ) RETURN NUMBER
IS
   CURSOR get_sum IS
      SELECT SUM(value * (DECODE(debit_credit, 'C', -1, 1)))
      FROM   MPCCOM_ACCOUNTING_TAB
      WHERE  accounting_id = accounting_id_
      AND    str_code LIKE str_code_
      AND   (date_applied <= to_date_ OR to_date_ IS NULL);

   total_value_ NUMBER;
BEGIN
   OPEN get_sum;
   FETCH get_sum INTO total_value_;
   CLOSE get_sum;

   RETURN NVL(total_value_, 0);
END Get_Sum_Value;


-- Get_Sum_Value_Details
--   Return a table containing postings created for the specified
--   accounting_id and str_code (posting type) summarized per
--   bucket posting group and cost source.
--   If and event_code is specified the method will only return postings
--   booked on the specified event
@UncheckedAccess
FUNCTION Get_Sum_Value_Details (
   accounting_id_ IN NUMBER,
   str_code_      IN VARCHAR2,
   event_code_    IN VARCHAR2 DEFAULT NULL,
   to_date_       IN DATE DEFAULT NULL ) RETURN Value_Detail_Tab
IS
   CURSOR get_sum_details IS
      SELECT NVL(bucket_posting_group_id, '*'),
             NVL(cost_source_id, '*'),
             SUM(value * (DECODE(debit_credit, 'C', -1, 1)))
      FROM   MPCCOM_ACCOUNTING_TAB
      WHERE  accounting_id = accounting_id_
      AND    str_code LIKE str_code_
      AND    ((event_code = event_code_) OR (event_code_ IS NULL))
      AND    (date_applied <= to_date_ OR to_date_ IS NULL)
      GROUP BY bucket_posting_group_id, cost_source_id;

   value_detail_tab_ Value_Detail_Tab;
BEGIN
   OPEN get_sum_details;
   FETCH get_sum_details BULK COLLECT INTO value_detail_tab_;
   CLOSE get_sum_details;

   RETURN value_detail_tab_;
END Get_Sum_Value_Details;


-- Get_Total_Cost
--   Get total cost for accounting.
@UncheckedAccess
FUNCTION Get_Total_Cost (
   accounting_id_ IN NUMBER ) RETURN NUMBER
IS
   -- event codes 'MATCOST','PRODCOST', 'PRODCOST-' comes from Polish Localization follow_up_mat_prod_cost in GET which is brought to core in 2021R2
   -- whith a completely different solution. These event can only exist for a customer that has been running the localization mentioned above.
   -- We need to do this exception for customers that are upgrading from the localization. 
   CURSOR it_cur IS
      SELECT Sum(VALUE)
      FROM MPCCOM_ACCOUNTING_TAB
      WHERE accounting_id = accounting_id_
        AND debit_credit = 'D'
        AND event_code NOT IN ('MATCOST','PRODCOST', 'PRODCOST-');

   total_cost_ NUMBER;
BEGIN
   OPEN it_cur;
   FETCH it_cur INTO total_cost_;
   CLOSE it_cur;

   RETURN total_cost_;
END Get_Total_Cost;


-- Inherit_Code_Parts
--   Inheritance of code parts between accounting events.
PROCEDURE Inherit_Code_Parts (
   accounting_id_       IN NUMBER,
   from_event_code_     IN VARCHAR2,
   from_debit_credit_   IN VARCHAR2,
   to_event_code_       IN VARCHAR2,
   to_debit_credit_     IN VARCHAR2 )
IS
   from_rec_      mpccom_accounting_tab%ROWTYPE;
   newrec_        mpccom_accounting_tab%ROWTYPE;
   exit_procedure EXCEPTION;
   update_needed_ BOOLEAN := FALSE;
   
   CURSOR from_acc IS
      SELECT *
      FROM   mpccom_accounting_tab
      WHERE  accounting_id = accounting_id_
      AND    event_code = from_event_code_
      AND    debit_credit = from_debit_credit_
      FOR UPDATE;

   CURSOR to_acc IS
      SELECT *
      FROM   mpccom_accounting_tab
      WHERE  accounting_id = accounting_id_
      AND    event_code = to_event_code_
      AND    debit_credit = to_debit_credit_
      FOR UPDATE;
BEGIN
   -- Fetch record based on the in parameters, accounting_id +seq is the key since
   -- there is one D and one C for every accounting_id
   OPEN from_acc;
   FETCH from_acc INTO from_rec_;
   IF (from_acc%NOTFOUND) THEN
      CLOSE from_acc;
      RAISE exit_procedure;
   END IF;
   CLOSE from_acc;

   OPEN to_acc;
   FETCH to_acc INTO newrec_;
   IF (to_acc%NOTFOUND) THEN
      CLOSE to_acc;
      RAISE exit_procedure;
   END IF;
   CLOSE to_acc;

   IF (from_rec_.codeno_b IS NOT NULL AND newrec_.codeno_b IS NULL) THEN
      newrec_.codeno_b := from_rec_.codeno_b;
      update_needed_   := TRUE;
   END IF;
   IF (from_rec_.codeno_c IS NOT NULL AND newrec_.codeno_c IS NULL) THEN
      newrec_.codeno_c := from_rec_.codeno_c;
      update_needed_   := TRUE;
   END IF;
   IF (from_rec_.codeno_d IS NOT NULL AND newrec_.codeno_d IS NULL) THEN
      newrec_.codeno_d := from_rec_.codeno_d;
      update_needed_   := TRUE;
   END IF;
   IF (from_rec_.codeno_e IS NOT NULL AND newrec_.codeno_e IS NULL) THEN
      newrec_.codeno_e := from_rec_.codeno_e;
      update_needed_   := TRUE;
   END IF;
   IF (from_rec_.codeno_f IS NOT NULL AND newrec_.codeno_f IS NULL) THEN
      newrec_.codeno_f := from_rec_.codeno_f;
      update_needed_   := TRUE;
   END IF;   
   IF (from_rec_.codeno_g IS NOT NULL AND newrec_.codeno_g IS NULL) THEN
      newrec_.codeno_g := from_rec_.codeno_g;
      update_needed_   := TRUE;
   END IF;
   IF (from_rec_.codeno_h IS NOT NULL AND newrec_.codeno_h IS NULL) THEN
      newrec_.codeno_h := from_rec_.codeno_h;
      update_needed_   := TRUE;
   END IF;
   IF (from_rec_.codeno_i IS NOT NULL AND newrec_.codeno_i IS NULL) THEN
      newrec_.codeno_i := from_rec_.codeno_i;
      update_needed_   := TRUE;
   END IF;
   IF (from_rec_.codeno_j IS NOT NULL AND newrec_.codeno_j IS NULL) THEN
      newrec_.codeno_j := from_rec_.codeno_j;
      update_needed_   := TRUE;
   END IF;

   IF (update_needed_) THEN
      Modify___(newrec_);
   END IF;
EXCEPTION
   WHEN exit_procedure THEN
      NULL;
END Inherit_Code_Parts;


-- Get_Code_Parts
--   This procedure returns all ten code parts for a specific accounting_id
--   and str_code.
PROCEDURE Get_Code_Parts (
   account_no_    OUT VARCHAR2,
   codeno_b_      OUT VARCHAR2,
   codeno_c_      OUT VARCHAR2,
   codeno_d_      OUT VARCHAR2,
   codeno_e_      OUT VARCHAR2,
   codeno_f_      OUT VARCHAR2,
   codeno_g_      OUT VARCHAR2,
   codeno_h_      OUT VARCHAR2,
   codeno_i_      OUT VARCHAR2,
   codeno_j_      OUT VARCHAR2,   
   activity_seq_  OUT NUMBER,
   accounting_id_ IN  NUMBER,
   str_code_      IN  VARCHAR2 )
IS
   CURSOR get_code_parts IS
      SELECT account_no, codeno_b, codeno_c, codeno_d, codeno_e, codeno_f,
             codeno_g, codeno_h, codeno_i, codeno_j, activity_seq
      FROM   MPCCOM_ACCOUNTING_TAB
      WHERE  accounting_id = accounting_id_
      AND    str_code = str_code_;
BEGIN
   OPEN get_code_parts;
   FETCH get_code_parts INTO account_no_, codeno_b_, codeno_c_, codeno_d_, codeno_e_,
                             codeno_f_, codeno_g_, codeno_h_, codeno_i_, codeno_j_, activity_seq_;
   CLOSE get_code_parts;
END Get_Code_Parts;


-- Get_Total_Abs_Value
--   Gets total cost for one accounting.
@UncheckedAccess
FUNCTION Get_Total_Abs_Value (
   accounting_id_ IN NUMBER ) RETURN NUMBER
IS
   total_cost_          NUMBER;
   acc_event_rec_       Accounting_Event_API.Public_Rec;

   -- event codes 'MATCOST','PRODCOST', 'PRODCOST-' comes from Polish Localization follow_up_mat_prod_cost in GET which is brought to core in 2021R2
   -- whith a completely different solution. These event can only exist for a customer that has been running the localization mentioned above.
   -- We need to do this exception for customers that are upgrading from the localization. 
   CURSOR get_postings IS
      SELECT value, event_code
      FROM MPCCOM_ACCOUNTING_TAB
      WHERE debit_credit  = 'D'
      AND accounting_id = accounting_id_
      AND event_code NOT IN ('MATCOST','PRODCOST', 'PRODCOST-');
BEGIN
   total_cost_ := 0;

   FOR posting_rec_ IN get_postings LOOP
      acc_event_rec_ := Accounting_Event_API.Get(posting_rec_.event_code);
      IF (acc_event_rec_.consignment_event NOT IN ('RETURN EVENT', 'CONSUME EVENT')) THEN
         total_cost_ := total_cost_ + ABS(posting_rec_.value);
      END IF;
   END LOOP;
 
   RETURN total_cost_;
END Get_Total_Abs_Value;


-- Get_A_Pre_Posting_Error_Desc
--   Returns an error description for the specified accounting id and
--   the postings within that accounting id that do allow pre posting.
--   Several error descriptions could exist for an accounting id.
--   This method will only return the first one if there are several.
@UncheckedAccess
FUNCTION Get_A_Pre_Posting_Error_Desc (
   accounting_id_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ MPCCOM_ACCOUNTING_TAB.error_desc%TYPE;

   CURSOR one_of_possible_errors IS
      SELECT error_desc
      FROM   MPCCOM_ACCOUNTING_TAB
      WHERE Acc_Event_Posting_Type_API.Get_Pre_Accounting_Flag_Db(event_code, str_code, debit_credit) = 'Y'
      AND   accounting_id = accounting_id_
      AND   status_code = '99'
      ORDER BY seq ASC;
BEGIN
   OPEN  one_of_possible_errors;
   FETCH one_of_possible_errors INTO temp_;
   CLOSE one_of_possible_errors;
   RETURN temp_;
END Get_A_Pre_Posting_Error_Desc;


-- Get_Status_Per_Accounting_Id
--   Returns the number of accountings in each status for a given
--   accounting id.
PROCEDURE Get_Status_Per_Accounting_Id (
   status_code_1_  OUT NUMBER,
   status_code_2_  OUT NUMBER,
   status_code_3_  OUT NUMBER,
   status_code_99_ OUT NUMBER,
   accounting_id_  IN  NUMBER )
IS
   CURSOR get_codes IS
      SELECT status_code, count(*) number_of_rows
      FROM MPCCOM_ACCOUNTING_TAB
      WHERE accounting_id = accounting_id_
      GROUP BY status_code;
BEGIN
   status_code_1_ := 0;
   status_code_2_ := 0;
   status_code_3_ := 0;
   status_code_99_ := 0;
   FOR codes_rec_ IN get_codes LOOP
      IF codes_rec_.status_code = '1' THEN
         status_code_1_ := codes_rec_.number_of_rows;
      ELSIF codes_rec_.status_code = '2' THEN
         status_code_2_ := codes_rec_.number_of_rows;
      ELSIF codes_rec_.status_code = '3' THEN
         status_code_3_ := codes_rec_.number_of_rows;
      ELSIF codes_rec_.status_code = '99' THEN
         status_code_99_ := codes_rec_.number_of_rows;
      END IF;
   END LOOP;
END Get_Status_Per_Accounting_Id;


-- All_Postings_Transferred
--   Check if all postings for the specified company within the specified
--   period have been transferred to Finance.
--   Should be called from Finance before closing an accounting period.
--   The return value will be the string 'TRUE' if all postings have been
--   transferred, 'FALSE' if not.
@UncheckedAccess
FUNCTION All_Postings_Transferred (
   company_    IN VARCHAR2,
   start_date_ IN DATE,
   end_date_   IN DATE ) RETURN VARCHAR2
IS
   CURSOR get_non_transferred IS
      SELECT 1
      FROM   MPCCOM_ACCOUNTING_TAB
      WHERE company = company_
      AND   status_code IN ('1', '2', '99')
      AND   date_applied BETWEEN start_date_ AND end_date_;
   
   dummy_                NUMBER;
   postings_transferred_ VARCHAR2(5) := 'TRUE';
BEGIN
   OPEN get_non_transferred;
   FETCH get_non_transferred INTO dummy_;

   IF (get_non_transferred%FOUND) THEN
      postings_transferred_ := 'FALSE';
   END IF;

   CLOSE get_non_transferred;
   
   RETURN postings_transferred_;
END All_Postings_Transferred;


-- Get_Activity_Cost_By_Status
--   Returns the total cost for a given status.
@UncheckedAccess
FUNCTION Get_Activity_Cost_By_Status (
   accounting_id_ IN NUMBER,
   status_        IN VARCHAR2 ) RETURN NUMBER
IS
   status_code_1_ MPCCOM_ACCOUNTING_TAB.status_code%TYPE;
   status_code_2_ MPCCOM_ACCOUNTING_TAB.status_code%TYPE;
   status_code_3_ MPCCOM_ACCOUNTING_TAB.status_code%TYPE;
   activity_cost_ NUMBER := 0;
   value_         NUMBER := 0;
   CURSOR get_activity_cost IS
      SELECT value,debit_credit
      FROM MPCCOM_ACCOUNTING_TAB
      WHERE accounting_id = accounting_id_
      AND   (activity_seq IS NOT NULL AND activity_seq >0)
      AND   ((status_code  = status_code_1_)  OR (status_code  = status_code_2_) OR (status_code  = status_code_3_) OR (status_ IS NULL));
BEGIN
   IF (status_ = 'CREATED') THEN
      status_code_1_ := '1';
      status_code_2_ := '1';
      status_code_3_ := '1';
   ELSIF (status_ = 'COMPLETED') THEN
      status_code_1_ := '2';
      status_code_2_ := '2';
      status_code_3_ := '2';
   ELSIF (status_ = 'TRANSFERRED') THEN
      status_code_1_ := '3';
      status_code_2_ := '3';
      status_code_3_ := '3';
   ELSIF (status_ = 'ERROR') THEN
      status_code_1_ := '99';
      status_code_2_ := '99';
      status_code_3_ := '99';
   ELSIF (status_ = 'NOT TRANSFERRED') THEN
      status_code_1_ := '1';
      status_code_2_ := '2';
      status_code_3_ := '99';
   END IF;

   FOR activity_cost IN get_activity_cost LOOP
      IF activity_cost.debit_credit = 'C' THEN
         value_ := -1 * (activity_cost.value);
      ELSE
         value_ := activity_cost.value;
      END IF;
      activity_cost_ := activity_cost_ + value_;
   END LOOP;
   RETURN(NVL(activity_cost_,0));
END Get_Activity_Cost_By_Status;


-- Is_Code_Part_Value_In_Status
--   This will check whether the given code part value is in given status.
--   Returns a Boolean value.
@UncheckedAccess
FUNCTION Is_Code_Part_Value_In_Status (
   company_          IN VARCHAR2,
   code_part_        IN VARCHAR2,
   code_part_value_  IN VARCHAR2,
   status_           IN VARCHAR2 ) RETURN BOOLEAN
IS
   status_code_1_ MPCCOM_ACCOUNTING_TAB.status_code%TYPE;
   status_code_2_ MPCCOM_ACCOUNTING_TAB.status_code%TYPE;
   status_code_3_ MPCCOM_ACCOUNTING_TAB.status_code%TYPE;
   dummy_         NUMBER;

   return_value_  BOOLEAN := FALSE;

   CURSOR exist_codeno_a IS
      SELECT 1
      FROM   MPCCOM_ACCOUNTING_TAB
      WHERE  account_no  = code_part_value_
      AND    ((status_code  = status_code_1_)  OR (status_code  = status_code_2_) OR (status_code  = status_code_3_))
      AND    company = company_;
   
   CURSOR exist_codeno_b IS
      SELECT 1
      FROM   MPCCOM_ACCOUNTING_TAB
      WHERE  codeno_b  = code_part_value_
      AND    ((status_code  = status_code_1_)  OR (status_code  = status_code_2_) OR (status_code  = status_code_3_))
      AND    company = company_;
   
   CURSOR exist_codeno_c IS
      SELECT 1
      FROM   MPCCOM_ACCOUNTING_TAB
      WHERE  codeno_c  = code_part_value_
      AND    ((status_code  = status_code_1_)  OR (status_code  = status_code_2_) OR (status_code  = status_code_3_))
      AND    company = company_;
   
   CURSOR exist_codeno_d IS
      SELECT 1
      FROM   MPCCOM_ACCOUNTING_TAB
      WHERE  codeno_d  = code_part_value_
      AND    ((status_code  = status_code_1_)  OR (status_code  = status_code_2_) OR (status_code  = status_code_3_))
      AND    company = company_;
   
   CURSOR exist_codeno_e IS
      SELECT 1
      FROM   MPCCOM_ACCOUNTING_TAB
      WHERE  codeno_e  = code_part_value_
      AND    ((status_code  = status_code_1_)  OR (status_code  = status_code_2_) OR (status_code  = status_code_3_))
      AND    company = company_;
   
   CURSOR exist_codeno_f IS
      SELECT 1
      FROM   MPCCOM_ACCOUNTING_TAB
      WHERE  codeno_f  = code_part_value_
      AND    ((status_code  = status_code_1_)  OR (status_code  = status_code_2_) OR (status_code  = status_code_3_))
      AND    company = company_;
   
   CURSOR exist_codeno_g IS
      SELECT 1
      FROM   MPCCOM_ACCOUNTING_TAB
      WHERE  codeno_g  = code_part_value_
      AND    ((status_code  = status_code_1_)  OR (status_code  = status_code_2_) OR (status_code  = status_code_3_))
      AND    company = company_;
   
   CURSOR exist_codeno_h IS
      SELECT 1
      FROM   MPCCOM_ACCOUNTING_TAB
      WHERE  codeno_h  = code_part_value_
      AND    ((status_code  = status_code_1_)  OR (status_code  = status_code_2_) OR (status_code  = status_code_3_))
      AND    company = company_;
   
   CURSOR exist_codeno_i IS
      SELECT 1
      FROM   MPCCOM_ACCOUNTING_TAB
      WHERE  codeno_i  = code_part_value_
      AND    ((status_code  = status_code_1_)  OR (status_code  = status_code_2_) OR (status_code  = status_code_3_))
      AND    company = company_;
   
   CURSOR exist_codeno_j IS
      SELECT 1
      FROM   MPCCOM_ACCOUNTING_TAB
      WHERE  codeno_j  = code_part_value_
      AND    ((status_code  = status_code_1_)  OR (status_code  = status_code_2_) OR (status_code  = status_code_3_))
      AND    company = company_;
   
   CURSOR exist_activity_seq IS
      SELECT 1
      FROM   MPCCOM_ACCOUNTING_TAB
      WHERE  activity_seq  = code_part_value_
      AND    ((status_code  = status_code_1_)  OR (status_code  = status_code_2_) OR (status_code  = status_code_3_))
      AND    company = company_;
BEGIN
   IF (status_ = 'CREATED') THEN
      status_code_1_ := '1';
      status_code_2_ := '1';
      status_code_3_ := '1';
   ELSIF (status_ = 'COMPLETED') THEN
      status_code_1_ := '2';
      status_code_2_ := '2';
      status_code_3_ := '2';
   ELSIF (status_ = 'TRANSFERRED') THEN
      status_code_1_ := '3';
      status_code_2_ := '3';
      status_code_3_ := '3';
   ELSIF (status_ = 'ERROR') THEN
      status_code_1_ := '99';
      status_code_2_ := '99';
      status_code_3_ := '99';
   ELSIF (status_ = 'NOT TRANSFERRED') THEN
      status_code_1_ := '1';
      status_code_2_ := '2';
      status_code_3_ := '99';
   END IF;

   IF (code_part_ = 'A') THEN
      OPEN exist_codeno_a;
      FETCH exist_codeno_a INTO dummy_;
      return_value_ := exist_codeno_a%FOUND;
      CLOSE exist_codeno_a;
   ELSIF (code_part_ = 'B') THEN
      OPEN exist_codeno_b;
      FETCH exist_codeno_b INTO dummy_;
      return_value_ := exist_codeno_b%FOUND;
      CLOSE exist_codeno_b;
   ELSIF (code_part_ = 'C') THEN
      OPEN exist_codeno_c;
      FETCH exist_codeno_c INTO dummy_;
      return_value_ := exist_codeno_c%FOUND;
      CLOSE exist_codeno_c;
   ELSIF (code_part_ = 'D') THEN
      OPEN exist_codeno_d;
      FETCH exist_codeno_d INTO dummy_;
      return_value_ := exist_codeno_d%FOUND;
      CLOSE exist_codeno_d;
   ELSIF (code_part_ = 'E') THEN
      OPEN exist_codeno_e;
      FETCH exist_codeno_e INTO dummy_;
      return_value_ := exist_codeno_e%FOUND;
      CLOSE exist_codeno_e;
   ELSIF (code_part_ = 'F') THEN
      OPEN exist_codeno_f;
      FETCH exist_codeno_f INTO dummy_;
      return_value_ := exist_codeno_f%FOUND;
      CLOSE exist_codeno_f;
   ELSIF (code_part_ = 'G') THEN
      OPEN exist_codeno_g;
      FETCH exist_codeno_g INTO dummy_;
      return_value_ := exist_codeno_g%FOUND;
      CLOSE exist_codeno_g;
   ELSIF (code_part_ = 'H') THEN
      OPEN exist_codeno_h;
      FETCH exist_codeno_h INTO dummy_;
      return_value_ := exist_codeno_h%FOUND;
      CLOSE exist_codeno_h;
   ELSIF (code_part_ = 'I') THEN
      OPEN exist_codeno_i;
      FETCH exist_codeno_i INTO dummy_;
      return_value_ := exist_codeno_i%FOUND;
      CLOSE exist_codeno_i;
   ELSIF (code_part_ = 'J') THEN
      OPEN exist_codeno_j;
      FETCH exist_codeno_j INTO dummy_;
      return_value_ := exist_codeno_j%FOUND;
      CLOSE exist_codeno_j;
   ELSIF (code_part_ = 'ACTIVITY_SEQ') THEN
      OPEN exist_activity_seq;
      FETCH exist_activity_seq INTO dummy_;
      return_value_ := exist_activity_seq%FOUND;
      CLOSE exist_activity_seq;
   END IF;
   RETURN return_value_;
END Is_Code_Part_Value_In_Status;


-- Remove
--   Remove the specified record.
PROCEDURE Remove (
   accounting_id_ IN NUMBER,
   seq_           IN NUMBER )
IS
   remrec_     MPCCOM_ACCOUNTING_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN

   remrec_ := Lock_By_Keys___(accounting_id_, seq_);
   Check_Delete___(remrec_);
   Get_Id_Version_By_Keys___(objid_, objversion_, accounting_id_, seq_);
   Delete___(objid_, remrec_);
END Remove;


-- Transferred_Posting_Exists
--   Check if any posting connected to the specified accounting_id has
--   been transferred to Finance
--   Return TRUE if any postings connected to the specified accounting id has
--   been transferred to Finance. Otherwise return FALSE.
@UncheckedAccess
FUNCTION Transferred_Posting_Exists (
   accounting_id_ IN NUMBER ) RETURN BOOLEAN
IS
   found_ NUMBER := 0;

   CURSOR check_transferred IS
      SELECT 1
      FROM MPCCOM_ACCOUNTING_TAB
      WHERE accounting_id = accounting_id_
      AND   status_code = '3';
BEGIN
   OPEN check_transferred;
   FETCH check_transferred INTO found_;
   CLOSE check_transferred;
   RETURN (found_ = 1);
END Transferred_Posting_Exists;


-- Error_Posting_Exists
--   Check if any posting connected to the specified accounting_id is
--   in error status
--   Return TRUE if any posting connected to the specified accounting id
--   exists with an error status. Otherwise FALSE will be returned.
@UncheckedAccess
FUNCTION Error_Posting_Exists (
   accounting_id_ IN NUMBER ) RETURN BOOLEAN
IS
   found_ NUMBER := 0;

   CURSOR check_error IS
      SELECT 1
      FROM MPCCOM_ACCOUNTING_TAB
      WHERE accounting_id = accounting_id_
      AND   status_code = '99';
BEGIN
   OPEN check_error;
   FETCH check_error INTO found_;
   CLOSE check_error;
   RETURN (found_ = 1);
END Error_Posting_Exists;


-- Transfer_To_Finance
--   Initiates background jobs for transfer of postings to Finance.
--   If no value is specified for the contract parameter postings will be
--   transferred for all sites to which the current user has access.
PROCEDURE Transfer_To_Finance (
   contract_         IN VARCHAR2,
   date_applied_     IN DATE,
   execution_offset_ IN NUMBER,
   booking_source_   IN VARCHAR2 )
IS
   attrib_              VARCHAR2(32000);
   batch_desc_          VARCHAR2(1000);
   batch_desc_site_     VARCHAR2(1000);
   execute_online_      BOOLEAN := FALSE;

   CURSOR get_all_contracts_ IS
      SELECT site
      FROM user_allowed_site_pub
      WHERE (site = contract_ OR contract_ IS NULL);
BEGIN
   -- Null is allowed to pass trough this first check.
   IF (contract_ IS NOT NULL) THEN
      Site_API.Exist(contract_);
      User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, contract_);   
      IF (Transaction_SYS.Is_Session_Deferred()) THEN
         execute_online_ := TRUE;
      END IF;
   END IF;

   batch_desc_ := CASE booking_source_
                     WHEN Mpccom_Transaction_Source_API.DB_INVENTORY THEN
                        Language_SYS.Translate_Constant(lu_name_,'BDESCITRAN: Transfer of inventory transaction postings for site ')
                     WHEN Mpccom_Transaction_Source_API.DB_PURCHASE THEN
                        Language_SYS.Translate_Constant(lu_name_,'BDESCPTRAN: Transfer of purchase transaction postings for site ')
                     WHEN Mpccom_Transaction_Source_API.DB_LABOR THEN
                        Language_SYS.Translate_Constant(lu_name_,'BDESCLTRAN: Transfer of labor transaction postings for site ')
                     WHEN Mpccom_Transaction_Source_API.DB_OPERATION THEN
                        Language_SYS.Translate_Constant(lu_name_,'BDESCOTRAN: Transfer of machine operation transaction postings for site ')
                     WHEN Mpccom_Transaction_Source_API.DB_SHOP_ORDER_GENERAL THEN
                        Language_SYS.Translate_Constant(lu_name_,'BDESCSOGENTRAN: Transfer of shop order general oh transaction postings for site ')
                     WHEN Mpccom_Transaction_Source_API.DB_INDIRECT_LABOR THEN
                        Language_SYS.Translate_Constant(lu_name_,'BDESCINLABTRAN: Transfer of indirect labor transaction postings for site ')
                     WHEN Mpccom_Transaction_Source_API.DB_RENTAL THEN
                        Language_SYS.Translate_Constant(lu_name_,'BDESCRENTALTRAN: Transfer of rental transaction postings for site ')
                     WHEN Mpccom_Transaction_Source_API.DB_FIELD_SERVICE_MANAGEMENT THEN
                        Language_SYS.Translate_Constant(lu_name_,'BDESCFSMTRAN: Transfer of fsm transaction postings for site ')
                  END;
   FOR contracts_ IN get_all_contracts_ LOOP
      Client_SYS.Clear_Attr(attrib_);
      Client_SYS.Add_To_Attr('DATE_APPLIED'  ,   date_applied_  , attrib_);
      Client_SYS.Add_To_Attr('EXECUTION_OFFSET', execution_offset_ ,  attrib_);
      Client_SYS.Add_To_Attr('CONTRACT'      ,   contracts_.site,     attrib_);
      Client_SYS.Add_To_Attr('BOOKING_SOURCE',   booking_source_,     attrib_);
      IF (execute_online_ ) THEN
         Transfer_To_Finance__(attrib_);
      ELSE
         batch_desc_site_ := batch_desc_||contracts_.site;
         Transaction_SYS.Deferred_Call('Mpccom_Accounting_API.Transfer_To_Finance__',attrib_,batch_desc_site_);
      END IF;
   END LOOP;
END Transfer_To_Finance;


-- Redo_Reverse_Accounting
--   Recreate postings for a cancel transaction.
--   The postings for the reversal (cancel) transaction are recreated with
--   code part values copied from the original transaction.
--   Only postings not transferred to Finance will be recreated.
--   Note that this method will only be used for postings created for inventory
--   transactions because only these transactions can have additional postings
--   created when matching the supplier invoice.
PROCEDURE Redo_Reverse_Accounting (
   accounting_id_ IN NUMBER,
   date_applied_  IN DATE )
IS
   CURSOR get_postings_to_reverse IS
      SELECT seq
      FROM   MPCCOM_ACCOUNTING_TAB
      WHERE  accounting_id = accounting_id_
      AND    status_code IN ('1', '2', '99')
      AND    original_accounting_id IS NOT NULL;

   CURSOR get_original_values(org_accounting_id_ IN VARCHAR2, org_seq_ IN VARCHAR2) IS
      SELECT account_no, codeno_b, codeno_c, codeno_d, codeno_e, codeno_f, codeno_g, codeno_h,
             codeno_i, codeno_j, activity_seq, status_code, error_desc, trans_reval_event_id
      FROM   MPCCOM_ACCOUNTING_TAB
      WHERE accounting_id = org_accounting_id_
      AND   seq = org_seq_;

   old_rec_                     MPCCOM_ACCOUNTING_TAB%ROWTYPE;
   account_no_                  MPCCOM_ACCOUNTING_TAB.account_no%TYPE;
   codeno_b_                    MPCCOM_ACCOUNTING_TAB.codeno_b%TYPE;
   codeno_c_                    MPCCOM_ACCOUNTING_TAB.codeno_c%TYPE;
   codeno_d_                    MPCCOM_ACCOUNTING_TAB.codeno_d%TYPE;
   codeno_e_                    MPCCOM_ACCOUNTING_TAB.codeno_e%TYPE;
   codeno_f_                    MPCCOM_ACCOUNTING_TAB.codeno_f%TYPE;
   codeno_g_                    MPCCOM_ACCOUNTING_TAB.codeno_g%TYPE;
   codeno_h_                    MPCCOM_ACCOUNTING_TAB.codeno_h%TYPE;
   codeno_i_                    MPCCOM_ACCOUNTING_TAB.codeno_i%TYPE;
   codeno_j_                    MPCCOM_ACCOUNTING_TAB.codeno_j%TYPE;   
   activity_seq_                MPCCOM_ACCOUNTING_TAB.activity_seq%TYPE;
   status_code_                 MPCCOM_ACCOUNTING_TAB.status_code%TYPE;
   error_desc_                  MPCCOM_ACCOUNTING_TAB.error_desc%TYPE;
   booking_source_              MPCCOM_ACCOUNTING_TAB.booking_source%TYPE;
   erroneous_posting_recreated_ BOOLEAN := FALSE;
   trans_reval_event_id_        mpccom_accounting_tab.trans_reval_event_id%TYPE;
BEGIN
   FOR next_posting_ IN get_postings_to_reverse LOOP
      -- Get a copy of the 'old' posting
      old_rec_ := Lock_By_Keys___(accounting_id_, next_posting_.seq);
      --
      -- Remove and recreate the posting using code part values from the original posting
      --
      Remove(accounting_id_, next_posting_.seq);

      OPEN get_original_values(old_rec_.original_accounting_id, old_rec_.original_seq);
      FETCH get_original_values
      INTO account_no_, codeno_b_, codeno_c_, codeno_d_, codeno_e_, codeno_f_, codeno_g_,
      codeno_h_, codeno_i_, codeno_j_, activity_seq_, status_code_, error_desc_, trans_reval_event_id_;
      CLOSE get_original_values;

      -- The posting cannot be recreated in status 'Transferred'
      IF (status_code_ = '3') THEN
         status_code_ := '2';
      ELSIF (status_code_ = '99') THEN
         erroneous_posting_recreated_ := TRUE;
         booking_source_ := old_rec_.booking_source;
      END IF;
      
      Do_New___(
         next_posting_.seq,
         old_rec_.company,
         accounting_id_,
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
         old_rec_.event_code,
         old_rec_.str_code,
         old_rec_.debit_credit,
         old_rec_.value,
         old_rec_.booking_source,
         old_rec_.currency_code,
         old_rec_.currency_rate,
         old_rec_.curr_amount,
         NVL(date_applied_, old_rec_.date_applied),
         error_desc_,
         status_code_,
         activity_seq_,
         old_rec_.contract,
         old_rec_.userid,
         old_rec_.date_of_origin,
         old_rec_.inventory_value_status,
         old_rec_.original_accounting_id,
         old_rec_.original_seq,
         old_rec_.cost_source_id,
         old_rec_.bucket_posting_group_id,
         old_rec_.per_oh_adjustment_id,
         NVL(old_rec_.conversion_factor, old_rec_.currency_rate),
         old_rec_.parallel_amount,
         old_rec_.parallel_currency_rate,
         old_rec_.parallel_conversion_factor,
         trans_reval_event_id_);

   END LOOP;
   IF (erroneous_posting_recreated_) THEN
      Modify_Source_Record___(accounting_id_, booking_source_);
   END IF;
END Redo_Reverse_Accounting;


-- Get_Max_Date_Transferred
--   Used by the Actual Costing functionality.
--   Returns max value for date_applied for postings transferred to Finance
--   for the specified site.
--   Only postings with booking_source = 'INVENTORY' are considered.
@UncheckedAccess
FUNCTION Get_Max_Date_Transferred (
   contract_ IN VARCHAR2 ) RETURN DATE
IS
   CURSOR get_max_date IS
      SELECT MAX(date_applied)
      FROM MPCCOM_ACCOUNTING_TAB
      WHERE contract = contract_
      AND   status_code = '3'
      AND   booking_source = 'INVENTORY';

   max_date_transferred_ DATE;
   first_calendar_date_  DATE := Database_SYS.first_calendar_date_;
BEGIN
   OPEN get_max_date;
   FETCH get_max_date INTO max_date_transferred_;
   CLOSE get_max_date;

   max_date_transferred_ := NVL(max_date_transferred_, first_calendar_date_);
   RETURN max_date_transferred_;
END Get_Max_Date_Transferred;


-- Get_Acc_Value_Not_Included
--   Return the total value for postings connected to the specified
--   accounting id with inventory_value_status = 'NOT INCLUDED' and
--   date_applied = specified date.
@UncheckedAccess
FUNCTION Get_Acc_Value_Not_Included (
   accounting_id_ IN NUMBER,
   date_applied_  IN DATE ) RETURN Value_Detail_Tab
IS
   value_detail_tab_ Value_Detail_Tab;

   CURSOR get_value_not_included IS
      SELECT NVL(bucket_posting_group_id,'*') bucket_posting_group_id,
             NVL(cost_source_id,'*') cost_source_id,
             SUM(value * (DECODE(debit_credit, 'C', -1, 1))) value
      FROM  MPCCOM_ACCOUNTING_TAB
      WHERE accounting_id = accounting_id_
      AND   date_applied = date_applied_
      AND   inventory_value_status = 'NOT INCLUDED'
      GROUP BY NVL(bucket_posting_group_id,'*'), NVL(cost_source_id,'*');
BEGIN
   OPEN  get_value_not_included;
   FETCH get_value_not_included bulk collect INTO value_detail_tab_;
   CLOSE get_value_not_included;

   RETURN (value_detail_tab_);
END Get_Acc_Value_Not_Included;


-- Set_Acc_Value_Included
--   Set the inventory_value_status = 'INCLUDED' for postings connected
--   to the specified accounting id with inventory_value_status_db = 'NOT INCLUDED'
--   and date_applied = specified date
PROCEDURE Set_Acc_Value_Included (
   accounting_id_ IN NUMBER,
   date_applied_  IN DATE )
IS
   CURSOR get_accountings_not_included IS
      SELECT accounting_id,
             seq
      FROM  MPCCOM_ACCOUNTING_TAB
      WHERE accounting_id = accounting_id_
      AND   date_applied = date_applied_
      AND   inventory_value_status = 'NOT INCLUDED';
BEGIN

   FOR next_posting_ IN get_accountings_not_included LOOP
      Set_Inventory_Value_Status___(next_posting_.accounting_id, next_posting_.seq);
   END LOOP;
END Set_Acc_Value_Included;


-- Get_Committed_Or_Actual_Value
--   Return the actual or committed value for a specified accounting_id and
@UncheckedAccess
FUNCTION Get_Committed_Or_Actual_Value (
   company_       IN VARCHAR2,
   accounting_id_ IN NUMBER,
   posting_type_  IN VARCHAR2,
   cost_type_     IN VARCHAR2 ) RETURN NUMBER
IS
   total_value_  NUMBER;
   updated_      VARCHAR2(5);

   CURSOR get_record IS
      SELECT value * (DECODE(debit_credit, 'C', -1, 1)) value,
             voucher_no, voucher_type, accounting_year, contract
      FROM MPCCOM_ACCOUNTING_TAB
      WHERE accounting_id = accounting_id_
        AND str_code      = posting_type_;
BEGIN
   total_value_  := 0;

   FOR rec_ IN get_record LOOP
      IF (cost_type_ = 'C') THEN
         total_value_ := total_value_ + rec_.value;
      ELSE
         $IF (Component_Genled_SYS.INSTALLED) $THEN
            IF (rec_.voucher_no IS NOT NULL) THEN
               updated_ := Gen_Led_Proj_Voucher_Row_API.Is_Voucher_Updated(company_, rec_.accounting_year, rec_.voucher_type, rec_.voucher_no); 
            IF (updated_ = 'TRUE') THEN
               total_value_ := total_value_ + rec_.value;
            END IF;
         END IF;
         $ELSE
            NULL;
         $END
      END IF;
   END LOOP;
   RETURN total_value_;
END Get_Committed_Or_Actual_Value;


-- Check_Credit_Str_Code_Exist
--   Checks whether a Credit entry exist for a given Str code.
--   Returns 1 or 0 depending on value existing or not respectively.
@UncheckedAccess
FUNCTION Check_Credit_Str_Code_Exist (
   accounting_id_ IN NUMBER,
   str_code_      IN VARCHAR2 ) RETURN NUMBER
IS
   temp_ VARCHAR2(10);

   CURSOR get_attr IS
      SELECT 1
      FROM MPCCOM_ACCOUNTING_TAB
      WHERE accounting_id = accounting_id_
      AND   debit_credit = 'C'
      AND   str_code = str_code_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   IF (get_attr%FOUND) THEN
      CLOSE get_attr;
      RETURN 1;
   END IF;
   CLOSE get_attr;
   RETURN 0;
END Check_Credit_Str_Code_Exist;


-- Get_Sum_Event_And_Type_Value
--   Fetch the value of postings.
@UncheckedAccess
FUNCTION Get_Sum_Event_And_Type_Value (
   accounting_id_ IN NUMBER,
   event_code_    IN VARCHAR2,
   str_code_      IN VARCHAR2,
   to_date_       IN DATE ) RETURN NUMBER
IS
   CURSOR event_value IS
      SELECT SUM(value * (DECODE(debit_credit, 'C', -1, 1)))
      FROM   MPCCOM_ACCOUNTING_TAB
      WHERE  event_code LIKE event_code_
      AND    accounting_id = accounting_id_
      AND    str_code      = str_code_
      AND   (date_applied <= to_date_ OR to_date_ IS NULL);

   total_value_ NUMBER;

BEGIN
   OPEN event_value ;
   FETCH event_value INTO total_value_;
   CLOSE event_value ;

   RETURN NVL(total_value_, 0);
END Get_Sum_Event_And_Type_Value;


-- Validate_Params
--   This procedure is called when executing the Schedule Transfer
--   Inventory Transactions.
PROCEDURE Validate_Params (
   message_ IN VARCHAR2 )
IS
   count_      NUMBER;
   name_arr_   Message_SYS.name_table;
   value_arr_  Message_SYS.line_table;
   contract_   VARCHAR2(5);
BEGIN

   Message_SYS.Get_Attributes(message_, count_, name_arr_, value_arr_);

   FOR n_ IN 1..count_ LOOP
      IF (name_arr_(n_) = 'CONTRACT_') THEN
         contract_ := value_arr_(n_);
      END IF;
   END LOOP;

   IF (contract_ IS NOT NULL) THEN
      Site_API.Exist(contract_);
      User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, contract_);
   END IF;
END Validate_Params;


-- Create_Value_Diff_Tables
--   Compare two value detail tables and return the difference found in two tables,
--   one for positive differences and one for negative differences.
PROCEDURE Create_Value_Diff_Tables (
   positive_value_diff_tab_ OUT Value_Detail_Tab,
   negative_value_diff_tab_ OUT Value_Detail_Tab,
   old_value_detail_tab_    IN  Value_Detail_Tab,
   new_value_detail_tab_    IN  Value_Detail_Tab )
IS
   pos_ix_                    PLS_INTEGER := 1;
   neg_ix_                    PLS_INTEGER := 1;
   missing_in_old_detail_tab_ BOOLEAN;
   missing_in_new_detail_tab_ BOOLEAN;
BEGIN

   IF (old_value_detail_tab_.COUNT > 0) THEN
      FOR i IN old_value_detail_tab_.FIRST..old_value_detail_tab_.LAST LOOP
         missing_in_new_detail_tab_ := TRUE;

         IF (new_value_detail_tab_.COUNT > 0) THEN
            FOR j IN new_value_detail_tab_.FIRST..new_value_detail_tab_.LAST LOOP
               IF ((old_value_detail_tab_(i).bucket_posting_group_id =
                                              new_value_detail_tab_(j).bucket_posting_group_id) AND
                   (old_value_detail_tab_(i).cost_source_id          =
                                              new_value_detail_tab_(j).cost_source_id)) THEN

                  IF (old_value_detail_tab_(i).value > new_value_detail_tab_(j).value) THEN

                     negative_value_diff_tab_(neg_ix_) := old_value_detail_tab_(i);
                     negative_value_diff_tab_(neg_ix_).value :=
                           old_value_detail_tab_(i).value - new_value_detail_tab_(j).value;
                     neg_ix_ := neg_ix_ + 1;
                  ELSIF (old_value_detail_tab_(i).value < new_value_detail_tab_(j).value) THEN
                     positive_value_diff_tab_(pos_ix_) := old_value_detail_tab_(i);
                     positive_value_diff_tab_(pos_ix_).value :=
                           new_value_detail_tab_(j).value - old_value_detail_tab_(i).value;
                     pos_ix_ := pos_ix_ + 1;
                  ELSE
                     NULL;
                  END IF;

                  missing_in_new_detail_tab_ := FALSE;
               END IF;
            END LOOP;
         END IF;
         IF (missing_in_new_detail_tab_) THEN
            negative_value_diff_tab_(neg_ix_) := old_value_detail_tab_(i);
            neg_ix_ := neg_ix_ + 1;
         END IF;
      END LOOP;
   END IF;

   IF (new_value_detail_tab_.COUNT > 0) THEN
      FOR i IN new_value_detail_tab_.FIRST..new_value_detail_tab_.LAST LOOP
         missing_in_old_detail_tab_ := TRUE;

         IF (old_value_detail_tab_.COUNT > 0) THEN
            FOR j IN old_value_detail_tab_.FIRST..old_value_detail_tab_.LAST LOOP
               IF ((new_value_detail_tab_(i).bucket_posting_group_id =
                                              old_value_detail_tab_(j).bucket_posting_group_id) AND
                   (new_value_detail_tab_(i).cost_source_id          =
                                              old_value_detail_tab_(j).cost_source_id)) THEN

                  missing_in_old_detail_tab_ := FALSE;
               END IF;
            END LOOP;
         END IF;
         IF (missing_in_old_detail_tab_) THEN
            positive_value_diff_tab_(pos_ix_) := new_value_detail_tab_(i);
            pos_ix_ := pos_ix_ + 1;
         END IF;
      END LOOP;
   END IF;
END Create_Value_Diff_Tables;


-- Get_Sign_Shifted_Value_Tab
--   Takes a value detail tab, shifts the sign for all for
--   all value details and returns the result.
@UncheckedAccess
FUNCTION Get_Sign_Shifted_Value_Tab (
   value_detail_tab_ IN Value_Detail_Tab ) RETURN Value_Detail_Tab
IS
   local_value_detail_tab_ Value_Detail_Tab;
BEGIN
   IF (value_detail_tab_.COUNT > 0) THEN
      FOR i IN value_detail_tab_.FIRST..value_detail_tab_.LAST LOOP
         local_value_detail_tab_(i)       := value_detail_tab_(i);
         local_value_detail_tab_(i).value := value_detail_tab_(i).value * -1;
      END LOOP;
   END IF;
   RETURN (local_value_detail_tab_);
END Get_Sign_Shifted_Value_Tab;


-- Get_Abs_Value_Detail_Tab
--   Takes a value detail tab, calculates the absolute value for
--   all value details and return the result.
@UncheckedAccess
FUNCTION Get_Abs_Value_Detail_Tab (
   value_detail_tab_ IN Value_Detail_Tab ) RETURN Value_Detail_Tab
IS
   local_value_detail_tab_ Value_Detail_Tab;
BEGIN
   IF (value_detail_tab_.COUNT > 0) THEN
      FOR i IN value_detail_tab_.FIRST..value_detail_tab_.LAST LOOP
         local_value_detail_tab_(i)       := value_detail_tab_(i);
         local_value_detail_tab_(i).value := ABS(value_detail_tab_(i).value);
      END LOOP;
   END IF;
   RETURN (local_value_detail_tab_);
END Get_Abs_Value_Detail_Tab;


-- Error_Posting_Exists_String
--   Returns the string value 'TRUE' or 'FALSE' depending on
--   if any error postings exist for the specified accounting id.
@UncheckedAccess
FUNCTION Error_Posting_Exists_String (
   accounting_id_ IN NUMBER ) RETURN VARCHAR2
IS
   error_posting_exists_ VARCHAR2(5) := 'FALSE';
BEGIN
   IF (Error_Posting_Exists(accounting_id_)) THEN
      error_posting_exists_ := 'TRUE';
   END IF;

   RETURN(error_posting_exists_);
END Error_Posting_Exists_String;


-- Transferred_Posting_Exists_Str
--   Return the string 'TRUE' if any postings connected to
--   the specified accounting id has been transferred to Finance.
--   Otherwise return 'FALSE'.
@UncheckedAccess
FUNCTION Transferred_Posting_Exists_Str (
   accounting_id_ IN NUMBER ) RETURN VARCHAR2
IS
   transferred_posting_exists_ VARCHAR2(5) := 'FALSE';
BEGIN
   IF (Transferred_Posting_Exists(accounting_id_)) THEN
      transferred_posting_exists_ := 'TRUE';
   END IF;

   RETURN(transferred_posting_exists_);
END Transferred_Posting_Exists_Str;


@UncheckedAccess
FUNCTION Check_Accounting_Exist (
   accounting_id_ IN NUMBER,
   str_code_      IN VARCHAR2,
   debit_credit_  IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   mpccom_accounting_tab
      WHERE accounting_id = accounting_id_
      AND   (str_code     = str_code_     OR str_code_     IS NULL)
      AND   (debit_credit = debit_credit_ OR debit_credit_ IS NULL);
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN(TRUE);
   END IF;
   CLOSE exist_control;
   RETURN(FALSE);
END Check_Accounting_Exist;


-- Set_Control_Type_Key
--   Sets the Control Type Key values needed for accounting and returns it.
@UncheckedAccess
FUNCTION Set_Control_Type_Key (
   part_no_             IN  VARCHAR2,
   contract_            IN  VARCHAR2,
   transaction_id_      IN  NUMBER,
   pre_accounting_id_   IN  NUMBER,
   activity_seq_        IN  NUMBER,
   source_ref_type_db_  IN  VARCHAR2,
   source_ref1_         IN  VARCHAR2,
   source_ref2_         IN  VARCHAR2,
   source_ref3_         IN  VARCHAR2,
   source_ref4_         IN  NUMBER ) RETURN Mpccom_Accounting_API.Control_Type_Key 
IS
   control_type_key_rec_      Mpccom_Accounting_API.Control_Type_Key;   
BEGIN

   control_type_key_rec_.part_no_           := part_no_;
   control_type_key_rec_.contract_          := contract_;
   control_type_key_rec_.transaction_id_    := transaction_id_;
   control_type_key_rec_.pre_accounting_id_ := pre_accounting_id_;
   control_type_key_rec_.activity_seq_      := activity_seq_;
     
   IF (source_ref_type_db_ = 'CUST ORDER') THEN
         control_type_key_rec_.oe_order_no_      := source_ref1_;
         control_type_key_rec_.oe_line_no_       := source_ref2_;
         control_type_key_rec_.oe_rel_no_        := source_ref3_;
         control_type_key_rec_.oe_line_item_no_  := source_ref4_;
   ELSIF (source_ref_type_db_ = 'PUR ORDER' OR source_ref_type_db_ = 'STAGE PAYMENT') THEN
         control_type_key_rec_.pur_order_no_     := source_ref1_;
         control_type_key_rec_.pur_line_no_      := source_ref2_;
         control_type_key_rec_.pur_release_no_   := source_ref3_;
   ELSIF (source_ref_type_db_ = 'SHOP ORDER') THEN
         control_type_key_rec_.so_order_no_      := source_ref1_;
         control_type_key_rec_.so_release_no_    := source_ref2_;
         control_type_key_rec_.so_sequence_no_   := source_ref3_;
         control_type_key_rec_.so_line_item_no_  := source_ref4_;
   ELSIF (source_ref_type_db_ = 'WORK ORDER') THEN
         control_type_key_rec_.wo_work_order_no_ := source_ref1_;
         control_type_key_rec_.wo_task_seq_      := source_ref2_;
         control_type_key_rec_.wo_mtrl_order_no_ := source_ref3_;
         control_type_key_rec_.wo_line_item_no_  := source_ref4_;
   ELSIF (source_ref_type_db_ = Order_Type_API.DB_WORK_TASK) THEN
         control_type_key_rec_.wt_task_seq_      := source_ref1_;
         control_type_key_rec_.wt_mtrl_order_no_ := source_ref2_;
         control_type_key_rec_.wt_line_item_no_  := source_ref3_;
   ELSIF (source_ref_type_db_ = 'COUNTING') THEN
         control_type_key_rec_.int_order_no_     := source_ref1_;
         control_type_key_rec_.int_line_no_      := source_ref2_;
         control_type_key_rec_.int_release_no_   := source_ref3_;
   ELSIF (source_ref_type_db_ = 'MTRL REQ') THEN
         control_type_key_rec_.int_order_no_     := source_ref1_;
         control_type_key_rec_.int_line_no_      := source_ref2_;
         control_type_key_rec_.int_release_no_   := source_ref3_;
   ELSIF (source_ref_type_db_ = 'PROD SCH') THEN
         control_type_key_rec_.ps_order_no_      := source_ref1_;
         control_type_key_rec_.ps_release_no_    := source_ref2_;
         control_type_key_rec_.ps_sequence_no_   := source_ref3_;
         control_type_key_rec_.ps_line_item_no_  := source_ref4_;
   ELSIF (source_ref_type_db_ = 'PROJECT') THEN
         control_type_key_rec_.prj_project_id_   := source_ref1_;
         control_type_key_rec_.prj_activity_seq_ := source_ref4_;
         control_type_key_rec_.project_mtrl_seq_no_ := TO_NUMBER(source_ref3_);
   ELSIF (source_ref_type_db_ = 'RMA') THEN
         control_type_key_rec_.oe_rma_no_        := TO_NUMBER(source_ref1_);
         control_type_key_rec_.oe_rma_line_no_   := source_ref4_;
   ELSIF (source_ref_type_db_ = 'FIXED ASSET OBJECT') THEN
         control_type_key_rec_.fa_object_id_     := source_ref1_;
         control_type_key_rec_.company_          := source_ref3_;
   ELSIF (source_ref_type_db_ = 'PUR REQ') THEN
         control_type_key_rec_.pur_req_no_       := source_ref1_;
         control_type_key_rec_.pur_req_line_no_  := source_ref2_;
         control_type_key_rec_.pur_req_rel_no_   := source_ref3_;
   ELSIF (source_ref_type_db_ = 'PUR ORDER CHG ORDER') THEN
         control_type_key_rec_.chg_pur_order_no_ := source_ref1_;
         control_type_key_rec_.chg_order_no_     := source_ref2_;
         control_type_key_rec_.chg_line_no_      := source_ref3_;
         control_type_key_rec_.chg_release_no_   := source_ref4_;
   ELSIF (source_ref_type_db_ = Order_Type_API.DB_COMPONENT_REPAIR_EXCHANGE) THEN
         control_type_key_rec_.cro_no_               := source_ref1_;
         control_type_key_rec_.cro_exchange_line_no_ := source_ref2_; 
   ELSIF (source_ref_type_db_ = 'PROJECT_DELIVERABLES') THEN
         control_type_key_rec_.prjdel_item_no_        := source_ref1_;
         control_type_key_rec_.prjdel_item_revision_  := source_ref2_;
         control_type_key_rec_.prjdel_planning_no_    := source_ref3_;
   END IF;

   IF (source_ref_type_db_ IS NOT NULL) THEN
      -- Reset the value in Control_Type_Key_Rec.pre_accounting_id_ when the source_ref_type_db_ is 'FIXED ASSET OBJECT'.
      IF (source_ref_type_db_ = 'FIXED ASSET OBJECT') THEN
         -- We can't set the pre_accounting_id for fixed asset here because we need to
         -- do it in context of a specific posting event. So it will be set inside Do_Accounting___.
         control_type_key_rec_.pre_accounting_id_ := NULL;
      ELSE         
         control_type_key_rec_.pre_accounting_id_ := NVL(Pre_Accounting_API.Get_Pre_Accounting_Id(control_type_key_rec_),
                                                    control_type_key_rec_.pre_accounting_id_); 
      END IF;
   END IF;
   RETURN control_type_key_rec_;
END Set_Control_Type_Key;


-- Get_Project_Cost_Element
--   This method simulates the postings and returns the project cost element
--   as when the postings are created actually in a later stage.
FUNCTION Get_Project_Cost_Element (
   part_no_                      IN VARCHAR2,
   contract_                     IN VARCHAR2,
   source_ref_type_db_           IN VARCHAR2,
   source_ref1_                  IN VARCHAR2,
   source_ref2_                  IN VARCHAR2,
   source_ref3_                  IN VARCHAR2,
   source_ref4_                  IN NUMBER,
   part_related_                 IN BOOLEAN  DEFAULT TRUE,
   bucket_posting_group_id_      IN VARCHAR2 DEFAULT NULL,
   charge_type_                  IN VARCHAR2 DEFAULT NULL,
   charge_group_                 IN VARCHAR2 DEFAULT NULL,
   error_when_element_not_exist_ IN BOOLEAN  DEFAULT TRUE,
   include_charge_               IN BOOLEAN  DEFAULT FALSE,
   supp_grp_                     IN VARCHAR2 DEFAULT NULL,
   stat_grp_                     IN VARCHAR2 DEFAULT NULL,
   assortment_                   IN VARCHAR2 DEFAULT NULL,
   cost_source_id_               IN VARCHAR2 DEFAULT NULL,
   location_type_                IN VARCHAR2 DEFAULT NULL,
   location_group_               IN VARCHAR2 DEFAULT NULL,
   sales_overhead_               IN BOOLEAN  DEFAULT FALSE,
   rental_type_db_               IN VARCHAR2 DEFAULT NULL,
   intra_company_rental_         IN BOOLEAN  DEFAULT FALSE,
   pre_accounting_id_            IN NUMBER   DEFAULT NULL) RETURN VARCHAR2
IS
   project_cost_element_tab_ Project_Cost_Element_Tab;
   project_cost_element_     VARCHAR2(100);
BEGIN
   -- Since introduce of new method of Get_Project_Cost_Elements() this method is redirected through that to 
   -- support old functionality.
   project_cost_element_tab_ := Get_Project_Cost_Elements(part_no_,
                                                          contract_,
                                                          source_ref_type_db_,
                                                          source_ref1_,
                                                          source_ref2_,
                                                          source_ref3_,
                                                          source_ref4_,
                                                          supp_grp_,
                                                          stat_grp_,
                                                          assortment_,
                                                          NULL,
                                                          part_related_,
                                                          bucket_posting_group_id_,
                                                          charge_type_,
                                                          charge_group_,
                                                          error_when_element_not_exist_,
                                                          include_charge_,
                                                          cost_source_id_,
                                                          location_type_,
                                                          location_group_,
                                                          sales_overhead_,
                                                          rental_type_db_,
                                                          intra_company_rental_,
                                                          pre_accounting_id_);
   
   IF project_cost_element_tab_.COUNT > 0 THEN
      project_cost_element_ := project_cost_element_tab_(project_cost_element_tab_.FIRST).project_cost_element;
   END IF;
   RETURN project_cost_element_;
END Get_Project_Cost_Element;


FUNCTION Get_Project_Cost_Elements (
   part_no_                      IN VARCHAR2,
   contract_                     IN VARCHAR2,
   source_ref_type_db_           IN VARCHAR2,
   source_ref1_                  IN VARCHAR2,
   source_ref2_                  IN VARCHAR2,
   source_ref3_                  IN VARCHAR2,
   source_ref4_                  IN NUMBER,
   supp_grp_                     IN VARCHAR2,
   stat_grp_                     IN VARCHAR2,
   assortment_                   IN VARCHAR2,
   total_value_                  IN NUMBER,
   part_related_                 IN BOOLEAN  DEFAULT FALSE,
   bucket_posting_group_id_      IN VARCHAR2 DEFAULT NULL,
   charge_type_                  IN VARCHAR2 DEFAULT NULL,
   charge_group_                 IN VARCHAR2 DEFAULT NULL,
   error_when_element_not_exist_ IN BOOLEAN  DEFAULT TRUE,
   include_charge_               IN BOOLEAN  DEFAULT FALSE,
   cost_source_id_               IN VARCHAR2 DEFAULT NULL,
   location_type_                IN VARCHAR2 DEFAULT NULL,
   location_group_               IN VARCHAR2 DEFAULT NULL,
   sales_overhead_               IN BOOLEAN  DEFAULT FALSE,
   rental_type_db_               IN VARCHAR2 DEFAULT NULL,
   intra_company_rental_         IN BOOLEAN  DEFAULT FALSE,
   pre_accounting_id_            IN NUMBER   DEFAULT NULL,
   condition_code_               IN VARCHAR2 DEFAULT NULL) RETURN Project_Cost_Element_Tab
IS
   event_code_                    MPCCOM_ACCOUNTING_TAB.event_code%TYPE;
   posting_type_                  MPCCOM_ACCOUNTING_TAB.str_code%TYPE;
   company_                       MPCCOM_ACCOUNTING_TAB.company%TYPE;
   currency_code_                 MPCCOM_ACCOUNTING_TAB.currency_code%TYPE;
   currency_rate_                 MPCCOM_ACCOUNTING_TAB.currency_rate%TYPE;
   conv_factor_                   NUMBER;
   currency_type_                 VARCHAR2(10);
   rcode_                         VARCHAR2(80);
   site_date_                     DATE;
   local_cost_source_id_          MPCCOM_ACCOUNTING_TAB.cost_source_id%TYPE;
   local_bucket_posting_group_id_ MPCCOM_ACCOUNTING_TAB.bucket_posting_group_id%TYPE;
   generate_errors_               VARCHAR2(5):= 'FALSE';
   base_code_part_                VARCHAR2(1);
   code_part_value_               VARCHAR2(10);
   
   -- Below variables are initialized with dummy values since their values are not 
   -- important in this process.
   accounting_id_                 NUMBER := mpc_sim_accounting_id.nextval;
   -- Added NVL to use dummy value if the parameter value is null.
   value_                         NUMBER := NVL(total_value_, 1000);
   booking_source_                VARCHAR2(5) := 'DUMMY';

   CURSOR get_str_event_acc IS
      SELECT pre_accounting_flag_db, debit_credit_db, project_accounting_flag_db
      FROM   acc_event_posting_type_pub
      WHERE  event_code = event_code_
      AND    str_code = posting_type_;

   CURSOR get_code_part_values IS
      SELECT account_no, codeno_b,codeno_c,codeno_d,codeno_e,codeno_f,
             codeno_g,codeno_h,codeno_i,codeno_j, error_desc, value
      FROM   MPCCOM_ACCOUNTING_TAB
      WHERE  accounting_id = accounting_id_
      AND    str_code = posting_type_;
   
   eventrec_                      get_str_event_acc%ROWTYPE;
   
   TYPE Code_Part_Value_Tab IS TABLE OF get_code_part_values%ROWTYPE INDEX BY PLS_INTEGER;
   
   code_part_value_tab_           Code_Part_Value_Tab;
   project_cost_element_tab_      Project_Cost_Element_Tab;      
   control_type_key_rec_          Mpccom_Accounting_API.Control_Type_Key;
   activity_seq_                  NUMBER := NULL;
BEGIN
  
   company_   := Site_API.Get_Company(contract_);
   site_date_ := Site_API.Get_Site_Date(contract_);
   
   IF (source_ref_type_db_ = 'MTRL REQ') THEN
      event_code_ := 'INTSHIP';
      posting_type_ := 'M53';
   ELSIF (source_ref_type_db_ IN ('PUR ORDER', 'PUR REQ', 'PUR ORDER CHG ORDER')) THEN
      IF (part_related_) THEN 
         event_code_ := 'ARRIVAL';
         posting_type_ := 'M1';
      ELSE
         event_code_ := 'APINVOICE';
         posting_type_ := 'M93';
      END IF;
   ELSIF (source_ref_type_db_ = 'CUST ORDER') THEN
      IF (part_related_)  THEN
         IF (sales_overhead_) THEN
            event_code_ := 'SALES-OH';
            posting_type_ := 'M194';
         ELSE
            event_code_ := 'OESHIP';
            posting_type_ := 'M24';
         END IF;
      ELSE
         event_code_ := 'OESHIPNI';
         posting_type_ := 'M26';
      END IF;
   ELSIF (source_ref_type_db_ = 'SHOP ORDER') THEN
      event_code_ := 'SOISS';
      posting_type_ := 'M40';
   ELSIF (source_ref_type_db_ = 'WORK ORDER') THEN
      event_code_ := 'WOISS';
      posting_type_ := 'M50';
   ELSIF (source_ref_type_db_ = Order_Type_API.DB_WORK_TASK) THEN
      event_code_ := 'WTISS';
      posting_type_ := 'M50';
   ELSIF (source_ref_type_db_ = 'PROJECT') THEN
      event_code_ := 'PROJISS';
      posting_type_ := 'M62';
   ELSIF (source_ref_type_db_ = 'PUR CHG') THEN
      IF (include_charge_) THEN
         event_code_ := 'ARRCHG';
         posting_type_ := 'M1';
      ELSE
         event_code_ := 'APINVOICE';
         posting_type_ := 'M65';
      END IF;
   ELSIF (source_ref_type_db_ = 'RENTAL') THEN
      IF (rental_type_db_ IN ('PUR ORDER', 'PUR REQ', 'PUR ORDER CHG ORDER')) THEN
         IF (part_related_) THEN
            IF (intra_company_rental_) THEN
               event_code_ := 'INTRNTCOS+';
               posting_type_ := 'M253';
            ELSE
               event_code_ := 'APINVOICE';
               posting_type_ := 'M234';
            END IF;
         ELSE
            IF (intra_company_rental_) THEN
               event_code_ := 'INTRNTCNI+';
               posting_type_ := 'M255';
            ELSE
               event_code_ := 'APINVOICE';
               posting_type_ := 'M235';
            END IF;
         END IF;
      ELSIF (rental_type_db_ = 'PROJECT' ) THEN
         event_code_ := 'PRJRENT+';
         posting_type_ := 'M226';
      ELSIF (rental_type_db_ = 'CUST ORDER' ) THEN
         IF (part_related_) THEN
            --Only inter-site intra-company customer orders are supported here. External COs continue using the normal flow where
            -- customer order invoices are required for postings.
            event_code_ := 'INTRNTREV+';
            posting_type_ := 'M250';
         ELSE
            event_code_ := 'INTRNTRNI+';
            posting_type_ := 'M252';
         END IF;
      ELSIF (rental_type_db_ = 'TASK' ) THEN  
         event_code_ := 'WTRENT+';
         posting_type_ := 'M261';
      END IF;
   ELSIF (source_ref_type_db_ = 'PROJECT_DELIVERABLES') THEN
      event_code_ := 'PD-SHIP';
      posting_type_ := 'M278';
   END IF;

   IF Posting_Ctrl_Public_API.Is_Ctrl_Type_Used_On_Post_Type(company_,
                                                             posting_type_,
                                                             'AC22',
                                                             site_date_) THEN
      -- A value (not NULL) is set for activity_seq_ to run the simulation correctly when the control type AC22 is being used in the company.                                                       
      activity_seq_ := -9999;                                                          
   END IF;
   
   -- Passed activity_seq_ to the method Set_Control_Type_Key. 
   -- Sets the control type key record.
   control_type_key_rec_ := Set_Control_Type_Key (part_no_,
                                                  contract_,
                                                  NULL,
                                                  pre_accounting_id_,
                                                  activity_seq_,
                                                  source_ref_type_db_,
                                                  source_ref1_,
                                                  source_ref2_,
                                                  source_ref3_,
                                                  source_ref4_ );   

   Company_Finance_API.Get_Accounting_Currency(currency_code_, company_);
   Currency_Rate_API.Get_Currency_Rate_Defaults(currency_type_,
                                                conv_factor_,
                                                currency_rate_,
                                                company_,
                                                currency_code_,
                                                site_date_);

   OPEN get_str_event_acc;
   FETCH get_str_event_acc INTO eventrec_;
   CLOSE get_str_event_acc;

   IF (cost_source_id_ != '*') THEN
      local_cost_source_id_ := cost_source_id_;
   END IF;

   IF (bucket_posting_group_id_ != '*') THEN
      local_bucket_posting_group_id_ := bucket_posting_group_id_;
   END IF; 

   -- Simulates the creation of posting and should rollback if one fails
   @ApproveTransactionStatement(2009-10-21,kayolk)
   SAVEPOINT before_create_postings;

   -- Passed NULL to parameters parallel_amount, parallel_currency_rate and parallel_conversion_factor
   -- as it is of no interest to have the correct values in the posting simulation.
   Do_Accounting___( rcode_                      => rcode_,                     
                     company_                    => company_,
                     event_code_                 => event_code_,
                     str_code_                   => posting_type_,
                     pre_accounting_flag_db_     => eventrec_.pre_accounting_flag_db,
                     accounting_id_              => accounting_id_,
                     debit_credit_db_            => eventrec_.debit_credit_db,
                     value_                      => value_,
                     booking_source_             => booking_source_,
                     currency_code_              => currency_code_,
                     currency_rate_              => currency_rate_,
                     curr_amount_                => value_,
                     accounting_date_            => site_date_,
                     project_accounting_flag_db_ => eventrec_.project_accounting_flag_db,
                     contract_                   => contract_,
                     userid_                     => Fnd_Session_API.Get_Fnd_User,
                     date_of_origin_             => NULL,
                     cost_source_id_             => local_cost_source_id_,
                     bucket_posting_group_id_    => local_bucket_posting_group_id_,
                     inventory_value_status_db_  => NULL,
                     seq_                        => NULL,
                     value_adjustment_           => FALSE,
                     per_oh_adjustment_id_       => NULL,
                     charge_type_                => charge_type_,
                     charge_group_               => charge_group_,
                     supp_grp_                   => supp_grp_,
                     stat_grp_                   => stat_grp_,
                     assortment_                 => assortment_,
                     location_type_              => location_type_,
                     location_group_             => location_group_,
                     conversion_factor_          => conv_factor_,
                     control_type_key_rec_       => control_type_key_rec_,
                     parallel_amount_            => NULL,
                     parallel_currency_rate_     => NULL,
                     parallel_conversion_factor_ => NULL,
                     trans_reval_event_id_       => NULL,
                     condition_code_             => condition_code_);
   
   Complete_Check_Accounting(rcode_,
                             company_,
                             site_date_,
                             accounting_id_);
   
   -- For distributed pre-postings, more than one record may be selected. IF we are to support
   -- distributed pre posting, we can store them in a PL- table and pass it back to the caller.
   OPEN  get_code_part_values;
   FETCH get_code_part_values BULK COLLECT INTO code_part_value_tab_;
   CLOSE get_code_part_values;

   -- Simulates the creation of posting and should rollback if one fails 
   @ApproveTransactionStatement(2009-10-21,kayolk)
   ROLLBACK TO SAVEPOINT before_create_postings;

  
   -- When distribution pre posting is used Do_Accounting___() method may create more than one code part record.
   IF (code_part_value_tab_.COUNT > 0) THEN
      IF (error_when_element_not_exist_) THEN
         base_code_part_ := Accounting_Code_Parts_API.Get_Base_For_Followup_Element(company_);
         generate_errors_ := 'TRUE';
      END IF;
      
      FOR i IN code_part_value_tab_.FIRST..code_part_value_tab_.LAST LOOP
         IF (error_when_element_not_exist_ AND base_code_part_ IS NOT NULL) THEN
            IF base_code_part_ = 'A' THEN
               code_part_value_ := CASE code_part_value_tab_(i).account_no WHEN '*' THEN NULL ELSE code_part_value_tab_(i).account_no END;
            ELSIF base_code_part_ = 'B' THEN
               code_part_value_ := code_part_value_tab_(i).codeno_b;
            ELSIF base_code_part_ = 'C' THEN
               code_part_value_ := code_part_value_tab_(i).codeno_c;
            ELSIF base_code_part_ = 'D' THEN
               code_part_value_ := code_part_value_tab_(i).codeno_d;
            ELSIF base_code_part_ = 'E' THEN
               code_part_value_ := code_part_value_tab_(i).codeno_e;
            ELSIF base_code_part_ = 'F' THEN
               code_part_value_ := code_part_value_tab_(i).codeno_f;
            ELSIF base_code_part_ = 'G' THEN
               code_part_value_ := code_part_value_tab_(i).codeno_g;
            ELSIF base_code_part_ = 'H' THEN
               code_part_value_ := code_part_value_tab_(i).codeno_h;
            ELSIF base_code_part_ = 'I' THEN
               code_part_value_ := code_part_value_tab_(i).codeno_i;
            ELSIF base_code_part_ = 'J' THEN
               code_part_value_ := code_part_value_tab_(i).codeno_j;
            END IF;

            IF (code_part_value_ IS NULL) THEN
               IF (code_part_value_tab_(i).error_desc IS NULL) THEN
                  Error_SYS.Record_General(lu_name_, 'ACCNTFORPOSTTYPE2: No value found for code part :P1. Check the Accounting Rules setup for posting type :P2.',
                                           Accounting_Code_Parts_API.Get_Description(company_, base_code_part_), posting_type_);
               ELSE
                  Error_SYS.Record_General(lu_name_, 'ACCNTFORPOSTTYPE: :P1 Check the Accounting Rules setup for posting type :P2.',
                                           code_part_value_tab_(i).error_desc, posting_type_);
               END IF;               
            END IF;
         END IF;

         project_cost_element_tab_(i).project_cost_element := Cost_Element_To_Account_API.Get_Project_Follow_Up_Element(
                                                                          company_, 
                                                                          CASE code_part_value_tab_(i).account_no WHEN '*' THEN NULL ELSE code_part_value_tab_(i).account_no END, 
                                                                          code_part_value_tab_(i).codeno_b,
                                                                          code_part_value_tab_(i).codeno_c,
                                                                          code_part_value_tab_(i).codeno_d,
                                                                          code_part_value_tab_(i).codeno_e,
                                                                          code_part_value_tab_(i).codeno_f,
                                                                          code_part_value_tab_(i).codeno_g,
                                                                          code_part_value_tab_(i).codeno_h,
                                                                          code_part_value_tab_(i).codeno_i,
                                                                          code_part_value_tab_(i).codeno_j,
                                                                          TRUNC(site_date_),
                                                                          generate_errors_,
                                                                          posting_type_);
         project_cost_element_tab_(i).amount := code_part_value_tab_(i).value;
      END LOOP;
   END IF;
   RETURN project_cost_element_tab_;   
END Get_Project_Cost_Elements;

   
PROCEDURE Fill_Temporary_Table (
   accounting_id_tab_ IN Accounting_Id_Tab )
IS
BEGIN
   Clear_Temporary_Table;

   IF (accounting_id_tab_.COUNT > 0) THEN
      FOR i IN accounting_id_tab_.FIRST..accounting_id_tab_.LAST LOOP
         INSERT INTO mpccom_accounting_id_tmp
            (accounting_id)
         VALUES
            (accounting_id_tab_(i));
      END LOOP;
   END IF;
END Fill_Temporary_Table; 


PROCEDURE Clear_Temporary_Table
IS
BEGIN
   DELETE FROM mpccom_accounting_id_tmp;
END Clear_Temporary_Table;


-- Get_From_Temporary_Table
--   To get the content of the temporary table 'MPCCOM_ACCOUNTING_ID_TMP'.
@UncheckedAccess
FUNCTION Get_From_Temporary_Table RETURN Accounting_Id_Tab
IS
   CURSOR get_acc_ids IS
      SELECT accounting_id
        FROM MPCCOM_ACCOUNTING_ID_TMP;
   accounting_id_tab_   Accounting_Id_Tab;
BEGIN
   OPEN   get_acc_ids;
   FETCH  get_acc_ids BULK COLLECT INTO accounting_id_tab_;
   CLOSE  get_acc_ids;
   RETURN accounting_id_tab_;
END Get_From_Temporary_Table;


-- Get_Activity_Costs_By_Status
--   Returns the used cost for the given accounting id and status.
FUNCTION Get_Activity_Costs_By_Status (
   accounting_id_tab_ IN Accounting_Id_Tab,
   status_            IN VARCHAR2,
   event_code_        IN VARCHAR2 DEFAULT NULL ) RETURN Project_Cost_Element_Tab
IS
   status_code_1_            MPCCOM_ACCOUNTING_TAB.status_code%TYPE;
   status_code_2_            MPCCOM_ACCOUNTING_TAB.status_code%TYPE;
   status_code_3_            MPCCOM_ACCOUNTING_TAB.status_code%TYPE;
   project_cost_element_tab_ Project_Cost_Element_Tab;

   CURSOR get_code_parts_and_values IS
      SELECT company,account_no,codeno_b,codeno_c,codeno_d,codeno_e,
             codeno_f,codeno_g,codeno_h,codeno_i,codeno_j,date_applied,
             SUM(CASE debit_credit WHEN 'C' THEN (value * -1) ELSE value END) value,
             SUM(CASE debit_credit WHEN 'C' THEN (curr_amount * -1) ELSE curr_amount END) currency_value
      FROM MPCCOM_ACCOUNTING_TAB
      WHERE accounting_id IN (SELECT accounting_id FROM mpccom_accounting_id_tmp)
      AND   (activity_seq IS NOT NULL AND activity_seq > 0)
      AND   ((status_code  = status_code_1_)  OR (status_code  = status_code_2_) 
                                              OR (status_code  = status_code_3_)
                                              OR (status_ IS NULL))
      AND   (event_code = event_code_ OR event_code_ IS NULL )
      GROUP BY company, account_no,codeno_b,codeno_c,codeno_d,codeno_e,
               codeno_f,codeno_g,codeno_h,codeno_i,codeno_j,date_applied;
   
   TYPE Code_Part_And_Value_Tab IS TABLE OF get_code_parts_and_values%ROWTYPE
      INDEX BY PLS_INTEGER;

   code_part_and_value_tab_ Code_Part_And_Value_Tab;
BEGIN

   IF (status_ = 'CREATED') THEN
      status_code_1_ := '1';
      status_code_2_ := '1';
      status_code_3_ := '1';
   ELSIF (status_ = 'COMPLETED') THEN
      status_code_1_ := '2';
      status_code_2_ := '2';
      status_code_3_ := '2';
   ELSIF (status_ = 'TRANSFERRED') THEN
      status_code_1_ := '3';
      status_code_2_ := '3';
      status_code_3_ := '3';
   ELSIF (status_ = 'ERROR') THEN
      status_code_1_ := '99';
      status_code_2_ := '99';
      status_code_3_ := '99';
   ELSIF (status_ = 'NOT TRANSFERRED') THEN
      status_code_1_ := '1';
      status_code_2_ := '2';
      status_code_3_ := '99';
   END IF;

   Fill_Temporary_Table(accounting_id_tab_);

   OPEN  get_code_parts_and_values;
   FETCH get_code_parts_and_values BULK COLLECT INTO code_part_and_value_tab_;
   CLOSE get_code_parts_and_values;

   Clear_Temporary_Table;

   IF (code_part_and_value_tab_.COUNT > 0) THEN
      FOR i IN code_part_and_value_tab_.FIRST..code_part_and_value_tab_.LAST LOOP
         project_cost_element_tab_(i).amount               := code_part_and_value_tab_(i).value;
         project_cost_element_tab_(i).currency_amount      := code_part_and_value_tab_(i).currency_value;
         project_cost_element_tab_(i).project_cost_element := 
                                              Cost_Element_To_Account_API.Get_Project_Follow_Up_Element(
                                                             code_part_and_value_tab_(i).company,
                                                             code_part_and_value_tab_(i).account_no,
                                                             code_part_and_value_tab_(i).codeno_b,
                                                             code_part_and_value_tab_(i).codeno_c,
                                                             code_part_and_value_tab_(i).codeno_d,
                                                             code_part_and_value_tab_(i).codeno_e,
                                                             code_part_and_value_tab_(i).codeno_f,
                                                             code_part_and_value_tab_(i).codeno_g,
                                                             code_part_and_value_tab_(i).codeno_h,
                                                             code_part_and_value_tab_(i).codeno_i,
                                                             code_part_and_value_tab_(i).codeno_j,
                                                             code_part_and_value_tab_(i).date_applied,
                                                             'FALSE');
      END LOOP;
      project_cost_element_tab_ := Get_Merged_Cost_Element_Tab___(project_cost_element_tab_);
   END IF;

   RETURN (project_cost_element_tab_);
END Get_Activity_Costs_By_Status;


FUNCTION Get_Project_Cost_Elements (
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
   value_detail_tab_             IN Value_Detail_Tab,
   location_type_                IN VARCHAR2,
   location_group_               IN VARCHAR2,
   sales_overhead_               IN BOOLEAN DEFAULT FALSE,
   condition_code_               IN VARCHAR2 DEFAULT NULL) RETURN Project_Cost_Element_Tab
IS
   cur_proj_cost_element_tab_   Project_Cost_Element_Tab;
   total_proj_cost_element_tab_ Project_Cost_Element_Tab;
   merged_value_detail_tab_     Value_Detail_Tab;
BEGIN

   merged_value_detail_tab_ := Get_Merged_Value_Detail_Tab___(value_detail_tab_);

   IF (merged_value_detail_tab_.COUNT > 0) THEN
      FOR i IN merged_value_detail_tab_.FIRST..merged_value_detail_tab_.LAST LOOP
         -- Stopped the project cost simulation when zero in merged_value_detail_tab_(i).value
         IF (merged_value_detail_tab_(i).value != 0) THEN
            cur_proj_cost_element_tab_ := Get_Project_Cost_Elements( 
                                                  part_no_,
                                                  contract_,
                                                  source_ref_type_db_,
                                                  source_ref1_,
                                                  source_ref2_,
                                                  source_ref3_,
                                                  source_ref4_,
                                                  supp_grp_,
                                                  stat_grp_,
                                                  assortment_,
                                                  merged_value_detail_tab_(i).value,                                                  
                                                  part_related_,
                                                  merged_value_detail_tab_(i).bucket_posting_group_id,
                                                  charge_type_,
                                                  charge_group_,
                                                  error_when_element_not_exist_,
                                                  include_charge_,
                                                  merged_value_detail_tab_(i).cost_source_id,
                                                  location_type_,
                                                  location_group_,
                                                  sales_overhead_,
                                                  condition_code_ => condition_code_);

             total_proj_cost_element_tab_ := Get_Merged_Cost_Element_Tab( total_proj_cost_element_tab_, 
                                                                          cur_proj_cost_element_tab_);
         END IF;
      END LOOP;
   END IF;

   RETURN total_proj_cost_element_tab_;
END Get_Project_Cost_Elements;


@UncheckedAccess
FUNCTION Project_Activity_Posting (
   accounting_id_ IN NUMBER ) RETURN BOOLEAN
IS
   dummy_                    NUMBER;
   project_activity_posting_ BOOLEAN := FALSE;

   CURSOR exist_control IS
      SELECT 1
        FROM MPCCOM_ACCOUNTING_TAB
       WHERE accounting_id = accounting_id_
         AND NVL(activity_seq,0) != 0;  
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      project_activity_posting_ := TRUE;
   END IF;
   CLOSE exist_control;

   RETURN(project_activity_posting_);
END Project_Activity_Posting;


@UncheckedAccess
FUNCTION Get_Merged_Cost_Element_Tab (
   project_cost_element_tab1_ IN Project_Cost_Element_Tab,
   project_cost_element_tab2_ IN Project_Cost_Element_Tab ) RETURN Project_Cost_Element_Tab
IS
   project_cost_element_tab_     Project_Cost_Element_Tab;
   index_                        PLS_INTEGER;
BEGIN
   index_ := ( NVL(project_cost_element_tab1_.LAST, 0) + 1);
   project_cost_element_tab_ := project_cost_element_tab1_;
   IF (project_cost_element_tab2_.COUNT > 0) THEN
      FOR i IN project_cost_element_tab2_.FIRST..project_cost_element_tab2_.LAST LOOP
         project_cost_element_tab_(index_).project_cost_element := project_cost_element_tab2_(i).project_cost_element;
         project_cost_element_tab_(index_).amount               := project_cost_element_tab2_(i).amount;
         project_cost_element_tab_(index_).hours                := project_cost_element_tab2_(i).hours;
         index_ := index_ + 1;
      END LOOP;
   END IF;   

   RETURN Get_Merged_Cost_Element_Tab___(project_cost_element_tab_);
END Get_Merged_Cost_Element_Tab;


-- All_Postings_Transferred_Acc
--   Check if all postings for the specified account and company
--   have been transferred to Finance.
--   Should be called from ACCOUNT_API when inert/update exclude_proj_followup.
--   The return value will be the string 'TRUE' if all postings have been
--   transferred, 'FALSE' if not.
@UncheckedAccess
FUNCTION All_Postings_Transferred_Acc (
   company_    IN VARCHAR2,
   account_no_ IN VARCHAR2) RETURN VARCHAR2
IS
   CURSOR get_company_sites IS
      SELECT contract
      FROM   SITE_PUBLIC
      WHERE  company = company_;

   CURSOR get_non_transferred(contract_ IN VARCHAR2) IS
      SELECT accounting_id
      FROM   MPCCOM_ACCOUNTING_TAB
      WHERE contract = contract_
      AND   status_code IN ('1', '2') --removed '99' to fix a bug-only check non-error postings
      AND   account_no = account_no_;

   accounting_id_        NUMBER;
   found_                BOOLEAN := FALSE;
   postings_transferred_ VARCHAR2(5) := 'TRUE';
BEGIN
   FOR next_site_ IN get_company_sites LOOP
      OPEN get_non_transferred(next_site_.contract);
      FETCH get_non_transferred INTO accounting_id_;
      IF (get_non_transferred%FOUND) THEN
         found_ := TRUE;
      END IF;
      CLOSE get_non_transferred;

      IF found_ THEN
         postings_transferred_ := 'FALSE';
         EXIT;
      END IF;
   END LOOP;

   RETURN postings_transferred_;
END All_Postings_Transferred_Acc;


PROCEDURE Check_Date_Applied (
   company_      IN VARCHAR2,
   date_applied_ IN DATE )
IS
   user_group_        VARCHAR2(30);
   open_              VARCHAR2(5);
   accounting_year_   NUMBER;
   accounting_period_ NUMBER;
   fnd_user_          VARCHAR2(30);
BEGIN
   
   fnd_user_   := Fnd_Session_API.Get_Fnd_User;
   user_group_ := User_Group_Member_Finance_API.Get_User_Group(company_, fnd_user_);
   
   IF (user_group_ IS NULL) THEN 
      Error_SYS.Record_General('MpccomAccounting', 'NOUSERGROUP: The user ID :P1 needs to be a member of a Finance User Group in company :P2.', fnd_user_, company_);  
   END IF;

   Accounting_Period_API.Get_Accounting_Year(accounting_year_,
                                             accounting_period_,
                                             company_,
                                             date_applied_,
                                             user_group_);

   User_Group_Period_API.Exist(company_, accounting_year_, accounting_period_, user_group_); 

   open_ := User_Group_Period_API.Is_Period_Open(company_,
                                                 accounting_year_,
                                                 accounting_period_,
                                                 user_group_);
   IF (open_ = 'FALSE') THEN
      Error_SYS.Record_General('MpccomAccounting','PERCLOSED: Financial period :P1 in company :P2 is closed for user group :P3.',accounting_period_||'-'||accounting_year_,company_,user_group_);
   END IF;
END Check_Date_Applied;


@UncheckedAccess
FUNCTION Has_Posting_In_Status (
   accounting_id_ IN NUMBER,
   status_        IN VARCHAR2 ) RETURN BOOLEAN
IS
   status_code_1_          MPCCOM_ACCOUNTING_TAB.status_code%TYPE;
   status_code_2_          MPCCOM_ACCOUNTING_TAB.status_code%TYPE;
   status_code_3_          MPCCOM_ACCOUNTING_TAB.status_code%TYPE;
   dummy_                  NUMBER;
   has_posting_in_status_ BOOLEAN := FALSE;

   CURSOR exist_control IS
      SELECT 1
      FROM   MPCCOM_ACCOUNTING_TAB
      WHERE accounting_id = accounting_id_
      AND   ((status_code  = status_code_1_) OR (status_code  = status_code_2_) OR (status_code  = status_code_3_));
BEGIN
   IF (status_ = 'CREATED') THEN
      status_code_1_ := '1';
      status_code_2_ := '1';
      status_code_3_ := '1';
   ELSIF (status_ = 'COMPLETED') THEN
      status_code_1_ := '2';
      status_code_2_ := '2';
      status_code_3_ := '2';
   ELSIF (status_ = 'TRANSFERRED') THEN
      status_code_1_ := '3';
      status_code_2_ := '3';
      status_code_3_ := '3';
   ELSIF (status_ = 'ERROR') THEN
      status_code_1_ := '99';
      status_code_2_ := '99';
      status_code_3_ := '99';
   ELSIF (status_ = 'NOT TRANSFERRED') THEN
      status_code_1_ := '1';
      status_code_2_ := '2';
      status_code_3_ := '99';
   END IF;

   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      has_posting_in_status_ := TRUE;
   END IF;
   CLOSE exist_control;

   RETURN(has_posting_in_status_);
END Has_Posting_In_Status;


@UncheckedAccess
FUNCTION Get_Sign_Shifted_Cost_Elements (
   project_cost_element_tab_ IN Project_Cost_Element_Tab ) RETURN Project_Cost_Element_Tab
IS
   local_proj_cost_element_tab_ Project_Cost_Element_Tab;
BEGIN
   IF (project_cost_element_tab_.COUNT > 0) THEN
      FOR i IN project_cost_element_tab_.FIRST..project_cost_element_tab_.LAST LOOP
         local_proj_cost_element_tab_(i)        := project_cost_element_tab_(i);
         local_proj_cost_element_tab_(i).amount := project_cost_element_tab_(i).amount * -1;
         local_proj_cost_element_tab_(i).hours  := project_cost_element_tab_(i).hours * -1;
      END LOOP;
   END IF;
   RETURN (local_proj_cost_element_tab_);
END Get_Sign_Shifted_Cost_Elements;


-- Activity_Postings_Transferred
--   Checks whether all postings for a particular activity seq/company has been transferred to finance.
@UncheckedAccess
FUNCTION Activity_Postings_Transferred (
   company_      IN VARCHAR2,
   activity_seq_ IN NUMBER ) RETURN VARCHAR2
IS
   all_postings_transferred_ VARCHAR2(5);
BEGIN
   IF (Is_Code_Part_Value_In_Status(company_,
                                    'ACTIVITY_SEQ',
                                    activity_seq_,
                                    'NOT TRANSFERRED')) THEN
      all_postings_transferred_ := 'FALSE';
   ELSE
      all_postings_transferred_ := 'TRUE';
   END IF;
   RETURN (all_postings_transferred_);
END Activity_Postings_Transferred;


-- Get_Merged_Value_Detail_Tab
--   Accepts 2 PL/SQL collections of type Value_Detail_Tab and returns the merged
--   set of Value Details grouped by bucket_posting_group_id and cost_source_id.
@UncheckedAccess
FUNCTION Get_Merged_Value_Detail_Tab (
   value_detail_tab1_ IN Value_Detail_Tab,
   value_detail_tab2_ IN Value_Detail_Tab ) RETURN Value_Detail_Tab
IS
   value_detail_tab_ Value_Detail_Tab;
   index_            PLS_INTEGER;
BEGIN
   index_            := (NVL(value_detail_tab1_.LAST, 0) + 1);
   value_detail_tab_ := value_detail_tab1_;
   IF (value_detail_tab2_.COUNT > 0) THEN
      FOR i IN value_detail_tab2_.FIRST..value_detail_tab2_.LAST LOOP
         value_detail_tab_(index_).bucket_posting_group_id := value_detail_tab2_(i).bucket_posting_group_id;
         value_detail_tab_(index_).cost_source_id          := value_detail_tab2_(i).cost_source_id;
         value_detail_tab_(index_).value                   := value_detail_tab2_(i).value;
         index_ := index_ + 1;
      END LOOP;
   END IF;

   RETURN Get_Merged_Value_Detail_Tab___(value_detail_tab_);
END Get_Merged_Value_Detail_Tab;


-- Get_Total_Value
--   Returns the total value of a given Value_Detail_Tab
@UncheckedAccess
FUNCTION Get_Total_Value (
   value_detail_tab_ IN Value_Detail_Tab) RETURN NUMBER
IS
   total_value_ NUMBER := 0;
BEGIN
   IF (value_detail_tab_.COUNT > 0) THEN
      FOR i IN value_detail_tab_.FIRST..value_detail_tab_.LAST LOOP
         total_value_ := total_value_ + value_detail_tab_(i).value;
      END LOOP;
   END IF;

   RETURN total_value_;
END Get_Total_Value;


@UncheckedAccess
PROCEDURE Get_Trans_Currency_Info(
   currency_rate_     OUT NUMBER,
   currency_code_     OUT VARCHAR2,
   conversion_factor_ OUT NUMBER,
   accounting_id_     IN  NUMBER,
   posting_type_      IN  VARCHAR2 )
IS
   CURSOR get_curr_details IS
      SELECT currency_rate, currency_code, NVL(conversion_factor, currency_rate) conversion_factor   
      FROM MPCCOM_ACCOUNTING_TAB
      WHERE accounting_id = accounting_id_ 
      AND str_code = posting_type_;
      
BEGIN
   OPEN get_curr_details;
   FETCH get_curr_details INTO currency_rate_, currency_code_, conversion_factor_;   
   CLOSE get_curr_details;

END Get_Trans_Currency_Info;

@UncheckedAccess
FUNCTION Get_Currency_Code_From_Latest (
   accounting_id_     IN  NUMBER,
   event_code_        IN  VARCHAR2,
   posting_type_      IN  VARCHAR2 ) RETURN VARCHAR2
IS
   currency_code_    MPCCOM_ACCOUNTING_TAB.currency_code%TYPE;
   
   CURSOR get_latest_trans_curr_code IS
      SELECT currency_code   
      FROM MPCCOM_ACCOUNTING_TAB
      WHERE accounting_id = accounting_id_
      AND   event_code = event_code_
      AND   str_code = posting_type_
      ORDER BY Seq DESC;
      
BEGIN
   OPEN get_latest_trans_curr_code;
   FETCH get_latest_trans_curr_code INTO currency_code_;
   CLOSE get_latest_trans_curr_code;
   
   RETURN currency_code_;
   
END Get_Currency_Code_From_Latest;


-- Get_Merged_Curr_Amount_Tab
--   Accepts 2 PL/SQL collections of type Curr_Amount_Detail_Tab and returns the merged
--   set of Curr Amount Details grouped by currency code, currency rate, conversion factor and inverted currency rate.
@UncheckedAccess
FUNCTION Get_Merged_Curr_Amount_Tab (
   curr_amount_detail_tab1_ IN Curr_Amount_Detail_Tab,
   curr_amount_detail_tab2_ IN Curr_Amount_Detail_Tab ) RETURN Curr_Amount_Detail_Tab
IS
   curr_amount_detail_tab_ Curr_Amount_Detail_Tab;
   index_                  PLS_INTEGER;
BEGIN
   index_                  := (NVL(curr_amount_detail_tab1_.LAST, 0) + 1);
   curr_amount_detail_tab_ := curr_amount_detail_tab1_;
   
   IF (curr_amount_detail_tab2_.COUNT > 0) THEN
      FOR i IN curr_amount_detail_tab2_.FIRST..curr_amount_detail_tab2_.LAST LOOP
         curr_amount_detail_tab_(index_) := curr_amount_detail_tab2_(i);
         index_ := index_ + 1;
      END LOOP;
   END IF;

   RETURN Get_Merged_Curr_Amount_Tab___(curr_amount_detail_tab_);
END Get_Merged_Curr_Amount_Tab;

-- Get_Curr_Amount_Details
--   Returns the nett sum of the curr amount for each currency code, currency rate, conversion factor and inverted currency rate combination.
--   The currency information of the latest posting will always be at the end in the collection.
@UncheckedAccess
FUNCTION Get_Curr_Amount_Details (      
   accounting_id_       IN  NUMBER,   
   str_code_            IN  VARCHAR2,
   to_date_             IN  DATE DEFAULT NULL ) RETURN Curr_Amount_Detail_Tab
IS
   find_latest_                        VARCHAR2(5);
   latest_currency_code_               mpccom_accounting_tab.currency_code%TYPE;
   latest_currency_rate_               mpccom_accounting_tab.currency_rate%TYPE;
   latest_conversion_factor_           mpccom_accounting_tab.conversion_factor%TYPE;
   latest_inverted_currency_rate_      mpccom_accounting_tab.inverted_currency_rate%TYPE;
   other_curr_amount_detail_tab_       Curr_Amount_Detail_Tab;
   latest_curr_amount_detail_tab_      Curr_Amount_Detail_Tab;
   full_curr_amount_detail_tab_        Curr_Amount_Detail_Tab;
   false_                              CONSTANT    VARCHAR2(5):= Fnd_Boolean_API.DB_FALSE;
   true_                               CONSTANT    VARCHAR2(4):= Fnd_Boolean_API.DB_TRUE;
   
   CURSOR get_curr_amount_details IS
      SELECT currency_code, currency_rate, NVL(conversion_factor,1) conversion_factor, NVL(inverted_currency_rate, false_) inverted_currency_rate, 
             SUM(curr_amount * (DECODE(debit_credit, 'C', -1, 1))) curr_amount, SUM(value * (DECODE(debit_credit, 'C', -1, 1))) value
      FROM   MPCCOM_ACCOUNTING_TAB
      WHERE  accounting_id = accounting_id_      
      AND    str_code = str_code_
      AND    (date_applied <= to_date_ OR to_date_ IS NULL)
      AND    (((currency_code != latest_currency_code_ OR
                currency_rate != latest_currency_rate_ OR
                NVL(conversion_factor,1)            != latest_conversion_factor_ OR 
                NVL(inverted_currency_rate, false_) != latest_inverted_currency_rate_) AND
               find_latest_ = false_)
              OR
              (currency_code = latest_currency_code_ AND
               currency_rate = latest_currency_rate_ AND
               NVL(conversion_factor,1)            = latest_conversion_factor_      AND 
               NVL(inverted_currency_rate, false_) = latest_inverted_currency_rate_ AND
               find_latest_ = true_))
      GROUP BY currency_code, currency_rate, NVL(conversion_factor,1), NVL(inverted_currency_rate, false_);      

   CURSOR get_latest_acc_details IS
      SELECT currency_code, currency_rate, NVL(conversion_factor,1) conversion_factor, NVL(inverted_currency_rate, false_) inverted_currency_rate             
      FROM   MPCCOM_ACCOUNTING_TAB
      WHERE  accounting_id = accounting_id_      
      AND    str_code = str_code_
      AND    (date_applied <= to_date_ OR to_date_ IS NULL)
      AND    seq IN (SELECT MAX(seq)
                     FROM   MPCCOM_ACCOUNTING_TAB
                     WHERE  accounting_id = accounting_id_      
                     AND    str_code = str_code_
                     AND    (date_applied <= to_date_ OR to_date_ IS NULL)); 
      
BEGIN   
   OPEN get_latest_acc_details;
   FETCH get_latest_acc_details INTO latest_currency_code_, latest_currency_rate_, latest_conversion_factor_, latest_inverted_currency_rate_;   
   CLOSE get_latest_acc_details;
   
   -- Firstly we find the non-latest curr details
   find_latest_ := false_;
   OPEN get_curr_amount_details;
   FETCH get_curr_amount_details BULK COLLECT INTO other_curr_amount_detail_tab_;
   CLOSE get_curr_amount_details;
   
   -- Secondly we find the latest curr details. This only returns one record 
   find_latest_ := true_;   
   OPEN get_curr_amount_details;
   FETCH get_curr_amount_details BULK COLLECT INTO latest_curr_amount_detail_tab_;
   CLOSE get_curr_amount_details;
   
   -- if there are non-latest curr information then we can safely assume we have latest curr information
   IF (other_curr_amount_detail_tab_.COUNT > 0) THEN
      full_curr_amount_detail_tab_ := other_curr_amount_detail_tab_;
      full_curr_amount_detail_tab_(full_curr_amount_detail_tab_.LAST + 1) := latest_curr_amount_detail_tab_(1);
   ELSE
      -- Checks whether we have one group of latest curr information atleast
      IF (latest_curr_amount_detail_tab_.COUNT = 1 ) THEN
         full_curr_amount_detail_tab_(1) := latest_curr_amount_detail_tab_(1);
      END IF;   
   END IF;   
  
   RETURN full_curr_amount_detail_tab_;   
END Get_Curr_Amount_Details;

@UncheckedAccess
FUNCTION Get_Total_Curr_Amount (
   curr_amount_detail_tab_ IN Curr_Amount_Detail_Tab,
   currency_code_          IN VARCHAR2 ) RETURN NUMBER
IS
   total_curr_amount_ NUMBER := 0;
BEGIN
   IF (curr_amount_detail_tab_.COUNT > 0) THEN
      FOR i IN curr_amount_detail_tab_.FIRST..curr_amount_detail_tab_.LAST LOOP
         IF (curr_amount_detail_tab_(i).currency_code = currency_code_) THEN
            total_curr_amount_ := total_curr_amount_ + curr_amount_detail_tab_(i).curr_amount;
         END IF;   
      END LOOP;
   END IF;

   RETURN total_curr_amount_;
END Get_Total_Curr_Amount;

PROCEDURE Get_Control_Type_Values(
   control_type_value_table_  OUT   Posting_Ctrl_Public_API.control_type_value_table,
   control_type_key_rec_      IN    Mpccom_Accounting_API.Control_Type_Key,
   company_                   IN    VARCHAR2,
   str_code_                  IN    VARCHAR2,
   accounting_date_           IN    DATE )  
IS   
BEGIN
   Get_Control_Type_Values___(control_type_value_table_,
                              str_code_,
                              company_,
                              accounting_date_,
                              control_type_key_rec_,
                              cost_source_id_            => NULL,
                              bucket_posting_group_id_   => NULL,
                              supp_grp_                  => NULL,
                              stat_grp_                  => NULL,
                              location_type_             => NULL,
                              charge_type_               => NULL,
                              charge_group_              => NULL,
                              assortment_                => NULL,
                              location_group_            => NULL,
                              condition_code_            => NULL);
END Get_Control_Type_Values; 

@UncheckedAccess
PROCEDURE Get_Sum_Amounts_Posted (
   sum_amount_in_base_         OUT NUMBER,
   sum_amount_in_curr_         OUT NUMBER,
   accounting_id_              IN  NUMBER, 
   str_code_                   IN  VARCHAR2,
   currency_code_              IN  VARCHAR2,
   to_date_                    IN  DATE,
   skip_trans_reval_postings_  IN  VARCHAR2 )
IS
   sum_base_amount_  NUMBER;
   sum_curr_amount_  NUMBER;
   
   CURSOR get_sum_posted IS
      SELECT SUM(value * (DECODE(debit_credit, 'C', -1, 1))),
             SUM(DECODE(NVL(currency_code_, currency_code), currency_code, curr_amount, 0) * (DECODE(debit_credit, 'C', -1, 1)))
      FROM   MPCCOM_ACCOUNTING_TAB
      WHERE  accounting_id = accounting_id_
      AND    str_code = str_code_
      AND   (date_applied <= to_date_ OR to_date_ IS NULL)
      AND   ((trans_reval_event_id IS NULL AND skip_trans_reval_postings_ = Fnd_Boolean_API.DB_TRUE) OR
             (skip_trans_reval_postings_ = Fnd_Boolean_API.DB_FALSE));

BEGIN
   OPEN get_sum_posted;
   FETCH get_sum_posted INTO sum_base_amount_, sum_curr_amount_;
   CLOSE get_sum_posted;
  
   sum_amount_in_base_ := NVL(sum_base_amount_, 0);
   sum_amount_in_curr_ := NVL(sum_curr_amount_, 0);
 
END Get_Sum_Amounts_Posted;

-- This method is used to post balance postings in inventory in curr amounts when transaction based parts are involved.
-- When the invoice is done in different currency or even in the same currency but at invoicing the currency rate is changed
-- then there would be some balance amount to be posted in transaction currency which is handled by this method.
-- This is used for both part and charge postings.
PROCEDURE Do_Curr_Amt_Balance_Posting (
   company_                    IN VARCHAR2,
   accounting_id_              IN NUMBER,
   contract_                   IN VARCHAR2,
   quantity_arrived_           IN NUMBER,
   trans_reval_event_id_       IN NUMBER,
   receipt_curr_code_          IN VARCHAR2,
   invoice_curr_code_          IN VARCHAR2,
   avg_inv_price_in_inv_curr_  IN NUMBER,
   avg_chg_value_in_inv_curr_  IN NUMBER,
   unit_cost_in_receipt_curr_  IN NUMBER,
   date_posted_                IN DATE, 
   control_type_key_rec_       IN Control_Type_Key DEFAULT NULL)
IS
   prev_posted_rec_            MPCCOM_ACCOUNTING_TAB%ROWTYPE;
   avg_value_in_inv_curr_      NUMBER;
   booking_id_                 NUMBER;
   debit_credit_db_            VARCHAR2(1);
   negative_when_credit_       NUMBER;
   company_fin_rec_            Company_Finance_API.Public_Rec;
   currency_rounding_          NUMBER;
   sum_base_amount_posted_     NUMBER;
   sum_curr_amount_posted_     NUMBER;
   currency_amount_            MPCCOM_ACCOUNTING_TAB.curr_amount%TYPE;
   from_old_posting_           BOOLEAN;
   new_postings_created_       BOOLEAN := FALSE;
   exit_procedure              EXCEPTION;
   charge_posting_             BOOLEAN := FALSE;
   str_code_                   MPCCOM_ACCOUNTING_TAB.str_code%TYPE;
   event_code_                 MPCCOM_ACCOUNTING_TAB.event_code%TYPE;

   CURSOR get_previous_posting IS
      SELECT  *
      FROM mpccom_accounting_tab
      WHERE accounting_id = accounting_id_
      AND ((str_code = 'M189' AND avg_chg_value_in_inv_curr_ IS NOT NULL) OR (str_code IN ('M10', 'M14') AND avg_chg_value_in_inv_curr_ IS NULL))
      AND  event_code NOT IN ('RETREVAL+', 'RETREVAL-')
      ORDER BY seq DESC;
BEGIN
   -- No need to consider all records. The record with heighest seq is enough to get the previous posted values.
   OPEN get_previous_posting;
   FETCH get_previous_posting INTO prev_posted_rec_;
   IF (get_previous_posting%NOTFOUND) THEN
      CLOSE get_previous_posting;
      RAISE exit_procedure;
   END IF;   
   CLOSE get_previous_posting;
  
   -- event_code and str_code can not be taken from prev_posted_rec_ always. eg. When a charge line connected part is received,
   -- postings are created for both ARRCHG and ARRIVAL in one transaction. If the part is transaction based, when invoicing the
   -- charge without part, the prev_posted_rec_ may contains the detail of part arrival. hence the currency balance postings
   -- are created with event_code_ and str_code ARRIVAL and M10 respectively. Hence avg_chg_value_in_inv_curr_ and avg_inv_price_in_inv_curr_
   -- are used to identify whether it is a charge posting or part posting.
   IF (avg_chg_value_in_inv_curr_ IS NOT NULL) THEN
      str_code_ := 'M189';
      event_code_ := 'ARRCHG';
      avg_value_in_inv_curr_ := avg_chg_value_in_inv_curr_;
      booking_id_ := 1;
      charge_posting_ := TRUE;
   ELSE
      str_code_ := prev_posted_rec_.str_code;
      avg_value_in_inv_curr_ := avg_inv_price_in_inv_curr_;      
      booking_id_ := 1;
      event_code_ := prev_posted_rec_.event_code;
   END IF;
   
   debit_credit_db_ := Acc_Event_Posting_Type_API.Get_Debit_Credit_Db(event_code_, str_code_, booking_id_); 
   negative_when_credit_ := CASE debit_credit_db_ WHEN 'C' THEN -1 ELSE 1 END;
  
   company_fin_rec_ := Company_Finance_API.Get(company_);
   IF (receipt_curr_code_ != invoice_curr_code_) THEN
      -- when 3 currencies are involved or previous posted currency is different to current invoice currency, need to reverse the sum amount posted in previous currency
      IF (str_code_ = 'M189') THEN
         -- when reversing charge posting we can not get the posted value at receipt for M189 as it contains the sum of charges.
         -- Hence the receipt cost is taken from purchase_receipt_chargeTab and it is is passed as a parameter.
         currency_amount_ := unit_cost_in_receipt_curr_ * -1;
      ELSE
         currency_amount_ := unit_cost_in_receipt_curr_ * quantity_arrived_ * -1;
      END IF;
   
      IF (currency_amount_ < 0) THEN
         IF (company_fin_rec_.correction_type = 'REVERSE') THEN
            currency_amount_ := ABS(currency_amount_);
            IF (debit_credit_db_ = 'C') THEN
               debit_credit_db_ := 'D';
            ELSE
               debit_credit_db_ := 'C';
            END IF;
         END IF;
      END IF;
      IF (currency_amount_ != 0) THEN
         IF ((prev_posted_rec_.trans_reval_event_id IS NULL) OR trans_reval_event_id_ != prev_posted_rec_.trans_reval_event_id) THEN
            from_old_posting_ := TRUE;
         ELSE
            from_old_posting_ := FALSE;
         END IF;
         Do_Curr_Amount_Posting___(new_postings_created_  => new_postings_created_,
                                   accounting_id_         => accounting_id_,
                                   prev_posted_rec_       => prev_posted_rec_,
                                   company_               => company_,
                                   trans_reval_event_id_  => NVL(trans_reval_event_id_, prev_posted_rec_.trans_reval_event_id),
                                   event_code_            => event_code_,
                                   str_code_              => str_code_,
                                   debit_credit_db_       => debit_credit_db_,
                                   currency_amount_       => currency_amount_,
                                   currency_code_         => receipt_curr_code_,
                                   contract_              => contract_,
                                   date_posted_           => date_posted_,
                                   from_old_posting_      => from_old_posting_,
                                   generate_code_string_  => FALSE,
                                   control_type_key_rec_  => control_type_key_rec_);
      END IF;
   END IF;
   -- Even if the invoicing is done in same currency as arrival, due to the charge in currency rate, the normal postings do not balance the amount in transaction currency.
   -- hence with cascade postings, the curr_amount is set as zero (when the arrival is not done in base currency) and the corresponding balance currency amount is posted now.
   -- If the arrival is in base currency but the invoicing is in differnt currency, some part of the currency amount is posted in normal bookings,
   -- but the remaining amount is also posted in the part.
   IF ((invoice_curr_code_ IS NOT NULL AND avg_value_in_inv_curr_ IS NOT NULL) AND (invoice_curr_code_ != company_fin_rec_.currency_code)) THEN
      debit_credit_db_ := Acc_Event_Posting_Type_API.Get_Debit_Credit_Db(event_code_, str_code_, booking_id_); 
      negative_when_credit_ := CASE debit_credit_db_ WHEN 'C' THEN -1 ELSE 1 END;
      currency_rounding_ := Currency_Code_API.Get_Currency_Rounding(company_, invoice_curr_code_);                                                                                     
      IF (charge_posting_) THEN                                                                                   
         currency_amount_ := ROUND(avg_value_in_inv_curr_, currency_rounding_);
      ELSE
         -- need to post the balance curr amount after substracting sum_curr_amount_posted_.
         Get_Sum_Amounts_Posted(sum_base_amount_posted_,
                                sum_curr_amount_posted_,
                                accounting_id_, 
                                str_code_,
                                invoice_curr_code_,
                                date_posted_,
                                'FALSE');
         
         currency_amount_ := ROUND((avg_value_in_inv_curr_ * quantity_arrived_ * negative_when_credit_), currency_rounding_) - NVL(sum_curr_amount_posted_, 0);         
         currency_amount_ := currency_amount_ * negative_when_credit_;
      END IF;
      
      IF (currency_amount_ < 0) THEN
         IF (company_fin_rec_.correction_type = 'REVERSE') THEN
            currency_amount_ := ABS(currency_amount_);
            IF (debit_credit_db_ = 'C') THEN
               debit_credit_db_ := 'D';
            ELSE
               debit_credit_db_ := 'C';
            END IF;
         END IF;
      END IF;
      IF (currency_amount_ != 0) THEN
         IF (new_postings_created_) THEN
            -- need to fetch previous posted rec as it is now been created in above.
            OPEN get_previous_posting;
            FETCH get_previous_posting INTO prev_posted_rec_;
            CLOSE get_previous_posting;
         END IF;
         IF ((prev_posted_rec_.trans_reval_event_id IS NULL) OR trans_reval_event_id_ != prev_posted_rec_.trans_reval_event_id) THEN
            from_old_posting_ := TRUE;
         ELSE   
            from_old_posting_ := FALSE;
         END IF;
         new_postings_created_ := FALSE;
         Do_Curr_Amount_Posting___(new_postings_created_  => new_postings_created_,
                                   accounting_id_         => accounting_id_,
                                   prev_posted_rec_       => prev_posted_rec_,
                                   company_               => company_,
                                   trans_reval_event_id_  => NVL(trans_reval_event_id_, prev_posted_rec_.trans_reval_event_id),
                                   event_code_            => event_code_,
                                   str_code_              => str_code_,
                                   debit_credit_db_       => debit_credit_db_,
                                   currency_amount_       => currency_amount_,
                                   currency_code_         => invoice_curr_code_,
                                   contract_              => contract_,
                                   date_posted_           => date_posted_,
                                   from_old_posting_      => from_old_posting_,
                                   generate_code_string_  => FALSE,
                                   control_type_key_rec_  => control_type_key_rec_);
      END IF;
   END IF;
   EXCEPTION
      WHEN exit_procedure THEN
         NULL;
END Do_Curr_Amt_Balance_Posting;   

PROCEDURE Do_Curr_Amt_Diff_Posting (
   company_                    IN VARCHAR2,
   accounting_id_              IN NUMBER,
   contract_                   IN VARCHAR2,
   quantity_arrived_           IN NUMBER,
   trans_reval_event_id_       IN NUMBER,
   unit_cost_in_receipt_curr_  IN NUMBER,
   receipt_curr_code_          IN VARCHAR2,
   invoice_curr_code_          IN VARCHAR2,
   price_diff_per_unit_curr_   IN NUMBER,
   event_code_                 IN VARCHAR2 )
   
IS
   prev_posted_rec_            MPCCOM_ACCOUNTING_TAB%ROWTYPE;
   date_posted_                DATE;
   debit_credit_db_            VARCHAR2(1);
   inv_currency_rounding_      NUMBER;
   receipt_currency_rounding_  NUMBER;
   str_code_                   MPCCOM_ACCOUNTING_TAB.str_code%TYPE;
   currency_amount_            NUMBER;
   new_postings_created_       BOOLEAN := FALSE;
   reverse_event_code_         MPCCOM_ACCOUNTING_TAB.event_code%TYPE;
   from_old_posting_           BOOLEAN;
   generate_code_string_       BOOLEAN := FALSE;
   arrival_event_code_         MPCCOM_ACCOUNTING_TAB.event_code%TYPE;
   
   CURSOR get_previous_posting IS
      SELECT  *
      FROM mpccom_accounting_tab
      WHERE accounting_id = accounting_id_
      AND  str_code IN ('M10', 'M189')
      ORDER BY seq DESC;
      
   exit_procedure    EXCEPTION;    
BEGIN
   -- If all three currencies, i.e. receipt currecy, base currency and invoice currency is the same, then there is
   -- no need to execute this method.
   IF (receipt_curr_code_ = invoice_curr_code_) AND (invoice_curr_code_ = Company_Finance_API.Get_Currency_Code(company_)) THEN
      RAISE exit_procedure;      
   END IF;    
   OPEN get_previous_posting;
   FETCH get_previous_posting INTO prev_posted_rec_;
   IF (get_previous_posting%NOTFOUND) THEN
      generate_code_string_ := TRUE;
   END IF;
   CLOSE get_previous_posting;
   
   date_posted_ := Site_API.Get_Site_Date(contract_);
   
   IF (generate_code_string_ OR prev_posted_rec_.trans_reval_event_id IS NULL) THEN
      IF (event_code_ IN ('CHGPRDIFF+', 'CHGPRDIFF-')) THEN
         str_code_ := 'M189';
      ELSE
         str_code_ := 'M10';
      END IF;
   ELSE
      str_code_ := prev_posted_rec_.str_code;
   END IF;
   
   debit_credit_db_ := Acc_Event_Posting_Type_API.Get_Debit_Credit_Db(event_code_, str_code_, 1); 
   inv_currency_rounding_ := Currency_Code_API.Get_Currency_Rounding(company_, invoice_curr_code_);                                                                                     
   currency_amount_ := ROUND((price_diff_per_unit_curr_ * quantity_arrived_), inv_currency_rounding_);
   IF (currency_amount_ != 0) THEN
      IF (prev_posted_rec_.trans_reval_event_id IS NULL) THEN
         from_old_posting_ := TRUE;
      ELSE   
         from_old_posting_ := FALSE;
      END IF;
      Do_Curr_Amount_Posting___(new_postings_created_,
                                accounting_id_,
                                prev_posted_rec_,
                                company_,
                                NVL(trans_reval_event_id_, prev_posted_rec_.trans_reval_event_id),
                                event_code_,
                                str_code_,
                                debit_credit_db_,
                                currency_amount_,
                                invoice_curr_code_,
                                contract_,
                                date_posted_,
                                from_old_posting_,
                                generate_code_string_,
                                NULL);
   END IF;   
   IF (invoice_curr_code_ != receipt_curr_code_) THEN
      IF (event_code_ LIKE 'PRICEDIFF%') THEN
         arrival_event_code_ := 'PRICEDIFF+';
      ELSIF (event_code_ LIKE 'CHGPRDIFF%') THEN
         arrival_event_code_ := 'CHGPRDIFF+';
      ELSIF (event_code_ LIKE 'BALINVOIC%') THEN
         arrival_event_code_ := 'BALINVOIC+';
      END IF;
      -- need to reverse the currency amount posted in receipt currency
      receipt_currency_rounding_ := Currency_Code_API.Get_Currency_Rounding(company_, receipt_curr_code_); 
      currency_amount_ := ROUND((unit_cost_in_receipt_curr_ * quantity_arrived_ * -1), receipt_currency_rounding_);
      -- Note: * -1 because we want to reverse the previous transaction done in receipt curr
      IF (currency_amount_ != 0) THEN
         IF (currency_amount_ < 0) THEN
            IF (arrival_event_code_ = 'PRICEDIFF+') THEN
               reverse_event_code_ := 'PRICEDIFF-';
            ELSIF (arrival_event_code_ = 'CHGPRDIFF+') THEN
               reverse_event_code_ := 'CHGPRDIFF-';
            ELSIF (arrival_event_code_ = 'BALINVOIC+') THEN
               reverse_event_code_ := 'BALINVOIC-';
            END IF;
            currency_amount_ := currency_amount_ * -1;
         ELSE
            reverse_event_code_ := arrival_event_code_;
         END IF;
        
         debit_credit_db_ := Acc_Event_Posting_Type_API.Get_Debit_Credit_Db(reverse_event_code_, str_code_, 1);
         IF (new_postings_created_) THEN
            -- need to fetch previous posted rec as it is now been created above.
            OPEN get_previous_posting;
            FETCH get_previous_posting INTO prev_posted_rec_;
            CLOSE get_previous_posting;
         END IF;
         IF (prev_posted_rec_.trans_reval_event_id IS NULL) THEN
            from_old_posting_ := TRUE;
         ELSE   
            from_old_posting_ := FALSE;
         END IF;
         new_postings_created_ := FALSE;
         Do_Curr_Amount_Posting___(new_postings_created_,
                                   accounting_id_,
                                   prev_posted_rec_,
                                   company_,
                                   NVL(trans_reval_event_id_, prev_posted_rec_.trans_reval_event_id),
                                   reverse_event_code_,
                                   str_code_,
                                   debit_credit_db_,
                                   currency_amount_,
                                   receipt_curr_code_,
                                   contract_,
                                   date_posted_,
                                   from_old_posting_,
                                   generate_code_string_,
                                   NULL);
      END IF;   
   END IF;
EXCEPTION 
   WHEN exit_procedure THEN
      NULL;
END Do_Curr_Amt_Diff_Posting;


@UncheckedAccess
PROCEDURE Get_Currency_Info (
   currency_rate_       OUT NUMBER,
   currency_code_       OUT VARCHAR2,
   conversion_factor_   OUT NUMBER,   
   accounting_id_tab_   IN  Accounting_Id_Tab,
   str_code_            IN VARCHAR2)
IS
   value_             NUMBER;
   curr_amount_       NUMBER;

   CURSOR get_currency_info IS
      SELECT currency_code, NVL(conversion_factor, currency_rate), SUM(curr_amount * currency_rate), SUM(curr_amount)
      FROM mpccom_accounting_tab
      WHERE accounting_id IN (SELECT * FROM TABLE (accounting_id_tab_))
      AND str_code = str_code_
      GROUP BY currency_code, NVL(conversion_factor, currency_rate);
BEGIN
   IF (accounting_id_tab_.COUNT > 0) THEN
      OPEN get_currency_info;
      FETCH get_currency_info INTO currency_code_, conversion_factor_, value_, curr_amount_;
      IF get_currency_info%FOUND THEN
         IF (curr_amount_ IS NOT NULL) AND (curr_amount_ != 0) THEN
            currency_rate_ := NVL(value_, 0) / curr_amount_;
         END IF;         
      END IF;   
      CLOSE get_currency_info;   
   END IF;
   currency_rate_ := NVL(currency_rate_,0);
END Get_Currency_Info;
