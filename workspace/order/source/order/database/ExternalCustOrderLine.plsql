-----------------------------------------------------------------------------
--
--  Logical unit: ExternalCustOrderLine
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210222  ApWilk  Bug 157977 (SCZ-13591), Modified Transfer_New_Ord_Line() to increase the length of packing instruction id.
--  200707  BudKlk  Bug 152611 (SCZ-9190), Modified Transfer_New_Ord_Line() by increasing the length of Contact_ field into 100.
--  191128  SBalLK  Bug 150878 (SCZ-7736), Modified Transfer_New_Ord_Line() method to fetch sales part number using exsisting information.
--  190106  UdGnlk  Bug 144824, Reversed bug correction 140998 and added an ELSE condition in Transfer_New_Ord_Line() to pass FALSE to copy_discount_ when discount is NULL.
--  180423  ErFelk  Bug 140998, Modified Transfer_New_Ord_Line() by making COPY_DISCOUNT true when DISCOUNT is not null. This will allow external discount to be copied to customer order line. 
--  180129  ChBnlk  Bug 139961, Modified Transfer_New_Ord_Line() by adding condition to check if the GTIN set up exists in the company before checking for the gtin_no_.
--  171116  Chjalk  Bug 138189, Modified Post_Insert_Col_Actions to add 'REPLICATE_CHANGES' and 'CHANGE_REQUEST' to the attribute string to change the address
--  171011          line of the customer order if calling through a change request. 
--  170929  SBalLK  Bug 137937, Modified Transfer_New_Ord_Line() method to send customer part number for customer order line when creating the customer order.
--  170926  RaVdlk  STRSC-11152,Removed Get_State function, since it is generated from the foundation
--  170329  Cpeilk  Bug 134690, Modified Transfer_New_Ord_Line so that Sales Part Cross Reference details are not used when GTIN number is not null.
--  170320  NaLrlk  Modifed Transfer_New_Ord_Line to store packing_instruction_id in created CO for ORDERS and ORDCHG messages.
--  170220  SURBLK  Added Check_Limit_Sales_To_Assort() to verfy the part is able to process for the customer.
--  160919  KiSalk  STRSC-3816, In Transfer_New_Ord_Line, made purchase part searched from demand site instead of supply site for ORDCHG.
--  160919  KiSalk  Bug 131508, Altered 130469 changes not to raise error for Non-inventory parts.
--  160815  KiSalk  Bug 130469, Modified Transfer_New_Ord_Line and Transfer_Quotation_Line___ in order to set the sales part in supply site which is connected to the
--  160720  NWeelk  FINHR-1322, Changed VAT_PAY_TAX to TAX_LIABILITY.  
--  160623  SudJlk  STRSC-2697, Replaced customer_Order_Address_API.Public_Rec with customer_Order_Address_API.Cust_Ord_Addr_Rec and 
--  160623          customer_Order_Address_API.Get() with customer_Order_Address_API.Get_Cust_Ord_Addr().
--  160608  reanpl  STRLOC-428, Added handling of new attributes ship_address3..ship_address6 
--  160505  SBalLK  Bug 128647, Modified Transfer_Order_Line___() method to update customer order line with configuration id before reserve the part according to supply site reservation.
--  160428  ChFolk  STRSC-2108, Modified Transfer_New_Ord_Line to validate No Part with Inv part in supply site.
--  151103  IsSalk  FINHR-316, Renamed attribute FEE_CODE to TAX_CODE in Customer Order Line.
--  150904  SWiclk  Bug 124312, Modified Transfer_New_Ord_Line() in order to fetch customer's delivery address (either default or first selected) since SHIP_ADDR_NO is mandatory.
--  150819  PrYaLK  Bug 121587, Modified Transfer_Quotation_Line___() and Transfer_New_Ord_Line() by fetching both conv_factor and inverted_conv_factor calling
--  150819          Sales_Part_Cross_Reference_API.Get() instead of calling both Sales_Part_Cross_Reference_API.Get_Conv_Factor and Sales_Part_Cross_Reference_API.Get_Inverted_Conv_Factor.
--  150205  RoJalk  PRSC-5941, Modified Set_Default_Address_Flag() and used Validate_SYS.Is_Different.
--  150205  RoJalk  PRSC-5941, Modified Set_Default_Address_Flag() by removing string_null_ from the line side so that the header value is taken if the line value comes as null.
--  150205          Modified Transfer_Order_Line___() by modifing a conditon to check the header ean_location_del_addr and set the addr_flag_.    
--  150205  RoJalk  PRSC-5925, Modified Transfer_New_Ord_Line and fetched a value for curr_code_ based on message type.  
--  150114  RoJalk  PRSC-4990, Modified Transfer_Order_Line___ and passed message type to the method call Post_Insert_Col_Actions and
--  150114          fetched internal_customer_site_ according to the message type within Post_Insert_Col_Actions.
--  150102  RoJalk  PRSC-4133, Modified Transfer_Order_Line___ and moved the address related code to Transfer_New_Ord_Line.
--  141217  RoJalk  PRSC-4133, Modified Transfer_Order_Line___ and moved the address and tax related code to Set_Default_Address_Flag.
--  141216  RoJalk  PRSC-4133, Modified Transfer_Order_Line___ and moved the Rental related code to Transfer_New_Ord_Line.
--  141215  RoJalk  PRSC-4133, Changed the scope of Transfer_New_Ord_Line___ to be public and called from Transfer_Order_Line___ and 
--  141215          Ext_Cust_Order_Line_Change_API.Transfer_Order_Line_Changes___.
--  141212  RoJalk  Added the new method Transfer_New_Ord_Line___ to include common logic for ORDCHG/ORDERS new line. Renamed Post_Insert_Actions to Post_Insert_Col_Actions.
--  141211  RoJalk  PRSC-4133, Added the method Post_Insert_Actions___ and called from Transfer_Order_Line___.
--  141210  RoJalk  PRSC-4133, Modified Transfer_Order_Line___ and removed the duplicate entries for contact, moved district_code and region_code to IPD block.
--  141209  RoJalk  PRSC-4133, Modified Transfer_Order_Line___ and called Cust_Order_Line_Address_API.Change_Address for single occurence.
--  141208  RoJalk  PRSC-4133, Modified Transfer_Order_Line___ - new line and moved the code to set the values for location, dock_code and sub_dock_code will be included in CO line insert instaed of update.
--  141203  RoJalk  Bug 119322, Added new function Set_Default_Address_Flag(). Removed the code which set the default address flag from Transfer_Order_Line___() and 
--  141203          placed the address comparison and setting default address flag in the new method. For demand code IPD this new method will not be called. 
--  141126  RoJalk  PRSC-4416, Modified Transfer_Order_Line_Changes___  and removed NOT NULL checks for IPD.
--  140912  NaLrlk  Modified Transfer_Order_Line___() to support for intersite swap in rental. 
--  140723  KiSalk  Bug 117835, In Transfer_Order_Line___, checked for existence of internal PO No before assigning customer_part_no (which can hold upto 45 characters) to catalog_no_.
--  140723          Added an error message if customer_part_no has a value but no sales part cross reference for the customer_part_no and internal_po_no has not been passed.
--  140609  ShKolk  Modified Transfer_Order_Line___ and Transfer_Quotation_Line___ to consider incl_tax columns when creating CO/SQ.
--  140226  RoJalk  Modified Do_Approve___ and replaced Unpack_Check_Update___ with Unpack___/Check_Update___.
--  131016  MeAblk  Bug 113187, Modified Transfer_Order_Line___ in order to avoid passing NULL for the shipment type in IPD case.
--  131115  Vwloza  Updated New_Rental___ by sending data into External_Pur_Order_Message_API instead of Rental_Object_API.
--  131017  NaLrlk  Added rental column to support rental information in incoming CO.
--  130915  KiSalk  Bug 108888, Added column vendor_part_desc to the table and to the view. Modified methods Unpack_Check_Insert___, Unpack_Check_Update___, Insert___, Update___.
--  130705  UdGnlk  TIBE-995, Removed global variables and modify to conditional compilation. 
--  130808  ShKolk  Modified Transfer_Order_Line___ to copy doc texts of internal PO line.
--  130417  MeAblk  Modified method Transfer_Order_Line___ by removing the handling of packing_instruction_id when the demand_code is IPT. Instead it moved to CustomerOrderLine.apy.
--  130417  SURBLK  Added new column cust_calendar_id and ext_transport_calendar_id.
--  130417  JeeJlk  Added new column ORIGINATING_CO_LANG_CODE.
--  130409  MeAblk  Added packing_instruction_id.
--  120905  MAHPLK  Added picking_leadtime and shipment_type.
--  130502  AyAmlk  Bug 109802, Modified Transfer_Order_Line___() by constructing the code so that CO line address will not be removed
--  130502          when there is no address information given in the incoming CO.
--  130320  AyAmlk  Bug 108793, Modified Transfer_Order_Line___() by removing the code segment which adds Customer's Sales Part to the attr_.
--  130312  AyAmlk  Bug 108793, Modified Transfer_Order_Line___() in order to prevent having NULL value for BASE_SALE_UNIT_PRICE when user
--  130312          sets the Customer's Sales Qty in incoming CO.
--  130212  SBalLK  Bug 107802, Added SHIPMENT_CREATION column and update the necessary method to reflect the changes. Update Transfer_Order_Line___() to send the
--  130212          shipment creation method for the new customer order.
--  120806  THIMLK  Bug 102357, Modified Transfer_Order_Line___ to validate if a configuration record is received for a part that is not configurable.
--  120417  MaMalk  Modified Transfer_Order_Line___ to update the tax information correctly when the demand code id IPD, when a single occurence address and a tax class is used.
--  120222  NaLrlk  Removed attributes input_unit_meas and input_conv_factor. Modified Transfer_Order_Line___,Transfer_Quotation_Line___ to validate the Gtin14 with Input qty.
--  120126  NaLrlk  Modified Transfer_Order_Line___,Transfer_Quotation_Line___ to change the method calls Part_Input_Unit_Meas_API to Part_Gtin_Unit_Meas_API.
--  111215  MaMalk  Modified Insert___ to move the setting of objversion_ to the end of this procedure.
--  110906  ChJalk  Replaced the method call Get_Catalog_No_By_Gtin_No with Validate_Catalog_No_By_Gtin_No.
--  110906  ChJalk  Call to the method Get_Catalog_No_By_Gtin_No was changd to add the out parameter part_no to the method call.
--  110309  Kagalk  RAVEN-1074, Added validated_date field
--  110112  MaMalk  Modified Transfer_Order_Line___ to pass the tax_liability of the external customer to the internal customer order line for IPD deliveries. 
--  101201  NaLrlk  Added columns INPUT_QTY,INPUT_UNIT_MEAS and INPUT_CONV_FACTOR.
--  101201          Modified the methods Transfer_Order_Line___ and Transfer_Quotation_Line___ for the multiple uom columns.
--  100520  KRPELK  Merge Rose Method Documentation.
--  100506  JuMalk  Bug 90398, Modified Transfer_Order_Line___ to set values of DISTRICT_CODE and REGION_CODE fields regardless of the supply code type. 
--  100304  JuMalk  Bug 89249, Modified Transfer_Order_Line___, used rec_ values when assigning values of DISTRICT_CODE and REGION_CODE to attr_.
--  091229  MaRalk  Modified the state machine according to the new template.
--  090930  MaMalk  Removed constant state_separator_. Modified Finite_State_Init___ to remove unused code.
--  ------------------------- 14.0.0 -------------------------------------------------
--  090713 MaJalk  Bug 83121, Changed the data type of the gtin no to string.
--  081201 HoInlk  Bug 78456, Moved global LU CONSTANTS defined in specification to implementation.
--  080623 NaLrlk  Bug 74960, Added check for del_terms_location is null in methods Transfer_Order_Line___ and Transfer_Quotation_Line___.
--  081006 KiSalk  Modified Transfer_Order_Line___, Transfer_Quotation_Line___ to re-asign customer_part_no to catalog_no if Sales_Part_Cross_Reference not entered.
--  080509 MaJalk  Added validations for GTIN at methods Transfer_Quotation_Line___ and Transfer_Order_Line___.
--  080502 MaJalk  Added attribute gtin_no.
--  080404 KiSalk  Modified Transfer_Order_Line___, Transfer_Quotation_Line___ to send classification_part_no, classification_unit_meas, classification_standard.
--  080402 KiSalk  Added attributes classification_part_no, classification_unit_meas, classification_standard and method Get_Classification_Standard.
--  --------------------------- Nice Price -----------------------------
--  080208  NaLrlk  Bug 70005, Removed not null check for del_terms_location in Transfer_Order_Line___ and Transfer_Quotation_Line___.
--  080130  NaLrlk  Bug 70005, Added private column del_terms_location and modified methods Transfer_Order_Line___, Transfer_Quotation_Line___.
--  070427  NuVelk  Bug 64184, Modified Transfer_Order_Line___ to fetch the correct delivery address of the 'deliver to customer' when single occurrence address use.
--  070323  MalLlk  Bug 60882, Modified procedure Transfer_Order_Line___ to pass values of vat_no,
--  070323          vat_db and fee_code came from original CO when IPD and non single occurrence.
--  070124  SuSalk  Added DELIVERY_TERMS_DESC & SHIP_VIA_DESC to base view.
--  070123  SuSalk  Removed DELIVERY_TERMS_DESC & SHIP_VIA_DESC from attr.
--  070118  KaDilk  Removed Language code from Order_Delivery_Term_API.Get_Description().
--  070118  SuSalk  Modified Mpccom_Ship_Via_API.Get_Description method calls.
--  061125  Cpeilk  Changed handling of vat_no in Transfer_Order_Line___.
--  060803  ChJalk  Modified parameters to methods Mpccom_Ship_Via_API.Get_Description and Order_Delivery_Term_API.Get_Description.
--  060725  ChJalk  Modified call Mpccom_Ship_Via_Desc_API.Get_Description to Mpccom_Ship_Via_API.Get_Description
--  060725          and Order_Delivery_Term_Desc_API.Get_Description to Order_Delivery_Term_API.Get_Description.
--  060516  NaLrlk  Enlarge Forwarder/Address - Changed variable definitions.
--  060418  NaLrlk  Enlarge Identity - Changed view comments of deliver_to_customer_no.
--  ------------------------- 13.4.0 -------------------------------------------------
--  060223  MiKulk
--  060203  MaGuse  Bug 55061, Added check for header_ship_via_ in method Transfer_Order_Line___.
--  060125  JaJalk  Added Assert safe annotation.
--  050926  UsRalk  Replaced calls to Currency_Rate_API with calls to Invoice_Library_API.
--  050922  NaLrlk  Removed unused variables.
--  050913  SaJjlk  Modified method Transfer_Order_Line___ to include Customer PO Line No and Release No when creating CO line.
--  050525  UdGnlk  Bug 50103, Added public method Get_Vat_Pay_Tax.
--  050521  UdGnlk  Bug 50103, Modified procedure Transfer_Order_Line___ inorder to get the tax laibilty.
--  050430  UdGnlk  Bug 50103, Added new columns vat_no, vat_free_vat_code and vat_pay_tax and modified Transfer_Order_Line___.
--  050614  LaBolk  Bug 51541, Modified Transfer_Order_Line___ to set RELEASE_PLANNING_DB to NOTRELEASED before the CO line is added.
--  050613  KiSalk  Bug 50953, Added new column, in_city. Modified procedures Unpack_Check_Insert___, Unpack_Check_Update___, Insert___, Update___ and Transfer_Order_Line___.
--  041026  UdGnlk  Bug 45802, Added columns original_buy_qty_due, original_plan_deliv_date.
--  041026          Modified methods Unpack_Check_Insert___, Unpack_Check_Update___, Insert___, Update___.
--  041014  MaJalk  Bug 44958, Modified procedure Transfer_Order_Line___ to consider delivery_terms ,description and forward_agent_id when adding DEFAULT_ADDR_FLAG_DB into the attr.
--  040827  LoPrlk  Method Transfer_Order_Line___ was altered to pass DELIVERY_LEADTIME, ROUTE_ID, DISTRICT_CODE,
--  040827          REGION_CODE and INTRASTAT_EXEMPT_DB for not single occurence addresses also.
--  040811  LoPrlk  Modified the mothod Transfer_Order_Line___ to make the address not order default for internal direct deliveries.
--  040809  DhAalk  Modified the comments of column deliver_to_customer_no in view EXTERNAL_CUST_ORDER_LINE.
--  040728  IsWilk  Modified the PROCEDURE Transfer_Order_Line___.
--  040723  IsWilk  Modified the PROCEDURE Transfer_Order_Line___.
--  040722  IsWilk  Added the column INTRASTAT_EXEMPT and modified the Transfer_Order_Line___.
--  040720  LoPrlk  Added the columns district_code and region_code, and method Transfer_Order_Line___ was altered.
--  040719  WaJalk  Added column contact to the LU.
--  040707  IsWilk  Modified the PROCEDURE Transfer_Order_Line___.
--  040630  IsWilk  Modified the PROCEDURE Transfer_Order_Line___ to fetch the correct addr_flag.
--  040628  LoPrlk  Column deliver_to_customer_no was made nullable.
--  040623  LoPrlk  Added deliver_to_customer_no to the LU. Method Transfer_Order_Line___ was altered. Some red codes were merged.
--  040616  MaMalk  Bug 45492, Modified the method Transfer_Order_Line___ by adding the county field.
--  040513  NaWilk  Bug 44113, Modified methods Unpack_Check_Insert___, Unpack_Check_Update___, Insert___, Update___ and Transfer_Order_Line___. Modified view EXTERNAL_CUST_ORDER_LINE.
--  040511  JaJalk  Corrected the lead time lables.
--  040506  MiKalk  Bug 44109, Modified Transfer_Order_Line___ to send the correct value of ADDR_FLAG_DB for order line at the time of insertion.
--  040224  SeKalk  Bug 41744, Changed the RELEASE_PLANNING_DB attribute in procedure Transfer_Order_Line___.
--  040220  IsWilk  Removed the SUBSTRB for Unicode Changes.
--  040210  Samnlk  Bug 39270, Added a new column INVENTORY_FLAG_DB to fetch the inventory flag in purchase part and modified procedures Unpack_Check_Insert___,
--  040130  OsAllk  Bug 41273, Added a check in the method Transfer_Order_Line___ before calling Reserve_Customer_Order_API.Transfer_Reservation to check the sites.
--  031106  JoAnSe  Added demand_code check in dynamic code in Transfer_Order_Line___
--  031020  SeKalk  Modified the view EXTERNAL_CUST_ORDER_LINE
--  031014  SeKalk  Made the attribute INTERNAL_DELIVERY_TYPE not required
--  031013  SeKalk  Modified view EXTERNAL_CUST_ORDER_LINE
--  031009  SeKalk  Added the column INTERNAL_DELIVERY_TYPE to table EXTERNAL_CUST_ORDER_LINE_TAB
--  030930  OsAllk  Added demand info to the attr in method Transfer_Order_Line___.
--  030919  JoAnSe  Removed initialization of data connected to ship address
--                  in Transfer_Order_Line. The values will be set automatically
--                  in Customer_Order_Line.
--  030911  DaZa    Added a call to Co_Supply_Site_Reservation_API.Get_Qty_Reserved in Transfer_Order_Line___.
--  030904  MaGulk  Added column Condition_Code to EXTERNAL_CUST_ORDER_LINE_TAB &
--  030904          modified Transfer_Order_Line___ to transfer Condition_Code
--  030825  MaGulk  Merged CR
--  030611  JoEd    Added transfer of supply site reservations when approving/transferring
--                  internal orders.
--  030602  BhRalk  Modified the method Transfer_Order_Line___.
--  030519  NaWalk  Added location,dock_code,sub_dock_code to attr_ in 'Transfer_Order_Line___'
--  030403  ThGuLk  Added new columns ship_county, dock_code, sub_dock_code, locaiton
--  ****************************** CR Merge ***********************************
--  030520  SaAblk  Removed public methods, Has_Options, Transfer_Line_Options and Transfer_Quote_Line_Options
--  020828  ErFise  Bug 29508, added new columns route_id, delivery_leadtime and forward_agent_id in VIEW and handling of these in methods
--                  Unpack_Check_Insert___, Insert___, Unpack_Check_Update___, Update___ and Transfer_Order_Line
--                  Added code to handle delivery_leadtime in procedures Unpack_Check_Insert___,
--                  Insert___, Unpack_Check_Update___, Update___ and Transfer_Order_Line.
--  020619  ErFi    Modified Transfer_Quotation_Line___
--  020611  ErFi    Modified Transfer_Quotation_Line___ to transfer configured
--                  lines to the Sales Quotation
--  010822  MaGu    Bug fix 23866. Added fetching of new order line keys after call to
--                  Customer_Order_Line_API.New in method Transfer_Order_Line___.
--  010528  JSAnse  Bug 21463, Added call to General_SYS.Init_Method in procedure Transfer_Quote_Line_Options.
--  00208   JoAn    CID 56719 line_item_no_ was assigned NULL Transfer_Order_Line___
--  001205  JoAn    CID 56719 Added configuration_id to attribute string used to
--                  update order line in Transfer_Order_Line___.
--                  Changed check for configurable part so that it will work also
--                  when only customer part no is passed in.
--  001113  JakH    Blocking creation of configuration if no Characteristics exist
--  001006  JakH    In transfer_order_line changed logic for characteristic pricing
--  000919  MaGu    Renamed address columns. Also modified method Transfer_Order_Line___
--                  to use new address columns. Also modified Insert___, Finite_State_Init
--                  and Finite_State_Machine___ according to new template.
--  000718  DEHA    Added the setting of the price_freeze flag to frozen for
--                  the co-lines for which the price/description should be
--                  set through the ORDERS message.
--  000707  DEHA    Extended Transfer_Line_Chars to handle pricing for
--                  char. options (interface).
--  000620  DEHA    Added Transfer_Line_Chars.
--  000524  JakH    Added Transfer_Quotation_Line___, and a switch in Do_Approve___
--  000719  DEHA    CTO merge for changes from 18/07/2000.
--  000712  LIN     CTO merge.
--  --------------  ------------- 12.10 ---------------------------------------
--  000419  PaLj    Corrected Init_Method Errors
--  --------------  ------ 12.0 -----------------------------------------------
--  991215  JoEd    Added delivery address per line.
--  --------------  ------------- 11.2 ----------------------------------------
--  991007  JoEd    Call Id 21210: Corrected double-byte problems.
--  --------------  ------------- 11.1 ----------------------------------------
--  990427  RaKu    Y.Corrections.
--  990416  JakH    Y. Added use of public-rec.
--  990409  RaKu    New templates.
--  990326  RaKu    Added PLANNED_DELIVERY_DATE to the attribute string in Transfer_Order_Line___.
--  990303  JICE    Corrected handling of currency codes for price on configured
--                  order lines.
--  981217  JICE    Added attributes for Configurator interface, public methods
--                  Has_Options, Transfer_Line_Options.
--  980422  RaKu    Changed length on state-machine from 32000.
--  980401  JoAn    SID 2402 No crossreference is needed for internal orders.
--                  Changed in Transfer_Order_Line___.
--  980302  RaKu    Changed in procedure Transfer_Order_Line___.
--  980218  RaKu    Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Transfer_Order_Line___
--   Creates a new record in the Customer Order Line (detail).
PROCEDURE Transfer_Order_Line___ (
   message_id_   IN NUMBER,
   message_line_ IN NUMBER )
