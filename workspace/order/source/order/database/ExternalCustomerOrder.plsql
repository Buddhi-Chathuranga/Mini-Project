-----------------------------------------------------------------------------
--
--  Logical unit: ExternalCustomerOrder
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  211223 Skanlk  Bug 161134(SC21R2-6825), Added Fetch_And_Validate_Tax_Id() and Get_Tax_Id_Type() to validate Tax ID other than EU countires.
--  211014 ThKrlk  Bug 160664 (SC21R2-2539), Modified Transfer_Order___() by adding new condtion to check bill_addr_no_ before calling Cust_Ord_Customer_API.Fetch_Cust_Ref().
--	 201130 ApWilk  Bug 156816 (SCZ-12763), Modified Transfer_Order___() to re-phrase an error message to be more descriptive.
--  200624 ChBnlk  SC2020R1-7485, Removed the methods added to handle ReceiveCustomerOrder Inet Transfer message since the 
--  200624         implementation was moved to Customer_Order_Transfer_API.
--  200519 ChBnlk  SC2020R1-6906, Added new methods Create_Ext_Cust_Ord_Inet_Trans, Ext_Cust_Ord_Struct_New___, Ext_Cust_Ord_Struct_External_Cust_Order_Line_New___,
--  200519         Ext_Cust_Ord_Struct_External_Cust_Order_Line_Copy_From_Header___, Ext_Cust_Ord_Struct_External_Cust_Order_Char_Copy_From_Header___, Get_Next_Message_Line___ 
--  200519         to handle Inet Trans message passing.
--  200109 SBalLK  Bug 151752(SCZ-8375), Modified Do_Approve___() method to give priority for internal customer when inter site flow triggered.
--  191011 Satglk  Bug SCXTEND-886, Modified Check_Insert___ to assign the newly created date to Created Date field.
--  190515 AsZelk  Bug 148272 (SCZ-4546), Modified Transfer_Order___() to fix the Incoming Customer Order Customer tax validation error.
--  181029 ApWilk  Bug 144320, Modified Transfer_Order___() to fetch the Invoice Customer and the relavant Address ID according to the Customer's Own Address ID.
--  180517 Cpeilk  Bug 141835, Modified Transfer_Order___ to fetch order type from Get_Default_Order_Type when passed parameter is NULL.
--  171003 KiSalk  Bug 138079, Modified cursors find_same_int_order and  find_same_orders NOT to fetch order_no of Cancelled customersorders.
--  170926 RaVdlk  STRSC-11152,Removed Get_State function, since it is generated from the foundation
--  170207 ErFelk  Bug 133180, Removed method Check_Country_Exist() added from Bug 108102, as country code going to be mandatory in the table. 
--  160920 NiNilk  Bug 131311, Modified the error message 'CUST_ORD_FOUND' in method Transfer_Order___ by adding additional information.
--  160809 TiRalk  STRSC-3788, Modified Do_Approve___ to check whether external CO is blocked if so it will give an info message.
--  160802 ChJalk  Bug 130143, Modified Transfer_Order___ to lock the external_customer_order record when creating the internal customer order.
--  160608 reanpl  STRLOC-428, Added handling of new attributes ship_address3..ship_address6 
--  150525 RoJalk  ORA-161, Modified Transfer_Order___ and used the method call Cust_Ord_Customer_API.Fetch_Cust_Ref to fetch cust ref.   
--  150519 RoJalk  ORA-161, Modified Transfer_Order___ and merged LCS 122077. Used the method Cust_Ord_Customer_API.Fetch_Cust_Ref in logic. 
--  141021 RoJalk  Handled print_delivered_lines in the Transfer_Order___ method. 
--  140703 HimRlk  Modified Do_Approve___ by changing release_internal_order fetching logic.
--  140425 RoJalk  Modified Do_Approve___ an added a PL/SQL block for the ROLLBACK statement and catch the exception when save point is invalid due to commits in order flow.
--  140404 SURBLK  Modified Do_Approve___() by changing the authorize_code_ fetching logic.
--  140226 ChFolk  Added method Check_In_Cust_Ord_Exist_Db and removed method Check_In_Cust_Ord_Exist.
--  130808 ShKolk  Added column same_database to save if received message originated from same database or a different database 
--  130808         and Modified Transfer_Order___ to copy doc texts of internal PO.
--  130712 ShKolk  Modified fetching sequence of AUTHORIZE_CODE and ORDER_ID to Site/Customer, Site, Customer.
--  120905 MAHPLK  Added picking_leadtime and shipment_type. 
--  130710 ChJalk  TIBE-996, Removed global variables inst_jinsui_ and current_info_.
--  130606 RuLiLk  Bug 107700, Modified Transfer_Order___(), Transfer_Quotation___() and Do_Approve___() methods in order to handle the order_coordinator_group_tab
--  130606         locking issue if the process sourced from Incoming Customer Order approval where the particular tab shall be locked for considerable time.
--  130606         Modified Do_Approve___() by adding a method call to get the customer no. At the time of automatic approval customer_no is not known.  
--  130506         It needs to be fetched by using internal_customer_site.
--  130613 MalLlk  Bug 109897, Modified Transfer_Order___ to fetch the customer reference value from CustOrdCustomerAddress before fetch it from CustOrdCustomer. 
--  130509 AyAmlk  Bug 108102, Added Check_Country_Exist() to validate the country to preventing saving a NULL when CO is not created from an external party.
--  130509 MalLlk  Bug 109897, Modified Transfer_Order___ to fetch the customer reference value from CustOrdCustomer 
--  130509         when it is null and not from inter-site flow.
--  130423 ErFelk  Bug 109586, Modified Transfer_Order___() to call Internal_Co_Exists() method in a condition.
--  120813 ShKolk  Modified Transfer_Order___ to add USE_PRICE_INCL_TAX_DB when customer order header is created.
--  120809 SudJlk  Bug 103412, Modified Unpack_Check_Update___ to check if the manually entered order_no has leading or trailing spaces
--  120802 MalLlk  Bug 104262, Modified Transfer_Order___ to get the values VAT_NO and TAX_ID_VALIDATED_DATE from rec and 
--  120802         check whether they are not null before add to attr. 
--  120313 NaLrlk  Modified Transfer_Order___ to add Tax Identity when customer order header create.
--  111215 MaMalk  Modified Insert___ to move the setting of objversion_ to the end of this procedure.
--  110617 HimRlk  Bug 97518, Modified Transfer_Order___ to stop the flow if there is a manually created CO with same Internal PO no.
--  110520 NiDalk  Bug 95291, Modified Transfer_Order___ to get the correct ship address when fetching vat_free_vat_code_.
--  110420 ErFelk  Bug 95833, Modified previous_errors cursor in Do_Approve___ method by adding another condition to check the cancelled state.
--  110309 Kagalk  RAVEN-1074, Added tax_id_validated_date field
--  110223 MaMalk  Replaced Customer_Info_Vat_API with new APIs.
--  110202 Nekolk  EANE-3744  added where clause to View EXTERNAL_CUSTOMER_ORDER.
--  100709 ShVese  Added record fetching in Do_Approve___ when an exception is raised.
--  100520 KRPELK  Merge Rose Method Documentation.
--  100512 ShVese  Moved the call to Get_Object_By_Keys___from Finite_State_Machine___ to Do_Approve___.
--  100723 SudJlk  Bug 91901, Modified method Replace_External___ to set not only the CO header but CO lines as well to Cancelled.
--  100722 SaJjlk  Bug 91920, Introduced global variable current_info_ and modified method Approve__  and Transfer_Order___ 
--  100722         to store and use the info messages raised while creating the Customer Order header.
--  100104 MaRalk  Modified the state machine according to the new developer studio template - 2.5.
--  091204 KiSalk  Cloumn length for backorder_option_db in view comments set to 40.
--  090930 MaMalk  Removed constant state_separator_. Modified Get_Jinsui_Invoice_Defaults__, Transfer_Quotation___ and Finite_State_Init___
--  090930         to remove unused code.
--  ------------------------- 14.0.0 -----------------------------------------
--  090701 Castse  Bug 83544, Modified the method Do_Approve___ to clear the error messages of previous lines when an error for a certain message line occurs.
--  090329 HimRlk  Bug 80277, Added new field internal_po_label_note.
--  081021 SaJjlk  Bug 77686, Modified the method call to Customer_Order_Transfer_API.Update_Ordchg_On_Create_Order in method Do_Approve___.
--  080918 HoInlk  Bug 67780, Added column internal_ref.
--  080623 NaLrlk  Bug 74960, Added check for del_terms_location is null in methods Transfer_Order___ and Transfer_Quotation___.
--  080208 NaLrlk  Bug 70005, Removed not null check for del_terms_location in Transfer_Order___ and Transfer_Quotation___.
--  080130 NaLrlk  Bug 70005, Added column del_terms_location and Modified methods Transfer_Order___, Transfer_Quotation___
--  071214 ThAylk  Bug 68692, Added column JINSUI_INVOICE, Functions Get_Jinsui_Invoice, Finite_State_Encode__,  
--  071214         Get_Jinsui_Invoice_Defaults___ and Procedure Validate_Jinsui_Constraints___. 
--  071211 LaBolk  Bug 67937, Added method Customer_Order_No_Exists.
--  070511 ChBalk  Bug 63020, Modified Transfer_Order___ in order to insert vat_free_vat_code into customer_order_address_tab.
--  070323 MalLlk  Bug 60882, Removed vat_no from the function Customer_Order_Address_API.New.
--  070323         Changed procedure Transfer_Order___ to handle vat_no.
--  070124 SuSalk  Added DELIVERY_TERMS_DESC & SHIP_VIA_DESC to base view. 
--  070123 SuSalk  Removed DELIVERY_TERMS_DESC & SHIP_VIA_DESC from attr.
--  070118 KaDilk  Removed Language Code from Order_Delivery_Terms_desc().
--  070118 SuSalk  Modified Mpccom_Ship_Via_API.Get_Description method call.   
--  061222 SuSalk  LCS Merge 61831, Added method call to Customer_Order_Transfer_API.Update_Ordchg_On_Create_Order 
--  061222         in method Do_Approve___.
--  061125 Cpeilk  Added column VAT_NO.
--  061110 NaLrlk  Added the columns backorder_option and function Get_Backorder_Option.
--                 Removed the column allow_backorders and function Get_Allow_Backorders.
--  060815 DaZase  Added new method Release_Order___ and call to it in method Do_Approve___ for handling automatic release of CO.
--  060725 ChJalk  Modified call Mpccom_Ship_Via_Desc_API.Get_Description to Mpccom_Ship_Via_API.Get_Description
--  060725         Order_Delivery_Term_Desc_API.Get_Description to Order_Delivery_Term_API.Get_Description.
--  060516 NaLrlk  Enlarge Address -  Changed variable definitions.
--  060420 RoJalk  Enlarge Customer - Changed variable definitions.
--  ------------------------- 13.4.0 -----------------------------------------
--  060206 CsAmlk  Changed Ean Location Payer Addr to Old Cust Own Pay Addr.
--  060119 MaHplk  Replace 'SELECT &OBJID INTO....' statement with RETURNING &OBJID INTO objid_.
--  051026 Cpeilk  Bug 53510, Modified Transfer_Order___ to add an error message when the EAN location is not unique.
--  050922 NaLrlk  Removed unused variables.
--  050722 VeMolk  Bug 52517, Modified the method Transfer_Order___.
--  050610 KiSalk  Bug 50953, Added new attribute, in_city and modified procedure Transfer_Order___.
--  050415 ChJalk  Bug 50263, Added column Allow_Backorders and Function Get_Allow_Backorders. Modified Procedure
--  050415         Transfer_Order___ to handle Allow_Backorders Functionality.
--  050210  IsWilk Modified the PROCEDURE Unpack_Check_Update___ to add the
--  050210         error message "Changes are not allowed for Created Orders".
--  040511  JaJalk Corrected lead time lables.
--  040220  IsWilk Removed the SUBSTRB for Unicode Changes.
--  --------------- Edge Package Group 3 Unicode Changes----------------------
--  031013 PrJalk  Bug Fix 106224, Added missing General_Sys.Init_Method calls.
--  031007 SeKalk  Removed all logic for allow_backorders
--  030901 UdGnlk  Performed CR Merge2.
--  030819 MaGulk  Merged CR
--  030716 NaWalk  Removed Bug coments.
--  030710 WaJalk  Applied bug 34820.
--  030602 BhRalk  Modified the method Transfer_Order___.
--  **************************** CR Merge **********************************
--  030805 AjShlk  Synchronized with the CAT file - SP4 Merge
--  030729 GaJalk  Performed SP4 Merge.
--  030324 SaAblk  Made customer_no, contract and delivery_date public
--  030324         Add new public method Find_Message_From_Cust_Po
--  030217 NuFilk Bug 34820, Modified Procedure Transfer_Order___, and the correction for bug id 29217.
--  020620  ErFi  Added Replace_External___
--  020619 ErFise Bug 30257, Added new attribute delivery_leadtime to view and methods.
--  020720 NuFilk Bug 29217, Included backorder flag from external customer for internal direct dilevery in Transfer_Order___
--  020322 SaKaLk Call 77116(Foreign Call 28170). Added ship_county to calling method parameter list of
--                'CUSTOMER_ORDER_ADDRESS_API.New'.
--  020312 SaKaLk Call 77116(Foreign Call 28170).Added Column ship_county.
--  020110 DaRuLK Bug fix 27078,   Modified cursor find_same_po in Transfer_Order___ .
--  011203  DaZa  Bug fix 24525, Added new fields delivery_terms_desc, ship_via_desc and route_id
--                to view and methods.
--  010528  JSAnse  Bug 21463, Added call to General_SYS.Init_Method in the procedure Is_Quotation.
--  001130  JoAn  CID 56298 No retrival of order type from Cust_Order_Type_Config_API
--                in Transfer_Order___
--  001120  JoEd  Added SALESMAN_CODE to Transfer_Order___ and Transfer_Quotation___.
--  001116  JoAn  Corrected Find_Message_From_Ext_Ref state 'Approved' in cursor
--                replaced with 'Created'
--  000919  MaGu  Renamed address columns to ship_address1, ship_address2, ship_zip_code,
--                ship_city and ship_state. Also modified Insert___, Finite_State_Init
--                and Finite_State_Machine___ according to new template. Modified
--                Transfer_Order___ to handle new address columns.
--  000905  JoEd  Added exist check on import mode.
--  000614  GBO   Removed call to Cust_Order_Type_Config_API.Get_Order_Type_Quotation
--                in Transfer_Order___
--  000524  JakH  Added is_quotation and transfer_quotation
--  -------------------- 12.10 ----------------------------------------------
--  000515  JoEd  Bug fix 15490. Added cursor find_same_po in Transfer_Order___.
--  000419  PaLj  Corrected Init_Method Errors
--  -------------------- 12.0 ----------------------------------------------
--  991108  JoEd  Added more parameters to Transfer_Order___ to handle values
--                entered by the user.
--  991021  JoEd  Changed address flag value from client to db.
--  991007  JoEd  Call Id 21210: Corrected double-byte problems.
--  --------------------------- 11.1 ----------------------------------------
--  990426  RaKu  Y.Correction 2.
--  990423  RaKu  Y.Correction.
--  990416  JakH  Y. Added use of public-rec.
--  990409  RaKu  New templates.
--  990310  JICE  Corrected handling of order types on Approve.
--  990303  JICE  Added public method Get_Currency_Code.
--  990129  JICE  Added Cancel and Find_Message_From_Ext_Ref.
--  981217  JICE  Added columns for Configurator interface.
--  980918  RaKu  Replaced call to Cust_Ord_Customer_API.Get_Edi_Order_Id with
--                Cust_Ord_Customer_API.Get_Order_Id.
--  980422  RaKu  Changed length on state-machine from 32000.
--  980406  JoAn  SID 3085, 3086 Added new attribute internal_delivery_type.
--  980330  JOHNI Changes for Oracle 8.
--  980306  RaKu  Added column INTERNAL_CUSTOMER_SITE.
--  980306  MNYS  Added call to Cust_Order_Event_Creation_API.External_Order_Stopped
--                in procedure Do_Creation_Error___.
--  980302  RaKu  Changes made to match Design.
--  980212  JOKE  Removed Authorized column plus renamed Note to Note_Text.
--  970127  JOKE  Altered state machine
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Transfer_Order___
--   Creates a new record in the Customer Order (header).
PROCEDURE Transfer_Order___ (
   message_id_                   IN NUMBER,
   authorize_code_               IN VARCHAR2,
   order_id_                     IN VARCHAR2,
   limit_sales_to_assortments_   IN VARCHAR2 )
