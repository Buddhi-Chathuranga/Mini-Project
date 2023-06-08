-----------------------------------------------------------------------------
--
--  Logical unit: OutstandingSalesAccting
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  211102  MaEelk   SC21R2-5668, Replaced control_type_key_rec_.oe_tax_code_ with control_type_key_rec_.tax_code_ in Do_Str_Event_Acc___
--  200626  KiSalk  Bug 153956(SCZ-9900), As Customer_Order_Inv_Item_API.Get_Sale_Unit_Price will be obsolete, replaced with Customer_Order_Inv_Item_API.Get_Item_Sale_Unit_Price.
--  191126  ErFelk  Bug 150216, Modified Create_Voucher___() and Do_Str_Event_Acc___() so that if a negative amount comes it gets posted to reverse directions with positive values.
--  190930  DaZase  SCSPRING20-146, Added Raise_Co_Posting_Error___ to solve MessageDefinitionValidation issue.
--  190521  ApWilk  Bug 144329, Modified Create_Postings___() by adding a condition to control creating tax postings depends on the value of the checkbox 
--  190521          'Include tax when creating Interim Sales Voucher' introduced to the Company/Order sub tab.
--  180521  AsZelk  Bug 141237, Used source_tax_item_base_pub view instead of source_tax_item_pub.
--  180222  IzShlk  STRSC-17321, Removed unnessary/usges TO_CHAR() within cursors.
--  151103  IsSalk  FINHR-316, Renamed attribute FEE_CODE to TAX_CODE in Customer Order Line.
--  151020  NipKlk  Bug 124976, Added method Check_No_Previous_Execution___() to check if there is already a background job for
--  151020          creation of interim sales vouchers for the given company, year and period.
--  150608  Raablk  Bug 121642,In Create_Tax_Postings___, set a few attribute of VoucherRow_Rec_ as requested by Finance side.
--  140912  Asawlk  PRSC-1950, Replaced the usages of Mpccom_Accounting_API.Control_Type_Key_Rec with local variables or parameters of same type.
--  140729  Asawlk  PRSC-1949, Replaced the usages of Mpccom_Accounting_API.Codestring_Rec with local variables or parameters of same type.
--  140227  AyAmlk  Bug 115258, Modified Create_Postings___() by passing CO header ship_addr_no instead of CO line ship_addr_no to fetch
--  140227          the correct customer_tax_regime_db_.
--  140127  MaEelk  Increased the length of account_err_desc_ in Do_Str_Event_Acc___ to avoid the numeric or value error raised before triggering the relevant error message
--  140122  Vwloza  Updated Create_Voucher___() with a rental check.
--  130917  NWeelk  Bug 111252, Modified method Create_Discount_Postings___ to get the additional discount from the invoice line.
--  130828  Asawlk  TIBE-2517, Removed calls to obsolete method Mpccom_Accounting_API.End_Booking.
--  130709  MaIklk  TIBE-1009, Moved global variables VoucherRow_Rec_ and InitVoucherRow_Rec_ to inside the relevant functions.
--  121210   Maaylk  PEPA-183, Increased length of voucher_id_ variable
--  120829  SeJalk  Added the function Interim_Voucher_Exist.
--  110316  Darklk  Bug 96033, Modified the procedure Complete_Check_Accounting___ to add a DUMMY value to the variable codestr_rec_.text.
--  110127  NeKolk  EANE-3744  added where clause to the View OUTSTANDING_SALES_ACCTING.
--  101230  MiKulk  Replaced the call to Customer_Info_Vat_API with the new method.
--  100525  MaMalk  Set company as a part of the primary key and did the necessary changes
--  100525          to maintain the parent child relationship with AccountingPeriod.
--  100520  KRPELK  Merge Rose Method Documentation.
--  --------------------- 14.0.0 ----------------------------------------------
--  081006  ChJalk  Bug 77372, Modified Do_Str_Event_Acc___ to extend the error messages ACCERROR1 and ACCERROR2 with the related Customer Order No.
--  060419  MaJalk  Enlarge Customer - Changed variable definitions.
--  -------------------- 13.4.0 -----------------------------------------------
--  060322  NuFilk  Modified method Create_Voucher_Row___ to handle reference_number correctly.
--  060302  RaKalk  Modified method Create_Interim_Voucher__ to make hte function give error
--  060302          if today is the end of the accounting period
--  060224  MiKulk  Modified the tax retrival logic in Create_Postings method
--  060202  SeNslk  Replaced column names debit_value and credit_value with debit_amount and
--  060202          credit_amount to be consistent with the client field labels.
--  060111  JOHESE  Modified Create_Interim_Voucher__ to only create a background job when run online
--  060103  IsAnlk  Added General_Sys to Create_Interim_Voucher_Attr__.  
--  050831  AnLaSe  Use reverse_voucher_date in Reverse_Voucher___.
--  050830  JOHESE  Assigned value for Mpccom_Accounting_API.Control_Type_Key_Rec.company_ in procedure Create_Postings___
--  050818  JOHESE  Added procedure Create_Interim_Voucher_Attr__ and modified Create_Interim_Voucher__ to run as a background job
--  050915  AnLaSe  CID 125855, changed select condition in Create_Voucher___.
--  050809  AnLaSe  CID 125773. Excluded records with incorrect delivery confirmation
--                  when selecting from OUTSTANDING_SALES_JOIN.
--  050809  AnLaSe  Removed obsolete paremeter from Voucher_Util_Pub_API.Create_Reverse_Voucher.
--  050715  JOHESE  Added check on allowed periods in Create_Interim_Voucher__
--  050711  AnLaSe  Added call to Voucher_Util_Pub_API.Create_Reverse_Voucher in Reverse_Voucher___.
--  050705  AnLaSe  Added call to Get_Next_Allowed_Period.
--  050629  MaEelk  Added General_SYS.Init method to Create_Interim_Voucher.
--  050620  AnLaSe  Changed calculation for tax postings.
--  050616  AnLaSe  CID 125030 moved validation for tax code.
--  050614  AnLaSe  Use price_conv_factor when calculation discount postings.
--  050610  AnLaSe  Added additional check in Reverse_Voucher___.
--  050607  AnLaSe  Added NVL in setting of sequence_no.
--  050602  AnLaSe  Commented call to Reverse_Voucher to be able to test. Method in Financials does not work properly.
--                  Modifications to fetch gross amount for account_value. Changed setting of sequence_no.
--  050530  AnLaSe  Modified Create_Postings___, Create_Balance_Posting___ and Reverse_Voucher___.
--  050525  AnLaSe  Added Create_Balance_Posting___. Moved call to Create_Voucher___.
--                  Removed date_cogs_posted in select from OUTSTANDING_SALES_JOIN.
--  050519  AnLaSe  Added Create_Tax_Postings___.
--  050517  AnLaSe  Added handling of tax_code. Modified Create_Discount_Postings___.
--  050502  AnLaSe  Modified call to Create_Postings___. Added contract and company in Do_New___.
--  050502  DaZase  Added debit_value and credit_value to view and some uppercase in the view comments.
--  050429  AnLaSe  Added InitVoucherRow_Rec_ in Create_Voucher___ to verify that correct
--                  values are in the VouherRow_Rec when calling Voucher_API.Add_Voucher_Row.
--                  Changed order of parameters in Complete_Check_Accounting___.
--  050422  AnLaSe  Added several implementation methods for creating postings and vouchers.
--                  Added global VoucherRow_Rec_.
--  050401  DaZase  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Raise_Co_Posting_Error___ (
   order_no_         IN VARCHAR2,
   account_err_desc_ IN VARCHAR2)
IS
BEGIN
   Error_SYS.Appl_General(lu_name_, 'ACCERROR: Posting cannot be created for Customer Order :P1. :P2', order_no_, account_err_desc_);
END Raise_Co_Posting_Error___;   
   

-- Create_Interim_Voucher___
--   Create interim sales postings for a period in past time and one voucher
--   for all the postings created.
--   Validations for in-parameters made in Create_Interim_Voucher__,
--   which is called from the client.
PROCEDURE Create_Interim_Voucher___ (
   company_           IN VARCHAR2,
   accounting_year_   IN NUMBER,
   accounting_period_ IN NUMBER,
   voucher_date_      IN DATE )
IS
   user_group_        VARCHAR2(30);
   function_group_    VARCHAR2(10);
   voucher_type_      VARCHAR2(3);
   voucher_no_        NUMBER;
BEGIN
   Check_No_Previous_Execution___(company_, accounting_year_, accounting_period_, 'Outstanding_Sales_Accting_API.Create_Interim_Voucher_Attr__');
   user_group_     := User_Group_Member_Finance_API.Get_User_Group(company_, Fnd_Session_API.Get_Fnd_User);
   function_group_ := 'LI';

   Voucher_Type_User_Group_API.Get_Default_Voucher_Type(voucher_type_,
                                                        company_,
                                                        user_group_,
                                                        accounting_year_,
                                                        function_group_);

   --Creates voucher header, postings and voucher rows.
   --Returns voucher_no which is needed to reverse vouchers.
   --Voucher date will be the last date in the period, the date the voucher is created.
   Create_Voucher___(voucher_no_,
                     voucher_type_,
                     company_,
                     accounting_year_,
                     accounting_period_,
                     voucher_date_,
                     function_group_,
                     user_group_ );

   --Reverse the voucher that was just created in next period
   Reverse_Voucher___(voucher_type_, user_group_, voucher_no_, company_, accounting_year_, accounting_period_ );
