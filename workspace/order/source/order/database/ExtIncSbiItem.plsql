-----------------------------------------------------------------------------
--
--  Logical unit: ExtIncSbiItem
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  150820  HimRlk  Bug 122790, Moved self-billing quantity validation to Start_Auto_Matching_Process___().
--  150819  PrYaLK  Bug 121587, Modified method Create_Self_Billing_Item___() by adding cust_part_invert_conv_fact in calculating customer_qty.
--  150716  HimRlk  Bug 122790, Modified Validate_Before_Auto_Match___ to fire an error message if self-billing qty is greater than the delivered qty.
--  150716          Override Unpack___ to avoid clearing of error_message after unpacking the attr.
--  130830  HimRlk  Merged Bug 110133-PIV, Modified method Create_Self_Billing_Item___, by changing Calculation logic of line discount amount to be consistent with discount postings.
--  130730  RuLiLk  Bug 110133, Modified method Create_Self_Billing_Item___, by changing Calculation logic of line discount amount to be consistent with discount postings.
--  130218  NipKlk  Bug 108331, Added a new public column price_conv_factor to the table EXT_INC_SBI_ITEM_TAB and updated the code where necessary.
--  111215  MaMalk  Modified Insert___ to move the setting of objversion_ to the end of this procedure.
--  100820  Swralk  SAP-SUCKER DF-77, Modified in function Create_Self_Billing_Item___ to use correct rounding.
--  100520  KRPELK  Merge Rose Method Documentation.
--  100111  Maralk  Modified Finite_State_Machine___ in order to make generated code fully aligned with the existing code.
--  100107  MaRalk  Modified the state machine according to the new developer studio template - 2.5.
--  090930  MaMalk  Removed constant state_separator_. Modified Finite_State_Init___ to remove unused code.
--  ------------------------- 14.0.0 -----------------------------------------
--   090713  MaJalk   Bug 83121, Changed the data type of gtin no to varchar.
--   080516  MaJalk   Added gtin no to view INCOMING_SBI_LINES.
--   080502  MaJalk   Added attribute gtin_no.
--  080402  KiSalk  Added attributes classification_part_no, classification_unit_meas, classification_standard and method Get_Classification_Standard.
--  --------------------------- Nice Price -----------------------------
--  080102  MaMalk  Bug 65955, Replaced cust_part_price with cust_unit_part_price in Create_Self_Billing_Item___ and modified the
--  080102          same method to fetch the correct Sales UoM .
--  060420  RoJalk  Enlarge Customer - Changed variable definitions.
--  ------------------------- 13.4.0 -----------------------------------------
--  070719  NuVelk  Bug 65924, Modified method Create_Self_Billing_Item___ to set the confirmed_sbi_qty_ correctly.
--  050926  NaLrlk  Removed unused variables.
--  050922  IsAnlk  Modofied Start_Auto_Matching_Process___ and Validate_Matching_Record___.
--  050905  JaBalk  Added Unmatch event to Matched state.
--  050901  JaBalk  Removed Get_Manual_Match_Possible__.
--  050901  JaBalk  Changed the content of the messages DELNOTEERR, REFIDEERR, CPOERR.
--  050815  JaBalk  Get the delnote_no from viewrec_ and assign it to linerec_.delnote_no in Create_Self_Billing_Item___.
--  050811  UsRalk  Changed Get_Manual_Match_Possible__ to return true for Stopped lines also.
--  050805  JaBalk  Modified Create_Self_Billing_Item___ to add the COLs discounts to SBI.
--  050804  IsAnlk  Modified matched_gross_amount,matched_tax_amount as gross_amount,tax_amount.
--  050803  IsAnlk  Added error message INVALIDNETAMOUNT in Validate_Mandatory_Fields___.
--  050729  IsAnlk  Changed vat_curr_amount as tax_curr_amount in Create_Self_Billing_Item___.
--  050729  IsAnlk  Modified Create_Self_Billing_Item___ to calculate cust_net_amount correctly.
--  050728  UsRalk  Added new private method Get_Manual_Match_Possible__.
--  050727  UsRalk  Removed fields CUSTOMER_PLANT,CUSTOMER_ORDER_NO,UNLOADING_PLACE,CONTACT_PERSON,DELIVERY_DATE from EXT_INC_SBI_ITEM_TAB.
--  050727  JaBalk  Modified the cursor get_exist_sbi_no to add NVL in Start_Auto_Matching_Process___.
--  050726  IsAnlk  Modified Create_Self_Billing_Item___ to validate catalog_no correctly.
--  050725  JaBalk  Changed the text of error messages.
--  050725  RaKalk  Modified Validate_Mandatory_Fields___ to change the error message 'Atleast two of the net amount, tax amount or gross amount must have values'
--  050725          to 'At least two amounts, out of Net Amount, Tax Amount or Gross Amount must have values'.
--  050725  RaKalk  Renamed Validate_Line___ to Validate_Before_Auto_Match___
--  050725  IsAnlk  Added Validate_Mandatory_Fields___ to validate mandatory columns in Self_billing_item.
--  050722  JaBalk  Done minor GUI changes.
--  050720  UsRalk  Added private method Clear_Line_Error_Messages__.
--  050720  UsRalk  Removed the event CheckBeforeManualMatch.
--  050720  IsAnlk  Modified pur_catalog_no as customer_part_no and pur_catalog_desc as customer_part_desc and
--                  changed the code accordingly.
--  050719  IsAnlk  Added parameter matched_contract_ to Start_Auto_Matching_Process___ and modified
--                  code to use pur_catalog_no instead of catalog_no.
--  050719  IsAnlk  Modified Change_Header_State___ to avoid header state change when unmatching from header.
--  050718  JaBalk  Changed the client_state_list_.
--  050718  IsAnlk  Added private method Set_Line_Unmatch__.
--  050718  RaKalk  Modified Do_Automatic_Match method to block auto matching when additional cost is used.
--  050718  IsAnlk  Modified Header_To_Be_Set_Matched___ to return TRUE atleast one line is matched.
--  050715  IsAnlk  Renamed vat_amount column as tax_amount.
--  050714  UsRalk  Added private method Set_To_Matched__.
--  050713  IsAnlk  Modified Change_Header_State___ by adding event UnmatchHeader.
--  050713  IsAnlk  Modified Create_Self_Billing_Item___, Start_Auto_Matching_Process and
--                  Change_Header_State___ to match incoiming message correctly.
--  050712  NuFilk  Modified method Create_Self_Billing_Item___.
--  050712  UsRalk  Added column catalog_desc to view SBILINES.
--  050712  JaBalk  Added events to change the state from Stopped to Stopped and Unmatched to Unmatched
--  050712          Changed to Changed. Added Set_Line_Cancel__.
--  050711  NuFilk  Modified method Create_Self_Billing_Item___ to handle tax amounts.
--  050711  JaBalk  Removed Unmatch and AutoMatch events and releated methods.
--  050711  JaBalk  Done GUI changes.
--  050708  JaJalk  Added the field ERROR_MESSAGE and removed the ERROR_TEXT.
--  050707  JaBalk  Set error messge to ERROR_TEXT field not to ERROR_MESSAGE.
--  050707  JaJalk  Added the validations in the method Validate_Line___.
--  050707  RaKalk  Removed fields Item_Pos and Invoice_No
--  050705  RaKalk  Added columns Additional_Cost and Invoice_No
--  050705  JaJalk  Added the methods Header_To_Be_Set_Unmatched___, Header_To_Be_Set_Matched___,
--  050705          Header_To_Be_Set_Changed___,Header_To_Be_Set_Stopped___ to retrieve the valid header states.
--  050705  RaKalk  Removed Public new method.
--  050705  RaKalk  Added method New_Item__
--  050704  JaBalk  Added fields price_information,customer_po_no,customer_po_line_no,customer_po_rel_no,reference_id,
--  050704          reference_id,gross_amount,approval_date,error_text. Removed view DELNOTE.
--  050704  JaJalk  Added the method Validate_Matching_Record___ and modified the some of codes of state machine.
--  050701  JaBalk  Added Set_Sbi_Record_Values___.
--  050701  JaBalk  Added Create_Self_Billing_Item___ instead of EXT_INC_SBI_UTIL_API.Update_Customer_Values.
--  050701  JaJalk  JaJalk  Implemented the most of the relevant logics with regards to the J-Invo functionality.
--  050630  JaJalk  Added the methods Do_Automatic_Match__ and Validate_Line___.
--  050627  JaJalk  Modified the state machine to support the new J-Invo self billing functionality.
--  040506  DaRulk  Renamed 'Delivery Date' to 'Wanted Delivery Date' in view comments.
--  040226  IsWilk  Removed the SUBSTRB for Unicode Changes.
--  ---------------13.3.0----------------------------------------------------
--  020614  ARAM  Removed status 'SBICreated'
--  020516  ARAM  Added new event 'Cancel' between status Receive and Cancelled.
--  020515  ARAM  Added event 'Match' between status InProcess and LineMatched.
--  020513  ARAM  Modified where clause in views INCOMING_SBI_DELIVERY_NOTE and INCOMING_SBI_LINES.
--  020508  ARAM  Added message_line_type column.
--  020415  ARAM  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Validate_Before_Auto_Match___
--   General Validations will be done before matching the record for
--   automatic match lines.
PROCEDURE Validate_Before_Auto_Match___ (
   rec_ IN EXT_INC_SBI_ITEM_TAB%ROWTYPE )
