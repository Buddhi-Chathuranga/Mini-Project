-----------------------------------------------------------------------------
--
--  Logical unit: CustomerOrderChargeUtil
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210520  KiSalk  Bug 158901(SCZ-15337), Modified Recalc_Percentage_Charge_Taxes and Modify_Cust_Order_Charge_Line to update free_of_charge field of connected charges along with CO lines.
--  210520          In Consolidate_Grouped_Charges, filtered out free of charge records from cursor get_order_line_charges.
--  200311  ChBnlk  Bug 158364(SCZ-14195), Modified New_Cust_Order_Charge_Line() by removing the fetching of active_shipment_ from Shipment line and 
--  200311          used shipment_connected from the customer order line to improve performance.
--  210323  Hahalk  Bug 158423 (SCZ-14157), Modified Recalc_Percentage_Charge_Taxes() to update the CO lines and calculate the charges correctly when having an invoiced CO lines with connected and not connected charges.
--  201019  Hahalk  SCZ-11506,  Modified Consolidate_Grouped_Charges() method by adding condition to check whether charge_type is not null before trying to create new customer order/quotation charge line.
--  201013  DhAplk  Bug 154965 (SCZ-11195), Modified Get_Freight_Charge_Attr___() method by removing value assigning for line_total_weight_ and line_total_volume_ to retrieve correct charge price value from freight price list.
--  200505  ThKrLk  Bug 153087 (SCZ-9625), Modified  Modify_Cust_Order_Charge_Line() method by allowing modify partial delivered charge lines.
--  200319  ThKrLk  Bug 152626(SCZ-9137), Modified Consolidate_Grouped_Charges() to get new values for charge_lines_(j_).line_weight and charge_lines_(j_).line_volume if the first picked value is null inside the NVL.
--  200312  Hahalk  Bug 152543 (SCZ-9103), Modified the get_charge cursor in Recalc_Percentage_Charge_Taxes() to update the customer order line which is in released state and added if condition to avoid the unnecessary charge fetching
--  191022  KiSalk  Bug 150603(SCZ-7484), Renamed variables charge_weight_ and charge_volumn_ to charge_weight_charge_uom_ and charge_volumn_charge_uom_ in Consolidate_Grouped_Charges.
--  191022          Initialized them to have values even if the UoM of company and charge type are same.
--  190725  SBalLK  Bug 149169(SCZ-5792), Modified Consolidate_Grouped_Charges() and Get_Freight_Charge_Attr___() methods by replacing line weight with converted weight relate to freight price list unit of measure.
--  190718  BudKlk  Bug 148970 (SCZ-5620), Modified the methods Exist_Charge_For_This_Price() and Get_Matched_Quote_Charge_No() to replace the base prices with  
--  190718          the currency values to avoid creating several promotion lines when there is a currency difference.
--  190427  KiSalk  Bug 148461(SCZ-4704), Modified Get_Freight_Charge_Attr___ to convert unit charge quantity, if Unit of Measures of company and charge type are different.
--  180427  DilMlk  Bug 140801, Modified Recalc_Percentage_Charge_Taxes to recalculate percentage charge taxes correctly for CO line connected charges.
--  180119  CKumlk  STRSC-15930, Modified New_Cust_Order_Charge_Line by changing Get_State() to Get_Objstate(). 
--  170426  SURBLK  Modified Calc_Consolidate_Charges(), Modify_Quotation_Charge_Line() to filter out rental lines for consolidate/calculate freight
--  170228  NaLrlk  STRSC-5730, Modified New_Quotation_Charge_Line() to exclude rental charges for quotation lines.
--  170125  slkapl  FINHR-5388, Implement Tax Structures in Sales Promotions
--  160526  ErFelk  Bug 127383, Modified Consolidate_Grouped_Charges() by adding another condition to an else block which was added from Bug 116392 so that it will not get 
--  160526          executed if base_freight_charge_ was zero.
--  160314  IsSalk  FINHR-686, Moved server logic of QuoteLineTaxLines to Source Tax Item Order.
--  160215  IsSalk  FINHR-722, Renamed attribute FEE_CODE to TAX_CODE in ORDER_QUOTATION_LINE_TAB.
--  160118  IsSalk  FINHR-657, Used FndBoolean in taxable attribute in Sales Charge Type.
--  160111  IsSalk  FINHR-581, Renamed column FEE_CODE to TAX_CODE in SALES_CHARGE_TYPE_TAB.
--  151215  RoJalk  LIM-5387, Added source ref type to Shipment_Line_API.Check_Active_Shipment_Exist method.
--  151110  RoJalk  LIM-4610, Rename ShipmentOrderLine LU to ShipmentLine.
--  151103  IsSalk  FINHR-316, Renamed attribute FEE_CODE to TAX_CODE in Customer Order Line.
--  150615  BudKlk  Bug 122926, Modified the method Get_Pack_Size_Charge_Attr___() in order to get the price_conv_factor_ to calculate Charge(%)Basis/Curr accordingly.
--  150521  ShKolk  Bug 122691, Modified Modify_Cust_Order_Charge_Line() to consolidate charges if delivery terms are modified. 
--  150214  ShKolk  EAP-804, Added Consolidate_Grouped_Charges() to group CO/SQ lines based on consolidation attributes and call Calc_Consolidate_Charges() per group.
--  150128  SlKapl  PRSC-5757, Added Recalc_Percentage_Charge_Taxes
--  140808  PraWlk  PRSC-2145, Modified Calc_Consolidate_Charges() by adding new state 'CO Created' to the condition.
--  140606  HimRlk  Modified Exist_Charge_For_This_Price and Get_Matched_Quote_Charge_No by adding two new parameters campaign_id_ and deal_id_.
--  140418  KiSalk  Bug 116392, In Calc_Consolidate_Charges, added 0 check for line_weight/line_volume added to null check of cursors get_customer_order_lines and
--  140418          get_order_quotion_lines; when looping through charge_lines_, skipped iterations when line_weight/line_volume is 0.
--  140410  NipKlk  Bug 116392, Applied the rounding logic that was done for  fixed delivery freight lines to non fixed delivery lines in the method Calc_Consolidate_Charges.
--  140321  HimRlk  Modified logic to pass use_price_incl_tax value when fetching freight price lists.
--  130228  JeeJlk  Modified Get_Matched_Quote_Charge_No() and Exist_Charge_For_This_Price() to check whether there already exist a line in the specific order
--  130228          with this specific charge price or charge price incl tax.
--  130211  JeeJlk  Modified Get_Freight_Charge_Attr___() and Calc_Consolidate_Charges() to consider use_price_incl_tax value when calculating the percentage charge basis.
--  130207  HimRlk  Modified Get_Pack_Size_Charge_Attr___() to consider use_price_incl_tax value when calculating the percentage charge basis.
--  130129  RuLiLk  Bug 106274 Modified methods Modify_Cust_Order_Charge_Line() and New_Cust_Order_Charge_Line(). Freight Charge lines should be consolidated,
--  130129          when updated or added due to modification of an existing CO line or due to addition of a new Co line where CO header is in Released state.
--  121114  RoJalk  Modified New_Cust_Order_Charge_Line and replaced Shipment_Order_Line_API.Get_Active_Shipment_Id with Shipment_Order_Line_API.Check_Active_Shipment_Exist.
--  120829  SURBLK  Added BASE_CHARGE_AMT_INCL_TAX and CHARGE_AMOUNT_INCL_TAX to Get_Pack_Size_Charge_Attr___ and Get_Freight_Charge_Attr__.
--  120412  AyAmlk  Bug 100608, Increased the length to 5 of the column delivery_terms in Line_Rec in method Calc_Consolidate_Charges.
--  120328  MaMalk  Modified Get_Pack_Size_Charge_Attr___ to only proceed with the calculation for the remaining quantity when Input UoM is not given.
--  120319  DaZase  Added checks inside New_Cust_Order_Charge_Line for freight charges so they are not created for a COL when its shipment connected and shipment_freight_charge on site is true.
--  120105  NaLrlk  Modified Calc_Consolidate_Charges to exclude Won quatation charge lines
--  111005  ShKolk  Modified New_Cust_Order_Charge_Line() and Calc_Consolidate_Charges() to stop creating charges for same company IPD orders.
--  110930  ChJalk  Added function Chk_Conn_Freight_Or_Prom_Exist.
--  110920  MaMalk  Modified methods Calc_Consolidate_Charges, New_Cust_Order_Charge_Line and Modify_Cust_Order_Charge_Line to consider Company Owned lines only.
--  110907  NaLrlk  Modified the method Calc_Consolidate_Charges to consider Collect on delivery term.
--  110905  MaMalk  Added parameter insert_freight_only_ to method New_Cust_Order_Charge_Line and inserted only freight charges if this is true.
--  110531  MiKulk  Modified the method Get_Pack_Size_Charge_Attr__ to first check for the user entered input unit of measure group
--  110526  ChJalk  Modified the method Modify_Cust_Order_Charge_Line to change the fee codes of charge lines when there are multiple tax lines for the charge line.
--  110519  RiLase  Changed COLLECT from client to decoded db value when creating the attr for
--  110519          call to Customer_Order_Charge_API.New in Calc_Consolidate_Charges.
--  110516  MiKulk  Modidifed the Calc_Consolidate_Charges for quotations and fixed delivery
--  110513  MiKulk  Modified the methods New_Cust_Order_Charge_Line and Calc_Consolidate_Charges to exclude non charged customer order lines from freight calculation.
--  110428  MiKulk  Modified the method Calc_Consolidate_Charges to apply the fixed delivery freight only to the co lines connected to the header freight price list no.
--  110420  NaLrlk  Modified the method Get_Pack_Size_Charge_Attr___ to include the fee code in attr.
--  110330  AndDse  BP-4760, Modified Get_Freight_Charge_Attr___ due to changes in Cust_Ord_Date_Calculation.
--  110317  AndDse  BP-4453, Modified Get_Freight_Charge_Attr___ and Calc_Consolidate_Charges to consider calendar when calculating with leadtimes.
--  101221  ChFolk  Added new function Get_Matched_Quote_Charge_No which returns quotation_charge_no if there already exist a charge line in the given quotation
--  101221          with this specific charge type and charge price.
--  101216  NaLrlk  Added Remove_Quote_Promo_Charges and rename the method Remove_Promotion_Charges to Remove_Order_Promo_Charges.
--  101208  ChFolk  Modified Calc_Consolidate_Charges to remove use_shipment_freight_charge_ check for quotation.
--  101206  ChFolk  Modified Calc_Consolidate_Charges to adjust rounding for fix delivery freight.
--  101112  ChFolk  Modified Calc_Consolidate_Charges to add fix_deliv_freight to the sales quotation charge consolidation.
--  101105  ChFolk  Modified Calc_Consolidate_Charges to exclude freight consolidation for lost quotation lines.
--  101021  Chfolk  Added new procedure Quote_Conn_Fr_Charge_Exist___ and replaced Conn_Freight_Charge_Exist___ with Order_Conn_Fr_Charge_Exist___.
--  101018  ChFolk  Added new parameter quotation_no_ into Calc_Consolidate_Charges and Delete_Zero_Charge_Lines___.
--  100921  ChFolk  Modified New_Quotation_Charge_Line, Modify_Quotation_Charge_Line, Get_Freight_Charge_Attr___ to insert and modify freight charges for quotation line.
--  100818  Chfolk  Modified Calc_Consolidate_Charges to remove updating freight information during consolidation as it is already updated when CO liine is saved.
--  100809  ShKolk  Modified Get_Freight_Charge_Attr___() and Get_Pack_Size_Charge_Attr___(), removed fee_code from attr_.
--  100616  ShKolk  Modified Get_Pack_Size_Charge_Attr___() to include CHARGE_PERCENT_BASIS.
--  100616  ShKolk  Modified New_Quotation_Charge_Line to create charges only if input UOM is allowed
--  100426  JeLise  Renamed zone_definition_id to freight_map_id.
--  100407  ShKolk  Modified Pack size charge fetcing logic to handle Input UOM.
--  100310  KiSalk  charge (percentage) included in the methods Get_Pack_Size_Charge_Attr___, New_Cust_Order_Charge_Line and New_Quotation_Charge_Line.
--  091217  AmPalk  Bug 86877, Modified Modify_Cust_Order_Charge_Line and New_Cust_Order_Charge_Line to use Collect_API.Decode to get the client values.
--  091110  KiSalk  Modified Modify_Cust_Order_Charge_Line and Modify_Quotation_Charge_Line to send fee_code to charge line change.
--  091021  DaZase  Removed the pack size charge category check in methods Remove_Connected_Chg_Lines/Remove_Connected_QChg_Lines and made sure
--  091021          that these methods can handle removal of several charge lines connected to one order/quotation line.
--  091015  ShKolk  Modified Calc_Consolidate_Charges to group using the stored freight_price_list_ in the customer order line.
--  091014  ShKolk  Modified Get_Freight_Charge_Attr___() to convert freight_free_amount_ if currency is different from base currency.
--  091013  ShKolk  Modified Calc_Consolidate_Charges to consider forward_agent_id_ in cursors when grouping.
--  091007  DaZase  Added CHARGE_COST to attribute string in methods Modify_Cust_Order_Charge_Line/Modify_Quotation_Charge_Line.
--  090911  ShKolk  Modified Delete_Zero_Charge_Lines___() to delete only freight charge lines.
--  090903  ShKolk  Modified Modify_Cust_Order_Charge_Line() to select only freight charges in cursor get_freight_charge_seq.
--  090824  ShKolk  Modified Delete_Zero_Charge_Lines___() to delete unnecessary charge lines.
--  090817  HimRlk  Modified Calc_Consolidate_Charges(), New_Cust_Order_Charge_Line() and Modify_Cust_Order_Charge_Line() assigned TRUE to server_dtata_change.
--  090817  ShKolk  Modified Calc_Consolidate_Charges() to create charges if calculate_freight_charge is TRUE.
--  090806  MaJalk  Bug 80825, Added zone_definition_id to the Freight_Price_List_Line_API.Get_Valid_Charge_Line calls.
--  090803  ShKolk  Modified Calc_Consolidate_Charges() added null weight and volume check for the cursor get_customer_order_lines.
--  090710  MiKulk  Modified the method Remove_Promotion_Charges to remove the charges correctly.
--  090708  ShKolk  Modified consolidation logic to create new charge lines for all CO lines before consolidating. Added Conn_Freight_Charge_Exist___()
--  090708          and Delete_Zero_Charge_Lines___.
--  090624  DaZase  Added Remove_Promotion_Charges and Exist_Charge_For_This_Price.
--  090403  MaHplk  Modified full_truck_price  to fix_deliv_freight in Calc_Consolidate_Charges.
--  090319  MaHplk  Modified Calc_Consolidate_Charges to handle full truck price.
--  090316  KiSalk  Merged bug 80654, Modified Get_Freight_Charge_Attr___ by assigning fee_code from CO, for charge line attr as well, for instances the customer is not liable for
--  090316          pay tax. Removed unnecessary cursor get_coline_weight_volume instead used public_rec of CO line, since it was a performance buster in the code.
--  090220  MaHplk  Modified New_Cust_Order_Charge_Line, Modify_Cust_Order_Charge_Line and Calc_Consolidate_Charges.
--  090116  ShKolk  Modified Get_Freight_Charge_Attr___() and Calc_Consolidate_Charges() to consider freight_free_amount_ when calculating charges.
--  090109  NaLrlk  Modified the methods New_Cust_Order_Charge_Line, New_Quotation_Charge_Line and Get_Pack_Size_Charge_Attr___ to handle the fee_code for pack size charge.
--  090105  ShKolk  Modified the logic that fetches min_freight_amount.
--  081223  KiSalk  Condition to check if Freight Charge Count greater than 1 added in Calc_Consolidate_Charges.
--  081021  AmPalk  Modified Calc_Consolidate_Charges to update charge cost when consolidating and to devide min freight amount among lines as a non-unit charge.
--  081016  AmPalk  Restricted inserts and updates of Freight charges with out CO Line or Freight Info. on sales part. Freight charge cost will be base acharge amount.
--  081016  MaJalk  Modified New_Cust_Order_Charge_Line, New_Quotation_Charge_Line, Modify_Quotation_Charge_Line, Modify_Cust_Order_Charge_Line
--  081016           to raise error message when charge amount is greater than line total.
--  081015  AmPalk  Modified New_Cust_Order_Charge_Line by blocking automatic freight charges addition if it is not allowed on delivery term.
--  081007  MaJalk  At methods Modify_Cust_Order_Charge_Line and Modify_Quotation_Charge_Line, fetch currency from Company_Finanace_API.
--  080917  AmPalk  Added Calc_Consolidate_Charges.
--  080912  AmPalk  Modified New_Cust_Order_Charge_Line and Modify_Cust_Order_Charge_Line and added Get_Freight_Charge_Attr___.
--  080904  MaJalk  Modified New_Cust_Order_Charge_Line, Modify_Quotation_Charge_Line, Modify_Cust_Order_Charge_Line and
--  080904          New_Quotation_Charge_Line to stop creation of charge line when charge qty is 0.
--  080829  MaJalk  Modified Modify_Cust_Order_Charge_Line and Modify_Quotation_Charge_Line.
--  080828  MaJalk  Changed the parameter order of call Pack_Size_Charge_List_Line_API.Get_Pack_Size_Chg_Line.
--  080825  MaJalk  Changed sales_charge_type_category to sales_chg_type_category.
--  080812  MaJalk  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

db_true_                      CONSTANT VARCHAR2(4)  := Fnd_Boolean_API.db_true;
db_false_                     CONSTANT VARCHAR2(5)  := Fnd_Boolean_API.db_false;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Get_Pack_Size_Charge_Attr___
--   Returns attr_ with values from Pack Size Charge List.
PROCEDURE Get_Pack_Size_Charge_Attr___ (
   attr_ IN OUT VARCHAR2 )
IS
   contract_                     VARCHAR2(5);
   currency_code_                VARCHAR2(3);
   customer_no_pay_              VARCHAR2(20);
   customer_no_                  VARCHAR2(20);
   input_unit_meas_group_id_     VARCHAR2(30);
   input_unit_meas_              VARCHAR2(30);
   line_no_                      VARCHAR2(4);
   order_no_                     VARCHAR2(12);
   pack_size_charge_list_no_     VARCHAR2(10);
   part_no_                      VARCHAR2(25);
   quotation_no_                 VARCHAR2(12);
   rel_no_                       VARCHAR2(4);
   tax_code_                     VARCHAR2(20);
   price_effectivity_date_       DATE;
   line_item_no_                 NUMBER;
   pack_size_charge_percentage_  NUMBER;
   pack_size_charge_amount_      NUMBER;
   pack_size_charge_cost_        NUMBER;
   pack_size_fixed_charge_       NUMBER;
   total_pack_size_chg_amount_   NUMBER;
   input_qty_                    NUMBER;
   charged_qty_                  NUMBER;
   currency_rate_                NUMBER;
   qty_                          NUMBER;
   rem_qty_                      NUMBER;
   conv_factor_                  NUMBER;
   dummy_                        NUMBER;
   base_sale_unit_price_         NUMBER;
   base_charge_percent_basis_    NUMBER;
   charge_percent_basis_         NUMBER;
   charge_type_rec_              Sales_Charge_Type_API.Public_Rec;
   ord_rec_                      Customer_Order_API.Public_Rec;
   order_line_rec_               Customer_Order_Line_API.Public_Rec;
   quot_rec_                     Order_Quotation_API.Public_Rec;
   quot_line_rec_                Order_Quotation_Line_API.Public_Rec;
   pack_size_chg_rec_            Pack_Size_Charge_List_API.Public_Rec;
   co_line_unit_conv_factor_     NUMBER;
   base_unit_price_incl_tax_     NUMBER;
   price_conv_factor_             NUMBER;


   -- First select the conversion factor of the requested unit code
   CURSOR get_conv_factor_for_input_uom IS
      SELECT iu.conversion_factor
      FROM pack_size_charge_list_line_tab pz,
           input_unit_meas_tab iu
      WHERE pz.charge_list_no = pack_size_charge_list_no_
      AND   pz.input_unit_meas_group_id = input_unit_meas_group_id_
      AND   pz.input_unit_meas_group_id = iu.input_unit_meas_group_id
      AND   pz.unit_code = iu.unit_code
      AND   pz.unit_code = input_unit_meas_
      AND   TRUNC(pz.valid_from_date) <= TRUNC(price_effectivity_date_);


   -- Select unit code and conversion factor
   CURSOR get_input_uoms IS
      SELECT pz.unit_code, iu.conversion_factor
      FROM pack_size_charge_list_line_tab pz,
           input_unit_meas_tab iu
      WHERE pz.charge_list_no = pack_size_charge_list_no_
      AND   pz.input_unit_meas_group_id = input_unit_meas_group_id_
      AND   pz.input_unit_meas_group_id = iu.input_unit_meas_group_id
      AND   pz.unit_code = iu.unit_code
      AND   TRUNC(pz.valid_from_date) <= TRUNC(price_effectivity_date_)
      GROUP BY pz.unit_code, iu.conversion_factor
      ORDER BY iu.conversion_factor DESC;