IS
   info_                     VARCHAR2(2000);
   attr_                     VARCHAR2(32000);
   rec_                      EXTERNAL_CUSTOMER_ORDER_TAB%ROWTYPE;
   newrec_                   EXTERNAL_CUSTOMER_ORDER_TAB%ROWTYPE;
   oldrec_                   EXTERNAL_CUSTOMER_ORDER_TAB%ROWTYPE;
   default_contract_         CUST_ORD_CUSTOMER_TAB.edi_site%TYPE := NULL;
   order_type_               CUST_ORD_CUSTOMER_TAB.order_id%TYPE;
   single_occurance_         BOOLEAN := FALSE;
   order_no_                 CUSTOMER_ORDER_TAB.order_no%TYPE;
   objid_                    VARCHAR2(2000);
   objversion_               VARCHAR2(2000);   
   cust_rec_                 Cust_Ord_Customer_API.Public_Rec;
   update_customer_          BOOLEAN := FALSE;
   update_language_          BOOLEAN := FALSE;
   co_no_                    VARCHAR2(12);
   new_order_no_             CUSTOMER_ORDER_TAB.order_no%TYPE;
   temp_attr_                VARCHAR2(32000);
   ship_addr_no_             CUSTOMER_ORDER_TAB.ship_addr_no%TYPE;
   customer_no_              EXTERNAL_CUSTOMER_ORDER_TAB.customer_no%TYPE;
   company_                  VARCHAR2(20);
   vat_free_vat_code_        VARCHAR2(20);
   bill_addr_no_             CUSTOMER_ORDER_TAB.bill_addr_no%TYPE;
   customer_no_pay_addr_no_  CUSTOMER_ORDER_TAB.customer_no_pay_addr_no%TYPE;
   supply_country_           CUSTOMER_ORDER_TAB.supply_country%TYPE;
   cust_ref_                 CUSTOMER_ORDER_TAB.cust_ref%TYPE;
   po_note_id_               NUMBER;
   co_note_id_               NUMBER;
   indrec_                   Indicator_Rec;
   found_                    NUMBER;   
   row_locked                EXCEPTION;
   PRAGMA EXCEPTION_INIT(row_locked, -00054);
   customer_no_pay_          EXTERNAL_CUSTOMER_ORDER_TAB.CUSTOMER_NO_PAY%TYPE;
   default_charges_          VARCHAR2(5);
   CURSOR lock_same_int_order IS
      SELECT 1
      FROM EXTERNAL_CUSTOMER_ORDER_TAB
      WHERE (internal_customer_site = rec_.internal_customer_site AND   internal_po_no = rec_.internal_po_no)
         OR (customer_no = rec_.customer_no  AND   customer_po_no = rec_.customer_po_no)
      FOR UPDATE NOWAIT;
  
   CURSOR find_same_int_order IS
      SELECT order_no
      FROM EXTERNAL_CUSTOMER_ORDER_TAB eco
      WHERE internal_customer_site = rec_.internal_customer_site
      AND   internal_po_no = rec_.internal_po_no
      AND   rowstate = 'Created'
      AND   EXISTS (SELECT 1 FROM customer_order_tab co WHERE co.order_no = eco.order_no AND co.rowstate !='Cancelled');

   CURSOR find_same_orders IS
      SELECT order_no
      FROM EXTERNAL_CUSTOMER_ORDER_TAB eco
      WHERE customer_no = rec_.customer_no
      AND   customer_po_no = rec_.customer_po_no
      AND   rowstate = 'Created'
      AND   EXISTS (SELECT 1 FROM customer_order_tab co WHERE co.order_no = eco.order_no AND co.rowstate !='Cancelled');