IS
   sb_matching_option_db_     VARCHAR2(30);
   cust_ord_cust_rec_         Cust_Ord_Customer_API.Public_Rec;
BEGIN

   --customer_no_ := Ext_Inc_Sbi_Head_API.Get_Customer_no(rec_.message_id);
   cust_ord_cust_rec_      := Cust_Ord_Customer_API.Get(Ext_Inc_Sbi_Head_API.Get_Customer_No(rec_.message_id));
   sb_matching_option_db_  := cust_ord_cust_rec_.self_billing_match_option;

   Validate_Mandatory_Fields___(rec_);

   -- Automatic process is not allowed when the additional_cost is used
   IF (rec_.additional_cost IS NOT NULL AND rec_.additional_cost != 0) THEN
      Error_SYS.Record_General('ExtIncSbiItem', 'ADITNLCOSTNOTNULL: The Incoming Self-Billing line holds an additional cost and must therefore be matched manually.');
   END IF;

   CASE sb_matching_option_db_
      WHEN 'DELIVERY NOTE' THEN
         IF (rec_.delnote_no IS NULL ) THEN
            Error_Sys.Record_General(lu_name_, 'DELNOTEERR: For automatic matching Delivery Note No must have a value.');
         END IF;
      WHEN 'REFERENCE ID' THEN
         IF (rec_.reference_id IS NULL) THEN
            Error_Sys.Record_General(lu_name_, 'REFIDEERR: For automatic matching Reference ID must have a value.');
         END IF;
      WHEN 'CUSTOMERS PO REFERENCE' THEN
         IF (rec_.customer_po_no IS NULL OR rec_.customer_po_line_no IS NULL OR rec_.customer_po_rel_no IS NULL ) THEN
            Error_Sys.Record_General(lu_name_, 'CPOERR: For automatic matching Customers Purchase Order information must have values');
         END IF;
   END CASE;

END Validate_Before_Auto_Match___;


