-----------------------------------------------------------------------------
--
--  Logical unit: CustOrdStatUtil
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  180502  DiKuLk  Bug 140211, Modified Do_Gen_Invoiced_Stat__() to increase the lenght of rma_market_desc_ from 35 to 200.
--  170507  NipKlk  STRSC-2566, Added rate correction invoice check to set zero cost and quantity for all rate correction invoice types in the method Do_Gen_Invoiced_Stat__().
--  170208  NWeelk  FINHR-5928, Modified Calc_Amounts_Order___ and Calc_Amounts_Return___ to use central logic to calculate tax amounts.
--  160622  MeAblk  Bug 129835, Modified Do_Gen_Invoiced_Stat__() to avoid converting the invoiced_qty into a negative value when creating any invoiced which is considered as a correction invoice.
--  160419  IsSalk  FINHR-1589, Move server logic of RmaLineTaxLines to common LU (Source Tax Item Order).
--  151103  IsSalk  FINHR-316, Renamed attribute FEE_CODE to TAX_CODE in Customer Order Line.
--  150526  IsSalk  KES-510, Modified cursors with Customer_Order_Delivery_TAB to filter out cancelled CO deliver lines.
--  141120  NaLrlk  Modified Do_Gen_Deli_Reliab_Stat__, Do_Gen_Deli_Quality_Stat__, Do_Gen_Backlog_Stat__and Do_Gen_Invoiced_Stat__ to exclude rental lines. 
--  140811  AyAmlk  Bug 118068, Modified Do_Gen_Invoiced_Stat__() in order to treat Correction Invoice lines and Collective Correction Invoice lines which are not connected to RMA
--  140811          although the header has an RMA reference, as Price adjusted lines.
--  140324  MaEdlk  Bug 116034, Modified method Do_Gen_Backlog_Stat__ to insert backlog_qty_to_deliver into cust_ord_back_stat_tab.
--  140307  HimRlk  Merged Bug 110133 - PIV, Modified method Do_Gen_Invoiced_Stat__, Calc_Amounts_Return___, Calc_Amounts_Order___ by changing Calculation logic of line discount amount to be consistent with discount postings.
--  140307          Calc_Amounts_Order___, Calc_Amounts_Return___ changed the logic of calculating net_base_amount_. net_base_amount_ = net_curr_amount_ * curr_rate_.
--  130822  NWeelk  Bug 111252, Modified method Do_Gen_Invoiced_Stat__ to get additional discount from the invocie line.
--  130815  SBalLK  Bug 110168, Modified Do_Gen_Invoiced_Stat__() method by updating where clause in get_invoice_line cursor to truncate last run date to avoid missing back dated invoices.
--  130730  RuLiLk  Bug 110133, Modified method Do_Gen_Invoiced_Stat__, Calc_Amounts_Return___, Calc_Amounts_Order___ by changing Calculation logic of line discount amount to be consistent with discount postings.
--  130730          Calc_Amounts_Order___, changed the logic of calculating net_base_amount_. net_base_amount_ = net_curr_amount_ * curr_rate_.
--  130730          Calc_Amounts_Return___, for returns, net_base_amount_ is calculated seperately without useing net_curr_amount_.
--  130730          Removed method Calc_Discount_Amount___.
--  120516  Darklk  Bug 99815, Modified the procedure Do_Gen_Invoiced_Stat__ in order to fetch the value for cost correctly.
--  121012  NipKlk  Bug 102071, Modified method Generate_Cust_Ord_Stat and removed encode method of Ord_Aggregate_Issue_API. 
--  121012          Modified method Validate_Params and checked for db values instead of client values.
--  120313  MaMalk  Bug 99430, Modified procedures Do_Gen_Deli_Reliab_Stat__,Do_Gen_Deli_Quality_Stat__, Do_Gen_Backlog_Stat__ and Do_Gen_Invoiced_Stat__ to include inverted conversion factor logic.
--  120308  MeAblk  Bug 100782, Modified the procedure Do_Gen_Invoiced_Stat__ in order to insert price_source_id and price_source into the table CUST_ORD_INVO_STAT_TAB.
--  110816  NWeelk  Bug 98069, Modified method Do_Gen_Invoiced_Stat__ by changing method call from Get_Charge_Cost to Get_Total_Base_Charged_Cost to get the cost correctly. 
--  110330  AndDse  BP-4760, Modified Do_Gen_Deli_Reliab_Stat__ due to changes in Cust_Ord_Date_Calculation.
--  110316  AndDse  BP-4453, Modified Do_Gen_Deli_Reliab_Stat__ to consider the external transport calendar.
--  110225  MalLlk  Replaced cust_ord_invo_stat with cust_ord_invo_stat_tab in cursor get_invoice_line in Do_Gen_Invoiced_Stat__.
--  101015  MaMalk  Removed rounding applied on curr_discount_, order_curr_discount_and add_curr_discount_ in PROCEDURE Calc_Amounts_Return___.   
--  100920  MUSHLK  EAPM-4461, Modified the where clause of CURSOR get_invoice_line in Do_Gen_Invoiced_Stat__ to filter for the company.
--  100914  Swralk  SAP-SUCKER DF-296, Removed rounding applied by DF-40 on curr_discount_, order_curr_discount_and add_curr_discount_ in PROCEDURE Calc_Amounts_Order___.
--  100906  MaMalk  Modified Calc_Amounts_Return___ to correctly round the amounts.    
--  100726  Swralk  SAP-SUCKER DF-40 Added currency code as a parameter to function Calc_Amounts_Return___.
--  100723  Swralk  SAP-SUCKER DF-40 Corrected rounding errors.
--  100603  MoNilk  Replaced the calls to Application_Country_API with Iso_Country_API.
--  100520  KRPELK  Merge Rose Method Documentation.
--  100304  SaJjlk  Bug 88067, Modified method Do_Gen_Invoiced_Stat__ to retrieve the region and district codes from the customer
--  100304          order header when there exist charges that are not connected to customer order lines.
--  100105  NWeelk  Bug 88012, Added condition_code and condition_code_description to be included in statictics in Do_Gen_Invoiced_Stat__.
--  091202  MaMalk  Modified Generate_Cust_Ord_Stat to check the value of company before executing the other methods.
--  091110  MaMalk  Introduced company parameter to Do_Gen_Deli_Reliab_Stat__, Do_Gen_Deli_Quality_Stat__, Do_Gen_Backlog_Stat__ and Do_Gen_Invoiced_Stat__ 
--  091110          and modified the methods to create statistics in company level. Removed method Check_If_All_Companies__.Replaced parameter issue with message
--  091110          in method Generate_Cust_Ord_Stat and modified the method. Made Generate_Cust_Ord_Stat_Defer private, introduced parameter company and modified the method.
--  091110          Modified method Get_Statistic_Date___ to consider the company when calculating the statistic date. Modified Validate_Params to introduce company validations.
--  091106  MaMalk  Made the necessary changes to support the introducing of company column to LU OrdDetailStatLog.
--  090923  MaMalk  Removed unused procedure Calc_Amounts___.
--  ------------------------- 14.0.0 -----------------------------------------
--  090713  MaMalk  Bug 83680, Modified Do_Gen_Invoiced_Stat__ to correct some errors when generating invoice statistics.
--  ------  ----   -----------------------------------------------------------
--  080703  AmPalk  Merged SP2 of APP75. 
--  ---------------------- APP75 SP2 End -----------------------------------
--  090303  NWeelk  Bug 80292, Modified Generate_Cust_Ord_Stat to prevent double records in detailed statistics.
--  080304  ChJalk  Bug 70742, Added invoice_no and series_id to be included in statictics in Do_Gen_Invoiced_Stat__.
--  ---------------------- APP75 SP2 Start -----------------------------------
--  080609  AmPalk  Modified Do_Gen_Invoiced_Stat__ by setting rebate amount, sales part rebate grp and rebate assortment detail.
--  080527  AmPalk  Modified Do_Gen_Invoiced_Stat__ by adding contract is not null condition to the get_invoice_line cursor. 
--  080527          This is due to the restriction needed to omit rebate invoices when creating statistics for invoiced sales.
--  080527          Currently only the rebate invoices have null contract and this addition affect little on performance.  
--  --------------- Nice Price -----------------------------------------------
--  071015  SuSalk  Bug 67695, Modified methods Do_Gen_Invoiced_Stat__ and Do_Gen_Deli_Reliab_Stat__ to pass country_code_ correctly when generating statistics.  
--  061103  KaDilk  Modified the method Do_Gen_Invoiced_Stat__ to exclude prepaymant 
--  061103          and advance invoice types. 
--  060720  RoJalk  Centralized Part Desc - Use Sales_Part_API.Get_Catalog_Desc.
--  060606  PrPrlk  Bug 58492, Made changes to the method Do_Gen_Invoiced_Stat__ to handle invoice type SELFBILLCRE correctly.
--  060531  JaJalk  Bug 58333, Initialized the variable currtype_dummy_ in Do_Gen_Invoiced_Stat__ for each iteration.
--  ---------------------13.4.0-----------------------------------------------
--  060316  IsAnlk Modified Generate_Cust_Ord_Stat_Defer to check whether user connected to all companies.
--  060306  IsAnlk Added Generate_Cust_Ord_Stat_Defer to used when creating stats from client.
--  060124  MaHplk Modified IF comdition in Get_Statistic_Date___. (Bug 55375)
--  060111  MaJalk Bug 55375, Modified Get_Statistic_Date___ to return SYSDATE, when there is not any site where current date is still yesterday.
--  060110  ChJalk Bug 54699, Modified the Procedure Do_Gen_Invoiced_Stat__ to handle cost and invoiced_qty according to the price_adjustment.
--  051026  ChJalk Bug 53742, Removed the TRUNC from the calculation of actual_delivery_date_ in Do_Gen_Deli_Reliab_Stat__.
--  051025  ChJalk Bug 53742, Modified Do_Gen_Deli_Reliab_Stat__ to correct the calculation of actual_delivery_date_.
--  050930  UsRalk Replaced calls to Currency_Rate_API with calls to Invoice_Library_API.
--  050922  SaMelk Removed unused variables.
--  050711  LaBolk Bug 52373, Modified Do_Gen_Invoiced_Stat__ to correct the calculation of cost to multiply by conv factor rather than divide by it.
--  050427  MiKulk Bug 50006, Modified the Do_Gen_Invoiced_Stat__ by adding the creation_date to the cust_ord_invo_stat_tab.
--  050401  ChJalk Bug 50416, Modified Do_Gen_Invoiced_Stat__ to fetch market, Coordinator and salesman info for orderless RMA.
--  050323  IsWilk Added PROCEDURE Validate_Params.
--  050216  MaMalk Bug 49257, Modified procedure Do_Gen_Invoiced_Stat__ to set the cost to 0 when the rma_no is null.
--  041217  ChJalk Bug 47792, Modified PROCEDURE Calc_Amounts_Return___, to calculate the value of add_curr_discount_.
--  041001  DaRulk Bug 47209, Modified Do_Gen_Backlog_Stat__, Do_Gen_Deli_Quality_Stat__, Do_Gen_Invoiced_Stat__, Do_Gen_Invoiced_Stat__
--  040817  DhWilk Inserted the General_SYS.Init_Method to the Generate_Cust_Ord_Stat & Modified the last parameter
--  040817         of Check_If_All_Companies__
--  040806  HeWelk 040611  IsAnlk Bug 45208, Modified Do_Gen_Invoiced_Stat__ to calculate cost_ correctly when invoice created from RMA.
--  040716  MiKulk Bug 45809, Modified the where condition in the cursor get_order_data in Do_Gen_Backlog_Stat__ to get the pkg parts.
--  040601  MiKulk Bug 45101, Modified the where condition in the cursor get_order_data in Do_Gen_Backlog_Stat__.
--  040511  UdGnlk Bug 41757, Modified Do_Gen_Invoiced_Stat__ in order to handle new collective invoice type CUSTCOLCRE.
--  040419  JaBalk  Added new method Generate_Cust_Ord_Stat and chnage the implementation method Check_if_all_Companies to private.
--  040419          and removed Generate_Deli_Reliab_Stat,Generate_Deli_Quality_Stat,Generate_Backlog_Stat,Generate_Invoiced_Stat.
--  040304  UdGnlk Bug 42771, Modified Do_Gen_Invoiced_Stat__ to fetch address info when order connection doesn't exist.
--  040202  SaRalk Bug 42413, Modified procedure Do_Gen_Invoiced_Stat__ to fetch correct Invoice quantity, Price quantity and Total Cost
--  040202         when credit invoices are created through Create Credit Invoice window.
--  ------------------------------ 13.3.0-------------------------------------
--  031012  JaJalk Removed the checks of the tax regime procedures Do_Gen_Backlog_Stat__,Do_Gen_Deli_Quality_Stat__ and Do_Gen_Deli_Reliab_Stat__.
--  030730  ChIwlk Performed SP4 Merge.
--  030401  SaNalk Removed commented codes of the previous modification.
--  030331  SaNalk Changed the checks to consider customer's tax regime for calculations in procedures
--                 Do_Gen_Backlog_Stat__,Do_Gen_Deli_Quality_Stat__,Do_Gen_Deli_Reliab_Stat__.
--  030313  SaRalk Bug 36047, Modified procedure Do_Gen_Invoiced_Stat__.
--  030123  PrJalk Changed function Calc_Amounts_Order___(), added missing
--                 addtional discount curr. amount calculation
--  030121  PrJalk Changed function Do_Gen_Invoiced_Stat__(), added branch to the 2 INSERT INTO
--                 statements and to the cursor get_invoice_line.
--  130103  PrJalk Changed Procedure Do_Gen_Backlog_Stat__() to correct
--                 Parameter passsing to function Calc_Amounts__()
--  030102  SaNalk Performed code review.
--  021231  PrJalk Merged SP3 Changes
--  021216  SaNalk Changed the method used for fetching additional discount in procedure Do_Gen_Invoiced_Stat__.
--  021216  ThPalk Bug 34844, Modified calculation of order_curr_discount_ in Do_Gen_Invoiced_Stat__
--  021211  CaRase Bug 34509, Added exist control of invoic_id and item_id in cursor get_invoice_line.
--  021210  SaNalk Added parameter add_discount_ to function Calc_Discount_Amount___.Added parameters add_discount_,add_curr_discount_ to
--                 procedures Calc_Amounts___,Calc_Amounts_Order___,Calc_Amounts_Return___. Modified coding in these functions and procedures
--                 to work with additional discount.
--  021122  NaWilk Bug 34284, Modified INSERT statement for cust_ord_invo_stat_tab by adding fields
--  021122         payer_no,payer_name,customer_price_group and customer_price_grp_desc in PROCEDURE Do_Gen_Invoiced_Stat__.
--  021121  DayJlk Bug 33927, Adjusted the calculation of cost to use Charge Cost from CO/RMA Lines
--  021115  DayJlk Bug 33927, Modified the calculation of cost for CO/RMA charged lines in Procedure Do_Gen_Invoiced_Stat__.
--  021009  JSAnse Bug fix 29271, added i.rma_no and i.rma_line_no to the cursor get_invoice_line.
--                 Added rmarec_ and rmalinerec_ in the Procedure Do_Gen_Invoiced_Stat__.
--                 Added check so that if no order head is found but there exist a RMA the RMA is included in the cust_ord_invo_stat_tab.
--  020506  JSAnse Bug fix 28060, changed where-statement in CURSOR get_invoice_line and changed update of Last_Trans_Date.
--  020318  PuIllk Bug fix 26301, When calculating total cost, the conversion factor has to_be
--                 multiplied with invoiced qty. Change made in procedure  Do_Gen_Invoiced_Stat__.
--  020318  JSAnse Bug fix 28060, changed where-statement in CURSOR get_invoice_line.
--  010322  DaJolk Bug fix 20326, Modified the CURSOR get_invoice_line to get the contract and
--                 Replaced the linerec_.contract with invrec_.contract in Do_Gen_Invoiced_Stat__.
--  001128  FBen   BugFix. Changed error message NOTCONNECTTOALLCOMP.
--  001009  JoEd   Bug fix 17686. Added method Check_If_All_Companies___.
--                 Added to all Generate_... methods to check that user is
--                 connected to all companies before running statistics.
--  000824  MaGu   Bug fix 16359. Modified calculation of cost_ in
--                 Do_Gen_Invoiced_Stat__ for credit invoice.
--  ------------------------------ 12.1 -------------------------------------
--  000609  MaGu   Bug fix 16359. Modified calculation of cost_ in Do_Gen_Invoiced_Stat__.
--  ------------------------------ 12.0 -------------------------------------
--  000222  JakH   Added handling for non-order connected RMA's in delivery quality.
--  000221  JoEd   Added sales tax handling.
--  000217  JeLise Added creation_date in cursor get_invoice_line and replaced
--                 invoice_date with creation_date in a few places in
--                 Do_Gen_Invoiced_Stat__.
--  000216  JoAn   Removed party and party_type in where clause get_invoice_line
--                 cursor in in Do_Gen_Invoiced_Stat__
--  000214  SaMi   Removed the where-clause with line_item_no in the cursor
--                 get_invoice_line in procedure Do_Gen_Invoiced_Stat__ CID31609
--  000125  JakH   Made inserts in delivery quality of Credit invoice instead
--                 Dedbit invoice.
--  991011  JakH   Removed Customer_Order_Tab use. Replaced with Return_Material_Line_Tab
--  991005  JakH   Modified fetching of return data to new rma-tables
--  990831  JoEd   Changed fetch of region_code and district_code.
--  ------------------------------ 11.1 -------------------------------------
--  990617  JakH   Removed vat columns from cust_ord_invo_stat_tab.
--                 (they were not publicly available in the views anyway, se 990129)
--  990607  JakH   Added function Get_Statistic_Date.
--  990603  JakH   Changed so amounts and price qty for returns gets negated.
--  990511  JakH   Backlog does not register unrelaesed orders.
--  990510  JakH   Removed inserts to the deleted column DEBIT_INVOICE_NO
--  990423  JakH   Corrected type definition for Scrapping_cause_.
--  990407  JakH   New template.
--  990324  JakH   CID 12681 The column 'Promised Quantity' is no longer used
---                since its deleted from the delivery_reliab_stat_tab
--                 Removed the usage of it from Do_Gen_Deli_Reliab_Stat__
--  990322  JakH   CID 12904 Corrected rounding error in DelivQuality.
--  990319  JakH   CID 12678 Added rowstate from customer order line to backlog
--  990315  JakH   CID 12869 Calculation for order_curr_discount corrected.
--  990315  JakH   CID 11779 Added checks for already executing statistics.
--  990308  JoAn   CID 10609 Corrected order of parameters in call to Calc_Amounts___
--                 in Do_Gen_Backlog_Stat__.
--  990304  JakH   CID 11427; price_conv_factor not to be used from order return,
--                 its always null and almost certainly it's an obsolete column.
--  990302  JakH   CID 10609; strange amounts when discount parameters to
--                 calc_amounts are null.
--  990302  JakH   CID 10601; in function Do_Gen_Reliab_Stat the cursor fetching
--                 actual delivery date is modified adding the delivery leadtime
--  990302  JakH   CID 10609; Calculation of amounts corrected. Default rounding 8.
--                 Removed Get_Next_Log_No function, functionality moved to OrdDetailStatLog
--  990302  JakH   CID 10523; In Do_gen_Deli_Quality_Stat prices and discounts are
--                 fetched from Customer Order Return instead of Customer Order Line.
--  990224  JakH   CID 9736; Price U/M in views corrected
--  990222  JakH   CID 9599; Calculations for statistics redesigned.
--  990219  JakH   Back log calculation changed in Do_Gen_Backlog_Stat__. New
--                 utility function calc_discount_amount__
--    *IMPORTANT*  _curr_ refers to values calculated in ORDER currecies,
--                 without it values refers to base currecy values.
--  990205  JoEd   Run through Design. Moved Get_Max_Trans_Date__ to Ord_Detail_Stat_Log_API.
--                 Also move update of that table to that same package.
--  990129  KaSu   Added the vat_amount and vat_curr_amount to Do_Gen_Invoiced_Stat___.
--  990128  KaSu   Removed obsolete variable last_run_date_.
--                 Removed first_start_date_, and Introduced the cursor date_before_min_date.
--                 Modified Do_Gen_Backlog_Stat__.
--                 Included the condition "line_item_no >=0" in all the issues.
--                 Made the cost and invoiced_qty to be negative when net_amount is negative.
--                 Calculation for sales_price was corrected by replacing buy_qty_due with
--                 qty_returned in Do_Gen_Quality_Stat__.
--                 Removed invoice_no and invoice_line_no from Do_Gen_Deli_Reliab_Stat
--  990127  KaSu   Replaced '01/01/1961' as '01/01/1985'
--  990125  KaSu   Replaced the FIRST_START_DATE with first_start_date date constant
--  990125  KaSu   Modified Get_Max_Trans_Date__
--                 Corrected the db value 'SUCCESS' as 'COMPLETE'.
--  990118  KaSu   Removed FUNCTION Exist_In_Cust_Ord_Rece_Stat__
--                 Modified the insert statement to add component_invoice_flag.
--  981129  KaSu   Replaced the trunc(date_entered) >= trunc(last_run_date_) with
--                 trunc(date_entered) > trunc(last_run_date_) in all the issues.
--  981128  KaSu   Added General_SYS.Init_Method to the procedures
--                 Added the desc in the Transaction_SYS.Deffered_Call statements.
--  980915  KaSu   Bug correction.
--  981022  Reza   General_SYS.Init_Method() was added in the necessary Procedures
--  98xxxx  xxxx   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
-- Calc_Discount_Amount___
--    This function will calculate the discount amount from a given set
--    of parameters. The discounts are assumed to be between -1 and 1 (-100% - 100%)
-----------------------------------------------------------------------------

