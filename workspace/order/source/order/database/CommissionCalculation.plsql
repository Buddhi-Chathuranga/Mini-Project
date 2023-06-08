-----------------------------------------------------------------------------
--
--  Logical unit: CommissionCalculation
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200828  KiSalk   Bug 155332(SCZ-11302), Added parameter Init_Batch_Commission_Calc include_calculated_lines_ to pass in attribute string to Batch_Commission_Calc. Modified cursor get_com_lines in Batch_Commission_Calc 
--  200828           by adding conditions removed by bugs 135272 and 136076 with an additional OR condition "include_calculated_lines_ = 'TRUE'". Modified Calc_Com_From_Cust_Ord_Line to use simple cursor when called with all parameters.
--  200607  AsZelk   Bug 148578(SCZ-4864), Reverted the bug 134182 by modifying the procedure Batch_Commission_Calc() in order to pass the selected commission_receiver
--  200607           and commission_receiver_group from the cursor into Calc_Com_From_Cust_Ord_Line(). Modified Calc_Com_From_Cust_Ord_Line() by passing the commission_receiver_
--  200607           into Order_Line_Commission_API.Check_Total_Com_Amount__() in order to validate the total commission amount against the commission receiver.
--  190508  KiSalk   Bug 148162(SCZ-4729), In Get_Planned_Com_Amount___, Stopped assigning com_percentage_ with olc_rec_.commission_percentage, when agree_calc_info
--  190508           contains no specific line info, in order to make com_percentage_ 0 as passed by Commission_Agree_Line_API.Calc_Com_Data_From_Agree.
--  180831  DiKulk   Bug 136076, Modified Calculate_Commission_Line___() to reset line_exclusion_flag after calculating commissions.
--  170420  MeAblk   Bug 135405, Modified Calculate_Invoice_Based___() to add a validation to set the total commission amount to zero when the total invoice amount
--  170420           gets zero while the total commission amount has a value which is greater than zero.
--  170418  MeAblk   Bug 135272, Modified Batch_Commission_Calc() to include the already calculated lines when rerun the calculation.
--  170221  ChBnlk   Bug 134182, Modified Batch_Commission_Calc() by passing the input parameter commission_receiver_ instead of the value from the cursor get_com_lines
--  170221           to the method call Calc_Com_From_Cust_Ord_Line(). 
--  160629  IzShlk   STRSC-1968, Activated data validity for the Commission_Receiver_API.Exist method
--  150427  SudJlk   STRSC-1777, Modified Init_Batch_Commission_Calc to check validity for commission_receiver_group.
--  150807  MAHPLK   KES-1211, Modified Calculate_Commission_Line___() pass the rowkey of the new commision order line to Order_Line_Commission_API.Modify().
--  141122  NaLrlk   Modified Calc_Com_From_Cust_Ord, Calc_Com_From_Cust_Ord_Line, Recalc_Com_From_Com_Header and Batch_Commission_Calc to exclude rentals.
--  130712  ErFelk   Bug 111147, Modified Create_Order_Com_Header() by making it as a public Procedure and added commission_no_
--  130712           as an OUT parameter.
--  130703  MaIklk   TIBE-952, Remvoed  Transaction_SYS.Set_Status_Info(info_) and used Transaction_SYS.Log_Status_Info (info_) instead.
--  120815  SURBLK   Modified Fetch_Com_Line_Basic_Data___() to implement 'use price including tax'.
--  100916  PaWelk   Modified Calculate_Invoice_Based___() to get the planned commission amount and update the calculated values in olc_rec_.
--  100512  Ajpelk   Merge rose method documentation
--  090930  MaMalk   Modified Calculate_Invoice_Based___, Get_Existing_Com_Amount___, Get_Planned_Com_Amount___  and Handle_Fixed_Com_Lines___ to remove unused code.
--  ------------------------- 14.0.0 -----------------------------------------
--  080507  MaGuse   Bug 71455, Added commission_receiver to select in cursor get_com_lines and to call of Calc_Com_From_Cust_Ord_Line
--  080507           in method Batch_Commission_Calc.
--  070912  NuVelk   Bug 66972, Modified the  method call Customer_Order_Inv_Head_API.Get_Tot_Discount to 
--  070912            Customer_Order_Inv_Head_API.Get_Tot_Discount_For_Co_Line in Fetch_Com_Line_Basic_Data___.
--  061106  Cpeilk   DIPL606A, Removed hard coded correction invoice types and called from Company_Invoice_Info_API.
--  061018  IsWilk   Bug 59097, Modified methods Calculate_Invoice_Based___ and Batch_Commission_Calc
--  061018           in order to exclude invoice based lines with zero commission from batch job for performance reasons.
--  060522  PrPrlk   Bug 54753, Removed the join between CUSTOMER_ORDER_INV_ITEM and CUSTOMER_ORDER_INV_HEAD that was used in the cusrsors in method Fetch_Com_Line_Basic_Data___.
--  060515  MaJalk   Bug 56576, Modified method Calculate_Correction___ to handle the case when calculation basis=0, existing commissions=0, and a 
--  060515           correction line is still open.
--  060424  MiKulk   Modified the method Fetch_Com_Line_Basic_Data___ to include the correction invoice types,
--  060424           and self billing invoice types also in the commision calulcation.
--  060419  IsWilk   Enlarge Customer - Changed variable definitions.
--  ------------------------- 13.4.0 -----------------------------------------
--  060314  MaGuse   Call ID 136065. Reapplied call to Get_Planned_Com_Amount___ in method Calculate_Invoice_Based___. This call
--                   is necessary to get any invoice based commissions.
--  050926  NuFilk   Reapplied Bug 46197, modified method Calc_Com_Line_Data__ and Calc_Com_From_Cust_Ord_Line.
--  050926  NuFilk   Modified the call to Currency_Rate_API.Get_Currency_Rate_Defaults to Invoice_Library_API.Get_Currency_Rate_Defaults.
--  050921  SaMelk   Removed unused variables.
--  050614  MaMalk   Bug 51333, Modified the procedure Fetch_Com_Line_Basic_Data___ to exclude charges for the commission calculation.
--  050510  ChJalk   Bug 51059, Removed fetching discount from invoice item and Added fetching of discount from invoice head. 
--  050207  MaGuse   Bug 49449, Modified method Fetch_Com_Line_Basic_Data___ to use part_no when fetching attributes from inventory part.
--  050131  MaGuse   Bug 47353, Modified method Batch_Commission_Calc to use invoice date for invoice based commission lines.
--  050125  MaGuse   Bug 48259, Added fetching of discount from invoice item. Modified method Fetch_Com_Line_Basic_Data___.
--  041202  MaGuse   Bug 46197, Restructured methods Calc_Com_Line_Data__, Fetch_Com_Line_Basic_Data__ and Get_Planned_Com_Amount___.
--  041202           Added new methods Calculate_Order_Based___, Calculate_Invoice_Based___ and Calculate_Correction___.
--  041202           Enabled calculation of commissions for more than one open lines at a time. Modified
--  041202           method Calc_Com_Line_Data__. Added new method Calculate_Commission_Line___.
--  041202           Added handling of commission no for fixed lines. Modified methods
--  041202           Handle_Fixed_Com_Lines___ and Calc_Com_Line_Data__. 
--  041202           Modified handling of fixed lines in method Calc_From_Cust_Ord_Line___.
--  041202           Removed usage of qty_returned in calculation of qty for Order Based commission lines 
--  041202           in method Fetch_Com_Line_Basic_Data___. Excluded Manual correction lines from total in 
--  041202           method Get_Existing_Com_Amount___. Enabled creation of correction lines for Order Based
--  041202           commission lines in methods Calculate_Correction___ and Calc_Com_Line_Data__.
--  040514  DaRulk   LCS Patch 42501, Modified Calc_Com_Line_Data__ to display the correction lines.
--  040511  UdGnlk   Bug 41757, Modified Fetch_Com_Line_Basic_Data___ in order to handle new collective invoice type CUSTCOLDEB and CUSTCOLCRE.
--  040218  IsWilk   Modified the SUBSTRB to SUBSTR for Unicode modification.
--  ----------------------13.3.0-----------------
--  031103  JaBalk   Call ID 107425, Modified the method Calc_Com_Line_Data__.
--  031103  JaBalk   Call ID 107425, Modified the methods Handle_Fixed_Com_Lines,Calc_Com_Line_Data__, Fetch_Com_Line_Basic_Data___,
--  031103           Calc_Com_From_Cust_Ord_Line,Calc_Com_From_Cust_Ord,Recalc_Com_From_Com_Header,Batch_Commission_Calc
--  031103           Added 2 default null parameters to Calc_Com_From_Cust_Ord_Line
--  031024  JaBalk   Call ID 107425, Modified the cursor get_fixed_lines to select not cancelled/closed lines in Handle_Fixed_Com_Lines___
--  030922  GaJalk   Merged the bug 38803.
--  030916  JaBalk   Bug 37779, Updated Calc_Com_Line_Data__ by calling Check_Total_Com_Amount__ which will handle all the checks related to amounts
--  030916           and renamed the Get_Total_Gross_Invoice_Amount to Get_Total_Net_Invoice_Amount.
--  030911  MiKulk   Bug 37995, Modified the VARCHAR declaration in the coding as VARCHAR2.
--  030804  ChFolk   Performed SP4 Merge. (SP4Only)
--  030516  JaBalk   Bug 36352, Update Create_Order_Com_Header__ to remove cursor get_inv_date and get the date from invoice header.
--  030516           Removed some commented codes related to bug 35402.
--  030511  KaDilk   Bug 35402, Removed Function Get_Invoice_Amount and Added Handle_Fixed_Com_Lines proceure and
--  030511           all work related to fixed commission lines.Handle_Fixed_Com_Lines will be called from Batch_Commission_Calc,
--  030511           Calc_Com_From_Cust_Ord,Calc_Com_From_Cust_Ord_LineRecalc_Com_From_Com_Header
--  030511           Modified Calc_Com_Line_Data__ to get the invoiced_amount
--  030803  KaDilk  Bug 36352, Changed the Function Create_Order_Com_Header__ to calculate
--  030803          Commission_No Based on the Commisson_Calculation Base.
--  030225  BhRalk  Bug 35402, Added New Functions Get_Invoice_Amount and Check_Invoice_Exist.
--  030225          Modified the Method Calc_Com_Line_Data__ and Fetch_Com_Line_Basic_Data___.
--  030129  BhRalk  Bug 35402, Modified the Method Calc_Com_Line_Data__ , to compare
--  030129          total_com_amount_ with invoiced_amount_ when Order Line is in Invoiced State and
--  030129          Commission Calc Base = 'INVOICED'.
--  021216  MiKulk  Bug 34468, Modified the Calc_Com_Line_Data__ to avoid checking the commision amount
--  021216          against order amount, if the total order amount is negative and the CO lines
--  021216          created with Aquisition Service Order.
--  010528  JSAnse  Bug 21463, Added call to  General_SYS.Init_Method in the procedures Get_Total_Com_Amount,
--                  Get_Amount_In_Currency and Get_Base_Amount_In_Currency.
--  010409  CaSt    Bug fix 21237. Different currency rates used when comparing total order amount
--                  and total commission amount in Calc_Com_Line_Data__.
--  010201  PaLj    Bug fix 19107. Added 2 cursors (get_invoiced_cre_qty, get_invoiced_deb_qty)
--                  in Fetch_Com_Line_Basic_Data___ to get invoice qty instead of delivered qty.
--  010125  PaLj    Bug Fix 19210. Added method Calc_Total_Est_Com_Amount___.
--                  Called in Calc_Com_Line_Data_
--  010103  CaRa    Added check if any part no is connected in agree_calc_info in function
--                  Get_Planned_Com_Amount___. Added condition in cursor source_items.
--                  Added cursor fetch_percentage_previous.
--  001218  JoAn    Corrected Calc_Com_Line_Data__. No values where assigned to
--                  qty and amount fields in commission line record.
--  001206  JoEd    Allowed wildcard % for commission receiver/receiver group
--                  in method Init_Batch_Commission_Calc.
--  001201  JoEd    Removed extra Set_Status_Info call in Batch_Commission_Calc.
--  001124  JoAn    CID 51575 Corrected calculation for estimated commission amount
--                  in Calc_Com_Line_Data__
--  001123  JoAn    Removed calls to Security_SYS.Is_View_Available.
--  000711  TFU     merging from Chameleon
--  000524  BRO     Corrected package parts management,
--                  explicited message NO_VALID_AGREE in Fetch_Com_Line_Basic_Data___
--  000511  BRO     Changed Calculate_Total_Com_Amount___ to a function
--  000509  BRO     Added function Get_Total_Com_Amount
--  000508  BRO     Added case where no invoice exist yet
--  000505  BjSa    Modified Fetch_Com_Line_Basic_Data___
--  000502  BRO     Added procedure Calculate_Total_Com_Amount___
--  000427  BRO     Added functions Get_Existing_Com_Amount___ and
--                  Get_Planned_Com_Amount___
--  000425  BRO     Set proc. Fetch_Com_Line_Basic_Data__ as implementation proc.
--  000420  DEHA    Added functions Get_Amount_In_Currency,
--          BRO     Get_Base_Amount_In_Currency:
--                     -- to get the amount in the currency from the commission
--                        receiver (parameter)
--                     -- to get the amount in the base currency from
--  000419  BRO     Moved Create_Order_Commission_Lines and
--                  Refresh_Order_Commission_Lines to Order_Line_Commission_API
--  000418  BjSa    Added Init_Batch_Commission_Calc
--  000418  BRO     Implemented private methods
--  000417  BRO     Added General_SYS.Init_Method calls
--  000412  DEHA    Created.
--  -------------------------- 12.1
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Fetch_Com_Line_Basic_Data___
--   Private method to fetch the basis data for a commission order line.
PROCEDURE Fetch_Com_Line_Basic_Data___ (
   estimated_amount_    OUT NUMBER,
   estimated_qty_       OUT NUMBER,
   olc_rec_             IN OUT ORDER_LINE_COMMISSION_TAB%ROWTYPE,
   order_no_            IN VARCHAR2,
   line_no_             IN VARCHAR2,
   rel_no_              IN VARCHAR2,
   line_item_no_        IN NUMBER,
   commission_receiver_ IN VARCHAR2 )