-- Validate_Mandatory_Fields___
--   Validates the mandatory fields when matching.
PROCEDURE Validate_Mandatory_Fields___ (
   rec_ IN EXT_INC_SBI_ITEM_TAB%ROWTYPE )
IS
BEGIN

   IF (rec_.customer_part_no IS NULL) THEN
      Error_Sys.Record_General(lu_name_, 'CUSTOMERPARTNULL: Customer Part No must have a value.');
   END IF;

   IF (rec_.inv_qty IS NULL ) THEN
      Error_Sys.Record_General(lu_name_, 'INVQTYNULL: Invoiced Quantity must have a value.');
   END IF;

   IF (rec_.inv_qty = 0 ) THEN
      Error_Sys.Record_General(lu_name_, 'INVQTYZERO: Invoiced Quantity cannot be zero.');
   END IF;

   IF (rec_.sales_unit_meas IS NULL) THEN
      Error_Sys.Record_General(lu_name_, 'SALESUNITNULL: Sales U/M must have a value.');
   END IF;

   IF (rec_.price_unit_meas IS NULL) THEN
      Error_Sys.Record_General(lu_name_, 'PRICEUNITNULL: Price U/M must have a value.');
   END IF;

   IF (rec_.sales_unit_price IS NULL) THEN
      Error_Sys.Record_General(lu_name_, 'SALESPRICENULL: Sales Unit Price must have a value.');
   END IF;

   IF (rec_.inv_qty*(rec_.sales_unit_price/rec_.price_conv_factor) != rec_.net_amount) THEN
      Error_Sys.Record_General(lu_name_, 'INVALIDNETAMOUNT: The Net Amount must be equal to Sales Unit Price * Invoiced Quantity.');
   END IF;

   IF (rec_.net_amount IS NOT NULL AND rec_.tax_amount IS NOT NULL AND rec_.gross_amount IS NOT NULL)  THEN
      IF (rec_.net_amount + rec_.tax_amount != rec_.gross_amount) THEN
         Error_Sys.Record_General(lu_name_, 'VALUEERROR: The sum of Tax Amount and Net Amount must be equal to Gross Amount of the line.');
      END IF;
   ELSE
      IF ((rec_.net_amount IS NULL AND rec_.tax_amount IS NULL) OR (rec_.net_amount IS NULL AND rec_.gross_amount IS NULL)
         OR (rec_.gross_amount IS NULL AND rec_.tax_amount IS NULL))  THEN
         Error_Sys.Record_General(lu_name_, 'AMOUNTNULL: At least two amounts out of Net Amount, Tax Amount and Gross Amount must have values.');
      END IF;
   END IF;

END Validate_Mandatory_Fields___;


-- Start_Auto_Matching_Process___
--   Invokes the auto sbi matching process.
PROCEDURE Start_Auto_Matching_Process___ (
   rec_ IN EXT_INC_SBI_ITEM_TAB%ROWTYPE )
IS
   inc_delnote_no_         VARCHAR2(2000);
   inc_customer_part_no_   VARCHAR2(2000);
   inc_inv_qty_            NUMBER;
   header_invoice_no_      VARCHAR2(50);
   sbi_no_                 NUMBER;
   sb_matching_option_db_  VARCHAR2(50);
   inc_reference_id_       VARCHAR2(50);
   attr_                   VARCHAR2(32000);
   contract_               VARCHAR2(5);
   prev_company_           VARCHAR2(20);
   current_company_        VARCHAR2(20);
   info_                   VARCHAR2(32000);
   error_message_          EXT_INC_SBI_ITEM_TAB.error_message%TYPE;
   objid_                  VARCHAR2(2000);
   objversion_             VARCHAR2(2000);
   customer_no_            EXT_INC_SBI_HEAD_TAB.customer_no%TYPE;
   deliv_no_               NUMBER;
   matched_contract_       VARCHAR2(5);
   inc_header_rec_         Ext_Inc_Sbi_Head_API.Public_Rec;
   sbi_header_rec_         SELF_BILLING_HEADER_TAB%ROWTYPE;
   cust_ord_cust_rec_      Cust_Ord_Customer_API.Public_Rec;
   currency_code_          VARCHAR2(3);
   qty_delivered_          NUMBER;

   CURSOR get_incoming_sbi_data IS
      SELECT delnote_no, customer_part_no, inv_qty, reference_id
        FROM EXT_INC_SBI_ITEM_TAB
       WHERE message_id = rec_.message_id
         AND message_line = rec_.message_line;

   CURSOR get_exist_sbi_no (header_invoice_no_ IN VARCHAR2) IS
      SELECT sbi_no
        FROM self_billing_header_tab
       WHERE message_id = rec_.message_id
         AND NVL(sb_reference_no, CHR(2)) = NVL(header_invoice_no_, CHR(2))
         AND rowstate = 'Preliminary';

   CURSOR get_header_data IS
      SELECT customer_no, invoice_no, currency
        FROM ext_inc_sbi_head_tab
       WHERE message_id = rec_.message_id;

