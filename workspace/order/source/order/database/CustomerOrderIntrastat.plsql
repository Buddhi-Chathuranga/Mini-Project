-----------------------------------------------------------------------------
--
--  Logical unit: CustomerOrderIntrastat
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220105  ErFelk  Bug 162059(SC21R2-7170), Modified Find_Intrastat_Data() by assigning end_customer_id as opponent number if customer and end_customer_id countries are different.
--  220113  ErFelk  Bug 161265(SC21R2-6817), Modified Find_Intrastat_Data() by assigning deliver_to_customer_no as opponent number if country codes are different.
--  211207  Hahalk  Bug 161186(SC21R2-6469), Modified Find_Intrastat_Data() to change the notc to 31, 32 for certain transaction codes for Denmark.
--  210405  Hahalk  Bug 157705(SCZ-14015), Modified Find_Intrastat_Data() by adding condition to assign cost for Net Invoiced Price/Base with considering catalog_type_ is 'KOMP' or not.
--  201014  RasDlk  SCZ-11838, Modified Get_Invoice_Info___() to exclude RMA credit invoice created for transaction_code OERETURN for country DE.
--  201014          Modified Find_Intrastat_Data() to set invoiced_unit_price_ as zero for OERETURN if report country is DE.
--  200904  WaSalk  GESPRING20-537, Modified Find_Intrastat_Data(), Get_Invoice_Info___(),Get_Part_Info___() and Get_Rma_Invoice_Info___() to support gelr fuctionalities.
--  200316  ErFelk  Bug 150094(SCZ-7054), Modified Find_Intrastat_Data() by replacing revised_qty_due_ with inv_trans_hist_rec_.quantity when calling Get_Charge_Info___. 
--  200121  ApWilk  Bug 151263, Modified Find_Intrastat_Data() to support include certain direct delivery transactions when collecting intrastat.          
--  200106  ErFelk  Bug 145333, Modified Get_Order_Line_Info___() to get the currency rate of the applied date when the country is CZ.
--  180219  ApWilk  Bug 139872, Modified Find_Intrastat_Data(),Get_Invoice_Info___()and Get_Invoice_Id___() in order to fetch the correct invoice id and save the intastat line 
--  180219          with the correct invoice no when there are multiple deliveries for a single customer order.
--  171130  DiKuLk  Bug 138954, Modified Find_Intrastat_Data() to revert the calculation of invoiced_unit_price_  in 'OESHIP' and 'OESHIPNI' transactions for Poland. and
--  171130          used the conversion factor for the return transactions also to present the invoiced_unit_price_ from accounting currency.
--  171128  TiRalk  STRSC-14727, Modified all the places by Including OEUNSHIP and OEUNSHIPNI where it refers OESHIP and OESHIPNI.
--  171123  TiRalk  STRSC-14367, Modified Find_Intrastat_Data() by adding POUNDIRSH, UNINTPODIR, UNPODIR-NI, UNPODRINEM, UNINPODRIM, UNSHIPDIR, UNSHIPTRAN, UNINTSHPNI.
--  171123  TiRalk  STRSC-14356, Bug 138804, Modified Find_Intrastat_Data to allow create intrastat lines though the company weight UoM is a base UoM is different than kg.
--  171102  DiKuLk  Bug 138347, Modified Find_Intrastat_Data() to calculate invoiced_unit_price_by using the invoice currency rate instead of customer order line currency rate.
--  171017  DiKuLk  Bug 137333, Modified Get_Invoice_Info__() to divide chargeSum and stat_charge_diff_sum_ by invoiced quantity to calculate unit_charge_amount_inv_ and unit_stat_charge_inv_ 
--  171017          hence, removed revised_qty_due_ as that parameter is no longer used by Modified Get_Invoice_Info__() procedure.
--  170314  MeAblk  Bug 134691, Modified Find_Intrastat_Data() to set the qty as negative for the transactions OEUNSHIP', 'OEUNSHIPNI', 'COOEUNSHIP.
--  170313  PrYaLK  Bug 134629, Modified Find_Intrastat_Data() in order to include the accounting currency when calculating the invoiced unit price
--  170313          for Polish intrastat reports.
--  161021  PrYaLK  Bug 131774, Modified Find_Intrastat_Data() to set the value of cost as the invoiced_unit_price_ when the invoice value gets null
--  161021          for Swidish intrastat reports. This is a legal requirement.
--  160914  PrYaLK  Bug 130922, Modified Find_Intrastat_Data() in order to consider ship via when customer order is delivered through a shipment process.
--  160727  PrYaLK  Bug 129926, Modified Find_Intrastat_Data() in order to set the debit invoice price as the invoiced_unit_price_ when the
--  160727          invoice value gets zero in the process of creating correction invoices. This is a legal requirement.
--  160718  PrYaLK  Bug 130028, Modified Find_Intrastat_Data() to set the value of cost as the invoiced_unit_price_ when the invoice value gets zero
--  160718          for Swidish intrastat reports.
--  160526  ErFelk  Bug 128165, Modified Find_Intrastat_Data() to stop including SHIPDIR, if the customer's country is the same as supply site country. Only INTPODIRSH 
--  160526          should be included to the report when supplier is in the same country as the own company.  
--  160307  MaIklk  LIM-4670, Used Get_Partca_Net_Weight() in Part_Weight_Volume_Util_API.
--  150518  ShKolk  Bug 121986, Modified Find_Data_From_Credit_Invoice() to fetch delivery address instead of document address for intrastat reports.
--  150430  DilMlk  Bug 122090, Added cursor get_credit_invoice_info and modified Get_Invoice_Info___ to include credit invoice amount when calculating invoice value 
--  150512  IsSalk  KES-443, Renamed usage of order_no, release_no, sequence_no, line_item_no attributes of Inventory_Transaction_Hist_API to 
--  150512          source_ref1, source_ref2, source_ref3, source_ref4.
--  150430          and charge value for the country 'DE' (Germany).
--  140813  TiRalk  Bug 118283, Modified Get_Order_Line_Info___ and Find_Intrastat_Data() to calculate invoiced charge price when sales quantity
--  140813          is different than delivered quantitiy.
--  140313  TiRalk  Bug 115882, Modified Get_part_info___() to get country_of_origin value properly for non inventory sales parts.
--  140212  TiRalk  Bug 115260, Modified Find_Data_From_Credit_Invoice() to display quantity correctly for inventory and non inventory parts in
--  140212          credit invoice intrastat lines(notc 16 lines) for country GB.
--  131030  ChBnlk  Bug 113285, Modified Get_Invoice_Info___() to fetch staged billing flag of the customer order line using
--  131030          Customer_Order_Line_API.Get_Staged_Billing_Db().
--  130910  Asawlk  Bug 109541, Modified Find_Intrastat_Data() to convert the net_unit_weight_ to 'kg' if weight_unit_code_ is anything other than 'kg' for
--  130910          non-inventory sales parts.
--  130830  HimRlk  Merged Bug 110133-PIV, Modified method Get_Order_Line_Info___, by changing Calculation logic of line discount amount 
--  130830          to be consistent with discount postings when price including tax is not specified..
--  130830          Modified parameter list of Get_Order_Line_Info___ to take order line keys instead of order line rec. 
--  130830          Modified method Find_Intrastat_Data to pass order line keys when calling Get_Order_Line_Info___.   
--  130809  IsSalk  Bug 107531, Modified Find_Intrastat_Data, Get_Charge_Info___ and Get_Invoice_Info___ to pass unit_stat_charge_diff_ to New_Intrastat_Line
--  130809          to store receiving country charge as unit_stat_charge_diff_ and to consider it when calculating the Statistical Value.
--  130809          Modified Get_Invoice_Info___ to exclude RMA lines when calculating unit_charge_amount_inv_ and unit_stat_charge_inv_ since
--  130809          RMA information fetched separately and report as import transactions.
--  130719  RuLiLk  Bug 110133, Modified method Get_Order_Line_Info___, by changing Calculation logic of line discount amount to be consistent with discount postings.
--  130626  IsSalk  Bug 106841, Modified Find_Intrastat_Data when the supplier address is in a different country than Germany, 
--  130626          set the value for Region of Origin as 99 and this is applicable only for Germany.
--  130812  ChFolk  Modified Find_Intrastat_Data to get price information from demand site instead of supply site.
--  130802  ChFolk  Modified Find_Intrastat_Data to include RETINTPODS transaction as Import instead of corresponding RETSHIPDIR, RETDIR-SCP, RETDIFSREC and RETDIFSSCP
--  130802          transaction when intrastat is created for supply site company.
--  130603  ChFolk  Modified Find_Intrastat_Data to get the delivery country of the internal CO using receipt rma information when transactions are RETPODIRSH and RETINTPODS.
--  130603          included RETDIR-SCP transaction. 
--  130510  ChFolk  Modified Find_Intrastat_Data to include transaction RETSHIPDIR, RETINTPODS, RETPODIRNI and RETPODSINT transactions.
--  130814  UdGnlk  TIBE-852, Modified Is_Eu_Country___(), Find_Intrastat_Data(), Find_Data_From_Credit_Invoice(), Get_Transaction_Info___() and Call_Purch_Intrastat___ hence
--  130814          global variables eu_country_table_ and transaction_table_ in Intrastat_Manager_API is removed. Therefore pass the tables through the parameters.
--  130806  UdGnlk  TIBE-852, Removed global variable Intrastat_Manager_API.g_processinfoflag_ therefore a parameter added to method call
--  130816          Intrastat_Manager_API.Check_Process_Info(). 
--  130704  AwWelk  TIBE-979, Removed inst_PurchaseOrder_, inst_SupplierAddress_, inst_PurchIntrastatUtil_ global variables and introduced 
--  130704          conditional compilation.
--  130130  ChFolk  Modified Find_Intrastat_Data to use return_from_customer_no instead of customer_no as the actual delivery is done for it.
--  130104  ChFolk  Modified Find_Intrastat_Data to include RETPODIRSH transaction.
--  120924  ChFolk  Modified Find_Intrastat_Data to get the intrastat_exempt, ship_via, delivery_terms and delivery_country for the rma lines which are not connected to a CO line.
--  120705  UdGnlk  Modified Find_Intrastat_Data() the length of column CUSTOMS_STAT_NO from 10 to 15. 
--  120412  AyAmlk  Bug 100608, Increased the length of delivery_terms_ in Find_Intrastat_Data().
--  120405  RoJalk  Bug 101284, Modified Find_Intrastat_Data and Find_Data_From_Credit_Invoice by passing opponent type when calling Intrastat_Line_API.New_Intrastat_Line()
--  120405          to clarify the opponent type to get opponent document country code when generating intrastat file for country IT.  
--  120329  MaMalk  Modified Find_Intrastat_Data to set the correct sales part description for orderless returns or scraps.
--  120312  MaMalk  Bug 99430, Modified the code to consider inverted_conv_factor where conv_factor has been considered.
--  120213  HaPulk  Removed dynamic calls to static components ENTERP(SupplierInfoMsgSetup)
--  120109  NipKlk  Bug 99736, Modified the info message for the constants NO_CUST_STAT and NO_CUST_STAT_INV to make them more clear.
--  110829  TiRalk  Bug 97558, Modified Find_Data_From_Credit_Invoice to get correct currency rate for calculations.
--  110822  HimRlk  Bug 97165, Modified Find_Intrastat_Data to exclude the delivery from the intrastat report if the tax liability is set to Tax, when the
--  110822          delivery is done to a different country and the document country is same as the company country. Removed the document company validation 
--  110822          for import transactions. Modified condition to handle OESHIPNI transactions with supply code PD or IPD. Also modified to avoid the validation 
--  110822          for document country and tax liability for SHIPDIR, SHIPTRAN and INTSHIP-NI transactions.
--  110707  PraWlk  Bug 95295, Modified Find_Intrastat_Data() to get and pass return_material_reason_ when calling Intrastat_Line_API.New_Intrastat_Line().
--  110628  NiDalk  Bug 95745, Modified Find_Data_From_Credit_Invoice to check the country of the contract is 'GB'.
--  110520  Cpeilk  Bug 94942, Modified Get_Order_Line_Info___, Get_Charge_Info___, Get_Rma_Invoice_Info___ to get rid of error, divisor is equal to zero.
--  110510  TiRalk  Bug 96057, Modified Find_Intrastat_Data by changing parameter value intrastat alt qty of method call 
--  110510          Intrastat_Line_API.New_Intrastat_Line to fetch values correctly for both inventory and non inventory sales parts.
--  101025  PraWlk  Bug 93752, Modified Find_Intrastat_Data()  by passing intrastat_alt_unit_meas_ to parameter intrastat_alt_unit_meas
--  101025          when calling Intrastat_Line_API.New_Intrastat_Line which revorks a part of correction done for 93020. 
--  100930  Asawlk  Bug 93020, Modified Find_Intrastat_Data()  by passing the correct value to parameter intrastat_alt_unit_meas
--  100930          when calling Intrastat_Line_API.New_Intrastat_Line. 
--  100930  PraWlk  Bug 93020, Modified method Find_Intrastat_Data() by adding a call to Inventory_Part_Config_API.
--  100930          Get_Intrastat_Conv_Factor() to fetch the intrastat conv factor value based on configuration id. 
--  100526  Cpeilk  Bug 90708, Modified Get_Invoice_Info___ to calculate invoiced_unit_price_ depending on invoiced_qty.
--  100520  KRPELK  Merge Rose Method Documentation.
--  091113  MaRalk  Removed unused method Check_Return_Period___ and golbal variable g_order_type_ since it is no longer used.
--  090930  MaMalk  Removed unused procedure Check_Return_Period___ and constant g_order_type_. Modified Get_Order_Line_Info___ and Get_Document_Country___
--  090930          to remove unused code.
--  --------------------------------- 14.0.0 --------------------------------
--  090720  HoInlk  Bug 76329, Modified Get_Document_Country___, Get_Supplier_Addr_Info___, Find_Data_From_Credit_Invoice
--  090720          and Find_Intrastat_Data to get including country when country code is MC or IM.
--  090516  SuThlk  Bug 82219, Added new method Find_Data_From_Credit_Invoice to analyse credit invoices.
--  081226  MaJalk  Bug 79423, Reversed the bug correction 74426.
--  080925  SuSalk  Bug 74426, Added new parameters to Get_Invoice_Info___, Get_Rma_Invoice_Info___ and Get_Rma_Inv_Chg_Info___ methods. 
--  080925          Modified Find_Intrastat_Data method to handle polish based invoiced unit prices and charges.
--  080711  MaMalk  Bug 75157, Modified Get_Part_Info___ to consider non inventory sales part and Modified Find_Intrastat_Data to change
--  080711          the parameters passed when calling Get_Part_Info___.     
--  080123  SuSalk  Bug 70104, Modified Find_Intrastat_Data method to fetch correct net weight value for non inventory sales parts.
--  080123          Removed net_unit_weight_ from the else part of the Get_Part_Info___ method.
--  070509  ChJalk  B143615, Modified Get_Invoice_Info___, inorder to calculate unit_charge_amount_inv_ for each intrastat line.
--  061127  NaLrlk  Bug 61606, Added method Get_Rma_Inv_Chg_Info___ and modified Find_Intrastat_Data to retrieve 
--  061127          unit_charge_amount_inv_ for charges in RMA's. 
--  061124  KaDilk  Bug 61390, Modified Get_Rma_Info___ to add price conv factor to the calculation of order unit price.
--  061106  Cpeilk  DIPL606A, Removed hard coded correction invoice types and called from Company_Invoice_Info_API.
--  060913  ChBalk  Merged call 53157, Modified procedure Find_Intrastat_Data to pass value of county_ when calling to Intrastat_Line_API.New_Intrastat_Line.
--  060725  ChJalk  Replaced Mpccom_Ship_Via_Desc_API.Get_Mode_Of_Transport with Mpccom_Ship_Via_API.Get_Mode_Of_Transport in all places.
--  060720  RoJalk  Centralized Part Desc - Use Sales_Part_API.Get_Catalog_Desc.
--  060720  MaMalk  Modified Find_Intrastat_Data to align some code and optimize the code.
--  060719  ChJalk  Added methods Get_Invoice_Id___, Get_Stage_Bill_Invoice_Id___ and Get_Correction_Invoice_Id___.
--  060719          Added parameters to the methods Get_Invoice_Info___ and Get_Rma_Info___. Modified those methods.
--  060713  MaMalk  Modified procedures Find_Intrastat_Data and Call_Purch_Intrastat___.
--  060627  MaMalk  Modified Get_Charge_Info___ and Get_Invoice_Info___ to exclude intrastat_exempt 'TRUE' records.
--  060605  MiErlk  Enlarge Description - Changed Variables Definitions.
--  060419  SaRalk  Enlarge Customer - Changed variable definitions.
--  --------------------------------- 13.4.0 --------------------------------
--  060125  NiDalk  Added Assert safe annotation.
--  051108  DAYJLK  Bug 53604, Modified procedure Find_Intrastat_Data to use the transaction cost for order unit price.
--  051027  DAYJLK  Bug 53604, Modified procedure Find_Intrastat_Data to handle transaction codes PURDIR and INTPURDIR. The Order reference used for
--  051027          these transaction codes are that of the Initial PO Line which created the CO Line for the component part that was shipped to the supplier.
--  051013  LEPESE  Stopped selection obsolete column cost from inventory_transaction_hist_pub.
--  050922  SaMelk  Removed unused variables.
--  050808  VeMolk  Bug 52715, Modified procedure Find_Intrastat_Data to change two translation constants to make them unique.
--  050616  SaLalk  Bug 51293, Modified Find_Intrastat_Data method to make the country of origin
--  050616          same as country of dispatch for a German company when intrastat direction is import.
--  050505  ErSolk  Bug 50036, Modified procedure Find_Intrastat_Data to fetch
--  050505          weight from Inventory_Part_Config_API.
--  050322  AnLaSe  SCJP625: Added DELCONF-OU in Check_Return_Period___.
--  050303  SeJalk  Bug 49256, Added new transaction codes,CO-SHIPTRN and CO-SHIPDIR in procedure Check_Return_Period___.
--  050224  MaMalk  Bug 49705, Restructured the procedure Get_Invoice_Info___ and modified procedure Find_Intrastat_Data.
--  041217  ChJalk  Bug 47792, Modified the procedure Get_Order_Line_Info___ to calculate total_discount_ considerring Additional Discount.
--  040930  MaMalk  Bug 47180, Modified the procedure Find_Intrastat_Data to get the database value for variable non_inv_part_type_.
--  040329  Castse  Bug 43257, Modified cursor get_coll_invoice_info in procedure Get_Invoice_Info___
--                  to take the MAX invoice_id, and modified the where condition.
--  040224  RoJalk  Bug 39942, Modified Find_Intrastat_Data to include 'OERETIN-NI' and 'OERETIN-NO'.
--  040127  ThPAlk  Bug 40289, Removed call to Check_Return_Period___ in Find_Intrastat_Data
--  040122  SaNalk  Send the Encoded value of Order Type to Cursor Get_Inv_Tran_Hist in method Check_Return_Period___.
--  040121  ChBalk  Bug 38752, Modified the PROCEDURES Check_Return_Period___ and Find_Intrastat_Data
--  040121          to include the new transaction codes 'PODIRINTEM'and 'INTPODIRIM'.
--  040116  SaNalk  Added cursor Get_Inv_Tran_Hist to method Check_Return_Period___.
--  040109  OsAllk  Bug 40358, Modified the PROCEDURES Get_Charge_Info___ and added 2 parameters begin_date_,invoice_date_ to Get_Charge_Info___.
--  040105  ThPalk  Bug 40289, Added checks for transaction_code OERET-SPNO ,OERET-SCP, OERET-SINT.
--  031229  NaWalk  Bug 40095, Modified the Procedure Get_Invoice_Info___ to take the MAX Invoice_id and Modified the where condition.
--  021212  Asawlk  Merged bug fixes in 2002-3 SP3
--  021105  AnLaSe  Bug 25422, added checks for new transaction_code 'OERET-NC' in
--                  Find_Intrastat_Data.
--  021029  DaZa    Bug 33041, added extra check and handling for denmark in method Find_Intrastat_Data.
--  021016  DaZa    Bug 33024, removed call to Check_Return_Period___ in Find_Intrastat_Data
--  020904  LEPESE  Bug 31992, Added new transaction codes INTSHIP-NI and PODIRSH-NI.
--  020815  MaGu    Bug 30882. Modified method Find_Intrastat_Data. Changed calculation
--  020815          of intrastat_alt_qty so that net weight is not used.
--  020702  SaNalk  Bug 29972, Added a check for non inventory sales part which is in package part in Procedure Get_Part_Info___.
--  020627  DaZa    Bug 30134, added checks for new transaction_code 'OERET-INT' in Find_Intrastat_Data.
--  020624  DaZa    Bug 30248, added region_of_origin in methods Get_Part_Info___ and Find_Intrastat_Data.
--  020607  SaNalk  Bug 29972, Added a check for catalog_type_ = 'KOMP' in procedure Find_Intrastat_Data.
--  020319  RoAnse  Bug fix 27817, Added procedure Call_Purch_Intrastat___. Added variables and coding in
--                  procedure Find_Intrastat_Data to check if Purch should be called instead.
--                  Also converted dbms_sql to Native Dynamic SQL in procedure Get_Supplier_Addr_Info.
--  010528  JSAnse  Bug Fix 21463, Added call to General_SYS.Init_Method for procedure Find_Intrastat_Data.
--  010413  JaBa    Bug Fix 20598,Added new global lu constants inst_PurchaseOrder_,inst_SuppInfoAddr_,inst_SupplierAddress_.
--  010314  MaGu    Modified cursor in Get_Invoice_Info___. Modified Get_Document_Country___.
--  010313  MaGu    Modified fetching of invoice info for RMA.
--  010312  MaGu    Added call to Intrastat_Manager_API.Check_Process_Info in
--                  method Set_Status_Info___.
--  010309  MaGu    Added handling of return transactions without connection to
--                  order.
--  010207  MaGu    Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Get_Order_Line_Info___
--   Fetches order line info for a specified order line.
PROCEDURE Get_Order_Line_Info___ (
   order_unit_price_     OUT NUMBER,
   conv_factor_          OUT NUMBER,
   inverted_conv_factor_ OUT NUMBER,
   mode_of_transport_    OUT VARCHAR2,
   delivery_terms_       OUT VARCHAR2,   
   order_no_             IN  VARCHAR2,
   line_no_              IN  VARCHAR2,
   rel_no_               IN  VARCHAR2,
   line_item_no_         IN  NUMBER,
   date_applied_         IN  DATE,
   report_country_       IN  VARCHAR2,
   company_              IN  VARCHAR2)
