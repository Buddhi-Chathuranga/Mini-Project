-----------------------------------------------------------------------------
--
--  Logical unit: TransactionRevaluation
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  211101  ChJalk  SC21R2-5478, Reverted the modifications done under SCZ-15524.
--  210913  Asawlk  SC21R2-1895, Renamed parameter price_diff_per_unit_curr_ to unit_cost_invoice_curr_ in methods Revalue_Direct_Delivery___(), Make_Price_Diff_Transaction___()
--  210913          and Revalue_Trans_From_PO_Receipt(). Also renamed variable transaction_curr_amount_ to trans_amount_invoice_curr_ in Make_Price_Diff_Transaction___().
--  210714  ChJalk  SCZ-15524, Modified Revalue_Supplier_Shipment___ to get the transaction_id tab instead of a single transaction_id.
--  210702  LEPESE  SC21R2-794, Correction in Process_Intersite_Transfers___ and Process_Part_Changes___ on NULL handling of viable_posting_date_contract_.
--  210527  LEPESE  SC21R2-794, Added functionality to control which date that will be applied when creating additional postings on existing transactions.
--  210527          Added calls to Site_Invent_Info_API.Get_First_Viable_Posting_Date in methods Start_Revalue_Serial_Trans___, Revalue_Serial_Transactions___,
--  210527          Process_Intersite_Transfers___, Process_Part_Changes___, Revalue_Trans_From_SO_Receipt, Revalue_Trans_From_PO_Receipt, Revalue_Trans_From_SO_Scrap_Op.
--  210527          Numerous changes in many methods parameter lists and implementations to pass correct date to the place where new postings are created.
--  200324  SBalLK  Bug 152848 (SCZ-9452), Resolving automatic testing reported issues.
--  200102  AsZelk  SCSPRING20-1398, Added Cancel_Intersit_Shipod_Rcpt___() and used in Revalue_Cancel_Transaction___().
--  191226  Asawlk  Bug 151032(SCZ-7882), Modified Revalue_This_Receipt___() by passing parameter control_type_key_rec_ when calling Mpccom_Accounting_API.Do_Curr_Amt_Balance_Posting().
--  190913  Asawlk  Bug 147557(SCZ-4325), Modified Handle_Prosch_Wip_Variance___ to call Production_Receipt_API.Get_Receipt_Info() which handles production receipts that were moved to history.
--  181017  Cpeilk  Bug 143569, Reversed the previous correction of passing parameter invoice_cancelled_ and handled it differently in mpccom module.
--  180926  Cpeilk  Bug 143569, Passed parameter invoice_cancelled_ to be used when calculating reverse postings in Mpccom_Accounting_API.Do_Curr_Amt_Balance_Posting.
--  180716  Cpeilk  Bug 140847, Modified Make_Bal_Invoic_Transaction___ to move part of the code and create a public method in Inventory_Transaction_Hist_API.
--  180716          Removed Make_Diff_Transaction___ and added in Inventory_Transaction_Hist_API as public method. Removed method Get_PO_Configuration_Id___.
--  180514  Asawlk  Bug 140674, Modified Revalue_Trans_From_SO_Receipt by changing a condition and restructuring the code in a way that out param revaluation_is_impossible_
--  180514          from Revalue_Part_Transactions___ and Revalue_All_Serial_Trans___ is properly considered when rollback is performed.
--  170925  TiRalk  STRSC-12290, Renamed method Undo_Return_Rework_Transit___ to Undo_Move_To_Order_Transit___.
--  170620  ChFolk  STRSC-9028, Modified Revalue_Serial_Transaction___ to filter calling Do_Curr_Amt_Balance_Posting when currency diff postings are required only.
--  170601  ChFolk  STRSC-8418, Removed varibale receipt_cost_in_inv_curr_ in Revalue_Trans_From_PO_Receipt. Renamed variable receipt_cost_in_inv_curr_ as avg_inv_price_in_inv_curr_ in Make_Bal_Invoic_Transaction___.
--  170531  ChFolk  STRSC-8512, Renamed variable receipt_charge_cost_in_curr_ with unit_cost_in_receipt_curr_ as it is common for both part and charges. When third currency senario is handling,
--  170531          the reversal value for arrival currency is stored in unit_cost_in_receipt_curr_ and it is introduced in all methods which are posting balance postings in curr amount.
--  170529  ChFolk  STRSC-8610, Added new parameter receipt_curr_code_ to Revalue_Part_Transactions___, Revalue_All_Serial_Trans___, Start_Revalue_Serial_Trans___, Revalue_Serial_Transactions___,
--  170529          Revalue_Serial_Transaction___, Revalue_This_Receipt___, Revalue_Direct_Delivery___, Revalue_Direct_Return___ and Revalue_Return_To_Supplier___ to be used in Mpccom_Accounting_API.Do_Curr_Amt_Balance_Posting.
--  170526  ChFolk  STRSC-8004, Modified Revalue_Direct_Delivery___ to allow updating all return transaction with new cost differnce instead of the first transaction.
--  170525  ChFolk  STRSC-8610, Added new parameter receipt_charge_cost_in_curr_ into Revalue_All_Serial_Trans___, Revalue_Serial_Transaction___, Revalue_Serial_Transactions___ and Start_Revalue_Serial_Trans___
--  170525          which is used to post charge cost in receipt currency which can not be taken from mpccom_accounting_tab. Hence it is taken from purch and passing as a parameter.] 
--  170524  ChFolk  STRSC-8610, Added new parameter receipt_charge_cost_in_curr_ to Revalue_Part_Transactions___ and Revalue_This_Receipt___ which contains the
--  170524          charge receipt value to be posted in receipt currency. Removed some unused paramters in Revalue_This_Receipt___.
--  170517  ChFolk  STRSC-8565, Modified Make_Bal_Invoic_Transaction___ and Revalue_Trans_From_PO_Receipt by adding new parameter purch_receipt_cost_in_curr_ and receipt_unit_cost_in_curr_ respectively. Re-arrange the parameters in diff posting methods.
--  170517          Removed the variable effective_qty_for_curr_ as it is no longer valid as currency diff postiongs are introduced with return transactions itselves and no BALINVOIC transaction is needed for that. 
--  170516  ChFolk  STRSC-7925, Reversed previous correction done in Make_Bal_Invoic_Transaction___ as now curr diff postings are created at return. Hence no need of creating balance invoice postings at credit invoice and cancel invoice.
--  170511  ChFolk  STRSC-7925, Modified Make_Bal_Invoic_Transaction___ to handle balance invoice postings for third currency to include the return cost in receipt currency.
--  170508  ChFolk  STRSC-7108, Removed value_adjustment_ parameter from Make_Price_Diff_Transaction___, Make_Bal_Invoic_Transaction___ and Make_Diff_Transaction___ as it is true for all senario.
--  170508  ChFolk  STRSC-7925, Added new parameter invoice_cancelled_ to Make_Bal_Invoic_Transaction___ and set value for effective_qty_for_curr_ which is a new parameter to Make_Diff_Transaction___
--  170508          when cancelling the invoice created in third currency, no need to consider return qty when calculation the transaction currency cost as return transaction is in different currency.   
--  170505  ChFolk  STRSC-7590, Modified Make_Price_Diff_Transaction___ to avoid calling Make_Diff_Transaction___ when transaction amount is zero.
--  170503  ChFolk  STRSC-7583, Modified Make_Bal_Invoic_Transaction___ to call Make_Diff_Transaction___ only if the transaction_amounts are not NULL.
--  170502  ChFolk  STRSC-7593, Modified Make_Diff_Transaction___ to avoid rounding unit_cost_in_inv_curr_ when calling Do_Curr_Amt_Diff_Posting as it will miss small differences.
--  170426  ChFolk  STRSC-7476, Added new parameters price_diff_per_unit_curr_ and receipt_curr_code, unit_cost_in_receipt_curr_ in to Revalue_Direct_Delivery___, Make_Price_Diff_Transaction___, Make_Diff_Transaction___ and
--  170426          Revalue_Trans_From_PO_Receipt to support price diff postings in transaction currency. Call Mpccom_Accounting_API.Do_Curr_Amt_Diff_Posting from Make_Diff_Transaction___. 
--  170419  ChFolk  STRSC-7046, Modified Make_Bal_Invoic_Transaction___ and Make_Diff_Transaction___ to support balance invoice postings in curr amounts.
--  170418  ChFolk  STRSC-7108, Removed parameter base_curr_code_ from revaluation methods as it is handled at posting creation. Removed method Do_Curr_Amt_Adjust_Booking___ which is handled from Mpccom_AccountingAPI.Do_Curr_Amt_Balance_Posting.
--  170412  ChFolk  STRSC-7108, Removed DEFAULT parameter in methods Revalue_This_Receipt___ and Revalue_Trans_From_PO_Receipt. Modified Do_Curr_Amt_Adjust_Booking___ to handle debit_credit_db_ 
--  170412          based on correction_type defined in company finance and remove if condition inside the method to filter str_code as it is done in the cursor.         
--  170411  ChFolk  STRSC-7046, Added new parameters base_curr_code_, invoice_curr_code_, avg_inv_price_in_inv_curr_ and avg_chg_value_in_inv_curr_ to methods Revalue_All_Serial_Trans___,
--  170411          Start_Revalue_Serial_Trans___, Revalue_Serial_Transactions___ and Revalue_Serial_Transaction___ and modified method Revalue_Serial_Transaction___ to call Do_Curr_Amt_Adjust_Booking___
--  170411          to support revaluation postings in transaction currency.
--  170405  ChFolk  STRSC-6916, Modified Revalue_Return_To_Supplier___ and Revalue_Direct_Delivery___ to support transaction currency value postings
--  170402  ChFolk  STRSC-4972, Added new parameter avg_chg_value_in_inv_curr_ to Revalue_Trans_From_PO_Receipt, Revalue_Part_Transactions___, Revalue_This_Receipt___ and Do_Curr_Amt_Adjust_Booking___.
--  170402          Modified Do_Curr_Amt_Adjust_Booking___ to support charge currency diff postings.
--  170327  ChFolk  STRSC-4971, Modified methods Revalue_Part_Transactions___, Revalue_This_Receipt___ and Revalue_Trans_From_PO_Receipt by adding some parameters
--  170327          to create cascade postings to balanace transaction curr amount. Adde new method Do_Curr_Amt_Adjust_Booking___ which is used to post new posting line
--  170327          to balanace remaining amount in transaction currency where base currency is zero always. 
--  170104  DAYJLK  STRSC-4946, Modified Make_Bal_Invoic_Transaction___ by adding new parameters to method call Inventory_Transaction_Hist_API.Get_Arrival_Value_And_Qty.
--  161124  MeAblk  Bug 132691, Modified Revalue_Serial_Transactions___() to correctly do the part revaluation for the inter-site transferring transactions based on 
--  161124          the inventory part valuation method to avoid revaluation error CLNOTHANDLED. 
--  161104  MeAblk  Bug 132412, Modified Revalue_Part_Transactions___() to consider the new trans_based_reval_group UNDO SUPPLIER MATERIAL SHIPMENT 
--  161104          when retrieving received lots for the UN-PURSHIP and UN-PURBKFL transactions.
--  160923  ChBnlk  Bug 131024, Modified Revalue_Supplier_Shipment___() by adding new parameters company_, date_applied_, order_no_, release_no_ and sequence_no_ and
--  160923          to create postings when there's no POINV_WIP transaction and to do inventory revaluation when there's a POINV_WIP transaction.
--  160627  SBalLK  Bug 129252, Modified method Process_Updated_Shop_Orders___ to get and store include flags of shop order and force set those flags to
--  160627          FALSE in shop order. This will exclude re-opened shop order from MRP process. Modified method Close_Shop_Order__ to re-set stored include flag values back.
--  160229  RuLiLk  Bug 126372, Modified Make_Bal_Invoic_Transaction___ to rounde the purch receipt amount using the base currency rounding. 
--  160229          This is done because purchasing has not done the rounding of receipt amount using base currecy rounding. At first rounding 
--  160229          was done to a higher precision (actual + 2) and then to the actual precision. This is done to achieve a more precise value.
--  150901  AyAmlk  Bug 114937, Modified Revalue_Trans_From_SO_Receipt(), Revalue_Trans_From_PO_Receipt() and Revalue_Trans_From_SO_Scrap_Op() to handle  
--  150901          transaction revaluation events. Added new method counter_() to increase the counter from one. Modified set of methods to handle and 
--  150901          pass the values trans_reval_event_id and closed_by_reval_event_id accordingly.
--  150831  ErFelk  Bug 122622, Modified Revalue_Trans_From_PO_Receipt to only create BALINVOIC transactions only if there are no PRICEDIFF 
--  150831          transactions takes/took place. Also modified Make_Bal_Invoic_Transaction___ to eliminate the purchase WIP costs, their  
--  150831          returns and their corrections when calculating the value for transactions 'BALINVOIC+' or 'BALINVOIC-'.  
--  150824  SBalLK  Bug 120342, Modified Revalue_Direct_Delivery___() and Revalue_Trans_From_PO_Receipt() methods to revalue the connected intersite transfers when
--  150824          revaluating the 'PODIRINTEM' transaction.
--  150824  ErFelk  Bug 121406, Modified Revalue_Trans_From_PO_Receipt and Make_Bal_Invoic_Transaction___ in order to create 'BALINVOIC+' or 'BALINVOIC-'
--  150824          transactions upon a direct delivery if needed. 
--  150822  ErFelk  Bug 120380, Modified method Make_Bal_Invoic_Transaction___ in order to consider the charges, returns, scraps, and their corrections when 
--  150822          creating 'BALINVOIC+' or 'BALINVOIC-' postings. Added new parameters unit_charge_ and exchange_cost_ to Revalue_Trans_From_PO_Receipt and passed them when calling 
--  150822          Make_Bal_Invoic_Transaction___. Modified Make_Bal_Invoic_Transaction___ in order to use unit_charge_ and exchange_cost_ when calculating
--  150822          transaction_amount_ for 'BALINVOIC+' or 'BALINVOIC-'.
--  150821  ErFelk  Bug 117650, Added methods Make_Bal_Invoic_Transaction___ and Make_Diff_Transaction___. Moved generic code from Make_Price_Diff_Transaction___
--  150821          to Make_Diff_Transaction___.
--  150723  Asawlk  Bug 122382, Modified Process_Intersite_Transfers___ to calculate the unit cost of the part in destination site when UoM is different in source
--  150723          and destination sites.
--  150708  IsSalk  KES-907, Renamed usage of order_type attribute of InventoryTransactionHist to source_ref_type.
--  150512  IsSalk  KES-421, Passed new parameter to Inventory_Transaction_Hist_API.New().
--- 150512  MAHPLK  KES-402, Renamed usage of order_no, release_no, sequence_no, line_item_no attributes of InventoryTransactionHist 
--  150512          to source_ref1, source_ref2, source_ref3, source_ref4
--  130904  ChFolk  Modified Revalue_Direct_Return___ to support RETPODIRSH transaction.
--  130903  ChFolk  Modified Revalue_Direct_Delivery___ to solve a merge issue and to call Revalue_Direct_Return___ only if return transaction exists.--  130809  VISALK  Bug 108652, Modified Add_Intersite_Trans_To_List___() to add lot_batch_no_ and inventory_part_cost_level_db_ as parameters and 
--  130809          modified existing logic to check whether if part cost level = 'COST PER LOT BATCH' then separate cascade should be done for each lot.
--  130802  ChJalk  TIBE-910, Removed the global variables.
--  130627  ChFolk  Modified Revalue_Direct_Return___ to get the delivery transaction cost via the new connection introduced in INVENT_TRANS_INTERCONNECT_TAB. 
--  130526  ChFolk  Removed parameter deliv_trans_code_ from Revalue_Direct_Return___ as the exact delivery transaction code can not specified when handling any site return.
--  130626          Modified Revalue_Direct_Delivery___ to change the method call for Revalue_Direct_Return___. Modified Process_Intersite_Transfers___ to avoid transaction
--  130626          revaluation for RETDIFSSCP in destination site as it does not change the inventory cost but just do value adjustment booking based on the change of
--  130626          corresponding RETINTPODS transaction. 
--  130522  ChFolk  Modified Process_Intersite_Transfers___ to avoid transaction revaluation in destination site as it does not change
--  130522          the inventory cost but just do value adjustment booking based on the change of corresponding RETINTPODS transaction.
--  130422  ChFolk  Modified Revalue_Direct_Return___ to add new parameter delivery_transaction_code which use to get the delivery transaction_id from return_transaction_id.
--  130422          Modified Revalue_Direct_Delivery___ to revaluate the cost based on the corresponding return transaction cost.
--  130411  ChFolk  Added new function Rma_Direct_Return___ which returns TRUE when transaction_type_ = 'RMA DIRECT RETURNS'. Added new function
--  130411          Revalue_Direct_Return___ which revalue using direct delivery transaction and do value adjustment booking. Modified
--  130411          Revalue_Part_Transactions___ to call Revalue_Direct_Return___. 
--  130201  UtSwlk  Bug 107076, Modified method Close_Shop_Order__ to call Shop_Ord_API.Close_Shop_Order when closing a re-opened shop order. .
--  121015  TiRalk  Bug 105627, Assigned TRUE to new parameter include_reversed_transactions_ when calling
--  121015          Inventory_Transaction_Hist_API.Get_Supplier_Return_Cost from Revalue_Return_To_Supplier___.
--  120813  Sejalk  Bug 101734, Modified Revalue_Direct_Delivery___() by introducing a loop to modify all the relevant transactions upon a revalue of a 
--  120813          direct delivery.
--  120424  Asawlk  Bug 102289, Modified Revalue_Part_Transactions___() to exit the revaluation process if 'exit_revaluation_' = TRUE.
--  120330  SWiclk  Bug 101984, Modified Revalue_This_Receipt___ by adding the parameters exit_revaluation_ and order_type_db_ in order to stop the revaluation 
--  120330          if there is no difference in receipt and invoiced values. This condition is only applied for POs.
--  111003  Asawlk  Bug 99196, Modified cursor get_transactions in Revalue_Part_Transactions___() to only select the transactions 
--  111003          having part_ownership = 'COMPANY OWNED'. 
--  110908  Asawlk  Bug 98834, Passed correct values for order references when calling Revalue_Return_To_Supplier___() inside Revalue_Part_Transactions___().
--  110525  Asawlk  Bug 95523, Modified Revalue_Part_Transactions___() by calling Cost_For_All_Receipts_Equal___() to check whether
--  110525          the specified cost details are as same as the ones for all the prior receipts when order_type_db_ = 'SHOP ORDER'.
--  110301  AmPalk  Bug 95941, Modified Process_Intersite_Transfers___ by adding condition to prevent numeric or value error, when new_cascade_trans_tab_ has no rows.
--  101019  Asawlk  Bug 93551, Modified methods Revalue_Part_Transactions___() and Revalue_Serial_Transactions___()
--  101019          to check whether current lot_tracking_code in part catalog matches with lot_batch_no on the transaction
--  101019          before revaluation of shop orders take place.
--  100505  KRPELK  Merge Rose Method Documentation.
--  100420  MaRalk  Modified reference by name method call to Inventory_Transaction_Hist_API.Create_And_Account
--  100420          within Make_Price_Diff_Transaction___ method.
--  100406  MaRalk  Modified reference by name method call to Inventory_Transaction_Hist_API.New
--  100406          within Handle_Prosch_Wip_Variance___ method.
--  100315  PraWlk  Bug 88817, Modified Revalue_Part_Transactions___() and Revalue_Serial_Transactions___() to call 
--  100315          Inventory_Part_Unit_Cost_API.Lock_By_Keys_Wait() to lock the InventoryPartUnitCost record before
--  100315          procesing all the affected transactions.
--  100106  ChFolk  Redirect method calls from obsolete package Shop_Order_Int_API.
--  091019  JoAnSe  Bug 86118, Added condition for non-reversed receipt in cursor in Revalue_All_Serial_Trans___
--  091005  JoAnSe  Bug 86118, Removed correction done for 85125 and replaced it with another solution that will start
--                  serial revaluation process from the last receipt of a serial instead of starting from the first
--                  receipt. Changes in Revalue_Serial_Transactions___ and Get_SO_Receipt_Trans_Id___
--  091001  ChFolk  Removed un used parameter quantity_ from Revalue_Serial_Transaction___ and source_contract_ from
--  091001          Process_Part_Changes___. Removed unused variables in the package.
--  ---------------------------------- 14.0.0 -----------------------------------
--  091019  JoAnSe  Bug 86118, Added condition for non-reversed receipt in cursor in Revalue_All_Serial_Trans___
--  091005  JoAnSe  Bug 86118, Removed correction done for 85125 and replaced it with another solution that will start
--                  serial revaluation process from the last receipt of a serial instead of starting from the first
--                  receipt. Changes in Revalue_Serial_Transactions___ and Get_SO_Receipt_Trans_Id___
--  090914  SaWjlk  Bug 85587, Modified procedure Revalue_Part_Transactions___ to revalue the reversal only if the 
--  090914          original transaction was not skipped.
--  090909  HoInlk  Bug 85125, Modified Revalue_Serial_Transactions___ to avoid revaluating for a second receipt
--  090909          with the same serial for the same order.
--  090826  DAYJLK  Bug 80323, Added function Get_Sorted_Shop_Ord_Ref_Tab___. Modified Process_Updated_Shop_Orders___ 
--  090826          to sort the shop order reference table using function Get_Sorted_Shop_Ord_Ref_Tab___. 
--  090504  HoInlk  Bug 77408, Added methods Return_To_Supplier___ and Revalue_Return_To_Supplier___ and used these
--  090504          methods in Revalue_Part_Transactions___ to handle revaluation group 'RETURN TO SUPPLIER'.
--  081017  JoAnSe  Bug 77526, Added parameter sequence_no to Revalue_Trans_From_PO_Receipt
--                  Revalue_Direct_Delivery___ and Make_Price_Diff_Transaction___.
--                  CHGPRDIFF triggered in Make_Price_Diff_Transaction___ when the
--                  cascade was triggered by a charge invoice.
--  080918  JoAnSe  Bug 76803, Changed the way intersite transfers are handled for WA cascades.
--                  Rewrote Process_Intersite_Transfers and added new methods Cost_Details_Equal___
--                  and Add_Intersite_Trans_To_List___.
--                  Also did some cleanup removing some code that was commented out.
--  080908  JoAnSe  Bug 76368, Added check for issue to same order in Revalue_Part_Transactions___.
--  080804  NuVelk  Bug 74513, Modified Revalue_Direct_Delivery___ to correctly 
--  080804          handle direct delivery of purchase components to supplier.
--  080722  NuVelk  Bug 75709, Modified Handle_Prosch_Wip_Variance___ to pass correct
--  080722          configuration_id_ when calling Inventory_Transaction_Hist_API.New  
--  080624  HoInlk  Bug 69398, Added methods Return_To_Inventory___, Return_And_Scrap___, Revalue_Return_To_Inventory___
--  080624          and Revalue_Return_And_Scrap___, and used these methods in Revalue_Part_Transactions___
--  040624          to handle revaluation groups 'RMA RETURN TO INVENTORY' and 'RMA RETURN AND SCRAP'.
--  080423  HoInlk  Bug 72646, Modified Revalue_Part_Transactions___ to exit the procedure
--  080423          if the variable first_receipt_transaction_id_ has received a NULL value.
--  080408  NiBalk  Bug 70198, Modified Revalue_Part_Transactions___ and Revalue_Serial_Transactions___, to 
--  080408          improve performance by refreshing project activitiy for project connected transactions.
--  080123  LEPESE  Bug 68763, modifications in methods Revalue_Serial_Transaction___ and 
--  080123          Revalue_Service_Cost_Arriv___ to make sure we get the correct cost detail
--  080123          for the 'ESO SERVICE COST RECEIPT'.
--  080123  LEPESE  Bug 68763, changed parameter name receipt_price_ to receipt_cost_ in method
--  080123          Revalue_Serial_Transactions___ and also changed parameter order to avoid
--  080123          a mixup with parameter invoice_price_ in the method call chain.
--  070917  MAJOSE  Call ID 143147, call Shop_Ord_API.Close in Close_Shop_Order__ in order to get
--                  variance bookings in Shop Order
--  070319  MiKulk  Bug 62991, Add line_item_no_ param to the Revalue_Trans_From_SO_Receipt. 
--  ----------------------------- Wings Merge End -------------------------------
--  070130  Dinklk  Merged Wings code.
--  061228  JoAnSe  Added handling for Part Id change in Revalue_Serial_Transactions___
--                  and Revalue_Part_Transactions___
--                  Added Transaction_Renames_Part___  and Process_Part_Changes___
--                  Added parameter connected_receipt_trans_id_ to Start_Revalue_Serial_Trans___
--  ----------------------------- Wings Merge Start -----------------------------
--  060328  JoAnSe  In Revalue_Part_Transactions___ condition Skip_Cost_Update___ = TRUE
--  060328          checked before checking for reversal transactions.
--  060322  JoAnSe  Corrected call to Reverse_Accounting in Revalue_Trans_From_SO_Scrap_Op.
--  060320  JoAnSe  Ended execution in Revalue_Trans_From_PO_Receipt after call to Revalue_Direct_Delivery___
--  060308  JoAnSe  Added Revalue_Direct_Delivery___ used in Revalue_Trans_From_PO_Receipt
--  060308          Added parameter external_direct_delivery_ to Revalue_Trans_From_PO_Receipt
--  060302  JoAnSe  Added Cancel_Int_Purch_Receipt___ used in Revalue_Cancel_Transaction___
--  060216  JoAnSe  Added calls to Inventory_Transaction_Hist_API.Balance_Transit_And_Invent_Acc.
--  060216          Added parameter value_adjustment_ in call to Reverse_Accounting.
--  060210  LEPESE  Modification of cursor get_transactions in method Revalue_Part_Transactions___.
--  060210          result prior_weighted_average_qty is calculated as
--  060210          pre_trans_level_qty_in_stock + pre_trans_level_qty_in_transit.
--  060209  JoAnSe  Added handling for consignment stock arrivals and
--  060209          arrivals due to ownership transfer in Revalue_All_Serial_Trans___
--  060209  JoAnSe  Added special handling for undo return rework transactions
--  060209          in Revalue_Cancel_Transaction___
--  060206  JoAnSe  Changes in handling of revaluation transactions in Revalue_Part_Transactions___
--  060203  JoAnSe  Added call to Reval_WA_Supplier_Shipment in Revalue_Supplier_Shipment___
--  060203          Replaced calls to Mpccom_Accounting_API.Reverse_Accounting
--  060203          with Inventory_Transaction_Hist_API.Reverse_Accounting
--  060202  JoAnSe  Added reinitialization of local variables for each lot
--  060202          in Revalue_Part_Transactions___
--  060130  JoAnSe  Added handling for multiple revaluation transactions in
--  060130          Revalue_Part_Transactions___.
--  060124  NiDalk  Added Assert safe annotation.
--  060123  LEPESE  Added inventory_valuation_method and inventory_part_cost_level when
--  060123          calling Inventory_Part_In_Stock_API.Transform_Cost_Details.
--  060213  JoAnSe  Removed obsolete method Get_PO_Receipt_Qty___,
--  061213          also removed unused parameters and variables.
--  060111  JoAnSe  Added handling for 'Posting Cost Group Change' transactions
--  060111  JoAnSe  Removed obsolete method Get_Current_Unmatched_Cost___
--  060103  JoAnSe  Rewrote cursor in Get_PO_Receipt_Trans_Id___
--                  Changes in Decide_Progress_Alternative___ for repair order cost.
--  051223  JoAnSe  Changes for creation of PRICEDIFF transactions and
--                  for handling manual revaluations
--  051219  JoAnSe  Changed Make_Price_Diff_Transaction to implementation instead
--                  of public.
--  051215  JoAnSe  Changes for revaluation of intersite transactions
--  051214  JoAnSe  Added Revalue_Trans_From_SO_Scrap_Op.
--  051213  JoAnSe  Changes to trigger cascade updates of SO:s for which issue
--                  transactions have been changed.
--  051203  JoAnSe  Major redesign in order to handle cascades from SO receipts
--                  as well as PO receipts
--  051201  JoAnSe  Added stubs for method Revalue_Trans_From_SO_Receipt and
--                  Revalue_Trans_From_PO_Receipt
--  051111  JoAnSe  Replaced use of associated_transaction_id with
--                  Invent_Trans_Interconnect_API.Get_Connected_Transaction_Id
--  051107  JoAnSe  Removed Intersite_Move_Revaluation___, Move_To_Different_Site___,
--                  Modify_Custord_Deliv_Cost___ and Customer_Order_Shipment___
--  051101  LEPESE  Major reimplementation of this LU because of Cost Details.
--  051004  JoAnSe  Merged DMC changes below
--  **********************  DMC Begin  ****************************************
--  050920  JoAnSe  Added parameter order_related_move_ in call to
--                  Inventory_Part_In_Stock_API.Intersite_Move_Revaluation
--  050831  LEPESE  Changed datatype in one parameter when calling method
--  050831          Inventory_Part_Unit_Cost_API.Find_And_Modify_Serial_Cost.
--  **********************  DMC Begin  ****************************************
--  050921  NiDalk  Removed unused variables.
--  050317  LEPESE  Introduced new transaction_type 'CUSTOMER ORDER SHIPMENT RETAIN OWNERSHIP'.
--  050202  JOHESE  Modified Revalue_Serial_Transactions___ and Revalue_Part_Transactions
--  050202  IsWilk  Modified the added design history on 050117 by IsWilk.
--  050201  LEPESE  Created new method Get_Current_Unmatched_Cost___. Called this method from
--                  Revalue_Part_Transactions and Revalue_Serial_Transactions immediately before
--                  calling Make_Price_Diff_Transaction. The reason is that we cannot use the
--                  original_receipt_price when making price diff transactions because of the new
--                  functionality "Post Price Difference at Arrival" that can be selected on
--                  company level. This functionality means that there could already be
--                  price difference postings on the arrival transactions, and we must consider
--                  those when creating price diff transactions during the
--                  "Transaction Based Invoice Consideration" functionality.
--  050117  IsWilk  Modified the PROCEDURE Revalue_Cancel_Transaction___ to add the
--  050117          condition before assign the value to weighted_average_cost_.
--  040920  HeWelk  Added catch_quantity as null to Inventory_Transaction_Hist_API.New().
--  040518  DaZaSe  Project Inventory: Added zero/null-parameters to call Inventory_Transaction_Hist_API.New,
--                  change these parameters to real Activity_Seq and Project_Id values if this functionality uses Project Inventory.
--  040319  LEPESE  Send invoice_qty_ instead of receipt_qty_ when calling
--                  Make_Price_Diff_Transaction from Revalue_Part_Transactions.
--  040317  LEPESE  Modifications in several methods to add a return statement immediately
--                  after setting the boolean revaluation_is_impossible_ to TRUE. The reason is
--                  to save performance and to avoid a NOT NULL violation in the transaction history.
--                  Modification in Make_Price_Diff_Transaction to create a transaction with
--                  quantity != 0 and to send in the price difference per unit.
--  040317  LEPESE  Modifications in methods Revalue_Serial_Transactions___ and
--                  Revalue_Serial_Transaction___ in order to get a correct new
--                  serial cost that adds delivery overhead to the invoice price.
--  040315  LEPESE  Model cleanup activities.
--  040314  LEPESE  Model cleanup activities.
--  040314  LEPESE  Added declarations for all LU specific implementation methods.
--  040312  LEPESE  Added boolean parameter in call to Get_Component_Arrival_Cost in order
--                  to get the current arrival cost, not the original arrival cost.
--  040311  LEPESE  Modified calculation in method Revalue_Service_Cost_Arriv___.
--  040305  LEPESE  Corrected calculation of current_receipt_price_ in Revalue_This_Arrival___.
--  040304  LEPESE  Removed method Get_Original_Receipt_Price.
--  040303  LEPESE  Implemented functionality for weighted average revaluation.
--  040225  LEPESE  Added methods Revalue_Part_Transactions, Revalue_Part_Transactions___
--                  and Revalue_Part_Transaction___.
--  040225  LEPESE  Added exception for Scrapping At Supplier - External Service Order.
--  040224  LEPESE  Replaced hard-coded transaction codes with check for trans_based_reval_group
--                  values in the MpccomTransactionCode basic data.
--  040223  LEPESE  Added call to lock InventoryPartUnitCost with WAIT option to method
--                  Decide_Progress_Alternative___ when component with new part number is received.
--  040220  LEPESE  Created method Handle_Prosch_Wip_Variance___.
--  040220  LEPESE  Added call to Intersite_Move_Revaluation.
--  040218  LEPESE  Added call to Customer Order to modify cost of delivery.
--  040218  LEPESE  Major redesign. Changed concept from recursive to iterative.
--  040217  LEPESE  Major redesign. Implemented functionality for the external service order process.
--  040216  LEPESE  Added function Cost_Should_Be_Changed___.
--  040216  LEPESE  Moving setting of savepoint in method Revalue_Serial_Transactions
--                  so that no new savepoint is set if the method is recursevly called.
--  040215  LEPESE  Added method Repair_Service_Cost_Receipt___.
--  040213  LEPESE  Added call to Shop_Order_Int_API.Balance_Wip_Material_Variance.
--  040211  LEPESE  Added default parameter replaces_renamed_serial_ to method
--                  Revalue_Serial_Transactions.
--  040210  LEPESE  Added method Make_Price_Diff_Transaction.
--  040208  LEPESE  Added several new implemenation methods.
--  040205  LEPESE  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