IS
   cor_inv_type_           VARCHAR2(20);
   col_inv_type_           VARCHAR2(20);
   inv_net_amount_         NUMBER;
   inv_vat_amount_         NUMBER;

   CURSOR get_invoiced_amount IS
      SELECT SUM(ii.net_dom_amount), SUM(ii.vat_dom_amount)
        FROM CUSTOMER_ORDER_INV_ITEM ii
       WHERE ii.contract      = olc_rec_.contract
         AND ii.order_no      = order_no_
         AND ii.line_no       = line_no_
         AND ii.release_no    = rel_no_
         AND ii.line_item_no  = line_item_no_
         AND ii.charge_seq_no IS NULL;

   CURSOR get_invoiced_deb_qty IS
      SELECT SUM(ii.invoiced_qty) 
        FROM CUSTOMER_ORDER_INV_ITEM ii
       WHERE ii.contract     = olc_rec_.contract
         AND ii.order_no     = order_no_
         AND ii.line_no      = line_no_
         AND ii.release_no   = rel_no_
         AND ii.line_item_no = line_item_no_
         AND ii.charge_seq_no IS NULL
         AND ii.invoice_type IN ('CUSTORDDEB', 'CUSTCOLDEB');
 
   CURSOR get_invoiced_cre_qty IS
      SELECT SUM(ii.invoiced_qty)
        FROM CUSTOMER_ORDER_INV_ITEM ii
       WHERE ii.contract     = olc_rec_.contract
         AND ii.order_no     = order_no_
         AND ii.line_no      = line_no_
         AND ii.release_no   = rel_no_
         AND ii.line_item_no = line_item_no_
         AND ii.charge_seq_no IS NULL
         AND ii.invoice_type IN ('CUSTORDCRE', 'CUSTCOLCRE') ;
 
   -- A cursor to get the quantities from correction invoices 
   CURSOR get_invoiced_cor_qty IS
      SELECT SUM(ii.invoiced_qty)
        FROM CUSTOMER_ORDER_INV_ITEM ii
       WHERE ii.contract     = olc_rec_.contract
         AND ii.order_no     = order_no_
         AND ii.line_no      = line_no_
         AND ii.release_no   = rel_no_
         AND ii.line_item_no = line_item_no_
         AND ii.charge_seq_no  IS NULL
         AND ii.invoice_type IN (cor_inv_type_, col_inv_type_);


   date_entered_            DATE;
   ivc_date_                DATE;
   company_                 VARCHAR2(20);
   curr_type_               CURRENCY_TYPE_TAB.currency_type%TYPE;
   conv_factor_             NUMBER;
   curr_code_               CURRENCY_CODE_TAB.currency_code%TYPE;
   buy_qty_due_             NUMBER;
   qty_invoiced_deb_        NUMBER;
   qty_invoiced_cre_        NUMBER;
   qty_invoiced_cor_        NUMBER;
   invoice_exist_           NUMBER:=0;
   order_calc_base_exist_   NUMBER:=0;
   contract_                VARCHAR2(5);
   part_no_                 VARCHAR2(25);
   co_rec_                  Customer_Order_API.Public_Rec;
   co_line_rec_             Customer_Order_Line_API.Public_Rec;
   cancelled_invoice_exist_ NUMBER := 0;

   CURSOR check_order_calc_base IS
      SELECT 1
      FROM  order_line_commission_tab
      WHERE order_no = order_no_
      AND   line_no = line_no_
      AND   rel_no = rel_no_
      AND   line_item_no = line_item_no_
      AND   commission_calc_base = 'ORDER'
      AND   rowstate NOT IN ('Cancelled');