BEGIN

   Validate_Matching_Record___(rec_);

   OPEN  get_header_data;
   FETCH get_header_data INTO customer_no_, header_invoice_no_, currency_code_;
   CLOSE get_header_data;

   cust_ord_cust_rec_      := Cust_Ord_Customer_API.Get(customer_no_);
   sb_matching_option_db_  := cust_ord_cust_rec_.self_billing_match_option;

   OPEN  get_exist_sbi_no(header_invoice_no_);
   FETCH get_exist_sbi_no INTO sbi_no_;
   CLOSE get_exist_sbi_no;

   OPEN  get_incoming_sbi_data;
   FETCH get_incoming_sbi_data INTO inc_delnote_no_,inc_customer_part_no_,inc_inv_qty_, inc_reference_id_;
   CLOSE get_incoming_sbi_data;

   CASE sb_matching_option_db_

   WHEN 'DELIVERY NOTE' THEN
      Order_Self_Billing_Manager_API.Get_Matched_Info_For_Delnote(deliv_no_,
                                                                  matched_contract_,
                                                                  inc_delnote_no_,
                                                                  customer_no_,
                                                                  inc_customer_part_no_,
                                                                  currency_code_);
   WHEN 'REFERENCE ID' THEN
      Order_Self_Billing_Manager_API.Get_Matched_Info_For_Ref_Id(deliv_no_,
                                                                 matched_contract_,
                                                                 inc_reference_id_,
                                                                 customer_no_,
                                                                 inc_customer_part_no_,
                                                                 currency_code_);
   WHEN 'CUSTOMERS PO REFERENCE' THEN
      Order_Self_Billing_Manager_API.Get_Matched_Info_For_Cpo(deliv_no_,
                                                              matched_contract_,
                                                              rec_.customer_po_no,
                                                              rec_.customer_po_line_no,
                                                              rec_.customer_po_rel_no,
                                                              customer_no_,
                                                              inc_customer_part_no_,
                                                              currency_code_);
   END CASE;

   qty_delivered_ := Customer_Order_Delivery_API.Get_Qty_Delivered(deliv_no_);
   IF (qty_delivered_ IS NOT NULL) THEN
      IF (rec_.inv_qty > qty_delivered_) THEN
         Error_SYS.Record_General(lu_name_, 'GREATER_MATCHED: The matched quantity should not be greater than the delivered quantity.');
      END IF;
   END IF;
   
   Client_SYS.Clear_Attr(attr_);
   IF sbi_no_ IS NULL THEN
      inc_header_rec_ := Ext_Inc_Sbi_Head_API.Get(rec_.message_id);
      Set_Sbi_Record_Values___(sbi_header_rec_, inc_header_rec_, rec_.message_id);
      Self_Billing_Header_API.Create_Header__(sbi_no_, sbi_header_rec_);
   END IF;

   -- fetch the contract from SelfBillingItem JustCreared
   contract_ := Self_Billing_Item_API.Get_Contract(sbi_no_, 1);
   IF contract_ IS NULL THEN
      contract_ := matched_contract_;
   END IF;
   prev_company_     := Site_API.Get_Company(contract_);
   current_company_  := Site_API.Get_Company(matched_contract_);

   IF (prev_company_ = current_company_) THEN
      Create_Self_Billing_Item___(rec_.message_id, rec_.message_line, deliv_no_, sbi_no_, matched_contract_);
      -- Clear the error messages created earlier before set the record to matched
      Clear_Line_Error_Messages__(rec_.message_id, rec_.message_line);

      Get_Id_Version_By_Keys___(objid_, objversion_, rec_.message_id, rec_.message_line);
      Match_Line__(info_, objid_, objversion_, attr_, 'DO');
   END IF;

   EXCEPTION
      WHEN OTHERS THEN
         error_message_ := SQLERRM;
         -- An error was trapped. Rollback entire transaction and write error_message.
         Client_SYS.Clear_Attr(attr_);
         Client_SYS.Add_To_Attr('ERROR_MESSAGE', error_message_, attr_);
         Get_Id_Version_By_Keys___(objid_, objversion_, rec_.message_id, rec_.message_line);
         Matching_Error__(info_, objid_, objversion_, attr_, 'DO');

END Start_Auto_Matching_Process___;


PROCEDURE Create_Self_Billing_Item___ (
   message_id_       IN NUMBER,
   inv_msg_line_     IN NUMBER,
   deliv_no_         IN NUMBER,
   sbi_no_           IN VARCHAR2,
   matched_contract_ IN VARCHAR2 )
IS
   catalog_no_           VARCHAR2(25);
   max_line_no_          NUMBER;
   header_gross_amount_  NUMBER;
   header_tax_amount_    NUMBER;
   matched_net_amount_   NUMBER;
   net_amount_           NUMBER;
   tax_amount_           NUMBER;
   gross_amount_         NUMBER;
   discount_amount_      NUMBER;
   cust_net_amount_      NUMBER;
   cust_tax_amount_      NUMBER;
   cust_gross_amount_    NUMBER;
   confirmed_sbi_qty_    NUMBER;
   qty_to_match_         NUMBER;
   matched_qty_          NUMBER;
   curr_rounding_        NUMBER;
   viewrec_              UNMATCHED_SBI_DELIVERIES%ROWTYPE;
   linerec_              SELF_BILLING_ITEM_TAB%ROWTYPE;
   sbi_header_rec_       Self_Billing_Header_API.Public_Rec;
   ext_inc_sbi_head_rec_ Ext_Inc_Sbi_Head_API.Public_Rec;

   CURSOR get_inventory_msg_line IS
       SELECT *
         FROM ext_inc_sbi_item_tab
        WHERE message_id   = message_id_
          AND message_line = inv_msg_line_;

   get_inv_msg_line_      get_inventory_msg_line%ROWTYPE;

   CURSOR sbi_Line IS
      SELECT *
        FROM unmatched_sbi_deliveries
       WHERE deliv_no = deliv_no_;

    CURSOR get_max_line_no IS
       SELECT MAX(sbi_line_no)
         FROM self_billing_item_tab
        WHERE sbi_no = sbi_no_;

    line_discount_ NUMBER;