END Create_Interim_Voucher___;


-- Create_Voucher___
--   Creates voucher header. Creates postings and voucher rows within same loop.
--   Loops over outstanding_sales to create postings and voucher rows.
--   Closes voucher when all voucher rows are created.
PROCEDURE Create_Voucher___ (
   voucher_no_        OUT NUMBER,
   voucher_type_      IN  VARCHAR2,
   company_           IN  VARCHAR2,
   accounting_year_   IN  NUMBER,
   accounting_period_ IN  NUMBER,
   voucher_date_      IN  DATE,
   function_group_    IN  VARCHAR2,
   user_group_        IN  VARCHAR2 )
IS
   transfer_id_          VARCHAR2(200);
   voucher_id_           VARCHAR2(300);
   base_currency_code_   VARCHAR2(3);
   voucher_row_rec_      Voucher_API.VoucherRowRecType;
   init_voucher_row_rec_ Voucher_API.VoucherRowRecType;   
   control_type_key_rec_ Mpccom_Accounting_API.Control_Type_Key;
   
   CURSOR get_outstanding_sales IS
      SELECT outstanding_sales_id, qty_expected, invoice_id, item_id, order_no, line_no, rel_no, line_item_no, contract, catalog_no, incorrect_del_confirmation_db
      FROM   OUTSTANDING_SALES_JOIN
      WHERE  company = company_
      AND    date_cogs_posted <= voucher_date_
      AND    (date_sales_posted > voucher_date_ OR date_sales_posted IS NULL)
      AND    incorrect_del_confirmation_db = 'FALSE'
      AND    rental_db = 'FALSE';

BEGIN

   Voucher_API.Transfer_Init(transfer_id_, company_);

   --Create Voucher Header for all interim sales vouchers.
   --this method will return voucher_id and voucher_no, needed to create voucher rows.
   Create_Voucher_Header___(voucher_no_,
                            voucher_id_,
                            transfer_id_,
                            company_,
                            accounting_year_,
                            accounting_period_,
                            voucher_date_,
                            voucher_type_,
                            function_group_);

   -- Assign values for voucher outside loop, these will be the same for every voucher row.
   base_currency_code_   := Company_Finance_API.Get_Currency_Code(company_);
   voucher_row_rec_      := NULL;
   init_voucher_row_rec_ := NULL;

   init_voucher_row_rec_.company            := company_;
   init_voucher_row_rec_.voucher_type       := voucher_type_;
   init_voucher_row_rec_.function_group     := function_group_;
   init_voucher_row_rec_.accounting_year    := accounting_year_;
   init_voucher_row_rec_.accounting_period  := accounting_period_;
   init_voucher_row_rec_.voucher_no         := voucher_no_;
   init_voucher_row_rec_.correction         := 'N';
   init_voucher_row_rec_.currency_code      := base_currency_code_;
   init_voucher_row_rec_.transfer_id        := transfer_id_;
   init_voucher_row_rec_.corrected          := 'N';
   init_voucher_row_rec_.voucher_date       := voucher_date_;

   voucher_row_rec_ := init_voucher_row_rec_;

   -- Create postings and voucher rows within same loop.
   FOR outstanding_sales_rec_ IN get_outstanding_sales LOOP      
      Create_Postings___(control_type_key_rec_,
                         voucher_row_rec_,
                         init_voucher_row_rec_,
                         outstanding_sales_rec_.outstanding_sales_id,
                         outstanding_sales_rec_.qty_expected,
                         outstanding_sales_rec_.invoice_id,
                         outstanding_sales_rec_.item_id,
                         outstanding_sales_rec_.order_no,
                         outstanding_sales_rec_.line_no,
                         outstanding_sales_rec_.rel_no,
                         outstanding_sales_rec_.line_item_no,
                         outstanding_sales_rec_.contract,
                         outstanding_sales_rec_.catalog_no,
                         voucher_id_,
                         user_group_   );

      
      --All postings for one oustanding_sales will be balanced in one posting.
      Create_Balance_Posting___(voucher_row_rec_,
                                init_voucher_row_rec_,
                                outstanding_sales_rec_.outstanding_sales_id,
                                outstanding_sales_rec_.qty_expected,
                                outstanding_sales_rec_.invoice_id,
                                outstanding_sales_rec_.order_no,
                                outstanding_sales_rec_.contract,
                                voucher_id_,
                                user_group_,
                                control_type_key_rec_);
   App_Context_SYS.Set_Value('OUTSTANDING_SALES_ACCTING_API.OUTSTANDING_SALES_ID_', '');  
   END LOOP;

   --after all voucher lines are created
   Voucher_API.Voucher_End(voucher_id_, TRUE);
END Create_Voucher___;


-- Create_Voucher_Header___
--   Creates one voucher header for all interim sales voucher lines.
--   This method will return voucher_id, needed to create postings and
--   voucher_no, needed to reverse vouchers.
PROCEDURE Create_Voucher_Header___ (
   voucher_no_        OUT NUMBER,
   voucher_id_        OUT VARCHAR2,
   transfer_id_       IN  VARCHAR2,
   company_           IN  VARCHAR2,
   accounting_year_   IN  NUMBER,
   accounting_period_ IN  NUMBER,
   voucher_date_      IN  DATE,
   voucher_type_      IN  VARCHAR2,
   function_group_    IN  VARCHAR2 )
IS
   dummy_                  VARCHAR2(30);
   temp_accounting_year_   NUMBER;
   temp_accounting_period_ NUMBER;
   temp_voucher_type_      VARCHAR2(3);
BEGIN

   voucher_no_             := 0;
   voucher_id_             := NULL;
   temp_accounting_year_   := accounting_year_;
   temp_accounting_period_ := accounting_period_;
   temp_voucher_type_      := voucher_type_;

   --Create Voucher Header for all interim sales voucher rows.
   --this method will return voucher_id and voucher_no, needed to create voucher rows.
   Voucher_API.New_Voucher(voucher_type_        => temp_voucher_type_,
                           voucher_no_          => voucher_no_,
                           voucher_id_          => voucher_id_,
                           accounting_year_     => temp_accounting_year_,
                           accounting_period_   => temp_accounting_period_,
                           company_             => company_,
                           transfer_id_         => transfer_id_,
                           voucher_date_        => voucher_date_,
                           voucher_group_       => function_group_,
                           user_group_          => dummy_,
                           correction_          => 'N');
END Create_Voucher_Header___;


-- Create_Postings___
--   Creates postings for an outstanding sales.
--   Set booking and creates postings for sale. Set control_type_key.
--   Further call to create postings for discounts and tax.
PROCEDURE Create_Postings___ (
   control_type_key_rec_ OUT    Mpccom_Accounting_API.Control_Type_Key,
   voucher_row_rec_      IN OUT Voucher_API.VoucherRowRecType,
   init_voucher_row_rec_ IN     Voucher_API.VoucherRowRecType,
   outstanding_sales_id_ IN     NUMBER,
   qty_expected_         IN     NUMBER,
   invoice_id_           IN     NUMBER,
   item_id_              IN     NUMBER,
   order_no_             IN     VARCHAR2,
   line_no_              IN     VARCHAR2,
   rel_no_               IN     VARCHAR2,
   line_item_no_         IN     NUMBER,
   contract_             IN     VARCHAR2,
   catalog_no_           IN     VARCHAR2,
   voucher_id_           IN     VARCHAR2,
   user_group_           IN     VARCHAR2 )
IS
   linerec_                Customer_Order_Line_API.Public_Rec;
   part_no_                VARCHAR2(25);
   sales_price_            NUMBER;
   inv_head_rec_           Customer_Order_Inv_Head_API.Public_Rec;
   base_price_             NUMBER;
   gross_amount_           NUMBER;
   round_gross_amount_     NUMBER;
   currency_rounding_      NUMBER;
   taxable_sales_          NUMBER;
   catalog_type_           VARCHAR2(20);
   inventory_              VARCHAR2(200) := Sales_Part_Type_API.Decode('INV');
   booking_                NUMBER;
   tax_code_               VARCHAR2(20);
   customer_order_rec_     CUSTOMER_ORDER_API.Public_Rec; 
   tax_liability_type_db_  VARCHAR2(20);
   sum_discount_           NUMBER;
   allow_tax_postings_     VARCHAR2(5);

   CURSOR inv_taxable_sales (inv_id_ IN VARCHAR2, inv_item_id_ IN VARCHAR2) IS
      SELECT 1
      FROM   source_tax_item_base_pub
      WHERE  source_ref1 = inv_id_
      AND    source_ref2 = inv_item_id_
      AND    source_ref3 = '*'
      AND    source_ref4 = '*'
      AND    source_ref5 = '*'
      AND    source_ref_type_db = Tax_Source_API.DB_INVOICE
      AND    company = voucher_row_rec_.company
      AND    tax_percentage != 0;

   CURSOR taxable_sales (line_item_no_ IN VARCHAR2) IS
      SELECT 1
      FROM   source_tax_item_base_pub
      WHERE  source_ref1 = order_no_
      AND    source_ref2 = line_no_
      AND    source_ref3 = rel_no_
      AND    source_ref4 = line_item_no_
      AND    source_ref5 = '*'
      AND    source_ref_type_db = Tax_Source_API.DB_CUSTOMER_ORDER_LINE
      AND    company = voucher_row_rec_.company
      AND    tax_percentage != 0;