BEGIN

   co_rec_      := Customer_Order_API.Get(order_no_);
   co_line_rec_ := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);

   olc_rec_.country_code := co_rec_.country_code;
   olc_rec_.market_code  := co_rec_.market_code;
   date_entered_         := co_rec_.date_entered;
   olc_rec_.customer_no  := co_rec_.customer_no;
   olc_rec_.contract     := co_rec_.contract;
 
   olc_rec_.catalog_no   := co_line_rec_.catalog_no;
   olc_rec_.region_code  := co_line_rec_.region_code;
   buy_qty_due_          := co_line_rec_.buy_qty_due;
   contract_             := co_line_rec_.contract;
   part_no_              := co_line_rec_.part_no;
      

   company_ := Site_API.Get_Company(olc_rec_.contract);
   invoice_exist_ := Check_Invoice_Exist(order_no_, line_no_, rel_no_, line_item_no_,olc_rec_.contract);
   cor_inv_type_ := Company_Def_Invoice_Type_API.Get_Def_Co_Cor_Inv_Type(company_);
   col_inv_type_ := Company_Def_Invoice_Type_API.Get_Def_Col_Cor_Inv_Type(company_);
   cancelled_invoice_exist_ := Check_Cancelled_Invoice_Exist(order_no_, line_no_, rel_no_, line_item_no_,olc_rec_.contract);
   
   --Fetch valid agreement revision
   IF (olc_rec_.commission_line_source != 'MANUAL') AND (olc_rec_.agreement_id IS NOT NULL) THEN
      IF (olc_rec_.commission_calc_base = 'INVOICED') AND (invoice_exist_ = 1) THEN
         --Fetch valid revision using invoice date.
         ivc_date_ := Customer_Order_Inv_Item_API.Get_Order_line_Invoice_Date(olc_rec_.order_no,
                                                                              olc_rec_.line_no,
                                                                              olc_rec_.rel_no,
                                                                              olc_rec_.line_item_no);

         olc_rec_.revision_no := Commission_Agree_API.Get_Agree_Version(olc_rec_.agreement_id, ivc_date_);
      ELSE
         --Fetch valid revision using date entered on customer order line.
         olc_rec_.revision_no := Commission_Agree_API.Get_Agree_Version(olc_rec_.agreement_id, date_entered_);
      END IF;
   END IF;
      -- com. receiver currency rate
   curr_code_ := Commission_Receiver_API.Get_Currency_Code(commission_receiver_);
   
    Invoice_Library_API.Get_Currency_Rate_Defaults(curr_type_,
                                                  conv_factor_,
                                                  olc_rec_.currency_rate,
                                                  company_,
                                                  curr_code_,
                                                  date_entered_,
                                                  'CUSTOMER',
                                                  NVL(co_rec_.customer_no_pay, olc_rec_.customer_no));

   --Fetch correct Amount and Quantity
   IF(co_rec_.use_price_incl_tax = 'TRUE') THEN
      estimated_amount_ := Customer_Order_Line_API.Get_Base_Price_Incl_Tax_Total(order_no_, line_no_, rel_no_, line_item_no_);                         
   ELSE
   estimated_amount_ := Customer_Order_Line_API.Get_Base_Sale_Price_Total(order_no_, line_no_, rel_no_, line_item_no_);
   END IF;
   estimated_qty_ := buy_qty_due_;

   IF (olc_rec_.commission_calc_base = 'INVOICED') THEN
      --Invoice based
      --If invoice item exists - use amount and quantity from invoice.
      IF (invoice_exist_ = 1 ) THEN
         --Amount
         OPEN get_invoiced_amount;
         FETCH get_invoiced_amount INTO inv_net_amount_, inv_vat_amount_;   
         CLOSE get_invoiced_amount;

         --If both invoice based and order based lines exist - the estimated amount is fetched
         --from customer order line. Otherwise estimated amount is fetched from invoice.
         OPEN check_order_calc_base;
         FETCH check_order_calc_base INTO order_calc_base_exist_;
         CLOSE check_order_calc_base;
         IF (order_calc_base_exist_ = 0) THEN
            IF(co_rec_.use_price_incl_tax = 'TRUE') THEN
               estimated_amount_ := inv_net_amount_+ inv_vat_amount_;
               olc_rec_.amount   := inv_net_amount_+ inv_vat_amount_;
            ELSE
               estimated_amount_ := inv_net_amount_;
               olc_rec_.amount   := inv_net_amount_;
         END IF;
         END IF;

         --Quantity 
         --Should always be fetched from invoice to handle case when qty is modified on preliminary ivc.
         OPEN get_invoiced_deb_qty;
         FETCH get_invoiced_deb_qty INTO qty_invoiced_deb_;
         CLOSE get_invoiced_deb_qty;

         OPEN get_invoiced_cre_qty;
         FETCH get_invoiced_cre_qty INTO qty_invoiced_cre_;
         CLOSE get_invoiced_cre_qty;

         OPEN get_invoiced_cor_qty;
         FETCH get_invoiced_cor_qty INTO qty_invoiced_cor_;
         CLOSE get_invoiced_cor_qty;


         olc_rec_.qty := nvl(qty_invoiced_deb_, 0) - nvl(qty_invoiced_cre_, 0) + nvl(qty_invoiced_cor_,0);
         olc_rec_.discount := Customer_Order_Inv_Head_API.Get_Tot_Discount_For_Co_Line(contract_, order_no_, line_no_, rel_no_, line_item_no_);
      ELSIF (cancelled_invoice_exist_ = 1) THEN
         olc_rec_.amount := estimated_amount_;
         olc_rec_.qty := Customer_Order_Line_API.Get_Qty_Invoiced(order_no_, line_no_, rel_no_, line_item_no_);
         olc_rec_.discount := Customer_Order_Inv_Head_API.Get_Tot_Discount_For_Co_Line(contract_, order_no_, line_no_, rel_no_, line_item_no_);
      ELSE
         --If no invoice item exists  - use the amount and quantity from customer order line.
         olc_rec_.amount := estimated_amount_;
         olc_rec_.qty := estimated_qty_;
         olc_rec_.discount := Customer_Order_Line_API.Get_Total_Discount_Percentage(order_no_, line_no_, rel_no_, line_item_no_);
      END IF;

   ELSE
      --Order based
      olc_rec_.amount := estimated_amount_;
      olc_rec_.qty := estimated_qty_;
      olc_rec_.discount := Customer_Order_Line_API.Get_Total_Discount_Percentage(order_no_, line_no_, rel_no_, line_item_no_);
   END IF;

   -- fetch basic data
   olc_rec_.stat_cust_grp := Cust_Ord_Customer_API.Get_Cust_Grp(olc_rec_.customer_no) ;
   olc_rec_.sales_price_group_id := Sales_Part_API.Get_Sales_Price_Group_Id(olc_rec_.contract, olc_rec_.catalog_no);
   olc_rec_.catalog_group := Sales_Part_API.Get_Catalog_Group(olc_rec_.contract, olc_rec_.catalog_no);
   olc_rec_.identity_type := Identity_Invoice_Info_API.Get_Identity_Type_Db (company_, olc_rec_.customer_no,
                             Party_Type_API.Decode('CUSTOMER'));
   olc_rec_.part_product_code := Inventory_Part_API.Get_Part_Product_Code(olc_rec_.contract, part_no_);
   olc_rec_.commodity_code := Inventory_Part_API.Get_Prime_Commodity(olc_rec_.contract, part_no_);
   olc_rec_.part_product_family := Inventory_Part_API.Get_Part_Product_Family(olc_rec_.contract, part_no_);

   olc_rec_.group_id := Identity_Invoice_Info_API.Get_Group_Id(company_, olc_rec_.customer_no, Party_Type_API.Decode('CUSTOMER'));
END Fetch_Com_Line_Basic_Data___;


-- Calculate_Total_Com_Amount___
--   Implementation method for calculating the total
--   commission amount in a line. It uses a given percentage,
--   a fixed amount and the basic data from the order/ invoice.
--   gives the existing commission amount for all the lines
FUNCTION Calculate_Total_Com_Amount___ (
   olc_rec_                IN ORDER_LINE_COMMISSION_TAB%ROWTYPE,
   curr_rounding_          IN NUMBER,
   com_percentage_calc_    IN NUMBER,
   com_amount_calc_        IN NUMBER ) RETURN NUMBER
IS
BEGIN
   -- calculate the total_commission_amount using the manual data
   RETURN ROUND( NVL(com_amount_calc_, 0) +
                 NVL(com_percentage_calc_, 0) *
                 NVL(olc_rec_.amount, 0) / 100, curr_rounding_);
END Calculate_Total_Com_Amount___;


FUNCTION Calc_Total_Est_Com_Amount___ (
   order_amount_           IN NUMBER,
   curr_rounding_          IN NUMBER,
   com_percentage_calc_    IN NUMBER,
   com_amount_calc_        IN NUMBER ) RETURN NUMBER
IS
BEGIN
   -- calculate the total_commission_amount using the manual data
   RETURN ROUND( NVL(com_amount_calc_, 0) +
                 NVL(com_percentage_calc_, 0) *
                 NVL(order_amount_, 0) / 100, curr_rounding_);
END Calc_Total_Est_Com_Amount___;


FUNCTION Get_Existing_Com_Amount___ (
   order_no_               IN VARCHAR2,
   line_no_                IN VARCHAR2,
   rel_no_                 IN VARCHAR2,
   line_item_no_           IN NUMBER,
   commission_receiver_    IN VARCHAR2 ) RETURN NUMBER
IS
   CURSOR get_com_amount IS
      SELECT SUM(olc.total_commission_amount)
        FROM ORDER_LINE_COMMISSION_TAB olc
       WHERE olc.order_no = order_no_
         AND olc.line_no = line_no_
         AND olc.rel_no = rel_no_
         AND olc.line_item_no = line_item_no_
         AND commission_receiver = commission_receiver_
         AND olc.fixed_commission_amount = 'NORMAL'
         AND olc.commission_line_source != 'MANUAL';

   existing_amount_  NUMBER;
BEGIN

   -- we consider all the lines that are not fixed
   OPEN get_com_amount;
   FETCH get_com_amount INTO existing_amount_;
   IF (get_com_amount%NOTFOUND) THEN
      existing_amount_ := 0;
   END IF;
   CLOSE get_com_amount;

   RETURN existing_amount_;
END Get_Existing_Com_Amount___;


-- Get_Planned_Com_Amount___
--   gives the planned commission amount for the opened line
--   or this method calculates the extimated commission
--   amount for a commission receiver and a customer order line using
--   an agreement.
FUNCTION Get_Planned_Com_Amount___ (
   olc_rec_                IN OUT ORDER_LINE_COMMISSION_TAB%ROWTYPE,
   order_no_               IN VARCHAR2,
   line_no_                IN VARCHAR2,
   rel_no_                 IN VARCHAR2,
   line_item_no_           IN NUMBER,   
   contract_               IN VARCHAR2,
   curr_rounding_          IN NUMBER ) RETURN NUMBER
IS
   com_curr_code_       COMMISSION_AGREE_TAB.CURRENCY_CODE%TYPE;
   com_percentage_      NUMBER;
   com_base_amount_     NUMBER; -- commission amount in company currency
   com_curr_amount_     NUMBER; -- commission amount in agreement currency

   currency_rate_       NUMBER;
   curr_date_           DATE;
   customer_no_pay_     ORDER_LINE_COMMISSION_TAB.customer_no%TYPE;
BEGIN

   -- an agreement id exists, we use it
   IF (olc_rec_.agreement_id IS NOT NULL AND olc_rec_.revision_no IS NOT NULL) THEN

      -- get the commission percentage and the fix amount using the agreement
      -- the calculation info are updated in the record
      Commission_Agree_Line_API.Calc_Com_Data_From_Agree(com_percentage_, com_curr_amount_, olc_rec_.agree_calc_info, olc_rec_);

      -- convert commission amount to base currency
      com_curr_code_ := Commission_Agree_API.Get_Currency_Code(olc_rec_.agreement_id, olc_rec_.revision_no);
      curr_date_ := Customer_Order_Line_API.Get_Date_Entered(order_no_, line_no_, rel_no_, line_item_no_);
      customer_no_pay_ := Customer_Order_API.Get_Customer_No_Pay(order_no_);
      com_base_amount_ := COMMISSION_CALCULATION_API.Get_Base_Amount_In_Currency (
                                         currency_rate_,
                                         NVL(customer_no_pay_,olc_rec_.customer_no),
                                         contract_,
                                         com_curr_code_,
                                         curr_date_,
                                         com_curr_amount_);

   -- there is no agreement connected, we parse the existing lines
   ELSE
      olc_rec_.agree_calc_info := NULL;
      com_percentage_ := 0;
      com_base_amount_ := 0;
   END IF;

   olc_rec_.commission_percentage_calc := com_percentage_;
   olc_rec_.commission_amount_calc := com_base_amount_;

   -- return the planned com. amount
   RETURN Calculate_Total_Com_Amount___(olc_rec_, curr_rounding_, com_percentage_, com_base_amount_);
END Get_Planned_Com_Amount___;


-- Handle_Fixed_Com_Lines___
--   This procedure will handle all works related to fixed commission lines
--   when calculating commissions
PROCEDURE Handle_Fixed_Com_Lines___ (
   order_no_              IN VARCHAR2,
   line_no_               IN VARCHAR2,
   rel_no_                IN VARCHAR2,
   line_item_no_          IN NUMBER,
   commission_receiver_   IN VARCHAR2 )
