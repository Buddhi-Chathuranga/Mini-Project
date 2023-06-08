-----------------------------------------------------------------------------
--
--  Logical unit: ShipmentFreightCharge
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  201130  Aabalk  SCZ-12655, Modified Modify_Shipment_Charges___() to use minimum freight charge amount when modifying shipment freight charges.
--  201126  Aabalk  SCZ-12654, Modified Calculate_Shipment_Charges() to recalculate Collect freight charges if the shipment is not closed.
--  200701  Aabalk  Bug 154106 (SCZ-10226), Modified Calculate_Shipment_Charges() to recalculate charges and prices only when charge is not a collect charge.
--  190717  JaBalk  SCUXXW4-18338, Modified Update___ to fetch default tax codes when charge type is changed.
--  190621  UdGnlk  Bug 148896 (SCZ-5491), Modified Modify_Shipment_Charges___() and Get_Freight_Charge_Attr___() to convert unit charge quantity, if Unit of Measures of company and charge type is different.  
--  180426  DiKuLk  Bug 140770, Modified Calculate_Shipment_Charges() to stop removing already invoiced charge lines in partially delivered state.
--  180209  KoDelk  STRSC-15901, When creating tax lines for invoice use the current currency rate rather than using the source line currency rate.
--  180119  CKumlk  STRSC-15930, Modified Calculate_Shipment_Charges() by changing Get_State() to Get_Objstate(). 
--  171024  MalLlk  STRSC-12754, Removed the methods Get_Line_Total_Base_Amount().
--  170627  MeAblk  Bug 135685, Modified Calculate_Shipment_Charges(), New_Shipment_Charge___(), Get_Freight_Charge_Attr___() to set the tax code and tax liability from CO charge line
--  170627          when creating shipment freight automatically. This is done to set the correct tax code and tax liability in a direct delivery which is related to internal customer.
--  170104  MaIklk  Moved Calculate_Freight_Charges() and Calculate_Shipment_Charges() from shipment to this utility.
--  160725  RoJalk  LIM-8142, Replaced Shipment_Line_API.Connected_Lines_Exist with Shipment_API.Connected_Lines_Exist.
--  160720  MalLlk  FINHR-1328, Added methods Get_Line_Total_Base_Amount and Get_Line_Address_Info.
--  160714  MAHPLK  FINHR-1330, Changed Calculate_Prices, Update_Currency public methods to implementation methods.
--  160714          Added Recalculate_Tax_Lines___, Add_Transaction_Tax_Info___, Update_Line___,  Fetch_Tax_Line_Param, Get_Tax_Info, 
--  160714          Modify_Tax_Info, Validate_Source_Pkg_Info, Get_Price_Total, Get_Price_Incl_Tax_Total, Get_Total_Tax_Amount_Curr, 
--  160714          Get_Total_Tax_Amount_Base, Get_Total_Charged_Amount, Get_Total_Charge_Amnt_Incl_Tax, Get_Total_Base_Amnt_Incl_Tax, 
--  160714          Get_Total_Base_Charged_Amount. Modified Modify_Prices___, Insert___, Update___, Check_Update___, Remove__, 
--  160714          Remove, Calculate_Shipment_Charges. Deleted Validate_Fee_Code___, Get_Total_Charge_Tax_Pct.
--  160509  MaRalk  LIM-6531, Removed unwanted variables order_no, line_no etc from Get_Freight_Charge_Attr___.
--  160509          Modified methods New_Shipment_Charge___, Modify_Shipment_Charges___, Validate_Fee_Code___, Check_Update___, 
--  160509          Update___, Update_Fix_Del_Freight_Charge, Update_Currency and Calculate_Prices to reflect 
--  160509          moving freight related columns from Shipment_Tab to order-Shipment_Freight_Tab.
--  160426  RoJalk  LIM-6631, Modified Modify_Shipment_Charges___ - get_count_freight_free cursor to include NVL handling.
--  160411  MaIklk  LIM-6957, Renamed Ship_Date to Planned_Ship_Date in Shipment_tab.
--  160215  MaRalk  LIM-6245, Modified Modify_Shipment_Charges___, Insert___, Recalculate_Freight_Charges
--  160215          and Update_Fix_Del_Freight_Charge to avoid direct accesssing of shipment tables.
--  160215  RoJalk  LIM-4652, Added the method Post_Delete_Ship_Line.
--  160208  MaIklk  LIM-4172, Added Process_Freight_On_Ship_Update().
--  160202  MaRalk  LIM-6114, Replaced Shipment_API.Get_Ship_Addr_No usages with Shipment_API.Get_Receiver_Addr_Id
--  160202          in Insert___. Replaced usages like shipment_rec_.ship_addr_no with shipment_rec_.receiver_addr_id
--  160202          in Get_Freight_Charge_Attr___, Validate_Fee_Code___, Insert___, Update___, Check_Update___ methods. 
--  160118  IsSalk  FINHR-657, Used FndBoolean in taxable attribute in Sales Charge Type.
--  160111  IsSalk  FINHR-581, Renamed column FEE_CODE to TAX_CODE in SALES_CHARGE_TYPE_TAB.
--  151229  MaIklk  LIM-5721, Added Remove_Shipment_Charges().
--  151202  RoJalk  LIM-5178, Rename ORDER_NO, LINE_NO, REL_NO, LINE_ITEM_NO to SOURCE_REF1,
--  151202          SOURCE_REF2, SOURCE_REF3, SOURCE_REF4 in ShipmentLine and ShipmentLineHandlUnit. 
--  151110  MaIklk  LIM-4059, Renamed deilver_to_customer_no to receiver_id and renamed address fields to sender_xxx and receiver_xxx of shipment table.
--  151110  RoJalk  LIM-4610, Rename ShipmentOrderLine LU to ShipmentLine.
--  151103  SURBLK  FINHR-317, Modified fee_code_changed_ in to tax_code_changed_.
--  150214  ShKolk  EAP-804, Modified Calculate_Shipment_Charges() to call Consolidate_Grouped_Charges() instead of Calc_Consolidate_Charges() to consolidate only the affected group.
--  141212  Hecolk  PRFI-3853, Corrected in Update_Currency and Modify_Prices___
--  141203  Hiralk  PRFI-3850, Modified Update___() to avoid to add all default tax lines when update is calling after changing the tax lines.
--  130718  MaEelk  Modified Get_freight_Charge_Attr___ to fetch the weight and volume from the shipment.
--  130718          Modified Modify_Shipment_Charges___ to fetch the weight and volume from the shipment and also fetch the customer order line's line_total_qty when needed.
--  130718          Modified Calculate_Shipment_Charges and replaced order_line_rec_.adjusted_weight_net with order_line_rec_.line_total_qty.
--  130129  RuLiLk  Bug 106274 Modified method Calculate_Shipment_Charges(). Freight Charge lines should be consolidated, when a charge line is removed.
--  120830  HimRlk  Modified Modify_Fee_Code() to calculate prices after modifying tax lines.
--  120828  JeeJlk  Added methods Modify_Prices___ and Calculate_Prices.
--  120822  JeeJlk  Added two new columns charge_amount_incl_tax and base_charge_amount_incl_tax.
--  110909  MaMalk  Added method Recalculate_Freight_Charges.
--  110713  ChJalk  Added user_allowed_site filter to the base view.
--  110524  MaMalk  Modified Validate_Fee_Code___ to fetch the tax code for the supply country from the tax class if no entry found for the delivery country.
--  110411  MaMalk  Modified Get_Freight_Charge_Attr___ to add delivery type to the attribute string.
--  110314  MaMalk  Added attribute Delivery_Type.
--  110314  MaMalk  Modified Update___ to claculate the taxes correctly when tax fetching attributes are changed. 
--  110309  MaMalk  Modified several methods to calculate the taxes correctly and added Get_Total_Charge_Tax_Pct
--  110309          to calculate the total tax percentage for a charge line.
--  110307  MaMalk  Added new columns Tax_Class_Id and Tax_Liability.
--  110208  MaMalk  Replaced some of the method calls to Customer_Info_Vat_API with Customer_Tax_Info_API.
--  100809  ShKolk  Modified Get_Freight_Charge_Attr___() and Modify_Shipment_Charges___(), removed fee_code from attr_.
--  100430  ShKolk  Added validations for taxes.
--  100426  JeLise  Renamed zone_definition_id to freight_map_id.
--  100312  ShKolk  Modified Get_Freight_Charge_Attr___ to fetch correct vat_db and fee_code.
--  091019  ShKolk  Added new column vat.
--  091007  ShKolk  Modified Modify_Shipment_Charges___ to handle freight free charges.
--  090828  MaJalk  Added error message UPDATENOTALLOWED to Unpack_Check_Update___.
--  090813  HimRlk  Modified Unpack_Check_Insert___ and Unpack_Check_Update___ to give an error message if sales_chg_type_category_db_ is not equal to Freight.
--  090812  ShKolk  Added function call to Site_Discom_Info_API.Get_Shipment_Freight_Charge_Db() to validate the value.
--  090807  ShKolk  Added parameter zone_definition_id to function call Freight_Price_List_Line_API.Get_Valid_Charge_Line() and rearranged parameters.
--  090710  ShKolk  Added Update_Currency() to re-calculate freight charges when currency is changed in Shipment tab.
--  090630  ShKolk  Modified Modify_Shipment_Charges___() to correct calculations of freight free lines.
--  090602  ShKolk  Modified Calculate_Shipment_Charges() to delete all freight charge lines conected to the coline.
--  090507  ShKolk  Modified New_Shipment_Charge___(), Modify_Shipment_Charges___() to fetch correct charges according
--  090507          to the freight basis.
--  090506  ShKolk  Modified New_Shipment_Charge___(), Modify_Shipment_Charges___() to check
--  090506          fix_delivery_freight before creating free charges.
--  090505  ShKolk  Modified cursor get_charge_data of Calculate_Shipment_Charges().
--  090422  ShKolk  Added Update_Fix_Del_Freight_Charge() and renamed Add_Shipment_Charges() to Calculate_Shipment_Charges.
--  090420  ShKolk  Removed unused variables and modified Modify_Shipment_Charges___().
--  090408  ShKolk  Added New_Shipment_Charge___(), modified Get_Freight_Charge_Attr___().
--  090309  ShKolk  Modified Add_Shipment_Charges() to modify existing charge line.
--  090305  ShKolk  Changed method call Fetch_Zone_For_Single_Occ_Addr to Fetch_Zone_For_Addr_Details.
--  090301  ShKolk  Added Add_Shipment_Charges().
--  090226  ShKolk  Added New().
--  090226  ShKolk  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

string_null_         CONSTANT VARCHAR2(15) := Database_SYS.string_null_;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Check_Tax_Calc_Struct_Ref___ (
   newrec_ IN OUT NOCOPY shipment_freight_charge_tab%ROWTYPE )
IS
   company_    VARCHAR2(20);
BEGIN
   company_ := Site_API.Get_Company(newrec_.contract);
   Tax_Calc_Structure_API.Validate_Tax_Structure_State(company_, newrec_.tax_calc_structure_id);
END Check_Tax_Calc_Struct_Ref___;


PROCEDURE Get_Freight_Charge_Attr___ (
   attr_                  IN OUT VARCHAR2,
   shipment_id_           IN NUMBER,
   freight_map_id_        IN VARCHAR2,
   zone_id_               IN VARCHAR2,
   freight_price_list_no_ IN VARCHAR2,
   order_no_              IN VARCHAR2,
   line_no_               IN VARCHAR2,
   rel_no_                IN VARCHAR2,
   line_item_no_          IN NUMBER )
IS
   shipment_rec_                 Shipment_API.Public_Rec;
   customer_order_rec_           Customer_Order_API.Public_Rec;
   shipment_freight_rec_         Shipment_Freight_API.Public_Rec; 
   charge_type_rec_              Sales_Charge_Type_API.Public_Rec;
   freight_price_list_rec_       Freight_Price_List_API.Public_Rec;
   contract_                     SITE_TAB.contract%TYPE;
   currency_code_                ISO_CURRENCY_TAB.currency_code%TYPE;
   customer_no_                  CUSTOMER_INFO_ADDRESS_TAB.customer_id%TYPE;
   charge_type_                  SALES_CHARGE_TYPE_TAB.charge_type%TYPE;
   price_currency_code_          ISO_CURRENCY_TAB.currency_code%TYPE;
   freight_basis_                VARCHAR2(100);
   is_unit_charge_               VARCHAR2(5);
   currency_rate_type_           VARCHAR2(10);
   company_                      VARCHAR2(20);
   line_total_volume_            NUMBER;
   line_total_weight_            NUMBER;
   temp_line_total_weight_       NUMBER;
   temp_line_total_volume_       NUMBER;
   qty_                          NUMBER;
   min_freight_amount_           NUMBER;
   base_charge_amt_              NUMBER;
   charge_amt_                   NUMBER;
   currency_rate_                NUMBER;
   charge_cost_                  NUMBER;
   proceed_with_charge_fetching_ BOOLEAN := FALSE;
   price_effectivity_date_       DATE;
   company_invent_info_rec_      Company_Invent_Info_API.Public_Rec;
   demand_code_db_               VARCHAR2(20);
   