BEGIN

   -- Check if postings for taxable or non-taxable sales should be generated.
   IF invoice_id_ IS NOT NULL THEN
      --fetch from invoice if invoice exist
      OPEN inv_taxable_sales (TO_CHAR(invoice_id_), TO_CHAR(item_id_));
      FETCH inv_taxable_sales INTO taxable_sales_;
      IF (inv_taxable_sales%NOTFOUND) THEN
         taxable_sales_ := 0;
      END IF;
      CLOSE inv_taxable_sales;
   ELSE
      --fetch all values from the customer order if no invoice exist.
      OPEN taxable_sales(TO_CHAR(line_item_no_));
      FETCH taxable_sales INTO taxable_sales_;
      IF (taxable_sales%NOTFOUND) THEN
         taxable_sales_ := 0;
      END IF;
      CLOSE taxable_sales;
   END IF;

   linerec_ := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);
   part_no_ := linerec_.part_no;
   allow_tax_postings_ := Company_Order_Info_Api.Get_Include_Tax_For_Interim_Db(voucher_row_rec_.company);

   -- Fetch the accounting value without discounts, without tax.
   IF invoice_id_ IS NOT NULL THEN
      sales_price_  := Customer_Order_Inv_Item_API.Get_Item_Sale_Unit_Price(voucher_row_rec_.company, invoice_id_, item_id_); --order currency
      inv_head_rec_ := Customer_Order_Inv_Head_API.Get(voucher_row_rec_.company, invoice_id_);
      base_price_   := Customer_Order_Pricing_API.Get_Base_Price_By_Rate(inv_head_rec_.curr_rate, inv_head_rec_.div_factor, sales_price_); --rate from the date invoice was created, not sysdate!
      --price_conv_ should be the same on invoice and CO.
      gross_amount_ := linerec_.price_conv_factor * base_price_ * qty_expected_;  --conversion between sale unit and price unit
   ELSE
      gross_amount_ := linerec_.base_sale_unit_price * linerec_.price_conv_factor * qty_expected_;
   END IF;
   currency_rounding_  := Currency_Code_API.Get_Currency_Rounding(voucher_row_rec_.company, voucher_row_rec_.currency_code);
   round_gross_amount_ := ROUND(gross_amount_, currency_rounding_);

   catalog_type_ := Sales_Part_API.Get_Catalog_Type(contract_, catalog_no_);
   IF (catalog_type_ != inventory_) THEN
      control_type_key_rec_.part_no_ := catalog_no_;
   ELSE
      control_type_key_rec_.part_no_ := part_no_;
   END IF;

   control_type_key_rec_.company_            := voucher_row_rec_.company;
   control_type_key_rec_.contract_           := contract_;
   control_type_key_rec_.pre_accounting_id_  := linerec_.pre_accounting_id;
   control_type_key_rec_.oe_invoice_id_      := invoice_id_;
   control_type_key_rec_.oe_invoice_item_id_ := item_id_;
   control_type_key_rec_.catalog_no_         := catalog_no_;
   control_type_key_rec_.oe_order_no_        := order_no_;
   control_type_key_rec_.oe_line_no_         := line_no_;
   control_type_key_rec_.oe_rel_no_          := rel_no_;
   control_type_key_rec_.oe_line_item_no_    := line_item_no_;

   -- Booking sale
   IF (taxable_sales_ = 1) THEN
      booking_ := 1;
   ELSE
      booking_ := 3;
   END IF;
   
   IF invoice_id_ IS NOT NULL THEN
      tax_code_ := Customer_Order_Inv_Item_API.Get_Vat_Code(voucher_row_rec_.company, invoice_id_, item_id_);
   ELSE
      customer_order_rec_     := Customer_Order_API.Get(order_no_);
      tax_liability_type_db_  := Customer_Order_Line_API.Get_Tax_Liability_Type_Db(order_no_, line_no_, rel_no_, line_item_no_);
      
      IF (tax_liability_type_db_ != 'EXM') THEN
         tax_code_ := linerec_.tax_code;
      END IF;
   --If using Sales Tax and several tax lines exist for one order row, tax code will be fetched from tax lines in Create_Tax_Postings___.
   END IF;

   --Get the code string and do accounting
   Do_Str_Event_Acc___(voucher_row_rec_,
                       init_voucher_row_rec_,
                       outstanding_sales_id_,
                       qty_expected_,
                       contract_,
                       customer_order_rec_.customer_no,
                       user_group_,
                       booking_,
                       round_gross_amount_,
                       tax_code_,
                       voucher_id_,
                       invoice_id_,
                       order_no_,
                       control_type_key_rec_);

   -- Create postings for discounts.
   Create_Discount_Postings___(sum_discount_, --OUT used for tax postings, rounded
                               voucher_row_rec_,
                               init_voucher_row_rec_,
                               outstanding_sales_id_,
                               qty_expected_,
                               gross_amount_,
                               invoice_id_,
                               item_id_,
                               order_no_,
                               line_no_,
                               rel_no_,
                               line_item_no_,
                               contract_,
                               customer_order_rec_.customer_no,
                               voucher_id_,
                               user_group_,
                               taxable_sales_,
                               tax_code_,
                               control_type_key_rec_);

   --Create posting for tax lines
   IF(allow_tax_postings_ = 'TRUE')THEN
      IF (taxable_sales_ = 1) THEN
         Create_Tax_Postings___(voucher_row_rec_,
                             init_voucher_row_rec_,
                             outstanding_sales_id_,
                             qty_expected_,
                             round_gross_amount_,
                             sum_discount_,
                             invoice_id_,
                             item_id_,
                             order_no_,
                             line_no_,
                             rel_no_,
                             line_item_no_,
                             contract_,
                             customer_order_rec_.customer_no,
                             voucher_id_,
                             user_group_,
                             control_type_key_rec_);
      END IF;
   END IF;
END Create_Postings___;


-- Do_Str_Event_Acc___
--   Retrieves the code string values and creates a new posting record in Outstanding_Sales_Accting_tab.
--   Sets row specific valus for voucher_row_rec_.
--   Creates a new voucher row for each record in Outstanding_Sales_Accting_tab
--   Calls End_Booking for each hit on the specified posting_event 'INTM-SALES'.
PROCEDURE Do_Str_Event_Acc___ (
   voucher_row_rec_      IN OUT Voucher_API.VoucherRowRecType,
   init_voucher_row_rec_ IN     Voucher_API.VoucherRowRecType,
   outstanding_sales_id_ IN     NUMBER,
   qty_expected_         IN     NUMBER,
   contract_             IN     VARCHAR2,
   customer_no_          IN     VARCHAR2,
   user_group_           IN     VARCHAR2,
   booking_              IN     NUMBER,
   account_value_        IN     NUMBER,
   tax_code_             IN     VARCHAR2,
   voucher_id_           IN     VARCHAR2,
   invoice_id_           IN     NUMBER,
   order_no_             IN     VARCHAR2,
   control_type_key_rec_ IN     Mpccom_Accounting_API.Control_Type_Key )
IS
   posting_event_         VARCHAR2(20) := 'INTM-SALES'; --event_code
   account_err_desc_      VARCHAR2(2000);
   account_err_status_    VARCHAR2(2);
   error_                 NUMBER;
   pre_accounting_exist_  NUMBER;
   activity_seq_          NUMBER;
   codestr_rec_           Accounting_Codestr_API.CodestrRec;
   -- This local variable replaced the usages of Mpccom_Accounting_API.Codestring_Rec.
   codestring_rec_        Accounting_Codestr_API.CodestrRec; 
   -- PRSC-1949, end   
   local_control_type_key_rec_  Mpccom_Accounting_API.Control_Type_Key := control_type_key_rec_;
   amount_                NUMBER;
   debit_credit_db_       VARCHAR2(1);
   

   CURSOR get_str_event_acc IS
      SELECT str_code, booking, pre_accounting_flag_db, debit_credit_db, project_accounting_flag_db
      FROM ACC_EVENT_POSTING_TYPE_PUB
      WHERE  event_code = posting_event_;