BEGIN

   sbi_header_rec_       := Self_Billing_Header_API.Get(sbi_no_);
   ext_inc_sbi_head_rec_ := Ext_Inc_Sbi_Head_API.Get(message_id_);

   OPEN get_max_line_no;
   FETCH get_max_line_no INTO max_line_no_;
   CLOSE get_max_line_no;

   max_line_no_ := nvl(max_line_no_, 0) + 1;

   -- Insert all the matched lines to the self billing item tab.
   OPEN get_max_line_no;
   FETCH get_max_line_no INTO max_line_no_;
   CLOSE get_max_line_no;

   max_line_no_ := nvl(max_line_no_, 0) + 1;

   -- Insert all the matched lines to the self billing item tab.
   -- Note: Get sbi line information
   OPEN sbi_line;
   FETCH sbi_line INTO viewrec_;

   IF (sbi_line%FOUND) THEN
      CLOSE sbi_line;
      -- Tell the system this line is automatically matched.
      linerec_.sbi_no               := sbi_no_;
      linerec_.sbi_line_no          := max_line_no_;
      linerec_.message_id           := message_id_;
      linerec_.message_row          := inv_msg_line_;
      linerec_.deliv_no             := deliv_no_;

      -- Note: Fetch part information
      OPEN  get_inventory_msg_line;
      FETCH get_inventory_msg_line INTO get_inv_msg_line_;
      CLOSE get_inventory_msg_line;

      linerec_.order_no             := viewrec_.order_no;
      linerec_.line_no              := viewrec_.line_no;
      linerec_.rel_no               := viewrec_.rel_no;
      linerec_.line_item_no         := viewrec_.line_item_no;
      linerec_.buy_qty_due          := viewrec_.buy_qty_due;
      linerec_.consignment_stock    := viewrec_.consignment_stock;
      linerec_.part_price           := viewrec_.part_price;
      linerec_.price_source         := viewrec_.price_source;
      linerec_.currency_code        := ext_inc_sbi_head_rec_.currency;
      linerec_.pay_term_id          := viewrec_.pay_term_id;
      linerec_.order_id             := viewrec_.order_id;
      linerec_.fee_code             := viewrec_.fee_code;
      linerec_.line_state           := viewrec_.state;
      linerec_.matched_date         := SYSDATE;
      linerec_.match_type           := 'AUTOMATIC';
      linerec_.conv_factor          := viewrec_.conv_factor;
      linerec_.price_conv_factor    := viewrec_.price_conv_factor;
      linerec_.delnote_no           := viewrec_.delnote_no;
      linerec_.wanted_delivery_date := viewrec_.wanted_delivery_date;
      linerec_.date_delivered       := viewrec_.date_delivered;

      curr_rounding_         := Currency_Code_API.Get_Currency_Rounding(viewrec_.company, linerec_.currency_code);

      -- calculate the line totals
      net_amount_ := viewrec_.buy_qty_due * viewrec_.price_conv_factor * viewrec_.part_price;
      -- NOTE: When using price including tax, discount calculation is not modified as this pakage was not handled in price including tax is specified.
      IF (Customer_Order_API.Get_Use_Price_Incl_Tax_Db(viewrec_.order_no) = 'TRUE') THEN
         discount_amount_  := (net_amount_ - (net_amount_ * (1 - viewrec_.included_discount / 100) * (1 - viewrec_.included_total_order_discount / 100)));
      ELSE
         line_discount_ := Cust_Order_Line_Discount_API.Get_Total_Line_Discount(viewrec_.order_no, viewrec_.line_no, viewrec_.rel_no, viewrec_.line_item_no, viewrec_.buy_qty_due, viewrec_.price_conv_factor);
         discount_amount_  := (net_amount_ - ((net_amount_ -line_discount_) * (1 - viewrec_.included_total_order_discount / 100)));

      END IF;
      
      net_amount_   := net_amount_ - discount_amount_;

      tax_amount_   := net_amount_ * NVL(Source_Tax_Item_API.Get_Total_Tax_Percentage(viewrec_.company, Tax_Source_API.DB_CUSTOMER_ORDER_LINE,
                                            viewrec_.order_no, viewrec_.line_no, viewrec_.rel_no, TO_CHAR(viewrec_.line_item_no), '*')/100,0);

      gross_amount_ := net_amount_ + tax_amount_;

      linerec_.net_curr_amount   := ROUND(net_amount_, curr_rounding_);
      linerec_.tax_curr_amount   := ROUND(tax_amount_, curr_rounding_);
      linerec_.gross_curr_amount := ROUND(gross_amount_, curr_rounding_);

      linerec_.customer_no       := ext_inc_sbi_head_rec_.customer_no;

      linerec_.customer_part_no  := get_inv_msg_line_.customer_part_no;

      IF get_inv_msg_line_.catalog_no IS NOT NULL THEN
         IF (get_inv_msg_line_.catalog_no != viewrec_.catalog_no)  THEN
            Error_Sys.Record_General(lu_name_, 'SALESPARTINVALID: Sales Part No :P1 does not exist in matched customer order line.', get_inv_msg_line_.catalog_no);
         ELSE
            catalog_no_ := get_inv_msg_line_.catalog_no;
         END IF;
      ELSE
         catalog_no_ := viewrec_.catalog_no;
      END IF;

      linerec_.catalog_no          := catalog_no_;
      linerec_.cust_unit_part_price:= get_inv_msg_line_.sales_unit_price;
      linerec_.cust_unit_sales_qty := get_inv_msg_line_.inv_qty;
      linerec_.customer_qty        := get_inv_msg_line_.inv_qty * NVL(viewrec_.customer_part_conv_factor, 1) / NVL(viewrec_.cust_part_invert_conv_fact, 1);
      linerec_.sales_unit_meas     := viewrec_.sales_unit_meas;
      linerec_.discount_amount     := viewrec_.included_total_order_discount;
      linerec_.discount            := viewrec_.included_discount;

      confirmed_sbi_qty_           := Customer_Order_Delivery_API.Get_Confirmed_Sbi_Qty(deliv_no_);
      matched_qty_                 := linerec_.customer_qty;
      confirmed_sbi_qty_           := confirmed_sbi_qty_ + linerec_.customer_qty;
      qty_to_match_                := viewrec_.qty_to_invoice - confirmed_sbi_qty_;

      linerec_.matched_qty         := matched_qty_;
      linerec_.qty_to_match        := qty_to_match_;

      -- calculate the customer totals
      cust_net_amount_ := get_inv_msg_line_.net_amount;
      cust_tax_amount_ := ROUND(cust_net_amount_ * NVL(Source_Tax_Item_API.Get_Total_Tax_Percentage(viewrec_.company, Tax_Source_API.DB_CUSTOMER_ORDER_LINE,
                                 viewrec_.order_no, viewrec_.line_no, viewrec_.rel_no, TO_CHAR(viewrec_.line_item_no), '*')/100,0), curr_rounding_);

      cust_gross_amount_ := cust_net_amount_+ cust_tax_amount_;

      linerec_.cust_net_curr_amount   := cust_net_amount_;

      header_gross_amount_  := sbi_header_rec_.gross_amount + cust_gross_amount_;
      header_tax_amount_    := sbi_header_rec_.tax_amount   + cust_tax_amount_;
      matched_net_amount_   := sbi_header_rec_.matched_net_amount + cust_net_amount_;

      linerec_.contract := matched_contract_;

      -- Create an item in the Self Billing Item Tab.
      Self_Billing_Item_API.New_Item__(linerec_);

      Customer_Order_Delivery_API.Modify_Confirmed_Sbi_Qty(deliv_no_,
                                                           confirmed_sbi_qty_);
      Self_Billing_Header_Api.Update_Totals(sbi_no_ ,
                                            header_gross_amount_,
                                            matched_net_amount_,
                                            header_tax_amount_);
   ELSE
      CLOSE sbi_line;
   END IF;