IS
   total_base_price_  NUMBER;
   sales_price_       NUMBER;
   total_discount_    NUMBER;
   line_discount_     NUMBER;
   order_line_rec_    Customer_Order_Line_API.Public_Rec;
   currency_rate_     NUMBER;
   currency_type_     VARCHAR2(10);
BEGIN
   order_line_rec_   := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_); 
   -- sales_price_ is calculated using order currency.
   sales_price_      := (order_line_rec_.buy_qty_due * order_line_rec_.price_conv_factor * order_line_rec_.sale_unit_price);
   
   -- NOTE: When using price including tax, discount calculation is not modified as this pakage was not handled in price including tax is specified.
   IF (Customer_Order_API.Get_Use_Price_Incl_Tax_Db(order_no_) = 'TRUE') THEN
      total_discount_   := sales_price_ - (sales_price_ * (1 - order_line_rec_.discount / 100) * (1 - (order_line_rec_.order_discount + order_line_rec_.additional_discount) / 100));
   ELSE
      line_discount_    := Cust_Order_Line_Discount_API.Get_Total_Line_Discount(order_no_, line_no_, rel_no_, line_item_no_, 
                                                                          order_line_rec_.buy_qty_due, order_line_rec_.price_conv_factor );
      total_discount_   := sales_price_ - ((sales_price_ - line_discount_) * (1 - (order_line_rec_.order_discount + order_line_rec_.additional_discount) / 100));
   END IF;
   IF (report_country_ = 'CZ') THEN
      Currency_Rate_API.Get_Currency_Rate_Defaults(currency_type_,
                                                   conv_factor_, 
                                                   currency_rate_,                                            
                                                   company_, 
                                                   Customer_Order_API.Get_Currency_Code(order_no_),                                           
                                                   date_applied_);
      total_base_price_ := (sales_price_ - total_discount_)* currency_rate_;
   ELSE
      total_base_price_ := (sales_price_ - total_discount_)*order_line_rec_.currency_rate;
      conv_factor_       := order_line_rec_.conv_factor;      
   END IF;
   
   IF (order_line_rec_.revised_qty_due = 0) THEN
      order_unit_price_ := total_base_price_;
   ELSE
      order_unit_price_ := total_base_price_ / order_line_rec_.revised_qty_due;
   END IF;

   mode_of_transport_ := Mpccom_Ship_Via_API.Get_Mode_Of_Transport(order_line_rec_.ship_via_code);
   delivery_terms_    := order_line_rec_.delivery_terms;
   inverted_conv_factor_ := order_line_rec_.inverted_conv_factor;   

END Get_Order_Line_Info___;


-- Get_Charge_Info___
--   Fetches charge info for a specified order line.
PROCEDURE Get_Charge_Info___ (
   unit_charge_amount_    OUT NUMBER,
   unit_stat_charge_diff_ OUT NUMBER,
   order_no_              IN  VARCHAR2,
   line_no_               IN  VARCHAR2,
   rel_no_                IN  VARCHAR2,
   line_item_no_          IN  NUMBER,
   revised_qty_due_       IN  NUMBER,
   begin_date_            IN  DATE,
   invoice_date_          IN  DATE )
IS
  charge_amount_           NUMBER;
  invoice_date_entered_    DATE;
  statistical_charge_diff_ NUMBER;

  CURSOR get_non_invoice_charge_amount IS
     SELECT SUM(base_charge_amount * charged_qty), SUM(statistical_charge_diff * charged_qty)
       FROM customer_order_charge_tab
      WHERE order_no = order_no_
        AND line_no = line_no_
        AND rel_no = rel_no_
        AND line_item_no = line_item_no_
        AND collect = 'INVOICE'
        AND intrastat_exempt = 'FALSE';

  CURSOR get_charge_amount IS
     SELECT SUM(base_charge_amount * (charged_qty - invoiced_qty)), SUM(statistical_charge_diff * (charged_qty - invoiced_qty))
       FROM customer_order_charge_tab
      WHERE order_no = order_no_
        AND line_no = line_no_
        AND rel_no = rel_no_
        AND line_item_no = line_item_no_
        AND collect = 'INVOICE'
        AND intrastat_exempt = 'FALSE';