BEGIN

   local_control_type_key_rec_.tax_code_ := tax_code_;

   FOR eventrec_ IN get_str_event_acc LOOP
      IF (eventrec_.booking = booking_) THEN
         -- PRSC-1949, Passed parameter codestring_rec_. 
         Mpccom_Accounting_API.Get_Code_String(account_err_desc_,
                                               account_err_status_,
                                               codestring_rec_,
                                               local_control_type_key_rec_,
                                               voucher_row_rec_.company,
                                               eventrec_.str_code,
                                               voucher_row_rec_.voucher_date);
         IF (account_err_desc_ IS NOT NULL) THEN
            error_ := 1;
         ELSE
            error_ := 0;
         END IF;

         pre_accounting_exist_ := Pre_Accounting_API.Pre_Accounting_Exist(local_control_type_key_rec_.pre_accounting_id_);

         IF (pre_accounting_exist_ = 0) THEN            
            local_control_type_key_rec_.pre_accounting_id_ := Pre_Accounting_API.Get_Pre_Accounting_Id(local_control_type_key_rec_);
         END IF;

         -- Do pre accounting if it exists.
         IF (local_control_type_key_rec_.pre_accounting_id_ IS NOT NULL) THEN            
            -- PRSC-1949, Passed parameter codestring_rec_. 
            Pre_Accounting_API.Do_Pre_Accounting(activity_seq_,
                                                 codestring_rec_,
                                                 local_control_type_key_rec_,
                                                 local_control_type_key_rec_.pre_accounting_id_,
                                                 eventrec_.pre_accounting_flag_db,
                                                 eventrec_.project_accounting_flag_db);
         END IF;

         IF (error_ = 1) THEN
            Raise_Co_Posting_Error___(order_no_, account_err_desc_);
         END IF;

         codestr_rec_.code_a := codestring_rec_.code_a;
         codestr_rec_.code_b := codestring_rec_.code_b;
         codestr_rec_.code_c := codestring_rec_.code_c;
         codestr_rec_.code_d := codestring_rec_.code_d;
         codestr_rec_.code_e := codestring_rec_.code_e;
         codestr_rec_.code_f := codestring_rec_.code_f;
         codestr_rec_.code_g := codestring_rec_.code_g;
         codestr_rec_.code_h := codestring_rec_.code_h;
         codestr_rec_.code_i := codestring_rec_.code_i;
         codestr_rec_.code_j := codestring_rec_.code_j;
         codestr_rec_.quantity := qty_expected_;

         account_err_desc_ := NULL;
         Complete_Check_Accounting___(account_err_desc_, codestr_rec_,
                                      user_group_, eventrec_.str_code, voucher_row_rec_ );

         IF (account_err_desc_ IS NOT NULL) THEN
            Raise_Co_Posting_Error___(order_no_, account_err_desc_);
         END IF;

         codestring_rec_.code_a := codestr_rec_.code_a;
         codestring_rec_.code_b := codestr_rec_.code_b;
         codestring_rec_.code_c := codestr_rec_.code_c;
         codestring_rec_.code_d := codestr_rec_.code_d;
         codestring_rec_.code_e := codestr_rec_.code_e;
         codestring_rec_.code_f := codestr_rec_.code_f;
         codestring_rec_.code_g := codestr_rec_.code_g;
         codestring_rec_.code_h := codestr_rec_.code_h;
         codestring_rec_.code_i := codestr_rec_.code_i;
         codestring_rec_.code_j := codestr_rec_.code_j;
         
         amount_ := account_value_;
         
         IF (App_Context_SYS.Find_Number_Value('OUTSTANDING_SALES_ACCTING_API.OUTSTANDING_SALES_ID_') = outstanding_sales_id_) THEN
            IF (eventrec_.debit_credit_db = 'D') THEN 
               debit_credit_db_ := 'C';
            ELSE
               debit_credit_db_ := 'D'; 
            END IF; 
            IF (account_value_ < 0) THEN
               amount_ := account_value_ * -1;
            END IF;      
         END IF;
            
         IF (eventrec_.debit_credit_db = 'C') THEN
            IF (account_value_ < 0) THEN
               amount_ := account_value_ * -1;
               debit_credit_db_ := 'D';                   
               App_Context_SYS.Set_Value('OUTSTANDING_SALES_ACCTING_API.OUTSTANDING_SALES_ID_', outstanding_sales_id_);               
            END IF;
         END IF;   
         
         -- Create the posting
         Do_New___(outstanding_sales_id_,
                   contract_,
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
                   activity_seq_,
                   eventrec_.str_code, --posting_type_
                   posting_event_,     --event_code
                   NVL(debit_credit_db_, eventrec_.debit_credit_db),
                   amount_,
                   voucher_row_rec_);

         --Assign values for code string. This is used in Create_Voucher_Row___.
         voucher_row_rec_.Codestring_Rec.code_a   := codestring_rec_.code_a;
         voucher_row_rec_.Codestring_Rec.code_b   := codestring_rec_.code_b;
         voucher_row_rec_.Codestring_Rec.code_c   := codestring_rec_.code_c;
         voucher_row_rec_.Codestring_Rec.code_d   := codestring_rec_.code_d;
         voucher_row_rec_.Codestring_Rec.code_e   := codestring_rec_.code_e;
         voucher_row_rec_.Codestring_Rec.code_f   := codestring_rec_.code_f;
         voucher_row_rec_.Codestring_Rec.code_g   := codestring_rec_.code_g;
         voucher_row_rec_.Codestring_Rec.code_h   := codestring_rec_.code_h;
         voucher_row_rec_.Codestring_Rec.code_i   := codestring_rec_.code_i;
         voucher_row_rec_.Codestring_Rec.code_j   := codestring_rec_.code_j;

         --Assign values for debet and credit amount set on voucher row
         IF NVL(debit_credit_db_, eventrec_.debit_credit_db) = 'D' THEN
            voucher_row_rec_.currency_debet_amount   := amount_;
            voucher_row_rec_.currency_credit_amount  := NULL;
            voucher_row_rec_.debet_amount            := amount_;
            voucher_row_rec_.credit_amount           := NULL;
         ELSE
            voucher_row_rec_.currency_debet_amount   := NULL;
            voucher_row_rec_.currency_credit_amount  := amount_;
            voucher_row_rec_.debet_amount            := NULL;
            voucher_row_rec_.credit_amount           := amount_;
         END IF;

         voucher_row_rec_.quantity                   := qty_expected_;
         voucher_row_rec_.project_activity_id        := activity_seq_;
         voucher_row_rec_.trans_code                 := eventrec_.str_code; -- posting_type
         voucher_row_rec_.optional_code              := tax_code_;
         voucher_row_rec_.text                       := outstanding_sales_id_;

         -- Create a voucher row for each outstanding_sales_accting
         Create_Voucher_Row___(voucher_row_rec_, voucher_id_, invoice_id_, order_no_, customer_no_);

         -- voucher_row_rec_ is an IN OUT parameter in Voucher_API.Add_Voucher_Row()
         -- This call assures that voucher_row_rec_ does only include the default values in the next loop
         voucher_row_rec_ := init_voucher_row_rec_;
      END IF;
   END LOOP;
END Do_Str_Event_Acc___;


-- Complete_Check_Accounting___
--   Checks the code string and returns an error message if it went wrong.
PROCEDURE Complete_Check_Accounting___ (
   account_err_desc_ OUT    VARCHAR2,
   codestr_rec_      IN OUT Accounting_Codestr_API.CodestrRec,
   user_group_       IN     VARCHAR2,
   posting_type_     IN     VARCHAR2,
   voucher_row_rec_  IN     Voucher_API.VoucherRowRecType )
IS
   accounting_error  EXCEPTION;
   pragma            exception_init(accounting_error, -20105);
BEGIN

   Accounting_Codestr_API.Complete_Codestring( codestr_rec_, voucher_row_rec_.company,
                                               posting_type_, voucher_row_rec_.voucher_date);
   codestr_rec_.text := 'DUMMY';
   Accounting_Codestr_API.Validate_Codestring( codestr_rec_, voucher_row_rec_.company,
                                               voucher_row_rec_.voucher_date, user_group_);

   account_err_desc_ := NULL;
EXCEPTION
   WHEN accounting_error THEN
      account_err_desc_ := substr(sqlerrm, instr(sqlerrm, ':') + 2, 100);
END Complete_Check_Accounting___;


-- Do_New___
--   Creates a new posting
PROCEDURE Do_New___ (
   outstanding_sales_id_ IN NUMBER,
   contract_             IN VARCHAR2,
   code_a_               IN VARCHAR2,
   code_b_               IN VARCHAR2,
   code_c_               IN VARCHAR2,
   code_d_               IN VARCHAR2,
   code_e_               IN VARCHAR2,
   code_f_               IN VARCHAR2,
   code_g_               IN VARCHAR2,
   code_h_               IN VARCHAR2,
   code_i_               IN VARCHAR2,
   code_j_               IN VARCHAR2,
   activity_seq_         IN NUMBER,
   posting_type_         IN VARCHAR2,
   posting_event_        IN VARCHAR2,
   debit_credit_db_      IN VARCHAR2,
   account_value_        IN NUMBER,
   voucher_row_rec_      IN Voucher_API.VoucherRowRecType  )