BEGIN
   order_no_      := Client_SYS.Get_Item_Value('ORDER_NO',     attr_);
   quotation_no_  := Client_SYS.Get_Item_Value('QUOTATION_NO', attr_);
   line_no_       := Client_SYS.Get_Item_Value('LINE_NO',      attr_);
   rel_no_        := Client_SYS.Get_Item_Value('REL_NO',       attr_);
   line_item_no_  := Client_SYS.Get_Item_Value('LINE_ITEM_NO', attr_);
   pack_size_charge_list_no_ := Client_SYS.Get_Item_Value('CHARGE_PRICE_LIST_NO', attr_);

   pack_size_chg_rec_         := Pack_Size_Charge_List_API.Get(pack_size_charge_list_no_);

   IF order_no_ IS NOT NULL THEN
      order_line_rec_         := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);
      ord_rec_                := Customer_Order_API.Get(order_no_);
      charge_type_rec_        := Sales_Charge_Type_API.Get(ord_rec_.contract, pack_size_chg_rec_.charge_type);
      price_effectivity_date_ := NVL(order_line_rec_.price_effectivity_date, SYSDATE);

      contract_               := ord_rec_.contract;
      currency_code_          := ord_rec_.currency_code;
      customer_no_pay_        := ord_rec_.customer_no_pay;
      customer_no_            := ord_rec_.customer_no;
      part_no_                := order_line_rec_.part_no;
      input_unit_meas_        := order_line_rec_.input_unit_meas;
      input_qty_              := order_line_rec_.input_qty;
      qty_                    := order_line_rec_.buy_qty_due;
      IF (ord_rec_.use_price_incl_tax = 'FALSE') THEN
         base_sale_unit_price_   := order_line_rec_.base_sale_unit_price;
      ELSE
         base_unit_price_incl_tax_ := order_line_rec_.base_unit_price_incl_tax;
      END IF;
      IF (charge_type_rec_.taxable = Fnd_Boolean_API.DB_TRUE) THEN
         tax_code_            := order_line_rec_.tax_code;
      ELSE
         tax_code_            := charge_type_rec_.tax_code;
      END IF;
      price_conv_factor_      := order_line_rec_.price_conv_factor;
   ELSE
      quot_line_rec_          := Order_Quotation_Line_API.Get(quotation_no_, line_no_, rel_no_, line_item_no_);
      quot_rec_               := Order_Quotation_API.Get(quotation_no_);
      charge_type_rec_        := Sales_Charge_Type_API.Get(quot_rec_.contract, pack_size_chg_rec_.charge_type);
      price_effectivity_date_ := NVL(quot_rec_.price_effectivity_date, SYSDATE);
      contract_               := quot_rec_.contract;
      currency_code_          := quot_rec_.currency_code;
      customer_no_pay_        := quot_rec_.customer_no_pay;
      customer_no_            := quot_rec_.customer_no;
      part_no_                := quot_line_rec_.part_no;
      input_unit_meas_        := quot_line_rec_.input_unit_meas;
      input_qty_              := quot_line_rec_.input_qty;
      qty_                    := quot_line_rec_.buy_qty_due;
      IF (quot_rec_.use_price_incl_tax = 'FALSE') THEN
         base_sale_unit_price_   := quot_line_rec_.base_sale_unit_price;
      ELSE
         base_unit_price_incl_tax_ := quot_line_rec_.base_unit_price_incl_tax;
      END IF;
      IF (charge_type_rec_.taxable = Fnd_Boolean_API.DB_TRUE) THEN
         tax_code_            := quot_line_rec_.tax_code;
      ELSE
         tax_code_            := charge_type_rec_.tax_code;
      END IF;
      price_conv_factor_      := quot_line_rec_.price_conv_factor;
   END IF;

   input_unit_meas_group_id_ := Inventory_Part_API.Get_Input_Unit_Meas_Group_Id(contract_, part_no_);

   -- If input qty has decimal values, FLOOR value is taken
   IF input_qty_ IS NOT NULL THEN
      conv_factor_ := Input_Unit_Meas_API.Get_Conversion_Factor(input_unit_meas_group_id_,input_unit_meas_);
      qty_ := FLOOR(input_qty_) * conv_factor_;
   END IF;

   Client_SYS.Clear_Attr(attr_);

    -- first try to reserve from the customer requested input_uom
   OPEN get_conv_factor_for_input_uom;
   FETCH get_conv_factor_for_input_uom INTO co_line_unit_conv_factor_;
   CLOSE get_conv_factor_for_input_uom;

   IF co_line_unit_conv_factor_ IS NOT NULL THEN
      input_qty_ := FLOOR(qty_/co_line_unit_conv_factor_);
      rem_qty_   := MOD(qty_,co_line_unit_conv_factor_);

      IF (input_qty_ > 0) THEN
         charged_qty_ := input_qty_;
         Pack_Size_Charge_List_Line_API.Get_Pack_Size_Chg_Line(pack_size_charge_amount_, pack_size_charge_percentage_, pack_size_charge_cost_, pack_size_fixed_charge_,
                                                               pack_size_charge_list_no_, input_unit_meas_group_id_,
                                                               input_unit_meas_, price_effectivity_date_ );

         IF (pack_size_charge_amount_ IS NULL AND pack_size_charge_percentage_ IS NULL) THEN
            pack_size_charge_amount_ := pack_size_fixed_charge_;
            charged_qty_ := 1;
         END IF;
         IF (pack_size_charge_amount_ IS NOT NULL) THEN
            total_pack_size_chg_amount_ := pack_size_charge_amount_;
            IF (Company_Finance_API.Get_Currency_Code(pack_size_chg_rec_.company) != currency_code_) THEN
               -- convert above base into sales price
               Customer_Order_Pricing_API.Get_Sales_Price_In_Currency(pack_size_charge_amount_, currency_rate_,
                                                                      NVL(customer_no_pay_, customer_no_),
                                                                      contract_, currency_code_,
                                                                      total_pack_size_chg_amount_, ord_rec_.currency_rate_type);
            END IF;
         END IF;
         
         IF (base_sale_unit_price_ IS NOT NULL) THEN
            base_charge_percent_basis_ := (base_sale_unit_price_ * price_conv_factor_) * co_line_unit_conv_factor_;
         ELSIF (base_unit_price_incl_tax_ IS NOT NULL) THEN
            base_charge_percent_basis_ := (base_unit_price_incl_tax_ * price_conv_factor_) * co_line_unit_conv_factor_;
         END IF;
         IF (Company_Finance_API.Get_Currency_Code(pack_size_chg_rec_.company) != currency_code_) THEN
            Customer_Order_Pricing_API.Get_Sales_Price_In_Currency(charge_percent_basis_, currency_rate_,
                                                                   NVL(customer_no_pay_, customer_no_),
                                                                   contract_, currency_code_,
                                                                   base_charge_percent_basis_, ord_rec_.currency_rate_type);
         END IF;

         IF order_no_ IS NOT NULL THEN
            Client_SYS.Add_To_Attr('ORDER_NO',           order_no_,                             attr_);
         ELSE
            Client_SYS.Add_To_Attr('QUOTATION_NO',       quotation_no_,                         attr_);
         END IF;
         Client_SYS.Add_To_Attr('LINE_NO',               line_no_,                              attr_);
         Client_SYS.Add_To_Attr('REL_NO',                rel_no_,                               attr_);
         Client_SYS.Add_To_Attr('LINE_ITEM_NO',          line_item_no_,                         attr_);
         Client_SYS.Add_To_Attr('CHARGE_PRICE_LIST_NO',  pack_size_charge_list_no_,             attr_);
         Client_SYS.Add_To_Attr('SERVER_DATA_CHANGE',    db_true_,                              attr_);
         Client_SYS.Add_To_Attr('CHARGE_TYPE',           pack_size_chg_rec_.charge_type,        attr_);
         Client_SYS.Add_To_Attr('CHARGE_AMOUNT',         NVL(pack_size_charge_amount_, total_pack_size_chg_amount_), attr_);
         Client_SYS.Add_To_Attr('CHARGE_AMOUNT_INCL_TAX',         NVL(pack_size_charge_amount_, total_pack_size_chg_amount_), attr_);
         Client_SYS.Add_To_Attr('CHARGE',                pack_size_charge_percentage_,          attr_);
         Client_SYS.Add_To_Attr('CHARGE_COST',           pack_size_charge_cost_,                attr_);
         Client_SYS.Add_To_Attr('CHARGED_QTY',           charged_qty_,                          attr_);
         Client_SYS.Add_To_Attr('BASE_CHARGE_AMOUNT',    total_pack_size_chg_amount_,           attr_);
         Client_SYS.Add_To_Attr('BASE_CHARGE_AMT_INCL_TAX',       total_pack_size_chg_amount_,           attr_);
         Client_SYS.Add_To_Attr('CONTRACT',              contract_,                             attr_);
         Client_SYS.Add_To_Attr('SALES_UNIT_MEAS',       charge_type_rec_.sales_unit_meas,      attr_);
         Client_SYS.Add_To_Attr('PRINT_CHARGE_TYPE_DB',  charge_type_rec_.print_charge_type,    attr_);
         Client_SYS.Add_To_Attr('TAX_CODE',              tax_code_,                             attr_);
         Client_SYS.Add_To_Attr('UNIT_CHARGE_DB',        db_true_,                              attr_);
         Client_SYS.Add_To_Attr('INTRASTAT_EXEMPT_DB',   db_false_,                             attr_);
         Client_SYS.Add_To_Attr('CHARGE_PERCENT_BASIS',  NVL(charge_percent_basis_,base_charge_percent_basis_),      attr_);
         Client_SYS.Add_To_Attr('BASE_CHARGE_PERCENT_BASIS',  base_charge_percent_basis_,       attr_);
         attr_ := attr_||CHR(2);
      END IF;
      qty_ := rem_qty_;
   END IF;


   IF (input_unit_meas_ IS NULL) THEN
      IF qty_ > 0 THEN

         -- Go through all Input UOMs to decide how it is divided and create charge lines
         FOR rec_ IN get_input_uoms LOOP
            input_qty_ := FLOOR(qty_/rec_.conversion_factor);
            rem_qty_   := MOD(qty_,rec_.conversion_factor);
            input_unit_meas_ := rec_.unit_code;

            IF (input_qty_ > 0) THEN
               charged_qty_ := input_qty_;
               Pack_Size_Charge_List_Line_API.Get_Pack_Size_Chg_Line(pack_size_charge_amount_, pack_size_charge_percentage_, pack_size_charge_cost_, pack_size_fixed_charge_,
                                                                     pack_size_charge_list_no_, input_unit_meas_group_id_,
                                                                     input_unit_meas_, price_effectivity_date_ );

               IF (pack_size_charge_amount_ IS NULL AND pack_size_charge_percentage_ IS NULL) THEN
                  pack_size_charge_amount_ := pack_size_fixed_charge_;
                  charged_qty_ := 1;
               END IF;
               IF (pack_size_charge_amount_ IS NOT NULL) THEN
                  total_pack_size_chg_amount_ := pack_size_charge_amount_;
                  IF (Company_Finance_API.Get_Currency_Code(pack_size_chg_rec_.company) != currency_code_) THEN
                     -- convert above base into sales price
                     Customer_Order_Pricing_API.Get_Sales_Price_In_Currency(pack_size_charge_amount_, currency_rate_,
                                                                            NVL(customer_no_pay_, customer_no_),
                                                                            contract_, currency_code_,
                                                                            total_pack_size_chg_amount_, ord_rec_.currency_rate_type);
                  END IF;
               END IF;
               
               IF (base_sale_unit_price_ IS NOT NULL) THEN
                  base_charge_percent_basis_ := (base_sale_unit_price_ * price_conv_factor_) * rec_.conversion_factor;
               ELSIF (base_unit_price_incl_tax_ IS NOT NULL) THEN
                  base_charge_percent_basis_ := (base_unit_price_incl_tax_ * price_conv_factor_) *  rec_.conversion_factor;
               END IF;
               IF (Company_Finance_API.Get_Currency_Code(pack_size_chg_rec_.company) != currency_code_) THEN
                  Customer_Order_Pricing_API.Get_Sales_Price_In_Currency(charge_percent_basis_, currency_rate_,
                                                                         NVL(customer_no_pay_, customer_no_),
                                                                         contract_, currency_code_,
                                                                         base_charge_percent_basis_, ord_rec_.currency_rate_type);
               END IF;

               IF order_no_ IS NOT NULL THEN
                  Client_SYS.Add_To_Attr('ORDER_NO',           order_no_,                             attr_);
               ELSE
                  Client_SYS.Add_To_Attr('QUOTATION_NO',       quotation_no_,                         attr_);
               END IF;
               Client_SYS.Add_To_Attr('LINE_NO',               line_no_,                              attr_);
               Client_SYS.Add_To_Attr('REL_NO',                rel_no_,                               attr_);
               Client_SYS.Add_To_Attr('LINE_ITEM_NO',          line_item_no_,                         attr_);
               Client_SYS.Add_To_Attr('CHARGE_PRICE_LIST_NO',  pack_size_charge_list_no_,             attr_);
               Client_SYS.Add_To_Attr('SERVER_DATA_CHANGE',    db_true_,                              attr_);
               Client_SYS.Add_To_Attr('CHARGE_TYPE',           pack_size_chg_rec_.charge_type,        attr_);
               Client_SYS.Add_To_Attr('CHARGE_AMOUNT',         NVL(pack_size_charge_amount_, total_pack_size_chg_amount_), attr_);
               Client_SYS.Add_To_Attr('CHARGE_AMOUNT_INCL_TAX', NVL(pack_size_charge_amount_, total_pack_size_chg_amount_), attr_);
               Client_SYS.Add_To_Attr('CHARGE',                pack_size_charge_percentage_,          attr_);
               Client_SYS.Add_To_Attr('CHARGE_COST',           pack_size_charge_cost_,                attr_);
               Client_SYS.Add_To_Attr('CHARGED_QTY',           charged_qty_,                          attr_);
               Client_SYS.Add_To_Attr('BASE_CHARGE_AMOUNT',    total_pack_size_chg_amount_,           attr_);
               Client_SYS.Add_To_Attr('BASE_CHARGE_AMT_INCL_TAX', total_pack_size_chg_amount_,        attr_);
               Client_SYS.Add_To_Attr('CONTRACT',              contract_,                             attr_);
               Client_SYS.Add_To_Attr('SALES_UNIT_MEAS',       charge_type_rec_.sales_unit_meas,      attr_);
               Client_SYS.Add_To_Attr('PRINT_CHARGE_TYPE_DB',  charge_type_rec_.print_charge_type,    attr_);
               Client_SYS.Add_To_Attr('TAX_CODE',              tax_code_,                             attr_);
               Client_SYS.Add_To_Attr('UNIT_CHARGE_DB',        db_true_,                              attr_);
               Client_SYS.Add_To_Attr('INTRASTAT_EXEMPT_DB',   db_false_,                             attr_);
               Client_SYS.Add_To_Attr('CHARGE_PERCENT_BASIS',  NVL(charge_percent_basis_,base_charge_percent_basis_),      attr_);
               Client_SYS.Add_To_Attr('BASE_CHARGE_PERCENT_BASIS',  base_charge_percent_basis_,       attr_);
               attr_ := attr_||CHR(2);

            END IF;

            pack_size_charge_amount_     := NULL;
            pack_size_charge_percentage_ := NULL;
            pack_size_charge_cost_       := NULL;
            pack_size_fixed_charge_      := NULL;
            total_pack_size_chg_amount_  := NULL;

            qty_ := rem_qty_;
            EXIT WHEN (qty_ = 0);
         END LOOP;
      END IF;

      -- Calculate charge for remaining items which does not qualify for above Input UOMs
      IF (qty_ > 0) THEN
         Pack_Size_Charge_List_Line_API.Get_Pack_Size_Chg_Line(dummy_, dummy_, pack_size_charge_cost_, pack_size_fixed_charge_,
                                                               pack_size_charge_list_no_, input_unit_meas_group_id_,
                                                               input_unit_meas_, price_effectivity_date_ );

         pack_size_charge_amount_ := pack_size_fixed_charge_;

         IF (pack_size_charge_amount_ IS NOT NULL) THEN
            total_pack_size_chg_amount_ := pack_size_charge_amount_;
            IF (Company_Finance_API.Get_Currency_Code(pack_size_chg_rec_.company) != currency_code_) THEN
               -- convert above base into sales price
               Customer_Order_Pricing_API.Get_Sales_Price_In_Currency(pack_size_charge_amount_, currency_rate_,
                                                                      NVL(customer_no_pay_, customer_no_),
                                                                      contract_, currency_code_,
                                                                      total_pack_size_chg_amount_, ord_rec_.currency_rate_type);
            END IF;

            IF order_no_ IS NOT NULL THEN
               Client_SYS.Add_To_Attr('ORDER_NO',           order_no_,                             attr_);
            ELSE
               Client_SYS.Add_To_Attr('QUOTATION_NO',       quotation_no_,                         attr_);
            END IF;
            Client_SYS.Add_To_Attr('LINE_NO',               line_no_,                              attr_);
            Client_SYS.Add_To_Attr('REL_NO',                rel_no_,                               attr_);
            Client_SYS.Add_To_Attr('LINE_ITEM_NO',          line_item_no_,                         attr_);
            Client_SYS.Add_To_Attr('CHARGE_PRICE_LIST_NO',  pack_size_charge_list_no_,             attr_);
            Client_SYS.Add_To_Attr('SERVER_DATA_CHANGE',    db_true_,                              attr_);
            Client_SYS.Add_To_Attr('CHARGE_TYPE',           pack_size_chg_rec_.charge_type,        attr_);
            Client_SYS.Add_To_Attr('CHARGE_AMOUNT',         NVL(pack_size_charge_amount_, total_pack_size_chg_amount_), attr_);
            Client_SYS.Add_To_Attr('CHARGE_AMOUNT_INCL_TAX', NVL(pack_size_charge_amount_, total_pack_size_chg_amount_), attr_);
            Client_SYS.Add_To_Attr('CHARGE',                pack_size_charge_percentage_,          attr_);
            Client_SYS.Add_To_Attr('CHARGE_COST',           pack_size_charge_cost_,                attr_);
            Client_SYS.Add_To_Attr('CHARGED_QTY',           1,                                     attr_);
            Client_SYS.Add_To_Attr('BASE_CHARGE_AMOUNT',    total_pack_size_chg_amount_,           attr_);
            Client_SYS.Add_To_Attr('BASE_CHARGE_AMT_INCL_TAX', total_pack_size_chg_amount_,        attr_);
            Client_SYS.Add_To_Attr('CONTRACT',              contract_,                             attr_);
            Client_SYS.Add_To_Attr('SALES_UNIT_MEAS',       charge_type_rec_.sales_unit_meas,      attr_);
            Client_SYS.Add_To_Attr('PRINT_CHARGE_TYPE_DB',  charge_type_rec_.print_charge_type,    attr_);
            Client_SYS.Add_To_Attr('TAX_CODE',              tax_code_,                             attr_);
            Client_SYS.Add_To_Attr('UNIT_CHARGE_DB',        db_true_,                              attr_);
            Client_SYS.Add_To_Attr('INTRASTAT_EXEMPT_DB',   db_false_,                             attr_);
            attr_ := attr_||CHR(2);
         END IF;
      END IF;
   END IF;
END Get_Pack_Size_Charge_Attr___;


-- Get_Freight_Charge_Attr___
--   Returns attr_ with values from Freight Charge Price List.
PROCEDURE Get_Freight_Charge_Attr___(
   attr_ IN OUT VARCHAR2 )
IS
   order_no_                     Customer_Order_TAB.order_no%TYPE;
   quotation_no_                 VARCHAR2(12);
   line_no_                      VARCHAR2(4);
   rel_no_                       VARCHAR2(4);
   line_item_no_                 NUMBER;
   freight_charge_list_no_       Freight_Price_List_Base_TAB.price_list_no%TYPE;
   order_line_rec_               Customer_Order_Line_API.public_rec;
   ord_rec_                      Customer_Order_API.public_rec;
   price_effectivity_date_       DATE;
   contract_                     Site_Tab.contract%TYPE;
   currency_code_                Iso_Currency_TAB.currency_code%TYPE;
   customer_no_pay_              VARCHAR2(20);
   customer_no_                  VARCHAR2(20);
   zone_id_                      VARCHAR2(15);
   line_total_volume_            NUMBER;
   line_total_weight_            NUMBER;
   qty_                          NUMBER;
   freight_price_list_dir_rec_   Freight_Price_List_Direct_API.public_rec;
   freight_price_list_rec_       Freight_Price_List_API.public_rec;
   charge_type_                  Sales_Charge_Type_TAB.Charge_Type%TYPE;
   freight_basis_                VARCHAR2(100);
   min_freight_amount_           NUMBER;
   price_currency_code_          Iso_Currency_TAB.currency_code%TYPE;
   charge_type_rec_              Sales_Charge_Type_API.public_rec;
   base_charge_amt_              NUMBER;
   charge_amt_                   NUMBER;
   currency_rate_                NUMBER;
   is_unit_charge_               VARCHAR2(5);
   proceed_with_charge_fetching_ BOOLEAN := FALSE;
   freight_free_amount_          NUMBER;
   line_amount_                  NUMBER;
   charge_cost_                  NUMBER;
   freight_map_id_               VARCHAR2(15);
   quote_rec_                    Order_Quotation_API.Public_Rec;
   quote_line_rec_               Order_Quotation_Line_API.Public_Rec;
   currency_rate_type_           VARCHAR2(10);
   company_                      SITE_TAB.company%TYPE;
   company_uom_                  SALES_CHARGE_TYPE_TAB.sales_unit_meas%TYPE;