TYPE Shop_Ord_Ref_Rec IS RECORD (
   order_no    VARCHAR2(12),
   release_no  VARCHAR2(4),
   sequence_no VARCHAR2(4));
TYPE Shop_Ord_Ref_Tab IS TABLE OF Shop_Ord_Ref_Rec
INDEX BY PLS_INTEGER;
TYPE Trans_List_Rec IS RECORD (
   transaction_id      NUMBER );
TYPE Trans_List_Tab IS TABLE OF Trans_List_Rec
INDEX BY PLS_INTEGER;
TYPE Intersite_Trans_List_Rec IS RECORD (
   dst_transaction_id  NUMBER,
   src_transaction_id  NUMBER,
   dst_site            VARCHAR2(5),
   lot_batch_no        VARCHAR2(20));
TYPE Intersite_Trans_List_Tab IS TABLE OF Intersite_Trans_List_Rec
INDEX BY PLS_INTEGER;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
-- Revalue_Part_Transactions___
--   Main procedure for revaluation of transactions for a part with inventory
--   valuation method is Weighted Average.
--   When order_type_db_ is 'SHOP ORDER' or 'PUR ORDER' transactions made since
--   the first receipt of the specified Shop Order or Purchase Order will be
PROCEDURE Revalue_Part_Transactions___ (
   revaluation_is_impossible_  IN OUT BOOLEAN,
   transaction_update_counter_ IN OUT NUMBER,
   order_ref1_                 IN     VARCHAR2,
   order_ref2_                 IN     VARCHAR2,
   order_ref3_                 IN     VARCHAR2,
   order_ref4_                 IN     NUMBER,
   order_type_db_              IN     VARCHAR2,
   contract_                   IN     VARCHAR2,
   part_no_                    IN     VARCHAR2,
   receipt_cost_               IN     NUMBER,
   invoice_price_              IN     NUMBER,
   company_                    IN     VARCHAR2,
   first_viable_posting_date_  IN     DATE,
   cost_detail_tab_            IN     Inventory_Part_Unit_Cost_API.Cost_Detail_Tab,
   connected_receipt_trans_id_ IN     NUMBER,
   trans_reval_event_id_       IN     NUMBER,
   receipt_curr_code_          IN     VARCHAR2 DEFAULT NULL,
   invoice_curr_code_          IN     VARCHAR2 DEFAULT NULL,
   avg_inv_price_in_inv_curr_  IN     NUMBER DEFAULT NULL,
   avg_chg_value_in_inv_curr_  IN     NUMBER DEFAULT NULL,
   unit_cost_in_receipt_curr_  IN     NUMBER DEFAULT NULL)
IS
   first_receipt_transaction_id_ NUMBER;
   tran_code_rec_                Mpccom_Transaction_Code_API.Public_Rec;
   receipt_trans_rec_            Inventory_Transaction_Hist_API.Public_Rec;
   transaction_type_             VARCHAR2(50);
   first_reval_trans_type_       VARCHAR2(50);
   empty_cost_detail_tab_        Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   weighted_avg_cost_detail_tab_ Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   transaction_cost_detail_tab_  Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   prior_avg_cost_detail_tab_    Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   reval_prior_cost_detail_tab_  Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   pos_cost_diff_tab_            Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   neg_cost_diff_tab_            Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   old_wip_sum_value_            NUMBER;
   inv_part_rec_                 Inventory_Part_API.Public_Rec;
   selection_configuration_id_   VARCHAR2(50);
   selection_lot_batch_no_       VARCHAR2(20);
   selection_condition_code_     VARCHAR2(10);
   shop_ord_ref_tab_             Shop_Ord_Ref_Tab;
   no_of_transfers_              NUMBER := 0;
   transfer_trans_tab_           Trans_List_Tab;
   no_of_part_changes_           NUMBER := 0;
   part_change_trans_tab_        Trans_List_Tab;
   reval_trans_found_            BOOLEAN;
   configuration_id_             INVENTORY_TRANSACTION_HIST_TAB.configuration_id%TYPE;
   exit_procedure_               EXCEPTION;
   org_transaction_code_         INVENTORY_TRANSACTION_HIST_TAB.transaction_code%TYPE;
   org_trans_code_rec_           Mpccom_Transaction_Code_API.Public_Rec;
   part_catalog_rec_             Part_Catalog_API.Public_Rec;
   exit_revaluation_             BOOLEAN;
   date_applied_                 DATE;

   -- It is possible to receive several different lots from both purchase order
   -- and shop order
   -- Only if part cost level is cost per lot there will be a need to handle
   -- the transactions for one lot at the time.
   -- For other part cost levels the cursor will return '*' as lot_batch_no.

   -- for the UN-PURSHIP and UN-PURBKFL transactions.
   -- Only one of part of the union below will result in any rows being retrieved
   -- included in the where clause.  
   CURSOR get_received_lots(inventory_part_cost_level_db_ IN VARCHAR2,
                            first_receipt_lot_batch_no_   IN VARCHAR2) IS

      SELECT  DISTINCT lot_batch_no
        FROM  INVENTORY_TRANSACTION_HIST_TAB a, mpccom_transaction_code_pub b
       WHERE  inventory_part_cost_level_db_ = 'COST PER LOT BATCH'
         AND  order_type_db_                = 'PUR ORDER'
         AND  a.source_ref1                 = order_ref1_
         AND  a.source_ref2                 = order_ref2_
         AND  a.source_ref3                 = order_ref3_
         AND  a.source_ref4                 = order_ref4_
         AND  a.source_ref_type             = 'PUR ORDER'
         AND  a.transaction_code            = b.transaction_code
         AND  b.trans_based_reval_group_db NOT IN ('SUPPLIER MATERIAL SHIPMENT',
                                               'UNDO SUPPLIER MATERIAL SHIPMENT',
                                               'SUPPLIER MATERIAL SHIPMENT CONS STOCK',
                                               'SUPPLIER EXCHANGE SHIPMENT',
                                               'SUPPLIER EXCHANGE SHIPMENT CONS STOCK',
                                               'ESO SCRAP AT SUPPLIER')
   UNION
      SELECT  DISTINCT lot_batch_no
        FROM  INVENTORY_TRANSACTION_HIST_TAB a, mpccom_transaction_code_pub b
       WHERE  inventory_part_cost_level_db_  = 'COST PER LOT BATCH'
         AND  order_type_db_                 = 'SHOP ORDER'
         AND  a.source_ref1                  = order_ref1_
         AND  a.source_ref2                  = order_ref2_
         AND  a.source_ref3                  = order_ref3_
         AND  a.source_ref_type              = 'SHOP ORDER'
         AND  a.contract                     = contract_
         AND  a.part_no                      = part_no_
         AND  a.transaction_code             = b.transaction_code
         AND  b.trans_based_reval_group_db   = 'MANUFACTURING RECEIPT'
   UNION
      SELECT  first_receipt_lot_batch_no_
        FROM  dual
       WHERE  inventory_part_cost_level_db_ = 'COST PER LOT BATCH'
         AND  order_type_db_ IS NULL
   UNION
      SELECT  '*'
        FROM  dual
       WHERE  inventory_part_cost_level_db_ != 'COST PER LOT BATCH';

   CURSOR get_transactions(configuration_id_ IN VARCHAR2,
                           lot_batch_no_     IN VARCHAR2,
                           condition_code_   IN VARCHAR2) IS
      SELECT transaction_id, transaction_code, original_transaction_id,
             accounting_id, configuration_id, quantity, source_ref1, source_ref2,
             source_ref3, source_ref4, source_ref_type, pre_trans_level_qty_in_stock +
             pre_trans_level_qty_in_transit prior_weighted_average_qty, direction,
             activity_seq, inventory_valuation_method, inventory_part_cost_level,
             lot_batch_no, condition_code, pre_accounting_id, date_applied
      FROM   INVENTORY_TRANSACTION_HIST_TAB
      WHERE  contract        = contract_
      AND    part_no         = part_no_
      AND    part_ownership  = 'COMPANY OWNED'
      AND    transaction_id >= first_receipt_transaction_id_
      AND    ((configuration_id = configuration_id_) OR (configuration_id_ = '*'))
      AND    ((condition_code  = condition_code_) OR (condition_code_ IS NULL))
      AND    ((lot_batch_no = lot_batch_no_) OR (lot_batch_no_ = '*'))
      ORDER BY transaction_id;
BEGIN
   
   -- Find the first receipt
   IF (connected_receipt_trans_id_ IS NOT NULL) THEN
      first_receipt_transaction_id_ := connected_receipt_trans_id_;
   ELSIF (order_type_db_ = 'PUR ORDER') THEN
      first_receipt_transaction_id_ := Get_PO_Receipt_Trans_Id___(order_ref1_,
                                                                  order_ref2_,
                                                                  order_ref3_,
                                                                  order_ref4_,
                                                                  order_type_db_,
                                                                  contract_,
                                                                  part_no_,
                                                                  NULL,
                                                                  1);
   ELSIF (order_type_db_ = 'SHOP ORDER') THEN
      first_receipt_transaction_id_ := Get_SO_Receipt_Trans_Id___(order_ref1_,
                                                                  order_ref2_,
                                                                  order_ref3_,
                                                                  order_type_db_,
                                                                  contract_,
                                                                  part_no_,
                                                                  NULL);

   ELSE
      Error_SYS.Record_General(lu_name_,'FATALDESERROR: Fatal design time error');
   END IF;

   IF (first_receipt_transaction_id_ IS NULL) THEN
      RAISE exit_procedure_;
   END IF;

   -- If this cascade was triggered from a Shop Order receipt then check if anything was changed
   -- since the receipt, if not just exit the cascade
   IF (order_type_db_ = 'SHOP ORDER') THEN
      IF (Cost_For_All_Receipts_Equal___(order_ref1_,
                                         order_ref2_,
                                         order_ref3_,
                                         order_type_db_,
                                         contract_,
                                         part_no_,
                                         cost_detail_tab_)) THEN
         RAISE exit_procedure_;
      END IF;
   END IF;

   inv_part_rec_      := Inventory_Part_API.Get(contract_, part_no_);
   receipt_trans_rec_ := Inventory_Transaction_Hist_API.Get(first_receipt_transaction_id_);
   part_catalog_rec_  := Part_Catalog_API.Get(part_no_);

   -- Check which transactions need to be updated.
   -- This depends on the inventory_part_cost_level for the received part
   CASE inv_part_rec_.inventory_part_cost_level
      WHEN 'COST PER PART' THEN
         selection_configuration_id_ := '*';
         selection_condition_code_   := NULL;
      WHEN 'COST PER CONDITION' THEN
         selection_configuration_id_ := '*';
         selection_condition_code_   := receipt_trans_rec_.condition_code;
      WHEN 'COST PER LOT BATCH' THEN
         selection_configuration_id_ := '*';
         selection_condition_code_ := NULL;
      WHEN 'COST PER CONFIGURATION' THEN
         selection_configuration_id_ := receipt_trans_rec_.configuration_id;
         selection_condition_code_   := NULL;
      ELSE
         Error_SYS.Record_General(lu_name_, 'CLNOTHANDLED: Inventory Part Cost Level :P1 not handled for Weighted Average in transaction revaluation',
                                  inv_part_rec_.inventory_part_cost_level);
   END CASE;
   Inventory_Part_Unit_Cost_API.Lock_By_Keys_Wait(contract_,
                                                  part_no_,
                                                  '*',
                                                  '*',
                                                  '*');
   FOR next_lot_ IN get_received_lots(inv_part_rec_.inventory_part_cost_level,
                                      receipt_trans_rec_.lot_batch_no) LOOP
      selection_lot_batch_no_ := next_lot_.lot_batch_no;

      -- Reinitialize variables for each lot batch processed
      reval_trans_found_      := FALSE;
      first_reval_trans_type_ := NULL;
      reval_prior_cost_detail_tab_ := empty_cost_detail_tab_;

      weighted_avg_cost_detail_tab_ := empty_cost_detail_tab_;
      FOR next_trans_ IN get_transactions(selection_configuration_id_,
                                          selection_lot_batch_no_,
                                          selection_condition_code_) LOOP

         tran_code_rec_               := Mpccom_Transaction_Code_API.Get(next_trans_.transaction_code);
         transaction_type_            := tran_code_rec_.trans_based_reval_group;
         date_applied_                := GREATEST(first_viable_posting_date_, next_trans_.date_applied);
         transaction_cost_detail_tab_ := Inventory_Transaction_Cost_API.Get_Transaction_Cost_Details(
                                                                            next_trans_.transaction_id);

         -- If we have run into a revaluation transaction then exit the loop as soon as
         -- the first transaction that is not part of the same 'revaluation batch' is found.
         IF (reval_trans_found_) THEN
            IF NOT ((Inventory_Value_Decrease___(transaction_type_)) OR
                    (Inventory_Value_Increase___(transaction_type_))) THEN
               EXIT;
            END IF;

            prior_avg_cost_detail_tab_ := Pre_Invent_Trans_Avg_Cost_API.Get_Cost_Details(next_trans_.transaction_id);
            -- Even if the next transaction is a revaluation we should exit if it is not
            -- part of the same batch. Verify this by comparing prior average cost details
            Inventory_Part_Unit_Cost_API.Create_Cost_Diff_Tables(pos_cost_diff_tab_,
                                                                 neg_cost_diff_tab_,
                                                                 reval_prior_cost_detail_tab_,
                                                                 prior_avg_cost_detail_tab_);
            IF ((pos_cost_diff_tab_.COUNT > 0) OR (neg_cost_diff_tab_.COUNT >0)) THEN
               EXIT;
            END IF;
         END IF;

         Make_Add_Pre_Reval_Actions___(old_wip_sum_value_,
                                       next_trans_.accounting_id,
                                       transaction_type_);

         -- Make sure the valuation method and cost level on the transaction is
         -- the same as currently specified on inventory part
         IF ((next_trans_.inventory_valuation_method != inv_part_rec_.inventory_valuation_method) OR
             (next_trans_.inventory_part_cost_level  != inv_part_rec_.inventory_part_cost_level)) THEN
            revaluation_is_impossible_ := TRUE;
         ELSIF ((connected_receipt_trans_id_ = next_trans_.transaction_id) OR
                (Purchase_Order_Arrival___(transaction_type_)) OR
                (Manufacturing_Receipt___(transaction_type_))) THEN
            IF ((connected_receipt_trans_id_ = next_trans_.transaction_id) OR
                ((next_trans_.source_ref1    = order_ref1_) AND
                 (next_trans_.source_ref2  = order_ref2_) AND
                 (next_trans_.source_ref3 = order_ref3_) AND
                 ((next_trans_.source_ref4 IS NULL) OR (next_trans_.source_ref4 = order_ref4_)) AND
                 (next_trans_.source_ref_type   = order_type_db_))) THEN

               -- Either this was the receipt that should initiate the revaluation or
               -- else this could be the receipt transaction for an intersite
               -- move or the receipt transaction for a part id change
               Revalue_This_Receipt___(exit_revaluation_,
                                       revaluation_is_impossible_,
                                       weighted_avg_cost_detail_tab_,
                                       next_trans_.transaction_id,
                                       company_,
                                       next_trans_.quantity,
                                       next_trans_.prior_weighted_average_qty,
                                       receipt_cost_,
                                       cost_detail_tab_,
                                       date_applied_,
                                       order_type_db_,
                                       trans_reval_event_id_,
                                       receipt_curr_code_,
                                       invoice_curr_code_,
                                       avg_inv_price_in_inv_curr_,
                                       avg_chg_value_in_inv_curr_,
                                       next_trans_.accounting_id,
                                       contract_,
                                       unit_cost_in_receipt_curr_);

               Increase___(transaction_update_counter_);
               IF (exit_revaluation_) THEN
                  RAISE exit_procedure_;
               END IF;
            ELSE
               Revalue_Other_Receipt___(revaluation_is_impossible_,
                                        weighted_avg_cost_detail_tab_,
                                        next_trans_.transaction_id,
                                        next_trans_.quantity,
                                        transaction_cost_detail_tab_,
                                        next_trans_.prior_weighted_average_qty,
                                        trans_reval_event_id_,
                                        date_applied_);
               Increase___ (transaction_update_counter_);
            END IF;
         ELSIF (Repair_Service_Cost_Arrival___(transaction_type_)) THEN
            IF ((next_trans_.source_ref1    = order_ref1_) AND
                (next_trans_.source_ref2  = order_ref2_) AND
                (next_trans_.source_ref3 = order_ref3_) AND
                ((next_trans_.source_ref4 IS NULL) OR (next_trans_.source_ref4 = order_ref4_)) AND
                (next_trans_.source_ref_type = order_type_db_)) THEN

               Revalue_Service_Cost_Arriv___(next_trans_.transaction_id,
                                             invoice_price_,
                                             company_,
                                             contract_,
                                             date_applied_,
                                             trans_reval_event_id_);
               Increase___ (transaction_update_counter_);
            END IF;
         ELSIF (External_Receipt___(transaction_type_)) THEN
            Revalue_Other_Receipt___(revaluation_is_impossible_,
                                     weighted_avg_cost_detail_tab_,
                                     next_trans_.transaction_id,
                                     next_trans_.quantity,
                                     transaction_cost_detail_tab_,
                                     next_trans_.prior_weighted_average_qty,
                                     trans_reval_event_id_,
                                     date_applied_);
            Increase___ (transaction_update_counter_);
         ELSIF ((Scrap_At_Supplier___(transaction_type_))  OR
                (Skip_Cost_Update___ (transaction_type_))) THEN
            NULL;
         ELSIF (next_trans_.original_transaction_id IS NOT NULL) THEN
            org_transaction_code_ := Inventory_Transaction_Hist_API.Get_Transaction_Code(next_trans_.original_transaction_id);  
            org_trans_code_rec_   := Mpccom_Transaction_Code_API.Get(org_transaction_code_);              
            -- Revalue the reversal only if the original transaction was not skipped 
            -- Revalue the reversal only if the original transaction was not skipped 
            IF NOT (Skip_Cost_Update___ (org_trans_code_rec_.trans_based_reval_group)) THEN
               Revalue_Cancel_Transaction___(revaluation_is_impossible_,
                                             weighted_avg_cost_detail_tab_,
                                             next_trans_.transaction_id,
                                             next_trans_.quantity,
                                             next_trans_.prior_weighted_average_qty,
                                             next_trans_.original_transaction_id,
                                             next_trans_.direction,
                                             transaction_type_,
                                             trans_reval_event_id_,
                                             date_applied_);
               Increase___ (transaction_update_counter_);
            END IF;
         ELSIF (Shipped_To_Supplier___(transaction_type_)) THEN            
            Revalue_Supplier_Shipment___(revaluation_is_impossible_,
                                         weighted_avg_cost_detail_tab_,
                                         next_trans_.transaction_id,
                                         next_trans_.prior_weighted_average_qty,                                         
                                         trans_reval_event_id_,
                                         company_,
                                         date_applied_,
                                         next_trans_.source_ref1,
                                         next_trans_.source_ref2,
                                         next_trans_.source_ref3);
            Increase___ (transaction_update_counter_);

         ELSIF ((Shipped_To_Intern_Customer___(transaction_type_)) OR
                (Intersite_Transfer_Issue___(transaction_type_))) THEN
            -- Store the connected transaction id for later processing
            -- The revaluation process may have to be continued on the receiving site
            no_of_transfers_ := no_of_transfers_ + 1;
            transfer_trans_tab_(no_of_transfers_).transaction_id      := next_trans_.transaction_id;

            Revalue_Other_Transaction___(weighted_avg_cost_detail_tab_,
                                         next_trans_.transaction_id,
                                         company_,
                                         date_applied_,
                                         trans_reval_event_id_);
            Increase___ (transaction_update_counter_);

         ELSIF (Transaction_Renames_Part___(transaction_type_)) THEN
            -- Store the connected transaction id for later processing
            -- The revaluation process may have to be continued with the renamed-to part
            no_of_part_changes_ := no_of_part_changes_ + 1;
            part_change_trans_tab_(no_of_part_changes_).transaction_id       := next_trans_.transaction_id;

            Revalue_Other_Transaction___(weighted_avg_cost_detail_tab_,
                                         next_trans_.transaction_id,
                                         company_,
                                         date_applied_,
                                         trans_reval_event_id_);
            Increase___ (transaction_update_counter_);
         ELSIF ((Inventory_Value_Decrease___(transaction_type_)) OR
                (Inventory_Value_Increase___(transaction_type_))) THEN
            IF NOT reval_trans_found_ THEN
               reval_trans_found_      := TRUE;
               first_reval_trans_type_ := transaction_type_;

               -- Save the current prior weighted average cost details
               -- As long as the following transactions have the same prior weighted average cost
               -- details they are considered to belong to the same 'revaluation batch'
               reval_prior_cost_detail_tab_ := Pre_Invent_Trans_Avg_Cost_API.Get_Cost_Details(next_trans_.transaction_id);
            END IF;
            Revalue_Reval_Transaction___(next_trans_.transaction_id,
                                         weighted_avg_cost_detail_tab_,
                                         transaction_type_,
                                         first_reval_trans_type_,
                                         company_,
                                         date_applied_,
                                         trans_reval_event_id_);
            Increase___ (transaction_update_counter_);
         ELSIF (Posting_Cost_Group_Change___(transaction_type_)) THEN
                  Revalue_Cost_Group_Change___(next_trans_.transaction_id,
                                               weighted_avg_cost_detail_tab_,
                                               company_,
                                               date_applied_,
                                               trans_reval_event_id_);
                  Increase___ (transaction_update_counter_);
         ELSIF (Rma_Return_To_Inventory___(transaction_type_)) THEN
            Revalue_Return_To_Inventory___ (revaluation_is_impossible_,
                                            weighted_avg_cost_detail_tab_,
                                            next_trans_.transaction_id,
                                            next_trans_.quantity,
                                            next_trans_.prior_weighted_average_qty,
                                            contract_,
                                            part_no_,
                                            next_trans_.configuration_id,
                                            next_trans_.lot_batch_no,
                                            next_trans_.condition_code,
                                            next_trans_.source_ref1,
                                            next_trans_.source_ref4,
                                            next_trans_.transaction_code,
                                            company_,
                                            date_applied_,
                                            trans_reval_event_id_);
            Increase___ (transaction_update_counter_);
         ELSIF (Rma_Return_And_Scrap___(transaction_type_)) THEN
            Revalue_Return_And_Scrap___ (next_trans_.transaction_id,
                                         contract_,
                                         part_no_,
                                         next_trans_.configuration_id,
                                         next_trans_.lot_batch_no,
                                         next_trans_.condition_code,
                                         next_trans_.source_ref1,
                                         next_trans_.source_ref4,
                                         next_trans_.transaction_code,
                                         company_,
                                         date_applied_,
                                         trans_reval_event_id_);
            Increase___ (transaction_update_counter_);
         ELSIF (Return_To_Supplier___(transaction_type_)) THEN            
            Revalue_Return_To_Supplier___(weighted_avg_cost_detail_tab_,
                                          next_trans_.transaction_id,
                                          next_trans_.prior_weighted_average_qty,
                                          next_trans_.quantity,
                                          next_trans_.source_ref1,
                                          next_trans_.source_ref2,
                                          next_trans_.source_ref3,
                                          next_trans_.source_ref4,
                                          company_,
                                          date_applied_,
                                          trans_reval_event_id_,
                                          receipt_curr_code_,
                                          invoice_curr_code_,
                                          avg_inv_price_in_inv_curr_,
                                          avg_chg_value_in_inv_curr_,
                                          next_trans_.accounting_id,
                                          contract_,
                                          unit_cost_in_receipt_curr_);
            Increase___ (transaction_update_counter_);
         ELSIF (Part_Reval_Is_Impossible___(transaction_type_)) THEN
            revaluation_is_impossible_ := TRUE;
         ELSIF (Rma_Direct_Return___(transaction_type_)) THEN
            no_of_transfers_ := no_of_transfers_ + 1;
            transfer_trans_tab_(no_of_transfers_).transaction_id := next_trans_.transaction_id;

            Revalue_Direct_Return___(next_trans_.transaction_id,
                                     company_,
                                     date_applied_,
                                     trans_reval_event_id_,
                                     next_trans_.accounting_id,
                                     contract_,
                                     next_trans_.quantity,
                                     receipt_curr_code_,
                                     invoice_curr_code_,
                                     avg_inv_price_in_inv_curr_,
                                     avg_chg_value_in_inv_curr_,
                                     unit_cost_in_receipt_curr_);
         ELSE
            Revalue_Other_Transaction___(weighted_avg_cost_detail_tab_,
                                         next_trans_.transaction_id,
                                         company_,
                                         date_applied_,
                                         trans_reval_event_id_);
            Increase___ (transaction_update_counter_);

            IF (Shop_Order_Material_Issue___(transaction_type_)) THEN
               -- Make sure that the issue is not for the same order that initiated the current cascade
               -- This could be the case for repair orders where the same part is received and issued.
               -- In this case if issues have been made after the first receipt then revaluation will not be possible.
               IF ((next_trans_.source_ref1    = order_ref1_) AND
                   (next_trans_.source_ref2  = order_ref2_) AND
                   (next_trans_.source_ref3 = order_ref3_)) THEN
                  revaluation_is_impossible_ := TRUE;
               ELSIF (((part_catalog_rec_.lot_tracking_code  = 'NOT LOT TRACKING') AND (next_trans_.lot_batch_no != '*')) OR
                      ((part_catalog_rec_.lot_tracking_code != 'NOT LOT TRACKING') AND (next_trans_.lot_batch_no  = '*'))) THEN
                  revaluation_is_impossible_ := TRUE;
               ELSE
                  -- Add the new shop order to the list for later processing
                  Add_Shop_Order_To_List___(shop_ord_ref_tab_,
                                            next_trans_.source_ref1,
                                            next_trans_.source_ref2,
                                            next_trans_.source_ref3);
               END IF;
            END IF;
         END IF;

         IF (configuration_id_ IS NULL) THEN
            configuration_id_ := next_trans_.configuration_id;
         END IF;

         EXIT WHEN (revaluation_is_impossible_);

         Make_Add_Post_Reval_Actions___(next_trans_.source_ref1,
                                        company_,
                                        transaction_type_,
                                        next_trans_.accounting_id,
                                        old_wip_sum_value_,
                                        trans_reval_event_id_);

         IF (NVL(next_trans_.activity_seq,0) > 0) THEN
            Project_Refresh_Accounting_API.New(next_trans_.accounting_id, contract_, 'INVENTORY');
         END IF;
      END LOOP;

      IF (NOT revaluation_is_impossible_) THEN
         IF (NOT reval_trans_found_) THEN
            Inventory_Part_Unit_Cost_API.Set_Actual_Cost(contract_,
                                                         part_no_,
                                                         configuration_id_,
                                                         selection_lot_batch_no_,
                                                         selection_condition_code_,
                                                         weighted_avg_cost_detail_tab_);
         END IF;
      ELSE
         EXIT;
      END IF;
   END LOOP;
   
   Inventory_Transaction_Hist_API.Refresh_Activity_Info(contract_);
   
   -- If any intersite transfers have been made a cascade update might have to
   -- be initiated for the receiving sites as well
   IF (NOT revaluation_is_impossible_) THEN
      IF (transfer_trans_tab_.COUNT > 0) THEN
         Process_Intersite_Transfers___(revaluation_is_impossible_,
                                        transaction_update_counter_,
                                        contract_,
                                        company_,
                                        trans_reval_event_id_,
                                        transfer_trans_tab_);
      END IF;

      -- If part id changes have been made revaluation should continue with the receipt
      -- transaction for the new part
      IF (part_change_trans_tab_.COUNT > 0) THEN
         Process_Part_Changes___(revaluation_is_impossible_,
                                 transaction_update_counter_,
                                 company_,
                                 trans_reval_event_id_,
                                 part_change_trans_tab_);
      END IF;

      -- If any shop order issues have been updated we should initiate the
      -- casacade updates for these orders as well
      IF (NOT revaluation_is_impossible_) AND (shop_ord_ref_tab_.COUNT > 0) THEN
         Process_Updated_Shop_Orders___(shop_ord_ref_tab_, trans_reval_event_id_);
      END IF;
   END IF;