FUNCTION Calc_Discount_Amount___ (
   sale_price_     IN NUMBER,
   order_discount_ IN NUMBER,
   discount_       IN NUMBER,
   add_discount_   IN NUMBER,
   rounding_       IN NUMBER ) RETURN NUMBER
IS
BEGIN
   RETURN ROUND(sale_price_ * (1 - (1 - discount_ ) * (1 - (order_discount_ + add_discount_) )), rounding_);
END Calc_Discount_Amount___;

-- Get_Statistic_Date___
--   Fetches the date to be used for statistic date. It's usually the
--   truncated sysdate but if there exists a site in the database with
--   a negative offset, the statistic date is set back one day.
--   The purpose of the statistic date is to tell that statistics are
--   gathered up to but not including this date.
FUNCTION Get_Statistic_Date___ (
   company_ IN VARCHAR2) RETURN DATE
IS
   min_  NUMBER := Site_API.Get_Min_Offset_By_Company(company_);
BEGIN
   IF (min_ >= 0) OR (TRUNC(SYSDATE) = TRUNC(SYSDATE + min_/24))
      OR (min_ = -(TO_CHAR(SYSDATE, 'HH24') + 1)) THEN

      Trace_SYS.Message('Statistic date is today. Min offset is >= zero hours');
      RETURN TRUNC(SYSDATE);
   ELSE
      -- if the companies sites are spread out in time
      -- statics can not be gathered for yesterday with complete
      -- certainty. So let it sum up until the day before yesterday.
      Trace_SYS.Message('Statistic date is day before today. Offsets unequal');
      RETURN TRUNC(SYSDATE) - 1;
   END IF;
END Get_Statistic_Date___;


-- Calc_Amounts_Order___
--   This function calculates the gross and net amounts in order and base
--   currency. The discount amount is also calculated in these currencies
--   The quantity is given in sales dimension.
PROCEDURE Calc_Amounts_Order___ (
   gross_amount_         IN OUT NUMBER,
   gross_curr_amount_    IN OUT NUMBER,
   net_amount_           IN OUT NUMBER,
   net_curr_amount_      IN OUT NUMBER,
   curr_discount_        IN OUT NUMBER,
   order_curr_discount_  IN OUT NUMBER,
   add_curr_discount_    IN OUT NUMBER,
   base_sale_unit_price_ IN     NUMBER,
   sale_unit_price_      IN     NUMBER,
   price_qty_            IN     NUMBER,
   discount_             IN     NUMBER,
   order_discount_       IN     NUMBER,
   add_discount_         IN     NUMBER,
   order_no_             IN     VARCHAR2,
   line_no_              IN     VARCHAR2,
   rel_no_               IN     VARCHAR2,
   line_item_no_         IN     NUMBER,
   company_              IN     VARCHAR2,
   tax_liability_        IN     VARCHAR2 )
IS
   rounding_           NUMBER;
   currency_rounding_  NUMBER;
   sale_price_         NUMBER;
   discount_amount_    NUMBER;
   vat_amount_         NUMBER := 0;
   vat_curr_amount_    NUMBER := 0;
   order_discount_p_   NUMBER := NVL(order_discount_, 0) * 0.01; -- in hundreds instead of percentage
   discount_p_         NUMBER := NVL(discount_, 0)       * 0.01;
   add_discount_p_     NUMBER := NVL(add_discount_, 0)   * 0.01;
   tax_liability_type_ VARCHAR2(20);
   col_rec_            Customer_Order_Line_API.Public_Rec;    
   
BEGIN
   rounding_ := NVL(Currency_Code_API.Get_Currency_Rounding(company_, Company_Finance_API.Get_Currency_Code(company_)), 8);
   currency_rounding_  := Customer_Order_API.Get_Order_Currency_Rounding(order_no_);
   col_rec_  := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);
      
   tax_liability_type_ := Tax_Liability_API.Get_Tax_Liability_Type_Db(tax_liability_, Cust_Order_Line_Address_API.Get_Country_Code(order_no_, line_no_, rel_no_, line_item_no_));
   -- count the price in order currency
   sale_price_ := sale_unit_price_ * price_qty_;

   -- NOTE: When using price including tax, discount calculation is not modified as this pakage was not handled in price including tax is specified.
   -- calculate the amounts of discount in order currency
    IF (Customer_Order_API.Get_Use_Price_Incl_Tax_Db(order_no_) = 'TRUE')  THEN
      -- calculate the amounts of discount in order currency
      curr_discount_       := ((sale_price_) * discount_p_);
      order_curr_discount_ := ((sale_price_ - curr_discount_) * order_discount_p_);
      add_curr_discount_:= ((sale_price_ - (sale_price_ * discount_p_ )) * add_discount_p_);
      discount_amount_ := Calc_Discount_Amount___(sale_price_, order_discount_p_, discount_p_,add_discount_p_, currency_rounding_);
   ELSE
      curr_discount_    := Cust_Order_Line_Discount_API.Get_Total_Line_Discount(order_no_, line_no_, rel_no_, line_item_no_, price_qty_, 1,  currency_rounding_);
      order_curr_discount_ := ROUND(((sale_price_ - curr_discount_) * order_discount_p_), currency_rounding_);
      add_curr_discount_:= ROUND(((sale_price_ - curr_discount_) * add_discount_p_), currency_rounding_);
      discount_amount_ := curr_discount_ + NVL(order_curr_discount_,0) + NVL(add_curr_discount_,0);
   END IF;

   sale_price_ := ROUND(sale_price_ , currency_rounding_);

   net_curr_amount_ := sale_price_ - NVL(discount_amount_, 0); 
   net_amount_ := ROUND(net_curr_amount_ * col_rec_.currency_rate, rounding_);
   
   
   IF (col_rec_.tax_liability_type != 'EXM') THEN
      Tax_Handling_Order_Util_API.Get_Amounts(vat_amount_, 
                                              net_amount_, 
                                              gross_amount_, 
                                              vat_curr_amount_, 
                                              net_curr_amount_, 
                                              gross_curr_amount_, 
                                              company_, 
                                              Tax_Source_API.DB_CUSTOMER_ORDER_LINE, 
                                              order_no_, 
                                              line_no_, 
                                              rel_no_, 
                                              line_item_no_, 
                                              '*');
   END IF;   