IS
   CURSOR get_fixed_lines IS
      SELECT olc.*
      FROM order_line_commission_tab olc
      WHERE olc.order_no     = order_no_
      AND   olc.line_no      = line_no_
      AND   olc.rel_no       = rel_no_
      AND   olc.line_item_no = line_item_no_
      AND   olc.fixed_commission_amount = 'FIXED'
      AND   olc.rowstate NOT IN ('Cancelled', 'Closed')
      ORDER BY olc.commission_line_no;

   contract_          VARCHAR2(5);
   invoice_exists_    NUMBER := 0;
   line_modified_     NUMBER := 0;
   reset_recalc_flag_ NUMBER := 0;

BEGIN
   contract_         :=Customer_Order_Line_API.Get_Contract(order_no_, line_no_, rel_no_,line_item_no_);
   invoice_exists_   := Check_Invoice_Exist(order_no_, line_no_, rel_no_,line_item_no_,contract_);

   FOR olc_rec_ IN get_fixed_lines LOOP
      IF (olc_rec_.commission_calc_base = 'INVOICED') THEN
         -- if any invoice exist for the order line, only update the commission amount to total_commission_amount for fixed lines
         IF (invoice_exists_ = 1) THEN
            IF (NVL(olc_rec_.total_commission_amount,0) != olc_rec_.commission_amount) THEN
               olc_rec_.total_commission_amount:=olc_rec_.commission_amount;
               
               line_modified_ := 1;
            END IF;

            IF (olc_rec_.commission_no IS NULL) THEN
               --Connect fixed line to commission header
               IF (NVL(olc_rec_.total_commission_amount, 0) != 0 ) THEN
                  Create_Order_Com_Header( olc_rec_.commission_no, order_no_, line_no_, rel_no_, line_item_no_, commission_receiver_);
               END IF;

               line_modified_ := 1;
            END IF;
         END IF;
      ELSIF (olc_rec_.commission_calc_base = 'ORDER') THEN

            IF (NVL(olc_rec_.total_commission_amount,0) != olc_rec_.commission_amount) THEN
               olc_rec_.total_commission_amount:=olc_rec_.commission_amount;
               
               line_modified_ := 1;
            END IF;

            IF (olc_rec_.commission_no IS NULL) THEN
               --Connect fixed line to commission header
               Create_Order_Com_Header( olc_rec_.commission_no, order_no_, line_no_, rel_no_, line_item_no_, commission_receiver_);
               line_modified_ := 1;
            END IF;
      END IF;

      IF (line_modified_ = 1) THEN
         olc_rec_.calculation_date := Site_API.Get_Site_Date(olc_rec_.contract);
         Order_Line_Commission_API.Modify(olc_rec_);
         line_modified_ := 0;
         reset_recalc_flag_ := 1;
      END IF;
      
   END LOOP;

   IF (reset_recalc_flag_ = 1) THEN
      -- clear the commission recalc flag (must be done after the modify)
      Order_Line_Commission_API.Reset_Order_Com_Lines_Changed(
         order_no_, line_no_, rel_no_, line_item_no_, commission_receiver_);
   END IF;
END Handle_Fixed_Com_Lines___;


-- Calculate_Correction___
--   Handles commission calculation for correction lines.
PROCEDURE Calculate_Correction___ (
   olc_rec_               IN OUT ORDER_LINE_COMMISSION_TAB%ROWTYPE,
   overwrite_manual_data_ IN     NUMBER,
   is_new_rec_            IN     NUMBER )
IS
   CURSOR get_manual_data IS
      SELECT commission_percentage, commission_amount
        FROM ORDER_LINE_COMMISSION_TAB 
       WHERE order_no = olc_rec_.order_no    
         AND line_no = olc_rec_.line_no
         AND rel_no = olc_rec_.rel_no
         AND line_item_no = olc_rec_.line_item_no
         AND commission_receiver = olc_rec_.commission_receiver
         AND fixed_commission_amount = 'NORMAL'
         AND rowstate = 'Closed'
         AND commission_line_source NOT IN ('MANUAL', 'CORRECTION')
         ORDER BY commission_line_no;

   comm_percentage_        NUMBER;
   comm_amount_            NUMBER;
   curr_rounding_          NUMBER;
   planned_com_amount_     NUMBER;
   existing_com_amount_    NUMBER;
   estimated_amount_       NUMBER;
   estimated_qty_          NUMBER;
   company_                VARCHAR2(20);

BEGIN


   IF (is_new_rec_ = 1) THEN
      olc_rec_.total_commission_amount := 0;
   END IF;

   ----------------------
   --Fetch basic data
   ----------------------

   Fetch_Com_Line_Basic_Data___(estimated_amount_,
                                estimated_qty_,
                                olc_rec_,
                                olc_rec_.order_no,
                                olc_rec_.line_no,
                                olc_rec_.rel_no,
                                olc_rec_.line_item_no,
                                olc_rec_.commission_receiver);

   ----------------------
   --Calculate commission
   ---------------------- 
   company_ := Site_API.Get_Company(olc_rec_.contract);
   curr_rounding_ := Currency_Code_API.Get_Currency_Rounding(company_, Company_Finance_API.Get_Currency_Code(company_));

   IF (olc_rec_.amount != 0) THEN
      IF (overwrite_manual_data_ = 0) AND (olc_rec_.original_line_source = 'MODIFIED') THEN

         --Use manually entered values for calculation.
         IF (is_new_rec_ = 1) THEN
            comm_percentage_ := NVL(olc_rec_.commission_percentage, 0);
            comm_amount_ := NVL(olc_rec_.commission_amount, 0);
         ELSE
            --Already existing correction line. 
            --Fetch manually entered data from original source line.
            OPEN get_manual_data;
            FETCH get_manual_data INTO comm_percentage_, comm_amount_;
            IF get_manual_data%NOTFOUND THEN
               comm_percentage_ := 0;
               comm_amount_ := 0;
            END IF;
            CLOSE get_manual_data;

         END IF;
         planned_com_amount_ := Calculate_Total_Com_Amount___(olc_rec_, 
                                                              curr_rounding_, 
                                                              comm_percentage_, 
                                                              comm_amount_);
      ELSE
         --Use system generated values for calculation.
         --Get the planned commission amount
         planned_com_amount_ := Get_Planned_Com_Amount___(
                                 olc_rec_,
                                 olc_rec_.order_no,
                                 olc_rec_.line_no,
                                 olc_rec_.rel_no,
                                 olc_rec_.line_item_no,                                 
                                 olc_rec_.contract,
                                 curr_rounding_ );
      END IF;
   END IF;
   --Get the existing commission amount. Amount from Fixed and Manual lines not included.
   existing_com_amount_ := Get_Existing_Com_Amount___(
                           olc_rec_.order_no,
                           olc_rec_.line_no,
                           olc_rec_.rel_no,
                           olc_rec_.line_item_no,
                           olc_rec_.commission_receiver );

   --Update calculated values for correction line
   olc_rec_.commission_percentage_calc := NULL;
   olc_rec_.commission_percentage := NULL;

   IF (olc_rec_.amount = 0) THEN
      IF (existing_com_amount_ != 0) THEN
      --All existing system generated commissions should be reversed
      olc_rec_.commission_amount_calc :=
          ROUND(NVL(planned_com_amount_,0) - existing_com_amount_, curr_rounding_);

         olc_rec_.commission_amount := olc_rec_.commission_amount_calc;
      END IF;
   ELSE
      olc_rec_.commission_amount_calc :=
          ROUND(NVL(planned_com_amount_,0) - existing_com_amount_ + olc_rec_.total_commission_amount, curr_rounding_);
      
      olc_rec_.commission_amount := olc_rec_.commission_amount_calc;
   END IF;

   ----------------------
   --Update totals
   ----------------------

   --Total Commission Amount
   IF (olc_rec_.amount = 0) THEN
         olc_rec_.total_commission_amount:=olc_rec_.commission_amount;
   ELSIF (olc_rec_.amount != 0 ) THEN
         olc_rec_.total_commission_amount := Calculate_Total_Com_Amount___(
         olc_rec_, curr_rounding_, olc_rec_.commission_percentage, olc_rec_.commission_amount);
   END IF;


   -- Total Estimated Commission Amount
   IF (olc_rec_.amount != 0 ) THEN
      olc_rec_.total_estimated_com_amount :=
             Calc_Total_Est_Com_Amount___(estimated_amount_,
                                          curr_rounding_,
                                          olc_rec_.commission_percentage,
                                          olc_rec_.commission_amount );
   END IF;

END Calculate_Correction___;


-- Calculate_Invoice_Based___
--   Handles commission calculation for invoice based commission lines.
PROCEDURE Calculate_Invoice_Based___ (
   olc_rec_               IN OUT ORDER_LINE_COMMISSION_TAB%ROWTYPE,
   overwrite_manual_data_ IN     NUMBER )
IS
   company_                VARCHAR2(20);
   invoice_exist_          NUMBER:=0;
   curr_rounding_          NUMBER;
   estimated_amount_       NUMBER;
   estimated_qty_          NUMBER;
   planned_com_amount_     NUMBER;
BEGIN

  ------------------
  --Fetch basic data
  ------------------
  
  Fetch_Com_Line_Basic_Data___ (estimated_amount_,
                                estimated_qty_,
                                olc_rec_,
                                olc_rec_.order_no,
                                olc_rec_.line_no,
                                olc_rec_.rel_no,
                                olc_rec_.line_item_no,
                                olc_rec_.commission_receiver);
     
  ----------------------
  --Calculate commission
  ----------------------
  company_ := Site_API.Get_Company(olc_rec_.contract);
  curr_rounding_ := Currency_Code_API.Get_Currency_Rounding(company_, Company_Finance_API.Get_Currency_Code(company_));

  --Get the planned commission amount and update the calculated values in olc_rec_.
  IF (olc_rec_.amount != 0) THEN
     planned_com_amount_ := Get_Planned_Com_Amount___(
                             olc_rec_,
                             olc_rec_.order_no,
                             olc_rec_.line_no,
                             olc_rec_.rel_no,
                             olc_rec_.line_item_no,
                             olc_rec_.contract,
                             curr_rounding_ );
  END IF;
      
  -- Update the manual data
  IF (overwrite_manual_data_ = 1) OR (olc_rec_.commission_line_source NOT IN ('MANUAL','MODIFIED')) THEN
     olc_rec_.commission_percentage := olc_rec_.commission_percentage_calc;
     olc_rec_.commission_amount := olc_rec_.commission_amount_calc;
  END IF;

  -------------------
  --Update totals
  -------------------
  invoice_exist_ := Check_Invoice_Exist(olc_rec_.order_no, olc_rec_.line_no, olc_rec_.rel_no, olc_rec_.line_item_no, olc_rec_.contract);

  -- Total Commission Amount
  IF (invoice_exist_ = 0 ) THEN
     olc_rec_.total_commission_amount := 0;
  ELSE
     IF (olc_rec_.commission_line_source = 'MANUAL' 
         AND olc_rec_.amount = 0 
         AND NVL(olc_rec_.total_commission_amount,0) = 0) THEN
         olc_rec_.total_commission_amount:=olc_rec_.commission_amount;
     ELSIF
        (olc_rec_.amount != 0 ) THEN   
        olc_rec_.total_commission_amount := Calculate_Total_Com_Amount___(olc_rec_,
                                                                          curr_rounding_,
                                                                          olc_rec_.commission_percentage,
                                                                          olc_rec_.commission_amount);
     ELSE
        olc_rec_.total_commission_amount := 0;                                                                     
     END IF;
  END IF;

  -- Total Estimated Commission Amount
  -- If the total order amount is reversed through RMA then olc_rec_.amount becomes 0 and can't calculate
  -- the total_estimated_com_amount using commission_percentage, since it gives zero value  
  IF (olc_rec_.amount != 0 ) THEN
      olc_rec_.total_estimated_com_amount := Calc_Total_Est_Com_Amount___(estimated_amount_,
                                                                          curr_rounding_,
                                                                          olc_rec_.commission_percentage,
                                                                          olc_rec_.commission_amount );
  END IF;

  IF (NVL(olc_rec_.total_commission_amount, 0) = 0) AND (invoice_exist_ = 1) THEN
     -- Exclude from batch job until invoice data is modified. For performance of lines without commission in batch job.
     olc_rec_.line_exclude_flag := 'FALSE';
  END IF;

