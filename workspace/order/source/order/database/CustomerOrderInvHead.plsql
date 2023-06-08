-----------------------------------------------------------------------------
--
--  Logical unit: CustomerOrderInvHead
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220202  Nasrlk   FI21R2-8932, Modified Create_Invoice_Head to fetch prepayment_type_code for CO credit prepayment tax document.
--  220201  Hecolk   KEEP-5977, IFSCloud E-invoice Compliance Attachment Handling 
--  220201  Ckumlk   FI21R2-4095, Merged Bug 160856, Modified Print_Invoice___ to add ORIGINAL to parameter_attr_.
--  220201  Smallk   FI21R2-8623, Removed references to External_Tax_Calc_Method_API.DB_VERTEX_SALES_TAX_Q_SERIES.
--  220122  ErFelk   Bug 161918(SC21R2-7337), Modified Print_Invoices() to set the print_online_ variable when print_method is PRINT_ONLINE and PRINT_BACKGROUND.  
--  220120  Kagalk   KEEP-5976, Modified Print_Invoices to support e-invoicing_compliance functionality.
--  220110  Hiralk   FI21R2-6563, Added prepayment_tax_document functionality.
--  211210  PeSulk   PJ21R2-3689, Modified Create_Invoice_Head to set value to is_simulated variable.
--  211108  NiDalk   SC21R2-5622, Added new method Get_Fiscal_Note_Ref_Info to fetch info for fiscal note from customer invoice. Also added Get_Contract and added creators_referenece to Public_Rec.
--  210831  Skanlk   Bug 160293(SC21R2-2540), Added the method Get_First_Co_To_Invoice__ to retrieve the first customer order which will be used to pass pre-posting values.
--  210831           Modified the method Create_Postings to add pre posting values of the first customer order invoiced for both normal and collective invoices.
--  210805  KiSalk   Bug 160297(SCZ-15850),In Get_Send_Invoice_Address_Data, used order_no from the first invoice item for collective customer invoices, as creators_reference is empty. 
--  210714  Utbalk   FI21R2-1566, Added procedure Update_Complimentary_Info.
--  210712  Sacnlk   FI21R2-2144, Added Posting Prepayments Based on Prepayment Type functionality.
--  210630  Shdilk   FI21R2-1650, Added out_inv_curr_rate_voucher_date functionality.
--  210628  ChFolk   SCZ-15338(Bug 159858), Modified Fetch_Unknown_Head_Attributes to fetch document text from rma header when invoice is created from rma.
--  210420  ApWilk   Bug 158843(SCZ-14546), Modified Check_Connected_Co_Exist__() to enable the RMB Reprint Modified when there are Customer Invoices with freight charges added through shipments.
--  210506  NiDalk   Bug 158933(SCZ-14121), Modified Write_To_Ext_Tax_Reg___ to pass prel_update_allowed to avoid updating taxes for credit lines.
--  210305  PamPlk   Bug 157341(SCZ-13917), Modified Create_History_When_Printed___() and Print_Invoices() to include PRINT_method which holds the values PRINT_ONLINE and PRINT_BACKGROUND. 
--  210305           This was used to bypass the history comment when an email is not sent.
--  210222  ErRalk   Bug 145450(SCZ-13531), Modified Get_Send_Invoice_Address_Data() by adding new OUT parameters shipment_id_, receiver_id_.
--  210201  RoJalk   Bug 151635(SCZ-13389), Modified Create_Postings() by modifying the invoice_tab whenever a code part value is changed to allow the proper posting creation
--  210201           when the code part values become NULL.
--  210129  ApWilk   Bug 156580(SCZ-13222), Modified Get_Company_Tax_Details___() to fetch the correct company tax id when creating the customer order invoice.
--  201221  ErRalk   Bug 156317(SCZ-12591), Modified Print_Invoices() so that rebate transactions are created for Collective Correction Invoice type.
--  201029  RasDlk   SCZ-11050, Added the missing annotations for Enumerate_States__ and Language_Refreshed to solve MissingAnnotation issue.
--  200916  MaEelk   GESPRING20-5400, Added Get_Discounted_Price_Rounded to check if all invoice lines are Discounted Price Enabled or not.
--  200904  WaSalk   GESPRING20-537, Added Get_Party_Type() to support gelr fuctionalities.
--  200720  NiDalk   Bug 154138 (SCZ-9209), Modified Write_To_Ext_Tax_Reg___ to send tax registration to VERTEX for correction invoice lines.
--  200715  KiSalk   Bug 154819, Added Finite_State_Encode__ and Enumerate_States__ to pass PLSQL model compliance test.
--  200417  Dihelk   gelr:fr_service_code, Adding service code.
--  200304  BudKlk   Bug 148995 (SCZ-5793), Modified the methods Modify_Invoice_Head___, Print_Invoice___, Print_Invoice to resize the variable size of cust_ref_ and contact_.    
--  200624  ApWilk   Bug 153456 (SCZ-9726), Modified Modify_Invoice_Complete__() to prevent deleting the invoice fee when changing the fields in header and line of the invoice.
--  200311  Basblk   Bug 150914 (FIZ-4505), Modified Print_Invoices, added USER_GROUP to head_attr_.
--  200225  NWeelk   GESPRING20-3706, Modified method Print_Invoices by adding validations for invoice reason and alternate unit of measure to raise when printing the Mexican e-Invoice. 
--  200211  KiSalk   Bug 150067(SCZ-7093), Modified Print_Invoices to update detailed statistics for invoiced sales only if rebate transactions created.
--  200127  ThKrLk   Bug 150623 (SCZ-7909), Added attributes use_ref_inv_curr_rate, number_reference, series_reference to Public_Rec and Get method.
--  200114  DhAplk   Bug 151621 (SCZ-8217), Modified Print_Invoices, Create_History_When_Printed___ methods to avoid the adding history record as Invoice emailed when print the invoice.
--  200113  Hiralk   GESPRING20-1895, Modified Create_Invoice_Head() to add invoice_reason_id functionality.
--  191016  ErFelk   Bug 150556 (SCZ-7449), Modified Get_Creators_Reference() by changing the method return type to VARCHAR2.
--  191003  Hairlk   SCXTEND-876, Avalara integration, Added Get_Debit_Invoice_Info and modified Write_To_Ext_Tax_Reg___ to write to avalara tax registry if the external tax calculation method is AVALARA. 
--  190919  AsZelk   Bug 150044 (SCZ-6813), Modified Print_Invoice___() method in order to reverse Bug 136825 due to creating two invoices in report archive.
--  190822  AsZelk   Bug 149567 (SCZ-6460), Modified Create_History_When_Printed___() by increasing invoice_email_ size by 200 from 100 to avoid error message when email address exceed 100 characters.
--  190717  Dkanlk   Bug 142602, Merged APP9 correction, Modified code to switch between different Swiss payment slips.
--  190524  ChBnlk   Bug 146299 (SCZ-3133), Modified Fetch_Unknown_Head_Attributes() in order to fetch the your_ref_desc_ from the invoice_address_id_ for collective invoices.
--  190416  MaEelk   SCUXXW4-19394, Added missing annotations to Finite_State_Decode__ and Finite_State_Events__.
--  190314  niedlk   SCUXXW4-9047, Added Get_Total_Sales_By_Year which is used by Customer 360 in Aurena.
--  190208  KHVESE   SCUXXW4-764, Added methods Get_Creators_Reference.
--  190112  UdGnlk   Bug 146019(SCZ-2544), Modified Modify_Invoice_Head___() to add a validation to check the validity of invoice address id.
--  181203  MAZPSE   Bug 145291, Modified method Modify_Work_Order_Ivc_Info___() to optimize speed to Work Order. Removed unnecessary code as well in that method.
--  181116  AMCHLK   Bug 145390, Modified Method Modify_Invoice_Details____() to update Work Order Invoice Info. 
--  181024  KiSalk   Bug 142841, Modified Get_Send_Invoice_Address_Data to retrieve address detail from RMA as well.
--  181020  KiSalk   Bug 144823, Replaced hardcoded values of prepayment invoice types with company defined values in Modify_Invoice_Head___.
--  180921  KHVESE   SCUXXW4-1054, Modified method Modify_Invoice_Head___ to fetch invoice_addr_id_ and invoice_date_ from lu_rec_ if they are not exist in the attr_ comming from client.
--  180810  KHVESE   SCUXXW4-1054, Added method Org_Print_Exists_In_Archive__.
--  180810  KHVESE   SCUXXW4-8350, Modified method Validate_Corr_Reason to fetch party type in cursor and send in the client value of party type to method Get_Validate_Correction_Rea_Db.
--  180802  WaSalk   Bug 141843, Modified Create_Invoice_Head by adding is_simulated_ parameter and modified condition to not to call copy_connected_objects if simulated. 
--  180702  KHVESE   SCUXXW4-12425, Added methods Finite_State_Decode__, Get_Client_Values___, Get_Db_Values___, Finite_State_Events__, Language_Refreshed
--  180511  KiSalk   Bug 141081, Added Get_Send_Invoice_Address_Data to retrieve address detail required when sending customer invoice and Get_Shipment_Id to support it.
--  180508  Ajpelk   Bug 141455, Added a new parameter to Customer_Invoice_Pub_Util_API.Get_Invoice_No_For_Printout and it calls from Print_Invoices 
--  180228  ChBnlk   STRSC-17325, Modified cursor get_next_item in Create_Postings in order to exclude the rounding factor and fee code items when creating
--  180228           postings from Customer_Order_Inv_Item.
--  180220  Bhhilk   STRFI-9996, Merged Bug 137839, Modified Send_Invoices() to raise error message if the session is not deferred.
--  180209  KoDelk   STRSC-15901, Made Get_Max_Deliv_Date public
--  180111  BudKlk   Bug 137467, Modified the method Create_Invoice_Head() to retrive values for correction_reason and correction_reason_id when they got values.
--  171207  Denelk   CRUISE-1207, Modified Modify_Invoice_Dates___(),Modify_Invoice_Head___(),Modify_Invoice_Details____(),Create_Invoice_Head to fetch rates based on delivery date or invoice date
--  171130  Kagalk   CRUISE-994, Modified Modify_Invoice_Dates___ to stop currency rate change while printing when company cust inv curr rate base is
--  171130           delivery date and Set invoice date to current date is checked.
--  171128  BudKlk   Bug 132164, Handled the columns in insert and update related methods. Added methods Validate_Corr_Reason() and Check_Corr_Reason_Exists(). 
--  171127  MAHPLK   STRFI-10886, Mofified Print_Invoices() method to  write tax information's to external system when printing invoice.
--  171117  Denelk   CRUISE-791 , Implementation, Customer invoice currency rate based on delivery date, modified Modify_Invoice_Dates___().
--  170925  niedlk   SCUXX-774, Modified Print_Invoice___() to distribute the invoice to the connected users if the customer is a B2B customer.
--  171002  SBalLK   Bug 137173, Modified Get_Ad_Net_Without_Invoice_Fee() and Get_Ad_Gro_Without_Invoice_Fee() methods to get total without considering invoice in Preliminary when necessary.
--  170925  niedlk   SCUXX-774, Modified Print_Invoice___() to distribute the invoice to the connected users if the customer is a B2B customer.
--  170912  SBalLK   Bug 137611, Modified Create_Invoice_Appendices(), Print_Invoices() and Send_Invoices() method to create/print invoice specification when customer invoice create/print.
--  170726  AsZelk   STRSC-10917, Modified the method Print_Invoices()___ to enable sending the email invoice automatically when order stops at create invoice and then manually print.
--  170517  NipKlk   STRSC-2566, Added new parameters curr_rate_new_, tax_curr_rate_new to the method Create_Invoice_Head() and modified its code to override the ref_inv_rec_ values curr_rate_ and tax_xurr_rate_in
--  170517           When those parameter values are not null since they have a value when there is a rate correction invoice head is being made.
--  170627  ErFelk   Bug 135761, Modified Print_Invoices() by moving the error INTERIMEXIST to a new method Customer_Order_Inv_Head_API.Interim_Voucher_Exist().
--  170627           When calling this method priority should be given to voucher_date.
--  170428  ErRalk   Bug 135430, Modified Print_Invoice___() by Changing the 'result_keys_' parameter to an IN OUT parameter and set result_keys_ to  NULL in Print_Invoices().
--  170315  Chwilk   Bug 134684, Modified Print_Invoices to handle multiple resends of an already sent invoice.
--  170215  ChJalk   Bug 133978, Modified Fetch_Unknown_Head_Attributes to send document text for collective invoices.
--  170320  ChBnlk   Bug 128400, Modified Print_Invoices() to pass the value of the attribute 'PRINT_ONLINE' in to the method call Print_Invoice___() and modified Print_Invoice___() 
--  170320           by adding a new parameter print_online_ and passing it in to parameter_attr_, to be passed in to the method call Customer_Order_Flow_API.Create_Print_Jobs(). 
--  170208  AmPalk   STRMF-6864, Modified Create_Postings to handle postings errors from rebate flexible postings and clear temporary data using Clear_Aggr_Posting_Tmp_Tabs accordingly. 
--  170208           Modified Print_Invoices to clear the reference data (if any) stored in temp tables during flexible posting creation process for rebate credit invoices accordingly.
--	 170118	JAROLK	STRSA-15944, Modified Create_Order_Appendix___(), Modify_Work_Order_Ivc_Info___().
--  170103  MeAblk   Bug 133265, Modified Modify_Invoice_Head___() to make it possible to change the cust reference of non-preliminary invoices.
--  160803  SWeelk   Bug 130368, Modified Check_Unpaid_Advance_Inv_Exist() to check whether the invoice type is equal to the user defined company default advance debit invoice type.
--  160629  Gawilk   Bug 130108, Increased the length of withholding_msg_ to 32000 and set it as a parameter to raise error in Print_Invoices.
--  160507  BudKlk   Bug 128726, Modified Modify_Invoice_Dates___() to fetch parallel currency rate.
--  160518  BudKlk   Bug 128049, Modified the method Print_Invoices() to enable sending the email invoice also for the order_type 'SELFBILLDEB'.
--  160407  DipeLK   FINHR-1685,changed method call from Tax_Item_API.Get_Tax_Curr_Rate to Tax_Handling_Invoic_Util_API.Get_Tax_Curr_Rate.
--  160201  Chwtlk   Bug 124890, Modified Modify_Invoice_Head___. Error DUEDATECHANGE is generated only if the current pay_term_id, invoice_date and pay_term_base_date are not changed.
--  151110  MaIklk  LIM-4059, Renamed deilver_to_customer_no to receiver_id and renamed address fields to sender_xxx and receiver_xxx of shipment table.
--  151022  ChJalk   Bug 123410, Added methods Validate_Invoice_Text and Check_Invoice_Text_Exists.
--  150901  Umdolk   AFT-3107, Added method Get_Invoice_Status_Db. 
--  150820  MeAblk   Bug 124025, Modified Create_Postings() in order to add pre posting when a collective invoice only connected to one customer order. 
--  150722  AyAmlk   Bug 123589, Modified Print_Invoice___() in order to prevent printing the CO invoice when the Print document check box is not checked.
--  150605  Hecolk   KES-538, Adding ability to cancel preliminary Customer Order Invoice
--  150722           Modified Print_Invoices() to pass send_and_print_ and send_ parameters correctly to Print_Invoice___(). Modified Print_Invoice___() by adding
--  150722           the parameter media_code_ and passed a value from Print_Invoices in order to print it in the note text.
--  150618  NWeelk   Bug 123054, Modified Print_Invoice___ by adding OUT parameter result_keys_, modified Print_Invoices by making attr_ an IN OUT parameter
--  150618           to pass the result_key_ when printing invoice online and raised the errors if the invoice is printed online.
--  150324  SBalLK   Bug 121721, Modified Print_Invoices() method to avoid considering the cancelled return material lines when updating the invoice information in the return material.
--  150304  Chfose   PRSC-6334, Added a null-check for ref_invoice_id in Create_Credit_Invoice_Hist___.
--  150224  Chfose   PRSC-6236, Modified Create_History_When_Printed___ to also create history when having the customer setting to email invoices active.
--  150218  MeAblk   EAP-1042, Modified Print_Invoice___ in order to avoid sending pdf info when printing the order confirmation if the emaling is not ebaled for the customer.
--  150206  SWiclk   PRSC-6174, Modified Create_Credit_Invoice_Hist___() in order to log history for credit invoice and advance invoice.
--  141217  Nirylk   PRFI-3962, Added parallel_curr_rate to Get() method and Public_Rec. Added new method Prepayment_Curr_Diff().
--  141119  KiSalk   Bug 119792, Modified Modify_Invoice_Dates___ and Print_Invoices to update invoice_date in CUST_ORD_INVO_STAT according to the 
--  141119           numbering_cust_inv_date_order value of Company_Invoice_Info.
--  141119  RuLiLk   PRSC-2839, Modified method Fetch_Unknown_Head_Attributes() to send customer reference name instead of customer reference id when the name has a value.
--  140903  TiRalk   Bug 117129, Modified Create_Order_Appendix___, Create_Invoice_Appendixes___, Print_Invoice___ and Print_Invoices
--  140903           to pass the invoice specification print_job_id to attach the pdfs to invoice properly.
--  140821  HimRlk   Modified Create_Postings() by adding new parametr user_group_ and added the value to app_context to be used in posting creation flow..
--  140813  AyAmlk   Bug 116357, Modified Create_Credit_Invoice_Hist___() by changing the CURSOR in order to prevent creating a CO history record when order_no is NULL.
--  140811  NiDalk   Bug 118201, Modified Print_Invoices to pass company_ to method Outstanding_Sales_API.Modify_Sales_Posted.
--  140630  KiSalk   Bug 117499, In Print_Invoices, check for payment SLIP for ISR payments creation changed from Company_Invoice_Info_API.Get_Reference_Method_Db to Invoice_API.Validate_Isr_Print.
--  140604  ChBnlk   Bug 117240, Modified Create_Invoice_Head() to get the currency_type_ from the customer order when it has a currency rate type. 
--  140409  NipKlk   Bug 115981, Renamed the method Create_Invoice_Appendixes___ to Create_Invoice_Appendices and made it public and added new parameters
--  140409           and passed the same parameters to Create_Order_Appendix___ and Work_Order_Coding_Utility_API.Create_Invoice_Appendix methods 
--  140409           to be able to pass the pdf parameters to the invoice specification report.
--  140321  NWeelk   Bug 110675, Added parameter company to the method Print_Invoice___ and modified Print_Invoice___ to call Create_Report_Settings 
--  140321           to build the attribute strings necessary to send the email when the report is printed and modified Print_Invoices() to pass contact 
--  140321           correctly when email Print invoice in Customer Order flow.
--  140305  BudKlk   Bug 115730, Modified the Create_History_When_Printed___ method in order print invoice number using the series_id to 
--  140305           differentiate invoice number when having same number for different invoice types.
--  131128  MalLlk   Added Remove method to delete CustOrderInvoiceHist records for CO Invoice Head.
--  131125  BURALK   PBSA-2713, changed Active_Work_Order_API.Get_Complex_Agreement_id(wo_no_) to Active_Separate_API.Get_Complex_Agreement_id(wo_no_).
--  --------------------------- APPS 9 ------------------------------------------------------------------------
--  130916  MAWILK   BLACK-566, Replaced Component_Pcm_SYS.
--  121022  ShKolk   Added Get_Use_Price_Incl_Tax_Db().
--  120921  ShKolk   Added parameter use_price_incl_tax_db_ to Create_Invoice_Head().
--  130806  Shdilk   TIBE-1978, Added parameters to Modify_Invoice_Complete__ to remove g_invoice_head global variable.
--  130704  AwWelk   TIBE-980, Removed global variable inst_jinsui_, inst_DocReferenceObject_ and introduced conditional compilation.
--  130906  NWeelk   Bug 111252, Modified method Fetch_Unknown_Head_Attributes by removing additional discount since additional discount is now a line level attribute.
--  130830  TiRalk   Bug 109294, Modified Print_Invoice___,  Print_Invoices and Send_Invoices by calling Create_Print_Jobs and Printing_Print_Jobs 
--  130830           Customer_Order_Flow_API to create one print job for Invoice and instances for copies and modified Create_Order_Appendix___,   
--  130830           Create_Invoice_Appendixes___ to create a separate job for Invoice specification/ MRO Invoice Specification.
--  130822  SudJlk   Bug 111855, Modified Create_Credit_Invoice_Hist___ to remove amounts from credit advance invoice creation history record. 
--  130710  Chselk   Bug 110994. Converted the implementation method Calculate_Prel_Revenue___ to a public method called Calculate_Prel_Revenue. 
--  130710  ErFelk   Bug 111142, Corrected the method name in General_SYS.Init_Method of Modify_Work_Order_Ivc_Info___().
--  130508  KiSalk   Bug 106680, Replaced Installed_Component_SYS.<component> with Component_<component>_SYS.<component>.
--  130401  KiSalk   Bug 107773, Added debit_invoice_id to CUSTOMER_ORDER_INV_HEAD_UIV view.
--  130313  KiSalk   Bug 108708, Added Modify_Work_Order_Ivc_Info___ and called it from Print_Invoices and Send_Invoices to update WO side when printouts bypassed.
--  130313           Re-written to pass correct WO number to MRO appendix printing and to print both the MRO appendix Invoice appendix when required.
--  130218  SudJlk   Bug 108372, Modified Create_History_When_Printed___ to reflect length change in CUSTOMER_ORDER_LINE_HIST_TAB.message_text and eliminate errors when email address list is long.
--  121221  GiSalk   Bug 106710, Added the private function Check_Connected_Co_Exist__.
--  121120  AyAmlk   Bug 106747, Modified Create_Invoice_Head() by adding the invoice_date_ as a parameter and altered the code to pass invoice_date_ if exists.
--  121107  AyAmlk   Bug 106006, Modified Print_Invoice___() and Print_Invoices() in order to support printing Swiss ISR slip with the invoices that can be printed from Customer Invoice.
--  121003  ChFolk   Modified Get_Company_Tax_Details___ to fetch the delivery country code for RMA with single occurence address.
--  120727  MaEelk   Added Allow_Print_Shipment_Invoice.
--  121002  GiSalk   Bug 101901, Modified Get_Company_Tax_Details___ to retrieve the branch using Invoice_Customer_Order_API.Get_Branch(), when a brach is not defined in 
--  121002           company tax information window.
--  120920  GiSalk   Bug 101901, Modified Create_Invoice_Head() by using Invoice_Customer_Order_API.Get_Branch() to retrieve the branch, 
--  120920           when the incoming parameter branch_ has no value.
--  120829  SeJalk   Bug 103399, Modified the procedure Print_Invoices() in order to set the sales posted date by the invoice date and
--  120829           to raise an error message if the interim sales voucher exist for the invoice when printing.
--  120827  GiSalk   Bug 104662, Modified Modify_Invoice_Head___() by adding a validation to check whether, new invoice_date is not earlier than the latest payment date, of 
--  120827           prepayment based invoices, when the invoice date is changed.
--  120823  GiSalk   Bug 104555, Modified Print_Invoices(), by using hard-coded layout id values only when no layout id is returned from the method Invoice_Type_API.Get_Layout_Id(); 
--  120426  NaLrlk   Modified the Modify_Invoice_Head___ to add the vacation period error message when due date is modified.
--  120426           Modified method Modify_Invoice_Dates___ to consider vacation period when recalculating due date when payterm_id or pay_term_base_date is changed.
--  120329  Darklk   Bug 101191, Reversed the bug 88819 to restrict the re-calculation of the invoiced line amounts. Added Validate_Vat_Codes___
--  120329           and modified the procedure Modify_Invoice_Head___ to validate the tax code when changing the invoice date.
--  120229  TiRalk   Reversed the Bug 77713 since the print server is no longer available in APP8.
--  120217  TiRalk   Bug 99454, Modified Print_Invoices by rearranging the code to update the self billing invoice with the series ID 
--  120217           and the new invoice number when printing multiple self billing invoices.
--  120213  NaLrlk   Bug 96456, Modified Print_Invoices to change the CANNOTPRINT error message.
--  120131  MeAblk   Bug 100800, Increased the length of the data type of the local variables advance_dr_invoice_type_, advance_cr_invoice_type_ upto 20 in the methods 
--  120131           Calc_And_Set_Max_Deliv_Date__,  Get_Ad_Net_Without_Invoice_Fee,  Get_Ad_Gro_Without_Invoice_Fee.     
--  111021  MoIflk   Bug 98911, Modified Modify_Invoice_Head___ to avoid changes in due date when having more than one installment plan
--  111001  NaLrlk   Bug 93036, Added the parameter company to function call Cust_Ord_Customer_API.Get_Default_Media_Code and changed the function call
--  111001           Customer_Info_Msg_Setup_API.Get_Address to Customer_Inv_Msg_Setup_API.Get_Address since the message class 'INVOIC' is used.
--  110914  HimRlk   Bug 98108, Modified Modify_Invoice_Head___ by changing the Exist check of invoice_addr_id_ to Customer_Info_Address_API.
--  110830  NWeelk   Bug 93145, Modified method Print_Invoices to allow creating rebate transactions to the CO correction invoices as well.
--  110802  MaEelk   Replaced the obsolete method calls Print_Server_SYS.Enumerate_Printer_Id and Print_Server_SYS.Get_Pdf_Printer
--  110802           with Logical_Printer_API.Enumerate_Printer_Id and Logical_Printer_API.Get_Pdf_Printer.
--  110725  KiSalk   Bug 97954, Modified Create_History_When_Printed___ to create history records for both printing and e-mailing.
--  110629  TiRalk   Bug 77713, Modified Print_Invoices procedure to execute the print job for twin print job to avoid displaying
--  110629           customer invoice in Status INACTIVE in Print Manager.
--  110629  PraWlk   Bug 77713, Changed logic when printing invoices to support archiving of invoice reports. Another twin print job will be created 
--  110629           that would use the pdf printer to archive the report if the archiving option is switched on from the print server. New print job 
--  110629           will be created in Print_Invoices and a new print job content will be created in Print_Invoice___.
--  110601  Mamalk   Bug 97340, Modified methods Get_Co_Inv_Gross_Total and Get_Co_Inv_Net_Total to take the sum of amounts.
--  110514  MaMalk   Modified the incorrect view comments in customer_order_inv_head_uiv.
--  110504  JeLise   Removed null column party from CUSTOMER_ORDER_INV_HEAD and CUSTOMER_ORDER_INV_HEAD_UIV.
--  110503  MaMalk   Modified Get_Company_Tax_Details___ to pass the branch correctly when the tax liability country doesn't contain a branch.
--  110419  MaMalk   Modified Get_Company_Tax_Details___ to  pass the company tax id correctly for a customer order invoice with charges only.
--  110414  JeLise   Added 'OR SUBSTR(c7,1,5) IS NULL' in where statement on view CUSTOMER_ORDER_INV_HEAD_UIV,
--  110414           to include credit invoices for rebate settlements.
--  110330  MaMalk   Modified method Get_Company_Tax_Details___ to fetch the company taxid for the supply country when no setting 
--  110330           found for the delivery country.
--  110314  MaMalk   Used RMA Line and Charge tables instead of the views to correct the upgrade error.
--  110308  MiKulk   Modified the method Modify_Tax_Details___ to fetch correct values for the shipment invoices,
--  110308           and RMA credit invoices.Also added the supply_country to Customer_Order_inv_Head view and Create_invoice_Head method
--  110131  Nekolk   EANE-3744  added where clause to View CUSTOMER_ORDER_INV_HEAD.
--  110127  MiKulk   Renamed the method Calc_And_Set_Max_Deliv_Date__ as Get_Max_Deliv_Date___,
--  110127           Added new methods.
--  100903  SudJlk   Bug 92792, Modified cursor get_advance_net_total in method Get_Co_Inv_Net_Total to take the sum of net_curr_amount.
--  100901  JeLise   Modified Print_Invoices, by updating the Rebate Net Amount/Base, Rebate Group, Rebate Assort ID and Node in the
--  100901           detailed statistics for invoiced sales, once an invoice get printed and once the rebate transactions get created.
--  100720  JuMalk   Bug 91871, Modified Modify_Invoice_Dates___ to replace null values for cor_inv_type_ and col_inv_type_ by adding NVL function.
--  100609  ChJalk   Bug 88819, Removed currency difference based condition to call Customer_Order_Inv_Item_API.Recalculate_Line_Amounts__ in Modify_Invoice_Dates___.
--  100713  ChFolk   Removed procedure Calculate_Bonus as bonus functionality is obsoleted.
--  100520  KRPELK   Merge Rose Method Documentation.
--  100603  RaKalk   Bug 91093, Modified Print_Invoices procedure to execute the print job if value in send_ variable is NULL or FALSE.
--  100311  SudJlk   Bug 81500, Added method Allow_Changes_To_Js_Inv.
--  100430  NuVelk   Merged Twin Peaks.
--  091028  KaEllk   Added Calculate_Prel_Revenue___. Modified Print_Invoices to call Calculate_Prel_Revenue___.
--  090514  Ersruk   Added new parameter project_id_ in Create_Invoice_Head().
--  090430  Ersruk   New column project_id added to view CUSTOMER_ORDER_INV_HEAD and added project_id in Create_Invoice_Head().
--  090930  MaMalk   Removed constant inst_OnAccountLedgerItem. Modified Create_Credit_Invoice_Hist___,Calculate_Bonus, Send_Invoices and Print_Invoice___ to remove unused code.
--  ------------------------- 14.0.0 -------------------------------------------
--  100311  ShKolk   Added shipment_id to Get().
--  091210  NiBalk   Bug 84902, Added text_id_co$ to CUSTOMER_ORDER_INV_HEAD view.
--  091005  NWeelk   Bug 86063, Removed function Get_Co_Net_Total and added functions Get_Co_Inv_Net_Total and Get_Co_Inv_Gross_Total.  
--  090901  Castse   Bug 84793, Modified the method Print_invoices to update the RMA lines with new correct invoice numbers when invoice is printed.
--  090824  PraWlk   Bug 84866, Added function Inv_Address_Exist to check whether a given customer address is used
--  090824           in cutomer invoice. Modified function Modify_Invoice_Head___ to raise an error when entering an 
--  090824           address with missing order attributes in a customer invoice.
--  090824  NaWilk   Bug 78948, Modified method Print_Invoices by adding an IF condition and removed some conditions added on 090728.
--  090806  MaMalk   Bug 84330, Made Delivery_Address_Id and Delivery_Indentity attributes public.
--  090728  NaLrlk   Bug 78948, Added new method Copy_Connected_Objects___. Modified the methods Create_Invoice_Head, Create_History_When_Printed___
--  090728           Send_Invoices and Print_Invoices to handle the E-INVOICE media code.
--  090728  ChJalk   Bug 83991, Modified method Print_Invoices to correctly select the report id when printing a prepayment credit invoice.
--  090713  MaMalk   Bug 83680, Modified method Modify_Invoice_Head___ and Print_Invoices to update invoice statistics correctly.
--  090504  ChJalk   Bug 81683, Added  attribute price_adjustment to the Method Get and changed Modify_Invoice_Head___ to update invoice_date of statistics records if it has been changed.
--  090422  AmPalk   Bug 80536, Modified method Print_Invoices, to pass the copy_no_ parameter as NULL to Print_Invoice___ method to avoid print mistake of ORGINAL label on the printout.
--  090203  MaMalk   Bug 74793, Modified Create_Invoice_Head to remove the setting of head_rec_.notes. Modified Fetch_Unknown_Head_Attributes to add HEADER_DOC_TEXT.             
--  090121  MalLlk   Bug 78783, Avoid specifying the length for wo_no_ and convert the value to NUMBER when assigning, in Create_Order_Appendix___.
--  080905  HaPulk   Bug 76499, Added condition in Print_Invoices to stop sending multiple invoices for the same invoice.
--  080905           Added Get_Previous_Execution___ to get previous 'Executing' background jobs
--  080724  ThAylk   Bug 68944, Modified method Modify_Invoice_Head___ to allow changes when jinsui status 'Transferred' in the customer invoice 
--  080724           and modified condition for raising error messages for Jinsui invoices.
--  080630  MaRalk   Bug 68628, Modified methods Create_Invoice_Head and Get. Added new function Get_Currency_Rate_Type.  
--  080623  ThAylk   Bug 73463, Modified the method Create_Invoice_Head to add invoice types customer order correction invoice and 
--  080623           customer order collective correction invoice to the if condition to set price_adjustment to TRUE.
--  081014  JeLise   Added currency_rate_type to Get.
--  080702  JeLise   Merged APP75 SP2.
--  ----------------------- APP75 SP2 merge - End ------------------------------
--  080508  ThAylk   Bug 71880, Modified the functions Get_Co_Gross_Total and Get_Co_Net_Total to fetch net amount and gross amount without invice fee.
--  080505  ThAylk   Bug 71995, Removed invoice_type CUSTORDCRE from the cursors in methods Get_Co_Gross_Total and Get_Co_Net_Total.
--  080430  ThAylk   Bug 71880, Added functions Get_Ad_Gro_Without_Invoice_Fee and Get_Ad_Net_Without_Invoice_Fee.
--  080430           Remove functions Get_Advance_Net_Total and Get_Advance_Gross_Total.
--  080407  NaLrlk   Bug 69626, Increased the length of your_reference column to 30 in CUSTOMER_ORDER_INV_HEAD.
--  ----------------------- APP75 SP2 merge - Start ----------------------------
--  080623  JeLise   Added invoice types 'CUSTORDCRE', 'CUSTCOLCRE' and 'SELFBILLCRE' to create rebate transactions for
--  080623           in Print_Invoices.
--  080616  AmPalk   Added method Get_Aggregation_No.
--  080604  JeLise   Added method Get_Final_Settlement.
--  080529  JeLise   Added final_settlement to the view and to Create_Invoice_Head.
--  080512  MiKulk   Modified the method Print_Invoices to get the correct debit invoice types to rebate transaction creation.
--  080512           Also modified the hardcoded invoice type for rebate credit invoice.
--  080502  AmPalk   Modified Public_Rec and Create_Invoice_Head by renaming rebate_settlement to aggregation_no
--  080502  MaHplk   Modified Print_Invoices to set the correct report view when printing rebate invoice.
--  080430  ShVese   Added rebate_settlement to Get method.
--- 080410  RiLase   Added rebate_settlement to Create_Invoice_Head.
--  080325  JeLise   Added delivery_identity in cursor get_invoice_data and in call to 
--  080325           Rebate_Transaction_Util_API.Create_Rebate_Transactions in Print_Invoices.
--  080311  RiLase   Merged APP75 SP1.
--  ----------------------------- APP75 SP1 merge - Start -----------------------------
--  080130  NaLrlk   Bug 70005, Added c12(del_terms_location) to the view, added new parameter del_terms_location_ to method Create_Invoice_Head and
--  080130           Modified the methods Fetch_Unknown_Head_Attributes, Modify_Invoice_Head___ for DEL_TERMS_LOCATION.
--  080121  MaJalk   Bug 69814, Modified Print_Invoices to give priority for messages and modified Create_History_When_Printed___.
--  080103  SuJalk   Bug 69892, Modifed the Get_Advance_Gross_Total and Get_Advance_Net_Total functions to return only the gross and net amounts for advance invoices.
--  080103           Also added the functions Get_Co_Net_Total and Get_Co_Gross_Total.
--  071231  MaJalk   Bug 69814, Modified Create_History_When_Printed___ to add email address to the messages and modified Print_Invoices.
--  071226  LaBolk   Bug 70016, Modified method Print_Invoices, to pass in the correct value for pay_term_id_ in call to Modify_Invoice_Dates___.
--  071224  MaRalk   Bug 64486, Modified methods Create_Invoice_Head and Modify_Invoice_Dates___ to handle the currency rate type correctly and 
--  071224           added C11 to the view CUSTOMER_ORDER_INV_HEAD.
--  071218  MaJalk   Bug 69814, Changed the method call Email_Order_Report to private in procedure Print_Invoices.
--  071213  MaJalk   Bug 69814, Modified procedure Print_Invoices to send email with attached pdf file.
--  071121  ChJalk   Bug 69174, Modified methods Print_Invoices and Create_Invoice_Head.
--  ----------------------------- APP75 SP1 merge - Start -----------------------------
--  080308  RiLase   Added if statement to check that rebate transactions isn't created for pre payment and advance invoices.
--  080226  RiLase   Moved Rebate_Transaction_Util_API.Create_Rebate_Transactions call to before Create_Postings call.
--  080225  JeLise   Added call to Rebate_Transaction_Util_API.Create_Rebate_Transactions and added 
--  080225           delivery_identity in cursor get_invoice_data in Print_Invoices.
--  ----------------------------- Nice Price -----------------------------
--  070913  AmPalk   Added columns net_dom_amount and vat_dom_amount to Customer_Order_Inv_Head.
--  070911  NuVelk   Bug 66972, Renamed function Get_Total_Discount as Get_Tot_Discount_For_Co_Line.
--  070907  Cpeilk   Call 148010, Changed the DEFAULT value to TRUE for parameter allow_credit_inv_fee_ in Create_Invoice_Complete.
--  070822  RaKalk   Removed Unwanted code from Fetch_Unknown_Head_Attributes function
--  070808  RaKalk   Bug 63323, Modified the method Fetch_Unknown_Head_Attributes to retrieve some additional attributes and made changes to create_invoice_head to handles notes.
--  070808  ChBalk   Bug 62609, Added extra parameter to Create_Invoice_Complete.
--  070604  ChJalk   Bug 64872, Modified Get_Invoice_No_By_Id() and  Get_Series_Id_By_Id() methods to fetch the data when invoice_id_ is not null.
--  070521  AmPalk   Modified Create_History_When_Printed___ to filter out the credited line(s) of a correction invoice when inserting the history, to avoid duplications.
--  070512  SenSlk   LCS Merge 60464, Modified PROCEDURE Print_Invoices not to send EDI message for SELFBILLDEB invoices.
--  070309  ChBalk   Checked for prepayment invoices when raise error for invalid payment terms in Modify_Invoice_Dates___.
--  070308  MiKulk   Bug 61080, Bug 61080, Modified the procedure Create_Postings to transfer preposting for advace invoices.
--  070214  ChBalk   Added new method Send_Invoices.
--  070109  RaKalk   Bug 58375, Added function call to get invoice no and changed Invoice id to Invoice No in error message PRINTERROR
--  070109           and added new error message CANNOTPRINT and a condition to check the invoice state at method Print_Invoices.
--  061219  RoJalk   Moved the method Remove_Invoice to InvoiceCustomerOrder.
--  061208  MiKulk   Modified the method Modify_Invoice_Dates___ to raise errors for invalid payment terms.
--  061208           Also modified the Remove_Invoice_ to consider the invoicing customer of the customer order.
--  061126  NaWilk   Modified method Print_Invoices to print CUST_ORDER_PREPAYM_INVOICE_REP.
--  061124  NaLrlk   Bug 60780, Added new method Check_Advance_Inv_Exist__.
--  061122  NaLrlk   Added function Get_Taxes_With_No_Liab_Date.
--  061121  Cpeilk   Added PRINT_OPTION to attr only when print_option_ equals to OFFSET in method Print_Invoices.
--  061117  KaDilk   Rename and modify the method Remove_Credit_Invoice as Remove_Invoice.
--  061108  Cpeilk   DIPL606A, Added attributes ledger_item_id, ledger_item_series_id and ledger_item_version_id to method Create_Invoice_Head
--  061108           and view CUSTOMER_ORDER_INV_HEAD. Removed hard coded correction invoice types.
--  061023  MaJalk   Added function Check_Corr_Inv_Tax_Lines.
--  061017  MaJalk   Added function Check_Manual_Tax_Liab_Exist.
--  060908  MarSlk   Bug 59642, Modified method Calculate_Bonus to use next_line_.net_dom_amount
--  060908           instead of bonus_basis_calc_ in the calculation for Bonus Value.
--  060825  MiKulk   Corrected to message constants used when creating invoice history records to remove the duplicates.
--  060822  MiKulk   Modified the method Create_History_When_Printed to add more details to the history when invoice sent.
--  060821  MiKulk   Modified the methods Create_Invoice_Complete, Create_Credit_Invoice_History__, Create_History_When_Printed and
--  060821           Print_Invoices to add the history records in Cust_Order_Invoice_Hist_Tab.
--  060727  MalLlk   Modified methods Modify_Invoice_Dates___ and Print_Invoices in order allow the print date correctly when printing the invoice.
--  060727           Added new parameter print_invoice_ to Modify_Invoice_Dates___.
--  060718  NuFilk   Bug 58182, Added new method Calculate_Bonus to be called from bonus report.
--  060714  ChJalk   Added head_rec_.creation_date  := site_date_ in Create_Invoice_Head.
--  060616  ChJalk   Added parameter series_id to the method Get_Invoice_Id_By_No.
--  060607  Samnlk   Bug 58065, Added the use_ref_inv_curr_rate to the view Customer_Order_Inv_Head and added it as a parameter to Create_Invoice_Head.
--  060607  PrPrlk   Bug 58492, Made changes to the method Create_Invoice_Head to handle invoice type SELFBILLCRE.
--  060606  KaDilk   Modified methos Calc_And_Set_Max_Deliv_Date__.
--  060606  MaMalk   Modified Remove_Credit_Invoice to handle the RMA lines and charges separately when removing the credit/correction invoice.
--  060602  MiKulk   Added the use_ref_inv_curr_rate to the view Customer_Order_Inv_Head and added it as a parameter to
--  060602           Create_Invoice_Head. Added a new implementation method as Modify_Invoice_Dates___ and
--  060602           call it from Modify_Invoice_Head___ also deleted the method Set_Print_Date___.
--  060602           Also removed the unwatned paramteres from the Create_Invoice_Head.
--  060530  Samnlk   Bug 58065, Modified the Modify_Invoice_Head__to retrive the currency rate based on the changed invoice date.
--  060523  MiKulk   Modified the Modify_Invoice_Head__to retrive the currency rate based on the changed invoice date.
--  060522  PrPrlk   Bug 54753, Removed the join between CUSTOMER_ORDER_INV_ITEM and CUSTOMER_ORDER_INV_HEAD in Function Get_Total_Discount and modified the method Remove_Credit_Invoice.
--  060522  ChJalk   Added the procedure Calc_And_Set_Max_Deliv_Date__. Modified the view Customer_Order_Inv_Head to add
--  060522           latest_delivery_date and column d3 from CUST_INVOICE_PUB_UTIL_HEAD was aliased as wanted_delivery_date.
--  060522           Modified the methods Create_Invoice_Head, Modify_Invoice_Head___ and Create_Invoice_Complete.
--  060519  ChBalk   Made tax_curr_rate public to get a public method.
--  060510  JaBalk   Modified Create_History_When_Printed___ to include history for corr inv.
--  060504  JaBalk   Modified Remove_Credit_Invoice to clear the CR details from RMA.
--  060503  PrKolk   Bug 55807, Added the parameter series_id to the method Get_Invoice_Id_By_No and removed the
--  060503           method Check_Credit_Invoices.
--  060428  JaBalk   Added Get_Rma_No method and attribute rma_no to public_rec.
--  060426  JaBalk   Set the report_id_ for correction invoices in Print_Invoices method.
--  060425  MaJalk   Bug 56651, Modified the method Cancel_Credit_Invoice to write a record to the Customer Order history
--  060425           when the connected Credit Invoice is cancelled.
--  060421  MaMalk   Added correction_invoice_id to Customer_Order_Inv_Head. Added method Get_Correction_Invoice_Id. Modified method Get to handle the correction_invoice_id.
--  060421  MaMalk   Removed methods Create_Credit_Invoice, Create_Credit_Invoice_Head, Check_Credit_Invoices and Unpack_Credit_Invoice.
--  060421           Renamed Cancel_Credit_Invoice to Remove_Credit_Invoice and modified this method to handle correction invoices.
--  060421           Added parameter ref_invoice_id_ to Create_Credit_Invoice_Hist. Removed parameter collective_, renamed parameter deb_invoice_id_
--  060421           to ref_invoice_id_ in Create_Credit_Invoice_Hist___and modified this method to handle the creation of order history for correction invoices.
--  060421  JaBalk   Removed unnecessary parameters party_type_,party_ from Get_Invoice_Type.
--  060421           Removed unwanted method Get_Invoice_Date with parameters party_type_,party_.
--  060420  RoJalk   Enlarge Customer - Changed variable definitions.
--  060419  NuFilk   Bug 57134, Removed the sustrb of label note in order to display the whole label note value from the client.
--  ------------------------- 13.4.0 -------------------------------------------
--  060307  SaRalk   Modified the procedure Create_Postings.
--  060207  CsAmlk   Changed Paying Customer as Invoicing Customer in View comments.
--  060125  JaJalk   Added Assert safe annotation.
--  060111  ChJalk   Bug 54699, Added Price_Adjustment in to the view CUSTOMER_ORDER_INV_HEAD and Modified Procedure Create_Invoice_Head
--  060111           to set the flag Price_Adjustment when creating the invoice head.
--  060109  SeNslk   Added new public method Get_Invoice_Status.
--  060103  LaBolk   Bug 55333, Modified Create_Postings to correct erroneous where clauses in cursors.
--  051229  RaNhlk   Bug 54928, Modified set_Print_date() to calculate due date and removed unnecessary coding.
--  051212  UsRalk   Modified CUSTOMER_ORDER_INV_HEAD to fetch sb_reference_no from invoice module.
--  051205  UsRalk   Modified Create_Credit_Invoice_Head to enable create credit invoice for invoice type SELFBILLDEB.
--  051122  IsAnlk   Modified Print_Invoices to avoid an error raised when send invoices.
--  051102  UsRalk   Added new method Check_Unpaid_Advance_Inv_Exist.
--  051012  KeFelk   Added Site_Discom_Info_API in some places for Site_API.
--  050916  ChJalk   Bug 50514, Added Functions Get_Net_Curr_Amount and Get_Vat_Curr_Amount. Added net_curr_amount
--  050916           and vat_curr_amount into the VIEW CUSTOMER_ORDER_INV_HEAD and Get Method.
--  050106  IsAnlk   Added function Get_Series_Reference__.
--  050926  IsAnlk   Modified Create_Invoice_Head to fetch currency rate from Invoice_Library_API.Get_Currency_Rate_Defaults.
--  050922  NaLrlk   Removed unused variables.
--  050815  RaSilk   Modifed Modify_Invoice_Head___ to restrict updating Jinsui Invoices not in state OJS.
--  050716  RaSilk   Set length of attribute js_invoice_state to 200 in CUSTOMER_ORDER_INV_HEAD.
--  050715  IsAnlk   Modified Print_Invoices to update invoice_id series_id in self_billing_item_tab.
--  050714  RaKalk   Modified Print_Invoices to fetch sbi_no from SELF_BILLING_ITEM_TAB
--  050705  RaSilk   Added parameter js_invoice_state_db_ Create_Invoice_Head and where used.
--  050426  JOHESE   Made attribute pay_term_id public
--  050412  JoEd     Added call in Print_Invoices to set sales posted date on the
--                   outstanding sales records connected to an invoice.
--  050204  AsJalk   FITH351, Modified method Create_Invoice_Head.
--  050118  reanpl   FITH351, Printing Tax Invoice added to Print_Invoices procedure
--  050110  Samnlk   Modify procedure Create_Credit_Invoice_Head, added Null parameter to the calling of procedure Create_Invoice_Head.
--  041201  IsAnlk   Modified Print_invoices() to send more than one invoices.
--  041122  MaGuse   Bug 46197, Set the recalculation flag for associated commissions when
--  041122           creating credit invoice. Modified method Create_Credit_Invoice_Head.
--  041013  JaJalk   Added the default null parameter sb_reference_no_ Create_Invoice_Head.
--  040817  DhWilk   Inserted General_SYS.Init_Method to Print_Job_Exists
--  040518  LaBolk   Modified the call to ACTIVE_WORK_ORDER1_API as ACTIVE_WORK_ORDER_API in Create_Order_Appendix___.
--  040511  UdGnlk   Bug 41757, Modified Create_Credit_Invoice_Head, Create_History_When_Printed___ in order to handle new
--  040511           collective invoice type CUSTCOLCRE.
--  040423  VeMolk   Bug 44152, Modified the procedure Create_Order_Appendix___.
--  040415  MiKalk   Bug 42707, Added new function Get_Fin_Curr_Rate. Modified method signature and the method body of the methods Create_Invoice_Head,
--  040415           Unpack_Credit_Invoice, Create_Credit_Invoice and Create_Credit_Invoice_Head. Modified Function Get. Modified view CUSTOMER_ORDER_INV_HEAD.
--  ----------------------------TouchDown Merge End-------------------------------
--  040331  IsAnlk   B113437 - Create history line when credit invoice is cancelled in Cancel_Credit_Invoice.
--  040315  HeWelk   B113188-Modified Get_Advance_Gross_Total and Get_Advance_Net_Total.
--  040303  ISAnlk   B112888 - History line created for advence credit invoices in Create_Credit_Invoice_Hist___.
--  040225  AjShlk   Performed code review
--  040216  AjShlk   Modified the method CreateInvoiceHead() to display invoice address, our ref and cust ref.
--  040212  AjShlk   Modified Create_Credit_Invoice_Head to create advance credit invoices
--  040210  GaSolk   Modified Proc: Print_Invoices in order to print the Advance Invoice
--                   report via the Print Server.
--  040210  HeWelk   Added Get_Advance_Gross_Total() and Get_Advance_Net_Total() functions
--  040202  AjShlk   Added attribute advance_invoice to the main view
--  040130  AjShlk   Added two new parameters to CreateInvoiceHead() to handle Adv Invoices.
--  ----------------------------TouchDown Merge Begin------------------------------
--  040220  IsWilk   Removed the SUBSTRB and modified the SUBSTR for Unicode Changes.
--  040211  UdGnlk   Bug 38390, Modified the Method Print_Invoices__ to handle the printing of an 'invoice batch' with an erroneous,
--  040211           invoice the process will print all the invoices other than the onces with errors.Added the Function Print_Job_Exists().
--  ********************* VSHSB Merge End*****************************
--  021120  GEKALK   Modified Print_Invoices to avoid ORA Error when printing invoices for "Normal" parts.
--  020613  GEKALK   Modified Print_Invoices to update the Self_Billing_Header_tab with
--                   invoice_no and series_id.
--  020521  GEPELK   SelfBilling VAP
--  020429  MaGu     Added handling of shipment_id_ in method Create_Invoice_Head.
--                   Added shipment_id in view CUSTOMER_ORDER_INV_HEAD.
--  ********************* VSHSB Merge Start*****************************
--  040127  GeKalk   Rewrote the DBMS_SQL to Native dynamic SQL for UNICODE modifications.
--  031104  GaJalk   Merged bug 39315. Remove the dynamic call to method NCF_INVOICE_UTIL_API.Ncf_Get_Reference.
--  031029  LaBolk   Bug Fix 109358, Modified method Create_Order_Appendix___ to check if a complex agreement is given in the work order,
--  031029           and if so print the MRO Invoice Specification.
--  031008  PrJalk   Bug Fix 106224, Changed and Added missing/incorrect General_Sys.Init_Method calls.
--  030918  SuAmlk   Modified PROCEDURE Set_Print_Date___ to exclude the time stamp of pay_term_base_date when comparing.
--  030918  IsWilk   Bug 38160, Modified the PROCEDURE Fetch_Unknown_Head_Attributes to add the customer_company to the attribute string.
--  030904  SuAmlk   Modified PROCEDURE Set_Print_Date___ to update the invoice date and pay term base date to print date when
--                   the invoice is printed and removed code added in the PROCEDURE Print_Invoices for handling this.
--  030729  GaJalk   Performed SP4 Merge.
--  030708  ChFolk   Reversed the changes that have been done for Advance Payment.
--  030625  SuAmlk   Modified PROCEDURE Print_Invoices to update the pay term base date to print date.
--  030428  LoKrLK   IID DEFI162N Added parameter value for Payment_Term_Details_API.Get_Days_To_Due_Date call
--  030421  ChIwlk   Added pay_term_base_date to View customer_order_inv_head.Changed functions Create_Invoice_head
--                   and Modify_Invoice_Head___ to get and handle pay term base date.
--  030408  PrJalk   Bug 36506, Changed Print_Invoices, to pass head_attr to Customer_Invoice_Pub_Util_API.Create_Vouchers.
--  030327  SuAmlk   Removed FUNCTION Get_No_Invoice_Copies and changed the position of FOR LOOP in PROCEDURE Print_Invoices.
--  030320  SuAmlk   Added new FUNCTION Get_No_Invoice_Copies, new IN parameter copy_no_ to the PROCEDURE Print_Invoice___ and
--                   made modifications to the PROCEDURE Print_Invoices to handle printing of multiple invoice copies.
--  030310  ThJalk   Bug 33773, Added an IF condition to check print type in method Print_Invoices.
--  030220  PrJalk   Modified Set_Print_Date___  to adhere with IFS Standards.
--  030203  PrJalk   Added missing column comment for print_date.
--  030131  AjShlk   performed code review.
--  030129  PrJalk   Changed function Set_Print_Date___to update the due date
--  030129  PrJalk   Added function Set_Print_Date___ Added a call to that function in
--                   Print_Invoices()
--  030116  PrJalk   Added branch to View customer_order_inv_head and to headrec_ in function Create_Invoice_head.
--  020819  NuFilk   Bug 26254, Modified procedure Create_Credit_Invoice_Hist.
--  020619  WaJalk   Bug 31013, Added Get_Identity.
--  020514  ROAL     Bug fix 30081, Create_Postings dummy_ variable length changed to 100
--  020313  KiSalk   Bug fix 27058, Added objstate to select list of cursor get_attr in function Get.
--  020308  NuFilk   Bug fix 26254, (Call 74376), Added procedure Create_Credit_Invoice_Hist
--  020213  ISAn     IID 10018 Reference No In External Interface. Added Function Get_ncf_reference_no. Removed view CUSTOMER_ORDER_INV_HEAD_REF.
--  020205  THAJLK   Added new view CUSTOMER_ORDER_INV_HEAD_REF.
--  010921  JoAn     Bug fix 24185. Added Get_Invoice_Id_By_No
--  010913  JoEd     Bug fix 21382. Added "COMPANY > ' '" and "COMPANY = company_"
--                   to cursors already using invoice_id in the where clause.
--  010704  IsWilk   Bug Fix 21433, Added the condition for checking the order line exist
--                   to the modification the bug 21433.
--  010629  IsWilk   Bug Fix 22847, Modified the PROCEDURE Modify_Invoice_Head___ to update the due_date when changing the invoice_date.
--  010531  IsWilk   Bug Fix 21433,Modified the PROCEDURE Create_History_When_Printed___ for adding the information to Customer Order Line History.
--  010509  ChAm     Bug Fix 20385,Added procedures:Check_Credit_Invoices,Cancel_Credit_Invoice.
--  010416  DaJolk   Bug fix 20332, Added check in Modify_Invoice_Head___ to check whether 'forward_agent_id' exists.
--  010413  JaBa     Bug Fix 20598,Added new global lu constant inst_WorkOrderCodingUtil_.
--  001215  JoEd     Added null value check on send_and_print value if not
--                   included in attribute string in proc. Print_Invoices.
--  000913  FBen     Added UNDEFINE.
--  --------------------------- 13.0 ----------------------------------------
--  000529  DaZa     Added event call in Create_History_When_Printed___.
--  000425  PaLj     Changed check for installed logical units. A check is made when API is instantiatet.
--                   See beginning of api-file.
--  000419  PaLj     Corrected Init_Method Errors
--  000306  JoEd     Added method Get.
--  000303  JoEd     Changed length for series_reference.
--  000225  DaZa     Changed series_id length to 20.
--  000218  JoAn     Changed calls to Customer_Invoice_Info_Pub_Util (now all procedures)
--  000218  JeLise   Added creation_date in view CUSTOMER_ORDER_INV_HEAD.
--  000217  JoAn     Using new interface Customer_Invoice_Info_Pub_Util on modify
--  000216  JoAn     Set party to NULL in the view. The column should be removed,
--                   but is still used in a number of client forms.
--  000215  JeLise   Added check on invoice_date_ and pay_term_id_ in Modify_Invoice_Head___.
--  000204  JakH     Create_History_When_Printed___ modified for RMA's
--  000201  JoAn     Using party_type_db instead of party_type in VIEW.
--  000131  JoAn     The view in this LU is now based on CUST_INVOICE_PUB_UTIL_HEAD
--                   Party retrieved from Customer_Info_API for now, but should be removed.
--                   Removed party and party_type from Get_XXX method cursors.
--  000126  JoAn     Moved call to Create_Vouchers from Create_Postings to Print_Invoices
--  000126  JakH     Added RMA_NO to view.
--  000120  JoAn     Added new parameter rma_no_ to Create_Invoice_Head
--                   Removed parameter pre_accounting_id in Create_Invoice_Head.
--  000112  JoAn     Final invoice id retrieved in Print_Invoices
--                   Changed calls to Customer_Invoice_Pub_Util_API (methods instead of functions).
--  000111  JoAn     Added Get_Currency.
--  000105  JoAn     Rewrote the methods used when printing invoices to comply
--                   with the new interface.
--                   Printout of invoice now handled in ORDER.
--                   Postings passed to INVOICE when printing.
--                   Invoice appendixes should now come in the right order when
--                   more than one invoice is printed.
--  991123  JoEd     Added contract and currency code in attribute string in
--                   Fetch_Unknown_Head_Attributes.
--                   Changed column comments on party and party_type.
--  --------------------------- 12.0 ----------------------------------------
--  991112  JoAn     Call Id 27839 Currency rate for currencies with inverted rate.
--                   Changed Create_Invoice_Head, currency rate used
--                   in Customer Orders stored in columns n1.
--                   The column n1 is mapped to curr_rate in the view.
--  991111  JoEd     Changed datatype length on company's view comment.
--  991011  JakH     Bug fix 11736 , Added an error message to avoid the error which
--                   appears when going to change printed/posted-Authorized invoices.
--  991007  JoEd     Replaced Utility_SYS.Get_User with Fnd_Session_API.Get_Fnd_User.
--  991007  JoEd     Call Id 21210: Corrected double-byte problems.
--  --------------------------- 11.1 ----------------------------------------
--  990615  JakH     Added checks for empty printjob when sending invoices without appendices
--  990614  JoAn     Call Id 19147 Added PROJECT_ACTIVITY_ID to attribute string
--                   passed when creating invoice head.
--  990611  JoEd     Call id 19810: Added send of invoices in Print_Invoices.
--                   Added history for sent invoice.
--  990517  JoAn     Added new methods Get_Invoice_No_By_Id and Get_Series_Id_By_Id.
--  990415  RaKu     Removed obsolete functions Get_Instance___ and Get_Record___.
--                   Minor cleanup of LU.
--  990412  JoEd     Y.Call id 14004: Added column c7 as contract to view and use
--                   that on invoice header. Added contract to Create_Invoice_Head.
--  990330  JakH     CID 14600 Added retrieval of div-factor from the view.
--  990219  JoAn     Changed retrieval of current date/time in Create_Invoice_Head
--                   the value was NULL when creating collective invoice.
--  990208  JakH     CID 8035, Added mapping against new invoice columns in
--                   Modify_Invoice_Head___, changed the view CUSTOMER_ORDER_INV_HEAD
--                   to use new invoice columns instead of HEAD_DATA column.
--  990202  JoAn     CID 5058 Added PRINT_JOB_ID to flag_attr_ in Print_Invoices
--  990128  JoAn     Changed order of parameters in Fetch_Unknown_Head_Attributes.
--  990126  JoAn     Added Fetch_Unknown_Head_Attributes.
--  990118  PaLj     changed sysdate to Site_API.Get_Site_Date(contract)
--  981208  JoEd     Changed comments for the amount columns.
--  980417  JoAn     SID 3882 Added check for pay terms in Create_Invoice_Head
--  980416  JoAn     SID 1659 New methods Create_Credit_Invoice_Hist___
--                   and Create_History_When_Printed___.
--                   History records created when invoice is printed.
--  980409  JoAn     SID 1659 Clenup of history record generation.
--                   Added invoice id to history messages.
--  980320  JoAn     Support Id 1872 Invoice apendixes not created unless customer
--                   has collective invoice. Corrected in Print_Invoices.
--                   Also corrected dynamic call in Create_Order_Appendix___.
--  980304  JoAn     Added print job creation and printing to Print_Invoices.
--                   Cleaned up the creation of credit invoices, removed
--                   all COMMIT:s made in the server and replaced Batch_Result
--                   logging with call to Transaction_SYS.Set_Status_Info
--                   Added creation of invoice appendixes from work order.
--  980226  DaZa     Changed forward_agent to forward_agent_id.
--  971120  RaKu     Changed to FND200 Templates.
--  971001  JoAn     Added logging of errors in Print_Invoices
--  970606  RaKu     Added parameter company_ in Create_Invoice_Head.
--  970514  JoEd     Added function Get_Curr_Rate, Get_Invoice_Date and
--                   Get_Invoice_Type.
--  970508  JoAn     Changes due to Finance8.1 integration
--  970417  JoEd     Removed objstate from Customer_Order_History_API.New.
--  970416  JoEd     Changed call to Customer_Order_History_API.
--  970408  ASBE     BUG 97-0048 Not possible to print invoice if swedish
--                   translation. Changed client_state to objstate.
--  970402  JoEd     BUG 97-0006. Delivery address has no value on the invoice
--                   because of wrong column name in attr_ variable.
--  970311  ASBE     BUG 97-0042 Invoice not created for order with pre posting
--                   due to incorrect string length in call to Pre_Accounting_API
--                   in procedure Create_Invoice_Head.
--  960913  RAKU     Created