IS
   seq_                   NUMBER;
   attr_                  VARCHAR2(32000);
   newrec_                OUTSTANDING_SALES_ACCTING_TAB%ROWTYPE;
   objid_                 OUTSTANDING_SALES_ACCTING.objid%TYPE;
   objversion_            OUTSTANDING_SALES_ACCTING.objversion%TYPE;
   indrec_                Indicator_Rec;
   CURSOR get_seq IS
      SELECT NVL(MAX(sequence_no),0) + 1
      FROM OUTSTANDING_SALES_ACCTING_TAB
      WHERE outstanding_sales_id = outstanding_sales_id_
      AND   company = voucher_row_rec_.company
      AND   accounting_year = voucher_row_rec_.accounting_year
      AND   accounting_period = voucher_row_rec_.accounting_period;
BEGIN

   OPEN  get_seq;
   FETCH get_seq INTO seq_;
   CLOSE get_seq;

   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('OUTSTANDING_SALES_ID', outstanding_sales_id_, attr_);
   Client_SYS.Add_To_Attr('COMPANY', voucher_row_rec_.company, attr_);
   Client_SYS.Add_To_Attr('ACCOUNTING_YEAR', voucher_row_rec_.accounting_year, attr_);
   Client_SYS.Add_To_Attr('ACCOUNTING_PERIOD', voucher_row_rec_.accounting_period, attr_);
   Client_SYS.Add_To_Attr('SEQUENCE_NO', seq_, attr_);
   Client_SYS.Add_To_Attr('CODE_A', code_a_, attr_);
   Client_SYS.Add_To_Attr('CODE_B', code_b_, attr_);
   Client_SYS.Add_To_Attr('CODE_C', code_c_, attr_);
   Client_SYS.Add_To_Attr('CODE_D', code_d_, attr_);
   Client_SYS.Add_To_Attr('CODE_E', code_e_, attr_);
   Client_SYS.Add_To_Attr('CODE_F', code_f_, attr_);
   Client_SYS.Add_To_Attr('CODE_G', code_g_, attr_);
   Client_SYS.Add_To_Attr('CODE_H', code_h_, attr_);
   Client_SYS.Add_To_Attr('CODE_I', code_i_, attr_);
   Client_SYS.Add_To_Attr('CODE_J', code_j_, attr_);
   Client_SYS.Add_To_Attr('ACTIVITY_SEQ', activity_seq_, attr_);
   Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_);
   Client_SYS.Add_To_Attr('VOUCHER_NO', voucher_row_rec_.voucher_no, attr_);
   Client_SYS.Add_To_Attr('VOUCHER_TYPE', voucher_row_rec_.voucher_type, attr_);
   Client_SYS.Add_To_Attr('VOUCHER_DATE', voucher_row_rec_.voucher_date, attr_);
   Client_SYS.Add_To_Attr('POSTING_TYPE', posting_type_, attr_);
   Client_SYS.Add_To_Attr('POSTING_EVENT', posting_event_, attr_);
   Client_SYS.Add_To_Attr('DEBIT_CREDIT', debit_credit_db_, attr_);
   Client_SYS.Add_To_Attr('VALUE', account_value_, attr_);

   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);
END Do_New___;


-- Create_Voucher_Row___
--   Creates one interim voucher row for each record in outstanding_sales_accting.
--   Values that are fetched earlier in the flow are assigned to voucher_row_rec_.
--   In this method values not needed earlier in the flow are assigned to voucher_row_rec_.
PROCEDURE Create_Voucher_Row___ (
   voucher_row_rec_ IN OUT Voucher_API.VoucherRowRecType,
   voucher_id_      IN     VARCHAR2,
   invoice_id_      IN     NUMBER,
   order_no_        IN     VARCHAR2,
   customer_no_     IN     VARCHAR2 )
IS
   customer_no_pay_      cust_ord_customer_pub.customer_no%TYPE;
   invoice_status_       VARCHAR2(30);         
BEGIN

   IF invoice_id_ IS NOT NULL THEN
      --fetch customer on customer invoice
      customer_no_pay_                 := Customer_Order_Inv_Head_API.Get_Identity(voucher_row_rec_.company, invoice_id_);
      voucher_row_rec_.reference_serie := Customer_Order_Inv_Head_API.Get_Series_Id_By_Id(invoice_id_);
      
      invoice_status_                  := Invoice_API.Is_Inv_Preliminary(voucher_row_rec_.company, invoice_id_);
      IF invoice_status_ = 'Preliminary' THEN 
         voucher_row_rec_.reference_number := invoice_id_;
      ELSE
         voucher_row_rec_.reference_number := Customer_Order_Inv_Head_API.Get_Invoice_No(voucher_row_rec_.company, NULL, NULL, invoice_id_);
      END IF;
   ELSE
      --get paying customer no
      customer_no_pay_                  := Customer_Order_API.Get_Customer_No_Pay(order_no_);
      voucher_row_rec_.reference_number := order_no_;
   END IF;

   voucher_row_rec_.party_type          := 'CUSTOMER';
   IF customer_no_pay_ IS NULL THEN
      voucher_row_rec_.party_type_id := customer_no_;
   ELSE
      voucher_row_rec_.party_type_id := customer_no_pay_;
   END IF;

   Voucher_API.Add_Voucher_Row(voucher_row_rec_,
                               voucher_row_rec_.transfer_id,
                               voucher_id_);
END Create_Voucher_Row___;


-- Reverse_Voucher___
--   Reverse the vouchers just created in the next accounting period.
PROCEDURE Reverse_Voucher___ (
   voucher_type_      IN VARCHAR2,
   user_group_        IN VARCHAR2,
   voucher_no_        IN NUMBER,
   company_           IN VARCHAR2,
   accounting_year_   IN NUMBER,
   accounting_period_ IN NUMBER )
IS
   reversal_voucher_no_   NUMBER;
   reversal_acc_year_     NUMBER;
   reversal_acc_period_   NUMBER;
   reversal_voucher_date_ DATE;
BEGIN

   reversal_voucher_no_ := NULL;

   -- Reversed voucher may not be created on a period that is year opening or year close.
   Accounting_Period_API.Get_Next_Allowed_Period(reversal_acc_period_, reversal_acc_year_, company_, accounting_period_, accounting_year_);

   reversal_voucher_date_ := Accounting_Period_API.Get_Date_From(company_, reversal_acc_year_, reversal_acc_period_);

   Voucher_Util_Pub_API.Create_Reverse_Voucher(reversal_voucher_no_, company_, voucher_no_, accounting_year_, voucher_type_,
                                               reversal_voucher_date_, reversal_acc_year_, reversal_acc_period_, user_group_,
                                               voucher_type_ );

   --Set reversed voucher no for all records created for this voucher.
   Set_Reversed_Voucher_No___(company_, accounting_year_, accounting_period_, voucher_no_, reversal_voucher_no_);
END Reverse_Voucher___;


-- Set_Reversed_Voucher_No___
--   Updates the posting with the reversed voucher no.
--   Sets reversed voucher no in OutstandingSalesAccting for all records
--   created for a specific voucher no.
PROCEDURE Set_Reversed_Voucher_No___ (
   company_           IN VARCHAR2,
   accounting_year_   IN NUMBER,
   accounting_period_ IN NUMBER,
   voucher_no_        IN NUMBER,
   rev_voucher_no_    IN NUMBER )
IS
   attr_                 VARCHAR2(32000);
   newrec_               OUTSTANDING_SALES_ACCTING_TAB%ROWTYPE;
   oldrec_               OUTSTANDING_SALES_ACCTING_TAB%ROWTYPE;
   objid_                OUTSTANDING_SALES_ACCTING.objid%TYPE;
   objversion_           OUTSTANDING_SALES_ACCTING.objversion%TYPE;
   indrec_               Indicator_Rec;
   
   CURSOR get_postings IS
      SELECT *
      FROM OUTSTANDING_SALES_ACCTING_TAB
      WHERE company = company_
      AND   accounting_year    = accounting_year_
      AND   accounting_period  = accounting_period_
      AND   voucher_no         = voucher_no_
      FOR UPDATE;
BEGIN

   --Set reversed voucher no for all records created for this voucher.
   FOR posting_rec_ IN get_postings LOOP
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('REVERSED_VOUCHER_NO', rev_voucher_no_, attr_);
      oldrec_ := posting_rec_;
      newrec_ := posting_rec_;      
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
      Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE); -- Update by keys
   END LOOP;
END Set_Reversed_Voucher_No___;