BEGIN

   shipment_rec_   := Shipment_API.Get(shipment_id_);
   shipment_freight_rec_ := Shipment_Freight_API.Get(shipment_id_);
   
   contract_       := shipment_rec_.contract;
   customer_no_    := shipment_rec_.receiver_id;
   company_        := Site_API.Get_Company(contract_);
   price_effectivity_date_ := NVL(shipment_rec_.planned_ship_date, Site_API.Get_Site_Date(contract_));
   
   company_invent_info_rec_ := Company_Invent_Info_API.Get(company_);
   line_total_weight_ := Shipment_API.Get_Operational_Gross_Weight(shipment_id_, company_invent_info_rec_.uom_for_weight,'TRUE');
   line_total_volume_ := Shipment_API.Get_Operational_Volume(shipment_id_,company_invent_info_rec_.uom_for_volume);
   
   freight_price_list_rec_ := Freight_Price_List_API.Get(freight_price_list_no_);
   charge_type_            := freight_price_list_rec_.charge_type;
   freight_basis_          := freight_price_list_rec_.freight_basis;
   min_freight_amount_     := Freight_Price_List_Zone_API.Get_Min_Freight_Amount(freight_price_list_no_,
                                                                                 freight_map_id_,
                                                                                 zone_id_);
   price_currency_code_    := Company_Finance_API.Get_Currency_Code(freight_price_list_rec_.company);
   
   demand_code_db_         := Customer_Order_Line_API.Get_Demand_Code_Db(order_no_, line_no_, rel_no_, line_item_no_);
   customer_order_rec_     := Customer_Order_API.Get(order_no_);
     
   currency_code_          := shipment_freight_rec_.currency_code;
   charge_type_rec_        := Sales_Charge_Type_API.Get(contract_, charge_type_);

   -- for non unit based charges the fixed freight charge amount is for the total co line
   -- This changes if it is a unit based, then it becomes weight or volume.
   IF (NVL(NVL(line_total_weight_, line_total_volume_),0) > 0) THEN
      qty_ := 1;
   ELSE
      qty_ := 0;
   END IF;

   -- line_total_weight_ and line_total_volume_ are already adjusted with the freight factor.
   IF (freight_basis_ = 'WEIGHT_BASED') THEN
      temp_line_total_volume_ := NULL;
      temp_line_total_weight_ := line_total_weight_;
      IF (charge_type_rec_.unit_charge = 'TRUE' AND NVL(line_total_weight_,0) > 0) THEN
         qty_ := line_total_weight_;
         IF (charge_type_rec_.sales_unit_meas != company_invent_info_rec_.uom_for_weight) THEN
            qty_ := NVL(Iso_Unit_API.Get_Unit_Converted_Quantity(qty_, company_invent_info_rec_.uom_for_weight, charge_type_rec_.sales_unit_meas), qty_); 
         END IF;
      END IF;
      -- To proceed with a weight based price list the adjusted weight is mandatory.
      IF (line_total_weight_ IS NOT NULL) THEN
         proceed_with_charge_fetching_ := TRUE;
      END IF;
   ELSE
      temp_line_total_weight_ := NULL;
      temp_line_total_volume_ := line_total_volume_;
      IF (charge_type_rec_.unit_charge = 'TRUE' AND NVL(line_total_volume_,0) > 0) THEN
         qty_ := line_total_volume_;
         IF (charge_type_rec_.sales_unit_meas != company_invent_info_rec_.uom_for_volume) THEN
            qty_ := NVL(Iso_Unit_API.Get_Unit_Converted_Quantity(qty_, company_invent_info_rec_.uom_for_volume, charge_type_rec_.sales_unit_meas), qty_); 
         END IF;
      END IF;
      -- To proceed with a volume based price list the adjusted volume is mandatory.
      IF (line_total_volume_ IS NOT NULL) THEN
         proceed_with_charge_fetching_ := TRUE;
      END IF;
   END IF;

   IF (proceed_with_charge_fetching_) THEN
      is_unit_charge_ := charge_type_rec_.unit_charge;

      base_charge_amt_ := Freight_Price_List_Line_API.Get_Valid_Charge_Line(freight_price_list_no_,
                                                                            temp_line_total_weight_,
                                                                            temp_line_total_volume_,
                                                                            price_effectivity_date_,
                                                                            freight_map_id_,
                                                                            zone_id_);

      IF (base_charge_amt_ IS NOT NULL) THEN
         -- IF minimum freight amount is larger than the total charge amount on the charge line, charge amount becomes fixed and min_freight_amount_.
         IF (NVL(min_freight_amount_,0) > (base_charge_amt_ * qty_)) THEN
            IF is_unit_charge_ != 'FALSE' THEN
               base_charge_amt_ := min_freight_amount_;
            END IF;
            -- Charged qty is 1 because now this is a fixed amount.
            qty_     := 1;
         END IF;

         charge_cost_ := base_charge_amt_;

         -- Fixed Delivery Freight charge is available
         IF shipment_freight_rec_.apply_fix_deliv_freight = 'TRUE' THEN
            base_charge_amt_ := shipment_freight_rec_.fix_deliv_freight;
            qty_ := 1;
            charge_cost_ := base_charge_amt_;
         END IF;
         IF (price_currency_code_ != currency_code_) THEN
            IF (demand_code_db_ = 'IPD') THEN
               -- convert above base into sales price
               Customer_Order_Pricing_API.Get_Sales_Price_In_Currency(charge_amt_, currency_rate_, NVL(customer_order_rec_.customer_no_pay, customer_order_rec_.customer_no),
                                                                      customer_order_rec_.contract, currency_code_, base_charge_amt_, currency_rate_type_);
            ELSE    
               -- convert above base into sales price
               Customer_Order_Pricing_API.Get_Sales_Price_In_Currency(charge_amt_, currency_rate_, customer_no_,
                                                                      contract_, currency_code_,
                                                                      base_charge_amt_, currency_rate_type_);
            END IF;     
         ELSE
            charge_amt_ := base_charge_amt_;
         END IF;
      ELSE
         charge_amt_ := NULL;
         qty_        := NULL;
      END IF;
      
      IF (demand_code_db_ IS NULL OR demand_code_db_ != 'IPD') THEN
         Client_SYS.Add_To_Attr('TAX_LIABILITY',        Tax_Handling_Util_API.Get_Customer_Tax_Liability(shipment_rec_.receiver_id, shipment_rec_.receiver_addr_id,
                                                                                                       company_, shipment_freight_rec_.supply_country), attr_);
      END IF;      
      
      Client_SYS.Add_To_Attr('CONTRACT',             contract_,                             attr_);
      Client_SYS.Add_To_Attr('COMPANY',              company_,                              attr_);
      Client_SYS.Add_To_Attr('CHARGE_TYPE',          charge_type_,                          attr_);
      Client_SYS.Add_To_Attr('CHARGE_AMOUNT',        charge_amt_,                           attr_);
      Client_SYS.Add_To_Attr('CHARGE_AMOUNT_INCL_TAX',charge_amt_,                          attr_);
      Client_SYS.Add_To_Attr('CHARGE_COST',          charge_cost_,                          attr_);
      Client_SYS.Add_To_Attr('CHARGED_QTY',          qty_,                                  attr_);
      Client_SYS.Add_To_Attr('BASE_CHARGE_AMOUNT',   base_charge_amt_,                      attr_);
      Client_SYS.Add_To_Attr('BASE_CHARGE_AMT_INCL_TAX',base_charge_amt_,                   attr_);
      Client_SYS.Add_To_Attr('PRINT_CHARGE_TYPE',    Gen_Yes_No_API.Decode(charge_type_rec_.print_charge_type), attr_);
      Client_SYS.Add_To_Attr('DELIVERY_TYPE',        charge_type_rec_.delivery_type,        attr_);
      Client_SYS.Add_To_Attr('UNIT_CHARGE_DB',       is_unit_charge_,                       attr_);
      Client_SYS.Add_To_Attr('PRINT_COLLECT_CHARGE', Print_Collect_Charge_API.Decode(charge_type_rec_.print_collect_charge), attr_);
      Client_SYS.Add_To_Attr('GROSS_WEIGHT',         NVL(line_total_weight_,0),             attr_);
      Client_SYS.Add_To_Attr('VOLUME',               NVL(line_total_volume_,0),             attr_);
   ELSE
      charge_amt_ := NULL;
      qty_        := NULL;
      Client_SYS.Add_To_Attr('CHARGE_AMOUNT',        charge_amt_,                           attr_);
      Client_SYS.Add_To_Attr('CHARGED_QTY',          qty_,                                  attr_);
   END IF;

END Get_Freight_Charge_Attr___;


-- New_Shipment_Charge___
--   This method will create new charge line in shipment. If the connecting
--   customer order line is freight free, it will create a new freight free
--   charge line as well.
--   This method will modify existing freight charge line and creating/updating
--   of freight free charge line.
--   parameter 'factor_' decides whether a CO line is added or removed from the
PROCEDURE New_Shipment_Charge___ (
   shipment_id_           IN NUMBER,
   order_no_              IN VARCHAR2,
   line_no_               IN VARCHAR2,
   rel_no_                IN VARCHAR2,
   line_item_no_          IN NUMBER,
   freight_map_id_        IN VARCHAR2,
   zone_id_               IN VARCHAR2,
   freight_price_list_no_ IN VARCHAR2,
   fee_code_              IN VARCHAR2,
   tax_liability_         IN VARCHAR2 )
IS
   shipment_rec_          Shipment_API.Public_Rec;
   del_term_rec_          Order_Delivery_Term_API.Public_Rec;
   freight_chg_attr_      VARCHAR2(2000);
   temp_freight_chg_attr_ VARCHAR2(2000);
   charge_amount_         NUMBER;
   base_charge_amount_    NUMBER;
   charge_qty_            NUMBER;
