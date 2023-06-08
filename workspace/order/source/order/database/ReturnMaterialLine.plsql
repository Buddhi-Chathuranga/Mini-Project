-----------------------------------------------------------------------------
--
--  Logical unit: ReturnMaterialLine
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210915  Skanlk   Bug 160575(SC21R2-2598), Modified Match_Returns_Against_Del___ and Create_Dir_Ret_Transaction___ to support retruns of handling units.
--  210701  ChFolk   SCZ-153839(159666), Removed error message for in correct supplier to create transaction in Create_Dir_Ret_Transaction___.
--  210701           Modified Insert___ to set null for part_no when the catalog_no is non inventory.
--  210303  MalLlk   SCZ-13866 (Bug 158000), Modified Line_Information() to get rid of additional calls to Cust_Ord_Customer_API.Get_Acquisition_Site and Return_Material_API.Get_Customer_No.
--  210302  NiDalk   SC2020R1-12663, Modified Receive_Returns_Information and receive_authorized_returns_arr to remove parent values.
--  210302  ChBnlk   SC2020R1-12159, Modified Check_Delete___ to add missing assignment to rma_rec_.
--  210209  ChBnlk   SC2020R1-12159, Replaced the individual attribute get methods from the public get method where possible to improve performance.
--  210201  Erlise   Bug 157511, Modified Get_Co_Line_Data(). Corrected the calculation of the max possible qty to return when the RMA is connected to a shipment id.
--  201127  ThKrlk   Bug 156485 (SCZ-12652), Modified Get_Net_Tot_Inv_Qty_To_Return()and Get_Net_Total_Qty_To_Return() to pass handling unit id.
--  201127           And modified Get_Tot_Returned_Scrapped_Qty() to get the correct returned quantity by considering handling unit if it exists.
--  201110  JeLise   SCZ-12157, Merged bug 155644
--  201110           ApWilk   Bug 155644 (SCZ-11198), Modified Register_Direct_Return_Clob(), Create_Dir_Ret_Transaction___(), Account_Non_Invent___() 
--  201110           and Return_And_Scrap__() to validate the return process when creating return transactions. 
--  201016  WaSalk   SC2020R1-10716, Modified Inventory_Return__() and method call in Packed_Inventory_Return___() by adding date_applied_ to parameter list.
--  201014  RoJalk   Bug 155370 (SCZ-11779), Modified Create_Dir_Ret_Transaction___() to fetch the correct arrived quantity and to create the correct transaction history
--  201014           when returning a direct delivered Non-Inventory Sales Part directly to the supply site.
--  200824  RoJalk   SC2020R1-9252, Added the new key parameters(ownership/project/delivery info) to Inventory_Part_In_Transit_API.Remove_From_Order_Transit method call.
--  220711  NiDalk   SCXTEND-4446, Modified Update___ and Modify_Rma_Defaults__ to handle UPDATE_TAX in attr. UPDATE_TAX is set to false when taxes are fetched from a bundle call and not necessary to add at line level.
--  200715  NiDalk   SCXTEND-4441, Modified Update___ to avoid duplicate tax requests being sent to external tax systems when updationg charge lines.
--  200728  RasDlk   Bug 154346 (SCZ-10369), Added the new method Return_Or_Scrap_Serial___.
--  200728           Modified Inventory_Return___, Return_Lot_Serial_Allowed and Return_And_Scrap__ to check whether the CO connected to the RMA have being delivered without a serial number
--  200728           when the supply code is Purchase Order Dir and the Stop Creation of New Serials in RMA is unchecked, before calling Part_Serial_Catalog_API.Exist methods.
--  200703  MaRalk   Bug 154330 (SCZ-10357), Modified method Register_Direct_Return_Clob in order to move part serial catalog object current position from 
--  200703           'In Facility' to 'Issued' before executing the logic for register direct returns for supplier.
--  200514  AjShlk   Bug 153923(SCZ-10076), Added new method Check_Active_Rma_For_Ord_Line() to exclude cancelled RMA lines to use in Modified Check_Undo_Ord_Line_Deliv___() to enable package part.
--  200512  ErFelk   Bug 153375(SCZ-9811), Modified Tax_Check___() by adding a separate code block to call Add_Transaction_Tax_Info___() if originating_rma_no is not null.  
--  200319  ErFelk   Bug 152367(SCZ-8903), Modified Create_Dir_Ret_Transaction___() to pass the supplier_return_reason_ when calling Inventory_Transaction_Hist_API.New().
--  200306  MaRalk   SCXTEND-3466, Modified pipeline function Receive_Returns_Information by returning more attributes in the rec
--  200306           in order improve the performance in 'Receive Authorized Returns' aurena client.
--  200304  Kagalk   GESPRING20-1798, Added del_reason_id_, del_note_no_, del_note_date_ to Packed_Inventory_Return___, Inventory_Return__.
--  200303  Kagalk   GESPRING20-1797, Added del_reason_id_, del_note_no_, del_note_date_ to Create_Cust_Receipt, Inventory_Return___, Return_And_Scrap__, Packed_Return_And_Scrap___, Unpack_Cust_Receipt___ methods.
--  200211  DhAplk   Bug 151176 (SCZ-8347), Modified Create_Dir_Ret_Transaction___() to use Get_Inv_Qty_Arrived_By_Source() instead of Get_Qty_Arrived_By_Source() to fetch the proper inventory quantity when creating the transaction history.
--  200210  WaSalk   GESPRING20-1776, Modified cust_receipt_rec,Create_Cust_Receipt(),Inventory_Return___(),Return_And_Scrap__(),Packed_Return_And_Scrap___(),Packed_Inventory_Return___() as necessary and created the method Modify_Inv_Trans_Date___().
--  200207  Kagalk   GESPRING20-1777, Moved validations to Check_Common___ method.
--  200129  Kagalk   GESPRING20-1624, Modified Check_Insert___, Check_Update___, Packed_Return_And_Scrap___, Packed_Inventory_Return___ methods for modify_date_applied functionality.
--  191022  Hairlk   SCXTEND-941, Modified Prepare_Insert___, added code to fetch CUSTOMER_TAX_USAGE_TYPE from the header and added it to the attr.
--  191008  Hairlk   SCXTEND-941, Avalara integration, Modified Insert___, Added code to fetch customer_tax_usage_type from customer if its not available in the attr.
--                   Modified Update___, added customer_tax_usage_type to the condition which check if the tax should be recalculated or not. Also modified Check_Update___, added validations related to customer_tax_usage_type and RMA line state
--  190918  ShPrlk   Bug 148683(SCZ-5655), Modified Inventory_Return___ to set transaction code to RETPODIRSH if the demand and intermediate sites are in different companies,
--  190918           in a three site intersite flow comprising three companies.
--  190911  ErRalk   Bug 144624, Modified Create_Cust_Receipt and Inventory_Return___ methods to return partially returned qty when 'Return Total Qty' Check box is checked in Receive parts dialog box.
--                   Modified Create_Cust_Receipt and Return_And_Scrap__ methods to scrap partially returned qty when 'Scrap Total Qty' Check box is checked in Scrap parts dialog boxand and 
--                   allow scrap/return remaining total quantity for the partial returns/scraps.
--  190806  RasDlk   Bug 149175 (SCZ-6171), Modified Check_Return_To_Delivered_Sup() to check whether the materials are returned to the same supplier who delivered goods 
--  190806           through the purchase order connected to the CO line in order to create the the return Transactions in Direct Delivery flow.
--  190802  DiKulk   Bug 149112 (SCZ-5797), Modified Get_Inv_Connected_Rma_Line_No() procedure by adding series_id_ parameter.
--  190725  Cpeilk   Bug 147476(SCZ-4137), Modified Create_Cust_Receipt(), Packed_Inventory_Return__(), Packed_Return_And_Scrap__() 
--  190329           and Register_Direct_Return() by adding an error message so that parts cannot be receive or scrap when RMA line is cancelled.
--  190617  ShPrlk   Bug 148549(SCZ-5431), Modified Restrict_Multi_Site_Rma___ by removing debit_invoice_no, debit_invoice_series_id to allow selecting invoice in reciept RMA
--  190617           and altered the error message to reflect it.
--  190524  ShPrlk   Bug 145072, Modified Return_Lot_Serial_Allowed to check if serials are in transit when attempting to receive.
--  190524           Modified Inventory_Return___ to change transaction code from 'RETPODIRSH' to 'RETPODSINT' in order to
--  190524           cater returns from a three site intersite flow without accounting issues.
--  190522  WaSalk  Bug 145377 (SCZ-2123), Modified Set_Cancel_Reason() to enble canceling the Origin RMA when user has no access to receipt site.
--  190518  LaThlk  Bug 145705(SCZ-2281), Added the function Lines_Invoice_Connected() to get the availability of RMA lines connected to particular invoice.
--  260419  RaVdlk  SCUXXW4-14737, Made the message type CLOB in Unpack_Cust_Receipt()
--  190403  RaVdlk  SCUXXW4-1389, Added the method Line_Information() to support certain fields in ReturnMaterialLineTab fragment.
--  190103  UdGnlk  Bug 145967(SCZ-2239), Modified Build_Attr_Create_Sup_Rma___() to pass delivery type to retrieve tax free tax code for receipt rma. 
--  190103  RaVdlk  SCUXXW4-8420, Made the message_ parameter in Register_Direct_Return_Clob()as CLOB and through the preious existing method which had the message_ paramter as varchar2, the new method Register_Direct_Return_Clob was called.
--  181204  RaVdlk  SCUXXW4-8435, Moved the logic in Packed_Inventory_Return__() to an implementation method and called that implementation method from the Packed_Inventory_Return__(), which is used in IEE
--  181204                        and added a new public method as Packed_Inventory_Return() and called the same implementation method through it to support aurena, since it has the message data type as CLOB
--  181114  RaVdlk  SCUXXW4-8435, Made the message type CLOB in Packed_Return_And_Scrap___()
--  181102  RaVdlk  SCUXXW4-8440, Moved the logic in Packed_Return_And_Scrap__() to an implementation method and called that implementation method from the Packed_Return_And_Scrap__(), which is used in IEE
--  181102                        and added a new public method as Packed_Return_And_Scrap() and called the same implementation method through it to support aurena, since it has the message data type as CLOB   
--  180425  reanpl  Bug 141485, Free of Charge enhancement - Modified Calc_Foc_Tax_Basis___
--  180228  MaEelk  STRSC-17365, Revesed the correction done from STRSC-16336.
--  180226  MaRalk  STRSC-17331, LCS merge 140429 - Modified the correction done in LCS bug 139158 - Create_Cust_Receipt.
--  180220  MaEelk  STRSC-16336, Set CURRENCY_CODE to be fetched from Invoice Header in Get_Ivc_Line_Data.
--  180209  KoDelk  STRSC-15901, When creating tax lines for invoice use the current currency rate rather than using the source line currency rate.
--  180124  AsZelk  STRSC-16039, Modified Validate_Conn_Purch_Line___() in order to change Get_State() in to Get_Objstate().
--  180124  TiRalk  STRSC-15785, Modified Account_Non_Invent___ by fetching cost using orginal RMA order references when return goods for supplier site for IPT flow.
--  180117  AsZelk  Bug 139158, Modified Create_Cust_Receipt() in order to update export control license coverage quantity  when a non-inventory part return through a RMA.
--  180111  DiKuLk  Bug 139482, Modified Check_Insert___() to set catch Qty only when the part is catch enabled.
--  171220  ApWilk  Bug 139092, Modified Get_Co_Line_Data() and Get_Ivc_Line_Data() to update the correct return qty when there are multiple RMAs connected with the CO and changed the return qty accordingly.
--  171218  RaVdlk  STRSC-15227, Passed tax_code,tax_calc_structure_id,tax_class_id values of newrec to Tax_Handling_Order_Util_API.Create_Tax_Line_Param_Rec()
--  171206  UdGnlk  Bug 138862, Added Get_Demand_Purchase_Order_Info to be used in Mpccom_Accounting_API.
--  171116  DiKuLk  Bug 138403, Modified Create_Dir_Ret_Transaction___ by passing value 'INT ORDER TRANSIT' to location_group_ parameter when calling Inventory_Transaction_Hist_API.New().
--  171108  RaVdlk  STRSC-13876, Passed 0 to handling_unit_id when it does not have a value for handling_unit_id.
--  171024  MalLlk  STRSC-12754, Removed the methods Get_Line_Total_Base_Amount().
--  171019  BudKlk  Bug 138394, Modified the method Return_And_Scrap__() by adding an attribute 'BYPASS_USER_ALLOWED_SITE' to the attr_ before updating the originating RMA in order to bypass the user allowed site validation.
--  171003  ErFelk  Bug 137591, Added function Check_Not_Invoiced_Rma_Lines().  
--  170926  RaVdlk  STRSC-11152,Removed Get_Objstate function, since it is generated from the foundation
--  170721  UdGnlk  Bug 136709, Modified Packed_Inventory_Return__() and Packed_Return_And_Scrap__() when calculating QTY_RECEIVED_INV_UOM 
--  170721          to get from oldrec_.qty_received_inv_uom instead of oldrec_.qty_received.
--  170530  ShPrlk  Bug 134781, Modified Check_Insert___ to fetch catch_qty_ correctly based on the source of RMA line and added method Get_Invoice_Price_Qty.
--  170327  SudJlk  VAULT-2640, Modified Create_Cust_Receipt to manually check if the RMA line is allowed to be updated based on CRM access settings.
--  170324  JeLise  LIM-11278, Added Message_SYS.Construct when creating org_message_ in Inventory_Return___.
--  170130  SBalLK  Bug 132728, Modified Unpack_Cust_Receipt__() method to resend the receipt_no_ and putaway_event_id_ generate in first iteration to client for reuse them for next iteration when message length get exceed 32000 limit.
--  161202  ApWilk  Bug 132700, Modified Inventory_Return__() to return a serial into the inventory through a RMA when the serial is in 'InFacility'.
--  161019  NWeelk  FINHR-3143, Removed method Get_Total_Line_Tax_Pct.
--  161013  MeAblk  GG-119, Added new error message to avoid creating RMA lines for FSM demand lines.
--  161010  LaThlk  Bug 131546, Modified Inventory_Return___() method to restrict receiving zero quantities through the RMA.
--  160930  SeJalk  Bug 131162, Reversed previous bug corrections 128650 and 129882. 
--  160930          Added method Match_Returns_Against_Del___ to match the return quantities against the deliveries, Modified Create_Dir_Ret_Transaction___ to check the exact transaction with lot batch/wdr
--  160930          or check with the total receipt quantity accordingly.
--  160929  LEPESE  LIM-8882, Added value for parameter handling_unit_id_ in call to method Inventory_Part_In_Stock_API.Get_Serial_No_For_Stock.
--  160815  ShPrlk  Bug 130102, Modified Get_Price_Info() to avoid retrieve condition code prices when there's no condition code price record exists in the sales part.
--  160728  LaThlk  Bug 130029, Modified Check_Update___() by adding a new variable(bypass_uas_) in order to ignore the user allowed site validation when updating RMA of another site in inter-site flow.
--  160728          Modified Inventory_Return___() by adding an attribute 'BYPASS_USER_ALLOWED_SITE' to the attr_ before updating the originating RMA in order to bypass the user allowed site validation.
--  160728          Modified Modify_Multi_Site_Rma___() by adding attribute to the modify_attr_ in order to ignore the user allowed site validation when updating the demand site RMA through supply site
--  160728          RMA and vice versa.
--  160725  RoJalk  LIM-8141, Replaced the usage of Shipment_Line_API.Source_Exist with Shipment_Line_API.Source_Ref1_Exist.
--  160712  SudJlk  STRSC-1959, Modified Check_Insert___ to handle data validity of coordinator.
--  160704  JeeJlk  Bug 129882, Modified Register_Direct_Return to create a single RETPODIRSH transaction in demand site for the whole quantity that is entered by user, if the quantity is delivered with 
--  160704          different lot batches and return to a single lot batch.
--  160629  DAYJLK  LIM-7748, Replaced usage of obsolete methods in Purchase_Order_Line_API.
--  160628  MalLlk  FINHR-1818, Added methods Get_Line_Total_Base_Amount and Get_Line_Address_Info.
--  160627  DAYJLK  LIM-7748, Modified function Get_Supplier_Rtn_Reason by replacing usage of Purchase_Receipt_Return_API with Receipt_Return_API.
--  160525  JeeJlk  Bug 128489, Modified Get_Price_Info to convert condtion code price/price incl tax to base price/price incl tax and then to sale price/sales price incl tax. 
--  160523  LEPESE  LIM-7363, Replaced putaway_event_id_ with inventory_event_id_, remove_putaway_event_ with finish_inventory_event_, 
--  160523          Inventory_Putaway_Manager_API.Get_Next_Putaway_Event_Id with Inventory_Event_Manager_API.Get_Next_Inventory_Event_id and
--  160523          Putaway_To_Empty_Event_API.Remove_Putaway_Event with Inventory_Event_Manager_API.Finish.
--  160503  MeAblk   Bug 128650, Modified methods Register_Direct_Return() and Create_Dir_Ret_Transaction___() to correctly create return transactions when have delivered parts having different w/d/r nos.
--  160419  IsSalk   FINHR-1589, Move server logic of RmaLineTaxLines to the LU Source Tax Item Order.
--  151218  MeAblk   Bug 126276, Modified Check_Insert___() and Get_Ivc_Line_Data in order to set the tax liability from the customer order line and avoid set it as 'TAX' always.
--  160202  ThEdlk   Bug 126845, Modified Valid_Customer_Order_Line___() by changing the conditions of the error messages that raise to validate 
--  160202           the supplier entered in the RMA field with the Customer Order connected PO supplier in a Purch Order Dir flow.
--  160201  RoJalk   LIM-5576, Replaced Shipment_Line_API.Get with Shipment_Line_API.Get_Qty_Shipped_By_Source.
--  160112  ErFelk   Bug 126346, Modified Inventory_Return___() and Return_And_Scrap__() by passing rma_rec_.customer_no if org_rma_rec_.customer_no is NULL. 
--  160111  RoJalk   LIM-5816, Replaced Shipment_Line_API.Order_Exist_In_Shipment with Shipment_Line_API.Source_Exist
--  151216  DilMlk   Bug 125916, Modified Packed_Inventory_Return__ and Packed_Return_And_Scrap__ methods and increased the length of serial_no_ from 20 to 50.
--  151118  AyAmlk   Bug 125451, Modified Validate_Fee_Code___() and Check_Insert___() so that if Tax liability is manually set while having the invoice no,
--  151118           the change will be saved at update. Modified Get_Ivc_Line_Data() so that the correct values for vat and tax liability will be shown when
--  151118           fetching data for invoice no.
--  151110  RoJalk   LIM-4610, Rename ShipmentOrderLine LU to ShipmentLine.
--  151103  IsSalk   FINHR-316, Renamed attribute FEE_CODE to TAX_CODE in Customer Order Line.
--  151103  SURBLK   FINHR-317, Modified fee_code_changed_ in to tax_code_changed_.
--  151030  RasDlk   Bug 125029, Modified Cancel__ and Deny__ by adding a condition to check whether the exp_license_connect_id_ is null before the export license order event
--  151030           is set as 'Canceled' when cancelling and denying a RMA line.
--  151021  IsSalk   FINHR-197, Used FndBoolean in taxable attribute in sales part.
--  151015  AyAmlk   Bug 125066, Modified Check_Insert___() in order to send the changed tax code value when inserting a RMA line.
--  151014  RasDlk   Bug 124925, Modified Build_Attr_For_New___ by retrieving the default value for tax_liability_ when it is null.
--  151014           Modified Check_Insert___ by retrieving the header value for tax_liability_ when it is null.
--  151009  RasDlk   Bug 124704, Modified Cancel__ and Deny__ by adding a condition to check whether the component 'EXPCTR' is installed. 
--  150908  NiNilk   Bug 123899, Modified Valid_Customer_Order_Line___() by preventing creating RMA Lines when the supply code is service order. Raised the error message RMANOTALLOWED.   
--  150916  RasDlk   Bug 124200, Modified Cancel__, Deny__ to set the export license order event as 'Canceled' when denying a RMA line.
--  150910  NaLrlk   AFT-1529, Modified Create_Cust_Receipt() to stop creating demobilization WO from rental transfer.
--  150907  NaLrlk   AFT-1515, Added Check_Common___() to restrict rental lines when return to site is different site.
--  150710  JaBalk   RED-502, Modified Inventory_Return___ to get the total deleived qty from cursor get_del_qty by adding SUM.
--  150707  IsSalk   KES-905, Added reference-by-name for the parameter list when calling the method Inventory_Transaction_Hist_API.New().
--  150619  ChBnlk   ORA-813, Modified Create_Supply_Site_Rma___() and New()by moving the attribute string manipulation to seperate methods. 
--  150619           Introduced new methods Build_Attr_Create_Sup_Rma___ and Build_Attr_For_New___.
--  150526  JaBalk   RED-361, Made the implementation method Create_Cust_Receipt___ to public.
--  150821  ErFelk   Bug 124026, Modified Return_And_Scrap__() by passing the original rma's customer no when calling Equipment_Serial_Utility_API.Moved_To_Issued_Cust_In_Object().
--  150818  ErFelk   Bug 124026, Modified Inventory_Return___() by passing the original rma's customer no when calling Equipment_Serial_Utility_API.Moved_To_Issued_Cust_In_Object() because
--  150818           the Service management object is been created with the original rma's customer no. 
--  150818  ErFelk   Bug 122838, Modified cursor get_delivery_transactions in Register_Direct_Return() by adding serial_no_ '*' to the where clause.
--  150717  ErFelk   Bug 123241, Modified Register_Direct_Return() so that EXPIRATION_DATE is converted by using Clinet_SYS date format.
--  150521  NWeelk   Bug 122649, Modified methods Inventory_Return__ and Return_And_Scrap__ by removing the loop which retrieved RMA lines for the order
--  150521           since the error SERIALRMARET should only raise if the same serial part is received twice from the same RMA line.
--  150515  IsSalk   KES-409, Passed new parameter to Inventory_Transaction_Hist_API.Set_Alt_Source_Ref().
--  150512  IsSalk   KES-421, Passed new parameter to Inventory_Transaction_Hist_API.New().
--  150512  MAHPLK   KES-402, Renamed usages of order_no, release_no, sequence_no, line_item_no attributes of 
--  150512           InventoryTransactionHist to source_ref1, source_ref2, source_ref3, source_ref4
--  150420  UdGnlk  LIM-152, Added handling_unit_id as new key column to Customer_Receipt_Location_Tab therefore did necessary changes for methods. 
--  150417  MaEelk  LIM-1072, Added dummy parameter handling_unit_id_ 0 to the Inventory_Part_In_Stock_API and Inventory_Part_In_Transit_API method calls.
--  150304  ShVese   PRSC-6335,Added a validation to check if configuration id has changed in Check_Update___ before executing Validate_Configuration_Id___.
--  150224  SlKapl   PRFI-5584, reversed correction PRSC-6089 as the same solution was used inside Customer_Order_Tax_Util_API to solve all similar issues to the one described in PRSC-6089.
--                   Modified method New to pass series_id_ to Customer_Order_Tax_Util_API.Get_Total_Tax_Percentage_Rma when invoice connected
--  150220  LEPESE  PRSC-5663, Added parameter putaway_event_id_ to method Inventory_Receipt_. Defined local variable putaway_event_id_ in Packed_Inventory_Receipt__
--  150220          and fetched event_id from sequence. Passed putaway_event_id_ from Packed_Inventory_Receipt__ via Inventory_Receipt__ to Inventory_Receipt___.
--  150218  RasDlk   Bug 120094, Modified Check_Insert___() and Check_Update___() to perform user allowed site check, only when it is not created automatically 
--  150218           while releasing the originating RMA. 
--  150217  SlKapl   PRFI-5582, Modified Update___, removed part of modification introduced by PRFI-3039
--  150216  JeeJlk   PRSC-6089, Modified method New to pass invoice_id_ to Customer_Order_Tax_Util_API.Get_Total_Tax_Percentage_Rma when invoice connected.
--  150215  NaLrlk   PRSC-5900, Modified Cal_Qty_To_Return_Sales_Uom to exclude Cancelled RMA lines for the calculation.
--  150208  NaLrlk   PRSC-6028, Modified Get_Tot_Returned_Scrapped_Qty() to consider WDR value for calculations.
--  150206  SlKapl   PRSC-5901, Added Return_Material_Charge_API.Recalc_Percentage_Charge_Taxes method call to Insert___, Update___, Delete___
--  150127  LEPESE   PRSC-5663, added parameter putaway_event_id_ to methods Create_Cust_Receipt___ and Inventory_Return___. Fetch putaway_event_id_
--  150127           from sequence in Unpack_Cust_Receipt__. Passed putaway_event_id_ in calls to Inventory_Part_In_Stock__API.Receive_Customer_Order_Return.
--  141217  RuLiLk   PRSC-4694, Modified method Validate_Configuration_Id___ by removing the NOT NULL of check as configuration_id_ is a not null column in return material line table.
--  141211  RuLiLk   PRSC-2695 Modified Check_Update___ to restrict configuration_id modification when RMA line is in status 'Denied' or 'Cancelled' 
--  141211           and to call Validate_Configuration_Id___(). Modified Check_Insert___ to call Validate_Configuration_Id___()
--  141126  SlKapl   PRFI-3039, Modified Update___ when tax_regime is Sales Tax
--  141126  DilMlk   Bug 117609, Modified Create_Supply_Site_Rma___() and New() in order to pass PRICE_CONV_FACTOR so that if the demand site RMA line price_conv_factor has been modified,
--  141126           it will be updated in the supply site RMA line as well in a direct return to supply site flow.
--  141124  NaLrlk   Modified Get_Tot_Returned_Scrapped_Qty() and Get_Net_Tot_Inv_Qty_To_Return to handle in inventory receipt issue serial part.
--  141116  ShKolk   PRSC-2422, Changed error message - WRONGSERIALNOINV.
--  141028  SlKapl   PRFI-3039 - renamed Get_Total_Tax_Amount to Get_Total_Tax_Amount_Curr, changed Get_Total_Tax_Amount_Base and Get_Total_Tax_Amount_Curr
--                   in order to retrieve tax amount directly from rma_line_tax_lines_tab without calculation, changed Get_Line_Total_Price,  Get_Line_Total_Price_Incl_Tax,
--                   Get_Line_Total_Base_Price, Get_Total_Base_Price_Incl_Tax to handle both setups with/without Price Including Tax used.
--  141028  MeAblk   Bug 119375, Added parameter order_no_ into the methods Cal_Qty_To_Return_Sales_Uom, Get_Co_Line_Info and modified Get_Co_Line_Info
--  141028           in order to refer the correct order no when retrieving the invoice items.
--  141028  KoDelk   Bug 119343, Modified Get_Co_Line_Data() to add CUSTOMER_PO_NO and INTERNAL_PO_NO to the attribute string.
--  141017  NaLrlk   Modified Create_Cust_Receipt___() to use complete rental when returned.
--  140908  ShVese   Added comparision for line_no, rel_no and line_item_no in cursor get_rma_lines in Inventory_Return___ and removed the comparision with part_no.
--  140818  Vwloza   Added rental validation in Check_Insert___ and Check_Update___ to stop rental objects from being connected to CO invoices.
--  140708  BudKlk   Bug 117605, Modified the method Get_Price_Info() in order to assign values to the variables sale_unit_price_  and base_sale_unit_price_ with
--  140708           the respective values of sale_price_ and base_price_ when have no line, order and additional discounts attached.
--  140702  Vwloza   Updated Create_Cust_Receipt___ by adding code to set off-rental those parts that have been returned with open rental periods.
--  140617  KoDelk   Bug 116712, Passed fee_code data sent with attr_ through Unpack_Check_Insert___ and Insert___ to Tax_Check___ not to reset value from client.
--  140613  AyAmlk   Bug 112934, Modified Check_Update___() by reversing the bug 84871 correction and adding a new condition to check whether
--  140613           there is a change in the condition_code for the error message to be raised.
--  140523  ChFolk   Modified Inventory_Return___ and Return_And_Scrap__ to create return to inventory or scrap transactions for IPD return,
--  140523           after creating RETPODIRSH transaction as to support correct current possition in part serial catalog.
--  140522  NaLrlk   Added receipt_all_ parameter to Create_Cust_Receipt___() to handle Return/Scrap Total Qty.
--  140516  NaLrlk   Modified Inventory_Return___() to validate the null location_no.
--  140317  RoJalk   Bug 114948, Modified Check_Update___() to avoid updating of the Qty to Return automatically.
--  140311  ShVese   Removed override annotation from the methods Check_Catalog_No_Ref___ and Check_Configuration_Id_Ref___.
--  140310  MADGLK   PBSA-5675 Removed PCM references.
--  140212  PraWlk   Added new method Get_Ship_Return_Qty(). Modified Get_Co_Line_Data() by calling it to set the poss_qty_to_return_ correctly when a shipment is connected to RMA.
--  140131  ChFolk   Modified Check_Delete___ to restrict deleting rma lines in state Release.
--  140108  BudKlk   Bug 114562, Modified Get_Returned_Total_Base_Price() method to return a value, when the qty_returned_inv and qty_scrapped varaibles are null.
--  140307  HimRlk   Merged Bug 110133-PIV, Modified method Get_Price_Info by changing Calculation logic of line discount amount to be consistent with discount postings.
--  131107  IsSalk   Bug 113412, Modified Get_Part_Info() in order to get catalog description from the RMA line when it is not NULL.
--  131105  SBalLK   Bug 113402, Modified Get_Price_Info() method to fetch price conversion factor when the value is 0 to avoid divide by zero error.
--  131220  NaLrlk   Modified the Get_Price_Info() for rental returns to consider prices incl tax.
--  131212  CHRALK   Modified method Create_Cust_Receipt___.
--  131021  NaLrlk   Modified Account_Non_Invent___() to handle transaction ownership for non inventory rentals.
--  131021  RoJalk   Corrected code indentation issues after merge.
--  130927  KaNilk   Modified Create_Cust_Receipt___ method.
--  130111  HimRlk   Modified Get_Total_Tax_Amount_Base() and Get_Total_Tax_Amount() to calculate the total tax amount by taking the
--  130111  HimRlk   total tax percentage when use_price_incl_tax is true.
--  120921  HimRlk   Modified Modify_Fee_Code___, Update___ to recalculate prices after tax changes.
--  120918  ShKolk   Modified Get_Total_Tax_Amount() to consider use_price_incl_tax value. Added Get_Total_Tax_Amount_Base().
--  120914  HimRlk   Added Get_Total_Base_Price_Incl_Tax() and Get_Line_Total_Price_Incl_Tax().
--  120913  ShKolk   Modified Get_Price_Info() to consider prices incl tax in calculations.
--  120912  ShKolk   Added public columns unit_price_incl_tax and base_unit_price_incl_tax.
--  130826  CHRALK   Modified Inventory_Return__() by filtering delivered quantity with lot_batch_no column.
--  130826  PeSuLK   Added new implementation method Inventory_Return___. Moved the functionality that was in Inventory_Return__ to the new method.
--  130812  CHRALK   Modified Inventory_Return__() by adding validation for returned quantity.
--  130806  CHRALK   Modified Sales_Part_API.Exist() method call by passing sales type paramter.
--  130722  NaSalk   Modified Create_Cust_Receipt___ to check for status changes in the connected customer order for rental lines.
--  130617  PeSulk   Added new columns rental, rental_db to RETURN_MATERIAL_JOIN_UIV.
--  130610  NaLrlk   Added part_ownership_db and owning_vendor_no parameters to Inventory_Return__ to support for rental CO lines.
--  130522  NaLrlk   Added Unpack_Cust_Receipt__ and Create_Cust_Receipt___ to create customer receipts for rma lines.
--  130521  NaSalk   Added method Cal_Qty_To_Return_Sales_Uom.
--  130515  PeSulk   Added new view RECEIVED_PARTS_ORDER_DEL.
--  130510  NaSalk   Added new column rental.  Altered return_reason_code to be nullable. Modified Approve_For_Credit__ and Get_Price_Info.
--  130510  NaSalk   Added new column rental.  Altered return_reason_code to be nullable.
--  121231  THTHLK   Modified Valid_Customer_Order_Line___. Added not allowed Part_Ownerships.
--  130709  ChJalk   TIBE-1017, Removed global variables inst_EquipmentSerialUtil_, inst_PurOrderExchangeComp_, inst_PurchaseOrderLine_, inst_Jinsui_ and inst_PurOrdChargedComp_.
--  130904  ChFolk   Modified Create_Dir_Ret_Transaction___ to inter connect RETPODIRSH transaction with corresponding PODIRSH transaction to support transaction revaluation.
--  130828  ChFolk   Modified Account_Non_Invent___ to get the cost from external cust order when non inv parts are returned to any site than delivered site.
--  130828  ChFolk   Modified Create_Supply_Site_Rma___ to include configuration_id from originating rma to receipt rma.
--  130826  ChFolk   Modified Create_Supply_Site_Rma___ to release the receipt site rma line.
--  130730  ChFolk   Added new parameter delivery_trans_qty_sum_ to Create_Dir_Ret_Transaction___ and modified the same method to handle multiple returns when normal CO is having multiple returns.
--  130712  ChFolk   Added new method Check_Return_To_Diff_Site which checks whether the goods are return to different site than the goods are delivered. Modified Create_Dir_Ret_Transaction___
--  130712           to get the return_to_delivered_supp_ and support serial return qty.
--  130712  JeeJlk   Modified Modify_State_Replication___ to replicate update in originating rma to receipt rma.
--  130627  ChFolk   Modified Create_Dir_Ret_Transaction___ to introduce Invent_Trans_Interconnect between delivery transaction and RETINTPODS transaction.
--  130626  ChFolk   Modified Create_Dir_Ret_Transaction___ to get the return qty from inventory instead of purchasing as any site return has to be handled. Modified Create_Supply_Site_Rma___ to
--  130626           convert the quantity when uom are different. Modified Register_Direct_Return to get the po information from alter source ref info in inventory transaction.
--  130620  ChFolk   Modified Account_Non_Invent___ to support new transaction RETDIFS-NI and Modified Update___ to change the condition to restrict executing Account_Non_Invent___ at demand site
--  130620           during multi-site return handling. Added new method Modify_Po_Info__ which used to modify the stored po info in rma line when rma header return to site or return to vendor
--  130620           is changed when rma header is in state Planned.
--  130617  ChFolk   Modified Return_And_Scrap__ and Create_Dir_Ret_Transaction___ to support RETDIFSSCP transaction.
--  130614  ChFolk   Added new function Check_Return_To_Delivered_Sup which checks whether the materials are returned to the same supplier who delivered goods.
--  130614           Modified Create_Dir_Ret_Transaction___ and Inventory_Return__ to support RETDIFSREC transaction.
--  130612  ChFolk   Modified Create_Supply_Site_Rma___ to support creation of receipt rma when returning to ay site in same company.
--  130612  JeeJlk   Modified Valid_Customer_Order_Line___, Fetch_Supplier_Rtn_Reason__ to return to any site when return to site and site are in the same company.
--  130606  ChFolk   Restructure Account_Non_Invent___, Inventory_Return__, Return_And_Scrap__ and Create_Dir_Ret_Transaction___ to facilitate return to any site in the same company.
--  130606           Modified Register_Direct_Return by replacing parameter delivery_transaction_code_ with demand_transaction_code_ and modified cursor get_delivery_transactions to use
--  130606           order refs instead of alter source refs to support any type of deliveries not only IPD to return to any site in the same company.
--  130529  ChFolk   Modified Inventory_Return__ to include serial and lot batch information in Register_Direct_Return message.
--  130528  ChFolk   Modified Get_Allowed_Operations__ to enable register direct return to supplier RMB instead of Direct Return to Supplier from Internal Order Transit RMB when
--  130528           RMA site and customer aquisition site belong to different companies.
--  130514  ChFolk   Modified Return_And_Scrap__ and Register_Direct_Return to support RETDIR-SCP transaction. Added new parameter reject_code_ to Create_Dir_Ret_Transaction___.
--  130513  ChFolk   Modified Check_Delete___ to restrict deletion of receipt rma line and modified Delete___ to delete the corresponding receipt rma line when originating rma line is deleted.
--  130508  ChFolk   Modified Get_Delivery_Country_Code to get the value for delivery_country_code and it is used in view. Modified Update___ to avoid calling Account_Non_Invent___
--  130508           when return_to_vendor is not null as it is handled in Register_Direct_Return method.
--  130507  JeeJlk   Added a new method Validate_Ship_Via_Del_Term___ to validate whether Ship Via Code and Delivery Term is mandatory.
--  130506  ChFolk   Modified Valid_Customer_Order_Line___ to assign values for purchase order information when supply type is IPD. These values are used in creating receipt rma.
--  130426  ChFolk   Modified Get_Allowed_Operations__ to enable Release RMA without checking teh value for return_approver_id.
--  130419  ShKolk   Modified Account_Non_Invent___ and Register_Direct_Return to support transactions for non-inventory multi-site direct return from same company.
--  130411  ChFolk   Modified Inventory_Return__ to create RETSHIPDIR transaction in supply site after creating direct return transaction in demand site as cost of RETSHIPDIR
--  130411           is taken from direct return transaction when the part is weighted avg. Modified Register_Direct_Return and Create_Dir_Ret_Transaction___ to support RETSHIPDIR transaction.
--  130402  ChFolk   Modified Inventory_Return__, Return_And_Scrap__ and Register_Direct_Return to support transactions for multi-site direct return from same company.
--  130328  ChFolk   Modified Update___ to avoid calling Account_Non_Invent___ for non inventory return of PD and IPD as it is handled by Register_Direct_Return as it needs to pass alt_source_ref values.
--  130327  UdGnlk   Added Restrict_Multi_Site_Rma___() to check possibility to update supply site rma in multisite functionality.
--  130327           Modified Unpack_Check_Insert___() to get correct values for qty to return, qty to return inv uom in multisite functionality.
--  130322  UdGnlk   Rename Cancel_Supply_Site_Rma___() to Modify_State_Replication___() inorder to support complete action in supply site rma via demand site rma.
--  130322           Added Fetch_Supplier_Rtn_Reason__() to retrieve supplier return reason.
--  130319  UdGnlk   Added Cancel_Supply_Site_Rma___() to cancel supply site rma via demand site rma in multisite functionality.
--  130315  ChFolk   Modified Get_Converted_Qty___ to add a new parameter to_inv_part_no to handle qty conversion when demand and suplly sites are having different inv part nos.
--  130312  UdGnlk   Modified Modify_Multi_Site_Rma___() and Update___() to handle multisite modification.
--  130314  ChFolk   Added new method Get_Converted_Qty___ which converts given inv and sales qty from one site to another when same database is used. Modified Create_Supply_Site_Rma___,
--  130314           Modify_Multi_Site_Rma___, Return_And_Scrap__ and Inventory_Return__ to update the supply site modified qty in demand site rma.
--  130312  UdGnlk   Added Modify_Multi_Site_Rma___() to handle multisite modification.
--  130312           Modified Update___(), Fully_Handled___(), All_Received_Handled___() to modify quantities from supply site to demand site.
--  130311  ChFolk   Removed method Direct_Returns_From_Customer and merged with Register_Direct_Return. Modified parameters of Register_Direct_Return to support both functionalities together.
--  130307  ChFolk   Added new method Create_Dir_Ret_Transaction___ which creates direct return transactions for both inventory parts and non inventory parts. Modified
--  130307           Account_Non_Invent___, Inventory_Return__ and Return_And_Scrap__ to support multisite direct return. Restructure Register_Direct_Return to support multi-site direct returns.
--  130306  UdGnlk   Added public attributes receipt_rma_line_no and originating_rma_line_no and its public methods.
--  130306           Modified Create_Supply_Site_Rma___() to update the receipt_rma_line_no and originating_rma_line_no.
--  130228  ChFolk   Modified method call Get_Direct_Ship_Return_Qty in DIRECT_DELIVERY_RETURNS as the parameters are changed.
--  130228  UdGnlk   Modified Valid_Customer_Order_Line___() to check for NULL in IF condition.
--  130226  UdGnlk   Modified Direct_Returns_From_Customer() and Register_Direct_Return() to restructure the purchasing code.
--  130213  UdGnlk   Modified Valid_Customer_Order_Line___() to validate return to supplier when connecting customer order.
--  130211  ChFolk   Added new method Create_Supply_Site_Rma___ to call it during state transition from planned to release when need to create supply site rma. Modified state machine accordingly.
--  130211  UdGnlk   Modified Get_Allowed_Operations__() to restrict cancel and denied RMB's for supply site RMA in multi site functionality.
--  130211           Modified Unpack_Check_Update___() to raise a message when modify the qty to return.
--  130208  UdGnlk   Modified Get_Allowed_Operations__() condition of Scrap and return.
--  130206  UdGnlk   Modified DIRECT_DELIVERY_RETURNS view adding NOCHECK keywords where its missing.
--  130130  ChFolk   Replaced usages of customer_no with return_from_customer_no in rma header when getting the delivery informations.
--  130122  UdGnlk   Added Get_Supplier_Rtn_Reason() to retreive purchase return reason code.
--  130111  UdGnlk   Modified Direct_Returns_From_Customer() to change logic for spliting the quantities.
--  130111  ChFolk   Modified Register_Direct_Return to include issue_transaction_id_ when creating inventory transaction.
--  130107  UdGnlk   Modified Get_Allowed_Operations__() add a validation to Direct Return to Supplier from Internal Order Transit.
--  130104  UdGnlk   Added Direct_Returns_From_Customer() to support direct returns to external supplier from internal customer.
--  130104           Removed earlier introduce view and logic in Register_Direct_Return().
--  130101  ErFelk   Modified Valid_Customer_Order_Line___ to raise an error message when removing RMA line order number in a Release RMA.
--  121224  UdGnlk   Introduce a new view DIRECT_DELIV_RETURNS_IC.
--  121219  UdGnlk   Modified Register_Direct_Return() to support direct returns to external supplier from internal customer. Transaction code "RETPODSINT".
--  121221  GanNlk   Added validations to RMB?s in RMA line.
--  121129  ChFolk   Added new view DIRECT_DELIVERY_RETURNS to be used in Direct Returns to Supplier dialog. Modified Fully_Handled___ and All_Received_Handled___to validate qty_to_return and qty_received
--  121129           when return to supplier is used qty_returned_inv is not updated as it refers the qty returned to inventory. Modified Register_Direct_Return to support both inventory qty and sales qty returns.
--  121128  UdGnlk   Modified Register_Direct_Return() to pass supplier return reason and validate it.
--  121122  ChFolk   Modified Register_Direct_Return to support mulitple receipts.
--  121113  ChFolk   Modified Update___ to avoid calling Account_Non_Invent___ when direct return of non inv sales parts as alt_source_ref need to update.
--  121113           The corresponding inventory transaction is handled Register_Direct_Return where the alt_source_ref data is available.
--  121109  ChFolk   Modifed Register_Direct_Return to handle direct return of non inventory sales parts. Modified Account_Non_Invent___ to add alt_source_ref information
--  121109           for direct delivery return transaction.
--  121108  UdGnlk   Added purchase order line information as public attributes. Modified Unpack_Check_Insert___(), Insert___()
--  121108           Unpack_Check_Update___(), Update___() accordingly.
--  121101  UdGnlk   Modified Finite_State_Machine___() adding an action ReleaseAllowed, Valid_Customer_Order_Line___() to validate
--  121101           return to supplier functionality.
--  121026  ChFolk   Added new method Register_Direct_Return which calls when Direct Return is triggered.
--  121023  UdGnlk   Modified Get_Allowed_Operations__() to check what operations are allowed for Register Return to Supplier RMB.
--  121003  ChFolk   Modified Unpack_Check_Insert___, Unpack_Check_Update___ and Validate_Fee_Code___ to get delivery_country for single occurence address.
--  120921  NaLrlk   Modified Valid_Customer_Order_Line___(), Modify_Rma_Defaults__, Get_Ivc_Line_Data, Get_Co_Line_Data and Cal_Qty_To_Return_Inv_Uom to exclude Cancelled RMA lines.
--  120806  ChFolk   Added new function Get_Objstate which returns the rowstate of RMA Line and re-structure Unpack_Check_Update___ to give state specific errors before the validation errors.
--  120731  UdGnlk   Modified Cancel__() to add history for cancelling the particular line. Modified Unpack_Check_Update___() to raise an error.
--  120730  ChFolk   Modified Valid_Customer_Order_Line___ to validate order_no with the order_no and shipment_id entered in rma header.
--  120724  UdGnlk   Modified Get_Allowed_Operations__() to check what operations are allowed for Cancel RMB.
--  120724  UdGnlk   Modified Finite_State_Machine___() to refresh the state for cancellation functionality.
--  120719  ErFelk   Added Procedure Set_Cancel_Reason() and Cancel_Line() to save the cancellation reason and to change the state of RMA line.
--  120717  UdGnlk   Modified Get_Allowed_Operations__() to support RMB Cancel.
--  120713  UdGnlk   Added new state CANCEL and its event to support cancellation reason functionality.
--  120713  UdGnlk   Added CANCEL_REASON null column to support cancellation reason functionality.
--  130926  NWeelk   Bug 111252, Modified method Get_Price_Info to retrieve additional discount from the invoice item.
--  130925  MalLlk   Bug 111242, Removed functions Get_Co_Line_Project_Id and Get_Co_Line_Activity_Seq.
--  130916  MalLlk   Bug 111242, Added functions Get_Co_Line_Project_Id and Get_Co_Line_Activity_Seq to return project id and activity seq
--  130916           in the CO line which connected to the RMA line.
--  130912  SBalLK   Bug 112260, Modified Unpack_Check_Update___() method be restructuring export control codes.
--  130822  AyAmlk   Bug 111983, Modified Return_Lot_Serial_Allowed() by passing the part_no instead of catalog_no so that the inventory part no is send to check whether the serial no exist.
--  130808  NiDalk   Bug 111734, Modified Return_Lot_Serial_Allowed to consider scraps as well for the check.
--  130723  NWeelk   Bug 110536, Modified methods Insert___, Unpack_Check_Insert___, Update___ to raise the message CANNOTEXCEEDQTYTORET correctly.
--  130719  RuLiLk   Bug 110133, Modified method Get_Price_Info by passing base currency rounding when calculating line discount amount in base currency.
--  130710  AyAmlk   Bug 111144, Modified Receive_Lines() by constructing the code to support without Get_Rma_Key___(), the inner function defined.
--  130630  RuLiLk   Bug 110133, Modified method Get_Price_Info by changing Calculation logic of line discount amount to be consistent with discount postings.
--  130625  AyAmlk   Bug 108970, Modified Unpack_Check_Insert___(), Unpack_Check_Update___(), Cal_Qty_To_Return_Sales_Uom(),Get_Co_Line_Info(),Get_Ivc_Line_Data() and Get_Co_Line_Data()
--  130625           to add the new parameters rma_no_ and rma_line_no_ and pass their values accordingly.
--  130507  IsSalk   Bug 109597, Modified Unpack_Check_Update___() to restrict the changing of quantity to return of approved RMA lines to 0.
--  130422  NWeelk   Bug 108926, Modified methods Return_And_Scrap__ and Inventory_Return__ to set OERET-SINT and OERET-INT correctly.
--  130411  SWiclk   Bug 109080, Modified New() in order to pass the tax liability correctly.
--  130307  SudJlk   Bug 108372, Modified Update___, Return_And_Scrap__, Release__, Deny__ and Complete__ to reflect length change in RETURN_MATERIAL_HISTORY_TAB.message_text.
--  130301  SudJlk   Bug 108657, Modified Get_Ivc_Line_Data to correctly set poss_qty_to_return_ in the attribute string so that correct value is set in the RMA line without unnecessary display of info message.
--  121128  SWiclk   Bug 106608, Modified Get_Co_Line_Info() by replacing the CUSTOMER_ORDER view by CUSTOMER_ORDER_TAB when defining the customer_order_no_ variable.
--  121121  SWiclk   Bug 106608, Added RETURN_MATERIAL_JOIN and RETURN_MATERIAL_JOIN_UIV views hence added definitions of LINEOBJVERSION, LINEPKG, VIEWJOIN and VIEWJOINUIV.
--  121017  ChJalk   Added Get_Objstate.
--  120926  AyAmlk   Bug 104235, Modified Unpack_Check_Update___() to prevent setting a NULL value to qty_to_return when the RMA line state is Return Completed.
--  120711  RuLiLk   Bug 103808, Modified functions Return_And_Scrap__ and Inventory_Return__.
--  120404  ChJalk   Modified the mrthod Return_Lot_Serial_Allowed to check the existence of the serial no.
--  120305  MaMalk   Bug 99430, Added attribute inverted conversion factor to define the inventory conversion factor in an inverted way
--  120305           so the long decimal values caused by division can be avoided.
--  111215  MaMalk   Modified Insert___ to move the setting of objversion_ to the end of this procedure.
--  111205  DaZase   Changes in Inventory_Return__/Return_And_Scrap__ so new serials could be created for 'OERET-NO'/'OERET-SPNO' if checkbox stop_new_serial_in_rma on PartCatalog is unchecked.
--  111125  KiSalk   Bug 100037, Modified New by replacing NULL in parameter values of Get_Price_Info call with debit invoice line details.
--  111111  DaZase   Changes in Get_Price_Info so price will not be fetched from sales part if no order connection is created or condition code price dont exist, price will be 0 then so the user has to investigate and come up with a better price.
--  111107  JuMalk   Bug 99594, Modified Unpack_Check_Insert___, moved client side setting of qty_edited_flag_ in to server.
--  111107           It is to set the flag upon a Duplicate or a Copy/Paste of a RMA line.
--  111101  NISMLK   SMA-289, Increased eng_chg_level_ and eng_chg_in_transit_ length to VARCHAR2(6) in few method.
--  111031  Darklk   Bug 99463, Reversed the corrections of bugs 98270 and 88590.
--  110906  MaMalk   Bug 98582, Modified Unpack_Check_Insert___ and Unpack_Check_Update___ by removing a check for the invoice type because regardless
--  110906           of the invoice type it should check existence of a correction_invoice_id for the invoice_no entered into the line.
--  110818  JuMalk   Bug 94527, Modified Inventory_Return__ and Return_And_Scrap__ methods to remove serial objects which are not connected to a customer order line.
--  110818           Added dynamic method call Equipment_Serial_Utility_API.Moved_To_Issued_Cust_In_Object to check whether the rma customer is connected to the sm object.
--  110817  KiSalk   Bug 98270, Corrected the unrounded line total in Get_Price_Info.
--  110815  ChJalk   Bug 93946, Modified method Get_Co_Line_Data to include QTY_TO_RETURN_INV_UOM and remove PURCHASE_ORDER_NO. Removed IN parameter catalog_no_ in Get_Ivc_Line_Data.
--  110815           Removed variables catalog_no_ and customer_po_no_ in method Get_Co_Line_Data. Checked if the poss_qty_to_return_ is
--  110815           not zero before calculating qty_to_return_inv_uom_ in the same method.
--  110810  ErFelk   Changed the name of Return_Lot_Batch_Allowed to Return_Lot_Serial_Allowed. Added serial_no and eng_chg_level
--  110810           as parameters to that method and changed parameter lot_batch_qty_allowed_ as lot_serial_qty_allowed_.
--  110810           Removed the condition to check lot batch and serial and Open the path to non track parts also.
--  110707  AmPalk   Bug 95748, Made Return_Lot_Batch_Allowed a procedure. Added new parameters to validate returning quantity instead of lot batch connection.
--  110525  MaMalk   Modified Validate_Fee_Code___ to fetch the fee_code from the tax class for the supply country when no entry found for the delivery country.
--  110523  JuMalk   Bug 95069, Modified method Receive_Lines. Added attribute QTY_RECEIVED_INV_UOM to the attribute string.
--  110519  NWeelk   Bug 94874, Modified method Get_Total_Tax_Amount to calculate the tax_amount_ correctly.
--  110514  AmPalk   Bug 95151, Removed base price from call Rma_Line_Tax_Lines_API.Recalculate_Tax_Lines.
--  110420  MaMalk   Modified Get_Co_Line_Info and Get_Ivc_Line_Data to pass the delivery type from the invoice correctly.
--  110419  MaMalk   Added attribute Delivery_Type.
--  110316  MaMalk   Modified Validate_Fee_Code___ to execute a certain logic only when the new_fee_code_ is null.
--  110120  LaRelk   Merged lcs patch 78644 to solve existing problem in best price feature branch.
--  110224  MaMalk   Modified Unpack_Check_Update___ to set the fee code correctly when the tax liability is changed.
--  110201  MaMalk   Added parameter tax_class_id_ to Get_Price_Info and added methods Modify_Tax_Class_Id and Get_Delivery_COuntry_Code.
--  110201  MaMalk   Modified Validate_Fee_Code___ to consider the tax class for the fee code retrieval.
--  110131  Nekolk   EANE-3744  added where clause to View RETURN_MATERIAL_LINE
--  110127  MaMalk   Added Tax_Class_Id to the RMA Line.
--  101021  PraWlk   Bug 89847, Modified Inventory_Return__() by calling Inventory_Part_In_Stock_API.Receive_Customer_Order_Return().
--  100813  Ampalk   Bug 92006, Modified Get_Co_Line_Data to consider non inventory parts.
--  101021           Modified Set_Demand_Order_As_Alt_Ref___() to accept transaction ids as a collection and called
--  110126  MaMalk   Added Tax_Liability to the RMA Line.
--  100615  MaMalk   Aligned the Finite_State_Machine___ according to the generated code from the model.
--  100517  KRPELK   Merge Rose Method Documentation.
--  101021           Inventory_Transaction_Hist_API.Set_Alt_Source_Ref method in a loop over the collection. Modified
--  101021           method Return_And_Scrap__() accordingly.
--  100830  JuMalk   Bug 92678, Added return material history record when the RMA line is approved for credit and removing approval.
--  100830           Modified methods Approve_For_Credit() and Remove_Credit_Approval().
--  100813  Ampalk   Bug 92006, Modified Get_Co_Line_Data to consider non inventory parts.
--  100723  ChJalk   Bug 78644, Modified the method Cal_Qty_To_Return_Inv_Uom to ignore the total returned amount from the customer order line because that
--  100723           amount has been already considered in the return material line returns connected to that order line.
--  100721  ChJalk   Bug 78644, Modified the method Cal_Qty_To_Return_Inv_Uom to consider the total returned quantity of a particular order line
--  100721           and handled qty_to_return_inv_uom when the qty_to_return is 0. Also modified the error message ALREADYSCRAPPED.
--  100713  ChJalk   Bug 78644, Modified the methods Packed_Inventory_Return__ and Packed_Return_And_Scrap__ to handle returns and scraps from internal order transits.
--  100701  ChJalk   Bug 78644, Added new parameters line_no_, rel_no_ and line_item_no_ to the procedure Get_Co_Line_Info and
--  100701           added columns QTY_TO_RETURN_INV_UOM, QTY_RECEIVED_INV_UOM and functions Get_Qty_To_Return_Inv_Uom, Get_Qty_Received_Inv_Uom,
--  100701           Cal_Qty_To_Return_Inv_Uom and Cal_Qty_To_Return_Inv_Uom. Modified functions Valid_Customer_Order_Line___ to calculate the validation
--  100701           'qty to return exceeds the maximum qty to return' in terms of 'inventory unit of measure' and
--  100701           added parameters return_all_ and scrap_all_ to methods Return_And_Scrap__ and Inventory_Return__ respectively.
--  100419  SuThlk   Bug 89931, Added changes in Valid_Customer_Order_Line___.
--  100407  MaRalk   Modified reference by name method call to Inventory_Transaction_Hist_API.New within Return_And_Scrap__ method.
--  100406  JuMalk   Bug 88590, Used line_total_curr_unround_, line_total_unround_ when calculating sale_unit_price and base_sale_unit_price in Get_Pric_Info().
--  100406  JuMalk   Removed rounding of base_sale_unit_price and sale_unit_price.
--  100104  MaRalk   Modified Get_Client_Values___/PartiallyReceived^ReturnCompleted as Partially Received^Return Completed in order to match with the old client values.
--  100101  MaRalk   Modified the state machine according to the new developer studio template - 2.5.
--  090930  MaMalk   Removed constant state_separator_. Removed unused code in Validate_Fee_Code__, Modify_Rma_Defaults__,
--  090930           Valid_Customer_Order_Line___ and Finite_State_Init___.
--  ------------------------- 14.0.0 -------------------------------------------
--  091103  NaLrlk   Bug 86768, Merge IPR to APP75 Core.
--  090922  AmPalk   Bug 70316, Changed Get_Price_Info to round values used to calculate line total in sales currency,
--  090922           using decimal setting on RMA currency code. Modified Get_Line_Total_Base_Price to calculate the base amount using curr amount as in the invoice.
--  090922           Modified Get_Total_Tax_Amount to round tax ammount using company currency's decimal settings.
--  090921  SudJlk   Bug 85512, Modified methods Packed_Return_And_Scrap__ and Packed_Inventory_Return__ to have QTY_RECEIVED in purch UoM.
--  090901  Castse   Bug 84793, Added procedure Modify_Db_Invoice_Info.
--  090803  PraWlk   Bug 84871, Modified Unpack_Check_Update___ to raise an error when if condition code is modified
--  090803           when the RMA line is in state return completed.
--  090622  HoInlk   Bug 83802, Modified call to Get_Matched_Eng_Chg_Level in Packed_Inventory_Return__.
--  090604  HoInlk   Bug 82024, Modified method Packed_Inventory_Return__ to match engineering revisions
--  090604           when moving between sites of the same company.
--  090527  SuJalk   Bug 83173, Modified the error constant NO_SERIES_ID to NO_SERIES_ID_DEB to make the error message unique in some places and formatted the error message NO_SERIES_ID.
--  090415  SaJjlk   Bug 81673, Increased length of variable message_ to 2000 and modified text of message raised
--  090415           when removing invoice lines in method Modify_Cr_Invoice_Fields.
--  090406  MaMalk   Bug 81620, Modified method New to assign currency_rate of the RMA Line with the Customer Order Line currency_rate when it is passed through the attribute string.
--  090319  SudJlk   Bug 77435, Modified method Unpack_Check_Update___ to allow passing FALSE to Order_Coordinator_API.Exist.
--  090219  NWeelk   Bug 80212, Modified Procedure New to calculate the currency_rate correctly.
--  081215  ChJalk   Bug 77014, Modified Get_Line_Total_Base_Price replacing base_sale_unit_price with sale_unit_price * currency_rate.
--  081118  ChJalk   Bug 78537, Modified the method Valid_Customer_Order_Line___ to change the datatypes of paying_customer_ and paying_customer_addr_no_.
--  081031  ChJalk   Bug 76959, Added Function Check_Exist_Rma_For_Order_Line and modified the method New.
--  081016  SudJlk   Bug 77374, Modified Inventory_Return__ and Return_And_Scrap__ to check if serial is processed on order when transaction code is PURDIR.
--  081016  SudJlk   Bug 77768, Replaced Utility_SYS.Get_User with Fnd_Session_API.Get_Fnd_User in User_Allowed_Site_API.Exist call.
--  080624  HoInlk   Bug 69398, Removed call to Inventory_Part_Unit_Cost_API.Get_Default_Details in
--  080624           Return_And_Scrap__ and Inventory_Return__ as cost calculation is done
--  080417           within Inventory_Transaction_Hist_API.Get_Customer_Return_Cost.
--  080619  SuJalk   Bug 74353, Modified Inventory_Return__ and Return_And_Scrap__ methods to check whether serial numbers of the returning parts belong to the part configuration.
--  080701  MaJalk   Merged APP75 SP2.
--  --------------------- APP75 SP2 Merge - End --------------------------------
--  080522  MaGuse   Bug 73846, Modified method Inventory_Return__. Set activity_seq_ = 0 for supply codes PD and IPD when
--  080522           transaction_code is 'OERETURN'.
--  080512  HoInlk   Bug 72829, Extended validation in Unpack_Check_Update___ that checks if the connected PO
--  080512           is closed, to consider changes in receive, scrap and return quantities.
--  080502  HoInlk   Bug 72829, Corrected to use Logical_Unit_Is_Installed when checking if PurOrdChargedComp
--  080502           is installed. Modified error message CONPOCLOED in Validate_Conn_Purch_Line___.
--  080429  DaZase   Bug 72745, Correction in Get_Price_Info so now a non order connected rma line that is not catch unit enabled
--  080429           will always (re)fetch the price conversion factor from the sales part.
--  080428  NaLrlk   Bug 73368, Modified the methods Unpack_Check_Update___ and Update___ to move the server call
--  080428           Rma_Line_Tax_Lines_API.Modify_Fee_Code__ to Update___ method.
--  --------------------- APP75 SP2 Merge - Start ------------------------------
--  080616  JeLise   Added rebate_builder.
--  ********************************* Nice Price *****************************
--  080123  OSALLK   Bug 68763, Added method Validate_Conn_Purch_Line___.
--  080123  LEPESE   Bug 68763, Renamed Set_Po_Line_Comp_As_Alt_Ref___ into Set_Demand_Order_As_Alt_Ref___
--  080123           and changed it's implementation. Now fetches demand_ref from customer_order_line_API.
--  080123  LEPESE   Bug 68763, Added method Set_Po_Line_Comp_As_Alt_Ref___. Added calls to this
--  080123           method in Return_And_Scrap__ and Inventory_Return__.
--  071224  MaRalk   Bug 64486, Modified procedure Get_Price_Info to consider currency rate type in CO when calculate price in currency.
--  071221  SuJalk   Bug 68979, Changed more quantity comparisons to compare rounded values using the inventory calc rounding.
--  071207  SuJalk   Bug 68979, Used the Inventory Calc Rounding value to round the quantity to return.
--  071106  NaLrlk   Bug 67429, Added new method Get_Ivc_Line_Data. Modified method Get_Co_Line_Info, added call to Get_Ivc_Line_Data.
--  070918  Cpeilk   Call id 148874, Modifed methods Account_Non_Invent___, Return_And_Scrap__ and Inventory_Return__.
--  070918  JaBalk   Bug 67559, Modified method Unpack_Check_Update___ to set the value for new_fee_code_ when the fee_code has not changed.
--  070917  NaLrlk   Bug 67498, Modified the method Get_Co_Line_Data to correctly calculate the quantity to be returned.
--  070903  ChBalk   Bug 67144, In method Inventory_Return__, modified the method call to Inventory_Part_In_Stock_API.Receive_Part
--  070903           to pass the value NVL(ordrow_rec_.activity_seq,0) for the parameter activity_seq_.
--  070716  MaJalk   Bug 66505, Modified the method Update___.
--  070710  MaJalk   Bug 66182, Added function Return_Lot_Batch_Allowed.
--  070530  LEPESE   Modification to method Return_And_Scrap__ in order to specify location group
--  070530           'INT ORDER TRANSIT' when creating inventory transaction for 'OERET-SINT'.
--  070503  MaJalk   Round the variables base_sale_unit_price_, sale_unit_price_ in method Get_Price_Info.
--  070315  NaLrlk   Bug 63297, Modified Valid_Customer_Order_Line___ to raise the error messages correctly.
--  070226  MoMalk   Bug 63295, Removed Pay Tax and Tax Code conditions from FUNCTION Other_Changes_Made
--  070221  WaJalk   Bug 61985, Increased the length of variable customer_po_no_ to 50 in method Get_Co_Line_Data
--  070221           increased length of column PURCHASE_ORDER_NO in view RETURN_MATERIAL_LINE.
--  070102  NaWilk   Bug 62083, Modified the procedure Update___, inorder to handle the returned quantity.
--  061014  RaNhlk   Bug 61718, Modified Get_Price_info() to add a if condition to check the value of qty_to_return_.
--  061106  Cpeilk   DIPL606A, Removed hard coded correction invoice types and called from Company_Invoice_Info_API.
--  060914  ChBalk   Bug 59057, Modified Unpack_Check_Update___, Enabled check for modification of catch quantity through price_conv_factor.
--  060727  JaJalk   Bug 59149, Added an extra check to check whether the order is a service order in Return_And_Scrap__ and Inventory_Return__.
--  060627  ChJalk   Added IN parameter series_id_ to the method Get_Co_Line_Info and added new Function Get_Series_Info.
--  060619  ChJalk   Added IN parameter series_id_ to the method Get_Price_Info.
--  060619  MiKulk   Added debit_invoice_series_id to the VIEW RETURN_MATERIAL_LINE and Function Get().
--  060619           Modified the methods Unpack_Check_Insert___, Insert___, Unpack_Check_Update___ and Update___.
--  060619           Added Functions Get_Debit_Invoice_Series_Id.
--  060606  MaMalk   Modified Unpack_Check_Update___ to prevent the error messages given by constants VATMANDATORY and NOZSEROVATCODE being raised when
--  060606           the order or ref invoice details are changed.
--  060605  NuFilk   Bug 58066, Modified Get_Price_Info to handle price_cov_factor_ for catch unit, rearranged parameters for the method.
--  060605  MiErlk   Enlarge Description - Changed Variables Definitions.
--  060602  MaMalk   Modified Unpack_Check_Update___ to change the conditions checked to raise the error message given by constant CREINVEXIST.
--  060602  MaMalk   Modified Unpack_Check_Update___ to prevent more than one credit/correction invoice getting created for a particular RMA line.
--  060601  MiErlk   Enlarge Identity - Changed view comments - Description.
--  060526  JaBalk   Modified the condition in Unpack_Check_Update___ to raise the error INVALIDCORINVTYPE.
--  060525  JaBalk   Added info CANNOTEXCEEDQTYTORET in Insert___ and Unpack_Check_Update___.
--  060524  JaBalk   Added INVALIDCORINVTYPE to Unpack_Check_Insert___ and Unpack_Check_Update___.
--  060522  PrPrlK   Bug 54753, Modified the cursor get_creators_ref in method Get_Co_Line_Info and made changes to the function Get_Series_Info.
--  060519  MaMalk   Modified Unpack_Check_Insert___ and Unpack_Check_Update___ to prevent entering invalid invoice types for reference invoice.
--  060516  JaBalk   Modified the cursor in Get_Inv_Connected_Rma_Line_No
--  060516           with the credit_approver_id condition.
--  060516  SaRalk   Removed unused variable address_id_ and line_addr_ in procedure Validate_Fee_Code___.
--  060504  JaBalk   Modified Modify_Cr_Invoice_Fields to change the message.
--  060503  MaJalk   Bug 57459, Added col_rec_.price_conv_factor for sale_unit_price_ and base_sale_unit_price_ calculations at method Get_Price_Info.
--  060503  JaBalk   Inserted the history when credit_invoice_no is not null in Modify_Cr_Invoice_Fields.
--  060425  IsAnlk   Enlarge Supplier - Changed variable definitions.
--  060424  NuFilk   Bug 54676, Added a derived attribute update_tax_from_ship_addr. Added procedure Modify_Rma_Defaults__.
--  060424           Added function Postings_Are_Created___ . Added a new parameter ship_addr_changed_ to procedure Tax_Check___ .
--  060424           Modified Tax_Check___, Unpack_Check_Update___ and Update___.
--  060419  RoJalk   Enlarge Customer - Changed variable definitions.
--  -------------------- 13.4.0 ------------------------------------------------
--  060328  KanGlk   Modified Get_Price_Info Procedure.
--  060313  MiKulk   Modified the Validate_Fee_Code___.
--  060310  KanGlk   Modified Get_Co_Line_Data.
--  060209  MiKulk   Bug 51197, Modified the method ....
--  060306  KanGlk   Modified Unpack_Check_Update___.
--  060130  MaJalk   Bug 55610, Modified Get_Price_Info to calculate line totals and reverse the correction done by 54677.
--  060124  JaJalk   Added Assert safe annotation.
--  051213  MaJalk   Bug 54677, Modified methods Get_Line_Total_Base_Price, Get_Line_Total_Price, Get_Price_Info.
--  051207  PrPrlk   Bug 54556, Made changes in method Return_And_Scrap__ and Inventory_Return__ to enable returning of serial handled parts delivered under INTPODIRSH transactions.
--  051130  KiSalk   Bug 54837, Modified condition for lot check to raise error on condition code change, Inventory_Return__ and Return_And_Scrap__.
--  051123  KiSalk   Bug 53629, Added IN parameter condition_code_ and modified Inventory_Return__ and Return_And_Scrap__.
--  051101  MaEelk   Added Jinsui validations for the RMA Header.
--  051012  JoAnSe   Corrected assignment of owning_customer_no_ in Return_And_Scrap__
--  050928  JoAnSe   Merged DMC changes below
--  **********************  DMC End  ****************************************
--  050919  JoAnSe   Record with cost details pass to Inventory_Transaction_Hist_API.New
--                   from Return_And_Scrap__ instead of passing just an inventory value.
--  050909  JoAnSe   NULL send as value_ in call to Inventory_Part_In_Stock_API.Receive_Part
--  050908  JoAnSe   Record with cost details pass to Inventory_Part_In_Stock_API.Receive_Part
--                   instead of just a NULL value in Inventory_Return__
--  **********************  DMC Begin  ****************************************
--  050927  IsAnlk   Added customer_no_ as in parameter to Get_Price_Info and changed the code accordingly.
--  050919  MaEelk   Removed unused variables from the code.
--  050909  SaMelk   Replace 'Get_Max_Amt_Js_Trans_Batch' with 'Get_Virtual_Inv_Max_Amount'.
--  050826  SaMelk   Modified the type of the variable 'company_maximum_amt_' in Validate_Jinsui_Constraints___ method, in to NUMBER .
--  050825  NuFilk   Modified method Return_And_Scrap__, Inventory_Return__, Packed_Inventory_Return__
--  050825           and Packed_Return_And_Scrap__ to include expiration_date_ handling.
--  050824  DaZase   Added project inventory handling in method Account_Non_Invent___.
--  050803  SaMelk   Modified the error message AMTEXCEEDED.
--  050713  SaMelk   Modified the method Validate_Jinsui_Constraints___.
--  050707  ChFolk   Bug 51942, Added IN parameter transit_eng_chg_level_ into Inventory_Return__ and Return_And_Scrap__
--  050707           and use the value when modifying the transit object. Modified Packed_Inventory_Return__ and Packed_Return_And_Scrap__
--  050707           to un_pack the transit_eng_chg_level and to pass it into Inventory_Return__ and Return_And_Scrap__ respectively.
--  050706  SaMelk   Added New method Validate_Jinsui_Constraints___. Modified Insert___ and Update___ methods.
--  050704  SaLalk   Bug 51171, Added the description to the view and update the relevent methods to handle the newly added column to store the catalog description.
--  050610  LaBolk   Bug 51643, Modified Get_Price_Info to assign the correct value to price_conv_factor_.
--  050517  JoEd     Changed terms for calling Confirmed_Deliv_Return_Allowed.
--  050510  MaMalk   Bug 50891, Modified procedure Valid_Customer_Order_Line___ in order to restrict the 'Denied' records in cursor get_total_qty_returned.
--  050412  HoInlk   Bug 50153, Added Global LU Constant inst_PurchaseOrderLine_.
--  050412           Modified Check_Ex_Order_Connectable___ to allow registration of RMA when return type of connected PO is credit.
--  050404  DaZase   Added call to method Confirmed_Deliv_Return_Allowed in Valid_Customer_Order_Line___.
--  050208  VeMolk   Bug 49432, Removed the code for currency rounding from the method Get_Price_Info.
--  041221  NiRulk   Bug 48473, Converted max_qty_to_return_ in Valid_Customer_Order_Line___ to the u/m of the sales part.
--  041122  SaJjlk   Added parameter catch_qty_scrapped_ to method Return_And_Scrap__ and modified Packed_Return_and_Scrap__ for catch unit handling.
--  041116  KanGlk   Modified the Update___ procedure to include the procedure Rma_Line_Tax_Lines_API.Recalculate_Tax_Lines.
--  041112  NaWalk   Modified the if condition of Modify method.
--  041111  GeKalk   Added catch_qty_returned_ parameter to method Inventory_Return__ and modified Packed_Inventory_Return__.
--  041028  NaWalk   Removed the order_no_ parameter from the method Get_Total_Tax_Amount.
--  041025  NaWalk   Added the function Get_Total_Line_Tax_Pct.
--  041021  NaWalk   Added the FEE_CODE to the attribute string in  Get_Part_Info.
--  041019  KiSalk   Added Procedure New.
--  041018  NaWalk   Added the function Get_Total_Tax_Amount.
--  041013  SaJjlk   Modified method calls to Inventory_Part_In_Stock_API.Receive_Part to pass Null for catch_quantity.
--  040921  RaKalk   Added new parameter to pass Null for Catch_Quantity in to calls to Inventory_Transaction_Hist_API.New.
--  040915  SaJjlk   Modified method calls to Inventory_Part_In_Transit_API.Remove_From_Order_Transit to pass NULL as parameter catch quantity.
--  040913  VeMolk   Bug 46463, Modified the methods Unpack_Check_Update___, Unpack_Check_Insert___ to add code for invoice line matching.
--  040913           Modified Get_Price_Info to add the fee_code to the parameter list. Modified Get_Co_Line_Info and Get_Co_Line_Data.
--  040902  MaMalk   Bug 46768, Modified Valid_Customer_Order_Line___ to remove the variables sales_tax_or_mixed_, tax_regime_db_ and the code attached to it.
--  040824  DAYJLK   Call ID 116770, Modified parameter list to call Inventory_Part_In_Transit_API.Remove_From_Order_Transit in Inventory_Return__.
--  040817  DAYJLK   Call ID 116440, Removed handling of expiration_date_ in Packed_Inventory_Return__.
--  040624  VeMolk   Bug 43567, Modified the methods Unpack_Check_Update___, Unpack_Check_Insert___ and Get_Part_Info to remove
--  040624           the pricing logic from these methods and implemeted the complete pricing logic in the method Get_CO_Price Info
--  040624           after renaming this method as Get_Price_Info.
--  040622  NuFilk   Modified Return_And_Scrap__, Inventory_Return__ and added Packed_Inventory_Return__, Packed_Return_and_Scrap__
--  040609  Asawlk   Bug 44917, Modified Unpack_Check_Update___ and Unpack_Check_Insert___, raised an error message when a
--  040609           Condition Code is entered for Non Inventory Sales Part.
--  040607  UdGnlk   Bug 45110, Modified method Get_Part_Info by adding a new parameter and retrieval of catalog description.
--  040518  DaZaSe   Project Inventory: Added zero/null-parameters to call Inventory_Transaction_Hist_API.New,
--                   change these parameters to real Activity_Seq and Project_Id values if this functionality uses Project Inventory.
--  040511  DaZaSe   Project Inventory: Added zero-parameter to calls to different Inventory_Part_In_Stock_API methods,
--                   the parameter should be changed to a real Activity_Seq value if this functionality uses Project Inventory.
--  040318  JOHESE   Bug 43566, Removed bug fix 42525
--  040224  IsWilk   Removed SUBSTRB from the view for Unicode Changes.
--  040223  WaJalk   Bug 42525, Modified method Get_Part_Info to fetch correct prices when condition codes are used.
--  040220  RoJalk   Bug 39942, Modified Account_Non_Invent___ to include two new transactions OERETIN-NO and OERETIN-NI.
--  040209  GeKalk   Convert  CHR() to UNISTR() for UNICODE modifications.
--  040129  GeKalk   Rewrote the DBMS_SQL to Native dynamic SQL for UNICODE modifications.
--  040105  KaDilk   Bug 40561, Modified the function Valid_Customer_Order_Line___. This will check the total  qty_to_return
--  040105           in the RMA lines for the part_no with quantity shipped for the connected order line
--  031105  SaNalk   Modified messages in procedures Inventory_Return__ and Return_And_Scrap__.
--  031031  SaNalk   Modified messages in procedures Inventory_Return__ and Return_And_Scrap__.
--  031024  SaNalk   Modified the check for delivered customer orders with serial parts in procedures Inventory_Return__ and Return_And_Scrap__.
--  031020  SaNalk   Modified the check for Object states in procedure Return_And_Scrap__.Removed this check from Inventory_Return__.
--  031018  JaJalk   Modified the where clause of the cursor get_total_qty_returned in method Valid_Customer_Order_Line___.
--  031017  SaNalk   Modified procedures Inventory_Return__ and Return_And_Scrap__ to check the delivered customer orders
--  031017           and Object state of the serial part.
--  031015  SaNalk   Modified calculations in PROCEDURE Get_Co_Price_Info for Additional discount.
--  031015  JaJalk   Modified the method Modify__ to add the tax code for customers with tax regime vat or mixed.
--  031013  GaJalk   Modified the procedure Get_Co_Price_Info.
--  031008  PrJalk   Bug Fix 106224, Added missing and corrected wrong General_Sys.Init_Method calls.
--  031008  WaJalk   Modified procedure Return_And_Scrap__ to chech a customer order is connected to RMA line.
--  031007  SaNalk   Modified calculations in PROCEDURE Get_Co_Price_Info for Additional discount.
--  030918  KaDilk   Bug 38174, Added a call to PROCEDURE Check_Reserved_Serial_Part in PROCEDURE Return_And_Scrap__
--  030917  DhAalk   Bug 38646, Modified the PROCEDURE Valid_Customer_Order_Line___ to restrict saving a
--  030917           rma line when total return quantity exceeds the quantity delivered.
--  030916  SaRalk   Bug 38744, Removed the corrections done for Bug Ids 19116 and 31530.
--  030916           Also added a new public function Get_Pre_Accounting_Id.
--  030914  MiKulk   Bug 38089, Change the name of the constant in the error message BASE_PRICE_LESS_THAN_ZERO to BASE_PRICE_NEGATIVE
--  030914           in Unpack_Check_Insert___ and Unpack_Check_Update___.
--  030909  ErSolk   Bug 37860, Made changes to Undo Quantity Received in Return Material Authorization by entering negative quantity.
--  030904  PrTilk   Added new function Check_Exch_Ord_Received.  Chnaged the Privet method Check_Exch_Charge_Order__
--  030904           to public.
--  030903  PrTilk   Added new method Check_Exch_Charge_Order__.
--  030902  PrTilk   Modified methods Check_Ex_Order_Connectable___, Unpack_Check_Insert___, Unpack_Check_Update___,
--  030902           Return_And_Scrap__,Inventory_Return__, Release__.
--  030901  PrTilk   Added new method Check_Ex_Order_Connectable___. Added checks for exchange order in
--  030901           procedures Unpack_Check_Insert___, Unpack_Check_Update___.
--  030828  PrTilk   Added new transaction codes in procedures Return_And_Scrap__,Inventory_Return__.
--  030827  PrTilk   Added checks for condition code in procedures Unpack_Check_Update___,Unpack_Check_Insert___.
--  030821  PrTilk   Added checks for condition code in Unpack_Check_Insert___, Unpack_Check_Update___
--  030821           Return_And_Scrap__,Inventory_Return__.
--  030819  PrTilk   Added a new column condition_code.
--  030801  JaJalk   Performed SP4 Merge.
--  030526  GaJalk   Code review changes.
--  030522  AnJplk   Modified Valid_Customer_Order_Line___ to restrict RMA for externally owned CO lines.
--  030513  ChFolk   Modified an error message in Validate_Fee_Code__.
--  030506  ChFolk   Call ID 96789. Modified the inconsistent error messages.
--  030505  GaJalk   Modified the procedure Modify__.
--  030502  JaJaLk   Modified the Validation of the FEE_CODE in Unpack_Check_Update___.
--  030429  GaJalk   Modified the procedure Modify__.
--  030424  GaJalk   Modified the procedure Tax_Check___.
--  030423  GaJalk   Modified the procedures Validate_Fee_Code__ and Get_Part_Info.
--  030403  GaJalk   Modified procedure Tax_Check___.
--  030402  GaJalk   Changed Modify_Fee_Code to Modify_Fee_Code__.
--  030401  GaJalk   Modified Unpack_Check_Insert___ and Modify_Line__.
--  030331  GaJalk   Modified the procedures Modify__ and Tax_Check___.
--  030327  GaJalk   Modified Tax_Check__.
--  030325  GaJalk   Modified Unpack_Check_Update___ and Tax_Check__.
--  030324  GaJalk   Removed company checks inside the procedure Validate_Fee_Code__. Modified Unpack_Check_Update___.
--                   Removed company_pays_vat check inside Tax_Check___. Called Rma_Line_Tax_Lines_API.Modify_Fee_Code__ inside Modify__.
--  030320  GaJalk   Modified the procedure Unpack_Check_Update___.
--  030319  GaJalk   Modified the procedure Tax_Check___. Added the procedure Modify_Fee_Code. Modified Unpack_Check_Update___.
--  030317  GaJalk   Added the procedure Validate_Fee_Code__. Called this procedure inside Unpack_Check_Insert___ and Unpack_Check_Update___.
--  030312  GaJalk   Added the procedure Modify_Line__. Modified the procedure Unpack_Check_Insert___ to retrive the first tax code from
--                   the customer address if the Return Material Line Tax code is NULL.
--  030306  GaJalk   Modified the procedure Valid_Customer_Order_Line___ and Tax_Check___ to handle the tax regime of the customer.
--                   Modified the procedure Update___ to fetch the changed tax information in the line.
--  030128  GeKaLk   Bug 35445, Modified Get_Co_Price_Info() to re_arrange the calculations of sale_unit_price and base_sale_unit_price.
--  021125  JaBalk   Bug 34217, Raised the error message NOPRELINVOICE if preliminary invoice does not exist in the system
--  021125           and allow to remove the preliminary invoice no if it has been printed.
--  021017  JoAnSe   Removed condition_code.
--  021014  JoAnSe   Passed NULL for parameters release_no and sequence_no in call to
--                   Inventory_Transaction_Hist_API.New in Return_And_Scrap__.
--  020919  JoAnSe   Merged the IceAge bugg corrections below onto the AD 2002-3 track.
--  020904  JoAnSe   Bug 32545 Removed corrections made for bug 27482 in Get_Co_Price_Info.
--                   The correction is made in ReturnMaterial.apy instead.
--  020814  DaZa     Bug 30134, added extra sites_with_same_company handling in methods Return_And_Scrap__ and Inventory_Return__.
--  020712  NaWalk   Bug 31615, Modified the Procedure Get_Co_Price_Info ,to out put the correct discount and sale_unit_price_ values.
--  020709  JICE     Bug 31530, Added order keys for pre posting in Account_Non_Invent___.
--  020627  DaZa     Bug 30134, added transaction_code 'OERET-INT' to Inventory_Return__ and
--                   'OERET-SINT' to Return_And_Scrap__ . Also added extra errors checks to stop scrap/returns
--                   without order connection if they are in an intrastat flow.
--  020619  IsWilk   Bug 29126, Modified the cursor get_creators_ref by commenting the party_ in the where clause in the PROCEDURE Get_Co_Line_Info.
--  020508  IsWilk   Bug 29126, Modified the declaration of the parameter party_ as VARCHAR2(20) in the PROCEDURE Get_Co_Line_Info.
--  ---------------------------------- IceAge Merge End ------------------------------------
--  020816  ANLASE   Replaced Inventory_Part_Config_API.Get_Inventory_Value_By_Method with
--                   Inventory_Part_Unit_Cost_API.Get_Inventory_Value_By_Method.
--  020722  NabeUs   Changed Unpack_Check_Insert___ and Unpack_Check_Update___ to validate condition_code.
--  020628  MaEelk   Changed comments of CONDITION_CODE in RETURN_MATERIAL_LINE.
--  020621  MaEelk   Added CONDITION_CODE to the LU.
--  ******************************** AD 2002-3 Baseline ************************************
--  000326  NaWa     Bug fix 78020 ,Replaced the call to the method "Gen_Def_Key_Value_API.Decode(0)" with '0'
--  020322  AnLaSe   Bug fix 25422, Call 74329. Set transaction_code 'OERET-NC' if for componentparts
--                   with NoCharge in Inventory_Return__. Set transaction_code 'OERET-SPNC' in Return_And_Scrap___.
--  020322  JoAn     Call 79868 Tax lines on connected invoice considered in Tax_Check___
--  020320  JeLise   Bug fix 27278, Added internal function other_changes_made in Unpack_Check_Update___.
--  020315  MGUO     Call 79487, Modified Get_Co_Price_Info to get the correct rounding of sale_unit_price and base_sale_unit_price.
--  020228  RaSilk   Bug fix 27482, Added the rounding function to the Get_Co_Price_Info()
--  011120  KiSalk   Bug fix 25970. In Prepare_Insert___ modified so that VAT_DB is set to that of the RMA Header
--  011011  MaGU     Bug fix 24887. Removed corrections from bug fix 19897 in methods Get_Co_Price_Info,
--                   Get_Line_Total_Base_Price and Get_Line_Total_Price, so that price conversion factor
--                   will be used also for component parts.
--  010928  MaGu     Bug fix 24887. Removed inventory conversion factor from calculation of sales price
--                   in method Get_Co_Price_Info.
--  010919  JoAn     Bug Fix 24185 Wrong price retrived to RMA line when connected to an
--                   invoice item. Added new parameters and logic to Get_Co_Price_Info.
--  010906  Samnlk   Bug Fix 23974 ,Modify Procedure Unpack_Check_Update___
--  010906  OsAllk   Bug Fix 21360, Modified the PROCEDURE Account_Non_Invent___ to send the correct cost_ in call to Inventory_Transaction_Hist_API.New.
--  010516  PuILlk   Bug fix 21359, Modify Procedures Unpack_Check_Insert___ and Unpack_Check_Update___ to correct calculation of line totals.
--  010515  OsAllk   Bug Fix 21360,Modified the PROCEDURE Account_Non_Invent___ to fetch the cost from CO for non inv parts.
--  010424  IsWi  Bug Fix 19897, Modified the FUNCTION Get_Line_Total_Base_Price,Get_Line_Total_price.
--  010421  IsWi  Bug Fix 19897, Modified the FUNCTION Get_Line_Total_Base_Price,Get_Line_Total_price and
--                PROCEDURE Get_Co_Price_Info.
--  010413  JaBa  Bug Fix 20598,Added new global variable inst_EquipmentSerialUtil_.
--  010409  IsWi  Bug Fix 19897, Modified the FUNCTION Get_Line_Total_Base_Price,Get_Line_Total_price and
--                PROCEDURE Get_Co_Price_Info.
--  010326  IsWi  Bug Fix 19897, Removed the earlier corrections regarding Bug Id 19897 in the PROCEDURE Get_Co_Price_Info.
--  010315  JaBa  Bug Fix 19116, If the Mpccom_Accounting_API.Control_Type_Key_Rec.oe_order_no_ is null
--                assigned the order_no,line_no,rel_no,line_item_no to Mpccom_Accounting_API.Control_Type_Key_Rec in Inventory_Return__,Return_And_Scrap__.
--  010315  IsWi  Bug Fix 19897,Modified the PROCEDURE Get_Co_Price_Info to fetch the
--                correct value to sale_unit_price.
--  001128  CaSt  Added function Get_Sales_Unit_Meas.
--  001121  JakH  Added error message when user trying to approve has no connection
--                to a application person id.
--  001027  JakH  Added Part_No and modified calls to inventory in in Inventory_Return__ and Return_And_Scrap__.
--  001027  JakH  Addded configuration_id to RETURN_MATERIAL_LINE_TAB
--  000524  JoAn  Added removal of SM object in Inventory_Return__ and Return_And_Scrap__.
--                The removal is done by the new method Remove_Sm_Object___
--  000425  JoAn  Changed Get_Co_Line_Data PURCHASE_ORDER_NO returned in
--                attribute string instead of CUSTOMER_PO_NO.
--  000419  PaLj  Corrected Init_Method Errors
--  000322  JakH  Rewrote logic for checking tax, adding sales tax lines also
--                from delivery address of RMA when line is unconnected.
--  000320  JakH  CID 33888 Made fixes for illegal inserts of serialized parts.
--  000306  JoAn  CID 32927 Order_Type and RMA line keys always passed in
--                inventory transaction calls.
--  000302  JakH  Added GetPartInfo
--  000229  JakH  expiration_date added to inventory return arguments
--  000224  JakH  Changed Inquire_Operation not to complain when there is no
--                order connection. Changed so credit approver can be set until
--                a credit invoice is created.
--  000223  JakH  Added NOTE_ID to attr_ in insert___
--  000222  DaZa  Made note_id public.
--  000221  JakH  Considered  Credit_approver part of economically used info.
--  000217  JakH  Added Receive_Lines.
--  000214  JakH  Sending RMA line keays as keys to Inventory Transaction when
--                there is no order connection.
--                Removed fetching of company on several places, it is
--                fetched from the line directly instead.
--  000208  JakH  Added default for VAT_DB
--  000204  JakH  Added sales tax when specifying order charge connections.
--  000131  JakH  New Posting Events for no-order scrappings, returns and non-
--                Inventory-part returns.
--  000126  JakH  Init_Method fixes.
--  000125  JakH  Removed demand for order connections whwn crediting.
--  000119  JakH  Added Fee_code in Get_Co_Line_Info.
--  000112  JakH  Added Fee_Code and Company.
--  991228  JakH  Added entries in RMA history.
--  991220  JakH  Removed invoicing routine, moved it to InvoiceCustomerOrder
--  991207  JakH  Added approve function Approve_For_Credit__
--  991201  JakH  Get_Returned_Total_Base_Price and Get_Line_Total_Base_Price
--                changed to fetch currency and rounding info from default
--                user company
--  991112  JakH  Completing probs fixed.
--  991111  JakH  Changed Company length to 20.
--  991111  JakH  Redesigned function Get_Co_line_Info to return an attr string
--  991110  JakH  Arguments to call to transaction history corrected in
--                return_and_scrap
--  991110  JakH  Inquire_Operation__ now with pragma.
--  991109  JakH  qty_returned on CO-line is updated in inventory U/M
--  991109  JakH  Trig refresh state of head when deleting a line.
--  991108  JakH  Added refresh of head state in upon entry of denied.
--  991108  JakH  Valid_Customer_Order_Line___ takes ordrow_rec_.qty_returned
--                into account also
--  991104  JakH  Qty_To_Return allowed to update unless line credited
--  991104  JakH  Changed definition of invoice no; debit ivoice is a 50 char
--                string credit invoice no is really the credit invoice id and
--                is a number. Added parameters for w and ec in Return_And_Scrap__
--  991102  JakH  Added in inquire operation for CREDIT check to tell
--                if qty_to_return is more than the qty_invoiced on the
--                associated order prior to credit invoicing.
--  991102  JakH  Added conditions to Get_Allowed_Operations.
--  991101  JakH  Added controls and warnings.
--  991028  JakH  Renamed Closed to ReturnCompleted
--  991025  JakH  Added check against package parts
--  991025  JakH  Added postings for non inventory parts.
--  991025  JakH  Added limitations from old return.apy for inserts.
--  991025  JakH  Added check for consignment stock. Cleaned up order line
---               validation procedure.
--  991020  JakH  Added check when updating qty_received not to be less than
--                qty already handled
--  991008  JakH  Fully handled modified for non-inventory parts.
--  990811  JakH  Create
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
TYPE line_information_rec  IS RECORD (
   net_amt_base               NUMBER,
   gross_amt_base             NUMBER,
   net_amt_curr               NUMBER,
   gross_amt_curr             NUMBER,
   tax_liability_type_db      VARCHAR2(100),
   tax_amt_curr               NUMBER,
   tax_amt_base               NUMBER,
   condition                  VARCHAR2(2000),
   customers_company          VARCHAR2(20),
   customers_contract         VARCHAR2(5),
   multiple_tax_lines         VARCHAR2(5),
   credit_invoice_series_id   VARCHAR2(2000),
   credit_corr_invoice_no     VARCHAR2 (50));

TYPE line_information_arr IS TABLE OF line_information_rec;

TYPE receive_authorized_returns_rec  IS RECORD (
   gtin_no                 VARCHAR2(20),
   return_uom              VARCHAR2(10),
   rental_no               NUMBER,
   currency_rate_final     NUMBER,
   total_base              NUMBER,
   gross_total_base        NUMBER,
   total_currency          NUMBER,
   gross_total_currency    NUMBER,
   credit_corr_invoice_no  VARCHAR2(50),
   customers_company       VARCHAR2(20),
   customers_contract      VARCHAR2(5),
   currency_rounding       NUMBER,
   condition               VARCHAR2(200),
   shortage_handling_on    VARCHAR2(30),
   shortage_exist          NUMBER,
   shortage_flag           VARCHAR2(50),
   inventory_uom           VARCHAR2(10),
   catalog_type_db         VARCHAR2(200),
   condition_code_desc     VARCHAR2(35),
   fee_code_desc           VARCHAR2(100),
   head_state              VARCHAR2(100));

TYPE receive_authorized_returns_arr IS TABLE OF receive_authorized_returns_rec;
-------------------- PRIVATE DECLARATIONS -----------------------------------

TYPE cust_receipt_rec IS RECORD(
   row_no                 NUMBER,
   rma_no                 NUMBER,
   rma_line_no            NUMBER,
   part_no                VARCHAR2(25),
   contract               VARCHAR2(5),
   configuration_id       VARCHAR2(50),
   expiration_date        DATE,
   location_no            VARCHAR2(35),
   lot_batch_no           VARCHAR2(20),
   serial_no              VARCHAR2(50),
   eng_chg_level          VARCHAR2(6),
   waiv_dev_rej_no        VARCHAR2(15),
   handling_unit_id       NUMBER,
   part_ownership         VARCHAR2(20),
   owning_vendor_no       VARCHAR2(20),
   qty_receipt            NUMBER,
   qty_receipt_inv        NUMBER,
   catch_qty_receipt      NUMBER,
   reject_reason          VARCHAR2(8),
   condition_code         VARCHAR2(10),
   receipt_all            VARCHAR2(5),
   date_applied           DATE,
   -- gelr:warehouse_journal, begin
   del_note_no            VARCHAR2(50),
   del_note_date          DATE,
   deliv_reason_id        VARCHAR2(20));
   -- gelr:warehouse_journal, end
TYPE cust_receipt_table IS TABLE OF cust_receipt_rec INDEX BY BINARY_INTEGER;

state_separator_   CONSTANT VARCHAR2(1)   := Client_SYS.field_separator_;


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Check_Tax_Calc_Struct_Ref___ (
   newrec_ IN OUT NOCOPY RETURN_MATERIAL_LINE_TAB%ROWTYPE )
IS
BEGIN
   Tax_Calc_Structure_API.Validate_Tax_Structure_State(newrec_.company, newrec_.tax_calc_structure_id);
END Check_Tax_Calc_Struct_Ref___;

-- Create_Supply_Site_Rma___
--   This method is to create receipt rma line from demand rma line.
PROCEDURE Create_Supply_Site_Rma___ (
   rec_  IN OUT RETURN_MATERIAL_LINE_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   rma_rec_              Return_Material_API.Public_Rec;
   supply_site_rma_no_   NUMBER;
   new_line_attr_        VARCHAR2(4000);
   int_cust_order_no_    VARCHAR2(12);
   int_co_line_no_       VARCHAR2(4);
   int_co_rel_no_        VARCHAR2(4);
   int_co_line_item_no_  NUMBER;
   inv_count_            NUMBER;
   rma_no_               NUMBER;
   receipt_rma_line_no_  NUMBER;
   line_attr_            VARCHAR2(4000);   
   int_co_line_rec_      Customer_Order_Line_API.Public_Rec;
   demand_co_line_rec_   Customer_Order_Line_API.Public_Rec;
   info_                 VARCHAR2(2000);
   same_company_         BOOLEAN := FALSE;  
   objid_                VARCHAR2(2000);
   objversion_           VARCHAR2(2000);   

BEGIN
   rma_rec_ := Return_Material_API.Get(rec_.rma_no);
   IF (rma_rec_.return_to_contract IS NOT NULL AND (rma_rec_.contract != rma_rec_.return_to_contract) AND rec_.order_no IS NOT NULL) THEN
      IF (Site_API.Get_Company(rma_rec_.return_to_contract) = Site_API.Get_Company(rma_rec_.contract)) THEN
         same_company_ := TRUE;
      END IF;

      demand_co_line_rec_ := Customer_Order_Line_API.Get(rec_.order_no, rec_.line_no, rec_.rel_no, rec_.line_item_no);

      IF (same_company_ OR
         ((rma_rec_.return_to_vendor_no IS NOT NULL) AND
          (demand_co_line_rec_.supply_site = rma_rec_.return_to_contract) AND
          (demand_co_line_rec_.vendor_no = rma_rec_.return_to_vendor_no) AND
          (demand_co_line_rec_.supply_code = 'IPD'))) THEN

         IF (rma_rec_.receipt_rma_no IS NULL) THEN
            -- create new rma header.
            Return_Material_API.Create_Supply_Site_Rma_Header(supply_site_rma_no_, rec_.rma_no, rec_.rma_line_no);

            Return_Material_API.Set_Receipt_Rma_No__(rec_.rma_no, supply_site_rma_no_);

            rma_no_ := supply_site_rma_no_;
         ELSE
            rma_no_ := rma_rec_.receipt_rma_no;
         END IF;
         -- customer order direct return
         IF ((rma_rec_.return_to_vendor_no IS NOT NULL) AND (demand_co_line_rec_.vendor_no = rma_rec_.return_to_vendor_no) AND (demand_co_line_rec_.supply_site = rma_rec_.return_to_contract) AND (demand_co_line_rec_.supply_code = 'IPD')) THEN
            Customer_Order_Line_API.Get_Custord_From_Demand_Info(int_cust_order_no_, int_co_line_no_, int_co_rel_no_, int_co_line_item_no_, rec_.po_order_no, rec_.po_line_no, rec_.po_rel_no, NULL, Order_Supply_Type_API.DB_INT_PURCH_DIR);           
            int_co_line_rec_ := Customer_Order_Line_API.Get(int_cust_order_no_, int_co_line_no_, int_co_rel_no_, int_co_line_item_no_);
            -- add rma_line into the created rma
            new_line_attr_ := Build_Attr_Create_Sup_Rma___(rec_, rma_rec_, demand_co_line_rec_, int_co_line_rec_, rma_no_);
            Customer_Order_Flow_API.Create_Rma_Line_From_Co_Line(inv_count_, receipt_rma_line_no_, int_cust_order_no_, int_co_line_no_, int_co_rel_no_, int_co_line_item_no_, new_line_attr_);

         ELSE            
            new_line_attr_ := Build_Attr_Create_Sup_Rma___(rec_, rma_rec_, demand_co_line_rec_, int_co_line_rec_, rma_no_);           
            Client_SYS.Add_To_Attr('ORDER_CONNECTED', 'FALSE', new_line_attr_);
            Return_Material_Line_API.New(info_, new_line_attr_);
            receipt_rma_line_no_ := Client_SYS.Get_Item_Value('RMA_LINE_NO', new_line_attr_);
         END IF;

         -- Update demand site RMA line with newly created supply site rma line infomation
         Client_SYS.Add_To_Attr('RECEIPT_RMA_LINE_NO', receipt_rma_line_no_, line_attr_);
         Modify_Line__(line_attr_, rec_.rma_no, rec_.rma_line_no);
         Get_Id_Version_By_Keys___(objid_, objversion_, rma_no_, receipt_rma_line_no_);
         Release__(info_, objid_, objversion_, line_attr_, 'DO');
      END IF;
   END IF;
END Create_Supply_Site_Rma___;


-- Account_Non_Invent___
--   Registers transaction for returns of non inventory parts.
PROCEDURE Account_Non_Invent___ (
   company_          IN VARCHAR2,
   rma_no_           IN NUMBER,
   rma_line_no_      IN NUMBER,
   order_no_         IN VARCHAR2,
   line_no_          IN VARCHAR2,
   rel_no_           IN VARCHAR2,
   line_item_no_     IN NUMBER,
   contract_         IN VARCHAR2,
   catalog_no_       IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   qty_returned_     IN NUMBER )
IS
   transaction_id_          NUMBER;
   accounting_id_           NUMBER;
   value_                   NUMBER;
   transaction_code_        VARCHAR2(200);
   cost_                    NUMBER;
   rma_contract_            VARCHAR2(5);
   sites_with_same_company_ BOOLEAN := FALSE;
   ordrow_rec_              Customer_Order_Line_API.Public_Rec;
   return_material_rec_     Return_Material_API.Public_Rec;
   activity_seq_            CUSTOMER_ORDER_LINE_TAB.activity_seq%TYPE;
   project_id_              CUSTOMER_ORDER_LINE_TAB.project_id%TYPE;
   originating_rma_no_      NUMBER;
   part_ownership_db_       CUSTOMER_ORDER_LINE_TAB.part_ownership%TYPE;
   org_rma_line_no_         NUMBER;
   org_message_             VARCHAR2(2000);
   inv_qty_returned_        NUMBER;
   org_sales_qty_return_    NUMBER;
   demand_site_trans_code_  VARCHAR2(10);
   org_rma_rec_             Return_Material_API.Public_Rec;
   delivered_co_line_rec_   Customer_Order_Line_API.Public_Rec;
   org_rma_line_rec_        Return_Material_Line_API.Public_Rec;
BEGIN
   return_material_rec_ := Return_Material_API.Get(rma_no_);
   rma_contract_        := Cust_Ord_Customer_API.Get_Acquisition_Site(return_material_rec_.customer_no);
   IF rma_contract_ IS NOT NULL THEN
      IF (company_ = Site_API.Get_Company(rma_contract_)) THEN
         sites_with_same_company_ := TRUE;
      END IF;
   END IF;

   originating_rma_no_ := return_material_rec_.originating_rma_no;
   IF (originating_rma_no_ IS NULL) THEN
      IF order_no_ IS NULL THEN
         IF sites_with_same_company_ THEN
            transaction_code_ := 'OERETIN-NO';
         ELSE
            transaction_code_ := 'OERET-NINO';
         END IF;
         cost_ := Sales_Part_API.Get_Cost(contract_, catalog_no_);
      ELSE
         IF sites_with_same_company_ THEN
            transaction_code_ := 'OERETIN-NI';
         ELSE
            transaction_code_ := 'OERET-NI';
         END IF;
         ordrow_rec_ := Customer_Order_line_API.Get(order_no_,line_no_,rel_no_,line_item_no_);
         IF (ordrow_rec_.rental = Fnd_Boolean_API.DB_TRUE) THEN
            part_ownership_db_ := Part_Ownership_API.DB_COMPANY_RENTAL_ASSET;
         END IF;
         cost_ := ordrow_rec_.cost;
      END IF;
   ELSE
      -- return to different site than RMA site
      org_rma_rec_      := Return_Material_API.Get(originating_rma_no_);
      org_rma_line_no_  := Get_Originating_Rma_Line_No(rma_no_, rma_line_no_);
      org_rma_line_rec_ := Return_Material_Line_API.Get(originating_rma_no_, org_rma_line_no_);

      IF (org_rma_rec_.return_to_vendor_no IS NOT NULL) THEN
         delivered_co_line_rec_ := Customer_Order_Line_API.Get(org_rma_line_rec_.order_no, org_rma_line_rec_.line_no, org_rma_line_rec_.rel_no, org_rma_line_rec_.line_item_no);
      END IF;

      IF (Site_API.Get_Company(org_rma_rec_.contract) != Site_API.Get_Company(org_rma_rec_.return_to_contract)) THEN
         IF ((org_rma_rec_.return_to_contract = NVL(delivered_co_line_rec_.supply_site, ' ')) AND (org_rma_rec_.return_to_vendor_no = NVL(delivered_co_line_rec_.vendor_no, ' '))) THEN
            transaction_code_       := 'OERET-NI';
            demand_site_trans_code_ := 'OERET-NI';
         END IF;
         ordrow_rec_ := Customer_Order_line_API.Get(order_no_,line_no_,rel_no_,line_item_no_);
         cost_       := ordrow_rec_.cost;
      ELSE
         demand_site_trans_code_ := 'RETPODIRNI';
         IF ((org_rma_rec_.return_to_contract = NVL(delivered_co_line_rec_.supply_site, ' ')) AND (org_rma_rec_.return_to_vendor_no = NVL(delivered_co_line_rec_.vendor_no, ' '))) THEN
            transaction_code_ := 'OERETIN-NI';
         ELSE
            transaction_code_ := 'RETDIFS-NI';
         END IF;
         -- getting the cost from external customer order would be enough at this point.
         ordrow_rec_       := Customer_Order_line_API.Get(org_rma_line_rec_.order_no, org_rma_line_rec_.line_no, org_rma_line_rec_.rel_no, org_rma_line_rec_.line_item_no);
         cost_             := ordrow_rec_.cost;
      END IF;
   END IF;

   activity_seq_ := NVL(ordrow_rec_.activity_seq, 0);
   project_id_   := ordrow_rec_.project_id;
   IF transaction_code_ = 'OERET-NI' THEN
      IF ordrow_rec_.supply_code = 'NO' THEN
         activity_seq_ := NULL;
         project_id_   := NULL;
      END IF;
   END IF;

   part_ownership_db_ := NVL(part_ownership_db_, Part_Ownership_API.DB_COMPANY_OWNED);

   Inventory_Transaction_Hist_API.New(transaction_id_    => transaction_id_,
                                      accounting_id_     => accounting_id_,
                                      value_             => value_,
                                      transaction_code_  => transaction_code_,
                                      contract_          => contract_,
                                      part_no_           => catalog_no_,
                                      configuration_id_  => configuration_id_,
                                      location_no_       => NULL,
                                      lot_batch_no_      => '*',
                                      serial_no_         => '*' ,
                                      waiv_dev_rej_no_   => '*' ,
                                      eng_chg_level_     => '*' ,
                                      activity_seq_      => activity_seq_,
                                      project_id_        => project_id_,
                                      source_ref1_       => to_char(rma_no_),
      								        source_ref2_       => NULL,
       								        source_ref3_       => NULL,
                                      source_ref4_       => rma_line_no_,
                                      source_ref5_       => NULL,
                                      reject_code_       => NULL,
                                      price_             => cost_,
                                      quantity_          => qty_returned_,
                                      qty_reversed_      => 0,
                                      catch_quantity_    => NULL,
                                      source_            => NULL,
                                      source_ref_type_   => Order_Type_API.Decode('RMA'),
                                      owning_vendor_no_  => NULL,
                                      part_ownership_db_ => part_ownership_db_);

   IF (transaction_id_ IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'TRANSCTNNOTEXIST: Inventory transaction could not be created.');
   END IF;

   Inventory_Transaction_Hist_API.Do_Transaction_Booking(transaction_id_, company_, 'N', NULL);

   IF(originating_rma_no_ IS NOT NULL) THEN
      -- Need to convert sales qty return with respect to demand site which will be handled later.
      org_sales_qty_return_ := qty_returned_;
      Message_SYS.Add_Attribute( org_message_, 'SALES_QTY_RETURNED', org_sales_qty_return_);
      Message_SYS.Add_Attribute( org_message_, 'SERIAL_NO', '*');
      -- just sending the null value for inv_qty_returned to support message unpack in Register_Direct_Return method.
      Message_SYS.Add_Attribute( org_message_, 'INV_QTY_RETURNED', inv_qty_returned_);

      Register_Direct_Return(originating_rma_no_, org_rma_line_no_, NULL, NULL, demand_site_trans_code_, org_message_);
   END IF;
END Account_Non_Invent___;

-- Modify_State_Replication___
--   This is to cancel or complete the supply site rma when demand site rma gets cancel or complete.
PROCEDURE Modify_State_Replication___ (
   rec_  IN OUT RETURN_MATERIAL_LINE_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   info_                 VARCHAR2(2000);
   rma_rec_              Return_Material_API.Public_Rec;
   co_line_supply_code_  CUSTOMER_ORDER_LINE_TAB.supply_code%TYPE;
   receipt_rma_state_    RETURN_MATERIAL_LINE_TAB.rowstate%TYPE;
BEGIN
   rma_rec_ := Return_Material_API.Get(rec_.rma_no);
   IF (rma_rec_.receipt_rma_no IS NOT NULL AND (rma_rec_.contract != rma_rec_.return_to_contract AND rec_.order_no IS NOT NULL)) THEN
      co_line_supply_code_ := Order_Supply_Type_API.Encode(Customer_Order_Line_API.Get_Supply_Code(rec_.order_no, rec_.line_no, rec_.rel_no, rec_.line_item_no));
      receipt_rma_state_   := Get_Objstate(rma_rec_.receipt_rma_no, rec_.receipt_rma_line_no);
      IF (receipt_rma_state_ IN ('Planned', 'Released')) THEN
         Cancel_Line(info_, rma_rec_.receipt_rma_no, rec_.receipt_rma_line_no);
         Set_Cancel_Reason(rma_rec_.receipt_rma_no, rec_.receipt_rma_line_no, rec_.cancel_reason);
      ELSIF (receipt_rma_state_ IN ('PartiallyReceived')) THEN
         Complete_Line__ (rma_rec_.receipt_rma_no, rec_.receipt_rma_line_no);
      END IF;
   END IF;
END Modify_State_Replication___;


-- Valid_Customer_Order_Line___
--   This method checks if the customer order line is valid for use on the RMA line.
PROCEDURE Valid_Customer_Order_Line___ (
   newrec_      IN OUT RETURN_MATERIAL_LINE_TAB%ROWTYPE,
   oldrec_      IN     RETURN_MATERIAL_LINE_TAB%ROWTYPE,
   insert_flag_ IN     BOOLEAN )
IS
   ordrec_                     Customer_Order_API.Public_Rec;
   ordrow_rec_                 Customer_Order_Line_API.Public_Rec;
   rma_rec_                    Return_Material_API.Public_Rec;   
   delta_qty_received_         NUMBER;
   max_qty_to_return_          NUMBER;
   order_is_changed_           BOOLEAN;
   paying_customer_            CUSTOMER_ORDER_TAB.customer_no_pay%TYPE;
   paying_customer_addr_no_    CUSTOMER_ORDER_TAB.customer_no_pay_addr_no%TYPE;
   total_qty_returned_         NUMBER;
   delta_qty_returned_         NUMBER;
   total_rma_qty_returned_     NUMBER;
   po_qty_                     NUMBER := 0;
   delta_qty_returned_inv_     NUMBER;
   total_qty_returned_inv_     NUMBER;
   total_rma_qty_returned_inv_ NUMBER;
   max_qty_to_return_inv_      NUMBER;
   order_exist_                VARCHAR2(5) := 'FALSE';
   purchase_type_              VARCHAR2(50);
   vendor_no_                  VARCHAR2(20);

   CURSOR get_total_qty_returned IS
      SELECT SUM(qty_to_return)
      FROM  RETURN_MATERIAL_LINE_TAB
      WHERE catalog_no   = newrec_.catalog_no
      AND   order_no     = newrec_.order_no
      AND   line_no      = newrec_.line_no
      AND   rel_no       = newrec_.rel_no
      AND   line_item_no = newrec_.line_item_no
      AND   rowstate NOT IN ('Denied', 'Cancelled');

   CURSOR get_total_qty_returned_rma IS
      SELECT SUM(qty_to_return)
      FROM  RETURN_MATERIAL_LINE_TAB
      WHERE catalog_no   = newrec_.catalog_no
      AND   order_no     = newrec_.order_no
      AND   line_no      = newrec_.line_no
      AND   rel_no       = newrec_.rel_no
      AND   line_item_no = newrec_.line_item_no
      AND   rma_no       = newrec_.rma_no
      AND   rma_line_no  = newrec_.rma_line_no
      AND   rowstate NOT IN ('Denied', 'Cancelled');

   CURSOR get_paycust_key IS
      SELECT customer_no_pay, customer_no_pay_addr_no
      FROM CUSTOMER_ORDER_TAB
      WHERE order_no = newrec_.order_no;

   CURSOR get_total_qty_returned_inv IS
      SELECT SUM(qty_to_return_inv_uom)
      FROM  RETURN_MATERIAL_LINE_TAB
      WHERE catalog_no   = newrec_.catalog_no
      AND   order_no     = newrec_.order_no
      AND   line_no      = newrec_.line_no
      AND   rel_no       = newrec_.rel_no
      AND   line_item_no = newrec_.line_item_no
      AND   rowstate NOT IN ('Denied', 'Cancelled');

   CURSOR get_total_qty_returned_rma_inv IS
      SELECT SUM(qty_to_return_inv_uom)
      FROM  RETURN_MATERIAL_LINE_TAB
      WHERE catalog_no   = newrec_.catalog_no
      AND   order_no     = newrec_.order_no
      AND   line_no      = newrec_.line_no
      AND   rel_no       = newrec_.rel_no
      AND   line_item_no = newrec_.line_item_no
      AND   rma_no       = newrec_.rma_no
      AND   rma_line_no  = newrec_.rma_line_no
      AND   rowstate NOT IN ('Denied', 'Cancelled');

   FUNCTION Delta_(a_ NUMBER, b_ NUMBER) RETURN NUMBER
   IS
   BEGIN
      RETURN NVL(a_, 0) - NVL(b_, 0);
   END Delta_;
BEGIN

   Trace_SYS.Field('valid insert_flag_', insert_flag_);

   rma_rec_    := Return_Material_API.Get(newrec_.rma_no);
   ordrec_     := Customer_Order_API.Get(newrec_.order_no);
   ordrow_rec_ := Customer_Order_Line_API.Get(newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
   --check whether Site and Return to site is different
   IF (rma_rec_.contract != NVL(rma_rec_.return_to_contract, Database_SYS.string_null_)) THEN
      vendor_no_:= Customer_Order_Pur_Order_API.Get_PO_Vendor_No(NULL, newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
      --Check whether Connected CO is not supplied via an internal/external supplier.
      IF (NOT(NVL(rma_rec_.return_to_vendor_no, Database_SYS.string_null_) = NVL(vendor_no_, Database_SYS.string_null_) AND ordrow_rec_.supply_code IN ('IPD','PD'))) THEN
         --If Site and Return to Site are in different company or mentioned supplier is not the one who directly delivered the CO, then RMA line can not be connected to the defined CO.
         IF ((Site_API.Get_Company(rma_rec_.contract) != Site_API.Get_Company(rma_rec_.return_to_contract)) AND rma_rec_.return_to_contract IS NOT NULL) THEN
            Error_SYS.Record_General(lu_name_,'RMALINEDIFFCOMPANY: The defined site and the return-to site must belong to the same company, when an RMA line is connected to a customer order line that is not directly delivered by the same supplier as specified in the Return to Site field in the RMA header.');
         ELSIF (rma_rec_.return_to_vendor_no IS NOT NULL) AND (rma_rec_.return_to_contract IS NULL) THEN
            Error_SYS.Record_General (lu_name_, 'ORDERNOTALLOWED: Each RMA line should be connected to customer order lines which have been directly delivered by the same supplier as specified in the Return to Supplier field in the RMA header.');
         END IF;
      END IF;
      IF (oldrec_.order_no IS NOT NULL) AND (newrec_.order_no IS NULL) THEN
         IF (newrec_.rowstate = 'Released') THEN
            Error_SYS.Record_General(lu_name_, 'RMALINENOTCONNECTED:  A released RMA line should be connected to a customer order line when a supplier is specified in the Return to Supplier field or a site is specified in the Return to Site field.');
         ELSIF (newrec_.rowstate = 'Planned' AND oldrec_.po_order_no IS NOT NULL) THEN
            newrec_.po_order_no := NULL;
            newrec_.po_line_no  := NULL;
            newrec_.po_rel_no   := NULL;
         END IF;
      END IF;
      IF (newrec_.order_no IS NOT NULL AND ordrow_rec_.supply_code IN ('IPD', 'PD') AND (rma_rec_.return_to_vendor_no = ordrow_rec_.vendor_no )) THEN
         Customer_Order_Pur_Order_API.Get_Purord_For_Custord(newrec_.po_order_no, newrec_.po_line_no, newrec_.po_rel_no, purchase_type_, newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
      END IF;
   END IF;

   IF (newrec_.order_no IS NOT NULL) THEN
      IF (rma_rec_.order_no IS NOT NULL AND newrec_.order_no != rma_rec_.order_no ) THEN
         Error_SYS.Record_General(lu_name_, 'CONN_TO_DIFF_ORDER: The customer order number defined in the RMA header must be the same as the one connected to the RMA line.');
      END IF;

      IF (rma_rec_.shipment_id IS NOT NULL) THEN
         order_exist_ := Shipment_Line_API.Source_Ref1_Exist(rma_rec_.shipment_id, Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER, newrec_.order_no);
         IF (order_exist_ = 'FALSE') THEN
            Error_SYS.Record_General(lu_name_, 'ORDER_NOT_EXIST: Customer order numbers entered in the RMA lines should belong to the shipment entered in the RMA header.');
         END IF;
      END IF;

      order_is_changed_ := (Str_Diff___(oldrec_.order_no, newrec_.order_no) OR
                            Str_Diff___(oldrec_.line_no, newrec_.line_no) OR
                            Str_Diff___(oldrec_.rel_no, newrec_.rel_no) OR
                            nvl(oldrec_.line_item_no, 0) != nvl(newrec_.line_item_no, 0)) OR insert_flag_;

      IF order_is_changed_ THEN
         -- eventually check for existance (or is it already done?)
         Customer_Order_Line_API.Exist(newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
      END IF;
      
      delta_qty_returned_     := newrec_.qty_to_return;
      delta_qty_returned_inv_ := newrec_.qty_to_return_inv_uom;
      
      IF (ordrow_rec_.supply_code = 'SEO') THEN
         IF (ordrow_rec_.demand_code = 'FSM') THEN
            Error_SYS.Record_General(lu_name_, 'RMALINENOTALLOWEDFSM: Returning or scrapping is not allowed for order connected lines with the demand code Field Service Management.');
         ELSE   
            Error_SYS.Record_General(lu_name_, 'RMALINENOTALLOWED: Returning or scrapping is not allowed for order connected lines with the supply code Service Order.');
         END IF;   
      END IF;

      IF rma_rec_.use_price_incl_tax  != ordrec_.use_price_incl_tax  THEN
         Error_SYS.Record_General(lu_name_, 'UNMATCHUSEPRICEINCL: The specified customer order does not match the price including tax information of the RMA.');
      END IF ;

      IF insert_flag_ THEN
         -- insert
         delta_qty_received_ := nvl(newrec_.qty_received, 0);
      ELSE
         -- update
         delta_qty_received_ := Delta_(newrec_.qty_received, oldrec_.qty_received);
      END IF;

      OPEN get_total_qty_returned;
      FETCH get_total_qty_returned INTO total_qty_returned_;
      CLOSE get_total_qty_returned;
      total_qty_returned_ := nvl(total_qty_returned_ , 0);

      OPEN get_total_qty_returned_rma;
      FETCH get_total_qty_returned_rma INTO total_rma_qty_returned_;
      CLOSE get_total_qty_returned_rma;
      total_rma_qty_returned_ := NVL(total_rma_qty_returned_ , 0);

      OPEN get_total_qty_returned_inv;
      FETCH get_total_qty_returned_inv INTO total_qty_returned_inv_;
      CLOSE get_total_qty_returned_inv;
      total_qty_returned_inv_ := NVL(total_qty_returned_inv_ , 0);

      OPEN get_total_qty_returned_rma_inv;
      FETCH get_total_qty_returned_rma_inv INTO total_rma_qty_returned_inv_;
      CLOSE get_total_qty_returned_rma_inv;
      total_rma_qty_returned_inv_ := NVL(total_rma_qty_returned_inv_ , 0);

      max_qty_to_return_     := (ordrow_rec_.qty_shipped / ordrow_rec_.conv_factor * ordrow_rec_.inverted_conv_factor) - total_qty_returned_ + total_rma_qty_returned_;
      max_qty_to_return_inv_ := ordrow_rec_.qty_shipped  - total_qty_returned_inv_ + total_rma_qty_returned_inv_;

      -- Check the PO receipts to find any utilized material and correct the maximum return qty.
      IF (ordrow_rec_.demand_code = 'PO') THEN
         $IF Component_Purch_SYS.INSTALLED $THEN
            po_qty_ := Pur_Ord_Charged_Comp_API.Get_Received_Qty(ordrow_rec_.demand_order_ref1,
                                                                 ordrow_rec_.demand_order_ref2,
                                                                 ordrow_rec_.demand_order_ref3,
                                                                 ordrow_rec_.demand_order_ref4);
         $END
         IF (po_qty_ > 0) THEN
            max_qty_to_return_ := max_qty_to_return_ - po_qty_;
         END IF;
      END IF;

      -- The quantity returned is compared with the quantity available to return
      IF (delta_qty_returned_ > max_qty_to_return_) AND (delta_qty_returned_inv_ > max_qty_to_return_inv_ ) THEN
         IF ((ordrow_rec_.demand_code = 'PO') AND (po_qty_ > 0)) THEN
            Error_SYS.Record_General(lu_name_, 'TOOMANYDUETOPO: The quantity to return exceeds the quantity available for return due to purchase order receipt(s). Check the purchase order line :P1-:P2-:P3.',ordrow_rec_.demand_order_ref1, ordrow_rec_.demand_order_ref2, ordrow_rec_.demand_order_ref3);
         ELSE
            Error_SYS.Record_General(lu_name_, 'TOMUCHTORET: The quantity to return exceeds the maximum quantity to return = :P1',
                                     to_char(max_qty_to_return_));
         END IF;
      END IF;

      -- validate against Consignment stock parts consumed
      IF (ordrow_rec_.consignment_stock = 'CONSIGNMENT STOCK') THEN
         Deliver_Customer_Order_API.Consign_Stock_Return_Allowed(newrec_.order_no, newrec_.line_no,
            newrec_.rel_no, newrec_.line_item_no, delta_qty_received_ * newrec_.conv_factor/newrec_.inverted_conv_factor);
      END IF;

      -- validate against Delivery Confirmed qty if Delay COGS is set
      IF (ordrec_.delay_cogs_to_deliv_conf = 'TRUE') THEN
         Deliver_Customer_Order_API.Confirmed_Deliv_Return_Allowed(newrec_.order_no, newrec_.line_no,
            newrec_.rel_no, newrec_.line_item_no, delta_qty_received_ * newrec_.conv_factor/newrec_.inverted_conv_factor);
      END IF;

      IF NOT ((ordrow_rec_.contract = newrec_.contract) AND
              (ordrow_rec_.catalog_no = newrec_.catalog_no) AND
              (ordrec_.customer_no = rma_rec_.customer_no) AND
              (ordrec_.currency_code = rma_rec_.currency_code) AND
              (ordrow_rec_.rowstate IN ('Delivered', 'PartiallyDelivered', 'Invoiced'))) THEN
         Error_SYS.Record_General(lu_name_, 'ORDLINENOTVALID: This customer order line is not valid for use on this RMA line.');
      END IF;

      IF order_is_changed_ THEN

         OPEN get_paycust_key;
         FETCH get_paycust_key INTO paying_customer_, paying_customer_addr_no_;
         CLOSE get_paycust_key;

         IF (nvl(rma_rec_.customer_no_credit, '*') != nvl(paying_customer_, '*')) THEN

            IF (paying_customer_ IS NULL) THEN
               paying_customer_ := rma_rec_.customer_no;
            END IF;

            Client_SYS.Add_Warning(lu_name_, 'RMADIFFPAY: Customer order line was paid by customer :P1',
                                   p1_ => paying_customer_);

         ELSIF (rma_rec_.customer_no_credit_addr_no != paying_customer_addr_no_) THEN
            Client_SYS.Add_Warning(lu_name_, 'RMADIFFPAYADR: The paying Customer Address No for this order line; :P1, ' || chr(10) ||
                                             'is not the same as the one to be credited; :P2, ',
                                             p1_ => paying_customer_addr_no_, p2_ => rma_rec_.customer_no_credit_addr_no);
         END IF;
         IF (oldrec_.credit_approver_id IS NOT NULL AND newrec_.rental = Fnd_Boolean_API.DB_TRUE) THEN
            Error_SYS.Appl_General(lu_name_, 'INVALIDORDERLINE: RMA line cannot be connected to a rental customer order line when it is approved for credit.');
         END IF;
      END IF;
      IF (ordrow_rec_.part_ownership IN (Part_Ownership_API.DB_CUSTOMER_OWNED,
                                         Part_Ownership_API.DB_SUPPLIER_LOANED)) THEN
         Error_SYS.Appl_General(lu_name_, 'RMAEXTORDLINE: RMA is not allowed for externally owned customer order lines.');
      END IF;
   END IF;
END Valid_Customer_Order_Line___;


-- Tax_Check___
--   This method checks for updates of sales tax lines
PROCEDURE Tax_Check___ (
   newrec_            IN OUT RETURN_MATERIAL_LINE_TAB%ROWTYPE,
   oldrec_            IN     RETURN_MATERIAL_LINE_TAB%ROWTYPE,
   insert_flag_       IN     BOOLEAN,
   ship_addr_changed_ IN     BOOLEAN,
   reset_tax_code_    IN     BOOLEAN )
IS
   order_exists_       BOOLEAN;
   invoice_exists_     BOOLEAN;
   rma_rec_            Return_Material_API.Public_Rec;
   invoice_id_         NUMBER;
BEGIN
   order_exists_   := newrec_.order_no IS NOT NULL;
   invoice_exists_ := newrec_.debit_invoice_no IS NOT NULL;

   IF invoice_exists_ THEN
      -- Retrive the invoice id corresponding to debit invoice no
      invoice_id_ := Customer_Order_Inv_Head_API.Get_Invoice_Id_By_No(newrec_.company, newrec_.debit_invoice_no, newrec_.debit_invoice_series_id);
   END IF;

   rma_rec_ := Return_Material_API.Get(newrec_.rma_no);
   IF (order_exists_ OR invoice_exists_) THEN
      Transfer_Tax_lines___(newrec_ , oldrec_, insert_flag_, reset_tax_code_);
   ELSIF (insert_flag_ AND reset_tax_code_) THEN
      IF NOT (ship_addr_changed_) THEN
         IF (rma_rec_.originating_rma_no IS NULL) THEN
            Add_Transaction_Tax_Info___ (newrec_,  
                                         newrec_.company,                                      
                                         rma_rec_.return_from_customer_no,
                                         rma_rec_.ship_addr_no,                                      
                                         rma_rec_.supply_country,                                        
                                         rma_rec_.use_price_incl_tax,
                                         rma_rec_.currency_code,                                       
                                         tax_from_defaults_ => reset_tax_code_,                                      
                                         add_tax_lines_     => TRUE,
                                         attr_              => NULL);            
         ELSE   
            -- When the RMA is created for the second site, created customers tax information should be fetched. Therefore default delivery address of that customer was taken.
            Add_Transaction_Tax_Info___ (newrec_,  
                                         newrec_.company,                                      
                                         rma_rec_.customer_no,
                                         Customer_Info_Address_API.Get_Default_Address(rma_rec_.customer_no, Address_Type_Code_API.Decode('DELIVERY')),                                      
                                         rma_rec_.supply_country,                                        
                                         rma_rec_.use_price_incl_tax,
                                         rma_rec_.currency_code,                                       
                                         tax_from_defaults_ => reset_tax_code_,                                      
                                         add_tax_lines_     => TRUE,
                                         attr_              => NULL);
         END IF;                     
      END IF;
   ELSIF (insert_flag_ AND NOT reset_tax_code_) THEN
      Add_Transaction_Tax_Info___ (newrec_,  
                                   newrec_.company,                                      
                                   rma_rec_.customer_no,
                                   rma_rec_.ship_addr_no,                                      
                                   rma_rec_.supply_country,                                        
                                   rma_rec_.use_price_incl_tax,
                                   rma_rec_.currency_code,                                       
                                   tax_from_defaults_ => reset_tax_code_,                                      
                                   add_tax_lines_     => TRUE,
                                   attr_              => NULL); 
   END IF;

   -- When delivery address is changed, changes to be applied to
   -- appropriate RMA lines.
   -- i.e. RMA line should not have a connection to a order no , debit invoice no or
   -- a credit invoice no
   IF ship_addr_changed_  THEN
      IF Get_Tax_Liability_Type_Db(newrec_.rma_no, newrec_.rma_line_no) != 'EXM' THEN
         IF (newrec_.order_no IS NULL AND newrec_.credit_invoice_no IS NULL
                                       AND newrec_.debit_invoice_no IS NULL) THEN
            Add_Transaction_Tax_Info___ (newrec_,  
                                         newrec_.company,                                      
                                         rma_rec_.customer_no,
                                         rma_rec_.ship_addr_no,                                      
                                         rma_rec_.supply_country,                                        
                                         rma_rec_.use_price_incl_tax,
                                         rma_rec_.currency_code,                                       
                                         tax_from_defaults_ => TRUE,                                      
                                         add_tax_lines_     => TRUE,
                                         attr_              => NULL);                                      
          END IF;
       END IF;
   END IF;
END Tax_Check___;


-- Str_Diff___
--   Compares two strings and takes care of possible NULL conditions.
FUNCTION Str_Diff___ (
   str1_ IN VARCHAR2,
   str2_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN nvl(str1_, ' ') != nvl(str2_, ' ');
END Str_Diff___;


-- Remove_Sm_Object___
--   Remove object in Service Management before returning into inventory
--   or scrapping. This method should be called when a return into inventory
--   or scrap is made for a part which has created an object in Service Management
--   when delivered.
PROCEDURE Remove_Sm_Object___ (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   serial_no_    IN VARCHAR2 )
IS
   ordrow_rec_ Customer_Order_Line_API.Public_Rec;
   attr_       VARCHAR2(1000);
BEGIN

   -- executing the SM-function
   $IF Component_Equip_SYS.INSTALLED $THEN
      ordrow_rec_ := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);

      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('CONTRACT', ordrow_rec_.contract, attr_);
      Client_SYS.Add_To_Attr('PART_NO', ordrow_rec_.part_no, attr_);
      Client_SYS.Add_To_Attr('CONFIGURATION_ID', ordrow_rec_.configuration_id, attr_);
      Client_SYS.Add_To_Attr('SERIAL_NO', serial_no_, attr_);

      Client_SYS.Add_To_Attr('CUSTOMER_NO', Customer_Order_API.Get_Customer_No(order_no_), attr_);
      Client_SYS.Add_To_Attr('ORDER_NO', order_no_, attr_);
      Client_SYS.Add_To_Attr('LINE_NO', line_no_, attr_);
      Client_SYS.Add_To_Attr('REL_NO', rel_no_, attr_);
      Client_SYS.Add_To_Attr('LINE_ITEM_NO', line_item_no_, attr_);

      Equipment_Serial_Utility_API.Remove_Object(attr_);
   $ELSE
      NULL;
   $END
END Remove_Sm_Object___;


-- Check_Ex_Order_Connectable___
--   Checks if  exchange order can be connected to the RMA line when the RMA line
--   is released, returned or scraped.
PROCEDURE Check_Ex_Order_Connectable___ (
   co_order_no_      IN VARCHAR2,
   co_line_no_       IN VARCHAR2,
   co_rel_no_        IN VARCHAR2,
   co_line_item_no_  IN NUMBER,
   order_no_updated_ IN BOOLEAN )
IS   
   po_line_state_          VARCHAR2(20);
   return_qty_             NUMBER := 0;
   $IF Component_Purch_SYS.INSTALLED $THEN
      po_exc_rec_             Pur_Order_Exchange_Comp_API.Public_Rec;      
   $END
BEGIN
   $IF Component_Purch_SYS.INSTALLED $THEN
      IF (co_order_no_ IS NOT NULL) AND (Exchange_Item_API.Encode(Customer_Order_Line_API.Get_Exchange_Item(co_order_no_, co_line_no_, co_rel_no_, co_line_item_no_)) = 'EXCHANGED ITEM') THEN
         DECLARE
                      po_order_no_     VARCHAR2(12);
                      po_line_no_      VARCHAR2(4);
                      po_release_no_   VARCHAR2(4);
         BEGIN
            Pur_Order_Exchange_Comp_API.Get_Connected_Po_Info(po_order_no_, po_line_no_, po_release_no_, co_order_no_, co_line_no_, co_rel_no_, co_line_item_no_);
            po_exc_rec_            := Pur_Order_Exchange_Comp_API.Get(po_order_no_, po_line_no_, po_release_no_);
            po_line_state_         := Purchase_Order_Line_API.Get_Objstate(po_order_no_, po_line_no_, po_release_no_);
            return_qty_            := Receipt_Info_API.Get_Qty_Ret_Credit_By_Source(po_order_no_, po_line_no_, po_release_no_, NULL, Logistics_Source_Ref_Type_API.DB_PURCHASE_ORDER, NULL);
         END;
         IF (po_exc_rec_.core_deposit_credited = 'CREDITED') THEN
            IF order_no_updated_ THEN
               Error_SYS.Record_General(lu_name_,'EX_CORE_DEP_CREDITED: Not possible to register an RMA for an exchange order when the core deposit credit invoice has been registered.');
            ELSE
               Error_SYS.Record_General(lu_name_, 'REL_EX_CORE_CREDITED: Not possible to release/receive an RMA for an exchange order when the core deposit credit invoice has been registered.');
            END IF;
         END IF;

         IF (po_exc_rec_.core_deposit = 'NO CORE DEPOSIT') AND (po_line_state_ IN ('Received', 'Closed', 'Arrived')) AND (return_qty_ = 0) THEN
            IF order_no_updated_ THEN
               Error_SYS.Record_General(lu_name_,'EX_PO_ARRIVED: Not possible to register an RMA for an exchange order when the exchange purchase order has arrived.');
            ELSE
               Error_SYS.Record_General(lu_name_, 'REL_EX_PO_ARRIVED: Not possible to release/receive an RMA for an exchange order when the exchange purchase order has arrived.');
            END IF;
         END IF;
      END IF;
   $ELSE
      NULL;
   $END
END Check_Ex_Order_Connectable___;


PROCEDURE Validate_Jinsui_Constraints___(
   newrec_ IN RETURN_MATERIAL_LINE_TAB%ROWTYPE)
IS
   company_maximum_amt_ NUMBER;
   net_amount_          NUMBER;
   total_tax_           NUMBER;
   gross_line_total_    NUMBER;
   cust_ord_rec_        Customer_Order_API.Public_Rec;
   return_material_rec_ Return_Material_API.Public_Rec;
   company_             VARCHAR2(20);
BEGIN
   company_ := Site_API.Get_Company(newrec_.contract);

   $IF Component_Jinsui_SYS.INSTALLED $THEN
      company_maximum_amt_ := Js_Company_Info_API.Get_Virtual_Inv_Max_Amount(company_);
   $END

   net_amount_          := Get_Line_Total_Price(newrec_.rma_no, newrec_.rma_line_no);
   total_tax_           := Get_Total_Tax_Amount_Curr(newrec_.rma_no, newrec_.rma_line_no);
   gross_line_total_    := net_amount_+ total_tax_;

   return_material_rec_ := Return_Material_API.Get(newrec_.rma_no);

   IF (return_material_rec_.jinsui_invoice ='TRUE') THEN
      IF (gross_line_total_>company_maximum_amt_) THEN
         Error_SYS.Record_General(lu_name_, 'AMTEXCEEDED: Line Total Amount cannot be greater than the Maximum Amount for Jinsui Transfer Batch :P1 for the company :P2.',company_maximum_amt_,company_);
      END IF;
   END IF;

   IF newrec_.order_no IS NOT NULL THEN
      --check if the connected order is jinsui or not
      cust_ord_rec_ := Customer_Order_API.Get(newrec_.order_no);

         IF (return_material_rec_.jinsui_invoice ='TRUE') THEN
            IF (cust_ord_rec_.jinsui_invoice='FALSE') THEN
               Error_SYS.Record_General(lu_name_, 'JINSUINOTCONNECT: Connected Order or Invoice should be enabled for Jinsui.');
            END IF;
         ELSE
            IF (cust_ord_rec_.jinsui_invoice='TRUE') THEN
               Error_SYS.Record_General(lu_name_, 'JINSUICONNECT: Connected Order or Invoice should not be enabled for Jinsui.');
            END IF;
         END IF;
   END IF;
END Validate_Jinsui_Constraints___;


-- Validate_Ship_Via_Del_Term___
--   This method check to whether Ship Via and Delivery Term are mandetory.
PROCEDURE Validate_Ship_Via_Del_Term___(
   rma_no_   IN VARCHAR2,
   order_no_ IN VARCHAR2)
IS
   rma_rec_                  Return_Material_API.Public_Rec;
   return_addr_country_code_ return_material_tab.return_addr_country_code%TYPE;
BEGIN
   rma_rec_ := Return_Material_API.Get(rma_no_);
   IF (rma_rec_.ship_addr_flag = 'Y' AND order_no_ IS NULL AND rma_rec_.intrastat_exempt='INCLUDE' AND (rma_rec_.ship_via_code IS NULL OR rma_rec_.delivery_terms IS NULL)) THEN
      return_addr_country_code_ := rma_rec_.return_addr_country_code;
      IF (return_addr_country_code_ IS NULL) THEN
         IF (rma_rec_.return_to_contract IS NULL) THEN
            return_addr_country_code_ := Supplier_Info_Address_API.Get_Country_Code(rma_rec_.return_to_vendor_no, rma_rec_.return_addr_no);
         ELSE
            return_addr_country_code_ := Company_Address_API.Get_Country_Db(Site_API.Get_Company(rma_rec_.return_to_vendor_no), rma_rec_.return_addr_no);
         END IF;
         IF (return_addr_country_code_ IS NULL) THEN
            return_addr_country_code_ := Company_Address_API.Get_Country_Db(Site_API.Get_Company(rma_rec_.contract), rma_rec_.return_addr_no);
         END IF;
      END IF;
      IF (return_addr_country_code_ != rma_rec_.ship_addr_country_code AND Iso_Country_API.Get_Eu_Member(return_addr_country_code_) = 'EU Member' AND Iso_Country_API.Get_Eu_Member(rma_rec_.ship_addr_country_code) = 'EU Member') THEN
         Error_SYS.Record_General(lu_name_ ,'SHIPVIADELTERMMANDETORY: Values must be defined for the ship-via and delivery terms when, the return from address is a single occurrence, the intrastat is applicable, and an RMA line exists that is not connected to a customer order line.');
      END IF;
   END IF;
END Validate_Ship_Via_Del_Term___;

-- Validate_Configuration_Id______
PROCEDURE Validate_Configuration_Id___(
   newrec_ IN RETURN_MATERIAL_LINE_TAB%ROWTYPE)
IS

BEGIN
   IF (NVL(newrec_.part_no , newrec_.catalog_no) IS NOT NULL) THEN 
      IF (newrec_.rowstate IN ('ReturnCompleted', 'PartiallyReceived', 'Received')) THEN
         Error_SYS.Record_General(lu_name_, 'CONFNOTEDITSTATE: The configuration id cannot be modified when the RMA line is in status :P1.', Finite_State_Decode__(newrec_.rowstate));
      END IF;
   END IF;    
   
   Order_Config_Util_API.Check_Configuration_Exist(NVL(newrec_.part_no, newrec_.catalog_no),
                                                   newrec_.configuration_id,
                                                   newrec_.order_no,
                                                   newrec_.line_no,
                                                   newrec_.rel_no,
                                                   newrec_.line_item_no);
                                                         
                                                      
END Validate_Configuration_Id___;


FUNCTION Postings_Are_Created___ (
   rec_ IN RETURN_MATERIAL_LINE_TAB%ROWTYPE ) RETURN BOOLEAN
IS
   salerec_ Sales_Part_API.Public_Rec;
BEGIN
   salerec_ := Sales_Part_API.Get(rec_.contract,rec_.catalog_no);

   RETURN  (rec_.credit_invoice_no IS NOT NULL) OR
           (NVL(rec_.qty_scrapped,0) > 0 ) OR ( NVL(rec_.qty_returned_inv,0) > 0 ) OR
           (( NVL(rec_.qty_received, 0) > 0) AND (salerec_.catalog_type ='NON'));
END Postings_Are_Created___;


PROCEDURE Refresh_State___ (
   rec_  IN OUT RETURN_MATERIAL_LINE_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   Return_Material_API.Refresh_State(rec_.rma_no);
END Refresh_State___;


PROCEDURE Release_Allowed___ (
   rec_  IN OUT RETURN_MATERIAL_LINE_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   Return_Material_API.Is_Release_Allowed(rec_.rma_no);
END Release_Allowed___;


FUNCTION Received___ (
   rec_ IN RETURN_MATERIAL_LINE_TAB%ROWTYPE ) RETURN BOOLEAN
IS
BEGIN
   RETURN (rec_.qty_received > 0);
END Received___;


FUNCTION Fully_Received___ (
   rec_ IN RETURN_MATERIAL_LINE_TAB%ROWTYPE ) RETURN BOOLEAN
IS
   temp_ BOOLEAN := FALSE;
BEGIN
   IF (rec_.qty_to_return_inv_uom = rec_.qty_received_inv_uom) THEN
      temp_ := TRUE;
   END IF;
   RETURN temp_;
END Fully_Received___;


FUNCTION Fully_Handled___ (
   rec_ IN RETURN_MATERIAL_LINE_TAB%ROWTYPE ) RETURN BOOLEAN
IS
   temp_              BOOLEAN := FALSE;
   suppler_category_  VARCHAR2(20) := NULL;
   return_to_vendor_no_  VARCHAR2(20);
BEGIN
   IF (Sales_Part_API.Get_Part_No(rec_.contract, rec_.catalog_no) IS NULL) THEN
      temp_ := TRUE;
   ELSE
      return_to_vendor_no_ := Return_Material_API.Get_Return_To_Vendor_No(rec_.rma_no);
      $IF Component_Purch_SYS.INSTALLED $THEN
         suppler_category_ := Supplier_Category_API.Encode(Supplier_API.Get_Category(return_to_vendor_no_));
      $ELSE
         NULL;
      $END
      -- when return to supplier qty_returned_inv is not updated as it refers the qty returned to inventory
      IF (return_to_vendor_no_ IS NOT NULL AND suppler_category_ = 'E') THEN
         IF (rec_.qty_to_return = (NVL(rec_.qty_received, 0))) THEN
            temp_ := TRUE;
         END IF;
      ELSE
         IF (rec_.qty_to_return_inv_uom = (NVL(rec_.qty_scrapped, 0) + NVL(rec_.qty_returned_inv, 0))) THEN
            temp_ := TRUE;
         END IF;
      END IF;
   END IF;

   RETURN temp_;
END Fully_Handled___;


FUNCTION All_Received_Handled___ (
   rec_ IN RETURN_MATERIAL_LINE_TAB%ROWTYPE ) RETURN BOOLEAN
IS
   temp_                   BOOLEAN := FALSE;
   suppler_category_       VARCHAR2(20) := NULL;
   return_to_vendor_no_    VARCHAR2(20);
BEGIN
   IF (Sales_Part_API.Get_Part_No(rec_.contract,rec_.catalog_no) IS NULL) THEN
      temp_ := TRUE;
   ELSE
      return_to_vendor_no_ := Return_Material_API.Get_Return_To_Vendor_No(rec_.rma_no);
      $IF Component_Purch_SYS.INSTALLED $THEN
         suppler_category_ := Supplier_Category_API.Encode(Supplier_API.Get_Category(return_to_vendor_no_));
      $ELSE
         NULL;
      $END
      -- when return to supplier qty_returned_inv is not updated as it refers the qty returned to inventory
      IF (return_to_vendor_no_ IS NOT NULL AND suppler_category_ = 'E') THEN
         IF (rec_.qty_to_return = (NVL(rec_.qty_received, 0))) THEN
            temp_ := TRUE;
         END IF;
      ELSE
         IF (rec_.qty_received_inv_uom = NVL(rec_.qty_scrapped, 0) + NVL(rec_.qty_returned_inv, 0)) THEN
            temp_ := TRUE;
         END IF;
      END IF;
   END IF;
   RETURN temp_;
END All_Received_Handled___;


PROCEDURE Set_Return_Date___ (
   rec_  IN OUT RETURN_MATERIAL_LINE_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   site_date_ DATE := Site_API.Get_Site_Date(rec_.contract);
BEGIN
   UPDATE return_material_line_tab
     SET date_returned = site_date_
     WHERE rma_no = rec_.rma_no
     AND rma_line_no = rec_.rma_line_no;

   Client_SYS.Add_To_Attr('DATE_RETURNED', site_date_, attr_);
END Set_Return_Date___;


PROCEDURE Set_Demand_Order_As_Alt_Ref___ (
   transaction_id_tab_  IN Inventory_Transaction_Hist_API.Transaction_Id_Tab,
   order_no_            IN VARCHAR2,
   line_no_             IN VARCHAR2,
   rel_no_              IN VARCHAR2,
   line_item_no_        IN NUMBER,
   order_type_db_       IN VARCHAR2 )
IS
   demand_order_ref1_ customer_order_line_tab.demand_order_ref1%TYPE;
   demand_order_ref2_ customer_order_line_tab.demand_order_ref2%TYPE;
   demand_order_ref3_ customer_order_line_tab.demand_order_ref3%TYPE;
   demand_order_ref4_ customer_order_line_tab.demand_order_ref4%TYPE;
BEGIN

   Customer_Order_Line_API.Get_Demand_Order_Info(demand_order_ref1_,
                                                 demand_order_ref2_,
                                                 demand_order_ref3_,
                                                 demand_order_ref4_,
                                                 order_no_,
                                                 line_no_,
                                                 rel_no_,
                                                 line_item_no_);
   IF (transaction_id_tab_.COUNT > 0) THEN
      FOR i IN transaction_id_tab_.FIRST..transaction_id_tab_.LAST LOOP
         Inventory_Transaction_Hist_API.Set_Alt_Source_Ref(transaction_id_tab_(i),
                                                           demand_order_ref1_,
                                                           demand_order_ref2_,
                                                           demand_order_ref3_,
                                                           demand_order_ref4_,
                                                           NULL,
                                                           order_type_db_);
      END LOOP;
   END IF;
END Set_Demand_Order_As_Alt_Ref___;

-- Match_Returns_Against_Del___
-- This method gets the delivary transactions using FIFO method,
-- try to match with return quantities and pass the values to create
-- inventory transactions and update purchase receipt returns in PD/IPD.
PROCEDURE Match_Returns_Against_Del___ (
   inv_qty_remaining_       IN OUT NUMBER,
   sales_qty_remaining_     IN OUT NUMBER,
   chk_against_tot_recpt_   IN     BOOLEAN,
   rma_no_                  IN     NUMBER,
   rma_line_no_             IN     NUMBER,
   demand_transaction_code_ IN     VARCHAR2,
   lot_batch_no_            IN     VARCHAR2,
   serial_no_               IN     VARCHAR2,
   waiv_dev_rej_no_         IN     VARCHAR2,
   eng_chg_level_           IN     VARCHAR2,
   condition_code_          IN     VARCHAR2,
   activity_seq_            IN     NUMBER,
   handling_unit_id_        IN     NUMBER,
   company_                 IN     VARCHAR2,
   location_no_             IN     VARCHAR2,
   expiration_date_         IN     DATE,
   catch_qty_returned_      IN     NUMBER,
   inv_qty_returned_        IN     NUMBER,
   reject_code_             IN     VARCHAR2 )
IS 
   org_rma_line_rec_          Return_Material_Line_API.Public_Rec;
   tmp_lot_batch_no_          VARCHAR2(20);
   tmp_waiv_dev_rej_no_       VARCHAR2(20);
   po_no_                     VARCHAR2(12);
   po_line_no_                VARCHAR2(4);
   po_rel_no_                 VARCHAR2(4);
   po_receipt_no_             NUMBER;
   delivery_trans_qty_sum_    NUMBER := 0;
   org_rma_rec_               Return_Material_API.Public_Rec;
   tmp_handling_unit_id_      NUMBER;

   CURSOR get_delivery_transactions(cust_order_no_ VARCHAR2, cust_ord_line_no_ IN VARCHAR2, cust_ord_rel_no_ IN VARCHAR2, cust_ord_line_tem_no_ IN VARCHAR2) IS
      SELECT transaction_id, alt_source_ref1, alt_source_ref2, alt_source_ref3, alt_source_ref4, lot_batch_no, waiv_dev_rej_no, eng_chg_level, condition_code, activity_seq, handling_unit_id, project_id, quantity, SUM(quantity) over() total_qty
      FROM   inventory_transaction_hist_pub
      WHERE source_ref1 = cust_order_no_
      AND   source_ref2 = cust_ord_line_no_
      AND   source_ref3 = cust_ord_rel_no_
      AND   source_ref4 = cust_ord_line_tem_no_
      AND   source_ref_type = Order_Type_API.DB_CUSTOMER_ORDER
      AND   (serial_no = serial_no_ OR serial_no_ = '*')
      AND   (lot_batch_no = tmp_lot_batch_no_ OR tmp_lot_batch_no_ IS NULL)
      AND   (waiv_dev_rej_no = tmp_waiv_dev_rej_no_ OR tmp_waiv_dev_rej_no_ IS NULL)
      AND   (handling_unit_id = tmp_handling_unit_id_ OR tmp_handling_unit_id_ = 0)
      ORDER BY transaction_id ASC;
   
BEGIN
   org_rma_line_rec_ := Return_Material_Line_API.Get(rma_no_, rma_line_no_);
   org_rma_rec_      := Return_Material_API.Get(rma_no_);

   IF NOT chk_against_tot_recpt_ THEN     
      tmp_lot_batch_no_     := lot_batch_no_;
      tmp_waiv_dev_rej_no_  := waiv_dev_rej_no_;
      tmp_handling_unit_id_ := handling_unit_id_;
   ELSE
      tmp_lot_batch_no_     := NULL;
      tmp_waiv_dev_rej_no_  := NULL;
      tmp_handling_unit_id_ := 0;
   END IF;
   -- find the necessary transaction according to FIFO method
   FOR trans_rec_ IN get_delivery_transactions(org_rma_line_rec_.order_no, org_rma_line_rec_.line_no, org_rma_line_rec_.rel_no, org_rma_line_rec_.line_item_no) LOOP
      IF (Order_Type_API.Encode(Inventory_Transaction_Hist_API.Get_Alt_Source_Ref_Type(trans_rec_.transaction_id)) = Order_Type_API.DB_CUSTOMER_ORDER_DIRECT) THEN
         po_no_         := trans_rec_.alt_source_ref1;
         po_line_no_    := trans_rec_.alt_source_ref2;
         po_rel_no_     := trans_rec_.alt_source_ref3;
         po_receipt_no_ := TO_NUMBER(trans_rec_.alt_source_ref4);
      END IF;

      IF NOT chk_against_tot_recpt_ THEN     
         delivery_trans_qty_sum_ := trans_rec_.quantity;
      ELSE
         delivery_trans_qty_sum_ := trans_rec_.total_qty;
      END IF;

      Create_Dir_Ret_Transaction___(inv_qty_remaining_,
                                    sales_qty_remaining_,
                                    trans_rec_.transaction_id,
                                    demand_transaction_code_,
                                    rma_no_,
                                    rma_line_no_,
                                    org_rma_line_rec_.order_no,
                                    org_rma_line_rec_.line_no,
                                    org_rma_line_rec_.rel_no,
                                    org_rma_line_rec_.line_item_no,
                                    po_no_,
                                    po_line_no_,
                                    po_rel_no_,
                                    po_receipt_no_,
                                    org_rma_line_rec_.part_no,
                                    org_rma_line_rec_.catalog_no,
                                    NVL(lot_batch_no_, trans_rec_.lot_batch_no),
                                    serial_no_,
                                    NVL(waiv_dev_rej_no_, trans_rec_.waiv_dev_rej_no),
                                    NVL(eng_chg_level_, trans_rec_.eng_chg_level),
                                    NVL(condition_code_, trans_rec_.condition_code),
                                    org_rma_line_rec_.configuration_id,
                                    NVL(activity_seq_, trans_rec_.activity_seq),
                                    NVL(handling_unit_id_, trans_rec_.handling_unit_id),
                                    trans_rec_.project_id,
                                    delivery_trans_qty_sum_, 
                                    chk_against_tot_recpt_,
                                    org_rma_rec_.contract,
                                    company_,
                                    org_rma_line_rec_.supplier_return_reason,
                                    location_no_,
                                    expiration_date_,
                                    catch_qty_returned_,
                                    inv_qty_returned_,
                                    reject_code_);

      IF (org_rma_line_rec_.part_no IS NOT NULL) THEN
         -- inventory part
         EXIT WHEN inv_qty_remaining_ = 0;
      ELSE
         -- non inventory part
         EXIT WHEN sales_qty_remaining_ = 0;
      END IF;	
   END LOOP;

END Match_Returns_Against_Del___;

-- Create_Dir_Ret_Transaction___
--   This method is to create inventory transaction, handle transit location and update purchase receipt returns.
--   For register direct returns for supplier functionality
PROCEDURE Create_Dir_Ret_Transaction___ (
   inv_qty_remaining_      IN OUT NUMBER,
   sales_qty_remaining_    IN OUT NUMBER,
   inv_transaction_id_     IN     NUMBER,
   transaction_code_       IN     VARCHAR2,
   rma_no_                 IN     NUMBER,
   rma_line_no_            IN     NUMBER,
   co_order_no_            IN     VARCHAR2,
   co_line_no_             IN     VARCHAR2,
   co_rel_no_              IN     VARCHAR2,
   co_line_item_no_        IN     NUMBER,
   po_order_no_            IN     VARCHAR2,
   po_line_no_             IN     VARCHAR2,
   po_rel_no_              IN     VARCHAR2,
   po_receipt_no_          IN     NUMBER,
   inv_part_no_            IN     VARCHAR2,
   calalog_no_             IN     VARCHAR2,
   lot_batch_no_           IN     VARCHAR2,
   serial_no_              IN     VARCHAR2,
   waiv_dev_rej_no_        IN     VARCHAR2,
   eng_chg_level_          IN     VARCHAR2,
   condition_code_         IN     VARCHAR2,
   configuration_id_       IN     VARCHAR2,
   activity_seq_           IN     NUMBER,
   handling_unit_id_       IN     NUMBER,
   project_id_             IN     VARCHAR2,
   delivery_trans_qty_     IN     NUMBER,
   chk_against_tot_recpt_  IN     BOOLEAN,
   contract_               IN     VARCHAR2,
   company_                IN     VARCHAR2,
   supplier_return_reason_ IN     VARCHAR2,
   location_no_            IN     VARCHAR2,
   expiration_date_        IN     DATE,
   catch_qty_returned_     IN     NUMBER,
   total_inv_qty_return_   IN     NUMBER,
   reject_code_            IN     VARCHAR2 )

IS
   inv_qty_returned_          NUMBER;
   sales_qty_returned_        NUMBER;
   part_no_                   VARCHAR2(25);
   quantity_                  NUMBER;
   catch_quantity_            NUMBER;
   price_                     NUMBER;
   transaction_id_            NUMBER;
   accounting_id_             NUMBER;
   trans_value_               NUMBER;
   alt_source_ref_type_db_    VARCHAR2(50);
   empty_cost_detail_tab_     Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   issue_transaction_id_      NUMBER;
   customer_contract_         VARCHAR2(10);
   direct_ret_trans_id_       NUMBER;
   inv_receipt_trans_id_      NUMBER;  
   receipt_rma_line_no_       NUMBER;
   receipt_contract_          VARCHAR2(5);
   receipt_rma_line_rec_      Return_Material_Line_API.Public_Rec;
   receipt_trans_code_        VARCHAR2(10);
   receipt_trans_inv_qty_     NUMBER;
   receipt_trans_sales_qty_   NUMBER;
   calc_catch_qty_returned_   NUMBER;
   message_                   VARCHAR2(2000);
   return_to_delivered_supp_  BOOLEAN := FALSE;
   alt_source_ref1_           VARCHAR2(50);
   alt_source_ref2_           VARCHAR2(50);
   alt_source_ref3_           VARCHAR2(50);
   alt_source_ref4_           VARCHAR2(50);
   direct_delivery_return_    BOOLEAN := FALSE;
   co_line_rec_               Customer_Order_Line_API.Public_Rec;
   inv_qty_return_            NUMBER;
   sales_qty_return_          NUMBER;
   inv_returned_qty_sum_      NUMBER;
   possible_qty_to_return_    NUMBER;
   receipt_qty_sum_           NUMBER := 0;
   rma_rec_                   Return_Material_API.Public_Rec;
BEGIN
   co_line_rec_ := Customer_Order_Line_API.Get(co_order_no_, co_line_no_, co_rel_no_, co_line_item_no_);

   -- for non inventory parts for PD and IPD purchase transactions are created instead of inventory transactions.
   IF (co_line_rec_.supply_code IN ('PD', 'IPD')) THEN
      direct_delivery_return_ := TRUE;
      alt_source_ref_type_db_ := Order_Type_API.DB_CUSTOMER_ORDER_DIRECT;
      alt_source_ref1_ := po_order_no_;
      alt_source_ref2_ := po_line_no_;
      alt_source_ref3_ := po_rel_no_;
      alt_source_ref4_ := po_receipt_no_;
   ELSE
      alt_source_ref_type_db_ := Order_Type_API.DB_CUSTOMER_ORDER;
      alt_source_ref1_ := co_order_no_;
      alt_source_ref2_ := co_line_no_;
      alt_source_ref3_ := co_rel_no_;
      alt_source_ref4_ := co_line_item_no_;
   END IF;

   -- Get total qty for particular receipt
   $IF (Component_Purch_SYS.INSTALLED) $THEN     
      IF direct_delivery_return_ THEN
         IF (inv_part_no_ IS NOT NULL) THEN
            -- Used Get_Inv_Qty_Arrived_By_Source() to fetch the proper inventory quantity.  
            receipt_qty_sum_ := Receipt_Info_API.Get_Inv_Qty_Arrived_By_Source( po_order_no_,
                                                                                po_line_no_,
                                                                                po_rel_no_,
                                                                                NULL,
                                                                                Logistics_Source_Ref_Type_API.DB_PURCHASE_ORDER,
                                                                                po_receipt_no_);
         ELSE
            receipt_qty_sum_ := Receipt_Info_API.Get_Qty_Arrived_By_Source( po_order_no_,
	                                                                         po_line_no_,
	                                                                         po_rel_no_,
	                                                                         NULL,
	                                                                         Logistics_Source_Ref_Type_API.DB_PURCHASE_ORDER,
	                                                                         po_receipt_no_);
         END IF;        
                                                                  
         inv_returned_qty_sum_ := Inventory_Transaction_Hist_API.Get_Rma_Multi_Site_Return_Qty(alt_source_ref1_,
	                                                                                            alt_source_ref2_,
	                                                                                            alt_source_ref3_,
	                                                                                            alt_source_ref4_,
	                                                                                            alt_source_ref_type_db_);                                                           	                                                                     	       
	      possible_qty_to_return_ := receipt_qty_sum_- inv_returned_qty_sum_;
      ELSE
         possible_qty_to_return_ := delivery_trans_qty_;     
      END IF;                                                             
   $ELSE
      receipt_qty_sum_ := 0;
      inv_returned_qty_sum_ := 0;
      possible_qty_to_return_ := delivery_trans_qty_;
   $END

   IF NOT chk_against_tot_recpt_ THEN
      inv_returned_qty_sum_ := Inventory_Transaction_Hist_API.Get_Rma_Multi_Site_Return_Qty(alt_source_ref1_,
                                                                                         alt_source_ref2_,
                                                                                         alt_source_ref3_,
                                                                                         alt_source_ref4_,
                                                                                         alt_source_ref_type_db_,
                                                                                         serial_no_,
                                                                                         waiv_dev_rej_no_,
                                                                                         lot_batch_no_,
                                                                                         handling_unit_id_);

      possible_qty_to_return_ := LEAST((delivery_trans_qty_ - inv_returned_qty_sum_), possible_qty_to_return_ );  
   END IF;

   IF (possible_qty_to_return_ > 0) THEN
      IF (inv_part_no_ IS NOT NULL) THEN
         inv_qty_return_  := LEAST(possible_qty_to_return_, inv_qty_remaining_);
         IF (possible_qty_to_return_ < 0 ) THEN
            inv_qty_return_  := 0;
         END IF;
         
         inv_qty_returned_  := inv_qty_return_;
         inv_qty_remaining_ := inv_qty_remaining_ - inv_qty_return_;
      ELSE
         sales_qty_return_  := LEAST(possible_qty_to_return_, sales_qty_remaining_);
         IF (possible_qty_to_return_ < 0) THEN
            sales_qty_return_ := 0;
         END IF;
         
         sales_qty_returned_  := sales_qty_return_;
         sales_qty_remaining_ := sales_qty_remaining_ - sales_qty_return_;
      END IF;
      
      return_to_delivered_supp_ := Check_Return_To_Delivered_Sup(rma_no_, rma_line_no_);
      
      IF (direct_delivery_return_ AND return_to_delivered_supp_) THEN
         $IF (Component_Purch_SYS.INSTALLED) $THEN
            Receive_Purchase_Order_API.Update_Rma_Return(inv_qty_returned_,
                                                         sales_qty_returned_,
                                                         po_order_no_,
                                                         po_line_no_,
                                                         po_rel_no_,
                                                         po_receipt_no_,
                                                         contract_,
                                                         inv_part_no_,
                                                         lot_batch_no_,
                                                         serial_no_,
                                                         activity_seq_,
                                                         supplier_return_reason_,
                                                         transaction_code_);
         $ELSE
            NULL;
         $END
      END IF;
      
      IF ((inv_qty_returned_ > 0) OR (sales_qty_returned_ > 0)) THEN
         IF (inv_qty_returned_ > 0) THEN
            -- inventory part return
            part_no_  := inv_part_no_;
            quantity_ := inv_qty_returned_;
         ELSE
            -- non inventory part return
            part_no_        := calalog_no_;
            quantity_       := sales_qty_returned_;
            catch_quantity_ := NULL;
            price_          := co_line_rec_.cost;
         END IF;
         
         IF (transaction_code_ = 'RETPODSINT') THEN
            issue_transaction_id_ := NULL;
         ELSE
            issue_transaction_id_ := inv_transaction_id_;
         END IF;
         Inventory_Transaction_Hist_API.New(transaction_id_         => transaction_id_,
                                            accounting_id_          => accounting_id_,
                                            value_                  => trans_value_,
                                            transaction_code_       => transaction_code_,
                                            contract_               => contract_,
                                            part_no_                => part_no_,
                                            configuration_id_       => configuration_id_,
                                            location_no_            => NULL,
                                            lot_batch_no_           => lot_batch_no_,
                                            serial_no_              => serial_no_,
                                            waiv_dev_rej_no_        => waiv_dev_rej_no_,
                                            eng_chg_level_          => eng_chg_level_,
                                            activity_seq_           => activity_seq_,
                                            handling_unit_id_       => handling_unit_id_,
                                            project_id_             => project_id_,
                                            source_ref1_            => TO_CHAR(rma_no_),
                                            source_ref2_            => NULL,
                                            source_ref3_            => NULL,
                                            source_ref4_            => rma_line_no_,
                                            source_ref5_            => NULL,
                                            reject_code_            => supplier_return_reason_,
                                            cost_detail_tab_        => empty_cost_detail_tab_,
                                            unit_cost_              => price_,
                                            quantity_               => quantity_,
                                            qty_reversed_           => 0,
                                            catch_quantity_         => catch_quantity_,
                                            source_                 => NULL,
                                            source_ref_type_        => Order_Type_API.Decode('RMA'),
                                            owning_vendor_no_       => NULL,
                                            condition_code_         => condition_code_,
                                            location_group_         => 'INT ORDER TRANSIT',
                                            part_ownership_db_      => Part_Ownership_API.DB_COMPANY_OWNED,
                                            owning_customer_no_     => NULL,
                                            expiration_date_        => expiration_date_,
                                            alt_source_ref1_        => alt_source_ref1_,
                                            alt_source_ref2_        => alt_source_ref2_,
                                            alt_source_ref3_        => alt_source_ref3_,
                                            alt_source_ref4_        => alt_source_ref4_,
                                            alt_source_ref5_        => NULL,
                                            alt_source_ref_type_db_ => alt_source_ref_type_db_,
                                            issue_transaction_id_   => issue_transaction_id_);
         
         IF (transaction_id_ IS NULL) THEN
            Error_SYS.Record_General(lu_name_, 'TRANSCTNNOTEXIST: Inventory transaction could not be created.');
         END IF;
         
         IF (transaction_code_ = 'RETINTPODS') THEN
            Invent_Trans_Interconnect_API.Connect_Transactions(issue_transaction_id_, transaction_id_, Invent_Trans_Conn_Reason_API.DB_MULTISITE_DELIVERY_RETURN);
         ELSIF (transaction_code_ = 'RETPODIRSH') THEN
            Invent_Trans_Interconnect_API.Connect_Transactions(issue_transaction_id_, transaction_id_, Invent_Trans_Conn_Reason_API.DB_RETURN_TO_SUPPLIER);
         END IF;
         
         Inventory_Transaction_Hist_API.Do_Transaction_Booking(transaction_id_, company_, 'N', NULL);
         
         rma_rec_ := Return_Material_API.Get(rma_no_);
         IF (transaction_code_ = 'RETPODSINT') THEN         
            -- Transit update
            customer_contract_ := Cust_Ord_Customer_API.Get_Acquisition_Site(rma_rec_.customer_no);
            Inventory_Part_In_Transit_API.Remove_From_Order_Transit(delivering_contract_     => customer_contract_,  
                                                                    contract_                => contract_, 
                                                                    part_no_                 => inv_part_no_,
                                                                    configuration_id_        => configuration_id_, 
                                                                    lot_batch_no_            => lot_batch_no_,
                                                                    serial_no_               => serial_no_,
                                                                    eng_chg_level_           => eng_chg_level_, 
                                                                    waiv_dev_rej_no_         => waiv_dev_rej_no_,
                                                                    handling_unit_id_        => handling_unit_id_,
                                                                    expiration_date_         => NULL,
                                                                    delivering_warehouse_id_ => '*',
                                                                    receiving_warehouse_id_  => '*',
                                                                    activity_seq_            => 0 ,
                                                                    part_ownership_db_       => Part_Ownership_API.DB_COMPANY_OWNED,
                                                                    owning_customer_no_      => '*',
                                                                    owning_vendor_no_        => '*',
                                                                    deliv_no_                => 0,
                                                                    shipment_id_             => 0,
                                                                    shipment_line_no_        => 0,
                                                                    qty_to_remove_           => inv_qty_returned_, 
                                                                    catch_qty_to_remove_     => NULL, 
                                                                    remove_unit_cost_        => FALSE);
            
            -- need to create RETSHIPDIR , RETDIR-SCP, RETDIFSREC, RETDIFSSCP transctions in supply site based on created RETINTPODS transaction created in demand site.
         ELSIF (transaction_code_ = 'RETINTPODS') THEN
            IF (reject_code_ IS NOT NULL) THEN
               IF (return_to_delivered_supp_) THEN
                  -- scrapping at supply site on direct delivery
                  receipt_trans_code_ := 'RETDIR-SCP';
               ELSE
                  -- scrapping at any site
                  receipt_trans_code_ := 'RETDIFSSCP';
               END IF;
               
            ELSE
               IF (return_to_delivered_supp_) THEN
                  -- return to supply site inventory on direct delivery
                  receipt_trans_code_ := 'RETSHIPDIR';
               ELSE
                  -- return to inventory any site
                  receipt_trans_code_ := 'RETDIFSREC';
               END IF;
            END IF;
            
            direct_ret_trans_id_  := transaction_id_;
            
            receipt_rma_line_no_  := Return_Material_Line_API.Get_Receipt_Rma_Line_No(rma_no_, rma_line_no_);
            receipt_contract_     := Return_Material_API.Get_Contract(rma_rec_.receipt_rma_no);
            
            receipt_rma_line_rec_ := Get(rma_rec_.receipt_rma_no, receipt_rma_line_no_);
            Get_Converted_Qty___(receipt_trans_inv_qty_,
                                 receipt_trans_sales_qty_,
                                 quantity_,
                                 NULL,
                                 contract_,
                                 receipt_contract_,
                                 part_no_,
                                 receipt_rma_line_rec_.part_no,
                                 receipt_rma_line_rec_.conv_factor,
                                 receipt_rma_line_rec_.inverted_conv_factor);
            
            -- get the propotional catch_qty when more than one SHIPDIR transactions are created.
            calc_catch_qty_returned_ := catch_qty_returned_ * quantity_ / total_inv_qty_return_;
            
            IF (reject_code_ IS NOT NULL) THEN
               Inventory_Transaction_Hist_API.New(transaction_id_          => inv_receipt_trans_id_,
                                                  accounting_id_           => accounting_id_,
                                                  value_                   => trans_value_,
                                                  transaction_code_        => receipt_trans_code_,
                                                  contract_                => receipt_contract_,
                                                  part_no_                 => part_no_,
                                                  configuration_id_        => receipt_rma_line_rec_.configuration_id,
                                                  location_no_             => NULL,
                                                  lot_batch_no_            => lot_batch_no_,
                                                  serial_no_               => serial_no_,
                                                  waiv_dev_rej_no_         => waiv_dev_rej_no_,
                                                  eng_chg_level_           => eng_chg_level_,
                                                  activity_seq_            => activity_seq_,
                                                  handling_unit_id_        => handling_unit_id_,
                                                  project_id_              => project_id_,
                                                  source_ref1_             => TO_CHAR(rma_rec_.receipt_rma_no),
                                                  source_ref2_             => NULL,
                                                  source_ref3_             => NULL,
                                                  source_ref4_             => rma_line_no_,
                                                  source_ref5_             => NULL,
                                                  reject_code_             => reject_code_,
                                                  cost_detail_tab_         => empty_cost_detail_tab_,
                                                  unit_cost_               => NULL,
                                                  quantity_                => receipt_trans_inv_qty_,
                                                  qty_reversed_            => 0,
                                                  catch_quantity_          => calc_catch_qty_returned_,
                                                  source_                  => NULL,
                                                  source_ref_type_         => Order_Type_API.Decode('RMA'),
                                                  owning_vendor_no_        => NULL,
                                                  condition_code_          => condition_code_,
                                                  location_group_          => NULL,
                                                  part_ownership_db_       => Part_Ownership_API.DB_COMPANY_OWNED,
                                                  owning_customer_no_      => NULL,
                                                  expiration_date_         => expiration_date_,
                                                  alt_source_ref1_         => NULL,
                                                  alt_source_ref2_         => NULL,
                                                  alt_source_ref3_         => NULL,
                                                  alt_source_ref4_         => NULL,
                                                  alt_source_ref5_         => NULL,
                                                  alt_source_ref_type_db_  => NULL,
                                                  issue_transaction_id_    => direct_ret_trans_id_);
               
               IF (inv_receipt_trans_id_ IS NULL) THEN
                  Error_SYS.Record_General(lu_name_, 'TRANSCTNNOTEXIST: Inventory transaction could not be created.');
               END IF;                                   
               
               Inventory_Transaction_Hist_API.Do_Transaction_Booking(inv_receipt_trans_id_, Site_API.Get_Company(receipt_contract_), 'N', NULL);
               
               message_ := Language_SYS.Translate_Constant(lu_name_, 'RMALINESCRAP: Line :P1, scrapped :P2 item(s).', p1_ => rma_line_no_, p2_ => receipt_trans_inv_qty_ );
               
               Invent_Trans_Interconnect_API.Connect_Transactions(direct_ret_trans_id_, inv_receipt_trans_id_, Invent_Trans_Conn_Reason_API.DB_INTERSITE_TRANSFER);
            ELSE
               Inventory_Part_In_Stock_API.Receive_Part(transaction_id_        => inv_receipt_trans_id_,
                                                        contract_              => receipt_contract_,
                                                        part_no_               => part_no_,
                                                        configuration_id_      => receipt_rma_line_rec_.configuration_id,
                                                        location_no_           => location_no_,
                                                        lot_batch_no_          => lot_batch_no_,
                                                        serial_no_             => serial_no_,
                                                        eng_chg_level_         => eng_chg_level_,
                                                        waiv_dev_rej_no_       => waiv_dev_rej_no_,
                                                        activity_seq_          => activity_seq_,
                                                        handling_unit_id_      => handling_unit_id_,
                                                        transaction_           => receipt_trans_code_,
                                                        expiration_date_       => expiration_date_,
                                                        quantity_              => receipt_trans_inv_qty_ ,
                                                        catch_quantity_        => calc_catch_qty_returned_,
                                                        quantity_reserved_     => 0,
                                                        order_no_              => TO_CHAR(rma_rec_.receipt_rma_no),
                                                        line_no_               => NULL,
                                                        release_no_            => NULL,
                                                        line_item_no_          => receipt_rma_line_no_,
                                                        source_                => NULL,
                                                        value_                 => NULL,
                                                        cost_detail_tab_       => empty_cost_detail_tab_,
                                                        order_type_            => Order_Type_API.Decode('RMA'),
                                                        receive_correction_    => NULL,
                                                        owning_vendor_no_      => NULL,
                                                        condition_code_        => condition_code_,
                                                        part_ownership_        => Part_Ownership_API.DB_COMPANY_OWNED,
                                                        owning_customer_no_    => NULL,
                                                        receipt_date_          => NULL,
                                                        issue_transaction_id_  => direct_ret_trans_id_);
               
               IF (inv_receipt_trans_id_ IS NULL) THEN
                  Error_SYS.Record_General(lu_name_, 'TRANSCTNNOTEXIST: Inventory transaction could not be created.');
               END IF; 
               
               message_ := Language_SYS.Translate_Constant(lu_name_, 'RMALINERETI: Line :P1, returned :P2 item(s) into inventory at location :P3.', p1_ => rma_rec_.receipt_rma_no, p2_ => receipt_trans_inv_qty_, p3_ => location_no_);
            END IF;
            Return_Material_History_API.New(rma_rec_.receipt_rma_no, message_);
         END IF;
      ELSE
         Error_SYS.Record_General(lu_name_, 'WRONGQTY: Incorrect quantity to create transaction.');
      END IF;
   END IF;
END Create_Dir_Ret_Transaction___;


PROCEDURE Validate_Conn_Purch_Line___ (
   co_order_no_     IN VARCHAR2,
   co_line_no_      IN VARCHAR2,
   co_rel_no_       IN VARCHAR2,
   co_line_item_no_ IN NUMBER )
IS
   demand_order_ref1_ customer_order_line_tab.demand_order_ref1%TYPE;
   demand_order_ref2_ customer_order_line_tab.demand_order_ref2%TYPE;
   demand_order_ref3_ customer_order_line_tab.demand_order_ref3%TYPE;
   demand_order_ref4_ customer_order_line_tab.demand_order_ref4%TYPE;
   purch_comp_exist_  NUMBER;
   state_             VARCHAR2(40);
BEGIN
   $IF Component_Purch_SYS.INSTALLED $THEN
      purch_comp_exist_ := Pur_Ord_Charged_Comp_API.Is_Comp_Line_Exists_For_Col(co_order_no_, co_line_no_, co_rel_no_, co_line_item_no_);

       Trace_sys.message('#############purch_comp_exist_'||purch_comp_exist_);

      IF purch_comp_exist_ = 1 THEN
         Customer_Order_Line_Api.Get_Demand_Order_Info(demand_order_ref1_, demand_order_ref2_,
                                                       demand_order_ref3_ ,demand_order_ref4_,
                                                       co_order_no_,co_line_no_,co_rel_no_,co_line_item_no_);
         state_ := Purchase_Order_Line_API.Get_Objstate(demand_order_ref1_, demand_order_ref2_, demand_order_ref3_);
         IF state_ = 'Closed' THEN
            Error_SYS.Record_General(lu_name_, 'CONPOCLOED: Cannot process the return/scrap since the connected Purchase Order Line :P1 /:P2 /:P3 is Closed.',demand_order_ref1_,demand_order_ref2_,demand_order_ref3_);
         END IF;
      END IF;
   $ELSE
      NULL;
   $END
END Validate_Conn_Purch_Line___;


-- Create_Cust_Receipt
--   Creates customer return receipt and customer receipt locations.
--   If the receipt_no for rma_no and rma_line_no is different with given receipt_no
--   Or given receipt_no_ is null, then creates new receipt.
PROCEDURE Create_Cust_Receipt (
   receipt_no_         IN OUT VARCHAR2,
   receipt_type_       IN     VARCHAR2,
   rma_no_             IN     NUMBER,
   rma_line_no_        IN     NUMBER,
   part_no_            IN     VARCHAR2,
   contract_           IN     VARCHAR2,
   configuration_id_   IN     VARCHAR2,
   expiration_date_    IN     DATE,
   location_no_        IN     VARCHAR2,
   lot_batch_no_       IN     VARCHAR2,
   serial_no_          IN     VARCHAR2,
   eng_chg_level_      IN     VARCHAR2,
   waiv_dev_rej_no_    IN     VARCHAR2,
   handling_unit_id_   IN     NUMBER,
   part_ownership_db_  IN     VARCHAR2,
   owning_vendor_no_   IN     VARCHAR2,
   qty_receipt_        IN     NUMBER,
   qty_receipt_inv_    IN     NUMBER,
   catch_qty_receipt_  IN     NUMBER,
   reject_reason_      IN     VARCHAR2,
   condition_code_     IN     VARCHAR2,
   receipt_all_        IN     VARCHAR2,
   rental_transfer_db_ IN     VARCHAR2 DEFAULT Fnd_Boolean_API.DB_FALSE,
   date_applied_       IN     DATE     DEFAULT SYSDATE,
   del_note_no_        IN     VARCHAR2 DEFAULT NULL,
   del_note_date_      IN     DATE     DEFAULT NULL,
   deliv_reason_id_    IN     VARCHAR2 DEFAULT NULL)
IS
   attr_                   VARCHAR2(32000);
   indrec_                 Indicator_Rec;
   date_received_          DATE;
   tmp_qty_receipt_        NUMBER := 0;
   tmp_qty_receipt_inv_    NUMBER;
   oldrec_                 RETURN_MATERIAL_LINE_TAB%ROWTYPE;
   newrec_                 RETURN_MATERIAL_LINE_TAB%ROWTYPE;
   objid_                  VARCHAR2(2000);
   objversion_             VARCHAR2(2000);
   primary_rental_no_      NUMBER;
   activity_seq_           NUMBER;
   wo_no_                  NUMBER;  
   part_catalog_rec_       Part_Catalog_API.Public_Rec;
   serial_no_in_stock_     VARCHAR2(50);
   location_type_db_       VARCHAR2(20);
   customer_               RETURN_MATERIAL_TAB.customer_no%TYPE;
   qty_to_end_rental_      NUMBER;   
   tmp_handling_unit_id_   NUMBER := NVL(handling_unit_id_,0);
   $IF Component_Rental_SYS.INSTALLED $THEN
      rental_object_rec_   Rental_Object_API.Public_Rec;
   $END
   coline_rec_             Customer_Order_Line_API.Public_Rec;
BEGIN
   --NOTE: With the introduction of customer receipts, qty_received_inv_uom and qty_receipt_inv will have the same value until inspection functionality is introduced.
   oldrec_ := Lock_By_Keys___(rma_no_, rma_line_no_);
   newrec_ := oldrec_;
   IF (oldrec_.rowstate = 'Cancelled') THEN
      Error_SYS.Record_General(lu_name_, 'CHGCANCELED: Cancelled RMA line can not be changed.');
   END IF;
   Client_SYS.Clear_Attr(attr_);
   $IF Component_Rmcom_SYS.INSTALLED $THEN
      IF Rm_Acc_Usage_API.Possible_To_Update('ReturnMaterial', 'RELATE_TO_PARENT', 'DO', rma_no_) = FALSE THEN
         Rm_Acc_Usage_API.Raise_No_Access('ReturnMaterial', rma_no_);
      END IF;
   $END
   IF (part_no_ IS NULL) THEN
      Client_SYS.Add_To_Attr('QTY_RECEIVED_INV_UOM', NVL(oldrec_.qty_received_inv_uom, 0) + qty_receipt_, attr_);
   ELSE
      Client_SYS.Add_To_Attr('QTY_RECEIVED_INV_UOM', NVL(oldrec_.qty_received_inv_uom, 0) + qty_receipt_inv_, attr_);
   END IF;

   Client_SYS.Add_To_Attr('QTY_RECEIVED', NVL(oldrec_.qty_received, 0) + qty_receipt_, attr_);

   -- Assign QTY_EDITED_FLAG value as 'DLG_NOT_EDITED' in order to take the values from the database to retain the full precision.
   IF (receipt_all_ = Fnd_Boolean_API.DB_TRUE) THEN
      Client_SYS.Add_To_Attr('QTY_EDITED_FLAG', 'DLG_NOT_EDITED', attr_);
   END IF;
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
   
   coline_rec_ := Customer_Order_Line_API.Get(newrec_.order_no,
                                              newrec_.line_no,
                                              newrec_.rel_no,
                                              newrec_.line_item_no);
   IF (receipt_no_ IS NULL) OR
      ((receipt_no_ IS NOT NULL) AND (NOT Customer_Return_Receipt_API.Check_Exist(rma_no_, rma_line_no_, receipt_no_))) THEN
      -- Create new customer return receipt.
      -- Note: For non-inventory parts, store the qty_returned in customer receipt.
      IF (part_no_ IS NULL) THEN
         tmp_qty_receipt_ := qty_receipt_;
      END IF;
      Customer_Return_Receipt_API.New (receipt_no_,
                                       rma_no_,
                                       rma_line_no_,
                                       contract_,
                                       tmp_qty_receipt_);
   END IF;

   qty_to_end_rental_ := qty_receipt_;
   IF (part_no_ IS NOT NULL) THEN
      IF (receipt_type_ = 'RETURN') THEN
         -- Set the returned date to site date.
         date_received_ := Site_API.Get_Site_Date(contract_);
         IF (receipt_all_ = Fnd_Boolean_API.DB_TRUE) THEN
            -- Added condition to calculate qty_receipt_inv for the partially returned qty when 'Return Total Qty' Check box is checked in Receive parts dialog box. 
            IF ( oldrec_.qty_returned_inv IS NULL) THEN
               tmp_qty_receipt_inv_ := newrec_.qty_to_return_inv_uom;
               tmp_qty_receipt_     := newrec_.qty_to_return;              
               IF (oldrec_.qty_scrapped IS  NOT NULL) THEN   
                  tmp_qty_receipt_inv_ := (newrec_.qty_to_return_inv_uom - oldrec_.qty_received_inv_uom);
                  tmp_qty_receipt_ := newrec_.qty_to_return - oldrec_.qty_received;
               END IF;
            ELSIF ( oldrec_.qty_returned_inv IS  NOT NULL) THEN
               tmp_qty_receipt_inv_ := (newrec_.qty_to_return_inv_uom - oldrec_.qty_received_inv_uom);
               tmp_qty_receipt_     := newrec_.qty_to_return - oldrec_.qty_received;             
               IF (oldrec_.qty_scrapped IS  NOT NULL) THEN   
                  tmp_qty_receipt_inv_ := (newrec_.qty_to_return_inv_uom - oldrec_.qty_received_inv_uom);
                  tmp_qty_receipt_ := newrec_.qty_to_return - oldrec_.qty_received;
               END IF;
            END IF; 
         ELSE
            tmp_qty_receipt_inv_ := qty_receipt_inv_;
            tmp_qty_receipt_     := qty_receipt_;
         END IF;
         
         
         -- Creates inventory transactions
         Inventory_Return___(activity_seq_            => activity_seq_,
                             rma_no_                  => rma_no_,
                             rma_line_no_             => rma_line_no_,
                             contract_                => contract_,
                             part_no_                 => part_no_,
                             configuration_id_        => configuration_id_,
                             location_no_             => location_no_,
                             lot_batch_no_            => lot_batch_no_,
                             serial_no_               => serial_no_,
                             eng_chg_level_           => eng_chg_level_,
                             waiv_dev_rej_no_         => waiv_dev_rej_no_,
                             handling_unit_id_        => tmp_handling_unit_id_,
                             qty_returned_            => tmp_qty_receipt_inv_,
                             catch_qty_returned_      => catch_qty_receipt_,
                             source_                  => NULL,
                             date_received_           => date_received_,
                             expiration_date_         => expiration_date_,
                             transit_eng_chg_level_   => NULL,
                             condition_code_          => Get_Condition_Code(rma_no_, rma_line_no_),
                             part_ownership_db_       => part_ownership_db_,
                             owning_vendor_no_        => owning_vendor_no_,
                             return_all_              => receipt_all_,
                             date_applied_            => date_applied_,
                             del_note_no_             => del_note_no_,
                             del_note_date_           => del_note_date_,
                             deliv_reason_id_         => deliv_reason_id_);
                             
         qty_to_end_rental_ := tmp_qty_receipt_;
         part_catalog_rec_  := Part_Catalog_API.Get(part_no_);
         location_type_db_  := Inventory_Location_API.Get_Location_Type_Db(contract_, location_no_);

         -- For receipt and issue tracked parts, the serial no passed in might not be found in InventoryPartInStock
         serial_no_in_stock_ := Inventory_Part_In_Stock_API.Get_Serial_No_For_Stock(part_no_,
                                                                                    serial_no_,
                                                                                    part_catalog_rec_,
                                                                                    location_type_db_,
                                                                                    tmp_handling_unit_id_);

         -- Create or modify if exist customer receipt location for inventory part.
         Customer_Receipt_Location_API.Manage_Receipt_Return(rma_no_             => rma_no_,
                                                             rma_line_no_        => rma_line_no_,
                                                             receipt_no_         => receipt_no_,
                                                             part_no_            => part_no_,
                                                             contract_           => contract_,
                                                             configuration_id_   => configuration_id_,
                                                             location_no_        => location_no_,
                                                             lot_batch_no_       => lot_batch_no_,
                                                             serial_no_          => serial_no_in_stock_,
                                                             eng_chg_level_      => eng_chg_level_,
                                                             waiv_dev_rej_no_    => waiv_dev_rej_no_,
                                                             activity_seq_       => activity_seq_,
                                                             handling_unit_id_   => tmp_handling_unit_id_,
                                                             part_ownership_db_  => part_ownership_db_,
                                                             owning_vendor_no_   => owning_vendor_no_,
                                                             qty_returned_       => tmp_qty_receipt_,
                                                             qty_returned_inv_   => tmp_qty_receipt_inv_,
                                                             catch_qty_returned_ => catch_qty_receipt_);         
      ELSIF (receipt_type_ = 'SCRAP') THEN
         -- Create inventory transactions.
         -- Added condition to calculate qty_receipt_inv for the partially scrapped qty when 'Scrap Total Qty' Check box is checked in Scrap parts dialog box. 
         IF (receipt_all_ = Fnd_Boolean_API.DB_TRUE) THEN
            IF (oldrec_.qty_scrapped IS NULL) THEN
               tmp_qty_receipt_inv_ := newrec_.qty_to_return_inv_uom;
               IF (oldrec_.qty_returned_inv IS  NOT NULL) THEN 
                  tmp_qty_receipt_inv_ := (newrec_.qty_to_return_inv_uom - oldrec_.qty_received_inv_uom);
               END IF;            
            ELSIF (oldrec_.qty_scrapped IS  NOT NULL) THEN   
               tmp_qty_receipt_inv_ := (newrec_.qty_to_return_inv_uom - oldrec_.qty_received_inv_uom);
               IF (oldrec_.qty_returned_inv IS  NOT NULL) THEN 
                  tmp_qty_receipt_inv_ := (newrec_.qty_to_return_inv_uom - oldrec_.qty_received_inv_uom);
               END IF;
            END IF;  
         ELSE
            tmp_qty_receipt_inv_ := qty_receipt_inv_;
         END IF;
         
         IF ( coline_rec_.part_ownership IS NOT NULL AND coline_rec_.part_ownership = Part_Ownership_API.DB_COMPANY_RENTAL_ASSET) THEN
            Error_SYS.Record_General(lu_name_, 'CANNOTSCRAPCRAOWN: Cannot perform scrapping for return lines with ownership Company Rental Asset.');
         END IF;      
         Return_And_Scrap__(rma_no_,
                            rma_line_no_,
                            tmp_qty_receipt_inv_,
                            catch_qty_receipt_,
                            reject_reason_,
                            part_no_,
                            configuration_id_,
                            serial_no_,
                            lot_batch_no_,
                            eng_chg_level_,
                            waiv_dev_rej_no_,
						          tmp_handling_unit_id_,
                            NULL,               --Expiration Date
                            NULL,               --Date Returned
                            NULL,               --Transit EngChgLevel
                            condition_code_,
                            receipt_all_,       --Scrap all
                            date_applied_,
                            del_note_no_,
                            del_note_date_,
                            deliv_reason_id_);  

         -- Create new scrap record.
         Return_Material_Scrap_API.New(rma_no_,
                                       rma_line_no_,
                                       receipt_no_,
                                       reject_reason_,
                                       serial_no_,
                                       lot_batch_no_,
                                       eng_chg_level_,
                                       waiv_dev_rej_no_,
                                       tmp_qty_receipt_inv_);
      END IF;
   END IF;   
   -- Added in order to update export control license coverage quantity when a non-inventory part return through a RMA.
   $IF Component_Expctr_SYS.INSTALLED $THEN
      IF ((newrec_.part_no IS NULL) AND Partca_Export_Control_API.Is_Part_Export_Controlled(newrec_.catalog_no)) THEN
         Update_License_Coverage_Qty___(rma_no_, rma_line_no_, qty_receipt_);
      END IF;
   $ELSE
      NULL;
   $END   
   IF (newrec_.rental = Fnd_Boolean_API.DB_TRUE) THEN
      $IF Component_Rental_SYS.INSTALLED $THEN
         IF (receipt_type_ = 'RETURN' AND newrec_.rental_end_date IS NOT NULL) THEN
            Rental_Object_Manager_API.Automatic_End_Rental(newrec_.order_no,
                                                           newrec_.line_no,
                                                           newrec_.rel_no,
                                                           newrec_.line_item_no,
                                                           Rental_Type_API.DB_CUSTOMER_ORDER,
                                                           lot_batch_no_,
                                                           serial_no_,
                                                           newrec_.rental_end_date,
                                                           qty_to_end_rental_);
         END IF;
         
         IF (coline_rec_.demand_code IS NOT NULL AND coline_rec_.demand_code IN (Order_Supply_Type_API.DB_REPLACEMENT_CUSTOMER_ORDER,
                                                                 Order_Supply_Type_API.DB_INT_PURCH_REPLACEMENT_ORDER)) THEN
            -- Get the primary rental number.
            primary_rental_no_ := Rental_Object_API.Get_Primary_Rental_No(newrec_.order_no,
                                                                          newrec_.line_no,
                                                                          newrec_.rel_no,
                                                                          newrec_.line_item_no,
                                                                          Rental_Type_API.DB_CUSTOMER_ORDER);
            rental_object_rec_ := Rental_Object_API.Get(primary_rental_no_);
            Customer_Order_API.Set_Rent_Line_Completed(rental_object_rec_.order_ref1,
                                                       rental_object_rec_.order_ref2,
                                                       rental_object_rec_.order_ref3,
                                                       rental_object_rec_.order_ref4);
         ELSE
            Customer_Order_API.Set_Rent_Line_Completed(newrec_.order_no,
                                                       newrec_.line_no,
                                                       newrec_.rel_no,
                                                       newrec_.line_item_no);
         END IF;
      $ELSE
         NULL;
      $END
      IF (rental_transfer_db_ = Fnd_Boolean_API.DB_FALSE) THEN
         $IF Component_Wo_SYS.INSTALLED $THEN
            customer_ := Return_Material_API.Get_Customer_No(rma_no_);
            Active_Separate_API.Create_Rental_Wo(wo_no_,
                                                 contract_,
                                                 part_no_,
                                                 serial_no_,
                                                 customer_,
                                                 NULL,
                                                 newrec_.order_no,
                                                 newrec_.line_no,
                                                 newrec_.rel_no,
                                                 newrec_.line_item_no,
                                                 tmp_qty_receipt_inv_,
                                                 'FALSE',
                                                 'TRUE');
         $ELSE
            NULL;
         $END
      END IF;
   END IF;
END Create_Cust_Receipt;


PROCEDURE Find_And_Conn_Exp_License___ (
   rma_no_      IN NUMBER,
   rma_line_no_ IN NUMBER)
IS

BEGIN
   IF (Customer_Order_Flow_API.Get_License_Enabled(rma_no_, 'INTERACT_RMA') = 'TRUE') THEN
      $IF Component_Expctr_SYS.INSTALLED $THEN
         Exp_License_Connect_Util_Api.Create_Exp_License_For_Src('RMA', rma_no_, rma_line_no_, NULL, NULL);
      $ELSE
         NULL;
      $END
   END IF;
END Find_And_Conn_Exp_License___;


PROCEDURE Check_Export_Controlled___ (
   rma_no_      IN NUMBER,
   rma_line_no_ IN NUMBER)
IS

BEGIN
   IF (Customer_Order_Flow_API.Get_License_Enabled(rma_no_, 'INTERACT_RMA') = 'TRUE') THEN
      $IF Component_Expctr_SYS.INSTALLED $THEN
         Exp_License_Connect_Util_API.Check_Order_Proceed_Allowed(rma_no_, rma_line_no_, NULL, NULL, 'RMA');
      $ELSE
         NULL;
      $END
   END IF;
END Check_Export_Controlled___;


PROCEDURE Update_License_Coverage_Qty___(
   order_no_ IN VARCHAR2,
   line_no_  IN VARCHAR2,
   quantity_ IN NUMBER)
IS
BEGIN
   IF (Customer_Order_Flow_API.Get_License_Enabled(order_no_, 'INTERACT_RMA') = 'TRUE') THEN
      $IF Component_Expctr_SYS.INSTALLED $THEN
         DECLARE
            action_ VARCHAR2(20) := 'Return';
         BEGIN
            Exp_License_Connect_Util_Api.Update_Coverage_Quantities(action_, order_no_, line_no_, NULL, '0', quantity_, 'RMA');
         END;
      $ELSE
         NULL;
      $END
   END IF;
END Update_License_Coverage_Qty___;


PROCEDURE Remove_Export_Licenses___ (
   rma_no_      IN NUMBER,
   rma_line_no_ IN NUMBER )
IS
BEGIN
   IF (Customer_Order_Flow_API.Get_License_Enabled(rma_no_, 'INTERACT_RMA') = 'TRUE') THEN
      $IF Component_Expctr_SYS.INSTALLED $THEN
         Exp_License_Connect_Head_API.Remove_By_Ref(rma_no_, rma_line_no_, NULL, 1, 'RMA');
      $ELSE
         NULL;
      $END
   END IF;
END Remove_Export_Licenses___;

PROCEDURE Calculate_Prices___ (
   newrec_ IN OUT RETURN_MATERIAL_LINE_TAB%ROWTYPE )   
IS 
   rma_rec_               Return_Material_API.Public_Rec;
   tax_liability_type_db_ VARCHAR2(20);
   multiple_tax_          VARCHAR2(20);
BEGIN
   rma_rec_        := Return_Material_API.Get(newrec_.rma_no);
   
   tax_liability_type_db_  := Tax_Liability_API.Get_Tax_Liability_Type_Db(newrec_.tax_liability, rma_rec_.ship_addr_country_code);
   
   Tax_Handling_Order_Util_API.Get_Prices(newrec_.base_sale_unit_price,
                                          newrec_.base_unit_price_incl_tax,
                                          newrec_.sale_unit_price,
                                          newrec_.unit_price_incl_tax,
                                          multiple_tax_,
                                          newrec_.fee_code,
                                          newrec_.tax_calc_structure_id,
                                          newrec_.tax_class_id,
                                          newrec_.rma_no, 
                                          newrec_.rma_line_no, 
                                          '*',
                                          '*',
                                          '*',
                                          Tax_Source_API.DB_RETURN_MATERIAL_LINE,
                                          newrec_.contract,
                                          rma_rec_.customer_no,
                                          rma_rec_.ship_addr_no,
                                          TRUNC(Site_API.Get_Site_Date(rma_rec_.contract)),
                                          rma_rec_.supply_country,
                                          NVL(newrec_.delivery_type, '*'),
                                          newrec_.catalog_no,
                                          rma_rec_.use_price_incl_tax,
                                          rma_rec_.currency_code,
                                          newrec_.currency_rate,
                                          'FALSE',                                          
                                          newrec_.tax_liability,
                                          tax_liability_type_db_,
                                          delivery_country_db_ => NULL,
                                          ifs_curr_rounding_ => 16,
                                          tax_from_diff_source_ => 'FALSE',
                                          attr_ => NULL);
END Calculate_Prices___;


-- Modify_Multi_Site_Rma___
--   This is to update the supply site rma though demand site rma and vice versa.
PROCEDURE Modify_Multi_Site_Rma___ (
   newrec_ IN RETURN_MATERIAL_LINE_TAB%ROWTYPE,
   oldrec_ IN RETURN_MATERIAL_LINE_TAB%ROWTYPE )
IS
   modify_attr_               VARCHAR2(32000);
   receipt_order_no_          RETURN_MATERIAL_LINE_TAB.order_no%TYPE;
   receipt_line_no_           RETURN_MATERIAL_LINE_TAB.line_no%TYPE;
   receipt_rel_no_            RETURN_MATERIAL_LINE_TAB.rel_no%TYPE;
   receipt_line_item_no_      RETURN_MATERIAL_LINE_TAB.line_item_no%TYPE;
   rma_rec_                   Return_Material_API.Public_Rec;
   org_rma_line_rec_          Return_Material_Line_API.Public_Rec;
   receipt_rma_line_rec_      Return_Material_Line_API.Public_Rec;
   org_inv_qty_received_      NUMBER;
   org_sales_qty_received_    NUMBER;
   receipt_inv_qty_to_ret_    NUMBER;
   receipt_sales_qty_to_ret_  NUMBER;
BEGIN
   rma_rec_  := Return_Material_API.Get(newrec_.rma_no);
   -- Supply site to Demand site
   IF ((newrec_.originating_rma_line_no IS NOT NULL) AND (NVL(newrec_.qty_received, 0) != NVL(oldrec_.qty_received, 0))) THEN
      org_rma_line_rec_ := Return_Material_Line_API.Get(rma_rec_.originating_rma_no, newrec_.originating_rma_line_no);

      Get_Converted_Qty___(org_inv_qty_received_,
                           org_sales_qty_received_,
                           newrec_.qty_received_inv_uom,
                           newrec_.qty_received,
                           newrec_.contract,
                           org_rma_line_rec_.contract,
                           newrec_.part_no,
                           org_rma_line_rec_.part_no,
                           org_rma_line_rec_.conv_factor,
                           org_rma_line_rec_.inverted_conv_factor );

      Client_SYS.Clear_Attr(modify_attr_);
      Client_SYS.Add_To_Attr('QTY_RECEIVED', org_sales_qty_received_ , modify_attr_);
      Client_SYS.Add_To_Attr('QTY_RECEIVED_INV_UOM', org_inv_qty_received_, modify_attr_);
      -- Added the attribute to the modify_attr_ to indicate that user allowed site validation should be bypassed when updating the originating RMA.
      Client_SYS.Add_To_Attr('BYPASS_USER_ALLOWED_SITE', 'TRUE', modify_attr_);
      
      Modify_Line__(modify_attr_, rma_rec_.originating_rma_no, newrec_.originating_rma_line_no);
   -- Demand site to Supply site
  ELSIF ((newrec_.receipt_rma_line_no IS NOT NULL) AND (NVL(newrec_.qty_to_return, 0) != NVL(oldrec_.qty_to_return, 0)) OR
         (newrec_.receipt_rma_line_no IS NOT NULL) AND (NVL(newrec_.order_no, 0) != NVL(oldrec_.order_no, 0))) THEN
      receipt_rma_line_rec_ := Return_Material_Line_API.Get(rma_rec_.receipt_rma_no, newrec_.receipt_rma_line_no);
      Customer_Order_Line_API.Get_Custord_From_Demand_Info(receipt_order_no_, receipt_line_no_, receipt_rel_no_, receipt_line_item_no_, newrec_.po_order_no, newrec_.po_line_no, newrec_.po_rel_no, NULL, Order_Supply_Type_API.DB_INT_PURCH_DIR);
      Get_Converted_Qty___(receipt_inv_qty_to_ret_,
                           receipt_sales_qty_to_ret_,
                           newrec_.qty_to_return_inv_uom,
                           newrec_.qty_to_return,
                           newrec_.contract,
                           receipt_rma_line_rec_.contract,
                           newrec_.part_no,
                           receipt_rma_line_rec_.part_no,
                           receipt_rma_line_rec_.conv_factor,
                           receipt_rma_line_rec_.inverted_conv_factor );

      Client_SYS.Clear_Attr(modify_attr_);
      Client_SYS.Add_To_Attr('QTY_TO_RETURN', receipt_sales_qty_to_ret_, modify_attr_);
      Client_SYS.Add_To_Attr('QTY_TO_RETURN_INV_UOM', receipt_inv_qty_to_ret_, modify_attr_);

      Client_SYS.Add_To_Attr('ORDER_NO', receipt_order_no_ , modify_attr_);
      Client_SYS.Add_To_Attr('LINE_NO', receipt_line_no_ , modify_attr_);
      Client_SYS.Add_To_Attr('REL_NO', receipt_rel_no_ , modify_attr_);
      Client_SYS.Add_To_Attr('LINE_ITEM_NO', receipt_line_item_no_ , modify_attr_);
      -- Added the attribute to the modify_attr_ to indicate that user allowed site validation should be bypassed when updating the originating RMA.
      Client_SYS.Add_To_Attr('BYPASS_USER_ALLOWED_SITE', 'TRUE', modify_attr_);
      
      Modify_Line__(modify_attr_, rma_rec_.receipt_rma_no, newrec_.receipt_rma_line_no);
   END IF;
END Modify_Multi_Site_Rma___;


-- Restrict_Multi_Site_Rma___
--   This is to restrict updation in the supply site rma line.
PROCEDURE Restrict_Multi_Site_Rma___ (
   newrec_ IN RETURN_MATERIAL_LINE_TAB%ROWTYPE,
   oldrec_ IN RETURN_MATERIAL_LINE_TAB%ROWTYPE )
IS
BEGIN
   IF (newrec_.originating_rma_line_no IS NOT NULL) THEN
      IF (NVL(newrec_.qty_to_return, 0) != NVL(oldrec_.qty_to_return, 0)) OR
         (NVL(newrec_.order_no, Database_SYS.string_null_)  != NVL(oldrec_.order_no, Database_SYS.string_null_)) OR
         (NVL(newrec_.purchase_order_no, Database_SYS.string_null_)  != NVL(oldrec_.purchase_order_no, Database_SYS.string_null_)) THEN
            Error_SYS.Record_General(lu_name_, 'RMALINEUPDNOTALLOWED: The values for the quantity to return, order number and customer purchase number cannot be modified when the RMA is originated by a different site');
      END IF;
   END IF;
END Restrict_Multi_Site_Rma___;


-- Get_Converted_Qty___
--   This method is used to convert the given qty from one site to another.
--   This conversion is possible in the same databases.
PROCEDURE Get_Converted_Qty___ (
   converted_inv_qty_        OUT NUMBER,
   converted_sales_qty_      OUT NUMBER,
   from_inv_qty_             IN  NUMBER,
   from_sales_qty_           IN  NUMBER,
   from_contract_            IN  VARCHAR2,
   to_contract_              IN  VARCHAR2,
   from_inv_part_no_         IN  VARCHAR2,
   to_inv_part_no_           IN  VARCHAR2,
   to_site_conv_factor_      IN  NUMBER,
   to_site_inv_conv_factor_  IN  NUMBER )
IS
   from_site_inv_uom_     VARCHAR2(30);
   to_site_inv_uom_       VARCHAR2(30);
BEGIN
   IF (from_inv_part_no_ IS NOT NULL) THEN
      -- Inventory Parts
      from_site_inv_uom_ := Inventory_Part_API.Get_Unit_Meas(from_contract_, from_inv_part_no_);
      to_site_inv_uom_   := Inventory_Part_API.Get_Unit_Meas(to_contract_, to_inv_part_no_);
      IF (from_site_inv_uom_ != to_site_inv_uom_) THEN
         converted_inv_qty_ := Iso_Unit_API.Get_Unit_Converted_Quantity(from_inv_qty_, from_site_inv_uom_, to_site_inv_uom_);
      ELSE
         converted_inv_qty_ := from_inv_qty_;
      END IF;
      converted_sales_qty_ := converted_inv_qty_ * to_site_inv_conv_factor_ / to_site_conv_factor_;
   ELSE
      -- Non Inv Parts
      -- need to consider the conversion for sales qty in different sites which will be handled later.
      converted_sales_qty_ := from_sales_qty_;
      -- in rms for non inv parts inv qty is same as sales qty
      converted_inv_qty_   := converted_sales_qty_;
   END IF;
END Get_Converted_Qty___;


-- Inventory_Return___
--   Update the qty_returned_inv attribute and call the Receive_Part method
--   in InventoryPartLocation to make an inventory transaction.
PROCEDURE Inventory_Return___ (
   activity_seq_          OUT NUMBER,
   rma_no_                IN  NUMBER,
   rma_line_no_           IN  NUMBER,
   contract_              IN  VARCHAR2,
   part_no_               IN  VARCHAR2,
   configuration_id_      IN  VARCHAR2,
   location_no_           IN  VARCHAR2,
   lot_batch_no_          IN  VARCHAR2,
   serial_no_             IN  VARCHAR2,
   eng_chg_level_         IN  VARCHAR2,
   waiv_dev_rej_no_       IN  VARCHAR2,
   handling_unit_id_      IN  NUMBER,
   qty_returned_          IN  NUMBER,
   catch_qty_returned_    IN  NUMBER,
   source_                IN  VARCHAR2,
   date_received_         IN  DATE,
   expiration_date_       IN  DATE,
   transit_eng_chg_level_ IN  VARCHAR2,
   condition_code_        IN  VARCHAR2,
   part_ownership_db_     IN  VARCHAR2,
   owning_vendor_no_      IN  VARCHAR2,
   return_all_            IN  VARCHAR2,
   date_applied_          IN  DATE DEFAULT SYSDATE,
   del_note_no_           IN  VARCHAR2 DEFAULT NULL,
   del_note_date_         IN  DATE     DEFAULT NULL,
   deliv_reason_id_       IN  VARCHAR2 DEFAULT NULL)
IS
   oldrec_                  RETURN_MATERIAL_LINE_TAB%ROWTYPE;
   newrec_                  RETURN_MATERIAL_LINE_TAB%ROWTYPE;
   indrec_                  Indicator_Rec;
   ordrow_rec_              Customer_Order_Line_API.Public_Rec;
   attr_                    VARCHAR2(2000);
   objid_                   VARCHAR2(2000);
   objversion_              VARCHAR2(2000);
   message_                 VARCHAR2(2000);
   transaction_code_        VARCHAR2(200);
   customer_contract_       VARCHAR2(5);
   sites_with_same_company_ BOOLEAN := FALSE;
   location_type_db_        VARCHAR2(20);
   eng_chg_in_transit_      VARCHAR2(6);
   transaction_id_tab_      Inventory_Transaction_Hist_API.Transaction_Id_Tab;
   temp_condition_code_     RETURN_MATERIAL_LINE_TAB.condition_code%TYPE;
   rma_line_rec_            Return_Material_Line_API.Public_Rec;   
   originating_rma_no_      NUMBER;
   org_rma_line_no_         NUMBER;
   org_rma_line_rec_        Return_Material_Line_API.Public_Rec;
   org_message_             VARCHAR2(2000);
   org_inv_qty_returned_    NUMBER;
   org_objversion_          VARCHAR2(2000);
   org_sales_qty_returned_  NUMBER;
   org_rma_rec_             Return_Material_API.Public_Rec;
   rma_rec_                 Return_Material_API.Public_Rec;
   delivered_co_line_rec_   Customer_Order_Line_API.Public_Rec;
   demand_site_trans_code_  VARCHAR2(10);
   qty_delivered_           NUMBER;
   qty_return_scrap_        NUMBER;
   demand_ord_company_      VARCHAR2(20);
   org_return_company_        VARCHAR2(20);

   CURSOR get_del_qty IS
      SELECT SUM(qty_delivered)
      FROM   received_parts_order_del
      WHERE  rma_no = rma_no_
      AND    rma_line_no = rma_line_no_
      AND    lot_batch_no = lot_batch_no_
      AND    part_ownership_db = part_ownership_db_
      AND    NVL(owning_vendor_no, ' ') = NVL(owning_vendor_no_, ' ');
BEGIN
   
   Trace_SYS.Field('SERIAL_NO_', serial_no_);
   Trace_SYS.Field('QTY_RETURNED_', qty_returned_);

   IF location_no_ IS NULL THEN
      Error_SYS.Record_General(lu_name_, 'NULLINVLOCATIONNO: Inventory location must have a value for RMA number :P1 - line number :P2.', rma_no_, rma_line_no_);
   END IF;
   IF ( qty_returned_ = 0 ) THEN
      Error_SYS.Record_General(lu_name_, 'RETZEROQTY: You cannot return zero quantity.');
   END IF;
   -- Check for correct LocationType.
   location_type_db_ := Inventory_Location_API.Get_Location_Type_Db(contract_, location_no_);
   IF location_type_db_ NOT IN (Inventory_Location_Type_API.DB_PICKING,
                                Inventory_Location_Type_API.DB_FLOOR_STOCK,
                                Inventory_Location_Type_API.DB_PRODUCTION_LINE) THEN
      Error_SYS.Record_General(lu_name_, 'WRONG_INV_TYPE: Invalid Inventory Location.');
   END IF;
   IF (Get_Rental_Db(rma_no_, rma_line_no_) =  Fnd_Boolean_API.DB_TRUE) THEN
      OPEN get_del_qty;
      FETCH get_del_qty INTO qty_delivered_;
      CLOSE get_del_qty;
      qty_return_scrap_ := Get_Tot_Returned_Scrapped_Qty(rma_no_, rma_line_no_, lot_batch_no_, serial_no_, eng_chg_level_, waiv_dev_rej_no_,part_ownership_db_, owning_vendor_no_);
      IF (NVL(qty_delivered_,0) - NVL(qty_return_scrap_,0) ) - NVL(qty_returned_,0) <0 THEN
         Error_SYS.Record_General(lu_name_, 'WRONGRETURNQTY: You are not allowed to return more than the delivered quantity against the specific ownership in RMA :P1, line number :P2', rma_no_, rma_line_no_ );
      END IF;
   END IF;

   -- Update the qty returned into invetory on the RMA line.
   oldrec_ := Lock_By_Keys___(rma_no_, rma_line_no_);
   Client_SYS.Clear_Attr(attr_);

   rma_rec_      := Return_Material_API.Get(rma_no_);
   rma_line_rec_ := Return_Material_Line_API.Get(rma_no_, rma_line_no_);
   IF (return_all_ = Fnd_Boolean_API.DB_TRUE) THEN
      -- Modified else condition to allow return remaining quantity when 'Return Total Qty' Check box is checked in Receive parts dialog box.
      IF (oldrec_.qty_returned_inv IS NULL) AND (oldrec_.qty_scrapped IS NULL) THEN
         IF (oldrec_.qty_received_inv_uom <> oldrec_.qty_to_return_inv_uom) AND (qty_returned_ = oldrec_.qty_to_return_inv_uom) THEN
            Error_SYS.Record_General(lu_name_, 'WRONGRETURNALL: The total quantity received should be equal to the quantity to return.');
         ELSIF (oldrec_.qty_received_inv_uom <> oldrec_.qty_to_return_inv_uom) AND (qty_returned_ <> oldrec_.qty_to_return_inv_uom )THEN
            Error_SYS.Record_General(lu_name_, 'ALREADYRETURNED: It is not possible to use the return total quantity check box when the quantity to return to inventory for the line does not equal the approved quantity to return.');
         ELSIF (oldrec_.qty_received_inv_uom = oldrec_.qty_to_return_inv_uom) AND (qty_returned_ <> oldrec_.qty_to_return_inv_uom )THEN
            Error_SYS.Record_General(lu_name_, 'ALREADYRETURNED: It is not possible to use the return total quantity check box when the quantity to return to inventory for the line does not equal the approved quantity to return.');
         ELSE
            Client_SYS.Add_To_Attr('QTY_RETURNED_INV', oldrec_.qty_to_return_inv_uom, attr_);
         END IF;
      ELSE
         Client_SYS.Add_To_Attr('QTY_RETURNED_INV', NVL(oldrec_.qty_returned_inv, 0) + qty_returned_, attr_);        
      END IF;
   ELSE
      Client_SYS.Add_To_Attr('QTY_RETURNED_INV', NVL(oldrec_.qty_returned_inv, 0) + qty_returned_, attr_);
   END IF;
   Client_SYS.Add_To_Attr('DATE_RETURNED', date_received_, attr_);

   newrec_            := oldrec_;
   customer_contract_ := Cust_Ord_Customer_API.Get_Acquisition_Site(rma_rec_.customer_no);
   IF (Site_API.Get_Company(oldrec_.contract) = Site_API.Get_Company(customer_contract_)) THEN
      sites_with_same_company_ := TRUE;
   END IF;

   temp_condition_code_ := NVL(condition_code_, newrec_.condition_code);
   IF (temp_condition_code_ IS NOT NULL) THEN
      IF temp_condition_code_ != Condition_Code_Manager_API.Get_Condition_Code(part_no_,serial_no_,lot_batch_no_) THEN
         IF (serial_no_ = '*') THEN
            IF lot_batch_no_ != '*' THEN
               IF (Lot_Batch_Master_API.Check_Exist(part_no_, lot_batch_no_) = Fnd_Boolean_API.DB_TRUE) THEN
                  Error_SYS.Record_General(lu_name_, 'LOTBAT_COND_CODE: Condition Code in Return Material Line should be equal to the condition code defined for the Lot Batch No in Lot Batch Master');
               END IF;
            END IF;
         ELSE
            Condition_Code_Manager_API.Modify_Condition_Code(part_no_,serial_no_,lot_batch_no_,temp_condition_code_);
         END IF;
      END IF;
   END IF;

   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);

   -- Check if this return is connected to an order line for which a Service Management
   -- object was created on delivery.
   IF (newrec_.order_no IS NOT NULL) THEN
      ordrow_rec_ := Customer_Order_Line_API.Get(newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
      IF (ordrow_rec_.create_sm_object_option = 'CREATESMOBJECT') THEN
         -- Service management object was created on delivery of this line
         -- Remove the object in Maintenance before the return into inventory is made
         Remove_Sm_Object___(newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no, serial_no_);
      END IF;
   END IF;

   Trace_SYS.Message('Before Receive_Part');

   originating_rma_no_ := rma_rec_.originating_rma_no;

   IF (originating_rma_no_ IS NULL) THEN
      IF oldrec_.order_no IS NULL THEN
         transaction_code_ := 'OERET-NO';
      ELSIF sites_with_same_company_ THEN
      -- its an internal delivery when the sites have the same company
         transaction_code_ := 'OERET-INT';
      ELSIF ordrow_rec_.charged_item = 'ITEM NOT CHARGED' THEN
         transaction_code_ := 'OERET-NC';
      ELSIF ordrow_rec_.exchange_item = 'EXCHANGED ITEM' THEN
         transaction_code_ := 'OERET-EX';
      ELSE
         transaction_code_ := 'OERETURN';
      END IF;
   ELSE
      -- return to different site than RMA site
      org_rma_rec_      := Return_Material_API.Get(originating_rma_no_);
      org_rma_line_no_  := Get_Originating_Rma_Line_No(rma_no_, rma_line_no_);
      org_rma_line_rec_ := Return_Material_Line_API.Get(originating_rma_no_, org_rma_line_no_);

      IF (org_rma_rec_.return_to_vendor_no IS NOT NULL) THEN
         delivered_co_line_rec_ := Customer_Order_Line_API.Get(org_rma_line_rec_.order_no, org_rma_line_rec_.line_no, org_rma_line_rec_.rel_no, org_rma_line_rec_.line_item_no);
      END IF;
      
      $IF Component_Purch_SYS.INSTALLED $THEN
         IF (delivered_co_line_rec_.demand_order_ref1 IS NOT NULL) THEN
            demand_ord_company_ := Purchase_Order_Line_API.Get_Company(delivered_co_line_rec_.demand_order_ref1, delivered_co_line_rec_.demand_order_ref2, delivered_co_line_rec_.demand_order_ref3);
         END IF;
      $END
      
      org_return_company_ := Site_API.Get_Company(org_rma_rec_.contract);
      IF ( org_return_company_ != Site_API.Get_Company(org_rma_rec_.return_to_contract)) THEN
         IF ((org_rma_rec_.return_to_contract = NVL(delivered_co_line_rec_.supply_site, ' ')) AND (org_rma_rec_.return_to_vendor_no = NVL(delivered_co_line_rec_.vendor_no, ' '))) THEN
            transaction_code_       := 'OERETURN';
            -- Surrounded with if condition to distinguish the transaction codes if the demand site and
            -- intermediate site are in different companies in a three site intersite flow.            
            -- Changed the transaction code from 'RETPODIRSH' to 'RETPODSINT' in order to cater returns from a three site intersite flow without accounting issues.
            IF (NVL(demand_ord_company_, Database_SYS.string_null_) != org_return_company_) THEN
               demand_site_trans_code_ := 'RETPODIRSH';
            ELSE
               demand_site_trans_code_ := 'RETPODSINT';
            END IF;
         END IF;
      ELSE
         IF ((org_rma_rec_.return_to_contract = NVL(delivered_co_line_rec_.supply_site, ' ')) AND (org_rma_rec_.return_to_vendor_no = NVL(delivered_co_line_rec_.vendor_no, ' '))) THEN
            transaction_code_       := 'RETSHIPDIR';
            demand_site_trans_code_ := 'RETINTPODS';
         ELSE
            transaction_code_       := 'RETDIFSREC';
            demand_site_trans_code_ := 'RETINTPODS';
         END IF;
      END IF;
   END IF;

   Trace_SYS.Field('CONTRACT_           ', contract_);
   Trace_SYS.Field('PART_NO_            ', part_no_);
   Trace_SYS.Field('CONFIGURATION_ID_   ', configuration_id_);
   Trace_SYS.Field('LOCATION_NO_        ', location_no_);
   Trace_SYS.Field('LOT_BATCH_NO_       ', lot_batch_no_);
   Trace_SYS.Field('SERIAL_NO_          ', serial_no_);
   Trace_SYS.Field('ENG_CHG_LEVEL_      ', eng_chg_level_);
   Trace_SYS.Field('WAIV_DEV_REJ_NO_    ', waiv_dev_rej_no_);
   Trace_SYS.Field('HANDLING_UNIT_ID_   ', handling_unit_id_);
   Trace_SYS.Field('TRANSACTION_        ', transaction_code_);
   Trace_SYS.Field('EXPIRATION_DATE_    ', expiration_date_);
   Trace_SYS.Field('QUANTITY_           ', qty_returned_);
   Trace_SYS.Field('QUANTITY_RESERVED_  ', 0);
   Trace_SYS.Field('ORDER_NO_           ', rma_no_);
   Trace_SYS.Field('LINE_ITEM_NO_       ', rma_line_no_);
   Trace_SYS.Field('SOURCE_             ', source_);

   Return_Or_Scrap_Serial___ (rma_no_,
                              rma_line_no_,
                              part_no_,
                              serial_no_,
                              configuration_id_,
                              qty_returned_,
                              newrec_,
                              org_rma_rec_,
                              rma_rec_,
                              ordrow_rec_,
                              'RETURN');

   activity_seq_ := NVL(ordrow_rec_.activity_seq, 0);
   IF transaction_code_ = 'OERETURN' THEN
      IF ordrow_rec_.supply_code IN ('IO', 'PD', 'IPD') THEN
         activity_seq_ := 0;
      END IF;
   END IF;

   -- In same company when direct delivery return, RETSHIPDIR and RETDIFSREC transactions in receipt site are created after creating transactions for originating rma site
   -- transaction, RETINTPODS as the same cost should be taken.
   -- In different company, when direct delivery return, the receipt site transaction OERETURN also created after creating originating transaction RETPODIRSH as
   -- to support part serial history current position. Otherwise it shows Return To Supplier instead of In Inventory. But no need to have the same cost.
   -- hence it is handled after Register_Direct_Return is done.
   IF NOT(transaction_code_ IN ('RETSHIPDIR', 'RETDIFSREC') OR (transaction_code_ = 'OERETURN' AND delivered_co_line_rec_.supply_code = 'IPD' AND delivered_co_line_rec_.supply_code IS NOT NULL)) THEN     
      -- RETSHIPDIR transaction is created after creating RETINTPODS transation is in demand site.
      Inventory_Part_In_Stock_API.Receive_Customer_Order_Return (transaction_id_tab_   => transaction_id_tab_,
                                                                 contract_             => contract_,
                                                                 part_no_              => part_no_,
                                                                 configuration_id_     => configuration_id_,
                                                                 location_no_          => location_no_,
                                                                 lot_batch_no_         => lot_batch_no_,
                                                                 serial_no_            => serial_no_,
                                                                 eng_chg_level_        => eng_chg_level_,
                                                                 waiv_dev_rej_no_      => waiv_dev_rej_no_,
                                                                 activity_seq_         => activity_seq_,
                                                                 handling_unit_id_     => handling_unit_id_,
                                                                 transaction_code_     => transaction_code_,
                                                                 expiration_date_      => expiration_date_,
                                                                 qty_returned_         => qty_returned_,
                                                                 catch_qty_returned_   => catch_qty_returned_,
                                                                 rma_no_               => to_char(rma_no_),
                                                                 rma_line_no_          => rma_line_no_,
                                                                 source_               => source_,
                                                                 condition_code_       => temp_condition_code_,
                                                                 part_ownership_db_    => part_ownership_db_,
                                                                 owning_vendor_no_     => owning_vendor_no_,
                                                                 del_reason_id_        => deliv_reason_id_,
                                                                 del_note_no_          => del_note_no_,
                                                                 del_note_date_        => del_note_date_);
                                                                 
      --   gelr:modify_date_applied, begin
      IF (Company_Localization_Info_API.Get_Parameter_Val_From_Site_Db(newrec_.contract,'MODIFY_DATE_APPLIED') = Fnd_Boolean_API.DB_TRUE) THEN
         Modify_Inv_Trans_Date___(transaction_id_tab_,date_applied_);
      END IF;
      --   gelr:modify_date_applied, end
        
      message_ := Language_SYS.Translate_Constant(lu_name_, 'RMALINERETI: Line :P1, returned :P2 item(s) into inventory at location :P3.',
                                                  p1_ => oldrec_.rma_line_no, p2_ => qty_returned_, p3_ => location_no_);
      Return_Material_History_API.New(oldrec_.rma_no, message_);

      IF (transaction_code_ = 'OERET-INT') AND (customer_contract_ IS NOT NULL) AND (newrec_.rental = Fnd_Boolean_API.DB_FALSE)THEN
         IF (transit_eng_chg_level_ IS NOT NULL) THEN
            eng_chg_in_transit_ := transit_eng_chg_level_;
         ELSE
            eng_chg_in_transit_ := eng_chg_level_;
         END IF;

         Inventory_Part_In_Transit_API.Remove_From_Order_Transit(delivering_contract_     => customer_contract_,  
                                                                 contract_                => contract_,
                                                                 part_no_                 => part_no_,            
                                                                 configuration_id_        => configuration_id_,
                                                                 lot_batch_no_            => lot_batch_no_,       
                                                                 serial_no_               => serial_no_,
                                                                 eng_chg_level_           => eng_chg_in_transit_, 
                                                                 waiv_dev_rej_no_         => waiv_dev_rej_no_,
                                                                 handling_unit_id_        => handling_unit_id_,
                                                                 expiration_date_         => expiration_date_,  
                                                                 delivering_warehouse_id_ => '*',
                                                                 receiving_warehouse_id_  => '*',
                                                                 activity_seq_            => 0 ,
                                                                 part_ownership_db_       => Part_Ownership_API.DB_COMPANY_OWNED,
                                                                 owning_customer_no_      => '*',
                                                                 owning_vendor_no_        => '*',
                                                                 deliv_no_                => 0,
                                                                 shipment_id_             => 0,
                                                                 shipment_line_no_        => 0,
                                                                 qty_to_remove_           => qty_returned_,
                                                                 catch_qty_to_remove_     => catch_qty_returned_, 
                                                                 remove_unit_cost_        => FALSE);
      END IF;
      IF (transaction_code_ = 'OERET-NC') THEN
         Set_Demand_Order_As_Alt_Ref___(transaction_id_tab_,
                                        newrec_.order_no,
                                        newrec_.line_no,
                                        newrec_.rel_no,
                                        newrec_.line_item_no,
                                        'PUR ORDER');
      END IF;
   END IF;

   IF (originating_rma_no_ IS NOT NULL) THEN

      Client_SYS.Clear_Attr(attr_);
      oldrec_ := Lock_By_Keys___(originating_rma_no_, org_rma_line_no_);
      newrec_ := oldrec_;

      Get_Converted_Qty___(org_inv_qty_returned_,
                           org_sales_qty_returned_,
                           qty_returned_,
                           NULL,
                           contract_,
                           org_rma_line_rec_.contract,
                           part_no_,
                           org_rma_line_rec_.part_no,
                           org_rma_line_rec_.conv_factor,
                           org_rma_line_rec_.inverted_conv_factor);

      Client_SYS.Add_To_Attr('QTY_RETURNED_INV', NVL(oldrec_.qty_returned_inv, 0) + org_inv_qty_returned_, attr_);
      Client_SYS.Add_To_Attr('DATE_RETURNED', date_received_, attr_);
      
      -- Added the attribute to the attr_ to indicate that user allowed site validation should be bypassed when updating the originating RMA.
      Client_SYS.Add_To_Attr('BYPASS_USER_ALLOWED_SITE', 'TRUE', attr_);
      
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
      Update___(objid_, oldrec_, newrec_, attr_, org_objversion_, TRUE);

      org_message_ := Message_Sys.Construct('RETURN_PART');
      IF (transaction_code_ IN ('RETSHIPDIR', 'RETDIFSREC')) THEN
         Message_SYS.Add_Attribute(org_message_, 'LOCATION_NO', location_no_);
      END IF;

      Message_SYS.Add_Attribute(org_message_, 'LOT_BATCH_NO',        lot_batch_no_);
      Message_SYS.Add_Attribute(org_message_, 'SERIAL_NO',           serial_no_);
      Message_SYS.Add_Attribute(org_message_, 'ENG_CHG_LEVEL',       eng_chg_level_);
      Message_SYS.Add_Attribute(org_message_, 'WAIV_DEV_REJ_NO',     waiv_dev_rej_no_);
      Message_SYS.Add_Attribute(org_message_, 'ACTIVITY_SEQ',        activity_seq_);
      Message_SYS.Add_Attribute(org_message_, 'HANDLING_UNIT_ID',    handling_unit_id_);
      Message_SYS.Add_Attribute(org_message_, 'EXPIRATION_DATE',     expiration_date_);
      Message_SYS.Add_Attribute(org_message_, 'CATCH_QTY_RETURNED',  catch_qty_returned_);
      Message_SYS.Add_Attribute(org_message_, 'INV_QTY_RETURNED',    org_inv_qty_returned_);

      Register_Direct_Return(originating_rma_no_, org_rma_line_no_, NULL, NULL, demand_site_trans_code_, org_message_);

      -- registering OERETURN transaction for direct return different company after RETPODIRSH transaction
      IF (transaction_code_ = 'OERETURN' AND delivered_co_line_rec_.supply_code = 'IPD') THEN
         Inventory_Part_In_Stock_API.Receive_Customer_Order_Return (transaction_id_tab_   => transaction_id_tab_,
                                                                    contract_             => contract_,
                                                                    part_no_              => part_no_,
                                                                    configuration_id_     => configuration_id_,
                                                                    location_no_          => location_no_,
                                                                    lot_batch_no_         => lot_batch_no_,
                                                                    serial_no_            => serial_no_,
                                                                    eng_chg_level_        => eng_chg_level_,
                                                                    waiv_dev_rej_no_      => waiv_dev_rej_no_,
                                                                    activity_seq_         => activity_seq_,
                                                                    handling_unit_id_     => handling_unit_id_,
                                                                    transaction_code_     => transaction_code_,
                                                                    expiration_date_      => expiration_date_,
                                                                    qty_returned_         => qty_returned_,
                                                                    catch_qty_returned_   => catch_qty_returned_,
                                                                    rma_no_               => to_char(rma_no_),
                                                                    rma_line_no_          => rma_line_no_,
                                                                    source_               => source_,
                                                                    condition_code_       => temp_condition_code_,
                                                                    part_ownership_db_    => part_ownership_db_,
                                                                    owning_vendor_no_     => owning_vendor_no_);
         
         --   gelr:modify_date_applied, begin
         IF (Company_Localization_Info_API.Get_Parameter_Val_From_Site_Db(newrec_.contract,'MODIFY_DATE_APPLIED') = Fnd_Boolean_API.DB_TRUE) THEN
            Modify_Inv_Trans_Date___(transaction_id_tab_,date_applied_);  
         END IF;
         --   gelr:modify_date_applied, end
         
         message_ := Language_SYS.Translate_Constant(lu_name_, 'RMALINERETI: Line :P1, returned :P2 item(s) into inventory at location :P3.',
                                                     p1_ => oldrec_.rma_line_no, p2_ => qty_returned_, p3_ => location_no_);
         Return_Material_History_API.New(oldrec_.rma_no, message_);
      END IF;
   END IF;

   Update_License_Coverage_Qty___(rma_no_,
                                  rma_line_no_,
                                  NVL(qty_returned_, catch_qty_returned_));

END Inventory_Return___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
   rma_no_  NUMBER;
   rma_rec_  Return_Material_API.Public_Rec;
BEGIN
   Trace_SYS.Field('preparing insert on', attr_);
   
   rma_no_ := Client_SYS.Get_Item_Value('RMA_NO', attr_);
   rma_rec_ := Return_Material_API.Get(rma_no_);
   super(attr_);
   Client_SYS.Add_To_Attr('CONFIGURATION_ID', '*', attr_);
   Client_SYS.Add_To_Attr('TAX_LIABILITY', rma_rec_.tax_liability, attr_ );
   Client_SYS.Add_To_Attr('REBATE_BUILDER_DB', 'TRUE', attr_);
   Client_SYS.Add_To_Attr('CONV_FACTOR', 1, attr_ );
   Client_SYS.Add_To_Attr('INVERTED_CONV_FACTOR', 1, attr_ );
   Client_SYS.Add_To_Attr('CUSTOMER_TAX_USAGE_TYPE', rma_rec_.customer_tax_usage_type, attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT RETURN_MATERIAL_LINE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   rma_rec_            Return_Material_API.Public_Rec;
   cust_ord_rec_       Customer_Order_API.Public_Rec;
   invoice_id_         NUMBER;
   total_qty_returned_ NUMBER;
   reset_tax_code_     BOOLEAN := FALSE;
   tax_class_id_       VARCHAR2(20);
   original_rma_no_    VARCHAR2(50);
   original_line_no_   VARCHAR2(50);
   tax_method_         VARCHAR2(50);
   tax_from_external_system_ BOOLEAN := FALSE;
   org_customer_no_    VARCHAR2(20);
   
   -- Added part_no, contract, configuration_id to the select list to be able to use the index RETURN_MATERIAL_LINE_1_IX.
   CURSOR get_tot_qty_returned(order_no_ IN VARCHAR2, line_no_ IN VARCHAR2, rel_no_ IN VARCHAR2,
                               line_item_no_ IN NUMBER, invoice_no_ IN VARCHAR2, series_id_ IN VARCHAR2,
                               part_no_ IN VARCHAR2, contract_ IN VARCHAR2, configuration_id_ IN VARCHAR2,
                               company_ IN VARCHAR2) IS
      SELECT SUM(qty_to_return)
      FROM RETURN_MATERIAL_LINE_TAB
      WHERE order_no                = order_no_
      AND line_no                 = line_no_
      AND rel_no                  = rel_no_
      AND line_item_no            = line_item_no_
      AND debit_invoice_no        = invoice_no_
      AND debit_invoice_series_id = series_id_
      AND part_no                 = part_no_
      AND contract                = contract_
      AND configuration_id        = configuration_id_
      AND company                 = company_
      AND rowstate                NOT IN ('Denied', 'Cancelled');
BEGIN
   newrec_.note_id := Document_Text_API.Get_Next_Note_Id;
   Client_SYS.Add_To_Attr('NOTE_ID', newrec_.note_id, attr_);
   
   rma_rec_        := Return_Material_API.Get(newrec_.rma_no);
   
   IF (newrec_.customer_tax_usage_type IS NULL) THEN
      newrec_.customer_tax_usage_type := rma_rec_.customer_tax_usage_type;
      Client_SYS.Add_To_Attr('CUSTOMER_TAX_USAGE_TYPE',newrec_.customer_tax_usage_type, attr_);
   END IF;         
   
   original_rma_no_      := Client_SYS.Get_Item_Value('ORIGINAL_RMA_NO', attr_);
   original_line_no_     := Client_SYS.Get_Item_Value('ORIGINAL_LINE_NO', attr_);
   org_customer_no_ := Return_Material_API.Get_Customer_No(original_rma_no_);
   IF (Client_SYS.Get_Item_Value('SET_TAX_FROM_ORIGINAL', attr_) = 'TRUE') AND 
      (org_customer_no_ = rma_rec_.customer_no) THEN
      newrec_.tax_class_id := Get_Tax_Class_Id(original_rma_no_, 
                                               original_line_no_); 
   END IF;
   IF (Sales_Part_API.Get_Catalog_Type_Db(newrec_.contract, newrec_.catalog_no) = 'NON' AND newrec_.part_no IS NOT NULL) THEN
      newrec_.part_no := NULL;
   END IF;
   super(objid_, objversion_, newrec_, attr_);

   $IF Component_Jinsui_SYS.INSTALLED $THEN
      IF rma_rec_.jinsui_invoice ='TRUE' THEN
         Validate_Jinsui_Constraints___(newrec_);
      ELSIF (newrec_.order_no IS NOT NULL) THEN
         --check if the connected order is jinsui or not
         cust_ord_rec_ := Customer_Order_API.Get(newrec_.order_no);
         IF (cust_ord_rec_.jinsui_invoice='TRUE') THEN
            Error_SYS.Record_General(lu_name_, 'JINSUICONNECT: Connected Order or Invoice should not be enabled for Jinsui.');
         END IF;
      END IF;
   $END
   
   tax_method_ := Company_Tax_Control_API.Get_External_Tax_Cal_Method_Db(newrec_.company);
   -- gelr:br_external_tax_integration, begin
   IF (tax_method_ = External_Tax_Calc_Method_API.DB_AVALARA_TAX_BRAZIL) THEN
      -- Return Material Lines are not handled for Avalara Brazil in initial release
      tax_method_ := External_Tax_Calc_Method_API.DB_NOT_USED;
   END IF;
   -- gelr:br_external_tax_integration, end
   IF (tax_method_ != External_Tax_Calc_Method_API.DB_NOT_USED) THEN
      reset_tax_code_ := TRUE;
      tax_from_external_system_ := TRUE;
   ELSE
      IF (NVL(Client_SYS.Get_Item_Value('FETCH_TAX_CODES', attr_), 'TRUE') = 'TRUE') THEN
         IF((newrec_.order_no IS NOT NULL) OR (newrec_.debit_invoice_no IS NOT NULL)) THEN
            reset_tax_code_ := TRUE;      
         ELSIF (newrec_.tax_calc_structure_id IS NOT NULL) THEN
            reset_tax_code_ := FALSE;         
         ELSE      
            reset_tax_code_ := (Client_SYS.Get_Item_Value('FEE_CODE', attr_) IS NULL);
         END  IF;            
      END IF; 
   END IF;
   -- If the line is copied or duplicated, taxes should be copied from the original line.
   IF (Client_SYS.Get_Item_Value('SET_TAX_FROM_ORIGINAL', attr_) = 'TRUE') AND (NOT tax_from_external_system_) AND 
      (org_customer_no_ = rma_rec_.customer_no) THEN
      reset_tax_code_ := FALSE;
      Tax_Handling_Order_Util_API.Transfer_Tax_lines(newrec_.company, 
                                                     Tax_Source_API.DB_RETURN_MATERIAL_LINE, 
                                                     original_rma_no_, 
                                                     original_line_no_, 
                                                     '*', 
                                                     '*', 
                                                     '*',
                                                     Tax_Source_API.DB_RETURN_MATERIAL_LINE, 
                                                     newrec_.rma_no, 
                                                     newrec_.rma_line_no, 
                                                     '*', 
                                                     '*', 
                                                     '*',
                                                     'TRUE',
                                                     'FALSE');      
   END IF; 
   Tax_Check___(newrec_, newrec_, TRUE, FALSE, reset_tax_code_);
   IF((newrec_.order_no IS NOT NULL) AND (newrec_.debit_invoice_no IS NULL)) THEN
      tax_class_id_ := Customer_Order_Line_API.Get_Tax_Class_Id(newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no); 
      IF (tax_class_id_ IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('TAX_CLASS_ID', tax_class_id_, attr_);
         Modify_Tax_Class_Id(attr_, newrec_.rma_no, newrec_.rma_line_no);
      END IF;
   END IF;
  
   -- Cannot do this check in Unpack_Check_insert since the Finite_State_Init___ clears the info.
   IF (newrec_.debit_invoice_no IS NOT NULL) THEN
      invoice_id_ := Customer_Order_Inv_Head_API.Get_Invoice_Id_By_No(newrec_.company, newrec_.debit_invoice_no, newrec_.debit_invoice_series_id);
      IF (invoice_id_ IS NOT NULL) THEN
         OPEN get_tot_qty_returned(newrec_.order_no, newrec_.line_no, newrec_.rel_no,
                                   newrec_.line_item_no, newrec_.debit_invoice_no, newrec_.debit_invoice_series_id,
                                   newrec_.part_no, newrec_.contract, newrec_.configuration_id, newrec_.company);
         FETCH get_tot_qty_returned INTO total_qty_returned_;
         CLOSE get_tot_qty_returned;

         IF (NVL(total_qty_returned_, 0) > Customer_Order_Inv_Item_API.Get_Invoiced_Qty(invoice_id_, newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no )) THEN
            Client_SYS.Add_Info(lu_name_, 'CANNOTEXCEEDQTYTORET: The quantity to return exceeds the quantity on reference invoice line.');
         END IF;
      END IF;
   END IF;
   objversion_ := to_char(newrec_.rowversion,'YYYYMMDDHH24MISS');

   -- Find and Connect Export License
   Find_And_Conn_Exp_License___(newrec_.rma_no, newrec_.rma_line_no);

   Return_Material_Charge_API.Recalc_Percentage_Charge_Taxes(newrec_.rma_no, tax_from_external_system_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     RETURN_MATERIAL_LINE_TAB%ROWTYPE,
   newrec_     IN OUT RETURN_MATERIAL_LINE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   info_                       VARCHAR2(2000);
   objid2_                     VARCHAR2(2000);
   sum_returned_               NUMBER;
   salerec_                    Sales_Part_API.Public_Rec;
   message_                    RETURN_MATERIAL_HISTORY_TAB.message_text%TYPE;
   rma_rec_                    Return_Material_API.Public_Rec;
   cust_ord_rec_               Customer_Order_API.Public_Rec;
   update_tax_from_ship_addr_  VARCHAR2(5);
   ship_addr_changed_          BOOLEAN := FALSE ;
   ord_connection_changed_     BOOLEAN := FALSE;
   refresh_tax_code_           BOOLEAN := FALSE;
   total_qty_returned_         NUMBER;
   invoice_id_                 NUMBER;
   tax_liability_type_         VARCHAR2(20);
   tax_from_defaults_          BOOLEAN;
   rowid_                      VARCHAR2(2000);
   tax_code_changed_           VARCHAR2(5) := 'FALSE';
   multiple_tax_lines_         VARCHAR2(20);
   tax_item_removed_           VARCHAR2(5) := 'FALSE';
   tax_method_                 VARCHAR2(50);
   update_tax_                 VARCHAR2(5) := 'TRUE';
   
   -- Added part_no, contract, configuration_id to the select list to be able to use the index RETURN_MATERIAL_LINE_1_IX.
   CURSOR get_tot_qty_returned(order_no_ IN VARCHAR2, line_no_ IN VARCHAR2, rel_no_ IN VARCHAR2,
                               line_item_no_ IN NUMBER, invoice_no_ IN VARCHAR2, series_id_ IN VARCHAR2,
                               part_no_ IN VARCHAR2, contract_ IN VARCHAR2, configuration_id_ IN VARCHAR2,
                               company_ IN VARCHAR2) IS
      SELECT SUM(qty_to_return)
      FROM RETURN_MATERIAL_LINE_TAB
      WHERE order_no              = order_no_
      AND line_no                 = line_no_
      AND rel_no                  = rel_no_
      AND line_item_no            = line_item_no_
      AND debit_invoice_no        = invoice_no_
      AND debit_invoice_series_id = series_id_
      AND part_no                 = part_no_
      AND contract                = contract_
      AND configuration_id        = configuration_id_
      AND company                 = company_
      AND rowstate                NOT IN ('Denied', 'Cancelled');
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   
   rma_rec_    := Return_Material_API.Get(newrec_.rma_no);
   refresh_tax_code_ := (NVL(Client_SYS.Get_Item_Value('REFRESH_FEE_CODE', attr_), '0') = '1');
   tax_liability_type_ := Get_Tax_Liability_Type_Db(newrec_.rma_no, newrec_.rma_line_no);
   update_tax_ := NVL(Client_SYS.Get_Item_Value('UPDATE_TAX', attr_), 'TRUE');
   IF by_keys_ THEN
      Get_Id_Version_By_Keys___(rowid_, objversion_, newrec_.rma_no, newrec_.rma_line_no);
   ELSE
      rowid_ := objid_;
   END IF;    
   
   tax_method_ := Company_Tax_Control_API.Get_External_Tax_Cal_Method_Db(newrec_.company);
   -- gelr:br_external_tax_integration, begin
   IF (tax_method_ = External_Tax_Calc_Method_API.DB_AVALARA_TAX_BRAZIL) THEN
      -- Avalara Brazil only supports Customer Order lines and Invoice lines in initial release
      tax_method_ := External_Tax_Calc_Method_API.DB_NOT_USED;
   END IF;
   -- gelr:br_external_tax_integration, end
   
   IF (refresh_tax_code_) THEN
      multiple_tax_lines_  := Client_SYS.Get_Item_Value('MULTIPLE_TAX_LINES', attr_);      
      IF ((newrec_.fee_code IS NULL) AND (newrec_.tax_calc_structure_id IS NULL) 
         AND (multiple_tax_lines_ IS NOT NULL) AND (multiple_tax_lines_ = 'FALSE')) THEN

         tax_item_removed_ := 'TRUE';

         Source_Tax_Item_Order_API.Remove_Tax_Items(newrec_.company, 
                                                   Tax_Source_API.DB_RETURN_MATERIAL_LINE,
                                                   TO_CHAR(newrec_.rma_no), 
                                                   TO_CHAR(newrec_.rma_line_no), 
                                                   '*', 
                                                   '*',
                                                   '*');
         Tax_Handling_Util_API.Validate_Tax_Code_Mandatory(newrec_.company, 'CUSTOMER_TAX');      
      END IF;
      -- modifies the tax line tax code with the new tax code of the return material line at the same time.
      IF ((tax_item_removed_ != 'TRUE') AND (update_tax_ = 'TRUE') AND (Str_Diff___(newrec_.fee_code, oldrec_.fee_code) OR 
          (Str_Diff___(oldrec_.tax_liability, newrec_.tax_liability)) OR
          (Str_Diff___(oldrec_.order_no, newrec_.order_no)) OR 
          (Str_Diff___(oldrec_.debit_invoice_item_id, newrec_.debit_invoice_item_id)) OR
          (Str_Diff___(newrec_.tax_calc_structure_id, oldrec_.tax_calc_structure_id)))) THEN
         
         IF (((newrec_.order_no IS NULL) AND (newrec_.debit_invoice_no IS NULL)) OR 
             (Str_Diff___(oldrec_.tax_liability, newrec_.tax_liability)) OR
             (Str_Diff___(newrec_.fee_code, oldrec_.fee_code)) OR
             (Str_Diff___(newrec_.tax_calc_structure_id, oldrec_.tax_calc_structure_id))) THEN
            IF (((Str_Diff___(oldrec_.order_no, newrec_.order_no)) OR (Str_Diff___(oldrec_.debit_invoice_item_id, newrec_.debit_invoice_item_id)) OR
                 (Str_Diff___(oldrec_.tax_liability, newrec_.tax_liability))
                ) AND nvl(Client_SYS.Get_Item_Value('FETCH_TAX_FROM_DEFAULTS', attr_), 'TRUE') = 'TRUE') THEN
               tax_from_defaults_ := TRUE;
            ELSE
               tax_from_defaults_ := FALSE;
            END IF;
            Add_Transaction_Tax_Info___ (newrec_,  
                                         newrec_.company,                                      
                                         rma_rec_.return_from_customer_no,
                                         rma_rec_.ship_addr_no,                                      
                                         rma_rec_.supply_country,                                        
                                         rma_rec_.use_price_incl_tax,
                                         rma_rec_.currency_code,                                       
                                         tax_from_defaults_ => tax_from_defaults_,                                      
                                         add_tax_lines_     => TRUE,
                                         attr_              => NULL);
         END IF;         
      END IF;
   END IF;
   
   $IF Component_Jinsui_SYS.INSTALLED $THEN
      IF rma_rec_.jinsui_invoice ='TRUE' THEN
          Validate_Jinsui_Constraints___(newrec_);
      ELSIF (newrec_.order_no IS NOT NULL) THEN
         --check if the connected order is jinsui or not
         cust_ord_rec_ := Customer_Order_API.Get(newrec_.order_no);
         IF (cust_ord_rec_.jinsui_invoice='TRUE') THEN
            Error_SYS.Record_General(lu_name_, 'JINSUICONNECT: Connected Order or Invoice should not be enabled for Jinsui.');
         END IF;
      END IF;
   $END

   -- Extra stuff to automatically trigger the state machine
   Trace_SYS.Field('RMA Line Update state', newrec_.rowstate);

   IF (newrec_.rowstate IN ('Released', 'PartiallyReceived', 'Received' )) THEN
      IF (nvl(newrec_.qty_received, 0) != nvl(oldrec_.qty_received, 0)) OR
          (nvl(newrec_.qty_to_return, 0) != nvl(oldrec_.qty_to_return, 0)) OR
          (nvl(newrec_.qty_returned_inv, 0) != nvl(oldrec_.qty_returned_inv, 0)) OR
          (nvl(newrec_.qty_scrapped, 0) != nvl(oldrec_.qty_scrapped, 0)) THEN
         IF by_keys_ THEN
            Get_Id_Version_By_Keys___(objid2_, objversion_, newrec_.rma_no, newrec_.rma_line_no);
         ELSE
            objid2_ := objid_;
         END IF;
         Qty_Changed__(info_ , objid2_ , objversion_ , attr_ , 'DO');
      END IF;
   ELSIF (newrec_.rowstate IN ('ReturnCompleted')) THEN
      IF (newrec_.qty_to_return != oldrec_.qty_to_return) THEN
         IF by_keys_ THEN
            Get_Id_Version_By_Keys___(objid2_ , objversion_, newrec_.rma_no, newrec_.rma_line_no);
         ELSE
            objid2_ := objid_;
         END IF;
         Qty_To_Return_Increased__(info_, objid2_, objversion_, attr_, 'DO');
      END IF;
   END IF;

   IF((NVL(newrec_.order_no,     ' ') != NVL(oldrec_.order_no,    ' '))OR
      (NVL(newrec_.line_no,      ' ') != NVL(oldrec_.line_no,     ' '))OR
      (NVL(newrec_.rel_no,       ' ') != NVL(oldrec_.rel_no,      ' '))OR
      (NVL(newrec_.line_item_no,  -2) != NVL(oldrec_.line_item_no, -2))) THEN
      ord_connection_changed_ := TRUE;
   END IF;
   -- Modify orderline returned qty
   IF ((ord_connection_changed_) OR (NVL(newrec_.qty_received, 0) != NVL(oldrec_.qty_received, 0))) THEN
      IF(newrec_.order_no IS NOT NULL) THEN
         sum_returned_ := Customer_Order_Line_API.Get_Qty_Returned(newrec_.order_no, newrec_.line_no,
                                                                   newrec_.rel_no, newrec_.line_item_no);

            IF (ord_connection_changed_) THEN
               sum_returned_ := sum_returned_ + NVL(newrec_.qty_received_inv_uom, 0);
            ELSE
               IF (newrec_.part_no IS NULL) THEN
                  sum_returned_ := sum_returned_ + (NVL(newrec_.qty_received, 0) - NVL(oldrec_.qty_received, 0));
               ELSE
                  sum_returned_ := sum_returned_ + (NVL(newrec_.qty_received_inv_uom, 0) - NVL(oldrec_.qty_received_inv_uom, 0));
            END IF;
         END IF;

         Customer_Order_Line_API.Modify_Qty_Returned(newrec_.order_no, newrec_.line_no,
                                                     newrec_.rel_no, newrec_.line_item_no,
                                                     sum_returned_);
      END IF;
      IF((oldrec_.order_no IS NOT NULL) AND (ord_connection_changed_)) THEN
         sum_returned_ := Customer_Order_Line_API.Get_Qty_Returned(oldrec_.order_no, oldrec_.line_no,
                                                                   oldrec_.rel_no, oldrec_.line_item_no);
         sum_returned_ := sum_returned_ - (oldrec_.conv_factor/oldrec_.inverted_conv_factor * NVL(oldrec_.qty_received, 0));
         Customer_Order_Line_API.Modify_Qty_Returned(oldrec_.order_no, oldrec_.line_no,
                                                     oldrec_.rel_no, oldrec_.line_item_no,
                                                     sum_returned_);
      END IF;
   END IF;

   -- IF any of the attributes affecting the total line amount have been changed then
   -- tax lines connected to the order line will have to be recalculated
   -- since the tax amount may have to be updated
   IF ((((newrec_.sale_unit_price) != (oldrec_.sale_unit_price) OR (newrec_.base_sale_unit_price) != (oldrec_.base_sale_unit_price)) AND rma_rec_.use_price_incl_tax = 'FALSE') OR
       (NVL(oldrec_.customer_tax_usage_type,' ') != NVL(newrec_.customer_tax_usage_type,' '))   OR
       (((newrec_.unit_price_incl_tax != oldrec_.unit_price_incl_tax) OR (newrec_.base_unit_price_incl_tax != oldrec_.base_unit_price_incl_tax)) AND rma_rec_.use_price_incl_tax = 'TRUE') OR
       (newrec_.qty_to_return) != (oldrec_.qty_to_return)) THEN
      IF (tax_method_ != External_Tax_Calc_Method_API.DB_NOT_USED) THEN
         tax_from_defaults_ := TRUE;
         IF update_tax_ = 'TRUE' THEN 
            Add_Transaction_Tax_Info___ (newrec_,  
                                         newrec_.company,                                      
                                         rma_rec_.return_from_customer_no,
                                         rma_rec_.ship_addr_no,                                      
                                         rma_rec_.supply_country,                                        
                                         rma_rec_.use_price_incl_tax,
                                         rma_rec_.currency_code,                                       
                                         tax_from_defaults_ => tax_from_defaults_,                                      
                                         add_tax_lines_     => TRUE,
                                         attr_              => NULL);
         END IF;
      ELSE
         tax_from_defaults_ := FALSE;
         Recalculate_Tax_Lines___(newrec_,                                  
                                  newrec_.company,                                  
                                  rma_rec_.customer_no,
                                  rma_rec_.ship_addr_no,
                                  rma_rec_.supply_country,
                                  rma_rec_.use_price_incl_tax,
                                  rma_rec_.currency_code,
                                  tax_from_defaults_,
                                  NULL);
      END IF;      
      Return_Material_Charge_API.Recalc_Percentage_Charge_Taxes(newrec_.rma_no, tax_from_defaults_);
   END IF;
   
   salerec_ := Sales_Part_API.Get(newrec_.contract, newrec_.catalog_no);
   -- in multi-site returns Account_Non_Invent___ does not executed in demand site but the corresponding transaction is handled in Register_Direct_Return method which contains alt_source_ref information.
   IF ((salerec_.catalog_type = 'NON') AND ((rma_rec_.contract = rma_rec_.return_to_contract) OR (rma_rec_.return_to_vendor_no IS NULL AND rma_rec_.return_to_contract IS NULL))) THEN
      IF nvl(newrec_.qty_received, 0) > nvl(oldrec_.qty_received, 0) THEN
         Account_Non_Invent___(
            newrec_.company,
            newrec_.rma_no, newrec_.rma_line_no,
            newrec_.order_no, newrec_.line_no,
            newrec_.rel_no, newrec_.line_item_no,
            newrec_.contract, newrec_.catalog_no, newrec_.configuration_id,
            nvl(newrec_.qty_received, 0) - nvl(oldrec_.qty_received, 0));
      END IF;
   END IF;

   IF nvl(newrec_.qty_received, 0) != nvl(oldrec_.qty_received, 0) THEN
      message_ := Language_SYS.Translate_Constant(lu_name_, 'RMALINEREC: Line :P1, :P2 :P3 received.',
                                                  p1_ => newrec_.rma_line_no,
                                                  p2_ => nvl(newrec_.qty_received, 0) - nvl(oldrec_.qty_received, 0),
                                                  p3_ => newrec_.catalog_no);
      Return_Material_History_API.New(oldrec_.rma_no, message_);
   END IF;

   update_tax_from_ship_addr_  := Client_SYS.Get_Item_Value('UPDATE_TAX_FROM_SHIP_ADDR', attr_);
   IF (update_tax_from_ship_addr_ IS NOT NULL) THEN
      ship_addr_changed_ := TRUE;
      
      IF (tax_method_ != External_Tax_Calc_Method_API.DB_NOT_USED) THEN
         tax_from_defaults_ := TRUE;
      END IF;
   END IF;
   IF (tax_item_removed_ != 'TRUE') AND update_tax_ = 'TRUE' THEN
      Tax_Check___(newrec_, oldrec_, FALSE, ship_addr_changed_, nvl(tax_from_defaults_, TRUE));
   END IF;
   
   tax_code_changed_ := NVL(Client_Sys.Get_Item_Value('TAX_CODE_CHANGED', attr_), 'FALSE');
   IF (tax_code_changed_ = 'TRUE') THEN
      Calculate_Prices___(newrec_);
      Update_Line___(rowid_, newrec_);
   END IF;
   
   IF (newrec_.debit_invoice_no IS NOT NULL) AND ((newrec_.qty_to_return != oldrec_.qty_to_return) OR (newrec_.debit_invoice_no != oldrec_.debit_invoice_no)) THEN
      invoice_id_ := Customer_Order_Inv_Head_API.Get_Invoice_Id_By_No(newrec_.company, newrec_.debit_invoice_no, newrec_.debit_invoice_series_id);
      IF (invoice_id_ IS NOT NULL) THEN
         OPEN get_tot_qty_returned(newrec_.order_no, newrec_.line_no, newrec_.rel_no,
                                   newrec_.line_item_no, newrec_.debit_invoice_no, newrec_.debit_invoice_series_id,
                                   newrec_.part_no, newrec_.contract, newrec_.configuration_id, newrec_.company);
         FETCH get_tot_qty_returned INTO total_qty_returned_;
         CLOSE get_tot_qty_returned;
         IF (NVL(total_qty_returned_, 0) > Customer_Order_Inv_Item_API.Get_Invoiced_Qty(invoice_id_, newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no )) THEN
            Client_SYS.Add_Info(lu_name_, 'CANNOTEXCEEDQTYTORET: The quantity to return exceeds the quantity on reference invoice line.');
         END IF;
      END IF;
   END IF;

   -- Multi Site modification
   IF (NVL(newrec_.qty_received, 0) != NVL(oldrec_.qty_received, 0)) OR
       (NVL(newrec_.qty_to_return, 0) != NVL(oldrec_.qty_to_return, 0)) OR
       (NVL(newrec_.order_no, Database_SYS.string_null_)  != NVL(oldrec_.order_no, Database_SYS.string_null_)) THEN
      Modify_Multi_Site_Rma___(newrec_, oldrec_);
   END IF;
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN RETURN_MATERIAL_LINE_TAB%ROWTYPE )
IS   
   rma_rec_    Return_Material_API.Public_Rec;
BEGIN
   rma_rec_ := Return_Material_API.Get(remrec_.rma_no);
   IF rma_rec_.rma_report_printed = Rma_Report_Printed_API.Decode('PRINTED') THEN
      Client_SYS.Add_Warning(lu_name_, 'RMAPRINTED: The RMA has already been printed.');
   END IF ;

   Customer_Order_Flow_API.Check_Delete_Exp_License(remrec_.rma_no, remrec_.rma_line_no, NULL, NULL, 'RMA');

   IF (remrec_.originating_rma_line_no IS NOT NULL AND (remrec_.rowstate IN ('Released', 'Planned'))) THEN
      IF (Check_Exist___(rma_rec_.originating_rma_no, remrec_.originating_rma_line_no)) THEN
         Error_SYS.record_general(lu_name_, 'DELETE_RECEIPT_RMA_LINE: The receipt RMA line(s) cannot be deleted.');
      END IF;
   END IF;
   IF (remrec_.rowstate = 'Released' AND remrec_.credit_invoice_no IS NOT NULL) THEN
      Error_SYS.record_general(lu_name_, 'RMALINECREDITED: Credit invoiced line may not be deleted.');
   END IF;
   IF (remrec_.rowstate != 'Planned') THEN
      Error_SYS.Record_General(lu_name_, 'RMALINENODEL: The RMA line can not be deleted!');
   END IF;

   super(remrec_);
END Check_Delete___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN RETURN_MATERIAL_LINE_TAB%ROWTYPE )
IS
   message_              VARCHAR2(2000);
   receipt_rma_no_       NUMBER;
   receipt_rma_line_rec_ RETURN_MATERIAL_LINE_TAB%ROWTYPE;
   receipt_objid_        VARCHAR2(2000);
   receipt_objversion_   VARCHAR2(2000);
BEGIN
   super(objid_, remrec_);
   Return_Material_API.Refresh_State(remrec_.rma_no);

   Customer_Order_Flow_API.Remove_Connected_Exp_Licenses(remrec_.rma_no, remrec_.rma_line_no, NULL, NULL, 'RMA');

   IF (remrec_.receipt_rma_line_no IS NOT NULL) THEN
      receipt_rma_no_ := Return_Material_API.Get_Receipt_Rma_No(remrec_.rma_no);
      Get_Id_Version_By_Keys___(receipt_objid_, receipt_objversion_, receipt_rma_no_, remrec_.receipt_rma_line_no);
      receipt_rma_line_rec_ := Lock_By_Id___(receipt_objid_, receipt_objversion_);
      Check_Delete___(receipt_rma_line_rec_);
      Delete___(receipt_objid_, receipt_rma_line_rec_);
   END IF;
   Return_Material_Charge_API.Recalc_Percentage_Charge_Taxes(remrec_.rma_no, FALSE);

   Source_Tax_Item_Order_API.Remove_Tax_Items(remrec_.company,
                                              Tax_Source_API.DB_RETURN_MATERIAL_LINE,
                                              TO_CHAR(remrec_.rma_no),
                                              TO_CHAR(remrec_.rma_line_no),
                                              '*',
                                              '*',
                                              '*');
   message_ := Language_SYS.Translate_Constant(lu_name_, 'RMALINEDEL: Line :P1 deleted.',
                                               p1_ => remrec_.rma_line_no);
   Return_Material_History_API.New(remrec_.rma_no, message_);
END Delete___;

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     return_material_line_tab%ROWTYPE,
   newrec_ IN OUT return_material_line_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   rma_rec_   Return_Material_API.Public_Rec;
BEGIN
      
   super(oldrec_, newrec_, indrec_, attr_);
   IF (newrec_.rental = Fnd_Boolean_API.DB_TRUE) THEN
      rma_rec_ := Return_Material_API.Get(newrec_.rma_no);
      IF (rma_rec_.return_to_contract IS NOT NULL AND rma_rec_.contract != rma_rec_.return_to_contract) THEN
         Error_SYS.Record_General(lu_name_,'CANNOTADDRENTLINE: It is not possible to add rental lines when the Return to Site field value is different to the return material authorization site.');
      END IF;
   END IF;
   -- gelr:modify_date_applied, begin
   IF ((Company_Localization_Info_API.Get_Parameter_Val_From_Site_Db(newrec_.contract, 'MODIFY_DATE_APPLIED') = Fnd_Boolean_API.DB_TRUE) AND 
      (NVL(newrec_.arrival_date, Database_SYS.first_calendar_date_) != NVL(oldrec_.arrival_date, Database_SYS.first_calendar_date_))) THEN
      IF (trunc(newrec_.arrival_date) > trunc(Site_API.Get_Site_Date(newrec_.contract)))THEN
         Error_SYS.Record_General(lu_name_, 'CANTBEFUTUREDATE: Arrival Date cannot be a future date than the Site Date.');
      END IF;
   END IF;
   -- gelr:modify_date_applied, end   
END Check_Common___;

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT return_material_line_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   salerec_               Sales_Part_API.Public_Rec;
   con_code_usage_        VARCHAR2(20);
   order_no_entered_      BOOLEAN := FALSE;
   invoice_id_            NUMBER;
   delivery_country_code_ VARCHAR2(2);
   qty_edited_flag_       VARCHAR2(20);
   id_no_                 VARCHAR2(50);
   shipment_id_           NUMBER;
   tax_code_from_attr_    RETURN_MATERIAL_LINE_TAB.fee_code%TYPE;
   rma_rec_               Return_Material_API.Public_Rec;
   inv_type_rec_          Company_Def_Invoice_Type_API.Public_Rec;
   inv_head_rec_          Customer_Order_Inv_Head_API.Public_Rec;
BEGIN  
   rma_rec_ := Return_Material_API.Get(newrec_.rma_no);
   
   IF (newrec_.tax_liability IS NULL OR NOT(indrec_.tax_liability)) THEN
      newrec_.tax_liability  := NVL(rma_rec_.tax_liability,'EXEMPT');
   END IF;

   IF NOT(indrec_.conv_factor) THEN
      newrec_.conv_factor := 1;
   END IF;

   IF NOT(indrec_.inverted_conv_factor) THEN
      newrec_.inverted_conv_factor := 1;
   END IF;

   IF (indrec_.order_no) THEN
      order_no_entered_ := TRUE;
   END IF;

   IF (indrec_.credit_approver_id AND newrec_.credit_approver_id IS NOT NULL) THEN
      Order_Coordinator_API.Exist(newrec_.credit_approver_id, true);
   END IF;

   IF (Client_SYS.Item_Exist('UPDATE_TAX_FROM_SHIP_ADDR', attr_)) THEN
      Error_SYS.Item_Insert(lu_name_, 'UPDATE_TAX_FROM_SHIP_ADDR');
   END IF; 
   
   newrec_.rental := NVL(Customer_Order_Line_API.Get_Rental_Db(newrec_.order_no,
                                                               newrec_.line_no,
                                                               newrec_.rel_no,
                                                               newrec_.line_item_no), Fnd_Boolean_API.DB_FALSE);
   
   tax_code_from_attr_ := newrec_.fee_code;

   IF (Client_SYS.Item_Exist('QTY_EDITED_FLAG', attr_)) THEN
      qty_edited_flag_ := Client_SYS.Get_Item_Value('QTY_EDITED_FLAG', attr_);
   END IF;

   IF (qty_edited_flag_ IS NULL) THEN
      IF newrec_.debit_invoice_no IS NOT NULL THEN
         qty_edited_flag_ := 'INVOICE';
      ELSIF newrec_.order_no IS NOT NULL THEN
         qty_edited_flag_ := 'CO';
      ELSIF newrec_.purchase_order_no IS NOT NULL THEN
         qty_edited_flag_ := 'CPO';
      ELSE
         qty_edited_flag_ := 'EDITED';
      END IF;
   END IF;

   -- When the QTY_TO_RETURN is edited manually.
   IF (qty_edited_flag_ = 'EDITED') THEN
      newrec_.qty_to_return_inv_uom := newrec_.qty_to_return * newrec_.conv_factor/NVL(newrec_.inverted_conv_factor,1);
   -- When QTY_TO_RETURN is NOT edited manually.
   ELSE
      -- Entered the ORDER_NO = 'CO'
      IF qty_edited_flag_ = 'CO' THEN
         id_no_ := newrec_.order_no;
         shipment_id_ := rma_rec_.shipment_id;
         IF (newrec_.originating_rma_line_no IS NULL) THEN
            IF (shipment_id_ IS NULL) THEN
               newrec_.qty_to_return_inv_uom := Cal_Qty_To_Return_Inv_Uom(newrec_.order_no,
                                                                          newrec_.line_no,
                                                                          newrec_.rel_no,
                                                                          newrec_.line_item_no);
            ELSE
               newrec_.qty_to_return_inv_uom := Cal_Ship_Qty_To_Return_Inv_Uom(newrec_.order_no,
                                                                               newrec_.line_no,
                                                                               newrec_.rel_no,
                                                                               newrec_.line_item_no,
                                                                               shipment_id_);
            END IF;
         END IF;
      -- Entered the PURCHASE_ORDER_NO = 'CPO'
      ELSIF qty_edited_flag_ = 'CPO' THEN
         id_no_ := newrec_.purchase_order_no;
      -- Entered the DEBIT_INVOICE_NO = 'INVOICE'
      ELSIF qty_edited_flag_ = 'INVOICE' THEN
         id_no_ := newrec_.debit_invoice_no;
      END IF;

      IF (newrec_.originating_rma_line_no IS NULL) THEN
         newrec_.qty_to_return := Cal_Qty_To_Return_Sales_Uom(newrec_.rma_no,
                                                              newrec_.rma_line_no,
                                                              id_no_,
                                                              qty_edited_flag_,
                                                              newrec_.contract,
                                                              newrec_.catalog_no,
                                                              newrec_.debit_invoice_series_id,
                                                              newrec_.order_no,
                                                              newrec_.line_no,
                                                              newrec_.rel_no,
                                                              newrec_.line_item_no);
      END IF;

      IF qty_edited_flag_ <> 'CO' THEN
         -- Calculate the qty_to_return_inv_uom based on the qty_to_return.
         newrec_.qty_to_return_inv_uom := newrec_.qty_to_return * newrec_.conv_factor/NVL(newrec_.inverted_conv_factor,1);
      END IF;
   END IF;

   IF (newrec_.debit_invoice_no IS NOT NULL) AND (newrec_.debit_invoice_series_id IS NULL) THEN
      Error_SYS.Appl_General(lu_name_,'NO_SERIES_ID_DEB: Invoice series must have a value when the RMA line is connected to a debit invoice');
   END IF;

   IF newrec_.order_no IS NOT NULL THEN
      Validate_Conn_Purch_Line___(newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
   END IF;

   IF (newrec_.debit_invoice_no IS NOT NULL) THEN
      IF (newrec_.debit_invoice_series_id IS NULL) THEN
         Error_SYS.Record_General(lu_name_,'NO_SERIES_ID: Invoice series must have a value when the RMA line is connected to a reference invoice');
      END IF;
      invoice_id_ := Customer_Order_Inv_Head_API.Get_Invoice_Id_By_No(newrec_.company, newrec_.debit_invoice_no, newrec_.debit_invoice_series_id);

      IF (newrec_.rental = Fnd_Boolean_API.DB_TRUE) THEN
         Error_SYS.Record_General(lu_name_,'NORENTALIVCRMALINES: You cannot connect rental invoices to return material authorization lines.');
      END IF;

      IF (invoice_id_ IS NULL) THEN
         Error_SYS.Appl_General(lu_name_,'NOPRELINVOICE: The Invoice :P1 does not exist. Preliminary Invoice may have been printed', newrec_.debit_invoice_no);
      ELSE
         inv_head_rec_ := Customer_Order_Inv_Head_API.Get(newrec_.company, invoice_id_);
         inv_type_rec_ := Company_Def_Invoice_Type_API.Get(newrec_.company);
        
         IF (inv_head_rec_.correction_invoice_id IS NOT NULL) THEN
            Error_SYS.Record_General(lu_name_, 'INVALIDCORINVTYPE: The reference invoice :P1 is not a last correction invoice.', newrec_.debit_invoice_no);
         END IF;

         IF (inv_head_rec_.invoice_type NOT IN ('CUSTORDDEB', 'CUSTCOLDEB', 'SELFBILLDEB', inv_type_rec_.def_co_cor_inv_type, inv_type_rec_.def_col_cor_inv_type)) THEN
            Error_SYS.Record_General(lu_name_, 'INVALIDCREINVTYPE: The reference invoice :P1 is not a debit/correction invoice.', newrec_.debit_invoice_no);
         END IF;

         IF (Customer_Order_Inv_Item_API.Is_Valid_Co_Line(newrec_.company,
                                                         invoice_id_,
                                                         newrec_.debit_invoice_item_id,
                                                         newrec_.order_no,
                                                         newrec_.line_no,
                                                         newrec_.rel_no,
                                                         newrec_.line_item_no) = 0) THEN
            Error_SYS.Appl_General(lu_name_,'INVMNOTMATCHED: The Debit Invoice does not match with the information on the RMA. Customer, Order, Sales Part or Site');
         END IF;
      END IF;
   END IF;

   IF newrec_.rma_line_no IS NULL THEN
      Get_Line_No__(newrec_.rma_line_no, newrec_.rma_no);
      Client_SYS.Add_To_Attr('RMA_LINE_NO', newrec_.rma_line_no, attr_);
      trace_sys.field('Line No', newrec_.rma_line_no);
   END IF;

   IF (newrec_.rental = Fnd_Boolean_API.DB_FALSE) THEN
      IF (newrec_.return_reason_code IS NULL) THEN
         Error_SYS.Appl_General(lu_name_, 'REASONCODEREQD: Return reason is required for non-rental lines.');
      END IF;
   ELSE
       newrec_.rebate_builder := Fnd_Boolean_API.DB_FALSE;
   END IF;
   
   IF (newrec_.configuration_id IS NOT NULL) THEN
      Validate_Configuration_Id___(newrec_);
   END IF;
   
   super(newrec_, indrec_, attr_);
   -- Note: This is to avoid error raise when an order is not connected

   IF (newrec_.order_no IS NOT NULL) THEN
      Valid_Customer_Order_Line___(newrec_, newrec_, TRUE);
       IF (newrec_.catch_qty IS NULL) THEN 
         IF (Part_Catalog_API.Get_Catch_Unit_Enabled_Db(newrec_.part_no) = 'TRUE') THEN
         newrec_.catch_qty := Get_Invoice_Price_Qty(newrec_.rma_no, newrec_.rma_line_no, newrec_.qty_to_return, newrec_.conv_factor);
         END IF;
      END IF;
   END IF;

   IF (newrec_.originating_rma_line_no IS NULL) THEN
      User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, newrec_.contract);
   END IF;

   -- Make sure the specified base sale unit price and sale unit price are valid
   IF newrec_.base_sale_unit_price < 0 THEN
      Error_SYS.Record_General(lu_name_, 'BASE_PRICE_NEGATIVE: Base sale unit price must be greater than zero!');
   END IF;

   IF newrec_.base_unit_price_incl_tax < 0 THEN
      Error_SYS.Record_General(lu_name_, 'BASE_PRICE_INCL_TAX_NEGATIVE: Base Sale Unit Price Including Tax must be greater than zero!');
   END IF;

   IF newrec_.sale_unit_price < 0 THEN
      Error_SYS.Record_General(lu_name_, 'PRICE_LESS_THAN_ZERO: Sale unit price must be greater than zero!');
   END IF;

   IF newrec_.unit_price_incl_tax < 0 THEN
      Error_SYS.Record_General(lu_name_, 'PRICE_INCL_TAX_LESS_THAN_ZERO: Sale Unit Price Including Tax must be greater than zero!');
   END IF;

   IF newrec_.qty_to_return < 0 THEN
      Error_SYS.Record_General(lu_name_, 'QTYTORETLESSZERO: Quantity to return can not be less than zero!');
   END IF;

   salerec_ := Sales_Part_API.Get(newrec_.contract,newrec_.catalog_no);
   IF (salerec_.catalog_type ='PKG') THEN
      Error_SYS.Record_General(lu_name_, 'PKGPART: Packages can only be returned by returning its components.');
   END IF;

   IF (newrec_.condition_code IS NOT NULL) AND (salerec_.catalog_type = 'NON') then
      Error_SYS.Record_General(lu_name_,'NO_COND_ON_NON: Condition codes are not allowed for Non Inventory Sales Parts.');
   END IF;

   IF rma_rec_.rma_report_printed = 'PRINTED' THEN
      Client_SYS.Add_Warning(lu_name_, 'RMAPRINTED: The RMA has already been printed.');
   END IF ;
   
   con_code_usage_ := Part_Catalog_API.Get_Condition_Code_Usage_Db(salerec_.part_no);
   IF (con_code_usage_ = 'ALLOW_COND_CODE') THEN
      IF newrec_.condition_code IS NULL THEN
         Error_SYS.Record_General(lu_name_,'COND_NOT_ALLOW0: Condition code functionality is enabled in the part catalog record for this part. You must enter a condition code.');
      END IF;
   ELSIF (con_code_usage_ = 'NOT_ALLOW_COND_CODE') THEN
      IF newrec_.condition_code IS NOT NULL THEN
         Error_SYS.Record_General(lu_name_,'COND_NOT_ALLOW: Condition code functionality is not enabled for this part. You cannot enter a condition code.');
      END IF;
   END IF;

   IF (order_no_entered_) THEN
      Check_Ex_Order_Connectable___(newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no, order_no_entered_);
   END IF;

   IF NOT (newrec_.tax_liability = 'TAX' OR newrec_.tax_liability = 'EXEMPT') THEN
      IF (newrec_.order_no IS NOT NULL) THEN
         delivery_country_code_ := Cust_Order_Line_Address_API.Get_Country_Code(newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
      ELSE
         IF (rma_rec_.ship_addr_flag = 'N') THEN
            delivery_country_code_ := Return_Material_API.Get_Ship_Addr_Country(newrec_.rma_no);
         ELSE
            delivery_country_code_ := rma_rec_.ship_addr_country_code;
         END IF;
      END IF;

      Tax_Handling_Order_Util_API.Validate_Tax_Liability(newrec_.tax_liability, delivery_country_code_);
   END IF;

   Client_SYS.Set_Item_Value('FEE_CODE', tax_code_from_attr_, attr_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     return_material_line_tab%ROWTYPE,
   newrec_ IN OUT return_material_line_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   salerec_                    Sales_Part_API.Public_Rec;
   con_code_usage_             VARCHAR2(20);
   order_no_updated_           BOOLEAN := FALSE;
   qty_rec_updated_            BOOLEAN := FALSE;
   exchange_attr_              VARCHAR2(2000);
   invoice_id_                 NUMBER;
   rma_rec_                    Return_Material_API.Public_Rec;
   new_tax_code_               VARCHAR2(20);
   refresh_tax_code_           BOOLEAN := FALSE;
   tax_code_changed_           BOOLEAN := FALSE;  
   order_ref_inv_updated_      BOOLEAN := FALSE;
   update_tax_from_ship_addr_  VARCHAR2(5);
   qty_scp_ret_updated_        BOOLEAN := FALSE;
   delivery_country_code_      VARCHAR2(2);
   qty_edited_flag_            VARCHAR2(20);
   delivery_type_changed_      BOOLEAN := FALSE;   
   site_date_                  DATE;
   $IF Component_Expctr_SYS.INSTALLED $THEN
      connect_head_id_         NUMBER;
   $END
   bypass_uas_                 VARCHAR2(5) := 'FALSE'; 
   ord_line_rec_               Customer_Order_Line_API.Public_Rec;
   com_def_rec_                Company_Def_Invoice_Type_API.Public_Rec;
   inv_head_rec_          Customer_Order_Inv_Head_API.Public_Rec;
   FUNCTION Other_Changes_Made RETURN BOOLEAN
   IS
      changed_rec_              Indicator_Rec;
   BEGIN
      changed_rec_ := Get_Indicator_Rec___(oldrec_, newrec_);
      Trace_SYS.Field ('order ' || newrec_.order_no || ' diffs:', changed_rec_.order_no);
      RETURN
        (oldrec_.debit_invoice_item_id != newrec_.debit_invoice_item_id) OR
        (oldrec_.line_item_no != newrec_.line_item_no) OR changed_rec_.line_no OR
        changed_rec_.order_no OR changed_rec_.purchase_order_no OR changed_rec_.rel_no ;
   END Other_Changes_Made;

   FUNCTION Economically_Used_Changed RETURN BOOLEAN
   IS
      changed_rec_ Indicator_Rec;
   BEGIN
      changed_rec_ := Get_Indicator_Rec___(oldrec_, newrec_);
      Trace_SYS.Field ('order ' || newrec_.order_no || ' diffs:', changed_rec_.order_no);
      RETURN (oldrec_.base_sale_unit_price != newrec_.base_sale_unit_price) OR
             (oldrec_.base_unit_price_incl_tax != newrec_.base_unit_price_incl_tax) OR
             (oldrec_.debit_invoice_item_id != newrec_.debit_invoice_item_id) OR
             (oldrec_.line_item_no != newrec_.line_item_no) OR
             (oldrec_.sale_unit_price != newrec_.sale_unit_price) OR
             (oldrec_.unit_price_incl_tax != newrec_.unit_price_incl_tax) OR
             (oldrec_.tax_liability != newrec_.tax_liability) OR
             changed_rec_.fee_code OR changed_rec_.debit_invoice_no OR changed_rec_.line_no OR
             changed_rec_.order_no OR changed_rec_.purchase_order_no OR changed_rec_.rel_no ;
   END Economically_Used_Changed;

   FUNCTION Essential_Changes_Made RETURN BOOLEAN
   IS
      changed_rec_ Indicator_Rec;
   BEGIN
      changed_rec_ := Get_Indicator_Rec___(oldrec_, newrec_);
      RETURN Economically_Used_Changed OR
             (oldrec_.qty_to_return != newrec_.qty_to_return) OR
              changed_rec_.return_reason_code OR changed_rec_.credit_approver_id OR changed_rec_.inspection_info OR -- NOT NULL already checked 
              oldrec_.configuration_id != newrec_.configuration_id;
   END Essential_Changes_Made;
BEGIN
   -- gelr:modify_date_applied, begin
   site_date_         := Site_API.Get_Site_Date(newrec_.contract);
   IF ((Company_Localization_Info_API.Get_Parameter_Val_From_Site_Db(newrec_.contract, 'MODIFY_DATE_APPLIED') = Fnd_Boolean_API.DB_TRUE) AND
      (NVL(newrec_.arrival_date, site_date_) != NVL(oldrec_.arrival_date, site_date_))) THEN
      IF (newrec_.rowstate NOT IN ('Released', 'Planned')) THEN
         Error_SYS.Record_General(lu_name_, 'NOUPDATEARRIVALDATE: Arrival Date is updatable only in Planned or Released RMA lines.');
      END IF;
   END IF;
   -- gelr:modify_date_applied, end
      
   IF (indrec_.order_no) THEN
      order_no_updated_ := TRUE;
   END IF;
   IF (indrec_.qty_returned_inv OR indrec_.qty_scrapped) THEN
      qty_scp_ret_updated_ := TRUE;
   END IF;

   IF (indrec_.debit_invoice_no OR indrec_.debit_invoice_item_id  OR indrec_.catalog_no OR
       indrec_.order_no OR indrec_.line_no OR indrec_.rel_no OR indrec_.line_item_no OR
       indrec_.fee_code OR indrec_.tax_liability OR indrec_.delivery_type OR indrec_.tax_calc_structure_id) THEN
      refresh_tax_code_ := TRUE;
   END IF;

   IF (indrec_.debit_invoice_no OR indrec_.debit_invoice_item_id OR indrec_.order_no OR
       indrec_.line_no OR indrec_.rel_no OR indrec_.line_item_no) THEN
      order_ref_inv_updated_ := TRUE;
   END IF;

   IF (indrec_.qty_received) THEN
      qty_rec_updated_ := TRUE;
   END IF;

   IF (indrec_.fee_code) THEN
      new_tax_code_     := newrec_.fee_code;
      tax_code_changed_ := TRUE;
   END IF;
   
   IF (indrec_.delivery_type) THEN
      delivery_type_changed_ := TRUE;
   END IF;

   IF (indrec_.credit_approver_id AND newrec_.credit_approver_id IS NOT NULL) THEN
      Order_Coordinator_API.Exist(newrec_.credit_approver_id, FALSE);
   END IF;

   IF (Client_SYS.Item_Exist('UPDATE_TAX_FROM_SHIP_ADDR', attr_)) THEN
      update_tax_from_ship_addr_ := Client_SYS.Get_Item_Value('UPDATE_TAX_FROM_SHIP_ADDR', attr_);
   END IF;

   IF (Client_SYS.Item_Exist('QTY_EDITED_FLAG', attr_)) THEN
      qty_edited_flag_ := Client_SYS.Get_Item_Value('QTY_EDITED_FLAG',   attr_);
   END IF;
   
   ord_line_rec_ := Customer_Order_Line_API.Get(newrec_.order_no,  newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
   newrec_.rental := NVL(ord_line_rec_.rental, Fnd_Boolean_API.DB_FALSE);

   $IF Component_Expctr_SYS.INSTALLED $THEN
       IF oldrec_.qty_to_return_inv_uom != newrec_.qty_to_return_inv_uom OR newrec_.qty_to_return != oldrec_.qty_to_return THEN
         IF (Customer_Order_Flow_API.Get_License_Enabled(newrec_.rma_no, 'INTERACT_RMA') = 'TRUE') THEN
            Exp_License_Connect_Util_API.Check_Allow_Update(newrec_.rma_no, newrec_.rma_line_no, NULL, NULL, 'RMA');
            connect_head_id_ := Exp_License_Connect_Head_API.Get_Connect_Id_From_Ref('RMA', newrec_.rma_no, newrec_.rma_line_no, NULL, NULL);
            IF connect_head_id_ IS NOT NULL AND oldrec_.qty_to_return_inv_uom != newrec_.qty_to_return_inv_uom THEN
               Exp_License_Connect_Head_API.Set_License_Qty(connect_head_id_, newrec_.qty_to_return_inv_uom);
            END IF;
         END IF;
      END IF;
   $END

   rma_rec_ := Return_Material_API.Get(newrec_.rma_no);

   Trace_SYS.Field('Updating RMA line in state', oldrec_.rowstate);
   IF (oldrec_.rowstate = 'Denied') THEN
      IF Essential_Changes_Made THEN
         Error_SYS.Record_General(lu_name_, 'CHGDENIED: Denied RMA line can not be changed.');
      END IF;
   ELSIF (oldrec_.rowstate = 'Cancelled') THEN
      IF Essential_Changes_Made THEN
         Error_SYS.Record_General(lu_name_, 'CHGCANCELED: Cancelled RMA line can not be changed.');
      END IF;
   ELSIF (oldrec_.rowstate != 'Planned') THEN
      IF (rma_rec_.rma_report_printed = 'PRINTED') THEN
         IF (oldrec_.qty_to_return != newrec_.qty_to_return) OR
            (oldrec_.sale_unit_price != newrec_.sale_unit_price) OR
            (oldrec_.base_sale_unit_price != newrec_.base_sale_unit_price) THEN
            Client_SYS.Add_Warning(lu_name_, 'RMAPRINTED: The RMA has already been printed.');
         END IF;
      END IF;

      -- qty_to_return may be changed if returned and not credited
      IF (oldrec_.credit_invoice_no IS NOT NULL) AND
         ((oldrec_.qty_to_return != newrec_.qty_to_return) OR (oldrec_.price_conv_factor != newrec_.price_conv_factor)) THEN
         Error_SYS.Record_General(lu_name_, 'CHGQNOTALLOWED: Credit invoiced line can not be changed.');
      END IF;

      -- essential things may not be changed when postings exists.
      IF (oldrec_.credit_invoice_no IS NOT NULL) AND Str_Diff___(oldrec_.credit_approver_id, newrec_.credit_approver_id) THEN
         Error_SYS.Record_General(lu_name_, 'CHGAPPNOTALLOWED: Credit invoice exist, credit approver may not be changed.');
      END IF;

      IF (oldrec_.credit_invoice_no IS NOT NULL) OR
         (oldrec_.qty_scrapped > 0) OR (oldrec_.qty_returned_inv > 0 ) OR
         ((oldrec_.qty_received > 0) AND (salerec_.catalog_type = 'NON')) THEN
         IF (oldrec_.credit_invoice_no IS NOT NULL) THEN
            IF Economically_Used_Changed THEN
               Error_SYS.Record_General(lu_name_, 'CHGNOTALLOWED: Postings already created. Line can not be changed.');
            END IF;
         ELSIF Other_Changes_Made THEN
            Error_SYS.Record_General(lu_name_, 'CHGNOTALLOWED: Postings already created. Line can not be changed.');
         END IF;
      END IF;
   END IF;

   -- QTY_TO_RETURN is manually edited.
   IF qty_edited_flag_ = 'EDITED' THEN
      newrec_.qty_to_return_inv_uom := newrec_.qty_to_return * newrec_.conv_factor/NVL(newrec_.inverted_conv_factor,1);
   -- When qty fields are not manually edited and in dlgReceivePartsOrderDeliveries/dlgRmaLineReceiveParts or dlgRmaLineScrapParts dialog box is.
   ELSIF qty_edited_flag_ = 'DLG_NOT_EDITED' THEN
      -- Value taken from the database to retain the full precision.
      newrec_.qty_received_inv_uom := Get_Qty_To_Return_Inv_Uom(newrec_.rma_no, newrec_.rma_line_no);
      newrec_.qty_received := Get_Qty_To_Return(newrec_.rma_no, newrec_.rma_line_no);
   END IF;

   IF (rma_rec_.originating_rma_no IS NOT NULL AND qty_edited_flag_ IS NOT NULL) THEN
      Restrict_Multi_Site_Rma___(newrec_, oldrec_);
   END IF;

   IF (order_no_updated_ OR qty_scp_ret_updated_ OR qty_rec_updated_) THEN
      Validate_Conn_Purch_Line___(newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
   END IF;

   IF (newrec_.debit_invoice_no IS NOT NULL) AND (newrec_.debit_invoice_series_id IS NULL) THEN
      Error_SYS.Appl_General(lu_name_,'NO_SERIES_ID_DEB: Invoice series must have a value when the RMA line is connected to a debit invoice');
   END IF;

   IF (newrec_.credit_invoice_no != oldrec_.credit_invoice_no) THEN
      Error_SYS.Record_General(lu_name_, 'CREINVEXIST: Credit/Correction Invoice already exists for RMA line :P1.', newrec_.rma_line_no);
   END IF;

   IF (newrec_.debit_invoice_no IS NOT NULL) AND (newrec_.debit_invoice_series_id IS NULL) THEN
      Error_SYS.Record_General(lu_name_,'NO_SERIES_ID: Invoice series must have a value when the RMA line is connected to a reference invoice');
   END IF;

   IF (newrec_.debit_invoice_no IS NOT NULL AND NVL(newrec_.debit_invoice_no, CHR(2)) != NVL(oldrec_.debit_invoice_no, CHR(2))) THEN
      invoice_id_ := Customer_Order_Inv_Head_API.Get_Invoice_Id_By_No(newrec_.company, newrec_.debit_invoice_no, newrec_.debit_invoice_series_id);
      IF (invoice_id_ IS NULL) THEN
         Error_SYS.Appl_General(lu_name_,'NOPRELINVOICE: The Invoice :P1 does not exist. Preliminary Invoice may have been printed', newrec_.debit_invoice_no);
      ELSE
         com_def_rec_   := Company_Def_Invoice_Type_API.Get(newrec_.company);
         inv_head_rec_  := Customer_Order_Inv_Head_API.Get(newrec_.company, invoice_id_) ;
        
         IF (newrec_.rental = Fnd_Boolean_API.DB_TRUE) THEN
            Error_SYS.Record_General(lu_name_,'NORENTALIVCRMALINES: You cannot connect rental invoices to return material authorization lines.');
         END IF;

         IF (inv_head_rec_.correction_invoice_Id IS NOT NULL) THEN
            Error_SYS.Record_General(lu_name_, 'INVALIDCORINVTYPE: The reference invoice :P1 is not a last correction invoice.', newrec_.debit_invoice_no);
         END IF;

         IF (inv_head_rec_.invoice_type NOT IN ('CUSTORDDEB', 'CUSTCOLDEB', 'SELFBILLDEB', com_def_rec_.def_co_cor_inv_type, com_def_rec_.def_col_cor_inv_type)) THEN
            Error_SYS.Record_General(lu_name_, 'INVALIDCREINVTYPE: The reference invoice :P1 is not a debit/correction invoice.', newrec_.debit_invoice_no);
         END IF;

         IF (Customer_Order_Inv_Item_API.Is_Valid_Co_Line(newrec_.company,
                                                          invoice_id_,
                                                          newrec_.debit_invoice_item_id,
                                                          newrec_.order_no,
                                                          newrec_.line_no,
                                                          newrec_.rel_no,
                                                          newrec_.line_item_no) = 0) THEN
            Error_SYS.Appl_General(lu_name_,'INVMNOTMATCHED: The Debit Invoice does not match with the information on the RMA. Customer, Order, Sales Part or Site');
         END IF;
      END IF;
   END IF;

   IF (newrec_.rental = Fnd_Boolean_API.DB_FALSE) THEN
      IF (newrec_.return_reason_code IS NULL) THEN
         Error_SYS.Appl_General(lu_name_, 'REASONCODEREQD: Return reason is required for non-rental lines.');
      END IF;
   ELSE
      newrec_.rebate_builder := Fnd_Boolean_API.DB_FALSE;
   END IF;
   
   IF (indrec_.configuration_id AND newrec_.configuration_id IS NOT NULL AND oldrec_.configuration_id != newrec_.configuration_id) THEN
      Validate_Configuration_Id___(newrec_);
   END IF;
   
   super(oldrec_, newrec_, indrec_, attr_);
   
   IF (oldrec_.rowstate = 'Denied') THEN
      IF (NVL(oldrec_.customer_tax_usage_type,' ') != NVL(newrec_.customer_tax_usage_type,' ')) THEN
         Error_SYS.Record_General(lu_name_, 'CHGDENIED: Denied RMA line can not be changed.');
      END IF;
   ELSIF (oldrec_.rowstate = 'Cancelled') THEN
      IF (NVL(oldrec_.customer_tax_usage_type,' ') != NVL(newrec_.customer_tax_usage_type,' '))THEN
         Error_SYS.Record_General(lu_name_, 'CHGCANCELED: Cancelled RMA line can not be changed.');
      END IF;
   END IF;
   IF (oldrec_.credit_invoice_no IS NOT NULL) AND (NVL(oldrec_.customer_tax_usage_type,' ') != NVL(newrec_.customer_tax_usage_type,' ')) THEN
      Error_SYS.Record_General(lu_name_, 'CHGQNOTALLOWED: Credit invoiced line can not be changed.');
   END IF;

   Error_SYS.Check_Not_Null(lu_name_, 'RENTAL', newrec_.rental);

   Valid_Customer_Order_Line___(newrec_, oldrec_, FALSE);
   
   bypass_uas_ := NVL(Client_SYS.Get_Item_Value('BYPASS_USER_ALLOWED_SITE',   attr_), 'FALSE');  
   
   -- User allowed site validation should not be triggered when user is trying to modify another site's RMA in inter-site flow.
   IF ((newrec_.receipt_rma_line_no IS NULL AND newrec_.originating_rma_line_no IS NULL) OR (bypass_uas_ != 'TRUE')) THEN           
           User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, newrec_.contract);
   END IF;

   IF ((newrec_.qty_to_return = 0) AND (newrec_.credit_approver_id IS NOT NULL)) THEN
      Error_SYS.Record_General(lu_name_, 'QTYRECNOZERO: Return material authorization line :P1-:P2 has been approved for credit. Therefore, you are not allowed to update the quantity to return to zero.', newrec_.rma_no, newrec_.rma_line_no);
   END IF;

   IF (newrec_.qty_to_return < newrec_.qty_received) OR (newrec_.qty_to_return_inv_uom < newrec_.qty_received_inv_uom) THEN
      Error_SYS.Record_General(lu_name_, 'QTYRECTOLARGE: The Quantity Received can not exceed Quantity to Return.');
   END IF;

   IF  NVL(newrec_.qty_received_inv_uom, 0) < (NVL(newrec_.qty_returned_inv, 0)+ NVL(newrec_.qty_scrapped, 0)) THEN
      Error_SYS.Record_General(lu_name_, 'QTYRECTOSMALL: The Quantity Received can not be less than already Handled Quantity.');
   END IF;

   -- Make sure the specified base sale unit price and sale unit price are valid
   IF newrec_.base_sale_unit_price < 0 THEN
      Error_SYS.Record_General(lu_name_, 'BASE_PRICE_NEGATIVE: Base sale unit price must be greater than zero!');
   END IF;

   IF newrec_.base_unit_price_incl_tax < 0 THEN
      Error_SYS.Record_General(lu_name_, 'BASE_PRICE_INCL_TAX_NEGATIVE: Base Sale Unit Price Including Tax must be greater than zero!');
   END IF;

   IF newrec_.sale_unit_price < 0 THEN
      Error_SYS.Record_General(lu_name_, 'PRICE_LESS_THAN_ZERO: Sale unit price must be greater than zero!');
   END IF;

   IF newrec_.unit_price_incl_tax < 0 THEN
      Error_SYS.Record_General(lu_name_, 'PRICE_INCL_TAX_LESS_THAN_ZERO: Sale Unit Price Including Tax must be greater than zero!');
   END IF;

   IF newrec_.qty_to_return < 0 THEN
      Error_SYS.Record_General(lu_name_, 'QTYTORETLESSZERO: Quantity to return can not be less than zero!');
   END IF;

   -- Make sure qty returned inv has not been decreased
   IF (oldrec_.qty_returned_inv > newrec_.qty_returned_inv) THEN
      Error_SYS.Record_General(lu_name_, 'QTY_RET_INV_DECREASED: The quantity returned to stock may not be decreased!');
   END IF;
   -- Make sure qty scrapped has not been decreased
   IF (oldrec_.qty_scrapped > newrec_.qty_scrapped) THEN
      Error_SYS.Record_General(lu_name_, 'QTY_SCR_DECREASED: The quantity to scrap may not be decreased!');
   END IF;

   salerec_ := Sales_Part_API.Get(newrec_.contract,newrec_.catalog_no);

   IF (salerec_.catalog_type = 'PKG') THEN
      Error_SYS.Record_General(lu_name_, 'PKGPART: Packages can only be returned by returning its components.');
   END IF;

   IF (salerec_.catalog_type = 'NON') THEN
      IF nvl(newrec_.qty_received, 0) < nvl(oldrec_.qty_received, 0) THEN
         Error_SYS.Record_General(lu_name_, 'QTYRECDECR: The Quantity to Receive can not be decreased when receiving non-inventory parts.');
      END IF;
      IF (newrec_.condition_code IS NOT NULL) THEN
         Error_SYS.Record_General(lu_name_,'NO_COND_ON_NON: Condition codes are not allowed for Non Inventory Sales Parts.');
      END IF;
   END IF;

   con_code_usage_ := Part_Catalog_API.Get_Condition_Code_Usage_Db(salerec_.part_no);
   IF (con_code_usage_ = 'ALLOW_COND_CODE') THEN
      IF (NVL(newrec_.condition_code, Database_SYS.string_null_) != NVL(oldrec_.condition_code, Database_SYS.string_null_)) AND (newrec_.rowstate = 'ReturnCompleted') THEN
         Error_SYS.Record_General(lu_name_, 'COND_UPD_NOT_ALL: Condition Code can not be changed if the return material line status is Return Completed.');
      END IF;
      IF newrec_.condition_code IS NULL THEN
         Error_SYS.Record_General(lu_name_, 'COND_NOT_ALLOW0: Condition code functionality is enabled in the part catalog record for this part. You must enter a condition code.');
      END IF;
   ELSIF (con_code_usage_ = 'NOT_ALLOW_COND_CODE') THEN
      IF newrec_.condition_code IS NOT NULL THEN
         Error_SYS.Record_General(lu_name_, 'COND_NOT_ALLOW: Condition code functionality is not enabled for this part. You cannot enter a condition code.');
      END IF;
   END IF;

   IF (order_no_updated_ OR qty_rec_updated_) THEN
      Check_Ex_Order_Connectable___(newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no, order_no_updated_);
   END IF;

   IF qty_rec_updated_ AND (newrec_.order_no IS NOT NULL) AND (ord_line_rec_.exchange_item = 'EXCHANGED ITEM') THEN
      $IF Component_Purch_SYS.INSTALLED $THEN
         Client_Sys.Clear_Attr(exchange_attr_);
         Client_SYS.Add_To_Attr('EXCHANGE_PART_SHIPPED_DB', 'NOT SHIPPED', exchange_attr_);
         DECLARE
            po_order_no_ VARCHAR2(12);
            po_line_no_  VARCHAR2(4);
            po_rel_no_   VARCHAR2(4);
         BEGIN
            Pur_Order_Exchange_Comp_API.Get_Connected_Po_Info(po_order_no_, po_line_no_, po_rel_no_,newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
            Pur_Order_Exchange_Comp_API.Modify(exchange_attr_ , po_order_no_, po_line_no_, po_rel_no_ );
         END;
      $ELSE
         NULL;
      $END
   END IF;
   
   Trace_SYS.Field('Updating RMA line in state', oldrec_.rowstate);
   IF (oldrec_.rowstate = 'Denied') THEN
      IF Essential_Changes_Made THEN
         Error_SYS.Record_General(lu_name_, 'CHGDENIED: Denied RMA line can not be changed.');
      END IF;
   ELSIF (oldrec_.rowstate != 'Planned') THEN
      IF (rma_rec_.rma_report_printed = 'PRINTED') THEN
         IF (oldrec_.qty_to_return != newrec_.qty_to_return) OR
            (oldrec_.sale_unit_price != newrec_.sale_unit_price) OR
            (oldrec_.unit_price_incl_tax != newrec_.unit_price_incl_tax) OR
            (oldrec_.base_sale_unit_price != newrec_.base_sale_unit_price) OR
            (oldrec_.base_unit_price_incl_tax != newrec_.base_unit_price_incl_tax) THEN
            Client_SYS.Add_Warning(lu_name_, 'RMAPRINTED: The RMA has already been printed.');
         END IF;
      END IF;

      -- qty_to_return may be changed if returned and not credited
      IF (oldrec_.credit_invoice_no IS NOT NULL) AND
         ((oldrec_.qty_to_return != newrec_.qty_to_return) OR (oldrec_.price_conv_factor != newrec_.price_conv_factor)) THEN
         Error_SYS.Record_General(lu_name_, 'CHGQNOTALLOWED: Credit invoiced line can not be changed.');
      END IF;

      -- essential things may not be changed when postings exists.
      IF (oldrec_.credit_invoice_no IS NOT NULL) AND Str_Diff___(oldrec_.credit_approver_id, newrec_.credit_approver_id) THEN
         Error_SYS.Record_General(lu_name_, 'CHGAPPNOTALLOWED: Credit invoice exist, credit approver may not be changed.');
      END IF;

      IF (oldrec_.credit_invoice_no IS NOT NULL) OR
         (oldrec_.qty_scrapped > 0) OR (oldrec_.qty_returned_inv > 0 ) OR
         ((oldrec_.qty_received > 0) AND (salerec_.catalog_type = 'NON')) THEN
         IF (oldrec_.credit_invoice_no IS NOT NULL) THEN
            IF Economically_Used_Changed THEN
               Error_SYS.Record_General(lu_name_, 'CHGNOTALLOWED: Postings already created. Line can not be changed.');
            END IF;
         ELSIF Other_Changes_Made THEN
            Error_SYS.Record_General(lu_name_, 'CHGNOTALLOWED: Postings already created. Line can not be changed.');
         END IF;
      END IF;
   END IF;

   IF NOT (newrec_.tax_liability = 'TAX' OR newrec_.tax_liability = 'EXEMPT') THEN
      IF (newrec_.order_no IS NOT NULL) THEN
         delivery_country_code_ := Cust_Order_Line_Address_API.Get_Country_Code(newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
      ELSE
         IF (rma_rec_.ship_addr_flag = 'N') THEN
            delivery_country_code_ := Return_Material_API.Get_Ship_Addr_Country(newrec_.rma_no);
         ELSE
            delivery_country_code_ := rma_rec_.ship_addr_country_code;
         END IF;
      END IF;

      Tax_Handling_Order_Util_API.Validate_Tax_Liability(newrec_.tax_liability, delivery_country_code_);
   END IF;
   
   IF refresh_tax_code_ THEN
      Client_SYS.Add_To_Attr('REFRESH_FEE_CODE', 1, attr_);
   ELSE
      Client_SYS.Add_To_Attr('REFRESH_FEE_CODE', 0, attr_);
   END IF;

   IF (update_tax_from_ship_addr_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('UPDATE_TAX_FROM_SHIP_ADDR', update_tax_from_ship_addr_, attr_);
   END IF;

   IF (newrec_.order_no IS NULL AND  newrec_.rowstate IN ('Released', 'Partially Received', 'Received')) THEN
      Validate_Ship_Via_Del_Term___(newrec_.rma_no, newrec_.order_no);
   END IF;
END Check_Update___;

PROCEDURE Check_Catalog_No_Ref___ (
   newrec_ IN OUT return_material_line_tab%ROWTYPE )
IS
BEGIN
   Sales_Part_API.Exist(newrec_.contract, newrec_.catalog_no, Sales_Type_API.DB_SALES_AND_RENTAL);
END Check_Catalog_No_Ref___;

PROCEDURE Check_Configuration_Id_Ref___ (
   newrec_ IN OUT return_material_line_tab%ROWTYPE )
IS
BEGIN
   IF newrec_.configuration_id != '*' THEN
      Order_Config_Util_API.Configuration_Exist(NVL(newrec_.part_no, newrec_.catalog_no), newrec_.configuration_id);
   END IF;

END Check_Configuration_Id_Ref___;

-- Check_Cancel_Reason_Ref___
--   Perform validation on the CancelReasonRef reference.
PROCEDURE Check_Cancel_Reason_Ref___ (
   newrec_ IN OUT return_material_line_tab%ROWTYPE )
IS
BEGIN
   Order_Cancel_Reason_Api.Exist( newrec_.cancel_reason, Reason_Used_By_Api.DB_RETURN_MATERIAL );
END;

-- Build_Attr_Create_Sup_Rma___ 
-- This method is used to build the attr_ which is used in method Create_Supply_Site_Rma___. 
FUNCTION Build_Attr_Create_Sup_Rma___ (	
   rec_                  IN RETURN_MATERIAL_LINE_TAB%ROWTYPE,
   rma_rec_              IN Return_Material_API.Public_Rec,
   demand_co_line_rec_   IN Customer_Order_Line_API.Public_Rec,
   int_co_line_rec_      IN Customer_Order_Line_API.Public_Rec,
   rma_no_               IN NUMBER ) RETURN VARCHAR2
IS
   new_line_attr_       VARCHAR2(4000);
   qty_to_return_       NUMBER;
   inv_qty_to_return_   NUMBER;
   sales_part_rec_      Sales_Part_API.Public_Rec;
   demand_catch_qty_    NUMBER;   
BEGIN
   Client_SYS.Clear_Attr(new_line_attr_);   

   IF ((rma_rec_.return_to_vendor_no IS NOT NULL) AND (demand_co_line_rec_.vendor_no = rma_rec_.return_to_vendor_no) AND (demand_co_line_rec_.supply_site = rma_rec_.return_to_contract) AND (demand_co_line_rec_.supply_code = 'IPD')) THEN       
      Get_Converted_Qty___(inv_qty_to_return_,
                           qty_to_return_,
                           rec_.qty_to_return_inv_uom,
                           rec_.qty_to_return,
                           rma_rec_.contract,
                           rma_rec_.return_to_contract,
                           rec_.part_no,
                           int_co_line_rec_.part_no,
                           int_co_line_rec_.conv_factor,
                           int_co_line_rec_.inverted_conv_factor ); 
   
      Client_SYS.Add_To_Attr('RMA_NO', rma_no_ , new_line_attr_);
      Client_SYS.Add_To_Attr('CONTRACT', rma_rec_.return_to_contract, new_line_attr_);
      Client_SYS.Add_To_Attr('QTY_TO_RETURN', qty_to_return_, new_line_attr_);
      Client_SYS.Add_To_Attr('QTY_TO_RETURN_INV_UOM', inv_qty_to_return_, new_line_attr_);
      Client_SYS.Add_To_Attr('RETURN_REASON_CODE', rec_.return_reason_code, new_line_attr_);
      Client_SYS.Add_To_Attr('ORIGINATING_RMA_LINE_NO', rec_.rma_line_no, new_line_attr_);
            
      IF (Part_Catalog_API.Get_Catch_Unit_Enabled_Db(rec_.part_no) = 'TRUE') THEN
         demand_catch_qty_ := rec_.qty_to_return * rec_.price_conv_factor;
         Client_SYS.Add_To_Attr('PRICE_CONV_FACTOR', demand_catch_qty_/qty_to_return_, new_line_attr_);
      END IF;
      
   ELSE
      IF (Sales_Part_API.Check_Exist(rma_rec_.return_to_contract, demand_co_line_rec_.catalog_no) = 0) THEN
         Error_Sys.Record_General(lu_name_, 'SUPP_PART_NOT_EXIT: Sales Part :P1 does not exist in supply site :P2 ', demand_co_line_rec_.catalog_no, rma_rec_.return_to_contract);
      ELSE
         sales_part_rec_ := Sales_Part_API.Get(rma_rec_.return_to_contract, demand_co_line_rec_.catalog_no);
      END IF;

      Get_Converted_Qty___(inv_qty_to_return_,
                           qty_to_return_,
                           rec_.qty_to_return_inv_uom,
                           rec_.qty_to_return,
                           rma_rec_.contract,
                           rma_rec_.return_to_contract,
                           rec_.part_no,
                           rec_.part_no,
                           sales_part_rec_.conv_factor,
                           sales_part_rec_.inverted_conv_factor ); 
   
      Client_SYS.Add_To_Attr('RMA_NO', rma_no_ , new_line_attr_);
      Client_SYS.Add_To_Attr('CONTRACT', rma_rec_.return_to_contract, new_line_attr_);
      Client_SYS.Add_To_Attr('CATALOG_NO', rec_.catalog_no , new_line_attr_);
      Client_SYS.Add_To_Attr('CATALOG_DESC', Sales_Part_API.Get_Catalog_Desc(rma_rec_.return_to_contract, rec_.catalog_no) , new_line_attr_);
      Client_SYS.Add_To_Attr('RETURN_REASON_CODE',rec_.return_reason_code , new_line_attr_);
      Client_SYS.Add_To_Attr('QTY_TO_RETURN', qty_to_return_ , new_line_attr_);
      Client_SYS.Add_To_Attr('QTY_TO_RETURN_INV_UOM', inv_qty_to_return_, new_line_attr_);
      Client_SYS.Add_To_Attr('PURCHASE_ORDER_NO', rec_.purchase_order_no, new_line_attr_);
      Client_SYS.Add_To_Attr('ORIGINATING_RMA_LINE_NO', rec_.rma_line_no, new_line_attr_);
      Client_SYS.Add_To_Attr('CONFIGURATION_ID', rec_.configuration_id, new_line_attr_);
      Client_SYS.Add_To_Attr('DELIVERY_TYPE', sales_part_rec_.delivery_type , new_line_attr_);
   END IF;
      
   RETURN new_line_attr_;   
END Build_Attr_Create_Sup_Rma___;

-- Build_Attr_For_New___ 
-- This method is used to build the attr_ which is used in method New. 
PROCEDURE Build_Attr_For_New___(
      new_attr_      OUT  VARCHAR2,
      attr_     IN   OUT  VARCHAR2 )
   IS   
   ptr_                           NUMBER;
   name_                          VARCHAR2(30);
   value_                         VARCHAR2(2000);
   part_attr_                     VARCHAR2(32000);
   rma_no_                        NUMBER;
   rma_rec_                       Return_Material_API.Public_Rec;
   rate_                          NUMBER;
   currency_rate_                 NUMBER;
   sale_unit_price_               NUMBER;
   sale_unit_price_incl_tax_      NUMBER;
   base_sale_unit_price_          NUMBER;
   base_sale_unit_price_incl_tax_ NUMBER;
   discount_                      NUMBER;
   conv_factor_                   NUMBER;
   part_conv_factor_              NUMBER;
   price_conv_factor_             NUMBER;
   catalog_no_                    VARCHAR2(25);
   order_no_                      VARCHAR2(12);
   line_no_                       VARCHAR2(4);
   rel_no_                        VARCHAR2(4);
   currency_type_                 VARCHAR2(10);
   condition_code_                VARCHAR2(10);
   tax_code_                      VARCHAR2(20);
   tax_class_id_                  VARCHAR2(20);
   part_no_                       VARCHAR2(25);
   company_                       VARCHAR2(20);
   return_reason_code_            VARCHAR2(10);
   dummy_                         NUMBER;
   qty_to_return_                 NUMBER;
   line_item_no_                  NUMBER;
   curr_rate_                     NUMBER;
   invoice_no_                    CUSTOMER_ORDER_INV_HEAD.invoice_no%TYPE;
   series_id_                     CUSTOMER_ORDER_INV_HEAD.series_id%TYPE;
   item_id_                       CUSTOMER_ORDER_INV_ITEM.item_id%TYPE;
   part_inverted_conv_factor_     NUMBER;
   source_ref_type_               VARCHAR2(50);
   source_ref1_                   VARCHAR2(50);
   source_ref2_                   VARCHAR2(50);
   source_ref3_                   VARCHAR2(50);
   source_ref4_                   VARCHAR2(50);
   tax_liability_                 VARCHAR2(20);
   order_connected_               VARCHAR2(5);
   BEGIN
      rma_no_             := Client_SYS.Get_Item_Value('RMA_NO',attr_);
      catalog_no_         := Client_SYS.Get_Item_Value('CATALOG_NO',attr_);
      order_no_           := Client_SYS.Get_Item_Value('ORDER_NO', attr_);
      line_no_            := Client_SYS.Get_Item_Value('LINE_NO', attr_);
      rel_no_             := Client_SYS.Get_Item_Value('REL_NO', attr_);
      line_item_no_       := Client_SYS.Get_Item_Value('LINE_ITEM_NO', attr_);
      return_reason_code_ := Client_SYS.Get_Item_Value('RETURN_REASON_CODE', attr_);
      qty_to_return_      := Client_SYS.Get_Item_Value('QTY_TO_RETURN', attr_);
      invoice_no_         := Client_SYS.Get_Item_Value('DEBIT_INVOICE_NO',attr_);
      series_id_          := Client_SYS.Get_Item_Value('DEBIT_INVOICE_SERIES_ID',attr_);
      item_id_            := Client_SYS.Get_Item_Value('DEBIT_INVOICE_ITEM_ID',attr_);
      tax_liability_      := Client_SYS.Get_Item_Value('TAX_LIABILITY', attr_);
      price_conv_factor_  := Client_SYS.Get_Item_Value('PRICE_CONV_FACTOR', attr_);

      Client_SYS.Set_Item_Value('RMA_NO', rma_no_, new_attr_);

      -- Retrieve the default attribute values.
      Prepare_Insert___(new_attr_);
      
      tax_liability_ := NVL(tax_liability_,Client_SYS.Get_Item_Value('TAX_LIABILITY', new_attr_));
   
      --Replace the default attribute values with the ones passed in the inparameterstring.
      ptr_ := NULL;
      WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
         Client_SYS.Set_Item_Value(name_, value_, new_attr_);
      END LOOP;

      rma_rec_ := Return_Material_API.Get(rma_no_);
      company_ := Site_API.Get_Company(rma_rec_.contract);
      Get_Part_Info(part_attr_, rma_rec_.contract, catalog_no_, rma_no_);

      part_no_                   := Client_SYS.Get_Item_Value('PART_NO', part_attr_);
      part_conv_factor_          := Client_SYS.Get_Item_Value('CONV_FACTOR', part_attr_);
      part_inverted_conv_factor_ := Client_SYS.Get_Item_Value('INVERTED_CONV_FACTOR', part_attr_);

      Invoice_Library_API.Get_Currency_Rate_Defaults(currency_type_,
                                                     conv_factor_,
                                                     rate_,
                                                     company_,
                                                     rma_rec_.currency_code,
                                                     rma_rec_.date_requested,
                                                     'CUSTOMER',
                                                     NVL(rma_rec_.customer_no_credit, rma_rec_.customer_no));

      curr_rate_ := Client_SYS.Get_Item_Value('CURRENCY_RATE', attr_);

      IF (curr_rate_ IS NULL) THEN
         currency_rate_ := rate_ / conv_factor_;
      ELSE
         currency_rate_ := curr_rate_;
      END IF;

      Get_Price_Info ( sale_unit_price_,
                       sale_unit_price_incl_tax_,
                       base_sale_unit_price_,
                       base_sale_unit_price_incl_tax_,
                       dummy_,
                       dummy_,
                       dummy_,
                       dummy_,
                       discount_,
                       tax_code_,
                       tax_class_id_,
                       price_conv_factor_,
                       condition_code_,
                       qty_to_return_,
                       rma_rec_.customer_no,
                       rma_rec_.contract,
                       rma_rec_.currency_code,
                       catalog_no_,
                       order_no_,
                       line_no_,
                       rel_no_,
                       line_item_no_,
                       invoice_no_,
                       item_id_,
                       series_id_,
                       rma_rec_.use_price_incl_tax);
   
      IF (invoice_no_ IS NOT NULL AND item_id_ IS NOT NULL) THEN 
         source_ref_type_ := Tax_Source_API.DB_INVOICE;
         source_ref1_     := Customer_Order_Inv_Head_API.Get_Invoice_Id_By_No(company_, invoice_no_, series_id_);
         source_ref2_     := item_id_;
         source_ref3_     := '*';
         source_ref4_     := '*';
      ELSE                        
         source_ref_type_ := Tax_Source_API.DB_CUSTOMER_ORDER_LINE;  
         source_ref1_     := order_no_;
         source_ref2_     := line_no_;
         source_ref3_     := rel_no_;
         source_ref4_     := line_item_no_;
      END IF;

      order_connected_ := NVL(Client_SYS.Get_Item_Value('ORDER_CONNECTED', attr_), 'TRUE');
      IF (order_connected_ = 'TRUE') THEN 
         Tax_Handling_Order_Util_API.Get_Prices(base_sale_unit_price_,
                                                base_sale_unit_price_incl_tax_,
                                                sale_unit_price_,
                                                sale_unit_price_incl_tax_, 
                                                company_, 
                                                source_ref_type_, 
                                                source_ref1_, 
                                                source_ref2_, 
                                                source_ref3_,
                                                source_ref4_,
                                                '*',
                                                ifs_curr_rounding_ => 16);
      END IF;

      Client_SYS.Set_Item_Value('CONV_FACTOR', part_conv_factor_, new_attr_);
      Client_SYS.Add_To_Attr('INVERTED_CONV_FACTOR', part_inverted_conv_factor_, attr_);
      Client_SYS.Set_Item_Value('PART_NO', part_no_, new_attr_);
      Client_SYS.Set_Item_Value('COMPANY', company_, new_attr_);
      Client_SYS.Set_Item_Value('CONTRACT', rma_rec_.contract, new_attr_);
      Client_SYS.Set_Item_Value('CATALOG_NO', catalog_no_, new_attr_);
      Client_SYS.Set_Item_Value('CURRENCY_RATE', currency_rate_, new_attr_);
      Client_SYS.Set_Item_Value('PRICE_CONV_FACTOR', price_conv_factor_, new_attr_);
      Client_SYS.Set_Item_Value('SALE_UNIT_PRICE', sale_unit_price_, new_attr_);
      Client_SYS.Set_Item_Value('UNIT_PRICE_INCL_TAX',      sale_unit_price_incl_tax_,      new_attr_);
      Client_SYS.Set_Item_Value('BASE_SALE_UNIT_PRICE', base_sale_unit_price_, new_attr_);
      Client_SYS.Set_Item_Value('BASE_UNIT_PRICE_INCL_TAX', base_sale_unit_price_incl_tax_, new_attr_);
      Client_SYS.Set_Item_Value('QTY_TO_RETURN', qty_to_return_, new_attr_);
      Client_SYS.Set_Item_Value('CONDITION_CODE', condition_code_, new_attr_);
      Client_SYS.Set_Item_Value('INSPECTION_INFO', Return_Material_Reason_API.Get_Inspection_Info(return_reason_code_), new_attr_);
      Client_SYS.Set_Item_Value('TAX_LIABILITY', tax_liability_ , new_attr_);
      Client_SYS.Add_To_Attr('PRICE_CONV_FACTOR', price_conv_factor_, new_attr_);   
END Build_Attr_For_New___;

-- Add_Transaction_Tax_Info___
--    Fetch and calculate taxes and add tax lines to source_tax_item_tab.
PROCEDURE Add_Transaction_Tax_Info___ (
   newrec_              IN RETURN_MATERIAL_LINE_TAB%ROWTYPE,    
   company_             IN VARCHAR2,   
   customer_no_         IN VARCHAR2,
   ship_addr_no_        IN VARCHAR2,
   supply_country_db_   IN VARCHAR2,     
   use_price_incl_tax_  IN VARCHAR2,
   currency_code_       IN VARCHAR2,
   tax_from_defaults_   IN BOOLEAN,
   add_tax_lines_       IN BOOLEAN,
   attr_                IN VARCHAR2)
IS
   line_amount_rec_           Tax_Handling_Util_API.line_amount_rec;
   source_key_rec_            Tax_Handling_Util_API.source_key_rec;
   tax_line_param_rec_        Tax_Handling_Order_Util_API.tax_line_param_rec;
   tax_liability_type_db_     VARCHAR2(20);
   multiple_tax_              VARCHAR2(20);
   free_of_charge_tax_basis_  NUMBER;
   tax_info_table_            Tax_Handling_Util_API.tax_information_table;
BEGIN
   source_key_rec_     := Tax_Handling_Util_API.Create_Source_Key_Rec(Tax_Source_API.DB_RETURN_MATERIAL_LINE,
                                                                      newrec_.rma_no, 
                                                                      newrec_.rma_line_no, 
                                                                      '*', 
                                                                      '*',
                                                                      '*',
                                                                      attr_); 

   tax_liability_type_db_ := Tax_Liability_API.Get_Tax_Liability_Type_Db(newrec_.tax_liability,
                                                                         Get_Delivery_Country_Code(newrec_.rma_no, newrec_.rma_line_no));

   free_of_charge_tax_basis_ := Calc_Foc_Tax_Basis___(newrec_.rma_no, newrec_.rma_line_no);
   
   tax_line_param_rec_ := Tax_Handling_Order_Util_API.Create_Tax_Line_Param_Rec (company_,
                                                                                 newrec_.contract,
                                                                                 customer_no_,
                                                                                 ship_addr_no_,
                                                                                 NVL(newrec_.date_returned, TRUNC(Site_API.Get_Site_Date(newrec_.contract))),
                                                                                 supply_country_db_,
                                                                                 NVL(newrec_.delivery_type, '*'),
                                                                                 newrec_.catalog_no,
                                                                                 use_price_incl_tax_,
                                                                                 currency_code_,
                                                                                 newrec_.currency_rate ,                                                                                       
                                                                                 NULL,
                                                                                 tax_from_defaults_,
                                                                                 newrec_.fee_code,
                                                                                 newrec_.tax_calc_structure_id,
                                                                                 newrec_.tax_class_id,
                                                                                 newrec_.tax_liability,
                                                                                 tax_liability_type_db_,
                                                                                 Get_Delivery_Country_Code(newrec_.rma_no, newrec_.rma_line_no),
                                                                                 add_tax_lines_,
                                                                                 net_curr_amount_   => NULL,
                                                                                 gross_curr_amount_ => NULL,
                                                                                 ifs_curr_rounding_ => NULL,
                                                                                 free_of_charge_tax_basis_ => free_of_charge_tax_basis_,
                                                                                 attr_              => attr_);

   Tax_Handling_Order_Util_API.Add_Transaction_Tax_Info (line_amount_rec_,
                                                         multiple_tax_,
                                                         tax_info_table_,
                                                         tax_line_param_rec_,
                                                         source_key_rec_,
                                                         attr_);
END Add_Transaction_Tax_Info___;

                                  
PROCEDURE Recalculate_Tax_Lines___ (
   newrec_             IN return_material_line_tab%ROWTYPE,
   company_            IN VARCHAR2,
   customer_no_        IN VARCHAR2,
   ship_addr_no_       IN VARCHAR2,
   supply_country_db_  IN VARCHAR2,     
   use_price_incl_tax_  IN VARCHAR2,
   currency_code_      IN VARCHAR2,
   from_defaults_      IN BOOLEAN,
   attr_               IN VARCHAR2)
IS
   source_key_rec_            Tax_Handling_Util_API.source_key_rec;
   tax_line_param_rec_        Tax_Handling_Order_Util_API.tax_line_param_rec;
   free_of_charge_tax_basis_  NUMBER;
BEGIN
   source_key_rec_     := Tax_Handling_Util_API.Create_Source_Key_Rec(Tax_Source_API.DB_RETURN_MATERIAL_LINE,
                                                                      newrec_.rma_no, 
                                                                      newrec_.rma_line_no, 
                                                                      '*', 
                                                                      '*',
                                                                      '*',
                                                                      attr_); 
 
   free_of_charge_tax_basis_ := Calc_Foc_Tax_Basis___(newrec_.rma_no, newrec_.rma_line_no);
   
   tax_line_param_rec_ := Tax_Handling_Order_Util_API.Create_Tax_Line_Param_Rec (company_,
                                                                                 newrec_.contract,
                                                                                 customer_no_,
                                                                                 ship_addr_no_,
                                                                                 NVL(newrec_.date_returned, TRUNC(Site_API.Get_Site_Date(newrec_.contract))),
                                                                                 supply_country_db_,
                                                                                 newrec_.delivery_type,
                                                                                 newrec_.part_no,
                                                                                 use_price_incl_tax_,
                                                                                 currency_code_,
                                                                                 newrec_.currency_rate,                                                                                       
                                                                                 NULL,
                                                                                 from_defaults_,
                                                                                 newrec_.fee_code,
                                                                                 newrec_.tax_calc_structure_id,
                                                                                 newrec_.tax_class_id,
                                                                                 newrec_.tax_liability,
                                                                                 Get_Tax_Liability_Type_Db(newrec_.rma_no, newrec_.rma_line_no),
                                                                                 Get_Delivery_Country_Code(newrec_.rma_no, newrec_.rma_line_no),
                                                                                 add_tax_lines_     => TRUE,
                                                                                 net_curr_amount_   => NULL,
                                                                                 gross_curr_amount_ => NULL,
                                                                                 ifs_curr_rounding_ => NULL,
                                                                                 free_of_charge_tax_basis_ => free_of_charge_tax_basis_,
                                                                                 attr_              => attr_);

   Tax_Handling_Order_Util_API.Recalculate_Tax_Lines (source_key_rec_,
                                                      tax_line_param_rec_,
                                                      attr_);
END Recalculate_Tax_Lines___;

PROCEDURE Transfer_Tax_Lines___(
   newrec_         IN RETURN_MATERIAL_LINE_TAB%ROWTYPE,
   oldrec_         IN RETURN_MATERIAL_LINE_TAB%ROWTYPE,
   insert_flag_    IN BOOLEAN,
   reset_tax_code_ IN BOOLEAN)
IS
   order_is_changed_           BOOLEAN;
   invoice_is_changed_         BOOLEAN;
   invoice_exists_             BOOLEAN;
   order_exists_               BOOLEAN;
   invoice_id_                 NUMBER;
   rma_rec_                    Return_Material_API.Public_Rec;
   old_tax_liability_type_db_  VARCHAR2(20);
   new_tax_liability_type_db_  VARCHAR2(20);
   delivery_country_code_      RETURN_MATERIAL_LINE.delivery_country_code%TYPE;
   saved_tax_code_msg_        VARCHAR2(32000);
   saved_tax_code_            VARCHAR2(20);
   saved_tax_calc_struct_id_  VARCHAR2(20);
   saved_tax_percentage_      NUMBER;
   saved_tax_base_curr_amount_ NUMBER;
BEGIN
   order_exists_   := newrec_.order_no IS NOT NULL;
   invoice_exists_ := newrec_.debit_invoice_no IS NOT NULL;
   
   IF invoice_exists_ THEN
      -- Retrive the invoice id corresponding to debit invoice no
      invoice_id_ := Customer_Order_Inv_Head_API.Get_Invoice_Id_By_No(newrec_.company, newrec_.debit_invoice_no, newrec_.debit_invoice_series_id);
   END IF;
   
   order_is_changed_ := (Str_Diff___(oldrec_.order_no, newrec_.order_no) OR
                         Str_Diff___(oldrec_.line_no, newrec_.line_no) OR
                         Str_Diff___(oldrec_.rel_no, newrec_.rel_no) OR
                         nvl(oldrec_.line_item_no, 0) != nvl(newrec_.line_item_no, 0));

   invoice_is_changed_ := (Str_Diff___(oldrec_.debit_invoice_no, newrec_.debit_invoice_no) OR
                           Str_Diff___(oldrec_.debit_invoice_item_id, newrec_.debit_invoice_item_id));

   IF (order_is_changed_ OR invoice_is_changed_ OR (insert_flag_ AND reset_tax_code_)) THEN
      IF (invoice_exists_) THEN
         Tax_Handling_Order_Util_API.Transfer_Tax_lines(newrec_.company,
                                                        Tax_Source_API.DB_INVOICE,
                                                        invoice_id_,
                                                        newrec_.debit_invoice_item_id,
                                                        '*',
                                                        '*',
                                                        '*',
                                                        Tax_Source_API.DB_RETURN_MATERIAL_LINE,
                                                        newrec_.rma_no,
                                                        newrec_.rma_line_no,
                                                        '*',
                                                        '*',
                                                        '*',
                                                        'TRUE',
                                                        'FALSE');
      ELSIF (order_exists_) THEN
         Tax_Handling_Order_Util_API.Transfer_Tax_lines(newrec_.company,
                                                        Tax_Source_API.DB_CUSTOMER_ORDER_LINE,
                                                        newrec_.order_no,
                                                        newrec_.line_no,
                                                        newrec_.rel_no,
                                                        newrec_.line_item_no,
                                                        '*',
                                                        Tax_Source_API.DB_RETURN_MATERIAL_LINE,
                                                        newrec_.rma_no,
                                                        newrec_.rma_line_no,
                                                        '*',
                                                        '*',
                                                        '*',
                                                        'TRUE',
                                                        'TRUE');
      END IF;
      
      Source_Tax_Item_API.Get_Tax_Codes(saved_tax_code_msg_, 
                                     saved_tax_code_, 
                                     saved_tax_calc_struct_id_, 
                                     saved_tax_percentage_, 
                                     saved_tax_base_curr_amount_, 
                                     newrec_.company, 
                                     Tax_Source_API.DB_RETURN_MATERIAL_LINE,
                                     newrec_.rma_no,
                                     newrec_.rma_line_no,
                                     '*',
                                     '*',
                                     '*',
									 'FALSE');
                                     
      IF (saved_tax_code_msg_ IS NULL) AND (saved_tax_code_ IS NULL) AND (saved_tax_calc_struct_id_ IS NULL) THEN
         Tax_Handling_Util_API.Validate_Tax_Code_Mandatory(newrec_.company, 'CUSTOMER_TAX');   
      END IF;
   ELSIF (newrec_.tax_liability != oldrec_.tax_liability) THEN
      rma_rec_ := Return_Material_API.Get(newrec_.rma_no);
      delivery_country_code_ := Get_Delivery_Country_Code(newrec_.rma_no, newrec_.rma_line_no);
      old_tax_liability_type_db_ := Tax_Liability_API.Get_Tax_Liability_Type_Db(oldrec_.tax_liability, delivery_country_code_);
      new_tax_liability_type_db_ := Tax_Liability_API.Get_Tax_Liability_Type_Db(newrec_.tax_liability, delivery_country_code_);
      
      IF(old_tax_liability_type_db_ != new_tax_liability_type_db_) THEN
            Add_Transaction_Tax_Info___ (newrec_,  
                                         newrec_.company,                                      
                                         rma_rec_.return_from_customer_no,
                                         rma_rec_.ship_addr_no,                                      
                                         rma_rec_.supply_country,                                        
                                         rma_rec_.use_price_incl_tax,
                                         rma_rec_.currency_code,                                       
                                         tax_from_defaults_ => reset_tax_code_,                                      
                                         add_tax_lines_     => TRUE,
                                         attr_              => NULL);
      END IF;
   END IF;   
END Transfer_Tax_Lines___;

-- Update_Line___
--   Method that simply updates the LU table.
PROCEDURE Update_Line___ (
   objid_  IN VARCHAR2,
   newrec_ IN RETURN_MATERIAL_LINE_TAB%ROWTYPE )
IS
BEGIN
   UPDATE return_material_line_tab
   SET rma_no                   = newrec_.rma_no,                                      
       rma_line_no              = newrec_.rma_line_no,                                      
       sale_unit_price          = newrec_.sale_unit_price,                                      
       base_sale_unit_price     = newrec_.base_sale_unit_price,                                      
       price_conv_factor        = newrec_.price_conv_factor,                                      
       currency_rate            = newrec_.currency_rate,                                      
       purchase_order_no        = newrec_.purchase_order_no,                            
       note_text                = newrec_.note_text,                           
       note_id                  = newrec_.note_id,                                      
       qty_to_return            = newrec_.qty_to_return,                                      
       qty_returned_inv         = newrec_.qty_returned_inv,                           
       qty_scrapped             = newrec_.qty_scrapped,                            
       date_returned            = newrec_.date_returned,                         
       inspection_info          = newrec_.inspection_info,                    
       credit_invoice_no        = newrec_.credit_invoice_no,
       credit_invoice_item_id   = newrec_.credit_invoice_item_id,                
       debit_invoice_no         = newrec_.debit_invoice_no,                   
       debit_invoice_item_id    = newrec_.debit_invoice_item_id,                  
       catalog_no               = newrec_.catalog_no, 
       order_no                 = newrec_.order_no,
       line_no                  = newrec_.line_no,                         
       rel_no                   = newrec_.rel_no,            
       line_item_no             = newrec_.line_item_no,                   
       credit_approver_id       = newrec_.credit_approver_id,                          
       return_reason_code       = newrec_.return_reason_code,                        
       replacement_order_no     = newrec_.replacement_order_no,                       
       contract                 = newrec_.contract,                            
       qty_received             = newrec_.qty_received,                      
       conv_factor              = newrec_.conv_factor,                                
       replacement_line_no      = newrec_.replacement_line_no,                         
       replacement_rel_no       = newrec_.replacement_rel_no,                          
       replacement_line_item_no = newrec_.replacement_line_item_no,                           
       fee_code                 = newrec_.fee_code,                          
       company                  = newrec_.company,                               
       part_no                  = newrec_.part_no,                          
       configuration_id         = newrec_.configuration_id,                 
       condition_code           = newrec_.condition_code,                           
       catalog_desc             = newrec_.catalog_desc,                         
       debit_invoice_series_id  = newrec_.debit_invoice_series_id,                        
       qty_to_return_inv_uom    = newrec_.qty_to_return_inv_uom,                           
       qty_received_inv_uom     = newrec_.qty_received_inv_uom,                           
       tax_liability            = newrec_.tax_liability,                              
       rebate_builder           = newrec_.rebate_builder,                               
       tax_class_id             = newrec_.tax_class_id,                           
       delivery_type            = newrec_.delivery_type,  
       inverted_conv_factor     = newrec_.inverted_conv_factor,                                      
       unit_price_incl_tax      = newrec_.unit_price_incl_tax,                                      
       base_unit_price_incl_tax = newrec_.base_unit_price_incl_tax,                                      
       rental                   = newrec_.rental,                             
       cancel_reason            = newrec_.cancel_reason,                    
       po_order_no              = newrec_.po_order_no,                         
       po_line_no               = newrec_.po_line_no,                           
       po_rel_no                = newrec_.po_rel_no,                          
       receipt_rma_line_no      = newrec_.receipt_rma_line_no,                         
       originating_rma_line_no  = newrec_.originating_rma_line_no,                         
       supplier_return_reason   = newrec_.supplier_return_reason,                            
       rental_end_date          = newrec_.rental_end_date,
       rowversion               = newrec_.rowversion
   WHERE rowid = objid_;
    
END Update_Line___;

FUNCTION Calc_Foc_Tax_Basis___ (
   rma_no_       IN NUMBER,
   rma_line_no_  IN NUMBER) RETURN NUMBER
IS
   rma_line_rec_             Return_Material_Line_API.Public_Rec;
   co_line_rec_              Customer_Order_Line_API.Public_Rec;
   deb_inv_item_rec_         Customer_Order_Inv_Item_API.Public_Rec;
   free_of_charge_tax_basis_ NUMBER;
BEGIN
   rma_line_rec_ := Get(rma_no_, rma_line_no_);
   co_line_rec_  := Customer_Order_Line_API.Get(rma_line_rec_.order_no, rma_line_rec_.line_no, rma_line_rec_.rel_no, rma_line_rec_.line_item_no);
   IF (rma_line_rec_.debit_invoice_no IS NOT NULL) THEN 
      deb_inv_item_rec_ := Customer_Order_Inv_Item_API.Get(rma_line_rec_.company, 
                                                           Customer_Order_Inv_Head_API.Get_Invoice_Id_By_No(rma_line_rec_.company, rma_line_rec_.debit_invoice_no, rma_line_rec_.debit_invoice_series_id),
                                                           rma_line_rec_.debit_invoice_item_id);
      free_of_charge_tax_basis_ := (deb_inv_item_rec_.free_of_charge_tax_basis / deb_inv_item_rec_.invoiced_qty) * rma_line_rec_.qty_to_return;
   ELSE   
      free_of_charge_tax_basis_ := (co_line_rec_.free_of_charge_tax_basis / co_line_rec_.buy_qty_due) * rma_line_rec_.qty_to_return;
   END IF;   
   RETURN free_of_charge_tax_basis_;
END Calc_Foc_Tax_Basis___;

PROCEDURE Packed_Return_And_Scrap___ (
   rma_no_           IN NUMBER,
   rma_line_no_      IN NUMBER,
   reject_code_      IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   message_          IN CLOB,
   date_received_    IN DATE )
IS
   count_                  NUMBER;
   name_arr_               Message_SYS.name_table;
   value_arr_              Message_SYS.line_table;

   lot_batch_no_           VARCHAR2(20);
   serial_no_              VARCHAR2(50);
   eng_chg_level_          VARCHAR2(6);
   qty_scrapped_           NUMBER;
   catch_qty_scrapped_     NUMBER;
   waiv_dev_rej_no_        VARCHAR2(20);
   handling_unit_id_       NUMBER;
   expiration_date_        DATE;

   mod_attr_               VARCHAR2(200);
   oldrec_                 RETURN_MATERIAL_LINE_TAB%ROWTYPE;
   newrec_                 RETURN_MATERIAL_LINE_TAB%ROWTYPE;
   indrec_                 Indicator_Rec;
   objid_                  VARCHAR2(2000);
   objversion_             VARCHAR2(2000);
   transit_eng_chg_level_  VARCHAR2(6);
   -- gelr:modify_date_applied, begin
   date_applied_           DATE;
   -- gelr:modify_date_applied, end
   -- gelr:warehouse_journal, begin
   del_note_no_            VARCHAR2(50);
   del_note_date_          DATE;
   deliv_reason_id_        VARCHAR2(20);
   -- gelr:warehouse_journal, end
BEGIN
   Message_SYS.Get_Attributes(message_, count_, name_arr_, value_arr_);

   FOR n_ IN 1..count_ LOOP
      IF (name_arr_(n_) = 'LOT_BATCH_NO') THEN
         lot_batch_no_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'SERIAL_NO') THEN
         serial_no_ := value_arr_(n_);
         IF serial_no_ IS NULL THEN
            Error_SYS.Record_General(lu_name_, 'NOSERIAL: Serial No must have a value');
         END IF;
      ELSIF (name_arr_(n_) = 'ENG_CHG_LEVEL') THEN
         eng_chg_level_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'TRANSIT_ENG_CHG_LEVEL') THEN
         transit_eng_chg_level_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'QTY_SCRAPPED') THEN
         qty_scrapped_ := Client_SYS.Attr_Value_To_Number(value_arr_(n_));
      ELSIF (name_arr_(n_) = 'CATCH_QTY_SCRAPPED') THEN
         catch_qty_scrapped_ := Client_SYS.Attr_Value_To_Number(value_arr_(n_));
      ELSIF (name_arr_(n_) = 'EXPIRATION_DATE') THEN
         expiration_date_ := Client_SYS.Attr_Value_To_Date(value_arr_(n_));
      ELSIF (name_arr_(n_) = 'HANDLING_UNIT_ID') THEN
         handling_unit_id_ := Client_SYS.Attr_Value_To_Number(value_arr_(n_));         
      -- gelr:modify_date_applied, begin
      ELSIF (name_arr_(n_) = 'DATE_APPLIED') THEN          
         date_applied_ :=  Client_SYS.Attr_Value_To_Date(value_arr_(n_));
      -- gelr:modify_date_applied, end   
      -- gelr:warehouse_journal, begin
      ELSIF (name_arr_(n_) = 'EXTERNAL_DELNOTE_REF') THEN
         del_note_no_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'EXTERNAL_DELNOTE_DATE') THEN
         del_note_date_ := Client_SYS.Attr_Value_To_Date(value_arr_(n_));
      ELSIF (name_arr_(n_) = 'DELIV_REASON_ID') THEN
         deliv_reason_id_ := value_arr_(n_);      
      -- gelr:warehouse_journal, end
      ELSIF (name_arr_(n_) = 'WAIV_DEV_REJ_NO') THEN
         waiv_dev_rej_no_ := value_arr_(n_);
         
         -- Qty Received should be updated using the qty scrapped
         oldrec_ := Lock_By_Keys___(rma_no_, rma_line_no_);
         IF (oldrec_.rowstate = 'Cancelled') THEN
            Error_SYS.Record_General(lu_name_, 'CHGCANCELED: Cancelled RMA line can not be changed.');
         END IF;
         -- gelr:modify_date_applied, begin
         IF (Company_Localization_Info_API.Get_Parameter_Val_From_Site_Db(oldrec_.contract,'MODIFY_DATE_APPLIED') = Fnd_Boolean_API.DB_TRUE) THEN
            IF (date_applied_ IS NULL) THEN
               Error_SYS.Record_General(lu_name_, 'NODATEAPPLIED: Return Date Applied must have a value');
            END IF; 
         END IF;            
         -- gelr:modify_date_applied, end   
         Client_SYS.Clear_Attr(mod_attr_);
         Client_SYS.Add_To_Attr('QTY_RECEIVED', NVL(oldrec_.qty_received, 0) + qty_scrapped_/oldrec_.conv_factor * oldrec_.inverted_conv_factor, mod_attr_);
         Client_SYS.Add_To_Attr('QTY_RECEIVED_INV_UOM', NVL(oldrec_.qty_received_inv_uom, 0) + qty_scrapped_, mod_attr_);
         Trace_SYS.Field('mod_attr_', mod_attr_);
         newrec_ := oldrec_;
         Unpack___(newrec_, indrec_, mod_attr_);
         Check_Update___(oldrec_, newrec_, indrec_, mod_attr_);
         Update___(objid_, oldrec_, newrec_, mod_attr_, objversion_, TRUE);
         Return_And_Scrap__(rma_no_                => rma_no_,
                            rma_line_no_           => rma_line_no_,
                            qty_scrapped_          => qty_scrapped_,
                            catch_qty_scrapped_    => catch_qty_scrapped_,
                            reject_code_           => reject_code_,
                            part_no_               => part_no_,
                            configuration_id_      => configuration_id_,
                            serial_no_             => serial_no_,
                            lot_batch_no_          => lot_batch_no_,
                            eng_chg_level_         => eng_chg_level_,
                            waiv_dev_rej_no_       => waiv_dev_rej_no_,
                            handling_unit_id_      => handling_unit_id_,
                            expiration_date_       => expiration_date_,
                            date_received_         => date_received_,
                            transit_eng_chg_level_ => transit_eng_chg_level_,
                            condition_code_        => newrec_.condition_code,
                            scrap_all_             => NULL,
                            date_applied_          => date_applied_,
                            del_note_no_           => del_note_no_,
                            del_note_date_         => del_note_date_,
                            deliv_reason_id_       => deliv_reason_id_);
      ELSE
         Error_SYS.Record_General(lu_name_, 'INCORRECT_MESSAGE: Item :P1 can not be used in this method.', name_arr_(n_));
      END IF;
   END LOOP;
END Packed_Return_And_Scrap___;

PROCEDURE Packed_Inventory_Return___ (
   rma_no_           IN NUMBER,
   rma_line_no_      IN NUMBER,
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   location_no_      IN VARCHAR2,
   message_          IN CLOB,
   source_           IN VARCHAR2,
   date_received_    IN DATE )
IS
   count_                 NUMBER;
   name_arr_              Message_SYS.name_table;
   value_arr_             Message_SYS.line_table;

   lot_batch_no_          VARCHAR2(20);
   serial_no_             VARCHAR2(50);
   eng_chg_level_         VARCHAR2(6);
   qty_returned_          NUMBER;
   catch_qty_returned_    NUMBER;
   waiv_dev_rej_no_       VARCHAR2(20);
   handling_unit_id_      NUMBER;
   expiration_date_       DATE;

   mod_attr_              VARCHAR2(200);
   oldrec_                RETURN_MATERIAL_LINE_TAB%ROWTYPE;
   newrec_                RETURN_MATERIAL_LINE_TAB%ROWTYPE;
   indrec_                Indicator_Rec;
   objid_                 VARCHAR2(2000);
   objversion_            VARCHAR2(2000);
   transit_eng_chg_level_ VARCHAR2(6);
   internal_transaction_  BOOLEAN;
   acq_contract_          VARCHAR2(5);
   -- gelr:modify_date_applied, begin
   date_applied_          DATE;
   -- gelr:modify_date_applied, end
   -- gelr:warehouse_journal, begin
   del_note_no_           VARCHAR2(50);
   del_note_date_         DATE;
   deliv_reason_id_       VARCHAR2(50);
   -- gelr:warehouse_journal, end
BEGIN
   Inventory_Event_Manager_API.Start_Session;
   Message_SYS.Get_Attributes(message_, count_, name_arr_, value_arr_);

   acq_contract_         := Cust_Ord_Customer_API.Get_Acquisition_Site(Return_Material_API.Get_Customer_No(rma_no_));
   internal_transaction_ := Site_API.Get_Company(contract_) = Site_API.Get_Company(acq_contract_);
   FOR n_ IN 1..count_ LOOP
      IF (name_arr_(n_) = 'LOT_BATCH_NO') THEN
         lot_batch_no_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'SERIAL_NO') THEN
         serial_no_ := value_arr_(n_);
         IF serial_no_ IS NULL THEN
            Error_SYS.Record_General(lu_name_, 'NOSERIAL: Serial No must have a value');
         END IF;
      ELSIF (name_arr_(n_) = 'ENG_CHG_LEVEL') THEN
         eng_chg_level_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'TRANSIT_ENG_CHG_LEVEL') THEN
         transit_eng_chg_level_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'QTY_RETURNED') THEN
         qty_returned_ := Client_SYS.Attr_Value_To_Number(value_arr_(n_));
      ELSIF (name_arr_(n_) = 'CATCH_QTY_RETURNED') THEN
         catch_qty_returned_ := Client_SYS.Attr_Value_To_Number(value_arr_(n_));
      ELSIF (name_arr_(n_) = 'EXPIRATION_DATE') THEN
         expiration_date_ := Client_SYS.Attr_Value_To_Date(value_arr_(n_));
      ELSIF (name_arr_(n_) = 'HANDLING_UNIT_ID') THEN
         handling_unit_id_ := Client_SYS.Attr_Value_To_Number(value_arr_(n_));
      -- gelr:modify_date_applied, begin
      ELSIF (name_arr_(n_) = 'DATE_APPLIED') THEN 
         IF (Company_Localization_Info_API.Get_Parameter_Val_From_Site_Db(contract_, 'MODIFY_DATE_APPLIED') = Fnd_Boolean_API.DB_TRUE) THEN
            date_applied_ :=  Client_SYS.Attr_Value_To_Date(value_arr_(n_));
            IF (date_applied_ IS NULL) THEN
               Error_SYS.Record_General(lu_name_, 'NODATEAPPLIED: Return Date Applied must have a value');
            END IF; 
         END IF;
      -- gelr:modify_date_applied, end    
      -- gelr:warehouse_journal, begin
      ELSIF (name_arr_(n_) = 'EXTERNAL_DELNOTE_REF') THEN
         del_note_no_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'EXTERNAL_DELNOTE_DATE') THEN
         del_note_date_ := Client_SYS.Attr_Value_To_Date(value_arr_(n_));
      ELSIF (name_arr_(n_) = 'DELIV_REASON_ID') THEN
         deliv_reason_id_ := value_arr_(n_);
      -- gelr:warehouse_journal, end
      ELSIF (name_arr_(n_) = 'WAIV_DEV_REJ_NO') THEN
         waiv_dev_rej_no_ := value_arr_(n_);

         IF (transit_eng_chg_level_ IS NOT NULL AND internal_transaction_) THEN
            Inventory_Part_Revision_API.Get_Matched_Eng_Chg_Level(eng_chg_level_,
                                                                  acq_contract_,
                                                                  contract_,
                                                                  part_no_,
                                                                  transit_eng_chg_level_,
                                                                  FALSE);
         END IF;

         -- Qty Received should be updated using the qty returned
         oldrec_ := Lock_By_Keys___(rma_no_, rma_line_no_);
         IF (oldrec_.rowstate = 'Cancelled') THEN
            Error_SYS.Record_General(lu_name_, 'CHGCANCELED: Cancelled RMA line can not be changed.');
         END IF;
         Client_SYS.Clear_Attr(mod_attr_);
         Client_SYS.Add_To_Attr('QTY_RECEIVED', NVL(oldrec_.qty_received, 0) + qty_returned_/oldrec_.conv_factor * oldrec_.inverted_conv_factor, mod_attr_);
         Client_SYS.Add_To_Attr('QTY_RECEIVED_INV_UOM', NVL(oldrec_.qty_received_inv_uom, 0) + qty_returned_, mod_attr_);
         Trace_SYS.Field('mod_attr_', mod_attr_);
         newrec_ := oldrec_;

         Unpack___(newrec_, indrec_, mod_attr_);
         Check_Update___(oldrec_, newrec_, indrec_, mod_attr_);
         Update___(objid_, oldrec_, newrec_, mod_attr_, objversion_, TRUE);

         Inventory_Return__(rma_no_                => rma_no_,
                            rma_line_no_           => rma_line_no_,
                            contract_              => contract_,
                            part_no_               => part_no_,
                            configuration_id_      => configuration_id_,
                            location_no_           => location_no_,
                            lot_batch_no_          => lot_batch_no_,
                            serial_no_             => serial_no_,
                            eng_chg_level_         => eng_chg_level_,
                            waiv_dev_rej_no_       => waiv_dev_rej_no_,
                            handling_unit_id_      => handling_unit_id_,
                            qty_returned_          => qty_returned_,
                            catch_qty_returned_    => catch_qty_returned_,
                            source_                => source_,
                            date_received_         => date_received_,
                            expiration_date_       => expiration_date_,
                            transit_eng_chg_level_ => transit_eng_chg_level_,
                            condition_code_        => newrec_.condition_code,
                            part_ownership_db_     => Part_Ownership_API.DB_COMPANY_OWNED,
                            owning_vendor_no_      => NULL,
                            return_all_            => NULL,
                            date_applied_          => date_applied_,
                            del_note_no_           => del_note_no_,
                            del_note_date_         => del_note_date_,
                            deliv_reason_id_       => deliv_reason_id_);
      ELSE
         Error_SYS.Record_General(lu_name_, 'INCORRECT_MESSAGE: Item :P1 can not be used in this method.', name_arr_(n_));
      END IF;
   END LOOP;
   Inventory_Event_Manager_API.Finish_Session;
END Packed_Inventory_Return___;

PROCEDURE Unpack_Cust_Receipt___ (
   message_       IN OUT CLOB ,
   receipt_type_  IN     VARCHAR2 )
IS
   receipt_no_         NUMBER;
   count_              NUMBER;
   index_              NUMBER;
   name_arr_           Message_SYS.name_table;
   value_arr_          Message_SYS.line_table;
   transfer_rec_       cust_receipt_rec;
   cust_receipt_tab_   cust_receipt_table;
   pack_complete_      BOOLEAN := FALSE;
BEGIN
   Message_SYS.Get_Attributes(message_, count_, name_arr_, value_arr_);
   FOR n_ IN 1..count_ LOOP
      IF (name_arr_(n_) = 'PACK_START') THEN
         cust_receipt_tab_.DELETE;
      ELSIF (name_arr_(n_) = 'RECEIPT_NO') THEN
         receipt_no_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'RMA_NO') THEN
         index_ := cust_receipt_tab_.COUNT;
         index_ := index_+ 1;
         transfer_rec_.row_no := index_;
         transfer_rec_.rma_no := Client_SYS.Attr_Value_To_Number(value_arr_(n_));
      ELSIF (name_arr_(n_) = 'RMA_LINE_NO') THEN
         transfer_rec_.rma_line_no := Client_SYS.Attr_Value_To_Number(value_arr_(n_));
      ELSIF (name_arr_(n_) = 'REJECT_REASON') THEN
         transfer_rec_.reject_reason := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'PART_NO') THEN
         transfer_rec_.part_no := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'CONTRACT') THEN
         transfer_rec_.contract := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'CONFIGURATION_ID') THEN
         transfer_rec_.configuration_id := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'EXPIRATION_DATE') THEN
         transfer_rec_.expiration_date := Client_SYS.Attr_Value_To_Date(value_arr_(n_));
      ELSIF (name_arr_(n_) = 'LOCATION_NO') THEN
         transfer_rec_.location_no := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'LOT_BATCH_NO') THEN
         transfer_rec_.lot_batch_no := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'SERIAL_NO') THEN
         transfer_rec_.serial_no := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'ENG_CHG_LEVEL') THEN
         transfer_rec_.eng_chg_level := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'WAIV_DEV_REJ_NO') THEN
         transfer_rec_.waiv_dev_rej_no := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'HANDLING_UNIT_ID') THEN
         transfer_rec_.handling_unit_id := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'CONDITION_CODE') THEN
         transfer_rec_.condition_code := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'PART_OWNERSHIP') THEN
         transfer_rec_.part_ownership := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'OWNING_VENDOR_NO') THEN
         transfer_rec_.owning_vendor_no := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'QTY_RECEIPT') THEN
         transfer_rec_.qty_receipt := Client_SYS.Attr_Value_To_Number(value_arr_(n_));
      ELSIF (name_arr_(n_) = 'QTY_RECEIPT_INV') THEN
         transfer_rec_.qty_receipt_inv := Client_SYS.Attr_Value_To_Number(value_arr_(n_));
      ELSIF (name_arr_(n_) = 'CATCH_QTY_RECEIPT') THEN
         transfer_rec_.catch_qty_receipt := Client_SYS.Attr_Value_To_Number(value_arr_(n_));
      -- gelr:modify_date_applied, begin
      ELSIF (name_arr_(n_) = 'DATE_APPLIED') THEN
         transfer_rec_.date_applied := Client_SYS.Attr_Value_To_Date(value_arr_(n_));
      -- gelr:modify_date_applied, end
      -- gelr:warehouse_journal, begin
      ELSIF (name_arr_(n_) = 'EXTERNAL_DELNOTE_REF') THEN
         transfer_rec_.del_note_no := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'EXTERNAL_DELNOTE_DATE') THEN
         transfer_rec_.del_note_date := Client_SYS.Attr_Value_To_Date(value_arr_(n_));
      ELSIF (name_arr_(n_) = 'DELIV_REASON_ID') THEN
         transfer_rec_.deliv_reason_id := value_arr_(n_);            
      -- gelr:warehouse_journal, end      
      ELSIF (name_arr_(n_) = 'RECEIPT_ALL') THEN
         transfer_rec_.receipt_all := value_arr_(n_);
         -- Assign values to PL-SQL table.
         cust_receipt_tab_(index_).row_no             := transfer_rec_.row_no;
         cust_receipt_tab_(index_).rma_no             := transfer_rec_.rma_no;
         cust_receipt_tab_(index_).rma_line_no        := transfer_rec_.rma_line_no;
         cust_receipt_tab_(index_).part_no            := transfer_rec_.part_no;
         cust_receipt_tab_(index_).contract           := transfer_rec_.contract;
         cust_receipt_tab_(index_).configuration_id   := transfer_rec_.configuration_id;
         cust_receipt_tab_(index_).expiration_date    := transfer_rec_.expiration_date;
         cust_receipt_tab_(index_).location_no        := transfer_rec_.location_no;
         cust_receipt_tab_(index_).lot_batch_no       := transfer_rec_.lot_batch_no;
         cust_receipt_tab_(index_).serial_no          := transfer_rec_.serial_no;
         cust_receipt_tab_(index_).eng_chg_level      := transfer_rec_.eng_chg_level;
         cust_receipt_tab_(index_).waiv_dev_rej_no    := transfer_rec_.waiv_dev_rej_no;
         cust_receipt_tab_(index_).handling_unit_id   := transfer_rec_.handling_unit_id;
         cust_receipt_tab_(index_).qty_receipt        := transfer_rec_.qty_receipt;
         cust_receipt_tab_(index_).qty_receipt_inv    := transfer_rec_.qty_receipt_inv;
         cust_receipt_tab_(index_).catch_qty_receipt  := transfer_rec_.catch_qty_receipt;
         cust_receipt_tab_(index_).reject_reason      := transfer_rec_.reject_reason;
         cust_receipt_tab_(index_).condition_code     := transfer_rec_.condition_code;
         cust_receipt_tab_(index_).receipt_all        := transfer_rec_.receipt_all;
         -- gelr:modify_date_applied, begin
         cust_receipt_tab_(index_).date_applied       := transfer_rec_.date_applied;
         -- gelr:modify_date_applied, end
         -- gelr:warehouse_journal, begin
         cust_receipt_tab_(index_).del_note_no        := transfer_rec_.del_note_no;
         cust_receipt_tab_(index_).del_note_date      := transfer_rec_.del_note_date;
         cust_receipt_tab_(index_).deliv_reason_id    := transfer_rec_.deliv_reason_id;
         -- gelr:warehouse_journal, end
         IF (transfer_rec_.part_ownership = Part_Ownership_API.DB_CONSIGNMENT) THEN
            cust_receipt_tab_(index_).part_ownership     := Part_Ownership_API.DB_COMPANY_OWNED;
            cust_receipt_tab_(index_).owning_vendor_no   := NULL;
         ELSE
            cust_receipt_tab_(index_).part_ownership     := transfer_rec_.part_ownership;
            cust_receipt_tab_(index_).owning_vendor_no   := transfer_rec_.owning_vendor_no;
         END IF;
      ELSIF (name_arr_(n_) = 'PACK_COMPLETE') THEN
         pack_complete_ := value_arr_(n_) = 'TRUE';
      ELSE
         Error_SYS.Record_General(lu_name_, 'INCORRECT_MESSAGE: Item :P1 can not be used in this method.', name_arr_(n_));
      END IF;
   END LOOP;
   
   IF (cust_receipt_tab_.COUNT > 0) THEN
      Inventory_Event_Manager_API.Start_Session;
      FOR i IN cust_receipt_tab_.FIRST..cust_receipt_tab_.LAST LOOP
         -- It should be created one receipt for the same rma_no, rma_line_no records.
         -- Otherwise different receipts will create.
         Create_Cust_Receipt( receipt_no_,
                              receipt_type_,
                              cust_receipt_tab_(i).rma_no,
                              cust_receipt_tab_(i).rma_line_no,
                              cust_receipt_tab_(i).part_no,
                              cust_receipt_tab_(i).contract,
                              cust_receipt_tab_(i).configuration_id,
                              cust_receipt_tab_(i).expiration_date,
                              cust_receipt_tab_(i).location_no,
                              cust_receipt_tab_(i).lot_batch_no,
                              cust_receipt_tab_(i).serial_no,
                              cust_receipt_tab_(i).eng_chg_level,
                              cust_receipt_tab_(i).waiv_dev_rej_no,
                              cust_receipt_tab_(i).handling_unit_id,
                              cust_receipt_tab_(i).part_ownership,
                              cust_receipt_tab_(i).owning_vendor_no,
                              cust_receipt_tab_(i).qty_receipt,
                              cust_receipt_tab_(i).qty_receipt_inv,
                              cust_receipt_tab_(i).catch_qty_receipt,
                              cust_receipt_tab_(i).reject_reason,
                              cust_receipt_tab_(i).condition_code,
                              cust_receipt_tab_(i).receipt_all,
                              date_applied_ => cust_receipt_tab_(i).date_applied,
                              del_note_no_     => cust_receipt_tab_(i).del_note_no ,
                              del_note_date_   => cust_receipt_tab_(i).del_note_date ,
                              deliv_reason_id_ => cust_receipt_tab_(i).deliv_reason_id);
      END LOOP;
      Inventory_Event_Manager_API.Finish_Session;
   END IF;
   
   cust_receipt_tab_.DELETE;
   
   message_ := Message_SYS.Construct('');
   Message_SYS.Add_Attribute(message_, 'RECEIPT_NO', receipt_no_);
EXCEPTION
   WHEN OTHERS THEN
      cust_receipt_tab_.DELETE;
      RAISE;
END Unpack_Cust_Receipt___;
   
-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Return_And_Scrap__ (
   rma_no_                IN NUMBER,
   rma_line_no_           IN NUMBER,
   qty_scrapped_          IN NUMBER,
   catch_qty_scrapped_    IN NUMBER,
   reject_code_           IN VARCHAR2,
   part_no_               IN VARCHAR2,
   configuration_id_      IN VARCHAR2,
   serial_no_             IN VARCHAR2,
   lot_batch_no_          IN VARCHAR2,
   eng_chg_level_         IN VARCHAR2,
   waiv_dev_rej_no_       IN VARCHAR2,
   handling_unit_id_      IN NUMBER,
   expiration_date_       IN DATE,
   date_received_         IN DATE,
   transit_eng_chg_level_ IN VARCHAR2,
   condition_code_        IN VARCHAR2,
   scrap_all_             IN VARCHAR2,
   date_applied_          IN DATE DEFAULT SYSDATE,
   del_note_no_           IN VARCHAR2 DEFAULT NULL,
   del_note_date_         IN DATE     DEFAULT NULL,
   deliv_reason_id_       IN VARCHAR2 DEFAULT NULL)
IS
   oldrec_                  RETURN_MATERIAL_LINE_TAB%ROWTYPE;
   newrec_                  RETURN_MATERIAL_LINE_TAB%ROWTYPE;
   indrec_                  Indicator_Rec;
   ordrow_rec_              Customer_Order_Line_API.Public_Rec;
   attr_                    VARCHAR2(200);
   transaction_id_          NUMBER := 0;
   accounting_id_           NUMBER := 0;
   trans_value_             NUMBER := 0;
   cost_detail_tab_         Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   objid_                   VARCHAR2(2000);
   objversion_              VARCHAR2(2000);
   contract_                RETURN_MATERIAL_TAB.contract%TYPE;
   message_                 RETURN_MATERIAL_HISTORY_TAB.message_text%TYPE;
   transaction_code_        VARCHAR2(200);
   customer_contract_       VARCHAR2(5);
   sites_with_same_company_ BOOLEAN := FALSE;
   eng_chg_in_transit_      VARCHAR2(6);
   location_group_          VARCHAR2(20) := NULL;
   part_ownership_          VARCHAR2(20) := 'COMPANY OWNED';
   lot_exists_              BOOLEAN;
   temp_condition_code_     RETURN_MATERIAL_LINE_TAB.condition_code%TYPE;
   activity_seq_            CUSTOMER_ORDER_LINE_TAB.activity_seq%TYPE := 0;
   project_id_              CUSTOMER_ORDER_LINE_TAB.project_id%TYPE := NULL;
   rma_line_rec_            Return_Material_Line_API.Public_Rec;
   transaction_id_tab_      Inventory_Transaction_Hist_API.Transaction_Id_Tab;   
   originating_rma_no_      NUMBER;
   org_rma_line_no_         NUMBER;
   org_rma_line_rec_        Return_Material_Line_API.Public_Rec;
   org_message_             VARCHAR2(2000);
   org_scrapped_qty_        NUMBER;
   org_objversion_          VARCHAR2(2000);
   org_sales_qty_scrapped_  NUMBER;
   demand_site_trans_code_  VARCHAR2(10);
   org_rma_rec_             Return_Material_API.Public_Rec;
   rma_rec_                 Return_Material_API.Public_Rec;
   old_rma_rec_             Return_Material_API.Public_Rec;
   delivered_co_line_rec_   Customer_Order_Line_API.Public_Rec;
   -- gelr:modify_date_applied, begin
   info_      VARCHAR2(2000);
   -- gelr:modify_date_applied, end
   return_to_company_       VARCHAR2(20);
BEGIN
   IF (part_no_ IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'INVALIDSCRAP: Only inventory parts may be scrapped!');
   END IF;

   Trace_SYS.Field('*** Scrap', 'Entered');

   -- Make the update
   oldrec_ := Lock_By_Keys___(rma_no_, rma_line_no_);
   newrec_ := oldrec_;

   Trace_SYS.Field('*** Scrap', 'Locked');
   old_rma_rec_ := Return_Material_API.Get(oldrec_.rma_no);
   customer_contract_ := Cust_Ord_Customer_API.Get_Acquisition_Site(old_rma_rec_.customer_no);
   IF (Site_API.Get_Company(oldrec_.contract) = Site_API.Get_Company(customer_contract_)) THEN
      sites_with_same_company_ := TRUE;
   END IF;

   Client_SYS.Clear_Attr(attr_);
   rma_rec_      := Return_Material_API.Get(rma_no_);
   rma_line_rec_ := Return_Material_Line_API.Get(rma_no_, rma_line_no_);
   -- Modified else condition to allow scrap remaining quantity when 'Scrap Total Qty' Check box is checked in Scrap parts dialog box.
   IF scrap_all_ = 'TRUE' THEN
      -- Check whether there is a scrap and inventory amount exist.
      IF (rma_line_rec_.qty_returned_inv IS NULL) AND (rma_line_rec_.qty_scrapped IS NULL) THEN
         IF (rma_line_rec_.qty_received_inv_uom <> rma_line_rec_.qty_to_return_inv_uom) AND (qty_scrapped_ = rma_line_rec_.qty_to_return_inv_uom)  THEN
            Error_SYS.Record_General(lu_name_, 'WRONGRETURNALL: The total quantity received should be equal to the quantity to return.');
         ELSIF (rma_line_rec_.qty_received_inv_uom <> rma_line_rec_.qty_to_return_inv_uom) AND (qty_scrapped_ <> rma_line_rec_.qty_to_return_inv_uom )THEN
            Error_SYS.Record_General(lu_name_, 'ALREADYSCRAPPED: It is not possible to use the scrap total quantity check box when the quantity to scrap for the line does not equal the approved quantity to return.');
         ELSIF (rma_line_rec_.qty_received_inv_uom = rma_line_rec_.qty_to_return_inv_uom) AND (qty_scrapped_ <> rma_line_rec_.qty_to_return_inv_uom )THEN
            Error_SYS.Record_General(lu_name_, 'ALREADYSCRAPPED: It is not possible to use the scrap total quantity check box when the quantity to scrap for the line does not equal the approved quantity to return.');
         ELSE
            Client_SYS.Add_To_Attr('QTY_SCRAPPED', rma_line_rec_.qty_to_return_inv_uom, attr_);
         END IF;
      ELSE
         Client_SYS.Add_To_Attr('QTY_SCRAPPED', NVL(oldrec_.qty_scrapped, 0) + qty_scrapped_, attr_);
      END IF;
   ELSE
      Client_SYS.Add_To_Attr('QTY_SCRAPPED', NVL(oldrec_.qty_scrapped, 0) + qty_scrapped_, attr_);
   END IF;
   Client_SYS.Add_To_Attr('DATE_RETURNED', date_received_, attr_);

   temp_condition_code_ := NVL(condition_code_, newrec_.condition_code);
   IF (temp_condition_code_ IS NOT NULL) THEN
      IF temp_condition_code_ != Condition_Code_Manager_API.Get_Condition_Code(part_no_,serial_no_,lot_batch_no_) THEN
         IF (serial_no_ = '*') THEN
            IF lot_batch_no_ != '*' THEN
               lot_exists_ := (Lot_Batch_Master_API.Check_Exist(part_no_, lot_batch_no_)='TRUE');
               IF (lot_exists_) THEN
                  Error_SYS.Record_General(lu_name_, 'LOTBAT_COND_CODE: Condition Code in Return Material Line should be equal to the condition code defined for the Lot Batch No in Lot Batch Master');
               END IF;
            END IF;
         ELSE
           Condition_Code_Manager_API.Modify_Condition_Code(part_no_,serial_no_,lot_batch_no_,temp_condition_code_);
         END IF;
      END IF;
   END IF;

   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Trace_SYS.Field('*** Scrap', 'update checked');
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
   Trace_SYS.Field('*** Scrap', 'updated');

   -- Check if this return is connected to an order line for which a Service Management
   -- object was created on delivery.
   IF (newrec_.order_no IS NOT NULL) THEN
      ordrow_rec_ := Customer_Order_Line_API.Get(newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
      IF (ordrow_rec_.create_sm_object_option = 'CREATESMOBJECT') THEN
         -- Service management object was created on delivery of this line
         -- Remove the object in Maintenance before the scrap is made
         Remove_Sm_Object___(newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no, serial_no_);
      END IF;
   END IF;

   -- get the contract from parent
   contract_           := old_rma_rec_.contract;
   originating_rma_no_ := rma_rec_.originating_rma_no;

   IF (originating_rma_no_ IS NULL) THEN
      IF oldrec_.order_no IS NULL THEN
         transaction_code_ := 'OERET-SPNO';
      ELSIF ordrow_rec_.charged_item = 'ITEM NOT CHARGED' THEN
         transaction_code_ := 'OERET-SPNC';
      ELSIF sites_with_same_company_ THEN
         -- its an internal delivery when the sites have the same company
         transaction_code_ := 'OERET-SINT';
         location_group_   := 'INT ORDER TRANSIT';
      ELSIF ordrow_rec_.charged_item = 'ITEM NOT CHARGED' THEN
         transaction_code_ := 'OERET-SPNC';
      ELSIF ordrow_rec_.exchange_item = 'EXCHANGED ITEM' THEN
         transaction_code_ := 'OERET-SPEX';
      ELSE
         transaction_code_ := 'OERET-SCP';
      END IF;
   ELSE
      -- return to different site than RMA site
      org_rma_rec_      := Return_Material_API.Get(originating_rma_no_);
      org_rma_line_no_  := Get_Originating_Rma_Line_No(rma_no_, rma_line_no_);
      org_rma_line_rec_ := Return_Material_Line_API.Get(originating_rma_no_, org_rma_line_no_);
      return_to_company_ := Site_API.Get_Company(org_rma_rec_.return_to_contract);
      IF (org_rma_rec_.return_to_vendor_no IS NOT NULL) THEN
         delivered_co_line_rec_ := Customer_Order_Line_API.Get(org_rma_line_rec_.order_no, org_rma_line_rec_.line_no, org_rma_line_rec_.rel_no, org_rma_line_rec_.line_item_no);
      END IF;

      IF (Site_API.Get_Company(org_rma_rec_.contract) != return_to_company_) THEN
         IF ((org_rma_rec_.return_to_contract = NVL(delivered_co_line_rec_.supply_site, ' ')) AND (org_rma_rec_.return_to_vendor_no = NVL(delivered_co_line_rec_.vendor_no, ' '))) THEN
            transaction_code_       := 'OERET-SCP';
            demand_site_trans_code_ := 'RETPODIRSH';
         END IF;
      ELSE
         IF ((org_rma_rec_.return_to_contract = NVL(delivered_co_line_rec_.supply_site, ' ')) AND (org_rma_rec_.return_to_vendor_no = NVL(delivered_co_line_rec_.vendor_no, ' '))) THEN
            transaction_code_       := 'RETDIR-SCP';
            demand_site_trans_code_ := 'RETINTPODS';
         ELSE
            transaction_code_       := 'RETDIFSSCP';
            demand_site_trans_code_ := 'RETINTPODS';
         END IF;
      END IF;
   END IF;

   Trace_SYS.Field('TRANSACTION_ID_        ', transaction_id_);
   Trace_SYS.Field('ACCOUNTING_ID_         ', accounting_id_);
   Trace_SYS.Field('VALUE_                 ', trans_value_);
   Trace_SYS.Field('TRANSACTION_CODE_      ', transaction_code_);
   Trace_SYS.Field('CONTRACT_              ', contract_);
   Trace_SYS.Field('PART_NO_               ', part_no_);
   Trace_SYS.Field('CONFIGURATION_ID_      ', configuration_id_);
   Trace_SYS.Field('LOT_BATCH_NO_          ', lot_batch_no_);
   Trace_SYS.Field('SERIAL_NO_             ', serial_no_);
   Trace_SYS.Field('WAIV_DEV_REJ_NO_       ', waiv_dev_rej_no_);
   Trace_SYS.Field('HANDLING_UNIT_ID_      ', handling_unit_id_);
   Trace_SYS.Field('ENG_CHG_LEVEL_         ', eng_chg_level_);
   Trace_SYS.Field('ORDER_NO_              ', rma_no_);
   Trace_SYS.Field('LINE_ITEM_NO_          ', rma_line_no_);
   Trace_SYS.Field('REJECT_CODE_           ', reject_code_);
   Trace_SYS.Field('QUANTITY_              ', qty_scrapped_);
   Trace_SYS.Field('QTY_REVERSED_          ', 0);
   Trace_SYS.Field('QTY_ONHAND_            ', qty_scrapped_);
   Trace_SYS.Field('SOURCE_                ', '');

   Return_Or_Scrap_Serial___ (rma_no_,
                              rma_line_no_,
                              part_no_,
                              serial_no_,
                              configuration_id_,
                              qty_scrapped_,
                              newrec_,
                              org_rma_rec_,
                              rma_rec_,
                              ordrow_rec_,
                              'SCRAP');

   IF transaction_code_ = 'OERET-SCP' THEN
      IF ordrow_rec_.supply_code = 'PI' THEN
         activity_seq_ := NVL(ordrow_rec_.activity_seq,0);
         project_id_   := ordrow_rec_.project_id;
      END IF;
   END IF;

   -- inv transaction related to RETDIR-SCP and RETDIFSSCP are created after creating RETINTPODS transation is in demand site in same company as the transaction cost need to taken.
   -- which is handled in Create_Dir_Ret_Transaction___. For IPD return in different company OERET-SCP transaction also created after creating RETPODIRSH transaction as to
   -- support correct current possition for serial parts.
   IF NOT(transaction_code_ IN ('RETDIR-SCP', 'RETDIFSSCP') OR (transaction_code_ = 'OERET-SCP' AND delivered_co_line_rec_.supply_code = 'IPD' AND delivered_co_line_rec_.supply_code IS NOT NULL)) THEN
      -- Create inventory transaction
      Inventory_Transaction_Hist_API.New(transaction_id_     => transaction_id_,
                                         accounting_id_      => accounting_id_,
                                         value_              => trans_value_,
                                         transaction_code_   => transaction_code_,
                                         contract_           => contract_,
                                         part_no_            => part_no_,
                                         configuration_id_   => configuration_id_,
                                         location_no_        => NULL,
                                         lot_batch_no_       => lot_batch_no_,
                                         serial_no_          => serial_no_,
                                         waiv_dev_rej_no_    => waiv_dev_rej_no_,
                                         eng_chg_level_      => eng_chg_level_,
                                         activity_seq_       => activity_seq_,
                                         handling_unit_id_   => handling_unit_id_,
                                         project_id_         => project_id_,
                                         source_ref1_        => to_char(rma_no_),
                                         source_ref2_        => NULL,
                                         source_ref3_        => NULL,
                                         source_ref4_        => rma_line_no_,
                                         source_ref5_        => NULL,
                                         reject_code_        => reject_code_,
                                         cost_detail_tab_    => cost_detail_tab_,
                                         unit_cost_          => NULL,
                                         quantity_           => qty_scrapped_,
                                         qty_reversed_       => 0,
                                         catch_quantity_     => catch_qty_scrapped_,
                                         source_             => NULL,
                                         source_ref_type_    => Order_Type_API.Decode('RMA'),
                                         owning_vendor_no_   => NULL,
                                         condition_code_     => newrec_.condition_code,
                                         location_group_     => location_group_,
                                         part_ownership_db_  => part_ownership_,
                                         owning_customer_no_ => NULL,
                                         expiration_date_    => expiration_date_,
                                         delivery_reason_id_ => deliv_reason_id_, 
                                         del_note_no_        => del_note_no_,
                                         del_note_date_      => del_note_date_);

      IF (transaction_id_ IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'TRANSCTNNOTEXIST: Inventory transaction could not be created.');
      END IF; 

      -- Make the booking
      Inventory_Transaction_Hist_API.Do_Transaction_Booking(transaction_id_, oldrec_.company, 'N', NULL);

      message_ := Language_SYS.Translate_Constant(lu_name_, 'RMALINESCRAP: Line :P1, scrapped :P2 item(s).',
                                                  p1_ => oldrec_.rma_line_no, p2_ => qty_scrapped_ );
      -- gelr:modify_date_applied, begin
      IF (Company_Localization_Info_API.Get_Parameter_Val_From_Site_Db(contract_,'MODIFY_DATE_APPLIED') = Fnd_Boolean_API.DB_TRUE) THEN
         Inventory_Transaction_Hist_API.Modify_Date_Applied(info_, transaction_id_, date_applied_);
      END IF; 
      -- gelr:modify_date_applied, end
      Return_Material_History_API.New(oldrec_.rma_no, message_);
   END IF;

   IF (transaction_code_ = 'OERET-SINT') AND (customer_contract_ IS NOT NULL) THEN
      IF (transit_eng_chg_level_ IS NOT NULL) THEN
         eng_chg_in_transit_ := transit_eng_chg_level_;
      ELSE
         eng_chg_in_transit_ := eng_chg_level_;
      END IF;

      Inventory_Part_In_Transit_API.Remove_From_Order_Transit(delivering_contract_     => customer_contract_,  
                                                              contract_                => oldrec_.contract,
                                                              part_no_                 => part_no_,            
                                                              configuration_id_        => configuration_id_,
                                                              lot_batch_no_            => lot_batch_no_,       
                                                              serial_no_               => serial_no_,
                                                              eng_chg_level_           => eng_chg_in_transit_, 
                                                              waiv_dev_rej_no_         => waiv_dev_rej_no_,
                                                              handling_unit_id_        => handling_unit_id_,
                                                              expiration_date_         => expiration_date_, 
                                                              delivering_warehouse_id_ => '*',
                                                              receiving_warehouse_id_  => '*',
                                                              activity_seq_            => 0 ,
                                                              part_ownership_db_       => Part_Ownership_API.DB_COMPANY_OWNED,
                                                              owning_customer_no_      => '*',
                                                              owning_vendor_no_        => '*',
                                                              deliv_no_                => 0,
                                                              shipment_id_             => 0,
                                                              shipment_line_no_        => 0,
                                                              qty_to_remove_           => qty_scrapped_,
                                                              catch_qty_to_remove_     => catch_qty_scrapped_);
   END IF;
   IF (transaction_code_ = 'OERET-SPNC') THEN
      transaction_id_tab_(1) := transaction_id_;
      Set_Demand_Order_As_Alt_Ref___(transaction_id_tab_,
                                     newrec_.order_no,
                                     newrec_.line_no,
                                     newrec_.rel_no,
                                     newrec_.line_item_no,
                                     'PUR ORDER');
   END IF;

   IF (originating_rma_no_ IS NOT NULL) THEN
      Client_SYS.Clear_Attr(attr_);
      oldrec_ := Lock_By_Keys___(originating_rma_no_, org_rma_line_no_);
      newrec_ := oldrec_;

      Get_Converted_Qty___(org_scrapped_qty_,
                           org_sales_qty_scrapped_,
                           qty_scrapped_,
                           NULL,
                           contract_,
                           org_rma_line_rec_.contract,
                           part_no_,
                           org_rma_line_rec_.part_no,
                           org_rma_line_rec_.conv_factor,
                           org_rma_line_rec_.inverted_conv_factor);

      Client_SYS.Add_To_Attr('QTY_SCRAPPED', NVL(oldrec_.qty_scrapped, 0) + org_scrapped_qty_, attr_);
      Client_SYS.Add_To_Attr('DATE_RETURNED', date_received_, attr_);
      -- Added the attribute to the modify_attr_ to indicate that user allowed site validation should be bypassed when updating the originating RMA.
      Client_SYS.Add_To_Attr('BYPASS_USER_ALLOWED_SITE', 'TRUE', attr_);

      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
      Update___(objid_, oldrec_, newrec_, attr_, org_objversion_, TRUE);

      IF (transaction_code_ IN ('RETDIR-SCP', 'RETDIFSSCP')) THEN
         Message_SYS.Add_Attribute( org_message_, 'REJECT_CODE', reject_code_);
      END IF;
      Message_SYS.Add_Attribute(org_message_, 'LOT_BATCH_NO',        lot_batch_no_);
      Message_SYS.Add_Attribute(org_message_, 'SERIAL_NO',           serial_no_);
      Message_SYS.Add_Attribute(org_message_, 'ENG_CHG_LEVEL',       eng_chg_level_);
      Message_SYS.Add_Attribute(org_message_, 'WAIV_DEV_REJ_NO',     waiv_dev_rej_no_);
      Message_SYS.Add_Attribute(org_message_, 'ACTIVITY_SEQ',        activity_seq_);
      Message_SYS.Add_Attribute(org_message_, 'HANDLING_UNIT_ID',    handling_unit_id_);
      Message_SYS.Add_Attribute(org_message_, 'EXPIRATION_DATE',     expiration_date_);
      Message_SYS.Add_Attribute(org_message_, 'CATCH_QTY_RETURNED',  catch_qty_scrapped_);
      Message_SYS.Add_Attribute(org_message_, 'INV_QTY_RETURNED',    org_scrapped_qty_);

      -- scrap considered as return for credit in demand site PO and creates RETPODIRSH or RETINTPODS transaction in inventory.
      Register_Direct_Return(originating_rma_no_, org_rma_line_no_, NULL, NULL, demand_site_trans_code_, org_message_);

      -- The OERET-SCP transaction in supply site is created after creating RETPODIRSH transaction in demand site.
      -- This is to support correct current possition for serial parts.
      IF (transaction_code_ = 'OERET-SCP' AND delivered_co_line_rec_.supply_code = 'IPD') THEN
         -- Create inventory transaction
         Inventory_Transaction_Hist_API.New(transaction_id_     => transaction_id_,
                                            accounting_id_      => accounting_id_,
                                            value_              => trans_value_,
                                            transaction_code_   => transaction_code_,
                                            contract_           => contract_,
                                            part_no_            => part_no_,
                                            configuration_id_   => configuration_id_,
                                            location_no_        => NULL,
                                            lot_batch_no_       => lot_batch_no_,
                                            serial_no_          => serial_no_,
                                            waiv_dev_rej_no_    => waiv_dev_rej_no_,
                                            eng_chg_level_      => eng_chg_level_,
                                            activity_seq_       => activity_seq_,
                                            handling_unit_id_   => handling_unit_id_,
                                            project_id_         => project_id_,
                                            source_ref1_        => to_char(rma_no_),
                                            source_ref2_        => NULL,
                                            source_ref3_        => NULL,
                                            source_ref4_        => rma_line_no_,
                                            source_ref5_        => NULL,
                                            reject_code_        => reject_code_,
                                            cost_detail_tab_    => cost_detail_tab_,
                                            unit_cost_          => NULL,
                                            quantity_           => qty_scrapped_,
                                            qty_reversed_       => 0,
                                            catch_quantity_     => catch_qty_scrapped_,
                                            source_             => NULL,
                                            source_ref_type_    => Order_Type_API.Decode('RMA'),
                                            owning_vendor_no_   => NULL,
                                            condition_code_     => newrec_.condition_code,
                                            location_group_     => location_group_,
                                            part_ownership_db_  => part_ownership_,
                                            owning_customer_no_ => NULL,
                                            expiration_date_    => expiration_date_);

         IF (transaction_id_ IS NULL) THEN
            Error_SYS.Record_General(lu_name_, 'TRANSCTNNOTEXIST: Inventory transaction could not be created.');
         END IF;

         -- Make the booking
         Inventory_Transaction_Hist_API.Do_Transaction_Booking(transaction_id_, return_to_company_, 'N', NULL);

         message_ := Language_SYS.Translate_Constant(lu_name_, 'RMALINESCRAP: Line :P1, scrapped :P2 item(s).',
                                                     p1_ => oldrec_.rma_line_no, p2_ => qty_scrapped_ );
         Return_Material_History_API.New(oldrec_.rma_no, message_);
      END IF;
   END IF;
END Return_And_Scrap__;


-- Inventory_Return__
--   Update the qty_returned_inv attribute and call the Receive_Part method
--   in InventoryPartLocation to make an inventory transaction.
PROCEDURE Inventory_Return__ (
   rma_no_                IN NUMBER,
   rma_line_no_           IN NUMBER,
   contract_              IN VARCHAR2,
   part_no_               IN VARCHAR2,
   configuration_id_      IN VARCHAR2,
   location_no_           IN VARCHAR2,
   lot_batch_no_          IN VARCHAR2,
   serial_no_             IN VARCHAR2,
   eng_chg_level_         IN VARCHAR2,
   waiv_dev_rej_no_       IN VARCHAR2,
   handling_unit_id_      IN NUMBER,
   qty_returned_          IN NUMBER,
   catch_qty_returned_    IN NUMBER,
   source_                IN VARCHAR2,
   date_received_         IN DATE,
   expiration_date_       IN DATE,
   transit_eng_chg_level_ IN VARCHAR2,
   condition_code_        IN VARCHAR2,
   part_ownership_db_     IN VARCHAR2,
   owning_vendor_no_      IN VARCHAR2,
   return_all_            IN VARCHAR2,
   date_applied_          IN DATE DEFAULT SYSDATE,        
   del_note_no_           IN VARCHAR2 DEFAULT NULL,
   del_note_date_         IN DATE     DEFAULT NULL,
   deliv_reason_id_       IN VARCHAR2 DEFAULT NULL )
IS
   activity_seq_            NUMBER;
BEGIN
   Inventory_Return___(activity_seq_,
                       rma_no_,
                       rma_line_no_,
                       contract_,
                       part_no_,
                       configuration_id_,
                       location_no_,
                       lot_batch_no_,
                       serial_no_,
                       eng_chg_level_,
                       waiv_dev_rej_no_,
                       handling_unit_id_,
                       qty_returned_,
                       catch_qty_returned_,
                       source_,
                       date_received_,
                       expiration_date_,
                       transit_eng_chg_level_,
                       condition_code_,
                        part_ownership_db_,
                       owning_vendor_no_,
                       return_all_,
                       date_applied_,
                       del_note_no_     => del_note_no_,
                       del_note_date_   => del_note_date_,
                       deliv_reason_id_ => deliv_reason_id_);
END Inventory_Return__;


-- Get_Line_No__
--   Gets the next line number for this rma.
PROCEDURE Get_Line_No__ (
   line_no_ IN OUT VARCHAR2,
   rma_no_  IN     NUMBER )
IS
   CURSOR get_rma_line is
      SELECT MAX(to_number(rma_line_no))
      FROM   RETURN_MATERIAL_LINE_TAB
      WHERE  rma_no = rma_no_;
BEGIN
   IF (line_no_ IS null) THEN
      OPEN get_rma_line;
      FETCH get_rma_line INTO line_no_;
      IF (line_no_ IS NULL) THEN
         line_no_ := '1';
      ELSE
         line_no_ := to_char(to_number(line_no_) + 1);
      END IF;
      CLOSE get_rma_line;
   END IF;
END Get_Line_No__;


-- Create_Replacement_Line__
--   This function takes the keys for a RMA line and a order number and creates
--   an order line on that order for this RMA line. ReplacementOrderNo is set
--   on the RMA line. It is only possible to create a replacement order once.
PROCEDURE Create_Replacement_Line__ (
   rma_no_               IN NUMBER,
   rma_line_no_          IN NUMBER,
   replacement_order_no_ IN VARCHAR2 )
IS
BEGIN
   NULL;
END Create_Replacement_Line__;


-- Inquire_Operation__
--   Server side logic for what might have been hairy client evaluations.
@UncheckedAccess
FUNCTION Inquire_Operation__ (
   rma_no_      IN NUMBER,
   rma_line_no_ IN NUMBER,
   operation_   IN VARCHAR2 ) RETURN VARCHAR2
IS
   rec_           RETURN_MATERIAL_LINE_TAB%ROWTYPE;
   qty_invoiced_  NUMBER;
   result_        VARCHAR2(15) := 'FALSE';
BEGIN
   rec_ := Get_Object_By_Keys___(rma_no_, rma_line_no_);
   IF rec_.order_no IS NULL THEN
      result_ := 'TRUE';
   ELSIF operation_ = 'CREDIT' THEN
      qty_invoiced_ := Customer_Order_Line_API.Get_Qty_Invoiced(rec_.order_no, rec_.line_no ,rec_.rel_no , rec_.line_item_no);
      IF (rec_.qty_to_return <= qty_invoiced_) THEN
         result_ := 'TRUE';
      END IF;
   END IF;
   RETURN result_;
END Inquire_Operation__;


-- Get_Allowed_Operations__
--   Returns a string used to determine which RMB operations should be allowed
--   for the specified return line.
@UncheckedAccess
FUNCTION Get_Allowed_Operations__ (
   rma_no_      IN NUMBER,
   rma_line_no_ IN NUMBER ) RETURN VARCHAR2
IS
   operations_        VARCHAR2(20);
   supplier_category_ VARCHAR2(20) := NULL;
   rec_               RETURN_MATERIAL_LINE_TAB%ROWTYPE;
   headrec_           Return_Material_API.Public_Rec;  
   
   same_company_      BOOLEAN := FALSE;
   custordcust_rec_   Cust_Ord_Customer_API.Public_Rec;
BEGIN
   rec_               := Get_Object_By_Keys___(rma_no_, rma_line_no_);
   headrec_           := Return_Material_API.Get(rma_no_);
   custordcust_rec_   := Cust_Ord_Customer_API.Get(headrec_.customer_no);
   
   $IF Component_Purch_SYS.INSTALLED $THEN
       supplier_category_ := Supplier_Category_API.Encode(Supplier_API.Get_Category(headrec_.return_to_vendor_no));
   $END

   IF (supplier_category_ = 'E') THEN
      IF (Site_API.Get_Company(headrec_.contract) = Site_API.Get_Company(custordcust_rec_.acquisition_site)) THEN
         same_company_ := TRUE;
      END IF;
   END IF;

   -- 0 Release RMA line
   IF (rec_.rowstate = 'Planned') THEN
      operations_ := 'R';
   ELSE
      operations_ := '*';
   END IF;

   -- 1 Deny RMA line
   IF (rec_.rowstate = 'Planned') AND NOT(headrec_.contract = headrec_.return_to_contract AND headrec_.originating_rma_no IS NOT NULL) THEN
      operations_ := operations_ || 'D';
   ELSE
      operations_ := operations_ || '*';
   END IF;

    -- 2 Complete RMA
   IF (rec_.rowstate IN ('PartiallyReceived')) AND All_Received_Handled___(rec_) AND
       NOT(headrec_.contract = headrec_.return_to_contract AND headrec_.originating_rma_no IS NOT NULL) THEN
      operations_ := operations_ || 'C';
   ELSE
      operations_ := operations_ || '*';
   END IF;

   -- 3 Scrap and return
   IF (rec_.rowstate NOT IN ('Denied', 'Planned', 'Cancelled') AND (headrec_.contract = headrec_.return_to_contract)) THEN
      operations_ := operations_ || 'S';
   ELSE
      operations_ := operations_ || '*';
   END IF;

   -- 4 Create Credit Invoice
   IF (rec_.rowstate NOT IN ('Denied', 'Planned', 'Cancelled'))
     AND (rec_.credit_approver_id IS NOT NULL)
     AND (rec_.credit_invoice_no IS NULL) THEN
      operations_ := operations_ || 'I';
   ELSE
      operations_ := operations_ || '*';
   END IF;

   -- 5 View Credit Invoice
   IF (rec_.rowstate NOT IN ('Denied', 'Planned','Cancelled')) AND (rec_.credit_invoice_no IS NOT NULL) THEN
      operations_ := operations_ || 'V';
   ELSE
      operations_ := operations_ || '*';
   END IF;

   -- 6 Approve Credit
   IF (rec_.rowstate NOT IN ('Denied', 'Planned', 'Cancelled'))
     AND (rec_.credit_approver_id IS NULL)
     AND (Check_Exch_Charge_Order(rma_no_, rma_line_no_) = 'FALSE') THEN
      operations_ := operations_ || 'A';
   ELSE
      operations_ := operations_ || '*';
   END IF;

   -- 7 Remove Approval Credit
   IF (rec_.rowstate NOT IN ('Denied', 'Planned', 'Cancelled'))
     AND (rec_.credit_invoice_no IS NULL)
     AND (rec_.credit_approver_id IS NOT NULL) THEN
      operations_ := operations_ || 'R';
   ELSE
      operations_ := operations_ || '*';
   END IF;

   -- 8 View configuration
   IF (rec_.configuration_id != '*') THEN
      operations_ := operations_ || 'V';
   ELSE
      operations_ := operations_ || '*';
   END IF;

   -- 9 Cancel
   IF (rec_.rowstate IN ('Planned', 'Released'))
     AND NOT(rec_.rowstate IN ('Released') AND (rec_.credit_invoice_no IS NOT NULL OR rec_.credit_approver_id IS NOT NULL))
     AND NOT(headrec_.contract = headrec_.return_to_contract AND headrec_.originating_rma_no IS NOT NULL) THEN
      operations_ := operations_ || 'L';
   ELSE
      operations_ := operations_ || '*';
   END IF;

   -- 10 Register Return to Supplier
   IF (rec_.rowstate NOT IN ('Denied', 'Planned', 'Cancelled')
     AND ((supplier_category_ = 'E') AND ((custordcust_rec_.category = 'E') OR (rec_.part_no IS NULL) OR NOT(same_company_)))) THEN
      operations_ := operations_ || 'U';
   ELSE
      operations_ := operations_ || '*';
   END IF;

   -- 11 Direct Return to Supplier from Internal Order Transit
   IF (rec_.rowstate NOT IN ('Denied', 'Planned', 'Cancelled')
     AND (supplier_category_ = 'E')
     AND (same_company_)
     AND (custordcust_rec_.category = 'I'))
     AND (rec_.part_no IS NOT NULL) AND NOT All_Received_Handled___(rec_) THEN
         operations_ := operations_ || 'T';
   ELSE
      operations_ := operations_ || '*';
   END IF;

   RETURN operations_;
END Get_Allowed_Operations__;


-- Complete_Line__
--   Trig state machinery to complete a line. Provided for ReturnMaterial
--   to be able to complete a complete RMA.
PROCEDURE Complete_Line__ (
   rma_no_      IN NUMBER,
   rma_line_no_ IN NUMBER )
IS
   info_       VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   attr_       VARCHAR2(2000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Get_Id_Version_By_Keys___(objid_ , objversion_, rma_no_, rma_line_no_);
   Complete__(info_ , objid_, objversion_, attr_, 'DO');
   Trace_SYS.Field('Completed attr', attr_);
END Complete_Line__;


-- Approve_For_Credit__
--   Called from client to approve a line for crediting. Sets the credit
--   approver to the user id of the user if he is a credit approver.
PROCEDURE Approve_For_Credit__ (
   rma_no_      IN NUMBER,
   rma_line_no_ IN NUMBER )
IS
   info_         VARCHAR2(2000);
   objid_        VARCHAR2(2000);
   objversion_   VARCHAR2(2000);
   attr_         VARCHAR2(2000);
   approver_     VARCHAR2(200);
   session_user_ VARCHAR2(200);
   message_      VARCHAR2(2000);
BEGIN
   session_user_ := Fnd_Session_API.Get_Fnd_User;
   approver_     := Person_Info_API.Get_Id_For_User(session_user_);
   IF (approver_ IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'NOPERCOORD: Logon user :P1 is not connected to an application person id.', session_user_);
   ELSE
      IF (Order_Coordinator_API.Check_Exist(approver_)= 'FALSE') THEN
         Error_SYS.Record_General(lu_name_, 'APPROVER_NOT_REG: You need to be registered as a coordinator in order to approve the return material authorization.');
      END IF;
   END IF;
   IF (Get_Rental_Db(rma_no_,rma_line_no_) = Fnd_Boolean_API.DB_TRUE) THEN
      Error_SYS.Record_General(lu_name_, 'APPROVENOTALLOWED: It is not possible to approve for credit for rental lines.');
   END IF;

   Get_Id_Version_By_Keys___(objid_, objversion_, rma_no_, rma_line_no_);
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('CREDIT_APPROVER_ID', approver_, attr_);
   Modify__(info_, objid_ , objversion_, attr_, 'DO');
   message_ := Language_SYS.Translate_Constant(lu_name_, 'RMALINECREAPP: Line :P1 approved for credit.', p1_ => rma_line_no_);
   Return_Material_History_API.New(rma_no_, message_);
END Approve_For_Credit__;


-- Remove_Credit_Approval__
--   Called from client to remove credit apporval for a line. Resets the
--   apporver ID. If not allowed the procedure will fail.
PROCEDURE Remove_Credit_Approval__ (
   rma_no_      IN NUMBER,
   rma_line_no_ IN NUMBER )
IS
   info_       VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   attr_       VARCHAR2(2000);
   message_    VARCHAR2(2000);
BEGIN
   Get_Id_Version_By_Keys___ ( objid_ , objversion_, rma_no_, rma_line_no_);
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('CREDIT_APPROVER_ID', '', attr_);
   Modify__(info_, objid_, objversion_, attr_, 'DO');
   message_ := Language_SYS.Translate_Constant(lu_name_, 'RMALINEREMCREAPP: Removed credit approval for RMA line :P1.', p1_ => rma_line_no_);
   Return_Material_History_API.New(rma_no_, message_);
END Remove_Credit_Approval__;


-- Modify_Line__
--   Purpose of this private procedure is to modify the Return Material Line.
PROCEDURE Modify_Line__ (
   attr_        IN OUT VARCHAR2,
   rma_no_      IN     NUMBER,
   rma_line_no_ IN     NUMBER )
IS
   objid_  VARCHAR2(2000);
   objver_ VARCHAR2(2000);
   info_   VARCHAR2(32000);
BEGIN
   Get_Id_Version_By_Keys___(objid_, objver_, rma_no_, rma_line_no_);
   Modify__(info_, objid_, objver_, attr_, 'DO');
   Client_SYS.Clear_Info;
END Modify_Line__;


PROCEDURE Packed_Inventory_Return__ (
   rma_no_           IN NUMBER,
   rma_line_no_      IN NUMBER,
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   location_no_      IN VARCHAR2,
   message_          IN VARCHAR2,
   source_           IN VARCHAR2,
   date_received_    IN DATE )
IS
BEGIN
   Packed_Inventory_Return___ (rma_no_, rma_line_no_, contract_, part_no_, configuration_id_,location_no_, message_, source_, date_received_ );
END Packed_Inventory_Return__;


PROCEDURE Packed_Return_And_Scrap__ (
   rma_no_           IN NUMBER,
   rma_line_no_      IN NUMBER,
   reject_code_      IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   message_          IN VARCHAR2,
   date_received_    IN DATE )
IS
BEGIN
   Packed_Return_And_Scrap___ (rma_no_ , rma_line_no_,reject_code_,part_no_,configuration_id_ , message_, date_received_);
END Packed_Return_And_Scrap__;


-- Modify_Rma_Defaults__
--   Modify RMAs header specific delivery information for all RMA lines
--   having pay tax set to Yes.
PROCEDURE Modify_Rma_Defaults__ (
   rma_no_                    IN NUMBER,
   rma_line_no_               IN NUMBER,
   pay_tax_                   IN BOOLEAN,
   update_tax_from_ship_addr_ IN BOOLEAN,
   update_tax_                IN BOOLEAN DEFAULT TRUE)
IS
   attr_         VARCHAR2(2000);
   oldrec_       RETURN_MATERIAL_LINE_TAB%ROWTYPE;
   newrec_       RETURN_MATERIAL_LINE_TAB%ROWTYPE;
   indrec_       Indicator_Rec;
   objid_        VARCHAR2(2000);
   objversion_   VARCHAR2(2000);
BEGIN
   oldrec_ := Get_Object_By_Keys___(rma_no_,rma_line_no_);
   newrec_ := oldrec_;

   IF (update_tax_from_ship_addr_) THEN
      Client_SYS.Add_To_Attr('UPDATE_TAX_FROM_SHIP_ADDR', 'TRUE', attr_);
   END IF;
   
   IF NOT update_tax_ THEN
      Client_SYS.Add_To_Attr('UPDATE_TAX', 'FALSE', attr_);
   END IF;

   IF (newrec_.rowstate NOT IN ('Denied', 'Cancelled')) THEN
      IF NOT (Postings_Are_Created___(newrec_)) THEN
         Client_SYS.Add_To_Attr('TAX_LIABILITY', Return_Material_API.Get_Tax_Liability(rma_no_), attr_);
         Unpack___(newrec_, indrec_, attr_);
         Check_Update___(oldrec_, newrec_, indrec_, attr_);
         Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
      END IF;
   END IF;
END Modify_Rma_Defaults__;


-- Fetch_Supplier_Rtn_Reason__
--   This is to retrieve supplier return_reason for direct return to external supplier from internal customer.
PROCEDURE Fetch_Supplier_Rtn_Reason__ (
   rma_no_      IN NUMBER,
   rma_line_no_ IN NUMBER )
IS
   rma_rec_                 Return_Material_API.Public_Rec;
   rec_                     Return_Material_Line_API.Public_Rec;
   orderrow_rec_            Customer_Order_Line_API.Public_Rec;
   supplier_return_reason_  RETURN_MATERIAL_LINE_TAB.supplier_return_reason%TYPE;
   line_attr_               VARCHAR2(2000);
BEGIN
   rec_          := Get(rma_no_, rma_line_no_);
   rma_rec_      := Return_Material_API.Get(rma_no_);
   orderrow_rec_ := Customer_Order_Line_API.Get(rec_.order_no, rec_.line_no, rec_.rel_no, rec_.line_item_no);
   IF (rma_rec_.return_to_vendor_no IS NOT NULL AND (NVL(rma_rec_.contract, Database_SYS.string_null_) != NVL(rma_rec_.return_to_contract, Database_SYS.string_null_)) AND orderrow_rec_.supply_code = 'PD') THEN
      supplier_return_reason_ := Get_Supplier_Rtn_Reason(rma_no_, rma_line_no_);
      IF (supplier_return_reason_ IS NOT NULL) THEN
         Client_SYS.Clear_Attr(line_attr_);
         Client_SYS.Add_To_Attr('SUPPLIER_RETURN_REASON', supplier_return_reason_, line_attr_);
         Modify_Line__(line_attr_, rma_no_, rma_line_no_);
      END IF;
   END IF;
END Fetch_Supplier_Rtn_Reason__;


@Override
PROCEDURE Release__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   rec_     RETURN_MATERIAL_LINE_TAB%ROWTYPE;
   message_ RETURN_MATERIAL_HISTORY_TAB.message_text%TYPE;
BEGIN
   IF (action_ = 'DO') THEN
      rec_ := Get_Object_By_Id___(objid_);
      Check_Ex_Order_Connectable___(rec_.order_no, rec_.line_no, rec_.rel_no, rec_.line_item_no, FALSE);
      Validate_Ship_Via_Del_Term___(rec_.rma_no, rec_.order_no);
   END IF;

   super(info_, objid_, objversion_, attr_, action_);

   IF (action_ = 'DO') THEN
      message_ := Language_SYS.Translate_Constant(lu_name_, 'RMALINEREL: Line :P1 released.', p1_ => rec_.rma_line_no);
      Return_Material_History_API.New(rec_.rma_no, message_);
      -- Find and Connect Export License
      Check_Export_Controlled___(rec_.rma_no, rec_.rma_line_no);
   END IF;
END Release__;


@Override
PROCEDURE Deny__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   rec_                    RETURN_MATERIAL_LINE_TAB%ROWTYPE;
   message_                RETURN_MATERIAL_HISTORY_TAB.message_text%TYPE;
   exp_license_connect_id_ NUMBER;
BEGIN
   IF (action_ = 'DO') THEN
      rec_ := Get_Object_By_Id___(objid_);
      Check_Ex_Order_Connectable___(rec_.order_no, rec_.line_no, rec_.rel_no, rec_.line_item_no, FALSE);
      Validate_Ship_Via_Del_Term___(rec_.rma_no, rec_.order_no);
   END IF;
   super(info_, objid_, objversion_, attr_, action_);
   IF (action_ = 'DO') THEN
      Customer_Order_Flow_API.Check_Delete_Exp_License(rec_.rma_no, rec_.rma_line_no, NULL, NULL, 'RMA');
      $IF Component_Expctr_SYS.INSTALLED $THEN
         exp_license_connect_id_ := Exp_License_Connect_Head_API.Get_Connect_Id_From_Ref('RMA',rec_.rma_no, rec_.rma_line_no, NULL, NULL);
         IF (exp_license_connect_id_ IS NOT NULL) THEN
            Exp_License_Connect_Head_API.Set_License_Order_Event(exp_license_connect_id_, 'CANCELED');   
         END IF;          
      $END
      message_ := Language_SYS.Translate_Constant(lu_name_, 'RMALINEDEN: Line :P1 denied.', p1_ => rec_.rma_line_no);
      Return_Material_History_API.New(rec_.rma_no, message_);
   END IF;
END Deny__;


@Override
PROCEDURE Complete__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   rec_     RETURN_MATERIAL_LINE_TAB%ROWTYPE;
   message_ RETURN_MATERIAL_HISTORY_TAB.message_text%TYPE;
BEGIN
   IF (action_ = 'DO') THEN
      rec_ := Get_Object_By_Id___(objid_);
   END IF;
   super(info_, objid_, objversion_, attr_, action_);
   IF (action_ = 'DO') THEN
      message_ := Language_SYS.Translate_Constant(lu_name_, 'RMALINECOMPL: Line :P1 completed.', p1_ => rec_.rma_line_no);
      Return_Material_History_API.New(rec_.rma_no, message_);
   END IF;
END Complete__;


@Override
PROCEDURE Cancel__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   rec_                    RETURN_MATERIAL_LINE_TAB%ROWTYPE;
   message_                VARCHAR2(500);
   exp_license_connect_id_ NUMBER;
BEGIN
   IF (action_ = 'DO') THEN
      rec_ := Get_Object_By_Id___(objid_);
   END IF;
   super(info_, objid_, objversion_, attr_, action_);
   IF (action_ = 'DO') THEN
      Customer_Order_Flow_API.Check_Delete_Exp_License(rec_.rma_no, rec_.rma_line_no, NULL, NULL, 'RMA');
      $IF Component_Expctr_SYS.INSTALLED $THEN
         exp_license_connect_id_ := Exp_License_Connect_Head_API.Get_Connect_Id_From_Ref('RMA',rec_.rma_no, rec_.rma_line_no, NULL, NULL);
         IF (exp_license_connect_id_ IS NOT NULL) THEN
            Exp_License_Connect_Head_API.Set_License_Order_Event(exp_license_connect_id_, 'CANCELED'); 
         END IF;
      $END
      message_ := Language_SYS.Translate_Constant(lu_name_, 'RMALINECANCEL: Line :P1 cancelled.', p1_ => rec_.rma_line_no);
      Return_Material_History_API.New(rec_.rma_no, message_);
   END IF;
END Cancel__;


-- Unpack_Cust_Receipt__
--   Creates customer receipt and receipt location for the rma_lines.
--   Note that the message should be sorted in ascending order by rma_no and rma_line_no.
PROCEDURE Unpack_Cust_Receipt__ (
   message_       IN OUT VARCHAR2,
   receipt_type_  IN     VARCHAR2 )
IS
BEGIN
   Unpack_Cust_Receipt___ ( message_,receipt_type_);
END Unpack_Cust_Receipt__;


-- Modify_Po_Info__
--   This method is used to update PO info. This is used from RMA header when return to contract
--   or return to vendor is changed.
PROCEDURE Modify_Po_Info__ (
   rma_no_        IN NUMBER,
   rma_line_no_   IN NUMBER,
   pur_order_no_  IN VARCHAR2,
   pur_line_no_   IN VARCHAR2,
   pur_rel_no_    IN VARCHAR2 )
IS
   attr_         VARCHAR2(2000);
   oldrec_       RETURN_MATERIAL_LINE_TAB%ROWTYPE;
   newrec_       RETURN_MATERIAL_LINE_TAB%ROWTYPE;
   indrec_       Indicator_Rec;
   objid_        VARCHAR2(2000);
   objversion_   VARCHAR2(2000);
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, rma_no_, rma_line_no_);
   oldrec_ := Lock_By_Keys___(rma_no_, rma_line_no_);
   newrec_ := oldrec_;

   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('PO_ORDER_NO', pur_order_no_, attr_);
   Client_SYS.Add_To_Attr('PO_LINE_NO', pur_line_no_, attr_);
   Client_SYS.Add_To_Attr('PO_REL_NO', pur_rel_no_, attr_);

   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
END Modify_Po_Info__;

-- gelr:modify_date_applied, begin
PROCEDURE Modify_Inv_Trans_Date___ (
   transaction_id_tab_  IN Inventory_Transaction_Hist_API.Transaction_Id_Tab,
   date_applied_        IN DATE)
IS
   info_              VARCHAR2(2000);   
BEGIN
   IF (transaction_id_tab_.COUNT > 0) THEN
      FOR i IN transaction_id_tab_.FIRST..transaction_id_tab_.LAST LOOP
            Inventory_Transaction_Hist_API.Modify_Date_Applied(info_,
                                                              transaction_id_tab_(i),
                                                              date_applied_);
         END LOOP;
   END IF;
END Modify_Inv_Trans_Date___;
-- gelr:modify_date_applied, end

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Series_Info
--   Returns the series_id of a given invoice_no, if only one such invoice_no
--   exists in the system. Otherwise returns NULL.
@UncheckedAccess
FUNCTION Get_Series_Info (
   company_     IN VARCHAR2,
   invoice_no_  IN VARCHAR2,
   contract_    IN VARCHAR2,
   catalog_no_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   count_      NUMBER := 0;
   series_id_  VARCHAR2(20);

   CURSOR count_series_id IS
      SELECT COUNT(DISTINCT(series_id))
      FROM   customer_order_inv_item ii, customer_order_inv_head ih
      WHERE  ii.invoice_id = ih.invoice_id
      AND    ii.company = ih.company
      AND    ii.company    = company_
      AND    ih.invoice_no = invoice_no_
      AND    ii.catalog_no = catalog_no_
      AND    ii.contract   = contract_;

   CURSOR get_series_id IS
      SELECT DISTINCT(series_id)
      FROM   customer_order_inv_item ii, customer_order_inv_head ih
      WHERE  ii.invoice_id = ih.invoice_id
      AND    ii.company = ih.company
      AND    ii.company    = company_
      AND    ih.invoice_no = invoice_no_
      AND    ii.catalog_no = catalog_no_
      AND    ii.contract   = contract_;
BEGIN
   OPEN count_series_id;
   FETCH count_series_id INTO count_;
   CLOSE count_series_id;
   IF (count_ = 1) THEN
      OPEN get_series_id;
      FETCH get_series_id INTO series_id_;
      CLOSE get_series_id;
   END IF;
   RETURN series_id_;
END Get_Series_Info;


-- Get_Pre_Accounting_Id
--   Returns the Pre Acconting Id of the customer order connected.
@UncheckedAccess
FUNCTION Get_Pre_Accounting_Id (
   rma_no_      IN NUMBER,
   rma_line_no_ IN NUMBER ) RETURN NUMBER
IS
   CURSOR get_order_info IS
      SELECT order_no, line_no, rel_no, line_item_no
      FROM   RETURN_MATERIAL_LINE_TAB
      WHERE  rma_no = rma_no_
      AND    rma_line_no = rma_line_no_;

   order_key_          get_order_info%ROWTYPE;
   pre_accounting_id_  NUMBER := NULL;
BEGIN
   OPEN get_order_info;
   FETCH get_order_info INTO order_key_;
   CLOSE get_order_info;
   IF (order_key_.order_no IS NOT NULL) THEN
      pre_accounting_id_ := Customer_Order_Line_API.Get_Pre_Accounting_Id(order_key_.order_no,
                                                                          order_key_.line_no,
                                                                          order_key_.rel_no,
                                                                          order_key_.line_item_no);
   END IF;
   RETURN pre_accounting_id_;
END Get_Pre_Accounting_Id;


-- Returns the returned qunatity of the shipment.
@UncheckedAccess
FUNCTION Get_Ship_Return_Qty (
   order_no_     IN  VARCHAR2,
   line_no_      IN  VARCHAR2,
   rel_no_       IN  VARCHAR2,
   line_item_no_ IN  NUMBER,
   shipment_id_  IN  NUMBER ) RETURN NUMBER
IS
   total_qty_returned_ NUMBER;

   CURSOR get_total_ship_qty_returned IS
      SELECT SUM(qty_to_return)
      FROM RETURN_MATERIAL_LINE_TAB rml, RETURN_MATERIAL_TAB rma
      WHERE rml.order_no     = order_no_
      AND rml.line_no      = line_no_
      AND rml.rel_no       = rel_no_
      AND rml.line_item_no = line_item_no_
      AND rml.rma_no       = rma.rma_no
      AND rma.shipment_id  = shipment_id_
      AND rml.rowstate NOT IN ('Denied', 'Cancelled');
BEGIN
   OPEN get_total_ship_qty_returned;
   FETCH get_total_ship_qty_returned INTO total_qty_returned_;
   CLOSE get_total_ship_qty_returned;
   RETURN total_qty_returned_;
END Get_Ship_Return_Qty;

@UncheckedAccess
PROCEDURE Get_Co_Line_Data (
   attr_         OUT VARCHAR2,
   order_no_     IN  VARCHAR2,
   line_no_      IN  VARCHAR2,
   rel_no_       IN  VARCHAR2,
   line_item_no_ IN  NUMBER,
   rma_no_       IN  NUMBER,
   rma_line_no_  IN  NUMBER,
   shipment_id_  IN  NUMBER DEFAULT NULL)
IS
   ordrow_rec_               Customer_Order_Line_API.public_rec;
   poss_qty_to_return_       NUMBER;
   qty_to_return_inv_uom_    NUMBER;
   tot_qty_returned_inv_uom_ NUMBER;
   total_qty_returned_       NUMBER;
   customer_order_rec_       Customer_Order_API.Public_Rec;
   ship_line_qty_shipped_    NUMBER; 
   qty_shipped_sales_uom_         NUMBER;
   total_ship_qty_returned_       NUMBER;
   tot_ship_qty_returned_inv_uom_ NUMBER;
   ship_line_qty_ship_sales_uom_  NUMBER;
   
   CURSOR get_total_ship_qty_returned IS
      SELECT SUM(qty_to_return), SUM(qty_to_return_inv_uom)
      FROM RETURN_MATERIAL_LINE_TAB rml, RETURN_MATERIAL_TAB rma
      WHERE rml.order_no     = order_no_
      AND rml.line_no      = line_no_
      AND rml.rel_no       = rel_no_
      AND rml.line_item_no = line_item_no_
      AND rml.rma_no       = rma.rma_no
      AND rma.shipment_id  = shipment_id_
      AND rml.rowstate NOT IN ('Denied', 'Cancelled');

   CURSOR get_total_qty_returned IS
      SELECT SUM(qty_to_return), SUM(qty_to_return_inv_uom)
      FROM RETURN_MATERIAL_LINE_TAB
      WHERE order_no     = order_no_
      AND line_no      = line_no_
      AND rel_no       = rel_no_
      AND line_item_no = line_item_no_
      AND rowstate NOT IN ('Denied', 'Cancelled')
      AND ((rma_line_no_ IS NULL) OR ((rma_line_no_ IS NOT NULL) AND (rma_no != rma_no_)));
BEGIN
   ordrow_rec_ := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);

   -- The cursor is used in both scenarios
   OPEN get_total_qty_returned;
   FETCH get_total_qty_returned INTO total_qty_returned_, tot_qty_returned_inv_uom_;
   CLOSE get_total_qty_returned;
   total_qty_returned_ := NVL(total_qty_returned_ , 0);
   tot_qty_returned_inv_uom_ := NVL(tot_qty_returned_inv_uom_, 0);

   -- Convert the qty_shipped to sales unit of measure.
   qty_shipped_sales_uom_ := ordrow_rec_.qty_shipped / ordrow_rec_.conv_factor * ordrow_rec_.inverted_conv_factor;

   IF (shipment_id_ IS NULL) THEN
      -- There is no connected shipment in the RMA header.
      -- The qty expressed in Sales UoM
      poss_qty_to_return_ := qty_shipped_sales_uom_ - total_qty_returned_;
      
      IF (poss_qty_to_return_ != 0) THEN
         -- The qty expressed in Inv UoM
         qty_to_return_inv_uom_ := ordrow_rec_.qty_shipped - tot_qty_returned_inv_uom_;
      END IF;
   ELSE
      OPEN get_total_ship_qty_returned;
      FETCH get_total_ship_qty_returned INTO total_ship_qty_returned_, tot_ship_qty_returned_inv_uom_;
      CLOSE get_total_ship_qty_returned;
      total_ship_qty_returned_ := NVL(total_ship_qty_returned_, 0);
      tot_ship_qty_returned_inv_uom_ := NVL(tot_ship_qty_returned_inv_uom_, 0);
      
      -- Inv UoM
      ship_line_qty_shipped_ := Shipment_Line_API.Get_Qty_Shipped_By_Source(shipment_id_,order_no_, line_no_, rel_no_, line_item_no_, Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER);
      -- Convert the shipment qty_shipped to sales unit of measure.
      ship_line_qty_ship_sales_uom_ := ship_line_qty_shipped_ / ordrow_rec_.conv_factor * ordrow_rec_.inverted_conv_factor;
      
      -- The qty expressed in Sales UoM.
      -- Limit the qty to the actual remaining qty left to be returned for the order line.
      poss_qty_to_return_ := LEAST(qty_shipped_sales_uom_ - total_qty_returned_, ship_line_qty_ship_sales_uom_ - total_ship_qty_returned_);

      IF (poss_qty_to_return_ != 0) THEN
         -- The qty expressed in Inv UoM.
         -- Limit the qty to the actual remaining qty left to be returned for the order line.
         qty_to_return_inv_uom_ := LEAST(ordrow_rec_.qty_shipped - tot_qty_returned_inv_uom_, ship_line_qty_shipped_ - tot_ship_qty_returned_inv_uom_);
      END IF;
   END IF;
   
   customer_order_rec_ := Customer_Order_API.Get(order_no_);

   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('ORDER_NO',              order_no_,                          attr_);
   Client_SYS.Add_To_Attr('LINE_NO',               line_no_,                           attr_);
   Client_SYS.Add_To_Attr('REL_NO',                rel_no_,                            attr_);
   Client_SYS.Add_To_Attr('LINE_ITEM_NO',          line_item_no_,                      attr_);
   Client_SYS.Add_To_Attr('CATALOG_NO',            ordrow_rec_.catalog_no,             attr_);
   Client_SYS.Add_To_Attr('PART_NO',               ordrow_rec_.part_no,                attr_);
   Client_SYS.Add_To_Attr('CONFIGURATION_ID',      ordrow_rec_.configuration_id,       attr_);
   Client_SYS.Add_To_Attr('POSS_QTY_TO_RETURN',    poss_qty_to_return_,                attr_);
   Client_SYS.Add_To_Attr('TAX_LIABILITY',         ordrow_rec_.tax_liability,          attr_);
   Client_SYS.Add_To_Attr('CURRENCY_RATE',         ordrow_rec_.currency_rate,          attr_);
   Client_SYS.Add_To_Attr('CONV_FACTOR',           ordrow_rec_.conv_factor,            attr_);
   Client_SYS.Add_To_Attr('INVERTED_CONV_FACTOR',  ordrow_rec_.inverted_conv_factor,   attr_);
   Client_SYS.Add_To_Attr('CONDITION_CODE',        ordrow_rec_.condition_code,         attr_);
   Client_SYS.Add_To_Attr('CATALOG_DESC',          ordrow_rec_.catalog_desc,           attr_);
   Client_SYS.Add_To_Attr('DELIVERY_TYPE',         ordrow_rec_.delivery_type,          attr_);
   Client_SYS.Add_To_Attr('QTY_TO_RETURN_INV_UOM', qty_to_return_inv_uom_,             attr_);
   Client_SYS.Add_To_Attr('RENTAL_DB',             ordrow_rec_.rental,                 attr_);
   Client_SYS.Add_To_Attr('CUSTOMER_PO_NO',        customer_order_rec_.customer_po_no, attr_);
   Client_SYS.Add_To_Attr('INTERNAL_PO_NO',        customer_order_rec_.internal_po_no, attr_);
END Get_Co_Line_Data;


@UncheckedAccess
PROCEDURE Get_Co_Line_Info (
   attr_          OUT VARCHAR2,
   id_no_         IN  VARCHAR2,
   id_type_       IN  VARCHAR2,
   contract_      IN  VARCHAR2,
   catalog_no_    IN  VARCHAR2,
   customer_no_   IN  VARCHAR2,
   currency_code_ IN  VARCHAR2,
   series_id_     IN  VARCHAR2,
   order_no_      IN  VARCHAR2 DEFAULT NULL,
   line_no_       IN  VARCHAR2 DEFAULT NULL,
   rel_no_        IN  VARCHAR2 DEFAULT NULL,
   line_item_no_  IN  NUMBER   DEFAULT NULL,
   rma_no_        IN  NUMBER   DEFAULT NULL,
   rma_line_no_   IN  NUMBER   DEFAULT NULL,
   shipment_id_   IN  NUMBER   DEFAULT NULL  )
IS
   company_            CUSTOMER_ORDER_INV_HEAD.company%TYPE;
   info_exist_         VARCHAR2(15);

   CURSOR get_co_info(customer_order_no_ VARCHAR2) IS
      SELECT col.order_no,
             col.line_no,
             col.rel_no,
             col.line_item_no
      FROM   customer_order_line_tab col, customer_order_tab co
      WHERE  col.order_no     = co.order_no
      AND    co.order_no      = customer_order_no_
      AND    col.catalog_no   = catalog_no_
      AND    co.contract      = contract_
      AND    co.customer_no   = customer_no_
      AND    co.currency_code = currency_code_
      AND    col.qty_shipped - col.qty_returned > 0
      AND    col.rowstate IN ('Delivered', 'PartiallyDelivered', 'Invoiced')
      AND    ((info_exist_ = 'FOUND') AND
             (col.line_no = line_no_)AND
             (col.rel_no = rel_no_) AND
             (col.line_item_no = line_item_no_) OR
             (info_exist_ = 'NOT FOUND'));

   co_key_             get_co_info%ROWTYPE;

   CURSOR get_cpo_info(customer_po_no_ VARCHAR2) IS
      SELECT co.order_no,
             col.line_no,
             col.rel_no,
             col.line_item_no
      FROM   customer_order_tab co, customer_order_line_tab col
      WHERE  co.customer_po_no = customer_po_no_
      AND    co.order_no       = col.order_no
      AND    col.contract      = contract_
      AND    col.catalog_no    = catalog_no_
      AND    co.customer_no    = customer_no_
      AND    co.currency_code  = currency_code_
      AND    col.qty_shipped - col.qty_returned > 0
      AND    col.rowstate IN ('Delivered', 'PartiallyDelivered', 'Invoiced')
      AND    ((info_exist_ = 'FOUND') AND
             (col.line_no = line_no_)AND
             (col.rel_no = rel_no_) AND
             (col.line_item_no = line_item_no_) OR
             (info_exist_ = 'NOT FOUND'));

    cpo_key_           get_cpo_info%ROWTYPE;

   CURSOR get_creators_ref(invoice_no_ VARCHAR2) IS
      SELECT ii.invoice_id
      FROM   customer_order_inv_item ii, customer_order_inv_head ih
      WHERE  ii.invoice_id   = ih.invoice_id
      AND    ii.company   = ih.company
      AND    ii.company    = company_
      AND    ii.order_no   = order_no_
      AND    ih.invoice_no = invoice_no_
      AND    ii.catalog_no = catalog_no_
      AND    ih.series_id  = series_id_;

    invoice_info_      get_creators_ref%ROWTYPE;
    item_id_           NUMBER;
BEGIN
   -- Check whether RMA information exist.
   info_exist_ := CASE
                     WHEN (rel_no_ IS NOT NULL) THEN
                        'FOUND'
                     ELSE
                        'NOT FOUND'
                     END;

   -- Customer Order Number
   IF (id_type_ = 'CO') THEN
      OPEN get_co_info(id_no_);
      FETCH get_co_info INTO co_key_;
      CLOSE get_co_info;

      Get_Co_Line_Data(attr_, co_key_.order_no, co_key_.line_no, co_key_.rel_no, co_key_.line_item_no, rma_no_, rma_line_no_, shipment_id_);

   -- Customer Purchase Order Number
   ELSIF (id_type_ = 'CPO') THEN
      OPEN get_cpo_info(id_no_);
      FETCH get_cpo_info INTO cpo_key_;
      CLOSE get_cpo_info;

      Get_Co_Line_Data(attr_, cpo_key_.order_no, cpo_key_.line_no, cpo_key_.rel_no, cpo_key_.line_item_no, rma_no_, rma_line_no_);

   -- Invoice Number
   ELSIF (id_type_ = 'INVOICE') THEN
      company_ := Site_API.Get_Company(contract_);

      OPEN get_creators_ref(id_no_);
      FETCH get_creators_ref INTO invoice_info_;
      CLOSE get_creators_ref;

      OPEN  get_co_info(order_no_);
      FETCH get_co_info INTO co_key_;
      CLOSE get_co_info;

      Get_Ivc_Line_Data(attr_, co_key_.order_no, co_key_.line_no, co_key_.rel_no, co_key_.line_item_no, id_no_, invoice_info_.invoice_id, series_id_, company_, rma_no_, rma_line_no_);

      item_id_ := Customer_Order_Inv_Item_API.Get_Item_Id(invoice_info_.invoice_id,
                                                          co_key_.order_no,
                                                          co_key_.line_no,
                                                          co_key_.rel_no,
                                                          co_key_.line_item_no);
      Client_SYS.Add_To_Attr('ITEM_ID', item_id_, attr_);
   END IF;
END Get_Co_Line_Info;


-- Get_Price_Info
--   Gets the priceinformation from the CO line or invoice item depending
--   on the parameter values. Called from client.
PROCEDURE Get_Price_Info (
   sale_unit_price_               OUT    NUMBER,
   sale_unit_price_incl_tax_      OUT    NUMBER,
   base_sale_unit_price_          OUT    NUMBER,
   base_sale_unit_price_incl_tax_ OUT    NUMBER,
   line_total_base_               OUT    NUMBER,
   line_total_incl_tax_base_      OUT    NUMBER,
   line_total_curr_               OUT    NUMBER,
   line_total_incl_tax_curr_      OUT    NUMBER,
   discount_                      OUT    NUMBER,
   tax_code_                      OUT    VARCHAR2,
   tax_class_id_                  OUT    VARCHAR2,
   price_conv_factor_             IN OUT NUMBER,
   condition_code_                IN OUT VARCHAR2,
   qty_to_return_                 IN     NUMBER,
   customer_no_                   IN     VARCHAR2,
   contract_                      IN     VARCHAR2,
   currency_code_                 IN     VARCHAR2,
   catalog_no_                    IN     VARCHAR2,
   order_no_                      IN     VARCHAR2,
   line_no_                       IN     VARCHAR2,
   rel_no_                        IN     VARCHAR2,
   line_item_no_                  IN     NUMBER,
   invoice_no_                    IN     VARCHAR2,
   invoice_item_id_               IN     NUMBER,
   series_id_                     IN     VARCHAR2,
   use_price_incl_tax_            IN     VARCHAR2 )
IS
   col_rec_                   Customer_Order_Line_API.public_rec;
   disc_                      NUMBER;
   order_disc_                NUMBER;
   company_                   VARCHAR2(20);
   invoice_id_                NUMBER;
   sale_price_                NUMBER;
   sale_price_incl_tax_       NUMBER;
   base_price_                NUMBER;
   base_price_incl_tax_       NUMBER;
   add_disc_                  NUMBER;
   salerec_                   Sales_Part_API.Public_Rec;   
   base_currency_rate_        NUMBER;
   sale_currency_rate_        NUMBER;
   rounding_                  NUMBER;
   sales_price_               NUMBER;
   sales_price_incl_tax_      NUMBER;
   line_disc_amount_          NUMBER := 0;
   add_disc_amount_           NUMBER;
   order_disc_amount_         NUMBER;
   currency_rate_type_        VARCHAR2(10);   
   currency_rounding_         NUMBER;
   cond_code_rec_             Condition_Code_Sale_Price_API.Public_Rec;
   cond_code_price_exist_     BOOLEAN := FALSE;
   part_catalog_rec_          Part_Catalog_API.Public_Rec;
BEGIN
   company_            := Site_API.Get_Company(contract_);
   currency_rate_type_ := Customer_order_API.Get_Currency_Rate_Type(order_no_);
   currency_rounding_  := Currency_Code_API.Get_Currency_Rounding(company_, currency_code_);
   rounding_           := Currency_Code_API.Get_Currency_Rounding(company_, Company_Finance_API.Get_Currency_Code(company_));

   IF (order_no_ IS NOT NULL) THEN
      --  Retrieve price information from invoice item if invoice item keys are passed to the
      --  method. IF not price info is retrieved from customer order line.
      col_rec_ := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);
      IF (col_rec_.rental = Fnd_Boolean_API.DB_FALSE) THEN
         IF (invoice_no_ IS NOT NULL AND invoice_item_id_ IS NOT NULL) THEN
            -- Retrieve the invoice id corresponding to invoice_no
            invoice_id_ := Customer_Order_Inv_Head_API.Get_Invoice_Id_By_No(company_, invoice_no_, series_id_);
            -- Retrieve the price info from invoice item
            Customer_Order_Inv_Item_API.Get_Price_Info(sale_price_, sale_price_incl_tax_, disc_, order_disc_, add_disc_, company_, invoice_id_, invoice_item_id_);
            Customer_Order_Pricing_API.Get_Base_Price_In_Currency(base_price_, base_currency_rate_, customer_no_,
                                                                  col_rec_.contract, currency_code_, sale_price_, currency_rate_type_);
            Customer_Order_Pricing_API.Get_Base_Price_In_Currency(base_price_incl_tax_, base_currency_rate_, customer_no_,
                                                                  col_rec_.contract, currency_code_, sale_price_incl_tax_, currency_rate_type_);

            tax_code_     := Customer_Order_Inv_Item_API.Get_Vat_Code(company_, invoice_id_, invoice_item_id_);
            tax_class_id_ := NULL;
            IF NVL(price_conv_factor_, 0) = 0 THEN
               price_conv_factor_ := Customer_Order_Inv_Item_API.Get_Price_Conv_Factor(company_, invoice_id_, invoice_item_id_);
            END IF;
         ELSE
            -- Retrive price info from customer order line
            disc_                := col_rec_.discount;
            order_disc_          := col_rec_.order_discount;
            base_price_          := col_rec_.base_sale_unit_price;
            base_price_incl_tax_ := col_rec_.base_unit_price_incl_tax;
            sale_price_          := col_rec_.sale_unit_price;
            sale_price_incl_tax_ := col_rec_.unit_price_incl_tax;
            tax_code_            := col_rec_.tax_code;
            tax_class_id_        := col_rec_.tax_class_id;
            base_currency_rate_  := col_rec_.currency_rate;
            add_disc_            := col_rec_.additional_discount;
            IF NVL(price_conv_factor_, 0 ) = 0 THEN
               price_conv_factor_ := col_rec_.price_conv_factor;
            END IF;
         END IF;

         IF (invoice_no_ IS NOT NULL AND invoice_item_id_ IS NOT NULL) THEN
            line_disc_amount_ := Cust_Invoice_Item_Discount_API.Get_Total_Line_Discount(company_, invoice_id_, invoice_item_id_, qty_to_return_, price_conv_factor_, currency_rounding_);
         ELSE
            line_disc_amount_ := Cust_Order_Line_Discount_API.Get_Total_Line_Discount(order_no_,line_no_,rel_no_,line_item_no_, qty_to_return_, price_conv_factor_, currency_rounding_);
         END IF;

         IF (use_price_incl_tax_ = Fnd_Boolean_API.DB_TRUE) THEN
            -- line total incl tax in order currency
            sales_price_incl_tax_     := qty_to_return_ * price_conv_factor_ * sale_price_incl_tax_;
            add_disc_amount_          := ROUND((sales_price_incl_tax_ - line_disc_amount_) * (add_disc_/100),currency_rounding_);
            order_disc_amount_        := ROUND((sales_price_incl_tax_ - line_disc_amount_) * (order_disc_/100),currency_rounding_);
            sales_price_incl_tax_     := ROUND( sales_price_incl_tax_, currency_rounding_);
            line_total_incl_tax_curr_ := sales_price_incl_tax_ - line_disc_amount_ - add_disc_amount_ - order_disc_amount_;

            -- Modified calculation logic of line_total_incl_tax_base_. Discounts are stored in order currency and when multiple discounts are used,
            -- to avoid rounding errors and to tally with order currency total values,
            -- calculations are done using order currency and then final values are converted to base currency.
            line_total_incl_tax_base_  := ROUND(sales_price_incl_tax_ * base_currency_rate_, rounding_);

            IF (qty_to_return_ != 0) THEN
               sale_unit_price_incl_tax_      := line_total_incl_tax_curr_/(qty_to_return_ * price_conv_factor_);
               base_sale_unit_price_incl_tax_ := (sale_unit_price_incl_tax_ * base_currency_rate_);
            ELSE
               sale_unit_price_incl_tax_      := sale_price_incl_tax_;
               base_sale_unit_price_incl_tax_ := base_price_incl_tax_;
            END IF;
         ELSE
            -- line total in order currency
            sales_price_       := qty_to_return_ * price_conv_factor_ * sale_price_ ;
            add_disc_amount_   := ROUND((sales_price_ - line_disc_amount_) * (add_disc_/100),currency_rounding_);
            order_disc_amount_ := ROUND((sales_price_ - line_disc_amount_) * (order_disc_/100),currency_rounding_);
            sales_price_       := ROUND( sales_price_, currency_rounding_);
            line_total_curr_   := sales_price_ - line_disc_amount_ - add_disc_amount_ - order_disc_amount_;

            -- Modified calculation logic of line_total_incl_tax_base_. Discounts are stored in order currency and when multiple discounts are used,
            -- to avoid rounding errors and to tally with order currency total values,
            -- calculations are done using order currency and then final values are converted to base currency.
            line_total_base_   := ROUND(line_total_curr_ * base_currency_rate_, rounding_);


            IF (qty_to_return_ != 0) AND (line_disc_amount_ != 0 OR add_disc_amount_ != 0 OR order_disc_amount_ != 0) THEN
               sale_unit_price_      := line_total_curr_/(qty_to_return_ * price_conv_factor_);
               -- Modified calculation logic of base_sale_unit_price_.
               base_sale_unit_price_ := (sale_unit_price_ * base_currency_rate_);
            ELSE
               sale_unit_price_      := sale_price_;
               base_sale_unit_price_ := base_price_;
            END IF;
         END IF;

         discount_ := disc_;
      ELSE
         -- For rental returns, price is not considered.
         -- So assign them to zero.
         sale_unit_price_               := 0;
         base_sale_unit_price_          := 0;
         sale_unit_price_incl_tax_      := 0;
         base_sale_unit_price_incl_tax_ := 0;
         line_total_base_               := 0;
         line_total_curr_               := 0;
         discount_                      := 0;
         tax_code_                      := col_rec_.tax_code;
         price_conv_factor_             := 0;
      END IF;
      condition_code_ := col_rec_.condition_code;
   ELSE
      salerec_ := Sales_Part_API.Get (contract_, catalog_no_);
      IF (salerec_.part_no IS NOT NULL) THEN
         part_catalog_rec_ := Part_Catalog_API.Get(salerec_.part_no);
         
         --If the condition is not provided for condition code enabled inventory part, get the default conidtion code
         IF ((part_catalog_rec_.condition_code_usage = 'ALLOW_COND_CODE') AND (condition_code_ IS NULL)) THEN
            condition_code_ := Condition_Code_API.Get_Default_Condition_Code;
         END IF;
         IF (part_catalog_rec_.condition_code_usage = 'ALLOW_COND_CODE') THEN
            cond_code_price_exist_ := Condition_Code_Sale_Price_API.Exists(condition_code_, contract_, catalog_no_);
         END IF;
      END IF;

      -- For non inventory sales parts and for condition code disabled inventory sales parts, get the price from sales part record.
      IF (cond_code_price_exist_ = FALSE OR salerec_.part_no IS NULL) THEN
         base_price_          := 0;
         base_price_incl_tax_ := 0;
         sale_price_          := 0;
         sale_price_incl_tax_ := 0;
      ELSE
         cond_code_rec_ := Condition_Code_Sale_Price_API.Get(condition_code_, contract_, catalog_no_);
         IF (use_price_incl_tax_ = Fnd_Boolean_API.DB_TRUE ) THEN
            -- Convert condition code price into base price
            Customer_Order_Pricing_API.Get_Base_Price_In_Currency(base_price_incl_tax_, 
                                       sale_currency_rate_,
                                       customer_no_,
                                       contract_, 
                                       cond_code_rec_.currency_code, 
                                       NVL(cond_code_rec_.price_incl_tax, 0), 
                                       currency_rate_type_);
            --Convert base price into sales price                          
            Customer_Order_Pricing_API.Get_Sales_Price_In_Currency(sale_price_incl_tax_, 
                                                                   sale_currency_rate_, 
                                                                   customer_no_, 
                                                                   contract_, 
                                                                   currency_code_, 
                                                                   base_price_incl_tax_, 
                                                                   currency_rate_type_);
         ELSE
            -- Convert condition code price into base price
            
            Customer_Order_Pricing_API.Get_Base_Price_In_Currency(base_price_, 
                                       sale_currency_rate_,
                                       customer_no_,
                                       contract_, 
                                       cond_code_rec_.currency_code, 
                                       NVL(cond_code_rec_.price, 0), 
                                       currency_rate_type_);
            --Convert base price into sales price 
            Customer_Order_Pricing_API.Get_Sales_Price_In_Currency(sale_price_, 
                                                                   sale_currency_rate_, 
                                                                   customer_no_, 
                                                                   contract_, 
                                                                   currency_code_, 
                                                                   base_price_, 
                                                                   currency_rate_type_);
         END IF;
      END IF;

      base_sale_unit_price_          := base_price_;
      base_sale_unit_price_incl_tax_ := base_price_incl_tax_;
      sale_unit_price_               := sale_price_;
      sale_unit_price_incl_tax_      := sale_price_incl_tax_;

      -- Note: Always (re)fetch the Price Conv Factor value from sales part since it can never be changed manually in the client,
      IF (price_conv_factor_ IS NULL) OR (part_catalog_rec_.catch_unit_enabled = 'FALSE') THEN
         price_conv_factor_ := salerec_.price_conv_factor;
      END IF;
      line_total_base_          := ROUND(qty_to_return_ * price_conv_factor_ * base_sale_unit_price_, rounding_) ;
      line_total_incl_tax_base_ := ROUND(qty_to_return_ * price_conv_factor_ * base_sale_unit_price_incl_tax_, rounding_) ;
      line_total_curr_          := ROUND(qty_to_return_ * price_conv_factor_ * sale_unit_price_, currency_rounding_) ;
      line_total_incl_tax_curr_ := ROUND(qty_to_return_ * price_conv_factor_ * sale_unit_price_incl_tax_, currency_rounding_) ;
   END IF;
END Get_Price_Info;


-- Get_Part_Info
--   Gets the information related to the sales part. Called from client.
PROCEDURE Get_Part_Info (
   attr_         IN OUT VARCHAR2,
   contract_     IN     VARCHAR2,
   catalog_no_   IN     VARCHAR2,
   rma_no_       IN     NUMBER )
IS
   salerec_           Sales_Part_API.Public_Rec;
   catalog_desc_      RETURN_MATERIAL_LINE_TAB.catalog_desc%TYPE;
   rma_rec_           Return_Material_API.Public_Rec;
   customer_part_no_  VARCHAR2(45);
BEGIN
   Client_SYS.Clear_Attr(attr_);

   salerec_          := Sales_Part_API.Get(contract_, catalog_no_);
   rma_rec_          := Return_Material_API.Get(rma_no_);
   customer_part_no_ := Sales_Part_Cross_Reference_API.Get_Customer_Part_No(rma_rec_.customer_no, contract_, catalog_no_);
   IF (customer_part_no_ IS NOT NULL) THEN
      catalog_desc_ := Sales_Part_Cross_Reference_API.Get_Catalog_Desc(rma_rec_.customer_no, contract_, customer_part_no_);
   END IF;
   -- If there is no any sales part cross reference record for the sales part then description is taken from the sales part language description.
   IF (catalog_desc_ IS NULL) THEN
      catalog_desc_ := Sales_Part_API.Get_Catalog_Desc_For_Lang(contract_, catalog_no_, rma_rec_.language_code);
   END IF;

   Client_SYS.Add_To_Attr('CATALOG_DESC', catalog_desc_, attr_);
   Client_SYS.Add_To_Attr('CONV_FACTOR', salerec_.conv_factor, attr_);
   Client_SYS.Add_To_Attr('INVERTED_CONV_FACTOR', salerec_.inverted_conv_factor, attr_);
   Client_SYS.Add_To_Attr('SALES_UNIT', salerec_.sales_unit_meas, attr_);
   Client_SYS.Add_To_Attr('PART_NO', salerec_.part_no, attr_);
   Client_SYS.Add_To_Attr('TAXABLE', salerec_.taxable, attr_);
   Client_SYS.Add_To_Attr('DELIVERY_TYPE', salerec_.delivery_type, attr_);
   Client_SYS.Add_To_Attr('INVENTORY_UNIT', Inventory_Part_API.Get_Unit_Meas(contract_, salerec_.part_no), attr_);
END Get_Part_Info;


-- Get_Returned_Total_Base_Price
--   Returns the base price for all currently received material on a single
--   RMA Line. Takes discounts in to concideration.
@UncheckedAccess
FUNCTION Get_Returned_Total_Base_Price (
   rma_no_      IN NUMBER,
   rma_line_no_ IN NUMBER ) RETURN NUMBER
IS
   rounding_   NUMBER;
   rec_        RETURN_MATERIAL_LINE_TAB%ROWTYPE;
BEGIN
   rec_ := Get_Object_By_Keys___(rma_no_, rma_line_no_);

   rounding_ := Currency_Code_API.Get_Currency_Rounding(rec_.company, Company_Finance_API.Get_Currency_Code(rec_.company));

   RETURN ROUND((NVL(rec_.qty_returned_inv, 0) + NVL(rec_.qty_scrapped, 0)) * rec_.price_conv_factor * rec_.base_sale_unit_price, rounding_);
END Get_Returned_Total_Base_Price;


-- Get_Line_Total_Base_Price
--   Gets the total base price for the line.
--   If Price Including Tax setup is used then amount is calculated as Gross Amount in base currency - Tax Amount in base currency
--   If Price Including Tax setup is not used then amount is calculated as Net Amount in rma currency * currency rate
@UncheckedAccess
FUNCTION Get_Line_Total_Base_Price (
   rma_no_      IN NUMBER,
   rma_line_no_ IN NUMBER ) RETURN NUMBER
IS
   rec_             RETURN_MATERIAL_LINE_TAB%ROWTYPE;
   rounding_        NUMBER;
   line_total_base_ NUMBER;
BEGIN
   IF (Return_Material_API.Get_Use_Price_Incl_Tax_Db(rma_no_)  = 'TRUE') THEN
      line_total_base_ := Get_Total_Base_Price_Incl_Tax(rma_no_, rma_line_no_) - Get_Total_Tax_Amount_Base(rma_no_, rma_line_no_);
   ELSE
      rec_             := Get_Object_By_Keys___ (rma_no_, rma_line_no_);
      rounding_        := Currency_Code_API.Get_Currency_Rounding(rec_.company, Company_Finance_API.Get_Currency_Code(rec_.company));
      line_total_base_ := ROUND(Get_Line_Total_Price(rma_no_, rma_line_no_) * rec_.currency_rate, rounding_);
   END IF;

   RETURN line_total_base_;
END Get_Line_Total_Base_Price;


-- Get_Total_Base_Price_Incl_Tax
--   Gets the total base price incl tax for the line.
--   If Price Including Tax setup is used then amount is calculated as Gross Amount in rma currency * currency rate
--   If Price Including Tax setup is not used then amount is calculated as Net Amount in rma currency + Tax Amount in rma currency
@UncheckedAccess
FUNCTION Get_Total_Base_Price_Incl_Tax (
   rma_no_      IN NUMBER,
   rma_line_no_ IN NUMBER ) RETURN NUMBER
IS
   rec_             RETURN_MATERIAL_LINE_TAB%ROWTYPE;
   rounding_        NUMBER;
   line_gross_base_ NUMBER;
BEGIN
   IF (Return_Material_API.Get_Use_Price_Incl_Tax_Db(rma_no_)  = 'TRUE') THEN
      rec_             := Get_Object_By_Keys___ (rma_no_, rma_line_no_);
      rounding_        := Currency_Code_API.Get_Currency_Rounding(rec_.company, Company_Finance_API.Get_Currency_Code(rec_.company));
      line_gross_base_ := ROUND(Get_Line_Total_Price_Incl_Tax(rma_no_, rma_line_no_) * rec_.currency_rate, rounding_);
   ELSE
      line_gross_base_ := Get_Line_Total_Base_Price(rma_no_, rma_line_no_) + Get_Total_Tax_Amount_Base(rma_no_, rma_line_no_);
   END IF;

   RETURN line_gross_base_;
END Get_Total_Base_Price_Incl_Tax;


-- Get_Line_Total_Price
--   Gets the total price for the line in rma currency.
--   If Price Including Tax setup is used then amount is calculated as Gross Amount in rma currency - Tax Amount in rma currency
--   If Price Including Tax setup is not used then amount is calculated using values on the line
@UncheckedAccess
FUNCTION Get_Line_Total_Price (
   rma_no_      IN NUMBER,
   rma_line_no_ IN NUMBER ) RETURN NUMBER
IS
   rec_             RETURN_MATERIAL_LINE_TAB%ROWTYPE;
   rounding_        NUMBER;
   line_total_curr_ NUMBER;
   rma_rec_         Return_Material_API.Public_Rec;
BEGIN
   rma_rec_ := Return_Material_API.Get(rma_no_);
   IF (rma_rec_.use_price_incl_tax  = 'TRUE') THEN
      line_total_curr_ := Get_Line_Total_Price_Incl_Tax(rma_no_, rma_line_no_) - Get_Total_Tax_Amount_Curr(rma_no_, rma_line_no_);
   ELSE
      rec_             := Get_Object_By_Keys___ (rma_no_, rma_line_no_);
      rounding_        := Currency_Code_API.Get_Currency_Rounding(rec_.company, rma_rec_.currency_code);
      line_total_curr_ := ROUND(rec_.qty_to_return * rec_.price_conv_factor * rec_.sale_unit_price, rounding_);
   END IF;

   RETURN line_total_curr_;
END Get_Line_Total_Price;


-- Get_Line_Total_Price_Incl_Tax
--   Gets the total price incl tax for the line in rma currency.
--   If Price Including Tax setup is used then amount is calculated using values on the line
--   If Price Including Tax setup is not used then amount is calculated as Net Amount in rma currency + Tax Amount in rma currency
@UncheckedAccess
FUNCTION Get_Line_Total_Price_Incl_Tax (
   rma_no_      IN NUMBER,
   rma_line_no_ IN NUMBER ) RETURN NUMBER
IS
   rec_             RETURN_MATERIAL_LINE_TAB%ROWTYPE;
   rounding_        NUMBER;
   line_gross_curr_ NUMBER;
   rma_rec_         Return_Material_API.Public_Rec;
BEGIN
   rma_rec_ := Return_Material_API.Get(rma_no_);
   IF (rma_rec_.use_price_incl_tax  = 'TRUE') THEN
      rec_             := Get_Object_By_Keys___ (rma_no_, rma_line_no_);
      rounding_        := Currency_Code_API.Get_Currency_Rounding(rec_.company, rma_rec_.currency_code);
      line_gross_curr_ := ROUND(rec_.qty_to_return * rec_.price_conv_factor * rec_.unit_price_incl_tax, rounding_);
   ELSE
      line_gross_curr_ := Get_Line_Total_Price(rma_no_, rma_line_no_) + Get_Total_Tax_Amount_Curr(rma_no_, rma_line_no_);
   END IF;

   RETURN line_gross_curr_;
END Get_Line_Total_Price_Incl_Tax;


-- Modify_Cr_Invoice_Fields
--   Modifies the credit invoice fields on the line.
PROCEDURE Modify_Cr_Invoice_Fields (
   rma_no_             IN NUMBER,
   rma_line_no_        IN NUMBER,
   cr_invoice_no_      IN NUMBER,
   cr_invoice_item_no_ IN NUMBER )
IS
   oldrec_             RETURN_MATERIAL_LINE_TAB%ROWTYPE;
   newrec_             RETURN_MATERIAL_LINE_TAB%ROWTYPE;
   indrec_             Indicator_Rec;
   attr_               VARCHAR2(2000);
   objid_              VARCHAR2(2000);
   objversion_         VARCHAR2(2000);
   message_            VARCHAR2(2000);
   old_cr_invoice_no_  NUMBER;
   old_cr_inv_item_no_ NUMBER;
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('CREDIT_INVOICE_NO', cr_invoice_no_, attr_);
   Client_SYS.Add_To_Attr('CREDIT_INVOICE_ITEM_ID', cr_invoice_item_no_, attr_);
   oldrec_ := lock_by_keys___(rma_no_, rma_line_no_);

   old_cr_invoice_no_  := oldrec_.credit_invoice_no;
   old_cr_inv_item_no_ := oldrec_.credit_invoice_item_id;

   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE );

   IF (cr_invoice_no_ IS NOT NULL) THEN
      message_ := Language_SYS.Translate_Constant(lu_name_, 'RMALINECRED: Credit/Correction invoice :P1 item :P2 created for line :P3.',
                  p1_ =>  cr_invoice_no_, p2_ =>  cr_invoice_item_no_, p3_ =>  rma_line_no_);
      Return_Material_History_API.New(rma_no_, message_);
   ELSE
      message_ := Language_SYS.Translate_Constant(lu_name_, 'RMALINECREDREM: Credit/Correction invoice :P1 item :P2 was removed from line :P3.',
                  p1_ =>  old_cr_invoice_no_, p2_ =>  old_cr_inv_item_no_, p3_ =>  rma_line_no_);
      Return_Material_History_API.New(rma_no_, message_);
   END IF;

END Modify_Cr_Invoice_Fields;


-- Receive_Lines
--   Takes the RMA lines specified in the attribute string and makes them
--   Received, i.e. changes the qty_received to equal qty_to_return.
PROCEDURE Receive_Lines (
   attr_ IN OUT VARCHAR2 )
IS
   lines_added_ NUMBER := 0;
   ptr_         NUMBER := NULL;
   rma_no_      NUMBER;
   rma_line_no_ NUMBER;
   mod_attr_    VARCHAR2(200);
   oldrec_      RETURN_MATERIAL_LINE_TAB%ROWTYPE;
   newrec_      RETURN_MATERIAL_LINE_TAB%ROWTYPE;
   indrec_      Indicator_Rec;
   objid_       VARCHAR2(2000);
   objversion_  VARCHAR2(2000);
   name_        VARCHAR2(30);
   value_       VARCHAR2(2000);
   more_exists_ BOOLEAN;
BEGIN
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'RMA_NO') THEN
         rma_no_ := Client_SYS.Attr_Value_To_Number(value_);
      END IF;
      more_exists_ := Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_);
      IF (name_ = 'RMA_LINE_NO') THEN
         rma_line_no_ := Client_SYS.Attr_Value_To_Number(value_);
      END IF;

      IF (rma_no_ IS NOT NULL) AND (rma_line_no_ IS NOT NULL) THEN
         Trace_SYS.Field('Receiving RMA', to_char(rma_no_) || ' ' || to_char(rma_line_no_));

         oldrec_ := Lock_By_Keys___(rma_no_, rma_line_no_);
         Client_SYS.Clear_Attr(mod_attr_);
         Client_SYS.Add_To_Attr('QTY_RECEIVED', oldrec_.qty_to_return, mod_attr_);
         Client_SYS.Add_To_Attr('QTY_RECEIVED_INV_UOM', (oldrec_.qty_to_return * oldrec_.conv_factor/oldrec_.inverted_conv_factor), mod_attr_);
         Trace_SYS.Field('mod_attr_',mod_attr_);
         newrec_ := oldrec_;

         Unpack___(newrec_, indrec_, mod_attr_);
         Check_Update___(oldrec_, newrec_, indrec_, mod_attr_);
         Update___(objid_, oldrec_, newrec_, mod_attr_, objversion_, TRUE);

         lines_added_ := lines_added_ + 1;
      END IF;
      rma_no_ := NULL;
      rma_line_no_ := NULL;
   END LOOP;
   Client_SYS.Clear_Attr(attr_);
   Trace_SYS.Field('OK lined received:', lines_added_);
   Client_SYS.Add_To_Attr('OK lined received:', lines_added_, attr_);
END Receive_Lines;


-- Get_Sales_Unit_Meas
--   Get the sales unit of measure
@UncheckedAccess
FUNCTION Get_Sales_Unit_Meas (
   rma_no_      IN NUMBER,
   rma_line_no_ IN NUMBER ) RETURN VARCHAR2
IS
   order_no_      RETURN_MATERIAL_LINE_TAB.order_no%TYPE;
   line_no_       RETURN_MATERIAL_LINE_TAB.line_no%TYPE;
   rel_no_        RETURN_MATERIAL_LINE_TAB.rel_no%TYPE;
   line_item_no_  RETURN_MATERIAL_LINE_TAB.line_item_no%TYPE;
   contract_      RETURN_MATERIAL_LINE_TAB.contract%TYPE;
   catalog_no_    RETURN_MATERIAL_LINE_TAB.catalog_no%TYPE;
   temp_          VARCHAR2(10);

   CURSOR get_record IS
      SELECT order_no, line_no, rel_no, line_item_no, contract, catalog_no
      FROM   RETURN_MATERIAL_LINE_TAB
      WHERE  rma_no = rma_no_
      AND    rma_line_no = rma_line_no_;
BEGIN
   OPEN get_record;
   FETCH get_record INTO order_no_, line_no_, rel_no_, line_item_no_, contract_, catalog_no_;
   CLOSE get_record;

   IF (order_no_ IS NOT NULL) THEN
      --If the rma is connected to a customer order: Return sales unit meas from the customer order line
      temp_ := Customer_Order_Line_API.Get_Sales_Unit_Meas(order_no_, line_no_, rel_no_, line_item_no_);
   ELSE
      --If not connected: Return sales unit meas from sales part
      temp_ := Sales_Part_API.Get_Sales_Unit_Meas(contract_, catalog_no_);
   END IF;
   RETURN temp_;
END Get_Sales_Unit_Meas;


-- Check_Exch_Charge_Order
--   Checks if connected customer order line is a exchange order or a no charge line.
@UncheckedAccess
FUNCTION Check_Exch_Charge_Order (
   rma_no_      IN NUMBER,
   rma_line_no_ IN NUMBER ) RETURN VARCHAR2
IS
   order_no_      RETURN_MATERIAL_LINE_TAB.order_no%TYPE;
   line_no_       RETURN_MATERIAL_LINE_TAB.line_no%TYPE;
   rel_no_        RETURN_MATERIAL_LINE_TAB.rel_no%TYPE;
   line_item_no_  RETURN_MATERIAL_LINE_TAB.line_item_no%TYPE;
   order_rec_     Customer_Order_Line_API.public_rec;

   CURSOR get_order IS
      SELECT order_no, line_no, rel_no, line_item_no
      FROM   RETURN_MATERIAL_LINE_TAB
      WHERE  rma_no = rma_no_
      AND    rma_line_no = rma_line_no_;
BEGIN
   OPEN get_order;
   FETCH get_order INTO order_no_, line_no_, rel_no_, line_item_no_;
   CLOSE get_order;
   IF (order_no_ IS NOT NULL) THEN
      order_rec_ := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);
      IF (order_rec_.exchange_item = 'EXCHANGED ITEM') THEN
         RETURN 'TRUE';
      ELSIF (order_rec_.charged_item = 'ITEM NOT CHARGED') THEN
         RETURN 'TRUE';
      END IF;
   END IF;
   RETURN 'FALSE';
END Check_Exch_Charge_Order;


-- Check_Exch_Ord_Received
--   Checks if a order line is connected to a RMA line and whether that
--   RMA line has been received.
FUNCTION Check_Exch_Ord_Received (
   co_order_no_     IN VARCHAR2,
   co_line_no_      IN VARCHAR2,
   co_rel_no_       IN VARCHAR2,
   co_line_item_no_ IN NUMBER ) RETURN VARCHAR2
IS
   received_order_found_   VARCHAR2(5):= 'FALSE';
   dummy_                  NUMBER;

   CURSOR get_order_info IS
      SELECT 1
      FROM RETURN_MATERIAL_LINE_TAB
      WHERE order_no = co_order_no_
      AND   line_no = co_line_no_
      AND   rel_no = co_rel_no_
      AND   line_item_no = co_line_item_no_
      AND   rowstate NOT IN ('Planned', 'Denied', 'Released');
BEGIN
   OPEN get_order_info;
   FETCH get_order_info INTO dummy_;
   IF get_order_info%FOUND THEN
      received_order_found_ := 'TRUE';
   END IF;
   CLOSE get_order_info;
   RETURN received_order_found_;
END Check_Exch_Ord_Received;


-- Get_Total_Tax_Amount_Curr
--   To Get the Total Tax Amount in RMA currency
@UncheckedAccess
FUNCTION Get_Total_Tax_Amount_Curr (
   rma_no_      IN NUMBER,
   rma_line_no_ IN NUMBER ) RETURN NUMBER
IS
   line_rec_          RETURN_MATERIAL_LINE_TAB%ROWTYPE;
   tax_amount_        NUMBER := 0;
   rounding_          NUMBER;
   company_           VARCHAR2(20);   
   
BEGIN
   line_rec_ := Get_Object_By_Keys___(rma_no_, rma_line_no_);
   company_  := Site_API.Get_Company(line_rec_.contract);
   rounding_ := Currency_Code_API.Get_Currency_Rounding(company_, Return_Material_API.Get_Currency_Code(rma_no_));
      
   IF (Get_Tax_Liability_Type_Db(rma_no_, rma_line_no_) = 'EXM') THEN
      -- No tax paid for this order line
      tax_amount_ := 0;
   ELSE
      tax_amount_ := Source_Tax_Item_API.Get_Total_Tax_Curr_Amount(company_, 
                                                                   Tax_Source_API.DB_RETURN_MATERIAL_LINE,
                                                                   TO_CHAR(rma_no_),
                                                                   TO_CHAR(rma_line_no_),
                                                                   '*',
                                                                   '*',
                                                                   '*');
   END IF;
   
   tax_amount_ := ROUND(tax_amount_, rounding_);
   RETURN NVL(tax_amount_, 0);
END Get_Total_Tax_Amount_Curr;


-- Get_Total_Tax_Amount_Base
--   To Get the Total Tax Amount in base currency
@UncheckedAccess
FUNCTION Get_Total_Tax_Amount_Base (
   rma_no_      IN NUMBER,
   rma_line_no_ IN NUMBER ) RETURN NUMBER
IS
   line_rec_   RETURN_MATERIAL_LINE_TAB%ROWTYPE;
   tax_amount_ NUMBER := 0;
   rounding_   NUMBER;
   company_    VARCHAR2(20);

BEGIN
   line_rec_ := Get_Object_By_Keys___(rma_no_, rma_line_no_);
   company_  := line_rec_.company;

   IF (Get_Tax_Liability_Type_Db(rma_no_, rma_line_no_) = 'EXM') THEN
      -- No tax paid for this order line
      tax_amount_ := 0;
   ELSE
      tax_amount_ := Source_Tax_Item_API.Get_Total_Tax_Dom_Amount(company_, 
                                                                  Tax_Source_API.DB_RETURN_MATERIAL_LINE,
                                                                  TO_CHAR(rma_no_),
                                                                  TO_CHAR(rma_line_no_),
                                                                  '*',
                                                                  '*',
                                                                  '*');

      rounding_   := Currency_Code_API.Get_Currency_Rounding(line_rec_.company, Company_Finance_API.Get_Currency_Code(line_rec_.company));
      tax_amount_ := ROUND(tax_amount_, rounding_);
   END IF;

   RETURN NVL(tax_amount_, 0);
END Get_Total_Tax_Amount_Base;


-- New
--   Public interface for creating a new RMA Line.
PROCEDURE New (
   info_ OUT    VARCHAR2,
   attr_ IN OUT VARCHAR2 )
IS  
   indrec_                        Indicator_Rec;
   new_attr_                      VARCHAR2(32000);   
   newrec_                        RETURN_MATERIAL_LINE_TAB%ROWTYPE;
   objid_                         RETURN_MATERIAL_LINE.objid%TYPE;
   objversion_                    RETURN_MATERIAL_LINE.objversion%TYPE;      
BEGIN
   Build_Attr_For_New___(new_attr_, attr_);

   Unpack___(newrec_, indrec_, new_attr_);
   Check_Insert___(newrec_, indrec_, new_attr_);
   Insert___(objid_, objversion_, newrec_, new_attr_);

   info_ := Client_SYS.Get_All_Info;
   attr_ := new_attr_;
END New;


-- Modify_Db_Invoice_Info
--   This will modify the debit invoice number and the debit invoice series id of the given RMA Line.
PROCEDURE Modify_Db_Invoice_Info (
   rma_no_           IN NUMBER,
   rma_line_no_      IN NUMBER,
   db_invoice_no_    IN VARCHAR2,
   db_inv_series_id_ IN VARCHAR2 )
IS
   oldrec_     RETURN_MATERIAL_LINE_TAB%ROWTYPE;
   newrec_     RETURN_MATERIAL_LINE_TAB%ROWTYPE;
   indrec_     Indicator_Rec;
   attr_       VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);

BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('DEBIT_INVOICE_NO', db_invoice_no_, attr_);
   Client_SYS.Add_To_Attr('DEBIT_INVOICE_SERIES_ID', db_inv_series_id_, attr_);
   oldrec_ := lock_by_keys___(rma_no_, rma_line_no_);
   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE );
END Modify_Db_Invoice_Info;

-- Get_Inv_Connected_Rma_Line_No
--   This method  will return the RMA line number connected
--   for a given reference invoice number and item id.
--   This method will only be used when creting correction invoices.
--   Because in other situations there can be more than one
--   rma lines connected to same item id
@UncheckedAccess
FUNCTION Get_Inv_Connected_Rma_Line_No(
   rma_no_              IN NUMBER,
   company_             IN VARCHAR2,
   ref_invoice_no_      IN VARCHAR2,
   ref_invoice_item_id_ IN NUMBER,
   series_id_           IN VARCHAR2 DEFAULT NULL) RETURN NUMBER
IS
   temp_ RETURN_MATERIAL_LINE_TAB.rma_line_no%TYPE;
   CURSOR get_attr IS
      SELECT rma_line_no
        FROM RETURN_MATERIAL_LINE_TAB
       WHERE rma_no = rma_no_
         AND company = company_
         AND debit_invoice_no = ref_invoice_no_
         AND debit_invoice_item_id = ref_invoice_item_id_
         AND (debit_invoice_series_id = series_id_ OR series_id_ IS NULL)
         AND credit_approver_id IS NOT NULL;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END  Get_Inv_Connected_Rma_Line_No;


-- Return_Lot_Serial_Allowed
--   Check and out the validity of the returning quantity on the lot batch and serial, based on the customer order information connected to the RMA Line.
PROCEDURE Return_Lot_Serial_Allowed (
   lot_serial_qty_allowed_ OUT VARCHAR2,
   poss_lot_qty_to_return_ OUT NUMBER,
   rma_no_                 IN  NUMBER,
   rma_line_no_            IN  NUMBER,
   lot_batch_no_           IN  VARCHAR2,
   serial_no_              IN  VARCHAR2,
   eng_chg_level_          IN  VARCHAR2,
   qty_to_return_          IN  NUMBER )
IS
   rec_          Public_Rec;
   ordrow_rec_   Customer_Order_Line_API.Public_Rec;
   qty_issued_   NUMBER := 0;
   qty_returned_ NUMBER := 0;
   qty_scrapped_ NUMBER := 0;
   orignating_rma_rec_              Public_Rec;
   in_transit_destination_site_     RETURN_MATERIAL_LINE_TAB.contract%TYPE; 
   contract_                        RETURN_MATERIAL_LINE_TAB.contract%TYPE;                           

   CURSOR get_rma_for_order (order_no_ IN VARCHAR2, line_no_ IN VARCHAR2, rel_no_ IN VARCHAR2, line_item_no_ IN  NUMBER)IS
      SELECT DISTINCT(rma_no), rma_line_no
      FROM RETURN_MATERIAL_LINE_TAB
      WHERE order_no = order_no_
      AND line_no = line_no_
      AND rel_no =  rel_no_
      AND line_item_no = line_item_no_;
BEGIN
   rec_                    := Get(rma_no_, rma_line_no_);
   lot_serial_qty_allowed_ := 'TRUE';
   poss_lot_qty_to_return_ := qty_to_return_;

   IF (rec_.order_no IS NOT NULL) THEN
      ordrow_rec_ := Customer_Order_Line_API.Get(rec_.order_no, rec_.line_no, rec_.rel_no, rec_.line_item_no);
      
      IF (serial_no_ != '*') THEN
         IF NOT (ordrow_rec_.supply_code = 'PD' AND Part_Catalog_API.Get_Stop_New_Serial_In_Rma_Db(rec_.part_no) = 'FALSE') THEN
            Part_Serial_Catalog_API.Exist(rec_.part_no, serial_no_);
         END IF;
         
         -- Added conditions to check if the serial is in transit and if so not to allow it for scrapping or recieving into inventory.          
         in_transit_destination_site_  := Inventory_Part_In_Transit_API.Get_Serial_Destination_Site(rec_.part_no, serial_no_);
         
         IF (in_transit_destination_site_ IS NOT NULL ) THEN            
            -- fetching the site if it is a three site intersite flow
            IF (rec_.originating_rma_line_no IS NOT NULL ) THEN
               orignating_rma_rec_     := Get(Return_Material_API.Get_Originating_Rma_No(rma_no_), rec_.originating_rma_line_no);
               contract_               := orignating_rma_rec_.contract;               
            -- fetching the site if it is a two site intersite flow
            ELSE
               contract_               := rec_.contract;
            END IF;
            
            -- the comparisoin to ensure that the transit is pointing towards the correct destination site
            -- if not trigger the error and prevent it from being returned via the RMA.
            IF (contract_ != in_transit_destination_site_ ) THEN
               Error_SYS.Record_General(lu_name_, 'SPLITSERINV: Serial :P1 already exists on a specific stock, transit or at customer record.', rec_.part_no||','||serial_no_);
            END IF;
         END IF;
      END IF;

      IF (ordrow_rec_.supply_code != 'SEO') THEN
         qty_issued_ := Inventory_Transaction_Hist_API.Get_Sum_Quantity(rec_.order_no,
                                                                        rec_.line_no,
                                                                        rec_.rel_no,
                                                                        rec_.line_item_no,
                                                                        'CUST ORDER',
                                                                        lot_batch_no_,
                                                                        serial_no_,
                                                                        eng_chg_level_,
                                                                        'ISSUE');

         FOR rma_rec_ IN get_rma_for_order(rec_.order_no, rec_.line_no, rec_.rel_no, rec_.line_item_no) LOOP
            qty_returned_  := qty_returned_ +
                               Inventory_Transaction_Hist_API.Get_Sum_Quantity(rma_rec_.rma_no,
                                                                               NULL,
                                                                               NULL,
                                                                               rma_rec_.rma_line_no,
                                                                               'RMA',
                                                                               lot_batch_no_,
                                                                               serial_no_,
                                                                               eng_chg_level_,
                                                                               'REVERSED ISSUE');
            qty_scrapped_ := qty_scrapped_ +
                              Return_Material_Scrap_API.Get_Sum_Qty_Scrapped(rma_rec_.rma_no,
                                                                             rma_rec_.rma_line_no,
                                                                             serial_no_,
                                                                             lot_batch_no_,
                                                                             eng_chg_level_);
         END LOOP;

         poss_lot_qty_to_return_ := qty_issued_ - qty_returned_ - qty_scrapped_;

         IF poss_lot_qty_to_return_ < 0 THEN
            poss_lot_qty_to_return_ := 0;
         END IF;

         IF (poss_lot_qty_to_return_ != 0 AND (poss_lot_qty_to_return_ >= qty_to_return_)) THEN
            lot_serial_qty_allowed_ := 'TRUE';
         ELSE
            lot_serial_qty_allowed_ := 'FALSE';
         END IF;
      END IF;
   END IF;
END Return_Lot_Serial_Allowed;


-- Get_Ivc_Line_Data
--   Fetches the possible quantity to return from the specified Debit Invoice.
@UncheckedAccess
PROCEDURE Get_Ivc_Line_Data (
   attr_         OUT VARCHAR2,
   order_no_     IN  VARCHAR2,
   line_no_      IN  VARCHAR2,
   rel_no_       IN  VARCHAR2,
   line_item_no_ IN  NUMBER,
   invoice_no_   IN  VARCHAR2,
   invoice_id_   IN  NUMBER,
   series_id_    IN  VARCHAR2,
   company_      IN  VARCHAR2,
   rma_no_       IN  NUMBER,
   rma_line_no_  IN  NUMBER )
IS
   ivc_qty_to_return_      NUMBER;
   poss_qty_to_return_     NUMBER;
   co_line_qty_to_return_  NUMBER;
   total_ivc_qty_returned_ NUMBER;
   ivc_id_                 NUMBER;
   invoice_item_id_        NUMBER;
   inv_line_rec_           Customer_Order_Inv_Item_API.Public_Rec;

   CURSOR get_ivc_qty_returned IS
      SELECT SUM(qty_to_return)
      FROM RETURN_MATERIAL_LINE_TAB
      WHERE order_no                = order_no_
      AND line_no                 = line_no_
      AND rel_no                  = rel_no_
      AND line_item_no            = line_item_no_
      AND debit_invoice_no        = invoice_no_
      AND debit_invoice_series_id = series_id_
      AND company                 = company_
      AND rowstate NOT IN ('Denied', 'Cancelled')
      AND ((rma_line_no_ IS NULL) OR ((rma_line_no_ IS NOT NULL) AND (rma_no != rma_no_)));
BEGIN
   -- Note: Possible qty to return on order line.
   Get_Co_Line_Data(attr_, order_no_, line_no_, rel_no_, line_item_no_, rma_no_, rma_line_no_);
   co_line_qty_to_return_ := Client_SYS.Get_Item_Value('POSS_QTY_TO_RETURN', attr_);

   IF (invoice_id_ IS NOT NULL) THEN
      ivc_id_ := invoice_id_;
   ELSIF (invoice_id_ IS NULL) AND (invoice_no_ IS NOT NULL) AND (series_id_ IS NOT NULL) AND (company_ IS NOT NULL) THEN
      ivc_id_ := Customer_Order_Inv_Head_API.Get_Invoice_Id_By_No(company_, invoice_no_, series_id_);
   END IF;

   OPEN get_ivc_qty_returned;
   FETCH get_ivc_qty_returned INTO total_ivc_qty_returned_;
   CLOSE get_ivc_qty_returned;

   total_ivc_qty_returned_ := NVL(total_ivc_qty_returned_,0);
   -- Note: Possible qty to return on debit invoice.
   ivc_qty_to_return_ := Customer_Order_Inv_Item_API.Get_Invoiced_Qty(ivc_id_ , order_no_, line_no_, rel_no_, line_item_no_);
   ivc_qty_to_return_ := ivc_qty_to_return_ - total_ivc_qty_returned_;

   IF (ivc_qty_to_return_ < 0) THEN
      ivc_qty_to_return_ := 0;
   END IF;
   poss_qty_to_return_ := LEAST(ivc_qty_to_return_, co_line_qty_to_return_);
   Client_SYS.Set_Item_Value('POSS_QTY_TO_RETURN', poss_qty_to_return_, attr_);
   invoice_item_id_    := Customer_Order_Inv_Item_API.Get_Item_Id(ivc_id_, order_no_, line_no_, rel_no_, line_item_no_);
   inv_line_rec_       := Customer_Order_Inv_Item_API.Get(company_, ivc_id_, invoice_item_id_);
   Client_SYS.Set_Item_Value('DELIVERY_TYPE', inv_line_rec_.deliv_type_id, attr_);
END Get_Ivc_Line_Data;


-- Check_Exist_Rma_For_Order_Line
--   Returns 'FALSE' if there are no Return Material Lines for the given Customer
--   Order Line. Returns 'TRUE' otherwise.
@UncheckedAccess
FUNCTION Check_Exist_Rma_For_Order_Line (
   order_no_       IN VARCHAR2,
   line_no_        IN VARCHAR2,
   rel_no_         IN VARCHAR2,
   line_item_no_   IN NUMBER ) RETURN VARCHAR2
IS
   dummy_ NUMBER;

   CURSOR get_rma_lines IS
      SELECT 1
      FROM RETURN_MATERIAL_LINE_TAB
      WHERE  order_no = order_no_
        AND  line_no  = line_no_
        AND  rel_no   = rel_no_
        AND  line_item_no >= 0;
BEGIN
   OPEN  get_rma_lines;
   FETCH get_rma_lines INTO dummy_;
   IF NOT get_rma_lines%FOUND THEN
      CLOSE get_rma_lines;
      RETURN 'FALSE';
   END IF;
   CLOSE get_rma_lines;
   RETURN 'TRUE';
END Check_Exist_Rma_For_Order_Line;

-- Check_Active_Rma_For_Ord_Line
--   Returns 'FALSE' if there are no Not Cancelled Return Material Lines 
--   for the given Customer Order Line. Returns 'TRUE' otherwise.
@UncheckedAccess
FUNCTION Check_Active_Rma_For_Ord_Line (
   order_no_       IN VARCHAR2,
   line_no_        IN VARCHAR2,
   rel_no_         IN VARCHAR2,
   line_item_no_   IN NUMBER ) RETURN VARCHAR2
IS
   dummy_ NUMBER;

   CURSOR get_rma_lines IS
      SELECT 1
      FROM RETURN_MATERIAL_LINE_TAB
      WHERE  order_no      = order_no_
        AND  line_no       = line_no_
        AND  rel_no        = rel_no_
        AND  line_item_no  = line_item_no_
        AND  rowstate     != 'Cancelled';
BEGIN
   OPEN  get_rma_lines;
   FETCH get_rma_lines INTO dummy_;
   IF NOT get_rma_lines%FOUND THEN
      CLOSE get_rma_lines;
      RETURN 'FALSE';
   END IF;
   CLOSE get_rma_lines;
   RETURN 'TRUE';
END Check_Active_Rma_For_Ord_Line;

@UncheckedAccess
FUNCTION Check_Not_Invoiced_Rma_Lines (   
   order_no_               IN VARCHAR2,
   line_no_                IN VARCHAR2,
   rel_no_                 IN VARCHAR2 ) RETURN VARCHAR2
IS     
   dummy_ NUMBER;
   
   CURSOR get_not_invoiced_lines IS
      SELECT 1
        FROM RETURN_MATERIAL_LINE_TAB
       WHERE  order_no = order_no_
         AND  line_no  = line_no_
         AND  rel_no   = rel_no_
         AND  line_item_no >= 0
         AND  rowstate != 'Cancelled'
         AND  debit_invoice_no IS NULL;
BEGIN
   OPEN  get_not_invoiced_lines;
   FETCH get_not_invoiced_lines INTO dummy_;
   IF get_not_invoiced_lines%FOUND THEN
      CLOSE get_not_invoiced_lines;
      RETURN 'TRUE';
   END IF;
   CLOSE get_not_invoiced_lines;
   RETURN 'FALSE';
END Check_Not_Invoiced_Rma_Lines;

-- Enable_Abnormal_Demand
--   Enable abnormal demand in return material lines for the given customer
--   order line.
PROCEDURE Enable_Abnormal_Demand (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER )
IS
   CURSOR get_data IS
      SELECT rma_no, rma_line_no
        FROM RETURN_MATERIAL_LINE_TAB
       WHERE order_no     = order_no_
         AND line_no      = line_no_
         AND rel_no       = rel_no_
         AND line_item_no = line_item_no_;
BEGIN
   FOR rec_ IN get_data LOOP
      Inventory_Transaction_Hist_API.Enable_Abnormal_Demand(rec_.rma_no,
                                                            NULL,
                                                            NULL,
                                                            rec_.rma_line_no,
                                                            'RMA');
   END LOOP;
END Enable_Abnormal_Demand;


-- Disable_Abnormal_Demand
--   Disable abnormal demand in return material lines for the given customer
--   Order Line.
PROCEDURE Disable_Abnormal_Demand (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER )
IS
   CURSOR get_data IS
      SELECT rma_no, rma_line_no
        FROM RETURN_MATERIAL_LINE_TAB
       WHERE order_no     = order_no_
         AND line_no      = line_no_
         AND rel_no       = rel_no_
         AND line_item_no = line_item_no_;
BEGIN
   FOR rec_ IN get_data LOOP
      Inventory_Transaction_Hist_API.Disable_Abnormal_Demand(rec_.rma_no,
                                                             NULL,
                                                             NULL,
                                                             rec_.rma_line_no,
                                                             'RMA');
   END LOOP;
END Disable_Abnormal_Demand;


-- Cal_Qty_To_Return_Sales_Uom
--   Returns the qty_to_return from this function.
--   Calculates the  qty to return for a given CO Line.
@UncheckedAccess
FUNCTION Cal_Qty_To_Return_Sales_Uom(
   rma_no_       IN VARCHAR2,
   rma_line_no_  IN NUMBER,
   id_no_        IN VARCHAR2,
   flag_type_    IN VARCHAR2,
   contract_     IN VARCHAR2,
   catalog_no_   IN VARCHAR2,
   series_id_    IN VARCHAR2,
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN NUMBER
IS
   attr_               VARCHAR2(2000);
   poss_qty_to_return_ NUMBER;
   rma_rec_            Return_Material_API.Public_Rec;   
BEGIN
   rma_rec_     := Return_Material_API.Get(rma_no_);
  
   Get_Co_Line_Info (attr_,
                     id_no_,
                     flag_type_,
                     contract_,
                     catalog_no_,
                     rma_rec_.customer_no,
                     rma_rec_.currency_code,
                     series_id_,
                     order_no_,
                     line_no_,
                     rel_no_,
                     line_item_no_,
                     rma_no_,
                     rma_line_no_,
                     rma_rec_.shipment_id);

    poss_qty_to_return_ := Client_SYS.Get_Item_Value('POSS_QTY_TO_RETURN', attr_);
    RETURN poss_qty_to_return_;
END Cal_Qty_To_Return_Sales_Uom;


-- Cal_Qty_To_Return_Sales_Uom
--   Returns the qty_to_return from this function.
--   Calculates the  qty to return for a given CO Line.
@UncheckedAccess
FUNCTION Cal_Qty_To_Return_Sales_Uom (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN NUMBER
IS
   order_rec_                CUSTOMER_ORDER_LINE_API.Public_Rec;
   total_col_qty_to_return_  NUMBER;
   qty_to_return_            NUMBER;

   CURSOR get_total_qty_to_return IS
      SELECT SUM(qty_received)
      FROM  RETURN_MATERIAL_LINE_TAB
      WHERE order_no     = order_no_
      AND   line_no      = line_no_
      AND   rel_no       = rel_no_
      AND   line_item_no = line_item_no_
      AND   rowstate NOT IN ('Denied', 'Cancelled');
BEGIN
   order_rec_ := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);

   OPEN get_total_qty_to_return;
   FETCH get_total_qty_to_return INTO total_col_qty_to_return_;
   CLOSE get_total_qty_to_return;

   qty_to_return_ := (order_rec_.qty_shipped / order_rec_.conv_factor * order_rec_.inverted_conv_factor) - NVL(total_col_qty_to_return_, 0);

   RETURN NVL(qty_to_return_, 0);
END Cal_Qty_To_Return_Sales_Uom;


-- Cal_Qty_To_Return_Inv_Uom
--   Returns the qty_to_return_inv_uom_ from this function.
@UncheckedAccess
FUNCTION Cal_Qty_To_Return_Inv_Uom(
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER) RETURN NUMBER
IS
   order_rec_                CUSTOMER_ORDER_LINE_API.Public_Rec;
   qty_to_return_inv_uom_    NUMBER;
   qty_to_return_            NUMBER;
   tot_qty_returned_inv_uom_ NUMBER;
   tot_qty_returned_         NUMBER;

   CURSOR get_tot_qty_returned_inv_uom IS
      SELECT SUM(qty_to_return), SUM(qty_to_return_inv_uom)
      FROM RETURN_MATERIAL_LINE_TAB
      WHERE order_no     = order_no_
      AND line_no      = line_no_
      AND rel_no       = rel_no_
      AND line_item_no = line_item_no_
      AND rowstate NOT IN ('Denied', 'Cancelled');
BEGIN
   order_rec_ := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);

   OPEN get_tot_qty_returned_inv_uom;
   FETCH get_tot_qty_returned_inv_uom INTO tot_qty_returned_, tot_qty_returned_inv_uom_;
   CLOSE get_tot_qty_returned_inv_uom;

   qty_to_return_ := (order_rec_.qty_shipped / order_rec_.conv_factor * order_rec_.inverted_conv_factor) - NVL(tot_qty_returned_, 0);

   IF (qty_to_return_ != 0) THEN
      qty_to_return_inv_uom_ := order_rec_.qty_shipped - NVL(tot_qty_returned_inv_uom_, 0);
   END IF;

   RETURN NVL(qty_to_return_inv_uom_, 0);
END Cal_Qty_To_Return_Inv_Uom;

@UncheckedAccess
FUNCTION Cal_Ship_Qty_To_Return_Inv_Uom (
   order_no_     IN  VARCHAR2,
   line_no_      IN  VARCHAR2,
   rel_no_       IN  VARCHAR2,
   line_item_no_ IN  NUMBER,
   shipment_id_  IN  NUMBER ) RETURN NUMBER
IS
   order_rec_                CUSTOMER_ORDER_LINE_API.Public_Rec;
   ship_line_qty_shipped_    NUMBER;
   qty_to_return_inv_uom_    NUMBER;
   qty_to_return_            NUMBER;
   tot_qty_returned_inv_uom_ NUMBER;
   tot_qty_returned_         NUMBER;

   CURSOR get_tot_ship_qty_ret_inv_uom IS
      SELECT SUM(qty_to_return), SUM(qty_to_return_inv_uom)
      FROM RETURN_MATERIAL_LINE_TAB rml, RETURN_MATERIAL_TAB rma
      WHERE rml.order_no     = order_no_
      AND rml.line_no      = line_no_
      AND rml.rel_no       = rel_no_
      AND rml.line_item_no = line_item_no_
      AND rml.rma_no       = rma.rma_no
      AND rma.shipment_id  = shipment_id_
      AND rml.rowstate NOT IN ('Denied', 'Cancelled');
BEGIN
   order_rec_    := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);
   OPEN get_tot_ship_qty_ret_inv_uom;
   FETCH get_tot_ship_qty_ret_inv_uom INTO tot_qty_returned_, tot_qty_returned_inv_uom_;
   CLOSE get_tot_ship_qty_ret_inv_uom;
   
   ship_line_qty_shipped_ := Shipment_Line_API.Get_Qty_Shipped_By_Source(shipment_id_,order_no_, line_no_,
                                                                         rel_no_, line_item_no_, Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER);
   qty_to_return_         := (ship_line_qty_shipped_/ order_rec_.conv_factor * order_rec_.inverted_conv_factor) - NVL(tot_qty_returned_, 0);
   IF (qty_to_return_ != 0) THEN
      qty_to_return_inv_uom_ := ship_line_qty_shipped_ - NVL(tot_qty_returned_inv_uom_, 0);
   END IF;

   RETURN NVL(qty_to_return_inv_uom_, 0);
END Cal_Ship_Qty_To_Return_Inv_Uom;

-- Modify_Tax_Class_Id
--   Modifies the tax class id when the tax code is changed from the
--   RMA Tax Lines dialog
PROCEDURE Modify_Tax_Class_Id (
   attr_        IN OUT VARCHAR2,
   rma_no_      IN     NUMBER,
   rma_line_no_ IN     NUMBER )
IS
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   oldrec_     RETURN_MATERIAL_LINE_TAB%ROWTYPE;
   newrec_     RETURN_MATERIAL_LINE_TAB%ROWTYPE;
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, rma_no_, rma_line_no_);
   oldrec_              := Lock_By_Id___(objid_, objversion_);
   newrec_              := oldrec_;
   newrec_.tax_class_id := Client_Sys.Get_Item_Value('TAX_CLASS_ID', attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_);
END Modify_Tax_Class_Id;


@UncheckedAccess
FUNCTION Get_Delivery_Country_Code (
   rma_no_      IN NUMBER,
   rma_line_no_ IN NUMBER ) RETURN VARCHAR2
IS
   order_no_               RETURN_MATERIAL_LINE_TAB.order_no%TYPE;
   line_no_                RETURN_MATERIAL_LINE_TAB.order_no%TYPE;
   rel_no_                 RETURN_MATERIAL_LINE_TAB.order_no%TYPE;
   line_item_no_           RETURN_MATERIAL_LINE_TAB.order_no%TYPE;
   delivery_country_code_  RETURN_MATERIAL_LINE.delivery_country_code%TYPE;
   rma_rec_                Return_Material_API.Public_Rec;

   CURSOR get_order_info IS
      SELECT order_no, line_no, rel_no, line_item_no
      FROM RETURN_MATERIAL_LINE_TAB
      WHERE  rma_no = rma_no_
      AND    rma_line_no = rma_line_no_;
BEGIN
   OPEN get_order_info;
   FETCH get_order_info INTO order_no_, line_no_, rel_no_, line_item_no_;
   CLOSE get_order_info;
   
   rma_rec_ := Return_Material_API.Get(rma_no_);
   IF (order_no_ IS NULL) THEN
      IF (rma_rec_.Ship_Addr_Flag = 'N') THEN
         delivery_country_code_ := Return_Material_API.Get_Ship_Addr_Country(rma_no_);
      ELSE
         delivery_country_code_ := rma_rec_.ship_addr_country_code;
      END IF;
   ELSE
      delivery_country_code_ := Cust_Order_Line_Address_API.Get_Country_Code(order_no_, line_no_, rel_no_, line_item_no_);
   END IF;

   RETURN delivery_country_code_;
END Get_Delivery_Country_Code;


-- Set_Cancel_Reason
--   Updates the value of CANCEL_REASON for the RMA line with the passed in value.
PROCEDURE Set_Cancel_Reason (
   rma_no_        IN NUMBER,
   rma_line_no_   IN NUMBER,
   cancel_reason_ IN VARCHAR2  )
IS
   attr_         VARCHAR2(2000);
   objid_        RETURN_MATERIAL_LINE.objid%TYPE;
   objversion_   RETURN_MATERIAL_LINE.objversion%TYPE;
   oldrec_       RETURN_MATERIAL_LINE_TAB%ROWTYPE;
   newrec_       RETURN_MATERIAL_LINE_TAB%ROWTYPE;
   indrec_       Indicator_Rec;
BEGIN

   Get_Id_Version_By_Keys___(objid_, objversion_, rma_no_, rma_line_no_);
   oldrec_ := Lock_By_Id___(objid_, objversion_);
   newrec_ := oldrec_;
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Set_Item_Value('CANCEL_REASON', cancel_reason_, attr_);
   Unpack___(newrec_, indrec_, attr_);
   IF oldrec_.originating_rma_line_no IS NOT NULL THEN
     Client_SYS.Add_To_Attr('BYPASS_USER_ALLOWED_SITE', 'TRUE', attr_);
   END IF;
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_);
END Set_Cancel_Reason;


-- Cancel_Line
--   This is to perform the Cancel event and pass it to the finite state machine for processing.
PROCEDURE Cancel_Line (
   info_          OUT VARCHAR2,
   rma_no_        IN  NUMBER,
   rma_line_no_   IN  NUMBER )
IS
   attr_         VARCHAR2(32000);
   objid_        RETURN_MATERIAL_LINE.objid%TYPE;
   objversion_   RETURN_MATERIAL_LINE.objversion%TYPE;
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, rma_no_, rma_line_no_);
   Cancel__(info_, objid_, objversion_, attr_,'DO');
END Cancel_Line;


-- Get_Supplier_Rtn_Reason
--   Return the return reason code of the first receipt of the given demand order.
--   This is to retrieve return reason code for direct return to external supplier.
@UncheckedAccess
FUNCTION Get_Supplier_Rtn_Reason (
   rma_no_      IN NUMBER,
   rma_line_no_ IN NUMBER ) RETURN VARCHAR2
IS
   purchase_return_reason_  VARCHAR2(8);
   line_rec_                RETURN_MATERIAL_LINE_TAB%ROWTYPE;
   order_rec_               CUSTOMER_ORDER_LINE_API.Public_Rec;
BEGIN
   line_rec_  := Get_Object_By_Keys___(rma_no_, rma_line_no_);
   order_rec_ := Customer_Order_Line_API.Get(line_rec_.order_no, line_rec_.line_no, line_rec_.rel_no, line_rec_.line_item_no);

   $IF Component_Purch_SYS.INSTALLED $THEN
       purchase_return_reason_ := Receipt_Return_API.Get_Default_Receipt_Rtn_Reason(order_rec_.demand_order_ref1, 
                                                                                    order_rec_.demand_order_ref2, 
                                                                                    order_rec_.demand_order_ref3,
                                                                                    NULL,
                                                                                    Logistics_Source_Ref_Type_API.DB_PURCHASE_ORDER);
   $ELSE
       NULL;
   $END

   RETURN purchase_return_reason_;
END  Get_Supplier_Rtn_Reason;


-- Check_Return_To_Delivered_Sup
--   This method which checks whether the materials are returned to the same supplier 
--   who delivered goods through the purchase order connected to the CO line.
@UncheckedAccess
FUNCTION Check_Return_To_Delivered_Sup (
   rma_no_       IN NUMBER,
   rma_line_no_  IN NUMBER ) RETURN BOOLEAN
IS
   rma_rec_              Return_Material_API.Public_Rec;
   rma_line_rec_         Return_Material_Line_API.Public_Rec;
   co_line_rec_          Customer_Order_Line_API.Public_Rec;
   ret_to_delivered_sup_ BOOLEAN := FALSE;
   po_vendor_no_         VARCHAR2(20);
BEGIN
   rma_rec_ := Return_Material_API.Get(rma_no_);
   IF (rma_rec_.return_to_contract IS NOT NULL OR rma_rec_.return_to_vendor_no IS NOT NULL) THEN
      rma_line_rec_ := Return_Material_Line_API.Get(rma_no_, rma_line_no_);
      co_line_rec_ := Customer_Order_Line_API.Get(rma_line_rec_.order_no, rma_line_rec_.line_no, rma_line_rec_.rel_no, rma_line_rec_.line_item_no);
      po_vendor_no_ := Customer_Order_Pur_Order_API.Get_PO_Vendor_No(NULL, co_line_rec_.order_no, co_line_rec_.line_no, co_line_rec_.rel_no, co_line_rec_.line_item_no);
      IF (rma_rec_.return_to_contract IS NULL AND rma_rec_.return_to_vendor_no IS NOT NULL AND (rma_rec_.return_to_vendor_no = po_vendor_no_)) THEN
         ret_to_delivered_sup_ := TRUE;
      END IF;
      IF ((rma_rec_.contract != rma_rec_.return_to_contract) AND
         (rma_rec_.return_to_vendor_no IS NOT NULL) AND
         (rma_rec_.return_to_contract = co_line_rec_.supply_site) AND
         (rma_rec_.return_to_vendor_no = po_vendor_no_)) THEN
         ret_to_delivered_sup_ := TRUE;
      END IF;
   END IF;

   RETURN ret_to_delivered_sup_;
END Check_Return_To_Delivered_Sup;


-- Check_Return_To_Diff_Site
--   This method checks whether the materials are returned to a different site
--   other than from where the goods are delivered.
@UncheckedAccess
FUNCTION Check_Return_To_Diff_Site (
   rma_no_       IN NUMBER,
   rma_line_no_  IN NUMBER ) RETURN BOOLEAN
IS
   ret_to_diff_site_   BOOLEAN := FALSE;
   rma_rec_            Return_Material_API.Public_Rec;
BEGIN
   rma_rec_ := Return_Material_API.Get(rma_no_);
   IF (rma_rec_.contract != rma_rec_.return_to_contract AND NOT(Check_Return_To_Delivered_Sup(rma_no_, rma_line_no_))) THEN
      ret_to_diff_site_ := TRUE;
   END IF;

   RETURN ret_to_diff_site_;
END Check_Return_To_Diff_Site;


-- Register_Direct_Return
--   This is to register the return for the direct delivered goods.
PROCEDURE Register_Direct_Return (
   rma_no_                  IN NUMBER,
   rma_line_no_             IN NUMBER,
   total_inv_qty_           IN NUMBER,
   total_sales_qty_         IN NUMBER,
   demand_transaction_code_ IN VARCHAR2,
   message_                 IN VARCHAR2 )
IS
   msg_     CLOB;  
   
BEGIN
   msg_ := message_; 
   Register_Direct_Return_Clob (rma_no_, rma_line_no_, total_inv_qty_,total_sales_qty_,demand_transaction_code_, msg_ );
END Register_Direct_Return;

PROCEDURE Register_Direct_Return_Clob (
   rma_no_                  IN NUMBER,
   rma_line_no_             IN NUMBER,
   total_inv_qty_           IN NUMBER,
   total_sales_qty_         IN NUMBER,
   demand_transaction_code_ IN VARCHAR2,
   message_                 IN CLOB )
IS
   org_rma_line_rec_          Return_Material_Line_API.Public_Rec;
   attr_                      VARCHAR2(2000);
   oldrec_                    RETURN_MATERIAL_LINE_TAB%ROWTYPE;
   indrec_                    Indicator_Rec;
   total_inv_qty_received_    NUMBER := 0;
   total_sales_qty_received_  NUMBER := 0;
   inv_qty_to_return_         NUMBER := 0;
   sales_qty_returned_        NUMBER := 0;
   sales_qty_to_return_       NUMBER := 0;
   newrec_                    RETURN_MATERIAL_LINE_TAB%ROWTYPE;
   err_msg_                   BOOLEAN := FALSE;
   objid_                     VARCHAR2(2000);
   objversion_                VARCHAR2(2000);
   inv_qty_returned_          NUMBER;
   company_                   VARCHAR2(20);
   count_                     NUMBER;
   name_arr_                  Message_SYS.name_table;
   value_arr_                 Message_SYS.line_table;
   inv_trans_rec_             Inventory_Transaction_Hist_API.Public_Rec;
   inv_transaction_id_        NUMBER;
   inv_qty_remaining_         NUMBER;
   sales_qty_remaining_       NUMBER;
   sales_qty_sum_             NUMBER;
   lot_batch_no_              VARCHAR2(20);
   serial_no_                 VARCHAR2(20);
   eng_chg_level_             VARCHAR2(6);
   condition_code_            VARCHAR2(20);
   waiv_dev_rej_no_           VARCHAR2(20);
   serial_delivered_          BOOLEAN := FALSE;
   location_no_               VARCHAR2(35);
   expiration_date_           DATE;
   activity_seq_              NUMBER;
   handling_unit_id_          NUMBER;
   catch_qty_returned_        NUMBER;
   reject_code_               VARCHAR2(8);
   org_rma_rec_               Return_Material_API.Public_Rec;
   part_objstate_             VARCHAR2(100);
BEGIN 
   org_rma_line_rec_ := Return_Material_Line_API.Get(rma_no_, rma_line_no_);
   org_rma_rec_      := Return_Material_API.Get(rma_no_);

   IF (total_inv_qty_ IS NOT NULL OR total_sales_qty_ IS NOT NULL) THEN
      Client_SYS.Clear_Attr(attr_);
      oldrec_ := Lock_By_Keys___(rma_no_, rma_line_no_);
      newrec_ := oldrec_;
      IF (oldrec_.rowstate = 'Cancelled') THEN
         Error_SYS.Record_General(lu_name_, 'CHGCANCELED: Cancelled RMA line can not be changed.');
      END IF;
      IF (org_rma_line_rec_.part_no IS NOT NULL) THEN
         inv_qty_to_return_ := org_rma_line_rec_.qty_to_return_inv_uom - NVL(oldrec_.qty_received_inv_uom, 0);
         IF (total_inv_qty_ > inv_qty_to_return_) THEN
            err_msg_ := TRUE;
         END IF;
      ELSE
         sales_qty_to_return_ := org_rma_line_rec_.qty_to_return - NVL(oldrec_.qty_received, 0);
         IF (total_sales_qty_ > sales_qty_to_return_) THEN
            err_msg_ := TRUE;
         END IF;
      END IF;
      IF err_msg_ THEN
         Error_SYS.Record_General(lu_name_, 'RETURN_EXCEED: The newly received quantity cannot exceed the remaining return quantity.');
      END IF;

      IF ((total_inv_qty_ IS NOT NULL) AND (total_sales_qty_ IS NULL)) THEN
         -- When return from Internal Order Transit need to calculate sales qty from the given inventory qty.
         sales_qty_sum_ := total_inv_qty_ * org_rma_line_rec_.inverted_conv_factor / org_rma_line_rec_.conv_factor;
      ELSE
         sales_qty_sum_ := total_sales_qty_;
      END IF;

      total_sales_qty_received_ := NVL(oldrec_.qty_received, 0) + sales_qty_sum_;
      Client_SYS.Add_To_Attr('QTY_RECEIVED', total_sales_qty_received_, attr_);
      IF (org_rma_line_rec_.part_no IS NOT NULL) THEN
         total_inv_qty_received_ := NVL(oldrec_.qty_received_inv_uom, 0) + total_inv_qty_;
      ELSE
         -- for non inventory sales parts qty_received_inv_uom is just updated with sales qty
         total_inv_qty_received_ := NVL(oldrec_.qty_received_inv_uom, 0) + sales_qty_sum_;
      END IF;
      Client_SYS.Add_To_Attr('QTY_RECEIVED_INV_UOM', total_inv_qty_received_, attr_);

      -- qty_returned in CO line tab will be updated (inside Update___ )when qty_received in RMA is updated
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
      Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);

      org_rma_line_rec_ := Return_Material_Line_API.Get(rma_no_, rma_line_no_);
   END IF;

   Message_SYS.Get_Attributes(message_, count_, name_arr_, value_arr_);
   FOR i_ IN 1..count_ LOOP
      IF (name_arr_(i_) = 'TRANSACTION_ID') THEN
         inv_transaction_id_ := value_arr_(i_);
      ELSIF (name_arr_(i_) = 'LOT_BATCH_NO') THEN
         lot_batch_no_ := value_arr_(i_);
      ELSIF (name_arr_(i_) = 'SERIAL_NO') THEN
         serial_no_ := value_arr_(i_);
         IF (serial_no_ IS NULL) THEN
            Error_SYS.Record_General(lu_name_, 'NOSERIAL: Serial No must have a value');
         END IF;
      ELSIF (name_arr_(i_) = 'ENG_CHG_LEVEL') THEN
         eng_chg_level_ := value_arr_(i_);
      ELSIF (name_arr_(i_) = 'WAIV_DEV_REJ_NO') THEN
         waiv_dev_rej_no_ := value_arr_(i_);
      ELSIF (name_arr_(i_) = 'CONDITION_CODE') THEN
         condition_code_ := value_arr_(i_);
      ELSIF (name_arr_(i_) = 'LOCATION_NO') THEN
         location_no_ := value_arr_(i_);
      ELSIF (name_arr_(i_) = 'ACTIVITY_SEQ') THEN
         activity_seq_ := value_arr_(i_);
      ELSIF (name_arr_(i_) = 'HANDLING_UNIT_ID') THEN
         handling_unit_id_ := value_arr_(i_);
      ELSIF (name_arr_(i_) = 'EXPIRATION_DATE') THEN
         expiration_date_ := Client_SYS.Attr_Value_To_Date(value_arr_(i_));
      ELSIF (name_arr_(i_) = 'CATCH_QTY_RETURNED') THEN
         catch_qty_returned_ := value_arr_(i_);
      ELSIF (name_arr_(i_) = 'REJECT_CODE') THEN
         reject_code_ := value_arr_(i_);
      ELSIF (name_arr_(i_) = 'SALES_QTY_RETURNED') THEN
         sales_qty_returned_ := Client_SYS.Attr_Value_To_Number(value_arr_(i_));
      ELSIF (name_arr_(i_) = 'INV_QTY_RETURNED') THEN
         inv_qty_returned_ := Client_SYS.Attr_Value_To_Number(value_arr_(i_));

         IF (inv_qty_returned_ > 0 AND sales_qty_returned_ IS NULL) THEN
            sales_qty_returned_ := inv_qty_returned_ * org_rma_line_rec_.inverted_conv_factor / org_rma_line_rec_.conv_factor;
         END IF;

         company_ := Site_API.Get_Company(org_rma_rec_.contract);

         IF (serial_no_ != '*') THEN
            part_objstate_ := Part_Serial_Catalog_API.Get_Objstate(org_rma_line_rec_.part_no, serial_no_);            
            IF part_objstate_ = 'InFacility' THEN               
               $IF Component_Equip_SYS.INSTALLED $THEN                  
                  Equipment_Serial_Utility_API.Moved_To_Issued_Cust_In_Object(org_rma_rec_.customer_no, org_rma_line_rec_.part_no, serial_no_);
               $ELSE
                  NULL;
               $END
            END IF;
               
            serial_delivered_ := Inventory_Transaction_Hist_API.Serial_Processed_On_Order(org_rma_line_rec_.order_no,
                                                                                          org_rma_line_rec_.line_no,
                                                                                          org_rma_line_rec_.rel_no,
                                                                                          org_rma_line_rec_.line_item_no,
                                                                                          'CUST ORDER',
                                                                                          org_rma_line_rec_.part_no,
                                                                                          serial_no_);

            IF NOT serial_delivered_ THEN
               IF (Check_Return_To_Diff_Site(rma_no_, rma_line_no_)) THEN
                  Error_SYS.Record_General(lu_name_, 'UN_DELIVERED_SERIAL: Serial number :P1 was not delivered by the customer order line connected to the originating RMA line in site :P2.', serial_no_, org_rma_rec_.contract);
               ELSE
                  Error_SYS.Record_General(lu_name_, 'WRONGSERIALNOINV: Serial no :P1 was not registered for direct delivery in site :P2.', serial_no_, org_rma_rec_.return_to_contract);
               END IF;
            END IF;
         END IF;

         IF (inv_transaction_id_ IS NOT NULL) THEN
            -- the original transaction is sent from the client
            inv_trans_rec_          := Inventory_Transaction_Hist_API.Get(inv_transaction_id_);

            inv_qty_remaining_      := inv_qty_returned_;
            sales_qty_remaining_    := sales_qty_returned_;

            Create_Dir_Ret_Transaction___(inv_qty_remaining_,
                                          sales_qty_remaining_,
                                          inv_transaction_id_,
                                          demand_transaction_code_,
                                          rma_no_,
                                          rma_line_no_,
                                          org_rma_line_rec_.order_no,
                                          org_rma_line_rec_.line_no,
                                          org_rma_line_rec_.rel_no,
                                          org_rma_line_rec_.line_item_no,
                                          org_rma_line_rec_.po_order_no,
                                          org_rma_line_rec_.po_line_no,
                                          org_rma_line_rec_.po_rel_no,
                                          inv_trans_rec_.alt_source_ref4,
                                          org_rma_line_rec_.part_no,
                                          org_rma_line_rec_.catalog_no,
                                          inv_trans_rec_.lot_batch_no,
                                          inv_trans_rec_.serial_no,
                                          inv_trans_rec_.waiv_dev_rej_no,
                                          inv_trans_rec_.eng_chg_level,
                                          inv_trans_rec_.condition_code,
                                          org_rma_line_rec_.configuration_id,
                                          inv_trans_rec_.activity_seq,
                                          inv_trans_rec_.handling_unit_id,
                                          inv_trans_rec_.project_id,
                                          inv_trans_rec_.quantity,
                                          FALSE,
                                          org_rma_rec_.contract,
                                          company_,
                                          org_rma_line_rec_.supplier_return_reason,
                                          location_no_,
                                          expiration_date_,
                                          catch_qty_returned_,
                                          inv_qty_returned_,
                                          reject_code_);
         ELSE
            inv_qty_remaining_   := inv_qty_returned_;
            sales_qty_remaining_ := sales_qty_returned_;
            Match_Returns_Against_Del___(inv_qty_remaining_,
                                         sales_qty_remaining_,
                                         FALSE,
                                         rma_no_,
                                         rma_line_no_,
                                         demand_transaction_code_,
                                         lot_batch_no_,
                                         serial_no_,
                                         waiv_dev_rej_no_,
                                         eng_chg_level_,
                                         condition_code_,
                                         activity_seq_,
                                         handling_unit_id_,
                                         company_,
                                         location_no_,
                                         expiration_date_,
                                         catch_qty_returned_,
                                         inv_qty_returned_,
                                         reject_code_);
                                       
            
            -- If still remaining Quantity exists means trying to return to diferent lot batch/WDR.
            -- So need to loop again IN FIFO to return Quantities.
            IF inv_qty_remaining_ > 0 OR sales_qty_remaining_ > 0 THEN
               Match_Returns_Against_Del___(inv_qty_remaining_,
                                             sales_qty_remaining_,
                                             TRUE,
                                             rma_no_,
                                             rma_line_no_,
                                             demand_transaction_code_,
                                             lot_batch_no_,
                                             serial_no_,
                                             waiv_dev_rej_no_,
                                             eng_chg_level_,
                                             condition_code_,
                                             activity_seq_,
                                             handling_unit_id_,
                                             company_,
                                             location_no_,
                                             expiration_date_,
                                             catch_qty_returned_,
                                             inv_qty_returned_,
                                             reject_code_);
            END IF;
            
            IF (inv_qty_remaining_ > 0 OR sales_qty_remaining_ > 0) THEN
               Error_SYS.Record_General(lu_name_, 'WRONGDELIVERY: No delivery transaction found.');
            END IF;
         END IF;
      END IF;
   END LOOP;
END Register_Direct_Return_Clob;

-- Get_Tot_Returned_Scrapped_Qty
--   Returns total returned and scrapped quantity from inventory unit meas for specified rma line information
@UncheckedAccess
FUNCTION Get_Tot_Returned_Scrapped_Qty(
   rma_no_             IN NUMBER,
   rma_line_no_        IN NUMBER,
   lot_batch_no_       IN VARCHAR2,
   serial_no_          IN VARCHAR2,
   eng_chg_level_      IN VARCHAR2,
   waiv_dev_rej_no_    IN VARCHAR2,
   part_ownership_db_  IN VARCHAR2,
   owning_vendor_no_   IN VARCHAR2,
   handling_unit_id_   IN NUMBER DEFAULT NULL) RETURN NUMBER
IS
   qty_returned_  NUMBER := 0;
   qty_scrapped_  NUMBER := 0;
   rma_line_rec_  RETURN_MATERIAL_LINE_TAB%ROWTYPE;

   CURSOR get_total_returned_inv(order_no_ VARCHAR2, line_no_ VARCHAR2, rel_no_ VARCHAR2, line_item_no_ NUMBER) IS
      SELECT NVL(SUM(crl.qty_returned_inv), 0)
      FROM   customer_receipt_location_tab crl, return_material_line_tab rml
      WHERE  crl.rma_no = rml.rma_no
      AND    crl.rma_line_no = rml.rma_line_no
      AND    rml.order_no = order_no_
      AND    rml.line_no = line_no_
      AND    rml.rel_no = rel_no_
      AND    rml.line_item_no = line_item_no_
      AND    crl.lot_batch_no = lot_batch_no_
      AND    crl.serial_no = serial_no_
      AND    crl.eng_chg_level = eng_chg_level_
      AND    crl.waiv_dev_rej_no = waiv_dev_rej_no_
      AND    crl.part_ownership =  part_ownership_db_
      AND    (handling_unit_id_ IS NULL OR crl.handling_unit_id = handling_unit_id_)
      AND    NVL(crl.owning_vendor_no, ' ') = NVL(owning_vendor_no_, ' ');

   CURSOR get_total_returned_noninv IS
      SELECT NVL(SUM(qty_returned), 0)
      FROM   customer_return_receipt_tab
      WHERE  rma_no = rma_no_
      AND    rma_line_no = rma_line_no_;

   CURSOR get_total_scrapped(order_no_ VARCHAR2, line_no_ VARCHAR2, rel_no_ VARCHAR2, line_item_no_ NUMBER) IS
      SELECT NVL(SUM(rms.qty_scrapped), 0)
      FROM   return_material_scrap_tab rms, return_material_line_tab rml
      WHERE  rms.rma_no = rml.rma_no
      AND    rms.rma_line_no = rml.rma_line_no
      AND    rml.order_no = order_no_
      AND    rml.line_no = line_no_
      AND    rml.rel_no = rel_no_
      AND    rml.line_item_no = line_item_no_
      AND    rms.lot_batch_no = lot_batch_no_
      AND    rms.serial_no = serial_no_
      AND    rms.eng_chg_level = eng_chg_level_
      AND    rms.waiv_dev_rej_no = waiv_dev_rej_no_;
BEGIN
   rma_line_rec_ := Get_Object_By_Keys___(rma_no_, rma_line_no_);

   IF (rma_line_rec_.part_no IS NULL) THEN
      OPEN get_total_returned_noninv;
      FETCH get_total_returned_noninv INTO qty_returned_;
      CLOSE get_total_returned_noninv;
   ELSE
      -- When Part is Receipt and Issue Serial Tracked but not Serial Tracked in Inventory, then customer_receipt_location keeep the '*' serial,
      -- then returned quantity should be taken from inventory transaction history.
      IF Part_Catalog_API.Serial_Tracked_Only_Rece_Issue(rma_line_rec_.part_no) THEN
         qty_returned_ := Inventory_Transaction_Hist_API.Get_Sum_Quantity(rma_no_,
                                                                          NULL,
                                                                          NULL,
                                                                          rma_line_no_,
                                                                          'RMA',
                                                                          lot_batch_no_,
                                                                          serial_no_,
                                                                          eng_chg_level_,
                                                                          'REVERSED ISSUE');
      ELSE
         OPEN get_total_returned_inv(rma_line_rec_.order_no, rma_line_rec_.line_no, rma_line_rec_.rel_no, rma_line_rec_.line_item_no);
         FETCH get_total_returned_inv INTO qty_returned_;
         CLOSE get_total_returned_inv;
      END IF;

      OPEN get_total_scrapped(rma_line_rec_.order_no, rma_line_rec_.line_no, rma_line_rec_.rel_no, rma_line_rec_.line_item_no);
      FETCH get_total_scrapped INTO qty_scrapped_;
      CLOSE get_total_scrapped;
   END IF;
   RETURN (qty_returned_ + qty_scrapped_);
END Get_Tot_Returned_Scrapped_Qty;

-- Get_Net_Total_Qty_To_Return
--   Returns  minimum quantity from RMA line quantity or
--   net qty received from sales unit meas for specified rma line information.
@UncheckedAccess
FUNCTION Get_Net_Total_Qty_To_Return(
   rma_no_             IN NUMBER,
   rma_line_no_        IN NUMBER,
   lot_batch_no_       IN VARCHAR2,
   serial_no_          IN VARCHAR2,
   eng_chg_level_      IN VARCHAR2,
   waiv_dev_rej_no_    IN VARCHAR2,
   part_ownership_db_  IN VARCHAR2,
   owning_vendor_no_   IN VARCHAR2,
   qty_delivered_inv_  IN NUMBER,
   handling_unit_id_   IN NUMBER DEFAULT NULL) RETURN NUMBER
IS
   qty_delivered_           NUMBER;
   qty_net_received_        NUMBER;
   qty_retrn_scrapped_inv_  NUMBER;
   qty_retrn_scrapped_      NUMBER;
   rma_line_rec_            RETURN_MATERIAL_LINE_TAB%ROWTYPE;
BEGIN
   rma_line_rec_ := Get_Object_By_Keys___(rma_no_, rma_line_no_);

   qty_retrn_scrapped_inv_ := Get_Tot_Returned_Scrapped_Qty(rma_no_,
                                                            rma_line_no_,
                                                            lot_batch_no_,
                                                            serial_no_,
                                                            eng_chg_level_,
                                                            waiv_dev_rej_no_,
                                                            part_ownership_db_,
                                                            owning_vendor_no_,
                                                            handling_unit_id_);

   IF (rma_line_rec_.part_no IS NULL) THEN
      qty_delivered_      := qty_delivered_inv_;
      qty_retrn_scrapped_ := qty_retrn_scrapped_inv_;
   ELSE
      qty_delivered_      := qty_delivered_inv_/rma_line_rec_.conv_factor * rma_line_rec_.inverted_conv_factor;
      qty_retrn_scrapped_ := qty_retrn_scrapped_inv_/rma_line_rec_.conv_factor * rma_line_rec_.inverted_conv_factor;
   END IF;

   qty_net_received_ := qty_delivered_ - qty_retrn_scrapped_;
   RETURN LEAST(rma_line_rec_.qty_to_return, qty_net_received_);
END Get_Net_Total_Qty_To_Return;

-- Get_Net_Tot_Inv_Qty_To_Return
--   Returns  minimum quantity from RMA line quantity or
--   net qty received from inventory unit meas for specified rma line information.
@UncheckedAccess
FUNCTION Get_Net_Tot_Inv_Qty_To_Return(
   rma_no_             IN NUMBER,
   rma_line_no_        IN NUMBER,
   lot_batch_no_       IN VARCHAR2,
   serial_no_          IN VARCHAR2,
   eng_chg_level_      IN VARCHAR2,
   waiv_dev_rej_no_    IN VARCHAR2,
   part_ownership_db_  IN VARCHAR2,
   owning_vendor_no_   IN VARCHAR2,
   qty_delivered_inv_  IN NUMBER,
   handling_unit_id_   IN NUMBER DEFAULT NULL) RETURN NUMBER
IS
   qty_net_received_inv_  NUMBER;   
   rma_line_rec_          RETURN_MATERIAL_LINE_TAB%ROWTYPE;


BEGIN
   rma_line_rec_ := Get_Object_By_Keys___(rma_no_, rma_line_no_);

   IF (rma_line_rec_.part_no IS NOT NULL) THEN
      qty_net_received_inv_ := qty_delivered_inv_ - Get_Tot_Returned_Scrapped_Qty(rma_no_,
                                                                                  rma_line_no_,
                                                                                  lot_batch_no_,
                                                                                  serial_no_,
                                                                                  eng_chg_level_,
                                                                                  waiv_dev_rej_no_,
                                                                                  part_ownership_db_,
                                                                                  owning_vendor_no_,
                                                                                  handling_unit_id_);
   END IF;
   RETURN LEAST(rma_line_rec_.qty_to_return_inv_uom, qty_net_received_inv_);
END Get_Net_Tot_Inv_Qty_To_Return;

-- Get_Tax_Liability_Type_Db
--   Returns tax liability type db value
@UncheckedAccess
FUNCTION Get_Tax_Liability_Type_Db (
   rma_no_     IN VARCHAR2,
   rma_line_no_      IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN      
   RETURN Tax_Liability_API.Get_Tax_Liability_Type_Db(Get_Tax_Liability(rma_no_, rma_line_no_), Get_Delivery_Country_Code(rma_no_, rma_line_no_));
END Get_Tax_Liability_Type_Db;
   
--   *** This method is dynamically called from Tax_Handling_Order_Util_API. ***
@UncheckedAccess
FUNCTION Get_Price_Incl_Tax_Total  (
   source_ref1_   IN VARCHAR2,
   source_ref2_   IN VARCHAR2,
   source_ref3_   IN VARCHAR2,
   source_ref4_   IN VARCHAR2) RETURN NUMBER
IS
BEGIN
   RETURN Get_Line_Total_Price_Incl_Tax (TO_NUMBER(source_ref1_), TO_NUMBER(source_ref2_));
END Get_Price_Incl_Tax_Total ;

--   *** This method is dynamically called from Tax_Handling_Order_Util_API. ***
@UncheckedAccess
PROCEDURE Get_Tax_Info (
   attr_          OUT VARCHAR2,
   source_ref1_   IN  VARCHAR2,
   source_ref2_   IN  VARCHAR2,
   source_ref3_   IN  VARCHAR2,
   source_ref4_   IN  VARCHAR2)
IS
   rma_line_rec_           RETURN_MATERIAL_LINE_TAB%ROWTYPE;
   tax_liability_type_db_  VARCHAR2(20);
   delivery_country_db_    VARCHAR2(2);
   rma_no_                 NUMBER;
   rma_line_no_            NUMBER;
BEGIN
   rma_no_       := TO_NUMBER(source_ref1_);
   rma_line_no_  := TO_NUMBER(source_ref2_);
   rma_line_rec_ := Get_Object_By_Keys___(rma_no_, rma_line_no_);
   delivery_country_db_ := Return_Material_API.Get_Ship_Addr_Country_Code(rma_no_);
   
   Client_SYS.Set_Item_Value('TAX_CODE', rma_line_rec_.fee_code, attr_);
   Client_SYS.Set_Item_Value('TAX_CLASS_ID', rma_line_rec_.tax_class_id, attr_);
   Client_SYS.Set_Item_Value('TAX_LIABILITY', rma_line_rec_.tax_liability, attr_);
   tax_liability_type_db_ := Tax_Liability_API.Get_Tax_Liability_Type_Db(rma_line_rec_.tax_liability, delivery_country_db_);
   Client_SYS.Set_Item_Value('TAX_LIABILITY_TYPE_DB', tax_liability_type_db_, attr_);
   Client_SYS.Set_Item_Value('DELIVERY_COUNTRY_DB', delivery_country_db_, attr_);
   Client_SYS.Set_Item_Value('IS_TAXABLE_DB', Sales_Part_API.Get_Taxable_Db(rma_line_rec_.contract, rma_line_rec_.catalog_no), attr_);
   Client_SYS.Set_Item_Value('TAX_LIABILITY_DATE', NVL(rma_line_rec_.date_returned, TRUNC(Site_API.Get_Site_Date(rma_line_rec_.contract))), attr_);

END Get_Tax_Info;


--   *** This method is dynamically called from Tax_Handling_Order_Util_API. ***
@UncheckedAccess
PROCEDURE Get_External_Tax_Info (
   attr_          OUT VARCHAR2,
   source_ref1_   IN VARCHAR2,
   source_ref2_   IN VARCHAR2,
   source_ref3_   IN VARCHAR2,
   source_ref4_   IN VARCHAR2,
   company_       IN VARCHAR2)
IS
   linerec_  RETURN_MATERIAL_LINE_TAB%ROWTYPE;
BEGIN
   linerec_  := Get_Object_By_Keys___(TO_NUMBER(source_ref1_), TO_NUMBER(source_ref2_));
   Client_SYS.Set_Item_Value('QUANTITY', linerec_.qty_to_return, attr_);  
END Get_External_Tax_Info;


--   *** This method is dynamically called from Tax_Handling_Order_Util_API. ***
@UncheckedAccess
FUNCTION Fetch_Tax_Line_Param(   
   company_             IN VARCHAR2,
   source_ref1_         IN VARCHAR2,
   source_ref2_         IN VARCHAR2,
   source_ref3_         IN VARCHAR2,
   source_ref4_         IN VARCHAR2) RETURN Tax_Handling_Order_Util_API.tax_line_param_rec
IS
   rma_no_              NUMBER;
   rma_line_no_         NUMBER;
   rma_rec_             Return_Material_API.Public_Rec;
   rma_line_rec_        Return_Material_Line_API.Public_Rec;
   tax_line_param_rec_  Tax_Handling_Order_Util_API.tax_line_param_rec;
BEGIN
   rma_no_       := TO_NUMBER(source_ref1_);
   rma_line_no_  := TO_NUMBER(source_ref2_);
   rma_rec_      := Return_Material_API.Get(rma_no_);
   rma_line_rec_ := Return_Material_Line_API.Get(rma_no_, rma_line_no_);
   
   tax_line_param_rec_.company                  := rma_line_rec_.company;
   tax_line_param_rec_.contract                 := rma_line_rec_.contract;
   tax_line_param_rec_.customer_no              := rma_rec_.customer_no;
   tax_line_param_rec_.ship_addr_no             := rma_rec_.ship_addr_no;
   tax_line_param_rec_.planned_ship_date        := TRUNC(Site_API.Get_Site_Date(rma_rec_.contract));
   tax_line_param_rec_.supply_country_db        := rma_rec_.supply_country;
   tax_line_param_rec_.delivery_type            := NVL(rma_line_rec_.delivery_type, '*');
   tax_line_param_rec_.object_id                := rma_line_rec_.catalog_no;
   tax_line_param_rec_.use_price_incl_tax       := rma_rec_.use_price_incl_tax;
   tax_line_param_rec_.currency_code            := rma_rec_.currency_code;
   tax_line_param_rec_.currency_rate            := rma_line_rec_.currency_rate;   
   tax_line_param_rec_.tax_liability            := rma_line_rec_.tax_liability;
   tax_line_param_rec_.tax_liability_type_db    := Tax_Liability_API.Get_Tax_Liability_Type_Db(rma_line_rec_.tax_liability, rma_rec_.ship_addr_country_code);
   tax_line_param_rec_.tax_code                 := rma_line_rec_.fee_code;
   tax_line_param_rec_.tax_calc_structure_id    := rma_line_rec_.tax_calc_structure_id;
   tax_line_param_rec_.tax_class_id             := rma_line_rec_.tax_class_id;
   tax_line_param_rec_.free_of_charge_tax_basis := Calc_Foc_Tax_Basis___(rma_no_, rma_line_no_);
   tax_line_param_rec_.taxable                  := Sales_Part_API.Get_Taxable_Db(rma_line_rec_.contract, rma_line_rec_.catalog_no);
   
   RETURN tax_line_param_rec_;
   
END Fetch_Tax_Line_Param;

--   *** This method is dynamically called from Tax_Handling_Order_Util_API. ***
@UncheckedAccess
PROCEDURE Fetch_Gross_Net_Tax_Amounts(
   gross_curr_amount_      OUT NUMBER,
   net_curr_amount_        OUT NUMBER,
   tax_curr_amount_        OUT NUMBER,
   company_                IN VARCHAR2,
   source_ref1_            IN VARCHAR2,
   source_ref2_            IN VARCHAR2,
   source_ref3_            IN VARCHAR2,
   source_ref4_            IN VARCHAR2) 
IS   
   rma_no_              NUMBER;
   rma_line_no_         NUMBER;
BEGIN
   rma_no_       := TO_NUMBER(source_ref1_);
   rma_line_no_  := TO_NUMBER(source_ref2_);
   
   gross_curr_amount_ := Return_Material_Line_API.Get_Line_Total_Price_Incl_Tax(rma_no_, rma_line_no_);
   net_curr_amount_  := Return_Material_Line_API.Get_Line_Total_Price(rma_no_, rma_line_no_);
   tax_curr_amount_  := Return_Material_Line_API.Get_Total_Tax_Amount_Curr(rma_no_, rma_line_no_); 
END Fetch_Gross_Net_Tax_Amounts;

--   *** This method is dynamically called from Tax_Handling_Order_Util_API. ***
PROCEDURE Validate_Source_Pkg_Info (
   source_ref1_  IN VARCHAR2,
   source_ref2_  IN VARCHAR2,
   source_ref3_  IN VARCHAR2,
   source_ref4_  IN VARCHAR2,
   attr_         IN VARCHAR2)
IS
BEGIN
   NULL;
END Validate_Source_Pkg_Info;

--   *** This method is dynamically called from Tax_Handling_Order_Util_API. ***
@UncheckedAccess
FUNCTION Get_Price_Total (
   source_ref1_   IN VARCHAR2,
   source_ref2_   IN VARCHAR2,
   source_ref3_   IN VARCHAR2,
   source_ref4_   IN VARCHAR2) RETURN NUMBER
IS
BEGIN
   RETURN Get_Line_Total_Price(TO_NUMBER(source_ref1_), TO_NUMBER(source_ref2_));
END Get_Price_Total;


-- Modify_Tax_Info
--   Modifies the tax information with the tax line tax information at the same time.
--   *** This method is dynamically called from Tax_Handling_Order_Util_API. ***
PROCEDURE Modify_Tax_Info (
   attr_         IN OUT VARCHAR2,
   source_ref1_  IN     VARCHAR2,
   source_ref2_  IN     VARCHAR2,
   source_ref3_  IN     VARCHAR2,
   source_ref4_  IN     VARCHAR2 )
IS
   objid_        VARCHAR2(2000);
   objversion_   VARCHAR2(2000);
   oldrec_       RETURN_MATERIAL_LINE_TAB%ROWTYPE;
   newrec_       RETURN_MATERIAL_LINE_TAB%ROWTYPE;   
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, TO_NUMBER(source_ref1_), TO_NUMBER(source_ref2_));
   oldrec_ := Lock_By_Id___(objid_, objversion_);
   newrec_ := oldrec_;
   newrec_.fee_code  := Client_Sys.Get_Item_Value('TAX_CODE', attr_);
   newrec_.tax_class_id := Client_Sys.Get_Item_Value('TAX_CLASS_ID', attr_);   
   newrec_.tax_calc_structure_id  := Client_Sys.Get_Item_Value('TAX_CALC_STRUCTURE_ID', attr_);   
   Client_SYS.Set_Item_Value('TAX_CODE_CHANGED', 'TRUE', attr_);   
   Update___(objid_, oldrec_, newrec_, attr_, objversion_);
END Modify_Tax_Info;


-- Get_Line_Address_Info
--   Returns RMA line Address information.
--   *** This method is dynamically called from Tax_Handling_Order_Util_API. ***
PROCEDURE Get_Line_Address_Info (
   address1_      OUT VARCHAR2,
   address2_      OUT VARCHAR2,
   country_code_  OUT VARCHAR2,
   city_          OUT VARCHAR2,
   state_         OUT VARCHAR2,
   zip_code_      OUT VARCHAR2,
   county_        OUT VARCHAR2,
   in_city_       OUT VARCHAR2,
   source_ref1_   IN  VARCHAR2,
   source_ref2_   IN  VARCHAR2,
   source_ref3_   IN  VARCHAR2,
   source_ref4_   IN  VARCHAR2,
   company_       IN  VARCHAR2)
IS
   rma_rec_           Return_Material_API.Public_Rec;
   cust_addr_rec_     Customer_Info_Address_API.Public_Rec;
   ord_line_addr_rec_ Cust_Order_Line_Address_API.Co_Line_Addr_Rec;
   order_no_          RETURN_MATERIAL_LINE_TAB.order_no%TYPE;
   line_no_           RETURN_MATERIAL_LINE_TAB.line_no%TYPE;
   rel_no_            RETURN_MATERIAL_LINE_TAB.rel_no%TYPE;
   line_item_no_      RETURN_MATERIAL_LINE_TAB.line_item_no%TYPE;
   
   CURSOR get_order_line_info IS
      SELECT order_no, line_no, rel_no, line_item_no
      FROM   RETURN_MATERIAL_LINE_TAB
      WHERE  rma_no      = source_ref1_
      AND    rma_line_no = source_ref2_;
BEGIN
   OPEN get_order_line_info;
   FETCH get_order_line_info INTO order_no_, line_no_, rel_no_, line_item_no_;
   CLOSE get_order_line_info;
   
   IF (order_no_ IS NOT NULL) THEN                            
      ord_line_addr_rec_ := Cust_Order_Line_Address_API.Get_Co_Line_Addr(order_no_, line_no_, rel_no_, line_item_no_);
      address1_          := ord_line_addr_rec_.address1;
      address2_          := ord_line_addr_rec_.address2;
      country_code_      := ord_line_addr_rec_.country_code;
      city_              := ord_line_addr_rec_.city;
      state_             := ord_line_addr_rec_.state;
      zip_code_          := ord_line_addr_rec_.zip_code;
      county_            := ord_line_addr_rec_.county;
      in_city_           := ord_line_addr_rec_.in_city;
   ELSE
      rma_rec_  := Return_Material_API.Get(source_ref1_);
      IF (rma_rec_.ship_addr_flag = 'N') THEN      
         cust_addr_rec_ := Customer_Info_Address_API.Get(rma_rec_.return_from_customer_no, rma_rec_.ship_addr_no);
         address1_      := cust_addr_rec_.address1;
         address2_      := cust_addr_rec_.address2;
         country_code_  := cust_addr_rec_.country;
         city_          := cust_addr_rec_.city;
         state_         := cust_addr_rec_.state;
         zip_code_      := cust_addr_rec_.zip_code;
         county_        := cust_addr_rec_.county;
         in_city_       := cust_addr_rec_.in_city;
      ELSE
         address1_      := rma_rec_.ship_address1;
         address2_      := rma_rec_.ship_address2;
         country_code_  := rma_rec_.ship_addr_country_code;
         city_          := rma_rec_.ship_addr_city;
         state_         := rma_rec_.ship_addr_state;
         zip_code_      := rma_rec_.ship_addr_zip_code;
         county_        := rma_rec_.ship_addr_county;
         in_city_       := NULL;
      END IF;
   END IF;
END Get_Line_Address_Info;


--   Get_Invoice_Price_Qty
--   Returns value of Catch_Qty column, entered in the Return Material Line
--   if it is a catch enabled part.
@UncheckedAccess
FUNCTION Get_Invoice_Price_Qty (
   rma_no_             IN NUMBER  ,
   rma_line_no_        IN NUMBER  ,   
   invoice_qty_        IN NUMBER  ,
   price_conv_factor_  IN NUMBER  ) RETURN NUMBER
IS 
   rma_line_rec_   RETURN_MATERIAL_LINE_TAB%ROWTYPE;
   price_quantity_ NUMBER;
BEGIN   
   price_quantity_ := invoice_qty_ * price_conv_factor_;
   
   IF (rma_no_ IS NOT NULL) THEN
      rma_line_rec_ := Get_Object_By_Keys___(rma_no_, rma_line_no_);
      IF (Part_Catalog_API.Get_Catch_Unit_Enabled_Db(rma_line_rec_.part_no) = 'TRUE') THEN          
         price_quantity_ := rma_line_rec_.catch_qty;
      END IF;      
   END IF;
   
	RETURN price_quantity_;
END Get_Invoice_Price_Qty;

-- Get_Demand_Purchase_Order_Info
-- Returns the demand order references connected to the RMA line.
@UncheckedAccess
PROCEDURE Get_Demand_Purchase_Order_Info (
   po_order_no_       OUT VARCHAR2,
   po_line_no_        OUT VARCHAR2,
   po_rel_no_         OUT VARCHAR2,
   rma_no_            IN  NUMBER,
   rma_line_no_       IN  NUMBER )
IS
   rma_line_rec_  Public_rec;
   dummy_         VARCHAR2(10);
BEGIN
   rma_line_rec_ := Get(rma_no_, rma_line_no_);
   IF rma_line_rec_.po_order_no IS NULL THEN
      -- Receipt of Returned Material into Inventory or Scrapping them
      Customer_Order_Line_API.Get_Demand_Order_Info(po_order_no_, 
                                                    po_line_no_,
                                                    po_rel_no_,
                                                    dummy_,
                                                    rma_line_rec_.order_no,
                                                    rma_line_rec_.line_no,
                                                    rma_line_rec_.rel_no,
                                                    rma_line_rec_.line_item_no);
   ELSE
      -- Direct Return to Supplier
      po_order_no_ := rma_line_rec_.po_order_no;
      po_line_no_  := rma_line_rec_.po_line_no;
      po_rel_no_   := rma_line_rec_.po_rel_no;
   END IF;
END Get_Demand_Purchase_Order_Info;

-- Lines_Invoice_Connected
-- Returns the RMA Line availability.
@UncheckedAccess
FUNCTION Lines_Invoice_Connected (
   order_no_               IN VARCHAR2,
   line_no_                IN VARCHAR2,
   rel_no_                 IN VARCHAR2,
   invoice_no_             IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_ NUMBER;
   
   CURSOR get_inv_connected_lines IS
      SELECT 1
        FROM RETURN_MATERIAL_LINE_TAB
       WHERE  order_no = order_no_
         AND  line_no  = line_no_
         AND  rel_no   = rel_no_
         AND  line_item_no >= 0
         AND  debit_invoice_no = invoice_no_
         AND  rowstate != 'Cancelled';
         
BEGIN
   OPEN  get_inv_connected_lines;
   FETCH get_inv_connected_lines INTO dummy_;
   IF get_inv_connected_lines%FOUND THEN
      CLOSE get_inv_connected_lines;
      RETURN 'TRUE';
   END IF;
   CLOSE get_inv_connected_lines;
   RETURN 'FALSE';
END Lines_Invoice_Connected;

PROCEDURE Packed_Return_And_Scrap(
   rma_no_           IN NUMBER,
   rma_line_no_      IN NUMBER,
   reject_code_      IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   message_          IN CLOB,
   date_received_    IN DATE )
IS
BEGIN
   Packed_Return_And_Scrap___ (rma_no_ , rma_line_no_,reject_code_,part_no_,configuration_id_ , message_, date_received_);
END Packed_Return_And_Scrap;

PROCEDURE Packed_Inventory_Return (
   rma_no_           IN NUMBER,
   rma_line_no_      IN NUMBER,
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   location_no_      IN VARCHAR2,
   message_          IN CLOB,
   source_           IN VARCHAR2,
   date_received_    IN DATE )
IS
BEGIN
   Packed_Inventory_Return___ (rma_no_, rma_line_no_, contract_, part_no_, configuration_id_,location_no_, message_, source_, date_received_ );
END Packed_Inventory_Return;

PROCEDURE Unpack_Cust_Receipt (
   message_       IN OUT VARCHAR2,
   receipt_type_  IN     CLOB )
IS
BEGIN
   Unpack_Cust_Receipt___ ( message_,receipt_type_);
END Unpack_Cust_Receipt;
-- Get_Objversion
--   Return the current objversion for line.
@UncheckedAccess
FUNCTION Get_Objversion (
   rma_no_      IN NUMBER,
   rma_line_no_ IN NUMBER) RETURN VARCHAR2
IS
   temp_  RETURN_MATERIAL_LINE_TAB.rowversion%TYPE;
   CURSOR get_attr IS
      SELECT rowversion
      FROM   RETURN_MATERIAL_LINE_TAB
      WHERE  rma_no = rma_no_
      AND    rma_line_no = rma_line_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN TO_CHAR(temp_, 'YYYYMMDDHH24MISS');
END Get_Objversion;

@UncheckedAccess
FUNCTION Line_Information (
   rma_no_             IN NUMBER,
   rma_line_no_        IN NUMBER) RETURN line_information_arr PIPELINED
IS 
   return_material_line_rec_  public_rec;
   rec_                       line_information_rec;
BEGIN
   return_material_line_rec_     := Get(rma_no_, rma_line_no_);
   rec_.net_amt_base             := Get_Line_Total_Base_Price(rma_no_, rma_line_no_);
   rec_.gross_amt_base           := Get_Total_Base_Price_Incl_Tax(rma_no_, rma_line_no_);
   rec_.net_amt_curr             := Get_Line_Total_Price(rma_no_, rma_line_no_);
   rec_.gross_amt_curr           := Get_Line_Total_Price_Incl_Tax(rma_no_, rma_line_no_);
   rec_.tax_liability_type_db    := Get_Tax_Liability_Type_Db(rma_no_, rma_line_no_);
   rec_.tax_amt_curr             := Get_Total_Tax_Amount_Curr(rma_no_, rma_line_no_);
   rec_.tax_amt_base             := Get_Total_Tax_Amount_Base(rma_no_, rma_line_no_);
   rec_.condition                := Get_Allowed_Operations__(rma_no_, rma_line_no_);   
   rec_.customers_contract       := Cust_Ord_Customer_API.Get_Acquisition_Site(Return_Material_API.Get_Customer_No(rma_no_));
   rec_.customers_company        := Site_API.Get_Company(rec_.customers_contract);
   rec_.multiple_tax_lines       := Source_Tax_Item_API.Multiple_Tax_Items_Exist(Site_API.Get_Company(return_material_line_rec_.contract), 'RETURN_MATERIAL_LINE', rma_no_, rma_line_no_, '*', '*', '*');
   rec_.credit_invoice_series_id := Customer_Order_Inv_Head_API.Get_Series_Id_By_Id(return_material_line_rec_.credit_invoice_no);
   rec_.credit_corr_invoice_no   := Customer_Order_Inv_Head_API.Get_Invoice_No_By_Id(return_material_line_rec_.credit_invoice_no);
   PIPE ROW (rec_);
END Line_Information;

@UncheckedAccess
FUNCTION Receive_Returns_Information (
   rma_no_             IN NUMBER,
   rma_line_no_        IN NUMBER,
   currency_code_      IN VARCHAR2,
   customer_no_        IN VARCHAR2) RETURN receive_authorized_returns_arr PIPELINED
IS 
   return_material_line_rec_  public_rec;
   rec_                       receive_authorized_returns_rec;
BEGIN
   return_material_line_rec_    := Get(rma_no_, rma_line_no_);
   rec_.catalog_type_db         := Sales_Part_API.Get_Catalog_Type_Db(return_material_line_rec_.contract, return_material_line_rec_.catalog_no);
   rec_.gtin_no                 := PART_GTIN_API.Get_Default_Gtin_No(return_material_line_rec_.catalog_no);
   rec_.return_uom              := Return_Material_Line_API.Get_Sales_Unit_Meas(rma_no_, rma_line_no_);
   rec_.rental_no               := CUSTOMER_ORDER_LINE_API.GET_PRIMARY_RENTAL_NO(return_material_line_rec_.order_no, return_material_line_rec_.line_no, return_material_line_rec_.rel_no, return_material_line_rec_.line_item_no);
   rec_.currency_rate_final     := Order_Currency_Rate_Util_API.Get_Fin_Curr_Rate(return_material_line_rec_.currency_rate, Site_API.Get_Company(return_material_line_rec_.contract), currency_code_);
   rec_.total_base              := Return_Material_Line_API.Get_Line_Total_Base_Price(rma_no_, rma_line_no_);
   rec_.gross_total_base        := Return_Material_Line_API.Get_Total_Base_Price_Incl_Tax(rma_no_, rma_line_no_);
   rec_.total_currency          := Return_Material_Line_API.Get_Line_Total_Price(rma_no_, rma_line_no_);
   rec_.gross_total_currency    := Return_Material_Line_API.Get_Line_Total_Price_Incl_Tax(rma_no_, rma_line_no_);
   rec_.condition               := Return_Material_Line_API.Get_Allowed_Operations__(rma_no_, rma_line_no_);
   rec_.credit_corr_invoice_no  := Customer_Order_Inv_Head_API.get_invoice_no_by_id(return_material_line_rec_.credit_invoice_no);
   rec_.customers_company       := Site_API.Get_Company(Cust_Ord_Customer_API.Get_Acquisition_Site(customer_no_));
   rec_.customers_contract      := Cust_Ord_Customer_API.Get_Acquisition_Site(customer_no_);
   rec_.currency_rounding       := Currency_Code_API.Get_Currency_Rounding(Site_API.Get_Company(return_material_line_rec_.contract),currency_code_);
   rec_.shortage_handling_on    := Mpccom_System_Parameter_API.Get_Parameter_Value1('SHORTAGE_HANDLING');
   IF Mpccom_System_Parameter_API.Get_Parameter_Value1( 'SHORTAGE_HANDLING' ) = 'Y' THEN
      rec_.shortage_exist       := Shortage_Demand_API.Shortage_Exists(return_material_line_rec_.contract, return_material_line_rec_.part_no);
      rec_.shortage_flag        := Inventory_Part_API.Get_Shortage_Flag(return_material_line_rec_.contract, return_material_line_rec_.part_no);
   ELSE
      rec_.shortage_exist       := NULL; 
      rec_.shortage_flag        := NULL;
   END IF;
   rec_.inventory_uom           := Inventory_Part_API.Get_Unit_Meas(return_material_line_rec_.contract, return_material_line_rec_.part_no);
   rec_.head_state              := Return_Material_API.Get_State(rma_no_);
   rec_.condition_code_desc     := Condition_Code_API.Get_Description(return_material_line_rec_.condition_code);
   rec_.fee_code_desc           := Statutory_Fee_API.Get_Description(return_material_line_rec_.company, return_material_line_rec_.fee_code);
   PIPE ROW (rec_);
END Receive_Returns_Information;


PROCEDURE Return_Or_Scrap_Serial___ (
   rma_no_           IN NUMBER,
   rma_line_no_      IN NUMBER,
   part_no_          IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   quantity_         IN NUMBER,
   newrec_           IN Return_Material_Line_Tab%ROWTYPE,   
   org_rma_rec_      IN Return_Material_API.Public_Rec,
   rma_rec_          IN Return_Material_API.Public_Rec,
   ordrow_rec_       IN Customer_Order_Line_API.Public_Rec,
   type_             IN VARCHAR2 )
IS
   new_serial_          BOOLEAN := FALSE;
   serial_delivered_    BOOLEAN := FALSE;
   rma_order_           BOOLEAN := FALSE;
   ord_msg_             VARCHAR2(2000);
   rma_msg_             VARCHAR2(2000);      
   part_status_         VARCHAR2(200);
   part_serial_catalog_rec_    Part_Serial_Catalog_API.Public_Rec;
   stop_new_serial_in_rma_     VARCHAR2(5);
BEGIN
   IF (serial_no_ != '*') THEN
      IF (type_ = 'RETURN') THEN
         IF (quantity_ != 1) THEN
            Error_SYS.Record_General(lu_name_, 'SERIAL_QTY_INVALID: Only one item can be returned on each Serial Number.');
         END IF;
      END IF;
      
      stop_new_serial_in_rma_ := Part_Catalog_API.Get_Stop_New_Serial_In_Rma_Db(part_no_);
      IF (newrec_.order_no IS NOT NULL) THEN         
         IF (ordrow_rec_.supply_code = 'PD' AND stop_new_serial_in_rma_ = 'FALSE') THEN    
            new_serial_ := Inventory_Transaction_Hist_API.Serial_Processed_On_Order(newrec_.order_no,
                                                                                    newrec_.line_no,
                                                                                    newrec_.rel_no,
                                                                                    newrec_.line_item_no,
                                                                                    'CUST ORDER',
                                                                                    part_no_,
                                                                                    '*',
                                                                                    'PODIRSH');
         END IF;
         -- Added a condition to prevent calling the method Serial_Processed_On_Order when it is a new serial.
         IF (NOT new_serial_) THEN
            IF (ordrow_rec_.supply_code = 'PD' AND ordrow_rec_.demand_code = 'PO' AND ordrow_rec_.exchange_item = 'ITEM NOT EXCHANGED') THEN               
               serial_delivered_ := Inventory_Transaction_Hist_API.Serial_Processed_On_Order(ordrow_rec_.demand_order_ref1,
                                                                                             ordrow_rec_.demand_order_ref2,
                                                                                             ordrow_rec_.demand_order_ref3,
                                                                                             ordrow_rec_.demand_order_ref4,
                                                                                             'PUR ORDER',
                                                                                             part_no_,
                                                                                             serial_no_);
            ELSIF(ordrow_rec_.supply_code != 'SEO') THEN               
               serial_delivered_ := Inventory_Transaction_Hist_API.Serial_Processed_On_Order(newrec_.order_no,
                                                                                             newrec_.line_no,
                                                                                             newrec_.rel_no,
                                                                                             newrec_.line_item_no,
                                                                                             'CUST ORDER',
                                                                                             part_no_,
                                                                                             serial_no_);
            END IF;
         END IF;
      END IF;
      
      IF (serial_delivered_) OR 
         ((NOT serial_delivered_) AND 
         ((stop_new_serial_in_rma_ = 'TRUE') OR
         (stop_new_serial_in_rma_ = 'FALSE' AND newrec_.order_no IS NOT NULL AND ((ordrow_rec_.supply_code != 'PD') OR (ordrow_rec_.supply_code = 'PD' AND NOT new_serial_))))) THEN
         Part_Serial_Catalog_API.Exist(part_no_, serial_no_);
      END IF;
      
      part_serial_catalog_rec_ := Part_Serial_Catalog_API.Get(part_no_, serial_no_);      
      IF (newrec_.order_no IS NOT NULL) THEN
         IF (ordrow_rec_.supply_code != 'SEO') THEN  
            rma_order_ := Inventory_Transaction_Hist_API.Serial_Processed_On_Order(rma_no_,
                                                                                   NULL,
                                                                                   NULL,
                                                                                   rma_line_no_,
                                                                                   'RMA',
                                                                                   part_no_,
                                                                                   serial_no_);

            IF rma_order_ THEN
               ord_msg_ := Language_SYS.Translate_Constant(lu_name_,'ORDDETAIL: order no :P1, line no :P2, del no :P3 ', p1_ => newrec_.order_no, p2_ => newrec_.line_no, p3_ => newrec_.rel_no);
               rma_msg_ := Language_SYS.Translate_Constant(lu_name_,'RMADETAIL: Return Material Authorization (RMA) :P1, line no :P2 ', p1_ => rma_no_, p2_ =>  rma_line_no_);

               Error_SYS.Record_General(lu_name_,'SERIALRMARET: The serial no :P1 which is delivered from :P2, is already returned by the :P3.'
                                        ,serial_no_, ord_msg_, rma_msg_);
            END IF;
            
            IF ((NOT serial_delivered_) AND (NOT new_serial_)) THEN
               Error_SYS.Record_General(lu_name_,'WRONGSERIALNO: Serial no :P1 was not delivered on the connected customer order line.',serial_no_);
            END IF;
         END IF;
      ELSE
         IF (part_serial_catalog_rec_.configuration_id != configuration_id_) THEN
            Error_SYS.Record_General(lu_name_,'CONFIDMISMATCH: The configuration ID for serial no :P1 of part :P2 is :P3, which does not match the configuration ID to be received.',serial_no_, part_no_, part_serial_catalog_rec_.configuration_id);
         END IF;
      END IF;

      IF part_serial_catalog_rec_.rowstate = 'InFacility' THEN
         $IF Component_Equip_SYS.INSTALLED $THEN
            Equipment_Serial_Utility_API.Moved_To_Issued_Cust_In_Object(NVL(org_rma_rec_.customer_no, rma_rec_.customer_no),
                                                                        part_no_,
                                                                        serial_no_);
         $ELSE
            Error_SYS.Component_Not_Exist('EQUIP');
         $END
      END IF;      
      
      part_status_ := Part_Serial_Catalog_API.Get_State(part_no_, serial_no_);
      
      IF (type_ = 'RETURN') THEN
         IF (part_serial_catalog_rec_.rowstate NOT IN ('Issued', 'UnderTransportation', 'ReturnedToSupplier', 'InFacility')) THEN
            Error_SYS.Record_General(lu_name_, 'CANNOTINVRETURN: It is not allowed to return in to inventory serial part :P1 in status :P2.', serial_no_, part_status_);
         END IF;
      ELSIF (type_ = 'SCRAP') THEN         
         IF (part_serial_catalog_rec_.rowstate NOT IN ('Issued', 'UnderTransportation', 'ReturnedToSupplier')) THEN            
            Error_SYS.Record_General(lu_name_,'CANNOTSCRAP: It is not allowed to scrap serial part :P1 in status :P2.', serial_no_, part_status_);
         END IF;
      END IF;
   END IF;
END Return_Or_Scrap_Serial___;