EXCEPTION
   WHEN exit_procedure_ THEN
      NULL;
END Revalue_Part_Transactions___;


-- Revalue_All_Serial_Trans___
--   Find all serials connected to the specified Purchase or Shop Order
--   receipt and initiate a revaluation process for each serial found
PROCEDURE Revalue_All_Serial_Trans___ (
   revaluation_is_impossible_   IN OUT BOOLEAN,
   transaction_update_counter_  IN OUT NUMBER,
   order_ref1_                  IN     VARCHAR2,
   order_ref2_                  IN     VARCHAR2,
   order_ref3_                  IN     VARCHAR2,
   order_ref4_                  IN     NUMBER,
   order_type_db_               IN     VARCHAR2,
   contract_                    IN     VARCHAR2,
   part_no_                     IN     VARCHAR2,
   receipt_cost_                IN     NUMBER,
   invoice_price_               IN     NUMBER,
   cost_detail_tab_             IN     Inventory_Part_Unit_Cost_API.Cost_Detail_Tab,
   company_                     IN     VARCHAR2,
   first_viable_posting_date_   IN     DATE,
   trans_reval_event_id_        IN     NUMBER,
   receipt_curr_code_           IN     VARCHAR2 DEFAULT NULL,
   invoice_curr_code_           IN     VARCHAR2 DEFAULT NULL,
   avg_inv_price_in_inv_curr_   IN     NUMBER DEFAULT NULL,
   avg_chg_value_in_inv_curr_   IN     NUMBER DEFAULT NULL,
   unit_cost_in_receipt_curr_   IN     NUMBER DEFAULT NULL )
IS
   -- 86118 Added condition for qty_reversed = 0
   -- Only retrieve serials for which a receipt that has not been reversed exists
   -- If a recipt has been cancelled and the serial on that receipt has then been 
   -- scrapped this receipt will not have to be considered
   CURSOR find_serial_receipts IS
      SELECT DISTINCT(serial_no)
      FROM  INVENTORY_TRANSACTION_HIST_TAB a, mpccom_transaction_code_pub b
      WHERE source_ref1  = order_ref1_
      AND   source_ref2  = order_ref2_
      AND   source_ref3  = order_ref3_
      AND   ((source_ref4 IS NULL) OR (source_ref4 = order_ref4_))
      AND   source_ref_type    = order_type_db_
      AND   contract           = contract_
      AND   part_no            = part_no_
      AND   qty_reversed       = 0
      AND   a.transaction_code = b.transaction_code
      AND   trans_based_reval_group_db IN ('MANUFACTURING RECEIPT',
                                           'PURCHASE ORDER RECEIPT',
                                           'ESO COMPONENT RECEIPT',
                                           'EXTERNAL RECEIPT',
                                           'RECEIPT CONS STOCK',
                                           'RMA DIRECT RETURNS');

BEGIN
   FOR next_serial_ IN find_serial_receipts LOOP
      -- Revalue all transactions made for this serial from the receipt
      Start_Revalue_Serial_Trans___(revaluation_is_impossible_  => revaluation_is_impossible_,
                                    transaction_update_counter_ => transaction_update_counter_,
                                    order_ref1_                 => order_ref1_,
                                    order_ref2_                 => order_ref2_,
                                    order_ref3_                 => order_ref3_,
                                    order_ref4_                 => order_ref4_,
                                    order_type_db_              => order_type_db_,
                                    contract_                   => contract_,
                                    part_no_                    => part_no_,
                                    serial_no_                  => next_serial_.serial_no,
                                    receipt_cost_               => receipt_cost_,
                                    invoice_price_              => invoice_price_,
                                    cost_detail_tab_            => cost_detail_tab_,
                                    company_                    => company_,
                                    first_viable_posting_date_  => first_viable_posting_date_,
                                    connected_receipt_trans_id_ => NULL,
                                    trans_reval_event_id_       => trans_reval_event_id_,
                                    receipt_curr_code_          => receipt_curr_code_,
                                    invoice_curr_code_          => invoice_curr_code_,
                                    avg_inv_price_in_inv_curr_  => avg_inv_price_in_inv_curr_,
                                    avg_chg_value_in_inv_curr_  => avg_chg_value_in_inv_curr_,
                                    unit_cost_in_receipt_curr_  => unit_cost_in_receipt_curr_);

      EXIT WHEN (revaluation_is_impossible_);
   END LOOP;
END Revalue_All_Serial_Trans___;


-- Start_Revalue_Serial_Trans___
--   Entry point for starting the casacade revaluation of serial transactions.
--   If the revaluation job runs into a repair order receipt this method
--   will be called again to start a new revaluation of transactions
--   for the serial that was received on the repair order. In this case
--   the part/serial received back could be different then the part/serial
--   that was being sent for repair.
PROCEDURE Start_Revalue_Serial_Trans___ (
   revaluation_is_impossible_   IN OUT BOOLEAN,
   transaction_update_counter_  IN OUT NUMBER,
   order_ref1_                  IN     VARCHAR2,
   order_ref2_                  IN     VARCHAR2,
   order_ref3_                  IN     VARCHAR2,
   order_ref4_                  IN     NUMBER,
   order_type_db_               IN     VARCHAR2,
   contract_                    IN     VARCHAR2,
   part_no_                     IN     VARCHAR2,
   serial_no_                   IN     VARCHAR2,
   receipt_cost_                IN     NUMBER,
   invoice_price_               IN     NUMBER,
   cost_detail_tab_             IN     Inventory_Part_Unit_Cost_API.Cost_Detail_Tab,
   company_                     IN     VARCHAR2,
   first_viable_posting_date_   IN     DATE,
   connected_receipt_trans_id_  IN     NUMBER,
   trans_reval_event_id_        IN     NUMBER,
   receipt_curr_code_           IN     VARCHAR2 DEFAULT NULL,
   invoice_curr_code_           IN     VARCHAR2 DEFAULT NULL,
   avg_inv_price_in_inv_curr_   IN     NUMBER DEFAULT NULL,
   avg_chg_value_in_inv_curr_   IN     NUMBER DEFAULT NULL,
   unit_cost_in_receipt_curr_   IN     NUMBER DEFAULT NULL )
IS
   process_completed_             BOOLEAN := FALSE;
   component_cost_extern_service_ BOOLEAN := FALSE;
   process_order_ref1_            INVENTORY_TRANSACTION_HIST_TAB.source_ref1%TYPE;
   process_order_ref2_            INVENTORY_TRANSACTION_HIST_TAB.source_ref2%TYPE;
   process_order_ref3_            INVENTORY_TRANSACTION_HIST_TAB.source_ref3%TYPE;
   process_order_ref4_            INVENTORY_TRANSACTION_HIST_TAB.source_ref4%TYPE;
   process_order_type_db_         INVENTORY_TRANSACTION_HIST_TAB.source_ref_type%TYPE;
   process_contract_              INVENTORY_TRANSACTION_HIST_TAB.contract%TYPE;
   input_contract_                INVENTORY_TRANSACTION_HIST_TAB.contract%TYPE;
   process_part_no_               INVENTORY_TRANSACTION_HIST_TAB.part_no%TYPE;
   configuration_id_              INVENTORY_TRANSACTION_HIST_TAB.configuration_id%TYPE;
   process_serial_no_             INVENTORY_TRANSACTION_HIST_TAB.serial_no%TYPE;
   process_receipt_cost_          NUMBER;
   process_invoice_price_         NUMBER;
   process_cost_detail_tab_       Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   quantity_                      NUMBER;
   process_company_               VARCHAR2(20);
   process_viable_posting_date_   DATE;
   process_receipt_trans_id_      NUMBER;
BEGIN

   process_order_ref1_          := order_ref1_;
   process_order_ref2_          := order_ref2_;
   process_order_ref3_          := order_ref3_;
   process_order_ref4_          := order_ref4_;
   process_order_type_db_       := order_type_db_;
   process_contract_            := contract_;
   process_part_no_             := part_no_;
   process_serial_no_           := serial_no_;
   process_receipt_cost_        := receipt_cost_;
   process_invoice_price_       := invoice_price_;
   process_company_             := company_;
   process_viable_posting_date_ := first_viable_posting_date_;
   process_cost_detail_tab_     := cost_detail_tab_;
   process_receipt_trans_id_    := connected_receipt_trans_id_;

   LOOP
      input_contract_ := process_contract_;

      Revalue_Serial_Transactions___(revaluation_is_impossible_,
                                     process_completed_,
                                     process_order_ref1_,
                                     process_order_ref2_,
                                     process_order_ref3_,
                                     process_order_ref4_,
                                     process_order_type_db_,
                                     process_contract_,
                                     process_part_no_,
                                     configuration_id_,
                                     process_serial_no_,
                                     process_receipt_cost_,
                                     process_invoice_price_,
                                     process_cost_detail_tab_,
                                     quantity_,
                                     process_company_,
                                     component_cost_extern_service_,
                                     process_receipt_trans_id_,
                                     transaction_update_counter_,
                                     trans_reval_event_id_,
                                     receipt_curr_code_,
                                     invoice_curr_code_,
                                     avg_inv_price_in_inv_curr_,
                                     avg_chg_value_in_inv_curr_,
                                     unit_cost_in_receipt_curr_,
                                     process_viable_posting_date_);

      EXIT WHEN (process_completed_ OR revaluation_is_impossible_);

      IF (process_contract_ != input_contract_) THEN
         -- If the execution inside Revalue_Serial_Transactions___ has detected that the serial has crossed a site-border then the value of process_contract_
         -- has changed and we need to fetch a new value for process_viable_posting_date_ before making a new call in the loop.
         process_viable_posting_date_ := Site_Invent_Info_API.Get_First_Viable_Posting_Date(process_contract_);
      END IF;
   END LOOP;

END Start_Revalue_Serial_Trans___;


-- Revalue_Serial_Transactions___
--   Find all transactions for the specified serial number starting with the
--   specified Purchase or Shop Order receipt and start a cascade update
--   of the transactions found.
--   The new transaction value can be passed to this method either in the
--   cost_detail_tab_ parameter (for SO updates) or as receipt_cost_
--   and invoice_price_ (for PO updates)
--   A special case is when the revaluation job has hit an intersite transfer
--   or a part renaming issue and the revaluation should continue with the
--   receipt transaction on the receiving site or with receipt of the renamed part
--   In this case a value for connected_receipt_trans_id_ should be passed instead
--   of a reference to an order.
--   Another special case is when a serial has been renamed
PROCEDURE Revalue_Serial_Transactions___ (
   revaluation_is_impossible_     IN OUT BOOLEAN,
   process_completed_             IN OUT BOOLEAN,
   order_ref1_                    IN OUT VARCHAR2,
   order_ref2_                    IN OUT VARCHAR2,
   order_ref3_                    IN OUT VARCHAR2,
   order_ref4_                    IN OUT NUMBER,
   order_type_db_                 IN OUT VARCHAR2,
   contract_                      IN OUT VARCHAR2,
   part_no_                       IN OUT VARCHAR2,
   configuration_id_              IN OUT VARCHAR2,
   serial_no_                     IN OUT VARCHAR2,
   receipt_cost_                  IN OUT NUMBER,
   invoice_price_                 IN OUT NUMBER,
   cost_detail_tab_               IN OUT Inventory_Part_Unit_Cost_API.Cost_Detail_Tab,
   quantity_                      IN OUT NUMBER,
   company_                       IN OUT VARCHAR2,
   component_cost_extern_service_ IN OUT BOOLEAN,
   connected_receipt_trans_id_    IN OUT NUMBER,
   transaction_update_counter_    IN OUT NUMBER,
   trans_reval_event_id_          IN     NUMBER,
   receipt_curr_code_             IN     VARCHAR2,
   invoice_curr_code_             IN     VARCHAR2,
   avg_inv_price_in_inv_curr_     IN     NUMBER,
   avg_chg_value_in_inv_curr_     IN     NUMBER,
   unit_cost_in_receipt_curr_     IN     NUMBER,
   first_viable_posting_date_     IN     DATE )
IS
   first_receipt_transaction_id_ NUMBER;
   next_receipt_transaction_id_  NUMBER;
   transaction_is_next_receipt_  BOOLEAN := FALSE;
   serial_has_been_renamed_      BOOLEAN := FALSE;
   part_has_been_renamed_        BOOLEAN := FALSE;
   continue_with_comp_receipt_   BOOLEAN := FALSE;
   find_service_cost_trans_      NUMBER;
   serviced_part_receipt_trans_  INVENTORY_TRANSACTION_HIST_TAB%ROWTYPE;
   tran_code_rec_                Mpccom_Transaction_Code_API.Public_Rec;
   transaction_type_             VARCHAR2(50);
   previous_transaction_type_    VARCHAR2(50);
   shop_ord_ref_tab_             Shop_Ord_Ref_Tab;
   transferred_to_other_site_    BOOLEAN := FALSE;
   connected_trans_id_           NUMBER;
   connected_trans_rec_          Inventory_Transaction_Hist_API.Public_Rec;
   serial_manually_revaluated_   BOOLEAN := FALSE;
   cost_detail_diff_tab_         Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   part_catalog_rec_             Part_Catalog_API.Public_Rec;
   connected_trans_inv_rec_      Inventory_Part_API.Public_Rec;
   date_applied_                 DATE;

   CURSOR get_transactions IS
      SELECT transaction_id, transaction_code, original_transaction_id,
             accounting_id, configuration_id, quantity, source_ref1, source_ref2,
             source_ref3, source_ref4, source_ref_type, activity_seq,
             inventory_valuation_method, inventory_part_cost_level, lot_batch_no, date_applied
      FROM   INVENTORY_TRANSACTION_HIST_TAB
      WHERE  contract        = contract_
      AND    part_no         = part_no_
      AND    serial_no       = serial_no_
      AND    transaction_id >= first_receipt_transaction_id_
      ORDER BY transaction_id;
BEGIN

   IF (component_cost_extern_service_) THEN
      find_service_cost_trans_ := 0;
   ELSE
      find_service_cost_trans_ := 1;
   END IF;

   IF (connected_receipt_trans_id_ IS NOT NULL) THEN
      -- We are continuing with an update that was started on another site or for
      -- a new serial number or part that replaces one that has been renamed.
      first_receipt_transaction_id_ := connected_receipt_trans_id_;
   ELSIF (order_type_db_ = 'PUR ORDER') THEN
      first_receipt_transaction_id_ := Get_PO_Receipt_Trans_Id___(order_ref1_,
                                                                  order_ref2_,
                                                                  order_ref3_,
                                                                  order_ref4_,
                                                                  order_type_db_,
                                                                  contract_,
                                                                  part_no_,
                                                                  serial_no_,
                                                                  find_service_cost_trans_);
   ELSIF (order_type_db_ = 'SHOP ORDER') THEN
      -- In this case first receipt transaction should be the first non-cancelled receipt i.e. the last receipt made
      -- on the specified order for the specified serial
      first_receipt_transaction_id_ := Get_SO_Receipt_Trans_Id___(order_ref1_,
                                                                  order_ref2_,
                                                                  order_ref3_,
                                                                  order_type_db_,
                                                                  contract_,
                                                                  part_no_,
                                                                  serial_no_);
   ELSE
      Error_SYS.Record_General(lu_name_,'FATALDESERROR: Fatal design time error');
   END IF;
   
   Inventory_Part_Unit_Cost_API.Lock_By_Keys_Wait(contract_, 
                                                  part_no_, 
                                                  '*', 
                                                  '*',
                                                  '*');

   part_catalog_rec_ := Part_Catalog_API.Get(part_no_);
   
   FOR next_trans_ IN get_transactions LOOP
      tran_code_rec_    := Mpccom_Transaction_Code_API.Get(next_trans_.transaction_code);
      transaction_type_ := tran_code_rec_.trans_based_reval_group;
      date_applied_     := GREATEST(first_viable_posting_date_, next_trans_.date_applied);

      IF (next_trans_.transaction_id = first_receipt_transaction_id_) THEN
         IF (configuration_id_ IS NULL) THEN
            configuration_id_ := next_trans_.configuration_id;
            quantity_         := next_trans_.quantity;
         END IF;
      ELSE
         transaction_is_next_receipt_ := Transaction_Is_Next_Receipt___(transaction_type_,
                                                                        previous_transaction_type_);
         EXIT WHEN (transaction_is_next_receipt_);
      END IF;

      revaluation_is_impossible_ := Serial_Reval_Is_Impossible___(next_trans_.inventory_valuation_method,
                                                                  next_trans_.inventory_part_cost_level,
                                                                  transaction_type_);
      EXIT WHEN (revaluation_is_impossible_);

      IF NOT (Skip_Cost_Update___(transaction_type_)) THEN
         Revalue_Serial_Transaction___(cost_detail_tab_,
                                       cost_detail_diff_tab_,
                                       next_trans_.source_ref1,
                                       contract_,
                                       company_,
                                       transaction_type_,
                                       next_trans_.transaction_id,
                                       next_trans_.accounting_id,
                                       next_trans_.original_transaction_id,
                                       receipt_cost_,
                                       invoice_price_,
                                       date_applied_,
                                       trans_reval_event_id_,
                                       receipt_curr_code_,
                                       invoice_curr_code_,
                                       avg_inv_price_in_inv_curr_,
                                       avg_chg_value_in_inv_curr_,
                                       unit_cost_in_receipt_curr_);
         Increase___ (transaction_update_counter_);
      END IF;

      IF (Shop_Order_Material_Issue___(transaction_type_)) THEN
         IF (((part_catalog_rec_.lot_tracking_code  = 'NOT LOT TRACKING') AND (next_trans_.lot_batch_no != '*')) OR
             ((part_catalog_rec_.lot_tracking_code != 'NOT LOT TRACKING') AND (next_trans_.lot_batch_no  = '*'))) THEN
            revaluation_is_impossible_ := TRUE;
         ELSE
            -- Add the new shop order to the list for later processing
            Add_Shop_Order_To_List___(shop_ord_ref_tab_,
                                      next_trans_.source_ref1,
                                      next_trans_.source_ref2,
                                      next_trans_.source_ref3);
         END IF;
      ELSIF ((Shipped_To_Supplier___(transaction_type_)) OR
          (Consign_Shipped_To_Supplier___(transaction_type_))) THEN

         IF (Received_Back_From_Supplier___(next_receipt_transaction_id_,
                                            next_trans_.source_ref1,
                                            next_trans_.source_ref2,
                                            next_trans_.source_ref3,
                                            next_trans_.source_ref_type)) THEN

            IF (External_Service_Order_Line___(next_trans_.source_ref1,
                                               next_trans_.source_ref2,
                                               next_trans_.source_ref3)) THEN

               Decide_Progress_Alternative___(serviced_part_receipt_trans_,
                                              continue_with_comp_receipt_,
                                              revaluation_is_impossible_,
                                              cost_detail_tab_,
                                              cost_detail_diff_tab_,
                                              next_receipt_transaction_id_,
                                              part_no_);
               EXIT WHEN (continue_with_comp_receipt_);
            ELSE
               revaluation_is_impossible_ := TRUE;
            END IF;
            EXIT WHEN (revaluation_is_impossible_);
         END IF;
      ELSIF ((Shipped_To_Intern_Customer___(transaction_type_)) OR
             (Intersite_Transfer_Issue___(transaction_type_)) OR
             (Rma_Direct_Return___(transaction_type_))) THEN
         transferred_to_other_site_ := TRUE;
         connected_trans_id_ := Invent_Trans_Interconnect_API.Get_Connected_Transaction_Id(
                                                                  next_trans_.transaction_id,
                                                                  'INTERSITE TRANSFER');
         EXIT;
      ELSIF ((Inventory_Value_Increase___(transaction_type_)) OR
             (Inventory_Value_Decrease___(transaction_type_))) THEN
         -- The serial has been manually revaluated.
         -- The value set by the revaluation should be kept, we only update
         -- transactions up to this point.
         serial_manually_revaluated_:= TRUE;
         EXIT;
      ELSIF (Transaction_Renames_Part___(transaction_type_)) THEN
         part_has_been_renamed_ := TRUE;
         connected_trans_id_ := Invent_Trans_Interconnect_API.Get_Connected_Transaction_Id(
                                                                 next_trans_.transaction_id,
                                                                 'RENAME SERIAL');
         EXIT;
      ELSIF (Transaction_Renames_Serial___(transaction_type_)) THEN
         serial_has_been_renamed_ := TRUE;
         connected_trans_id_ := Invent_Trans_Interconnect_API.Get_Connected_Transaction_Id(
                                                                 next_trans_.transaction_id,
                                                                 'RENAME SERIAL');
         EXIT;
      END IF;

      previous_transaction_type_ := transaction_type_;

      IF (NVL(next_trans_.activity_seq,0) > 0) THEN
         Project_Refresh_Accounting_API.New(next_trans_.accounting_id, contract_, 'INVENTORY');
      END IF;
   END LOOP;

   Inventory_Transaction_Hist_API.Refresh_Activity_Info(contract_);

   IF (revaluation_is_impossible_) THEN
      process_completed_ := TRUE;
   ELSIF (serial_has_been_renamed_) THEN
      process_completed_ := FALSE;
      order_ref1_        := NULL;
      order_ref2_        := NULL;
      order_ref3_        := NULL;
      order_ref4_        := NULL;
      order_type_db_     := NULL;

      connected_receipt_trans_id_ := connected_trans_id_;
      -- serial_no_         := Part_Serial_Catalog_API.Get_Renamed_To_Serial_No(part_no_,
      --                                                                        serial_no_);

      -- Retrive the new serial number from the connected transaction
      -- to continue the process using that instead.
      connected_trans_rec_ := Inventory_Transaction_Hist_API.Get(connected_trans_id_);
      serial_no_ := connected_trans_rec_.serial_no;
   ELSIF (part_has_been_renamed_) THEN
      -- Part number has been changed, no more transactions for this part number and
      -- serial no. Continue with the renamed-to part and serial no
      connected_trans_rec_ := Inventory_Transaction_Hist_API.Get(connected_trans_id_);

      IF ((connected_trans_rec_.inventory_valuation_method = 'AV') OR
          ((connected_trans_rec_.inventory_valuation_method = 'ST') AND
           (connected_trans_rec_.inventory_part_cost_level = 'COST PER SERIAL'))) THEN

         -- The cascade update should continue with the new part number

         IF (connected_trans_rec_.inventory_valuation_method = 'AV') THEN
            -- The other site uses valuation method weighted average
            Revalue_Part_Transactions___(revaluation_is_impossible_  => revaluation_is_impossible_,
                                         transaction_update_counter_ => transaction_update_counter_,
                                         order_ref1_                 => NULL,
                                         order_ref2_                 => NULL,
                                         order_ref3_                 => NULL,
                                         order_ref4_                 => NULL,
                                         order_type_db_              => NULL,
                                         contract_                   => contract_,
                                         part_no_                    => connected_trans_rec_.part_no,
                                         receipt_cost_               => NULL,
                                         invoice_price_              => NULL,
                                         company_                    => company_,
                                         first_viable_posting_date_  => first_viable_posting_date_,
                                         cost_detail_tab_            => cost_detail_tab_,
                                         connected_receipt_trans_id_ => connected_trans_id_,
                                         trans_reval_event_id_       => trans_reval_event_id_);

            -- We are finished wih the serial revaluation process
            process_completed_:= TRUE;
         ELSE
            -- The new part is also is setup to use 'COST PER SERIAL'
            order_ref1_                 := NULL;
            order_ref2_                 := NULL;
            order_ref3_                 := NULL;
            order_ref4_                 := NULL;
            order_type_db_              := NULL;
            contract_                   := contract_;
            part_no_                    := connected_trans_rec_.part_no;
            serial_no_                  := connected_trans_rec_.serial_no;
            receipt_cost_               := NULL;
            invoice_price_              := NULL;
            connected_receipt_trans_id_ := connected_trans_id_;
            process_completed_ := FALSE;
         END IF;
      ELSE
         process_completed_ := TRUE;
      END IF;
   ELSIF (continue_with_comp_receipt_) THEN
      IF (contract_ != serviced_part_receipt_trans_.contract) THEN
         company_ := Site_API.Get_Company(serviced_part_receipt_trans_.contract);
      END IF;

      order_ref1_                    := serviced_part_receipt_trans_.source_ref1;
      order_ref2_                    := serviced_part_receipt_trans_.source_ref2;
      order_ref3_                    := serviced_part_receipt_trans_.source_ref3;
      order_ref4_                    := serviced_part_receipt_trans_.source_ref4;
      order_type_db_                 := serviced_part_receipt_trans_.source_ref_type;
      contract_                      := serviced_part_receipt_trans_.contract;
      part_no_                       := serviced_part_receipt_trans_.part_no;
      serial_no_                     := serviced_part_receipt_trans_.serial_no;
      receipt_cost_                  := NULL;
      invoice_price_                 := NULL;
      component_cost_extern_service_ := TRUE;
      process_completed_             := FALSE;
   ELSIF (transferred_to_other_site_) THEN
      -- No more transactions on this site, change the serial cost
      Inventory_Part_Unit_Cost_API.Find_And_Modify_Serial_Cost(contract_,
                                                               part_no_,
                                                               serial_no_,
                                                               cost_detail_tab_,
                                                               FALSE);
      connected_trans_rec_ := Inventory_Transaction_Hist_API.Get(connected_trans_id_);

      IF ((connected_trans_rec_.inventory_valuation_method = 'AV') OR
          ((connected_trans_rec_.inventory_valuation_method = 'ST') AND
           (connected_trans_rec_.inventory_part_cost_level = 'COST PER SERIAL'))) THEN
         -- The cascade update should continue on the receiving site
         -- Transform cost details to corresponding details on the receiving site
         cost_detail_tab_ := Inventory_Part_In_Stock_API.Transform_Cost_Details(
                                                   contract_,
                                                   cost_detail_tab_,
                                                   connected_trans_rec_.contract,
                                                   connected_trans_rec_.inventory_valuation_method,
                                                   connected_trans_rec_.inventory_part_cost_level);

         connected_trans_inv_rec_ := Inventory_Part_API.Get(connected_trans_rec_.part_no, connected_trans_rec_.contract);
         IF (connected_trans_inv_rec_.inventory_valuation_method = 'AV') THEN
            -- The other site uses valuation method weighted average
            Revalue_Part_Transactions___(revaluation_is_impossible_  => revaluation_is_impossible_,
                                         transaction_update_counter_ => transaction_update_counter_,
                                         order_ref1_                 => NULL,
                                         order_ref2_                 => NULL,
                                         order_ref3_                 => NULL,
                                         order_ref4_                 => NULL,
                                         order_type_db_              => NULL,
                                         contract_                   => connected_trans_rec_.contract,
                                         part_no_                    => part_no_,
                                         receipt_cost_               => NULL,
                                         invoice_price_              => NULL,
                                         company_                    => company_,
                                         first_viable_posting_date_  => Site_Invent_Info_API.Get_First_Viable_Posting_Date(connected_trans_rec_.contract),
                                         cost_detail_tab_            => cost_detail_tab_,
                                         connected_receipt_trans_id_ => connected_trans_id_,
                                         trans_reval_event_id_       => trans_reval_event_id_);

            -- We are finished wih the serial revaluation process
            process_completed_:= TRUE;
         ELSE
            -- The other site also is setup to use 'COST PER SERIAL'
            order_ref1_                 := NULL;
            order_ref2_                 := NULL;
            order_ref3_                 := NULL;
            order_ref4_                 := NULL;
            order_type_db_              := NULL;
            contract_                   := connected_trans_rec_.contract;
            receipt_cost_               := NULL;
            invoice_price_              := NULL;
            connected_receipt_trans_id_ := connected_trans_id_;
            process_completed_ := FALSE;
         END IF;
      ELSE
         process_completed_ := TRUE;
      END IF;
   ELSIF (transaction_is_next_receipt_) THEN
      process_completed_ := TRUE;
   ELSIF (serial_manually_revaluated_) THEN
      -- In this case the Part Unit Cost should not be updated
      process_completed_ := TRUE;
   ELSE
      process_completed_ := TRUE;
      Inventory_Part_Unit_Cost_API.Find_And_Modify_Serial_Cost(contract_,
                                                               part_no_,
                                                               serial_no_,
                                                               cost_detail_tab_,
                                                               FALSE);
   END IF;

   -- If any shop order issues have been updated we should initiate the
   -- casacade updates for these orders as well
   IF ((NOT revaluation_is_impossible_) AND
       (shop_ord_ref_tab_.COUNT > 0)) THEN
      Process_Updated_Shop_Orders___(shop_ord_ref_tab_, trans_reval_event_id_);
   END IF;