BEGIN

   shipment_rec_   := Shipment_API.Get(shipment_id_);
   del_term_rec_   := Order_Delivery_Term_API.Get(shipment_rec_.delivery_terms);

   Client_SYS.Add_To_Attr('SHIPMENT_ID',        shipment_id_, freight_chg_attr_);
   Client_SYS.Add_To_Attr('MANUALY_CREATED_DB', 'N',          freight_chg_attr_);

   Client_SYS.Add_To_Attr('COMPANY', Site_API.Get_Company(shipment_rec_.contract),  freight_chg_attr_);

   IF (del_term_rec_.collect_freight_charge = 'TRUE') THEN
      Client_SYS.Add_To_Attr('COLLECT_DB', 'COLLECT', freight_chg_attr_);
   ELSE
      Client_SYS.Add_To_Attr('COLLECT_DB', 'INVOICE', freight_chg_attr_);
   END IF;

   IF (fee_code_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('FEE_CODE', fee_code_, freight_chg_attr_);
   END IF;
   
   IF (tax_liability_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('TAX_LIABILITY', tax_liability_, freight_chg_attr_);
   END IF;
   
   Get_Freight_Charge_Attr___(freight_chg_attr_, shipment_id_, freight_map_id_, zone_id_, freight_price_list_no_, order_no_, line_no_, rel_no_, line_item_no_);

   charge_amount_      := Client_SYS.Get_Item_Value('CHARGE_AMOUNT',      freight_chg_attr_);
   charge_qty_         := Client_SYS.Get_Item_Value('CHARGED_QTY',        freight_chg_attr_);
   base_charge_amount_ := Client_SYS.Get_Item_Value('BASE_CHARGE_AMOUNT', freight_chg_attr_);

   IF (charge_amount_ IS NOT NULL) AND (charge_qty_ != 0) THEN
      temp_freight_chg_attr_ := freight_chg_attr_;
      -- New freight charge line
      New(freight_chg_attr_);

      IF Shipment_Freight_API.Get_Apply_Fix_Deliv_Freight_Db(shipment_id_) = 'FALSE' THEN
         IF ( Fnd_Boolean_API.Encode(Customer_Order_Line_API.Get_Freight_Free(order_no_, line_no_, rel_no_, line_item_no_)) = 'TRUE' ) THEN
            -- New freight free charge line
            Client_SYS.Set_Item_Value('CHARGE_AMOUNT',      -charge_amount_,      temp_freight_chg_attr_);
            Client_SYS.Set_Item_Value('BASE_CHARGE_AMOUNT', -base_charge_amount_, temp_freight_chg_attr_);
            Client_SYS.Set_Item_Value('CHARGE_AMOUNT_INCL_TAX',   -charge_amount_,      temp_freight_chg_attr_);
            Client_SYS.Set_Item_Value('BASE_CHARGE_AMT_INCL_TAX', -base_charge_amount_, temp_freight_chg_attr_);
            Client_SYS.Set_Item_Value('CHARGE_COST',        0,                    temp_freight_chg_attr_);
            New(temp_freight_chg_attr_);
         END IF;
      END IF;
   END IF;
END New_Shipment_Charge___;


PROCEDURE Modify_Shipment_Charges___ (
   shipment_id_           IN NUMBER,
   sequence_no_           IN NUMBER,
   order_no_              IN VARCHAR2,
   line_no_               IN VARCHAR2,
   rel_no_                IN VARCHAR2,
   line_item_no_          IN NUMBER,
   freight_price_list_no_ IN VARCHAR2,
   factor_                IN NUMBER )
IS
   order_line_rec_             Customer_Order_Line_API.Public_Rec;
   shipment_rec_               Shipment_API.Public_Rec;
   shipment_freight_rec_       Shipment_Freight_API.Public_Rec; 
   freight_price_list_rec_     Freight_Price_List_API.public_rec;
   currency_code_              ISO_CURRENCY_TAB.currency_code%TYPE;
   price_currency_code_        ISO_CURRENCY_TAB.currency_code%TYPE;
   shipment_charge_rec_        SHIPMENT_FREIGHT_CHARGE_TAB%ROWTYPE;
   attr_                       VARCHAR2(2000);
   free_freight_chg_attr_      VARCHAR2(2000);
   freight_basis_              VARCHAR2(20);
   charged_qty_                NUMBER;
   gross_weight_               NUMBER;
   volume_                     NUMBER;
   dummy_                      NUMBER;
   new_charge_amount_          NUMBER;
   new_base_charge_amount_     NUMBER;
   new_weight_                 NUMBER;
   new_volume_                 NUMBER;
   temp_new_weight_            NUMBER;
   temp_new_volume_            NUMBER;
   new_charge_cost_            NUMBER;
   new_qty_                    NUMBER;
   min_freight_amount_         NUMBER;
   free_sequence_no_           NUMBER;
   free_charge_amount_         NUMBER;
   free_base_charge_amount_    NUMBER;
   count_freight_free_         NUMBER;
   currency_rate_              NUMBER;
   removed_freight_free_       BOOLEAN := FALSE;
   price_effectivity_date_     DATE;
   company_                    VARCHAR2(20);
   company_invent_info_rec_    Company_Invent_Info_API.Public_Rec;
   charge_type_rec_            Sales_Charge_Type_API.Public_Rec;
   
   CURSOR get_shipment_charge IS
      SELECT *
      FROM  SHIPMENT_FREIGHT_CHARGE_TAB
      WHERE shipment_id = shipment_id_
      AND   sequence_no = sequence_no_
      AND   manualy_created = 'N';

   CURSOR get_freight_free_charges IS
      SELECT sequence_no, charge_amount, charged_qty, base_charge_amount, gross_weight, volume, charge_cost
      FROM  SHIPMENT_FREIGHT_CHARGE_TAB
      WHERE shipment_id = shipment_id_
      AND   charge_cost = 0
      AND   manualy_created = 'N';

   CURSOR get_count_freight_free IS
      SELECT count(*)
      FROM  shipment_line_pub s, customer_order_line_tab c
      WHERE s.shipment_id = shipment_id_
      AND   NVL(s.source_ref1, string_null_) = c.order_no
      AND   NVL(s.source_ref2, string_null_) = c.line_no
      AND   NVL(s.source_ref3, string_null_) = c.rel_no
      AND   NVL(s.source_ref4, string_null_) = c.line_item_no
      AND   s.source_ref_type_db = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER
      AND   c.freight_free = 'TRUE';
BEGIN

   order_line_rec_         := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);
   shipment_rec_           := Shipment_API.Get(shipment_id_);
   shipment_freight_rec_   := Shipment_Freight_API.Get(shipment_id_);
   freight_price_list_rec_ := Freight_Price_List_API.Get(freight_price_list_no_);
   freight_basis_          := freight_price_list_rec_.freight_basis;

   price_currency_code_    := Company_Finance_API.Get_Currency_Code(freight_price_list_rec_.company);
   currency_code_          := shipment_freight_rec_.currency_code;
   price_effectivity_date_ := NVL(shipment_rec_.planned_ship_date, Site_API.Get_Site_Date(shipment_rec_.contract));

   -- Get the existing weight / total volume from shipment freight charge
   OPEN get_shipment_charge;
   FETCH get_shipment_charge INTO shipment_charge_rec_;
   CLOSE get_shipment_charge;
   
   company_        := Site_API.Get_Company(shipment_rec_.contract);
    
   company_invent_info_rec_ := Company_Invent_Info_API.Get(company_);
   new_weight_ := Shipment_API.Get_Operational_Gross_Weight(shipment_id_, company_invent_info_rec_.uom_for_weight,'TRUE');
   new_volume_ := Shipment_API.Get_Operational_Volume(shipment_id_,company_invent_info_rec_.uom_for_volume);
   
   -- Calculate total weight
   IF (shipment_charge_rec_.unit_charge = 'TRUE') THEN
      charge_type_rec_  := Sales_Charge_Type_API.Get(shipment_rec_.contract, freight_price_list_rec_.charge_type);
   END IF;   
   
   IF (NVL(NVL(new_weight_, new_volume_),0) > 0) THEN
      new_qty_ := 1;
   ELSE
      new_qty_ := 0;
   END IF;

   IF (freight_basis_ = 'WEIGHT_BASED') THEN
      temp_new_volume_ := NULL;
      temp_new_weight_ := new_weight_;
      IF (shipment_charge_rec_.unit_charge = 'TRUE' AND NVL(new_weight_,0) > 0) THEN
         new_qty_ := new_weight_;
         IF (charge_type_rec_.sales_unit_meas != company_invent_info_rec_.uom_for_weight) THEN
            new_qty_ := NVL(Iso_Unit_API.Get_Unit_Converted_Quantity(new_qty_, company_invent_info_rec_.uom_for_weight, charge_type_rec_.sales_unit_meas), new_qty_); 
         END IF;
      END IF;      
   ELSE
      temp_new_weight_ := NULL;
      temp_new_volume_ := new_volume_;
      IF (shipment_charge_rec_.unit_charge = 'TRUE' AND NVL(new_volume_,0) > 0) THEN
         new_qty_ := new_volume_;
         IF (charge_type_rec_.sales_unit_meas != company_invent_info_rec_.uom_for_volume) THEN
            new_qty_ := NVL(Iso_Unit_API.Get_Unit_Converted_Quantity(new_qty_, company_invent_info_rec_.uom_for_volume, charge_type_rec_.sales_unit_meas), new_qty_); 
         END IF;
      END IF;      
   END IF;

   new_base_charge_amount_ := Freight_Price_List_Line_API.Get_Valid_Charge_Line(shipment_freight_rec_.price_list_no,
                                                                                temp_new_weight_,
                                                                                temp_new_volume_,
                                                                                price_effectivity_date_,
                                                                                shipment_freight_rec_.freight_map_id,
                                                                                shipment_freight_rec_.zone_id);

   -- Disconnecting CO lines from shipment
   IF factor_ = -1 THEN
      IF (new_weight_ = 0 AND new_volume_ = 0) THEN
         -- Remove the charge line if no order lines are connected
         Remove(shipment_id_, sequence_no_);

         OPEN get_freight_free_charges;
         FETCH get_freight_free_charges INTO free_sequence_no_, dummy_, dummy_, dummy_, dummy_, dummy_, dummy_;
         IF get_freight_free_charges%FOUND THEN
            Remove(shipment_id_, free_sequence_no_);
         END IF;
         CLOSE get_freight_free_charges;
      ELSE
         -- if no freight free lines, delete freight free line
         OPEN get_count_freight_free;
         FETCH get_count_freight_free INTO count_freight_free_;
         CLOSE get_count_freight_free;

         IF count_freight_free_ = 0 THEN
            OPEN get_freight_free_charges;
            FETCH get_freight_free_charges INTO free_sequence_no_, dummy_, dummy_, dummy_, dummy_, dummy_, dummy_;
            IF get_freight_free_charges%FOUND THEN
               Remove(shipment_id_, free_sequence_no_);
            END IF;
            CLOSE get_freight_free_charges;
         END IF;
         removed_freight_free_ := TRUE;
      END IF;
   END IF;

   new_charge_amount_   := new_base_charge_amount_;
   min_freight_amount_  := Freight_Price_List_Zone_API.Get_Min_Freight_Amount(freight_price_list_no_, 
                                                                              shipment_freight_rec_.freight_map_id, 
                                                                              shipment_freight_rec_.zone_id);
   
   -- Modify charge lines
   IF (new_base_charge_amount_ IS NOT NULL) AND (new_qty_ != 0) THEN
      -- IF minimum freight amount is larger than the total charge amount on the charge line, charge amount becomes fixed and min_freight_amount_.
      IF (NVL(min_freight_amount_,0) > (new_charge_amount_ * new_qty_)) THEN
         IF shipment_charge_rec_.unit_charge = 'TRUE' THEN
            new_base_charge_amount_ := min_freight_amount_;
         END IF;
         -- Charged qty is 1 because now this is a fixed amount.
         new_qty_     := 1;
      END IF;

      new_charge_cost_ := new_base_charge_amount_;

      IF (price_currency_code_ != currency_code_) THEN
         -- convert above base into sales price
         Customer_Order_Pricing_API.Get_Sales_Price_In_Currency(new_charge_amount_, currency_rate_, shipment_rec_.receiver_id,
                                                                shipment_rec_.contract, currency_code_, new_base_charge_amount_);
      ELSE
         new_charge_amount_ := new_base_charge_amount_;
      END IF;

      Client_Sys.Clear_Attr(attr_);
      IF shipment_freight_rec_.apply_fix_deliv_freight = 'TRUE' THEN
         new_charge_cost_ := shipment_freight_rec_.fix_deliv_freight;
      ELSE
         Client_SYS.Add_To_Attr('CHARGE_AMOUNT',      new_charge_amount_,       attr_);
         Client_SYS.Add_To_Attr('BASE_CHARGE_AMOUNT', new_base_charge_amount_,  attr_);
         Client_SYS.Add_To_Attr('CHARGE_AMOUNT_INCL_TAX', new_charge_amount_,       attr_);
         Client_SYS.Add_To_Attr('BASE_CHARGE_AMT_INCL_TAX', new_base_charge_amount_,  attr_);
         Client_SYS.Add_To_Attr('CHARGED_QTY',        new_qty_,                 attr_);
      END IF;

      Client_SYS.Add_To_Attr('CHARGE_COST',   new_charge_cost_,  attr_);
      Client_SYS.Add_To_Attr('GROSS_WEIGHT',  new_weight_,       attr_);
      Client_SYS.Add_To_Attr('VOLUME',          new_volume_,       attr_);
      Modify(attr_, shipment_id_, sequence_no_);

      -- Modify freight free charge line
      IF (shipment_freight_rec_.apply_fix_deliv_freight = 'FALSE') AND (order_no_ IS NOT NULL) THEN
         IF ( Fnd_Boolean_API.Encode(Customer_Order_Line_API.Get_Freight_Free(order_no_, line_no_, rel_no_, line_item_no_)) = 'TRUE' ) AND NOT removed_freight_free_ THEN
            -- IF connecting a freight free CO line
            OPEN get_freight_free_charges;
            FETCH get_freight_free_charges INTO free_sequence_no_, dummy_, charged_qty_, dummy_, gross_weight_, volume_, dummy_;

            IF (freight_basis_ = 'WEIGHT_BASED') THEN
               IF shipment_charge_rec_.unit_charge = 'TRUE' THEN
                  new_qty_                 := NVL(charged_qty_,0) + NVL(order_line_rec_.adjusted_weight_gross*factor_,0);
                  free_base_charge_amount_ := new_base_charge_amount_;
               ELSE
                  new_qty_                 := 1;
                  free_base_charge_amount_ := NVL(new_base_charge_amount_,0) * (NVL(gross_weight_,0) + NVL(order_line_rec_.adjusted_weight_gross*factor_,0))/new_weight_;
               END IF;
            ELSE
               IF shipment_charge_rec_.unit_charge = 'TRUE' THEN
                  new_qty_                 := NVL(charged_qty_,0) + NVL(order_line_rec_.line_total_qty*factor_,0);
                  free_base_charge_amount_ := new_base_charge_amount_;
               ELSE
                  new_qty_                 := 1;
                  free_base_charge_amount_ := NVL(new_base_charge_amount_,0) * (NVL(volume_,0) + NVL(order_line_rec_.line_total_qty*factor_,0))/new_volume_;
               END IF;
            END IF;

            IF (price_currency_code_ != currency_code_) THEN
               -- convert above base into sales price
               Customer_Order_Pricing_API.Get_Sales_Price_In_Currency(free_charge_amount_, currency_rate_, shipment_rec_.receiver_id,
                                                                      shipment_rec_.contract, currency_code_, free_base_charge_amount_);
            ELSE
               free_charge_amount_ := free_base_charge_amount_;
            END IF;

            Client_SYS.Clear_Attr(free_freight_chg_attr_);
            IF get_freight_free_charges%FOUND THEN
               Client_SYS.Add_To_Attr('CHARGE_AMOUNT',      -(free_charge_amount_),                                                 free_freight_chg_attr_);
               Client_SYS.Add_To_Attr('BASE_CHARGE_AMOUNT', -(free_base_charge_amount_),                                            free_freight_chg_attr_);
               Client_SYS.Add_To_Attr('CHARGE_AMOUNT_INCL_TAX',   -(free_charge_amount_),                                           free_freight_chg_attr_);
               Client_SYS.Add_To_Attr('BASE_CHARGE_AMT_INCL_TAX', -(free_base_charge_amount_),                                      free_freight_chg_attr_);
               Client_SYS.Add_To_Attr('CHARGED_QTY',        new_qty_,                                                               free_freight_chg_attr_);
               Client_SYS.Add_To_Attr('GROSS_WEIGHT',       NVL(gross_weight_ + (order_line_rec_.adjusted_weight_gross*factor_),0), free_freight_chg_attr_);
               Client_SYS.Add_To_Attr('VOLUME',             NVL(volume_ + (order_line_rec_.line_total_qty*factor_),0),              free_freight_chg_attr_);
               Modify(free_freight_chg_attr_, shipment_id_, free_sequence_no_);
            ELSE
               Client_SYS.Clear_Attr(free_freight_chg_attr_);
               Client_SYS.Add_To_Attr('SHIPMENT_ID',             shipment_id_,                                 free_freight_chg_attr_);
               Client_SYS.Add_To_Attr('CONTRACT',                shipment_charge_rec_.contract,                free_freight_chg_attr_);
               Client_SYS.Add_To_Attr('COMPANY',                 shipment_charge_rec_.company,                 free_freight_chg_attr_);
               Client_SYS.Add_To_Attr('CHARGE_TYPE',             shipment_charge_rec_.charge_type,             free_freight_chg_attr_);
               Client_SYS.Add_To_Attr('CHARGE_AMOUNT',           -(free_charge_amount_),                       free_freight_chg_attr_);
               Client_SYS.Add_To_Attr('CHARGE_AMOUNT_INCL_TAX',  -(free_charge_amount_),                       free_freight_chg_attr_);
               Client_SYS.Add_To_Attr('CHARGE_COST',             0,                                            free_freight_chg_attr_);
               Client_SYS.Add_To_Attr('CHARGED_QTY',             new_qty_,                                     free_freight_chg_attr_);
               Client_SYS.Add_To_Attr('BASE_CHARGE_AMOUNT',      -(free_base_charge_amount_),                  free_freight_chg_attr_);
               Client_SYS.Add_To_Attr('BASE_CHARGE_AMT_INCL_TAX',-(free_base_charge_amount_),                  free_freight_chg_attr_);
               Client_SYS.Add_To_Attr('PRINT_CHARGE_TYPE_DB',    shipment_charge_rec_.print_charge_type,       free_freight_chg_attr_);
               Client_SYS.Add_To_Attr('COLLECT_DB',              shipment_charge_rec_.collect,                 free_freight_chg_attr_);
               Client_SYS.Add_To_Attr('TAX_LIABILITY',           shipment_charge_rec_.tax_liability,           free_freight_chg_attr_);
               Client_SYS.Add_To_Attr('UNIT_CHARGE_DB',          shipment_charge_rec_.unit_charge,             free_freight_chg_attr_);
               Client_SYS.Add_To_Attr('PRINT_COLLECT_CHARGE_DB', shipment_charge_rec_.print_collect_charge,    free_freight_chg_attr_);
               Client_SYS.Add_To_Attr('GROSS_WEIGHT',            NVL(order_line_rec_.adjusted_weight_gross,0), free_freight_chg_attr_);
               Client_SYS.Add_To_Attr('VOLUME',                  NVL(order_line_rec_.line_total_qty,0),        free_freight_chg_attr_);
               Client_SYS.Add_To_Attr('MANUALY_CREATED_DB',      'N',                                          free_freight_chg_attr_);
               New(free_freight_chg_attr_);
            END IF;
            CLOSE get_freight_free_charges;
         ELSE
            -- IF connecting a non freight free CO line to a shipment with a freight free charge line
            OPEN get_freight_free_charges;
            FETCH get_freight_free_charges INTO free_sequence_no_, dummy_, charged_qty_, dummy_, gross_weight_, volume_, dummy_;
            IF get_freight_free_charges%FOUND THEN
               IF (freight_basis_ = 'WEIGHT_BASED') THEN
                  IF shipment_charge_rec_.unit_charge = 'TRUE' THEN
                     free_base_charge_amount_ := new_base_charge_amount_;
                  ELSE
                     free_base_charge_amount_ := NVL(new_charge_amount_,0) * NVL(gross_weight_,0)/new_weight_;
                  END IF;
               ELSE
                  IF shipment_charge_rec_.unit_charge = 'TRUE' THEN
                     free_base_charge_amount_ := new_base_charge_amount_;
                  ELSE
                     free_base_charge_amount_ := NVL(new_charge_amount_,0) * NVL(volume_,0)/new_volume_;
                  END IF;
               END IF;
               IF (price_currency_code_ != currency_code_) THEN
                  -- convert above base into sales price
                  Customer_Order_Pricing_API.Get_Sales_Price_In_Currency(free_charge_amount_, currency_rate_, shipment_rec_.receiver_id,
                                                                         shipment_rec_.contract, currency_code_, free_base_charge_amount_);
               ELSE
                  free_charge_amount_ := free_base_charge_amount_;
               END IF;
               Client_SYS.Clear_Attr(free_freight_chg_attr_);
               Client_SYS.Add_To_Attr('CHARGE_AMOUNT',      -(free_charge_amount_),       free_freight_chg_attr_);
               Client_SYS.Add_To_Attr('BASE_CHARGE_AMOUNT', -(free_base_charge_amount_),  free_freight_chg_attr_);
               Client_SYS.Add_To_Attr('CHARGE_AMOUNT_INCL_TAX',   -(free_charge_amount_),       free_freight_chg_attr_);
               Client_SYS.Add_To_Attr('BASE_CHARGE_AMT_INCL_TAX', -(free_base_charge_amount_),  free_freight_chg_attr_);
               Modify(free_freight_chg_attr_, shipment_id_, free_sequence_no_);
            END IF;
            CLOSE get_freight_free_charges;
         END IF;
      END IF;
   ELSE
      IF shipment_freight_rec_.apply_fix_deliv_freight = 'FALSE' THEN
         -- Remove freight charge line
         OPEN get_shipment_charge;
         FETCH get_shipment_charge INTO shipment_charge_rec_;
         IF get_shipment_charge%FOUND THEN
            Remove(shipment_id_, sequence_no_);
         END IF;
         CLOSE get_shipment_charge;

         -- Remove freight free charge line
         OPEN get_freight_free_charges;
         FETCH get_freight_free_charges INTO free_sequence_no_, dummy_, dummy_, dummy_, dummy_, dummy_, dummy_;
         IF get_freight_free_charges%FOUND THEN
            Remove(shipment_id_, free_sequence_no_);
         END IF;
         CLOSE get_freight_free_charges;
      END IF;
   END IF;
END Modify_Shipment_Charges___;


PROCEDURE Modify_Prices___(
   shipment_id_   IN NUMBER,
   sequence_no_   IN NUMBER )
IS
   line_rec_                    shipment_freight_charge_tab%ROWTYPE;
   charge_amount_               NUMBER;
   charge_amount_incl_tax_      NUMBER;
   base_charge_amount_          NUMBER;
   base_charge_amount_incl_tax_ NUMBER;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000); 
