-----------------------------------------------------------------------------
--
--  Logical unit: OrderSelfBillingManager
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  160721  NWeelk   FINHR-1229, Re-structured methods Get_Net_Curr_Amount, Get_Gross_Curr_Amount and Get_Customer_Part_Price 
--  160721           to get values directly from customer order line and modified Connect_Matched_Line_To_Sbi___, Save_Manually_Matched_Lines and 
--  160721           Add_Matched_Lines to receive cust_gross_curr_amount_ and cust_tax_curr_amount_ from the client.
--  150826  KiSalk   Bug 124068, Set Qty_Confirmeddiff of Customer order line in Connect_Matched_Line_To_Sbi___, so that customer order line get invoiced when SB Item invoice created..
--  150819  PrYaLK   Bug 121587, Modified Connect_Matched_Line_To_Sbi___() by adding cust_part_invert_conv_fact in calculating cust_unit_sales_qty_temp_.
--  150819           Modified Get_Customer_Part_Price() by adding cust_part_invert_conv_fact in calculating customer_part_price_.
--  150819           Modified Get_Customer_Sales_Price() by adding cust_part_invert_conv_fact in calculating customer_sales_price_.
--  150526  IsSalk   KES-510, Modified cursors with Customer_Order_Delivery_TAB to filter out cancelled CO deliver lines.
--  150714  HimRlk   Bug 119098, Added new method Save_Manually_Matched_Lines(). Deprecated Save_Manually_Matched_Line().
--  140812  SlKapl   FIPR19 Multiple tax handling in CO and PO flows - replaced Customer_Order_Line_API.Get_Total_Tax_Amount by Customer_Order_Line_API.Get_Total_Tax_Amount_Curr
--  140704  SudJlk   Bug 117506, Modified Save_Manually_Matched_Line to pass qty_edited_flag correctly to Connect_Matched_Line_To_Sbi___, correctly set the quantities
--  140704           when the quantity matched is less than the total quantity to match.
--  140306  AyAmlk   Bug 115485, Added a new parameter qty_edited_flag_ to Connect_Matched_Line_To_Sbi___(). Modified Add_Matched_Lines(),
--  140306           Save_Manually_Matched_Line() and Connect_Matched_Line_To_Sbi___() so that the customer_qty and cust_unit_sales_qty values will be fetched
--  140306           from sever if it is not been modified by the client to avoid incorrect calculations due to precision.
--  140307  HimRlk   Merged Bug 110133-PIV, Modified method Get_Net_Curr_Amount, by changing Calculation logic of line discount amount 
--  140307           to be consistent with discount postings when price including tax is not specified.
--  130730  RuLiLk   Bug 110133, Modified method Get_Net_Curr_Amount, by changing Calculation logic of line discount amount to be consistent with discount postings.
--  130705  GayDLK   Bug 110953, Modified Add_Matched_Lines() by increasing the length of rec_attr_ to 32000 characters. 
--  120412  AyAmlk   Bug 100608, Increased the column length of delivery_terms to 5 in views UNMATCHED_SBI_DELIVERIES, UNMATCHED_SBI_DELIVERIES_UIV
--  120412           and SBI_DELIVERY_NOT_INVOICED.
--  120313  MoIflk   Bug 99430, Modified view UNMATCHED_SBI_DELIVERIES and procedure Connect_Matched_Line_To_Sbi___ to include inverted_conv_factor.
--  111121  ChJalk   Added user allowed company filter to the view UNMATCHED_SBI_DELIVERIES. 
--  110303  PAWELK   EANE-3744, Created new view SBI_CO_LINES_DEVIATIONS_UIV.
--  110127  NeKolk   EANE-3744  added where clause to the View SBI_CO_LINES_DEVIATIONS,UNMATCHED_SBI_DELIVERIES.
--  100903  Swralk   SAP-SUCKER DF-77, Modified function Get_Customer_Sales_Price to use correct currency rounding.
--  100820  Swralk   SAP-SUCKER DF-77, Modified function Connect_Matched_Line_To_Sbi___ to use correct rounding.
--  100720  Swralk   SAP-SUCKER DF-40, Modified Get_Net_Curr_Amount and Get_Tax_Curr_Amount functions to use correct rounding.
--  100520  KRPELK   Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  091001  MaMalk   Modified Get_Customer_Quantity___ to remove unused code.
--  ------------------------- 14.0.0 -------------------------------------------
--  081104  SaJjlk   Bug 78142, Removed unused variable company_ in method Get_Customer_Part_Price.
--  081030  SaJjlk   Bug 78142, Modified method Get_Customer_Part_Price to remove the rounding.
--  080130  NaLrlk   Bug 70005, Added del_terms_location to lov view UNMATCHED_SBI_DELIVERIES.
--  080102  MaMalk   Bug 65955, Modified the where condition of view SBI_CO_LINES_DEVIATIONS.
--  080102           Modified the method Get_Customer_Part_Price and Get_Customer_Sales_Price to consider the customer and price conversion factors.
--  080102           Modified Connect_Matched_Line_To_Sbi___, Save_Manually_Matched_Line and Add_Matched_Lines to replace cust_part_price with cust_unit_part_price. 
--  080102           Modified Price_Deviation_Exist to call the method in Self_Billing_Item_API.
--  070221  WaJalk   Bug 61985, Modified view UNMATCHED_SBI_DELIVERIES to increase length of column customer_po_no from 15 to 50, in view comments.
--  070119  KaDilk   Replaced delivery_terms_desc with Method calls in views UNMATCHED_SBI_DELIVERIES,
--  070119           and SBI_DELIVERY_NOT_INVOICED.
--  060601  MiErlk   Enlarge Identity - Changed view comments - Description.
--  060522  MaRalk   Bug 57640, Modified the view UNMATCHED_SBI_DELIVERIES. 
--  060517  MiErlk   Enlarge Identity - Changed view comment
--  060516  MiErlk   Enlarge Identity - Changed view comment
--  060419  NaLrlk   Enlarge Customer - Changed variable definitions.
--  060410  IsWilk   Enlarge Identity - Changed view comments of customer_no.
--  ------------------------- 13.4.0 -------------------------------------------
--  060207  IsAnlk   Modified UNMATCHED_SBI_DELIVERIES to get wanted_delivery_date from Customer_order_line_tab.
--  051024  IsWilk   Removed the delivery_type column from UNMATCHED_SBI_DELIVERIES, SBI_DELIVERY_NOT_INVOICED.
--  050921  IsAnlk   Added parameter Currency_code to Check_Matched_Line_For_Delnote, Check_Matched_Line_For_Delnote, Check_Matched_Line_For_Delnote
--                   Get_Matched_Info_For_Delnote, Get_Matched_Info_For_Cpo, Get_Matched_Info_For_Ref_Id.   
--  050921  NaLrlk   Removed unused variables.
--  050905  UsRalk   Modified VIEW_SBI to exclude package components.
--  050826  JaBalk   Added incorrect_del_confirmation to where caluse of VIEW_SBI.
--  050821  IsAnlk   Modified Get_Customer_Part_Price method by adding currency rounding.
--  050817  JaBalk   When the match type is 'Auto Match, Create Invoice'/'Auto Match, Create and Post Invoice'
--  050817           commit the changes until the message is matched if no errors in Automatic_Sbi_Process.
--  050816  IsAnlk   Modified Connect_Matched_Line_To_Sbi___ to calulate amounts according to cust_part_price.
--  050816  JaBalk   Changed the call to Get_Sbi_No_By_Msg_Id to Get_Preliminary_Sbi_By_Msg.
--  050803  IsAnlk   Modified matched_gross_amount,matched_tax_amount as gross_amount,tax_amount.
--  050729  IsAnlk   Changed vat_curr_amount as tax_curr_amount and changed method name Get_Vat_Curr_Amount as Get_Tax_Curr_Amount.
--  050729  IsAnlk   Modofied Get_Net_Curr_Amount to consider additional_discount when calculating net_amount.
--  050728  IsAnlk   Added message_id and message_row as parameters to Connect_Matched_Line_To_Sbi___.
--  050726  IsAnlk   Modified Check_Matched_Line_For_Ref and Check_Matched_Line_For_Cpo.
--  050725  UsRalk   Renamed the parameter match_type_ to match_type_db in Connect_Matched_Line_To_Sbi___.
--  050722  JaBalk   Changed the reason_ to deviation_reason_ and match_type_db to match_type_.
--  050720  UsRalk   Modified Save_Manually_Matched_Line to clear any previous error messages before doing processing.
--  050719  NuFilk   Modified method Get_Vat_Curr_Amount.
--  050719  IsAnlk   Modified the methods Check_Matched_Line_For_Cpo, Check_Matched_Line_For_Delnote,
--                   Check_Matched_Line_For_Ref to handle the count variable.
--  050719  RaKalk   Modified Save_Manually_Matched_Line to give the additional cost info message when additional cost not null and not zero.
--  050718  JaBalk   Changed the methods Check_Matched_Line_For_Cpo, Check_Matched_Line_For_Delnote,
--                   Check_Matched_Line_For_Ref to handle the count variable.
--  050718  RaKalk   Added info_ out parameter to method Save_Manually_Matched_Line. Modified Save_Manually_Matched_Line
--  050718           give a info message when the incoming message line has additional costs.
--  050715  UsRalk   Renamed Save_Matched_Lines to Add_Matched_Lines and Save_Matched_Line to Save_Manually_Matched_Line.
--  050714  UsRalk   Added new method Set_Sbi_Record_Values___.
--  050714  IsAnlk   Made private method Automatic_Sbi_Process__ as public.
--  050713  NaWalk   Added parameter reason_ to the method Connect_Matched_Line_To_Sbi.
--  050713  IsAnlk   Changed functions to procedures and renamed Multiple_Matches_Found__ as Check_Matched_Line_For_Cpo, Check_Matched_Line_For_Delnote,
--                   Check_Matched_Line_For_Ref and made public Get_Matched_Info_For_Cpo, Get_Matched_Info_For_Delnote, Get_Matched_Info_For_Ref_Id
--  050712  RaKalk   Modified Automatic_Sbi_Process__ and Save_matched_Line method to reflect the changes made in SELF_BILLING_HEADER_TAB
--  050712  UsRalk   Modified Save_Matched_Line to send matched_gross_amount, matched_net_amount and matched_tax_amount to Create_Header__.
--  050711  UsRalk   Moved Get_Next_Sbi_Line_No___ from SelfBillingItem.
--  050711  JaBalk   Chnaged the functions to procedures and renamed it from Get_Matched_Rec_For_Cpo__ to
--  050711           Get_Matched_Info_For_Cpo__, Get_Matched_Rec_For_Ref_Id__ to Get_Matched_Info_For_Ref_Id__
--  050711           and Get_Matched_Rec_For_Del_Note__ to Get_Matched_Info_For_Delnote__.
--  050708  UsRalk   Added methods Connect_Matched_Line_To_Sbi___ and Save_Matched_Line.
--  050707  NuFilk   Modified Automatic_Sbi_Process__ changed the call Make_Self_Billing_Invoice to Create_Invoice.
--  050707           Removed Get_Customer_Vat_Curr_Amount, Get_Customer_Gross_Curr_Amount and Calculate_Tax_Lines.
--  050707  IsAnlk   Modified Quantity_Deviation_Exist to compare qty_to_invoice and qty_invoiced.
--  050706  IsAnlk   Modified confirmed_sbi_qty_ calculation to sales unit of measure.
--  050706  JaJalk   Added the methods Multiple_Matches_Found__, Multiple_Matches_Found_Ref__, Get_Matched_Rec_For_Cpo__,
--  050706           Get_Matched_Rec_For_Ref_Id__ and  Get_Matched_Rec_For_Del_Note__ modified the matching procedure.
--  050705  IsAnlk   Removed condition provisional_price ='FALSE' from view UNMATCHED_SBI_DELIVERIES.
--  050701  JaBalk   Removed method Do_Matching__ and renamed Is_Automatic_Match__ to Automatic_Sbi_Process__
--  050629  RaKalk   Moved Create_Header,Update_Customer_Values methods from ExtIncSbiUtil and renamed to
--  050629           Create_Header___ and Update_Customer_Values___. Moved method Do_Matching__ and Is_Automatic_Match__ from ExtIncSbiUtil.
--  050628  JaBalk   Changed the VIEW_SBI by renaming discount to included_discount and order_discount to included_total_order_discount
--  050628           Added date_confirmed to VIEW_SBI.Added ty_to_invoice to VIEW_DEVIATE.
--  050606  IsAnlk   Added condition provisional_price = 'FALSE' to view UNMATCHED_SBI_DELIVERIES.
--  050530  MaEelk   Added condition col.blocked_for_invoicing = 'FALSE' to the WHERE clause
--  050530           in UNMATCHED_SBI_DELIVERIES.
--  050407  IsAnlk   Modified Get_Customer_Quantity___ to calculate customer_qty_ correctly.
--  050331  IsAnlk   Changed calculation of customer_qty in view UNMATCHED_SBI_DELIVERIES.
--  050107  GeKalk   Changed where clause of UNMATCHED_SBI_DELIVERIES to fetch the shipment_id from customer_order_delivery_tab.
--  041220  IsAnlk   Changed CREATE_SELF_BILLING as UNMATCHED_SBI_DELIVERIES.
--  041217  GeKalk   Modified where clause of shipment data retrieval in CREATE_SELF_BILLING.
--  041214  GeKalk   Added public methods Quantity_Deviation_Exist and Price_Deviation_Exist and view SBI_CO_LINES_DEVIATIONS.
--  041213  IsAnlk   Modified last parameter as deliv_no_ in Get_Customer_Sales_Price, Get_Customer_Net_Curr_Amount
--                   Get_Customer_Vat_Curr_Amount, Get_Customer_Gross_Curr_Amount.
--  041210  SaJjlk   Added view CREATE_SELF_BILLING.
--  041210  YoMiJp   The column deliv_no was added to the View "SBI_DELIVERY_NOT_INVOICED"
--  041209  SaJjlk   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Get_Customer_Quantity___ (
   deliv_no_     IN VARCHAR2 ) RETURN NUMBER