END Calculate_Invoice_Based___;


-- Calculate_Order_Based___
--   Handles commission calculation for order based commission lines.
PROCEDURE Calculate_Order_Based___ (
   olc_rec_               IN OUT ORDER_LINE_COMMISSION_TAB%ROWTYPE,
   overwrite_manual_data_ IN     NUMBER )
IS
   company_                VARCHAR2(20);
   curr_rounding_          NUMBER;
   estimated_amount_       NUMBER;
   estimated_qty_          NUMBER;
   planned_com_amount_     NUMBER;
BEGIN

  -----------------------
  --Fetch basic data
  -----------------------
  Fetch_Com_Line_Basic_Data___ (estimated_amount_,
                                estimated_qty_,
                                olc_rec_,
                                olc_rec_.order_no,
                                olc_rec_.line_no,
                                olc_rec_.rel_no,
                                olc_rec_.line_item_no,
                                olc_rec_.commission_receiver);

  -----------------------
  --Calculate commission
  -----------------------
  company_ := Site_API.Get_Company(olc_rec_.contract);
  curr_rounding_ := Currency_Code_API.Get_Currency_Rounding(company_, Company_Finance_API.Get_Currency_Code(company_));
  
  --Get the planned commission amount and update the calculated values
  IF (olc_rec_.amount != 0) THEN
     planned_com_amount_ := Get_Planned_Com_Amount___(        
                             olc_rec_,                        
                             olc_rec_.order_no,
                             olc_rec_.line_no,
                             olc_rec_.rel_no,
                             olc_rec_.line_item_no,                             
                             olc_rec_.contract,
                             curr_rounding_ );
  END IF;
  

  -- Update the manual data
  IF (overwrite_manual_data_ = 1) OR (olc_rec_.commission_line_source NOT IN ('MANUAL','MODIFIED')) THEN       
     olc_rec_.commission_percentage := olc_rec_.commission_percentage_calc;
     olc_rec_.commission_amount := olc_rec_.commission_amount_calc;
  END IF;

  -----------------------
  -- Update totals
  -----------------------

  -- Total Commission Amount
  IF (olc_rec_.commission_line_source = 'MANUAL' 
      AND olc_rec_.amount = 0 
      AND NVL(olc_rec_.total_commission_amount,0) = 0) THEN     
     olc_rec_.total_commission_amount:=olc_rec_.commission_amount;
  ELSIF 
     (olc_rec_.amount != 0 ) THEN
     -- If the total order amount is reversed through RMA then olc_rec_.amount becomes 0 and can't calculate
     -- the total_commission_amount using commission_percentage, since it gives zero value
     olc_rec_.total_commission_amount := Calculate_Total_Com_Amount___(olc_rec_,
                                                                       curr_rounding_,
                                                                       olc_rec_.commission_percentage,
                                                                       olc_rec_.commission_amount);
  END IF;

  -- Total Estimated Commission Amount
  olc_rec_.total_estimated_com_amount := NVL(planned_com_amount_,0);

END Calculate_Order_Based___;


-- Calculate_Commission_Line___
--   Handles commission calculation for a commission line.
PROCEDURE Calculate_Commission_Line___ (
   olc_rec_               IN OUT ORDER_LINE_COMMISSION_TAB%ROWTYPE,
   overwrite_manual_data_ IN     NUMBER,
   line_type_             IN     VARCHAR2 )
IS
   old_agreement_id_         VARCHAR2(12);
   is_new_rec_               NUMBER := 0;
   old_revision_no_          NUMBER;
   temp_olc_rec_             ORDER_LINE_COMMISSION_TAB%ROWTYPE;
BEGIN

   IF (line_type_ = 'CLOSED') THEN
      --New correction line
      olc_rec_.original_line_source := olc_rec_.commission_line_source;
      olc_rec_.commission_line_source := 'CORRECTION';
      olc_rec_.commission_no := NULL;
      olc_rec_.rowstate  := 'Created';
      is_new_rec_ := 1;
   END IF;

   IF (overwrite_manual_data_ = 1) THEN
      IF (olc_rec_.commission_line_source = 'MODIFIED') THEN
         --Special handling of system generated commission lines that have been modified manually.
         --Revert to using system generated values for calculation.
         olc_rec_.commission_line_source := 'SYSTEM';
      END IF;
   END IF;


   --Fetch Calculation base
   old_agreement_id_ := olc_rec_.agreement_id;
   old_revision_no_ := olc_rec_.revision_no;

   IF (olc_rec_.commission_line_source != 'MANUAL') THEN  
      olc_rec_.agreement_id := Commission_Receiver_API.Get_Agreement_Id(olc_rec_.commission_receiver);
      IF (olc_rec_.agreement_id IS NOT NULL) THEN
         -- Fetch calculation base per Agreement ID, since calculation base may not differ between revisions.
         olc_rec_.commission_calc_base := Commission_Agree_API.Get_Comm_Calc_Base_Db(olc_rec_.agreement_id);
      END IF;
   END IF;


   --Calculate Commission
   IF (line_type_ = 'OPEN' AND olc_rec_.commission_line_source != 'CORRECTION') THEN
      IF (olc_rec_.commission_calc_base = 'INVOICED') THEN
         --Invoice Based
         Calculate_Invoice_Based___(olc_rec_, overwrite_manual_data_);
      ELSIF (olc_rec_.commission_calc_base = 'ORDER') THEN
         --Order Based
         Calculate_Order_Based___(olc_rec_, overwrite_manual_data_);
      END IF;
   ELSIF (olc_rec_.commission_line_source = 'CORRECTION') THEN
         --Handle calculation of corrections.
         Calculate_Correction___(olc_rec_, overwrite_manual_data_, is_new_rec_);
   END IF;


      
   --Check agreement data fetched at calculation.
   IF (olc_rec_.commission_line_source != 'MANUAL') THEN  
      IF (olc_rec_.agreement_id IS NULL OR olc_rec_.revision_no IS NULL) THEN
         IF (old_agreement_id_ IS NOT NULL AND old_revision_no_ IS NOT NULL) THEN
         Client_SYS.Add_Info(lu_name_, 'NO_VALID_AGREE: The agreement of Commission Receiver :P1 is no longer valid in Order :P2 on Line :P3.', olc_rec_.commission_receiver, olc_rec_.order_no, olc_rec_.line_no);
         END IF;
      END IF;
   END IF;


   -- GENERAL STEPS
   -- check if the line is attached to an order commission
   -- Do not create new commission header for lines with 0 value and line source correction.
   IF (olc_rec_.commission_no IS NULL) THEN
      IF (NVL(olc_rec_.total_commission_amount, 0) != 0 AND olc_rec_.commission_calc_base = 'INVOICED') THEN
         Create_Order_Com_Header( olc_rec_.commission_no, olc_rec_.order_no, olc_rec_.line_no, olc_rec_.rel_no, olc_rec_.line_item_no, olc_rec_.commission_receiver);
      ELSIF ( (olc_rec_.commission_calc_base = 'ORDER') AND NOT
      (olc_rec_.commission_line_source = 'CORRECTION' AND NVL(olc_rec_.total_commission_amount, 0) = 0) ) THEN
         Create_Order_Com_Header( olc_rec_.commission_no, olc_rec_.order_no, olc_rec_.line_no, olc_rec_.rel_no, olc_rec_.line_item_no, olc_rec_.commission_receiver);
      END IF;
   END IF;

   -- update the calculation date
   olc_rec_.calculation_date := Site_API.Get_Site_Date(olc_rec_.contract);


   -- update the commission line data
   IF (is_new_rec_ = 1) THEN
      IF (NVL(olc_rec_.total_commission_amount, 0) != 0) THEN
         temp_olc_rec_:= Order_Line_Commission_API.Create_Order_Commission_Line(
            olc_rec_.order_no, olc_rec_.line_no, olc_rec_.rel_no, olc_rec_.line_item_no, olc_rec_.contract,
            Customer_Order_API.Get_Customer_No(olc_rec_.order_no), olc_rec_.commission_receiver, olc_rec_.commission_line_source);
         
         olc_rec_.commission_line_no := temp_olc_rec_.commission_line_no;
         olc_rec_.rowkey             := temp_olc_rec_.rowkey; 
         
         Order_Line_Commission_API.Modify(olc_rec_);
         -- change the state of the commission line
         Order_Line_Commission_API.Calculate(olc_rec_.order_no, olc_rec_.line_no, olc_rec_.rel_no, olc_rec_.line_item_no, olc_rec_.commission_line_no);
      END IF;
   ELSE
      -- initialize all columns to zero if RMA exist for the order line and total invoice amount becomes zero
      IF (olc_rec_.amount = 0 ) THEN 
         IF (olc_rec_.commission_line_source = 'SYSTEM' OR (NVL(olc_rec_.commission_amount,0) = 0 AND NVL(olc_rec_.commission_percentage,0)= 0)) THEN
            olc_rec_.total_estimated_com_amount :=0;
            olc_rec_.total_commission_amount :=0;
            olc_rec_.commission_amount :=0;
            olc_rec_.commission_percentage := 0;
            olc_rec_.commission_percentage_calc := 0;
            olc_rec_.commission_amount_calc := 0;
         END IF;   
      END IF;
      Order_Line_Commission_API.Modify(olc_rec_);
      -- change the state of the commission line
      IF (olc_rec_.rowstate = 'Created') THEN
         Order_Line_Commission_API.Calculate(olc_rec_.order_no, olc_rec_.line_no, olc_rec_.rel_no, olc_rec_.line_item_no, olc_rec_.commission_line_no);
      ELSE
         Order_Line_Commission_API.Recalculate(olc_rec_.order_no, olc_rec_.line_no, olc_rec_.rel_no, olc_rec_.line_item_no, olc_rec_.commission_line_no);
      END IF;
   END IF;

   -- clear the commission recalc flag (must be done after the modify)
   Order_Line_Commission_API.Reset_Order_Com_Lines_Changed(
      olc_rec_.order_no, olc_rec_.line_no, olc_rec_.rel_no, olc_rec_.line_item_no, olc_rec_.commission_receiver);
   Order_Line_Commission_API.Set_Line_Exclude_Flag(olc_rec_.order_no, olc_rec_.line_no, olc_rec_.rel_no, olc_rec_.line_item_no, 'FALSE');

