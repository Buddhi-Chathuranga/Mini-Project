-----------------------------------------------------------------------------
--
--  Logical unit: InvoiceCustomerOrder
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220202  Nasrlk  FI21R2-8932, Modified Create_Credit_Invoice__ method to add prepayment_type_code for CO credit prepayment tax document.
--  220120  KiSalk  Bug 161969(SC21R2-7035), Added Get_Line_Counts_Per_Supply__. Modified Create_Credit_Invoice__ to pass exclude_service_items_ to Customer_Order_Inv_Item_API.Create_Credit_Invoice_Items.
--  220118  PraWlk  FI21R2-8648, Modified Get_Prel_Cancel_Hist_Text___() to exclude the state and to include the series id and invoice no instead of invoice id as
--  220118          of invoice id as the method coveres both Preliminary and PostedAuth invoices. 
--  210104  PraWlk  FI21R2-8033, Added Validate_Cancel_Debit_Invoice___() to do additional validations when cacelling a PostedAuth CO debit invoice.
--  220105  KaPblk  SC21R2-6605, Modified Create_Rebate_Credit_Invoice__() by fetching the value to inv_customer_no_ only when ignore_inv_cust is FALSE. 
--  211208  Utbalk  FI21R2-8032, Modified Cancel_Prelim_Debit_Invoice by replacing Customer_Invoice_Pub_Util_API.Cancel_Prelim_Debit_Invoice to Customer_Invoice_Pub_Util_API.Cancel_Debit_Invoice. 
--  211106  MiKulk  SC21R2-6212, Modified the Consume_Prepaym_Inv_Lines___ to consider the NULL delivery types
--  211102  MaEelk  SC21R2-5668, Replaced control_type_key_rec_.oe_tax_code_ with control_type_key_rec_.tax_code_ in Add_Control_Type_Values___
--  211013  Hiralk  FI21R2-4199, Modified Create_Rebate_Credit_Invoice__ to add coefficient_for_tax functionality.
--  211013  NiDalk  SC21R2-3203, Supported Bundle call for external tax fetch of AVALARA taxes.
--  210831  Skanlk  Bug 160293(SC21R2-2540), Modified Create_Collect_Ivc_Ord__ and New_Collect_Inv_Line_Temp___ to fetch the first Order No correctly.
--  210805  KiSalk  Bug 160297(SCZ-15850), Reverted passing a value as order_no_ done by 140700(142414) and passed NULL again, because creators reference should be null for collective invoice.
--  210720  Chgulk  FI21R2-3530, Allowed to Modify the Domestic tax amount in invoice line section only for self-billing invoices.
--  210725  PraWlk  FI21R2-3250, Added new method Update_Business_Operation() to update business operation in CO invoice lines.
--  210715  Shdilk  FI21R2-2292, Added out_inv_curr_rate_voucher_date functionality.
--  210712  Skanlk  Bug 159946(SCZ-15488), Modified Create_Shipment_Invoice___ method by changing head_data cursor by replacing internal_ref by customer_no_pay_ref to fetch correct reference to invoice.
--  210618  MaEelk  SC21R2-1075, Added DELIV_TYPE_ID to prepay_line_attr_ in Calculate_Prepaym_Amounts___ and to the prepayment consumption logic in Consume_Prepaym_Inv_Lines___. 
--  210305  ErRalk  Bug 156764(SCZ-13895), Created function called Get_Prepaym_Based_Other_Amt__ to get the invoiced amount of other orders.
--  210305  PamPlk  Bug 157341(SCZ-13917), Removed PRINT_ONLINE from Finalize_Rate_Credit_Invoice__(). Modified Create_And_Print_Adv_Invoice__() and Create_Print_Prepay_Invoice__()  to include PRINT_BACKGROUND 
--  210305          so that it can be used to bypass the history comment when an email is not sent.
--  201216  PamPlk  Bug 156336(SCZ-12857), Modified Create_Rebate_Credit_Invoice__() by passing 'FALSE' instead of 'TRUE' when getting cust_ref_ and handling NVL.
--  201108  RasDlk  SCZ-11661, Modified Create_Rebate_Credit_Invoice__() by changing a condition to filter ALL parts with DB_INCLUDE_SALES_PART.
--  201016  RoJalk  Bug 146018(SCZ-11809), Removed all code added in bug 127272 in Unconsume_Deliveries___() since it is now redundant.
--  201016          Outstanding_Sales_Tab will now have records for customer order lines originating from a service order, and the common logic 
--  201016          in Unconsume_Deliveries___() will handle all order lines correctly, when a preliminary credit invoice is cancelled.
--  201015  ErRalk  Bug 155361(SCZ-11071), Modified Create_Rebate_Credit_Invoice__() by adding agreement type ALL so that Sales Part is displayed in Final Settlement credit invoice. 
--  201013  ErFelk  Bug 150985(SCZ-11840), Modified Create_Rebate_Credit_Invoice__() to get the invoice customer when creating the Rebate credit invoice.
--  200923  NiDalk  Bug 155677(SCZ-11552), Modified  Create_Invoice_Item__ and Create_Invoice_Charge_Item___ to correct an issue on dicount transfer introduced from AVALARA implementation.
--  200914  MaEelk  GESPRING20-5400, Modified Create_Invoice_Item__ and passed original_discount, original_add_discount and original_order_discount
--  200914          to Customer_Order_Inv_Item_API.Create_Invoice_Item.
--  200801  Skanlk  Bug 150945(SCZ-7582), In Buffer_Coll_Ivc_Orders___ changed DUP_VAL_ON_INDEX added sub method Clear_Obsolete_Buffer_Val___ to clear previously added batch_collect_ivc_orders_tab records,
--  200801          that are left as garbage when background job has been deleted in Posted state.
--  200710  NiDalk  SCXTEND-4446, Implemented to fetch external tax info through a bundle call when creating invoice when using AVALARA tax.
--  200710  RasDlk  Bug 153628(SCZ-10089), Used the attribute INVOICE_ID instead of REF_INVOICE_ID to check previous executions of Rate Correction Invoice creation jobs in Check_No_Previous_Execution___
--  200710          and in Create_Rate_Correction, Check if previous background job has already created a Rate Correction Invoice.
--  200417  Dihelk  gelr:fr_service_code, Added functionality related to france service code
--  200406  WaSalk  GESPRING20-539, Modified Create_Invoice_Line___() by adding relevant modification to del_note_mandatory localization.
--  200304  BudKlk  Bug 148995 (SCZ-5793), Modified the method Create_Collect_Ivc_Ord__, Create_Collect_Ivc_Ord__ and public record ivc_head_rec to resize the variable size of cust_ref_.    
--  200323  Hahalk  Bug 152942 (SCZ-9548), Added condition in Create_Advance_Invoice__() and Create_Prepayment_Invoice__() to fetch cust_ref for the Advance Invoice based on the Invoice customer.
--  200320  ApWilk  Bug 152695 (SCZ-9261), Modified Create_Collective_Invoice___() and Create_Invoice_Lines___() to fine tune the functionality of unconnected charges when there is a closed date has defined.
--  200305  ApWilk  Bug 142414, Modified Batch_Create_Cust_Invoices__(), Batch_Create_Coll_Invoices__() and New_Collect_Inv_Line_Temp___() to finetune the invoice creating functionality.
--  200305  ApWilk  Bug 140700, Modified Batch_Create_Cust_Invoices__() to facilitate the batch create normal invoice process without depending on the company value and implemented the same functionality to 
--  200305          batch create collective invoices by modifying the methods Validate_Coll_Ivc_Params() and Batch_Create_Coll_Invoices__().
--  200203  ErFelk  Bug 150486 (SCZ-7453), Modified Calculate_Prepaym_Amounts___() by changing a condition to check whether whole order amount is going to be consumed or not.
--  200203          Modified Calculate_Prepaym_Amounts___() by passing prepaym_invoice_id_ and prepaym_item_id_ to the call Customer_Order_Inv_Item_API.Get_Vat_Curr_Amount(). 
--  200120  NWeelk  GESPRING20-1910, Modified Create_Credit_Invoice__, Create_Invoice_Head_For_Rma___ and Create_Rebate_Credit_Invoice__ to fetch correction reason 
--  200120          from the invoice type to support MX_XML_DOC_REPORTING functionality.   
--  200113  Hiralk  GESPRING20-1895, Modified ivc_head_rec, Create_Collective_Invoice___, Create_Invoice_Head_For_Rma___, Create_Shipment_Invoice___, Create_Invoice__, Create_Collect_Ivc_Ord__, 
--  200113          Create_Advance_Invoice__, Create_Credit_Invoice__, Create_Prepayment_Invoice__, Create_Rebate_Credit_Invoice__ to add invoice_reason_id functionality.
--  191212  KiSalk  Bug 151284(SCZ-7989), Passed values for parameters ship_via_desc_, forward_agent_id_,  label_note_, delivery_terms_desc_, del_terms_location_ 
--  191212          when calling Customer_Order_Inv_Head_API.Create_Invoice_Head in Create_Advance_Invoice__.
--  191016  DhAplk  Bug 150011 (SCZ-7307), Modified Create_Credit_Invoice_Rec___() procedure to fetch del_terms_location.
--  190802  DiKulk  Bug 149112 (SCZ-5797), Modified Validate_Credit_Inv_Creation__() procedure to consider series_id_ in correction invoice validation.
--  190709  WaSalk  Bug 148946 (SCZ-5240), Modified Create_Collect_Ivc_Ord__() to fetch cust_ref only if same for all the orders in collective invoice.
--  190709          IF cust_No_pay exsits fetch cust_No_pay_ref in necessary way.
--  190528  ApWilk  Bug 148210(SCZ-4716), Modified Get_Head_Data_From_Rma___() to fetch the pay term id from the CO header when creating the credit invoice from RMA.
--  190518  LaThlk  Bug 145705(SCZ-2281), Modified the procedure Cancel_Prelim_Debit_Invoice() to restrict the cancellation of the preliminary debit invoice when it is connected to a RMA line.
--  190320  ApWilk  Bug 147413 (SCZ-3819), Modified Create_Advance_Invoice__() to remove the condition for creating the advanced invoice when a stage billing is connected.
--  181114  BudKlk  Bug 145243, Modified the method Create_Collect_Ivc_Ord__() to change the method  call Get_Customer_Liability_Date to Get_Customer_Liability_Date_Db in order to retrived the database value.
--  181020  ChBnlk  Bug 140588, Modified Finalize_Rate_Credit_Invoice__() by removing the code to automatically set the rate credit invoice for printed and called  
--  181020          Customer_Order_Inv_Head_API.Print_Invoices() in order to create a print job for the rate credit invoice.
--  180806  ErFelk  Bug 135965, Modified Cancel_Prelim_Debit_Invoice() by modifing the FREIGHT_CHG_INVOICED_DB flag to FALSE when cancelling an invoice.
--  180521  AsZelk  Bug 141237, Used source_tax_item_base_pub view instead of source_tax_item_pub.
--  180425  reanpl  Bug 141485, Free of Charge enhancement - Modified Credit_Returned_Line___
--  180222  MaEelk  STRSC-16934, Added parameter use_ref_inv_rates_ to Customer_Order_Inv_Item_API.Create_Credit_Invoice_Items.
--  180222  IzShlk  STRSC-17321, Removed unnessary/usges TO_CHAR() within cursors.
--  180221  ErRalk  Bug 140300, Modified Create_Collective_Invoice___,New_Collect_Inv_Line_Temp___ methods to fetch customer order reference to invoice when there isn't any invoicing customer and Customer Reference is same on all connected orders.
--  180221  budKlk  Bug 140212, Modified the method Calculate_Prepaym_Amounts___() to correct the values of Customer invoice for prepayment line for option Use Price Incl Tax and prepayment invoice is for whole order amount.
--  180215  ApWilk  Bug 139644, Modified Cancel_Prelim_Debit_Invoice() and Unconsume_Deliveries___() in order to reverse the qty correctly for consignment stock when canceling the preliminary invoice. 
--  180214  MAHPLK  STRSC-16787, Modified Create_Corr_Inv_From_Return to block the creation of correcion invoice from RMA.
--  180209  KoDelk  STRSC-15901, When creating tax lines for invoice use the current currency rate rather than using the source line currency rate.
--  180129  IzShlk  STRSC-16066, Introduced transaction level tax manadatory check in Create_Advance_Invoice__.
--  180129  ShPrlk  Bug 139771, Modified Get_Invoice_Charge_Data to fetch the sales charge group of the respective charge type to get latest value, if basic data is changed to fix posting errors.
--  180111  BudKlk  Bug 137467, Modified the methods Create_Rate_Corr_Invoices__(), Create_Credit_Invoice__(), Create_Rate_Correction() to retrive the correction reason and correction reason id from the currency rate correction dialog. 
--  171110  UdGnlk  Bug 138257, Modified Create_Invoice_Line___() calculation of pkgs_already_delivered_ with conv_factor considering the brackets.
--  171108  ShPrlk  Bug 137988, Modified Create_Shipment_Invoice___ to fetch the internal customer information to the shipment invoice in supply type IPD.
--  171023  BudKlk  Bug 138449, Modified the method Create_Invoice_From_Return__() to create credit invoice which does not include zero price charge lines which have cost.
--  171002  SBalLK  Bug 137173, Added Check_Adv_Credit_Inv_Create__() method to raise warning when creating advance credit invoice which exceed order amount and having open(Preliminary) advance credit invoice.
--  170926  ApWilk  Bug 137627, Modified Create_Shipment_Invoice___ to invoke the Exception message when user tries to create the shipment invoice with non refreshed data.
--  170925  ApWilk  Bug 137589, Modified New_Collect_Inv_Line_Temp___ in order to ignore the COs which are connected with a pre-payment invoice when Batch Create Collective Customer Invoices is excecuted.
--  170619  NipKlk  STRSC-2566, Added a new method Create_Rate_Correction to be called from the client when there is a currency rate correction to be done in the Customer invoice and modified 
--  170619          Create_Credit_Invoice__ method to accordingly to handle the rate correction. Added 2 calls to Create_Credit_Invoice__ method first to create reversal credit invoice and then to
--  170619          create the correct debit invoice with the new currency rate and tax currency rate values and finally modified the Create_Credit_Invoice__ out the invoice ids of rate correction invoices. 
--  170615  MeAblk  Bug 135966, Modified methods Create_Shipment_Invoice___() and Create_Invoice_Lines___() in order to make it possible to create separate shipment invoices for the shipment freight charges
--  170615          when the shipment freight charges are creating in a different currency other than the order currency.
--  170506  NiDalk  VAULT-2619, Modified Create_Collect_Ivc_Ord__ to raise the error after clearing collective invoices when an error occured.
--  170316  AmPalk  STRMF-10176, Modified Create_Rebate_Credit_Invoice__. The catalog number and the desc. passed in
--  170316          to the invoice item will comprise the sales part and the description along with the rebate type, if sales part is involved in grouping the settlement lines. 
--  170315  AmPalk  STRMF-10152, Added Clear_Reb_Aggr_Tmp_Tabs___ and Clear_Rebate_Postings_Ref_Data.
--  170307  AmPalk  STRMF-6615, Altered Get_Rebate_Info___ to handle multiple valid agreement list instead of a single agreement. 
--  170208  AmPalk  STRMF-6864, Added Add_Control_Type_Values___ and modified Create_Rebate_Credit_Invoice__ to maintain derived control type values (using MPCCOM), 
--  170208          for the defined control types for the bookings 29 and 30 considering the rebate transactions under a rebate credit invoice line.
--  170208          Modified Remove_Invoice_Associations___ to clear the temporary data used in flexible rebate credit invoice postings when invoice line removal.
--  170202  JeeJlk  Bug 131867, Modified Cancel_Prelim_Debit_Invoice to reduce the original invoiced qty from co line invoiced_qty when uninvoicing the customer order line.
--  170202  SBalLK  Bug 121377, Modified Credit_Returned_Charge___() and Credit_Returned_Line___() in order to check whether invoice item already created or not before creating customer order history.
--  170202          Added Check_Create_Cust_Ord_Hist___() method.
--  170201  NiDalk  Bug 131941, Modified Batch_Create_Coll_Invoices__ to use planned invoice date using batch create collect invoice. 
--  170127  NiDalk  STRSC-3939, Removed price including vat from rebate functionality.
--  170126  ThImlk  STRMF-8408, Modified Create_Rebate_Credit_Invoice__() to send the rebate agreement currency code, when generating rebate credit invoice.
--  170110  ChBnlk  Bug 133334, Modified Create_Collect_Ivc_Ord__() by adding a call to Clear_Batch_Coll_Ivc_Orders__() to handle all the exceptions that are not 
--  170110          specifically handled.
--  161103  ErFelk  Bug 131753, Modified Create_Prepayment_Invoice__() by changing the error message ROLLBACKEDPAYMENT to cater scenarios handle from bug 128241 and this.  
--  161103  ErFelk  Bug 131936, Modified Check_Req_Prepayments_Unpaid() by adding NVL and gave priority to invoicing customer when calling On_Account_Ledger_Item_API.Get_Payment_Amt_For_Order_Ref().
--  161004  ErFelk  Bug 131787, Modified Create_Prepayment_Invoice__() to give priority to invoicing customer when calling Ledger_Transaction_API.Exist_Unrollbacked_Trans().
--  160906  ChBnlk  Bug 130789, Modified Batch_Create_Coll_Invoices__() by adding check to create invoices even when the planned_invoice_date_ is less than the sysdate. 
--  160901  NiDalk  Bug 131026, Modified Create_Rebate_Credit_Invoice__ not to consider use_price_incl_tax_ when calculating rebate postings as tax amount is not a cost.
--  160818  BudKlk  Bug 130913, Modified the method Credit_Returned_Line___() by adding a condition to make sure to get the RMA ship_addr_no_ when the demand_code is 'int purch dir' to avoid the error message. 
--  160714  LaThlk  Bug 130118, Modified Credit_Returned_Charge___() in order to pass the customer_po_no_(if it is connected to a CO) when creating the invoice.
--  160714  SudJlk  STRSC-1959, Modified Validate_Cust_Ivc_Params to check validity for order coordinator.
--  160708  KiSalk  Bug 130040, Cleared invoice details of rental transactions in Cancel_Prelim_Debit_Invoice.
--  160705  TiRalk  STRSC-1189, Modified the places where it used Customer_Order_API.Release_Credit_Blocked, Customer_Order_API.Start_Release_Credit_Blocked
--  160509          to Customer_Order_API.Start_Release_Blocked, Customer_Order_API.Start_Release_Blocked.
--  160629  TiRalk  STRSC-2702, Changed the places where it has used CreditBlocked from CustomerOrder has changed to state Blocked.
--  160609  ChJalk  Bug 129006, Modified the methods Create_Invoice_Lines___ and Batch_Create_Coll_Invoices__ to consider the closing dates when doing the batch creating the collective invoices.
--  160525  JeeJlk  Bug 128931, Modified Create_Advance_Invoice__ to prevent invoicing more than 100% of Invoice Net Amt when multiple users making advance invoices for the same order.
--  160329  MeAblk  Bug 128241, Modified Create_Prepayment_Invoice__ to avoid rollbacked payments when creating prepayment invoices.
--  160317  Kisalk  Bug 127272, Modified Unconsume_Deliveries___ to reset qty_invoiced of customer_order_delivery_tab for credit invoice of service contract.
--  160511  Cpeilk  Bug 128362, Modified Create_Collective_Invoice___ to store history record in CO header only when CO lines get invoiced for that particular order.
--  160509  MaRalk  LIM-6531, Modified Create_Shipment_Invoice___ - shipment_data cursor by joining with shipment_freight_tab.
--  160509          Replaced Shipment_API.Get_Use_Price_Incl_Tax_Db with Shipment_Freight_API.Get_Use_Price_Incl_Tax_Db inside Create_Shipment_Invoice__.
--  160419  IsSalk  FINHR-1589, Move server logic of RmaLineTaxLines to common LU (Source Tax Item Order).
--  160405  Cpeilk  Bug 128240, Modified Get_Head_Data_From_Rma___ to fetch cust_ref from RMA header if credit customer does not exist, if exist then from customer address details.
--  160314  NWeelk  STRLOC-262, Modified Create_Invoice_Tax_Item___ by adding parameter free_of_charge_ to use when calculating tax amounts for free of charge lines.
--  160308  MeAblk  Bug 127480, Modified Create_Invoice_Lines___() to correctly handle negative charged_qty.
--  160229  MaIklk  LIM-4322, Added source ref type and used pub views in cursors related to shipment.
--  160224  MeAblk  Bug 127465, Modified Cancel_Prelim_Debit_Invoice() to handle cancelling invoice when there's no any default invoice types defined.
--  160221	MeAblk  Bug 126305, Modified Cancel_Prelim_Debit_Invoice() to correctly set the qty_invoiced when have modified the pkg comp qty_invoiced.
--  160221          Modified Unconsume_Deliveries___() to correctly set the component_invoice_flag when canceling partial component invoice items.
--  160211  IsSalk  FINHR-685, Renamed attribute FEE_CODE to TAX_CODE in Customer Order Charge.
--  160201  MaRalk  LIM-6114, Replaced ship_addr_no usages with receiver_addr_id
--  160201          in Create_Shipment_Invoice___, Create_Shipment_Charge_Item___ methods.
--  160111  IsSalk  FINHR-581, Renamed column FEE_CODE to TAX_CODE in SALES_CHARGE_TYPE_TAB.
--  160108  PrYaLK  Bug 125799, Modified Create_Shipment_Charge_Item___ to create the invoice tax item if the customer tax regime is VAT or MIX.
--  160106  ErFelk  Bug 126097, Modified messages INVHISTCANCEL, CANPREINV, CANPREADVINV, CANPRECOLINV and CANPRESELFINV to display as cancelled instead of canceled. 
--  151231  SeJalk  Bug 126402, Modified Create_Invoice_From_Return__ to search invoices added for credit customer if exists instead of the customer.
--  150107          Added New method Get_Ref_Inv_Curr_Rate_Type___ to get the referene invoice currency rate if the used needs to use it. 
--  151222  DilMlk  Bug 125479, Modified Remove_Invoice to remove attached Approval Routings, Documents and Technical classes from invoice header 
--  151222          and lines, when credit/correction invoice is deleted.
--  151217  MeAblk  Bug 125426, Modified Cancel_Prelim_Debit_Invoice() to correctly get the order line qty when a charge line is connected.
--  151202  RoJalk  LIM-5178, Rename ORDER_NO, LINE_NO, REL_NO, LINE_ITEM_NO to SOURCE_REF1,
--  151202          SOURCE_REF2, SOURCE_REF3, SOURCE_REF4 in ShipmentLine and ShipmentLineHandlUnit. 
--  151110  MaIklk  LIM-4059, Renamed deilver_to_customer_no to receiver_id and renamed address fields to sender_xxx and receiver_xxx of shipment table.
--  151110  RoJalk  LIM-4610, Rename ShipmentOrderLine LU to ShipmentLine.
--  151103  IsSalk  FINHR-316, Renamed attribute FEE_CODE to TAX_CODE in Customer Order Line.
--  150911  IsSalk  AFT-4241, Modified methods to add correct info in the CO History in case CO Correction Invoice has been created and later removed.
--  150716  Hecolk  KES-1067, Adding ability to specify a reason when cancelling a preliminary CO Invoice
--  150710  Hecolk  KES-1027, Cancelling Preliminary Self-Billing CO invoice   
--  150706  Hecolk  KES-677, Cancelling Preliminary Advance CO invoice
--  150706  Hecolk  KES-880, Cancelling Preliminary Staged Billing CO invoice
--  150626  Hecolk  KES-779, Handling charges when Cancelling preliminary CO Invoice   
--  150619  Hecolk  KES-675, Cancelling preliminary collective CO Invoice 
--  150605  MeAblk   Bug 122831, Added customer_no_pay_ref into the view CUSTOMER_ORDER_COLLECT_INV and modified methods Create_Invoice__,Create_Collective_Invoice___, Create_Collect_Ivc_Ord__ 
--  150605           in order to consider order defined customer_no_pay_ref when creating collective and normal invoices.  Added new methods New_Collect_Inv_Line_Temp___, Clear_Collective_Line_Tmp___
--  150605           in order to improve the performance when creating collective invoices.
--  150529  Hecolk  KES-538, Adding ability to cancel preliminary Customer Order Invoice
--  150526  IsSalk  KES-510, Modified cursors with Customer_Order_Delivery_TAB to filter out cancelled CO deliver lines.
--  150526  Cpeilk  RED-358, Modified methods to introduce condition compilation for ORDER in order to skip intial deployment for views moved to Post_Installation_Object method.
--  150519  RoJalk  ORA-161, Replaced the logic to fetch cust_ref_ using Cust_Ord_Customer_API.Fetch_Cust_Ref. 
--  150429  NWeelk  Bug 122325, Modified Create_Invoice_Lines___ to retrieve un-invoiced charge lines correctly from the cursors get_charge_to_invoice and get_charge_to_invoice2
--  150429          by selecting records which has invoiced_qty less than charged_qty instead of using not equal sign.
--  150902  SeJalk  Bug 124302, Modified Create_Invoice_From_Return__() by adding extra filtering to the cursors to hit indexes hence gain performance.
--  150727  KiSalk  Bug 123710,In Create_Shipment_Invoice___, when create invoice header, ship_addr_no of shipment was used if it has a value, 
--  150722  HimRlk  Bug 119517, Modified Batch_Create_Cust_Invoices__() and Validate_Cust_Ivc_Params() to filter Partially Delivered and Delivered Orders 
--  150722          when using Batch Create Customer Invoices.
--  150722  ErFelk  Bug 122091, Modified Batch_Create_Cust_Invoices__() by adding company_ to the where clause of cursor get_orders.
--  150429  NWeelk  Bug 122325, Modified Create_Invoice_Lines___ to retrieve un-invoiced charge lines correctly from the cursors get_charge_to_invoice and get_charge_to_invoice2
--  150429          by selecting records which has invoiced_qty less than charged_qty instead of using not equal sign.
--  150217  SWiclk  PRSC-6174, Modified Credit_Returned_Charge___() and Credit_Returned_Line___() in order to check whether the item_id_ is 1 because otherwise for each item there 
--  150217          will be a history record in debit invoice (repeated info). Passed the ref_invoice_id_ when calling Customer_Order_Inv_Head_API.Create_Credit_Invoice_Hist().
--  140128  Ersruk  PRPJ-4330, Corrected method call to Create_Invoice_Charge_Line___().
--  141127  MAHPLK  PRSC-2774, Modified Check_No_Previous_Execution___ method to use overloaded 
--  141127          Transaction_SYS.Get_Posted_Job_Arguments which returns plsql table.
--  141118  JeLise  PRSC-2547, Replaced CUSTOMER_ORDER_JOIN with CUSTOMER_ORDER_TAB.
--  141116  DilMlk   Bug 116703, Modified method Get_Head_Data_From_Rma___() to set the ivc_rec_.cust_ref before passing it to the method Create_Credit_Invoice_Rec___().
--  141116           Removed the conditions of Create_Credit_Invoice_Rec___() that checked for rma_rec_.cust_ref and added conditions to check for ivc_rec_.cust_ref and to set it, if it is null.
--  141020  Chfose   PRSC-3407, Added a null-check on the background job id's for the check on comparing previous background jobs to work in Get_Job_Arguments___.
--  140925  JeeJlk   Bug 117714, Modified Create_Collective_Invoice___, Create_Invoice_Head_For_Rma___, Create_Shipment_Invoice___, Create_Invoice__, Create_Collect_Ivc_Ord__, Create_Advance_Invoice__,  
--  140925           Create_Credit_Invoice__, Create_Prepayment_Invoice__ in order to pass all the parameters correctly in all the method calls to Customer_Order_Inv_Head_API.Create_Invoice_Head.
--  140908  ShVese   Removed unused cursor get_invoice_details from Get_Head_Data_From_Rma___.
--  140813  Vwloza   Updated Get_Invoice_For_Rma() with a Rental clause in the main IF condition.
--  140813  MAHPLK   PRSC-2191, Moved code block for insert date in to batch_collect_ivc_orders_tab to new implementation method Buffer_Coll_Ivc_Orders___.
--  140811  MAHPLK   PRSC-2189, Removed transaction statements from the Create_Prepayment_Invoice__.
--  140721  RuLiLk   Bug 117029, Modified methods Create_Shipment_Invoice___ and Create_Collect_Ivc_Ord__ to pass language code when fetching delivery_terms_desc_ and ship_via_desc_.
--  140516  BudKlk   Bug 116840, Modified Create_Invoice_Charge_Item___() procedure to save the customer order charge description on the customer order invoice line.
--  140505  MiKulk   Bug 116341, Merged with PBSC-8419. Modified Create_Collective_Invoice___, Create_Shipment_Invoice___() and Create_Collect_Ivc_Ord__() 
--  140505           in order to change the currency rate accordingly when changing invoice date.
--  140421  KiSalk   Bug 116472, Added function Get_Prepayment_Text__.
--  140327  AyAmlk   Bug 115073, Modified Create_Shipment_Invoice___() to prevent invoicing the shipment freight charges multiple times.
--  140211  IsSalk   Bug 115267, Modified Create_Collective_Invoice___() in order to sort the invoice lines according to the Order No.
--  140121  NaLrlk   Modified Create_Invoice_Item__() to consider unit_price_incl_tax_curr_ defined in rental transaction when create rental invoices.
--  140117  BudKlk   Bug 114677, Modified Create_Invoice_Item___() by passing qty_invoiced_ to the method Cust_Invoice_Item_Discount_API.Copy_Discount().
--  131107  IsSalk   Bug 113412, Modified Credit_Returned_Line___() in order to get catalog description from the RMA line.
--  131105  MAHPLK   Renamed CUSTOMER_ORDER_ADDRESS to CUSTOMER_ORDER_ADDRESS_2.
--  131016  RoJalk   Modified the calls to Create_Invoice_Item__ and corrected the order of parameters after merge.
--  130924  RuLiLk   Bug 112419, Added the public procedure Get_Invoice_Charge_Data(). Moved logic of fetching charge data from MPCCOM to ORDER module
--  130829  ChBnlk   Bug 110824, Modified Create_Collective_Invoice___ to check if there are invoiced order lines in a collective invoice 
--  130829           and display the information message properly when there are no order lines available to create the collective invoice.
--  130827  IsSalk   Bug 112056, Modified method Create_Invoice_Lines___() to close the Open Cursor is_inv_items_available which was not closed within the method.
--  130822  SudJlk   Bug 111855, Modified Create_Advance_Invoice__ to remove amounts from advance invoice creation history record. 
--  130625  NWeelk   Bug 110507, Modified method Create_Shipment_Invoice___ by changing cursor head_data to avoid duplicate records.
--  130619  jokbse   Bug 110304, Merge, Modified Create_Prepayment_Invoice__ to remove states 'Delivered','PartiallyDelivered' from status check when creating prepayment invoice.
--  130823  CHRALK   Modified view CUSTOMER_ORDER_INVOICE_LINE, by adding where condition for filter rental order lines.
--  130708  ChJalk   TIBE-998, Removed Global variables inst_OnAccountLedgerItem_ and inst_LedgerItem_. 
--  130717  NaSalk   Added RENTAL_TRANSACTION_PUB dummy view so that it can be used in INVOICABLE_COLL_CO_LINES. INVOICABLE_COLL_CO_LINES was modified to include rental transactions.
--  130618  NaSalk   Modified Create_Invoice_Lines___, Create_Invoice_Line___ and Create_Invoice_Item__ to consider rental transactions when invoiced.
--  130808  MaMalk   Added another parameter attr_ to Make_Shipment_Invoice__ to be passed from create shipment invoice client.
--  130808           Restructured this method to create multiple invoices when a value is passed to the attr_.
--  130808           Modified Batch_Create_Ship_Invoices__ to consider parameters sent from the client.
--  130603  SURBLK   Modified Create_Collective_Invoice___() by adding Start_Release_credit_Blocked instead of Release_Credit_Blocked.
--  140425  IsSalk   Bug 116305, Modified Create_Collective_Invoice___() and Create_Collect_Ivc_Ord__() to set the cust ref correctly when creating the CO collective invoices 
--  140425           for a scenario where there exist a separate paying customer.
--  130325  ChFolk   Modified Credit_Returned_Line___, Credit_Returned_Charge___ and Get_Head_Data_From_Rma___ to get the delivery address from internal customer defaut for fetching tax regime in supply site rma.
--  130201  MaMalk   Added price_conv_factor_ as a default null parameter to method Create_Invoice_Item__ and modified Create_Invoice_Line___ to correctly calculate the price conversion factor 
--  130201           for shipment invoices with catch unit enabled parts.
--  130130  ChFolk   Replaced usages of customer_no with return_from_customer_no in rma header when getting the delivery informations.
--  121231  MeAblk   Modified view CUSTOMER_ORDER_SHIP_INVOICE by adding the shipment_type. Modified Batch_Create_Ship_Invoices__ in order to run the shipment flow when batch shipment invoices.
--  120727  Maeelk   Added out paramater invoice_id_ to Make_Shipment_Invoice__. Changed Create_Shipment_Invoice__ to add invoice_id_ to the attribute string.
--  120723  MaEelk   Modified Make_Shipment_Invoice__ changinging the parameter att_ to shipment_id. 
--  120723           Added Is_Shipment_Invoiceable to check if a given shipment in available to crate a shipment invoice.
--  130517  SeJalk   Bug 109820, Changed the method Create_Invoice__() to get the cust_ref instead of internal_ref if the order is created from service contract.
--  130509  ErFelk   Bug 108174, Modified Consume_Prepaym_Inv_Lines___() so that debit invoice lines will consume prepayment lines having the same vat code and 
--  130509           thereafter it will consume from other vat codes.  
--  130508  KiSalk   Bug 106680, Replaced Installed_Component_SYS.<component> with Component_<component>_SYS.<component>.
--  130221  SudJlk   Bug 107667, Modified Create_Credit_Invoices and added new methods Check_No_Previous_Execution___ and Get_Job_Arguments___ to stop multiple background jobs 
--  130221           getting posted for creating the same credit invoice.
--  130109  AyAmlk   Bug 103043, Modified Create_Advance_Invoice__() to control if Delivery Confirmation for Advance/Prepayment Invoices with the new parameter, Allow With Delivery Confirmation.
--  121022  ShKolk   Passed total_tax_percentage_, vat_dom_amount and vat_curr_amount to Create_Invoice_Tax_Item___().
--  121018  GiSalk   Bug 106069, Modified Get_Branch() by removing the unnecessary conditional compilation which was checking whether INVOIC module is installed.
--  120927  HimRlk   Modified CUSTOMER_ORDER_COLLECT_INV view by adding use_price_incl_tax column and modified CUSTOMER_ORDER_COLLECT_INVOICE view by adding use_price_incl_tax
--  120927           to group by clause. Modified Batch_Create_Coll_Invoices__, Make_Collective_Invoice__, Create_Collective_Invoice__ and Create_Collective_Invoice___ to 
--  120927           to support use_price_incl_tax.
--  120926  AyAmlk   Bug 104235, Modified the INVOICE_CUSTOMER_RMA_LOV view and moved a filtering condition to the client.
--  120926  ShKolk   Passed prices including tax and total tax percentage to Create_Invoice_Item().
--  120921  ShKolk   Passed use_price_incl_tax_db_ to Create_Invoice_Head().
--  120920  GiSalk   Bug 101901, Added the function Get_Branch().
--  120912  KiSalk   Bug 104725, Changed the call to Psc_Inv_Line_Util_API.Update_Product_Invoice for conditional compilation and called in Create_Collect_Ivc_Ord__ too.  
--  120907  NipKlk   Bug 105076, Changed the names of the views STATUTORY_FEE_LOV,DELIVERY_TYPE_LOV,INVOICE_TYPE_LOV and INVOICE_SERIES_LOV to 
--  120907           ORD_STATUTORY_FEE_LOV, ORD_DELIVERY_TYPE_LOV,ORD_INVOICE_TYPE_LOV and ORD_INVOICE_SERIES_LOV to avoid conflicts.
--  120821  KiSalk   Bug 104725, The second FETCH moved to the end of LOOP in Create_Collective_Invoice___.
--  120713  MalLlk   Bug 103622, Modified Is_Report_Available to check whether the session user has system privileges.
--  120702  NipKlk   Bug 102236, Created views STATUTORY_FEE_LOV,DELIVERY_TYPE_LOV,INVOICE_TYPE_LOV and INVOICE_SERIES_LOV to get data for LOVs.
--  120607  NWeelk   Bug 102423, Modified method Create_Shipment_Invoice___ by setting the Commission Recalc Flag to true before creating the invoice lines since the  
--  120607           commission should/may be recalculated after creating the invoice.
--  120404  SWiclk   Bug 102006, Modified Create_Collect_Ivc_Ord__() in order to raise the no_invoiced_lines exception when there is no data found to create an invoice. 
--  120419  Darklk   Bug 101806, Modified Create_Invoice_Lines___ in order to make it possible to create a collective invoice when there is a new charge line added
--  120419           to an already Invoiced CO.
--  120412  AyAmlk   Bug 100608, Increased the column length of delivery_terms to 5 in view CUSTOMER_ORDER_INVOICE_LINE.
--  120409  MaRalk   Modified cursor get_shipment_freight_charges in Create_Shipment_Invoice___ method 
--  120409           to exclude shipment freight charges being invoiced if the collect check box is selected.
--  120329  Darklk   Bug 101191, Added the public procedure Validate_Vat_Codes.
--  120314  DaZase   Removed last TRUE parameter in Init_Method call inside Batch_Create_Cust_Invoices__/Batch_Create_Rebate_Invoices__.
--  120313  MoIflk   Bug 99430, Modified procedures Create_Invoice_Line___ and Create_Sbi_Invoice_Item to include inverted_conv_factor logic.
--  120118  KiSalk   Bug 100805, Removed the parameter print_invoice_ from Create_Advance_Invoice__ and moved printing to new method Create_Print_Prepay_Invoice__.
--  120118           Removed the parameter print_option_ from Create_Prepayment_Invoice__ and moved printing to new method Create_And_Print_Adv_Invoice__.
--  111227  JuMalk   Bug 100499, Added cursor get_distinct_order to get the distinct orders connected to the RMA lines in method Get_Head_Data_From_Rma___. 
--  111227           Set the distinct order number to the invoice header if there is only one distinct order number in the RMA lines.
--  111124  GiSalk   Bug 94416, Modified methods Create_Invoice_Line___ and Consume_Deliveries___ to calculate quantity to invoice correctly for the component lines added after performing a partial delivery.
--  111124          Modified method Create_Invoice_Line___ to use qty_per_assembly when calculating the qty_invoiced.
--  111101  KiSalk   Bug 99079, Modified Create_Collective_Invoice___ and Create_Collect_Ivc_Ord__ by removing 85978 changes (set cust_ref null only when SEO lines exists) 
--  111101           and made it null always when creating collective invoices.
--  111027  SurBlk   Bug 99610, Modified the data type of the attribute debit_invoice_no_ as RETURN_MATERIAL_LINE_TAB.debit_invoice_no Type instead of Number in Create_Invoice_Head_For_Rma___().  
--  111005  MoIflk   Bug 99174, Modified Get_Head_Data_From_Rma___ by removing the get_distinct_charge_deb_inv cursor and related cursor execution lines due to Return_Material_API.Check_Debit_Inv_Numbers logic change.
--  111001  NaLrlk   Bug 93036, Changed the funcion call Cust_Ord_Customer_API.Get_Default_Media_Code by adding a new parameter in procedure Create_Prepayment_Invoice__.
--  110914  HimRlk   Bug 98108, Modified the exist check for bill_addr_no in Create_Collective_Invoice__ and Create_Shipment_Invoice__. Changed the reference of
--  110914           bill_addr_no to CustomerInfoAddress in CUSTOMER_ORDER_COLLECT_INVOICE, COLLECT_CUSTOM_INVOICE and CUSTOMER_ORDER_SHIP_INVOICE.
--  110906  MaMalk   Bug 98582, Modified INVOICE_CUSTOMER_RMA_LOV by removing the check of invoice type in the where clause and let it select all the invoices that do not  
--  110906           have correction invoices. Also corrected method Get_Invoice_For_Rma to apply the same changes.
--  110901  NaLrlk   Modified the method Create_Rebate_Credit_Invoice__ to pass correct supply country code when creating rebate invoice.
--  110824  NiDalk   Bug 95776, Modified Create_Prepayment_Invoice__ to check the order status before creating the prepayment invoice
--  110729  ShKolk   Added methods Batch_Create_Cust_Invoices__, Batch_Create_Coll_Invoices__, Batch_Create_Ship_Invoices__, Batch_Create_Rebate_Invoices__,  
--  110729           Validate_Cust_Ivc_Params, Validate_Coll_Ivc_Params, Validate_Ship_Ivc_Params, Validate_Rebate_Ivc_Params.
--  110729           Added company to CUSTOMER_ORDER_COLLECT_INVOICE and CUSTOMER_ORDER_SHIP_INVOICE views.
--  110708  MaMalk   Added the user allowed site filteration to INVOICE_CUSTOMER_RMA_LOV and modified method Get_Invoice_For_Rma to replace this view by joining some tables and views.
--  110701  KiSalk   Bug 97350, Modified Create_Collective_Invoice___ and Create_Collective_Invoice__ to allow null valued bill_addr_no. 
--  110531  AmPalk   Bug 94303, Added Is_Report_Available.
--  110521  MaMalk   Modified Create_Prepayment_Invoice__ and Create_Advance_Invoice__ to pass the supply country tax id when a tax id cannot be found for the delivery address.
--  110514  MaMalk   Modified method Create_Invoice_Lines___ to correctly set the out parameter lines_invoiced_,  modified view CUSTOMER_ORDER_COLLECT_INV to add a DISTINCT.
--  110429  MaMalk   Modified Create_Prepayment_Invoice__ to pass the tax_id tax_id_type and branch for the prepayment invoice correctly.
--  110427  ChJalk   Modified view CUSTOMER_ORDER_SHIP_INVOICE to correctly include shipments with uninvoiced freight charges and ensure already invoiced shipments are excluded.
--  110426  MaMalk   Added Tax_Liability_Country to views CUSTOMER_ORDER_INVOICE and CUSTOMER_ORDER_INVOICE_LINE.
--  110425  MaMalk   Added 2 new views CUSTOMER_ORDER_NORMAL_INV and CUSTOMER_ORDER_NORMAL_INVOICE to seperately handle normal invoices since the grouping criteria for
--  110425           collective is newly based on delivery address.
--  110420  MaMalk   Modified Credit_Returned_Line___ and Credit_Returned_Charge___ to pass the correct delivery type.
--  110418  MaMalk   Modified Batch_Coll_Ivc_Orders__ to handle the rowkey of batch_collect_ivc_orders_tab properly.
--  110412  MaMalk   Modified view CUSTOMER_ORDER_COLLECT_INVOICE to show correct number of orders to invoice.
--  110318  Darklk   Bug 96275, Modified the procedure Create_Invoice_From_Return__ to use the invoice type SELFBILLCRE when the Create Credit Invoice is executed from the RMA line.
--  110309  MiKulk   Modified the method Create_Advance_Invoice to pass the correct tax details..
--  110308  MiKulk   Added the supply_country_ to all the invoice header creation processes.
--  110308           Also modofied the credit/correction invoice creation to pass the reference invoice company tax details. 
--  110303  MiKulk   Modified the Create_Credit_Invoice__ method to pass the reference invoice tax details..
--  110208  MiKulk   Changed the collective invoice creation process to group according to tax_liablity_country.
--  110203  MiKulk   Modified the Create_Collect_Ivc_Ord__ to support the grouping of invoice creation
--  110203           by tax liability country details..
--  101010  AmPalk   Bug 93193, Added methods Clear_Batch_Coll_Ivc_Orders__ and Batch_Coll_Ivc_Orders__.
--  100727  AmPalk   Bug 92006, Modified Credit_Returned_Charge___ to check whether the charge line on the CO is invoiced. RMA charge lines can get saved even thought those are not invoiced on CO.
--  100702  ChFolk   Added Create_Inv_Tax_Item to create invoice tax items using the return value of Cust_Ord_Tax_Item_Tab.
--  110202  MiKulk   Modified the server logic to support grouping the collective invoice creation
--  110202           per tax_liability type and the delivery county, then to fetch the correct tax liability countries details.
--  101230  MiKulk   Replaced the calls to Customer_Info_Vat_API with the new method calls.
--  100713  Swralk   SAP-SUCKER DF-40, Added function Get_Invoice_Currency_Rounding.
--  101010           Changed Create_Collect_Ivc_Ord__ to use a buffer table to get the order number list to create the collective invoice.
--  101011  NWeelk   Bug 93306, Modified method Create_Invoice_Line___ by changing the WHERE clause of get_package_lines to filter records not in row state 'Invoiced'.
--  100727  AmPalk   Bug 92006, Modified Credit_Returned_Charge___ to check whether the charge line on the CO is invoiced. RMA charge lines can get saved even thought those are not invoiced on CO.
--  100727  ChJalk   Bug 91773, Added method Get_Credited_Amt_Per_Ord_Line.
--  100618  JuMalk   Bug 91143, Modified view CUSTOMER_ORDER_INV_ITEM_JOIN by modifying the decode statement for invoice_qty by adding another condition for Credit Invoices.
--  100618  ShKolk   Modified Create_Invoice_Lines___ to calculate correct charged_qty when using pack size price lists. 
--  100520  KRPELK   Merge Rose Method Documentation.
--  100507  SaJjlk   Bug 90173, Modified method Create_Credit_Invoice__ to pass the shipment_id when creating a credit invoice.
--  100505  MaGuse   Bug 89832, Modified method Create_Collect_Ivc_Ord__ to modify Commission Recalculate Flag.
--  100430  NuVelk   Merged Twin Peaks.
--  100421  MaGuse   Bug 89832, Modified method Create_Collective_Invoice___ to modify Commission Recalculate Flag. 
--  100311  SuThlk   Bug 89138, Passed ship_addr_no as a parameter to Customer_Order_Inv_Head_API.Create_Invoice_Head in Create_Advance_Invoice__.
--  100208  UtSwlk   Bug 87675, Modified code to set internal_po_no for customer_po_no_ in Create_Advance_Invoice_Item___.  
--  100202  Cpeilk   Bug 88620, Modified Credit_Returned_Charge___ to pass line_no, rel_no and line_item_no to the Invoice Item parameter list instead of NULL.
--  100122  NWeelk   Bug 88500, Modified Consume_Prepaym_Inv_Lines___ to allow consumption of prepayment invoices with vat codes other than the CO line vat code.
--  091028  KaEllk   Modified passed parameters of Calculate_Prel_Revenue__.
--  091013  KaEllk   Renamed revenue_simulation_ to planned_revenue_simulation_.
--  091008  KaEllk   Removed DEFAULT FALSE of parameter revenue_simulation_ in Create_Invoice_Charge_Item___.
--  091002  KaEllk   Added parameter revenue_simulation_ to Create_Invoice_Charge_Line, Create_Invoice_Charge_Line___ and Create_Invoice_Charge_Item___.
--  090930  RoJalk   Modified Create_Invoice_Item__ and added the parameter revenue_simulation_.  
--  090929  RoJalk   Changed the scope of Create_Invoice_Item___ to be private and Create_Invoice_Line__ to be implementation. 
--  090922  KaEllk   Added Remove_Project_Connections___. Modified Remove_Invoice, Create_Invoice_Item___, Create_Invoice_Charge_Item___.
--                   Credit_Returned_Line___ and Credit_Returned_Charge___.
--  090921  RoJalk   Added the parameter qty_to_simulate_ to the method Create_Invoice_Line__ to be used in planned revenue calculation.
--  090921  RoJalk   Changed the scope of Create_Invoice_Line__ to be private.
--  091001  MaMalk   Modified Credit_Returned_Charge___, Create_Invoice_From_Return__, Chk_Prev_Credit_Invoices__, Validate_Credit_Inv_Creation__,
--  091001           Create_Prepayment_Invoice__ to remove unused code.
--  ------------------------- 14.0.0 -------------------------------------------
--  100430  ShKolk   Added multiple tax lines for shipment charges.
--  100309  ShKolk   Modified Create_Shipment_Charge_Item___() fetched correct value for pay_tax_.
--  100112  SudJlk   Bug 87997, Reversed the correction done earlier.
--  091223  SudJlk   Bug 87997, Modified the WHERE clause in view CUSTOMER_ORDER_SHIP_INVOICE by removing NVL to consider header customer when creating invoices.
--  091217  SudJlk   Bug 86969, Revised the modifications done by the earlier versions of 86969.
--  091204  JuMalk   Bug 85873, Modified Create_Collective_Invoice___ by adding condition to avoid inconsistent error message when creating collective customer invoices. 
--  091204           Modified Create_Collective_Invoice___, Create_Shipment_Invoice___ and Create_Collect_Ivc_Ord__ by changing NOINVOICE message.
--  091203  PraWlk   Bug 85978, Modified Create_Collective_Invoice___() to check whether the records exists before creating the collective invoice.
--  091202  PraWlk   Bug 85978, Modified Create_Collect_Ivc_Ord__() to assign NULL to customer reference when user creates 
--  091125           collective invoices for service contract invoicing.
--  091130  PraWlk   Bug 85978, Modified the cursor get_service_order_lines in Create_Collective_Invoice___().
--  091125  PraWlk   Bug 85978, Modified Create_Collective_Invoice___() to assign NULL to customer reference when user creates 
--  091125           collective invoices for service contract invoicing.
--  091112  SudJlk   Bug 86969, Modified views CUSTOMER_ORDER_SHIP_INVOICE and CUSTOMER_ORDER_COLLECT_INV to handle NULL values in the condition checking for companies. 
--  091111  SudJlk   Bug 86969, Modified views CUSTOMER_ORDER_INVOICE, CUSTOMER_ORDER_INVOICE_LINE, CUSTOMER_ORDER_SHIP_INVOICE and CUSTOMER_ORDER_COLLECT_INV 
--  091111           to restrict invoice creation for internal COs in the same company with an external invoicing customer.
--  091110  NWeelk   Bug 86942, Modified Create_Invoice__ to set the cust ref correctly when creating the CO debit invoices 
--  091110           for a scenario where there exist a separate paying customer.
--  090921  ChJalk   Bug 86003, Modified Create_Collective_Invoice___ to initialize the variable lines_invoiced_.
--  090803  SudJlk   Bug 85022, Modified the WHERE clause in CUSTOMER_ORDER_SHIP_INVOICE view to select uninvoiced lines of a shipment where already invoiced lines can exist.
--  090622  NWeelk   Bug 83737, Modified the WHERE clause in CUSTOMER_ORDER_SHIP_INVOICE view, to prevent creating a shipment invoice when using
--  090622           internal order handling between two sites in the same company.
--  091105  MiKulk   Modified the cursor check_lines_invoiced in method Create_Invoice_Lines___ by removing the check for line_item_no to include the 
--  091115           sales promotion charge to an invoice which partially invoice the package components.
--  090911  MiKulk   Modified the cursor check_lines_invoiced in method Create_Invoice_Lines___ to check correct deal_id_.
--  090814  MaJalk   Modified Create_Shipment_Charge_Item___(), Create_Shipment_Invoice___() and view VIEW_SHIP_IVC to handle freight_chg_invoiced flag.
--  090811  Kisalk   Modified Create_Invoice_From_Return__ and Credit_Returned_Charge___ to consider charge percentage.
--  090527  SuJalk   Bug 83173, Modified the error message NOTAXINFO2 to remove the exclamation mark.
--  090504  ChJalk   Bug 81683, Modified the method Remove_Invoice to remove related invoice statistics when removing an invoice.
--  090424  NWeelk   Bug 80130, Modified Create_Invoice__ to check the existence of an advance or prepayment invoice.
--  090423  NWeelk   Bug 80130, Modified Create_Shipment_Invoice___ to check the existence of an advance or prepayment invoice.
--  090421  ChJalk   Bug 79793, Modified the Methods Create_Invoice__, Create_Collective_Invoice___ and Create_Collect_Ivc_Ord__ to release the 
--  090421           blocked Customer Orders after the Customer Order is Invoiced if there are only charge lines in the Customer Orders.
--  090416  NWeelk   Bug 80130, Modified the WHERE clause in CUSTOMER_ORDER_SHIP_INVOICE view to select records with prepayment invoices.
--  090415  DaGulk   Bug 81729, Increased the length of variable customer_no_ in Create_Invoice_From_Return__. 
--  090407  HimRlk   Bug 80277, Modified methods Create_Invoice__, Create_Advance_Invoice__, Create_prepayment_Invoice__, Create_Collective_Invoice___ and Create_Collect_Ivc_Ord__ to use 
--  090407           internal_po_label_note as Label Note when value exists for column. Added column internal_po_label_note to customer_order_collect_inv
--  090401  NWeelk   Bug 80130, Modified CUSTOMER_ORDER_COLLECT_INVOICE and COLLECT_CUSTOM_INVOICE views to filter records with advance or prepayment invoices,
--  090401           Modified procedure Chk_Adv_Inv_Exist_For_Ship__ by changing the procedure name to Chk_Ship_Adv_Pre_Inv_Exist__, adding OUT patameter 
--  090401           inv_type_ to the parameter list and by changing the conditions to check the existence of a prepayment invoice.
--  090325  ChJalk   Bug 81434, Modified the method Calculate_Prepaym_Amounts___ to take the description entered in prepayment invoice to the debet invoice.
--  090223  MaMalk   Bug 80722, Modified view Customer_Order_Inv_Item_Join to increase the length of description to 200.   
--  090219  MaRalk   Bug 75617, Modified cursor get_charge_deb_inv in method Credit_Returned_Charge___.
--  090213  MaRalk   Bug 75617, Modified cursor get_charge_deb_inv in method Credit_Returned_Charge___. 
--  090206  MaRalk   Bug 75617, Modified method Credit_Returned_Charge___ in order to add Debit Invoice Referance to invoice lines for charges.
--  090128  MaRalk   Bug 76921, Modified the functions Get_Head_Data_From_Rma___ and Create_Invoice_From_Return__ to handle the charge debit invoices.
--  090128           Added new function Create_Credit_Invoice_Rec___.
--  090122  SuJalk   Bug 79574, Modified the cursor Check_Invoice_Exist in function Check_Invoice_Exist_For_Co to query from the CUSTOMER_ORDER_INV_ITEM 
--  090122           to include collective invoices into the selection.
--  090102  SuJalk   Bug 79416, Modified CUSTOMER_ORDER_INV_ITEM_JOIN view to remove the join with Sales_Part_Pub. The catalog_group is now fetched using the Sales_Part_API.Get_Catalog_Group method call.
--  081224  SuJalk   Bug 79416, Added invoice date to the select list in CUSTOMER_ORDER_INV_ITEM_JOIN view. Also modified the where clause of CUSTOMER_ORDER_INV_ITEM_JOIN view to exclude advance and prepayment invoices. 
--  081224           Also joined SALES_PART view to CUSTOMER_ORDER_INV_ITEM_JOIN view inorder to get the catalog_group.
--  081031  ChJalk   Bug 76959, Added Procrdure Get_Invoice_For_Rma.
--  081031  RoJalk   Bug 78106, Added invoiced_qty to the view INVOICE_CUSTOMER_RMA_LOV.
--  081027  SuJalk   Bug 76539, Modified method Create_Shipment_Invoice___ to retrieve internal_po_no and internal_ref for the intersite flow.
--  081010  NaLrlk   Bug 74689, Modified the methods Create_Invoice__ and Get_Head_Data_From_Rma___ for passing the language code as a 
--  081010           parameter in method calls for ship_via_desc and delivery_term_desc.
--  081001  SuJalk   Bug 74635, Added delivery type to the paramterer list in method call Customer_Order_Inv_Item_API.Create_Invoice_Item. Also modified the Credit_Returned_Charge___ and Credit_Returned_Line___ to set the delivery type
--  081001           for RMA charge lines and RMA lines not connected to orders. 
--  080919  HoInlk   Bug 67780, Modified methods Create_Invoice__, Create_Collective_Invoice___
--  080919           and Create_Collect_Ivc_Ord__ to use internal_ref as customer reference when value exists for column.
--  080919           Added column internal_ref to customer_order_collect_inv.
--  080724  MaRalk   Bug 72697, Added currency_rate_type to the view COLLECT_CUSTOM_INVOICE. 
--  080630  MaRalk   Bug 68628, Restructured method Create_Invoice_From_Return__ in order to split invoices per currency rate type.
--  080630           Added new function Check_Pre_Created_Cre_Inv___. Defined a new type named Invoice_Id_Tab that will be used to store a list of Invoice id's.
--  080619  ThAylk   Bug 74429, Modified the view CUSTOMER_ORDER_SHIP_INVOICE to avoid invoicing of invoiced shipments when charges are added to the order.
--  080605  MaMalk   Bug 74658, Modified Create_Credit_Invoice__ to fetch the invoice type correctly when creating prepayment credit invoices. 
--  090701  MiKulk   Modified the method Create_Invoice_Lines___ to invoice the 'PROMOTION' type charges only with the connected invoice lines.    
--  090625  NaLrlk   Bug 83003, Modified the method Create_Invoice_Line___ to make the OUT parameter qty_invoiced_ an IN OUT parameter. 
--  090331  ShKolk   Added Create_Shipment_Charge_Item___().
--  090331  KiSalk   Modified Create_Invoice_Charge_Item___ to calculate charge_amount from percentage, when it is null.
--  081023  JeLise   Changed from check on customer_parent_ to check on assortment_node_id_ in Get_Rebate_Info___.
--  081022  JeLise   Added assortment_id_ := NULL in Get_Rebate_Info___.
--  081021  JeLise   Added check on rebate_type before calling Customer_Order_Inv_Item_API.Create_Invoice_Item in 
--  081021           Create_Rebate_Credit_Invoice__.
--  081017  AmPalk   Handled charged_qty when charge line is from a unit based Freight Charge in Create_Invoice_Lines___.
--  081014  JeLise   Added method Get_Rebate_Info___ and calls to it in Create_Invoice_Item___ and Credit_Returned_Line___.
--  080929  JeLise   Added check on hierarchy in the fetch of rebate info in Create_Invoice_Item___.
--  080925  JeLise   Changed the fetch of sales_part_rebate_group, assortment_id, and assortment_node_id in Create_Invoice_Item___.
--  080922  JeLise   Added check on assortment_node_id_ in Create_Invoice_Item___.
--  080919  JeLise   Added fetch of sales_part_rebate_group, assortment_id, and assortment_node_id in Create_Invoice_Item___.
--  080903  MaJalk   At Create_Invoice_Lines___, set charged_qty when charge line is pack size.
--  080828  MaJalk   Did corrections and added comments at Create_Invoice_Lines___.
--  080822  MaJalk   Modified Create_Invoice_Lines___ to create invoice charge lines related to Pack Size charge.
--  080813  AmPalk   Modified Remove_Invoice to remove invoice id from the settlement when a preliminary rebate invoice gets cancelled.
--  080702   JeLise   Merged APP75 SP2.
--  ----------------------- APP75 SP2 merge - End ------------------------------
--  080605  MaMalk   Bug 74658, Modified Create_Credit_Invoice__ to fetch the invoice type correctly when creating prepayment credit invoices.
--  080307  NaLrlk   Bug 69626, Increased the length of cust_ref to 30 in record type ivc_head_rec.
--  080225  MaMalk   Bug 70666, Modified Get_Head_Data_From_Rma___ to fetch the order_no to the invoice header when creating the credit invoice from the RMA line.
--  ----------------------- APP75 SP2 merge - Start ----------------------------
--  080612  MiKulk   Modified the Create_Invoice_Lines___ to correctly set the value to line_invoiced_.
--  080609  MiKulk   Removed the Unsued variables and the bug tags.
--  080606  MiKulk   Modified the methods Create_Invoice_Lines___ and Create_Invoice_Line___ to invoice the correct value for the
--  080606           order line connected unit charges.
--  080603  JeLise   Added check on currency_code and two new cursors in Create_Rebate_Credit_Invoice__.
--  080529  JeLise   Added final_settlement_ as in parameter in Create_Rebate_Credit_Invoice__ and code to handle creation
--  080529           of final settlement invoices.
--  080514  JeLise   Added print_invoice_ as in parameter and call to Customer_Order_Inv_Head_API.Print_Invoices
--  080514           in Create_Rebate_Credit_Invoice__.
--  080509  ShVese   In Create_Rebate_Credit_Invoice__ passed in negative INVOICED_QTY_COUNT_ to
--                   Customer_Order_Inv_Item_API.Create_Invoice_Item.
--  080508  ShVese   Changed assignment of line_no in call to Customer_Order_Inv_Item_API.Create_Invoice_Item
--                   in Create_Rebate_Credit_Invoice__.
--  080506  JeLise   Added code to create tax lines in Create_Rebate_Credit_Invoice__.
--  080423  RiLase   Added PROCEDURE Process_Rebate_Settlements___ and PROCEDURE Start_Create_Rebate_Cre_Inv.
--  080421  RiLase   Added company in call to Customer_Order_Inv_Item_API.Create_Invoice_Item.
--  080414  RiLase   Added Create_Rebate_Credit_Invoice.
--  ---------------- Nice Price ------------------------------------------------
--  080130  NaLrlk   Bug 70005, Added del_terms_location column to view CUSTOMER_ORDER_COLLECT_INV, CUSTOMER_ORDER_INVOICE_LINE, Record TYPE ivc_head_rec and passed the del_terms_location
--  080130           parameter to server call Customer_Order_Inv_Head_API.Create_Invoice_Head() in the methods Create_Collective_Invoice___, Create_Invoice_Head_For_Rma___,
--  080130           Create_Shipment_Invoice___, Create_Invoice__, Create_Collect_Ivc_Ord__, Create_Advance_Invoice__, Create_Credit_Invoice__, Create_Prepayment_Invoice__.
--  080112  LaBolk   Bug 68627, Modified method Create_Prepayment_Invoice__ to pass in a value instead of NULL for parameter use_ref_inv_curr_rate, in method call Create_Invoice_Head.
--  080109  MaRalk   Bug 70427, Modified method Create_Prepayment_Invoice__ in order to pass the parameter currency_rate_type to Customer_Order_Inv_Head_API.Create_Invoice_Head.
--  071224  MaRalk   Bug 64486, Added currency_rate_type to CUSTOMER_ORDER_SHIP_INVOICE,CUSTOMER_ORDER_COLLECT_INV and CUSTOMER_ORDER_COLLECT_INVOICE.
--  071224           Modified calls to Customer_Order_Inv_Head_API.Create_Invoice_Head to pass the currency rate type. Added new parameter currency_rate_type to
--  071224           Create_Collective_Invoice___, Create_Shipment_Invoice___ and Create_Invoice_Head_For_Rma___. Modified method Create_Invoice_From_Return__
--  071224           to consider currency_rate_type_ of the CO Line connected to RMA Line when creating invoices for individual RMA lines.
--  071224           Modified methods Create_Invoice__, Make_Collective_Invoice__, Create_Collect_Ivc_Ord__ and Create_Advance_Invoice__.
--  071213  MaMalk   Bug 69811, Modified Create_Prepayment_Invoice__ to remove the validations existed for project-prepayment combination.
--  071101  FreMse   Bug 67638, Added new warning CRINVEXISTFORDEBINV in order to give more information when credit invoices are created twice.
--  071101           Modified Chk_Prev_Credit_Invoices__.
--  070914  MaHplk   Modified columns net_dom_amount and vat_dom_amount in CUSTOMER_ORDER_INV_ITEM_JOIN view to get the values from CUSTOMER_ORDER_INV_ITEM.
--  070907  Cpeilk   Call 148010, Removed addition of invoice fee for invoices created from RMA and for prepayment invoices.
--  070810  MiKulk   Bug 66080, Modified the view INVOICE_CUSTOMER_RMA_LOV to get the correct deliver customer for collective invoices.
--  070810  MaJalk   Bug 66820, Modified view INVOICE_CUSTOMER_RMA_LOV and made a join with CUSTOMER_ORDER_LINE_TAB
--  070810           to fetch only the not returned debit invoices.
--  070808  ChBalk   Bug 62609, Added extra parameter to Create_Credit_Invoices.
--  070723  MiKulk   Bug 66249, Modified the method Get_Cred_Amt_Per_Db_Ivc__ to improve the performance of the cursor get_credited_amt.
--  070723           Also modified the method Check_Cre_Invoice_Exist, Get_Consumed_Line_Amt__,Get_Credited_Amt_Per_Order__ by removing the join to customer_order_inv_item.
--  070622  SuSalk   LCS Merge 65508, Modified views CUSTOMER_ORDER_INVOICE and CUSTOMER_ORDER_INVOICE_LINE to include orders with Advance Invoice.
--  070622           Removed obsolete condition invoice_sort IN ('N', 'C').
--  070605  MaJalk   Changed the type of parameter prepaym_vat_code_ in method Calculate_Prepaym_Amounts___.
--  070601  NiDalk   Modified Create_Sbi_Invoice_Item to update package component lines also when creating Self Billing Invoice.
--  070512  SuSalk   Modified Create_Shipment_Invoice___ procedure to avoid duplicate history lines for same customer order,
--  070512           when invoicing shipments.
--  070510  MaMalk   Modified Create_Advance_Invoice_Item___ to pass the customer_po_no when creating the invoice line.
--  070425  CsAmlk   Added ifs_assert_safe statement.
--  070418  WaJalk   Bug 64420, Modified view CUSTOMER_ORDER_INV_ITEM_JOIN and increased length of column CUSTOMER_PO_NO to 50 in the select statement.
--  070417  NiDalk   Bug 64079, Modified cursor get_qty_to_invoice in method Consume_Deliveries___ to consider
--  070417           the shipped quantity only when creating shipment invoices.
--  070416  NiDalk   Added check for NULL order_no before calling Customer_Order_History_API.New in Remove_Invoice.
--  070406  NaLrlk   Bug 44896, Modified the procedure Create_Collect_Ivc_Ord__ to update all the customer order histories with the newly created invoice number.
--  070323  MalLlk   Bug 60882, Modified the parameters of the function Tax_Regime_API.Encode() to retrive value for the header
--  070323           level parameters. Modified procedure Create_Invoice_Item___ to retrieve correct customer_tax_regime_db_ value.
--  070314  MiKulk   Bug 63516, Modified Create_Shipment_Invoice___ to pass ship_addr_no from customer order and not from shipment, when shipment invoice is created.
--  070305  DiAmlk   Modified the method Create_Collective_Invoice___.(Relate to IID MTIS907:New Service Contract)
--  070302  WaJalk   Bug 61985, Increased length of column CUSTOMER_PO_NO in view CUSTOMER_ORDER_INV_ITEM_JOIN and changed the length of
--  070302           variable customer_po_no_ in method Credit_Returned_Line___, cust_po_no_ in methods Create_Collective_Invoice___, Create_Collect_Ivc_Ord__ and Create_Invoice__.
--  070221  NuVelk   Modified method Calculate_Prepaym_Amounts___ to include PREPAY_INVOICE_NO and PREPAY_INVOICE_SERIES_ID in attribute string.
--  070220  Cpeilk   Modified method Create_Invoice__ to consider Unposted credit PBI invoices before creating CO debit invoice.
--  070127  NaWilk   Modified method Create_Prepayment_Invoice__ by adding MEDIA_CODE to print_attr_.
--  070129  ChBalk   Corrected static call to On_Account_Ledger_Item_API.Get_Payment_Amt_For_Order_Ref in Check_Req_Prepayments_Unpaid.
--  070129  Cpeilk   Modified method Create_Prepayment_Invoice__.
--  070126  RoJalk   Bug 60764, Changed private method Get_Credited_Amt_Per_Order__ to a public method.
--  070123  SuSalk   Code cleanup, Romeoved external DELIVERY_TERMS_DESC references & used Order_Delivery_Term_API.Get_Description
--  070123           method calls.
--  070118  SuSalk   Code cleanup, Removed external ship_via_code references & used Mpccom_Ship_Via_API.Get_Description
--  070118           Method calls.
--  061229  Cpeilk   Call ID 140469, Modified Create_Prepayment_Invoice__ to stop PBI creation when the CO is connected to a project.
--  061221  RoJalk   Modifications to the method Get_Prepaym_Based_Gross_Amt__.
--  061219  RoJalk   Moved the method Remove_Invoice from CustomerOrderInvHead.
--  061219  NiDalk   Bug 60598 Modified reference to debit_series_id_ to NULL when creating credit invoice for RMA in procedure Get_Head_Data_From_Rma___.
--  061215  ChBalk   Added extra condition when creating debit invoices to check whether all prepayment based invoices PaidPosted.
--  061215  Cpeilk   Call ID 140332, Checked method of invoicing is prepayment based before calling for consumptions in Create_Invoice__.
--  061215  RoJalk   Modified the formatting of error message in Create_Prepayment_Invoice__.
--  061214  Cpeilk   Call ID 140298, Modified methods Get_Prepaym_Based_Gross_Amt__ and Get_Consumed_Line_Amt__.
--  061213  RoJalk   Modifications to the Get_Prepaym_Based_Gross_Amt__.
--  061208  MiKulk   Modified the method Create_Prepayment_Invoice__ to raise error for invalid payment terms.
--  061208           And also to consider the invoicing customer when setting the order reference.
--  061127  Cpeilk   Modified the exception in method Create_Prepayment_Invoice__.
--  061126  NaLrlk   Bug 61804, Changed format of invoice_no in CUSTOMER_ORDER_INV_ITEM_JOIN to Uppercase.
--  061124  NaLrlk   Bug 60780 Added method Chk_Adv_Inv_Exist_for_Ship__ and modified Create_Shipment_Invoice___ to check if advance invoices exist for orders in a Shipment.
--  061123  OsAllk   Bug 60776, Modified view COLLECT_CUSTOM_INVOICE to base it on CUSTOMER_ORDER_COLLECT_INV in order to eliminate duplicate conditions.
--  061123           Modified view CUSTOMER_ORDER_COLLECT_INV to add rowstate. Modified Create_Collective_Invoice___ to rule out advance invoices from the cursor selection.
--  061122  Cpeilk   Modified Create_Prepayment_Invoice__ to add a dynamic call to On_Account_Ledger_Item_API.
--  061122  ChBalk   Prepayment Credit Invoice creation and modification changes.
--  061120  Cpeilk   Added new methods Reconsume_Prepaym_Inv_Lines__ and Unconsume_Prepaym_Inv_Lines___.
--  061120  KaDilk   modified method Get_Prepaym_Based_Gross_Amt__.
--  061117  Cpeilk   Modified the exception in method Create_Prepayment_Invoice__.
--  061116  Cpeilk   Added new methods Calculate_Prepaym_Amounts___ and Consume_Prepaym_Inv_Lines___.
--  061110  Cpeilk   Modified method Create_Prepayment_Invoice__.
--  061108  Cpeilk   Added new methods Create_Prepayment_Invoice__ and Check_Invoice_Exist_For_Co.
--  061108           Removed hard coded correction invoice types.
--  061103  KaDilk   Modified the method Get_Prepaym_Based_Gross_Amt__.
--  061101  JaBalk   Removed unwanted error message CREIVCERR from Create_Credit_Invoice__.
--  061025  Cpeilk   Modified the where condition in view CUSTOMER_ORDER_SHIP_INVOICE to exclude
--                   shipments which have customer orders with prepayments
--  061019  ChBalk   Added method content of Check_Req_Prepayments_Unpaid.
--  061018  MiErlk   Bug 60272, Added NOCHECK to some columns in view CUSTOMER_ORDER_INVOICE_LINE.
--  061016  KaDilk   Added functions  Get_Prepaym_Based_Gross_Amount__ and Get_Consumed_Line_Amount__.
--  061012  ChBalk   Added new method Check_Req_Prepayments_Unpaid
--  061010  YaJalk   Bug 60872, Modified PROCEDURE Credit_Returned_Line___ to send internal PO number to create invoice as priority 1.
--  060918  KaDilk   Bug 59530, Modified methods Credit_Returned_Line___ and Credit_Returned_Charge___ to include a check on credit_invoice_no
--  060918           So that two invoices are not created for a line which is processed simultaneously.
--  060915  ChJalk   Modified Validate_Credit_Inv_Creation__ and Create_Credit_Invoice__ to modify the error messages.
--  060829  IsWilk   Bug 48560, Added series_id to the view CUSTOMER_ORDER_INV_ITEM_JOIN.
--  060818  JaBalk   Removed the NC from Create_Invoice__.
--  060815  MalLlk   Modified Create_Invoice__ by replacing Cust_Ord_Customer_API.Get_Invoice_Sort with Cust_Ord_Customer_API.Get_Invoice_Sort_Db.
--  060814  MalLlk   Added new Customer Invoice Type 'Normal and Collective'.
--  060802  MaMalk   Replaced OrderDeliveryTermDesc with OrderDeliveryTerm.
--  060725  ChJalk   Replaced Mpccom_Ship_Via_Desc_API.Get_Description with Mpccom_Ship_Via_API.Get_Description
--  060725           and Order_Delivery_Term_Desc_API.Get_Description to Order_Delivery_Term_API.Get_Description.
--  060720  RoJalk   Centralized Part Desc - Use Sales_Part_API.Get_Catalog_Desc.
--  060627  ChJalk   Added parameter series_id in to the method Get_Cred_Amt_Per_Db_Ivc__ and modified the method Get_Head_Data_From_Rma___.
--  060619  ChJalk   Added the parameter series_id in call Customer_Order_Inv_Head_API.Get_Invoice_Id_By_No.
--  060612  ChBalk   Modified INVOICE_CUSTOMER_RMA_LOV to show all the debit invoices and only last correction invoices.
--  060607  MiErlk   Enlarge Description - Changed Variables Definitions.
--  060607  MiErlk   Enlarge Description - Changed View Comments .
--  060607  PrPrlk   Bug 58492, Made changes to the view CUSTOMER_ORDER_INV_ITEM_JOIN to display the invoiced_qty as a negative amount for invoice type SELFBILLCRE.
--  060606  Prkolk   Bug 58370, Modified the calling position of procedure Lock_Rma_Head___ inside Create_Invoice_From_Return__.
--  060606  MaMalk   Modified Get_Head_Data_From_Rma___ to retrieve the correct debit invoice no to the credit invoice head.
--  060606  ChJalk   Modified the methods Chk_Prev_Credit_Invoices__ and Validate_Credit_Inv_Creation__ to give correct warning messages online.
--  060602  MiKulk   Modified the calls to Customer_Order_Inv_Head_API.Create_Invoice_Head by using correct parameters.
--  060602           Also removed the logic to retrieve the currency rates, and instead passed correct value for use_ref_inv_curr_rate.
--  060602  MaMalk   Modified Validate_Credit_Inv_Creation__ to correct an error in the error message given by constant MUTLIPLECONN.
--  060601  Prkolk   Bug 58370, Added procedure Lock_Rma_Head___ and called it inside Create_Invoice_From_Return__.
--  060529  NuFilk   Bug 58257, Modified Create_Shipment_Invoice___ to set the correct invoice type in method Customer_Order_Inv_Head_API.Create_Invoice_Head.
--  060529  MaMalk   Modified Get_Prev_Ref_Invoices and Get_Debit_Invoices to exclude the number_reference null records.
--  060526  MaMalk   Modified Get_Debit_Invoices to correct the invoice type from CUSTCOLDDEB to CUSTCOLDEB.
--  060526  MaMalk   Modified Validate_Credit_Inv_Creation__, Get_Cred_Amt_Per_Db_Ivc__ and Get_Credited_Amt_Per_Order__ to handle correction/credit invoices when creating correction/credit
--  060526           invoices. Modified Get_Credit_Invoices and Get_Debit_Invoices to decrease the length of invoice_type. Modified Create_Credit_Invoice__ to change an error message.
--  060525  SaRalk   Enlarge Identity - Modified lengths of customer_no and customer_no_pay in VIEW_RMA_LOV.
--  060524  KeFelk   Enlarge Identity - Modified variable definitions in ivc_head_rec.
--  060524  MaMalk   Modified Create_Invoice_From_Return__ to exclude the RMA lines and charges with credit_approver_id is null and status 'Planned'
--  060524           when creating credit invoices.
--  060523  MaMalk   Added method Check_Cre_Invoice_Exist.
--  060522  PrPrlk   Bug 54753, In view CUSTOMER_ORDER_INV_ITEM_JOIN, fetched the column invoice_no from CUSTOMER_ORDER_INV_HEAD instead of CUSTOMER_ORDER_INV_ITEM and defined constant CUSTOMER_ORDER_INV_HEAD.
--  060522  ChJalk   Modified Create_Credit_Invoice__ for selecting wanted_delivery_date from the Customer_Order_Inv_Head view, instead of delivery_date.
--  060519  MaMalk   Modified Validate_Credit_Inv_Creation__ to remove the validations done for the credit invoices and to move some validations
--  060519           to Return_Material_Lines. Modified Create_Invoice_From_Return__ to remove the calling of Validate_Credit_Inv_Creation__.
--  060518  PrPrlk   Bug 57945, Made changes to the method Create_Invoice_Line___ to correctly handle order lines having staged billing lines.
--  060518  MaRalk   Bug 57349, Modified the view INVOICE_CUSTOMER_RMA_LOV.
--  060518  MiErlk   Enlarge Identity - Changed view comment
--  060517  MaMalk   Added method Validate_Credit_Inv_Creation__. Modified methods Create_Invoice_From_Return__ and Create_Credit_Invoice__
--  060517           to call the newly added method. Modified Create_Corr_Inv_From_Return to clear the attribute string.
--  060517  NaLrlk   Enlarge Address  - Changed variable definitions.
--  060516  MiErlk   Enlarge Identity - Changed view comment
--  060510  JaBalk   Modified Chk_Prev_Credit_Invoices__,Create_Credit_Invoice__
--  060510           to raise CORINVEXIST,CORINVEXISTFORREF messages.
--  060503  JaBalk   Modified the cursor in Create_Corr_Inv_From_Return method.
--  060428  MaMalk   Added methods Get_Prev_Ref_Invoices, Get_Credit_Invoices and Get_Debit_Invoices.
--  060428  JaBalk   Passed rma_no_ to Customer_Order_Inv_Head_API.Create_Invoice_Head method in Create_Credit_Invoice__.
--  060426  MaMalk   Modified Create_Credit_invoice__ to set the correction_invoice_id of the reference invoice when a correction invoice is created.
--  060426  JaBalk   Added Create_Corr_Inv_From_Return and removed Is_Rma_Lines_Exist_For_Order.
--  060425  JaBalk   Added Prel_Update_Allowed condition for VIEW_RMA_LOV
--  060424  JaBalk   Added parameter invoice_category to Create_Credit_Invoices to handle
--  060424           both credit and correction invoices.
--  060421  MaMalk   Added methods Create_Credit_Invoice__ and Create_Credit_Invoices. Modified methods Credit_Returned_Line___
--  060421           and Credit_Returned_Charge___ to handle the newly added paramter ref_invoice_id_ in Create_Credit_Invoice_Hist.
--  060421           Modified Create_Invoice_Charge_Item___, Create_Invoice_Item___, Credit_Returned_Line___, Credit_Returned_Charge___
--  060421           and Create_Advance_Invoice_Item___ to handle the parameter prel_update_allowed_ when calling Customer_Order_Inv_Item_API.Create_Invoice_Item.
--  060421  JaBalk   Added Get_Corr_Amt_Per_Ref_Ivc__ to get amount_to_correct.
--  060419  MaJalk   Enlarge Customer - Changed variable definitions.
--  060418  NaLrlk   Enlarge Identity - Changed view comments of deliver_to_customer_no.
--  060418  RoJalk   Enlarge Identity - Changed view comments.
--  060412  RoJalk   Enlarge Identity - Changed view comments.
--  -------------------- 13.4.0 ------------------------------------------------
--  060327  RaKalk   Modified get_tax_lines cursor of the Create_Invoice_Item___ procedure to
--  060327           fetch the tax line of the package header when the individual components are being invoiced.
--  060316  SaRalk   Modified procedures Create_Advance_Invoice__, Create_Advance_Invoice_Item___ and Create_Adv_Inv_Tax_Item___.
--  060309  IsAnlk   Modified Create_Invoice_Lines___ to allow create collective invoices with charges.
--  060227  MiKulk   Bug 51197, Modified the Create_Advance_Invoice__ to pass the pay_tax_ and added more validation in that logic.
--  060224  MiKulk   Bug 51197, Modified fetching value of fee_code in methods Create_Invoice_Charge_Item___,
--  060224           Create_Invoice_Item___, Credit_Returned_Line___, Create_Adv_Inv_Tax_Item___ and Credit_Returned_Charge___.
--  060214  SuJalk   Changed the cusror get_qty_to_invoice in consume_deliveries to create invoices from shipments.
--  060211  NuFilk   Modified method Create_Invoice_From_Return__ to handle Sales part cross reference correctly.
--  060207  CsAmlk   Changed Paying Customer as Invoicing Customer in View INVOICE_CUSTOMER_RMA_LOV.
--  060128  NiDalk   Added method Is_Create_Credit_Invoice_Ok.
--  060111  ChJalk   Bug 54699, Added the column Price_Adjustment to the view CUSTOMER_ORDER_INV_ITEM_JOIN.
--  051227  KanGlk   Modified Consume_Deliveries___ procedure.
--  051222  PrPrlk   Bug 55262, Modified method Credit_Returned_Charge___ to fetch the charge type description correctly using the language used.
--  051220  IsAnlk   Added shipment_id as a parameter to Create_Invoice_Line___ and Consume_deliveries___.
--  051124  SaRalk   Modified the ONE_VAT_EXIST error message in procedure Create_Advance_Invoice__.
--  051118  MaMalk   Bug 51903, Added method Get_Credited_Amt_Per_Order__ instead of Get_Credited_Amt_Per_Db_Ivc and
--  051118           Added method Get_Cred_Amt_Per_Db_Ivc__ instead of Get_Cred_Amt_Per_Coll_Db_Ivc. Restructured the procedure Chk_Prev_Credit_Invoices and made it private.
--  051110  SaRalk   Modified procedures Create_Advance_Invoice__, Create_Advance_Invoice_Item___ and Create_Adv_Inv_Tax_Item___.
--  051109  KanGlk   Removed unused variables. Added savepoint to Create_Shipment_Invoice___.
--  051007  KanGlk   The Calculate_Qty_To_Invoice___ method modified to include the actual updates of consumption deliveries and renamed as Consume_Deliveries___.
--  051007           Old  method Consume_Deliveries___ removed and a new method Connect_Delivs_To_Ivc_Item___ wrote to connect the invoice item_id to the relevant tables.
--  051007           According TO the above changes modified Create_Invoice_Line___ methed as well.
--  051007           Even though there is no invoice lines, Customer Invoice Header is being created; to avoid this, modified Create_Collective_Invoice___ and Create_Collect_Ivc_Ord__ methods with savepoints.
--  051003  SuJalk   Changed reference in views COL_IVC_VIEW,VIEW_SHIP_IVC,CO_IVC,CO_IVC_LINE to user_allowed_site_pub.
--  050928  KanGlk   Removed unused variables. Modified Create_Collective_Invoice__ and Create_Collect_Ivc_Ord__ procedures.
--  050916  ChJalk   Bug 50514, Modified the view CUSTOMER_ORDER_INV_ITEM_JOIN.
--  050914  RaKalk   Modified Create_Invoice_From_Return__ method to create invoice header when there are only charge lines in the RMA
--  050902  UsRalk   Changed COL_VIEW (CUSTOMER_ORDER_COLLECT_INVOICE) to increase performance.
--  050831  JoEd     Changed use of qty_confirmeddiff. It can be negative.
--  050816  PrPrlk   Bug 37375, Replace use of attr_copy_ to use attr_ instead in Procedure Create_Collect_Ivc_Ord__.
--  050816  AnLaSe   CID 125779, added qty_on_invoice to CO_IVC_LINE.
--  050816  IsAnlk   Added cust_part_price_ parameter to Create_Sbi_Invoice_Item and to Create_Invoice_Item___.
--  050816  IsWilk   Modified the cursor get_head_data_from_first_order to avoid
--  050816           creation of Invoice Headers for empty lines in PROCEDURE Create_Collect_Ivc_Ord__.
--  050803  RaSilk   Added jinsui_invoice to COLLECT_CUSTOM_INVOICE.
--  050721   RaKalk   Added public method Create_Invoice_Charge_Line
--  050708  SaJjlk   Added condition to view COLLECT_CUSTOM_INVOICE to exclude self-billing order lines.
--  050707  NuFilk   Added method Create_Sbi_Invoice_Item and modified method Create_Invoice_Item___.
--  050706  RaSilk   Added method Get_Js_Invoice_State_Db___ and logic to handle Jinsui Invoices.
--  050628  MaEelk   Modified view CUSTOMER_ORDER_INVOICE. Ordder_No was selected as objid instead of the Customer_No.
--  050624  MaEelk   Modified views CUSTOMER_ORDER_INVOICE and CUSTOMER_ORDER_INVOICE_LINE
--  050622  RaKalk   Modified view CUSTOMER_ORDER_SHIP_INVOICE to fetch the Invoic unlocked lines from shipments with already invoiced lines.
--  050622  IsAnlk   Modidfied the views CUSTOMER_ORDER_COLLECT_INV, COLLECT_CUSTOM_INVOICE to
--                   to handle provisional_price to stage billing.
--  050617  MaEelk   Modified the cursor get_line_to_invoice in Create_Invoice_lines___
--  050617           to remove invoiced blocked lines from invoice
--  050615  IsWilk   Added the parameter lines_invoiced to PROCEDUREs Create_Invoice_Line___ ,
--  050615           Create_Invoice_Lines___ and modified cursor head_data, get_qty_to_invoice in
--  050615           PROCEDUREs Create_Collective_Invoice___ , Calculate_Qty_To_Invoice___.
--  050614  IsWilk   Modified the PROCEDURE Create_Collect_Ivc_Ord__ , Make_Collective_Invoice__.
--  050614  IsWilk   Modified the view commets of columns fee_code, delivery_terms in CUSTOMER_ORDER_INVOICE_LINE.
--  050613  WaJalk   Modified view CUSTOMER_ORDER_INVOICE_LINE, added column currency_rate.
--  050610  IsWilk   Modified PROCEDURE Create_Invoice_Line___ to call Consume_Deliveries___
--  050610           inside the codition (qty_to_invoice_ != 0).
--  050610  IsWilk   Modified cursor get_ship_line_to_invoice in PROCEDUE Create_Invoice_Lines___.
--  050610  MaMalk   Bug 51361, Changed views Collect_Custom_Invoice, Customer_Order_Collect_Invoice and method Create_Collective_Invoice___.
--  050609  WaJalk   Modified views CUSTOMER_ORDER_INVOICE and CUSTOMER_ORDER_INVOICE_LINE to select both normal and collective invoice types.
--  050609  IsWilk   Modified the PROCEDURE Create_Invoice__ to pass the ignore_closing_date_ as 'TRUE' .
--  050608  WaJalk   Further modifications in views CUSTOMER_ORDER_INVOICE and CUSTOMER_ORDER_INVOICE_LINE.
--  050608  IsWilk   Modified cursor get_ship_line_to_invoice to check the date_delivered
--  050608           with date_delivered and pass ignore_closing_date_ and closest_closing_date_
--  050608           when calling Create_Invoice_Line___ for Create Shipment invoice in the PROCEDURE Create_Invoice_Lines___.
--  050607  WaJalk   Modified views CUSTOMER_ORDER_COLLECT_INV, CUSTOMER_ORDER_INVOICE and CUSTOMER_ORDER_INVOICE_LINE.
--  050607  IsAnlk   Added condition col.provisional_price = 'FALSE' to views for avoid invoicing of provisional prices.
--  050531  IsWilk   Renamed the view COLLECT_INVOICE_PER_ORDER_lINE as CUSTOMER_ORDER_INVOICE_LINE
--  050531           added the new view CUSTOMER_ORDER_INVOICE.
--  050527  IsWilk   Added the new view COLLECT_INVOICE_PER_ORDER_lINE, CUSTOMER_ORDER_COLLECT_INV
--  050527           and modified view CUSTOMER_ORDER_COLLECT_INVOICE, added the parameter
--  050527           ignore_closing_date_, closest_closing_date_ to the Calculate_Qty_To_Invoice___,
--  050527           Create_Invoice_Line___ , Create_Invoice_Lines___ , Create_Collective_Invoice___.
--  050526  MaEelk   Added condition col.blocked_for_invoicing = 'FALSE' to the COLLECT_CUSTOM_INVOICE view.
--  050520  JoEd     Added check on delivery confirmation in Create_Advance_Invoice__.
--  050512  SaLalk   Bug 49825, Removed the statment which assign 0 to fee_code_ when it is NULL in Create_Invoice_Item___ function.
--  050511  JoEd     Changed Calculate_Qty_To_Invoice___ to decrease whole packages with qty_confirmeddiff
--                   when invoicing excess components.
--  050510  MaMalk   Bug 50891, Removed method Get_Max_Qty_To_Rtn_Str since the same functionality is implemented in Return Material Line.
--  050505  LaBolk   Bug 50111, Modified WHERE clause of views COLLECT_CUSTOM_INVOICE and CUSTOMER_ORDER_COLLECT_INVOICE to exclude state 'Invoiced' in staged billing checks.
--  050504  ChJalk   Bug 50859, Made changes to avoid Orderless Charges being invoiced when using Customer Consignment Stock,if the reporting Consignment Consumption has not been done.
--  050426  ChJalk   Bug 50859, Made changes to avoid Orderless Charges in state 'Credit Blocked' being invoiced.
--  050425  JoEd     Changed Consume_Deliveries___, Create_Invoice_Lines___, Create_Collective_Invoice___,
--                   Create_Shipment_Invoice___ and Calculate_Qty_To_Invoice___ to exclude incorrect deliveries.
--                   Also added the same where clause to the views COL_VIEW, COL_IVC_VIEW and VIEW_SHIP_IVC.
--  050411  JoEd     Changed method Consume_Deliveries___ to update outstanding sales records
--                   when creating invoice items.
--  050210  ChJalk   Bug 49252, Removed Method Handle_Zero_Invoice_Order___, Added PROCEDURE Calculate_Qty_To_Invoice___
--  050210           and Modified METHODS Consume_Deliveries___ and Create_Invoice_Line___. Also removed the unused parameter
--  050210           currency_code_ from PROCEDURES Create_Invoice_Line___, Create_Invoice_Charge_Line___ and Create_Invoice_Lines___.
--  050126  ChJalk   Bug 48740, Added FUNCTION Get_Cust_Ord_Location_Code.
--  050105  IsAnlk   Modified where clause of Customer_Order_Ship_Invoice.
--  041221  NiRulk   Bug 48473, Modified function Get_Max_Qty_To_Rtn_Str.
--  041210  SaJjlk   Removed view SBI_PRICE_DEVIATIONS and moved it to OrderSelfBillingManager.apy.
--  041102  AmPalk   Bug 44333, Modified INVOICE_CUSTOMER_RMA_LOV view by adding delivery_identity column.
--  041006  NuFilk   Modified the cursor get_qty_to_invoice in method Consume_Deliveries___ and Create_Invoice_Line___ to consider delivery note.
--  041006           Added shipment_id_ as new parameter to method Create_Invoice_Line___ and Consume_Deliveries___.
--  040908  ChBalk   Bug 46252, Modified Credit_Returned_Line___, Added invoiced customer when creating invoice tax lines.
--  040907  reanpl  FIJP344 Japanese Tax Rounding
--  040901  NaWilk   Bug 40315, Modified method Create_Invoice_Item___ to retrieve FeeCode correctly.
--  040827  MaMalk   Bug 44416, Modified the procedure Create_Invoice_From_Return__ to show the debit_invoice_no in the credit invoice when created from the RMA header.
--  040513  NaWilk   Bug 43579, Modified method Credit_Returned_Line___.
--  040511  UdGnlk   Bug 41757, Modified Create_Collect_Ivc_Ord__, Create_Collective_Invoice___ and CUSTOMER_ORDER_INV_ITEM_JOIN in order to handle two new
--  040511           collective invoice types CUSTCOLDEB and CUSTCOLCRE.
--  040430  IsAnlk   B114558 - Modified Create_Advance_Invoice__.
--  040421  NaWilk   Bug 43579, Modified method Credit_Returned_Line___ and Credit_Returned_Charge___ to retrieve the Tax Code correctly.
--  040421  NaWilk   Bug 43578, Modified method Create_Invoice_Item___ and Create_Invoice_Charge_Item___ to retrieve the Tax Code correctly.
--  040415  MiKalk   Bug 42707, Modified method signature and the method body of the methods Create_Invoice_Head_For_Rma___ and Create_Invoice_From_Return__.
--  ----------------------------TouchDown Merge End-------------------------------------
--  040316  IsAnlk   B113369 , Made changes to enable edit of Advance Credit Invoices in Create_Advance_Invoice_Item___.
--  040302  IsAnlk   B112888 - Added method Get_Tax_Percentage__ and modified  Create_Advance_Invoice__ to display history line correctly.
--  040301  HeWelk   Modified Create_Advance_Invoice__ to disable advance invoices when
--                   order is connected to stage billing.
--  040225  AjShlk   Performed code review
--  040224  GaJalk   Modified the procedure Create_Invoice__.
--  040216  AjShlk   Modified the method Create_Advance_Invoice__ to display invoice address, our ref and cust ref.
--  040203  AjShlk   Modified the method Create_Advance_Invoice__ to print invoice automatically.
--  040202  GaJalk   Modified the view CUSTOMER_ORDER_COLLECT_INVOICE to exclude orders with advance invoices.
--                   Modified the procedure Create_Invoice__.
--  040202  AjShlk   Added new method Create_Adv_Inv_Tax_Item__ to handle tax for advance invoices.
--  040129  AjShlk   Added new method Create_Advance_Invoice__ and Create_Advance_Invoice_Item__
--  040129           to handle advance invoices.
--  ----------------------------TouchDown Merge Begin-------------------------------------
--  040311  NaWilk   Bug 39654, Modified the method Get_Head_Data_From_Rma___ to get the correct ship_addr_no.
--  040305  UdGnlk   Bug 42877, Modified the where clause of CUSTOMER_ORDER_INV_ITEM_JOIN from invoice_no to invoice_id.
--  040224  IsWilk   Modified the SUBSTRB TO SUBSTR and removed the unnecessary SUBSTR from the view for Unicode Changes.
--  040220  ErSolk   Bug 40425, Made changes to retrieve correct tax percentage.
--  040129  SaRalk   Bug 41968, Modified procedure Credit_Returned_Line___ to fetch the correct catalog_desc_ when an order is not connected to the RMA.
--  ********************* VSHSB Merge End *****************************
--  021203  GeKaLk   Added new public method Create_Invoice_Tax_Item.
--  021115  PrInLk   Modified the method Create_Invoice_Lines___ to creation of invoice only corresponds to the given shipment.
--  021024  GeKalk   Moved SBI_PRICE_DEVIATIONS from SelfBillingItem LU.
--  021021  Prinlk   Added an extra condition to the Customer_Order_Ship_Invoice to avoid replication of previously invoiced
--                   shipments. Rearrange the methods to comply with IFS Design tool.(Removed 'Red' code).
--  021016  GEKALK   Corrected in order to open in the Delta Engine.
--  021009  GEKALK   Added a check for self_billing to CURSOR head_data in Create_Shipment_Invoice___ and
--                   CURSOR get_ship_line_to_invoice in Create_Invoice_Lines___ to exclude self billing parts from shipment invoice.
--  021009  GEKALK   Added a check for self_billing to CUSTOMER_ORDER_SHIP_INVOICE view creation statement to
--                   exclude self billing parts.
--  020610  ARAM     Added default null parameter to method Create_Invoice_Head_For_Rma___ and modified Create_Invoice_From_Return__
--                   to hadle self billing credit invoices. Remove Make_Self_Billing_Invoice__.
--  020314  GeKa     Modified the selection of records of all the places modified last.
--  020314  GeKa     Modified the selection of records to CUSTOMER_ORDER_COLLECT_INVOICE, CURSOR get_line_to_invoice in
--                   Create_Collective_Invoice___ ,CURSOR get_line_to_invoice in Create_Invoice_Lines___ , CURSOR get_order_line_total
--                   and CURSOR get_order_lines in Create_Invoice__  .
--  020312  ARAM     Added new method Make_Self_Billing_Invoice__
--  020312  GeKa     Changed the selection of records to CUSTOMER_ORDER_COLLECT_INVOICE.
--  020610  DaMase   Corrected spelling error in last change.
--  020529  DaMa     Changed cursor get_ship_line_to_invoice due to performance.
--  020429  MaGu     Added methods Make_Shipment_Invoice__, Create_Shipment_Invoice__ and
--                   Create_Shipment_Invoice___. Modified method Create_Invoice_Lines to
--                   handle shipment_id_. Added view CUSTOMER_ORDER_SHIP_INVOICE.
--  ********************* VSHSB Merge Start *****************************
--  031107  JaJalk   Modified the method Credit_Returned_Line___ to get the rma tax percentage.
--  031104  JaJalk   Reversed the bug correction 102366, since it was not the correct functionality.
--  031029  NuFilk   LCS 39163, Re-Designed the view CUSTOMER_ORDER_INV_ITEM_JOIN.
--  031021  NaWalk   Modified the Method "Get_Cred_Amt_Per_Coll_Db_Ivc" Removed the parameter invoice_id_.
--  031015  JaJalk   Added the parameter date to the method call Customer_Info_Vat_API.Get_Liability_Db.
--  031013  JaJalk   Modified the methods Create_Invoice_Charge_Item___,Create_Invoice_Item___,Credit_Returned_Line___ and Credit_Returned_Charge___ to support tax excempt.
--  031013  PrJalk   Bug Fix 106224, Chagned incorrect General_Sys.Init_Method calls.
--  031010  JaJalk   Modified the methods Create_Invoice_Charge_Item___,Create_Invoice_Item___,Credit_Returned_Line___ and Credit_Returned_Charge___ to support tax excempt.
--  031010  NaWalk   Added the Method "Get_Cred_Amt_Per_Coll_Db_Ivc".
--  030930  JaJalk   Removed the calls Identity_Invoice_Info_API.Get_Vat_Free_Vat_Code and Customer_Info_Vat_API.Get_Vat_Free_Vat_Code to handle the indirect tax.
--  030919  JaJalk   Modified the method Create_Invoice_Item___ to handle tax Exempt.
--  030916  ChJalk   Bug 38360, Modified Get_Head_Data_From_Rma___ to fetch the header details of the RMA when create the invoice from charged lines.
--  030915  MiKulk   Bug 38139, Removed the conditions for the customer_no and customer_no_pay from CUSTOMER_ORDER_INV_ITEM_JOIN.
--  030915  ThPalk   Bug 38121, Added subqueries to the view CUSTOMER_ORDER_INV_ITEM_JOIN.
--  030912  JaJalk   Corrected the calculated vat 0 error.
--  030912  MiKulk   Bug 37677, Modified the where condition in the view CUSTOMER_ORDER_COLLECT_INVOICE to restrict creating invoices for a internal customer
--  030912           when both the ordering site and the manufacturing site belongs to the same company.
--  030909  ErSolk   Bug 37862, Made changes to stop Charges for orders that have not yet been delivered from being invoiced.
--  030904  PrTilk   Made changes to procedure Create_Invoice_From_Return__. Added checks to exclude exchange and no charge lines
--  030904           when creating the credit invoices.
--  030804  GaJalk   Code review changes.
--  030804  SaNalk   Performed SP4 Merge.
--  030708  ChFolk   Reversed the changes that have been done for Advance Payment.
--  030515  CaRase   Bug 37375, Replace use of attr_copy_ to use attr_ instead in Procedure Create_Collect_Ivc_Ord__.
--  030514  JaBalk   Bug 37324, Get the charge total in base currency,Use base_charge_amount instead of charge_amount in
--  030514           Create_Collective_Invoice___ ,Create_Invoice__ ,Create_Collect_Ivc_Ord__.
--  030507  JaBalk   Bug 36929, Moved get_zero_amount_order_charges cursor to Handle_Zero_Invoice_Order___ from methods Create_Collective_Invoice___ ,Create_Invoice__ ,Create_Collect_Ivc_Ord__.
--  030507           Modified the Qty_Invoiced of charge line when the total order is zero.
--  030506  JaBalk   Bug 36695, Added Handle_Zero_Invoice_Order___,Consume_Deliveries___ to handle all bugs related to zero invoice orders.
--  030506           Removed get_order_lines cursor and restrucure it under the above methods.
--  030506           All bugs 20897,22917,25559,27846,27928,28758,31053,31508,33698,34420,34424,34528,34663,35463,35989 have beed handled.
--  030428  ChIwlk   Changed procedure Create_Invoice_From_Return__ to allow creating credit invoices
--                   for zero valued RMA lines.
--  030425  JaJaLk   Added the PARENT_FEE_CODE to cursor get_tax_lines in Create_Invoice_Charge_Item___.
--  030421  ChIwlk   Removed the checks which prevent zero valued invoices in procedures Create_Collect_Ivc_Ord__,
--                   Create_Collective_Invoice___ and Create_Invoice__. Removed the cursors and variables
--                   used to block zero invoices and thus not needed now.
--  030417  MiKulk   Bug 36640, Modified the procedure Create_Collect_Ivc_Ord__ to modify the discount bonus for CO lines.
--  030409  MiKulk   Bug 36640, Modified the procedure Create_Collective_Invoice___ to modify the discount bonus for CO lines.
--  030402  SaNalk   Removed commented codes of previous modification.
--  030401  SaNalk   Change the checks to customer's tax regime in procedures Create_Invoice_Charge_Item___ and Credit_Returned_Charge___.
--  030328  JaBalk   Bug 36560, Reversed the correction 34728.
--  030327  UdGnlk   Modified Create_Invoice_Item___ and Credit_Returned_Line___ to condition with customer tax regime.
--  030324  UdGnlk   Modified Credit_Returned_Line___ to avoid company_pays_vat condition.
--  030319  UdGnlk   Modified  Create_Invoice_Tax_Item___ & Create_Invoice_Item___ procedure.
--  030317  ThPalk   Bug 35664, Added condition to check customer order state in methods Create_Collective_Invoice___ ,Create_Invoice__ ,Create_Collect_Ivc_Ord__.
--  030317  SeKalk   Bug 35989, Modified methods Create_Invoice__, Create_Collective_Invoice__ and Create_Collect_Inv_Ord__ to handle zero priced lines.
--  030305  LaBolk   Bug 35664, Modified methods Create_Invoice__, Create_Collective_Invoice___ and Create_Collect_Ivc_Ord__ to handle zero charge lines.
--  030228  AjShlk   Performed code review and modified Create_Invoice_Lines___().
--  030214  MaMalk   Bug 35855, Modified the procedure Get_Head_Data_From_Rma___ to transfer the reference in the RMA header to the credit invoice
--  030214           when a reference exists in the RMA header.
--  030213  NaWilk   Bug 35463, Modified cursor get_line_to_invoice by adding a sub query in the PROCEDURE Create_Invoice_Lines___
--  030213  NaWilk   Bug 35463, Modified cursor get_line_to_invoice by joining CUSTOMER_ORDER_DELIVERY_TAB and added aliases accordingly in the PROCEDURE Create_Invoice_Lines___
--  030210  KiSalk   Bug 35664, Modified procedures Create_Invoice__, Create_Collective_Invoice___ and Create_Collect_Ivc_Ord__
--  030129  AjShlk   Code Reveiw
--  030129  PrJalk   Moved the method description part of methods to correct position
--  030119  AjShlk   Performed code review.
--  030102  SaRalk   Bug 34728, Modified procedure Create_Invoice__, Create_Invoice_Line___, Create_Invoice_Item___, Create_Collective_Invoice___, Create_Collect_Ivc_Ord__
--  030102           and views  CUSTOMER_ORDER_COLLECT_INVOICE and COLLECT_CUSTOM_INVOICE.
--  030102  SaNalk   Performed code review.
--  021231  UsRalk   Merged with SP3 Changes.
--  021211  JeLise   Bug 34763, Changed to creator = 'CUSTOMER_ORDER_INV_ITEM_API' in view CUSTOMER_ORDER_INV_ITEM_JOIN.
--  021211  SaNalk   Changed the method used for fetching additional discount in PROCEDURE Create_Invoice_Item___.
--  021209  JaBalk   Bug 34663, Modified the cursors to select the order lines which has approved stage billing lines to create an invoice
--  021209           in Create_Collective_Invoice___,Create_Collect_Ivc_Ord__,Create_Invoice__.
--  021202  SaNalk   Changed PROCEDURE Create_Invoice_Item___ for Additional Discount.
--  021120  PrJalk   Changed the case of some words, according to the standard in Get_Max_Qty_To_Rtn_Str
--  021108  PrJalk   Changed the case of words according to the standards in Get_Max_Qty_To_Rtn_Str .
--  021104  PrJalk   Added Function Is_Rma_Lines_Exist_For_Order
--  021128  JeLise   Bug 34532, Moved view CUSTOMER_ORDER_INV_ITEM_JOIN here from CustomerOrderInvItem.
--  021105  PrTilk   Bug 33806, Changed the view CUSTOMER_ORDER_COLLECT_INVOICE by modifying third select statement in the where clause.
--  021101  JaBalk   Bug 33698, Put a cod.qty_to_invoice != cod.qty_invoiced condition to the cursor get_order_lines
--  021101           in Procedures:Create_Collective_Invoice___,Create_Invoice__,Create_Collect_Ivc_Ord__ to avoid the
--  021101           the order header getting state Invoice/closed when having a zero price CO line together with consignment parts.
--  021031  PrTilk   Bug 33806, Changed the third select in the where clause when selecting approved stage billing lines.
--  021029  PrJalk   Added procedure Chk_Prev_Credit_Invoices and function get_credited_amt_Per_Db_Ivc.
--  021029  PrJalk   Added function Get_Max_Qty_To_Rtn_Str.
--  020828  JoAnSe   Bug 31296, Removed parameter copy_amount_ in call to Copy_Discount in Create_Invoice_Item___
--  020827  NuFilk   Bug 26254, Modified Credit_Returned_Line___ and Credit_Returned_Charge___.
--  020823  ChFolk   Bug 29707, Added new IN parameter, rma_charge_no_ into PROCEDURE Get_Head_Data_From_Rma___. Change the parameter order and
--  020823           modified the of same procedure to Deleted the invoice Ref value in the credit invoice which is created from a charge line.
--  020809  ChFolk   Bug 31869, Modified PROCEDURE Create_Invoice_Lines___. Allowed to create customer invoices, when customer order only has charge lines.
--  020807  ARKRPL   Bug 31508, Modified cursor get_order_line to improve server performance by reducing scanning the table CUSTOMER_ORDER_DELIVERY_TAB
--  020730  GaSolk   Bug 31006, Changed the parameter  - 1 * net_curr_amount_ to  1 * net_curr_amount_
--  020730           in the calling method Create_Invoice_Tax_Item___ of the Proc: Credit_Returned_Charge___.
--  020715  WaJalk   Bug 30577, Modified Create_Collective_Invoice___ to select internal_po_no.
--  020709  WaJalk   Bug 30577, Modified Create_Invoice__ and Create_Collect_Ivc_Ord__ to select internal_po_no
--  020709           and customer_po_no for normal and collective invoices.
--  020626  WaJalk   Bug 30577, Modified Create_Invoice__ to get internal_po_no instead of customer_po_no.
--  020531  AjShlk   Bug 29095, Modified Get_Head_Data_From_Rma___ to show missing data.
--  020524  JOHESE   Bug 28728, Optimized cursor head_data in procedure Create_Collective_Invoice___
--  020508  Miguus   Bug fix 29132, Modified cursor get_order_lines in order to invoiced package component parts that have
--                   sales price of zero and to invoiced/closed customer order.
--  020327  MaGu     Bug fix 28758. Added call to Customer_Order_Delivery_API.Modify_Qty_Invoiced in method
--                   Create_Invoice__ to set the quantity invoiced for zero price customer order lines.
--                   Added fetch of deliv_no in cursor get_order_lines_.
--                   The same changes were made in methods Create_Collective_Invoice__ and Create_Collect_Ivc_Ord__.
--  200303  AjShLk   Call ID 74347 - enable the LOV property for LINE_ITEM_NO in INVOICE_CUSTOMER_RMA_LOV
--  020312  JoAn     ID 10115 Sales Tax. Tax percentage retrived from Cust_Order_Line_Tax_Lines
--                   when creating tax lines for order lines invoiced.
--                   Added new parameter tax_percentage_ to Create_Invoice_Tax_Item___
--  020308  NuFilk   Bug fix 26254,(Call 74376), Modified Credit_Returned_Line___ inserted statement CUSTOMER_ORDER_INV_HEAD_API.Create_Credit_Invoice_Hist ( line_rec_.order_no, invoice_id_ );
--  020307  GaJalk   Bug fix 27928, Modified the procedure Create_Invoice__ when total to be invoiced is 0.
--  020226  CaSt     Bug fix 27846, Removed changes made 020116 in bug 27308. Modified Create_Invoice_Line___.
--  020213  GaJalk   Bug fix 27064, Modified the procedure Create_Collect_Ivc_Ord__ to get the earliest delivery date of the customer orders.
--  020116  CaSt     Bug fix 27308, Removed changes made 011003 in bug 22917. Added update of qty_invoiced for
--                   component lines in procedure Create_Invoice_Line___.
--  011119  OsAllk   Bug Fix 25956, Moved the error message NOT_CREDITABLE from Credit_Returned_Line___
--                   to Create_Invoice_From_Return__ and modified CURSOR get_lines in Create_Invoice_From_Return__.
--  011026  MaGu     Bug fix 24889. Removed all corrections for bug fix 24889.
--  011026  RoAnse   Bug fix 20897, Modified corrections made earlier for this bug in Create_Collect_Ivc_Ord__.
--  011026  MaGu     Bug fix 24889. Modified methods Create_Invoice_Item___ and Create_Invoice_Lines___ so that the discount is
--                   withdrawn from the sales price when only invoicing package components.
--  011025  CaSt     Bug fix 25559, Modified cursor get_order_lines in procedures Create_Collective_Invoice___,
--                   Create_Invoice__ and Create_Collect_Ivc_Ord__.
--  011025  CaSt     Bug fix 20897, Added coding to avoid creating zero amount collective invoices in Create_Collect_Ivc_Ord__.
--  011025  GaJalk   Bug fix 25349, Modified the procedure Create_Invoice_Lines___.
--  011016  PuIllk   Bugfix 18710, Set Sales UOM  to fetch correctly when RMN line is Connected and Not Connected to a Customer Order in PROCEDURE Credit_Returned_Line___.
--  011003  CaSt     Bug fix 22917, Qty invoiced was not calculated correctly when only components in a package part
--                   are invoiced.
--  010912  DaZa     Bug fix 23782, Added a new parameter (rma_line_no) and a new cursor to Get_Head_Data_From_Rma___.
--  010828  DaZa     Bug Fix 23782, Added 2 more cursors to Get_Head_Data_From_Rma___.
--  010813  JakHse   Bug Fix 23636, Added order state machine trigger in Create_Invoice_Lines___
--  010806  OsAllk   Bug Fix 23160, Removed the sign reversal of the amounts passed to Create_Invoice_Tax_Item___
--                   in the procedure Credit_Returned_Line___ since amounts are already negative.
--  010625  IsWilk   Bug Fix 22145, removed the error message NOT_CREDITABLE in the PROCEDURE Credit_Returned_Charge___ and
--                   modified the cursor get_charges in the PROCEDURE Create_Invoice_From_Return__.
--  010516  IsAn     Bug fix 20897 , Added coding to not to create collective invoice for zero amount in Create_Collective_Invoice___.
--  000306  IsAn     Bug fix 18710 , Added coding to get sales_Unit_Meas from Customer Order Line in procedure Invoice_Returned_Lines__ .
--  010104  JoAn     CID 58721 Added call to Order_Line_Commission_API.Set_Order_Com_Lines_Changed
--                   in Credit_Returned_Line___
--  001116  FBen     Corrected view comment for pay_term_id in COLLECT_CUSTOM_INVOICE.
--  001110  FBen     Added view comments on CUSTOMER_ORDER_COLLECT_INVOICE and COLLECT_CUSTOM_INVOICE.
--  001108  FBen     Removed view COLLECT_DISTINCT_CUSTOM_NO.
--  000913  FBen     Added UNDEFINED.
--  000906  DaZa     Added checks for COLLECT='INVOICE' in views/methods &COL_VIEW, &COL_IVC_VIEW,
--                   Create_Collective_Invoice___, Create_Invoice_Lines___, Create_Invoice__.
--  000828  FBen     Created Create_Collect_Ivc_Ord__ to invoice selected collective customer orders.
--  000823  FBen     Added two new views - COLLECT_DISTINCT_CUSTOM_NO and COLLECT_CUSTOM_INVOICE in order
--                   to display all orders that are ready to be invoiced.
--  000509  BRO      Hooked call to SetOrderComLinesChanged in Create_Invoice___
--  000713  ThIs     Merged from Chameleon
--  ------------------------------- 12.1 ------------------------------------
--  000620  JoAn     Bug Id 15894 Added call to Customer_Order_Line_API.Check_State
--                   in Create_invoice_Line___
--  000522  JoEd     Added discount amount check to Copy_Discount call in
--                   Create_Invoice_Item___.
--  000515  JoAn     Bug Id 15978. Changed cursor line_data in Create_Invoice__,
--                   added ORDER BY clause and renamed the cursor get_order_lines.
--  000511  JoAn     Bug Id 15976. Added condition for qty_invoiced_ in last IF
--                   statement in Create_Invoice_Line___
--  000309  JoAn     Corrected fee_code retrieval in Credit_Returned_Line___ and
--                   Credit_Returned_Charge___
--  000306  JoAn     Corrected view comments for INVOICE_CUSTOMER_RMA_LOV
--  000302  JoEd     Changed fetch of VAT free VAT code in Create_Invoice_Item___ and
--                   Create_Invoice_Charge_Item___.
--  000228  PaLj     CID 33040. Changed call to Create_Invoice_Tax_Item___. Net amount should be used.
--                   Also moved creation of VAT taxlines to Customer_Order_Ivc_Item_API.Create_Invoice_Item.
--  000224  PaLj     CID 32887. Added call to Create_Invoice_Tax_Item___ in Create_Invoice_Item
--                   and Create_Invoice_Charge_Item when creating VAT invoice item.
--  000221  JoEd     Use ship address when fetching VAT free VAT code in
--                   Create_Invoice_Item___ instead of paying customer's address.
--  000219  JakH     Changed logic for RMA's charges' and lines' tax lines.
--  000218  PaLj     Changed Cursor head_data in Create_Collective_Invoice___.
--  000214  JoEd     Changed fetch of "VAT usage" from Company.
--                   Added error message NOTAXINFO.
--  000211  JoEd     Removed vat_ from all methods' parameter lists.
--                   Vat flag (or "pay any type of tax") is handled per order line.
--  000209  JoEd     Added calls to Create_Invoice_Tax_Item when creating invoice
--                   items and charged invoice items.
--  000209  PaLj     Changed Create_Invoice_Line___ to support staged billing
--                   when invoicing packages.
--  000209  JakH     Added Create_Invoice_Tax_Item
--                   Added calls to Create_Invoice_Tax_Item when crediting RMA's
--  000207  PaLj     Added Round(*,12) in cursor in Create_Invoice_Line___
--  000127  PaLj     Removed invoice_date from function call
--                   order_line_staged_billing_API.Set_Invoiced
--  000122  JakH     Made major changes in creation of invoices from returns.
--                   All done to enable crediting without order connections.
--  000122  JakH     Removed parameter pre_accounting_id in calls to Create_invoice_Head
--  000118  JoEd     Changed "Pay Tax" handling.
--  000117  PaLj     Changed COL_VIEW to adapt to Staged Billing
--  000113  PaLj     Changed Invoice_Id_ declaration to NUMBER where it was VARCHAR2
--  000113  PaLj     Changed call to order_line_staged_billing_API.Set_Invoiced
--  000112  JoEd     Removed Create_Extra_Discount_Item___.
--  000107  PaLj     Changed function Create_Invoice, Create_Invoice_Line and
--                   Create_Invoice_Item to handle Staged Billing
--  000104  JoEd     Removed party and party_type from call to
--                   Cust_Invoice_Item_Discount_API.Copy_Discount.
--  991228  JakH     Added Customer and Paying Customer in debit invoice rma lov.
--  991223  JakH     Added lov-view for finding invoices for crediting in RMA.
--  991207  JakH     Added functions for RMA crediting.
--  9911xx- JoEd     Added call to Copy_Discount in Create_Invoice_Item___.
--  991202           Added Create_Extra_Discount_Item___ and calls to it.
--  ------------------------------- 12.0 ------------------------------------
--  991111  JoEd     Changed datatype length on company_ variables.
--  991028  DaZa     Added checks on charges for view &COL_VIEW, so
--                    "charge only orders" can be invoiced.
--  991021  JoAn     CID 24743 Changed cursor for charges to invoice in Create_Invoice_Lines___
--  991019  JoAn     CID 24293 Changed the check for zero value invoices in Create_Invoice__
--                   Charges are now included in the calculation.
--  991012  DaZa     Removed exist check in cursor head_data in Create_Invoice__,
--                   since this check is already done in
--                   CUSTOMER_ORDER_FLOW_API.Create_Invoice_Allowed__.
--  991011  JakH     Removed methods for creating credit invoces from returns
--  991007  JoEd     Call Id 21210: Corrected double-byte problems.
--  990930  DaZa     Added charge_group to the invoice_charge_item.
--  990929  DaZa     Changes in Create_Invoice_Lines___ and Create_Invoice_Charge_Line___,
--                   fixed so charge connected to order_line now only will be
--                   invoiced when the order_line have been invoiced.
--  990925  DaZa     Changes in Create_Invoice_Charge_Item___ so sales_unit_meas
--                   and fee_code are taken from customer_order_charge instead of
--                   sales_charge_type.
--  990917  DaZa     Added new methods Create_Invoice_Charge_Line___ and Create_Invoice_Charge_Item___.
--                   Added a loop that fetches charges to be invoiced.
--  990826  JoAn     Corrected cursor get_invoice_total in Create_Invoice.
--  ------------------------------- 11.1 ------------------------------------
--  990607  PaLj     CID 19801 Added Rounding of invoice_total_ in Create_Invoice_
--  990528  JakH     CID 18828 Changed order of creation of invoice items for packages.
--                   Package header line has its state checked again after handling of its
--                   compoonents are updated. The calcultion for invoiced qty for components corrected.
--  990526  JakH     CID 17644 make it impossible to create credit invoices for internal orders.
--  990519  JoAn     CID 17064 vat_ passed to Create_Invoice_Item___ assumed to be db value.
--  990419  PaLj     removed funtions Order_Fully_Invoiced and Line_Fully_Invoiced
--  990414  PaLj     YOSHIMURA - New Template and Performance changes
--  990412  JoEd     Y.Call id 14004: Added contract in calls to Create_Invoice_Head.
--  990329  RaKu     Changed in Create_Invoice__. Qty_Invoiced was wrong calculated.
--  990211  JoAn     Redefined the CUSTOMER_ORDER_COLLECT_INVOICE view for better
--                   performance.
--                   Also removed the condition for customer category (CID 4547).
--                   Changed the condition used to check if a line is possible to
--                   invoice from qty_to_invoice > qty_invoiced to qty_to_invoice != qty_invoiced
--                   to allow invoicing of lines with qty < 0 (Service Management).
--  990202  CAST     Added conv_factor to qty_shipped in Create_Invoice__.
--  981209  JoEd     Changed fetch of vat free fee code.
--  981124  RaKu     Removed incorrect conv_factor from qty_invoiced in Create_Invoice_Line___.
--  981002  RaKu     Modifyed Create_Invoice_Line___.
--  980915  RaKu     Changed function Line_Fully_Invoiced__.
--  980417  JoAn     SID 3882 Moved check for pay terms before invoice head is
--                    created to ivchead.apy.
--  980415  JoAn     SID 1659 Corrected history message when collective invoice created
--  980409  JoAn     SID 1659 Clenup of history record creation.
--                   Invoice id added to all history records created.
--  980303  RaKu     Bug 2793 If an order line have price = 0 it should not appear
--                   on the invoice. Changes made in proc. Create_Invoice__ and
--                   Create_Invoice_Lines__.
--  980226  DaZa     Changed forward_agent to forward_agent_id.
--  980225  ToOs     Changed setting of no vat vat_code.
--  980224  ToOs     Corrected roundings
--  980220  MNYS     Changes in Create_Invoice_Lines___ due to Negative quantity.
--  980213  JoAn     Changed Make_Collective_Invoice__ method so that one deferred
--                   call will be made for each customer processed.
--                   Removed the error handling and Batch_Result creation when
--                   creating collective invoices. The standard error handling
--                   provided by Transaction_SYS should be sufficient.
--  980211  ToOs     Changed hardcoded rounds to get_currency_rounding
--  971125  RaKu     Changed to FND200 Templates.
--  971031  JoAn     Changed Invoice_Returned_Lines___ so that a negative qty is passed
--                   when creating invoice item.
--  971003  JoAn     Added condition objstate != 'Cancelled' in cursor get_package_lines
--                   in Create_Invoice_Line___
--  971001  JoAn     Added check for payterm_id = NULL in Create_Invoice__ and
--                   Make_Collective_Invoice___
--  970919  JoAn     Bug 97-0114 Corrected qty_invoiced for package components in
--                   Create_Invoice_Line___
--  970623  RaKu     Commented check for collective invoicing in Create_Invoice_From_Return__.
--  970613  JoAn     Added check for sales_unit_price > 0 to cursor in Invoice_Returned_Lines___.
--                   Also added error message when no lines to invoice are found.
--  970610  JoAn     Corrected bug in cursor in Create_Invoice_Line___
--  970606  RaKu     Added parameter company_ in all calls to Create_Invoice_Head.
--  970605  JoAn     Removed currency_code_ parameter in Create_Invoice_Line___
--  970526  JoAn     Removed extra quotes in error messages.
--  970523  JoAn     Added error handling in Unpack_Collective_Invoice__
--  970522  JOED     Added _db column in the view for the IID column.
--  970520  RaKu     Added view-comments on COL_VIEW.
--  970508  JoAn     Changes due to Finance8.1 integration
--                   Removed Count_Not_Invoiced_Orders
--  970424  JoAn     Replaced usage of status_code with state.
--  970418  JoAn     Replaced call to Customer_Order_Line_API.Modify_Qty_Invoiced with
--                   Customer_Order_API.Set_Line_Qty_Invoiced
--  970417  JOED     Removed objstate from Customer_Order_History_API.New and
--                   Customer_Order_Line_Hist_API.New.
--  970416  JOED     Changed call to Customer_Order_History_API and changed package
--                   name to &PKG where its called.
--                   Changed call to Customer_Order_Line_Hist_API.
--  970312  RaKu     Changed table-names in view-definition.
--  970225  RaKu     Added procedures Create_Invoice_From_Return__ and
--                   Invoice_Returned_Lines___.
--  970221  RaKu     Fixed bugs with some cursors. Was not completly declared.
--  961213  RaKu     Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

TYPE ivc_head_rec IS RECORD
  ( authorize_name                VARCHAR2(100),
    bill_addr_no                  CUSTOMER_ORDER_TAB.bill_addr_no%TYPE,
    company                       VARCHAR2(20),
    contract                      VARCHAR2(5),
    currency_code                 VARCHAR2(3),
    cust_ref                      VARCHAR2(100),
    customer_no                   CUSTOMER_ORDER_TAB.customer_no%TYPE,
    customer_no_pay               CUSTOMER_ORDER_TAB.customer_no_pay%TYPE,
    customer_no_pay_addr_no       CUSTOMER_ORDER_TAB.customer_no_pay_addr_no%TYPE,
    date_entered                  DATE,
    delivery_terms_desc           VARCHAR2(35),
    del_terms_location            VARCHAR2(100),
    forward_agent_id              CUSTOMER_ORDER_TAB.forward_agent_id%TYPE,
    invoice_type                  VARCHAR2(20),
    label_note                    VARCHAR2(50),
    number_reference              VARCHAR2(50),
    order_no                      VARCHAR2(12),
    pay_term_id                   VARCHAR2(20),
    series_reference              VARCHAR2(20),
    ship_addr_no                  CUSTOMER_ORDER_TAB.ship_addr_no%TYPE,
    ship_via_desc                 VARCHAR2(35),
    rma_no                        NUMBER,
    wanted_delivery_date          DATE,
    js_invoice_state_db           VARCHAR2(3),
    supply_country_db             VARCHAR2(2),
    -- gelr:invoice_reason, begin
    invoice_reason_id             CUSTOMER_ORDER_TAB.invoice_reason_id%TYPE);
    -- gelr:invoice_reason, end
TYPE Order_No_Array IS TABLE OF VARCHAR2(12) INDEX BY BINARY_INTEGER;
TYPE Invoice_Id_Tab IS TABLE OF NUMBER INDEX BY PLS_INTEGER;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Clear_Reb_Aggr_Tmp_Tabs___
--    reb_aggr_line_cntrl_type_tmp stores values for control types for grouping in next level. 
--    reb_aggr_line_posting_tmp stores grouped and summed total rebate cost and total rebate amount as per the posting control type setup.
--    This method clears values of above two tables as requested using the in parameters.

PROCEDURE Clear_Reb_Aggr_Tmp_Tabs___ (
   aggregation_no_     IN NUMBER,
   aggr_line_no_       IN NUMBER,
   tab_                IN NUMBER) 
IS
BEGIN
   IF (aggregation_no_ IS NOT NULL) THEN 
      IF (tab_ = 0) THEN
         DELETE 
            FROM reb_aggr_line_cntrl_type_tmp
            WHERE aggregation_no = aggregation_no_
            AND TO_CHAR(aggr_line_no) LIKE NVL(TO_CHAR(aggr_line_no_), '%');
         DELETE 
            FROM reb_aggr_line_posting_tmp
            WHERE aggregation_no = aggregation_no_
            AND TO_CHAR(aggr_line_no) LIKE NVL(TO_CHAR(aggr_line_no_), '%');
      ELSIF (tab_ = 1) THEN
         DELETE 
            FROM reb_aggr_line_cntrl_type_tmp
            WHERE aggregation_no = aggregation_no_
            AND TO_CHAR(aggr_line_no) LIKE NVL(TO_CHAR(aggr_line_no_), '%');
      ELSIF (tab_ = 2) THEN
         DELETE 
            FROM reb_aggr_line_posting_tmp
            WHERE aggregation_no = aggregation_no_
            AND TO_CHAR(aggr_line_no) LIKE NVL(TO_CHAR(aggr_line_no_), '%');
      END IF;
   END IF; 
END Clear_Reb_Aggr_Tmp_Tabs___;


PROCEDURE Add_Control_Type_Values___ (
   aggregation_no_                IN NUMBER, 
   aggr_line_no_                  IN NUMBER,
   is_final_                      IN VARCHAR2,
   booking_                       IN NUMBER, 
   company_                       IN VARCHAR2,
   invoice_id_                    IN NUMBER, 
   item_id_                       IN NUMBER,
   inv_item_vat_code_             IN VARCHAR2
   )       
IS
   TYPE rebate_transactions IS TABLE OF rebate_transaction_tab%ROWTYPE INDEX BY PLS_INTEGER;
   rebate_transactions_       rebate_transactions;
   total_rebate_cost_amount_  NUMBER;
   total_rebate_amount_       NUMBER;
   str_code_                  VARCHAR2(10);
   control_type_key_rec_      Mpccom_Accounting_API.Control_Type_Key;
   control_type_value_table_  Posting_Ctrl_Public_API.control_type_value_table;
   prime_commodity_           VARCHAR2(5) := NULL;
   second_commodity_          VARCHAR2(5) := NULL;
   accounting_group_          VARCHAR2(5) := NULL;
   part_product_family_       VARCHAR2(5) := NULL;
   part_product_code_         VARCHAR2(5) := NULL;
   cust_info_country_db_      VARCHAR2(2) := NULL;
   identity_inv_group_id_     VARCHAR2(20) := NULL;
   contract_                  VARCHAR2(5) := NULL;
   authorize_group_           VARCHAR2(1) := NULL;
   salesman_code_             VARCHAR2(20) := NULL;
   currency_code_             VARCHAR2(3) := NULL;
   order_id_                  VARCHAR2(3) := NULL;
   catalog_group_             VARCHAR2(10) := NULL;
   col_addr_country_code_     VARCHAR2(2) := NULL;
   region_code_               VARCHAR2(10) := NULL;
   district_code_             VARCHAR2(10) := NULL;
   cust_grp_                  VARCHAR2(10) := NULL;
   market_code_               VARCHAR2(10) := NULL;
   pay_term_id_               VARCHAR2(20) := NULL;
   sales_part_rebate_group_   VARCHAR2(10) := NULL; 
   rebate_type_               VARCHAR2(10) := NULL;
   
   CURSOR get_str_code IS
      SELECT DISTINCT(str_code) 
      FROM ACC_EVENT_POSTING_TYPE_PUB
      WHERE event_code = 'INVOICE-C'
      AND booking = booking_;
    
   CURSOR get_period_trans_ids IS
      SELECT *
      FROM rebate_transaction_tab 
      WHERE period_aggregation_no = aggregation_no_
      AND period_aggr_line_no = aggr_line_no_; 

   CURSOR get_final_trans_ids IS
      SELECT *
      FROM rebate_transaction_tab 
      WHERE final_aggregation_no = aggregation_no_
      AND final_aggr_line_no = aggr_line_no_;
      
   PROCEDURE Assign_Values___ ( 
      control_type_value_table_ IN Posting_Ctrl_Public_API.control_type_value_table
      )
   IS 
      j_  VARCHAR2(20);
   BEGIN
      contract_ := NULL; 
      prime_commodity_ := NULL; 
      second_commodity_ := NULL;
      cust_grp_  := NULL; 
      catalog_group_ := NULL; 
      order_id_ := NULL; 
      col_addr_country_code_ := NULL; 
      market_code_ := NULL; 
      region_code_ := NULL; 
      district_code_ := NULL; 
      pay_term_id_ := NULL; 
      currency_code_ := NULL; 
      salesman_code_ := NULL; 
      authorize_group_ := NULL; 
      accounting_group_ := NULL;
      part_product_family_ := NULL;
      part_product_code_ := NULL; 
      cust_info_country_db_ := NULL; 
      identity_inv_group_id_ := NULL; 
      sales_part_rebate_group_ := NULL; 
      rebate_type_ := NULL;
      
      j_ := control_type_value_table_.FIRST;
      WHILE j_ IS NOT NULL LOOP
         IF j_ = 'AC7' THEN
            --inv_item_vat_code_ := control_type_value_table_(j_); --AC7
            NULL;
         ELSIF j_ = 'C5' THEN 
            contract_ := control_type_value_table_(j_); -- C5
         ELSIF j_ = 'C7' THEN 
            prime_commodity_ := control_type_value_table_(j_); -- C7
         ELSIF j_ = 'C8' THEN 
            second_commodity_ := control_type_value_table_(j_); -- C8
         ELSIF j_ = 'C13' THEN         
            cust_grp_ := control_type_value_table_(j_); -- C13
         ELSIF j_ = 'C15' THEN         
            catalog_group_ := control_type_value_table_(j_); -- C15
         ELSIF j_ = 'C16' THEN         
            order_id_ := control_type_value_table_(j_); -- C16
         ELSIF j_ = 'C18' THEN         
            col_addr_country_code_ := control_type_value_table_(j_); --C18
         ELSIF j_ = 'C19' THEN         
            market_code_ := control_type_value_table_(j_); --C19
         ELSIF j_ = 'C20' THEN         
            region_code_ := control_type_value_table_(j_); --C20
         ELSIF j_ = 'C21' THEN         
            district_code_ := control_type_value_table_(j_); --C21
         ELSIF j_ = 'C22' THEN         
            pay_term_id_ := control_type_value_table_(j_); --C22
         ELSIF j_ = 'C26' THEN         
            currency_code_ := control_type_value_table_(j_); --C26
         ELSIF j_ = 'C27' THEN         
            salesman_code_ := control_type_value_table_(j_); --C27
         ELSIF j_ = 'C29' THEN         
            authorize_group_ := control_type_value_table_(j_); --C29
         ELSIF j_ = 'C32' THEN         
            accounting_group_ := control_type_value_table_(j_); -- C32
         ELSIF j_ = 'C49' THEN         
            part_product_family_ := control_type_value_table_(j_); -- C49
         ELSIF j_ = 'C50' THEN         
            part_product_code_ := control_type_value_table_(j_); --C50
         ELSIF j_ = 'C85' THEN         
            cust_info_country_db_ := control_type_value_table_(j_); --C85
         ELSIF j_ = 'C88' THEN         
            identity_inv_group_id_ := control_type_value_table_(j_); -- C88
         ELSIF j_ = 'C96' THEN         
            sales_part_rebate_group_ := control_type_value_table_(j_); -- C96
         ELSIF j_ = 'C97' THEN         
            rebate_type_ := control_type_value_table_(j_);
         END IF;        
         j_ := control_type_value_table_.NEXT(j_);
      END LOOP;
   END Assign_Values___;

BEGIN
   IF (is_final_ = 'TRUE') THEN
      OPEN get_final_trans_ids;
      IF get_final_trans_ids%NOTFOUND THEN
         CLOSE get_final_trans_ids;
      END IF;
      FETCH get_final_trans_ids BULK COLLECT INTO rebate_transactions_;
      CLOSE get_final_trans_ids;
   ELSE
      OPEN get_period_trans_ids;
      IF get_period_trans_ids%NOTFOUND THEN
         CLOSE get_period_trans_ids;
      END IF;
      FETCH get_period_trans_ids BULK COLLECT INTO rebate_transactions_;
      CLOSE get_period_trans_ids;
   END IF;
   
   IF (rebate_transactions_.COUNT > 0) THEN
      
      OPEN get_str_code;
      FETCH get_str_code INTO str_code_; -- posting type
      CLOSE get_str_code;
      
      FOR trans_rec_ IN 1..rebate_transactions_.COUNT LOOP
         
         IF (is_final_ = 'TRUE') THEN
            -- remaining_cost
            -- amount_to_invoice
            IF (rebate_transactions_(trans_rec_).period_aggregation_no IS NULL) THEN
               total_rebate_cost_amount_ := rebate_transactions_(trans_rec_).total_rebate_cost_amount;
               total_rebate_amount_ := rebate_transactions_(trans_rec_).final_rebate_amount;
            ELSE
               total_rebate_cost_amount_ := 0;
               total_rebate_amount_ := rebate_transactions_(trans_rec_).final_rebate_amount - rebate_transactions_(trans_rec_).total_rebate_amount;
            END IF;
         ELSE
            total_rebate_amount_ := rebate_transactions_(trans_rec_).total_rebate_amount;
            total_rebate_cost_amount_ := rebate_transactions_(trans_rec_).total_rebate_cost_amount;
         END IF;
         
         control_type_key_rec_.tax_code_ := inv_item_vat_code_;
         control_type_key_rec_.contract_ := NVL(rebate_transactions_(trans_rec_).contract, Customer_Order_API.Get_Contract(rebate_transactions_(trans_rec_).order_no));
         control_type_key_rec_.part_no_ := Sales_Part_API.Get_Part_No(control_type_key_rec_.contract_, rebate_transactions_(trans_rec_).part_no);
         control_type_key_rec_.company_:= company_;
         control_type_key_rec_.oe_order_no_ := rebate_transactions_(trans_rec_).order_no;
         control_type_key_rec_.oe_line_no_ := rebate_transactions_(trans_rec_).line_no;
         control_type_key_rec_.oe_rel_no_ := rebate_transactions_(trans_rec_).rel_no;
         control_type_key_rec_.oe_line_item_no_ := rebate_transactions_(trans_rec_).line_item_no;
         control_type_key_rec_.oe_invoice_id_ := invoice_id_;
         control_type_key_rec_.oe_invoice_item_id_ := item_id_;
         control_type_key_rec_.transaction_id_ := rebate_transactions_(trans_rec_).transaction_id;
         
         Mpccom_Accounting_API.Get_Control_Type_Values  (control_type_value_table_,
                                                         control_type_key_rec_,
                                                         company_, -- company_
                                                         str_code_, -- str_code_
                                                         SYSDATE); -- accounting_date_
                                                          
         Assign_Values___(control_type_value_table_);

         INSERT INTO reb_aggr_line_cntrl_type_tmp (aggregation_no, aggr_line_no, transaction_id, company, is_final, booking, 
                                                   total_rebate_amount, total_rebate_cost_amount, AC1, AC7, C5, C7, C8, C13, C15, C16, C18, C19,
                                                   C20, C21, C22, C26, C27, C29, C32, C49, C50, C85, C88, C96, C97 )
         VALUES (aggregation_no_, aggr_line_no_, rebate_transactions_(trans_rec_).transaction_id, company_, is_final_, booking_,
                 total_rebate_amount_, total_rebate_cost_amount_,
                 'AC1_FIXED_VALUE', -- AC1
                 inv_item_vat_code_, --AC7
                 contract_, -- C5
                 prime_commodity_, -- C7
                 second_commodity_, -- C8
                 cust_grp_, -- C13
                 catalog_group_, -- C15
                 order_id_, -- C16
                 col_addr_country_code_, --C18
                 market_code_, --C19
                 region_code_, --C20
                 district_code_, --C21
                 pay_term_id_, --C22
                 currency_code_, --C26
                 salesman_code_, --C27
                 authorize_group_, --C29
                 accounting_group_, -- C32
                 part_product_family_, -- C49
                 part_product_code_, --C50
                 cust_info_country_db_, --C85
                 identity_inv_group_id_, -- C88
                 sales_part_rebate_group_, -- C96
                 rebate_type_); --C97
                 
      END LOOP;
   END IF;
     
END Add_Control_Type_Values___;


-- Create_Collective_Invoice___
--   Create a collective invoice for one single customer.
PROCEDURE Create_Collective_Invoice___ (
   customer_no_               IN VARCHAR2,
   contract_                  IN VARCHAR2,
   currency_code_             IN VARCHAR2,
   pay_term_id_               IN VARCHAR2,
   bill_addr_no_              IN VARCHAR2,
   ignore_closing_date_       IN VARCHAR2,
   jinsui_invoice_db_         IN VARCHAR2,
   closest_closing_date_      IN DATE,
   currency_rate_type_        IN VARCHAR2,
   project_id_                IN VARCHAR2,
   tax_liability_country_db_  IN VARCHAR2,
   use_price_incl_tax_        IN VARCHAR2,
   ivc_unconct_chg_seperatly_ IN NUMBER DEFAULT 1)
IS
   invoice_id_               NUMBER;
   collective_               VARCHAR2(5) := 'TRUE';
   company_                  VARCHAR2(20);
   cust_po_no_               VARCHAR2(50);
   lines_invoiced_           BOOLEAN := FALSE;
   no_invoiced_lines         EXCEPTION;
   info_                     VARCHAR2(2000);
   order_state_              VARCHAR2(20);
   invoiced_lines_available_ BOOLEAN := FALSE; 
   cust_ref_                 VARCHAR2(100);
   tax_liability_country_rec_ Tax_Liability_Countries_API.Public_Rec; 
   use_reference_          BOOLEAN := TRUE;  -- should we fetch any customer reference to the customer invoice.
   use_ref_from_order_     BOOLEAN := FALSE; -- use the customer reference stored in the customer order.
   dummy_ NUMBER := 0;
   cust_ref_from_order_     BOOLEAN := FALSE;
   -- gelr:invoice_reason, begin
   invoice_reason_id_       Customer_Order_Tab.invoice_reason_id%TYPE;
   -- gelr:invoice_reason, end
   copy_from_tax_source_arr_    Tax_Handling_Util_API.source_key_arr := Tax_Handling_Util_API.source_key_arr();
   copy_to_tax_source_arr_      Tax_Handling_Util_API.source_key_arr := Tax_Handling_Util_API.source_key_arr();
   
   CURSOR head_data IS
      SELECT *
      FROM collective_invoice_line_tmp;   
   
   CURSOR check_invoice_cust_exist IS
      SELECT 1
      FROM collective_invoice_line_tmp
      WHERE customer_no_pay IS NULL;
   
   CURSOR check_use_ref_from_order IS
      SELECT COUNT(DISTINCT NVL(customer_no_pay_ref, Database_Sys.string_null_)) 
      FROM   collective_invoice_line_tmp;
   
   CURSOR check_cust_ref_from_order IS
      SELECT COUNT(DISTINCT NVL(cust_ref, Database_Sys.string_null_)) 
      FROM   collective_invoice_line_tmp;
      
   -- gelr:fr_service_code, begin
   CURSOR count_distinct_serv_codes IS
      SELECT COUNT(DISTINCT NVL(service_code, ' '))
      FROM   customer_order_tab
      WHERE  order_no IN (SELECT order_no FROM collective_invoice_line_tmp);

   service_code_              VARCHAR2(100);
   -- gelr:fr_service_code, end  
   
   invoice_component_         head_data%ROWTYPE;   
BEGIN
   company_ := Site_API.Get_Company(contract_);
   $IF (Component_Order_SYS.INSTALLED) $THEN
      New_Collect_Inv_Line_Temp___(customer_no_, contract_, currency_code_, currency_rate_type_, pay_term_id_, bill_addr_no_, project_id_, jinsui_invoice_db_, tax_liability_country_db_, use_price_incl_tax_, ivc_unconct_chg_seperatly_);
      
      OPEN  check_invoice_cust_exist;
      FETCH check_invoice_cust_exist INTO dummy_;
      IF (check_invoice_cust_exist%FOUND) THEN
         use_reference_ := FALSE;         
         dummy_ := 0;
         OPEN  check_cust_ref_from_order;
         FETCH check_cust_ref_from_order INTO dummy_;
         CLOSE check_cust_ref_from_order;

         IF (dummy_ = 1) THEN
            cust_ref_from_order_ := TRUE;   
         END IF;
      ELSE
         dummy_ := 0;
         OPEN  check_use_ref_from_order;
         FETCH check_use_ref_from_order INTO dummy_;
         CLOSE  check_use_ref_from_order;
      
         IF (dummy_ = 1) THEN
            use_ref_from_order_ := TRUE;   
         END IF;   
      END IF;
      CLOSE check_invoice_cust_exist;   
      OPEN head_data;
      FETCH head_data INTO invoice_component_;

       @ApproveTransactionStatement(2014-09-18,darklk)
      SAVEPOINT before_header_creation;

      IF (head_data%FOUND) THEN

         IF tax_liability_country_db_ IS NOT NULL THEN
            tax_liability_country_rec_ := Tax_Liability_Countries_API.Get_Valid_Tax_Info(company_, tax_liability_country_db_, Site_API.Get_Site_Date(contract_)); 
         END IF;
         IF (use_reference_) THEN   
            IF (NOT use_ref_from_order_) THEN
               cust_ref_ := Cust_Ord_Customer_API.Fetch_Cust_Ref(invoice_component_.customer_no_pay, invoice_component_.customer_no_pay_addr_no, 'TRUE');
            ELSE
               cust_ref_ := invoice_component_.customer_no_pay_ref;            
            END IF;
         ELSIF (cust_ref_from_order_) THEN 
            cust_ref_ := Customer_Order_API.Get_Cust_Ref(invoice_component_.order_no);    
         END IF; 
         -- gelr:invoice_reason, begin
         IF (Company_Localization_Info_API.Get_Parameter_Value_Db(company_, 'INVOICE_REASON') = Fnd_Boolean_API.DB_TRUE) THEN 
            invoice_reason_id_ := Identity_Invoice_Info_API.Get_Invoice_Reason_Id(company_, invoice_component_.customer_no, Party_Type_API.Decode(Party_Type_API.DB_CUSTOMER));
         END IF;
         -- gelr:invoice_reason, end
         -- gelr:fr_service_code, begin
         IF (Company_Localization_Info_API.Get_Parameter_Value_Db(company_, 'FR_SERVICE_CODE') = Fnd_Boolean_API.DB_TRUE) THEN
            OPEN count_distinct_serv_codes;
            FETCH count_distinct_serv_codes INTO dummy_;
            CLOSE count_distinct_serv_codes;
            
            IF (dummy_ > 1) THEN
               service_code_ := NULL;
            ELSE
               service_code_ := Customer_Order_API.Get_Service_Code(invoice_component_.order_no);
            END IF;
         END IF;
         -- gelr:fr_service_code, end
         
         Customer_Order_Inv_Head_API.Create_Invoice_Head(
            invoice_id_, --invoice_id_
            company_, --company_
            NULL, -- order_no_
            invoice_component_.customer_no, --customer_no_
            invoice_component_.customer_no_pay, --customer_no_pay_
            Order_Coordinator_API.Get_Name(invoice_component_.authorize_code), --authorize_name_
            invoice_component_.date_entered, --date_entered_
            cust_ref_, -- cust_ref_
            invoice_component_.ship_via_desc, --ship_via_desc_
            invoice_component_.forward_agent_id, --forward_agent_id_
            invoice_component_.label_note, --label_note_
            invoice_component_.delivery_terms_desc, --delivery_terms_desc_
            invoice_component_.del_terms_location, --del_terms_location_
            pay_term_id_, --pay_term_id_
            currency_code_, --currency_code_
            invoice_component_.ship_addr_no, --ship_addr_no_
            invoice_component_.customer_no_pay_addr_no, --customer_no_pay_addr_no_
            invoice_component_.bill_addr_no, --bill_addr_no_
            invoice_component_.wanted_delivery_date, --wanted_delivery_date_
            'CUSTCOLDEB', -- invoice_type_
            NULL, -- number_reference
            NULL, -- series_reference
            contract_, --contract_
            Get_Js_Invoice_State_Db___(jinsui_invoice_db_), --js_invoice_state_db_
            invoice_component_.currency_rate_type, --currency_rate_type_
            collective_, -- collect_
            NULL, -- rma_no_
            NULL, -- shipment_id_
            NULL, -- adv_invoice_
            NULL, -- adv_pay_base_date_       
            NULL, -- sb_reference_no_         
            'FALSE', -- use_ref_inv_curr_rate_   
            NULL, -- ledger_item_id_          
            NULL, -- ledger_item_series_id_   
            NULL, -- ledger_item_version_id_ 
            NULL, --aggregation_no_
            'FALSE', --final_settlement_
            project_id_, --project_id
            tax_liability_country_rec_.tax_id_number, -- tax_id_number
            tax_liability_country_rec_.tax_id_type, --tax_id_type
            tax_liability_country_rec_.branch, --branch
            tax_liability_country_db_, --supply_country_db_
            NULL, --invoice_date_
            invoice_component_.use_price_incl_tax, --use_price_incl_tax_db_            
            NULL, --wht_amount_base_
            NULL, --curr_rate_new_
            NULL, --tax_curr_rate_new_
            NULL, --correction_reason_id_
            NULL, --correction_reason_
            'FALSE', --is_simulated_
            invoice_reason_id_, --invoice_reason_id_
            service_code_ => service_code_); --service_code_
      ELSE
         RAISE no_invoiced_lines;
      END IF;

      WHILE head_data%FOUND LOOP
         IF (invoice_component_.internal_po_no IS NOT NULL ) THEN
            cust_po_no_ := invoice_component_.internal_po_no;
         ELSE
            cust_po_no_ := invoice_component_.customer_po_no;
         END IF;
         lines_invoiced_:= FALSE;    

         -- Note : set the Commission Recalc Flag to true: data have changed, commission should/may be recalculated.
         Order_Line_Commission_API.Set_Order_Com_Lines_Changed(invoice_component_.order_no);
         
         Create_Invoice_Lines___(
            copy_from_tax_source_arr_,
            copy_to_tax_source_arr_,
            lines_invoiced_,
            invoice_component_.order_no,
            invoice_id_,
            cust_po_no_,
            ignore_closing_date_,
            closest_closing_date_,
            NULL,
            tax_liability_country_db_,
            NULL,
            ivc_unconct_chg_seperatly_);

         IF((lines_invoiced_ = TRUE) AND (invoiced_lines_available_ = FALSE))THEN         
             invoiced_lines_available_ := TRUE;       
         END IF;
         
         IF (lines_invoiced_ ) THEN         
            Customer_Order_History_API.New(invoice_component_.order_no,
               Language_SYS.Translate_Constant(lu_name_, 'CRECOLLINVOICE: Collective invoice :P1 created', NULL, invoice_id_));       
         END IF;

         order_state_ := Customer_Order_API.Get_Objstate(invoice_component_.order_no);
         IF (order_state_ = 'Blocked') THEN
            Customer_Order_API.Start_Release_Blocked(invoice_component_.order_no, 'FALSE'); 
         END IF;

         $IF Component_Pcmsci_SYS.INSTALLED $THEN
             Psc_Inv_Line_Util_API.Update_Product_Invoice(invoice_component_.order_no, company_, invoice_id_);
         $END
         -- This FETCH moved to be the last call in the loop
         FETCH head_data INTO invoice_component_;
      END LOOP; -- Loop until all orders are invoiced
      
      IF (copy_from_tax_source_arr_.COUNT > 0 ) THEN 
            Transfer_Ext_Tax_Lines___ (copy_from_tax_source_arr_,
                                       copy_to_tax_source_arr_,
                                       company_,
                                       invoice_id_);
         END IF;
      CLOSE head_data;
   $END
   
   -- If no lines are invoiced, raise an expection so that we can rollback the creation of header.
   IF (invoiced_lines_available_ = FALSE) THEN
      RAISE no_invoiced_lines;
   END IF;

   IF (invoice_id_ IS NOT NULL) THEN
      Customer_Order_Inv_Head_API.Create_Invoice_Complete(company_, invoice_id_);
      Cust_Ord_Customer_API.Modify_Last_Ivc_Date(customer_no_);
   END IF;
   Clear_Collective_Line_Tmp___;
EXCEPTION
   WHEN no_invoiced_lines THEN
      Clear_Collective_Line_Tmp___;
      @ApproveTransactionStatement(2014-09-18,darklk)
      ROLLBACK TO before_header_creation;
      
      info_ := Language_SYS.Translate_Constant(lu_name_, 'NOINVOICE: There are no customer order lines available to create the collective customer invoice');
      Transaction_SYS.Set_Status_Info(info_);
 END Create_Collective_Invoice___;

PROCEDURE New_Collect_Inv_Line_Temp___ (
   customer_no_               IN VARCHAR2,
   contract_                  IN VARCHAR2,
   currency_code_             IN VARCHAR2,
   currency_rate_type_        IN VARCHAR2,
   pay_term_id_               IN VARCHAR2,
   bill_addr_no_              IN VARCHAR2,
   project_id_                IN VARCHAR2,
   jinsui_invoice_db_         IN VARCHAR2,
   tax_liability_country_db_  IN VARCHAR2,
   use_price_incl_tax_        IN VARCHAR2,
   ivc_unconct_chg_seperatly_ IN NUMBER DEFAULT 1)
IS
   $IF (Component_Order_SYS.INSTALLED) $THEN
      CURSOR head_data IS
         SELECT order_no, customer_no, authorize_code,
                date_entered, bill_addr_no, cust_ref, customer_no_pay, customer_no_pay_ref,
                customer_no_pay_addr_no, customer_po_no,
                delivery_terms_desc, del_terms_location, forward_agent_id,
                ship_via_desc, ship_addr_no, NVL(internal_po_label_note, label_note) label_note, note_id,
                wanted_delivery_date, internal_po_no, currency_rate_type, use_price_incl_tax
         FROM   customer_order_collect_inv coi
         WHERE  ((coi.customer_no_pay = customer_no_ AND coi.customer_no_pay_addr_no = bill_addr_no_ ) OR
                (coi.customer_no = customer_no_ AND NVL(coi.bill_addr_no, Database_SYS.string_null_) = NVL(bill_addr_no_, Database_SYS.string_null_) AND coi.customer_no_pay IS NULL))
         AND    coi.currency_code = currency_code_
         AND    coi.pay_term_id = pay_term_id_
         AND    coi.contract  = contract_
         AND    coi.jinsui_invoice = jinsui_invoice_db_
         AND    coi.tax_liability_country = tax_liability_country_db_
         AND    coi.use_price_incl_tax = use_price_incl_tax_
         AND    NVL(coi.currency_rate_type, Database_SYS.string_null_) = NVL(currency_rate_type_, Database_SYS.string_null_)
         AND    coi.order_no NOT IN (SELECT creators_reference
                                     FROM invoice_utility_inv_head_pub
                                     WHERE (adv_inv = 'TRUE'
                                     OR prepay_based_inv_db = 'TRUE')
                                     AND creators_reference IS NOT NULL
                                     AND creator = 'CUSTOMER_ORDER_INV_HEAD_API')
         AND   (ivc_unconct_chg_seperatly_ = 1
                     OR coi.rowstate IN ('PartiallyDelivered', 'Delivered')
                     OR coi.order_no IN (SELECT col.order_no
                                          FROM ORDER_LINE_STAGED_BILLING_TAB osb, CUSTOMER_ORDER_LINE_TAB col
                                          WHERE col.rowstate          NOT IN ('Cancelled', 'Invoiced')
                                          AND   col.provisional_price = 'FALSE'
                                          AND   osb.order_no          = col.order_no
                                          AND   osb.line_no           = col.line_no
                                          AND   osb.rel_no            = col.rel_no
                                          AND   osb.line_item_no      = col.line_item_no
                                          AND   osb.rowstate          = 'Approved')
                     OR coi.order_no IN (SELECT cod.order_no 
                                          FROM customer_order_delivery_tab cod
                                          WHERE cod.date_confirmed IS NOT NULL
                                          AND   cod.incorrect_del_confirmation = 'FALSE' 
                                          AND  cod.order_no = coi.order_no )
                     OR coi.order_no NOT IN (SELECT col.order_no
                                             FROM customer_order_line_tab col
                                             WHERE col.order_no = coi.order_no))
         AND    NVL(coi.project_id, Database_SYS.string_null_) = NVL(project_id_, Database_SYS.string_null_)
         ORDER BY coi.date_entered, coi.order_no;
      
      TYPE Buffered_Collect_Inv_Tab IS TABLE OF head_data%ROWTYPE
      INDEX BY PLS_INTEGER;
      buffered_collect_inv_list_ Buffered_Collect_Inv_Tab;
      max_rows_            PLS_INTEGER := 10000;
   $END   
BEGIN
   $IF (Component_Order_SYS.INSTALLED) $THEN
      OPEN head_data;
      LOOP
         FETCH head_data BULK COLLECT INTO buffered_collect_inv_list_ LIMIT max_rows_;
         EXIT WHEN buffered_collect_inv_list_.COUNT = 0;
         IF (buffered_collect_inv_list_.COUNT > 0) THEN
            FOR i IN buffered_collect_inv_list_.first .. buffered_collect_inv_list_.last LOOP
               INSERT  INTO COLLECTIVE_INVOICE_LINE_TMP (order_no,
                                                         customer_no,
                                                         authorize_code,
                                                         date_entered,
                                                         bill_addr_no,
                                                         cust_ref,
                                                         customer_no_pay,
                                                         customer_no_pay_ref,
                                                         customer_no_pay_addr_no,
                                                         customer_po_no,
                                                         delivery_terms_desc,
                                                         del_terms_location,
                                                         forward_agent_id,
                                                         ship_via_desc,
                                                         ship_addr_no,
                                                         label_note,
                                                         note_id,
                                                         wanted_delivery_date,
                                                         internal_po_no,
                                                         currency_rate_type,
                                                         use_price_incl_tax)

               VALUES (buffered_collect_inv_list_(i).order_no,
                       buffered_collect_inv_list_(i).customer_no,
                       buffered_collect_inv_list_(i).authorize_code,
                       buffered_collect_inv_list_(i).date_entered,
                       buffered_collect_inv_list_(i).bill_addr_no,
                       buffered_collect_inv_list_(i).cust_ref,
                       buffered_collect_inv_list_(i).customer_no_pay,
                       buffered_collect_inv_list_(i).customer_no_pay_ref,
                       buffered_collect_inv_list_(i).customer_no_pay_addr_no,
                       buffered_collect_inv_list_(i).customer_po_no,
                       buffered_collect_inv_list_(i).delivery_terms_desc,
                       buffered_collect_inv_list_(i).del_terms_location,
                       buffered_collect_inv_list_(i).forward_agent_id,
                       buffered_collect_inv_list_(i).ship_via_desc,
                       buffered_collect_inv_list_(i).ship_addr_no,
                       buffered_collect_inv_list_(i).label_note,
                       buffered_collect_inv_list_(i).note_id,
                       buffered_collect_inv_list_(i).wanted_delivery_date,
                       buffered_collect_inv_list_(i).internal_po_no,
                       buffered_collect_inv_list_(i).currency_rate_type,
                       buffered_collect_inv_list_(i).use_price_incl_tax);                     
            END LOOP;              
         END IF;        
      END LOOP;   
      CLOSE head_data;
   $ELSE
      NULL;
   $END   
END  New_Collect_Inv_Line_Temp___;  

PROCEDURE Clear_Collective_Line_Tmp___
IS
BEGIN
   DELETE FROM collective_invoice_line_tmp;
END Clear_Collective_Line_Tmp___;
   

-- Create_Invoice_Line___
--   Create invoice_line in INVOICE module and update depending order_line.
PROCEDURE Create_Invoice_Line___ (
   item_id_                      OUT NUMBER,
   qty_invoiced_              IN OUT NUMBER,
   order_no_                  IN     VARCHAR2,
   line_no_                   IN     VARCHAR2,
   rel_no_                    IN     VARCHAR2,
   line_item_no_              IN     NUMBER,
   invoice_id_                IN     NUMBER,
   customer_po_no_            IN     VARCHAR2,
   ignore_closing_date_       IN     VARCHAR2,
   closest_closing_date_      IN     DATE,
   shipment_id_               IN     NUMBER,
   rental_transaction_id_     IN     NUMBER,
   taransfer_ext_tax_at_line_ IN     BOOLEAN DEFAULT TRUE)
IS
   line_rec_               Customer_Order_Line_API.Public_Rec;   
   qty_to_invoice_         NUMBER := 0;
   qty_shipped_            NUMBER;
   pkgs_already_delivered_ NUMBER;
   price_conv_factor_      NUMBER;
   catch_qty_shipped_      NUMBER;
   invoice_type_           CUSTOMER_ORDER_INV_HEAD.invoice_type%TYPE;

   CURSOR get_staged_qty_to_invoice IS
      SELECT Round((col.buy_qty_due*osb.total_percentage/100), 12) staged_qty_to_invoice, osb.stage
      FROM customer_order_line_tab col, order_line_staged_billing_tab osb
      WHERE osb.order_no     = order_no_
      AND   osb.line_no      = line_no_
      AND   osb.rel_no       = rel_no_
      AND   osb.line_item_no = line_item_no_
      AND   col.order_no     = osb.order_no
      AND   col.line_no      = osb.line_no
      AND   col.rel_no       = osb.rel_no
      AND   col.line_item_no = osb.line_item_no
      AND   osb.rowstate     = 'Approved'
      AND   (ignore_closing_date_ = 'TRUE' OR TRUNC(osb.approval_date) <= TRUNC(closest_closing_date_));

   CURSOR get_package_lines IS
      SELECT line_item_no, revised_qty_due, conv_factor, qty_invoiced, qty_per_assembly, new_comp_after_delivery, inverted_conv_factor
      FROM   customer_order_line_tab
      WHERE  order_no = order_no_
      AND    line_no = line_no_
      AND    rel_no = rel_no_
      AND    line_item_no > 0
      AND    rowstate NOT IN ('Cancelled', 'Invoiced');
      
   -- gelr:del_note_mandatory, begin
      delnote_nos_   VARCHAR2(2000);
   
      CURSOR get_delnote_created IS
         SELECT cod.delnote_no
         FROM customer_order_delivery_tab cod, delivery_note_tab codn, cust_delivery_inv_ref_tab cdi
         WHERE  cod.delnote_no     = codn.delnote_no
         AND    cdi.invoice_id     = invoice_id_
         AND    cod.order_no       = order_no_
         AND    cod.line_no        = line_no_
         AND    cod.rel_no         = rel_no_
         AND    cod.line_item_no   = line_item_no_
         AND    codn.rowstate     != 'Printed'
         AND    cancelled_delivery = 'FALSE';
      -- gelr:del_note_mandatory, end
      
BEGIN
   line_rec_ := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);
   -- Note : Restructure the code written here and moved into Consume_Deliveries___
   IF (line_rec_.staged_billing = 'NOT STAGED BILLING') THEN
      IF (line_rec_.rental = Fnd_Boolean_API.DB_FALSE) THEN 
         Consume_Deliveries___ (qty_to_invoice_, order_no_, line_no_, rel_no_, line_item_no_, invoice_id_,
                                ignore_closing_date_, closest_closing_date_, shipment_id_);
         IF (qty_to_invoice_ != 0) THEN
            invoice_type_ := Customer_Order_Inv_Head_API.Get_Invoice_Type(Site_API.Get_Company(line_rec_.contract), invoice_id_);
            IF (invoice_type_ = 'CUSTCOLDEB') AND (shipment_id_ IS NOT NULL) AND (Part_Catalog_API.Get_Catch_Unit_Enabled_Db(line_rec_.part_no)= 'TRUE') THEN
               catch_qty_shipped_ := Deliver_Customer_Order_API.Get_Catch_Qty_Shipped(order_no_, line_no_, rel_no_, line_item_no_, shipment_id_);
               IF (catch_qty_shipped_ != 0) THEN
                  price_conv_factor_ := catch_qty_shipped_ / qty_to_invoice_;
               END IF;
            END IF;

            -- Note : Create an invoice line if there is anything to invoice.
            Create_Invoice_Item__(
               item_id_           => item_id_,
               invoice_id_        => invoice_id_,
               order_no_          => order_no_,
               line_no_           => line_no_,
               rel_no_            => rel_no_,
               line_item_no_      => line_item_no_,
               qty_invoiced_      => qty_to_invoice_,
               customer_po_no_    => customer_po_no_,
               stage_             => NULL,
               price_conv_factor_ => price_conv_factor_,
               taransfer_ext_tax_ => taransfer_ext_tax_at_line_);

            -- here the qty_invoiced_ is actually the qty_invoiced_ per invoice line.
            qty_invoiced_  := qty_to_invoice_;
            -- Note:- No need to Consume Deliveries for order lines with 'STAGED BILLING'.
            Connect_Delivs_To_Ivc_Item___(order_no_, line_no_, rel_no_, line_item_no_, invoice_id_, item_id_ );
           
            -- gelr:del_note_mandatory, begin
            IF (Company_Localization_Info_API.Get_Parameter_Val_From_Site_Db(line_rec_.contract, 'DEL_NOTE_MANDATORY') = Fnd_Boolean_API.DB_TRUE) THEN
               FOR rec_ IN get_delnote_created LOOP
                  IF delnote_nos_ IS NULL THEN
                     delnote_nos_ := rec_.delnote_no;
                  ELSE
                     delnote_nos_ := delnote_nos_ || ', ' || rec_.delnote_no;
                  END IF;
               END LOOP;
               IF (delnote_nos_ IS NOT NULL) THEN
                  Error_SYS.Record_General(lu_name_, 'DEL_NOTE_NOT_PRINTED: Cannot create invoice without printing the delivery note/s :P1 when Delivery Note Print-out Mandatory to Create Customer Invoice localization functionality is enabled.', delnote_nos_);
               END IF;
            END IF;
            -- gelr:del_note_mandatory, end
            
         END IF;
      ELSE
         $IF Component_Rental_SYS.INSTALLED $THEN 
            qty_to_invoice_ := Rental_Transaction_API.Get_Transaction_Qty(rental_transaction_id_);

            IF (qty_to_invoice_ != 0) THEN
               Create_Invoice_Item__(
                  item_id_               => item_id_,
                  invoice_id_            => invoice_id_,
                  order_no_              => order_no_,
                  line_no_               => line_no_,
                  rel_no_                => rel_no_,
                  line_item_no_          => line_item_no_,
                  qty_invoiced_          => qty_to_invoice_,
                  customer_po_no_        => customer_po_no_,
                  stage_                 => NULL,
                  rental_transaction_id_ => rental_transaction_id_,
                  taransfer_ext_tax_     => taransfer_ext_tax_at_line_);

               qty_invoiced_ := Rental_Transaction_API.Get_Qty_Invoiced(rental_transaction_id_);
            END IF;
         $ELSE
            Error_SYS.Component_Not_Exist('RENTAL');
         $END             
      END IF;
   ELSE
      qty_to_invoice_ := 0;
      --lines_invoiced_ := TRUE;
      FOR staged_rec_ IN get_staged_qty_to_invoice LOOP
         qty_to_invoice_ := qty_to_invoice_ + staged_rec_.staged_qty_to_invoice;
         Create_Invoice_Item__(
            item_id_,
            invoice_id_,
            order_no_,
            line_no_,
            rel_no_,
            line_item_no_,
            staged_rec_.staged_qty_to_invoice,
            customer_po_no_,
            staged_rec_.stage,
            taransfer_ext_tax_ => taransfer_ext_tax_at_line_);
         -- What if using staged billing and having part of packages delivered.
      END LOOP;
      -- here the qty_invoiced_ is actually the qty_invoiced_ per invoice line.
      qty_invoiced_ := qty_to_invoice_;
   END IF;

   IF (line_item_no_ = -1) AND (qty_to_invoice_ != 0 ) THEN
      -- Note : When invoicing a package, update qty_invoiced in Customer_Order_Delivery for components also.
      FOR itemrec_ IN get_package_lines LOOP
         -- If the component line is added after a partial delivery, that component part contains only on those packages delivered afterwards.
         IF itemrec_.new_comp_after_delivery = 'TRUE' THEN
            qty_shipped_ := line_rec_.qty_shipped + line_rec_.qty_confirmeddiff;
            -- Packages already delivered when adding the new component line.
            pkgs_already_delivered_ := (line_rec_.revised_qty_due / line_rec_.conv_factor * line_rec_.inverted_conv_factor)  - (itemrec_.revised_qty_due / itemrec_.conv_factor* itemrec_.inverted_conv_factor / itemrec_.qty_per_assembly);
            qty_to_invoice_ := qty_shipped_  - pkgs_already_delivered_; 
         END IF;     
         Customer_Order_API.Set_Line_Qty_Invoiced(order_no_, line_no_, rel_no_, itemrec_.line_item_no, itemrec_.qty_invoiced  + qty_to_invoice_ * itemrec_.qty_per_assembly);
      END LOOP;
      -- Note : try to advance package line head if possible
      Customer_Order_Line_API.Check_State(order_no_, line_no_, rel_no_, -1);
   END IF;

   -- Note : If components have been invoiced separately the package status may have to be updated.
   IF ((line_item_no_ > 0) AND (qty_to_invoice_!= 0)) THEN
      -- Note : Package component line was invoiced, check if state of package header should be changed.
      Customer_Order_Line_API.Check_State(order_no_, line_no_, rel_no_, -1);
   END IF;
END Create_Invoice_Line___;


-- Create_Invoice_Charge_Line___
--   Create invoice_charge_line in INVOICE module and update depending order_charge_line.
PROCEDURE Create_Invoice_Charge_Line___ (
   item_id_                    OUT NUMBER,
   order_no_                   IN VARCHAR2,
   line_no_                    IN VARCHAR2,
   rel_no_                     IN VARCHAR2,
   line_item_no_               IN NUMBER,
   invoice_id_                 IN NUMBER,
   customer_po_no_             IN VARCHAR2,
   charge_seq_no_              IN NUMBER,
   charged_qty_                IN NUMBER,
   planned_revenue_simulation_ IN BOOLEAN DEFAULT FALSE,
   lines_invoiced_             IN BOOLEAN DEFAULT FALSE,
   taransfer_ext_tax_at_line_  IN BOOLEAN DEFAULT TRUE)
IS
BEGIN
   Create_Invoice_Charge_Item___(
      item_id_,
      invoice_id_,
      order_no_,
      line_no_,
      rel_no_,
      line_item_no_,
      charged_qty_,
      customer_po_no_,
      charge_seq_no_,
      planned_revenue_simulation_,
      taransfer_ext_tax_at_line_);
   -- Note : We invoice the whole charged qty
   Customer_Order_Charge_API.Modify_Invoiced_Qty(order_no_, charge_seq_no_, charged_qty_, lines_invoiced_);
END Create_Invoice_Charge_Line___;


-- Create_Invoice_Charge_Item___
--   Create invoice_charge_line in INVOICE module and update depending order_line.
PROCEDURE Create_Invoice_Charge_Item___ (
   item_id_                    IN OUT NUMBER,
   invoice_id_                 IN     NUMBER,
   order_no_                   IN     VARCHAR2,
   line_no_                    IN     VARCHAR2,
   rel_no_                     IN     VARCHAR2,
   line_item_no_               IN     NUMBER,
   qty_invoiced_               IN     NUMBER,
   customer_po_no_             IN     VARCHAR2,
   charge_seq_no_              IN     NUMBER,
   planned_revenue_simulation_ IN     BOOLEAN,
   taransfer_ext_tax_          IN     BOOLEAN DEFAULT TRUE)
IS
   co_rec_                 Customer_Order_API.Public_Rec;
   co_charge_rec_          Customer_Order_Charge_API.Public_Rec;
   charge_rec_             Sales_Charge_Type_API.Public_Rec;
   line_rec_               Customer_Order_Line_API.Public_Rec;
   charge_percent_basis_   NUMBER;
   total_tax_percentage_   NUMBER;   
   ship_addr_no_           VARCHAR2(50);
   charged_desc_           VARCHAR2(35);
   tax_liability_type_     VARCHAR2(20);

BEGIN
   co_charge_rec_ := Customer_Order_Charge_API.Get(order_no_, charge_seq_no_);
   charge_rec_    := Sales_Charge_Type_API.Get(co_charge_rec_.contract, co_charge_rec_.charge_type);
   co_rec_        := Customer_Order_API.Get(order_no_);
   charged_desc_  := Customer_Order_Charge_API.Get_Charge_Type_Desc(co_charge_rec_.contract,order_no_,co_charge_rec_.charge_type);

   -- Note : if charge is connected to an order header, fetch value from there
   IF (co_charge_rec_.line_no IS NULL) THEN
      ship_addr_no_ := co_rec_.ship_addr_no ; 
   -- Note : otherwise fetch from the order line
   ELSE
      line_rec_     := Customer_Order_Line_API.Get(order_no_, co_charge_rec_.line_no, co_charge_rec_.rel_no, co_charge_rec_.line_item_no);
      ship_addr_no_ := line_rec_.ship_addr_no ;
   END IF;
   tax_liability_type_ := Customer_Order_Charge_Api.Get_Conn_Tax_Liability_Type_Db(order_no_, charge_seq_no_);

   IF (co_charge_rec_.charge_amount IS NULL) THEN
   -- When co_charge_rec_.charge_amount is null it should be calculated from charge percentage
      charge_percent_basis_ := Customer_Order_Charge_API.Get_Charge_Percent_Basis(order_no_, charge_seq_no_);
   END IF;
      
   total_tax_percentage_:= Source_Tax_Item_API.Get_Total_Tax_Percentage(co_charge_rec_.company, Tax_Source_API.DB_CUSTOMER_ORDER_CHARGE, 
                                              order_no_, TO_CHAR(charge_seq_no_), '*', '*', '*' );
                                              
   Customer_Order_Inv_Item_API.Create_Invoice_Item(
      item_id_, invoice_id_, co_charge_rec_.company ,order_no_, line_no_, rel_no_, line_item_no_,
      co_charge_rec_.contract,
      co_charge_rec_.charge_type,      -- charge_type
      charged_desc_,                   -- charge_type_description
      co_charge_rec_.sales_unit_meas,
      1,                               -- price_conv_factor
      co_charge_rec_.charge_amount,    -- sale_unit_price
      co_charge_rec_.charge_amount_incl_tax, -- sale_unit_price_incl_tax
      0,                               -- discount
      0,                               -- order_discount
      co_charge_rec_.tax_code,
      total_tax_percentage_,
      qty_invoiced_,
      customer_po_no_,
      co_charge_rec_.delivery_type,    -- delivery_type
      qty_invoiced_,
      charge_seq_no_,
      charge_rec_.charge_group,
      NULL,                            -- stage_
      'TRUE',                          -- prel_update_allowed_
      charge_percent_ => co_charge_rec_.charge, 
      charge_percent_basis_ => charge_percent_basis_,
      delivery_address_id_ => ship_addr_no_);

   IF (taransfer_ext_tax_) then
      Tax_Handling_Order_Util_API.Transfer_Tax_lines(co_charge_rec_.company, 
                                                     Tax_Source_API.DB_CUSTOMER_ORDER_CHARGE,
                                                     order_no_, 
                                                     TO_CHAR(charge_seq_no_), 
                                                     '*', 
                                                     '*',
                                                     '*',
                                                     Tax_Source_API.DB_INVOICE,
                                                     invoice_id_,
                                                     item_id_,
                                                     '*',
                                                     '*',
                                                     '*',
                                                     'TRUE',
                                                     'TRUE');
      IF (NOT planned_revenue_simulation_) THEN
         -- If CO Line is project connected, then refresh project revenue for CO Invoice Line
         IF (co_charge_rec_.line_no IS NOT NULL) AND NVL(line_rec_.activity_seq, 0) > 0 THEN
            Customer_Order_Inv_item_API.Calculate_Prel_Revenue__ (co_charge_rec_.company, invoice_id_, item_id_, line_rec_.activity_seq);
         END IF;
      END IF;
   END IF;

   
END Create_Invoice_Charge_Item___;


-- Create_Invoice_Lines___
--   Create invoice lines the specified order.
PROCEDURE Create_Invoice_Lines___ (
   copy_from_tax_source_arr_  IN OUT Tax_Handling_Util_API.source_key_arr,
   copy_to_tax_source_arr_    IN OUT Tax_Handling_Util_API.source_key_arr,
   lines_invoiced_            IN OUT BOOLEAN,
   order_no_                  IN VARCHAR2,
   invoice_id_                IN NUMBER,
   customer_po_no_            IN VARCHAR2,
   ignore_closing_date_       IN VARCHAR2,
   closest_closing_date_      IN DATE,
   shipment_id_               IN NUMBER DEFAULT NULL,
   tax_liability_country_db_  IN VARCHAR2 DEFAULT NULL,
   currency_code_             IN VARCHAR2 DEFAULT NULL,
   ivc_unconct_chg_seperatly_ IN NUMBER DEFAULT 1)
IS
   charges_invoiced_             BOOLEAN := FALSE;
   is_inv_item_available_        NUMBER;
   invoiced_qty_per_line_        NUMBER;
   conn_invoice_lines_exist_     NUMBER;
   charged_qty_temp_             NUMBER;
   include_in_invoice_           BOOLEAN := FALSE;
   company_                      VARCHAR2(20);
   supply_country_db_            VARCHAR2(2);
   line_deliv_country_db_        VARCHAR2(2);
   site_date_                    DATE;
   inv_items_exist_              NUMBER := 1;
   external_tax_cal_method_      VARCHAR2(50); 
   taransfer_ext_tax_at_line_    BOOLEAN := TRUE;
   item_id_                      NUMBER;
   i_                            NUMBER := copy_from_tax_source_arr_.COUNT + 1;

   CURSOR get_line_to_invoice IS
      SELECT line_no, rel_no, line_item_no, tax_liability
      FROM customer_order_line_tab
      WHERE order_no = order_no_
      AND  (((qty_invoiced < buy_qty_due) AND (buy_qty_due > 0)
             OR ((qty_invoiced > buy_qty_due) AND (buy_qty_due < 0))
             OR ((qty_invoiced) < ( SELECT SUM (cod.qty_to_invoice)
                                    FROM  CUSTOMER_ORDER_DELIVERY_TAB cod, CUSTOMER_ORDER_TAB co
                                    WHERE cod.order_no     = order_no_
                                    AND   cod.order_no     = co.order_no
                                    AND  (ignore_closing_date_ = 'TRUE' OR TRUNC(cod.date_delivered) <= TRUNC(closest_closing_date_))
                                    AND   ((co.confirm_deliveries = 'FALSE') OR
                                          (co.confirm_deliveries = 'TRUE' AND
                                          cod.date_confirmed IS NOT NULL AND
                                          cod.incorrect_del_confirmation = 'FALSE'))
                                    AND   cod.cancelled_delivery = 'FALSE')))
            AND ((EXISTS (SELECT 1
                          FROM   customer_order_delivery_tab cod
                          WHERE  cod.order_no = order_no_
                          AND    ((ignore_closing_date_ = 'TRUE') OR (TRUNC(cod.date_delivered) <= TRUNC(closest_closing_date_))))
                 ) OR staged_billing = Staged_Billing_Type_API.DB_STAGED_BILLING))                                       
      AND   rowstate NOT IN ('Invoiced', 'Cancelled')
      AND   self_billing          = Self_Billing_Type_API.DB_NOT_SELF_BILLING
      AND   blocked_for_invoicing = Fnd_Boolean_API.DB_FALSE
      AND   provisional_price     = Fnd_Boolean_API.DB_FALSE
      AND   rental                = Fnd_Boolean_API.DB_FALSE      
      ORDER BY TO_NUMBER(line_no), TO_NUMBER(rel_no), line_item_no;

   CURSOR get_charge_to_invoice IS
      SELECT coc.contract, coc.sequence_no, coc.line_no, coc.rel_no, coc.line_item_no,
             coc.charge_type, coc.charged_qty, coc.unit_charge, coc.charge_price_list_no,
             coc.campaign_id, coc.deal_id
      FROM customer_order_charge_tab coc
      WHERE ABS(coc.invoiced_qty) < ABS(coc.charged_qty)
      AND   coc.line_no IS NULL     -- not connected to an order_line
      AND   coc.collect = 'INVOICE' -- only invoice charges, no collect charges
      AND   coc.order_no = order_no_
   UNION
      SELECT coc.contract, coc.sequence_no, coc.line_no, coc.rel_no, coc.line_item_no,
             coc.charge_type, coc.charged_qty, coc.unit_charge, coc.charge_price_list_no,
             coc.campaign_id, coc.deal_id
      FROM customer_order_charge_tab coc,
           customer_order_inv_item coii
      WHERE coii.invoice_id = invoice_id_
      AND   ABS(coc.invoiced_qty) < ABS(coc.charged_qty)
      AND   coc.collect = 'INVOICE'             -- only invoice charges, no collect charges
      AND   coc.line_item_no = coii.line_item_no
      AND   coc.rel_no  = coii.release_no
      AND   coc.line_no = coii.line_no
      AND   coc.order_no = coii.order_no
      AND   coc.order_no = order_no_;

  CURSOR get_charge_to_invoice2 IS
      SELECT distinct coc.contract, coc.sequence_no, coc.line_no, coc.rel_no,
             coc.line_item_no,coc.charge_type, coc.charged_qty, coc.unit_charge
      FROM customer_order_charge_tab coc, order_line_staged_billing_tab osb
      WHERE coc.order_no                            = order_no_
      AND   coc.order_no                            = osb.order_no
      AND   coc.collect                             = 'INVOICE'
      AND   ABS(coc.invoiced_qty)                   < ABS(coc.charged_qty)
      AND   NVL(coc.line_no, osb.line_no)           = osb.line_no
      AND   NVL(coc.rel_no,osb.rel_no)              = osb.rel_no
      AND   NVL(coc.line_item_no,osb.line_item_no)  = osb.line_item_no;

  CURSOR  is_inv_items_available IS
      SELECT 1
      FROM customer_order_inv_item
      WHERE order_no = order_no_;

   CURSOR get_ship_line_to_invoice IS
      SELECT col.line_no, col.rel_no, col.line_item_no
      FROM customer_order_line_tab col, shipment_line_pub sol
      WHERE sol.source_ref1 = order_no_
      AND   sol.shipment_id = shipment_id_   -- Added just to make the statement use the shipment_line_pk
      AND   col.order_no = sol.source_ref1
      AND   col.line_no = sol.source_ref2
      AND   col.rel_no = sol.source_ref3
      AND   col.line_item_no = sol.source_ref4
      AND   sol.source_ref_type_db = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER
      AND   col.self_billing = Self_Billing_Type_API.DB_NOT_SELF_BILLING
      AND   col.blocked_for_invoicing = Fnd_Boolean_API.DB_FALSE
      AND   col.provisional_price = Fnd_Boolean_API.DB_FALSE
      AND   (((col.qty_invoiced < col.buy_qty_due) AND (col.buy_qty_due > 0))
           OR ((col.qty_invoiced > col.buy_qty_due) AND (col.buy_qty_due < 0)))
      AND   col.rowstate NOT IN ('Invoiced', 'Cancelled')
      AND   rental = Fnd_Boolean_API.DB_FALSE
      AND   (currency_code_ IS NULL OR EXISTS (SELECT 1
                                               FROM customer_order_tab co
                                               WHERE co.order_no = order_no_
                                               AND   co.currency_code = currency_code_))
      ORDER BY TO_NUMBER(col.line_no), TO_NUMBER(col.rel_no), col.line_item_no;

   CURSOR  get_qty_invoiced(line_no_ IN VARCHAR2, release_no_ IN VARCHAR2, line_item_no_ IN NUMBER ) IS
      SELECT invoiced_qty
      FROM customer_order_inv_item
      WHERE order_no      = order_no_
      AND   line_no       = line_no_
      AND   release_no    = release_no_
      AND   line_item_no  = line_item_no_
      AND   Invoice_id    = invoice_id_
      AND   charge_seq_no IS NULL;
    
   -- This cursor will check for the connected order lines for a sales promotion charge are at least partially invoiced in this invoice.  
   CURSOR check_lines_invoiced(campaign_id_ IN NUMBER, deal_id_ IN NUMBER, charge_seq_no_ IN NUMBER) IS    
      SELECT 1
      FROM  customer_order_line_tab col, 
            promo_deal_get_order_line_tab pdgol,
            customer_order_inv_item coii
      WHERE coii.invoice_id   = invoice_id_
      AND   col.rel_no        = coii.release_no
      AND   col.line_no       = coii.line_no
      AND   col.order_no      = coii.order_no
      AND   col.order_no      = pdgol.order_no
      AND   col.line_no       = pdgol.line_no
      AND   col.rel_no        = pdgol.rel_no
      AND   pdgol.charge_sequence_no = charge_seq_no_
      AND   pdgol.campaign_id = campaign_id_
      AND   pdgol.deal_id     = deal_id_; 

   $IF Component_Rental_SYS.INSTALLED $THEN
      CURSOR get_rental_line_to_invoice IS
         SELECT col.line_no, col.rel_no, col.line_item_no, rt.transaction_id
         FROM   rental_transaction_pub rt, customer_order_line_tab col
         WHERE  rt.order_ref1 = col.order_no
         AND    rt.order_ref2 = col.line_no
         AND    rt.order_ref3 = col.rel_no
         AND    rt.order_ref4 = col.line_item_no
         AND    rt.rental_type_db = Rental_Type_API.DB_CUSTOMER_ORDER
         AND    col.order_no  = order_no_
         AND    TRUNC(rt.planned_invoice_date) <= TRUNC(site_date_)
         AND    col.rowstate NOT IN ('Released', 'Invoiced', 'Cancelled')
         AND    col.self_billing = Self_Billing_Type_API.DB_NOT_SELF_BILLING
         AND    col.blocked_for_invoicing = Fnd_Boolean_API.DB_FALSE
         AND    col.provisional_price = Fnd_Boolean_API.DB_FALSE
         AND    col.rental = Fnd_Boolean_API.DB_TRUE
         AND    rt.invoiceable_db = Fnd_Boolean_API.DB_TRUE
         AND    rt.invoice_status_db = Rental_Trans_Invoic_Status_API.DB_NOT_INVOICED
         ORDER BY TO_NUMBER(line_no), TO_NUMBER(rel_no), line_item_no;
   $END
BEGIN
   company_           := Site_API.Get_Company(Customer_Order_API.Get_Contract(order_no_));
   supply_country_db_ := Customer_Order_API.Get_Supply_Country_Db(order_no_);
   site_date_         := Site_API.Get_Site_Date(Customer_Order_API.Get_Contract(order_no_));
   external_tax_cal_method_ := Company_Tax_Control_API.Get_External_Tax_Cal_Method_Db(company_);

   -- gelr:br_external_tax_integration, Modified condition to include Avalara Brazil
   IF (external_tax_cal_method_ IN (External_Tax_Calc_Method_API.DB_AVALARA_SALES_TAX, External_Tax_Calc_Method_API.DB_AVALARA_TAX_BRAZIL)) THEN
      taransfer_ext_tax_at_line_ := FALSE;
   END IF;   
   
   IF (shipment_id_ IS NULL) THEN
      -- Create normal invoice line
      FOR line_rec_ IN get_line_to_invoice LOOP
         line_deliv_country_db_ := Cust_Order_Line_Address_API.Get_Country_Code(order_no_, line_rec_.line_no, line_rec_.rel_no, line_rec_.line_item_no);
         include_in_invoice_    := Check_Invoicable_Line___(company_, tax_liability_country_db_, supply_country_db_, line_deliv_country_db_, line_rec_.tax_liability, site_date_);
         item_id_ := NULL;
         
         IF include_in_invoice_ THEN
            Create_Invoice_Line___(
               item_id_,
               invoiced_qty_per_line_,
               order_no_,
               line_rec_.line_no,
               line_rec_.rel_no,
               line_rec_.line_item_no,
               invoice_id_,
               customer_po_no_,
               ignore_closing_date_,
               closest_closing_date_,
               shipment_id_,
               NULL,
               taransfer_ext_tax_at_line_ => taransfer_ext_tax_at_line_);

            IF invoiced_qty_per_line_ != 0  THEN
               IF (NOT taransfer_ext_tax_at_line_ AND item_id_ IS NOT NULL) THEN 
                  Create_Tax_Source_Keys___(copy_from_tax_source_arr_(i_),
                                            copy_to_tax_source_arr_(i_),
                                            Tax_Source_API.DB_CUSTOMER_ORDER_LINE,
                                            order_no_,
                                            line_rec_.line_no,
                                            line_rec_.rel_no,
                                            line_rec_.line_item_no,
                                            '*',
                                            Tax_Source_API.DB_INVOICE,
                                            invoice_id_,
                                            item_id_,
                                            '*',
                                            '*',
                                            '*');  
                  i_ := i_ + 1;
               END IF;
               
               lines_invoiced_ := TRUE;
            END IF;
         END IF;
      END LOOP;
   ELSE
      item_id_ := NULL;
      -- Create Shipment invoice line
      FOR line_rec_ IN get_ship_line_to_invoice LOOP
         Create_Invoice_Line___(
            item_id_,
            invoiced_qty_per_line_,
            order_no_,
            line_rec_.line_no,
            line_rec_.rel_no,
            line_rec_.line_item_no,
            invoice_id_,
            customer_po_no_,
            ignore_closing_date_,
            closest_closing_date_,
            shipment_id_,
            NULL,
            taransfer_ext_tax_at_line_ => taransfer_ext_tax_at_line_);

         IF invoiced_qty_per_line_ != 0  THEN
            lines_invoiced_ := TRUE;
            
            IF (NOT taransfer_ext_tax_at_line_ AND item_id_ IS NOT NULL) THEN 
                  Create_Tax_Source_Keys___(copy_from_tax_source_arr_(i_),
                                            copy_to_tax_source_arr_(i_),
                                            Tax_Source_API.DB_CUSTOMER_ORDER_LINE,
                                            order_no_,
                                            line_rec_.line_no,
                                            line_rec_.rel_no,
                                            line_rec_.line_item_no,
                                            '*',
                                            Tax_Source_API.DB_INVOICE,
                                            invoice_id_,
                                            item_id_,
                                            '*',
                                            '*',
                                            '*');  
               i_ := i_ + 1;
            END IF;
         END IF; 
      END LOOP;
   END IF;
   $IF Component_Rental_SYS.INSTALLED $THEN
      FOR rental_rec_ IN get_rental_line_to_invoice LOOP
         item_id_ := NULL;
         Create_Invoice_Line___(  
               item_id_,
               invoiced_qty_per_line_,
               order_no_,
               rental_rec_.line_no,
               rental_rec_.rel_no,
               rental_rec_.line_item_no,
               invoice_id_,
               customer_po_no_,
               ignore_closing_date_,
               closest_closing_date_,
               shipment_id_,
               rental_rec_.transaction_id,
               taransfer_ext_tax_at_line_ => taransfer_ext_tax_at_line_);

         IF invoiced_qty_per_line_ != 0  THEN
            lines_invoiced_ := TRUE;
            
            IF (NOT taransfer_ext_tax_at_line_ AND item_id_ IS NOT NULL) THEN 
                  Create_Tax_Source_Keys___(copy_from_tax_source_arr_(i_),
                                            copy_to_tax_source_arr_(i_),
                                            Tax_Source_API.DB_CUSTOMER_ORDER_LINE,
                                            order_no_,
                                            rental_rec_.line_no,
                                            rental_rec_.rel_no,
                                            rental_rec_.line_item_no,
                                            '*',
                                            Tax_Source_API.DB_INVOICE,
                                            invoice_id_,
                                            item_id_,
                                            '*',
                                            '*',
                                            '*');  
               i_ := i_ + 1;
            END IF;
         END IF; 
      END LOOP;
   $END

   IF((ivc_unconct_chg_seperatly_ = 1) OR(ivc_unconct_chg_seperatly_ = 0 AND lines_invoiced_ = TRUE))THEN
      FOR charge_rec_ IN get_charge_to_invoice LOOP
         line_deliv_country_db_ := Customer_Order_Charge_API.Get_Connected_Deliv_Country(order_no_, charge_rec_.sequence_no);
         include_in_invoice_    := Check_Invoicable_Line___(company_, tax_liability_country_db_, supply_country_db_, line_deliv_country_db_, Customer_Order_Charge_API.Get_Connected_Tax_Liability(order_no_, charge_rec_.sequence_no), site_date_);

         IF include_in_invoice_ THEN
            IF charge_rec_.unit_charge = 'TRUE' THEN
               -- Set charged qty for unit charge lines.
               OPEN get_qty_invoiced(charge_rec_.line_no, charge_rec_.rel_no, charge_rec_.line_item_no);
               FETCH get_qty_invoiced INTO invoiced_qty_per_line_;
               CLOSE get_qty_invoiced;

               -- Set charged qty at invoice charge lines which has created by pack size charges.
               IF (charge_rec_.charge_price_list_no IS NOT NULL AND
                  (Sales_Charge_Type_API.Get_Sales_Chg_Type_Category_Db(charge_rec_.contract,charge_rec_.charge_type) = 'PACK_SIZE')) THEN
                  charged_qty_temp_       := charge_rec_.charged_qty;
                  charge_rec_.charged_qty := invoiced_qty_per_line_ / (Customer_Order_Line_API.Get_Input_Conv_Factor(order_no_, charge_rec_.line_no, charge_rec_.rel_no, charge_rec_.line_item_no));
                  IF charge_rec_.charged_qty IS NULL THEN
                     charge_rec_.charged_qty := charged_qty_temp_;
                  END IF;
               ELSIF (Sales_Charge_Type_API.Get_Sales_Chg_Type_Category_Db(charge_rec_.contract,charge_rec_.charge_type) = 'FREIGHT') THEN
                  charge_rec_.charged_qty := charge_rec_.charged_qty * (invoiced_qty_per_line_ / Customer_order_line_API.Get_Buy_Qty_Due(order_no_, charge_rec_.line_no, charge_rec_.rel_no, charge_rec_.line_item_no) );            
               ELSE
                  charge_rec_.charged_qty := invoiced_qty_per_line_;
               END IF;
            END IF;

            -- If campaign id of the customer order charge line has value, that is a Sales Promotion Charge
            IF (charge_rec_.campaign_id IS NOT NULL) THEN
               -- For sales promotion charges to be invoiced, we need to check at least one of the connected 
               -- CO lines are also included in this invoice.
               OPEN check_lines_invoiced(charge_rec_.campaign_id, charge_rec_.deal_id, charge_rec_.sequence_no);
               FETCH check_lines_invoiced INTO conn_invoice_lines_exist_;
               IF (check_lines_invoiced%NOTFOUND) THEN
                  conn_invoice_lines_exist_ := 0;
               END IF;
               CLOSE check_lines_invoiced ; 
            END IF;  

            IF (charge_rec_.campaign_id IS NULL) OR (conn_invoice_lines_exist_ = 1) THEN
               Create_Invoice_Charge_Line___(
                       item_id_        => item_id_,
                       order_no_       => order_no_,
                       line_no_        => charge_rec_.line_no,
                       rel_no_         => charge_rec_.rel_no,
                       line_item_no_   => charge_rec_.line_item_no,
                       invoice_id_     => invoice_id_,
                       customer_po_no_ => customer_po_no_,
                       charge_seq_no_  => charge_rec_.sequence_no,
                       charged_qty_    => charge_rec_.charged_qty,
                       lines_invoiced_ => lines_invoiced_,
                       taransfer_ext_tax_at_line_ => taransfer_ext_tax_at_line_);
               charges_invoiced_ := TRUE;
                 
               IF (NOT taransfer_ext_tax_at_line_ AND item_id_ IS NOT NULL) THEN 
                  Create_Tax_Source_Keys___(copy_from_tax_source_arr_(i_),
                                            copy_to_tax_source_arr_(i_),
                                            Tax_Source_API.DB_CUSTOMER_ORDER_CHARGE,
                                            order_no_, 
                                            TO_CHAR(charge_rec_.sequence_no), 
                                            '*', 
                                            '*',
                                            '*',
                                            Tax_Source_API.DB_INVOICE,
                                            invoice_id_,
                                            item_id_,
                                            '*',
                                            '*',
                                            '*');
                  i_ := i_ + 1;
                END IF;
            END IF; 
         END IF;
      END LOOP;
   END IF;

   OPEN is_inv_items_available;
   FETCH is_inv_items_available INTO is_inv_item_available_;
   IF (is_inv_items_available%NOTFOUND) THEN
      inv_items_exist_ := 0;
   END IF;
   CLOSE is_inv_items_available;
   
   IF (inv_items_exist_ = 0) THEN
      FOR charge_rec2_ IN get_charge_to_invoice2 LOOP 
         line_deliv_country_db_ := Customer_Order_Charge_API.Get_Connected_Deliv_Country(order_no_, charge_rec2_.sequence_no);
         include_in_invoice_    := Check_Invoicable_Line___(company_, tax_liability_country_db_, supply_country_db_, line_deliv_country_db_, Customer_Order_Charge_API.Get_Connected_Tax_Liability(order_no_, charge_rec2_.sequence_no), site_date_);
         
         IF include_in_invoice_ THEN
            Create_Invoice_Charge_Line___(
               item_id_        => item_id_,
               order_no_       => order_no_,
               line_no_        => charge_rec2_.line_no,
               rel_no_         => charge_rec2_.rel_no,
               line_item_no_   => charge_rec2_.line_item_no,
               invoice_id_     => invoice_id_,
               customer_po_no_ => customer_po_no_,
               charge_seq_no_  => charge_rec2_.sequence_no,
               charged_qty_    => charge_rec2_.charged_qty,
               lines_invoiced_ => lines_invoiced_,
               taransfer_ext_tax_at_line_ => taransfer_ext_tax_at_line_);
            charges_invoiced_ := TRUE;
            
            IF (NOT taransfer_ext_tax_at_line_ AND item_id_ IS NOT NULL) THEN 
               Create_Tax_Source_Keys___(copy_from_tax_source_arr_(i_),
                                         copy_to_tax_source_arr_(i_),
                                         Tax_Source_API.DB_CUSTOMER_ORDER_CHARGE,
                                         order_no_, 
                                         TO_CHAR(charge_rec2_.sequence_no), 
                                         '*', 
                                         '*',
                                         '*',
                                         Tax_Source_API.DB_INVOICE,
                                         invoice_id_,
                                         item_id_,
                                         '*',
                                         '*',
                                         '*');
               i_ := i_ + 1;
             END IF;
         END IF;
      END LOOP;
   END IF;
   IF charges_invoiced_ AND NOT lines_invoiced_ THEN
      lines_invoiced_ := TRUE;
   END IF;
   
END Create_Invoice_Lines___;


-- Get_Head_Data_From_Rma___
--   Checks the RMA head for approval and adds information to the invoice
--   head record.
PROCEDURE Get_Head_Data_From_Rma___ (
   ivc_rec_       IN OUT ivc_head_rec,
   rma_no_        IN     NUMBER,
   rma_line_no_   IN     NUMBER,
   rma_charge_no_ IN     NUMBER )
IS
   debit_invoice_no_     VARCHAR2(50) := NULL;
   debit_series_id_      VARCHAR2(20) := NULL;
   lines_                NUMBER := 0;
   customer_rec_         Cust_Ord_Customer_API.Public_Rec;
   company_              VARCHAR2(20);
   customer_to_credit_   return_material_tab.customer_no%TYPE;
   customer_addr_no_     return_material_tab.customer_no_addr_no%TYPE;
   order_no_             return_material_line_tab.order_no%TYPE;
   first_line_invno_     return_material_line_tab.debit_invoice_no%TYPE;
   first_line_invseries_ return_material_line_tab.debit_invoice_series_id%TYPE;

   debit_invoice_id_     NUMBER;
   rma_line_rec_         Return_Material_Line_API.Public_Rec;
   rma_charge_rec_       Return_Material_Charge_API.Public_Rec;
   debit_inv_rec_        Customer_Order_Inv_Head_API.Public_Rec;
   charge_seq_no_        NUMBER; 
   distinct_order_no_    return_material_line_tab.order_no%TYPE;
   ship_addr_no_         VARCHAR2(50);

   CURSOR rma_info(rma_no_ NUMBER) IS
      SELECT customer_no, customer_no_addr_no,
             customer_no_credit, customer_no_credit_addr_no, ship_addr_no,
             currency_code, date_requested, cust_ref, contract,
             return_approver_id, jinsui_invoice, supply_country, rowstate, originating_rma_no
        FROM return_material_tab
       WHERE rma_no = rma_no_;
   
   CURSOR get_distinct_deb_inv IS
      SELECT DISTINCT debit_invoice_no, debit_invoice_series_id
      FROM return_material_line_tab
      WHERE rma_no = rma_no_
      AND credit_invoice_no IS NULL
      AND debit_invoice_no IS NOT NULL
      AND credit_approver_id IS NOT NULL
      AND rowstate != 'Denied';

   CURSOR rma_line IS
      SELECT debit_invoice_no, debit_invoice_series_id, order_no
        FROM return_material_line_tab
       WHERE rma_no = rma_no_
         AND rma_line_no = rma_line_no_;
  
   CURSOR get_charge_debit_invoice  IS   
      SELECT invoice_id
      FROM   CUSTOMER_ORDER_INV_ITEM
      WHERE  company       = company_
      AND    order_no      = order_no_
      AND    charge_seq_no = charge_seq_no_;
	  
	CURSOR get_distinct_order(rma_no_ NUMBER) IS
      SELECT DISTINCT order_no
      FROM return_material_line_tab 
      WHERE rma_no = rma_no_ 
	  AND credit_invoice_no IS NULL 
	  AND rowstate NOT IN('Planned', 'Denied'); 
   
   rma_info_           rma_info%ROWTYPE;
BEGIN
   OPEN rma_info(rma_no_);
   FETCH rma_info INTO rma_info_;
   IF (rma_info%NOTFOUND) THEN
      CLOSE rma_info;
      Error_SYS.Record_General(lu_name_, 'NO_RMA_HEAD_DATA: Could not find RMA data when creating credit invoice.');
   END IF;
   CLOSE rma_info;

   IF (rma_info_.return_approver_id IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'NOTAPPROVED: RMA approver not set.');
   END IF;

   IF (rma_info_.rowstate IN ('Denied', 'Planned')) THEN
      Error_SYS.Record_General(lu_name_, 'NOTRELEASED: RMA must at least be released to be credit invoiced.');
   END IF;

   IF (rma_info_.customer_no_credit IS NULL) THEN
      customer_to_credit_ := rma_info_.customer_no;
      customer_addr_no_   := rma_info_.customer_no_addr_no;
      ivc_rec_.cust_ref   := rma_info_.cust_ref;
   ELSE
      customer_to_credit_ := rma_info_.customer_no_credit;
      customer_addr_no_   := rma_info_.customer_no_credit_addr_no;
      ivc_rec_.cust_ref   := Cust_Ord_Customer_API.Fetch_Cust_Ref(customer_to_credit_, customer_addr_no_, 'TRUE');
   END IF;

   customer_rec_     := Cust_Ord_Customer_API.Get(customer_to_credit_);
   company_          := Site_API.Get_Company(rma_info_.contract);   
   
   IF (rma_line_no_ IS NULL AND rma_charge_no_ IS NULL) THEN
      -- Note : this a credit invoice for a whole rma
      lines_ := Return_Material_API.Check_Debit_Inv_Numbers(rma_no_);

      IF (lines_ = 1) THEN
         -- This mean no connectionless lines exist for both RMA lines and RMA charge lines.
         -- Case 1 : All rma lines connected to a one debit invoice and no charge lines.
         -- Case 2 : All rma lines and charge lines are connected to a one debit invoice
         OPEN  get_distinct_deb_inv;
         FETCH get_distinct_deb_inv INTO debit_invoice_no_, debit_series_id_;
         CLOSE get_distinct_deb_inv;
      ELSE
         -- If no invoice connection or more than 1 invoice connection to this rma, do not show invoice ref
         debit_invoice_no_ := NULL;
         debit_series_id_  := NULL;
      END IF;
      
      -- Note : always get the first line debit invoice no/ order no if the credit invoice is created from header
      rma_line_rec_         := Return_Material_Line_API.Get( rma_no_, 1 );
      first_line_invno_     := rma_line_rec_.debit_invoice_no;
      first_line_invseries_ := rma_line_rec_.debit_invoice_series_id;
      order_no_             := rma_line_rec_.order_no;

      Create_Credit_Invoice_Rec___(ivc_rec_, 
                                   rma_no_,
                                   order_no_,
                                   first_line_invno_, 
                                   first_line_invseries_ );
								   
      FOR rec_ IN get_distinct_order(rma_no_) LOOP
	     IF get_distinct_order%ROWCOUNT = 1 THEN 
		    distinct_order_no_ := rec_.order_no;            
		 ELSE
            distinct_order_no_ := NULL;            
            EXIT;  
         END IF;   
      END LOOP;                        

      order_no_ := distinct_order_no_;

   -- Note : Added Condition 'rma_line_no_ IS NOT NULL'.
   ELSIF (rma_line_no_ IS NOT NULL OR rma_charge_no_ IS NOT NULL) THEN
      -- Note : this is a single row credit invoice from a single rma row
      IF (rma_line_no_ IS NOT NULL) THEN
         OPEN  rma_line;
         FETCH rma_line INTO debit_invoice_no_, debit_series_id_, order_no_;
         CLOSE rma_line;
      ELSE 
         debit_invoice_no_ := NULL;
         rma_charge_rec_   := Return_Material_Charge_API.Get( rma_no_, rma_charge_no_ );
         order_no_         := rma_charge_rec_.order_no;
         IF (order_no_ IS NOT NULL) AND (rma_charge_rec_.credit_invoice_no IS NULL) THEN         
            charge_seq_no_ := rma_charge_rec_.sequence_no;
            OPEN  get_charge_debit_invoice;
            FETCH get_charge_debit_invoice INTO debit_invoice_id_;
            CLOSE get_charge_debit_invoice;

            debit_inv_rec_    := Customer_Order_Inv_Head_API.Get(company_, debit_invoice_id_);
            debit_invoice_no_ := debit_inv_rec_.invoice_no;
            debit_series_id_  := debit_inv_rec_.series_id;
         END IF;
      END IF;
      first_line_invno_     := debit_invoice_no_;
      first_line_invseries_ := debit_series_id_;
      Create_Credit_Invoice_Rec___(ivc_rec_, 
                                   rma_no_,
                                   order_no_,
                                   first_line_invno_, 
                                   first_line_invseries_ );
   END IF;

   IF (rma_info_.originating_rma_no IS NOT NULL) THEN
      -- in supply site rma, the delivery address is from external customer which is different from rma customer.
      -- but just for invoicing, the delivery address is fetched from rma customers default delivery address. which is same as invoicing of internal customer order.
      ship_addr_no_ := Cust_Ord_Customer_API.Get_Delivery_Address(rma_info_.customer_no);
   ELSE
      ship_addr_no_ := rma_info_.ship_addr_no;
   END IF;

   ivc_rec_.rma_no                  := rma_no_;
   ivc_rec_.company                 := company_;
   ivc_rec_.customer_no             := rma_info_.customer_no;
   ivc_rec_.bill_addr_no            := rma_info_.customer_no_addr_no;
   ivc_rec_.customer_no_pay         := customer_to_credit_ ;
   ivc_rec_.customer_no_pay_addr_no := customer_addr_no_;
   ivc_rec_.authorize_name          := Order_Coordinator_API.Get_Name(rma_info_.return_approver_id);
   ivc_rec_.contract                := rma_info_.contract;
   ivc_rec_.currency_code           := rma_info_.currency_code;
   ivc_rec_.date_entered            := rma_info_.date_requested;
   ivc_rec_.order_no                := order_no_;
   IF(order_no_ IS NOT NULL)THEN
      ivc_rec_.pay_term_id          := Customer_Order_Api.Get_Pay_Term_Id(order_no_);
   ELSE
      ivc_rec_.pay_term_id          := Identity_Invoice_Info_API.Get_Pay_Term_Id(company_, customer_to_credit_, Party_Type_API.Decode('CUSTOMER'));
   END IF;
   ivc_rec_.ship_addr_no            := ship_addr_no_;
   ivc_rec_.wanted_delivery_date    := NULL;
   ivc_rec_.series_reference        := debit_series_id_;
   ivc_rec_.number_reference        := debit_invoice_no_;
   ivc_rec_.js_invoice_state_db     := Get_Js_Invoice_State_Db___(rma_info_.jinsui_invoice);
   ivc_rec_.supply_country_db       := rma_info_.supply_country;

   IF ((customer_rec_.category = 'E') OR -- external customer
      ((customer_rec_.category = 'I') AND -- internal customer and connected to a site associated with another company.
      (Site_API.Get_Company(customer_rec_.acquisition_site) != company_))) THEN
      -- Note : it's ok to generate credit invoice
      NULL;
   ELSE
      -- Note : it's a pure internal order; it's not ok to generate a credit invoice.
      Error_SYS.Record_General(lu_name_, 'INT_CUST_NO_CRED: Creating credit invoices for internal customers not possible.');
   END IF;
END Get_Head_Data_From_Rma___;


-- Credit_Returned_Line___
--   Create credit invoice line for the specified RMA line.
PROCEDURE Credit_Returned_Line___ (
   rma_no_                 IN NUMBER,
   rma_line_no_            IN NUMBER,
   invoice_id_             IN NUMBER,
   rma_rec_                IN Return_Material_API.Public_Rec,
   use_ref_inv_curr_rate_  IN NUMBER)
IS
   -- Note : takes qty_to_return from all states but denied and planned
   -- Note : (this is to allow  credit invoicing in early states)
   -- Note : this creates an invoice item for a specific rma line.
   CURSOR get_line_to_invoice IS
      SELECT rma_no, rma_line_no, rowstate,
             order_no, line_no, rel_no, line_item_no,
             company, fee_code,
             catalog_no, sale_unit_price, unit_price_incl_tax, base_sale_unit_price,
             price_conv_factor, qty_to_return,
             credit_approver_id, debit_invoice_series_id,
             debit_invoice_no, debit_invoice_item_id, rebate_builder
      FROM  return_material_line_tab
      WHERE rma_no = rma_no_
      AND   rma_line_no = rma_line_no_
      AND   credit_invoice_no IS NULL;

   item_id_                     NUMBER;
   line_rec_                    get_line_to_invoice%ROWTYPE;
   tax_liability_type_db_       VARCHAR2(20);
   fee_code_                    RETURN_MATERIAL_LINE_TAB.fee_code%TYPE;
   sales_rec_                   Sales_Part_API.Public_Rec;
   ordrow_rec_                  Customer_Order_Line_API.Public_Rec;
   catalog_desc_                CUSTOMER_ORDER_LINE_TAB.Catalog_Desc%TYPE := NULL;
   company_                     VARCHAR2(20);
   customer_po_no_              VARCHAR2(50);
   uom_                         VARCHAR2(10);
   sales_part_rebate_group_     VARCHAR2(10) := NULL;
   assortment_id_               VARCHAR2(50) := NULL;
   assortment_node_id_          VARCHAR2(50) := NULL;
   ship_addr_no_                VARCHAR2(50);
   self_billing_db_             VARCHAR2(20);
   income_type_id_              VARCHAR2(20) := NULL;
   refetch_curr_rate_           VARCHAR2(10);
   deb_inv_item_rec_            Customer_Order_Inv_Item_API.Public_Rec;
   deb_inv_quantity_            NUMBER;
   free_of_charge_tax_basis_    NUMBER;
BEGIN
   IF use_ref_inv_curr_rate_ = 1 THEN
      refetch_curr_rate_ := 'FALSE';
   ELSE
      refetch_curr_rate_ := 'TRUE';
   END IF;
   
   OPEN get_line_to_invoice;
   FETCH get_line_to_invoice INTO line_rec_;
   IF get_line_to_invoice%NOTFOUND THEN
      CLOSE get_line_to_invoice;
      Error_SYS.Record_General(lu_name_, 'NO_RMA_LINE_DATA: Could not find RMA Line data when creating credit invoice.');
   ELSE
      CLOSE get_line_to_invoice;
   END IF;
   IF (line_rec_.order_no IS NOT NULL) THEN
      ordrow_rec_ := Customer_Order_Line_API.Get(line_rec_.order_no,
                                                 line_rec_.line_no,
                                                 line_rec_.rel_no,
                                                 line_rec_.line_item_no);
   END IF;
   company_        := line_rec_.company;
   customer_po_no_ := Customer_Order_API.Get_Internal_Po_No(line_rec_.order_no);
   IF (customer_po_no_ IS NULL) THEN
      customer_po_no_ := Customer_Order_API.Get_Customer_Po_No(line_rec_.order_no);
   END IF;
   tax_liability_type_db_ := Return_Material_Line_API.Get_Tax_Liability_Type_Db(rma_no_, rma_line_no_);

   -- IID ESDI109E
   IF (rma_rec_.originating_rma_no IS NOT NULL) THEN
      -- in supply site rma, the delivery address is from external customer which is different from rma customer.
      -- but just for invoicing, the delivery address is fetched from rma customers default delivery address. which is same as invoicing of internal customer order.
      ship_addr_no_ := Cust_Ord_Customer_API.Get_Delivery_Address(rma_rec_.customer_no);
   ELSE
      IF (line_rec_.order_no IS NOT NULL AND ordrow_rec_.demand_code != 'IPD') THEN
         ship_addr_no_ := ordrow_rec_.ship_addr_no;   
      END IF;
      IF (ship_addr_no_ IS NULL) THEN
         ship_addr_no_ := rma_rec_.ship_addr_no;
      END IF;      
   END IF;

   IF (tax_liability_type_db_ != 'EXM') THEN
      fee_code_ := line_rec_.fee_code;
   END IF;

   IF (line_rec_.credit_approver_id IS NULL) THEN
      Error_SYS.Record_General
        (lu_name_, 'NOT_CREDIT_APPROVED: Credit Approver was not specified for the RMA line :P1.',
         to_char(rma_line_no_));

   ELSIF (line_rec_.rowstate IN ('Denied', 'Planned')) THEN
      Error_SYS.Record_General(lu_name_, 'RMLINENOTREL: RMA line :P1 must at least be released to be credit invoiced.',
         to_char(rma_line_no_));

   ELSIF (line_rec_.order_no IS NOT NULL) THEN
      trace_sys.field('RMA line associated. Crediting with order connection.',rma_line_no_);

      -- Note : Set the Commission Recalc Flag to true: data have changed, commission should/may be recalculated
      Order_Line_Commission_API.Set_Order_Com_Lines_Changed(line_rec_.order_no, line_rec_.line_no,
                                                            line_rec_.rel_no, line_rec_.line_item_no);
      
      -- Note : Credit for returns are not allowed for order lines that were not charged.
      IF (ordrow_rec_.charged_item = 'ITEM NOT CHARGED') THEN
         Error_SYS.Record_General(lu_name_, 'NONCHARGEDRETURN: Returns for order lines not charged cannot be credited, RMA line :P1.',
             to_char(rma_line_no_));
      END IF;
   END IF;

   catalog_desc_ := Return_Material_Line_API.Get_Catalog_Desc(rma_no_, rma_line_no_);
   sales_rec_ := Sales_Part_API.Get(rma_rec_.contract, line_rec_.catalog_no);
   
   IF (line_rec_.order_no IS NOT NULL) THEN
      uom_ := ordrow_rec_.sales_unit_meas;
   ELSE
      uom_ := sales_rec_.sales_unit_meas;
   END IF;

   IF line_rec_.rebate_builder = 'TRUE' THEN
      Get_Rebate_Info___(sales_part_rebate_group_, assortment_id_, assortment_node_id_,
                         company_, rma_rec_.contract, rma_rec_.customer_no, line_rec_.catalog_no);
   END IF;
  
   IF (line_rec_.debit_invoice_no IS NOT NULL) THEN
      income_type_id_ := Customer_Invoice_Pub_Util_API.Get_Income_Type_Id(company_,
                                                                          Return_Material_API.Get_Customer_No(rma_no_),
                                                                          line_rec_.debit_invoice_series_id,
                                                                          line_rec_.debit_invoice_no, 
                                                                          line_rec_.debit_invoice_item_id);
      deb_inv_item_rec_ := Customer_Order_Inv_Item_API.Get(company_, 
                                                           Customer_Order_Inv_Head_API.Get_Invoice_Id_By_No(company_, line_rec_.debit_invoice_no, line_rec_.debit_invoice_series_id),
                                                           line_rec_.debit_invoice_item_id);
      IF (deb_inv_item_rec_.free_of_charge = 'TRUE') THEN 
         free_of_charge_tax_basis_ := deb_inv_item_rec_.free_of_charge_tax_basis;
         deb_inv_quantity_         := deb_inv_item_rec_.invoiced_qty;
      END IF;   
   END IF;
   
   Customer_Order_Inv_Item_API.Create_Invoice_Item(
      item_id_,                       --    ITEM_ID_
      invoice_id_,                    --    INVOICE_ID_
      company_,                       --    COMPANY
      line_rec_.order_no,             --    ORDER_NO_
      line_rec_.line_no,              --    LINE_NO_
      line_rec_.rel_no,               --    REL_NO_
      line_rec_.line_item_no,         --    LINE_ITEM_NO_
      rma_rec_.contract,              --    CONTRACT_
      line_rec_.catalog_no,           --    CATALOG_NO_
      catalog_desc_,                  --    CATALOG_DESC_
      uom_,                           --    sales_unit_meas_
      line_rec_.price_conv_factor,    --    PRICE_CONV_FACTOR_
      line_rec_.sale_unit_price,      --    SALE_UNIT_PRICE_
      line_rec_.unit_price_incl_tax,  --    UNIT_PRICE_INCL_TAX_
      0,                              --    DISCOUNT_
      0,                              --    ORDER_DISCOUNT_
      fee_code_,                      --    VAT_CODE_
      NULL ,                          --    TOTAL_TAX_PERCENTAGE_
      line_rec_.qty_to_return,        --    INVOICED_QTY_
      customer_po_no_,                --    CUSTOMER_PO_NO_
      Return_Material_Line_API.Get_Delivery_Type(rma_no_, rma_line_no_), -- DELIV_TYPE_ID_
      line_rec_.qty_to_return * -1,   --    INVOICED_QTY_COUNT_     -- credit invoice all possible
      NULL,                           --    CHARGE_SEQ_NO_
      NULL,                           --    CHARGE_GROUP_
      NULL,                           --    STAGE_ staged billing stage number
      'TRUE',                         --    Prel_Update_Allowed
      rma_no_,                        --    RMA_NO_
      rma_line_no_,                   --    RMA_LINE_NO_
      NULL,                           --    RMA_CHARGE_NO_
      NULL,                           --    DEB_INVOICE_ID_
      NULL,                           --    DEB_ITEM_ID_
      NULL,                           --    ADD_DISCOUNT_
      sales_part_rebate_group_,       --    SALES_PART_REBATE_GROUP_
      assortment_id_,                 --    ASSORTMENT_ID_
      assortment_node_id_,            --    ASSORTMENT_NODE_ID_
      NULL,                           --    CHARGE_PERCENT_
      NULL,                           --    CHARGE_PERCENT_BASIS_
      NULL,                           --    RENTAL_TRANSACTION_ID_ 
      ship_addr_no_,                  --    DELIVERY_ADDRESS_ID_
      income_type_id_,                --    INCOME_TYPE_ID_
      free_of_charge_tax_basis_ => free_of_charge_tax_basis_,
      deb_inv_quantity_ => deb_inv_quantity_);

   Return_Material_Line_API.Modify_Cr_Invoice_Fields(rma_no_, rma_line_no_,
                                                     invoice_id_, item_id_);

   IF (line_rec_.order_no IS NOT NULL) AND Check_Create_Cust_Ord_Hist___(company_, invoice_id_, item_id_, line_rec_.order_no) THEN
      Customer_Order_Inv_Head_API.Create_Credit_Invoice_Hist(order_no_       => line_rec_.order_no,
                                                             cre_invoice_id_ => invoice_id_,
                                                             ref_invoice_id_ => Customer_Order_Inv_Head_API.Get_Invoice_Id_By_No(company_, 
                                                                                                                                 line_rec_.debit_invoice_no, 
                                                                                                                                 line_rec_.debit_invoice_series_id));
   END IF;
   -- copy tax lines from reference RMA item to this credit invoice item
   Tax_Handling_Order_Util_API.Transfer_Tax_lines(company_, 
                                                  Tax_Source_API.DB_RETURN_MATERIAL_LINE,
                                                  rma_no_,
                                                  rma_line_no_,
                                                  '*',
                                                  '*',
                                                  '*',
                                                  Tax_Source_API.DB_INVOICE,
                                                  invoice_id_,
                                                  item_id_,
                                                  '*',
                                                  '*',
                                                  '*',
                                                  'TRUE',
                                                  refetch_curr_rate_); 
     
   self_billing_db_ := Customer_Order_Line_API.Get_Self_Billing_Db(line_rec_.order_no, line_rec_.line_no, line_rec_.rel_no, line_rec_.line_item_no);
   
   IF (nvl(self_billing_db_, ' ') = 'NOT SELF BILLING' OR line_rec_.order_no IS NULL) THEN      
      Customer_Invoice_Pub_Util_API.Create_Rma_Cre_Inv_Wht_Item(company_,
                                                                Return_Material_API.Get_Customer_No(rma_no_),
                                                                'CREDIT',
                                                                ship_addr_no_,
                                                                line_rec_.debit_invoice_series_id,
                                                                line_rec_.debit_invoice_no, 
                                                                line_rec_.debit_invoice_item_id,                                                                            
                                                                invoice_id_,
                                                                item_id_);   
   END IF;
   -- If CO Line is project connected, then refresh project revenue for CO Invoice Line
   IF (line_rec_.order_no IS NOT NULL) AND (line_rec_.line_no IS NOT NULL) AND 
      (line_rec_.rel_no IS NOT NULL) AND (line_rec_.line_item_no IS NOT NULL) AND (NVL(ordrow_rec_.activity_seq, 0) > 0) THEN
       
      Customer_Order_Inv_item_API.Calculate_Prel_Revenue__ (company_, invoice_id_, item_id_, ordrow_rec_.activity_seq);
   END IF;
END Credit_Returned_Line___;


-- Credit_Returned_Charge___
--   Create credit invoice line for the specified RMA charge.
PROCEDURE Credit_Returned_Charge___ (
   rma_no_                 IN NUMBER,
   rma_charge_no_          IN NUMBER,
   invoice_id_             IN NUMBER,
   rma_rec_                IN Return_Material_API.Public_Rec,
   use_ref_inv_curr_rate_  IN NUMBER )
IS
   -- Note : takes qty_to_return from all states but denied and planned
   -- Note : (this is to allow  credit invoicing in early states)
   -- Note : this creates an invoice item for a specific rma charge.
   CURSOR get_charge_state IS
     SELECT rowstate
     FROM return_material_charge_tab
     WHERE rma_no = rma_no_
     AND   rma_charge_no = rma_charge_no_
     AND   credit_invoice_no IS NULL;
     
   rowstate_                     VARCHAR2(2000);
   item_id_                      NUMBER;
   rma_charge_rec_               Return_Material_Charge_API.Public_Rec;
   charge_rec_                   Sales_Charge_Type_API.Public_Rec;
   tax_liability_type_db_        VARCHAR2(20);
   fee_code_                     RETURN_MATERIAL_CHARGE_TAB.fee_code%TYPE;
   co_charge_rec_                Customer_Order_Charge_API.Public_Rec;
   co_line_rec_                  Customer_Order_Line_API.Public_Rec;
   company_                      VARCHAR2(20);
   return_material_rec_          RETURN_MATERIAL_API.Public_Rec;
   debit_invoice_id_             NUMBER;
   rma_charge_percent_basis_     NUMBER;
   ship_addr_no_                 VARCHAR2(50);
   refetch_curr_rate_            VARCHAR2(10);
   
   CURSOR get_charge_deb_inv(order_no_ VARCHAR2) IS
      SELECT ii.invoice_id
      FROM   CUSTOMER_ORDER_INV_ITEM ii, RETURN_MATERIAL_CHARGE_TAB ct
      WHERE  ct.rma_no        = rma_no_
      AND    ii.order_no      = ct.order_no
      AND    ii.order_no      = order_no_
      AND    ii.charge_seq_no = ct.sequence_no
      AND    ct.rma_charge_no = rma_charge_no_
      AND    ii.company       = ct.company
      AND    ct.order_no IS NOT NULL
      AND    ct.credit_invoice_no IS NULL; 
BEGIN
   IF use_ref_inv_curr_rate_ = 1 THEN
      refetch_curr_rate_ := 'FALSE';
   ELSE
      refetch_curr_rate_ := 'TRUE';
   END IF;
   
   OPEN get_charge_state;
   FETCH get_charge_state INTO rowstate_;
   IF get_charge_state%NOTFOUND THEN
      CLOSE get_charge_state;
      Error_SYS.Record_General(lu_name_, 'NO_RMA_CHARGE_DATA: Could not find RMA Charge data when creating credit invoice.');
   END IF;
   CLOSE get_charge_state;

   IF (rowstate_ IN ('Denied', 'Planned')) THEN
      Error_SYS.Record_General(lu_name_, 'RMCHARGENOTREL: RMA charge :P1 must at least be released to be credit invoiced.',
         to_char(rma_charge_no_));
   END IF;

   rma_charge_rec_ := Return_Material_Charge_API.Get(rma_no_, rma_charge_no_);
   company_ := rma_charge_rec_.company;

   -- RMA charge lines can get saved even though those are not invoiced on CO. When Creating CR Invoice check added.
   IF (rma_charge_rec_.order_no IS NOT NULL) THEN
      IF (Customer_Order_Inv_Item_API.Is_Co_Charge_Line_Invoiced(rma_charge_rec_.company,
                                                                 rma_charge_rec_.order_no,
                                                                 rma_charge_rec_.sequence_no) = 0) THEN
         Error_SYS.Record_General(lu_name_, 'CHGNOTINVOICED: The selected charge line :P1 for order number :P2, is not yet invoiced.', rma_charge_rec_.sequence_no, rma_charge_rec_.order_no);
      END IF;
      co_charge_rec_ := Customer_Order_Charge_API.Get(rma_charge_rec_.order_no, rma_charge_rec_.sequence_no);
   END IF;

   IF (co_charge_rec_.line_no IS NOT NULL) THEN
      co_line_rec_ := Customer_Order_Line_API.Get(rma_charge_rec_.order_no, co_charge_rec_.line_no, co_charge_rec_.rel_no, co_charge_rec_.line_item_no);
   END IF;
   tax_liability_type_db_ := Return_Material_Charge_API.Get_Tax_Liability_Type_Db(rma_no_, rma_charge_no_);
   return_material_rec_ := Return_Material_API.Get(rma_no_);
   IF (return_material_rec_.originating_rma_no IS NOT NULL) THEN
      -- in supply site rma, the delivery address is from external customer which is different from rma customer.
      -- but just for invoicing, the delivery address is fetched from rma customers default delivery address. which is same as invoicing of internal customer order.
      ship_addr_no_ := Cust_Ord_Customer_API.Get_Delivery_Address(return_material_rec_.customer_no);
   ELSE
      IF (co_charge_rec_.line_no IS NOT NULL) THEN
         ship_addr_no_ := co_line_rec_.ship_addr_no;
      END IF;
      IF (ship_addr_no_ IS NULL) THEN
         ship_addr_no_ := return_material_rec_.ship_addr_no;
      END IF;      
   END IF;
   
   -- get charge info.
   charge_rec_ := Sales_Charge_Type_API.Get(rma_charge_rec_.contract, rma_charge_rec_.charge_type);

   IF (rma_charge_rec_.order_no IS NOT NULL) THEN
      co_charge_rec_ := Customer_Order_Charge_API.Get(rma_charge_rec_.order_no, rma_charge_rec_.sequence_no);
   END IF;


   IF (tax_liability_type_db_ != 'EXM') THEN
      fee_code_ := rma_charge_rec_.fee_code;
   END IF;

   IF (rma_charge_rec_.credit_approver_id IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'NOT_CREDIT_APPROVED_CH: Credit Approver was not specified for the RMA charge :P1.',
         to_char(rma_charge_no_));

   ELSIF (rma_charge_rec_.credit_invoice_no IS NOT NULL) THEN
      Error_SYS.Record_General(lu_name_, 'ALREADYCREDITED: RMA charge :P1 already credited.',
         to_char(rma_charge_no_));
   END IF;

   charge_rec_.charge_type_desc := Return_Material_Charge_API.Get_Charge_Type_Desc(rma_charge_rec_.contract, rma_no_, rma_charge_rec_.charge_type);

   IF  (rma_charge_rec_.order_no IS NOT NULL) THEN
      OPEN get_charge_deb_inv(rma_charge_rec_.order_no);
      FETCH get_charge_deb_inv INTO debit_invoice_id_;
      CLOSE get_charge_deb_inv; 
   END IF;
   
   rma_charge_percent_basis_ := Return_Material_Charge_API.Get_Charge_Percent_Basis(rma_no_, rma_charge_no_);
  
   Customer_Order_Inv_Item_API.Create_Invoice_Item(
      item_id_,                                 --    item_id_
      invoice_id_,                              --    invoice_id_
      company_,                                 --    company_
      rma_charge_rec_.order_no,                 --    order_no_
      co_charge_rec_.line_no,                   --    line_no_
      co_charge_rec_.rel_no,                    --    rel_no_
      co_charge_rec_.line_item_no,              --    line_item_no_
      rma_rec_.contract,                        --    contract_
      rma_charge_rec_.charge_type,              --    catalog_no_
      charge_rec_.charge_type_desc,             --    catalog_desc_
      rma_charge_rec_.sales_unit_meas,          --    sales_unit_meas_
      1,                                        --    price_conv_factor_
      rma_charge_rec_.charge_amount,            --    sale_unit_price_
      rma_charge_rec_.charge_amount_incl_tax,   --    unit_price_incl_tax_
      0,                                        --    discount_
      0,                                        --    order_discount_
      fee_code_,                                --    vat_code_
      NULL ,                                    --    total_tax_percentage_
      rma_charge_rec_.charged_qty,              --    invoiced_qty_
      Customer_Order_API.Get_Customer_Po_No(rma_charge_rec_.order_no), --    customer_po_no_
      Return_Material_Charge_API.Get_Delivery_Type(rma_no_, rma_charge_no_), -- deliv_type_id_
      rma_charge_rec_.charged_qty * -1,         --    invoiced_qty_count_ -- credit invoice all possible
      rma_charge_rec_.sequence_no,              --    charge_seq_no_ (on order)
      charge_rec_.charge_group,                 --    charge_group_
      NULL,                                     --    stage number
      'TRUE',                                   --    Prel_Update_Allowed
      rma_no_        => rma_no_,
      rma_charge_no_ => rma_charge_no_,
      charge_percent_ => rma_charge_rec_.charge, 
      charge_percent_basis_ => rma_charge_percent_basis_,
      deb_invoice_id_ => debit_invoice_id_,
      delivery_address_id_ => ship_addr_no_  );  

   Return_Material_Charge_API.Modify_Cr_Invoice_Fields(rma_no_, rma_charge_no_, invoice_id_, item_id_);
   
   IF (rma_charge_rec_.order_no IS NOT NULL) AND Check_Create_Cust_Ord_Hist___(company_, invoice_id_, item_id_, rma_charge_rec_.order_no) THEN
      Customer_Order_Inv_Head_API.Create_Credit_Invoice_Hist(order_no_       => rma_charge_rec_.order_no,
                                                             cre_invoice_id_ => invoice_id_,
                                                             ref_invoice_id_ => debit_invoice_id_);
   END IF;
   -- copy tax lines from reference RMA charge item to this credit invoice item
   Tax_Handling_Order_Util_API.Transfer_Tax_lines(company_, 
                                                  Tax_Source_API.DB_RETURN_MATERIAL_CHARGE,
                                                  rma_no_,
                                                  rma_charge_no_,
                                                  '*',
                                                  '*',
                                                  '*',
                                                  Tax_Source_API.DB_INVOICE,
                                                  invoice_id_,
                                                  item_id_,
                                                  '*',
                                                  '*',
                                                  '*',
                                                  'TRUE',
                                                  refetch_curr_rate_); 
     
   Customer_Invoice_Pub_Util_API.Create_Rma_Cre_Inv_Wht_Item(company_,
                                                             Return_Material_API.Get_Customer_No(rma_no_),
                                                             'CREDIT',
                                                             ship_addr_no_,
                                                             NULL,
                                                             NULL, 
                                                             NULL,                                                                            
                                                             invoice_id_,
                                                             item_id_);   

   -- If CO Line is project connected, then refresh project revenue for CO Invoice Line
   IF (NVL(co_line_rec_.activity_seq, 0)  > 0) THEN
      Customer_Order_Inv_item_API.Calculate_Prel_Revenue__ (company_, invoice_id_, item_id_, co_line_rec_.activity_seq);
   END IF; 
END Credit_Returned_Charge___;


-- Create_Invoice_Head_For_Rma___
--   Creates the Invoice head using an invoice head record and specifies the RMA_NO .
PROCEDURE Create_Invoice_Head_For_Rma___ (
    invoice_id_              IN OUT NUMBER,
    ivc_head_rec_            IN     ivc_head_rec,
    use_ref_inv_curr_rate_   IN     NUMBER,
    currency_rate_type_      IN     VARCHAR2,
    invoice_type_            IN     VARCHAR2,
    use_price_incl_tax_db_   IN     VARCHAR2 )
IS
   deb_invoice_no_         RETURN_MATERIAL_LINE_TAB.debit_invoice_no%TYPE;
   use_ref_inv_rates_      VARCHAR2(5) := 'FALSE';
   -- gelr:mx_xml_doc_reporting, begin
   correction_reason_id_   VARCHAR2(20);
   correction_reason_      VARCHAR2(2000);
   -- gelr:mx_xml_doc_reporting, end
BEGIN
   deb_invoice_no_ := ivc_head_rec_.number_reference;
   IF (use_ref_inv_curr_rate_ = 1) AND (deb_invoice_no_ IS NOT NULL) THEN
      use_ref_inv_rates_ := 'TRUE';
   END IF;

   -- gelr:mx_xml_doc_reporting, begin
   IF (Company_Localization_Info_API.Get_Parameter_Value_Db(ivc_head_rec_.company, 'MX_XML_DOC_REPORTING') = Fnd_Boolean_API.DB_TRUE) THEN 
      correction_reason_id_ := Invoice_Type_API.Get_Correction_Reason_Id(ivc_head_rec_.company, Party_Type_API.Decode(Party_Type_API.DB_CUSTOMER), invoice_type_);
      correction_reason_    := Correction_Reason_API.Get_Correction_Reason(ivc_head_rec_.company, correction_reason_id_);
   END IF;
   -- gelr:mx_xml_doc_reporting, end
      
   Customer_Order_Inv_Head_API.Create_Invoice_Head(
      invoice_id_, --invoice_id_
      ivc_head_rec_.company, --company_
      ivc_head_rec_.order_no, --order_no_
      ivc_head_rec_.customer_no, --customer_no_
      ivc_head_rec_.customer_no_pay, --customer_no_pay_
      ivc_head_rec_.authorize_name, --authorize_name_
      ivc_head_rec_.date_entered, --date_entered_
      ivc_head_rec_.cust_ref, --cust_ref_
      ivc_head_rec_.ship_via_desc, --ship_via_desc_
      ivc_head_rec_.forward_agent_id, --forward_agent_id_
      ivc_head_rec_.label_note, --label_note_
      ivc_head_rec_.delivery_terms_desc, --delivery_terms_desc_
      ivc_head_rec_.del_terms_location, --del_terms_location_
      ivc_head_rec_.pay_term_id, --pay_term_id_
      ivc_head_rec_.currency_code, --currency_code_
      ivc_head_rec_.ship_addr_no, --ship_addr_no_
      ivc_head_rec_.customer_no_pay_addr_no, --customer_no_pay_addr_no_
      ivc_head_rec_.bill_addr_no, --bill_addr_no_
      ivc_head_rec_.wanted_delivery_date, --wanted_delivery_date_
      invoice_type_, --invoice_type_
      ivc_head_rec_.number_reference, --number_reference_
      ivc_head_rec_.series_reference, --series_reference_
      ivc_head_rec_.contract, --contract_
      ivc_head_rec_.js_invoice_state_db, --js_invoice_state_db_
      currency_rate_type_, --currency_rate_type_
      'FALSE', --collect_
      ivc_head_rec_.rma_no, -- rma_no
      NULL,                 -- shipment_id
      NULL,                 -- adv_invoice
      NULL,                 -- adv_pay_base_date
      NULL,                 -- sb_reference_no
      use_ref_inv_rates_,   -- use_ref_inv_curr_rate
      NULL,                 -- ledger_item_id
      NULL,                 -- ledger_item_series_id
      NULL,                 -- ledger_item_version_id
      NULL,                 -- aggregation_no
      'FALSE',              -- final_settlement
      NULL,                 -- project_id
      NULL,                 -- tax_id_number
      NULL,                 -- tax_id_type
      NULL,                 -- branch
      ivc_head_rec_.supply_country_db, --supply_country_db_
      NULL, --invoice_date_
      use_price_incl_tax_db_, --use_price_incl_tax_db_      
      NULL, --wht_amount_base_
      NULL, --curr_rate_new_
      NULL, --tax_curr_rate_new_
      correction_reason_id_, --correction_reason_id_
      correction_reason_, --correction_reason_
      'FALSE', --is_simulated_
      ivc_head_rec_.invoice_reason_id); --invoice_reason_id_      
END Create_Invoice_Head_For_Rma___;


-- Connect_Delivs_To_Ivc_Item___
--   This method will modify the qty invoiced and Create the reference to
--   the order delivery.
PROCEDURE Connect_Delivs_To_Ivc_Item___ (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   invoice_id_   IN NUMBER,
   item_id_      IN NUMBER )
IS
   contract_          VARCHAR2(15);
   company_           VARCHAR2(20);
   previous_deliv_no_ NUMBER := 0;

   CURSOR get_outstanding_sales IS
      SELECT outstanding_sales_id, deliv_no
        FROM outstanding_sales_tab
       WHERE invoice_id = invoice_id_
         AND item_id IS NULL
    ORDER BY deliv_no;
BEGIN
   contract_ := Customer_Order_Line_API.Get_Contract(order_no_, line_no_, rel_no_, line_item_no_);
   company_  := Site_API.Get_Company(contract_);

   FOR next_ IN get_outstanding_sales LOOP
      Outstanding_Sales_API.Modify_Invoice_Reference(next_.outstanding_sales_id,
                                                     invoice_id_, item_id_);
      -- Create a cross reference record between invoice item and delivery
      -- Do we need to check the existance of a record when the stock is non consignments??
      IF (previous_deliv_no_ != next_.deliv_no) THEN
         Cust_Delivery_Inv_Ref_API.Create_Reference(next_.deliv_no, company_, invoice_id_, item_id_);
      END IF;
      previous_deliv_no_ := next_.deliv_no;
   END LOOP;
END Connect_Delivs_To_Ivc_Item___;


-- Create_Shipment_Invoice___
--   Create a collective invoice for one single shipment, currency,
--   bill_addr_no and payment_terms.
PROCEDURE Create_Shipment_Invoice___ (
   invoice_id_            OUT NUMBER,
   shipment_id_           IN  NUMBER,
   customer_no_           IN  VARCHAR2,
   contract_              IN  VARCHAR2,
   currency_code_         IN  VARCHAR2,
   pay_term_id_           IN  VARCHAR2,
   bill_addr_no_          IN  VARCHAR2,
   jinsui_invoice_db_     IN  VARCHAR2,
   currency_rate_type_    IN  VARCHAR2,
   use_price_incl_tax_db_ IN  VARCHAR2 )
IS
   collective_            VARCHAR2(5) := 'TRUE';
   company_               VARCHAR2(20);
   delivery_terms_desc_   VARCHAR2(35);
   ship_via_desc_         VARCHAR2(35);
   lines_invoiced_        BOOLEAN := FALSE;
   no_invoiced_lines      EXCEPTION;
   info_                  VARCHAR2(2000);
   adv_pre_payment_exist_ VARCHAR2(5) := 'FALSE';
   item_id_               NUMBER;
   attr_                  VARCHAR2(2000);
   dummy_                 NUMBER;
   -- gelr:fr_service_code, begin
   service_code_          VARCHAR2(100);
   -- gelr:fr_service_code, end
   copy_from_tax_source_arr_     Tax_Handling_Util_API.source_key_arr := Tax_Handling_Util_API.source_key_arr();
   copy_to_tax_source_arr_       Tax_Handling_Util_API.source_key_arr := Tax_Handling_Util_API.source_key_arr();
   i_                            NUMBER;
   external_tax_cal_method_      VARCHAR2(50); 
   taransfer_ext_tax_at_line_    BOOLEAN := TRUE;

   CURSOR shipment_data IS
      SELECT sp.delivery_terms, sp.del_terms_location, sp.receiver_addr_id, sp.forward_agent_id, 
             sp.ship_via_code, sp.language_code, sf.supply_country, sf.freight_chg_invoiced, sf.currency_code
      FROM   shipment_pub sp, shipment_freight_tab sf
      WHERE  sp.shipment_id = shipment_id_
      AND    sp.shipment_id = sf.shipment_id;
   
   -- gelr:fr_service_code, begin
      CURSOR count_distinct_serv_codes IS
      SELECT COUNT(DISTINCT NVL(co.service_code, ' '))
      FROM   customer_order_tab co
      WHERE  NVL(co.customer_no_pay_addr_no, co.bill_addr_no) = bill_addr_no_
      AND    NVL(co.customer_no_pay, co.customer_no) = customer_no_
      AND   ( co.currency_code = currency_code_ OR EXISTS (
                                                           SELECT 1
                                                           FROM  shipment_freight_tab sf
                                                           WHERE sf.shipment_id   = shipment_id_
                                                           AND   sf.currency_code = currency_code_))
      AND    co.pay_term_id = pay_term_id_
      AND    co.contract  = contract_
      AND    co.order_no IN (SELECT source_ref1 
                             FROM shipment_line_pub 
                             WHERE shipment_id = shipment_id_
                             AND source_ref_type_db = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER)
      AND    co.jinsui_invoice = jinsui_invoice_db_
      AND    NVL(co.currency_rate_type, Database_SYS.string_null_) = NVL(currency_rate_type_, Database_SYS.string_null_);   
      -- gelr:fr_service_code, end      
      
   CURSOR head_data IS
      SELECT co.order_no, co.customer_no, co.authorize_code,
             co.date_entered, co.bill_addr_no, co.customer_no_pay,
             co.customer_no_pay_addr_no, NVL(co.internal_po_no, co.customer_po_no) cust_po_no, 
             NVL(co.customer_no_pay_ref, co.cust_ref) cust_ref,
             co.label_note, co.note_id, co.wanted_delivery_date, co.ship_addr_no,
             co.currency_rate_type,co.service_code
      FROM   customer_order_tab co
      WHERE  NVL(co.customer_no_pay_addr_no, co.bill_addr_no) = bill_addr_no_
      AND    NVL(co.customer_no_pay, co.customer_no) = customer_no_
      AND   ( co.currency_code = currency_code_ OR EXISTS (
                                                           SELECT 1
                                                           FROM  shipment_freight_tab sf
                                                           WHERE sf.shipment_id   = shipment_id_
                                                           AND   sf.currency_code = currency_code_
                                                           ))
      AND    co.pay_term_id = pay_term_id_
      AND    co.contract  = contract_
      AND    co.order_no IN (SELECT source_ref1 
                             FROM shipment_line_pub 
                             WHERE shipment_id = shipment_id_
                             AND source_ref_type_db = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER)
      AND    co.jinsui_invoice = jinsui_invoice_db_
      AND    NVL(co.currency_rate_type, Database_SYS.string_null_) = NVL(currency_rate_type_, Database_SYS.string_null_)
      ORDER BY co.order_no;

   CURSOR get_shipment_freight_charges IS
      SELECT *
      FROM shipment_freight_charge_tab
      WHERE shipment_id = shipment_id_
      AND   collect     = 'INVOICE';
      
   CURSOR check_order_line_ipd IS 
      SELECT 1
      FROM   customer_order_line_tab co
      WHERE  co.demand_code = 'IPD'
      AND    (co.order_no, co.line_no, co.rel_no, co.line_item_no ) IN (SELECT sl.source_ref1,sl.source_ref2,sl.source_ref3, sl.source_ref4
                                                                        FROM  shipment_line_pub sl
                                                                        WHERE shipment_id = shipment_id_                                                                        
                                                                        AND   source_ref_type_db = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER);

   invoice_component_    head_data%ROWTYPE;
   shipment_             shipment_data%ROWTYPE;
   priv_ord_no_          CUSTOMER_ORDER_TAB.order_no%TYPE;
   -- gelr:invoice_reason, begin
   invoice_reason_id_    CUSTOMER_ORDER_TAB.invoice_reason_id%TYPE;
   -- gelr:invoice_reason, end
BEGIN
   
   company_ := Site_API.Get_Company(contract_);

   OPEN shipment_data;
   FETCH shipment_data INTO shipment_;
   CLOSE shipment_data;

   delivery_terms_desc_ := Order_Delivery_Term_API.Get_Description(shipment_.delivery_terms, shipment_.language_code);
   ship_via_desc_       := Mpccom_Ship_Via_API.Get_Description(shipment_.ship_via_code, shipment_.language_code);
      
   @ApproveTransactionStatement(2014-09-18,darklk)
   SAVEPOINT before_header_creation;

   OPEN head_data;
   FETCH head_data INTO invoice_component_;
   IF head_data%NOTFOUND THEN
      CLOSE head_data;
   ELSE
      
      OPEN check_order_line_ipd;
      FETCH check_order_line_ipd INTO dummy_;   
      IF (check_order_line_ipd%FOUND) THEN 
         shipment_.receiver_addr_id := NULL;         
      END IF;        
      CLOSE check_order_line_ipd;
         
      -- gelr:invoice_reason, begin
      IF (Company_Localization_Info_API.Get_Parameter_Value_Db(company_, 'INVOICE_REASON') = Fnd_Boolean_API.DB_TRUE) THEN 
         invoice_reason_id_ := Identity_Invoice_Info_API.Get_Invoice_Reason_Id(company_, invoice_component_.customer_no, Party_Type_API.Decode(Party_Type_API.DB_CUSTOMER));
      END IF;
      -- gelr:invoice_reason, end
      -- gelr:fr_service_code, begin
      IF (Company_Localization_Info_API.Get_Parameter_Value_Db(company_, 'FR_SERVICE_CODE') = Fnd_Boolean_API.DB_TRUE) THEN
         OPEN count_distinct_serv_codes;
         FETCH count_distinct_serv_codes INTO dummy_;
         CLOSE count_distinct_serv_codes;

         IF (dummy_ > 1) THEN
            service_code_ := NULL;
         ELSE
            service_code_ := invoice_component_.service_code;
         END IF;
      END IF;
         -- gelr:fr_service_code, end
   
         Customer_Order_Inv_Head_API.Create_Invoice_Head(
         invoice_id_, --invoice_id_
         company_, --company_
         NULL, --order_no_
         invoice_component_.customer_no, --customer_no_
         invoice_component_.customer_no_pay, --customer_no_pay_
         Order_Coordinator_API.Get_Name(invoice_component_.authorize_code), --authorize_name_
         invoice_component_.date_entered, --date_entered_
         invoice_component_.cust_ref, --cust_ref_
         ship_via_desc_, --ship_via_desc_
         shipment_.forward_agent_id, --forward_agent_id_
         invoice_component_.label_note, --label_note_
         delivery_terms_desc_, --delivery_terms_desc_
         shipment_.del_terms_location, --del_terms_location_
         pay_term_id_, --pay_term_id_
         currency_code_, --currency_code_
         NVL(shipment_.receiver_addr_id, invoice_component_.ship_addr_no), --ship_addr_no_
         invoice_component_.customer_no_pay_addr_no, --customer_no_pay_addr_no_
         invoice_component_.bill_addr_no, --bill_addr_no_
         invoice_component_.wanted_delivery_date, --wanted_delivery_date_
         'CUSTCOLDEB', --invoice_type_
         NULL, -- number_reference
         NULL, -- series_reference
         contract_, --contract_
         Get_Js_Invoice_State_Db___(jinsui_invoice_db_), --js_invoice_state_db_
         invoice_component_.currency_rate_type, --currency_rate_type_
         collective_, --collect_
         NULL, -- RMA No
         shipment_id_, --shipment_id_
         NULL,    -- adv_invoice_
         NULL,    -- adv_pay_base_date_
         NULL,    -- sb_reference_no_
         'FALSE', -- use_ref_inv_curr_rate_
         NULL,    -- ledger_item_id_
         NULL,    -- ledger_item_series_id_
         NULL,    -- ledger_item_version_id_
         NULL,    -- aggregation_no_  
         'FALSE', -- final_settlement_
         NULL,    -- project_id_
         NULL,    -- tax_id_number_
         NULL,    -- tax_id_type_
         NULL,    -- branch_
         shipment_.supply_country, --supply_country_db_
         NULL, --invoice_date_
         use_price_incl_tax_db_, --use_price_incl_tax_db_
         NULL, --wht_amount_base_
         NULL, --curr_rate_new_
         NULL, --tax_curr_rate_new_
         NULL, --correction_reason_id_
         NULL, --correction_reason_
         'FALSE', --is_simulated_
         invoice_reason_id_, --invoice_reason_id_
         service_code_ => service_code_); --service_code_
         
      WHILE head_data%FOUND LOOP
         adv_pre_payment_exist_ := Customer_Invoice_Pub_Util_API.Has_Adv_Or_Prepaym_Inv(invoice_component_.order_no);
         IF (adv_pre_payment_exist_ = 'FALSE') THEN
            -- Note : set the Commission Recalc Flag to true: data have changed, commission should/may be recalculated.
            Order_Line_Commission_API.Set_Order_Com_Lines_Changed(invoice_component_.order_no);
            IF (NVL(priv_ord_no_,' ') != invoice_component_.order_no) THEN
               Customer_Order_History_API.New(invoice_component_.order_no,
               Language_SYS.Translate_Constant(lu_name_, 'CRESHIPINVOICE: Shipment invoice :P1 created', NULL, invoice_id_));
            END IF;
            Create_Invoice_Lines___(
               copy_from_tax_source_arr_,
               copy_to_tax_source_arr_,
               lines_invoiced_,
               invoice_component_.order_no,
               invoice_id_,
               invoice_component_.cust_po_no,
               'TRUE',
               NULL,
               shipment_id_,
               currency_code_ => currency_code_);
            priv_ord_no_ := invoice_component_.order_no;
         END IF;
         FETCH head_data INTO invoice_component_;
      END LOOP; -- Loop until all orders are invoiced
      CLOSE head_data;
   END IF;
   
   external_tax_cal_method_ := Company_Tax_Control_API.Get_External_Tax_Cal_Method_Db(company_);

   -- gelr:br_external_tax_integration, Modified condition to include Avalara Brazil
   IF (external_tax_cal_method_ IN (External_Tax_Calc_Method_API.DB_AVALARA_SALES_TAX, External_Tax_Calc_Method_API.DB_AVALARA_TAX_BRAZIL)) THEN
      taransfer_ext_tax_at_line_ := FALSE;
   END IF; 
   
   IF (shipment_.freight_chg_invoiced = 'FALSE' AND currency_code_ = Shipment_Freight_API.Get_Currency_Code(shipment_id_)) THEN   
      i_ := copy_from_tax_source_arr_.COUNT + 1;
      
      FOR shipment_charges_rec_ IN get_shipment_freight_charges LOOP
         Create_Shipment_Charge_Item___ (item_id_, invoice_id_, shipment_id_, shipment_charges_rec_.sequence_no, taransfer_ext_tax_at_line_);   
         
         IF (NOT taransfer_ext_tax_at_line_ AND item_id_ IS NOT NULL) THEN 
            Create_Tax_Source_Keys___(copy_from_tax_source_arr_(i_),
                                      copy_to_tax_source_arr_(i_),
                                      Tax_Source_API.DB_SHIPMENT_FREIGHT_CHARGE,
                                      shipment_id_,
                                      shipment_charges_rec_.sequence_no,
                                      '*',
                                      '*',
                                      '*',
                                      Tax_Source_API.DB_INVOICE,
                                      invoice_id_,
                                      item_id_,
                                      '*',
                                      '*',
                                      '*');  
            i_ := i_ + 1;
         END IF;
      END LOOP;

      IF (item_id_ IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('FREIGHT_CHG_INVOICED_DB', 'TRUE', attr_);
         Shipment_Freight_API.Modify(info_, attr_, shipment_id_);
      END IF;
   END IF;
   
   IF (copy_from_tax_source_arr_.COUNT > 0 ) THEN 
      Transfer_Ext_Tax_Lines___ (copy_from_tax_source_arr_,
                                 copy_to_tax_source_arr_,
                                 company_,
                                 invoice_id_);
   END IF;

   -- If no lines are invoiced, raise an expection so that we can rollback the creation of header.
   IF (NOT lines_invoiced_ AND item_id_ IS NULL) THEN
      RAISE no_invoiced_lines;
   END IF;
                                           
   Customer_Order_Inv_Head_API.Create_Invoice_Complete(company_, invoice_id_);

EXCEPTION
   WHEN  no_invoiced_lines THEN
      @ApproveTransactionStatement(2014-09-18,darklk)
      ROLLBACK TO before_header_creation;
      info_ := Language_SYS.Translate_Constant(lu_name_, 'NOINVOICE: There are no customer order lines available to create the collective customer invoice');
      Transaction_SYS.Set_Status_Info(info_);
END Create_Shipment_Invoice___;


-- Create_Advance_Invoice_Item___
--   This method is used to create Advance Invoice Item
PROCEDURE Create_Advance_Invoice_Item___ (
   item_id_           IN OUT NUMBER,
   invoice_id_        IN     NUMBER,
   order_no_          IN     VARCHAR2,
   adv_pay_amt_net_   IN     NUMBER,
   adv_pay_amt_gross_ IN     NUMBER,
   tax_msg_           IN     VARCHAR2,
   tax_code_          IN     VARCHAR2,
   invoice_text_      IN     VARCHAR2)
IS
   company_                VARCHAR2(20);
   co_rec_                 Customer_Order_API.Public_Rec;
   customer_po_no_         VARCHAR2(50);
BEGIN
   co_rec_         := Customer_Order_API.Get( order_no_ );
   company_        := Site_API.Get_Company(Customer_Order_API.Get_Contract(order_no_));
   customer_po_no_ := NVL(co_rec_.internal_po_no, co_rec_.customer_po_no);

   Customer_Order_Inv_Item_API.Create_Invoice_Item(
      item_id_,
      invoice_id_,
      company_,
      order_no_,
      NULL ,          --line_no
      NULL ,          --rel_no
      NULL ,          --line_item_no
      co_rec_.contract, --contract
      NULL ,          --catalog_no
      invoice_text_ , --catalog_desc
      NULL ,          --sales_unit_meas
      1,              --price_conv_factor
      adv_pay_amt_net_,--sale_unit_price
      adv_pay_amt_gross_,--unit_price_incl_tax_ 
      0 ,             --discount
      0 ,             --order_discount
      tax_code_,      --fee_code
      NULL,           --total_tax_percentage_
      1,              --qty_invoiced
      customer_po_no_, --customer_po_no
      NULL ,          --delivery_type
      1,              --qty_invoiced
      NULL,           -- Not a charge
      NULL,           -- Not a charge
      NULL ,          --stage
      'TRUE',         --Prel_Update_Allowed
      NULL,           --rma_no
      NULL,           --rma_line_no_ 
      NULL,           --rma_charge_no
      NULL,           --debit invoice id
      NULL,           -- debit_item_id
      0,              -- add_discount_ => add_discount_
      NULL,           -- sales_part_rebate_group_
      NULL,           -- assortment_id_
      NULL,           -- assortment_node_id_
      NULL,           -- charge_percent_
      NULL,           -- charge_percent_basis_
      NULL,           -- rental_transaction_id_
      co_rec_.ship_addr_no,-- delivery_address_id_ 
      NULL,           --income_type_id
      NULL,           --shipment_id_
      tax_msg_ );     -- adv inv tax message         
      
END Create_Advance_Invoice_Item___;

-----------------------------------------
-- Check_Create_Cust_Ord_Hist___
--    This method validate that invoice item connected customer order
--    needs to create an order history item when creating credit invoice for RMA.
-----------------------------------------
FUNCTION Check_Create_Cust_Ord_Hist___(
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER,
   item_id_    IN NUMBER,
   order_no_   IN VARCHAR2) RETURN BOOLEAN
IS
   return_value_ BOOLEAN := TRUE;
   dummy_        NUMBER;
   
   CURSOR order_inv_item_exist IS
      SELECT 1
        FROM CUST_INVOICE_PUB_UTIL_ITEM
       WHERE company    =  company_
         AND invoice_id =  invoice_id_
         AND c1         =  order_no_
         AND item_id    != item_id_;
BEGIN
   IF item_id_ <> 1 THEN
      OPEN order_inv_item_exist;
      FETCH order_inv_item_exist INTO dummy_;
      IF order_inv_item_exist%FOUND THEN
         return_value_ := FALSE;
      END IF;
      CLOSE order_inv_item_exist;
   END IF;
   RETURN return_value_;
END Check_Create_Cust_Ord_Hist___;


PROCEDURE Consume_Deliveries___ (
   qty_to_invoice_       OUT NUMBER,
   order_no_             IN  VARCHAR2,
   line_no_              IN  VARCHAR2,
   rel_no_               IN  VARCHAR2,
   line_item_no_         IN  NUMBER,
   invoice_id_           IN  NUMBER,
   ignore_closing_date_  IN  VARCHAR2,
   closest_closing_date_ IN  DATE,
   shipment_id_          IN  NUMBER )
IS
   first_component_        BOOLEAN := TRUE;
   qty_in_packages_        NUMBER;
   qty_shipped_            NUMBER;   
   line_rec_               Customer_Order_Line_API.Public_Rec;
   deliv_qty_to_invoice_   NUMBER;
   attr_                   VARCHAR2(2000);
   comp_line_rec_          Customer_Order_Line_API.Public_Rec;
   pkgs_already_delivered_ NUMBER;
   -- Changed the condition to compare the date_confirmed with the closest_closing_date_
   CURSOR get_qty_to_invoice IS
      SELECT cod.deliv_no, cod.qty_to_invoice, cod.qty_invoiced, cod.component_invoice_flag
      FROM customer_order_delivery_tab cod, CUSTOMER_ORDER_TAB co
      WHERE cod.order_no = order_no_
      AND   cod.line_no = line_no_
      AND   cod.rel_no = rel_no_
      AND   cod.line_item_no = line_item_no_
      AND   cod.order_no = co.order_no
      AND   ((cod.line_item_no <= 0 AND cod.qty_to_invoice != cod.qty_invoiced) OR
             (cod.line_item_no > 0 AND (cod.component_invoice_flag = 'Y')))
      AND   ((co.confirm_deliveries = 'FALSE') OR
             (co.confirm_deliveries = 'TRUE' AND cod.date_confirmed IS NOT NULL AND cod.incorrect_del_confirmation = 'FALSE'))
      AND   (((shipment_id_ IS NULL) AND
              (((cod.shipment_id IS NOT NULL AND shipment_id_ IS NULL) OR
               ((cod.shipment_id IS NULL) AND (shipment_id_ IS NULL) AND
                ((ignore_closing_date_ = 'TRUE')OR(TRUNC(cod.date_confirmed) <= TRUNC(closest_closing_date_)))))) OR
             ((shipment_id_ IS NOT NULL) AND (cod.shipment_id = shipment_id_))))
      AND   cod.cancelled_delivery = 'FALSE'
      ORDER BY cod.deliv_no;

   -- The cursor to receive the qty_to_invoice for the consignment stocks.
   -- A join with the outstnding_sales_tab is used to handle the partial consumptions.
   CURSOR get_consumed_qty_to_invoice IS
      SELECT cod.deliv_no, os.qty_expected, cod.qty_to_invoice, os.outstanding_sales_id
      FROM customer_order_delivery_tab cod, outstanding_sales_tab os
      WHERE cod.order_no = order_no_
      AND   cod.line_no = line_no_
      AND   cod.rel_no = rel_no_
      AND   cod.line_item_no = line_item_no_
      AND   cod.deliv_no = os.deliv_no
      AND   cod.shipment_id IS NULL
      AND   os.invoice_id IS NULL
      AND   (TRUNC(os.date_cogs_posted) <= TRUNC(closest_closing_date_))
      AND   cod.cancelled_delivery = 'FALSE'
      ORDER BY cod.deliv_no;
BEGIN
   
   line_rec_ := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);   
   
   IF line_rec_.consignment_stock = 'CONSIGNMENT STOCK' AND ignore_closing_date_ = 'FALSE' THEN
      FOR next_ IN get_consumed_qty_to_invoice LOOP
         qty_to_invoice_ := NVL(qty_to_invoice_, 0) + next_.qty_expected;
         -- Updating the outstanding sales tab.
         Outstanding_Sales_API.Modify_Invoice_Reference(next_.outstanding_sales_id, invoice_id_, NULL);
         -- Modify qty_invoiced for the consignment stocks
         deliv_qty_to_invoice_ := next_.qty_expected + Customer_Order_Delivery_API.Get_Qty_Invoiced(next_.deliv_no);
         Customer_Order_Delivery_API.Modify_Qty_Invoiced(next_.deliv_no, deliv_qty_to_invoice_);
      END LOOP;
   ELSE
      qty_to_invoice_ := 0;
      IF (line_item_no_ > 0) THEN
         comp_line_rec_ := line_rec_;
         line_rec_ := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, -1);         
      END IF;
      FOR next_ IN get_qty_to_invoice LOOP
         IF (line_item_no_ > 0) THEN
            
            qty_shipped_ := line_rec_.qty_shipped + (line_rec_.qty_confirmeddiff);
            
            -- Find out how many whole packages that has been shipped and confirmed.
            -- The remaining component parts, not enough for whole packages,
            -- shall be invoiced and get separate invoice lines.
            IF comp_line_rec_.new_comp_after_delivery = 'TRUE' THEN
               -- Component lines added after a partial delivery are handled from this code.
               -- Packages already delivered when adding the new component line.
               pkgs_already_delivered_ := line_rec_.buy_qty_due  - (comp_line_rec_.buy_qty_due / comp_line_rec_.qty_per_assembly);
               qty_in_packages_ := comp_line_rec_.qty_per_assembly * (qty_shipped_ - pkgs_already_delivered_);               
            ELSE
               -- Invoice only components and not whole packages.
               qty_in_packages_ := comp_line_rec_.qty_per_assembly * qty_shipped_;               
            END IF;
            IF NOT first_component_ THEN
               qty_in_packages_ := 0;
            ELSIF first_component_ THEN
               first_component_ := FALSE;
            END IF;
            qty_to_invoice_ := qty_to_invoice_ + (next_.qty_to_invoice - next_.qty_invoiced) - qty_in_packages_;
            -- Clear the component_invoice_flag for the delivery record
            IF (next_.component_invoice_flag = 'Y') THEN
               Customer_Order_Delivery_API.Modify_Component_Invoice_Flag(next_.deliv_no, Invoice_Package_Component_API.Decode('N'));
            END IF;
         ELSE
            -- The cursor to receive the qty_to_invoice for the consignment stocks.0
            qty_to_invoice_ := qty_to_invoice_ + (next_.qty_to_invoice - next_.qty_invoiced);
         END IF;
         -- The cursor to receive the qty_to_invoice for the consignment stocks.1
         Client_SYS.Clear_Attr(attr_);
         Client_SYS.Add_To_Attr('INVOICE_ID', invoice_id_, attr_);
         Outstanding_Sales_API.Modify_Confirmed(next_.deliv_no, attr_);
         Customer_Order_Delivery_API.Modify_Qty_Invoiced(next_.deliv_no, next_.qty_to_invoice);
      END LOOP;
   END IF;
END Consume_Deliveries___;


PROCEDURE Unconsume_Deliveries___ (
   order_no_             IN VARCHAR2,
   line_no_              IN VARCHAR2,
   rel_no_               IN VARCHAR2,
   line_item_no_         IN NUMBER,
   invoice_id_           IN NUMBER,
   consignment_stock_    IN VARCHAR2 )
IS
   deliv_qty_invoiced_   NUMBER := 0;
   prev_deliv_no_        NUMBER := 0;
   
   CURSOR get_qty_to_invoice IS
      SELECT cod.deliv_no, cod.qty_to_invoice, cod.qty_invoiced, cod.component_invoice_flag,
             os.outstanding_sales_id, os.company, os.item_id
      FROM Customer_Order_Delivery_Tab cod, Outstanding_Sales_Tab os
      WHERE cod.order_no = order_no_
      AND   cod.line_no = line_no_
      AND   cod.rel_no = rel_no_
      AND   cod.line_item_no = line_item_no_
      AND   cod.line_item_no <= 0
      AND   cod.deliv_no = os.deliv_no
      AND   os.invoice_id = invoice_id_
      AND   cod.cancelled_delivery = 'FALSE'
      ORDER BY cod.deliv_no;

   -- The cursor to receive the qty_to_invoice for the consignment stocks.
   -- A join with the outstnding_sales_tab is used to handle the partial consumptions.
   CURSOR get_consumed_qty_to_invoice IS
      SELECT cod.deliv_no, 
             cod.qty_invoiced   deliv_qty_invoiced, 
             os.qty_expected, 
             os.outstanding_sales_id,
             os.company,
             os.item_id
      FROM Customer_Order_Delivery_Tab cod, Outstanding_Sales_Tab os
      WHERE cod.order_no = order_no_
      AND   cod.line_no = line_no_
      AND   cod.rel_no = rel_no_
      AND   cod.line_item_no = line_item_no_
      AND   cod.deliv_no = os.deliv_no
      AND   os.invoice_id = invoice_id_
      AND   cod.cancelled_delivery = 'FALSE'
      ORDER BY cod.deliv_no;
      
   CURSOR get_comp_invoiced_delivs(order_no_ VARCHAR2, line_no_ VARCHAR2, rel_no_ VARCHAR2, line_item_no_ NUMBER) IS
      SELECT *
      FROM  customer_order_delivery_tab cod
      WHERE cod.order_no = order_no_
      AND   cod.line_no = line_no_
      AND   cod.rel_no = rel_no_
      AND   cod.line_item_no = line_item_no_
      AND   cod.qty_invoiced > 0
      AND   cod.component_invoice_flag = 'N'
      ORDER BY cod.deliv_no;
   -- 126305, end  
   
   PROCEDURE Update_Ref_Quantities__ (
      company_              IN VARCHAR2,
      deliv_no_             IN NUMBER,
      item_id_              IN NUMBER,
      outstanding_sales_id_ IN NUMBER,
      qty_to_invoice_       IN NUMBER )
   IS
   BEGIN
      -- Remove Reference to Delivery and invoice
      Cust_Delivery_Inv_Ref_API.Remove_Reference(deliv_no_,
                                                 company_,
                                                 invoice_id_,
                                                 item_id_);            
      -- Updating the outstanding sales tab.
      Outstanding_Sales_API.Modify_Invoice_Reference(outstanding_sales_id_, NULL, NULL);
      -- Modify qty_invoiced for the consignment stocks
      Customer_Order_Delivery_API.Modify_Qty_Invoiced(deliv_no_, qty_to_invoice_);
   END Update_Ref_Quantities__;       

BEGIN
   IF consignment_stock_ = 'CONSIGNMENT STOCK' THEN
      FOR next_ IN get_consumed_qty_to_invoice LOOP
         
         IF (prev_deliv_no_ = next_.deliv_no) THEN
               deliv_qty_invoiced_ := deliv_qty_invoiced_ - next_.qty_expected;
         ELSE
               deliv_qty_invoiced_ := next_.deliv_qty_invoiced - next_.qty_expected;
               prev_deliv_no_ := next_.deliv_no;
         END IF;
         
         Update_Ref_Quantities__( next_.company,
                                  next_.deliv_no,
                                  next_.item_id,
                                  next_.outstanding_sales_id,
                                  deliv_qty_invoiced_ );
      END LOOP;
   ELSE
      IF (line_item_no_ > 0) THEN
         FOR comp_rec_ IN  get_comp_invoiced_delivs(order_no_, line_no_,  rel_no_, line_item_no_) LOOP    
            Customer_Order_Delivery_API.Modify_Component_Invoice_Flag(comp_rec_.deliv_no, Invoice_Package_Component_API.Decode('Y'));
            Customer_Order_Delivery_API.Modify_Qty_Invoiced(comp_rec_.deliv_no, 0);
         END LOOP;   
      ELSE
         FOR next_ IN get_qty_to_invoice LOOP
            Update_Ref_Quantities__( next_.company,
                                     next_.deliv_no,
                                     next_.item_id,
                                     next_.outstanding_sales_id,
                                     next_.qty_to_invoice - next_.qty_invoiced ); 
         END LOOP;
      END IF;
   END IF;
END Unconsume_Deliveries___;


PROCEDURE Remove_Invoice_Associations___ (
   company_       IN VARCHAR2,
   invoice_id_    IN NUMBER,
   remove_inv_    IN BOOLEAN,
   invoice_type_  IN VARCHAR2 DEFAULT NULL,
   pre_cre_inv_   IN VARCHAR2 DEFAULT NULL )
IS
BEGIN
   -- Remove project connections of invoice lines
   Remove_Project_Connections___(company_, invoice_id_);
   -- Remove the Statistics entry if there is any.
   Cust_Ord_Invo_Stat_API.Remove_Invoice_Statistics(company_, invoice_id_);
   
   -- Remove data if in REB_AGGR_LINE_CNTRL_TYPE_TMP. 
   Clear_Reb_Aggr_Tmp_Tabs___(Customer_Order_Inv_Head_API.Get_Aggregation_No(company_, invoice_id_), NULL, 1);
   
   IF (NOT remove_inv_ AND Company_Order_Info_API.Get_Prepayment_Inv_Method_Db(company_) = 'PREPAYMENT_BASED_INVOICE') OR
      (remove_inv_ AND invoice_type_ = pre_cre_inv_) THEN
      Unconsume_Prepaym_Inv_Lines___(company_,invoice_id_, remove_inv_);
   END IF;
END Remove_Invoice_Associations___; 


PROCEDURE Get_Connected_Orders___ (
   order_no_arr_  IN OUT Order_No_Array,
   company_       IN VARCHAR2,
   invoice_id_    IN NUMBER )
IS
   CURSOR get_connected_orders IS
      SELECT DISTINCT order_no
      FROM customer_order_inv_item
      WHERE company  = company_
      AND invoice_id = invoice_id_;   
BEGIN
   OPEN get_connected_orders;
   FETCH get_connected_orders BULK COLLECT INTO order_no_arr_;
   CLOSE get_connected_orders;
END Get_Connected_Orders___;

PROCEDURE Get_Ref_Inv_Curr_Rate_Type___(    
   currency_rate_type_    IN OUT VARCHAR2,  
   company_               IN VARCHAR2,
   customer_no_           IN VARCHAR2,
   ivc_head_rec_          IN ivc_head_rec,
   use_ref_inv_curr_rate_ IN NUMBER DEFAULT 0)
IS 
   ref_invoice_id_     NUMBER;
BEGIN
   IF (use_ref_inv_curr_rate_ = 1 AND ivc_head_rec_.number_reference IS NOT NULL) THEN  
                
      ref_invoice_id_ := Customer_Order_Inv_Head_API.Get_Invoice_Id_By_No(company_, 
                                                                          ivc_head_rec_.number_reference,
                                                                          ivc_head_rec_.series_reference);
      currency_rate_type_ := Customer_Order_Inv_Head_API.Get_Currency_Rate_Type(company_, ref_invoice_id_);                                           
   ELSE
      IF (currency_rate_type_ IS NULL) THEN
         currency_rate_type_ := Invoice_Library_API.Get_Default_Currency_Type(company_, 'CUSTOMER', customer_no_);
      END IF;
   END IF;
END Get_Ref_Inv_Curr_Rate_Type___;  

PROCEDURE Create_Order_History___ (
   company_       IN VARCHAR2,
   invoice_id_    IN NUMBER,
   cancelled_     IN BOOLEAN,
   order_no_arr_  IN Order_No_Array,
   invoice_no_    IN VARCHAR2 DEFAULT NULL,
   invoice_type_  IN VARCHAR2 DEFAULT NULL,
   cor_inv_type_  IN VARCHAR2 DEFAULT NULL,
   pre_deb_inv_   IN VARCHAR2 DEFAULT NULL,
   pre_cre_inv_   IN VARCHAR2 DEFAULT NULL,
   col_inv_type_  IN VARCHAR2 DEFAULT NULL)
IS
   msg_           VARCHAR2(200);
   order_no_      customer_order_line.order_no%TYPE;
BEGIN 
   -- Creates order history with different messages for different invoice types
   IF order_no_arr_.COUNT > 0 THEN
      IF (invoice_type_ IN (cor_inv_type_, col_inv_type_)) THEN
         msg_ := Language_SYS.Translate_Constant(lu_name_, 'CORCANINV: Correction Invoice :P1 removed', NULL, invoice_no_);
      ELSIF (invoice_type_ IN (pre_deb_inv_, pre_cre_inv_ )) THEN
         msg_ := Language_SYS.Translate_Constant(lu_name_, 'PRECANINV: Prepayment Invoice :P1 removed', NULL, invoice_no_);
      ELSIF (cancelled_) THEN
         msg_ := Get_Prel_Cancel_Hist_Text___(company_,
                                              invoice_id_,
                                              invoice_type_);
      ELSE   
         msg_ := Language_SYS.Translate_Constant(lu_name_, 'CRECANINV: Credit Invoice :P1 removed', NULL, invoice_no_);
      END IF;
      FOR row_index IN order_no_arr_.FIRST..order_no_arr_.LAST LOOP
         order_no_ := order_no_arr_(row_index);
         IF (order_no_ IS NOT NULL) THEN
            Customer_Order_History_API.New(order_no_, msg_);
         END IF;
      END LOOP;
   END IF;

END Create_Order_History___; 


FUNCTION Get_Prel_Cancel_Hist_Text___ (
   company_       IN VARCHAR2,
   invoice_id_    IN NUMBER,
   invoice_type_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   msg_           VARCHAR2(200);   
   inv_rec_       Invoice_API.Public_Rec;
BEGIN   
   inv_rec_ := Invoice_API.Get(company_, invoice_id_);
   -- Both Invoice Id and Invoice Number are the same in Preliminary stage.
   IF (invoice_type_ IS NOT NULL) AND (invoice_type_ = 'CUSTCOLDEB') THEN
      msg_ := Language_SYS.Translate_Constant(lu_name_, 'CANPRECOLINV: Collective invoice :P1 :P2 cancelled', NULL, inv_rec_.series_id, inv_rec_.invoice_no);
   ELSIF (invoice_type_ IS NOT NULL) AND (invoice_type_ = 'SELFBILLDEB') THEN
      msg_ := Language_SYS.Translate_Constant(lu_name_, 'CANPRESELFINV: Self-billing invoice :P1 :P2 cancelled', NULL, inv_rec_.series_id, inv_rec_.invoice_no);
   ELSIF (invoice_type_ IS NOT NULL) AND (invoice_type_ = Company_Def_Invoice_Type_API.Get_Def_Adv_Co_Dr_Inv_Type(company_)) THEN
      msg_ := Language_SYS.Translate_Constant(lu_name_, 'CANPREADVINV: Advance invoice :P1 :P2 cancelled', NULL, inv_rec_.series_id, inv_rec_.invoice_no);
   ELSE   
      msg_ := Language_SYS.Translate_Constant(lu_name_, 'CANPREINV: Invoice :P1 :P2 cancelled', NULL, inv_rec_.series_id, inv_rec_.invoice_no);
   END IF;
   RETURN msg_;
END Get_Prel_Cancel_Hist_Text___;


-- Get_Js_Invoice_State_Db___
--   Returns the Jinsui invoice status depending on the input Jinsui invoice value.
FUNCTION Get_Js_Invoice_State_Db___ (
   jinsui_invoice_db_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (jinsui_invoice_db_ = 'TRUE') THEN
      RETURN 'OJS';
   END IF;
   RETURN 'NJS';
END Get_Js_Invoice_State_Db___;


-- Lock_Rma_Head___
--   Lock the RMA header while it is being processed.
PROCEDURE Lock_Rma_Head___ (
   rma_no_ IN NUMBER )
IS
BEGIN
   -- Lock the RMA Header while it is being processed.
   Return_Material_API.Lock_By_Keys__(rma_no_);
END Lock_Rma_Head___;


-- Calculate_Prepaym_Amounts___
--   This method is used to calculate the consumption amounts.
--   Also in this method a new record will be inserted to the customer
--   prepayment consumption table and prepayment lines will be added to
--   the customer order debit invoice.
PROCEDURE Calculate_Prepaym_Amounts___ (
   deb_inv_line_fully_consumed_ IN OUT BOOLEAN,
   remaining_deb_inv_line_amt_  IN OUT NUMBER,
   company_                     IN VARCHAR2,
   prepaym_invoice_id_          IN NUMBER,
   prepaym_item_id_             IN NUMBER,
   deb_invoice_id_              IN NUMBER,
   deb_item_id_                 IN NUMBER,
   order_no_                    IN VARCHAR2,
   prepaym_vat_code_            IN VARCHAR2,
   deb_inv_gross_curr_amt_      IN NUMBER,
   available_to_consume_        IN NUMBER)
IS
   tax_percentage_                 NUMBER;
   net_curr_amt_                   NUMBER;
   vat_curr_amt_                   NUMBER;
   new_attr_                       VARCHAR2(32000);
   prepay_line_attr_               VARCHAR2(32000);
   consumed_amount_                NUMBER;
   prepay_invoice_no_              VARCHAR2(50);
   prepay_invoice_series_id_       VARCHAR2(20);
   pre_pay_inv_rec_                Customer_Order_Inv_Item_API.Public_Rec;
   currency_rounding_              NUMBER;
   identity_                       VARCHAR2(20);
BEGIN
   IF remaining_deb_inv_line_amt_ > 0 THEN
      IF (remaining_deb_inv_line_amt_ <= available_to_consume_) THEN
         consumed_amount_ := remaining_deb_inv_line_amt_;
         remaining_deb_inv_line_amt_ := 0;
         deb_inv_line_fully_consumed_ := TRUE;
      ELSE
         consumed_amount_ := available_to_consume_;
         remaining_deb_inv_line_amt_ := remaining_deb_inv_line_amt_ - available_to_consume_;
      END IF;
   ELSIF (available_to_consume_ < deb_inv_gross_curr_amt_) THEN
      consumed_amount_ := available_to_consume_;
      remaining_deb_inv_line_amt_ := deb_inv_gross_curr_amt_ - available_to_consume_;
   ELSE
      consumed_amount_ := deb_inv_gross_curr_amt_;
      deb_inv_line_fully_consumed_ := TRUE;
   END IF;

   -- Inserting a record to the cust_prepaym_consumption_tab
   Client_SYS.Clear_Attr(new_attr_);
   Client_SYS.Add_To_Attr('COMPANY', company_, new_attr_);
   Client_SYS.Add_To_Attr('PREPAYMENT_INVOICE_ID', prepaym_invoice_id_, new_attr_);
   Client_SYS.Add_To_Attr('PREPAYMENT_INVOICE_ITEM', prepaym_item_id_, new_attr_);
   Client_SYS.Add_To_Attr('INVOICE_ID', deb_invoice_id_, new_attr_);
   Client_SYS.Add_To_Attr('ITEM_ID', deb_item_id_, new_attr_);
   Client_SYS.Add_To_Attr('CONSUMED_AMOUNT', consumed_amount_, new_attr_);

   Cust_Prepaym_Consumption_API.New(new_attr_);
   currency_rounding_   := Currency_Code_API.Get_Currency_Rounding(company_, Customer_Order_Inv_Head_API.Get_Currency(company_, deb_invoice_id_));

   tax_percentage_ := Source_Tax_Item_API.Get_Total_Tax_Percentage(company_, Tax_Source_API.DB_INVOICE, 
                                                      TO_CHAR(prepaym_invoice_id_), TO_CHAR(prepaym_item_id_), '*', '*', '*');
   IF (Customer_Order_Inv_Head_API.Get_Use_Price_Incl_Tax_Db(company_, prepaym_invoice_id_) = 'TRUE'
       AND Customer_Order_API.Get_Gross_Amount_Per_Tax_Code(order_no_,prepaym_vat_code_) = consumed_amount_) THEN
      -- When using Price Incl Tax and Prepayment invoice is for whole order amount then fetch vat, net amounts from Prepayment invoice
      identity_               := Customer_Order_API.Get_Customer_No(order_no_);
      vat_curr_amt_           := Customer_Order_Inv_Item_API.Get_Vat_Curr_Amount(company_, prepaym_invoice_id_, prepaym_item_id_, Party_Type_API.Decode('CUSTOMER'),identity_ );
      net_curr_amt_           := consumed_amount_ - vat_curr_amt_;
   ELSE
      net_curr_amt_           := ROUND((consumed_amount_ / (100 + tax_percentage_)*100), currency_rounding_);
      vat_curr_amt_           := ROUND((consumed_amount_ / (100 + tax_percentage_)*tax_percentage_), currency_rounding_);
   END IF;
   prepay_invoice_no_         := Customer_Order_Inv_Head_Api.Get_Invoice_No(company_,NULL,NULL,prepaym_invoice_id_);
   prepay_invoice_series_id_  := Customer_Order_Inv_Head_Api.Get_Series_Id(company_,NULL,NULL,prepaym_invoice_id_);

   pre_pay_inv_rec_ := Customer_Order_Inv_Item_Api.Get(company_, prepaym_invoice_id_, prepaym_item_id_);

   -- Creating the prepayment line in the new invoice with negative amounts
   Client_SYS.Clear_Attr(prepay_line_attr_);
   Client_SYS.Add_To_Attr('COMPANY', company_, prepay_line_attr_);
   Client_SYS.Add_To_Attr('INVOICE_ID', deb_invoice_id_, prepay_line_attr_);
   Client_SYS.Add_To_Attr('ORDER_NO', order_no_, prepay_line_attr_);
   Client_SYS.Add_To_Attr('FEE_CODE', prepaym_vat_code_, prepay_line_attr_);
   Client_SYS.Add_To_Attr('FEE_PERCENTAGE', tax_percentage_, prepay_line_attr_);
   Client_SYS.Add_To_Attr('NET_CURR_AMOUNT', (-1)*net_curr_amt_, prepay_line_attr_);
   Client_SYS.Add_To_Attr('TAX_CURR_AMOUNT', (-1)*vat_curr_amt_, prepay_line_attr_);
   Client_SYS.Add_To_Attr('GROSS_CURR_AMOUNT', (-1)*consumed_amount_, prepay_line_attr_);
   Client_SYS.Add_To_Attr('DESCRIPTION', pre_pay_inv_rec_.description, prepay_line_attr_);
   Client_SYS.Add_To_Attr('PREPAY_INVOICE_NO', prepay_invoice_no_, prepay_line_attr_);
   Client_SYS.Add_To_Attr('PREPAY_INVOICE_SERIES_ID', prepay_invoice_series_id_, prepay_line_attr_);
   -- gelr:delivery_types_in_pbi, begin
   Client_SYS.Add_To_Attr('DELIV_TYPE_ID', pre_pay_inv_rec_.deliv_type_id, prepay_line_attr_);
   -- gelr:delivery_types_in_pbi, end
   Customer_Order_Inv_Item_API.Create_Prepayment_Inv_Line__(prepay_line_attr_);
END Calculate_Prepaym_Amounts___;


-- Consume_Prepaym_Inv_Lines___
--   This method is used to find the debit invoice lines and the relevent
--   prepayment lines. If prepayment consumption is possible calls method
PROCEDURE Consume_Prepaym_Inv_Lines___ (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER,
   order_no_   IN VARCHAR2 )
IS
   prepay_deb_inv_type_             VARCHAR2(20);
   total_amt_consumed_              NUMBER := 0;
   available_to_consume_            NUMBER;
   deb_inv_line_fully_consumed_     BOOLEAN := FALSE;
   remaining_deb_inv_line_amt_      NUMBER;
   gross_amt_consumed_              NUMBER := 0;
   
   -- gelr:delivery_types_in_pbi, Renames get_sales_by_vat as get_sales_by_vat_and_delivery_type
   --      Added deliv_type_id to the SELECT Statement and ORDER BY Clause
   CURSOR get_sales_by_vat_and_delivery_type IS
      SELECT vat_code, (net_curr_amount + vat_curr_amount) curr_amount, gross_curr_amount, item_id, deliv_type_id
      FROM   CUSTOMER_ORDER_INV_ITEM
      WHERE  company    = company_
      AND    invoice_id = invoice_id_
      AND    prepay_invoice_no IS NULL
      ORDER BY vat_code, deliv_type_id, item_id;

   -- gelr:delivery_types_in_pbi, begin
   CURSOR get_prepaym_lines_by_vat_deliv(vat_code_ IN VARCHAR2, deliv_type_ IN VARCHAR2) IS
      SELECT ii.*
      FROM   CUSTOMER_ORDER_INV_ITEM ii, CUSTOMER_ORDER_INV_HEAD ih
      WHERE  ih.company = ii.company
      AND    ih.invoice_id = ii.invoice_id
      AND    ih.company = company_
      AND    ih.creators_reference = order_no_
      AND    ih.invoice_type = prepay_deb_inv_type_
      AND    ih.objstate NOT IN ( 'Preliminary', 'Printed', 'Cancelled' )
      AND    ii.vat_code = vat_code_
      AND    (ii.deliv_type_id = deliv_type_ OR (deliv_type_ IS NULL AND ii.deliv_type_id IS NULL))
      AND    ii.gross_curr_amount > (SELECT NVL(SUM(cpc.consumed_amount),0)
                                     FROM   CUST_PREPAYM_CONSUMPTION_TAB cpc
                                     WHERE  cpc.company = ii.company
                                     AND    cpc.prepayment_invoice_id = ii.invoice_id
                                     AND    cpc.prepayment_invoice_item = ii.item_id)
      ORDER BY ii.payment_date ASC, ii.invoice_id, ii.item_id;
   -- gelr:delivery_types_in_pbi, end
   
   CURSOR get_prepaym_lines_by_vat( vat_code_ VARCHAR2) IS
      SELECT ii.*
      FROM   CUSTOMER_ORDER_INV_ITEM ii, CUSTOMER_ORDER_INV_HEAD ih
      WHERE  ih.company = ii.company
      AND    ih.invoice_id = ii.invoice_id
      AND    ih.company = company_
      AND    ih.creators_reference = order_no_
      AND    ih.invoice_type = prepay_deb_inv_type_
      AND    ih.objstate NOT IN ( 'Preliminary', 'Printed', 'Cancelled' )
      AND    ii.vat_code = vat_code_
      AND    ii.gross_curr_amount > (SELECT NVL(SUM(cpc.consumed_amount),0)
                                     FROM   CUST_PREPAYM_CONSUMPTION_TAB cpc
                                     WHERE  cpc.company = ii.company
                                     AND    cpc.prepayment_invoice_id = ii.invoice_id
                                     AND    cpc.prepayment_invoice_item = ii.item_id)
      ORDER BY ii.payment_date ASC, ii.invoice_id, ii.item_id;

   CURSOR get_prepaym_lines( vat_code_ VARCHAR2) IS
      SELECT ii.*
      FROM  CUSTOMER_ORDER_INV_ITEM ii, CUSTOMER_ORDER_INV_HEAD ih
      WHERE ih.company = ii.company
      AND   ih.invoice_id = ii.invoice_id
      AND   ih.company = company_
      AND   ih.creators_reference = order_no_
      AND   ih.invoice_type = prepay_deb_inv_type_
      AND   ih.objstate NOT IN ( 'Preliminary', 'Printed', 'Cancelled' )
      AND   ii.vat_code != vat_code_
      AND   ii.gross_curr_amount > (SELECT NVL(SUM(cpc.consumed_amount),0)
                                    FROM   CUST_PREPAYM_CONSUMPTION_TAB cpc
                                    WHERE  cpc.company = ii.company
                                    AND    cpc.prepayment_invoice_id = ii.invoice_id
                                    AND    cpc.prepayment_invoice_item = ii.item_id)
      ORDER BY  ii.payment_date ASC, ii.invoice_id, ii.item_id;

   CURSOR get_consumed_amt (prepaym_invoice_id_ NUMBER, prepaym_item_id_ NUMBER) IS
      SELECT NVL(SUM(cpc.consumed_amount),0)
      FROM   CUST_PREPAYM_CONSUMPTION_TAB cpc
      WHERE  cpc.company = company_
      AND    cpc.prepayment_invoice_id = prepaym_invoice_id_
      AND    cpc.prepayment_invoice_item = prepaym_item_id_;

   CURSOR get_debit_inv_consumed_amt (invoice_id_ NUMBER, item_id_ NUMBER) IS
      SELECT NVL(SUM(cpc.consumed_amount),0)
      FROM   CUST_PREPAYM_CONSUMPTION_TAB cpc
      WHERE  cpc.company = company_
      AND    cpc.invoice_id = invoice_id_
      AND    cpc.item_id = item_id_;
BEGIN
   prepay_deb_inv_type_ := Company_Def_Invoice_Type_API.Get_Def_Co_Prepay_Deb_Inv_Type (company_);

   -- gelr:delivery_types_in_pbi, begin
   -- First consume prepayment lines which are having the same vat_code and delivery type as debit lines. 
   FOR inv_sales_rec_ IN get_sales_by_vat_and_delivery_type LOOP
      remaining_deb_inv_line_amt_  := -1;
      deb_inv_line_fully_consumed_ := FALSE;

      FOR prepaym_lines_rec_ IN get_prepaym_lines_by_vat_deliv(inv_sales_rec_.vat_code, inv_sales_rec_.deliv_type_id) LOOP
         OPEN  get_consumed_amt(prepaym_lines_rec_.invoice_id, prepaym_lines_rec_.item_id);
         FETCH get_consumed_amt INTO total_amt_consumed_;
         CLOSE get_consumed_amt;

         available_to_consume_ := prepaym_lines_rec_.gross_curr_amount - total_amt_consumed_;

         IF (available_to_consume_ > 0 ) THEN
            IF (NOT deb_inv_line_fully_consumed_) THEN
               Calculate_Prepaym_Amounts___(deb_inv_line_fully_consumed_, remaining_deb_inv_line_amt_, company_, prepaym_lines_rec_.invoice_id,
                                            prepaym_lines_rec_.item_id, invoice_id_, inv_sales_rec_.item_id, order_no_,
                                            prepaym_lines_rec_.vat_code, inv_sales_rec_.gross_curr_amount, available_to_consume_);
            END IF;
         END IF;
      END LOOP;
   END LOOP;
   -- gelr:delivery_types_in_pbi, end
   
   -- get debit invoice lines to be consumed
   -- This will consume prepayment lines which are having the same vat_code as debit lines. 
   -- gelr:delivery_types_in_pbi, Renamed get_sales_by_vat as get_sales_by_vat_and_delivery_type
   FOR inv_sales_rec_ IN get_sales_by_vat_and_delivery_type LOOP
      deb_inv_line_fully_consumed_ := FALSE;
      remaining_deb_inv_line_amt_  := -1;

      -- gelr:delivery_types_in_pbi, begin
      OPEN  get_debit_inv_consumed_amt(invoice_id_, inv_sales_rec_.item_id);
      FETCH get_debit_inv_consumed_amt INTO gross_amt_consumed_;
      CLOSE get_debit_inv_consumed_amt;

         remaining_deb_inv_line_amt_ := inv_sales_rec_.gross_curr_amount - gross_amt_consumed_;         
      
      IF (remaining_deb_inv_line_amt_ != 0) THEN      
      -- gelr:delivery_types_in_pbi, end
         FOR prepaym_lines_rec_ IN get_prepaym_lines_by_vat(inv_sales_rec_.vat_code) LOOP
            OPEN  get_consumed_amt(prepaym_lines_rec_.invoice_id, prepaym_lines_rec_.item_id);
            FETCH get_consumed_amt INTO total_amt_consumed_;
            CLOSE get_consumed_amt;

            available_to_consume_ := prepaym_lines_rec_.gross_curr_amount - total_amt_consumed_;

            IF (available_to_consume_ > 0 ) THEN
               IF (NOT deb_inv_line_fully_consumed_) THEN
                  Calculate_Prepaym_Amounts___(deb_inv_line_fully_consumed_, remaining_deb_inv_line_amt_, company_, prepaym_lines_rec_.invoice_id,
                                               prepaym_lines_rec_.item_id, invoice_id_, inv_sales_rec_.item_id, order_no_,
                                               prepaym_lines_rec_.vat_code, inv_sales_rec_.gross_curr_amount, available_to_consume_);
               END IF;
            END IF;
         END LOOP;
      END IF;   -- gelr:delivery_types_in_pbi
   END LOOP;

   -- When the prepayment lines with the same tax code are fully consumed and if the current debit line is not fully consumed, 
   -- we'll try to consume the prepayment lines with different tax codes.
   -- gelr:delivery_types_in_pbi, Renamed get_sales_by_vat as get_sales_by_vat_and_delivery_type
   FOR inv_sales_rec_ IN get_sales_by_vat_and_delivery_type LOOP
      deb_inv_line_fully_consumed_ := FALSE;

      OPEN  get_debit_inv_consumed_amt(invoice_id_, inv_sales_rec_.item_id);
      FETCH get_debit_inv_consumed_amt INTO gross_amt_consumed_;
      CLOSE get_debit_inv_consumed_amt;

      remaining_deb_inv_line_amt_ := inv_sales_rec_.gross_curr_amount - gross_amt_consumed_;
         
      IF ( remaining_deb_inv_line_amt_ != 0 ) THEN
         FOR prepaym_lines_rec_ IN get_prepaym_lines(inv_sales_rec_.vat_code) LOOP
            OPEN  get_consumed_amt(prepaym_lines_rec_.invoice_id, prepaym_lines_rec_.item_id);
            FETCH get_consumed_amt INTO total_amt_consumed_;
            CLOSE get_consumed_amt;

            available_to_consume_ := prepaym_lines_rec_.gross_curr_amount - total_amt_consumed_;

            IF (available_to_consume_ > 0 ) THEN
               IF (NOT deb_inv_line_fully_consumed_) THEN
                  Calculate_Prepaym_Amounts___(deb_inv_line_fully_consumed_, remaining_deb_inv_line_amt_, company_, prepaym_lines_rec_.invoice_id,
                                               prepaym_lines_rec_.item_id, invoice_id_, inv_sales_rec_.item_id, order_no_,
                                               prepaym_lines_rec_.vat_code, inv_sales_rec_.gross_curr_amount, available_to_consume_);
               END IF;
            END IF;
         END LOOP;
      END IF;
   END LOOP; 
END Consume_Prepaym_Inv_Lines___;


-- Unconsume_Prepaym_Inv_Lines___
--   This method will delete the lines from Cust_Prepaym_Consumption_Tab
--   for a particular invoice id and will also delete the relevant
--   prepayment invoice lines.
PROCEDURE Unconsume_Prepaym_Inv_Lines___ (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER,
   remove_inv_ IN BOOLEAN )
IS
   info_             VARCHAR2(2000);

   CURSOR get_lines_to_unconsume IS
      SELECT *
      FROM  CUST_PREPAYM_CONSUMPTION_TAB
      WHERE company = company_
      AND   invoice_id = invoice_id_;

   CURSOR get_prepay_lines IS
      SELECT *
      FROM  CUSTOMER_ORDER_INV_ITEM
      WHERE company = company_
      AND   invoice_id = invoice_id_
      AND   prel_update_allowed = 'FALSE';
BEGIN
   FOR lines_to_unconsume_ IN get_lines_to_unconsume LOOP
      Cust_Prepaym_Consumption_API.Remove(lines_to_unconsume_.company,
                                          lines_to_unconsume_.prepayment_invoice_id,
                                          lines_to_unconsume_.prepayment_invoice_item,
                                          lines_to_unconsume_.invoice_id,
                                          lines_to_unconsume_.item_id );
   END LOOP;
   
   IF remove_inv_ THEN   
      FOR prepay_lines_rec_ IN get_prepay_lines LOOP
         Invoice_Item_API.Remove(info_, prepay_lines_rec_.objid, prepay_lines_rec_.objversion, 'DO');
      END LOOP;
   END IF;
END Unconsume_Prepaym_Inv_Lines___;


PROCEDURE Get_Rebate_Info___ (
   sales_part_rebate_group_ OUT VARCHAR2,
   assortment_id_           OUT VARCHAR2,
   assortment_node_id_      OUT VARCHAR2,
   company_                 IN  VARCHAR2,
   contract_                IN  VARCHAR2,
   customer_no_             IN  VARCHAR2,
   catalog_no_              IN  VARCHAR2 )
IS
   hierarchy_id_                  VARCHAR2(10);
   customer_parent_               CUSTOMER_ORDER_TAB.customer_no%TYPE;
   valid_line_                    BOOLEAN := FALSE;
   hierarchy_rec_                 Cust_Hierarchy_Rebate_Attr_API.Public_Rec;
   cust_agreement_list_           Rebate_Agreement_API.Agreement_Info_List;
   agreement_rec_                 Rebate_Agreement_API.Public_Rec;

BEGIN
   Rebate_Agreement_Receiver_API.Get_Active_Agreement(cust_agreement_list_, customer_no_, company_, SYSDATE);
   sales_part_rebate_group_ := Sales_Part_API.Get_Sales_Part_Rebate_Group(contract_, catalog_no_);
   
   IF cust_agreement_list_.COUNT > 0 THEN
      FOR i_ IN 1 .. cust_agreement_list_.COUNT LOOP
         agreement_rec_    := Rebate_Agreement_API.Get(cust_agreement_list_(i_).agreement_id);
         assortment_id_    := agreement_rec_.assortment_id;
         IF assortment_id_ IS NOT NULL AND valid_line_ = FALSE THEN
            assortment_node_id_ := Assortment_Structure_API.Get_Parent_On_Level(assortment_id_,
                                                                                 agreement_rec_.structure_level,
                                                                                 catalog_no_);
            valid_line_ := Rebate_Agreement_Assort_API.Has_Valid_Deal(cust_agreement_list_(i_).agreement_id, 
                                                                        assortment_id_, 
                                                                        assortment_node_id_);                                                                     
         END IF; 
      END LOOP;    
   END IF; 
   
   IF valid_line_ = FALSE THEN
      customer_parent_ := customer_no_;
      WHILE NOT valid_line_ LOOP
         hierarchy_id_     := Cust_Hierarchy_Struct_API.Get_Hierarchy_Id(customer_parent_);
         customer_parent_  := Cust_Hierarchy_Struct_API.Get_Parent_Cust(hierarchy_id_, customer_parent_);
         cust_agreement_list_.DELETE;
         Rebate_Agreement_Receiver_API.Get_Active_Agreement(cust_agreement_list_, customer_parent_, company_, trunc(SYSDATE));
         -- Exit when the top of the hiearchy is reached
         EXIT WHEN customer_parent_ IS NULL;
         IF cust_agreement_list_.COUNT > 0 THEN
            FOR i_ IN 1 .. cust_agreement_list_.COUNT LOOP
               agreement_rec_    := Rebate_Agreement_API.Get(cust_agreement_list_(i_).agreement_id);
               assortment_id_    := agreement_rec_.assortment_id;
               IF assortment_id_ IS NOT NULL AND valid_line_ = FALSE THEN
                  assortment_node_id_ := Assortment_Structure_API.Get_Parent_On_Level(assortment_id_,
                                                                                       agreement_rec_.structure_level,
                                                                                       catalog_no_);
                  valid_line_ := Rebate_Agreement_Assort_API.Has_Valid_Deal(cust_agreement_list_(i_).agreement_id, 
                                                                              assortment_id_, 
                                                                              assortment_node_id_);                                                                     
               END IF; 
            END LOOP;
         END IF; 
      END LOOP;
   END IF;
   
   IF assortment_node_id_ IS NULL THEN
      assortment_id_ := NULL;
   END IF;
      
   IF valid_line_ = FALSE THEN
      -- Does the customer belong to a hierarchy?
      hierarchy_id_ := Cust_Hierarchy_Struct_API.Get_Hierarchy_Id(customer_no_);
      IF hierarchy_id_ IS NOT NULL THEN
         hierarchy_rec_      := Cust_Hierarchy_Rebate_Attr_API.Get(hierarchy_id_, company_);
         assortment_id_      := hierarchy_rec_.assortment_id;
         assortment_node_id_ := Assortment_Structure_API.Get_Parent_On_Level(assortment_id_,
                                                                             hierarchy_rec_.structure_level,
                                                                             catalog_no_);
      END IF;
      -- If the customer doesn't belong to a hierarchy or the hierarchy is not connected to an assortment
      IF assortment_node_id_ IS NULL THEN
         assortment_id_ := NULL;
      END IF;
   END IF; 
END Get_Rebate_Info___;


-- Create_Shipment_Charge_Item___
--   Create Shipment Invoice Charge Item in INVOICE module and update depending order_line.
PROCEDURE Create_Shipment_Charge_Item___ (
   item_id_             IN OUT NUMBER,
   invoice_id_          IN     NUMBER,
   shipment_id_         IN     VARCHAR2,
   charge_seq_no_       IN     NUMBER, 
   taransfer_ext_tax_   IN     BOOLEAN DEFAULT TRUE)
IS
   tax_code_               Sales_Charge_Type_Tab.Tax_Code%TYPE;
   charge_rec_             Sales_Charge_Type_API.Public_Rec;
   shipment_rec_           Shipment_API.Public_Rec; 
   shipment_charge_rec_    Shipment_Freight_Charge_API.Public_Rec;
   company_                VARCHAR2(20);
BEGIN
   
   shipment_rec_ := Shipment_API.Get(shipment_id_);
   shipment_charge_rec_ := Shipment_Freight_Charge_API.Get(shipment_id_, charge_seq_no_);
   charge_rec_ := Sales_Charge_Type_API.Get(shipment_rec_.contract, shipment_charge_rec_.charge_type);
   
   company_  := Site_API.Get_Company(shipment_rec_.contract);
   tax_code_ := shipment_charge_rec_.fee_code;
   
   Customer_Order_Inv_Item_API.Create_Invoice_Item(
      item_id_, invoice_id_, company_,
      null,                            -- order_no_
      null,                            -- line_no_
      null,                            -- rel_no_
      null,                            -- line_item_no_
      shipment_charge_rec_.contract,
      shipment_charge_rec_.charge_type,      -- charge_type
      charge_rec_.charge_type_desc,    -- charge_type_description
      charge_rec_.sales_unit_meas,
      1,                               -- price_conv_factor
      shipment_charge_rec_.charge_amount,    -- sale_unit_price
      shipment_charge_rec_.charge_amount_incl_tax, -- sale_unit_price_incl_tax
      0,                               -- discount
      0,                               -- order_discount
      tax_code_,
      NULL,
      shipment_charge_rec_.charged_qty,
      NULL,
      NULL,                            -- delivery_type
      shipment_charge_rec_.charged_qty,
      charge_seq_no_,
      charge_rec_.charge_group,
      NULL,
      'TRUE',
      delivery_address_id_ => shipment_rec_.receiver_addr_id,
      shipment_id_ => shipment_id_);
   

   IF taransfer_ext_tax_ THEN 
      Tax_Handling_Order_Util_API.Transfer_Tax_lines(company_, 
                                                     Tax_Source_API.DB_SHIPMENT_FREIGHT_CHARGE,
                                                     shipment_id_,
                                                     charge_seq_no_,
                                                     '*',
                                                     '*',
                                                     '*',
                                                     Tax_Source_API.DB_INVOICE,
                                                     invoice_id_,
                                                     item_id_,
                                                     '*',
                                                     '*',
                                                     '*',
                                                     'TRUE',
                                                     'TRUE');
   END IF;
   
END Create_Shipment_Charge_Item___;


-- Check_Pre_Created_Cre_Inv___
--   Checks whether the given invoice id is within the invoice id table records
FUNCTION Check_Pre_Created_Cre_Inv___(
   inv_id_tab_ IN Invoice_Id_Tab,
   invoice_id_ IN NUMBER ) RETURN BOOLEAN
IS
   inv_id_ NUMBER;
BEGIN
   FOR index_ IN 0..inv_id_tab_.COUNT-1 LOOP
      inv_id_ := inv_id_tab_ (index_);
      IF (inv_id_ = invoice_id_) THEN
         RETURN TRUE;
      END IF;
   END LOOP;
   RETURN FALSE;
END Check_Pre_Created_Cre_Inv___;


-- Create_Credit_Invoice_Rec___
--   This method assigns values for customer reference, label note, ship via description,
--   delivery terms description and forward agent id values for the credit invoice record.
PROCEDURE Create_Credit_Invoice_Rec___ (
   ivc_rec_          IN OUT ivc_head_rec,
   rma_no_           IN     NUMBER,
   order_no_         IN     VARCHAR2,
   debit_invoice_no_ IN     VARCHAR2,
   debit_series_id_  IN     VARCHAR2 )
IS
   rma_rec_          Return_Material_API.Public_Rec;
   order_rec_        Customer_Order_API.Public_Rec;
   company_          VARCHAR2(20);
   your_reference_   CUSTOMER_ORDER_INV_HEAD.your_reference%TYPE;
   ship_via_         CUSTOMER_ORDER_INV_HEAD.ship_via%TYPE;
   forward_agent_id_ CUSTOMER_ORDER_INV_HEAD.forward_agent_id%TYPE;
   label_note_       CUSTOMER_ORDER_INV_HEAD.label_note%TYPE;
   delivery_terms_   CUSTOMER_ORDER_INV_HEAD.delivery_terms%TYPE;
   del_terms_location_  CUSTOMER_ORDER_INV_HEAD.del_terms_location%TYPE;
   -- gelr:invoice_reason, begin
   invoice_reason_id_   CUSTOMER_ORDER_INV_HEAD.invoice_reason_id%TYPE;
   -- gelr:invoice_reason, end

   CURSOR get_invoice_details  IS
      SELECT your_reference, ship_via, forward_agent_id, label_note, delivery_terms, del_terms_location, invoice_reason_id
      FROM   CUSTOMER_ORDER_INV_HEAD
      WHERE  invoice_no = debit_invoice_no_
      AND    company = company_
      AND    series_id = debit_series_id_;  
BEGIN
   rma_rec_ := Return_Material_API.Get(rma_no_);

   IF ( debit_invoice_no_ IS NOT NULL ) THEN
      company_ := Site_API.Get_Company(rma_rec_.contract);
      OPEN  get_invoice_details;
      FETCH get_invoice_details INTO your_reference_, ship_via_, forward_agent_id_, label_note_, delivery_terms_, del_terms_location_, invoice_reason_id_;
      CLOSE get_invoice_details;
      IF (ivc_rec_.cust_ref IS NULL) THEN
         ivc_rec_.cust_ref             := your_reference_;
      END IF;
      ivc_rec_.label_note              := label_note_;
      ivc_rec_.ship_via_desc           := ship_via_;
      ivc_rec_.delivery_terms_desc     := delivery_terms_;
      ivc_rec_.del_terms_location      := del_terms_location_;
      ivc_rec_.forward_agent_id        := forward_agent_id_;
      -- gelr:invoice_reason, begin
      ivc_rec_.invoice_reason_id       := invoice_reason_id_;
      -- gelr:invoice_reason, end

   ELSIF ( order_no_ IS NOT NULL ) THEN
      order_rec_:= Customer_Order_API.Get(order_no_);
      IF (ivc_rec_.cust_ref IS NULL) THEN
         ivc_rec_.cust_ref             := order_rec_.cust_ref;      
      END IF;
      ivc_rec_.label_note              := order_rec_.label_note;
      ivc_rec_.ship_via_desc := Mpccom_Ship_Via_API.Get_Description(order_rec_.ship_via_code, order_rec_.language_code);
      ivc_rec_.delivery_terms_desc := Order_Delivery_Term_API.Get_Description(order_rec_.delivery_terms, order_rec_.language_code);
      ivc_rec_.del_terms_location := order_rec_.del_terms_location;
      ivc_rec_.forward_agent_id        := order_rec_.forward_agent_id;
      -- gelr:invoice_reason, begin
      ivc_rec_.invoice_reason_id       := order_rec_.invoice_reason_id;
      -- gelr:invoice_reason, end
   ELSE
      ivc_rec_.label_note              := NULL;
      ivc_rec_.ship_via_desc           := NULL;
      ivc_rec_.delivery_terms_desc     := NULL;
      ivc_rec_.forward_agent_id        := NULL;
      -- gelr:invoice_reason, begin
      company_ := Site_API.Get_Company(rma_rec_.contract);
      ivc_rec_.invoice_reason_id       := Identity_Invoice_Info_API.Get_Invoice_Reason_Id(company_, rma_rec_.customer_no, Party_Type_API.Decode(Party_Type_API.DB_CUSTOMER));  
      -- gelr:invoice_reason, end
   END IF;
END Create_Credit_Invoice_Rec___;


PROCEDURE Remove_Project_Connections___ (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER)
IS
   CURSOR get_invoice_lines IS
      SELECT item_id, order_no, line_no, release_no, line_item_no
      FROM CUSTOMER_ORDER_INV_ITEM
      WHERE company = company_
      AND invoice_id = invoice_id_;
BEGIN
   FOR line_rec_ IN get_invoice_lines LOOP
      Customer_Order_Inv_Item_API.Remove_Project_Connection__(company_, invoice_id_, line_rec_.item_id,
                                                              line_rec_.order_no, line_rec_.line_no, 
                                                              line_rec_.release_no, line_rec_.line_item_no);
   END LOOP;
END Remove_Project_Connections___;


FUNCTION Check_Invoicable_Line___(
   company_                   IN VARCHAR2,
   tax_liability_country_db_  IN VARCHAR2,
   supply_country_db_         IN VARCHAR2,
   delivery_country_db_       IN VARCHAR2,
   tax_liability_             IN VARCHAR2,
   date_                      IN DATE) RETURN BOOLEAN
IS
    include_in_invoice_     BOOLEAN := FALSE;
    tax_liability_type_db_  VARCHAR2(20);
BEGIN
   IF (tax_liability_country_db_ IS NOT NULL) THEN
      tax_liability_type_db_ := Tax_Liability_API.Get_Tax_Liability_Type_Db(tax_liability_, tax_liability_country_db_);
      IF tax_liability_type_db_ = 'EXM' THEN 
         IF supply_country_db_ = tax_liability_country_db_ THEN
            include_in_invoice_ := TRUE;
         END IF;
      ELSE -- vat = 'Y'
         IF Tax_Liability_Countries_API.Check_Valid_Info_Exist(company_, delivery_country_db_, date_) = 'TRUE'  THEN
            -- if a tax registration exist then that line should be invoiced alond with the
            -- tax_liability_country_ same as the delivery country
            IF delivery_country_db_ = tax_liability_country_db_  THEN
               include_in_invoice_ := TRUE;
            END IF;
         ELSE
            -- if a tax registration doesn't exists then that line should be invoiced with the
            -- tax_liability_country_ same as the supply_country
            IF supply_country_db_ = tax_liability_country_db_  THEN
               include_in_invoice_ := TRUE;
            END IF;
         END IF;
      END IF;
   ELSE
      -- if the tax_liability_country_ is NULL that means, we might be calling this for normal debit invoices
      -- where filteration is not needed. OR no tax registration exists even for the supply country..
      include_in_invoice_ := TRUE;
   END IF;

   RETURN include_in_invoice_;
END Check_Invoicable_Line___;


-- Check_No_Previous_Execution___
--   This function check whether another method is "Posted" or "Executing"
--   in parallel in background jobs with the same invoice_no.
PROCEDURE Check_No_Previous_Execution___ (
   invoice_id_       IN VARCHAR2,
   invoice_no_       IN VARCHAR2,
   deferred_call_    IN VARCHAR2 )
IS
   msg_            VARCHAR2(32000);
   current_job_id_ NUMBER := NULL;
   job_id_value_   VARCHAR2(35);
   arg_tab_        Transaction_SYS.Arguments_Table;
   job_invoice_id_ VARCHAR2(12);   
BEGIN
   -- Get current job_id
   current_job_id_ := Transaction_SYS.Get_Current_Job_Id;

   -- Get current 'Posted' job arguments
   arg_tab_:= Transaction_SYS.Get_Posted_Job_Arguments(deferred_call_, NULL);
   
   IF (arg_tab_.COUNT > 0) THEN
      FOR i_ IN arg_tab_.FIRST..arg_tab_.LAST LOOP
         IF (deferred_call_ = 'INVOICE_CUSTOMER_ORDER_API.Create_Rate_Corr_Invoices__') THEN 
            job_invoice_id_ := Client_SYS.Get_Item_Value('INVOICE_ID',arg_tab_(i_).arguments_string);
         ELSE
         job_invoice_id_ := Client_SYS.Get_Item_Value('REF_INVOICE_ID',arg_tab_(i_).arguments_string);
         END IF;
         
         IF ((NVL(current_job_id_, '-1') != NVL(arg_tab_(i_).job_id, '-1')) AND (job_invoice_id_ = invoice_id_)) THEN
            Error_SYS.Record_General(lu_name_, 'SAMEORDEREXIST: The customer invoice :P1 has already been processed by another user and added to the background job :P2.', invoice_no_, TO_CHAR(arg_tab_(i_).job_id));            
         END IF;
         
         IF (job_invoice_id_ != Database_SYS.string_null_) THEN
            job_invoice_id_   := Database_SYS.string_null_;
         END IF;
      END LOOP;
   END IF;
   
   -- Get current 'Executing' job arguments
   Transaction_SYS.Get_Executing_Job_Arguments(msg_, deferred_call_);
   IF Get_Job_Arguments___(msg_, job_id_value_, invoice_id_, current_job_id_) IS NOT NULL THEN
      Error_SYS.Record_General(lu_name_, 'SAMEORDEREXIST: The customer invoice :P1 has already been processed by another user and added to the background job :P2.', invoice_no_, TO_CHAR(job_id_value_));
   END IF;  
END Check_No_Previous_Execution___;


-- Get_Job_Arguments___
--   This function returns background job ids included in JOB_ARGUMENTS string
--   msg, which belonsg to a given customer invoice.
FUNCTION Get_Job_Arguments___ (
   msg_            IN OUT VARCHAR2,
   job_id_value_   IN OUT VARCHAR2,
   invoice_id_     IN     VARCHAR2,
   current_job_id_ IN     NUMBER) RETURN NUMBER
IS
   attrib_value_   VARCHAR2(32000);
   value_          VARCHAR2(2000);   
   name_           VARCHAR2(30);
   job_id_tab_     Message_SYS.Name_Table;
   attrib_tab_     Message_SYS.Line_Table;
   job_invoice_id_ VARCHAR2(12); 
   count_          NUMBER;
   ptr_            NUMBER;
BEGIN
   Message_SYS.Get_Attributes(msg_, count_, job_id_tab_, attrib_tab_);
   FOR i_ IN 1..count_ LOOP
      job_id_value_   := job_id_tab_(i_);
      attrib_value_   := attrib_tab_(i_);

      ptr_ := NULL;
      -- Loop through the parameter list to check whether invoice_no exists
      WHILE (Client_SYS.Get_Next_From_Attr(attrib_value_, ptr_, name_, value_)) LOOP
         IF (name_ = 'REF_INVOICE_ID') THEN
            job_invoice_id_ := value_;
         END IF;

         -- Check to see if another job of this type exists
         IF ((NVL(current_job_id_, '-1') != NVL(job_id_value_, '-1')) AND (job_invoice_id_ = invoice_id_)) THEN
            -- Return previous Execution            
			   RETURN  job_id_value_;
         END IF;

         IF (job_invoice_id_ != Database_SYS.string_null_) THEN
            job_invoice_id_   := Database_SYS.string_null_;
         END IF;
      END LOOP;                          
   END LOOP;
   RETURN NULL;
END Get_Job_Arguments___;


PROCEDURE Buffer_Coll_Ivc_Orders___(attr_ IN VARCHAR2)
IS
   PRAGMA AUTONOMOUS_TRANSACTION;
   
   ptr_                    NUMBER;
   name_                   VARCHAR2(30);
   value_                  VARCHAR2(2000);
   i_                      NUMBER;
   TYPE Buffered_Ord_List_Type IS TABLE OF BATCH_COLLECT_IVC_ORDERS_TAB%ROWTYPE INDEX BY PLS_INTEGER;
   bufferd_order_list_  Buffered_Ord_List_Type;
   raise_error_           BOOLEAN := FALSE;
   --   This procedure checks whether there is another background job is "Posted" or "Executing"
   --   state in parallel with the same order_no.
   PROCEDURE Clear_Obsolete_Buffer_Val___
   IS
      msg_            VARCHAR2(32000);
      arg_tab_        Transaction_SYS.Arguments_Table;
      job_id_tab_   Message_SYS.Name_Table;
      attrib_tab_   Message_SYS.Line_Table;
      count_        NUMBER;
    BEGIN
      
      -- Get current 'Posted' job arguments
      arg_tab_:= Transaction_SYS.Get_Posted_Job_Arguments('Invoice_Customer_Order_API.Create_Collect_Ivc_Ord__', NULL);
      
      -- Get current 'Executing' job arguments
      Transaction_SYS.Get_Executing_Job_Arguments(msg_, 'Invoice_Customer_Order_API.Create_Collect_Ivc_Ord__');
      Message_SYS.Get_Attributes(msg_, count_, job_id_tab_, attrib_tab_);

      FOR j_ IN bufferd_order_list_.first .. bufferd_order_list_.last LOOP
         -- Background jobs for Create Collective Customer Invoices Per Order(Invoice_Customer_Order_API.Create_Collect_Ivc_Ord__)
         -- are created having argument with single value of head_order number only
         IF (arg_tab_.COUNT > 0) THEN
            -- Check if duplicate orders are from Posted background job
            FOR i_ IN arg_tab_.FIRST..arg_tab_.LAST LOOP
               IF (arg_tab_(i_).arguments_string = bufferd_order_list_(j_).head_order_no) THEN
                  -- DUP_VAL_ON_INDEX error is valid and need to be raised
                  raise_error_ := TRUE;
                  RETURN;
               END IF;
            END LOOP;
         END IF;
         -- Check if duplicate orders are from Executing background job
         FOR i_ IN 1..count_ LOOP
            IF (attrib_tab_(i_) = bufferd_order_list_(j_).head_order_no) THEN
               -- DUP_VAL_ON_INDEX error is valid and need to be raised
               raise_error_ := TRUE;
               RETURN;
            END IF;                        
         END LOOP;
      END LOOP;

   END Clear_Obsolete_Buffer_Val___; 
   
BEGIN
   ptr_ := NULL;
   i_ := 0;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'ORDER_NO') THEN
         i_ := i_ + 1;
         bufferd_order_list_(i_).order_no := value_;
         bufferd_order_list_(i_).rowkey   := SYS_GUID();
      END IF;

      IF (name_ = 'IGNORE_CLOSING_DATE') THEN
         bufferd_order_list_(i_).ignore_closing_date := value_;
      END IF;

      IF (name_ = 'CLOSEST_CLOSING_DATE') THEN
         bufferd_order_list_(i_).closest_closing_date := Client_SYS.Attr_Value_To_Date(value_);
      END IF;

      IF (name_ = 'HEAD_ORDER_NO') THEN
         bufferd_order_list_(i_).head_order_no := value_;
      END IF;

      IF (name_ = 'TAX_LIABILITY_COUNTRY_DB') THEN
         bufferd_order_list_(i_).tax_liability_country := value_;
      END IF;

   END LOOP;

   FORALL i IN bufferd_order_list_.first .. bufferd_order_list_.last
      INSERT INTO batch_collect_ivc_orders_tab VALUES bufferd_order_list_(i);
   @ApproveTransactionStatement(2014-08-11,mahplk)
   COMMIT;
EXCEPTION
   WHEN DUP_VAL_ON_INDEX THEN
      Clear_Obsolete_Buffer_Val___ ();
      IF raise_error_ THEN
         Error_SYS.Record_General(lu_name_, 'DUPVALBATCHCOLIVC: One or more selected lines are already included in the process of creating the collective invoice per order. Refresh the window and then try to proceed.');
      ELSE
         -- Remove all the records added currently and previously added, that are not deleted once the background job is processed. This happens when 
         -- the records in batch_collect_ivc_orders_tab remains undeleted if the previousely created background job deleted in Posted state.
         FORALL i IN bufferd_order_list_.first .. bufferd_order_list_.last
             DELETE batch_collect_ivc_orders_tab WHERE order_no = bufferd_order_list_(i).order_no;
         -- Start adding the order numbers again    
         FORALL i IN bufferd_order_list_.first .. bufferd_order_list_.last
            INSERT INTO batch_collect_ivc_orders_tab VALUES bufferd_order_list_(i);
         @ApproveTransactionStatement(2019-11-13,kisalk)
         COMMIT;
      END IF;
END Buffer_Coll_Ivc_Orders___;

PROCEDURE Create_Tax_Source_Keys___ (
   copy_from_source_key_rec_  OUT   Tax_Handling_Util_API.source_key_rec,
   copy_to_source_key_rec_    OUT   Tax_Handling_Util_API.source_key_rec, 
   copy_from_source_ref_type_ IN    VARCHAR2,
   copy_from_source_ref1_     IN    VARCHAR2,
   copy_from_source_ref2_     IN    VARCHAR2,
   copy_from_source_ref3_     IN    VARCHAR2,
   copy_from_source_ref4_     IN    VARCHAR2,
   copy_from_source_ref5_     IN    VARCHAR2,
   copy_to_source_ref_type_   IN    VARCHAR2, 
   copy_to_source_ref1_       IN    VARCHAR2,
   copy_to_source_ref2_       IN    VARCHAR2,
   copy_to_source_ref3_       IN    VARCHAR2,
   copy_to_source_ref4_       IN    VARCHAR2,
   copy_to_source_ref5_       IN    VARCHAR2)
IS
BEGIN
   copy_from_source_key_rec_ := Tax_Handling_Util_API.Create_Source_Key_Rec(copy_from_source_ref_type_, 
                                                                              copy_from_source_ref1_,
                                                                              copy_from_source_ref2_,
                                                                              copy_from_source_ref3_,
                                                                              copy_from_source_ref4_,
                                                                              copy_from_source_ref5_,
                                                                              NULL); 
   copy_to_source_key_rec_ := Tax_Handling_Util_API.Create_Source_Key_Rec(copy_to_source_ref_type_, 
                                                                           copy_to_source_ref1_,
                                                                           copy_to_source_ref2_,
                                                                           copy_to_source_ref3_,
                                                                           copy_to_source_ref4_,
                                                                           copy_to_source_ref5_,
                                                                           NULL); 
END Create_Tax_Source_Keys___;

PROCEDURE Transfer_Ext_Tax_Lines___(
   copy_from_source_arr_   IN    Tax_Handling_Util_API.source_key_arr,
   copy_to_source_arr_     IN    Tax_Handling_Util_API.source_key_arr,
   company_                IN    VARCHAR2,
   invoice_id_             IN    VARCHAR2)
IS
   invoiced_qty_                 NUMBER;
   activity_seq_                 NUMBER;
   co_charge_rec_                Customer_Order_Charge_API.Public_Rec;
BEGIN
   Tax_Handling_Order_Util_API.Transfer_Ext_Tax_Lines(copy_from_source_arr_,
                                                      copy_to_source_arr_,
                                                      company_,
                                                      'TRUE');

   FOR i_ IN 1..copy_from_source_arr_.COUNT LOOP
      IF copy_from_source_arr_(i_).source_ref_type = Tax_Source_API.DB_CUSTOMER_ORDER_LINE THEN 
         invoiced_qty_ := Customer_Order_Inv_Item_API.Get_Invoiced_Qty(invoice_id_, 
                                                                       copy_from_source_arr_(i_).source_ref1,
                                                                       copy_from_source_arr_(i_).source_ref2, 
                                                                       copy_from_source_arr_(i_).source_ref3, 
                                                                       copy_from_source_arr_(i_).source_ref4);
         -- Note : when invoice item has been successfully created, copy order line's discounts to the new item
         Cust_Invoice_Item_Discount_API.Copy_Discount(company_, 
                                                      copy_to_source_arr_(i_).source_ref1, 
                                                      copy_to_source_arr_(i_).source_ref2, 
                                                      copy_from_source_arr_(i_).source_ref1, 
                                                      copy_from_source_arr_(i_).source_ref2, 
                                                      copy_from_source_arr_(i_).source_ref3, 
                                                      copy_from_source_arr_(i_).source_ref4,
                                                      invoiced_qty_);

         activity_seq_ := Customer_Order_Line_API.Get_Activity_Seq(copy_from_source_arr_(i_).source_ref1,
                                                                  copy_from_source_arr_(i_).source_ref2,
                                                                  copy_from_source_arr_(i_).source_ref3,
                                                                  copy_from_source_arr_(i_).source_ref4);
         -- If CO Line is project connected, then refresh project revenue for CO Invoice Line
         IF (NVL(activity_seq_, 0) > 0) THEN

            Customer_Order_Inv_Item_API.Calculate_Prel_Revenue__ (company_, invoice_id_, copy_to_source_arr_(i_).source_ref2, activity_seq_);
         END IF;
      END IF;    

      IF copy_from_source_arr_(i_).source_ref_type = Tax_Source_API.DB_CUSTOMER_ORDER_CHARGE THEN 
         co_charge_rec_ := Customer_Order_Charge_API.Get(copy_from_source_arr_(i_).source_ref1, copy_from_source_arr_(i_).source_ref2);

         activity_seq_ := Customer_Order_Line_API.Get_Activity_Seq(co_charge_rec_.order_no,
                                                                   co_charge_rec_.line_no,
                                                                   co_charge_rec_.rel_no,
                                                                   co_charge_rec_.line_item_no);

         -- If CO Line is project connected, then refresh project revenue for CO Invoice Line
         IF (co_charge_rec_.line_no IS NOT NULL) AND NVL(activity_seq_, 0) > 0 THEN
            Customer_Order_Inv_item_API.Calculate_Prel_Revenue__ (co_charge_rec_.company, invoice_id_, copy_to_source_arr_(i_).source_ref2, activity_seq_);
         END IF;
      END IF;
   END LOOP;
END Transfer_Ext_Tax_Lines___;

-- gelr: cancel_customer_order_invoice, begin
@IgnoreUnitTest TrivialFunction
PROCEDURE Validate_Cancel_Debit_Invoice___(
   company_             IN     VARCHAR2,
   invoice_id_          IN     NUMBER)   
IS 
   credit_invoices_     VARCHAR2(2000); 
   rma_exists_          VARCHAR2(5) := 'FALSE';   
   inv_rec_             Invoice_API.Public_Rec;
   
BEGIN    
   inv_rec_ := Invoice_API.Get(company_, invoice_id_);
   IF (inv_rec_.correction_invoice_id IS NOT NULL) THEN      
      Error_SYS.Appl_General(lu_name_, 'CUSTORDCOREXISTS: You are not allowed to cancel the invoice :P1 :P2 since correction invoice :P3 exists.', inv_rec_.series_id, inv_rec_.invoice_no, inv_rec_.correction_invoice_id);
   END IF;   
   
   rma_exists_ := Return_Material_API.Check_Exist_Rma_For_Invoice(inv_rec_.invoice_no, company_);
   IF (rma_exists_ = 'TRUE') THEN      
      Error_SYS.Appl_General(lu_name_, 'RMAEXIST: You are not allowed to cancel the invoice :P1 :P2 since one or more RMA lines are connected.', inv_rec_.series_id, inv_rec_.invoice_no);
   END IF;

   credit_invoices_ := Get_Credit_Invoices(company_, inv_rec_.invoice_no, inv_rec_.series_id);      
   IF (credit_invoices_ IS NOT NULL) THEN      
      Error_SYS.Appl_General(lu_name_, 'CUSTORDCRDEXIST: You are not allowed to cancel the invoice :P1 :P2 since one or more credit invoices exist.', inv_rec_.series_id, inv_rec_.invoice_no);
   END IF;  
END Validate_Cancel_Debit_Invoice___;
-- gelr: cancel_customer_order_invoice, end

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Create_Invoice_Item__
--   Create invoice_line in INVOICE module and update depending order_line.
PROCEDURE Create_Invoice_Item__ (
   item_id_                      IN OUT NUMBER,
   invoice_id_                   IN     NUMBER,
   order_no_                     IN     VARCHAR2,
   line_no_                      IN     VARCHAR2,
   rel_no_                       IN     VARCHAR2,
   line_item_no_                 IN     NUMBER,
   qty_invoiced_                 IN     NUMBER,
   customer_po_no_               IN     VARCHAR2,
   stage_                        IN     NUMBER,
   cust_part_price_              IN     NUMBER  DEFAULT NULL,
   copy_discount_                IN     BOOLEAN DEFAULT TRUE,
   planned_revenue_simulation_   IN     BOOLEAN DEFAULT FALSE, 
   rental_transaction_id_        IN     NUMBER  DEFAULT NULL,
   price_conv_factor_            IN     NUMBER  DEFAULT NULL,
   taransfer_ext_tax_            IN     BOOLEAN DEFAULT TRUE )
IS
   new_qty_invoiced_              NUMBER;
   company_                       VARCHAR2(20);
   line_rec_                      Customer_Order_Line_API.Public_Rec;
   co_rec_                        Customer_Order_API.Public_Rec;
   total_tax_percentage_          NUMBER;
   add_discount_                  NUMBER := 0;
   discount_                      NUMBER := 0;
   order_discount_                NUMBER := 0;
   sale_unit_price_               NUMBER := 0;
   unit_price_incl_tax_           NUMBER := 0;
   sales_part_rebate_group_       VARCHAR2(10) := NULL;
   assortment_id_                 VARCHAR2(50) := NULL;
   assortment_node_id_            VARCHAR2(50) := NULL;
   $IF Component_Rental_SYS.INSTALLED $THEN 
      rental_trans_rec_          Rental_Transaction_API.Public_Rec;
   $END
   source_ref4_                  VARCHAR2(50);
   net_dom_price_                NUMBER := 0;
   gross_dom_price_              NUMBER := 0;
BEGIN
   line_rec_ := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);
   co_rec_   := Customer_Order_API.Get(order_no_);
   company_  := Site_API.Get_Company(co_rec_.contract);
      
   IF copy_discount_ THEN
      discount_       := line_rec_.discount;
      order_discount_ := line_rec_.order_discount;
      add_discount_   := Customer_Order_Line_API.Get_Additional_Discount(order_no_, line_no_, rel_no_, line_item_no_);
   END IF;

   IF (rental_transaction_id_ IS NULL) THEN 
      --cust_part_price_ is used when invice item is created from Self Billing.
      IF (cust_part_price_ IS NOT NULL) THEN
         IF (co_rec_.use_price_incl_tax = 'FALSE') THEN
            sale_unit_price_ := cust_part_price_;
         ELSE
            unit_price_incl_tax_ := cust_part_price_;
         END IF;            
         Tax_Handling_Order_Util_API.Get_Prices(net_dom_price_, 
                                                gross_dom_price_, 
                                                sale_unit_price_, 
                                                unit_price_incl_tax_, 
                                                company_, 
                                                Tax_Source_API.DB_CUSTOMER_ORDER_LINE, 
                                                order_no_, 
                                                line_no_, 
                                                rel_no_, 
                                                line_item_no_, 
                                                '*',
                                                ifs_curr_rounding_ => 16);
      ELSE
         sale_unit_price_     := line_rec_.sale_unit_price;
         unit_price_incl_tax_ := line_rec_.unit_price_incl_tax;
      END IF;      
   ELSE
      $IF Component_Rental_SYS.INSTALLED $THEN
         rental_trans_rec_    := Rental_Transaction_API.Get(rental_transaction_id_);
         sale_unit_price_     := rental_trans_rec_.unit_price_curr;
         unit_price_incl_tax_ := rental_trans_rec_.unit_price_incl_tax_curr;
      $ELSE
         Error_SYS.Component_Not_Exist('RENTAL');
      $END      
   END IF;

   IF line_rec_.rebate_builder = 'TRUE' THEN
      Get_Rebate_Info___(sales_part_rebate_group_, assortment_id_, assortment_node_id_,
                         company_, co_rec_.contract, co_rec_.customer_no, line_rec_.catalog_no);
   END IF;

   IF line_item_no_ <= 0 THEN
      source_ref4_ := TO_CHAR(line_item_no_);
   ELSE
      source_ref4_ := '-1';
   END IF;
   total_tax_percentage_ := Source_Tax_Item_API.Get_Total_Tax_Percentage(company_, Tax_Source_API.DB_CUSTOMER_ORDER_LINE,
                                                                       order_no_, line_no_, rel_no_, source_ref4_, '*');

   -- gelr:disc_price_rounded, added original_discount_, original_add_discount_ and original_order_discount_ to the parameter list.
   Customer_Order_Inv_Item_API.Create_Invoice_Item(item_id_, invoice_id_, company_, order_no_, line_no_, rel_no_, line_item_no_,
                                                   line_rec_.contract,line_rec_.catalog_no,line_rec_.catalog_desc,
                                                   line_rec_.sales_unit_meas,NVL(price_conv_factor_, line_rec_.price_conv_factor),
                                                   sale_unit_price_, unit_price_incl_tax_, discount_, order_discount_, 
                                                   line_rec_.tax_code, total_tax_percentage_, qty_invoiced_, customer_po_no_, line_rec_.delivery_type,
                                                   qty_invoiced_,
                                                   NULL,          -- Not a charge
                                                   NULL,          -- Not a charge
                                                   stage_,
                                                   'TRUE',
                                                   NULL,          -- rma_no_
                                                   NULL,          -- rma_line_no_
                                                   NULL,          -- rma_charge_no_
                                                   NULL,          -- deb_invoice_id_
                                                   NULL,          -- deb_item_id_
                                                   add_discount_,
                                                   sales_part_rebate_group_,
                                                   assortment_id_,
                                                   assortment_node_id_,
                                                   NULL,          -- charge_percent_
                                                   NULL,          -- charge_percent_basis_
                                                   rental_transaction_id_,
                                                   line_rec_.ship_addr_no,
                                                   original_discount_       => Customer_Order_Line_API.Get_Original_Discount(order_no_, line_no_, rel_no_, line_item_no_),
                                                   original_add_discount_   => Customer_Order_Line_API.Get_Original_Add_Discount(order_no_, line_no_, rel_no_, line_item_no_),
                                                   original_order_discount_ => Customer_Order_Line_API.Get_Original_Order_Discount(order_no_, line_no_, rel_no_, line_item_no_)
                                                   );

   IF (line_rec_.rental = Fnd_Boolean_API.DB_TRUE AND rental_transaction_id_ IS NOT NULL) THEN
      $IF Component_Rental_SYS.INSTALLED $THEN 
         Rental_Transaction_API.Modify_Qty_Invoiced(rental_transaction_id_, 
                                                    qty_invoiced_);
      $ELSE
         Error_SYS.Component_Not_Exist('RENTAL');
      $END
   END IF;

   Customer_Order_Line_Hist_API.New(order_no_, line_no_, rel_no_, line_item_no_,
     Language_SYS.Translate_Constant(lu_name_, 'LINEINVOICED: Invoiced on invoice :P1', NULL, invoice_id_));

   IF (NOT planned_revenue_simulation_) THEN
      new_qty_invoiced_ := qty_invoiced_ + line_rec_.qty_invoiced;
      Customer_Order_API.Set_Line_Qty_Invoiced(order_no_, line_no_, rel_no_, line_item_no_, new_qty_invoiced_);
   END IF;

   IF (stage_ IS NOT NULL) THEN
      Order_Line_Staged_Billing_API.Set_Invoiced(order_no_, line_no_, rel_no_, line_item_no_, stage_, invoice_id_);
   END IF;
   
   IF taransfer_ext_tax_ THEN 
      Tax_Handling_Order_Util_API.Transfer_Tax_lines(company_, 
                                                     Tax_Source_API.DB_CUSTOMER_ORDER_LINE,
                                                     order_no_,
                                                     line_no_,
                                                     rel_no_,
                                                     line_item_no_,
                                                     '*',
                                                     Tax_Source_API.DB_INVOICE,
                                                     invoice_id_,
                                                     item_id_,
                                                     '*',
                                                     '*',
                                                     '*',
                                                     'TRUE',
                                                     'TRUE');

      IF copy_discount_ THEN
         -- Note : when invoice item has been successfully created, copy order line's discounts to the new item
         Cust_Invoice_Item_Discount_API.Copy_Discount(company_, invoice_id_, item_id_, order_no_, line_no_, rel_no_, line_item_no_,qty_invoiced_);
      END IF;

      IF (NOT planned_revenue_simulation_) THEN
         -- If CO Line is project connected, then refresh project revenue for CO Invoice Line
         IF (order_no_ IS NOT NULL) AND (line_no_      IS NOT NULL) AND 
            (rel_no_   IS NOT NULL) AND (line_item_no_ IS NOT NULL) AND (NVL(line_rec_.activity_seq, 0) > 0) THEN

            Customer_Order_Inv_Item_API.Calculate_Prel_Revenue__ (company_, invoice_id_, item_id_, line_rec_.activity_seq);
         END IF;
      END IF;
      
   END IF;                                               
   
   
END Create_Invoice_Item__;


-- Create_Collective_Invoice__
--   Create collective invoice for the customer passed in the attribute
PROCEDURE Create_Collective_Invoice__ (
   attr_ IN OUT VARCHAR2 )
IS
   ptr_                  NUMBER;
   name_                 VARCHAR2(30);
   value_                VARCHAR2(2000);
   -- The Customer_Order_Collect_Invoice will be created in post installation
   -- Therefore added ORDER check (intially it will be false) in order to skip in intial deployment of the package.
   $IF (Component_Order_SYS.INSTALLED) $THEN
      newrec_               CUSTOMER_ORDER_COLLECT_INVOICE%ROWTYPE;
   $END

   ignore_closing_date_       VARCHAR2(10);
   closest_closing_date_      DATE;
   jinsui_invoice_db_         VARCHAR2(5);
   tax_liability_country_db_  VARCHAR2(2);
   currency_rate_type_        VARCHAR2(10);
   use_price_incl_tax_        VARCHAR2(20);
   ivc_unconct_chg_seperatly_    NUMBER;
   comp_ivc_unconct_chg_seprtly_ VARCHAR2(20);
BEGIN
   $IF (Component_Order_SYS.INSTALLED) $THEN
      WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
         -- The order of the attributes should not changed.
         IF (name_ = 'CUSTOMER_NO') THEN
            newrec_.customer_no := value_;
            Cust_Ord_Customer_API.Exist(newrec_.customer_no);
         ELSIF (name_ = 'CONTRACT') THEN
            newrec_.contract := value_;
            Site_API.Exist(newrec_.contract);
         ELSIF (name_ = 'CURRENCY_CODE') THEN
            newrec_.currency_code := value_;
            Iso_Currency_API.Exist(newrec_.currency_code);
         ELSIF (name_ = 'PAY_TERM_ID') THEN
            newrec_.pay_term_id := value_;
            Payment_Term_API.Exist(Site_API.Get_Company(newrec_.contract), newrec_.pay_term_id);
         ELSIF (name_ = 'BILL_ADDR_NO') THEN
            newrec_.bill_addr_no := value_;
            IF (newrec_.bill_addr_no IS NOT NULL) THEN
               Customer_Info_Address_API.Exist(newrec_.customer_no, newrec_.bill_addr_no);
            END IF;
         ELSIF (name_ = 'IGNORE_CLOSING_DATE') THEN
            ignore_closing_date_ := value_;
         ELSIF (name_ = 'JINSUI_INVOICE_DB') THEN
            jinsui_invoice_db_ := value_;
         ELSIF (name_ = 'CLOSEST_CLOSING_DATE') THEN
            closest_closing_date_ := Client_Sys.Attr_Value_To_Date(value_);
         ELSIF (name_ = 'PROJECT_ID') THEN
            newrec_.project_id := value_;
         ELSIF (name_ = 'CURRENCY_RATE_TYPE') THEN
            currency_rate_type_ := value_;
         ELSIF (name_ = 'TAX_LIABILITY_COUNTRY_DB') THEN
            tax_liability_country_db_ := value_; 
         ELSIF (name_ = 'USE_PRICE_INCL_TAX') THEN
            use_price_incl_tax_ := value_;
         ELSIF (name_ = 'IVC_UNCONCT_CHG_SEPERATLY') THEN
            ivc_unconct_chg_seperatly_ := value_;
         ELSE
            Error_SYS.Item_Not_Exist(lu_name_, name_, value_);
         END IF;
      END LOOP;
      
      IF(ivc_unconct_chg_seperatly_ IS NOT NULL) THEN
         ivc_unconct_chg_seperatly_ := ivc_unconct_chg_seperatly_;
      ELSE
         comp_ivc_unconct_chg_seprtly_ := Company_Order_Info_API.Get_Ivc_Unconct_Chg_Seperat_Db(Site_Api.Get_Company(newrec_.contract));
            IF(comp_ivc_unconct_chg_seprtly_ = 'TRUE') THEN
               ivc_unconct_chg_seperatly_ := 1;
            ELSE 
               ivc_unconct_chg_seperatly_ := 0;
            END IF;
      END IF;

      Create_Collective_Invoice___(newrec_.customer_no,
                                   newrec_.contract,
                                   newrec_.currency_code,
                                   newrec_.pay_term_id,
                                   newrec_.bill_addr_no,
                                   ignore_closing_date_,
                                   jinsui_invoice_db_,
                                   closest_closing_date_,
                                   currency_rate_type_,
                                   newrec_.project_id,
                                   tax_liability_country_db_,
                                   use_price_incl_tax_,
                                   ivc_unconct_chg_seperatly_);
   $ELSE
      NULL;
   $END                            
END Create_Collective_Invoice__;


-- Create_Invoice__
--   Creates invoice for order_no in INVOICE module
PROCEDURE Create_Invoice__ (
   invoice_id_ IN OUT NUMBER,
   order_no_   IN     VARCHAR2 )
IS
   invoice_summary_         EXCEPTION;
   company_                 VARCHAR2(20);
   cust_po_no_              VARCHAR2(50);
   adv_pre_payment_exist_   VARCHAR2(5);
   lines_invoiced_          BOOLEAN := FALSE;
   dummy_                   NUMBER;
   lines_exists_            NUMBER;
   copy_from_tax_source_arr_    Tax_Handling_Util_API.source_key_arr := Tax_Handling_Util_API.source_key_arr();
   copy_to_tax_source_arr_      Tax_Handling_Util_API.source_key_arr := Tax_Handling_Util_API.source_key_arr();

   -- gelr:fr_service_code, begin
   CURSOR head_data IS
      SELECT order_no, customer_no, currency_code, authorize_code, date_entered,
             bill_addr_no, customer_no_pay, customer_no_pay_addr_no,
             internal_po_no, internal_ref, cust_ref, delivery_terms, del_terms_location,
             forward_agent_id, pay_term_id, ship_via_code,
             ship_addr_no, NVL(internal_po_label_note, label_note) label_note, note_id,
             contract, wanted_delivery_date, customer_po_no, currency_rate_type, 
             language_code, supply_country, use_price_incl_tax, rowstate, invoice_reason_id,service_code
      FROM   CUSTOMER_ORDER_TAB
      WHERE  order_no = order_no_;
   -- gelr:fr_service_code, end
   
   CURSOR check_prel_pbi_invoice_exist(deb_invoice_type_   VARCHAR2, cre_invoice_type_   VARCHAR2) IS
      SELECT 1
        FROM customer_order_inv_head
       WHERE creators_reference = order_no_
         AND invoice_type IN (deb_invoice_type_, cre_invoice_type_)
         AND objstate IN ('Preliminary', 'Printed');

   CURSOR exists_order_line_data(order_no_ IN VARCHAR2) IS
      SELECT 1
      FROM   customer_order_line_tab
      WHERE  order_no = order_no_
      AND    rowstate != 'Cancelled';

   CURSOR exists_service_order_lines IS
      SELECT 1
      FROM   customer_order_line_tab
      WHERE  order_no = order_no_
      AND    demand_code = 'SEC';

   invoice_component_   head_data%ROWTYPE;
   js_invoice_state_db_ VARCHAR2(3);
BEGIN
   company_             := Site_API.Get_Company(Customer_Order_API.Get_Contract(order_no_));
   js_invoice_state_db_ := Get_Js_Invoice_State_Db___(Customer_Order_API.Get_Jinsui_Invoice_Db(order_no_));

   -- Note : set the Commission Recalc Flag to true: data have changed, commission should/may be recalculated
   Order_Line_Commission_API.Set_Order_Com_Lines_Changed(order_no_); 

   OPEN head_data;
   FETCH head_data INTO invoice_component_;
   IF head_data%NOTFOUND THEN
      CLOSE head_data;
      Error_SYS.Record_General(lu_name_, 'NO_INV_HEAD_DATA: Could not find order data when creating invoice.');
   ELSE
      CLOSE head_data;

      OPEN check_prel_pbi_invoice_exist(Company_Def_Invoice_Type_API.Get_Def_Co_Prepay_Deb_Inv_Type(company_),
                                        Company_Def_Invoice_Type_API.Get_Def_Co_Prepay_Cre_Inv_Type(company_));
      FETCH check_prel_pbi_invoice_exist INTO dummy_;
      IF (check_prel_pbi_invoice_exist%FOUND) THEN
         CLOSE check_prel_pbi_invoice_exist;
         Error_SYS.Record_General(lu_name_, 'PRELPREPAYINVEXIST: Unposted prepayment based invoice(s) exist. The debit invoice will not be created for Customer Order :P1.', order_no_);
      END IF;
      CLOSE check_prel_pbi_invoice_exist;

      adv_pre_payment_exist_ := Customer_Invoice_Pub_Util_API.Has_Adv_Or_Prepaym_Inv(invoice_component_.order_no);

      IF Cust_Ord_Customer_API.Get_Invoice_Sort_Db(NVL
         (invoice_component_.customer_no_pay, invoice_component_.customer_no)) = 'C'
         AND (adv_pre_payment_exist_ = 'FALSE') THEN
         RAISE invoice_summary_;
      END IF;

      IF (invoice_component_.customer_no_pay IS NOT NULL) THEN
         invoice_component_.cust_ref := Customer_Order_API.Get_Customer_No_Pay_Ref(order_no_);
      ELSE
         OPEN exists_service_order_lines;
         FETCH exists_service_order_lines INTO lines_exists_;
         IF (exists_service_order_lines%NOTFOUND) THEN
            invoice_component_.cust_ref := NVL(invoice_component_.internal_ref, invoice_component_.cust_ref);
         ELSE           
            invoice_component_.cust_ref := NVL(invoice_component_.cust_ref, invoice_component_.internal_ref);
         END IF;
         CLOSE exists_service_order_lines;
      END IF; 
      
      Customer_Order_Inv_Head_API.Create_Invoice_Head(
         invoice_id_, --invoice_id_
         Site_API.Get_Company(invoice_component_.contract), --company_
         invoice_component_.order_no, --order_no_
         invoice_component_.customer_no, --customer_no_
         invoice_component_.customer_no_pay, --customer_no_pay_
         Order_Coordinator_API.Get_Name(invoice_component_.authorize_code), --authorize_name_
         invoice_component_.date_entered, --date_entered_
         invoice_component_.cust_ref, --cust_ref_
         Mpccom_Ship_Via_API.Get_Description(invoice_component_.ship_via_code, invoice_component_.language_code), --ship_via_desc_
         invoice_component_.forward_agent_id, --forward_agent_id_
         invoice_component_.label_note, --label_note_
         Order_Delivery_Term_API.Get_Description(invoice_component_.delivery_terms, invoice_component_.language_code), --delivery_terms_desc_
         invoice_component_.del_terms_location, --del_terms_location_
         invoice_component_.pay_term_id, --pay_term_id_
         invoice_component_.currency_code, --currency_code_
         invoice_component_.ship_addr_no, --ship_addr_no_
         invoice_component_.customer_no_pay_addr_no, --customer_no_pay_addr_no_
         invoice_component_.bill_addr_no, --bill_addr_no_
         invoice_component_.wanted_delivery_date, --wanted_delivery_date_
         'CUSTORDDEB', --invoice_type_
         NULL, -- number_reference
         NULL, -- series_reference
         invoice_component_.contract, --contract_
         js_invoice_state_db_ , --js_invoice_state_db_
         invoice_component_.currency_rate_type, --currency_rate_type_
         'FALSE', -- collect
         NULL,    -- rma_no
         NULL,    -- shipment_id
         NULL,    -- adv_invoice
         NULL,    -- adv_pay_base_date
         NULL,    -- sb_reference_no
         'FALSE', -- use_ref_inv_curr_rate
         NULL,    -- ledger_item_id
         NULL,    -- ledger_item_series_id
         NULL,    -- ledger_item_version_id
         NULL,    -- aggregation_no 
         'FALSE', -- final_settlement
         NULL,    -- project_id
         NULL,    -- tax_id_number
         NULL,    -- tax_id_type
         NULL,    -- branch
         invoice_component_.supply_country, --supply_country_db_
         NULL, --invoice_date_
         invoice_component_.use_price_incl_tax, --use_price_incl_tax_db_
         NULL, --wht_amount_base_
         NULL, --curr_rate_new_
         NULL, --tax_curr_rate_new_
         NULL, --correction_reason_id_
         NULL, --correction_reason_
         'FALSE', --is_simulated_
         invoice_component_.invoice_reason_id,--invoice_reason_id_
         service_code_ => invoice_component_.service_code); --service_code_
         
      Customer_Order_History_API.New(invoice_component_.order_no,
         Language_SYS.Translate_Constant(lu_name_, 'CRECUSTINV: Invoice :P1 created', NULL, invoice_id_));

      -- Note : Checked whether invoice_component_.internal_po_no is null
      IF (invoice_component_.internal_po_no IS NOT NULL ) THEN
         cust_po_no_ := invoice_component_.internal_po_no;
      ELSE
         cust_po_no_ := invoice_component_.customer_po_no;
      END IF;

      Create_Invoice_Lines___(copy_from_tax_source_arr_, copy_to_tax_source_arr_, lines_invoiced_ , order_no_, invoice_id_, cust_po_no_,'TRUE' ,NULL, NULL);
      
      IF (copy_from_tax_source_arr_.COUNT > 0 ) THEN 
         Transfer_Ext_Tax_Lines___ (copy_from_tax_source_arr_,
                                    copy_to_tax_source_arr_,
                                    company_,
                                    invoice_id_);
      END IF;
      
      IF (Company_Order_Info_API.Get_Prepayment_Inv_Method_Db(company_) = 'PREPAYMENT_BASED_INVOICE') THEN
         Consume_Prepaym_Inv_Lines___(company_, invoice_id_, order_no_);
      END IF;
      Customer_Order_Inv_Head_API.Create_Invoice_Complete(company_, invoice_id_);
      OPEN exists_order_line_data(order_no_);
      FETCH exists_order_line_data INTO lines_exists_;
      IF (exists_order_line_data%NOTFOUND) THEN
         IF (invoice_component_.rowstate = 'Blocked') THEN
            Customer_Order_API.Release_Blocked(order_no_);         
         END IF;
      END IF;
      CLOSE exists_order_line_data;
   END IF;
EXCEPTION
   WHEN invoice_summary_ THEN
      NULL;
END Create_Invoice__;


-- Make_Collective_Invoice__
--   Create collective invoices for all the customer passed in the attribute
--   string. Make a deferred call for each customer.
PROCEDURE Make_Collective_Invoice__ (
   attr_ IN OUT VARCHAR2 )
IS
   ptr_           NUMBER;
   name_          VARCHAR2(30);
   value_         VARCHAR2(2000);
   invoice_attr_  VARCHAR2(2000);
   description_   VARCHAR2(200);
BEGIN
   Client_SYS.Clear_Attr(invoice_attr_);

   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      Client_SYS.Add_To_Attr(name_, value_, invoice_attr_);

      IF (name_ = 'CUSTOMER_NO') THEN
         NULL;
      ELSIF (name_ = 'CONTRACT') THEN
         NULL;
      ELSIF (name_ = 'CURRENCY_CODE') THEN
         NULL;
      ELSIF (name_ = 'PAY_TERM_ID') THEN
         NULL;
      ELSIF (name_ = 'BILL_ADDR_NO') THEN
         NULL;
      ELSIF (name_ = 'IGNORE_CLOSING_DATE') THEN
         NULL;
      ELSIF (name_ = 'JINSUI_INVOICE_DB') THEN
         NULL;
      ELSIF (name_ = 'CLOSEST_CLOSING_DATE') THEN
         NULL;
      ELSIF (name_ = 'PROJECT_ID') THEN
         NULL;
      ELSIF (name_ = 'CURRENCY_RATE_TYPE') THEN
         NULL;
      ELSIF (name_ = 'TAX_LIABILITY_COUNTRY_DB') THEN
         NULL;
      ELSIF (name_ = 'USE_PRICE_INCL_TAX') THEN
         -- Note : Create invoice for the customer
         description_ := Language_SYS.Translate_Constant(lu_name_, 'CRE_COLLINV: Create Collective Customer Invoices');
         Transaction_SYS.Deferred_Call('INVOICE_CUSTOMER_ORDER_API.Create_Collective_Invoice__', invoice_attr_, description_);
         Client_SYS.Clear_Attr(invoice_attr_);
      ELSE
         Error_SYS.Item_Not_Exist(lu_name_, name_, value_);
      END IF;
   END LOOP;
END Make_Collective_Invoice__;


-- Create_Invoice_From_Return__
--   Create credit invoices for the specified RMA.
--   If rma_line_no is specified a new credit invoice is created for that line.
PROCEDURE Create_Invoice_From_Return__ (
   rma_no_                IN NUMBER,
   rma_line_no_           IN NUMBER DEFAULT NULL,
   rma_charge_no_         IN NUMBER DEFAULT NULL,
   use_ref_inv_curr_rate_ IN NUMBER DEFAULT 0 )
IS
   -- cursors
   CURSOR get_lines (rma_no_ VARCHAR2) IS
      SELECT rma_line_no, order_no, line_no, rel_no, line_item_no
        FROM return_material_line_tab
       WHERE rma_no = rma_no_
         AND credit_invoice_no IS NULL
         AND credit_approver_id IS NOT NULL
         AND rowstate NOT IN ('Planned','Denied');
   
   -- variables
   invoice_id_                   NUMBER;
   ivc_head_rec_                 ivc_head_rec;
   rma_rec_                      Return_Material_API.Public_Rec;
   order_no_                     RETURN_MATERIAL_CHARGE_TAB.order_no%TYPE;
   cust_part_no_                 CUSTOMER_ORDER_LINE_TAB.customer_part_no%TYPE;
   self_billing_db_              VARCHAR2(20);
   self_billing_                 BOOLEAN := FALSE;
   not_self_billing_             BOOLEAN := FALSE;
   sbi_invoice_id_               NUMBER;
   return_                       BOOLEAN := FALSE;
   currency_rate_type_           VARCHAR2(10);

   contract_                     VARCHAR2(5); 
   company_                      VARCHAR2(20); 
   customer_no_                  VARCHAR2(20); 
   exist_                        NUMBER;       
   invoice_type_                 VARCHAR2(20);
   co_not_connected_lines_exist_ BOOLEAN := FALSE;
   charge_lines_exist_           NUMBER := 0; 
   co_not_conn_charges_exist_    BOOLEAN := FALSE;
   self_billing_val_             VARCHAR2(20);
   invoice_id_tab_               Invoice_Id_Tab;
   count_                        NUMBER := 0;
   header_created_invoice_exist_ BOOLEAN := FALSE;
   rma_line_rec_                 Return_Material_Line_API.Public_Rec;

   -- This cursor is used to get Self Billing CO connected RMA lines and other RMA lines which are CO connected.
   -- Depending on the requirement Self Billing or Not Self Billing second parameter is passed. 
   CURSOR get_co_connected_lines (rma_no_ NUMBER, self_billing_ VARCHAR2) IS 
      SELECT rmt.rma_line_no, rmt.order_no, rmt.line_no, rmt.rel_no, rmt.line_item_no, co.currency_rate_type
      FROM  return_material_line_tab rmt, customer_order_tab co, customer_order_line_tab col 
      WHERE rmt.rma_no = rma_no_
      AND   rmt.credit_invoice_no IS NULL
      AND   rmt.order_no = co.order_no
      AND   col.order_no = co.order_no
      AND   rmt.line_no = col.line_no
      AND   rmt.rel_no = col.rel_no
      AND   rmt.line_item_no =  col.line_item_no
      AND   col.self_billing = self_billing_ 
      AND   rmt.credit_approver_id IS NOT NULL
      AND   rmt.rowstate NOT IN ('Planned','Denied')
      ORDER BY co.currency_rate_type;

   CURSOR get_co_connected_charges (rma_no_ NUMBER) IS
      SELECT rmt.rma_charge_no, rmt.order_no, co.currency_rate_type
      FROM  return_material_charge_tab rmt, customer_order_tab co
      WHERE rmt.rma_no = rma_no_
      AND   rmt.credit_invoice_no IS NULL
      AND   (NVL(rmt.charge_amount, rmt.charge) != 0 OR rmt.charge_cost != 0)
      AND   rmt.order_no IS NOT NULL
      AND   co.order_no = rmt.order_no
      AND   rmt.credit_approver_id IS NOT NULL
      AND   rmt.rowstate NOT IN ('Planned','Denied')
      ORDER BY co.currency_rate_type;

   CURSOR get_co_not_connected_charges (rma_no_ NUMBER) IS
      SELECT rma_charge_no
      FROM  return_material_charge_tab
      WHERE rma_no = rma_no_
      AND   credit_invoice_no IS NULL
      AND   (NVL(charge_amount, charge) != 0 OR charge_cost != 0)  
      AND   order_no IS NULL
      AND   credit_approver_id IS NOT NULL
      AND   rowstate NOT IN ('Planned','Denied'); 

   CURSOR check_charges_exist (rma_no_ NUMBER) IS   
      SELECT 1
      FROM  return_material_charge_tab
      WHERE rma_no = rma_no_
      AND   credit_invoice_no IS NULL
      AND   (NVL(charge_amount, charge) != 0 OR charge_cost != 0) 
      AND   credit_approver_id IS NOT NULL
      AND   rowstate NOT IN ('Planned','Denied');

   CURSOR get_invoice_id (rma_no_ NUMBER, curr_rate_type_ VARCHAR2, invoice_type_ VARCHAR2, company_ VARCHAR2, customer_no_ VARCHAR2) IS
      SELECT invoice_id
      FROM   customer_order_inv_head  
      WHERE  company = company_
      AND    identity = customer_no_
      AND    rma_no = rma_no_
      AND    currency_rate_type = curr_rate_type_
      AND    invoice_type = invoice_type_;

   CURSOR get_all_invoices (rma_no_ NUMBER, company_ VARCHAR2, customer_no_ VARCHAR2) IS
      SELECT invoice_id
      FROM   customer_order_inv_head  
      WHERE  company = company_
      AND    identity = customer_no_
      AND    rma_no = rma_no_; 
BEGIN
   --Lock RMA Header While Creating Invoice
   Lock_Rma_Head___(rma_no_);

   Get_Head_Data_From_Rma___(ivc_head_rec_, rma_no_, rma_line_no_, rma_charge_no_);   
   rma_rec_ := Return_Material_API.Get(rma_no_);

   contract_ := rma_rec_.contract;
   company_ := Site_API.Get_Company(contract_);
   customer_no_ := nvl(rma_rec_.customer_no_credit, rma_rec_.customer_no);

   -- Note : check if we have specied a line to credt invoice
   IF (rma_line_no_ IS NULL) AND (rma_charge_no_ IS NULL) THEN

      -- Before creating new invoices from the header, it is needed to keep the invoices created 
      -- up to that time from the rma linewise or charge linewise. 
      -- New invoices will be created for the same rma no, currency rate type, invoice type 
      -- irrespective of the previous invoices created.
      FOR rec_ IN get_all_invoices(rma_no_, company_, customer_no_ ) LOOP
         invoice_id_tab_(count_) := rec_.invoice_id;
         count_ := count_ + 1;
      END LOOP;

      -- check self billing flag on all lines
      FOR rec_ IN get_lines(rma_no_) LOOP
         -- Setting parameter co_not_connected_lines_exist_ to TRUE if there are RMA lines not connected to a order.
         IF (rec_.order_no IS NULL) THEN
            co_not_connected_lines_exist_ := TRUE;
         END IF;
         
         -- Setting two parametrs self_billing_ and not_self_billing_ to TRUE considering all the RMA lines.
         -- Any parameter will be set to TRUE if there exists at least one RMA line satisfying the condition.
         
         self_billing_db_ := Customer_Order_Line_API.Get_Self_Billing_Db(rec_.order_no, rec_.line_no, rec_.rel_no, rec_.line_item_no);

         IF (nvl(self_billing_db_, ' ') = 'SELF BILLING') THEN
            self_billing_ := TRUE;
         END IF;

         IF ((nvl(self_billing_db_, ' ') = 'NOT SELF BILLING') OR (rec_.order_no IS NULL)) THEN
            not_self_billing_ := TRUE;
         END IF;

      END LOOP;

      -- Check if there are any charge lines belongs to RMA.
      -- Later this parameter is used to create seperate invoice headers.
      
      OPEN check_charges_exist(rma_no_);
      FETCH check_charges_exist INTO charge_lines_exist_;
      IF (check_charges_exist%FOUND) THEN
         -- The invoice heads are created for charge lines when the not_self_billing_ parameter is TRUE.
         not_self_billing_ := TRUE;
      END IF;
      CLOSE check_charges_exist;
      
      -- Check whether existence of charge lines which do not have any CO connected. 
      OPEN get_co_not_connected_charges(rma_no_); 
      FETCH get_co_not_connected_charges INTO exist_;
      IF (get_co_not_connected_charges%FOUND) THEN
         co_not_conn_charges_exist_ := TRUE;
      END IF;
      CLOSE get_co_not_connected_charges; 

      -- Restructured the whole code considering different currency rate types.  
      IF self_billing_ THEN
         Create_Invoice_Head_For_Rma___(sbi_invoice_id_, ivc_head_rec_, use_ref_inv_curr_rate_, currency_rate_type_, 'SELFBILLCRE', rma_rec_.use_price_incl_tax);
         self_billing_val_ := 'SELF BILLING';
         -- Loop through self billing CO connected RMA lines
         FOR rec1_ IN get_co_connected_lines(rma_no_, self_billing_val_) LOOP
            IF ((rec1_.currency_rate_type IS NULL) OR (NVL(rec1_.currency_rate_type, Database_SYS.string_null_) != NVL(currency_rate_type_, Database_SYS.string_null_))) THEN   
    
               currency_rate_type_ := rec1_.currency_rate_type;
               Get_Ref_Inv_Curr_Rate_Type___(currency_rate_type_, company_,  customer_no_, ivc_head_rec_, use_ref_inv_curr_rate_);
               FOR rec_ IN get_invoice_id(rma_no_, currency_rate_type_, 'SELFBILLCRE', company_, customer_no_ ) LOOP
                  -- Check invoice is created from rma line level or charge line level.
                  -- if so header_created_invoice_exist_ will remain FALSE.
                  IF NOT (Check_Pre_Created_Cre_Inv___(invoice_id_tab_, rec_.invoice_id)) THEN
                     header_created_invoice_exist_ := TRUE;
                  END IF;
               END LOOP;

               IF NOT (header_created_invoice_exist_)  THEN
                  sbi_invoice_id_ := NULL;
                  -- If invoice head has not already created from the header, create a new invoice head.
                  Create_Invoice_Head_For_Rma___(sbi_invoice_id_, ivc_head_rec_, use_ref_inv_curr_rate_, currency_rate_type_, 'SELFBILLCRE', rma_rec_.use_price_incl_tax);
               END IF; 
            END IF;
         END LOOP;
         currency_rate_type_ := NULL;
      END IF;

      IF not_self_billing_ THEN
         Create_Invoice_Head_For_Rma___(invoice_id_, ivc_head_rec_, use_ref_inv_curr_rate_, currency_rate_type_, 'CUSTORDCRE', rma_rec_.use_price_incl_tax);
         self_billing_val_ := 'NOT SELF BILLING';
         -- Loop through CO connected RMA lines but not self billing enabled
         -- create invoice heads for co connected rma lines.
         FOR rec1_ IN get_co_connected_lines(rma_no_, self_billing_val_) LOOP
            
            IF ((rec1_.currency_rate_type IS NULL) OR (NVL(rec1_.currency_rate_type, Database_SYS.string_null_) != NVL(currency_rate_type_, Database_SYS.string_null_))) THEN   
    
               currency_rate_type_ := rec1_.currency_rate_type;
               Get_Ref_Inv_Curr_Rate_Type___(currency_rate_type_, company_,  customer_no_, ivc_head_rec_, use_ref_inv_curr_rate_);

               header_created_invoice_exist_ := FALSE; 
               FOR rec_ IN get_invoice_id(rma_no_, currency_rate_type_, 'CUSTORDCRE', company_, customer_no_ ) LOOP
                  -- Check invoice is created from rma line level or charge line level.
                  -- if so header_created_invoice_exist_ will remain FALSE.
                  IF NOT (Check_Pre_Created_Cre_Inv___(invoice_id_tab_, rec_.invoice_id)) THEN
                     header_created_invoice_exist_ := TRUE;
                  END IF;
               END LOOP;

               IF NOT (header_created_invoice_exist_)  THEN
                  invoice_id_ := NULL; 
                  -- If invoice head has not already created from the header, create a new invoice head.
                  Create_Invoice_Head_For_Rma___(invoice_id_, ivc_head_rec_, use_ref_inv_curr_rate_, currency_rate_type_, 'CUSTORDCRE', rma_rec_.use_price_incl_tax);
               END IF;  
            END IF;  
         END LOOP;
         
         currency_rate_type_ := NULL;     
         invoice_id_ := NULL;

         -- Check if there are RMA lines which are not connected to a CO 
         -- This RMA lines must belong to a invoice header of default currency rate type
         IF (co_not_connected_lines_exist_ ) THEN
            -- Create invoice heads for co not connected rma lines. 
            currency_rate_type_ := Invoice_Library_API.Get_Default_Currency_Type(company_, 'CUSTOMER', customer_no_);
            
            OPEN get_invoice_id(rma_no_, currency_rate_type_, 'CUSTORDCRE', company_, customer_no_ );
            FETCH get_invoice_id INTO exist_;
            IF (get_invoice_id%NOTFOUND) THEN
               CLOSE get_invoice_id;
               -- If invoice head has not already created for default currency rate type, create a new invoice head.
               Create_Invoice_Head_For_Rma___(invoice_id_, ivc_head_rec_, use_ref_inv_curr_rate_, currency_rate_type_, 'CUSTORDCRE', rma_rec_.use_price_incl_tax);
            ELSE
               CLOSE get_invoice_id;
               header_created_invoice_exist_ := FALSE;
               FOR rec_ IN get_invoice_id(rma_no_, currency_rate_type_, 'CUSTORDCRE', company_, customer_no_ ) LOOP
                  -- Check invoice is created from rma line level or charge line level.
                  -- if so header_created_invoice_exist_ will remain FALSE.
                  IF NOT (Check_Pre_Created_Cre_Inv___(invoice_id_tab_, rec_.invoice_id)) THEN
                     header_created_invoice_exist_ := TRUE;
                  END IF;
               END LOOP;

               IF NOT (header_created_invoice_exist_)  THEN
                  invoice_id_ := NULL;
                  -- If invoice head has not already created from the header and invoice head has already been created from rma line level or charge line level, create a new invoice head.
                  Create_Invoice_Head_For_Rma___(invoice_id_, ivc_head_rec_, use_ref_inv_curr_rate_, currency_rate_type_, 'CUSTORDCRE', rma_rec_.use_price_incl_tax);
      
               END IF;
            END IF; 
            

            currency_rate_type_ := NULL;
         END IF;

         IF (charge_lines_exist_ =  1) THEN
            -- Create Invoice heads for charge lines connected to a order.
            FOR rec_ IN get_co_connected_charges(rma_no_) LOOP
               
               IF ((rec_.currency_rate_type IS NULL) OR (NVL(rec_.currency_rate_type, Database_SYS.string_null_) != NVL(currency_rate_type_, Database_SYS.string_null_))) THEN  
                  
                  currency_rate_type_ := rec_.currency_rate_type;

                  Get_Ref_Inv_Curr_Rate_Type___(currency_rate_type_, company_,  customer_no_, ivc_head_rec_, use_ref_inv_curr_rate_);
                  
                  invoice_id_ := NULL;
                  
                  OPEN get_invoice_id(rma_no_, currency_rate_type_, 'CUSTORDCRE', company_, customer_no_ );
                  FETCH get_invoice_id INTO exist_;
                  IF (get_invoice_id%NOTFOUND) THEN
                     CLOSE get_invoice_id; 
                     -- If invoice head has not already created for default currency rate type, create a new invoice head.
                     Create_Invoice_Head_For_Rma___(invoice_id_, ivc_head_rec_, use_ref_inv_curr_rate_, currency_rate_type_, 'CUSTORDCRE', rma_rec_.use_price_incl_tax);
      
                  ELSE
                     CLOSE get_invoice_id; 
                     header_created_invoice_exist_ := FALSE;
                     FOR rec_ IN get_invoice_id(rma_no_, currency_rate_type_, 'CUSTORDCRE', company_, customer_no_ ) LOOP
                        -- Check invoice is created from rma line level or charge line level.
                        -- if so header_created_invoice_exist_ will remain FALSE.
                        IF NOT (Check_Pre_Created_Cre_Inv___(invoice_id_tab_, rec_.invoice_id)) THEN
                           header_created_invoice_exist_ := TRUE;
                        END IF;
                     END LOOP;

                     IF NOT (header_created_invoice_exist_)  THEN
                        invoice_id_ := NULL;
                        -- If invoice head has not created from the header and invoice head has already been created from rma line level or charge line level, create a new invoice head.
                        Create_Invoice_Head_For_Rma___(invoice_id_, ivc_head_rec_, use_ref_inv_curr_rate_, currency_rate_type_, 'CUSTORDCRE', rma_rec_.use_price_incl_tax);
      
                     END IF;
                  END IF;
                
               END IF;
            END LOOP;
            currency_rate_type_ := NULL;

            -- Create Invoice heads for charge lines not connected to a order.
            -- This charge lines must belong to a invoice header of default currency rate type.
            IF (co_not_conn_charges_exist_ ) THEN

               -- Create invoice heads for co not connected charge lines. 
               currency_rate_type_ := Invoice_Library_API.Get_Default_Currency_Type(company_, 'CUSTOMER', customer_no_);
               
               invoice_id_ := NULL;
               
               OPEN get_invoice_id(rma_no_, currency_rate_type_, 'CUSTORDCRE', company_, customer_no_ );
               FETCH get_invoice_id INTO exist_;
               IF (get_invoice_id%NOTFOUND) THEN
                  CLOSE get_invoice_id;
                  -- If invoice head has not already created for default currency rate type, create a new invoice head.
                  Create_Invoice_Head_For_Rma___(invoice_id_, ivc_head_rec_, use_ref_inv_curr_rate_, currency_rate_type_, 'CUSTORDCRE', rma_rec_.use_price_incl_tax);
      
               ELSE
                  CLOSE get_invoice_id;
                  header_created_invoice_exist_ := FALSE;
                  FOR rec_ IN get_invoice_id(rma_no_, currency_rate_type_, 'CUSTORDCRE', company_, customer_no_ ) LOOP
                     -- Check invoice is created from rma line level or charge line level.
                     -- if so header_created_invoice_exist_ will remain FALSE.
                     IF NOT (Check_Pre_Created_Cre_Inv___(invoice_id_tab_, rec_.invoice_id)) THEN
                        header_created_invoice_exist_ := TRUE;
                     END IF;
                  END LOOP;

                  IF NOT (header_created_invoice_exist_)  THEN
                     invoice_id_ := NULL;
                     -- If invoice head has not created from the header and invoice head has already been created from rma line level or charge line level, create a new invoice head.
                     Create_Invoice_Head_For_Rma___(invoice_id_, ivc_head_rec_, use_ref_inv_curr_rate_, currency_rate_type_, 'CUSTORDCRE', rma_rec_.use_price_incl_tax);
                  END IF;
               END IF;  
               currency_rate_type_ := NULL;  
            END IF;
         END IF; 

      END IF;
      
      -- Note : Add invoice items for RMA Lines
      -- Loop through all the RMA lines to fetch matching invoice id created from the header and insert the line 

      FOR invoice_line_ IN get_lines(rma_no_) LOOP
         IF (Return_Material_Line_API.Check_Exch_Charge_Order(rma_no_,invoice_line_.rma_line_no) = 'FALSE') THEN
            
            currency_rate_type_ := Customer_Order_API.get_currency_rate_type(invoice_line_.order_no);
            
            Get_Ref_Inv_Curr_Rate_Type___(currency_rate_type_, company_,  customer_no_, ivc_head_rec_, use_ref_inv_curr_rate_);

            self_billing_db_ := Customer_Order_Line_API.Get_Self_Billing_Db(invoice_line_.order_no, invoice_line_.line_no, invoice_line_.rel_no, invoice_line_.line_item_no);

            IF (nvl(self_billing_db_, ' ') = 'SELF BILLING') THEN
               invoice_type_ := 'SELFBILLCRE';
            ELSE
               invoice_type_ := 'CUSTORDCRE';
            END IF;

            FOR rec_ IN get_invoice_id(rma_no_, currency_rate_type_, invoice_type_, company_, customer_no_ ) LOOP
               -- Invoice line is inserted only if the invoice was not created from the rma line level or charge line level before. 
               IF NOT (Check_Pre_Created_Cre_Inv___(invoice_id_tab_, rec_.invoice_id)) THEN
                  Credit_Returned_Line___(rma_no_, invoice_line_.rma_line_no, rec_.invoice_id, rma_rec_, use_ref_inv_curr_rate_);
                  EXIT;
               END IF;
            END LOOP;  

            currency_rate_type_ := NULL;

         END IF;
      END LOOP;

      -- Add invoice items for RMA Charges which are connected to a order.
      -- Loop through charge lines which are connected to a CO to fetch matching CUSTORDCRE invoice id created from the header and insert the line. 

      FOR invoice_charge_ IN get_co_connected_charges(rma_no_) LOOP
         
         currency_rate_type_ := Customer_Order_API.Get_Currency_Rate_Type(invoice_charge_.order_no);
         
         IF (currency_rate_type_ IS NULL) THEN
            currency_rate_type_ := Invoice_Library_API.Get_Default_Currency_Type(company_, 'CUSTOMER', customer_no_);
         END IF;

         FOR rec_ IN get_invoice_id(rma_no_, currency_rate_type_, 'CUSTORDCRE', company_, customer_no_ ) LOOP
            -- Charge line is inserted only if the invoice was not created from the rma line level or charge line level before. 
            IF NOT (Check_Pre_Created_Cre_Inv___(invoice_id_tab_, rec_.invoice_id)) THEN
               Credit_Returned_Charge___(rma_no_, invoice_charge_.rma_charge_no, rec_.invoice_id, rma_rec_, use_ref_inv_curr_rate_);
               EXIT;
            END IF;
         END LOOP; 

      END LOOP;

      -- Add invoice items for RMA Charges which are not connected to a order.
      IF (co_not_conn_charges_exist_ ) THEN 
         currency_rate_type_ := Invoice_Library_API.Get_Default_Currency_Type(company_, 'CUSTOMER', customer_no_);
            
         FOR invoice_charge_ IN get_co_not_connected_charges(rma_no_) LOOP
            FOR rec_ IN get_invoice_id(rma_no_, currency_rate_type_, 'CUSTORDCRE', company_, customer_no_ ) LOOP
               -- Charge line is inserted only if the invoice was not created from the rma line level or charge line level before. 
               IF NOT (Check_Pre_Created_Cre_Inv___(invoice_id_tab_, rec_.invoice_id)) THEN
                  Credit_Returned_Charge___(rma_no_, invoice_charge_.rma_charge_no, rec_.invoice_id, rma_rec_, use_ref_inv_curr_rate_);
                  EXIT;
               END IF;
            END LOOP; 
         END LOOP; 
                  
      END IF;   

      FOR rec_ IN get_all_invoices(rma_no_, company_, customer_no_ ) LOOP
         -- Completing only the invoices that were created from the header. 
         -- The invoices created from RMA should be excluded from adding invoice_fee amount
         IF NOT (Check_Pre_Created_Cre_Inv___(invoice_id_tab_, rec_.invoice_id)) THEN
            Customer_Order_Inv_Head_API.Create_Invoice_Complete(ivc_head_rec_.company, rec_.invoice_id, 'FALSE');
         END IF;
      END LOOP;

   ELSIF (rma_line_no_ IS NOT NULL) THEN
      rma_line_rec_ := Return_Material_Line_API.Get(rma_no_, rma_line_no_);
      cust_part_no_ := Customer_Order_Line_API.Get_Customer_Part_No(rma_line_rec_.order_no,rma_line_rec_.line_no, rma_line_rec_.rel_no, rma_line_rec_.line_item_no);
      IF (rma_line_rec_.order_no IS NOT NULL) THEN
         currency_rate_type_ := Customer_Order_API.Get_Currency_Rate_Type(rma_line_rec_.order_no);
      END IF;
      self_billing_db_ := Customer_Order_Line_API.Get_Self_Billing_Db(rma_line_rec_.order_no,rma_line_rec_.line_no, rma_line_rec_.rel_no, rma_line_rec_.line_item_no);
      
      IF (nvl(self_billing_db_, ' ') = 'SELF BILLING') THEN
         self_billing_ := TRUE;
      END IF;

      IF ((nvl(self_billing_db_, ' ') = 'NOT SELF BILLING') OR (cust_part_no_ IS NULL)) THEN
         not_self_billing_ := TRUE;
      END IF;

      IF (Return_Material_Line_API.Check_Exch_Charge_Order(rma_no_, rma_line_no_) = 'FALSE') THEN
         return_ := TRUE;
      END IF;

      IF self_billing_ THEN
         Create_Invoice_Head_For_Rma___(sbi_invoice_id_, ivc_head_rec_, use_ref_inv_curr_rate_, currency_rate_type_, 'SELFBILLCRE', rma_rec_.use_price_incl_tax);
         IF return_ THEN
            Credit_Returned_Line___(rma_no_, rma_line_no_, sbi_invoice_id_, rma_rec_, use_ref_inv_curr_rate_);
         END IF;
         -- The invoices created from RMA line should be excluded from adding invoice_fee amount
         Customer_Order_Inv_Head_API.Create_Invoice_Complete(ivc_head_rec_.company, sbi_invoice_id_, 'FALSE');
      ELSIF not_self_billing_ THEN
         Create_Invoice_Head_For_Rma___(invoice_id_, ivc_head_rec_, use_ref_inv_curr_rate_, currency_rate_type_, 'CUSTORDCRE', rma_rec_.use_price_incl_tax);
         IF return_ THEN
            Credit_Returned_Line___(rma_no_, rma_line_no_, invoice_id_, rma_rec_, use_ref_inv_curr_rate_);
         END IF;
         -- The invoices created from RMA should be excluded from adding invoice_fee amount
         Customer_Order_Inv_Head_API.Create_Invoice_Complete(ivc_head_rec_.company, invoice_id_, 'FALSE');
      END IF;

   ELSE
      order_no_ := Return_Material_Charge_API.Get_Order_No(rma_no_, rma_charge_no_);
      IF (order_no_ IS NOT NULL) THEN
         currency_rate_type_ := Customer_Order_API.Get_Currency_Rate_Type(order_no_);
      END IF;
      Create_Invoice_Head_For_Rma___(invoice_id_, ivc_head_rec_, use_ref_inv_curr_rate_, currency_rate_type_, 'CUSTORDCRE', rma_rec_.use_price_incl_tax);
      Credit_Returned_Charge___(rma_no_, rma_charge_no_, invoice_id_, rma_rec_, use_ref_inv_curr_rate_);
      -- The invoices created from RMA should be excluded from adding invoice_fee amount
      Customer_Order_Inv_Head_API.Create_Invoice_Complete(ivc_head_rec_.company, invoice_id_, 'FALSE');
   END IF;

END Create_Invoice_From_Return__;


-- Create_Collect_Ivc_Ord__
--   Create collective invoices for selected customer orders passed in to
--   the attribute string
PROCEDURE Create_Collect_Ivc_Ord__ (
   header_order_no_ IN VARCHAR2 )
IS
   head_order_no_                 CUSTOMER_ORDER_TAB.order_no%TYPE;
   invoice_id_                    NUMBER := NULL;
   collective_                    VARCHAR2(5) := 'TRUE';
   company_                       VARCHAR2(20);
   contract_                      CUSTOMER_ORDER_TAB.contract%TYPE;
   currency_code_                 CUSTOMER_ORDER_TAB.currency_code%TYPE;
   customer_po_no_                CUSTOMER_ORDER_TAB.customer_po_no%TYPE;
   internal_po_no_                CUSTOMER_ORDER_TAB.internal_po_no%TYPE;
   cust_po_no_                    VARCHAR2(50);
   wanted_del_date_               DATE;
   temp_date_                     DATE;
   ignore_closing_date_           VARCHAR2(10);
   closest_closing_date_          DATE;
   lines_invoiced_                BOOLEAN;
   no_invoiced_lines              EXCEPTION;
   info_                          VARCHAR2(2000);
   order_state_                   VARCHAR2(20);
   cust_ref_                      VARCHAR2(100);
   cust_ref_per_order_            BOOLEAN := TRUE;
   cust_no_pay_exist_             BOOLEAN := FALSE;   
   temp_no_pay_ref_               VARCHAR2(30);
   cust_ord_rec_                  CUSTOMER_ORDER_API.Public_Rec;
   cust_contact_                  BOOLEAN := FALSE;
   temp_cust_ref_                 VARCHAR2(100);
   -- 148946, end
   -- gelr:invoice_reason, begin
   invoice_reason_id_             CUSTOMER_ORDER_TAB.invoice_reason_id%TYPE;
   -- gelr:invoice_reason, end
   copy_from_tax_source_arr_    Tax_Handling_Util_API.source_key_arr := Tax_Handling_Util_API.source_key_arr();
   copy_to_tax_source_arr_      Tax_Handling_Util_API.source_key_arr := Tax_Handling_Util_API.source_key_arr();
   
   CURSOR get_head_data_from_first_order IS
      SELECT co.customer_no, co.authorize_code,
             co.date_entered, co.bill_addr_no, co.customer_no_pay,
             co.customer_no_pay_addr_no, co.customer_po_no,
             co.delivery_terms, co.del_terms_location, co.forward_agent_id,
             co.ship_via_code, co.ship_addr_no, NVL(co.internal_po_label_note, co.label_note) label_note, co.note_id,
             co.wanted_delivery_date, co.currency_code, co.pay_term_id, co.jinsui_invoice, currency_rate_type, co.project_id, 
             co.use_price_incl_tax, co.language_code
      FROM   customer_order_tab co
      WHERE  head_order_no_ = co.order_no
      AND    (EXISTS (SELECT 1
                      FROM   customer_order_delivery_tab cod
                      WHERE  co.order_no = cod.order_no
                      AND    ((cod.shipment_id IS NULL)
                      AND    ((ignore_closing_date_ = 'TRUE')
                      OR     (TRUNC(cod.date_delivered) <= TRUNC(closest_closing_date_)))
                      OR     (cod.shipment_id IS NOT NULL))
                      AND    cod.cancelled_delivery = 'FALSE')
      OR NOT EXISTS  (SELECT 1
                      FROM   customer_order_delivery_tab cod
                      WHERE  co.order_no = cod.order_no
                      AND    cod.cancelled_delivery = 'FALSE'));

   ivc_head_data_  get_head_data_from_first_order%ROWTYPE;
   tax_liability_country_rec_ Tax_Liability_Countries_API.Public_Rec; 
   customer_liability_date_type_ VARCHAR2(20);
   customer_liability_date_ DATE; 
   tax_liability_country_db_ VARCHAR2(2);
   
   CURSOR get_header_order_flags IS
      SELECT ignore_closing_date, closest_closing_date, tax_liability_country     
      FROM BATCH_COLLECT_IVC_ORDERS_TAB
      WHERE head_order_no = header_order_no_
      AND order_no = header_order_no_;

   max_rows_            PLS_INTEGER := 10000;
   CURSOR get_buffered_order_list  IS 
      SELECT bio.head_order_no, bio.order_no, bio.ignore_closing_date, bio.closest_closing_date
      FROM BATCH_COLLECT_IVC_ORDERS_TAB bio, CUSTOMER_ORDER_TAB co
      WHERE bio.head_order_no = header_order_no_
      AND bio.order_no = co.order_no
      ORDER BY co.date_entered, co.order_no;
      
	CURSOR get_head_order_no  IS 
      SELECT co.order_no
      FROM BATCH_COLLECT_IVC_ORDERS_TAB bio, CUSTOMER_ORDER_TAB co
      WHERE bio.head_order_no = header_order_no_
      AND bio.order_no = co.order_no
      ORDER BY co.date_entered, co.order_no
      FETCH FIRST 1 ROWS ONLY;
   TYPE Buffered_Orders_Tab IS TABLE OF get_buffered_order_list%ROWTYPE
   INDEX BY PLS_INTEGER;
   buffered_order_list_ Buffered_Orders_Tab;
   
   -- gelr:fr_service_code, begin
   CURSOR count_distinct_serv_codes IS
      SELECT COUNT(DISTINCT NVL(service_code, ' '))
      FROM   customer_order_tab
      WHERE  order_no IN (SELECT order_no FROM BATCH_COLLECT_IVC_ORDERS_TAB);

   service_code_              VARCHAR2(100);
   dummy_                     NUMBER;
   -- gelr:fr_service_code, end
BEGIN
   -- Note : Loop through all orderlines that will be included in this collective invoice.
   -- Head order number will be the 1st selected order and the Invoice Header will pick data from this.
   OPEN  get_head_order_no;
   FETCH get_head_order_no INTO head_order_no_ ;
   CLOSE get_head_order_no;
   OPEN get_header_order_flags;
   FETCH get_header_order_flags INTO ignore_closing_date_, closest_closing_date_, tax_liability_country_db_;
   CLOSE get_header_order_flags;

   temp_date_ := Customer_Order_API.Get_Wanted_Delivery_Date(head_order_no_);
   OPEN get_buffered_order_list;
   LOOP
       FETCH get_buffered_order_list BULK COLLECT INTO buffered_order_list_ LIMIT max_rows_;
       EXIT WHEN buffered_order_list_.COUNT = 0;
         
       IF (buffered_order_list_.COUNT > 0) THEN
          FOR i IN buffered_order_list_.first .. buffered_order_list_.last LOOP
             IF (wanted_del_date_ < temp_date_) THEN
                temp_date_ := wanted_del_date_;
             END IF;
             cust_ord_rec_ := Customer_Order_API.Get(buffered_order_list_(i).order_no);
             IF (cust_ord_rec_.customer_no_pay IS NOT NULL) THEN 
                cust_no_pay_exist_ := TRUE;
                IF (i = 1)THEN
                   temp_no_pay_ref_ := cust_ord_rec_.customer_no_pay_ref;
                END IF;
                IF(temp_no_pay_ref_ != cust_ord_rec_.customer_no_pay_ref)THEN
                   cust_contact_ := TRUE;
                   EXIT;
                END IF;
             ELSE
                IF (i = 1)THEN
                   temp_cust_ref_:= cust_ord_rec_.cust_ref;
                END IF;
                IF(temp_cust_ref_ != cust_ord_rec_.cust_ref)THEN
                   cust_ref_per_order_ := FALSE;
                END IF;           
             END IF;
          END LOOP;
       END IF;
   END LOOP;
   CLOSE get_buffered_order_list;
   cust_ord_rec_ := Customer_Order_API.Get(head_order_no_);
   IF (cust_no_pay_exist_ AND cust_contact_ = FALSE ) THEN 
      cust_ref_ := Customer_Order_API.Get_Customer_No_Pay_Ref(head_order_no_);
   ELSIF (cust_contact_) THEN 
      cust_ref_ := Cust_Ord_Customer_API.Fetch_Cust_Ref(cust_ord_rec_.customer_no_pay, cust_ord_rec_.customer_no_pay_addr_no, 'TRUE');
   ELSIF (cust_ref_per_order_ AND cust_no_pay_exist_ = FALSE ) THEN
      cust_ref_ := Customer_Order_API.Get_Cust_Ref(head_order_no_);
   END IF;
   
   contract_ := Customer_Order_API.Get_Contract(head_order_no_);
   company_ := Site_API.Get_Company(contract_);
   
   @ApproveTransactionStatement(2014-09-18,darklk)
   SAVEPOINT before_header_creation;

   OPEN get_head_data_from_first_order;
   FETCH get_head_data_from_first_order INTO ivc_head_data_;
   
   customer_liability_date_type_ := Tax_Liability_Date_Ctrl_API.Get_Customer_Liability_Date_Db(company_);

   IF (get_head_data_from_first_order%FOUND) THEN
      IF invoice_id_ IS NULL THEN
         ivc_head_data_.wanted_delivery_date := temp_date_;
         
         -- customer liability date is fetched from Tax Liability Date Control.
         -- if the date is VOUCHERDATE or INVOICEDATE we use the invoice_date becuase 
         -- vouchers are not created when are calling this method.
         IF customer_liability_date_type_ = 'DELIVERYDATE' THEN
            customer_liability_date_ := ivc_head_data_.wanted_delivery_date;
         ELSE
            customer_liability_date_ := ivc_head_data_.date_entered;
         END IF;
         
         tax_liability_country_rec_ := Tax_Liability_Countries_API.Get_Valid_Tax_Info(company_, tax_liability_country_db_, customer_liability_date_);
         -- gelr:invoice_reason, begin
         IF (Company_Localization_Info_API.Get_Parameter_Value_Db(company_, 'INVOICE_REASON') = Fnd_Boolean_API.DB_TRUE) THEN 
            invoice_reason_id_ := Identity_Invoice_Info_API.Get_Invoice_Reason_Id(company_, ivc_head_data_.customer_no, Party_Type_API.Decode(Party_Type_API.DB_CUSTOMER));
         END IF;
         -- gelr:invoice_reason, end
         -- gelr:fr_service_code, begin
         IF (Company_Localization_Info_API.Get_Parameter_Value_Db(company_, 'FR_SERVICE_CODE') = Fnd_Boolean_API.DB_TRUE) THEN
            OPEN count_distinct_serv_codes;
            FETCH count_distinct_serv_codes INTO dummy_;
            CLOSE count_distinct_serv_codes;
            
            IF (dummy_ > 1) THEN
               service_code_ := NULL;
            ELSE
               service_code_ := Customer_Order_API.Get_Service_Code(head_order_no_);
            END IF;
         END IF;
         -- gelr:fr_service_code, end
         
         --Creates Invoice Header
         Customer_Order_Inv_Head_API.Create_Invoice_Head(
                                        invoice_id_, --invoice_id_
                                        company_, --company_
                                        NULL, --order_no_
                                        ivc_head_data_.customer_no, --customer_no_
                                        ivc_head_data_.customer_no_pay, --customer_no_pay_
                                        Order_Coordinator_API.Get_Name(ivc_head_data_.authorize_code), --authorize_name_
                                        ivc_head_data_.date_entered, --date_entered_
                                        cust_ref_, --cust_ref_
                                        Mpccom_Ship_Via_API.Get_Description(ivc_head_data_.ship_via_code, ivc_head_data_.language_code), --ship_via_desc_
                                        ivc_head_data_.forward_agent_id, --forward_agent_id_
                                        ivc_head_data_.label_note, --label_note_
                                        Order_Delivery_Term_API.Get_Description(ivc_head_data_.delivery_terms, ivc_head_data_.language_code), --delivery_terms_desc_
                                        ivc_head_data_.del_terms_location, --del_terms_location_
                                        ivc_head_data_.pay_term_id, --pay_term_id_
                                        ivc_head_data_.currency_code, --currency_code_
                                        ivc_head_data_.ship_addr_no, --ship_addr_no_
                                        ivc_head_data_.customer_no_pay_addr_no, --customer_no_pay_addr_no_
                                        ivc_head_data_.bill_addr_no, --bill_addr_no_
                                        ivc_head_data_.wanted_delivery_date, --wanted_delivery_date_
                                        'CUSTCOLDEB', --invoice_type_
                                        NULL, -- number_reference
                                        NULL, -- series_reference
                                        contract_, --contract_
                                        Get_Js_Invoice_State_Db___(ivc_head_data_.jinsui_invoice), --js_invoice_state_db_
                                        ivc_head_data_.currency_rate_type, --currency_rate_type_
                                        collective_, --collect_
                                        NULL, -- rma_no_                  
                                        NULL, -- shipment_id_             
                                        NULL, -- adv_invoice_             
                                        NULL, -- adv_pay_base_date_       
                                        NULL, -- sb_reference_no_         
                                        'FALSE', --use_ref_inv_curr_rate_   
                                        NULL, --ledger_item_id_          
                                        NULL, -- ledger_item_series_id_      
                                        NULL, -- ledger_item_version_id_ 
                                        NULL, --aggregation_no_
                                        'FALSE', --final_settlement_
                                        ivc_head_data_.project_id, --project_id_
                                        tax_liability_country_rec_.tax_id_number, --tax_id_number_
                                        tax_liability_country_rec_.tax_id_type, --tax_id_type_
                                        tax_liability_country_rec_.branch, --branch
                                        tax_liability_country_db_, --supply_country_db_
                                        NULL, --invoice_date_
                                        ivc_head_data_.use_price_incl_tax, --use_price_incl_tax_
                                        NULL, --wht_amount_base_
                                        NULL, --curr_rate_new_
                                        NULL, --tax_curr_rate_new_
                                        NULL, --correction_reason_id_
                                        NULL, --correction_reason_
                                        'FALSE', --is_simulated_
                                        invoice_reason_id_,--invoice_reason_id_
                                        service_code_ => service_code_); --service_code_                                                   
      END IF;
      
      IF (invoice_id_ IS NOT NULL) THEN
         OPEN get_buffered_order_list;
         LOOP
             FETCH get_buffered_order_list BULK COLLECT INTO buffered_order_list_ LIMIT max_rows_;
             EXIT WHEN buffered_order_list_.COUNT = 0;
               
             IF (buffered_order_list_.COUNT > 0) THEN
                FOR i IN buffered_order_list_.first .. buffered_order_list_.last LOOP
                   currency_code_  := Customer_Order_API.Get_Currency_Code(buffered_order_list_(i).order_no);
                   customer_po_no_ := Customer_Order_API.Get_Customer_Po_No(buffered_order_list_(i).order_no);
                   internal_po_no_ := Customer_Order_API.Get_Internal_Po_No(buffered_order_list_(i).order_no);

                    IF (internal_po_no_ IS NOT NULL) THEN
                       cust_po_no_ := internal_po_no_;
                    ELSE
                       cust_po_no_ := customer_po_no_;
                    END IF;
                    lines_invoiced_:= FALSE;

                    Customer_Order_History_API.New(buffered_order_list_(i).order_no,
                          Language_SYS.Translate_Constant(lu_name_, 'CRECOLLINVOICE: Collective invoice :P1 created', NULL, invoice_id_));

                    -- Note : set the Commission Recalc Flag to true: data have changed, commission should/may be recalculated.
                    Order_Line_Commission_API.Set_Order_Com_Lines_Changed(buffered_order_list_(i).order_no);

                    Create_Invoice_Lines___( copy_from_tax_source_arr_,
                                             copy_to_tax_source_arr_,
                                             lines_invoiced_,
                                             buffered_order_list_(i).order_no,
                                             invoice_id_,
                                             cust_po_no_,
                                             ignore_closing_date_,
                                             closest_closing_date_,
                                             NULL,
                                             tax_liability_country_db_);

                     
                    order_state_ := Customer_Order_API.Get_Objstate(buffered_order_list_(i).order_no);
 
                    IF (order_state_ = 'Blocked') THEN
                       Customer_Order_API.Release_Blocked(buffered_order_list_(i).order_no);
                    END IF;
                    IF NOT lines_invoiced_ THEN
                       CLOSE get_buffered_order_list;
                       CLOSE get_head_data_from_first_order;
                       RAISE no_invoiced_lines;
                    END IF;

                    $IF Component_Pcmsci_SYS.INSTALLED $THEN
                        Psc_Inv_Line_Util_API.Update_Product_Invoice(buffered_order_list_(i).order_no, company_, invoice_id_);
                    $END
                 END LOOP;
                 
             END IF;     
         END LOOP;  -- Loop until all orders are invoiced
         CLOSE get_buffered_order_list;
         CLOSE get_head_data_from_first_order;
         
         IF (copy_from_tax_source_arr_.COUNT > 0 ) THEN 
            Transfer_Ext_Tax_Lines___ (copy_from_tax_source_arr_,
                                       copy_to_tax_source_arr_,
                                       company_,
                                       invoice_id_);
         END IF;
      ELSE
         CLOSE get_head_data_from_first_order;
         RAISE no_invoiced_lines;
      END IF;
   ELSE
      RAISE no_invoiced_lines;
   END IF;
   
   IF (invoice_id_ IS NOT NULL AND lines_invoiced_) THEN
      Customer_Order_Inv_Head_API.Create_Invoice_Complete(company_, invoice_id_);
      Cust_Ord_Customer_API.Modify_Last_Ivc_Date(ivc_head_data_.customer_no);
   END IF;
   Clear_Batch_Coll_Ivc_Orders__(head_order_no_);
EXCEPTION
   WHEN  no_invoiced_lines THEN
      @ApproveTransactionStatement(2014-09-18,darklk)
      ROLLBACK TO before_header_creation;
      Clear_Batch_Coll_Ivc_Orders__(head_order_no_);
      info_ := Language_SYS.Translate_Constant(lu_name_, 'NOINVOICE: There are no customer order lines available to create the collective customer invoice');
      Transaction_SYS.Set_Status_Info(info_);
   WHEN OTHERS THEN 
       Clear_Batch_Coll_Ivc_Orders__(head_order_no_);
       RAISE;
END Create_Collect_Ivc_Ord__;


-- Make_Collect_Ivc_Ord__
--   Is called by the client only in order to make a Transaction_SYS.Deferred_Call.
--   This method calls Create_Collect_Ivc_Ord__.
PROCEDURE Make_Collect_Ivc_Ord__ (
   header_order_no_ IN VARCHAR2 )
IS
   desc_   VARCHAR2(200);
BEGIN
   desc_ := Language_SYS.Translate_Constant(lu_name_, 'CRE_COLLINV_PER_ORD: Create Collective Customer Invoices Per Order');
   Transaction_SYS.Deferred_Call('INVOICE_CUSTOMER_ORDER_API.Create_Collect_Ivc_Ord__', header_order_no_, desc_);
END Make_Collect_Ivc_Ord__;


-- Get_Cred_Amt_Per_Db_Ivc__
--   Returns the total credited amount for a particular debit invoice.
@UncheckedAccess
FUNCTION Get_Cred_Amt_Per_Db_Ivc__ (
   company_    IN VARCHAR2,
   invoice_no_ IN VARCHAR2,
   series_id_  IN VARCHAR2 ) RETURN NUMBER
IS
   credited_amount_ NUMBER;
   invoice_type_    VARCHAR2(20);

   CURSOR get_credited_amt IS
      SELECT SUM(gross_curr_amount)
        FROM customer_order_inv_item
       WHERE number_reference = invoice_no_
         AND series_reference = series_id_
         AND company          = company_
         AND invoice_type IN ('CUSTORDCRE','CUSTCOLCRE', 'SELFBILLCRE', invoice_type_);
BEGIN
   invoice_type_ := Company_Def_Invoice_Type_API.Get_Def_Adv_Co_Cr_Inv_Type(company_);
   OPEN get_credited_amt  ;
   FETCH get_credited_amt INTO credited_amount_;
   CLOSE get_credited_amt;

   RETURN ABS(NVL(credited_amount_,0));
END Get_Cred_Amt_Per_Db_Ivc__;



-- Make_Shipment_Invoice__
--   Create invoices for all the shipments passed in the attribute string by making a deferred call. If the
--   shipment_id is paased that means this comes from the shipment flow. In this case, if multiple invoices
--   are getting created, it will raise en error. If not will create a single shipment invoice.
PROCEDURE Make_Shipment_Invoice__ (
   invoice_id_  OUT     NUMBER,
   attr_        IN OUT  VARCHAR2,
   shipment_id_ IN      NUMBER )
IS
   invoice_attr_  VARCHAR2(32000);
   count_         NUMBER := 0;
   ptr_           NUMBER;
   name_          VARCHAR2(30);
   value_         VARCHAR2(2000);
   description_   VARCHAR2(200);
   -- The Customer_Order_Ship_Invoice will be created in post installation
   -- Therefore added ORDER check (intially it will be false) in order to skip in intial deployment of the package.
   $IF (Component_Order_SYS.INSTALLED) $THEN
      CURSOR get_shipment IS
         SELECT customer_no, contract, currency_code, pay_term_id, jinsui_invoice, bill_addr_no, currency_rate_type
         FROM   CUSTOMER_ORDER_SHIP_INVOICE
         WHERE  shipment_id       = shipment_id_;
   $END   
BEGIN

   IF (shipment_id_ IS NOT NULL) THEN
      $IF (Component_Order_SYS.INSTALLED) $THEN
         FOR rec_ IN get_shipment LOOP
            count_ := count_ + 1;
            IF (count_ > 1) THEN
               Error_SYS.Record_General(lu_name_, 'TOOMANYRECSFOUND: Several shipment invoices will be created for shipment :P1, therefore shipment invoice cannot be created automatically in the shipment flow.', shipment_id_);
            END IF;
            Client_SYS.Add_To_Attr('CUSTOMER_NO',        rec_.customer_no,        invoice_attr_);
            Client_SYS.Add_To_Attr('SHIPMENT_ID',        shipment_id_,            invoice_attr_);
            Client_SYS.Add_To_Attr('CONTRACT',           rec_.contract,           invoice_attr_);
            Client_SYS.Add_To_Attr('CURRENCY_CODE',      rec_.currency_code,      invoice_attr_);
            Client_SYS.Add_To_Attr('PAY_TERM_ID',        rec_.pay_term_id,        invoice_attr_);
            Client_SYS.Add_To_Attr('JINSUI_INVOICE_DB',  rec_.jinsui_invoice,     invoice_attr_);
            Client_SYS.Add_To_Attr('BILL_ADDR_NO',       rec_.bill_addr_no,       invoice_attr_);
            Client_SYS.Add_To_Attr('CURRENCY_RATE_TYPE', rec_.currency_rate_type, invoice_attr_);
         END LOOP;
      $END
      Create_Shipment_Invoice__(invoice_attr_);
      invoice_id_ := Client_SYS.Get_Item_Value('INVOICE_ID', invoice_attr_);
   ELSE
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      Client_SYS.Add_To_Attr(name_, value_, invoice_attr_);
         IF (name_ = 'CURRENCY_RATE_TYPE') THEN
         -- Create invoice for the shipment
         description_ := Language_SYS.Translate_Constant(lu_name_, 'CRE_SHIPINV: Create Shipment Invoices');
         Transaction_SYS.Deferred_Call('INVOICE_CUSTOMER_ORDER_API.Create_Shipment_Invoice__', invoice_attr_, description_);
         Client_SYS.Clear_Attr(invoice_attr_);
      END IF;
   END LOOP;
   END IF; 
END Make_Shipment_Invoice__;


-- Create_Shipment_Invoice__
--   Create collective invoice for the shipment passed in the attribute
PROCEDURE Create_Shipment_Invoice__ (
   attr_ IN OUT VARCHAR2 )
IS
   ptr_                NUMBER;
   name_               VARCHAR2(30);
   value_              VARCHAR2(2000);
   -- The Customer_Order_Ship_Invoice will be created in post installation
   -- Therefore added ORDER check (intially it will be false) in order to skip in intial deployment of the package.
   $IF (Component_Order_SYS.INSTALLED) $THEN
      newrec_          CUSTOMER_ORDER_SHIP_INVOICE%ROWTYPE;
   $END   
   jinsui_invoice_db_  VARCHAR2(5);
   currency_rate_type_ VARCHAR2(10);
   invoice_id_         NUMBER;
BEGIN
   $IF (Component_Order_SYS.INSTALLED) $THEN
      WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
         IF (name_ = 'CUSTOMER_NO') THEN
            newrec_.customer_no := value_;
            Cust_Ord_Customer_API.Exist(newrec_.customer_no);
         ELSIF (name_ = 'SHIPMENT_ID') THEN
            newrec_.shipment_id := value_;
            Shipment_API.Exist(newrec_.shipment_id);
         ELSIF (name_ = 'CONTRACT') THEN
            newrec_.contract := value_;
            Site_API.Exist(newrec_.contract);
         ELSIF (name_ = 'CURRENCY_CODE') THEN
            newrec_.currency_code := value_;
            Iso_Currency_API.Exist(newrec_.currency_code);
         ELSIF (name_ = 'PAY_TERM_ID') THEN
            newrec_.pay_term_id := value_;
            Payment_Term_API.Exist(Site_API.Get_Company(newrec_.contract), newrec_.pay_term_id);
         ELSIF (name_ = 'JINSUI_INVOICE_DB') THEN
            jinsui_invoice_db_ := value_;
         ELSIF (name_ = 'BILL_ADDR_NO') THEN
            newrec_.bill_addr_no := value_;
            Customer_Info_Address_API.Exist(newrec_.customer_no, newrec_.bill_addr_no);
         ELSIF (name_ = 'CURRENCY_RATE_TYPE') THEN
            currency_rate_type_ := value_;
         ELSE
            Error_SYS.Item_Not_Exist(lu_name_, name_, value_);
         END IF;
      END LOOP;

      Create_Shipment_Invoice___(invoice_id_,
                                 newrec_.shipment_id,
                                 newrec_.customer_no,
                                 newrec_.contract,
                                 newrec_.currency_code,
                                 newrec_.pay_term_id,
                                 newrec_.bill_addr_no,
                                 jinsui_invoice_db_,
                                 currency_rate_type_,
                                 Shipment_Freight_API.Get_Use_Price_Incl_Tax_Db(newrec_.shipment_id));
   $END
   Client_SYS.Add_To_Attr('INVOICE_ID', invoice_id_, attr_);
END Create_Shipment_Invoice__;


-- Chk_Prev_Credit_Invoices__
--   Checks whether an exisiting credit invoice exists, for the given debit
--   invoice, and if true , displays a warning message.
--   Note: This method is only used in Web. This method is to be removed once
--   the Web client removes this call.
PROCEDURE Chk_Prev_Credit_Invoices__ (
   info_       IN OUT VARCHAR2,
   order_no_   IN     VARCHAR2,
   invoice_no_ IN     VARCHAR2,
   company_    IN     VARCHAR2,
   series_id_  IN     VARCHAR2 )
IS
   cr_amount_           NUMBER;
   debit_inv_cr_amount_ NUMBER;
   message1_            VARCHAR2(280);
   message2_            VARCHAR2(150);
   exist_               NUMBER;
   cor_inv_type_        VARCHAR2(20);
   col_inv_type_        VARCHAR2(20);

   CURSOR corr_inv_exist IS
      SELECT 1
        FROM customer_order_inv_head h
       WHERE h.company = company_
         AND h.number_reference = invoice_no_
         AND h.series_reference = series_id_
         AND h.invoice_type IN (cor_inv_type_, col_inv_type_) ;
BEGIN

   IF (order_no_ IS NOT NULL) THEN
      cr_amount_ := Get_Credited_Amt_Per_Order(order_no_);
      debit_inv_cr_amount_ := Get_Cred_Amt_Per_Db_Ivc__(company_, invoice_no_, series_id_);
     IF (cr_amount_ != 0)  THEN
         IF (debit_inv_cr_amount_ != 0) THEN
            message1_ := series_id_ || invoice_no_;
            message2_ := order_no_ ||': '|| cr_amount_;
            Client_SYS.Add_Info(lu_name_, 'CRINVEXISTFORDEBINV: Credit invoice(s) for invoice :P1'
                                           ||' already exists with credit amount :P2' ||'. Total credit amount for order :P3',
                                           message1_, debit_inv_cr_amount_, message2_);
         ELSE
            Client_SYS.Add_Info(lu_name_, 'CRINVEXIST: Credit Invoice(s) already exists for order :P1'
                                       ||' and the credited amount is :P2', order_no_, cr_amount_ );
         END IF;
      END IF;
   ELSE
      cr_amount_ := Get_Cred_Amt_Per_Db_Ivc__(company_, invoice_no_, series_id_);
      IF (cr_amount_ != 0)  THEN
         Client_SYS.Add_Info(lu_name_, 'CRDEBINVEXIST: Credit Invoice(s) already exists for the debit invoice :P1'
                                       ||' and the credited amount is :P2', invoice_no_, cr_amount_ );
      END IF;
   END IF;

   cor_inv_type_ := Company_Def_Invoice_Type_API.Get_Def_Co_Cor_Inv_Type(company_);
   col_inv_type_ := Company_Def_Invoice_Type_API.Get_Def_Col_Cor_Inv_Type(company_);

   OPEN corr_inv_exist;
   FETCH corr_inv_exist INTO exist_;
   IF (corr_inv_exist%FOUND) THEN
      Client_SYS.Add_Info(lu_name_, 'CORRINVEXIST: Correction invoice exist for the reference invoice :P1.', invoice_no_);
   END IF;
   CLOSE corr_inv_exist;

   info_ := Client_SYS.Get_All_Info;
END Chk_Prev_Credit_Invoices__;


-- Create_Advance_Invoice__
--   This method is used to create an Advance Invoice
PROCEDURE Create_Advance_Invoice__ (
   invoice_id_    IN OUT VARCHAR2,
   order_no_      IN     VARCHAR2,
   adv_pay_amt_   IN     NUMBER,
   tax_msg_       IN     VARCHAR2,
   invoice_text_  IN     VARCHAR2,
   pay_base_date_ IN     DATE,
   pay_term_id_   IN     VARCHAR2,
   pay_tax_       IN     VARCHAR2 )
IS  
   company_                   VARCHAR2(20);
   tax_liability_type_db_     VARCHAR2(20);
   cust_tax_liability_        VARCHAR2(20);   
   tax_code_                  VARCHAR2(20);
   tax_liability_country_db_  VARCHAR2(2);   
   gross_amt_                 NUMBER := 0;
   net_amt_                   NUMBER := 0;
   tax_percentage_            NUMBER := 0;
   tax_count_                 NUMBER := 0;
   item_id_                   NUMBER;
   site_date_                 DATE;
   tax_liability_country_rec_ Tax_Liability_Countries_API.Public_Rec;  
   base_for_adv_invoice_      company_order_info.base_for_adv_invoice%TYPE;
   invoiced_amount_           NUMBER;
   order_amount_              NUMBER;
   total_sales_charge_        NUMBER;
   order_total_net_           NUMBER;
   order_total_gross_         NUMBER;
   order_total_gross_charge_  NUMBER;
   order_total_net_charge_    NUMBER;
   count_                     NUMBER;
   m_s_names_                 Message_SYS.name_table;
   m_s_values_                Message_SYS.line_table;
   edited_tax_msg_            VARCHAR2(32000);
    
   CURSOR head_data IS
      SELECT order_no, customer_no, currency_code, authorize_code, date_entered,
             bill_addr_no, customer_no_pay, customer_no_pay_addr_no,
             internal_po_no, cust_ref, forward_agent_id, pay_term_id,
             ship_addr_no, NVL(internal_po_label_note, label_note) label_note, note_id, confirm_deliveries,
             contract, wanted_delivery_date, customer_po_no,staged_billing, currency_rate_type, supply_country, 
             use_price_incl_tax, ship_via_code, language_code, delivery_terms, del_terms_location, invoice_reason_id
      FROM   customer_order_tab
      WHERE  order_no = order_no_;
   invoice_component_ head_data%ROWTYPE;
BEGIN
 
   edited_tax_msg_ := tax_msg_;
   company_ := Site_API.Get_Company(Customer_Order_API.Get_Contract(order_no_));

   OPEN head_data;
   FETCH head_data INTO invoice_component_;
   IF head_data%NOTFOUND THEN
      CLOSE head_data;
      Error_SYS.Record_General(lu_name_, 'NO_INV_HEAD_DATA: Could not find order data when creating invoice.');
   ELSE
      CLOSE head_data;
      IF ((invoice_component_.confirm_deliveries = 'TRUE') AND (Company_Order_Info_API.Get_Allow_With_Deliv_Conf_Db(company_) = 'FALSE')) THEN
         Error_SYS.Record_General(lu_name_, 'DELCONF_ADV: The customer order has requested to confirm deliveries. Company :P1 does not allow using delivery confirmation for advance invoices.', company_);
      END IF;

      site_date_ := Site_API.Get_Site_Date(invoice_component_.contract);

      -- if apply tax check box is not selected from the client, then we need to
      -- fetch the company tax liability country data from the supply country..
      IF pay_tax_ = 'FALSE' THEN
         tax_liability_country_db_ := invoice_component_.supply_country;
      ELSE
         tax_liability_country_db_ := Customer_Order_Address_API.Get_Country_Code(order_no_);
         IF (Tax_Liability_Countries_API.Check_Valid_Info_Exist(company_, tax_liability_country_db_, site_date_)= 'FALSE') THEN
            tax_liability_country_db_ := invoice_component_.supply_country;
         END IF;
      END IF;

      tax_liability_country_rec_ := Tax_Liability_Countries_API.Get_Valid_Tax_Info(company_, tax_liability_country_db_, site_date_); 
      base_for_adv_invoice_ := Company_Order_Info_API.Get_Base_For_Adv_Invoice_Db(company_);
      IF (Customer_Order_Inv_Head_API.Check_Advance_Inv_Exist__(order_no_) = TRUE) THEN
         total_sales_charge_   := Customer_Order_API.Get_Total_Sale_Charge__(order_no_);
         order_total_gross_    := Customer_Order_API.Get_Ord_Gross_Amount(order_no_);
         order_total_net_      := Customer_Order_API.Get_Total_Sale_Price__(order_no_);
         IF (invoice_component_.use_price_incl_tax = 'TRUE') THEN
            order_total_gross_charge_ := order_total_gross_ + Customer_Order_API.Get_Total_Sale_Charge_Gross__(order_no_);
            order_total_net_charge_ := order_total_net_ + total_sales_charge_;
         ELSE
            order_total_net_charge_ := order_total_net_ + total_sales_charge_;
            order_total_gross_charge_ := order_total_gross_ + total_sales_charge_ + CUSTOMER_ORDER_API.Get_Tot_Charge_Sale_Tax_Amt(order_no_);
         END IF;
           
         IF (base_for_adv_invoice_ = 'NET AMOUNT' OR base_for_adv_invoice_ = 'NET AMOUNT WITH CHARGES') THEN
            invoiced_amount_ := Customer_Order_Inv_Head_API.Get_Ad_Net_Without_Invoice_Fee(company_, order_no_);                 
            IF (base_for_adv_invoice_ = 'NET AMOUNT') THEN
               order_amount_ := order_total_net_;
            ELSE
               order_amount_ := order_total_net_charge_;
            END IF;    
         ELSIF  (base_for_adv_invoice_ = 'GROSS AMOUNT' OR base_for_adv_invoice_ = 'GROSS AMOUNT WITH CHARGES') THEN
            invoiced_amount_   := Customer_Order_Inv_Head_API.Get_Ad_Gro_Without_Invoice_Fee(company_, order_no_);   
            IF  (base_for_adv_invoice_ = 'GROSS AMOUNT') THEN
               order_amount_ := order_total_gross_;
            ELSE
               order_amount_ := order_total_gross_charge_;
            END IF;
         END IF;
         IF ((order_amount_ -invoiced_amount_) < adv_pay_amt_) THEN 
            Error_SYS.Record_General(lu_name_, 'NOTALLOWEDADVANCEINVOICE: You are not allowed to create the advance invoice as the order amount is exceeded.');
         END IF;
      END IF;
      
      IF (invoice_component_.customer_no_pay IS NOT NULL) THEN
            invoice_component_.cust_ref := Customer_Order_API.Get_Customer_No_Pay_Ref(order_no_);
      END IF;
      
      Customer_Order_Inv_Head_API.Create_Invoice_Head(
         invoice_id_, --invoice_id_
         company_, --company_
         invoice_component_.order_no, --order_no_
         invoice_component_.customer_no, --customer_no_
         invoice_component_.customer_no_pay, --customer_no_pay_
         Order_Coordinator_API.Get_Name(invoice_component_.authorize_code), --authorize_name_
         invoice_component_.date_entered, --date_entered_
         invoice_component_.cust_ref, --cust_ref_
         Mpccom_Ship_Via_API.Get_Description(invoice_component_.ship_via_code, invoice_component_.language_code), --ship_via_desc,
         invoice_component_.forward_agent_id, --forward_agent_id,
         invoice_component_.label_note, --label_note,
         Order_Delivery_Term_API.Get_Description(invoice_component_.delivery_terms, invoice_component_.language_code), --delivery_terms_desc,
         invoice_component_.del_terms_location, --del_terms_location,
         pay_term_id_, --pay_term_id_
         invoice_component_.currency_code, --currency_code_
         invoice_component_.ship_addr_no, --ship_addr_no_
         invoice_component_.customer_no_pay_addr_no, --customer_no_pay_addr_no_
         invoice_component_.bill_addr_no, --bill_addr_no_
         NULL, --wanted_delivery_date,
         Company_Def_Invoice_Type_API.Get_Def_Adv_Co_Dr_Inv_Type(company_), --Invoice Type,
         NULL, -- number_reference
         NULL, -- series_reference
         invoice_component_.contract, --contract_
         'NJS', --js_invoice_state_db_
         invoice_component_.currency_rate_type, --currency_rate_type_
         NULL, --collect_
         NULL, --rma_no_
         NULL, --shipment_id_
         'TRUE', --adv_invoice_
         pay_base_date_, --adv_pay_base_date_
         NULL,    -- sb_reference_no
         'FALSE', -- use_ref_inv_curr_rate
         NULL,    -- ledger_item_id
         NULL,    -- ledger_item_series_id
         NULL,    -- ledger_item_version_id
         NULL,    -- aggregation_no
         'FALSE', -- final_settlement
         NULL,    -- project_id
         tax_liability_country_rec_.tax_id_number, --tax_id_number_
         tax_liability_country_rec_.tax_id_type, --tax_id_type_
         tax_liability_country_rec_.branch, --branch
         invoice_component_.supply_country, --supply_country_
         NULL, --invoice_date_
         invoice_component_.use_price_incl_tax, --use_price_incl_tax_db_
         NULL, --wht_amount_base_
         NULL, --curr_rate_new_
         NULL, --tax_curr_rate_new_
         NULL, --correction_reason_id_
         NULL, --correction_reason_
         'FALSE', --is_simulated_
         invoice_component_.invoice_reason_id); --invoice_reason_id_               

      Tax_Handling_Util_API.Get_Cust_Tax_Liability_Info(cust_tax_liability_, tax_liability_type_db_,
                                                        invoice_component_.customer_no, invoice_component_.ship_addr_no,
                                                        company_, invoice_component_.supply_country, 
                                                        Customer_Info_Address_API.Get_Country_Code(invoice_component_.customer_no, invoice_component_.ship_addr_no ));
            
      IF (edited_tax_msg_ IS NOT NULL) THEN
         IF (Message_SYS.Get_Name(edited_tax_msg_) = 'TAX_INFORMATION') THEN
            Message_SYS.Get_Attributes(edited_tax_msg_, count_, m_s_names_, m_s_values_);
            IF (count_ = 0) THEN
               IF pay_tax_ = 'TRUE' THEN
                  Error_SYS.Record_General(lu_name_, 'NOVATCODE: Tax Code is mandatory, When the apply tax is checked.');
               END IF;   
               Tax_Handling_Util_API.Validate_Tax_Code_Mandatory(company_, 'CUSTOMER_TAX');  
            END IF;
            FOR i IN 1..count_  LOOP
               IF (m_s_names_(i) = 'TAX_CODE') THEN
                  tax_code_ := m_s_values_(i);
                  tax_count_ := tax_count_ + 1;
               END IF;
               IF (m_s_names_(i) = 'TAX_PERCENTAGE') THEN
                  tax_percentage_ := Client_SYS.Attr_Value_To_Number(m_s_values_(i));         
               END IF;
               tax_percentage_ := NVL(tax_percentage_ ,Statutory_Fee_API.Get_Percentage(company_, tax_code_));
               IF (pay_tax_ = 'FALSE') AND (tax_percentage_ != 0)THEN
                  Error_SYS.Record_General(lu_name_, 'NONZEROVAT: When the apply tax is unchecked, only 0% TAX is allowed for the Customers.');
               END IF;
               tax_percentage_ := NULL;
            END LOOP;        
         END IF;       
      END IF;
      IF (base_for_adv_invoice_ = 'NET AMOUNT' OR base_for_adv_invoice_ = 'NET AMOUNT WITH CHARGES') THEN
         net_amt_    := adv_pay_amt_;
      ELSIF  (base_for_adv_invoice_ = 'GROSS AMOUNT' OR base_for_adv_invoice_ = 'GROSS AMOUNT WITH CHARGES') THEN
         gross_amt_  := adv_pay_amt_;
      END IF;
      Customer_Order_History_API.New(invoice_component_.order_no,
         Language_SYS.Translate_Constant(lu_name_, 'CRECUSTADVINV: Advance Invoice :P1 created', NULL, invoice_id_));
      IF (tax_count_ != 1)THEN
         tax_code_ := NULL;
      END IF;
      Create_Advance_Invoice_Item___(item_id_, invoice_id_, order_no_, net_amt_, gross_amt_, edited_tax_msg_, tax_code_, invoice_text_);
      Customer_Order_Inv_Head_API.Create_Invoice_Complete(company_, invoice_id_);
   END IF;

END Create_Advance_Invoice__;


-- Get_Tax_Percentage__
--   Returns total tax paercebtage
FUNCTION Get_Tax_Percentage__ (
   company_  IN VARCHAR2,
   tax_code_ IN VARCHAR2 ) RETURN NUMBER
IS
   tax_percentage_      NUMBER :=0;   
BEGIN
   IF (tax_code_ IS NOT NULL) THEN
      tax_percentage_ := Statutory_Fee_API.Get_Percentage(company_, tax_code_);      
   END IF;
   RETURN(tax_percentage_);
END Get_Tax_Percentage__;


-- Get_Corr_Amt_Per_Ref_Ivc__
--   Return the sum of the total gross amount of debit or correction invoices to correct.
@UncheckedAccess
FUNCTION Get_Corr_Amt_Per_Ref_Ivc__ (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER ) RETURN NUMBER
IS
   correction_amount_ NUMBER;

   CURSOR get_correction_amt IS
      SELECT SUM(gross_curr_amount)
        FROM CUSTOMER_ORDER_INV_ITEM
       WHERE invoice_id          = invoice_id_
         AND company             = company_
         AND prel_update_allowed = 'TRUE';
BEGIN
   OPEN get_correction_amt;
   FETCH get_correction_amt INTO correction_amount_;
   CLOSE get_correction_amt;

   RETURN (NVL(correction_amount_, 0));
END Get_Corr_Amt_Per_Ref_Ivc__;



-- Create_Credit_Invoice__
--   Creates credit invoice head and items. The in parameter must be
--   declared as a string because this method will be called using a deferred call.
PROCEDURE Create_Credit_Invoice__ (
   attr_in_ IN OUT VARCHAR2 )
IS
   cre_invoice_id_            NUMBER;
   ref_invoice_id_            NUMBER;
   invoice_type_              VARCHAR2(20);
   advance_invoice_           VARCHAR2(5);
   invoice_id_                VARCHAR2(200);
   use_ref_inv_curr_rate_     NUMBER;
   use_ref_inv_rates_         VARCHAR2(5) := 'FALSE';
   invoice_category_          VARCHAR2(10);
   rma_no_                    NUMBER;
   cor_inv_type_              VARCHAR2(20);
   col_inv_type_              VARCHAR2(20);
   allow_credit_inv_fee_      VARCHAR2(5);
   pre_deb_inv_type_          VARCHAR2(20);
   pre_cre_inv_type_          VARCHAR2(20);
   
   curr_rate_                 NUMBER;
   tax_curr_rate_             NUMBER;
   invoice_date_              DATE := NULL;
   correction_reason_id_      VARCHAR2(20);
   correction_reason_         VARCHAR2(2000);
   exclude_service_items_     VARCHAR2(5) := NULL;

   -- gelr:prepayment_tax_document, added prepay_adv_inv_id
   CURSOR get_invoice_head IS
      SELECT company, name, identity,
             delivery_identity, creators_reference, invoice_id,
             series_id, invoice_no, invoice_type, sb_reference_no,
             currency, curr_rate, notes, net_amount, vat_amount,
             gross_amount, invoice_address_id, delivery_address_id,
             invoice_date, wanted_delivery_date, pay_term_id,
             pay_term_description, due_date, collect,
             cash, int_allowed, series_reference, number_reference,
             order_date, our_reference, your_reference, ship_via,
             forward_agent_id, label_note, delivery_terms, del_terms_location,
             aff_base_ledg_post, aff_line_post, client_state,
             contract,advance_invoice, js_invoice_state_db, correction_invoice_id,
             objid, objversion, ledger_item_series_id, ledger_item_id, ledger_item_version_id,
             currency_rate_type, shipment_id, tax_id_number, tax_id_type, branch, supply_country_db,
             use_price_incl_tax_db, wht_amount_base, invoice_reason_id, prepay_adv_inv_id, prepayment_type_code
      FROM   customer_order_inv_head
      WHERE  invoice_id = ref_invoice_id_
      AND    company > ' ';

   invoice_component_   get_invoice_head%ROWTYPE;
BEGIN

   invoice_id_            := Client_SYS.Get_Item_Value ('REF_INVOICE_ID', attr_in_);
   use_ref_inv_curr_rate_ := TO_NUMBER(Client_SYS.Get_Item_Value('USE_REF_INV_CURR_RATE', attr_in_));
   rma_no_                := TO_NUMBER(Client_SYS.Get_Item_Value('RMA_NO', attr_in_));
   allow_credit_inv_fee_  := Client_SYS.Get_Item_Value('ALLOW_CREDIT_INV_FEE', attr_in_);
   ref_invoice_id_        := TO_NUMBER(invoice_id_);
   
   curr_rate_             := Client_SYS.Get_Item_Value ('CURR_RATE', attr_in_);   
   tax_curr_rate_         := Client_SYS.Get_Item_Value ('TAX_CURR_RATE', attr_in_);
   invoice_date_          := Client_SYS.Attr_Value_To_Date(Client_SYS.Get_Item_Value ('INVOICE_DATE', attr_in_));
   correction_reason_id_  := Client_SYS.Get_Item_Value ('CORRECTION_REASON_ID', attr_in_);   
   correction_reason_     := Client_SYS.Get_Item_Value ('CORRECTION_REASON', attr_in_); 
   exclude_service_items_ := NVL(Client_SYS.Get_Item_Value ('EXCLUDE_SERVICE_ITEMS', attr_in_), 'FALSE');
   
   
   @ApproveTransactionStatement(2014-09-18,darklk)
   SAVEPOINT create_credit_invoice;

   OPEN get_invoice_head;
   FETCH get_invoice_head INTO invoice_component_;
   IF get_invoice_head%NOTFOUND THEN
      CLOSE get_invoice_head;
      Error_SYS.Record_General(lu_name_, 'CREDITINVHEADERR: Could not find order data when creating credit/correction invoice.');
   ELSE
      CLOSE get_invoice_head;

      invoice_category_ := Client_SYS.Get_Item_Value('INVOICE_CATEGORY', attr_in_);

      Validate_Credit_Inv_Creation__( invoice_component_.company, ref_invoice_id_, rma_no_, invoice_category_);
      cor_inv_type_ := Company_Def_Invoice_Type_API.Get_Def_Co_Cor_Inv_Type(invoice_component_.company);
      col_inv_type_ := Company_Def_Invoice_Type_API.Get_Def_Col_Cor_Inv_Type(invoice_component_.company);
      pre_deb_inv_type_ := Company_Def_Invoice_Type_API.Get_Def_Co_Prepay_Deb_Inv_Type(invoice_component_.company);
      pre_cre_inv_type_ := Company_Def_Invoice_Type_API.Get_Def_Co_Prepay_Cre_Inv_Type(invoice_component_.company);

      IF (invoice_category_ = 'CREDIT') THEN
         IF (invoice_component_.invoice_type = 'SELFBILLDEB') THEN
            invoice_type_ := 'SELFBILLCRE';
         ELSIF (invoice_component_.collect = 'TRUE') THEN
            invoice_component_.creators_reference := NULL;
            invoice_type_ := 'CUSTCOLCRE';
         ELSIF (invoice_component_.advance_invoice = 'TRUE') THEN
            invoice_type_    := Company_Def_Invoice_Type_API.Get_Def_Adv_Co_Cr_Inv_Type(Site_API.Get_Company(invoice_component_.contract));
            advance_invoice_ := 'TRUE';
         ELSIF (invoice_component_.invoice_type = pre_deb_inv_type_) THEN
            invoice_type_ := pre_cre_inv_type_;
         ELSE
            invoice_type_ := 'CUSTORDCRE';
         END IF;
	   ELSIF (invoice_category_ = 'PREPAYMENT') THEN
         invoice_type_ := pre_cre_inv_type_;
      ELSIF (invoice_category_ = 'RATE1' OR invoice_category_ = 'RATE2')THEN
         invoice_type_  :=  Client_SYS.Get_Item_Value ('INVOICE_TYPE', attr_in_);    
      ELSE
         -- setting the invoice types for correction invoices
         IF (invoice_component_.collect = 'TRUE') THEN
            invoice_component_.creators_reference := NULL;
            invoice_type_ := col_inv_type_;
         ELSE
            invoice_type_ := cor_inv_type_;
         END IF;
      END IF;
      -- gelr:prepayment_tax_document, begin
      IF (Company_Localization_Info_API.Get_Parameter_Value_Db(invoice_component_.company, 'PREPAYMENT_TAX_DOCUMENT') = Fnd_Boolean_API.DB_TRUE) THEN
         IF (invoice_category_ = 'CREDIT' AND invoice_component_.prepay_adv_inv_id IS NOT NULL) THEN
            invoice_type_ := Company_Def_Invoice_Type_API.Get_Def_Co_Cre_Tax_Doc_Type(invoice_component_.company);
         END IF;
      END IF;      
      -- gelr:prepayment_tax_document, end
      IF ( use_ref_inv_curr_rate_ = 1 ) THEN
         use_ref_inv_rates_ := 'TRUE';
      END IF;

      -- prevent to create 2 correction invoices for the same ref invoice
      IF (invoice_category_ = 'CORRECTION' AND invoice_component_.correction_invoice_id IS NOT NULL) THEN
         Error_SYS.Record_General(lu_name_, 'CORINVEXISTFORREF: Correction invoice :P1 already created for the reference invoice :P2', invoice_component_.correction_invoice_id, ref_invoice_id_);
      END IF;

      -- gelr:mx_xml_doc_reporting, begin
      IF (Company_Localization_Info_API.Get_Parameter_Value_Db(invoice_component_.company, 'MX_XML_DOC_REPORTING') = Fnd_Boolean_API.DB_TRUE) THEN 
         correction_reason_id_ := Invoice_Type_API.Get_Correction_Reason_Id(invoice_component_.company, Party_Type_API.Decode(Party_Type_API.DB_CUSTOMER), invoice_type_);
         correction_reason_    := Correction_Reason_API.Get_Correction_Reason(invoice_component_.company, correction_reason_id_);
      END IF;
      -- gelr:mx_xml_doc_reporting, end
      
      -- To get same due_date as invoice_date when Credit Invoice is made.
      Customer_Order_Inv_Head_API.Create_Invoice_Head(
         cre_invoice_id_, --invoice_id_
         invoice_component_.company, --company_
         invoice_component_.creators_reference, --order_no_
         invoice_component_.delivery_identity, --customer_no_
         invoice_component_.identity, --customer_no_pay_
         invoice_component_.our_reference, --authorize_name_
         invoice_component_.order_date, --date_entered_
         invoice_component_.your_reference, --cust_ref_
         invoice_component_.ship_via, --ship_via_desc_
         invoice_component_.forward_agent_id, --forward_agent_id_
         invoice_component_.label_note, --label_note_
         invoice_component_.delivery_terms, --delivery_terms_desc_
         invoice_component_.del_terms_location, --del_terms_location_
         invoice_component_.pay_term_id, --pay_term_id_
         invoice_component_.currency, --currency_code_
         invoice_component_.delivery_address_id, --ship_addr_no_
         invoice_component_.invoice_address_id, --customer_no_pay_addr_no_
         NULL, --bill_addr_no_
         invoice_component_.wanted_delivery_date, --wanted_delivery_date_
         invoice_type_, --invoice_type_
         invoice_component_.invoice_no, --number_reference_
         invoice_component_.series_id, --series_reference_
         invoice_component_.contract, --contract_
         invoice_component_.js_invoice_state_db, --js_invoice_state_db_
         invoice_component_.currency_rate_type, --currency_rate_type_
         invoice_component_.collect, --collect
         rma_no_, --rma_no
         invoice_component_.shipment_id, --shipment_id
         advance_invoice_, --adv_invoice
         NULL, --adv_pay_base_date
         invoice_component_.sb_reference_no, --sb_reference_no
         use_ref_inv_rates_, --use_ref_inv_curr_rate
         invoice_component_.ledger_item_id, --ledger_item_id
         invoice_component_.ledger_item_series_id, --ledger_item_series_id
         invoice_component_.ledger_item_version_id, --ledger_item_version_id
         NULL, --aggregation_no_
         'FALSE', --final_statement_
         NULL, --project_id_
         invoice_component_.tax_id_number, --tax_id_number_
         invoice_component_.tax_id_type, --tax_id_type_ 
         invoice_component_.branch, --branch
         invoice_component_.supply_country_db, --supply_country_db
         invoice_date_, --invoice_date_
         invoice_component_.use_price_incl_tax_db, --use_price_incl_tax
         invoice_component_.wht_amount_base,-- wht_amount_base_         
         curr_rate_,
         tax_curr_rate_,
         correction_reason_id_,
         correction_reason_,
         'FALSE', --is_simulated_
         invoice_component_.invoice_reason_id, --invoice_reason_id
         NULL, --service_code
         invoice_component_.prepay_adv_inv_id, -- prepay_adv_inv_id
         invoice_component_.prepayment_type_code);  
         
      Customer_Order_Inv_Item_API.Create_Credit_Invoice_Items(invoice_component_.company, cre_invoice_id_, ref_invoice_id_, invoice_category_, use_ref_inv_rates_, exclude_service_items_);

      Customer_Order_Inv_Head_API.Create_Invoice_Complete(invoice_component_.company, cre_invoice_id_, allow_credit_inv_fee_);

      IF (invoice_type_ IN (col_inv_type_, cor_inv_type_)) THEN
         Customer_Invoice_Pub_Util_API.Set_Correction_Invoice_Id(invoice_component_.company, ref_invoice_id_, cre_invoice_id_);
      END IF;

      -- Create history records for credit invoiced order(s).
      Customer_Order_Inv_Head_API.Create_Credit_Invoice_Hist(invoice_component_.creators_reference, cre_invoice_id_, ref_invoice_id_);
      -- Set the associated commission lines as 'Changed'.
      IF (invoice_component_.creators_reference IS NOT NULL) THEN
         Order_Line_Commission_API.Set_Order_Com_Lines_Changed(invoice_component_.creators_reference);
      END IF;
   END IF;
   
   IF (invoice_category_ = 'RATE1' OR invoice_category_ = 'RATE2') THEN
       Client_Sys.Clear_Attr(attr_in_);  
       Client_Sys.Add_To_Attr('INVOICE_ID', cre_invoice_id_, attr_in_);
       Client_SYS.Add_To_Attr('END', '', attr_in_);
   END IF;
   
EXCEPTION
   WHEN others THEN
      @ApproveTransactionStatement(2014-09-18,darklk)
      ROLLBACK TO create_credit_invoice;
      -- Logg the error
      Transaction_SYS.Set_Status_Info(sqlerrm);
END Create_Credit_Invoice__;


-- Validate_Credit_Inv_Creation__
--   Performs validations required when creating credit/correction invoice.
PROCEDURE Validate_Credit_Inv_Creation__ (
   company_          IN VARCHAR2,
   ref_invoice_id_   IN NUMBER,
   rma_no_           IN NUMBER,
   invoice_category_ IN VARCHAR2 )
IS
   ref_inv_rec_    Customer_Order_Inv_Head_API.Public_Rec;
   exist_          NUMBER;   

   CURSOR check_multiple_inv_conn IS
      SELECT  1
        FROM  return_material_line_tab r, return_material_line_tab l
       WHERE  r.rma_no = rma_no_
         AND  r.debit_invoice_no =  ref_inv_rec_.invoice_no
         AND  r.debit_invoice_no = l.debit_invoice_no
         AND  r.debit_invoice_item_id = l.debit_invoice_item_id
         AND  r.rma_no = l.rma_no
         AND  r.rma_line_no != l.rma_line_no
         AND  r.debit_invoice_series_id  = l.debit_invoice_series_id
         AND  r.credit_approver_id IS NOT NULL
         AND  l.credit_approver_id IS NOT NULL
         AND  r.credit_invoice_no IS NULL
         AND  l.credit_invoice_no IS NULL;

   CURSOR check_amount_to_credit IS
      SELECT 1
        FROM customer_order_inv_item coii
       WHERE coii.company = company_
         AND coii.invoice_id = ref_invoice_id_
         AND coii.gross_curr_amount >=
            (SELECT NVL(SUM(cpc.consumed_amount), 0)
               FROM cust_prepaym_consumption cpc
              WHERE cpc.company = company_
                AND cpc.prepayment_invoice_id = coii.invoice_id
                AND cpc.prepayment_invoice_item = coii.item_id);
BEGIN
   ref_inv_rec_ := Customer_Order_Inv_Head_API.Get(company_, ref_invoice_id_);

   IF (rma_no_ IS NOT NULL) THEN
      IF (invoice_category_ = 'CORRECTION') THEN
         IF (ref_inv_rec_.invoice_type = 'SELFBILLDEB') THEN
            Error_SYS.Record_General(lu_name_, 'INVALIDCORINVTYPE: Cannot create a correction invoice. The reference invoice no :P1 cannot be a self-billing debit invoice.', ref_inv_rec_.invoice_no);
         END IF;

         IF (ref_inv_rec_.objstate NOT IN ('PostedAuth', 'PartlyPaidPosted', 'PaidPosted')) THEN
            Error_SYS.Record_General(lu_name_, 'INVALIDSTATE: Cannot create a correction invoice. The reference invoice no :P1 has invalid state :P2.', ref_inv_rec_.invoice_no, ref_inv_rec_.objstate);
         END IF;

         IF (ref_inv_rec_.correction_invoice_id IS NOT NULL) THEN
            Error_SYS.Record_General(lu_name_, 'INVALIDREFINV: A correction invoice already exists for the reference invoice no :P1 and cannot create another correction invoice.', ref_inv_rec_.invoice_no);
         END IF;

         OPEN check_multiple_inv_conn;
         FETCH check_multiple_inv_conn INTO exist_;
         IF (check_multiple_inv_conn%FOUND) THEN
            CLOSE check_multiple_inv_conn;
            Error_SYS.Record_General(lu_name_, 'MUTLIPLECONN: Cannot create a correction invoice for the reference invoice no :P1. Several RMA lines are connected to the same reference invoice item no.', ref_inv_rec_.invoice_no);
         END IF;
         CLOSE check_multiple_inv_conn;
      END IF;
   ELSE
      IF (invoice_category_ = 'PREPAYMENT') THEN
         OPEN check_amount_to_credit;
         FETCH check_amount_to_credit INTO exist_;
         IF (check_amount_to_credit%NOTFOUND) THEN
            CLOSE check_amount_to_credit;
            Error_SYS.Record_General(lu_name_, 'NOCONSUMPPREPAY: Cannot create a prepayment credit invoice, the prepayments may be fully consumed or credited');
         END IF;
         CLOSE check_amount_to_credit;
      END IF;
   END IF;
END Validate_Credit_Inv_Creation__;


-- Get_Prepaym_Based_Gross_Amt__
--   This will return the prepayment based invoiced gross amount for a customer order.
@UncheckedAccess
FUNCTION Get_Prepaym_Based_Gross_Amt__ (
   company_  IN VARCHAR2,
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   prepay_deb_type_     VARCHAR2(20);
   prepay_cre_type_     VARCHAR2(20);
   gross_amount_        NUMBER;

   CURSOR sum_gross_amt IS
      SELECT SUM(gross_amount)
      FROM   customer_order_inv_head
      WHERE  creators_reference = order_no_
      AND    invoice_type IN (prepay_deb_type_, prepay_cre_type_)
      AND    objstate NOT IN ('Printed', 'Preliminary');
BEGIN
   prepay_deb_type_ := Company_Def_Invoice_Type_API.Get_Def_Co_Prepay_Deb_Inv_Type(company_);
   prepay_cre_type_ := Company_Def_Invoice_Type_API.Get_Def_Co_Prepay_Cre_Inv_Type(company_);

   OPEN  sum_gross_amt;
   FETCH sum_gross_amt INTO gross_amount_ ;
   IF (sum_gross_amt%NOTFOUND) THEN
      gross_amount_ :=0 ;
   END IF;
   CLOSE sum_gross_amt;

   RETURN NVL(gross_amount_,0);
END Get_Prepaym_Based_Gross_Amt__;



@UncheckedAccess
FUNCTION Get_Consumed_Line_Amt__ (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   consumed_amount_   NUMBER;
   credited_amount_   NUMBER;
   prepay_cre_type_   VARCHAR2(20);
   company_           VARCHAR2(20);

   CURSOR sum_consumed_amt IS
      SELECT SUM(consumed_amount)
      FROM  cust_prepaym_consumption cpc, customer_order_inv_head coih
      WHERE cpc.invoice_id = coih.invoice_id
      AND   cpc.company = coih.company
      AND   coih.creators_reference = order_no_;

   CURSOR sum_credited_amt IS
      SELECT SUM(gross_curr_amount)
      FROM  customer_order_inv_item
      WHERE invoice_type = prepay_cre_type_
      AND   order_no = order_no_;

BEGIN
   company_ := Site_API.Get_Company(Customer_Order_API.Get_Contract(order_no_));
   prepay_cre_type_ := Company_Def_Invoice_Type_API.Get_Def_Co_Prepay_Cre_Inv_Type(company_);

   OPEN  sum_consumed_amt;
   FETCH sum_consumed_amt INTO consumed_amount_;
   CLOSE sum_consumed_amt;
   consumed_amount_ := NVl(consumed_amount_,0);

   OPEN  sum_credited_amt;
   FETCH sum_credited_amt INTO credited_amount_;
   CLOSE sum_credited_amt;
   credited_amount_ := NVl(credited_amount_,0);

   RETURN (consumed_amount_ + credited_amount_ );
END Get_Consumed_Line_Amt__;


@UncheckedAccess
FUNCTION Get_Prepaym_Based_Other_Amt__ (
   company_   IN VARCHAR2,
   order_no_  IN VARCHAR2,
   identity_  IN VARCHAR2) RETURN NUMBER
IS   
   prepay_deb_type_     VARCHAR2(20);
   prepay_cre_type_     VARCHAR2(20);
   gross_amount_        NUMBER;
   consumed_amount_     NUMBER;
   credited_amount_     NUMBER;
   
   CURSOR sum_gross_amt IS
      SELECT SUM(gross_amount)
      FROM   customer_order_inv_head
      WHERE  creators_reference != order_no_
      AND    identity = identity_
      AND    company = company_
      AND    invoice_type IN (prepay_deb_type_, prepay_cre_type_)
      AND    objstate NOT IN ('Printed', 'Preliminary')
      AND    creators_reference IN ( SELECT order_no
                                     FROM   customer_order_tab
                                     WHERE  rowstate IN ('Blocked', 'Released', 'Reserved', 'Picked', 'PartiallyDelivered', 'Delivered')
                                     AND    identity  = identity_);         
         
   CURSOR sum_consumed_amt IS
      SELECT SUM(consumed_amount)
      FROM  cust_prepaym_consumption cpc, customer_order_inv_head coih
      WHERE cpc.invoice_id = coih.invoice_id
      AND   cpc.company = coih.company
      AND   coih.creators_reference != order_no_
      AND   coih.identity = identity_
      AND   coih.company = company_
      AND   coih.creators_reference IN ( SELECT order_no
                                         FROM   customer_order_tab
                                         WHERE  rowstate IN ('Blocked', 'Released', 'Reserved', 'Picked', 'PartiallyDelivered', 'Delivered')
                                         AND    coih.identity  = identity_);
   
   CURSOR sum_credited_amt IS
      SELECT SUM(gross_curr_amount)
      FROM  customer_order_inv_item
      WHERE invoice_type = prepay_cre_type_
      AND   order_no != order_no_
      AND   identity = identity_
      AND   company = company_
      AND   order_no IN ( SELECT order_no
                          FROM customer_order_tab
                          WHERE rowstate IN ('Blocked', 'Released', 'Reserved', 'Picked', 'PartiallyDelivered', 'Delivered')
                          AND  identity  = identity_);
         
BEGIN
   prepay_deb_type_ := Company_Def_Invoice_Type_API.Get_Def_Co_Prepay_Deb_Inv_Type(company_);
   prepay_cre_type_ := Company_Def_Invoice_Type_API.Get_Def_Co_Prepay_Cre_Inv_Type(company_);

   OPEN  sum_gross_amt;
   FETCH sum_gross_amt INTO gross_amount_ ;
   IF (sum_gross_amt%NOTFOUND) THEN
      gross_amount_ :=0 ;
   END IF;
   CLOSE sum_gross_amt;
   gross_amount_ := NVL(gross_amount_,0);

   OPEN  sum_consumed_amt;
   FETCH sum_consumed_amt INTO consumed_amount_;
   CLOSE sum_consumed_amt;
   consumed_amount_ := NVl(consumed_amount_,0);

   OPEN  sum_credited_amt;
   FETCH sum_credited_amt INTO credited_amount_;
   CLOSE sum_credited_amt;
   credited_amount_ := NVl(credited_amount_,0);

   RETURN (gross_amount_ - (consumed_amount_ + credited_amount_ ));
END Get_Prepaym_Based_Other_Amt__;


-- Create_Prepayment_Invoice__
--   Creates Prepayment based Invoices.
PROCEDURE Create_Prepayment_Invoice__ (
   invoice_id_             IN OUT VARCHAR2,
   order_no_               IN VARCHAR2,
   ledger_item_id_         IN VARCHAR2,
   ledger_item_series_id_  IN VARCHAR2,
   ledger_item_version_id_ IN NUMBER,
   prepaym_lines_attr_     IN VARCHAR2 )
IS
   invoice_type_    CUSTOMER_ORDER_INV_HEAD.invoice_type%TYPE;
   company_         VARCHAR2(20);
   payment_date_    DATE;
   tax_liability_country_db_  VARCHAR2(2);
   tax_liability_country_rec_ Tax_Liability_Countries_API.Public_Rec; 
   site_date_       DATE;
   -- gelr:out_inv_curr_rate_voucher_date, begin
   attr_            VARCHAR2(2000);
   -- gelr:out_inv_curr_rate_voucher_date, end
   
   CURSOR head_data IS
      SELECT customer_no, customer_no_pay, authorize_code, date_entered, cust_ref, currency_code, bill_addr_no,
             customer_no_pay_addr_no, pay_term_id, ship_addr_no, contract, customer_po_no, currency_rate_type, 
             NVL(internal_po_label_note, label_note) label_note, supply_country, use_price_incl_tax, rowstate,
             invoice_reason_id
      FROM   CUSTOMER_ORDER_TAB
      WHERE  order_no = order_no_;

   CURSOR get_inv_data IS
      SELECT identity, party_type
      FROM   CUSTOMER_ORDER_INV_HEAD
      WHERE  invoice_id = invoice_id_
      AND    company    = company_;

   invoice_component_ head_data%ROWTYPE;
   invoice_data_      get_inv_data%ROWTYPE;
   unrollbacked_ BOOLEAN;
BEGIN
   company_      := Site_API.Get_Company(Customer_Order_API.Get_Contract(order_no_));
   invoice_type_ := Company_Def_Invoice_Type_API.Get_Def_Co_Prepay_Deb_Inv_Type(company_);

   OPEN head_data;
   FETCH head_data INTO invoice_component_;
   IF head_data%NOTFOUND THEN
      CLOSE head_data;
      Error_SYS.Record_General(lu_name_, 'NO_INV_HEAD_DATA: Could not find order data when creating invoice.');
   ELSE
      CLOSE head_data;

      IF (invoice_component_.customer_no_pay IS NOT NULL) THEN
            invoice_component_.cust_ref := Customer_Order_API.Get_Customer_No_Pay_Ref(order_no_);
      END IF;
      
      -- Check the order status before creating the prepayment invoice
      IF invoice_component_.rowstate IN ('Invoiced','Cancelled')  THEN
         Error_SYS.Record_General( lu_name_, 'NOT_ALLOWED_STATE: You are not allowed to create a prepayment based invoice for a customer order in status :P1.', Customer_Order_API.Finite_State_Decode__(invoice_component_.rowstate));
      END IF;

      $IF (Component_Payled_SYS.INSTALLED) $THEN  
         unrollbacked_ := Ledger_Transaction_API.Exist_Unrollbacked_Trans(company_, NVL(invoice_component_.customer_no_pay, invoice_component_.customer_no), Party_Type_API.Decode('CUSTOMER'), ledger_item_series_id_, ledger_item_id_, ledger_item_version_id_);

         IF (NOT unrollbacked_) THEN
            Error_SYS.Record_General( lu_name_, 'ROLLBACKEDPAYMENT: Prepayment invoice cannot be created for customer :P1 because either the connected payment no longer exists, or the connected payment is for customer :P2.', invoice_component_.customer_no_pay, invoice_component_.customer_no);
         END IF;              
      $END      
      
      IF Payment_Term_Details_API.Get_Installment_Count(company_, invoice_component_.pay_term_id) = 1 THEN
         IF Payment_Term_Details_API.Get_Discount_Specified(company_, invoice_component_.pay_term_id, 1 ,1) ='FALSE' THEN
            site_date_ := Site_API.Get_Site_Date(invoice_component_.contract);
            IF Customer_Order_API.Get_Tax_Liability_Type_Db(order_no_) = 'EXM' THEN
               tax_liability_country_db_ := invoice_component_.supply_country;
            ELSE
               tax_liability_country_db_ := Customer_Order_Address_API.Get_Country_Code(order_no_);
               IF (Tax_Liability_Countries_API.Check_Valid_Info_Exist(company_, tax_liability_country_db_, site_date_)= 'FALSE') THEN
                  tax_liability_country_db_ := invoice_component_.supply_country;
               END IF;
            END IF;

            tax_liability_country_rec_ := Tax_Liability_Countries_API.Get_Valid_Tax_Info(company_, tax_liability_country_db_, site_date_); 

            Customer_Order_Inv_Head_API.Create_Invoice_Head(invoice_id_, --invoice_id_
                                                            company_, --company_
                                                            order_no_, --order_no_
                                                            invoice_component_.customer_no, --customer_no_
                                                            invoice_component_.customer_no_pay, --customer_no_pay_
                                                            Order_Coordinator_API.Get_Name(invoice_component_.authorize_code), --authorize_name_
                                                            invoice_component_.date_entered, --date_entered_
                                                            invoice_component_.cust_ref, --cust_ref_
                                                            NULL,         --ship_via_desc
                                                            NULL,         --forward_agent_id
                                                            invoice_component_.label_note,         --label_note
                                                            NULL,         --delivery_terms_desc
                                                            NULL,         --del_terms_location
                                                            invoice_component_.pay_term_id, --pay_term_id_
                                                            invoice_component_.currency_code, --currency_code_
                                                            invoice_component_.ship_addr_no, --ship_addr_no_
                                                            invoice_component_.customer_no_pay_addr_no, --customer_no_pay_addr_no_
                                                            invoice_component_.bill_addr_no, --bill_addr_no_
                                                            NULL,         --wanted_delivery_date,
                                                            invoice_type_, --invoice_type_
                                                            NULL,         --number_reference
                                                            NULL,         --series_reference
                                                            invoice_component_.contract, --contract_
                                                            NULL,         --js_invoice_state_db
                                                            invoice_component_.currency_rate_type, --currency_rate_type_
                                                            NULL,         --collect
                                                            NULL,         --rma_no
                                                            NULL,         --shipment_id
                                                            NULL,         --adv_invoice
                                                            NULL,         --adv_pay_base_date
                                                            NULL,         --sb_reference_no
                                                            'FALSE',      --use_ref_inv_curr_rate
                                                            ledger_item_id_, --ledger_item_id_
                                                            ledger_item_series_id_, --ledger_item_series_id_
                                                            ledger_item_version_id_, --ledger_item_version_id_
                                                            NULL,         -- aggregation_no
                                                            'FALSE',      -- final_settlement
                                                            NULL,         -- project_id
                                                            tax_liability_country_rec_.tax_id_number, --tax_id_number_
                                                            tax_liability_country_rec_.tax_id_type, --tax_id_type_
                                                            tax_liability_country_rec_.branch, --branch_
                                                            invoice_component_.supply_country, --supply_country_db_
                                                            NULL, -- invoice_date
                                                            invoice_component_.use_price_incl_tax, --use_price_incl_tax_db_
                                                            NULL, --wht_amount_base_
                                                            NULL, --curr_rate_new_
                                                            NULL, --tax_curr_rate_new_
                                                            NULL, --correction_reason_id_
                                                            NULL, --correction_reason_
                                                            'FALSE', --is_simulated_
                                                            invoice_component_.invoice_reason_id); --invoice_reason_id_                                                            
         ELSE
            -- Raise an error if discosunts are specified for the payment term's installations.
            Error_SYS.Record_General(lu_name_,'PAYTERMDISC: Payment Term with discounts can not be used for a prepayment based invoice.');
         END IF;
      ELSE
         --Raise an error if multiple installments are connectedto the payment term
         Error_SYS.Record_General(lu_name_,'MANYINST: Payment Term with many installments can not be used for a prepayment based invoice.');
      END IF;
   END IF;

   Customer_Order_History_API.New(order_no_,
      Language_SYS.Translate_Constant(lu_name_, 'CREPREPAYINV: Prepayment invoice :P1 created', NULL, invoice_id_));

   OPEN get_inv_data;
   FETCH get_inv_data INTO invoice_data_;
   IF (get_inv_data%NOTFOUND) THEN
      payment_date_ := NULL;
   END IF;
   CLOSE get_inv_data;

   -- Payment date is stored in the line level to speed up the consumption logic.
   $IF Component_Payled_SYS.INSTALLED $THEN 
      payment_date_ := Ledger_Item_API.Get_Due_Date ( company_, invoice_data_.identity, Party_Type_API.Decode(invoice_data_.party_type), ledger_item_series_id_, ledger_item_id_, ledger_item_version_id_ );
   $END

   Customer_Order_Inv_Item_API.Create_Prepayment_Inv_Lines(company_, invoice_id_, order_no_, payment_date_, prepaym_lines_attr_ );
   -- The prepayment invoices should be excluded from adding invoice_fee amount
   Customer_Order_Inv_Head_API.Create_Invoice_Complete(company_, invoice_id_, 'FALSE');

   $IF Component_Payled_SYS.INSTALLED $THEN
      On_Account_Ledger_Item_API.Update_Invoice_Id_Ref( invoice_id_, company_, invoice_data_.identity, invoice_data_.party_type, ledger_item_series_id_, ledger_item_id_, ledger_item_version_id_ ); 
   $END   
   -- gelr:out_inv_curr_rate_voucher_date, begin
   IF (Company_Localization_Info_API.Get_Parameter_Value_Db(company_, 'OUT_INV_CURR_RATE_VOUCHER_DATE') = Fnd_Boolean_API.DB_TRUE) THEN
      attr_ := NULL;
      Client_SYS.Add_To_Attr('COMPANY', company_, attr_);
      Client_SYS.Add_To_Attr('INVOICE_ID', invoice_id_, attr_);
      Client_SYS.Add_To_Attr('DELIVERY_DATE', payment_date_, attr_);
      Customer_Invoice_Pub_Util_API.Modify_Invoice_Head(attr_, 'CUSTOMER_ORDER_INV_HEAD_API');
   END IF;
   -- gelr:out_inv_curr_rate_voucher_date, end
END Create_Prepayment_Invoice__;


-- Is_Invoice_Exist_For_Payment__
--   Check Invoice exist for a payment. This is requiered for prepayment
--   invoices created.
@UncheckedAccess
FUNCTION Is_Invoice_Exist_For_Payment__ (
   identity_               IN VARCHAR2,
   company_                IN VARCHAR2,
   ledger_item_series_id_  IN VARCHAR2,
   ledger_item_id_         IN VARCHAR2,
   ledger_item_version_    IN NUMBER,
   party_type_db_          IN VARCHAR2 ) RETURN VARCHAR2
IS
   invoice_id_    NUMBER;

   CURSOR get_invoice_details IS
      SELECT invoice_id
      FROM CUSTOMER_ORDER_INV_HEAD
      WHERE identity = identity_
      AND company = company_
      AND ledger_item_series_id = ledger_item_series_id_
      AND ledger_item_id = ledger_item_id_
      AND ledger_item_version_id = ledger_item_version_
      AND party_type = party_type_db_;

BEGIN
   OPEN get_invoice_details;
   FETCH get_invoice_details INTO invoice_id_;
   CLOSE get_invoice_details;
   IF (invoice_id_ IS NULL) THEN
      RETURN 'FALSE';
   ELSE
      RETURN 'TRUE';
   END IF;
END Is_Invoice_Exist_For_Payment__;



-- Reconsume_Prepaym_Inv_Lines__
--   This method will be called when a modification is done to a invoive
--   which have prepayment lines. First it calls the Unconsume_Prepaym_Inv_Lines___
--   to unconsume the consumed lines and then calls the Consume_Prepaym_Inv_Lines___
--   to consume the lines again.
PROCEDURE Reconsume_Prepaym_Inv_Lines__ (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER,
   order_no_   IN VARCHAR2 )
IS
BEGIN
   Unconsume_Prepaym_Inv_Lines___(company_, invoice_id_, TRUE);
   Consume_Prepaym_Inv_Lines___(company_, invoice_id_, order_no_);
END Reconsume_Prepaym_Inv_Lines__;


PROCEDURE Chk_Ship_Adv_Pre_Inv_Exist__ (
   result_            OUT VARCHAR2,
   order_nos_         OUT VARCHAR2,
   inv_type_          OUT VARCHAR2,
   shipment_id_       IN  VARCHAR2,
   customer_no_       IN  VARCHAR2,
   contract_          IN  VARCHAR2,
   currency_code_     IN  VARCHAR2,
   pay_term_id_       IN  VARCHAR2,
   bill_addr_no_      IN  VARCHAR2,
   jinsui_invoice_db_ IN  VARCHAR2 )
IS
   advance_payment_exist_  BOOLEAN     := FALSE;
   adv_prepaym_inv_exist_  VARCHAR2(5) := 'FALSE';

   CURSOR  get_order_no IS
      SELECT DISTINCT co.order_no
      FROM   CUSTOMER_ORDER_LINE_TAB col, CUSTOMER_ORDER_TAB co, SHIPMENT_LINE_PUB sol
      WHERE  NVL(co.customer_no_pay_addr_no, co.bill_addr_no) = bill_addr_no_
      AND    NVL(co.customer_no_pay, co.customer_no) = customer_no_
      AND    co.currency_code = currency_code_
      AND    co.pay_term_id = pay_term_id_
      AND    co.contract  = contract_
      AND    co.order_no = sol.source_ref1
      AND    sol.source_ref_type_db = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER
      AND    col.order_no = co.order_no
      AND    co.jinsui_invoice = jinsui_invoice_db_
      AND    sol.shipment_id = shipment_id_
      AND    col.rowstate NOT IN ('Invoiced', 'Cancelled');
BEGIN
   result_ := 'FALSE';
   order_nos_ := NULL;
   FOR rec_ IN get_order_no LOOP
      advance_payment_exist_ := Customer_Order_Inv_Head_API.Check_Advance_Inv_Exist__(rec_.order_no);
      adv_prepaym_inv_exist_ := Customer_Invoice_Pub_Util_API.Has_Adv_Or_Prepaym_Inv(rec_.order_no);

      IF (adv_prepaym_inv_exist_ = 'TRUE') THEN
         IF (advance_payment_exist_) THEN
            inv_type_ := 'Advance';  
         END IF;
         result_   := 'TRUE';

         IF order_nos_ IS NULL THEN
            order_nos_ := rec_.order_no;
         ELSE
            order_nos_ := order_nos_ || ', ' || rec_.order_no;
         END IF;
      END IF;

   END LOOP;
END Chk_Ship_Adv_Pre_Inv_Exist__;


-- Create_Rebate_Credit_Invoice__
--   Creates credit invoice for rebate periodic settlement and rebate final settlement.
PROCEDURE Create_Rebate_Credit_Invoice__ (
   aggregation_no_   IN NUMBER,
   print_invoice_    IN VARCHAR2,
   final_settlement_ IN VARCHAR2 )
IS
   rebate_periodic_agg_head_rec_ Rebate_Periodic_Agg_Head_API.Public_Rec;
   rebate_final_agg_head_rec_    Rebate_Final_Agg_Head_API.Public_Rec;
   agreement_rec_                Rebate_Agreement_API.Public_Rec;
   company_                      VARCHAR2(20);
   customer_no_                  Customer_Order_Tab.customer_no%TYPE;
   agreement_id_                 VARCHAR2(10);
   invoice_id_                   NUMBER;
   do_not_invoice_               VARCHAR2(5);
   currency_code_                VARCHAR2(3);
   item_id_                      NUMBER;
   sales_price_                  NUMBER;
   sales_price_incl_tax_         NUMBER;
   contract_                     VARCHAR2(5);
   tax_percentage_               NUMBER;
   print_attr_                   VARCHAR2(200);
   calc_base_                    VARCHAR2(20);
   pay_term_id_                  VARCHAR2(20);
   catalog_no_                   VARCHAR2(2000);
   catalog_desc_                 VARCHAR2(2000);
   -- gelr:invoice_reason, begin
   invoice_reason_id_            Customer_Order_Tab.invoice_reason_id%TYPE;
   -- gelr:invoice_reason, end
   -- gelr:mx_xml_doc_reporting, begin
   correction_reason_id_         VARCHAR2(20);
   correction_reason_            VARCHAR2(2000);
   -- gelr:mx_xml_doc_reporting, end
   inv_customer_no_              VARCHAR2(20);

   CURSOR get_contract_periodic IS
      SELECT distinct(contract)
      FROM REBATE_TRANSACTION_TAB
      WHERE period_aggregation_no = aggregation_no_;

   CURSOR get_contract_final IS
      SELECT distinct(contract)
      FROM REBATE_TRANSACTION_TAB
      WHERE final_aggregation_no = aggregation_no_;

   CURSOR  get_periodic_agr_lines_ IS
      SELECT *
      FROM   REBATE_PERIODIC_AGG_LINE_TAB
      WHERE  aggregation_no = aggregation_no_;

   CURSOR  get_final_agr_lines_ IS
      SELECT *
      FROM   REBATE_FINAL_AGG_LINE_TAB
      WHERE  aggregation_no = aggregation_no_;

BEGIN

   IF final_settlement_ = 'FALSE' THEN
      Rebate_Periodic_Agg_Head_API.Exist(aggregation_no_);
      -- Get settlement head rec
      rebate_periodic_agg_head_rec_ := Rebate_Periodic_Agg_Head_API.Get(aggregation_no_);
      company_          := rebate_periodic_agg_head_rec_.company;
      customer_no_      := rebate_periodic_agg_head_rec_.customer_no;
      agreement_id_     := rebate_periodic_agg_head_rec_.agreement_id;
      invoice_id_       := rebate_periodic_agg_head_rec_.invoice_id;
      do_not_invoice_   := rebate_periodic_agg_head_rec_.do_not_invoice;
      OPEN get_contract_periodic;
      FETCH get_contract_periodic INTO contract_;
      CLOSE get_contract_periodic;
   ELSE
      Rebate_Final_Agg_Head_API.Exist(aggregation_no_);
      -- Get settlement head rec
      rebate_final_agg_head_rec_ := Rebate_Final_Agg_Head_API.Get(aggregation_no_);
      company_          := rebate_final_agg_head_rec_.company;
      customer_no_      := rebate_final_agg_head_rec_.customer_no;
      agreement_id_     := rebate_final_agg_head_rec_.agreement_id;
      invoice_id_       := rebate_final_agg_head_rec_.invoice_id;
      do_not_invoice_   := rebate_final_agg_head_rec_.do_not_invoice;
      OPEN get_contract_final;
      FETCH get_contract_final INTO contract_;
      CLOSE get_contract_final;
   END IF;

   -- Check to see if the settlement is invoiced.
   IF (invoice_id_ IS NOT NULL) THEN
      Error_SYS.Record_General(lu_name_, 'AGGALREADYINV: The settlement is already invoiced.');
   END IF;

   -- Check if the do_not_invoice is ticked
   IF (do_not_invoice_ = 'TRUE') THEN
      Error_SYS.Record_General(lu_name_, 'DONOTINVOICEAGG: The aggregation ":P1" cannot be invoiced! The "Do not invoice" flag is set on the settlement.', aggregation_no_);
   END IF;
   agreement_rec_    := Rebate_Agreement_API.Get(agreement_id_);
   currency_code_    := agreement_rec_.Currency_Code;
   pay_term_id_      := agreement_rec_.Pay_Term_Id;
   
   IF (agreement_rec_.ignore_inv_cust = 'FALSE') THEN
      inv_customer_no_  := Cust_Ord_Customer_API.Get_Customer_No_Pay(customer_no_);
   END IF;
   
   -- gelr:invoice_reason, begin
   IF (Company_Localization_Info_API.Get_Parameter_Value_Db(company_, 'INVOICE_REASON') = Fnd_Boolean_API.DB_TRUE) THEN 
      invoice_reason_id_ := Identity_Invoice_Info_API.Get_Invoice_Reason_Id(company_, customer_no_, Party_Type_API.Decode(Party_Type_API.DB_CUSTOMER));
   END IF;
   -- gelr:invoice_reason, end
   -- gelr:mx_xml_doc_reporting, begin
   IF (Company_Localization_Info_API.Get_Parameter_Value_Db(company_, 'MX_XML_DOC_REPORTING') = Fnd_Boolean_API.DB_TRUE) THEN 
      correction_reason_id_ := Invoice_Type_API.Get_Correction_Reason_Id(company_, Party_Type_API.Decode(Party_Type_API.DB_CUSTOMER), Company_Def_Invoice_Type_API.Get_Co_Rebate_Cre_Inv_Type(company_));
      correction_reason_    := Correction_Reason_API.Get_Correction_Reason(company_, correction_reason_id_);
   END IF;
   -- gelr:mx_xml_doc_reporting, end
   
   -- Create the invoice head for Periodic Settlement
   Customer_Order_Inv_Head_API.Create_Invoice_Head(
      invoice_id_              => invoice_id_,
      company_                 => company_,
      order_no_                => NULL,
      customer_no_             => customer_no_,
      customer_no_pay_         => NVL(inv_customer_no_, customer_no_),
      authorize_name_          => agreement_rec_.Authorize_Code,
      date_entered_            => SYSDATE,
      cust_ref_                => Cust_Ord_Customer_API.Fetch_Cust_Ref(NVL(inv_customer_no_, customer_no_), NULL, 'FALSE'),
      ship_via_desc_           => NULL,
      forward_agent_id_        => NULL,
      label_note_              => NULL,
      delivery_terms_desc_     => NULL,
      del_terms_location_      => NULL,
      pay_term_id_             => pay_term_id_,
      currency_code_           => currency_code_,
      ship_addr_no_            => NULL,
      customer_no_pay_addr_no_ => Cust_Ord_Customer_API.Get_Document_Address(NVL(inv_customer_no_, customer_no_)),
      bill_addr_no_            => Cust_Ord_Customer_API.Get_Document_Address(customer_no_),
      wanted_delivery_date_    => NULL,
      invoice_type_            => Company_Def_Invoice_Type_API.Get_Co_Rebate_Cre_Inv_Type(company_),
      number_reference_        => NULL,
      series_reference_        => NULL,
      contract_                => NULL,
      js_invoice_state_db_     => NULL,
      currency_rate_type_      => NULL,
      collect_                 => NULL,
      rma_no_                  => NULL,
      shipment_id_             => NULL,
      adv_invoice_             => NULL,
      adv_pay_base_date_       => NULL,
      sb_reference_no_         => NULL,
      use_ref_inv_curr_rate_   => 'FALSE',
      ledger_item_id_          => NULL,
      ledger_item_series_id_   => NULL,
      ledger_item_version_id_  => NULL,
      aggregation_no_          => aggregation_no_,
      final_settlement_        => final_settlement_,
      project_id_              => NULL,
      tax_id_number_           => NULL,
      tax_id_type_             => NULL,
      branch_                  => NULL,
      supply_country_db_       => Company_API.Get_Country_Db(company_),
      invoice_date_            => NULL,
      use_price_incl_tax_db_   => 'FALSE',
      wht_amount_base_         => NULL,
      curr_rate_new_           => NULL,
      tax_curr_rate_new_       => NULL,
      correction_reason_id_    => correction_reason_id_,
      correction_reason_       => correction_reason_,
      is_simulated_            => 'FALSE',
      invoice_reason_id_       => invoice_reason_id_);
      
   -- Get Tax regime to be used when creating tax lines
   IF final_settlement_ = 'FALSE' THEN
      -- Create invoice lines for Periodic Settlement
      -- USE THE CUSTOMERS CURRENCY AND CONV. FACTOR! Currency from customers invoice tab (connected to company)
      FOR periodic_line_ IN get_periodic_agr_lines_ LOOP
         tax_percentage_ := NVL(Statutory_Fee_API.Get_Percentage(company_, periodic_line_.tax_code),0);
         sales_price_ := periodic_line_.total_rebate_amount;
         calc_base_ := 'NET_BASE';
         Tax_Handling_Util_API.Calculate_Prices(sales_price_, sales_price_incl_tax_, calc_base_, tax_percentage_, ifs_curr_rounding_ => 16);

         IF periodic_line_.rebate_type != '*' THEN
            IF ((agreement_rec_.agreement_type = 'SALES_PART') OR (agreement_rec_.agreement_type = 'ALL' AND agreement_rec_.all_sales_part_level = Rebate_All_Sales_Level_API.DB_INCLUDE_SALES_PART)) THEN
               catalog_no_    := SUBSTR(periodic_line_.rebate_type || ' - ' || periodic_line_.part_no, 1, 2000);
               catalog_desc_  := SUBSTR(Rebate_Type_API.Get_Description(periodic_line_.rebate_type) || ' - ' ||
                                          Sales_Part_API.Get_Catalog_Desc(contract_, periodic_line_.part_no), 1, 2000);
            ELSE
               catalog_no_    := periodic_line_.rebate_type;
               catalog_desc_  := Rebate_Type_API.Get_Description(periodic_line_.rebate_type);
            END IF;
            Customer_Order_Inv_Item_API.Create_Invoice_Item(
               item_id_,                                                      -- ITEM_ID_                                               item_id_
               invoice_id_,                                                   -- INVOICE_ID_                                            invoice_id_
               company_,                                                      -- COMPANY                                                company_
               NULL,                                                          -- ORDER_NO_ (N/A)                                        order_no_
               NULL,                                                          -- LINE_NO_/POS (N/A)                                     line_no_
               NULL,                                                          -- REL_NO_ (N/A)                                          rel_no_
               periodic_line_.line_no,                                        -- LINE_ITEM_NO_ (N/A)                                    line_item_no_
               NULL,                                                          -- CONTRACT_ (N/A)                                        contract_
               catalog_no_,                                                   -- CATALOG_NO_/INVOICE ITEM (Rebate type)                 catalog_no_
               catalog_desc_,                                                 -- CATALOG_DESC_ (Rebate Type Description)                catalog_desc_
               NULL,                                                          -- sales_unit_meas_ (N/A)                                 sales_unit_meas_
               1,                                                             -- PRICE_CONV_FACTOR_ (Always 1)                          price_conv_factor_
               sales_price_,                                                  -- SALE_UNIT_PRICE_                                       sale_unit_price_
               sales_price_incl_tax_,                                         -- UNIT_PRICE_INCL_TAX_                                   unit_price_incl_tax_
               0,                                                             -- DISCOUNT_ (zero)                                       discount_
               0,                                                             -- ORDER_DISCOUNT_ (zero)                                 order_discount_
               periodic_line_.tax_code,                                       -- VAT_CODE_                                              vat_code_
               NULL,                                                          -- TOTAL_TAX_PERCENTAGE_                                  total_tax_percentage_
               1,                                                             -- INVOICED_QTY_ (always 1 since qty not available)       invoiced_qty_
               NULL,                                                          -- CUSTOMER_PO_NO_                                        customer_po_no_
               NULL,                                                          -- DELIV_TYPE_ID_                                         deliv_type_id_
               -1,                                                            -- INVOICED_QTY_COUNT_                                    invoiced_qty_count_
               NULL,                                                          -- CHARGE_SEQ_NO_ (N/A)                                   charge_seq_no_
               NULL,                                                          -- CHARGE_GROUP_ (N/A)                                    charge_group_
               NULL,                                                          -- STAGE_ staged billing stage number (N/A)               stage_
               'TRUE',                                                        -- Prel_Update_Allowed
               NULL,                                                          -- rma_no_
               NULL,                                                          -- rma_line_no_
               NULL,                                                          -- rma_charge_no_
               NULL,                                                          -- deb_invoice_id_
               NULL,                                                          -- deb_item_id_
               0,                                                             -- add_discount_
               periodic_line_.sales_part_rebate_group,                        -- sales_part_rebate_group_
               periodic_line_.assortment_id,                                  -- assortment_id_
               periodic_line_.assortment_node_id);                            -- assortment_node_id_
   
                                                      
            -- Create tax lines for the invoice lines
            Tax_Handling_Order_Util_API.Transfer_Tax_lines(company_, 
                                                  Tax_Source_API.DB_INVOICE,
                                                  invoice_id_,
                                                  item_id_,
                                                  '*',
                                                  '*',
                                                  '*',
                                                  Tax_Source_API.DB_INVOICE,
                                                  invoice_id_,
                                                  item_id_,
                                                  '*',
                                                  '*',
                                                  '*',
                                                  'TRUE',
                                                  'FALSE');
            Add_Control_Type_Values___ ( aggregation_no_, 
                                         periodic_line_.line_no,
                                         'FALSE',
                                         '29',
                                         company_,
                                         invoice_id_,
                                         item_id_,
                                         periodic_line_.tax_code);
            IF (periodic_line_.total_rebate_cost_amount IS NOT NULL AND periodic_line_.total_rebate_amount IS NOT NULL) THEN                             
               IF (periodic_line_.total_rebate_amount > periodic_line_.total_rebate_cost_amount) THEN
                  IF (periodic_line_.total_rebate_amount - periodic_line_.total_rebate_cost_amount > 0) THEN
                     Add_Control_Type_Values___ ( aggregation_no_, 
                                         periodic_line_.line_no,
                                         'FALSE',
                                         '30',
                                         company_,
                                         invoice_id_,
                                         item_id_,
                                         periodic_line_.tax_code);
                  END IF; 
               END IF;
            END IF; 
         END IF;
      END LOOP;

      -- Update Rebate Settlement with the invoice id.
      Rebate_Periodic_Agg_Head_API.Set_Invoice_Id(aggregation_no_, invoice_id_);
   ELSE
      -- Create invoice lines for Final Settlement
      -- USE THE CUSTOMERS CURRENCY AND CONV. FACTOR! Currency from customers invoice tab (connected to company)
      FOR final_line_ IN get_final_agr_lines_ LOOP
         tax_percentage_ := NVL(Statutory_Fee_API.Get_Percentage(company_, final_line_.tax_code),0);
         sales_price_ := final_line_.amount_to_invoice;
         calc_base_ := 'NET_BASE';
         
         Tax_Handling_Util_API.Calculate_Prices(sales_price_, sales_price_incl_tax_, calc_base_, tax_percentage_, ifs_curr_rounding_ => 16);
         IF final_line_.rebate_type != '*' THEN
            
            IF ((agreement_rec_.agreement_type = 'SALES_PART') OR (agreement_rec_.agreement_type = 'ALL' AND agreement_rec_.all_sales_part_level = Rebate_All_Sales_Level_API.DB_INCLUDE_SALES_PART)) THEN
               catalog_no_    := SUBSTR(final_line_.rebate_type || ' - ' || final_line_.part_no, 1, 2000);
               catalog_desc_  := SUBSTR(Rebate_Type_API.Get_Description(final_line_.rebate_type) || ' - ' ||
                                          Sales_Part_API.Get_Catalog_Desc(contract_, final_line_.part_no), 1, 2000);
            ELSE
               catalog_no_    := final_line_.rebate_type;
               catalog_desc_  := Rebate_Type_API.Get_Description(final_line_.rebate_type);
            END IF;
            
            Customer_Order_Inv_Item_API.Create_Invoice_Item(
               item_id_,                                                      -- ITEM_ID_
               invoice_id_,                                                   -- INVOICE_ID_
               company_,                                                      -- COMPANY
               NULL,                                                          -- ORDER_NO_ (N/A)
               NULL,                                                          -- LINE_NO_/POS (N/A)
               NULL,                                                          -- REL_NO_ (N/A)
               final_line_.line_no,                                           -- LINE_ITEM_NO_ (N/A)
               NULL,                                                          -- CONTRACT_ (N/A)
               catalog_no_,                                                   -- CATALOG_NO_/INVOICE ITEM (Rebate type)
               catalog_desc_,                                                 -- CATALOG_DESC_ (Rebate Type Description)
               NULL,                                                          -- sales_unit_meas_ (N/A)
               1,                                                             -- PRICE_CONV_FACTOR_ (Always 1)
               sales_price_,                                                  -- SALE_UNIT_PRICE_
               sales_price_incl_tax_,                                         -- UNIT_PRICE_INCL_TAX_
               0,                                                             -- DISCOUNT_ (zero)
               0,                                                             -- ORDER_DISCOUNT_ (zero)
               final_line_.tax_code,                                          -- VAT_CODE_
               NULL,                                                          -- TOTAL_TAX_PERCENTAGE_
               1,                                                             -- INVOICED_QTY_ (always 1 since qty not available)
               NULL,                                                          -- CUSTOMER_PO_NO_
               NULL,                                                          -- DELIV_TYPE_ID_
               -1,                                                            -- INVOICED_QTY_COUNT_
               NULL,                                                          -- CHARGE_SEQ_NO_ (N/A)
               NULL,                                                          -- CHARGE_GROUP_ (N/A)
               NULL,                                                          -- STAGE_ staged billing stage number (N/A)
               'TRUE',                                                        -- Prel_Update_Allowed
               NULL,                                                          -- rma_no_
               NULL,                                                          -- rma_line_no_
               NULL,                                                          -- rma_charge_no_
               NULL,                                                          -- deb_invoice_id_
               NULL,                                                          -- deb_item_id_
               0,                                                             -- add_discount_
               final_line_.sales_part_rebate_group,                           -- sales_part_rebate_group_
               final_line_.assortment_id,                                     -- assortment_id_
               final_line_.assortment_node_id);                               -- assortment_node_id_
               
            
   
            -- Create tax lines for the invoice lines
            Tax_Handling_Order_Util_API.Transfer_Tax_lines(company_, 
                                                  Tax_Source_API.DB_INVOICE,
                                                  invoice_id_,
                                                  item_id_,
                                                  '*',
                                                  '*',
                                                  '*',
                                                  Tax_Source_API.DB_INVOICE,
                                                  invoice_id_,
                                                  item_id_,
                                                  '*',
                                                  '*',
                                                  '*',
                                                  'TRUE',
                                                  'FALSE');
                                                  
            IF (sales_price_ > 0) THEN
               Add_Control_Type_Values___ ( aggregation_no_, 
                                            final_line_.line_no,
                                            'TRUE',
                                            '30',
                                            company_,
                                            invoice_id_,
                                            item_id_,
                                            final_line_.tax_code);
               IF (Rebate_Final_Agg_Line_API.Get_Remaining_Cost(aggregation_no_, final_line_.line_no) > 0) THEN
                  Add_Control_Type_Values___ ( aggregation_no_, 
                                               final_line_.line_no,
                                               'TRUE',
                                               '29',
                                               company_,
                                               invoice_id_,
                                               item_id_,
                                               final_line_.tax_code);
               END IF; 
            END IF; 
            
            
            
         END IF;
      END LOOP;

      -- Update Rebate Settlement with the invoice id.
      Rebate_Final_Agg_Head_API.Set_Invoice_Id(aggregation_no_, invoice_id_);
   END IF;

   -- Complete the invoice creation
   Customer_Order_Inv_Head_API.Create_Invoice_Complete(company_, invoice_id_, 'FALSE');

   -- Automatically print the invoice
   IF print_invoice_ = 'TRUE' THEN
      Client_SYS.Clear_Attr(print_attr_);
      Client_SYS.Add_To_Attr('INVOICE_ID', invoice_id_, print_attr_);
      Customer_Order_Inv_Head_API.Print_Invoices(print_attr_);
   END IF;
END Create_Rebate_Credit_Invoice__;


-- Batch_Coll_Ivc_Orders__
--   In order to facilitate large number of orders in Make_Collect_Ivc_Ord__,
--   this method will buffer the order numbers to added to the collective invoice in BATCH_COLLECT_IVC_ORDERS_TAB.
--   Create_Collect_Ivc_Ord__ will read records for the herder order number from this buffer table.
--   If all the order list has been buffered, in that case header_order_no_ will be not null. Then Make_Collect_Ivc_Ord__ will create the background job from this method.
PROCEDURE Batch_Coll_Ivc_Orders__ (
   attr_                IN VARCHAR2,
   header_order_no_     IN VARCHAR2)
IS   
BEGIN
   Buffer_Coll_Ivc_Orders___(attr_);
   IF (header_order_no_ IS NOT NULL) THEN       
      Make_Collect_Ivc_Ord__(header_order_no_);
   END IF;
END Batch_Coll_Ivc_Orders__;


-- Clear_Batch_Coll_Ivc_Orders__
--   Clears the buffered order list for the herder order number used in the collective invoice creation.
PROCEDURE Clear_Batch_Coll_Ivc_Orders__ (
   head_order_no_ IN VARCHAR2 )
IS
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
   DELETE FROM BATCH_COLLECT_IVC_ORDERS_TAB
      WHERE head_order_no = head_order_no_;
   @ApproveTransactionStatement(2014-08-11,mahplk)
   COMMIT;
END Clear_Batch_Coll_Ivc_Orders__;


-- Batch_Create_Cust_Invoices__
--   This method will create customer invoices for the given parameters
--   company, contract, order_id, customer_no, authorize_code, salesman_code and priority.
PROCEDURE Batch_Create_Cust_Invoices__ (
   message_ IN VARCHAR2 )
IS
   count_          NUMBER;
   name_arr_       Message_SYS.name_table;
   value_arr_      Message_SYS.line_table;

   company_        VARCHAR2(20);
   contract_       VARCHAR2(5);
   order_id_       VARCHAR2(3);
   customer_no_    VARCHAR2(20);
   authorize_code_ VARCHAR2(20);
   salesman_code_  VARCHAR2(20);
   priority_       NUMBER;

   cust_ivc_attr_  VARCHAR2(2000);
   description_    VARCHAR2(100);
   ivc_unconct_chg_seperatly_ NUMBER := 0;
   
   CURSOR get_orders IS
      SELECT order_no
      FROM customer_order co
      WHERE co.objstate != 'Invoiced'
      AND   co.company   = company_
      AND   co.contract       LIKE contract_
      AND   co.order_id       LIKE order_id_
      AND   co.customer_no    LIKE customer_no_
      AND   co.authorize_code LIKE authorize_code_
      AND   NVL(co.salesman_code, '%') LIKE salesman_code_
      AND   (priority_ IS NULL OR co.priority = priority_)
      AND   (ivc_unconct_chg_seperatly_ = 1
            OR co.objstate IN ('PartiallyDelivered', 'Delivered') 
            OR co.order_no IN (SELECT col.order_no
                               FROM   customer_order_line col
                               WHERE  col.order_no = co.order_no
                               AND    col.staged_billing_db = 'STAGED BILLING')
            OR co.order_no NOT IN (SELECT col.order_no
                                  FROM   customer_order_line col
                                  WHERE  col.order_no = co.order_no));
BEGIN
   -- In parameters are:  Company - not null
   --                     Contract - not null
   --                     Order_Id - not null
   --                     Customer_No - not null
   --                     Authorize_Code - not null
   --                     Salesman_Code - not null
   --                     Priority
   --                     ivc_unconct_chg_seperatly
   -- Unpack the in parameters
   Message_SYS.Get_Attributes(message_, count_, name_arr_, value_arr_);
   FOR n_ IN 1..count_ LOOP
      IF (name_arr_(n_) = 'COMPANY') THEN
         company_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'CONTRACT') THEN
         contract_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'ORDER_ID') THEN
         order_id_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'CUSTOMER_NO') THEN
         customer_no_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'AUTHORIZE_CODE') THEN
         authorize_code_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'SALESMAN_CODE') THEN
         salesman_code_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'PRIORITY') THEN
         priority_ := Client_SYS.Attr_Value_To_Number(value_arr_(n_));
      ELSIF (name_arr_(n_) = 'IVC_UNCONCT_CHG_SEPERATLY') THEN
         ivc_unconct_chg_seperatly_ :=  Client_SYS.Attr_Value_To_Number(value_arr_(n_));
      ELSE
         Error_SYS.Record_General(lu_name_, 'INCORRECT_MESSAGE: Item :P1 can not be used in this method.', name_arr_(n_));
      END IF;
   END LOOP;

   
   FOR rec_ IN get_orders LOOP
      IF(Customer_Order_Flow_API.Create_Invoice_Allowed__(rec_.order_no, TRUE, ivc_unconct_chg_seperatly_) = 1) THEN
         Client_SYS.Clear_Attr(cust_ivc_attr_);
         Client_SYS.Add_To_Attr('START_EVENT', '500',         cust_ivc_attr_);
         Client_SYS.Add_To_Attr('ORDER_NO',    rec_.order_no, cust_ivc_attr_);
         Client_SYS.Add_To_Attr('END',         '',            cust_ivc_attr_);

         description_ := Language_SYS.Translate_Constant(lu_name_, 'FROM_CREATE_INVOICE: Create Invoice for Customer Order');
         Transaction_SYS.Deferred_Call('CUSTOMER_ORDER_FLOW_API.Process_From_Create_Invoice__', cust_ivc_attr_, description_);
      END IF;
   END LOOP;
END Batch_Create_Cust_Invoices__;


-- Batch_Create_Coll_Invoices__
--   This method will create collective invoices for the given parameters
--   company, contract, customer_no, currency_code, pay_term_id and planned_invoice_date_offset.
PROCEDURE Batch_Create_Coll_Invoices__ (
   message_ IN VARCHAR2 )
IS
   count_                        NUMBER;
   name_arr_                     Message_SYS.name_table;
   value_arr_                    Message_SYS.line_table;

   company_                      VARCHAR2(20);
   contract_                     VARCHAR2(5);
   customer_no_                  VARCHAR2(20);
   currency_code_                VARCHAR2(3);
   pay_term_id_                  VARCHAR2(20);
   planned_invoice_date_offset_  NUMBER;
   planned_invoice_date_         DATE;

   coll_ivc_attr_                VARCHAR2(2000);
   description_                  VARCHAR2(100);
   closest_close_invoice_date_   DATE;
   ivc_unconct_chg_seperatly_    NUMBER := 0;
   
   -- The Customer_Order_Collect_Invoice will be created in post installation
   -- Therefore added ORDER check (intially it will be false) in order to skip in intial deployment of the package.
   $IF (Component_Order_SYS.INSTALLED) $THEN
      CURSOR get_orders IS
         SELECT customer_no, contract, currency_code, pay_term_id, bill_addr_no, jinsui_invoice, project_id, currency_rate_type, tax_liability_country_db, use_price_incl_tax
         FROM CUSTOMER_ORDER_COLLECT_INVOICE
         WHERE company       = company_
         AND   contract      LIKE contract_
         AND   customer_no   LIKE customer_no_
         AND   currency_code LIKE currency_code_
         AND   pay_term_id   LIKE pay_term_id_;
   $END   
BEGIN
   -- In parameters are:  Company - not null
   --                     Contract - not null
   --                     Customer_No - not null
   --                     Currency_Code - not null
   --                     Pay_Term_Id - not null
   --                     Planned_Invoice_Date_Offset
   --                     ivc_unconct_chg_seperatly
   -- Unpack the in parameters
   Message_SYS.Get_Attributes(message_, count_, name_arr_, value_arr_);
   FOR n_ IN 1..count_ LOOP
      IF (name_arr_(n_) = 'COMPANY') THEN
         company_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'CONTRACT') THEN
         contract_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'CUSTOMER_NO') THEN
         customer_no_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'CURRENCY_CODE') THEN
         currency_code_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'PAY_TERM_ID') THEN
         pay_term_id_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'PLANNED_INVOICE_DATE_OFFSET') THEN
         planned_invoice_date_offset_ := Client_SYS.Attr_Value_To_Number(value_arr_(n_));
      ELSIF (name_arr_(n_) = 'IVC_UNCONCT_CHG_SEPERATLY') THEN
         ivc_unconct_chg_seperatly_ :=  Client_SYS.Attr_Value_To_Number(value_arr_(n_));
      ELSE
         Error_SYS.Record_General(lu_name_, 'INCORRECT_MESSAGE: Item :P1 can not be used in this method.', name_arr_(n_));
      END IF;
   END LOOP;
   
   $IF (Component_Order_SYS.INSTALLED) $THEN   
      FOR rec_ IN get_orders LOOP
         IF planned_invoice_date_offset_ IS NOT NULL THEN
            planned_invoice_date_ := Cust_Invoice_Close_Date_API.Get_Planned_Invoice_Date(rec_.customer_no, rec_.contract);
         END IF;
         
         IF ((planned_invoice_date_offset_ IS NULL) OR (planned_invoice_date_ IS NULL) OR (planned_invoice_date_ <= TRUNC(sysdate) + planned_invoice_date_offset_)) THEN
            closest_close_invoice_date_ := Cust_Invoice_Close_Date_API.Get_Closest_Closing_Day(rec_.customer_no, rec_.contract, planned_invoice_date_offset_);            
            Client_SYS.Clear_Attr(coll_ivc_attr_);
            Client_SYS.Add_To_Attr('CUSTOMER_NO',              rec_.customer_no,              coll_ivc_attr_);
            Client_SYS.Add_To_Attr('CONTRACT',                 rec_.contract,                 coll_ivc_attr_);
            Client_SYS.Add_To_Attr('CURRENCY_CODE',            rec_.currency_code,            coll_ivc_attr_);
            Client_SYS.Add_To_Attr('PAY_TERM_ID',              rec_.pay_term_id,              coll_ivc_attr_);
            Client_SYS.Add_To_Attr('BILL_ADDR_NO',             rec_.bill_addr_no,             coll_ivc_attr_);

            IF (planned_invoice_date_offset_ IS NULL OR closest_close_invoice_date_ IS NULL) THEN
               Client_SYS.Add_To_Attr('IGNORE_CLOSING_DATE',   'TRUE',                        coll_ivc_attr_);
            ELSE
               Client_SYS.Add_To_Attr('IGNORE_CLOSING_DATE',   'FALSE',                       coll_ivc_attr_);
            END IF;

            Client_SYS.Add_To_Attr('CLOSEST_CLOSING_DATE',     closest_close_invoice_date_,   coll_ivc_attr_);
            Client_SYS.Add_To_Attr('JINSUI_INVOICE_DB',        rec_.jinsui_invoice,           coll_ivc_attr_);
            Client_SYS.Add_To_Attr('PROJECT_ID',               rec_.project_id,               coll_ivc_attr_);
            Client_SYS.Add_To_Attr('CURRENCY_RATE_TYPE',       rec_.currency_rate_type,       coll_ivc_attr_);
            Client_SYS.Add_To_Attr('TAX_LIABILITY_COUNTRY_DB', rec_.tax_liability_country_db, coll_ivc_attr_);
            Client_SYS.Add_To_Attr('USE_PRICE_INCL_TAX',       rec_.use_price_incl_tax,       coll_ivc_attr_);
            Client_SYS.Add_To_Attr('IVC_UNCONCT_CHG_SEPERATLY', ivc_unconct_chg_seperatly_,   coll_ivc_attr_ );

            description_ := Language_SYS.Translate_Constant(lu_name_, 'CRE_COLLINV: Create Collective Customer Invoices');
            Transaction_SYS.Deferred_Call('INVOICE_CUSTOMER_ORDER_API.Create_Collective_Invoice__', coll_ivc_attr_, description_);            
         END IF;  
      END LOOP;
   $END
END Batch_Create_Coll_Invoices__;


-- Batch_Create_Ship_Invoices__
--   This method will create shipment invoices for the given parameters
--   company, contract, customer_no, currency_code and pay_term_id.
PROCEDURE Batch_Create_Ship_Invoices__ (
   message_ IN VARCHAR2 )
IS
   count_          NUMBER;
   name_arr_       Message_SYS.name_table;
   value_arr_      Message_SYS.line_table;

   company_        VARCHAR2(20);
   contract_       VARCHAR2(5);
   customer_no_    VARCHAR2(20);
   currency_code_  VARCHAR2(3);
   pay_term_id_    VARCHAR2(20);

   ship_ivc_attr_  VARCHAR2(2000);
   description_    VARCHAR2(100);
   -- The Customer_Order_Ship_Invoice will be created in post installation
   -- Therefore added ORDER check (intially it will be false) in order to skip in intial deployment of the package.
   $IF (Component_Order_SYS.INSTALLED) $THEN
      CURSOR get_shipments IS
         SELECT customer_no, shipment_id, contract, currency_code, pay_term_id, jinsui_invoice, bill_addr_no, currency_rate_type
         FROM CUSTOMER_ORDER_SHIP_INVOICE
         WHERE company       = company_
         AND   contract      LIKE contract_
         AND   customer_no   LIKE customer_no_
         AND   currency_code LIKE currency_code_
         AND   pay_term_id   LIKE pay_term_id_;
   $END   
BEGIN
   -- In parameters are:  Company - not null
   --                     Contract - not null
   --                     Customer_No - not null
   --                     Currency_Code - not null
   --                     Pay_Term_Id - not null
   -- Unpack the in parameters
   Message_SYS.Get_Attributes(message_, count_, name_arr_, value_arr_);
   FOR n_ IN 1..count_ LOOP
      IF (name_arr_(n_) = 'COMPANY') THEN
         company_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'CONTRACT') THEN
         contract_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'CUSTOMER_NO') THEN
         customer_no_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'CURRENCY_CODE') THEN
         currency_code_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'PAY_TERM_ID') THEN
         pay_term_id_ := value_arr_(n_);
      ELSE
         Error_SYS.Record_General(lu_name_, 'INCORRECT_MESSAGE: Item :P1 can not be used in this method.', name_arr_(n_));
      END IF;
   END LOOP;
   $IF (Component_Order_SYS.INSTALLED) $THEN
      FOR rec_ IN get_shipments LOOP
         Client_SYS.Clear_Attr(ship_ivc_attr_);
         Client_SYS.Add_To_Attr('CUSTOMER_NO',        rec_.customer_no,        ship_ivc_attr_);
         Client_SYS.Add_To_Attr('SHIPMENT_ID',        rec_.shipment_id,        ship_ivc_attr_);
         Client_SYS.Add_To_Attr('CONTRACT',           rec_.contract,           ship_ivc_attr_);
         Client_SYS.Add_To_Attr('CURRENCY_CODE',      rec_.currency_code,      ship_ivc_attr_);
         Client_SYS.Add_To_Attr('PAY_TERM_ID',        rec_.pay_term_id,        ship_ivc_attr_);
         Client_SYS.Add_To_Attr('JINSUI_INVOICE_DB',  rec_.jinsui_invoice,     ship_ivc_attr_);
         Client_SYS.Add_To_Attr('BILL_ADDR_NO',       rec_.bill_addr_no,       ship_ivc_attr_);
         Client_SYS.Add_To_Attr('CURRENCY_RATE_TYPE', rec_.currency_rate_type, ship_ivc_attr_);
         description_ := Language_SYS.Translate_Constant(lu_name_, 'CRE_SHIPINV: Create Shipment Invoices');
         Transaction_SYS.Deferred_Call('INVOICE_CUSTOMER_ORDER_API.Create_Shipment_Invoice__', ship_ivc_attr_, description_);
      END LOOP;
   $END
END Batch_Create_Ship_Invoices__;


-- Batch_Create_Rebate_Invoices__
--   This method will create rebate invoices for the given parameters
--   company, customer_no, agreement_id, hierarchy_id and customer_level.
PROCEDURE Batch_Create_Rebate_Invoices__ (
   message_ IN VARCHAR2 )
IS
   count_           NUMBER;
   name_arr_        Message_SYS.name_table;
   value_arr_       Message_SYS.line_table;

   company_         VARCHAR2(20);
   customer_no_     VARCHAR2(20);
   agreement_id_    VARCHAR2(10);
   hierarchy_id_    VARCHAR2(10);
   customer_level_  NUMBER;

   rebate_ivc_attr_ VARCHAR2(2000);
   description_     VARCHAR2(100);

   CURSOR get_periodic_settlements IS
      SELECT aggregation_no
      FROM rebate_periodic_agg_head_tab 
      WHERE company = company_ 
      AND   invoice_id IS NULL 
      AND   do_not_invoice = 'FALSE' 
      AND   customer_no LIKE customer_no_
      AND   agreement_id LIKE agreement_id_
      AND   hierarchy_id LIKE hierarchy_id_
      AND   (customer_level_ IS NULL OR customer_level LIKE customer_level_);

   CURSOR get_final_settlements IS
      SELECT aggregation_no
      FROM rebate_final_agg_head_tab 
      WHERE company = company_ 
      AND   invoice_id IS NULL 
      AND   do_not_invoice = 'FALSE' 
      AND   customer_no LIKE customer_no_
      AND   agreement_id LIKE agreement_id_
      AND   hierarchy_id LIKE hierarchy_id_
      AND   (customer_level_ IS NULL OR customer_level LIKE customer_level_);
BEGIN
   -- In parameters are:  Company - not null
   --                     Customer_No - not null
   --                     Agreement_Id - not null
   --                     Hierarchy_Id - not null
   --                     Customer_Level
   -- Unpack the in parameters
   Message_SYS.Get_Attributes(message_, count_, name_arr_, value_arr_);
   FOR n_ IN 1..count_ LOOP
      IF (name_arr_(n_) = 'COMPANY') THEN
         company_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'CUSTOMER_NO') THEN
         customer_no_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'AGREEMENT_ID') THEN
         agreement_id_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'HIERARCHY_ID') THEN
         hierarchy_id_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'CUSTOMER_LEVEL') THEN
         customer_level_ := Client_SYS.Attr_Value_To_Number(value_arr_(n_));
      ELSE
         Error_SYS.Record_General(lu_name_, 'INCORRECT_MESSAGE: Item :P1 can not be used in this method.', name_arr_(n_));
      END IF;
   END LOOP;

   FOR rec_ IN get_periodic_settlements LOOP
      Client_SYS.Clear_Attr(rebate_ivc_attr_);
      Client_SYS.Add_To_Attr('START_EVENT',      '500',                rebate_ivc_attr_);
      Client_SYS.Add_To_Attr('AGGREGATION_NO',   rec_.aggregation_no,  rebate_ivc_attr_);
      Client_SYS.Add_To_Attr('FINAL_SETTLEMENT', 'FALSE',              rebate_ivc_attr_);
      Client_SYS.Add_To_Attr('END',              '',                   rebate_ivc_attr_);

      description_ := Language_SYS.Translate_Constant(lu_name_, 'FROM_CRE_REB_INV_P: Create and Print Rebate Credit Invoice');
      Transaction_SYS.Deferred_Call('REBATE_TRANS_AGG_UTIL_API.Process_Rebate_Settlements__', rebate_ivc_attr_, description_);
   END LOOP;

   FOR rec_ IN get_final_settlements LOOP
      Client_SYS.Clear_Attr(rebate_ivc_attr_);
      Client_SYS.Add_To_Attr('START_EVENT',      '500',                rebate_ivc_attr_);
      Client_SYS.Add_To_Attr('AGGREGATION_NO',   rec_.aggregation_no,  rebate_ivc_attr_);
      Client_SYS.Add_To_Attr('FINAL_SETTLEMENT', 'TRUE',               rebate_ivc_attr_);
      Client_SYS.Add_To_Attr('END',              '',                   rebate_ivc_attr_);

      description_ := Language_SYS.Translate_Constant(lu_name_, 'FROM_CRE_REB_INV_P: Create and Print Rebate Credit Invoice');
      Transaction_SYS.Deferred_Call('REBATE_TRANS_AGG_UTIL_API.Process_Rebate_Settlements__', rebate_ivc_attr_, description_);
   END LOOP;

END Batch_Create_Rebate_Invoices__;


-- Create_And_Print_Adv_Invoice__
--   Create Advance Invoice and print it.
PROCEDURE Create_And_Print_Adv_Invoice__ (
   invoice_id_    IN OUT VARCHAR2,
   order_no_      IN     VARCHAR2,
   adv_pay_amt_   IN     NUMBER,
   tax_msg_      IN     VARCHAR2,
   invoice_text_  IN     VARCHAR2,
   pay_base_date_ IN     DATE,
   pay_term_id_   IN     VARCHAR2,
   pay_tax_       IN     VARCHAR2 )
IS
   print_attr_ VARCHAR2(200);
BEGIN
   Create_Advance_Invoice__ (invoice_id_,
                             order_no_ ,
                             adv_pay_amt_,
                             tax_msg_,
                             invoice_text_,
                             pay_base_date_,
                             pay_term_id_,
                             pay_tax_ );
   -- Automatically print the invoice
   Client_SYS.Clear_Attr(print_attr_);
   Client_SYS.Add_To_Attr('INVOICE_ID', invoice_id_, print_attr_);
   -- Since this method always calls from client, added PRINT_BACKGROUND to bypass the history when email is not sent.
   Client_SYS.Add_To_Attr('PRINT_METHOD', 'PRINT_BACKGROUND', print_attr_);
   Customer_Order_Inv_Head_API.Print_Invoices(print_attr_);
END Create_And_Print_Adv_Invoice__;


-- Create_Print_Prepay_Invoice__
--   Creates Prepayment Invoice and print it if print_option_ is 'OFFSET'.
PROCEDURE Create_Print_Prepay_Invoice__ (
   invoice_id_             IN OUT VARCHAR2,
   order_no_               IN VARCHAR2,
   ledger_item_id_         IN VARCHAR2,
   ledger_item_series_id_  IN VARCHAR2,
   ledger_item_version_id_ IN NUMBER,
   prepaym_lines_attr_     IN VARCHAR2,
   print_option_           IN VARCHAR2 )
IS
   print_attr_      VARCHAR2(2000);
   media_code_      VARCHAR2(30) := NULL;
   co_rec_          Customer_Order_API.Public_Rec;
BEGIN

   Create_Prepayment_Invoice__ (invoice_id_,
                                order_no_,
                                ledger_item_id_,
                                ledger_item_series_id_,
                                ledger_item_version_id_,
                                prepaym_lines_attr_);

   IF print_option_ = 'OFFSET' THEN
      Client_SYS.Clear_Attr(print_attr_);
      Client_SYS.Add_To_Attr('INVOICE_ID', invoice_id_, print_attr_);
      -- Since this method always calls from client, added PRINT_BACKGROUND to bypass the history when email is not sent.
      Client_SYS.Add_To_Attr('PRINT_METHOD', 'PRINT_BACKGROUND', print_attr_);
      Client_SYS.Add_To_Attr('PRINT_OPTION', print_option_, print_attr_);
      co_rec_     := Customer_Order_API.Get(order_no_);
      media_code_ := Cust_Ord_Customer_API.Get_Default_Media_Code(nvl(co_rec_.customer_no_pay, co_rec_.customer_no), 'INVOIC', Site_API.Get_Company(co_rec_.contract));
      IF (media_code_ IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('MEDIA_CODE', media_code_, print_attr_);
      END IF;
      Customer_Order_Inv_Head_API.Print_Invoices(print_attr_);
   END IF;
END Create_Print_Prepay_Invoice__;

----------------------------------------------------------------------------
-- Get_Prepayment_Text__
--    This function returns the text "Prepayment" translated to CO hader language.
----------------------------------------------------------------------------
@UncheckedAccess
FUNCTION Get_Prepayment_Text__ (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Language_SYS.Translate_Constant(lu_name_, 'PREPAYMENT: Prepayment', Customer_Order_API.Get_Language_Code(order_no_));
END Get_Prepayment_Text__;

PROCEDURE Finalize_Rate_Credit_Invoice__ (
   credit_inv_id_    IN VARCHAR2,
   company_          IN VARCHAR2)
IS
   print_attr_      VARCHAR2(2000);
BEGIN
   Client_SYS.Clear_Attr(print_attr_);    
   Client_SYS.Add_To_Attr('INVOICE_ID', credit_inv_id_, print_attr_);
   Client_SYS.Add_To_Attr('PRINT_ONLINE', 'FALSE', print_attr_);
   Customer_Order_Inv_Head_API.Print_Invoices(print_attr_);
END Finalize_Rate_Credit_Invoice__;


PROCEDURE Create_Rate_Corr_Invoices__(
   attr_                IN VARCHAR2)
IS
   attr_new_               VARCHAR2(2000) := null;
   company_                VARCHAR2(30); 
   invoice_id_             VARCHAR2(52);   
   curr_rate_              NUMBER;
   tax_curr_rate_          NUMBER;
   invoice_date_           DATE;
   credit_inv_id_          CUSTOMER_ORDER_INV_HEAD.invoice_id%TYPE;
   corr_inv_type_          VARCHAR2(30);
   description_            VARCHAR2(200);
   correction_reason_id_   VARCHAR2(20);
   correction_reason_      VARCHAR2(2000);

   PROCEDURE Add_Values_To_Attr(
      attr_                  IN OUT VARCHAR2,
      invoice_id_            IN VARCHAR2,
      invoice_type_          IN VARCHAR2,
      allow_credit_inv_fee_  IN VARCHAR2 )
   IS
   BEGIN
      Client_SYS.Clear_Attr(attr_new_);
      Client_SYS.Add_To_Attr('REF_INVOICE_ID', invoice_id_, attr_);
      Client_SYS.Add_To_Attr('USE_REF_INV_CURR_RATE', 1, attr_);
      Client_SYS.Add_To_Attr('INVOICE_TYPE', invoice_type_, attr_);
      Client_SYS.Add_To_Attr('INVOICE_DATE', invoice_date_, attr_);
      Client_SYS.Add_To_Attr('ALLOW_CREDIT_INV_FEE', allow_credit_inv_fee_, attr_);
      Client_SYS.Add_To_Attr('CORRECTION_REASON_ID', correction_reason_id_, attr_);
      Client_SYS.Add_To_Attr('CORRECTION_REASON', correction_reason_, attr_);     
   END;

BEGIN   
   company_ :=  Client_Sys.Get_Item_Value('COMPANY',attr_);
   invoice_id_ := Client_Sys.Get_Item_Value('INVOICE_ID',attr_);
   curr_rate_ :=  Client_Sys.Get_Item_Value('CURR_RATE',attr_);
   tax_curr_rate_ := Client_Sys.Get_Item_Value('TAX_CURR_RATE',attr_);
   invoice_date_ := Client_SYS.Attr_Value_To_Date(Client_Sys.Get_Item_Value('INVOICE_DATE',attr_));
   correction_reason_id_ := Client_Sys.Get_Item_Value('CORRECTION_REASON_ID',attr_);
   correction_reason_    := Client_Sys.Get_Item_Value('CORRECTION_REASON',attr_);

   corr_inv_type_ := Company_Def_Invoice_Type_API.Get_Def_Co_Cor_Inv_Type(company_ );
   Add_Values_To_Attr(attr_new_, invoice_id_, corr_inv_type_, 'FALSE');
   Client_SYS.Add_To_Attr('INVOICE_CATEGORY', 'RATE1', attr_new_);
   Create_Credit_Invoice__(attr_new_);
   credit_inv_id_ :=  Client_Sys.Get_Item_Value('INVOICE_ID',attr_new_);

   Finalize_Rate_Credit_Invoice__ (credit_inv_id_, company_);
   Add_Values_To_Attr(attr_new_, invoice_id_, corr_inv_type_, 'FALSE');

   Client_SYS.Add_To_Attr('CURR_RATE', curr_rate_, attr_new_);
   Client_SYS.Add_To_Attr('TAX_CURR_RATE', tax_curr_rate_, attr_new_);
   Client_SYS.Add_To_Attr('INVOICE_CATEGORY', 'RATE2', attr_new_);
  -- Error_SYS.Record_General(lu_name_, tax_curr_rate_);
   Create_Credit_Invoice__(attr_new_);
END Create_Rate_Corr_Invoices__;

PROCEDURE Check_Adv_Credit_Inv_Create__(
   info_       OUT VARCHAR2,
   order_no_   IN  VARCHAR2,
   amount_     IN  NUMBER )
IS
   contract_            VARCHAR2(50);
   company_             VARCHAR2(50);
   check_type_          VARCHAR2(50);
   def_invoice_type_    VARCHAR2(100);
   invoice_amount_      NUMBER;
   order_total_amount_  NUMBER;
   order_total_charge_  NUMBER;
   invoice_id_          NUMBER;
   raise_warning_       BOOLEAN := FALSE;
   
   CURSOR get_invoice_id IS
      SELECT invoice_id
      FROM   customer_order_inv_join
      WHERE  invoice_type = def_invoice_type_
      AND    order_no = order_no_;
      
BEGIN
   contract_             := Customer_Order_API.Get_Contract(order_no_);
   company_              := Site_API.Get_Company(contract_);
   check_type_           := Company_Order_Info_API.Get_Base_For_Adv_Invoice_Db(company_);
   def_invoice_type_     := Company_Def_Invoice_Type_API.Get_Def_Adv_Co_Cr_Inv_Type(company_);
   
   IF check_type_ IN( Base_For_Adv_Invoice_API.DB_NET_AMOUNT, Base_For_Adv_Invoice_API.DB_NET_AMOUNT_WITH_CHARGES ) THEN
      order_total_amount_ := Customer_Order_API.Get_Total_Sale_Price__(order_no_);
      invoice_amount_     := amount_ + Customer_Order_Inv_Head_API.Get_Ad_Net_Without_Invoice_Fee(company_,order_no_, 'TRUE');
   ELSIF check_type_ IN( Base_For_Adv_Invoice_API.DB_GROSS_AMOUNT, Base_For_Adv_Invoice_API.DB_GROSS_AMOUNT_WITH_CHARGES ) THEN
      order_total_amount_ := Customer_Order_API.Get_Ord_Gross_Amount(order_no_);
      invoice_amount_     := amount_ + Customer_Order_Inv_Head_API.Get_Ad_Gro_Without_Invoice_Fee(company_,order_no_, 'TRUE');
   END IF;
   
   IF(check_type_ IN ( Base_For_Adv_Invoice_API.DB_NET_AMOUNT_WITH_CHARGES, Base_For_Adv_Invoice_API.DB_GROSS_AMOUNT_WITH_CHARGES )) THEN
      order_total_charge_   := Customer_Order_API.Get_Total_Sale_Charge__(order_no_);
      order_total_amount_   := order_total_amount_ + order_total_charge_;
   END IF;
   
   IF ( order_total_amount_ < invoice_amount_ )THEN
      FOR rec_ IN get_invoice_id LOOP
         IF( Customer_Order_Inv_Head_API.Get_Invoice_Status_Db(company_, rec_.invoice_id) = 'Preliminary') THEN
            invoice_id_ := rec_.invoice_id;
            raise_warning_ := TRUE;
            EXIT;
         END IF;
      END LOOP;
   END IF;
   
   IF( raise_warning_ ) THEN
      Client_SYS.Add_Warning(lu_name_, 'CREDITINVEXISTS: Credit invoice :P1 exists in Preliminary status.' , invoice_id_);
   END IF;
   info_ := Client_SYS.Get_All_Info;
END Check_Adv_Credit_Inv_Create__;

@IgnoreUnitTest TrivialFunction
PROCEDURE Override_Self_Bill_Tax_Dom__ (
   tax_msg_                     IN OUT NOCOPY VARCHAR2,
   tax_dom_amount_              IN OUT NOCOPY NUMBER,
   company_                     IN VARCHAR2,
   invoice_id_                  IN NUMBER,
   tax_code_                    IN VARCHAR2,
   identity_                    IN VARCHAR2,
   net_curr_amount_             IN NUMBER,
   tax_curr_amount_             IN NUMBER,
   inv_item_tax_dom_amount_     IN NUMBER, 
   tax_percentage_              IN NUMBER)
IS
   head_rec_                     Invoice_API.Public_Rec;
BEGIN 
   head_rec_ := Invoice_API.Get(company_,invoice_id_);
   Tax_Handling_Invoic_Util_API.Check_Max_Overwrite_Level(company_,
                                                          identity_,
                                                          head_rec_.party_type,
                                                          head_rec_.adv_inv, 
                                                          head_rec_.creator,                                                         
                                                          head_rec_.currency,
                                                          head_rec_.delivery_address_id,
                                                          tax_code_,
                                                          tax_percentage_,
                                                          net_curr_amount_+tax_curr_amount_,
                                                          net_curr_amount_,
                                                          head_rec_.curr_rate,
                                                          head_rec_.tax_curr_rate,
                                                          head_rec_.div_factor,
                                                          tax_curr_amount_,
                                                          inv_item_tax_dom_amount_,
                                                          head_rec_.invoice_date);
   Message_SYS.Set_Attribute(tax_msg_,'TAX_DOM_AMOUNT',inv_item_tax_dom_amount_);
   tax_dom_amount_ := inv_item_tax_dom_amount_; 
END Override_Self_Bill_Tax_Dom__;

-- Get_Line_Counts_Per_Supply__ 
--   The count of invoice items for a given supply code is out with supply_count_.
--   If check_other_count_ is 'TRUE', the count of invoice items not containing the given supply code is out with other_count_. 
--  ***** THIS METHOD CREATED FOR CLIENT USE AND WILL RETURN 0 IF THE USER IS NOT ALLOWED THE COMPANY OF INVOICE*****
PROCEDURE Get_Line_Counts_Per_Supply__ (
   supply_count_     OUT NUMBER,
   other_count_      OUT NUMBER,
   company_           IN VARCHAR2,
   invoice_id_        IN VARCHAR2,
   supply_code_db_    IN VARCHAR2,
   check_other_count_ IN VARCHAR2 DEFAULT 'FALSE')
IS
   
   CURSOR get_co_line_count(supply_code_check_ NUMBER) IS
      SELECT count(*)
        FROM customer_order_line_tab col
       WHERE ((supply_code_check_ = 1 AND col.supply_code = supply_code_db_) OR (supply_code_check_ = 0 AND col.supply_code != supply_code_db_))
         AND (col.order_no, col.line_no, col.rel_no, col.line_item_no ) IN (SELECT coi.order_no, coi.line_no, coi.release_no, coi.line_item_no
                                                                                 FROM customer_order_inv_item_all coi
                                                                                WHERE coi.invoice_id = invoice_id_ 
                                                                                  AND coi.company = company_);
         
BEGIN
   OPEN get_co_line_count(1);
   FETCH get_co_line_count INTO supply_count_;
   CLOSE get_co_line_count;
   
   IF (check_other_count_ = 'TRUE')THEN
      OPEN get_co_line_count(0);
      FETCH get_co_line_count INTO other_count_;
      CLOSE get_co_line_count;
   END IF;
END Get_Line_Counts_Per_Supply__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Credited_Amt_Per_Order
--   Returns the total credited amount per debit invoice order.
@UncheckedAccess
FUNCTION Get_Credited_Amt_Per_Order (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   credited_amount_ NUMBER;
   invoice_type_    VARCHAR2(20);

   CURSOR get_credited_amt IS
      SELECT SUM(gross_curr_amount)
        FROM customer_order_inv_item
       WHERE order_no = order_no_
         AND invoice_type IN ('CUSTORDCRE','CUSTCOLCRE', 'SELFBILLCRE', invoice_type_);
BEGIN
   invoice_type_ := Company_Def_Invoice_Type_API.Get_Def_Adv_Co_Cr_Inv_Type(Site_API.Get_Company(customer_Order_API.Get_Contract(order_no_)));
   OPEN get_credited_amt;
   FETCH get_credited_amt INTO credited_amount_;
   CLOSE get_credited_amt;

   RETURN ABS(NVL(credited_amount_,0));

END Get_Credited_Amt_Per_Order;



-- Get_Credited_Amt_Per_Ord_Line
--   Returns the total credited amount for a particular order line.
@UncheckedAccess
FUNCTION Get_Credited_Amt_Per_Ord_Line (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN NUMBER
IS
   credited_amount_ NUMBER;
   
   CURSOR get_credited_amt IS
      SELECT SUM(gross_curr_amount)
      FROM   CUSTOMER_ORDER_INV_ITEM
      WHERE  order_no     = order_no_
      AND    line_no      = line_no_
      AND    release_no   = rel_no_
      AND    line_item_no = line_item_no_
      AND    invoice_type IN ('CUSTORDCRE','CUSTCOLCRE', 'SELFBILLCRE');
BEGIN
   OPEN get_credited_amt;
   FETCH get_credited_amt INTO credited_amount_;
   CLOSE get_credited_amt;

   RETURN ABS(NVL(credited_amount_,0));
END Get_Credited_Amt_Per_Ord_Line;


-- Get_Cust_Ord_Location_Code
--   Returns a string concatinating the country code and the state code. The
--   country code and the state code are fetched from Customer Order Line
--   Address, Customer Order Address or from Customer Address depending on
--   the values of line_no_, order_no_ , rma_no_ and sequence_no_
@UncheckedAccess
FUNCTION Get_Cust_Ord_Location_Code (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   rma_no_       IN NUMBER,
   sequence_no_  IN NUMBER ) RETURN VARCHAR2
IS
   location_code_      VARCHAR2(20);
   co_line_no_         VARCHAR2(4);
   co_rel_no_          VARCHAR2(4);
   co_line_item_no_    NUMBER;
   country_code_       VARCHAR2(2);
   state_code_         VARCHAR2(35);
   state_presentation_ VARCHAR2(20);

   CURSOR get_address_in_order_line IS
      SELECT country_code,state
        FROM cust_order_line_address_2
       WHERE order_no     = order_no_
         AND line_no      = co_line_no_
         AND rel_no       = co_rel_no_
         AND line_item_no = co_line_item_no_;

   CURSOR get_address_in_order_header IS
      SELECT country_code,state
        FROM customer_order_address_2
       WHERE order_no = order_no_;

   CURSOR get_addr_in_rma_cust IS
      SELECT country,state
        FROM customer_info_address_tab
       WHERE (customer_id, address_id) IN (
             SELECT customer_no, ship_addr_no
               FROM return_material_tab
              WHERE rma_no = rma_no_);

    CURSOR get_ord_line_connection IS
      SELECT line_no, rel_no, line_item_no
        FROM customer_order_charge_tab
       WHERE order_no    = order_no_
         AND sequence_no = sequence_no_;

BEGIN
   IF (sequence_no_ IS NOT NULL) THEN
      OPEN  get_ord_line_connection;
      FETCH get_ord_line_connection INTO co_line_no_,co_rel_no_,co_line_item_no_;
      CLOSE get_ord_line_connection;
   END IF;

   co_line_no_      := NVL(co_line_no_, line_no_);
   co_rel_no_       := NVL(co_rel_no_, rel_no_);
   co_line_item_no_ := NVL(co_line_item_no_, line_item_no_);

   IF (co_line_no_ IS NOT NULL ) THEN
      OPEN  get_address_in_order_line;
      FETCH get_address_in_order_line INTO country_code_,state_code_;
      CLOSE get_address_in_order_line;
   ELSIF (order_no_ IS NOT NULL ) THEN
      OPEN  get_address_in_order_header;
      FETCH get_address_in_order_header INTO country_code_,state_code_;
      CLOSE get_address_in_order_header;
   ELSE
      OPEN  get_addr_in_rma_cust;
      FETCH get_addr_in_rma_cust INTO country_code_,state_code_;
      CLOSE get_addr_in_rma_cust;
   END IF;

   state_presentation_  := Presentation_Type_API.Encode(
                              Enterp_Address_Country_API.Get_State_Presentation ( country_code_));

   IF (state_presentation_ = 'NAMES') THEN
      state_code_ := State_Codes_API.Get_State_Code(country_code_, state_code_);
   END IF;

   location_code_ := Concatenated_State_Info_API.Display_State(country_code_, state_code_);

   RETURN location_code_;
END Get_Cust_Ord_Location_Code;



-- Create_Sbi_Invoice_Item
--   Creates the Self billing invoice item by calling Create_Invoice_Item___
--   Creates the Self billing invoice item by calling Create_Invoice_Item__
PROCEDURE Create_Sbi_Invoice_Item (
   item_id_         IN OUT VARCHAR2,
   invoice_id_      IN     NUMBER,
   order_no_        IN     VARCHAR2,
   line_no_         IN     VARCHAR2,
   rel_no_          IN     VARCHAR2,
   line_item_no_    IN     NUMBER,
   qty_invoiced_    IN     NUMBER,
   cust_part_price_ IN     NUMBER,
   customer_po_no_  IN     VARCHAR2,
   stage_           IN     NUMBER,
   copy_discount_   IN     BOOLEAN DEFAULT TRUE )
IS
   line_rec_                      Customer_Order_Line_API.Public_Rec;
   revised_qty_due_pkg_           NUMBER;

   CURSOR get_package_lines IS
      SELECT line_item_no, revised_qty_due, conv_factor, qty_invoiced, inverted_conv_factor
      FROM   customer_order_line_tab
      WHERE  order_no     = order_no_
      AND    line_no      = line_no_
      AND    rel_no       = rel_no_
      AND    line_item_no > 0
      AND    rowstate NOT IN ('Cancelled');
BEGIN
   line_rec_ := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);
   Create_Invoice_Item__(item_id_        => item_id_,
                         invoice_id_     => invoice_id_,
                         order_no_       => order_no_,
                         line_no_        => line_no_,
                         rel_no_         => rel_no_,
                         line_item_no_   => line_item_no_,
                         qty_invoiced_   => qty_invoiced_,
                         customer_po_no_ => customer_po_no_,
                         stage_          => stage_,
                         cust_part_price_=> cust_part_price_,
                         copy_discount_  => copy_discount_);

   IF (line_item_no_ = -1) AND (qty_invoiced_ != 0 ) THEN
      -- Note : When invoicing a package, update qty_invoiced in Customer_Order_Delivery for components also.
      revised_qty_due_pkg_ := line_rec_.revised_qty_due ;
      FOR itemrec_ IN get_package_lines LOOP
         Customer_Order_API.Set_Line_Qty_Invoiced(order_no_,
                                                  line_no_,
                                                  rel_no_,
                                                  itemrec_.line_item_no,
                                                  itemrec_.qty_invoiced  + qty_invoiced_ * (itemrec_.revised_qty_due / revised_qty_due_pkg_) / itemrec_.conv_factor * itemrec_.inverted_conv_factor);
      END LOOP;
      -- Note : try to advance package line head if possible
      Customer_Order_Line_API.Check_State(order_no_, line_no_, rel_no_, -1);
   END IF;
END Create_Sbi_Invoice_Item;


-- Create_Invoice_Charge_Line
--   Create invoice_charge_line in INVOICE module.
PROCEDURE Create_Invoice_Charge_Line (
   order_no_                     IN VARCHAR2,
   line_no_                      IN VARCHAR2,
   rel_no_                       IN VARCHAR2,
   line_item_no_                 IN NUMBER,
   invoice_id_                   IN NUMBER,
   customer_po_no_               IN VARCHAR2,
   charge_seq_no_                IN NUMBER,
   charged_qty_                  IN NUMBER,
   planned_revenue_simulation_   IN BOOLEAN DEFAULT FALSE )
IS
   item_id_       NUMBER;
BEGIN

   Create_Invoice_Charge_Line___(item_id_,
                                 order_no_,
                                 line_no_,
                                 rel_no_,
                                 line_item_no_,
                                 invoice_id_,
                                 customer_po_no_,
                                 charge_seq_no_,
                                 charged_qty_,
                                 planned_revenue_simulation_);
END Create_Invoice_Charge_Line;


-- Is_Create_Credit_Invoice_Ok
--   Returns 'TRUE' if it's ok to generate Credit Invoice. Otherwise returns 'FALSE'.
FUNCTION Is_Create_Credit_Invoice_Ok (
   customer_no_   IN VARCHAR2,
   contract_      IN VARCHAR2 ) RETURN VARCHAR2
IS
   customer_rec_       Cust_Ord_Customer_API.Public_Rec;
   company_            VARCHAR2(20);
   result_             VARCHAR2(15) := 'FALSE';
BEGIN

   customer_rec_   := Cust_Ord_Customer_API.Get(customer_no_);
   company_        := Site_API.Get_Company(contract_);

   IF ((customer_rec_.category = 'E') OR -- external customer
       ((customer_rec_.category = 'I') AND -- internal customer and connected to a site associated with another company.
        (Site_API.Get_Company(customer_rec_.acquisition_site) != company_))) THEN
      -- Note : it's ok to generate credit invoice
      result_ := 'TRUE';
      -- Note : if it's a pure internal order; it's not ok to generate a credit invoice.
   END IF;

   RETURN result_;
END Is_Create_Credit_Invoice_Ok;


-- Create_Credit_Invoices
--   Loops through an attribute string, unpacks all invoice ids and creates
--   credit/correction invoice for each invoice id.
PROCEDURE Create_Credit_Invoices (
   attr_                   IN VARCHAR2,
   use_ref_inv_curr_rate_  IN NUMBER,
   invoice_category_       IN VARCHAR2,
   allow_credit_inv_fee_   IN VARCHAR2 DEFAULT 'FALSE' )
IS
   ptr_            NUMBER;
   name_           VARCHAR2(30);
   value_          VARCHAR2(2000);
   deb_invoice_id_ VARCHAR2(200);
   description_    VARCHAR2(200);
   attr_new_       VARCHAR2(2000);
   invoice_no_     VARCHAR2(52);
   exclude_service_items_     VARCHAR2(5) := NULL;
BEGIN
   ptr_ := NULL;
   exclude_service_items_ := NVL(Client_SYS.Get_Item_Value ('EXCLUDE_SERVICE_ITEMS', attr_), 'FALSE');
   
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'INVOICEID') THEN
         deb_invoice_id_ := value_;
         Client_SYS.Clear_Attr(attr_new_);
         Client_SYS.Add_To_Attr('REF_INVOICE_ID', deb_invoice_id_, attr_new_);
         Client_SYS.Add_To_Attr('USE_REF_INV_CURR_RATE', use_ref_inv_curr_rate_, attr_new_);
         Client_SYS.Add_To_Attr('INVOICE_CATEGORY', invoice_category_, attr_new_);
         Client_SYS.Add_To_Attr('ALLOW_CREDIT_INV_FEE', allow_credit_inv_fee_, attr_new_);
         Client_SYS.Add_To_Attr('EXCLUDE_SERVICE_ITEMS', exclude_service_items_, attr_new_);
         description_ := Language_SYS.Translate_Constant(lu_name_, 'CRE_CREDINV: Create Customer Credit/Correction Invoice');
         invoice_no_  := Customer_Order_Inv_Head_API.Get_Series_Id_By_Id(deb_invoice_id_) || Customer_Order_Inv_Head_API.Get_Invoice_No_By_Id(deb_invoice_id_);
         Check_No_Previous_Execution___(deb_invoice_id_, invoice_no_, 'INVOICE_CUSTOMER_ORDER_API.Create_Credit_Invoice__');
         Transaction_SYS.Deferred_Call('INVOICE_CUSTOMER_ORDER_API.Create_Credit_Invoice__', attr_new_, description_);
      END IF;
   END LOOP;
END Create_Credit_Invoices;


-- Create_Corr_Inv_From_Return
--   Use to create correction invoice from RMA
PROCEDURE Create_Corr_Inv_From_Return (
   rma_no_ IN  NUMBER )
IS
   CURSOR distinct_rma_line IS
      SELECT DISTINCT(debit_invoice_no), debit_invoice_series_id, company
        FROM return_material_line_tab
       WHERE rma_no = rma_no_
         AND debit_invoice_no IS NOT NULL
         AND credit_approver_id IS NOT NULL
         AND credit_invoice_no IS NULL
         AND rowstate NOT IN ('Denied', 'Planned');

   attr_           VARCHAR2(32000);
   description_    VARCHAR2(2000);
   deb_invoice_id_ NUMBER;
   external_tax_calc_method_     VARCHAR2(50);
   company_                      VARCHAR2(20);
BEGIN
   company_ := Site_API.Get_Company(Return_Material_API.Get_Contract(rma_no_));
   external_tax_calc_method_ := Company_Tax_Control_API.Get_External_Tax_Cal_Method_Db(company_);   
   IF (external_tax_calc_method_ != External_Tax_Calc_Method_API.DB_NOT_USED) THEN
      Error_SYS.Record_General(lu_name_, 'CORRINVNOTALLOWED: Correction Invoice from RMA is not allowed when External Tax Calculation Method is set to :P1 for company :P2.', External_Tax_Calc_Method_API.Decode(external_tax_calc_method_), company_);
   END IF;
   
   FOR rma_line_ IN distinct_rma_line LOOP
      --Validate_Corr_Invoice_Creation
      deb_invoice_id_ := Customer_Order_Inv_Head_API.Get_Invoice_Id_By_No (rma_line_.company, rma_line_.debit_invoice_no, rma_line_.debit_invoice_series_id);
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('REF_INVOICE_ID', deb_invoice_id_, attr_);
      Client_SYS.Add_To_Attr('USE_REF_INV_CURR_RATE', 1, attr_);
      Client_SYS.Add_To_Attr('INVOICE_CATEGORY', 'CORRECTION', attr_);
      Client_SYS.Add_To_Attr('RMA_NO', rma_no_, attr_);
      description_ := Language_SYS.Translate_Constant(lu_name_, 'CRE_CORR_INVOICE: Create Customer Correction Invoice from RMA');
      Transaction_SYS.Deferred_Call('INVOICE_CUSTOMER_ORDER_API.Create_Credit_Invoice__', attr_, description_);
   END LOOP;
END Create_Corr_Inv_From_Return;


-- Get_Prev_Ref_Invoices
--   Returns previous reference invoice(s) for a given credit/correction invoice
@UncheckedAccess
FUNCTION Get_Prev_Ref_Invoices (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER ) RETURN VARCHAR2
IS
   attr_ VARCHAR2(32000);

   CURSOR get_prev_ref_inv IS
      SELECT DISTINCT number_reference, series_reference
        FROM customer_order_inv_item
       WHERE invoice_id = invoice_id_
         AND company = company_
         AND number_reference IS NOT NULL;

BEGIN
   Client_SYS.Clear_Attr(attr_);
   FOR inv_rec_ IN get_prev_ref_inv LOOP
      Client_SYS.Add_To_Attr('INVOICE_ID', Customer_Order_Inv_Head_API.Get_Invoice_Id_By_No(company_, inv_rec_.number_reference, inv_rec_.series_reference), attr_);
   END LOOP;
   RETURN attr_;
END Get_Prev_Ref_Invoices;



-- Get_Credit_Invoices
--   Returns the credit invoice(s) for a given debit invoice
@UncheckedAccess
FUNCTION Get_Credit_Invoices (
   company_    IN VARCHAR2,
   invoice_no_ IN VARCHAR2,
   series_id_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   attr_                VARCHAR2(32000);
   invoice_type_        VARCHAR2(20);
   prepay_invoice_type_ VARCHAR2(20);
   -- gelr:prepayment_tax_document, begin
   tax_doc_cr_inv_type_ VARCHAR2(20);
   -- gelr:prepayment_tax_document, end

   -- gelr:prepayment_tax_document, added tax_doc_cr_inv_type_
   CURSOR get_debit_inv IS
      SELECT DISTINCT h.invoice_id
        FROM customer_order_inv_item i,  customer_order_inv_head h
       WHERE i.invoice_id = h.invoice_id
         AND i.company = h.company
         AND i.number_reference = invoice_no_
         AND i.series_reference = series_id_
         AND h.company = company_
         AND h.invoice_type IN ('CUSTORDCRE','CUSTCOLCRE','SELFBILLCRE', invoice_type_, prepay_invoice_type_, tax_doc_cr_inv_type_);

BEGIN
   invoice_type_    := Company_Def_Invoice_Type_API.Get_Def_Adv_Co_Cr_Inv_Type(company_);
   prepay_invoice_type_ := Company_Def_Invoice_Type_API.Get_Def_Co_Prepay_Cre_Inv_Type (company_);
   -- gelr:prepayment_tax_document, begin
   tax_doc_cr_inv_type_ := Company_Def_Invoice_Type_API.Get_Def_Co_Cre_Tax_Doc_Type(company_);
   -- gelr:prepayment_tax_document, end
   Client_SYS.Clear_Attr(attr_);
   FOR inv_rec_ IN get_debit_inv LOOP
      Client_SYS.Add_To_Attr('INVOICE_ID', inv_rec_.invoice_id , attr_);
   END LOOP;
   RETURN attr_;
END Get_Credit_Invoices;



-- Get_Debit_Invoices
--   Returns the debit invoice(s) for a given credit/correction invoice
@UncheckedAccess
FUNCTION Get_Debit_Invoices (
   company_    IN VARCHAR2,
   invoice_no_ IN VARCHAR2,
   series_id_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   attr_         VARCHAR2(32000);
   invoice_id_   NUMBER;
   invoice_type_ VARCHAR2(20);
   adv_inv_type_ VARCHAR2(20);
   num_ref_      VARCHAR2(50);
   series_ref_   VARCHAR2(20);

   CURSOR get_deb_inv1 IS
      SELECT DISTINCT ii.number_reference, ii.series_reference
        FROM customer_order_inv_item ii, customer_order_inv_head ih
       WHERE ii.invoice_id = ih.invoice_id
         AND ii.company = ih.company
         AND ih.invoice_no = invoice_no_
         AND ii.company = company_
         AND ih.series_id = series_id_
         AND ii.number_reference IS NOT NULL;

   CURSOR get_deb_inv2 IS
      SELECT number_reference, series_reference
        FROM customer_order_inv_head
       WHERE invoice_no = num_ref_
         AND company = company_
         AND series_id = series_ref_;
BEGIN
   adv_inv_type_    := Company_Def_Invoice_Type_API.Get_Def_Adv_Co_Dr_Inv_Type(company_);
   Client_SYS.Clear_Attr(attr_);
   FOR inv_rec_ IN get_deb_inv1 LOOP
      num_ref_      := inv_rec_.number_reference;
      series_ref_   := inv_rec_.series_reference;
      invoice_id_   := Customer_Order_Inv_Head_API.Get_Invoice_Id_By_No(company_, num_ref_, series_ref_);
      invoice_type_ := Customer_Order_Inv_Head_API.Get_Invoice_Type(company_, invoice_id_);
      WHILE (invoice_type_ NOT IN ('CUSTORDDEB','CUSTCOLDEB', 'SELFBILLDEB', adv_inv_type_)) LOOP
         OPEN  get_deb_inv2;
         FETCH get_deb_inv2 INTO num_ref_, series_ref_;
         CLOSE get_deb_inv2;
         invoice_id_   := Customer_Order_Inv_Head_API.Get_Invoice_Id_By_No(company_, num_ref_, series_ref_);
         invoice_type_ := Customer_Order_Inv_Head_API.Get_Invoice_Type(company_, invoice_id_);
      END LOOP;
      Client_SYS.Add_To_Attr('INVOICE_ID', invoice_id_ , attr_);
   END LOOP;
   RETURN attr_;
END Get_Debit_Invoices;



-- Check_Cre_Invoice_Exist
--   Checks whether a credit/correction invoice exists for a given order line
@UncheckedAccess
FUNCTION Check_Cre_Invoice_Exist (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN VARCHAR2
IS
   exist_          NUMBER;
   company_        VARCHAR2(20);
   cor_inv_type_   VARCHAR2(20);
   col_inv_type_   VARCHAR2(20);

   CURSOR Check_Cre_Invoice_Exist IS
      SELECT 1
      FROM   customer_order_inv_item
      WHERE  invoice_type IN (cor_inv_type_, col_inv_type_, 'CUSTORDCRE','CUSTCOLCRE', 'SELFBILLCRE')
      AND    order_no = order_no_
      AND    line_no = line_no_
      AND    release_no = rel_no_
      AND    line_item_no = line_item_no_;

BEGIN
   company_ := Site_API.Get_Company(Customer_Order_API.Get_Contract(order_no_));
   cor_inv_type_ := Company_Def_Invoice_Type_API.Get_Def_Co_Cor_Inv_Type(company_);
   col_inv_type_ := Company_Def_Invoice_Type_API.Get_Def_Col_Cor_Inv_Type(company_);

   OPEN Check_Cre_Invoice_Exist;
   FETCH Check_Cre_Invoice_Exist INTO exist_;
   IF (Check_Cre_Invoice_Exist%FOUND) THEN
      CLOSE Check_Cre_Invoice_Exist;
      RETURN 'TRUE';
   END IF;
   CLOSE Check_Cre_Invoice_Exist;
   RETURN 'FALSE';
END Check_Cre_Invoice_Exist;



-- Check_Req_Prepayments_Unpaid
--   This method will return TRUE if all the payments connected to the
--   order are greater than or equal to the proposed prepayments.
@UncheckedAccess
FUNCTION Check_Req_Prepayments_Unpaid (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   connected_payments_  NUMBER;
   prepayment_amount_   NUMBER;
   all_paid_            VARCHAR2(5) := 'FALSE';
   company_             VARCHAR2(80);   
   order_rec_           Customer_Order_API.Public_Rec;
BEGIN
   order_rec_ := Customer_Order_API.Get(order_no_);
   company_   := Site_API.Get_Company(order_rec_.contract);
   
   $IF Component_Payled_SYS.INSTALLED $THEN 
      connected_payments_ := On_Account_Ledger_Item_API.Get_Payment_Amt_For_Order_Ref(company_, NVL(order_rec_.customer_no_pay, order_rec_.customer_no), order_no_);
   $ELSE
      connected_payments_ := 0;
   $END

   prepayment_amount_  := Customer_Order_API.Get_Proposed_Prepayment_Amount(order_no_);
   IF (connected_payments_ >= prepayment_amount_) THEN
      all_paid_ := 'TRUE';
   END IF;
   RETURN all_paid_;
END Check_Req_Prepayments_Unpaid;



-- Check_Invoice_Exist_For_Co
--   This method will return TRUE if a customer order is connected to a
--   invoice. Else it will return FALSE.
@UncheckedAccess
FUNCTION Check_Invoice_Exist_For_Co (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   exist_ NUMBER;

   CURSOR Check_Invoice_Exist IS
      SELECT 1
      FROM   customer_order_inv_item_all
      WHERE  order_no = order_no_;
BEGIN
   OPEN Check_Invoice_Exist;
   FETCH Check_Invoice_Exist INTO exist_;
   IF (Check_Invoice_Exist%FOUND) THEN
      CLOSE Check_Invoice_Exist;
      RETURN 'TRUE';
   END IF;
   CLOSE Check_Invoice_Exist;
   RETURN 'FALSE';
END Check_Invoice_Exist_For_Co;



PROCEDURE Remove_Invoice (
   company_    IN VARCHAR2,
   party_type_ IN VARCHAR2,
   identity_   IN VARCHAR2,
   series_id_  IN VARCHAR2,
   invoice_no_ IN VARCHAR2 )
IS
   cncl_attr_              VARCHAR2(2000);
   creator_                INVOICE_TAB.CREATOR%TYPE;
   invoice_type_           CUSTOMER_ORDER_INV_HEAD.invoice_type%TYPE;
   ref_invoice_id_         CUSTOMER_ORDER_INV_HEAD.invoice_id%TYPE;
   number_ref_             CUSTOMER_ORDER_INV_HEAD.number_reference%TYPE;
   series_ref_             CUSTOMER_ORDER_INV_HEAD.series_reference%TYPE;
   invoice_id_             NUMBER;
   rma_no_                 NUMBER;
   order_no_               VARCHAR2(12);
   cor_inv_type_           VARCHAR2(20);
   col_inv_type_           VARCHAR2(20);
   pre_deb_inv_            VARCHAR2(20);
   pre_cre_inv_            VARCHAR2(20);
   order_no_arr_           Order_No_Array;
   ledger_item_series_id_  CUSTOMER_ORDER_INV_HEAD.ledger_item_series_id%TYPE;
   ledger_item_id_         CUSTOMER_ORDER_INV_HEAD.ledger_item_id%TYPE;
   ledger_item_version_id_ CUSTOMER_ORDER_INV_HEAD.ledger_item_version_id%TYPE;
   invoice_id_ref_         CUSTOMER_ORDER_INV_HEAD.invoice_id%TYPE := NULL;
   customer_no_pay_        CUSTOMER_ORDER_INV_HEAD.identity%TYPE;
   aggregation_no_         CUSTOMER_ORDER_INV_HEAD.aggregation_no%TYPE;
   final_settlement_       CUSTOMER_ORDER_INV_HEAD.final_settlement%TYPE;
   head_key_ref_           VARCHAR2(600);
   line_key_ref_           VARCHAR2(600);
   head_lu_                VARCHAR2(30):='CustomerOrderInvHead';
   line_lu_                VARCHAR2(30):='CustomerOrderInvItem';

   -- Get credit invoice details
   CURSOR get_invoice_data IS
     SELECT invoice_type, number_reference, series_reference, invoice_id, rma_no,
            ledger_item_series_id, ledger_item_id, ledger_item_version_id, creators_reference, aggregation_no, final_settlement
       FROM CUSTOMER_ORDER_INV_HEAD
      WHERE invoice_no = invoice_no_
        AND series_id = series_id_
        AND company = company_;
   
   CURSOR get_invoice_items IS
      SELECT item_id
        FROM CUSTOMER_ORDER_INV_ITEM
       WHERE invoice_id = invoice_id_
         AND company = company_;

   CURSOR get_invoice_rmalines IS
      SELECT DISTINCT rma_no, rma_line_no
        FROM CUSTOMER_ORDER_INV_ITEM
       WHERE invoice_id = invoice_id_
         AND company = company_
         AND rma_line_no IS NOT NULL;

   CURSOR get_invoice_rmacharges IS
      SELECT DISTINCT rma_no, rma_charge_no
        FROM CUSTOMER_ORDER_INV_ITEM
       WHERE invoice_id = invoice_id_
         AND company = company_
         AND rma_charge_no IS NOT NULL;

BEGIN
   OPEN get_invoice_data;
   FETCH get_invoice_data INTO invoice_type_, number_ref_, series_ref_, invoice_id_, rma_no_, ledger_item_series_id_, ledger_item_id_, ledger_item_version_id_, order_no_, aggregation_no_, final_settlement_;
   CLOSE  get_invoice_data;

   Client_SYS.Clear_Attr(cncl_attr_);
   Client_SYS.Add_To_Attr('COMPANY', company_, cncl_attr_);
   Client_SYS.Add_To_Attr('PARTY_TYPE', party_type_, cncl_attr_);
   Client_SYS.Add_To_Attr('IDENTITY', identity_, cncl_attr_);
   Client_SYS.Add_To_Attr('SERIES_ID', series_id_, cncl_attr_);
   Client_SYS.Add_To_Attr('INVOICE_NO', invoice_no_, cncl_attr_);
   creator_ := 'CUSTOMER_ORDER_INV_HEAD_API';

   -- Before cancel the crdit/correction invoice, clear the CR details from RMA lines/charges
   IF (rma_no_ IS NOT NULL) THEN
      FOR invoice_rmalines_rec_ IN get_invoice_rmalines LOOP
         Return_Material_Line_API.Modify_Cr_Invoice_Fields(invoice_rmalines_rec_.rma_no, invoice_rmalines_rec_.rma_line_no, TO_NUMBER(NULL), TO_NUMBER(NULL));
      END LOOP;
      FOR invoice_rmacharges_rec_ IN get_invoice_rmacharges LOOP
         Return_Material_Charge_API.Modify_Cr_Invoice_Fields(invoice_rmacharges_rec_.rma_no, invoice_rmacharges_rec_.rma_charge_no, TO_NUMBER(NULL), TO_NUMBER(NULL));
      END LOOP;
   END IF;
   
   cor_inv_type_ := Company_Def_Invoice_Type_API.Get_Def_Co_Cor_Inv_Type(company_);
   col_inv_type_ := Company_Def_Invoice_Type_API.Get_Def_Col_Cor_Inv_Type(company_);
   pre_deb_inv_  := Company_Def_Invoice_Type_API.Get_Def_Co_Prepay_Deb_Inv_Type(company_);
   pre_cre_inv_  := Company_Def_Invoice_Type_API.Get_Def_Co_Prepay_Cre_Inv_Type(company_);
   
   Get_Connected_Orders___ (order_no_arr_,
                            company_,
                            invoice_id_);                               

   Remove_Invoice_Associations___(company_,
                                  invoice_id_,
                                  TRUE,
                                  invoice_type_,
                                  pre_cre_inv_);
                                  
   $IF (Component_Docman_SYS.INSTALLED) $THEN
 
      -- Remove Approval Routings attached to Invoice Header
      head_key_ref_:='COMPANY='||company_||'^'||'INVOICE_ID='||invoice_no_|| '^';        
      IF (Approval_Routing_API.Exist_Routing(head_lu_, head_key_ref_) = 'TRUE') THEN     
         Approval_Routing_API.Remove_Approval_Routing(head_lu_, head_key_ref_);
      END IF;
   
      -- Remove Approval Routings attached to Invoice Lines     
      FOR invoice_items_rec_ IN get_invoice_items LOOP
         line_key_ref_:='COMPANY='||company_||'^'||'INVOICE_ID='||invoice_no_||'^'||'ITEM_ID='||invoice_items_rec_.item_id||'^';         
         IF (Approval_Routing_API.Exist_Routing(line_lu_, line_key_ref_) = 'TRUE') THEN
            Approval_Routing_API.Remove_Approval_Routing(line_lu_, line_key_ref_);
         END IF;     
      END LOOP;                 
  
      -- Remove Documents attached to Invoice Header
      head_key_ref_:='COMPANY='||company_||'^'||'INVOICE_ID='||invoice_no_||'^';     
      IF (Doc_Reference_Object_API.Exist_Obj_Reference(head_lu_, head_key_ref_) = 'TRUE') THEN
         Doc_Reference_Object_API.Unlock_Survey(head_lu_, head_key_ref_);
         Doc_Reference_Object_API.Remove_Refs_From_Obj(head_lu_, head_key_ref_ );
      END IF;
              
      -- Remove Documents attached to Invoice Lines
      FOR invoice_items_rec_ IN get_invoice_items LOOP
         line_key_ref_:='COMPANY='||company_||'^'||'INVOICE_ID='||invoice_no_||'^'||'ITEM_ID='||invoice_items_rec_.item_id||'^';                
         IF (Doc_Reference_Object_API.Exist_Obj_Reference(line_lu_, line_key_ref_) = 'TRUE') THEN
            Doc_Reference_Object_API.Unlock_Survey(line_lu_, line_key_ref_);
            Doc_Reference_Object_API.Remove_Refs_From_Obj( line_lu_, line_key_ref_ );
         END IF;   
      END LOOP;
   
   $END
   
   -- Remove Technical Class attached to Invoice Header
   head_key_ref_:='COMPANY='||company_||'^'||'INVOICE_ID='||invoice_no_||'^';
   Technical_Object_Reference_API.Delete_Reference(head_lu_, head_key_ref_);
   
   -- Remove Technical Class attached to Invoice Lines
   FOR invoice_items_rec_ IN get_invoice_items LOOP
      line_key_ref_:='COMPANY='||company_||'^'||'INVOICE_ID='||invoice_no_||'^'||'ITEM_ID='||invoice_items_rec_.item_id||'^';
      Technical_Object_Reference_API.Delete_Reference(line_lu_, line_key_ref_);
   END LOOP;   
                                  
   -- Removal of credit invoice head and items
   Out_Invoice_Util_Pub_API.Cancel_Prelim_Invoice(cncl_attr_, creator_);

   -- Set the correction invoice id to null in the reference invoice after removing the correction invoice
   IF (invoice_type_ IN (cor_inv_type_, col_inv_type_)) THEN
      ref_invoice_id_ := Customer_Order_Inv_Head_API.Get_Invoice_Id_By_No(company_, number_ref_, series_ref_);
      Customer_Invoice_Pub_Util_API.Set_Correction_Invoice_Id(company_, ref_invoice_id_, NULL);
   END IF;

   -- Remove the invoice_id_ref for PBI invoices from Ledger Item
   IF (invoice_type_ = pre_deb_inv_) THEN
      customer_no_pay_ := Customer_Order_API.Get_Customer_No_Pay(order_no_);
      
      $IF Component_Payled_SYS.INSTALLED $THEN
         On_Account_Ledger_Item_API.Update_Invoice_Id_Ref( invoice_id_ref_, company_, NVL(customer_no_pay_, identity_), party_type_, ledger_item_series_id_, ledger_item_id_, ledger_item_version_id_ );
      $END     
   END IF;

   Create_Order_History___(company_,
                           invoice_id_,
                           false,
                           order_no_arr_,
                           invoice_no_,
                           invoice_type_,
                           cor_inv_type_,
                           pre_deb_inv_,
                           pre_cre_inv_,
                           col_inv_type_);   

   -- If a rebate Preliminary gets removed remove the invoice id of the related settlemet record.
   IF (aggregation_no_ IS NOT NULL) THEN
      IF (final_settlement_ = 'TRUE') THEN
         Rebate_Final_Agg_Head_API.Set_Invoice_Id(aggregation_no_, NULL);
      ELSE
         Rebate_Periodic_Agg_Head_API.Set_Invoice_Id(aggregation_no_, NULL);
      END IF;
   END IF;
END Remove_Invoice;

   
-- Get_Invoice_For_Rma
--   The OUT parameters invoice_no_, item_id_ and series_id_ will have values if there is
--   only one invoice for the given Customer Order Line. Otherwise those values will be NULL.
--   The OUT parameter inv_count_ will indicate the number of invoices connected to the Customer
--   Order Line. If there are no invoices inv_count_ = 0, if there is only one invoice inv_count_ = 1
--   and if there are more than one invoice inv_count_ = 2.
PROCEDURE Get_Invoice_For_Rma (
   inv_count_    OUT NUMBER,
   invoice_no_   OUT VARCHAR2,
   item_id_      OUT NUMBER,
   series_id_    OUT VARCHAR2,
   order_no_     IN  VARCHAR2,
   line_no_      IN  VARCHAR2,
   rel_no_       IN  VARCHAR2,
   line_item_no_ IN  NUMBER )
IS 
   order_line_rec_              Customer_Order_Line_API.Public_Rec;

   CURSOR get_invoice_data IS
      SELECT ih.invoice_no, ii.item_id, ih.series_id
      FROM   customer_order_inv_item ii, customer_order_inv_head ih
      WHERE  ii.invoice_id = ih.invoice_id
      AND    ii.company = ih.company
      AND    ii.charge_seq_no IS NULL
      AND    ii.net_curr_amount >= 0
      AND    ii.prel_update_allowed = 'TRUE'
      AND    ih.correction_invoice_id IS NULL
      AND    ii.order_no = order_no_
      AND    ii.line_no = line_no_
      AND    ii.release_no = rel_no_
      AND    ii.line_item_no = line_item_no_;
BEGIN
   order_line_rec_ :=  Customer_Order_Line_API.Get( order_no_, line_no_, rel_no_, line_item_no_);
   inv_count_      := 0;

   IF (order_line_rec_.qty_shipped - order_line_rec_.qty_returned > 0 AND
       order_line_rec_.rental = Fnd_Boolean_API.DB_FALSE) THEN
      FOR rec_ IN get_invoice_data LOOP
         inv_count_ := inv_count_ + 1;
         IF inv_count_ > 1 THEN
            invoice_no_ := NULL;
            item_id_    := 0;
            series_id_  := NULL;
            EXIT;
         ELSE
            invoice_no_ := rec_.invoice_no;
            item_id_    := rec_.item_id;
            series_id_  := rec_.series_id;
         END IF;
       END LOOP;
   END IF;
END Get_Invoice_For_Rma;


@UncheckedAccess
FUNCTION Get_Invoice_Currency_Rounding (
   company_    IN VARCHAR2,
   invoice_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   CURSOR get_currency_info IS
      SELECT currency
        FROM CUSTOMER_ORDER_INV_HEAD t 
       WHERE company    = company_
         AND invoice_id = invoice_id_;
       
   currency_code_     VARCHAR2(12);    
   currency_rounding_ NUMBER := 0;
BEGIN
   OPEN get_currency_info;
   FETCH get_currency_info INTO currency_code_;
   CLOSE get_currency_info;
   
   currency_rounding_ := Currency_Code_Api.Get_Currency_Rounding( company_, currency_code_); 
   
   RETURN currency_rounding_;
END Get_Invoice_Currency_Rounding; 


-- Is_Report_Available
--   Checks whether the given result_key_ is in Distribution Reports Archive
--   and the session user has the system privileges.
FUNCTION Is_Report_Available (
   result_key_  IN NUMBER,
   user_        IN VARCHAR2 ) RETURN VARCHAR2
IS
   report_available_ VARCHAR2(5) := 'FALSE';
BEGIN
   
   IF (Archive_Distribution_API.Is_Distributed(result_key_)) THEN
      report_available_ := Security_SYS.Has_System_Privilege('ADMINISTRATOR');

      IF (report_available_ = 'FALSE') THEN
         report_available_ := Archive_Distribution_API.Is_Key_Available(result_key_ ,user_ );
      END IF;
   END IF;
   RETURN report_available_ ;
END Is_Report_Available;


-- Validate_Cust_Ivc_Params
--   Validates the parameters when running the Schedule for Batch Create
--   Customer Invoices.
PROCEDURE Validate_Cust_Ivc_Params (
   message_ IN VARCHAR2 )
IS
   count_          NUMBER;
   name_arr_       Message_SYS.name_table;
   value_arr_      Message_SYS.line_table;
   
   company_        VARCHAR2(20);
   contract_       VARCHAR2(5);
   order_id_       VARCHAR2(3);
   customer_no_    VARCHAR2(20);
   authorize_code_ VARCHAR2(20);
   salesman_code_  VARCHAR2(20);
   priority_       NUMBER;
   ivc_unconct_chg_seperatly_ NUMBER;
BEGIN

   Message_SYS.Get_Attributes(message_, count_, name_arr_, value_arr_);
   FOR n_ IN 1..count_ LOOP
      IF (name_arr_(n_) = 'COMPANY') THEN
         company_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'CONTRACT') THEN
         contract_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'ORDER_ID') THEN
         order_id_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'CUSTOMER_NO') THEN
         customer_no_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'AUTHORIZE_CODE') THEN
         authorize_code_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'SALESMAN_CODE') THEN
         salesman_code_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'PRIORITY') THEN
         priority_ := Client_SYS.Attr_Value_To_Number(value_arr_(n_));
      ELSIF (name_arr_(n_) = 'IVC_UNCONCT_CHG_SEPERATLY') THEN
         ivc_unconct_chg_seperatly_ :=  Client_SYS.Attr_Value_To_Number(value_arr_(n_));
      ELSE
         Error_SYS.Record_General(lu_name_, 'INCORRECT_MESSAGE: Item :P1 can not be used in this method.', name_arr_(n_));
      END IF;
   END LOOP;

   Company_API.Exist(company_);
   Company_Finance_API.Exist(company_);

   IF (contract_ != '%') THEN
      User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, contract_);
   END IF;

   IF (order_id_ != '%') THEN
      Cust_Order_Type_API.Exist(order_id_);
   END IF;

   IF (customer_no_ != '%') THEN
      Cust_Ord_Customer_API.Exist(customer_no_);
   END IF;

   IF (authorize_code_ != '%') THEN
      Order_Coordinator_API.Exist(authorize_code_, true);
   END IF;

   IF (salesman_code_ != '%') THEN
      Sales_Part_Salesman_API.Exist(salesman_code_, TRUE);
   END IF;

END Validate_Cust_Ivc_Params;


-- Validate_Coll_Ivc_Params
--   Validates the parameters when running the Schedule for Batch Create
--   Collective Invoices.
PROCEDURE Validate_Coll_Ivc_Params (
   message_ IN VARCHAR2 )
IS
   count_                        NUMBER;
   name_arr_                     Message_SYS.name_table;
   value_arr_                    Message_SYS.line_table;
                                 
   company_                      VARCHAR2(20);
   contract_                     VARCHAR2(5);
   customer_no_                  VARCHAR2(20);
   currency_code_                VARCHAR2(3);
   pay_term_id_                  VARCHAR2(20);
   planned_invoice_date_offset_  NUMBER;
   ivc_unconct_chg_seperatly_    NUMBER := 0;
BEGIN

   Message_SYS.Get_Attributes(message_, count_, name_arr_, value_arr_);
   FOR n_ IN 1..count_ LOOP
      IF (name_arr_(n_) = 'COMPANY') THEN
         company_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'CONTRACT') THEN
         contract_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'CUSTOMER_NO') THEN
         customer_no_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'CURRENCY_CODE') THEN
         currency_code_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'PAY_TERM_ID') THEN
         pay_term_id_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'PLANNED_INVOICE_DATE_OFFSET') THEN
         planned_invoice_date_offset_ := Client_SYS.Attr_Value_To_Number(value_arr_(n_));
      ELSIF (name_arr_(n_) = 'IVC_UNCONCT_CHG_SEPERATLY') THEN
         ivc_unconct_chg_seperatly_ :=  Client_SYS.Attr_Value_To_Number(value_arr_(n_));
      ELSE
         Error_SYS.Record_General(lu_name_, 'INCORRECT_MESSAGE: Item :P1 can not be used in this method.', name_arr_(n_));
      END IF;
   END LOOP;

   Company_API.Exist(company_);
   Company_Finance_API.Exist(company_);

   IF (contract_ != '%') THEN
      User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, contract_);
   END IF;

   IF (customer_no_ != '%') THEN
      Cust_Ord_Customer_API.Exist(customer_no_);
   END IF;

   IF (currency_code_ != '%') THEN
      Iso_Currency_API.Exist(currency_code_);
   END IF;

   IF (pay_term_id_ != '%') THEN
      Payment_Term_API.Exist(company_, pay_term_id_);
   END IF;

END Validate_Coll_Ivc_Params;


-- Validate_Ship_Ivc_Params
--   Validates the parameters when running the Schedule for Batch Create
--   Shipment Invoices.
PROCEDURE Validate_Ship_Ivc_Params (
   message_ IN VARCHAR2 )
IS
   count_          NUMBER;
   name_arr_       Message_SYS.name_table;
   value_arr_      Message_SYS.line_table;

   company_        VARCHAR2(20);
   contract_       VARCHAR2(5);
   customer_no_    VARCHAR2(20);
   currency_code_  VARCHAR2(3);
   pay_term_id_    VARCHAR2(20);
BEGIN

   Message_SYS.Get_Attributes(message_, count_, name_arr_, value_arr_);
   FOR n_ IN 1..count_ LOOP
      IF (name_arr_(n_) = 'COMPANY') THEN
         company_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'CONTRACT') THEN
         contract_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'CUSTOMER_NO') THEN
         customer_no_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'CURRENCY_CODE') THEN
         currency_code_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'PAY_TERM_ID') THEN
         pay_term_id_ := value_arr_(n_);
      ELSE
         Error_SYS.Record_General(lu_name_, 'INCORRECT_MESSAGE: Item :P1 can not be used in this method.', name_arr_(n_));
      END IF;
   END LOOP;

   Company_API.Exist(company_);
   Company_Finance_API.Exist(company_);

   IF (contract_ != '%') THEN
      User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, contract_);
   END IF;

   IF (customer_no_ != '%') THEN
      Cust_Ord_Customer_API.Exist(customer_no_);
   END IF;

   IF (currency_code_ != '%') THEN
      Iso_Currency_API.Exist(currency_code_);
   END IF;

   IF (pay_term_id_ != '%') THEN
      Payment_Term_API.Exist(company_, pay_term_id_);
   END IF;

END Validate_Ship_Ivc_Params;


-- Validate_Rebate_Ivc_Params
--   Validates the parameters when running the Schedule for Batch Create
--   Rebate Invoices.
PROCEDURE Validate_Rebate_Ivc_Params (
   message_ IN VARCHAR2 )
IS
   count_           NUMBER;
   name_arr_        Message_SYS.name_table;
   value_arr_       Message_SYS.line_table;
                    
   company_         VARCHAR2(20);
   customer_no_     VARCHAR2(20);
   agreement_id_    VARCHAR2(10);
   hierarchy_id_    VARCHAR2(10);
   customer_level_  NUMBER;
BEGIN

   Message_SYS.Get_Attributes(message_, count_, name_arr_, value_arr_);
   FOR n_ IN 1..count_ LOOP
      IF (name_arr_(n_) = 'COMPANY') THEN
         company_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'CUSTOMER_NO') THEN
         customer_no_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'AGREEMENT_ID') THEN
         agreement_id_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'HIERARCHY_ID') THEN
         hierarchy_id_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'CUSTOMER_LEVEL') THEN
         customer_level_ := Client_SYS.Attr_Value_To_Number(value_arr_(n_));
      ELSE
         Error_SYS.Record_General(lu_name_, 'INCORRECT_MESSAGE: Item :P1 can not be used in this method.', name_arr_(n_));
      END IF;
   END LOOP;

   Company_API.Exist(company_);
   Company_Finance_API.Exist(company_);

   IF (customer_no_ != '%') THEN
      Cust_Ord_Customer_API.Exist(customer_no_);
   END IF;

   IF (agreement_id_ != '%') THEN
      Rebate_Agreement_API.Exist(agreement_id_);
   END IF;

   IF (hierarchy_id_ != '%') THEN
      Customer_Hierarchy_API.Exist(hierarchy_id_);
   END IF;

   IF (hierarchy_id_ != '%') AND (customer_level_ IS NOT NULL) THEN
      Customer_Hierarchy_Level_API.Exist(hierarchy_id_, customer_level_);
   END IF;

END Validate_Rebate_Ivc_Params;


-- Validate_Vat_Codes
--   Validate tax codes according to the given invoice id and invoice date.
PROCEDURE Validate_Vat_Codes (
   company_            IN VARCHAR2,
   invoice_id_         IN NUMBER,
   invoice_date_       IN DATE)
IS
   source_ref_type_db_  CONSTANT VARCHAR2(100) := Tax_Source_API.DB_INVOICE;
   
   CURSOR check_items (inv_id_ IN VARCHAR2) IS
      SELECT tax_code
      FROM   source_tax_item_base_pub
      WHERE  company    = company_
      AND    source_ref1 = inv_id_
      AND    source_ref_type_db = source_ref_type_db_;
BEGIN
   FOR rec_ IN check_items (TO_CHAR(invoice_id_)) LOOP
      Statutory_Fee_API.Validate_Tax_Code(company_, rec_.tax_code, invoice_date_);   
   END LOOP;
END Validate_Vat_Codes;


-- Is_Shipment_Invoiceable
--   Returns 'TRUE' if the shipment is available to invoice otherwise 'FALSE'
@UncheckedAccess
FUNCTION Is_Shipment_Invoiceable (
   shipment_id_   IN NUMBER ) RETURN BOOLEAN
IS
   allowed_            BOOLEAN := FALSE;
   dummy_              NUMBER;
   -- The Customer_Order_Ship_Invoice will be created in post installation
   -- Therefore added ORDER check (intially it will be false) in order to skip in intial deployment of the package.
   $IF (Component_Order_SYS.INSTALLED) $THEN
      CURSOR get_shipment_invoice IS
         SELECT 1
         FROM CUSTOMER_ORDER_SHIP_INVOICE
         WHERE shipment_id = shipment_id_;
   $END   
BEGIN
   $IF (Component_Order_SYS.INSTALLED) $THEN
      OPEN get_shipment_invoice;
      FETCH get_shipment_invoice INTO dummy_;
      IF (get_shipment_invoice%FOUND) THEN
         allowed_ := TRUE;
      END IF;
      CLOSE get_shipment_invoice;
   $END
   RETURN allowed_; 
END Is_Shipment_Invoiceable;

-- Get_Branch
--   Returns the branch in Invoice_Numeration_Group_tab, if available, or
--   else, returns the branch attached to the site.
@UncheckedAccess
FUNCTION Get_Branch (
   company_     IN VARCHAR2,
   contract_    IN VARCHAR2,
   customer_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   branch_temp_      VARCHAR2(20);
   party_type_db_    VARCHAR2(20);
BEGIN
   party_type_db_    := 'CUSTOMER';
   branch_temp_ := Invoice_Numeration_Group_API.Get_Branch_Of_Numeration_Group(company_, customer_no_, party_type_db_);
   IF (branch_temp_ IS NULL) THEN 
      branch_temp_ := Site_Discom_Info_API.Get_Branch(contract_);
      RETURN branch_temp_;
   ELSE
      RETURN branch_temp_;
   END IF;
END Get_Branch;    


-- Get_Invoice_Charge_Data
--   Retrieves charge type and charge group using invoice data.
--   Method is used in Mpccom_Accounting_API to fetch values for Control_Type_Value_Tab
@UncheckedAccess
PROCEDURE Get_Invoice_Charge_Data (
   charge_type_    OUT VARCHAR2, 
   charge_group_   OUT VARCHAR2,
   company_        IN  VARCHAR2,
   invoice_id_     IN  NUMBER,
   item_id_        IN  NUMBER)
IS

   CURSOR get_item IS
      SELECT catalog_no, contract
      FROM   CUSTOMER_ORDER_INV_ITEM
      WHERE  invoice_id = invoice_id_
      AND    item_id = item_id_
      AND    company = company_
      AND    charge_seq_no IS NOT NULL;

   item_rec_        get_item%ROWTYPE;
   
BEGIN
   
   OPEN get_item;
   FETCH get_item INTO item_rec_;
   IF get_item%FOUND THEN
      -- NOTE: For invoiced charge lines, charge_type is saved as catalog_no
      charge_type_ := item_rec_.catalog_no;
      charge_group_ := Sales_Charge_Type_API.Get_Charge_Group(item_rec_.contract, charge_type_);
   END IF;
   CLOSE get_item;
   
END Get_Invoice_Charge_Data;


FUNCTION Is_Rental_Lines_Exist (
   customer_no_   IN VARCHAR2,
   contract_      IN VARCHAR2 ) RETURN VARCHAR2
IS
   result_   VARCHAR2(5) := 'FALSE';
   -- The customer_order_collect_inv will be created in post installation
   -- Therefore added ORDER check (intially it will be false) in order to skip in intial deployment of the package.
   $IF (Component_Order_SYS.INSTALLED) $THEN
      CURSOR get_orders IS
         SELECT order_no
         FROM CUSTOMER_ORDER_COLLECT_INV
         WHERE customer_no = customer_no_
         AND   contract = contract_;
   $END   
BEGIN
   $IF (Component_Order_SYS.INSTALLED) $THEN
      FOR rec_ IN get_orders LOOP
         IF Customer_Order_API.Rental_Lines_Exist(rec_.order_no) = Fnd_Boolean_API.DB_TRUE THEN
            result_ := 'TRUE';
            EXIT;
         END IF;         
      END LOOP;
   $END
   RETURN result_;
END Is_Rental_Lines_Exist;


PROCEDURE Cancel_Prelim_Debit_Invoice (
   company_       IN VARCHAR2,
   identity_      IN VARCHAR2,
   invoice_id_    IN NUMBER,
   cancel_reason_ IN VARCHAR2 )
IS
   done_sbi_cancelled_  BOOLEAN := FALSE;
   qty_invoiced_        NUMBER := 0;
   inv_line_qty_tot_    NUMBER := 0;    
   prev_objid_          VARCHAR2(100);
   order_no_arr_        Order_No_Array;
   order_no_            customer_order_line.order_no%TYPE;
   line_no_             customer_order_line.line_no%TYPE;
   rel_no_              customer_order_line.rel_no%TYPE;
   line_item_no_        customer_order_line.line_item_no%TYPE;
   ref_id_              customer_order_line.ref_id%TYPE;
   supply_code_         customer_order_line.supply_code_db%TYPE;
   consignment_stock_   customer_order_line.consignment_stock_db%TYPE;
   invoice_type_        customer_order_inv_head.invoice_type%TYPE;
   shipment_id_         NUMBER;
   info_                VARCHAR2(2000);
   shipment_freight_attr_ VARCHAR2(2000);   
   
   CURSOR get_quantities IS
      SELECT il.invoiced_qty, ol.qty_invoiced, il.original_invoiced_qty,
             ol.objid, ol.objkey, 
             ol.order_no, ol.line_no, ol.rel_no, ol.line_item_no,
             ol.ref_id, ol.supply_code_db, ol.consignment_stock_db
      FROM customer_order_inv_item_all il, customer_order_line ol
      WHERE il.company = company_
      AND il.invoice_id = invoice_id_
      AND il.order_no = ol.order_no
      AND il.line_no = ol.line_no
      AND il.release_no = ol.rel_no
      AND il.line_item_no = ol.line_item_no
      AND il.charge_seq_no IS NULL
      ORDER BY ol.order_no, ol.line_no, ol.rel_no, ol.line_item_no;
   
   CURSOR get_charge_quantities IS
      SELECT coc.order_no, 
             coc.sequence_no, 
             it.invoiced_qty
      FROM customer_order_charge         coc, 
           customer_order_inv_item_all   it
      WHERE it.company = company_
      AND   it.invoice_id   = invoice_id_                
      AND   coc.order_no    = it.order_no
      AND   it.charge_seq_no IS NOT NULL  
      AND   coc.sequence_no = it.charge_seq_no;
   
   CURSOR get_staged_bill_info IS
      SELECT order_no, line_no, rel_no, line_item_no, stage
      FROM  order_line_staged_billing_tab
      WHERE company    = company_
      AND   invoice_id = invoice_id_
      AND   rowstate   = 'Invoiced';         
   
   $IF Component_Rental_SYS.INSTALLED $THEN
      CURSOR get_rental_transactions IS      
         SELECT rental_transaction_id
         FROM customer_order_inv_item_all
         WHERE company    = company_
         AND invoice_id   = invoice_id_
         AND rental_transaction_id IS NOT NULL;
   $END
   
   CURSOR get_self_bill_info IS
      SELECT i.sbi_no, i.sbi_line_no
      FROM self_billing_header_tab h, self_billing_item_tab i
      WHERE h.sbi_no = i.sbi_no
      AND h.company = company_
      AND i.invoice_id = invoice_id_
      AND i.rowstate = 'InvoiceCreated';
      
      
   PROCEDURE Uninvoice_Order_Line__
   IS
   BEGIN
      Customer_Order_Line_Hist_API.New(order_no_,
                                       line_no_,
                                       rel_no_,
                                       line_item_no_,
                                       Get_Prel_Cancel_Hist_Text___(company_,
                                                                    invoice_id_,
                                                                    invoice_type_));

      Customer_Order_API.Set_Line_Uninvoiced(order_no_,
                                             line_no_,
                                             rel_no_,
                                             line_item_no_,
                                             qty_invoiced_ - inv_line_qty_tot_);
      Unconsume_Deliveries___(order_no_,
                              line_no_,
                              rel_no_,
                              line_item_no_,
                              invoice_id_,
                              consignment_stock_ );
                              
      Order_Line_Commission_API.Set_Order_Com_Lines_Changed(order_no_, line_no_, rel_no_, line_item_no_);
                        
      $IF (Component_Pcmsci_SYS.INSTALLED) $THEN
         IF (supply_code_ = 'SEO') AND (invoice_type_ != 'CUSTCOLDEB') THEN
            Psc_Contr_Product_Invline_API.Set_Invoice_Id_From_Order(ref_id_, 
                                                                    order_no_, 
                                                                    line_no_, 
                                                                    rel_no_, 
                                                                    line_item_no_, 
                                                                    NULL);                          
         END IF;
      $END
   END Uninvoice_Order_Line__;
      
BEGIN
      
   $IF Component_Rental_SYS.INSTALLED $THEN 
      FOR rec_ IN get_rental_transactions LOOP
         -- To clear invoice details, NULL is pased for qty_invoiced_ so that it is set as 0 and invoice_status is set to 'NOT INVOICED'
         Rental_Transaction_API.Modify_Qty_Invoiced(rec_.rental_transaction_id, NULL);
      END LOOP;
   $END
   
   shipment_id_ := Customer_Order_Inv_Head_API.Get_Shipment_Id(company_, invoice_id_);
   
   invoice_type_ := Invoice_API.Get_Invoice_Type(company_, invoice_id_);
   
   Get_Connected_Orders___ (order_no_arr_,
                            company_,
                            invoice_id_);                               
      
   Remove_Invoice_Associations___(company_,
                                  invoice_id_,
                                  FALSE);
   
   Cust_Order_Invoice_Hist_API.New(company_, invoice_id_, Language_SYS.Translate_Constant(lu_name_, 'INVHISTCANCEL: Invoice cancelled', NULL));
   
   -- gelr: cancel_customer_order_invoice, begin
   Validate_Cancel_Debit_Invoice___(company_, invoice_id_);
   -- gelr: cancel_customer_order_invoice, begin
   
   Customer_Invoice_Pub_Util_API.Cancel_Debit_Invoice(company_,
                                                         identity_,
                                                         invoice_id_,
                                                         cancel_reason_);
   Create_Order_History___ (company_,
                            invoice_id_,
                            TRUE,
                            order_no_arr_,
                            invoice_type_ => invoice_type_);
                            
   IF ((shipment_id_ IS NOT NULL) AND (Shipment_Freight_API.Get_Freight_Chg_Invoiced_Db(shipment_id_) = 'TRUE')) THEN
      Client_SYS.Add_To_Attr('FREIGHT_CHG_INVOICED_DB', 'FALSE', shipment_freight_attr_);
      Shipment_Freight_API.Modify(info_, shipment_freight_attr_, shipment_id_);
   END IF;
   
   IF invoice_type_ != NVL(Company_Def_Invoice_Type_API.Get_Def_Adv_Co_Dr_Inv_Type(company_), 'COADVDEB') THEN
      FOR qty_rec_ IN get_quantities LOOP
         -- Compare objid of current Customer Order Line record with previous one and Call Uninvoice_Order_Line__ only when they differ
         -- so that it will be called per Customer Order Line record
         IF ( qty_rec_.objid != nvl(prev_objid_, qty_rec_.objid) ) THEN
            Uninvoice_Order_Line__();
            inv_line_qty_tot_ := 0;
         END IF;

         IF (order_no_ IS NULL) OR (qty_rec_.order_no != order_no_) THEN
            Customer_Order_API.Modify_Grp_Disc_Calc_Flag(qty_rec_.order_no, 'N');
            Order_Line_Commission_API.Reset_Order_Com_Lines_Changed(qty_rec_.order_no);
            $IF Component_Pcmsci_SYS.INSTALLED $THEN
               IF (invoice_type_ = 'CUSTCOLDEB') THEN
                  Psc_Inv_Line_Util_API.Reset_Product_Invoice(qty_rec_.order_no, company_, invoice_id_);
               END IF;
            $END
         END IF;   

         order_no_          := qty_rec_.order_no;
         line_no_           := qty_rec_.line_no;
         rel_no_            := qty_rec_.rel_no;
         line_item_no_      := qty_rec_.line_item_no;
         
         IF (Return_Material_Line_API.Lines_Invoice_Connected(order_no_, line_no_, rel_no_, invoice_id_) = 'TRUE') THEN
            Error_SYS.Record_General(lu_name_, 'RMALINESCONNEXIST: This Customer Invoice is connected to a Return Material Line. Remove the connection to cancel the Invoice.');
         END IF;
         
         -- it might have changed when updating the qty_invoiced for the releveant package header line.
         IF (line_item_no_ > 0) THEN
            qty_invoiced_      := Customer_Order_Line_API.Get_Qty_Invoiced(order_no_, line_no_, rel_no_, line_item_no_);
         ELSE
            qty_invoiced_   :=  qty_rec_.qty_invoiced;
         END IF;
         prev_objid_        := qty_rec_.objid;
         ref_id_            := qty_rec_.ref_id;
         supply_code_       := qty_rec_.supply_code_db;
         consignment_stock_ := qty_rec_.consignment_stock_db;
         inv_line_qty_tot_  := inv_line_qty_tot_ + NVL(qty_rec_.original_invoiced_qty, qty_rec_.qty_invoiced);
      END LOOP;
      -- This will handle the call to Uninvoice_Order_Line__ for the last Customer Order Line record
      IF order_no_ IS NOT NULL THEN
         Uninvoice_Order_Line__();
      END IF;

      FOR chg_qty_rec_ IN get_charge_quantities LOOP
         Customer_Order_Charge_API.Modify_Invoiced_Qty( chg_qty_rec_.order_no,
                                                        chg_qty_rec_.sequence_no,
                                                        chg_qty_rec_.invoiced_qty * -1,
                                                        FALSE );
      END LOOP;

      -- Reset status of any Staged billing profile records involved
      FOR stage_rec_ IN get_staged_bill_info LOOP
         Order_Line_Staged_Billing_API.Set_Uninvoiced( stage_rec_.order_no,
                                                       stage_rec_.line_no,
                                                       stage_rec_.rel_no,
                                                       stage_rec_.line_item_no,
                                                       stage_rec_.stage );
      END LOOP;
   
      -- Reset status of any Self Billing item/ head records involved
      FOR sbi_rec_ IN get_self_bill_info LOOP
         IF NOT done_sbi_cancelled_ THEN
            Self_Billing_Header_API.Do_Sbi_Cancelled (sbi_rec_.sbi_no);
         END IF;
         done_sbi_cancelled_ := TRUE;                                        
         Self_Billing_Item_API.Do_Sbi_Cancelled (sbi_rec_.sbi_no,
                                                 sbi_rec_.sbi_line_no);
      END LOOP;
   END IF;
END Cancel_Prelim_Debit_Invoice;

PROCEDURE Create_Rate_Correction(
   company_                IN VARCHAR2, 
   invoice_id_             IN VARCHAR2,   
   curr_rate_              IN NUMBER,
   tax_curr_rate_          IN NUMBER,
   invoice_date_           IN DATE,
   correction_reason_id_   IN VARCHAR2 DEFAULT NULL,
   correction_reason_      IN VARCHAR2 DEFAULT NULL )
IS
   description_    VARCHAR2(200);
   invoice_no_     VARCHAR2(52);
   attr_           VARCHAR2(2000);
BEGIN     
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('COMPANY', company_, attr_);
   Client_SYS.Add_To_Attr('INVOICE_ID', invoice_id_, attr_);
   Client_SYS.Add_To_Attr('CURR_RATE', curr_rate_, attr_);
   Client_SYS.Add_To_Attr('TAX_CURR_RATE', tax_curr_rate_, attr_);
   Client_SYS.Add_To_Attr('INVOICE_DATE', invoice_date_, attr_);
   Client_SYS.Add_To_Attr('CORRECTION_REASON_ID', correction_reason_id_, attr_);
   Client_SYS.Add_To_Attr('CORRECTION_REASON', correction_reason_, attr_);
   description_ := Language_SYS.Translate_Constant(lu_name_, 'CRE_RATE_INV: Create Rate Correction Invoices');
   invoice_no_ := Customer_Order_Inv_Head_API.Get_Series_Id_By_Id(invoice_id_) || Customer_Order_Inv_Head_API.Get_Invoice_No_By_Id(invoice_id_);
   Check_No_Previous_Execution___(invoice_id_, invoice_no_, 'INVOICE_CUSTOMER_ORDER_API.Create_Rate_Corr_Invoices__');
   -- Check if previous background job has already created a Rate_ Correction Invoice
   IF ( Customer_Order_Inv_Head_API.Get_Correction_Invoice_Id(company_, invoice_id_) IS NOT NULL) THEN
      Error_SYS.Record_General(lu_name_, 'RATECORREXIST: The customer invoice :P1 has already been processed by another user and created rate correction invoice.', invoice_no_);
   END IF;
   Transaction_SYS.Deferred_Call('INVOICE_CUSTOMER_ORDER_API.Create_Rate_Corr_Invoices__', attr_, description_);   
END Create_Rate_Correction;

-- Create_Adv_Inv_Tax_Item
--   Creates invoice tax lines for advance invoices
PROCEDURE Create_Adv_Inv_Tax_Item (
   tax_info_table_ IN Tax_Handling_Util_API.tax_information_table,
   company_        IN VARCHAR2,
   invoice_id_     IN NUMBER,
   item_id_        IN NUMBER )
IS
BEGIN
   Tax_Handling_Order_Util_API.Add_Source_Tax_Invoic_Lines (tax_info_table_,
                                                            company_,
                                                            TO_CHAR(invoice_id_),
                                                            TO_CHAR(item_id_),
                                                            '*',
                                                            '*',
                                                            '*',
                                                            Tax_Source_API.DB_INVOICE); 
END Create_Adv_Inv_Tax_Item;


-- Clear_Rebate_Postings_Ref_Data
--    The reb_aggr_line_cntrl_type_tmp and reb_aggr_line_posting_tmp needs to be cleared after an invoice gets printed and posted accordingly.
--    If the invoice gets stuck in an error state, the reference data on reb_aggr_line_cntrl_type_tmp needs to be preserved for subsequent runs using the Customer Invoices with Errors window. 
--    Else after a successful posted invoice, all reference data should be cleared related to it.  

PROCEDURE Clear_Rebate_Postings_Ref_Data (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER)
IS
   aggregation_no_     NUMBER := NULL;
BEGIN
   aggregation_no_ := Customer_Order_Inv_Head_API.Get_Aggregation_No(company_, invoice_id_);
      IF (aggregation_no_ IS NOT NULL) THEN
         IF (NVL(Out_Invoice_Util_Pub_API.Is_With_Errors(company_, invoice_id_), 'FALSE') = 'TRUE') THEN
            -- Postings process has a code-string with an error. 
            -- The invoice needs to be processed using 'Customer Invoices with Errors' window after the posting setup done correctly.
            -- Remove data in reb_aggr_line_cntrl_type_tmp only.
            Clear_Reb_Aggr_Tmp_Tabs___(aggregation_no_, NULL, 2);
         ELSE
            -- Invoice postings done without any error.
            -- Remove data if in REB_AGGR_LINE_CNTRL_TYPE_TMP and in reb_aggr_line_cntrl_type_tmp both. 
            Clear_Reb_Aggr_Tmp_Tabs___(aggregation_no_, NULL, 0);
         END IF;
      END IF;
   END Clear_Rebate_Postings_Ref_Data;
   
   -- gelr:br_external_tax_integration, begin
@IgnoreUnitTest DMLOperation
PROCEDURE Update_Business_Operation(
   company_             IN VARCHAR2,
   invoice_id_          IN NUMBER,
   item_id_             IN NUMBER,
   cfop_info_           IN VARCHAR2)
IS
   attr_                VARCHAR2(4000);
   reference_           VARCHAR2(100);
   CURSOR get_reference IS
      SELECT reference       
        FROM customer_order_inv_item
       WHERE company = company_
         AND invoice_id = invoice_id_
         AND item_id = item_id_;
BEGIN   
   IF company_ IS NOT NULL AND invoice_id_ IS NOT NULL THEN
      attr_ := NULL;

      OPEN get_reference;
      FETCH get_reference INTO reference_;
      CLOSE get_reference;
      
      Client_SYS.Add_To_Attr('COMPANY', company_, attr_);
      Client_SYS.Add_To_Attr('INVOICE_ID', invoice_id_, attr_);
      Client_SYS.Add_To_Attr('REFERENCE', reference_, attr_);
      Client_SYS.Add_To_Attr('BUSINESS_OPERATION', cfop_info_, attr_);
      Customer_Invoice_Pub_Util_API.Modify_Invoice_Item(attr_, 'CUSTOMER_ORDER_INV_ITEM_API');
   END IF;
END Update_Business_Operation;
-- gelr:br_external_tax_integration, end

-- Check_Tax_Dom_Amount_Editable() method introduced to make editable the tax amount/base field in customer invoice line section only for the below scenarios
-- specific tax curr rate is used in company level, transaction done in foreign currency , invoice type is self billing debit
-- tax disbursed method is invoice entry and invoice state is preliminary
@UncheckedAccess
FUNCTION Check_Tax_Dom_Amount_Editable (
   company_               IN VARCHAR2,
   tax_code_              IN VARCHAR2,
   curr_code_             IN VARCHAR2,
   inv_state_db_          IN VARCHAR2,
   multiple_tax_          IN VARCHAR2,
   inv_type_              IN VARCHAR2,
   client_validation_     IN VARCHAR2 DEFAULT 'FALSE') RETURN VARCHAR2
IS
   
BEGIN
   -- this condition (client_validation_ = 'TRUE') reached only when calling from aurena client
   IF (client_validation_ = 'TRUE') THEN
      IF (Currency_Type_Basic_Data_API.Get_Use_Tax_Rates(company_)  = 'TRUE' AND Statutory_Fee_API.Get_Vat_Disbursed_Db(company_,tax_code_) = '1') THEN
         RETURN 'TRUE';
      ELSE
         RETURN 'FALSE';
      END IF;
   ELSE
      IF (Currency_Type_Basic_Data_API.Get_Use_Tax_Rates(company_)  = 'TRUE'                                        AND 
         curr_code_                                                != Currency_Code_API.Get_Currency_Code(company_) AND 
         Statutory_Fee_API.Get_Vat_Disbursed_Db(company_,tax_code_) = '1'                                           AND
         inv_state_db_                                              = 'Preliminary'                                 AND
         multiple_tax_                                              = 'FALSE'                                       AND
         inv_type_                                                  = 'SELFBILLDEB') THEN
         RETURN 'TRUE';
      ELSE
         RETURN 'FALSE';
      END IF;
   END IF;
END Check_Tax_Dom_Amount_Editable;