BEGIN

   -- invoiced_qty is consider if the invoice_date_entered_ (invoice_date in invoice)
   -- between begin_date_ and invoice_date(which is entered in collect intrastat dialog)

   invoice_date_entered_ := Customer_Order_Inv_Item_API.Get_Order_Line_Invoice_Date(order_no_, line_no_, rel_no_, line_item_no_);
   IF (TRUNC(invoice_date_entered_) >= begin_date_ AND TRUNC(invoice_date_entered_) <= invoice_date_) THEN
      OPEN get_charge_amount;
      FETCH get_charge_amount INTO charge_amount_, statistical_charge_diff_;
      CLOSE get_charge_amount;

      IF (charge_amount_ IS NOT NULL AND revised_qty_due_ != 0) THEN
         unit_charge_amount_ := charge_amount_ / revised_qty_due_;
      END IF;
   ELSE
      OPEN get_non_invoice_charge_amount;
      FETCH get_non_invoice_charge_amount INTO charge_amount_, statistical_charge_diff_;
      CLOSE get_non_invoice_charge_amount;

      IF (charge_amount_ IS NOT NULL AND revised_qty_due_ != 0) THEN
         unit_charge_amount_ := charge_amount_ / revised_qty_due_;
      END IF;
   END IF;
   IF (statistical_charge_diff_ != 0 AND revised_qty_due_ != 0) THEN
      unit_stat_charge_diff_ := statistical_charge_diff_ / revised_qty_due_;
   END IF;
END Get_Charge_Info___;


-- Get_Invoice_Info___
--   Fetches invoice info for a specified order line.
PROCEDURE Get_Invoice_Info___ (
   invoice_no_             OUT VARCHAR2,
   invoice_series_         OUT VARCHAR2,
   invoiced_unit_price_    OUT NUMBER,
   unit_charge_amount_inv_ OUT NUMBER,
   unit_stat_charge_inv_   OUT NUMBER,
   order_no_               IN  VARCHAR2,
   line_no_                IN  VARCHAR2,
   rel_no_                 IN  VARCHAR2,
   line_item_no_           IN  NUMBER,
   conv_factor_            IN  NUMBER,
   inverted_conv_factor_   IN  NUMBER, 
   begin_date_             IN  DATE,
   invoice_date_           IN  DATE,
   company_                IN  VARCHAR2,
   date_time_created_      IN  DATE,
   delivery_no_            IN  NUMBER )
IS
   charge_sum_           NUMBER := 0;
   invoice_id_           NUMBER;
   corr_invoice_id_      NUMBER;
   stat_charge_diff_sum_ NUMBER := 0;
   credit_invoice_amt_   NUMBER := 0;
   invoice_qty_          NUMBER := 0;

   --gelr:italy_intrastat, Added invoice_date to get_invoice_info
   -- Note: Cursor for fetching information from normal and collective invoice.
   CURSOR get_invoice_info IS
      SELECT h.invoice_no, h.series_id, i.net_dom_amount, i.charge_seq_no, i.invoiced_qty, h.invoice_date
        FROM customer_order_inv_item i, customer_order_inv_head h
       WHERE h.company      = company_
         AND i.order_no     = order_no_
         AND i.line_no      = line_no_
         AND i.release_no   = rel_no_
         AND i.line_item_no = line_item_no_
         AND i.company      = h.company
         AND i.invoice_id   = h.invoice_id
         AND h.invoice_id   = invoice_id_
         AND prel_update_allowed = 'TRUE';
         
   -- Note: Cursor for fetching information from credit invoice for the country Germany.
   CURSOR get_credit_invoice_info IS 
      SELECT h.invoice_no, h.series_id, i.net_dom_amount, i.charge_seq_no, i.invoiced_qty
        FROM customer_order_inv_item i, customer_order_inv_head h
       WHERE h.company      = company_
         AND i.order_no     = order_no_
         AND i.line_no      = line_no_
         AND i.release_no   = rel_no_
         AND i.line_item_no = line_item_no_
         AND i.company      = h.company
         AND i.invoice_id   = h.invoice_id
         AND prel_update_allowed = 'TRUE'
         AND h.invoice_type = 'CUSTORDCRE'
         AND h.supply_country_db = 'DE'
         AND NOT EXISTS ( SELECT 1
                          FROM inventory_transaction_hist_pub ith
                          WHERE ith.transaction_code = 'OERETURN'
                          AND ith.source_ref1 = i.rma_no
                          AND ith.source_ref4 = i.rma_line_no);
         
   -- Added condition to avoid the RMA lines from the calculation since it is calculating separately.
   CURSOR get_charge_info IS
      SELECT i.net_dom_amount, i.charge_seq_no
        FROM customer_order_inv_item i, customer_order_inv_head h
       WHERE i.company      = company_
         AND i.order_no     = order_no_
         AND i.line_no      = line_no_
         AND i.release_no   = rel_no_
         AND i.line_item_no = line_item_no_
         AND i.charge_seq_no IS NOT NULL
         AND prel_update_allowed = 'TRUE'
         AND i.invoice_id   = h.invoice_id
         AND h.invoice_id   = invoice_id_;

   CURSOR get_stat_charge_diff_info IS
      SELECT c.statistical_charge_diff * i.invoiced_qty statistical_charge_diff_sum
      FROM customer_order_inv_item i, customer_order_charge_tab c, customer_order_inv_head h
      WHERE i.company       = company_
      AND   i.order_no      = order_no_
      AND   i.line_no       = line_no_
      AND   i.release_no    = rel_no_
      AND   i.line_item_no  = line_item_no_
      AND   i.order_no      = c.order_no
      AND   i.line_no       = c.line_no
      AND   i.release_no    = c.rel_no
      AND   i.line_item_no  = c.line_item_no
      AND   i.charge_seq_no = c.sequence_no
      AND   i.charge_seq_no IS NOT NULL
      AND   prel_update_allowed = 'TRUE'
      AND   c.intrastat_exempt != 'TRUE'
      AND   i.invoice_id    = h.invoice_id
      AND   h.invoice_id    = invoice_id_;
BEGIN

   IF (Customer_Order_Line_API.Get_Staged_Billing_Db(order_no_, line_no_, rel_no_, line_item_no_) = 'STAGED BILLING') THEN   
      invoice_id_ := Get_Stage_Bill_Invoice_Id___(company_, order_no_, line_no_, rel_no_,
                                                  line_item_no_, begin_date_, invoice_date_);
   ELSE
      invoice_id_ := Get_Invoice_Id___(company_, order_no_, line_no_, rel_no_, line_item_no_,
                                       date_time_created_, begin_date_, invoice_date_, delivery_no_);
   END IF;

   corr_invoice_id_ := Customer_Order_Inv_Head_API.Get_Correction_Invoice_Id(company_, invoice_id_);

   IF (corr_invoice_id_ IS NOT NULL) THEN
      invoice_id_ := Get_Correction_Invoice_Id___(company_, invoice_id_, begin_date_, invoice_date_);
   END IF;

   FOR rec_ IN get_invoice_info LOOP
      IF (rec_.charge_seq_no IS NULL) THEN
         IF (rec_.invoiced_qty = 0) THEN
            invoiced_unit_price_ := rec_.net_dom_amount;
         ELSE
            -- Note: Invoiced amount in base currency per invoiced qty in inventory unit
            invoiced_unit_price_ := rec_.net_dom_amount / (rec_.invoiced_qty * conv_factor_/inverted_conv_factor_);         
         END IF;
         invoice_no_     := rec_.invoice_no;
         invoice_series_ := rec_.series_id;
         invoice_qty_    := rec_.invoiced_qty;
         -- gelr:italy_intrastat, start
         App_Context_SYS.Set_Value('INVOICE_DATE_FROM_INV', rec_.invoice_date);
         -- gelr:italy_intrastat, end
      END IF;
   END LOOP;

   FOR chg_rec_ IN get_charge_info LOOP
      IF (Customer_Order_Charge_API.Get_Intrastat_Exempt_Db(order_no_, chg_rec_.charge_seq_no) = 'FALSE') THEN
         charge_sum_ := charge_sum_ + chg_rec_.net_dom_amount;
      END IF;
   END LOOP;
   
   FOR rec_ IN get_credit_invoice_info LOOP     
      IF (rec_.charge_seq_no IS NULL) THEN
         IF (rec_.invoiced_qty = 0) THEN
            credit_invoice_amt_ := rec_.net_dom_amount;
         ELSE
            credit_invoice_amt_ := rec_.net_dom_amount / (rec_.invoiced_qty * conv_factor_/inverted_conv_factor_);         
         END IF;
         invoiced_unit_price_ := invoiced_unit_price_ + credit_invoice_amt_;
      ELSE 
         charge_sum_ := charge_sum_ + rec_.net_dom_amount;
      END IF;         
   END LOOP;
   
   FOR stat_chg_diff_rec_ IN get_stat_charge_diff_info LOOP
      stat_charge_diff_sum_ := stat_charge_diff_sum_ + stat_chg_diff_rec_.statistical_charge_diff_sum;
   END LOOP;
   
   IF (invoice_qty_ != 0) THEN      
      IF (charge_sum_ != 0) THEN
         unit_charge_amount_inv_ := charge_sum_ / (invoice_qty_* conv_factor_/inverted_conv_factor_);
      END IF;
      IF (stat_charge_diff_sum_ != 0) THEN
         unit_stat_charge_inv_ := stat_charge_diff_sum_ / (invoice_qty_* conv_factor_/inverted_conv_factor_);
      END IF;
   END IF;
END Get_Invoice_Info___;


-- Get_Invoice_Id___
--   Returns the minimum Invoice Id in the given time period.
FUNCTION Get_Invoice_Id___ (
   company_           IN VARCHAR2,
   order_no_          IN VARCHAR2,
   line_no_           IN VARCHAR2,
   rel_no_            IN VARCHAR2,
   line_item_no_      IN NUMBER,
   date_time_created_ IN DATE,
   begin_date_        IN DATE,
   end_date_          IN DATE,
   delivery_no_       IN NUMBER ) RETURN NUMBER
IS
   invoice_id_                 NUMBER;

   -- Note: Cursor for fetching information from normal and collective invoice.
   CURSOR get_invoice_id IS
      SELECT ch.invoice_id
           FROM customer_order_inv_item ci, customer_order_inv_head ch, cust_delivery_inv_ref_tab cd
           WHERE ci.order_no   = order_no_
           AND ci.line_no      = line_no_
           AND ci.release_no   = rel_no_
           AND ci.line_item_no = line_item_no_
           AND ci.company      = ch.company
           AND ci.invoice_id   = ch.invoice_id
           AND ci.company      = cd.company
           AND ci.item_id      = cd.item_id
           AND ci.invoice_id   = cd.invoice_id
           AND ch.company      = company_
           AND cd.deliv_no     = delivery_no_
           AND ch.invoice_type IN ('CUSTORDDEB','CUSTCOLDEB','SELFBILLDEB')
           AND TRUNC(ch.invoice_date) BETWEEN TRUNC(begin_date_) AND TRUNC(end_date_)
           AND ch.creation_date >= date_time_created_;

BEGIN
   OPEN get_invoice_id;
   FETCH get_invoice_id INTO invoice_id_;
   CLOSE get_invoice_id;
   RETURN invoice_id_;
END Get_Invoice_Id___;


-- Get_Stage_Bill_Invoice_Id___
--   Returns the Staged Billing Invoice Id.
FUNCTION Get_Stage_Bill_Invoice_Id___ (
   company_      IN VARCHAR2,
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   begin_date_   IN DATE,
   end_date_     IN DATE ) RETURN NUMBER
IS
   stage_bill_inv_no_      NUMBER;
   -- Note: Cursor for fetching information from normal and collective invoice.
   CURSOR get_staged_billing_id IS
      SELECT MAX(ch.invoice_id)
         FROM customer_order_inv_item ci, customer_order_inv_head ch
        WHERE ci.order_no     = order_no_
          AND ci.line_no      = line_no_
          AND ci.release_no   = rel_no_
          AND ci.line_item_no = line_item_no_
          AND ci.company      = ch.company
          AND ci.invoice_id   = ch.invoice_id
          AND ch.company      = company_
          AND ch.invoice_type IN ('CUSTORDDEB','CUSTCOLDEB')
          AND TRUNC(ch.invoice_date) BETWEEN TRUNC(begin_date_) AND TRUNC(end_date_);

BEGIN
   OPEN get_staged_billing_id;
   FETCH get_staged_billing_id INTO stage_bill_inv_no_;
   CLOSE get_staged_billing_id;
   RETURN stage_bill_inv_no_;
END Get_Stage_Bill_Invoice_Id___;


-- Get_Correction_Invoice_Id___
--   Returns the latest Correction Invoice Id.
FUNCTION Get_Correction_Invoice_Id___ (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER,
   begin_date_ IN DATE,
   end_date_   IN DATE ) RETURN NUMBER
IS
   invoice_date_               DATE;
   next_correction_invoice_id_ NUMBER;
   correction_invoice_id_      NUMBER;
   exit_                       BOOLEAN;
BEGIN
  correction_invoice_id_ := invoice_id_;
  LOOP
      next_correction_invoice_id_ := Customer_Order_Inv_Head_API.Get_Correction_Invoice_Id(company_, correction_invoice_id_);
      IF next_correction_invoice_id_ IS NOT NULL THEN
         invoice_date_ := Customer_Order_Inv_Head_API.Get_Invoice_Date(company_,next_correction_invoice_id_);
         IF (invoice_date_ BETWEEN begin_date_ AND end_date_) THEN
            correction_invoice_id_ := next_correction_invoice_id_;
         ELSE
            exit_ := TRUE;
         END IF;
      ELSE
          exit_ := TRUE;
      END IF;
      EXIT WHEN exit_;
  END LOOP;
  RETURN (correction_invoice_id_);