-- Create_Discount_Postings___
--   Create all discount postings for an invoice item or customer order line
PROCEDURE Create_Discount_Postings___ (
   sum_discount_         OUT    NUMBER,
   voucher_row_rec_      IN OUT Voucher_API.VoucherRowRecType,
   init_voucher_row_rec_ IN     Voucher_API.VoucherRowRecType,
   outstanding_sales_id_ IN     NUMBER,
   qty_expected_         IN     NUMBER,
   gross_amount_         IN     NUMBER,
   invoice_id_           IN     NUMBER,
   item_id_              IN     NUMBER,
   order_no_             IN     VARCHAR2,
   line_no_              IN     VARCHAR2,
   rel_no_               IN     VARCHAR2,
   line_item_no_         IN     NUMBER,
   contract_             IN     VARCHAR2,
   customer_no_          IN     VARCHAR2,
   voucher_id_           IN     VARCHAR2,
   user_group_           IN     VARCHAR2,
   taxable_sales_        IN     NUMBER,
   tax_code_             IN     VARCHAR2,
   control_type_key_rec_ IN     Mpccom_Accounting_API.Control_Type_Key)
IS
   base_currency_code_   VARCHAR2(3);
   order_currency_code_  VARCHAR2(3);
   order_date_           DATE;
   inv_head_rec_         Customer_Order_Inv_Head_API.Public_Rec;
   price_conv_factor_    NUMBER;
   conv_factor_          NUMBER;
   curr_rate_            NUMBER;
   dummy_                VARCHAR2(10); --curr_type
   currency_rounding_    NUMBER;
   order_discount_       NUMBER;
   booking_              NUMBER;
   discount_amount_      NUMBER;
   base_discount_amount_ NUMBER;
   total_line_discount_  NUMBER := 0;
   order_discount_basis_ NUMBER;
   additional_discount_  NUMBER;
   add_discount_amount_  NUMBER;
   discount_             NUMBER := 0;
   customer_order_rec_   CUSTOMER_ORDER_API.Public_Rec;   
   local_control_type_key_rec_    Mpccom_Accounting_API.Control_Type_Key := control_type_key_rec_; 
   
   CURSOR get_inv_line_discounts IS
      SELECT discount_no, discount_type, discount,
             --calculation_basis in order currency
             (calculation_basis * NVL(discount, 0)/100 + NVL(discount_amount, 0))  discount_amount
      FROM   CUST_INVOICE_ITEM_DISCOUNT_TAB
      WHERE  company = voucher_row_rec_.company
      AND    invoice_id = invoice_id_
      AND    item_id = item_id_;

   CURSOR get_co_line_discounts IS
      SELECT discount_no, discount_type, discount,
             (calculation_basis * NVL(discount, 0)/100 + NVL(discount_amount, 0))  discount_amount
      FROM   CUST_ORDER_LINE_DISCOUNT_TAB
      WHERE  order_no = order_no_
      AND    line_no = line_no_
      AND    rel_no  = rel_no_
      AND    line_item_no = line_item_no_;

BEGIN

   base_currency_code_  := voucher_row_rec_.currency_code;
   currency_rounding_   := Currency_Code_API.Get_Currency_Rounding(voucher_row_rec_.company, base_currency_code_);
   order_currency_code_ := Customer_Order_API.Get_Currency_Code(order_no_);
   sum_discount_        := 0;

   IF invoice_id_ IS NOT NULL THEN
      --use this method if invoice exist
      order_discount_    := Customer_Order_Inv_Item_API.Get_Order_Discount(voucher_row_rec_.company, invoice_id_, item_id_);
      price_conv_factor_ := Customer_Order_Inv_Item_API.Get_Price_Conv_Factor(voucher_row_rec_.company, invoice_id_, item_id_);

      -- Create postings for each line discount record
      FOR discount_rec_ IN get_inv_line_discounts LOOP
         discount_amount_ := (discount_rec_.discount_amount * qty_expected_ * price_conv_factor_);
         --Get the discount amount in base currency using the currency rate on the order, not todays rate.
         inv_head_rec_         := Customer_Order_Inv_Head_API.Get(voucher_row_rec_.company, invoice_id_);
         base_discount_amount_ := Customer_Order_Pricing_API.Get_Base_Price_By_Rate(inv_head_rec_.curr_rate, inv_head_rec_.div_factor, discount_amount_);
         base_discount_amount_ := ROUND(base_discount_amount_, currency_rounding_); --base_curr
         discount_             := discount_rec_.discount;   --%
         total_line_discount_  := total_line_discount_ + base_discount_amount_; --base_curr

         local_control_type_key_rec_.oe_discount_no_   := discount_rec_.discount_no;
         local_control_type_key_rec_.oe_discount_type_ := discount_rec_.discount_type;

         IF (taxable_sales_ = 1) THEN
            booking_ := 2;
         ELSE
            booking_ := 4;
         END IF;

         Do_Str_Event_Acc___(voucher_row_rec_,
                             init_voucher_row_rec_,
                             outstanding_sales_id_,
                             qty_expected_,
                             contract_,
                             customer_no_,
                             user_group_,
                             booking_,
                             base_discount_amount_,
                             tax_code_,
                             voucher_id_,
                             invoice_id_,
                             order_no_,
                             local_control_type_key_rec_);

         sum_discount_ := sum_discount_ + base_discount_amount_;
      END LOOP;

      additional_discount_ := Customer_Order_Inv_Item_API.Get_Additional_Discount(voucher_row_rec_.company, invoice_id_, item_id_); --%
   ELSE
      --no invoice exist, fetch order_discount from customer order line instead.
      order_discount_    := Customer_Order_Line_API.Get_Order_Discount(order_no_, line_no_, rel_no_, line_item_no_);
      price_conv_factor_ := Customer_Order_Line_API.Get_Price_Conv_Factor(order_no_, line_no_, rel_no_, line_item_no_);

      -- Create postings for each line discount record
      FOR co_discount_rec_ IN get_co_line_discounts LOOP
         discount_amount_      := (co_discount_rec_.discount_amount * qty_expected_ * price_conv_factor_);
         --Get the discount_amount in base currency using the currency rate on the order, not todays rate.
         order_date_           := Customer_Order_API.Get_Date_Entered(order_no_);
         customer_order_rec_   := Customer_Order_API.Get(order_no_);
         
         Invoice_Library_API.Get_Currency_Rate_Defaults(dummy_, conv_factor_, curr_rate_, voucher_row_rec_.company, order_currency_code_, order_date_, 'CUSTOMER', NVL(customer_order_rec_.customer_no_pay, customer_order_rec_.customer_no));
         base_discount_amount_ := Customer_Order_Pricing_API.Get_Base_Price_By_Rate(curr_rate_, conv_factor_, discount_amount_);

         base_discount_amount_ := ROUND(base_discount_amount_, currency_rounding_);
         discount_             := co_discount_rec_.discount;

         total_line_discount_  := total_line_discount_ + base_discount_amount_;

         local_control_type_key_rec_.oe_discount_no_   := co_discount_rec_.discount_no;
         local_control_type_key_rec_.oe_discount_type_ := co_discount_rec_.discount_type;

         IF (taxable_sales_ = 1) THEN
            booking_ := 2;
         ELSE
            booking_ := 4;
         END IF;

         Do_Str_Event_Acc___(voucher_row_rec_,
                             init_voucher_row_rec_,
                             outstanding_sales_id_,
                             qty_expected_,
                             contract_,
                             customer_no_,
                             user_group_,
                             booking_,
                             base_discount_amount_,
                             tax_code_,
                             voucher_id_,
                             invoice_id_,
                             order_no_,
                             local_control_type_key_rec_);

         sum_discount_ := sum_discount_ + base_discount_amount_;
      END LOOP;
      additional_discount_ := Customer_Order_Line_API.Get_Additional_Discount(order_no_,line_no_,rel_no_,line_item_no_);
   END IF;

   -- Create postings for order discount

   -- Calculate the discount amount for order_discount in base currency
   order_discount_basis_ := (gross_amount_ - total_line_discount_);
   base_discount_amount_ := order_discount_basis_ - order_discount_basis_ * ((100 - order_discount_)/100);

   -- Calculate the rounded total discount amount.
   base_discount_amount_ := ROUND(base_discount_amount_, currency_rounding_);

   IF (taxable_sales_ = 1) THEN
      booking_ := 5;
   ELSE
      booking_ := 6;
   END IF;

   -- Create posting if order discount != 0
   IF (base_discount_amount_ != 0) THEN
      Do_Str_Event_Acc___(voucher_row_rec_,
                          init_voucher_row_rec_,
                          outstanding_sales_id_,
                          qty_expected_,
                          contract_,
                          customer_no_,
                          user_group_,
                          booking_,
                          base_discount_amount_,
                          tax_code_,
                          voucher_id_,
                          invoice_id_,
                          order_no_,
                          local_control_type_key_rec_);

      sum_discount_ := sum_discount_ + base_discount_amount_;
   END IF;

   --Postings for additional discount
   IF (additional_discount_ != 0) THEN
      IF (taxable_sales_ = 1) THEN
         booking_ := 7;
      ELSE
         booking_ := 8;
      END IF;

      add_discount_amount_ := (gross_amount_ - total_line_discount_ ) * (additional_discount_/100);
      add_discount_amount_ := ROUND(add_discount_amount_, currency_rounding_);

      Do_Str_Event_Acc___(voucher_row_rec_,
                          init_voucher_row_rec_,
                          outstanding_sales_id_,
                          qty_expected_,
                          contract_,
                          customer_no_,
                          user_group_,
                          booking_,
                          add_discount_amount_,
                          tax_code_,
                          voucher_id_,
                          invoice_id_,
                          order_no_,
                          local_control_type_key_rec_);
      sum_discount_ := sum_discount_ + add_discount_amount_;
   END IF;