END Calculate_Commission_Line___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Calc_Com_Line_Data__
--   Private method to fetch a commission (percentage, amount)
--   from the agreements based on the basic date in the order
--   commission line.
PROCEDURE Calc_Com_Line_Data__ (
   order_no_               IN VARCHAR2,
   line_no_                IN VARCHAR2,
   rel_no_                 IN VARCHAR2,
   line_item_no_           IN NUMBER,
   commission_receiver_    IN VARCHAR2,
   overwrite_manual_data_  IN NUMBER )
IS
   olc_rec_                  ORDER_LINE_COMMISSION_TAB%ROWTYPE;
   record_found_             BOOLEAN := FALSE;
   line_type_                VARCHAR2(8);
   open_lines_count_         NUMBER := 0;
   manual_line_              NUMBER := 0;
   
   CURSOR exist_open_item IS
      SELECT olc.*
        FROM ORDER_LINE_COMMISSION_TAB olc
       WHERE olc.order_no     = order_no_
         AND olc.line_no      = line_no_
         AND olc.rel_no       = rel_no_
         AND olc.line_item_no = line_item_no_
         AND olc.commission_receiver = commission_receiver_
         AND olc.fixed_commission_amount = 'NORMAL'
         AND olc.rowstate NOT IN ('Cancelled', 'Closed');

   CURSOR source_item IS
      SELECT olc.*
        FROM ORDER_LINE_COMMISSION_TAB olc
       WHERE olc.order_no     = order_no_
         AND olc.line_no      = line_no_
         AND olc.rel_no       = rel_no_
         AND olc.line_item_no = line_item_no_
         AND olc.commission_receiver = commission_receiver_
         AND olc.fixed_commission_amount = 'NORMAL'
         AND olc.rowstate = 'Closed'
         AND olc.commission_line_source NOT IN ('MANUAL', 'CORRECTION')
         ORDER BY olc.commission_line_no;

BEGIN


   FOR olc_rec_ IN exist_open_item LOOP
      --Find open lines. It is possible to have one CORRECTION and one MANUAL line open at a time.
      record_found_ := TRUE;
      line_type_ := 'OPEN';
      open_lines_count_ := open_lines_count_ + 1;

      IF olc_rec_.commission_line_source = 'MANUAL' THEN
         manual_line_ := 1;
      END IF;

      Calculate_Commission_Line___(olc_rec_, overwrite_manual_data_, line_type_);
   END LOOP;


   --If only MANUAL open line exist, then corrections may need to be created for 
   --closed system generated lines.

   IF NOT (record_found_) OR (open_lines_count_ = 1 AND manual_line_ = 1) THEN
      --Find closed line. Used as basis for creating correction lines. 
      record_found_ := FALSE;
      OPEN source_item;
      FETCH source_item INTO olc_rec_;
      IF (source_item%FOUND) THEN
         line_type_ := 'CLOSED';
         record_found_ := TRUE;
      END IF;
      CLOSE source_item; 

      IF (record_found_) THEN
         Calculate_Commission_Line___(olc_rec_, overwrite_manual_data_, line_type_);
      END IF;
   END IF;

END Calc_Com_Line_Data__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Create_Order_Com_Header
--   Public method which creates a commission header from order commission lines
--   and from the corresponding valid agreement, if this not already exists.
--   If it will exist, the commission no will be returned.
PROCEDURE Create_Order_Com_Header (
   commission_no_       OUT NUMBER,
   order_no_            IN  VARCHAR2,
   line_no_             IN  VARCHAR2,
   rel_no_              IN  VARCHAR2,
   line_item_no_        IN  NUMBER,
   commission_receiver_ IN  VARCHAR2 ) 
IS
   cust_ord_date_entered_  DATE;
   cust_ord_site_          ORDER_COMMISSION_TAB.contract%TYPE;   
   commission_calc_status_ ORDER_COMMISSION_TAB.commission_calc_status%TYPE;
   date_until_             DATE;
   previous_date_until_    DATE;
   next_date_from_         DATE;
   current_date_           DATE;
   temp_                   ORDER_LINE_COMMISSION_TAB.commission_line_no%TYPE;

   CURSOR get_first_previous_date_until(date_ DATE) IS
      SELECT MAX(period_until)
        FROM ORDER_COMMISSION_TAB
       WHERE period_until < date_
         AND contract = cust_ord_site_
         AND commission_receiver = commission_receiver_;

   CURSOR get_next_date_from(date_ DATE) IS
      SELECT MIN(period_from)
        FROM ORDER_COMMISSION_TAB
       WHERE period_from > date_
         AND contract = cust_ord_site_
         AND commission_receiver = commission_receiver_;

   CURSOR exist_control(date_ DATE) IS
      SELECT commission_no, commission_calc_status, period_until
        FROM ORDER_COMMISSION_TAB
       WHERE period_from <= date_
         AND period_until >= date_
         AND contract = cust_ord_site_
         AND commission_receiver = commission_receiver_;

   -- to check the commission line is invoice based indirectly
   CURSOR check_invoice_base IS
      SELECT commission_line_no
      FROM order_line_commission_tab
      WHERE order_no = order_no_
      AND   line_no =line_no_
      AND   rel_no = rel_no_
      AND   line_item_no = line_item_no_
      AND   commission_receiver = commission_receiver_
      AND   commission_calc_base = 'INVOICED';

BEGIN
   cust_ord_site_ := Customer_Order_Line_API.Get_Contract(order_no_, line_no_, rel_no_, line_item_no_);
   -- fetch the necessary data throught the functions:
   -- we don't know if the other values are up to date
   -- first check the commission_calculation basis(invoiced)
   OPEN check_invoice_base ;
   FETCH check_invoice_base INTO temp_;
   IF (check_invoice_base%NOTFOUND ) THEN
      -- then the commission line is order based
      cust_ord_date_entered_ := Customer_Order_Line_API.Get_Date_Entered(order_no_, line_no_, rel_no_, line_item_no_);
   ELSE
      -- then the commission line is Invoice based, if invoice exist use Invoice date for the date entered
      IF (Check_Invoice_Exist(order_no_, line_no_, rel_no_,line_item_no_,cust_ord_site_) >0) THEN
         cust_ord_date_entered_ := Customer_Order_Inv_Item_API.Get_Order_line_Invoice_Date(order_no_, line_no_, rel_no_, line_item_no_);
      ELSE
         cust_ord_date_entered_ := Customer_Order_Line_API.Get_Date_Entered(order_no_, line_no_, rel_no_, line_item_no_);
      END IF;
   END IF;
   CLOSE check_invoice_base;

   current_date_ := TRUNC(cust_ord_date_entered_);

   -- initialize last_date_until_
   OPEN get_first_previous_date_until(current_date_);
   FETCH get_first_previous_date_until INTO previous_date_until_;
   IF (get_first_previous_date_until%NOTFOUND OR previous_date_until_ IS NULL) THEN
      previous_date_until_ := Commission_Receiver_API.Get_Period_Date_From(commission_receiver_, current_date_) - 1;
   END IF;
   CLOSE get_first_previous_date_until;

   WHILE TRUE LOOP
      -- check if an opened commission header is already existing
      OPEN exist_control(current_date_);
      FETCH exist_control INTO commission_no_, commission_calc_status_, date_until_;
      -- no record has been found
      IF (exist_control%NOTFOUND) THEN
         -- initialize next_date_from_
         OPEN get_next_date_from(current_date_);
         FETCH get_next_date_from INTO next_date_from_;
         date_until_ := Commission_Receiver_API.Get_Period_Date_Until(commission_receiver_, current_date_);
         IF (get_next_date_from%FOUND AND next_date_from_ IS NOT NULL) THEN
            date_until_ := LEAST(date_until_, next_date_from_ - 1);
         END IF;
         CLOSE get_next_date_from;
         -- a new header should be created
         Order_Commission_API.New(
            commission_no_,
            GREATEST(Commission_Receiver_API.Get_Period_Date_From(commission_receiver_, current_date_), previous_date_until_ + 1),
            date_until_,
            commission_receiver_,
            cust_ord_site_
         );
         CLOSE exist_control;
         EXIT;
      -- a record exists
      ELSE
         CLOSE exist_control;
         -- the record is opened
         IF (commission_calc_status_ <> 'FINALLYCALCULATED') THEN
            EXIT;
         -- the record was not usable, we are going on in the loop looking for an other one
         ELSE
            current_date_ := date_until_ + 1;
            previous_date_until_ := date_until_;
         END IF;
      END IF;
   END LOOP;

END Create_Order_Com_Header;


-- Calc_Com_From_Cust_Ord
--   Public Method for (re-)calculation of commission order lines/
--   headers, if they exist for a selected customer order.
PROCEDURE Calc_Com_From_Cust_Ord (
   info_                  OUT VARCHAR2,
   order_no_              IN  VARCHAR2,
   overwrite_manual_data_ IN  NUMBER )
IS
   CURSOR loop_com_lines IS
      SELECT DISTINCT
             olc.order_no,
             olc.line_no,
             olc.rel_no,
             olc.line_item_no
      FROM   customer_order_line_tab col, order_line_commission_tab olc
      WHERE  col.order_no = olc.order_no
      AND    col.line_no  = olc.line_no
      AND    col.rel_no   = olc.rel_no
      AND    col.line_item_no = olc.line_item_no
      AND    col.rowstate <> 'Cancelled'
      AND    olc.order_no = order_no_
      AND    col.line_item_no <= 0
      AND    col.rental = 'FALSE';