-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

-- gelr:prepayment_tax_document, added prepay_adv_inv_id
TYPE Public_Rec IS RECORD
   (customer_no            VARCHAR2(200),
    invoice_type           VARCHAR2(20),
    currency_code          VARCHAR2(3),
    contract               VARCHAR2(5),
    curr_rate              NUMBER,
    div_factor             NUMBER,
    series_id              VARCHAR2(20),
    invoice_no             VARCHAR2(50),
    invoice_date           DATE,
    objstate               VARCHAR2(30),
    fin_curr_rate          NUMBER,
    pay_term_id            VARCHAR2(30),
    net_curr_amount        NUMBER,
    vat_curr_amount        NUMBER,
    correction_invoice_id  NUMBER,
    rma_no                 NUMBER,
    tax_curr_rate          NUMBER,
    aggregation_no         NUMBER,
    final_settlement       VARCHAR2(5),
    currency_rate_type     VARCHAR2(10),
    price_adjustment       VARCHAR2(5),
    delivery_address_id    VARCHAR2(50),
    invoice_address_id     VARCHAR2(50),
    delivery_identity      VARCHAR2(200),
    shipment_id            NUMBER,
    tax_id_number          VARCHAR2(50),
    tax_id_type            VARCHAR2(10),
    branch                 VARCHAR2(20),
    supply_country         VARCHAR2(2),
    use_price_incl_tax     VARCHAR2(5),
    advance_invoice        VARCHAR2(5),
    use_ref_inv_curr_rate  VARCHAR2(5),
    number_reference       VARCHAR2(50),
    series_reference       VARCHAR2(20),
    component_a            VARCHAR2(50),
    serial_number          VARCHAR2(50),
    creators_reference     VARCHAR2(100),    
    prepay_adv_inv_id      NUMBER);

-------------------- PRIVATE DECLARATIONS -----------------------------------

pc_tax_round_item_start_           CONSTANT NUMBER        := 100100;
pc_rounding_diff_start_            CONSTANT NUMBER        := 500000;
pc_fee_item_id_                    CONSTANT NUMBER        := 100000;
pc_rounding_item_id_               CONSTANT NUMBER        := 100001;
pc_corr_fee_item_id_               CONSTANT NUMBER        := 99998;
pc_corr_rounding_item_id_          CONSTANT NUMBER        := 99999;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- gelr:e-invoicing_compliance, begin
@IgnoreUnitTest DMLOperation
FUNCTION Set_Warning_Status___ (
   invoice_id_ IN NUMBER,
   sqlerm_     IN VARCHAR2 ) RETURN BOOLEAN
IS
   error_info_ VARCHAR2(2000);
   invoice_no_ customer_order_inv_head.invoice_no%TYPE;
BEGIN
   invoice_no_ := Get_Invoice_No_By_Id(invoice_id_);
   error_info_ := Language_SYS.Translate_Constant(lu_name_, 'PRINTERROR: Printing Invoice No :P1 cannot be processed. :P2', NULL, invoice_no_ , sqlerm_);
   IF (Transaction_SYS.Is_Session_Deferred()) THEN
      Transaction_SYS.Set_Status_Info(error_info_, 'WARNING');
      RETURN TRUE;
   END IF;
   RETURN FALSE;
END Set_Warning_Status___;
-- gelr:e-invoicing_compliance, end


PROCEDURE Write_To_Ext_Tax_Reg___(
   company_             IN VARCHAR2,
   invoice_id_          IN NUMBER,
   corr_credit_invoice_ IN  BOOLEAN)
IS
   CURSOR get_co_inv_item IS
      SELECT item_id, prel_update_allowed
      FROM   customer_order_inv_item
      WHERE  invoice_id = invoice_id_
      AND    company    = company_; 
   
   inv_rec_                 Invoice_API.Public_Rec;
   external_tax_cal_method_ VARCHAR2(50);
   xml_trans_               CLOB;
BEGIN
   inv_rec_ := Invoice_API.Get(company_, invoice_id_);
   
   external_tax_cal_method_ := Company_Tax_Control_API.Get_External_Tax_Cal_Method_Db(company_);
   IF (external_tax_cal_method_ = 'AVALARA_SALES_TAX') THEN
      Avalara_Tax_Util_API.Write_To_Ext_Avalara_Tax_Regis(xml_trans_, company_, invoice_id_, inv_rec_.invoice_no, inv_rec_.series_id, inv_rec_.invoice_date, corr_credit_invoice_);
      Tax_Handling_Order_Util_API.Write_To_Ext_Avalara_Tax_Regis(company_, invoice_id_, xml_trans_);
   ELSE
      FOR inv_item_rec_ IN get_co_inv_item LOOP      
         Tax_Handling_Order_Util_API.Write_To_Ext_Tax_Register(company_, invoice_id_,inv_item_rec_.item_id, add_tax_lines_ => inv_item_rec_.prel_update_allowed);
         
         IF inv_item_rec_.prel_update_allowed = 'TRUE' THEN 
            Invoice_Item_API.Modify_Line_Level_Tax_Info(company_, 'NET_BASE', inv_rec_.creator, NULL, invoice_id_, inv_item_rec_.item_id);      
         END IF;
      END LOOP;           
   END IF;
END Write_To_Ext_Tax_Reg___;

-- Modify_Invoice_Dates___
--   Recalculate the currency rate, tax rates when the invoice date is changed.
--   And modify the invoice date_, pay term base date, due_date_, print_Date
PROCEDURE Modify_Invoice_Dates___ (
   date_changed_        OUT BOOLEAN,
   company_             IN VARCHAR2,
   invoice_id_          IN NUMBER,
   invoice_date_        IN DATE,
   pay_term_base_date_  IN DATE,
   print_date_          IN DATE,
   pay_term_id_         IN VARCHAR2,
   delivery_date_       IN DATE,
   print_invoice_       IN BOOLEAN DEFAULT FALSE,
   fetch_del_date_rate_ IN BOOLEAN DEFAULT FALSE)
IS
   lu_rec_                      CUSTOMER_ORDER_INV_HEAD%ROWTYPE;
   currency_rate_               NUMBER;
   conv_factor_                 NUMBER;
   tax_curr_rate_               NUMBER;
   fin_curr_rate_               NUMBER;
   base_currency_code_          VARCHAR2(3);
   inverted_                    VARCHAR2(5);
   currency_type_               VARCHAR2(10);
   newattr_                     VARCHAR2(2000);
   pay_term_desc_               VARCHAR2(2000);
   due_date_                    DATE;
   temp_pay_term_base_date_     DATE;
   proceed_allowed_             BOOLEAN := TRUE;
   cor_inv_type_                VARCHAR2(20);
   col_inv_type_                VARCHAR2(20);
   prepay_deb_inv_type_         VARCHAR2(20);
   prepay_cre_inv_type_         VARCHAR2(20);
   new_currency_rate_retrieved_ BOOLEAN := FALSE;
   parallel_curr_rate_          NUMBER;                       
   parallel_conv_factor_        NUMBER;          
   parallel_inverted_           VARCHAR2(5);
   compfin_rec_                 Company_Finance_API.Public_Rec;
   tax_curr_rate_type_          VARCHAR2(10);
   curr_rate_base_              VARCHAR2(20);
   curr_rate_base_date_         DATE;
   date_modified_               BOOLEAN := FALSE;
   
   CURSOR getrec IS
      SELECT *
        FROM CUSTOMER_ORDER_INV_HEAD
       WHERE company = company_
         AND invoice_id = invoice_id_;

   CURSOR get_items (company_ IN VARCHAR2, invoice_id_ IN NUMBER) IS
      SELECT item_id
        FROM customer_order_inv_item
       WHERE company = company_
         AND invoice_id = invoice_id_;