END Create_Self_Billing_Item___;


PROCEDURE Set_Sbi_Record_Values___ (
   sbi_header_rec_ OUT SELF_BILLING_HEADER_TAB%ROWTYPE,
   inc_header_rec_ IN  Ext_Inc_Sbi_Head_API.Public_Rec,
   message_id_     IN  NUMBER )
IS
BEGIN

   sbi_header_rec_.customer_id     := inc_header_rec_.customer_no;
   sbi_header_rec_.sb_reference_no := inc_header_rec_.invoice_no;
   sbi_header_rec_.modified_date   := SYSDATE;
   sbi_header_rec_.currency_code   := inc_header_rec_.currency;
   sbi_header_rec_.message_id      := message_id_;
END Set_Sbi_Record_Values___;


-- Validate_Matching_Record___
--   Validates the matching data and will be called only from the matching process.
PROCEDURE Validate_Matching_Record___ (
   rec_ IN EXT_INC_SBI_ITEM_TAB%ROWTYPE )
IS
   cust_ord_cust_rec_      Cust_Ord_Customer_API.Public_Rec;
   customer_no_            EXT_INC_SBI_HEAD_TAB.customer_no%TYPE;
   sb_matching_option_db_  VARCHAR2(30);
   currency_code_          VARCHAR2(3);

   CURSOR get_customer_info IS
      SELECT customer_no, currency
        FROM ext_inc_sbi_head_tab
       WHERE message_id = rec_.message_id;
BEGIN

   OPEN get_customer_info;
   FETCH get_customer_info INTO customer_no_, currency_code_;
   CLOSE get_customer_info;

   cust_ord_cust_rec_ := Cust_Ord_Customer_API.Get(customer_no_);
   sb_matching_option_db_ := cust_ord_cust_rec_.self_billing_match_option;

   CASE sb_matching_option_db_
      WHEN 'DELIVERY NOTE' THEN
         Order_Self_Billing_Manager_API.Check_Matched_Line_For_Delnote(rec_.delnote_no,
                                                                       customer_no_,
                                                                       rec_.customer_part_no,
                                                                       currency_code_);
      WHEN 'REFERENCE ID' THEN
         Order_Self_Billing_Manager_API.Check_Matched_Line_For_Ref(rec_.reference_id,
                                                                   customer_no_,
                                                                   rec_.customer_part_no,
                                                                   currency_code_);
      WHEN 'CUSTOMERS PO REFERENCE' THEN
         Order_Self_Billing_Manager_API.Check_Matched_Line_For_Cpo(rec_.customer_po_no,
                                                                   rec_.customer_po_line_no,
                                                                   rec_.customer_po_rel_no,
                                                                   customer_no_,
                                                                   rec_.customer_part_no,
                                                                   currency_code_);
   END CASE;
END Validate_Matching_Record___;


-- Header_To_Be_Set_Stopped___
--   Sbi Header will be set to Stopped if it returns true.
FUNCTION Header_To_Be_Set_Stopped___ (
   message_id_ IN NUMBER ) RETURN BOOLEAN
IS
   line_status_ VARCHAR2(20);

   CURSOR get_status IS
      SELECT rowstate
        FROM EXT_INC_SBI_ITEM_TAB
       WHERE message_id = message_id_
         AND rowstate   = 'Stopped';
BEGIN

   OPEN get_status;
   FETCH get_status INTO line_status_;
   IF (get_status%FOUND) THEN
      CLOSE get_status;
      RETURN TRUE;
   END IF;
   CLOSE get_status;

   RETURN FALSE;
END Header_To_Be_Set_Stopped___;


-- Header_To_Be_Set_Changed___
--   Sbi Header will be set to Changed if it returns true
FUNCTION Header_To_Be_Set_Changed___ (
   message_id_ IN NUMBER ) RETURN BOOLEAN
IS
   line_status_ VARCHAR2(20);

   CURSOR get_status IS
      SELECT rowstate
        FROM EXT_INC_SBI_ITEM_TAB
       WHERE message_id = message_id_
         AND rowstate = 'Changed';
