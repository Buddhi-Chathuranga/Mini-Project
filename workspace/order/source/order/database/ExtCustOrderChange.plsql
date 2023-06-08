-----------------------------------------------------------------------------
--
--  Logical unit: ExtCustOrderChange
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  211223  Skanlk  Bug 161134(SC21R2-6825), Added Fetch_And_Validate_Tax_Id() and Get_Tax_Id_Type() to validate Tax ID other than EU countires.
--  200624  ChBnlk  SC2020R1-7485, Removed the methods added to handle ReceiveCustOrderChange Inet Transfer message since the 
--  200624          implementation was moved to Customer_Order_Transfer_API.
--  200519  ChBnlk  SC2020R1-6906, Added new methods Create_Cust_Ord_Chg_Inet_Trans, Ext_Cust_Ord_Change_Struct_New___, Ext_Cust_Ord_Change_Struct_Ext_Cust_Order_Line_Change_New___,
--  200519          Get_Next_Change_Line___, Ext_Cust_Ord_Change_Struct_Ext_Cust_Order_Line_Change_Copy_From_Header___, Ext_Cust_Ord_Change_Struct_Ext_Cust_Order_Char_Change_Copy_From_Header___,
--  200519          to handle InetTrans message parsing.
--  191011  Satglk  Bug SCXTEND-887, Modified Check_Insert___ to assign the newly created date to Created Date field.
--  180918  ChJalk  Bug 143524(SCZ-959), Modified Do_Approve___() to ignore aproving the same message line two times when manually pegged into more than one purchase orders.
--  180720  ErFelk  Bug 142232, Modified Do_Approve___() by assigning next_.po_order_no to previous_po_order_no_ at the end of the loop.
--  180510  ChBnlk  Bug 140555, Modified Transfer_Order_Changes___() in order to reassign NULL for the customer_po_no when updating the customer order, to force update
--  180510          the customer_po_no_ with NULL in the internal customer order, when there are lines with demand code ICD.
--  171221  TiRalk  STRSC-15360, Reverted STRSC-7860. When external PO details sent through change request, it prevents adding a new CO line to Invoiced CO which is wrong.
--  170509  TiRalk  STRSC-7860, Modified Transfer_Order_Changes___ to avoid processing change order whetn the customer order is processed.
--  160921  Maabse  APPUXX-4844, Added column b2b_process_online with support for columns ship_addr_no and bill_addr_no.
--  160608  reanpl  STRLOC-428, Added handling of new attributes ship_address3..ship_address6 
--  150226  SURBLK  Modified Transfer_Order_Changes___() to change document text deletion method by comparing output types.
--  150119  Chfose  PRSC-5160, Modified the MISSING_ORDER_NO error message.
--  141023  RoJalk  Handled PRINT_DELIVERED_LINES_DB in the method Get_Changed_Attributes__.
--  141021  RoJalk  Handled print_delivered_lines in the Transfer_Order_Changes___ method.
--  140710  MAHPLK  Removed SHIPMENT_TYPE from ExtCustOrderChange LU.
--  140707  MAHPLK  Modified Do_Approve___ to conditionally enable COMMIT and ROLLBACK.
--  140423  KiSalk  Bug 111264, Modified Do_Approve___ to call Ext_Cust_Order_Line_Change_API.Set_Line_Approve with new last_line_ 'FALSE' for last line
--  140423          in order to send Change Request for last line of the message only.
--  130808  ShKolk  Added column same_database to save if received message originated from same database or a different database 
--  130808          and Modified Transfer_Order_Changes___ to copy doc texts of internal PO.
--  120905  MAHPLK  Added picking_leadtime and shipment_type.
--  111215  MaMalk  Modified Insert___ to move the setting of objversion_ to the end of this procedure.
--  111018  JuMalk  Bug 99054, Mofified Transfer_Order_Changes___. Added the address flag to the attribute string when the default address is fetched.   
--  110823  IsSalk  Bug 97628, Modified Do_Approve___ to cancel the CO when all the lines are cancelled and 
--  110823          there are no unconnected charges lines and CO is not used by Customer Schedules
--  110701  SudJlk  Bug 95932, Modified method Transfer_Order_Changes___ to only modify NOTE_TEXT when the incoming value is not NULL.
--  110520  NiDalk  Bug 95291, Modified Transfer_Order_Changes___ to get the correct ship address when fetching vat_free_vat_code_.
--  110309  Kagalk  RAVEN-1074, Added tax_id_validated_date field
--  110223  MaMalk  Replaced Customer_Info_Vat_API with new APIs.
--  110202  Nekolk  EANE-3744  added where clause to View EXT_CUST_ORDER_CHANGE.
--  100720  JuMalk  Bug 91923, Added null check to Transfer_Order_Changes___ and Transfer_Quotation_Changes___when assigning customer reference.
--  100709  ShVese  Added record fetching in Do_Approve___ when an exception is raised.
--  100520  KRPELK  Merge Rose Method Documentation.
--  100510  ShVese  Finite_State_Machine alignment according to dev studio.
--  091229  MaRalk  Modified the state machine according to the new developer studio template - 2.5.
--  091204  KiSalk  Cloumn length for backorder_option_db in view comments set to 40.
--  090930  MaMalk  Removed constant state_separator_. Modified Modify_Change_Request and Finite_State_Init___ to remove unused code.
--  ------------------------- 14.0.0 -----------------------------------------
--  090330  HimRlk  Bug 80277, Added columns internal_po_label_note and org_internal_po_label_note.
--  080918  HoInlk  Bug 67780, Added columns internal_ref, org_internal_ref and org_customer_po_no.
--  080623  NaLrlk  Bug 74960, Added check for del_terms_location is null in method Transfer_Order_Changes___.
--  080208  NaLrlk  Bug 70005, Removed the check not null condition for del_terms_location in Transfer_Order_Changes___.
--  080130  NaLrlk  Bug 70005, Added private columns del_terms_location, org_del_terms_location and Modified methods
--  080130          for del_terms_location in Transfer_Order_Changes___, Get_Changed_Attributes__.
--  070511  ChBalk  Bug 63020, Modified Transfer_Order_Changes___ in order to insert vat_free_vat_code into customer_order_address_tab.
--  070323  MalLlk  Bug 60882, Removed vat_no from function calls of Modify and New of CustomerOrderAddress LU. 
--  070323          Passed NULL instead vat_no for function calls of Modify and New of CustomerOrderAddress LU. 
--  070124  SuSalk  Added DELIVERY_TERMS_DESC & SHIP_VIA_DESC to base view. 
--  070123  SuSalk  Removed DELIVERY_TERMS_DESC & SHIP_VIA_DESC from attr.
--  070118  KaDilk  Removed Language code from the Method call Order_Delivery_Term_API.Get_Description.
--  070118  SuSalk  Modified Mpccom_Ship_Via_API.Get_Description method call.
--  061222  SuSalk  LCS Merge 61831, Added method Modify_Change_Request.
--  061215  NaLrlk  Replace allow_backorders to backorder_option in Transfer_Order_Changes___
--  061125  Cpeilk  Added columns VAT_NO and ORG_VAT_NO.
--  061110  NaLrlk  Removed the columns allow_backorders,org_allow_backorders and added columns backorder_option,org_backorder_option.
--                  Removed the functions Get_Allow_Backorders,Get_Org_Allow_Backorders and Added functions Get_Backorder_Option,Get_Org_Backorder_Option.
--  060725  ChJalk  Modified call Mpccom_Ship_Via_Desc_API.Get_Description to Mpccom_Ship_Via_API.Get_Description
--  060725          and Order_Delivery_Term_Desc_API.Get_Description to Order_Delivery_Term_API.Get_Description.
--  060206  CsAmlk  Changed Ean Location Payer Addr and Org Ean Location Payer Addr to Old Cust Own Pay Addr and Cust Own Pay Addr
--  060119  MaHplk  Replace 'SELECT &OBJID INTO....' statement with RETURNING &OBJID INTO objid_.
--  050922  NaLrlk  Removed unused variables.
--  050722  VeMolk  Bug 52517, Modified the method Transfer_Order_Changes___.
--  050614  KiSalk  Bug 50953, Added last parameter NULL to calls New & Modify of Customer_Order_Address_API.
--  050509  KiSalk  Bug 50697, Modified Get_Changed_Attributes__, Transfer_Order_Changes___
--  050509          and Do_Approve___ to process on real changes only.
--  050415  ChJalk  Bug 50263, Added columns Allow_Backorders, Org_Allow_Backorders and Functions Get_Allow_Backorders and Get_Org_Allow_Backorders.
--  050415          Modified the procedure Transfer_Order_Changes___ to handle Allow_Backorders.
--  040511  JaJalk  Corrected the lead time lables.
--  040506  DaRulk  Renamed view comments of 'Delivery Date' to 'Wanted Delivery Date'
--  040220  IsWilk  Removed the SUBSTRB for Unicode Changes.
--  --------------- 13.3.0------------------------
--  031104  Asawlk  Modifed procedure Transfer_Order_Changes___, delivery_terms, delivery_terms_desc, ship_via_code, ship_via_desc and route_id are
--                  added to attribute string only if they are not null.
--  031029  ChBalk  Bug fixed 109020, in Transfer_Order_Line_Changes___ changed the order of execution of single_occurance processing.
--  031028  SeKalk  Modified procedure Transfer_Order_Changes___
--  030910  SeKalk  Removed allow_backorders and all logic concerning it.
--  031006  SeKalk  changed the value of internal_delivery_type
--  030805  AjShlk  Synchronized with the CAT file - SP4 Merge
--  030804  GaJalk  Performed SP4 Merge.
--  030217  NuFilk  Bug 34820, Added association to customer_allow_backorders.
--  020619  ErFise  Bug 30257, Added new attributes delivery_leadtime and
--                  org_delivery_leadtime to view and methods.
--  020705  PioZpl  Bug 29015, changes in Get_Changed_Attributes__ so ship_via_code and delivery_terms
--                  are only validated when its an internal transit or internal direct order.
--  020322 SaKaLk   Call 77116(Foreign Call 28170). Added ship_county to calling method parameter list of
--                  'CUSTOMER_ORDER_ADDRESS_API.New' and 'CUSTOMER_ORDER_ADDRESS_API.Modify'.
--  020318  SaKaLk  Call 77116(Foreign Call 28170).Added Column org_ship_county.
--  020312  SaKaLk  Call 77116(Foreign Call 28170).Added Column ship_county.
--  011217  DaZa    Bug fix 24525, Added DELIVERY_TERMS and SHIP_VIA_CODE to method Transfer_Order_Changes___.
--  011203  DaZa    Bug fix 24525, Added new fields delivery_terms_desc, ship_via_desc and route_id
--                  to view and methods. Added EAN_LOCATION_DEL_ADDR to method Get_Changed_Attributes__.
--  010619  JSAnse  Bug fix 21463, Added call to General_SYS.Init_Method in Is_Quotation.
--  001128  JoEd    Added SALESMAN_CODE to Transfer_Order_Changes___ and Transfer_Quotation_Changes___.
--  000920  MaGu    Renamed address columns. Changed to new address format in Transfer_Order_Changes___ and
--                  Get_Changed_Attributes__. Also modified Insert___, Finite_State_Init
--                  and Finite_State_Machine___ according to new template.
--  000905  JoEd    Added exist check on import_mode.
--  000524  JakH    Added is_quotation and Transfer_Quotation_Changes___
--  --------------  ------------- 12.10 ---------------------------------------
--  991026  JoAn    CID 24078 Cancel configured order. Added check for objstate
--                  before calling Customer_Order_API.Set_Cancelled in Do_Approve__
--  991007  JoEd    Call Id 21210: Corrected double-byte problems.
--  990826  JoEd    Changed check on single occurence address in
--                  Transfer_Order_Changes___.
--  --------------  ---------------- 11.1 -------------------------------------
--  990507  RaKu    Y.More corrections.
--  990423  RaKu    Y.Corrections.
--  990416  JakH    Removed use of  Get_Id_Version_By_Keys___
--  990217  RaKu    Removed mandatory field-checks on several columns.
--  990202  JICE    Added language.
--  990125  JICE    Added columns for configured orders.
--  981113  RaKu    Corrected compilation bug.
--  980930  RaKu    Added functions Get_Changed_Attributes__ and
--                  3 x Add_To_Attr_On_Differance___.
--  980912  RaKu    Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Transfer_Order_Changes___
--   Update the Customer Order with the changes received.
PROCEDURE Transfer_Order_Changes___ (
   message_id_ IN NUMBER )