BEGIN
   prepay_deb_inv_type_ := Company_Def_Invoice_Type_API.Get_Def_Co_Prepay_Deb_Inv_Type(company_);
   prepay_cre_inv_type_ := Company_Def_Invoice_Type_API.get_Def_Co_Prepay_Cre_Inv_Type(company_);
   IF (print_invoice_)THEN      
      IF (company_Invoice_Info_API.Get_Numb_Cust_Inv_Date_Order(company_) != 'TRUE')THEN
         proceed_allowed_ := FALSE;         
      END IF;
   END IF;

   Client_SYS.Add_To_Attr('COMPANY', company_, newattr_);
   Client_SYS.Add_To_Attr('INVOICE_ID', invoice_id_, newattr_);
   Client_SYS.Add_To_Attr('D2', print_date_,newattr_);
   date_changed_ := proceed_allowed_;

   IF (proceed_allowed_) THEN      
      OPEN getrec;
      FETCH getrec INTO lu_rec_;
      CLOSE getrec;

      Client_SYS.Add_To_Attr('INVOICE_DATE', NVL(invoice_date_, lu_rec_.invoice_date), newattr_);

      temp_pay_term_base_date_ := NVL(pay_term_base_date_, lu_rec_.pay_term_base_date);

      -- If the invoice date is changed and pay term base date is not changed
      -- then we should change the payterm base date if earlier also it was decided by the invoice date
      IF ((lu_rec_.invoice_date != invoice_date_) AND  (lu_rec_.pay_term_base_date = temp_pay_term_base_date_)) THEN
         IF (lu_rec_.invoice_date = TRUNC(lu_rec_.pay_term_base_date)) THEN
            temp_pay_term_base_date_ := invoice_date_;
         END IF;
      END IF;

      -- If payterm id is changed, set the correct pay term description also
      IF (lu_rec_.pay_term_id != pay_term_id_) THEN
         pay_term_desc_ := Payment_Term_API.Get_Description(lu_rec_.company, pay_term_id_);
         Client_SYS.Add_To_Attr('PAY_TERM_ID', pay_term_id_, newattr_);
         Client_SYS.Add_To_Attr('PAY_TERM_DESCRIPTION', pay_term_desc_, newattr_);
         IF (lu_rec_.invoice_type IN (prepay_deb_inv_type_, prepay_cre_inv_type_)) THEN
            IF Payment_Term_Details_API.Get_Installment_Count(company_, pay_term_id_) != 1 THEN
               --Raise an error if multiple installments are connectedto the payment term
               Error_SYS.Record_General(lu_name_,'MANYINST: Payment Term with many instllments can not be used for a prepayment based invoice.');
            ELSE
               IF Payment_Term_Details_API.Get_Discount_Specified(company_, pay_term_id_, 1 ,1) ='TRUE' THEN
                  -- Raise an error if discosunts are specified for the payment term's installations.
                  Error_SYS.Record_General(lu_name_,'PAYTERMDISC: Payment Term with discounts can not be used for a prepayment based invoice.');
               END IF;
            END IF;
         END IF;
      END IF;

      IF ((lu_rec_.pay_term_base_date != temp_pay_term_base_date_) OR (lu_rec_.pay_term_id != pay_term_id_)) THEN
         -- re calculate the due date based on the changed payterm_id or pay_term_base_date_
         Invoice_API.Get_Unblocked_Due_Date(due_date_ , lu_rec_.company, lu_rec_.identity, 'CUSTOMER', pay_term_id_, temp_pay_term_base_date_);
      ELSE
         due_date_ := lu_rec_.due_date;
      END IF;

      -- Set the print date
      Client_SYS.Add_To_Attr('D2', print_date_,newattr_);
      Client_SYS.Add_To_Attr('DUE_DATE', due_date_, newattr_);
      Client_SYS.Add_To_Attr('PAY_TERM_BASE_DATE', temp_pay_term_base_date_, newattr_);

      cor_inv_type_   := Company_Def_Invoice_Type_API.Get_Def_Co_Cor_Inv_Type(company_);
      col_inv_type_   := Company_Def_Invoice_Type_API.Get_Def_Col_Cor_Inv_Type(company_);
      curr_rate_base_ := Company_Invoice_Info_API.Get_Out_Inv_Curr_Rate_Base_Db(company_);
      
      -- gelr:out_inv_curr_rate_voucher_date, begin
      IF (Company_Localization_Info_API.Get_Parameter_Value_Db(company_, 'OUT_INV_CURR_RATE_VOUCHER_DATE') = Fnd_Boolean_API.DB_TRUE) THEN
         curr_rate_base_ := Invoice_API.Get_Out_Inv_Curr_Rate_Base_Db(company_, invoice_id_);
      END IF;
      -- gelr:out_inv_curr_rate_voucher_date, end      
      IF (curr_rate_base_ = 'INVOICE_DATE') THEN 
         curr_rate_base_date_ := invoice_date_;
         IF (TRUNC(lu_rec_.invoice_date) != TRUNC(invoice_date_)) THEN
            date_modified_ := TRUE;
         END IF;
      ELSIF (curr_rate_base_ != 'INVOICE_DATE' AND delivery_date_ IS NULL)THEN 
         curr_rate_base_date_ := invoice_date_;
         date_modified_ := TRUE;
      ELSE
         curr_rate_base_date_ := delivery_date_;
         IF (lu_rec_.latest_delivery_date IS NULL OR lu_rec_.latest_delivery_date != delivery_date_) THEN
            date_modified_ := TRUE;
         END IF;          
      END IF;      
      
      IF (print_invoice_ AND curr_rate_base_ = 'DELIVERY_DATE') THEN
         date_modified_ := FALSE;
      END IF;
        
      -- gelr:out_inv_curr_rate_voucher_date, Modified if condition
      IF (((date_modified_ OR (fetch_del_date_rate_ AND Company_Localization_Info_API.Get_Parameter_Value_Db(company_, 'OUT_INV_CURR_RATE_VOUCHER_DATE') = Fnd_Boolean_API.DB_TRUE)) AND (lu_rec_.invoice_type NOT IN (NVL(cor_inv_type_, 'CUSTORDCOR'), NVL(col_inv_type_, 'CUSTCOLCOR'))
          AND (lu_rec_.use_ref_inv_curr_rate = 'FALSE'))) OR (fetch_del_date_rate_ AND Company_Localization_Info_API.Get_Parameter_Value_Db(company_, 'OUT_INV_CURR_RATE_VOUCHER_DATE') = Fnd_Boolean_API.DB_FALSE)) THEN      
         -- When the invoice date is changed,we should
         -- change the currency rates for all invoice types except 'correction invoices'
         -- and except for the credit invoices which were supposed to use the debit invoice rates.
         base_currency_code_ := Company_Finance_API.Get_Currency_Code(lu_rec_.company);
         IF (base_currency_code_ != lu_rec_.currency) THEN
            currency_type_ := lu_rec_.currency_rate_type;
            
            IF (currency_type_ IS NULL) THEN
               currency_type_ := Invoice_Library_API.Get_Default_Currency_Type(lu_rec_.company, 'CUSTOMER', lu_rec_.identity);
            END IF;
            -- fin_curr_rate_ will be the rate used in Finance saved in the CURR_RATE COLUMN
            Currency_Rate_API.Fetch_Currency_Rate_Base(conv_factor_, fin_curr_rate_, inverted_, lu_rec_.company,
                                                       lu_rec_.currency, base_currency_code_, currency_type_,
                                                       curr_rate_base_date_,
                                                       Currency_Code_API.Get_Emu(lu_rec_.company, base_currency_code_));                                           
            -- currency_rate_ will be an uninverted rate, even if the currency rate for this currency should be inverted
            Invoice_Library_API.Get_Currency_Rate_Defaults(currency_type_, conv_factor_, currency_rate_,
                                                           lu_rec_.company, lu_rec_.currency, curr_rate_base_date_, 'CUSTOMER', lu_rec_.identity);
            IF (lu_rec_.advance_invoice = 'TRUE') THEN
               tax_curr_rate_      := fin_curr_rate_;
            ELSE
               tax_curr_rate_type_ := Currency_Type_Basic_Data_API.Get_Tax_Sell(lu_rec_.company);
               tax_curr_rate_      := Tax_Handling_Invoic_Util_API.Get_Tax_Curr_Rate(lu_rec_.company, 'CUSTOMER', lu_rec_.currency, 'CUSTOMER_ORDER_INV_HEAD_API', fin_curr_rate_, curr_rate_base_date_);
            END IF;                                                           
            
            IF ((lu_rec_.curr_rate != currency_rate_) OR (lu_rec_.fin_curr_rate != fin_curr_rate_) OR (lu_rec_.tax_curr_rate != tax_curr_rate_) OR fetch_del_date_rate_) THEN
               new_currency_rate_retrieved_ := TRUE;
            END IF;

            Client_SYS.Add_To_Attr('CURR_RATE', fin_curr_rate_, newattr_);            
            Client_SYS.Add_To_Attr('N1', currency_rate_, newattr_);
            Client_SYS.Add_To_Attr('TAX_CURR_TYPE', tax_curr_rate_type_, newattr_);
            Client_SYS.Add_To_Attr('TAX_CURR_RATE', tax_curr_rate_, newattr_);
         END IF;
         
         compfin_rec_ := Company_Finance_API.Get(company_);
         IF (compfin_rec_.parallel_acc_currency IS NOT NULL AND compfin_rec_.parallel_acc_currency != lu_rec_.currency) THEN
            Currency_Rate_API.Get_Parallel_Currency_Rate ( parallel_curr_rate_,
                                                           parallel_conv_factor_,
                                                           parallel_inverted_,
                                                           company_,
                                                           lu_rec_.currency,
                                                           curr_rate_base_date_,
                                                           compfin_rec_.parallel_rate_type,
                                                           compfin_rec_.parallel_base,
                                                           compfin_rec_.currency_code,
                                                           compfin_rec_.parallel_acc_currency,
                                                           NULL,
                                                           NULL);
            Client_SYS.Add_To_Attr('PARALLEL_CURR_RATE', parallel_curr_rate_, newattr_);
            
            IF (parallel_curr_rate_ != lu_rec_.parallel_curr_rate) THEN
               new_currency_rate_retrieved_ := TRUE;
            END IF;
         END IF;
      END IF;

      Customer_Invoice_Pub_Util_API.Modify_Invoice_Head(newattr_, 'CUSTOMER_ORDER_INV_HEAD_API');

      -- Item amounts should be changed if the invoice date is changed
      IF (new_currency_rate_retrieved_) THEN
         FOR item_rec_ IN get_items(lu_rec_.company, lu_rec_.invoice_id) LOOP
            Customer_Order_Inv_Item_API.Recalculate_Line_Amounts__(lu_rec_.company, lu_rec_.invoice_id, item_rec_.item_id);
         END LOOP ;
      END IF;
   ELSIF (print_invoice_)THEN
      Customer_Invoice_Pub_Util_API.Modify_Invoice_Head(newattr_, 'CUSTOMER_ORDER_INV_HEAD_API');
   END IF;
END Modify_Invoice_Dates___;


-- Modify_Invoice_Head___
--   Calls Customer_Invoice_Pub_Util for modifications of the invoice header.
PROCEDURE Modify_Invoice_Head___ (
   attr_  IN OUT VARCHAR2,
   objid_ IN     VARCHAR2 )
IS
   lu_rec_                 CUSTOMER_ORDER_INV_HEAD_ALL%ROWTYPE;
   ptr_                    NUMBER;
   newattr_                VARCHAR2(32000);
   name_                   VARCHAR2(30);
   value_                  VARCHAR2(2000);
   invoice_date_           DATE;
   pay_term_id_            VARCHAR2(20);
   pay_term_base_date_     DATE;
   invoice_addr_id_        VARCHAR2(50);
   allow_changes_          VARCHAR2(5);
   stat_attr_              VARCHAR2(2000);
   price_adjustment_       VARCHAR2(5);
   due_date_               DATE;
   new_due_date_           DATE;
   installment_plan_count_ NUMBER;
   def_payment_method_     VARCHAR2(20) := NULL;
   max_voucher_date_       DATE;
   date_changed_           BOOLEAN;
   cust_ref_               VARCHAR2(100);
   delivery_date_          DATE;
   cust_ref_changed_       BOOLEAN := FALSE;
   deliv_date_changed_     BOOLEAN := FALSE;
   prepay_deb_inv_type_    VARCHAR2(20);
   prepay_cre_inv_type_    VARCHAR2(20);
   -- gelr:out_inv_curr_rate_voucher_date, begin
   vou_date_base_changed_  BOOLEAN := FALSE;
   vou_date_base_          VARCHAR2(20);
   -- gelr:out_inv_curr_rate_voucher_date, end
   
   CURSOR getrec IS
      SELECT *
      FROM   CUSTOMER_ORDER_INV_HEAD_ALL
      WHERE  OBJID = objid_;

   CURSOR get_items IS
      SELECT item_id
      FROM   CUSTOMER_ORDER_INV_ITEM
      WHERE  company = lu_rec_.company
      AND    invoice_id = lu_rec_.invoice_id; 
BEGIN

   OPEN getrec;
   FETCH getrec INTO lu_rec_;
   IF (getrec%NOTFOUND) THEN
      CLOSE getrec;
      Error_SYS.Record_Removed(lu_name_); 
   END IF;
   CLOSE getrec;

   IF lu_rec_.objstate != 'Preliminary' THEN
      
      IF (lu_rec_.objstate = 'Cancelled') THEN
         Error_SYS.Record_General(lu_name_,'NOTPRELINVOICE: Only invoices in state Preliminary can be changed.');
      END IF;
      
      ptr_ := NULL;
      WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
         IF (name_ != 'YOUR_REFERENCE') THEN
            Error_SYS.Record_General(lu_name_,'NOTPRELINVOICE: Only invoices in state Preliminary can be changed.');
         ELSE
            IF (NVL(lu_rec_.your_reference, Database_Sys.string_null_) != NVL(value_, Database_Sys.string_null_)) THEN
               cust_ref_changed_ := TRUE;
               cust_ref_ := value_;
            END IF;        
         END IF;
      END LOOP; 
      
      IF (cust_ref_changed_ = TRUE) THEN
         attr_ := NULL;
         Client_SYS.Add_To_Attr('COMPANY',    lu_rec_.company,    attr_);
         Client_SYS.Add_To_Attr('SERIES_ID',  lu_rec_.series_id,  attr_);
         Client_SYS.Add_To_Attr('INVOICE_NO', lu_rec_.invoice_no, attr_);
         Client_SYS.Add_To_Attr('IDENTITY',   lu_rec_.identity,   attr_);
         Client_SYS.Add_To_Attr('PARTY_TYPE', 'CUSTOMER',         attr_);
         Client_SYS.Add_To_Attr('C2', cust_ref_,                   attr_);
         Customer_Invoice_Pub_Util_API.Modify_Invoice_Head(attr_, 'CUSTOMER_ORDER_INV_HEAD_API'); 
      END IF;     
   ELSE
      $IF (Component_Jinsui_SYS.INSTALLED)$THEN 
         allow_changes_ := Js_Customer_Info_API.Get_Allow_Changes_To_Prel_Inv(lu_rec_.company, lu_rec_.identity);
      $END 

      allow_changes_ := NVL(allow_changes_,'TRUE');

      IF (lu_rec_.js_invoice_state_db IN ('RJS','UJS')) THEN
         Error_SYS.Record_General(lu_name_,'JINSUINOTOPEN: Jinsui invoices in state Ready For Transfer and Updated may not be changed.');
      ELSIF (lu_rec_.js_invoice_state_db = 'TJS' AND allow_changes_ = 'FALSE') THEN
         Error_SYS.Record_General(lu_name_,'JINSUICHANGE: Jinsui invoices in state Transferred cannot be changed when Allow Changes to Transferred Jinsui Invoices option is not selected for the company.');
      END IF;

      pay_term_id_            := NVL(Client_SYS.Get_Item_Value('PAY_TERM_ID', attr_), lu_rec_.pay_term_id);
      invoice_addr_id_        := NVL(Client_SYS.Get_Item_Value('INVOICE_ADDRESS_ID', attr_), lu_rec_.invoice_address_id);
      invoice_date_           := NVL(Client_SYS.Attr_Value_To_Date(Client_SYS.Get_Item_Value('INVOICE_DATE', attr_)), lu_rec_.invoice_date);
      pay_term_base_date_     := Client_SYS.Attr_Value_To_Date(Client_SYS.Get_Item_Value('PAY_TERM_BASE_DATE', attr_));
      price_adjustment_       := Client_SYS.Get_Item_Value('PRICE_ADJUSTMENT', attr_);
      due_date_               := NVL(Client_SYS.Attr_Value_To_Date(Client_SYS.Get_Item_Value('DUE_DATE', attr_)), lu_rec_.due_date);
      -- gelr:out_inv_curr_rate_voucher_date, begin
      vou_date_base_changed_  := Client_SYS.Item_Exist('OUT_INV_VOU_DATE_BASE_DB', attr_);      
      -- gelr:out_inv_curr_rate_voucher_date, end
      deliv_date_changed_     := Client_SYS.Item_Exist('LATEST_DELIVERY_DATE', attr_);      
      
      IF(deliv_date_changed_) THEN 
         delivery_date_      := Client_SYS.Attr_Value_To_Date(Client_SYS.Get_Item_Value('LATEST_DELIVERY_DATE', attr_));
      ELSE 
         delivery_date_      := lu_rec_.latest_delivery_date;
      END IF;     

      IF (invoice_addr_id_ IS NOT NULL) THEN
         Customer_Info_Address_API.Exist(lu_rec_.identity, invoice_addr_id_);
         IF (Cust_Ord_Customer_Address_API.Is_Valid(lu_rec_.identity, invoice_addr_id_) = 0) THEN
            Error_SYS.Record_General(lu_name_, 'INVALIDINVADDR: Invoice address :P1 is invalid. Check the validity period.', invoice_addr_id_);
         END IF;
      END IF;

      IF (lu_rec_.due_date != due_date_) THEN
         IF (Payment_Term_API.Get_Consider_Pay_Vac_Period(lu_rec_.company, pay_term_id_) = 'TRUE') THEN
            $IF Component_Payled_SYS.INSTALLED $THEN
                def_payment_method_ := Payment_Way_Per_Identity_API.Get_Default_Pay_Way(lu_rec_.company,
                                                                                        lu_rec_.identity,
                                                                                        Party_Type_API.Decode(lu_rec_.party_type));
            $END
            new_due_date_ := Payment_Vacation_Period_API.Get_New_Vac_Due_Date(company_        => lu_rec_.company,
                                                                              payment_method_ => def_payment_method_,
                                                                              customer_id_    => lu_rec_.identity,
                                                                              due_date_       => due_date_);
            IF (new_due_date_ != due_date_) THEN
               Error_SYS.Record_General(lu_name_,'DUEDATEINVACPRD: The due date cannot overlap the vacation period.');
            END IF;
         END IF;
      END IF;

      IF lu_rec_.pay_term_id != pay_term_id_ THEN
         Cust_Order_Invoice_Hist_API.New(lu_rec_.company, lu_rec_.invoice_id,
                                         Language_SYS.Translate_Constant(lu_name_, 'PAYTERMCHGD: Pay Term has been changed from :P1 to :P2', NULL, lu_rec_.pay_term_id, pay_term_id_));
      END IF;

      IF lu_rec_.invoice_address_id != invoice_addr_id_ THEN
         Cust_Order_Invoice_Hist_API.New(lu_rec_.company, lu_rec_.invoice_id,
                                         Language_SYS.Translate_Constant(lu_name_, 'INVADDRCHGD: Invoice Address Id has been changed from :P1 to :P2', NULL, lu_rec_.invoice_address_id, invoice_addr_id_));
      END IF;

      -- gelr:out_inv_curr_rate_voucher_date, modified condition to check the delivery date and voucher date base as well.
      IF ((lu_rec_.invoice_date != invoice_date_) OR (lu_rec_.latest_delivery_date != delivery_date_) OR vou_date_base_changed_) THEN
         prepay_deb_inv_type_ := NVL(Company_Def_Invoice_Type_API.Get_Def_Co_Prepay_Deb_Inv_Type(lu_rec_.company), 'COPREPAYDEB');
         prepay_cre_inv_type_ := NVL(Company_Def_Invoice_Type_API.Get_Def_Co_Prepay_Cre_Inv_Type(lu_rec_.company), 'COPREPAYCRE');
         IF (lu_rec_.invoice_type IN (prepay_deb_inv_type_, prepay_cre_inv_type_)) THEN     
            $IF Component_Payled_SYS.INSTALLED $THEN
               max_voucher_date_ := Payment_API.Get_Prepay_Inv_Max_Vou_Date(lu_rec_.company,
                                                                            lu_rec_.identity,
                                                                            lu_rec_.party_type,
                                                                            lu_rec_.creators_reference,
                                                                            lu_rec_.invoice_id);
            $END                     
            IF (max_voucher_date_ IS NOT NULL) THEN
               -- gelr:out_inv_curr_rate_voucher_date, added if condition
               IF (Company_Localization_Info_API.Get_Parameter_Value_Db(lu_rec_.company, 'OUT_INV_CURR_RATE_VOUCHER_DATE') = Fnd_Boolean_API.DB_FALSE) THEN
                  IF (invoice_date_ < max_voucher_date_) THEN
                     Error_SYS.Record_General(lu_name_,'PREPAYINVDATE: The invoice date cannot be an earlier date than the payment date (:P1).', max_voucher_date_ );
                  END IF;            
               -- gelr:out_inv_curr_rate_voucher_date, begin
               ELSE                
                  IF( vou_date_base_changed_) THEN          
                     vou_date_base_   := Client_SYS.Get_Item_Value('OUT_INV_VOU_DATE_BASE_DB', attr_);
                  ELSE         
                     vou_date_base_   := lu_rec_.out_inv_vou_date_base_db;
                  END IF;
                  IF (invoice_date_ < max_voucher_date_) AND (vou_date_base_ = Base_Date_API.DB_INVOICE_DATE) THEN
                     Error_SYS.Record_General(lu_name_,'PREPAYINVDATE: The invoice date cannot be an earlier date than the payment date (:P1).', max_voucher_date_ );
                  END IF;
                  IF (delivery_date_ < max_voucher_date_) AND (vou_date_base_ = Base_Date_API.DB_DELIVERY_DATE) THEN
                     Error_SYS.Record_General(lu_name_,'PREPAYDELIVDATE: The delivery date cannot be an earlier date than the payment date (:P1).', max_voucher_date_ );
                  END IF;
               END IF;
               -- gelr:out_inv_curr_rate_voucher_date, end
            END IF;            
         END IF;    
         Invoice_Customer_Order_API.Validate_Vat_Codes(lu_rec_.company, lu_rec_.invoice_id, invoice_date_);
         Cust_Order_Invoice_Hist_API.New(lu_rec_.company, lu_rec_.invoice_id,
                                       Language_SYS.Translate_Constant(lu_name_, 'INVDATECHGD: Invoice Date has been changed from :P1 to :P2', NULL, lu_rec_.invoice_date, invoice_date_));
         Client_SYS.Clear_Attr(stat_attr_);
         Client_SYS.Add_To_Attr('INVOICE_DATE', invoice_date_, stat_attr_);
         Cust_Ord_Invo_Stat_API.Modify_Invoice_Statistics(stat_attr_, lu_rec_.company, lu_rec_.invoice_id);
      END IF;

      IF lu_rec_.pay_term_base_date != pay_term_base_date_ THEN
         Cust_Order_Invoice_Hist_API.New(lu_rec_.company, lu_rec_.invoice_id,
                                         Language_SYS.Translate_Constant(lu_name_, 'PAYTERMBASDATCHG: Pay Term Base Date has been changed from :P1 to :P2', NULL, lu_rec_.pay_term_base_date, pay_term_base_date_));
      END IF;
      
      Modify_Invoice_Dates___(date_changed_, lu_rec_.company, lu_rec_.invoice_id, invoice_date_, pay_term_base_date_, NULL, pay_term_id_, delivery_date_);   

      ptr_ := NULL;
      WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
         IF (name_ = 'ORDER_DATE') THEN
            Client_SYS.Add_To_Attr('D1', value_, newattr_);
         END IF;
         IF (name_ = 'OUR_REFERENCE') THEN
            Client_SYS.Add_To_Attr('C1', value_, newattr_);
         END IF;
         IF (name_ = 'YOUR_REFERENCE') THEN
            Client_SYS.Add_To_Attr('C2', value_, newattr_);
         END IF;
         IF (name_ = 'SHIP_VIA') THEN
            Client_SYS.Add_To_Attr('C3', value_, newattr_);
         END IF;
         IF (name_ = 'FORWARD_AGENT_ID') THEN
            IF (value_ IS NOT NULL) THEN
               Forwarder_Info_API.Exist(value_);
            END IF;
            Client_SYS.Add_To_Attr('C4', value_, newattr_);
         END IF;
         IF (name_ = 'LABEL_NOTE') THEN
            Client_SYS.Add_To_Attr('C5', value_, newattr_);
         END IF;
         IF (name_ = 'DELIVERY_TERMS') THEN
            Client_SYS.Add_To_Attr('C6', value_, newattr_);
         END IF;
         IF (name_ = 'DEL_TERMS_LOCATION') THEN
            Client_SYS.Add_To_Attr('C12', value_, newattr_);
         END IF;
         IF (name_ = 'CONTRACT') THEN
            Client_SYS.Add_To_Attr('C7', value_, newattr_);
         END IF;
         IF (name_ = 'LATEST_DELIVERY_DATE') THEN
            Client_SYS.Add_To_Attr('DELIVERY_DATE', value_, newattr_);
         END IF;
         IF (name_ = 'BRANCH') THEN
            Client_SYS.Add_To_Attr('BRANCH', value_, newattr_);
         END IF;
         IF (name_ = 'TAX_ID_NUMBER') THEN
            Client_SYS.Add_To_Attr('TAX_ID_NUMBER', value_, newattr_);
         END IF;
         IF (name_ = 'TAX_ID_TYPE') THEN
            Client_SYS.Add_To_Attr('TAX_TD_TYPE', value_, newattr_);
         END IF;
         IF (name_ = 'INVOICE_TEXT_ID') THEN
            Client_SYS.Add_To_Attr('INVOICE_TEXT_ID', value_, newattr_);
         END IF;
         IF (name_ = 'INVOICE_TEXT') THEN
            Client_SYS.Add_To_Attr('INVOICE_TEXT', value_, newattr_);
         END IF;
         IF (name_ = 'CORRECTION_REASON_ID') THEN
            Client_SYS.Add_To_Attr('CORRECTION_REASON_ID', value_, newattr_);
         END IF;
         IF (name_ = 'CORRECTION_REASON') THEN
            Client_SYS.Add_To_Attr('CORRECTION_REASON', value_, newattr_);
         END IF;
         IF (name_ NOT IN ('INVOICE_TEXT', 'INVOICE_TEXT_ID')) THEN
            Client_SYS.Set_Item_Value(name_, value_, newattr_);
         END IF;  
      END LOOP;

      Client_SYS.Add_To_Attr('COMPANY',    lu_rec_.company,    newattr_);
      Client_SYS.Add_To_Attr('SERIES_ID',  lu_rec_.series_id,  newattr_);
      Client_SYS.Add_To_Attr('INVOICE_NO', lu_rec_.invoice_no, newattr_);
      Client_SYS.Add_To_Attr('IDENTITY',   lu_rec_.identity,   newattr_);
      Client_SYS.Add_To_Attr('PARTY_TYPE', 'CUSTOMER',         newattr_);

      attr_ := newattr_;

      Customer_Invoice_Pub_Util_API.Modify_Invoice_Head(attr_, 'CUSTOMER_ORDER_INV_HEAD_API');   
      IF (lu_rec_.price_adjustment != price_adjustment_) THEN
         FOR item_rec_ IN get_items LOOP
            Customer_Order_Inv_Item_API.Modify_Invoice_Statistics(lu_rec_.company, lu_rec_.invoice_id, item_rec_.item_id, TRUE);
         END LOOP;
      END IF;

      IF lu_rec_.pay_term_id = pay_term_id_ AND lu_rec_.invoice_date = invoice_date_ AND lu_rec_.pay_term_base_date = pay_term_base_date_ THEN
         installment_plan_count_ := Payment_Plan_API.Get_Record_Count(lu_rec_.company,lu_rec_.invoice_id);            
         IF installment_plan_count_ > 1 THEN
            IF lu_rec_.due_date != due_date_ THEN
               Error_SYS.Record_General(lu_name_,'DUEDATECHANGE: Due date cannot be changed when more than one installment plan exists.');
            END IF;         
         END IF;
      END IF;
   END IF;
   
   IF (cust_ref_changed_) THEN
      IF (lu_rec_.your_reference IS NULL AND cust_ref_ IS NOT NULL) THEN
         Cust_Order_Invoice_Hist_API.New(lu_rec_.company, lu_rec_.invoice_id,
                                   Language_SYS.Translate_Constant(lu_name_, 'CUSTREFCHANGE1: Cust reference has been changed to :P1.', NULL, cust_ref_));
      ELSIF (lu_rec_.your_reference IS NOT NULL AND cust_ref_ IS NULL) THEN
         Cust_Order_Invoice_Hist_API.New(lu_rec_.company, lu_rec_.invoice_id,
                                   Language_SYS.Translate_Constant(lu_name_, 'CUSTREFCHANGE2: Cust reference has been set to empty.'));
      ELSIF (lu_rec_.your_reference IS NOT NULL AND cust_ref_ IS NOT NULL) THEN
          Cust_Order_Invoice_Hist_API.New(lu_rec_.company, lu_rec_.invoice_id,
                                   Language_SYS.Translate_Constant(lu_name_, 'CUSTREFCHANGE3: Cust reference has been changed from :P1 to :P2.', NULL, lu_rec_.your_reference, cust_ref_));
      END IF;   
   END IF;
END Modify_Invoice_Head___;


-- Modify_Invoice_Details____
--   This method is only called from server and is used to modify the invoice header based on some values
--   which can only be retrieved after the invoice lines are created..
--   For example the maximum delivery date can only be decided once we see
--   all the invoice lines that are included in the debit invoice..
PROCEDURE Modify_Invoice_Details____ (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER )
IS
   latest_deliv_date_ CUSTOMER_ORDER_INV_HEAD.latest_delivery_date%TYPE;
   tax_id_number_     CUSTOMER_ORDER_INV_HEAD.tax_id_number%TYPE;
   tax_id_type_       CUSTOMER_ORDER_INV_HEAD.tax_id_type%TYPE;
   branch_            CUSTOMER_ORDER_INV_HEAD.branch%TYPE; 
   attr_              VARCHAR2(32000);
   ivc_head_rec_      Customer_Order_Inv_Head_API.Public_Rec;
   date_changed_      BOOLEAN;

BEGIN 

   ivc_head_rec_ := Get(company_, invoice_id_);
   Get_Max_Deliv_Date(latest_deliv_date_, company_, invoice_id_);
  
   IF (latest_deliv_date_ IS NOT NULL AND Company_Invoice_Info_API.Get_Out_Inv_Curr_Rate_Base_Db(company_) = 'DELIVERY_DATE') THEN
      Modify_Invoice_Dates___(date_changed_, company_, invoice_id_, ivc_head_rec_.invoice_date, 
                              Invoice_API.Get_Pay_Term_Base_Date(company_, invoice_id_), NULL, ivc_head_rec_.pay_term_id, latest_deliv_date_, FALSE,TRUE);           
   END IF;
   
   IF ivc_head_rec_.invoice_type = 'CUSTORDDEB' THEN
      Modify_Work_Order_Ivc_Info___(invoice_id_);
   END IF;
   
   -- For the normal debit invoices, shipment debit invoices and the credit invoices created from RMA
   -- should fetch the tax details from the correct company. i.e if all the invoice lines are of tax liability type 'TAX'
   -- and they have the same delivery country and if tax details exists for the delivery country, then fetch the tax liability
   -- countries data from delivery country. Else fetch from the supply country..
   IF (ivc_head_rec_.invoice_type = 'CUSTORDDEB') OR 
      (ivc_head_rec_.shipment_id IS NOT NULL AND ivc_head_rec_.invoice_type = 'CUSTCOLDEB') OR 
      (ivc_head_rec_.rma_no IS NOT NULL) THEN
      Get_Company_Tax_Details___(tax_id_number_, tax_id_type_, branch_, company_, invoice_id_); 
      Client_SYS.Add_To_Attr('TAX_ID_NUMBER', tax_id_number_, attr_);
      Client_SYS.Add_To_Attr('TAX_ID_TYPE', tax_id_type_, attr_);
      Client_SYS.Add_To_Attr('BRANCH', branch_, attr_);
   END IF;   
   Client_SYS.Add_To_Attr('DELIVERY_DATE', latest_deliv_date_, attr_);
   Client_SYS.Add_To_Attr('COMPANY', company_, attr_);
   Client_SYS.Add_To_Attr('INVOICE_ID', invoice_id_, attr_);

   Customer_Invoice_Pub_Util_API.Modify_Invoice_Head(attr_, 'CUSTOMER_ORDER_INV_HEAD_API');
END Modify_Invoice_Details____;        


PROCEDURE Get_Max_Deliv_Date (
   latest_deliv_date_   OUT DATE,
   company_             IN  VARCHAR2,
   invoice_id_          IN  NUMBER)
IS
   advance_dr_invoice_type_    VARCHAR2(20);
   advance_cr_invoice_type_    VARCHAR2(20);

   CURSOR get_invoice_info IS
      SELECT  invoice_type, number_reference, series_reference
        FROM  CUSTOMER_ORDER_INV_HEAD
       WHERE  invoice_id = invoice_id_
         AND  company = company_ ;

   inv_rec_           get_invoice_info%ROWTYPE;

   CURSOR get_ref_invoice_info(series_reference_ IN VARCHAR2, number_reference_ IN VARCHAR2) IS
      SELECT  latest_delivery_date
        FROM  CUSTOMER_ORDER_INV_HEAD
       WHERE  invoice_no = number_reference_
         AND  series_id = series_reference_
         AND  company = company_ ;
BEGIN
   OPEN get_invoice_info;
   FETCH get_invoice_info INTO inv_rec_;
   CLOSE get_invoice_info;

   advance_dr_invoice_type_ := Company_Def_Invoice_Type_API.Get_Def_Adv_Co_Dr_Inv_Type(company_);
   advance_cr_invoice_type_ := Company_Def_Invoice_Type_API.Get_Def_Adv_Co_Cr_Inv_Type(company_);

   IF (inv_rec_.invoice_type IN (advance_dr_invoice_type_, advance_cr_invoice_type_)) THEN
      latest_deliv_date_ := NULL;
   ELSIF (inv_rec_.invoice_type IN ('CUSTORDDEB', 'CUSTCOLDEB', 'SELFBILLDEB')) THEN
      latest_deliv_date_ := Outstanding_Sales_API.Get_Max_Delivery_Confirm_Date(company_, invoice_id_);
   ELSE
      IF (inv_rec_.number_reference IS NOT NULL) THEN
         OPEN get_ref_invoice_info(inv_rec_.series_reference, inv_rec_.number_reference);
         FETCH get_ref_invoice_info INTO latest_deliv_date_;
         CLOSE get_ref_invoice_info;
      ELSE
         latest_deliv_date_ := NULL;
      END IF;
   END IF;
END Get_Max_Deliv_Date;


-- Get_Company_Tax_Details___
--   This method is used to retrive the correction tax identity number, tax id type and the branch
--   for the normal debit invoices,shipment invoices, and credit invoices created from RMA/RMA line no/RMA charge no.
PROCEDURE Get_Company_Tax_Details___(
   tax_id_number_ OUT VARCHAR2,
   tax_id_type_   OUT VARCHAR2,
   branch_        OUT VARCHAR2,
   company_       IN  VARCHAR2,
   invoice_id_    IN  VARCHAR2)
IS
   CURSOR get_header IS
      SELECT creators_reference, identity, rma_no, shipment_id, supply_country_db, contract
      FROM customer_order_inv_head
      WHERE company = company_
      AND   invoice_id = invoice_id_;

   -- cursors for RMAs-----
   
   -- this cursor will select the distinct delivery countries connected to rma lines..
   CURSOR get_deliv_country_per_rma_line IS
      SELECT DISTINCT(DECODE(rml.order_no, NULL, DECODE(rm.ship_addr_flag, 'N', Return_Material_API.Get_Ship_Addr_Country(rml.rma_no), rm.ship_addr_country_code), Cust_Order_Line_Address_API.Get_Country_Code(rml.order_no, rml.line_no, rml.rel_no, rml.line_item_no))) delivery_country_code
      FROM customer_order_inv_item coii, return_material_line_tab rml, return_material_tab rm
      WHERE coii.company = company_
      AND   coii.invoice_id = invoice_id_
      AND   coii.rma_no = rml.rma_no
      AND   coii.rma_line_no = rml.rma_line_no
      AND   rm.rma_no = rml.rma_no; 
      
   -- this cursor will select the distinct delivery countries connected to rma lines..
   CURSOR get_deliv_country_per_rma_chg IS
      SELECT DISTINCT(DECODE(rmc.order_no, NULL, DECODE(rm.ship_addr_flag, 'N', Return_Material_API.Get_Ship_Addr_Country(rmc.rma_no), rm.ship_addr_country_code), Customer_Order_Charge_API.Get_Connected_Deliv_Country(rmc.order_no, rmc.sequence_no))) delivery_country_code
      FROM customer_order_inv_item coii, return_material_charge_tab rmc, return_material_tab rm
      WHERE coii.company = company_
      AND   coii.invoice_id = invoice_id_
      AND   coii.rma_no = rmc.rma_no
      AND   coii.rma_charge_no = rmc.rma_charge_no
      AND   rm.rma_no = rmc.rma_no;  
      
   -- this cursor will check whether we have at least one rma line or rma charge
   -- with tax liability 'exempt' is included in this invoice..
   CURSOR check_tax_exempt_rma_exist IS
      SELECT 1
      FROM customer_order_inv_item coii, return_material_line_tab rml
      WHERE coii.company = company_
      AND   coii.invoice_id = invoice_id_
      AND   coii.rma_no = rml.rma_no
      AND   coii.rma_line_no = rml.rma_line_no
      AND   Return_Material_Line_API.Get_Tax_Liability_Type_Db(rml.rma_no, rml.rma_line_no) = 'EXM'
      UNION
      SELECT 1
      FROM customer_order_inv_item coii, return_material_charge_tab rmc
      WHERE coii.company = company_
      AND   coii.invoice_id = invoice_id_
      AND   coii.rma_no   = rmc.rma_no
      AND   coii.rma_charge_no = rmc.rma_charge_no
      AND   Return_Material_Charge_API.Get_Tax_Liability_Type_Db(rmc.rma_no, rmc.rma_charge_no) = 'EXM'; 

   -- cursors for customer order debit invoices, advance debit invoices, 
   --  prepayment debit invoices... ----
   CURSOR get_deliv_country_per_line IS
      SELECT DISTINCT(cola.country_code)
      FROM customer_order_inv_item coii, cust_order_line_address_2 cola
      WHERE coii.company = company_
      AND   coii.invoice_id = invoice_id_
      AND   coii.order_no = cola.order_no
      AND   coii.line_no = cola.line_no
      AND   coii.release_no = cola.rel_no
      AND   coii.line_item_no = cola.line_item_no; 

   CURSOR check_tax_exempt_lines_exist IS
      SELECT 1
      FROM customer_order_inv_item coii, customer_order_line_tab col
      WHERE coii.company = company_
      AND   coii.invoice_id = invoice_id_
      AND   coii.order_no = col.order_no
      AND   coii.line_no = col.line_no
      AND   coii.release_no = col.rel_no
      AND   coii.line_item_no = col.line_item_no
      AND   Customer_Order_Line_API.Get_Tax_Liability_Type_Db(col.order_no, col.line_no, col.rel_no, col.line_item_no) = 'EXM';

   CURSOR check_header_connected_items IS
      SELECT order_no
      FROM  customer_order_inv_item coii
      WHERE coii.company = company_
      AND   coii.invoice_id = invoice_id_
      AND   coii.line_no IS NULL;

   -- cursors specific for Shipment Invoices (debit) -----
   -- note: most of the cursor can be used from the CO debit section..
   -- only specific cursors are needed for the shipment freight charges.
   CURSOR check_tax_exempt_freight_chg(shipment_id_ IN NUMBER) IS
      SELECT 1
      FROM  customer_order_inv_item coii, shipment_freight_charge_tab sfc
      WHERE coii.company = company_
      AND   coii.invoice_id = invoice_id_
      AND   coii.charge_seq_no = sfc.sequence_no
      AND   sfc.shipment_id = shipment_id_
      AND   EXISTS (SELECT 1
                    FROM tax_liability_tab tl
                    WHERE tl.tax_liability  = sfc.tax_liability 
                    AND tl.tax_liability_type = 'EXM'
                    AND tl.country_code IN (SELECT s.receiver_country
                                            FROM shipment_tab s                                           
                                            WHERE s.shipment_id = shipment_id_));
                                            
   CURSOR check_del_to_cust(order_no_ IN VARCHAR2, del_to_cust_no_ IN VARCHAR2) IS
      SELECT 1
      FROM customer_order_line_tab col
      WHERE col.order_no = order_no_
      AND col.deliver_to_customer_no = del_to_cust_no_;                                          

   order_no_                      VARCHAR2(12);
   rma_no_                        NUMBER;
   shipment_id_                   NUMBER;
   use_supply_country_tax_id_     BOOLEAN := FALSE;
   deliv_country_count_           NUMBER := 0;
   deliv_country_code_            VARCHAR2(2);
   supply_country_code_           VARCHAR2(2);
   header_country_                VARCHAR2(2);
   tax_exempt_lines_exist_        NUMBER;
   temp_order_no_                 VARCHAR2(12);
   tax_liability_country_rec_     Tax_Liability_Countries_API.Public_Rec;
   co_header_connected_chg_exist_ BOOLEAN := FALSE;
   contract_                      Customer_Order_Inv_Head.contract%TYPE;
   header_del_cust_               Customer_Order_Inv_Head.identity%TYPE;
   co_line_exist_                 NUMBER := 0;
   