END Calc_Amounts_Order___;


-- Calc_Amounts_Return___
--   This function calculates the gross and net amounts in order and base
--   currency. The discount amount is also calculated in these currencies
--   The quantity is given in sales dimension.
PROCEDURE Calc_Amounts_Return___ (
   gross_amount_         IN OUT NUMBER,
   gross_curr_amount_    IN OUT NUMBER,
   net_amount_           IN OUT NUMBER,
   net_curr_amount_      IN OUT NUMBER,
   curr_discount_        IN OUT NUMBER,
   order_curr_discount_  IN OUT NUMBER,
   add_curr_discount_    IN OUT NUMBER,
   currency_code_        IN     VARCHAR2,
   base_sale_unit_price_ IN     NUMBER,
   sale_unit_price_      IN     NUMBER,
   price_qty_            IN     NUMBER,
   discount_             IN     NUMBER,
   order_discount_       IN     NUMBER,
   add_discount_         IN     NUMBER,
   rma_no_               IN     NUMBER,
   rma_line_no_          IN     NUMBER,
   company_              IN     VARCHAR2,
   tax_liability_type_   IN     VARCHAR2 )

IS
   currency_rounding_  NUMBER;
   base_curr_rounding_ NUMBER;
   discount_amount_    NUMBER;
   sale_price_         NUMBER;
   vat_amount_         NUMBER := 0;
   vat_curr_amount_    NUMBER := 0;
   order_discount_p_   NUMBER := NVL(order_discount_, 0) * 0.01; -- in hundreds instead of percentage
   discount_p_         NUMBER := NVL(discount_, 0)       * 0.01;
   add_discount_p_     NUMBER := NVL(add_discount_, 0)   * 0.01;
   rmalinerec_      Return_Material_Line_API.Public_Rec;
   invoice_id_      NUMBER;

BEGIN
   currency_rounding_ := NVL(Currency_Code_API.Get_Currency_Rounding(company_, currency_code_), 8);
   base_curr_rounding_ := NVL(Currency_Code_API.Get_Currency_Rounding(company_, Company_Finance_API.Get_Currency_Code(company_)), 8);

   -- count the price in order currency
   sale_price_ := sale_unit_price_ * price_qty_;
   rmalinerec_ := Return_Material_Line_API.Get(rma_no_, rma_line_no_);
    IF rmalinerec_.order_no IS NOT NULL THEN -- order connected RMA
      -- NOTE: When using price including tax, discount calculation is not modified as this pakage was not handled in price including tax is specified.
      -- calculate the amounts of discount in order currency
      IF (Customer_Order_API.Get_Use_Price_Incl_Tax_Db(rmalinerec_.order_no) = 'TRUE')  THEN
         -- calculate the amounts of discount in order currency
         curr_discount_       := (sale_price_) * discount_p_;
         order_curr_discount_ := (sale_price_ - curr_discount_) * order_discount_p_;
         add_curr_discount_:= (sale_price_ - curr_discount_) * add_discount_p_;

         discount_amount_ := Calc_Discount_Amount___(sale_price_, order_discount_p_, discount_p_,add_discount_p_, currency_rounding_);
      ELSE
         -- Modified the calculation logic of line discounts
         curr_discount_ := Cust_Invoice_Item_Discount_API.Get_Total_Line_Discount(company_, invoice_id_, rmalinerec_.credit_invoice_item_id, price_qty_, 1, currency_rounding_);
         -- Applied Rounding to discount amounts.
         order_curr_discount_ := ROUND((sale_price_ - curr_discount_) * order_discount_p_, currency_rounding_);
         add_curr_discount_:= ROUND((sale_price_ - curr_discount_) * add_discount_p_, currency_rounding_);
      END IF;   
   END IF;
   sale_price_ := ROUND(sale_price_ , currency_rounding_);

   net_curr_amount_ := sale_price_ - NVL(discount_amount_, 0);
   
   -- get the net in base currency
   net_amount_    := ROUND(net_curr_amount_ * rmalinerec_.currency_rate, base_curr_rounding_);
      
   IF (tax_liability_type_ = 'TAX') THEN      
      Tax_Handling_Order_Util_API.Get_Amounts(vat_amount_, 
                                              net_amount_, 
                                              gross_amount_, 
                                              vat_curr_amount_, 
                                              net_curr_amount_, 
                                              gross_curr_amount_, 
                                              company_, 
                                              Tax_Source_API.DB_RETURN_MATERIAL_LINE, 
                                              rma_no_, 
                                              rma_line_no_, 
                                              '*', 
                                              '*', 
                                              '*');
   END IF;   
END Calc_Amounts_Return___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Do_Gen_Deli_Reliab_Stat__
--   This method creates the detail statistics for the issue 'Delivery Reliability'.
PROCEDURE Do_Gen_Deli_Reliab_Stat__ (
   company_ IN VARCHAR2)

IS
   CURSOR get_delivery(last_run_date_ IN DATE, statistic_date_ IN DATE) IS
      SELECT cod.deliv_no,
             cod.order_no,
             cod.line_no,
             cod.rel_no,
             cod.line_item_no,
             cod.load_id,
             cod.delnote_no               del_note_no,
             cod.component_invoice_flag,
             cod.date_delivered,
             cod.qty_shipped
      FROM  customer_order_delivery_tab cod, customer_order_tab co, site_public s      
      WHERE cod.order_no = co.order_no
      AND   co.contract = s.contract
      AND   s.company = company_ 
      AND   TRUNC(cod.date_delivered) > TRUNC(last_run_date_)
      AND   TRUNC(cod.date_delivered) <= TRUNC(statistic_date_ - 1)
      AND   cod.line_item_no >= 0 
      AND   cod.cancelled_delivery = 'FALSE'     
      ORDER BY cod.date_delivered;

   CURSOR get_order_line(order_no_ IN VARCHAR2, line_no_ IN VARCHAR2, rel_no_ IN VARCHAR2, line_item_no_ IN NUMBER) IS
      SELECT rowversion,
             order_no,
             line_no,
             rel_no,
             line_item_no,
             date_entered,
             date_entered             order_received_date,
             cost,
             contract,
             catalog_no,
             catalog_desc,
             part_no,
             buy_qty_due,
             sales_unit_meas,
             base_sale_unit_price,
             sale_unit_price,
             currency_rate,
             discount,
             order_discount,
             promised_delivery_date,
             real_ship_date,
             qty_shipped              delivered_quantity,
             customer_no,
             price_list_no,
             price_conv_factor,
             conv_factor,
             inverted_conv_factor,
             tax_code                 vat_code,
             region_code,
             district_code,
             tax_liability           tax_liability,
             additional_discount,
             delivery_leadtime,
             ext_transport_calendar_id,
             rental
      FROM   customer_order_line_tab
      WHERE  order_no     = order_no_
      AND    line_no      = line_no_
      AND    rel_no       = rel_no_
      AND    line_item_no = line_item_no_;

   CURSOR get_order_head (order_no_     VARCHAR2) IS
      SELECT delivery_leadtime,
             country_code,
             currency_code     order_curr_code,
             authorize_code,
             salesman_code,
             market_code
      FROM   customer_order_tab
      WHERE  order_no = order_no_;

   CURSOR date_before_min_date IS
      SELECT (MIN(cod.date_delivered) - 1)
      FROM   customer_order_delivery_tab cod, customer_order_line_tab col, site_public s 
      WHERE  cod.order_no     = col.order_no
      AND    cod.line_no      = col.line_no
      AND    cod.rel_no       = col.rel_no
      AND    cod.line_item_no = col.line_item_no
      AND    col.rental       = 'FALSE'
      AND    col.contract     = s.contract
      AND    s.company        = company_
      AND    cod.cancelled_delivery = 'FALSE';

   statistic_date_             DATE;   
   commit_date_                DATE;
   linerec_                    get_order_line%ROWTYPE;
   headrec_                    get_order_head%ROWTYPE;
   salerec_                    Sales_Part_API.public_rec;
   issue_id_db_                VARCHAR2(20) := 'DELIVERY_RELIABILITY';
   curr_discount_              NUMBER;
   order_curr_discount_        NUMBER;
   net_amount_                 NUMBER;
   net_curr_amount_            NUMBER;
   gross_amount_               NUMBER;
   gross_curr_amount_          NUMBER;
   price_qty_                  NUMBER;
   add_curr_discount_          NUMBER;

   actual_delivery_date_       DATE;   
   cust_grp_                   delivery_reliab_stat_tab.cust_grp%TYPE;
   customer_name_              delivery_reliab_stat_tab.customer_name%TYPE;
   part_description_           delivery_reliab_stat_tab.part_desc%TYPE;
   country_description_        delivery_reliab_stat_tab.country_desc%TYPE;
   customer_group_desc_        delivery_reliab_stat_tab.cust_grp_desc%TYPE;
   sales_group_desc_           delivery_reliab_stat_tab.cata_grp_desc%TYPE;
   sales_market_desc_          delivery_reliab_stat_tab.market_desc%TYPE;
   sales_region_desc_          delivery_reliab_stat_tab.region_desc%TYPE;
   sales_district_desc_        delivery_reliab_stat_tab.district_desc%TYPE;
   salesman_name_              delivery_reliab_stat_tab.salesman%TYPE;
   sales_price_list_desc_      delivery_reliab_stat_tab.price_list_desc%TYPE;
   company_name_               delivery_reliab_stat_tab.company_name%TYPE;
   order_coordinator_name_     delivery_reliab_stat_tab.authorize_name%TYPE;
   acct_curr_code_             delivery_reliab_stat_tab.acct_curr_code%TYPE;
   country_code_               delivery_reliab_stat_tab.country_code%TYPE;
   found_                      NUMBER;
   row_locked                  EXCEPTION;
   key_exist                   EXCEPTION;
   PRAGMA      EXCEPTION_INIT(row_locked, -0054);
   PRAGMA      EXCEPTION_INIT(key_exist, -20112); 
   date_changed_               BOOLEAN := FALSE;
   execution_date_             DATE;     
   ord_detail_stat_log_rec_    Ord_Detail_Stat_Log_API.public_rec; 
   
   CURSOR log_lock_control IS
      SELECT 1
      FROM  ord_detail_stat_log_tab
      WHERE issue_id = issue_id_db_
      AND   company = company_
      FOR UPDATE NOWAIT;