BEGIN
   FOR com_line_ IN loop_com_lines LOOP
      Calc_Com_From_Cust_Ord_Line(info_, com_line_.order_no, com_line_.line_no, com_line_.rel_no, com_line_.line_item_no, overwrite_manual_data_);
   END LOOP;
END Calc_Com_From_Cust_Ord;


-- Calc_Com_From_Cust_Ord_Line
--   Public Method for recalculation of commission order lines/ headers,
--   if they exist for a selected customer order line.
PROCEDURE Calc_Com_From_Cust_Ord_Line (
   info_                        OUT VARCHAR2,
   order_no_                    IN  VARCHAR2,
   line_no_                     IN  VARCHAR2,
   rel_no_                      IN  VARCHAR2,
   line_item_no_                IN  NUMBER,
   overwrite_manual_data_       IN  NUMBER,
   commission_receiver_         IN  VARCHAR2 DEFAULT NULL,
   commission_receiver_group_   IN  VARCHAR2 DEFAULT NULL )
IS
   CURSOR loop_com_lines IS
      SELECT DISTINCT
             olc.order_no,
             olc.line_no,
             olc.rel_no,
             olc.line_item_no,
             olc.commission_receiver,
             fixed_commission_amount
      FROM   customer_order_line_tab col, commission_receiver_tab cr, order_line_commission_tab olc
      WHERE  olc.commission_receiver LIKE NVL(commission_receiver_,'%')
      AND    NVL(cr.commission_receiver_group, '%') LIKE NVL(commission_receiver_group_,'%')
      AND    cr.commission_receiver = olc.commission_receiver
      AND    col.order_no = olc.order_no
      AND    col.line_no = olc.line_no
      AND    col.rel_no = olc.rel_no
      AND    col.line_item_no = olc.line_item_no
      AND    col.rowstate <> 'Cancelled'
      AND    olc.order_no = order_no_
      AND    olc.line_no = line_no_
      AND    olc.rel_no = rel_no_
      AND    olc.line_item_no = line_item_no_
      AND    col.line_item_no <= 0
      AND    col.rental = 'FALSE';

   CURSOR com_lines_exist(fixed_commission_amount_ VARCHAR2) IS
      SELECT 1
      FROM   order_line_commission_tab olc
      WHERE  olc.commission_receiver = commission_receiver_
      AND    olc.order_no = order_no_
      AND    olc.line_no = line_no_
      AND    olc.rel_no = rel_no_
      AND    olc.line_item_no = line_item_no_
      AND    olc.fixed_commission_amount = fixed_commission_amount_;

   went_fixed_line_ NUMBER:=0;   
BEGIN
   IF (INSTR(NVL(commission_receiver_, '%'), '%') > 0) THEN
      FOR com_line_ IN loop_com_lines LOOP
         IF (com_line_.fixed_commission_amount = 'FIXED') THEN
            IF (went_fixed_line_ = 0) THEN
               went_fixed_line_ := 1;
               Handle_Fixed_Com_Lines___(order_no_,line_no_,rel_no_,line_item_no_,com_line_.commission_receiver);         
            END IF;
         ELSE
            Calc_Com_Line_Data__(com_line_.order_no, com_line_.line_no, com_line_.rel_no,
                                 com_line_.line_item_no, com_line_.commission_receiver, overwrite_manual_data_);            
         END IF;       
      END LOOP; 
   ELSE     
      OPEN com_lines_exist('FIXED');
      FETCH com_lines_exist INTO went_fixed_line_;
      IF com_lines_exist%FOUND THEN
            Handle_Fixed_Com_Lines___(order_no_, line_no_, rel_no_, line_item_no_, commission_receiver_);
      END IF;
      CLOSE com_lines_exist;
      OPEN com_lines_exist('NORMAL');
      FETCH com_lines_exist INTO went_fixed_line_;
      IF com_lines_exist%FOUND THEN
         Calc_Com_Line_Data__(order_no_, line_no_, rel_no_, line_item_no_, commission_receiver_, overwrite_manual_data_);                 
      END IF;
      CLOSE com_lines_exist;
   END IF;

   Order_Line_Commission_API.Check_Total_Com_Amount__(order_no_, line_no_, rel_no_, line_item_no_, commission_receiver_ => commission_receiver_);   
   
   info_ := Client_SYS.Get_All_Info;
END Calc_Com_From_Cust_Ord_Line;


-- Recalc_Com_From_Com_Header
--   Public Method for recalculation of header for corresponding order
--   commission lines.
PROCEDURE Recalc_Com_From_Com_Header (
   info_                  OUT VARCHAR2,
   commission_no_         IN  NUMBER,
   overwrite_manual_data_ IN  NUMBER )
IS
   CURSOR loop_com_lines IS
      SELECT DISTINCT
             olc.order_no,
             olc.line_no,
             olc.rel_no,
             olc.line_item_no
      FROM   customer_order_line_tab col, order_line_commission_tab olc
      WHERE  col.order_no = olc.order_no
      AND    col.line_no = olc.line_no
      AND    col.rel_no = olc.rel_no
      AND    col.line_item_no = olc.line_item_no
      AND    col.rowstate <> 'Cancelled'
      AND    olc.commission_no = commission_no_
      AND    col.line_item_no <= 0
      AND    col.rental = 'FALSE';
BEGIN

   IF (Order_Commission_API.Get_Commission_Calc_Status(commission_no_)= Commission_Calc_Status_API.Decode('FINALLYCALCULATED')) THEN
      Error_Sys.System_General('RECALC_COM_FROM_COM_HEADER: A closed commission header can''t be recalculated');
   END IF;

   FOR com_line_ IN loop_com_lines LOOP
      Calc_Com_From_Cust_Ord_Line(info_, com_line_.order_no, com_line_.line_no, com_line_.rel_no, com_line_.line_item_no, overwrite_manual_data_);
   END LOOP;
   -- update the calculation date

   Order_Commission_API.Set_Last_Calculation_Date(commission_no_);

END Recalc_Com_From_Com_Header;


-- Batch_Commission_Calc
--   Public mehtod for the batch commission calculation.
PROCEDURE Batch_Commission_Calc (
   attr_     IN VARCHAR2 )
IS
   ptr_                       NUMBER;
   name_                      VARCHAR2(30);
   value_                     VARCHAR2(2000);
   attr2_                     VARCHAR2(2000);
   info_                      VARCHAR2(2000);
   commission_receiver_       VARCHAR2(20);
   commission_receiver_group_ VARCHAR2(10);
   date_until_                DATE;
   contract_                  VARCHAR2(5);
   company_                   VARCHAR2(20);
 
   include_calculated_lines_  VARCHAR2(5);

   CURSOR get_com_lines IS
      SELECT DISTINCT ol.order_no, ol.line_no, ol.rel_no, ol.line_item_no, ol.commission_receiver, cr.commission_receiver_group
      FROM   customer_order_line_tab cl, commission_receiver_tab cr, order_line_commission_tab ol
      WHERE  ol.commission_receiver LIKE commission_receiver_
      AND    NVL(cr.commission_receiver_group, '%') LIKE commission_receiver_group_
      AND    cr.commission_receiver = ol.commission_receiver
      AND    TRUNC(cl.date_entered) <= TRUNC(date_until_)
      AND    cl.order_no = ol.order_no
      AND    cl.line_no = ol.line_no
      AND    cl.rel_no = ol.rel_no
      AND    cl.line_item_no = ol.line_item_no
      AND    cl.contract = contract_
      AND    cl.rowstate <> 'Cancelled'
      AND    (ol.commission_no IS NULL OR include_calculated_lines_ = 'TRUE' OR
              ol.commission_recalc_flag = 'NEEDCALCULATION')
      AND    cl.line_item_no <= 0
      AND    cl.rental = 'FALSE'
      AND    (ol.commission_calc_base = 'ORDER' OR NOT EXISTS (SELECT 1
                                                               FROM  customer_order_inv_item i
                                                               WHERE i.contract     = contract_
                                                               AND   i.order_no     = ol.order_no
                                                               AND   i.line_no      = ol.line_no
                                                               AND   i.release_no   = ol.rel_no
                                                               AND   i.line_item_no = ol.line_item_no
                                                               AND   i.rental_transaction_id IS NULL))
      UNION
      SELECT DISTINCT ol.order_no, ol.line_no, ol.rel_no, ol.line_item_no, ol.commission_receiver, cr.commission_receiver_group
      FROM   customer_order_line_tab cl, commission_receiver_tab cr, order_line_commission_tab ol
      WHERE  ol.commission_receiver LIKE commission_receiver_
      AND    NVL(cr.commission_receiver_group, '%') LIKE commission_receiver_group_
      AND    cr.commission_receiver = ol.commission_receiver
      AND    cl.order_no = ol.order_no
      AND    cl.line_no = ol.line_no
      AND    cl.rel_no = ol.rel_no
      AND    cl.line_item_no = ol.line_item_no
      AND    cl.contract = contract_
      AND    cl.rowstate <> 'Cancelled'      
      AND    ((ol.commission_no IS NULL AND line_exclude_flag != 'FALSE' ) OR include_calculated_lines_ = 'TRUE' OR
               ol.commission_recalc_flag = 'NEEDCALCULATION')
      AND    ol.commission_calc_base = 'INVOICED'
      AND    cl.line_item_no <= 0
      AND    cl.rental = 'FALSE'
      AND EXISTS (SELECT 1 
                  FROM  customer_order_inv_item i
                  WHERE i.contract     = contract_
                  AND   i.order_no     = ol.order_no
                  AND   i.line_no      = ol.line_no
                  AND   i.release_no   = ol.rel_no
                  AND   i.line_item_no = ol.line_item_no
                  AND   i.rental_transaction_id IS NULL
                  AND EXISTS (SELECT 1 
                              FROM customer_order_inv_head ih
                              WHERE ih.company = company_
                              AND   ih.invoice_id = i.invoice_id
                              AND TRUNC(date_until_) >= TRUNC(ih.invoice_date)));