END Revalue_Serial_Transactions___;


-- Revalue_Serial_Transaction___
--   Revalue one transaction for a serial part. Also executes any pre and
--   post revaluation actions that might be needed.
--   This method changes the cost of one specific inventory transaction history
--   record, and then it initiates the creation of additional postings in
--   MpccomAccounting in order to adjust the posting for this specific transaction.
PROCEDURE Revalue_Serial_Transaction___ (
   new_serial_cost_detail_tab_  IN OUT Inventory_Part_Unit_Cost_API.Cost_Detail_Tab,
   cost_detail_diff_tab_        IN OUT Inventory_Part_Unit_Cost_API.Cost_Detail_Tab,
   order_ref1_                  IN VARCHAR2,
   contract_                    IN VARCHAR2,
   company_                     IN VARCHAR2,
   transaction_type_            IN VARCHAR2,
   transaction_id_              IN NUMBER,
   accounting_id_               IN NUMBER,
   original_transaction_id_     IN NUMBER,
   receipt_cost_                IN NUMBER,
   invoice_price_               IN NUMBER,
   date_applied_                IN DATE,
   trans_reval_event_id_        IN NUMBER,
   receipt_curr_code_           IN VARCHAR2,
   invoice_curr_code_           IN VARCHAR2,
   avg_inv_price_in_inv_curr_   IN NUMBER,
   avg_chg_value_in_inv_curr_   IN NUMBER,
   unit_cost_in_receipt_curr_   IN NUMBER )
IS
   org_trans_cost_detail_tab_ Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   new_trans_cost_detail_tab_ Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   dummy_cost_detail_tab_     Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   trans_rec_                 Inventory_Transaction_Hist_API.Public_Rec;
   old_wip_sum_value_         NUMBER;
   reval_factor_              NUMBER;
   repair_service_cost_receipt_ BOOLEAN;
   
BEGIN

   Make_Add_Pre_Reval_Actions___(old_wip_sum_value_, accounting_id_, transaction_type_);
   IF (Repair_Service_Cost_Arrival___(transaction_type_)) THEN
      repair_service_cost_receipt_ := FALSE;
   END IF;
   IF (repair_service_cost_receipt_ OR original_transaction_id_ IS NULL) THEN
      trans_rec_ := Inventory_Transaction_Hist_API.Get(transaction_id_);
   END IF;
      
   IF (repair_service_cost_receipt_) THEN
      -- For a Repair Order service cost arrival the cost should be set to the invoiced price.
      -- In this case the value of the repaired part should not be included
     -- arr_repair_trans_rec_ := Inventory_Transaction_Hist_API.Get(transaction_id_);

      Inventory_Transaction_Hist_API.Get_External_Service_Costs(
                                     comp_cost_detail_tab_    => dummy_cost_detail_tab_,
                                     service_cost_detail_tab_ => new_trans_cost_detail_tab_,
                                     source_ref_1_            => trans_rec_.source_ref1,
                                     source_ref_2_            => trans_rec_.source_ref2,
                                     source_ref_3_            => trans_rec_.source_ref3,
                                     service_cost_            => invoice_price_,
                                     include_service_cost_    => TRUE,
                                     contract_                => trans_rec_.contract);

      Inventory_Transaction_Hist_API.Set_Cost(transaction_id_, new_trans_cost_detail_tab_);

   ELSIF ((Inventory_Value_Increase___(transaction_type_)) OR
          (Inventory_Value_Decrease___(transaction_type_))) THEN
      -- Update the cost details of the revaluation transaction so that the resulting
      -- value after the revaluation is the same as before
      IF (Inventory_Value_Decrease___(transaction_type_)) THEN
         reval_factor_ := 1;
      ELSE
         reval_factor_:= -1;
      END IF;
      org_trans_cost_detail_tab_ := Inventory_Transaction_Cost_API.Get_Transaction_Cost_Details(transaction_id_);

      -- Remove the diff added to previous transactions from the revaluation transaction
      new_serial_cost_detail_tab_ :=
         Inventory_Part_Unit_Cost_API.Add_To_Value_Detail_Tab(org_trans_cost_detail_tab_,
                                                              cost_detail_diff_tab_,
                                                              reval_factor_);
      Inventory_Transaction_Hist_API.Set_Cost(transaction_id_, new_serial_cost_detail_tab_);

   ELSIF (Posting_Cost_Group_Change___(transaction_type_)) THEN
            Revalue_Cost_Group_Change___(transaction_id_,
                                         new_serial_cost_detail_tab_,
                                         company_,
                                         date_applied_,
                                         trans_reval_event_id_);
   ELSE
      -- For normal transactions the cost should be set to
      -- receipt_cost_ = (invoiced_price + exchange_cost)

      -- Get the current cost details before they are updated so that a
      -- diff can be calculated
      IF (cost_detail_diff_tab_.COUNT = 0) THEN
         org_trans_cost_detail_tab_ := Inventory_Transaction_Cost_API.Get_Transaction_Cost_Details(transaction_id_);
      END IF;
      --
      -- Update the transaction cost
      --
      IF (new_serial_cost_detail_tab_.COUNT = 0) THEN
         Inventory_Transaction_Hist_API.Recalc_Cost_On_Price_Update(new_serial_cost_detail_tab_,
                                                                    transaction_id_,
                                                                    receipt_cost_);
      ELSE
         Inventory_Transaction_Hist_API.Set_Cost(transaction_id_, new_serial_cost_detail_tab_);
      END IF;

      IF (cost_detail_diff_tab_.COUNT = 0)  THEN
         -- Calculate the diff that is being applied to the transactions
         -- updated. This might be needed in case we run into a revaluation
         -- transaction later on
         cost_detail_diff_tab_ :=
            Inventory_Part_Unit_Cost_API.Add_To_Value_Detail_Tab(new_serial_cost_detail_tab_,
                                                                 org_trans_cost_detail_tab_,
                                                                 -1);
      END IF;
   END IF;

   IF (original_transaction_id_ IS NULL) THEN
      Do_Value_Adjustment_Booking___(transaction_id_, company_, date_applied_, trans_reval_event_id_);
      IF ((receipt_curr_code_ IS NOT NULL AND invoice_curr_code_ IS NOT NULL) AND
         (Purchase_Order_Arrival___(transaction_type_) OR 
          Return_To_Supplier___(transaction_type_) OR
          Rma_Direct_Return___(transaction_type_))) THEN
         -- currency diff postings needs to be posted with the posting events which are having connection with currency revaluation account.
         -- Also to post the currency diff it is necessay to have the values for receipt_curr_code_ and invoice_curr_code_.
         Mpccom_Accounting_API.Do_Curr_Amt_Balance_Posting(company_                   => company_,
                                                           accounting_id_             => accounting_id_,
                                                           contract_                  => contract_,
                                                           quantity_arrived_          => 1,
                                                           trans_reval_event_id_      => trans_reval_event_id_,
                                                           receipt_curr_code_         => receipt_curr_code_,
                                                           invoice_curr_code_         => invoice_curr_code_,
                                                           avg_inv_price_in_inv_curr_ => avg_inv_price_in_inv_curr_,
                                                           avg_chg_value_in_inv_curr_ => avg_chg_value_in_inv_curr_,
                                                           unit_cost_in_receipt_curr_ => unit_cost_in_receipt_curr_,
                                                           date_posted_               => date_applied_);
      END IF;                                                     
   ELSE
      Inventory_Transaction_Hist_API.Reverse_Accounting(transaction_id_,
                                                        original_transaction_id_,
                                                        value_adjustment_     => TRUE,
                                                        per_oh_adjustment_id_ => NULL,
                                                        trans_reval_event_id_ => trans_reval_event_id_,
                                                        date_applied_         => date_applied_);
   END IF;

   Make_Add_Post_Reval_Actions___(order_ref1_,
                                  company_,
                                  transaction_type_,
                                  accounting_id_,
                                  old_wip_sum_value_,
                                  trans_reval_event_id_);
END Revalue_Serial_Transaction___;