BEGIN

   OPEN get_header;
   FETCH get_header INTO order_no_, header_del_cust_, rma_no_, shipment_id_, supply_country_code_, contract_; 
   CLOSE get_header;
   
   OPEN check_del_to_cust(order_no_, header_del_cust_);
   FETCH check_del_to_cust INTO co_line_exist_;
      IF (check_del_to_cust%NOTFOUND) THEN
         use_supply_country_tax_id_ := TRUE;  
      END IF;
   CLOSE check_del_to_cust;

   -- for the credit invoices created from RMA header, RMA line or RMA charges...we need to 
   --  check from which country we should fetch the tax liability countries information..
   IF rma_no_ IS NOT NULL THEN
      FOR country_rec_ IN get_deliv_country_per_rma_line LOOP

         -- deliv_country_count_ is maintained so that is it exceeds 1 that means we have 
         -- a mix of delivery countries...hence we need to fetch the tax details from the supply country
         deliv_country_count_ := deliv_country_count_ + 1;
         deliv_country_code_ := country_rec_.delivery_country_code;
         IF (deliv_country_count_ = 1) THEN
            -- If there's only one delivery country connected to the invoiced rma lines
            -- but still there could be some invoice lines for rma charges connected to a different delivery country
            -- then check if these 2 countries are same.
            FOR country_rec2_ IN get_deliv_country_per_rma_chg LOOP
              IF deliv_country_code_ !=  country_rec2_.delivery_country_code THEN 
                  -- Then we should use the supply country specific tax id in the Company/tax Liability Countries table
                  use_supply_country_tax_id_ := TRUE;
              END IF;              
            END LOOP;
         ELSE
            -- This means there are more than 1 delivery countries connected invoice lines..
            -- then cannot use the tax identity from the delivery country..use supply country_tax is instead..
            use_supply_country_tax_id_ := TRUE;
         END IF;
      END LOOP; 

      -- if still use_supply_country_tax_id_ is false..that means we have the same delivery country
      -- for all the RMA invoice items..now check whether there are invoice items rma lines/charges with EXEMPT tax liability
      IF NOT use_supply_country_tax_id_ THEN
         
         OPEN  check_tax_exempt_rma_exist;
         FETCH check_tax_exempt_rma_exist INTO tax_exempt_lines_exist_;
         IF (check_tax_exempt_rma_exist%FOUND) THEN
            -- If we find any invoice line connected to a tax exempt RMA line/RMA charge
            -- then the tax identity should be fetched from the supply country..
            use_supply_country_tax_id_ := TRUE;
         END IF;
         CLOSE check_tax_exempt_rma_exist;
      END IF;

   ELSIF shipment_id_ IS NOT NULL THEN
   -- for the collective debit invoices created from shipment we need to find the country to be used for tax fetching.
   -- Since all the shipment connected order lines and charges are connected based on the shipment delivery country
   -- we can skip the 'same delivery country' check in this section..
   -- but still we need to check for the 'Exempt' tax liability..
      deliv_country_code_  := Shipment_API.Get_Receiver_Country(shipment_id_);

      OPEN  check_tax_exempt_lines_exist;
      FETCH check_tax_exempt_lines_exist INTO tax_exempt_lines_exist_;
      IF (check_tax_exempt_lines_exist%FOUND) THEN
         -- If we find any invoice line connected to a tax exempt CO line
         -- then the tax identity should be fetched from the supply country..
         use_supply_country_tax_id_ := TRUE;
      END IF;
      CLOSE check_tax_exempt_lines_exist;

      -- if there are co header connected charges that also get invoiced with the shipment
      -- then we need to check the header tax liability type..
      FOR rec_ IN check_header_connected_items LOOP      
         IF Tax_Liability_API.Get_Tax_Liability_Type_Db(Customer_Order_API.Get_Tax_Liability(rec_.order_no), Customer_Order_Address_API.Get_Address_Country_Code(rec_.order_no)) = 'EXM' THEN
            use_supply_country_tax_id_ := TRUE;
         END IF;
      END LOOP;

      -- We also need to check the tax liability type of the shipment freight charges..
      OPEN  check_tax_exempt_freight_chg(shipment_id_);
      FETCH check_tax_exempt_freight_chg INTO tax_exempt_lines_exist_;
      IF (check_tax_exempt_freight_chg%FOUND) THEN
         use_supply_country_tax_id_ := TRUE;
      END IF;
      CLOSE check_tax_exempt_freight_chg;

   ELSE
      -- Else part will be executed for the customer order debit invoices
      header_country_ := Customer_Order_Address_API.Get_Country_Code(order_no_);

      -- This cursor will check whether there exist any invoice line which is NOT connected to any line
      -- that means that invoice line should fetch the details from the header..hence we fetch the order_no      OPEN check_header_connected_items;
      OPEN check_header_connected_items;
      FETCH check_header_connected_items INTO temp_order_no_;
      IF check_header_connected_items%FOUND THEN
         co_header_connected_chg_exist_ := TRUE;
         deliv_country_code_ :=  header_country_;
      END IF;
      CLOSE check_header_connected_items;

      FOR country_rec_ IN get_deliv_country_per_line LOOP
         deliv_country_count_ := deliv_country_count_ + 1;
         deliv_country_code_ := country_rec_.country_code;
         IF (deliv_country_count_ = 1) THEN
            -- If there's only one delivery country connected to the co lines
            -- but still there could be some invoice lines connected to the header delivery country
            -- then check if these 2 countries are same.
            IF (co_header_connected_chg_exist_) THEN
               IF header_country_ != deliv_country_code_ THEN
                  -- Then we should use the supply country specific tax id in the Company/tax Liability Countries table
                  use_supply_country_tax_id_ := TRUE;
               END IF;
            END IF;
         ELSE
            -- This means there are more than 1 delivery countries connected invoice lines..
            -- then cannot use the tax identity from the delivery country..use supply country_tax is instead..
            use_supply_country_tax_id_ := TRUE;
         END IF;
      END LOOP;

      -- if still use_supply_country_tax_id_ is false..that means we have the same delivery country
      -- for all the invoice item..now check whether there are invoice items connected to lines/header with EXEMPT tax liability
      IF NOT use_supply_country_tax_id_ THEN
         -- if header connected charges exist, check pay tax on the customer order header..
         IF (co_header_connected_chg_exist_ AND Tax_Liability_API.Get_Tax_Liability_Type_Db(Customer_Order_API.Get_Tax_Liability(order_no_), Customer_Order_Address_API.Get_Address_Country_Code(order_no_)) = 'EXM') THEN
            use_supply_country_tax_id_ := TRUE;
         END IF;

         OPEN  check_tax_exempt_lines_exist;
         FETCH check_tax_exempt_lines_exist INTO tax_exempt_lines_exist_;
         IF (check_tax_exempt_lines_exist%FOUND) THEN
            -- If we find any invoice line connected to a tax exempt CO line
            -- then the tax identity should be fetched from the supply country..
            use_supply_country_tax_id_ := TRUE;
         END IF;
         CLOSE check_tax_exempt_lines_exist;
      END IF;
   END IF;

   IF (NOT use_supply_country_tax_id_) THEN
      IF (Tax_Liability_Countries_API.Check_Valid_Info_Exist(company_, deliv_country_code_, SYSDATE)= 'FALSE') THEN
         use_supply_country_tax_id_ := TRUE;
      END IF;
   END IF;
      
   IF use_supply_country_tax_id_ THEN
      -- fetch the tax identity and the branch from the supply country
      tax_liability_country_rec_ := Tax_Liability_Countries_API.Get_Valid_Tax_Info(company_, supply_country_code_, SYSDATE); 
   ELSE
      -- fetch the tax identity and the branch from the delivery country
      tax_liability_country_rec_ := Tax_Liability_Countries_API.Get_Valid_Tax_Info(company_, deliv_country_code_, SYSDATE); 
   END IF;

   tax_id_number_ := tax_liability_country_rec_.tax_id_number;
   tax_id_type_   := tax_liability_country_rec_.tax_id_type;
   branch_        := NVL(tax_liability_country_rec_.branch, Invoice_Customer_Order_API.Get_Branch(company_, contract_, Customer_Order_API.Get_Customer_No(order_no_)));
END Get_Company_Tax_Details___;


-- Create_Order_Appendix___
--   Check if any Work Order appendixes exist for the specified order.
--   If this is the case the create the appendixes.
PROCEDURE Create_Order_Appendix___ (
   print_job_id_   IN OUT NUMBER,
   invoice_id_     IN NUMBER,
   order_no_       IN VARCHAR2,
   invoice_copies_ IN NUMBER,
   contact_        IN VARCHAR2,
   contract_       IN VARCHAR2,
   invoice_no_     IN VARCHAR2,
   email_          IN VARCHAR2,
   customer_no_    IN VARCHAR2,
   our_reference_  IN VARCHAR2)
IS
   wo_no_               NUMBER;
   complex_agr_         VARCHAR2(10) := NULL;
   create_ivc_appendix_ BOOLEAN := FALSE;

   CURSOR get_wo_lines IS
      SELECT DISTINCT demand_order_ref1
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  order_no = order_no_
      AND    demand_code = 'WO';
BEGIN
   -- and to print both print the MRO appendix Invoice apendix when required.
   $IF (Component_Wo_SYS.INSTALLED) $THEN

      FOR next_ IN get_wo_lines LOOP
         IF (complex_agr_ IS NULL) THEN
            -- Note : Check if the work order is connected to a complex agreement. Functionally, one CO cannot have WOs of different complex agreement.
            wo_no_ := TO_NUMBER(next_.demand_order_ref1);
            complex_agr_ := Active_Separate_API.Get_Complex_Agreement_Id(wo_no_);
            
            IF (complex_agr_ IS NULL) THEN
               -- The first WO fetched has no complex agreement.
               create_ivc_appendix_ := TRUE;
            END IF;
         ELSE
            -- The CO has lines connected to WOs, those are not having complex agreement.
            create_ivc_appendix_ := TRUE;
            -- complex_agr_ has a value and create_ivc_appendix_ is TRUE. No need to loop through further.
            EXIT;
         END IF;
      END LOOP;      
      -- Note : If it's connected to a complex agreement, then print the MRO appendix
      IF (complex_agr_ IS NOT NULL) THEN
         Active_Work_Order_Util_API.Create_Mro_Inv_Appendix(invoice_id_, order_no_, wo_no_, invoice_copies_); 
      END IF;

      IF create_ivc_appendix_ THEN
         -- If any work order appendixes exist for this order the create the apendixes
         IF (Active_Work_Order_Util_API.Check_Appendix_Exist(order_no_) = 1) THEN            
            Active_Work_Order_Util_API.Create_Invoice_Appendix(print_job_id_, invoice_id_, order_no_, invoice_copies_, contact_, contract_, invoice_no_, email_, customer_no_, our_reference_);  
         END IF;
      END IF;
   $ELSE
      NULL;
   $END
END Create_Order_Appendix___;


-- Create_Invoice_Appendices
--   Create appendixes for an invoice.
PROCEDURE Create_Invoice_Appendices (
   print_job_id_   OUT NUMBER,
   invoice_id_     IN NUMBER,
   invoice_copies_ IN NUMBER,
   contact_        IN VARCHAR2,
   contract_       IN VARCHAR2,
   invoice_no_     IN VARCHAR2,
   email_          IN VARCHAR2,
   customer_no_    IN VARCHAR2,
   our_reference_  IN VARCHAR2,
   send_and_print_ IN VARCHAR2 DEFAULT 'TRUE')
IS
   CURSOR get_invoice_orders IS
      SELECT DISTINCT order_no
      FROM   CUSTOMER_ORDER_INV_ITEM
      WHERE  invoice_id = invoice_id_;
BEGIN
   -- Create appendixes for order(s) on the invoice.
   -- For collective invoices there could be more than one order.
   FOR next_order_ IN get_invoice_orders LOOP
      Create_Order_Appendix___(print_job_id_, invoice_id_, next_order_.order_no, invoice_copies_, contact_, contract_, invoice_no_, email_, customer_no_, our_reference_);
   END LOOP;

   IF print_job_id_ IS NOT NULL AND send_and_print_ = 'TRUE' THEN
      Customer_Order_Flow_API.Printing_Print_Jobs(print_job_id_);
   END IF;
END Create_Invoice_Appendices;


-- Create_History_When_Printed___
--   Create history records for order(s) when an invoice has been printed/sent.
PROCEDURE Create_History_When_Printed___ (
   company_      IN VARCHAR2,
   invoice_id_   IN NUMBER,
   media_code_   IN VARCHAR2,
   email_addr_   IN VARCHAR2,
   print_method_ IN VARCHAR2)
   
IS
   invoice_no_          CUSTOMER_ORDER_INV_HEAD.invoice_no%TYPE;
   invoice_type_        CUSTOMER_ORDER_INV_HEAD.invoice_type%TYPE;
   text_                VARCHAR2(2000);
   order_no_            VARCHAR2(12);
   customer_id_         CUSTOMER_ORDER_INV_HEAD.identity%TYPE;
   your_reference_      CUSTOMER_ORDER_INV_HEAD.your_reference%TYPE;
   invoice_address_id_  CUSTOMER_ORDER_INV_HEAD.invoice_address_id%TYPE;
   email_invoice_db_    VARCHAR2(10);
   invoice_email_       VARCHAR2(200);
   receiver_address_    VARCHAR2(100);
   cor_inv_type_        VARCHAR2(20);
   col_inv_type_        VARCHAR2(20);
   text_email_          VARCHAR2(2000);
   series_id_           CUSTOMER_ORDER_INV_HEAD.series_id%TYPE;
   
   CURSOR get_invoice_data IS
      SELECT invoice_no,
             invoice_type,
             identity,
             series_id,
             your_reference,
             invoice_address_id
      FROM   CUSTOMER_ORDER_INV_HEAD
      WHERE  invoice_id = invoice_id_
      AND    company = company_;

   CURSOR get_invoice_orders IS
      SELECT DISTINCT order_no
      FROM   CUSTOMER_ORDER_INV_ITEM
      WHERE  invoice_id = invoice_id_
      AND    company = company_;

   CURSOR get_invoice_rmas IS
      SELECT DISTINCT rma_no
      FROM   CUSTOMER_ORDER_INV_ITEM
      WHERE  invoice_id = invoice_id_
      AND    company = company_;   

   -- prel_update_allowed = 'TRUE' avoids duplicate Cust. Ord. Line history entry on the credited line of a Corr. Invoice.
   CURSOR get_line IS
      SELECT line_no,release_no,line_item_no
      FROM CUSTOMER_ORDER_INV_ITEM
      WHERE order_no = order_no_
      AND invoice_id = invoice_id_
      AND company = company_
      AND prel_update_allowed = 'TRUE';
BEGIN

   OPEN get_invoice_data;
   FETCH get_invoice_data INTO invoice_no_, invoice_type_, customer_id_, series_id_, your_reference_, invoice_address_id_;
   CLOSE get_invoice_data;

   cor_inv_type_ := Company_Def_Invoice_Type_API.Get_Def_Co_Cor_Inv_Type(company_);
   col_inv_type_ := Company_Def_Invoice_Type_API.Get_Def_Col_Cor_Inv_Type(company_);

   IF (invoice_type_ = 'SELFBILLDEB') THEN
      text_ := Language_SYS.Translate_Constant(lu_name_, 'INVPOSTED: Invoice :P1 posted', NULL, invoice_no_);
   ELSIF (media_code_ IS NOT NULL) THEN
      receiver_address_ := Customer_Inv_Msg_Setup_API.Get_Address(customer_id_,
                                                                  company_,
                                                                  Party_Type_API.Decode('CUSTOMER'),
                                                                  media_code_, 
                                                                  'INVOIC');
      Cust_Order_Invoice_Hist_API.New(company_, invoice_id_, Language_SYS.Translate_Constant(lu_name_, 'INVSENTRECADDR: Invoice sent via :P1 to the receiver address :P2 ', NULL, media_code_, receiver_address_));
      IF (invoice_type_ IN ('CUSTORDCRE', 'CUSTCOLCRE')) THEN
         text_ := Language_SYS.Translate_Constant(lu_name_, 'CREINVSENT: Credit invoice :P1 sent via :P2', NULL, invoice_no_, media_code_);
      ELSE
         text_ := Language_SYS.Translate_Constant(lu_name_, 'INVSENT: Invoice :P1 sent via :P2', NULL, invoice_no_, media_code_);
      END IF;
   ELSE
      IF (email_addr_ IS NULL) THEN
         email_invoice_db_ := Cust_Ord_Customer_API.Get_Email_Invoice_Db(customer_id_);      
         IF (email_invoice_db_ = 'TRUE') THEN
            invoice_email_ := Cust_Ord_Customer_Address_API.Get_Email(customer_id_, your_reference_, invoice_address_id_);
         END IF;
      END IF;
      IF ((email_addr_ IS NOT NULL OR invoice_email_ IS NOT NULL) AND (NVL(print_method_, 'NO_STOP') = 'NO_STOP')) THEN
         -- History should not be inserted if print_method is PRINT_ONLINE or PRINT_BACKGROUND.
         Cust_Order_Invoice_Hist_API.New(company_, invoice_id_, Language_SYS.Translate_Constant(lu_name_, 'INVHISTEMAILED: Invoice E-mailed to :P1',NULL, NVL(email_addr_, invoice_email_)));
         IF (invoice_type_ IN ('CUSTORDCRE', 'CUSTCOLCRE')) THEN
            text_email_ := Language_SYS.Translate_Constant(lu_name_, 'CREINVEMAILED: Credit invoice :P1 E-mailed to :P2', NULL, invoice_no_, NVL(email_addr_, invoice_email_));
         ELSIF (invoice_type_ IN (cor_inv_type_, col_inv_type_)) THEN
            text_email_ := Language_SYS.Translate_Constant(lu_name_, 'CORINVEMAILED: Correction invoice :P1 E-mailed to :P2', NULL, invoice_no_, NVL(email_addr_, invoice_email_));
         ELSE
            text_email_ := Language_SYS.Translate_Constant(lu_name_, 'INVEMAILED: Invoice :P1 E-mailed to :P2', NULL, invoice_no_, NVL(email_addr_, invoice_email_));
         END IF;
      END IF;
      Cust_Order_Invoice_Hist_API.New(company_, invoice_id_, Language_SYS.Translate_Constant(lu_name_, 'INVHISTPRINTED: Invoice Printed',NULL));
      IF (invoice_type_ IN ('CUSTORDCRE', 'CUSTCOLCRE')) THEN
         text_ := Language_SYS.Translate_Constant(lu_name_, 'CREINVPRINTED: Credit invoice :P1 printed', NULL, invoice_no_);
      ELSIF (invoice_type_ IN (cor_inv_type_, col_inv_type_)) THEN
         text_ := Language_SYS.Translate_Constant(lu_name_, 'CORINVPRINTED: Correction invoice :P1 printed', NULL, invoice_no_);
      ELSE
         text_ := Language_SYS.Translate_Constant(lu_name_, 'INVPRINTED: Invoice :P1 printed', NULL, series_id_||invoice_no_);
      END IF;
   END IF;

   -- Create history records for order(s) on the invoice.
   -- For collective invoices there could be more than one order.
   FOR next_order_ IN get_invoice_orders LOOP
      IF next_order_.order_no IS NOT NULL THEN
         IF (text_email_ IS NOT NULL) THEN
            Customer_Order_History_API.New(next_order_.order_no, text_email_);
         END IF;
         Customer_Order_History_API.New(next_order_.order_no, text_);
         -- send event
         Cust_Order_Event_Creation_API.Create_Invoice(next_order_.order_no, invoice_id_);
         --Add a new record in Customer Order Line History
         order_no_:= next_order_.order_no;
         FOR linerec_ IN get_line LOOP
            IF (linerec_.line_no IS NOT NULL) THEN
               IF (text_email_ IS NOT NULL) THEN
                  Customer_Order_Line_Hist_API.New(order_no_, linerec_.line_no, linerec_.release_no, linerec_.line_item_no, text_email_);
               END IF;
               Customer_Order_Line_Hist_API.New(order_no_,linerec_.line_no,linerec_.release_no,linerec_.line_item_no,text_);
            END IF;
         END LOOP;
      END IF;
   END LOOP;

   FOR next_rma_ IN get_invoice_rmas LOOP
      IF next_rma_.rma_no IS NOT NULL THEN
         IF (text_email_ IS NOT NULL) THEN
            Return_Material_History_API.New(next_rma_.rma_no, text_email_);
         END IF;
         Return_Material_History_API.New(next_rma_.rma_no, text_);
      END IF;
   END LOOP;

END Create_History_When_Printed___;


-- Create_Credit_Invoice_Hist___
--   Create customer order history records for order(s) when credit invoice has been created.
PROCEDURE Create_Credit_Invoice_Hist___ (
   order_no_       IN VARCHAR2,
   ref_invoice_id_ IN NUMBER,
   cre_invoice_id_ IN NUMBER )
IS
   msg_              VARCHAR2(100);
   currency_         VARCHAR2(3);
   gross_amount_     NUMBER;
   invoice_type_     VARCHAR2(20);
   advance_invoice_  CUSTOMER_ORDER_INV_HEAD.advance_invoice%TYPE;
   company_          VARCHAR2(20);   
   cor_inv_type_     VARCHAR2(20);
   col_inv_type_     VARCHAR2(20);

   -- Get distinct order nos for the reference invoice
   CURSOR get_invoice_orders IS
      SELECT DISTINCT order_no
      FROM   CUSTOMER_ORDER_INV_ITEM
      WHERE  invoice_id = ref_invoice_id_
      AND    order_no IS NOT NULL;

   -- Get credit invoice details
   CURSOR get_invoice_datail IS
      SELECT company, currency , gross_amount , invoice_type, advance_invoice
      FROM   CUSTOMER_ORDER_INV_HEAD
      WHERE  invoice_id = cre_invoice_id_;

BEGIN

   OPEN get_invoice_datail;
   FETCH get_invoice_datail INTO company_, currency_, gross_amount_, invoice_type_, advance_invoice_;
   CLOSE get_invoice_datail;

   cor_inv_type_ := Company_Def_Invoice_Type_API.Get_Def_Co_Cor_Inv_Type(company_);
   col_inv_type_ := Company_Def_Invoice_Type_API.Get_Def_Col_Cor_Inv_Type(company_);

   -- Set different messages for different invoice types
   IF (advance_invoice_ = 'TRUE') THEN
      msg_ := Language_SYS.Translate_Constant(lu_name_, 'CREDADVINV: Credit Advance Invoice :P1 created', NULL, cre_invoice_id_);
   ELSIF (invoice_type_ IN (cor_inv_type_, col_inv_type_)) THEN
      msg_ := Language_SYS.Translate_Constant(lu_name_, 'CORRINV: Correction invoice :P1 created', NULL, cre_invoice_id_);      
   ELSE
      msg_ := Language_SYS.Translate_Constant(lu_name_, 'CREDITINV: Credit invoice :P1 created', NULL, cre_invoice_id_);
   END IF;
   -- Create the history record for the reference invoice also
   IF(ref_invoice_id_ IS NOT NULL) THEN
      Cust_Order_Invoice_Hist_API.New(company_, ref_invoice_id_, msg_);
   END IF;

   -- Creates customer order history records for order(s)
   IF (order_no_ IS NOT NULL) THEN
      Customer_Order_History_API.New(order_no_, msg_);
   ELSE
      FOR next_order_ IN get_invoice_orders LOOP
         Customer_Order_History_API.New(next_order_.order_no, msg_);
      END LOOP;
   END IF;
END Create_Credit_Invoice_Hist___;


-- Remove_Print_Job_If_Empty___
--   Check if a print job is empty and should be removed.
--   This could be the case when invoices are send and not printed.
PROCEDURE Remove_Print_Job_If_Empty___ (
   print_job_id_ IN OUT NUMBER )
IS
BEGIN

   IF (print_job_id_ IS NOT NULL) THEN
      -- A foundation error will be raised if the print job is empty
      Print_Job_Contents_API.Check_Empty(print_job_id_);
   END IF;

EXCEPTION
   WHEN OTHERS THEN
      IF Error_SYS.is_foundation_error(SQLCODE) THEN
         Print_Job_API.Remove(print_job_id_);
         print_job_id_ := NULL;
      ELSE
         RAISE;
      END IF;
END Remove_Print_Job_If_Empty___;


-- Print_Invoice___
--   Execute the invoice report for an invoice and connect the result to
--   a print job.
PROCEDURE Print_Invoice___ (
   result_keys_       IN OUT VARCHAR2,
   company_           IN  VARCHAR2,
   invoice_id_        IN  NUMBER,
   report_id_         IN  VARCHAR2,
   copy_no_           IN  NUMBER,
   tax_invoice_       IN  BOOLEAN,
   send_and_print_    IN  VARCHAR2,
   send_              IN  VARCHAR2,
   isr_param_attr_    IN  VARCHAR2 DEFAULT NULL,
   print_type_        IN  VARCHAR2 DEFAULT NULL,
   media_code_        IN  VARCHAR2 DEFAULT NULL,
   print_online_      IN  VARCHAR2)
IS 
   parameter_attr_     VARCHAR2(2000);
   temp_copy_no_       NUMBER;
   print_job_id_       NUMBER;
   pdf_info_           VARCHAR2(4000);
   identity_           VARCHAR2(20);             
   your_reference_     VARCHAR2(100);             
   invoice_address_id_ VARCHAR2(50);             
   contract_           VARCHAR2(5);             
   email_              VARCHAR2(200);
   email_invoice_db_   cust_ord_customer_tab.email_invoice%TYPE;
   result_key_         NUMBER;   
   report_life_        NUMBER;
   distribution_list_  VARCHAR2(4000);
   user_id_            VARCHAR2(20);
   from_               NUMBER;
   to_                 NUMBER;

   CURSOR get_invoice_datail IS
      SELECT identity, your_reference, invoice_address_id, contract
      FROM CUSTOMER_ORDER_INV_HEAD
      WHERE company    = company_  
      AND   invoice_id = invoice_id_;
      
BEGIN
   OPEN  get_invoice_datail;
   FETCH get_invoice_datail INTO identity_, your_reference_, invoice_address_id_, contract_;
   CLOSE get_invoice_datail;
   email_ := Cust_Ord_Customer_Address_API.Get_Email(identity_, your_reference_, invoice_address_id_);
   email_invoice_db_ := Cust_Ord_Customer_API.Get_Email_Invoice_Db(identity_);

   report_life_ := Report_Definition_API.Get_Life(report_id_);
   FOR copy_nos_ IN 0..copy_no_ LOOP
      IF (email_invoice_db_ = 'TRUE') THEN
         Customer_Order_Flow_API.Create_Report_Settings(pdf_info_, invoice_id_, your_reference_, contract_, email_, identity_, report_id_);
      END IF;
      -- Create the invoice report
      Client_SYS.Clear_Attr(parameter_attr_);
      IF (report_id_ IN('ADDITIONAL_INVOICE_DOC_REP', 'ADDITIONAL_INV_Q_R_CODE_REP')) THEN
         parameter_attr_ := isr_param_attr_;
      ELSE
         -- For Preliminary invoices sending copy_nos_ as 0 results errors on the printout. 
         -- Until the invoice is in preliminary state the 'Original' or 'Copy No' not needed on the print out.
         IF (print_type_ = 'P') THEN
           temp_copy_no_ := NULL;
           Client_SYS.Add_To_Attr('ORIGINAL', 'FALSE', parameter_attr_);
         ELSE
            temp_copy_no_ := copy_nos_;
         END IF;
         Client_SYS.Add_To_Attr('INVOICE_ID', invoice_id_, parameter_attr_);
         Client_SYS.Add_To_Attr('INVOICE_COPY_NO', temp_copy_no_, parameter_attr_);
         IF tax_invoice_ THEN
            Client_SYS.Add_To_Attr('TAX_INVOICE', '1', parameter_attr_);
         END IF;
      END IF;
      Client_SYS.Add_To_Attr('MEDIA_CODE', media_code_, parameter_attr_);
      Client_SYS.Add_To_Attr('PRINT_ONLINE', print_online_, parameter_attr_); 
      IF (email_invoice_db_ = 'TRUE') THEN
         -- Create one print job for original report and attach print job instances to same print job if there are no of copies
         Customer_Order_Flow_API.Create_Print_Jobs(print_job_id_, result_key_, report_id_, parameter_attr_, pdf_info_);
      ELSE
         -- Create one print job for original report and attach print job instances to same print job if there are no of copies
         Customer_Order_Flow_API.Create_Print_Jobs(print_job_id_, result_key_, report_id_, parameter_attr_);
      END IF; 
      -- If the customer is a B2b customer, distribute the report to the users connected to the customer. 
      $IF (Component_Salbb_SYS.INSTALLED) $THEN 
         IF (Customer_Info_API.Is_B2b_Customer(identity_)) THEN
            distribution_list_ := B2b_User_Util_API.Get_B2b_Cust_Connected_Users(identity_);
            from_ := 1;
            to_ := instr(distribution_list_, Client_SYS.field_separator_, from_);
            WHILE (to_ > 0) LOOP 
               user_id_ := substr(distribution_list_, from_, to_ - from_);
               Archive_Distribution_API.Connect_Instance(result_key_, user_id_, sysdate + report_life_);  
               from_ := to_ + 1;
               to_ := instr(distribution_list_, Client_SYS.field_separator_, from_);
            END LOOP;                     
         END IF;
      $END
      Client_SYS.Add_To_Attr('RESULT_KEY', result_key_, result_keys_);
      result_keys_ := result_keys_||',';      
      result_key_ := NULL; 
   END LOOP;
   -- If we are sending only the print jobs will normally be emty and should be removed.
   -- However appendixes might have been created event in this case, and they will never
   -- be sent, so there might still be a need to print the contents of the print job.
   
   -- Print_Job_API.Print will only get executed if Print document check box is checked.
   IF ((send_ = 'TRUE') AND (send_and_print_ = 'FALSE')) THEN
      Remove_Print_Job_If_Empty___(print_job_id_);
   END IF;
   -- Print_Job_API.Print will only get executed if Print document check box is checked.
   IF ((send_and_print_ = 'TRUE') OR (NVL(send_,'FALSE') = 'FALSE')) THEN
      Customer_Order_Flow_API.Printing_Print_Jobs(print_job_id_);
   END IF;
END Print_Invoice___;


-- Get_Previous_Execution___
--   This function check whether another method is "Executing" in parallel in background jobs
--   with the same invoice_id. If so, previous job_id is returned
FUNCTION Get_Previous_Execution___ (
   invoice_id_ IN NUMBER ) RETURN NUMBER
IS
   msg_            VARCHAR2(32000);
   attrib_value_   VARCHAR2(32000);
   value_          VARCHAR2(2000);
   deferred_call_  VARCHAR2(200):= 'Customer_Order_Inv_Head_API.Print_Invoices';
   name_           VARCHAR2(30);
   job_id_value_   VARCHAR2(30);
   job_id_tab_     Message_SYS.Name_Table;
   attrib_tab_     Message_SYS.Line_Table;
   job_invoice_id_ NUMBER;
   current_job_id_ NUMBER:=NULL;
   count_          NUMBER;
   ptr_            NUMBER;   
BEGIN
   -- Get current job_id
   current_job_id_ := Transaction_SYS.Get_Current_Job_Id;
   -- Get current 'Executing' job arguments
   Transaction_SYS.Get_Executing_Job_Arguments(msg_, deferred_call_);
   Message_SYS.Get_Attributes(msg_, count_, job_id_tab_, attrib_tab_);
   FOR i_ IN 1..count_ LOOP
      job_id_value_   := job_id_tab_(i_);
      attrib_value_   := attrib_tab_(i_);

      ptr_ := NULL;
      -- Loop through the parameter list to check whether invoice_id exists
      WHILE (Client_SYS.Get_Next_From_Attr(attrib_value_, ptr_, name_, value_)) LOOP
         IF (name_ = 'INVOICE_ID') THEN
            job_invoice_id_ := value_;
            -- Check to see if another job of this type is executing
            IF ((current_job_id_ != job_id_value_) AND (job_invoice_id_ = invoice_id_)) THEN    
               -- Return previous Execution
               RETURN job_id_value_;            
            END IF;  
         END IF;
      END LOOP;                          
   END LOOP;
   -- No previous job_id found
   RETURN NULL;
END Get_Previous_Execution___;


-- Copy_Connected_Objects___
--   Copy all document connected objects from CustomerOrder LU
--   to CustomerOrderInvHead LU for specified company.
PROCEDURE Copy_Connected_Objects___ (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER,
   order_no_   IN VARCHAR2 )
IS
   source_key_ref_      VARCHAR2(2000);
   destination_key_ref_ VARCHAR2(2000);
   source_lu_name_      VARCHAR2(100) := 'CustomerOrder';
   destination_lu_name_ VARCHAR2(100) := 'CustomerOrderInvHead';
BEGIN
   source_key_ref_      := Client_SYS.Get_Key_Reference(source_lu_name_,
                                                        'ORDER_NO',
                                                        order_no_);

   destination_key_ref_ := Client_SYS.Get_Key_Reference(destination_lu_name_,
                                                        'COMPANY',
                                                        company_,
                                                        'INVOICE_ID',
                                                        invoice_id_);

   $IF (Component_Docman_SYS.INSTALLED)$THEN 
       Doc_Reference_Object_API.Copy(source_lu_name_,
                                     source_key_ref_,
                                     destination_lu_name_,
                                     destination_key_ref_);
   $END 
END Copy_Connected_Objects___;

PROCEDURE Modify_Work_Order_Ivc_Info___ (
   invoice_id_     IN NUMBER)
IS
   $IF (Component_Wo_SYS.INSTALLED) $THEN
      service_invoice_line_coll_ Service_Invoice_Line_API.Serv_Invoice_Line_Tab_Type;
   $END
   
   wo_no_       NUMBER;
   invoice_no_  customer_order_inv_head.invoice_no%TYPE;
      
   CURSOR get_invoice_order_items IS
      SELECT coi.order_no, coi.line_no, coi.release_no, coi.line_item_no, item_id, demand_order_ref1
      FROM   customer_order_inv_item coi, customer_order_line_tab col
      WHERE  coi.order_no = col.order_no 
      AND    coi.line_no = col.line_no 
      AND    coi.release_no = col.rel_no 
      AND    coi.line_item_no = col.line_item_no
      AND    invoice_id = invoice_id_
      AND    demand_code = 'WO';
      
   TYPE Temp_Serv_Inv_Line_Tab_Type IS TABLE OF get_invoice_order_items%ROWTYPE
   INDEX BY BINARY_INTEGER;
   
   temp_serv_inv_line_coll_  Temp_Serv_Inv_Line_Tab_Type;