IS
   info_                     VARCHAR2(2000);
   attr_                     VARCHAR2(32000);
   line_attr_                VARCHAR2(32000);
   objid_                    VARCHAR2(2000);
   objversion_               VARCHAR2(2000);
   modified_                 BOOLEAN := FALSE;
   rec_                      EXTERNAL_CUST_ORDER_LINE_TAB%ROWTYPE;
   order_no_                 CUSTOMER_ORDER_TAB.order_no%TYPE;
   line_no_                  VARCHAR2(2000);
   rel_no_                   VARCHAR2(2000);
   line_item_no_             NUMBER;
   headrec_                  Customer_Order_API.public_rec;
   single_occurence_         BOOLEAN := FALSE;
   ship_addr_no_             CUSTOMER_ORDER_TAB.ship_addr_no%TYPE := NULL;
   configuration_id_         NUMBER;
   configured_line_price_id_ NUMBER;
   char_price_               NUMBER;
   calc_char_price_          NUMBER;
   set_freeze_flag_          BOOLEAN;
   catalog_no_               CUSTOMER_ORDER_LINE_TAB.catalog_no%TYPE;
   head_addr_rec_            Customer_Order_Address_API.Cust_Ord_Addr_Rec;
   orig_order_no_            VARCHAR2(12);
   orig_line_no_             VARCHAR2(4);
   orig_rel_no_              VARCHAR2(4);
   orig_line_item_no_        NUMBER;
   demand_code_db_           VARCHAR2(20);
   po_contract_              VARCHAR2(5);
   po_line_note_id_          NUMBER;
   co_line_note_id_          NUMBER;
   default_addr_flag_        VARCHAR2(1);
   sp_tax_class_id_          VARCHAR2(20);