BEGIN
    
   execution_date_ := TRUNC(SYSDATE);
   IF (Ord_Detail_Stat_Log_API.Exist(issue_id_db_, company_)) THEN        
      OPEN log_lock_control;
      FETCH log_lock_control INTO found_;
      CLOSE log_lock_control; 
      
      ord_detail_stat_log_rec_ := Ord_Detail_Stat_Log_API.Get(issue_id_db_, company_);
      commit_date_ := ord_detail_stat_log_rec_.last_trans_date;

      IF (commit_date_ IS NULL) THEN
         OPEN date_before_min_date;
         FETCH date_before_min_date INTO commit_date_;
         CLOSE date_before_min_date;
      END IF; 
      
      Ord_Detail_Stat_Log_API.Set_Trans_Execution_Date__(issue_id_db_, company_, commit_date_, execution_date_);      
   ELSE
      OPEN date_before_min_date;
      FETCH date_before_min_date INTO commit_date_;
      CLOSE date_before_min_date;
      
      Ord_Detail_Stat_Log_API.Create_Log__(issue_id_db_, company_, commit_date_);      
   END IF;
   
   
   statistic_date_ := Get_Statistic_Date___(company_);    
  
   FOR delivrec_ IN get_delivery(commit_date_, statistic_date_) LOOP

      OPEN get_order_line(delivrec_.order_no, delivrec_.line_no, delivrec_.rel_no, delivrec_.line_item_no);
      FETCH get_order_line INTO linerec_;
      CLOSE get_order_line;
      
      -- Exclude the rental lines from the statistcs.   
      IF (linerec_.rental = Fnd_Boolean_API.DB_TRUE) THEN
         -- Go to next iteration in loop
         CONTINUE;
      END IF;

      OPEN get_order_head(delivrec_.order_no);
      FETCH get_order_head INTO headrec_;
      CLOSE get_order_head;

      salerec_      := Sales_Part_API.Get (linerec_.contract, linerec_.catalog_no);
      country_code_ := Cust_Order_Line_Address_API.Get_Country_Code(linerec_.order_no, linerec_.line_no,linerec_.rel_no,linerec_.line_item_no);

      Cust_Ord_Date_Calculation_API.Fetch_Calendar_End_Date(actual_delivery_date_, linerec_.ext_transport_calendar_id, 
                                                                                       linerec_.real_ship_date,
                                                                                       linerec_.delivery_leadtime);      
      company_name_           := Company_API.Get_Name(company_);
      cust_grp_               := Cust_Ord_Customer_API.Get_Cust_Grp(linerec_.customer_no);
      customer_name_          := Cust_Ord_Customer_API.Get_Name(linerec_.customer_no);
      part_description_       := Inventory_Part_API.Get_Description(linerec_.contract, linerec_.part_no);
      country_description_    := Iso_Country_API.Get_Description(country_code_);
      customer_group_desc_    := Customer_Group_API.Get_Description(cust_grp_);
      sales_group_desc_       := Sales_Group_API.Get_Description(salerec_.catalog_group);
      sales_market_desc_      := Sales_Market_API.Get_Description(headrec_.market_code);
      sales_region_desc_      := Sales_Region_API.Get_Description(linerec_.region_code);
      sales_district_desc_    := Sales_District_API.Get_Description(linerec_.district_code);
      salesman_name_          := Sales_Part_Salesman_API.Get_Name(headrec_.salesman_code);
      sales_price_list_desc_  := Sales_Price_List_API.Get_Description(linerec_.price_list_no);
      order_coordinator_name_ := Order_Coordinator_API.Get_Name(headrec_.authorize_code);
      acct_curr_code_         := Company_Finance_API.Get_Currency_Code(company_);


      IF (TRUNC(delivrec_.date_delivered) > TRUNC(commit_date_)) THEN
         commit_date_ := delivrec_.date_delivered;
         date_changed_ := TRUE;       
      END IF;

      price_qty_ :=  (delivrec_.qty_shipped / linerec_.conv_factor * linerec_.inverted_conv_factor)  * linerec_.price_conv_factor ;
      -- qty_shipped is first converted from inventory dimension to
      -- sales dimension then converted into price dimension
      Calc_Amounts_Order___(gross_amount_, gross_curr_amount_, net_amount_, net_curr_amount_,
                               curr_discount_, order_curr_discount_,add_curr_discount_, linerec_.base_sale_unit_price,
                               linerec_.sale_unit_price, price_qty_, linerec_.discount, linerec_.order_discount,
                               linerec_.additional_discount,delivrec_.order_no, delivrec_.line_no, delivrec_.rel_no, delivrec_.line_item_no,
                               company_, linerec_.tax_liability);

      INSERT
         INTO delivery_reliab_stat_tab (
            statistic_no,
            statistic_date,
            deliv_no,
            order_no,
            line_no,
            rel_no,
            line_item_no,
            load_id,
            del_note_no,
            component_invoice_flag,
            date_delivered,
            qty_shipped,
            promised_delivery_date,
            actual_delivery_date,
            delivered_quantity,
            order_received_date,
            buy_qty_due,
            price_qty,
            net_amount,
            net_curr_amount,
            gross_amount,
            gross_curr_amount,
            cost,
            discount,
            curr_discount,
            order_discount,
            order_curr_discount,
            base_sale_unit_price,
            customer_name,
            catalog_desc,
            part_desc,
            country_desc,
            sale_unit_price,
            cust_grp_desc,
            cata_grp_desc,
            market_desc,
            region_desc,
            district_desc,
            salesman,
            price_list_desc,
            company_name,
            authorize_name,
            salesman_code,
            district_code,
            region_code,
            market_code,
            company,
            customer_no,
            sales_unit_meas,
            acct_curr_code,
            order_curr_code,
            country_code,
            price_unit_meas,
            cata_group,
            authorize_code,
            price_list_no,
            contract,
            part_no,
            cust_grp,
            catalog_no,
            additional_discount,
            additional_curr_discount,
            rowversion)
         VALUES (
            cust_delivery_reliab_no.nextval,           -- statistic_no
            statistic_date_,                           -- statistic_date
            delivrec_.deliv_no,                        -- deliv_no
            delivrec_.order_no,                        -- order_no
            delivrec_.line_no,                         -- line_no
            delivrec_.rel_no,                          -- rel_no
            delivrec_.line_item_no,                    -- line_item_no
            delivrec_.load_id,                         -- load_id
            delivrec_.del_note_no,                     -- del_note_no
            delivrec_.component_invoice_flag,          -- component_invoice_flag
            delivrec_.date_delivered,                  -- date_delivered
            delivrec_.qty_shipped,                     -- qty_shipped
            linerec_.promised_delivery_date,           -- promised_delivery_date
            actual_delivery_date_,                     -- actual_delivery_date
            linerec_.delivered_quantity,               -- delivered_quantity
            linerec_.order_received_date,              -- order_received_date
            linerec_.buy_qty_due,                      -- buy_qty_due
            price_qty_,                                -- price_qty
            net_amount_,                               -- net_amount
            net_curr_amount_,                          -- net_curr_amount
            gross_amount_,                             -- gross_amount
            gross_curr_amount_,                        -- gross_curr_amount
            linerec_.cost,                             -- cost
            linerec_.discount,                         -- discount
            curr_discount_,                            -- curr_discount
            linerec_.order_discount,                   -- order_discount
            order_curr_discount_,                      -- order_curr_discount
            linerec_.base_sale_unit_price,             -- base_sale_unit_price
            customer_name_,                            -- customer_name
            linerec_.catalog_desc,                     -- catalog_desc
            part_description_,                         -- part_desc
            country_description_,                      -- country_desc
            linerec_.sale_unit_price,                  -- sale_unit_price
            customer_group_desc_,                      -- cust_grp_desc
            sales_group_desc_,                         -- cata_grp_desc
            sales_market_desc_,                        -- market_desc
            sales_region_desc_,                        -- region_desc
            sales_district_desc_,                      -- district_desc
            salesman_name_,                            -- salesman
            sales_price_list_desc_,                    -- price_list_desc
            company_name_,                             -- company_name
            order_coordinator_name_,                   -- authorize_name
            headrec_.salesman_code,                    -- salesman_code
            linerec_.district_code,                    -- district_code
            linerec_.region_code,                      -- region_code
            headrec_.market_code,                      -- market_code
            company_,                                  -- company
            linerec_.customer_no,                      -- customer_no
            linerec_.sales_unit_meas,                  -- sales_unit_meas
            acct_curr_code_,                           -- acct_curr_code
            headrec_.order_curr_code,                  -- order_curr_code
            country_code_,                             -- country_code
            salerec_.price_unit_meas,                  -- price_unit_meas
            salerec_.catalog_group,                    -- cata_group
            headrec_.authorize_code,                   -- authorize_code
            linerec_.price_list_no,                    -- price_list_no
            linerec_.contract,                         -- contract
            linerec_.part_no,                          -- part_no
            cust_grp_,                                 -- cust_grp
            linerec_.catalog_no,                       -- catalog_no
            linerec_.additional_discount,              -- additional_discount
            add_curr_discount_,                        -- add_curr_discount
            sysdate );                                 -- rowversion
   END LOOP;
    
   IF (date_changed_) THEN      
      Ord_Detail_Stat_Log_API.Set_Trans_Execution_Date__(issue_id_db_, company_, commit_date_, execution_date_);             
   END IF;     
EXCEPTION
   WHEN row_locked THEN
      IF (log_lock_control%ISOPEN) THEN
         CLOSE log_lock_control;         
      END IF;
      Error_SYS.Record_General(lu_name_, 'RUNNING: Statistic data collecting is already started for :P1 for company :P2.', Ord_Aggregate_Issue_API.Decode(issue_id_db_), company_);      
   WHEN key_exist THEN
      Error_SYS.Record_General(lu_name_, 'RUNNING: Statistic data collecting is already started for :P1 for company :P2.', Ord_Aggregate_Issue_API.Decode(issue_id_db_), company_);      
END Do_Gen_Deli_Reliab_Stat__;


-- Do_Gen_Deli_Quality_Stat__
--   This method creates the detail statistics for the issue 'Delivery Quality'.
PROCEDURE Do_Gen_Deli_Quality_Stat__ (
   company_ IN VARCHAR2)
IS
   CURSOR get_returns(last_run_date_ IN DATE, statistic_date_ IN DATE) IS
      SELECT rma_no,
             currency_code,
             customer_no,
             customer_no_addr_no,
             contract,
             return_approver_id,
             rma_line_no,
             sale_unit_price,
             base_sale_unit_price,
             price_conv_factor,
             qty_returned_inv,
             qty_scrapped,
             date_returned,
             credit_invoice_no,
             credit_invoice_item_id,
             catalog_no,
             order_no,
             line_no,
             rel_no,
             line_item_no,
             credit_approver_id,
             return_reason_code,
             qty_received,
             conv_factor,
             inverted_conv_factor,       
             objstate,
             state,
             fee_code
      FROM   return_material_join 
      WHERE  TRUNC(date_returned) > TRUNC(last_run_date_)
      AND    TRUNC(date_returned) <= TRUNC(statistic_date_ - 1)
      AND    company   = company_
      AND    rental_db = 'FALSE'
      ORDER BY date_returned;

   CURSOR get_order_line(order_no_ VARCHAR2, line_no_ VARCHAR2, rel_no_ VARCHAR2, line_item_no_ NUMBER) IS
      SELECT rowversion,
             cost,
             rowstate,
             buy_qty_due,
             price_list_no,
             tax_code,
             discount,
             order_discount,
             region_code,
             district_code,
             tax_liability,
             additional_discount
      FROM   customer_order_line_tab
      WHERE  order_no = order_no_
      AND    line_no = line_no_
      AND    rel_no  = rel_no_
      AND    line_item_no = line_item_no_;

   CURSOR date_before_min_date IS
      SELECT (MIN(date_returned) - 1)
      FROM   return_material_line_tab
      WHERE  company = company_
      AND    rental  = 'FALSE';

   CURSOR get_order_head(order_no_ IN VARCHAR2) IS
      SELECT salesman_code,
             market_code
      FROM   customer_order_tab
      WHERE  order_no = order_no_;

   linerec_                    get_order_line%ROWTYPE;
   headrec_                    get_order_head%ROWTYPE;
   salerec_                    Sales_Part_API.public_rec;
   customer_rec_               Cust_Ord_Customer_API.Public_Rec;
   address_rec_                Cust_Ord_Customer_Address_API.Public_Rec;
   statistic_date_             DATE;   
   issue_id_db_                VARCHAR2(20) := 'DELIVERY_QUALITY';
   commit_date_                DATE;

   dqstatrec_                  delivery_quality_stat_tab%ROWTYPE;
   found_                      NUMBER;
   row_locked                  EXCEPTION;
   key_exist                   EXCEPTION;
   PRAGMA EXCEPTION_INIT(row_locked, -00054);
   PRAGMA EXCEPTION_INIT(key_exist, -20112); 
   date_changed_               BOOLEAN := FALSE;
   execution_date_             DATE; 
   ord_detail_stat_log_rec_    Ord_Detail_Stat_Log_API.public_rec;     
    
   CURSOR log_lock_control IS
      SELECT 1
      FROM  ord_detail_stat_log_tab
      WHERE issue_id = issue_id_db_
      AND   company = company_
      FOR UPDATE NOWAIT;    