BEGIN

   OPEN get_status;
   FETCH get_status INTO line_status_;
   IF (get_status%FOUND) THEN
      CLOSE get_status;
      RETURN TRUE;
   END IF;
   CLOSE get_status;

   RETURN FALSE;
END Header_To_Be_Set_Changed___;


-- Header_To_Be_Set_Unmatched___
--   Sbi Header will be set to UnMatched if it returns true
FUNCTION Header_To_Be_Set_Unmatched___ (
   message_id_ IN NUMBER ) RETURN BOOLEAN
IS
   line_status_ VARCHAR2(20);

   CURSOR get_status IS
      SELECT rowstate
        FROM EXT_INC_SBI_ITEM_TAB
       WHERE message_id = message_id_
         AND rowstate  = 'UnMatched';
BEGIN

   OPEN get_status;
   FETCH get_status INTO line_status_;
   IF (get_status%FOUND) THEN
      CLOSE get_status;
      RETURN TRUE;
   ELSE
      CLOSE get_status;
      RETURN FALSE;
   END IF;
END Header_To_Be_Set_Unmatched___;


-- Header_To_Be_Set_Matched___
--   Sbi Header will be set to Matched if it returns true
FUNCTION Header_To_Be_Set_Matched___ (
   message_id_ IN NUMBER ) RETURN BOOLEAN
IS
   line_status_ VARCHAR2(20);

   CURSOR get_status IS
      SELECT rowstate
        FROM EXT_INC_SBI_ITEM_TAB
       WHERE message_id = message_id_
         AND rowstate   = 'Matched';
BEGIN

   OPEN get_status;
   FETCH get_status INTO line_status_;
   IF (get_status%FOUND) THEN
      CLOSE get_status;
      RETURN TRUE;
   ELSE
      CLOSE get_status;
      RETURN FALSE;
   END IF;
END Header_To_Be_Set_Matched___;


PROCEDURE Do_Create_Error___ (
   rec_  IN OUT EXT_INC_SBI_ITEM_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   oldrec_        EXT_INC_SBI_ITEM_TAB%ROWTYPE;
   newrec_        EXT_INC_SBI_ITEM_TAB%ROWTYPE;
   objid_         EXT_INC_SBI_ITEM.OBJID%TYPE;
   objversion_    EXT_INC_SBI_ITEM.OBJVERSION%TYPE;
   indrec_        Indicator_Rec;
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, rec_.message_id, rec_.message_line);
   oldrec_ := Lock_By_Id___(objid_, objversion_);
   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_);
END Do_Create_Error___;