BEGIN
   rec_            := Get_Object_By_Keys___(message_id_, message_line_);
   order_no_       := External_Customer_Order_API.Get_Order_No(message_id_);
   headrec_        := Customer_Order_API.Get(order_no_);
   head_addr_rec_  := Customer_Order_Address_API.Get_Cust_Ord_Addr(order_no_);
   
   IF rec_.internal_delivery_type = 'INTDIRECT' THEN
      demand_code_db_ := 'IPD';
   ELSIF rec_.internal_delivery_type = 'INTTRANSIT' THEN
      demand_code_db_ := 'IPT';
   END IF;
     
   ship_addr_no_ := Cust_Ord_Customer_Address_API.Get_Id_By_Ean_Location(NVL(rec_.deliver_to_customer_no, headrec_.customer_no), rec_.ean_location_del_addr);
  
   Client_SYS.Clear_Attr(attr_);
   
   IF  (((rec_.ship_via_code IS NOT NULL) OR (rec_.delivery_leadtime IS NOT NULL) OR (rec_.picking_leadtime IS NOT NULL) 
       OR (rec_.shipment_type IS NOT NULL)) AND ship_addr_no_ IS NULL) THEN  
      -- Now we have to add some values from the header not passed on line.
      IF (rec_.delivery_leadtime IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('DELIVERY_LEADTIME', rec_.delivery_leadtime, attr_);
      END IF;
      IF (rec_.route_id IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('ROUTE_ID', rec_.route_id, attr_);
      END IF;
      IF (headrec_.ship_addr_no IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('SHIP_ADDR_NO', headrec_.ship_addr_no, attr_);
      END IF;
      IF (rec_.picking_leadtime IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('PICKING_LEADTIME', rec_.picking_leadtime, attr_);
      END IF;
      IF (rec_.shipment_type IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('SHIPMENT_TYPE', rec_.shipment_type, attr_);
      END IF;
   END IF;
   
   -- This method will include common code to handle new line via ORDERS and ORDCHG
   Transfer_New_Ord_Line(set_freeze_flag_, catalog_no_, sp_tax_class_id_,
                         orig_order_no_, orig_line_no_, orig_rel_no_, orig_line_item_no_, po_contract_,
                         default_addr_flag_, single_occurence_, attr_, demand_code_db_, message_id_,
                         message_line_, order_no_, headrec_.customer_no, headrec_.contract,
                         headrec_.internal_po_no, 'ExternalCustOrderLine', headrec_.customer_no_pay,
                         ship_addr_no_, headrec_.addr_flag);
                         
   IF ((rec_.rental = Fnd_Boolean_API.DB_FALSE) AND headrec_.limit_sales_to_assortments = 'TRUE') THEN
      Sales_Part_API.Check_Limit_Sales_To_Assort(headrec_.contract, catalog_no_, headrec_.customer_no);
   END IF;         
                         
   --Internal PO derect. Pass the values came from the original CO.
   IF (demand_code_db_ = 'IPD') THEN
      Client_SYS.Set_Item_Value('DELIVERY_LEADTIME', rec_.delivery_leadtime, attr_);
      Client_SYS.Set_Item_Value('ROUTE_ID',          rec_.route_id,          attr_);
      Client_SYS.Set_Item_Value('PICKING_LEADTIME',  rec_.picking_leadtime,  attr_); 
      Client_SYS.Set_Item_Value('FORWARD_AGENT_ID',  rec_.forward_agent_id,  attr_);
   END IF;
   
   Customer_Order_Line_API.New(info_, attr_);

   -- receive data created on insert of new order line
   line_no_                  := Client_SYS.Get_Item_Value('LINE_NO', attr_);
   rel_no_                   := Client_SYS.Get_Item_Value('REL_NO', attr_);
   line_item_no_             := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('LINE_ITEM_NO', attr_));
   configured_line_price_id_ := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('CONFIGURED_LINE_PRICE_ID', attr_));

   -- Update the incoming customer order line with the new values for line_no and rel_no
   -- to match the new order line.
   Client_SYS.Clear_Attr(line_attr_);

   IF (NVL(rec_.line_no, ' ') != NVL(line_no_,  ' ')) THEN
      Client_SYS.Add_To_Attr('LINE_NO', line_no_, line_attr_);
      modified_ := TRUE;
   END IF;
   IF (NVL(rec_.rel_no,  ' ') != NVL(rel_no_, ' ')) THEN
      Client_SYS.Add_To_Attr('REL_NO', rel_no_, line_attr_);
      modified_ := TRUE;
   END IF;
   IF (modified_) THEN
      Get_Id_Version_By_Keys___ (objid_, objversion_, message_id_, message_line_);
      Modify__(info_, objid_, objversion_, line_attr_, 'DO');
   END IF;

   -- update price-freeze flag
   IF set_freeze_flag_ = TRUE THEN
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('PRICE_FREEZE_DB', 'FROZEN', attr_);
      Customer_Order_Line_API.Modify(attr_, order_no_, line_no_, rel_no_ , line_item_no_);
   END IF;
   
   -- New configuration functionality
   IF (Sales_Part_API.Get_Configurable_Db(headrec_.contract, catalog_no_) = 'CONFIGURED') THEN
      External_Cust_Order_Char_API.Transfer_Line_Chars( configuration_id_, configured_line_price_id_, message_id_,
                                                        order_no_, line_no_, rel_no_);

      -- IF configuration was created update configuration id and price information on customer order line
      IF (configuration_id_ IS NOT NULL) THEN

         Configured_Line_Price_API.Get_Pricing_Totals( char_price_, calc_char_price_,
                                                       configured_line_price_id_, configuration_id_);
         Client_SYS.Clear_Attr(attr_);
         Client_SYS.Add_To_Attr('CONFIGURATION_ID', configuration_id_, attr_);
         Client_SYS.Add_To_Attr('CHAR_PRICE', char_price_, attr_);
         Client_SYS.Add_To_Attr('CALC_CHAR_PRICE', calc_char_price_, attr_);
         Customer_Order_Line_API.Modify( attr_, order_no_, line_no_, rel_no_, line_item_no_);
      END IF;
   ELSIF (External_Cust_Order_Char_API.Has_Configuration(message_id_, line_no_, rel_no_) = 1) THEN
      Error_SYS.Record_General(lu_name_, 'NOTCONFIGPART: The part :P1 is not a configurable part, and therefore cannot have configuration characteristics line(s).', catalog_no_);
   END IF;
   
   Post_Insert_Col_Actions(message_id_, order_no_, line_no_, rel_no_, line_item_no_, orig_order_no_, orig_line_no_,
                           orig_rel_no_, orig_line_item_no_, single_occurence_, default_addr_flag_, demand_code_db_,
                           rec_.delivery_address_name, rec_.ship_address1, rec_.ship_address2, rec_.ship_address3, rec_.ship_address4, 
                           rec_.ship_address5, rec_.ship_address6, rec_.ship_zip_code,
                           rec_.ship_city, rec_.ship_state, rec_.country_code, rec_.ship_county, rec_.vat_free_vat_code,
                           po_contract_, headrec_.internal_po_no, sp_tax_class_id_, 'ORDERS' );

   IF (NVL(External_Customer_Order_API.Get_Same_Database_Db(message_id_), Fnd_Boolean_API.DB_FALSE) = Fnd_Boolean_API.DB_TRUE) THEN
      -- Fetch and copy PO line notes to the CO line
      $IF Component_Purch_SYS.INSTALLED $THEN
         po_line_note_id_  := Purchase_Order_Line_API.Get_Note_Id(headrec_.internal_po_no, rec_.line_no, rec_.rel_no);
      $END
      IF (po_line_note_id_ IS NOT NULL) THEN
         co_line_note_id_ := Customer_Order_Line_API.Get_Note_Id(order_no_, line_no_, rel_no_, line_item_no_);
         Document_Text_API.Copy_All_Note_Texts(po_line_note_id_, co_line_note_id_);
      END IF;
   END IF;
END Transfer_Order_Line___;


-- Transfer_Quotation_Line___
--   Creates a new record in the Order Quotation Line (detail).
PROCEDURE Transfer_Quotation_Line___ (
   message_id_   IN NUMBER,
   message_line_ IN NUMBER )
IS
   info_                     VARCHAR2(2000);
   attr_                     VARCHAR2(32000);
   rec_                      EXTERNAL_CUST_ORDER_LINE_TAB%ROWTYPE;
   quotation_no_             ORDER_QUOTATION_TAB.quotation_no%TYPE;
   line_no_                  VARCHAR2(2000);
   rel_no_                   VARCHAR2(2000);
   line_item_no_             NUMBER;
   company_                  VARCHAR2(20);
   curr_code_                VARCHAR2(20);
   curr_rate_                NUMBER;
   curr_type_                VARCHAR2(20);
   conv_factor_              NUMBER;
   headrec_                  Order_Quotation_API.public_rec;
   ship_addr_no_             ORDER_QUOTATION_TAB.ship_addr_no%TYPE := NULL;
   catalog_no_               ORDER_QUOTATION_LINE_TAB.catalog_no%TYPE;
   configuration_id_         NUMBER;
   configured_line_price_id_ NUMBER;
   char_price_               NUMBER;
   calc_char_price_          NUMBER;
   temp_classi_part_no_      EXTERNAL_CUST_ORDER_LINE_TAB.classification_part_no%TYPE;
   temp_classi_unit_meas_    EXTERNAL_CUST_ORDER_LINE_TAB.classification_unit_meas%TYPE;
   gtin_part_no_             VARCHAR2(2000) := NULL;
   input_variable_values_    ORDER_QUOTATION_LINE_TAB.input_variable_values%TYPE := NULL;
   input_unit_meas_          ORDER_QUOTATION_LINE_TAB.input_unit_meas%TYPE := NULL;
   input_conv_factor_        ORDER_QUOTATION_LINE_TAB.input_conv_factor%TYPE  := NULL;
   leadtimerec_              Customer_Address_Leadtime_API.Public_Rec;
   customer_rec_             Sales_Part_Cross_Reference_API.Public_Rec;

BEGIN
   rec_          := Get_Object_By_Keys___(message_id_, message_line_);
   quotation_no_ := External_Customer_Order_API.Get_Order_No(message_id_);
   line_no_      := rec_.line_no;
   rel_no_       := rec_.rel_no;
   headrec_      := Order_Quotation_API.Get(quotation_no_);
   
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('QUOTATION_NO', quotation_no_, attr_);
   Client_SYS.Add_To_Attr('LINE_NO', rec_.line_no , attr_);
   Client_SYS.Add_To_Attr('REL_NO', rec_.rel_no , attr_);
   Client_SYS.Add_To_Attr('LINE_ITEM_NO', 0, attr_);
   Client_SYS.Add_To_Attr('CONTRACT', headrec_.contract, attr_);
   Client_SYS.Add_To_Attr('WANTED_DELIVERY_DATE', rec_.wanted_delivery_date , attr_);
   Client_SYS.Add_To_Attr('NOTE_TEXT', rec_.notes , attr_);

   -- Priorities to fetch catalog_no
   -- 1. IFS Sales Part No.
   -- 2. GTIN
   -- 3. Customer's Part No.
   -- 4. Std Class. Part No.

   IF rec_.catalog_no IS NOT NULL THEN
      --first check for the IFS sales part no
      catalog_no_ := rec_.catalog_no;
   ELSIF (rec_.gtin_no IS NOT NULL) THEN
      -- IF IFS sales part no is null fetch the GTIN
      Sales_Part_API.Validate_Catalog_No_By_Gtin_No(catalog_no_, rec_.gtin_no, headrec_.contract);
   ELSIF rec_.customer_part_no IS NOT NULL THEN
      -- IF GTIN is also null check for the customer's part no
      -- Lookup the sales part number in the sales part cross reference
      catalog_no_ := Sales_Part_Cross_Reference_API.Get_Catalog_No(headrec_.customer_no, headrec_.contract, rec_.customer_part_no);

      IF (catalog_no_ IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('CUSTOMER_PART_NO', rec_.customer_part_no , attr_);
      END IF;
   END IF;

   IF (rec_.classification_standard IS NOT NULL) THEN
      -- retrieve the catalog no from the std classification code
      temp_classi_part_no_ := rec_.classification_part_no;
      temp_classi_unit_meas_ := rec_.classification_unit_meas;
      Assortment_Node_API.Get_Classification_Defaults(temp_classi_unit_meas_,
                                                      rec_.catalog_no,
                                                      temp_classi_part_no_,
                                                      rec_.classification_standard,
                                                      'TRUE');

      IF (rec_.classification_part_no IS NOT NULL AND temp_classi_part_no_ IS NOT NULL AND temp_classi_part_no_ != rec_.classification_part_no) THEN
         Error_SYS.Record_General(lu_name_, 'CLASSIPARTDIFF: Classification part no :P1 of external order line does not match with :P2 of the system.', rec_.classification_part_no, temp_classi_part_no_);
      END IF;
      IF (rec_.classification_unit_meas IS NOT NULL AND temp_classi_unit_meas_ IS NOT NULL AND temp_classi_unit_meas_ != rec_.classification_unit_meas) THEN
         Error_SYS.Record_General(lu_name_, 'CLASSIUOMDIFF: Classification unit of measure :P1 of external order line does not match with :P2 of the system.', rec_.classification_unit_meas, temp_classi_unit_meas_);
      END IF;

      IF (temp_classi_part_no_ IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('CLASSIFICATION_STANDARD', rec_.classification_standard , attr_);
         Client_SYS.Add_To_Attr('CLASSIFICATION_PART_NO', temp_classi_part_no_ , attr_);
         Client_SYS.Add_To_Attr('CLASSIFICATION_UNIT_MEAS', temp_classi_unit_meas_ , attr_);
      END IF;
      IF (catalog_no_ IS NULL) THEN
         catalog_no_ := rec_.catalog_no;
      END IF;
   END IF;
   IF (catalog_no_ IS NULL AND rec_.customer_part_no IS NOT NULL) THEN
      -- IF the sales part available in both sites, customer_part_no can be used in place of catalog_no, even though Sales_Part_Cross_Reference not entered
      catalog_no_ := rec_.customer_part_no;
      IF (Inventory_Part_API.Check_Exist(headrec_.contract, rec_.customer_part_no)) THEN
         IF (rec_.customer_part_no != Sales_Part_API.Get_Part_No(headrec_.contract, rec_.customer_part_no)) THEN
            -- Set the sales part in supply site which is connected to the inventory part in
            -- demand site as the catalog_no, even though Sales_Part_Cross_Reference not entered
            catalog_no_ := Sales_Part_API.Get_Catalog_No_For_Part_No(headrec_.contract, rec_.customer_part_no);
         END IF;
      ELSE
            IF Sales_Part_API.Check_Exist(headrec_.contract, catalog_no_) = 0 THEN
               catalog_no_ := NVL(Sales_Part_API.Get_Catalog_No_For_Purch_No(headrec_.contract, catalog_no_), catalog_no_);
            END IF;
      END IF;
   END IF;

   Client_SYS.Add_To_Attr('CATALOG_NO', catalog_no_ , attr_);

   IF (rec_.gtin_no IS NOT NULL) THEN
      Sales_Part_API.Validate_Catalog_No_By_Gtin_No(gtin_part_no_, rec_.gtin_no, headrec_.contract);
      IF (gtin_part_no_ IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'NOCATNOBYGTIN: Cannot find a valid sales part for the GTIN.');
      END IF;
      IF (gtin_part_no_ != catalog_no_) THEN
         Error_SYS.Record_General(lu_name_, 'NOMATCHCATNOBYGTIN: The received GTIN is not connected to the received Sales Part.');
      END IF;
      -- Check Exist for the valid GTIN 14, IF exist validate with received input qty.
      IF (NVL(Part_Gtin_Unit_Meas_API.Get_Part_Via_Identified_Gtin(rec_.gtin_no), Database_SYS.string_null_) = gtin_part_no_) THEN
         input_unit_meas_ := Part_Gtin_Unit_Meas_API.Get_Unit_Code_For_Gtin14(rec_.gtin_no);
         input_conv_factor_ := Input_Unit_Meas_API.Get_Conversion_Factor(Part_Catalog_API.Get_Input_Unit_Meas_Group_Id(gtin_part_no_),
                                                                         input_unit_meas_);
         input_variable_values_ := Input_Unit_Meas_API.Get_Input_Value_String(rec_.input_qty, 
                                                                              input_unit_meas_);


         IF (rec_.buy_qty_due IS NOT NULL AND rec_.input_qty IS NOT NULL) THEN
            IF (rec_.buy_qty_due != rec_.input_qty * input_conv_factor_) THEN
               Error_SYS.Record_General(lu_name_, 'INCORRECTQTY: The relation between the received Sales Qty and the received Input Qty is not correct according to Input Conversion Factor');
            END IF;
         ELSIF (rec_.buy_qty_due IS NOT NULL AND rec_.input_qty IS NULL) THEN
            rec_.input_qty   := rec_.buy_qty_due / input_conv_factor_;
         ELSIF (rec_.buy_qty_due IS NULL AND rec_.input_qty IS NOT NULL) THEN
            rec_.buy_qty_due := rec_.input_qty * input_conv_factor_;
         END IF;

         IF (rec_.input_qty IS NOT NULL) THEN
            Client_SYS.Add_To_Attr('INPUT_QTY', rec_.input_qty , attr_);
         END IF;
         IF (input_unit_meas_ IS NOT NULL) THEN
            Client_SYS.Add_To_Attr('INPUT_UNIT_MEAS', input_unit_meas_, attr_);
         END IF;
         IF (input_conv_factor_ IS NOT NULL) THEN
            Client_SYS.Add_To_Attr('INPUT_CONV_FACTOR', input_conv_factor_ , attr_);
         END IF;
         IF (input_variable_values_ IS NOT NULL) THEN
            Client_SYS.Add_To_Attr('INPUT_VARIABLE_VALUES', input_variable_values_, attr_);
         END IF;
      END IF;
   END IF;

   IF (rec_.customer_quantity IS NULL) THEN
      -- Quantity based on quy_qty_due
      Client_SYS.Add_To_Attr('BUY_QTY_DUE', rec_.buy_qty_due , attr_);
   ELSE
      -- Quantity fetched from the cross-reference
      Client_SYS.Add_To_Attr('CUSTOMER_PART_BUY_QTY', rec_.customer_quantity , attr_);
      
      customer_rec_ := Sales_Part_Cross_Reference_API.Get(headrec_.customer_no, headrec_.contract, rec_.customer_part_no);
      IF (customer_rec_.conv_factor IS NULL) THEN
         Client_SYS.Add_To_Attr('BUY_QTY_DUE', rec_.buy_qty_due , attr_);
      ELSE
         Client_SYS.Add_To_Attr('BUY_QTY_DUE', (rec_.customer_quantity * customer_rec_.conv_factor) / customer_rec_.inverted_conv_factor , attr_);
      END IF;
   END IF;

   IF (rec_.sale_unit_price IS NOT NULL OR rec_.unit_price_incl_tax IS NOT NULL) THEN
      company_   := Site_API.Get_Company(headrec_.contract);
      curr_code_ := External_Customer_Order_API.Get_Currency_Code(message_id_);
      Invoice_Library_API.Get_Currency_Rate_Defaults(currency_type_ => curr_type_,
                                                     conv_factor_   => conv_factor_,
                                                     currency_rate_ => curr_rate_,
                                                     company_       => company_,
                                                     currency_code_ => curr_code_,
                                                     date_          => Site_API.Get_Site_Date(headrec_.contract),
                                                     related_to_    => 'CUSTOMER',
                                                     identity_      => NVL(headrec_.customer_no_pay, headrec_.customer_no));
      curr_rate_ := curr_rate_ / conv_factor_;
      IF (rec_.sale_unit_price IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('SALE_UNIT_PRICE', rec_.sale_unit_price, attr_);
         Client_SYS.Add_To_Attr('BASE_SALE_UNIT_PRICE', rec_.sale_unit_price * curr_rate_, attr_);
      END IF;
      IF (rec_.unit_price_incl_tax IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('UNIT_PRICE_INCL_TAX', rec_.unit_price_incl_tax, attr_);
         Client_SYS.Add_To_Attr('BASE_UNIT_PRICE_INCL_TAX', rec_.unit_price_incl_tax * curr_rate_, attr_);
      END IF;
   END IF;

   IF (rec_.discount IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('DISCOUNT', rec_.discount, attr_);
   END IF;

   Client_SYS.Add_To_Attr('CATALOG_DESC', rec_.catalog_desc, attr_);

   Order_Quotation_Line_API.New(info_, attr_);

   -- Update non-default address - must do an update, since the address is inserted via the New method.
   -- Do as it's done in the Order Line Address client dialog - call Line.Modify__ and LineAddress.Change_Address__.
   line_item_no_ := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('LINE_ITEM_NO', attr_));
   configured_line_price_id_ := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('CONFIGURED_LINE_PRICE_ID', attr_));

   Client_SYS.Clear_Attr(attr_);

   -- Transfer the configuration to the quotation
   IF (Sales_Part_API.Get_Configurable_Db(headrec_.contract, catalog_no_) = 'CONFIGURED') THEN
      External_Cust_Order_Char_API.Transfer_Line_Chars(configuration_id_,
                                                       configured_line_price_id_,
                                                       message_id_,
                                                       NULL,
                                                       line_no_,
                                                       rel_no_);

      -- IF configuration was created update configuration id and price information on customer order line
      IF (configuration_id_ IS NOT NULL) THEN

         Configured_Line_Price_API.Get_Pricing_Totals(char_price_,
                                                      calc_char_price_,
                                                      configured_line_price_id_,
                                                      configuration_id_);
         Client_SYS.Clear_Attr(attr_);
         Client_SYS.Add_To_Attr('CONFIGURATION_ID', configuration_id_, attr_);
         Client_SYS.Add_To_Attr('CHAR_PRICE', char_price_, attr_);
         Client_SYS.Add_To_Attr('CALC_CHAR_PRICE', calc_char_price_, attr_);

      END IF;
   END IF;

   IF (rec_.ean_location_del_addr IS NOT NULL) THEN
      -- EAN Location code
      ship_addr_no_ := Cust_Ord_Customer_Address_API.Get_Id_By_Ean_Location(headrec_.customer_no, rec_.ean_location_del_addr);
      Client_SYS.Add_To_Attr('SHIP_ADDR_NO', ship_addr_no_, attr_);
   END IF;

   IF (rec_.delivery_terms IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('DELIVERY_TERMS', rec_.delivery_terms, attr_);
   END IF;

   IF (rec_.del_terms_location IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('DEL_TERMS_LOCATION', rec_.del_terms_location, attr_);
   END IF;

   IF (rec_.ship_via_code IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('SHIP_VIA_CODE', rec_.ship_via_code, attr_);
      IF ship_addr_no_ IS NOT NULL THEN 
         leadtimerec_ := Customer_Address_Leadtime_API.Get(headrec_.customer_no, ship_addr_no_, rec_.ship_via_code, headrec_.contract);
         Client_SYS.Add_To_Attr('DELIVERY_LEADTIME', leadtimerec_.delivery_leadtime, attr_);
         Client_SYS.Add_To_Attr('PICKING_LEADTIME', leadtimerec_.picking_leadtime, attr_);  
      END IF;
   END IF;

   IF (attr_ IS NOT NULL) THEN
      Order_Quotation_Line_API.Modify(attr_, quotation_no_, rec_.line_no, rec_.rel_no, line_item_no_);
      Client_SYS.Clear_Attr(attr_);
   END IF;
END Transfer_Quotation_Line___;


PROCEDURE Do_Set_Head_Error___ (
   rec_  IN OUT EXTERNAL_CUST_ORDER_LINE_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   oldrec_     EXTERNAL_CUST_ORDER_LINE_TAB%ROWTYPE;
   newrec_     EXTERNAL_CUST_ORDER_LINE_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN

   oldrec_ := Lock_By_Keys___(rec_.message_id, rec_.message_line);
   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, attr_); 
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);

   newrec_.error_message := Language_SYS.Translate_Constant(lu_name_,
     'EXTERNAL_ERR_LINE: Error on Message Line :P1. Error Message: :P2',
     NULL, newrec_.message_line, newrec_.error_message);

   External_Customer_Order_API.Set_Head_Error(rec_.message_id, newrec_.error_message);
END Do_Set_Head_Error___;


PROCEDURE Do_Approve___ (
   rec_  IN OUT EXTERNAL_CUST_ORDER_LINE_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   oldrec_        EXTERNAL_CUST_ORDER_LINE_TAB%ROWTYPE;
   newrec_        EXTERNAL_CUST_ORDER_LINE_TAB%ROWTYPE;
   objid_         VARCHAR2(2000);
   objversion_    VARCHAR2(2000);
   info_          VARCHAR2(2000);
   clear_message_ VARCHAR2(2000) := NULL;
   indrec_        Indicator_Rec;
BEGIN

   IF External_Customer_Order_API.Is_Quotation(rec_.message_id) THEN
      Transfer_Quotation_Line___(rec_.message_id, rec_.message_line);
   ELSE
      Transfer_Order_Line___(rec_.message_id, rec_.message_line);
   END IF;

   IF (rec_.error_message IS NOT NULL) THEN
      -- Clear old error message
      oldrec_ := Lock_By_Keys___(rec_.message_id, rec_.message_line);
      newrec_ := oldrec_;
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('ERROR_MESSAGE', clear_message_, attr_);
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
      Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
   END IF;

   Client_SYS.Clear_Attr(attr_);
   Get_Id_Version_By_Keys___(objid_, objversion_, rec_.message_id, rec_.message_line);
   Line_Created__(info_, objid_, objversion_, attr_, 'DO');
END Do_Approve___;


PROCEDURE Do_Set_Head_Changed___ (
   rec_  IN OUT EXTERNAL_CUST_ORDER_LINE_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   External_Customer_Order_API.Set_Head_Changed(rec_.message_id);
END Do_Set_Head_Changed___;

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT external_cust_order_line_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   --Add pre-processing code here
   super(objid_, objversion_, newrec_, attr_);
   IF (newrec_.rental = Fnd_Boolean_API.DB_TRUE) THEN
      New_Rental___(attr_, newrec_);
   END IF;
END Insert___;

@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     EXTERNAL_CUST_ORDER_LINE_TAB%ROWTYPE,
   newrec_     IN OUT EXTERNAL_CUST_ORDER_LINE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   info_  VARCHAR2(2000);
   rowid_ VARCHAR2(2000);
BEGIN
   -- Return error_message to client. May be changed.
   Client_SYS.Add_To_Attr('ERROR_MESSAGE', newrec_.error_message, attr_);

   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   -- Modify_Rental___() method need to call before the Changed__().
   IF (newrec_.rental = Fnd_Boolean_API.DB_TRUE) THEN
      Modify_Rental___(attr_, newrec_);
   END IF;
   IF (newrec_.error_message IS NULL) THEN
      Get_Id_Version_By_Keys___(rowid_, objversion_, newrec_.message_id, newrec_.message_line);
      Changed__(info_, rowid_, objversion_, attr_, 'DO');
   END IF;
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT external_cust_order_line_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   IF (newrec_.rental IS NULL) THEN
      newrec_.rental := Fnd_Boolean_API.DB_FALSE;     
   END IF;
   super(newrec_, indrec_, attr_);
   IF (newrec_.delivery_terms IS NULL) THEN
      newrec_.delivery_terms_desc := NULL;
   END IF;
   IF (newrec_.ship_via_code IS NULL) THEN
      newrec_.ship_via_desc := NULL;
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     external_cust_order_line_tab%ROWTYPE,
   newrec_ IN OUT external_cust_order_line_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   -- Clear the error_message.
   IF (indrec_.error_message = FALSE) THEN
      newrec_.error_message := NULL;
   END IF;
   
   super(oldrec_, newrec_, indrec_, attr_);
   
   IF (newrec_.delivery_terms IS NULL) THEN
      newrec_.delivery_terms_desc := NULL;
   END IF;
   IF (newrec_.ship_via_code IS NULL) THEN
      newrec_.ship_via_desc := NULL;
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;

@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN external_cust_order_line_tab%ROWTYPE )
IS
BEGIN   
   super(objid_, remrec_);
   IF (remrec_.rental = Fnd_Boolean_API.DB_TRUE) THEN
      Remove_Rental___(remrec_);
   END IF;
END Delete___;

PROCEDURE New_Rental___ (
   attr_     IN VARCHAR2,
   newrec_   IN EXTERNAL_CUST_ORDER_LINE_TAB%ROWTYPE)
IS
BEGIN   
   IF (attr_ IS NOT NULL) THEN
      $IF Component_Rental_SYS.INSTALLED $THEN
         External_Pur_Order_Message_API.New(newrec_.message_id,
                                            newrec_.message_line,
                                            'ORDERS',
                                            attr_);
      $ELSE
         Error_SYS.Component_Not_Exist('RENTAL');
      $END
   END IF;
END New_Rental___;


-- Modify_Rental___
--   This method modifies a rental record.  
PROCEDURE Modify_Rental___ (
   attr_      IN VARCHAR2,
   newrec_    IN EXTERNAL_CUST_ORDER_LINE_TAB%ROWTYPE)
IS
BEGIN   
   IF (attr_ IS NOT NULL) THEN
      $IF Component_Rental_SYS.INSTALLED $THEN
         External_Pur_Order_Message_API.Modify(newrec_.message_id,
                                               newrec_.message_line,
                                               'ORDERS',
                                               attr_);
      $ELSE
         Error_SYS.Component_Not_Exist('RENTAL');
      $END
   END IF;
END Modify_Rental___;

-- Remove_Rental___
--   This method removes a rental record.
PROCEDURE Remove_Rental___ (
   remrec_ IN EXTERNAL_CUST_ORDER_LINE_TAB%ROWTYPE)
IS
BEGIN   
   $IF Component_Rental_SYS.INSTALLED $THEN
      External_Pur_Order_Message_API.Remove(remrec_.message_id,
                                            remrec_.message_line,
                                            'ORDERS');
   $ELSE
      NULL;
   $END
END Remove_Rental___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- New
--   Creates a new record with specified attributes.
PROCEDURE New (
   attr_ IN VARCHAR2 )
IS
   newrec_     EXTERNAL_CUST_ORDER_LINE_TAB%ROWTYPE;
   newattr_    VARCHAR2(32000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN
   newattr_ := attr_;
   Unpack___(newrec_, indrec_, newattr_);
   Check_Insert___(newrec_, indrec_, newattr_);
   Insert___(objid_, objversion_, newrec_, newattr_);
END New;


-- Set_Line_Approve
--   Approve the (create Customer Order Line) and change status to 'Created'.
--   If an error occurs, an execption is trapped and the error message is stored.
PROCEDURE Set_Line_Approve (
   message_id_   IN NUMBER,
   message_line_ IN NUMBER )
IS
   info_       VARCHAR2(2000);
   attr_       VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, message_id_, message_line_);
   Client_SYS.Clear_Attr(attr_);
   Approve__(info_, objid_, objversion_, attr_, 'DO');
END Set_Line_Approve;


-- Set_Line_Cancel
--   Changes the state to 'Canceled'
PROCEDURE Set_Line_Cancel (
   message_id_   IN NUMBER,
   message_line_ IN NUMBER )
IS
   info_       VARCHAR2(2000);
   attr_       VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, message_id_, message_line_);
   Client_SYS.Clear_Attr(attr_);
   Cancel__(info_, objid_, objversion_, attr_, 'DO');
END Set_Line_Cancel;


-- Set_Line_Error
--   Sets the state to 'Error' and stores the error message
PROCEDURE Set_Line_Error (
   message_id_    IN NUMBER,
   message_line_  IN NUMBER,
   error_message_ IN VARCHAR2 )
IS
   info_       VARCHAR2(2000);
   attr_       VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, message_id_, message_line_);
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('ERROR_MESSAGE', error_message_, attr_);
   Line_Creation_Error__(info_, objid_, objversion_, attr_, 'DO');
END Set_Line_Error;

-- Transfer_New_Ord_Line
--   This method will include common code to handle new line via ORDERS and ORDCHG.   
PROCEDURE Transfer_New_Ord_Line (
   set_freeze_flag_      OUT    BOOLEAN,
   catalog_no_           OUT    VARCHAR2,
   sp_tax_class_id_      OUT    VARCHAR2,
   orig_order_no_        OUT    VARCHAR2,
   orig_line_no_         OUT    VARCHAR2,
   orig_rel_no_          OUT    VARCHAR2,
   orig_line_item_no_    OUT    NUMBER,
   po_contract_          OUT    VARCHAR2, 
   default_addr_flag_    OUT    VARCHAR2,
   single_occurence_     OUT    BOOLEAN,
   attr_                 IN OUT VARCHAR2,
   demand_code_db_       IN OUT VARCHAR2,
   message_id_           IN     NUMBER,
   message_line_         IN     NUMBER,
   order_no_             IN     VARCHAR2, 
   co_customer_no_       IN     VARCHAR2,
   co_contract_          IN     VARCHAR2,
   co_internal_po_no_    IN     VARCHAR2,
   lu_type_              IN     VARCHAR2,
   co_customer_no_pay_   IN     VARCHAR2,
   ship_addr_no_         IN     VARCHAR2,
   co_addr_flag_         IN     VARCHAR2 )
IS
   line_no_                    VARCHAR2(2000);
   rel_no_                     VARCHAR2(2000);
   wanted_delivery_date_       DATE;
   notes_                      VARCHAR2(2000);
   deliver_to_customer_no_     VARCHAR2(20);
   temp_catalog_no_            VARCHAR2(2000);
   ext_cust_ord_line_rec_      EXTERNAL_CUST_ORDER_LINE_TAB%ROWTYPE;
   customer_part_no_           VARCHAR2(2000);
   gtin_no_                    VARCHAR2(2000);
   invalid_customer_part_no_   BOOLEAN := FALSE;
   classification_standard_    VARCHAR2(2000);
   temp_classi_part_no_        VARCHAR2(2000);
   temp_classi_unit_meas_      VARCHAR2(2000);
   classification_part_no_     VARCHAR2(2000);
   classification_unit_meas_   VARCHAR2(2000);
   gtin_part_no_               VARCHAR2(2000) := NULL;
   input_qty_                  NUMBER;
   buy_qty_due_                NUMBER;
   input_variable_values_      VARCHAR2(2000);
   input_unit_meas_            VARCHAR2(30);
   input_conv_factor_          NUMBER;
   customer_quantity_          NUMBER;
   sale_unit_price_            NUMBER;
   unit_price_incl_tax_        NUMBER;
   company_                    VARCHAR2(20);
   curr_code_                  VARCHAR2(20);
   curr_rate_                  NUMBER;
   curr_type_                  VARCHAR2(20);
   conv_factor_                NUMBER;
   ext_cust_ord_line_chg_rec_  EXT_CUST_ORDER_LINE_CHANGE_TAB%ROWTYPE;
   cust_rec_                   Cust_Ord_Customer_API.Public_Rec;
   inventory_flag_db_          VARCHAR2(1);
   discount_                   NUMBER;
   catalog_desc_               VARCHAR2(2000);
   forward_agent_id_           VARCHAR2(2000);
   condition_code_             VARCHAR2(2000);
   sales_part_rec_             Sales_Part_API.public_rec;
   $IF Component_Purch_SYS.INSTALLED $THEN
      purchase_part_rec_       Purchase_Part_API.Public_Rec;
   $END
   location_                   VARCHAR2(2000);
   dock_code_                  VARCHAR2(2000); 
   sub_dock_code_              VARCHAR2(2000);
   intrastat_exempt_           VARCHAR2(20);
   shipment_creation_          VARCHAR2(25); 
   shipment_type_              VARCHAR2(3); 
   packing_instruction_id_     VARCHAR2(50); 
   originating_co_lang_code_   VARCHAR2(2);
   cust_calendar_id_           VARCHAR2(10);
   ext_transport_calendar_id_  VARCHAR2(10); 
   contact_                    VARCHAR2(100);    
   orig_attr_                  VARCHAR2(2000);
   ean_location_del_addr_      VARCHAR2(2000);
   message_type_               VARCHAR2(6);
   rental_                     VARCHAR2(5);
   ship_via_code_              VARCHAR2(2000);
   delivery_terms_             VARCHAR2(2000);
   del_terms_location_         VARCHAR2(2000); 
   delivery_address_name_      VARCHAR2(2000);
   ship_address1_              VARCHAR2(2000);
   ship_address2_              VARCHAR2(2000);
   ship_address3_              VARCHAR2(2000);
   ship_address4_              VARCHAR2(2000);
   ship_address5_              VARCHAR2(2000);
   ship_address6_              VARCHAR2(2000);
   ship_zip_code_              VARCHAR2(2000);
   ship_city_                  VARCHAR2(2000);
   ship_state_                 VARCHAR2(2000);
   country_code_               VARCHAR2(2000);
   ship_county_                VARCHAR2(2000);
   in_city_                    VARCHAR2(2000);
   tax_liability_type_         VARCHAR2(20);
   tax_liability_              VARCHAR2(20);
   vat_no_                     VARCHAR2(50);
   vat_free_vat_code_          VARCHAR2(20);
   tax_id_validated_date_      DATE;
   district_code_              VARCHAR2(10);
   region_code_                VARCHAR2(10);
   head_addr_rec_              Customer_Order_Address_API.Cust_Ord_Addr_Rec;
   addr_flag_                  VARCHAR2(1);
   header_ean_deliv_           VARCHAR2(2000);
   ext_cust_order_change_rec_   Ext_Cust_Order_Change_API.public_rec;
   external_customer_order_rec_ External_Customer_Order_API.public_rec;
   customer_rec_               Sales_Part_Cross_Reference_API.Public_Rec;
   customer_po_line_no_        VARCHAR2(4);
   customer_po_rel_no_         VARCHAR2(4);
   company_gtin_prifix_        VARCHAR2(15);
   
   $IF Component_Rental_SYS.INSTALLED $THEN
      po_rental_rec_         Rental_Object_API.Public_Rec;
      replacement_rental_no_ NUMBER;
      primary_rental_no_     NUMBER;
      int_cust_order_no_     VARCHAR2(12);
      int_co_line_no_        VARCHAR2(4);
      int_co_rel_no_         VARCHAR2(4);
      int_co_line_item_no_   NUMBER;
   $END
   
   CURSOR get_ext_cust_ord_line_chg_info IS
      SELECT *
        FROM ext_cust_order_line_change_tab
       WHERE message_id = message_id_
         AND message_line = message_line_;
BEGIN
   set_freeze_flag_ := FALSE;
   cust_rec_        := Cust_Ord_Customer_API.Get(co_customer_no_);
   IF (lu_type_ = 'ExternalCustOrderLine') THEN
      ext_cust_ord_line_rec_     := Get_Object_By_Keys___(message_id_, message_line_);
      line_no_                   := ext_cust_ord_line_rec_.line_no;               
      rel_no_                    := ext_cust_ord_line_rec_.rel_no;                
      wanted_delivery_date_      := ext_cust_ord_line_rec_.wanted_delivery_date; 
      notes_                     := ext_cust_ord_line_rec_.notes;                 
      deliver_to_customer_no_    := ext_cust_ord_line_rec_.deliver_to_customer_no;
      catalog_no_                := ext_cust_ord_line_rec_.catalog_no;
      temp_catalog_no_           := ext_cust_ord_line_rec_.catalog_no;
      customer_part_no_          := ext_cust_ord_line_rec_.customer_part_no;
      gtin_no_                   := ext_cust_ord_line_rec_.gtin_no;
      classification_standard_   := ext_cust_ord_line_rec_.classification_standard;
      classification_part_no_    := ext_cust_ord_line_rec_.classification_part_no;
      classification_unit_meas_  := ext_cust_ord_line_rec_.classification_unit_meas; 
      buy_qty_due_               := ext_cust_ord_line_rec_.buy_qty_due;
      customer_quantity_         := ext_cust_ord_line_rec_.customer_quantity;
      input_qty_                 := ext_cust_ord_line_rec_.input_qty;
      sale_unit_price_           := ext_cust_ord_line_rec_.sale_unit_price;
      unit_price_incl_tax_       := ext_cust_ord_line_rec_.unit_price_incl_tax; 
      inventory_flag_db_         := ext_cust_ord_line_rec_.inventory_flag_db;
      discount_                  := ext_cust_ord_line_rec_.discount;
      forward_agent_id_          := ext_cust_ord_line_rec_.forward_agent_id;
      condition_code_            := ext_cust_ord_line_rec_.condition_code;
      catalog_desc_              := ext_cust_ord_line_rec_.catalog_desc;
      location_                  := ext_cust_ord_line_rec_.location;
      dock_code_                 := ext_cust_ord_line_rec_.dock_code;
      sub_dock_code_             := ext_cust_ord_line_rec_.sub_dock_code;   
      intrastat_exempt_          := ext_cust_ord_line_rec_.intrastat_exempt; 
      shipment_creation_         := ext_cust_ord_line_rec_.shipment_creation; 
      shipment_type_             := ext_cust_ord_line_rec_.shipment_type; 
      packing_instruction_id_    := ext_cust_ord_line_rec_.packing_instruction_id;  
      originating_co_lang_code_  := ext_cust_ord_line_rec_.originating_co_lang_code; 
      cust_calendar_id_          := ext_cust_ord_line_rec_.cust_calendar_id;
      ext_transport_calendar_id_ := ext_cust_ord_line_rec_.ext_transport_calendar_id;
      contact_                   := ext_cust_ord_line_rec_.contact;
      deliver_to_customer_no_    := ext_cust_ord_line_rec_.deliver_to_customer_no;
      ean_location_del_addr_     := ext_cust_ord_line_rec_.ean_location_del_addr;
      rental_                    := ext_cust_ord_line_rec_.rental;
      ship_via_code_             := ext_cust_ord_line_rec_.ship_via_code;
      delivery_terms_            := ext_cust_ord_line_rec_.delivery_terms; 
      del_terms_location_        := ext_cust_ord_line_rec_.del_terms_location;
      delivery_address_name_     := ext_cust_ord_line_rec_.delivery_address_name;
      ship_address1_             := ext_cust_ord_line_rec_.ship_address1;
      ship_address2_             := ext_cust_ord_line_rec_.ship_address2;
      ship_address3_             := ext_cust_ord_line_rec_.ship_address3;
      ship_address4_             := ext_cust_ord_line_rec_.ship_address4;
      ship_address5_             := ext_cust_ord_line_rec_.ship_address5;
      ship_address6_             := ext_cust_ord_line_rec_.ship_address6;
      ship_zip_code_             := ext_cust_ord_line_rec_.ship_zip_code;
      ship_city_                 := ext_cust_ord_line_rec_.ship_city;
      ship_state_                := ext_cust_ord_line_rec_.ship_state;
      country_code_              := ext_cust_ord_line_rec_.country_code;
      ship_county_               := ext_cust_ord_line_rec_.ship_county;
      in_city_                   := ext_cust_ord_line_rec_.in_city;
      tax_liability_             := ext_cust_ord_line_rec_.tax_liability;
      vat_no_                    := ext_cust_ord_line_rec_.vat_no;
      vat_free_vat_code_         := ext_cust_ord_line_rec_.vat_free_vat_code;
      tax_id_validated_date_     := ext_cust_ord_line_rec_.tax_id_validated_date;    
      district_code_             := ext_cust_ord_line_rec_.district_code; 
      region_code_               := ext_cust_ord_line_rec_.region_code;
      customer_po_line_no_       := ext_cust_ord_line_rec_.customer_po_line_no;
      customer_po_rel_no_        := ext_cust_ord_line_rec_.customer_po_rel_no;
      external_customer_order_rec_ := External_Customer_Order_API.Get(message_id_);
      header_ean_deliv_            := external_customer_order_rec_.ean_location_del_addr;
      curr_code_                   := external_customer_order_rec_.currency_code;
      message_type_                := 'ORDERS';
   ELSIF (lu_type_ = 'ExtCustOrderLineChange') THEN
      
      OPEN  get_ext_cust_ord_line_chg_info;
      FETCH get_ext_cust_ord_line_chg_info INTO ext_cust_ord_line_chg_rec_;
      CLOSE get_ext_cust_ord_line_chg_info;
      
      line_no_                   := ext_cust_ord_line_chg_rec_.line_no;               
      rel_no_                    := ext_cust_ord_line_chg_rec_.rel_no;                
      wanted_delivery_date_      := ext_cust_ord_line_chg_rec_.wanted_delivery_date; 
      notes_                     := ext_cust_ord_line_chg_rec_.notes;                 
      deliver_to_customer_no_    := ext_cust_ord_line_chg_rec_.deliver_to_customer_no;
      catalog_no_                := ext_cust_ord_line_chg_rec_.catalog_no;
      temp_catalog_no_           := ext_cust_ord_line_chg_rec_.catalog_no;
      customer_part_no_          := ext_cust_ord_line_chg_rec_.customer_part_no;
      gtin_no_                   := ext_cust_ord_line_chg_rec_.gtin_no;
      classification_standard_   := ext_cust_ord_line_chg_rec_.classification_standard;
      classification_part_no_    := ext_cust_ord_line_chg_rec_.classification_part_no;
      classification_unit_meas_  := ext_cust_ord_line_chg_rec_.classification_unit_meas; 
      buy_qty_due_               := ext_cust_ord_line_chg_rec_.buy_qty_due;
      customer_quantity_         := ext_cust_ord_line_chg_rec_.customer_quantity;
      input_qty_                 := ext_cust_ord_line_chg_rec_.input_qty;
      sale_unit_price_           := ext_cust_ord_line_chg_rec_.sale_unit_price;
      unit_price_incl_tax_       := ext_cust_ord_line_chg_rec_.unit_price_incl_tax;
      $IF (Component_Purch_SYS.INSTALLED) $THEN
         purchase_part_rec_      := Purchase_Part_API.Get(cust_rec_.acquisition_site, customer_part_no_);
         inventory_flag_db_      := purchase_part_rec_.inventory_flag;
      $END
      discount_                  := ext_cust_ord_line_chg_rec_.discount;
      forward_agent_id_          := ext_cust_ord_line_chg_rec_.forward_agent_id;
      condition_code_            := ext_cust_ord_line_chg_rec_.condition_code;
      catalog_desc_              := ext_cust_ord_line_chg_rec_.catalog_desc;
      location_                  := ext_cust_ord_line_chg_rec_.location;
      dock_code_                 := ext_cust_ord_line_chg_rec_.dock_code;
      sub_dock_code_             := ext_cust_ord_line_chg_rec_.sub_dock_code; 
      intrastat_exempt_          := ext_cust_ord_line_chg_rec_.intrastat_exempt;
      shipment_creation_         := ext_cust_ord_line_chg_rec_.shipment_creation; 
      shipment_type_             := ext_cust_ord_line_chg_rec_.shipment_type; 
      packing_instruction_id_    := ext_cust_ord_line_chg_rec_.packing_instruction_id;  
      originating_co_lang_code_  := ext_cust_ord_line_chg_rec_.originating_co_lang_code; 
      cust_calendar_id_          := ext_cust_ord_line_chg_rec_.cust_calendar_id;
      ext_transport_calendar_id_ := ext_cust_ord_line_chg_rec_.ext_transport_calendar_id;
      contact_                   := ext_cust_ord_line_chg_rec_.contact;
      deliver_to_customer_no_    := ext_cust_ord_line_chg_rec_.deliver_to_customer_no;
      ean_location_del_addr_     := ext_cust_ord_line_chg_rec_.ean_location_del_addr;
      rental_                    := ext_cust_ord_line_chg_rec_.rental;
      ship_via_code_             := ext_cust_ord_line_chg_rec_.ship_via_code;
      delivery_terms_            := ext_cust_ord_line_chg_rec_.delivery_terms; 
      del_terms_location_        := ext_cust_ord_line_chg_rec_.del_terms_location;
      delivery_address_name_     := ext_cust_ord_line_chg_rec_.delivery_address_name;
      ship_address1_             := ext_cust_ord_line_chg_rec_.ship_address1;
      ship_address2_             := ext_cust_ord_line_chg_rec_.ship_address2;
      ship_address3_             := ext_cust_ord_line_chg_rec_.ship_address3;
      ship_address4_             := ext_cust_ord_line_chg_rec_.ship_address4;
      ship_address5_             := ext_cust_ord_line_chg_rec_.ship_address5;
      ship_address6_             := ext_cust_ord_line_chg_rec_.ship_address6;
      ship_zip_code_             := ext_cust_ord_line_chg_rec_.ship_zip_code;
      ship_city_                 := ext_cust_ord_line_chg_rec_.ship_city;
      ship_state_                := ext_cust_ord_line_chg_rec_.ship_state;
      country_code_              := ext_cust_ord_line_chg_rec_.country_code;
      ship_county_               := ext_cust_ord_line_chg_rec_.ship_county;
      in_city_                   := NULL;
      tax_liability_             := ext_cust_ord_line_chg_rec_.tax_liability;
      vat_no_                    := ext_cust_ord_line_chg_rec_.vat_no;
      vat_free_vat_code_         := ext_cust_ord_line_chg_rec_.vat_free_vat_code;
      tax_id_validated_date_     := ext_cust_ord_line_chg_rec_.tax_id_validated_date;
      district_code_             := ext_cust_ord_line_chg_rec_.district_code; 
      region_code_               := ext_cust_ord_line_chg_rec_.region_code;
      customer_po_line_no_       := ext_cust_ord_line_chg_rec_.customer_po_line_no;
      customer_po_rel_no_        := ext_cust_ord_line_chg_rec_.customer_po_rel_no;
      ext_cust_order_change_rec_ := Ext_Cust_Order_Change_API.Get(message_id_);
      header_ean_deliv_          := ext_cust_order_change_rec_.ean_location_del_addr;
      curr_code_                 := ext_cust_order_change_rec_.currency_code;
      message_type_              := 'ORDCHG';
   END IF;
   
   Client_SYS.Add_To_Attr('ORDER_NO',               order_no_,              attr_);
   Client_SYS.Add_To_Attr('LINE_NO',                line_no_ ,              attr_);
   Client_SYS.Add_To_Attr('REL_NO',                 rel_no_ ,               attr_);
   Client_SYS.Add_To_Attr('LINE_ITEM_NO',           0,                      attr_);
   Client_SYS.Add_To_Attr('CONTRACT',               co_contract_,           attr_);
   Client_SYS.Add_To_Attr('WANTED_DELIVERY_DATE',   wanted_delivery_date_ , attr_);
   Client_SYS.Add_To_Attr('PLANNED_DELIVERY_DATE',  wanted_delivery_date_ , attr_);
   Client_SYS.Add_To_Attr('NOTE_TEXT',              notes_,                 attr_);
   Client_SYS.Add_To_Attr('DELIVER_TO_CUSTOMER_NO', NVL(deliver_to_customer_no_, co_customer_no_) , attr_);
   Client_SYS.Add_To_Attr('CUSTOMER_PO_LINE_NO',    NVL(customer_po_line_no_, line_no_),            attr_);
   Client_SYS.Add_To_Attr('CUSTOMER_PO_REL_NO',     NVL(customer_po_rel_no_, rel_no_),              attr_);

   -- Get sale part number for the GTIN
   IF (gtin_no_ IS NOT NULL) THEN
      gtin_part_no_ := Sales_Part_API.Get_Catalog_No_By_Gtin_No(gtin_no_, co_contract_);
   END IF;
   -- Get sale part number from customer part number
   IF (catalog_no_ IS NULL) THEN
      -- Get sales part number from customer part number
      IF (customer_part_no_ IS NOT NULL) THEN
         catalog_no_ := Sales_Part_Cross_Reference_API.Get_Catalog_No(co_customer_no_, co_contract_, customer_part_no_);
         -- If internal PO is used
         IF (catalog_no_ IS NULL AND co_internal_po_no_ IS NOT NULL ) THEN
            -- If the sales part available in both sites, customer_part_no can be used in place of catalog_no, even though Sales_Part_Cross_Reference not entered
            catalog_no_ := customer_part_no_;
            IF (Inventory_Part_API.Check_Exist(co_contract_, customer_part_no_)) THEN
               IF (customer_part_no_ != NVL(Sales_Part_API.Get_Part_No(co_contract_, customer_part_no_), Database_SYS.string_null_)) THEN
                  -- Set the sales part in supply site which is connected to the inventory part in
                  -- demand site as the catalog_no, even though Sales_Part_Cross_Reference not entered
                  catalog_no_ := Sales_Part_API.Get_Catalog_No_For_Part_No(co_contract_, customer_part_no_);
               END IF;
            ELSE
               IF Sales_Part_API.Check_Exist(co_contract_, catalog_no_) = 0 THEN
                  catalog_no_ := NVL(Sales_Part_API.Get_Catalog_No_For_Purch_No(co_contract_, catalog_no_), catalog_no_);
               END IF;
            END IF;
         ELSIF (catalog_no_ IS NULL) THEN
            Error_SYS.Record_General(lu_name_, 'CUSTOMERPARTNOERROR: Customer''s part number :P1 does not exist in sales part cross reference for customer :P2 and site :P3.' , customer_part_no_, co_customer_no_, co_contract_);
         END IF;
      END IF;
   END IF;
   
   IF (classification_standard_ IS NOT NULL) THEN
      -- retrieve the catalog no from the std classification code
      temp_classi_part_no_   := classification_part_no_;
      temp_classi_unit_meas_ := classification_unit_meas_;
      Assortment_Node_API.Get_Classification_Defaults(temp_classi_unit_meas_,
                                                      temp_catalog_no_,
                                                      temp_classi_part_no_,
                                                      classification_standard_,
                                                      'TRUE');

      IF (classification_part_no_ IS NOT NULL AND temp_classi_part_no_ IS NOT NULL AND temp_classi_part_no_ != classification_part_no_) THEN
         Error_SYS.Record_General(lu_name_, 'CLASSIPARTDIFF: Classification part no :P1 of external order line does not match with :P2 of the system.', classification_part_no_, temp_classi_part_no_);
      END IF;
      IF (classification_unit_meas_ IS NOT NULL AND temp_classi_unit_meas_ IS NOT NULL AND temp_classi_unit_meas_ != classification_unit_meas_) THEN
         Error_SYS.Record_General(lu_name_, 'CLASSIUOMDIFF: Classification unit of measure :P1 of external order line does not match with :P2 of the system.', classification_unit_meas_, temp_classi_unit_meas_);
      END IF;
      IF (temp_classi_part_no_ IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('CLASSIFICATION_STANDARD',  classification_standard_, attr_);
         Client_SYS.Add_To_Attr('CLASSIFICATION_PART_NO',   temp_classi_part_no_ ,    attr_);
         Client_SYS.Add_To_Attr('CLASSIFICATION_UNIT_MEAS', temp_classi_unit_meas_ ,  attr_);
      END IF;
      IF (catalog_no_ IS NULL) THEN
         catalog_no_ := temp_catalog_no_;
      END IF;
   END IF;
   
   IF (gtin_no_ IS NOT NULL) THEN
      IF (gtin_part_no_ IS NOT NULL ) THEN
         -- Catalog number will empty when no catalog, customer part or clasification standard used but the gtin.
         IF (catalog_no_ IS NULL) THEN
            catalog_no_ := gtin_part_no_;
         END IF;
      END IF;
      IF (gtin_part_no_ IS NULL AND gtin_no_ IS NOT NULL AND catalog_no_ IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'NOCATNOBYGTIN: Cannot find a valid sales part for the GTIN.');
      END IF;

      IF (NVL(catalog_no_, '') != NVL(gtin_part_no_, '')) THEN
         Error_SYS.Record_General(lu_name_, 'NOMATCHCATNOBYGTIN: The received GTIN is not connected to the received Sales Part.');
      END IF;
      
      IF (NVL(Part_Gtin_Unit_Meas_API.Get_Part_Via_Identified_Gtin(gtin_no_), Database_SYS.string_null_) = gtin_part_no_) THEN
         input_unit_meas_       := Part_Gtin_Unit_Meas_API.Get_Unit_Code_For_Gtin14(gtin_no_);
         input_conv_factor_     := Input_Unit_Meas_API.Get_Conversion_Factor(Part_Catalog_API.Get_Input_Unit_Meas_Group_Id(gtin_part_no_),
                                                                             input_unit_meas_);
         input_variable_values_ := Input_Unit_Meas_API.Get_Input_Value_String(input_qty_, 
                                                                              input_unit_meas_);

         IF (buy_qty_due_ IS NOT NULL AND input_qty_ IS NOT NULL) THEN
            IF (buy_qty_due_ != input_qty_ * input_conv_factor_) THEN
               Error_SYS.Record_General(lu_name_, 'INCORRECTQTY: The relation between the received Sales Qty and the received Input Qty is not correct according to Input Conversion Factor');
            END IF;
         ELSIF (buy_qty_due_ IS NOT NULL AND input_qty_ IS NULL) THEN
            input_qty_   := buy_qty_due_ / input_conv_factor_;
         ELSIF (buy_qty_due_ IS NULL AND input_qty_ IS NOT NULL) THEN
            buy_qty_due_ := input_qty_ * input_conv_factor_;
         END IF;

         IF (input_qty_ IS NOT NULL) THEN
            Client_SYS.Add_To_Attr('INPUT_QTY', input_qty_, attr_);
         END IF;
         
         IF (input_unit_meas_ IS NOT NULL) THEN
            Client_SYS.Add_To_Attr('INPUT_UNIT_MEAS', input_unit_meas_ , attr_);
         END IF;
         
         IF (input_conv_factor_ IS NOT NULL) THEN
            Client_SYS.Add_To_Attr('INPUT_CONV_FACTOR', input_conv_factor_, attr_);
         END IF;
         
         IF input_variable_values_ IS NOT NULL THEN
            Client_SYS.Add_To_Attr('INPUT_VARIABLE_VALUES', input_variable_values_, attr_);
         END IF;
         
      END IF;
   END IF;
   
   Client_SYS.Add_To_Attr('CATALOG_NO', catalog_no_ , attr_);
   IF (customer_part_no_ IS NOT NULL AND NVL(Sales_Part_Cross_Reference_API.Get_Catalog_No(co_customer_no_, co_contract_, customer_part_no_), '') = NVL(catalog_no_, '')) THEN
      Client_SYS.Add_To_Attr('CUSTOMER_PART_NO', customer_part_no_, attr_);
   END IF;
   
    sales_part_rec_  := Sales_Part_API.Get(co_contract_, catalog_no_);
    sp_tax_class_id_ := sales_part_rec_.tax_class_id;
    head_addr_rec_   := Customer_Order_Address_API.Get_Cust_Ord_Addr(order_no_);
    -- For same companies in our sites make sure that the parts
    -- are either an inventory part at both sites or a
    -- non-inventory part at both sites
    IF (Site_API.Get_Company(co_contract_) = Site_API.Get_Company(cust_rec_.acquisition_site))THEN
       IF (((inventory_flag_db_ = 'Y') AND (sales_part_rec_.catalog_type = 'NON')) OR 
          ((inventory_flag_db_ = 'N') AND (sales_part_rec_.catalog_type = 'INV')) OR
          ((inventory_flag_db_ IS NULL) AND (sales_part_rec_.catalog_type = 'INV'))) THEN
          Error_SYS.Record_General(lu_name_, 'PART_MIXED: A mix of Inventory and Non Inventory Parts are not allowed for Inter-Site transactions between two sites connected to the same company.');
       END IF;
    END IF;   

   IF ((customer_quantity_ IS NULL) OR (gtin_no_ IS NOT NULL)) THEN
      -- Quantity based on quy_qty_due
      Client_SYS.Add_To_Attr('BUY_QTY_DUE', buy_qty_due_, attr_);
   ELSE
      -- Quantity fetched from the cross-reference
      Client_SYS.Add_To_Attr('CUSTOMER_PART_BUY_QTY', customer_quantity_, attr_);
      customer_rec_ := Sales_Part_Cross_Reference_API.Get(co_customer_no_, co_contract_, customer_part_no_);
      IF (customer_rec_.conv_factor IS NULL) THEN
         Client_SYS.Add_To_Attr('BUY_QTY_DUE', buy_qty_due_ , attr_);
      ELSE
         Client_SYS.Add_To_Attr('BUY_QTY_DUE', (customer_quantity_ * customer_rec_.conv_factor) / customer_rec_.inverted_conv_factor , attr_);
      END IF;
   END IF;

   IF (sale_unit_price_ IS NOT NULL OR unit_price_incl_tax_ IS NOT NULL) THEN
      company_   := Site_API.Get_Company(co_contract_);
      Invoice_Library_API.Get_Currency_Rate_Defaults(currency_type_ => curr_type_,
                                                     conv_factor_   => conv_factor_,
                                                     currency_rate_ => curr_rate_,
                                                     company_       => company_,
                                                     currency_code_ => curr_code_,
                                                     date_          => Site_API.Get_Site_Date(co_contract_),
                                                     related_to_    => 'CUSTOMER',
                                                     identity_      => NVL(co_customer_no_pay_, co_customer_no_) );
      curr_rate_ := curr_rate_ / conv_factor_;
   
      IF (sale_unit_price_ IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('SALE_UNIT_PRICE',          sale_unit_price_,                  attr_);
         Client_SYS.Add_To_Attr('BASE_SALE_UNIT_PRICE',     sale_unit_price_ * curr_rate_,     attr_);
      END IF;
      IF (unit_price_incl_tax_ IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('UNIT_PRICE_INCL_TAX',      unit_price_incl_tax_,              attr_);
         Client_SYS.Add_To_Attr('BASE_UNIT_PRICE_INCL_TAX', unit_price_incl_tax_ * curr_rate_, attr_);
      END IF;
      -- price freeze flag need to be set after creation of the customer order line
      set_freeze_flag_ := TRUE;
   END IF;

   IF (discount_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('DISCOUNT', discount_, attr_);
   ELSE
      -- To identify COL is created externally from Customer_Order_Line_API.New() andto fetch correct discount information when exteranl discount is NULL.
      -- Discount fetching logic exists in Customer_Order_Line_API.Post_Insert_Actions___() and further it fetches from Customer_Order_Line_API.New().
      -- Note that it should always Prioritize of exteranl discount than the default fetching logic
      Client_SYS.Add_To_Attr('COPY_DISCOUNT', 'FALSE', attr_);      
   END IF;
   
   IF (catalog_desc_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('CATALOG_DESC', catalog_desc_, attr_);
   END IF;
   
   IF (forward_agent_id_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('FORWARD_AGENT_ID', forward_agent_id_, attr_);
   END IF;
   
   IF (condition_code_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('CONDITION_CODE', condition_code_, attr_);
   END IF;

   IF (location_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('LOCATION_NO', location_, attr_);
   END IF;
         
   IF (dock_code_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('DOCK_CODE', dock_code_ , attr_);
   END IF;
         
   IF (sub_dock_code_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('SUB_DOCK_CODE', sub_dock_code_ , attr_);
   END IF;  
   
   Client_SYS.Add_To_Attr('SHIP_VIA_CODE',      ship_via_code_,      attr_);
   Client_SYS.Add_To_Attr('DELIVERY_TERMS',     delivery_terms_,     attr_);
   Client_SYS.Add_To_Attr('DEL_TERMS_LOCATION', del_terms_location_, attr_);   
   
   IF (co_internal_po_no_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('DEMAND_ORDER_REF1', co_internal_po_no_, attr_);
      Client_SYS.Add_To_Attr('DEMAND_ORDER_REF2', line_no_,           attr_);
      Client_SYS.Add_To_Attr('DEMAND_ORDER_REF3', rel_no_,            attr_);
   END IF;  
   
   -- When IPD and Single occurrence, ean_location_del_addr and deliver_to_customer_no always null
   IF ((ean_location_del_addr_ IS NULL) AND (header_ean_deliv_ IS NULL)) THEN
      addr_flag_ := 'Y';
   ELSE
      addr_flag_ := 'N';
   END IF;
   
   IF(ship_addr_no_ IS NULL) THEN 
      IF (delivery_address_name_ IS NULL) AND (ship_address1_ IS NULL) AND
         (ship_address2_ IS NULL) AND (ship_address3_ IS NULL) AND (ship_address4_ IS NULL) AND
         (ship_address5_ IS NULL) AND (ship_address6_ IS NULL) AND (ship_zip_code_ IS NULL) AND
         (ship_city_ IS NULL) AND (ship_state_ IS NULL) AND
         (country_code_ IS NULL) AND (ship_county_ IS NULL) AND (co_addr_flag_ = 'Y') THEN
            -- No address has been passed but the order address is a single occurance
            -- so the address needs to be fetched from the order head address.
            delivery_address_name_ := head_addr_rec_.addr_1;
            ship_address1_         := head_addr_rec_.address1;
            ship_address2_         := head_addr_rec_.address2;
            ship_address3_         := head_addr_rec_.address3;
            ship_address4_         := head_addr_rec_.address4;
            ship_address5_         := head_addr_rec_.address5;
            ship_address6_         := head_addr_rec_.address6;
            ship_zip_code_         := head_addr_rec_.zip_code;
            ship_city_             := head_addr_rec_.city;
            ship_state_            := head_addr_rec_.state;
            country_code_          := head_addr_rec_.country_code;
            ship_county_           := head_addr_rec_.county;
            in_city_               := head_addr_rec_.in_city;
      END IF;
      IF ((delivery_address_name_ IS NOT NULL) OR (ship_address1_ IS NOT NULL) OR
            (ship_address2_ IS NOT NULL) OR (ship_address3_ IS NOT NULL) OR (ship_address4_ IS NOT NULL) OR
            (ship_address5_ IS NOT NULL) OR (ship_address6_ IS NOT NULL) OR (ship_zip_code_ IS NOT NULL) OR
            (ship_city_ IS NOT NULL) OR (ship_state_ IS NOT NULL) OR
            (country_code_ IS NOT NULL) OR (ship_county_ IS NOT NULL)) THEN
            -- Single occurence address
            addr_flag_ := 'Y';
            single_occurence_ := TRUE;
         IF (ean_location_del_addr_ IS NULL) THEN
               --             Cust_Ord_Customer_API.Get_Delivery_Address() instead of Customer_Info_Address_API.Get_Default_Address() because when there is no default 
               --             delivery address, the system should get the first delivery address which could be found.
               Client_SYS.Set_Item_Value('SHIP_ADDR_NO', Cust_Ord_Customer_API.Get_Delivery_Address(NVL(deliver_to_customer_no_, co_customer_no_)), attr_);
            END IF;
         ELSE
            addr_flag_ := co_addr_flag_;
      END IF;   
   END IF;

   IF (demand_code_db_ = 'IPD') THEN
      Client_SYS.Set_Item_Value('INTRASTAT_EXEMPT_DB',       intrastat_exempt_,          attr_);
      IF (shipment_creation_ IS NOT NULL ) THEN
         Client_SYS.Add_To_Attr('SHIPMENT_CREATION_DB',      shipment_creation_,         attr_ );
      END IF;
      IF (shipment_type_ IS NOT NULL) THEN
         Client_SYS.Set_Item_Value('SHIPMENT_TYPE',          shipment_type_,             attr_);
      END IF;
   	Client_SYS.Set_Item_Value('ORIGINATING_CO_LANG_CODE',  originating_co_lang_code_,  attr_);
      Client_SYS.Set_Item_Value('CUST_CALENDAR_ID',          cust_calendar_id_,          attr_);
      Client_SYS.Set_Item_Value('EXT_TRANSPORT_CALENDAR_ID', ext_transport_calendar_id_, attr_);
      Client_SYS.Set_Item_Value('CONTACT',                   contact_,                   attr_); 
      Client_SYS.Set_Item_Value('DISTRICT_CODE',             district_code_,             attr_);
      Client_SYS.Set_Item_Value('REGION_CODE',               region_code_,               attr_);
      IF (ship_addr_no_ IS NOT NULL) OR (single_occurence_)THEN
         tax_liability_type_ := Tax_Liability_API.Get_Tax_Liability_Type_Db(tax_liability_, country_code_);
         Client_SYS.Add_To_Attr('TAX_LIABILITY_TYPE_DB', tax_liability_type_, attr_);
         Client_SYS.Add_To_Attr('TAX_LIABILITY', tax_liability_, attr_);
         IF (tax_liability_type_ = 'EXM') THEN
            Client_SYS.Add_To_Attr('TAX_CODE', vat_free_vat_code_, attr_);
         END IF;
      END IF;
      Client_SYS.Add_To_Attr('VAT_NO',                vat_no_,                attr_);
      Client_SYS.Add_To_Attr('TAX_ID_VALIDATED_DATE', tax_id_validated_date_, attr_);  
   END IF;

   IF (co_internal_po_no_ IS NOT NULL) THEN
      -- get the originating order line keys
      -- Fetch the Internal PO site.
      $IF (Component_Purch_SYS.INSTALLED) $THEN
         DECLARE
            poline_ Purchase_Order_Line_API.Public_Rec;
         BEGIN
            poline_ := Purchase_Order_Line_API.Get(co_internal_po_no_, line_no_, rel_no_);
            IF (poline_.demand_code IN ('ICD', 'ICT')) THEN
               orig_order_no_     := poline_.demand_order_no;
               orig_line_no_      := poline_.demand_release;
               orig_rel_no_       := poline_.demand_sequence_no;
               orig_line_item_no_ := Purchase_Order_Line_API.Get_Demand_Operation_No(co_internal_po_no_, line_no_, rel_no_);
               po_contract_       := poline_.contract;
            END IF;
         END;
      $ELSE
         NULL;
      $END  
      IF (orig_order_no_ IS NOT NULL AND orig_line_no_ IS NOT NULL AND orig_rel_no_ IS NOT NULL AND orig_line_item_no_ IS NOT NULL)THEN
         Client_SYS.Clear_Attr(orig_attr_);
         Client_SYS.Add_To_Attr('RELEASE_PLANNING_DB', 'NOTRELEASED', orig_attr_);
         Customer_Order_Line_API.Modify(orig_attr_, orig_order_no_, orig_line_no_, orig_rel_no_, orig_line_item_no_);
      END IF;
   END IF;

   IF (demand_code_db_ = 'IPD') AND (ship_addr_no_ IS NULL) AND (ean_location_del_addr_ IS NOT NULL) THEN
      Error_SYS.Record_General(lu_name_, 'ECOLNOMATCH: Delivery address cannot be found for the customer :P1 and own address :P2',
                               deliver_to_customer_no_, ean_location_del_addr_);
   END IF;

   IF (ship_addr_no_ IS NOT NULL ) THEN
      Client_SYS.Add_To_Attr('SHIP_ADDR_NO', ship_addr_no_, attr_);
   END IF;
   
   Client_SYS.Add_To_Attr('RENTAL_DB', rental_, attr_);
   Client_SYS.Set_Item_Value('PACKING_INSTRUCTION_ID', packing_instruction_id_, attr_);
   
   IF (rental_ = Fnd_Boolean_API.DB_TRUE) THEN
      $IF Component_Rental_SYS.INSTALLED $THEN
         IF (message_type_ = 'ORDERS') THEN
            replacement_rental_no_ := External_Pur_Order_Message_API.Get_Replacement_Rental_No(message_id_,
                                                                                               message_line_,
                                                                                               message_type_);
            -- When replacement_rental_no is included in the ORDERS message, 
            -- then demand code should be IPT_RO.
            IF (replacement_rental_no_ IS NOT NULL) THEN
               demand_code_db_ := Order_Supply_Type_API.DB_INT_PURCH_REPLACEMENT_ORDER;

               -- Get the rental record using primary rental number(replacement rental no)
               -- of the replacement purchase order
               po_rental_rec_   := Rental_Object_API.Get(replacement_rental_no_);

               -- Get the internal customer order information using purch rental record.
               Customer_Order_Line_API.Get_Custord_From_Demand_Info(int_cust_order_no_, 
                                                                    int_co_line_no_, 
                                                                    int_co_rel_no_, 
                                                                    int_co_line_item_no_, 
                                                                    po_rental_rec_.order_ref1, 
                                                                    po_rental_rec_.order_ref2, 
                                                                    po_rental_rec_.order_ref3, 
                                                                    NULL, 
                                                                    Order_Supply_Type_API.DB_INT_PURCH_TRANS);

               -- Get rental no of the connected internal customer order, 
               -- then it should be a primary rental no of the new customer order that we are going to create.
               primary_rental_no_ := Rental_Object_API.Get_Rental_No(int_cust_order_no_,
                                                                     int_co_line_no_,
                                                                     int_co_rel_no_,
                                                                     int_co_line_item_no_,
                                                                     Rental_Type_API.DB_CUSTOMER_ORDER);

               IF (primary_rental_no_ IS NOT NULL) THEN                                                           
                  Client_SYS.Add_To_Attr('PRIMARY_RENTAL_NO', primary_rental_no_, attr_);
               END IF;
            END IF;   
         END IF;
         -- For the external rental customer order lines, copy the rental information
         -- to attr_ in order to cretae rental customer order line.
         Rental_Object_Manager_API.Add_Rental_Info_To_Attr(attr_,
                                                           message_id_,
                                                           message_line_,
                                                           message_type_);
         
      $ELSE
         Error_SYS.Component_Not_Exist('RENTAL');
      $END
      
   END IF;
      
   Client_SYS.Add_To_Attr('DEMAND_CODE_DB', demand_code_db_, attr_);

   Client_SYS.Add_To_Attr('ADDR_FLAG_DB', addr_flag_ , attr_);
   --For internal derect deliveries, order lines should not be order default addresses.
   IF (demand_code_db_ = 'IPD') THEN
      Client_SYS.Set_Item_Value('DEFAULT_ADDR_FLAG_DB', 'N', attr_);
      default_addr_flag_ := 'N';
   ELSE
      default_addr_flag_ := Set_Default_Address_Flag(addr_flag_,              
                                                     order_no_,
                                                     ship_addr_no_,
                                                     ship_via_code_,
                                                     delivery_terms_,
                                                     forward_agent_id_,
                                                     del_terms_location_,
                                                     delivery_address_name_,
                                                     ship_address1_,
                                                     ship_address2_,
                                                     ship_address3_,
                                                     ship_address4_,
                                                     ship_address5_,
                                                     ship_address6_,
                                                     ship_zip_code_,
                                                     ship_city_,
                                                     ship_state_,
                                                     country_code_,
                                                     ship_county_,
                                                     in_city_);  
                                                     
      Client_SYS.Set_Item_Value('DEFAULT_ADDR_FLAG_DB', default_addr_flag_, attr_);
   END IF;

END Transfer_New_Ord_Line;   

PROCEDURE Post_Insert_Col_Actions (
   message_id_             IN NUMBER,
   order_no_               IN VARCHAR2, 
   line_no_                IN VARCHAR2,
   rel_no_                 IN VARCHAR2,
   line_item_no_           IN NUMBER,
   orig_order_no_          IN VARCHAR2, 
   orig_line_no_           IN VARCHAR2,
   orig_rel_no_            IN VARCHAR2, 
   orig_line_item_no_      IN NUMBER,
   single_occurence_       IN BOOLEAN, 
   default_addr_flag_      IN VARCHAR2,
   demand_code_db_         IN VARCHAR2,
   delivery_address_name_  IN VARCHAR2,
   ship_address1_          IN VARCHAR2,
   ship_address2_          IN VARCHAR2,
   ship_address3_          IN VARCHAR2,
   ship_address4_          IN VARCHAR2,
   ship_address5_          IN VARCHAR2,
   ship_address6_          IN VARCHAR2,
   ship_zip_code_          IN VARCHAR2,
   ship_city_              IN VARCHAR2,
   ship_state_             IN VARCHAR2,
   country_code_           IN VARCHAR2,
   ship_county_            IN VARCHAR2, 
   vat_free_vat_code_      IN VARCHAR2,
   po_contract_            IN VARCHAR2,
   internal_po_no_         IN VARCHAR2,
   tax_class_id_           IN VARCHAR2,
   message_type_           IN VARCHAR2 )
IS
   attr_                   VARCHAR2(32000);
   internal_customer_site_ VARCHAR2(2000);
BEGIN
   -- set back the address flag, to be able to modify the already existing address
   IF (single_occurence_ AND default_addr_flag_ = 'N') THEN
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('ADDR_FLAG_DB', 'Y', attr_);
      Client_SYS.Add_To_Attr('ADDR_1',       delivery_address_name_, attr_);
      Client_SYS.Add_To_Attr('ADDRESS1',     ship_address1_,         attr_);
      Client_SYS.Add_To_Attr('ADDRESS2',     ship_address2_,         attr_);
      Client_SYS.Add_To_Attr('ADDRESS3',     ship_address3_,         attr_);
      Client_SYS.Add_To_Attr('ADDRESS4',     ship_address4_,         attr_);
      Client_SYS.Add_To_Attr('ADDRESS5',     ship_address5_,         attr_);
      Client_SYS.Add_To_Attr('ADDRESS6',     ship_address6_,         attr_);
      Client_SYS.Add_To_Attr('ZIP_CODE',     ship_zip_code_,         attr_);
      Client_SYS.Add_To_Attr('CITY',         ship_city_,             attr_);
      Client_SYS.Add_To_Attr('STATE',        ship_state_,            attr_);
      Client_SYS.Add_To_Attr('COUNTRY_CODE', country_code_,          attr_);
      Client_SYS.Add_To_Attr('COUNTY',       ship_county_,           attr_);
      IF (message_type_ = 'ORDCHG') THEN  
         Client_SYS.Add_To_Attr('REPLICATE_CHANGES', 'TRUE', attr_);      
         Client_SYS.Add_To_Attr('CHANGE_REQUEST', 'TRUE', attr_);
      END IF;
      Cust_Order_Line_Address_API.Change_Address(attr_, order_no_, line_no_, rel_no_, line_item_no_);
   END IF;
   
   IF ((single_occurence_)  AND (demand_code_db_ = 'IPD') AND (tax_class_id_ IS NOT NULL) AND (vat_free_vat_code_ IS NULL)) THEN
      Customer_Order_Line_API.Modify_Tax_Details_For_IPD(order_no_, line_no_, rel_no_, line_item_no_);
   END IF;

   -- create reservations using the originating customer order line's "temporary" reservations
   IF (internal_po_no_ IS NOT NULL) THEN
      $IF (Component_Purch_SYS.INSTALLED) $THEN
         -- if it exists an originating order line and any supply site reservations, transfer supply site reservation from that order line to this newly created one
         IF (message_type_ = 'ORDERS') THEN
            internal_customer_site_ := External_Customer_Order_API.Get_Internal_Customer_Site(message_id_);
         ELSIF (message_type_ = 'ORDCHG') THEN
            internal_customer_site_ := Ext_Cust_Order_Change_API.Get_Internal_Customer_Site(message_id_);
         END IF;   
         IF (po_contract_ = internal_customer_site_) THEN
            IF (orig_order_no_ IS NOT NULL AND orig_line_no_ IS NOT NULL AND orig_rel_no_ IS NOT NULL AND orig_line_item_no_ IS NOT NULL AND
                Co_Supply_Site_Reservation_API.Get_Qty_Reserved(orig_order_no_, orig_line_no_, orig_rel_no_, orig_line_item_no_) > 0) THEN
               Reserve_Customer_Order_API.Transfer_Reservation(orig_order_no_, orig_line_no_, orig_rel_no_, orig_line_item_no_,
                                                               order_no_, line_no_, rel_no_, line_item_no_);
            END IF;
         END IF;
      $ELSE
          NULL;
      $END
   END IF;
      
END Post_Insert_Col_Actions;


-- Get_Tax_Liability
--   To retrieve tax liabilty.
@UncheckedAccess
FUNCTION Get_Tax_Liability (
   order_no_  IN VARCHAR2,
   line_no_   IN VARCHAR2,
   rel_no_    IN VARCHAR2 ) RETURN VARCHAR2
IS

   CURSOR get_external_line(line_no_ VARCHAR2, rel_no_ VARCHAR2) IS
      SELECT tax_liability, ecol.country_code
         FROM  external_cust_order_line_tab ecol , external_customer_order_tab eco
         WHERE ecol.message_id = eco.message_id
         AND   eco.order_no = order_no_
         AND   ecol.line_no = line_no_
         AND   ecol.rel_no = rel_no_;

   extlinerec_            get_external_line%ROWTYPE;

BEGIN
   OPEN  get_external_line(line_no_, rel_no_);
   FETCH get_external_line INTO extlinerec_;
   CLOSE get_external_line;
   RETURN Tax_Liability_API.Get_Tax_Liability_Type_Db(extlinerec_.tax_liability, extlinerec_.country_code);
END Get_Tax_Liability;



FUNCTION Set_Default_Address_Flag (
   addr_flag_              IN VARCHAR2,
   order_no_               IN VARCHAR2,
   ship_addr_no_           IN VARCHAR2,
   ship_via_code_          IN VARCHAR2,
   delivery_terms_         IN VARCHAR2,
   forward_agent_id_       IN VARCHAR2,
   del_terms_location_     IN VARCHAR2,
   delivery_address_name_  IN VARCHAR2,
   ship_address1_          IN VARCHAR2,
   ship_address2_          IN VARCHAR2,
   ship_address3_          IN VARCHAR2,
   ship_address4_          IN VARCHAR2,
   ship_address5_          IN VARCHAR2,
   ship_address6_          IN VARCHAR2,
   ship_zip_code_          IN VARCHAR2,
   ship_city_              IN VARCHAR2,
   ship_state_             IN VARCHAR2,
   country_code_           IN VARCHAR2,
   ship_county_            IN VARCHAR2,
   in_city_                IN VARCHAR2 ) RETURN VARCHAR2
IS
   head_addr_rec_     Customer_Order_Address_API.Cust_Ord_Addr_Rec;
   headrec_           Customer_Order_API.public_rec;
   default_addr_flag_ VARCHAR2(1) := 'Y';
BEGIN
   headrec_             := Customer_Order_API.Get(order_no_);
   head_addr_rec_       := Customer_Order_Address_API.Get_Cust_Ord_Addr(order_no_);

   IF (Validate_SYS.Is_Different(headrec_.ship_via_code, NVL(ship_via_code_, headrec_.ship_via_code)) OR
       Validate_SYS.Is_Different(headrec_.delivery_terms, NVL(delivery_terms_, headrec_.delivery_terms)) OR
       Validate_SYS.Is_Different(headrec_.forward_agent_id, NVL(forward_agent_id_, headrec_.forward_agent_id)) OR
       Validate_SYS.Is_Different(headrec_.del_terms_location, NVL(del_terms_location_, headrec_.del_terms_location))) THEN 
      default_addr_flag_   := 'N';
   END IF;
 
   IF (default_addr_flag_ = 'Y') THEN
      -- Check the customer order addr flag
      IF (headrec_.addr_flag = 'Y') AND (addr_flag_ = 'Y') THEN
         -- Single Occurence address 
        IF (Validate_SYS.Is_Different(head_addr_rec_.addr_1,   NVL(delivery_address_name_, head_addr_rec_.addr_1)) OR
            Validate_SYS.Is_Different(head_addr_rec_.address1, NVL(ship_address1_, head_addr_rec_.address1)) OR
            Validate_SYS.Is_Different(head_addr_rec_.address2, NVL(ship_address2_, head_addr_rec_.address2)) OR
            Validate_SYS.Is_Different(head_addr_rec_.address3, NVL(ship_address3_, head_addr_rec_.address3)) OR
            Validate_SYS.Is_Different(head_addr_rec_.address4, NVL(ship_address4_, head_addr_rec_.address4)) OR
            Validate_SYS.Is_Different(head_addr_rec_.address5, NVL(ship_address5_, head_addr_rec_.address5)) OR
            Validate_SYS.Is_Different(head_addr_rec_.address6, NVL(ship_address6_, head_addr_rec_.address6)) OR
            Validate_SYS.Is_Different(head_addr_rec_.zip_code, NVL(ship_zip_code_, head_addr_rec_.zip_code)) OR
            Validate_SYS.Is_Different(head_addr_rec_.city, NVL(ship_city_, head_addr_rec_.city)) OR
            Validate_SYS.Is_Different(head_addr_rec_.state, NVL(ship_state_, head_addr_rec_.state)) OR
            Validate_SYS.Is_Different(head_addr_rec_.country_code, NVL(country_code_, head_addr_rec_.country_code)) OR
            Validate_SYS.Is_Different(head_addr_rec_.county, NVL(ship_county_, head_addr_rec_.county)) OR
            Validate_SYS.Is_Different(head_addr_rec_.in_city, NVL(in_city_, head_addr_rec_.in_city))) THEN
           default_addr_flag_   := 'N';
        END IF;
      ELSIF (headrec_.addr_flag = 'N') AND (addr_flag_ = 'N') THEN
         IF (Validate_SYS.Is_Different(headrec_.ship_addr_no, NVL(ship_addr_no_, headrec_.ship_addr_no))) THEN
            default_addr_flag_ := 'N';
         END IF;
      ELSE
         -- Address Flag has been changed.
         default_addr_flag_ := 'N';
      END IF;
   END IF; 

   RETURN (default_addr_flag_);
END Set_Default_Address_Flag;