BEGIN
    
   execution_date_ := TRUNC(SYSDATE); 
   IF (Ord_Detail_Stat_Log_API.Exist(issue_id_db_, company_)) THEN        
      OPEN log_lock_control;
      FETCH log_lock_control INTO found_;
      CLOSE log_lock_control; 
      
      ord_detail_stat_log_rec_ := Ord_Detail_Stat_Log_API.Get(issue_id_db_, company_);
      commit_date_ := ord_detail_stat_log_rec_.last_trans_date;
      
      IF (commit_date_ IS NULL) THEN
         OPEN date_before_min_date;
         FETCH date_before_min_date INTO commit_date_;
         CLOSE date_before_min_date;
      END IF;

      Ord_Detail_Stat_Log_API.Set_Trans_Execution_Date__(issue_id_db_, company_, commit_date_, execution_date_);                 
   ELSE
      OPEN date_before_min_date;
      FETCH date_before_min_date INTO commit_date_;
      CLOSE date_before_min_date;
      
      Ord_Detail_Stat_Log_API.Create_Log__(issue_id_db_, company_, commit_date_);      
   END IF;
   
   
   statistic_date_ := Get_Statistic_Date___(company_);          

   
   FOR returnrec_ IN get_returns(commit_date_, statistic_date_) LOOP

      salerec_ := Sales_Part_API.Get (returnrec_.contract, returnrec_.catalog_no);

      IF returnrec_.order_no IS NOT NULL THEN
         -- fetch data from order head and order line

         OPEN get_order_head(returnrec_.order_no);
         FETCH get_order_head INTO headrec_;
         CLOSE get_order_head;


         OPEN get_order_line(returnrec_.order_no, returnrec_.line_no,
                             returnrec_.rel_no, returnrec_.line_item_no);
         FETCH get_order_line INTO linerec_;
         CLOSE get_order_line;

         IF returnrec_.line_no IS NOT NULL THEN
            dqstatrec_.country_code := Cust_Order_Line_Address_API.Get_Country_Code(returnrec_.order_no, returnrec_.line_no,returnrec_.rel_no,returnrec_.line_item_no);
         ELSE
            dqstatrec_.country_code := Customer_Order_Address_API.Get_Country_Code(returnrec_.order_no);
         END IF;

         dqstatrec_.market_code    := headrec_.market_code;
         dqstatrec_.salesman_code  := headrec_.salesman_code;

         dqstatrec_.discount       := linerec_.discount;
         dqstatrec_.order_discount := linerec_.order_discount;
         dqstatrec_.buy_qty_due    := linerec_.buy_qty_due;
         dqstatrec_.cost           := linerec_.cost;
         dqstatrec_.district_code  := linerec_.district_code;
         dqstatrec_.region_code    := linerec_.region_code;
         dqstatrec_.price_list_no  := linerec_.price_list_no;
         dqstatrec_.price_list_desc:= Sales_Price_List_API.Get_Description(dqstatrec_.price_list_no);
         dqstatrec_.additional_discount := linerec_.additional_discount;


         IF (linerec_.rowstate = 'Cancelled') THEN
            dqstatrec_.buy_qty_due := -dqstatrec_.buy_qty_due;
         END IF ;


      ELSE
         -- fetch data from other places.
         dqstatrec_.country_code    := Cust_Ord_Customer_Address_API.Get_Country_Code
           (returnrec_.customer_no, returnrec_.customer_no_addr_no);

         address_rec_ := Cust_Ord_Customer_Address_API.Get
           (returnrec_.customer_no, returnrec_.customer_no_addr_no);

         dqstatrec_.district_code  := address_rec_.district_code;
         dqstatrec_.region_code    := address_rec_.region_code;

         customer_rec_ := Cust_Ord_Customer_API.Get(returnrec_.customer_no);

         dqstatrec_.market_code    := customer_rec_.market_code;
         dqstatrec_.salesman_code  := customer_rec_.salesman_code;

         dqstatrec_.discount       := 0;
         dqstatrec_.order_discount := 0;
         dqstatrec_.buy_qty_due    := 0; -- sale unit
         dqstatrec_.cost           := 0; -- base currency
         dqstatrec_.additional_discount := 0;

         -- Fetch total_standard from PART_COST.
         IF (salerec_.part_no IS NULL) THEN
            dqstatrec_.cost := salerec_.cost;
         ELSE
            dqstatrec_.cost := NVL(Inventory_Part_API.Get_Inventory_Value_By_Method
                                   (returnrec_.contract, salerec_.part_no),
                                   0);
         END IF;

         dqstatrec_.price_list_no  := NULL;
         dqstatrec_.price_list_desc:= NULL;
      END IF;

      dqstatrec_.salesman         := Sales_Part_Salesman_API.Get_Name(dqstatrec_.salesman_code);
      dqstatrec_.country_desc     := Iso_Country_API.Get_Description(dqstatrec_.country_code);
      dqstatrec_.market_desc      := Sales_Market_API.Get_Description(dqstatrec_.market_code);

      dqstatrec_.region_desc      := Sales_Region_API.Get_Description(dqstatrec_.region_code);
      dqstatrec_.district_desc    := Sales_District_API.Get_Description(dqstatrec_.district_code);


      dqstatrec_.scrapping_cause  := Return_Material_Reason_Api.Get_Return_Reason_Description(returnrec_.return_reason_code);
      dqstatrec_.company_name     := Company_API.Get_Name(company_);
      dqstatrec_.cust_grp         := Cust_Ord_Customer_API.Get_Cust_Grp (returnrec_.customer_no);
      dqstatrec_.cust_grp_desc    := Customer_Group_API.Get_Description(dqstatrec_.cust_grp);
      dqstatrec_.customer_name    := Cust_Ord_Customer_API.Get_Name(returnrec_.customer_no);

      dqstatrec_.part_desc        := Inventory_Part_API.Get_Description(returnrec_.contract, salerec_.part_no);

      dqstatrec_.cata_grp_desc    := Sales_Group_API.Get_Description(salerec_.catalog_group);
      dqstatrec_.authorize_name   := Order_Coordinator_API.Get_Name(returnrec_.return_approver_id);
      dqstatrec_.acct_curr_code   := Company_Finance_API.Get_Currency_Code(company_);


      IF (TRUNC(returnrec_.date_returned) > TRUNC(commit_date_)) THEN
         commit_date_ :=  returnrec_.date_returned;
         date_changed_ := TRUE;        
      END IF;

      dqstatrec_.price_qty := (returnrec_.qty_received / returnrec_.conv_factor * returnrec_.inverted_conv_factor) * returnrec_.price_conv_factor ;
      -- qty_returned is first converted from inventory dimension to
      -- sales dimension then into price dimension
      Calc_Amounts_Return___(dqstatrec_.gross_amount, dqstatrec_.gross_curr_amount,
                                dqstatrec_.net_amount, dqstatrec_.net_curr_amount,
                                dqstatrec_.curr_discount, dqstatrec_.order_curr_discount,dqstatrec_.additional_curr_discount,
                                returnrec_.currency_code,
                                returnrec_.base_sale_unit_price, returnrec_.sale_unit_price,
                                dqstatrec_.price_qty,
                                dqstatrec_.discount, dqstatrec_.order_discount,dqstatrec_.additional_discount,
                                returnrec_.rma_no, returnrec_.rma_line_no,
                                company_, Return_Material_Line_API.Get_Tax_Liability_Type_Db(returnrec_.rma_no, returnrec_.rma_line_no));
      INSERT
         INTO delivery_quality_stat_tab (
            statistic_no,
            line_no,
            rel_no,
            order_no,
            line_item_no,
            quantity_returned,
            returned_to_stock,
            qty_scrapped,
            statistic_date,
            scrapping_cause,
            scrapp_code,
            return_no,
            return_line_no,
            date_returned,
            buy_qty_due,
            price_qty,
            net_amount,
            net_curr_amount,
            gross_amount,
            gross_curr_amount,
            cost,
            discount,
            curr_discount,
            order_discount,
            order_curr_discount,
            base_sale_unit_price,
            customer_name,
            catalog_desc,
            part_desc,
            country_desc,
            sale_unit_price,
            cust_grp_desc,
            cata_grp_desc,
            market_desc,
            region_desc,
            district_desc,
            salesman,
            price_list_desc,
            company_name,
            authorize_name,
            salesman_code,
            district_code,
            region_code,
            market_code,
            company,
            customer_no,
            sales_unit_meas,
            acct_curr_code,
            order_curr_code,
            country_code,
            price_unit_meas,
            cata_group,
            authorize_code,
            price_list_no,
            contract,
            part_no,
            cust_grp,
            catalog_no,
            invoice_no,
            invoice_line_no,
            additional_discount,
            additional_curr_discount,
            rowversion )
         VALUES (
            cust_delivery_quality_no.nextval,
            returnrec_.line_no,
            returnrec_.rel_no,
            returnrec_.order_no,
            returnrec_.line_item_no,
            returnrec_.qty_received,
            returnrec_.qty_returned_inv,
            returnrec_.qty_scrapped,
            statistic_date_,
            dqstatrec_.scrapping_cause,
            returnrec_.return_reason_code,
            returnrec_.rma_no,
            returnrec_.rma_line_no,
            returnrec_.date_returned,
            dqstatrec_.buy_qty_due,
            dqstatrec_.price_qty,
            dqstatrec_.net_amount,
            dqstatrec_.net_curr_amount,
            dqstatrec_.gross_amount,
            dqstatrec_.gross_curr_amount,
            dqstatrec_.cost,
            dqstatrec_.discount,
            dqstatrec_.curr_discount,
            dqstatrec_.order_discount,
            dqstatrec_.order_curr_discount,
            returnrec_.base_sale_unit_price,
            dqstatrec_.customer_name,
            Sales_Part_API.Get_Catalog_Desc(returnrec_.contract, returnrec_.catalog_no),
            dqstatrec_.part_desc,
            dqstatrec_.country_desc,
            returnrec_.sale_unit_price,
            dqstatrec_.cust_grp_desc,
            dqstatrec_.cata_grp_desc,
            dqstatrec_.market_desc,
            dqstatrec_.region_desc,
            dqstatrec_.district_desc,
            dqstatrec_.salesman,
            dqstatrec_.price_list_desc,
            dqstatrec_.company_name,
            dqstatrec_.authorize_name,
            dqstatrec_.salesman_code,
            dqstatrec_.district_code,
            dqstatrec_.region_code,
            dqstatrec_.market_code,
            company_,
            returnrec_.customer_no,
            salerec_.sales_unit_meas,
            dqstatrec_.acct_curr_code,
            returnrec_.currency_code,
            dqstatrec_.country_code,
            salerec_.price_unit_meas,
            salerec_.catalog_group,
            returnrec_.return_approver_id,
            dqstatrec_.price_list_no,
            returnrec_.contract,
            salerec_.part_no,
            dqstatrec_.cust_grp,
            returnrec_.catalog_no,
            returnrec_.credit_invoice_no,
            returnrec_.credit_invoice_item_id,
            dqstatrec_.additional_discount,
            dqstatrec_.additional_curr_discount,
            sysdate );
   END LOOP;
   
   IF (date_changed_) THEN      
      Ord_Detail_Stat_Log_API.Set_Trans_Execution_Date__(issue_id_db_, company_, commit_date_, execution_date_);             
   END IF;     
EXCEPTION
   WHEN row_locked THEN
      IF (log_lock_control%ISOPEN) THEN
         CLOSE log_lock_control;         
      END IF;
      Error_SYS.Record_General(lu_name_, 'RUNNING: Statistic data collecting is already started for :P1 for company :P2.', Ord_Aggregate_Issue_API.Decode(issue_id_db_), company_);      
   WHEN key_exist THEN
      Error_SYS.Record_General(lu_name_, 'RUNNING: Statistic data collecting is already started for :P1 for company :P2.', Ord_Aggregate_Issue_API.Decode(issue_id_db_), company_);      
END Do_Gen_Deli_Quality_Stat__;


-- Do_Gen_Backlog_Stat__
--   This method creates the detail statistics for the issue 'Backlog Of Orders'.
PROCEDURE Do_Gen_Backlog_Stat__ (
   company_ IN VARCHAR2)
IS
    
   salerec_                Sales_Part_API.Public_Rec;
   statistic_date_         DATE;   
   issue_id_db_            VARCHAR2(20) := 'BACKLOG_OF_ORDERS';
   commit_date_            DATE;
   curr_discount_          NUMBER;
   order_curr_discount_    NUMBER;
   net_amount_             NUMBER;
   net_curr_amount_        NUMBER;
   gross_amount_           NUMBER;
   gross_curr_amount_      NUMBER;
   price_qty_              NUMBER;
   
   cust_grp_               cust_ord_back_stat_tab.cust_grp%TYPE;
   customer_name_          cust_ord_back_stat_tab.customer_name%TYPE;
   part_description_       cust_ord_back_stat_tab.part_desc%TYPE;
   country_description_    cust_ord_back_stat_tab.country_desc%TYPE;
   customer_group_desc_    cust_ord_back_stat_tab.cust_grp_desc%TYPE;
   sales_group_desc_       cust_ord_back_stat_tab.catalog_group_desc%TYPE;
   sales_market_desc_      cust_ord_back_stat_tab.market_desc%TYPE;
   sales_region_desc_      cust_ord_back_stat_tab.region_desc%TYPE;
   sales_district_desc_    cust_ord_back_stat_tab.district_desc%TYPE;
   salesman_name_          cust_ord_back_stat_tab.salesman%TYPE;
   sales_price_list_desc_  cust_ord_back_stat_tab.price_list_desc%TYPE;
   company_name_           cust_ord_back_stat_tab.company_name%TYPE;
   order_coordinator_name_ cust_ord_back_stat_tab.authorize_name%TYPE;
   acct_curr_code_         cust_ord_back_stat_tab.acct_currency_code%TYPE;
   add_curr_discount_      NUMBER;
   found_                  NUMBER;
   row_locked              EXCEPTION;
   key_exist               EXCEPTION;
   PRAGMA EXCEPTION_INIT(row_locked, -00054);
   PRAGMA EXCEPTION_INIT(key_exist, -20112);
   ord_detail_stat_log_rec_     Ord_Detail_Stat_Log_API.public_rec;       

   CURSOR get_order_data IS
      SELECT l.order_no             order_no,
             l.line_no              line_no,
             l.rel_no               rel_no,
             l.line_item_no         line_item_no,
             l.date_entered         date_entered,
             l.buy_qty_due + (NVL(l.qty_shipdiff,0) / l.conv_factor * l.inverted_conv_factor ) - l.qty_invoiced
                                    qty_backlog,
             l.cost                 cost,
             l.contract             contract,
             l.catalog_no           catalog_no,
             l.catalog_desc         catalog_desc,
             l.part_no              part_no,
             l.sales_unit_meas      sales_unit_meas,
             l.base_sale_unit_price base_sale_unit_price,
             l.sale_unit_price      sale_unit_price,
             l.currency_rate        currency_rate,
             l.discount             discount,
             l.order_discount       order_discount,
             l.customer_no          customer_no,
             l.price_list_no        price_list_no,
             l.tax_code             vat_code,
             l.price_conv_factor    price_conv_factor,
             l.conv_factor          conv_factor,
             l.inverted_conv_factor inverted_conv_factor,
             l.rowstate             objstate,
             Cust_Order_Line_Address_API.Get_Country_Code(l.order_no, l.line_no,l.rel_no,l.line_item_no)
                                    country_code,
             h.currency_code        order_currency_code,
             h.authorize_code       authorize_code,
             h.salesman_code        salesman_code,
             l.district_code        district_code,
             l.region_code          region_code,
             h.market_code          market_code,
             l.tax_liability        tax_Liability,
             l.additional_discount  additional_discount,
             l.buy_qty_due - (NVL(l.qty_shipped,0) / l.conv_factor * l.inverted_conv_factor )
                                    qty_backlog_to_deliver
      FROM  customer_order_line_tab l, customer_order_tab h, site_public s
      WHERE h.order_no = l.order_no
      AND   h.contract = s.contract
      AND   s.company  = company_
      AND   l.rental   = 'FALSE'
      AND   l.rowstate IN ('Delivered', 'PartiallyDelivered', 'Picked', 'Released', 'Reserved');
         
   CURSOR log_lock_control IS
      SELECT 1
      FROM  ord_detail_stat_log_tab
      WHERE issue_id = issue_id_db_
      AND   company = company_
      FOR UPDATE NOWAIT;