END Get_Correction_Invoice_Id___;


-- Set_Status_Info___
--   Writes information about the current transaction that is being processed
--   to the the background job log.
PROCEDURE Set_Status_Info___ (
   transaction_id_ IN NUMBER,
   intrastat_id_   IN NUMBER,
   language_       IN VARCHAR2,
   info_           IN VARCHAR2 DEFAULT NULL )
IS
   transaction_info_   VARCHAR2(2000);
   process_info_flag_  BOOLEAN := FALSE;
BEGIN

   -- Write information about the current transaction being processed
   -- to the background job log
   transaction_info_ := Language_SYS.Translate_Constant(lu_name_,
                        'TRANS_ERROR: Error when processing Inventory Transaction Id :P1.',
                                                        language_, to_char(transaction_id_));
   Transaction_SYS.Set_Status_Info(transaction_info_);

   IF info_ IS NOT NULL THEN
      -- Write additional error information
      Transaction_SYS.Set_Status_Info(info_);
   END IF;

   -- Set error flag on Intrastat header.
   Intrastat_Manager_API.Check_Process_Info(process_info_flag_, intrastat_id_);
END Set_Status_Info___;


-- Get_Delivery_Country___
--   Fetches the country code of the delivery address for a specified order line.
PROCEDURE Get_Delivery_Country___ (
   delivery_country_ OUT VARCHAR2,
   order_no_         IN  VARCHAR2,
   line_no_          IN  VARCHAR2,
   rel_no_           IN  VARCHAR2,
   line_item_no_     IN  NUMBER,
   customer_no_      IN  VARCHAR2 )
IS
BEGIN

   -- Get delivery address country
   -- 1. From the order line address (single occurrence)
   delivery_country_ := Cust_Order_Line_Address_API.Get_Country_Code(order_no_, line_no_, rel_no_, line_item_no_);

   -- 2. From the order address
   IF (delivery_country_ IS NULL) THEN
       delivery_country_ := Customer_Order_Address_API.Get_Country_Code(order_no_);
   END IF;

   -- 3. From customer general information
   IF (delivery_country_ IS NULL) THEN
       delivery_country_ := Iso_Country_API.Encode(Customer_Info_API.Get_Country(customer_no_));
   END IF;

END Get_Delivery_Country___;


-- Get_Document_Country___
--   Fetches the country code of the document address for a specified order line.
PROCEDURE Get_Document_Country___ (
   document_country_ OUT VARCHAR2,   
   customer_no_      IN  VARCHAR2,
   bill_addr_no_     IN  VARCHAR2 )
IS
BEGIN

   -- Get document address country.
   document_country_ := Cust_Ord_Customer_Address_API.Get_Country_Code(customer_no_, bill_addr_no_);
   IF document_country_ IN ('MC', 'IM') THEN
      document_country_ := Intrastat_Manager_API.Get_Including_Country(document_country_);
   END IF;
END Get_Document_Country___;


-- Get_Transaction_Info___
--   Fetches intrastat direction and notc (Nature of Transaction Code) for
--   a specifed transaction code.
PROCEDURE Get_Transaction_Info___ (
   notc_                OUT VARCHAR2,
   intrastat_direction_ OUT VARCHAR2,
   transaction_         IN  VARCHAR2,
   transaction_table_   IN  Intrastat_Manager_API.mpccom_transaction_type )
IS
BEGIN

   Intrastat_Manager_API.Get_Notc(notc_, intrastat_direction_, transaction_table_, transaction_);

END Get_Transaction_Info___;


-- Get_Part_Info___
--   Fetches info for a specified inventory part or non-inventory sales part.
PROCEDURE Get_Part_Info___ (
   unit_of_measure_         OUT VARCHAR2,
   country_of_origin_       OUT VARCHAR2,
   region_of_origin_        OUT VARCHAR2,
   customs_stat_no_         OUT VARCHAR2,
   intrastat_alt_unit_meas_ OUT VARCHAR2,
   net_unit_weight_         OUT NUMBER,
   intrastat_alt_qty_       OUT NUMBER,   
   catalog_no_              IN  VARCHAR2,
   contract_                IN  VARCHAR2,
   language_                IN  VARCHAR2,
   transaction_id_          IN  NUMBER,
   intrastat_id_            IN  NUMBER,
   italy_intrastat_enabled_ IN  BOOLEAN  DEFAULT FALSE)
IS
   inv_part_rec_   Inventory_Part_API.Public_Rec;
   sales_part_rec_ Sales_Part_API.Public_Rec;
   info_           VARCHAR2(2000);  
BEGIN
   sales_part_rec_ := Sales_Part_API.Get(contract_, catalog_no_);  

   -- Check if non-inventory part 
   IF (sales_part_rec_.catalog_type = 'NON') THEN   
       unit_of_measure_   := sales_part_rec_.sales_unit_meas;
      net_unit_weight_   := nvl(Part_Weight_Volume_Util_API.Get_Partca_Net_Weight(contract_,catalog_no_, sales_part_rec_.part_no, unit_of_measure_, sales_part_rec_.conv_factor, sales_part_rec_.inverted_conv_factor, Company_Invent_Info_API.Get_Uom_For_Weight(Site_API.Get_Company(contract_))) , 0);
       country_of_origin_ := sales_part_rec_.country_of_origin;
       region_of_origin_  := NULL;
       customs_stat_no_   := sales_part_rec_.customs_stat_no;

       -- Not mandatory in application, but should be entered for report.
      IF (customs_stat_no_ IS NULL) THEN
         -- gelr:italy_intrastat, start
         IF (sales_part_rec_.non_inv_part_type != 'SERVICE' OR (NOT italy_intrastat_enabled_)) THEN
         -- gelr:italy_intrastat, end
            info_ := Language_SYS.Translate_Constant(lu_name_,
                   'NO_CUST_STAT: Customs statistics number for non-inventory sales part :P1 on site :P2 must be entered.',
                                               language_, catalog_no_, contract_);
            Set_Status_Info___(transaction_id_, intrastat_id_, language_, info_);
         -- gelr:italy_intrastat, start
         ELSIF (sales_part_rec_.statistical_code IS NULL AND NOT italy_intrastat_enabled_) THEN
            info_ := Language_SYS.Translate_Constant(lu_name_,
                        'NO_CPA_CODE: Cpa Code for Non Inventory Sales Part :P1 on Site :P2 must be entered.',
                                                       language_, catalog_no_, contract_);
            Set_Status_Info___(transaction_id_, intrastat_id_, language_, info_);
         END IF;
          -- gelr:italy_intrastat, end
      ELSE
         intrastat_alt_unit_meas_ := Customs_Statistics_Number_API.Get_Customs_Unit_Meas(sales_part_rec_.customs_stat_no);
      END IF;

       intrastat_alt_qty_ := nvl(sales_part_rec_.intrastat_conv_factor, 0);   
   ELSE
       --Inventory part
       inv_part_rec_ := Inventory_Part_API.Get(contract_, sales_part_rec_.part_no);

       unit_of_measure_  := inv_part_rec_.unit_meas;
       country_of_origin_:= inv_part_rec_.country_of_origin;
       region_of_origin_ := inv_part_rec_.region_of_origin;
       customs_stat_no_  := inv_part_rec_.customs_stat_no;

       -- Not mandatory in application, but should be entered for report.
       IF (customs_stat_no_ IS NULL) THEN
           info_ := Language_SYS.Translate_Constant(lu_name_,
                   'NO_CUST_STAT_INV: Customs statistics number for inventory part :P1 on site :P2 must be entered.',
                                               language_, sales_part_rec_.part_no, contract_);
           Set_Status_Info___(transaction_id_, intrastat_id_, language_, info_);
       ELSE
           intrastat_alt_unit_meas_ := Customs_Statistics_Number_API.Get_Customs_Unit_Meas(inv_part_rec_.customs_stat_no);
       END IF;

       intrastat_alt_qty_ := nvl(inv_part_rec_.intrastat_conv_factor, 0);
   END IF;
END Get_Part_Info___;


-- Get_Supplier_Addr_Info___
--   Fetches country code and intrastat exempt flag from the supplier's
--   address for a specified order line.
PROCEDURE Get_Supplier_Addr_Info___ (
   country_db_          OUT VARCHAR2,
   intrastat_exempt_db_ OUT VARCHAR2,
   order_no_            IN  VARCHAR2,
   line_no_             IN  VARCHAR2,
   rel_no_              IN  VARCHAR2,
   line_item_no_        IN  NUMBER )
IS
   po_no_              VARCHAR2(12);
   po_line_no_         VARCHAR2(4);
   po_line_item_no_    VARCHAR2(4);
   po_type_            VARCHAR2(200);
   intrastat_exempt_   VARCHAR2(200);
   country_            VARCHAR2(200);
BEGIN

   -- Get the purchase order number for the purchase order connected to the current
   -- order line.
   Customer_Order_Pur_Order_API.Get_Purord_For_Custord(po_no_, po_line_no_,
                                                       po_line_item_no_, po_type_,
                                                       order_no_, line_no_,
                                                       rel_no_, line_item_no_);

   -- Get country and intrastat exempt flag for the supplier of the purchase order.
   $IF (Component_Purch_SYS.INSTALLED) $THEN 
      DECLARE 
         po_rec_ Purchase_Order_API.Public_Rec;
      BEGIN
         po_rec_     := Purchase_Order_API.Get(po_no_);
         country_    := Supplier_Info_Address_API.Get_Country(po_rec_.vendor_no, po_rec_.addr_no);
         intrastat_exempt_ := Supplier_Address_API.Get_Intrastat_Exempt(po_rec_.vendor_no, po_rec_.addr_no);
      END;
   $END

   intrastat_exempt_db_ := Intrastat_Exempt_API.Encode(intrastat_exempt_);
   country_db_          := Iso_Country_API.Encode(country_);
   IF country_db_ IN ('MC', 'IM') THEN
      country_db_ := Intrastat_Manager_API.Get_Including_Country(country_db_);
   END IF;
EXCEPTION
   WHEN OTHERS THEN
      RAISE;
END Get_Supplier_Addr_Info___;


-- Is_Eu_Country___
--   Returns TRUE if the speicfied country is a member of the EU.
FUNCTION Is_Eu_Country___ (
   country_          IN VARCHAR2,
   eu_country_table_ IN Intrastat_Manager_API.eu_country_type ) RETURN BOOLEAN
IS
BEGIN

   -- Check if the current country is a memeber of the EU.
   RETURN (Intrastat_Manager_API.Eu_Country(country_, eu_country_table_));
END Is_Eu_Country___;


-- Get_Order_Line_Keys___
--   Fetches the keys of the order line that is connected to a specified RMA.
PROCEDURE Get_Order_Line_Keys___ (
   order_no_     OUT VARCHAR2,
   line_no_      OUT VARCHAR2,
   rel_no_       OUT VARCHAR2,
   line_item_no_ OUT NUMBER,
   rma_no_       IN  NUMBER,
   rma_line_no_  IN  NUMBER )
IS
   CURSOR get_orig_line_keys IS
   SELECT order_no, line_no, rel_no, line_item_no
   FROM   Return_Material_Line_Tab
   WHERE  rma_no = rma_no_
   AND    rma_line_no = rma_line_no_;
BEGIN

   --Get order line keys connected to the current return transaction.
   OPEN get_orig_line_keys;
   FETCH get_orig_line_keys INTO order_no_, line_no_, rel_no_, line_item_no_;
   CLOSE get_orig_line_keys;
END Get_Order_Line_Keys___;


-- Get_Rma_Info___
--   Fetches RMA info for a specified RMA line.
PROCEDURE Get_Rma_Info___ (
    order_unit_price_     OUT NUMBER,
    conv_factor_          OUT NUMBER,
    inverted_conv_factor_ OUT NUMBER,
    invoice_id_           OUT NUMBER,
    invoice_item_id_      OUT NUMBER,
    rma_no_               IN  NUMBER,
    rma_line_no_          IN  NUMBER,
    begin_date_           IN  DATE,
    end_date_             IN  DATE,
    date_applied_         IN  DATE,
    report_country_       IN  VARCHAR2,
    company_              IN  VARCHAR2 )
IS
   rma_line_rec_        Return_Material_Line_API.Public_Rec;
   inv_type_            Customer_Order_Inv_Head.invoice_type%TYPE;
   corr_invoice_id_     NUMBER;
   cor_inv_type_        VARCHAR2(20);
   col_inv_type_        VARCHAR2(20);
   currency_rate_       NUMBER;
   currency_type_       VARCHAR2(10);