IS
   deliv_rec_    CUSTOMER_ORDER_DELIVERY_API.Public_Rec;
   customer_qty_ NUMBER;

BEGIN
   deliv_rec_    := Customer_Order_Delivery_API.Get(deliv_no_);
   customer_qty_ := (deliv_rec_.qty_to_invoice + deliv_rec_.qty_invoiced) -
                     deliv_rec_.confirmed_sbi_qty;
   RETURN customer_qty_;
END Get_Customer_Quantity___;


PROCEDURE Connect_Matched_Line_To_Sbi___ (
   sbi_no_                 IN VARCHAR2,
   order_no_               IN VARCHAR2,
   line_no_                IN VARCHAR2,
   rel_no_                 IN VARCHAR2,
   line_item_no_           IN NUMBER,
   deliv_no_               IN NUMBER,
   customer_qty_           IN NUMBER,
   cust_unit_part_price_   IN NUMBER,
   cust_unit_sales_qty_    IN NUMBER,
   cust_net_curr_amount_   IN NUMBER,
   cust_gross_curr_amount_ IN NUMBER,
   cust_tax_curr_amount_   IN NUMBER,
   net_curr_amount_        IN NUMBER,
   tax_curr_amount_        IN NUMBER,
   gross_curr_amount_      IN NUMBER,
   close_type_db_          IN VARCHAR2,
   match_type_db_          IN VARCHAR2,
   message_id_             IN NUMBER,
   message_row_            IN NUMBER,
   deviation_reason_       IN VARCHAR2,
   qty_edited_flag_        IN VARCHAR2 )