BEGIN
   
   statistic_date_ :=  TRUNC(SYSDATE);  

   IF (Ord_Detail_Stat_Log_API.Exist(issue_id_db_, company_)) THEN
      OPEN log_lock_control;
      FETCH log_lock_control INTO found_;
      CLOSE log_lock_control; 
      
      ord_detail_stat_log_rec_ := Ord_Detail_Stat_Log_API.Get(issue_id_db_, company_);
      commit_date_ := ord_detail_stat_log_rec_.last_trans_date;
      
      IF (TRUNC(commit_date_) = TRUNC(statistic_date_)) THEN
         -- The procedure is not allowed to be executed more than once on the same date.
         RETURN;
      END IF;
      
      Ord_Detail_Stat_Log_API.Set_Trans_Execution_Date__(issue_id_db_, company_, statistic_date_, statistic_date_);                
   ELSE
      Ord_Detail_Stat_Log_API.Create_Log__(issue_id_db_, company_, statistic_date_); 
   END IF;

     
     
   FOR linerec_ IN get_order_data LOOP

      salerec_                := Sales_Part_API.Get(linerec_.contract, linerec_.catalog_no);      
      cust_grp_               := Cust_Ord_Customer_API.Get_Cust_Grp(linerec_.customer_no);
      customer_name_          := Cust_Ord_Customer_API.Get_Name(linerec_.customer_no);

      part_description_       := Inventory_Part_API.Get_Description(linerec_.contract, linerec_.part_no);
      country_description_    := Iso_Country_API.Get_Description(linerec_.country_code);
      customer_group_desc_    := Customer_Group_API.Get_Description(cust_grp_);
      sales_group_desc_       := Sales_Group_API.Get_Description(salerec_.catalog_group);
      sales_market_desc_      := Sales_Market_API.Get_Description(linerec_.market_code);
      sales_region_desc_      := Sales_Region_API.Get_Description(linerec_.region_code);
      sales_district_desc_    := Sales_District_API.Get_Description(linerec_.district_code);
      salesman_name_          := Sales_Part_Salesman_API.Get_Name(linerec_.salesman_code);
      sales_price_list_desc_  := Sales_Price_List_API.Get_Description(linerec_.price_list_no);
      company_name_           := Company_API.Get_Name(company_);
      order_coordinator_name_ := Order_Coordinator_API.Get_Name(linerec_.authorize_code);
      acct_curr_code_         := Company_Finance_API.Get_Currency_Code(company_);

      price_qty_ := NVL(linerec_.qty_backlog, 0) * linerec_.price_conv_factor;
      Calc_Amounts_Order___(gross_amount_, gross_curr_amount_, net_amount_, net_curr_amount_,
                               curr_discount_, order_curr_discount_,add_curr_discount_, linerec_.base_sale_unit_price,
                               linerec_.sale_unit_price, price_qty_, linerec_.discount, linerec_.order_discount,linerec_.additional_discount,
                               linerec_.order_no, linerec_.line_no, linerec_.rel_no, linerec_.line_item_no,
                               company_, linerec_.tax_liability);
      INSERT
         INTO cust_ord_back_stat_tab (
            statistic_no,
            statistic_date,
            order_date,
            buy_qty_due,
            price_qty,
            net_amount,
            net_curr_amount,
            gross_amount,
            gross_curr_amount,
            cost,
            discount,
            curr_discount,
            order_discount,
            order_curr_discount,
            sale_unit_price,
            base_sale_unit_price,
            customer_name,
            catalog_desc,
            part_desc,
            country_desc,
            cust_grp_desc,
            catalog_group_desc,
            market_desc,
            region_desc,
            district_desc,
            salesman,
            price_list_desc,
            company_name,
            authorize_name,
            cust_grp,
            contract,
            catalog_no,
            part_no,
            price_list_no,
            authorize_code,
            salesman_code,
            district_code,
            region_code,
            market_code,
            company,
            order_no,
            line_no,
            rel_no,
            line_item_no,
            customer_no,
            sales_unit_meas,
            acct_currency_code,
            order_currency_code,
            country_code,
            price_unit_meas,
            catalog_group,
            additional_discount,
            additional_curr_discount,
            backlog_qty_to_deliver,
            objstate,
            rowversion )
         VALUES (
            cust_order_backlog_stat_seq.nextval,
            statistic_date_,
            linerec_.date_entered,
            linerec_.qty_backlog,
            price_qty_,
            net_amount_,
            net_curr_amount_,
            gross_amount_,
            gross_curr_amount_,
            linerec_.cost,
            linerec_.discount,
            curr_discount_,
            linerec_.order_discount,
            order_curr_discount_,
            linerec_.sale_unit_price,
            linerec_.base_sale_unit_price,
            customer_name_,
            linerec_.catalog_desc,
            part_description_,
            country_description_,
            customer_group_desc_ ,
            sales_group_desc_,
            sales_market_desc_,
            sales_region_desc_,
            sales_district_desc_,
            salesman_name_,
            sales_price_list_desc_,
            company_name_,
            order_coordinator_name_,
            cust_grp_,
            linerec_.contract,
            linerec_.catalog_no,
            linerec_.part_no,
            linerec_.price_list_no,
            linerec_.authorize_code,
            linerec_.salesman_code,
            linerec_.district_code,
            linerec_.region_code,
            linerec_.market_code,
            company_,
            linerec_.order_no,
            linerec_.line_no,
            linerec_.rel_no,
            linerec_.line_item_no,
            linerec_.customer_no,
            linerec_.sales_unit_meas,
            acct_curr_code_,
            linerec_.order_currency_code,
            linerec_.country_code,
            salerec_.price_unit_meas,
            salerec_.catalog_group,
            linerec_.additional_discount,
            add_curr_discount_,
            linerec_.qty_backlog_to_deliver,
            linerec_.objstate,
            sysdate );
   END LOOP;      
EXCEPTION
   WHEN row_locked THEN
      IF (log_lock_control%ISOPEN) THEN
         CLOSE log_lock_control;         
      END IF;
      Error_SYS.Record_General(lu_name_, 'RUNNING: Statistic data collecting is already started for :P1 for company :P2.', Ord_Aggregate_Issue_API.Decode(issue_id_db_), company_);      
   WHEN key_exist THEN
      Error_SYS.Record_General(lu_name_, 'RUNNING: Statistic data collecting is already started for :P1 for company :P2.', Ord_Aggregate_Issue_API.Decode(issue_id_db_), company_);      
END Do_Gen_Backlog_Stat__;


-- Do_Gen_Invoiced_Stat__
--   This method creates the detail statistics for the issue 'Invoiced'.
--   The basic algorthm of the procedures:
PROCEDURE Do_Gen_Invoiced_Stat__ (
   company_ IN VARCHAR2)
IS
   -- Note : The process must omit the rebate invoices accordingly to the spec DI004(Rebate Handling). 
   --        For performance reasons the condition contract IS NOT NULL added. 
   --        Currently only the rebate invoices do not have sites.
   CURSOR get_invoice_line (last_run_date_ IN DATE, statistic_date_ IN DATE) IS
      SELECT h.invoice_id,
             h.invoice_date,
             h.identity,
             h.invoice_type,
             h.branch,
             i.item_id,
             i.order_no,
             i.line_no,
             i.release_no         rel_no,
             i.line_item_no,
             i.invoiced_qty,
             i.net_dom_amount     net_amount,
             i.vat_dom_amount     vat_amount,
             i.net_curr_amount,
             i.gross_curr_amount,
             i.catalog_no,
             i.description        catalog_desc,
             i.company,
             i.sale_um            sales_unit_meas,
             i.price_um           price_unit_meas,
             i.sale_unit_price    sale_unit_price,
             i.discount,
             i.order_discount,
             i.contract,
             h.creation_date,
             i.rma_no,
             i.rma_line_no,
             i.rma_charge_no,
             i.charge_seq_no,
             h.price_adjustment,
             h.invoice_no,
             h.series_id,
             h.div_factor,
             h.curr_rate,
             i.price_conv,
             i.prel_update_allowed,
             i.additional_discount,
             h.rma_no             header_rma_no,
             i.pos
      FROM  customer_order_inv_item i,customer_order_inv_head h
      WHERE i.company = h.company
      AND   i.invoice_id = h.invoice_id
      AND   GREATEST(h.creation_date,TRUNC(h.invoice_date + 1)) >= TRUNC(last_run_date_)
      AND   TRUNC(h.invoice_date) <= TRUNC(statistic_date_ - 1)
      AND   i.catalog_no IS NOT NULL
      AND   i.contract IS NOT NULL
      AND   h.company = company_
      AND   i.rental_transaction_id IS NULL
      AND NOT EXISTS (SELECT 1
                      FROM  cust_ord_invo_stat_tab c
                      WHERE c.invoice_id = i.invoice_id
                      AND   c.item_id = i.item_id
                      AND   c.company = company_)
      ORDER BY h.creation_date;

   CURSOR date_before_min_date IS
      SELECT (MIN(TRUNC(h.creation_date)) - 1)
      FROM   customer_order_inv_head h
      WHERE  h.company = company_
      AND    EXISTS (SELECT 1
                     FROM  customer_order_inv_item i
                     WHERE i.company = h.company
                     AND   i.invoice_id = h.invoice_id
                     AND   i.rental_transaction_id IS NULL);

   CURSOR get_order_head(order_no_ IN VARCHAR2) IS
     SELECT customer_no,
            country_code,
            currency_code     order_currency_code,
            authorize_code,
            salesman_code,
            market_code
     FROM   customer_order_tab
     WHERE  order_no = order_no_;

   headrec_              get_order_head%ROWTYPE;
   linerec_              Customer_Order_Line_API.Public_Rec;
   salerec_              Sales_Part_API.Public_Rec;
   rmarec_               Return_Material_API.Public_Rec;
   rmalinerec_           Return_Material_Line_API.Public_Rec;
   ordrec_               Customer_Order_API.Public_Rec;

   statistic_date_       DATE;
   issue_id_db_          VARCHAR2(20) := 'INVOICED_SALES';
   commit_date_          DATE;
   gross_amount_         NUMBER;
   curr_discount_        NUMBER;
   order_curr_discount_  NUMBER;
   base_sale_unit_price_ NUMBER;
   price_qty_            NUMBER;
   add_curr_discount_    NUMBER;
   rma_market_           VARCHAR2(10);
   rma_market_desc_      VARCHAR2(200);
   rma_coordinator_      VARCHAR2(20);
   rma_coordinator_name_ VARCHAR2(100);
   rma_sales_man_        VARCHAR2(20);
   rma_sales_man_desc_   VARCHAR2(100);

   cust_grp_                cust_ord_invo_stat_tab.cust_grp%TYPE;
   customer_name_           cust_ord_invo_stat_tab.customer_name%TYPE;
   part_description_        cust_ord_invo_stat_tab.part_desc%TYPE;
   country_description_     cust_ord_invo_stat_tab.country_desc%TYPE;
   customer_group_desc_     cust_ord_invo_stat_tab.cust_grp_desc%TYPE;
   sales_group_desc_        cust_ord_invo_stat_tab.catalog_group_desc%TYPE;
   sales_market_desc_       cust_ord_invo_stat_tab.market_desc%TYPE;
   sales_region_desc_       cust_ord_invo_stat_tab.region_desc%TYPE;
   sales_district_desc_     cust_ord_invo_stat_tab.district_desc%TYPE;
   salesman_name_           cust_ord_invo_stat_tab.salesman%TYPE;
   sales_price_list_desc_   cust_ord_invo_stat_tab.price_list_desc%TYPE;
   company_name_            cust_ord_invo_stat_tab.company_name%TYPE;
   order_coordinator_name_  cust_ord_invo_stat_tab.authorize_name%TYPE;
   acct_curr_code_          cust_ord_invo_stat_tab.acct_currency_code%TYPE;
   cost_                    cust_ord_invo_stat_tab.cost%TYPE;
   payer_name_              cust_ord_invo_stat_tab.payer_name%TYPE;
   customer_price_group_    cust_ord_invo_stat_tab.customer_price_group%TYPE;
   customer_price_grp_desc_ cust_ord_invo_stat_tab.customer_price_grp_desc%TYPE;
   district_code_           cust_ord_invo_stat_tab.district_code%TYPE;
   region_code_             cust_ord_invo_stat_tab.region_code%TYPE;
   country_code_            cust_ord_invo_stat_tab.country_code%TYPE;

   found_                   NUMBER;
   row_locked               EXCEPTION;
   key_exist                EXCEPTION;
   PRAGMA EXCEPTION_INIT(row_locked, -00054);
   PRAGMA EXCEPTION_INIT(key_exist, -20112);
   date_changed_            BOOLEAN := FALSE;
   execution_date_          DATE;
   condition_code_          cust_ord_invo_stat_tab.condition_code%TYPE;
   condition_code_desc_     cust_ord_invo_stat_tab.condition_code_description%TYPE;
   ord_detail_stat_log_rec_ Ord_Detail_Stat_Log_API.public_rec;

   CURSOR log_lock_control IS
      SELECT 1
      FROM  ord_detail_stat_log_tab
      WHERE issue_id = issue_id_db_
      AND   company = company_
      FOR UPDATE NOWAIT;

   rebate_amt_base_           NUMBER;
   sales_part_rebate_group_   Rebate_Transaction_Tab.sales_part_rebate_group%TYPE;
   rebate_assortment_id_      Rebate_Transaction_Tab.assortment_id%TYPE;
   rebate_assort_node_id_     Rebate_Transaction_Tab.assortment_node_id%TYPE;
   cor_inv_type_              VARCHAR2(20);
   col_inv_type_              VARCHAR2(20);
   set_zero_cost_and_qty_     BOOLEAN;
   correction_invoice_ VARCHAR2(5);