BEGIN
   line_rec_  := Get_Object_By_Keys___(shipment_id_,sequence_no_);
   charge_amount_                := line_rec_.charge_amount;
   charge_amount_incl_tax_       := line_rec_.charge_amount_incl_tax;
   base_charge_amount_           := line_rec_.base_charge_amount;
   base_charge_amount_incl_tax_  := line_rec_.base_charge_amt_incl_tax;
   
   Calculate_Prices___(charge_amount_, charge_amount_incl_tax_, base_charge_amount_, 
                       base_charge_amount_incl_tax_, shipment_id_, sequence_no_);
   
   line_rec_.base_charge_amount       := base_charge_amount_;
   line_rec_.base_charge_amt_incl_tax := base_charge_amount_incl_tax_;
   line_rec_.charge_amount            := charge_amount_;
   line_rec_.charge_amount_incl_tax   := charge_amount_incl_tax_;
   
   Get_Id_Version_By_Keys___(objid_, objversion_, shipment_id_,sequence_no_);
   line_rec_.rowversion := sysdate; 
   Update_Line___(objid_, line_rec_);   
END Modify_Prices___;


PROCEDURE Modify_Prices___(
   newrec_     IN OUT SHIPMENT_FREIGHT_CHARGE_TAB%ROWTYPE )
IS   
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000); 
BEGIN
      
   Calculate_Prices___(newrec_);
   
   Get_Id_Version_By_Keys___(objid_, objversion_, newrec_.shipment_id, newrec_.sequence_no);
   newrec_.rowversion := sysdate; 
   Update_Line___(objid_, newrec_);   
END Modify_Prices___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT SHIPMENT_FREIGHT_CHARGE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   CURSOR get_seq_no(shipment_id_ IN VARCHAR2) IS
      SELECT nvl(max(sequence_no) + 1, 1)
      FROM   SHIPMENT_FREIGHT_CHARGE_TAB
      WHERE  shipment_id = shipment_id_;
      
   tax_from_defaults_            BOOLEAN;
   original_ship_id_             VARCHAR2(50);
   original_sequence_no_         VARCHAR2(50);
   tax_class_id_                 VARCHAR2(20);
   tax_method_                   VARCHAR2(50);
   tax_from_external_system_     BOOLEAN := FALSE;
BEGIN
   OPEN get_seq_no(newrec_.shipment_id);
   FETCH get_seq_no INTO newrec_.sequence_no;
   CLOSE get_seq_no;
   super(objid_, objversion_, newrec_, attr_);
   
   tax_method_ := Company_Tax_Control_API.Get_External_Tax_Cal_Method_Db(newrec_.company);
   IF (tax_method_ != External_Tax_Calc_Method_API.DB_NOT_USED) THEN
      tax_from_defaults_ := TRUE;
      tax_from_external_system_ := TRUE;
   ELSE
      IF (NVL(Client_SYS.Get_Item_Value('FETCH_TAX_CODES', attr_), 'TRUE') = 'TRUE') THEN
         IF (newrec_.tax_calc_structure_id IS NULL) THEN 
            IF (newrec_.fee_code IS NULL) THEN
               tax_from_defaults_ := TRUE;         
            ELSE
               tax_from_defaults_ := FALSE;
            END IF;
         ELSE
            tax_from_defaults_ := FALSE;
         END IF;
      END IF;
   END IF;
   -- If the line is copied or duplicated, taxes should be copied from the original line.
   original_ship_id_      := Client_SYS.Get_Item_Value('ORIGINAL_SHIP_ID', attr_);      
   original_sequence_no_  := Client_SYS.Get_Item_Value('ORIGINAL_SEQ_NO', attr_);      

   IF (Client_SYS.Get_Item_Value('SET_TAX_FROM_ORIGINAL', attr_) = 'TRUE') AND (original_ship_id_ IS NOT NULL) AND 
      (NOT tax_from_external_system_) THEN      
      tax_class_id_ := Get_Tax_Class_Id(original_ship_id_,
                                        original_sequence_no_);
      Tax_Handling_Order_Util_API.Transfer_Tax_lines(newrec_.company, 
                                                     Tax_Source_API.DB_SHIPMENT_FREIGHT_CHARGE, 
                                                     original_ship_id_, 
                                                     original_sequence_no_, 
                                                     '*', 
                                                     '*', 
                                                     '*',
                                                     Tax_Source_API.DB_SHIPMENT_FREIGHT_CHARGE, 
                                                     newrec_.shipment_id, 
                                                     newrec_.sequence_no, 
                                                     '*', 
                                                     '*', 
                                                     '*',
                                                     'TRUE',
                                                     'FALSE');
   ELSE
      Add_Transaction_Tax_Info___(newrec_,                                
                                  tax_from_defaults_ => tax_from_defaults_,                                      
                                  add_tax_lines_     => TRUE,
                                  attr_              => NULL);
   END IF; 
   newrec_ := Get_Object_By_Keys___(newrec_.shipment_id, newrec_.sequence_no);
   IF (tax_class_id_ IS NOT NULL) THEN
      newrec_.tax_class_id := tax_class_id_;
   END IF;
   Modify_Prices___(newrec_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     SHIPMENT_FREIGHT_CHARGE_TAB%ROWTYPE,
   newrec_     IN OUT SHIPMENT_FREIGHT_CHARGE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   shipment_freight_rec_ Shipment_Freight_API.Public_Rec; 
   tax_lines_updated_    VARCHAR2(5);
   tax_from_defaults_    BOOLEAN;
   multiple_tax_lines_   VARCHAR2(20);
   tax_item_removed_     VARCHAR2(5) := 'FALSE';
   tax_method_           VARCHAR2(50);
BEGIN
   tax_lines_updated_ := Client_sys.Cut_Item_Value('TAX_LINES_UPDATED', attr_);
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);   
   shipment_freight_rec_ := Shipment_Freight_API.Get(newrec_.shipment_id);
   
   multiple_tax_lines_  := Client_SYS.Get_Item_Value('MULTIPLE_TAX_LINES', attr_);
   IF ((newrec_.fee_code IS NULL) AND (newrec_.tax_calc_structure_id IS NULL) 
      AND (multiple_tax_lines_ IS NOT NULL) AND (multiple_tax_lines_ = 'FALSE')) THEN
      
      tax_item_removed_ := 'TRUE';
      
      Source_Tax_Item_Order_API.Remove_Tax_Items(newrec_.company, 
                                                Tax_Source_API.DB_SHIPMENT_FREIGHT_CHARGE,
                                                TO_CHAR(newrec_.shipment_id), 
                                                TO_CHAR(newrec_.sequence_no), 
                                                '*', 
                                                '*',           
                                                '*');
      Tax_Handling_Util_API.Validate_Tax_Code_Mandatory(newrec_.company, 'CUSTOMER_TAX');       
   END IF;
   
   IF (tax_item_removed_ != 'TRUE') AND ((NVL(tax_lines_updated_, ' ') != 'TRUE') AND ((newrec_.tax_liability != oldrec_.tax_liability) OR 
      (NVL(newrec_.fee_code, Database_SYS.string_null_) != NVL(oldrec_.fee_code, Database_SYS.string_null_)) OR
      (NVL(newrec_.delivery_type, Database_SYS.string_null_) != NVL(oldrec_.delivery_type, Database_SYS.string_null_)) OR
      (NVL(newrec_.tax_calc_structure_id, Database_SYS.string_null_) != NVL(oldrec_.tax_calc_structure_id, Database_SYS.string_null_))))THEN
      
      IF ((newrec_.tax_liability != oldrec_.tax_liability) OR 
         (NVL(newrec_.delivery_type, Database_SYS.string_null_) != NVL(oldrec_.delivery_type, Database_SYS.string_null_))
         OR (newrec_.charge_type != oldrec_.charge_type)) THEN
         tax_from_defaults_ := TRUE;
      ELSE
         tax_from_defaults_ := FALSE;
      END IF;
      Add_Transaction_Tax_Info___ (newrec_,                                
                                   tax_from_defaults_ => tax_from_defaults_,                                      
                                   add_tax_lines_     => TRUE,
                                   attr_              => NULL); 
   ELSIF ((((newrec_.base_charge_amount != oldrec_.base_charge_amount) OR 
            (newrec_.charge_amount != oldrec_.charge_amount)) AND 
            shipment_freight_rec_.use_price_incl_tax = 'FALSE') OR 
            (newrec_.charged_qty != oldrec_.charged_qty) OR 
            (newrec_.charge_type != oldrec_.charge_type) OR 
            (((newrec_.charge_amount_incl_tax != oldrec_.charge_amount_incl_tax) OR
            (newrec_.base_charge_amt_incl_tax != oldrec_.base_charge_amt_incl_tax)) AND 
            shipment_freight_rec_.use_price_incl_tax = 'TRUE')) THEN
      
         tax_method_ := Company_Tax_Control_API.Get_External_Tax_Cal_Method_Db(newrec_.company);
         IF (tax_method_ != External_Tax_Calc_Method_API.DB_NOT_USED) THEN
            tax_from_defaults_ := TRUE;
            Add_Transaction_Tax_Info___ (newrec_,                                
                                         tax_from_defaults_ => tax_from_defaults_,                                      
                                         add_tax_lines_     => TRUE,
                                         attr_              => NULL);
         ELSE
            tax_from_defaults_ := FALSE;
            Recalculate_Tax_Lines___(newrec_, tax_from_defaults_, attr_);
         END IF;
         
   END IF;
   IF (NVL(tax_lines_updated_, ' ') = 'TRUE') THEN
      Modify_Prices___(newrec_);
   END IF;
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT shipment_freight_charge_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS  
   sales_chg_type_category_db_ VARCHAR2(20);
BEGIN
   super(newrec_, indrec_, attr_);
   sales_chg_type_category_db_ := Sales_Charge_Type_API.Get_Sales_Chg_Type_Category_Db(newrec_.contract, newrec_.charge_type);

   IF (sales_chg_type_category_db_ != 'FREIGHT') THEN
      Error_SYS.Record_General(lu_name_, 'INVALCHGTYPE: Only charges of the charge type category Freight can be entered in the shipment.');
   END IF;

   IF NOT (newrec_.tax_liability = 'TAX' OR newrec_.tax_liability = 'EXEMPT') THEN      
      Tax_Handling_Order_Util_API.Validate_Tax_Liability(newrec_.tax_liability, Shipment_API.Get_Receiver_Country(newrec_.shipment_id));
   END IF;

