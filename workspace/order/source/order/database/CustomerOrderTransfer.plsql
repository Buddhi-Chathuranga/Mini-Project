-----------------------------------------------------------------------------
--
--  Logical unit: CustomerOrderTransfer
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign     History
--  ------  ------   ---------------------------------------------------------
--  211206  RoJalk   SC21R2-2756, Modified Create_Disadv_Struct_Info and passed NUll for activity seq for Dispatch_Advice_Utility_API.Create_Line call.
--  210205  ChBnlk   SC2020R1-12434, Modified Create_Disadv_Struct_Info() to reassigned the fetch line rec to the main dispatch advice array.
--  210202  ChBnlk   SC2020R1-12378, Moved methods related to SendOrderConfirmation to the utility SendOrderConfirmationMsg.
--  210122  ChBnlk   SC2020R1-12027, Modified Create_Disadv_Struct_Info() in order to use Dispatch_Advice_Dispatch_Advice_Line_Arr.
--  210125  DhAplk   SC2020R1-12242, Added is_json_ param to Post_Outbound_Message() method call in Send_Order_Conf_Inet_Trans___.
--  210115  DhAplk   SC2020R1-11651, Modified Send_Agreement by moving logic to Send_Price_Catalog_Msg_API to work with modelling support in BizApi relpacement.
--  210115           Moved Do_Send_Price_List logic to Send_Price_Catalog_Msg_API
--  201203  ChBnlk   SC2020R1-11654, Added order_no_ to the structure in Set_Order_Conf_Struct_Rec___.
--  201202  ChBnlk   SC2020R1-11523, Changed code Related to ReceiveOrder, ReceiveOrderChange and SendOrderConfirmation messages based on the code review comments.
--  201125  DhAplk   SC2020R1-11522, Chanaged language_code fetching location in Send_Agreement method.
--  201115  ChBnlk   SC2020R1-11346, Restructured the Send_Order_Conf_Inet_Trans___() and related methods in order to stop using the 
--  201115           generated get methods to fetch data. Created Get_Send_Cust_Order_Struct_Rec___() to use the original cursors used in EDI flow to fetch data in ITS as well.
--  201109  RoJalk   Bug 151021(SCZ-11633), Set C35 of message header as document text from customer in Send_Order_Confirmation (ORDRSP).
--  201109  DhAplk   SC2020R1-11290, Handled the exceptions in Receive_Order, Receive_Order_Inet_Trans.
--  201105  DhAplk   SC2020R1-11286, Handled the exceptions in Receive_Order_Change, Receive_Order_Chg_Inet_Trans.
--  201104  Erlise   Bug 146145(SCZ-11653), Modified Send_Order_Conf_Mhs_Edi___() and Get_Message_Line_Status___(). Added delivery_terms and del_terms_location to the check status changed conditions.
--  201104           Removed UPPER function on line level attribute del_term_location, (C25).
--  201019  ChBnlk   SC2020R1-10738, Replace conditional compilation check for ITS with method Dictionary_SYS.Component_Is_Active('ITS').
--  201016  RoJalk   Bug 154791(SCZ-11814), Modified Get_Supplier_Id() to get the correct supplier id by fetching customer_po_no from Customer_Order_Line_API.Get_Info_For_Desadv.
--  200910  ChBnlk   SC2020R1-817, Corrected Send_Order_Conf_Inet_Trans___, Get_Order_Conf_Head_Data___ in order to pass proper values. 
--  200910           Also corrected the code to receive multiple configurations in ReceiveCustomerOrder and ReceiveCustomerOrderChange ITS flows.
--  201002  MalLlk   SC2020R1-10234, Modified Set_Customer_Order_Line_Arr___ to add parameter media_code_ and passed it to the message text.
--  280929  ChBnlk   SC2020R1-817, Modified  Send_Order_Conf_Inet_Trans___ to get json_clobs directly from generated methods.
--  280920  DhAplk   SC2020R1-820, Modified Do_Send_Price_List and Send_Agreement methods to get json_clobs directly from generated methods.
--  180920  ChBnlk   SC2020R1-9656, Added component check ITS to execute INET_TRANS message passing related codes only when ITS is istalled.         
--  200904  MalLlk   SC2020R1-9589, Modified Receive_Order_Change() to get the order no from Message rows and pass to External_Customer_Order_API.New via attr.
--  200811  DhAplk   SC2020R1-813, Modified Receive_Receiving_Advice() method by moving some logic part to Receive_Rec_Advice_Msg_API.Process_Aftr_Recv_Rec_Advice__()
--  200810  ChBnlk   SC2020R1-8997, Modified Receive_Order() and Receive_Order_Change() to pass internal_delivery_type_db_ in to Get_Data_Receive_Cust_Order_Line___() instead of internal_delivery_type_
--  200810           since it needs to be reused.
--  200804  RasDlk   SC2020R1-8981, Replaced the method Create_Line_From_Dis_Adv_Struct from Create_Line_From_Dis_Adv_Stct since the procedure name is longer than the allowed maximum of 30 characters.
--  200717  ChBnlk   SC2020R1-818, Modified the method Create_Disadv_Struct_Info() to call Create_Line_From_Dis_Adv_Struct when ITS
--  200717           message parsing is used.
--  200701  DilMlk   Bug 151904 (SCZ-8562), Modified Send_Order_Confirmation to pass ship_via_code, forward_agent_id and ext_transport_calendar_id when supply code is changed.
--  200630  ChBnlk   SC2020R1-817, Introduced new method Set_Customer_Order_Line_Arr___() in order to set the line attributes in 
--  200630           SendCustomerOrderResponse.
--  200624  ChBnlk   SC2020R1-7485, Included the methods related to ReceiveCustomerOrder and ReceiveCustOrderChange ITS message implementations
--  200624           since the implementation was moved to the CustomerOrderTransfer fragment.
--  200624  DhAplk   SC2020R1-814, Modified Receive_Self_Billing_Invoice by moving approving code part to Approve_Self_Billing_Invoice() method.
--  200622  ChBnlk   SC2020R1-817,  Added new methods Send_Order_Conf_Inet_Trans___(), Send_Order_Conf_Mhs_Edi___(),  Get_Comm_Methods___(),
--  200622           Get_Order_Conf_Head_Common___() and Post_Send_Order_Conf___() to handle send order confirmation related message passing.
--  200601  DhAplk   SC2020R1-820 Modified the Do_Send_Price_List by removing the conectivity message creation for INET_TRANS media code, and instead creating an Applciation message directly with XML message.
--  200529  MiKulk   SC2020R1-820 Modified the Send_Agreement by removing the conectivity message creation for INET_TRANS media code, and instead creating an Applciation message directly with  XML message.
--  200519  ChBnlk   SC2020R1-6906, Added new methods Receive_Order_Header_Common, Receive_Cust_Order_Line_Common, Approve_Receive_Change_Order___ and 
--  200519           Approve_Receive_Change_Order___ to handle InetTrans message passing.
--  200430  ChBnlk   SC2020R1-807, Introduced new methods Receive_Order_Inet_Trans(), Get_Next_Message_Line___() and reimplemented the methods
--  200430           Ext_Cust_Ord_Struct_New___(), Ext_Cust_Ord_Line_Struct_New___(), Ext_Cust_Ord_Struct_External_Cust_Order_Line_Copy_From_Header___(), Receive_Cust_Order_Common___()
--  200430           and Receive_Cust_Order_Line_Common().
--  200430           and Ext_Cust_Ord_Struct_External_Cust_Order_Char_Copy_From_Header___() in order to convert the ReceiveCustomerOrder biz api.
--  200306  BudKlk   Bug 152611 (SCZ-9190), Modified Receive_Order_Change() by increasing the length of Contact_ field into 100.
--  190710  UdGnlk   Bug 148954(SCZ-5636), Modified Get_Supplier_Id to retrieve correct supplier for IPD orders when three sites intersite scenario.
--  190613  ErFelk   Bug 148686(SCZ-5368), Modified Send_Order_Confirmation() so that if ext_transport_calendar_id and packing_instruction_id is NULL it is not taken for comparison to marked the record as changed. 
--  190526  KiSalk   Bug 144005(SCZ-1015), Renamed method Send_Price_List as Do_Send_Price_List and Added two new methods Send_Price_List and Send_Price_List__ to call that in background.
--  180103  ErFelk   Bug 146104(SCZ-2510), Modified Send_Order_Confirmation() so that if external picking_leadtime, delivery_leadtime, route_id and forward_agent_id is NULL 
--  180103           it is not taken for comparison to marked the record as changed.
--  181204  ErFelk   Bug 145644(SCZ-2119), Modified Send_Order_Confirmation() so that if extrec_.picking_leadtime and extrec_.delivery_leadtime is NULL it won't be taken for comparison. 
--  180719  DiKuLk   Bug 142977, Modified Send_Price_List(), Send_Agreement() and Send_Order_Confirmation() to add customer_email_id ,company_association_no and customer_association_no to EDI/ITS in 'PRICAT'
--  180717           and 'ORDRSP' message type.
--  180508  DilMlk   Bug 141385, Modified methods Receive_Order and Receive_Order_Change to pass zero when null is received as discount, to prevent refetching discount when creating CO from incoming CO.
--  180508  DilMlk   Bug 140771, Modified method Add_Org_Line_Values__ to prevent getting unit_price_incl_tax as changed, when the value is actually not changed.
--  180222  RoJalk   STRSC-16106, Reversed the correction done in Send_Order_Confirmation. 
--  180222  RoJalk   STRSC-16106, Modified Send_Order_Confirmation to compare delivery_leadtime, picking_leadtime only if it is not null in extrec_
--  180206  IzShlk   STRSC-16836, Modified Add_Org_Line_Values__() by adding Org_District_code, Org_Region_code, Org_cust_calendar_id, org_ext_trans_calendar_id and org_contact difference.
--  180202  IzShlk   STRSC-15535, Modified Add_Org_Line_Values__() method by adding ORG_FORWARD_AGENT_ID and ORG_ROUTE_ID to contain the orginal values before editing.
--  180129  JaThlk   Bug 139913, Modified Receive_Order() and Receive_Order_Change() to assign INTERNAL_PO_NO value only if the order code equals to 4.
--  180125  ErRalk   Bug 139449, Added Org_originating_co_lang_code value to attr in Add_Org_Line_Values___
--  180124  JaThlk   Bug 138609, Modified Send_Order_Confirmation() to set del_terms_location value to uppercase.
--  180124  NiLalk   Bug 139728, Modified Add_Org_Line_Values__() method by adding org_dock_code, org_sub_dock_code and org_location to contain the orginal values before editing.
--  180116  JaThlk   Bug 138609, Modified Send_Order_Confirmation() to set ship_via_code, forward_agent_id, delivery_terms and del_terms_location for IPT and IPD.
--  180102  SBalLK   Bug 139544, Modified Receive_Order() and Receive_Order_Change() method to reset send price flag before start new iteration for avoid using old values from previous iteration.
--  171003  KiSalk   Bug 138079, Modified Find_Order_No_For_Ext_Cust___ and Find_Order_No_For_Int_Cust___ to fetch order_no giving priority to other states over Cancelled.
--  170504  SBalLK   Bug 135106, Restore the INET_TRANS validation removed during the bug merge 135106.
--  170405  MeAblk   Bug 135149,  Modified Send_Order_Confirmation() to correctly set the supplier id for attribute C32 in an intersite flow.  
--  170405  SBalLK   Bug 135106, Modified Receive_Order() and Receive_Order_Change() methods to handle unhandled TO_NUMBER() conversion exceptions.
--  170404  JeeJlk   Bug 134807, Modified Send_Order_Confirmation() by introducing messageType and medioCode.
--  170331  NaLrlk   LIM-11285, Modified Get_Supplier_Id() to extend the solution for IPD demand code.
--  170322  NaLrlk   LIM-11162, Modified Receive_Order() and Receive_Order_Change() to fetch customer_po_line_no and customer_po_rel_no from c32 and c33 line level from the message.
--  170320  NaLrlk   LIM-11226, Modified Receive_Order and Receive_Order_Change to support packing_instruction_id in ORDERS and ORDCHG messages.
--  160923  TiRalk   Bug 131552, Modified Receive_Order to initialize shipment_type_ in the message line level.
--  160921  Maabse   APPUXX-4844, Added b2b_process_online with support for ship_addr_no and bill_addr_no.
--  160826  ChFolk   STRSC-3938, Modified Send_Price_List to consider timeframe lines when creating new send message lines.
--  160821  ChFolk   STRSC-3729, Modified Send_Price_List to create new message lines based on periods defined in the send dialog.
--  160808  ChFolk   STRSC-3729, Modified Send_Price_List to include valid_to_date in sales price list lines to the message.
--  160801  ChBnlk   Bug 129894, Modified Receive_Order() by adding value of package_content in to the attribute string when transfering 
--  160801           configuration characteristics. 
--  160801  ChFolk   STRSC-3675, Modified Send_Agreement to send the correct agreement line considering valid_to_date. Also included the valid_to_date in message line.
--  160720  NWeelk   FINHR-1322, Changed VAT_PAY_TAX to TAX_LIABILITY.  
--  160720  RoJalk   LIM-8034, Modified Create_Dirdel_Transit_Row___ and passed handling_unit_id_. Modified
--  160720           Send_Direct_Delivery to include handling unit id in the DIRDEL mesage.  
--  160704  MaRalk   LIM-7671, Modified method Send_Direct_Delivery in order to reflect column renaming in
--  160704           delivery_note_tab - deliver_to_customer_no as receiver_id. 
--  160627  RoJalk   LIM-7824, Added the method Create_Disadv_Struct_Info moving out
--  160627           the code from Dispatch_Advice_Utility_API.Create_Disadv_Struct_Info___.
--  160624  RoJalk   LIM-7680, Added the method  Post_Send_Dispatch_Advice.
--  160623  SudJlk   STRSC-2697, Replaced customer_Order_Address_API.Public_Rec with customer_Order_Address_API.Cust_Ord_Addr_Rec and 
--  160623           customer_Order_Address_API.Get() with customer_Order_Address_API.Get_Cust_Ord_Addr().
--  160623  Chgulk   STRLOC-249, Added new Address fields.
--  160613  RoJalk   LIM-7680, Moved code related to dispacth advise to DispatchAdviceUtility.
--  160613  RoJalk   LIM-7682, Code improvements to the method Create_Disadv_Struct_Info___, changed the scope of Get_Supplier_Id___ to be public.
--  160608  MaIklk   LIM-7442, Fixed the usages of renaming Customer_Order_Deliv_Note to Delivery_Note.
--  160504  SeJalk   Bug 128920, Modified Receive_Order_Change to do online approval only if automatic approval selected by checking approval user exists. 
--  160309  MaRalk   LIM-5871, Modified Create_Disadv_Line___ - get_connected_row cursor 
--  160309           to reflect shipment_line_tab-sourece_ref4 data type change.
--  160225  RoJalk   LIM-5934, Modified Create_Disadv_Struct_Info___ and fetched source info from shipment_line_tab.
--  160211  RoJalk   LIM-5933, Modified Create_Disadv_Line___ and used shipment_line_pub.
--  160201  MaRalk   LIM-6114, Replaced shipment_rec_.ship_addr_no usages with shipment_rec_.receiver_addr_id
--  160201           in Create_Disadv_Address_Info___ method.
--	 151228	HiFelk	STRFI-20, Replaced Customer_Info_api.Get_Country_Code with Customer_Info_api.Get_Country_Db
--  151202  RoJalk   LIM-5178, Rename ORDER_NO, LINE_NO, REL_NO, LINE_ITEM_NO to SOURCE_REF1,
--  151202           SOURCE_REF2, SOURCE_REF3, SOURCE_REF4 in ShipmentLine and ShipmentLineHandlUnit. 
--  151119  IsSalk   FINHR-327, Renamed attribute VAT_NO to TAX_ID_NO in Customer Order.
--  151120  PrYaLK   Bug 125018, In Create_Disadv_Struct_Info___, Changed the cursor get_handling_units to select top and second level handling units, because shipment_id is in all the records now.
--  151110  MaIklk   LIM-4059, Renamed deilver_to_customer_no to receiver_id and renamed address fields to sender_xxx and receiver_xxx of shipment table.
--  151110  RoJalk   LIM-4610, Rename ShipmentOrderLine LU to ShipmentLine.
--  151109  MaEelk   LIM-4453, Removed pallet_id from cursors.
--  151005  JeeJlk   Bug 124635, Modified Add_Org_Line_Values___ a private method.
--  150928  AyAmlk   Bug 124566, Modified Create_Disadv_Line___() by sending the Sales Part No as the Customer's Part No when there is no Customer's Part No or a GTIN No
--  150928           and an internal PO is connected to the CO.
--  150907  TiRalk   AFT-3548, Modified Create_Disadv_Struct_Info___() to get value properly from cursor get_reservation.
--  150605  JaBalk   RED-361, Modified Receive_Order_Change to send the RENTAL_TRANSFER value come from C62 to 
--  150526  IsSalk   KES-510, Modified cursors with Customer_Order_Delivery_TAB to filter out cancelled CO deliver lines.
--  150605           receiving rental customer order line when executing rental transfer.
--  150819  PrYaLK   Bug 121587, Modified calculating shipped_qty_ in Create_Disadv_Line___() by adding cust_part_invert_conv_fact. Modified Send_Order_Confirmation()
--  150819           by fetching both conv_factor and  inverted_conv_factor using Sales_Part_Cross_Reference_API.Get(). Modified message transfer number
--  150819           in Send_Order_Confirmation() to N22.
--  150810  Kisalk   Bug 123972, Changed view customer_order_deliv_note_main to customer_order_deliv_note_tab table in join of second part of UNION, in cursor get_order_row of 
--  150810           Create_Disadv_Struct_Info___. Added a condition to check for delnote_no_ to stop the query retrieving all the customer_order_deliv_note records giving bad performance.
--  150723  PrYaLK   Bug 123113, Modified Create_Disadv_Header_Info___() to fetch the actual_ship_date_.
--  150714  RasDlk   Bug 123394, Modified Send_Order_Confirmation to add a new entry to customer order line history when sending an order confirmation. 
--  150623  SeJalk   Bug 123118, Ignored Impersonation when approving the order change in online flow due to lack of impersonate rights in method Receive_Order_Change.
--  150303  MeAblk   Bug 121203, Modified Receive_Order_Change () in order to receive vendor_part_desc.
--  150209  Chfose   PRSC-5657, Extracted the retrieving edi_auto_approval_user part from Receive_Order_Change into a new function: Get_Auto_Change_Approval_User.
--  150202  RoJalk   Bug 120668, Modified the cursors in Add_Org_Line_Values___() in order to allow adding the original values of the part when the sales part in the supply site is a package part.
--  150130  RoJalk   Modified Send_Order_Confirmation and used Validate_SYS.Is_Changed.
--  150128  RoJalk   PRSC-5445, Modified Send_Order_Confirmation and modified/verified that all comparisons include the new values
--  150128           ship_via_code, forward_agent_id, ext_transport_calendar_id, packing_instruction_id, route_id, picking_leadtime and delivery_leadtime. 
--  150122  RoJalk   PRSC-5297, Modified Add_Org_Header_Values___ and set a value for org_print_delivered_lines.
--  141218  MAHPLK   PRSC-4493, Modified Receive_Order_Change to receive CHANGED_ATTRIB_NOT_IN_POL from ORDCHG. 
--  141209  RasDlk   Bug 103391, Modified Create_Disadv_Struct_Info___ by correcting an issue in addr_flag matching and
--  141209           removing an additional where cluase which selects package parts incorrectly. 
--  141209           Modified cursor get_connected_row in method Create_Disadv_Line___ not to fetch component lines to shipment delivery note. 
--  141111  RoJalk   LCS 119048 merge,, Modified Receive_Order and Receive_Order_Change to stop receiving delivery leadtime for transit deliveries.
--  KiSAlk  KiSalk   PRSC-2788, In addition to bug 117617 merge, corrected Create_Disadv_Line___ not to set shipped_qty_ null when acquisition_site_ is null.
--  141121  RoJalk   PRSC-4338, Modified Send_Order_Confirmation and added missing dynamic calls for PURCH.
--  141028  ErFelk   Bug 118530, Modified Receive_Order() and Receive_Order_Change() by receiving the discount value to N06. This will get transfered to 
--  141028           the CO line only if C16 value is SENDPRICE.
--  141027  AyAmlk   Bug 119307, Modified Create_Disadv_Struct_Info___() so that shipment line information will be added to the dispatch advice when the lines are not connected
--  141027           to a handling unit when unattached shipment lines are allowed.
--  141023  RoJalk   Modified Modified Receive_Order_Change and Receive_Order to handle RINT_DELIVERED_LINES_DB.
--  141020  Chfose   Added error msg in Send_Dispatch_Advice when entering an invalid media_code_.
--  141015  RoJalk   Modified Receive_Order_Change and added code to handle C44,C45 and C46.
--  140923  IsSalk   Bug 118218, Added parameter valid_from_ to the method Send_Agreement() and modified it in order to
--  140923           send only valid agreement lines for a certain date via PRICAT message.
--  140922  MAHPLK   PRSC-3084, Modified Send_Order_Confirmation to pass forward_agent_id through ORDRSP message.
--  140912  MAHPLK   PRSC-2584, Modified Send_Order_Confirmation to pass ship_via_code through ORDRSP message.
--  140911  NaLrlk   Modified Receive_Order() to receice REPLACEMENT_RENTAL_NO in intersite rental swap.
--  140731  BudKlk   Bug 117103, Modified Send_Direct_Delivery() and Send_Order_Confirmation() to show the pay_term_desc in messages. 
--  140730  RoJalk   Modified session_id_ parameter to be NOT NULL in Customer_Order_Transfer_API.Send_Direct_Delivery.
--  140730  RoJalk   Removed the methods Clear_Temporary_Table and Fill_Temporary_Table___.
--  140729  RoJalk   Modified Send_Direct_Delivery, Send_Multi_Tier_Dir_Delivery to use  Temporary_Mul_Tier_Dirdel_API.
--  140724  RoJalk   Modified Fill_Temporary_Table___, Send_Direct_Delivery, Send_Multi_Tier_Dir_Delivery to support delive_no.
--  140708  KiSalk   Bug 117617, Modified Create_Disadv_Line___ to send Dispatch Advice in Demand qty and UOM when ordering and supply sites has the part number in two different names.
--  140707  RoJalk   Defined data types Dirdel_Row_Rec, Dirdel_Row_Tab and added methods Create_Dirdel_Row___, Create_Dirdel_Transit_Row___, Fill_Temporary_Table___,
--  140707           Clear_Temporary_Table and Send_Multi_Tier_Dir_Delivery. Split the logic in to two sections in Send_Direct_Delivery based 
--  140707           on to delnote_no_ to handle delivery notification based on delivery note and multi-tier delivery notification info in temp table.
--  140707  MAHPLK   Modified Receive_Order_Change method to enable online execution of ORDCHG message.
--  140703  Cpeilk   Bug 117342, Modified Send_Order_Confirmation to send delivery_leadtime when demand_code is IPD. 
--  140702  MaEdlk   Bug 117072, Removed rounding of net weight and tare weight at Create_Disadv_Struct_Info___.
--  140623  ShKolk   Added use_price_incl_tax and sales_price_incl_tax to PRICAT message.
--  140613  ShKolk   Added unit_price_incl_tax,base_unit_price_incl_tax,Total Incl Tax/Base to ORDRSP message.
--  140612  NaLrlk   Modified Send_Price_List() to exclude rental sales price list lines.
--  140609  ShKolk   Modified Receive_Order(), Receive_Order_Change() to receive UNIT_PRICE_INCL_TAX from ORDERS/ORDCHG messages.
--  140520  JeLise   Added customer_no_ in cursor get_xref_info.
--  140410  Vwloza   Updated Send_Order_Confirmation() with org_rental_start_date and org_rental_end_date support.
--  140409  RoJalk   Removed the unused cursor get_expiration_date from Create_Disadv_Struct_Info___.
--  140317  AyAmlk   Bug 114798, Modified Send_Direct_Delivery() to send the qty_delivered_ and qty_shipped in customer unit of measure to avoid incorrect qty calculations.
--  140304  RoJalk   Bug 113799, Modified methods Receive_Order and Receive_Order_Change by setting NULL to the variables sales_unit_price_and catalog_desc_ 
--  140304           inside the LOOP which creates the Transfer Customer Order Row. Additionally set NULL to route_id_, delivery_terms_, delivery_terms_desc_, ean_location_del_addr_.
--  140116  NaLrlk   Modified Receive_Order(), Receive_Order_Change() to handle sender_id for INET_TRANS messages.
--  131219  ChBnlk   Bug 113704, Modified Receive_Order_Change() and Add_Org_Line_Values___() by adding CONFIGURATION_ID to the attribute string.
--  131218  Cpeilk   Bug 114360, Modified method Send_Direct_Delivery to prevent sending pay_term_id in DIRDEL message when demand_code is IPD. 
--  131023  SURBLK   Modified CATALOG_DESC as c68 and SHIPMENT_TYPE as c73.
--  130917  KiSalk   Bug 108888, Reversed adding CATALOG_DESC to attribute unconditionally in Receive_Order, done early for this bug.
--  130915  PraWlk   Bug 110205, Modified Create_Disadv_Struct_Info___() by re-implementing the cursor get_order_row to do the comparison of ship_via_code_, 
--  130915           delivery_terms_ and forward_agent_id_ with the respective values of CUSTOMER_ORDER_DELIV_NOTE. 
--  130915  KiSalk   Bug 108888, Modified Receive_Order and added column CATALOG_DESC when transfering customer order row. Added new column VENDOR_PART_DESC.
--  130902  MeAblk   Modified Create_Disadv_Address_Info___ in order to add C88 AND C89.
--  130830  HimRlk   Merged Bug 110133-PIV, Modified method Send_Order_Confirmation() by changing Calculation logic of line discount amount to be consistent with discount postings.
--  130808  ShKolk   Added Get_Same_Database___ to return if multi database inter-site setup is used.
--  130807  NWeelk   Bug 111699, Modified method Send_Order_Confirmation by adding an ORDER BY clause to the cursor get_line_info 
--  130807           in order to get the order confirmation lines sorted in the message.
--  130802  MaRalk   TIBE-2500, Removed unwanted converting like Client_SYS.Attr_Value_To_Date and Attr_Value_To_Number from Receive_Order, Receive_Order_Change
--  130802           methods after implementation of Connectivity_SYS function calls with IN_MESSAGE_LINE_PUB. 
--  130726  MaEelk   Removed the usage of the view SHIPMENT_HANDLING_UTILITY in Create_Disadv_Struct_Info___
--  130725  MaEelk   Removed the unused cursor get_no_packages in Create_Disadv_Struct_Info___
--  130718  MaIklk   TIBE-2402,Removed depricated Connectivity_SYS function calls. Instead defined the own cursor using IN_MESSAGE_LINE_PUB in relevant procedures.
--  130716  MeAblk   Added C22, C23, C24 into the DESADV message by modifying the method Create_Disadv_Struct_Info___.
--  130712  ShKolk   Modified fetching sequence of edi_authorize_code, edi_auto_order_approval and edi_auto_change_approval to Site/Customer, Site, Customer.
--  130705  MaIklk   TIBE-988, Removed global constants inst_DistributionOrder_ and inst_Supplier_. Used conditional compilation instead.
--  130701  SudJlk   Bug 107700, Modified Receive_Order to remove generation of order_no as the functionality will be replaced by autonomous transaction.
--  130630  RuLiLk   Bug 110133, Modified method Send_Order_Confirmation() by changing Calculation logic of line discount amount to be consistent with discount postings.
--  130618  RoJalk   Renamed the method Get_Qty_On_Handling_Unit to Get_Line_Attached_Qty.
--  130617  NiDalk   Bug 107725, Modified Send_Order_Confirmation to send customer_part_buy_qty instead of buy_qty_due and send customer_part_conv_factor_ in line datails.
--  130617           Also modified checks for status changed to consider customer_part_buy_qty instead of buy_qty_due. 
--  130617  MeAblk   Modified Create_Disadv_Address_Info___ in order to restructure the way of adding LINE rows in DESADV.  
--  130613  SURBLK   Added edi_auto_order_approval and edi_auto_change_approval from site validations in Receive_Order and Receive_Order_Change.
--  130610  MeAblk   Modified methods Create_Disadv_Address_Info___, Create_Disadv_Struct_Info___ in order to retrieve data from the shipment handling unit structure. 
--  130513  MalLlk   Bug 109226, Modified method Send_Direct_Delivery to add default parameter multiple_messages_ and 
--  130513           to get the value for delnote no when self billing and more than one message sending when finalizing a shipment.
--  130417  SURBLK   Modified Receive_Order and Receive_Order_Change to add CUST_CALENDAR_ID and EXT_TRANSPORT_CALENDAR_ID to ORDERS AND ORDCHG messages.
--  130417  JeeJlk   Modified Receive_Order and Receive_Order_Change to add originating_co_lang_code to ORDERS AND ORDCHG messages.  
--  130409  MeAblk   Modified Receive_Order and Receive_Order_Change to add packing_instruction_id to ORDERS and ORDCHG messages.
--  130318  AyAmlk   Bug 108479, Modified Receive_Order() and Receive_Order_Change()to set the internal_delivery_type_ values as characters to prevent character number comparison.
--  130226  SALIDE   EDEL-2020, changed the use of company_name2 to name
--  130212  SBalLK   Bug 107802, Modified Receive_Order() method to have shipment creation method when supply code IPD is used with customer order.
--  130215  NipKlk   Bug 108331, Modified Receive_Self_Billing_Invoice() by adding a new message field for receiving the price conversion factor.
--  121231  NWeelk   Bug 107399, Modified Send_Order_Confirmation by changing the cursor get_external_info by checking rowstate 
--  121231           to exclude Cancelled records from ext_cust_order_line_change_tab.
--  121204  AyAmlk   Bug 106840, Modified Receive_Order() and Receive_Order_Change() to show the INTERNAL_PO_NO in the CUSTOMER_PO_NO field when receiving 
--  121204           Incoming Customer Order for inter company set up.
--  120918  NipKlk   Bug 103994, Modified Send_Direct_Delivery() by adding an if condition to calculate the shipped qty using conversion factor if only an inventory part exists.
--  120905  MAHPLK   Modified Receive_Order and Receive_Order_Change to add picking_leadtime and shipment_type to ORDERS and ORDCHG messages.
--  120731  NipKlk   Bug 104191, Modified Send_Direct_Delivery() by adding the retrieved alt_delnote_no_ instead of delnote_no_ for C02 column in the message line.
--  120619  NaLrlk   Bug 102400, Modified Send_Order_Confirmation() by changing get_external_line_change cursor to fetch the latest record with state CHANGED or NOT AMENDED.
--  120412  AyAmlk   Bug 100608, Changed the length to 5 of delivery_terms_ in Create_Disadv_Address_Info___(), Create_Disadv_Struct_Info___(),
--  120412           and cust_delivery_terms_ in Receive_Order(), Receive_Order_Change().
--  120404  NaLrlk   Modified Create_Disadv_Line___ to correct the demand_order_ref variable declaration from customer_order_line_tab.
--  120328  MeAblk   Bug 101696, Modified the method Send_Direct_Delivery() to add expiration_date in to the SELECT and GROUP BY statement of the 
--  120328           cursor get_transit_row_info in order to get the transit rows according to their expiration dates. Removed the cursor
--  120328           get_expiration_date as it is not relavent anymore (There can be many transit lines having different expiration dates).  
--  120314  KiSalk   Bug 101670, Modified Send_Direct_Delivery to convert qty_shipped in inventory UoM to that of acquisition_site, in order to avoid different base unit error.
--  120323  MaMalk   Modified Send_Agreement to remove the line which sent the header valid from date for the line, so that the line valid from date is passed correctly.
--  120320  HimRlk   Bug 101735, Modified Send_Order_Confirmation() by changing cursor get_external_line_change by removing MAX message_id and adding order by clause
--  120320           to take the record with the highest message_id of the changed lines. 
--  120312  MaMalk   Bug 99430, Modified the code to consider inverted_conv_factor where conv_factor has been considered.
--  120308  Darklk   Bug 101588, Modified method Send_Order_Confirmation by changing the total discount calculation according to the discount posting calculatoin.
--  120229  SudJlk   Bug 101292, Modified Send_Order_Confirmation to correctly set value for chg_req_exists_ for CO lines where no change has been made through a change request.
--  120222  NaLrlk   Modified Create_Disadv_Line___, Receive_Order, Receive_Order_Change, Send_Order_Confirmation to remove input_unit_meas and input_conv_factor from message.
--  120130  NaLrlk   Replaced the method call Part_Catalog_API.Get_Active_Gtin_No with Part_Gtin_API.Get_Default_Gtin_No.
--  120126  NaLrlk   Modified Receive_Order and Receive_Order_Change to change the method calls Part_Input_Unit_Meas_API to Part_Gtin_Unit_Meas_API.
--  111017  JuMalk   Bug 99054, Modified Receive_Order_Change. Removed the condition of checking the Addr_Flag when appending the EAN address to the attr string.
--  111017           Modified method Update_Ordchg_On_Create_Order. Added condition before appending EAN_LOCATION_DEL_ADDR to the attribute string.
--  110913  SudJlk   Bug 98653, Modified Create_Disadv_Line___ to reflect length change in demand_order_ref1 in customer_order_line_tab.
--  110926  ChJalk   Modified methods Send_Agreement and Send_Price_List to send the active gtin no.
--  110907  ErFelk   Bug 98705, Modified Create_Disadv_Struct_Info___ by introducing N06 to pass Qty on handling unit and Quantity in package in sales UoM.  
--  110224  NWeelk   Bug 95883, Modified method Create_Disadv_Line___ by introducing N03 to pass shipped_qty in sales UoM.
--  110520  SudJlk   Bug 95029, Modified method Create_Disadv_Line___ to fetch the correct dispatch qty for non inventory parts. 
--  110520  SaJjlk   Bug 94997, Modified methods Receive_Order, Receive_Order_Change and Receive_Receiving_Advice to correctly handle exceptions.
--  110429  MaMalk   Modified Send_Order_Confirmation to send input_qty and input_conv_factor in N13 and N14
--  110429           since N09 and N10 have been used in support to pass some other values.
--  110309  Kagalk   RAVEN-1074, Added tax_id_validated_date field
--  110126  RiLase   Added where statement to only send active part lines in Sent_Price_List().
--  101201  NaLrlk   Modified the method Receive_Order, Receive_Order_Change, Send_Order_Confirmation and Create_Disadv_Line___ to fetch the multiple uom fields value.
--  100929  NWeelk   Bug 93181, Modified method Send_Order_Confirmation to retrieve N08 from the Customer_Order_Line_API.
--  101112  RaKalk   Modified Send_Price_List function to check if user is allowed to access given price list.
--  101019  ShKolk   Called function Part_Catalog_API.Get_Gtin_No instead of Sales_Part_API.Get_Gtin_No.
--  100520  KRPELK   Merge Rose Method Documentation.
--  100928  NWeelk   Bug 93056, Modified method Send_Direct_Delivery by dividing the quantity shipped from the line conversion factor when fetching the transit_row_qty_shipped_. 
--  100922  NWeelk   Bug 93181, Modified Send_Order_Confirmation by adding discount information to be passed through the ORDRSP 
--  100922           message and changed the calculation of N08 to use sale_unit_price.
--  100506  JuMalk   Bug 90398, Modified Receive_Order and Receive_Order_Change to set values of DISTRICT_CODE and REGION_CODE fields 
--  100506           regardless of the supply code type.
--  100430  ErFelk   Bug 89205, Modified Create_Disadv_Line___ to transfer PO Line information in C12 and C13.
--  100422  NWeelk   Bug 89754, Modified Procedures Receive_Order and Receive_Order_Change by setting variable lengths correctly,
--  100422           to prevent rejecting ORDERS and ORDCHG messages in the InBox.
--  100331  JuMalk   Bug 88848, Modified Create_Disadv_Address_Info___ to retrieve address details correctly.
--  091202  JENASE   Changed a method call from Party_Invoice_Info_API.Get_Vat_No to Identity_Invoice_Info_API.Get_Vat_No
--  091202           in methods Send_Order_Confirmation and Send_Direct_Delivery to be able to remove an old interface.
--  091123  ChFolk   Re-structure the message methods in order to arrange the message attributes in serial order.
--  091026  MaJalk   Set D02 to expiration_date_ at Create_Disadv_Line___.
--  091023  ChFolk   Removed sending receiver_address_, message_class_ and media_code_ in Send_Order_Confirmation as the information already included in soap header.
--  090930  MaMalk   Removed constant inst_PurchaseOrderLine_. Modified Create_Disadv_Struct_Info___, Create_Disadv_Address_Info___ and Create_Disadv_Line___ to remove unused code.
--  ------------------------- 14.0.0 -----------------------------------------
--  100309  NaLrlk   Modified the method Create_Disadv_Struct_Info___ to correct the column name for SSCC in 'PACKAGE UNIT' and 'HANDLING UNIT'.
--  091016  SudJlk   Bug 86027, Modified method Receive_Order_Change to handle ROUTE_ID and DELIVERY_LEADTIME correctly when internal_delivery_type is 3 or 4 at line level.
--  090910  HiWilk   Bug 85107, Modified Send_Direct_Delivery method to handle cross referenced parts.
--  090807  MaMalk   Bug 84186. Changed Create_Disadv_Struct_Info___ to include WAIV_DEV_REJ_NO when sending the DESADV message for a shipment structure.
--  090804  NWeelk   Bug 84811, Modified the cursor get_transit_row_info in Send_Direct_Delivery to get the correct records to TRANSITROW in the DIRDEL message.
--  090630  AndDse   Bug 79374, Modified functions Receive_Order and Receive_Order_Change in order to make the receiving of delivery leadtime work.
--  090817  MaJalk   Bug 83121, Assigned C10 to gtin no at Receive_Receiving_Advice().
--  090812  IrRalk   Bug 82835, Modified Create_Disadv_Struct_Info___ to rounded weight to 4 decimals.
--  090527  SuJalk   Bug 83173, Modified the error constant to AGR_NOT_PART_BASED to make the error constant unique in method Send_Agreement.
--  090527           Formatted error message in method Send_Price_List from 'Price list :P1 is not part based!' to 'Price list :P1 is not part based.'.      
--  090522  ChJalk   Bug 82640, Modified Send_Order_Confirmation and Send_Direct_Delivery to get the customer order's delivery address, bill address and
--  090522           payer address instead of the customer's default address for getting EAN location. 
--  090429  SuJalk   Bug 82445, Modified the datatype of consignment_note_id_ to VARCHAR2 instead of NUMBER in method Create_Disadv_Header_Info___.
--  090424  HImRlk   Bug 80277, Modified label_note of Send_Order_Confirmation() to use internal_po_label_note if it has a value.
--  090330  HimRlk   Bug 80277, Modified methods Receive_Order and Receive_Order_Change. Added field C85 for internal_po_label_note.
--  090330           Added Internal PO Label Note to Add_Org_Header_Values___.
--  090216  HimRlk   Bug 80197, Modified Create_Disadv_Address_Info___() to get the supplier id from Get_Supplier_Id___().
--  090109  SaRilk   Bug 79337, Modified the methods Create_Disadv_Address_Info___, Send_Agreement, Send_Direct_Delivery and Send_Order_Confirmation by using the  
--  090109           language code to fetch the delivery_terms_desc_ and ship_via_desc_ and by passing the data base value of handling unit type instead of the  
--  090109           client value in the method Create_Disadv_Struct_Info___.
--  081219  SaRilk   Bug 79266, Modified the methods Receive_Order and Receive_Order_Change by replacing the value C32 with C36.
--  081021  SaJjlk   Bug 77686, Modified the first parameter name in method Update_Ordchg_On_Create_Order and modified cursor find_change_requests in the same method.
--  081003  SudJlk   Bug 75542, Modified Create_Disadv_Line___ to convert shipped quantity to inventory UoM of the ordering site.
--  080918  HoInlk   Bug 67780, Modified methods Receive_Order and Receive_Order_Change. Changed value passed in
--  080918           field C14 to internal_ref. Added field C61 for cust_ref. Removed logic that transfers
--  080918           Internal PO No to Customer PO No. Added Internal Ref No and Customer PO No to Add_Org_Header_Values___.
--  080827  SuJalk   Bug 71706, Changed the Create_Disadv_Line___ method to send the Connected PO number of the DO instead of the DO number if the 
--  080827           demand code is Distribution Order.
--  080623  SaJjlk   Bug 72602, Added parameter expiration_date to the method Create_Disadv_Line___ and modified methods Create_Disadv_Line___
--  080623           and Create_Disadv_Struct_Info___ to consider expiration_date.
--  090320  AmPalk   Removed C01 assignment of LINE message of Send_Price_List. Sending our sales part GTIN no to Supplier's EAN no (in PURCH side) is an error and blocks the PRICAT message.
--  090507  KiSalk   Added SSCC as 'C18' in 'PACKAGE UNIT' and 'HANDLING UNIT' in Create_Disadv_Struct_Info___ (for DESADV).
--  090302  KiSalk   Modified for new parameters of Handling_Utility_API.Get_Net_Summary.
--  080925  KiSalk   values from agreement_sales_part_deal_tab min_quantity added for 'N02' and valid_from_date set for D00 in line part of Send_Agreement. 
--  080701  MaJalk   Merged APP75 SP2.
--  --------------------- APP75 SP2 Merge - End --------------------------------
--  080508  ThAylk   Bug 73703, Increased the length of variable addr_id_ to 50 in methods Send_Order_Confirmation and Send_Direct_Delivery.
--  080402  HaPulk   Bug 68143, Replaced Fnd_Session_API.Set_Property('FND_USER') with Impersonate_Fnd_User/Reset_Fnd_User in 
--  080402           Receive_Order, Receive_Order_Change, Receive_Receiving_Advice and Receive_Self_Billing_Invoice.
--  --------------------- APP75 SP2 Merge - Start ------------------------------
--  080613  MaJalk   Modified Send_Agreement to add classification unit meas and classification part no to message attr_.
--  080529  AmPalk   Removed code related to ean_no gave compilation errors.
--  080513  MaJalk   Changed the usage of contract to base_price_site at method Send_Agreement.
--  080509  MaJalk   Added gtin_no to parameter attr at methods Send_Agreement and Send_Price_List.
--  080506  KiSalk   Added parameter gtin_no to Receive_Receiving_Advice.
--  080502  MaJalk   Added parameter gtin_no to parameter attr at methods Create_Disadv_Line___, Receive_Order, Receive_Order_Change and Send_Order_Confirmation.
--  080313  MaJalk   Merged APP 75 SP1.
--  --------------------------- APP 75 SP1 merge - End -----------------------
--  080130  NaLrlk   Bug 70005, Added DEL_TERMS_LOCATION to ORDERS/ORDCHG/DESADV messages in methods Create_Disadv_Address_Info___, Receive_Order, Receive_Order_Change.
--  071211  LaBolk   Bug 67937, Modified method Receive_Order to generate the CO number if specified to do so in Company.
--  071203  PrPrlk   Bug 68771, Modified the methods Send_Order_Confirmation,Send_Dispatch_Advice,Send_Direct_Delivery and Send_Agreement to handle the msg_sequence_no and msg_version_no 
--  071203           Modified the methods Create_Disadv_Address_Info___, Send_Order_Confirmation and Send_Direct_Delivery to handle the customer cross refference values.
--  071126  SaJjlk   Bug 68881, Added method Get_Supplier_Id___ and modified methods Send_Agreement and Send_Price_List  
--  071126           to use this method to retrieve the supplier.
--  071107  PrPrlk   Bug 68566  Modified the methods Send_Order_Confirmation and Send_Direct_Delivery to fetch the address related fields correctly.
--  071015  RaKalk   Bug 67729, Modified the method Create_Disadv_Address_Info___ to correctly fetch the values for gross total, net total and total volume.
--  --------------------------- APP 75 SP1 merge - Start ---------------------
--  080227  MaJalk   Changed contract fetching method at Send_Agreement().
--  --------------------------- Nice Price Start -----------------------------
--  070619  ChBalk   Added catch_qty_delivered to the messages ROW and TRANSITROW when Send_Direct_Delivery.
--  070530  WaJalk   Bug 65216, Modified method Create_Disadv_Struct_Info___ and Create_Disadv_Line___
--  070530           to create lines for non-inventory parts.
--  070512  NiDalk   Modified Send_Agreement to remove Agreement_Type.
--  070502  ChBalk   Modified Create_Disadv_Line___, changed the value for the C04 when Internal PO line exists.
--  070502           Otherwise use the Customer Po No.
--  070405  NiDalk   Bug 64205, Modified Receive_Order() to add N10 for internal_delivery_type_ 1.
--  070328  SuSalk   LCS Merge 63028, Added condition in cursor get_transit_row_info in method Send_Direct_Delivery to
--  070328           filter from order_no_. Modified method Send_Direct_Delivery to add order_no_ as an IN parameter.
--  070328           Added variable delnote_state_ and used it instead of method calls.
--  070323  MalLlk   Bug 60882, Changed method Add_Org_Header_Values___ to get ORG_VAT_NO from customer_order_tab.
--  070226  DaZase   Added qty conversion of qty_shipped for transitrow in method Send_Direct_Delivery.
--  070221  WaJalk   Bug 61985, Increased length of variable customer_po_no_ from 15 to 50 in methods Send_Order_Confirmation and Send_Direct_Delivery.
--  070219  NuVelk   Bug 62453, Modified the procedure Create_Disadv_Line___ and Send_Dispatch_Advice and
--  070219           added a new overloaded procedure Create_Disadv_Line___.
--  070208  RaNhlk   Modified method Create_Disadv_Address_Info___ to get the correct values for net_weight,handling_unit_weight and volume.
--  070201  RaNhlk   Modified method Create_Disadv_Struct_Info__().
--  070118  KaDilk   Removed Language Code from ship_via_desc and delivery_terms_desc to clean the LU
--  070118           specific descriptions.
--  061222  SuSalk   LCS Merge 61831, Added method Update_Ordchg_On_Create_Order.
--  061125  Cpeilk   Added header vat_no as C54 in methods Receive_Order and Receive_Order_Change.
--  061117  NaLrlk   Changed the ALLOW_BACKORDERS to BACKORDER_OPTION in all places.
--  061019  NiDalk   Bug 60759, Added the Note in the header of the file,with a reminder about updating Messages.xls.
--  060725  ChJalk   Modified call Mpccom_Ship_Via_Desc_API.Get_Description to Mpccom_Ship_Via_API.Get_Description
--  060725           and Order_Delivery_Term_Desc_API.Get_Description to Order_Delivery_Term_API.Get_Description
--  060531  JoEd     Bug 58344. Changed Create_Disadv_Struct_Info___ and Create_Disadv_Line___
--                   to include lot batch no, serial no, eng chg level and pallet/package in the
--                   LINE segment of the DESADV message.
--  060518  JoEd     Bug 57604. Changed Receive_Order and Receive_Order_Change methods
--                   to receive "Allow Backorders" value in field C50 instead of C61.
--  060515  RoJalk   Enlarge Address - Changed variable definitions.
--  060509  SaRalk   Enlarge Forwarder - Changed variable definitions.
--  060419  SaRalk   Enlarge Customer - Changed variable definitions.
--  --------------------------------- 13.4.0 --------------------------------
--  060225  RaKalk   Modified the order by clause of the cursor get_entire_shipment_structure of
--  060225           Create_Desadv_Struct_Info___ procedure to correct the order of the pkage/handling units in the message
--  060211  NuFilk   Modified method Create_Disadv_Address_Info___ to consider shipment and order delivery address.
--  060109  IsWilk   Removed the approval_date from PROCEDURE Receive_Self_Billing_Invoice.
--  051207  MaMalk   Bug 54865, Modified Send_Price_List and Send_Agreement to fetch the ean location from the document address.
--  051026  Cpeilk   Bug 53510, Modified methods Receive_Order and Receive_Order_Change to get customer no from ean location.
--  051012  KeFelk   Added Site_Discom_Info_API in some places for Site_API.
--  051003  JaBalk   Sent the actual_ship_date from shipment if shipment id is not null in Create_Disadv_Header_Info___.
--  050926  SaMelk   Removed unused variables.
--  050908  UsRalk   Modified Send_Direct_Delivery to use the correct acquisition_site when locating the expiration date.
--  050907  RaKalk   Modified Receive_Self_Billing_invoice to set the session user to sbi auto approval user when automatic match
--  050906  KeFelk   Added call to Fnd_Session_API.Set_Property in Receive_Receiving_Advice.
--  050829  UsRalk   Changed expiration_date fetching logic in procedure Send_Direct_Delivery.
--  050826  UsRalk   Added support for expiration_date in procedure Send_Direct_Delivery.
--  050826  KeFelk   Added logic to Receive_Receiving_Advice to Check whether the automatic matching is enable for the customer.
--  050817  JaBalk   Removed Start_Automatic_Sbi_Process___ deffered call from Receive_Self_Billing_Invoice since the
--  050817           connectivity is an background job.
--  050430  UdGnlk   Bug 50103, Modified Receive_Order to set values for IPD Tax info.
--  050810  KeFelk   Used C62 for IN_CITY instead of C56.
--  050802  ToBeSe   Bug 52427, Increased size of attr_ in Send_Direct_Delivery and Send_Order_Confirmation.
--  050727  NaLrlk   B126015: Modified the assigned values in qty_confirmrd_arrived/approved in Receive_Receiving_Advice.
--  050725  RaKalk   Modified Receive_Self_Billing_Invoice save the connectivity error message in to incoming sbi header and line.
--  050720  IsAnlk   Changed pur_catalog_no as customer_part_no and pur_catalog_desc as customer_part_desc in Receive_Self_Billing_Invoice.
--  050718  ZiMolk   Restructured method Send_Dispatch_Advice to send the strcutures(LINE,HANDLING_UNIT,PACKAGE_UNIT segments) in order.
--  050715  IsAnlk   Modified total_amount as tot_inv_net_amount and vat_amount as tax_amount in Receive_self_billing_invoice.
--  040714  IsAnlk   Modified Start_Automatic_Sbi_Process___ to call public method Automatic_Sbi_Process and modified Receive_Self_Billing_Invoice.
--  050711  RaKalk   Modified the method Receive_Self_Billing_Invoice to change columns of SBI header.
--  050711           Of fields pay_term_desc, company_name and supplier_reference.
--  050707  RaKalk   Modified the column order in Receive_Self_Billing_Invoice to match the send column order.
--  050705  RaKalk   Modified Receive_Self_Billing_Invoice method to use record based new methods
--  050705           in Ext_Inc_Sbi_Head_API and Ext_Inc_Sbi_Item_API. reordered the columns in messages.
--  050705  RaKalk   Added Company_Name and Payment_terms_desc to SBI header, Added Invoice_No and Additional_cost to SBI line.
--  050704  JaBalk   Added SENDER_MESSAGE_ID to Receive_Self_Billing_Invoice.
--  050701  JaBalk   Added Start_Automatic_Sbi_Process___ and call it inside the Receive_Self_Billing_Invoice.
--  050701  UsRalk   Modified Receive_Self_Billing_Invoice to store DELIVERYNOTE on EXT_INC_SBI_DELIVERY_INFO_TAB.
--  050629  RaKalk   Modified Receive_Self_Billing_Invoice method to Is_Automatic_Match__ in ORDER_SELF_BILLING_MANAGER_API.
--  050628  KeFelk   Added procedure Receive_Receiving_Advice.
--  050628  RaKalk   Renamed method Receive_Sbi_Msg to Receive_Self_Billing_Invoice and modified it to use message records.
--  050628  MiKulk   Bug 51770, Removed the conditions for creating the history records for the customer order header.
--  050627  RaKalk   Moved method Receive_Sbi_Msg from Ext_Inc_Sbi_Util_API.
--  050613  KiSalk   Bug 50953, Added C56, IN_CITY address parameter to Receive_Order.
--  050509  KiSalk   Bug 50697, Modified Receive_Order_Change to conditionally add attribute EAN_LOCATION_DEL_ADDR
--  050509           and added some missing attributes and conditions in Add_Org_Header_Values___.
--  050415  ChJalk   Bug 50263, Modified PROCEDURE Receive_Order and PROCEDURE Receive_Order_Change to receive Allow_Backorders.
--  050411  HoInlk   Bug 50260, Modified Receive_Order to set delivery leadtime when internal_delivery_type_ is 2.
--  050301  NiRulk   Bug 48631, Added new function Get_Customer_Country_Code() to retrieve the alternative country code that can be used
--                   to set the address layout when the country code is not available in the client.
--  050228  RaKalk   Modified Create_Disadv_Struct_Info___ to corrected the check to send shipment lines
--  050221  SaJjlk   Modified code in Create_Disadv_Struct_Info___ and Create_Disadv_Header_Info___
--  050221           Changed method name Create_Line___ to Create_Disadv_line___.
--  050217  IsAnlk   Modified SHIPMENT_CONNECTED as VARCHAR2 and changed the code accordingly.
--  050217  SaJjlk   Added methods Create_Line___, Create_Simplified_Structure___ and Create_Simplified_Structure___.
--  050216  SaJjlk   Modified code in method Send_Dispatch_Advice.
--  050203  SaJjlk   Added methods Create_Disadv_Header___, Create_Disadv_Address_Info___ and Create_Disadv_Struct_Info___.
--  050118  UsRalk   Renamed CustomerNo attribute on Shipment LU to DeliverToCustomerNo.
--  050110  VeMolk   Bug 44226, Modified the document address retrieval logic in Send_Direct_Delivery and Send_Order_Confirmation.
--  041213  AmPalk   Bug 47749, Modified Procedure Send_Order_Confirmation to change the status to 'Changed' if the price is changed at the CO,
--  041213           and in instances the price is sent in ORDERS and ORDCHG messages.
--  041220  ChJalk   Bug 47792, Modifeid Send_Order_Confirmation to consider Additional Discount in calculting the value of N08.
--  041026  UdGnlk   Bug 45802, Modified  Receive_Order(), Receive_Order_Change() to add original_buy_qty_due and original_plan_deliv_date.
--  041026           Modified Send_Order_Confirmation() logic inorder to fetch the status of ORDRSP for supplier response.
--  041018  MaJalk   Bug 44958, In procedure Receive_Order() and procedure Receive_Order_Change(), set value for FORWARD_AGENT_ID.
--  040827  LoPrlk   Methods Receive_Order and Receive_Order_Change were altered to pass DELIVERY_LEADTIME, ROUTE_ID, DISTRICT_CODE,
--  040827           REGION_CODE and INTRASTAT_EXEMPT_DB for not single occurence addresses also.
--  040811  LoPrlk   Methods Add_Org_Line_Values___, Receive_Order and Receive_Order_Change were altered to refer
--  040811           delever to customer instead of cuatomer in some places.
--  040811  LoPrlk   Duplicated variable ean_loc_ was removed from Receive_Order and Receive_Order_Change.
--  040809  NuFilk   Modified Send_Direct_Delivery corrected the cursor get_transit_row_info.
--  040803  NuFilk   Modified Send_Direct_Delivery included message for TRANSITROW.
--  040428  HeWelk   Bug 43658,Modified Send_Price_List() - Added customer_no to the where clause of the cursor get_xref_info.
--  040727  IsWilk   Modified the PROCEDURE to add the ean_location_del_addr, deliver_to_customer_no,
--  040727           contact and INTRASTAT_EXEMPT_DB to the PROCEDURE Receive_Order_Change.
--  040722  IsWilk   Modified the PROCEDURE Receive_Order to add the INTRASTAT_EXEMPT_DB.
--  040722  WaJalk   Modified the method Receive_Order to add contact.
--  040720  LoPrlk   Modified the method Receive_Order.
--  040708  WaJalk   Modified methods Receive_Order and Receive_Order_Change to add 'CLASS_ID'.
--  040623  LoPrlk   Added the fields EAN_LOCATION_DEL_ADDR and DELIVER_TO_CUSTOMER_NO to Receive_Order.
--  040616  KeFelk   Added Exception clause to Receive_Direct_Delivery and Receive_Order_Response methods.
--  040526  MiKalk   Bug 43398, Modified the correction done in Receive_Order and Receive_Order_Change to remove the check for internal_delivery_type_.
--  040524  MiKalk   Bug 43398, Modified the correction done in Receive_Order and Receive_Order_Change to get the correct address_no.
--  040517  MiKalk   Bug 43398, Modified the methods Receive_Order and Receive_Order_Change.
--  040513  NaWilk   Bug 44113, Modified the methods Receive_Order and Receive_Order_Change.
--  040324  JoEd     Added Message ID parameter to all message lines in Send_Dispatch_Advice.
--  040303  JoEd     Changed Send_Dispatch_Advice method to include small, medium and advanced
--                   versions of the DESADV message.
--  040227 WaJalk    Bug 40664, Modified method Receive_Order_Change to get route_id and delivery_leadtime.
--  040210 Samnlk    Bug 39270, Added a new attribute to the message line in PROCEDURE Receive_Order.
--  040202  JoEd     Changed structure of Send_Dispatch_Advice message segments.
--                   Moved numeric values into numeric Connectivity columns.
--                   Added delivery terms description and ship via description columns (C71, C73).
--  021106  PrInLk   Send_Dispatch_Advice. Modified C11 column in simplified handling units.
--  020607  MaGu     Modified method Send_Dispatch_Advice. Removed call to
--                   Shipment_API.Get_No_Of_Pallets and Shipment_API.Get_No_Of_Packages and added call to
--                   Shipment_Handling_Utility_API.Get_No_Of_Pallets and Shipment_Handling_Utility_API.Get_No_Of_Packages.
--  020606  MaGu     Modified method Send_Dispatch_Advice. Removed call to
--                   Handling_Unit_Package_API.Get_Package_Net_Weight and added call to
--                   Shipment_Handling_Utility_API.Get_Package_Net_Weight.
--  020605  MaGu     Modified method Send_Dispatch_Advice. Removed call to Handling_Unit_Part_API.Get_Pallet_Lot_Batch
--                   and Handling_Unit_Part_API.Get_Pallet_Ec. Added call to Handling_Unit_Part_API.Get_Lot_Batch_No
--                   and Handling_Unit_Part_API.Get_Eng_Chg_Level. Added fetch of client value for handling_unit_type,
--                   added ROWTYPE in where statement for cursor get_simplified_pallets.
--  020603  DaMase   Cleanup in Send_Dispatch_Advice after codereview and install tests.
--  020424  PrInLk   Rewrote the Send_Dispatch_Advice functionality to be compatible
--                   with the package structure created on Shipment.
--  ********************* VSHSB Merge *****************************
--  031105 Asawlk    Modified Receive_Order_Change and Receive_Order.
--  031029 SeKalk    Modified procedure Find_Order_No_For_Ext_Cust___ ,Receive_Order, and Receive_Order_Change
--  031028 SeKalk    Modified procedure Receive_Order_Change
--  031023 BhRalk    Modified the method Send_Price_List to validate Site.
--  031021 PrJalk    Merged Bug 39375, Changed Send_Direct_Delivery.
--  031021 SeKalk    Inter site flow change
--  031020 Erlise    SHIP_COUNTY, C49, occured twice in ROW-loop in procedures Receive_Order and Receive_Order_Change.
--  031016 BhRalk    Modified the methods Send_Price_List and Send_Agreement to send Ean_Loc_No
--                   present in the Site Delivery Address.
--  031016 SeKalk    Modified procedure Receive_Order_Change
--  031015 OsAllk    Merged Bug 39185, Small modification in method Send_Direct_Delivery.
--  031013 BhRalk    Added default parameter price_list_site_ to method Send_Price_List.
--  031008 NuFilk    Modified the Recieve_Order and Receive_Order_Change, Changed C36 to C32.
--  030912 BhRalk    Modified the Method Receive_Order_Change to use C30 instead C54 to pass Forwader.
--  030911 MiKulk    Bug 37995, Modified the VARCHAR declaration in the coding as VARCHAR2.
--  030910 BhRalk    Modified the method Receive_Order.
--  030905 MaGulk    Modified Receive_Order_Change to include Condition_Code in Order Change Request Line Row to ORDCHG message
--  030904 MaGulk    Modified Receive_Order to include Condition_Code in Order Line Row to ORDERS message
--  030901 ChBalk    CR Merged 02.
--  030822 MaGulk    Merged CR
--  030730 ThGuLk    Modified function Receive_Order, Receive_Order_change, added checking for forwarder_id .
--  030717 NaWalk    Removed Bug coments.
--  030710 WaJalk    Applied bugs 35640, 34820, 35721.
--  030528 ChBalk    Fixed known bug, Added Delevery_leadtime when internal_delivery_type_ is '4' in when Receive_Order.
--  030513 ThGuLk    Modified function Receive_Order_change, added checking for forwarder_id .
--  030401 ThGuLk    Modified function Receive_Order_change, Receive_Order. added new fields to fetch line(row) message.
--  ****************************** CR Merge ************************************
--  030730  ChIwlk   Performed SP4 Merge.
--  030526  SaAblk   Removed Add_Org_Option_Values___
--  030520  SaAblk   Removed references to EXT_CUST_ORD_OPTION_CHANGE
--  030520  SaAblk   Removed references to EXTERNAL_CUST_ORDER_OPTION
--  030219  AnJplk   Bug 35721, Changed procedure Send_Dispatch_Advice in order to facilitate DESADV in inter-site flow.
--  030218  NuFilk   Bug 34820, Modified procedures Add_Org_Header_Values___, Receive_Order, Receive_Order_Change
--  030218           to handle allow backorders for internal direct delivery of Intersite Ordering.
--  030207  MaMalk   Bug 35640, Changed the procedure Send_Order_Confirmation to change the planned_delivery_date,planned_receipt_date or quantity
--                   of internal purchase order lines according to the change of planned_delivery_date or quantity  of customer order lines in Intersite Ordering.
--  030123  UsRalk   Included alt_delnote_no when Sending Dispatch Advices
--  020920  MKrase   Bug 33007, Added condition 'line_item_no <= 0' for cursor get_line_info in Send_Order_Confirmation.
--  020917  AjShlk   Bug 32760, Changed the PROCEDURE Send_Direct_Delivery, set the delivered date correctly.
--  020902  NaWalk   Bug 29810, Made the Price and Catalog Description changes to be passed to the Customer Order
--  020902           when the 'sending_price_flag_' is ticked in the window "supplier for purchase part"
--  020828  ErFise   Bug 29508, added handling of route_id, forward_agent_id
--                   and delivery_leadtime in Receiver_Order
--  020819  ErFise   Bug 30257, added handling of delivery_leadtime on head when internal_delivery_type = 3.
--  020801  NaWalk   Bug 29810, Added the item values of the columns 'SALE_UNIT_PRICE' and 'CATALOG_DESC' to the newattr_ string.
--  020705  PioZpl   Bug 29015, change in Add_Org_Header_Values___ so now org values for ship_via_code
--                   and delivery_terms now only are handled when its internal_delivery_type = 3 or 4. Changes
--                   in Receive_Order and Receive_Order_Change so we now include delivery_terms and
--                   ship_via_code when internal_delivery_type = 4 also.
--  020607  WaJalk   Bug 29806, Modified the procedure Receive_Order to correct the method of handling sales_unit_price_.
--  020327  MAJE     Bug 28506, Commented out the CustomerOrderDelivNote.SetPrinted in SendDirectDelivery
--                   to avoid the Delivery Note Documents Printed check box on Customer Order
--                   form's Document Information tab from being checked when you only SendDirectDelivery.
--  020326  SaNalk   Call Id 75780, Changes were done in procedure Send_Order_Confirmation.Modified cursors get_line_info and get_external_info.
--                   Loop for deleted rows was modified and changed the position of the loop.
--  020325 SaKaLk    Call 77116(Foreign Call 28170). Added new column 'ship_county'.
--  011204  DaZa     Bug fix 24525, Added some code in Receive_Order, Receive_Order_Change and Add_Org_Header_Values___
--                   for receiving some additional data when its an internal direct delivery from PO.
--  011122  DaZa     Bug fix 26219, changed place of 2 if-statements in method Send_Order_Confirmation.
--  011016  RoAnse   Bug fix 21629, Modified cursor get_line_info in procedure Send_Order_Confirmation
--                   to not enable lines in status Cancelled being sent if the corresponding PO-line
--                   already is cancelled.
--  011015  PuIllk   Bug 25169, Increase the length of variable Customer_Po_No_ to VARCHAR2(15) in Procedure Send_Order_Confirmation.
--  010130  JoEd     Bug fix 19338. Changed assignment of currency code (C06) in Receive_Order.
--  000125  FBen     Bug Fix 19084, added valid_from_date in cursor get_line_info and modified msg 'D00'.
--  001201  JoAn     RefId, LocationNo, DockCode and SubDockCode moved to
--                   C14-C17 in DESADV message.
--  001129  JoAn     CID 55919 Dock and Sub Dock Code added to DESADV message.
--  001113  JakH     Hanlded ConfigurationId handled as a string.
--  001010  JoEd     Added nvl check on import_mode in Receive_Order and Receive_Order_Change
--                   so that it's always showing what kind of message has been sent.
--  000920  MaGu     Changed to new address format in Receive_Order, Receive_Order_Change,
--                   Add_Org_Header_Values___ and Add_Org_Line_Values___.
--  000913  FBen     Added UNDEFINE.
--  000901  JoEd     Added ref_id and location_no fields (C09-C10) to DESADV message.
--  000711  TFU      merging from Chameleon
--  000718  DEHA     Added the applying of the price and the description
--                   to the co-line in the ORDERS message.
--  000616  DEHA     Added handling for lines which contains characteristic data
--                   (line type - CHARROW) for ORDERS and ORDCHG message.
--  000719  DEHA     Merged from CTO.
--  ---------------------- 13.0 ---------------------------------------------
--  000619  JoEd     Changed column value for D00 on LINES in Send_Price_List.
--  000308  JoEd     Added handling of order lines added via ORDER CHANGE message
--                   when sending order confirmation.
--  000307  JoEd     Changed fetch of ean_location from Company_Address in Send_Price_List
--                   and Send_Agreement.
--  000225  JoEd     Added NOTFOUND check on fetch of sales part cross reference
--                   in Send_Price_List and Send_Agreement.
--  000225  JoEd     Changed Send_Dispatch_Advice. Fetch delivery note specific information
--                   from delivery note table instead of customer order table.
--  000218  JoEd     Removed value N02 from Send_Agreement. Only used for price intervals.
--  000217  JoEd     Changed value for C06 in price list/agreement header.
--                   Made value N01 0 if null (discount) in the same headers.
--  000216  JoEd     Changed attribute NAME's value from ROW to LINE in Send_Price_List
--                   and Send_Agreement.
--  000215  JoEd     Changed the get_line_info cursor in Send_Price_List.
--                   Changed PRICAT status (C01) and action code (C00) to uppercase
--                   (Used as IID's in Purchase).
--  000211  JoAn     Added C27 Our Id at customer in Send_Dispatch_Advise.
--                   Also corrected the order of parameters to Customer_Info_Our_Id_API.Get_Our_Id
--                   in Send_Order_Confirmation and Send_Direct_Delivery.
--  000210  JoEd     Added Connectivity call for price list/agreement header
--                   in Send_Price_List and Send_Agreement.
--  000117  JoEd     Changed C01 item value for PRICAT lines.
--  000110  JoEd     Added procedure Send_Agreement.
--  991229  JoEd     Added procedure Send_Price_List.
--  991215  JoEd     Added handling of delivery address info on lines.
--  991125  JoAn     Changed Send_Displatch_Advice: create_date stored in D01 instead
--                   of C01.
--  ---------------------- 12.0 ---------------------------------------------
--  991111  JoEd     Changed datatype length on company_ variables.
--  991008  JoEd     Replaced Utility_SYS.Set_User with Fnd_Session_API.Set_Property.
--  991007  JoEd     Replaced Utility_SYS.Get_User with Fnd_Session_API.Get_Fnd_User.
--  ---------------------- 11.1 ---------------------------------------------
--  990601  JICE     Cancellation of old external customer orders when creating
--                   new with same external ref.
--  990429  RaKu     CID 5689. Added in Send_Direct_Delivery so only lines with
--                   qty_shipped > 0 are included.
--  990420  JoAn     Removed calls to Get_Client_Value in Send_Order_Confirmation.
--  990415  JoEd     Replaced cursors get_ean_addresses with Get_Default_Address call.
--  990413  PaLj     Yoshimura - Performance changes
--  990326  RaKu     Changed so ORG-changes are shows when a line is NOT AMENDED also.
--  990217  RaKu     Corrected logic for fetching the correct order_no when processing
--                   the ORDCHG-message in Receive_Order_Change.
--  990209  JoAn     Using Customer_Info_Our_Id_API to retrieve Our_Id for a customer.
--  990202  JICE     Added language for order change.
--  990202  RaKu     Replaced COMPANY with function Site_API.Get_Company(contract)
--                   in several cursors.
--  990127  JICE     Added handling of options.
--  990119  RaKu     Changes made in Send_Dispatch_Advice.
--  990114  RaKu     Added procedure Send_Dispatch_Advice.
--  990114  RaKu     Renamed procedure Send_Dispatch_Advice to Send_Direct_Delivery.
--  990114  RaKu     Changed EDI-message from DESADV to DIRDEL.
--  981217  JICE     Added handling of Configurations.
--  981209  JoEd     Changed fetch of vat_no.
--  981203  RaKu     Replaced Get_Printed_Flag and Set_Printed_Flag with Get_Objstate
--                   and Set_Printed in call to Customer_Order_Deliv_Note.
--  981203  JoEd     Changed calls to Company and Customer in Enterprise.
--  981104  RaKu     Removed price_list_no where used.
--  980406  JoAn     SID 3085, 3086 Added handling for attribute internal_delivery_type.
--  980401  JoAn     SID 1955 Passing DB state instead of clients state in Send_Dispatch_Advice
--  980330  JoAn     SID 2859 Changed Send_Dispatch_Advice so that lines with supply code
--                   Purchase order direct are included.
--  980325  RaKu     Changed so the sended contract in fetched from the internal customer
--                   in Send_Dispatch_Advice.
--  980324  RaKu     Wanted_delivery_date was incorrect checked in Send_Order_Confirmation.
--                   Changed so the sended contract in fetched from the internal customer.
--  980320  RaKu     Replaced cursor to CUSTOMER_AGREEMENT with function-call.
--  980316  RaKu     Added logic to change user when trying to approve orders automatic.
--  980312  RaKu     Added check for internal_customer_site to handle the automatic
--                   approval correct.
--  980306  RaKu     Added Internal_Customer_Site in method Receive_Order.
--  980305  RaKu     Changed status-text in procedure Send_Order_Confirmation.
--  980302  JoEd     Added methods Send_Order_Confirmation, Send_Dispatch_Advice
--                   and Allowed_To_Send.
--  980217  RaKu     Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Find_Order_No_For_Ext_Cust___
--   Return our order no for the specified specified customer and customer po no.
FUNCTION Find_Order_No_For_Ext_Cust___ (
   customer_no_    IN VARCHAR2,
   customer_po_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   order_no_ VARCHAR2(12) := NULL;

   CURSOR get_order_no IS
      SELECT order_no
      FROM   customer_order_tab
      WHERE  customer_no = customer_no_
      AND    customer_po_no = customer_po_no_
      ORDER BY DECODE(rowstate,'Cancelled', 2, 1);

   CURSOR get_order_cust_null IS
      SELECT order_no
      FROM   customer_order_tab
      WHERE  customer_po_no = customer_po_no_
      ORDER BY DECODE(rowstate,'Cancelled', 2, 1);
BEGIN
   IF (customer_no_ IS NULL) THEN
      OPEN  get_order_cust_null;
      FETCH get_order_cust_null INTO order_no_;
      CLOSE get_order_cust_null;
   ELSE
      OPEN  get_order_no;
      FETCH get_order_no INTO order_no_;
      CLOSE get_order_no;
   END IF;
   RETURN order_no_;
END Find_Order_No_For_Ext_Cust___;


-- Find_Order_No_For_Int_Cust___
--   Return our order no for the specified specified customer and internal po no.
FUNCTION Find_Order_No_For_Int_Cust___ (
   customer_no_    IN VARCHAR2,
   internal_po_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   order_no_ VARCHAR2(12) := NULL;

   CURSOR get_order_no IS
      SELECT order_no
      FROM   customer_order_tab
      WHERE  customer_no = customer_no_
      AND    internal_po_no = internal_po_no_
      ORDER BY DECODE(rowstate,'Cancelled', 2, 1);
BEGIN
   OPEN  get_order_no;
   FETCH get_order_no INTO order_no_;
   CLOSE get_order_no;
   RETURN order_no_;
END Find_Order_No_For_Int_Cust___;


-- Add_Org_Header_Values___
--   Adds the orginal order header values to the attribute string to store
--   the old information and be able to compare it with the new one.
PROCEDURE Add_Org_Header_Values___ (
   attr_           IN OUT VARCHAR2,
   order_no_       IN     VARCHAR2,
   int_deliv_type_ IN     VARCHAR2,
   b2b_process_online_ IN BOOLEAN DEFAULT FALSE)
IS
   orgrec_          customer_order_tab%ROWTYPE;
   orgaddrrec_      customer_order_address_tab%ROWTYPE;
   CURSOR get_org_header IS
      SELECT *
      FROM   customer_order_tab
      WHERE  order_no = order_no_;
   CURSOR get_org_address IS
      SELECT *
      FROM   customer_order_address_tab
      WHERE  order_no = order_no_;
BEGIN
   OPEN  get_org_header;
   FETCH get_org_header INTO orgrec_;
   CLOSE get_org_header;
   -- Orginal Header
   
   Client_SYS.Add_To_Attr('ORG_CUST_REF', orgrec_.cust_ref, attr_);
   Client_SYS.Add_To_Attr('ORG_CUSTOMER_PO_NO', orgrec_.customer_po_no, attr_);
   Client_SYS.Add_To_Attr('ORG_LABEL_NOTE', orgrec_.label_note, attr_);
   
   --If B2B Process: Exclude some org value, but add bill and ship addr no
   IF NOT b2b_process_online_ THEN
      Client_SYS.Add_To_Attr('ORG_EAN_LOCATION_DOC_ADDR',
         Cust_Ord_Customer_Address_API.Get_Ean_Location(orgrec_.customer_no, orgrec_.bill_addr_no), attr_);
      Client_SYS.Add_To_Attr('ORG_FORWARD_AGENT_ID', orgrec_.forward_agent_id, attr_);
      Client_SYS.Add_To_Attr('ORG_CUSTOMER_NO_PAY', orgrec_.customer_no_pay, attr_);
      Client_SYS.Add_To_Attr('ORG_NOTE_TEXT', orgrec_.note_text, attr_);
      Client_SYS.Add_To_Attr('ORG_VAT_NO', orgrec_.tax_id_no, attr_);
      Client_SYS.Add_To_Attr('ORG_INTERNAL_REF', orgrec_.internal_ref, attr_);
      Client_SYS.Add_To_Attr('ORG_INTERNAL_PO_LABEL_NOTE', orgrec_.internal_po_label_note, attr_);
      Client_SYS.Add_To_Attr('ORG_PAY_TERM_ID', orgrec_.pay_term_id, attr_);
      Client_SYS.Add_To_Attr('ORG_SALESMAN_CODE', orgrec_.salesman_code, attr_);
      Client_SYS.Add_To_Attr('ORG_EAN_LOCATION_PAYER_ADDR',
         Cust_Ord_Customer_Address_API.Get_Ean_Location(orgrec_.customer_no_pay, orgrec_.customer_no_pay_addr_no), attr_);
   ELSE
      Client_SYS.Add_To_Attr('ORG_BILL_ADDR_NO', orgrec_.bill_addr_no, attr_);
      IF (orgrec_.addr_flag = 'N') THEN
         Client_SYS.Add_To_Attr('ORG_SHIP_ADDR_NO', orgrec_.ship_addr_no, attr_);    
      END IF;
   END IF;

   IF (orgrec_.addr_flag = 'N') THEN
      IF NOT b2b_process_online_ THEN
         Client_SYS.Add_To_Attr('ORG_EAN_LOCATION_DEL_ADDR',
            Cust_Ord_Customer_Address_API.Get_Ean_Location(orgrec_.customer_no, orgrec_.ship_addr_no), attr_);
      END IF;
   ELSE
      OPEN  get_org_address;
      FETCH get_org_address INTO orgaddrrec_;
      CLOSE get_org_address;
      -- Orginal Address (on Header)
      Client_SYS.Add_To_Attr('ORG_DELIVERY_ADDRESS_NAME', orgaddrrec_.addr_1, attr_);
      Client_SYS.Add_To_Attr('ORG_SHIP_ADDRESS1', orgaddrrec_.address1, attr_);
      Client_SYS.Add_To_Attr('ORG_SHIP_ADDRESS2', orgaddrrec_.address2, attr_);
      Client_SYS.Add_To_Attr('ORG_SHIP_ADDRESS3', orgaddrrec_.address3, attr_);
      Client_SYS.Add_To_Attr('ORG_SHIP_ADDRESS4', orgaddrrec_.address4, attr_);
      Client_SYS.Add_To_Attr('ORG_SHIP_ADDRESS5', orgaddrrec_.address5, attr_);
      Client_SYS.Add_To_Attr('ORG_SHIP_ADDRESS6', orgaddrrec_.address6, attr_);
      Client_SYS.Add_To_Attr('ORG_SHIP_ZIP_CODE', orgaddrrec_.zip_code, attr_);
      Client_SYS.Add_To_Attr('ORG_SHIP_CITY', orgaddrrec_.city, attr_);
      Client_SYS.Add_To_Attr('ORG_SHIP_STATE', orgaddrrec_.state, attr_);
      Client_SYS.Add_To_Attr('ORG_SHIP_COUNTY', orgaddrrec_.county, attr_);
      Client_SYS.Add_To_Attr('ORG_COUNTRY_CODE', orgaddrrec_.country_code, attr_);
   END IF;

   Client_SYS.Add_To_Attr('ORG_DELIVERY_DATE', orgrec_.wanted_delivery_date, attr_);
   -- add these values if its an internal delivery from Purch
   IF (int_deliv_type_ = '4') THEN
      Client_SYS.Add_To_Attr('ORG_DELIVERY_TERMS', orgrec_.delivery_terms, attr_);
      Client_SYS.Add_To_Attr('ORG_SHIP_VIA_CODE', orgrec_.ship_via_code, attr_);
      Client_SYS.Add_To_Attr('ORG_DELIVERY_TERMS_DESC', Order_Delivery_Term_API.Get_Description(orgrec_.delivery_terms), attr_);
      Client_SYS.Add_To_Attr('ORG_SHIP_VIA_DESC', Mpccom_Ship_Via_API.Get_Description(orgrec_.ship_via_code), attr_);
      IF (Client_SYS.Get_Item_Value('BACKORDER_OPTION_DB', attr_) IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('ORG_BACKORDER_OPTION_DB', orgrec_.backorder_option, attr_);
      END IF;
      IF (Client_SYS.Get_Item_Value('PRINT_DELIVERED_LINES_DB', attr_) IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('ORG_PRINT_DELIVERED_LINES_DB', orgrec_.print_delivered_lines, attr_);
      END IF;
      IF (Client_SYS.Get_Item_Value('DELIVERY_LEADTIME', attr_) IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('ORG_DELIVERY_LEADTIME', orgrec_.delivery_leadtime, attr_);
      END IF;
      Client_SYS.Add_To_Attr('ORG_ROUTE_ID', orgrec_.route_id, attr_);
   END IF;
   -- add these values if its an internal direct delivery from Purch
   
END Add_Org_Header_Values___;

-- Get_Same_Database___
--   This method checks if there is a simillar out message to the given in message.
--   If it is available then this is same database intersite setup.
--   Else it is different database intersite setup.
--   Note: The sender_id is not applicable (null) for INET_TRANS type messages.
FUNCTION Get_Same_Database___ (
   sender_            IN VARCHAR2,
   receiver_          IN VARCHAR2,
   class_id_          IN VARCHAR2,
   sender_id_         IN NUMBER,
   sender_message_id_ IN VARCHAR2) RETURN VARCHAR2
IS
   same_database_       VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;

   CURSOR get_same_database IS
      SELECT Fnd_Boolean_API.DB_TRUE
      FROM out_message_tab
      WHERE sender                 = sender_
      AND   receiver               = receiver_
      AND   class_id               = class_id_
      AND   message_id             = sender_id_
      AND   application_message_id = sender_message_id_
      AND   receiver IN (SELECT receiver
                         FROM message_receiver_tab r,
                              installation_site_tab i
                         WHERE r.site_id = i.site_id
                         AND   i.database_link IS NULL);
                                       
BEGIN   
   IF (sender_id_ IS NOT NULL) THEN
      OPEN get_same_database;
      FETCH get_same_database INTO same_database_;
      CLOSE get_same_database;      
   END IF;   
   RETURN same_database_;
END Get_Same_Database___;

PROCEDURE Create_Dirdel_Row___ (
   message_id_              IN NUMBER,   
   message_line_            IN NUMBER,
   order_no_                IN VARCHAR2, 
   line_no_                 IN VARCHAR2, 
   rel_no_                  IN VARCHAR2,
   catalog_no_              IN VARCHAR2,
   catalog_desc_            IN VARCHAR2,
   sales_unit_meas_         IN VARCHAR2,
   price_unit_meas_         IN VARCHAR2,
   rowstate_                IN VARCHAR2,
   note_id_                 IN NUMBER,
   customer_part_no_        IN VARCHAR2,
   customer_part_unit_meas_ IN VARCHAR2,
   planned_delivery_date_   IN DATE,
   delnote_date_            IN DATE,
   qty_delivered_           IN NUMBER,
   buy_qty_due_             IN NUMBER,
   qty_shipped_             IN NUMBER,
   price_conv_factor_       IN NUMBER,
   customer_part_buy_qty_   IN NUMBER,
   catch_qty_delivered_     IN NUMBER,
   customer_no_             IN VARCHAR2,
   contract_                IN VARCHAR2,
   customer_po_no_          IN VARCHAR2, 
   alt_delnote_no_          IN VARCHAR2 )  
IS
   attr_                    VARCHAR2(32000);
   message_name_            VARCHAR2(255);
   sales_part_cross_rec_    Sales_Part_Cross_Reference_API.Public_Rec;
BEGIN
   message_name_           := 'ROW';
   sales_part_cross_rec_  := Sales_Part_Cross_Reference_API.Get(customer_no_, contract_, customer_part_no_ );
   
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('MESSAGE_ID',   message_id_,              attr_);
   Client_SYS.Add_To_Attr('MESSAGE_LINE', message_line_,            attr_);
   Client_SYS.Add_To_Attr('NAME',         message_name_,            attr_);
   Client_SYS.Add_To_Attr('C00',          order_no_,                attr_);
   Client_SYS.Add_To_Attr('C01',          customer_po_no_,          attr_);
   Client_SYS.Add_To_Attr('C02',          alt_delnote_no_,          attr_);
   Client_SYS.Add_To_Attr('C03',          line_no_,                 attr_);
   Client_SYS.Add_To_Attr('C04',          rel_no_,                  attr_);
   Client_SYS.Add_To_Attr('C05',          catalog_no_,              attr_);
   Client_SYS.Add_To_Attr('C06',          catalog_desc_,            attr_);
   Client_SYS.Add_To_Attr('C07',          sales_unit_meas_,         attr_);
   Client_SYS.Add_To_Attr('C08',          price_unit_meas_,         attr_);
   Client_SYS.Add_To_Attr('C09',          rowstate_,                attr_);
   Client_SYS.Add_To_Attr('C10',          SUBSTR(Document_Text_API.Get_All_Notes(note_id_, '3'), 1, 2000), attr_);
   Client_SYS.Add_To_Attr('C11',          '',                       attr_); -- blanket detail note
   Client_SYS.Add_To_Attr('C12',          customer_part_no_,        attr_);
   Client_SYS.Add_To_Attr('C13',          customer_part_unit_meas_, attr_);
   Client_SYS.Add_To_Attr('D00',          planned_delivery_date_,   attr_);
   Client_SYS.Add_To_Attr('D01',          delnote_date_,            attr_);
   Client_SYS.Add_To_Attr('N00',          qty_delivered_/NVL(sales_part_cross_rec_.conv_factor, 1)*NVL(sales_part_cross_rec_.inverted_conv_factor, 1), attr_);
   Client_SYS.Add_To_Attr('N01',          buy_qty_due_,             attr_);
   Client_SYS.Add_To_Attr('N02',          qty_shipped_/NVL(sales_part_cross_rec_.conv_factor, 1)*NVL(sales_part_cross_rec_.inverted_conv_factor, 1), attr_);
   Client_SYS.Add_To_Attr('N03',          price_conv_factor_,       attr_);
   Client_SYS.Add_To_Attr('N04',          customer_part_buy_qty_,   attr_);
   Client_SYS.Add_To_Attr('N05',          catch_qty_delivered_,     attr_);

   Connectivity_SYS.Create_Message_Line(attr_);
   
END Create_Dirdel_Row___;  

PROCEDURE Create_Dirdel_Transit_Row___ (
   message_id_        IN NUMBER,   
   message_line_      IN NUMBER,
   order_no_          IN VARCHAR2, 
   line_no_           IN VARCHAR2,
   rel_no_            IN VARCHAR2,
   configuration_id_  IN VARCHAR2,
   lot_batch_no_      IN VARCHAR2,
   serial_no_         IN VARCHAR2,
   waiv_dev_rej_no_   IN VARCHAR2,
   eng_chg_level_     IN VARCHAR2,
   handling_unit_id_  IN NUMBER,
   expiration_date_   IN DATE,
   qty_shipped_       IN NUMBER,
   catch_qty_shipped_ IN NUMBER,
   acquisition_site_  IN VARCHAR2,
   part_no_           IN VARCHAR2,
   contract_          IN VARCHAR2,
   catalog_no_        IN VARCHAR2,
   customer_no_       IN VARCHAR2,
   customer_po_no_    IN VARCHAR2 )  
IS
   attr_                      VARCHAR2(32000);
   msg_part_no_               VARCHAR2(45);
   transit_row_qty_shipped_   NUMBER:=0;
   message_name_              VARCHAR2(255);
BEGIN
   message_name_ := 'TRANSITROW';
   
   IF(Inventory_Part_API.Check_Exist(acquisition_site_, part_no_)) THEN
      msg_part_no_ := part_no_;
   ELSE
      msg_part_no_ := Sales_Part_Cross_Reference_API.Get_Customer_Part_No(customer_no_, contract_, catalog_no_);
   END IF;
               
   -- Divided the quantity shipped from the line conversion factor. 
   IF (Inventory_Part_API.Part_Exist(acquisition_site_, msg_part_no_) = 1) THEN
      transit_row_qty_shipped_ := Inventory_Part_API.Get_Site_Converted_Qty(msg_part_no_, qty_shipped_, Inventory_Part_API.Get_Unit_Meas(contract_, msg_part_no_), acquisition_site_, 'REMOVE');  
   ELSE
      transit_row_qty_shipped_ := qty_shipped_;
   END IF;            
               
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('MESSAGE_ID',   message_id_,              attr_);
   Client_SYS.Add_To_Attr('MESSAGE_LINE', message_line_,            attr_);
   Client_SYS.Add_To_Attr('NAME',         message_name_,            attr_);   
   Client_SYS.Add_To_Attr('C00',          order_no_,                attr_);
   Client_SYS.Add_To_Attr('C01',          customer_po_no_,          attr_);
   Client_SYS.Add_To_Attr('C02',          line_no_,                 attr_);
   Client_SYS.Add_To_Attr('C03',          rel_no_,                  attr_);
   Client_SYS.Add_To_Attr('C04',          configuration_id_,        attr_);
   Client_SYS.Add_To_Attr('C05',          lot_batch_no_,            attr_);
   Client_SYS.Add_To_Attr('C06',          serial_no_,               attr_);
   Client_SYS.Add_To_Attr('C07',          waiv_dev_rej_no_,         attr_);
   Client_SYS.Add_To_Attr('C08',          eng_chg_level_,           attr_);
   Client_SYS.Add_To_Attr('D00',          expiration_date_,         attr_);
   Client_SYS.Add_To_Attr('N00',          transit_row_qty_shipped_, attr_);
   Client_SYS.Add_To_Attr('N01',          catch_qty_shipped_,       attr_);
   Client_SYS.Add_To_Attr('N02',          handling_unit_id_,        attr_);
   
   Connectivity_SYS.Create_Message_Line(attr_);
   
END Create_Dirdel_Transit_Row___;  

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------
-- Add_Org_Line_Values___
--   Adds the orginal order line values to the attribute string to store the
--   old information and be able to compare it with the new one.
PROCEDURE Add_Org_Line_Values__ (
   attr_     IN OUT VARCHAR2,
   order_no_ IN     VARCHAR2,
   b2b_process_online_ IN BOOLEAN DEFAULT FALSE)
IS
   orgrec_     customer_order_line_tab%ROWTYPE;
   orgaddrrec_ cust_order_line_address_tab%ROWTYPE;
   line_no_    VARCHAR2(4);
   rel_no_     VARCHAR2(4);
   $IF Component_Rental_SYS.INSTALLED $THEN
      rental_org_rec_  Rental_Object_API.Public_Rec;
   $END

   CURSOR get_org_line IS
      SELECT *
      FROM   customer_order_line_tab
      WHERE  order_no = order_no_
      AND    line_no = line_no_
      AND    rel_no = rel_no_
      AND    line_item_no <= 0;

   CURSOR get_org_address IS
      SELECT *
      FROM cust_order_line_address_tab
      WHERE  order_no = order_no_
      AND    line_no = line_no_
      AND    rel_no = rel_no_
      AND    line_item_no <= 0;
BEGIN
   line_no_ := Client_SYS.Get_Item_Value('LINE_NO', attr_);
   rel_no_ := Client_SYS.Get_Item_Value('REL_NO', attr_);
   OPEN  get_org_line;
   FETCH get_org_line INTO orgrec_;
   CLOSE get_org_line;
   -- Orginal Line
   Client_SYS.Add_To_Attr('ORG_CATALOG_DESC', orgrec_.catalog_desc, attr_);
   Client_SYS.Add_To_Attr('ORG_BUY_QTY_DUE', NVL(orgrec_.customer_part_buy_qty, orgrec_.buy_qty_due), attr_);
   Client_SYS.Add_To_Attr('ORG_WANTED_DELIVERY_DATE', orgrec_.wanted_delivery_date, attr_);
   Client_SYS.Add_To_Attr('ORG_DOCK_CODE', orgrec_.dock_code, attr_);
   Client_SYS.Add_To_Attr('ORG_SUB_DOCK_CODE', orgrec_.sub_dock_code, attr_);
   Client_SYS.Add_To_Attr('ORG_LOCATION', orgrec_.location_no, attr_);
   Client_SYS.Add_To_Attr('ORG_ORIGINATING_CO_LANG_CODE', orgrec_.originating_co_lang_code, attr_);
   Client_SYS.Add_To_Attr('ORG_FORWARD_AGENT_ID', orgrec_.forward_agent_id, attr_);
   Client_SYS.Add_To_Attr('ORG_ROUTE_ID', orgrec_.route_id, attr_);
   Client_SYS.Add_To_Attr('ORG_CONTACT', orgrec_.contact, attr_);
   Client_SYS.Add_To_Attr('ORG_DISTRICT_CODE', orgrec_.district_code, attr_);
   Client_SYS.Add_To_Attr('ORG_REGION_CODE', orgrec_.region_code, attr_);
   Client_SYS.Add_To_Attr('ORG_CUST_CALENDAR_ID', orgrec_.cust_calendar_id, attr_);
   Client_SYS.Add_To_Attr('ORG_EXT_TRANS_CALENDAR_ID', orgrec_.ext_transport_calendar_id, attr_);
   Client_SYS.Add_To_Attr('ORG_DISCOUNT', orgrec_.discount, attr_);
   Client_SYS.Add_To_Attr('ORG_CONFIGURATION_ID', orgrec_.configuration_id, attr_);
   --If B2B Process: Exclude some org value, but add ship addr no
   IF NOT b2b_process_online_ THEN
      Client_SYS.Add_To_Attr('ORG_SALE_UNIT_PRICE', orgrec_.sale_unit_price, attr_);      
      Client_SYS.Add_To_Attr('ORG_UNIT_PRICE_INCL_TAX', orgrec_.unit_price_incl_tax, attr_);
      Client_SYS.Add_To_Attr('ORG_NOTES', orgrec_.note_text, attr_);
   ELSE
      IF (orgrec_.addr_flag  = 'N') THEN
         Client_SYS.Add_To_Attr('ORG_SHIP_ADDR_NO', orgrec_.ship_addr_no, attr_);    
      END IF;
   END IF;
   
   IF (orgrec_.default_addr_flag = 'N') THEN
      IF NOT b2b_process_online_ THEN
         Client_SYS.Add_To_Attr('ORG_DELIVERY_TERMS', orgrec_.delivery_terms, attr_);
         Client_SYS.Add_To_Attr('ORG_SHIP_VIA_CODE', orgrec_.ship_via_code, attr_);
      END IF;
      IF (orgrec_.addr_flag = 'N') THEN
         IF NOT b2b_process_online_ THEN
            Client_SYS.Add_To_Attr('ORG_EAN_LOCATION_DEL_ADDR',
            Cust_Ord_Customer_Address_API.Get_Ean_Location(orgrec_.deliver_to_customer_no, orgrec_.ship_addr_no), attr_); 
         END IF;
      ELSE
         -- Original Line Address
         OPEN  get_org_address;
         FETCH get_org_address INTO orgaddrrec_;
         CLOSE get_org_address;
         Client_SYS.Add_To_Attr('ORG_DELIVERY_ADDRESS_NAME', orgaddrrec_.addr_1, attr_);
         Client_SYS.Add_To_Attr('ORG_SHIP_ADDRESS1', orgaddrrec_.address1, attr_);
         Client_SYS.Add_To_Attr('ORG_SHIP_ADDRESS2', orgaddrrec_.address2, attr_);
         Client_SYS.Add_To_Attr('ORG_SHIP_ADDRESS3', orgaddrrec_.address3, attr_);
         Client_SYS.Add_To_Attr('ORG_SHIP_ADDRESS4', orgaddrrec_.address4, attr_);
         Client_SYS.Add_To_Attr('ORG_SHIP_ADDRESS5', orgaddrrec_.address5, attr_);
         Client_SYS.Add_To_Attr('ORG_SHIP_ADDRESS6', orgaddrrec_.address6, attr_);
         Client_SYS.Add_To_Attr('ORG_SHIP_ZIP_CODE', orgaddrrec_.zip_code, attr_);
         Client_SYS.Add_To_Attr('ORG_SHIP_CITY', orgaddrrec_.city, attr_);
         Client_SYS.Add_To_Attr('ORG_SHIP_STATE', orgaddrrec_.state, attr_);
         Client_SYS.Add_To_Attr('ORG_SHIP_COUNTY', orgaddrrec_.county, attr_);
         Client_SYS.Add_To_Attr('ORG_COUNTRY_CODE', orgaddrrec_.country_code, attr_);
      END IF;
   END IF;
   
   IF (orgrec_.rental = Fnd_Boolean_API.DB_TRUE) THEN
      $IF Component_Rental_SYS.INSTALLED $THEN
         rental_org_rec_  := Rental_Object_API.Get_Rental_Rec(order_no_,
                                                              line_no_,
                                                              rel_no_,
                                                              0,
                                                              Rental_Type_API.DB_CUSTOMER_ORDER);
         Client_SYS.Add_To_Attr('ORG_RENTAL_START_DATE', rental_org_rec_.planned_rental_start_date, attr_);
         Client_SYS.Add_To_Attr('ORG_RENTAL_END_DATE', rental_org_rec_.planned_rental_end_date, attr_);
      $ELSE
         Error_SYS.Component_Not_Exist('RENTAL');         
      $END
   END IF;
  
END Add_Org_Line_Values__;

-- Send_Price_List__
--   Sends a price list to one or several customers using EDI/MHS.
--   Received in the PURCH method Price_Catalog_Transfer_API.Receive_Price_Catalog.
PROCEDURE Send_Price_List__ (
   attr_ IN VARCHAR2 )
IS
   price_list_no_     VARCHAR2(200);
   media_code_        VARCHAR2(100);
   customer_no_list_  VARCHAR2(32000);
   valid_from_        DATE;
   valid_to_          DATE;
   price_list_site_   VARCHAR2(10);
   ptr_               NUMBER;
   name_              VARCHAR2(30);
   value_             VARCHAR2(2000); 
BEGIN
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'CUSTOMER_NO') THEN
         Client_SYS.Add_To_Attr( name_, value_, customer_no_list_);
      ELSIF (name_ = 'PRICE_LIST_NO') THEN
         price_list_no_ := value_;
      ELSIF (name_ = 'MEDIA_CDE') THEN
         media_code_ := value_;
      ELSIF (name_ = 'VALID_FROM') THEN
         valid_from_ := Client_SYS.Attr_Value_To_Date(value_);
      ELSIF (name_ = 'VALID_TO') THEN
         valid_to_ := Client_SYS.Attr_Value_To_Date(value_);
      ELSIF (name_ = 'PRICE_LIST_SITE') THEN
         price_list_site_ := value_;
      END IF;
   END LOOP;
   Do_Send_Price_List(price_list_no_, media_code_, customer_no_list_, valid_from_, valid_to_, price_list_site_);
END Send_Price_List__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Receive_Order
--   Process an incoming ORDERS message and transfer the incoming message
--   data to the ExternalCustomerOrder and ExternalCustOrderLines LU's
PROCEDURE Receive_Order (
   message_id_ IN NUMBER )
IS
   attr_                     VARCHAR2(32000);
   newattr_                  VARCHAR2(32000);
   customer_no_              external_customer_order_tab.customer_no%TYPE := NULL;
   internal_customer_site_   external_customer_order_tab.internal_customer_site%TYPE := NULL;
   language_                 VARCHAR2(2000);
   external_ref_             VARCHAR2(2000);
   sending_price_flag_       VARCHAR2(2000);
   sales_unit_price_         NUMBER;
   unit_price_incl_tax_      NUMBER;
   catalog_desc_             external_cust_order_line_tab.catalog_desc%TYPE;
   import_mode_              VARCHAR2(2000) := 'ORDER';
   currency_                 VARCHAR2(2000);
   internal_delivery_type_   VARCHAR2(20);
   delivery_terms_desc_      VARCHAR2(2000);
   ship_via_desc_            VARCHAR2(2000);
   route_id_                 VARCHAR2(2000);
   delivery_leadtime_        NUMBER;
   forward_agent_id_         EXTERNAL_CUSTOMER_ORDER_TAB.forward_agent_id%TYPE;
   internal_po_no_           VARCHAR2(2000);
   intrastat_exempt_db_      VARCHAR2(20);
   delivery_terms_           VARCHAR2(2000);
   ean_location_del_addr_    VARCHAR2(2000);
   deliver_to_customer_no_   EXTERNAL_CUSTOMER_ORDER_TAB.customer_no%TYPE;
   ship_addr_no_             CUSTOMER_ORDER_TAB.ship_addr_no%TYPE;
   contract_                 VARCHAR2(2000);
   gtin_no_                  VARCHAR2(14);
   accept_message_           BOOLEAN := FALSE;
   picking_leadtime_         NUMBER;
   shipment_type_            VARCHAR2(3);
   cust_calendar_id_         VARCHAR2(10);
   ext_trans_calendar_id_    VARCHAR2(10);
   sender_                   VARCHAR2(255);
   receiver_                 VARCHAR2(255);
   class_id_                 VARCHAR2(30);
   sender_id_txt_            VARCHAR2(2000);
   sender_id_                NUMBER := NULL;
   sender_message_id_        VARCHAR2(255);
   customer_po_no_           EXTERNAL_CUSTOMER_ORDER_TAB.customer_po_no%TYPE;
   discount_                 NUMBER;  
   internal_delivery_type_db_ VARCHAR2(20);
   
   CURSOR get_message_line IS
      SELECT *
      FROM   IN_MESSAGE_LINE_PUB
      WHERE  message_id = message_id_
      ORDER BY message_line;
BEGIN
   -- Get Message Head
   attr_ := Connectivity_SYS.Get_Message(message_id_);
   IF (attr_ IS NULL) THEN
      RETURN;
   END IF;
   Trace_SYS.Field('Message Head', attr_);
   sender_            := Client_SYS.Get_Item_Value('SENDER', attr_);
   receiver_          := Client_SYS.Get_Item_Value('RECEIVER', attr_);
   class_id_          := Client_SYS.Get_Item_Value('CLASS_ID', attr_);
   sender_id_txt_     := Client_SYS.Get_Item_Value('SENDER_ID', attr_);
   sender_message_id_ := Client_SYS.Get_Item_Value('SENDER_MESSAGE_ID', attr_);
   IF (class_id_ != 'ORDERS') THEN
      RETURN;
   END IF;
   
   -- The sender_id_txt_ value is N/A for INET_TRANS type messages.
   -- Otherwise outbox message_id.
   IF (sender_id_txt_ != 'N/A') THEN
      BEGIN
         sender_id_ := TO_NUMBER(sender_id_txt_);
      EXCEPTION
         WHEN OTHERS THEN
            Error_SYS.Item_General(lu_name_, 'SENDER_ID', 'INVALFORMAT: Field [:NAME] must contain a numeric value. The value is: ":P1".', sender_id_txt_);
      END;
   END IF;

   -- Get all Message Rows
   FOR line_rec_ IN get_message_line LOOP
      IF (line_rec_.name = 'HEADER') THEN         
         Client_SYS.Clear_Attr(newattr_);         
         external_ref_ := NULL;
         delivery_terms_ := NULL;
         delivery_terms_desc_ := NULL;
         ean_location_del_addr_ := NULL;         
         ship_addr_no_ :=NULL;
         
         Client_SYS.Set_Item_Value('MESSAGE_ID', line_rec_.message_id, newattr_);
         IF line_rec_.c00 IS NOT NULL THEN         
            internal_po_no_   := line_rec_.c00;         
         END IF;
         IF line_rec_.c01 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('CONTRACT', line_rec_.c01, newattr_);
            contract_ := line_rec_.c01;
         END IF;
         IF line_rec_.c06 IS NOT NULL THEN
            currency_ := line_rec_.c06;
         END IF;
         IF line_rec_.c07 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('DELIVERY_ADDRESS_NAME', line_rec_.c07, newattr_);
         END IF;
         IF line_rec_.c08 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('SHIP_ADDRESS1', line_rec_.c08, newattr_);
         END IF;
         IF line_rec_.c09 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('SHIP_ADDRESS2', line_rec_.c09, newattr_);
         END IF;
         IF line_rec_.c74 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('SHIP_ADDRESS3', line_rec_.c74, newattr_);
         END IF;
         IF line_rec_.c75 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('SHIP_ADDRESS4', line_rec_.c75, newattr_);
         END IF;
         IF line_rec_.c76 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('SHIP_ADDRESS5', line_rec_.c76, newattr_);
         END IF;
         IF line_rec_.c77 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('SHIP_ADDRESS6', line_rec_.c77, newattr_);
         END IF;
         IF line_rec_.c10 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('SHIP_ZIP_CODE', line_rec_.c10, newattr_);
         END IF;
         IF line_rec_.c11 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('SHIP_CITY', line_rec_.c11, newattr_);
         END IF;
         IF line_rec_.c12 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('SHIP_STATE', line_rec_.c12, newattr_);
         END IF;
         IF line_rec_.c49 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('SHIP_COUNTY', line_rec_.c49, newattr_);
         END IF;
         IF line_rec_.c13 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('COUNTRY_CODE', line_rec_.c13, newattr_);
         END IF;
         IF line_rec_.c14 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('INTERNAL_REF', line_rec_.c14, newattr_);
         END IF;
         IF line_rec_.c15 IS NOT NULL THEN
            delivery_terms_desc_ := line_rec_.c15;
         END IF;
         IF line_rec_.c16 IS NOT NULL THEN
            ship_via_desc_ := line_rec_.c16;
         END IF;
         IF line_rec_.c17 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('FORWARD_AGENT_ID', line_rec_.c17, newattr_);
         END IF;
         IF line_rec_.c18 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('LABEL_NOTE', line_rec_.c18, newattr_);
         END IF;
         IF line_rec_.c25 IS NOT NULL THEN            
            customer_no_ := line_rec_.c25;
         END IF;
         IF line_rec_.c26 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('NOTE_TEXT', line_rec_.c26, newattr_);
         END IF;
         IF line_rec_.c33 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('EAN_LOCATION_DEL_ADDR', line_rec_.c33, newattr_);
            ean_location_del_addr_ := line_rec_.c33;
         END IF;
         IF line_rec_.c34 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('EAN_LOCATION_DOC_ADDR', line_rec_.c34, newattr_);
         END IF;
         IF line_rec_.c35 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('CUSTOMER_NO_PAY', line_rec_.c35, newattr_);
         END IF;
         IF line_rec_.c36 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('EAN_LOCATION_PAYER_ADDR', line_rec_.c36, newattr_);
         END IF;
         IF line_rec_.c37 IS NOT NULL THEN
            IF (line_rec_.c37 = '4') THEN
               Client_SYS.Set_Item_Value('INTERNAL_DELIVERY_TYPE', 'INTER-SITE', newattr_);
               Client_SYS.Set_Item_Value('INTERNAL_PO_NO', line_rec_.c00, newattr_);
           END IF;
            internal_delivery_type_ := line_rec_.c37;
         END IF;
         IF line_rec_.c38 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('CUSTOMER_PO_NO', line_rec_.c38, newattr_);
            customer_po_no_ := line_rec_.c38;
         END IF;
         IF line_rec_.c39 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('INTERNAL_CUSTOMER_SITE', line_rec_.c39, newattr_);
            internal_customer_site_ := line_rec_.c39;
         END IF;
         IF line_rec_.c41 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('PAY_TERM_ID', line_rec_.c41, newattr_);
         END IF;
         IF line_rec_.c42 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('DELIVERY_TERMS', line_rec_.c42, newattr_);
            delivery_terms_ := line_rec_.c42;
         END IF;
         IF line_rec_.c43 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('SHIP_VIA_CODE', line_rec_.c43, newattr_);
         END IF;
         IF line_rec_.c44 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('SALESMAN_CODE', line_rec_.c44, newattr_);
         END IF;
         IF line_rec_.c45 IS NOT NULL THEN
            language_ := line_rec_.c45;
         END IF;
         IF line_rec_.c46 IS NOT NULL THEN
            import_mode_ := nvl(line_rec_.c46, 'ORDER');
         END IF;
         IF line_rec_.c47 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('EXTERNAL_REF', line_rec_.c47, newattr_);
            external_ref_ := line_rec_.c47;
         END IF;
         IF line_rec_.c48 IS NOT NULL THEN
            route_id_ := line_rec_.c48;
         END IF;
         IF line_rec_.c50 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('BACKORDER_OPTION_DB', line_rec_.c50, newattr_);
         END IF;
         IF line_rec_.c54 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('VAT_NO', line_rec_.c54, newattr_);
         END IF;
         IF line_rec_.c55 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('DEL_TERMS_LOCATION', line_rec_.c55, newattr_);
         END IF;
         IF line_rec_.c56 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('PRINT_DELIVERED_LINES_DB', line_rec_.c56, newattr_); 
         END IF;
         IF line_rec_.c61 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('CUST_REF', line_rec_.c61, newattr_);
         END IF;
         IF line_rec_.c62 IS NOT NULL THEN
            Client_SYS.Set_item_Value('IN_CITY', line_rec_.c62, newattr_);
         END IF;
         IF line_rec_.c73 IS NOT NULL THEN
            shipment_type_ := line_rec_.c73;   
         END IF;
         IF line_rec_.c85 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('INTERNAL_PO_LABEL_NOTE', line_rec_.c85, newattr_);
         END IF;
         IF line_rec_.d01 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('DELIVERY_DATE', line_rec_.d01, newattr_);
         END IF;
         IF line_rec_.n10 IS NOT NULL THEN
            delivery_leadtime_ := line_rec_.n10;
         END IF;      
         IF line_rec_.n12 IS NOT NULL THEN
             picking_leadtime_ := line_rec_.n12;
         END IF;           
         
         -- set import mode here. Default value is ORDER. (PURCH doesn't send C46...)
         Client_SYS.Set_Item_Value('IMPORT_MODE', import_mode_, newattr_);

         Get_Common_Receive_Header_Info___(customer_no_, language_, 
                                   delivery_terms_desc_, customer_po_no_, 
                                   internal_delivery_type_, delivery_terms_, 
                                   internal_customer_site_, ean_location_del_addr_, internal_po_no_ ); 
                                   
         
         Client_SYS.Set_Item_Value('CUSTOMER_NO', customer_no_, newattr_);
         Client_SYS.Set_Item_Value('LANGUAGE_CODE', language_, newattr_);
         Client_SYS.Set_Item_Value('CURRENCY_CODE', currency_, newattr_);
         Client_SYS.Set_Item_Value('DELIVERY_TERMS_DESC', delivery_terms_desc_, newattr_);
         Client_SYS.Set_Item_Value('CUSTOMER_PO_NO', customer_po_no_, newattr_);
         -- add these values if its an internal delivery from Purch
         IF (internal_delivery_type_ = '4') THEN            
            Client_SYS.Set_Item_Value('SHIP_VIA_DESC', ship_via_desc_, newattr_);            
            Client_SYS.Set_Item_Value('PICKING_LEADTIME', picking_leadtime_, newattr_);
            Client_SYS.Set_Item_Value('SHIPMENT_TYPE', shipment_type_, newattr_);
         END IF;
         -- add these values if its an internal direct delivery from Purch
         IF (internal_delivery_type_ = '1') THEN
            Client_SYS.Set_Item_Value('DELIVERY_LEADTIME', delivery_leadtime_, newattr_);
         END IF;
         Cancel_Prev_Ext_Cust_Orders___(external_ref_);
         
         IF (currency_ IS NULL) THEN
            currency_ := Cust_Ord_Customer_API.Get_Currency_Code(customer_no_);
         END IF;
         Client_SYS.Set_Item_Value('CURRENCY_CODE', currency_, newattr_);
         Client_SYS.Set_Item_Value('SAME_DATABASE_DB', Get_Same_Database___(sender_, receiver_, class_id_, sender_id_, sender_message_id_), newattr_);
         
         -- Create new External_Customer Order (Head)
         Trace_SYS.Field('Transfer Customer Order Head NewAttr', newattr_);
         External_Customer_Order_API.New(newattr_);
      END IF;

      IF (line_rec_.name = 'ROW') THEN 
         Client_SYS.Clear_Attr(newattr_);
         Client_SYS.Set_Item_Value('MESSAGE_ID', line_rec_.message_id, newattr_);
         Client_SYS.Set_Item_Value('MESSAGE_LINE', line_rec_.message_line, newattr_);

         route_id_               := NULL;
         delivery_terms_         := NULL;
         delivery_terms_desc_    := NULL;
         ean_location_del_addr_  := NULL;
         sales_unit_price_       := NULL;
         unit_price_incl_tax_    := NULL;
         catalog_desc_           := NULL;
         discount_               := NULL;
         shipment_type_          := NULL;
         sending_price_flag_     := NULL;
         
         IF line_rec_.c01 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('LINE_NO', line_rec_.c01, newattr_);
         END IF;
         IF line_rec_.c02 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('REL_NO', line_rec_.c02, newattr_);
         END IF;
         IF line_rec_.c03 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('CUSTOMER_PART_NO', line_rec_.c03, newattr_);
         END IF;
         IF line_rec_.c04 IS NOT NULL THEN
            catalog_desc_ := line_rec_.c04;
         END IF;
         IF line_rec_.c09 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('CATALOG_NO', line_rec_.c09, newattr_);
         END IF;
         IF line_rec_.c11 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('NOTES', line_rec_.c11, newattr_);
         END IF;
         IF line_rec_.c16 IS NOT NULL THEN
            sending_price_flag_ := line_rec_.c16;
         END IF;
         IF line_rec_.c17 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('DELIVERY_ADDRESS_NAME', line_rec_.c17, newattr_);
         END IF;
         IF line_rec_.c18 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('SHIP_ADDRESS1', line_rec_.c18, newattr_);
         END IF;
         IF line_rec_.c19 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('SHIP_ADDRESS2', line_rec_.c19, newattr_);
         END IF;
         IF line_rec_.c74 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('SHIP_ADDRESS3', line_rec_.c74, newattr_);
         END IF;
         IF line_rec_.c75 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('SHIP_ADDRESS4', line_rec_.c75, newattr_);
         END IF;
         IF line_rec_.c76 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('SHIP_ADDRESS5', line_rec_.c76, newattr_);
         END IF;
         IF line_rec_.c77 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('SHIP_ADDRESS6', line_rec_.c77, newattr_);
         END IF;
         IF line_rec_.c20 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('SHIP_ZIP_CODE', line_rec_.c20, newattr_);
         END IF;
         IF line_rec_.c21 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('SHIP_CITY', line_rec_.c21, newattr_);
         END IF;
         IF line_rec_.c22 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('SHIP_STATE', line_rec_.c22, newattr_);
         END IF;
         IF line_rec_.c49 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('SHIP_COUNTY', line_rec_.c49, newattr_);
         END IF;
         IF line_rec_.c62 IS NOT NULL THEN
            Client_SYS.Set_item_Value('IN_CITY', line_rec_.c62, newattr_);
         END IF;
         IF line_rec_.c23 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('COUNTRY_CODE', line_rec_.c23, newattr_);
         END IF;
         IF line_rec_.c24 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('DELIVERY_TERMS', line_rec_.c24, newattr_);
            delivery_terms_ := line_rec_.c24;
         END IF;
         IF line_rec_.c25 IS NOT NULL THEN            
            delivery_terms_desc_ := line_rec_.c25;
         END IF;
         IF line_rec_.c26 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('SHIP_VIA_CODE', line_rec_.c26, newattr_);
         END IF;
         IF line_rec_.c27 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('SHIP_VIA_DESC', line_rec_.c27, newattr_);
         END IF;
         IF line_rec_.c28 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('EAN_LOCATION_DEL_ADDR', line_rec_.c28, newattr_);
            ean_location_del_addr_ := line_rec_.c28;
         END IF;
         IF line_rec_.c29 IS NOT NULL THEN
            route_id_ := line_rec_.c29;
         END IF;
         IF line_rec_.c30 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('FORWARD_AGENT_ID', line_rec_.c30, newattr_);
            forward_agent_id_ := line_rec_.c30;
         END IF;
         IF line_rec_.c31 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('CONDITION_CODE', line_rec_.c31, newattr_);
         END IF;
         IF line_rec_.c32 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('CUSTOMER_PO_LINE_NO', line_rec_.c32, newattr_);
         END IF;
         IF line_rec_.c33 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('CUSTOMER_PO_REL_NO', line_rec_.c33, newattr_);
         END IF;
         IF line_rec_.c36 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('SHIPMENT_CREATION_DB', line_rec_.c36, newattr_);
         END IF;
         IF line_rec_.c37 IS NOT NULL THEN
            internal_delivery_type_ := line_rec_.c37;            
         END IF;
         IF line_rec_.c44 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('VAT_NO', line_rec_.c44, newattr_);
         END IF;
         IF line_rec_.c45 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('VAT_FREE_VAT_CODE', line_rec_.c45, newattr_);
         END IF;
         IF line_rec_.c46 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('TAX_LIABILITY', line_rec_.c46, newattr_);
         END IF;
         IF line_rec_.c51 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('DOCK_CODE', line_rec_.c51, newattr_);
         END IF;
         IF line_rec_.c52 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('SUB_DOCK_CODE', line_rec_.c52, newattr_);
         END IF;
         IF line_rec_.c53 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('LOCATION', line_rec_.c53, newattr_);
         END IF;
         IF line_rec_.c54 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('INVENTORY_FLAG_DB', line_rec_.c54, newattr_);
         END IF;
         IF line_rec_.c56 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('DELIVER_TO_CUSTOMER_NO', line_rec_.c56, newattr_);
            deliver_to_customer_no_ := line_rec_.c56;
         END IF;
         IF line_rec_.c57 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('DISTRICT_CODE', line_rec_.c57, newattr_);
         END IF;
         IF line_rec_.c58 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('REGION_CODE', line_rec_.c58, newattr_);
         END IF;
         IF line_rec_.c59 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('CONTACT', line_rec_.c59, newattr_);
         END IF;
         IF line_rec_.c60 IS NOT NULL THEN
            intrastat_exempt_db_ := line_rec_.c60;
         END IF;
         IF line_rec_.c63 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('DEL_TERMS_LOCATION', line_rec_.c63, newattr_);
         END IF;
         IF line_rec_.c64 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('CLASSIFICATION_STANDARD', line_rec_.c64, newattr_);
         END IF;
         IF line_rec_.c65 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('CLASSIFICATION_PART_NO', line_rec_.c65, newattr_);
         END IF;
         IF line_rec_.c66 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('CLASSIFICATION_UNIT_MEAS', line_rec_.c66, newattr_);
         END IF;
         IF line_rec_.c67 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('GTIN_NO', line_rec_.c67, newattr_);
            gtin_no_ := line_rec_.c67;
         END IF;
         IF line_rec_.c68 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('VENDOR_PART_DESC', line_rec_.c68, newattr_);
         END IF;
         IF line_rec_.c69 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('PACKING_INSTRUCTION_ID', line_rec_.c69, newattr_);
         END IF;
         IF line_rec_.c70 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('ORIGINATING_CO_LANG_CODE', line_rec_.c70, newattr_);
         END IF;
         IF line_rec_.c71 IS NOT NULL THEN
            cust_calendar_id_ := line_rec_.c71;
         END IF;
         IF line_rec_.c72 IS NOT NULL THEN
            ext_trans_calendar_id_ := line_rec_.c72;
         END IF;
         IF line_rec_.c73 IS NOT NULL THEN
            shipment_type_ :=  line_rec_.c73;
         END IF;
         IF line_rec_.d00 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('WANTED_DELIVERY_DATE', line_rec_.d00, newattr_);
         END IF;
         IF line_rec_.d05 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('ORIGINAL_PLAN_DELIV_DATE', line_rec_.d05, newattr_);
         END IF;
         IF line_rec_.d06 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('TAX_ID_VALIDATED_DATE', line_rec_.d06, newattr_);          
         END IF;
         IF line_rec_.d07 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('RENTAL_DB', Fnd_Boolean_API.DB_TRUE, newattr_);            
            Client_SYS.Set_Item_Value('PLANNED_RENTAL_START_DATE', line_rec_.d07, newattr_);
            Client_SYS.Set_Item_Value('ORIGINAL_RENTAL_START_DATE', line_rec_.d07, newattr_);
         END IF;
         IF line_rec_.d08 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('PLANNED_RENTAL_END_DATE', line_rec_.d08, newattr_);
            Client_SYS.Set_Item_Value('ORIGINAL_RENTAL_END_DATE', line_rec_.d08, newattr_);
         END IF;
         IF line_rec_.n00 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('BUY_QTY_DUE', line_rec_.n00, newattr_);
            Client_SYS.Set_Item_Value('ORIGINAL_BUY_QTY_DUE', line_rec_.n00, newattr_);
         END IF;
         IF line_rec_.n02 IS NOT NULL THEN
            sales_unit_price_ := line_rec_.n02;
         END IF;
         IF line_rec_.n06 IS NOT NULL THEN
            discount_   := line_rec_.n06;
         END IF;
         IF line_rec_.n13 IS NOT NULL THEN
            unit_price_incl_tax_ := line_rec_.n13;
         END IF;
         IF line_rec_.n09 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('CUSTOMER_QUANTITY', line_rec_.n09, newattr_);
         END IF;
         IF line_rec_.n10 IS NOT NULL THEN
            delivery_leadtime_ := line_rec_.n10;
         END IF;
         IF line_rec_.n11 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('INPUT_QTY', line_rec_.n11, newattr_);
         END IF;       
         IF line_rec_.n12 IS NOT NULL THEN
             picking_leadtime_ := line_rec_.n12;
         END IF;
         IF line_rec_.n16 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('REPLACEMENT_RENTAL_NO', line_rec_.n16, newattr_);
         END IF;
         
         internal_delivery_type_db_ := internal_delivery_type_;
         Get_Data_Receive_Cust_Order_Line___(internal_delivery_type_db_, delivery_terms_desc_,                                           
                                          deliver_to_customer_no_, delivery_terms_);
      
         Client_SYS.Set_Item_Value('INTERNAL_DELIVERY_TYPE_DB', internal_delivery_type_db_, newattr_);
         Client_SYS.Set_Item_Value('DELIVERY_TERMS_DESC', delivery_terms_desc_, newattr_);
         
         -- apply price/desription to co-line if this is a demanded
         IF ( sending_price_flag_ IS NOT NULL AND sending_price_flag_ = 'SENDPRICE' ) THEN
            Client_SYS.Set_Item_Value('SALE_UNIT_PRICE', sales_unit_price_, newattr_);
            Client_SYS.Set_Item_Value('UNIT_PRICE_INCL_TAX', unit_price_incl_tax_, newattr_);
            Client_SYS.Set_Item_Value('CATALOG_DESC', catalog_desc_, newattr_);
            Client_SYS.Set_Item_Value('DISCOUNT', NVL(discount_, 0), newattr_);
         END IF;
         -- Add this value if its an internal direct delivery from Purch
         IF (internal_delivery_type_ = '3') THEN
            Client_SYS.Set_Item_Value('FORWARD_AGENT_ID', forward_agent_id_, newattr_);
            Client_SYS.Set_Item_Value('DELIVERY_LEADTIME', delivery_leadtime_, newattr_);
            Client_SYS.Set_Item_Value('ROUTE_ID', route_id_, newattr_);
            Client_SYS.Set_Item_Value('INTRASTAT_EXEMPT_DB', intrastat_exempt_db_, newattr_);
            Client_SYS.Set_Item_Value('PICKING_LEADTIME', picking_leadtime_, newattr_);
            Client_SYS.Set_Item_Value('SHIPMENT_TYPE', shipment_type_, newattr_);
            Client_SYS.Set_Item_Value('CUST_CALENDAR_ID', cust_calendar_id_, newattr_);
            Client_SYS.Set_Item_Value('EXT_TRANSPORT_CALENDAR_ID', ext_trans_calendar_id_, newattr_);
         END IF;

         IF (internal_delivery_type_ = '2' OR internal_delivery_type_ = '4') THEN
            Client_SYS.Set_Item_Value('DELIVERY_LEADTIME', delivery_leadtime_, newattr_);            
         END IF;
         
         IF (internal_delivery_type_ = '4') THEN
            Client_SYS.Set_Item_Value('PICKING_LEADTIME', picking_leadtime_, newattr_);
            Client_SYS.Set_Item_Value('SHIPMENT_TYPE', shipment_type_, newattr_);
         END IF;         

         -- Create new Customer Order Line (Detail)
         Trace_SYS.Field('Transfer Customer Order Row NewAttr', newattr_);
         External_Cust_Order_Line_API.New(newattr_);
      END IF;
      IF (line_rec_.name = 'CONFIGROW') THEN        
         Client_SYS.Clear_Attr(newattr_);
         Client_SYS.Set_Item_Value('MESSAGE_ID', line_rec_.message_id, newattr_);
         Client_SYS.Set_Item_Value('MESSAGE_LINE', line_rec_.message_line, newattr_);
         IF line_rec_.c01 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('LINE_NO', line_rec_.c01, newattr_);
         END IF;
         IF line_rec_.c02 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('REL_NO', line_rec_.c02, newattr_);
         END IF;
         IF line_rec_.c03 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('CUSTOMER_PART_NO', line_rec_.c03, newattr_);
         END IF;
         IF line_rec_.c04 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('CATALOG_DESC', line_rec_.c04, newattr_);
         END IF;
         IF line_rec_.c09 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('CATALOG_NO', line_rec_.c09, newattr_);
         END IF;
         IF line_rec_.c11 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('NOTES', line_rec_.c11, newattr_);
         END IF;
         IF line_rec_.c28 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('EAN_LOCATION_DEL_ADDR', line_rec_.c28, newattr_);
         END IF;
         IF line_rec_.c56 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('DELIVER_TO_CUSTOMER_NO', line_rec_.c56, newattr_);
         END IF;
         IF line_rec_.c59 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('CONTACT', line_rec_.c59, newattr_);
         END IF;
         IF line_rec_.d00 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('WANTED_DELIVERY_DATE', line_rec_.d00, newattr_);
         END IF;
         IF line_rec_.n00 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('BUY_QTY_DUE', line_rec_.n00, newattr_);
         END IF;
         IF line_rec_.n02 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('SALE_UNIT_PRICE', line_rec_.n02, newattr_);
         END IF;
         IF line_rec_.n06 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('DISCOUNT', line_rec_.n06, newattr_);
         END IF;
         IF line_rec_.n09 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('CUSTOMER_QUANTITY', line_rec_.n09, newattr_);
         END IF;
         
         -- Create new Customer Order Line (Detail)
         Trace_SYS.Field('Transfer Customer Order Row NewAttr', newattr_);
         External_Cust_Order_Line_API.New(newattr_);
      END IF;
      IF (line_rec_.name = 'CHARROW') THEN        
         Client_SYS.Clear_Attr(newattr_);
         Client_SYS.Set_Item_Value('MESSAGE_ID', line_rec_.message_id, newattr_);
         Client_SYS.Set_Item_Value('MESSAGE_LINE', line_rec_.message_line, newattr_);
         IF line_rec_.c01 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('LINE_NO', line_rec_.c01, newattr_);
         END IF;
         IF line_rec_.c02 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('RELEASE_NO', line_rec_.c02, newattr_);
         END IF;
         IF line_rec_.c03 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('BASE_ITEM_NO', line_rec_.c03, newattr_);
         END IF;
         IF line_rec_.c04 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('BASE_ITEM_DESC', line_rec_.c04, newattr_);
         END IF;
         IF line_rec_.c05 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('LANGUAGE_CODE', line_rec_.c05, newattr_);
         END IF;
         IF line_rec_.c06 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('CHARACTERISTIC_ID', line_rec_.c06, newattr_);
         END IF;
         IF line_rec_.c07 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('CHARACTERISTIC_ID_DESC', line_rec_.c07, newattr_);
         END IF;
         IF line_rec_.c08 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('CHARACTERISTIC_VALUE', line_rec_.c08, newattr_);
         END IF;
         IF line_rec_.c09 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('CHARACTERISTIC_VALUE_DESC', line_rec_.c09, newattr_);
         END IF;
         IF line_rec_.c10 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('CHARACTERISTIC_UOM', line_rec_.c10, newattr_);
         END IF;
         IF line_rec_.c11 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('CHARACTERISTIC_VALUE_TYPE', line_rec_.c11, newattr_);
         END IF;
         IF line_rec_.c12 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('CHARACTERISTIC_DATA_TYPE', line_rec_.c12, newattr_);
         END IF;
         IF line_rec_.c13 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('PACKAGE_CONTENT', line_rec_.c13, newattr_);
         END IF;
         IF line_rec_.n00 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('CONFIGURATION_ID', line_rec_.n00, newattr_);
         END IF;
         IF line_rec_.n01 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('SPEC_REVISION_NO', line_rec_.n01, newattr_);
         END IF;
         IF line_rec_.n02 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('QTY_OF_OPTION', line_rec_.n02, newattr_);
         END IF;
         -- Create new Char. option line
         Trace_SYS.Field('Transfer Customer Order Characteristic Option NewAttr', newattr_);
         External_Cust_Order_Char_API.New(newattr_);
      END IF;
   END LOOP;
   -- Set state of message in connectivity to 'Accepted' if it has been transferred
   -- to the CO External tables successfully.
   Connectivity_SYS.Accept_Message(message_id_);

   @ApproveTransactionStatement(2012-01-24,GanNLK)
   COMMIT;
   accept_message_ := TRUE;
  
   Approve_Receive_Cust_Order___(contract_, customer_no_, message_id_);
            
EXCEPTION
   WHEN others THEN
      -- Rollback to the last savepoint
      @ApproveTransactionStatement(2012-01-24,GanNLK)
      ROLLBACK;
      Fnd_Session_API.Reset_Fnd_User();
      Transaction_SYS.Set_Status_Info(sqlerrm);
      -- Reject messages
      IF NOT accept_message_ THEN
         Connectivity_SYS.Reject_Message(message_id_);
      END IF;
END Receive_Order;
   
PROCEDURE Receive_Order_Inet_Trans (
   orders_struct_       IN Ext_Cust_Ord_Struct_Rec   )
IS
   new_order_struct_    Ext_Cust_Ord_Struct_Rec;    
   accept_message_      BOOLEAN := FALSE;
BEGIN 
   IF Dictionary_SYS.Component_Is_Active('ITS') THEN
      new_order_struct_ := orders_struct_; 
      Create_Ext_Cust_Ord_Struct_Rec___(new_order_struct_);
      @ApproveTransactionStatement(2020-06-25,ChBnLK)
      COMMIT;
      -- Application message is processed correctly.
      accept_message_ := TRUE;
      Approve_Receive_Cust_Order___(new_order_struct_.contract, new_order_struct_.customer_no, new_order_struct_.message_id);
   ELSE
      Error_SYS.Record_General(lu_name_, 'NOITS: Component ITS need to be installed to proceed with this request.');
   END IF;   
EXCEPTION
   WHEN others THEN
      -- Rollback to the last savepoint
      @ApproveTransactionStatement(2020-06-25,ChBnLK)
      ROLLBACK;
      Fnd_Session_API.Reset_Fnd_User();
      -- Reject messages
      IF NOT accept_message_ THEN
         -- If get an error before message is processed correctly, it will appear on Application Message.
         RAISE;
      END IF;   
END Receive_Order_Inet_Trans;
   
      
-- Receive_Order_Change
--   Process an incoming ORDCHG message and transfer the incoming message
--   data to the ExternalCustOrderChange and ExtCustOrdLineChange LU's
PROCEDURE Receive_Order_Change (
   message_id_ IN NUMBER,
   b2b_process_online_ IN BOOLEAN DEFAULT FALSE)
IS
   attr_                   VARCHAR2(32000);  
   newattr_                VARCHAR2(32000);
   customer_no_            external_customer_order_tab.customer_no%TYPE := NULL;
   internal_customer_site_ external_customer_order_tab.internal_customer_site%TYPE := NULL;
   ord_chg_state_          VARCHAR2(2000);
   order_no_               VARCHAR2(2000);   
   language_               VARCHAR2(2000);
   internal_delivery_type_ VARCHAR2(20);
   delivery_terms_desc_    VARCHAR2(2000);
   ship_via_desc_          VARCHAR2(2000);
   route_id_               VARCHAR2(2000);
   delivery_leadtime_      NUMBER;
   sending_price_flag_     VARCHAR2(2000);
   sales_unit_price_       NUMBER;
   unit_price_incl_tax_    NUMBER;
   catalog_desc_           external_cust_order_line_tab.catalog_desc%TYPE;
   forward_agent_id_       EXTERNAL_CUSTOMER_ORDER_TAB.forward_agent_id%TYPE;
   internal_po_no_         VARCHAR2(2000);
   intrastat_exempt_db_    VARCHAR2(20);
   delivery_terms_         VARCHAR2(2000);
   ean_location_del_addr_  VARCHAR2(2000);
   deliver_to_customer_no_ EXTERNAL_CUSTOMER_ORDER_TAB.customer_no%TYPE;
   ship_addr_no_           CUSTOMER_ORDER_TAB.ship_addr_no%TYPE;
   gtin_no_                VARCHAR2(14);
   accept_message_         BOOLEAN := FALSE;
   picking_leadtime_       NUMBER;
   cust_calendar_id_       VARCHAR2(10);
   ext_trans_calendar_id_  VARCHAR2(10);
   contract_               VARCHAR2(2000);
   sender_                 VARCHAR2(255);
   receiver_               VARCHAR2(255);
   class_id_               VARCHAR2(30);
   sender_id_txt_          VARCHAR2(2000);
   sender_id_              NUMBER := NULL;
   sender_message_id_      VARCHAR2(255);
   customer_po_no_         EXTERNAL_CUSTOMER_ORDER_TAB.customer_po_no%TYPE;
   process_online_         BOOLEAN := FALSE;
   contact_                VARCHAR2(100);
   discount_               NUMBER;
   changed_attrib_not_in_pol_ VARCHAR2(5);
   currency_                  VARCHAR2(2000);
   internal_delivery_type_db_ VARCHAR2(20);
      
   CURSOR get_message_line IS
      SELECT *
      FROM   intersite_data_transfer_tmp
      WHERE  message_id = message_id_
      ORDER BY message_line;
BEGIN
   IF (Site_Discom_Info_API.Get_Exec_Ord_Change_Online_Db(Intersite_Data_Transfer_API.Get_Acquisition_Site(message_id_, 'ORDCHG')) = 'TRUE' OR b2b_process_online_) THEN
      process_online_ := TRUE;
   END IF;
   
   IF NOT process_online_ THEN
      Intersite_Data_Transfer_API.Delete_Intersite_Data_Tmp();
      -- Fill temporary table intersite_data_transfer_tmp
      Intersite_Data_Transfer_API.Fill_Intersite_Data_Tmp(message_id_);

      -- Get Message Head
      attr_ := Connectivity_SYS.Get_Message(message_id_);
      IF (attr_ IS NULL) THEN
         RETURN;
      END IF;
      Trace_SYS.Field('Message Head', attr_);
      sender_            := Client_SYS.Get_Item_Value('SENDER', attr_);
      receiver_          := Client_SYS.Get_Item_Value('RECEIVER', attr_);
      class_id_          := Client_SYS.Get_Item_Value('CLASS_ID', attr_);
      sender_id_txt_     := Client_SYS.Get_Item_Value('SENDER_ID', attr_);
      sender_message_id_ := Client_SYS.Get_Item_Value('SENDER_MESSAGE_ID', attr_);
      IF (class_id_ != 'ORDCHG') THEN
         RETURN;
      END IF;

      -- The sender_id_txt_ value is N/A for INET_TRANS type messages.
      -- Otherwise outbox message_id.
      IF (sender_id_txt_ != 'N/A') THEN
         BEGIN
            sender_id_ := TO_NUMBER(sender_id_txt_);
         EXCEPTION
            WHEN OTHERS THEN
               Error_SYS.Item_General(lu_name_, 'SENDER_ID', 'INVALFORMAT: Field [:NAME] must contain a numeric value. The value is: ":P1".', sender_id_txt_);
         END;
      END IF;
   END IF;

   -- Get all Message Rows
    FOR line_rec_ IN get_message_line LOOP
      IF (line_rec_.name = 'HEADER') THEN        
         Client_SYS.Clear_Attr(newattr_);  
         Trace_SYS.Field('Transfer Customer Order Head', attr_);
         Client_SYS.Clear_Attr(newattr_);
         delivery_terms_ := NULL;
         delivery_terms_desc_ := NULL;
         ean_location_del_addr_ := NULL;         
         Client_SYS.Set_Item_Value('MESSAGE_ID', line_rec_.message_id, newattr_);
         IF line_rec_.c00 IS NOT NULL THEN
            internal_po_no_   := line_rec_.c00;
         END IF;
         IF line_rec_.c01 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('CONTRACT', line_rec_.c01, newattr_);
            contract_ := line_rec_.c01;
         END IF;
         IF line_rec_.c06 IS NOT NULL THEN
            currency_   := line_rec_.c06;            
         END IF;
         IF line_rec_.c07 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('DELIVERY_ADDRESS_NAME', line_rec_.c07, newattr_);
         END IF;
         IF line_rec_.c08 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('SHIP_ADDRESS1', line_rec_.c08, newattr_);
         END IF;
         IF line_rec_.c09 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('SHIP_ADDRESS2', line_rec_.c09, newattr_);
         END IF;
         IF line_rec_.c57 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('SHIP_ADDRESS3', line_rec_.c57, newattr_);
         END IF;
         IF line_rec_.c58 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('SHIP_ADDRESS4', line_rec_.c58, newattr_);
         END IF;
         IF line_rec_.c59 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('SHIP_ADDRESS5', line_rec_.c59, newattr_);
         END IF;
         IF line_rec_.c60 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('SHIP_ADDRESS6', line_rec_.c60, newattr_);
         END IF;
         IF line_rec_.c10 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('SHIP_ZIP_CODE', line_rec_.c10, newattr_);
         END IF;
         IF line_rec_.c11 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('SHIP_CITY', line_rec_.c11, newattr_);
         END IF;
         IF line_rec_.c12 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('SHIP_STATE', line_rec_.c12, newattr_);
         END IF;
         IF line_rec_.c49 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('SHIP_COUNTY', line_rec_.c49, newattr_);
         END IF;
         IF line_rec_.c13 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('COUNTRY_CODE', line_rec_.c13, newattr_);
         END IF;
         IF line_rec_.c14 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('INTERNAL_REF', line_rec_.c14, newattr_);
         END IF;
         IF line_rec_.c15 IS NOT NULL THEN 
            delivery_terms_desc_ := line_rec_.c15;
         END IF;
         IF line_rec_.c16 IS NOT NULL THEN
            ship_via_desc_ := line_rec_.c16;
         END IF;
         IF line_rec_.c17 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('FORWARD_AGENT_ID', line_rec_.c17, newattr_);
         END IF;
         IF line_rec_.c18 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('LABEL_NOTE', line_rec_.c18, newattr_);
         END IF;
         IF line_rec_.c25 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('CUSTOMER_NO', line_rec_.c25, newattr_);
            customer_no_ := line_rec_.c25;
         END IF;
         IF line_rec_.c26 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('NOTE_TEXT', line_rec_.c26, newattr_);
         END IF;
         IF line_rec_.c33 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('EAN_LOCATION_DEL_ADDR', line_rec_.c33, newattr_);
            ean_location_del_addr_ := line_rec_.c33;
         END IF; 
         IF line_rec_.c34 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('EAN_LOCATION_DOC_ADDR', line_rec_.c34, newattr_);
         END IF;
         IF line_rec_.c35 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('CUSTOMER_NO_PAY', line_rec_.c35, newattr_);
         END IF;
         IF line_rec_.c36 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('EAN_LOCATION_PAYER_ADDR', line_rec_.c36, newattr_);
         END IF;
         IF line_rec_.c37 IS NOT NULL THEN
            IF (line_rec_.c37 = '4') THEN
               Client_SYS.Set_Item_Value('INTERNAL_DELIVERY_TYPE', 'INTER-SITE', newattr_);
               Client_SYS.Set_Item_Value('INTERNAL_PO_NO', line_rec_.c00, newattr_);
            END IF;
            internal_delivery_type_ := line_rec_.c37;
         END IF;
         IF line_rec_.c38 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('CUSTOMER_PO_NO', line_rec_.c38, newattr_);
            customer_po_no_ := line_rec_.c38;
         END IF;
         IF line_rec_.c39 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('INTERNAL_CUSTOMER_SITE', line_rec_.c39, newattr_);
            internal_customer_site_ := line_rec_.c39;
         END IF;
         IF line_rec_.c40 IS NOT NULL THEN
            order_no_ := line_rec_.c40;
         END IF;
         IF line_rec_.c41 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('PAY_TERM_ID', line_rec_.c41, newattr_);
         END IF;
         IF line_rec_.c42 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('DELIVERY_TERMS', line_rec_.c42, newattr_);
            delivery_terms_ := line_rec_.c42;
         END IF;
         IF line_rec_.c43 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('SHIP_VIA_CODE', line_rec_.c43, newattr_);
         END IF;
         IF line_rec_.c44 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('SALESMAN_CODE', line_rec_.c44, newattr_);
         END IF;
         IF line_rec_.c46 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('IMPORT_MODE', line_rec_.c46, newattr_);
         END IF;
         IF line_rec_.c47 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('EXTERNAL_REF', line_rec_.c47, newattr_);
         END IF;
         IF line_rec_.c48 IS NOT NULL THEN
            route_id_ := line_rec_.c48;
         END IF;
         IF line_rec_.c50 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('BACKORDER_OPTION_DB', line_rec_.c50, newattr_);
         END IF;
         IF line_rec_.c54 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('VAT_NO', line_rec_.c54, newattr_);
         END IF;
         IF line_rec_.c55 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('DEL_TERMS_LOCATION', line_rec_.c55, newattr_);
         END IF;
         IF line_rec_.c56 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('PRINT_DELIVERED_LINES_DB', line_rec_.c56, newattr_); 
         END IF;
         IF line_rec_.c61 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('CUST_REF', line_rec_.c61, newattr_);
         END IF;
         IF line_rec_.c85 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('INTERNAL_PO_LABEL_NOTE', line_rec_.c85, newattr_);
         END IF;
         IF line_rec_.d01 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('DELIVERY_DATE', line_rec_.d01, newattr_);
         END IF;
         IF line_rec_.n10 IS NOT NULL THEN
            delivery_leadtime_ := line_rec_.n10; 
         END IF;        
         IF line_rec_.n12 IS NOT NULL THEN
            picking_leadtime_ := line_rec_.n12; 
         END IF;
         
         -- B2b Process Online
         IF b2b_process_online_ THEN
            Client_SYS.Set_Item_Value('B2B_PROCESS_ONLINE_DB', Fnd_Boolean_API.DB_TRUE, newattr_);
            IF line_rec_.c82 IS NOT NULL THEN
               Client_SYS.Set_Item_Value('BILL_ADDR_NO', line_rec_.c82, newattr_);
            END IF;
            IF line_rec_.c83 IS NOT NULL THEN
               Client_SYS.Set_Item_Value('SHIP_ADDR_NO', line_rec_.c83, newattr_);
               ship_addr_no_ := line_rec_.c83;
            END IF;
         END IF;
         
        Get_Common_Receive_Header_Info___(customer_no_, language_,
                                  delivery_terms_desc_, customer_po_no_, 
                                  internal_delivery_type_, delivery_terms_, 
                                  internal_customer_site_, ean_location_del_addr_, internal_po_no_ ); 
         Get_Chg_Order_Header_Info___(order_no_, internal_customer_site_, customer_no_, customer_po_no_, internal_po_no_);
         Client_SYS.Set_Item_Value('CUSTOMER_NO', customer_no_, newattr_);        
         Client_SYS.Set_Item_Value('LANGUAGE_CODE', language_, newattr_);   
         Client_SYS.Set_Item_Value('CURRENCY_CODE', currency_, newattr_);
         Client_SYS.Set_Item_Value('CUSTOMER_PO_NO', customer_po_no_, newattr_);
         Client_SYS.Set_Item_Value('ORDER_NO', order_no_, newattr_);
         Client_SYS.Set_Item_Value('DELIVERY_TERMS_DESC', delivery_terms_desc_, newattr_);
          
         IF (contract_ IS NULL) THEN
            contract_ := Cust_Ord_Customer_API.Get_Edi_Site(customer_no_);
         END IF;

         IF (internal_delivery_type_ = '4') THEN            
            Client_SYS.Set_Item_Value('SHIP_VIA_DESC', ship_via_desc_, newattr_);            
            Client_SYS.Set_Item_Value('PICKING_LEADTIME', picking_leadtime_, newattr_);
            Client_SYS.Set_Item_Value('ROUTE_ID', route_id_, newattr_);
         END IF;
         Client_SYS.Set_Item_Value('SAME_DATABASE_DB', Get_Same_Database___(sender_, receiver_, class_id_, sender_id_, sender_message_id_), newattr_);
     
         Add_Org_Header_Values___(newattr_, order_no_, internal_delivery_type_, b2b_process_online_);
         Ext_Cust_Order_Change_API.New(newattr_);
      END IF;

      IF (line_rec_.name = 'ROW') THEN  

         Client_SYS.Clear_Attr(newattr_);        
         Client_SYS.Set_Item_Value('MESSAGE_ID', line_rec_.message_id, newattr_);
         Client_SYS.Set_Item_Value('MESSAGE_LINE', line_rec_.message_line, newattr_);

         delivery_terms_         := NULL;
         delivery_terms_desc_    := NULL;
         ean_location_del_addr_  := NULL;
         ship_addr_no_           := NULL;
         route_id_               := NULL;
         sales_unit_price_       := NULL;
         unit_price_incl_tax_    := NULL;
         catalog_desc_           := NULL;
         discount_               := NULL;
         sending_price_flag_     := NULL;
         
         IF line_rec_.c01 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('LINE_NO', line_rec_.c01, newattr_);
         END IF;
         IF line_rec_.c02 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('REL_NO', line_rec_.c02, newattr_);
         END IF;
         IF line_rec_.c03 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('CUSTOMER_PART_NO', line_rec_.c03, newattr_);
         END IF;
         IF line_rec_.c04 IS NOT NULL THEN
            catalog_desc_ := line_rec_.c04;
         END IF;
         IF line_rec_.c09 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('CATALOG_NO', line_rec_.c09, newattr_);
         END IF;
         IF line_rec_.c11 IS NOT NULL THEN       
            Client_SYS.Set_Item_Value('NOTES', line_rec_.c11, newattr_);
         END IF;
         IF line_rec_.c15 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('ORD_CHG_STATE', line_rec_.c15, newattr_);
            ord_chg_state_ := line_rec_.c15;
         END IF;
         IF line_rec_.c16 IS NOT NULL THEN
            sending_price_flag_ := line_rec_.c16;
         END IF;
         IF line_rec_.c17 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('DELIVERY_ADDRESS_NAME', line_rec_.c17, newattr_);
         END IF;
         IF line_rec_.c18 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('SHIP_ADDRESS1', line_rec_.c18, newattr_);
         END IF;
         IF line_rec_.c19 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('SHIP_ADDRESS2', line_rec_.c19, newattr_);
         END IF;
         IF line_rec_.c78 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('SHIP_ADDRESS3', line_rec_.c78, newattr_);
         END IF;
         IF line_rec_.c79 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('SHIP_ADDRESS4', line_rec_.c79, newattr_);
         END IF;
         IF line_rec_.c80 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('SHIP_ADDRESS5', line_rec_.c80, newattr_);
         END IF;
         IF line_rec_.c81 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('SHIP_ADDRESS6', line_rec_.c81, newattr_);
         END IF;
         IF line_rec_.c20 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('SHIP_ZIP_CODE', line_rec_.c20, newattr_);
         END IF;
         IF line_rec_.c21 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('SHIP_CITY', line_rec_.c21, newattr_);
         END IF;
         IF line_rec_.c22 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('SHIP_STATE', line_rec_.c22, newattr_);
         END IF;
         IF line_rec_.c49 IS NOT NULL THEN   
            Client_SYS.Set_Item_Value('SHIP_COUNTY', line_rec_.c49, newattr_);
         END IF;
         IF line_rec_.c23 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('COUNTRY_CODE', line_rec_.c23, newattr_);
         END IF;
         IF line_rec_.c24 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('DELIVERY_TERMS', line_rec_.c24, newattr_);
            delivery_terms_ := line_rec_.c24;
         END IF;
         IF line_rec_.c25 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('DELIVERY_TERMS_DESC', line_rec_.c25, newattr_);
            delivery_terms_desc_ := line_rec_.c25;
         END IF;
         IF line_rec_.c26 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('SHIP_VIA_CODE', line_rec_.c26, newattr_);
         END IF;
         IF line_rec_.c27 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('SHIP_VIA_DESC', line_rec_.c27, newattr_);
         END IF;
         IF line_rec_.c28 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('EAN_LOCATION_DEL_ADDR', line_rec_.c28, newattr_);
            ean_location_del_addr_ := line_rec_.c28;
         END IF;      
         IF line_rec_.c29 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('ROUTE_ID', line_rec_.c29, newattr_);
            route_id_ := line_rec_.c29;
         END IF;
         IF line_rec_.c30 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('FORWARD_AGENT_ID', line_rec_.c30, newattr_);
            forward_agent_id_ := line_rec_.c30;
         END IF;
         IF line_rec_.c32 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('CUSTOMER_PO_LINE_NO', line_rec_.c32, newattr_);
         END IF;
         IF line_rec_.c33 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('CUSTOMER_PO_REL_NO', line_rec_.c33, newattr_);
         END IF;
         IF line_rec_.c44 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('VAT_NO', line_rec_.c44, newattr_);
         END IF;
         IF line_rec_.c45 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('VAT_FREE_VAT_CODE', line_rec_.c45, newattr_);
         END IF;
         IF line_rec_.c46 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('TAX_LIABILITY', line_rec_.c46, newattr_);
         END IF;
         IF line_rec_.c55 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('CONDITION_CODE', line_rec_.c55, newattr_);
         END IF;
         IF line_rec_.n10 IS NOT NULL THEN
            delivery_leadtime_ := line_rec_.n10;
         END IF;
         IF line_rec_.c37 IS NOT NULL THEN
            internal_delivery_type_ := line_rec_.c37;
         END IF;
         IF line_rec_.c51 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('DOCK_CODE', line_rec_.c51, newattr_);
         END IF;
         IF line_rec_.c52 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('SUB_DOCK_CODE', line_rec_.c52, newattr_);
         END IF;
         IF line_rec_.c53 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('LOCATION', line_rec_.c53, newattr_);
         END IF;
         IF line_rec_.c56 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('DELIVER_TO_CUSTOMER_NO', line_rec_.c56, newattr_);
            deliver_to_customer_no_ := line_rec_.c56;
         END IF;
         IF line_rec_.c57 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('DISTRICT_CODE', line_rec_.c57, newattr_);
         END IF;
         IF line_rec_.c58 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('REGION_CODE', line_rec_.c58, newattr_);
         END IF;
         IF line_rec_.c59 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('CONTACT', line_rec_.c59, newattr_);
            contact_ := line_rec_.c59;
         END IF;
         IF line_rec_.c60 IS NOT NULL THEN
            intrastat_exempt_db_ := line_rec_.c60;
         END IF;
         IF line_rec_.c62 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('RENTAL_TRANSFER_DB', line_rec_.c62, newattr_);
         END IF;
         IF line_rec_.c63 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('DEL_TERMS_LOCATION', line_rec_.c63, newattr_);
         END IF;
         IF line_rec_.c64 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('CLASSIFICATION_STANDARD', line_rec_.c64, newattr_);
         END IF;
         IF line_rec_.c65 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('CLASSIFICATION_PART_NO', line_rec_.c65, newattr_);
         END IF;
         IF line_rec_.c66 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('CLASSIFICATION_UNIT_MEAS', line_rec_.c66, newattr_);
         END IF;
         IF line_rec_.c67 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('GTIN_NO', line_rec_.c67, newattr_);
            gtin_no_ := line_rec_.c67;
         END IF;
         IF line_rec_.c69 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('PACKING_INSTRUCTION_ID', line_rec_.c69, newattr_);
         END IF;
         IF line_rec_.c70 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('ORIGINATING_CO_LANG_CODE', line_rec_.c70, newattr_); 
         END IF;
         IF line_rec_.c71 IS NOT NULL THEN
            cust_calendar_id_ := line_rec_.c71; 
         END IF;
         IF line_rec_.c72 IS NOT NULL THEN
            ext_trans_calendar_id_ := line_rec_.c72; 
         END IF;
         IF line_rec_.c73 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('SHIPMENT_TYPE', line_rec_.c73, newattr_);
         END IF;
         IF line_rec_.c75 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('SHIPMENT_CREATION_DB', line_rec_.c75, newattr_); 
         END IF;
         IF line_rec_.c76 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('CHANGED_ATTRIB_NOT_IN_POL', line_rec_.c76, newattr_);
            changed_attrib_not_in_pol_ := line_rec_.c76;
         END IF;
         IF line_rec_.d00 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('WANTED_DELIVERY_DATE', line_rec_.d00, newattr_);
         END IF;
         IF line_rec_.d05 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('ORIGINAL_PLAN_DELIV_DATE', line_rec_.d05, newattr_);
         END IF;
         IF line_rec_.d06 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('RENTAL_DB', Fnd_Boolean_API.DB_TRUE, newattr_);            
            Client_SYS.Set_Item_Value('PLANNED_RENTAL_START_DATE', line_rec_.d06, newattr_);
            Client_SYS.Set_Item_Value('ORIGINAL_RENTAL_START_DATE', line_rec_.d06, newattr_);
         END IF;  
         IF line_rec_.d07 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('PLANNED_RENTAL_END_DATE', line_rec_.d07, newattr_);
            Client_SYS.Set_Item_Value('ORIGINAL_RENTAL_END_DATE', line_rec_.d07, newattr_);
         END IF;
         IF line_rec_.d08 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('TAX_ID_VALIDATED_DATE', line_rec_.d08, newattr_);
         END IF; 
         IF line_rec_.n00 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('BUY_QTY_DUE', line_rec_.n00, newattr_);
            Client_SYS.Set_Item_Value('ORIGINAL_BUY_QTY_DUE', line_rec_.n00, newattr_);
         END IF;
         IF line_rec_.n02 IS NOT NULL THEN
            sales_unit_price_ := line_rec_.n02;
         END IF;
         IF line_rec_.n06 IS NOT NULL THEN
               discount_ := line_rec_.n06;
         END IF;
         IF line_rec_.n13 IS NOT NULL THEN
            unit_price_incl_tax_ := line_rec_.n13;
         END IF;
         IF line_rec_.n09 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('CUSTOMER_QUANTITY', line_rec_.n09, newattr_);
         END IF;
         IF line_rec_.n11 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('INPUT_QTY', line_rec_.n11, newattr_);
         END IF;
         IF line_rec_.n12 IS NOT NULL THEN
            picking_leadtime_ := line_rec_.n12;
         END IF;         
         IF line_rec_.c74 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('CONFIGURATION_ID', line_rec_.c74, newattr_);
         END IF; 
         IF line_rec_.c77 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('VENDOR_PART_DESC', line_rec_.c77, newattr_);
         END IF;      
         
         IF b2b_process_online_ THEN
            Client_SYS.Set_Item_Value('B2B_PROCESS_ONLINE_DB', Fnd_Boolean_API.DB_TRUE, newattr_);
            IF line_rec_.c83 IS NOT NULL THEN
               Client_SYS.Set_Item_Value('SHIP_ADDR_NO', line_rec_.c83, newattr_);
               ship_addr_no_ := line_rec_.c83;
            END IF;
         END IF;
         
         
         IF (internal_delivery_type_ = '3') THEN
            Client_SYS.Set_Item_Value('FORWARD_AGENT_ID', forward_agent_id_, newattr_);
            Client_SYS.Set_Item_Value('DELIVERY_LEADTIME', delivery_leadtime_, newattr_);
            Client_SYS.Set_Item_Value('ROUTE_ID', route_id_, newattr_);
            Client_SYS.Set_Item_Value('INTRASTAT_EXEMPT_DB', intrastat_exempt_db_, newattr_);
            Client_SYS.Set_Item_Value('PICKING_LEADTIME', picking_leadtime_, newattr_);
            Client_SYS.Set_Item_Value('CUST_CALENDAR_ID', cust_calendar_id_, newattr_);
            Client_SYS.Set_Item_Value('EXT_TRANSPORT_CALENDAR_ID', ext_trans_calendar_id_, newattr_);
            Client_SYS.Set_Item_Value('CHANGED_ATTRIB_NOT_IN_POL', changed_attrib_not_in_pol_, newattr_);
         END IF;

         IF (internal_delivery_type_ = '4') THEN
            Client_SYS.Set_Item_Value('DELIVERY_LEADTIME', delivery_leadtime_, newattr_);
            Client_SYS.Set_Item_Value('PICKING_LEADTIME', picking_leadtime_, newattr_);
         END IF;         

         IF ( sending_price_flag_ IS NOT NULL AND sending_price_flag_ = 'SENDPRICE' ) THEN
            Client_SYS.Set_Item_Value('SALE_UNIT_PRICE', sales_unit_price_, newattr_);
            Client_SYS.Set_Item_Value('UNIT_PRICE_INCL_TAX', unit_price_incl_tax_, newattr_);
            Client_SYS.Set_Item_Value('CATALOG_DESC', catalog_desc_, newattr_);
            Client_SYS.Set_Item_Value('DISCOUNT', NVL(discount_, 0), newattr_);
         END IF;
         
         internal_delivery_type_db_ := internal_delivery_type_;
         Get_Data_Receive_Cust_Order_Line___(internal_delivery_type_db_, delivery_terms_desc_,                                           
                                         deliver_to_customer_no_, delivery_terms_);
      
         Client_SYS.Set_Item_Value('INTERNAL_DELIVERY_TYPE_DB', internal_delivery_type_db_, newattr_);
         Client_SYS.Set_Item_Value('DELIVERY_TERMS_DESC', delivery_terms_desc_, newattr_);
        
         -- Create new Ext Cust Order Change Line (Detail)
         Trace_SYS.Field('Transfer Customer Order Row NewAttr', newattr_);
         IF ord_chg_state_ IN ('CHANGED', 'NOT AMENDED') THEN
            Add_Org_Line_Values__(newattr_, order_no_, b2b_process_online_);
         END IF;
         Ext_Cust_Order_Line_Change_API.New(newattr_);
      END IF;

       IF (line_rec_.name = 'CONFIGROW') THEN        
         Client_SYS.Clear_Attr(newattr_);
         Client_SYS.Set_Item_Value('MESSAGE_ID', line_rec_.message_id, newattr_);
         Client_SYS.Set_Item_Value('MESSAGE_LINE', line_rec_.message_line, newattr_);
         IF line_rec_.c01 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('LINE_NO', line_rec_.c01, newattr_);
         END IF;
         IF line_rec_.c02 IS NOT NULL THEN 
            Client_SYS.Set_Item_Value('REL_NO', line_rec_.c02, newattr_);
         END IF;
         IF line_rec_.c03 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('CUSTOMER_PART_NO', line_rec_.c03, newattr_);
         END IF;
         IF line_rec_.c04 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('CATALOG_DESC', line_rec_.c04, newattr_);
         END IF;
         IF line_rec_.c09 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('CATALOG_NO', line_rec_.c09, newattr_);
         END IF;
         IF line_rec_.c11 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('NOTES', line_rec_.c11, newattr_);
         END IF;
         IF line_rec_.c15 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('ORD_CHG_STATE', line_rec_.c15, newattr_);
            ord_chg_state_ := line_rec_.c15;
         END IF;
         IF line_rec_.c17 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('DELIVERY_ADDRESS_NAME', line_rec_.c17, newattr_);
         END IF;
         IF line_rec_.c18 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('SHIP_ADDRESS1', line_rec_.c18, newattr_);
         END IF;
         IF line_rec_.c19 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('SHIP_ADDRESS2', line_rec_.c19, newattr_);
         END IF;
         IF line_rec_.c60 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('SHIP_ADDRESS3', line_rec_.c60, newattr_);
         END IF;
         IF line_rec_.c61 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('SHIP_ADDRESS4', line_rec_.c61, newattr_);
         END IF;
         IF line_rec_.c62 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('SHIP_ADDRESS5', line_rec_.c62, newattr_);
         END IF;
         IF line_rec_.c63 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('SHIP_ADDRESS6', line_rec_.c63, newattr_);
         END IF;
         IF line_rec_.c20 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('SHIP_ZIP_CODE', line_rec_.c20, newattr_);
         END IF;
         IF line_rec_.c21 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('SHIP_CITY', line_rec_.c21, newattr_);
         END IF;
         IF line_rec_.c22 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('SHIP_STATE', line_rec_.c22, newattr_);
         END IF;
         IF line_rec_.c23 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('COUNTRY_CODE', line_rec_.c23, newattr_);
         END IF;
         IF line_rec_.c49 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('SHIP_COUNTY', line_rec_.c49, newattr_);
         END IF;
         IF line_rec_.c24 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('DELIVERY_TERMS', line_rec_.c24, newattr_);
         END IF;
         IF line_rec_.c26 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('SHIP_VIA_CODE', line_rec_.c26, newattr_);
         END IF;
         IF line_rec_.c28 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('EAN_LOCATION_DEL_ADDR', line_rec_.c28, newattr_);
         END IF;
         IF line_rec_.c25 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('DELIVERY_TERMS_DESC', line_rec_.c25, newattr_);
         END IF;
         IF line_rec_.c27 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('SHIP_VIA_DESC', line_rec_.c27, newattr_);
         END IF;
         IF line_rec_.c56 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('DELIVER_TO_CUSTOMER_NO', line_rec_.c56, newattr_);
         END IF;
         IF line_rec_.c59 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('CONTACT', line_rec_.c59, newattr_);
         END IF;
         IF line_rec_.d00 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('WANTED_DELIVERY_DATE', line_rec_.d00, newattr_);
         END IF;
         IF line_rec_.d05 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('ORIGINAL_PLAN_DELIV_DATE', line_rec_.d05, newattr_);
         END IF;
         IF line_rec_.n00 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('BUY_QTY_DUE', line_rec_.n00, newattr_);
         END IF;
         IF line_rec_.n02 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('SALE_UNIT_PRICE', line_rec_.n02, newattr_);
         END IF;
         IF line_rec_.n06 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('DISCOUNT', line_rec_.n06, newattr_);
         END IF;
         IF line_rec_.n09 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('CUSTOMER_QUANTITY', line_rec_.n09, newattr_);
         END IF;
         
         -- Create new Customer Order Line (Detail)
         Trace_SYS.Field('Transfer Customer Order Row NewAttr', newattr_);
         IF ord_chg_state_ IN ('CHANGED', 'NOT AMENDED') THEN
            Add_Org_Line_Values__(newattr_, order_no_);
         END IF;
         Ext_Cust_Order_Line_Change_API.New(newattr_);
      END IF;

      IF (line_rec_.name = 'CHARROW') THEN         
         Client_SYS.Clear_Attr(newattr_);
         Client_SYS.Set_Item_Value('MESSAGE_ID', line_rec_.message_id, newattr_);
         Client_SYS.Set_Item_Value('MESSAGE_LINE', line_rec_.message_line, newattr_);
         IF line_rec_.c01 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('LINE_NO', line_rec_.c01, newattr_);
         END IF;
         IF line_rec_.c02 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('RELEASE_NO', line_rec_.c02, newattr_);
         END IF;
         IF line_rec_.c03 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('BASE_ITEM_NO', line_rec_.c03, newattr_);
         END IF;
         IF line_rec_.c04 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('BASE_ITEM_DESC', line_rec_.c04, newattr_);
         END IF;
         IF line_rec_.c05 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('LANGUAGE_CODE', line_rec_.c05, newattr_);
         END IF;
         IF line_rec_.c06 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('CHARACTERISTIC_ID', line_rec_.c06, newattr_);
         END IF;
         IF line_rec_.c07 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('CHARACTERISTIC_ID_DESC', line_rec_.c07, newattr_);
         END IF;
         IF line_rec_.c08 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('CHARACTERISTIC_VALUE', line_rec_.c08, newattr_);
         END IF;
         IF line_rec_.c09 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('CHARACTERISTIC_VALUE_DESC', line_rec_.c09, newattr_);
         END IF;
         IF line_rec_.c10 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('CHARACTERISTIC_UOM', line_rec_.c10, newattr_);
         END IF;
         IF line_rec_.c11 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('CHARACTERISTIC_VALUE_TYPE', line_rec_.c11, newattr_);
         END IF;
         IF line_rec_.c12 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('CHARACTERISTIC_DATA_TYPE', line_rec_.c12, newattr_);
         END IF;
         IF line_rec_.n00 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('CONFIGURATION_ID', line_rec_.n00, newattr_);
         END IF;
         IF line_rec_.n01 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('SPEC_REVISION_NO', line_rec_.n01, newattr_);
         END IF;
         IF line_rec_.n02 IS NOT NULL THEN
            Client_SYS.Set_Item_Value('QTY_OF_OPTION', line_rec_.n02, newattr_);
         END IF;
          
         -- Create new Char. option line
         Trace_SYS.Field('Transfer Customer Order Characteristic Option NewAttr', newattr_);
         Ext_Cust_Order_Char_Change_API.New(newattr_);
      END IF;
   END LOOP;
   
   IF NOT process_online_ THEN
      Connectivity_SYS.Accept_Message(message_id_);

      @ApproveTransactionStatement(2012-01-24,GanNLK)
      COMMIT;
      accept_message_ := TRUE;
   END IF;
      
   Approve_Receive_Change_Order___(message_id_, contract_, customer_no_, process_online_);
   
EXCEPTION
   WHEN others THEN
      IF process_online_ THEN
         RAISE;
      ELSE
         -- Rollback to the last savepoint
         @ApproveTransactionStatement(2012-01-24,GanNLK)
         ROLLBACK;
         Fnd_Session_API.Reset_Fnd_User();
         Transaction_SYS.Set_Status_Info(sqlerrm);
         -- Reject messages
         IF NOT accept_message_ THEN
            Connectivity_SYS.Reject_Message(message_id_);
         END IF;
      END IF;
END Receive_Order_Change;


-- Receive_Order_Chg_Inet_Trans
-- Used when receiving the customer order change request in Inet-Trans.
PROCEDURE Receive_Order_Chg_Inet_Trans (
   chg_orders_struct_       IN Ext_Cust_Ord_Change_Struct_Rec   )
IS
   new_chg_ord_struct_      Ext_Cust_Ord_Change_Struct_Rec; 
   contract_                VARCHAR2(2000);
   accept_message_          BOOLEAN := FALSE;
BEGIN 
   IF Dictionary_SYS.Component_Is_Active('ITS') THEN
      new_chg_ord_struct_ := chg_orders_struct_;       
      Create_Ext_Cust_Ord_Change_Struct_Rec___(new_chg_ord_struct_);
      @ApproveTransactionStatement(2020-06-25,ChBnLK)
      COMMIT;
      -- Application message is processed correctly.
      accept_message_ := TRUE;
      contract_   := new_chg_ord_struct_.contract;
      IF contract_ IS NULL THEN
         contract_ := Cust_Ord_Customer_API.Get_Edi_Site(new_chg_ord_struct_.customer_no);
      END IF;
      Approve_Receive_Change_Order___(new_chg_ord_struct_.message_id, contract_, new_chg_ord_struct_.customer_no, FALSE);
   ELSE
      Error_SYS.Record_General(lu_name_, 'NOITS: Component ITS need to be installed to proceed with this request.');
   END IF;
EXCEPTION
   WHEN others THEN
      -- Rollback to the last savepoint
      @ApproveTransactionStatement(2020-06-25,ChBnLK)
      ROLLBACK;
      Fnd_Session_API.Reset_Fnd_User();
      
      IF NOT accept_message_ THEN
         -- If get an error before message is processed correctly, it will appear on Application Message.
         RAISE;
      END IF; 
END Receive_Order_Chg_Inet_Trans;


-- Send_Order_Confirmation
--   Generate an order response (ORDERSP) EDI/MHS/ITS message for the specified order.
PROCEDURE Send_Order_Confirmation (
   order_no_   IN VARCHAR2,
   media_code_ IN VARCHAR2 )
IS
BEGIN
   Send_Order_Confirmation_Msg_API.Send_Order_Confirmation(order_no_, media_code_);
END Send_Order_Confirmation;


-- Send_Direct_Delivery
--   Generate a internal direct delivery (DIRDEL) EDI/MHS message for
--   the specified order.
--   Note that value for multiple_messages_ becomes 'TRUE' when more
--   than one message sending while finalizing a shipment.
PROCEDURE Send_Direct_Delivery (
   delnote_no_        IN VARCHAR2,
   order_no_          IN VARCHAR2,
   media_code_        IN VARCHAR2,
   session_id_        IN NUMBER, 
   multiple_messages_ IN VARCHAR2 DEFAULT 'FALSE' )
IS
   attr_                    VARCHAR2(32000);
   message_id_              NUMBER;
   message_line_            NUMBER;
   message_type_            VARCHAR2(30);
   message_name_            VARCHAR2(255);
   customer_po_no_          VARCHAR2(50);
   receiver_address_        VARCHAR2(2000);
   sender_address_          VARCHAR2(2000);
   addr_id_                 VARCHAR2(50);
   company_country_         VARCHAR2(35);
   postal_address_          VARCHAR2(2000);
   ean_del_addr_            VARCHAR2(2000);
   ean_doc_addr_            VARCHAR2(2000);
   ean_pay_addr_            VARCHAR2(2000);
   agreement_note_id_       NUMBER;
   delnote_date_            DATE;
   qty_delivered_           NUMBER;
   salesman_name_           VARCHAR2(100);
   authorize_name_          VARCHAR2(100);
   company_                 VARCHAR2(20);
   price_unit_meas_         VARCHAR2(10);
   address_id_              CUST_ORD_CUSTOMER_ADDRESS_PUB.addr_no%TYPE;
   acquisition_site_        VARCHAR2(5);
   delnote_state_           VARCHAR2(20);
   catch_qty_delivered_     NUMBER;
   address_rec_             Customer_Order_Address_API.Cust_Ord_Addr_Rec;
   sequence_no_             NUMBER;
   version_no_              NUMBER;
   cross_ref_rec_           Cust_Addr_Cross_reference_API.Public_Rec;
   alt_delnote_no_          VARCHAR2(50);
   cust_ord_del_note_rec_   Delivery_Note_API.Public_Rec;
   deliver_to_customer_no_  VARCHAR2(20);
   delivery_country_db_     CUSTOMER_INFO_ADDRESS_TAB.country%TYPE;
   co_line_rec_             Customer_Order_Line_API.Public_Rec;
   log_co_history_          BOOLEAN:= FALSE;
   cust_order_delivery_rec_ Customer_Order_Delivery_API.Public_Rec;
   deliv_no_                NUMBER;
   pay_term_desc_           VARCHAR2(100);
   
   CURSOR get_order_info IS
      SELECT order_no, customer_no, contract, internal_po_no, customer_po_no,
             salesman_code,
             authorize_code,
             date_entered,
             bill_addr_no, currency_code, customer_no_pay,
             customer_no_pay_addr_no, cust_ref, pay_term_id, delivery_terms,
             wanted_delivery_date, delivery_leadtime, ship_via_code, forward_agent_id,
             label_note, language_code, note_id, agreement_id, ship_addr_no
        FROM customer_order_tab
       WHERE order_no = order_no_;
   ordrec_            get_order_info%ROWTYPE;

   CURSOR get_line_info IS
      SELECT order_no, line_no, rel_no, line_item_no, catalog_no, catalog_desc,
             buy_qty_due, (qty_shipped/conv_factor * inverted_conv_factor) qty_shipped, sales_unit_meas,
             contract,
             conv_factor, inverted_conv_factor, price_conv_factor, planned_delivery_date, rowstate, note_id,
             customer_part_no, customer_part_buy_qty, customer_part_unit_meas
        FROM customer_order_line_tab
       WHERE order_no      = order_no_
         AND rowstate NOT IN ('Delivered', 'Invoiced', 'Cancelled')
         AND line_item_no <= 0
         AND qty_shipped  >  0
   UNION
      SELECT order_no, line_no, rel_no, line_item_no, catalog_no, catalog_desc,
             buy_qty_due, (qty_shipped/conv_factor * inverted_conv_factor) qty_shipped, sales_unit_meas,
             contract,
             conv_factor, inverted_conv_factor, price_conv_factor, planned_delivery_date, rowstate, note_id,
             customer_part_no, customer_part_buy_qty, customer_part_unit_meas
        FROM customer_order_line_tab col
       WHERE order_no = order_no_
         AND qty_shipped > 0
         AND EXISTS (SELECT 1
                         FROM customer_order_delivery_tab cod
                        WHERE order_no         = order_no_
                          AND cod.line_no      = col.line_no
                          AND cod.rel_no       = col.rel_no
                          AND cod.line_item_no = col.line_item_no
                          AND cod.delnote_no   = delnote_no_
                          AND cod.cancelled_delivery = 'FALSE')
         AND line_item_no <= 0
       ORDER BY 1, 2, 3;
       
   CURSOR get_mul_tier_line_info IS
      SELECT line_no, rel_no, line_item_no, SUM(quantity_delivered) quantity_delivered, SUM(catch_qty_delivered) catch_qty_delivered
        FROM temporary_mul_tier_dirdel_tab
       WHERE session_id = session_id_
       AND   order_no   = order_no_
       GROUP BY line_no, rel_no, line_item_no;
       
   CURSOR get_deliv_no(line_no_ VARCHAR2, rel_no_ VARCHAR2, line_item_no_ NUMBER) IS
      SELECT deliv_no   
        FROM temporary_mul_tier_dirdel_tab
       WHERE session_id   = session_id_
         AND order_no     = order_no_
         AND line_no      = line_no_
         AND rel_no       = rel_no_
         AND line_item_no = line_item_no_;    

   CURSOR get_transit_row_info (line_no_ VARCHAR2, rel_no_ VARCHAR2, line_item_no_ NUMBER) IS
      SELECT p.configuration_id, p.lot_batch_no, p.serial_no, p.waiv_dev_rej_no, p.eng_chg_level, p.handling_unit_id,
             p.part_no, p.expiration_date, SUM(p.qty_shipped) qty_shipped, SUM(p.catch_qty_shipped) catch_qty_shipped
        FROM customer_order_delivery_tab t, customer_order_reservation_tab p
       WHERE t.delnote_no   = delnote_no_
         AND t.line_item_no = p.line_item_no
         AND t.rel_no       = p.rel_no
         AND t.line_no      = p.line_no
         AND t.order_no     = p.order_no
         AND t.deliv_no     = p.deliv_no
         AND p.order_no     = order_no_
         AND p.line_no      = line_no_
         AND p.rel_no       = rel_no_
         AND p.line_item_no = line_item_no_
         AND t.cancelled_delivery = 'FALSE'
      GROUP BY p.configuration_id, p.lot_batch_no, p.serial_no, p.waiv_dev_rej_no, p.eng_chg_level, p.handling_unit_id, p.part_no, p.expiration_date;
      
   CURSOR get_mul_tier_transit_row_info (line_no_ VARCHAR2, rel_no_ VARCHAR2, line_item_no_ NUMBER) IS
      SELECT configuration_id, lot_batch_no, serial_no, waiv_dev_rej_no, eng_chg_level, handling_unit_id,
             expiration_date, SUM(quantity_delivered) quantity_delivered, SUM(catch_qty_delivered) catch_qty_delivered
        FROM temporary_mul_tier_dirdel_tab
       WHERE session_id   = session_id_
         AND order_no     = order_no_ 
         AND line_no      = line_no_
         AND rel_no       = rel_no_
         AND line_item_no = line_item_no_
       GROUP BY configuration_id, lot_batch_no, serial_no, waiv_dev_rej_no, eng_chg_level, handling_unit_id, expiration_date;   
BEGIN
   message_type_ := 'DIRDEL';

   -- Retrieve company info
   OPEN  get_order_info;
   FETCH get_order_info INTO ordrec_;
   CLOSE get_order_info;

   IF (delnote_no_ IS NOT NULL) THEN
      cust_ord_del_note_rec_  := Delivery_Note_API.Get(delnote_no_);
      delnote_date_           := cust_ord_del_note_rec_.create_date;
      deliver_to_customer_no_ := cust_ord_del_note_rec_.receiver_id;
   END IF;

   salesman_name_          := Sales_Part_Salesman_API.Get_Name(ordrec_.salesman_code);
   authorize_name_         := Order_Coordinator_API.Get_Name(ordrec_.authorize_code);
   company_                := Site_API.Get_Company(ordrec_.contract);
   receiver_address_       := Customer_Info_Msg_Setup_API.Get_Address(ordrec_.customer_no, media_code_, message_type_);
   acquisition_site_       := Cust_Ord_Customer_API.Get_Acquisition_Site(ordrec_.customer_no);
   pay_term_desc_ := Payment_Term_API.Get_Description(company_,ordrec_.pay_term_id );
   
   -- Retrieve postal address of company (recipient) from Enterprise
   sender_address_         := Company_Msg_Setup_API.Get_Address(company_, media_code_, message_type_);

   -- Create OUT_MESSAGE
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('CLASS_ID',                message_type_,       attr_);
   Client_SYS.Add_To_Attr('MEDIA_CODE',              media_code_,         attr_);
   Client_SYS.Add_To_Attr('RECEIVER',                receiver_address_,   attr_);
   Client_SYS.Add_To_Attr('SENDER',                  sender_address_,     attr_);
   Client_SYS.Add_To_Attr('APPLICATION_MESSAGE_ID',  ordrec_.order_no,    attr_);
   Client_SYS.Add_To_Attr('APPLICATION_RECEIVER_ID', ordrec_.customer_no, attr_);

   Connectivity_SYS.Create_Message(message_id_, attr_);

   -- Set customer's po number - check if internal order
   IF (ordrec_.internal_po_no IS NOT NULL) THEN
      customer_po_no_ := ordrec_.internal_po_no;
   ELSE
      customer_po_no_ := ordrec_.customer_po_no;
   END IF;

   Trace_SYS.Message('Creating message HEADER');
   -- Create OUT_MESSAGE_LINE (for header)
   delivery_country_db_ := Customer_Info_Address_API.Get_Delivery_Country_Db(ordrec_.customer_no);
   message_name_        := 'HEADER';
   message_line_        := 1;
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('MESSAGE_ID',   message_id_,           attr_);
   Client_SYS.Add_To_Attr('MESSAGE_LINE', message_line_,         attr_);
   Client_SYS.Add_To_Attr('NAME',         message_name_,         attr_);
   Client_SYS.Add_To_Attr('C00',          ordrec_.order_no,      attr_);
   Client_SYS.Add_To_Attr('C01',          customer_po_no_,       attr_);
   Client_SYS.Add_To_Attr('C02',          acquisition_site_,     attr_);
   Client_SYS.Add_To_Attr('C03',          salesman_name_,        attr_);
   Client_SYS.Add_To_Attr('C04',          authorize_name_,       attr_);
   Client_SYS.Add_To_Attr('C05',          ordrec_.customer_no,   attr_);
   Client_SYS.Add_To_Attr('C06',          (Customer_Document_Tax_Info_API.Default_Vat_No(ordrec_.customer_no, company_, Company_API.Get_Country_Db(company_), delivery_country_db_, SYSDATE)), attr_);
   Client_SYS.Add_To_Attr('C07',          ordrec_.bill_addr_no,  attr_);
   Client_SYS.Add_to_Attr('C08',          ordrec_.currency_code, attr_);

   address_rec_ := Customer_Order_Address_API.Get_Cust_Ord_Addr(ordrec_.order_no);
   Client_SYS.Add_To_Attr('C09', address_rec_.addr_1,             attr_);
   Client_SYS.Add_To_Attr('C10', address_rec_.address1,           attr_);
   Client_SYS.Add_To_Attr('C11', address_rec_.address2,           attr_);
   Client_SYS.Add_To_Attr('C12', address_rec_.zip_code,           attr_);
   Client_SYS.Add_To_Attr('C13', address_rec_.city,               attr_);
   Client_SYS.Add_To_Attr('C14', address_rec_.state,              attr_);
   Client_SYS.Add_To_Attr('C42', address_rec_.county,             attr_);
   Client_SYS.Add_To_Attr('C15', address_rec_.country_code,       attr_);
   Client_SYS.Add_To_Attr('C16', ordrec_.customer_no_pay,         attr_);
   Client_SYS.Add_To_Attr('C17', ordrec_.customer_no_pay_addr_no, attr_);
   Client_SYS.Add_To_Attr('C18', ordrec_.cust_ref,                attr_);
   Client_SYS.Add_To_Attr('C48', address_rec_.address3,           attr_);
   Client_SYS.Add_To_Attr('C49', address_rec_.address4,           attr_);
   Client_SYS.Add_To_Attr('C50', address_rec_.address5,           attr_);
   Client_SYS.Add_To_Attr('C51', address_rec_.address6,           attr_);
    
   IF NOT ((ordrec_.internal_po_no IS NOT NULL) AND (deliver_to_customer_no_ != ordrec_.customer_no)) THEN
      Client_SYS.Add_To_Attr('C19', ordrec_.pay_term_id, attr_);
      Client_SYS.Add_To_Attr('C86', pay_term_desc_, attr_);
   END IF;
   
   Client_SYS.Add_To_Attr('C20', Order_Delivery_Term_API.Get_Description(ordrec_.delivery_terms, ordrec_.language_code), attr_);
   Client_SYS.Add_To_Attr('C21', Mpccom_Ship_Via_API.Get_Description(ordrec_.ship_via_code, ordrec_.language_code),      attr_);
   Client_SYS.Add_To_Attr('C22', ordrec_.forward_agent_id, attr_);
   Client_SYS.Add_To_Attr('C23', ordrec_.label_note,       attr_);
   addr_id_ := Site_Discom_Info_API.Get_Document_Address_Id(ordrec_.contract, 'TRUE');
   company_country_ := substr(Iso_Country_API.Get_Description(Iso_Country_API.Encode(Company_Address_API.Get_Country(company_, addr_id_)),
                              Iso_Language_API.Decode(ordrec_.language_code)), 1, 35);
   postal_address_ := Company_Address_API.Get_Line(company_, addr_id_, 1) || ', ' ||
                      Company_Address_API.Get_Line(company_, addr_id_, 2) || ', ' ||
                      Company_Address_API.Get_Line(company_, addr_id_, 3) || ', ' ||
                      Company_Address_API.Get_Line(company_, addr_id_, 4) || ', ' ||
                      Company_Address_API.Get_Line(company_, addr_id_, 5) || ', ' ||
                      Company_Address_API.Get_Line(company_, addr_id_, 6) || ', ' ||
                      Company_Address_API.Get_Line(company_, addr_id_, 7) || ', ' ||
                      Company_Address_API.Get_Line(company_, addr_id_, 8) || ', ' ||
                      Company_Address_API.Get_Line(company_, addr_id_, 9) || ', ' ||
                      Company_Address_API.Get_Line(company_, addr_id_, 10) || ', ' ||
                      company_country_;
   Client_SYS.Add_To_Attr('C25', Comm_Method_API.Get_Value('COMPANY', company_, Comm_Method_Code_API.Decode('FAX'), 1, addr_id_, sysdate),                    attr_);
   Client_SYS.Add_To_Attr('C26', Comm_Method_API.Get_Value('COMPANY', company_, Comm_Method_Code_API.Decode('PHONE'), 1, addr_id_, sysdate),                  attr_);
   Client_SYS.Add_To_Attr('C27', postal_address_,                                                    attr_);
   Client_SYS.Add_To_Attr('C28', '',                                                                 attr_); -- post
   Client_SYS.Add_To_Attr('C29', '',                                                                 attr_); -- bank
   Client_SYS.Add_To_Attr('C30', substr(Company_API.Get_Name(company_), 1, 35),                      attr_);
   Client_SYS.Add_To_Attr('C31', company_country_,                                                   attr_);
   Client_SYS.Add_To_Attr('C32', Customer_Info_Our_Id_API.Get_Our_Id(ordrec_.customer_no, company_), attr_);

   -- Retrieve note info and agreement info
   Client_SYS.Add_To_Attr('C33', substr(Document_Text_API.Get_All_Notes(ordrec_.note_id, '3'), 1, 2000),    attr_);

   agreement_note_id_ := Customer_Agreement_API.Get_Note_Id(ordrec_.agreement_id);

   Client_SYS.Add_To_Attr('C34', substr(Document_Text_API.Get_All_Notes(agreement_note_id_, '3'), 1, 2000), attr_);
   Client_SYS.Add_To_Attr('C35', '',                attr_); -- customer note
   Client_SYS.Add_To_Attr('C36', receiver_address_, attr_);
   Client_SYS.Add_To_Attr('C37', message_type_,     attr_);
   Client_SYS.Add_To_Attr('C38', media_code_,       attr_);
   
   ean_doc_addr_ := NULL;
   address_id_   := ordrec_.bill_addr_no;
   Trace_SYS.Field('EAN_DOC_ADDRESS_ID', address_id_);
   IF (address_id_ IS NOT NULL) THEN
      ean_doc_addr_ := Customer_Info_Address_API.Get_Ean_Location(ordrec_.customer_no, address_id_);
   END IF;
   Trace_SYS.Field('EAN_DOC_ADDR', ean_doc_addr_);
   Client_SYS.Add_To_Attr('C39', ean_doc_addr_, attr_);

   ean_del_addr_ := NULL;
   address_id_   := ordrec_.ship_addr_no;
   Trace_SYS.Field('EAN_DEL_ADDRESS_ID', address_id_);
   IF (address_id_ IS NOT NULL) THEN
      ean_del_addr_ := Customer_Info_Address_API.Get_Ean_Location(ordrec_.customer_no, address_id_);
   END IF;
   Trace_SYS.Field('EAN_DEL_ADDR', ean_del_addr_);
   Client_SYS.Add_To_Attr('C40', ean_del_addr_, attr_);

   ean_pay_addr_ := NULL;
   IF (ordrec_.customer_no_pay IS NOT NULL) THEN
      address_id_ := ordrec_.customer_no_pay_addr_no;
      Trace_SYS.Field('EAN_PAY_ADDRESS_ID', address_id_);
      IF (address_id_ IS NOT NULL) THEN
         ean_pay_addr_ := Customer_Info_Address_API.Get_Ean_Location(ordrec_.customer_no_pay, address_id_);
      END IF;
   END IF;
   Trace_SYS.Field('EAN_PAY_ADDR', ean_pay_addr_);
   Client_SYS.Add_To_Attr('C41', ean_pay_addr_, attr_);
   
   cross_ref_rec_ := Cust_Addr_Cross_Reference_API.Get(ordrec_.customer_no, address_rec_.ship_addr_no);
   
   Client_SYS.Add_To_Attr('C43', cross_ref_rec_.cross_reference_info_1, attr_);
   Client_SYS.Add_To_Attr('C44', cross_ref_rec_.cross_reference_info_2, attr_); 
   Client_SYS.Add_To_Attr('C45', cross_ref_rec_.cross_reference_info_3, attr_); 
   Client_SYS.Add_To_Attr('C46', cross_ref_rec_.cross_reference_info_4, attr_); 
   Client_SYS.Add_To_Attr('C47', cross_ref_rec_.cross_reference_info_5, attr_);

   Client_SYS.Add_To_Attr('D00', ordrec_.date_entered,         attr_);
   Client_SYS.Add_To_Attr('D01', ordrec_.wanted_delivery_date, attr_);
   Client_SYS.Add_To_Attr('N00', ordrec_.delivery_leadtime,    attr_);
   
   sequence_no_ := cust_ord_del_note_rec_.dirdel_sequence_no;
            
   IF (sequence_no_ IS NULL) THEN
   -- This is the first time the invoice is being sent. 
   -- Obtain a new sequence_no and set the version_no to 0.
      sequence_no_ := Customer_Info_Msg_Setup_API.Increase_Sequence_No(ordrec_.customer_no, media_code_, message_type_);   
      version_no_ := 0; 
   ELSE
   -- The invoice is being resent
   -- Reuse the existing sequence_no and increment the version.
      version_no_ := cust_ord_del_note_rec_.dirdel_version_no + 1; 
   END IF;  
            
   Client_SYS.Add_To_Attr('N20', sequence_no_, attr_);
   Client_SYS.Add_To_Attr('N21', version_no_, attr_);

   Connectivity_SYS.Create_Message_Line(attr_);
   
   -- delnote_no_ is null when Multi-tier delivery notification is used.   
   IF (delnote_no_ IS NOT NULL) THEN   
      Delivery_Note_API.Set_Dirdel_Sequence_Version (delnote_no_, sequence_no_ , version_no_);
      -- Create OUT_MESSAGE_LINE (for lines)
      FOR linerec_ IN get_line_info LOOP
         -- Retrieve the total quantity delivered on this delivery note for the current row.
         -- Several rows might exist in Customer Order Delivery as the last delivery note will be
         -- updated as long as it has not been printed when additional deliverys are made.
         qty_delivered_ := Customer_Order_Line_API.Get_Qty_Shipped_On_Deliv_Note(linerec_.order_no,
                                                                                 linerec_.line_no,
                                                                                 linerec_.rel_no,
                                                                                 linerec_.line_item_no,
                                                                                 delnote_no_);

         -- Retrieve the total catch_quantity_delivered on this delivery note for the current row.
         catch_qty_delivered_ := Customer_Order_Line_API.Get_Catch_Qty_Del_On_Delivnote(linerec_.order_no,
                                                                                        linerec_.line_no,
                                                                                        linerec_.rel_no,
                                                                                        linerec_.line_item_no,
                                                                                        delnote_no_);
         -- Convert to sales unit of measure
         qty_delivered_ := (qty_delivered_ / linerec_.conv_factor * linerec_.inverted_conv_factor);
         IF qty_delivered_ > 0 THEN
            price_unit_meas_ := Sales_Part_API.Get_Price_Unit_Meas(linerec_.contract, linerec_.catalog_no);
            delnote_date_    := NVL(Customer_Order_Delivery_API.Get_Delivered_Date(linerec_.order_no, linerec_.line_no, linerec_.rel_no, linerec_.line_item_no, delnote_no_ ), delnote_date_ );
            message_line_    := message_line_ + 1;
            Trace_SYS.Field('Creating message ROW', message_line_);

            IF (multiple_messages_ = 'TRUE') THEN
               $IF Component_Purch_SYS.INSTALLED $THEN
                  -- Fetch a value for alt_delnote_no_ if self billing invoice will be created.
                  alt_delnote_no_ := Invoice_Purchase_Order_API.Get_Self_Bill_Invoice_No(customer_po_no_, linerec_.line_no, linerec_.rel_no, ordrec_.contract, 'TRUE');
               $ELSE
                  NULL;
               $END
            END IF;

            IF (alt_delnote_no_ IS NULL) THEN
               alt_delnote_no_ := NVL(cust_ord_del_note_rec_.alt_delnote_no, delnote_no_);
            END IF;

            Create_Dirdel_Row___(message_id_                     ,   
                                 message_line_                   ,
                                 linerec_.order_no               ,                                  
                                 linerec_.line_no                , 
                                 linerec_.rel_no                 ,
                                 linerec_.catalog_no             ,
                                 linerec_.catalog_desc           ,
                                 linerec_.sales_unit_meas        ,
                                 price_unit_meas_                ,
                                 linerec_.rowstate               ,
                                 linerec_.note_id                ,
                                 linerec_.customer_part_no       ,
                                 linerec_.customer_part_unit_meas,
                                 linerec_.planned_delivery_date  ,
                                 delnote_date_                   ,
                                 qty_delivered_                  ,
                                 linerec_.buy_qty_due            ,
                                 linerec_.qty_shipped            ,
                                 linerec_.price_conv_factor      ,
                                 linerec_.customer_part_buy_qty  ,
                                 catch_qty_delivered_            ,
                                 ordrec_.customer_no             ,            
                                 linerec_.contract               ,
                                 customer_po_no_                 , 
                                 alt_delnote_no_                 );  

            FOR line_detail_rec_ IN get_transit_row_info (linerec_.line_no, linerec_.rel_no, linerec_.line_item_no) LOOP
               message_line_ := message_line_ + 1;
               Create_Dirdel_Transit_Row___ (message_id_,   
                                             message_line_,
                                             linerec_.order_no,
                                             linerec_.line_no,
                                             linerec_.rel_no,
                                             line_detail_rec_.configuration_id,
                                             line_detail_rec_.lot_batch_no,
                                             line_detail_rec_.serial_no,
                                             line_detail_rec_.waiv_dev_rej_no,
                                             line_detail_rec_.eng_chg_level,
                                             line_detail_rec_.handling_unit_id,
                                             line_detail_rec_.expiration_date,
                                             line_detail_rec_.qty_shipped,
                                             line_detail_rec_.catch_qty_shipped,
                                             acquisition_site_,
                                             line_detail_rec_.part_no,
                                             linerec_.contract,
                                             linerec_.catalog_no,
                                             ordrec_.customer_no,
                                             customer_po_no_ );  

            END LOOP;
         END IF;
      END LOOP;
   ELSE
      -- Multi-tier delivery notification
      FOR linerec_ IN get_mul_tier_line_info LOOP
         message_name_        := 'ROW'; 
         -- only a limited numer of information stored in dirdel_row_tmp, fetch rest of the values from CO line.
         co_line_rec_         := Customer_Order_Line_API.Get(order_no_, linerec_.line_no, linerec_.rel_no, linerec_.line_item_no);                          
         IF (linerec_.quantity_delivered > 0) THEN
            price_unit_meas_  := Sales_Part_API.Get_Price_Unit_Meas(co_line_rec_.contract, co_line_rec_.catalog_no);
            
            -- there will be multiple deliv_no and delivery records for a given order line(serial/lot bacth parts etc.. ), but each will have the same delivery note 
            OPEN get_deliv_no(linerec_.line_no, linerec_.rel_no, linerec_.line_item_no);
            FETCH get_deliv_no INTO deliv_no_;
            IF (get_deliv_no%FOUND) THEN
               cust_order_delivery_rec_ := Customer_Order_Delivery_API.Get(deliv_no_);
               delnote_date_            := cust_order_delivery_rec_.date_delivered;
               alt_delnote_no_          := cust_order_delivery_rec_.delivery_note_ref;
            END IF;   
            CLOSE get_deliv_no;  
     
            message_line_               := message_line_ + 1;
            
            Create_Dirdel_Row___(message_id_                         ,   
                                 message_line_                       ,
                                 order_no_                           ,
                                 linerec_.line_no                    , 
                                 linerec_.rel_no                     ,
                                 co_line_rec_.catalog_no             ,
                                 co_line_rec_.catalog_desc           ,
                                 co_line_rec_.sales_unit_meas        ,
                                 price_unit_meas_                    ,
                                 Customer_Order_Line_API.Get_Objstate(order_no_, linerec_.line_no, linerec_.rel_no, linerec_.line_item_no),
                                 Customer_Order_Line_API.Get_Note_Id(order_no_, linerec_.line_no, linerec_.rel_no, linerec_.line_item_no) ,
                                 co_line_rec_.customer_part_no       ,
                                 co_line_rec_.customer_part_unit_meas,
                                 co_line_rec_.planned_delivery_date  ,
                                 delnote_date_                       ,
                                 linerec_.quantity_delivered         ,
                                 co_line_rec_.buy_qty_due            ,
                                 co_line_rec_.qty_shipped            ,
                                 co_line_rec_.price_conv_factor      ,
                                 co_line_rec_.customer_part_buy_qty  ,
                                 linerec_.catch_qty_delivered        ,
                                 ordrec_.customer_no                 ,            
                                 co_line_rec_.contract               ,
                                 customer_po_no_                     , 
                                 alt_delnote_no_                     );  
            
            log_co_history_ := TRUE;
            
            FOR line_detail_rec_ IN get_mul_tier_transit_row_info (linerec_.line_no, linerec_.rel_no, linerec_.line_item_no) LOOP 
               message_line_ := message_line_ + 1;
               Create_Dirdel_Transit_Row___ (message_id_,   
                                             message_line_,
                                             order_no_,
                                             linerec_.line_no,
                                             linerec_.rel_no,
                                             line_detail_rec_.configuration_id,
                                             line_detail_rec_.lot_batch_no,
                                             line_detail_rec_.serial_no,
                                             line_detail_rec_.waiv_dev_rej_no,
                                             line_detail_rec_.eng_chg_level,
                                             line_detail_rec_.handling_unit_id,
                                             line_detail_rec_.expiration_date,
                                             line_detail_rec_.quantity_delivered,
                                             line_detail_rec_.catch_qty_delivered,
                                             acquisition_site_,
                                             co_line_rec_.part_no,
                                             co_line_rec_.contract,
                                             co_line_rec_.catalog_no,
                                             ordrec_.customer_no,
                                             customer_po_no_ );  

            END LOOP;
         END IF;
      END LOOP;
      Temporary_Mul_Tier_Dirdel_API.Remove_Session(session_id_);
   END IF; 

   -- 'RELEASE' the message in the Out_Message box
   Connectivity_SYS.Release_Message(message_id_);
     
   IF (delnote_no_ IS NOT NULL) THEN   
      delnote_state_ := Delivery_Note_API.Get_Objstate(delnote_no_);
      IF (delnote_state_ IN ('Preliminary','Created','Printed')) THEN
         ----------------------------------------------------------------------------------
         --  If you set it to printed, then the Documents Printed check box is set even if you only MHS'd the delivery note.
         --  The printing of the Delivery note is set to printed now only if you print it.
         ----------------------------------------------------------------------------------
         -- Set the delivery note state to 'Printed' in the delivery note header. -- commented out, see above.
         --Delivery_Note_API.Set_Printed(delnote_no_);
         ----------------------------------------------------------------------------------
          -- Set the delivery note state to 'Printed' in the delivery note header. -- commented out, see above.
         IF (delnote_state_ <> 'Printed') THEN
            Delivery_Note_API.Set_Printed(delnote_no_);
         END IF;
         log_co_history_ := TRUE;        
      END IF;
   END IF;

   IF log_co_history_ THEN
      -- Add a new entry to Customer Order History
      Customer_Order_History_API.New(order_no_, Language_SYS.Translate_Constant(lu_name_, 'DELNOTESENT: Delivery Notification sent via :P1', NULL, media_code_));
   END IF;
   
END Send_Direct_Delivery;


-- Allowed_To_Send
--   Check if a EDI/MHS message may be sent or not for the specified order.
--   Return TRUE (1) if the message may be sent FALSE (0) if not.
@UncheckedAccess
FUNCTION Allowed_To_Send (
   order_no_      IN VARCHAR2,
   message_class_ IN VARCHAR2 ) RETURN NUMBER
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM external_customer_order_tab
      WHERE order_no = order_no_
      AND   rowstate = 'Created';
BEGIN
   IF (message_class_ != 'DESADV') THEN
      -- Check if order is created via Connectivity
      OPEN exist_control;
      FETCH exist_control INTO dummy_;
      IF (exist_control%NOTFOUND) THEN
         CLOSE exist_control;
         RETURN 0;
      END IF;
      CLOSE exist_control;
   END IF;
   -- Check if customer can send 'message_class' message
   IF (Cust_Ord_Customer_API.Get_Default_Media_Code(Customer_Order_API.Get_Customer_No(order_no_), message_class_) IS NULL) THEN
      RETURN 0;
   ELSE
      RETURN 1;
   END IF;
END Allowed_To_Send;

-- Send_Price_List
-- Creates a background job to call Send_Price_List__
PROCEDURE Send_Price_List (
   price_list_no_    IN VARCHAR2,
   media_code_       IN VARCHAR2,
   customer_no_list_ IN VARCHAR2,
   valid_from_       IN DATE,
   valid_to_         IN DATE,
   price_list_site_  IN VARCHAR2 DEFAULT NULL )
IS
   attr_        VARCHAR2(32000);
   description_ VARCHAR2(200);
BEGIN
   attr_ := customer_no_list_;
   
   Client_SYS.Add_To_Attr('PRICE_LIST_NO', price_list_no_, attr_);
   Client_SYS.Add_To_Attr('MEDIA_CDE', media_code_, attr_);
   Client_SYS.Add_To_Attr('VALID_FROM', valid_from_, attr_);
   Client_SYS.Add_To_Attr('VALID_TO',valid_to_, attr_);
   Client_SYS.Add_To_Attr('PRICE_LIST_SITE', price_list_site_, attr_);
   
   description_ := Language_SYS.Translate_Constant(lu_name_, 'SEND_PRICE_LIST: Send Price List');      
   Transaction_SYS.Deferred_Call('CUSTOMER_ORDER_TRANSFER_API.Send_Price_List__', attr_, description_);
END Send_Price_List;

-- Do_Send_Price_List
--   Sends a price list to one or several customers using EDI/MHS/INET_TRANS.
PROCEDURE Do_Send_Price_List (
   price_list_no_    IN VARCHAR2,
   media_code_       IN VARCHAR2,
   customer_no_list_ IN VARCHAR2,
   valid_from_       IN DATE,
   valid_to_         IN DATE,
   price_list_site_  IN VARCHAR2 DEFAULT NULL )
IS

BEGIN 
   Send_Price_Catalog_Msg_API.Send_Sales_Price_List(price_list_no_, media_code_, customer_no_list_, valid_from_, valid_to_, price_list_site_);
END Do_Send_Price_List;


-- Send_Agreement
--   Sends a agreement to the agreement's customer using EDI/MHS or INET_TRANS.
PROCEDURE Send_Agreement (
   agreement_id_ IN VARCHAR2,
   media_code_   IN VARCHAR2,
   valid_from_   IN DATE DEFAULT NULL )
IS
BEGIN 
   Send_Price_Catalog_Msg_API.Send_Agreement(agreement_id_, media_code_, valid_from_);
END Send_Agreement;

-- Get_Auto_Change_Approval_User
--   Returns the edi_auto_change_approval from site/customer, site, customer
--   if there is any, otherwise it returns NULL.
FUNCTION Get_Auto_Change_Approval_User (
   contract_      IN VARCHAR2,
   customer_no_   IN VARCHAR2) RETURN VARCHAR2
IS 
   approval_user_          VARCHAR2(30);
   site_cust_rec_          Message_Defaults_Per_Cust_API.Public_Rec;
   site_rec_               Site_Discom_Info_API.Public_Rec;
   cust_rec_               Cust_Ord_Customer_API.Public_Rec;
BEGIN
   -- Get edi_auto_change_approval from site/customer, site, customer
   site_cust_rec_ := Message_Defaults_Per_Cust_API.Get(contract_, customer_no_);
   site_rec_      := Site_Discom_Info_API.Get(contract_);
   cust_rec_      := Cust_Ord_Customer_API.Get(customer_no_);
   
   IF (site_cust_rec_.edi_auto_change_approval IS NULL) OR (site_cust_rec_.edi_auto_change_approval = Approval_Option_API.DB_NOT_APPLICABLE) THEN
      IF (site_rec_.edi_auto_change_approval IS NULL) OR (site_rec_.edi_auto_change_approval = Approval_Option_API.DB_NOT_APPLICABLE) THEN
         IF (cust_rec_.edi_auto_change_approval = Approval_Option_API.DB_AUTOMATICALLY) THEN
            approval_user_ := cust_rec_.edi_auto_approval_user;
         END IF;
      ELSIF (site_rec_.edi_auto_change_approval = Approval_Option_API.DB_AUTOMATICALLY) THEN
         approval_user_ := site_rec_.edi_auto_approval_user;
      END IF;
   ELSIF (site_cust_rec_.edi_auto_change_approval = Approval_Option_API.DB_AUTOMATICALLY) THEN
      approval_user_ := site_cust_rec_.edi_auto_approval_user;
   END IF;

   RETURN approval_user_;
END Get_Auto_Change_Approval_User;


-- Get_Customer_Country_Code
--   Returns the alternative country code that can be used to set the
--   address layout when the country code is not available in the client.
@UncheckedAccess
FUNCTION Get_Customer_Country_Code (
   customer_id_ IN VARCHAR2,
   company_id_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   country_code_db_ VARCHAR2(2);
   address_id_      CUST_ORD_CUSTOMER_ADDRESS_PUB.addr_no%TYPE;
BEGIN
   -- fetch the country used in the customers delivery address.
   address_id_      := Cust_Ord_Customer_API.Get_Delivery_Address (customer_id_);
   country_code_db_ := Customer_Info_Address_API.Get_Country_Code (customer_id_ , address_id_);
   -- if there is no delivery adress get the customers country
   IF (country_code_db_ IS NULL) THEN
      country_code_db_ := Customer_Info_api.Get_Country_Db (customer_id_);
      -- if the customer is not in the database get the company's country
      IF (country_code_db_ IS NULL) THEN
         country_code_db_ := Company_API.Get_Country_Db (company_id_);
      END IF;
   END IF;
   RETURN country_code_db_;
END Get_Customer_Country_Code;


-- Receive_Receiving_Advice
--   Process an incoming RECADV message and transfer the incoming
--   message data to the ExtReceivingAdvice and ExtReceivingAdviceLine LU's
--   This procedure is called by Connectivity when there is a new incoming Receiving Advice.
--   Any additional logic changes should be evaluate with the Receive_Rec_Advice_Msg_API.Receive_Recv_Advice_Inet_Trans() method.
PROCEDURE Receive_Receiving_Advice (
   message_id_ IN NUMBER )
IS
   connectivity_header_ Connectivity_SYS.in_message;
   connectivity_lines_  Connectivity_SYS.in_message_lines;
   rec_                 in_message_line_pub%ROWTYPE;
   header_rec_          ext_receiving_advice_tab%ROWTYPE;
   line_rec_            ext_receiving_advice_line_tab%ROWTYPE;
   count_               NUMBER;   
   accept_message_      BOOLEAN := FALSE;
BEGIN
   -- Get Message Head
   Connectivity_SYS.Get_Message(count_, connectivity_header_, message_id_);
   IF (count_ = 0 OR connectivity_header_(1).class_id != 'RECADV' ) THEN
      RETURN;
   END IF;

   -- Get all Message Lines
   Connectivity_SYS.Get_Message_Lines(count_,connectivity_lines_,message_id_);

   FOR cnt IN 1..count_ LOOP
      rec_  := connectivity_lines_(cnt);
      -- Initializing header record
      CASE rec_.name
         WHEN 'HEADER' THEN
            header_rec_.message_id             := rec_.message_id;
            header_rec_.advice_id              := rec_.C02;
            header_rec_.receiving_advice_type  := rec_.C03;
            header_rec_.currency_code          := rec_.C04;
            header_rec_.contract               := rec_.C05;
            header_rec_.customer_no            := rec_.C09;
            header_rec_.internal_customer_site := rec_.C07;
            header_rec_.company                := rec_.C08;
            header_rec_.buyer_code             := rec_.C10;
            header_rec_.receiving_advice_date  := rec_.D00;
            header_rec_.date_from              := rec_.D01;
            header_rec_.date_to                := rec_.D02;
            -- Create new Ext Receiving Advice (Head)
            Ext_Receiving_Advice_API.New(header_rec_);
         WHEN 'LINE' THEN
            line_rec_.message_id             := rec_.message_id;
            line_rec_.message_line           := rec_.message_line;
            line_rec_.receipt_reference      := rec_.C00;
            line_rec_.customer_po_no         := rec_.C01;
            line_rec_.customer_po_line_no    := rec_.C02;
            line_rec_.customer_po_release_no := rec_.C03;
            line_rec_.customer_po_receipt_no := rec_.C04;
            line_rec_.customer_ref_id        := rec_.C05;
            line_rec_.customer_part_no       := rec_.C06;
            line_rec_.catalog_no             := rec_.C07;
            line_rec_.sales_unit_meas        := rec_.C09;
            line_rec_.gtin_no                := rec_.C10; -- The GTIN no.
            line_rec_.arrival_date           := rec_.D00;
            line_rec_.receipt_date           := rec_.D01;
            line_rec_.delivery_date          := rec_.D02;
            line_rec_.qty_confirmed_arrived  := rec_.N00;
            line_rec_.qty_confirmed_approved := rec_.N01;
            --Create new Ext Receiving Advice (Detail)
            Ext_Receiving_Advice_line_API.New(line_rec_);
         ELSE
            NULL;
      END CASE;
   END LOOP;

   -- Set state of message in connectivity to 'Accepted' if it has been transferred
   -- to the CO External tables successfully.
   Connectivity_SYS.Accept_Message(message_id_);
   
   @ApproveTransactionStatement(2012-01-24,GanNLK)
   COMMIT;
   accept_message_ := TRUE; 
   Receive_Rec_Advice_Msg_API.Process_Aftr_Recv_Rec_Advice__(header_rec_.message_id, header_rec_.customer_no, header_rec_.internal_customer_site);
EXCEPTION
   WHEN others THEN
   -- Rollback to the last savepoint
   @ApproveTransactionStatement(2012-01-24,GanNLK)
   ROLLBACK;
   Fnd_Session_API.Reset_Fnd_User();
   Transaction_SYS.Set_Status_Info(sqlerrm);
   -- Reject messages
   IF NOT accept_message_ THEN
      Connectivity_SYS.Reject_Message(message_id_);
   END IF;
END Receive_Receiving_Advice;

-- Receive_Self_Billing_Invoice
--   This procedure is called by Connectivity when there is a new incoming Self-billing Invoice.
--   Any additional logic changes should be evaluate with the Receive_Self_Bill_Inv_Msg_API.Receive_Self_Billing_Invoice() method.
PROCEDURE Receive_Self_Billing_Invoice (
   message_id_ IN NUMBER )
IS
   newattr_           VARCHAR2(32000);
   customer_no_       EXT_INC_SBI_HEAD_TAB.customer_no%TYPE := NULL;
   msg_lines_tab_     Connectivity_SYS.in_message_lines;
   msg_header_tab_    Connectivity_SYS.in_message;
   count_             NUMBER;
   header_rec_        Ext_Inc_Sbi_Head_TAB%ROWTYPE;
   line_rec_          Ext_Inc_Sbi_Item_TAB%ROWTYPE;   
BEGIN
   --Fetch the message header
   Connectivity_SYS.Get_Message(count_,msg_header_tab_,message_id_);
   IF (count_ = 0) THEN
      RETURN;
   END IF;

   IF (msg_header_tab_(1).class_id != 'SBIINV') THEN
      RETURN;
   END IF;

   Connectivity_SYS.Get_Message_Lines(count_,msg_lines_tab_,message_id_);
   IF (count_ = 0) THEN
      RETURN;
   END IF;

   FOR i_ IN msg_lines_tab_.FIRST .. msg_lines_tab_.LAST LOOP
      IF (msg_lines_tab_(i_).name = 'HEADER') THEN

         customer_no_ := msg_lines_tab_(i_).c02;

         header_rec_.sender_message_id    := msg_header_tab_(i_).sender_message_id;
         header_rec_.message_id           := msg_lines_tab_(i_).message_id;
         header_rec_.invoice_no           := msg_lines_tab_(i_).c00;
         header_rec_.currency             := msg_lines_tab_(i_).c01;
         header_rec_.customer_no          := msg_lines_tab_(i_).c02;
         header_rec_.customer_reference   := msg_lines_tab_(i_).c03;
         header_rec_.payment_terms_desc   := msg_lines_tab_(i_).c04;
         header_rec_.company_name         := msg_lines_tab_(i_).c05;
         header_rec_.supplier_reference   := msg_lines_tab_(i_).c06;
         header_rec_.invoice_date         := msg_lines_tab_(i_).d00;
         header_rec_.payment_date         := msg_lines_tab_(i_).d01;
         header_rec_.tot_inv_net_amount   := msg_lines_tab_(i_).n00;
         header_rec_.total_tax_amount     := msg_lines_tab_(i_).n01;
         header_rec_.tot_inv_gross_amount := msg_lines_tab_(i_).n02;
         header_rec_.error_message        := msg_lines_tab_(i_).error_message;
         header_rec_.create_date          := SYSDATE;

         Ext_Inc_Sbi_Head_API.New_Header__(header_rec_);

         @ApproveTransactionStatement(2012-01-24,GanNLK)
         COMMIT;
      ELSIF (msg_lines_tab_(i_).name = 'DELIVERYNOTE') THEN
         Client_SYS.Clear_Attr(newattr_);

         Client_SYS.Set_Item_Value('MESSAGE_ID',            msg_lines_tab_(i_).message_id, newattr_);
         Client_SYS.Set_Item_Value('MESSAGE_LINE',          msg_lines_tab_(i_).message_line, newattr_);
         Client_SYS.Set_Item_Value('DELNOTE_NO',            msg_lines_tab_(i_).c00, newattr_);
         Client_SYS.Set_Item_Value('CUSTOMER_PLANT',        msg_lines_tab_(i_).c01, newattr_);
         Client_SYS.Set_Item_Value('CUSTOMER_ORDER_NO',     msg_lines_tab_(i_).c02, newattr_);
         Client_SYS.Set_Item_Value('UNLOADING_PLACE',       msg_lines_tab_(i_).c03, newattr_);
         Client_SYS.Set_Item_Value('CONTACT_PERSON',        msg_lines_tab_(i_).c04, newattr_);
         Client_SYS.Set_Item_Value('DELIVERY_DATE',         msg_lines_tab_(i_).d00, newattr_);
         Client_SYS.Set_Item_Value('RECEIPT_DATE',          msg_lines_tab_(i_).d01, newattr_);

         -- Insert record to the EXT_INC_SBI_DELIVERY_INFO_TAB.
         Ext_Inc_Sbi_Delivery_Info_API.New(newattr_);
      ELSIF (msg_lines_tab_(i_).name = 'INVOICEITEM') THEN

         line_rec_.message_id := msg_lines_tab_(i_).message_id;
         line_rec_.message_line := msg_lines_tab_(i_).message_line;

         line_rec_.delnote_no              := msg_lines_tab_(i_).c00;
         line_rec_.catalog_no              := msg_lines_tab_(i_).c01;
         line_rec_.catalog_desc            := msg_lines_tab_(i_).c02;
         line_rec_.customer_part_no        := msg_lines_tab_(i_).c03;
         line_rec_.customer_part_desc      := msg_lines_tab_(i_).c04;
         line_rec_.sales_unit_meas         := msg_lines_tab_(i_).c05;
         line_rec_.price_unit_meas         := msg_lines_tab_(i_).c06;
         line_rec_.customer_po_no          := msg_lines_tab_(i_).c07;
         line_rec_.customer_po_line_no     := msg_lines_tab_(i_).c08;
         line_rec_.customer_po_rel_no      := msg_lines_tab_(i_).c09;
         line_rec_.reference_id            := msg_lines_tab_(i_).c10;
         line_rec_.order_no                := msg_lines_tab_(i_).c11;
         line_rec_.serial_number           := msg_lines_tab_(i_).c12;
         line_rec_.price_information       := msg_lines_tab_(i_).c13;
         line_rec_.goods_receipt_date      := msg_lines_tab_(i_).d00;
         line_rec_.approval_date           := msg_lines_tab_(i_).d01;
         line_rec_.sales_unit_price        := msg_lines_tab_(i_).n00;
         line_rec_.inv_qty                 := msg_lines_tab_(i_).n01;
         line_rec_.net_amount              := msg_lines_tab_(i_).n02;
         line_rec_.tax_amount              := msg_lines_tab_(i_).n03;
         line_rec_.discount                := msg_lines_tab_(i_).n04;
         line_rec_.gross_amount            := msg_lines_tab_(i_).n05;
         line_rec_.additional_cost         := msg_lines_tab_(i_).n06;
         line_rec_.price_conv_factor       := NVL(msg_lines_tab_(i_).n07, 1);
         line_rec_.gtin_no                 := msg_lines_tab_(i_).c17;
         line_rec_.error_message           := msg_lines_tab_(i_).error_message;
         line_rec_.message_line_type       := 'INVOICEITEM';

         Ext_Inc_Sbi_Item_API.New_Item__(line_rec_);
      END IF;
   END LOOP;
   -- Set state of message in connectivity to 'Accepted' if it has been transferred to the tables successfully.
   Connectivity_SYS.Accept_Message(message_id_);
   @ApproveTransactionStatement(2012-01-24,GanNLK)
   COMMIT;

   -- Check whether the automatic approval enable for the customer.  
   Receive_Self_Bill_Inv_Msg_API.Approve_Self_Billing_Invoice(customer_no_, message_id_);
   
END Receive_Self_Billing_Invoice;


-- Update_Ordchg_On_Create_Order
--   Called from ExternalCustomerOrder to update change requests
--   when  a change request exist at the time of approving an incoming CO.
PROCEDURE Update_Ordchg_On_Create_Order (
   internal_po_no_         IN VARCHAR2,
   order_no_               IN VARCHAR2,
   internal_delivery_type_ IN VARCHAR2 )
IS
   change_request_message_id_ NUMBER;
   attr_                      VARCHAR2(2000);
   ean_location_del_addr_     VARCHAR2(100);
   order_rec_                 Customer_Order_API.Public_Rec;

   CURSOR find_change_requests IS
      SELECT message_id, ean_location_del_addr
      FROM   ext_cust_order_change_tab
      WHERE  internal_po_no = internal_po_no_
      AND    rowstate NOT IN ('Processed', 'Cancelled');

   CURSOR find_change_request_lines IS
      SELECT message_line, line_no, rel_no
      FROM   ext_cust_order_line_change_tab
      WHERE  message_id    = change_request_message_id_;
BEGIN
   FOR change_request IN find_change_requests LOOP
      Client_SYS.Clear_Attr(attr_);
      Add_Org_Header_Values___(attr_, order_no_, internal_delivery_type_);
      Client_SYS.Add_To_Attr('ORDER_NO', order_no_, attr_);
      -- Condition to check whether the order change message has a single occurance address.
      -- If it has a value, do not fetch the default address. It means it is single occurance.
      IF (change_request.ean_location_del_addr IS NOT NULL) THEN
         order_rec_              := Customer_Order_API.Get(order_no_);
         ean_location_del_addr_  := Customer_Info_Address_API.Get_Ean_Location(order_rec_.customer_no, order_rec_.ship_addr_no);
         IF (order_rec_.addr_flag = 'N') THEN
            Client_SYS.Add_To_attr('EAN_LOCATION_DEL_ADDR', ean_location_del_addr_, attr_);
         END IF;
      END IF;
      Ext_Cust_Order_Change_API.Modify_Change_Request(attr_, change_request.message_id);
      change_request_message_id_ := change_request.message_id;

      FOR change_request_line_ IN find_change_request_lines LOOP
         Client_SYS.Clear_Attr(attr_);
         Client_SYS.Add_To_Attr('LINE_NO', change_request_line_.line_no, attr_);
         Client_SYS.Add_To_Attr('REL_NO', change_request_line_.rel_no, attr_);
         Add_Org_Line_Values__(attr_, order_no_);
         Ext_Cust_Order_Line_Change_API.Modify_Line(attr_, change_request_message_id_, change_request_line_.message_line );
      END LOOP;
   END LOOP;
END Update_Ordchg_On_Create_Order;

PROCEDURE Send_Multi_Tier_Dir_Delivery (      
   session_id_                  IN NUMBER, 
   order_no_                    IN VARCHAR2, 
   line_no_                     IN VARCHAR2,
   rel_no_                      IN VARCHAR2,              
   line_item_no_                IN NUMBER,
   deliv_no_                    IN NUMBER,
   configuration_id_            IN VARCHAR2,
   lot_batch_no_                IN VARCHAR2,
   serial_no_                   IN VARCHAR2,
   waiv_dev_rej_no_             IN VARCHAR2,
   eng_chg_level_               IN VARCHAR2,
   handling_unit_id_            IN NUMBER,
   quantity_delivered_          IN NUMBER,
   catch_qty_delivered_         IN NUMBER,
   expiration_date_             IN DATE,
   send_mul_tier_del_notificat_ IN BOOLEAN)
IS
   media_code_              VARCHAR2(30) := NULL;
   order_rec_               Customer_Order_API.Public_Rec;
   cust_ord_customer_rec_   Cust_Ord_Customer_API.Public_Rec;
BEGIN   
   order_rec_             := Customer_Order_API.Get(order_no_);
   cust_ord_customer_rec_ := Cust_Ord_Customer_API.Get(order_rec_.customer_no);
   media_code_            := Cust_Ord_Customer_API.Get_Default_Media_Code(order_rec_.customer_no, 'DIRDEL');
      
   Temporary_Mul_Tier_Dirdel_API.New(session_id_          => session_id_,
                                     order_no_            => order_no_,
                                     line_no_             => line_no_, 
                                     rel_no_              => rel_no_,
                                     line_item_no_        => line_item_no_,
                                     deliv_no_            => deliv_no_,
                                     configuration_id_    => configuration_id_,
                                     lot_batch_no_        => lot_batch_no_,
                                     serial_no_           => serial_no_,
                                     waiv_dev_rej_no_     => waiv_dev_rej_no_,
                                     eng_chg_level_       => eng_chg_level_,
                                     handling_unit_id_    => handling_unit_id_, -- LIMHU0
                                     quantity_delivered_  => quantity_delivered_,
                                     catch_qty_delivered_ => catch_qty_delivered_,
                                     expiration_date_     => expiration_date_);   
   
   -- at the end of the data set, trigger the sending of multi-tier dlivery notification.   
   IF send_mul_tier_del_notificat_ THEN
      IF (Temporary_Mul_Tier_Dirdel_API.Check_Session_Exist(session_id_) = 'TRUE') THEN
         Send_Direct_Delivery(delnote_no_ => NULL,
                              order_no_   => order_no_,
                              media_code_ => media_code_,
                              session_id_ => session_id_);
      END IF;                                                                     
   END IF; 
   
END Send_Multi_Tier_Dir_Delivery;

@UncheckedAccess
FUNCTION Is_Multi_Tier_Ordchg_Enabled (
   order_no_     IN  VARCHAR2,
   line_no_      IN  VARCHAR2,
   rel_no_       IN  VARCHAR2,
   line_item_no_ IN  NUMBER ) RETURN VARCHAR2
IS
   int_order_no_     VARCHAR2(12);
   int_line_no_      VARCHAR2(4);
   int_rel_no_       VARCHAR2(4);
   int_line_item_no_ NUMBER;
   po_order_no_      VARCHAR2(12);
   po_line_no_       VARCHAR2(4);
   po_rel_no_        VARCHAR2(4);
   supply_site_      VARCHAR2(5);
   demand_code_      VARCHAR2(20);
   supply_code_      VARCHAR2(20);   
   purchase_type_    VARCHAR2(20); 
   multi_tier_ordchg_  VARCHAR2(5):= 'TRUE';
   
   CURSOR get_internal_co_info(po_order_no_ IN VARCHAR2, po_line_no_ IN VARCHAR2, po_rel_no_ IN VARCHAR2) IS
      SELECT order_no, line_no, rel_no, line_item_no,  
             contract, demand_code, supply_code
      FROM CUSTOMER_ORDER_LINE_TAB
      WHERE demand_order_ref1 = po_order_no_
      AND   demand_order_ref2 = po_line_no_
      AND   demand_order_ref3 = po_rel_no_;
      
BEGIN   
   int_order_no_     := order_no_;
   int_line_no_      := line_no_;
   int_rel_no_       := rel_no_;
   int_line_item_no_ := line_item_no_;
   
   LOOP
      Customer_Order_Pur_Order_API.Get_Purord_For_Custord(po_order_no_,
                                                          po_line_no_,
                                                          po_rel_no_, 
                                                          purchase_type_, 
                                                          int_order_no_,      
                                                          int_line_no_,       
                                                          int_rel_no_,      
                                                          int_line_item_no_);
      IF (po_order_no_ IS NOT NULL) THEN         
         OPEN  get_internal_co_info(po_order_no_, po_line_no_, po_rel_no_);
         FETCH get_internal_co_info INTO int_order_no_, int_line_no_, int_rel_no_, int_line_item_no_,  
                                         supply_site_, demand_code_, supply_code_;
         IF get_internal_co_info%FOUND THEN
            IF (Site_Discom_Info_API.Get_Exec_Ord_Change_Online_Db(supply_site_) = 'FALSE') THEN
               multi_tier_ordchg_ := 'FALSE';
            END IF;
         END IF;
         CLOSE get_internal_co_info;
      END IF;
      EXIT WHEN ((po_order_no_ IS NULL) OR (multi_tier_ordchg_ = 'FALSE') OR 
                 (supply_code_ IS NOT NULL AND supply_code_ NOT IN ('IPD','IPT'))) ;
   END LOOP;
   RETURN multi_tier_ordchg_;
 END Is_Multi_Tier_Ordchg_Enabled;


FUNCTION Get_Supplier_Id (
   company_     IN VARCHAR2,
   contract_    IN VARCHAR2,
   customer_no_ IN VARCHAR2,
   delnote_no_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   supplier_id_                VARCHAR2(20);
   int_order_no_               VARCHAR2(12);
   int_line_no_                VARCHAR2(4);
   int_rel_no_                 VARCHAR2(4);
   int_line_item_no_           NUMBER;
   int_demand_code_            VARCHAR2(20);
   order_line_rec_             Customer_Order_Line_API.Public_Rec;
   receiver_source_ref1_       VARCHAR2(50);
   receiver_source_ref2_       VARCHAR2(50);
   receiver_source_ref3_       VARCHAR2(50);
   receiver_source_ref_type_   VARCHAR2(20);
   receiver_uom_               VARCHAR2(50);
   shipped_qty_                NUMBER;
   qty_shipped_                NUMBER;
   customer_part_no_           VARCHAR2(45);
   customer_part_desc_         VARCHAR2(200);
   customer_contract_          VARCHAR2(5);
   inventory_part_no_          VARCHAR2(25);
   catalog_no_                 VARCHAR2(25);
   input_unit_meas_            VARCHAR2(30);
   gtin_no_                    VARCHAR2(14);
   
   CURSOR get_order_line IS
      SELECT col.order_no, col.line_no, col.rel_no, col.line_item_no, col.demand_code, col.part_no,col.catalog_no, col.input_unit_meas, cod.qty_shipped
      FROM   customer_order_delivery_tab cod, customer_order_line_tab col, customer_order_tab co
      WHERE  col.order_no     = cod.order_no
      AND    col.line_no      = cod.line_no
      AND    col.rel_no       = cod.rel_no
      AND    col.line_item_no = cod.line_item_no
      AND    col.order_no     = co.order_no
      AND    col.demand_code  = 'IPD'
      AND    cod.delnote_no   = delnote_no_
      AND    rownum           = 1;
BEGIN
   IF (delnote_no_ IS NOT NULL) THEN
      
      OPEN get_order_line;
      FETCH get_order_line INTO int_order_no_, int_line_no_, int_rel_no_, int_line_item_no_, int_demand_code_,inventory_part_no_,catalog_no_,input_unit_meas_,qty_shipped_;
      CLOSE get_order_line;
      
      order_line_rec_ := Customer_Order_Line_API.Get(int_order_no_, int_line_no_, int_rel_no_, int_line_item_no_);
      gtin_no_         := Sales_Part_API.Get_Gtin_No(contract_, catalog_no_, input_unit_meas_);
      
      Customer_Order_Line_API.Get_Info_For_Desadv(receiver_source_ref1_           ,
                                                  receiver_source_ref2_           ,
                                                  receiver_source_ref3_           ,
                                                  receiver_source_ref_type_       ,
                                                  customer_part_no_               ,
                                                  customer_part_desc_             ,
                                                  customer_contract_              ,
                                                  receiver_uom_                   ,
                                                  shipped_qty_                    ,
                                                  order_line_rec_                 ,
                                                  contract_                       ,
                                                  customer_no_                    ,
                                                  inventory_part_no_              ,
                                                  gtin_no_                        ,
                                                  qty_shipped_                    );

      $IF (Component_Purch_SYS.INSTALLED) $THEN
         IF (receiver_source_ref1_ IS NOT NULL) THEN
             supplier_id_ := Purchase_Order_API.Get_Vendor_No(receiver_source_ref1_);
         ELSE
            IF (Cust_Ord_Customer_Category_API.Encode(Cust_Ord_Customer_API.Get_Category(customer_no_)) = 'I') THEN
               supplier_id_ := Supplier_API.Get_Vendor_No_From_Contract(contract_);
            END IF;
         END IF;
      $ELSE
         NULL;
      $END
   END IF;
   
   IF (supplier_id_ IS NULL) THEN
      supplier_id_ := Customer_Info_Our_Id_API.Get_Our_Id(customer_no_, company_);
   END IF;
   
   RETURN supplier_id_;
END Get_Supplier_Id;

PROCEDURE Post_Send_Dispatch_Advice (
   order_no_     IN VARCHAR2,
   media_code_   IN VARCHAR2 )
IS
BEGIN
   Customer_Order_History_API.New(order_no_, Language_SYS.Translate_Constant(lu_name_, 'DISPADVSENT: Dispatch Advice sent via :P1', NULL, media_code_));
END Post_Send_Dispatch_Advice;

PROCEDURE Create_Disadv_Struct_Info(
   dis_adv_line_arr_   IN OUT Dispatch_Advice_Utility_API.Dispatch_Advice_Dispatch_Advice_Line_Arr,
   delnote_no_         IN VARCHAR2,
   message_id_         IN NUMBER,
   message_line_       IN NUMBER,
   forward_agent_id_   IN VARCHAR2,
   delivery_terms_     IN VARCHAR2,
   ship_via_code_      IN VARCHAR2,
   customer_no_        IN VARCHAR2,
   order_no_           IN VARCHAR2,
   media_code_         IN VARCHAR2 DEFAULT NULL)
IS
   msg_line_                NUMBER;  
   contract_ VARCHAR2(5);
   dis_adv_line_rec_  Dispatch_Advice_Utility_API.Dispatch_Advice_Dispatch_Advice_Line_Rec;  

   -- the respective values of DELIVERY_NOTE. Also used alias to avoid ambiguous column names. 
   -- cursor copied from Delivery note report (delnote.rdf)
   -- used together with small message structure
   CURSOR get_order_row IS
      SELECT col1.order_no, to_number(col1.line_no) l, to_number(col1.rel_no) r,
             col1.line_no,  col1.rel_no,               col1.line_item_no,        col1.catalog_type
        FROM CUSTOMER_ORDER_LINE_TAB col1, CUSTOMER_ORDER_DELIV_NOTE_MAIN cod, CUST_ORDER_LINE_ADDRESS_2 cola
       WHERE col1.order_no       = order_no_
         AND col1.order_no       = cola.order_no
         AND col1.line_no        = cola.line_no
         AND col1.rel_no         = cola.rel_no
         AND col1.line_item_no   = cola.line_item_no
         AND col1.ship_addr_no   = cod.ship_addr_no
         AND cod.ship_via_code   = ship_via_code_
         AND cod.delivery_terms  = NVL(delivery_terms_, ' ')
         AND NVL(cod.forward_agent_id, ' ')  = NVL(forward_agent_id_, ' ')
         AND cod.delnote_no                  = delnote_no_
         AND cod.addr_flag_db                = col1.addr_flag
         AND (((col1.addr_flag = 'N') AND (cod.ship_addr_no = col1.ship_addr_no)) OR
              ((col1.addr_flag = 'Y') AND
               (cola.addr_1||'^'||cola.address1||'^'||cola.address2||'^'||cola.address3||'^'||cola.address4||'^'||cola.address5||'^'||cola.address6||'^'||cola.zip_code||'^'||cola.city||'^'||cola.state||'^'||cola.country_code||'^' =
                cod.addr_1||'^'||cod.ship_address1||'^'||cod.ship_address2||'^'||cod.ship_address3||'^'||cod.ship_address4||'^'||cod.ship_address5||'^'||cod.ship_address6||'^'||cod.ship_zip_code||'^'||cod.ship_city||'^'||cod.ship_state||'^'||cod.country_code||'^')))
         AND col1.rowstate NOT IN ('Invoiced', 'Cancelled')
         AND supply_code NOT IN ('PD', 'IPD')
         AND (col1.line_item_no = 0
              OR (col1.line_item_no < 0 AND EXISTS (SELECT line_item_no
                                                      FROM CUSTOMER_ORDER_LINE_TAB col2
                                                     WHERE col1.order_no = col2.order_no
                                                       AND col1.line_no  = col2.line_no
                                                       AND col1.rel_no   = col2.rel_no
                                                       AND col2.rowstate != 'Cancelled'
                                                       AND col2.supply_code NOT IN ('PD', 'IPD')
                                                       AND col2.line_item_no > 0
                                                       AND col2.shipment_connected = 'FALSE')))
         AND col1.shipment_connected = 'FALSE'
   UNION
      SELECT col1.order_no, to_number(line_no) l, to_number(rel_no) r,
             line_no,       rel_no, line_item_no, catalog_type
        FROM CUSTOMER_ORDER_LINE_TAB col1, delivery_note_pub dnp
       WHERE col1.order_no                    = order_no_
         AND dnp.ship_via_code                = ship_via_code_
         AND dnp.delnote_no                   = delnote_no_
         AND NVL(dnp.delivery_terms, ' ')     = NVL(delivery_terms_, ' ')
         AND NVL(dnp.forward_agent_id, ' ')   = NVL(forward_agent_id_, ' ')
         AND Customer_Order_Line_API.Line_On_Delivery_Note(col1.order_no, line_no, rel_no, line_item_no, delnote_no_) = 1
         AND supply_code NOT IN ('PD', 'IPD')
         AND (line_item_no = 0
              OR (line_item_no < 0 AND EXISTS (SELECT line_item_no
                                                 FROM CUSTOMER_ORDER_LINE_TAB col2
                                                WHERE col1.order_no =  col2.order_no
                                                  AND col1.line_no  =  col2.line_no
                                                  AND col1.rel_no   =  col2.rel_no
                                                  AND col2.rowstate != 'Cancelled'
                                                  AND col2.supply_code NOT IN ('PD', 'IPD')
                                                  AND col2.line_item_no > 0)))
      
      ORDER BY 1, 2, 3;


   CURSOR get_reservation(delnote_no_ VARCHAR2, order_no_ VARCHAR2,
                          line_no_    VARCHAR2, rel_no_   VARCHAR2, line_item_no_ NUMBER) IS
      SELECT order_no, line_no, rel_no, line_item_no, lot_batch_no, serial_no, waiv_dev_rej_no, eng_chg_level, handling_unit_id, qty_shipped, expiration_date
        FROM CUSTOMER_ORDER_RESERVATION_TAB
       WHERE order_no     = order_no_
         AND line_no      = line_no_
         AND rel_no       = rel_no_
         AND line_item_no = line_item_no_
         AND deliv_no IN (SELECT deliv_no
                           FROM CUSTOMER_ORDER_DELIVERY
                          WHERE delnote_no          = delnote_no_
                            AND order_no              = order_no_
                            AND line_no               = line_no_
                            AND rel_no                = rel_no_
                            AND line_item_no          = line_item_no_
                            AND cancelled_delivery_db = 'FALSE');
                         
BEGIN
   msg_line_      := message_line_;
   contract_ := Customer_Order_API.Get_Contract(order_no_);
   FOR linerec_ IN get_order_row LOOP
      IF (linerec_.catalog_type = 'INV') THEN
         -- Add order lines connected to the delivery note - without a package structure.
         -- Added inner loop to split the order line into reserved "parts"
         FOR resrec_ IN get_reservation(delnote_no_, linerec_.order_no,
                                        linerec_.line_no, linerec_.rel_no, linerec_.line_item_no) LOOP
            
            IF media_code_ = 'INET_TRANS' THEN
               IF Dictionary_SYS.Component_Is_Active('ITS') THEN
                  dis_adv_line_arr_.extend();                 
                  dis_adv_line_rec_ := dis_adv_line_arr_(dis_adv_line_arr_.last);
               ELSE
                  Error_SYS.Record_General(lu_name_, 'NOITS: Component ITS need to be installed to proceed with this request.');
               END IF;
            ELSE
               msg_line_ := msg_line_ + 1;               
            END IF;
            
            Dispatch_Advice_Utility_API.Create_Line(dis_adv_line_rec_ => dis_adv_line_rec_,                                                   
                                                    message_id_       => message_id_,
                                                    message_line_     => msg_line_,
                                                    shipment_id_      => NULL,
                                                    shipment_line_no_ => NULL,
                                                    source_ref1_      => resrec_.order_no,
                                                    source_ref2_      => resrec_.line_no,
                                                    source_ref3_      => resrec_.rel_no,
                                                    source_ref4_      => resrec_.line_item_no,
                                                    customer_no_      => customer_no_,
                                                    lot_batch_no_     => resrec_.lot_batch_no,
                                                    serial_no_        => resrec_.serial_no,
                                                    expiration_date_  => resrec_.expiration_date,
                                                    waiv_dev_rej_no_  => resrec_.waiv_dev_rej_no,
                                                    eng_chg_level_    => resrec_.eng_chg_level,
                                                    qty_shipped_      => resrec_.qty_shipped,
                                                    handling_unit_id_ => resrec_.handling_unit_id,
                                                    activity_seq_     => NULL,
                                                    media_code_       => media_code_);
            IF media_code_ = 'INET_TRANS' THEN                                         
               dis_adv_line_arr_(dis_adv_line_arr_.last) := dis_adv_line_rec_;
            END IF;
            
         END LOOP;
      ELSE                   
         IF media_code_ = 'INET_TRANS' THEN
            IF Dictionary_SYS.Component_Is_Active('ITS') THEN
               dis_adv_line_arr_.extend();              
               dis_adv_line_rec_ := dis_adv_line_arr_(dis_adv_line_arr_.last);
            ELSE
               Error_SYS.Record_General(lu_name_, 'NOITS: Component ITS need to be installed to proceed with this request.');
            END IF;
         ELSE
            msg_line_ := msg_line_ + 1;               
         END IF;

         Dispatch_Advice_Utility_API.Create_Line(dis_adv_line_rec_ => dis_adv_line_rec_,                                                 
                                                 message_id_       => message_id_,
                                                 message_line_     => msg_line_,
                                                 shipment_id_      => NULL,
                                                 shipment_line_no_ => NULL,
                                                 source_ref1_      => linerec_.order_no,
                                                 source_ref2_      => linerec_.line_no,
                                                 source_ref3_      => linerec_.rel_no,
                                                 source_ref4_      => linerec_.line_item_no,
                                                 customer_no_      => customer_no_,
                                                 lot_batch_no_     => '*',
                                                 serial_no_        => '*', 
                                                 expiration_date_  => NULL,
                                                 waiv_dev_rej_no_  => NULL,
                                                 eng_chg_level_    => NULL,
                                                 qty_shipped_      => Customer_Order_Line_API.Get_Qty_Shipped_On_Deliv_Note(linerec_.order_no, linerec_.line_no, linerec_.rel_no, linerec_.line_item_no, delnote_no_),
                                                 handling_unit_id_ => NULL,
                                                 activity_seq_     => NULL,
                                                 media_code_       => media_code_);
      
         IF media_code_ = 'INET_TRANS' THEN                                         
            dis_adv_line_arr_(dis_adv_line_arr_.last) := dis_adv_line_rec_;
         END IF;
      END IF;
   END LOOP;
END Create_Disadv_Struct_Info;  

  
   -- Get_Common_Receive_Header_Info___
   -- This method contains the common logics that are relevant to
   -- receive ORDERS and ORDCHG messages in EDI and ITS flows.
   PROCEDURE Get_Common_Receive_Header_Info___ (
      customer_no_            IN OUT VARCHAR2,
      language_code_          IN OUT VARCHAR2,           
      delivery_terms_desc_    IN OUT VARCHAR2,
      customer_po_no_         IN OUT VARCHAR2,
      internal_delivery_type_ IN OUT VARCHAR2,      
      delivery_terms_         IN VARCHAR2, 
      internal_customer_site_ IN VARCHAR2,
      ean_location_del_addr_  IN VARCHAR2,
      internal_po_no_         IN VARCHAR2    )
   IS        
      ship_addr_no_             CUSTOMER_ORDER_TAB.ship_addr_no%TYPE := NULL; 
   BEGIN
      -- Check if internal customer is used.
      IF (internal_customer_site_ IS NOT NULL) THEN
         customer_no_ := Cust_Ord_Customer_API.Get_Customer_No_From_Contract(internal_customer_site_);
      END IF;
      IF (customer_no_ IS NULL AND ean_location_del_addr_ IS NOT NULL) THEN
         Customer_Info_Address_API.Get_Id_By_Ean_Loc_If_Unique(customer_no_, ship_addr_no_, ean_location_del_addr_); 
      END IF;
      IF (language_code_ IS NULL) THEN
         language_code_ := Cust_Ord_Customer_API.Get_Language_Code(customer_no_);
      END IF;

   -- If delivery_terms_desc_ has a value sent in, we will not fetch a value for address_no_
   IF (internal_delivery_type_ != '4') THEN 
      IF   ( (customer_no_ IS NOT NULL) AND (delivery_terms_ IS NOT NULL) AND (delivery_terms_desc_ IS NULL)) THEN
         delivery_terms_desc_ := Order_Delivery_Term_API.Get_Description(delivery_terms_);         
      ELSE 
         delivery_terms_desc_ := NULL;
      END IF;
   END IF;   

   IF ((internal_delivery_type_ IN ('1', '5')) AND (customer_po_no_ IS NULL)) THEN
      customer_po_no_ := internal_po_no_;
   END IF; 

END Get_Common_Receive_Header_Info___; 

PROCEDURE Get_Chg_Order_Header_Info___(
   order_no_               IN OUT VARCHAR2,
   internal_customer_site_ IN VARCHAR2,
   customer_no_            IN VARCHAR2,
   customer_po_no_         IN VARCHAR2,
   internal_po_no_         IN VARCHAR2)
IS
BEGIN
   IF (order_no_ IS NULL) THEN
      IF (internal_customer_site_ IS NULL) THEN
         -- External customer. Find correct order_no using CUSTOMER_PO_NO.
         order_no_ := Find_Order_No_For_Ext_Cust___(customer_no_, customer_po_no_);
      ELSE
         -- Internal customer. Find correct order_no using INTERNAL_PO_NO.
         order_no_ := Find_Order_No_For_Int_Cust___(customer_no_, internal_po_no_);
      END IF;               
   END IF;
END Get_Chg_Order_Header_Info___;

-- Cancel_Prev_Ext_Cust_Orders___
-- This message will cancel the previous
-- incomming customer orders when the new
-- one is received.
PROCEDURE Cancel_Prev_Ext_Cust_Orders___ (
   external_ref_ IN VARCHAR2 )
IS
   old_msg_id_               NUMBER; 
BEGIN
   IF (external_ref_ IS NOT NULL) THEN
      old_msg_id_ := External_Customer_Order_API.Find_Message_From_Ext_Ref(external_ref_);
      IF (old_msg_id_ IS NOT NULL) THEN
         External_Customer_Order_API.Cancel(old_msg_id_);
      END IF;
   END IF;    
END Cancel_Prev_Ext_Cust_Orders___;

-- Get_Data_Receive_Cust_Order_Line___
-- This method is used to place all the logic common to 
-- receive ORDERS and ORDCHG EDI and ITS messages.
PROCEDURE Get_Data_Receive_Cust_Order_Line___ (
   internal_delivery_type_     IN OUT VARCHAR2,      
   delivery_terms_desc_        IN OUT VARCHAR2,      
   deliver_to_customer_no_     IN VARCHAR2,  
   delivery_terms_             IN VARCHAR2 )
IS
BEGIN
   IF (internal_delivery_type_ = '4') THEN
      internal_delivery_type_ := 'INTTRANSIT';
   ELSIF (internal_delivery_type_ = '3') THEN
      internal_delivery_type_ := 'INTDIRECT'; 
   ELSE
      internal_delivery_type_ := NULL;
   END IF;         

   IF (deliver_to_customer_no_ IS NOT NULL) AND (delivery_terms_ IS NOT NULL) AND (delivery_terms_desc_ IS NULL) THEN
      delivery_terms_desc_ := Order_Delivery_Term_API.Get_Description(delivery_terms_);      
   END IF;         	
END Get_Data_Receive_Cust_Order_Line___;

PROCEDURE Approve_Receive_Cust_Order___ (
   contract_         IN VARCHAR2,
   customer_no_      IN VARCHAR2,
   message_id_       IN NUMBER)
IS
   impersonate_fnd_user_     VARCHAR2(30);
   cust_rec_                 Cust_Ord_Customer_API.Public_Rec;
   site_rec_                 Site_Discom_Info_API.Public_Rec;
   site_cust_rec_            Message_Defaults_Per_Cust_API.Public_Rec;
BEGIN
    -- Get edi_auto_order_approval from site/customer, site, customer
   site_cust_rec_ := Message_Defaults_Per_Cust_API.Get(contract_, customer_no_);
   site_rec_      := Site_Discom_Info_API.Get(contract_);
   cust_rec_      := Cust_Ord_Customer_API.Get(customer_no_);
   
   IF (site_cust_rec_.edi_auto_order_approval IS NULL) OR (site_cust_rec_.edi_auto_order_approval = Approval_Option_API.DB_NOT_APPLICABLE) THEN
      IF (site_rec_.edi_auto_order_approval IS NULL) OR (site_rec_.edi_auto_order_approval = Approval_Option_API.DB_NOT_APPLICABLE) THEN
         IF (cust_rec_.edi_auto_order_approval = Approval_Option_API.DB_AUTOMATICALLY) THEN
            impersonate_fnd_user_ := cust_rec_.edi_auto_approval_user;
         END IF;
      ELSIF (site_rec_.edi_auto_order_approval = Approval_Option_API.DB_AUTOMATICALLY) THEN
         impersonate_fnd_user_ := site_rec_.edi_auto_approval_user;
      END IF;
   ELSIF (site_cust_rec_.edi_auto_order_approval = Approval_Option_API.DB_AUTOMATICALLY) THEN
      impersonate_fnd_user_ := site_cust_rec_.edi_auto_approval_user;
   END IF;
        
   IF (impersonate_fnd_user_ IS NOT NULL) THEN
      Fnd_Session_API.Impersonate_Fnd_User(impersonate_fnd_user_);
      External_Customer_Order_API.Set_Approve(message_id_);
      Fnd_Session_API.Reset_Fnd_User();
   END IF;  
END Approve_Receive_Cust_Order___;

PROCEDURE Approve_Receive_Change_Order___ (
   message_id_       IN VARCHAR2,
   contract_         IN VARCHAR2,
   customer_no_      IN VARCHAR2,
   process_online_   IN BOOLEAN)
IS
   impersonate_fnd_user_ VARCHAR2(30);
BEGIN
	impersonate_fnd_user_ := Get_Auto_Change_Approval_User(contract_, customer_no_);
    
   -- Checked approval user exists to confirm auto approval flow.
   IF (impersonate_fnd_user_ IS NOT NULL) THEN
      IF process_online_ THEN
         Ext_Cust_Order_Change_API.Set_Approve(message_id_);
      ELSE
         Fnd_Session_API.Reset_Fnd_User();
         Fnd_Session_API.Impersonate_Fnd_User(impersonate_fnd_user_);
         Ext_Cust_Order_Change_API.Set_Approve(message_id_);
         Fnd_Session_API.Reset_Fnd_User();
      END IF;
   END IF;           
END Approve_Receive_Change_Order___;


@Override
PROCEDURE Ext_Cust_Ord_Change_Struct_Ext_Cust_Order_Char_Change_Copy_From_Header___(
   rec_        IN OUT NOCOPY Ext_Cust_Ord_Change_Struct_Ext_Cust_Order_Char_Change_Rec,
   header_rec_ IN      Ext_Cust_Ord_Change_Struct_Ext_Cust_Order_Line_Change_Rec)
IS
   
BEGIN
   rec_.message_id := header_rec_.message_id;      
   rec_.external_msg_line := header_rec_.message_line;
 
END Ext_Cust_Ord_Change_Struct_Ext_Cust_Order_Char_Change_Copy_From_Header___;

@Override
PROCEDURE Ext_Cust_Ord_Change_Struct_New___ (
   rec_ IN OUT Ext_Cust_Ord_Change_Struct_Rec)
IS
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   info_       VARCHAR2(32000);
   attr_       VARCHAR2(32000);
   
BEGIN
   rec_.message_id := Connectivity_SYS.Get_Next_In_Message_Id(); 
   Get_Common_Receive_Header_Info___(rec_.customer_no, rec_.language_code,                                 rec_.delivery_terms_desc, rec_.customer_po_no, 
                                rec_.internal_delivery_type, rec_.delivery_terms, 
                                rec_.internal_customer_site, rec_.ean_location_del_addr, rec_.internal_po_no ); 
   -- add these values are kept only if it's an internal delivery from Purch
   IF (rec_.internal_delivery_type != '4') THEN 
      rec_.ship_via_desc := NULL;
      rec_.picking_leadtime := NULL;      
   END IF;
   Get_Chg_Order_Header_Info___(rec_.order_no, rec_.internal_customer_site, rec_.customer_no, rec_.customer_po_no,
                              rec_.internal_po_no);   
   Add_To_Attr_From_Rec___(rec_, attr_);
   Add_Org_Header_Values___(attr_, rec_.order_no, rec_.internal_delivery_type); --  check b2b_process_online_
   Ext_Cust_Order_Change_API.New__(info_, objid_, objversion_, attr_, 'DO');
   Add_To_Rec_From_Attr___(attr_, rec_);
 
END Ext_Cust_Ord_Change_Struct_New___;

@Override
PROCEDURE Ext_Cust_Ord_Change_Struct_Ext_Cust_Order_Line_Change_New___ (
   rec_ IN OUT Ext_Cust_Ord_Change_Struct_Ext_Cust_Order_Line_Change_Rec)
IS
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   info_       VARCHAR2(32000);
   attr_       VARCHAR2(32000);
   order_no_   VARCHAR2(2000);
BEGIN
   rec_.message_line := Get_Next_Change_Line___(rec_.message_id);
   order_no_ := External_Customer_Order_API.Get_Order_No(rec_.message_id);
   Get_Data_Receive_Cust_Order_Line___(rec_.internal_delivery_type, rec_.delivery_terms_desc,                                           
                                       rec_.deliver_to_customer_no, rec_.delivery_terms);

   IF (rec_.planned_rental_start_date IS NOT NULL) THEN
      rec_.rental := TRUE;
      rec_.original_rental_start_date := rec_.planned_rental_start_date;
   ELSIF (rec_.planned_rental_end_date IS NOT NULL) THEN
      rec_.rental := TRUE;        
      rec_.original_rental_end_date := rec_.planned_rental_end_date;
   END IF; 

   IF ( rec_.orders_price_option_db IS NULL OR rec_.orders_price_option_db != 'SENDPRICE' ) THEN
      IF rec_.discount IS NULL THEN
         rec_.discount := 0;
      END IF;
   ELSE        
      rec_.sale_unit_price := NULL;
      rec_.unit_price_incl_tax := NULL;
      rec_.catalog_desc := NULL;    
      rec_.discount := NULL;
   END IF;      
    IF rec_.original_buy_qty_due IS NULL THEN
      rec_.original_buy_qty_due := rec_.buy_qty_due;
   END IF;

   Add_To_Attr_From_Rec___(rec_, attr_);
   IF rec_.ord_chg_state IN ('CHANGED', 'NOT AMENDED') THEN
      Add_Org_Line_Values__(attr_, order_no_); 
   END IF;
   Ext_Cust_Order_Line_Change_API.New__(info_, objid_, objversion_, attr_, 'DO');
   Add_To_Rec_From_Attr___(attr_, rec_);
END Ext_Cust_Ord_Change_Struct_Ext_Cust_Order_Line_Change_New___;

FUNCTION Get_Next_Change_Line___ (
     message_id_ IN NUMBER ) RETURN NUMBER
   IS
      message_line_ NUMBER;
      temp_ NUMBER;
      
      CURSOR get_max_line_id(message_id_ NUMBER) IS
      SELECT max(message_line)
      FROM ext_cust_order_line_change_tab
      WHERE message_id = message_id_;
      
   BEGIN
      OPEN get_max_line_id(message_id_); 
      FETCH get_max_line_id INTO temp_;
      IF (get_max_line_id%NOTFOUND OR temp_ IS NULL) THEN
         message_line_ := 1;
      ELSE
         message_line_ := temp_ + 1;
      END IF;
      CLOSE get_max_line_id;
      RETURN message_line_;
   END Get_Next_Change_Line___;

@Override   
PROCEDURE Ext_Cust_Ord_Change_Struct_Ext_Cust_Order_Line_Change_Copy_From_Header___(
rec_        IN OUT NOCOPY Ext_Cust_Ord_Change_Struct_Ext_Cust_Order_Line_Change_Rec,
header_rec_ IN      Ext_Cust_Ord_Change_Struct_Rec)
IS 
BEGIN
   rec_.message_id := header_rec_.message_id; 
END Ext_Cust_Ord_Change_Struct_Ext_Cust_Order_Line_Change_Copy_From_Header___;

@Override
PROCEDURE Ext_Cust_Ord_Struct_New___ (
  rec_ IN OUT NOCOPY Ext_Cust_Ord_Struct_Rec)
IS    
BEGIN 
   rec_.message_id := Connectivity_SYS.Get_Next_In_Message_Id();     
   Get_Common_Receive_Header_Info___(rec_.customer_no, rec_.language_code,
                                rec_.delivery_terms_desc, rec_.customer_po_no, 
                                rec_.internal_delivery_type, rec_.delivery_terms, 
                                rec_.internal_customer_site, rec_.ean_location_del_addr, rec_.internal_po_no ); 
   IF rec_.import_mode IS NULL THEN
      rec_.import_mode := 'ORDER';
   END IF;
   IF (rec_.internal_delivery_type = '4') THEN
      rec_.internal_delivery_type  := 'INTER-SITE';
   END IF;
   IF (rec_.internal_delivery_type != '1') THEN 
      rec_.delivery_leadtime := NULL;
   END IF;
   -- add these values are kept only if it's an internal
   -- delivery from Purch
   IF (rec_.internal_delivery_type != '4') THEN 
      rec_.ship_via_desc := NULL;
      rec_.picking_leadtime := NULL;
      rec_.shipment_type := NULL;
   END IF;
   IF (rec_.currency_code IS NULL) THEN
      rec_.currency_code := Cust_Ord_Customer_API.Get_Currency_Code(rec_.customer_no);
   END IF;   
   Cancel_Prev_Ext_Cust_Orders___(rec_.external_ref);
   Super(rec_);
END Ext_Cust_Ord_Struct_New___;
   
 
@Override   
PROCEDURE Ext_Cust_Ord_Struct_External_Cust_Order_Line_New___ (
   rec_ IN OUT NOCOPY Ext_Cust_Ord_Struct_External_Cust_Order_Line_Rec)
IS      
BEGIN 
   rec_.message_line := Get_Next_Ext_Ord_Msg_Line___(rec_.message_id);

   Get_Data_Receive_Cust_Order_Line___(rec_.internal_delivery_type, rec_.delivery_terms_desc,                                           
                                        rec_.deliver_to_customer_no, rec_.delivery_terms);

   IF (rec_.planned_rental_start_date IS NOT NULL) THEN
      rec_.rental := TRUE;
      rec_.original_rental_start_date := rec_.planned_rental_start_date;
   ELSIF (rec_.planned_rental_end_date IS NOT NULL) THEN
      rec_.rental := TRUE;
      rec_.original_rental_end_date := rec_.planned_rental_end_date;
   END IF;

   IF ( rec_.orders_price_option_db IS NULL OR rec_.orders_price_option_db != 'SENDPRICE' ) THEN
      rec_.sale_unit_price := NULL;
      rec_.unit_price_incl_tax := NULL;
      rec_.catalog_desc := NULL;    
      rec_.discount := NULL;
   END IF;

   IF rec_.original_buy_qty_due IS NULL THEN
      rec_.original_buy_qty_due := rec_.buy_qty_due;
   END IF;
   super(rec_);
END Ext_Cust_Ord_Struct_External_Cust_Order_Line_New___;
   
@Override
PROCEDURE Ext_Cust_Ord_Struct_External_Cust_Order_Char_New___ (
   rec_ IN OUT NOCOPY Ext_Cust_Ord_Struct_External_Cust_Order_Char_Rec)
IS
BEGIN
   rec_.message_line := Get_Next_Ext_Char_Line___(rec_.message_id, rec_.external_msg_line);
   super(rec_);  
END Ext_Cust_Ord_Struct_External_Cust_Order_Char_New___;
   
@Override 
PROCEDURE Ext_Cust_Ord_Struct_External_Cust_Order_Line_Copy_From_Header___(
   rec_        IN OUT  Ext_Cust_Ord_Struct_External_Cust_Order_Line_Rec,
   header_rec_ IN      Ext_Cust_Ord_Struct_Rec)
IS
BEGIN
   rec_.message_id := header_rec_.message_id;  
END Ext_Cust_Ord_Struct_External_Cust_Order_Line_Copy_From_Header___;
   
 
@Override
PROCEDURE Ext_Cust_Ord_Struct_External_Cust_Order_Char_Copy_From_Header___(
   rec_        IN OUT  Ext_Cust_Ord_Struct_External_Cust_Order_Char_Rec,
   header_rec_ IN      Ext_Cust_Ord_Struct_External_Cust_Order_Line_Rec)
IS
BEGIN
   rec_.message_id := header_rec_.message_id;
   rec_.external_msg_line := header_rec_.message_line;
END Ext_Cust_Ord_Struct_External_Cust_Order_Char_Copy_From_Header___;
     
   
FUNCTION Get_Next_Ext_Ord_Msg_Line___ (
   message_id_ IN NUMBER ) RETURN NUMBER
IS
   message_line_ NUMBER;
   temp_ NUMBER;
      
   CURSOR get_max_line_id(message_id_ NUMBER) IS
      SELECT max(message_line)
      FROM external_cust_order_line_tab
      WHERE message_id = message_id_;
      
BEGIN
   OPEN get_max_line_id(message_id_); 
   FETCH get_max_line_id INTO temp_;
   IF (get_max_line_id%NOTFOUND OR temp_ IS NULL) THEN
      message_line_ := 1;
   ELSE
      message_line_ := temp_ + 1;
   END IF;
   CLOSE get_max_line_id;
   RETURN message_line_;
END Get_Next_Ext_Ord_Msg_Line___;

FUNCTION Get_Next_Ext_Char_Line___ (
   message_id_ IN NUMBER,
   external_msg_line_ IN NUMBER ) RETURN NUMBER
IS
   message_line_ NUMBER;
   temp_ NUMBER;
      
   CURSOR get_max_line_id(message_id_ NUMBER) IS
      SELECT max(message_line)
      FROM external_cust_order_char_tab
      WHERE message_id = message_id_;
      
BEGIN
   OPEN get_max_line_id(message_id_); 
   FETCH get_max_line_id INTO temp_;
   IF (get_max_line_id%NOTFOUND OR temp_ IS NULL) THEN
      message_line_ := external_msg_line_ + 1;
   ELSE
      message_line_ := temp_ + 1;
   END IF;
   CLOSE get_max_line_id;
   RETURN message_line_;
END Get_Next_Ext_Char_Line___;


FUNCTION Get_Next_Chg_Char_Line___ (
   message_id_ IN NUMBER,
   external_msg_line_  IN NUMBER ) RETURN NUMBER
IS
   message_line_ NUMBER;
   temp_ NUMBER;
      
   CURSOR get_max_line_id(message_id_ NUMBER) IS
      SELECT max(message_line)
      FROM ext_cust_order_char_change_tab
      WHERE message_id = message_id_;
      
BEGIN
   OPEN get_max_line_id(message_id_); 
   FETCH get_max_line_id INTO temp_;
   IF (get_max_line_id%NOTFOUND OR temp_ IS NULL) THEN
      message_line_ := external_msg_line_ + 1;
   ELSE
      message_line_ := temp_ + 1;
   END IF;
   CLOSE get_max_line_id;
   RETURN message_line_;
END Get_Next_Chg_Char_Line___; 

@Override
PROCEDURE Ext_Cust_Ord_Change_Struct_Ext_Cust_Order_Char_Change_New___ (
   rec_ IN OUT NOCOPY Ext_Cust_Ord_Change_Struct_Ext_Cust_Order_Char_Change_Rec)
IS
BEGIN
   rec_.message_line := Get_Next_Chg_Char_Line___(rec_.message_id, rec_.external_msg_line);
   super(rec_);
END Ext_Cust_Ord_Change_Struct_Ext_Cust_Order_Char_Change_New___;