-- Purchase_Order_Arrival___
--   Decides if this is a transaction that performs purchase order arrival.
FUNCTION Purchase_Order_Arrival___ (
   transaction_type_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   purchase_order_receipt_ BOOLEAN := FALSE;
BEGIN
   IF (transaction_type_ IN ('PURCHASE ORDER RECEIPT', 'ESO COMPONENT RECEIPT')) THEN
      purchase_order_receipt_ := TRUE;
   END IF;
   RETURN (purchase_order_receipt_);
END Purchase_Order_Arrival___;


FUNCTION Manufacturing_Receipt___ (
   transaction_type_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   manufacturing_receipt_ BOOLEAN := FALSE;
BEGIN
   IF (transaction_type_ = 'MANUFACTURING RECEIPT') THEN
      manufacturing_receipt_ := TRUE;
   END IF;
   RETURN (manufacturing_receipt_);
END Manufacturing_Receipt___;


-- Transaction_Is_Next_Receipt___
--   This method looks at the direction, the inventory_stat_direction and
--   the part_tracing attributes for a given transaction_code in order to
--   determine if this is a receipt transaction.
FUNCTION Transaction_Is_Next_Receipt___ (
   transaction_type_          IN VARCHAR2,
   previous_transaction_type_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   transaction_is_next_receipt_ BOOLEAN := FALSE;
BEGIN
   IF (transaction_type_ IN ('RECEIPT',
                             'PURCHASE ORDER RECEIPT',
                             'RECEIPT CONS STOCK',
                             'MANUFACTURING RECEIPT',
                             'EXTERNAL RECEIPT',
                             'FIXED ASSET POOL RECEIPT')) THEN

      transaction_is_next_receipt_ := TRUE;

   ELSIF (transaction_type_ = 'ESO SERVICE COST RECEIPT') THEN
      IF (previous_transaction_type_ != 'ESO COMPONENT RECEIPT') THEN

         transaction_is_next_receipt_ := TRUE;
      END IF;
   ELSIF (transaction_type_ = 'ESO COMPONENT RECEIPT') THEN
      IF (previous_transaction_type_ != 'ESO SERVICE COST RECEIPT') THEN

         transaction_is_next_receipt_ := TRUE;
      END IF;
   END IF;
   RETURN (transaction_is_next_receipt_);
END Transaction_Is_Next_Receipt___;


-- Serial_Reval_Is_Impossible___
--   Returns TRUE if the transaction is impossible to revalue via
--   Transaction Based Invoice Consideration.
FUNCTION Serial_Reval_Is_Impossible___ (
   inventory_valuation_method_ IN VARCHAR2,
   inventory_part_cost_level_  IN VARCHAR2,
   transaction_type_           IN VARCHAR2 ) RETURN BOOLEAN
IS
   serial_reval_is_impossible_ BOOLEAN := FALSE;
BEGIN
   IF ((inventory_valuation_method_ != 'ST') OR
       (inventory_part_cost_level_  != 'COST PER SERIAL')) THEN
      serial_reval_is_impossible_ := TRUE;

   ELSIF (transaction_type_ IN ('REVALUATION IS IMPOSSIBLE',
                                'SUPPLIER EXCHANGE SHIPMENT',
                                'SUPPLIER EXCHANGE SHIPMENT CONS STOCK',
                                'SPLIT INTO SERIALS',
                                'CUSTOMER ORDER SHIPMENT RETAIN OWNERSHIP')) THEN
      serial_reval_is_impossible_ := TRUE;
   END IF;
   RETURN (serial_reval_is_impossible_);
END Serial_Reval_Is_Impossible___;


-- Part_Reval_Is_Impossible___
--   Decides if this is a transaction that makes it impossible to continue
--   the transaction based invoice revaluation for weighted average handled parts.
FUNCTION Part_Reval_Is_Impossible___ (
   transaction_type_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   part_reval_is_impossible_ BOOLEAN := FALSE;
BEGIN
   IF (transaction_type_ IN ('REVALUATION IS IMPOSSIBLE',
                             'OTHER CONS STOCK',
                             'MANUFACTURING VARIANCE',
                             'MANUFACTURING SCRAP',
                             'FIXED ASSET POOL RECEIPT',
                             'CUSTOMER ORDER SHIPMENT CONS STOCK',
                             'INTERNAL CUSTOMER ORDER SHIPMENT CONS STOCK',
                             'PROD SCHED MATERIAL ISSUE CONS STOCK',
                             'SHOP ORDER MATERIAL ISSUE CONS STOCK',
                             'SUPPLIER EXCHANGE SHIPMENT CONS STOCK',
                             'SERIAL RENAMING ISSUE CONS STOCK',
                             'RECEIPT CONS STOCK')) THEN
      part_reval_is_impossible_ := TRUE;
   END IF;
   RETURN (part_reval_is_impossible_);
END Part_Reval_Is_Impossible___;


-- Repair_Service_Cost_Arrival___
--   This method decides if a given transaction code is an arrival of a
--   repair order service cost purchase order line.
FUNCTION Repair_Service_Cost_Arrival___ (
   transaction_type_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   repair_service_cost_receipt_ BOOLEAN := FALSE;
BEGIN
   IF (transaction_type_ = 'ESO SERVICE COST RECEIPT') THEN
      repair_service_cost_receipt_ := TRUE;
   END IF;
   RETURN (repair_service_cost_receipt_);
END Repair_Service_Cost_Arrival___;


-- Skip_Cost_Update___
--   Returns TRUE if the transaction is marked as Skip Cost Update.
FUNCTION Skip_Cost_Update___ (
   transaction_type_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   skip_cost_update_ BOOLEAN := FALSE;
BEGIN
   IF (transaction_type_ IN ('SKIP COST UPDATE',
                             'DIR SHIP INTERNAL TRANSIT CUSTOMER ORDER')) THEN
      skip_cost_update_ := TRUE;
   END IF;
   RETURN (skip_cost_update_);
END Skip_Cost_Update___;


-- Shipped_To_Supplier___
--   Returns TRUE if the transaction is marked as Ship To Supplier.
FUNCTION Shipped_To_Supplier___ (
   transaction_type_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   shipped_to_supplier_ BOOLEAN := FALSE;
BEGIN
   IF (transaction_type_ IN ('SUPPLIER MATERIAL SHIPMENT',
                             'SUPPLIER EXCHANGE SHIPMENT')) THEN
      shipped_to_supplier_ := TRUE;
   END IF;
   RETURN (shipped_to_supplier_);
END Shipped_To_Supplier___;


-- Consign_Shipped_To_Supplier___
--   Decides if this is a transaction that ships supplier consignment
--   stock material to a supplier.
FUNCTION Consign_Shipped_To_Supplier___ (
   transaction_type_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   consign_shipped_to_supplier_ BOOLEAN := FALSE;
BEGIN
   IF (transaction_type_ IN ('SUPPLIER MATERIAL SHIPMENT CONS STOCK',
                             'SUPPLIER EXCHANGE SHIPMENT CONS STOCK')) THEN
      consign_shipped_to_supplier_ := TRUE;
   END IF;
   RETURN (consign_shipped_to_supplier_);
END Consign_Shipped_To_Supplier___;


-- Transaction_Renames_Serial___
--   This method looks at the transaction_code to determine if the serial
--   has been renamed to anther serial number while beeing in inventory.
FUNCTION Transaction_Renames_Serial___ (
   transaction_type_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   transaction_renames_serial_ BOOLEAN;
BEGIN
   IF (transaction_type_ IN ('SERIAL RENAMING ISSUE',
                             'SERIAL RENAMING ISSUE CONS STOCK')) THEN
      transaction_renames_serial_ := TRUE;
   ELSE
      transaction_renames_serial_ := FALSE;
   END IF;
   RETURN (transaction_renames_serial_);
END Transaction_Renames_Serial___;


FUNCTION Transaction_Renames_Part___ (
   transaction_type_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   transaction_renames_part_ BOOLEAN;
BEGIN
   IF (transaction_type_ = 'RENAME SERIAL - CHANGE PART NO - ISSUE') THEN
      transaction_renames_part_ := TRUE;
   ELSE
      transaction_renames_part_ := FALSE;
   END IF;
   RETURN (transaction_renames_part_);
END Transaction_Renames_Part___;


-- Shop_Order_Material_Issue___
--   This method decides id a given transaction code is a material issue
--   or unissue for a shop order.
FUNCTION Shop_Order_Material_Issue___ (
   transaction_type_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   shop_order_material_issue_ BOOLEAN := FALSE;
BEGIN
   IF (transaction_type_ IN ('SHOP ORDER MATERIAL ISSUE',
                             'SHOP ORDER MATERIAL ISSUE CONS STOCK')) THEN
      shop_order_material_issue_ := TRUE;
   END IF;
   RETURN (shop_order_material_issue_);
END Shop_Order_Material_Issue___;


-- Prod_Schedule_Mtrl_Issue___
--   This method decides id a given transaction code is a material issue
--   or unissue for a production schedule.
FUNCTION Prod_Schedule_Mtrl_Issue___ (
   transaction_type_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   prod_schedule_mtrl_issue_ BOOLEAN := FALSE;
BEGIN
   IF (transaction_type_ IN ('PRODUCTION SCHEDULE MATERIAL ISSUE',
                             'PROD SCHED MATERIAL ISSUE CONS STOCK')) THEN
      prod_schedule_mtrl_issue_ := TRUE;
   END IF;
   RETURN (prod_schedule_mtrl_issue_);
END Prod_Schedule_Mtrl_Issue___;


-- Scrap_At_Supplier___
--   Returns TRUE if the transaction is marked as Scrap At Supplier.
FUNCTION Scrap_At_Supplier___ (
   transaction_type_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   scrap_at_supplier_ BOOLEAN := FALSE;
BEGIN
   IF (transaction_type_ = 'ESO SCRAP AT SUPPLIER') THEN
      scrap_at_supplier_ := TRUE;
   END IF;
   RETURN (scrap_at_supplier_);
END Scrap_At_Supplier___;


-- Shipped_To_Intern_Customer___
--   Returns TRUE if the transaction is marked as Ship To Internal Customer.
FUNCTION Shipped_To_Intern_Customer___ (
   transaction_type_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   shipped_to_intern_customer_ BOOLEAN := FALSE;
BEGIN
   IF (transaction_type_ = 'INTERNAL CUSTOMER ORDER SHIPMENT') THEN
      shipped_to_intern_customer_ := TRUE;
   END IF;
   RETURN (shipped_to_intern_customer_);
END Shipped_To_Intern_Customer___;


FUNCTION Intersite_Transfer_Issue___ (
   transaction_type_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   intersite_transfer_ BOOLEAN := FALSE;
BEGIN
   IF (transaction_type_ = 'INTER SITE TRANSFER ISSUE') THEN
      intersite_transfer_ := TRUE;
   END IF;
   RETURN (intersite_transfer_);
END Intersite_Transfer_Issue___;


-- External_Receipt___
--   Decides if this transaction is an external receipt.
FUNCTION External_Receipt___ (
   transaction_type_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   external_receipt_ BOOLEAN := FALSE;
BEGIN
   IF (transaction_type_ = 'EXTERNAL RECEIPT') THEN
      external_receipt_ := TRUE;
   END IF;
   RETURN (external_receipt_);
END External_Receipt___;


FUNCTION Inventory_Value_Increase___ (
   transaction_type_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   value_increase_ BOOLEAN := FALSE;
BEGIN
   IF (transaction_type_ = 'INVENTORY VALUE INCREASE') THEN
      value_increase_ := TRUE;
   END IF;
   RETURN (value_increase_);
END Inventory_Value_Increase___;


FUNCTION Inventory_Value_Decrease___ (
   transaction_type_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   value_decrease_ BOOLEAN := FALSE;
BEGIN
   IF (transaction_type_ = 'INVENTORY VALUE DECREASE') THEN
      value_decrease_ := TRUE;
   END IF;
   RETURN (value_decrease_);
END Inventory_Value_Decrease___;


FUNCTION Posting_Cost_Group_Change___ (
   transaction_type_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   cost_group_change_ BOOLEAN := FALSE;
BEGIN
   IF (transaction_type_ = 'POSTING COST GROUP CHANGE') THEN
      cost_group_change_ := TRUE;
   END IF;
   RETURN (cost_group_change_);
END Posting_Cost_Group_Change___;


FUNCTION Undo_Move_To_Order_Transit___ (
   transaction_type_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   undo_move_to_order_transit_ BOOLEAN := FALSE;
BEGIN
   IF (transaction_type_ = 'UNDO MOVE TO ORDER TRANSIT') THEN
      undo_move_to_order_transit_ := TRUE;
   END IF;
   RETURN (undo_move_to_order_transit_);
END Undo_Move_To_Order_Transit___;


FUNCTION Cancel_Int_Purch_Receipt___ (
   transaction_type_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   cancel_int_purch_receipt_ BOOLEAN := FALSE;
BEGIN
   IF (transaction_type_ = 'CANCEL INTERNAL PURCHASE RECEIPT') THEN
      cancel_int_purch_receipt_ := TRUE;
   END IF;
   RETURN (cancel_int_purch_receipt_);
END Cancel_Int_Purch_Receipt___;

FUNCTION Cancel_Intersit_Shipod_Rcpt___ (
   transaction_type_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   cancel_intersit_shipod_rcpt_ BOOLEAN := FALSE;
BEGIN
   IF (transaction_type_ = 'CANCEL INTERSITE SHIPMENT ORDER RECEIPT') THEN
      cancel_intersit_shipod_rcpt_ := TRUE;
   END IF;
   RETURN (cancel_intersit_shipod_rcpt_);
END Cancel_Intersit_Shipod_Rcpt___;

FUNCTION Rma_Direct_Return___ (
   transaction_type_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   rma_direct_return_ BOOLEAN := FALSE;
BEGIN
   IF (transaction_type_ = 'RMA DIRECT RETURNS') THEN
      rma_direct_return_ := TRUE;
   END IF;
   RETURN (rma_direct_return_);
END Rma_Direct_Return___;


PROCEDURE Revalue_This_Receipt___ (
   exit_revaluation_             OUT    BOOLEAN,
   revaluation_is_impossible_    IN OUT BOOLEAN,
   weighted_avg_cost_detail_tab_ IN OUT Inventory_Part_Unit_Cost_API.Cost_Detail_Tab,
   transaction_id_               IN     NUMBER,
   company_                      IN     VARCHAR2,
   transaction_qty_              IN     NUMBER,
   prior_average_qty_            IN     NUMBER,
   receipt_cost_                 IN     NUMBER,
   cost_detail_tab_              IN     Inventory_Part_Unit_Cost_API.Cost_Detail_Tab,
   date_applied_                 IN     DATE,
   source_ref_type_db_           IN     VARCHAR2,
   trans_reval_event_id_         IN     NUMBER,
   receipt_curr_code_            IN     VARCHAR2,
   invoice_curr_code_            IN     VARCHAR2,
   avg_inv_price_in_inv_curr_    IN     NUMBER,
   avg_chg_value_in_inv_curr_    IN     NUMBER,
   accounting_id_                IN     NUMBER,
   contract_                     IN     VARCHAR2,
   unit_cost_in_receipt_curr_    IN     NUMBER )
 
IS
   new_trans_cost_detail_tab_ Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   prior_avg_cost_detail_tab_ Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   pre_cost_detail_tab_       Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   inv_tran_hist_rec_         Inventory_Transaction_Hist_API.Public_Rec;
   control_type_key_rec_      Mpccom_Accounting_API.Control_Type_Key;
BEGIN

   prior_avg_cost_detail_tab_ := Pre_Invent_Trans_Avg_Cost_API.Get_Cost_Details(transaction_id_);

   IF (source_ref_type_db_ = Order_Type_API.DB_PURCHASE_ORDER) THEN
      pre_cost_detail_tab_ := Inventory_Transaction_Cost_API.Get_Transaction_Cost_Details(transaction_id_);
   END IF;

   IF (prior_average_qty_ IS NULL) THEN
      revaluation_is_impossible_ := TRUE;
      RETURN;
   END IF;

   IF (cost_detail_tab_.COUNT = 0) THEN
      Inventory_Transaction_Hist_API.Recalc_Cost_On_Price_Update(new_trans_cost_detail_tab_,
                                                                 transaction_id_,
                                                                 receipt_cost_);
   ELSE
      Inventory_Transaction_Hist_API.Set_Cost(transaction_id_, cost_detail_tab_);
      new_trans_cost_detail_tab_ := cost_detail_tab_;
   END IF;

   Do_Value_Adjustment_Booking___(transaction_id_, company_, date_applied_, trans_reval_event_id_);
   inv_tran_hist_rec_    := Inventory_Transaction_Hist_API.Get(transaction_id_);
   control_type_key_rec_ := Mpccom_Accounting_API.Set_Control_Type_Key(inv_tran_hist_rec_.part_no,
                                                                       inv_tran_hist_rec_.contract,
                                                                       transaction_id_,
                                                                       inv_tran_hist_rec_.pre_accounting_id,
                                                                       inv_tran_hist_rec_.activity_seq,
                                                                       inv_tran_hist_rec_.source_ref_type,
                                                                       inv_tran_hist_rec_.source_ref1,
                                                                       inv_tran_hist_rec_.source_ref2,
                                                                       inv_tran_hist_rec_.source_ref3,
                                                                       inv_tran_hist_rec_.source_ref4 );

   Mpccom_Accounting_API.Do_Curr_Amt_Balance_Posting(company_                   => company_,
                                                     accounting_id_             => accounting_id_,
                                                     contract_                  => contract_,
                                                     quantity_arrived_          => transaction_qty_,
                                                     trans_reval_event_id_      => trans_reval_event_id_,
                                                     receipt_curr_code_         => receipt_curr_code_,
                                                     invoice_curr_code_         => invoice_curr_code_,
                                                     avg_inv_price_in_inv_curr_ => avg_inv_price_in_inv_curr_,
                                                     avg_chg_value_in_inv_curr_ => avg_chg_value_in_inv_curr_,
                                                     unit_cost_in_receipt_curr_ => unit_cost_in_receipt_curr_,
                                                     date_posted_               => date_applied_,
                                                     control_type_key_rec_      => control_type_key_rec_);
 
   -- If several receipt transactions were created due to serial or lot tracking
   -- the prior average cost details will have to be updated for all receipt transactions
   -- except the first one
   IF (weighted_avg_cost_detail_tab_.COUNT = 0) THEN
      weighted_avg_cost_detail_tab_ := prior_avg_cost_detail_tab_;
   ELSE
      Pre_Invent_Trans_Avg_Cost_API.Replace_Cost_Details(transaction_id_,
                                                         weighted_avg_cost_detail_tab_);
      prior_avg_cost_detail_tab_ := weighted_avg_cost_detail_tab_;
   END IF;

   weighted_avg_cost_detail_tab_ := Inventory_Part_Unit_Cost_API.Get_Weighted_Avg_Cost_Details(
                                                                     weighted_avg_cost_detail_tab_,
                                                                     new_trans_cost_detail_tab_,
                                                                     prior_average_qty_,
                                                                     transaction_qty_);

   -- There could be a need to create 'TRANSIBAL' postings to balance the
   -- inventory and transit accounts
   Inventory_Transaction_Hist_API.Balance_Transit_And_Invent_Acc(transaction_id_,
                                                                 prior_avg_cost_detail_tab_,
                                                                 weighted_avg_cost_detail_tab_,
                                                                 value_adjustment_     => TRUE,
                                                                 per_oh_adjustment_id_ => NULL,
                                                                 trans_reval_event_id_ => trans_reval_event_id_,
                                                                 date_applied_         => date_applied_);

   IF (source_ref_type_db_ = Order_Type_API.DB_PURCHASE_ORDER) THEN
      exit_revaluation_ := Cost_Details_Equal___(transaction_id_, pre_cost_detail_tab_);
   ELSE
      exit_revaluation_ := FALSE;
   END IF;

END Revalue_This_Receipt___;


-- Revalue_Other_Receipt___
--   Calculates and set new transaction cost and create additional postings
--   for a transaction that is marked as Other Receipt.
PROCEDURE Revalue_Other_Receipt___ (
   revaluation_is_impossible_    IN OUT BOOLEAN,
   weighted_avg_cost_detail_tab_ IN OUT Inventory_Part_Unit_Cost_API.Cost_Detail_Tab,
   transaction_id_               IN     NUMBER,
   transaction_qty_              IN     NUMBER,
   transaction_cost_detail_tab_  IN     Inventory_Part_Unit_Cost_API.Cost_Detail_Tab,
   prior_average_qty_            IN     NUMBER,
   trans_reval_event_id_         IN     NUMBER,
   date_applied_                 IN     DATE )
IS
   prior_avg_cost_detail_tab_ Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
BEGIN

   IF (prior_average_qty_ IS NULL) THEN
      revaluation_is_impossible_ := TRUE;
      RETURN;
   END IF;

   Pre_Invent_Trans_Avg_Cost_API.Replace_Cost_Details(transaction_id_,
                                                      weighted_avg_cost_detail_tab_);
   prior_avg_cost_detail_tab_ := weighted_avg_cost_detail_tab_;

   weighted_avg_cost_detail_tab_ := Inventory_Part_Unit_Cost_API.Get_Weighted_Avg_Cost_Details(
                                                                     weighted_avg_cost_detail_tab_,
                                                                     transaction_cost_detail_tab_,
                                                                     prior_average_qty_,
                                                                     transaction_qty_);

   -- There could be a need to create 'TRANSIBAL' postings to balance the
   -- inventory and transit accounts
   Inventory_Transaction_Hist_API.Balance_Transit_And_Invent_Acc(transaction_id_,
                                                                 prior_avg_cost_detail_tab_,
                                                                 weighted_avg_cost_detail_tab_,
                                                                 value_adjustment_     => TRUE,
                                                                 per_oh_adjustment_id_ => NULL,
                                                                 trans_reval_event_id_ => trans_reval_event_id_,
                                                                 date_applied_         => date_applied_);

END Revalue_Other_Receipt___;


-- Revalue_Other_Transaction___
--   Calculates and set new transaction cost and create additional postings
--   for a transaction that is marked as Other Transaction.
PROCEDURE Revalue_Other_Transaction___ (
   weighted_avg_cost_detail_tab_ IN Inventory_Part_Unit_Cost_API.Cost_Detail_Tab,
   transaction_id_               IN NUMBER,
   company_                      IN VARCHAR2,
   date_applied_                 IN DATE,
   trans_reval_event_id_         IN NUMBER )
IS
BEGIN

   Inventory_Transaction_Hist_API.Set_Cost(transaction_id_, weighted_avg_cost_detail_tab_);

   Do_Value_Adjustment_Booking___(transaction_id_, company_, date_applied_, trans_reval_event_id_);

END Revalue_Other_Transaction___;


-- Revalue_Cancel_Transaction___
--   Calculates and set new transaction cost and create additional postings
--   for a transaction that is a cancel of another transaction.
PROCEDURE Revalue_Cancel_Transaction___ (
   revaluation_is_impossible_    IN OUT BOOLEAN,
   weighted_avg_cost_detail_tab_ IN OUT Inventory_Part_Unit_Cost_API.Cost_Detail_Tab,
   transaction_id_               IN     NUMBER,
   transaction_qty_              IN     NUMBER,
   prior_average_qty_            IN     NUMBER,
   original_transaction_id_      IN     NUMBER,
   direction_                    IN     VARCHAR2,
   transaction_type_             IN     VARCHAR2,
   trans_reval_event_id_         IN     NUMBER,
   date_applied_                 IN     DATE )
IS
   original_tran_cost_detail_tab_ Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   prior_avg_cost_detail_tab_     Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   cancel_transaction_qty_        NUMBER;
BEGIN

   Pre_Invent_Trans_Avg_Cost_API.Replace_Cost_Details(transaction_id_,
                                                      weighted_avg_cost_detail_tab_);

   prior_avg_cost_detail_tab_ := weighted_avg_cost_detail_tab_;

   original_tran_cost_detail_tab_ := Inventory_Transaction_Cost_API.Get_Transaction_Cost_Details(
                                                                         original_transaction_id_);

   Inventory_Transaction_Hist_API.Set_Cost(transaction_id_, original_tran_cost_detail_tab_);

   Inventory_Transaction_Hist_API.Reverse_Accounting(transaction_id_,
                                                     original_transaction_id_,
                                                     value_adjustment_     => TRUE,
                                                     per_oh_adjustment_id_ => NULL,
                                                     trans_reval_event_id_ => trans_reval_event_id_,
                                                     date_applied_         => date_applied_);

   -- The cancellation of an internal purchase order or intersite shipment order is a special case that should not result in
   -- any calulations of the weighted average since that transaction only moves parts between
   -- inventory and transit
   IF NOT ((Cancel_Int_Purch_Receipt___(transaction_type_)) OR (Cancel_Intersit_Shipod_Rcpt___(transaction_type_))) THEN
      IF (prior_average_qty_ IS NULL) THEN
         revaluation_is_impossible_ := TRUE;
         RETURN;
      END IF;

      IF ((direction_ = '-') OR (Undo_Move_To_Order_Transit___(transaction_type_))) THEN
         cancel_transaction_qty_ := transaction_qty_ * -1;
      ELSE
         cancel_transaction_qty_ := transaction_qty_;
      END IF;

      IF ((prior_average_qty_ + cancel_transaction_qty_) != 0) THEN

         weighted_avg_cost_detail_tab_ := Inventory_Part_Unit_Cost_API.Get_Weighted_Avg_Cost_Details(
                                                                       weighted_avg_cost_detail_tab_,
                                                                       original_tran_cost_detail_tab_,
                                                                       prior_average_qty_,
                                                                       cancel_transaction_qty_);

         -- There could be a need to create 'TRANSIBAL' postings to balance the
         -- inventory and transit accounts
         Inventory_Transaction_Hist_API.Balance_Transit_And_Invent_Acc(transaction_id_,
                                                                       prior_avg_cost_detail_tab_,
                                                                       weighted_avg_cost_detail_tab_,
                                                                       value_adjustment_     => TRUE,
                                                                       per_oh_adjustment_id_ => NULL,
                                                                       trans_reval_event_id_ => trans_reval_event_id_,
                                                                       date_applied_         => date_applied_);
      END IF;
   END IF;
END Revalue_Cancel_Transaction___;


-- Revalue_Direct_Delivery___
--   Revalue the 'receipt' transaction created for a direct delivery from an
--   exernal supplier.
PROCEDURE Revalue_Direct_Delivery___ (
   create_price_diff_on_purdir_  OUT    BOOLEAN,
   revaluation_is_impossible_    IN OUT BOOLEAN,
   transaction_update_counter_   IN OUT NUMBER,
   order_no_                     IN     VARCHAR2,
   line_no_                      IN     VARCHAR2,
   release_no_                   IN     VARCHAR2,
   receipt_no_                   IN     NUMBER,
   sequence_no_                  IN     NUMBER,
   contract_                     IN     VARCHAR2,
   part_no_                      IN     VARCHAR2,
   receipt_cost_                 IN     NUMBER,
   company_                      IN     VARCHAR2,
   first_viable_posting_date_    IN     DATE,
   invoice_qty_                  IN     NUMBER,
   price_diff_per_unit_          IN     NUMBER,
   unit_cost_invoice_curr_       IN     NUMBER,
   order_type_db_                IN     VARCHAR2,
   trans_reval_event_id_         IN     NUMBER,
   unit_cost_in_receipt_curr_    IN     NUMBER,
   receipt_curr_code_            IN     VARCHAR2,
   invoice_curr_code_            IN     VARCHAR2,
   avg_inv_price_in_inv_curr_    IN     NUMBER,
   avg_chg_value_in_inv_curr_    IN     NUMBER )
IS
   new_trans_cost_detail_tab_ Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   receipt_transaction_id_    INVENTORY_TRANSACTION_HIST_TAB.transaction_id%TYPE;
   alt_source_ref_type_       INVENTORY_TRANSACTION_HIST_TAB.alt_source_ref_type%TYPE;
   ret_transaction_id_        NUMBER;
   transaction_code_          INVENTORY_TRANSACTION_HIST_TAB.transaction_code%TYPE;
   no_of_transfers_           NUMBER := 0;
   trans_code_rec_            Mpccom_Transaction_Code_API.Public_Rec;
   transfer_trans_tab_        Trans_List_Tab;
   accounting_id_             NUMBER;
   quantity_received_         NUMBER;
   pre_accounting_id_         NUMBER;
   activity_seq_              NUMBER; 
   source_ref_type_db_        VARCHAR2(50);
   source_ref1_               VARCHAR2(50);
   source_ref2_               VARCHAR2(50);
   source_ref3_               VARCHAR2(50);
   source_ref4_               VARCHAR2(50);
   date_applied_              DATE;
   
   CURSOR get_receipt_trans IS
      SELECT transaction_id, alt_source_ref_type, transaction_code, accounting_id, quantity, pre_accounting_id,
             activity_seq, source_ref1, source_ref2, source_ref3, source_ref4, source_ref_type, date_applied
      FROM   INVENTORY_TRANSACTION_HIST_TAB
      WHERE  alt_source_ref1     = order_no_
      AND    alt_source_ref2     = line_no_
      AND    alt_source_ref3     = release_no_
      AND    alt_source_ref4     = receipt_no_
      AND    contract            = contract_
      AND    part_no             = part_no_
      AND    source_ref_type    != 'RMA';

   CURSOR get_return_trans IS
      SELECT transaction_id, accounting_id, quantity, pre_accounting_id, activity_seq, 
             source_ref1, source_ref2, source_ref3, source_ref4, source_ref_type, date_applied
      FROM   INVENTORY_TRANSACTION_HIST_TAB           
      WHERE  alt_source_ref1     = order_no_
      AND    alt_source_ref2     = line_no_
      AND    alt_source_ref3     = release_no_
      AND    alt_source_ref4     = receipt_no_
      AND    alt_source_ref_type = 'CUSTOMER ORDER DIRECT'
      AND    contract            = contract_
      AND    part_no             = part_no_
      AND    source_ref_type     = 'RMA';

BEGIN
   create_price_diff_on_purdir_ := FALSE;
   
   OPEN get_receipt_trans;
   LOOP
      FETCH get_receipt_trans INTO receipt_transaction_id_, alt_source_ref_type_, transaction_code_, accounting_id_, quantity_received_, pre_accounting_id_, activity_seq_,
                                   source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, date_applied_;
      EXIT WHEN get_receipt_trans%NOTFOUND;
      IF (alt_source_ref_type_ = 'CUSTOMER ORDER DIRECT') THEN
         
         Inventory_Transaction_Hist_API.Recalc_Cost_On_Price_Update(new_trans_cost_detail_tab_,
                                                                    receipt_transaction_id_,
                                                                    receipt_cost_);

         date_applied_ := GREATEST(first_viable_posting_date_, date_applied_);

         Do_Value_Adjustment_Booking___(receipt_transaction_id_, company_, date_applied_, trans_reval_event_id_);

         Mpccom_Accounting_API.Do_Curr_Amt_Balance_Posting(company_                   => company_,
                                                           accounting_id_             => accounting_id_,
                                                           contract_                  => contract_,
                                                           quantity_arrived_          => quantity_received_,
                                                           trans_reval_event_id_      => trans_reval_event_id_,
                                                           receipt_curr_code_         => receipt_curr_code_,
                                                           invoice_curr_code_         => invoice_curr_code_,
                                                           avg_inv_price_in_inv_curr_ => avg_inv_price_in_inv_curr_,
                                                           avg_chg_value_in_inv_curr_ => avg_chg_value_in_inv_curr_,
                                                           unit_cost_in_receipt_curr_ => unit_cost_in_receipt_curr_,
                                                           date_posted_               => date_applied_);
         Increase___ (transaction_update_counter_);
         
         OPEN get_return_trans;
         LOOP
            FETCH get_return_trans INTO ret_transaction_id_, accounting_id_, quantity_received_, pre_accounting_id_, activity_seq_,
                                        source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, date_applied_;
            EXIT WHEN get_return_trans%NOTFOUND;
         
            IF (ret_transaction_id_ IS NOT NULL) THEN

               date_applied_ := GREATEST(first_viable_posting_date_, date_applied_);

               Revalue_Direct_Return___(ret_transaction_id_,
                                        company_,
                                        date_applied_,
                                        trans_reval_event_id_,
                                        accounting_id_,
                                        contract_,
                                        quantity_received_,
                                        receipt_curr_code_,
                                        invoice_curr_code_,
                                        avg_inv_price_in_inv_curr_,
                                        avg_chg_value_in_inv_curr_,
                                        unit_cost_in_receipt_curr_);
            ELSE
               EXIT;
            END IF;
         END LOOP;
         CLOSE get_return_trans;
         trans_code_rec_ := Mpccom_Transaction_Code_API.Get(transaction_code_);
         IF ( trans_code_rec_.trans_based_reval_group = Trans_Based_Reval_Group_API.DB_DIR_SHP_INT_TRANSIT_CUS_ORD ) THEN
            no_of_transfers_ := no_of_transfers_ + 1;
            transfer_trans_tab_(no_of_transfers_).transaction_id := receipt_transaction_id_;
         END IF;
      ELSE
         EXIT;
      END IF;
   END LOOP;
   CLOSE get_receipt_trans;

   IF (NVL(alt_source_ref_type_, Database_SYS.string_null_) != 'CUSTOMER ORDER DIRECT') THEN
      -- Price differences when matching a direct delivery of purchase components to supplier
      -- should lead to price difference transactions instead of updating the transaction cost.
      -- This transaction is a PURDIR trans.
      Make_Price_Diff_Transaction___(order_no_,
                                     line_no_,
                                     release_no_,
                                     receipt_no_,
                                     sequence_no_,
                                     order_type_db_,
                                     contract_,
                                     part_no_,
                                     company_,
                                     invoice_qty_,
                                     price_diff_per_unit_,
                                     trans_reval_event_id_,
                                     unit_cost_invoice_curr_,
                                     invoice_curr_code_,
                                     unit_cost_in_receipt_curr_,
                                     receipt_curr_code_);
                                   
      create_price_diff_on_purdir_ := TRUE;
   END IF; 
   IF ( transfer_trans_tab_.COUNT > 0 ) THEN
      Process_Intersite_Transfers___( revaluation_is_impossible_,
                                      transaction_update_counter_,
                                      contract_,
                                      company_,
                                      trans_reval_event_id_,
                                      transfer_trans_tab_);
   END IF;
END Revalue_Direct_Delivery___;


-- Revalue_Supplier_Shipment___
--   Calculates new transaction cost and creates additional postings for
--   transactions that are marked as Ship Material To Supplier.
PROCEDURE Revalue_Supplier_Shipment___ (
   revaluation_is_impossible_    IN OUT BOOLEAN,
   weighted_avg_cost_detail_tab_ IN OUT Inventory_Part_Unit_Cost_API.Cost_Detail_Tab,
   transaction_id_               IN     NUMBER,
   prior_average_qty_            IN     NUMBER,   
   trans_reval_event_id_         IN     NUMBER,
   company_                      IN     VARCHAR2,
   date_applied_                 IN     DATE,
   order_no_                     IN     VARCHAR2,
   release_no_                   IN     VARCHAR2,
   sequence_no_                  IN     VARCHAR2)
IS
   prior_avg_cost_detail_tab_      Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   poinv_wip_transaction_id_       NUMBER;
BEGIN

   IF (prior_average_qty_ IS NULL) THEN
      revaluation_is_impossible_ := TRUE;
      RETURN;
   END IF;

   Pre_Invent_Trans_Avg_Cost_API.Replace_Cost_Details(transaction_id_,
                                                      weighted_avg_cost_detail_tab_);

   prior_avg_cost_detail_tab_ := weighted_avg_cost_detail_tab_;

   poinv_wip_transaction_id_ := Inventory_Transaction_Hist_API.Get_Purch_Comp_Consume_Trans(order_no_, release_no_, sequence_no_, NULL);
   IF(poinv_wip_transaction_id_ IS NULL) THEN    
      Revalue_Other_Transaction___(weighted_avg_cost_detail_tab_, transaction_id_, company_, date_applied_, trans_reval_event_id_);
   ELSE
      Inventory_Transaction_Hist_API.Reval_WA_Supplier_Shipment(transaction_id_, trans_reval_event_id_, date_applied_);
   END IF;

   -- There could be a need to create 'TRANSIBAL' postings to balance the
   -- inventory and transit accounts
   Inventory_Transaction_Hist_API.Balance_Transit_And_Invent_Acc(transaction_id_,
                                                                 prior_avg_cost_detail_tab_,
                                                                 weighted_avg_cost_detail_tab_,
                                                                 value_adjustment_     => TRUE,
                                                                 per_oh_adjustment_id_ => NULL,
                                                                 trans_reval_event_id_ => trans_reval_event_id_,
                                                                 date_applied_         => date_applied_);

END Revalue_Supplier_Shipment___;


-- Revalue_Service_Cost_Arriv___
--   Calculates transaction cost and creates additional postings for a
--   service cost arrival transaction.
PROCEDURE Revalue_Service_Cost_Arriv___ (
   transaction_id_       IN NUMBER,
   invoice_price_        IN NUMBER,
   company_              IN VARCHAR2,
   contract_             IN VARCHAR2,
   date_applied_         IN DATE,
   trans_reval_event_id_ IN NUMBER )
IS
   new_trans_cost_detail_tab_ Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   dummy_cost_detail_tab_     Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   arr_repair_trans_rec_      Inventory_Transaction_Hist_API.Public_Rec;
BEGIN

   arr_repair_trans_rec_ := Inventory_Transaction_Hist_API.Get(transaction_id_);

   Inventory_Transaction_Hist_API.Get_External_Service_Costs(
                                  comp_cost_detail_tab_    => dummy_cost_detail_tab_,
                                  service_cost_detail_tab_ => new_trans_cost_detail_tab_,
                                  source_ref_1_            => arr_repair_trans_rec_.source_ref1,
                                  source_ref_2_            => arr_repair_trans_rec_.source_ref2,
                                  source_ref_3_            => arr_repair_trans_rec_.source_ref3,
                                  service_cost_            => invoice_price_,
                                  include_service_cost_    => TRUE,
                                  contract_                => arr_repair_trans_rec_.contract);

   Inventory_Transaction_Hist_API.Set_Cost(transaction_id_, new_trans_cost_detail_tab_);

   Do_Value_Adjustment_Booking___(transaction_id_, company_, date_applied_, trans_reval_event_id_);

END Revalue_Service_Cost_Arriv___;


-- Revalue_Reval_Transaction___
--   Revalue a revaluation transaction when valuation method is
--   Weighted Average. Changes the value of the revaluation
--   transaction so that the result after the revalution will be the same
--   as before.
--   The revaluation transactions could come in pairs if the value for
--   some details has been increased and the value for other details
--   have been decreased. In that case the full difference resulting from the
--   cascade process will be booked on the first revaluation transaction so that
--   the resulting value after that transaction will be the same as before.
PROCEDURE Revalue_Reval_Transaction___(
   transaction_id_               IN NUMBER,
   weighted_avg_cost_detail_tab_ IN Inventory_Part_Unit_Cost_API.Cost_Detail_Tab,
   transaction_type_             IN VARCHAR2,
   first_reval_trans_type_       IN VARCHAR2,
   company_                      IN VARCHAR2,
   date_applied_                 IN DATE,
   trans_reval_event_id_         IN NUMBER )
IS
   prior_avg_cost_detail_tab_ Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   org_trans_cost_detail_tab_ Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   new_trans_cost_detail_tab_ Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   cost_detail_diff_tab_      Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   reval_factor_              NUMBER;

BEGIN

   -- Only revalue the first transaction in case both a INVREVAL+ and INVREVAL- transaction
   -- was created when the revaluation was executed.
   IF (transaction_type_ = first_reval_trans_type_) THEN
      prior_avg_cost_detail_tab_ := Pre_Invent_Trans_Avg_Cost_API.Get_Cost_Details(transaction_id_);
      org_trans_cost_detail_tab_ := Inventory_Transaction_Cost_API.Get_Transaction_Cost_Details(transaction_id_);

      -- Calculate the diff that should be applied to the current transaction cost for the revaluation
      cost_detail_diff_tab_ := Inventory_Part_Unit_Cost_API.Add_To_Value_Detail_Tab(weighted_avg_cost_detail_tab_,
                                                                                    prior_avg_cost_detail_tab_,
                                                                                    -1);

      -- Depending on the direction of the revaluation transaction the cost of the transaction should
      -- either be increased or decreased with the diff calculated
      IF (Inventory_Value_Decrease___(transaction_type_)) THEN
         reval_factor_ := 1;
      ELSE
         reval_factor_:= -1;
      END IF;

      new_trans_cost_detail_tab_ := Inventory_Part_Unit_Cost_API.Add_To_Value_Detail_Tab(org_trans_cost_detail_tab_,
                                                                                         cost_detail_diff_tab_,
                                                                                         reval_factor_);

      Inventory_Transaction_Hist_API.Set_Cost(transaction_id_, new_trans_cost_detail_tab_);

      Do_Value_Adjustment_Booking___(transaction_id_, company_, date_applied_, trans_reval_event_id_);
   END IF;

   Pre_Invent_Trans_Avg_Cost_API.Replace_Cost_Details(transaction_id_,
                                                      weighted_avg_cost_detail_tab_);
END Revalue_Reval_Transaction___;


-- Revalue_Cost_Group_Change___
--   Revalue transaction created when a posting cost group has been changed
--   for one or more cost bucket(s).
--   Only the cost details already existing on the cost group change
--   transaction will have to be modified
PROCEDURE Revalue_Cost_Group_Change___ (
   transaction_id_       IN NUMBER,
   cost_detail_tab_      IN Inventory_Part_Unit_Cost_API.Cost_Detail_Tab,
   company_              IN VARCHAR2,
   date_applied_         IN DATE,
   trans_reval_event_id_ IN NUMBER )
IS
   old_cost_detail_tab_ Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   new_cost_detail_tab_ Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   match_found_         BOOLEAN;
BEGIN

   old_cost_detail_tab_ := Inventory_Transaction_Cost_API.Get_Transaction_Cost_Details(transaction_id_);

   IF (cost_detail_tab_.COUNT = 0) THEN
      -- In the unlikely event that no details are passed all existing details should be cleared out
      new_cost_detail_tab_ := cost_detail_tab_;
   ELSE
      new_cost_detail_tab_ := old_cost_detail_tab_;
   END IF;

   IF (new_cost_detail_tab_.COUNT > 0) THEN
      FOR i_ IN new_cost_detail_tab_.FIRST..new_cost_detail_tab_.LAST LOOP
         match_found_ := FALSE;
         FOR j_ IN cost_detail_tab_.FIRST..cost_detail_tab_.LAST LOOP
            IF ((new_cost_detail_tab_(i_).accounting_year = cost_detail_tab_(j_).accounting_year) AND
                (new_cost_detail_tab_(i_).contract        = cost_detail_tab_(j_).contract) AND
                (new_cost_detail_tab_(i_).cost_bucket_id  = cost_detail_tab_(j_).cost_bucket_id) AND
                (new_cost_detail_tab_(i_).company         = cost_detail_tab_(j_).company) AND
                (new_cost_detail_tab_(i_).cost_source_id  = cost_detail_tab_(j_).cost_source_id)) THEN
               -- If the same detail already exist in the transaction cost details then
               -- update unit cost with the new value
               new_cost_detail_tab_(i_).unit_cost := cost_detail_tab_(j_).unit_cost;
               match_found_ := TRUE;
               EXIT;
            END IF;
         END LOOP;
         IF (NOT match_found_) THEN
            -- The old cost details did not exist in the new details
            new_cost_detail_tab_(i_).unit_cost := 0;
         END IF;
      END LOOP;
   END IF;

   Inventory_Transaction_Hist_API.Set_Cost(transaction_id_, new_cost_detail_tab_);

   Do_Value_Adjustment_Booking___(transaction_id_, company_, date_applied_, trans_reval_event_id_);

END Revalue_Cost_Group_Change___;


-- Revalue_Direct_Return___
--   Calculates direct delivery return transaction cost based on the corresponding delivery transaction
--   cost and set the cost is same as delivery transaction and create value adjustment booking for the
--   difference. This is used with type Rma_Direct_Return.
PROCEDURE Revalue_Direct_Return___ (
   transaction_id_             IN  NUMBER,
   company_                    IN  VARCHAR2,
   date_applied_               IN  DATE,
   trans_reval_event_id_       IN  NUMBER,
   accounting_id_              IN  NUMBER,
   contract_                   IN  VARCHAR2,
   quantity_                   IN  NUMBER, 
   receipt_curr_code_          IN  VARCHAR2,
   invoice_curr_code_          IN  VARCHAR2,
   avg_inv_price_in_inv_curr_  IN  NUMBER,
   avg_chg_value_in_inv_curr_  IN  NUMBER,
   unit_cost_in_receipt_curr_  IN  NUMBER )
IS
   delivery_transaction_id_        NUMBER;
   original_tran_cost_detail_tab_  Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   connect_reason_db_              VARCHAR2(200);
BEGIN
   
   IF (Inventory_Transaction_Hist_API.Get_Transaction_Code(transaction_id_) = 'RETPODIRSH') THEN     
      connect_reason_db_ := Invent_Trans_Conn_Reason_API.DB_RETURN_TO_SUPPLIER;
   ELSE
      connect_reason_db_ := Invent_Trans_Conn_Reason_API.DB_MULTISITE_DELIVERY_RETURN;
   END IF;      
   delivery_transaction_id_ := Invent_Trans_Interconnect_API.Get_Connected_Transaction_Id(transaction_id_, connect_reason_db_);
 
   original_tran_cost_detail_tab_ := Inventory_Transaction_Cost_API.Get_Transaction_Cost_Details(delivery_transaction_id_);
  
   Inventory_Transaction_Hist_API.Set_Cost(transaction_id_, original_tran_cost_detail_tab_);

   Do_Value_Adjustment_Booking___(transaction_id_, company_, date_applied_, trans_reval_event_id_);

   Mpccom_Accounting_API.Do_Curr_Amt_Balance_Posting(company_                   => company_,
                                                     accounting_id_             => accounting_id_,
                                                     contract_                  => contract_,
                                                     quantity_arrived_          => quantity_,
                                                     trans_reval_event_id_      => trans_reval_event_id_,
                                                     receipt_curr_code_         => receipt_curr_code_,
                                                     invoice_curr_code_         => invoice_curr_code_,
                                                     avg_inv_price_in_inv_curr_ => avg_inv_price_in_inv_curr_,
                                                     avg_chg_value_in_inv_curr_ => avg_chg_value_in_inv_curr_,
                                                     unit_cost_in_receipt_curr_ => unit_cost_in_receipt_curr_,
                                                     date_posted_               => date_applied_);
END Revalue_Direct_Return___;


-- Handle_Prosch_Wip_Variance___
--   This method makes a dynamic call to Production Schedule to find
--   the top part number and contract. Then makes a PSDIFF transaction
--   if the transaction revaluation has affected the M40 (WIP) postings
--   on the material issue transactions.
PROCEDURE Handle_Prosch_Wip_Variance___ (
   order_no_             IN VARCHAR2,
   company_              IN VARCHAR2,
   old_wip_sum_value_    IN NUMBER,
   new_wip_sum_value_    IN NUMBER,
   trans_reval_event_id_ IN NUMBER )
IS   
   transaction_code_      INVENTORY_TRANSACTION_HIST_TAB.transaction_code%TYPE;
   ndummy_                NUMBER;
   wip_variance_          NUMBER;
   contract_              INVENTORY_TRANSACTION_HIST_TAB.contract%TYPE;
   part_no_               INVENTORY_TRANSACTION_HIST_TAB.part_no%TYPE;
   transaction_id_        INVENTORY_TRANSACTION_HIST_TAB.transaction_id%TYPE;
   accounting_id_         INVENTORY_TRANSACTION_HIST_TAB.accounting_id%TYPE;
   empty_cost_detail_tab_ Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   value_detail_tab_      Mpccom_Accounting_API.Value_Detail_Tab;
BEGIN

   wip_variance_ := new_wip_sum_value_ - old_wip_sum_value_;

   IF (wip_variance_ = 0) THEN
      RETURN;
   END IF;

   $IF Component_Prosch_SYS.INSTALLED $THEN
      Production_Receipt_API.Get_Receipt_Info(contract_, part_no_, order_no_);
   $ELSE
      Error_SYS.Component_Not_Exist('PROSCH');
   $END                                 

   IF (wip_variance_ < 0) THEN
      transaction_code_ := 'PSDIFF+';
   ELSE
      transaction_code_ := 'PSDIFF-';
   END IF;

   Inventory_Transaction_Hist_API.New(transaction_id_     => transaction_id_,
                                      accounting_id_      => accounting_id_,
                                      value_              => ndummy_,
                                      transaction_code_   => transaction_code_,
                                      contract_           => contract_,
                                      part_no_            => part_no_,
                                      configuration_id_   => '*',
                                      location_no_        => '*',
                                      lot_batch_no_       => '*',
                                      serial_no_          => '*',
                                      waiv_dev_rej_no_    => '*',
                                      eng_chg_level_      => '*',
                                      activity_seq_       => 0,
                                      project_id_         => NULL,
                                      source_ref1_        => order_no_,
                                      source_ref2_        => '*',
                                      source_ref3_        => '*',
                                      source_ref4_        => NULL,
                                      source_ref5_        => NULL,
                                      reject_code_        => NULL,
                                      cost_detail_tab_    => empty_cost_detail_tab_,
                                      unit_cost_          => 0,
                                      quantity_           => 0,
                                      qty_reversed_       => 0,
                                      catch_quantity_     => NULL,
                                      source_             => NULL,
                                      source_ref_type_    => NULL,
                                      owning_vendor_no_   => NULL,
                                      condition_code_     => NULL,
                                      location_group_     => NULL,
                                      part_ownership_db_  => 'COMPANY OWNED',
                                      owning_customer_no_ => NULL,
                                      expiration_date_    => NULL);

   value_detail_tab_(1).bucket_posting_group_id := NULL;
   value_detail_tab_(1).cost_source_id          := NULL;
   value_detail_tab_(1).value                   := ABS(wip_variance_);

   Inventory_Transaction_Hist_API.Do_Booking(transaction_id_,
                                             company_,
                                             NULL,
                                             'Y',
                                             value_detail_tab_,
                                             trans_reval_event_id_ => trans_reval_event_id_);
END Handle_Prosch_Wip_Variance___;


-- External_Service_Order_Line___
--   This method makes a dynamic call to fetch the order code from
--   the purchase order line. If order code = 6 then return true.
FUNCTION External_Service_Order_Line___ (
   order_no_    IN VARCHAR2,
   release_no_  IN VARCHAR2,
   sequence_no_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   order_code_                  VARCHAR2(10);
   stmt_                        VARCHAR2(200);
   external_service_order_line_ BOOLEAN := FALSE;
BEGIN
   stmt_ := 'BEGIN '                                                                        ||
               ':order_code := Purchase_Order_Line_Part_API.Get_Order_Code(:order_no,'      ||
                                                                          ':release_no,'    ||
                                                                          ':sequence_no); ' ||
            'END;';

   @ApproveDynamicStatement(2006-01-24,nidalk)
   EXECUTE IMMEDIATE stmt_ USING OUT order_code_,
                                 IN  order_no_,
                                 IN  release_no_,
                                 IN  sequence_no_;

   IF (order_code_ = '6') THEN
      external_service_order_line_ := TRUE;
   END IF;

   RETURN (external_service_order_line_);
END External_Service_Order_Line___;


-- Decide_Progress_Alternative___
--   Method contains logic that decides on how to handle a component receipt
--   in the External Service Order flow.
PROCEDURE Decide_Progress_Alternative___ (
   receipt_trans_                 OUT INVENTORY_TRANSACTION_HIST_TAB%ROWTYPE,
   continue_with_comp_receipt_    OUT BOOLEAN,
   revaluation_is_impossible_  IN OUT BOOLEAN,
   cost_detail_tab_            IN OUT Inventory_Part_Unit_Cost_API.Cost_Detail_Tab,
   cost_detail_diff_tab_       IN     Inventory_Part_Unit_Cost_API.Cost_Detail_Tab,
   receipt_transaction_id_     IN     NUMBER,
   shipped_part_no_            IN     VARCHAR2 )
IS
   received_part_rec_      Inventory_Part_API.Public_Rec;
   comp_cost_detail_tab_   Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;

   CURSOR get_receipt_trans IS
      SELECT *
      FROM INVENTORY_TRANSACTION_HIST_TAB
      WHERE transaction_id = receipt_transaction_id_;
BEGIN

   OPEN  get_receipt_trans;
   FETCH get_receipt_trans INTO receipt_trans_;
   CLOSE get_receipt_trans;

   IF (receipt_trans_.part_no = shipped_part_no_) THEN
      continue_with_comp_receipt_ := TRUE;
   ELSE
      received_part_rec_ := Inventory_Part_API.Get(receipt_trans_.contract, receipt_trans_.part_no);

      IF ((received_part_rec_.inventory_valuation_method = 'ST'               )  AND
          (received_part_rec_.inventory_part_cost_level  = 'COST PER SERIAL'  )  AND
          (received_part_rec_.invoice_consideration      = 'TRANSACTION BASED')) THEN

         continue_with_comp_receipt_ := TRUE;

         Inventory_Part_Unit_Cost_API.Lock_By_Keys_Wait(receipt_trans_.contract,
                                                        receipt_trans_.part_no,
                                                        '*',
                                                        '*',
                                                        '*');
      ELSE
         revaluation_is_impossible_ := TRUE;
      END IF;
   END IF;

   IF (continue_with_comp_receipt_) THEN

      -- Retrieve the currect cost details for the component arrival transaction
      comp_cost_detail_tab_ := Inventory_Transaction_Cost_API.Get_Transaction_Cost_Details(receipt_trans_.transaction_id);

      -- Calculate the new transaction cost by adding the diff passed on in the cascade
      cost_detail_tab_ := Inventory_Part_Unit_Cost_API.Add_To_Value_Detail_Tab(comp_cost_detail_tab_,
                                                                               cost_detail_diff_tab_,
                                                                               1);


   END IF;
END Decide_Progress_Alternative___;


-- Handle_Shpord_Wip_Variance___
--   This method makes a dynamic call to Shop Order where material variance
--   postings are created on the shop order.
PROCEDURE Handle_Shpord_Wip_Variance___ (
   order_no_    IN VARCHAR2,
   release_no_  IN VARCHAR2,
   sequence_no_ IN VARCHAR2 )
IS   
BEGIN
   
   $IF Component_Shpord_SYS.INSTALLED $THEN
      Shop_Ord_Util_API.Balance_Wip_Material_Variance(order_no_, release_no_, sequence_no_);
   $ELSE
      NULL;  
   $END
END Handle_Shpord_Wip_Variance___;


-- Get_PO_Receipt_Trans_Id___
--   Find the first Purchase Receipt transaction for the specified
--   purchase order receipt.
FUNCTION Get_PO_Receipt_Trans_Id___ (
   order_no_                IN VARCHAR2,
   line_no_                 IN VARCHAR2,
   release_no_              IN VARCHAR2,
   receipt_no_              IN NUMBER,
   order_type_db_           IN VARCHAR2,
   contract_                IN VARCHAR2,
   part_no_                 IN VARCHAR2,
   serial_no_               IN VARCHAR2,
   find_service_cost_trans_ IN NUMBER ) RETURN NUMBER
IS
   receipt_transaction_id_ NUMBER;

   -- NULL checks needed when the method is being called from Received_Back_From_Supplier___
   CURSOR get_receipt_transaction_id IS
      SELECT min(transaction_id)
      FROM   INVENTORY_TRANSACTION_HIST_TAB a, mpccom_transaction_code_pub b
      WHERE source_ref1  = order_no_
      AND   source_ref2  = line_no_
      AND   source_ref3  = release_no_
      AND   (source_ref4 = receipt_no_    OR  receipt_no_ IS NULL)
      AND   source_ref_type = order_type_db_
      AND   (contract       = contract_      OR contract_      IS NULL)
      AND   (part_no        = part_no_       OR part_no_       IS NULL)
      AND   (serial_no      = serial_no_     OR serial_no_     IS NULL)
      AND   (a.transaction_code = b.transaction_code)
      AND   (((trans_based_reval_group_db = 'ESO SERVICE COST RECEIPT') AND
              (find_service_cost_trans_ = 1)) OR
             (trans_based_reval_group_db IN ('PURCHASE ORDER RECEIPT',
                                             'EXTERNAL RECEIPT',
                                             'RECEIPT CONS STOCK',
                                             'ESO COMPONENT RECEIPT')));
BEGIN
   OPEN  get_receipt_transaction_id;
   FETCH get_receipt_transaction_id INTO receipt_transaction_id_;
   CLOSE get_receipt_transaction_id;
   RETURN (receipt_transaction_id_);
END Get_PO_Receipt_Trans_Id___;


-- Get_SO_Receipt_Trans_Id___
--   Find the Shop Order Receipt transaction for the specified serial part.
FUNCTION Get_SO_Receipt_Trans_Id___ (
   order_no_      IN VARCHAR2,
   release_no_    IN VARCHAR2,
   sequence_no_   IN VARCHAR2,
   order_type_db_ IN VARCHAR2,
   contract_      IN VARCHAR2,
   part_no_       IN VARCHAR2,
   serial_no_     IN VARCHAR2 ) RETURN NUMBER
IS
   receipt_transaction_id_ NUMBER;

   -- For WA processing the first receipt should be returned
   CURSOR get_first_receipt_trans_id IS
      SELECT MIN(transaction_id)
      FROM   INVENTORY_TRANSACTION_HIST_TAB a, mpccom_transaction_code_pub b
      WHERE source_ref1     = order_no_
      AND   source_ref2     = release_no_
      AND   source_ref3     = sequence_no_
      AND   source_ref_type = order_type_db_
      AND   contract        = contract_
      AND   part_no         = part_no_
      AND   a.transaction_code         = b.transaction_code
      AND   trans_based_reval_group_db = 'MANUFACTURING RECEIPT';

   -- For Serial processing the last receipt should be returned
   CURSOR get_last_receipt_trans_id IS
      SELECT MAX(transaction_id)
      FROM   INVENTORY_TRANSACTION_HIST_TAB a, mpccom_transaction_code_pub b
      WHERE source_ref1     = order_no_
      AND   source_ref2     = release_no_
      AND   source_ref3     = sequence_no_
      AND   source_ref_type = order_type_db_
      AND   contract        = contract_
      AND   part_no         = part_no_
      AND   serial_no       = serial_no_
      AND   a.transaction_code         = b.transaction_code
      AND   trans_based_reval_group_db = 'MANUFACTURING RECEIPT';
   
BEGIN
   IF (serial_no_ IS NOT NULL) THEN
      OPEN  get_last_receipt_trans_id;
      FETCH get_last_receipt_trans_id INTO receipt_transaction_id_;
      CLOSE get_last_receipt_trans_id;
   ELSE
      OPEN  get_first_receipt_trans_id;
      FETCH get_first_receipt_trans_id INTO receipt_transaction_id_;
      CLOSE get_first_receipt_trans_id;
   END IF;
   RETURN (receipt_transaction_id_);
END Get_SO_Receipt_Trans_Id___;


-- Received_Back_From_Supplier___
--   This method checks if there has been any component receipt transactions
--   reported for this purchase order line.
FUNCTION Received_Back_From_Supplier___ (
   next_receipt_transaction_id_ OUT NUMBER,
   order_no_                    IN  VARCHAR2,
   release_no_                  IN  VARCHAR2,
   sequence_no_                 IN  VARCHAR2,
   order_type_db_               IN  VARCHAR2 ) RETURN BOOLEAN
IS
   received_back_from_supplier_ BOOLEAN := TRUE;
BEGIN
   next_receipt_transaction_id_ := Get_PO_Receipt_Trans_Id___(order_no_,
                                                              release_no_,
                                                              sequence_no_,
                                                              NULL,
                                                              order_type_db_,
                                                              NULL,
                                                              NULL,
                                                              NULL,
                                                              0);
   IF (next_receipt_transaction_id_ IS NULL) THEN
      received_back_from_supplier_ := FALSE;
   END IF;
   RETURN (received_back_from_supplier_);
END Received_Back_From_Supplier___;


-- Make_Add_Pre_Reval_Actions___
--   Performs additional pre-revaluation actions for one transaction.
PROCEDURE Make_Add_Pre_Reval_Actions___ (
   old_wip_sum_value_ OUT NUMBER,
   accounting_id_     IN  NUMBER,
   transaction_type_  IN  VARCHAR2 )
IS
BEGIN

   IF (Prod_Schedule_Mtrl_Issue___(transaction_type_)) THEN
      old_wip_sum_value_ := Mpccom_Accounting_API.Get_Sum_Value(accounting_id_, 'M40');
   END IF;

END Make_Add_Pre_Reval_Actions___;


-- Make_Add_Post_Reval_Actions___
--   Performs additional post-revaluation actions for one transaction.
PROCEDURE Make_Add_Post_Reval_Actions___ (
   order_no_                  IN VARCHAR2,
   company_                   IN VARCHAR2,
   transaction_type_          IN VARCHAR2,
   accounting_id_             IN NUMBER,
   old_wip_sum_value_         IN NUMBER,
   trans_reval_event_id_      IN NUMBER )
IS
   new_wip_sum_value_ NUMBER;
BEGIN
   IF (Prod_Schedule_Mtrl_Issue___(transaction_type_)) THEN

      new_wip_sum_value_ := Mpccom_Accounting_API.Get_Sum_Value(accounting_id_, 'M40');

      Handle_Prosch_Wip_Variance___(order_no_,
                                    company_,
                                    old_wip_sum_value_,
                                    new_wip_sum_value_,
                                    trans_reval_event_id_);
   END IF;

END Make_Add_Post_Reval_Actions___;


PROCEDURE Do_Value_Adjustment_Booking___ (
   transaction_id_       IN NUMBER,
   company_              IN VARCHAR2,
   date_applied_         IN DATE,
   trans_reval_event_id_ IN NUMBER )
IS
   empty_value_detail_tab_ Mpccom_Accounting_API.Value_Detail_Tab;
BEGIN
   Inventory_Transaction_Hist_API.Do_Booking(transaction_id_       => transaction_id_,
                                             company_              => company_,
                                             event_code_           => NULL,
                                             complete_flag_        => 'N',
                                             external_value_tab_   => empty_value_detail_tab_,
                                             value_adjustment_     => TRUE,
                                             adjustment_date_      => date_applied_,
                                             trans_reval_event_id_ => trans_reval_event_id_);
END Do_Value_Adjustment_Booking___;

-- Add_Shop_Order_To_List___
--   Adds a new shop order to the shop_order_tab_ if it is not already
PROCEDURE Add_Shop_Order_To_List___ (
   shop_ord_ref_tab_ IN OUT Shop_Ord_Ref_Tab,
   order_no_         IN     VARCHAR2,
   release_no_       IN     VARCHAR2,
   sequence_no_      IN     VARCHAR2 )
IS
   already_added_ BOOLEAN := FALSE;
   n_             PLS_INTEGER;
BEGIN

   IF (shop_ord_ref_tab_.COUNT = 0) THEN
      shop_ord_ref_tab_(1).order_no    := order_no_;
      shop_ord_ref_tab_(1).release_no  := release_no_;
      shop_ord_ref_tab_(1).sequence_no := sequence_no_;
   ELSE
      -- Make sure the order is not already in the list
      FOR i_ IN shop_ord_ref_tab_.FIRST..shop_ord_ref_tab_.LAST LOOP
         IF ((shop_ord_ref_tab_(i_).order_no    = order_no_) AND
             (shop_ord_ref_tab_(i_).release_no  = release_no_) AND
             (shop_ord_ref_tab_(i_).sequence_no = sequence_no_)) THEN
            already_added_ := TRUE;
            EXIT;
         END IF;
      END LOOP;
      -- Add shop order if new
      IF (NOT already_added_) THEN
         n_ := shop_ord_ref_tab_.LAST + 1;
         shop_ord_ref_tab_(n_).order_no    := order_no_;
         shop_ord_ref_tab_(n_).release_no  := release_no_;
         shop_ord_ref_tab_(n_).sequence_no := sequence_no_;
      END IF;
   END IF;
END Add_Shop_Order_To_List___;


-- Process_Updated_Shop_Orders___
--   Process shop orders for which issue transactions have been updated.
--   If a Shop Order is still open there will not be any need for additional
--   processing as the changes will be accounted for when the SO is being
--   closed. If a SO that was upadated was not already in an open state then
--   it needs to be reopened and then closed again.
PROCEDURE Process_Updated_Shop_Orders___ (
   shop_ord_ref_tab_     IN Shop_Ord_Ref_Tab,
   trans_reval_event_id_ IN NUMBER  )
IS   
   needs_closing_           NUMBER;
   attr_                    VARCHAR2(2000);
   description_             VARCHAR2(2000);
   sorted_shop_ord_ref_tab_ Shop_Ord_Ref_Tab;
   $IF Component_Shpord_SYS.INSTALLED $THEN
      so_rec_               Shop_Ord_API.Public_Rec;
   $END
BEGIN

   $IF Component_Shpord_SYS.INSTALLED $THEN
      IF (shop_ord_ref_tab_.COUNT > 0) THEN
        DECLARE
           already_open_ BOOLEAN;
        BEGIN
           -- The list of shop order keys needs to be sorted so that we can avoid having a deadlock if several 
           -- Transaction Revaluation processes deal with the same orders simultaneously.
           sorted_shop_ord_ref_tab_ := Get_Sorted_Shop_Ord_Ref_Tab___(shop_ord_ref_tab_);
           FOR i_ IN sorted_shop_ord_ref_tab_.FIRST..sorted_shop_ord_ref_tab_.LAST LOOP
               Shop_Ord_API.Lock_And_Open(already_open_,
                                          sorted_shop_ord_ref_tab_(i_).order_no,
                                          sorted_shop_ord_ref_tab_(i_).release_no,
                                          sorted_shop_ord_ref_tab_(i_).sequence_no);
               IF already_open_ THEN
                  needs_closing_ := 0;
               ELSE
                  needs_closing_ := 1;
               END IF;

               -- If the Shop Order was reopened it should be closed again
               -- This will be done in a deferred call since it could initiate a new
               -- cascade which needs to be executed in a transaction of it's own
               IF (needs_closing_ = 1) THEN
                  so_rec_ := Shop_Ord_API.Get(sorted_shop_ord_ref_tab_(i_).order_no,
                                              sorted_shop_ord_ref_tab_(i_).release_no,
                                              sorted_shop_ord_ref_tab_(i_).sequence_no);
                  
                  -- When shop order is re-open it should not be visible either as demand or supply for process such as MRP
                  -- So we force set the include flag to FALSE and will be revert back when shop order close.
                  IF so_rec_.include_as_demand != Fnd_Boolean_API.DB_FALSE OR so_rec_.include_as_supply != Fnd_Boolean_API.DB_FALSE THEN
                     Shop_Ord_API.Set_Mrp_Include_Flags(sorted_shop_ord_ref_tab_(i_).order_no,
                                                        sorted_shop_ord_ref_tab_(i_).release_no,
                                                        sorted_shop_ord_ref_tab_(i_).sequence_no,
                                                        Fnd_Boolean_API.DB_FALSE,
                                                        Fnd_Boolean_API.DB_FALSE );
                  END IF;
                  
                  Client_SYS.Clear_Attr(attr_);
                  Client_SYS.Add_To_Attr('ORDER_NO', sorted_shop_ord_ref_tab_(i_).order_no, attr_);
                  Client_SYS.Add_To_Attr('RELEASE_NO', sorted_shop_ord_ref_tab_(i_).release_no, attr_);
                  Client_SYS.Add_To_Attr('SEQUENCE_NO', sorted_shop_ord_ref_tab_(i_).sequence_no, attr_);
                  Client_SYS.Add_To_Attr('CLOSED_BY_REVAL_EVENT_ID', trans_reval_event_id_ , attr_);
                  Client_SYS.Add_To_Attr('INCLUDE_AS_DEMAND_DB', so_rec_.include_as_demand, attr_);
                  Client_SYS.Add_To_Attr('INCLUDE_AS_SUPPLY_DB', so_rec_.include_as_supply, attr_);
                  description_ := Language_SYS.Translate_Constant(lu_name_, 'CLOSE_SO: Close Open Shop Order from Transaction Revaluation');
                  Transaction_SYS.Deferred_Call('TRANSACTION_REVALUATION_API.Close_Shop_Order__', attr_, description_);
               END IF;
           END LOOP;
        END;
      END IF;
   $ELSE
      NULL;   
   $END    
END Process_Updated_Shop_Orders___;


-- Process_Intersite_Transfers___
--   Continue the cascade process starting with the receipt side of
--   intersite transactions.
PROCEDURE Process_Intersite_Transfers___ (
   revaluation_is_impossible_  IN OUT BOOLEAN,
   transaction_update_counter_ IN OUT NUMBER,
   source_contract_            IN     VARCHAR2,
   company_                    IN     VARCHAR2,
   trans_reval_event_id_       IN     NUMBER,
   transfer_trans_tab_         IN     Trans_List_Tab )
IS
   dst_transaction_id_           inventory_transaction_hist_tab.transaction_id%TYPE;
   src_transaction_id_           inventory_transaction_hist_tab.transaction_id%TYPE;
   viable_posting_date_contract_ inventory_transaction_hist_tab.contract%TYPE;
   src_trans_rec_                Inventory_Transaction_Hist_API.Public_Rec;
   dst_trans_rec_                Inventory_Transaction_Hist_API.Public_Rec;
   dst_cost_detail_tab_          Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;

   new_cascade_trans_tab_        Intersite_Trans_List_Tab;
   force_add_                    BOOLEAN;
   src_cost_detail_tab_          Inventory_Part_Unit_Cost_API.Cost_Detail_Tab; 
   date_applied_                 DATE;
   first_viable_posting_date_    DATE;
BEGIN

   FOR i_ IN transfer_trans_tab_.FIRST..transfer_trans_tab_.LAST LOOP
      src_transaction_id_ := transfer_trans_tab_(i_).transaction_id;

      dst_transaction_id_ := Invent_Trans_Interconnect_API.Get_Connected_Transaction_Id(
                                                               src_transaction_id_,
                                                               'INTERSITE TRANSFER');

      src_trans_rec_ := Inventory_Transaction_Hist_API.Get(src_transaction_id_);
      dst_trans_rec_ := Inventory_Transaction_Hist_API.Get(dst_transaction_id_);

      IF ((dst_trans_rec_.inventory_valuation_method = 'AV') OR
          ((dst_trans_rec_.inventory_valuation_method = 'ST') AND
           (dst_trans_rec_.inventory_part_cost_level = 'COST PER SERIAL'))) THEN
         
         src_cost_detail_tab_ := Inventory_Transaction_Cost_API.Get_Transaction_Cost_Details(src_transaction_id_);

         -- Update the receipt transactions on the receiving site. 
         -- All these should be updated before the cascade is continued on the destination site(s).
         dst_cost_detail_tab_ := Inventory_Part_In_Stock_API.Transform_Cost_Details(
                                                       source_contract_,
                                                       src_cost_detail_tab_,
                                                       dst_trans_rec_.contract,
                                                       dst_trans_rec_.inventory_valuation_method,
                                                       dst_trans_rec_.inventory_part_cost_level);                                                       
         -- Unit cost should be converted.
         IF (dst_cost_detail_tab_.COUNT > 0) THEN
            FOR i_ IN dst_cost_detail_tab_.FIRST..dst_cost_detail_tab_.LAST LOOP
               dst_cost_detail_tab_(i_).unit_cost := ((dst_cost_detail_tab_(i_).unit_cost * src_trans_rec_.quantity)/dst_trans_rec_.quantity);
            END LOOP;
         END IF;
         -- Update cost of the connected receipt transaction
         Inventory_Transaction_Hist_API.Set_Cost(dst_transaction_id_, dst_cost_detail_tab_);

         IF (Validate_SYS.Is_Different(dst_trans_rec_.contract, viable_posting_date_contract_)) THEN
            first_viable_posting_date_    := Site_Invent_Info_API.Get_First_Viable_Posting_Date(dst_trans_rec_.contract);
            viable_posting_date_contract_ := dst_trans_rec_.contract;
         END IF;

         date_applied_ := GREATEST(dst_trans_rec_.date_applied, first_viable_posting_date_);

         Do_Value_Adjustment_Booking___(dst_transaction_id_, company_, date_applied_, trans_reval_event_id_);

         -- If the valuation method or cost level on the destination site is not the same as on the
         -- current site then a new cascade on the receiving site should be started for every receipt.
         -- If the attributes have the same values then it is enough to start the cascade from the first receipt.
         IF ((dst_trans_rec_.inventory_valuation_method != src_trans_rec_.inventory_valuation_method) OR
             (dst_trans_rec_.inventory_part_cost_level != src_trans_rec_.inventory_part_cost_level)) THEN
            force_add_ := TRUE;
         ELSE
            force_add_ := FALSE;
         END IF;
         
         -- Add the transaction to the list for continued cascade if needed.
         -- When force_add_ = FALSE only the first transfer to each new site will be added to the list.
         Add_Intersite_Trans_To_List___(new_cascade_trans_tab_,
                                        force_add_,
                                        dst_transaction_id_,
                                        src_transaction_id_,
                                        dst_trans_rec_.contract,
                                        dst_trans_rec_.lot_batch_no,
                                        dst_trans_rec_.inventory_part_cost_level);

      END IF;
   END LOOP;

   IF (new_cascade_trans_tab_.COUNT > 0) THEN
      -- Now initiate the cascade for the transfer transaction made to each site
      FOR i_ IN new_cascade_trans_tab_.FIRST..new_cascade_trans_tab_.LAST LOOP

         src_transaction_id_ := new_cascade_trans_tab_(i_).src_transaction_id;
         dst_transaction_id_ := new_cascade_trans_tab_(i_).dst_transaction_id;
         
         src_trans_rec_ := Inventory_Transaction_Hist_API.Get(src_transaction_id_);
         dst_trans_rec_ := Inventory_Transaction_Hist_API.Get(dst_transaction_id_);

         -- Retrieve the cost details again for the source transaction. 
         -- If the valuation method or cost level differ between the source and the destination site then
         -- a separate cascade will be triggered on the destination site for each receipt. 
         -- If there are transactions moving parts back again to the source site these could have updated
         -- the cost details for later intersite transactions on the source site.
         src_cost_detail_tab_ := Inventory_Transaction_Cost_API.Get_Transaction_Cost_Details(src_transaction_id_);
 
         dst_cost_detail_tab_ := Inventory_Part_In_Stock_API.Transform_Cost_Details(
                                                       source_contract_,
                                                       src_cost_detail_tab_,
                                                       dst_trans_rec_.contract,
                                                       dst_trans_rec_.inventory_valuation_method,
                                                       dst_trans_rec_.inventory_part_cost_level);                                                       
         -- Unit cost should be converted.
         IF (dst_cost_detail_tab_.COUNT > 0) THEN
            FOR i_ IN dst_cost_detail_tab_.FIRST..dst_cost_detail_tab_.LAST LOOP
               dst_cost_detail_tab_(i_).unit_cost := ((dst_cost_detail_tab_(i_).unit_cost * src_trans_rec_.quantity)/dst_trans_rec_.quantity);
            END LOOP;
         END IF;
         -- when the destination transaction is RETDIR-SCP no need to revaluate the rest of the transactions in destination site
         -- as RETDIR-SCP transaction does not change the inventory cost.
         IF NOT(dst_trans_rec_.transaction_code IN ('RETDIR-SCP', 'RETDIFSSCP')) THEN

            IF (Validate_SYS.Is_Different(dst_trans_rec_.contract, viable_posting_date_contract_)) THEN
               first_viable_posting_date_    := Site_Invent_Info_API.Get_First_Viable_Posting_Date(dst_trans_rec_.contract);
               viable_posting_date_contract_ := dst_trans_rec_.contract;
            END IF;

            IF (dst_trans_rec_.inventory_valuation_method = 'AV') THEN
               -- The other site uses valuation method weighted average
               Revalue_Part_Transactions___(revaluation_is_impossible_  => revaluation_is_impossible_,
                                            transaction_update_counter_ => transaction_update_counter_,
                                            order_ref1_                 => NULL,
                                            order_ref2_                 => NULL,
                                            order_ref3_                 => NULL,
                                            order_ref4_                 => NULL,
                                            order_type_db_              => NULL,
                                            contract_                   => dst_trans_rec_.contract,
                                            part_no_                    => dst_trans_rec_.part_no,
                                            receipt_cost_               => NULL,
                                            invoice_price_              => NULL,
                                            company_                    => company_,
                                            first_viable_posting_date_  => first_viable_posting_date_,
                                            cost_detail_tab_            => dst_cost_detail_tab_,
                                            connected_receipt_trans_id_ => dst_transaction_id_,
                                            trans_reval_event_id_       => trans_reval_event_id_);
            ELSE 
               -- The other site is setup to use 'COST PER SERIAL'
               Start_Revalue_Serial_Trans___(revaluation_is_impossible_  => revaluation_is_impossible_,
                                             transaction_update_counter_ => transaction_update_counter_,
                                             order_ref1_                 => NULL,
                                             order_ref2_                 => NULL,
                                             order_ref3_                 => NULL,
                                             order_ref4_                 => NULL,
                                             order_type_db_              => NULL,
                                             contract_                   => dst_trans_rec_.contract,
                                             part_no_                    => dst_trans_rec_.part_no,
                                             serial_no_                  => dst_trans_rec_.serial_no,
                                             receipt_cost_               => NULL,
                                             invoice_price_              => NULL,
                                             cost_detail_tab_            => dst_cost_detail_tab_,
                                             company_                    => company_,
                                             first_viable_posting_date_  => first_viable_posting_date_,
                                             connected_receipt_trans_id_ => dst_transaction_id_,
                                             trans_reval_event_id_       => trans_reval_event_id_);
            END IF;
         END IF;

         EXIT WHEN revaluation_is_impossible_;
      END LOOP;
   END IF;
END Process_Intersite_Transfers___;


-- Process_Part_Changes___
--   Continue the cascade process starting with the receipt side of
--   transactions for part renaming.
PROCEDURE Process_Part_Changes___ (
   revaluation_is_impossible_  IN OUT BOOLEAN,
   transaction_update_counter_ IN OUT NUMBER,
   company_                    IN     VARCHAR2,
   trans_reval_event_id_       IN     NUMBER,
   part_change_trans_tab_      IN     Trans_List_Tab )
IS
   connected_trans_id_           inventory_transaction_hist_tab.transaction_id%TYPE;
   viable_posting_date_contract_ inventory_transaction_hist_tab.contract%TYPE;
   dst_trans_rec_                Inventory_Transaction_Hist_API.Public_Rec;
   src_cost_detail_tab_          Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   first_viable_posting_date_    DATE;
BEGIN

   FOR i_ IN part_change_trans_tab_.FIRST..part_change_trans_tab_.LAST LOOP
      connected_trans_id_ := Invent_Trans_Interconnect_API.Get_Connected_Transaction_Id(
                                                               part_change_trans_tab_(i_).transaction_id,
                                                               'RENAME SERIAL');
      dst_trans_rec_ := Inventory_Transaction_Hist_API.Get(connected_trans_id_);

      IF ((dst_trans_rec_.inventory_valuation_method = 'AV') OR
          ((dst_trans_rec_.inventory_valuation_method = 'ST') AND
           (dst_trans_rec_.inventory_part_cost_level = 'COST PER SERIAL'))) THEN
         src_cost_detail_tab_ := Inventory_Transaction_Cost_API.Get_Transaction_Cost_Details(part_change_trans_tab_(i_).transaction_id);

         IF (Validate_SYS.Is_Different(dst_trans_rec_.contract, viable_posting_date_contract_)) THEN
            first_viable_posting_date_    := Site_Invent_Info_API.Get_First_Viable_Posting_Date(dst_trans_rec_.contract);
            viable_posting_date_contract_ := dst_trans_rec_.contract;
         END IF;

         IF (dst_trans_rec_.inventory_valuation_method = 'AV') THEN
            -- The renamed-to part is setup for valuation method weighted average
            Revalue_Part_Transactions___(revaluation_is_impossible_  => revaluation_is_impossible_,
                                         transaction_update_counter_ => transaction_update_counter_,
                                         order_ref1_                 => NULL,
                                         order_ref2_                 => NULL,
                                         order_ref3_                 => NULL,
                                         order_ref4_                 => NULL,
                                         order_type_db_              => NULL,
                                         contract_                   => dst_trans_rec_.contract,
                                         part_no_                    => dst_trans_rec_.part_no,
                                         receipt_cost_               => NULL,
                                         invoice_price_              => NULL,
                                         company_                    => company_,
                                         first_viable_posting_date_  => first_viable_posting_date_,
                                         cost_detail_tab_            => src_cost_detail_tab_,
                                         connected_receipt_trans_id_ => connected_trans_id_,
                                         trans_reval_event_id_       => trans_reval_event_id_);
         ELSE
            -- The renamed-to part is setup for valuation method use 'COST PER SERIAL'
            Start_Revalue_Serial_Trans___(revaluation_is_impossible_  => revaluation_is_impossible_,
                                          transaction_update_counter_ => transaction_update_counter_,
                                          order_ref1_                 => NULL,
                                          order_ref2_                 => NULL,
                                          order_ref3_                 => NULL,
                                          order_ref4_                 => NULL,
                                          order_type_db_              => NULL,
                                          contract_                   => dst_trans_rec_.contract,
                                          part_no_                    => dst_trans_rec_.part_no,
                                          serial_no_                  => dst_trans_rec_.serial_no,
                                          receipt_cost_               => NULL,
                                          invoice_price_              => NULL,
                                          cost_detail_tab_            => src_cost_detail_tab_,
                                          company_                    => company_,
                                          first_viable_posting_date_  => first_viable_posting_date_,
                                          connected_receipt_trans_id_ => connected_trans_id_,
                                          trans_reval_event_id_       => trans_reval_event_id_);
         END IF;
         EXIT WHEN revaluation_is_impossible_;
      END IF;
   END LOOP;
END Process_Part_Changes___;

PROCEDURE Make_Price_Diff_Transaction___ (
   order_no_                     IN VARCHAR2,
   line_no_                      IN VARCHAR2,
   release_no_                   IN VARCHAR2,
   receipt_no_                   IN NUMBER,
   sequence_no_                  IN NUMBER,
   order_type_db_                IN VARCHAR2,
   contract_                     IN VARCHAR2,
   part_no_                      IN VARCHAR2,
   company_                      IN VARCHAR2,
   invoice_qty_                  IN NUMBER,
   price_diff_per_unit_          IN NUMBER,
   trans_reval_event_id_         IN NUMBER,
   unit_cost_invoice_curr_       IN NUMBER,
   invoice_curr_code_            IN VARCHAR2,
   unit_cost_in_receipt_curr_    IN NUMBER,
   receipt_curr_code_            IN VARCHAR2 )

IS   
   transaction_value_            NUMBER;   
   transaction_code_             INVENTORY_TRANSACTION_HIST_TAB.transaction_code%TYPE;
   trans_amount_invoice_curr_    NUMBER;
   curr_transaction_code_        INVENTORY_TRANSACTION_HIST_TAB.transaction_code%TYPE;
   
BEGIN
   
   transaction_value_ := invoice_qty_ * price_diff_per_unit_;
   trans_amount_invoice_curr_ := invoice_qty_ * unit_cost_invoice_curr_;
   
   IF (transaction_value_ > 0) THEN
      -- Generate different transactions based on if the cascade was triggered by a charge invoice or a normal receipt invoice
      IF (sequence_no_ IS NULL) THEN
         transaction_code_ := 'PRICEDIFF+';
      ELSE
         transaction_code_ := 'CHGPRDIFF+';
      END IF;
   ELSIF (transaction_value_ < 0) THEN
      IF (sequence_no_ IS NULL) THEN
         transaction_code_ := 'PRICEDIFF-';
      ELSE
         transaction_code_ := 'CHGPRDIFF-';
      END IF;
   END IF;
   
   IF (trans_amount_invoice_curr_ > 0) THEN
      -- Generate different transactions based on if the cascade was triggered by a charge invoice or a normal receipt invoice
      IF (sequence_no_ IS NULL) THEN
         curr_transaction_code_ := 'PRICEDIFF+';
      ELSE
         curr_transaction_code_ := 'CHGPRDIFF+';
      END IF;
   ELSIF (trans_amount_invoice_curr_ < 0) THEN
      IF (sequence_no_ IS NULL) THEN
         curr_transaction_code_ := 'PRICEDIFF-';
      ELSE
         curr_transaction_code_ := 'CHGPRDIFF-';
      END IF;
   END IF;

   IF (transaction_value_ != 0 OR trans_amount_invoice_curr_ != 0 ) THEN
      Inventory_Transaction_Hist_API.Make_Po_Line_Diff_Transaction (order_no_,
                                                                    line_no_, 
                                                                    release_no_,
                                                                    receipt_no_,
                                                                    order_type_db_,
                                                                    contract_,
                                                                    part_no_,
                                                                    company_,
                                                                    invoice_qty_,
                                                                    price_diff_per_unit_,
                                                                    transaction_code_,
                                                                    trans_reval_event_id_,
                                                                    unit_cost_invoice_curr_,
                                                                    curr_transaction_code_,
                                                                    invoice_curr_code_,
                                                                    unit_cost_in_receipt_curr_,
                                                                    receipt_curr_code_);

   END IF;                                

END Make_Price_Diff_Transaction___;

PROCEDURE Make_Bal_Invoic_Transaction___ (
   order_no_                  IN VARCHAR2,
   line_no_                   IN VARCHAR2,
   release_no_                IN VARCHAR2,
   receipt_no_                IN NUMBER,
   order_type_db_             IN VARCHAR2,
   contract_                  IN VARCHAR2,
   part_no_                   IN VARCHAR2,
   company_                   IN VARCHAR2,
   purch_receipt_cost_        IN NUMBER,
   avg_inv_price_in_inv_curr_ IN NUMBER,
   unit_charge_               IN NUMBER,
   exchange_cost_             IN NUMBER,
   external_direct_delivery_  IN BOOLEAN,
   trans_reval_event_id_      IN NUMBER,
   invoice_curr_code_         IN VARCHAR2,
   unit_cost_in_receipt_curr_ IN NUMBER,
   receipt_curr_code_         IN VARCHAR2 )

IS   
BEGIN
   Inventory_Transaction_Hist_API.Make_Po_Invoice_Balance_Trans(order_no_,
                                                                line_no_, 
                                                                release_no_, 
                                                                receipt_no_,
                                                                order_type_db_,
                                                                contract_,
                                                                part_no_,
                                                                company_,
                                                                purch_receipt_cost_,
                                                                avg_inv_price_in_inv_curr_,
                                                                unit_charge_,
                                                                exchange_cost_,
                                                                external_direct_delivery_,
                                                                trans_reval_event_id_,
                                                                invoice_curr_code_,
                                                                unit_cost_in_receipt_curr_,
                                                                receipt_curr_code_,
                                                                'BALINVOIC+',
                                                                'BALINVOIC-',                                                                
                                                                NULL);
END Make_Bal_Invoic_Transaction___;

-- Rma_Return_To_Inventory___
--   This method decides if a given transaction code is performing
--   an RMA return to the inventory.
FUNCTION Rma_Return_To_Inventory___ (
   transaction_type_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   return_to_inventory_ BOOLEAN := FALSE;
BEGIN
   IF (transaction_type_ = 'RMA RETURN TO INVENTORY') THEN
      return_to_inventory_ := TRUE;
   END IF;
   RETURN (return_to_inventory_);
END Rma_Return_To_Inventory___;


-- Rma_Return_And_Scrap___
--   This method decides if a given transaction code is performing
--   an RMA scrap return.
FUNCTION Rma_Return_And_Scrap___ (
   transaction_type_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   return_and_scrap_ BOOLEAN := FALSE;
BEGIN
   IF (transaction_type_ = 'RMA RETURN AND SCRAP') THEN
      return_and_scrap_ := TRUE;
   END IF;
   RETURN (return_and_scrap_);
END Rma_Return_And_Scrap___;


-- Revalue_Return_To_Inventory___
--   Calculates and set new transaction cost and create additional postings
--   for a transaction that returns to inventory.
PROCEDURE Revalue_Return_To_Inventory___ (
   revaluation_is_impossible_    IN OUT BOOLEAN,
   weighted_avg_cost_detail_tab_ IN OUT Inventory_Part_Unit_Cost_API.Cost_Detail_Tab,
   transaction_id_               IN     NUMBER,
   transaction_qty_              IN     NUMBER,
   prior_average_qty_            IN     NUMBER,
   contract_                     IN     VARCHAR2,
   part_no_                      IN     VARCHAR2,
   configuration_id_             IN     VARCHAR2,
   lot_batch_no_                 IN     VARCHAR2,
   condition_code_               IN     VARCHAR2,
   rma_no_                       IN     VARCHAR2,
   rma_line_no_                  IN     NUMBER,
   transaction_code_             IN     VARCHAR2,
   company_                      IN     VARCHAR2,
   date_applied_                 IN     DATE,
   trans_reval_event_id_         IN     NUMBER )
IS
   prior_avg_cost_detail_tab_    Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   return_trans_cost_detail_tab_ Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
BEGIN

   IF (prior_average_qty_ IS NULL) THEN
      revaluation_is_impossible_ := TRUE;
      RETURN;
   END IF;

   Pre_Invent_Trans_Avg_Cost_API.Replace_Cost_Details(transaction_id_,
                                                      weighted_avg_cost_detail_tab_);
   prior_avg_cost_detail_tab_ := weighted_avg_cost_detail_tab_;

   return_trans_cost_detail_tab_ := Inventory_Transaction_Hist_API.Get_Customer_Return_Cost(
                                                                               contract_        ,
                                                                               part_no_         ,
                                                                               configuration_id_,
                                                                               lot_batch_no_    ,
                                                                               NULL             ,
                                                                               condition_code_  ,
                                                                               rma_no_          ,
                                                                               rma_line_no_     ,
                                                                               transaction_code_ );

   Inventory_Transaction_Hist_API.Set_Cost(transaction_id_, return_trans_cost_detail_tab_);

   Do_Value_Adjustment_Booking___(transaction_id_, company_, date_applied_, trans_reval_event_id_);

   return_trans_cost_detail_tab_ := Inventory_Transaction_Cost_API.Get_Transaction_Cost_Details(
                                                                                  transaction_id_);

   weighted_avg_cost_detail_tab_ := Inventory_Part_Unit_Cost_API.Get_Weighted_Avg_Cost_Details(
                                                                     weighted_avg_cost_detail_tab_,
                                                                     return_trans_cost_detail_tab_,
                                                                     prior_average_qty_,
                                                                     transaction_qty_);

   -- There could be a need to create 'TRANSIBAL' postings to balance the
   -- inventory and transit accounts
   Inventory_Transaction_Hist_API.Balance_Transit_And_Invent_Acc(transaction_id_,
                                                                 prior_avg_cost_detail_tab_,
                                                                 weighted_avg_cost_detail_tab_,
                                                                 value_adjustment_     => TRUE,
                                                                 per_oh_adjustment_id_ => NULL,
                                                                 trans_reval_event_id_ => trans_reval_event_id_,
                                                                 date_applied_         => date_applied_);
END Revalue_Return_To_Inventory___;


-- Revalue_Return_And_Scrap___
--   Calculates and set new transaction cost and create additional postings
--   for a transaction that returns and scraps.
PROCEDURE Revalue_Return_And_Scrap___ (
   transaction_id_               IN NUMBER,
   contract_                     IN VARCHAR2,
   part_no_                      IN VARCHAR2,
   configuration_id_             IN VARCHAR2,
   lot_batch_no_                 IN VARCHAR2,
   condition_code_               IN VARCHAR2,
   rma_no_                       IN VARCHAR2,
   rma_line_no_                  IN NUMBER,
   transaction_code_             IN VARCHAR2,
   company_                      IN VARCHAR2,
   date_applied_                 IN DATE,
   trans_reval_event_id_         IN NUMBER )
IS
   return_trans_cost_detail_tab_ Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
BEGIN

   return_trans_cost_detail_tab_ := Inventory_Transaction_Hist_API.Get_Customer_Return_Cost(
                                                                               contract_        ,
                                                                               part_no_         ,
                                                                               configuration_id_,
                                                                               lot_batch_no_    ,
                                                                               NULL             ,
                                                                               condition_code_  ,
                                                                               rma_no_          ,
                                                                               rma_line_no_     ,
                                                                               transaction_code_ );

   Inventory_Transaction_Hist_API.Set_Cost(transaction_id_, return_trans_cost_detail_tab_);

   Do_Value_Adjustment_Booking___(transaction_id_, company_, date_applied_, trans_reval_event_id_);

END Revalue_Return_And_Scrap___;


-- Cost_Details_Equal___
--   Checks if the specified cost details are the same as the ones currently
--   set on the specified transaction.
FUNCTION Cost_Details_Equal___ (
   transaction_id_  IN NUMBER,
   cost_detail_tab_ IN Inventory_Part_Unit_Cost_API.Cost_Detail_Tab ) RETURN BOOLEAN
IS
   trans_cost_detail_tab_ Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   pos_cost_diff_tab_     Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   neg_cost_diff_tab_     Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;

   ret_val_ BOOLEAN := TRUE;
BEGIN
   trans_cost_detail_tab_ := Inventory_Transaction_Cost_API.Get_Transaction_Cost_Details(transaction_id_);

   Inventory_Part_Unit_Cost_API.Create_Cost_Diff_Tables(pos_cost_diff_tab_,
                                                        neg_cost_diff_tab_,
                                                        trans_cost_detail_tab_,
                                                        cost_detail_tab_);
   IF ((pos_cost_diff_tab_.COUNT > 0) OR (neg_cost_diff_tab_.COUNT > 0)) THEN
      ret_val_ := FALSE;
   END IF;

   RETURN ret_val_;

END Cost_Details_Equal___;


-- Add_Intersite_Trans_To_List___
--   Adds a new intersite transaction to the new_cascade_trans_tab_ if the
--   receiving site is not already included in the list.
--   If the force_add_ parameter is TRUE the transaction will always be added.
PROCEDURE Add_Intersite_Trans_To_List___ (
   new_cascade_trans_tab_        IN OUT Intersite_Trans_List_Tab,
   force_add_                    IN     BOOLEAN,
   dst_transaction_id_           IN     NUMBER,
   src_transaction_id_           IN     NUMBER,
   dst_site_                     IN     VARCHAR2,
   lot_batch_no_                 IN     VARCHAR2,
   inventory_part_cost_level_db_ IN     VARCHAR2 ) 
IS
   already_added_ BOOLEAN := FALSE;
   n_             NUMBER;
BEGIN

   IF (new_cascade_trans_tab_.COUNT = 0) THEN
      new_cascade_trans_tab_(1).dst_transaction_id := dst_transaction_id_;
      new_cascade_trans_tab_(1).src_transaction_id := src_transaction_id_;
      new_cascade_trans_tab_(1).dst_site           := dst_site_; 
      new_cascade_trans_tab_(1).lot_batch_no       := lot_batch_no_;
   ELSE
      IF NOT force_add_ THEN
         -- Make sure the destination site is not already in the list.If part cost level = 'COST PER LOT BATCH' 
         -- the lot_batch_no should also be checked since a separate cascade should be done for each lot.
         FOR i_ IN new_cascade_trans_tab_.FIRST..new_cascade_trans_tab_.LAST LOOP
            IF (new_cascade_trans_tab_(i_).dst_site = dst_site_) THEN
               IF ((inventory_part_cost_level_db_ != 'COST PER LOT BATCH') OR (new_cascade_trans_tab_(i_).lot_batch_no = lot_batch_no_)) THEN
                  already_added_ := TRUE;
                  EXIT;
               END IF;
            END IF;
         END LOOP;
      END IF;
      -- Add transaction to list
      IF ((NOT already_added_) OR force_add_) THEN
         n_ := new_cascade_trans_tab_.LAST + 1;
         new_cascade_trans_tab_(n_).dst_transaction_id := dst_transaction_id_;
         new_cascade_trans_tab_(n_).src_transaction_id := src_transaction_id_;
         new_cascade_trans_tab_(n_).dst_site           := dst_site_;
         new_cascade_trans_tab_(n_).lot_batch_no       := lot_batch_no_;
      END IF;
   END IF;
END Add_Intersite_Trans_To_List___;


FUNCTION Return_To_Supplier___ (
   transaction_type_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   return_to_supplier_ BOOLEAN := FALSE;
BEGIN
   IF (transaction_type_ = 'RETURN TO SUPPLIER') THEN
      return_to_supplier_ := TRUE;
   END IF;
   RETURN (return_to_supplier_);
END Return_To_Supplier___;

PROCEDURE Revalue_Return_To_Supplier___ (
   weighted_avg_cost_detail_tab_ IN OUT Inventory_Part_Unit_Cost_API.Cost_Detail_Tab,
   transaction_id_               IN     NUMBER,
   prior_average_qty_            IN     NUMBER,
   transaction_qty_              IN     NUMBER,
   order_ref1_                   IN     VARCHAR2, 
   order_ref2_                   IN     VARCHAR2, 
   order_ref3_                   IN     VARCHAR2,
   order_ref4_                   IN     NUMBER,
   company_                      IN     VARCHAR2,
   date_applied_                 IN     DATE,
   trans_reval_event_id_         IN     NUMBER,
   receipt_curr_code_            IN     VARCHAR2,
   invoice_curr_code_            IN     VARCHAR2,
   avg_inv_price_in_inv_curr_    IN     NUMBER, 
   avg_chg_value_in_inv_curr_    IN     NUMBER,
   accounting_id_                IN     NUMBER,
   contract_                     IN     VARCHAR2,
   unit_cost_in_receipt_curr_    IN     NUMBER)

IS
   calc_transaction_qty_          NUMBER;
   prior_avg_cost_detail_tab_     Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   arrival_trans_cost_detail_tab_ Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   dummy_                         NUMBER;
BEGIN

   IF (prior_average_qty_ IS NULL) THEN
      -- The purpose of this section is to handle return transactions created before patch 77408 was applied.
      Revalue_Other_Transaction___(weighted_avg_cost_detail_tab_,
                                   transaction_id_,
                                   company_,
                                   date_applied_,
                                   trans_reval_event_id_);
   ELSE
      Pre_Invent_Trans_Avg_Cost_API.Replace_Cost_Details(transaction_id_,
                                                         weighted_avg_cost_detail_tab_);

      prior_avg_cost_detail_tab_ := weighted_avg_cost_detail_tab_;

      Inventory_Transaction_Hist_API.Get_Supplier_Return_Cost(dummy_,
                                                              arrival_trans_cost_detail_tab_,
                                                              order_ref1_,
                                                              order_ref2_,
                                                              order_ref3_,
                                                              order_ref4_,
                                                              include_reversed_transactions_ => TRUE);

      Inventory_Transaction_Hist_API.Set_Cost(transaction_id_, arrival_trans_cost_detail_tab_);

      Do_Value_Adjustment_Booking___(transaction_id_, company_, date_applied_, trans_reval_event_id_);
      IF (avg_chg_value_in_inv_curr_ IS NULL) THEN         
         -- currency diff posting for returns is only needed for parts but not charges. avg_chg_value_in_inv_curr_ is NOT NULL means charge posting is done. 
         Mpccom_Accounting_API.Do_Curr_Amt_Balance_Posting(company_                   => company_,
                                                           accounting_id_             => accounting_id_,
                                                           contract_                  => contract_,
                                                           quantity_arrived_          => transaction_qty_,
                                                           trans_reval_event_id_      => trans_reval_event_id_,
                                                           receipt_curr_code_         => receipt_curr_code_,
                                                           invoice_curr_code_         => invoice_curr_code_,
                                                           avg_inv_price_in_inv_curr_ => avg_inv_price_in_inv_curr_,
                                                           avg_chg_value_in_inv_curr_ => avg_chg_value_in_inv_curr_,
                                                           unit_cost_in_receipt_curr_ => unit_cost_in_receipt_curr_,
                                                           date_posted_               => date_applied_);
      END IF;

      calc_transaction_qty_ := transaction_qty_ * -1;

      IF (prior_average_qty_ + calc_transaction_qty_ != 0) THEN
         -- Since there is stock left after this transaction we can recalculate a new WA and pass it on to the next transaction.
         -- If no stock is left after the return then adjustment bookings will be created by method Reval_Wa_At_Empty_Inventory___
         -- in package Inventory_Transaction_Hist_API. the call is handled automatically when postings are created. 
         weighted_avg_cost_detail_tab_ := Inventory_Part_Unit_Cost_API.Get_Weighted_Avg_Cost_Details(
                                                                           weighted_avg_cost_detail_tab_,
                                                                           arrival_trans_cost_detail_tab_,
                                                                           prior_average_qty_,
                                                                           calc_transaction_qty_);
      END IF;
      -- There could be a need to create 'TRANSIBAL' postings to balance the
      -- inventory and transit accounts
      Inventory_Transaction_Hist_API.Balance_Transit_And_Invent_Acc(transaction_id_,
                                                                    prior_avg_cost_detail_tab_,
                                                                    weighted_avg_cost_detail_tab_,
                                                                    value_adjustment_     => TRUE,
                                                                    per_oh_adjustment_id_ => NULL,
                                                                    trans_reval_event_id_ => trans_reval_event_id_,
                                                                    date_applied_         => date_applied_);
   END IF;
END Revalue_Return_To_Supplier___;


FUNCTION Get_Sorted_Shop_Ord_Ref_Tab___ (
   shop_ord_ref_tab_ IN Shop_Ord_Ref_Tab) RETURN Shop_Ord_Ref_Tab
IS
   sorted_shop_ord_ref_tab_ Shop_Ord_Ref_Tab;

   CURSOR get_shop_order_info IS
      SELECT order_no, release_no, sequence_no
        FROM trans_reval_shop_ord_ref_tmp
    ORDER BY order_no, release_no, sequence_no;

BEGIN

   DELETE FROM trans_reval_shop_ord_ref_tmp;

   FORALL i_ IN shop_ord_ref_tab_.FIRST..shop_ord_ref_tab_.LAST
   INSERT INTO trans_reval_shop_ord_ref_tmp VALUES shop_ord_ref_tab_(i_);
   
   OPEN  get_shop_order_info;
   FETCH get_shop_order_info BULK COLLECT INTO sorted_shop_ord_ref_tab_;
   CLOSE get_shop_order_info;

   RETURN (sorted_shop_ord_ref_tab_);
END Get_Sorted_Shop_Ord_Ref_Tab___;


-- Cost_For_All_Receipts_Equal___
--   Checks if the specified cost details are the same as the ones for all the
--   receipt transactions of a particular MANUFACTURING RECEIPT.
FUNCTION Cost_For_All_Receipts_Equal___ (
   order_no_        IN VARCHAR2,
   release_no_      IN VARCHAR2,
   sequence_no_     IN VARCHAR2,
   order_type_db_   IN VARCHAR2,
   contract_        IN VARCHAR2,
   part_no_         IN VARCHAR2,
   cost_detail_tab_ IN Inventory_Part_Unit_Cost_API.Cost_Detail_Tab ) RETURN BOOLEAN
IS
   cost_for_all_receipts_equal_ BOOLEAN := TRUE;

   CURSOR get_receipt_trans_id IS
      SELECT transaction_id
        FROM INVENTORY_TRANSACTION_HIST_TAB ith, mpccom_transaction_code_pub mtc
       WHERE source_ref1                = order_no_
         AND source_ref2                = release_no_
         AND source_ref3                = sequence_no_
         AND source_ref_type            = order_type_db_
         AND contract                   = contract_
         AND part_no                    = part_no_
         AND ith.transaction_code       = mtc.transaction_code
         AND trans_based_reval_group_db = 'MANUFACTURING RECEIPT';
BEGIN

   FOR rec_ IN get_receipt_trans_id LOOP
      IF NOT (Cost_Details_Equal___(rec_.transaction_id, cost_detail_tab_)) THEN
         cost_for_all_receipts_equal_ := FALSE;
         EXIT;
      END IF;
   END LOOP;
   RETURN (cost_for_all_receipts_equal_);
END Cost_For_All_Receipts_Equal___;


----------------------------------------
-- Increase___
--   Increase the counter from 1.
----------------------------------------
PROCEDURE Increase___ (
   counter_ IN OUT NUMBER )
IS
BEGIN
   counter_ := counter_ + 1;
END Increase___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Close_Shop_Order__
--   Close a Shop Order in order to trigger upadates of the receipts made
PROCEDURE Close_Shop_Order__ (
   attr_ VARCHAR2 )
IS
   order_no_    VARCHAR2(12);
   release_no_  VARCHAR2(4);
   sequence_no_ VARCHAR2(4);
   trans_reval_event_id_ NUMBER;
   include_as_demand_db_ VARCHAR2(5);
   include_as_supply_db_ VARCHAR2(5);
BEGIN
   
   $IF (Component_Shpord_SYS.INSTALLED) $THEN
      order_no_    := Client_SYS.Get_Item_Value('ORDER_NO', attr_);
      release_no_  := Client_SYS.Get_Item_Value('RELEASE_NO', attr_);
      sequence_no_ := Client_SYS.Get_Item_Value('SEQUENCE_NO', attr_);
      trans_reval_event_id_ := Client_SYS.Get_Item_Value('CLOSED_BY_REVAL_EVENT_ID', attr_);
      include_as_demand_db_ := Client_SYS.Get_Item_Value('INCLUDE_AS_DEMAND_DB', attr_);
      include_as_supply_db_ := Client_SYS.Get_Item_Value('INCLUDE_AS_SUPPLY_DB', attr_);

      Shop_Ord_API.Set_Closed_By_Reval_Event_Id  (order_no_, release_no_, sequence_no_, trans_reval_event_id_);
      Shop_Ord_API.Set_Mrp_Include_Flags(order_no_, release_no_, sequence_no_, include_as_demand_db_, include_as_supply_db_);
      Shop_Ord_API.Close_Shop_Order(order_no_, release_no_, sequence_no_);
      Shop_Ord_API.Clear_Closed_By_Reval_Event_Id(order_no_, release_no_, sequence_no_);
   $ELSE
      NULL;   
   $END
   
END Close_Shop_Order__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Revalue_Trans_From_SO_Receipt
--   Revalue transactions when a Shop Order has been closed.
--   The revaluation process will start at the Shop Order receipt.
--   The new cost for the recipt transaction should be passed in the
--   cost_detail_tab_ parameter.
PROCEDURE Revalue_Trans_From_SO_Receipt (
   order_no_        IN VARCHAR2,
   release_no_      IN VARCHAR2,
   sequence_no_     IN VARCHAR2,
   line_item_no_    IN NUMBER,
   contract_        IN VARCHAR2,
   part_no_         IN VARCHAR2,
   cost_detail_tab_ IN Inventory_Part_Unit_Cost_API.Cost_Detail_Tab )
IS
   inv_part_rec_               Inventory_Part_API.Public_Rec;
   order_type_db_              VARCHAR2(20) := 'SHOP ORDER';
   company_                    VARCHAR2(20);
   first_viable_posting_date_  DATE;
   new_cost_detail_tab_        Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   revaluation_is_impossible_  BOOLEAN := FALSE;
   trans_reval_event_id_       NUMBER;
   transaction_update_counter_ NUMBER := 0;
BEGIN

   $IF Component_Shpord_SYS.INSTALLED $THEN
      trans_reval_event_id_ := Shop_Ord_API.Get_Closed_By_Reval_Event_Id(order_no_,
                                                                         release_no_,
                                                                         sequence_no_);
   $END

   IF (trans_reval_event_id_ IS NULL) THEN
      Trans_Reval_Event_API.New(event_id_            => trans_reval_event_id_,
                                part_no_             => part_no_,
                                contract_            => contract_,
                                shpord_order_no_     => order_no_,
                                shpord_release_no_   => release_no_,
                                shpord_sequence_no_  => sequence_no_,
                                shpord_line_item_no_ => line_item_no_);
   END IF;

   IF (Trans_Reval_Event_Shpord_API.Check_Exist(trans_reval_event_id_,
                                                order_no_,
                                                release_no_,
                                                sequence_no_)) THEN
      -- Loop Detected. The same Shop Order is processed once again for the same event ID.
      revaluation_is_impossible_ := TRUE;
   ELSE
      Trans_Reval_Event_Shpord_API.New(trans_reval_event_id_,
                                       order_no_,
                                       release_no_,
                                       sequence_no_,
                                       Site_API.Get_Site_Date(contract_));
   END IF;

   @ApproveTransactionStatement(2012-01-25,GanNLK)
   SAVEPOINT before_processing_transactions;

   --             from Revalue_Part_Transactions___ and Revalue_All_Serial_Trans___ is properly considered when rollback is performed.
   IF NOT (revaluation_is_impossible_) THEN
      -- If revaluation was possible
      new_cost_detail_tab_       := cost_detail_tab_;
      company_                   := Site_API.Get_Company(contract_);
      first_viable_posting_date_ := Site_Invent_Info_API.Get_First_Viable_Posting_Date(contract_);

      -- Take care of the special case when there where no manufacturing costs
      IF (new_cost_detail_tab_.COUNT = 0) THEN
         new_cost_detail_tab_(1).accounting_year := '*';
         new_cost_detail_tab_(1).contract        := contract_;
         new_cost_detail_tab_(1).cost_bucket_id  := '*';
         new_cost_detail_tab_(1).company         := company_;
         new_cost_detail_tab_(1).cost_source_id  := '*';
         new_cost_detail_tab_(1).unit_cost       := 0;
      END IF;

      -- Check the valuation method and part cost level to determine which type
      -- of revaluation to execute
      inv_part_rec_ := Inventory_Part_API.Get(contract_, part_no_);
      IF (inv_part_rec_.inventory_valuation_method = 'AV') THEN
         Revalue_Part_Transactions___(revaluation_is_impossible_  => revaluation_is_impossible_,
                                      transaction_update_counter_ => transaction_update_counter_,
                                      order_ref1_                 => order_no_,
                                      order_ref2_                 => release_no_,
                                      order_ref3_                 => sequence_no_,
                                      order_ref4_                 => line_item_no_,
                                      order_type_db_              => order_type_db_,
                                      contract_                   => contract_,
                                      part_no_                    => part_no_,
                                      receipt_cost_               => NULL,
                                      invoice_price_              => NULL,
                                      company_                    => company_,
                                      first_viable_posting_date_  => first_viable_posting_date_,
                                      cost_detail_tab_            => new_cost_detail_tab_,
                                      connected_receipt_trans_id_ => NULL,
                                      trans_reval_event_id_       => trans_reval_event_id_);
      ELSIF (inv_part_rec_.inventory_part_cost_level = 'COST PER SERIAL') THEN
         Revalue_All_Serial_Trans___(revaluation_is_impossible_  => revaluation_is_impossible_,
                                     transaction_update_counter_ => transaction_update_counter_,
                                     order_ref1_                 => order_no_,
                                     order_ref2_                 => release_no_,
                                     order_ref3_                 => sequence_no_,
                                     order_ref4_                 => line_item_no_,
                                     order_type_db_              => order_type_db_,
                                     contract_                   => contract_,
                                     part_no_                    => part_no_,
                                     receipt_cost_               => NULL,
                                     invoice_price_              => NULL,
                                     cost_detail_tab_            => new_cost_detail_tab_,
                                     company_                    => company_,
                                     first_viable_posting_date_  => first_viable_posting_date_,
                                     trans_reval_event_id_       => trans_reval_event_id_);
      END IF;
   END IF;
   
   IF (revaluation_is_impossible_) THEN
      -- If revaluation was not possible create variance postings on the SO
      @ApproveTransactionStatement(2012-01-25,GanNLK)
      ROLLBACK TO before_processing_transactions;

      Handle_Shpord_Wip_Variance___(order_no_,
                                    release_no_,
                                    sequence_no_);
   END IF;   
   
   Trans_Reval_Event_API.Finish(trans_reval_event_id_,
                                revaluation_is_impossible_,
                                transaction_update_counter_);
END Revalue_Trans_From_SO_Receipt;

--------------------------------------------------------------------------
-- Revalue_Trans_From_PO_Receipt
--   Revalue transactions when a Purchase Order invoice has been created.
--   The revaluation process will start at the Purchase Order receipt.
--   The new receipt cost (including component or exchange costs)
--   and the average invoice price per inventory unit for all invoices
--   created so far should be passed in as parameters to the method.
---------------------------------------------------------------------------
PROCEDURE Revalue_Trans_From_PO_Receipt (
   order_no_                     IN VARCHAR2,
   line_no_                      IN VARCHAR2,
   release_no_                   IN VARCHAR2,
   receipt_no_                   IN NUMBER,
   sequence_no_                  IN NUMBER,
   invoice_id_                   IN NUMBER,
   invoice_company_              IN VARCHAR2,
   contract_                     IN VARCHAR2,
   part_no_                      IN VARCHAR2,
   receipt_cost_                 IN NUMBER, 
   avg_inv_price_in_base_curr_   IN NUMBER,
   unit_charge_                  IN NUMBER,
   exchange_cost_                IN NUMBER,
   invoice_qty_                  IN NUMBER,
   price_diff_per_unit_          IN NUMBER,
   unit_cost_invoice_curr_       IN NUMBER,
   invoice_cancelled_            IN BOOLEAN,
   external_direct_delivery_     IN BOOLEAN,
   unit_cost_in_receipt_curr_    IN NUMBER,
   receipt_curr_code_            IN VARCHAR2,
   invoice_curr_code_            IN VARCHAR2,
   avg_inv_price_in_inv_curr_    IN NUMBER,
   avg_chg_value_in_inv_curr_    IN NUMBER )
IS
   CURSOR get_pricediff_for_receipt IS
      SELECT 1
      FROM INVENTORY_TRANSACTION_HIST_TAB
      WHERE source_ref1     = order_no_
      AND   source_ref2     = line_no_
      AND   source_ref3     = release_no_
      AND   source_ref4     = receipt_no_
      AND   source_ref_type = 'PUR ORDER'
      AND   transaction_code IN ('PRICEDIFF+', 'PRICEDIFF-', 'CHGPRDIFF+', 'CHGPRDIFF-');

   found_                       NUMBER;
   price_diff_exists_           BOOLEAN;
   inv_part_rec_                Inventory_Part_API.Public_Rec;
   empty_cost_detail_tab_       Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   order_type_db_               VARCHAR2(20) := 'PUR ORDER';
   company_                     VARCHAR2(20);
   revaluation_is_impossible_   BOOLEAN := FALSE;
   create_price_diff_on_purdir_ BOOLEAN;
   exit_procedure               EXCEPTION;
   trans_reval_event_id_        NUMBER;
   transaction_update_counter_  NUMBER := 0; 
   first_viable_posting_date_   DATE;
BEGIN

   Trace_SYS.Field('receipt_cost_', receipt_cost_);
   Trace_SYS.Field('avg_inv_price_in_base_curr_', avg_inv_price_in_base_curr_);
   Trace_SYS.Field('invoice_qty_', invoice_qty_);
   Trace_SYS.Field('price_diff_per_unit_', price_diff_per_unit_);
   Trace_SYS.Field('unit_cost_invoice_curr_', unit_cost_invoice_curr_);
   Trace_SYS.Field('avg_inv_price_in_inv_curr_ ', avg_inv_price_in_inv_curr_);
   
   Trans_Reval_Event_API.New(event_id_                   => trans_reval_event_id_,
                             part_no_                    => part_no_,
                             contract_                   => contract_,
                             purch_order_no_             => order_no_,
                             purch_line_no_              => line_no_,
                             purch_release_no_           => release_no_,
                             purch_receipt_no_           => receipt_no_,
                             purch_charge_sequence_no_   => sequence_no_,
                             invoice_id_                 => invoice_id_,
                             invoice_company_            => invoice_company_,
                             purch_receipt_cost_         => receipt_cost_,
                             average_invoice_price_      => avg_inv_price_in_base_curr_,
                             invoice_qty_                => invoice_qty_,
                             purch_price_diff_per_unit_  => price_diff_per_unit_,
                             supplier_invoice_cancelled_ => invoice_cancelled_,
                             external_direct_delivery_   => external_direct_delivery_);

   -- Check if a pricediff has previously been booked for this receipt.
   -- If this is the case there is not point in starting the revaluation
   -- process since it will fail again. Just book the new pricediff
   OPEN get_pricediff_for_receipt;
   FETCH get_pricediff_for_receipt INTO found_;
   IF get_pricediff_for_receipt%NOTFOUND THEN
      price_diff_exists_ := FALSE;
   ELSE
      price_diff_exists_ := TRUE;
   END IF;
   CLOSE get_pricediff_for_receipt;

   @ApproveTransactionStatement(2012-01-25,GanNLK)
   SAVEPOINT before_processing_transactions;

   company_                   := Site_API.Get_Company(contract_);
   first_viable_posting_date_ := Site_Invent_Info_API.Get_First_Viable_Posting_Date(contract_);
   
   IF (NOT price_diff_exists_) THEN
      -- First check if we are dealing with a receipt created for a
      -- direct delivery to an end customer.
      -- In this case the only transaction that can be updated will
      -- be the transaction created for the direct delivery.
      IF (external_direct_delivery_) THEN
         Revalue_Direct_Delivery___(create_price_diff_on_purdir_,
                                    revaluation_is_impossible_,
                                    transaction_update_counter_,
                                    order_no_,
                                    line_no_,
                                    release_no_,
                                    receipt_no_,
                                    sequence_no_,
                                    contract_,
                                    part_no_,
                                    receipt_cost_,
                                    company_,
                                    first_viable_posting_date_,
                                    invoice_qty_,
                                    price_diff_per_unit_,
                                    unit_cost_invoice_curr_,
                                    order_type_db_,
                                    trans_reval_event_id_,
                                    unit_cost_in_receipt_curr_,
                                    receipt_curr_code_,
                                    invoice_curr_code_,
                                    avg_inv_price_in_inv_curr_,
                                    avg_chg_value_in_inv_curr_);
         IF (create_price_diff_on_purdir_) THEN
            RAISE exit_procedure;
         END IF;
      ELSE
         -- Check the valuation method and part cost level to determine which type
         -- of revaluation to execute
         inv_part_rec_ := Inventory_Part_API.Get(contract_, part_no_);
         IF (inv_part_rec_.inventory_valuation_method = 'AV') THEN

            Revalue_Part_Transactions___(revaluation_is_impossible_  => revaluation_is_impossible_,
                                         transaction_update_counter_ => transaction_update_counter_,
                                         order_ref1_                 => order_no_,
                                         order_ref2_                 => line_no_,
                                         order_ref3_                 => release_no_,
                                         order_ref4_                 => receipt_no_,
                                         order_type_db_              => order_type_db_,
                                         contract_                   => contract_,
                                         part_no_                    => part_no_,
                                         receipt_cost_               => receipt_cost_,
                                         invoice_price_              => avg_inv_price_in_base_curr_,
                                         company_                    => company_,
                                         cost_detail_tab_            => empty_cost_detail_tab_,
                                         first_viable_posting_date_  => first_viable_posting_date_,
                                         connected_receipt_trans_id_ => NULL,
                                         trans_reval_event_id_       => trans_reval_event_id_,
                                         receipt_curr_code_          => receipt_curr_code_,
                                         invoice_curr_code_          => invoice_curr_code_,
                                         avg_inv_price_in_inv_curr_  => avg_inv_price_in_inv_curr_,
                                         avg_chg_value_in_inv_curr_  => avg_chg_value_in_inv_curr_,
                                         unit_cost_in_receipt_curr_  => unit_cost_in_receipt_curr_);

         ELSIF (inv_part_rec_.inventory_part_cost_level = 'COST PER SERIAL') THEN
            Revalue_All_Serial_Trans___(revaluation_is_impossible_  => revaluation_is_impossible_,
                                        transaction_update_counter_ => transaction_update_counter_,
                                        order_ref1_                 => order_no_,
                                        order_ref2_                 => line_no_,
                                        order_ref3_                 => release_no_,
                                        order_ref4_                 => receipt_no_,
                                        order_type_db_              => order_type_db_,
                                        contract_                   => contract_,
                                        part_no_                    => part_no_,
                                        receipt_cost_               => receipt_cost_,
                                        invoice_price_              => avg_inv_price_in_base_curr_,
                                        cost_detail_tab_            => empty_cost_detail_tab_,
                                        company_                    => company_,
                                        first_viable_posting_date_  => first_viable_posting_date_,
                                        trans_reval_event_id_       => trans_reval_event_id_,
                                        receipt_curr_code_          => receipt_curr_code_,
                                        invoice_curr_code_          => invoice_curr_code_,
                                        avg_inv_price_in_inv_curr_  => avg_inv_price_in_inv_curr_,
                                        avg_chg_value_in_inv_curr_  => avg_chg_value_in_inv_curr_,
                                        unit_cost_in_receipt_curr_  => unit_cost_in_receipt_curr_);
         ELSE                                                          
            -- This takes care of the case when Inventory Valution method was changed to e.g standard cost 
            -- after receiving the first invoice
            revaluation_is_impossible_ := TRUE;
         END IF;
      END IF;
      
      IF (revaluation_is_impossible_) THEN
         @ApproveTransactionStatement(2012-01-25,GanNLK)
         ROLLBACK TO before_processing_transactions;
      END IF;
   END IF;

   -- Book a price diff when the revaluation failed or when a price diff already existed.
   -- If the revaluation started as a result of a cancelled PO invoice a price diff should
   -- be booked only if one was booked when the invoice was created.
   IF ((revaluation_is_impossible_ AND NOT invoice_cancelled_) OR
       (price_diff_exists_)) THEN
      Make_Price_Diff_Transaction___(order_no_,
                                     line_no_,
                                     release_no_,
                                     receipt_no_,
                                     sequence_no_,
                                     order_type_db_,
                                     contract_,
                                     part_no_,
                                     company_,
                                     invoice_qty_,
                                     price_diff_per_unit_,
                                     trans_reval_event_id_,
                                     unit_cost_invoice_curr_,
                                     invoice_curr_code_,
                                     unit_cost_in_receipt_curr_,
                                     receipt_curr_code_);

   ELSE
      IF (sequence_no_ IS NULL) THEN
         -- Received - Not Yet Invoiced report only includes the part itself. Therefore the intension of creating balance invoice postings (BALINVOIC- or BALINVOIC+)
         -- is to eliminate any imbalances present in between M10 and M18. So we need to exclude the matching of charges.
         Make_Bal_Invoic_Transaction___ (order_no_,
                                         line_no_,
                                         release_no_,
                                         receipt_no_,
                                         order_type_db_,
                                         contract_,
                                         part_no_,
                                         company_,
                                         receipt_cost_,
                                         avg_inv_price_in_inv_curr_,
                                         unit_charge_,
                                         exchange_cost_,
                                         external_direct_delivery_,
                                         trans_reval_event_id_,
                                         invoice_curr_code_,
                                         unit_cost_in_receipt_curr_,
                                         receipt_curr_code_);

      END IF;
   END IF;
   Trans_Reval_Event_API.Finish(trans_reval_event_id_,
                                revaluation_is_impossible_,
                                transaction_update_counter_);
EXCEPTION
   WHEN exit_procedure THEN
      Trans_Reval_Event_API.Finish(trans_reval_event_id_,
                                   revaluation_is_impossible_,
                                   transaction_update_counter_);
END Revalue_Trans_From_PO_Receipt;


-- Revalue_Trans_From_SO_Scrap_Op
--   Revalue transactions when a WIP on a Shop Order has been scrapped
--   The new cost for the scrap transaction should be passed in the
--   cost_detail_tab_ parameter. If any cancel transactions are found for
--   the scrap transaction they will also be revaluated.
PROCEDURE Revalue_Trans_From_SO_Scrap_Op (
   transaction_id_  IN NUMBER,
   cost_detail_tab_ IN Inventory_Part_Unit_Cost_API.Cost_Detail_Tab )
IS
   trans_rec_                  Inventory_Transaction_Hist_API.Public_Rec;
   first_viable_posting_date_  DATE;
   date_applied_               DATE;
   company_                    VARCHAR2(20);
   site_date_                  DATE;
   trans_reval_event_id_       NUMBER;
   transaction_update_counter_ NUMBER := 0;
   revaluation_is_impossible_  BOOLEAN := FALSE;  

   CURSOR get_cancel_transactions IS
      SELECT transaction_id, quantity, date_applied
        FROM INVENTORY_TRANSACTION_HIST_TAB
       WHERE original_transaction_id = transaction_id_;
BEGIN

   trans_rec_ := Inventory_Transaction_Hist_API.Get(transaction_id_);
   
   $IF Component_Shpord_SYS.INSTALLED $THEN
      trans_reval_event_id_ := Shop_Ord_API.Get_Closed_By_Reval_Event_Id(trans_rec_.source_ref1,
                                                                         trans_rec_.source_ref2,
                                                                         trans_rec_.source_ref3);
   $END

   IF (trans_reval_event_id_ IS NULL) THEN
      Trans_Reval_Event_API.New(event_id_            => trans_reval_event_id_,
                                part_no_             => trans_rec_.part_no,
                                contract_            => trans_rec_.contract,
                                shpord_order_no_     => trans_rec_.source_ref1,
                                shpord_release_no_   => trans_rec_.source_ref2,
                                shpord_sequence_no_  => trans_rec_.source_ref3,
                                shpord_line_item_no_ => trans_rec_.source_ref4);
   END IF;

   site_date_                 := Site_API.Get_Site_Date(trans_rec_.contract);
   first_viable_posting_date_ := Site_Invent_Info_API.Get_First_Viable_Posting_Date(trans_rec_.contract);

   IF (Trans_Reval_Event_Shpord_API.Check_Exist(trans_reval_event_id_,
                                                trans_rec_.source_ref1,
                                                trans_rec_.source_ref2,
                                                trans_rec_.source_ref3)) THEN
      -- Loop Detected. The same Shop Order is processed once again for the same event ID.
      revaluation_is_impossible_ := TRUE;
   ELSE
      Trans_Reval_Event_Shpord_API.New(trans_reval_event_id_,
                                       trans_rec_.source_ref1,
                                       trans_rec_.source_ref2,
                                       trans_rec_.source_ref3,
                                       site_date_);
   END IF;
   
   company_      := Site_API.Get_Company(trans_rec_.contract);
   date_applied_ := GREATEST(first_viable_posting_date_, trans_rec_.date_applied);

   -- Update the scrap transaction passed in
   Inventory_Transaction_Hist_API.Set_Cost(transaction_id_, cost_detail_tab_);
   Do_Value_Adjustment_Booking___(transaction_id_, company_, date_applied_, trans_reval_event_id_);
   Increase___ (transaction_update_counter_);

   -- Update any cancel transactions that might exist for the scrapping
   FOR next_cancel_trans_ IN get_cancel_transactions LOOP
      Inventory_Transaction_Hist_API.Set_Cost(next_cancel_trans_.transaction_id, cost_detail_tab_);

      date_applied_ := GREATEST(first_viable_posting_date_, next_cancel_trans_.date_applied);

      Inventory_Transaction_Hist_API.Reverse_Accounting(next_cancel_trans_.transaction_id,
                                                        transaction_id_,
                                                        value_adjustment_     => TRUE,
                                                        per_oh_adjustment_id_ => NULL,
                                                        trans_reval_event_id_ => trans_reval_event_id_,
                                                        date_applied_         => date_applied_);
   END LOOP;
   Trans_Reval_Event_API.Finish(trans_reval_event_id_,
                                revaluation_is_impossible_,
                                transaction_update_counter_);
END Revalue_Trans_From_SO_Scrap_Op;