END Create_Discount_Postings___;

-- Create_Tax_Postings___
--   Creates tax postings for an invoice item or customer order line.
--   Tax_amount fetched is in base currency.
PROCEDURE Create_Tax_Postings___ (
   voucher_row_rec_        IN OUT Voucher_API.VoucherRowRecType,
   init_voucher_row_rec_   IN     Voucher_API.VoucherRowRecType,
   outstanding_sales_id_   IN     NUMBER,
   qty_expected_           IN     NUMBER,
   round_gross_amount_     IN     NUMBER,
   sum_discount_           IN     NUMBER,
   invoice_id_             IN     NUMBER,
   item_id_                IN     NUMBER,
   order_no_               IN     VARCHAR2,
   line_no_                IN     VARCHAR2,
   rel_no_                 IN     VARCHAR2,
   line_item_no_           IN     NUMBER,
   contract_               IN     VARCHAR2,
   customer_no_            IN     VARCHAR2,
   voucher_id_             IN     VARCHAR2,
   user_group_             IN     VARCHAR2,
   control_type_key_rec_   IN     Mpccom_Accounting_API.Control_Type_Key )
IS
   booking_              NUMBER;
   tax_percentage_       NUMBER;
   net_amount_           NUMBER;
   tax_amount_           NUMBER;
   currency_rounding_    NUMBER;
   invoice_version_      NUMBER;
   tax_line_tax_code_    VARCHAR2(20);
   tax_table_            Source_Tax_Item_API.source_tax_table;
   
BEGIN

   booking_           := 10;
   currency_rounding_ := Currency_Code_API.Get_Currency_Rounding(voucher_row_rec_.company, voucher_row_rec_.currency_code);

   IF invoice_id_ IS NOT NULL THEN
      invoice_version_        := Invoice_API.Get_Invoice_Version(voucher_row_rec_.company, invoice_id_);
      
      tax_table_ := Source_Tax_Item_API.Get_Tax_Items(voucher_row_rec_.company, Tax_Source_API.DB_INVOICE, 
                                                      TO_CHAR(invoice_id_), TO_CHAR(item_id_), '*', '*', '*');
      
      FOR i IN 1 .. tax_table_.COUNT LOOP
         IF (tax_table_(i).tax_percentage IS NULL) THEN
            tax_percentage_ := Statutory_Fee_API.Get_Percentage(voucher_row_rec_.company, tax_table_(i).tax_code);
         ELSE
            tax_percentage_ := tax_table_(i).tax_percentage;
         END IF;

         net_amount_ := round_gross_amount_ - sum_discount_;
         tax_amount_ := NVL(tax_percentage_, 0)/100 * net_amount_;
         tax_amount_ := ROUND(tax_amount_, currency_rounding_);

         -- A different tax code may be used if tax lines exist, fetch this.
         tax_line_tax_code_ := tax_table_(i).tax_code;
         
         voucher_row_rec_.mpccom_accounting_id     := outstanding_sales_id_;
         -- M177 is always Credit as of now and so should the Tax Base and Currency Tax Base
         voucher_row_rec_.tax_base_amount          := -1*ABS(net_amount_);
         voucher_row_rec_.currency_tax_base_amount := -1*ABS(net_amount_);
         voucher_row_rec_.party_type               := 'CUSTOMER';
         voucher_row_rec_.reference_version        := invoice_version_;

         
         -- Create postings for each tax line record
         Do_Str_Event_Acc___(voucher_row_rec_,
                             init_voucher_row_rec_,
                             outstanding_sales_id_,
                             qty_expected_,
                             contract_,
                             customer_no_,
                             user_group_,
                             booking_,
                             tax_amount_,        --account_value_
                             tax_line_tax_code_, --tax_code_
                             voucher_id_,
                             invoice_id_,
                             order_no_,
                             control_type_key_rec_);
      END LOOP;
   ELSE
      tax_table_ := Source_Tax_Item_API.Get_Tax_Items(voucher_row_rec_.company, Tax_Source_API.DB_CUSTOMER_ORDER_LINE, 
                                                      order_no_, line_no_, rel_no_, TO_CHAR(line_item_no_), '*');
      -- use this cursor if no invoice exist
      FOR i IN 1 .. tax_table_.COUNT LOOP
         IF (tax_table_(i).tax_percentage IS NULL) THEN
            tax_percentage_ := Statutory_Fee_API.Get_Percentage(voucher_row_rec_.company, tax_table_(i).tax_code);
         ELSE
            tax_percentage_ := tax_table_(i).tax_percentage;
         END IF;

         net_amount_ := round_gross_amount_ - sum_discount_;
         tax_amount_ := NVL(tax_percentage_, 0)/100 * net_amount_;
         tax_amount_ := ROUND(tax_amount_, currency_rounding_);

         tax_line_tax_code_ := tax_table_(i).tax_code;
         

         voucher_row_rec_.mpccom_accounting_id       := outstanding_sales_id_;
         -- M177 is always Credit as of now and so should the Tax Base and Currency Tax Base
         voucher_row_rec_.tax_base_amount            := -1*ABS(net_amount_);
         voucher_row_rec_.currency_tax_base_amount   := -1*ABS(net_amount_);
         voucher_row_rec_.party_type                 := 'CUSTOMER';

         
         Do_Str_Event_Acc___(voucher_row_rec_,
                             init_voucher_row_rec_,
                             outstanding_sales_id_,
                             qty_expected_,
                             contract_,
                             customer_no_,
                             user_group_,
                             booking_,
                             tax_amount_,        --account_value_
                             tax_line_tax_code_, --tax_code_
                             voucher_id_,
                             invoice_id_,
                             order_no_,
                             control_type_key_rec_);
      END LOOP;
   END IF;
END Create_Tax_Postings___;

-- Create_Balance_Posting___
--   Creates posting to balance all postings for the voucher just created.
PROCEDURE Create_Balance_Posting___ (
   voucher_row_rec_      IN OUT Voucher_API.VoucherRowRecType,
   init_voucher_row_rec_ IN     Voucher_API.VoucherRowRecType,
   outstanding_sales_id_ IN     NUMBER,
   qty_expected_         IN     NUMBER,
   invoice_id_           IN     NUMBER,
   order_no_             IN     VARCHAR2,
   contract_             IN     VARCHAR2,
   voucher_id_           IN     VARCHAR2,
   user_group_           IN     VARCHAR2,
   control_type_key_rec_ IN     Mpccom_Accounting_API.Control_Type_Key )
IS
   sum_value_          NUMBER;
   booking_            NUMBER;
   customer_order_rec_ CUSTOMER_ORDER_API.Public_Rec;

   CURSOR get_sum_value IS
      SELECT ABS(SUM(value * (DECODE(debit_credit, 'C', -1, 1))))
      FROM   OUTSTANDING_SALES_ACCTING_TAB
      WHERE  outstanding_sales_id = outstanding_sales_id_;
BEGIN

   OPEN get_sum_value;
   FETCH get_sum_value INTO sum_value_;
   CLOSE get_sum_value;

   booking_ := 9;

   customer_order_rec_ := Customer_Order_API.Get(order_no_);
      
   Do_Str_Event_Acc___(voucher_row_rec_,
                       init_voucher_row_rec_,
                       outstanding_sales_id_,
                       qty_expected_,     --will not be summed
                       contract_,
                       customer_order_rec_.customer_no,
                       user_group_,
                       booking_,
                       sum_value_,        --account_value_
                       NULL,              --tax_code_
                       voucher_id_,
                       invoice_id_,
                       order_no_,
                       control_type_key_rec_);
END Create_Balance_Posting___;