END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     shipment_freight_charge_tab%ROWTYPE,
   newrec_ IN OUT shipment_freight_charge_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS   
   sales_chg_type_category_db_ VARCHAR2(20);   
   delivery_type_changed_      BOOLEAN := FALSE;
   shipment_rec_               Shipment_API.Public_Rec;   
   shipment_freight_rec_       Shipment_Freight_API.Public_Rec;
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
      
   delivery_type_changed_  := indrec_.delivery_type;   
   IF (NVL(newrec_.fee_code, Database_SYS.string_null_) != NVL(oldrec_.fee_code, Database_SYS.string_null_)) THEN
      newrec_.tax_class_id := NULL;
   END IF;

   sales_chg_type_category_db_ := Sales_Charge_Type_API.Get_Sales_Chg_Type_Category_Db(newrec_.contract, newrec_.charge_type);
   IF (sales_chg_type_category_db_ != 'FREIGHT') THEN
      Error_SYS.Record_General(lu_name_, 'INVALCHGTYPE: Only charges of the charge type category Freight can be entered in the shipment.');
   END IF;

   shipment_rec_ := Shipment_API.Get(newrec_.shipment_id);
   shipment_freight_rec_ := Shipment_Freight_API.Get(newrec_.shipment_id);
   
   IF (shipment_freight_rec_.freight_chg_invoiced = 'TRUE') THEN
      Error_SYS.Record_General(lu_name_, 'UPDATENOTALLOWED: Invoiced shipment freight charge lines may not be modified.');
   END IF;

   IF NOT (newrec_.tax_liability = 'TAX' OR newrec_.tax_liability = 'EXEMPT') THEN
      Tax_Handling_Order_Util_API.Validate_Tax_Liability(newrec_.tax_liability, shipment_rec_.receiver_country);
   END IF;   

END Check_Update___;


PROCEDURE Recalculate_Tax_Lines___ (
   newrec_        IN OUT shipment_freight_charge_tab%ROWTYPE,
   from_defaults_ IN BOOLEAN,
   attr_          IN VARCHAR2)
IS
   source_key_rec_         Tax_Handling_Util_API.source_key_rec;
   tax_line_param_rec_     Tax_Handling_Order_Util_API.tax_line_param_rec;
   shipment_rec_           Shipment_API.Public_Rec; 
   shipment_freight_rec_   Shipment_Freight_API.Public_Rec;
   curr_type_              VARCHAR2(10);
   currency_conv_factor_   NUMBER;
   currency_rate_          NUMBER;
BEGIN
   source_key_rec_     := Tax_Handling_Util_API.Create_Source_Key_Rec(Tax_Source_API.DB_SHIPMENT_FREIGHT_CHARGE,
                                                                      TO_CHAR(newrec_.shipment_id), 
                                                                      TO_CHAR(newrec_.sequence_no), 
                                                                      '*', 
                                                                      '*',   
                                                                      '*',
                                                                      attr_); 
                                      
   shipment_rec_         := Shipment_API.Get(newrec_.shipment_id);
   shipment_freight_rec_ := Shipment_Freight_API.Get(newrec_.shipment_id);
   
   tax_line_param_rec_.company             := newrec_.company;
   tax_line_param_rec_.contract            := shipment_rec_.contract;
   tax_line_param_rec_.customer_no         := shipment_rec_.receiver_id;
   tax_line_param_rec_.ship_addr_no        := shipment_rec_.receiver_addr_id;
   tax_line_param_rec_.planned_ship_date   := TRUNC(Site_API.Get_Site_Date(shipment_rec_.contract));
   tax_line_param_rec_.supply_country_db   := shipment_freight_rec_.supply_country;
   tax_line_param_rec_.delivery_type       := NVL(newrec_.delivery_type, '*');
   tax_line_param_rec_.object_id           := newrec_.charge_type;
   tax_line_param_rec_.use_price_incl_tax  := shipment_freight_rec_.use_price_incl_tax;
   tax_line_param_rec_.currency_code       := NVL(shipment_freight_rec_.currency_code, Company_Finance_API.Get_Currency_Code(newrec_.company));
   
   Invoice_Library_API.Get_Currency_Rate_Defaults(curr_type_, currency_conv_factor_, currency_rate_, newrec_.company, tax_line_param_rec_.currency_code,
                                                  Site_API.Get_Site_Date(shipment_rec_.contract), 'CUSTOMER', shipment_rec_.receiver_id);
   
   tax_line_param_rec_.currency_rate         := (currency_rate_ / currency_conv_factor_);
   tax_line_param_rec_.tax_liability         := newrec_.tax_liability;
   tax_line_param_rec_.tax_liability_type_db := Tax_Liability_API.Get_Tax_Liability_Type_Db(newrec_.tax_liability, shipment_rec_.receiver_country);   
   tax_line_param_rec_.from_defaults         := from_defaults_;
   tax_line_param_rec_.tax_code              := newrec_.fee_code;
   tax_line_param_rec_.tax_calc_structure_id := newrec_.tax_calc_structure_id;
   tax_line_param_rec_.add_tax_lines         := FALSE;

   Tax_Handling_Order_Util_API.Recalculate_Tax_Lines (source_key_rec_,
                                                      tax_line_param_rec_,
                                                      attr_);
   
END Recalculate_Tax_Lines___;


-- Add_Transaction_Tax_Info___
--    Fetch and calculate taxes and add tax lines to source_tax_item_tab.
PROCEDURE Add_Transaction_Tax_Info___ (
   newrec_              IN OUT shipment_freight_charge_tab%ROWTYPE, 
   tax_from_defaults_   IN BOOLEAN,
   add_tax_lines_       IN BOOLEAN,
   attr_                IN VARCHAR2)
IS
   line_amount_rec_       Tax_Handling_Util_API.line_amount_rec;
   source_key_rec_        Tax_Handling_Util_API.source_key_rec;
   tax_line_param_rec_    Tax_Handling_Order_Util_API.tax_line_param_rec;   
   shipment_rec_          Shipment_API.Public_Rec; 
   shipment_freight_rec_  Shipment_Freight_API.Public_Rec;
   curr_type_             VARCHAR2(10);
   multiple_tax_          VARCHAR2(20);
   currency_conv_factor_  NUMBER;
   currency_rate_         NUMBER; 
   tax_info_table_        Tax_Handling_Util_API.tax_information_table;
BEGIN
   source_key_rec_     := Tax_Handling_Util_API.Create_Source_Key_Rec(Tax_Source_API.DB_SHIPMENT_FREIGHT_CHARGE,
                                                                      TO_CHAR(newrec_.shipment_id), 
                                                                      TO_CHAR(newrec_.sequence_no), 
                                                                      '*', 
                                                                      '*',           
                                                                      '*',
                                                                      attr_); 
                                      
   shipment_rec_         := Shipment_API.Get(newrec_.shipment_id);
   shipment_freight_rec_ := Shipment_Freight_API.Get(newrec_.shipment_id);
   
   tax_line_param_rec_.company             := newrec_.company;
   tax_line_param_rec_.contract            := shipment_rec_.contract;
   tax_line_param_rec_.customer_no         := shipment_rec_.receiver_id;
   tax_line_param_rec_.ship_addr_no        := shipment_rec_.receiver_addr_id;
   tax_line_param_rec_.planned_ship_date   := TRUNC(Site_API.Get_Site_Date(shipment_rec_.contract));
   tax_line_param_rec_.supply_country_db   := shipment_freight_rec_.supply_country;
   tax_line_param_rec_.delivery_type       := NVL(newrec_.delivery_type, '*');
   tax_line_param_rec_.object_id           := newrec_.charge_type;
   tax_line_param_rec_.use_price_incl_tax  := shipment_freight_rec_.use_price_incl_tax;
   tax_line_param_rec_.currency_code       := NVL(shipment_freight_rec_.currency_code, Company_Finance_API.Get_Currency_Code(newrec_.company));
   
   Invoice_Library_API.Get_Currency_Rate_Defaults(curr_type_, currency_conv_factor_, currency_rate_, newrec_.company, tax_line_param_rec_.currency_code,
                                                  Site_API.Get_Site_Date(shipment_rec_.contract), 'CUSTOMER', shipment_rec_.receiver_id);
   
   tax_line_param_rec_.currency_rate         := (currency_rate_ / currency_conv_factor_);
   tax_line_param_rec_.tax_liability         := newrec_.tax_liability;
   tax_line_param_rec_.tax_liability_type_db := Tax_Liability_API.Get_Tax_Liability_Type_Db(newrec_.tax_liability, shipment_rec_.receiver_country);   
   tax_line_param_rec_.from_defaults         := tax_from_defaults_;
   tax_line_param_rec_.add_tax_lines         := add_tax_lines_;
   tax_line_param_rec_.tax_code              := newrec_.fee_code;
   tax_line_param_rec_.tax_calc_structure_id := newrec_.tax_calc_structure_id;
   
   Tax_Handling_Order_Util_API.Add_Transaction_Tax_Info (line_amount_rec_,
                                                         multiple_tax_,
                                                         tax_info_table_,
                                                         tax_line_param_rec_,
                                                         source_key_rec_,
                                                         attr_);
                                                         
END Add_Transaction_Tax_Info___;


PROCEDURE Update_Line___ (
   objid_  IN VARCHAR2,
   newrec_ IN shipment_freight_charge_tab%ROWTYPE )
IS
BEGIN     
   UPDATE shipment_freight_charge_tab
      SET ROW = newrec_
      WHERE rowid = objid_;    
END Update_Line___;


PROCEDURE Calculate_Prices___ (
   newrec_ IN OUT shipment_freight_charge_tab%ROWTYPE ) 
IS
   shipment_rec_          Shipment_API.Public_Rec; 
   shipment_freight_rec_  Shipment_Freight_API.Public_Rec;
   curr_type_             VARCHAR2(10);
   currency_conv_factor_  NUMBER;
   currency_rate_         NUMBER;
   multiple_tax_          VARCHAR2(20);
   currency_code_         VARCHAR2(3);
BEGIN
   shipment_rec_         := Shipment_API.Get(newrec_.shipment_id);
   shipment_freight_rec_ := Shipment_Freight_API.Get(newrec_.shipment_id);
   
   currency_code_ := NVL(shipment_freight_rec_.currency_code, Company_Finance_API.Get_Currency_Code(newrec_.company));
   
   Invoice_Library_API.Get_Currency_Rate_Defaults(curr_type_, currency_conv_factor_, currency_rate_, newrec_.company, currency_code_,
                                                  Site_API.Get_Site_Date(newrec_.contract), 'CUSTOMER', shipment_rec_.receiver_id);

   Tax_Handling_Order_Util_API.Get_Prices(newrec_.base_charge_amount,
                                          newrec_.base_charge_amt_incl_tax,
                                          newrec_.charge_amount,
                                          newrec_.charge_amount_incl_tax,
                                          multiple_tax_,
					                           newrec_.fee_code,
                                          newrec_.tax_calc_structure_id,
                                          newrec_.tax_class_id,
                                          newrec_.shipment_id, 
                                          newrec_.sequence_no, 
                                          '*',
                                          '*',
                                          '*',
                                          Tax_Source_API.DB_SHIPMENT_FREIGHT_CHARGE,
                                          newrec_.contract,
                                          shipment_rec_.receiver_id,
                                          shipment_rec_.receiver_addr_id,
                                          TRUNC(Site_API.Get_Site_Date(newrec_.contract)),
                                          shipment_freight_rec_.supply_country,
                                          NVL(newrec_.delivery_type, '*'),
                                          newrec_.charge_type,
                                          shipment_freight_rec_.use_price_incl_tax,
                                          currency_code_,
                                          (currency_rate_ / currency_conv_factor_),
                                          'FALSE',                                          
                                          newrec_.tax_liability,
                                          Tax_Liability_API.Get_Tax_Liability_Type_Db(newrec_.tax_liability, shipment_rec_.receiver_country),
                                          delivery_country_db_ => NULL,
                                          ifs_curr_rounding_ => 16,
                                          tax_from_diff_source_ => 'FALSE',
                                          attr_ => NULL);
END Calculate_Prices___;


PROCEDURE Calculate_Prices___ (
   charge_amount_                 IN OUT NUMBER,
   charge_amount_incl_tax_        IN OUT NUMBER,
   base_charge_amount_            IN OUT NUMBER,
   base_charge_amount_incl_tax_   IN OUT NUMBER,
   shipment_id_                   IN NUMBER,
   sequence_no_                   IN NUMBER ) 
IS
   tax_line_param_rec_    Tax_Handling_Order_Util_API.tax_line_param_rec;
   multiple_tax_          VARCHAR2(20);
BEGIN
   tax_line_param_rec_ := Fetch_Tax_Line_Param(Get_Company(shipment_id_, sequence_no_), shipment_id_, sequence_no_, '*', '*');

   Tax_Handling_Order_Util_API.Get_Prices(base_charge_amount_,
                                          base_charge_amount_incl_tax_,
                                          charge_amount_,
                                          charge_amount_incl_tax_,
                                          multiple_tax_,
					                           tax_line_param_rec_.tax_code,
                                          tax_line_param_rec_.tax_calc_structure_id,
                                          tax_line_param_rec_.tax_class_id,
                                          shipment_id_, 
                                          sequence_no_, 
                                          '*',
                                          '*',
                                          '*',
                                          Tax_Source_API.DB_SHIPMENT_FREIGHT_CHARGE,
                                          tax_line_param_rec_.contract,
                                          tax_line_param_rec_.customer_no,
                                          tax_line_param_rec_.ship_addr_no,
                                          tax_line_param_rec_.planned_ship_date,
                                          tax_line_param_rec_.supply_country_db,
                                          tax_line_param_rec_.delivery_type,
                                          tax_line_param_rec_.object_id,
                                          tax_line_param_rec_.use_price_incl_tax,
                                          tax_line_param_rec_.currency_code,
                                          tax_line_param_rec_.currency_rate,
                                          'FALSE',                                          
                                          tax_line_param_rec_.tax_liability,
                                          tax_line_param_rec_.tax_liability_type_db,
                                          delivery_country_db_ => NULL,
                                          ifs_curr_rounding_ => 16,
                                          tax_from_diff_source_ => 'FALSE',
                                          attr_ => NULL);
END Calculate_Prices___;


PROCEDURE Update_Currency___ (
   shipment_id_  IN NUMBER )
IS
   shipment_rec_          Shipment_API.Public_Rec;
   shipment_freight_rec_  Shipment_Freight_API.Public_Rec;
   newrec_                SHIPMENT_FREIGHT_CHARGE_TAB%ROWTYPE;
   oldrec_                SHIPMENT_FREIGHT_CHARGE_TAB%ROWTYPE;
   charge_amt_            NUMBER;
   currency_rate_         NUMBER;
   price_currency_code_   Iso_Currency_TAB.currency_code%TYPE;
   attr_                  VARCHAR2(2000);
   objid_                 VARCHAR2(2000);
   objversion_            VARCHAR2(2000);
   indrec_                Indicator_Rec;
   charge_amount_incl_tax_        NUMBER;
   base_charge_amount_incl_tax_   NUMBER;
   company_                       Company_Finance_Tab.company%TYPE;                            

   CURSOR get_freight_charges IS
      SELECT sequence_no, company, base_charge_amount
      FROM  SHIPMENT_FREIGHT_CHARGE_TAB
      WHERE shipment_id = shipment_id_;