BEGIN

   execution_date_ := TRUNC(SYSDATE);
   IF (Ord_Detail_Stat_Log_API.Exist(issue_id_db_, company_)) THEN
      OPEN log_lock_control;
      FETCH log_lock_control INTO found_;
      CLOSE log_lock_control;

      ord_detail_stat_log_rec_ := Ord_Detail_Stat_Log_API.Get(issue_id_db_, company_);
      commit_date_ := ord_detail_stat_log_rec_.last_trans_date;

      IF (commit_date_ IS NULL) THEN
         OPEN date_before_min_date;
         FETCH date_before_min_date INTO commit_date_;
         CLOSE date_before_min_date;
      END IF;
      Ord_Detail_Stat_Log_API.Set_Trans_Execution_Date__(issue_id_db_, company_, commit_date_, execution_date_);
   ELSE
      OPEN date_before_min_date;
      FETCH date_before_min_date INTO commit_date_;
      CLOSE date_before_min_date;

      Ord_Detail_Stat_Log_API.Create_Log__(issue_id_db_, company_, commit_date_);
   END IF;


   statistic_date_ := Get_Statistic_Date___(company_);

   FOR invrec_ IN get_invoice_line(commit_date_, statistic_date_) LOOP

      OPEN get_order_head(invrec_.order_no);
      FETCH get_order_head INTO headrec_;
      
      condition_code_      := Customer_Order_Inv_Item_API.Get_Condition_Code(invrec_.company, invrec_.invoice_id, invrec_.item_id);
      condition_code_desc_ := Condition_Code_API.Get_Description(condition_code_);
      correction_invoice_ := Invoice_API.Is_Correction_Invoice(invrec_.company, invrec_.invoice_id);

      IF get_order_head%NOTFOUND THEN
         CLOSE get_order_head;
         Trace_SYS.Field('Order head not found for Invoice ID', invrec_.invoice_id);
         Trace_SYS.Field('Not found Order No', invrec_.order_no);

         IF invrec_.rma_no IS NOT NULL THEN
            rmarec_     := Return_Material_API.Get(invrec_.rma_no);
            rmalinerec_ := Return_Material_Line_API.Get(invrec_.rma_no, invrec_.rma_line_no);
            salerec_    := Sales_Part_API.Get(rmalinerec_.contract, invrec_.catalog_no);

            country_code_ := Cust_Ord_Customer_Address_API.Get_Country_Code(rmarec_.customer_no,rmarec_.customer_no_addr_no);

            cust_grp_               := Cust_Ord_Customer_API.Get_Cust_Grp(rmarec_.customer_no);
            customer_name_          := Cust_Ord_Customer_API.Get_Name(rmarec_.customer_no);
            part_description_       := Inventory_Part_API.Get_Description(rmalinerec_.contract, salerec_.part_no);
            customer_group_desc_    := Customer_Group_API.Get_Description(cust_grp_);
            sales_group_desc_       := Sales_Group_API.Get_Description(salerec_.catalog_group);

            company_name_           := Company_API.Get_Name(company_);
            acct_curr_code_         := Company_Finance_API.Get_Currency_Code(company_);

            payer_name_              := Cust_Ord_Customer_API.Get_Name(invrec_.identity);
            customer_price_group_    := Cust_Ord_Customer_API.Get_Cust_Price_Group_Id(rmarec_.customer_no);
            customer_price_grp_desc_ := Cust_Price_Group_API.Get_Description(customer_price_group_);
            region_code_             := Cust_Ord_Customer_Address_API.Get_Region_Code(rmarec_.customer_no,rmarec_.customer_no_addr_no);
            district_code_           := Cust_Ord_Customer_Address_API.Get_District_Code(rmarec_.customer_no,rmarec_.customer_no_addr_no);
            sales_region_desc_       := Sales_Region_API.Get_Description(region_code_);
            sales_district_desc_     := Sales_District_API.Get_Description(district_code_);
            country_description_     := Iso_Country_API.Get_Description(country_code_);
            rma_market_              := Cust_Ord_Customer_API.Get_Market_Code (rmarec_.customer_no);
            rma_market_desc_         := Sales_Market_API.Get_Description (rma_market_);
            rma_coordinator_         := rmarec_.return_approver_id;
            rma_coordinator_name_    := Order_Coordinator_API.Get_Name (rmarec_.return_approver_id);
            rma_sales_man_           := Cust_Ord_Customer_API.Get_Salesman_Code (rmarec_.customer_no);
            rma_sales_man_desc_      := Sales_Part_Salesman_API.Get_Name(rma_sales_man_);

            IF (GREATEST(invrec_.creation_date, invrec_.invoice_date)  > commit_date_) THEN
               commit_date_ :=  GREATEST(invrec_.creation_date, invrec_.invoice_date);
               date_changed_ := TRUE;
            END IF;

            cost_ := Customer_Order_Inv_Item_API.Get_Total_Cost(
                                                      invrec_.company,
                                                      invrec_.invoice_id,
                                                      invrec_.item_id,
                                                      invrec_.order_no,
                                                      invrec_.line_no,
                                                      invrec_.rel_no,
                                                      invrec_.line_item_no,
                                                      invrec_.charge_seq_no,
                                                      invrec_.rma_no,
                                                      invrec_.rma_line_no,
                                                      invrec_.rma_charge_no,
                                                      invrec_.catalog_no,
                                                      invrec_.invoiced_qty,
                                                      invrec_.prel_update_allowed,
                                                      invrec_.net_amount,
                                                      invrec_.invoice_type,
                                                      invrec_.pos,
                                                      invrec_.header_rma_no);

            IF (invrec_.net_amount <= 0 AND correction_invoice_ = 'FALSE') THEN                   
               invrec_.invoiced_qty := -1 * invrec_.invoiced_qty;
            END IF;

            price_qty_ := NVL(invrec_.invoiced_qty, 0) * invrec_.price_conv;
            base_sale_unit_price_ := invrec_.sale_unit_price * ( invrec_.curr_rate / invrec_.div_factor);
            -- NOTE: When using price including tax, discount calculation is not modified as this pakage was not handled in price including tax is specified.
            IF Customer_Order_Inv_Head_API.Get_Use_Price_Incl_Tax_Db(invrec_.company, invrec_.invoice_id) = 'TRUE' THEN
               curr_discount_        := ((invrec_.discount       * 0.01) * invrec_.sale_unit_price * price_qty_);
            ELSE
               curr_discount_        := Cust_Invoice_Item_Discount_API.Get_Total_Line_Discount(invrec_.company, invrec_.invoice_id, invrec_.item_id, price_qty_, 1);
            END IF;
            order_curr_discount_  := ((invrec_.order_discount * 0.01) * (invrec_.sale_unit_price * price_qty_ - curr_discount_));

            gross_amount_         := invrec_.net_amount + invrec_.vat_amount;        

            rebate_amt_base_           := Rebate_Transaction_Util_API.Get_Total_Reb_Amt_For_Inv_Line(invrec_.company, invrec_.invoice_id, invrec_.item_id);
            sales_part_rebate_group_   := Rebate_Transaction_Util_API.Get_Rebate_Grp_For_Inv_Line(invrec_.company, invrec_.invoice_id, invrec_.item_id);
            rebate_assortment_id_      := Rebate_Transaction_Util_API.Get_Assort_Id_For_Inv_Line(invrec_.company, invrec_.invoice_id, invrec_.item_id, invrec_.identity);
            rebate_assort_node_id_     := Rebate_Transaction_Util_API.Get_Assort_Node_For_Inv_Line(invrec_.company, invrec_.invoice_id, invrec_.item_id, invrec_.identity);
            

            INSERT
              INTO cust_ord_invo_stat_tab
              ( statistic_no,
                statistic_date,
                invoice_date,
                invoiced_qty,
                price_qty,
                net_amount,
                net_curr_amount,
                gross_amount,
                gross_curr_amount,
                cost,
                order_discount,
                order_curr_discount,
                discount,
                curr_discount,
                sale_unit_price,
                base_sale_unit_price,
                customer_name,
                catalog_desc,
                part_desc,
                cust_grp_desc,
                catalog_group_desc,
                company_name,
                cust_grp,
                customer_no,
                contract,
                branch,
                catalog_no,
                sales_unit_meas,
                order_currency_code,
                acct_currency_code,
                part_no,
                company,
                invoice_id,
                item_id,
                catalog_group,
                price_unit_meas,
                payer_no,
                payer_name,
                customer_price_group,
                customer_price_grp_desc,
                region_code,
                region_desc,
                district_code,
                district_desc,
                country_code,
                country_desc,
                market_code,
                market_desc,
                authorize_code,
                authorize_name,
                salesman_code,
                salesman,
                creation_date,
                invoice_no,
                series_id,
                rebate_amt_base,
                sales_part_rebate_group,
                rebate_assortment_id,
                rebate_assort_node_id,
                condition_code,
                condition_code_description,
                rowversion)
              VALUES
              ( cust_order_invoiced_seq.nextval,
                statistic_date_,
                invrec_.invoice_date,
                invrec_.invoiced_qty,
                price_qty_,
                invrec_.net_amount,
                invrec_.net_curr_amount,
                gross_amount_,
                invrec_.gross_curr_amount,
                cost_,
                invrec_.order_discount,
                order_curr_discount_,
                invrec_.discount,
                curr_discount_,
                invrec_.sale_unit_price,
                base_sale_unit_price_,
                customer_name_ ,
                invrec_.catalog_desc,
                part_description_ ,
                customer_group_desc_,
                sales_group_desc_,
                company_name_,
                cust_grp_,
                rmarec_.customer_no,
                invrec_.contract,
                invrec_.branch,
                invrec_.catalog_no,
                invrec_.sales_unit_meas,
                rmarec_.currency_code,
                acct_curr_code_,
                salerec_.part_no,
                company_,
                invrec_.invoice_id,
                invrec_.item_id,
                salerec_.catalog_group,
                invrec_.price_unit_meas,
                invrec_.identity,
                payer_name_,
                customer_price_group_,
                customer_price_grp_desc_,
                region_code_,
                sales_region_desc_,
                district_code_,
                sales_district_desc_,
                country_code_,
                country_description_,
                rma_market_,
                rma_market_desc_,
                rma_coordinator_,
                rma_coordinator_name_,
                rma_sales_man_,
                rma_sales_man_desc_,
                invrec_.creation_date,
                invrec_.invoice_no,
                invrec_.series_id,
                rebate_amt_base_,
                sales_part_rebate_group_,
                rebate_assortment_id_,
                rebate_assort_node_id_,
                condition_code_,
                condition_code_desc_,
                SYSDATE );
         END IF;

      ELSE
         CLOSE get_order_head;
         linerec_ := Customer_Order_Line_API.Get(invrec_.order_no, invrec_.line_no, invrec_.rel_no, invrec_.line_item_no);
         salerec_ := Sales_Part_API.Get(linerec_.contract, invrec_.catalog_no);
         ordrec_  := Customer_Order_API.Get(invrec_.order_no);

         IF invrec_.line_no IS NOT NULL THEN
            country_code_ := Cust_Order_Line_Address_API.Get_Country_Code(invrec_.order_no, invrec_.line_no,invrec_.rel_no,invrec_.line_item_no);
            region_code_  := linerec_.region_code;
            district_code_ := linerec_.district_code;
         ELSE
            IF invrec_.order_no IS NOT NULL THEN
               country_code_ := Customer_Order_Address_API.Get_Country_Code(invrec_.order_no);
               region_code_  := ordrec_.region_code;
               district_code_ := ordrec_.district_code;
            END IF;
         END IF;

         cust_grp_               := Cust_Ord_Customer_API.Get_Cust_Grp(headrec_.customer_no);
         customer_name_          := Cust_Ord_Customer_API.Get_Name(headrec_.customer_no);
         part_description_       := Inventory_Part_API.Get_Description(linerec_.contract, salerec_.part_no);
         country_description_    := Iso_Country_API.Get_Description(country_code_);
         customer_group_desc_    := Customer_Group_API.Get_Description(cust_grp_);
         sales_group_desc_       := Sales_Group_API.Get_Description(salerec_.catalog_group);

         sales_region_desc_      := Sales_Region_API.Get_Description(region_code_);
         sales_district_desc_    := Sales_District_API.Get_Description(district_code_);

         salesman_name_          := Sales_Part_Salesman_API.Get_Name(headrec_.salesman_code);
         sales_price_list_desc_  := Sales_Price_List_API.Get_Description(linerec_.price_list_no);
         company_name_           := Company_API.Get_Name(company_);
         order_coordinator_name_ := Order_Coordinator_API.Get_Name(headrec_.authorize_code);
         sales_market_desc_      := Sales_Market_API.Get_Description(headrec_.market_code);
         acct_curr_code_         := Company_Finance_API.Get_Currency_Code(company_);

         payer_name_              := Cust_Ord_Customer_API.Get_Name(invrec_.identity);
         customer_price_group_    := Cust_Ord_Customer_API.Get_Cust_Price_Group_Id(headrec_.customer_no);
         customer_price_grp_desc_ := Cust_Price_Group_API.Get_Description(customer_price_group_);
         
         IF (GREATEST(invrec_.creation_date, invrec_.invoice_date)  > commit_date_) THEN
            commit_date_ :=  GREATEST(invrec_.creation_date, invrec_.invoice_date);
            date_changed_ := TRUE;
         END IF;

         -- Note : When a correction invoice is created from a RMA and if there are invoice lines that were not included
         --        in the RMA, these correction invoice line should be treated as price adjusted.
         cor_inv_type_ := Company_Def_Invoice_Type_API.Get_Def_Co_Cor_Inv_Type(invrec_.company);
         col_inv_type_ := Company_Def_Invoice_Type_API.Get_Def_Col_Cor_Inv_Type(invrec_.company);
         IF (invrec_.invoice_type IN (cor_inv_type_, col_inv_type_)) THEN
             set_zero_cost_and_qty_ := Customer_Order_Inv_Item_API.Check_Zero_Cost_And_Qty(invrec_.company,
                                                                                           invrec_.invoice_id,
                                                                                           invrec_.item_id,
                                                                                           invrec_.pos,
                                                                                           invrec_.header_rma_no,
                                                                                           invrec_.rma_no);
         ELSE
            set_zero_cost_and_qty_ := FALSE;
         END IF;

         IF (invrec_.price_adjustment = 'TRUE') OR set_zero_cost_and_qty_ OR (Invoice_API.Is_Rate_Correction_Invoice(invrec_.company, invrec_.invoice_id) = 'CORRECTION_INV')THEN
            cost_        := 0;
            invrec_.invoiced_qty := 0;
         ELSE
            cost_ := Customer_Order_Inv_Item_API.Get_Total_Cost(
                                                      invrec_.company,
                                                      invrec_.invoice_id,
                                                      invrec_.item_id,
                                                      invrec_.order_no,
                                                      invrec_.line_no,
                                                      invrec_.rel_no,
                                                      invrec_.line_item_no,
                                                      invrec_.charge_seq_no,
                                                      invrec_.rma_no,
                                                      invrec_.rma_line_no,
                                                      invrec_.rma_charge_no,
                                                      invrec_.catalog_no,
                                                      invrec_.invoiced_qty,
                                                      invrec_.prel_update_allowed,
                                                      invrec_.net_amount,
                                                      invrec_.invoice_type,
                                                      invrec_.pos,
                                                      invrec_.header_rma_no);

            IF ((invrec_.net_amount <= 0) AND (invrec_.invoice_type IN ('CUSTORDCRE', 'CUSTCOLCRE', 'SELFBILLCRE') AND correction_invoice_ = 'FALSE')) THEN              
               invrec_.invoiced_qty := -1 * invrec_.invoiced_qty;
            END IF;
         END IF;

         price_qty_ := NVL(invrec_.invoiced_qty, 0) * invrec_.price_conv;
         -- 83680, Changed the calculation of base_sale_unit_price_
         base_sale_unit_price_ := invrec_.sale_unit_price * ( invrec_.curr_rate / invrec_.div_factor);
         -- Modified the calculation logic of curr_discount_
         -- NOTE: When using price including tax, discount calculation is not modified as this pakage was not handled in price including tax is specified.
         IF Customer_Order_Inv_Head_API.Get_Use_Price_Incl_Tax_Db(invrec_.company, invrec_.invoice_id) = 'TRUE' THEN
            curr_discount_        := ((invrec_.discount       * 0.01) * invrec_.sale_unit_price * price_qty_);
         ELSE
            curr_discount_        := Cust_Invoice_Item_Discount_API.Get_Total_Line_Discount(invrec_.company, invrec_.invoice_id, invrec_.item_id, price_qty_, 1);
         END IF;
         order_curr_discount_  := ((invrec_.order_discount * 0.01) * (invrec_.sale_unit_price * price_qty_ - curr_discount_));
         add_curr_discount_    := (((invrec_.sale_unit_price * price_qty_) - curr_discount_) * (invrec_.additional_discount   * 0.01));

         gross_amount_         := invrec_.net_amount + invrec_.vat_amount;

         rebate_amt_base_           := Rebate_Transaction_Util_API.Get_Total_Reb_Amt_For_Inv_Line(invrec_.company, invrec_.invoice_id, invrec_.item_id);
         sales_part_rebate_group_   := Rebate_Transaction_Util_API.Get_Rebate_Grp_For_Inv_Line(invrec_.company, invrec_.invoice_id, invrec_.item_id);
         rebate_assortment_id_      := Rebate_Transaction_Util_API.Get_Assort_Id_For_Inv_Line(invrec_.company, invrec_.invoice_id, invrec_.item_id, invrec_.identity);
         rebate_assort_node_id_     := Rebate_Transaction_Util_API.Get_Assort_Node_For_Inv_Line(invrec_.company, invrec_.invoice_id, invrec_.item_id, invrec_.identity);

         INSERT
           INTO cust_ord_invo_stat_tab
           ( statistic_no,
             statistic_date,
             invoice_date,
             invoiced_qty,
             price_qty,
             net_amount,
             net_curr_amount,
             gross_amount,
             gross_curr_amount,
             cost,
             order_discount,
             order_curr_discount,
             discount,
             curr_discount,
             sale_unit_price,
             base_sale_unit_price,
             customer_name,
             catalog_desc,
             part_desc,
             country_desc,
             cust_grp_desc,
             catalog_group_desc,
             region_desc,
             district_desc,
             salesman,
             price_list_desc,
             company_name,
             authorize_name,
             salesman_code,
             price_list_no,
             district_code,
             region_code,
             market_code,
             market_desc,
             cust_grp,
             customer_no,
             contract,
             catalog_no,
             authorize_code,
             sales_unit_meas,
             order_currency_code,
             acct_currency_code,
             part_no,
             company,
             order_no,
             line_no,
             rel_no,
             line_item_no,
             invoice_id,
             item_id,
             catalog_group,
             country_code,
             price_unit_meas,
             payer_no,
             payer_name,
             customer_price_group,
             customer_price_grp_desc,
             additional_discount,
             additional_curr_discount,
             branch,
             creation_date,
             invoice_no,
             series_id,
             rebate_amt_base,
             sales_part_rebate_group,
             rebate_assortment_id,
             rebate_assort_node_id,
             condition_code,
             condition_code_description,
             price_source_id,
             price_source,
             rowversion )
           VALUES
           ( cust_order_invoiced_seq.nextval,
             statistic_date_,
             invrec_.invoice_date,
             invrec_.invoiced_qty,
             price_qty_,
             invrec_.net_amount,
             invrec_.net_curr_amount,
             gross_amount_,
             invrec_.gross_curr_amount,
             cost_,
             invrec_.order_discount,
             order_curr_discount_,
             invrec_.discount,
             curr_discount_,
             invrec_.sale_unit_price,
             base_sale_unit_price_,
             customer_name_ ,
             invrec_.catalog_desc,
             part_description_ ,
             country_description_,
             customer_group_desc_,
             sales_group_desc_,
             sales_region_desc_,
             sales_district_desc_,
             salesman_name_,
             sales_price_list_desc_,
             company_name_,
             order_coordinator_name_ ,
             headrec_.salesman_code,
             linerec_.price_list_no,
             district_code_,
             region_code_,
             headrec_.market_code,
             sales_market_desc_,
             cust_grp_,
             headrec_.customer_no,
             invrec_.contract,
             invrec_.catalog_no,
             headrec_.authorize_code,
             invrec_.sales_unit_meas,
             headrec_.order_currency_code,
             acct_curr_code_,
             salerec_.part_no,
             company_,
             invrec_.order_no,
             invrec_.line_no,
             invrec_.rel_no,
             invrec_.line_item_no,
             invrec_.invoice_id,
             invrec_.item_id,
             salerec_.catalog_group,
             country_code_,
             invrec_.price_unit_meas,
             invrec_.identity,
             payer_name_,
             customer_price_group_,
             customer_price_grp_desc_,
             invrec_.additional_discount,
             add_curr_discount_,
             invrec_.branch,
             invrec_.creation_date,
             invrec_.invoice_no,
             invrec_.series_id,
             rebate_amt_base_,
             sales_part_rebate_group_,
             rebate_assortment_id_,
             rebate_assort_node_id_,
             condition_code_,
             condition_code_desc_,
             linerec_.price_source_id,
             linerec_.price_source,
             SYSDATE );
      END IF;
   END LOOP;

   IF (date_changed_) THEN
      Ord_Detail_Stat_Log_API.Set_Trans_Execution_Date__(issue_id_db_, company_, commit_date_, execution_date_);
   END IF;