BEGIN
   rma_line_rec_ := Return_Material_Line_API.Get(rma_no_, rma_line_no_);
   
   IF (report_country_ = 'CZ') THEN
      Currency_Rate_API.Get_Currency_Rate_Defaults(currency_type_,
                                                   conv_factor_, 
                                                   currency_rate_,                                            
                                                   company_, 
                                                   Return_Material_API.Get_Currency_Code(rma_no_),                                           
                                                   date_applied_);
      order_unit_price_ := rma_line_rec_.sale_unit_price * rma_line_rec_.price_conv_factor / conv_factor_ * rma_line_rec_.inverted_conv_factor * currency_rate_;
   ELSE   
      -- Added price_conv_factor to the calculation of order_unit_price_
      order_unit_price_ := rma_line_rec_.base_sale_unit_price * rma_line_rec_.price_conv_factor / rma_line_rec_.conv_factor * rma_line_rec_.inverted_conv_factor;
      conv_factor_      := rma_line_rec_.conv_factor;
   END IF;
   
   inverted_conv_factor_  := rma_line_rec_.inverted_conv_factor;

   invoice_id_ := rma_line_rec_.credit_invoice_no;
   inv_type_   := Customer_Order_Inv_Head_API.Get_Invoice_Type(rma_line_rec_.company, invoice_id_);

   cor_inv_type_ := Company_Def_Invoice_Type_API.Get_Def_Co_Cor_Inv_Type(rma_line_rec_.company);
   col_inv_type_ := Company_Def_Invoice_Type_API.Get_Def_Col_Cor_Inv_Type(rma_line_rec_.company);

   IF (inv_type_ IN (cor_inv_type_, col_inv_type_)) THEN
      corr_invoice_id_ := Get_Correction_Invoice_Id___(rma_line_rec_.company, invoice_id_, begin_date_, end_date_);
      IF (invoice_id_ != corr_invoice_id_) THEN
          invoice_id_      := corr_invoice_id_;
          invoice_item_id_ := Customer_Order_Inv_Item_API.Get_Item_Id(invoice_id_,
                                                                      rma_line_rec_.order_no,
                                                                      rma_line_rec_.line_no,
                                                                      rma_line_rec_.rel_no,
                                                                      rma_line_rec_.line_item_no);
      END IF;
   END IF;
   IF (invoice_item_id_ IS NULL) THEN
      invoice_item_id_ := rma_line_rec_.credit_invoice_item_id;
   END IF;
END  Get_Rma_Info___;


-- Get_Rma_Invoice_Info___
--   Fetches invoice info for a specified RMA line.
PROCEDURE Get_Rma_Invoice_Info___ (
   invoice_series_       OUT VARCHAR2,
   invoice_no_           OUT VARCHAR2,
   invoiced_unit_price_  OUT NUMBER,
   invoiced_qty_         OUT NUMBER,
   company_              IN  VARCHAR2,
   invoice_id_           IN  NUMBER,
   invoice_item_id_      IN  NUMBER,
   conv_factor_          IN  NUMBER,
   inverted_conv_factor_ IN  NUMBER,
   begin_date_           IN  DATE,
   invoice_date_         IN  DATE )
IS
   invoiced_price_  NUMBER;
   -- gelr:italy_intrastat, start
   invoice_date_from_inv_ DATE;
   -- gelr:italy_intrastat, end
   
   -- gelr:italy_intrastat, added invoice_date   
   CURSOR get_invoice_info IS
      SELECT h.series_id, h.invoice_no, i.net_dom_amount, i.invoiced_qty, h.invoice_date
      FROM Customer_Order_Inv_Item i, Customer_Order_Inv_Head h
      WHERE h.company = company_
      AND h.invoice_id = invoice_id_
      AND i.company = h.company
      AND i.invoice_id = h.invoice_id
      AND i.item_id = invoice_item_id_
      AND TRUNC(h.invoice_date) BETWEEN TRUNC(begin_date_) AND TRUNC(invoice_date_)
      AND prel_update_allowed = 'TRUE';
BEGIN
   OPEN get_invoice_info;
   FETCH get_invoice_info INTO invoice_series_, invoice_no_, invoiced_price_, invoiced_qty_, invoice_date_from_inv_;
   CLOSE get_invoice_info;
   -- gelr:italy_intrastat, start
   App_Context_SYS.Set_Value('INVOICE_DATE_FROM_INV', invoice_date_from_inv_);
   -- gelr:italy_intrastat, end
   IF (invoiced_qty_ = 0) THEN
      invoiced_unit_price_ := invoiced_price_;
   ELSE
      invoiced_unit_price_ := invoiced_price_ / (invoiced_qty_ * conv_factor_/inverted_conv_factor_);
   END IF;
   IF (invoiced_unit_price_ < 0) THEN
      invoiced_unit_price_ := invoiced_unit_price_ * -1;
   END IF;
END Get_Rma_Invoice_Info___;


-- Call_Purch_Intrastat___
--   Calls PurchaseOrderIntrastatUtil
PROCEDURE Call_Purch_Intrastat___ (
   intrastat_id_        IN NUMBER,
   begin_date_          IN DATE,
   end_date_            IN DATE,
   invoice_date_        IN DATE,
   report_country_      IN VARCHAR2,
   language_            IN VARCHAR2,
   transaction_id_      IN NUMBER,
   eu_country_table_    IN Intrastat_Manager_API.eu_country_type,
   transaction_table_   IN Intrastat_Manager_API.mpccom_transaction_type  )
IS
BEGIN
   $IF (Component_Purch_SYS.INSTALLED)$THEN 
      @ApproveTransactionStatement(2013-11-28,MeAblk)
      SAVEPOINT before_purch_;
       Purchase_Intrastat_Util_API.Find_Intrastat_Data(intrastat_id_,
                                                       begin_date_,
                                                       end_date_,
                                                       invoice_date_,
                                                       report_country_,
                                                       language_,
                                                       transaction_id_,
                                                       eu_country_table_,
                                                       transaction_table_ );
   $ELSE 
      NULL;
   $END 
END Call_Purch_Intrastat___;


-- Get_Rma_Inv_Chg_Info___
--   This method retrieves the applicable invoiced charged amount
--   per unit for a particular RMA line.
PROCEDURE Get_Rma_Inv_Chg_Info___ (
   inv_chg_unit_price_    OUT NUMBER,
   unit_stat_charge_diff_ OUT NUMBER,
   company_               IN  VARCHAR2,
   order_no_              IN  VARCHAR2,
   line_no_               IN  VARCHAR2,
   rel_no_                IN  VARCHAR2,
   line_item_no_          IN  NUMBER,
   invoiced_qty_          IN  NUMBER,
   conv_factor_           IN  NUMBER,
   inverted_conv_factor_  IN  NUMBER,
   begin_date_            IN  DATE,
   invoice_date_          IN  DATE )
IS
   amount_         NUMBER := 0;
   total_amount_   NUMBER := 0;
   tot_stat_charge_diff_ NUMBER := 0;

   CURSOR get_con_ord_chg_lines IS
      SELECT order_no, sequence_no
      FROM customer_order_charge_tab
      WHERE order_no = order_no_
      AND line_no = line_no_
      AND rel_no = rel_no_
      AND line_item_no = line_item_no_;
   
   CURSOR get_con_rma_chg_lines(order_no_   IN VARCHAR2, sequence_no_   IN NUMBER) IS
      SELECT credit_invoice_no, credit_invoice_item_id, statistical_charge_diff * charged_qty statistical_charge_diff
      FROM return_material_charge_tab
      WHERE order_no = order_no_ 
      AND sequence_no = sequence_no_;

   CURSOR get_invoice_info (invoice_id_   IN VARCHAR2, invoice_item_id_   IN VARCHAR2) IS
      SELECT i.net_dom_amount
      FROM customer_order_inv_item i, customer_order_inv_head h
      WHERE h.company = company_
      AND h.invoice_id = invoice_id_
      AND i.company = h.company
      AND i.invoice_id = h.invoice_id
      AND i.item_id = invoice_item_id_
      AND TRUNC(h.invoice_date) BETWEEN TRUNC(begin_date_) AND TRUNC(invoice_date_);
   
BEGIN
   -- Loop through all the CO charge records which has a connection to the CO line in consideration. 
   FOR order_chg_lines IN get_con_ord_chg_lines LOOP
      -- Loop through all the RMA charge lines which are connected to a particular CO charge line.
      FOR rma_chg_lines IN get_con_rma_chg_lines(order_chg_lines.order_no, order_chg_lines.sequence_no) LOOP
         -- Find the invoiced charge amounnts.
         OPEN get_invoice_info(rma_chg_lines.credit_invoice_no, rma_chg_lines.credit_invoice_item_id);
         FETCH get_invoice_info INTO amount_;
         CLOSE get_invoice_info;
         total_amount_ := total_amount_ + amount_;
         IF rma_chg_lines.statistical_charge_diff != 0 THEN
            tot_stat_charge_diff_ := tot_stat_charge_diff_ + rma_chg_lines.statistical_charge_diff;
         END IF;
      END LOOP;
   END LOOP;
   IF (invoiced_qty_ !=0 ) THEN
      inv_chg_unit_price_ := total_amount_ / (invoiced_qty_ * conv_factor_/inverted_conv_factor_ ); 
      unit_stat_charge_diff_ := tot_stat_charge_diff_ / (invoiced_qty_ * conv_factor_ / inverted_conv_factor_);
   END IF;
   IF (inv_chg_unit_price_ < 0) THEN
      inv_chg_unit_price_ := (inv_chg_unit_price_ * -1);
   END IF;
END Get_Rma_Inv_Chg_Info___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Find_Intrastat_Data
--   Checks if the specified transaction is to be included in the Intrastat
--   report, and fetches order related Intrastat data for the current transaction.
PROCEDURE Find_Intrastat_Data (
   intrastat_id_   IN NUMBER,
   begin_date_     IN DATE,
   end_date_       IN DATE,
   invoice_date_   IN DATE,
   company_        IN VARCHAR2,
   report_country_ IN VARCHAR2,
   language_       IN VARCHAR2,
   transaction_id_    IN NUMBER,
   eu_country_table_  IN Intrastat_Manager_API.eu_country_type,
   transaction_table_ IN Intrastat_Manager_API.mpccom_transaction_type )
IS
   mode_of_transport_            VARCHAR2(200);
   delivery_country_             VARCHAR2(3);
   invoice_series_               VARCHAR2(20);
   triangulation_flag_           VARCHAR2(20) := 'NO TRIANGULATION';
   info_                         VARCHAR2(2000);
   customer_no_                  CUSTOMER_ORDER_TAB.customer_no%TYPE;
   delivery_terms_               VARCHAR2(5);
   ship_via_code_                VARCHAR2(3);
   customer_name_                VARCHAR2(4000);
   catalog_no_                   VARCHAR2(25);
   catalog_desc_                 RETURN_MATERIAL_LINE_TAB.catalog_desc%TYPE;
   catalog_type_                 VARCHAR2(4);
   unit_of_measure_              VARCHAR2(10);
   customs_stat_no_              VARCHAR2(15);
   intrastat_alt_unit_meas_      VARCHAR2(10);
   country_of_origin_            VARCHAR2(3);
   region_of_origin_             VARCHAR2(10);
   notc_                         VARCHAR2(2);
   intrastat_direction_          VARCHAR2(20);
   sales_part_rec_               SALES_PART_API.Public_Rec;
   non_inv_part_type_            VARCHAR2(7);
   region_port_                  VARCHAR2(10) := NULL;
   statistical_procedure_        VARCHAR2(25) := 'DELIVERY';
   invoice_number_               VARCHAR2(50);
   document_country_             VARCHAR2(3);
   supplier_country_             VARCHAR2(3);
   supplier_exempt_              VARCHAR2(20);
   intrastat_exempt_             VARCHAR2(20);
   order_no_                     VARCHAR2(12);
   line_no_                      VARCHAR2(4);
   rel_no_                       VARCHAR2(30);
   line_item_no_                 NUMBER;
   order_unit_price_             NUMBER;
   unit_charge_amount_           NUMBER;
   unit_charge_amount_inv_       NUMBER;
   invoiced_unit_price_          NUMBER;
   revised_qty_due_              NUMBER;
   conv_factor_                  NUMBER;
   inverted_conv_factor_         NUMBER;
   net_unit_weight_              NUMBER;
   intrastat_alt_qty_            NUMBER;
   rma_no_                       NUMBER;
   rma_line_no_                  NUMBER;
   invoice_id_                   NUMBER;
   invoice_item_id_              NUMBER;
   add_to_intrastat_             BOOLEAN := FALSE;
   order_rec_                    Customer_Order_API.Public_Rec;
   line_rec_                     Customer_Order_Line_API.Public_Rec;
   rma_rec_                      Return_Material_API.Public_Rec;
   create_co_intrastat_          BOOLEAN := TRUE;
   weight_unit_code_             VARCHAR2(10);
   order_type_to_use_            VARCHAR2(20);
   inv_trans_hist_rec_           Inventory_Transaction_Hist_API.Public_Rec;
   order_ref1_                   VARCHAR2(12);
   order_ref2_                   VARCHAR2(4);
   order_ref3_                   VARCHAR2(30);
   order_ref4_                   NUMBER;
   order_type_                   VARCHAR2(20);
   county_                       VARCHAR2(35);
   invoiced_qty_                 NUMBER;
   check_inv_part_               BOOLEAN; 
   config_intrastat_conv_factor_ NUMBER;
   return_material_reason_       VARCHAR2(10);
   tax_liability_type_db_        VARCHAR2(20);
   opponent_type_                VARCHAR2(20);
   unit_stat_charge_diff_        NUMBER;
   unit_stat_charge_inv_         NUMBER;
   cust_addr_rec_                Cust_Ord_Customer_Address_API.Public_Rec;
   org_rma_no_                   NUMBER;
   org_rma_line_no_              NUMBER;
   conn_demand_transaction_id_   NUMBER;
   intrastat_transaction_id_     NUMBER;
   contract_country_             VARCHAR2(2);
   customer_country_             VARCHAR2(2);
   shipment_id_                  NUMBER;
   shipment_rec_                 Shipment_API.Public_Rec;
   invoiced_curr_rate_           NUMBER;
   order_unit_price_temp_        NUMBER;
   demand_code_                  VARCHAR2(5);
   -- gelr:italy_intrastat, start
   exclude_line                  EXCEPTION;
   cpa_code_                     VARCHAR2(15);
   invoice_status_               VARCHAR2(4000);
   party_type_                   VARCHAR2(20);
   payment_method_               VARCHAR2(20);
   invoice_date_from_inv_        DATE;
   intrastat_direction_trans_    VARCHAR2(10);
   notc_code_trans_              VARCHAR2(2);
   amounts_sign_                 NUMBER;
   italy_intrastat_enabled_      BOOLEAN:=FALSE;
   
   CURSOR get_country_trans IS
      SELECT UPPER(intrastat_direction) as intrastat_direction, notc, intrastat_amount_sign
      FROM   mpccom_trans_code_country_tab
      WHERE  country_code     = report_country_
      AND    transaction_code = inv_trans_hist_rec_.transaction_code
      AND    included         = 'TRUE';                  
   -- gelr:italy_intrastat, end
   