BEGIN   
   $IF (Component_Wo_SYS.INSTALLED) $THEN
      invoice_no_ := CUSTOMER_ORDER_INV_HEAD_API.Get_Invoice_No_By_Id(invoice_id_);
      OPEN get_invoice_order_items;
      LOOP
         FETCH get_invoice_order_items BULK COLLECT INTO temp_serv_inv_line_coll_ LIMIT 100;
         EXIT WHEN temp_serv_inv_line_coll_.COUNT = 0;
         
         service_invoice_line_coll_.DELETE;
         
         FOR i IN temp_serv_inv_line_coll_.FIRST..temp_serv_inv_line_coll_.LAST LOOP
            wo_no_ := TO_NUMBER(temp_serv_inv_line_coll_(i).demand_order_ref1);
            IF (wo_no_ IS NOT NULL) THEN
               service_invoice_line_coll_(i).cust_order_no            := temp_serv_inv_line_coll_(i).order_no;
               service_invoice_line_coll_(i).cust_order_line_no       := temp_serv_inv_line_coll_(i).line_no;
               service_invoice_line_coll_(i).cust_order_rel_no        := temp_serv_inv_line_coll_(i).release_no;
               service_invoice_line_coll_(i).cust_order_line_item_no  := temp_serv_inv_line_coll_(i).line_item_no;
               service_invoice_line_coll_(i).invoice_item_id          := temp_serv_inv_line_coll_(i).item_id;
               service_invoice_line_coll_(i).invoice_id               := invoice_id_;
               service_invoice_line_coll_(i).invoice_no               := invoice_no_;
            END IF;
         END LOOP;
         
         IF (service_invoice_line_coll_.COUNT > 0) THEN
            Service_Invoice_Line_API.Modify_Invoice_Info(service_invoice_line_coll_);
         END IF;
         
      END LOOP;
      CLOSE get_invoice_order_items;
   $ELSE
      NULL;
   $END
END Modify_Work_Order_Ivc_Info___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@UncheckedAccess
FUNCTION Org_Print_Exists_In_Archive__ (
   company_        IN VARCHAR2, 
   invoice_id_     IN NUMBER ) RETURN VARCHAR2 
IS
   result_key_          NUMBER;
   exists_in_archive_   VARCHAR2(5);
BEGIN
   IF company_ IS NOT NULL AND invoice_id_ IS NOT NULL THEN 
      Invoice_API.Get_Org_Result_Key(result_key_, exists_in_archive_, company_, invoice_id_);
   END IF;
   
   RETURN exists_in_archive_;
END Org_Print_Exists_In_Archive__;