BEGIN
   order_no_               := Client_SYS.Get_Item_Value('ORDER_NO',     attr_);
   quotation_no_           := Client_SYS.Get_Item_Value('QUOTATION_NO', attr_);
   line_no_                := Client_SYS.Get_Item_Value('LINE_NO',      attr_);
   rel_no_                 := Client_SYS.Get_Item_Value('REL_NO',       attr_);
   line_item_no_           := Client_SYS.Get_Item_Value('LINE_ITEM_NO', attr_);
   freight_charge_list_no_ := Client_SYS.Get_Item_Value('CHARGE_PRICE_LIST_NO', attr_);

   IF order_no_ IS NOT NULL THEN
      order_line_rec_         := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);
      ord_rec_                := Customer_Order_API.Get(order_no_);

      price_effectivity_date_ := order_line_rec_.planned_ship_date;
      contract_               := ord_rec_.contract;
      currency_code_          := ord_rec_.currency_code;
      customer_no_pay_        := ord_rec_.customer_no_pay;
      customer_no_            := ord_rec_.customer_no;
      freight_map_id_         := order_line_rec_.freight_map_id;
      zone_id_                := order_line_rec_.zone_id;
      line_total_volume_      := order_line_rec_.adjusted_volume;
      line_total_weight_      := order_line_rec_.adjusted_weight_gross;
      currency_rate_type_     := ord_rec_.currency_rate_type;
      company_                := Site_API.Get_Company(contract_);

      -- Note : line_total_volume_ and line_total_weight_ are adjusted values using freight factor of the part.
      IF (order_line_rec_.supply_code IN ('PD', 'IPD') AND order_line_rec_.vendor_no IS NOT NULL) THEN
         freight_price_list_dir_rec_ := Freight_Price_List_Direct_API.Get(freight_charge_list_no_);
         charge_type_                := freight_price_list_dir_rec_.charge_type;
         freight_basis_              := freight_price_list_dir_rec_.freight_basis;
         min_freight_amount_         := Freight_Price_List_Zone_API.Get_Min_Freight_Amount(freight_charge_list_no_,
                                                                                           freight_price_list_dir_rec_.freight_map_id,
                                                                                           zone_id_);
         freight_free_amount_        := Freight_Price_List_Zone_API.Get_Freight_Free_Amount(freight_charge_list_no_,
                                                                                            freight_price_list_dir_rec_.freight_map_id,
                                                                                            zone_id_);
         price_currency_code_        := Company_Finance_API.Get_Currency_Code(freight_price_list_dir_rec_.company);
      ELSE
         freight_price_list_rec_     := Freight_Price_List_API.Get(freight_charge_list_no_);
         charge_type_                := freight_price_list_rec_.charge_type;
         freight_basis_              := freight_price_list_rec_.freight_basis;
         min_freight_amount_         := Freight_Price_List_Zone_API.Get_Min_Freight_Amount(freight_charge_list_no_,
                                                                                           freight_price_list_rec_.freight_map_id,
                                                                                           zone_id_);
         freight_free_amount_        := Freight_Price_List_Zone_API.Get_Freight_Free_Amount(freight_charge_list_no_,
                                                                                            freight_price_list_rec_.freight_map_id,
                                                                                            zone_id_);
         price_currency_code_        := Company_Finance_API.Get_Currency_Code(freight_price_list_rec_.company);
      END IF;
   END IF;

   IF quotation_no_ IS NOT NULL THEN
      quote_line_rec_         := Order_Quotation_Line_API.Get(quotation_no_, line_no_, rel_no_, line_item_no_);
      quote_rec_              := Order_Quotation_API.Get(quotation_no_);

      Cust_Ord_Date_Calculation_API.Fetch_Calendar_End_Date(price_effectivity_date_, Site_API.Get_Dist_Calendar_Id(quote_line_rec_.contract), quote_line_rec_.planned_due_date, Site_Invent_Info_API.Get_Picking_Leadtime(quote_line_rec_.contract));
      contract_               := quote_line_rec_.contract;
      currency_code_          := quote_rec_.currency_code;
      customer_no_pay_        := quote_rec_.customer_no_pay;
      customer_no_            := quote_line_rec_.customer_no;
      freight_map_id_         := quote_line_rec_.freight_map_id;
      zone_id_                := quote_line_rec_.zone_id;
      line_total_volume_      := quote_line_rec_.adjusted_volume;
      line_total_weight_      := quote_line_rec_.adjusted_weight_gross;
      company_                := quote_line_rec_.company;

      -- Note : line_total_volume_ and line_total_weight_ are adjusted values using freight factor of the part.
      IF (quote_line_rec_.order_supply_type IN ('PD', 'IPD') AND quote_line_rec_.vendor_no IS NOT NULL) THEN
         freight_price_list_dir_rec_ := Freight_Price_List_Direct_API.Get(freight_charge_list_no_);
         charge_type_                := freight_price_list_dir_rec_.charge_type;
         freight_basis_              := freight_price_list_dir_rec_.freight_basis;
         min_freight_amount_         := Freight_Price_List_Zone_API.Get_Min_Freight_Amount(freight_charge_list_no_,
                                                                                           freight_price_list_dir_rec_.freight_map_id,
                                                                                           zone_id_);
         freight_free_amount_        := Freight_Price_List_Zone_API.Get_Freight_Free_Amount(freight_charge_list_no_,
                                                                                            freight_price_list_dir_rec_.freight_map_id,
                                                                                            zone_id_);
         price_currency_code_        := Company_Finance_API.Get_Currency_Code(freight_price_list_dir_rec_.company);
      ELSE
         freight_price_list_rec_ := Freight_Price_List_API.Get(freight_charge_list_no_);
         charge_type_            := freight_price_list_rec_.charge_type;
         freight_basis_          := freight_price_list_rec_.freight_basis;
         min_freight_amount_     := Freight_Price_List_Zone_API.Get_Min_Freight_Amount(freight_charge_list_no_,
                                                                                       freight_price_list_rec_.freight_map_id,
                                                                                       zone_id_);
         freight_free_amount_        := Freight_Price_List_Zone_API.Get_Freight_Free_Amount(freight_charge_list_no_,
                                                                                            freight_price_list_rec_.freight_map_id,
                                                                                            zone_id_);
         price_currency_code_        := Company_Finance_API.Get_Currency_Code(freight_price_list_rec_.company);
      END IF;
   END IF;

   IF (price_currency_code_ != currency_code_) THEN
      Customer_Order_Pricing_API.Get_Sales_Price_In_Currency(freight_free_amount_, currency_rate_,
                                                             NVL(customer_no_pay_, customer_no_),
                                                             contract_, currency_code_,
                                                             freight_free_amount_, currency_rate_type_);
   END IF;

   charge_type_rec_ := Sales_Charge_Type_API.Get(contract_, charge_type_);

   -- for non unit based charges the fixed freight charge amount is for the total co line
   -- This changes if it is a unit based, then it becomes weight or volume.
   IF (NVL(NVL(line_total_weight_, line_total_volume_),0) > 0) THEN
      qty_ := 1;
   ELSE
      qty_ := 0;
   END IF;

   -- line_tital weight_ and line_total_volume_ are already adjusted with the freight factor.
   IF (freight_basis_ = 'WEIGHT_BASED') THEN
      line_total_volume_ := NULL;
      IF (charge_type_rec_.unit_charge = db_true_ AND NVL(line_total_weight_,0) > 0) THEN
         qty_ := line_total_weight_;
         company_uom_ := Company_Invent_Info_API.Get_Uom_For_Weight(company_);
         IF (charge_type_rec_.sales_unit_meas != company_uom_) THEN
            qty_ := NVL(Iso_Unit_API.Get_Unit_Converted_Quantity(qty_, company_uom_, charge_type_rec_.sales_unit_meas), qty_); 
         END IF;
         line_total_weight_ := qty_;
      END IF;

      -- To proceed with a weight based price list the adjusted weight is mandatory.
      IF (line_total_weight_ IS NOT NULL) THEN
         proceed_with_charge_fetching_ := TRUE;
      END IF;
   ELSE
      line_total_weight_ := NULL;
      IF (charge_type_rec_.unit_charge = db_true_ AND NVL(line_total_volume_,0) > 0) THEN
         qty_ := line_total_volume_;
         company_uom_ := Company_Invent_Info_API.Get_Uom_For_Volume(company_);
         IF (charge_type_rec_.sales_unit_meas != company_uom_) THEN
            qty_ := NVL(Iso_Unit_API.Get_Unit_Converted_Quantity(qty_, company_uom_, charge_type_rec_.sales_unit_meas), qty_); 
         END IF;
         line_total_volume_ := qty_;
      END IF;
  
      -- To proceed with a volume based price list the adjusted volume is mandatory.
      IF (line_total_volume_ IS NOT NULL) THEN
         proceed_with_charge_fetching_ := TRUE;
      END IF;
   END IF;

   IF (proceed_with_charge_fetching_) THEN
      is_unit_charge_ := charge_type_rec_.unit_charge;
      base_charge_amt_ := Freight_Price_List_Line_API.Get_Valid_Charge_Line(freight_charge_list_no_,
                                                                            line_total_weight_,
                                                                            line_total_volume_,
                                                                            price_effectivity_date_,
                                                                            freight_map_id_,
                                                                            zone_id_);
      IF (base_charge_amt_ IS NOT NULL) THEN
         -- If minimum freight amount is larger than the total charge amount on the charge line, charge amount becomes fixed and min_freight_amount_.
         IF (NVL(min_freight_amount_,0) > (base_charge_amt_ * qty_)) THEN
            IF is_unit_charge_ != db_false_ THEN
               base_charge_amt_ := min_freight_amount_;
            END IF;
            is_unit_charge_  := db_false_;
            -- Charged qty is 1 because now this is a fixed amount.
            qty_     := 1;
         END IF;

         charge_cost_ := base_charge_amt_;
         IF (order_no_ IS NOT NULL) THEN
            line_amount_ := Customer_Order_Line_API.Get_Base_Sale_Price_Total(order_no_,
                                                                              freight_map_id_,
                                                                              zone_id_,
                                                                              freight_charge_list_no_,
                                                                              price_effectivity_date_);
         ELSIF (quotation_no_ IS NOT NULL) THEN
            line_amount_ := Order_Quotation_Line_API.Get_Base_Sale_Price_Total(quotation_no_,
                                                                               freight_map_id_,
                                                                               zone_id_,
                                                                               freight_charge_list_no_,
                                                                               price_effectivity_date_);
         END IF;
         -- If the total amount is larger than the freight free amount, charge amount becomes 0.
         IF ( (freight_free_amount_ IS NOT NULL) AND ( line_amount_ >= NVL(freight_free_amount_,0)) ) THEN
            base_charge_amt_ := 0;
         END IF;

         IF (price_currency_code_ != currency_code_) THEN
            -- convert above base into sales price
            Customer_Order_Pricing_API.Get_Sales_Price_In_Currency(charge_amt_, currency_rate_,
                                                                   NVL(customer_no_pay_, customer_no_),
                                                                   contract_, currency_code_,
                                                                   base_charge_amt_, currency_rate_type_);
         ELSE
            charge_amt_ := base_charge_amt_;
         END IF;
      ELSE
         charge_amt_ := NULL;
         qty_        := NULL;
      END IF;
      Client_SYS.Add_To_Attr('CHARGE_TYPE',              charge_type_,                       attr_);
      Client_SYS.Add_To_Attr('CHARGE_AMOUNT',            charge_amt_,                        attr_);
      Client_SYS.Add_To_Attr('CHARGE_AMOUNT_INCL_TAX',   charge_amt_,                        attr_);
      Client_SYS.Add_To_Attr('CHARGE_COST',              charge_cost_,                       attr_);
      Client_SYS.Add_To_Attr('CHARGED_QTY',              qty_,                               attr_);
      Client_SYS.Add_To_Attr('BASE_CHARGE_AMOUNT',       base_charge_amt_,                   attr_);
      Client_SYS.Add_To_Attr('BASE_CHARGE_AMT_INCL_TAX', base_charge_amt_,                   attr_);
      Client_SYS.Add_To_Attr('CONTRACT',                 contract_,                          attr_);
      Client_SYS.Add_To_Attr('SALES_UNIT_MEAS',          charge_type_rec_.sales_unit_meas,   attr_);
      Client_SYS.Add_To_Attr('PRINT_CHARGE_TYPE',        Gen_Yes_No_API.Decode(charge_type_rec_.print_charge_type),               attr_);
      Client_SYS.Add_To_Attr('UNIT_CHARGE_DB',           is_unit_charge_,                    attr_);
      Client_SYS.Add_To_Attr('INTRASTAT_EXEMPT_DB',      charge_type_rec_.intrastat_exempt,  attr_);
      IF (order_no_ IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('PRINT_COLLECT_CHARGE',  Print_Collect_Charge_API.Decode(charge_type_rec_.print_collect_charge),  attr_);
      END IF;
   ELSE
      charge_amt_ := NULL;
      qty_        := NULL;
      Client_SYS.Add_To_Attr('CHARGE_AMOUNT',            charge_amt_,                        attr_);
      Client_SYS.Add_To_Attr('CHARGE_AMOUNT_INCL_TAX',   charge_amt_,                        attr_);
      Client_SYS.Add_To_Attr('CHARGED_QTY',              qty_,                               attr_);
   END IF;

END Get_Freight_Charge_Attr___;


-- Order_Conn_Fr_Charge_Exist___
--   Returns TRUE if a freight charge line is connected to the co line.
FUNCTION Order_Conn_Fr_Charge_Exist___ (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN BOOLEAN
IS
   found_  BOOLEAN := FALSE;
   dummy_  NUMBER;

   CURSOR get_data IS
      SELECT 1
      FROM customer_order_line_tab col,
           customer_order_charge_tab coc,
           sales_charge_type_tab sct
      WHERE col.order_no = order_no_
      AND   col.line_no = line_no_
      AND   col.rel_no = rel_no_
      AND   col.line_item_no = line_item_no_
      AND   col.order_no = coc.order_no
      AND   col.line_no = coc.line_no
      AND   col.rel_no = coc.rel_no
      AND   col.line_item_no = coc.line_item_no
      AND   sct.sales_chg_type_category = 'FREIGHT'
      AND   sct.contract = coc.contract
      AND   sct.charge_type = coc.charge_type;

BEGIN
   OPEN get_data;
   FETCH get_data INTO dummy_;
   IF get_data%FOUND THEN
      found_ := TRUE;
   END IF;
   CLOSE get_data;
   RETURN found_;
END Order_Conn_Fr_Charge_Exist___;


-- Quote_Conn_Fr_Charge_Exist___
--   Returns TRUE if a freight charge line is connected to the quote line.
FUNCTION Quote_Conn_Fr_Charge_Exist___ (
   quotation_no_   IN VARCHAR2,
   line_no_        IN VARCHAR2,
   rel_no_         IN VARCHAR2,
   line_item_no_   IN NUMBER ) RETURN BOOLEAN
IS
   found_  BOOLEAN := FALSE;
   dummy_  NUMBER;

   CURSOR get_data IS
      SELECT 1
      FROM order_quotation_line_tab ql,
           order_quotation_charge_tab qc,
           sales_charge_type_tab sct
      WHERE ql.quotation_no = quotation_no_
      AND   ql.line_no = line_no_
      AND   ql.rel_no = rel_no_
      AND   ql.line_item_no = line_item_no_
      AND   ql.quotation_no = qc.quotation_no
      AND   ql.line_no = qc.line_no
      AND   ql.rel_no = qc.rel_no
      AND   ql.line_item_no = qc.line_item_no
      AND   sct.sales_chg_type_category = 'FREIGHT'
      AND   sct.contract = qc.contract
      AND   sct.charge_type = qc.charge_type;

BEGIN
   OPEN get_data;
   FETCH get_data INTO dummy_;
   IF get_data%FOUND THEN
      found_ := TRUE;
   END IF;
   CLOSE get_data;
   RETURN found_;
END Quote_Conn_Fr_Charge_Exist___;


-- Delete_Zero_Charge_Lines___
--   Deletes charge lines with zero charge amount and zero cost.
--   Also deletes charge lines associated to a customer order line with
--   delivery term having Calculate_Freight_Charge set to FALSE.
PROCEDURE Delete_Zero_Charge_Lines___ (
   order_no_     IN VARCHAR2,
   quotation_no_ IN VARCHAR2 )
IS
   CURSOR get_order_data IS
      SELECT sequence_no, coc.charge_amount, coc.charge_cost, col.delivery_terms
      FROM customer_order_charge_tab coc,
           customer_order_line_tab col,
           sales_charge_type_tab sct
      WHERE coc.order_no = order_no_
      AND   col.order_no = coc.order_no
      AND   col.line_no = coc.line_no
      AND   col.rel_no = coc.rel_no
      AND   col.line_item_no = coc.line_item_no
      AND   col.freight_free = db_false_
      AND   sct.sales_chg_type_category = 'FREIGHT'
      AND   sct.contract = coc.contract
      AND   sct.charge_type = coc.charge_type;

   CURSOR get_quote_data IS
      SELECT quotation_charge_no, oqc.charge_amount, oqc.charge_cost, ql.delivery_terms
      FROM order_quotation_charge_tab oqc,
           order_quotation_line_tab ql,
           sales_charge_type_tab sct
      WHERE oqc.quotation_no = quotation_no_
      AND   ql.quotation_no = oqc.quotation_no
      AND   ql.line_no = oqc.line_no
      AND   ql.rel_no = oqc.rel_no
      AND   ql.line_item_no = oqc.line_item_no
      AND   ql.freight_free = db_false_
      AND   sct.sales_chg_type_category = 'FREIGHT'
      AND   sct.contract = oqc.contract
      AND   sct.charge_type = oqc.charge_type;
BEGIN
   IF (order_no_ IS NOT NULL) THEN
      FOR rec_ IN get_order_data LOOP
         IF (rec_.charge_amount = 0 AND rec_.charge_cost = 0) OR
            (Order_Delivery_Term_API.Get_Calculate_Freight_Charge(rec_.delivery_terms) = db_false_) THEN
            Customer_Order_Charge_API.Remove(order_no_, rec_.sequence_no);
         END IF;
      END LOOP;
   ELSIF (quotation_no_ IS NOT NULL) THEN
      FOR rec_ IN get_quote_data LOOP
         IF (rec_.charge_amount = 0 AND rec_.charge_cost = 0) OR
            (Order_Delivery_Term_API.Get_Calculate_Freight_Charge(rec_.delivery_terms) = db_false_) THEN
            Order_Quotation_Charge_API.Remove(quotation_no_, rec_.quotation_charge_no);
         END IF;
      END LOOP;
   END IF;
END Delete_Zero_Charge_Lines___;


PROCEDURE Recalculate_Tax_Lines___ (
   contract_            IN VARCHAR2,
   order_no_            IN VARCHAR2,
   sequence_no_         IN NUMBER, 
   from_defaults_       IN BOOLEAN,
   attr_                IN VARCHAR2)
IS
   source_key_rec_         Tax_Handling_Util_API.source_key_rec;
   tax_line_param_rec_     Tax_Handling_Order_Util_API.tax_line_param_rec;
   company_                VARCHAR2(20);     
BEGIN
   source_key_rec_     := Tax_Handling_Util_API.Create_Source_Key_Rec(Tax_Source_API.DB_CUSTOMER_ORDER_CHARGE,
                                                                      order_no_, 
                                                                      TO_CHAR(sequence_no_), 
                                                                      '*', 
                                                                      '*',   
                                                                      '*', 
                                                                      attr_); 
   company_ := Site_API.Get_Company(contract_);
   tax_line_param_rec_ := Customer_Order_Charge_API.Fetch_Tax_Line_Param(company_, order_no_, sequence_no_, '*', '*');
   
   tax_line_param_rec_.from_defaults         := from_defaults_;
   tax_line_param_rec_.add_tax_lines         := TRUE; 
      
   Tax_Handling_Order_Util_API.Recalculate_Tax_Lines (source_key_rec_,
                                                      tax_line_param_rec_,
                                                      attr_);
END Recalculate_Tax_Lines___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Remove_Connected_Chg_Lines (
   order_no_            IN VARCHAR2,
   line_no_             IN VARCHAR2,
   rel_no_              IN VARCHAR2,
   line_item_no_        IN NUMBER )
IS
   CURSOR get_record IS
      SELECT coc.sequence_no
      FROM   customer_order_charge_tab coc
      WHERE  coc.order_no     = order_no_
      AND    coc.line_no      = line_no_
      AND    coc.rel_no       = rel_no_
      AND    coc.line_item_no = line_item_no_;

BEGIN
   FOR rec_ IN get_record LOOP
      Customer_Order_Charge_API.Remove(order_no_, rec_.sequence_no);
   END LOOP;

END Remove_Connected_Chg_Lines;


PROCEDURE Remove_Connected_QChg_Lines (
   quotation_no_        IN VARCHAR2,
   line_no_             IN VARCHAR2,
   rel_no_              IN VARCHAR2,
   line_item_no_        IN NUMBER )
IS
   CURSOR get_record IS
      SELECT oqc.quotation_charge_no
      FROM   order_quotation_charge_tab oqc
      WHERE  oqc.quotation_no = quotation_no_
      AND    oqc.line_no      = line_no_
      AND    oqc.rel_no       = rel_no_
      AND    oqc.line_item_no = line_item_no_;

BEGIN
   FOR rec_ IN get_record LOOP
      Order_Quotation_Charge_API.Remove(quotation_no_, rec_.quotation_charge_no);
   END LOOP;

END Remove_Connected_QChg_Lines;


-- New_Cust_Order_Charge_Line
--   Add new charge line with values from pack size charge list.
PROCEDURE New_Cust_Order_Charge_Line (
   newrec_              IN CUSTOMER_ORDER_LINE_TAB%ROWTYPE,
   insert_freight_only_ IN BOOLEAN )
IS
   pack_size_chg_list_no_     VARCHAR2(10);
   chg_attr_                  VARCHAR2(32000);
   new_chg_attr_              VARCHAR2(2000);
   freight_chg_attr_          VARCHAR2(2000);
   info_                      VARCHAR2(2000);
   contract_                  SALES_CHARGE_TYPE_TAB.contract%TYPE;
   charge_type_               SALES_CHARGE_TYPE_TAB.charge_type%TYPE;
   freight_price_list_no_     FREIGHT_PRICE_LIST_BASE_TAB.price_list_no%TYPE;
   del_term_rec_              ORDER_DELIVERY_TERM_API.Public_Rec;
   pack_size_chg_line_seq_no_ NUMBER;
   tmp_sequence_no_           NUMBER := NULL;
   charge_amount_             NUMBER;
   charge_                    NUMBER;
   charge_qty_                NUMBER;
   net_amount_curr_           NUMBER;
   to_sequence_no_            NUMBER;
   forward_agent_id_          CUSTOMER_ORDER_LINE_TAB.Forward_Agent_Id%TYPE;
   ptr_                       NUMBER := 1;
   newpos_                    NUMBER;
   input_uom_allowed_         VARCHAR2(5);
   company_                   site_tab.company%TYPE;
   purch_company_             site_tab.company%TYPE;
   stmt_                      VARCHAR2(2000);
   intersite_same_company_    BOOLEAN := FALSE;
   site_discom_rec_           SITE_DISCOM_INFO_API.Public_Rec;   
   use_price_incl_tax_db_     CUSTOMER_ORDER_TAB.use_price_incl_tax%TYPE;
   gross_amount_curr_         NUMBER;

   CURSOR get_freight_charge_seq (freight_price_list_no_ IN VARCHAR2)IS
      SELECT sequence_no
      FROM   customer_order_charge_tab
      WHERE  charge_price_list_no = freight_price_list_no_
      AND    order_no = newrec_.order_no
      AND    line_no = newrec_.line_no
      AND    rel_no = newrec_.rel_no
      AND    line_item_no = newrec_.line_item_no;

BEGIN
   company_ := Site_API.Get_Company(newrec_.contract);
   IF (newrec_.part_ownership = 'COMPANY OWNED') THEN
      use_price_incl_tax_db_ := Customer_Order_API.Get_Use_Price_Incl_Tax_Db(newrec_.order_no);
      IF (NOT insert_freight_only_) THEN
         input_uom_allowed_ := Input_Unit_Meas_Group_API.Is_Usage_Allowed(Inventory_Part_API.Get_Input_Unit_Meas_Group_Id(newrec_.contract,
                               Sales_Part_API.Get_Part_No(newrec_.contract, newrec_.catalog_no)), 'ORDER');


         IF (input_uom_allowed_ = db_true_ AND newrec_.price_source_net_price = db_false_) THEN

              pack_size_chg_line_seq_no_ := Customer_Order_Charge_API.Get_Pack_Size_Chg_Line_Seq_No(newrec_.order_no,  newrec_.line_no, newrec_.rel_no,  newrec_.line_item_no);

             IF (pack_size_chg_line_seq_no_ IS NULL) THEN
               IF (Cust_Ord_Customer_API.Get_Receive_Pack_Size_Chg_Db(newrec_.customer_no) = db_true_) THEN
                  pack_size_chg_list_no_   := Pack_Size_Charge_List_API.Get_Active_Chg_List_For_Site(newrec_.contract, NVL(newrec_.price_effectivity_date, SYSDATE), use_price_incl_tax_db_);
                  IF (pack_size_chg_list_no_ IS NOT NULL ) THEN
                     Client_SYS.Add_To_Attr('ORDER_NO',                 newrec_.order_no,       chg_attr_);
                     Client_SYS.Add_To_Attr('LINE_NO',                  newrec_.line_no,        chg_attr_);
                     Client_SYS.Add_To_Attr('REL_NO',                   newrec_.rel_no,         chg_attr_);
                     Client_SYS.Add_To_Attr('LINE_ITEM_NO',             newrec_.line_item_no,   chg_attr_);
                     Client_SYS.Add_To_Attr('CHARGE_PRICE_LIST_NO',     pack_size_chg_list_no_, chg_attr_);

                     Get_Pack_Size_Charge_Attr___(chg_attr_);

                     LOOP
                        newpos_       := instr(chg_attr_, CHR(2), ptr_);
                        new_chg_attr_ := substr(chg_attr_, ptr_, newpos_ - ptr_);
                        ptr_ := newpos_ + 1;
                        EXIT WHEN new_chg_attr_ IS NULL;

                        charge_amount_ := Client_SYS.Get_Item_Value('CHARGE_AMOUNT', new_chg_attr_);
                        charge_        := Client_SYS.Get_Item_Value('CHARGE',        new_chg_attr_);
                        charge_qty_    := Client_SYS.Get_Item_Value('CHARGED_QTY',   new_chg_attr_);
                        charge_type_   := Client_SYS.Get_Item_Value('CHARGE_TYPE',   new_chg_attr_);
                        contract_      := Client_SYS.Get_Item_Value('CONTRACT',      new_chg_attr_);

                        IF (charge_amount_ IS NOT NULL OR charge_ IS NOT NULL) AND (charge_qty_ != 0) THEN
                           IF (use_price_incl_tax_db_ = 'TRUE') THEN
                              gross_amount_curr_ := Customer_Order_Line_API.Get_Sale_Price_Incl_Tax_Total(newrec_.order_no, newrec_.line_no,newrec_.rel_no,newrec_.line_item_no);
                              IF ((-1 * NVL(charge_amount_, 0) * charge_qty_) >= gross_amount_curr_) THEN
                                 Error_SYS.Record_General(lu_name_, 'INVALORDCHGGROSS: Pack size discount cannot exceed the order line gross amount.');
                              END IF;
                           ELSE
                              net_amount_curr_ := Customer_Order_Line_API.Get_Sale_Price_Total(newrec_.order_no, newrec_.line_no,newrec_.rel_no,newrec_.line_item_no);
                              IF ((-1 * NVL(charge_amount_, 0) * charge_qty_) >= net_amount_curr_) THEN
                                 Error_SYS.Record_General(lu_name_, 'INVALORDCHGNET: Pack size discount cannot exceed the order line net amount.');
                              END IF;
                           END IF;

                           Customer_Order_Charge_API.New(info_, new_chg_attr_);
                           to_sequence_no_ := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('SEQUENCE_NO', new_chg_attr_));

                           IF (Source_Tax_Item_API.Multiple_Tax_Items_Exist(company_, Tax_Source_API.DB_CUSTOMER_ORDER_LINE, newrec_.order_no, newrec_.line_no, newrec_.rel_no, TO_CHAR(newrec_.line_item_no), '*') = db_true_)
                           AND (Sales_Charge_Type_API.Get_Taxable_Db(contract_, charge_type_) = Fnd_Boolean_API.DB_TRUE) THEN
                              Customer_Order_Charge_API.Copy_Order_Line_Tax_Lines(company_,
                                                                                  newrec_.order_no,
                                                                                  newrec_.line_no,
                                                                                  newrec_.rel_no,
                                                                                  newrec_.line_item_no,
                                                                                  to_sequence_no_);
                           END IF;
                        END IF;
                     END LOOP;
                  END IF;
               END IF;
            END IF;
         END IF;
      END IF;

      del_term_rec_ := Order_Delivery_Term_API.Get(newrec_.delivery_terms);
      IF (newrec_.demand_code = 'IPD') THEN         
         stmt_ := 'BEGIN
                      :purch_company := Site_API.Get_Company(Purchase_Order_Line_API.Get_Contract(:demand_order_ref1, :demand_order_ref2, :demand_order_ref3));
                   END;';
         @ApproveDynamicStatement(2011-10-05,ShKolk)
         EXECUTE IMMEDIATE stmt_ USING
            OUT purch_company_,
            IN  newrec_.demand_order_ref1,
            IN  newrec_.demand_order_ref2,
            IN  newrec_.demand_order_ref3;
         IF company_ = NVL(purch_company_, company_) THEN
            intersite_same_company_ := TRUE;
         END IF;
      END IF;

      IF (newrec_.freight_map_id IS NOT NULL AND newrec_.zone_id IS NOT NULL AND newrec_.charged_item = 'CHARGED ITEM'
          AND del_term_rec_.calculate_freight_charge = db_true_ AND (newrec_.adjusted_weight_gross IS NOT NULL OR newrec_.adjusted_volume IS NOT NULL )
          AND NOT intersite_same_company_) THEN

         site_discom_rec_ := Site_Discom_Info_API.Get(newrec_.contract);
         
         -- dont create freight charge for COL if COL is shipment connected and shipment freight charge flag on Site is true since this is already handled on the shipment
         IF (newrec_.shipment_connected = 'TRUE' AND site_discom_rec_.shipment_freight_charge = db_false_) OR (newrec_.shipment_connected = 'FALSE' ) THEN

            forward_agent_id_:= Customer_Order_API.Get_Forward_Agent_Id(newrec_.order_no);

            IF (newrec_.supply_code IN ('PD', 'IPD') AND newrec_.vendor_no IS NOT NULL) THEN
               freight_price_list_no_      := Freight_Price_List_Direct_API.Get_Active_Freight_List_No(newrec_.contract, newrec_.ship_via_code, newrec_.freight_map_id, forward_agent_id_, use_price_incl_tax_db_, newrec_.vendor_no);
            ELSE
               freight_price_list_no_      := Freight_Price_List_API.Get_Active_Freight_List_No(newrec_.contract, newrec_.ship_via_code, newrec_.freight_map_id, forward_agent_id_, use_price_incl_tax_db_);
            END IF;

            OPEN get_freight_charge_seq(freight_price_list_no_);
            FETCH get_freight_charge_seq INTO tmp_sequence_no_;
            CLOSE get_freight_charge_seq;

            IF (freight_price_list_no_ IS NOT NULL AND tmp_sequence_no_ IS NULL) THEN
               Client_SYS.Add_To_Attr('ORDER_NO',                 newrec_.order_no,                      freight_chg_attr_);
               Client_SYS.Add_To_Attr('LINE_NO',                  newrec_.line_no,                       freight_chg_attr_);
               Client_SYS.Add_To_Attr('REL_NO',                   newrec_.rel_no,                        freight_chg_attr_);
               Client_SYS.Add_To_Attr('LINE_ITEM_NO',             newrec_.line_item_no,                  freight_chg_attr_);
               Client_SYS.Add_To_Attr('CHARGE_PRICE_LIST_NO',     freight_price_list_no_,                freight_chg_attr_);
               Client_SYS.Add_To_Attr('SERVER_DATA_CHANGE',       db_true_,                              freight_chg_attr_);
               -- Use client values, Check Customer_Order_Charge_API.New
               IF (del_term_rec_.collect_freight_charge = db_true_) THEN
                  Client_SYS.Add_To_Attr('COLLECT',               Collect_API.Decode('COLLECT'),         freight_chg_attr_);
               ELSE
                  Client_SYS.Add_To_Attr('COLLECT',               Collect_API.Decode('INVOICE'),         freight_chg_attr_);
               END IF;
               Get_Freight_Charge_Attr___(freight_chg_attr_);
               IF (Client_SYS.Get_Item_Value('CHARGE_AMOUNT', freight_chg_attr_) IS NOT NULL) AND
                  (Client_SYS.Get_Item_Value('CHARGED_QTY', freight_chg_attr_) != 0) THEN
                  Customer_Order_Charge_API.New(info_, freight_chg_attr_);
               END IF;
               IF Customer_Order_API.Get_Objstate(newrec_.order_no) != 'Planned' THEN
                  Customer_Order_Charge_Util_API.Consolidate_Grouped_Charges(newrec_.order_no,
                                                                             NULL,
                                                                             newrec_.planned_ship_date,
                                                                             newrec_.zone_id,
                                                                             newrec_.delivery_terms,
                                                                             newrec_.freight_price_list_no,
                                                                             newrec_.demand_code);
               END IF;
            END IF;

         END IF;
      END IF;
   END IF;
END New_Cust_Order_Charge_Line;


-- New_Quotation_Charge_Line
--   Add new charge line with values from pack size charge list.
PROCEDURE New_Quotation_Charge_Line (
   newrec_ IN ORDER_QUOTATION_LINE_TAB%ROWTYPE )
IS
   pack_size_chg_list_no_     VARCHAR2(10);
   chg_attr_                  VARCHAR2(32000);
   new_chg_attr_              VARCHAR2(2000);
   info_                      VARCHAR2(2000);
   input_uom_allowed_         VARCHAR2(5);
   contract_                  SALES_CHARGE_TYPE_TAB.contract%TYPE;
   charge_type_               SALES_CHARGE_TYPE_TAB.charge_type%TYPE;
   charge_amount_             NUMBER;
   charge_                    NUMBER;
   charge_qty_                NUMBER;
   net_amount_curr_           NUMBER;
   to_quot_charge_no_         NUMBER;
   ptr_                       NUMBER := 1;
   newpos_                    NUMBER;
   price_effectivity_date_    DATE;
   calc_freight_charge_       VARCHAR2(20);
   dummy_                     NUMBER;
   insert_freight_charge_     BOOLEAN := FALSE;
   freight_chg_attr_          VARCHAR2(2000);
   freight_price_list_no_     VARCHAR2(10);
   use_price_incl_tax_db_     CUSTOMER_ORDER_TAB.use_price_incl_tax%TYPE;
   gross_amount_curr_         NUMBER;

   CURSOR charge_rec_exist(freight_price_list_no_ IN VARCHAR2)IS
      SELECT 1
      FROM   order_quotation_charge_tab
      WHERE  charge_price_list_no = freight_price_list_no_
      AND    quotation_no = newrec_.quotation_no
      AND    line_no = newrec_.line_no
      AND    rel_no = newrec_.rel_no
      AND    line_item_no = newrec_.line_item_no;
BEGIN
   IF (newrec_.rental = Fnd_Boolean_API.DB_TRUE) THEN
      RETURN;
   END IF;

   input_uom_allowed_ := Input_Unit_Meas_Group_API.Is_Usage_Allowed(Inventory_Part_API.Get_Input_Unit_Meas_Group_Id(newrec_.contract,Sales_Part_API.Get_Part_No(newrec_.contract, newrec_.catalog_no)), 'ORDER');
   use_price_incl_tax_db_ := Order_Quotation_API.Get_Use_Price_Incl_Tax_Db(newrec_.quotation_no);
   IF (Cust_Ord_Customer_API.Get_Receive_Pack_Size_Chg_Db(Order_Quotation_API.Get_Customer_No(newrec_.quotation_no)) = db_true_  AND input_uom_allowed_ = db_true_) THEN

      price_effectivity_date_ := NVL(Order_Quotation_API.Get_Price_Effectivity_Date(newrec_.quotation_no), SYSDATE);
      pack_size_chg_list_no_   := Pack_Size_Charge_List_API.Get_Active_Chg_List_For_Site(newrec_.contract, price_effectivity_date_, use_price_incl_tax_db_);

      IF (pack_size_chg_list_no_ IS NOT NULL ) THEN
         Client_SYS.Add_To_Attr('QUOTATION_NO',             newrec_.quotation_no,   chg_attr_);
         Client_SYS.Add_To_Attr('LINE_NO',                  newrec_.line_no,        chg_attr_);
         Client_SYS.Add_To_Attr('REL_NO',                   newrec_.rel_no,         chg_attr_);
         Client_SYS.Add_To_Attr('LINE_ITEM_NO',             newrec_.line_item_no,   chg_attr_);
         Client_SYS.Add_To_Attr('CHARGE_PRICE_LIST_NO',     pack_size_chg_list_no_, chg_attr_);

         Get_Pack_Size_Charge_Attr___(chg_attr_);

         LOOP
            newpos_       := instr(chg_attr_, CHR(2), ptr_);
            new_chg_attr_ := substr(chg_attr_, ptr_, newpos_ - ptr_);
            ptr_ := newpos_ + 1;
            EXIT WHEN new_chg_attr_ IS NULL;

            charge_amount_ := Client_SYS.Get_Item_Value('CHARGE_AMOUNT', new_chg_attr_);
            charge_        := Client_SYS.Get_Item_Value('CHARGE',        new_chg_attr_);
            charge_qty_    := Client_SYS.Get_Item_Value('CHARGED_QTY',   new_chg_attr_);
            charge_type_   := Client_SYS.Get_Item_Value('CHARGE_TYPE',   new_chg_attr_);
            contract_      := Client_SYS.Get_Item_Value('CONTRACT',      new_chg_attr_);

            IF (charge_amount_ IS NOT NULL OR charge_ IS NOT NULL) AND (charge_qty_ != 0) THEN
               IF (use_price_incl_tax_db_ = 'TRUE') THEN
                  gross_amount_curr_ := Order_Quotation_Line_API.Get_Sale_Price_Incl_Tax_Total(newrec_.quotation_no, newrec_.line_no,newrec_.rel_no,newrec_.line_item_no);
                  IF ((-1 * NVL(charge_amount_, 0) * charge_qty_) >= gross_amount_curr_) THEN
                     Error_SYS.Record_General(lu_name_, 'INVALQUOTCHGGROSS: Pack size discount cannot exceed the quotation line gross amount.');
                  END IF;
               ELSE
                  net_amount_curr_ := Order_Quotation_Line_API.Get_Sale_Price_Total(newrec_.quotation_no, newrec_.line_no,newrec_.rel_no,newrec_.line_item_no);
                  IF ((-1 * NVL(charge_amount_, 0) * charge_qty_) >= net_amount_curr_) THEN
                     Error_SYS.Record_General(lu_name_, 'INVALQUOTCHGNET: Pack size discount cannot exceed the quotation line net amount.');
                  END IF;
               END IF;
               Order_Quotation_Charge_API.New(info_, new_chg_attr_);
               to_quot_charge_no_ := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('QUOTATION_CHARGE_NO', new_chg_attr_));

               IF (Source_Tax_Item_API.Multiple_Tax_Items_Exist(newrec_.company, Tax_Source_API.DB_ORDER_QUOTATION_LINE, newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, TO_CHAR(newrec_.line_item_no), '*') = db_true_)
                   AND (Sales_Charge_Type_API.Get_Taxable_Db(contract_, charge_type_) = Fnd_Boolean_API.DB_TRUE) THEN
                  Order_Quotation_Charge_API.Copy_Quote_Line_Tax_Lines(newrec_.company,
                                                                       newrec_.quotation_no,
                                                                       newrec_.line_no,
                                                                       newrec_.rel_no,
                                                                       newrec_.line_item_no,
                                                                       to_quot_charge_no_);
               END IF;
            END IF;
         END LOOP;
      END IF;
   END IF;
   calc_freight_charge_ := Order_Delivery_Term_API.Get_Calculate_Freight_Charge(newrec_.delivery_terms);
   IF (newrec_.freight_map_id IS NOT NULL AND newrec_.zone_id IS NOT NULL AND calc_freight_charge_ = db_true_ AND
      (newrec_.adjusted_weight_gross IS NOT NULL OR newrec_.adjusted_volume IS NOT NULL )) THEN
      IF (newrec_.order_supply_type IN ('PD', 'IPD') AND newrec_.vendor_no IS NOT NULL) THEN
         freight_price_list_no_ := Freight_Price_List_Direct_API.Get_Active_Freight_List_No(newrec_.contract, newrec_.ship_via_code, newrec_.freight_map_id, newrec_.forward_agent_id, use_price_incl_tax_db_, newrec_.vendor_no);
      ELSE
         freight_price_list_no_ := Freight_Price_List_API.Get_Active_Freight_List_No(newrec_.contract, newrec_.ship_via_code, newrec_.freight_map_id, newrec_.forward_agent_id, use_price_incl_tax_db_);
      END IF;

      OPEN charge_rec_exist(freight_price_list_no_);
      FETCH charge_rec_exist INTO dummy_;
      IF (charge_rec_exist%NOTFOUND) THEN
         insert_freight_charge_ := TRUE;
      END IF;
      CLOSE charge_rec_exist;
      IF insert_freight_charge_ AND (freight_price_list_no_ IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('QUOTATION_NO',         newrec_.quotation_no,   freight_chg_attr_);
         Client_SYS.Add_To_Attr('LINE_NO',              newrec_.line_no,        freight_chg_attr_);
         Client_SYS.Add_To_Attr('REL_NO',               newrec_.rel_no,         freight_chg_attr_);
         Client_SYS.Add_To_Attr('LINE_ITEM_NO',         newrec_.line_item_no,   freight_chg_attr_);
         Client_SYS.Add_To_Attr('CHARGE_PRICE_LIST_NO', freight_price_list_no_, freight_chg_attr_);
         Client_SYS.Add_To_Attr('SERVER_DATA_CHANGE',   db_true_,               freight_chg_attr_);

         Get_Freight_Charge_Attr___(freight_chg_attr_);
         IF (Client_SYS.Get_Item_Value('CHARGE_AMOUNT', freight_chg_attr_) IS NOT NULL) AND
            (Client_SYS.Get_Item_Value('CHARGED_QTY', freight_chg_attr_) != 0) THEN
            Order_Quotation_Charge_API.New(info_, freight_chg_attr_);
         END IF;
      END IF;
   END IF;
END New_Quotation_Charge_Line;


-- Modify_Cust_Order_Charge_Line
--   Modify CO charge line which is connected to CO line.
PROCEDURE Modify_Cust_Order_Charge_Line (
   newrec_ IN CUSTOMER_ORDER_LINE_TAB%ROWTYPE,
   oldrec_ IN CUSTOMER_ORDER_LINE_TAB%ROWTYPE,
   tax_code_changed_ IN VARCHAR2)
IS
   pack_size_chg_line_seq_no_   NUMBER;
   tmp_sequence_no_             NUMBER := NULL;
   temp_order_state_            CUSTOMER_ORDER_TAB.rowstate%TYPE;
   old_freight_price_list_no_   Freight_Price_List_Base_TAB.price_list_no%TYPE;
   new_freight_price_list_no_   Freight_Price_List_Base_TAB.price_list_no%TYPE;
   freight_chg_attr_            VARCHAR2(2000);
   info_                        VARCHAR2(2000);
   del_term_rec_                Order_Delivery_Term_API.Public_Rec;
   input_uom_allowed_           VARCHAR2(5);
   last_calendar_date_          DATE := Database_SYS.last_calendar_date_;
   order_rec_                   CUSTOMER_ORDER_API.Public_Rec;
   delivery_country_db_         VARCHAR2(2);
   old_charge_rec_              Customer_Order_Charge_API.Public_Rec;
   allow_invoiced_chg_del_      BOOLEAN := FALSE;

   CURSOR get_packsize_charges IS
      SELECT sequence_no
         FROM customer_order_charge_tab coc,
              sales_charge_type_tab     sct
         WHERE coc.order_no = newrec_.order_no
         AND   coc.line_no = newrec_.line_no
         AND   coc.rel_no = newrec_.rel_no
         AND   coc.line_item_no = newrec_.line_item_no
         AND   coc.charge_type = sct.charge_type
         AND   coc.contract = sct.contract
         AND   coc.charge_price_list_no IS NOT NULL
         AND   sct.sales_chg_type_category = 'PACK_SIZE';

   CURSOR get_freight_charge_seq (freight_price_list_no_ IN VARCHAR2)IS
      SELECT sequence_no
      FROM customer_order_charge_tab coc,
           sales_charge_type_tab     sct
      WHERE coc.charge_price_list_no = freight_price_list_no_
      AND   sct.sales_chg_type_category = 'FREIGHT'
      AND   sct.contract = coc.contract
      AND   sct.charge_type = coc.charge_type
      AND   coc.order_no = newrec_.order_no
      AND   coc.line_no = newrec_.line_no
      AND   coc.rel_no = newrec_.rel_no
      AND   coc.line_item_no = newrec_.line_item_no;
BEGIN
   IF (newrec_.part_ownership = 'COMPANY OWNED') THEN
      temp_order_state_       := Customer_Order_API.Get_Objstate(newrec_.order_no);
      -- Set allow_invoiced_chg_del_ to true if the customer order is in Partially delivered state
      IF temp_order_state_ IN ('PartiallyDelivered') THEN
         allow_invoiced_chg_del_ := TRUE;
      END IF;
      
      -- When the buy qty changed modify the connected unit charge quantities.
      IF (newrec_.buy_qty_due != oldrec_.buy_qty_due) THEN
         Customer_Order_Charge_API.Update_Connected_Charged_Qty(newrec_.order_no,newrec_.line_no,
                                                                newrec_.rel_no, newrec_.line_item_no,
                                                                newrec_.buy_qty_due);
      END IF;
      
      IF (newrec_.free_of_charge != oldrec_.free_of_charge) THEN
         Customer_Order_Charge_API.Update_Connected_Foc_Db(newrec_.order_no,newrec_.line_no,
                                                            newrec_.rel_no, newrec_.line_item_no,
                                                            newrec_.free_of_charge);
      END IF;

      pack_size_chg_line_seq_no_ := Customer_Order_Charge_API.Get_Pack_Size_Chg_Line_Seq_No(newrec_.order_no,
                                                                                            newrec_.line_no, newrec_.rel_no,
                                                                                            newrec_.line_item_no);
      IF (pack_size_chg_line_seq_no_ IS NOT NULL ) THEN

         input_uom_allowed_ := Input_Unit_Meas_Group_API.Is_Usage_Allowed(Inventory_Part_API.Get_Input_Unit_Meas_Group_Id(newrec_.contract,Sales_Part_API.Get_Part_No(newrec_.contract, newrec_.catalog_no)), 'ORDER');
         delivery_country_db_ := Cust_Order_Line_Address_API.Get_Country_Code(newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
         IF ((oldrec_.input_qty != newrec_.input_qty) OR (oldrec_.input_unit_meas != newrec_.input_unit_meas) OR (Tax_Liability_API.Get_Tax_Liability_Type_Db(oldrec_.tax_liability, delivery_country_db_) != Tax_Liability_API.Get_Tax_Liability_Type_Db(newrec_.tax_liability, delivery_country_db_)) OR
             (NVL(oldrec_.tax_code, Database_SYS.string_null_) !=  NVL(newrec_.tax_code, Database_SYS.string_null_)) OR (oldrec_.tax_code IS NULL AND newrec_.tax_code IS NULL AND NVL(tax_code_changed_, 'FALSE') = db_true_) OR
             (newrec_.buy_qty_due != oldrec_.buy_qty_due) OR (TRUNC(NVL(newrec_.price_effectivity_date,last_calendar_date_)) != TRUNC(NVL(oldrec_.price_effectivity_date,last_calendar_date_)))
             OR (oldrec_.sale_unit_price != newrec_.sale_unit_price) OR (oldrec_.unit_price_incl_tax != newrec_.unit_price_incl_tax)
             OR (oldrec_.base_sale_unit_price != newrec_.base_sale_unit_price) OR (oldrec_.base_unit_price_incl_tax != newrec_.base_unit_price_incl_tax)) AND (input_uom_allowed_ = db_true_) THEN

            -- Getting old charge line
            old_charge_rec_ := Customer_Order_Charge_API.Get(newrec_.order_no, pack_size_chg_line_seq_no_ );
            
            -- Delete all PACKSIZE charge lines
            FOR rec_ IN get_packsize_charges LOOP
               Customer_Order_Charge_API.Remove(newrec_.order_no, rec_.sequence_no, NULL, allow_invoiced_chg_del_);
            END LOOP;

            New_Cust_Order_Charge_Line(newrec_, FALSE);
            
            IF temp_order_state_ IN ('PartiallyDelivered') THEN
               pack_size_chg_line_seq_no_ := Customer_Order_Charge_API.Get_Pack_Size_Chg_Line_Seq_No( newrec_.order_no,
                                                                                                      newrec_.line_no, newrec_.rel_no,
                                                                                                      newrec_.line_item_no );
               IF (pack_size_chg_line_seq_no_ IS NOT NULL) THEN               
                  Customer_Order_Charge_API.Modify_Invoiced_Qty ( newrec_.order_no,
                                                                  pack_size_chg_line_seq_no_,
                                                                  old_charge_rec_.invoiced_qty,
                                                                  FALSE );
               END IF;
            END IF;
         END IF;
      END IF;

      -- update freight charge line
      order_rec_ := Customer_Order_API.Get(newrec_.order_no);
      IF (temp_order_state_ IN ('Planned' ,'Released', 'Reserved', 'PartiallyDelivered', 'Picked')) THEN
         IF (NVL(oldrec_.zone_id, CHR(32)) != NVL(newrec_.zone_id, CHR(32))) OR (oldrec_.buy_qty_due != newrec_.buy_qty_due) OR (NVL(oldrec_.input_qty,0) != NVL(newrec_.input_qty,0)
            OR (oldrec_.planned_ship_date != newrec_.planned_ship_date) OR (oldrec_.ship_via_code != newrec_.ship_via_code) OR (NVL(oldrec_.vendor_no, CHR(32)) != NVL(newrec_.vendor_no, CHR(32)))
            OR (oldrec_.line_total_weight != newrec_.line_total_weight) OR (oldrec_.line_total_qty != newrec_.line_total_qty)
            OR (oldrec_.adjusted_weight_net != newrec_.adjusted_weight_net) OR (oldrec_.adjusted_volume != newrec_.adjusted_volume) )
            OR (NVL(oldrec_.forward_agent_id, CHR(32)) != NVL(newrec_.forward_agent_id, CHR(32)))
            OR (NVL(oldrec_.delivery_terms, CHR(32)) != NVL(newrec_.delivery_terms, CHR(32)))
            OR (oldrec_.discount != newrec_.discount) THEN
            --update freight charges ...
            del_term_rec_ := Order_Delivery_Term_API.Get(newrec_.delivery_terms);
            IF (oldrec_.supply_code IN ('PD', 'IPD') AND oldrec_.vendor_no IS NOT NULL) THEN
               old_freight_price_list_no_      := Freight_Price_List_Direct_API.Get_Active_Freight_List_No(oldrec_.contract, oldrec_.ship_via_code, oldrec_.freight_map_id, oldrec_.forward_agent_id, order_rec_.use_price_incl_tax, oldrec_.vendor_no);
            ELSE
               old_freight_price_list_no_      := Freight_Price_List_API.Get_Active_Freight_List_No(oldrec_.contract, oldrec_.ship_via_code, oldrec_.freight_map_id, oldrec_.forward_agent_id, order_rec_.use_price_incl_tax);
            END IF;
            OPEN get_freight_charge_seq(old_freight_price_list_no_);
            FETCH get_freight_charge_seq INTO tmp_sequence_no_;
            CLOSE get_freight_charge_seq;

            IF (tmp_sequence_no_ IS NOT NULL) THEN
               old_charge_rec_ := Customer_Order_Charge_API.Get(newrec_.order_no, tmp_sequence_no_ );
               
               -- Remove the old charge line.
               Customer_Order_Charge_API.Remove(newrec_.order_no, tmp_sequence_no_, NULL, allow_invoiced_chg_del_);
            END IF;

            IF (del_term_rec_.calculate_freight_charge = db_true_ AND (NVL(newrec_.adjusted_weight_gross,0) != 0 OR NVL(newrec_.adjusted_volume,0) != 0)) THEN
               -- Recalculate the charge.
               IF (newrec_.supply_code IN ('PD', 'IPD') AND newrec_.vendor_no IS NOT NULL) THEN
                  new_freight_price_list_no_      := Freight_Price_List_Direct_API.Get_Active_Freight_List_No(newrec_.contract, newrec_.ship_via_code, newrec_.freight_map_id, newrec_.forward_agent_id, order_rec_.use_price_incl_tax, newrec_.vendor_no);
               ELSE
                  new_freight_price_list_no_      := Freight_Price_List_API.Get_Active_Freight_List_No(newrec_.contract, newrec_.ship_via_code, newrec_.freight_map_id, newrec_.forward_agent_id, order_rec_.use_price_incl_tax);
               END IF;

               IF (new_freight_price_list_no_ IS NOT NULL ) THEN
                  Client_SYS.Add_To_Attr('ORDER_NO',                 newrec_.order_no,                freight_chg_attr_);
                  Client_SYS.Add_To_Attr('LINE_NO',                  newrec_.line_no,                 freight_chg_attr_);
                  Client_SYS.Add_To_Attr('REL_NO',                   newrec_.rel_no,                  freight_chg_attr_);
                  Client_SYS.Add_To_Attr('LINE_ITEM_NO',             newrec_.line_item_no,            freight_chg_attr_);
                  Client_SYS.Add_To_Attr('CHARGE_PRICE_LIST_NO',     new_freight_price_list_no_,      freight_chg_attr_);
                  Client_SYS.Add_To_Attr('SERVER_DATA_CHANGE',       db_true_,                        freight_chg_attr_);
                  -- Use client values, Check Customer_Order_Charge_API.New
                  IF (del_term_rec_.collect_freight_charge = db_true_) THEN
                     Client_SYS.Add_To_Attr('COLLECT',               Collect_API.Decode('COLLECT'),   freight_chg_attr_);
                  ELSE

                     Client_SYS.Add_To_Attr('COLLECT',               Collect_API.Decode('INVOICE'),   freight_chg_attr_);
                  END IF;

                  Get_Freight_Charge_Attr___(freight_chg_attr_);
                  IF (Client_SYS.Get_Item_Value('CHARGE_AMOUNT', freight_chg_attr_) IS NOT NULL) AND
                     (Client_SYS.Get_Item_Value('CHARGED_QTY', freight_chg_attr_) != 0)  THEN
                     Customer_Order_Charge_API.New(info_, freight_chg_attr_);
                     
                     IF (temp_order_state_ IN ('PartiallyDelivered')) THEN
                        tmp_sequence_no_ :=  Client_SYS.Get_Item_Value('SEQUENCE_NO', freight_chg_attr_);                     
                     
                        IF (tmp_sequence_no_ IS NOT NULL) THEN                                
                           Customer_Order_Charge_API.Modify_Invoiced_Qty ( newrec_.order_no,
                                                                           tmp_sequence_no_,
                                                                           old_charge_rec_.invoiced_qty,
                                                                           FALSE );
                        END IF;
                     END IF;
                  END IF;
               END IF;
            END IF;
            
            IF temp_order_state_ != 'Planned' THEN
               -- If attributes related to freight calculation group(planned_ship_date,zone_id,delivery_terms,freight_price_list_no,demand_code) are changed then consolidate whole order
               -- else consolidate freight of the line related to the relevant line
               IF (Validate_SYS.Is_Changed(newrec_.planned_ship_date,oldrec_.planned_ship_date) 
                   OR Validate_SYS.Is_Changed(newrec_.zone_id, oldrec_.zone_id)
                   OR Validate_SYS.Is_Changed(newrec_.delivery_terms,oldrec_.delivery_terms)
                   OR Validate_SYS.Is_Changed(newrec_.freight_price_list_no,oldrec_.freight_price_list_no)
                   OR Validate_SYS.Is_Changed(newrec_.demand_code,oldrec_.demand_code)) THEN
                  -- Consolidate old freight group
                  Customer_Order_Charge_Util_API.Consolidate_Grouped_Charges(oldrec_.order_no,
                                                                             NULL,
                                                                             oldrec_.planned_ship_date, 
                                                                             oldrec_.zone_id, 
                                                                             oldrec_.delivery_terms, 
                                                                             oldrec_.freight_price_list_no, 
                                                                             oldrec_.demand_code);
                  -- Consolidate new freight group
                  Customer_Order_Charge_Util_API.Consolidate_Grouped_Charges(newrec_.order_no,
                                                                             NULL,
                                                                             newrec_.planned_ship_date, 
                                                                             newrec_.zone_id, 
                                                                             newrec_.delivery_terms, 
                                                                             newrec_.freight_price_list_no, 
                                                                             newrec_.demand_code);
               ELSE
                  Customer_Order_Charge_Util_API.Consolidate_Grouped_Charges(newrec_.order_no,
                                                                             NULL,
                                                                             newrec_.planned_ship_date, 
                                                                             newrec_.zone_id, 
                                                                             newrec_.delivery_terms, 
                                                                             newrec_.freight_price_list_no, 
                                                                             newrec_.demand_code);
               END IF;
            END IF;
         END IF;
      END IF;
   END IF;
END Modify_Cust_Order_Charge_Line;


-- Modify_Quotation_Charge_Line
--   Modify SQ charge line which is connected to SQ line.
PROCEDURE Modify_Quotation_Charge_Line (
   newrec_ IN ORDER_QUOTATION_LINE_TAB%ROWTYPE,
   oldrec_ IN ORDER_QUOTATION_LINE_TAB%ROWTYPE,
   tax_code_changed_    IN VARCHAR2)
IS
   pack_size_chg_line_quot_no_  NUMBER;
   input_uom_allowed_           VARCHAR2(5);
   quote_state_                 VARCHAR2(4000);
   old_freight_price_list_no_   VARCHAR2(15);
   new_freight_price_list_no_   VARCHAR2(15);
   tmp_sequence_no_             NUMBER := NULL;
   calc_freight_charge_         VARCHAR2(20);
   freight_chg_attr_            VARCHAR2(2000);
   info_                        VARCHAR2(2000);
   quote_rec_                   Order_Quotation_API.Public_Rec;

   CURSOR get_packsize_charges IS
      SELECT quotation_charge_no
      FROM order_quotation_charge_tab oqc,
           sales_charge_type_tab      sct
      WHERE oqc.quotation_no = newrec_.quotation_no
      AND   oqc.line_no      = newrec_.line_no
      AND   oqc.rel_no       = newrec_.rel_no
      AND   oqc.line_item_no = newrec_.line_item_no
      AND   oqc.charge_type  = sct.charge_type
      AND   oqc.contract     = sct.contract
      AND   oqc.charge_price_list_no IS NOT NULL
      AND   sct.sales_chg_type_category = 'PACK_SIZE';

   CURSOR get_freight_charge_seq (freight_price_list_no_ IN VARCHAR2)IS
      SELECT quotation_charge_no
      FROM order_quotation_charge_tab oqc,
           sales_charge_type_tab     sct
      WHERE oqc.charge_price_list_no = freight_price_list_no_
      AND   sct.sales_chg_type_category = 'FREIGHT'
      AND   sct.contract = oqc.contract
      AND   sct.charge_type = oqc.charge_type
      AND   oqc.quotation_no = newrec_.quotation_no
      AND   oqc.line_no = newrec_.line_no
      AND   oqc.rel_no = newrec_.rel_no
      AND   oqc.line_item_no = newrec_.line_item_no;
BEGIN
   
   IF (newrec_.rental = Fnd_Boolean_API.DB_TRUE) THEN
      RETURN;
   END IF;

   -- When the buy qty changed modify the connected unit charge quantities.
   IF (newrec_.buy_qty_due != oldrec_.buy_qty_due) THEN
      Order_Quotation_Charge_API.Update_Connected_Charged_Qty(newrec_.quotation_no,newrec_.line_no,
                                                              newrec_.rel_no, newrec_.line_item_no,
                                                              newrec_.buy_qty_due);
   END IF;

   pack_size_chg_line_quot_no_ := Order_Quotation_Charge_API.Get_Pack_Size_Chg_Line_Quot_No(newrec_.quotation_no,
                                                                                            newrec_.line_no, newrec_.rel_no,
                                                                                            newrec_.line_item_no);
   IF (pack_size_chg_line_quot_no_ IS NOT NULL ) THEN
      input_uom_allowed_ := Input_Unit_Meas_Group_API.Is_Usage_Allowed(Inventory_Part_API.Get_Input_Unit_Meas_Group_Id(newrec_.contract,Sales_Part_API.Get_Part_No(newrec_.contract, newrec_.catalog_no)), 'ORDER');
      -- Packsize charges needed to be refetched when the customer changes.
      IF ((oldrec_.input_qty != newrec_.input_qty) OR (oldrec_.input_unit_meas != newrec_.input_unit_meas)
         OR (NVL(oldrec_.tax_code, Database_SYS.string_null_) !=  NVL(newrec_.tax_code, Database_SYS.string_null_)) 
         OR (oldrec_.tax_code IS NULL AND newrec_.tax_code IS NULL AND NVL(tax_code_changed_, 'FALSE') = db_true_) 
         OR (newrec_.buy_qty_due != oldrec_.buy_qty_due) OR (newrec_.customer_no != oldrec_.customer_no)
         OR (oldrec_.sale_unit_price != newrec_.sale_unit_price) OR (oldrec_.unit_price_incl_tax != newrec_.unit_price_incl_tax)
         OR (oldrec_.base_sale_unit_price != newrec_.base_sale_unit_price) OR (oldrec_.base_unit_price_incl_tax != newrec_.base_unit_price_incl_tax)) AND input_uom_allowed_ = db_true_ THEN
         -- Delete all PACKSIZE charge lines
         FOR rec_ IN get_packsize_charges LOOP
            Order_Quotation_Charge_API.Remove(newrec_.quotation_no, rec_.quotation_charge_no);
         END LOOP;
         New_Quotation_Charge_Line(newrec_);
      END IF;
   END IF;
   -- update freight charge line
   quote_state_ := Order_Quotation_API.Get_Objstate(newrec_.quotation_no);
   quote_rec_ := Order_Quotation_API.Get(newrec_.quotation_no);
   IF (quote_state_ IN ('Planned' ,'Released', 'Revised')) THEN
      IF (NVL(oldrec_.zone_id, CHR(32)) != NVL(newrec_.zone_id, CHR(32))) OR (oldrec_.buy_qty_due != newrec_.buy_qty_due) OR (NVL(oldrec_.input_qty,0) != NVL(newrec_.input_qty,0)
         OR (oldrec_.planned_due_date != newrec_.planned_due_date) OR (oldrec_.ship_via_code != newrec_.ship_via_code) OR (NVL(oldrec_.vendor_no, CHR(32)) != NVL(newrec_.vendor_no, CHR(32)))
         OR (oldrec_.line_total_weight != newrec_.line_total_weight) OR (oldrec_.line_total_qty != newrec_.line_total_qty)
         OR (oldrec_.adjusted_weight_net != newrec_.adjusted_weight_net) OR (oldrec_.adjusted_volume != newrec_.adjusted_volume) )
         OR (NVL(oldrec_.forward_agent_id, CHR(32)) != NVL(newrec_.forward_agent_id, CHR(32)))
         OR (oldrec_.discount != newrec_.discount) THEN
         --update freight charges ...
         IF (oldrec_.order_supply_type IN ('PD', 'IPD') AND oldrec_.vendor_no IS NOT NULL) THEN
            old_freight_price_list_no_ := Freight_Price_List_Direct_API.Get_Active_Freight_List_No(oldrec_.contract, oldrec_.ship_via_code, oldrec_.freight_map_id, oldrec_.forward_agent_id, quote_rec_.use_price_incl_tax, oldrec_.vendor_no);
         ELSE
            old_freight_price_list_no_ := Freight_Price_List_API.Get_Active_Freight_List_No(oldrec_.contract, oldrec_.ship_via_code, oldrec_.freight_map_id, oldrec_.forward_agent_id, quote_rec_.use_price_incl_tax);
         END IF;

         OPEN get_freight_charge_seq(old_freight_price_list_no_);
         FETCH get_freight_charge_seq INTO tmp_sequence_no_;
         CLOSE get_freight_charge_seq;

         IF (tmp_sequence_no_ IS NOT NULL) THEN
            -- Remove the old charge line.
            Order_Quotation_Charge_API.Remove(newrec_.quotation_no, tmp_sequence_no_);
         END IF;

         calc_freight_charge_ := Order_Delivery_Term_API.Get_Calculate_Freight_Charge(newrec_.delivery_terms);

         IF (calc_freight_charge_ = db_true_ AND (NVL(newrec_.adjusted_weight_gross,0) != 0 OR NVL(newrec_.adjusted_volume,0) != 0)) THEN
            -- Recalculate the charge.
            IF (newrec_.order_supply_type IN ('PD', 'IPD') AND newrec_.vendor_no IS NOT NULL) THEN
               new_freight_price_list_no_ := Freight_Price_List_Direct_API.Get_Active_Freight_List_No(newrec_.contract, newrec_.ship_via_code, newrec_.freight_map_id, newrec_.forward_agent_id, quote_rec_.use_price_incl_tax, newrec_.vendor_no);
            ELSE
               new_freight_price_list_no_ := Freight_Price_List_API.Get_Active_Freight_List_No(newrec_.contract, newrec_.ship_via_code, newrec_.freight_map_id, newrec_.forward_agent_id, quote_rec_.use_price_incl_tax);
            END IF;

            IF (new_freight_price_list_no_ IS NOT NULL ) THEN
                  Client_SYS.Add_To_Attr('QUOTATION_NO',         newrec_.quotation_no,       freight_chg_attr_);
                  Client_SYS.Add_To_Attr('LINE_NO',              newrec_.line_no,            freight_chg_attr_);
                  Client_SYS.Add_To_Attr('REL_NO',               newrec_.rel_no,             freight_chg_attr_);
                  Client_SYS.Add_To_Attr('LINE_ITEM_NO',         newrec_.line_item_no,       freight_chg_attr_);
                  Client_SYS.Add_To_Attr('CHARGE_PRICE_LIST_NO', new_freight_price_list_no_, freight_chg_attr_);
                  Client_SYS.Add_To_Attr('SERVER_DATA_CHANGE',   db_true_,                   freight_chg_attr_);

                  Get_Freight_Charge_Attr___(freight_chg_attr_);
                  IF (Client_SYS.Get_Item_Value('CHARGE_AMOUNT', freight_chg_attr_) IS NOT NULL) AND
                     (Client_SYS.Get_Item_Value('CHARGED_QTY', freight_chg_attr_) != 0)  THEN
                     Order_Quotation_Charge_API.New(info_, freight_chg_attr_);
                  END IF;
            END IF;
         END IF;
      END IF;
   END IF;
END Modify_Quotation_Charge_Line;


-- Calc_Consolidate_Charges
--   This will consolidate the freight charges connected to the order accordingly.
--   Prior this, the CO lines with single occurrence addresses get a fright map and a zone id picked automatically.
PROCEDURE Calc_Consolidate_Charges(
   order_no_     IN VARCHAR2,
   quotation_no_ IN VARCHAR2 DEFAULT NULL )
IS
   CURSOR order_delivery_groups IS
      SELECT planned_ship_date,
             zone_id,
             delivery_terms,
             freight_price_list_no,
             demand_code
      FROM customer_order_line_tab
      WHERE order_no = order_no_
      GROUP BY planned_ship_date,
               zone_id,
               delivery_terms,
               freight_price_list_no,
               demand_code;

   CURSOR quotation_delivery_groups(dist_calendar_id_ IN VARCHAR2, picking_lead_time_ IN NUMBER) IS
      SELECT Cust_Ord_Date_Calculation_API.Get_Calendar_End_Date(dist_calendar_id_, planned_due_date, picking_lead_time_) planned_ship_date,
             zone_id,
             delivery_terms,
             freight_price_list_no,
             demand_code
      FROM order_quotation_line_tab
      WHERE quotation_no = quotation_no_
      GROUP BY Cust_Ord_Date_Calculation_API.Get_Calendar_End_Date(dist_calendar_id_, planned_due_date, picking_lead_time_),
               zone_id,
               delivery_terms,
               freight_price_list_no,
               demand_code;

   contract_            VARCHAR2(5);
   picking_lead_time_   NUMBER;
   dist_calendar_id_    site_tab.dist_calendar_id%TYPE;
   
BEGIN
   IF (order_no_ IS NOT NULL) THEN
      FOR rec_ IN order_delivery_groups LOOP
         IF (Order_Delivery_Term_API.Get_Calculate_Freight_Charg_Db(rec_.delivery_terms) = db_true_) THEN
            Consolidate_Grouped_Charges(order_no_,
                                        NULL,
                                        rec_.planned_ship_date,
                                        rec_.zone_id,
                                        rec_.delivery_terms,
                                        rec_.freight_price_list_no,
                                        rec_.demand_code);
         END IF;
      END LOOP;
      
   ELSIF (quotation_no_ IS NOT NULL) THEN
      contract_          := Order_Quotation_API.Get_Contract(quotation_no_);
      dist_calendar_id_  := Site_API.Get_Dist_Calendar_Id(contract_);
      picking_lead_time_ := Site_Invent_Info_API.Get_Picking_Leadtime(contract_);
      
      FOR rec_ IN quotation_delivery_groups(dist_calendar_id_,picking_lead_time_) LOOP
         IF (Order_Delivery_Term_API.Get_Calculate_Freight_Charg_Db(rec_.delivery_terms) = db_true_) THEN
            Consolidate_Grouped_Charges(NULL,
                                        quotation_no_,
                                        rec_.planned_ship_date,
                                        rec_.zone_id,
                                        rec_.delivery_terms,
                                        rec_.freight_price_list_no,
                                        rec_.demand_code);
         END IF;
      END LOOP;
      
   END IF;
END Calc_Consolidate_Charges;


PROCEDURE Consolidate_Grouped_Charges(
   order_no_              IN VARCHAR2,
   quotation_no_          IN VARCHAR2,
   planned_ship_date_     IN DATE,
   zone_id_               IN VARCHAR2,
   delivery_terms_        IN VARCHAR2,
   freight_price_list_no_ IN VARCHAR2,
   demand_code_           IN VARCHAR2 )
IS
   CURSOR get_customer_order_lines(use_shipment_freight_charge_ IN VARCHAR2) IS
      SELECT *
      FROM   customer_order_line_tab
      WHERE  order_no = order_no_
      AND    planned_ship_date = planned_ship_date_
      AND    zone_id = zone_id_
      AND    delivery_terms = delivery_terms_
      AND    freight_price_list_no = freight_price_list_no_
      AND    (demand_code  = demand_code_ OR demand_code_ IS NULL)
      AND    part_ownership = 'COMPANY OWNED'
      AND    (NVL(adjusted_weight_gross, 0) != 0 OR NVL(adjusted_volume, 0) != 0)
      AND    charged_item = 'CHARGED ITEM'
      AND    rowstate NOT IN ('Cancelled', 'Invoiced')
      AND    qty_invoiced = 0
      AND    (use_shipment_freight_charge_ = db_false_ 
              OR
              (use_shipment_freight_charge_ = db_true_ AND shipment_connected = db_false_ ));

   CURSOR get_order_quotion_lines(dist_calendar_id_ IN VARCHAR2, picking_lead_time_ IN NUMBER) IS
      SELECT *
      FROM   order_quotation_line_tab
      WHERE  quotation_no = quotation_no_
      AND    Cust_Ord_Date_Calculation_API.Get_Calendar_End_Date(dist_calendar_id_, planned_due_date, picking_lead_time_) = planned_ship_date_
      AND    zone_id = zone_id_
      AND    delivery_terms = delivery_terms_
      AND    freight_price_list_no = freight_price_list_no_
      AND    rental = 'FALSE'
      AND    (demand_code = demand_code_ OR demand_code_ IS NULL)
      AND    (NVL(adjusted_weight_gross, 0) != 0 OR NVL(adjusted_volume, 0) != 0)
      AND    rowstate NOT IN ('Cancelled', 'Lost', 'Won', 'CO Created');

   CURSOR get_order_lines(use_shipment_freight_charge_ IN VARCHAR2) IS
      SELECT SUM(NVL(adjusted_weight_gross,0)) total_weight,
             SUM(NVL(adjusted_volume,0))       total_volume
      FROM  customer_order_line_tab
      WHERE order_no = order_no_
      AND   planned_ship_date = planned_ship_date_
      AND   zone_id = zone_id_
      AND   delivery_terms = delivery_terms_
      AND   freight_price_list_no = freight_price_list_no_
      AND   (demand_code = demand_code_ OR demand_code_ IS NULL)
      AND   part_ownership = 'COMPANY OWNED'
      AND   rowstate NOT IN ('Cancelled', 'Invoiced')
      AND   qty_invoiced = 0
      AND   charged_item = 'CHARGED ITEM'
      AND   line_item_no <= 0
      AND   (use_shipment_freight_charge_ = db_false_
             OR
            (use_shipment_freight_charge_ = db_true_ AND shipment_connected = db_false_ ));

   CURSOR get_quote_lines(dist_calendar_id_ IN VARCHAR2, picking_lead_time_ IN NUMBER) IS
      SELECT SUM(NVL(adjusted_weight_gross,0)) total_weight,
             SUM(NVL(adjusted_volume, 0))      total_volume
      FROM  order_quotation_line_tab
      WHERE quotation_no = quotation_no_
      AND   Cust_Ord_Date_Calculation_API.Get_Calendar_End_Date(dist_calendar_id_, planned_due_date, picking_lead_time_) = planned_ship_date_
      AND   zone_id  = zone_id_
      AND   delivery_terms = delivery_terms_
      AND   freight_price_list_no = freight_price_list_no_
      AND   rental = 'FALSE'
      AND   (demand_code = demand_code_ OR demand_code_ IS NULL)
      AND   rowstate NOT IN ('Cancelled', 'Lost', 'Won', 'CO Created')
      AND   line_item_no <= 0;

   CURSOR get_order_line_charges(delivery_terms_              IN VARCHAR2,
                                 freight_price_list_no_       IN VARCHAR2,
                                 zone_id_                     IN VARCHAR2,
                                 planned_ship_date_           IN DATE,
                                 use_shipment_freight_charge_ IN VARCHAR2) IS
      SELECT coc.sequence_no,
             NVL(col.adjusted_weight_gross, 0) line_weight,
             NVL(col.adjusted_volume,0)        line_volume
      FROM  customer_order_line_tab   col,
            customer_order_charge_tab coc,
            sales_charge_type_tab     sct
      WHERE col.order_no = coc.order_no
      AND   col.part_ownership = 'COMPANY OWNED'
      AND   col.line_no = coc.line_no
      AND   col.rel_no = coc.rel_no
      AND   col.line_item_no = coc.line_item_no
      AND   sct.contract = coc.contract
      AND   sct.charge_type = coc.charge_type
      AND   col.delivery_terms = delivery_terms_
      AND   col.freight_price_list_no = freight_price_list_no_
      AND   col.zone_id = zone_id_
      AND   col.planned_ship_date = planned_ship_date_
      AND   sct.sales_chg_type_category = 'FREIGHT'
      AND   col.rowstate NOT IN ('Cancelled','Invoiced')
      AND   coc.invoiced_qty = 0
      AND   col.line_item_no <= 0
      AND   col.order_no = order_no_
      AND   coc.free_of_charge = 'FALSE'
      AND   (use_shipment_freight_charge_ = db_false_
             OR
             (use_shipment_freight_charge_ = db_true_ AND col.shipment_connected = db_false_ ));

   CURSOR get_quote_line_charges(delivery_terms_              IN VARCHAR2,
                                 freight_price_list_no_       IN VARCHAR2,
                                 zone_id_                     IN VARCHAR2,
                                 planned_ship_date_           IN DATE,
                                 picking_lead_time_           IN NUMBER ) IS
      SELECT oqc.quotation_charge_no,
             NVL(ql.adjusted_weight_gross, 0) line_weight,
             NVL(ql.adjusted_volume,0)        line_volume
      FROM  order_quotation_line_tab   ql,
            order_quotation_charge_tab oqc,
            sales_charge_type_tab      sct
      WHERE ql.quotation_no = oqc.quotation_no
      AND   ql.line_no = oqc.line_no
      AND   ql.rel_no = oqc.rel_no
      AND   ql.line_item_no = oqc.line_item_no
      AND   sct.contract = oqc.contract
      AND   sct.charge_type = oqc.charge_type
      AND   ql.delivery_terms = delivery_terms_
      AND   ql.freight_price_list_no = freight_price_list_no_
      AND   ql.rental = 'FALSE'
      AND   ql.zone_id = zone_id_
      AND   Cust_Ord_Date_Calculation_API.Get_Calendar_End_Date(Site_API.Get_Dist_Calendar_Id(ql.contract), ql.planned_due_date, picking_lead_time_) = planned_ship_date_
      AND   sct.sales_chg_type_category = 'FREIGHT'
      AND   ql.rowstate NOT IN ('Cancelled', 'Lost', 'Won', 'CO Created')
      AND   ql.line_item_no <= 0
      AND   ql.quotation_no = quotation_no_;

   CURSOR get_minimum_adj_info_order(use_shipment_freight_charge_ IN VARCHAR2,
                                     planned_ship_date_           IN DATE,
                                     zone_id_                     IN VARCHAR2,
                                     delivery_terms_              IN VARCHAR2,
                                     freight_price_list_no_       IN VARCHAR2) IS
      SELECT MIN(NVL(adjusted_weight_gross, 0)) min_weight,
             MIN(NVL(adjusted_volume, 0))       min_volume
      FROM  customer_order_line_tab
      WHERE order_no = order_no_
      AND   part_ownership = 'COMPANY OWNED'
      AND   rowstate NOT IN ('Cancelled','Invoiced')
      AND   qty_invoiced = 0
      AND   charged_item = 'CHARGED ITEM'
      AND   line_item_no <= 0
      AND   (use_shipment_freight_charge_ = db_false_
             OR
             (use_shipment_freight_charge_ = db_true_ AND shipment_connected = db_false_ ))
      AND   planned_ship_date = planned_ship_date_
      AND   zone_id = zone_id_
      AND   delivery_terms = delivery_terms_
      AND   freight_price_list_no = freight_price_list_no_;


   CURSOR get_minimum_adj_info_quote(picking_lead_time_      IN NUMBER,
                                     planned_ship_date_      IN DATE,
                                     zone_id_                IN VARCHAR2,
                                     delivery_terms_         IN VARCHAR2,
                                     freight_price_list_no_  IN VARCHAR2) IS
      SELECT MIN(NVL(adjusted_weight_gross, 0)) min_weight,
             MIN(NVL(adjusted_volume, 0))       min_volume
      FROM  order_quotation_line_tab
      WHERE quotation_no = quotation_no_
      AND   rowstate NOT IN ('Cancelled', 'Lost', 'Won', 'CO Created')
      AND   line_item_no <= 0
      AND   Cust_Ord_Date_Calculation_API.Get_Calendar_End_Date(Site_API.Get_Dist_Calendar_Id(contract), planned_due_date, picking_lead_time_) = planned_ship_date_
      AND   rental = 'FALSE'
      AND   zone_id = zone_id_
      AND   delivery_terms = delivery_terms_
      AND   freight_price_list_no = freight_price_list_no_;

   TYPE Line_Rec IS RECORD(
      total_weight          NUMBER,
      total_volume          NUMBER);

   TYPE Line_List IS TABLE OF Line_Rec;
   lines_ Line_List := Line_List();

   TYPE Charge_Line_Rec IS RECORD(
      sequence_no           NUMBER,
      line_weight           NUMBER,
      line_volume           NUMBER);

   TYPE Charge_Line_List IS TABLE OF Charge_Line_Rec;
   charge_lines_ Charge_Line_List := Charge_Line_List();
   
   charge_price_list_no_           FREIGHT_PRICE_LIST_BASE_TAB.price_list_no%TYPE;
   new_freight_charge_             NUMBER;
   freight_attr_                   VARCHAR2(2000);
   ord_rec_                        Customer_Order_API.Public_Rec;
   freight_price_list_rec_         Freight_Price_List_Base_API.Public_Rec;
   line_total_volume_              NUMBER;
   line_total_weight_              NUMBER;
   is_unit_based_                  VARCHAR2(5);
   freight_charge_                 NUMBER;
   base_freight_charge_            NUMBER;
   min_freight_amount_             NUMBER;
   currency_rate_                  NUMBER;
   consolidated_                   BOOLEAN := FALSE;
   update_chg_qty_                 BOOLEAN := FALSE;
   proceed_with_charge_fetching_   BOOLEAN := FALSE;
   use_shipment_freight_charge_    VARCHAR2(5) := db_false_;
   collect_freight_charge_         VARCHAR2(5) := db_false_;
   new_qty_                        NUMBER;
   tmp_charged_tot_wght_vol_       NUMBER;
   tmp_charge_weight_vol_          NUMBER;
   freight_free_amount_            NUMBER;
   order_amount_                   NUMBER;
   charge_cost_                    NUMBER;
   info_                           VARCHAR2(2000);
   contract_                       VARCHAR2(5);
   dist_calendar_id_               site_tab.dist_calendar_id%TYPE;
   picking_lead_time_              NUMBER;
   fix_deliv_freight_              NUMBER;
   apply_fix_deliv_freight_        VARCHAR2(20);
   customer_no_pay_                VARCHAR2(20);
   customer_no_                    VARCHAR2(20);
   currency_code_                  VARCHAR2(3);
   currency_rate_type_             VARCHAR2(10);
   quote_rec_                      Order_Quotation_API.Public_Rec;
   charged_qty_                    NUMBER;
   base_freight_chg_sum_           NUMBER := 0;
   rounded_chg_sum_                NUMBER := 0;
   highest_freight_charge_         NUMBER := 0;
   highest_chg_found_              BOOLEAN := FALSE;
   highest_chg_line_seq_           NUMBER;
   charge_attr_                    VARCHAR2(2000);
   adj_base_freight_chg_           NUMBER;
   charge_variance_                NUMBER := 0;
   min_volume_                     NUMBER;
   min_weight_                     NUMBER;
   min_base_freight_charge_        NUMBER := 0;
   find_round_factor_              BOOLEAN := FALSE;
   rounding_factor_                NUMBER := 0;
   head_freight_price_list_no_     Freight_Price_List_Base_Tab.price_list_no%TYPE;
   company_                        site_tab.company%TYPE;
   purch_company_                  site_tab.company%TYPE;
   stmt_                           VARCHAR2(2000);
   intersite_same_company_         BOOLEAN := FALSE;
   use_price_incl_tax_             VARCHAR2(20);
   freight_charge_amount_          NUMBER;
   rounding_needed_                BOOLEAN := TRUE;
   company_uom_                    SALES_CHARGE_TYPE_TAB.sales_unit_meas%TYPE;
   charge_type_uom_                SALES_CHARGE_TYPE_TAB.sales_unit_meas%TYPE;
   charge_weight_charge_uom_       NUMBER;
   charge_volumn_charge_uom_       NUMBER;
   
BEGIN
   IF (order_no_ IS NOT NULL) THEN
      ord_rec_ := Customer_Order_API.Get(order_no_);
      apply_fix_deliv_freight_    := ord_rec_.apply_fix_deliv_freight;
      fix_deliv_freight_          := ord_rec_.fix_deliv_freight;
      customer_no_pay_            := ord_rec_.customer_no_pay;
      customer_no_                := ord_rec_.customer_no;
      currency_code_              := ord_rec_.currency_code;
      currency_rate_type_         := ord_rec_.currency_rate_type;
      head_freight_price_list_no_ := ord_rec_.freight_price_list_no;
      use_price_incl_tax_         := ord_rec_.use_price_incl_tax;
   ELSIF (quotation_no_ IS NOT NULL) THEN
      quote_rec_ := Order_Quotation_API.Get(quotation_no_);
      apply_fix_deliv_freight_    := quote_rec_.apply_fix_deliv_freight;
      fix_deliv_freight_          := quote_rec_.fix_deliv_freight;
      customer_no_pay_            := quote_rec_.customer_no_pay;
      customer_no_                := quote_rec_.customer_no;
      currency_code_              := quote_rec_.currency_code;
      head_freight_price_list_no_ := quote_rec_.freight_price_list_no;
      use_price_incl_tax_         := quote_rec_.use_price_incl_tax;
   END IF;
   collect_freight_charge_ := Order_Delivery_Term_API.Get_Collect_Freight_Charge_Db(delivery_terms_);

   -- Add temporary zero charge lines
   IF (order_no_ IS NOT NULL) THEN
      contract_ := Customer_Order_API.Get_Contract(order_no_);
      use_shipment_freight_charge_ := Site_Discom_Info_API.Get_Shipment_Freight_Charge_Db(contract_);
      -- In order to consolidate the CO lines for assign the fixed deliv freight, minimmum freight or
      -- freight free amount, first of all we need to create freight charge lines for all customer order lines
      -- So we create charge lines with 0 amounts for those CO line.
      FOR coline_rec_ IN get_customer_order_lines(use_shipment_freight_charge_) LOOP
         -- If there are no freight charge lines connected to the CO line, add 0 charge lines
         IF NOT Order_Conn_Fr_Charge_Exist___(coline_rec_.order_no, coline_rec_.line_no, coline_rec_.rel_no, coline_rec_.line_item_no) THEN
            -- fetch intersite data if it has not been fetched already
            IF ((NOT intersite_same_company_) AND (demand_code_ = 'IPD'))THEN
               company_ := Site_API.Get_Company(contract_);
               stmt_ := 'BEGIN
                            :purch_company := Site_API.Get_Company(Purchase_Order_Line_API.Get_Contract(:demand_order_ref1, :demand_order_ref2, :demand_order_ref3));
                         END;';
               @ApproveDynamicStatement(2011-10-05,ShKolk)
               EXECUTE IMMEDIATE stmt_ USING
                  OUT purch_company_,
                  IN  coline_rec_.demand_order_ref1,
                  IN  coline_rec_.demand_order_ref2,
                  IN  coline_rec_.demand_order_ref3;
               IF company_ = NVL(purch_company_, company_) THEN
                  intersite_same_company_ := TRUE;
               END IF;
            END IF;

            IF (NVL(coline_rec_.demand_code, Database_SYS.string_null_) != 'IPD') OR ((NOT intersite_same_company_) AND (coline_rec_.demand_code = 'IPD')) THEN
               IF (coline_rec_.supply_code IN ('PD', 'IPD') AND coline_rec_.vendor_no IS NOT NULL) THEN
                  charge_price_list_no_ := Freight_Price_List_Direct_API.Get_Active_Freight_List_No(coline_rec_.contract,
                                                                                                    coline_rec_.ship_via_code,
                                                                                                    coline_rec_.freight_map_id,
                                                                                                    coline_rec_.forward_agent_id,
                                                                                                    use_price_incl_tax_,
                                                                                                    coline_rec_.vendor_no);
               ELSE
                  charge_price_list_no_ := Freight_Price_List_API.Get_Active_Freight_List_No(coline_rec_.contract,
                                                                                             coline_rec_.ship_via_code,
                                                                                             coline_rec_.freight_map_id,
                                                                                             coline_rec_.forward_agent_id,
                                                                                             use_price_incl_tax_);
               END IF;
               IF (charge_price_list_no_ IS NOT NULL) THEN
                  Client_Sys.Clear_Attr(freight_attr_);
                  Client_SYS.Add_To_Attr('TEMP_CHARGE_LINE',      db_true_,                  freight_attr_);
                  Client_SYS.Add_To_Attr('ORDER_NO',              coline_rec_.order_no,      freight_attr_);
                  Client_SYS.Add_To_Attr('LINE_NO',               coline_rec_.line_no,       freight_attr_);
                  Client_SYS.Add_To_Attr('REL_NO',                coline_rec_.rel_no,        freight_attr_);
                  Client_SYS.Add_To_Attr('LINE_ITEM_NO',          coline_rec_.line_item_no,  freight_attr_);
                  Client_SYS.Add_To_Attr('CHARGE_PRICE_LIST_NO',  charge_price_list_no_,     freight_attr_);
                  IF (Order_Delivery_Term_API.Get_Collect_Freight_Charge_Db(delivery_terms_) = db_true_) THEN
                     Client_SYS.Add_To_Attr('COLLECT',Collect_API.Decode('COLLECT'),  freight_attr_);
                  ELSE
                     Client_SYS.Add_To_Attr('COLLECT', Collect_API.Decode('INVOICE'),  freight_attr_);
                  END IF;
                  Get_Freight_Charge_Attr___(freight_attr_);
                  Client_SYS.Set_Item_Value('CHARGE_AMOUNT',            0,        freight_attr_);
                  Client_SYS.Set_Item_Value('CHARGE_AMOUNT_INCL_TAX',   0,        freight_attr_);
                  Client_SYS.Set_Item_Value('CHARGE_COST',              0,        freight_attr_);
                  Client_SYS.Set_Item_Value('CHARGED_QTY',              0,        freight_attr_);
                  Client_SYS.Set_Item_Value('BASE_CHARGE_AMOUNT',       0,        freight_attr_);
                  Client_SYS.Set_Item_Value('BASE_CHARGE_AMT_INCL_TAX', 0,        freight_attr_);
                  Client_SYS.Set_Item_Value('SERVER_DATA_CHANGE',       db_true_, freight_attr_);
                  IF (Client_SYS.Get_Item_Value('CHARGE_TYPE', freight_attr_) IS NOT NULL) THEN
                     Customer_Order_Charge_API.New(info_, freight_attr_);
                  END IF;
               END IF;
            END IF;
         END IF;
      END LOOP;

      -- Get the total gross weight and total volume of lines
      OPEN get_order_lines(use_shipment_freight_charge_);
      FETCH get_order_lines BULK COLLECT INTO lines_;
      CLOSE get_order_lines;
   ELSIF (quotation_no_ IS NOT NULL) THEN
      contract_ := Order_Quotation_API.Get_Contract(quotation_no_);
      dist_calendar_id_  := Site_API.Get_Dist_Calendar_Id(contract_);
      picking_lead_time_ := Site_Invent_Info_API.Get_Picking_Leadtime(contract_);
      -- In order to consolidate the quotation lines for assign the fixed deliv freight, minimmum freight or
      -- freight free amount, first of all we need to create freight charge lines for all customer order lines
      -- So we create charge lines with 0 amounts for those CO line.        FOR qouteline_rec_ IN get_order_quotion_lines LOOP
      FOR qouteline_rec_ IN get_order_quotion_lines(dist_calendar_id_,picking_lead_time_) LOOP
         IF NOT Quote_Conn_Fr_Charge_Exist___(quotation_no_, qouteline_rec_.line_no, qouteline_rec_.rel_no, qouteline_rec_.line_item_no) THEN
            IF (qouteline_rec_.order_supply_type IN ('PD', 'IPD') AND qouteline_rec_.vendor_no IS NOT NULL) THEN
               charge_price_list_no_ := Freight_Price_List_Direct_API.Get_Active_Freight_List_No(qouteline_rec_.contract,
                                                                                                 qouteline_rec_.ship_via_code,
                                                                                                 qouteline_rec_.freight_map_id,
                                                                                                 qouteline_rec_.forward_agent_id,
                                                                                                 use_price_incl_tax_,
                                                                                                 qouteline_rec_.vendor_no);
            ELSE
               charge_price_list_no_ := Freight_Price_List_API.Get_Active_Freight_List_No(qouteline_rec_.contract,
                                                                                          qouteline_rec_.ship_via_code,
                                                                                          qouteline_rec_.freight_map_id,
                                                                                          qouteline_rec_.forward_agent_id,
                                                                                          use_price_incl_tax_);
            END IF;
            IF (charge_price_list_no_ IS NOT NULL) THEN
               Client_Sys.Clear_Attr(freight_attr_);
               Client_SYS.Add_To_Attr('TEMP_CHARGE_LINE',      db_true_,                     freight_attr_);
               Client_SYS.Add_To_Attr('QUOTATION_NO',          quotation_no_,                freight_attr_);
               Client_SYS.Add_To_Attr('LINE_NO',               qouteline_rec_.line_no,       freight_attr_);
               Client_SYS.Add_To_Attr('REL_NO',                qouteline_rec_.rel_no,        freight_attr_);
               Client_SYS.Add_To_Attr('LINE_ITEM_NO',          qouteline_rec_.line_item_no,  freight_attr_);
               Client_SYS.Add_To_Attr('CHARGE_PRICE_LIST_NO',  charge_price_list_no_,       freight_attr_);

               Get_Freight_Charge_Attr___(freight_attr_);
               Client_SYS.Set_Item_Value('CHARGE_AMOUNT',            0,        freight_attr_);
               Client_SYS.Set_Item_Value('CHARGE_AMOUNT_INCL_TAX',   0,        freight_attr_);
               Client_SYS.Set_Item_Value('CHARGE_COST',              0,        freight_attr_);
               Client_SYS.Set_Item_Value('CHARGED_QTY',              0,        freight_attr_);
               Client_SYS.Set_Item_Value('BASE_CHARGE_AMOUNT',       0,        freight_attr_);
               Client_SYS.Set_Item_Value('BASE_CHARGE_AMT_INCL_TAX', 0,        freight_attr_);
               Client_SYS.Set_Item_Value('SERVER_DATA_CHANGE',       db_true_, freight_attr_);
               IF (Client_SYS.Get_Item_Value('CHARGE_TYPE', freight_attr_) IS NOT NULL) THEN
                  Order_Quotation_Charge_API.New(info_, freight_attr_);
               END IF;
            END IF;
         END IF;
      END LOOP;

      -- Get the total gross weight and total volume of lines
      OPEN get_quote_lines(dist_calendar_id_,picking_lead_time_);
      FETCH get_quote_lines BULK COLLECT INTO lines_;
      CLOSE get_quote_lines;
   END IF;
   IF company_ IS NULL THEN
      company_ := Site_API.Get_Company(contract_);
   END IF;
   -- Consolidate charges
   IF (lines_.count > 0) THEN
      FOR i_ IN lines_.FIRST .. lines_.LAST LOOP
         min_volume_             := 0;
         min_weight_             := 0;
         rounding_factor_        := 2;
         base_freight_chg_sum_   := 0;
         highest_freight_charge_ := 0;
         highest_chg_found_      := FALSE;
         find_round_factor_      := FALSE;

         freight_price_list_rec_ := Freight_Price_List_Base_API.Get(freight_price_list_no_);

         min_freight_amount_    := Freight_Price_List_Zone_API.Get_Min_Freight_Amount(freight_price_list_no_,
                                                                                      freight_price_list_rec_.freight_map_id,
                                                                                      zone_id_);
         freight_free_amount_   := Freight_Price_List_Zone_API.Get_Freight_Free_Amount(freight_price_list_no_,
                                                                                       freight_price_list_rec_.freight_map_id,
                                                                                       zone_id_);

         IF (freight_price_list_rec_.freight_basis = 'WEIGHT_BASED') THEN
            line_total_volume_ := NULL;
            line_total_weight_ := lines_(i_).total_weight;
            company_uom_     := Company_Invent_Info_API.Get_Uom_For_Weight(company_);
            charge_type_uom_ := Sales_Charge_Type_API.Get_Sales_Unit_Meas(contract_, freight_price_list_rec_.charge_type);
            IF line_total_weight_ IS NOT NULL AND line_total_weight_ != 0 THEN
               IF company_uom_ != charge_type_uom_ THEN
                  line_total_weight_ := NVL(Iso_Unit_API.Get_Unit_Converted_Quantity(line_total_weight_, company_uom_, charge_type_uom_), line_total_weight_);
               END IF;
            END IF;
            -- To proceed with a weight based price list the adjusted weight is mandatory.
            IF (line_total_weight_ IS NOT NULL AND line_total_weight_ > 0) THEN
               proceed_with_charge_fetching_ := TRUE;
            END IF;
         ELSE
            line_total_weight_ := NULL;
            line_total_volume_ := lines_(i_).total_volume;
            company_uom_     := Company_Invent_Info_API.Get_Uom_For_Volume(company_);
            charge_type_uom_ := Sales_Charge_Type_API.Get_Sales_Unit_Meas(contract_, freight_price_list_rec_.charge_type);
            IF line_total_volume_ IS NOT NULL AND line_total_volume_ != 0 THEN
               IF company_uom_ != charge_type_uom_ THEN
                  line_total_volume_ := NVL(Iso_Unit_API.Get_Unit_Converted_Quantity(line_total_volume_, company_uom_, charge_type_uom_), line_total_volume_);
               END IF;
            END IF;
            IF (line_total_volume_ IS NOT NULL AND line_total_volume_ > 0 ) THEN
               proceed_with_charge_fetching_ := TRUE;
            END IF;
         END IF;

         IF (proceed_with_charge_fetching_) THEN
            -- Note : line_total_weight_ and line_total_volume_ are adjusted values using freight factor.
            new_freight_charge_ := NVL(Freight_Price_List_Line_API.Get_Valid_Charge_Line(freight_price_list_no_,
                                                                                         line_total_weight_,
                                                                                         line_total_volume_,
                                                                                         planned_ship_date_,
                                                                                         freight_price_list_rec_.freight_map_id,
                                                                                         zone_id_)
                                                                                         , 0);

            IF (new_freight_charge_ IS NOT NULL) THEN
               IF (order_no_ IS NOT NULL) THEN
                  OPEN get_order_line_charges(delivery_terms_,
                                              freight_price_list_no_,
                                              zone_id_,
                                              planned_ship_date_,
                                              use_shipment_freight_charge_);
                  FETCH get_order_line_charges BULK COLLECT INTO charge_lines_;
                  CLOSE get_order_line_charges;
                  order_amount_ := Customer_Order_Line_API.Get_Base_Sale_Price_Total(order_no_,
                                                                                     freight_price_list_rec_.freight_map_id,
                                                                                     zone_id_,
                                                                                     freight_price_list_no_,
                                                                                     planned_ship_date_);
                  -- get the minimum adjusted_gross_weight or adjusted_volume for given freigh info
                  OPEN get_minimum_adj_info_order(use_shipment_freight_charge_,
                                                  planned_ship_date_,
                                                  zone_id_,
                                                  delivery_terms_,
                                                  freight_price_list_no_);
                  FETCH get_minimum_adj_info_order INTO min_weight_, min_volume_;
                  CLOSE get_minimum_adj_info_order;
               ELSIF (quotation_no_ IS NOT NULL) THEN
                  OPEN get_quote_line_charges(delivery_terms_,
                                              freight_price_list_no_,
                                              zone_id_,
                                              planned_ship_date_,
                                              picking_lead_time_);
                  FETCH get_quote_line_charges BULK COLLECT INTO charge_lines_;
                  CLOSE get_quote_line_charges;
                  order_amount_ := Order_Quotation_Line_API.Get_Base_Sale_Price_Total(quotation_no_,
                                                                                      freight_price_list_rec_.freight_map_id,
                                                                                      zone_id_,
                                                                                      freight_price_list_no_,
                                                                                      planned_ship_date_);
                  -- get the minimum adjusted_gross_weight or adjusted_volume for given freigh info
                  OPEN get_minimum_adj_info_quote(picking_lead_time_,
                                                  planned_ship_date_,
                                                  zone_id_,
                                                  delivery_terms_,
                                                  freight_price_list_no_);
                  FETCH get_minimum_adj_info_quote INTO min_weight_, min_volume_;
                  CLOSE get_minimum_adj_info_quote;
               END IF;

               -- Added ELSE part to do the calculation when its not fixed delivery freight as well
               -- If apply_fix_deliv_freight_ is SET and the lines are having a same freight price list number as header,
               -- Then we are only applying the fixed delivery freight.
               IF (apply_fix_deliv_freight_ = db_true_) AND (head_freight_price_list_no_ = freight_price_list_no_) THEN
                  IF (min_weight_ != 0) THEN
                     min_base_freight_charge_ := NVL(fix_deliv_freight_, 0) * (min_weight_ / lines_(i_).total_weight);
                  END IF;
                  IF (min_volume_ != 0) THEN
                     min_base_freight_charge_ := NVL(fix_deliv_freight_, 0) * (min_volume_ / lines_(i_).total_volume);
                  END IF;
                  -- select the rounding_factor which can display minimum freight charge
                  WHILE (NOT find_round_factor_ ) LOOP
                     IF (min_base_freight_charge_ != 0 AND (TRUNC(min_base_freight_charge_, rounding_factor_) = 0)) THEN
                        rounding_factor_ := rounding_factor_ + 1;
                     ELSE
                        find_round_factor_  := TRUE;
                     END IF;
                  END LOOP;
               ELSE
                  IF (min_weight_ != 0) THEN
                     min_base_freight_charge_ := NVL(new_freight_charge_, 0) * (min_weight_ / line_total_weight_);
                  END IF;
                  IF (min_volume_ != 0) THEN
                     min_base_freight_charge_ := NVL(new_freight_charge_, 0) * (min_volume_ / line_total_volume_);
                  END IF;
                  -- select the rounding_factor which can display minimum freight charge
                  WHILE (NOT find_round_factor_ ) LOOP
                     IF (min_base_freight_charge_ != 0 AND (TRUNC(min_base_freight_charge_, rounding_factor_) = 0)) THEN
                        rounding_factor_ := rounding_factor_ + 1;
                     ELSE
                        find_round_factor_  := TRUE;
                     END IF;
                  END LOOP;
               END IF;
               -- convert above base into sales price
               IF (charge_lines_.count > 0) THEN
                  FOR j_ IN charge_lines_.FIRST .. charge_lines_.LAST LOOP
                     IF ((line_total_volume_ IS NULL AND NVL(charge_lines_(j_).line_weight, 0) = 0 ) OR (line_total_volume_ IS NOT NULL AND NVL(charge_lines_(j_).line_volume, 0) = 0)) THEN
                        -- Go to next iteration in loop if line_weight/line_volume to be divided by is 0
                        CONTINUE;
                     END IF;
                     IF (apply_fix_deliv_freight_ = db_true_) AND (head_freight_price_list_no_ = freight_price_list_no_) THEN
                        IF line_total_volume_ IS NULL THEN
                           base_freight_charge_ := NVL(fix_deliv_freight_, 0) * (charge_lines_(j_).line_weight / lines_(i_).total_weight);
                           rounded_chg_sum_ := (ROUND(base_freight_charge_, rounding_factor_) * lines_(i_).total_weight) / charge_lines_(j_).line_weight ;
                        ELSE
                           base_freight_charge_ := NVL(fix_deliv_freight_, 0) * (charge_lines_(j_).line_volume / lines_(i_).total_volume);
                           rounded_chg_sum_ := (ROUND(base_freight_charge_, rounding_factor_) * lines_(i_).total_volume) / charge_lines_(j_).line_volume;
                        END IF;


                        IF (fix_deliv_freight_ != rounded_chg_sum_) THEN
                           base_freight_charge_ := ROUND(base_freight_charge_, rounding_factor_);
                        END IF;
                        charge_cost_ := base_freight_charge_;
                        base_freight_chg_sum_ := base_freight_chg_sum_ + base_freight_charge_;
                        IF (highest_freight_charge_ <= base_freight_charge_ ) THEN
                           highest_freight_charge_ := base_freight_charge_;
                           highest_chg_found_ := TRUE;
                        ELSE
                           highest_chg_found_ := FALSE;
                        END IF;
                     ELSE
                        IF (line_total_volume_ IS NULL) THEN
                           charge_weight_charge_uom_ := charge_lines_(j_).line_weight;
                           IF company_uom_ != charge_type_uom_ THEN
                              charge_weight_charge_uom_ := NVL(Iso_Unit_API.Get_Unit_Converted_Quantity(charge_lines_(j_).line_weight, company_uom_, charge_type_uom_), charge_lines_(j_).line_weight);
                           END IF;
                        ELSE
                           charge_volumn_charge_uom_ := charge_lines_(j_).line_volume;
                           IF company_uom_ != charge_type_uom_ THEN
                              charge_volumn_charge_uom_ := NVL(Iso_Unit_API.Get_Unit_Converted_Quantity(charge_lines_(j_).line_volume, company_uom_, charge_type_uom_), charge_lines_(j_).line_volume);
                           END IF;
                        END IF;
                        
                        -- Unit based tick can not get modified on the CO Line.
                        is_unit_based_      := Sales_Charge_Type_API.Get_Unit_Charge_Db(contract_, Freight_Price_List_Base_API.Get_Charge_Type(freight_price_list_no_));
                        IF is_unit_based_ = db_false_ THEN
                           freight_charge_amount_  := new_freight_charge_;
                           rounding_needed_ := TRUE;
                           IF (line_total_volume_ IS NULL) THEN
                              base_freight_charge_ := (new_freight_charge_ / line_total_weight_) * charge_weight_charge_uom_;
                              -- added rounded_chg_sum_ to check if the rounded values sum give the total value
                              rounded_chg_sum_ := (ROUND(base_freight_charge_, rounding_factor_) * line_total_weight_) / charge_weight_charge_uom_ ;
                           ELSE
                              base_freight_charge_ := (new_freight_charge_ / line_total_volume_) * charge_volumn_charge_uom_;
                              -- added rounded_chg_sum_ to check if the rounded values sum give the total value
                              rounded_chg_sum_ := (ROUND(base_freight_charge_, rounding_factor_) * line_total_volume_) / charge_volumn_charge_uom_;
                           END IF;
                           -- checked if the total rounded value gives the original total of base_freight_charge_ and rounded the value
                           IF (new_freight_charge_ != rounded_chg_sum_) THEN
                              base_freight_charge_ := ROUND(base_freight_charge_, rounding_factor_);
                           END IF;

                           charge_cost_ := base_freight_charge_;
                           -- If the total amount is larger than the freight free amount, charge amount becomes 0.
                           IF ( (freight_free_amount_ IS NOT NULL) AND (order_amount_ >= freight_free_amount_) ) THEN
                              base_freight_charge_ := 0;
                           END IF;

                           new_qty_ := 1;
                           update_chg_qty_ := TRUE;
                        ELSE
                           -- Unit based charge type ..
                           -- If minimum freight amount is larger than the total charge amount charged for qty.
                           -- new_freight_charge_ becoes minimum amount for the price list.
                           IF (line_total_volume_ IS NULL) THEN
                              tmp_charged_tot_wght_vol_ := line_total_weight_;
                              tmp_charge_weight_vol_    := charge_weight_charge_uom_;
                           ELSE
                              tmp_charged_tot_wght_vol_   := line_total_volume_;
                              tmp_charge_weight_vol_      := charge_volumn_charge_uom_;
                           END IF;

                           IF (NVL(min_freight_amount_,0) > (new_freight_charge_ * tmp_charged_tot_wght_vol_)) THEN
                              is_unit_based_      := db_false_;
                              freight_charge_amount_     := min_freight_amount_;
                              rounding_needed_    := TRUE;
                              -- Since min freight amount is a non-unit based charge devide it among lines.
                              base_freight_charge_ := (min_freight_amount_ / tmp_charged_tot_wght_vol_) * tmp_charge_weight_vol_;
                              rounded_chg_sum_ := (ROUND(base_freight_charge_, rounding_factor_)) *  tmp_charged_tot_wght_vol_ / tmp_charge_weight_vol_;

                              IF (new_freight_charge_ != rounded_chg_sum_) THEN
                                 base_freight_charge_ := ROUND(base_freight_charge_, rounding_factor_);
                              END IF;
                              IF (order_no_ IS NOT NULL) THEN
                                 charged_qty_ := Customer_Order_Charge_API.Get_Charged_Qty(order_no_, charge_lines_(j_).sequence_no);
                              ELSIF (quotation_no_ IS NOT NULL) THEN
                                 charged_qty_ := Order_Quotation_Charge_API.Get_Charged_Qty(quotation_no_, charge_lines_(j_).sequence_no);
                              END IF;
                              IF ( charged_qty_ != 1) THEN
                                 new_qty_ := 1;
                                 update_chg_qty_ := TRUE;
                              END IF;
                           ELSE
                              rounding_needed_     := FALSE;
                              base_freight_charge_ := new_freight_charge_;
                              new_qty_ := tmp_charge_weight_vol_;
                              update_chg_qty_ := TRUE;
                           END IF;

                           charge_cost_ := base_freight_charge_;
                           IF ( (freight_free_amount_ IS NOT NULL) AND (order_amount_ >= freight_free_amount_) ) THEN
                              base_freight_charge_ := 0;
                           END IF;
                        END IF;
                        IF (highest_freight_charge_ <= base_freight_charge_ ) THEN
                           highest_freight_charge_ := base_freight_charge_;
                           highest_chg_found_ := TRUE;
                        ELSE
                           highest_chg_found_ := FALSE;
                        END IF;
                        base_freight_chg_sum_ := base_freight_chg_sum_ + base_freight_charge_;
                     END IF;

                     -- convert above base into sales price
                     Customer_Order_Pricing_API.Get_Sales_Price_In_Currency(freight_charge_, currency_rate_,
                                                                            NVL(customer_no_pay_, customer_no_),
                                                                            contract_, currency_code_,
                                                                            base_freight_charge_, currency_rate_type_);
                     --update charge qty
                     Client_Sys.Clear_Attr(freight_attr_);
                     IF (update_chg_qty_ ) THEN
                        Client_SYS.Add_To_Attr('CHARGED_QTY', new_qty_, freight_attr_);
                        Client_SYS.Add_To_Attr('UNIT_CHARGE_DB', is_unit_based_ , freight_attr_);
                        update_chg_qty_ := FALSE;
                     END IF;
                     IF (apply_fix_deliv_freight_ = db_true_) AND (head_freight_price_list_no_ = freight_price_list_no_) THEN
                        Client_SYS.Add_To_Attr('CHARGED_QTY', 1, freight_attr_);
                     END IF;
                     Client_SYS.Add_To_Attr('CHARGE_AMOUNT',             freight_charge_,      freight_attr_);
                     Client_SYS.Add_To_Attr('CHARGE_AMOUNT_INCL_TAX',    freight_charge_,      freight_attr_);
                     Client_SYS.Add_To_Attr('BASE_CHARGE_AMOUNT',        base_freight_charge_, freight_attr_);
                     Client_SYS.Add_To_Attr('BASE_CHARGE_AMT_INCL_TAX',  base_freight_charge_, freight_attr_);
                     Client_SYS.Add_To_Attr('CHARGE_COST',               charge_cost_,         freight_attr_);
                     Client_SYS.Add_To_Attr('SERVER_DATA_CHANGE',        db_true_,             freight_attr_);
                     Client_SYS.Add_To_Attr('FREIGHT_CHARGES_RECALCULATED',db_true_,           freight_attr_);
                     IF (order_no_ IS NOT NULL) THEN
                        IF (collect_freight_charge_ = db_true_) THEN
                           Client_SYS.Add_To_Attr('COLLECT', Collect_API.Decode('COLLECT'), freight_attr_);
                        ELSE
                           Client_SYS.Add_To_Attr('COLLECT', Collect_API.Decode('INVOICE'), freight_attr_);
                        END IF;
                        Customer_Order_Charge_API.Modify(order_no_, charge_lines_(j_).sequence_no, freight_attr_);
                     ELSIF (quotation_no_ IS NOT NULL) THEN
                        Order_Quotation_Charge_API.Modify(quotation_no_, charge_lines_(j_).sequence_no, freight_attr_);
                     END IF;
                     consolidated_ := TRUE;
                     -- get the charge line seq no to update the charge line with variance to avoid rounding issue.
                     IF (highest_chg_found_) THEN
                        highest_chg_line_seq_ := charge_lines_(j_).sequence_no;
                     END IF;
                  END LOOP;
               END IF;
            END IF;
            IF NOT ((NVL(demand_code_, Database_SYS.string_null_) = 'IPD') AND (intersite_same_company_)) THEN
               -- Added ELSE part to do the rounding correction when the lines are not fixed delivery freight as well.
               IF (apply_fix_deliv_freight_ = db_true_) AND (head_freight_price_list_no_ = freight_price_list_no_) THEN
                  IF (fix_deliv_freight_ != base_freight_chg_sum_ ) THEN
                     charge_variance_ := fix_deliv_freight_ - base_freight_chg_sum_;
                     adj_base_freight_chg_ := highest_freight_charge_ + charge_variance_;
                     Customer_Order_Pricing_API.Get_Sales_Price_In_Currency(freight_charge_, currency_rate_,
                                                                            NVL(customer_no_pay_, customer_no_),
                                                                            contract_, currency_code_,
                                                                            adj_base_freight_chg_, currency_rate_type_);
                     Client_Sys.Clear_Attr(charge_attr_);
                     Client_SYS.Add_To_Attr('BASE_CHARGE_AMOUNT',       adj_base_freight_chg_, charge_attr_);
                     Client_SYS.Add_To_Attr('BASE_CHARGE_AMT_INCL_TAX', adj_base_freight_chg_, charge_attr_);
                     Client_SYS.Add_To_Attr('CHARGE_AMOUNT',            freight_charge_,       charge_attr_);
                     Client_SYS.Add_To_Attr('CHARGE_AMOUNT_INCL_TAX',   freight_charge_,       charge_attr_);
                     Client_SYS.Add_To_Attr('CHARGE_COST',              adj_base_freight_chg_, charge_attr_);
                     Client_SYS.Add_To_Attr('FREIGHT_CHARGES_RECALCULATED',db_true_,           charge_attr_);
                     IF (order_no_ IS NOT NULL) THEN
                        Customer_Order_Charge_API.Modify(order_no_, highest_chg_line_seq_, charge_attr_);
                     ELSIF (quotation_no_ IS NOT NULL) THEN
                        Order_Quotation_Charge_API.Modify(quotation_no_, highest_chg_line_seq_, charge_attr_);
                     END IF;
                  END IF;
               ELSE
                  IF ((new_freight_charge_ != base_freight_chg_sum_ ) AND (rounding_needed_) AND NOT(base_freight_charge_ = 0)) THEN
                     charge_variance_ := freight_charge_amount_ - base_freight_chg_sum_;
                     adj_base_freight_chg_ := highest_freight_charge_ + charge_variance_;
                     Customer_Order_Pricing_API.Get_Sales_Price_In_Currency(freight_charge_, currency_rate_,
                                                                            NVL(customer_no_pay_, customer_no_),
                                                                            contract_, currency_code_,
                                                                            adj_base_freight_chg_, currency_rate_type_);
                     Client_Sys.Clear_Attr(charge_attr_);
                     Client_SYS.Add_To_Attr('BASE_CHARGE_AMOUNT',       adj_base_freight_chg_, charge_attr_);
                     Client_SYS.Add_To_Attr('BASE_CHARGE_AMT_INCL_TAX', adj_base_freight_chg_, charge_attr_);
                     Client_SYS.Add_To_Attr('CHARGE_AMOUNT',            freight_charge_,       charge_attr_);
                     Client_SYS.Add_To_Attr('CHARGE_AMOUNT_INCL_TAX',   freight_charge_,       charge_attr_);
                     Client_SYS.Add_To_Attr('CHARGE_COST',              adj_base_freight_chg_, charge_attr_);
                     Client_SYS.Add_To_Attr('FREIGHT_CHARGES_RECALCULATED',db_true_,           charge_attr_);
                     IF (order_no_ IS NOT NULL) THEN
                        Customer_Order_Charge_API.Modify(order_no_, highest_chg_line_seq_, charge_attr_);
                     ELSIF (quotation_no_ IS NOT NULL) THEN
                        Order_Quotation_Charge_API.Modify(quotation_no_, highest_chg_line_seq_, charge_attr_);
                     END IF;
                  END IF;
               END IF;
            END IF;
         END IF;
      END LOOP;

      -- Insert history
      IF consolidated_ THEN
         IF (order_no_ IS NOT NULL) THEN
             Customer_Order_History_API.New(order_no_, Language_SYS.Translate_Constant(lu_name_, 'FREGHTCONSOL: Freight charges have been consolidated.'));
         ELSIF (quotation_no_ IS NOT NULL) THEN
            Order_Quotation_History_API.New(quotation_no_, Language_SYS.Translate_Constant(lu_name_, 'FREGHTCONSOL: Freight charges have been consolidated.'));
         END IF;
      END IF;

      -- Remove charge lines with 0 amounts and 0 cost
      Delete_Zero_Charge_Lines___(order_no_, quotation_no_);

      -- Update freight free checkbox for lines with 0 amounts
      IF (order_no_ IS NOT NULL) THEN
         Customer_Order_API.Update_Freight_Free_On_Lines(order_no_);
      ELSIF (quotation_no_ IS NOT NULL) THEN
         Order_Quotation_API.Update_Freight_Free_On_Lines(quotation_no_);
      END IF;
   END IF;

END Consolidate_Grouped_Charges;


-- Remove_Order_Promo_Charges
--   Remove all charges of the sales promotion type for a specific order.
PROCEDURE Remove_Order_Promo_Charges (
   order_no_ IN VARCHAR2 )
IS
   CURSOR get_all_promotion_charges IS
      SELECT sequence_no
      FROM   customer_order_charge_tab coc, sales_charge_type_tab sct
      WHERE  coc.order_no = order_no_
      AND    coc.charge_type = sct.charge_type
      AND    coc.contract = sct.contract
      AND    sct.sales_chg_type_category = 'PROMOTION';
BEGIN

   FOR chargerec_ IN get_all_promotion_charges LOOP
      -- Note that last parameter was set to true to indicate that we allow to delete the promotion charges.
      Customer_Order_Charge_API.Remove(order_no_, chargerec_.sequence_no, TRUE);
   END LOOP;

END Remove_Order_Promo_Charges;


-- Remove_Quote_Promo_Charges
--   Remove all quotation charges of the sales promotion type for a specified quotation.
PROCEDURE Remove_Quote_Promo_Charges (
   quotation_no_ IN VARCHAR2 )
IS
   CURSOR get_all_promotion_charges IS
      SELECT quotation_charge_no
      FROM   order_quotation_charge_tab qct, sales_charge_type_tab sct
      WHERE  qct.quotation_no = quotation_no_
      AND    qct.charge_type = sct.charge_type
      AND    qct.contract = sct.contract
      AND    sct.sales_chg_type_category = 'PROMOTION';
BEGIN

   FOR chargerec_ IN get_all_promotion_charges LOOP
      -- Note that last parameter was set to true to indicate that we allow to delete the promotion charges.
      Order_Quotation_Charge_API.Remove(quotation_no_, chargerec_.quotation_charge_no, TRUE);
   END LOOP;

END Remove_Quote_Promo_Charges;


-- Exist_Charge_For_This_Price
--   Return the charge sequence no if there already exist a line in the specific order
--   with this specific charge type and charge price or charge price incl tax.
--   Used in the Sales Promotion Calculations.
@UncheckedAccess
FUNCTION Exist_Charge_For_This_Price (
   order_no_              IN VARCHAR2,
   charge_type_           IN VARCHAR2,
   charge_price_          IN NUMBER,
   charge_price_incl_tax_ IN NUMBER,
   campaign_id_           IN NUMBER,
   deal_id_               IN NUMBER) RETURN NUMBER
IS
   charge_sequence_no_   NUMBER;
   CURSOR Check_Charge_Exist_This_Price IS
      SELECT sequence_no
      FROM   CUSTOMER_ORDER_CHARGE_TAB
      WHERE order_no = order_no_
      AND   charge_type = charge_type_
      AND   campaign_id = campaign_id_
      AND   deal_id     = deal_id_
      AND   (charge_amount = charge_price_ OR charge_amount_incl_tax = charge_price_incl_tax_);
BEGIN

   OPEN  Check_Charge_Exist_This_Price;
   FETCH Check_Charge_Exist_This_Price INTO charge_sequence_no_;
   CLOSE Check_Charge_Exist_This_Price;
   RETURN charge_sequence_no_;

END Exist_Charge_For_This_Price;




-- Get_Matched_Quote_Charge_No
--   Return the quotation charge no if there already exist a charge line in the specific quotation
--   with this specific charge type and charge price or charge price incl tax.
--   Used in the Sales Promotion Calculations.
@UncheckedAccess
FUNCTION Get_Matched_Quote_Charge_No (
   quotation_no_          IN VARCHAR2,
   charge_type_           IN VARCHAR2,
   charge_price_          IN NUMBER,
   charge_price_incl_tax_ IN NUMBER,
   campaign_id_           IN NUMBER,
   deal_id_               IN NUMBER) RETURN NUMBER
IS
   charge_sequence_no_   NUMBER;

   CURSOR charge_exist IS
      SELECT quotation_charge_no
      FROM   order_quotation_charge_tab
      WHERE quotation_no = quotation_no_
      AND   charge_type = charge_type_
      AND   campaign_id = campaign_id_
      AND   deal_id     = deal_id_
      AND   (charge_amount = charge_price_ OR charge_amount_incl_tax = charge_price_incl_tax_);
BEGIN

   OPEN  charge_exist;
   FETCH charge_exist INTO charge_sequence_no_;
   CLOSE charge_exist;
   RETURN charge_sequence_no_;

END Get_Matched_Quote_Charge_No;




-- Chk_Conn_Freight_Or_Prom_Exist
--   Return 1 if there exists a freight charge line or sales promotion charge line connected to the
--   given customer order line. Otherwise returns 0.
@UncheckedAccess
FUNCTION Chk_Conn_Freight_Or_Prom_Exist (
   order_no_         IN VARCHAR2,
   line_no_          IN VARCHAR2,
   rel_no_           IN VARCHAR2,
   line_item_no_     IN NUMBER) RETURN NUMBER
IS
   temp_ NUMBER:= 0;
   CURSOR get_conn_freight IS
      SELECT 1
        FROM customer_order_charge_tab coc, sales_charge_type_tab sct
       WHERE coc.order_no                = order_no_
         AND coc.line_no                 = line_no_
         AND rel_no                      = rel_no_
         AND line_item_no                = line_item_no_
         AND coc.charge_type             = sct.charge_type
         AND sct.sales_chg_type_category = 'FREIGHT';

BEGIN
   OPEN get_conn_freight;
   FETCH get_conn_freight INTO temp_;
   IF (get_conn_freight%NOTFOUND) THEN
      temp_ := 0;
   END IF;
   CLOSE get_conn_freight;
   IF (temp_ = 0) THEN
      IF (Sales_Promotion_Util_API.Check_Promo_Exist_For_Ord_Line(order_no_, line_no_, rel_no_, line_item_no_)) THEN
         temp_ := 1;
      END IF;
   END IF;
   RETURN temp_;
END Chk_Conn_Freight_Or_Prom_Exist;

-- Modified method to be applicable for both CO line connected and not connected percentage charges
-- Recalc_Percentage_Charge_Taxes
--   Recalculate taxes for all percentage charges not connected to CO lines
@UncheckedAccess
PROCEDURE Recalc_Percentage_Charge_Taxes (
   order_no_          IN VARCHAR2,
   line_no_           IN VARCHAR2,
   tax_from_defaults_ IN BOOLEAN)   
IS
   from_defaults_ BOOLEAN;
   
   CURSOR get_charge IS
      SELECT contract, sequence_no, line_no
      FROM   CUSTOMER_ORDER_CHARGE_TAB
      WHERE  order_no = order_no_
      AND    charge IS NOT NULL
      AND    invoiced_qty = 0;
BEGIN
   FOR rec_ IN get_charge LOOP
      IF (rec_.line_no IS NULL OR line_no_ != NVL(rec_.line_no, ' ')) THEN
         -- If the charge line is not connected to the order line being updated, only do a recalulation without calling the external tax service.
         from_defaults_ := FALSE;
      ELSE
         from_defaults_ := tax_from_defaults_;
      END IF;
      
      Recalculate_Tax_Lines___(rec_.contract, order_no_, rec_.sequence_no, from_defaults_, NULL);
   END LOOP;
END Recalc_Percentage_Charge_Taxes;