IS
   info_                VARCHAR2(2000);
   attr_                VARCHAR2(32000);
   rec_                 EXT_CUST_ORDER_CHANGE_TAB%ROWTYPE;
   newrec_              EXT_CUST_ORDER_CHANGE_TAB%ROWTYPE;
   objid_               VARCHAR2(2000);
   objversion_          VARCHAR2(2000);
   old_addr_flag_       VARCHAR2(200);
   single_occurance_    BOOLEAN := FALSE;
   ship_addr_no_        customer_order.ship_addr_no%TYPE := NULL;
   company_             VARCHAR2(20);
   vat_free_vat_code_   VARCHAR2(20);
   po_note_id_          NUMBER;
   co_note_id_          NUMBER;
   indrec_              Indicator_Rec;
   customer_po_no_      VARCHAR2(50);
   CURSOR get_msg_lines(message_id_ NUMBER) IS
      SELECT line_no, rel_no 
      FROM ext_cust_order_line_change      
      WHERE message_id = message_id_;

BEGIN

   rec_ := Get_Object_By_Keys___(message_id_);
   Client_SYS.Clear_Attr(attr_);

   IF (rec_.order_no IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'MISSING_ORDER_NO: Customer order not created yet or not found on site :P1', rec_.contract);
   END IF;   
   -- fetch old single occurence flag
   old_addr_flag_ := Customer_Order_API.Get_Addr_Flag(rec_.order_no);

   -- Get attributes from external order header
   Client_SYS.Add_To_Attr('WANTED_DELIVERY_DATE', rec_.delivery_date , attr_);

   IF (rec_.cust_ref IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('CUST_REF', rec_.cust_ref , attr_);
   END IF;

   Client_SYS.Add_To_Attr('LABEL_NOTE', rec_.label_note , attr_);
   IF (rec_.note_text IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('NOTE_TEXT', rec_.note_text , attr_);
   END IF;

   IF (rec_.salesman_code IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('SALESMAN_CODE', rec_.salesman_code, attr_);
   END IF;

   IF (rec_.forward_agent_id IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('FORWARD_AGENT_ID', rec_.forward_agent_id , attr_);
   END IF;

   -- Handle payer and payer address
   IF (rec_.customer_no_pay IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('CUSTOMER_NO_PAY', rec_.customer_no_pay , attr_);
      IF (rec_.ean_location_payer_addr IS NOT NULL) THEN
         -- EAN Location code
         Client_SYS.Add_To_Attr('CUSTOMER_NO_PAY_ADDR_NO', Cust_Ord_Customer_Address_API.Get_Id_By_Ean_Location(
            rec_.customer_no_pay, rec_.ean_location_payer_addr), attr_);
      END IF;
   END IF;

   -- Handle delivery (ship) address
   IF rec_.b2b_process_online = Fnd_Boolean_API.DB_TRUE THEN
      ship_addr_no_ := rec_.ship_addr_no;
   ELSE
      ship_addr_no_ := Cust_Ord_Customer_Address_API.Get_Id_By_Ean_Location(rec_.customer_no, rec_.ean_location_del_addr);
   END IF;
   IF (ship_addr_no_ IS NOT NULL) THEN
      -- EAN Location code
      Client_SYS.Add_To_Attr('SHIP_ADDR_NO', ship_addr_no_, attr_);
      Client_SYS.Add_To_Attr('ADDR_FLAG_DB', 'N', attr_);
   ELSIF (rec_.delivery_address_name IS NOT NULL) OR (rec_.ship_address1 IS NOT NULL) OR
      (rec_.ship_address2 IS NOT NULL) OR (rec_.ship_zip_code IS NOT NULL) OR
      (rec_.ship_address3 IS NOT NULL) OR (rec_.ship_address4 IS NOT NULL) OR
      (rec_.ship_address5 IS NOT NULL) OR (rec_.ship_address6 IS NOT NULL) OR
      (rec_.ship_city IS NOT NULL) OR (rec_.ship_state IS NOT NULL) OR
      (rec_.country_code IS NOT NULL) THEN
      -- Single occurance address
      Client_SYS.Add_To_Attr('ADDR_FLAG_DB', 'Y', attr_);
      single_occurance_ := TRUE;
   END IF;

   -- Handle document (bill) address
   IF rec_.b2b_process_online = Fnd_Boolean_API.DB_TRUE THEN
      Client_SYS.Add_To_Attr('BILL_ADDR_NO', rec_.bill_addr_no, attr_);
   ELSE
      IF (rec_.ean_location_doc_addr IS NOT NULL) THEN
      -- EAN Location code
      Client_SYS.Add_To_Attr('BILL_ADDR_NO', Cust_Ord_Customer_Address_API.Get_Id_By_Ean_Location(
         rec_.customer_no, rec_.ean_location_doc_addr), attr_);
      END IF;
   END IF;

   IF (rec_.delivery_terms IS NOT NULL)  THEN
      Client_SYS.Add_To_Attr('DELIVERY_TERMS', rec_.delivery_terms, attr_);
   END IF;

   IF (rec_.del_terms_location IS NOT NULL)  THEN
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
   
   IF (rec_.backorder_option IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('BACKORDER_OPTION_DB', rec_.backorder_option , attr_);
   END IF;
   
   IF (rec_.print_delivered_lines IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('PRINT_DELIVERED_LINES_DB', rec_.print_delivered_lines, attr_);
   END IF;   

   IF (rec_.vat_no IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('VAT_NO', rec_.vat_no , attr_);
   END IF;

   IF (rec_.tax_id_validated_date IS NOT NULL AND rec_.vat_no IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('TAX_ID_VALIDATED_DATE', rec_.tax_id_validated_date , attr_);
   END IF;

   IF (rec_.customer_po_no IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('CUSTOMER_PO_NO', rec_.customer_po_no, attr_);
   ELSE
      $IF Component_Purch_SYS.INSTALLED $THEN
         IF(Customer_Order_API.Get_Customer_Po_No(rec_.order_no) IS NOT NULL) THEN
            FOR line_rec_ IN get_msg_lines(rec_.message_id) LOOP
               IF ((Purchase_Order_Line_Part_API.Get_State(rec_.internal_po_no, line_rec_.line_no, line_rec_.rel_no) != 'Cancelled') AND
                       (Purchase_Order_Line_Part_API.Get_Demand_Code_Db(rec_.internal_po_no, line_rec_.line_no, line_rec_.rel_no) = 'ICD'))THEN
                  customer_po_no_ := NULL;
                  Client_SYS.Add_To_Attr('CUSTOMER_PO_NO', customer_po_no_, attr_); 
                  EXIT;
               END IF;   
            END LOOP; 
         END IF;         
      $ELSE
         NULL;
      $END
   END IF;
   IF (rec_.internal_ref IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('INTERNAL_REF', rec_.internal_ref, attr_);
   END IF;
   IF (rec_.internal_po_label_note IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('INTERNAL_PO_LABEL_NOTE', rec_.internal_po_label_note, attr_);
   END IF;

   IF (rec_.delivery_date IS NOT NULL) THEN
      IF ( rec_.delivery_date != rec_.org_delivery_date) THEN
         IF (Site_Discom_Info_API.Get_Price_Effective_Date_Db(rec_.contract) = 'TRUE') THEN
            Client_SYS.Add_To_Attr('UPDATE_PRICE_EFFECTIVE_DATE', 'TRUE', attr_);
         END IF;
      END IF;
   END IF;

   Client_SYS.Add_To_Attr('REPLICATE_CHANGES', 'TRUE', attr_);
   Client_SYS.Add_To_Attr('CHANGE_REQUEST', 'TRUE', attr_);
   IF rec_.b2b_process_online = Fnd_Boolean_API.DB_TRUE THEN
      Client_SYS.Add_To_Attr('B2B_PROCESS_ONLINE', 'TRUE', attr_);
   END IF;
   
   -- change the order header values
   Customer_Order_API.Modify(info_, attr_, rec_.order_no);

   IF (rec_.error_message IS NOT NULL) THEN
      -- Clear Error_Message.
      rec_ := Lock_By_Keys___(rec_.message_id);
      newrec_ := rec_;
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('ERROR_MESSAGE', '', attr_);
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(rec_, newrec_, indrec_, attr_);
      Update___(objid_, rec_, newrec_, attr_, objversion_, TRUE);
   END IF;

   -- check if order had a single occurence address before this change
   IF (old_addr_flag_ = Gen_Yes_No_API.Decode('Y')) THEN
      -- Old single occurance address exist.
      IF single_occurance_ THEN
         Customer_Order_Address_API.Modify(rec_.order_no, rec_.delivery_address_name, rec_.ship_address1,
            rec_.ship_address2, rec_.ship_address3, rec_.ship_address4, rec_.ship_address5, rec_.ship_address6,
            rec_.ship_zip_code, rec_.ship_city, rec_.ship_state,rec_.ship_county, rec_.country_code, NULL);
      ELSE
         Trace_SYS.Message('Remove single occurance address');
         Customer_Order_Address_API.Remove(rec_.order_no);
      END IF;
   ELSIF single_occurance_ THEN
      ship_addr_no_      := NVL(Customer_order_API.Get_Ship_Addr_No(rec_.order_no), Cust_Ord_Customer_API.Get_Delivery_Address(rec_.customer_no));
      company_           := Site_API.Get_Company(rec_.contract);
      vat_free_vat_code_ := Customer_Tax_Free_Tax_Code_API.Get_Tax_Free_Tax_Code(rec_.customer_no, ship_addr_no_, company_, Company_SIte_API.Get_Country_Db(rec_.contract), '*');

      Customer_Order_Address_API.New(rec_.order_no, 
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
                                     NULL, 
                                     vat_free_vat_code_);
   END IF;

   IF (NVL(rec_.same_database, Fnd_Boolean_API.DB_FALSE) = Fnd_Boolean_API.DB_TRUE) THEN
      -- Fetch and copy PO notes to the CO
      $IF Component_Purch_SYS.INSTALLED $THEN
         po_note_id_  := Purchase_Order_API.Get_Note_Id(rec_.internal_po_no);
      $END
      IF (po_note_id_ IS NOT NULL) THEN
         co_note_id_ := Customer_Order_API.Get_Note_Id(rec_.order_no);
         -- Delete all notes in the CO
         Document_Text_API.Replace_Note_Text(po_note_id_, co_note_id_);
      END IF;
   END IF;
END Transfer_Order_Changes___;


-- Transfer_Quotation_Changes___
--   Update the Order Quotation with the changes received.
PROCEDURE Transfer_Quotation_Changes___ (
   message_id_ IN NUMBER )
IS
   info_             VARCHAR2(2000);
   attr_             VARCHAR2(32000);
   rec_              EXT_CUST_ORDER_CHANGE_TAB%ROWTYPE;
   newrec_           EXT_CUST_ORDER_CHANGE_TAB%ROWTYPE;
   objid_            VARCHAR2(2000);
   objversion_       VARCHAR2(2000);
   indrec_           Indicator_Rec;
BEGIN

   rec_ := Get_Object_By_Keys___(message_id_);
   Client_SYS.Clear_Attr(attr_);


   -- Get attributes from external order header
   Client_SYS.Add_To_Attr('WANTED_DELIVERY_DATE', rec_.delivery_date , attr_);

   IF (rec_.cust_ref IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('CUST_REF', rec_.cust_ref , attr_);
   END IF;

   Client_SYS.Add_To_Attr('LABEL_NOTE', rec_.label_note , attr_);
   Client_SYS.Add_To_Attr('NOTE_TEXT', rec_.note_text , attr_);
   Client_SYS.Add_To_Attr('SALESMAN_CODE', rec_.salesman_code, attr_);

   IF (rec_.ean_location_del_addr IS NOT NULL) THEN
      -- EAN Location code
      Client_SYS.Add_To_Attr('SHIP_ADDR_NO', Cust_Ord_Customer_Address_API.Get_Id_By_Ean_Location(
         rec_.customer_no, rec_.ean_location_del_addr), attr_);
   END IF;

   -- Handle document (bill) address
   IF (rec_.ean_location_doc_addr IS NOT NULL) THEN
      -- EAN Location code
      Client_SYS.Add_To_Attr('BILL_ADDR_NO', Cust_Ord_Customer_Address_API.Get_Id_By_Ean_Location(
         rec_.customer_no, rec_.ean_location_doc_addr), attr_);
   END IF;

   -- change the order header values
   Order_Quotation_API.Modify(info_, attr_, rec_.order_no);

   IF (rec_.error_message IS NOT NULL) THEN
      -- Clear Error_Message.
      rec_ := Lock_By_Keys___(rec_.message_id);
      newrec_ := rec_;
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('ERROR_MESSAGE', '', attr_);
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(rec_, newrec_, indrec_, attr_);
      Update___(objid_, rec_, newrec_, attr_, objversion_, TRUE);
   END IF;
END Transfer_Quotation_Changes___;


-- Add_To_Attr_On_Differance___
--   Adds a message to the attribute string only if the two parameters
--   (OrgValue and NewValue) do not match. String parameters only.
--   Adds a message to the attribute string only if the two parameters
--   (OrgValue and NewValue) do not match. Number parameters only.
--   Adds a message to the attribute string only if the two parameters
--   (OrgValue and NewValue) do not match. Date parameters only.
PROCEDURE Add_To_Attr_On_Differance___ (
   item_      IN     VARCHAR2,
   new_value_ IN     VARCHAR2,
   org_value_ IN     VARCHAR2,
   attr_      IN OUT VARCHAR2 )
IS
   diff_ BOOLEAN;
BEGIN
   IF new_value_ IS NULL THEN
      diff_ := (org_value_ IS NOT NULL);
   ELSE
      diff_ := (org_value_ IS NULL) OR (new_value_ != org_value_);
   END IF;
   IF (diff_) THEN
      attr_ := attr_ || item_      || Client_SYS.field_separator_;
      attr_ := attr_ || org_value_ || Client_SYS.field_separator_;
      attr_ := attr_ || new_value_ || Client_SYS.record_separator_;
   END IF;
END Add_To_Attr_On_Differance___;


-- Add_To_Attr_On_Differance___
--   Adds a message to the attribute string only if the two parameters
--   (OrgValue and NewValue) do not match. String parameters only.
--   Adds a message to the attribute string only if the two parameters
--   (OrgValue and NewValue) do not match. Number parameters only.
--   Adds a message to the attribute string only if the two parameters
--   (OrgValue and NewValue) do not match. Date parameters only.
PROCEDURE Add_To_Attr_On_Differance___ (
   item_      IN     VARCHAR2,
   new_value_ IN     NUMBER,
   org_value_ IN     NUMBER,
   attr_      IN OUT VARCHAR2 )
IS
   diff_ BOOLEAN;
BEGIN
   IF new_value_ IS NULL THEN
      diff_ := (org_value_ IS NOT NULL);
   ELSE
      diff_ := (org_value_ IS NULL) OR (new_value_ != org_value_);
   END IF;
   IF (diff_) THEN
      attr_ := attr_ || item_               || Client_SYS.field_separator_;
      attr_ := attr_ || TO_CHAR(org_value_) || Client_SYS.field_separator_;
      attr_ := attr_ || TO_CHAR(new_value_) || Client_SYS.record_separator_;
   END IF;
END Add_To_Attr_On_Differance___;


-- Add_To_Attr_On_Differance___
--   Adds a message to the attribute string only if the two parameters
--   (OrgValue and NewValue) do not match. String parameters only.
--   Adds a message to the attribute string only if the two parameters
--   (OrgValue and NewValue) do not match. Number parameters only.
--   Adds a message to the attribute string only if the two parameters
--   (OrgValue and NewValue) do not match. Date parameters only.
PROCEDURE Add_To_Attr_On_Differance___ (
   item_      IN     VARCHAR2,
   new_value_ IN     DATE,
   org_value_ IN     DATE,
   attr_      IN OUT VARCHAR2 )
IS
   diff_ BOOLEAN;
BEGIN
   IF new_value_ IS NULL THEN
      diff_ := (org_value_ IS NOT NULL);
   ELSE
      diff_ := (org_value_ IS NULL) OR (new_value_ != org_value_);
   END IF;
   IF (diff_) THEN
      attr_ := attr_ || item_ || Client_SYS.field_separator_;
      attr_ := attr_ || TO_CHAR(org_value_, 'YYYY-MM-DD') || Client_SYS.field_separator_;
      attr_ := attr_ || TO_CHAR(new_value_, 'YYYY-MM-DD') || Client_SYS.record_separator_;
   END IF;
END Add_To_Attr_On_Differance___;


PROCEDURE Do_Cancel___ (
   rec_  IN OUT EXT_CUST_ORDER_CHANGE_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   CURSOR cancel_all_lines IS
      SELECT message_line
      FROM   EXT_CUST_ORDER_LINE_CHANGE_TAB
      WHERE  message_id = rec_.message_id
      AND    rowstate IN ('Changed', 'RequiresApproval', 'Stopped');
BEGIN
   FOR next_ IN cancel_all_lines LOOP
      Ext_Cust_Order_Line_Change_API.Set_Line_Cancel(rec_.message_id, next_.message_line);
   END LOOP;
END Do_Cancel___;


PROCEDURE Do_Change_Error___ (
   rec_  IN OUT EXT_CUST_ORDER_CHANGE_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   oldrec_     EXT_CUST_ORDER_CHANGE_TAB%ROWTYPE;
   newrec_     EXT_CUST_ORDER_CHANGE_TAB%ROWTYPE;
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
END Do_Change_Error___;


PROCEDURE Do_Approve___ (
   rec_  IN OUT EXT_CUST_ORDER_CHANGE_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   info_            VARCHAR2(2000);
   message_line_    NUMBER := NULL;
   newrec_          EXT_CUST_ORDER_CHANGE_TAB%ROWTYPE;
   objid_           VARCHAR2(2000);
   objversion_      VARCHAR2(2000);
   error_message_   VARCHAR2(2000);
   quotation_       BOOLEAN;
   head_attr_       VARCHAR2(32000);
   amended_line_fetched_ BOOLEAN := FALSE;
   previous_po_order_no_ customer_order_pur_order_tab.po_order_no%TYPE;
   process_online_       BOOLEAN := FALSE;
   
   CURSOR approve_all_lines IS
      SELECT ecol.message_line, ecol.ord_chg_state, copo.po_order_no
      FROM   ext_cust_order_line_change_tab ecol, customer_order_pur_order_tab copo
      WHERE  ecol.message_id = rec_.message_id
      AND    copo.oe_order_no(+) = rec_.order_no 
      AND    copo.oe_line_no(+) = ecol.line_no 
      AND    copo.oe_rel_no(+) = ecol.rel_no 
      AND    copo.oe_line_item_no(+) = 0
      AND    ecol.rowstate IN ('RequiresApproval', 'Changed', 'Stopped')
      ORDER BY ecol.message_line, copo.po_order_no;

BEGIN
   IF (Site_Discom_Info_API.Get_Exec_Ord_Change_Online_Db(rec_.contract) = 'TRUE') THEN
      process_online_ := TRUE;
   END IF;
   
   IF (NOT process_online_) THEN
      @ApproveTransactionStatement(2013-12-14,wawilk)
      SAVEPOINT approve;
   END IF;
   
   Trace_SYS.Field('IMPORT_MODE', rec_.import_mode);
   quotation_ := (rec_.import_mode IN ('QUOTATION', 'CANCELQUOTATION'));

   IF quotation_ THEN
      -- Change order quotation head
      Transfer_Quotation_Changes___(rec_.message_id);
   ELSE
      -- Change customer order head
      head_attr_:= Get_Changed_Attributes__ (rec_.message_id);
      IF (head_attr_ IS NOT NULL) THEN
         Transfer_Order_Changes___(rec_.message_id);
      END IF;
   END IF;

   -- In the multiple inter-site ( more than 2 sites) scenario,an amended( i.e. added, changed or deleted) line should be sent 
   -- with change request flag TRUE, for the second internal PO to send change request automatically.
   -- So, in the following loop, it is made sure an added, changed or deleted line (if there's any) is approved as the last line. 
   FOR next_ IN approve_all_lines LOOP
      -- Added IF condition to avoid approving the same message line twice if mannually pegged into more than one purchase orders.
      IF ((NVL(message_line_, 0) != next_.message_line)) THEN
         IF next_.po_order_no != previous_po_order_no_ THEN
            IF amended_line_fetched_ THEN
               IF message_line_ IS NOT NULL THEN
                  -- A new internal PO. Send the line kept in message_line_ variable with change request flag TRUE.
                  -- This can be previously kept not amended line or that of previous iteration if none amended for this internal PO.
                  Ext_Cust_Order_Line_Change_API.Set_Line_Approve(rec_.message_id, message_line_, 'TRUE');
                  message_line_ := NULL;
               END IF;
            END IF;
            amended_line_fetched_ := FALSE;
         END IF;
         IF amended_line_fetched_ THEN
            -- A line added, changed or deleted is already found and assigned to message_line_ to be used outside the loop.
            -- So approve current line with last_line_ parameter FALSE
            Ext_Cust_Order_Line_Change_API.Set_Line_Approve(rec_.message_id, next_.message_line, 'FALSE');
         ELSE
            -- This loop will not approve a line in the first iteration. message_line_ is null for the first iteration only.
            -- First of all, call the approve method with last_line_ parameter FALSE for message_line of the previous iteration (if this is not the first)
            IF message_line_ IS NOT NULL THEN
               Ext_Cust_Order_Line_Change_API.Set_Line_Approve(rec_.message_id, message_line_, 'FALSE');
            END IF;
            -- Keep this message_line to be processed later in next iteration or outside the loop
            message_line_ := next_.message_line;

            IF next_.ord_chg_state != 'NOT AMENDED' THEN
               -- This is an added, changed or deleted line. message_line_ will not be asigned with new value in the loop again and this is kept to be approved outside the loop. 
               amended_line_fetched_ := TRUE;
            END IF;

         END IF;
         previous_po_order_no_ := next_.po_order_no;
      END IF;
   END LOOP;
   -- Approve first found added, changed or deleted line in the loop (or the last line if all the lines are 'NOT AMENDED')
   IF message_line_ IS NOT NULL THEN
      Ext_Cust_Order_Line_Change_API.Set_Line_Approve(rec_.message_id, message_line_, 'TRUE');
   END IF;   
   message_line_ := NULL;

----- How do we destinguish between orders and quotations when cancelling????

   IF (NVL(rec_.import_mode, 'ORDER') = 'CANCELLATION' OR 
       (Customer_Order_API.All_Lines_Cancelled(rec_.order_no) = 'TRUE' AND Customer_Order_API.Get_Scheduling_Connection_Db(rec_.order_no) = 'NOT SCHEDULE')) THEN
      -- The order might already have been cancelled if all order lines were cancelled
      -- when processing the message lines.
      IF (Customer_Order_API.Get_Objstate(rec_.order_no) != 'Cancelled') THEN
         Customer_Order_API.Set_Cancelled(rec_.order_no);
      END IF;
   END IF;

   -- Everything OK. Change status to 'Created'. Commit is handled by the client
   Client_SYS.Clear_Attr(attr_);
   newrec_ := Get_Object_By_Keys___(rec_.message_id);
   Get_Id_Version_By_Keys___(objid_, objversion_, rec_.message_id);
   Order_Changed__(info_, objid_, objversion_, attr_, 'DO');

   Client_SYS.Add_To_Attr('ORDER_NO', newrec_.order_no, attr_);
   Client_SYS.Add_To_Attr('CONTRACT', newrec_.contract, attr_);
   Client_SYS.Add_To_Attr('ERROR_MESSAGE', newrec_.error_message, attr_);

   rec_ := Get_Object_By_Keys___(rec_.message_id);
   
EXCEPTION
   WHEN others THEN
      IF (process_online_) THEN  
         RAISE;
      ELSE
         error_message_ := sqlerrm;
         @ApproveTransactionStatement(2013-12-14,wawilk)
         ROLLBACK to approve;
         -- An error was trapped. Rollback entire transaction and write error_message.
         IF (message_line_ IS NULL) THEN
            -- The error was caused when creating order header
            Trace_SYS.Message('Error in header');
            Client_SYS.Clear_Attr(attr_);
            Client_SYS.Add_To_Attr('ERROR_MESSAGE', error_message_, attr_);
            Get_Id_Version_By_Keys___(objid_, objversion_, rec_.message_id);
            Order_Change_Error__(info_, objid_, objversion_, attr_, 'DO');
            rec_ := Get_Object_By_Keys___(rec_.message_id);
         ELSE
            -- The error was caused when creating order line
            Trace_SYS.Message('Error in order line');
            Ext_Cust_Order_Line_Change_API.Set_Line_Error(rec_.message_id, message_line_, error_message_);
            newrec_ := Get_Object_By_Keys___(rec_.message_id);
            rec_:= newrec_;
            Client_SYS.Add_To_Attr('ERROR_MESSAGE', newrec_.error_message, attr_);
         END IF;
      END IF;
END Do_Approve___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     EXT_CUST_ORDER_CHANGE_TAB%ROWTYPE,
   newrec_     IN OUT EXT_CUST_ORDER_CHANGE_TAB%ROWTYPE,
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
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT ext_cust_order_change_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   IF indrec_.internal_delivery_type THEN
      newrec_.internal_delivery_type := 'INTER-SITE';
   END IF;      
   IF (newrec_.import_mode IS NOT NULL) THEN
      Order_Config_Import_Mode_API.Exist_Db(newrec_.import_mode);
   END IF;
   IF (newrec_.b2b_process_online IS NULL) THEN
      newrec_.b2b_process_online := Fnd_Boolean_API.DB_FALSE;
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
   IF (newrec_.org_delivery_terms IS NOT NULL AND newrec_.org_delivery_terms_desc IS NULL) THEN
      newrec_.org_delivery_terms_desc := Order_Delivery_Term_API.Get_Description(newrec_.org_delivery_terms);
   END IF;
   IF (newrec_.org_ship_via_code IS NOT NULL AND newrec_.org_ship_via_desc IS NULL) THEN
      newrec_.org_ship_via_desc := Mpccom_Ship_Via_API.Get_Description(newrec_.org_ship_via_code);
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
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     ext_cust_order_change_tab%ROWTYPE,
   newrec_ IN OUT ext_cust_order_change_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   -- Clear the error_message.
   IF NOT indrec_.error_message THEN
      newrec_.error_message := NULL;
   END IF;
   IF indrec_.internal_delivery_type THEN
      newrec_.internal_delivery_type := 'INTER-SITE';
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

   -- Add import mode back to client
   Client_SYS.Add_To_Attr('IMPORT_MODE', newrec_.import_mode, attr_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Get_Changed_Attributes__
--   Return a string containing all the changed attributes with the new and old values.
@UncheckedAccess
FUNCTION Get_Changed_Attributes__ (
   message_id_ IN NUMBER ) RETURN VARCHAR2
IS
   attr_         VARCHAR2(32000) := NULL;
   rec_          EXT_CUST_ORDER_CHANGE_TAB%ROWTYPE;
   is_addr_flag_ BOOLEAN;
BEGIN
   rec_ := Get_Object_By_Keys___(message_id_);
   is_addr_flag_ := (Gen_Yes_No_API.Encode(Customer_Order_API.Get_Addr_Flag(rec_.order_no)) = 'N');
   -- Compare Header
   Add_To_Attr_On_Differance___('FORWARD_AGENT_ID',            rec_.forward_agent_id,        rec_.org_forward_agent_id,        attr_);
   Add_To_Attr_On_Differance___('CUST_REF',                    rec_.cust_ref,                rec_.org_cust_ref,                attr_);
   Add_To_Attr_On_Differance___('CUSTOMER_NO_PAY',             rec_.customer_no_pay,         rec_.org_customer_no_pay,         attr_);
   Add_To_Attr_On_Differance___('NOTE_TEXT',                   rec_.note_text,               rec_.org_note_text,               attr_);
   Add_To_Attr_On_Differance___('LABEL_NOTE',                  rec_.label_note,              rec_.org_label_note,              attr_);
   IF rec_.b2b_process_online = Fnd_Boolean_API.DB_TRUE THEN
      Add_To_Attr_On_Differance___('BILL_ADDR_NO',                rec_.bill_addr_no, rec_.org_bill_addr_no, attr_);
   ELSE
      Add_To_Attr_On_Differance___('EAN_LOCATION_DOC_ADDR',       rec_.ean_location_doc_addr,   rec_.org_ean_location_doc_addr,   attr_);
      Add_To_Attr_On_Differance___('EAN_LOCATION_PAYER_ADDR',     rec_.ean_location_payer_addr, rec_.org_ean_location_payer_addr, attr_);
   END IF;
   Add_To_Attr_On_Differance___('DELIVERY_DATE',               rec_.delivery_date,           rec_.org_delivery_date,           attr_);
   IF (is_addr_flag_) THEN
      IF rec_.b2b_process_online = Fnd_Boolean_API.DB_TRUE THEN
         Add_To_Attr_On_Differance___('SHIP_ADDR_NO',             rec_.ship_addr_no, rec_.org_ship_addr_no, attr_);
      ELSE
         Add_To_Attr_On_Differance___('EAN_LOCATION_DEL_ADDR',    rec_.ean_location_del_addr,   rec_.org_ean_location_del_addr,   attr_);
      END IF;
   END IF;

   IF (rec_.internal_delivery_type = 'INTDIRECT' OR rec_.internal_delivery_type = 'INTTRANSIT' OR rec_.internal_delivery_type = 'INTER-SITE') THEN
      Add_To_Attr_On_Differance___('DELIVERY_TERMS',           rec_.delivery_terms,          rec_.org_delivery_terms,        attr_);
      Add_To_Attr_On_Differance___('DELIVERY_TERMS_DESC',      rec_.delivery_terms_desc,     rec_.org_delivery_terms_desc,   attr_);
      Add_To_Attr_On_Differance___('DEL_TERMS_LOCATION',       rec_.del_terms_location,      rec_.org_del_terms_location,    attr_);
      Add_To_Attr_On_Differance___('SHIP_VIA_CODE',            rec_.ship_via_code,           rec_.org_ship_via_code,         attr_);
      Add_To_Attr_On_Differance___('SHIP_VIA_DESC',            rec_.ship_via_desc,           rec_.org_ship_via_desc,         attr_);
      Add_To_Attr_On_Differance___('DELIVERY_LEADTIME',        rec_.delivery_leadtime,       rec_.org_delivery_leadtime,     attr_);
      IF (rec_.backorder_option IS NOT NULL) THEN
         Add_To_Attr_On_Differance___('BACKORDER_OPTION', Customer_Backorder_Option_API.Decode(rec_.backorder_option), Customer_Backorder_Option_API.Decode(rec_.org_backorder_option), attr_);
      END IF;
      Add_To_Attr_On_Differance___('ROUTE_ID',                 rec_.route_id,                rec_.org_route_id,               attr_);

   END IF;
   
   IF NOT (is_addr_flag_) THEN
   -- Compare Address
      Add_To_Attr_On_Differance___('DELIVERY_ADDRESS_NAME',    rec_.delivery_address_name,   rec_.org_delivery_address_name,  attr_);
      Add_To_Attr_On_Differance___('SHIP_ADDRESS1',            rec_.ship_address1,           rec_.org_ship_address1,          attr_);
      Add_To_Attr_On_Differance___('SHIP_ADDRESS2',            rec_.ship_address2,           rec_.org_ship_address2,          attr_);
      Add_To_Attr_On_Differance___('SHIP_ADDRESS3',            rec_.ship_address3,           rec_.org_ship_address3,          attr_);
      Add_To_Attr_On_Differance___('SHIP_ADDRESS4',            rec_.ship_address4,           rec_.org_ship_address4,          attr_);
      Add_To_Attr_On_Differance___('SHIP_ADDRESS5',            rec_.ship_address5,           rec_.org_ship_address5,          attr_);
      Add_To_Attr_On_Differance___('SHIP_ADDRESS6',            rec_.ship_address6,           rec_.org_ship_address6,          attr_);
      Add_To_Attr_On_Differance___('SHIP_ZIP_CODE',            rec_.ship_zip_code,           rec_.org_ship_zip_code,          attr_);
      Add_To_Attr_On_Differance___('SHIP_CITY',                rec_.ship_city,               rec_.org_ship_city,              attr_);
      Add_To_Attr_On_Differance___('SHIP_STATE',               rec_.ship_state,              rec_.org_ship_state,             attr_);
      Add_To_Attr_On_Differance___('COUNTRY_CODE',             rec_.country_code,            rec_.org_country_code,           attr_);
      Add_To_Attr_On_Differance___('VAT_NO',                   rec_.vat_no,                  rec_.org_vat_no,                 attr_);
   END IF;
   IF (rec_.pay_term_id IS NOT NULL) THEN
      Add_To_Attr_On_Differance___('PAY_TERM_ID',              rec_.pay_term_id,             rec_.org_pay_term_id,            attr_);
   END IF;
   IF (rec_.salesman_code IS NOT NULL) THEN
      Add_To_Attr_On_Differance___('SALESMAN_CODE',            rec_.salesman_code,           rec_.org_salesman_code,          attr_);
   END IF;
   Add_To_Attr_On_Differance___('INTERNAL_REF',                rec_.internal_ref,            rec_.org_internal_ref,           attr_);
   Add_To_Attr_On_Differance___('CUSTOMER_PO_NO',              rec_.customer_po_no,          rec_.org_customer_po_no,         attr_);   
   Add_To_Attr_On_Differance___('INTERNAL_PO_LABEL_NOTE',      rec_.internal_po_label_note,  rec_.org_internal_po_label_note, attr_);
   IF (rec_.print_delivered_lines IS NOT NULL) THEN
      Add_To_Attr_On_Differance___('PRINT_DELIVERED_LINES_DB', rec_.print_delivered_lines,   rec_.org_print_delivered_lines,  attr_);
   END IF;
   RETURN attr_;
END Get_Changed_Attributes__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- New
--   Creates a new record with specified attributes
PROCEDURE New (
   attr_ IN VARCHAR2 )
IS
   newrec_     EXT_CUST_ORDER_CHANGE_TAB%ROWTYPE;
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
--   Approve changes to order and order lines. If any error occurs, the
--   error message is stored and no changes will be made to the Customer Order.
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
   message_id_ IN NUMBER,
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
   Order_Change_Error__(info_, objid_, objversion_, attr_, 'DO');
END Set_Head_Error;


-- Is_Quotation
--   Returns TRUE if this external object is really a Quotation.
FUNCTION Is_Quotation (
   message_id_ IN NUMBER ) RETURN BOOLEAN
IS
   rec_ EXT_CUST_ORDER_CHANGE_TAB%ROWTYPE;
BEGIN
   rec_ := Get_Object_By_Keys___(message_id_);
   RETURN (NVL(rec_.import_mode, 'ORDER') = 'QUOTATION');
END Is_Quotation;


-- Modify_Change_Request
--   This method is used to update a change request if it exists at the time
--   of creating the internal CO. Called from CustomerOrderTransfer.
PROCEDURE Modify_Change_Request (
   attr_       IN OUT VARCHAR2,
   message_id_ IN     NUMBER )
IS
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   oldrec_     EXT_CUST_ORDER_CHANGE_TAB%ROWTYPE;
   newrec_     EXT_CUST_ORDER_CHANGE_TAB%ROWTYPE;
   indrec_     Indicator_Rec;
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, message_id_);
   oldrec_ := Lock_By_Id___(objid_, objversion_);
   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_);
END Modify_Change_Request;


PROCEDURE Update_Tax_Id_Validated_Date (
   message_id_ IN NUMBER )
IS   
   attr_       VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   oldrec_     EXT_CUST_ORDER_CHANGE_TAB%ROWTYPE;
   newrec_     EXT_CUST_ORDER_CHANGE_TAB%ROWTYPE;
   indrec_     Indicator_Rec;
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, message_id_);
   oldrec_ := Lock_By_Id___(objid_, objversion_);
   newrec_ := oldrec_;   
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('TAX_ID_VALIDATED_DATE', CURRENT_DATE, attr_);
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_);
END Update_Tax_Id_Validated_Date;

@UncheckedAccess
FUNCTION Get_Tax_Id_Type (
   message_id_    IN NUMBER) RETURN VARCHAR2
IS
   tax_id_type_      VARCHAR2(10);
   customer_no_      VARCHAR2(20);
   company_          VARCHAR2(20);   
   bill_addr_no_     VARCHAR2(50);
   supply_country_   VARCHAR2(2);
   delivery_country_ VARCHAR2(2);
   rec_              EXT_CUST_ORDER_CHANGE_TAB%ROWTYPE;
   header_rec_       Customer_Order_API.Public_Rec; 
BEGIN    
   rec_ := Get_Object_By_Keys___(message_id_);
   
   customer_no_      := rec_.customer_no;  
   bill_addr_no_     := rec_.bill_addr_no;
   company_          := Site_API.Get_Company(rec_.contract);  
   supply_country_   := Company_Site_API.Get_Country_Db(rec_.contract);
   delivery_country_ := rec_.country_code;
      
   IF (rec_.ean_location_doc_addr IS NOT NULL) THEN
      -- EAN Location code
      bill_addr_no_ := Cust_Ord_Customer_Address_API.Get_Id_By_Ean_Location(rec_.customer_no, rec_.ean_location_doc_addr);
   END IF;
   IF (rec_.order_no IS NOT NULL) THEN
      header_rec_       := Customer_Order_API.Get(rec_.order_no);
      IF customer_no_ IS NULL THEN
         customer_no_ := header_rec_.customer_no;
      END IF;
      IF bill_addr_no_ IS NULL THEN
         bill_addr_no_ := header_rec_.bill_addr_no;
      END IF;      
      IF supply_country_ IS NULL THEN
         supply_country_ := header_rec_.supply_country;
      END IF;      
      IF delivery_country_ IS NULL THEN
         delivery_country_ := Customer_Order_Address_API.Get_Country_Code(rec_.order_no);
      END IF;      
   END IF;
   tax_id_type_   := Tax_Handling_Order_Util_API.Fetch_And_Validate_Tax_Id(customer_no_, bill_addr_no_, company_, supply_country_, delivery_country_);
   
   RETURN tax_id_type_;
END Get_Tax_Id_Type;