BEGIN
   intrastat_transaction_id_ := transaction_id_;
   inv_trans_hist_rec_ := Inventory_Transaction_Hist_API.Get(transaction_id_);
   IF Company_Localization_Info_API.Get_Parameter_Value_Db(company_, 'ITALY_INTRASTAT') = Fnd_Boolean_API.DB_TRUE THEN
      italy_intrastat_enabled_:= TRUE;
   END IF;
   IF inv_trans_hist_rec_.source_ref_type = 'CUST ORDER' THEN
      IF Customer_Order_Line_API.Get_Rental_Db(inv_trans_hist_rec_.source_ref1, 
                                               inv_trans_hist_rec_.source_ref2, 
                                               inv_trans_hist_rec_.source_ref3, 
                                               inv_trans_hist_rec_.source_ref4) = Fnd_Boolean_API.DB_TRUE THEN
         RETURN;
      END IF;
   ELSIF inv_trans_hist_rec_.source_ref_type = 'RMA' THEN
      IF Return_Material_Line_API.Get_Rental_Db(inv_trans_hist_rec_.source_ref1, inv_trans_hist_rec_.source_ref4) = Fnd_Boolean_API.DB_TRUE THEN
         RETURN;
      END IF;
   END IF;   
   
   IF (inv_trans_hist_rec_.transaction_code IN ('PURDIR','INTPURDIR')) THEN
      Customer_Order_Pur_Order_API.Get_Custord_For_Purord( order_ref1_,
                                                           order_ref2_,
                                                           order_ref3_,
                                                           order_ref4_,
                                                           SUBSTR(inv_trans_hist_rec_.alt_source_ref1,1,12),
                                                           SUBSTR(inv_trans_hist_rec_.alt_source_ref2,1,4),
                                                           SUBSTR(inv_trans_hist_rec_.alt_source_ref3,1,30));

      order_type_ := 'CUST ORDER';
   ELSE
      order_type_    := inv_trans_hist_rec_.source_ref_type;
      order_ref1_    := inv_trans_hist_rec_.source_ref1;
      order_ref2_    := inv_trans_hist_rec_.source_ref2;
      order_ref3_    := inv_trans_hist_rec_.source_ref3;
      order_ref4_    := inv_trans_hist_rec_.source_ref4;
   END IF;
   
   -- gelr:italy_intrastat, start
   IF italy_intrastat_enabled_ THEN
      IF (Mpccom_Trans_Code_Country_API.Get_Included_Db(inv_trans_hist_rec_.transaction_code, report_country_) = 'FALSE') THEN
         RAISE exclude_line;
      END IF;
   END IF;
   IF (Intrastat_Line_API.Advance_Trans_For_Order_Exists(order_ref1_) = TRUE) THEN
      RAISE exclude_line;
   END IF;
   -- gelr:italy_intrastat, end
   
   Get_Transaction_Info___(notc_, intrastat_direction_, inv_trans_hist_rec_.transaction_code, transaction_table_);

   IF (inv_trans_hist_rec_.transaction_code IN ('OERET-NO','OERET-NINO','OERETIN-NO','OERET-SPNO')) THEN
      -- Transaction without order connection. Address information has to be fetched from RMA.
      rma_no_ := TO_NUMBER(order_ref1_);
      rma_line_no_ := TO_NUMBER(order_ref4_);

      -- Get RMA address information.
      rma_rec_ := Return_Material_API.Get(rma_no_);
      customer_no_ := rma_rec_.return_from_customer_no;
      intrastat_exempt_ := rma_rec_.intrastat_exempt;
      cust_addr_rec_ := Cust_Ord_Customer_Address_API.Get(customer_no_, rma_rec_.ship_addr_no);
      ship_via_code_ := NVL(rma_rec_.ship_via_code, cust_addr_rec_.ship_via_code);
      delivery_terms_ := NVL(rma_rec_.delivery_terms, cust_addr_rec_.delivery_terms);
      IF (rma_rec_.ship_addr_flag = 'N') THEN
      delivery_country_ := Iso_Country_API.Encode(Customer_Info_Address_API.Get_Country(
                                                                 customer_no_,
                                                                 rma_rec_.ship_addr_no));
      ELSE
         delivery_country_ := rma_rec_.ship_addr_country_code;
      END IF;

      -- Get sales part information.
      catalog_no_ := Return_Material_Line_API.Get_Catalog_No(rma_no_, rma_line_no_);
      sales_part_rec_ :=  Sales_Part_API.Get(inv_trans_hist_rec_.contract, catalog_no_);
      catalog_type_ := sales_part_rec_.catalog_type;
      catalog_desc_ := Sales_Part_API.Get_Catalog_Desc_For_Lang(inv_trans_hist_rec_.contract, catalog_no_, rma_rec_.language_code);
   ELSE
      -- Transactions with order connection. Address data can be fetched from customer order line.
      IF (inv_trans_hist_rec_.transaction_code IN ('OERET-EX','OERETURN', 'OERET-NI', 'OERET-NC', 'OERET-INT','OERETIN-NI','OERET-SCP','OERET-SINT', 'RETSHIPDIR', 'RETPDIR-SCP')) THEN
         -- Get order line keys from RMA.
         rma_no_ := TO_NUMBER(order_ref1_);
         rma_line_no_ := TO_NUMBER(order_ref4_);
         Get_Order_Line_Keys___(order_no_, line_no_, rel_no_, line_item_no_, rma_no_, rma_line_no_);

         IF (inv_trans_hist_rec_.transaction_code IN ('RETSHIPDIR', 'RETPDIR-SCP')) THEN
            org_rma_no_ := Return_Material_API.Get_Originating_Rma_No(rma_no_);
            org_rma_line_no_ := Return_Material_Line_API.Get_Originating_Rma_Line_No(rma_no_, rma_line_no_);
         END IF;
      ELSIF (inv_trans_hist_rec_.transaction_code IN ('RETDIFSREC', 'RETDIFSSCP')) THEN
         rma_no_ := TO_NUMBER(order_ref1_);
         rma_line_no_ := TO_NUMBER(order_ref4_);
         -- CO line is not connected in receipt rma. Hence need to get the originating rma
         org_rma_no_ := Return_Material_API.Get_Originating_Rma_No(rma_no_);
         org_rma_line_no_ := Return_Material_Line_API.Get_Originating_Rma_Line_No(rma_no_, rma_line_no_);
         Get_Order_Line_Keys___(order_no_, line_no_, rel_no_, line_item_no_, org_rma_no_, org_rma_line_no_);
      ELSE
         order_no_ := order_ref1_;
         line_no_ := order_ref2_;
         rel_no_ := order_ref3_;
         line_item_no_ := order_ref4_;
      END IF;

      order_rec_ := Customer_Order_API.Get(order_no_);
      line_rec_ := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);
      customer_no_ := order_rec_.customer_no;

      -- Get delivery address country.
      Get_Delivery_Country___(delivery_country_, order_no_, line_no_, rel_no_, line_item_no_, customer_no_);

      intrastat_exempt_ := line_rec_.intrastat_exempt;
      ship_via_code_    := line_rec_.ship_via_code;
      delivery_terms_   := line_rec_.delivery_terms;
      catalog_no_       := line_rec_.catalog_no;
      catalog_type_     := line_rec_.catalog_type;
      catalog_desc_     := line_rec_.catalog_desc;

      -- Added check, since value of county_ is needed only for Italy.
      IF (report_country_ = 'IT') THEN
         county_ := Company_Address_API.Get_County(Site_API.Get_Company(order_rec_.contract),
                                                   Site_API.Get_Delivery_Address(order_rec_.contract));
      END IF;
   END IF;

   IF delivery_country_ IN ('MC', 'IM') THEN
      delivery_country_ := Intrastat_Manager_API.Get_Including_Country(delivery_country_);
   END IF;

   -- Check if transaction should be included in Intrastat report.
   IF (Is_Eu_Country___(delivery_country_, eu_country_table_)) AND (intrastat_exempt_ = 'INCLUDE') THEN
      -- Transaction should only be included in Intrastat report if the delivery address
      -- is in another EU-country and if the address is not exempted from Intrastat reporting.

      -- Check the type of the sales part.
      IF (catalog_type_ = 'NON' OR catalog_type_ = 'KOMP') THEN
          -- Non-inventory sales part with category 'Service' should not be included in report.
          non_inv_part_type_ := Non_Inventory_Part_Type_API.Encode(Sales_Part_API.Get_Non_Inv_Part_Type(
                                                                   inv_trans_hist_rec_.contract, catalog_no_));
         -- gelr:italy_intrastat, start
         IF (non_inv_part_type_ = 'GOODS') OR (italy_intrastat_enabled_) THEN
              add_to_intrastat_ := TRUE;
         END IF;
         IF (non_inv_part_type_ = 'SERVICE') AND (italy_intrastat_enabled_) THEN 
            IF (rma_no_ IS NULL) THEN
               invoice_id_ := Get_Invoice_Id___(company_, order_no_, line_no_, rel_no_, line_item_no_, inv_trans_hist_rec_.date_time_created, begin_date_, end_date_, inv_trans_hist_rec_.source_ref5);
            ELSE
               invoice_id_ := Return_Material_Line_API.Get_Credit_Invoice_No(rma_no_, rma_line_no_);
            END IF;
   
            invoice_status_ := Customer_Order_Inv_Head_API.Get_Invoice_Status_Db(company_, invoice_id_);
            cpa_code_ := Sales_Part_API.Get_Statistical_Code(inv_trans_hist_rec_.contract, catalog_no_);
   
            IF invoice_id_ IS NULL THEN
               add_to_intrastat_ := FALSE;
            ELSE
               IF (invoice_status_ NOT IN ('PostedAuth', 'PaidPosted', 'PartlyPaidPosted')) THEN
                  add_to_intrastat_ := FALSE;
               END IF;
            END IF;
         END IF;
         
         IF (add_to_intrastat_) AND (italy_intrastat_enabled_) THEN
            payment_method_ := Payment_Plan_API.Get_First_Open_Payment_Method(company_, invoice_id_);
   
            IF payment_method_ IS NULL THEN
               party_type_ := Customer_Order_Inv_Head_API.Get_Party_Type(company_, invoice_id_);
               $IF Component_Payled_SYS.INSTALLED $THEN
               payment_method_ := Payment_Way_Per_Identity_API.Get_Default_Pay_Way_Db( company_, customer_no_, party_type_);
               $END
            END IF;
         END IF;
         -- gelr:italy_intrastat, end
      ELSE
          -- Inventory part.
          add_to_intrastat_ := TRUE;
      END IF;

      IF (add_to_intrastat_) THEN
         IF (delivery_country_ != report_country_) THEN
            -- Delivery address is in another EU-country.
            tax_liability_type_db_ := Tax_Liability_API.Get_Tax_Liability_Type_Db(line_rec_.tax_liability, delivery_country_);
            
            IF (inv_trans_hist_rec_.transaction_code NOT IN ('OERETURN','OERET-NI','OERET-NO','OERET-NINO','OERETIN-NO','OERET-NC','OERET-INT', 'OERET-EX',
                                                             'OERETIN-NI','OERET-SPNO','OERET-SCP','OERET-SINT','SHIPDIR','SHIPTRAN','INTSHIP-NI', 'RETSHIPDIR', 'RETDIR-SCP', 'RETDIFSREC', 'RETDIFSSCP',
                                                             'UNSHIPDIR', 'UNSHIPTRAN', 'UNINTSHPNI')) THEN
               -- Get document address country.
               Get_Document_Country___(document_country_, customer_no_, order_rec_.bill_addr_no);
               demand_code_ := Customer_Order_Line_API.Get_Demand_Code_Db(order_no_, line_no_, rel_no_, line_item_no_);
               
	       -- Added ELSIF condition to ommit the transactions which the tax liability is not EXEMPT
               IF (document_country_ = report_country_) AND (tax_liability_type_db_ != 'EXM') THEN
                  -- Special case of third party trade. The transaction should not be included in
                  -- Intrastat report.
                  add_to_intrastat_ := FALSE;
                  triangulation_flag_ := 'TRIANGULATION';
               ELSIF (demand_code_ = 'IPD' AND document_country_ != report_country_ AND tax_liability_type_db_ != 'EXM') THEN
                  IF(inv_trans_hist_rec_.transaction_code = 'OESHIP')THEN
                     add_to_intrastat_ := FALSE; 
                  END IF;
               END IF;
            END IF;

            IF (inv_trans_hist_rec_.transaction_code IN ('PODIRSH', 'INTPODIRSH', 'PODIRSH-NI','PODIRINTEM','INTPODIRIM','PURDIR','INTPURDIR',
                                                         'POUNDIRSH', 'UNINTPODIR', 'UNPODIR-NI', 'UNPODRINEM', 'UNINPODRIM'))
               OR ((inv_trans_hist_rec_.transaction_code IN ('OESHIPNI', 'OEUNSHIPNI')) AND ((line_rec_.supply_code = 'PD') OR (line_rec_.supply_code = 'IPD'))) THEN

               Get_Supplier_Addr_Info___(supplier_country_, supplier_exempt_, order_no_, line_no_, rel_no_, line_item_no_);
               
               IF (document_country_ = report_country_) AND (tax_liability_type_db_ != 'EXM') THEN
                  -- Special case of third party trade. The transaction should not be included in
                  -- Intrastat report.
                  add_to_intrastat_ := FALSE;
               ELSIF ((supplier_country_ = report_country_) AND (supplier_exempt_ = 'INCLUDE') AND (tax_liability_type_db_ != 'TAX')) THEN
                  -- Special case of third party trade. The transaction should be included
                  -- in Intrastat report.
                  add_to_intrastat_   := TRUE;
                  triangulation_flag_ := 'TRIANGULATION';
               ELSE
                  add_to_intrastat_ := FALSE;
               END IF;
            END IF;
            
            contract_country_ := Company_Address_API.Get_Country_Db(Site_API.Get_Company(order_rec_.contract), Site_API.Get_Delivery_Address(order_rec_.contract));
            customer_country_ := Customer_Info_API.Get_Country_Db(order_rec_.customer_no);
            IF ((contract_country_ = customer_country_) AND (inv_trans_hist_rec_.transaction_code IN ('SHIPDIR', 'UNSHIPDIR'))) THEN
               -- SHIPDIR should not be included to the intrastat report if the customer's country is the same as supply site country.
               -- If SHIPDIR is not including it should not be included UNSHIPDIR as it is the reversal transaction of SHIDIR.
               add_to_intrastat_ := FALSE;
            END IF;
         ELSIF ((delivery_country_ = report_country_) AND
                (inv_trans_hist_rec_.transaction_code IN ('PODIRSH', 'INTPODIRSH', 'OESHIPNI', 'PODIRSH-NI','PODIRINTEM','INTPODIRIM','PURDIR','INTPURDIR',
                                                          'POUNDIRSH', 'UNINTPODIR', 'UNPODIR-NI', 'UNPODRINEM', 'UNINPODRIM', 'OEUNSHIPNI'))) THEN       -- Delivery country is in the same country as reporting country.
            -- Delivery country is in the same country as reporting country.
            -- Special case of third party trade.
            -- Get the country of the supplier address
            Get_Supplier_Addr_Info___(supplier_country_, supplier_exempt_, order_no_, line_no_, rel_no_, line_item_no_);
            tax_liability_type_db_ := Tax_Liability_API.Get_Tax_Liability_Type_Db(line_rec_.tax_liability, delivery_country_);

            -- If the supplier_country_ is another EU-country, and is not exempted from
            -- Intrastat reporting, then Intrastat import should be reported.
            IF ((supplier_country_ != report_country_ ) AND
                (Is_Eu_Country___(supplier_country_, eu_country_table_)) AND
                (supplier_exempt_ = 'INCLUDE') AND (tax_liability_type_db_ != 'EXM')) THEN

                intrastat_direction_ := 'IMPORT';
                -- A PurchaseOrderIntrastat should be created instead:
                create_co_intrastat_ := FALSE;
                add_to_intrastat_ := TRUE;
                triangulation_flag_ := 'TRIANGULATION';
            ELSE
               add_to_intrastat_ := FALSE;
            END IF;
         ELSE
            add_to_intrastat_ := FALSE;
         END IF;
      END IF;
   END IF;

   IF (add_to_intrastat_) THEN
      IF (create_co_intrastat_) THEN
         --Fetch data for Intrastat line.
         -- For Intrastat RETINTPODS transaction details should be shown instead of the transactions RETSHIPDIR, RETDIR-SCP, RETDIFSREC, RETDIFSSCP
         IF (inv_trans_hist_rec_.transaction_code IN ('RETSHIPDIR', 'RETDIR-SCP', 'RETDIFSREC', 'RETDIFSSCP')) THEN
             conn_demand_transaction_id_ := Invent_Trans_Interconnect_API.Get_Connected_Transaction_Id(transaction_id_, Invent_trans_Conn_Reason_API.DB_INTERSITE_TRANSFER );
             inv_trans_hist_rec_ := Inventory_Transaction_Hist_API.Get(conn_demand_transaction_id_);
             intrastat_transaction_id_ := conn_demand_transaction_id_;
             Get_Transaction_Info___(notc_, intrastat_direction_, inv_trans_hist_rec_.transaction_code, transaction_table_);
             rma_no_ := org_rma_no_;
             rma_line_no_ := org_rma_line_no_;
        
         END IF;
         -- Get Part information.
         Get_Part_Info___(unit_of_measure_, country_of_origin_, region_of_origin_, customs_stat_no_,
                          intrastat_alt_unit_meas_, net_unit_weight_, intrastat_alt_qty_, catalog_no_, inv_trans_hist_rec_.contract, language_,
                          intrastat_transaction_id_, intrastat_id_, italy_intrastat_enabled_);

         -- Returned material connected to a customer order.
         IF (inv_trans_hist_rec_.transaction_code IN ('OERETURN', 'OERET-NI', 'OERET-NC', 'OERET-EX', 'OERET-INT','OERETIN-NI','OERET-SCP','OERET-SINT', 'RETPODIRSH', 'RETPODSINT', 'RETINTPODS')) THEN
            -- Get RMA information.
            Get_Rma_Info___(order_unit_price_, conv_factor_, inverted_conv_factor_, invoice_id_,
                            invoice_item_id_, rma_no_, rma_line_no_, begin_date_, end_date_ , inv_trans_hist_rec_.date_applied, report_country_, company_);

            mode_of_transport_ := Mpccom_Ship_Via_API.Get_Mode_Of_Transport(ship_via_code_);

            IF (mode_of_transport_ IS NULL) THEN
               info_ := Language_SYS.Translate_Constant(lu_name_,
                            'NO_MODE: No Mode of Transport has been selected for the Ship Via Code used on Customer Order :P1, Line No :P2, Del No :P3.',
                                    language_, order_no_, line_no_, rel_no_);
               Set_Status_Info___(intrastat_transaction_id_, intrastat_id_, language_, info_);
            END IF;

            IF (delivery_terms_ IS NULL) THEN
               info_ := Language_SYS.Translate_Constant(lu_name_,
                            'NO_DEL_TERMS: No Delivery Terms has been entered on Customer Order :P1, Line No :P2, Del No :P3.',
                                    language_, order_no_, line_no_, rel_no_);
               Set_Status_Info___(intrastat_transaction_id_, intrastat_id_, language_, info_);
            END IF;

            -- Get RMA invoice information.
            Get_Rma_Invoice_Info___(invoice_series_, invoice_number_, invoiced_unit_price_, invoiced_qty_,
                                    company_, invoice_id_, invoice_item_id_, conv_factor_, inverted_conv_factor_, begin_date_, invoice_date_);

            Get_Rma_Inv_Chg_Info___ (unit_charge_amount_inv_, unit_stat_charge_diff_, company_, order_no_, line_no_, 
                                     rel_no_, line_item_no_, invoiced_qty_, conv_factor_, inverted_conv_factor_, begin_date_, invoice_date_);
         -- Returned material not connected to a customer order.
         ELSIF (inv_trans_hist_rec_.transaction_code IN ('OERET-NO','OERET-NINO','OERETIN-NO','OERET-SPNO')) THEN
            -- Get RMA information.
            Get_Rma_Info___(order_unit_price_, conv_factor_, inverted_conv_factor_, invoice_id_,
                            invoice_item_id_, rma_no_, rma_line_no_, begin_date_, end_date_ ,inv_trans_hist_rec_.date_applied, report_country_, company_);

            mode_of_transport_ := Mpccom_Ship_Via_API.Get_Mode_Of_Transport(ship_via_code_);

            IF (mode_of_transport_ IS NULL) THEN
               info_ := Language_SYS.Translate_Constant(lu_name_,
                              'NO_DEF_MODE: No Mode of Transport has been selected for the default Ship Via Code for Customer :P1, Address ID :P2, Site :P3.',
                                      language_, customer_no_, rma_rec_.ship_addr_no, inv_trans_hist_rec_.contract);
               Set_Status_Info___(intrastat_transaction_id_, intrastat_id_, language_, info_);
            END IF;

            IF (delivery_terms_ IS NULL) THEN
               info_ := Language_SYS.Translate_Constant(lu_name_,
                              'NO_DEF_DEL_TERMS: No default Delivery Terms has been entered for Customer :P1, Address ID :P2.',
                                      language_, customer_no_, rma_rec_.ship_addr_no);
               Set_Status_Info___(intrastat_transaction_id_, intrastat_id_, language_, info_);
            END IF;

            -- Get RMA invoice information.
            Get_Rma_Invoice_Info___(invoice_series_, invoice_number_, invoiced_unit_price_, invoiced_qty_,
                                    company_, invoice_id_, invoice_item_id_, conv_factor_, inverted_conv_factor_, begin_date_, invoice_date_);

         ELSE
            -- Get order line information.
            Get_Order_Line_Info___(order_unit_price_, conv_factor_, inverted_conv_factor_, mode_of_transport_, delivery_terms_,
                                   order_no_, line_no_, rel_no_, line_item_no_, inv_trans_hist_rec_.date_applied, report_country_, company_);

            shipment_id_ := Customer_Order_Delivery_API.Get_Shipment_Id(inv_trans_hist_rec_.source_ref5);
            
            IF (shipment_id_ IS NOT NULL) THEN
               shipment_rec_ := Shipment_API.Get(shipment_id_);
               mode_of_transport_ := Mpccom_Ship_Via_API.Get_Mode_Of_Transport(shipment_rec_.ship_via_code);
               delivery_terms_ := shipment_rec_.delivery_terms;
            END IF;

            IF (mode_of_transport_ IS NULL) THEN
               info_ := Language_SYS.Translate_Constant(lu_name_,
                            'NO_MODE: No Mode of Transport has been selected for the Ship Via Code used on Customer Order :P1, Line No :P2, Del No :P3.',
                                    language_, order_no_, line_no_, rel_no_);
               Set_Status_Info___(intrastat_transaction_id_, intrastat_id_, language_, info_);
            END IF;

            IF (delivery_terms_ IS NULL) THEN
               info_ := Language_SYS.Translate_Constant(lu_name_,
                            'NO_DEL_TERMS: No Delivery Terms has been entered on Customer Order :P1, Line No :P2, Del No :P3.',
                                    language_, order_no_, line_no_, rel_no_);
               Set_Status_Info___(intrastat_transaction_id_, intrastat_id_, language_, info_);
            END IF;

            -- If the charge qty is greater than one and invoiced charge qty is less than charge qty,
            -- it should be correctly calculate the statistical charge diff value as we calculate the unit charge amounts.
            -- Hence introduced two variables unit_stat_charge_diff_, unit_charge_amount_inv_.
            -- Get charge information.
            Get_Charge_Info___(unit_charge_amount_, unit_stat_charge_diff_, order_no_, line_no_, rel_no_,
                               line_item_no_, inv_trans_hist_rec_.quantity, begin_date_, invoice_date_);

            Get_Invoice_Info___(invoice_number_, invoice_series_, invoiced_unit_price_,
                                unit_charge_amount_inv_, unit_stat_charge_inv_, order_no_, line_no_, rel_no_, line_item_no_,
                                conv_factor_, inverted_conv_factor_, begin_date_, invoice_date_, company_,
                                inv_trans_hist_rec_.date_time_created, inv_trans_hist_rec_.source_ref5);
         END IF;

         IF (report_country_ = 'DK') THEN
            IF (notc_ = 31) THEN
               notc_ := 32;
            END IF;
         END IF;

         customer_name_  := Customer_Info_API.Get_Name(customer_no_);
         check_inv_part_ := FALSE;

         IF (Sales_Part_API.Exist_Inventory_Part(inv_trans_hist_rec_.contract,
                                                 inv_trans_hist_rec_.part_no)=1) THEN
            check_inv_part_ := TRUE;
         END IF;
         
         IF (((catalog_type_ = 'NON') OR (catalog_type_ = 'KOMP' AND check_inv_part_ = FALSE ))= FALSE) THEN
            Inventory_Part_Config_API.Get_Net_Weight_And_Unit_Code(net_unit_weight_,
                                                                   weight_unit_code_,
                                                                   inv_trans_hist_rec_.contract,
                                                                   inv_trans_hist_rec_.part_no,
                                                                   inv_trans_hist_rec_.configuration_id);
         ELSE
            weight_unit_code_ := Company_Invent_Info_API.Get_Uom_For_Weight(company_);
         END IF;
         
         IF (weight_unit_code_ != 'kg') THEN            
            -- When having Base UoM other than kg as the Company weight UoM it cannot be define the conversion with kg.
            -- With that data set up it allows to create lines. 
            BEGIN                  
               net_unit_weight_ := Iso_Unit_API.Convert_Unit_Quantity(net_unit_weight_,
                                                                      weight_unit_code_,
                                                                      'kg');                  
            EXCEPTION
               WHEN OTHERS THEN
                  NULL;
            END;            
         END IF;

         config_intrastat_conv_factor_ := Inventory_Part_Config_API.Get_Intrastat_Conv_Factor(inv_trans_hist_rec_.contract,
                                                                                              inv_trans_hist_rec_.part_no,
                                                                                              inv_trans_hist_rec_.configuration_id);

         IF (report_country_ = 'DE') THEN
               IF (country_of_origin_ = 'DE' OR country_of_origin_ IS NULL) AND (intrastat_direction_ = 'IMPORT') THEN
                  country_of_origin_ :=  delivery_country_;
               END IF;
               IF (inv_trans_hist_rec_.transaction_code IN ('OESHIP', 'OEUNSHIP')  AND line_rec_.supply_code IN ('PT', 'IPT')) THEN
                  Get_Supplier_Addr_Info___(supplier_country_, supplier_exempt_, order_no_, line_no_, rel_no_, line_item_no_);
                  IF supplier_country_ != 'DE' THEN
                     region_of_origin_ := '99';
                  END IF;
               END IF;
               IF (inv_trans_hist_rec_.transaction_code = 'OERETURN') THEN
                  invoiced_unit_price_ := 0;
               END IF;               
         END IF;

         IF (inv_trans_hist_rec_.transaction_code IN ('INTPURDIR', 'PURDIR')) THEN
            order_no_          := inv_trans_hist_rec_.source_ref1;
            line_no_           := inv_trans_hist_rec_.source_ref2;
            rel_no_            := inv_trans_hist_rec_.source_ref3;
            line_item_no_      := inv_trans_hist_rec_.source_ref4;
            order_type_to_use_ := inv_trans_hist_rec_.source_ref_type;
            order_unit_price_  := Inventory_Transaction_Cost_API.Get_Sum_Unit_Cost(intrastat_transaction_id_);
         ELSE
            order_no_         := order_ref1_;
            line_no_          := order_ref2_;
            rel_no_           := order_ref3_;
            line_item_no_     := order_ref4_;
            order_type_to_use_:= order_type_;
         END IF;
            
         -- Fecthing return reason from RMA.
         IF (inv_trans_hist_rec_.transaction_code IN ('OERETURN', 'OERET-NI', 'OERET-NC', 'OERET-INT','OERETIN-NI', 'OERET-EX',
                                                      'OERET-SCP','OERET-SINT','OERET-NO','OERET-NINO','OERETIN-NO','OERET-SPNO', 'RETPODIRSH', 'RETPODIRNI', 'RETINTPODS', 'RETPODSINT')) THEN
            return_material_reason_ := Return_Material_Line_API.Get_Return_Reason_Code(rma_no_, rma_line_no_);
         END IF;

         IF (report_country_ = 'IT') THEN
            opponent_type_ := 'CUSTOMER';
         ELSE
            opponent_type_ := NULL;
         END IF;
         
         IF (report_country_ = 'SE' AND (invoiced_unit_price_ = 0 OR invoiced_unit_price_ IS NULL)) THEN
            IF(catalog_type_ != 'KOMP' OR (catalog_type_ = 'KOMP' AND order_unit_price_ = 0)) THEN
               invoiced_unit_price_ := Inventory_Transaction_Cost_API.Get_Sum_Unit_Cost(transaction_id_);
            END IF;
         END IF;
         
         -- This is specially done for Poland considering a legal requirement. According to their business practise,
         -- they use only correction invoices. They don't use credit invoices for any business transaction. This is
         -- implemented considering the senario of creating correction invoices without changing the price through a
         -- customer order.
         IF (report_country_ = 'PL') THEN
            IF (invoiced_qty_ = 0 AND inv_trans_hist_rec_.transaction_code IN ('OERETURN', 'OERET-NI', 'OERET-NC', 'OERET-INT', 'OERET-EX',
                                                                               'OERETIN-NI','OERET-SCP','OERET-SINT' )) THEN
               Get_Rma_Info___(order_unit_price_temp_, conv_factor_, inverted_conv_factor_, invoice_id_, invoice_item_id_, rma_no_, rma_line_no_, begin_date_, end_date_, inv_trans_hist_rec_.date_applied, report_country_, company_);
               invoiced_curr_rate_ := Customer_Order_Inv_Head_API.Get_Curr_Rate(company_, NULL, NULL, invoice_id_);
               invoiced_unit_price_ := Return_Material_Line_API.Get_Sale_Unit_Price(rma_no_, rma_line_no_) * invoiced_curr_rate_ / (conv_factor_ * inverted_conv_factor_);
            END IF;
         END IF;

         IF (inv_trans_hist_rec_.transaction_code IN ('OEUNSHIP', 'OEUNSHIPNI', 'COOEUNSHIP', 'UNINTSHPNI', 'UNSHIPTRAN', 'UNSHIPDIR',
                                                      'POUNDIRSH', 'UNINTPODIR', 'UNPODRINEM', 'UNINPODRIM', 'UNPODIR-NI')) THEN
            inv_trans_hist_rec_.quantity := -inv_trans_hist_rec_.quantity;   
         END IF;
         
         -- gelr:italy_intrastat, start
            invoice_date_from_inv_ := App_Context_SYS.Find_Date_Value('INVOICE_DATE_FROM_INV', NULL);
            IF (italy_intrastat_enabled_)THEN
               OPEN get_country_trans;
               FETCH get_country_trans INTO intrastat_direction_trans_, notc_code_trans_, amounts_sign_;
   
               -- Change amounts sign, Intrastat direction and NOTC if exception definition is found in Intrastat_Country_Trans table
               IF get_country_trans%FOUND THEN
                  IF intrastat_direction_trans_ IS NOT NULL THEN
                     intrastat_direction_ := intrastat_direction_trans_;
                  END IF;
   
                  IF notc_code_trans_ IS NOT NULL THEN
                     notc_ := notc_code_trans_;
                  END IF;
   
                  IF amounts_sign_ = -1 THEN   
                     order_unit_price_       := - order_unit_price_;                     
                     unit_charge_amount_     := - unit_charge_amount_;
                     invoiced_unit_price_    := - invoiced_unit_price_;
                     unit_charge_amount_inv_ := - unit_charge_amount_inv_;
                  END IF;
               END IF;
   
               CLOSE get_country_trans;
            END IF;
         -- gelr:italy_intrastat, end         
         
         IF (demand_code_ = 'IPD') THEN
            IF (Customer_Info_API.Get_Country_Db(customer_no_) != Customer_Info_API.Get_Country_Db(line_rec_.deliver_to_customer_no)) THEN
               customer_no_   := line_rec_.deliver_to_customer_no;
               customer_name_ := Customer_Info_API.Get_Name(line_rec_.deliver_to_customer_no);
            END IF;
         ELSIF (line_rec_.end_customer_id IS NOT NULL) AND (Customer_Info_API.Get_Country_Db(customer_no_) != Customer_Info_API.Get_Country_Db(line_rec_.end_customer_id))  THEN
            customer_no_   := line_rec_.end_customer_id;
            customer_name_ := Customer_Info_API.Get_Name(line_rec_.end_customer_id);
         END IF;         
         
         -- Create Intrastat line.
         Intrastat_Line_API.New_Intrastat_Line(intrastat_id_,
                                               intrastat_transaction_id_,
                                               inv_trans_hist_rec_.transaction_code,
                                               order_type_to_use_,
                                               inv_trans_hist_rec_.contract,
                                               inv_trans_hist_rec_.part_no,
                                               catalog_desc_,
                                               inv_trans_hist_rec_.configuration_id,
                                               inv_trans_hist_rec_.lot_batch_no,
                                               inv_trans_hist_rec_.serial_no,
                                               order_no_,
                                               line_no_,
                                               rel_no_,
                                               line_item_no_,
                                               inv_trans_hist_rec_.direction,
                                               inv_trans_hist_rec_.quantity,
                                               inv_trans_hist_rec_.qty_reversed,
                                               unit_of_measure_,
                                               inv_trans_hist_rec_.reject_code,
                                               inv_trans_hist_rec_.date_applied,
                                               inv_trans_hist_rec_.userid,
                                               net_unit_weight_,
                                               customs_stat_no_,
                                               NVL(config_intrastat_conv_factor_, intrastat_alt_qty_),
                                               intrastat_alt_unit_meas_,
                                               notc_,
                                               intrastat_direction_,
                                               country_of_origin_,
                                               'AUTOMATIC',
                                               delivery_country_,
                                               customer_no_, -- opponent number
                                               customer_name_, -- opponent name
                                               order_unit_price_,
                                               NULL,
                                               unit_charge_amount_,
                                               mode_of_transport_,
                                               invoice_series_,
                                               invoice_number_,
                                               invoiced_unit_price_,
                                               NULL,
                                               unit_charge_amount_inv_,
                                               delivery_terms_,
                                               triangulation_flag_,
                                               statistical_procedure_,
                                               region_port_,
                                               region_of_origin_,
                                               county_,
                                               NULL,
                                               return_material_reason_,
                                               opponent_type_,
                                               NVL(unit_stat_charge_diff_, unit_stat_charge_inv_ ),
                                               invoice_date_from_inv_,
                                               cpa_code_,
                                               NULL,
                                               NULL,
                                               NULL,
                                               payment_method_,
                                               NULL,
                                               NULL,   
                                               NULL);
      ELSE
         Call_Purch_Intrastat___ (intrastat_id_,
                                  begin_date_,
                                  end_date_,
                                  invoice_date_,
                                  report_country_,
                                  language_,
                                  intrastat_transaction_id_,
                                  eu_country_table_,
                                  transaction_table_ );
      END IF;
   END IF;