BEGIN
   attr2_ := attr_;
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr2_, ptr_, name_, value_)) LOOP
      IF (name_ = 'CONTRACT') THEN
         contract_ := value_;
      ELSIF (name_ = 'COMMISSION_RECEIVER') THEN
         commission_receiver_ := value_;
      ELSIF (name_ = 'COMMISSION_RECEIVER_GROUP') THEN
         commission_receiver_group_ := value_;
      ELSIF (name_ = 'DATE_UNTIL') THEN
         date_until_ := Client_SYS.Attr_Value_To_Date(value_);
      ELSIF (name_ = 'INCLUDE_CALCULATED_LINES') THEN
         include_calculated_lines_ := value_;
      ELSE
         Error_SYS.Item_Not_Exist(lu_name_, name_, value_);
      END IF;
   END LOOP;
   Client_SYS.Clear_Attr(attr2_);
   commission_receiver_ := NVL(commission_receiver_, '%');
   commission_receiver_group_ := NVL(commission_receiver_group_, '%');
   include_calculated_lines_ := NVL(include_calculated_lines_, 'FALSE');
   company_ := Site_API.Get_Company(contract_);

   FOR rec_ IN get_com_lines LOOP
      BEGIN
         @ApproveTransactionStatement(2012-01-24,GanNLK)
         SAVEPOINT calc_com_data;
         Calc_Com_From_Cust_Ord_Line(info_, rec_.order_no, rec_.line_no, rec_.rel_no, rec_.line_item_no, 0, rec_.commission_receiver, rec_.commission_receiver_group);
         @ApproveTransactionStatement(2012-01-24,GanNLK)
         COMMIT;
      EXCEPTION
         WHEN others THEN
            @ApproveTransactionStatement(2012-01-24,GanNLK)
            ROLLBACK TO calc_com_data;
            info_ := Language_sys.Translate_Constant(lu_name_, 'ERR1: Error in Order :P1 on line :P2 - :P3', NULL, rec_.order_no, rec_.line_no, SUBSTR(SQLERRM, 1, 255));
            Trace_SYS.Message(info_);
            Transaction_SYS.Log_Status_Info (info_);         
      END;
   END LOOP;

END Batch_Commission_Calc;


-- Init_Batch_Commission_Calc
--   Public method for generating a background job for the
--   batch commission calculation.
PROCEDURE Init_Batch_Commission_Calc (
   commission_receiver_       IN VARCHAR2,
   commission_receiver_group_ IN VARCHAR2,
   date_until_                IN DATE,
   contract_                  IN VARCHAR2,
   include_calculated_lines_  IN VARCHAR2 DEFAULT 'FALSE')
IS
   desc_  VARCHAR2(200);
   attr_  VARCHAR2(2000);
BEGIN
   Trace_SYS.Field('COMMISSION_RECEIVER', commission_receiver_);
   Trace_SYS.Field('COMMISSION_RECEIVER_GROUP', commission_receiver_group_);
   Trace_SYS.Field('DATE_UNTIL', date_until_);
   Trace_SYS.Field('CONTRACT', contract_);

   -- Check the parameter values
   Site_API.Exist(contract_);

   -- allow wildcard %
   IF ((commission_receiver_group_ IS NOT NULL) AND (commission_receiver_group_ != '%')) THEN
      Commission_Receiver_Group_API.Exist(commission_receiver_group_, true);
   ELSE
      Error_SYS.Check_Not_Null(lu_name_, 'COMMISSION_RECEIVER_GROUP', commission_receiver_group_);
   END IF;

   -- allow wildcard %
   IF ((commission_receiver_ IS NOT NULL) AND (commission_receiver_ != '%')) THEN
      Commission_Receiver_API.Exist(commission_receiver_,TRUE);
   ELSE
      Error_SYS.Check_Not_Null(lu_name_, 'COMMISSION_RECEIVER', commission_receiver_);
   END IF;

   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_);
   Client_SYS.Add_To_Attr('COMMISSION_RECEIVER_GROUP', commission_receiver_group_, attr_);
   Client_SYS.Add_To_Attr('COMMISSION_RECEIVER', commission_receiver_, attr_);
   Client_SYS.Add_To_Attr('DATE_UNTIL', date_until_, attr_);
   Client_SYS.Add_To_Attr('INCLUDE_CALCULATED_LINES', include_calculated_lines_, attr_);

   desc_ := Language_SYS.Translate_Constant(lu_name_, 'ORDER_COM_CALC: Calculate Order Commission.');
   Transaction_SYS.Deferred_Call('COMMISSION_CALCULATION_API.Batch_Commission_Calc', attr_, desc_);
END Init_Batch_Commission_Calc;


-- Get_Total_Com_Amount
--   Public method for calculating the total commission amount
--   using the basic data and the manual inserted/ updated commission
--   percentage and/ or amount.
FUNCTION Get_Total_Com_Amount (
   order_no_               IN VARCHAR2,
   line_no_                IN VARCHAR2,
   rel_no_                 IN VARCHAR2,
   line_item_no_           IN NUMBER,
   commission_line_no_     IN NUMBER,
   commission_percentage_  IN NUMBER,
   commission_amount_      IN NUMBER ) RETURN NUMBER
IS
   olc_rec_        ORDER_LINE_COMMISSION_TAB%ROWTYPE;
   company_        COMPANY_TAB.COMPANY%TYPE;
   curr_rounding_  NUMBER;

   CURSOR order_line_commission IS
      SELECT olc.*
      FROM   ORDER_LINE_COMMISSION_TAB olc
      WHERE  olc.order_no = order_no_
      AND    olc.line_no = line_no_
      AND    olc.rel_no = rel_no_
      AND    olc.line_item_no = line_item_no_
      AND    olc.commission_line_no = commission_line_no_;
BEGIN
   -- returns the total commission amount of the order line commission
   -- using the sames logic than Calculate_Total_Com_Amount___
   OPEN order_line_commission;
   FETCH order_line_commission INTO olc_rec_;
   CLOSE order_line_commission;

   company_ := Site_API.Get_Company(olc_rec_.contract);
   curr_rounding_ := Currency_Code_API.Get_Currency_Rounding(company_, Company_Finance_API.Get_Currency_Code(company_));

   RETURN Calculate_Total_Com_Amount___(olc_rec_, curr_rounding_, commission_percentage_, commission_amount_ );
END Get_Total_Com_Amount;


-- Get_Amount_In_Currency
--   Public method for transferring the amount from base currency to the
--   currency specified in the parameters.
FUNCTION Get_Amount_In_Currency (
   currency_rate_ OUT NUMBER,
   customer_no_   IN  VARCHAR2,
   contract_      IN  VARCHAR2,
   curr_code_     IN  VARCHAR2,
   curr_date_     IN  DATE,
   base_amount_   IN  NUMBER ) RETURN NUMBER
IS
   curr_amount_       NUMBER;
   company_           VARCHAR2(20);
   rounding_          NUMBER;
   curr_type_         VARCHAR2(10);
   conv_factor_       NUMBER;
   rate_              NUMBER;
BEGIN
   company_ := Site_API.Get_Company(contract_);
   Invoice_Library_API.Get_Currency_Rate_Defaults(curr_type_,
                                                  conv_factor_,
                                                  rate_,
                                                  company_,
                                                  curr_code_,
                                                  curr_date_,
                                                  'CUSTOMER',
                                                  customer_no_);
   rounding_ := Currency_Code_API.Get_Currency_Rounding(company_, curr_code_);
   rate_ := rate_ / conv_factor_;
   IF (Company_Finance_API.Get_Currency_Code(company_) = curr_code_) THEN
      curr_amount_ := base_amount_;
   ELSIF (rate_ = 0) THEN
      curr_amount_ := 0;
   ELSE
      curr_amount_ := round(base_amount_ / rate_, rounding_);
   END IF;
   currency_rate_ := rate_;
   RETURN curr_amount_;
END Get_Amount_In_Currency;


-- Get_Base_Amount_In_Currency
--   Public method for transferring the amount into an amount in base currency.
FUNCTION Get_Base_Amount_In_Currency (
   currency_rate_  OUT NUMBER,
   customer_no_    IN  VARCHAR2,
   contract_       IN  VARCHAR2,
   curr_code_      IN  VARCHAR2,
   curr_date_      IN  DATE,
   curr_amount_    IN  NUMBER ) RETURN NUMBER
IS
   base_amount_   NUMBER;
   company_       VARCHAR2(20);
   rounding_      NUMBER;
   curr_type_     VARCHAR2(10);
   conv_factor_   NUMBER;
   rate_          NUMBER;
BEGIN
   company_ := Site_API.Get_Company(contract_);
   Invoice_Library_API.Get_Currency_Rate_Defaults(curr_type_,
                                                  conv_factor_,
                                                  rate_,
                                                  company_,
                                                  curr_code_,
                                                  curr_date_,
                                                  'CUSTOMER',
                                                  customer_no_);
   rate_ := rate_ / conv_factor_;
   rounding_ := Currency_Code_API.Get_Currency_Rounding(company_, Company_Finance_API.Get_Currency_Code(company_));
   base_amount_ := round(curr_amount_ * rate_, rounding_);
   currency_rate_ := rate_;
   RETURN base_amount_;
END Get_Base_Amount_In_Currency;


-- Check_Invoice_Exist
--   This will return 1 when Order Line has an Invoice.
@UncheckedAccess
FUNCTION Check_Invoice_Exist (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   contract_     IN VARCHAR2 ) RETURN NUMBER
IS
   invoice_item_exist_          NUMBER:=0;

   CURSOR exist_invoice_item IS
      SELECT 1
      FROM CUSTOMER_ORDER_INV_ITEM
      WHERE contract     = contract_
      AND   order_no     = order_no_
      AND   line_no      = line_no_
      AND   release_no   = rel_no_
      AND   line_item_no = line_item_no_;
BEGIN
   OPEN exist_invoice_item ;
   FETCH exist_invoice_item  INTO invoice_item_exist_;
   IF exist_invoice_item%NOTFOUND THEN
      invoice_item_exist_ :=0;
   END IF;
   CLOSE exist_invoice_item;
   RETURN invoice_item_exist_;
END Check_Invoice_Exist;

-- Check_Cancelled_Invoice_Exist
--   This will return 1 when Order Line has an Cancelled Invoice.
@UncheckedAccess
FUNCTION Check_Cancelled_Invoice_Exist (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   contract_     IN VARCHAR2 ) RETURN NUMBER
IS
   invoice_item_exist_          NUMBER:=0;

   CURSOR exist_invoice_item IS
      SELECT 1
      FROM CUSTOMER_ORDER_INV_ITEM_ALL
      WHERE contract     = contract_
      AND   order_no     = order_no_
      AND   line_no      = line_no_
      AND   release_no   = rel_no_
      AND   line_item_no = line_item_no_;
BEGIN
   OPEN exist_invoice_item ;
   FETCH exist_invoice_item  INTO invoice_item_exist_;
   IF exist_invoice_item%NOTFOUND THEN
      invoice_item_exist_ :=0;
   END IF;
   CLOSE exist_invoice_item;
   RETURN invoice_item_exist_;
END Check_Cancelled_Invoice_Exist;