PROCEDURE Change_Header_State___ (
   rec_  IN OUT EXT_INC_SBI_ITEM_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   event_ VARCHAR2(200);
BEGIN

   IF Header_To_Be_Set_Stopped___(rec_.message_id) THEN
      -- SET the header TO stopped
      event_ := 'InvalidMessageHeader';
   ELSIF Header_To_Be_Set_Changed___(rec_.message_id) THEN
      -- SET the header TO Changed
      event_ := 'Change';
   ELSIF Header_To_Be_Set_Matched___(rec_.message_id) THEN
      --SET the head TO Partially Matched State
      IF (Ext_Inc_Sbi_Head_API.Get_Message_Status(rec_.message_id) = 'Matched') THEN
         -- SET the NULL event to change the status to Partially Matched
         event_ := NULL;
      ELSE
         event_ := 'MatchHeader';
      END IF;
   ELSIF Header_To_Be_Set_Unmatched___(rec_.message_id) THEN
      -- SET the header TO Unmatched
      event_ := 'UnmatchHeader';
   END IF;

   Ext_Inc_Sbi_Head_API.Change_Header_State__ (rec_.message_id, event_);
END Change_Header_State___;


PROCEDURE Do_Unmatch_Line___ (
   rec_  IN     EXT_INC_SBI_ITEM_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
BEGIN

   Self_Billing_Item_API.Unmatch_Line_From_Sbi_Message(rec_.message_id, rec_.message_line);
END Do_Unmatch_Line___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     EXT_INC_SBI_ITEM_TAB%ROWTYPE,
   newrec_     IN OUT EXT_INC_SBI_ITEM_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   info_  VARCHAR2(32000);
   rowid_ VARCHAR2(2000);
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   -- Set the status to Changed when changing any of the fields in header
   IF (newrec_.error_message IS NULL) THEN
      Get_Id_Version_By_Keys___(rowid_, objversion_, newrec_.message_id, newrec_.message_line);
      Change__(info_, rowid_, objversion_, attr_, 'DO');
   END IF;
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     ext_inc_sbi_item_tab%ROWTYPE,
   newrec_ IN OUT ext_inc_sbi_item_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN

   IF ((newrec_.rowstate = 'Cancelled') OR (newrec_.rowstate = 'Matched')) THEN
      Error_Sys.Record_General(lu_name_, 'MODNOTALLOWED: Changes are not allowed when the status is Matched or Cancelled');
   END IF;

   super(oldrec_, newrec_, indrec_, attr_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;

@Override
PROCEDURE Unpack___ (
   newrec_   IN OUT NOCOPY ext_inc_sbi_item_tab%ROWTYPE,
   indrec_   IN OUT NOCOPY Indicator_Rec,
   attr_     IN OUT NOCOPY VARCHAR2 )
IS
BEGIN
   -- Clear the error_message.
   newrec_.error_message := NULL;
   super(newrec_, indrec_, attr_);
END Unpack___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Do_Automatic_Match__
--   Match the lines automatically and will be called by the header.
PROCEDURE Do_Automatic_Match__ (
   message_id_   IN NUMBER,
   message_line_ IN NUMBER )
IS
   line_rec_ EXT_INC_SBI_ITEM_TAB%ROWTYPE;

   CURSOR get_rec IS
      SELECT *
        FROM EXT_INC_SBI_ITEM_TAB
       WHERE message_id   = message_id_
         AND message_line = message_line_;
BEGIN

   OPEN  get_rec;
   FETCH get_rec INTO line_rec_;
   CLOSE get_rec;

   Validate_Before_Auto_Match___(line_rec_);

   Start_Auto_Matching_Process___(line_rec_);

END Do_Automatic_Match__;


-- Set_Line_Error__
--   Sets the line error.
PROCEDURE Set_Line_Error__ (
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
   Invalid_Message_Line__(info_, objid_, objversion_, attr_, 'DO');
END Set_Line_Error__;


-- Validate_Before_Manual_Match__
--   Validates the data before the manual matching.
PROCEDURE Validate_Before_Manual_Match__ (
   error_message_ OUT VARCHAR2,
   message_id_    IN  NUMBER,
   message_line_  IN  NUMBER )
IS
   CURSOR get_rec IS
      SELECT  *
        FROM EXT_INC_SBI_ITEM_TAB
       WHERE message_id   = message_id_
         AND message_line = message_line_;

   rec_  EXT_INC_SBI_ITEM_TAB%ROWTYPE;
BEGIN

   OPEN  get_rec;
   FETCH get_rec INTO rec_;
   CLOSE get_rec;

   Validate_Mandatory_Fields___(rec_);

EXCEPTION
   WHEN OTHERS THEN
      error_message_ := SQLERRM;
      Set_Line_Error__(message_id_, message_line_, error_message_);
      error_message_ := Language_SYS.Translate_Constant(lu_name_, error_message_);
END Validate_Before_Manual_Match__;


PROCEDURE New_Item__ (
   rec_ IN EXT_INC_SBI_ITEM_TAB%ROWTYPE )
IS
   newrec_      EXT_INC_SBI_ITEM_TAB%ROWTYPE;
   newattr_     VARCHAR2(32000);
   objid_       VARCHAR2(2000);
   objversion_  VARCHAR2(2000);
   indrec_      Indicator_Rec;
BEGIN
   newrec_ := rec_;
   Unpack___(newrec_, indrec_, newattr_);
   Check_Insert___(newrec_, indrec_, newattr_);
   Insert___(objid_, objversion_, newrec_, newattr_);
END New_Item__;


-- Set_Line_Cancel__
--   Set the line status to 'Cancelled'.
PROCEDURE Set_Line_Cancel__ (
   message_id_   IN NUMBER,
   message_line_ IN NUMBER )
IS
   info_       VARCHAR2(2000);
   attr_       VARCHAR2(2000);
   objid_      EXT_INC_SBI_ITEM.OBJID%TYPE;
   objversion_ EXT_INC_SBI_ITEM.OBJVERSION%TYPE;
BEGIN

   Get_Id_Version_By_Keys___(objid_, objversion_, message_id_, message_line_);
   Client_SYS.Clear_Attr(attr_);
   Cancel__(info_, objid_, objversion_, attr_, 'DO');
END Set_Line_Cancel__;


-- Set_Line_Matched__
--   External interface for state machine.
--   Fires the event [ MatchLine ] on the selected line.
--   Should be invoked from server only.
--   Called from OrderSelfBillingManager.
PROCEDURE Set_Line_Matched__ (
   message_id_   IN NUMBER,
   message_line_ IN NUMBER )
IS
   info_       VARCHAR2(2000);
   attr_       VARCHAR2(2000);
   objid_      EXT_INC_SBI_ITEM.OBJID%TYPE;
   objversion_ EXT_INC_SBI_ITEM.OBJVERSION%TYPE;
BEGIN

   Get_Id_Version_By_Keys___(objid_, objversion_, message_id_, message_line_);
   Client_SYS.Clear_Attr(attr_);
   Match_Line__(info_, objid_, objversion_, attr_, 'DO');
END Set_Line_Matched__;


-- Clear_Line_Error_Messages__
--   Clears any previous error messages on the line.
PROCEDURE Clear_Line_Error_Messages__ (
   message_id_   IN NUMBER,
   message_line_ IN NUMBER )
IS
   attr_       VARCHAR2(2000);
   objid_      EXT_INC_SBI_ITEM.OBJID%TYPE;
   objversion_ EXT_INC_SBI_ITEM.OBJVERSION%TYPE;
   oldrec_     EXT_INC_SBI_ITEM_TAB%ROWTYPE;
   newrec_     EXT_INC_SBI_ITEM_TAB%ROWTYPE;
   indrec_     Indicator_Rec;
BEGIN
   Client_SYS.Add_To_Attr('ERROR_MESSAGE', '', attr_);
   Get_Id_Version_By_Keys___(objid_, objversion_, message_id_, message_line_);
   oldrec_ := Lock_By_Id___(objid_, objversion_);
   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_);
END Clear_Line_Error_Messages__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Set_Line_Unmatch
--   Unmatch the incoming self-billing lines.
PROCEDURE Set_Line_Unmatch (
   message_id_   IN NUMBER,
   message_line_ IN NUMBER )
IS
   info_       VARCHAR2(2000);
   attr_       VARCHAR2(2000);
   objid_      EXT_INC_SBI_ITEM.OBJID%TYPE;
   objversion_ EXT_INC_SBI_ITEM.OBJVERSION%TYPE;
BEGIN

   Get_Id_Version_By_Keys___(objid_, objversion_, message_id_, message_line_);
   Client_SYS.Clear_Attr(attr_);
   Unmatch_Line__(info_, objid_, objversion_, attr_, 'DO');
END Set_Line_Unmatch;