EXCEPTION
   -- gelr:italy_intrastat, start
   WHEN exclude_line THEN
      @ApproveTransactionStatement(2015-04-17,SALIDE)
      ROLLBACK TO before_order_;
   -- gelr:italy_intrastat, end
   WHEN OTHERS THEN
     @ApproveTransactionStatement(2013-11-28,MeAblk)
     ROLLBACK TO before_order_;
     Set_Status_Info___(intrastat_transaction_id_, intrastat_id_, language_, SQLERRM);
END Find_Intrastat_Data;


PROCEDURE Find_Data_From_Credit_Invoice (
   intrastat_id_   IN NUMBER,
   begin_date_     IN DATE,
   end_date_       IN DATE,
   invoice_date_   IN DATE,
   company_        IN VARCHAR2,
   report_country_    IN VARCHAR2,
   eu_country_table_  IN Intrastat_Manager_API.eu_country_type )
IS
   delivery_country_           VARCHAR2(3);
   base_unit_price_            NUMBER := NULL;
   contract_country_           VARCHAR2(35);

   CURSOR get_credit_inv_data IS
      SELECT co.invoice_date, 
             co.delivery_address_id, 
             co.invoice_no,
             co.series_id, 
             co.identity, 
             co.currency, 
             co.fin_curr_rate,
             co.div_factor, 
             coi.invoiced_qty, 
             coi.price_um, 
             coi.sale_unit_price,
             rm.contract,
             rm.return_reason_code,
             rm.qty_returned_inv
        FROM Customer_Order_Inv_Head co, Return_Material_Line_Tab rm, Customer_Order_Inv_Item coi
       WHERE co.rma_no = rm.rma_no
         AND co.invoice_id = rm.credit_invoice_no
         AND co.invoice_date >= begin_date_
         AND co.invoice_date <= GREATEST(end_date_, invoice_date_)
         AND coi.invoice_id = co.invoice_id
         AND coi.rma_no = rm.rma_no
         AND coi.rma_line_no = rm.rma_line_no
         AND rm.rental = 'FALSE'
         AND rm.rowstate = 'ReturnCompleted'
         AND rm.company = company_;        