IS
   viewrec_                      UNMATCHED_SBI_DELIVERIES%ROWTYPE;
   sbi_item_rec_                 SELF_BILLING_ITEM_TAB%ROWTYPE;
   sbi_line_no_                  NUMBER;
   sbi_header_rec_               Self_Billing_Header_API.Public_Rec;
   cust_order_del_rec_           Customer_Order_Delivery_API.Public_Rec;
   today_                        DATE := SYSDATE;
   confirmed_sbi_qty_            NUMBER;
   qty_to_invoice_               NUMBER;
   matched_qty_                  NUMBER;
   qty_to_match_                 NUMBER;
   close_type_db_local_          VARCHAR2(20) := close_type_db_;
   net_curr_amount_local_        NUMBER       := 0;
   tax_curr_amount_local_        NUMBER       := 0;
   gross_curr_amount_local_      NUMBER       := 0;
   curr_rounding_                NUMBER;
   customer_qty_temp_            NUMBER;
   cust_unit_sales_qty_temp_     NUMBER;
   qty_confirmeddiff_            NUMBER;
   
   CURSOR get_sbiview_line IS
      SELECT *
        FROM unmatched_sbi_deliveries
       WHERE order_no     = order_no_
         AND line_no      = line_no_
         AND rel_no       = rel_no_
         AND line_item_no = line_item_no_
         AND deliv_no     = deliv_no_;
BEGIN

   sbi_header_rec_ := Self_Billing_Header_API.Get(sbi_no_);

   OPEN  get_sbiview_line;
   FETCH get_sbiview_line INTO viewrec_;
   CLOSE get_sbiview_line;

   IF (NVL(qty_edited_flag_, 'FALSE') = 'FALSE') THEN
      customer_qty_temp_ := viewrec_.customer_qty;
      cust_unit_sales_qty_temp_ := customer_qty_temp_ / NVL(viewrec_.customer_part_conv_factor, 1) * NVL(viewrec_.cust_part_invert_conv_fact, 1);
   ELSE
      customer_qty_temp_ := customer_qty_;
      cust_unit_sales_qty_temp_ := cust_unit_sales_qty_;
   END IF;
   
   curr_rounding_   := Currency_Code_API.Get_Currency_Rounding(viewrec_.company, viewrec_.currency_code);

   net_curr_amount_local_   :=  NVL((cust_net_curr_amount_   + sbi_header_rec_.matched_net_amount), 0);
   tax_curr_amount_local_   :=  NVL((NVL(cust_tax_curr_amount_, tax_curr_amount_) + sbi_header_rec_.tax_amount), 0);
   gross_curr_amount_local_ :=  NVL((NVL(cust_gross_curr_amount_, gross_curr_amount_) + sbi_header_rec_.gross_amount), 0);

   Self_Billing_Header_API.Update_Totals (
      sbi_no_               => sbi_no_,
      gross_amount_         => gross_curr_amount_local_,
      matched_net_amount_   => net_curr_amount_local_,
      tax_amount_           => tax_curr_amount_local_ );

   sbi_line_no_         :=  Get_Next_Sbi_Line_No___(sbi_no_);
   cust_order_del_rec_  :=  Customer_Order_Delivery_API.Get(viewrec_.deliv_no);
   confirmed_sbi_qty_   :=  cust_order_del_rec_.confirmed_sbi_qty;
   qty_to_invoice_      :=  cust_order_del_rec_.qty_to_invoice;

   IF (confirmed_sbi_qty_ + customer_qty_temp_ >= qty_to_invoice_) THEN
      close_type_db_local_    := 'SETCLOSE';
   END IF;

   IF (close_type_db_local_ = 'SETCLOSE') THEN
      qty_confirmeddiff_      := (confirmed_sbi_qty_ + customer_qty_temp_ - qty_to_invoice_);
      matched_qty_         := qty_to_invoice_ - confirmed_sbi_qty_;
      confirmed_sbi_qty_   := qty_to_invoice_;
   ELSE
      matched_qty_         := customer_qty_temp_;
      confirmed_sbi_qty_   := confirmed_sbi_qty_ + customer_qty_temp_ ;
   END IF;

   Customer_Order_Delivery_API.Modify_Confirmed_Sbi_Qty(viewrec_.deliv_no, confirmed_sbi_qty_);
   qty_to_match_           := (qty_to_invoice_ - confirmed_sbi_qty_);


   -- Initialize the SBI_ITEM_REC_
   sbi_item_rec_.sbi_no               := sbi_no_;
   sbi_item_rec_.sbi_line_no          := sbi_line_no_;
   sbi_item_rec_.order_no             := order_no_;
   sbi_item_rec_.line_no              := line_no_;
   sbi_item_rec_.rel_no               := rel_no_;
   sbi_item_rec_.line_item_no         := line_item_no_;
   sbi_item_rec_.deliv_no             := viewrec_.deliv_no;
   sbi_item_rec_.customer_qty         := customer_qty_temp_;
   sbi_item_rec_.cust_unit_part_price := cust_unit_part_price_;
   sbi_item_rec_.cust_unit_sales_qty  := cust_unit_sales_qty_temp_;
   sbi_item_rec_.cust_net_curr_amount := cust_net_curr_amount_;
   sbi_item_rec_.net_curr_amount      := net_curr_amount_;
   sbi_item_rec_.tax_curr_amount      := tax_curr_amount_;
   sbi_item_rec_.gross_curr_amount    := gross_curr_amount_;
   sbi_item_rec_.delnote_no           := viewrec_.delnote_no;
   sbi_item_rec_.catalog_no           := viewrec_.catalog_no;
   sbi_item_rec_.sales_unit_meas      := viewrec_.sales_unit_meas;
   sbi_item_rec_.buy_qty_due          := viewrec_.buy_qty_due;
   sbi_item_rec_.customer_part_no     := viewrec_.customer_part_no;
   sbi_item_rec_.customer_no          := viewrec_.customer_no;
   sbi_item_rec_.contract             := viewrec_.contract;
   sbi_item_rec_.consignment_stock    := viewrec_.consignment_stock;
   sbi_item_rec_.part_price           := viewrec_.part_price;
   sbi_item_rec_.price_source         := viewrec_.price_source;
   sbi_item_rec_.discount             := viewrec_.included_discount;
   sbi_item_rec_.discount_amount      := viewrec_.included_total_order_discount;
   sbi_item_rec_.currency_code        := viewrec_.currency_code;
   sbi_item_rec_.pay_term_id          := viewrec_.pay_term_id;
   sbi_item_rec_.order_id             := viewrec_.order_id;
   sbi_item_rec_.wanted_delivery_date := viewrec_.wanted_delivery_date;
   sbi_item_rec_.date_delivered       := viewrec_.date_delivered;
   sbi_item_rec_.line_state           := viewrec_.state;
   sbi_item_rec_.qty_to_match         := qty_to_match_;
   sbi_item_rec_.matched_qty          := matched_qty_;
   sbi_item_rec_.matched_date         := today_;
   sbi_item_rec_.match_type           := match_type_db_;
   sbi_item_rec_.conv_factor          := viewrec_.conv_factor / viewrec_.inverted_conv_factor;
   sbi_item_rec_.price_conv_factor    := viewrec_.price_conv_factor;
   sbi_item_rec_.fee_code             := viewrec_.fee_code;
   sbi_item_rec_.reason               := deviation_reason_;

   IF match_type_db_ = 'MANUAL MATCH' THEN
      sbi_item_rec_.message_id        := message_id_;
      sbi_item_rec_.message_row       := message_row_ ;
   END IF;

   Self_Billing_Item_API.New_Item__(sbi_item_rec_);
   IF qty_confirmeddiff_ IS NOT NULL THEN
      Customer_Order_API.Set_Line_Qty_Confirmeddiff(order_no_, 
                                                    line_no_,
                                                    rel_no_,
                                                    line_item_no_,
                                                    Customer_Order_Line_API.Get_Qty_Confirmeddiff(order_no_, line_no_, rel_no_, line_item_no_) + qty_confirmeddiff_);
   END IF;