BEGIN

   shipment_rec_ := Shipment_API.Get(shipment_id_);
   shipment_freight_rec_ := Shipment_Freight_API.Get(shipment_id_);
   
   company_ := Site_API.Get_Company(shipment_rec_.contract);   
   price_currency_code_ := Company_Finance_API.Get_Currency_Code(company_);

   FOR rec_ IN get_freight_charges LOOP
      IF (price_currency_code_ != shipment_freight_rec_.currency_code) THEN
         Customer_Order_Pricing_API.Get_Sales_Price_In_Currency(charge_amt_, currency_rate_, shipment_rec_.receiver_id,
                                                                shipment_rec_.contract, shipment_freight_rec_.currency_code, rec_.base_charge_amount);
      ELSE
         charge_amt_ := rec_.base_charge_amount;
      END IF;

      Calculate_Prices___ (charge_amt_, charge_amount_incl_tax_,
                           rec_.base_charge_amount, base_charge_amount_incl_tax_,
                           shipment_id_, rec_.sequence_no);

      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('CHARGE_AMOUNT', charge_amt_, attr_);
      Client_SYS.Add_To_Attr('CHARGE_AMOUNT_INCL_TAX', charge_amount_incl_tax_,  attr_);
      Client_SYS.Add_To_Attr('BASE_CHARGE_AMT_INCL_TAX', base_charge_amount_incl_tax_, attr_);

      Get_Id_Version_By_Keys___(objid_, objversion_, shipment_id_, rec_.sequence_no);
      oldrec_ := Lock_By_Id___(objid_, objversion_);
      newrec_ := oldrec_;
      Reset_Indicator_Rec___(indrec_);
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
      Update___(objid_, oldrec_, newrec_, attr_, objversion_);

   END LOOP;
END Update_Currency___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@Override
PROCEDURE Remove__ (
   info_       OUT VARCHAR2,
   objid_      IN  VARCHAR2,
   objversion_ IN  VARCHAR2,
   action_     IN  VARCHAR2 )
IS
   remrec_ SHIPMENT_FREIGHT_CHARGE_TAB%ROWTYPE;
BEGIN
   IF (action_ = 'DO') THEN
      remrec_ := Get_Object_By_Id___(objid_);
   END IF;
   super(info_, objid_, objversion_, action_);
   IF (action_ = 'DO') THEN
      Source_Tax_Item_Order_API.Remove_Tax_Items(remrec_.company, Tax_Source_API.DB_SHIPMENT_FREIGHT_CHARGE, TO_CHAR(remrec_.shipment_id), 
                                                 TO_CHAR(remrec_.sequence_no), '*', '*', '*' );
      info_ := info_ || Client_SYS.Get_All_Info;
   END IF;
END Remove__;


-- Check_Delivery_Type__
--   Checks if delivery_type exists. If found, print an error message.
--   Used for restricted delete check when removing delivery_type (INVOIC-module).
PROCEDURE Check_Delivery_Type__ (
   key_list_ IN VARCHAR2 )
IS
   company_       VARCHAR2(20);
   delivery_type_ SHIPMENT_FREIGHT_CHARGE_TAB.delivery_type%TYPE;
   found_         NUMBER;

   CURSOR exist_control IS
      SELECT 1
      FROM   SHIPMENT_FREIGHT_CHARGE_TAB
      WHERE  company = company_
      AND    delivery_type = delivery_type_;
BEGIN

   company_ := SUBSTR(key_list_, 1, INSTR(key_list_, '^') - 1);
   delivery_type_ := SUBSTR(key_list_, INSTR(key_list_, '^') + 1, INSTR(key_list_, '^' , 1, 2) - (INSTR(key_list_, '^') + 1));

   OPEN exist_control;
   FETCH exist_control INTO found_;
   IF (exist_control%NOTFOUND) THEN
      found_ := 0;
   END IF;
   CLOSE exist_control;
   IF found_ = 1 THEN
      Error_SYS.Record_General(lu_name_, 'NO_DEL_TYPE: Delivery Type :P1 exists on one or several shipment freight charge(s)', delivery_type_ );
   END IF;
END Check_Delivery_Type__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


PROCEDURE New (
   attr_ IN OUT VARCHAR2)
IS
   newrec_      SHIPMENT_FREIGHT_CHARGE_TAB%ROWTYPE;
   objid_       VARCHAR2(2000);
   objversion_  VARCHAR2(2000);
   indrec_      Indicator_Rec;
BEGIN
   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);
END New;


PROCEDURE Modify (
   attr_        IN OUT VARCHAR2,
   shipment_id_ IN NUMBER,
   sequence_no_ IN NUMBER )
IS
   objid_        VARCHAR2(2000);
   objversion_   VARCHAR2(2000);
   oldrec_       SHIPMENT_FREIGHT_CHARGE_TAB%ROWTYPE;
   newrec_       SHIPMENT_FREIGHT_CHARGE_TAB%ROWTYPE;
   indrec_       Indicator_Rec;
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, shipment_id_, sequence_no_);
   oldrec_ := Lock_By_Id___(objid_, objversion_);
   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_);
END Modify;


PROCEDURE Remove (
   shipment_id_   IN NUMBER,
   sequence_no_   IN NUMBER )
IS
   remrec_     SHIPMENT_FREIGHT_CHARGE_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN
   remrec_ := Lock_By_Keys___(shipment_id_, sequence_no_);
   Check_Delete___(remrec_);
   Get_Id_Version_By_Keys___(objid_, objversion_, shipment_id_, sequence_no_);
   Delete___(objid_, remrec_);
   Source_Tax_Item_Order_API.Remove_Tax_Items(remrec_.company, Tax_Source_API.DB_SHIPMENT_FREIGHT_CHARGE, TO_CHAR(shipment_id_), 
                                                 TO_CHAR(sequence_no_), '*', '*', '*' );
END Remove;


PROCEDURE Calculate_Shipment_Charges (
   shipment_id_  IN NUMBER,
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   factor_       IN NUMBER )
IS
   order_line_rec_        Customer_Order_Line_API.Public_Rec;
   shipment_rec_          Shipment_API.Public_Rec;
   shipment_freight_rec_  Shipment_Freight_API.Public_Rec; 
   del_term_rec_           Order_Delivery_Term_API.Public_Rec;

   sequence_no_                 NUMBER;
   use_shipment_freight_charge_ VARCHAR2(5) := 'FALSE';

   fee_code_               VARCHAR2(10);
   tax_liability_          VARCHAR2(20);
   customer_order_rec_     Customer_Order_API.Public_Rec;
   ship_freight_attr_      VARCHAR2(32000);
   ship_freight_info_      VARCHAR2(32000);
   int_cust_currency_code_ VARCHAR2(3);
   
   CURSOR get_shipment_charge_data IS
      SELECT MIN(sequence_no)
      FROM  SHIPMENT_FREIGHT_CHARGE_TAB
      WHERE manualy_created = 'N'
      AND   shipment_id = shipment_id_;

   CURSOR get_charge_data IS
      SELECT coc.sequence_no, coc.tax_code
      FROM  customer_order_charge_tab coc, sales_charge_type_tab sct
      WHERE coc.order_no = order_no_
      AND   coc.line_no = line_no_
      AND   coc.rel_no = rel_no_
      AND   coc.line_item_no = line_item_no_
      AND   coc.charge_type = sct.charge_type
      AND   coc.contract = sct.contract
      AND   sct.sales_chg_type_category = 'FREIGHT';

BEGIN
   order_line_rec_              := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);
   shipment_rec_                := Shipment_API.Get(shipment_id_);
   shipment_freight_rec_        := Shipment_Freight_API.Get(shipment_id_);
   del_term_rec_                := Order_Delivery_Term_API.Get(shipment_rec_.delivery_terms);
   use_shipment_freight_charge_ := Site_Discom_Info_API.Get_Shipment_Freight_Charge_Db(shipment_rec_.contract);

   IF (shipment_freight_rec_.freight_map_id IS NOT NULL AND shipment_freight_rec_.zone_id IS NOT NULL AND shipment_freight_rec_.price_list_no IS NOT NULL AND
       del_term_rec_.calculate_freight_charge = 'TRUE' AND use_shipment_freight_charge_ = 'TRUE' AND
       (order_line_rec_.adjusted_weight_gross IS NOT NULL OR order_line_rec_.line_total_qty IS NOT NULL OR order_no_ IS NULL )) THEN

      OPEN get_shipment_charge_data;
      FETCH get_shipment_charge_data INTO sequence_no_;
      CLOSE get_shipment_charge_data;

      IF sequence_no_ IS NULL THEN
         IF (order_line_rec_.demand_code = 'IPD') THEN
            customer_order_rec_ := Customer_Order_API.Get(order_no_);   
            tax_liability_      := Tax_Handling_Util_API.Get_Customer_Tax_Liability(order_line_rec_.customer_no, NVL(customer_order_rec_.bill_addr_no, customer_order_rec_.ship_addr_no), Site_API.Get_Company(shipment_rec_.contract), shipment_freight_rec_.supply_country);  
                                                                                                          
            OPEN get_charge_data;
            FETCH get_charge_data INTO sequence_no_, fee_code_;
            CLOSE get_charge_data;
            
            int_cust_currency_code_ := Cust_Ord_Customer_API.Get_Currency_Code(customer_order_rec_.customer_no);
            IF (shipment_freight_rec_.currency_code != int_cust_currency_code_) THEN
               Client_SYS.Clear_Attr(ship_freight_attr_);
               Client_SYS.Add_To_Attr('CURRENCY_CODE', int_cust_currency_code_, ship_freight_attr_);
               Shipment_Freight_API.Modify(ship_freight_info_, ship_freight_attr_, shipment_id_);
            END IF;                        
         END IF;
         --New charge line
         New_Shipment_Charge___(shipment_id_, order_no_, line_no_, rel_no_, line_item_no_,
                                shipment_freight_rec_.freight_map_id, shipment_freight_rec_.zone_id, shipment_freight_rec_.price_list_no, fee_code_, tax_liability_);
      ELSE
         --Modify existing charge line
         IF (Get_Collect_Db(shipment_id_, sequence_no_) = Collect_API.DB_INVOICE OR 
            (Get_Collect_Db(shipment_id_, sequence_no_) = Collect_API.DB_COLLECT AND shipment_rec_.rowstate != 'Closed')) THEN
            Modify_Shipment_Charges___(shipment_id_, sequence_no_, order_no_, line_no_, rel_no_, line_item_no_,
                                       shipment_freight_rec_.price_list_no, factor_);         
            IF (Check_Exist___(shipment_id_, sequence_no_)) THEN                           
               Modify_Prices___(shipment_id_, sequence_no_);
            END IF;
         END IF;
      END IF;

      IF (NOT (order_line_rec_.Qty_Invoiced != 0 AND order_line_rec_.rowstate = 'PartiallyDelivered' )) THEN
         -- Delete the charge record from Customer Order charge table
         FOR rec_ IN get_charge_data LOOP
            Customer_Order_Charge_API.Remove(order_no_, rec_.sequence_no);
         END LOOP;
      END IF;
      
      IF Customer_Order_API.Get_Objstate(order_no_) != 'Planned' THEN
         Customer_Order_Charge_Util_API.Consolidate_Grouped_Charges(order_no_,
                                                                    NULL,
                                                                    order_line_rec_.planned_ship_date,
                                                                    order_line_rec_.zone_id,
                                                                    order_line_rec_.delivery_terms,
                                                                    order_line_rec_.freight_price_list_no,
                                                                    order_line_rec_.demand_code);
      END IF;
   END IF;
END Calculate_Shipment_Charges;


-- Recalculate_Freight_Charges
--   Remove the exiting charge lines and calculates freight charges for the
--   connected order lines from the scratch
PROCEDURE Recalculate_Freight_Charges (
   shipment_id_  IN NUMBER )
IS
   CURSOR get_lines IS
      SELECT source_ref1, source_ref2, source_ref3, source_ref4
      FROM   shipment_line_pub
      WHERE  shipment_id = shipment_id_
      AND    source_ref_type_db = 'CUSTOMER_ORDER';
      
   CURSOR get_charge_lines IS
      SELECT sequence_no
      FROM   SHIPMENT_FREIGHT_CHARGE_TAB
      WHERE  shipment_id = shipment_id_
      AND    manualy_created = 'N';
      
   shipment_rec_  Shipment_API.Public_Rec;
   del_term_rec_  Order_Delivery_Term_API.Public_Rec;
BEGIN

   shipment_rec_ := Shipment_API.Get(shipment_id_);   
   del_term_rec_ := Order_Delivery_Term_API.Get(shipment_rec_.delivery_terms);

   FOR rec_ IN get_charge_lines LOOP
      Shipment_Freight_Charge_API.Remove(shipment_id_, 
                                         rec_.sequence_no);    
   END LOOP;
   IF (del_term_rec_.calculate_freight_charge = 'TRUE') THEN
      -- It's necessary to calculate shipment charges line vise since we need the
      -- the line details to find freight free information
      FOR rec_ IN get_lines LOOP
         Shipment_Freight_Charge_API.Calculate_Shipment_Charges(shipment_id_,
                                                                rec_.source_ref1,
                                                                rec_.source_ref2,
                                                                rec_.source_ref3,
                                                                rec_.source_ref4,
                                                                1);
           
      END LOOP;
   END IF;
END Recalculate_Freight_Charges;


PROCEDURE Update_Fix_Del_Freight_Charge (
   shipment_id_ IN NUMBER )
IS
   CURSOR get_freight_charges IS
      SELECT *
      FROM  SHIPMENT_FREIGHT_CHARGE_TAB
      WHERE shipment_id = shipment_id_
      AND   manualy_created = 'N';

   CURSOR get_connected_orders IS
      SELECT source_ref1, source_ref2, source_ref3, source_ref4
      FROM   shipment_line_pub
      WHERE  shipment_id = shipment_id_
      AND    source_ref_type_db = 'CUSTOMER_ORDER';
      
   shipment_freight_rec_ Shipment_Freight_API.Public_Rec; 