FUNCTION Interim_Voucher_Exist___ (
   company_             IN VARCHAR2,
   accounting_year_     IN NUMBER,
   accounting_period_   IN NUMBER ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   OUTSTANDING_SALES_ACCTING_TAB
      WHERE company = company_
      AND   accounting_year = accounting_year_
      AND   accounting_period = accounting_period_;     
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN(TRUE);
   END IF;
   CLOSE exist_control;
   RETURN(FALSE);
END Interim_Voucher_Exist___;


----------------------------------------------------------------------------
-- Check_No_Previous_Execution___
--    This procedure checks whether another method is "Posted" or "Executing"
--    in parallel in background jobs with the same process.
----------------------------------------------------------------------------
PROCEDURE Check_No_Previous_Execution___ (
   company_        IN VARCHAR2,
   year_           IN NUMBER,
   period_         IN NUMBER,   
   deferred_call_  IN VARCHAR2 )
IS
   msg_            VARCHAR2(32000);
   current_job_id_ NUMBER:=NULL;
   job_id_value_   VARCHAR2(35);
BEGIN   
   -- Get current job_id
   current_job_id_ := Transaction_SYS.Get_Current_Job_Id;

   -- Get current 'Posted' job arguments
   Transaction_SYS.Get_Posted_Job_Arguments(msg_, deferred_call_);

   IF Get_Job_Arguments___(msg_, job_id_value_, company_, year_, period_, current_job_id_) IS NOT NULL THEN
      Error_SYS.Record_General(lu_name_, 'SAMEPROCEXIST: The request cannot be processed as another request to create an interim sales voucher has already been added to the background job :P1 by another user.', TO_CHAR(job_id_value_));
   ELSE
      -- Get current 'Executing' job arguments
      Transaction_SYS.Get_Executing_Job_Arguments(msg_, deferred_call_);
      IF Get_Job_Arguments___(msg_, job_id_value_, company_, year_, period_, current_job_id_) IS NOT NULL THEN
         Error_SYS.Record_General(lu_name_, 'SAMEPROCEXIST: The request cannot be processed as another request to create an interim sales voucher has already been added to the background job :P1 by another user.', TO_CHAR(job_id_value_));
      END IF;
   END IF;  
END Check_No_Previous_Execution___;


----------------------------------------------------------------------------
-- Get_Job_Arguments___
--    This function returns background job ids included in JOB_ARGUMENTS string
--    msg_, which belong to a given process.
----------------------------------------------------------------------------

FUNCTION Get_Job_Arguments___ ( 
   msg_            IN OUT VARCHAR2,
   job_id_value_   IN OUT VARCHAR2,
   company_        IN VARCHAR2,
   year_           IN NUMBER,
   period_         IN NUMBER,   
   current_job_id_ IN NUMBER) RETURN NUMBER
IS
   attrib_value_   VARCHAR2(32000);
   value_          VARCHAR2(2000);   
   name_           VARCHAR2(30);
   job_id_tab_     Message_SYS.Name_Table;
   attrib_tab_     Message_SYS.Line_Table;
   job_company_no_ VARCHAR2(12); 
   job_year_       NUMBER;
   job_period_     NUMBER;
   count_          NUMBER;
   ptr_            NUMBER;
BEGIN   
   Message_SYS.Get_Attributes(msg_, count_, job_id_tab_, attrib_tab_);
   FOR i_ IN 1..count_ LOOP
      job_id_value_   := job_id_tab_(i_);
      attrib_value_   := attrib_tab_(i_);

      ptr_ := NULL;
      -- Loop through the parameter list to check whether order_no exists
      WHILE (Client_SYS.Get_Next_From_Attr(attrib_value_, ptr_, name_, value_)) LOOP
         IF (name_ = 'COMPANY') THEN
            job_company_no_ := value_;
         ELSIF (name_ = 'ACCOUNTING_YEAR') THEN
            job_year_  := value_;
         ELSIF (name_ = 'ACCOUNTING_PERIOD') THEN
            job_period_  := value_;
         END IF;         
      END LOOP;
      
      -- Check to see if another job of this type exists
      IF ((current_job_id_ != job_id_value_) AND (job_company_no_ = company_) AND (job_year_ = year_) AND (job_period_ = period_)) THEN
         -- Return previous Execution
         RETURN  job_id_value_;
      END IF;
   END LOOP;
   RETURN NULL;
END Get_Job_Arguments___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Create_Interim_Voucher__
--   Creates interim sales postings for a specified year and period in past time.
--   Creates one interim voucher for all the postings created. The voucher
--   includes several voucher rows.
PROCEDURE Create_Interim_Voucher__ (
   company_             IN VARCHAR2,
   accounting_year_     IN NUMBER,
   accounting_period_   IN NUMBER )
IS
   current_year_        NUMBER;
   current_period_      NUMBER;
   period_              NUMBER;
   year_                NUMBER;
   to_date_             DATE;
   attr_                VARCHAR2(2000);
   description_         VARCHAR2(2000);   
   
BEGIN
   -- IF no period is given use previous period
   IF (accounting_year_ IS NULL OR accounting_period_ IS NULL) THEN
      Accounting_Period_API.Get_Accounting_Year(current_year_, current_period_, company_, SYSDATE);
      Accounting_Period_API.Get_Previous_Allowed_Period(period_, year_, company_, current_period_, current_year_);
   ELSE
      period_ := accounting_period_;
      year_ := accounting_year_;

      Accounting_Period_API.Exist(company_, year_, period_);

      IF (Accounting_Period_API.Is_Period_Allowed(company_, period_, year_) = 'FALSE') THEN
         Error_SYS.Record_General(lu_name_, 'ALLOWEDPERIOD: Interim Sales Voucher can only be created on ordinary periods.');
      END IF;
   END IF;

   to_date_ := Accounting_Period_API.Get_Date_Until(company_, year_, period_);

   -- Check that the period is in the past
   IF (to_date_ >= TRUNC(SYSDATE)) THEN
      Error_SYS.Record_General(lu_name_, 'ONGOING: Interim Sales Voucher cannot be created for future or ongoing periods.');
   END IF;

   -- Check that the period has not been run before
   IF (Interim_Voucher_Exist___(company_, year_, period_)) THEN
      Error_SYS.Record_General(lu_name_, 'ALLREADYCREATED: Interim Sales Voucher has already been created for this period.');
   END IF;

   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('COMPANY', company_, attr_);
   Client_SYS.Add_To_Attr('ACCOUNTING_YEAR', year_, attr_);
   Client_SYS.Add_To_Attr('ACCOUNTING_PERIOD', period_, attr_);
   Client_SYS.Add_To_Attr('TO_DATE', to_date_, attr_);

   IF (Transaction_Sys.Is_Session_Deferred()) THEN
      Create_Interim_Voucher_Attr__(attr_);
   ELSE
      description_ := Language_SYS.Translate_Constant(lu_name_,'CREATEINTERIM: Create Interim Sales Voucher for company :P1 year :P2 period :P3 ', NULL, company_, year_, period_);
      Transaction_SYS.Deferred_Call('Outstanding_Sales_Accting_API.Create_Interim_Voucher_Attr__', attr_, description_);
   END IF;
END Create_Interim_Voucher__;


-- Create_Interim_Voucher_Attr__
--   Creates interim sales postings for a specified year and period in past
--   time. Creates one interim voucher for all the postings created.
--   The voucher includes several voucher rows.
PROCEDURE Create_Interim_Voucher_Attr__ (
   attr_ IN VARCHAR2 )
IS
   ptr_                 NUMBER;
   name_                VARCHAR2(30);
   value_               VARCHAR2(2000);
   company_             VARCHAR2(20);
   accounting_year_     NUMBER;
   accounting_period_   NUMBER;
   to_date_             DATE;   
BEGIN
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'COMPANY') THEN
         company_ := value_;
      ELSIF (name_ = 'ACCOUNTING_YEAR') THEN
         accounting_year_ := Client_SYS.Attr_Value_To_Number(value_);
      ELSIF (name_ = 'ACCOUNTING_PERIOD') THEN
         accounting_period_ := Client_SYS.Attr_Value_To_Number(value_);
      ELSIF (name_ = 'TO_DATE') THEN
         to_date_ := Client_SYS.Attr_Value_To_Date(value_);
      ELSE
         Error_SYS.Item_Not_Exist(lu_name_, name_, value_);
      END IF;
   END LOOP;

   Create_Interim_Voucher___(company_, accounting_year_, accounting_period_, to_date_);
END Create_Interim_Voucher_Attr__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Interim_Voucher_Exist
--   Used to check whether the interim sales voucher is created for the given
--   invoice id according to the accounting period of the invoice date
PROCEDURE Interim_Voucher_Exist (
   accounting_year_     OUT NUMBER,
   accounting_period_   OUT NUMBER,
   voucher_exist_       OUT BOOLEAN,
   invoice_id_          IN  NUMBER,
   company_             IN  VARCHAR2,
   invoice_date_        IN  DATE )
IS
   outstanding_sales_id_    NUMBER;   

   CURSOR exist_control IS
      SELECT accounting_year, accounting_period
      FROM   OUTSTANDING_SALES_ACCTING_TAB
      WHERE accounting_year >= accounting_year_
      AND   accounting_period >= accounting_period_
      AND   company = company_
      AND   outstanding_sales_id = outstanding_sales_id_;
BEGIN
   outstanding_sales_id_ := Outstanding_Sales_API.Get_Min_Outstanding_Sales_Id(company_, invoice_id_);
   Accounting_Period_API.Get_Accounting_Year(accounting_year_, accounting_period_, company_, invoice_date_);   
   OPEN exist_control;
   FETCH exist_control INTO accounting_year_, accounting_period_;
   IF (exist_control%FOUND) THEN      
      voucher_exist_ := TRUE;
   ELSE
      voucher_exist_ := FALSE;
   END IF;
   CLOSE exist_control;   
END Interim_Voucher_Exist;