END Connect_Matched_Line_To_Sbi___;


FUNCTION Get_Next_Sbi_Line_No___ (
   sbi_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   sbi_line_no_ NUMBER;
   CURSOR get_next_line IS
      SELECT MAX(sbi_line_no)
        FROM self_billing_item_tab
       WHERE sbi_no = sbi_no_;
BEGIN

   OPEN  get_next_line ;
   FETCH get_next_line INTO sbi_line_no_;
   CLOSE get_next_line;

   RETURN NVL(sbi_line_no_ + 1, 1);
END Get_Next_Sbi_Line_No___;


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


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Net_Curr_Amount
--   This function returns the net currency amount.
@UncheckedAccess
FUNCTION Get_Net_Curr_Amount (
   order_no_ IN VARCHAR2,
   line_no_       IN VARCHAR2,
   rel_no_        IN VARCHAR2,
   line_item_no_  IN NUMBER ) RETURN NUMBER
IS
   net_curr_amount_  NUMBER;
BEGIN
   net_curr_amount_ := Customer_Order_Line_API.Get_Sale_Price_Total(order_no_,
                                                                    line_no_,
                                                                    rel_no_,
                                                                    line_item_no_);

   RETURN net_curr_amount_;
END Get_Net_Curr_Amount;



-- Get_Tax_Curr_Amount
--   This function returns the tax currency amount.
@UncheckedAccess
FUNCTION Get_Tax_Curr_Amount (
   order_no_      IN VARCHAR2,
   line_no_       IN VARCHAR2,
   rel_no_        IN VARCHAR2,
   line_item_no_  IN NUMBER ) RETURN NUMBER
IS
   tax_curr_amount_  NUMBER;
BEGIN
   tax_curr_amount_ := Customer_Order_Line_API.Get_Total_Tax_Amount_Curr(order_no_,
                                                                         line_no_,
                                                                         rel_no_,
                                                                         line_item_no_);
   RETURN tax_curr_amount_;
END Get_Tax_Curr_Amount;



-- Get_Gross_Curr_Amount
--   This function returns the gross currency amount.
@UncheckedAccess
FUNCTION Get_Gross_Curr_Amount (
   order_no_      IN VARCHAR2,
   line_no_       IN VARCHAR2,
   rel_no_        IN VARCHAR2,
   line_item_no_  IN NUMBER ) RETURN NUMBER
IS
   gross_curr_amount_ NUMBER;
BEGIN
   gross_curr_amount_ := Customer_Order_Line_API.Get_Sale_Price_Incl_Tax_Total(order_no_,
                                                                               line_no_,
                                                                               rel_no_,
                                                                               line_item_no_); 
   RETURN gross_curr_amount_;
END Get_Gross_Curr_Amount;



-- Get_Customer_Part_Price
--   This function returns the customer part price.
@UncheckedAccess
FUNCTION Get_Customer_Part_Price (
   order_no_      IN VARCHAR2,
   line_no_       IN VARCHAR2,
   rel_no_        IN VARCHAR2,
   line_item_no_  IN NUMBER ) RETURN NUMBER
IS
   order_line_          Customer_Order_Line_API.Public_Rec;
   sales_price_total_   NUMBER;
   customer_part_price_ NUMBER;
   use_price_incl_tax_  VARCHAR2(5);
BEGIN

   order_line_         := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);
   use_price_incl_tax_ := Customer_Order_API.Get_Use_Price_Incl_Tax_Db(order_no_);
   IF use_price_incl_tax_ = 'FALSE' THEN
      sales_price_total_  := Get_Net_Curr_Amount(order_no_,
                                                 line_no_,
                                                 rel_no_,
                                                 line_item_no_);
   ELSE
      sales_price_total_  := Get_Gross_Curr_Amount(order_no_,
                                                   line_no_,
                                                   rel_no_,
                                                   line_item_no_);
   END IF;
   customer_part_price_ := ((sales_price_total_/order_line_.buy_qty_due) * (NVL(order_line_.customer_part_conv_factor, 1))) / (NVL(order_line_.cust_part_invert_conv_fact, 1));

   RETURN customer_part_price_;

END Get_Customer_Part_Price;



-- Get_Customer_Sales_Price
--   This function returns the customer sales price.
@UncheckedAccess
FUNCTION Get_Customer_Sales_Price (
   order_no_      IN VARCHAR2,
   line_no_       IN VARCHAR2,
   rel_no_        IN VARCHAR2,
   line_item_no_  IN NUMBER,
   deliv_no_      IN NUMBER ) RETURN NUMBER
IS
   order_line_             Customer_Order_Line_API.Public_Rec;
   company_                VARCHAR2(20);
   customer_part_price_    NUMBER;   
   customer_sales_price_   NUMBER;
   curr_rounding_          NUMBER;
   customer_qty_           NUMBER;

BEGIN
   order_line_ := Customer_Order_Line_API.Get(order_no_,
                                line_no_,
                                rel_no_,
                                line_item_no_);
   company_    := Site_API.Get_Company(order_line_.contract);
   curr_rounding_ := Customer_Order_API.Get_Order_Currency_Rounding(order_no_);

   customer_part_price_    := Get_Customer_Part_Price(order_no_,
                                                      line_no_,
                                                      rel_no_,
                                                      line_item_no_);

   customer_qty_           := Get_Customer_Quantity___(deliv_no_);
   customer_sales_price_   := customer_part_price_ * (customer_qty_/NVL(order_line_.customer_part_conv_factor, 1) * NVL(order_line_.cust_part_invert_conv_fact, 1));
   customer_sales_price_   := ROUND(customer_sales_price_,curr_rounding_);

   RETURN customer_sales_price_;