BEGIN

   rec_ := Get_Object_By_Keys___(message_id_);
   Client_SYS.Clear_Attr(attr_);

   OPEN lock_same_int_order;
   FETCH lock_same_int_order INTO found_;
   CLOSE lock_same_int_order;
      
   -- Check if the same purchase order already has created a customer order
   IF (rec_.internal_customer_site IS NOT NULL) THEN
      OPEN find_same_int_order;
      FETCH find_same_int_order INTO co_no_;
      IF (find_same_int_order%FOUND) THEN
         CLOSE find_same_int_order;
         Error_SYS.Record_General(lu_name_, 'CUST_ORD_FOUND: The order :P1 has already been created.', co_no_);
      ELSE
         CLOSE find_same_int_order;
      END IF;
   ELSE
      OPEN find_same_orders;
      FETCH find_same_orders INTO co_no_;
      IF (find_same_orders%FOUND) THEN
         CLOSE find_same_orders;
      Error_SYS.Record_General(lu_name_, 'CUST_ORD_FOUND_EXT: The order :P1 has already been created for customer''s purchase order number :P2.', co_no_, rec_.customer_po_no);
   ELSE
         CLOSE find_same_orders;
      END IF;
   END IF;

   -- Check if internal customer is used. In that case, get all defaults for that (internal) customer.
   IF (rec_.internal_customer_site IS NOT NULL) THEN
      rec_.customer_no := Cust_Ord_Customer_API.Get_Customer_No_From_Contract(rec_.internal_customer_site);

      update_customer_ := TRUE;
   END IF;

   IF (rec_.customer_no IS NULL AND rec_.ean_location_del_addr IS NOT NULL) THEN
      Customer_Info_Address_API.Get_Id_By_Ean_Loc_If_Unique(customer_no_, ship_addr_no_, rec_.ean_location_del_addr);

      IF (customer_no_ IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'EAN_NOT_UNIQUE: Customer Info could not be found using the EAN Address Location. Either it is not unique for only one customer, or it does not exist. Please review the setup of Customer''s Own Address ID.');
      END IF;
      update_customer_ := TRUE;
   ELSE
      ship_addr_no_ := Cust_Ord_Customer_Address_API.Get_Id_By_Ean_Location(rec_.customer_no, rec_.ean_location_del_addr);
   END IF;

   customer_no_ := NVL(rec_.customer_no, customer_no_);

   IF (rec_.internal_po_no IS NOT NULL) THEN
      IF (Customer_Order_API.Internal_Co_Exists(customer_no_, rec_.internal_po_no) = 1) THEN
         Error_SYS.Record_General(lu_name_, 'CO_PO_NO_FOUND: Manually-entered customer order(s) already exists for the customer :P1 with a customer''s PO number identical to the internal PO number.', customer_no_ );
      END IF;
   END IF;

   cust_rec_      := Cust_Ord_Customer_API.Get(customer_no_);  

   -- Get attributes from customer
   IF (rec_.contract IS NULL) THEN
      default_contract_ := cust_rec_.edi_site;
   END IF;
      
   Client_SYS.Add_To_Attr('AUTHORIZE_CODE', authorize_code_, attr_);
   -- Get order_id from site/customer, site, customer
   order_type_ := NVL(order_id_, Customer_Order_API.Get_Default_Order_Type(NVL(rec_.contract, default_contract_), customer_no_));   
   IF (order_type_ IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'ORDTYPE_NOT_FOUND: Default order type is missing for customer :P1', customer_no_);
   END IF;
   Client_SYS.Add_To_Attr('ORDER_ID', order_type_, attr_);

   -- Get attributes from external order header
   Client_SYS.Add_To_Attr('ORDER_NO', rec_.order_no, attr_);
   Client_SYS.Add_To_Attr('CONTRACT', NVL(rec_.contract, default_contract_), attr_);
   Client_SYS.Add_To_Attr('CUSTOMER_NO', customer_no_, attr_);
   Client_SYS.Add_To_Attr('WANTED_DELIVERY_DATE', rec_.delivery_date, attr_);
   Client_SYS.Add_To_Attr('CURRENCY_CODE', rec_.currency_code, attr_);

   IF (rec_.ean_location_doc_addr IS NOT NULL) THEN
      bill_addr_no_ := Cust_Ord_Customer_Address_API.Get_Id_By_Ean_Location(customer_no_, rec_.ean_location_doc_addr);
   END IF;

   IF (rec_.cust_ref IS NULL) THEN
      IF (NVL(rec_.internal_delivery_type, ' ') != 'INTER-SITE') THEN
         IF (bill_addr_no_ IS NOT NULL) THEN
            cust_ref_ := Cust_Ord_Customer_API.Fetch_Cust_Ref(customer_no_, bill_addr_no_, 'TRUE');
         ELSE
            cust_ref_ := Cust_Ord_Customer_API.Fetch_Cust_Ref(customer_no_, NULL, 'FALSE');
         END IF;
      ELSIF (rec_.internal_ref IS NULL) THEN
         cust_ref_ := Cust_Ord_Customer_API.Fetch_Cust_Ref(customer_no_, NULL, 'FALSE');
      END IF;      
   ELSE
      cust_ref_ := rec_.cust_ref;
   END IF;
   Client_SYS.Add_To_Attr('CUST_REF', cust_ref_, attr_);

   Client_SYS.Add_To_Attr('CUSTOMER_PO_NO', rec_.customer_po_no, attr_);
   Client_SYS.Add_To_Attr('INTERNAL_PO_NO', rec_.internal_po_no, attr_);
   Client_SYS.Add_To_Attr('INTERNAL_DELIVERY_TYPE', Order_Delivery_Type_API.Decode(rec_.internal_delivery_type), attr_);
   Client_SYS.Add_To_Attr('LABEL_NOTE', rec_.label_note, attr_);
   Client_SYS.Add_To_Attr('NOTE_TEXT', rec_.note_text, attr_);
   Client_SYS.Add_To_Attr('JINSUI_INVOICE_DB', rec_.jinsui_invoice, attr_);
   Client_SYS.Add_To_Attr('INTERNAL_REF', rec_.internal_ref, attr_);
   Client_SYS.Add_To_Attr('INTERNAL_PO_LABEL_NOTE', rec_.internal_po_label_note, attr_);

   IF (rec_.forward_agent_id IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('FORWARD_AGENT_ID', rec_.forward_agent_id, attr_);
   END IF;

   IF (rec_.pay_term_id IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('PAY_TERM_ID', rec_.pay_term_id, attr_);
   END IF;

   IF (rec_.delivery_terms IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('DELIVERY_TERMS', rec_.delivery_terms, attr_);
   END IF;

   IF (rec_.del_terms_location IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('DEL_TERMS_LOCATION', rec_.del_terms_location, attr_);
   END IF;

   IF (rec_.ship_via_code IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('SHIP_VIA_CODE', rec_.ship_via_code, attr_);
   END IF;

   IF (rec_.language_code IS NULL) THEN
      rec_.language_code := Cust_Ord_Customer_API.Get_Language_Code(customer_no_);

      update_language_ := TRUE;
   END IF;
   Client_SYS.Add_To_Attr('LANGUAGE_CODE', rec_.language_code, attr_);

   Client_SYS.Add_To_Attr('EXTERNAL_REF', rec_.external_ref, attr_);

   IF (rec_.salesman_code IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('SALESMAN_CODE', rec_.salesman_code, attr_);
   END IF;

   -- Handle delivery (ship) address
   IF (rec_.delivery_address_name IS NOT NULL) OR (rec_.ship_address1 IS NOT NULL) OR
      (rec_.ship_address2 IS NOT NULL) OR (rec_.ship_address3 IS NOT NULL) OR (rec_.ship_address4 IS NOT NULL) OR 
      (rec_.ship_address5 IS NOT NULL) OR (rec_.ship_address6 IS NOT NULL) OR (rec_.ship_zip_code IS NOT NULL) OR
      (rec_.ship_city IS NOT NULL) OR (rec_.ship_state IS NOT NULL) OR
      (rec_.country_code IS NOT NULL) THEN

      IF (ship_addr_no_ IS NULL) THEN
         -- Note: Single occurance address
         Client_SYS.Add_To_Attr('ADDR_FLAG_DB', 'Y', attr_);
         single_occurance_ := TRUE;
         IF (rec_.delivery_terms IS NOT NULL) THEN
            Client_SYS.Add_To_Attr('DELIVERY_TERMS', rec_.delivery_terms, attr_);
         END IF;

         IF (rec_.del_terms_location IS NOT NULL) THEN
            Client_SYS.Add_To_Attr('DEL_TERMS_LOCATION', rec_.del_terms_location, attr_);
         END IF;

         IF (rec_.ship_via_code IS NOT NULL) THEN
            Client_SYS.Add_To_Attr('SHIP_VIA_CODE', rec_.ship_via_code, attr_);
         END IF;
         IF (rec_.route_id IS NOT NULL) THEN
            Client_SYS.Add_To_Attr('ROUTE_ID', rec_.route_id, attr_);
         END IF;
         IF (rec_.delivery_leadtime IS NOT NULL) THEN
            Client_SYS.Add_To_Attr('DELIVERY_LEADTIME', rec_.delivery_leadtime, attr_);
         END IF;
         IF (rec_.picking_leadtime IS NOT NULL) THEN
            Client_SYS.Add_To_Attr('PICKING_LEADTIME', rec_.picking_leadtime, attr_);
         END IF;
         IF (rec_.shipment_type IS NOT NULL) THEN
            Client_SYS.Add_To_Attr('SHIPMENT_TYPE', rec_.shipment_type, attr_);
         END IF;
      ELSE
         Client_SYS.Add_To_Attr('SHIP_ADDR_NO', ship_addr_no_, attr_);
      END IF;
   ELSIF (rec_.ean_location_del_addr IS NOT NULL) THEN
      -- EAN Location code
      Client_SYS.Add_To_Attr('SHIP_ADDR_NO',ship_addr_no_ , attr_);
   END IF;

   -- Handle payer and payer address
   IF (rec_.customer_no_pay IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('CUSTOMER_NO_PAY', rec_.customer_no_pay , attr_);
      IF (rec_.ean_location_payer_addr IS NOT NULL) THEN
         -- EAN Location code
         customer_no_pay_addr_no_ := Cust_Ord_Customer_Address_API.Get_Id_By_Ean_Location(rec_.customer_no_pay, rec_.ean_location_payer_addr);
         Client_SYS.Add_To_Attr('CUSTOMER_NO_PAY_ADDR_NO', customer_no_pay_addr_no_, attr_);
      END IF;
   ELSE
      IF (rec_.Ean_Location_Payer_Addr IS NOT NULL) THEN
         Customer_Info_Address_API.Get_Id_By_Ean_Loc_If_Unique(customer_no_pay_, customer_no_pay_addr_no_, rec_.Ean_Location_Payer_Addr);
         IF (customer_no_pay_ IS NULL) THEN
            Error_SYS.Record_General(lu_name_, 'EAN_NOT_UNIQUE: Customer Info could not be found using the EAN Address Location. Either it is not unique for only one customer, or it does not exist. Please review the setup of Customer''s Own Address ID.');
         END IF;
         Client_SYS.Add_To_Attr('CUSTOMER_NO_PAY', customer_no_pay_ , attr_);
         Client_SYS.Add_To_Attr('CUSTOMER_NO_PAY_ADDR_NO', customer_no_pay_addr_no_, attr_);
      END IF;
   END IF;

   -- Note: Handle document (bill) address
   IF (rec_.ean_location_doc_addr IS NOT NULL) THEN
      -- Note: EAN Location code
      Client_SYS.Add_To_Attr('BILL_ADDR_NO', bill_addr_no_, attr_);
   END IF;
   IF (rec_.route_id IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('ROUTE_ID', rec_.route_id, attr_);
   END IF;
   IF (rec_.delivery_leadtime IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('DELIVERY_LEADTIME', rec_.delivery_leadtime, attr_);
   END IF;
   IF (rec_.backorder_option IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('BACKORDER_OPTION_DB', rec_.backorder_option, attr_);
   END IF;
   IF (rec_.print_delivered_lines IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('PRINT_DELIVERED_LINES_DB', rec_.print_delivered_lines, attr_);
   END IF;
   
   company_ := Site_API.Get_Company(NVL(rec_.contract, default_contract_));
   supply_country_ := Company_Site_API.Get_Country_Db(NVL(rec_.contract, default_contract_));

   IF (rec_.vat_no IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('VAT_NO', rec_.vat_no, attr_);
      IF (rec_.tax_id_validated_date IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('TAX_ID_VALIDATED_DATE', rec_.tax_id_validated_date, attr_);
      END IF;
   END IF;

   -- Note: Sourced from Incoming Customer Order
   Client_SYS.Add_To_Attr('SOURCE_ORDER', 'ICO', attr_);

   Client_SYS.Add_To_Attr('USE_PRICE_INCL_TAX_DB', Customer_Tax_Calc_Basis_API.Get_Use_Price_Incl_Tax_Db(customer_no_,company_), attr_);
   Client_SYS.Add_To_Attr('LIMIT_SALES_TO_ASSORTMENTS_DB', limit_sales_to_assortments_, attr_);

   Customer_Order_API.New(info_, attr_);
   new_order_no_ := Client_SYS.Get_Item_Value('ORDER_NO',attr_);
   default_charges_ := NVL(Client_SYS.Get_Item_Value('DEFAULT_CHARGES', attr_), 'FALSE');

   IF ((rec_.order_no IS NULL) OR (rec_.contract IS NULL) OR (rec_.error_message IS NOT NULL) OR
       update_customer_ OR update_language_) THEN
      -- Store OrderNo, Contract and clear Error_Message.
      Get_Id_Version_By_Keys___(objid_, objversion_, message_id_);
      oldrec_ := Lock_By_Id___(objid_, objversion_);
      newrec_ := oldrec_;
      order_no_ := NVL(oldrec_.order_no, Client_SYS.Get_Item_Value('ORDER_NO', attr_));
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('ORDER_NO', order_no_, attr_);
      Client_SYS.Add_To_Attr('CONTRACT', NVL(oldrec_.contract, default_contract_), attr_);
      IF update_customer_ THEN

         Client_SYS.Add_To_Attr('CUSTOMER_NO', customer_no_, attr_);
      END IF;
      IF update_language_ THEN

         Client_SYS.Add_To_Attr('LANGUAGE_CODE', rec_.language_code, attr_);
      END IF;
      Client_SYS.Add_To_Attr('ERROR_MESSAGE', '', attr_);
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
      Update___(objid_, oldrec_, newrec_, attr_, objversion_);
   END IF;

   IF (rec_.internal_delivery_type = 'INTDIRECT') THEN
      IF (rec_.internal_po_no IS NOT NULL) THEN
         Client_SYS.Clear_Attr(temp_attr_);
         Client_SYS.Clear_Attr(info_);
         Customer_Order_API.Modify(info_,temp_attr_,new_order_no_);
      END IF;
   END IF;

   IF single_occurance_ THEN
      ship_addr_no_      := NVL(Customer_order_API.Get_Ship_Addr_No(new_order_no_), Cust_Ord_Customer_API.Get_Delivery_Address(customer_no_));
      vat_free_vat_code_ := Customer_Tax_Free_Tax_Code_API.Get_Tax_Free_Tax_Code(customer_no_, ship_addr_no_, company_, supply_country_, '*');

      Customer_Order_Address_API.New(NVL(rec_.order_no, order_no_),
                                     rec_.delivery_address_name, 
                                     rec_.ship_address1,
                                     rec_.ship_address2,
                                     rec_.ship_address3,
                                     rec_.ship_address4,
                                     rec_.ship_address5,
                                     rec_.ship_address6,
                                     rec_.ship_zip_code,
                                     rec_.ship_city, 
                                     rec_.ship_state, 
                                     rec_.ship_county, 
                                     rec_.country_code, 
                                     rec_.in_city,
                                     vat_free_vat_code_);
   END IF;

   -- Note: Added Copy_From_Customer_Charge() call in order to create customer order charge after customer order address record created.
   IF default_charges_ = 'TRUE' THEN
      Customer_Order_Charge_API.Copy_From_Customer_Charge(customer_no_, rec_.contract, NVL(rec_.order_no, order_no_));
   END IF;
   
   IF (NVL(rec_.same_database, Fnd_Boolean_API.DB_FALSE) = Fnd_Boolean_API.DB_TRUE) THEN
      -- Fetch and copy PO notes to the CO
      $IF Component_Purch_SYS.INSTALLED $THEN
         po_note_id_  := Purchase_Order_API.Get_Note_Id(rec_.internal_po_no);
      $END
      IF (po_note_id_ IS NOT NULL) THEN
         co_note_id_ := Customer_Order_API.Get_Note_Id(new_order_no_);
         Document_Text_API.Copy_All_Note_Texts(po_note_id_, co_note_id_);
      END IF;
   END IF;
EXCEPTION
   WHEN row_locked THEN
      IF (lock_same_int_order%ISOPEN) THEN
         CLOSE lock_same_int_order;         
      END IF;
      Error_SYS.Record_General(lu_name_, 'RUNNING: Another internal customer order is been processed for the same internal purchase order for the same site of the internal customer, or for the same customer number and the customer''s PO number.');         
END Transfer_Order___;


-- Transfer_Quotation___
--   Creates a new record in the Customer Order Quotation (header).
PROCEDURE Transfer_Quotation___ (
   message_id_     IN NUMBER,
   authorize_code_ IN VARCHAR2 )
IS
   info_             VARCHAR2(2000);
   attr_             VARCHAR2(32000);
   rec_              EXTERNAL_CUSTOMER_ORDER_TAB%ROWTYPE;
   newrec_           EXTERNAL_CUSTOMER_ORDER_TAB%ROWTYPE;
   oldrec_           EXTERNAL_CUSTOMER_ORDER_TAB%ROWTYPE;
   default_contract_ cust_ord_customer_tab.edi_site%TYPE := NULL;
   order_no_         customer_order_tab.order_no%TYPE;
   objid_            VARCHAR2(2000);
   objversion_       VARCHAR2(2000);   
   cust_rec_         Cust_Ord_Customer_API.Public_Rec;
   update_customer_  BOOLEAN := FALSE;
   update_language_  BOOLEAN := FALSE;
   indrec_           Indicator_Rec;
BEGIN

   rec_ := Get_Object_By_Keys___(message_id_);
   Client_SYS.Clear_Attr(attr_);

   -- Check if internal customer is used. In that case, get all defaults for that (internal) customer.
   IF (rec_.internal_customer_site IS NOT NULL) THEN
      rec_.customer_no := Cust_Ord_Customer_API.Get_Customer_No_From_Contract(rec_.internal_customer_site);

      update_customer_ := TRUE;
   END IF;

   cust_rec_      := Cust_Ord_Customer_API.Get(rec_.customer_no);

   -- Get attributes from customer
   IF (rec_.contract IS NULL) THEN
      default_contract_ := cust_rec_.edi_site;
   END IF;

   Client_SYS.Add_To_Attr('AUTHORIZE_CODE', authorize_code_, attr_);
   -- For new quotations there is no order type

   -- Get attributes from external order header
   Client_SYS.Add_To_Attr('QUOTATION_NO', rec_.order_no, attr_);
   Client_SYS.Add_To_Attr('CONTRACT', NVL(rec_.contract, default_contract_), attr_);
   Client_SYS.Add_To_Attr('CUSTOMER_NO', rec_.customer_no, attr_);
   Client_SYS.Add_To_Attr('WANTED_DELIVERY_DATE', rec_.delivery_date, attr_);
   Client_SYS.Add_To_Attr('CURRENCY_CODE', rec_.currency_code, attr_);
   Client_SYS.Add_To_Attr('CUST_REF', rec_.cust_ref, attr_);
   Client_SYS.Add_To_Attr('LABEL_NOTE', rec_.label_note, attr_);
   Client_SYS.Add_To_Attr('NOTE_TEXT', rec_.note_text, attr_);

   IF (rec_.pay_term_id IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('PAY_TERM_ID', rec_.pay_term_id, attr_);
   END IF;

   IF (rec_.delivery_terms IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('DELIVERY_TERMS', rec_.delivery_terms, attr_);
   END IF;

   IF (rec_.del_terms_location IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('DEL_TERMS_LOCATION', rec_.del_terms_location, attr_);
   END IF;

   IF (rec_.ship_via_code IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('SHIP_VIA_CODE', rec_.ship_via_code, attr_);
   END IF;

   IF (rec_.language_code IS NULL) THEN
      rec_.language_code := Cust_Ord_Customer_API.Get_Language_Code(rec_.customer_no);

      update_language_ := TRUE;
   END IF;
   Client_SYS.Add_To_Attr('LANGUAGE_CODE', rec_.language_code, attr_);

   Client_SYS.Add_To_Attr('EXTERNAL_REF', rec_.external_ref, attr_);

   IF (rec_.salesman_code IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('SALESMAN_CODE', rec_.salesman_code, attr_);
   END IF;

   IF (rec_.ean_location_del_addr IS NOT NULL) THEN
      -- EAN Location code
      Client_SYS.Add_To_Attr('SHIP_ADDR_NO',
         Cust_Ord_Customer_Address_API.Get_Id_By_Ean_Location(rec_.customer_no, rec_.ean_location_del_addr), attr_);
   END IF;

   -- New quotations don't have payers
   -- Handle document (bill) address
   IF (rec_.ean_location_doc_addr IS NOT NULL) THEN
      -- EAN Location code
      Client_SYS.Add_To_Attr('BILL_ADDR_NO',
         Cust_Ord_Customer_Address_API.Get_Id_By_Ean_Location(rec_.customer_no, rec_.ean_location_doc_addr), attr_);
   END IF;

   Client_SYS.Add_To_Attr('SOURCE_ORDER', 'ICO', attr_);

   Order_Quotation_API.New(info_, attr_);
   IF ((rec_.order_no IS NULL) OR (rec_.contract IS NULL) OR (rec_.error_message IS NOT NULL) OR
       update_customer_ OR update_language_) THEN
      -- Store OrderNo, Contract and clear Error_Message.
      Get_Id_Version_By_Keys___(objid_, objversion_, message_id_);
      oldrec_ := Lock_By_Id___(objid_, objversion_);
      newrec_ := oldrec_;
      order_no_ := NVL(oldrec_.order_no, Client_SYS.Get_Item_Value('QUOTATION_NO', attr_));
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('ORDER_NO', order_no_, attr_);
      Client_SYS.Add_To_Attr('CONTRACT', NVL(oldrec_.contract, default_contract_), attr_);
      IF update_customer_ THEN

         Client_SYS.Add_To_Attr('CUSTOMER_NO', rec_.customer_no, attr_);
      END IF;
      IF update_language_ THEN

         Client_SYS.Add_To_Attr('LANGUAGE_CODE', rec_.language_code, attr_);
      END IF;
      Client_SYS.Add_To_Attr('ERROR_MESSAGE', '', attr_);
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
      Update___(objid_, oldrec_, newrec_, attr_, objversion_);
   END IF;
END Transfer_Quotation___;


-- Replace_External___
--   check if the message should replace an existing order or quotation.
PROCEDURE Replace_External___ (
   external_ref_ IN VARCHAR2,
   customer_no_  IN VARCHAR2,
   quotation_    IN BOOLEAN )
IS
   order_no_     VARCHAR2(12);
   quotation_no_ VARCHAR2(12);
   objstate_     VARCHAR2(20);
BEGIN
   IF NOT quotation_ THEN
      -- Check if there is a customer order in status Planned
      -- for this external ref and customer no
      order_no_ := Customer_Order_API.Find_External_Ref_Order(external_ref_, customer_no_);
      -- Check the status of the order
      IF order_no_ IS NOT NULL THEN
         IF Customer_Order_API.Get_Objstate(order_no_) = 'Planned' THEN
            -- Cancel the customer order, it will be replaced
            Cancel_Customer_Order_API.Cancel_Order(order_no_);
         ELSE
            Error_SYS.Record_General(lu_name_,
                                     'NO_REPLACE_ORDER: Order :P1 could not be replaced since it is in status :P2',
                                     order_no_, Customer_Order_API.Get_State(order_no_));
         END IF;
      END IF;
   ELSE
      -- Check if there is a quotation in status Planned
      -- for this external ref and customer no
      quotation_no_ := Order_Quotation_API.Find_External_Ref_Quote(external_ref_, customer_no_);
      -- Check the status of the quotation
      IF quotation_no_ IS NOT NULL THEN
         objstate_ := Order_Quotation_API.Get_Objstate(quotation_no_);
         IF objstate_ = 'Planned' THEN
            -- Cancel the quotation, it will be replaced
            Order_Quotation_API.Set_Cancelled(quotation_no_);
         ELSE
            Error_SYS.Record_General(lu_name_,
                                     'NO_REPLACE_QUOTE: Quotation :P1 could not be replaced since it is in status :P2',
                                     quotation_no_, Order_Quotation_API.Get_State(quotation_no_));
         END IF;
      END IF;
   END IF;
END Replace_External___;


-- Release_Order___
--   Used for automatic release of the incoming Customer Order
PROCEDURE Release_Order___ (
   order_no_       IN VARCHAR2 )
IS
BEGIN
   Customer_Order_Flow_API.Release_Order(order_no_);
END Release_Order___;


PROCEDURE Do_Cancel___ (
   rec_  IN OUT EXTERNAL_CUSTOMER_ORDER_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   CURSOR cancel_all_lines IS
      SELECT message_line
      FROM   external_cust_order_line_tab
      WHERE  message_id = rec_.message_id
      AND    rowstate IN ('Changed', 'RequiresApproval', 'Stopped');
BEGIN
   FOR next_ IN cancel_all_lines LOOP
      External_Cust_Order_Line_API.Set_Line_Cancel(rec_.message_id, next_.message_line);
   END LOOP;
END Do_Cancel___;


PROCEDURE Do_Creation_Error___ (
   rec_  IN OUT EXTERNAL_CUSTOMER_ORDER_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   oldrec_     EXTERNAL_CUSTOMER_ORDER_TAB%ROWTYPE;
   newrec_     EXTERNAL_CUSTOMER_ORDER_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   error_msg_  VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN
   oldrec_ := Lock_By_Keys___(rec_.message_id);
   newrec_ := oldrec_;
   error_msg_ := Client_SYS.Get_Item_Value('ERROR_MESSAGE', attr_);
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
   Client_SYS.Add_To_Attr('ERROR_MESSAGE', error_msg_, attr_);
   Cust_Order_Event_Creation_API.External_Order_Stopped(newrec_.message_id, error_msg_);
END Do_Creation_Error___;


PROCEDURE Do_Approve___ (
   rec_  IN OUT EXTERNAL_CUSTOMER_ORDER_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   info_                       VARCHAR2(2000);
   message_line_               NUMBER := NULL;
   newrec_                     EXTERNAL_CUSTOMER_ORDER_TAB%ROWTYPE;
   objid_                      VARCHAR2(2000);
   objversion_                 VARCHAR2(2000);
   error_message_              VARCHAR2(2000);
   authorize_code_             cust_ord_customer_tab.edi_authorize_code%TYPE;
   order_id_                   cust_ord_customer_tab.order_id%TYPE;
   quotation_                  BOOLEAN;
   int_deliv_type_             VARCHAR2(4);
   auth_group_                 VARCHAR2(2);
   current_quot_no_            NUMBER;
   current_co_no_              NUMBER;
   customer_no_                EXTERNAL_CUSTOMER_ORDER_TAB.customer_no%TYPE; 
   site_cust_rec_              Message_Defaults_Per_Cust_API.Public_Rec;
   site_rec_                   Site_Discom_Info_API.Public_Rec;
   default_contract_           CUST_ORD_CUSTOMER_TAB.edi_site%TYPE := NULL;
   cust_rec_                   Cust_Ord_Customer_API.Public_Rec;
   exception_on_rollback_      BOOLEAN:=FALSE;
   ext_order_no_               Customer_Order_Tab.Order_No%TYPE;  
   limit_sales_to_assortments_ CUSTOMER_ORDER_TAB.limit_sales_to_assortments%TYPE;
   
   CURSOR approve_all_lines IS
      SELECT message_line
      FROM   external_cust_order_line_tab
      WHERE  message_id = rec_.message_id
      AND    rowstate IN ('RequiresApproval', 'Changed', 'Stopped');
      
   CURSOR previous_errors(current_line_ NUMBER) IS
      SELECT message_line
      FROM   external_cust_order_line_tab
      WHERE  message_id = rec_.message_id
      AND    message_line < current_line_
      AND    rowstate != 'Cancelled'
      AND    error_message IS NOT NULL;
BEGIN
   @ApproveTransactionStatement(2014-08-15,darklk)
   SAVEPOINT approve;

   quotation_ := NVL((NVL(rec_.import_mode, 'ORDER') = 'QUOTATION'),FALSE);

   IF (rec_.internal_customer_site IS NOT NULL) THEN
      customer_no_ := Cust_Ord_Customer_API.Get_Customer_No_From_Contract(rec_.internal_customer_site);
   END IF;

   customer_no_ := NVL(customer_no_, rec_.customer_no);

   -- check if this message should replace an existing order or quotation
   Replace_External___(rec_.external_ref, customer_no_, quotation_);

   authorize_code_ := Client_SYS.Get_Item_Value('AUTHORIZE_CODE', attr_);
   order_id_ := Client_SYS.Get_Item_Value('ORDER_ID', attr_);
   limit_sales_to_assortments_ := Client_SYS.Get_Item_Value('LIMIT_SALES_TO_ASSORTMENTS', attr_);
   
   cust_rec_      := Cust_Ord_Customer_API.Get(customer_no_);

   -- Get attributes from customer
   IF (rec_.contract IS NULL) THEN
      default_contract_ := cust_rec_.edi_site;
   END IF;
   
   -- Get edi_authorize_code from site/customer, site, customer
   IF authorize_code_ IS NULL THEN 
      site_cust_rec_ := Message_Defaults_Per_Cust_API.Get(NVL(rec_.contract, default_contract_), customer_no_);
      site_rec_      := Site_Discom_Info_API.Get(NVL(rec_.contract, default_contract_));
      IF (site_cust_rec_.edi_auto_order_approval IS NULL) OR (site_cust_rec_.edi_auto_order_approval = Approval_Option_API.DB_NOT_APPLICABLE) THEN
         IF (site_rec_.edi_auto_order_approval IS NULL) OR (site_rec_.edi_auto_order_approval = Approval_Option_API.DB_NOT_APPLICABLE) THEN
            IF (cust_rec_.edi_auto_order_approval = Approval_Option_API.DB_AUTOMATICALLY) THEN
               authorize_code_ := cust_rec_.edi_authorize_code;
            END IF;
         ELSIF (site_rec_.edi_auto_order_approval = Approval_Option_API.DB_AUTOMATICALLY) THEN
            authorize_code_ := site_rec_.edi_authorize_code;
         END IF;
      ELSIF (site_cust_rec_.edi_auto_order_approval = Approval_Option_API.DB_AUTOMATICALLY) THEN
         authorize_code_ := site_cust_rec_.edi_authorize_code;
      END IF;               
   END IF;         
      
   IF (authorize_code_ IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'EDI_COORD_NOTFOUND: EDI coordinator is missing for customer :P1', customer_no_);
   END IF;
   auth_group_ := Order_Coordinator_API.Get_Authorize_Group(authorize_code_);

   IF quotation_ THEN
      current_quot_no_ := Order_Coordinator_Group_API.Get_Quotation_No(auth_group_);
      -- Create order quotation head
      Transfer_Quotation___(rec_.message_id, authorize_code_);
   ELSE
      current_co_no_ := Order_Coordinator_Group_API.Get_Cust_Order_No(auth_group_);
      -- Create customer order head
      Transfer_Order___(rec_.message_id, authorize_code_, order_id_, limit_sales_to_assortments_);
   END IF;

   -- Create customer order lines or quotation lines
   FOR next_ IN approve_all_lines LOOP
      message_line_ := next_.message_line;
      External_Cust_Order_Line_API.Set_Line_Approve(rec_.message_id, message_line_);
   END LOOP;
   message_line_ := NULL;

   -- Everything OK. Change status to 'Created'. Commit is handled by the client
   Client_SYS.Clear_Attr(attr_);
   newrec_ := Get_Object_By_Keys___(rec_.message_id);
   Get_Id_Version_By_Keys___(objid_, objversion_, rec_.message_id);
   Order_Created__(info_, objid_, objversion_, attr_, 'DO');

   -- Check whether the external CO is blocked and raise a info message
   Customer_Order_Line_API.Get_External_Cust_Order(ext_order_no_, newrec_.order_no);  
   IF ext_order_no_ IS NOT NULL AND ext_order_no_ != newrec_.order_no THEN      
      IF (Customer_Order_API.Get_Objstate(ext_order_no_) = 'Blocked') THEN
         IF Customer_order_API.Get_Blocked_Type_Db(ext_order_no_) = Customer_Order_Block_Type_API.DB_MANUAL_BLOCKED THEN
            Client_SYS.Add_Info(lu_name_, 'EXTMANBLOCK: External CO is manually blocked so the order will be blocked.');
         END IF;
      END IF;
   END IF;
      
   IF NOT quotation_ THEN
      -- if the automatic customer order release flag is set on the site customer/ site / customer, start the release of the customer order
      site_cust_rec_ := Message_Defaults_Per_Cust_API.Get(NVL(rec_.contract, default_contract_), newrec_.customer_no);
      site_rec_      := Site_Discom_Info_API.Get(NVL(rec_.contract, default_contract_));
               
      IF (site_cust_rec_.release_internal_order IS NULL) OR (site_cust_rec_.release_internal_order = Approval_Option_API.DB_NOT_APPLICABLE) THEN
         IF (site_rec_.release_internal_order IS NULL) OR (site_rec_.release_internal_order = Approval_Option_API.DB_NOT_APPLICABLE) THEN
            IF (Cust_Ord_Customer_API.Get_Release_Internal_Order_Db(newrec_.customer_no) = Approval_Option_API.DB_AUTOMATICALLY) THEN
               Release_Order___(newrec_.order_no);
            END IF;   
         ELSIF (site_rec_.release_internal_order = Approval_Option_API.DB_AUTOMATICALLY) THEN
            Release_Order___(newrec_.order_no);
         END IF;
      ELSIF (site_cust_rec_.release_internal_order = Approval_Option_API.DB_AUTOMATICALLY) THEN
         Release_Order___(newrec_.order_no);
      END IF;
   END IF;

   Client_SYS.Add_To_Attr('ORDER_NO', newrec_.order_no, attr_);
   Client_SYS.Add_To_Attr('CONTRACT', newrec_.contract, attr_);
   Client_SYS.Add_To_Attr('CUSTOMER_NO', newrec_.customer_no, attr_);
   Client_SYS.Add_To_Attr('LANGUAGE_CODE', newrec_.language_code, attr_);
   Client_SYS.Add_To_Attr('ERROR_MESSAGE', newrec_.error_message, attr_);

   IF (newrec_.internal_delivery_type = 'INTDIRECT') THEN
      int_deliv_type_ := '3';
   ELSIF (newrec_.internal_delivery_type = 'INTTRANSIT') THEN
      int_deliv_type_ := '4';
   ELSE
      int_deliv_type_ := NULL;
   END IF;
   Customer_Order_Transfer_API.Update_Ordchg_On_Create_Order(newrec_.internal_po_no, newrec_.order_no, int_deliv_type_);

   rec_ := Get_Object_By_Keys___(rec_.message_id);
EXCEPTION
   WHEN others THEN
      error_message_ := SQLERRM;
      -- handle the situation where approve save point is invalid because of commits in order flow
      BEGIN
         @ApproveTransactionStatement(2014-08-15,darklk)
         ROLLBACK TO approve;   
      EXCEPTION
         WHEN others THEN
            exception_on_rollback_ := TRUE;
            NULL;       
         END;
      IF (NOT exception_on_rollback_) THEN   
         IF (current_co_no_ IS NOT NULL) THEN
            Order_Coordinator_Group_API.Reset_Cust_Order_No_Autonomous(auth_group_, current_co_no_);
         ELSIF (current_quot_no_ IS NOT NULL) THEN
            Order_Coordinator_Group_API.Reset_Quotation_No_Autonomous(auth_group_, current_quot_no_);
         END IF;
         -- An error was trapped. Rollback entire transaction and write error_message.
         IF (message_line_ IS NULL) THEN
            -- The error was caused when creating order header
            Client_SYS.Clear_Attr(attr_);
            Client_SYS.Add_To_Attr('ERROR_MESSAGE', error_message_, attr_);
            Get_Id_Version_By_Keys___(objid_, objversion_, rec_.message_id);
            Order_Creation_Error__(info_, objid_, objversion_, attr_, 'DO');
            rec_ := Get_Object_By_Keys___(rec_.message_id);
         ELSE
            -- Only if there are no errors in all the previous lines, it processes the current line. So all the error messages 
            -- for previous lines will be cleared before setting the error for the current line.
            FOR error_recs_ IN previous_errors(message_line_) LOOP
               External_Cust_Order_Line_API.Set_Line_Error(rec_.message_id, error_recs_.message_line, NULL);
            END LOOP;         
            -- The error was caused when creating order line
            External_Cust_Order_Line_API.Set_Line_Error(rec_.message_id, message_line_, error_message_);
            newrec_ := Get_Object_By_Keys___(rec_.message_id);
            rec_:= newrec_;
            Client_SYS.Add_To_Attr('ERROR_MESSAGE', newrec_.error_message, attr_);
         END IF;
      END IF;
END Do_Approve___;


-- Get_Jinsui_Invoice_Defaults___
--   Gets default value for the Junsui Invoice.
FUNCTION Get_Jinsui_Invoice_Defaults___ (
   company_     IN VARCHAR2,
   customer_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   cust_no_         EXTERNAL_CUSTOMER_ORDER_TAB.customer_no%TYPE;
   jinsui_invoice_  EXTERNAL_CUSTOMER_ORDER_TAB.jinsui_invoice%TYPE;   
BEGIN
   -- Get the default value for create jinsui info.
   $IF Component_Jinsui_SYS.INSTALLED $THEN
      cust_no_ := NVL(Cust_Ord_Customer_API.Get_Customer_No_Pay(customer_no_),customer_no_);      
      jinsui_invoice_ := Js_Customer_Info_API.Get_Create_Js_Invoice(company_, cust_no_);
   $END
   jinsui_invoice_ := NVL(jinsui_invoice_,'FALSE');
   RETURN jinsui_invoice_; 
END Get_Jinsui_Invoice_Defaults___;


-- Validate_Jinsui_Constraints___
--   Performs validation with the Junsi Invoice Constraints.
PROCEDURE Validate_Jinsui_Constraints___ (
   newrec_ IN EXTERNAL_CUSTOMER_ORDER_TAB%ROWTYPE )
IS
   cust_no_           EXTERNAL_CUSTOMER_ORDER_TAB.customer_no%TYPE;
   create_js_invoice_ VARCHAR2(20);   
   company_           VARCHAR2(20);
BEGIN
   $IF Component_Jinsui_SYS.INSTALLED $THEN
   IF newrec_.jinsui_invoice = 'TRUE' THEN
      company_ := Site_API.Get_Company(newrec_.contract);
      cust_no_ := NVL(newrec_.customer_no_pay,newrec_.customer_no);
         create_js_invoice_ := Js_Customer_Info_API.Get_Create_Js_Invoice(company_, cust_no_);
        
      IF (create_js_invoice_ = 'FALSE') THEN
         Error_SYS.Record_General(lu_name_, 'NOJINSUI: You cannot have a Jinsui Order when :P1 is not Jinsui enabled.',cust_no_);
      END IF;
   END IF;
   $ELSE
      NULL;
   $END   
END Validate_Jinsui_Constraints___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     EXTERNAL_CUSTOMER_ORDER_TAB%ROWTYPE,
   newrec_     IN OUT EXTERNAL_CUSTOMER_ORDER_TAB%ROWTYPE,
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

   IF (newrec_.error_message IS NULL) THEN
      Get_Id_Version_By_Keys___(rowid_, objversion_, newrec_.message_id);
      Changed__(info_, rowid_, objversion_, attr_, 'DO');
   END IF;
END Update___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT external_customer_order_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   company_  VARCHAR2(20);

BEGIN
   IF (newrec_.import_mode IS NOT NULL) THEN
      Order_Config_Import_Mode_API.Exist_Db(newrec_.import_mode);
   END IF;
   
   company_ := Site_API.Get_Company(newrec_.contract);
   IF (newrec_.jinsui_invoice IS NULL) THEN
      newrec_.jinsui_invoice := Get_Jinsui_Invoice_Defaults___(company_, newrec_.customer_no);
   END IF;
   super(newrec_, indrec_, attr_);

   -- if delivery_terms_desc or ship_via_desc is empty, add default description
   IF (newrec_.delivery_terms IS NOT NULL AND newrec_.delivery_terms_desc IS NULL) THEN
      newrec_.delivery_terms_desc := Order_Delivery_Term_API.Get_Description(newrec_.delivery_terms);
      Client_SYS.Add_To_Attr('DELIVERY_TERMS_DESC', newrec_.delivery_terms_desc, attr_);
   END IF;
   IF (newrec_.ship_via_code IS NOT NULL AND newrec_.ship_via_desc IS NULL) THEN
      newrec_.ship_via_desc := Mpccom_Ship_Via_API.Get_Description(newrec_.ship_via_code);
      Client_SYS.Add_To_Attr('SHIP_VIA_DESC', newrec_.ship_via_desc, attr_);
   END IF;

   IF newrec_.created_date IS NULL THEN 
      IF newrec_.contract IS NOT NULL THEN
         newrec_.created_date := Site_API.Get_Site_Date(newrec_.contract);
      ELSE
         newrec_.created_date := sysdate;
      END IF;
      Client_SYS.Add_To_Attr('CREATED_DATE', newrec_.created_date, attr_);
   END IF;
   
   -- Add import mode back to client
   Client_SYS.Add_To_Attr('IMPORT_MODE', newrec_.import_mode, attr_);

   -- Validate Jinsui Invoice.
      Validate_Jinsui_Constraints___(newrec_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     external_customer_order_tab%ROWTYPE,
   newrec_ IN OUT external_customer_order_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   -- Clear the error_message.
   IF NOT indrec_.error_message THEN 
      newrec_.error_message := NULL;
   END IF;

   IF (newrec_.import_mode IS NOT NULL) THEN
      Order_Config_Import_Mode_API.Exist_Db(newrec_.import_mode);
   END IF;
   
   IF NOT indrec_.tax_id_validated_date THEN
      IF (NVL(oldrec_.vat_no, '#####') != NVL(newrec_.vat_no, '#####')) THEN
         newrec_.tax_id_validated_date := NULL;
      END IF;
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);

   IF (newrec_.rowstate = 'Created') THEN
      Error_SYS.Record_General(lu_name_, 'NOTUPDATE: Changes are not allowed for Created Orders.');
   END IF;
   
   Error_Sys.Trim_Space_Validation(newrec_.order_no);
   
   -- Add import mode back to client
   Client_SYS.Add_To_Attr('IMPORT_MODE', newrec_.import_mode, attr_);
   -- Validate Jinsui Invoice.
      Validate_Jinsui_Constraints___(newrec_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@Override
PROCEDURE Approve__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
BEGIN
   super(info_, objid_, objversion_, attr_, action_);
   info_ := SUBSTR(info_ , 1, 2000);
END Approve__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- New
--   Creates a new record with specified attributes
PROCEDURE New (
   attr_ IN VARCHAR2 )
IS
   newrec_     EXTERNAL_CUSTOMER_ORDER_TAB%ROWTYPE;
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

-- Set_Approve
--   Approve order and order lines. If any error occurs, the error message
--   is stored and no Customer Order is generated.
PROCEDURE Set_Approve (
   message_id_ IN NUMBER )
IS
   info_       VARCHAR2(2000);
   attr_       VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, message_id_);
   Client_SYS.Clear_Attr(attr_);
   Approve__(info_, objid_, objversion_, attr_, 'DO');
END Set_Approve;


-- Set_Head_Changed
--   Changes the status on the record to 'Changed'
PROCEDURE Set_Head_Changed (
   message_id_ IN NUMBER )
IS
   info_       VARCHAR2(2000);
   attr_       VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, message_id_);
   Client_SYS.Clear_Attr(attr_);
   Changed__(info_, objid_, objversion_, attr_, 'DO');
END Set_Head_Changed;


-- Set_Head_Error
--   Changes the record state to 'Error' and stores the error message generated.
PROCEDURE Set_Head_Error (
   message_id_    IN NUMBER,
   error_message_ IN VARCHAR2 )
IS
   info_       VARCHAR2(2000);
   attr_       VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, message_id_);
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('ERROR_MESSAGE', error_message_, attr_);
   Order_Creation_Error__(info_, objid_, objversion_, attr_, 'DO');
END Set_Head_Error;


-- Find_Message_From_Ext_Ref
--   Finds any message with the given external reference
--   which has yet not been approved or cancelled.
@UncheckedAccess
FUNCTION Find_Message_From_Ext_Ref (
   external_ref_ IN VARCHAR2 ) RETURN NUMBER
IS
   message_id_ NUMBER;

   CURSOR get_message_id IS
      SELECT message_id
      FROM   EXTERNAL_CUSTOMER_ORDER_TAB
      WHERE  rowstate NOT IN ('Cancelled', 'Created')
      AND    external_ref = external_ref_;
BEGIN
   OPEN get_message_id;
   FETCH get_message_id INTO message_id_;
   IF get_message_id%NOTFOUND THEN
      message_id_ := NULL;
   END IF;
   CLOSE get_message_id;
   RETURN message_id_;
END Find_Message_From_Ext_Ref;


-- Find_Message_Id
--   Get message id for an approved customer order.
--   Returns same_database value for a given PO number
@UncheckedAccess
FUNCTION Find_Message_Id (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   message_id_ NUMBER;

   CURSOR get_message_id IS
      SELECT message_id
      FROM   EXTERNAL_CUSTOMER_ORDER_TAB
      WHERE  rowstate != 'Cancelled'
      AND    order_no = order_no_;
BEGIN
   OPEN get_message_id;
   FETCH get_message_id INTO message_id_;
   IF get_message_id%NOTFOUND THEN
      message_id_ := NULL;
   END IF;
   CLOSE get_message_id;
   RETURN message_id_;
END Find_Message_Id;

--Check_In_Cust_Ord_Exist_Db
--   Returns Databse value of attribute same_database for a given PO number
@UncheckedAccess
FUNCTION Check_In_Cust_Ord_Exist_Db(
   int_po_no_ IN VARCHAR2 ) RETURN VARCHAR2 
IS
   temp_ VARCHAR2(20);
   CURSOR get_attr IS
      SELECT same_database
      FROM EXTERNAL_CUSTOMER_ORDER_TAB
      WHERE internal_po_no = int_po_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Check_In_Cust_Ord_Exist_Db;

-- Find_Message_From_Cust_Po
--   Returns the Message Id for a given Customer's Customer PO Number.
FUNCTION Find_Message_From_Cust_Po (
   customer_no_    IN VARCHAR2,
   customer_po_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   message_id_       NUMBER;

   CURSOR get_with_customer_no IS
      SELECT message_id
      FROM EXTERNAL_CUSTOMER_ORDER_TAB
      WHERE customer_no = customer_no_
      AND   customer_po_no = customer_po_no_;

   CURSOR get_with_cust_po_no IS
      SELECT message_id
      FROM EXTERNAL_CUSTOMER_ORDER_TAB
      WHERE   customer_po_no = customer_po_no_;


BEGIN
   IF customer_no_ IS NULL THEN
      OPEN get_with_cust_po_no;
      FETCH get_with_cust_po_no INTO message_id_;
      CLOSE get_with_cust_po_no;
   ELSE
      OPEN get_with_customer_no;
      FETCH get_with_customer_no INTO message_id_;
      CLOSE get_with_customer_no;
   END IF;

   RETURN message_id_;
END Find_Message_From_Cust_Po;


-- Cancel
--   Cancels the external customer order, preventing approval.
PROCEDURE Cancel (
   message_id_ IN NUMBER )
IS
   info_       VARCHAR2(2000);
   attr_       VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, message_id_);
   Client_SYS.Clear_Attr(attr_);
   Cancel__(info_, objid_, objversion_, attr_, 'DO');
END Cancel;


-- Count_Message_From_Ext_Ref
--   Returns number of 'new' external orders found with the
--   specified external reference id ('new' meaning orders not
--   approved or cancelled).
@UncheckedAccess
FUNCTION Count_Message_From_Ext_Ref (
   external_ref_ IN VARCHAR2 ) RETURN NUMBER
IS
   count_ NUMBER;

   CURSOR get_message_id IS
      SELECT count(*)
      FROM   EXTERNAL_CUSTOMER_ORDER_TAB
      WHERE  rowstate != 'Cancelled'
      AND    external_ref = external_ref_;
BEGIN
   OPEN get_message_id;
   FETCH get_message_id INTO count_;
   IF get_message_id%NOTFOUND THEN
      count_ := 0;
   END IF;
   CLOSE get_message_id;
   RETURN count_;
END Count_Message_From_Ext_Ref;


-- Is_Quotation
--   Returns TRUE if this external object is really a Quotation.
FUNCTION Is_Quotation (
   message_id_ IN NUMBER ) RETURN BOOLEAN
IS
   rec_ EXTERNAL_CUSTOMER_ORDER_TAB%ROWTYPE;
BEGIN
   rec_ := Get_Object_By_Keys___(message_id_);
   RETURN (NVL(rec_.import_mode, 'ORDER') = 'QUOTATION');
END Is_Quotation;


-- Customer_Order_No_Exists
--   This method checks if an Incoming CO with the specified co number exists
--   in EXTERNAL_CUSTOMER_ORDER_TAB. If so returns TRUE, if not returns FALSE.
@UncheckedAccess
FUNCTION Customer_Order_No_Exists (
   order_no_   IN VARCHAR2 ) RETURN BOOLEAN
IS
   exists_     NUMBER := 0;

   CURSOR get_order_exists IS
      SELECT 1
      FROM EXTERNAL_CUSTOMER_ORDER_TAB
      WHERE order_no = order_no_;
BEGIN
   OPEN get_order_exists;
   FETCH get_order_exists INTO exists_;
   CLOSE get_order_exists;

   RETURN (exists_ = 1);
END Customer_Order_No_Exists;

PROCEDURE Update_Tax_Id_Validated_Date (
   message_id_ IN NUMBER )
IS
   info_       VARCHAR2(2000);
   attr_       VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, message_id_);
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('TAX_ID_VALIDATED_DATE', CURRENT_DATE, attr_);
   Modify__(info_, objid_ , objversion_, attr_, 'DO');
END Update_Tax_Id_Validated_Date;

@UncheckedAccess
FUNCTION Get_Tax_Id_Type (
   message_id_    IN NUMBER) RETURN VARCHAR2
IS
   rec_              EXTERNAL_CUSTOMER_ORDER_TAB%ROWTYPE;
   cust_rec_         Cust_Ord_Customer_API.Public_Rec;
   contract_         VARCHAR2(5);
   customer_no_      VARCHAR2(20);
   company_          VARCHAR2(20);   
   bill_addr_no_     VARCHAR2(50);   
   ship_addr_no_     VARCHAR2(20);
   supply_country_   VARCHAR2(2);
   delivery_country_ VARCHAR2(2);
   tax_id_type_      VARCHAR2(10);
BEGIN    
   rec_ := Get_Object_By_Keys___(message_id_);
   
   -- Check if internal customer is used. In that case, get all defaults for that (internal) customer.
   IF (rec_.internal_customer_site IS NOT NULL) THEN
      rec_.customer_no := Cust_Ord_Customer_API.Get_Customer_No_From_Contract(rec_.internal_customer_site);
   END IF;
     
   IF (rec_.customer_no IS NULL AND rec_.ean_location_del_addr IS NOT NULL) THEN
      Customer_Info_Address_API.Get_Id_By_Ean_Loc_If_Unique(customer_no_, ship_addr_no_, rec_.ean_location_del_addr);
      
      IF (customer_no_ IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'EAN_NOT_UNIQUE: Customer Info could not be found using the EAN Address Location. Either it is not unique for only one customer, or it does not exist. Please review the setup of Customer''s Own Address ID.');
      END IF;
   ELSE
      ship_addr_no_ := Cust_Ord_Customer_Address_API.Get_Id_By_Ean_Location(rec_.customer_no, rec_.ean_location_del_addr);
   END IF;
   
   customer_no_      := NVL(rec_.customer_no, customer_no_);   
   cust_rec_         := Cust_Ord_Customer_API.Get(customer_no_);     
   contract_         := rec_.contract;
   delivery_country_ := rec_.country_code;
   
   IF delivery_country_ IS NULL THEN
      delivery_country_ := Customer_Info_Address_API.Get_Country_Db(customer_no_, ship_addr_no_);
   END IF;
   IF (contract_ IS NULL) THEN
      contract_ := cust_rec_.edi_site;
   END IF;   
   
   company_          := Site_API.Get_Company(contract_);
   supply_country_   := Company_Site_API.Get_Country_Db(contract_);
   
   IF (rec_.ean_location_doc_addr IS NOT NULL) THEN
      bill_addr_no_  := Cust_Ord_Customer_Address_API.Get_Id_By_Ean_Location(customer_no_, rec_.ean_location_doc_addr);
   END IF;
   
   tax_id_type_      := Tax_Handling_Order_Util_API.Fetch_And_Validate_Tax_Id(customer_no_, bill_addr_no_, company_, supply_country_, delivery_country_);
   
   RETURN tax_id_type_;
END Get_Tax_Id_Type;