BEGIN
   shipment_freight_rec_ := Shipment_Freight_API.Get(shipment_id_);
   
   IF shipment_freight_rec_.apply_fix_deliv_freight = 'TRUE' THEN
      -- Delete existing automatically created charge lines
      FOR rec_ IN get_freight_charges LOOP
         Remove(shipment_id_, rec_.sequence_no);
      END LOOP;
      -- Add new charge line for fixed delivery freight
      Calculate_Shipment_Charges(shipment_id_, NULL, NULL, NULL, NULL, 1);
   ELSE
      -- Delete existing fixed delivery freight charge line
      FOR rec_ IN get_freight_charges LOOP
         Remove(shipment_id_, rec_.sequence_no);
      END LOOP;
      -- Add new charge lines for connected orders
      FOR conn_rec_ IN get_connected_orders LOOP
         Calculate_Shipment_Charges(shipment_id_, conn_rec_.source_ref1, conn_rec_.source_ref2, conn_rec_.source_ref3, conn_rec_.source_ref4, 1);
      END LOOP;
   END IF;

END Update_Fix_Del_Freight_Charge;


-- Modify_Fee_Code
--   This method will only modify the fee code in the charge line.
--   We do not use unpack_check_update___ here, because we do not want to
--   make all the unpack checks in this case, we also gain some
--   performance by bypassing unpack.
PROCEDURE Modify_Fee_Code (
   shipment_id_  IN NUMBER,
   sequence_no_  IN NUMBER,
   fee_code_     IN VARCHAR2 )
IS
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   newrec_     SHIPMENT_FREIGHT_CHARGE_TAB%ROWTYPE;
   oldrec_     SHIPMENT_FREIGHT_CHARGE_TAB%ROWTYPE;
   attr_       VARCHAR2(2000);
BEGIN
   oldrec_ := Lock_By_Keys___(shipment_id_, sequence_no_);
   newrec_ := oldrec_;
   newrec_.fee_code := fee_code_;
   Client_SYS.Add_To_Attr('TAX_LINES_UPDATED', 'TRUE', attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
END Modify_Fee_Code;


-- Remove_Freight_Charges
--   This removes all the shipment freight charges when there are no order lines connected to a shipment.
PROCEDURE Remove_Freight_Charges (
   shipment_id_ IN NUMBER)
IS
   CURSOR get_freight_charges IS
      SELECT sequence_no
      FROM   shipment_freight_charge_tab
      WHERE  shipment_id = shipment_id_;
BEGIN
   FOR rec_ IN get_freight_charges LOOP
      Remove(shipment_id_, rec_.sequence_no);
   END LOOP;    
END Remove_Freight_Charges;


PROCEDURE Process_Freight_On_Ship_Update (
   shipment_id_                     IN VARCHAR2,
   recalculate_freight_charges_     IN VARCHAR2,
   update_currency_                 IN VARCHAR2,
   update_fix_del_freight_charge_   IN VARCHAR2,
   calculate_shipment_charges_      IN VARCHAR2)
IS   
BEGIN
   IF(recalculate_freight_charges_ = Fnd_Boolean_API.DB_TRUE) THEN
      Recalculate_Freight_Charges(shipment_id_);
   END IF;
   IF(update_currency_ = Fnd_Boolean_API.DB_TRUE) THEN   
      Update_Currency___(shipment_id_);
   END IF;
   IF(update_fix_del_freight_charge_ = Fnd_Boolean_API.DB_TRUE) THEN
      Update_Fix_Del_Freight_Charge(shipment_id_);
   END IF;
   IF(calculate_shipment_charges_ = Fnd_Boolean_API.DB_TRUE) THEN  
      Calculate_Shipment_Charges(shipment_id_, NULL, NULL, NULL, NULL, 1);
   END IF;
END Process_Freight_On_Ship_Update;


PROCEDURE Post_Delete_Ship_Line (
   shipment_id_  IN NUMBER,
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER )
IS    
   connected_lines_exist_ NUMBER;
   coline_rec_            customer_order_line_tab%ROWTYPE;
   
   CURSOR get_coline IS
      SELECT *
        FROM customer_order_line_tab
       WHERE order_no     = order_no_
         AND line_no      = line_no_
         AND rel_no       = rel_no_
         AND line_item_no = line_item_no_;
BEGIN
   connected_lines_exist_ := Shipment_API.Connected_Lines_Exist(shipment_id_);
   -- IF no order lines connected to the shipment remove all the freight charges and update supply country of the shipment to null
   IF (connected_lines_exist_ = 0) THEN
      Shipment_Freight_Charge_API.Remove_Freight_Charges(shipment_id_);
   ELSE
      -- Recalculate the Shipment Freight Charge
      Shipment_Freight_Charge_API.Calculate_Shipment_Charges(shipment_id_, order_no_, line_no_, rel_no_, line_item_no_, -1);
   END IF;
   IF (Customer_Order_Line_API.Get_Objstate(order_no_, line_no_, rel_no_, line_item_no_) NOT IN ('Cancelled', 'Invoiced')) THEN
      -- Create Customer Order Charges
      OPEN get_coline;
      FETCH get_coline INTO coline_rec_;
      IF get_coline%FOUND THEN
         Customer_Order_Charge_Util_API.New_Cust_Order_Charge_Line(coline_rec_, TRUE);
      END IF;
      CLOSE get_coline;
   END IF;
END Post_Delete_Ship_Line;


--   *** This method is dynamically called from Tax_Handling_Order_Util_API. ***
@UncheckedAccess
 FUNCTION Fetch_Tax_Line_Param(   
   company_                IN VARCHAR2,
   source_ref1_            IN VARCHAR2,
   source_ref2_            IN VARCHAR2,
   source_ref3_            IN VARCHAR2,
   source_ref4_            IN VARCHAR2) RETURN Tax_Handling_Order_Util_API.tax_line_param_rec
IS
   shipment_rec_              Shipment_API.Public_Rec; 
   shipment_freight_rec_      Shipment_Freight_API.Public_Rec;
   tax_line_param_rec_        Tax_Handling_Order_Util_API.tax_line_param_rec;
   ship_freight_chg_rec_      Shipment_Freight_Charge_API.Public_Rec; 
   curr_type_              VARCHAR2(10);
   currency_conv_factor_   NUMBER;
   currency_rate_          NUMBER;
BEGIN
   shipment_rec_         := Shipment_API.Get(source_ref1_);
   shipment_freight_rec_ := Shipment_Freight_API.Get(source_ref1_);
   ship_freight_chg_rec_ := Shipment_Freight_Charge_API.Get(source_ref1_, source_ref2_);
   
   tax_line_param_rec_.company             := company_;
   tax_line_param_rec_.contract            := shipment_rec_.contract;
   tax_line_param_rec_.customer_no         := shipment_rec_.receiver_id;
   tax_line_param_rec_.ship_addr_no        := shipment_rec_.receiver_addr_id;
   tax_line_param_rec_.planned_ship_date   := TRUNC(Site_API.Get_Site_Date(shipment_rec_.contract));
   tax_line_param_rec_.supply_country_db   := shipment_freight_rec_.supply_country;
   tax_line_param_rec_.delivery_type       := NVL(ship_freight_chg_rec_.delivery_type, '*');
   tax_line_param_rec_.object_id           := ship_freight_chg_rec_.charge_type;
   tax_line_param_rec_.use_price_incl_tax  := shipment_freight_rec_.use_price_incl_tax;
   tax_line_param_rec_.currency_code       := NVL(shipment_freight_rec_.currency_code, Company_Finance_API.Get_Currency_Code(company_));
   
   Invoice_Library_API.Get_Currency_Rate_Defaults(curr_type_, currency_conv_factor_, currency_rate_, company_, tax_line_param_rec_.currency_code,
                                                  Site_API.Get_Site_Date(shipment_rec_.contract), 'CUSTOMER', shipment_rec_.receiver_id);
   
   tax_line_param_rec_.currency_rate         := (currency_rate_ / currency_conv_factor_);   
   tax_line_param_rec_.tax_liability         := ship_freight_chg_rec_.tax_liability;
   tax_line_param_rec_.tax_liability_type_db := Tax_Liability_API.Get_Tax_Liability_Type_Db(ship_freight_chg_rec_.tax_liability, shipment_rec_.receiver_country);
   tax_line_param_rec_.tax_code              := ship_freight_chg_rec_.fee_code;
   tax_line_param_rec_.tax_calc_structure_id := ship_freight_chg_rec_.tax_calc_structure_id;
   tax_line_param_rec_.tax_class_id          := ship_freight_chg_rec_.tax_class_id;
   tax_line_param_rec_.taxable               := Sales_Charge_Type_API.Get_Taxable_Db(shipment_rec_.contract, ship_freight_chg_rec_.charge_type);
      
   RETURN tax_line_param_rec_;
   
END Fetch_Tax_Line_Param;

--   *** This method is dynamically called from Tax_Handling_Order_Util_API. ***
@UncheckedAccess
PROCEDURE Fetch_Gross_Net_Tax_Amounts(
   gross_curr_amount_      OUT NUMBER,
   net_curr_amount_        OUT NUMBER,
   tax_curr_amount_        OUT NUMBER,
   company_                IN VARCHAR2,
   source_ref1_            IN VARCHAR2,
   source_ref2_            IN VARCHAR2,
   source_ref3_            IN VARCHAR2,
   source_ref4_            IN VARCHAR2) 
IS    
BEGIN
   gross_curr_amount_ := Shipment_Freight_Charge_API.Get_Total_Charge_Amnt_Incl_Tax(source_ref1_, source_ref2_);
   net_curr_amount_   := Shipment_Freight_Charge_API.Get_Total_Charged_Amount(source_ref1_, source_ref2_);
   tax_curr_amount_   := Shipment_Freight_Charge_API.Get_Total_Tax_Amount_Curr(source_ref1_, source_ref2_);  
END Fetch_Gross_Net_Tax_Amounts;

--   *** This method is dynamically called from Tax_Handling_Order_Util_API. ***
@UncheckedAccess
PROCEDURE Get_Tax_Info (
   attr_          OUT VARCHAR2,
   source_ref1_   IN VARCHAR2,
   source_ref2_   IN VARCHAR2,
   source_ref3_   IN VARCHAR2,
   source_ref4_   IN VARCHAR2)
IS
   ship_freight_chg_rec_   shipment_freight_charge_tab%ROWTYPE;
   shipment_rec_           Shipment_API.Public_Rec; 
   shipment_freight_rec_   Shipment_Freight_API.Public_Rec;
BEGIN
   ship_freight_chg_rec_ := Get_Object_By_Keys___(source_ref1_, source_ref2_);
   shipment_rec_         := Shipment_API.Get(source_ref1_);
   shipment_freight_rec_ := Shipment_Freight_API.Get(source_ref1_);
   
   Client_SYS.Set_Item_Value('TAX_CODE', ship_freight_chg_rec_.fee_code, attr_);
   Client_SYS.Set_Item_Value('TAX_CLASS_ID', ship_freight_chg_rec_.tax_class_id, attr_);
      
   Client_SYS.Set_Item_Value('TAX_LIABILITY', ship_freight_chg_rec_.tax_liability, attr_);   
   Client_SYS.Set_Item_Value('TAX_LIABILITY_TYPE_DB', Tax_Liability_API.Get_Tax_Liability_Type_Db(ship_freight_chg_rec_.tax_liability, 
                                                      shipment_rec_.receiver_country), attr_);   
   Client_SYS.Set_Item_Value('DELIVERY_COUNTRY_DB', shipment_rec_.receiver_country, attr_);
   Client_SYS.Set_Item_Value('IS_TAXABLE_DB', Sales_Charge_Type_API.Get_Taxable_Db(ship_freight_chg_rec_.contract, ship_freight_chg_rec_.charge_type), attr_);
   Client_SYS.Set_Item_Value('TAX_LIABILITY_DATE', TRUNC(Site_API.Get_Site_Date(ship_freight_chg_rec_.contract)), attr_);
   Client_SYS.Set_Item_Value('SHIP_ADDR_NO', shipment_rec_.receiver_addr_id, attr_);
   Client_SYS.Set_Item_Value('PLANNED_SHIP_DATE', TRUNC(Site_API.Get_Site_Date(ship_freight_chg_rec_.contract)), attr_);
   Client_SYS.Set_Item_Value('SUPPLY_COUNTRY_DB', shipment_freight_rec_.supply_country , attr_);
   Client_SYS.Set_Item_Value('DELIVERY_TYPE',  NVL(ship_freight_chg_rec_.delivery_type, '*'), attr_);
END Get_Tax_Info;


--   *** This method is dynamically called from Tax_Handling_Order_Util_API. ***
@UncheckedAccess
PROCEDURE Get_External_Tax_Info (
   attr_          OUT VARCHAR2,
   source_ref1_   IN VARCHAR2,
   source_ref2_   IN VARCHAR2,
   source_ref3_   IN VARCHAR2,
   source_ref4_   IN VARCHAR2,
   company_       IN VARCHAR2)
IS
   ship_freight_chg_rec_   shipment_freight_charge_tab%ROWTYPE;
BEGIN   
   ship_freight_chg_rec_  := Get_Object_By_Keys___(source_ref1_, source_ref2_);
   Client_SYS.Set_Item_Value('QUANTITY', ship_freight_chg_rec_.charged_qty, attr_); 
END Get_External_Tax_Info;


-- Modify_Tax_Info
--   Modifies the tax information with the tax line tax information at the same time.
--   *** This method is dynamically called from Tax_Handling_Order_Util_API. ***
PROCEDURE Modify_Tax_Info (
   attr_         IN OUT VARCHAR2,
   source_ref1_  IN VARCHAR2,
   source_ref2_  IN VARCHAR2,
   source_ref3_  IN VARCHAR2,
   source_ref4_  IN VARCHAR2 )
IS
   objid_            VARCHAR2(2000);
   objversion_       VARCHAR2(2000);
   oldrec_           shipment_freight_charge_tab%ROWTYPE;
   newrec_           shipment_freight_charge_tab%ROWTYPE;   
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, source_ref1_, source_ref2_);
   oldrec_ := Lock_By_Id___(objid_, objversion_);
   newrec_ := oldrec_;
   newrec_.fee_code  := Client_Sys.Get_Item_Value('TAX_CODE', attr_);   
   newrec_.tax_class_id := Client_Sys.Get_Item_Value('TAX_CLASS_ID', attr_);
   newrec_.tax_calc_structure_id  := Client_Sys.Get_Item_Value('TAX_CALC_STRUCTURE_ID', attr_);
   Client_SYS.Add_To_Attr('TAX_LINES_UPDATED', 'TRUE', attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_);
END Modify_Tax_Info;