@UncheckedAccess
FUNCTION Finite_State_Decode__ (
   db_state_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN   
   RETURN(Domain_SYS.Decode_(Domain_SYS.Get_Translated_Values(lu_name_), Get_Db_Values___, db_state_));
END Finite_State_Decode__;

-- These methods were added as a temporary solution to pass PLSQL model compliance test, because false state machine included in the LU.
@UncheckedAccess
FUNCTION Finite_State_Encode__ (
   client_state_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN   
   RETURN(Domain_SYS.Encode_(Domain_SYS.Get_Translated_Values(lu_name_), Get_Db_Values___, client_state_));
END Finite_State_Encode__;

@UncheckedAccess
PROCEDURE Enumerate_States__ (
   client_values_ OUT VARCHAR2 )
IS
BEGIN
   client_values_ := Domain_SYS.Enumerate_(Domain_SYS.Get_Translated_Values(lu_name_));
END Enumerate_States__;

FUNCTION Get_Client_Values___ RETURN VARCHAR2 DETERMINISTIC
IS
BEGIN
   RETURN('Preliminary^Posted^Cancelled^Printed^PostedAuth^PaidPosted^PartlyPaidPosted^');
END Get_Client_Values___;

FUNCTION Get_Db_Values___ RETURN VARCHAR2 DETERMINISTIC
IS
BEGIN
   RETURN('Preliminary^Posted^Cancelled^Printed^PostedAuth^PaidPosted^PartlyPaidPosted^');
END Get_Db_Values___;

@UncheckedAccess
FUNCTION Finite_State_Events__ (
   db_state_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN NULL;
END Finite_State_Events__;

@UncheckedAccess
PROCEDURE Language_Refreshed
IS
BEGIN
   Domain_SYS.Language_Refreshed(lu_name_, Get_Client_Values___, Get_Db_Values___, 'STATE');
END Language_Refreshed;

-- Modify__
--   Client-support interface to modify attributes for LU instances.
--   action_ = 'CHECK'
--   Check all attributes before modifying an existing object and
--   handle of information to client. The attribute list is unpacked,
--   checked and prepared(defaults) in procedure Unpack_Check_Update___.
--   action_ = 'DO'
--   Modification of an existing instance of the logical unit. The
--   procedure unpacks the attributes, checks all values before
--   procedure Update___ is called.
PROCEDURE Modify__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
BEGIN
   IF (action_ = 'DO') THEN
      Modify_Invoice_Head___(attr_, objid_);
   END IF;
   info_ := Client_SYS.Get_All_Info;
END Modify__;


-- Modify_Invoice_Complete__
--   Modifies the invoice header by calling Customer_Invoice_Pub_Util.
--   Returns 1 if OK otherwise 0.
PROCEDURE Modify_Invoice_Complete__ (
   status_        IN OUT NUMBER,
   company_       IN VARCHAR2,
   invoice_id_    IN NUMBER,
   invoice_lines_changed_ IN BOOLEAN DEFAULT FALSE)
IS
BEGIN
   Customer_Invoice_Pub_Util_API.Modify_Invoice_Complete('CUSTOMER_ORDER_INV_HEAD_API', company_, invoice_id_, invoice_lines_changed_);
   status_ := 1;
END Modify_Invoice_Complete__;


-- Get_Series_Reference__
--   Returns series reference.
@UncheckedAccess
FUNCTION Get_Series_Reference__ (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ CUSTOMER_ORDER_INV_HEAD.series_reference%TYPE;
   CURSOR get_attr IS
      SELECT series_reference
      FROM CUSTOMER_ORDER_INV_HEAD
      WHERE company    = company_
      AND   invoice_id = invoice_id_;

BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Series_Reference__;



-- Check_Advance_Inv_Exist__
--   Checks and if an advance invoices exists for the order
@UncheckedAccess
FUNCTION Check_Advance_Inv_Exist__ (
   order_no_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   exist_ NUMBER;

   CURSOR advance_inv_exist IS
      SELECT 1
        FROM CUSTOMER_ORDER_INV_HEAD
       WHERE creators_reference = order_no_
         AND advance_invoice    = 'TRUE';
BEGIN
   OPEN  advance_inv_exist;
   FETCH advance_inv_exist INTO exist_;
   CLOSE advance_inv_exist;

   IF (exist_ = 1 ) THEN
      RETURN TRUE;
   ELSE
      RETURN FALSE;
   END IF;
END Check_Advance_Inv_Exist__;



-- Check_Connected_Co_Exist__
--   Checks whether the connected customer order is available, if order_no_
--   is available. And checks whether all connected customer orders are
--   available for collective invoices.
@UncheckedAccess
FUNCTION Check_Connected_Co_Exist__ (
   company_      IN VARCHAR2,
   invoice_id_   IN NUMBER,
   order_no_     IN VARCHAR2,
   invoice_type_ IN VARCHAR2 ) RETURN NUMBER
IS
   CURSOR get_item_orders IS
      SELECT DISTINCT order_no 
         FROM customer_order_inv_join
         WHERE company = company_
         AND invoice_id = invoice_id_
         AND objstate != 'Cancelled'
         AND charge_seq_no IS NULL;
BEGIN
   IF (order_no_ IS NOT NULL) THEN      
      RETURN Customer_Order_API.Is_Order_Exist(order_no_);
   ELSE  
      IF (invoice_type_ = 'CUSTCOLDEB') THEN
         FOR item_order_ IN get_item_orders LOOP
            IF (Customer_Order_API.Is_Order_Exist(item_order_.order_no) = 0) THEN
               RETURN 0;
            END IF;
         END LOOP;
         RETURN 1;
      ELSE
         RETURN 1;
      END IF;
   END IF;  
END  Check_Connected_Co_Exist__; 

@UncheckedAccess
FUNCTION Get_First_Co_To_Invoice__ (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER ) RETURN VARCHAR2
IS
   order_no_ VARCHAR2(12);
   CURSOR get_invoice_order IS
      SELECT  order_no
        FROM  CUSTOMER_ORDER_INV_ITEM
       WHERE  company = company_
         AND  invoice_id = invoice_id_
         AND  order_no IS NOT NULL
         AND  rownum = 1;
BEGIN
   OPEN get_invoice_order;
   FETCH get_invoice_order INTO order_no_;
   CLOSE get_invoice_order;
   
   RETURN order_no_;
END Get_First_Co_To_Invoice__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Identity (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ CUSTOMER_ORDER_INV_HEAD.identity%TYPE;
   CURSOR get_attr IS
      SELECT identity
      FROM CUSTOMER_ORDER_INV_HEAD
      WHERE company = company_
      AND   invoice_id = invoice_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Identity;



-- Get_Delivery_Identity
--   Returns Delivery_Identity for a given invoice.
@UncheckedAccess
FUNCTION Get_Delivery_Identity (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ CUSTOMER_ORDER_INV_HEAD.delivery_identity%TYPE;
   CURSOR get_attr IS
      SELECT delivery_identity
      FROM   CUSTOMER_ORDER_INV_HEAD
      WHERE  company = company_
      AND    invoice_id = invoice_id_;   
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_; 
END Get_Delivery_Identity;  



-- Get_Series_Id
--   Returns Series_Id
@UncheckedAccess
FUNCTION Get_Series_Id (
   company_    IN VARCHAR2,
   party_type_ IN VARCHAR2,
   party_      IN VARCHAR2,
   invoice_id_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ CUSTOMER_ORDER_INV_HEAD.series_id%TYPE;
   CURSOR get_attr IS
      SELECT series_id
      FROM CUSTOMER_ORDER_INV_HEAD
      WHERE company = company_
      AND   invoice_id = invoice_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Series_Id;



-- Get_Invoice_No
--   Returns Invoice_No
@UncheckedAccess
FUNCTION Get_Invoice_No (
   company_    IN VARCHAR2,
   party_type_ IN VARCHAR2,
   party_      IN VARCHAR2,
   invoice_id_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ CUSTOMER_ORDER_INV_HEAD.invoice_no%TYPE;
   CURSOR get_attr IS
      SELECT invoice_no
      FROM CUSTOMER_ORDER_INV_HEAD
      WHERE company = company_
      AND   invoice_id = invoice_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Invoice_No;



-- Get_Invoice_Type
--   Returns Invoice_Type
@UncheckedAccess
FUNCTION Get_Invoice_Type (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ CUSTOMER_ORDER_INV_HEAD.invoice_type%TYPE;
   CURSOR get_attr IS
      SELECT invoice_type
      FROM CUSTOMER_ORDER_INV_HEAD
      WHERE company = company_
      AND   invoice_id = invoice_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Invoice_Type;



-- Get_Curr_Rate
--   Returns currency rate
@UncheckedAccess
FUNCTION Get_Curr_Rate (
   company_    IN VARCHAR2,
   party_type_ IN VARCHAR2,
   party_      IN VARCHAR2,
   invoice_id_ IN NUMBER ) RETURN NUMBER
IS
   temp_ CUSTOMER_ORDER_INV_HEAD.curr_rate%TYPE;
   CURSOR get_attr IS
      SELECT curr_rate
      FROM CUSTOMER_ORDER_INV_HEAD
      WHERE company = company_
      AND   invoice_id = invoice_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Curr_Rate;



-- Get_Delivery_Address_Id
--   Returns Delivery_Address_Id for a given invoice.
@UncheckedAccess
FUNCTION Get_Delivery_Address_Id (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ CUSTOMER_ORDER_INV_HEAD.delivery_address_id%TYPE;
   CURSOR get_attr IS
      SELECT delivery_address_id
      FROM   CUSTOMER_ORDER_INV_HEAD
      WHERE  company = company_
      AND    invoice_id = invoice_id_;   
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_; 
END Get_Delivery_Address_Id;



-- Get_Invoice_Address_Id
--   Returns Invoice_Address_Id for a given invoice.
@UncheckedAccess
FUNCTION Get_Invoice_Address_Id (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ CUSTOMER_ORDER_INV_HEAD.invoice_address_id%TYPE;
   CURSOR get_attr IS
      SELECT invoice_address_id
      FROM   CUSTOMER_ORDER_INV_HEAD
      WHERE  company = company_
      AND    invoice_id = invoice_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Invoice_Address_Id;



-- Get_Div_Factor
--   Returns div factor.
@UncheckedAccess
FUNCTION Get_Div_Factor (
   company_    IN VARCHAR2,
   party_type_ IN VARCHAR2,
   party_      IN VARCHAR2,
   invoice_id_ IN NUMBER ) RETURN NUMBER
IS
   temp_ CUSTOMER_ORDER_INV_HEAD.div_factor%TYPE;
   CURSOR get_attr IS
      SELECT div_factor
      FROM CUSTOMER_ORDER_INV_HEAD
      WHERE company = company_
      AND   invoice_id = invoice_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Div_Factor;



-- Get_Invoice_Date
--   Returns invoice date.
@UncheckedAccess
FUNCTION Get_Invoice_Date (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER ) RETURN DATE
IS
   temp_ CUSTOMER_ORDER_INV_HEAD.invoice_date%TYPE;
   CURSOR get_attr IS
      SELECT invoice_date
      FROM CUSTOMER_ORDER_INV_HEAD
      WHERE company = company_
      AND   invoice_id = invoice_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Invoice_Date;



-- Get_Name
--   Returns the customers name.
@UncheckedAccess
FUNCTION Get_Name (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ CUSTOMER_ORDER_INV_HEAD.name%TYPE;
   CURSOR get_attr IS
      SELECT name
      FROM CUSTOMER_ORDER_INV_HEAD
      WHERE company = company_
      AND   invoice_id = invoice_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Name;



-- Get_Currency
--   Returns the currency code.
@UncheckedAccess
FUNCTION Get_Currency (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ CUSTOMER_ORDER_INV_HEAD.currency%TYPE;
   CURSOR get_attr IS
      SELECT currency
      FROM CUSTOMER_ORDER_INV_HEAD
      WHERE company = company_
      AND   invoice_id = invoice_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Currency;



-- Get_Pay_Term_Id
--   Returns the paymentterm ID
@UncheckedAccess
FUNCTION Get_Pay_Term_Id (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ CUSTOMER_ORDER_INV_HEAD.pay_term_id%TYPE;
   CURSOR get_attr IS
      SELECT pay_term_id
      FROM CUSTOMER_ORDER_INV_HEAD
      WHERE company = company_
      AND   invoice_id = invoice_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Pay_Term_Id;


-- Get_Creators_Reference
-- Returns the Get_Creators_Reference
@UncheckedAccess
FUNCTION Get_Creators_Reference (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ CUSTOMER_ORDER_INV_HEAD.creators_reference%TYPE;
   CURSOR get_attr IS
      SELECT creators_reference
      FROM  CUSTOMER_ORDER_INV_HEAD
      WHERE company = company_
      AND   invoice_id = invoice_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Creators_Reference;


-- Get_Correction_Invoice_Id
--   Returns the correction invoice id
@UncheckedAccess
FUNCTION Get_Correction_Invoice_Id (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER ) RETURN NUMBER
IS
   temp_ CUSTOMER_ORDER_INV_HEAD.correction_invoice_id%TYPE;
   CURSOR get_attr IS
      SELECT correction_invoice_id
      FROM  CUSTOMER_ORDER_INV_HEAD
      WHERE company = company_
      AND   invoice_id = invoice_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Correction_Invoice_Id;



-- Get_Tax_Curr_Rate
--   Retrives the Tax currency rate
@UncheckedAccess
FUNCTION Get_Tax_Curr_Rate (
   company_       IN VARCHAR2,
   invoice_id_    IN NUMBER ) RETURN NUMBER
IS
   temp_    CUSTOMER_ORDER_INV_HEAD.tax_curr_rate%TYPE;
   CURSOR get_attr IS
      SELECT tax_curr_rate
      FROM CUSTOMER_ORDER_INV_HEAD
      WHERE company = company_
      AND   invoice_id = invoice_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Tax_Curr_Rate;

-- Get_Contract
--   Retrives the site of the invoice
@UncheckedAccess
@IgnoreUnitTest TrivialFunction
FUNCTION Get_Contract (
   company_       IN VARCHAR2,
   invoice_id_    IN NUMBER ) RETURN VARCHAR2
IS
   temp_    CUSTOMER_ORDER_INV_HEAD.contract%TYPE;
   CURSOR get_attr IS
      SELECT contract
      FROM CUSTOMER_ORDER_INV_HEAD
      WHERE company = company_
      AND   invoice_id = invoice_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Contract;

-- Create_Invoice_Head
--   Creates a new invoice head in module INVOICE
-- gelr:prepayment_tax_document, added prepay_adv_inv_id_, prepayment_type_code_
PROCEDURE Create_Invoice_Head (
   invoice_id_              IN OUT NUMBER,
   company_                 IN     VARCHAR2,
   order_no_                IN     VARCHAR2,
   customer_no_             IN     VARCHAR2,
   customer_no_pay_         IN     VARCHAR2,
   authorize_name_          IN     VARCHAR2,
   date_entered_            IN     DATE,
   cust_ref_                IN     VARCHAR2,
   ship_via_desc_           IN     VARCHAR2,
   forward_agent_id_        IN     VARCHAR2,
   label_note_              IN     VARCHAR2,
   delivery_terms_desc_     IN     VARCHAR2,
   del_terms_location_      IN     VARCHAR2,
   pay_term_id_             IN     VARCHAR2,
   currency_code_           IN     VARCHAR2,
   ship_addr_no_            IN     VARCHAR2,
   customer_no_pay_addr_no_ IN     VARCHAR2,
   bill_addr_no_            IN     VARCHAR2,
   wanted_delivery_date_    IN     DATE,
   invoice_type_            IN     VARCHAR2,
   number_reference_        IN     VARCHAR2,
   series_reference_        IN     VARCHAR2,
   contract_                IN     VARCHAR2,
   js_invoice_state_db_     IN     VARCHAR2,
   currency_rate_type_      IN     VARCHAR2,
   collect_                 IN     VARCHAR2     DEFAULT 'FALSE',
   rma_no_                  IN     NUMBER       DEFAULT  NULL,
   shipment_id_             IN     NUMBER       DEFAULT  NULL,
   adv_invoice_             IN     VARCHAR2     DEFAULT  NULL,
   adv_pay_base_date_       IN     DATE         DEFAULT  NULL,
   sb_reference_no_         IN     VARCHAR2     DEFAULT  NULL,
   use_ref_inv_curr_rate_   IN     VARCHAR2     DEFAULT 'FALSE',
   ledger_item_id_          IN     VARCHAR2     DEFAULT  NULL,
   ledger_item_series_id_   IN     VARCHAR2     DEFAULT  NULL,
   ledger_item_version_id_  IN     NUMBER       DEFAULT  NULL,
   aggregation_no_          IN     NUMBER       DEFAULT  NULL,   
   final_settlement_        IN     VARCHAR2     DEFAULT 'FALSE',
   project_id_              IN     VARCHAR2     DEFAULT  NULL,
   tax_id_number_           IN     VARCHAR2     DEFAULT  NULL,
   tax_id_type_             IN     VARCHAR2     DEFAULT  NULL,
   branch_                  IN     VARCHAR2     DEFAULT  NULL,
   supply_country_db_       IN     VARCHAR2     DEFAULT  NULL,
   invoice_date_            IN     DATE         DEFAULT  NULL,
   use_price_incl_tax_db_   IN     VARCHAR2     DEFAULT 'FALSE',
   wht_amount_base_         IN     VARCHAR2     DEFAULT  NULL, 
   curr_rate_new_           IN     NUMBER       DEFAULT  NULL,
   tax_curr_rate_new_       IN     NUMBER       DEFAULT  NULL,
   correction_reason_id_    IN     VARCHAR2     DEFAULT  NULL,
   correction_reason_       IN     VARCHAR2     DEFAULT  NULL,
   is_simulated_            IN     VARCHAR2     DEFAULT 'FALSE',
   invoice_reason_id_       IN     VARCHAR2     DEFAULT  NULL,
   service_code_            IN     VARCHAR2     DEFAULT  NULL,
   prepay_adv_inv_id_       IN     NUMBER       DEFAULT  NULL,
   prepayment_type_code_    IN     VARCHAR2     DEFAULT  NULL)
IS
   site_date_           DATE;
   currency_rate_       NUMBER;               -- Currency rate used in order (never inverted)
   fin_curr_rate_       NUMBER;               -- Currency rate used in Finance (could be inverted)
   tax_curr_rate_       NUMBER;
   inverted_            VARCHAR2(5);
   currency_type_       VARCHAR2(10);
   base_currency_code_  VARCHAR2(3);
   conv_factor_         NUMBER;               -- Conversion factor (same for both currency rates)
   pay_term_base_date_  DATE;
   head_rec_            Customer_Invoice_Pub_Util_API.customer_invoice_head_rec;
   ref_inv_rec_         Customer_Order_Inv_Head_API.Public_Rec;
   ref_invoice_id_      NUMBER;
   cust_ord_cor_        VARCHAR2(20);
   cust_col_cor_        VARCHAR2(20);
   invoic_date_         DATE;
   tax_curr_rate_type_  VARCHAR2(10);
BEGIN   
   -- Make sure pay terms have been defined otherwise an error will occur when creating the invoice
   IF (pay_term_id_ IS NULL) THEN
      IF (collect_ = 'FALSE') THEN
         Error_SYS.Record_General(lu_name_, 'NOORDERPAYTERM: Payment terms are missing for order :P1. No invoice created', order_no_);
      ELSE
         Error_SYS.Record_General(lu_name_, 'NOPAYTERMS: Payment terms are missing. No collective invoice created for customer :P1', customer_no_);
      END IF;
   END IF;
   -- Retrive the current date.
   IF (contract_ IS NOT NULL) THEN
      site_date_ := Site_API.Get_Site_Date(contract_);
   ELSE
      site_date_ := Site_API.Get_Site_Date(User_Default_API.Get_Contract);
   END IF;
   IF (invoice_date_ IS NOT NULL) THEN
      invoic_date_ := invoice_date_;
   ELSE
      invoic_date_ := site_date_;
   END IF;
   
   IF (use_ref_inv_curr_rate_ = 'TRUE') THEN
      ref_invoice_id_     := Get_Invoice_Id_By_No(company_, number_reference_, series_reference_);
      ref_inv_rec_        := CUSTOMER_ORDER_INV_HEAD_API.Get(company_, ref_invoice_id_);
      fin_curr_rate_      := ref_inv_rec_.fin_curr_rate;      
      conv_factor_        := ref_inv_rec_.div_factor;
      currency_rate_      := ref_inv_rec_.curr_rate;
      currency_type_      := ref_inv_rec_.currency_rate_type;
      IF (adv_invoice_ = 'TRUE') THEN
         tax_curr_rate_      := ref_inv_rec_.curr_rate;
      ELSE
         tax_curr_rate_type_ := Currency_Type_Basic_Data_API.Get_Tax_Sell(company_);
         tax_curr_rate_      := ref_inv_rec_.tax_curr_rate;
      END IF; 
      IF(curr_rate_new_ IS NOT NULL OR tax_curr_rate_new_ IS NOT NULL) THEN
         fin_curr_rate_ :=   curr_rate_new_;
         tax_curr_rate_ :=   tax_curr_rate_new_;       
      END IF;
   ELSE
      -- This will be the rate used in Finance saved in the CURR_RATE_COLUMN
      base_currency_code_ := Company_Finance_API.Get_Currency_Code(company_);
      currency_type_ := currency_rate_type_; 
      IF currency_type_ IS NULL THEN
         IF (order_no_ IS NOT NULL) THEN
            currency_type_ := Customer_Order_API.get_currency_rate_type(order_no_); 
         END IF;
         -- This code is exectued when the order_no_ is null or when the order doesn't have a currency code.        
         IF (currency_type_ IS NULL) THEN
            currency_type_ := Invoice_Library_API.Get_Default_Currency_Type(company_, 'CUSTOMER',
                                                                         NVL(customer_no_pay_, customer_no_));
         END IF;
      END IF;      
      Currency_Rate_API.Fetch_Currency_Rate_Base(conv_factor_, fin_curr_rate_, inverted_, company_,
                                                 currency_code_, base_currency_code_, currency_type_,
                                                 invoic_date_,
                                                 Currency_Code_API.Get_Emu(company_, base_currency_code_));
      
      -- This will return an uninverted rate even if the currency rate for this currency should be inverted
      Invoice_Library_API.Get_Currency_Rate_Defaults(currency_type_, conv_factor_, currency_rate_,
                                                     company_,currency_code_, invoic_date_, 'CUSTOMER',
                                                     NVL(customer_no_pay_, customer_no_));
      
      IF (adv_invoice_ = 'TRUE') THEN
         tax_curr_rate_      := fin_curr_rate_;
      ELSE
         tax_curr_rate_type_ := Currency_Type_Basic_Data_API.Get_Tax_Sell(company_); 
         tax_curr_rate_      := Tax_Handling_Invoic_Util_API.Get_Tax_Curr_Rate(company_, 
                                                                               'CUSTOMER', 
                                                                               currency_code_,
                                                                               'CUSTOMER_ORDER_INV_HEAD_API',
                                                                               fin_curr_rate_,
                                                                               invoic_date_);              
      END IF;                                                                                          
   END IF;


   IF (order_no_ IS NOT NULL) THEN
      pay_term_base_date_ := Customer_Order_API.Get_Pay_Term_Base_Date(order_no_);
      IF (pay_term_base_date_ IS NULL) THEN
         pay_term_base_date_ := invoic_date_;
      END IF;
   ELSE
      pay_term_base_date_ := invoic_date_;
   END IF;
   
   -- Create head_data
   head_rec_.company             := company_;
   head_rec_.invoice_type        := invoice_type_;
   head_rec_.creator             := 'CUSTOMER_ORDER_INV_HEAD_API';
   head_rec_.identity            := NVL(customer_no_pay_, customer_no_);
   head_rec_.delivery_identity   := customer_no_;
   head_rec_.invoice_date        := invoic_date_;
   head_rec_.pay_term_id         := pay_term_id_;
   head_rec_.delivery_address_id := ship_addr_no_;
   head_rec_.invoice_address_id  := NVL(customer_no_pay_addr_no_, bill_addr_no_);
   head_rec_.d3                  := wanted_delivery_date_;     -- WANTED_DELIVERY_DATE
   head_rec_.currency            := currency_code_;
   head_rec_.curr_rate           := fin_curr_rate_;   
   head_rec_.tax_curr_type       := tax_curr_rate_type_; 
   head_rec_.tax_curr_rate       := tax_curr_rate_;
   head_rec_.div_factor          := conv_factor_;
   head_rec_.collect             := collect_;
   head_rec_.series_reference    := series_reference_;
   head_rec_.number_reference    := number_reference_;
   head_rec_.creators_reference  := order_no_;
   head_rec_.aff_base_ledg_post  := 'FALSE';
   head_rec_.aff_line_post       := 'FALSE';
   head_rec_.d1                  := date_entered_;             -- ORDER_DATE
   head_rec_.c1                  := authorize_name_;           -- OUR_REFERENCE
   head_rec_.c2                  := cust_ref_;                 -- YOUR_REFERENCE
   head_rec_.c3                  := ship_via_desc_;            -- SHIP_VIA
   head_rec_.c4                  := forward_agent_id_;         -- FORWARD_AGENT_ID
   head_rec_.c5                  := label_note_;               -- LABEL_NOTE
   head_rec_.c6                  := delivery_terms_desc_;      -- DELIVERY_TERMS
   head_rec_.c7                  := contract_;                 -- CONTRACT
   head_rec_.c8                  := use_ref_inv_curr_rate_;    -- USE_REF_INV_CURR_RATE
   head_rec_.c11                 := currency_type_;    
   head_rec_.c9                  := ledger_item_id_;           -- LEDGER_ITEM_ID
   head_rec_.c10                 := ledger_item_series_id_;    -- LEDGER_ITEM_SERIES_ID
   head_rec_.c12                 := del_terms_location_;       -- DEL_TERMS_LOCATION
   head_rec_.n1                  := currency_rate_;            -- CURR RATE (noninverted used in order)
   head_rec_.n2                  := rma_no_;                   -- RMA number. Used for credit invoices from RMA
   head_rec_.n3                  := shipment_id_;              -- SHIPMENT ID. Used for collective invoices for Shipments.
   head_rec_.n4                  := ledger_item_version_id_;   -- LEDGER_ITEM_VERSION_ID
   head_rec_.branch              := NVL(branch_, Invoice_Customer_Order_API.Get_Branch(company_, contract_, customer_no_));
   head_rec_.pay_term_base_date  := pay_term_base_date_;
   head_rec_.self_billing_ref    := sb_reference_no_;
   head_rec_.js_invoice_state_db := js_invoice_state_db_;
   head_rec_.creation_date       := site_date_;
   head_rec_.n5                  := aggregation_no_;
   head_rec_.c13                 := final_settlement_;
   head_rec_.c14                 := use_price_incl_tax_db_;
   head_rec_.tax_id_number       := tax_id_number_;
   head_rec_.tax_id_type         := tax_id_type_;
   head_rec_.supply_country      := supply_country_db_;
   head_rec_.wht_amount_base     := wht_amount_base_;
   head_rec_.adv_inv := 'FALSE';
   head_rec_.correction_reason_id := correction_reason_id_;
   head_rec_.correction_reason    := correction_reason_;
   head_rec_.prepayment_type_code := NVL(prepayment_type_code_, Fetch_Prepayment_Type(company_, invoice_type_, adv_invoice_, number_reference_, series_reference_));
   head_rec_.is_simulated         := is_simulated_;
   -- gelr:invoice_reason, begin
   IF (Company_Localization_Info_API.Get_Parameter_Value_Db(company_, 'INVOICE_REASON') = Fnd_Boolean_API.DB_TRUE) THEN
      IF (invoice_reason_id_ IS NOT NULL) THEN
         head_rec_.invoice_reason_id := invoice_reason_id_;
      END IF;
   END IF;
   -- gelr:invoice_reason, end
   -- gelr:fr_service_code, begin
   IF (Company_Localization_Info_API.Get_Parameter_Value_Db(company_, 'FR_SERVICE_CODE') = Fnd_Boolean_API.DB_TRUE) THEN
      head_rec_.service_code := service_code_;
   END IF;
   -- gelr:fr_service_code, end   
   IF ( adv_invoice_ = 'TRUE' ) THEN
      head_rec_.pay_term_base_date := adv_pay_base_date_;
      head_rec_.d3 := NULL;
      head_rec_.collect := 'FALSE';
      head_rec_.adv_inv := 'TRUE';
   END IF;

   cust_ord_cor_ := Company_Def_Invoice_Type_API.Get_Def_Co_Cor_Inv_Type(company_);
   cust_col_cor_ := Company_Def_Invoice_Type_API.Get_Def_Col_Cor_Inv_Type(company_);
   IF ((rma_no_ IS NULL) AND (invoice_type_ IN ('CUSTORDCRE', 'CUSTCOLCRE', 'SELFBILLCRE', cust_ord_cor_, cust_col_cor_) AND (tax_curr_rate_new_ IS NULL))) THEN
      head_rec_.price_adjustment := 'TRUE';
   ELSE
      head_rec_.price_adjustment := 'FALSE';
   END IF;

   IF (order_no_ IS NOT NULL) THEN
      head_rec_.project_id       := Customer_Order_API.Get_Project_Id(order_no_);
   ELSE
      head_rec_.project_id       := project_id_;
   END IF;

   -- gelr:alt_invoice_no_per_branch, begin
   IF (Company_Localization_Info_API.Get_Parameter_Value_Db(company_, 'ALT_INVOICE_NO_PER_BRANCH') = Fnd_Boolean_API.DB_TRUE) THEN
      IF invoice_type_ = 'CUSTCOLDEB' THEN
         head_rec_.component_a := Off_Inv_Num_Comp_Series_API.Get_Default_Component(company_, head_rec_.branch);
      ELSE
         head_rec_.component_a := Customer_Order_API.Get_Component_A(order_no_);
      END IF;

      IF Company_Invoice_Info_API.Get_Generate_Official_Inv_N_Db(company_) = Generate_Official_Inv_No_API.DB_AT_PREL_INVOICE THEN
         Off_Inv_Num_comp_Series_API.Get_Next_Alt_Inv_Number(head_rec_.component_b, head_rec_.component_c, head_rec_.serial_number, company_, head_rec_.branch, head_rec_.component_a);
         head_rec_.official_invoice_no := Off_Inv_Num_Comp_Series_API.Get_Official_Number(company_, NULL, head_rec_.component_a, head_rec_.component_b, head_rec_.component_c, head_rec_.serial_number);
      END IF;
   END IF;
   -- gelr:alt_invoice_no_per_branch, end
   
   -- gelr:out_inv_curr_rate_voucher_date, begin
   IF (Company_Localization_Info_API.Get_Parameter_Value_Db(company_, 'OUT_INV_CURR_RATE_VOUCHER_DATE') = Fnd_Boolean_API.DB_TRUE) THEN
      IF ((head_rec_.invoice_type IN ('CUSTORDDEB','CUSTCOLDEB',Company_Def_Invoice_Type_API.Get_Def_Co_Prepay_Deb_Inv_Type(company_))) AND (head_rec_.number_reference IS NULL)) THEN
         Out_Invoice_Util_Pub_API.Get_Out_Inv_Base_Dates(head_rec_.out_inv_vou_date_base, head_rec_.out_inv_curr_rate_base, head_rec_.tax_sell_curr_rate_base, head_rec_.identity, head_rec_.delivery_address_id, company_);
      END IF;
   END IF;
   -- gelr:out_inv_curr_rate_voucher_date, end 
   -- gelr:prepayment_tax_document, begin
   IF (adv_invoice_ != 'TRUE') THEN
      IF (Company_Localization_Info_API.Get_Parameter_Value_Db(company_, 'PREPAYMENT_TAX_DOCUMENT') = Fnd_Boolean_API.DB_TRUE) THEN
         head_rec_.prepay_adv_inv_id := prepay_adv_inv_id_;         
      END IF;
   END IF;
   -- gelr:prepayment_tax_document, end
   -- Create the invoice head in invoice.
   Customer_Invoice_Pub_Util_API.Create_Invoice_Head(head_rec_);   
     
   -- Return the invoice id of the created invoice.
   invoice_id_ := head_rec_.invoice_id;

   -- Copy all connected document attached to CustomerOrder
   IF (order_no_ IS NOT NULL AND is_simulated_ = 'FALSE' )THEN
      Copy_Connected_Objects___(company_,
                                invoice_id_,
                                order_no_);
   END IF;
END Create_Invoice_Head;


-- Create_Invoice_Complete
--   Should be called when the last invoice line has been created to
--   allow the INVOICE module to do it's stuff.
PROCEDURE Create_Invoice_Complete (
   company_              IN VARCHAR2,
   invoice_id_           IN NUMBER,
   allow_credit_inv_fee_ IN VARCHAR2 DEFAULT 'TRUE' )
IS
   -- gelr:prepayment_tax_document, begin
   inv_rec_      Invoice_API.Public_Rec;
   -- gelr:prepayment_tax_document, end
BEGIN
   Modify_Invoice_Details____(company_, invoice_id_);
   Customer_Invoice_Pub_Util_API.Complete_Invoice(company_, invoice_id_, allow_credit_inv_fee_);
   Cust_Order_Invoice_Hist_API.New(company_, invoice_id_, Language_SYS.Translate_Constant(lu_name_, 'INVHISTCREATED: Invoice Created',NULL));
   -- gelr:prepayment_tax_document, begin
   IF (Company_Localization_Info_API.Get_Parameter_Value_Db(company_, 'PREPAYMENT_TAX_DOCUMENT') = Fnd_Boolean_API.DB_TRUE) THEN      
      inv_rec_ := Invoice_API.Get(company_, invoice_id_);
      IF  (inv_rec_.invoice_type = 'CUSTORDDEB') THEN
         Advance_Inv_Reference_API.Adv_Invoices_For_Matching(invoice_id_, company_, inv_rec_.identity, inv_rec_.creators_reference, inv_rec_.currency, inv_rec_.net_curr_amount + inv_rec_.vat_curr_amount); 
         $IF Component_Payled_SYS.INSTALLED $THEN
            Ledger_Transaction_Api.Offset_Saved_Adv_Inv(company_, invoice_id_);
         $END
      END IF;
   END IF;
   -- gelr:prepayment_tax_document, end 
END Create_Invoice_Complete;


-- Get_Invoice_Type_Date
--   Returns the invoice_type and invoice_date for a specified invoice_id.
PROCEDURE Get_Invoice_Type_Date (
   invoice_type_ OUT VARCHAR2,
   invoice_date_ OUT DATE,
   company_      IN  VARCHAR2,
   invoice_id_   IN  NUMBER )
IS
   CURSOR get_head IS
      SELECT invoice_type, invoice_date
      FROM   CUSTOMER_ORDER_INV_HEAD
      WHERE  invoice_id = invoice_id_
      AND    company = company_;
BEGIN
   OPEN get_head;
   FETCH get_head INTO invoice_type_, invoice_date_;
   CLOSE get_head;
END Get_Invoice_Type_Date;


-- Invoice_Credit_Total
--   Returns the total for a specified customer and invoice_type.
@UncheckedAccess
FUNCTION Invoice_Credit_Total (
   customer_no_  IN VARCHAR2,
   invoice_type_ IN VARCHAR2 ) RETURN NUMBER
IS
   invoice_total_  CUSTOMER_ORDER_INV_HEAD.net_amount%TYPE;
   CURSOR get_credit_total IS
      SELECT SUM(net_amount * curr_rate)
      FROM   CUSTOMER_ORDER_INV_HEAD
      WHERE  NVL(identity, delivery_identity) = customer_no_
      AND    invoice_type = invoice_type_
      AND    objstate IN ('Preliminary', 'Printed');
BEGIN
   OPEN get_credit_total;
   FETCH get_credit_total INTO invoice_total_;
   IF get_credit_total%NOTFOUND THEN
      invoice_total_ := 0;
   END IF;
   CLOSE get_credit_total;
   RETURN NVL(invoice_total_, 0);
END Invoice_Credit_Total;



-- Get_Preliminary_Invoice_Id
--   Retrieve the invoice_id for the specified order_no and invoice_type.
--   Only one invoice with status 'Preliminary' should exist.
@UncheckedAccess
FUNCTION Get_Preliminary_Invoice_Id (
   order_no_     IN VARCHAR2,
   invoice_type_ IN VARCHAR2 ) RETURN NUMBER
IS
   invoice_id_    CUSTOMER_ORDER_INV_HEAD.invoice_id%TYPE;
   CURSOR get_invoice_id IS
      SELECT invoice_id
      FROM   CUSTOMER_ORDER_INV_HEAD
      WHERE  creators_reference = order_no_
      AND    invoice_type = invoice_type_
      AND    objstate = 'Preliminary';
BEGIN
   OPEN get_invoice_id;
   FETCH get_invoice_id INTO invoice_id_;
   IF (get_invoice_id%NOTFOUND) THEN
      invoice_id_ := NULL;
   END IF;
   CLOSE get_invoice_id;
   RETURN invoice_id_;
END Get_Preliminary_Invoice_Id;



-- Get_Invoice_Status
--   Return the invoice status for the specified company and invoice id.
@UncheckedAccess
FUNCTION Get_Invoice_Status (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER ) RETURN VARCHAR2
IS
   client_state_ CUSTOMER_ORDER_INV_HEAD.client_state%TYPE;
   CURSOR get_invoice_status IS
      SELECT client_state
      FROM CUSTOMER_ORDER_INV_HEAD_ALL
      WHERE company = company_
      AND   invoice_id = invoice_id_;
BEGIN
   OPEN get_invoice_status;
   FETCH get_invoice_status INTO client_state_;
   IF (get_invoice_status%NOTFOUND) THEN
      client_state_ := NULL;
   END IF;
   CLOSE get_invoice_status;
   RETURN client_state_;
END Get_Invoice_Status;


-- Get_Invoice_Status_Db
--   Return the invoice status(db value) for the specified company and invoice id.
@UncheckedAccess
FUNCTION Get_Invoice_Status_Db (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER ) RETURN VARCHAR2
IS
   db_state_ CUSTOMER_ORDER_INV_HEAD.objstate%TYPE;
   CURSOR get_invoice_status IS
      SELECT objstate
      FROM CUSTOMER_ORDER_INV_HEAD_ALL
      WHERE company = company_
      AND   invoice_id = invoice_id_;
BEGIN
   OPEN get_invoice_status;
   FETCH get_invoice_status INTO db_state_;
   IF (get_invoice_status%NOTFOUND) THEN
      db_state_ := NULL;
   END IF;
   CLOSE get_invoice_status;
   RETURN db_state_;
END Get_Invoice_Status_Db;

-- Get_Series_Id_By_Id
--   Return the series id for the invoice with the specified invoice id.
@UncheckedAccess
FUNCTION Get_Series_Id_By_Id (
   invoice_id_ IN NUMBER ) RETURN VARCHAR2
IS
   series_id_ CUSTOMER_ORDER_INV_HEAD.series_id%TYPE;
   CURSOR get_series_id IS
      SELECT series_id
      FROM   CUSTOMER_ORDER_INV_HEAD
      WHERE  invoice_id = invoice_id_
      AND    company > ' ';
BEGIN
   IF invoice_id_ IS NOT NULL THEN
      OPEN get_series_id;
      FETCH get_series_id INTO series_id_;
      IF (get_series_id%NOTFOUND) THEN
         series_id_ := NULL;
      END IF;
      CLOSE get_series_id;
   END IF;
   RETURN series_id_;
END Get_Series_Id_By_Id;



-- Get_Invoice_No_By_Id
--   Return the invoice no for the invoice with the specified invoice id.
@UncheckedAccess
FUNCTION Get_Invoice_No_By_Id (
   invoice_id_ IN NUMBER ) RETURN VARCHAR2
IS
   invoice_no_ CUSTOMER_ORDER_INV_HEAD.invoice_no%TYPE;
   CURSOR get_invoice_no IS
      SELECT invoice_no
      FROM   CUSTOMER_ORDER_INV_HEAD
      WHERE  invoice_id = invoice_id_
      AND    company > ' ';
BEGIN
   IF invoice_id_ IS NOT NULL THEN
      OPEN get_invoice_no;
      FETCH get_invoice_no INTO invoice_no_;
      IF (get_invoice_no%NOTFOUND) THEN
         invoice_no_ := NULL;
      END IF;
      CLOSE get_invoice_no;
   END IF;
   RETURN invoice_no_;
END Get_Invoice_No_By_Id;



@UncheckedAccess
FUNCTION Get_Fin_Curr_Rate (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER ) RETURN NUMBER
IS
   temp_ CUSTOMER_ORDER_INV_HEAD.fin_curr_rate%TYPE;
   CURSOR get_attr IS
      SELECT fin_curr_rate
      FROM CUSTOMER_ORDER_INV_HEAD
      WHERE company = company_
      AND   invoice_id = invoice_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Fin_Curr_Rate;



-- Get_Invoice_Id_By_No
--   Return the invoice id for the invoice with the specified invoice no.
@UncheckedAccess
FUNCTION Get_Invoice_Id_By_No (
   company_    IN VARCHAR2,
   invoice_no_ IN VARCHAR2,
   series_id_  IN VARCHAR2  ) RETURN NUMBER
IS
   invoice_id_ CUSTOMER_ORDER_INV_HEAD.invoice_id%TYPE;
   CURSOR get_invoice_id IS
      SELECT invoice_id
      FROM   CUSTOMER_ORDER_INV_HEAD
      WHERE  invoice_no = invoice_no_
      AND    series_id = series_id_
      AND    company = company_;
BEGIN
   OPEN get_invoice_id;
   FETCH get_invoice_id INTO invoice_id_;
   IF (get_invoice_id%NOTFOUND) THEN
      invoice_id_ := NULL;
   END IF;
   CLOSE get_invoice_id;
   RETURN invoice_id_;
END Get_Invoice_Id_By_No;



-- Print_Invoices
--   Prints invoices that are packed in attr_.
--   If the attribute string contains both collective invoices and ordinary
--   invoices two different print jobs will be created. The reason for this
--   is that different report methods and layouts are used for ordinary and
--   collective invoices.
PROCEDURE Print_Invoices (
   attr_ IN OUT VARCHAR2 )
IS
   ptr_                     NUMBER;
   name_                    VARCHAR2(30);
   value_                   VARCHAR2(2000);
   invoice_id_              CUSTOMER_ORDER_INV_HEAD.invoice_id%TYPE;
   collective_              CUSTOMER_ORDER_INV_HEAD.collect%TYPE;
   series_id_               CUSTOMER_ORDER_INV_HEAD.series_id%TYPE;
   inv_series_id_           CUSTOMER_ORDER_INV_HEAD.series_id%TYPE;
   invoice_no_              CUSTOMER_ORDER_INV_HEAD.invoice_no%TYPE; 
   company_                 CUSTOMER_ORDER_INV_HEAD.company%TYPE;
   objstate_                CUSTOMER_ORDER_INV_HEAD.objstate%TYPE;
   
   media_code_              VARCHAR2(30) := NULL;
   send_and_print_          VARCHAR2(5) := 'FALSE';
   report_id_               VARCHAR2(30);
   no_of_invoice_copies_    NUMBER;
   party_type_              CUSTOMER_ORDER_INV_HEAD.party_type%TYPE;
   identity_                CUSTOMER_ORDER_INV_HEAD.identity%TYPE;
   invoice_type_            CUSTOMER_ORDER_INV_HEAD.invoice_type%TYPE;
   print_type_              VARCHAR2(1);
   head_attr_               VARCHAR2(100);
   voucher_type_            VARCHAR2(3);
   voucher_date_            VARCHAR2(20);
   sbi_attr_                VARCHAR2(2000);
   error_info_              VARCHAR2(2000);
   is_advance_invoice_      VARCHAR2(5);
   send_                    VARCHAR2(5) ;
   tax_invoice_no_          VARCHAR2(50);
   inv_tax_invoice_no_      VARCHAR2(50);
   site_date_               DATE;
   print_option_            VARCHAR2(20);
   rebate_inv_type_         VARCHAR2(20);
   contract_                VARCHAR2(5);
   contact_                 VARCHAR2(100);
   email_address_           VARCHAR2(200);
   pay_term_id_             VARCHAR2(20);
   delivery_identity_       CUSTOMER_ORDER_INV_HEAD.delivery_identity%TYPE;

   previous_execution_id_   NUMBER;   
   doc_source_key_ref_      VARCHAR2(2000):= NULL;
   doc_source_lu_name_      VARCHAR2(100) := 'CustomerOrderInvHead';
   connected_objects_       VARCHAR2(5);
   flag_attr_               VARCHAR2(2000);
   send_error_              VARCHAR2(2000);
   stat_attr_               VARCHAR2(2000);
   prel_series_id_          CUSTOMER_ORDER_INV_HEAD.series_id%TYPE;
   invoice_number_          CUSTOMER_ORDER_INV_HEAD.invoice_no%TYPE;

   prepay_deb_inv_type_     VARCHAR2(20);
   prepay_cre_inv_type_     VARCHAR2(20);
   old_invoice_no_          CUSTOMER_ORDER_INV_HEAD.invoice_no%TYPE;
   old_series_id_           CUSTOMER_ORDER_INV_HEAD.series_id%TYPE;

   rebate_amt_base_         NUMBER;
   sales_part_rebate_group_ VARCHAR2(10);
   rebate_assortment_id_    VARCHAR2(50);
   rebate_assort_node_id_   VARCHAR2(50);
   cor_inv_type_            VARCHAR2(20);
   col_cor_inv_type_        VARCHAR2(20);
   corr_credit_invoice_     BOOLEAN := FALSE;
   
   isr_param_attr_          VARCHAR2(2000);
   party_type_cl_           VARCHAR2(200);
   your_reference_          CUSTOMER_ORDER_INV_HEAD.your_reference%TYPE;
   user_group_              VARCHAR2(30);   
   print_job_id_            NUMBER;
   withholding_msg_         VARCHAR2(32000) := NULL;  
   validate_bg_             VARCHAR2(5) := 'TRUE';
   date_changed_            BOOLEAN;
   result_keys_             VARCHAR2(32000);
   result_key_attr_         VARCHAR2(32000);
   print_online_            VARCHAR2(5):= 'FALSE';
   tax_method_              VARCHAR2(50);
   is_qr_code_              VARCHAR2(5);
   report_type_             VARCHAR2(200);
   transactions_created_    NUMBER;
   print_method_            VARCHAR2(16);
   -- gelr:prepayment_tax_document, begin
   comp_def_rec_            Company_Def_Invoice_Type_API.Public_Rec;
   -- gelr:prepayment_tax_document, end
   -- gelr:e-invoicing_compliance, begin
   compliance_media_code_   VARCHAR2(30);
   send_compliance_einv_    VARCHAR2(5) := 'FALSE';
   send_compl_exception_    EXCEPTION;
   -- gelr:e-invoicing_compliance, end   

   CURSOR get_invoice_data IS
      SELECT objstate, collect, company, party_type, identity, invoice_type, advance_invoice,
             series_id, tax_invoice_number, contract, pay_term_id, delivery_identity, invoice_no, your_reference
      FROM CUSTOMER_ORDER_INV_HEAD
      WHERE invoice_id = invoice_id_
      AND   company    > ' ';

   CURSOR get_sbi_info IS
      SELECT sbi_no, sbi_line_no
      FROM self_billing_item_tab
      WHERE invoice_id = invoice_id_;
 
   CURSOR get_connected_rma_lines IS
      SELECT rma_no, rma_line_no
      FROM return_material_line_tab
      WHERE debit_invoice_no        = old_invoice_no_
      AND   debit_invoice_series_id = old_series_id_
      AND   rowstate NOT IN ( 'Denied', 'Cancelled')
      AND   credit_invoice_no       IS NULL
      AND   company                 = company_;

   CURSOR get_inv_lines (company_ IN VARCHAR2, invoice_id_ IN VARCHAR2) IS
      SELECT item_id, identity
      FROM CUSTOMER_ORDER_INV_ITEM
      WHERE company    = company_
      AND   invoice_id = invoice_id_;
BEGIN
   -- If the attribute string contains a media code the invoice passed in the
   -- attribute string should be sent to the customer via EDI/MHS
   -- The attribute string will only contain one invoice in this case.
   media_code_        := Client_SYS.Get_Item_Value('MEDIA_CODE', attr_);
   send_              := Client_SYS.Get_Item_Value('SEND', attr_);
   print_type_        := Client_SYS.Get_Item_Value('PRINT_TYPE', attr_);
   email_address_     := Client_SYS.Get_Item_Value('EMAIL_ADDR', attr_);
   connected_objects_ := NVL(Client_SYS.Get_Item_Value('CONNECTED_OBJECTS', attr_), 'FALSE');
   user_group_        := Client_SYS.Get_Item_Value('USER_GROUP', attr_);
   voucher_date_      := Client_SYS.Attr_Value_To_Date(Client_SYS.Get_Item_Value('VOUCHER_DATE', attr_));
   
   IF Client_SYS.Item_Exist('PRINT_METHOD', attr_) THEN
      print_method_ := Client_SYS.Get_Item_Value('PRINT_METHOD', attr_);
   END IF;
   
   -- Print method is being set from the client and Customer_Order_Flow_API
   IF (print_method_ IS NOT NULL) THEN
      print_online_ := 'TRUE';
   END IF;
      
   IF (print_type_ IS NULL) THEN
      print_type_ := 'D';
   END IF;

   IF (send_ IS NULL AND media_code_ IS NOT NULL) THEN
      send_ := 'TRUE';
   END IF;

   IF (send_ = 'TRUE') THEN
      -- Check if the invoice should be printed as well
      send_and_print_ := nvl(Client_SYS.Get_Item_Value('SEND_AND_PRINT', attr_), 'FALSE');
   END IF;

   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'INVOICE_ID') THEN
         invoice_id_ := Client_SYS.Attr_Value_To_Number(value_);
         date_changed_ := FALSE;

         previous_execution_id_ := Get_Previous_Execution___ (invoice_id_);
         IF ((send_ = 'TRUE') AND (previous_execution_id_ IS NOT NULL)) THEN
            error_info_ := Language_SYS.Translate_Constant(lu_name_, 'SENDERROR: Invoice :P1 is being processed by Job ID :P2', 
                                                           NULL, invoice_id_, TO_CHAR(previous_execution_id_));
            Transaction_SYS.Set_Status_Info(error_info_, 'WARNING');
         ELSE
            OPEN get_invoice_data;
            FETCH get_invoice_data INTO objstate_, collective_, company_, party_type_, identity_, invoice_type_ ,is_advance_invoice_,
                                        inv_series_id_, inv_tax_invoice_no_, contract_, pay_term_id_, delivery_identity_, invoice_number_, your_reference_;
            CLOSE get_invoice_data;
            -- gelr:e-invoicing_compliance, begin   
            IF (Company_Localization_Info_API.Get_Parameter_Value_Db(company_, 'E-INVOICING_COMPLIANCE') = Fnd_Boolean_API.DB_TRUE) THEN
               compliance_media_code_ := Einv_Compliance_Msg_Setup_API.Get_Default_Media_Code(company_, 'INVOIC');
               IF (compliance_media_code_ IS NULL) THEN
                  Error_SYS.Appl_General(lu_name_, 'NOMSGSETUP: Default Message Setup (Company/Invoice/E-invoicing Compliance/Message Setup) data should be provided when "E-invoicing Compliance" localization control center parameter enabled.');
               ELSE
                  send_compliance_einv_ := 'TRUE';
               END IF;
            END IF;
            -- gelr:e-invoicing_compliance, end
            -- gelr:mx_xml_doc_reporting, begin
            IF (media_code_ = 'E-INVOICE') THEN
               Customer_Invoice_Pub_Util_API.Validate_Send_Invoice(company_, invoice_id_, 'CUSTOMER_ORDER_INV_ITEM_API');
            END IF;
            -- gelr:mx_xml_doc_reporting, end           
            -- gelr:prepayment_tax_document, begin
            $IF Component_Payled_SYS.INSTALLED $THEN
               IF (Company_Localization_Info_API.Get_Parameter_Value_Db(company_, 'PREPAYMENT_TAX_DOCUMENT') = Fnd_Boolean_API.DB_TRUE) THEN         
                  IF (Company_Pay_Info_API.Get_Prepay_Based_Prepay_Typ_Db(company_) = 'TRUE') THEN   
                     comp_def_rec_ := Company_Def_Invoice_Type_API.Get(company_);
                     IF (invoice_type_ IN (comp_def_rec_.def_co_tax_doc_type, comp_def_rec_.def_co_cre_tax_doc_type) 
                        AND Invoice_API.Get_Prepayment_Type_Code(company_, invoice_id_) IS NULL) THEN 
                        Error_SYS.Appl_General(lu_name_, 'NOPRPAYTYPECODE: Prepayment type is mandatory for prepayment tax documents.');
                     END IF;
                  END IF;
               END IF;
            $END   
            -- gelr:prepayment_tax_document, end
            party_type_cl_  := Party_Type_API.Decode(party_type_);
            old_invoice_no_ := invoice_number_;
            old_series_id_  := inv_series_id_;

            IF (send_ = 'TRUE' AND media_code_ IS NULL) THEN
               media_code_ := Cust_Ord_Customer_API.Get_Default_Media_Code(identity_, 'INVOIC', company_);
            END IF;

            prepay_deb_inv_type_ := Company_Def_Invoice_Type_API.Get_Def_Co_Prepay_Deb_Inv_Type(company_);
            prepay_cre_inv_type_ := Company_Def_Invoice_Type_API.Get_Def_Co_Prepay_Cre_Inv_Type(company_);

            -- A warning will be send to the background jobs indicating the Error.Invoices without errors will be printed.
            DECLARE
               resend_invoice_   BOOLEAN := FALSE;
            BEGIN
               
               @ApproveTransactionStatement(2014-08-13,darklk)
               SAVEPOINT print_invoice;
               
            IF (objstate_ != 'Preliminary') THEN
               resend_invoice_ := TRUE;
               Error_SYS.Record_General(lu_name_,'CANNOTPRINT: Invoice has already been E-mailed, Printed or Sent');
            END IF;
          
            report_id_ := Invoice_Type_API.Get_Layout_Id(company_, party_type_cl_, invoice_type_);
            
            IF (Client_Sys.Item_Exist('VALIDATEBG' ,attr_)) THEN
               validate_bg_ := Client_Sys.Get_Item_Value('VALIDATEBG' ,attr_ );   
            END IF;      
               
            IF(validate_bg_ = 'TRUE')THEN
               Customer_Invoice_Pub_Util_Api.Check_Customer_Invoice_Post(withholding_msg_,                                                             
                                                                         company_  ,
                                                                         identity_ ,                                                             
                                                                         invoice_id_ ,
                                                                         inv_series_id_ ,
                                                                         invoice_number_,
                                                                         'FALSE');                                                                
               IF (withholding_msg_ IS NOT NULL) THEN               
                  Error_SYS.Record_General(lu_name_, 'WHTERROR: :P1', withholding_msg_);
               END IF;      
            END IF;   
                        
            IF (collective_ = 'TRUE') THEN
               -- correction collective/ normal collective invoice
               -- Used hard-coded layout id only when no layout id is returned from the method Invoice_Type_API.Get_Layout_Id(); 
               report_id_ := NVL(report_id_, 'CUSTOMER_ORDER_COLL_IVC_REP');
            ELSE
               rebate_inv_type_ := Company_Def_Invoice_Type_API.Get_Co_Rebate_Cre_Inv_Type(company_);
               IF (invoice_type_ IN (prepay_deb_inv_type_, prepay_cre_inv_type_)) THEN
                  --Prepayment Based Invoice
                  -- Used hard-coded layout id only when no layout id is returned from the method Invoice_Type_API.Get_Layout_Id(); 
                  report_id_ := NVL(report_id_, 'CUST_ORDER_PREPAYM_INVOICE_REP');
               ELSIF (is_advance_invoice_='TRUE') THEN
                  --Advance Invoice
                  -- Used hard-coded layout id only when no layout id is returned from the method Invoice_Type_API.Get_Layout_Id(); 
                  report_id_ := NVL(report_id_, 'CUSTOMER_ORDER_ADV_IVC_REP');
               ELSIF (invoice_type_ = rebate_inv_type_) THEN
                  --Rebate Credit Invoice
                  -- Used hard-coded layout id only when no layout id is returned from the method Invoice_Type_API.Get_Layout_Id(); 
                  report_id_ := NVL(report_id_, 'REBATE_CREDIT_IVC_REP'); 
               ELSE
                  --Normal invoice and Correction invoice
                  -- Used hard-coded layout id only when no layout id is returned from the method Invoice_Type_API.Get_Layout_Id(); 
                  report_id_ := NVL(report_id_, 'CUSTOMER_ORDER_IVC_REP');
               END IF;
            END IF;
            -- Retrive and set the final invoice_no if the invoice is preliminary
            IF (print_type_ != 'P') THEN
               IF (objstate_ = 'Preliminary') THEN
                  Customer_Invoice_Pub_Util_API.Get_Invoice_No_For_Printout(series_id_, invoice_no_, tax_invoice_no_,
                                                                            company_, invoice_id_, voucher_date_);  
                  IF series_id_ IS NOT NULL THEN
                     inv_series_id_ := series_id_;
                  END IF;
                  IF tax_invoice_no_ IS NOT NULL THEN
                     inv_tax_invoice_no_ := tax_invoice_no_;
                  END IF;
                  IF (contract_ IS NOT NULL) THEN
                     site_date_ := Site_API.Get_Site_Date(contract_);
                  ELSE
                     site_date_ := Site_API.Get_Site_Date(User_Default_API.Get_Contract);
                  END IF;
                  -- Modify the invoice_date_, pay_term_base_date_, due_date_ , print_date
                  Modify_Invoice_Dates___(date_changed_, company_, invoice_id_, site_date_, NULL, site_date_, pay_term_id_, NULL, TRUE); 
                  
                  Interim_Voucher_Exist(company_, invoice_id_, NVL(voucher_date_, Get_Invoice_Date(company_, invoice_id_)));
               END IF;
            END IF;
            IF ((series_id_ IS NOT NULL) AND (invoice_no_ IS NOT NULL)) THEN
               Client_SYS.Clear_Attr(stat_attr_);
               Client_SYS.Add_To_Attr('SERIES_ID', series_id_, stat_attr_);
               Client_SYS.Add_To_Attr('INVOICE_NO', invoice_no_, stat_attr_);
               IF date_changed_ THEN
                  Client_SYS.Add_To_Attr('INVOICE_DATE', site_date_, stat_attr_);
               END IF;
               Cust_Ord_Invo_Stat_API.Modify_Invoice_Statistics(stat_attr_, company_, invoice_id_);    
            ELSE 
               prel_series_id_ := Invoice_Type_API.Get_Prel_Invoice_Series(company_, party_type_cl_, invoice_type_);
               
               IF (prel_series_id_ != inv_series_id_) THEN
                  Client_SYS.Clear_Attr(stat_attr_);
                  Client_SYS.Add_To_Attr('SERIES_ID', inv_series_id_, stat_attr_);
                  Client_SYS.Add_To_Attr('INVOICE_NO', invoice_number_, stat_attr_);
                  IF date_changed_ THEN
                     Client_SYS.Add_To_Attr('INVOICE_DATE', site_date_, stat_attr_);
                  END IF;
                  Cust_Ord_Invo_Stat_API.Modify_Invoice_Statistics(stat_attr_, company_, invoice_id_);
               END IF;
            END IF;

            IF (invoice_id_ != old_invoice_no_) THEN
               invoice_no_     := old_invoice_no_;
               series_id_      := inv_series_id_;
               old_invoice_no_ := invoice_id_;
               old_series_id_  := Invoice_Type_API.Get_Prel_Invoice_Series(company_, party_type_cl_, invoice_type_);
            END IF;

            --Get the no of invoice copies to print
            no_of_invoice_copies_ := Invoice_Utility_Pub_API.Get_No_Of_Invoice_Copies(company_, party_type_cl_, identity_, invoice_type_);
            tax_method_       := Company_Tax_Control_API.Get_External_Tax_Cal_Method_Db(company_);
            cor_inv_type_     := Company_Def_Invoice_Type_API.Get_Def_Co_Cor_Inv_Type(company_);
            col_cor_inv_type_ := Company_Def_Invoice_Type_API.Get_Def_Col_Cor_Inv_Type(company_);
            IF (tax_method_ IN (External_Tax_Calc_Method_API.DB_AVALARA_SALES_TAX, External_Tax_Calc_Method_API.DB_VERTEX_SALES_TAX_O_SERIES)) AND print_type_ != 'P' AND is_advance_invoice_ !='TRUE' THEN
               IF (invoice_type_ IN ('CUSTORDCRE', 'CUSTCOLCRE', cor_inv_type_, col_cor_inv_type_)) THEN
                  corr_credit_invoice_ := TRUE;
               END IF;
               Write_To_Ext_Tax_Reg___(company_, invoice_id_, corr_credit_invoice_);
            END IF;
               
            IF (email_address_ IS NULL) THEN
               IF (media_code_ IS NULL OR send_and_print_ = 'TRUE') OR 
                  (media_code_ = 'E-INVOICE' AND send_and_print_ = 'FALSE') THEN
                  -- Create invoice report and connect it to the current print job.
                  Print_Invoice___(result_keys_, company_, invoice_id_, report_id_, no_of_invoice_copies_, FALSE, send_and_print_, send_, NULL, print_type_, media_code_, print_online_); 
                  -- Create payment SLIP for ISR payments
                  IF (Invoice_API.Validate_Isr_Print(company_, invoice_id_) ='TRUE') THEN
                     Client_SYS.Clear_Attr(isr_param_attr_);
                     isr_param_attr_ := stat_attr_;
                     Client_SYS.Add_To_Attr('COMPANY', company_, isr_param_attr_);
                     is_qr_code_ := Payment_Term_API.Get_Print_Swiss_Q_R_Code_DB(company_, Invoice_API.Get_Pay_Term_Id(company_, invoice_id_));
                     IF (is_qr_code_ = 'TRUE') THEN 
                        report_type_ := 'ADDITIONAL_INV_Q_R_CODE_REP';
                     ELSE
                        report_type_ := 'ADDITIONAL_INVOICE_DOC_REP';
                     END IF;
                     Print_Invoice___(result_keys_, company_, invoice_id_, report_type_, no_of_invoice_copies_, FALSE, send_and_print_, send_, isr_param_attr_, NULL, NULL, print_online_);
                  END IF;
                  -- Print separate Tax Invoice if necessary
                  IF Company_Tax_Control_Invoic_API.Get_Use_Tax_Invoice_Db(company_) = 'TRUE' AND
                     inv_tax_invoice_no_  IS NOT NULL AND
                     Invoice_Series_API.Get_Separate_Tax_Invoice(company_, inv_series_id_) = 'TRUE'
                  THEN                    
                     Print_Invoice___(result_keys_, company_, invoice_id_, report_id_, no_of_invoice_copies_, TRUE, send_and_print_, send_, NULL, NULL, NULL, print_online_);
                  END IF;
                  -- Add appendixes if any               
                  Create_Invoice_Appendices(print_job_id_, invoice_id_, no_of_invoice_copies_, NULL, NULL, NULL, NULL, NULL, NULL, send_and_print_);                         
               END IF; 
               result_key_attr_ := result_key_attr_||result_keys_;
               result_keys_ := NULL;
               
               IF (media_code_ = 'E-INVOICE') THEN
                  -- COMMIT should required when the Invoice is sent via media code is E-INVOICE.
                  -- In this situation, Invoice report should be printed before send the invoice,
                  -- Because printed invoice image also attached to the xml document.
                  @ApproveTransactionStatement(2014-08-13,darklk)
                  COMMIT;
                  -- Set new savepoint so that rollback to savepoint will not fail.
                  @ApproveTransactionStatement(2014-08-13,darklk)
                  SAVEPOINT print_invoice;
               END IF;
            END IF;

            -- Update the invoice status
            IF (print_type_ != 'P') THEN
               Customer_Invoice_Pub_Util_API.Set_Invoice_Printed(company_, invoice_id_);
            END IF;
            Modify_Work_Order_Ivc_Info___(invoice_id_);
            
            -- Set date_sales_posted on the outstanding sales record connected to this invoice.
            Outstanding_Sales_API.Modify_Sales_Posted(company_, invoice_id_, Get_Invoice_Date(company_, invoice_id_));

            -- Create history records for customer orders
            Create_History_When_Printed___(company_, invoice_id_, media_code_, email_address_,print_method_);

            IF (invoice_type_ != 'SELFBILLDEB') THEN
               -- gelr:it_xml_invoice, check for media code availability in message setup
               IF (media_code_ IS NOT NULL) AND (Customer_Inv_Msg_Setup_API.Check_Msg_Setup_Exist(company_, identity_, party_type_cl_, media_code_, 'INVOIC') = 'TRUE') THEN
                  Client_SYS.Clear_Attr(flag_attr_);
                  Client_SYS.Add_To_Attr('CONNECTED_OBJECTS', connected_objects_, flag_attr_);
                  $IF (Component_Docman_SYS.INSTALLED)$THEN 
                     -- To fetch document objects connected to CustomerOrderInvHead LU.
                     doc_source_key_ref_ := Client_SYS.Get_Key_Reference(doc_source_lu_name_,
                                                                         'COMPANY',
                                                                         company_,
                                                                         'INVOICE_ID',
                                                                         invoice_id_);
                     Client_SYS.Add_To_Attr('LU_NAME', doc_source_lu_name_, flag_attr_);
                     Client_SYS.Add_To_Attr('KEY_REF', doc_source_key_ref_, flag_attr_);
                  $END                  
                  Client_SYS.Add_To_Attr('PRINT_JOB_ID', print_job_id_, flag_attr_);                  
                  send_error_ := NULL;
                  Customer_Invoice_Pub_Util_API.Send_Co_Invoice(send_error_,
                                                                company_, 
                                                                invoice_id_,
                                                                media_code_,
                                                                flag_attr_);
                  IF (send_error_ IS NOT NULL) THEN
                     invoice_no_ := Get_Invoice_No_By_Id(invoice_id_);
                     error_info_ := Language_SYS.Translate_Constant(lu_name_, 'SENDERROR2: Sending Invoice No :P1 cannot be processed. :P2', NULL, invoice_no_ , send_error_);
                     Transaction_SYS.Set_Status_Info(error_info_, 'WARNING');
                  END IF;
                  media_code_ := NULL;
               END IF;
            END IF;
            -- gelr:e-invoicing_compliance, begin
            IF (send_compliance_einv_ = 'TRUE')  THEN
               BEGIN
                  send_error_ := NULL;
                  Customer_Invoice_Pub_Util_API.Send_Online_Compliance_Invoice (send_error_, company_, invoice_id_, custord_inv_ => TRUE );                              
                  IF (send_error_ IS NOT NULL) THEN
                     invoice_no_ := Get_Invoice_No_By_Id(invoice_id_);
                     error_info_ := Language_SYS.Translate_Constant(lu_name_, 'REPORTERROR: Send reporting of Invoice No :P1 cannot be processed. :P2', NULL, invoice_no_ , send_error_);                  
                     Transaction_SYS.Set_Status_Info(error_info_, 'WARNING');
                  END IF;
                  compliance_media_code_ := NULL;
               EXCEPTION
                  WHEN OTHERS THEN
                     RAISE send_compl_exception_;
               END;
            END IF;
            -- gelr:e-invoicing_compliance, end            
            IF (email_address_ IS NOT NULL) THEN
               contact_ := Client_SYS.Get_Item_Value('CUSTOMER_REF', attr_);
               IF contact_ IS NULL  THEN
                  contact_ := your_reference_;
               END IF;
               Customer_Order_Flow_API.Email_Order_Report__(invoice_id_, contact_, contract_, email_address_, identity_, report_id_);
            END IF;
            
            IF (invoice_type_ IN ('CUSTORDDEB','CUSTCOLDEB','SELFBILLDEB','CUSTORDCRE','CUSTCOLCRE','SELFBILLCRE', cor_inv_type_, col_cor_inv_type_)) THEN
               Rebate_Transaction_Util_API.Create_Rebate_Transactions(transactions_created_,company_, invoice_id_, delivery_identity_);
            END IF;

            IF (transactions_created_ = 1) THEN
               -- Update the Rebate Net Amount/Base, Rebate Group, Rebate Assort ID and Node in the detailed statistics for invoiced sales.
               FOR line_rec_ IN get_inv_lines(company_, invoice_id_) LOOP
                  Client_SYS.Clear_Attr(stat_attr_);

                  rebate_amt_base_         := Rebate_Transaction_Util_API.Get_Total_Reb_Amt_For_Inv_Line(company_, invoice_id_, line_rec_.item_id);
                  sales_part_rebate_group_ := Rebate_Transaction_Util_API.Get_Rebate_Grp_For_Inv_Line(company_, invoice_id_, line_rec_.item_id);
                  rebate_assortment_id_    := Rebate_Transaction_Util_API.Get_Assort_Id_For_Inv_Line(company_, invoice_id_, line_rec_.item_id, line_rec_.identity);
                  rebate_assort_node_id_   := Rebate_Transaction_Util_API.Get_Assort_Node_For_Inv_Line(company_, invoice_id_, line_rec_.item_id, line_rec_.identity);

                  IF (rebate_amt_base_ IS NOT NULL) THEN
                     Client_SYS.Add_To_Attr('REBATE_AMT_BASE',rebate_amt_base_ , stat_attr_);
                  END IF;
                  IF (sales_part_rebate_group_ IS NOT NULL) THEN
                     Client_SYS.Add_To_Attr('SALES_PART_REBATE_GROUP',sales_part_rebate_group_ , stat_attr_);
                  END IF;
                  IF (rebate_assortment_id_ IS NOT NULL) THEN
                     Client_SYS.Add_To_Attr('REBATE_ASSORTMENT_ID',rebate_assortment_id_ , stat_attr_);
                  END IF;
                  IF (rebate_assort_node_id_ IS NOT NULL) THEN
                     Client_SYS.Add_To_Attr('REBATE_ASSORT_NODE_ID',rebate_assort_node_id_ , stat_attr_);
                  END IF;
                  IF (stat_attr_ IS NOT NULL) THEN
                     Cust_Ord_Invo_Stat_API.Modify_Invoice_Statistics(stat_attr_, company_, invoice_id_, line_rec_.item_id);
                  END IF;
               END LOOP;
            END IF;
            
            
            -- Create postings for the invoice printed or sent
            IF (print_type_ != 'P') THEN
               IF (objstate_ = 'Preliminary') THEN
                  Create_Postings(company_, invoice_id_, user_group_);
                  voucher_type_  := Client_SYS.Get_Item_Value('VOUCHER_TYPE',attr_);
                  voucher_date_  := Client_SYS.Get_Item_Value('VOUCHER_DATE',attr_);
                  print_option_  := Client_SYS.Get_Item_Value('PRINT_OPTION',attr_);
                  Client_SYS.Clear_Attr(head_attr_);
                  Client_SYS.Add_To_Attr('VOUCHER_TYPE', voucher_type_, head_attr_);
                  Client_SYS.Add_To_Attr('VOUCHER_DATE', voucher_date_, head_attr_);
                  Client_SYS.Add_To_Attr('USER_GROUP', user_group_, head_attr_);
                  IF print_option_ = 'OFFSET' THEN
                     Client_SYS.Add_To_Attr('PRINT_OPTION', print_option_, head_attr_);
                  END IF;
                  -- Create vouchers for postings
                  Customer_Invoice_Pub_Util_API.Create_Vouchers(company_, invoice_id_, head_attr_);
                  Calculate_Prel_Revenue(company_, invoice_id_);
                  Cust_Order_Invoice_Hist_API.New(company_, invoice_id_, Language_SYS.Translate_Constant('INVHISTPOSTED: Invoice Posted',NULL));
               END IF;
            END IF;

            -- Update the RMA lines
            FOR rec_ IN get_connected_rma_lines LOOP
               Return_Material_Line_API.Modify_Db_Invoice_Info(rec_.rma_no, rec_.rma_line_no, invoice_no_, series_id_);
            END LOOP;
            
            -- Clear the reference data (if any) stored in temp tables during flexible posting creation process for rebate credit invoices accordingly.
            -- This needs to be done after all accountings been done and the invoice erroneous state is decided.  
            Invoice_Customer_Order_API.Clear_Rebate_Postings_Ref_Data(company_, invoice_id_);
         EXCEPTION
            -- gelr:e-invoicing_compliance, begin
            WHEN send_compl_exception_ THEN
               @ApproveTransactionStatement(2022-02-02,hecolk)
               ROLLBACK TO print_invoice;
               IF NOT Set_Warning_Status___(invoice_id_, sqlerrm) THEN
                  RAISE;
               END IF;   
               IF (NOT resend_invoice_) THEN
                  Customer_Invoice_Pub_Util_API.Remove_Attachments(company_, invoice_id_, 'TRUE');
               END IF;
            -- gelr:e-invoicing_compliance, end   
            WHEN OTHERS THEN
               @ApproveTransactionStatement(2014-08-13,darklk)
               ROLLBACK TO print_invoice;
               -- gelr:e-invoicing_compliance, begin
               IF NOT Set_Warning_Status___(invoice_id_, sqlerrm) THEN
                  RAISE;
               END IF;
               -- gelr:e-invoicing_compliance, end
               -- Remove attachments
               IF (media_code_ = 'E-INVOICE' AND NOT resend_invoice_) THEN
                  Customer_Invoice_Pub_Util_API.Remove_Attachments(company_,
                                                                      invoice_id_);
               END IF;
         END;
      END IF;
   END IF;
      
      -- update the self billing invoice with the series ID and the new 
      -- invoice number when printing multiple self billing invoices 
      IF (email_address_ IS NULL) THEN
         -- add to update the invoice_no and series_id in the Self_Billing_header_table
         Client_SYS.Clear_Attr(sbi_attr_);
         IF (invoice_no_ IS NOT NULL) AND (series_id_ IS NOT NULL) THEN
            FOR get_sbi_info_ IN get_sbi_info LOOP
               Client_SYS.Add_To_Attr('INVOICE_NO', invoice_no_, sbi_attr_);
               Client_SYS.Add_To_Attr('SERIES_ID',  series_id_,  sbi_attr_);
               Self_Billing_Item_API.Modify(sbi_attr_, get_sbi_info_.sbi_no, get_sbi_info_.sbi_line_no);
            END LOOP;
         END IF;
      END IF;         
   END LOOP;  
   attr_ := result_key_attr_;       
END Print_Invoices;


-- Allowed_To_Print
--   Returns the order_no if the order_no is the same as the
--   creators_reference, otherwise NULL.
@UncheckedAccess
FUNCTION Allowed_To_Print (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   creators_reference_   CUSTOMER_ORDER_INV_HEAD.creators_reference%TYPE;
   CURSOR print_allowed IS
      SELECT creators_reference
      FROM   CUSTOMER_ORDER_INV_HEAD
      WHERE  creators_reference = order_no_
      AND    objstate IN ('Preliminary', 'Printed');
BEGIN
   OPEN print_allowed;
   FETCH print_allowed INTO creators_reference_;
   IF print_allowed%NOTFOUND THEN
      creators_reference_ := NULL;
   END IF;
   CLOSE print_allowed;
   RETURN creators_reference_;
END Allowed_To_Print;



PROCEDURE Fetch_Unknown_Head_Attributes (
   order_attributes_ IN OUT VARCHAR2,
   company_          IN     VARCHAR2,
   party_            IN     VARCHAR2,
   party_type_       IN     VARCHAR2,
   invoice_id_       IN     NUMBER )
IS
   creators_reference_       CUSTOMER_ORDER_INV_HEAD.creators_reference%TYPE;
   order_date_               CUSTOMER_ORDER_INV_HEAD.order_date%TYPE;
   our_reference_            CUSTOMER_ORDER_INV_HEAD.our_reference%TYPE;
   your_reference_           CUSTOMER_ORDER_INV_HEAD.your_reference%TYPE;
   ship_via_                 CUSTOMER_ORDER_INV_HEAD.ship_via%TYPE;
   forward_agent_id_         CUSTOMER_ORDER_INV_HEAD.forward_agent_id%TYPE;
   label_note_               CUSTOMER_ORDER_INV_HEAD.label_note%TYPE;
   delivery_terms_           CUSTOMER_ORDER_INV_HEAD.delivery_terms%TYPE;
   del_terms_location_       CUSTOMER_ORDER_INV_HEAD.del_terms_location%TYPE;
   contract_                 CUSTOMER_ORDER_INV_HEAD.contract%TYPE;
   currency_code_            CUSTOMER_ORDER_INV_HEAD.currency%TYPE;
   identity_                 CUSTOMER_ORDER_INV_HEAD.identity%TYPE;
   customer_company_         VARCHAR2(20);
   note_id_                  NUMBER;
   notes_                    VARCHAR2(2000);
   document_code_            VARCHAR2(3);
   invoice_type_             CUSTOMER_ORDER_INV_HEAD.invoice_type%TYPE;
   net_curr_amount_          CUSTOMER_ORDER_INV_HEAD.net_curr_amount%TYPE;
   company_def_inv_type_rec_ Company_Def_Invoice_Type_API.Public_Rec;
   order_rec_                Customer_Order_API.Public_Rec;
   your_ref_desc_            VARCHAR2(100);
   invoice_address_id_       VARCHAR2(50);
   rma_no_                   NUMBER;
   
   CURSOR get_head_data IS
      SELECT identity,             
             creators_reference,
             order_date,
             our_reference,
             your_reference,
             ship_via,
             forward_agent_id,
             label_note,
             delivery_terms,
             del_terms_location,
             contract,
             currency,
             invoice_type,
             net_curr_amount,
             invoice_address_id,
             rma_no
      FROM  CUSTOMER_ORDER_INV_HEAD
      WHERE company = company_
      AND   invoice_id = invoice_id_;
      
   CURSOR get_coll_item_data IS
      SELECT DISTINCT order_no
      FROM   customer_order_inv_item
      WHERE  company = company_
      AND    invoice_id = invoice_id_;
      
BEGIN
   OPEN get_head_data;
   FETCH get_head_data INTO identity_,          creators_reference_, order_date_, 
                            our_reference_,     your_reference_,     ship_via_, 
                            forward_agent_id_,  label_note_,         delivery_terms_,
                            del_terms_location_,contract_,           currency_code_,  invoice_type_,  net_curr_amount_,
                            invoice_address_id_, rma_no_;
   CLOSE get_head_data;

   order_rec_ := Customer_Order_API.Get(creators_reference_);

   Client_SYS.Clear_Attr(order_attributes_);
   Client_SYS.Add_To_Attr('ORDER_NO',              creators_reference_, order_attributes_);
   Client_SYS.Add_To_Attr('ORDER_DATE',            order_date_,         order_attributes_);
   Client_SYS.Add_To_Attr('OUR_REFERENCE',         our_reference_,      order_attributes_);
   
   IF (creators_reference_ IS NOT NULL) THEN
      your_ref_desc_ := Contact_Util_API.Get_Cust_Contact_Name(identity_, order_rec_.bill_addr_no, your_reference_);
   ELSE
      your_ref_desc_ := Contact_Util_API.Get_Cust_Contact_Name(identity_, invoice_address_id_, your_reference_);
   END IF;
   Client_SYS.Add_To_Attr('YOUR_REFERENCE',        NVL( your_ref_desc_, your_reference_),     order_attributes_);
   
   Client_SYS.Add_To_Attr('SHIP_VIA_DESC',         ship_via_,           order_attributes_);
   Client_SYS.Add_To_Attr('FORWARD_AGENT_ID',      forward_agent_id_,   order_attributes_);
   Client_SYS.Add_To_Attr('LABEL_NOTE',            label_note_,         order_attributes_);
   Client_SYS.Add_To_Attr('DELIVERY_TERMS_DESC',   delivery_terms_,     order_attributes_);
   Client_SYS.Add_To_Attr('DEL_TERMS_LOCATION',    del_terms_location_,  order_attributes_);
   Client_SYS.Add_To_Attr('CONTRACT',              contract_,           order_attributes_);
   Client_SYS.Add_To_Attr('CURRENCY_CODE',         currency_code_,      order_attributes_);
   customer_company_ := Site_API.Get_Company(Cust_Ord_Customer_API.Get_Acquisition_Site(identity_));
   Client_SYS.Add_To_Attr('CUSTOMER_COMPANY',      customer_company_,   order_attributes_);
   
   company_def_inv_type_rec_ := Company_Def_Invoice_Type_API.Get(company_);
  
   IF (invoice_type_ IN ('CUSTORDDEB', 'CUSTCOLDEB', 'SELFBILLDEB', company_def_inv_type_rec_.def_co_prepay_deb_inv_type)) THEN
      document_code_ := '4';
   ELSIF (invoice_type_ IN ('CUSTORDCRE', 'CUSTCOLCRE', 'SELFBILLCRE', company_def_inv_type_rec_.def_co_prepay_cre_inv_type)) THEN
      document_code_ := '5';
   ELSIF (invoice_type_ = company_def_inv_type_rec_.def_adv_co_dr_inv_type) THEN
      document_code_ := '74';
   ELSIF (invoice_type_ = company_def_inv_type_rec_.def_adv_co_cr_inv_type) THEN
      document_code_ := '75';
   ELSIF (invoice_type_ IN (company_def_inv_type_rec_.def_co_cor_inv_type, company_def_inv_type_rec_.def_col_cor_inv_type)) THEN
      IF (net_curr_amount_ >= 0) THEN
         document_code_ := '4';
      ELSE
         document_code_ := '5';
      END IF;
   END IF;

   IF (creators_reference_ IS NULL AND invoice_type_ IN ('CUSTCOLDEB', 'CUSTCOLCRE', company_def_inv_type_rec_.def_col_cor_inv_type)) THEN
      FOR item IN get_coll_item_data LOOP 
         note_id_ := Customer_Order_API.Get_Note_Id(item.order_no);
         notes_ := SUBSTR( notes_ || Document_Text_API.Get_All_Notes(note_id_, document_code_) ||';'|| CHR(13) || CHR(10), 1, 2000);
      END LOOP;
   ELSE
      IF (rma_no_ IS NOT NULL) THEN
         note_id_ := Return_Material_API.Get_Note_Id(rma_no_);
      ELSE
         note_id_ := order_rec_.note_id ;
      END IF;
      notes_ := Document_Text_API.Get_All_Notes(note_id_, document_code_);
   END IF;

   Client_SYS.Add_To_Attr('HEADER_DOC_TEXT', notes_, order_attributes_);

END Fetch_Unknown_Head_Attributes;


-- Create_Postings
--   Create postings for an invoice.
PROCEDURE Create_Postings (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER,
   user_group_ IN VARCHAR2 )
IS
   collect_            CUSTOMER_ORDER_INV_HEAD.collect%TYPE;
   order_no_           VARCHAR2(12);
   pre_accounting_id_  NUMBER;
   posting_rec_        Customer_Invoice_Pub_Util_API.customer_invoice_posting_rec;
   dummy_              VARCHAR2(100);
   advance_invoice_    VARCHAR2(5);
   add_pre_posting_    BOOLEAN := TRUE;
   order_no_ref_       VARCHAR2(12);
   n_                  NUMBER := 0;
   
   CURSOR get_invoice_data IS
      SELECT collect, advance_invoice
      FROM   CUSTOMER_ORDER_INV_HEAD
      WHERE  company = company_
      AND    invoice_id = invoice_id_;

   CURSOR get_invoice_order IS
      SELECT DISTINCT order_no
      FROM   CUSTOMER_ORDER_INV_ITEM
      WHERE  company = company_
      AND    invoice_id = invoice_id_
      AND    order_no IS NOT NULL;
-- need to include Gross Price Item also which created from tax rounding in total level
   CURSOR get_next_item IS
      SELECT item_id
      FROM   cust_invoice_pub_util_item
      WHERE  company = company_
      AND    invoice_id = invoice_id_
      AND NOT((item_id BETWEEN pc_tax_round_item_start_ AND pc_rounding_diff_start_) 
              AND (net_curr_amount = 0 AND vat_curr_amount != 0))   
     AND item_id NOT IN (pc_rounding_item_id_, pc_corr_rounding_item_id_, pc_fee_item_id_, pc_corr_fee_item_id_);
BEGIN

   App_Context_SYS.Set_Value('CUSTOMER_ORDER_INV_ITEM_API.user_group_', user_group_);
   -- Check if this is a collective invoice or a normal invoice
   OPEN get_invoice_data;
   FETCH get_invoice_data INTO collect_, advance_invoice_;
   CLOSE get_invoice_data;
   
   order_no_:= Get_First_Co_To_Invoice__ (company_, invoice_id_);
   
   IF (order_no_ IS NULL) THEN
      add_pre_posting_ := FALSE;         
   END IF;   

   IF (add_pre_posting_) THEN
      -- Retrive the customer order for this invoice
      OPEN get_invoice_order;
      FETCH get_invoice_order INTO order_no_;
      CLOSE get_invoice_order;

      pre_accounting_id_ := Customer_Order_API.Get_Pre_Accounting_Id(order_no_);

     
      -- Get pre posting for the order
      Pre_Accounting_API.Get_Pre_Accounting(posting_rec_.codepart_a, dummy_,
                                            posting_rec_.codepart_b, dummy_,
                                            posting_rec_.codepart_c, dummy_,
                                            posting_rec_.codepart_d, dummy_,
                                            posting_rec_.codepart_e, dummy_,
                                            posting_rec_.codepart_f, dummy_,
                                            posting_rec_.codepart_g, dummy_,
                                            posting_rec_.codepart_h, dummy_,
                                            posting_rec_.codepart_i, dummy_,
                                            posting_rec_.codepart_j, dummy_,
                                            pre_accounting_id_, company_);

      posting_rec_.project_activity_id := Pre_Accounting_API.Get_Activity_Seq(pre_accounting_id_);

      posting_rec_.company := company_;
      posting_rec_.invoice_id := invoice_id_;
      posting_rec_.item_id := NULL;

      IF ((advance_invoice_ = 'TRUE') AND (Pre_Accounting_API.Pre_Accounting_Exist(pre_accounting_id_) = 1))
          OR (Invoice_API.Get_Code_Part_Exist(company_, invoice_id_) = 'true') THEN
         Invoice_API.Modify_Pre_Accounting (posting_rec_.company,
                                            posting_rec_.invoice_id,
                                            posting_rec_.codepart_a,
                                            posting_rec_.codepart_b,
                                            posting_rec_.codepart_c,
                                            posting_rec_.codepart_d,
                                            posting_rec_.codepart_e,
                                            posting_rec_.codepart_f,
                                            posting_rec_.codepart_g,
                                            posting_rec_.codepart_h,
                                            posting_rec_.codepart_i,
                                            posting_rec_.codepart_j,
                                            posting_rec_.project_activity_id );
      END IF;
      IF ((advance_invoice_ = 'FALSE') AND (Pre_Accounting_API.Pre_Accounting_Exist(pre_accounting_id_) = 1)) THEN
         -- Send the pre posting for the header to Invoice
         Customer_Invoice_Pub_Util_API.Create_Posting(posting_rec_, TRUE);
      END IF;
   END IF;
  
   IF (advance_invoice_ = 'TRUE') THEN
      Customer_Invoice_Pub_Util_API.Create_Adv_Inv_Postings(company_, invoice_id_);
   ELSE
      -- Create postings for all invoice items
      FOR inv_item_ IN get_next_item LOOP
         Customer_Order_Inv_Item_API.Create_Postings__(company_, invoice_id_, inv_item_.item_id);
      END LOOP;
   END IF;
END Create_Postings;


-- Get_Ncf_Reference_No
--   Return the Nfc Reference No
@UncheckedAccess
FUNCTION Get_Ncf_Reference_No (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER ) RETURN VARCHAR2

IS
 ncf_reference_   VARCHAR2(50);

BEGIN
 ncf_reference_ := Ncf_Invoice_Util_API.Ncf_Get_Reference (company_, invoice_id_);
 RETURN ncf_reference_;
END Get_Ncf_Reference_No ;



-- Create_Credit_Invoice_Hist
--   Create history records for order when a credit invoice has been
--   created using implementation method CreateCreditInvoiceHist.
PROCEDURE Create_Credit_Invoice_Hist (
   order_no_       IN VARCHAR2,
   cre_invoice_id_ IN NUMBER,
   ref_invoice_id_ IN NUMBER )
IS
BEGIN
   Create_Credit_Invoice_Hist___ ( order_no_, ref_invoice_id_ , cre_invoice_id_);
END Create_Credit_Invoice_Hist;


@UncheckedAccess
FUNCTION Get_Co_Gross_Total (
   company_  IN VARCHAR2,
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   final_gross_total_ NUMBER := 0;

   CURSOR get_gross_amount IS 
   SELECT i.gross_curr_amount
     FROM customer_order_inv_head h, customer_order_inv_item i
    WHERE h.company = i.company
      AND h.invoice_id = i.invoice_id
      AND h.company = company_
      AND h.creators_reference = order_no_
      AND h.invoice_type = 'CUSTORDDEB' ;
BEGIN
   FOR rec_ IN get_gross_amount LOOP
      final_gross_total_ := final_gross_total_ + NVL(rec_.gross_curr_amount,0);
   END LOOP;

   RETURN final_gross_total_;
END Get_Co_Gross_Total;



-- Get_Tot_Discount_For_Co_Line
--   Returns the total invoice item discount given for a specified customer order line.
@UncheckedAccess
FUNCTION Get_Tot_Discount_For_Co_Line (
   contract_     IN VARCHAR2,
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN NUMBER
IS
   discount_              NUMBER := 0;
   tot_amt_with_discount_ NUMBER := 0;
   tot_price_base_        NUMBER := 0;

   CURSOR get_attr IS
      SELECT (i.invoiced_qty * i.sale_unit_price * i.price_conv *
              (1 - i.discount / 100) * (1 - (i.order_discount + i.additional_discount) / 100))     price_base_with_discount,
             i.invoiced_qty * i.sale_unit_price * i.price_conv                                     price_base
      FROM  customer_order_inv_item i
      WHERE i.contract = contract_
      AND   i.order_no = order_no_
      AND   i.line_no = line_no_
      AND   i.release_no = rel_no_
      AND   i.line_item_no = line_item_no_
      AND   i.invoice_type IN ('CUSTORDDEB','CUSTCOLDEB');


BEGIN
   FOR rec_ IN get_attr LOOP
      tot_amt_with_discount_ := tot_amt_with_discount_ + rec_.price_base_with_discount;
      tot_price_base_ := tot_price_base_ + rec_.price_base;
   END LOOP;

   IF (NVL(tot_price_base_, 0) <> 0) THEN
      discount_ := ROUND(100 * (1 - (tot_amt_with_discount_ / tot_price_base_)), 2);
   END IF;

   RETURN discount_;
END Get_Tot_Discount_For_Co_Line;



-- Check_Unpaid_Advance_Inv_Exist
--   This function checks for unpaid advance invoices related to the given
--   order_no and will return TRUE if at least one unpaid advance invoice
--   exist. Otherwise return FALSE.
@UncheckedAccess
FUNCTION Check_Unpaid_Advance_Inv_Exist (
   order_no_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   exist_ NUMBER;
   def_advance_dr_invoice_type_ VARCHAR2(20);

   CURSOR unpaid_advance_inv_exist IS
      SELECT 1
        FROM CUSTOMER_ORDER_INV_HEAD
       WHERE creators_reference = order_no_
         AND advance_invoice     = 'TRUE'
         AND invoice_type        = def_advance_dr_invoice_type_
         AND objstate           != 'PaidPosted';
BEGIN
   def_advance_dr_invoice_type_ := Company_Def_Invoice_Type_API.Get_Def_Adv_Co_Dr_Inv_Type(Site_API.Get_Company(Customer_Order_API.Get_Contract(order_no_)));
   OPEN  unpaid_advance_inv_exist;
   FETCH unpaid_advance_inv_exist INTO exist_;
   CLOSE unpaid_advance_inv_exist;

   IF (exist_ IS NOT NULL) THEN
      RETURN TRUE;
   ELSE
      RETURN FALSE;
   END IF;
END Check_Unpaid_Advance_Inv_Exist;



-- Get_Net_Curr_Amount
--   Returns the Net_Curr_Amount of the Invoice
@UncheckedAccess
FUNCTION Get_Net_Curr_Amount (
   company_ IN VARCHAR2,
   invoice_id_ IN NUMBER ) RETURN NUMBER
IS
   temp_ CUSTOMER_ORDER_INV_HEAD.net_curr_amount%TYPE;
   CURSOR get_attr IS
      SELECT net_curr_amount
      FROM CUSTOMER_ORDER_INV_HEAD
      WHERE company = company_
      AND   invoice_id = invoice_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Net_Curr_Amount;



-- Get_Vat_Curr_Amount
--   Returns the Vat_Curr_Amount of the Invoice
@UncheckedAccess
FUNCTION Get_Vat_Curr_Amount (
   company_ IN VARCHAR2,
   invoice_id_ IN NUMBER ) RETURN NUMBER
IS
   temp_ CUSTOMER_ORDER_INV_HEAD.vat_curr_amount%TYPE;
   CURSOR get_attr IS
      SELECT vat_curr_amount
      FROM CUSTOMER_ORDER_INV_HEAD
      WHERE company = company_
      AND   invoice_id = invoice_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Vat_Curr_Amount;



-- Get_Rma_No
--   Returns the Rma No stored in the Correction Invoice header.
@UncheckedAccess
FUNCTION Get_Rma_No (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER ) RETURN NUMBER
IS
   temp_ CUSTOMER_ORDER_INV_HEAD.rma_no%TYPE;
   CURSOR get_attr IS
      SELECT rma_no
        FROM CUSTOMER_ORDER_INV_HEAD
       WHERE company = company_
         AND invoice_id = invoice_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Rma_No;



-- Check_Manual_Tax_Liab_Exist
--   Return TRUE if invoice has tax codes without manual tax liability dates.
@UncheckedAccess
FUNCTION Check_Manual_Tax_Liab_Exist (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER ) RETURN VARCHAR2
IS
   manual_line_exist_   VARCHAR2(5);

   CURSOR get_items IS
      SELECT item_id, invoice_type, man_tax_liability_date
        FROM customer_order_inv_item
       WHERE company = company_
         AND invoice_id = invoice_id_;

BEGIN

   FOR item_rec_ IN get_items LOOP
      IF (item_rec_.man_tax_liability_date IS NULL) THEN
         manual_line_exist_ := Customer_Order_Inv_Item_API.Has_Manual_Tax_Liablty_Lines(company_, invoice_id_, item_rec_.item_id, item_rec_.invoice_type);
         IF (manual_line_exist_ = 'TRUE' ) THEN
            RETURN 'TRUE';
         END IF;
      END IF;
   END LOOP ;
   RETURN 'FALSE';

END Check_Manual_Tax_Liab_Exist;



-- Check_Corr_Inv_Tax_Lines
--   Return TRUE if credit line has tax codes with Tax Liability Date type as "Manual"
--   and DEBIT line has tax codes without Tax Liability Date type as "Manual".
@UncheckedAccess
FUNCTION Check_Corr_Inv_Tax_Lines (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER ) RETURN VARCHAR2
IS
   rows_                 NUMBER;
   creline_item_id_      NUMBER;
   debline_item_id_      NUMBER;
   creline_manual_exist_ VARCHAR2(5);
   debline_manual_exist_ VARCHAR2(5);
   temp_                 BOOLEAN := FALSE;
   man_tax_liab_date_    DATE;

   CURSOR get_item IS
      SELECT count(*)
      FROM   CUSTOMER_ORDER_INV_ITEM
      WHERE  invoice_id = invoice_id_
      AND    company = company_;

   CURSOR get_items(cre_item_id_ IN NUMBER) IS
      SELECT item_id, invoice_type
      FROM   CUSTOMER_ORDER_INV_ITEM
      WHERE  invoice_id = invoice_id_
      AND    company = company_
      AND    item_id >= cre_item_id_;

BEGIN

   OPEN get_item;
   FETCH get_item INTO rows_;
   CLOSE get_item;

   creline_item_id_ := (rows_/2) + 1 ;

   FOR item_rec_ IN get_items(creline_item_id_) LOOP
      creline_manual_exist_ := Customer_Order_Inv_Item_API.Has_Manual_Tax_Liablty_Lines(company_, invoice_id_, item_rec_.item_id, item_rec_.invoice_type);
      IF (creline_manual_exist_ = 'TRUE') THEN
         debline_item_id_ := item_rec_.item_id - (rows_/2);
         debline_manual_exist_ := Customer_Order_Inv_Item_API.Has_Manual_Tax_Liablty_Lines(company_, invoice_id_, debline_item_id_, item_rec_.invoice_type);

         IF (debline_manual_exist_ = 'FALSE') THEN
            man_tax_liab_date_ := Customer_Order_Inv_Item_API.Get_Man_Tax_Liab_Date(company_, invoice_id_, item_rec_.item_id);
            IF (man_tax_liab_date_ IS NULL) THEN
               temp_ := TRUE;
            END IF;
         ELSE
            man_tax_liab_date_ := Customer_Order_Inv_Item_API.Get_Man_Tax_Liab_Date(company_, invoice_id_, debline_item_id_);
            IF (man_tax_liab_date_ IS NULL) THEN
               temp_ := FALSE;
               EXIT;
            END IF;
         END IF;
      END IF;
   END LOOP;
   IF (temp_ = TRUE) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Check_Corr_Inv_Tax_Lines;

@UncheckedAccess
FUNCTION Get_Final_Settlement (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ CUSTOMER_ORDER_INV_HEAD.final_settlement%TYPE;
   CURSOR get_attr IS
      SELECT final_settlement
      FROM CUSTOMER_ORDER_INV_HEAD
      WHERE company = company_
      AND   invoice_id = invoice_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Final_Settlement;



-- Send_Invoices
--   Resend customer order invoices via specified media code.
PROCEDURE Send_Invoices (
   attr_ IN VARCHAR2 )
IS
   ptr_                   NUMBER;
   name_                  VARCHAR2(30);
   value_                 VARCHAR2(2000);
   media_code_            VARCHAR2(30) := NULL;
   invoice_id_            CUSTOMER_ORDER_INV_HEAD.invoice_id%TYPE;
   company_               CUSTOMER_ORDER_INV_HEAD.company%TYPE;
   party_type_            CUSTOMER_ORDER_INV_HEAD.party_type%TYPE;
   identity_              CUSTOMER_ORDER_INV_HEAD.identity%TYPE;
   order_no_              CUSTOMER_ORDER_INV_HEAD.creators_reference%TYPE;
   invoice_no_            CUSTOMER_ORDER_INV_HEAD.invoice_no%TYPE;
   error_info_            VARCHAR2(2000);   
   receiver_address_      VARCHAR2(100);
   connected_objects_     VARCHAR2(5);
   flag_attr_             VARCHAR2(5000);
   send_error_            VARCHAR2(2000);
   key_ref_               VARCHAR2(2000);
   doc_lu_name_           VARCHAR2(100) := 'CustomerOrderInvHead';
   attachment_group_      NUMBER;
   result_key_            NUMBER;
   print_job_id_          NUMBER;
   report_id_             VARCHAR2(30);
   send_and_print_        VARCHAR2(5);
   instance_attr_         VARCHAR2(32000);
   parameter_attr_        VARCHAR2(32000);


   CURSOR get_invoice_data IS
      SELECT company, party_type, identity, creators_reference
      FROM   CUSTOMER_ORDER_INV_HEAD
      WHERE  invoice_id = invoice_id_
      AND    company > ' ';
BEGIN
   media_code_ := Client_SYS.Get_Item_Value('MEDIA_CODE', attr_);
   connected_objects_ := Client_SYS.Get_Item_Value('CONNECTED_OBJECTS', attr_);
   attachment_group_  := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('ATTACHMENT_GROUP', attr_));
   send_and_print_    := NVL(Client_SYS.Get_Item_Value('SEND_AND_PRINT', attr_), 'FALSE');
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'INVOICE_ID') THEN
         invoice_id_ := Client_SYS.Attr_Value_To_Number(value_);
      ELSIF (name_ = 'RESULT_KEY') THEN
         result_key_  := Client_SYS.Attr_Value_To_Number(value_);
      ELSIF (name_ = 'END') THEN
         OPEN get_invoice_data;
         FETCH get_invoice_data INTO company_, party_type_, identity_, order_no_;
         CLOSE get_invoice_data;

         IF (media_code_ IS NULL) THEN
            media_code_ := Cust_Ord_Customer_API.Get_Default_Media_Code(identity_,'INVOIC', company_);
         END IF;

         IF (media_code_ IS NOT NULL) THEN
            Client_SYS.Clear_Attr(flag_attr_);
            Client_SYS.Add_To_Attr('CONNECTED_OBJECTS', connected_objects_, flag_attr_);
            Client_SYS.Add_To_Attr('ATTACHMENT_GROUP',  attachment_group_,  flag_attr_);
            Client_SYS.Add_To_Attr('RESULT_KEY',        result_key_,        flag_attr_);

            -- if result_key_ is not null and send_and_print_ is true then a report of the invoice has been created and should be printed
            IF (result_key_ IS NOT NULL) THEN
               IF (send_and_print_ = 'TRUE') THEN
                  -- Get data about the created report.
                  Archive_API.Get_Info(instance_attr_, parameter_attr_, result_key_);
                  report_id_ := Client_SYS.Get_Item_Value('REPORT_ID', instance_attr_);
                  -- if report_id is NULL then the report is not in the archive any more, then do nothing
                  IF (report_id_ IS NOT NULL) THEN
                     Customer_Order_Flow_API.Create_Print_Jobs(print_job_id_, result_key_, report_id_, parameter_attr_);
                     Customer_Order_Flow_API.Printing_Print_Jobs(print_job_id_);
                  END IF;
               END IF;
               print_job_id_ := NULL;
               Create_Invoice_Appendices(print_job_id_, invoice_id_, 0, NULL, NULL, NULL, NULL, NULL, NULL, send_and_print_);
            END IF;

            $IF (Component_Docman_SYS.INSTALLED)$THEN 
               key_ref_ := Client_SYS.Get_Key_Reference(doc_lu_name_,
                                                        'COMPANY',
                                                        company_,
                                                        'INVOICE_ID',
                                                        invoice_id_);
               Client_SYS.Add_To_Attr('LU_NAME', doc_lu_name_, flag_attr_);
               Client_SYS.Add_To_Attr('KEY_REF', key_ref_,     flag_attr_);
            $END 

            Customer_Invoice_Pub_Util_API.Resend_Co_Invoice(send_error_,
                                                            company_,
                                                            invoice_id_, 
                                                            media_code_,
                                                            flag_attr_);
            IF (send_error_ IS NULL) THEN
               -- Create history record in customer invoice history.
               receiver_address_ := Customer_Inv_Msg_Setup_API.Get_Address(identity_,
                                                                           company_,
                                                                           Party_Type_API.Decode('CUSTOMER'),
                                                                           media_code_, 
                                                                           'INVOIC');
               Cust_Order_Invoice_Hist_API.New(company_, 
                                               invoice_id_, 
                                               Language_SYS.Translate_Constant(lu_name_, 'INVRESENTRECADDR: Invoice re-sent via :P1 to the receiver address :P2 ', NULL, media_code_, receiver_address_));
               Modify_Work_Order_Ivc_Info___(invoice_id_);
            ELSE
               invoice_no_ := Get_Invoice_No_By_Id(invoice_id_);
               error_info_ := Language_SYS.Translate_Constant(lu_name_, 'SENDERROR2: Sending Invoice No :P1 cannot be processed. :P2', NULL, invoice_no_ , send_error_);
               
               IF (Transaction_SYS.Is_Session_Deferred) THEN
                  Transaction_SYS.Set_Status_Info(error_info_, 'WARNING');
               ELSE
                  Error_SYS.Record_General(lu_name_, error_info_); 
               END IF;
            END IF;
            media_code_ := NULL;
         END IF;
      END IF;
   END LOOP;
END Send_Invoices;


-- Get_Aggregation_No
--   Returns the aggregation no of the invoice.
@UncheckedAccess
FUNCTION Get_Aggregation_No (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER ) RETURN NUMBER
IS
   temp_ CUSTOMER_ORDER_INV_HEAD.aggregation_no%TYPE;
   CURSOR get_attr IS
      SELECT aggregation_no
      FROM CUSTOMER_ORDER_INV_HEAD
      WHERE company = company_
      AND   invoice_id = invoice_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Aggregation_No;



FUNCTION Get_Ad_Net_Without_Invoice_Fee (
   company_            IN VARCHAR2,
   order_no_           IN VARCHAR2,
   skip_preliminary_   IN VARCHAR2 DEFAULT 'FALSE') RETURN NUMBER
IS
   final_net_total_         NUMBER := 0;
   advance_dr_invoice_type_ VARCHAR2(20);
   advance_cr_invoice_type_ VARCHAR2(20);

   CURSOR get_net_amount IS 
      SELECT i.net_curr_amount
        FROM customer_order_inv_head h, customer_order_inv_item i
       WHERE h.company = i.company
         AND h.invoice_id = i.invoice_id
         AND h.company = company_
         AND h.creators_reference = order_no_
         AND ( h.invoice_type IN (advance_dr_invoice_type_ ) OR 
             (h.invoice_type = advance_cr_invoice_type_ AND ( h.objstate != 'Preliminary' OR skip_preliminary_ = 'FALSE')));

BEGIN
   advance_dr_invoice_type_ := Company_Def_Invoice_Type_API.Get_Def_Adv_Co_Dr_Inv_Type(company_);
   advance_cr_invoice_type_ := Company_Def_Invoice_Type_API.Get_Def_Adv_Co_Cr_Inv_Type(company_);

   FOR rec_ IN get_net_amount LOOP
      final_net_total_ := final_net_total_ + NVL(rec_.net_curr_amount,0);
   END LOOP;
 
   RETURN final_net_total_;
END Get_Ad_Net_Without_Invoice_Fee;


FUNCTION Get_Ad_Gro_Without_Invoice_Fee (
   company_            IN VARCHAR2,
   order_no_           IN VARCHAR2,
   skip_preliminary_   IN VARCHAR2 DEFAULT 'FALSE' ) RETURN NUMBER
IS
   final_gross_total_       NUMBER := 0;
   advance_dr_invoice_type_ VARCHAR2(20);
   advance_cr_invoice_type_ VARCHAR2(20);
    
   CURSOR get_gross_amount IS 
      SELECT i.gross_curr_amount
        FROM customer_order_inv_head h, customer_order_inv_item i
       WHERE h.company = i.company
         AND h.invoice_id = i.invoice_id
         AND h.company = company_
         AND h.creators_reference = order_no_
         AND ( h.invoice_type IN (advance_dr_invoice_type_ ) OR 
             (h.invoice_type = advance_cr_invoice_type_ AND ( h.objstate != 'Preliminary' OR skip_preliminary_ = 'FALSE')));
BEGIN
   advance_dr_invoice_type_ := Company_Def_Invoice_Type_API.Get_Def_Adv_Co_Dr_Inv_Type(company_);
   advance_cr_invoice_type_ := Company_Def_Invoice_Type_API.Get_Def_Adv_Co_Cr_Inv_Type(company_);
    
   FOR rec_ IN get_gross_amount LOOP
      final_gross_total_ := final_gross_total_ + NVL(rec_.gross_curr_amount,0);
   END LOOP;
 
   RETURN final_gross_total_;
END Get_Ad_Gro_Without_Invoice_Fee;


-- Get_Currency_Rate_Type
--   Returns the Currency_Rate_Type of the Invoice
@UncheckedAccess
FUNCTION Get_Currency_Rate_Type (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ CUSTOMER_ORDER_INV_HEAD.currency_rate_type%TYPE;
   CURSOR get_attr IS
      SELECT currency_rate_type
      FROM CUSTOMER_ORDER_INV_HEAD
      WHERE company = company_
      AND   invoice_id = invoice_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Currency_Rate_Type;



-- Inv_Address_Exist
--   Returns TRUE if a given customer address is used in cutomer invoice.
@UncheckedAccess
FUNCTION Inv_Address_Exist (
   customer_no_ IN VARCHAR2,
   inv_addr_no_ IN VARCHAR2) RETURN BOOLEAN
IS
   dummy_ VARCHAR2(200);

   CURSOR inv_address IS
      SELECT 1
      FROM  CUSTOMER_ORDER_INV_HEAD 
      WHERE identity = customer_no_
      AND   invoice_address_id = inv_addr_no_;
BEGIN
   OPEN  inv_address;
   FETCH inv_address INTO dummy_;
   IF (inv_address %FOUND) THEN
      CLOSE inv_address;
      RETURN TRUE;
   ELSE
      CLOSE inv_address;
      RETURN FALSE;
   END IF;
END Inv_Address_Exist;



-- Get_Co_Inv_Net_Total
--   Returns the maximum of advance invoice amount and debit invoice amount.
--   This value is used to calculate the remaining amount to create the advance invoice
--   when the base for advance invoice is NET AMOUNT or NET AMOUNT WITH CHARGES in the
@UncheckedAccess
FUNCTION Get_Co_Inv_Net_Total (
   company_  IN VARCHAR2,
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   advance_net_total_       NUMBER := 0;
   custorder_net_total_     NUMBER := 0;
   advance_dr_invoice_type_ VARCHAR2(20);
   advance_cr_invoice_type_ VARCHAR2(20);

   CURSOR get_advance_net_total IS 
      SELECT SUM(i.net_curr_amount)
        FROM customer_order_inv_head h, customer_order_inv_item i
       WHERE h.company = i.company
         AND h.invoice_id = i.invoice_id
         AND h.company = company_
         AND h.creators_reference = order_no_
         AND h.invoice_type IN (advance_dr_invoice_type_ , advance_cr_invoice_type_);

   CURSOR get_co_net_total IS 
     SELECT SUM(i.net_curr_amount)
       FROM customer_order_inv_head h, customer_order_inv_item i
      WHERE h.company = i.company
        AND h.invoice_id = i.invoice_id
        AND h.company = company_
        AND h.creators_reference = order_no_
        AND h.invoice_type ='CUSTORDDEB' ;   

BEGIN
   advance_dr_invoice_type_ := Company_Def_Invoice_Type_API.Get_Def_Adv_Co_Dr_Inv_Type(company_);
   advance_cr_invoice_type_ := Company_Def_Invoice_Type_API.Get_Def_Adv_Co_Cr_Inv_Type(company_);
   
   OPEN  get_advance_net_total;
   FETCH get_advance_net_total INTO advance_net_total_;
   CLOSE get_advance_net_total;
   advance_net_total_ := NVL(advance_net_total_, 0);

   OPEN  get_co_net_total;
   FETCH get_co_net_total INTO custorder_net_total_;
   CLOSE get_co_net_total;
   custorder_net_total_ := NVL(custorder_net_total_, 0);

   IF (advance_net_total_ > custorder_net_total_) THEN
      RETURN advance_net_total_;
   ELSE
      RETURN custorder_net_total_;
   END IF;
END Get_Co_Inv_Net_Total;



-- Get_Co_Inv_Gross_Total
--   Returns the maximum of advance invoice amount and debit invoice amount.
--   This value is used to calculate the remaining amount to create the advance invoice
--   when the base for advance invoice is 'GROSS AMOUNT or 'GROSS AMOUNT WITH CHARGES
--   in the dlgCreateAdvancePaymentInvoice.
@UncheckedAccess
FUNCTION Get_Co_Inv_Gross_Total (
   company_  IN VARCHAR2,
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   advance_gross_total_     NUMBER := 0;
   custorder_gross_total_   NUMBER := 0;
   advance_dr_invoice_type_ VARCHAR2(20);
   advance_cr_invoice_type_ VARCHAR2(20);

   CURSOR get_advance_gross_total IS 
      SELECT SUM(i.gross_curr_amount)
        FROM customer_order_inv_head h, customer_order_inv_item i
       WHERE h.company = i.company
         AND h.invoice_id = i.invoice_id
         AND h.company = company_
         AND h.creators_reference = order_no_
         AND h.invoice_type IN (advance_dr_invoice_type_ , advance_cr_invoice_type_);

   CURSOR get_co_gross_total IS 
   SELECT SUM(i.gross_curr_amount)
     FROM customer_order_inv_head h, customer_order_inv_item i
    WHERE h.company = i.company
      AND h.invoice_id = i.invoice_id
      AND h.company = company_
      AND h.creators_reference = order_no_
      AND h.invoice_type = 'CUSTORDDEB' ;   

BEGIN
   advance_dr_invoice_type_ := Company_Def_Invoice_Type_API.Get_Def_Adv_Co_Dr_Inv_Type(company_);
   advance_cr_invoice_type_ := Company_Def_Invoice_Type_API.Get_Def_Adv_Co_Cr_Inv_Type(company_);
   
   OPEN  get_advance_gross_total;
   FETCH get_advance_gross_total INTO advance_gross_total_;
   CLOSE get_advance_gross_total;  
   advance_gross_total_ := NVL(advance_gross_total_, 0);

   OPEN  get_co_gross_total;
   FETCH get_co_gross_total INTO custorder_gross_total_;
   CLOSE get_co_gross_total;
   custorder_gross_total_ := NVL(custorder_gross_total_, 0);

   IF (advance_gross_total_ > custorder_gross_total_) THEN
      RETURN advance_gross_total_;
   ELSE
      RETURN custorder_gross_total_;
   END IF;
END Get_Co_Inv_Gross_Total;



@UncheckedAccess
FUNCTION Allow_Changes_To_Js_Inv (
   company_   IN VARCHAR2,
   identity_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   allwed_modify_js_inv_ VARCHAR2(5);
BEGIN
   $IF (Component_Jinsui_SYS.INSTALLED)$THEN 
      allwed_modify_js_inv_ := Js_Customer_Info_API.Get_Allow_Changes_To_Prel_Inv( company_ , identity_);
   $END 

	IF ( allwed_modify_js_inv_ IS NULL ) THEN
		allwed_modify_js_inv_ := 'FALSE';
	END IF; 
   RETURN allwed_modify_js_inv_;
END Allow_Changes_To_Js_Inv ;



-- Calculate_Prel_Revenue
--   Refreshes project revenue of the invoice lines if vouchers were created.
PROCEDURE Calculate_Prel_Revenue (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER)
IS
   co_inv_head_rec_  Customer_Order_Inv_Head_API.Public_Rec;

   CURSOR get_inv_item IS
      SELECT item_id, order_no, line_no, release_no, line_item_no
      FROM customer_order_inv_item
      WHERE company = company_
      AND invoice_id = invoice_id_;
BEGIN
   co_inv_head_rec_ := Customer_Order_Inv_Head_API.Get(company_, invoice_id_);
   
   IF (co_inv_head_rec_.objstate NOT IN ('Preliminary', 'Printed')) THEN
      FOR inv_item_rec_ IN get_inv_item LOOP
         Customer_Order_Inv_Item_API.Calculate_Prel_Revenue__(company_, invoice_id_, inv_item_rec_.item_id,
                                                              inv_item_rec_.order_no, inv_item_rec_.line_no, 
                                                              inv_item_rec_.release_no, inv_item_rec_.line_item_no );
      END LOOP;
   END IF;
END Calculate_Prel_Revenue;


-- Get_Use_Price_Incl_Tax_Db
--   Returns the use price including tax setting.
@UncheckedAccess
FUNCTION Get_Use_Price_Incl_Tax_Db (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ CUSTOMER_ORDER_INV_HEAD.use_price_incl_tax_db%TYPE;
   CURSOR get_attr IS
      SELECT use_price_incl_tax_db
      FROM CUSTOMER_ORDER_INV_HEAD
      WHERE company    = company_
      AND   invoice_id = invoice_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Use_Price_Incl_Tax_Db;

-- Validate_Invoice_Text
--    Returns whether the invoice text exists in header or in all the invoice lines if the user has selected to validate the invoice text 
--    of the particular invoice type.
@UncheckedAccess
FUNCTION Validate_Invoice_Text (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_       CUSTOMER_ORDER_INV_HEAD.invoice_text%TYPE;
   inv_type_   CUSTOMER_ORDER_INV_HEAD.invoice_type%TYPE;
   validate_   VARCHAR2(5):= 'TRUE';
   validate_inv_type_needed_  VARCHAR2(5):= 'FALSE';
   party_type_ CUSTOMER_ORDER_INV_HEAD.PARTY_TYPE%TYPE;
   party_type_cl_ VARCHAR2(200);
      
   CURSOR get_header_inv_text IS
      SELECT invoice_text, invoice_type, party_type
        FROM CUSTOMER_ORDER_INV_HEAD
       WHERE company = company_
         AND invoice_id = invoice_id_;
  
   CURSOR get_null_invoice_text_lines IS
      SELECT 1
        FROM customer_order_inv_item
       WHERE company = company_
         AND invoice_id = invoice_id_
         AND prel_update_allowed = 'TRUE'
         AND invoice_text IS NULL;
BEGIN
   OPEN get_header_inv_text;
   FETCH get_header_inv_text INTO temp_, inv_type_, party_type_;
   CLOSE get_header_inv_text; 
   party_type_cl_ := Party_Type_API.Decode(party_type_);
   validate_inv_type_needed_ := Invoice_Type_API.Get_Validate_Invoice_Text_Db(company_, party_type_cl_, inv_type_);   
   IF validate_inv_type_needed_ = 'TRUE' THEN      
      IF temp_ IS NULL THEN
         OPEN get_null_invoice_text_lines;  
         FETCH get_null_invoice_text_lines INTO temp_;
         IF get_null_invoice_text_lines%FOUND THEN         
            validate_ := 'FALSE';               
         END IF;
         CLOSE get_null_invoice_text_lines;
      END IF;  
   END IF;    
   RETURN validate_;
END Validate_Invoice_Text;

-- Check_Invoice_Text_Exists
--    Returns 'TRUE' or 'FALSE' depending on whether there exists an invoice text for 
--    the given invoice id.
@UncheckedAccess
FUNCTION Check_Invoice_Text_Exists (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER) RETURN VARCHAR2
IS   
   CURSOR InvoiceText IS 
      SELECT invoice_text 
      FROM   CUSTOMER_ORDER_INV_HEAD
      WHERE  company = company_
      AND    invoice_id = invoice_id_;   
   temp_ VARCHAR2(2000);
BEGIN   
   OPEN InvoiceText;
   FETCH InvoiceText INTO temp_;
   CLOSE InvoiceText;
   
   IF temp_ IS NULL THEN
      RETURN 'FALSE';
   ELSE
      RETURN 'TRUE';
   END IF;
END Check_Invoice_Text_Exists;

@UncheckedAccess
FUNCTION Get (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER ) RETURN Public_Rec
IS
   temp_ Public_Rec;
   -- gelr:prepayment_tax_document, added prepay_adv_inv_id
   CURSOR get_attr IS
      SELECT identity customer_no, invoice_type, currency currency_code, contract, curr_rate, div_factor, 
             series_id, invoice_no, invoice_date, objstate, fin_curr_rate, pay_term_id,net_curr_amount, 
             vat_curr_amount, correction_invoice_id, rma_no, tax_curr_rate, aggregation_no, final_settlement,
             currency_rate_type, price_adjustment, delivery_address_id, invoice_address_id, delivery_identity, shipment_id,
             tax_id_number, tax_id_type, branch, supply_country_db, use_price_incl_tax_db, advance_invoice,
             use_ref_inv_curr_rate, number_reference, series_reference, component_a, serial_number, creators_reference, prepay_adv_inv_id
      FROM CUSTOMER_ORDER_INV_HEAD
      WHERE company = company_
      AND invoice_id = invoice_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get;



-- Allow_Print_Shipment_Invoice
--   Decides if the shipment invoice is allowed to be printed or not.
@UncheckedAccess
FUNCTION Allow_Print_Shipment_Invoice (
   shipment_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   dummy_    NUMBER;
   CURSOR print_allowed IS
      SELECT 1
      FROM   CUSTOMER_ORDER_INV_HEAD
      WHERE  shipment_id = shipment_id_
      AND    objstate IN ('Preliminary', 'Printed');
BEGIN
   OPEN print_allowed;
   FETCH print_allowed INTO dummy_;
   IF print_allowed%NOTFOUND THEN
      dummy_ := 0;
   END IF;
   CLOSE print_allowed;
   RETURN dummy_;
END Allow_Print_Shipment_Invoice;



-- Remove
--   Delete CustOrderInvoiceHist records for CO Invoice Head.
--   Used for cascade delete when removing a Invoice (INVOIC module).
PROCEDURE Remove (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER )
IS
BEGIN
   Cust_Order_Invoice_Hist_API.Remove(company_, invoice_id_);
END Remove;

FUNCTION Prepayment_Curr_Diff (
   company_                  IN VARCHAR2,
   invoice_id_               IN NUMBER,
   prepay_invoice_no_        IN VARCHAR2,
   prepay_invoice_series_id_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   prepay_inv_id_            NUMBER;
   curr_rate_                NUMBER;
   parallel_curr_rate_       NUMBER;
   prepay_curr_rate_         NUMBER;
   prepay_parallel_rate_     NUMBER;

   CURSOR get_curr_rates(invoice_id_ NUMBER) IS
         SELECT curr_rate, parallel_curr_rate
         FROM  CUSTOMER_ORDER_INV_HEAD
         WHERE company = company_
         AND   invoice_id = invoice_id_;
BEGIN
   prepay_inv_id_ := Get_Invoice_Id_By_No(company_, prepay_invoice_no_, prepay_invoice_series_id_);
   
   OPEN get_curr_rates(invoice_id_);
   FETCH get_curr_rates INTO curr_rate_, parallel_curr_rate_;
   CLOSE get_curr_rates;
   
   OPEN get_curr_rates(prepay_inv_id_);
   FETCH get_curr_rates INTO prepay_curr_rate_, prepay_parallel_rate_;
   CLOSE get_curr_rates;
      
   IF ((curr_rate_ IS NOT NULL) AND (prepay_curr_rate_ IS NOT NULL) AND (curr_rate_ != prepay_curr_rate_) OR
      (parallel_curr_rate_ IS NOT NULL) AND (prepay_parallel_rate_ IS NOT NULL) AND (parallel_curr_rate_ != prepay_parallel_rate_)) THEN
         RETURN TRUE;
   ELSE
         RETURN FALSE;
   END IF;
END Prepayment_Curr_Diff;

PROCEDURE Interim_Voucher_Exist (
   company_      IN VARCHAR2,
   invoice_id_   IN NUMBER,
   voucher_date_ IN DATE)
IS   
   interim_voucher_exist_   BOOLEAN;
   accounting_year_         NUMBER;
   accounting_period_       NUMBER; 
BEGIN   
   Outstanding_Sales_Accting_API.Interim_Voucher_Exist(accounting_year_, accounting_period_, interim_voucher_exist_, invoice_id_, company_, voucher_date_);
   IF (interim_voucher_exist_) THEN
      -- Raise an error if the interim sales vourcher is created for the given invoice id.
      Error_SYS.Record_General(lu_name_,'INTERIMEXIST: Interim sales voucher postings exist for the customer invoice :P1 in accounting period :P2 of accounting year :P3. Therefore, you cannot print the invoice and book the revenue postings to the same or a previous period.'
                               , invoice_id_, accounting_period_, accounting_year_);                               
   END IF;   
END Interim_Voucher_Exist;


-- Get_Shipment_Id
--   Retrieves the shipment_id
@UncheckedAccess
FUNCTION Get_Shipment_Id (
   company_       IN VARCHAR2,
   invoice_id_    IN NUMBER ) RETURN NUMBER
IS
   temp_    CUSTOMER_ORDER_INV_HEAD.shipment_id%TYPE;
   CURSOR get_attr IS
      SELECT shipment_id
      FROM CUSTOMER_ORDER_INV_HEAD
      WHERE company = company_
      AND   invoice_id = invoice_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Shipment_Id;

-- Get_Send_Invoice_Address_Data
--   Retrieves ship address detail required to send customer invoice with 'INVOIC' message
@UncheckedAccess
PROCEDURE Get_Send_Invoice_Address_Data (
   addr_flag_db_ OUT VARCHAR2,
   addr_1_       OUT VARCHAR2,
   address1_     OUT VARCHAR2,
   address2_     OUT VARCHAR2,
   zip_code_     OUT VARCHAR2,
   city_         OUT VARCHAR2,
   state_        OUT VARCHAR2,
   country_code_ OUT VARCHAR2,
   county_       OUT VARCHAR2,
   shipment_id_  OUT VARCHAR2,
   receiver_id_  OUT VARCHAR2,
   order_no_      IN VARCHAR2,
   company_       IN VARCHAR2,
   invoice_id_    IN NUMBER)
IS   
   order_addr_rec_  Customer_Order_Address_API.Cust_Ord_Addr_Rec;
   shipment_rec_    Shipment_API.Public_Rec;
   rma_no_          CUSTOMER_ORDER_INV_HEAD.rma_no%TYPE;
   rma_rec_         Return_Material_API.Public_Rec;
   ref_order_no_    CUSTOMER_ORDER_INV_ITEM.order_no%TYPE;
   addr_data_set_   BOOLEAN := false;

   
BEGIN   
   rma_no_  := Get_Rma_No(company_, invoice_id_);
   IF (rma_no_ IS NOT NULL) THEN
      rma_rec_        := Return_Material_API.Get(rma_no_);
      addr_flag_db_   := rma_rec_.ship_addr_flag;
      addr_1_         := rma_rec_.ship_addr_name;
      address1_       := rma_rec_.ship_address1;
      address2_       := rma_rec_.ship_address2;
      zip_code_       := rma_rec_.ship_addr_zip_code;
      city_           := rma_rec_.ship_addr_city;
      state_          := rma_rec_.ship_addr_state;
      country_code_   := rma_rec_.ship_addr_country_code;
      county_         := rma_rec_.ship_addr_county;
      addr_data_set_  := true;
   ELSIF (order_no_ IS NULL) THEN
      shipment_id_ := Get_Shipment_Id(company_, invoice_id_);
      IF (shipment_id_ IS NOT NULL) THEN
         shipment_rec_ := Shipment_API.Get(shipment_id_);
         addr_flag_db_   := shipment_rec_.addr_flag;
         addr_1_         := shipment_rec_.receiver_address_name;
         address1_       := shipment_rec_.receiver_address1;
         address2_       := shipment_rec_.receiver_address2;
         zip_code_       := shipment_rec_.receiver_zip_code;
         city_           := shipment_rec_.receiver_city;
         state_          := shipment_rec_.receiver_state;
         country_code_   := shipment_rec_.receiver_country;
         county_         := shipment_rec_.receiver_county;
         receiver_id_    := shipment_rec_.receiver_id;
         addr_data_set_  := true;
      END IF;
   END IF;
   IF (NOT addr_data_set_) THEN
      -- For collective customer invoices, need to use order_no from the first invoice item
      IF (order_no_ IS NULL) THEN
         ref_order_no_ := Customer_Order_Inv_Item_API.Get_First_Order(company_, invoice_id_);
      END IF;
      
      order_addr_rec_ := Customer_Order_Address_API.Get_Cust_Ord_Addr(NVL(order_no_, ref_order_no_));
      addr_flag_db_   := order_addr_rec_.addr_flag;
      addr_1_         := order_addr_rec_.addr_1;
      address1_       := order_addr_rec_.address1;
      address2_       := order_addr_rec_.address2;
      zip_code_       := order_addr_rec_.zip_code;
      city_           := order_addr_rec_.city;
      state_          := order_addr_rec_.state;
      country_code_   := order_addr_rec_.country_code;
      county_         := order_addr_rec_.county;
   END IF;   
END Get_Send_Invoice_Address_Data;      

-- Validate_Corr_Reason
--    Returns whether the correction reason exists in header or in all the invoice lines if the user has selected to validate  
--    the correction reason of the particular invoice type.
@UncheckedAccess
FUNCTION Validate_Corr_Reason (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_                      CUSTOMER_ORDER_INV_HEAD.correction_reason%TYPE;
   inv_type_                  CUSTOMER_ORDER_INV_HEAD.invoice_type%TYPE;
   validate_                  VARCHAR2(5):= 'TRUE';
   validate_inv_type_needed_  VARCHAR2(5):= 'FALSE';
   party_type_                CUSTOMER_ORDER_INV_HEAD.PARTY_TYPE%TYPE;
   party_type_cl_             VARCHAR2(200);
      
   CURSOR get_header_corr_reason IS
      SELECT correction_reason, invoice_type, party_type
        FROM CUSTOMER_ORDER_INV_HEAD
       WHERE company = company_
         AND invoice_id = invoice_id_;
  
   CURSOR get_null_corr_reason_lines IS
      SELECT 1
        FROM CUSTOMER_ORDER_INV_ITEM
       WHERE company = company_
         AND invoice_id = invoice_id_
         AND prel_update_allowed = 'TRUE'
         AND correction_reason IS NULL;
BEGIN
      OPEN get_header_corr_reason;
      FETCH get_header_corr_reason INTO temp_, inv_type_, party_type_;
      CLOSE get_header_corr_reason; 
      party_type_cl_ := Party_Type_API.Decode(party_type_);
      validate_inv_type_needed_ := Invoice_Type_API.Get_Validate_Correction_Rea_Db(company_, party_type_cl_, inv_type_);   

      IF validate_inv_type_needed_ = 'TRUE' THEN      
         IF temp_ IS NULL THEN
            OPEN get_null_corr_reason_lines;  
            FETCH get_null_corr_reason_lines INTO temp_;
            IF get_null_corr_reason_lines%FOUND THEN         
               validate_ := 'FALSE';         
            END IF;
            CLOSE get_null_corr_reason_lines;
         END IF;  
      END IF; 
      
   RETURN validate_;
END Validate_Corr_Reason;

-----------------------------------------------------------------------------
-- Check_Corr_Reason_Exists
--   Return TRUE if correction reason exists in the view.
-----------------------------------------------------------------------------
@UncheckedAccess
FUNCTION Check_Corr_Reason_Exists (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER) RETURN VARCHAR2
IS   
   CURSOR CorrReason IS 
      SELECT correction_reason 
      FROM   CUSTOMER_ORDER_INV_HEAD
      WHERE  company = company_
      AND    invoice_id = invoice_id_;   
   temp_ VARCHAR2(2000);
BEGIN   
   OPEN  CorrReason;
   FETCH CorrReason INTO temp_;
   CLOSE CorrReason;
   
   IF temp_ IS NULL THEN
      RETURN 'FALSE';
   ELSE
      RETURN 'TRUE';
   END IF;
END Check_Corr_Reason_Exists;

@UncheckedAccess
FUNCTION Get_Total_Sales_By_Year (
   identity_           IN VARCHAR2,
   company_            IN VARCHAR2,
   quarter_start_date_ IN DATE,
   quarter_end_date_   IN DATE) RETURN NUMBER 
IS 
   total_sales_ NUMBER;
   
   CURSOR get_total_sales IS 
      SELECT SUM(net_dom_amount)
         FROM customer_order_inv_head coi
         WHERE identity        = identity_
         AND   company         LIKE NVL(company_, '%')
         AND   advance_invoice = 'FALSE'
         AND   (invoice_date BETWEEN quarter_start_date_ AND quarter_end_date_)
         AND   EXISTS (SELECT 1
                       FROM user_allowed_site_pub uas, company_site
                       WHERE contract = coi.contract
                       AND   contract = uas.site
                       AND   company  = NVL(company_, '%'));
BEGIN      
   OPEN get_total_sales;
   FETCH get_total_sales INTO total_sales_;
   CLOSE get_total_sales;

   RETURN total_sales_;
END Get_Total_Sales_By_Year;

PROCEDURE Get_Debit_Invoice_Info (
   invoice_type_        OUT VARCHAR2,
   number_reference_    OUT VARCHAR2,
   series_reference_    OUT VARCHAR2,
   company_             IN  VARCHAR2,
   invoice_id_          IN  NUMBER)
IS
   
   CURSOR get_invoice_info IS
      SELECT  invoice_type, number_reference, series_reference
        FROM  CUSTOMER_ORDER_INV_HEAD
       WHERE  invoice_id = invoice_id_
         AND  company = company_ ;
   inv_rec_           get_invoice_info%ROWTYPE;
BEGIN
   OPEN get_invoice_info;
   FETCH get_invoice_info INTO inv_rec_;
   CLOSE get_invoice_info;

   invoice_type_     := inv_rec_.invoice_type;
   number_reference_ := inv_rec_.number_reference;
   series_reference_ := inv_rec_.series_reference;
END Get_Debit_Invoice_Info;

-- gelr:italy_intrastat, start
FUNCTION Get_Party_Type (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ Customer_Order_Inv_Head.party_type%TYPE;
   CURSOR get_party_type IS
      SELECT party_type
      FROM   customer_order_inv_head
      WHERE  company = company_
      AND    invoice_id = invoice_id_;
BEGIN
   OPEN get_party_type;
   FETCH get_party_type INTO temp_;
   CLOSE get_party_type;
   RETURN temp_;
END Get_Party_Type;
-- gelr:italy_intrastat, end

-- gelr:disc_price_rounded, begin
@UncheckedAccess
FUNCTION Get_Discounted_Price_Rounded(
   company_           IN VARCHAR2,
   invoice_id_        IN NUMBER ) RETURN VARCHAR2
IS
   CURSOR get_item_rec IS
      SELECT order_no
      FROM   customer_order_inv_item
      WHERE  company = company_
      AND    invoice_id = invoice_id_;
      
   discounted_price_rounded_ VARCHAR2(5) := 'FALSE';
BEGIN
   FOR item_rec_ IN get_item_rec LOOP
      IF (Customer_Order_API.Get_Discounted_Price_Rounded(item_rec_.order_no)) THEN
         discounted_price_rounded_ := 'TRUE';
      ELSE
         RETURN 'FALSE';
      END IF;
   END LOOP;
   RETURN discounted_price_rounded_;
END Get_Discounted_Price_Rounded;
-- gelr:disc_price_rounded, end


FUNCTION Fetch_Prepayment_Type (
   company_          IN VARCHAR2,
   invoice_type_     IN VARCHAR2,
   adv_invoice_      IN VARCHAR2,
   number_reference_ IN VARCHAR2,
   series_reference_ IN VARCHAR2 ) RETURN VARCHAR2
IS     
   prepayment_type_code_      VARCHAR2(20);
   inv_type_rec_              Company_Def_Invoice_Type_API.Public_Rec;
BEGIN
  $IF Component_Payled_SYS.INSTALLED $THEN
     IF (Company_Pay_Info_API.Get_Prepay_Based_Prepay_Typ_Db(company_) = 'TRUE' AND adv_invoice_ = 'TRUE') THEN
         inv_type_rec_ := Company_Def_Invoice_Type_API.Get(company_);
         IF (invoice_type_ = inv_type_rec_.def_adv_co_dr_inv_type) THEN
            prepayment_type_code_  := Prepayment_Type_API.Get_Default_Prepayment_Type(company_);
         END IF;
      ELSE
         prepayment_type_code_     := NULL;
      END IF;
   $END
   RETURN prepayment_type_code_;
END Fetch_Prepayment_Type;

-- gelr:out_inv_curr_rate_voucher_date, begin
@IgnoreUnitTest DMLOperation
PROCEDURE Change_Cust_Order_Inv_Dates (
   company_           IN VARCHAR2,
   invoice_id_        IN NUMBER) 
IS
   inv_                         customer_order_inv_head%ROWTYPE;
   currency_rate_               NUMBER;
   conv_factor_                 NUMBER;
   tax_curr_rate_               NUMBER;
   fin_curr_rate_               NUMBER;
   base_currency_code_          VARCHAR2(3);
   inverted_                    VARCHAR2(5);
   currency_type_               VARCHAR2(10);
   attr_                        VARCHAR2(2000);
   parallel_curr_rate_          NUMBER;                       
   parallel_conv_factor_        NUMBER;          
   parallel_inverted_           VARCHAR2(5);
   compfin_rec_                 Company_Finance_API.Public_Rec;
   inv_curr_rate_base_date_     DATE;
   tax_curr_rate_base_date_     DATE;
   
   CURSOR getrec IS
      SELECT *
        FROM customer_order_inv_head
       WHERE company = company_
         AND invoice_id = invoice_id_;

   CURSOR get_items IS
      SELECT item_id
        FROM customer_order_inv_item
       WHERE company = company_
         AND invoice_id = invoice_id_;
BEGIN
   OPEN getrec;
   FETCH getrec INTO inv_;
   CLOSE getrec;

   base_currency_code_ := Company_Finance_API.Get_Currency_Code(company_);
   currency_type_ := inv_.currency_rate_type;
   IF (currency_type_ IS NULL) THEN
      currency_type_ := Invoice_Library_API.Get_Default_Currency_Type(inv_.company, 'CUSTOMER', inv_.identity);
   END IF;

   IF Invoice_API.Get_Out_Inv_Curr_Rate_Base_Db(company_, invoice_id_) = 'INVOICE_DATE' THEN
      inv_curr_rate_base_date_ := inv_.invoice_date;
   ELSE
      inv_curr_rate_base_date_ := nvl(inv_.latest_delivery_date, inv_.invoice_date);
   END IF;

   IF Invoice_API.Get_Tax_Sell_Curr_Rate_Base_Db(company_, invoice_id_) = 'INVOICE_DATE' THEN
      tax_curr_rate_base_date_ := inv_.invoice_date;
   ELSE
      tax_curr_rate_base_date_ := nvl(inv_.latest_delivery_date, inv_.invoice_date);
   END IF;
   Currency_Rate_API.Fetch_Currency_Rate_Base(conv_factor_, fin_curr_rate_, inverted_, inv_.company,
                                              inv_.currency, base_currency_code_, currency_type_,
                                              inv_curr_rate_base_date_,
                                              Currency_Code_API.Get_Emu(inv_.company, base_currency_code_));
   Invoice_Library_API.Get_Currency_Rate_Defaults(currency_type_, conv_factor_, currency_rate_,
                                                  inv_.company, inv_.currency, inv_curr_rate_base_date_, 'CUSTOMER', inv_.identity);
   tax_curr_rate_ := Tax_Handling_Invoic_Util_API.Get_Tax_Curr_Rate( inv_.company,
                                                     'CUSTOMER',
                                                     inv_.currency,
                                                     'CUSTOMER_ORDER_INV_HEAD_API',
                                                     fin_curr_rate_,
                                                     tax_curr_rate_base_date_);                                                   
   compfin_rec_ := Company_Finance_API.Get(inv_.company);
   IF (compfin_rec_.parallel_acc_currency IS NOT NULL AND compfin_rec_.parallel_acc_currency != inv_.currency) THEN
      Currency_Rate_API.Get_Parallel_Currency_Rate ( parallel_curr_rate_,
                                                     parallel_conv_factor_,
                                                     parallel_inverted_,
                                                     inv_.company,
                                                     inv_.currency,
                                                     inv_curr_rate_base_date_,
                                                     compfin_rec_.parallel_rate_type,
                                                     compfin_rec_.parallel_base,
                                                     compfin_rec_.currency_code,
                                                     compfin_rec_.parallel_acc_currency,
                                                     NULL,
                                                     NULL);
   END IF;

   IF ((inv_.curr_rate != currency_rate_) OR (inv_.fin_curr_rate != fin_curr_rate_) OR (inv_.tax_curr_rate != tax_curr_rate_) OR (inv_.parallel_curr_rate != parallel_curr_rate_)) THEN
      attr_ := NULL;
      Client_SYS.Add_To_Attr('COMPANY', inv_.company, attr_);
      Client_SYS.Add_To_Attr('INVOICE_ID', inv_.invoice_id, attr_);
      Client_SYS.Add_To_Attr('CURR_RATE', fin_curr_rate_, attr_);
      Client_SYS.Add_To_Attr('N1', currency_rate_, attr_);
      IF nvl(Currency_Type_Basic_Data_API.Get_Use_Tax_Rates(inv_.company),'FALSE') = 'TRUE' THEN
         Client_SYS.Add_To_Attr('TAX_CURR_RATE', tax_curr_rate_, attr_);
      ELSE 
         Client_SYS.Add_To_Attr('TAX_CURR_RATE', fin_curr_rate_, attr_);
      END IF;         
      Client_SYS.Add_To_Attr('PARALLEL_CURR_RATE', NVL(parallel_curr_rate_, inv_.parallel_curr_rate), attr_);         
       
      Customer_Invoice_Pub_Util_API.Modify_Invoice_Head(attr_, 'CUSTOMER_ORDER_INV_HEAD_API');

      FOR item_rec_ IN get_items LOOP
         Customer_Order_Inv_Item_API.Recalculate_Line_Amounts__(inv_.company, inv_.invoice_id, item_rec_.item_id);
      END LOOP ;
   END IF;   
END Change_Cust_Order_Inv_Dates;
-- gelr:out_inv_curr_rate_voucher_date, end

-- gelr:br_external_tax_integration, begin
@IgnoreUnitTest DMLOperation
PROCEDURE Update_Complimentary_Info(
   company_             IN VARCHAR2,
   invoice_id_          IN NUMBER,
   complementary_info_  IN VARCHAR2)
IS
   attr_                VARCHAR2(4000);
BEGIN   
   IF company_ IS NOT NULL AND invoice_id_ IS NOT NULL THEN
      attr_ := NULL;
      Client_SYS.Add_To_Attr('COMPANY', company_, attr_);
      Client_SYS.Add_To_Attr('INVOICE_ID', invoice_id_, attr_);
      Client_SYS.Add_To_Attr('INVOICE_TEXT', complementary_info_, attr_);
      Customer_Invoice_Pub_Util_API.Modify_Invoice_Head(attr_, 'CUSTOMER_ORDER_INV_HEAD_API');
   END IF;
END Update_Complimentary_Info;
-- gelr:br_external_tax_integration, end

-- gelr: outgoing_fiscal_note, begin
--------------------------------------------------------------------------
-- Get_Fiscal_Note_Ref_Info
--    Returns CO specific info required for fiscal note
--------------------------------------------------------------------------
PROCEDURE Get_Fiscal_Note_Ref_Info(
   contract_                  OUT   VARCHAR2,
   business_transaction_id_   OUT   VARCHAR2,
   final_consumer_            OUT   VARCHAR2,
   company_                   IN    VARCHAR2,
   invoice_id_                IN    NUMBER)
IS
   inv_rec_       Customer_Order_Inv_Head_API.Public_Rec;
   order_rec_     Customer_Order_API.Public_Rec; 
   creators_reference_  CUSTOMER_ORDER_INV_HEAD.creators_reference%TYPE;
   
   -- in shipment invoice business transaction id and final consumer is same for all connected order
   CURSOR get_order_no IS
      SELECT order_no
      FROM   customer_order_inv_item
      WHERE  company = company_
      AND    invoice_id = invoice_id_
      AND    rownum = 1;
BEGIN
   inv_rec_ := Get(company_, invoice_id_);
   contract_ := inv_rec_.contract;
   creators_reference_ := inv_rec_.creators_reference;
     
   IF inv_rec_.shipment_id IS NOT NULL THEN
      OPEN get_order_no;
      FETCH get_order_no INTO creators_reference_;
      CLOSE get_order_no;
   END IF;

   order_rec_ := Customer_Order_API.Get(creators_reference_);
   final_consumer_ := order_rec_.final_consumer;
   business_transaction_id_ := order_rec_.business_transaction_id; 
END Get_Fiscal_Note_Ref_Info;
-- gelr: outgoing_fiscal_note, end