END Get_Customer_Sales_Price;



-- Get_Customer_Net_Curr_Amount
--   This function returns the customer net currency amount
@UncheckedAccess
FUNCTION Get_Customer_Net_Curr_Amount (
   order_no_      IN VARCHAR2,
   line_no_       IN VARCHAR2,
   rel_no_        IN VARCHAR2,
   line_item_no_  IN NUMBER,
   deliv_no_      IN NUMBER ) RETURN NUMBER
IS
BEGIN
   RETURN Get_Customer_Sales_Price(order_no_,
                                   line_no_,
                                   rel_no_,
                                   line_item_no_,
                                   deliv_no_);

END Get_Customer_Net_Curr_Amount;



-- Price_Deviation_Exist
--   Check whether the price entered by the customer when creating the self
--   billing invoice is differ to the price of the part.
@UncheckedAccess
FUNCTION Price_Deviation_Exist (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN VARCHAR2
IS
   price_deviation_exist_ VARCHAR2(5):= 'FALSE';
   
   CURSOR get_price_details IS
      SELECT *
        FROM self_billing_item_tab
       WHERE order_no     = order_no_
         AND line_no      = line_no_
         AND rel_no       = rel_no_
         AND line_item_no = line_item_no_;
BEGIN
   FOR part_rec_ IN get_price_details LOOP
      price_deviation_exist_ := Self_Billing_Item_API.Price_Deviation_Exist(part_rec_);  
   END LOOP;

   RETURN price_deviation_exist_;
END Price_Deviation_Exist;



-- Quantity_Deviation_Exist
--   Check whether the quantity invoiced by the customer when creating the self
--   billing invoices for the order line is differ to the quantity shipped of the line.
@UncheckedAccess
FUNCTION Quantity_Deviation_Exist (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN VARCHAR2
IS
   quantity_deviation_exist_ VARCHAR2(5):= 'FALSE';

   CURSOR get_quantity_details IS
      SELECT SUM(qty_to_invoice), SUM(qty_invoiced)
        FROM customer_order_delivery_tab
       WHERE order_no     = order_no_
         AND line_no      = line_no_
         AND rel_no       = rel_no_
         AND line_item_no = line_item_no_
         AND cancelled_delivery = 'FALSE';

   qty_to_invoice_ NUMBER;
   qty_invoiced_   NUMBER;

BEGIN
   OPEN get_quantity_details;
   FETCH get_quantity_details INTO qty_to_invoice_, qty_invoiced_;
   CLOSE get_quantity_details;

   IF (qty_to_invoice_ - qty_invoiced_) != 0 THEN
      quantity_deviation_exist_ := 'TRUE';
   END IF;

   RETURN quantity_deviation_exist_;
END Quantity_Deviation_Exist;



-- Automatic_Sbi_Process
--   Check whether the automatic matching is available or not.
PROCEDURE Automatic_Sbi_Process (
   message_id_ IN NUMBER )
IS
   attr_            VARCHAR2(32000);
   newattr_         VARCHAR2(32000);
   is_automatic_db_ VARCHAR2(20);
   customer_no_     EXT_INC_SBI_HEAD_TAB.customer_no%TYPE;
   company_         SELF_BILLING_HEADER_TAB.company%TYPE;
   sbi_no_          SELF_BILLING_HEADER_TAB.sbi_no%TYPE;
   rec_             EXT_INC_SBI_HEAD_TAB%ROWTYPE;
   error_message_   VARCHAR2(2000);

   CURSOR get_sbi_data IS
      SELECT *
        FROM ext_inc_sbi_head_tab
       WHERE message_id = message_id_
         AND rowstate   = 'Received';

   CURSOR get_invoice_ids IS
      SELECT invoice_id
        FROM self_billing_item_tab
       WHERE sbi_no   = sbi_no_
         AND rowstate = 'InvoiceCreated'
    GROUP BY invoice_id;

BEGIN

   is_automatic_db_ := Match_Type_API.Encode(Cust_Ord_Customer_API.Get_Match_Type(Ext_Inc_Sbi_Head_API.Get_Customer_No(message_id_)));

   OPEN  get_sbi_data;
   FETCH get_sbi_data INTO rec_;
   CLOSE get_sbi_data;

   IF (is_automatic_db_ IN ('AUTO', 'AUTOCREATE', 'AUTOCREATEPOST')) THEN
      Ext_Inc_Sbi_Head_API.Do_Match__(attr_, rec_);
      -- Commit changes made so far
      @ApproveTransactionStatement(2012-01-24,GanNLK)
      COMMIT;

      @ApproveTransactionStatement(2012-01-24,GanNLK)
      SAVEPOINT invoice_processed;

      IF (Ext_Inc_Sbi_Head_API.Get_Message_Status(message_id_) IN ('Matched', 'PartiallyMatched')) THEN
         IF (is_automatic_db_ IN ('AUTOCREATE', 'AUTOCREATEPOST')) THEN
            sbi_no_ := Self_Billing_Header_API.Get_Preliminary_Sbi_By_Msg(message_id_);
            customer_no_:= Ext_Inc_Sbi_Head_API.Get_Customer_No(message_id_);
            Self_Billing_Header_API.Create_Invoice(company_, sbi_no_, customer_no_);

            IF (is_automatic_db_ IN ('AUTOCREATEPOST')) THEN
               FOR sb_item_rec_ IN get_invoice_ids LOOP
                  Client_SYS.Add_To_Attr('INVOICE_ID', sb_item_rec_.invoice_id, newattr_);
               END LOOP;
               Customer_Order_Inv_Head_API.Print_Invoices(newattr_);
            END IF;
         END IF;
      END IF;
   END IF;
EXCEPTION
   WHEN others THEN
      error_message_ := sqlerrm;
      -- Rollback to the last savepoint
      @ApproveTransactionStatement(2012-01-24,GanNLK)
      ROLLBACK to invoice_processed;
      -- Logg the error
      Transaction_SYS.Set_Status_Info(error_message_);
END Automatic_Sbi_Process;


-- Get_Matched_Info_For_Delnote
--   Returns contract and delivery no of the matched record.
PROCEDURE Get_Matched_Info_For_Delnote (
   deliv_no_         OUT NUMBER,
   contract_         OUT VARCHAR2,
   delnote_no_       IN  VARCHAR2,
   customer_no_      IN  VARCHAR2,
   customer_part_no_ IN  VARCHAR2,
   currency_code_    IN  VARCHAR2 )
IS
      
   CURSOR get_delivery_data IS
     SELECT deliv_no, contract
       FROM unmatched_sbi_deliveries, user_allowed_site_pub
      WHERE delnote_no        = delnote_no_
        AND customer_no       = customer_no_
        AND customer_part_no  = customer_part_no_
        AND currency_code     = currency_code_
        AND contract          = site;

BEGIN
   OPEN get_delivery_data;
   FETCH get_delivery_data INTO deliv_no_, contract_;
   CLOSE get_delivery_data;
END Get_Matched_Info_For_Delnote;


-- Get_Matched_Info_For_Ref_Id
--   Returns contract and delivery no of the matched record.
PROCEDURE Get_Matched_Info_For_Ref_Id (
   deliv_no_         OUT NUMBER,
   contract_         OUT VARCHAR2,
   reference_id_     IN  VARCHAR2,
   customer_no_      IN  VARCHAR2,
   customer_part_no_ IN  VARCHAR2,
   currency_code_    IN  VARCHAR2 )
IS
   CURSOR get_delivery_data IS
     SELECT deliv_no, contract
       FROM unmatched_sbi_deliveries, user_allowed_site_pub
      WHERE ref_id            = reference_id_
        AND customer_no       = customer_no_
        AND customer_part_no  = customer_part_no_
        AND currency_code     = currency_code_ 
        AND contract          = site;
BEGIN

   OPEN get_delivery_data;
   FETCH get_delivery_data INTO deliv_no_, contract_;
   CLOSE get_delivery_data;
END Get_Matched_Info_For_Ref_Id;


-- Get_Matched_Info_For_Cpo
--   Returns contract and delivery no of the matched record.
PROCEDURE Get_Matched_Info_For_Cpo (
   deliv_no_            OUT NUMBER,
   contract_            OUT VARCHAR2,
   customer_po_no_      IN  VARCHAR2,
   customer_po_line_no_ IN  VARCHAR2,
   customer_po_rel_no_  IN  VARCHAR2,
   customer_no_         IN  VARCHAR2,
   customer_part_no_    IN  VARCHAR2,
   currency_code_       IN  VARCHAR2 )
IS
   CURSOR get_delivery_data IS
     SELECT deliv_no, contract
       FROM unmatched_sbi_deliveries, user_allowed_site_pub 
      WHERE customer_po_no      = customer_po_no_
        AND customer_po_line_no = customer_po_line_no_
        AND customer_po_rel_no  = customer_po_rel_no_
        AND customer_no         = customer_no_
        AND customer_part_no    = customer_part_no_ 
        AND currency_code       = currency_code_
        AND contract            = site; 
BEGIN

   OPEN  get_delivery_data;
   FETCH get_delivery_data INTO deliv_no_, contract_;
   CLOSE get_delivery_data;
END Get_Matched_Info_For_Cpo;


-- Check_Matched_Line_For_Delnote
--   Reaise an error when multiple for no data found for a delnote.
PROCEDURE Check_Matched_Line_For_Delnote (
   delnote_no_       IN VARCHAR2,
   customer_no_      IN VARCHAR2,
   customer_part_no_ IN VARCHAR2,
   currency_code_    IN VARCHAR2 )
IS
   dummy_             NUMBER:=0;
   approval_user_     VARCHAR2(30);

   CURSOR get_delivery_data IS
      SELECT COUNT(customer_part_no)
        FROM unmatched_sbi_deliveries, user_allowed_site_pub
       WHERE delnote_no       = delnote_no_
         AND customer_no      = customer_no_
         AND customer_part_no = customer_part_no_
         AND currency_code    = currency_code_ 
         AND contract         = site;
BEGIN

   OPEN get_delivery_data;
   FETCH get_delivery_data INTO dummy_;
   CLOSE get_delivery_data;

   IF (dummy_ > 1) THEN
      Error_Sys.Record_General(lu_name_, 'MULTIMATCHFOUND: Multiple matching lines found. Please perform matching operation manually.');
   ELSE
      IF (dummy_ = 0) THEN
         approval_user_ := Cust_Ord_Customer_API.Get_Sbi_Auto_Approval_User(customer_no_);
         Error_Sys.Record_General(lu_name_, 'NOMATCHFOUND: Matching lines not found on sites allowed for user :P1. Please perform matching operation manually.', approval_user_);
      END IF;
   END IF;
END Check_Matched_Line_For_Delnote;


-- Check_Matched_Line_For_Cpo
--   Reaise an error when multiple for no data found for a CPO.
PROCEDURE Check_Matched_Line_For_Cpo (
   customer_po_no_      IN VARCHAR2,
   customer_po_line_no_ IN VARCHAR2,
   customer_po_rel_no_  IN VARCHAR2,
   customer_no_         IN VARCHAR2,
   customer_part_no_    IN VARCHAR2,
   currency_code_       IN  VARCHAR2 )
IS
   dummy_             NUMBER:=0;
   approval_user_     VARCHAR2(30);

   CURSOR get_delivery_data IS
      SELECT COUNT(customer_part_no)
        FROM unmatched_sbi_deliveries, user_allowed_site_pub
       WHERE customer_po_no      = customer_po_no_
         AND customer_po_line_no = customer_po_line_no_
         AND customer_po_rel_no  = customer_po_rel_no_
         AND customer_no         = customer_no_
         AND customer_part_no    = customer_part_no_
         AND currency_code       = currency_code_ 
         AND contract            = site;

BEGIN

   OPEN get_delivery_data;
   FETCH get_delivery_data INTO dummy_;
   CLOSE get_delivery_data;

   IF (dummy_ > 1) THEN
      Error_Sys.Record_General(lu_name_, 'MULTIMATCHFOUND: Multiple matching lines found. Please perform matching operation manually.');
   ELSE
      IF (dummy_ = 0) THEN
         approval_user_ := Cust_Ord_Customer_API.Get_Sbi_Auto_Approval_User(customer_no_);
         Error_Sys.Record_General(lu_name_, 'NOMATCHFOUND: Matching lines not found on sites allowed for user :P1. Please perform matching operation manually.', approval_user_);
      END IF;
   END IF;
END Check_Matched_Line_For_Cpo;


-- Check_Matched_Line_For_Ref
--   Reaise an error when multiple for no data found for a ref.
PROCEDURE Check_Matched_Line_For_Ref (
   reference_id_     IN VARCHAR2,
   customer_no_      IN VARCHAR2,
   customer_part_no_ IN VARCHAR2,
   currency_code_    IN VARCHAR2 )
IS
   dummy_             NUMBER:=0;
   approval_user_     VARCHAR2(30);

   CURSOR get_delivery_data IS
      SELECT COUNT(customer_part_no)
        FROM unmatched_sbi_deliveries, user_allowed_site_pub
       WHERE ref_id           = reference_id_
         AND customer_no      = customer_no_
         AND customer_part_no = customer_part_no_
         AND currency_code    = currency_code_ 
         AND contract         = site;
BEGIN

   OPEN get_delivery_data;
   FETCH get_delivery_data INTO dummy_;
   CLOSE get_delivery_data;
   IF (dummy_ > 1) THEN
      Error_Sys.Record_General(lu_name_, 'MULTIMATCHFOUND: Multiple matching lines found. Please perform matching operation manually.');
   ELSE
      IF (dummy_ = 0) THEN
         approval_user_ := Cust_Ord_Customer_API.Get_Sbi_Auto_Approval_User(customer_no_);
         Error_Sys.Record_General(lu_name_, 'NOMATCHFOUND: Matching lines not found on sites allowed for user :P1. Please perform matching operation manually.', approval_user_);
      END IF;
   END IF;
END Check_Matched_Line_For_Ref;


-- Save_Manually_Matched_Line
--   Match one unmatched delivery against one Incoming Self Billing Line.
@Deprecated
PROCEDURE Save_Manually_Matched_Line (
   info_ OUT VARCHAR2,
   attr_ IN VARCHAR2 )
IS   
BEGIN
   Save_Manually_Matched_Lines(info_, 
                               attr_); 
END Save_Manually_Matched_Line;

-- Save_Manually_Matched_Lines
--   Match unmatched deliveries against one Incoming Self Billing Line.
PROCEDURE Save_Manually_Matched_Lines (
   info_ OUT VARCHAR2,
   attr_ IN VARCHAR2 )
IS
   ptr_                    NUMBER;
   name_                   VARCHAR2(30);
   value_                  VARCHAR2(2000);
   sbi_no_                 VARCHAR2(15);
   order_no_               VARCHAR2(12);
   line_no_                VARCHAR2(4);
   rel_no_                 VARCHAR2(4);
   line_item_no_           NUMBER;
   customer_qty_           NUMBER;
   cust_net_curr_amount_   NUMBER;
   deliv_no_               NUMBER;
   cust_unit_sales_qty_    NUMBER;
   cust_unit_part_price_   NUMBER;
   net_curr_amount_        NUMBER;
   tax_curr_amount_        NUMBER;
   gross_curr_amount_      NUMBER;
   message_id_             NUMBER;
   message_line_           NUMBER;
   close_type_db_          VARCHAR2(20);
   contract_               VARCHAR2(5);
   customer_id_            SELF_BILLING_HEADER_TAB.customer_id%TYPE;
   sbi_header_rec_         SELF_BILLING_HEADER_TAB%ROWTYPE;
   inc_header_rec_         Ext_Inc_Sbi_Head_API.Public_Rec;
   company_                VARCHAR2(20);
   deviation_reason_       VARCHAR2(10);
   additional_cost_        NUMBER;
   qty_edited_flag_        VARCHAR2(5);
   full_attr_              VARCHAR2(32000);
   length_                 NUMBER;
   rec_attr_               VARCHAR2(32000);
   cust_gross_curr_amount_ NUMBER;
   cust_tax_curr_amount_   NUMBER;
   
   
   CURSOR get_exist_sbi_no(message_id_ NUMBER, customer_id_ VARCHAR2, company_ VARCHAR2) IS
      SELECT sbi_no
        FROM SELF_BILLING_HEADER_TAB
       WHERE message_id  = message_id_
         AND customer_id = customer_id_
         AND company     = company_
         AND rowstate    = 'Preliminary';

   CURSOR get_additional_cost IS
      SELECT additional_cost
        FROM EXT_INC_SBI_ITEM_TAB
       WHERE message_id   = message_id_
         AND message_line = message_line_;

BEGIN
   full_attr_ := attr_;
   length_ := LENGTH(full_attr_);

   -- Fetch the neccessary attributes from the attr string
   message_id_   := Client_SYS.Get_Item_Value('MESSAGE_ID', attr_);
   customer_id_  := Client_SYS.Get_Item_Value('CUSTOMER_ID', attr_);
   company_      := Site_API.Get_Company(Client_SYS.Get_Item_Value('CONTRACT', attr_));
   message_line_ := Client_SYS.Get_Item_Value('MESSAGE_LINE', attr_);
   
   OPEN  get_exist_sbi_no (message_id_, customer_id_, company_);
   FETCH get_exist_sbi_no INTO sbi_no_;
   CLOSE get_exist_sbi_no;
   
   IF ( sbi_no_ IS NULL ) THEN
      inc_header_rec_ := Ext_Inc_Sbi_Head_API.Get(message_id_);
      Set_Sbi_Record_Values___(sbi_header_rec_, inc_header_rec_, message_id_);
      Self_Billing_Header_API.Create_Header__(sbi_no_, sbi_header_rec_);
   END IF;
   
   WHILE (length_ > 0) LOOP
      rec_attr_  := SUBSTR(full_attr_, 1, (INSTR(full_attr_, 'END', 1, 1) - 1));
      full_attr_ := SUBSTR(full_attr_, (INSTR(full_attr_, 'END', 1, 1) + 3), length_);
      length_    := LENGTH(full_attr_);
   
      ptr_ := NULL;
      WHILE (Client_SYS.Get_Next_From_Attr(rec_attr_, ptr_, name_, value_)) LOOP
         IF (name_ = 'SBI_NO') THEN
            sbi_no_ := value_;
         ELSIF (name_ = 'MESSAGE_ID') THEN
            message_id_ := value_;
         ELSIF (name_ = 'MESSAGE_LINE') THEN
            message_line_ := value_;
         ELSIF (name_ = 'CONTRACT') THEN
            contract_ := value_;
            company_  := Site_API.Get_Company(contract_);
         ELSIF (name_ = 'CUSTOMER_ID') THEN
            customer_id_ := value_;
         ELSIF (name_ = 'ORDER_NO') THEN
            order_no_ := value_;
         ELSIF (name_ = 'LINE_NO') THEN
            line_no_ := value_;
         ELSIF (name_ = 'REL_NO') THEN
            rel_no_ := value_;
         ELSIF (name_ = 'LINE_ITEM_NO') THEN
            line_item_no_ := Client_SYS.Attr_Value_To_Number(value_);
         ELSIF (name_ = 'DELIV_NO') THEN
            deliv_no_ := Client_SYS.Attr_Value_To_Number(value_);
         ELSIF (name_ = 'CUSTOMER_QTY') THEN
            customer_qty_ := Client_SYS.Attr_Value_To_Number(value_);
         ELSIF (name_ = 'CUST_UNIT_PART_PRICE') THEN
            cust_unit_part_price_ := Client_SYS.Attr_Value_To_Number(value_);
         ELSIF (name_ = 'CUST_UNIT_SALES_QTY') THEN
            cust_unit_sales_qty_ := Client_SYS.Attr_Value_To_Number(value_);
         ELSIF (name_ = 'CUST_NET_CURR_AMOUNT') THEN
            cust_net_curr_amount_ := Client_SYS.Attr_Value_To_Number(value_);
         ELSIF (name_ = 'CUST_GROSS_CURR_AMOUNT') THEN
            cust_gross_curr_amount_ := Client_SYS.Attr_Value_To_Number(value_);
         ELSIF (name_ = 'CUST_TAX_CURR_AMOUNT') THEN
            cust_tax_curr_amount_ := Client_SYS.Attr_Value_To_Number(value_);
         ELSIF (name_ = 'NET_CURR_AMOUNT') THEN
            net_curr_amount_ := Client_SYS.Attr_Value_To_Number(value_);
         ELSIF (name_ = 'TAX_CURR_AMOUNT') THEN
            tax_curr_amount_ := Client_SYS.Attr_Value_To_Number(value_);
         ELSIF (name_ = 'GROSS_CURR_AMOUNT') THEN
            gross_curr_amount_ := Client_SYS.Attr_Value_To_Number(value_);
         ELSIF (name_ = 'CLOSE_TYPE_DB') THEN
            close_type_db_ := value_;
         ELSIF (name_ = 'QTY_EDITED_FLAG') THEN
            qty_edited_flag_ := value_;
         END IF;
      END LOOP;
   
      -- qty_edited_flag is sent from the client as TRUE when the quantity manually matched is less than the total quantity to match
      Connect_Matched_Line_To_Sbi___ ( sbi_no_                 => sbi_no_,
                                       order_no_               => order_no_,
                                       line_no_                => line_no_,
                                       rel_no_                 => rel_no_,
                                       line_item_no_           => line_item_no_,
                                       deliv_no_               => deliv_no_,
                                       customer_qty_           => customer_qty_,
                                       cust_unit_part_price_   => cust_unit_part_price_,
                                       cust_unit_sales_qty_    => cust_unit_sales_qty_,
                                       cust_net_curr_amount_   => cust_net_curr_amount_,
                                       cust_gross_curr_amount_ => cust_gross_curr_amount_,
                                       cust_tax_curr_amount_   => cust_tax_curr_amount_,
                                       net_curr_amount_        => net_curr_amount_,
                                       tax_curr_amount_        => tax_curr_amount_,
                                       gross_curr_amount_      => gross_curr_amount_,
                                       close_type_db_          => close_type_db_,
                                       match_type_db_          => 'MANUAL MATCH',
                                       message_id_             => message_id_,
                                       message_row_            => message_line_,
                                       deviation_reason_       => deviation_reason_,
                                       qty_edited_flag_        => qty_edited_flag_);
   END LOOP;

   -- Since now we have all the data we need, reset any error messages on line.
   Ext_Inc_Sbi_Item_API.Clear_Line_Error_Messages__(message_id_, message_line_);
   -- After all this tell the line to update its state.
   Ext_Inc_Sbi_Item_API.Set_Line_Matched__(message_id_, message_line_);

   OPEN  get_additional_cost;
   FETCH get_additional_cost INTO additional_cost_;
   CLOSE get_additional_cost;

   IF ((additional_cost_ IS NOT NULL) AND (additional_cost_ != 0)) THEN
      Client_SYS.Add_Info('OrderSelfBillingManager','HASADDITIONALCOST: The Incoming Self-Billing line holds an additional cost. The additional cost should be considered when matching.');
   END IF;

   info_ := Client_SYS.Get_All_Info;
END Save_Manually_Matched_Lines;

-- Add_Matched_Lines
--   Save matched lines in the self billing item table.
PROCEDURE Add_Matched_Lines (
   attr_ IN VARCHAR2 )
IS
   full_attr_              VARCHAR2(32000);
   rec_attr_               VARCHAR2(32000);
   ptr_                    NUMBER;
   name_                   VARCHAR2(30);
   value_                  VARCHAR2(2000);
   length_                 NUMBER;
   sbi_no_                 VARCHAR2(15);
   order_no_               VARCHAR2(12);
   line_no_                VARCHAR2(4);
   rel_no_                 VARCHAR2(4);
   line_item_no_           NUMBER;
   customer_qty_           NUMBER;
   cust_net_curr_amount_   NUMBER;
   deliv_no_               NUMBER;
   cust_unit_sales_qty_    NUMBER;
   cust_unit_part_price_   NUMBER;
   net_curr_amount_        NUMBER;
   tax_curr_amount_        NUMBER;
   gross_curr_amount_      NUMBER;
   close_type_db_          VARCHAR2(20);
   deviation_reason_       VARCHAR2(10);
   message_id_             NUMBER := NULL;
   message_line_           NUMBER := NULL;
   qty_edited_flag_        VARCHAR2(5);
   cust_gross_curr_amount_ NUMBER;
   cust_tax_curr_amount_   NUMBER;
   
BEGIN 

   full_attr_ := attr_;
   length_ := LENGTH(full_attr_);
   WHILE (length_ > 0 ) LOOP
      rec_attr_ := SUBSTR(full_attr_, 1, (INSTR(full_attr_, 'END', 1, 1) - 1));
      full_attr_ := SUBSTR(full_attr_, (INSTR(full_attr_, 'END', 1, 1) + 3), length_);
      length_ := LENGTH(full_attr_);

      ptr_ := NULL;
      WHILE (Client_SYS.Get_Next_From_Attr(rec_attr_, ptr_, name_, value_)) LOOP
         IF (name_ = 'SBI_NO') THEN
            sbi_no_ := value_;
         ELSIF (name_ = 'ORDER_NO') THEN
            order_no_ := value_;
         ELSIF (name_ = 'LINE_NO') THEN
            line_no_ := value_;
         ELSIF (name_ = 'REL_NO') THEN
            rel_no_ := value_;
         ELSIF (name_ = 'LINE_ITEM_NO') THEN
            line_item_no_ := Client_SYS.Attr_Value_To_Number(value_);
         ELSIF (name_ = 'DELIV_NO') THEN
            deliv_no_ := Client_SYS.Attr_Value_To_Number(value_);
         ELSIF (name_ = 'CUSTOMER_QTY') THEN
            customer_qty_ := Client_SYS.Attr_Value_To_Number(value_);
         ELSIF (name_ = 'CUST_UNIT_PART_PRICE') THEN
            cust_unit_part_price_ := Client_SYS.Attr_Value_To_Number(value_);
         ELSIF (name_ = 'CUST_UNIT_SALES_QTY') THEN
            cust_unit_sales_qty_ := Client_SYS.Attr_Value_To_Number(value_);
         ELSIF (name_ = 'CUST_NET_CURR_AMOUNT') THEN
            cust_net_curr_amount_ := Client_SYS.Attr_Value_To_Number(value_);
         ELSIF (name_ = 'CUST_GROSS_CURR_AMOUNT') THEN
            cust_gross_curr_amount_ := Client_SYS.Attr_Value_To_Number(value_);
         ELSIF (name_ = 'CUST_TAX_CURR_AMOUNT') THEN
            cust_tax_curr_amount_ := Client_SYS.Attr_Value_To_Number(value_);
         ELSIF (name_ = 'NET_CURR_AMOUNT') THEN
            net_curr_amount_ := Client_SYS.Attr_Value_To_Number(value_);
         ELSIF (name_ = 'TAX_CURR_AMOUNT') THEN
            tax_curr_amount_ := Client_SYS.Attr_Value_To_Number(value_);
         ELSIF (name_ = 'GROSS_CURR_AMOUNT') THEN
            gross_curr_amount_ := Client_SYS.Attr_Value_To_Number(value_);
         ELSIF (name_ = 'CLOSE_TYPE_DB') THEN
            close_type_db_ := value_;
         ELSIF (name_ = 'DEVIATION_REASON') THEN
            deviation_reason_ := value_;
         ELSIF (name_ = 'QTY_EDITED_FLAG') THEN
            qty_edited_flag_ := value_;
         END IF;
      END LOOP;

      Connect_Matched_Line_To_Sbi___ (
         sbi_no_                 => sbi_no_,
         order_no_               => order_no_,
         line_no_                => line_no_,
         rel_no_                 => rel_no_,
         line_item_no_           => line_item_no_,
         deliv_no_               => deliv_no_,
         customer_qty_           => customer_qty_,
         cust_unit_part_price_   => cust_unit_part_price_,
         cust_unit_sales_qty_    => cust_unit_sales_qty_,
         cust_net_curr_amount_   => cust_net_curr_amount_,
         cust_gross_curr_amount_ => cust_gross_curr_amount_,
         cust_tax_curr_amount_   => cust_tax_curr_amount_,
         net_curr_amount_        => net_curr_amount_,
         tax_curr_amount_        => tax_curr_amount_,
         gross_curr_amount_      => gross_curr_amount_,
         close_type_db_          => close_type_db_,
         match_type_db_          => 'MANUAL ADDITION',
         message_id_             => message_id_,
         message_row_            => message_line_,
         deviation_reason_       => deviation_reason_,
         qty_edited_flag_        => qty_edited_flag_  );
   END LOOP;
END Add_Matched_Lines;