--   *** This method is dynamically called from Tax_Handling_Order_Util_API. ***
PROCEDURE Validate_Source_Pkg_Info (
   source_ref1_  IN VARCHAR2,
   source_ref2_  IN VARCHAR2,
   source_ref3_  IN VARCHAR2,
   source_ref4_  IN VARCHAR2,
   attr_         IN VARCHAR2 )
IS     
   error_                     BOOLEAN := FALSE;
BEGIN
   IF (Shipment_API.Get_Objstate(source_ref1_) = 'Cancelled') THEN
      error_ := TRUE;
   ELSIF (Shipment_Freight_API.Get_Freight_Chg_Invoiced_Db(source_ref1_) = 'TRUE') THEN
      error_ := TRUE;
   END IF;
   IF error_ THEN
      Error_SYS.Record_General(lu_name_, 'INVOICED_LINE: Tax lines can not be altered when the shipment has been been Cancelled or Invoiced.');
   END IF;    
END Validate_Source_Pkg_Info;

--   *** This method is dynamically called from Tax_Handling_Order_Util_API. ***
@UncheckedAccess
FUNCTION Get_Price_Total (
   source_ref1_   IN VARCHAR2,
   source_ref2_   IN VARCHAR2,
   source_ref3_   IN VARCHAR2,
   source_ref4_   IN VARCHAR2) RETURN NUMBER
IS
BEGIN
   RETURN Get_Total_Charged_Amount(source_ref1_, source_ref2_);
END Get_Price_Total;


--   *** This method is dynamically called from Tax_Handling_Order_Util_API. ***
@UncheckedAccess
FUNCTION Get_Price_Incl_Tax_Total  (
   source_ref1_   IN VARCHAR2,
   source_ref2_   IN VARCHAR2,
   source_ref3_   IN VARCHAR2,
   source_ref4_   IN VARCHAR2) RETURN NUMBER
IS
BEGIN
   RETURN Get_Total_Charge_Amnt_Incl_Tax (source_ref1_, source_ref2_);
END Get_Price_Incl_Tax_Total ;


@UncheckedAccess
FUNCTION Get_Total_Tax_Amount_Curr (
   shipment_id_ IN NUMBER,
   sequence_no_ IN NUMBER ) RETURN NUMBER
IS
   total_tax_amount_    NUMBER :=0;
   rounding_            NUMBER;
   company_             VARCHAR2(20);
   currency_code_       VARCHAR2(3);
BEGIN
   company_          := Get_Company(shipment_id_, sequence_no_);
   currency_code_    := NVL(Shipment_Freight_API.Get_Currency_Code(shipment_id_), Company_Finance_API.Get_Currency_Code(company_));
   rounding_         := Currency_Code_API.Get_Currency_Rounding(company_, currency_code_);
   total_tax_amount_ := Source_Tax_Item_API.Get_Total_Tax_Curr_Amount(company_, 
                                                                      Tax_Source_API.DB_SHIPMENT_FREIGHT_CHARGE,
                                                                      TO_CHAR(shipment_id_),
                                                                      TO_CHAR(sequence_no_),
                                                                      '*',
                                                                      '*',
                                                                      '*');
   total_tax_amount_ := ROUND(total_tax_amount_, rounding_);
   RETURN NVL(total_tax_amount_, 0);
END Get_Total_Tax_Amount_Curr ;


@UncheckedAccess
FUNCTION Get_Total_Tax_Amount_Base (
   shipment_id_ IN NUMBER,
   sequence_no_ IN NUMBER ) RETURN NUMBER
IS   
   company_          VARCHAR2(20);   
   total_tax_amount_ NUMBER := 0;
   rounding_         NUMBER;
   currency_code_    VARCHAR2(3);
BEGIN
   company_       := Get_Company(shipment_id_, sequence_no_);
   currency_code_ := NVL(Shipment_Freight_API.Get_Currency_Code(shipment_id_), Company_Finance_API.Get_Currency_Code(company_));
   rounding_      := Currency_Code_API.Get_Currency_Rounding(company_, currency_code_);

   total_tax_amount_ := Source_Tax_Item_API.Get_Total_Tax_Dom_Amount(company_, 
                                                               Tax_Source_API.DB_SHIPMENT_FREIGHT_CHARGE,
                                                               TO_CHAR(shipment_id_),
                                                               TO_CHAR(sequence_no_),
                                                               '*',
                                                               '*',
                                                               '*');
   total_tax_amount_ := ROUND(total_tax_amount_, rounding_);
   RETURN NVL(total_tax_amount_, 0);
END Get_Total_Tax_Amount_Base;


@UncheckedAccess
FUNCTION Get_Total_Charged_Amount (
   shipment_id_ IN NUMBER,
   sequence_no_ IN NUMBER ) RETURN NUMBER
IS
   total_charged_amount_ NUMBER;
   rec_                  shipment_freight_charge_tab%ROWTYPE;
   rounding_             NUMBER;
   currency_code_        VARCHAR2(3);
BEGIN
   IF Shipment_Freight_API.Get_Use_Price_Incl_Tax_Db(shipment_id_) = 'FALSE' THEN
      rec_                := Get_Object_By_Keys___(shipment_id_, sequence_no_);
      currency_code_      := NVL(Shipment_Freight_API.Get_Currency_Code(shipment_id_), Company_Finance_API.Get_Currency_Code(rec_.company));
      rounding_           := Currency_Code_API.Get_Currency_Rounding(rec_.company, currency_code_);
      total_charged_amount_ := ROUND((rec_.charge_amount * rec_.charged_qty), rounding_);
   ELSE
      total_charged_amount_ := Get_Total_Charge_Amnt_Incl_Tax(shipment_id_, sequence_no_) - Get_Total_Tax_Amount_Curr(shipment_id_, sequence_no_);
   END IF;   
   RETURN NVL(total_charged_amount_, 0);
END Get_Total_Charged_Amount;


@UncheckedAccess
FUNCTION Get_Total_Charge_Amnt_Incl_Tax (
   shipment_id_ IN NUMBER,
   sequence_no_ IN NUMBER ) RETURN NUMBER
IS
   total_chrg_incl_tax_  NUMBER;
   rec_                  shipment_freight_charge_tab%ROWTYPE;
   rounding_             NUMBER;
   currency_code_        VARCHAR2(3);
BEGIN
   IF Shipment_Freight_API.Get_Use_Price_Incl_Tax_Db(shipment_id_) = 'FALSE' THEN
      total_chrg_incl_tax_ := Get_Total_Charged_Amount(shipment_id_, sequence_no_) + Get_Total_Tax_Amount_Curr(shipment_id_, sequence_no_);
   ELSE
      rec_                := Get_Object_By_Keys___(shipment_id_, sequence_no_);
      currency_code_      := NVL(Shipment_Freight_API.Get_Currency_Code(shipment_id_), Company_Finance_API.Get_Currency_Code(rec_.company));
      rounding_           := Currency_Code_API.Get_Currency_Rounding(rec_.company, currency_code_);
      total_chrg_incl_tax_ := ROUND((rec_.charge_amount_incl_tax * rec_.charged_qty), rounding_);
   END IF;     
   total_chrg_incl_tax_ := NVL(total_chrg_incl_tax_, 0);   
   RETURN NVL(total_chrg_incl_tax_, 0);
END Get_Total_Charge_Amnt_Incl_Tax;


@UncheckedAccess
FUNCTION Get_Total_Base_Amnt_Incl_Tax (
   shipment_id_ IN NUMBER,
   sequence_no_ IN NUMBER  ) RETURN NUMBER
IS
   total_base_amnt_incl_tax_ NUMBER;
   rounding_                 NUMBER;
   rec_                      shipment_freight_charge_tab%ROWTYPE;
   currency_code_            VARCHAR2(3);
BEGIN
   IF Shipment_Freight_API.Get_Use_Price_Incl_Tax_Db(shipment_id_) = 'FALSE' THEN
      total_base_amnt_incl_tax_ := Get_Total_Base_Charged_Amount(shipment_id_, sequence_no_) + Get_Total_Tax_Amount_Base(shipment_id_, sequence_no_);
   ELSE
      rec_ := Get_Object_By_Keys___(shipment_id_, sequence_no_);
      currency_code_ := NVL(Shipment_Freight_API.Get_Currency_Code(shipment_id_), Company_Finance_API.Get_Currency_Code(rec_.company));
      rounding_ := Currency_Code_API.Get_Currency_Rounding(rec_.company, currency_code_);
      total_base_amnt_incl_tax_ := ROUND((rec_.base_charge_amt_incl_tax * rec_.charged_qty), rounding_);
   END IF;   
   RETURN NVL(total_base_amnt_incl_tax_, 0);
END Get_Total_Base_Amnt_Incl_Tax;


@UncheckedAccess
FUNCTION Get_Total_Base_Charged_Amount (
   shipment_id_ IN NUMBER,
   sequence_no_ IN NUMBER ) RETURN NUMBER
IS
   total_base_charged_amount_ NUMBER;
   rounding_                  NUMBER;
   rec_                       shipment_freight_charge_tab%ROWTYPE;
   currency_code_             VARCHAR2(3);
BEGIN
   IF Shipment_Freight_API.Get_Use_Price_Incl_Tax_Db(shipment_id_) = 'FALSE' THEN
      rec_ := Get_Object_By_Keys___(shipment_id_, sequence_no_);
      currency_code_ := NVL(Shipment_Freight_API.Get_Currency_Code(shipment_id_), Company_Finance_API.Get_Currency_Code(rec_.company));
      rounding_   := Currency_Code_API.Get_Currency_Rounding(rec_.company, currency_code_);
      total_base_charged_amount_ := ROUND((rec_.base_charge_amount * rec_.charged_qty), rounding_);
   ELSE
      total_base_charged_amount_ := Get_Total_Base_Amnt_Incl_Tax(shipment_id_, sequence_no_) - Get_Total_Tax_Amount_Base(shipment_id_, sequence_no_);
   END IF;
   RETURN NVL(total_base_charged_amount_, 0);
END Get_Total_Base_Charged_Amount;

-- Get_Line_Address_Info
--   Returns Shipment Freight Charge, customer(receiver) Address information.
--   *** This method is dynamically called from Tax_Handling_Order_Util_API. ***
PROCEDURE Get_Line_Address_Info (
   address1_      OUT VARCHAR2,
   address2_      OUT VARCHAR2,
   country_code_  OUT VARCHAR2,
   city_          OUT VARCHAR2,
   state_         OUT VARCHAR2,
   zip_code_      OUT VARCHAR2,
   county_        OUT VARCHAR2,
   in_city_       OUT VARCHAR2,
   source_ref1_   IN  VARCHAR2,
   source_ref2_   IN  VARCHAR2,
   source_ref3_   IN  VARCHAR2,
   source_ref4_   IN  VARCHAR2,
   company_       IN  VARCHAR2)
IS
   shipment_rec_  Shipment_API.Public_Rec;
BEGIN
   shipment_rec_  := Shipment_API.Get(source_ref1_);
   address1_      := shipment_rec_.receiver_address1;
   address2_      := shipment_rec_.receiver_address2;
   country_code_  := shipment_rec_.receiver_country;
   city_          := shipment_rec_.receiver_city;
   state_         := shipment_rec_.receiver_state;
   zip_code_      := shipment_rec_.receiver_zip_code;
   county_        := shipment_rec_.receiver_county;
   in_city_       := NULL;
END Get_Line_Address_Info;

-- Get_Tax_Liability_Type_Db
--   Returns tax liability type db value
@UncheckedAccess
FUNCTION Get_Tax_Liability_Type_Db (
   shipment_id_ IN NUMBER,
   sequence_no_ IN NUMBER ) RETURN VARCHAR2
IS
BEGIN      
   RETURN Tax_Liability_API.Get_Tax_Liability_Type_Db(Shipment_Freight_Charge_API.Get_Tax_Liability(shipment_id_, sequence_no_), 
                                                      Shipment_API.Get_Receiver_Country(shipment_id_));
END Get_Tax_Liability_Type_Db;


PROCEDURE Calculate_Shipment_Charges (
   shipment_id_tab_ IN Shipment_API.Shipment_Id_Tab )
IS
BEGIN   
   IF (shipment_id_tab_.COUNT > 0) THEN
      FOR i IN shipment_id_tab_.FIRST..shipment_id_tab_.LAST LOOP
         IF ((Shipment_API.Get_Objstate(shipment_id_tab_(i)) != 'Cancelled') AND (Shipment_Freight_API.Get_Freight_Chg_Invoiced_Db(shipment_id_tab_(i)) = 'FALSE')) THEN
            Calculate_Shipment_Charges(shipment_id_tab_(i), NULL, NULL, NULL, NULL, 1);
         END IF;          
      END LOOP;
   END IF;  
END Calculate_Shipment_Charges;

-- Calculate_Freight_Charges
--   This method will find all shipments having this sales part no and, calculate freight charges for them
PROCEDURE Calculate_Freight_Charges (
   catalog_no_ IN VARCHAR2 )
IS
   CURSOR get_shipment_id IS
      SELECT DISTINCT sl.shipment_id
      FROM shipment_line_pub sl,
           customer_order_line_tab col
      WHERE sl.source_ref1 = col.order_no
      AND   sl.source_ref2 = col.line_no
      AND   sl.source_ref3 = col.rel_no
      AND   sl.source_ref4 = col.line_item_no
      AND   sl.source_ref_type_db = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER
      AND   col.catalog_no = catalog_no_;
            
   shipment_id_tab_ Shipment_API.Shipment_Id_Tab;  
BEGIN
   OPEN get_shipment_id;
   FETCH get_shipment_id BULK COLLECT INTO shipment_id_tab_;
   CLOSE get_shipment_id;

   IF (shipment_id_tab_.COUNT >0) THEN
      Calculate_Shipment_Charges(shipment_id_tab_);
   END IF;   
END Calculate_Freight_Charges;

-- Get_Objversion
--   Return the current objversion for line
FUNCTION Get_Objversion (
   shipment_id_ IN NUMBER,
   sequence_no_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_  SHIPMENT_FREIGHT_CHARGE_TAB.rowversion%TYPE;
   CURSOR get_attr IS
      SELECT rowversion
      FROM   SHIPMENT_FREIGHT_CHARGE_TAB
      WHERE shipment_id = shipment_id_
      AND   sequence_no = sequence_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN TO_CHAR(temp_, 'YYYYMMDDHH24MISS');
END Get_Objversion;