BEGIN
   FOR rec_ IN get_credit_inv_data LOOP
      delivery_country_ := Iso_Country_API.Encode(Customer_Info_Address_API.Get_Country(rec_.identity, rec_.delivery_address_id));
      IF delivery_country_ IN ('MC', 'IM') THEN
         delivery_country_ := Intrastat_Manager_API.Get_Including_Country(delivery_country_);
      END IF;

      contract_country_  := Iso_Country_API.Encode(Company_Address_API.Get_Country(company_, Site_API.Get_Delivery_Address(rec_.contract)));
      IF contract_country_ IN ('MC', 'IM') THEN
         contract_country_ := Intrastat_Manager_API.Get_Including_Country(contract_country_);
      END IF;

      IF ((delivery_country_ != report_country_) AND Intrastat_Manager_Api.Eu_Country(delivery_country_, eu_country_table_) AND contract_country_ = 'GB') THEN
         Invoice_Library_Api.Calculate_Amount(rec_.sale_unit_price, rec_.currency, rec_.fin_curr_rate, rec_.div_factor, base_unit_price_,company_);
         Intrastat_Line_API.New_Intrastat_Line(intrastat_id_,
                                               NULL,
                                               NULL,
                                               NULL,
                                               NULL,
                                               NULL,
                                               NULL,
                                               NULL,
                                               NULL,
                                               NULL,
                                               NULL,
                                               NULL,
                                               NULL,
                                               NULL,
                                               NULL,
                                               NVL(rec_.qty_returned_inv, rec_.invoiced_qty),
                                               NULL,
                                               rec_.price_um,
                                               NULL,
                                               rec_.invoice_date,
                                               Fnd_Session_Api.Get_Fnd_User,
                                               NULL,
                                               NULL,
                                               NULL,
                                               NULL,
                                               '16',
                                               'EXPORT',
                                               NULL,
                                               'AUTOMATIC',
                                               delivery_country_,
                                               NULL,
                                               NULL,
                                               base_unit_price_,
                                               NULL,
                                               NULL,
                                               NULL,
                                               rec_.series_id,
                                               rec_.invoice_no,
                                               base_unit_price_,
                                               NULL,
                                               NULL,
                                               NULL,
                                               'NO TRIANGULATION',
                                               'DELIVERY',
                                               NULL,
                                               NULL,
                                               NULL,
                                               NULL,
                                               rec_.return_reason_code,
                                               NULL,
                                               NULL --unit_stat_charge_diff_
                                               );
      END IF;
      -- resetting the IN OUT parameter for next loop
      base_unit_price_ := NULL;
   END LOOP;
END Find_Data_From_Credit_Invoice;