EXCEPTION
   WHEN row_locked THEN
      IF (log_lock_control%ISOPEN) THEN
         CLOSE log_lock_control;         
      END IF;
      Error_SYS.Record_General(lu_name_, 'RUNNING: Statistic data collecting is already started for :P1 for company :P2.', Ord_Aggregate_Issue_API.Decode(issue_id_db_), company_);      
   WHEN key_exist THEN
      Error_SYS.Record_General(lu_name_, 'RUNNING: Statistic data collecting is already started for :P1 for company :P2.', Ord_Aggregate_Issue_API.Decode(issue_id_db_), company_);      
END Do_Gen_Invoiced_Stat__;


PROCEDURE Generate_Cust_Ord_Stat_Defer__ (
   issue_db_  IN VARCHAR2,
   company_   IN VARCHAR2 )
IS  
   desc_      VARCHAR2(100);
   issue_     VARCHAR2(200); 
BEGIN
   
   issue_ := Ord_Aggregate_Issue_API.Decode(issue_db_);         
   
   IF (issue_db_ = 'BACKLOG_OF_ORDERS') THEN
      desc_ := Language_SYS.Translate_Constant(lu_name_, 'ORDDETAILSTAT: Customer Order Detail Statistics for :P1 for company :P2.', NULL, issue_, company_);
      Transaction_SYS.Deferred_Call('CUST_ORD_STAT_UTIL_API.Do_Gen_Backlog_Stat__', company_, desc_);
   ELSIF (issue_db_ = 'INVOICED_SALES') THEN
      desc_ := Language_SYS.Translate_Constant(lu_name_, 'ORDDETAILSTAT: Customer Order Detail Statistics for :P1 for company :P2.', NULL, issue_, company_);
      Transaction_SYS.Deferred_Call('CUST_ORD_STAT_UTIL_API.Do_Gen_Invoiced_Stat__', company_, desc_);
   ELSIF (issue_db_ = 'DELIVERY_RELIABILITY') THEN
      desc_ := Language_SYS.Translate_Constant(lu_name_, 'ORDDETAILSTAT: Customer Order Detail Statistics for :P1 for company :P2.', NULL, issue_, company_);
      Transaction_SYS.Deferred_Call('CUST_ORD_STAT_UTIL_API.Do_Gen_Deli_Reliab_Stat__', company_, desc_);
   ELSIF (issue_db_ = 'DELIVERY_QUALITY') THEN
      desc_ := Language_SYS.Translate_Constant(lu_name_, 'ORDDETAILSTAT: Customer Order Detail Statistics for :P1 for company :P2.', NULL, issue_, company_);
      Transaction_SYS.Deferred_Call('CUST_ORD_STAT_UTIL_API.Do_Gen_Deli_Quality_Stat__', company_, desc_);
   END IF;
END Generate_Cust_Ord_Stat_Defer__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Generate_Cust_Ord_Stat
--   This method calls Do_Gen_Backlog_Stat__,Do_Gen_Invoiced_Stat__,
--   Do_Gen_Deli_Reliab_Stat__,Do_Gen_Deli_Quality_Stat__ according to the type of issue.
PROCEDURE Generate_Cust_Ord_Stat (
   message_ IN VARCHAR2 )
IS
   issue_db_                VARCHAR2(20);            
   count_                   NUMBER;
   name_arr_                Message_SYS.name_table;
   value_arr_               Message_SYS.line_table;  
   company_                 VARCHAR2(20);
   
   
BEGIN

   Message_SYS.Get_Attributes(message_, count_, name_arr_, value_arr_);

   FOR n_ IN 1..count_ LOOP
      IF (name_arr_(n_) = 'ISSUE_') THEN
         issue_db_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'COMPANY_') THEN
         company_ :=  value_arr_(n_);            
      END IF;
   END LOOP;   
     
   IF (company_ IS NOT NULL) THEN
      IF (Transaction_Sys.Is_Session_Deferred()) THEN        
         IF (issue_db_ = 'BACKLOG_OF_ORDERS') THEN
            Do_Gen_Backlog_Stat__(company_);
         ELSIF (issue_db_ = 'INVOICED_SALES') THEN
            Do_Gen_Invoiced_Stat__(company_);
         ELSIF (issue_db_ = 'DELIVERY_RELIABILITY') THEN
            Do_Gen_Deli_Reliab_Stat__(company_);
         ELSIF (issue_db_ = 'DELIVERY_QUALITY') THEN
            Do_Gen_Deli_Quality_Stat__(company_);
         END IF;
      ELSE
         Generate_Cust_Ord_Stat_Defer__(issue_db_, company_);
      END IF;     
   END IF;     
END Generate_Cust_Ord_Stat;


-- Validate_Params
--   Validates the parameters when running the Schedule for Detail Order Statistics.
PROCEDURE Validate_Params (
   message_ IN VARCHAR2 )
IS
   count_               NUMBER;
   name_arr_            Message_SYS.name_table;
   value_arr_           Message_SYS.line_table;
   issue_               VARCHAR2(200);
   company_             VARCHAR2(20);
   
BEGIN
   Message_SYS.Get_Attributes(message_, count_, name_arr_, value_arr_);

   FOR n_ IN 1..count_ LOOP
      IF (name_arr_(n_) = 'ISSUE_') THEN
         issue_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'COMPANY_') THEN
         company_ := value_arr_(n_);
      END IF;
   END LOOP;

   IF (issue_ IS NOT NULL) THEN
      IF NOT ((issue_ = 'BACKLOG_OF_ORDERS') OR (issue_ = 'INVOICED_SALES')
             OR (issue_ = 'DELIVERY_RELIABILITY') OR (issue_ = 'DELIVERY_QUALITY')) THEN
         Error_SYS.Record_General(lu_name_, 'UNKNOWNISSUE: The selected issue is not known to the Detail Statistics Process Scheduler.');
      END IF;
   END IF;
   
   IF (company_ IS NOT NULL) THEN
      Company_API.Exist(company_);
      Company_Finance_API.Exist(company_);
   END IF;  
END Validate_Params;



