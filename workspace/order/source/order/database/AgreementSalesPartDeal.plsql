-----------------------------------------------------------------------------
--
--  Logical unit: AgreementSalesPartDeal
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  190529  KiSalk  Bug 148507(SCZ-4995), Modified Calculate_Deal_Price___ by adding parameter calc_direction_ and making deal_price_ and deal_price_incl_tax_ of direction "IN OUT" type.
--  190511  LaThlk  Bug 142914, Modified Insert_Price_Break_Lines() to fetch the price break template from Sales_Part_Base_Price_API when the from_header_ is true.
--  181111  IzShlk  SCUXXW4-9622,  Introduced Get_Calculated_sales_price() method to fetch calculated sales price.
--  180119  CKumlk  STRSC-15930, Modified Check_Insert___, Check_Update___ and Check_Delete___ by changing Get_State() to Get_Objstate().
--  170921  NiDalk  Bug 137741, Modified Check_Common___  to set the base prices and deal prices if already not set to support data migration jobs.
--  170407  IzShlk  STRSC-4713, Handled logic in Copy_All_Sales_Part_Deals__() to select both valid_from & valid_to records only if the 
--                               "Include lines with both Valid From and Valid To dates" checkbox is checked.
--  170420  IzShlk  STRSC-4713, Added an additional parameter(raise_msg_) to Copy_All_Sales_Part_Deals__() to raise a warning msg if the new valid_from date is later than the valid_to date.
--  161012  ChFolk  STRSC-4270, Renamed method Modify_Base_Prices as Modify_Price_Info as now it support modifying of offset values, valid_to_date and sales prices as well.
--  160926  ChFolk  STRSC-3834, Added new method Modify_Valid_To_Date and modified method Modify_Offset to support modifing to given offset values.
--  160812  NWeelk  FINHR-1302, Modified Calculate_Deal_Price___ to use central logic to calculate prices.
--  160722  ChFolk  STRSC-3669, Modified get_min_date_part in Copy_All_Sales_Part_Deals__ to fetch correct lines to be copied considering the valid_to_date.
--  160722          If the valid_to_date is defined then it must be priortised.
--  160718  ChFolk  STRSC-3570, Added new function Check_Period_Overlapped___ and modified Check_Common___ to use it in validating entered from date and to date.
--  160715  ChFolk  STRSC-3631, Added new paramater valid_to_date into Insert_Price_Break_Lines.
--  160714  ChFolk  STRSC-3570, Modified Check_Common___ to add validations for entered valid_to_date.
--  151229  ThEdlk  Bug 125768, Modified Prepare_Insert__() to fetch header value for the valid_from_date when it is greater than the sysdate.
--  150914  MeAblk Bug 124475, Override Check_Delete___ and modified Check_Insert___ in order to avoid make any update to the agreement when 
--  150914         it is in 'Closed' state.
--  140615  BudKlk  Bug 121801, Modified the method Check_Insert___() in order to validate price_break_template_id.
--  150603  RuLiLk  Merged bug 121256, Modified method Modify_Prices_For_Tax to consider base_price_site when updating the agreement.
--  150214  HimRlk  PRSC-6155, Modified to bypass not allowing to update the agreement if it is in closed state, when updating from Modify_Prices_For_Tax.
--  150212  MaRalk  PRSC-5566, Modified method Update___ in order to call Agreement_Part_Discount_API.Sync_Discount_Line__  
--  150212          when the deal_price changes from NULL.
--  140430  RoJalk  Modified Update___ and added a NVL when comparing the SERVER_DATA_CHANGE value when calling Agreement_Part_Discount_API.Sync_Discount_Line__.
--  140226  AyAmlk  Bug 115495, Modified methods which use the server_data_change flag, to specified the value as 2 when changed through
--  140226          Modify_Discount__().
--  131203  SeJalk Bug 114057, Added new parameter price_break_temp_id_ as default null to Insert_Price_Break_Lines.
--  131203         Checked Tamplate id validity in Unpack_Check_Insert___.
--  130320  NaLrlk Added Sales_Price_Type_Db to Prepare_Insert___ method.
--  130115  SURBLK Added Modify_Prices_For_Tax().
--  120910  ShKolk Modified  Copy_Sales_Part_Deal_Line___() to set prices according to the use_price_incl_tax value.
--  120904  SURBLK Added base_price_incl_tax and deal_price_incl_tax in to AGREEMENT_SALES_PART_DEAL_JOIN.
--  120904  SURBLK Modified new() and Modify_Deal_Price() to add BASE_PRICE_INCL_TAX and DEAL_PRICE_INCL_TAX.
--  120829  SURBLK Added Calculate_Deal_Price___ and modified Modify_Base_Prices.
--  120822  ShKolk Added columns deal_price_incl_tax and base_price_incl_tax.
--  111116  ChJalk Modified the view AGREEMENT_SALES_PART_DEAL to use User_Finance_Auth_Pub instead of Company_Finance_Auth_Pub.
--  111020  ChJalk Modified the base view AGREEMENT_SALES_PART_DEAL to use the user allowed company filter.
--  110822  NWeelk Bug 93605, Added public method Copy to copy multiple deal per part lines.
--  110509  NWeelk Bug 96967, Added discount amounts check to the error messages NODISCANDPRICE, SALES_DISCOUNT_UPG, SALES_DISCOUNT_INS, 
--  110509         added function Discount_Amount_Exist, modified method Copy_Sales_Part_Deal_Line___ to set value for discount correctly 
--  110509         and modified method Update___ by adding discount amounts exist check before calling Sync_Discount_Line__.
--  110428  NWeelk Bug 96125, Removed discount = 0 check from the error NODISCANDPRICE since now discount can be 0 when there are 
--  110428         only discount amounts define and the deal_price in null.  
--  110325  ChJalk EANE-4849, Removed user allowed site filter from the view AGREEMENT_SALES_PART_DEAL_JOIN.
--  110322  MaMalk Replaced some of the method calls to Customer_Info_Vat_API with Customer_Delivery_Tax_Info_API.
--  110304  ChJalk EANE-3807, Added user allowed site filter to the view AGREEMENT_SALES_PART_DEAL_JOIN.
--  110208  MaMalk Replaced some of the method calls to Customer_Info_Vat_API with Customer_Tax_Info_API.
--  110204  RiLase Added method Insert_Price_Break_Lines(). Added call to Insert_Price_Break_Lines in New__.
--  100901  NaLrlk Bug 88741, Modified procedure Unpack_Check_Insert___ by initializing variable copy_record_ to FALSE. 
--  100512  Ajpelk Merge rose method documentation
--  091109  DaZase Added checks on valid_from_date in Unpack_Check_Insert___.
--  080519  MiKulk Modified the method Update___ to correctly set the values in the histpory records.
--  080508  KiSalk Added method Get_Net_Price and attribute net_price to Get().
--  080407  MaHplk Modified view comments on state column of AGREEMENT_SALES_PART_DEAL_JOIN.
--  080402  AmPalk Made last_updated to be SYSDATE, when updating.
--  080226  MaJalk Changed parameters and modified procedure New().
--  080221  MaHplk Modified view AGREEMENT_SALES_PART_DEAL_JOIN.
--  080215  MaHplk Added view AGREEMENT_SALES_PART_DEAL_JOIN.
--  080208  MaJalk Modified procedure New. Added methods Modify_Base_Price, Modify_Offset and Remove.
--  080208  KiSalk Added attribute server_data_change.
--  080121  KiSalk Made net_price a string arrtibute with reference to FndBoolean.
--  080118  AmPalk Added several default values to the Prepare_Insert___ method.
--  080117  KiSalk Added methods Modify_Discount__, Get_Disc_Line_Count_Per_Deal__ and Get_Rounding.
--  080114  MaHplk Modified method Modify_Deal_Price to find the correct record and update the deal price.
--  080114  KiSalk Made base_price_site a public attribute.
--  080104  MaJalk New keys valid_from_date and min_quantity added to the methods.
--  071224  KiSalk Added method Copy_All_Sales_Part_Deals__.
--  071129  MaJalk Added attribute base_price_site and new method Get_Base_Price_Site.
--  061102  PrPrlk Bug 61299, Modified methods Unpack_Check_Insert___ and Unpack_Check_Update___ to check for instances
--  061102         where discount percentage is entered without a discount type.
--  060515  SaRalk Enlarge Address - Changed variable definitions.
--  060419  IsWilk Enlarge Customer - Changed variable definitions.
--  050715  JaBalk Modified Modify_Deal_Price to clear the provisional price flag when updating from CO.
--  050520  SaJjlk Modified method Update__ to insert history records when provisional_price has changed.
--  050519  IsAnlk Added public methods Modify_Deal_Price and New.
--  050513  NiDalk Added column provisional_price.
--  041025  NuFilk Modified method Get_Assumed_Vat_Percentage.
--  040913  GeKalk Added public method Get_Assumed_Vat_Percentage.
--  040227  GeKalk Bug 41033, Added public method Check_Exist.
--  020304  MGUO  Bug 28288, Added check that deal_price must greater than 0.
--  020102  JICE  Added public view for Sales Configurator export.
--  020109  CaSt  Bug fix 26922, Changed discount limits in Unpack_Check_Insert___ and Unpack_Check_Update___
--                to allow negative discount.
--  990907  JOHW  Added checks where Discount_Type is Null and Discount is not.
--  990901  JOHW  Made Discount Public.
--  990830  JOHW  Changed to Discount_Type and added column.
--  990419  JoAn  Beautified the code.
--  990407  PaLj  New Yoshimura Templates
--  990209  CAST  Added note_text.
--  981113  CAST  SID 7013. Allow deal_price = NULL.
--  981102  CAST  A history record is created when deal_price is changed.
--  980130  MNYS  Changed Deal_Price to 'NOT MANDATORY'. Added check on DEAL_PRICE
--                and DISCOUNT_CLASS, both columns cannot be NULL at the same time.
--  980126  MNYS  Added function Get_Deal_Price.
--  980108  MNYS  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE Agree_Part_Deal_Rec IS RECORD
   (agreement_id AGREEMENT_SALES_PART_DEAL_TAB.agreement_id%TYPE,
    min_qty AGREEMENT_SALES_PART_DEAL_TAB.min_quantity%TYPE,
    valid_from AGREEMENT_SALES_PART_DEAL_TAB.valid_from_date%TYPE,
    catalog_no AGREEMENT_SALES_PART_DEAL_TAB.catalog_no%TYPE);

TYPE Agree_Part_Deal_Table IS TABLE OF Agree_Part_Deal_Rec INDEX BY BINARY_INTEGER;


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Find_Min_Qty_And_Date___ (
   min_quantity_     IN OUT NUMBER,
   valid_from_date_  IN OUT DATE,
   agreement_id_     IN     VARCHAR2,
   catalog_no_       IN     VARCHAR2 )
IS
   found_min_quantity_    NUMBER;
   found_valid_from_date_ DATE;

   CURSOR find_qty_and_date IS
      SELECT min_quantity, MAX(valid_from_date)
      FROM   AGREEMENT_SALES_PART_DEAL_TAB
      WHERE  agreement_id = agreement_id_
      AND    catalog_no = catalog_no_
      AND    valid_from_date <= valid_from_date_
      AND    min_quantity = (SELECT MAX(min_quantity)
                             FROM   AGREEMENT_SALES_PART_DEAL_TAB
                             WHERE  agreement_id = agreement_id_
                             AND    catalog_no = catalog_no_
                             AND    min_quantity <= min_quantity_
                             AND    valid_from_date <= valid_from_date_)
      GROUP BY min_quantity;

BEGIN
   OPEN find_qty_and_date;
   FETCH find_qty_and_date INTO found_min_quantity_, found_valid_from_date_;
   CLOSE find_qty_and_date;
   min_quantity_ := found_min_quantity_;
   valid_from_date_ := found_valid_from_date_;
END Find_Min_Qty_And_Date___;


PROCEDURE Copy_Sales_Part_Deal_Line___ (
   source_rec_           IN AGREEMENT_SALES_PART_DEAL_TAB%ROWTYPE,
   from_agreement_id_    IN VARCHAR2,
   from_valid_from_date_ IN DATE,
   currency_rate_        IN NUMBER,
   copy_notes_           IN NUMBER,
   use_price_incl_tax_   IN VARCHAR2 )
IS
   attr_                VARCHAR2(32000);
   objid_               VARCHAR2(2000);
   objversion_          VARCHAR2(2000);
   newrec_              AGREEMENT_SALES_PART_DEAL_TAB%ROWTYPE;
   base_price_          NUMBER;
   base_price_incl_tax_ NUMBER;
   deal_price_          NUMBER;
   deal_price_incl_tax_ NUMBER;
   indrec_              Indicator_Rec;
BEGIN

   -- Copy the line
   IF (Sales_Part_API.Check_Exist(source_rec_.base_price_site, source_rec_.catalog_no) = 1) THEN      
      base_price_          := source_rec_.base_price * currency_rate_;
      base_price_incl_tax_ := source_rec_.base_price_incl_tax * currency_rate_;
      deal_price_          := source_rec_.deal_price * currency_rate_;
      deal_price_incl_tax_ := source_rec_.deal_price_incl_tax * currency_rate_;
      
      Calculate_Deal_Price___(deal_price_, 
                              deal_price_incl_tax_, 
                              base_price_, 
                              base_price_incl_tax_, 
                              source_rec_.percentage_offset, 
                              source_rec_.amount_offset * currency_rate_, 
                              source_rec_.base_price_site, 
                              source_rec_.catalog_no, 
                              use_price_incl_tax_,
                              'NO_CALC',
                              source_rec_.rounding);      
                              
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('SERVER_DATA_CHANGE',   1,                                          attr_);--Not to raise discount_type null error
      Client_SYS.Add_To_Attr('AGREEMENT_ID',         source_rec_.agreement_id,                   attr_);
      Client_SYS.Add_To_Attr('MIN_QUANTITY',         source_rec_.min_quantity,                   attr_);
      Client_SYS.Add_To_Attr('VALID_FROM_DATE',      source_rec_.valid_from_date,                attr_);
      Client_SYS.Add_To_Attr('CATALOG_NO',           source_rec_.catalog_no,                     attr_);
      Client_SYS.Add_To_Attr('DISCOUNT',             NVL(source_rec_.discount,0),                attr_);
      Client_SYS.Add_To_Attr('DISCOUNT_TYPE',        source_rec_.discount_type,                  attr_);
      Client_SYS.Add_To_Attr('PROVISIONAL_PRICE_DB', source_rec_.provisional_price,              attr_);
      Client_SYS.Add_To_Attr('BASE_PRICE_SITE',      source_rec_.base_price_site,                attr_);
      IF (copy_notes_ = 1) THEN
         Client_SYS.Add_To_Attr('NOTE_TEXT',         source_rec_.note_text,                      attr_);
      END IF;
      Client_SYS.Add_To_Attr('BASE_PRICE',           base_price_,                                attr_);
      Client_SYS.Add_To_Attr('BASE_PRICE_INCL_TAX',  base_price_incl_tax_,                       attr_);
      Client_SYS.Add_To_Attr('PERCENTAGE_OFFSET',    source_rec_.percentage_offset,              attr_);
      Client_SYS.Add_To_Attr('AMOUNT_OFFSET',        source_rec_.amount_offset * currency_rate_, attr_);
      Client_SYS.Add_To_Attr('DEAL_PRICE',           deal_price_,                                attr_);
      Client_SYS.Add_To_Attr('DEAL_PRICE_INCL_TAX',  deal_price_incl_tax_,                       attr_);
      Client_SYS.Add_To_Attr('NET_PRICE_DB',         source_rec_.net_price,                      attr_);
      Client_SYS.Add_To_Attr('ROUNDING',             source_rec_.rounding,                       attr_);
      Client_SYS.Add_To_Attr('LAST_UPDATED',         SYSDATE,                                    attr_);
      Client_SYS.Add_To_Attr('VALID_TO_DATE',        source_rec_.valid_to_date,                  attr_);
      
      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);

      -- Copy multiple Discount Lines
      Agreement_Part_Discount_API.Copy_All_Discount_Lines__ (from_agreement_id_,
                                                             source_rec_.min_quantity,
                                                             from_valid_from_date_,
                                                             source_rec_.catalog_no,
                                                             source_rec_.agreement_id,
                                                             source_rec_.min_quantity,
                                                             source_rec_.valid_from_date,
                                                             source_rec_.catalog_no,
                                                             currency_rate_ );
   END IF;
END Copy_Sales_Part_Deal_Line___;

PROCEDURE Calculate_Deal_Price___ (
   deal_price_            IN  OUT NUMBER,
   deal_price_incl_tax_   IN  OUT NUMBER,
   base_price_            IN  OUT NUMBER,
   base_price_incl_tax_   IN  OUT NUMBER,
   percentage_offset_     IN      NUMBER,
   amount_offset_         IN      NUMBER,
   contract_              IN      VARCHAR2,
   catalog_no_            IN      VARCHAR2,
   use_price_incl_tax_    IN      VARCHAR2,
   calc_direction_        IN      VARCHAR2,
   rounding_              IN      NUMBER )
IS
   calc_base_ VARCHAR2(10);
BEGIN
   IF (use_price_incl_tax_ = 'TRUE') THEN
      calc_base_ := 'GROSS_BASE';
   ELSE
      calc_base_ := 'NET_BASE';
   END IF; 
   
   Sales_Part_Base_Price_API.Calculate_Part_Prices(base_price_,
                                                   base_price_incl_tax_,
                                                   deal_price_,
                                                   deal_price_incl_tax_,
                                                   percentage_offset_,      
                                                   amount_offset_,    
                                                   contract_,         
                                                   catalog_no_,       
                                                   calc_base_,        
                                                   calc_direction_,
                                                   rounding_,
                                                   ifs_curr_rounding_ => 16);
END Calculate_Deal_Price___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
   agreement_id_   agreement_sales_part_deal_tab.agreement_id%TYPE;
BEGIN
   agreement_id_ := client_sys.Get_Item_Value('AGREEMENT_ID', attr_);
   super(attr_);
   Client_SYS.Add_To_Attr('PROVISIONAL_PRICE_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('NET_PRICE_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('LAST_UPDATED', TRUNC(SYSDATE), attr_);
   Client_SYS.Add_To_Attr('MIN_QUANTITY', 0, attr_);
   Client_SYS.Add_To_Attr('AMOUNT_OFFSET', 0, attr_);
   Client_SYS.Add_To_Attr('PERCENTAGE_OFFSET', 0, attr_);
   Client_SYS.Add_To_Attr('VALID_FROM_DATE', GREATEST(TRUNC(Customer_Agreement_API.Get_Valid_From(agreement_id_ )), sysdate), attr_);
   Client_SYS.Add_To_Attr('SALES_PRICE_TYPE_DB', Sales_Price_Type_API.DB_SALES_PRICES, attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT AGREEMENT_SALES_PART_DEAL_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   super(objid_, objversion_, newrec_, attr_);
   IF (newrec_.deal_price IS NOT NULL) THEN
      Agreement_Sales_Part_Hist_API.New(newrec_.agreement_id, newrec_.min_quantity, newrec_.valid_from_date,
                                        newrec_.catalog_no, newrec_.deal_price, newrec_.deal_price);
   END IF;
   IF NOT (newrec_.discount_type IS NULL OR Client_SYS.Item_Exist('SERVER_DATA_CHANGE', attr_)) THEN
      -- New line is created with discount from client. So, create corresponding discount record
      Agreement_Part_Discount_API.Sync_Discount_Line__(newrec_.agreement_id, newrec_.min_quantity, newrec_.valid_from_date, newrec_.catalog_no);
   END IF;
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     AGREEMENT_SALES_PART_DEAL_TAB%ROWTYPE,
   newrec_     IN OUT AGREEMENT_SALES_PART_DEAL_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   -- oldrec_.deal_price is not NULL means that a price agreement exists.
   IF (oldrec_.deal_price IS NOT NULL AND newrec_.deal_price IS NOT NULL) THEN
      -- IF the price has changed: Create a new history record
      IF (NVL(newrec_.deal_price, 0) != NVL(oldrec_.deal_price, 0)) THEN
         Agreement_Sales_Part_Hist_API.New(newrec_.agreement_id, newrec_.min_quantity, newrec_.valid_from_date,
                                           newrec_.catalog_no, newrec_.deal_price, oldrec_.deal_price);
      ELSIF (oldrec_.provisional_price != newrec_.provisional_price) THEN
         Agreement_Sales_Part_Hist_API.New(newrec_.agreement_id, newrec_.min_quantity, newrec_.valid_from_date,
                                           newrec_.catalog_no, newrec_.deal_price, newrec_.deal_price);
      END IF;
   ELSIF (newrec_.deal_price IS NOT NULL) THEN
      -- A price has been entered: Create a new history record.
         Agreement_Sales_Part_Hist_API.New(newrec_.agreement_id, newrec_.min_quantity, newrec_.valid_from_date,
                                           newrec_.catalog_no, newrec_.deal_price, newrec_.deal_price);
   END IF;     
   
   IF ((newrec_.discount IS NOT NULL) OR (oldrec_.discount IS NOT NULL) OR (Discount_Amount_Exist(newrec_.agreement_id, newrec_.min_quantity, newrec_.valid_from_date, newrec_.catalog_no) = 'TRUE')) THEN
      IF (Validate_SYS.Is_Changed(oldrec_.discount_type, newrec_.discount_type)
         OR NVL(newrec_.discount, 0) != NVL(oldrec_.discount, 0)
         OR (newrec_.net_price = 'TRUE' AND oldrec_.net_price = 'FALSE')
         OR (Validate_SYS.Is_Changed(oldrec_.deal_price, newrec_.deal_price))) THEN          
         IF (NVL(Client_SYS.Get_Item_Value('SERVER_DATA_CHANGE', attr_), 0) != 2) THEN             
            -- Create/ Modify / Delete Discount record if not called through Modify_Discount__
            Agreement_Part_Discount_API.Sync_Discount_Line__(newrec_.agreement_id, newrec_.min_quantity, newrec_.valid_from_date, newrec_.catalog_no);
         END IF;
      END IF;
   END IF;

END Update___;

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     agreement_sales_part_deal_tab%ROWTYPE,
   newrec_ IN OUT agreement_sales_part_deal_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   disc_amount_exist_      VARCHAR2(5);
   header_valid_to_date_   DATE;
   use_price_incl_tax_     VARCHAR2(10);
   cust_agreement_rec_     Customer_Agreement_API.Public_Rec;
   currency_rate_          NUMBER;
   tax_calc_base_          VARCHAR2(20);
   calc_price_             BOOLEAN := FALSE;
   taxable_                VARCHAR2(5) := 'FALSE';
   tax_code_               VARCHAR2(20);
   base_price_             NUMBER;
   deal_price_             NUMBER;
   base_price_incl_tax_    NUMBER;
   deal_price_incl_tax_    NUMBER;
BEGIN 
   cust_agreement_rec_ := Customer_Agreement_API.Get(newrec_.agreement_id);
   use_price_incl_tax_ := cust_agreement_rec_.use_price_incl_tax;
   
   IF (use_price_incl_tax_ = 'TRUE') THEN
      IF (NOT indrec_.base_price_incl_tax AND  newrec_.base_price_incl_tax IS NULL ) THEN
         Sales_Part_Base_Price_API.Calculate_Base_Price_Incl_Tax(newrec_.price_break_template_id,
                                                                 newrec_.base_price_incl_tax,
                                                                 newrec_.base_price_site,
                                                                 newrec_.catalog_no,
                                                                 newrec_.sales_price_type,
                                                                 newrec_.min_quantity,
                                                                 cust_agreement_rec_.use_price_break_templates);
         Customer_Order_Pricing_API.Get_Sales_Price_In_Currency(newrec_.base_price_incl_tax,
                                                                currency_rate_,
                                                                cust_agreement_rec_.customer_no,
                                                                newrec_.base_price_site,
                                                                cust_agreement_rec_.currency_code,
                                                                newrec_.base_price_incl_tax);                                                       
         indrec_.base_price_incl_tax := TRUE;
      END IF;
      
      calc_price_ := TRUE;
      tax_calc_base_ := 'GROSS_BASE';
      tax_code_ := Sales_Part_API.Get_Tax_Code(newrec_.base_price_site, newrec_.catalog_no);

      IF ((newrec_.base_price_incl_tax IS NULL AND newrec_.deal_price_incl_tax IS NULL) OR tax_code_ IS NULL OR Sales_Part_API.Get_Taxable_Db(newrec_.base_price_site, newrec_.catalog_no) = 'FALSE') THEN 
         newrec_.base_price := newrec_.base_price_incl_tax;
         newrec_.deal_price := newrec_.deal_price_incl_tax;
         calc_price_ := FALSE;
      END IF;
      
      IF NOT indrec_.base_price_incl_tax AND NOT indrec_.deal_price_incl_tax THEN
         calc_price_ := FALSE;
      END IF;
      
      IF calc_price_ THEN
         Sales_Part_Base_Price_API.Calculate_Part_Prices(base_price_, 
                                                         newrec_.base_price_incl_tax,
                                                         deal_price_,
                                                         newrec_.deal_price_incl_tax,
                                                         NVL(newrec_.percentage_offset, 0),
                                                         NVL(newrec_.amount_offset, 0),
                                                         newrec_.base_price_site,
                                                         newrec_.catalog_no,
                                                         tax_calc_base_,
                                                         'NO_CALC',
                                                         NVL(newrec_.rounding, 20),
                                                         NULL);
         IF (indrec_.base_price_incl_tax  AND newrec_.base_price_incl_tax IS NOT NULL AND newrec_.base_price IS NULL ) THEN
            newrec_.base_price := base_price_;
         END IF;
         
         IF (indrec_.deal_price_incl_tax AND newrec_.deal_price_incl_tax IS NOT NULL AND newrec_.deal_price IS NULL ) THEN
            newrec_.deal_price := deal_price_;
         END IF;
      END IF;
   ELSE
      
      IF (NOT indrec_.base_price AND  newrec_.base_price IS NULL ) THEN
         Sales_Part_Base_Price_API.Calculate_Base_Price(newrec_.price_break_template_id,
                                                        newrec_.base_price,
                                                        newrec_.base_price_site,
                                                        newrec_.catalog_no,
                                                        newrec_.sales_price_type,
                                                        newrec_.min_quantity,
                                                        cust_agreement_rec_.use_price_break_templates);
         Customer_Order_Pricing_API.Get_Sales_Price_In_Currency(newrec_.base_price,
                                                                currency_rate_,
                                                                cust_agreement_rec_.customer_no,
                                                                newrec_.base_price_site,
                                                                cust_agreement_rec_.currency_code,
                                                                newrec_.base_price);
         indrec_.base_price := TRUE;
      END IF;
      
      calc_price_ := TRUE;
      tax_calc_base_ := 'NET_BASE';
      tax_code_ := Sales_Part_API.Get_Tax_Code(newrec_.base_price_site, newrec_.catalog_no);
      
      IF ((newrec_.base_price IS NULL AND newrec_.deal_price IS NULL) OR tax_code_ IS NULL OR Sales_Part_API.Get_Taxable_Db(newrec_.base_price_site, newrec_.catalog_no) = 'FALSE') THEN 
         newrec_.base_price_incl_tax := newrec_.base_price;
         newrec_.deal_price_incl_tax := newrec_.deal_price;
         calc_price_ := FALSE;
      END IF;
      
      IF NOT indrec_.base_price AND NOT indrec_.deal_price THEN
         calc_price_ := FALSE;
      END IF;
      
      IF calc_price_ THEN
         Sales_Part_Base_Price_API.Calculate_Part_Prices(newrec_.base_price, 
                                                         base_price_incl_tax_,
                                                         newrec_.deal_price,
                                                         deal_price_incl_tax_,
                                                         NVL(newrec_.percentage_offset, 0),
                                                         NVL(newrec_.amount_offset, 0),
                                                         newrec_.base_price_site,
                                                         newrec_.catalog_no,
                                                         tax_calc_base_,
                                                         'NO_CALC',
                                                         NVL(newrec_.rounding, 20),
                                                         NULL);
         IF (indrec_.base_price  AND newrec_.base_price IS NOT NULL AND newrec_.base_price_incl_tax IS NULL ) THEN
            newrec_.base_price_incl_tax := base_price_incl_tax_;
         END IF;
         
         IF (indrec_.deal_price AND newrec_.deal_price IS NOT NULL AND newrec_.deal_price_incl_tax IS NULL ) THEN
            newrec_.deal_price_incl_tax := deal_price_incl_tax_;
         END IF;
      END IF;

   END IF;
   
   super(oldrec_, newrec_, indrec_, attr_);   
   
   IF (newrec_.discount < -100) OR (newrec_.discount > 100) THEN
      Error_SYS.Record_General(lu_name_, 'INVALID_DISCOUNT3: Discount must be between -100 and 100!');
   END IF;

   IF (newrec_.deal_price < 0) THEN
      Error_SYS.Record_General(lu_name_, 'NONE_NEG_PRICE: The price must be greater than 0.');
   END IF;
   
   disc_amount_exist_ := Discount_Amount_Exist(newrec_.agreement_id, newrec_.min_quantity, newrec_.valid_from_date, newrec_.catalog_no);
   
   IF ((newrec_.deal_price IS NULL) AND (newrec_.discount_type IS NULL) AND (newrec_.discount IS NULL) AND (disc_amount_exist_ = 'FALSE')) THEN
      Error_SYS.Record_General(lu_name_, 'NODISCANDPRICE: Either discount type or deal price must be entered.');
   END IF;

   IF ((newrec_.discount_type IS NOT NULL) AND (newrec_.discount IS NULL) AND (disc_amount_exist_ = 'FALSE')) THEN
      Error_SYS.Record_General(lu_name_, 'SALES_DISCOUNT_INS: You have to specify a discount percentage when using a discount type.');
   END IF;
   
   IF (TRUNC(newrec_.valid_from_date) > TRUNC(newrec_.valid_to_date)) THEN
      Error_SYS.Record_General(lu_name_, 'EARLY_TO_DATE: Valid To date has to be equal to or later than Valid From date.');
   END IF;
   
   header_valid_to_date_ := Customer_Agreement_API.Get_Valid_Until(newrec_.agreement_id);
   IF (TRUNC(newrec_.valid_to_date) IS NOT NULL AND (TRUNC(newrec_.valid_to_date) > TRUNC(NVL(header_valid_to_date_, Database_SYS.Get_Last_Calendar_Date())))) THEN
      Client_SYS.Add_Info(lu_name_, 'INVALID_TO_DATE: Valid To date has to be equal to or earlier than Customer Agreement To Date.');
   END IF;
   
   IF (indrec_.valid_to_date AND newrec_.valid_to_date IS NOT NULL) THEN
      IF (Check_Period_Overlapped___(newrec_.agreement_id, newrec_.min_quantity, newrec_.valid_from_date, newrec_.catalog_no, newrec_.valid_to_date) = 'TRUE') THEN
         Error_SYS.Record_General(lu_name_, 'PERIOD_OVRLAPPED: Timeframe is overlapping with other Valid From and Valid To timeframe for same Min Qty.');
      END IF;
   END IF;
END Check_Common___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT agreement_sales_part_deal_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   use_price_break_templates_ VARCHAR2(5);
BEGIN
   
   IF indrec_.provisional_price = FALSE OR newrec_.provisional_price IS NULL THEN
      newrec_.provisional_price := Fnd_Boolean_API.DB_FALSE;
   END IF;   
   IF indrec_.net_price = FALSE OR newrec_.net_price IS NULL THEN
      newrec_.net_price := Fnd_Boolean_API.DB_FALSE;
   END IF;   
   IF indrec_.last_updated = FALSE OR newrec_.last_updated IS NULL THEN
      newrec_.last_updated := TRUNC(SYSDATE);
   END IF;
   IF indrec_.min_quantity = FALSE OR newrec_.min_quantity IS NULL THEN
      newrec_.min_quantity := 0;
   END IF;
   IF indrec_.amount_offset = FALSE OR newrec_.amount_offset IS NULL THEN
      newrec_.amount_offset := 0;
   END IF;
   IF indrec_.percentage_offset = FALSE OR newrec_.percentage_offset IS NULL THEN
      newrec_.percentage_offset := 0;
   END IF;
   IF indrec_.valid_from_date = FALSE OR newrec_.valid_from_date IS NULL THEN
      newrec_.valid_from_date := SYSDATE;
   END IF;
   IF indrec_.sales_price_type = FALSE OR newrec_.sales_price_type IS NULL THEN
      newrec_.sales_price_type  := Sales_Price_Type_API.DB_SALES_PRICES;
   END IF;   

   super(newrec_, indrec_, attr_);   
   
   IF (Customer_Agreement_API.Get_Objstate(newrec_.agreement_id) = 'Closed') THEN
      Error_SYS.Record_General(lu_name_, 'UPDATENOTALLOW: Update not allowed when agreement is in closed state');
   END IF;

   IF ((NOT Client_SYS.Item_Exist('SERVER_DATA_CHANGE', attr_)) AND (newrec_.discount_type IS NULL) AND (newrec_.discount IS NOT NULL)) THEN
      Error_SYS.Record_General(lu_name_, 'DISCTYPE_NULL: Discount percentage cannot be entered without a corresponding discount type.');
   END IF;

   IF (TRUNC(newrec_.valid_from_date) < TRUNC(Customer_Agreement_Api.Get_Valid_From(newrec_.agreement_id))) OR
      (TRUNC(newrec_.valid_from_date) > TRUNC(NVL(Customer_Agreement_Api.Get_Valid_Until(newrec_.agreement_id), newrec_.valid_from_date))) THEN
      Client_SYS.Add_Info(lu_name_, 'CUSTAGREENOTVALID: Valid from date entered is not valid within the valid period of the customer agreement.');
   END IF;

   IF Sales_Part_Base_Price_API.Get_Objstate(newrec_.base_price_site, newrec_.catalog_no, Sales_Price_Type_API.Decode(newrec_.sales_price_type)) != 'Active' THEN
      Error_SYS.Record_General(lu_name_, 'ADDONLYACTIVE: The sales part cannot be added because the base price is not active.');
   END IF;
   
   IF (newrec_.price_break_template_id IS NOT NULL) AND 
      (Sales_Part_Base_Price_API.Is_Valid_Price_Break_Templ(newrec_.base_price_site, newrec_.catalog_no, newrec_.price_break_template_id, newrec_.sales_price_type) = 0) THEN
      Error_SYS.Record_General(lu_name_, 'INVALTEMPLATE: You are only allowed to enter an active price break template of type :P1 with the price unit of measure :P2.',
      Sales_Price_Type_API.Decode(newrec_.sales_price_type), Sales_Part_API.Get_Price_Unit_Meas(newrec_.base_price_site, newrec_.catalog_no));
   END IF;
   use_price_break_templates_ := Customer_Agreement_API.Get_Use_Price_Break_Templ_Db(newrec_.agreement_id);
   IF (newrec_.price_break_template_id IS NOT NULL) AND (use_price_break_templates_ = Fnd_Boolean_API.db_false) THEN
      Error_SYS.Record_General(lu_name_, 'NOTENTPRICETEMP: You cannot enter a price break template ID when the Use Price Break Template check box has been cleared.');
   ELSIF (newrec_.price_break_template_id IS NOT NULL) AND (use_price_break_templates_ = Fnd_Boolean_API.db_true) AND 
         (NOT(Price_Break_Template_Line_API.Check_Exist(newrec_.price_break_template_id, newrec_.min_quantity, -1))) THEN
      Error_SYS.Record_General(lu_name_, 'VALIDTEMPNOTFOUND: No valid price break template ID has been found.');
   END IF;
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     agreement_sales_part_deal_tab%ROWTYPE,
   newrec_ IN OUT agreement_sales_part_deal_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS   
   discount_changed_   BOOLEAN := FALSE;
   disc_line_count_    NUMBER;   
BEGIN
   -- Don't allow update if agreement is in closed state and not sent from Modify_Prices_For_Tax
   IF (Customer_Agreement_API.Get_Objstate(newrec_.agreement_id) = 'Closed') AND (NVL(Client_SYS.Get_Item_Value('SERVER_DATA_CHANGE', attr_), 0) != 3) THEN
      Error_SYS.Record_General(lu_name_, 'UPDATENOTALLOW: Update not allowed when agreement is in closed state');
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);
   
   discount_changed_ := discount_changed_ OR Validate_SYS.Is_Changed(oldrec_.discount_type, newrec_.discount_type)   
                        OR Validate_SYS.Is_Changed(oldrec_.discount, newrec_.discount);      
   
   disc_line_count_ := Get_Disc_Line_Count_Per_Deal__(newrec_.agreement_id, newrec_.min_quantity, newrec_.valid_from_date, newrec_.catalog_no);
   IF (discount_changed_ AND NOT Client_SYS.Item_Exist('SERVER_DATA_CHANGE', attr_)) THEN
      IF NOT (newrec_.net_price = 'TRUE' AND newrec_.discount IS NULL) THEN
         IF ( disc_line_count_ > 1) THEN
            Error_SYS.Record_General(lu_name_, 'MULTIDISCTYPEEDIT: Multiple Discount lines exist. Discount / Discount type cannot be modified in deal per part line.');
         END IF;
      END IF;
   END IF;

   IF (newrec_.discount_type IS NULL AND newrec_.discount IS NOT NULL AND NOT Client_SYS.Item_Exist('SERVER_DATA_CHANGE', attr_)) THEN
      IF (disc_line_count_ < 2) THEN
         Error_SYS.Record_General(lu_name_, 'DISCTYPE_NULL: Discount percentage cannot be entered without a corresponding discount type.');
      END IF;
   END IF; 

   newrec_.last_updated := TRUNC(SYSDATE);
END Check_Update___;


@Override   
PROCEDURE Check_Delete___ (
   remrec_ IN agreement_sales_part_deal_tab%ROWTYPE )
IS
BEGIN
   IF (Customer_Agreement_API.Get_Objstate(remrec_.agreement_id) = 'Closed') THEN
      Error_SYS.Record_General(lu_name_, 'UPDATENOTALLOW: Update not allowed when agreement is in closed state');
   END IF;
   super(remrec_);
END Check_Delete___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@Override
PROCEDURE New__ (
   info_       OUT    VARCHAR2,
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   newrec_            AGREEMENT_SALES_PART_DEAL_TAB%ROWTYPE;
   added_lines_       NUMBER;
BEGIN
   super(info_, objid_, objversion_, attr_, action_);
   IF (action_ = 'DO') THEN
      newrec_ := Get_Object_By_Id___(objid_);
      -- Post Insert Actions
      Insert_Price_Break_Lines(added_lines_,
                               newrec_.agreement_id,
                               newrec_.valid_from_date,
                               newrec_.catalog_no,
                               newrec_.base_price_site,
                               newrec_.percentage_offset,
                               newrec_.amount_offset,
                               newrec_.rounding,
                               newrec_.discount_type,
                               newrec_.discount,
                               newrec_.min_quantity,
                               newrec_.price_break_template_id,
                               newrec_.valid_to_date);
      info_ := Client_SYS.Append_Info(info_);
   END IF;
END New__;


PROCEDURE Copy_All_Sales_Part_Deals__ (
   raise_msg_          IN OUT VARCHAR2,
   from_agreement_id_  IN VARCHAR2,
   to_agreement_id_    IN VARCHAR2,
   currency_rate_      IN NUMBER,
   valid_from_date_    IN DATE,
   to_valid_from_date_ IN DATE,
   copy_notes_         IN NUMBER,
   use_price_incl_tax_ IN VARCHAR2,
   row_select_state_   IN VARCHAR2 DEFAULT 'Include_All_Dates' )
IS
   -- This cursor will return the qualified lines by considering both valid_from_date and valid_to_date dates
   CURSOR get_min_date_part_all IS
      SELECT valid_date,  catalog_no, min_quantity
      FROM 
         (SELECT MAX(valid_from_date) valid_date, catalog_no, min_quantity
            FROM  AGREEMENT_SALES_PART_DEAL_TAB
            WHERE agreement_id = from_agreement_id_
            AND   valid_to_date IS NOT NULL
            AND   TRUNC(valid_from_date) <= TRUNC(valid_from_date_)
            AND   TRUNC(valid_to_date) >= TRUNC(valid_from_date_)
            GROUP BY catalog_no, min_quantity
         UNION ALL
         SELECT MAX(valid_from_date) valid_date,  catalog_no, min_quantity
            FROM  AGREEMENT_SALES_PART_DEAL_TAB
            WHERE agreement_id = from_agreement_id_
            AND   valid_to_date IS NULL
            AND   TRUNC(valid_from_date) <= TRUNC(valid_from_date_)
            AND   (catalog_no, min_quantity) NOT IN (SELECT catalog_no, min_quantity
                                                     FROM  AGREEMENT_SALES_PART_DEAL_TAB
                                                     WHERE agreement_id = from_agreement_id_
                                                     AND   valid_to_date IS NOT NULL
                                                     AND   TRUNC(valid_from_date) <= TRUNC(valid_from_date_)
                                                     AND   TRUNC(valid_to_date) >= TRUNC(valid_from_date_))
            GROUP BY catalog_no, min_quantity);
            
   -- This cursor will return the qualified lines by considering only valid_from_date
   CURSOR get_min_date_part IS
   SELECT valid_date,  catalog_no, min_quantity
   FROM 
      (SELECT MAX(valid_from_date) valid_date,  catalog_no, min_quantity
         FROM  AGREEMENT_SALES_PART_DEAL_TAB
         WHERE agreement_id = from_agreement_id_
         AND   valid_to_date IS NULL
         AND   TRUNC(valid_from_date) <= TRUNC(valid_from_date_)
         GROUP BY catalog_no, min_quantity);

      CURSOR  get_source (catalog_no_ IN VARCHAR2, min_quantity_ IN NUMBER, valid_date_ IN DATE) IS
            SELECT *
            FROM AGREEMENT_SALES_PART_DEAL_TAB t
            WHERE t.agreement_id = from_agreement_id_
            AND   t.catalog_no = catalog_no_
            AND   t.min_quantity = min_quantity_
            AND   t.valid_from_date = valid_date_;
            
      CURSOR  get_source_all (row_state_ VARCHAR2) IS
            SELECT *
            FROM AGREEMENT_SALES_PART_DEAL_TAB
            WHERE agreement_id = from_agreement_id_
            AND   row_state_ = 'Include_From_Dates'
            AND   valid_to_date IS NULL
         UNION ALL
            SELECT *
            FROM AGREEMENT_SALES_PART_DEAL_TAB
            WHERE agreement_id = from_agreement_id_
            AND   row_state_ = 'Include_All_Dates';
   BEGIN
         --raise_msg_ := 'FALSE';
         IF (to_valid_from_date_ IS NULL) THEN
            IF (valid_from_date_ IS NULL) THEN
               --Copy all lines with original valid from date
               FOR source_rec_ IN get_source_all (row_select_state_) LOOP
                  source_rec_.agreement_id := to_agreement_id_;
                  Copy_Sales_Part_Deal_Line___ (source_rec_, from_agreement_id_, source_rec_.valid_from_date, currency_rate_, copy_notes_, use_price_incl_tax_);
               END LOOP;
            ELSE
               IF row_select_state_ =  'Include_All_Dates' THEN
                  --Copy valid lines as at valid_from_date_ with original valid from date (Considered both valid from and valid to dates)
                  FOR date_rec_ IN get_min_date_part_all LOOP
                     FOR source_rec_ IN get_source(date_rec_.catalog_no, date_rec_.min_quantity, date_rec_.valid_date) LOOP
                        source_rec_.agreement_id := to_agreement_id_;
                        Copy_Sales_Part_Deal_Line___ (source_rec_, from_agreement_id_, source_rec_.valid_from_date, currency_rate_, copy_notes_, use_price_incl_tax_);
                     END LOOP;
                  END LOOP;
               ELSE
                  --Copy valid lines as at only valid_from_date_ with original valid from date (Considered only valid from date)
                  FOR date_rec_ IN get_min_date_part LOOP
                     FOR source_rec_ IN get_source(date_rec_.catalog_no, date_rec_.min_quantity, date_rec_.valid_date) LOOP
                        source_rec_.agreement_id := to_agreement_id_;
                        Copy_Sales_Part_Deal_Line___ (source_rec_, from_agreement_id_, source_rec_.valid_from_date, currency_rate_, copy_notes_, use_price_incl_tax_);
                     END LOOP;
                  END LOOP;
               END IF;
               
            END IF;
         ELSE
            IF row_select_state_ =  'Include_All_Dates' THEN
               --Copy valid lines as at valid_from_date_ with valid from date to_valid_from_date_
               FOR date_rec_ IN get_min_date_part_all LOOP
                  FOR source_rec_ IN get_source(date_rec_.catalog_no, date_rec_.min_quantity, date_rec_.valid_date) LOOP
                     -- If to_valid_from_date_ is later than original valid_to_date, then the new line's valid_to_date should be NULL.
                     IF TRUNC(to_valid_from_date_) > TRUNC(Get_Valid_To_Date(from_agreement_id_, source_rec_.min_quantity, source_rec_.valid_from_date, source_rec_.catalog_no)) THEN
                        raise_msg_ := 'TRUE';
                        source_rec_.valid_to_date := NULL;
                     END IF;
                     source_rec_.valid_from_date := to_valid_from_date_;
                     source_rec_.agreement_id := to_agreement_id_;
                     Copy_Sales_Part_Deal_Line___ (source_rec_, from_agreement_id_, date_rec_.valid_date, currency_rate_, copy_notes_, use_price_incl_tax_);
                  END LOOP;
               END LOOP;
            ELSE
               --Copy valid lines as at valid_from_date_ with valid from date to_valid_from_date_
               FOR date_rec_ IN get_min_date_part LOOP
                  FOR source_rec_ IN get_source(date_rec_.catalog_no, date_rec_.min_quantity, date_rec_.valid_date) LOOP
                     source_rec_.agreement_id := to_agreement_id_;
                     source_rec_.valid_from_date := to_valid_from_date_;
                     Copy_Sales_Part_Deal_Line___ (source_rec_, from_agreement_id_, date_rec_.valid_date, currency_rate_, copy_notes_, use_price_incl_tax_);
                  END LOOP;
               END LOOP;
            END IF;
         END IF;
END Copy_All_Sales_Part_Deals__;


PROCEDURE Modify_Discount__ (
   agreement_id_    IN VARCHAR2,
   min_quantity_    IN NUMBER,
   valid_from_date_ IN DATE,
   catalog_no_      IN VARCHAR2,
   discount_        IN NUMBER,
   discount_type_   IN VARCHAR2 )
IS
   attr_            VARCHAR2(2000);
   objid_           VARCHAR2(2000);
   objversion_      VARCHAR2(2000);
   newrec_          AGREEMENT_SALES_PART_DEAL_TAB%ROWTYPE;
   oldrec_          AGREEMENT_SALES_PART_DEAL_TAB%ROWTYPE;
   indrec_   Indicator_Rec;
BEGIN

   oldrec_ := Lock_By_Keys___(agreement_id_, min_quantity_, valid_from_date_, catalog_no_);
   Get_Id_Version_By_Keys___(objid_, objversion_, agreement_id_, min_quantity_, valid_from_date_, catalog_no_);
   newrec_ := oldrec_;
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('DISCOUNT_TYPE', discount_type_, attr_);
   Client_SYS.Add_To_Attr('DISCOUNT', discount_, attr_);
   -- NOTE: Passed 2 to specify the change was done through Modify_Discount__.
   Client_SYS.Add_To_Attr('SERVER_DATA_CHANGE', 2, attr_);
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_);

END Modify_Discount__;


@UncheckedAccess
FUNCTION Get_Disc_Line_Count_Per_Deal__ (
   agreement_id_    IN VARCHAR2,
   min_quantity_    IN NUMBER,
   valid_from_date_ IN DATE,
   catalog_no_      IN VARCHAR2 ) RETURN NUMBER
IS
   line_count_          NUMBER;
   CURSOR get_total_lines IS
      SELECT count(discount_no)
      FROM   AGREEMENT_PART_DISCOUNT_TAB
      WHERE agreement_id = agreement_id_
      AND   min_quantity = min_quantity_
      AND   valid_from_date = valid_from_date_
      AND   catalog_no = catalog_no_;

BEGIN

   OPEN get_total_lines;
   FETCH get_total_lines INTO line_count_;
   CLOSE get_total_lines;

   RETURN line_count_;

END Get_Disc_Line_Count_Per_Deal__;

FUNCTION Check_Period_Overlapped___ (
   agreement_id_    IN VARCHAR2,
   min_quantity_    IN NUMBER,
   valid_from_date_ IN DATE,
   catalog_no_      IN VARCHAR2,
   valid_to_date_   IN DATE ) RETURN VARCHAR2
IS
   period_overlapped_  VARCHAR2(5) := 'FALSE';
   dummy_              NUMBER;
   
   CURSOR find_overlap IS
      SELECT 1
      FROM AGREEMENT_SALES_PART_DEAL_TAB
      WHERE agreement_id = agreement_id_
      AND min_quantity = min_quantity_
      AND catalog_no = catalog_no_
      AND valid_to_date IS NOT NULL
      AND ((TRUNC(valid_from_date_) BETWEEN TRUNC(valid_from_date) AND TRUNC(valid_to_date)) OR
           (TRUNC(valid_to_date_) BETWEEN TRUNC(valid_from_date) AND TRUNC(valid_to_date)) OR
           (TRUNC(valid_to_date_) IS NOT NULL AND (TRUNC(valid_from_date) BETWEEN TRUNC(valid_from_date_) AND TRUNC(valid_to_date_))) OR
           (TRUNC(valid_to_date_) IS NOT NULL AND (TRUNC(valid_to_date) BETWEEN TRUNC(valid_from_date_) AND TRUNC(valid_to_date_))))
      AND valid_from_date != valid_from_date_;
BEGIN
   OPEN find_overlap;
   FETCH find_overlap INTO dummy_;
   IF (find_overlap%FOUND) THEN
      period_overlapped_ := 'TRUE';
   END IF;   
   CLOSE find_overlap;
   
   RETURN period_overlapped_;
END Check_Period_Overlapped___;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Insert_Price_Break_Lines (
   added_lines_         OUT NUMBER,
   agreement_id_        IN  VARCHAR2,
   valid_from_date_     IN  DATE,
   catalog_no_          IN  VARCHAR2,
   base_price_site_     IN  VARCHAR2,
   percentage_offset_   IN  NUMBER,
   amount_offset_       IN  NUMBER,
   rounding_            IN  NUMBER,
   discount_type_       IN  VARCHAR2,
   discount_            IN  NUMBER,
   parent_quantity_     IN  NUMBER,
   price_break_temp_id_ IN  VARCHAR2,
   valid_to_date_       IN  DATE,
   from_header_         IN  BOOLEAN DEFAULT FALSE )
IS
   deal_price_                   NUMBER;
   deal_price_incl_tax_          NUMBER;   
   cust_agr_rec_                 Customer_Agreement_API.Public_Rec;
   base_price_                   NUMBER;
   base_price_incl_tax_          NUMBER;
   price_                        NUMBER;
   currency_rate_                NUMBER;
   attr_                         VARCHAR2(32000);
   info_                         VARCHAR2(2000);
   used_price_break_template_id_ VARCHAR2(10);
   sales_price_type_db_          VARCHAR2(20);

   CURSOR template_lines_for_update (template_id_ VARCHAR2) IS
      SELECT min_qty
      FROM   price_break_template_line_tab
      WHERE  template_id = template_id_
      AND    NOT EXISTS (SELECT 1
                           FROM agreement_sales_part_deal_tab
                          WHERE agreement_id = agreement_id_
                            AND catalog_no = catalog_no_
                            AND valid_from_date = valid_from_date_
                            AND min_qty = min_quantity);
BEGIN

   added_lines_ := 0;
   sales_price_type_db_       := Sales_Price_Type_API.DB_SALES_PRICES;   
   cust_agr_rec_ := Customer_Agreement_API.Get(agreement_id_);
   
   IF(from_header_) THEN
      used_price_break_template_id_ := NVL(price_break_temp_id_, Sales_Part_Base_Price_API.Get_Template_Id(base_price_site_, catalog_no_, Sales_Price_Type_API.Decode(sales_price_type_db_)));
   ELSE
      used_price_break_template_id_ := price_break_temp_id_;
   END IF;

   IF (cust_agr_rec_.use_price_break_templates  = Fnd_Boolean_API.db_true) AND 
       (Sales_Part_Base_Price_API.Is_Valid_Price_Break_Templ(base_price_site_, catalog_no_, used_price_break_template_id_, sales_price_type_db_) = 1) THEN
      FOR rec_ IN template_lines_for_update(used_price_break_template_id_) LOOP
         
         IF (cust_agr_rec_.use_price_incl_tax = 'TRUE') THEN
            Sales_Part_Base_Price_API.Calculate_Base_Price_Incl_Tax(used_price_break_template_id_,
                                                                    price_,
                                                                    base_price_site_,
                                                                    catalog_no_,
                                                                    sales_price_type_db_,
                                                                    rec_.min_qty,
                                                                    cust_agr_rec_.use_price_break_templates);
   
            Customer_Order_Pricing_API.Get_Sales_Price_In_Currency(base_price_incl_tax_,
                                                                   currency_rate_,
                                                                   NULL,
                                                                   base_price_site_,
                                                                   cust_agr_rec_.currency_code,
                                                                   price_);
         ELSE
            Sales_Part_Base_Price_API.Calculate_Base_Price(used_price_break_template_id_,
                                                           price_,
                                                           base_price_site_,
                                                           catalog_no_,
                                                           sales_price_type_db_,
                                                           rec_.min_qty,
                                                           cust_agr_rec_.use_price_break_templates);
   
            Customer_Order_Pricing_API.Get_Sales_Price_In_Currency(base_price_,
                                                                   currency_rate_,
                                                                   NULL,
                                                                   base_price_site_,
                                                                   cust_agr_rec_.currency_code,
                                                                   price_);
         END IF;

         Calculate_Deal_Price___(deal_price_, deal_price_incl_tax_, base_price_, base_price_incl_tax_, 
                                 percentage_offset_, amount_offset_, base_price_site_, catalog_no_, cust_agr_rec_.use_price_incl_tax, 'FORWARD', rounding_);

         Client_SYS.Set_Item_Value('AGREEMENT_ID',        agreement_id_,        attr_);
         Client_SYS.Set_Item_Value('MIN_QUANTITY',        rec_.min_qty,         attr_);
         Client_SYS.Set_Item_Value('VALID_FROM_DATE',     valid_from_date_,     attr_);
         Client_SYS.Set_Item_Value('CATALOG_NO',          catalog_no_,          attr_);
         Client_SYS.Set_Item_Value('BASE_PRICE_SITE',     base_price_site_,     attr_);
         Client_SYS.Set_Item_Value('BASE_PRICE',          base_price_,          attr_);
         Client_SYS.Set_Item_Value('BASE_PRICE_INCL_TAX', base_price_incl_tax_, attr_);
         Client_SYS.Set_Item_Value('DEAL_PRICE',          deal_price_,          attr_);
         Client_SYS.Set_Item_Value('DEAL_PRICE_INCL_TAX', deal_price_incl_tax_, attr_);
         Client_SYS.Set_Item_Value('PERCENTAGE_OFFSET',   percentage_offset_,   attr_);
         Client_SYS.Set_Item_Value('AMOUNT_OFFSET',       amount_offset_,       attr_);
         Client_SYS.Set_Item_Value('ROUNDING',            rounding_,            attr_);
         IF (valid_to_date_ IS NOT NULL) THEN
            Client_SYS.Set_Item_Value('VALID_TO_DATE',       valid_to_date_,       attr_);
         END IF;
         IF discount_type_ IS NOT NULL AND discount_ IS NOT NULL THEN
            Client_SYS.Set_Item_Value('DISCOUNT_TYPE', discount_type_, attr_);
            Client_SYS.Set_Item_Value('DISCOUNT',      discount_,      attr_);
         END IF;
         Client_SYS.Set_Item_Value('PRICE_BREAK_TEMPLATE_ID', used_price_break_template_id_, attr_);
         New(info_, attr_);

         added_lines_ := added_lines_ + 1;
         IF Agreement_Sales_Part_Deal_API.Get_Disc_Line_Count_Per_Deal__(agreement_id_, parent_quantity_, valid_from_date_, catalog_no_) > 1 THEN
            Agreement_Part_Discount_API.Copy_All_Discount_Lines__(agreement_id_,
                                                                  parent_quantity_,
                                                                  valid_from_date_,
                                                                  catalog_no_,
                                                                  agreement_id_,
                                                                  rec_.min_qty,
                                                                  valid_from_date_,
                                                                  catalog_no_,
                                                                  1);
            Agreement_Part_Discount_API.Calc_Discount_Upd_Agr_Line(agreement_id_, rec_.min_qty, valid_from_date_, catalog_no_);
         END IF;
      END LOOP;
   END IF;
END Insert_Price_Break_Lines;


@UncheckedAccess
FUNCTION Check_Exist (
   agreement_id_    IN VARCHAR2,
   min_quantity_    IN NUMBER,
   valid_from_date_ IN DATE,
   catalog_no_      IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN Check_Exist___(agreement_id_, min_quantity_, valid_from_date_,catalog_no_);
END Check_Exist;

-- New
--   Creates new agreement deal part record.
PROCEDURE New (
   info_    OUT   VARCHAR2,
   attr_    IN    VARCHAR2 )
IS
   objid_               AGREEMENT_SALES_PART_DEAL.objid%TYPE;
   objversion_          AGREEMENT_SALES_PART_DEAL.objversion%TYPE;
   newrec_              AGREEMENT_SALES_PART_DEAL_TAB%ROWTYPE;
   new_attr_            VARCHAR2(32000);
   ptr_                 NUMBER;
   name_                VARCHAR2(30);
   value_               VARCHAR2(2000);
   agreement_id_        VARCHAR2(10);
   min_quantity_        NUMBER;
   valid_from_date_     DATE;
   catalog_no_          VARCHAR2(25);
   base_price_site_     VARCHAR2(20);    
   base_price_          NUMBER;
   base_price_incl_tax_ NUMBER;
   percentage_offset_   NUMBER;
   amount_offset_       NUMBER;
   rounding_            NUMBER;
   deal_price_          NUMBER;
   deal_price_incl_tax_ NUMBER; 
   use_price_incl_tax_  VARCHAR2(20);
   indrec_              Indicator_Rec;
BEGIN
   
   agreement_id_        := Client_SYS.Get_Item_Value('AGREEMENT_ID', attr_);
   min_quantity_        := Client_SYS.Get_Item_Value('MIN_QUANTITY', attr_);
   valid_from_date_     := Client_SYS.Attr_Value_To_Date(Client_SYS.Get_Item_Value('VALID_FROM_DATE', attr_));
   catalog_no_          := Client_SYS.Get_Item_Value('CATALOG_NO', attr_);
   base_price_site_     := Client_SYS.Get_Item_Value('BASE_PRICE_SITE', attr_);
   base_price_          := Client_SYS.Get_Item_Value('BASE_PRICE', attr_);
   base_price_incl_tax_ := Client_SYS.Get_Item_Value('BASE_PRICE_INCL_TAX', attr_);
   percentage_offset_   := Client_SYS.Get_Item_Value('PERCENTAGE_OFFSET', attr_);
   amount_offset_       := Client_SYS.Get_Item_Value('AMOUNT_OFFSET', attr_);
   rounding_            := Client_SYS.Get_Item_Value('ROUNDING', attr_);
   
   use_price_incl_tax_ := Customer_Agreement_API.Get_Use_Price_Incl_Tax_Db(agreement_id_);
   Calculate_Deal_Price___(deal_price_, deal_price_incl_tax_, base_price_, base_price_incl_tax_, percentage_offset_, amount_offset_, base_price_site_, catalog_no_, use_price_incl_tax_, 'FORWARD', rounding_);  

   -- Replace the default attribute values with the ones passed in the in parameter string
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      Client_SYS.Set_Item_Value(name_, value_, new_attr_);
   END LOOP;
   
   Client_SYS.Add_To_Attr('BASE_PRICE', base_price_, new_attr_);
   Client_SYS.Add_To_Attr('BASE_PRICE_INCL_TAX', base_price_incl_tax_, new_attr_);
   Client_SYS.Add_To_Attr('DEAL_PRICE', deal_price_, new_attr_);
   Client_SYS.Add_To_Attr('DEAL_PRICE_INCL_TAX', deal_price_incl_tax_, new_attr_);
   
   Unpack___(newrec_, indrec_, new_attr_);
   Check_Insert___(newrec_, indrec_, new_attr_);
   Insert___( objid_, objversion_, newrec_, new_attr_ );
   info_ := Client_SYS.Get_All_Info;
END New;


-- Modify_Deal_Price
--   This method will modify the Deal Price
PROCEDURE Modify_Deal_Price (
   agreement_id_        IN VARCHAR2,
   quantity_            IN NUMBER,
   effectivity_date_    IN DATE,
   catalog_no_          IN VARCHAR2,
   deal_price_          IN NUMBER,
   deal_price_incl_tax_ IN NUMBER   )
IS
   objid_                    AGREEMENT_SALES_PART_DEAL.objid%TYPE;
   objversion_               AGREEMENT_SALES_PART_DEAL.objversion%TYPE;
   oldrec_                   AGREEMENT_SALES_PART_DEAL_TAB%ROWTYPE;
   newrec_                   AGREEMENT_SALES_PART_DEAL_TAB%ROWTYPE;
   attr_                     VARCHAR2(2000);
   found_min_quantity_       NUMBER;
   found_valid_from_date_    DATE;
   use_price_incl_tax_       VARCHAR2(20);   
   indrec_                   Indicator_Rec;
   calc_base_                VARCHAR2(10);
   new_deal_price_           NUMBER;
   new_deal_price_incl_tax_  NUMBER;
BEGIN
   found_min_quantity_ := quantity_;
   found_valid_from_date_ := effectivity_date_;
   Find_Min_Qty_And_Date___(found_min_quantity_, found_valid_from_date_,agreement_id_, catalog_no_);
   
   Get_Id_Version_By_Keys___(objid_, objversion_, agreement_id_, found_min_quantity_, found_valid_from_date_, catalog_no_);
   oldrec_ := Lock_By_Id___(objid_, objversion_);
   newrec_ := oldrec_; 
   use_price_incl_tax_ := Customer_Agreement_API.Get_Use_Price_Incl_Tax_Db(agreement_id_);   
    
   IF (use_price_incl_tax_ = 'TRUE') THEN      
      calc_base_ := 'GROSS_BASE';
   ELSE      
      calc_base_ := 'NET_BASE';
   END IF;
   
   Tax_Handling_Order_Util_API.Calc_Price_Source_Prices(new_deal_price_,
                                                        new_deal_price_incl_tax_,  
                                                        newrec_.base_price_site,  
                                                        catalog_no_,
                                                        calc_base_, 
                                                        NVL(oldrec_.rounding, 16));
   
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('DEAL_PRICE', new_deal_price_, attr_);
   Client_SYS.Add_To_Attr('DEAL_PRICE_INCL_TAX', new_deal_price_incl_tax_, attr_);
   Client_SYS.Add_To_Attr('PROVISIONAL_PRICE_DB', 'FALSE', attr_);
   
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_);
END Modify_Deal_Price;


PROCEDURE Modify_Price_Info (
   agreement_id_             IN VARCHAR2,
   min_quantity_             IN NUMBER,
   valid_from_date_          IN DATE,
   catalog_no_               IN VARCHAR2,
   new_base_price_           IN NUMBER,
   new_base_price_incl_tax_  IN NUMBER,
   new_deal_price_           IN NUMBER, 
   new_sales_price_incl_tax_ IN NUMBER,
   price_break_template_id_  IN VARCHAR2,
   valid_to_date_            IN DATE,
   percentage_offset_        IN NUMBER,
   amount_offset_            IN NUMBER )
IS
   objid_                 AGREEMENT_SALES_PART_DEAL.objid%TYPE;
   objversion_            AGREEMENT_SALES_PART_DEAL.objversion%TYPE;
   oldrec_                AGREEMENT_SALES_PART_DEAL_TAB%ROWTYPE;
   newrec_                AGREEMENT_SALES_PART_DEAL_TAB%ROWTYPE;
   attr_                  VARCHAR2(2000);
   indrec_                Indicator_Rec;
 
BEGIN
   oldrec_ := Lock_By_Keys___(agreement_id_, min_quantity_, valid_from_date_, catalog_no_);
   newrec_ := oldrec_;
                              
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('BASE_PRICE', new_base_price_, attr_);
   Client_SYS.Add_To_Attr('BASE_PRICE_INCL_TAX', new_base_price_incl_tax_, attr_);
   Client_SYS.Add_To_Attr('DEAL_PRICE', new_deal_price_, attr_);
   Client_SYS.Add_To_Attr('DEAL_PRICE_INCL_TAX', new_sales_price_incl_tax_, attr_);
   IF price_break_template_id_ IS NOT NULL THEN
      Client_SYS.Add_To_Attr('PRICE_BREAK_TEMPLATE_ID', price_break_template_id_, attr_);
   END IF;
   Client_SYS.Add_To_Attr('VALID_TO_DATE', valid_to_date_, attr_);
   Client_SYS.Add_To_Attr('PERCENTAGE_OFFSET', percentage_offset_, attr_);
   Client_SYS.Add_To_Attr('AMOUNT_OFFSET', amount_offset_, attr_);
   Unpack___(newrec_, indrec_, attr_); 
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE); 

END Modify_Price_Info;


-- Modify_Deal_Prices
--   Update deal price and deal price incl tax according the base price.
PROCEDURE Modify_Deal_Prices (
   agreement_id_       IN VARCHAR2,
   use_price_incl_tax_ IN VARCHAR2
 )
IS
   objid_                 AGREEMENT_SALES_PART_DEAL.objid%TYPE;
   objversion_            AGREEMENT_SALES_PART_DEAL.objversion%TYPE;
   oldrec_                AGREEMENT_SALES_PART_DEAL_TAB%ROWTYPE;
   newrec_                AGREEMENT_SALES_PART_DEAL_TAB%ROWTYPE;
   attr_                  VARCHAR2(2000);
   deal_price_            NUMBER;
   deal_price_incl_tax_   NUMBER;
   indrec_                Indicator_Rec;       
   
   CURSOR  get_data IS
      SELECT  base_price, base_price_incl_tax, catalog_no, min_quantity, valid_from_date, base_price_site, rounding, percentage_offset, amount_offset 
      FROM    AGREEMENT_SALES_PART_DEAL_TAB 
      WHERE   agreement_id = agreement_id_;

BEGIN
   
   FOR rec_ IN get_data LOOP
      Client_SYS.Clear_Attr(attr_);
      Get_Id_Version_By_Keys___(objid_, objversion_, agreement_id_, rec_.min_quantity,
                                rec_.valid_from_date, rec_.catalog_no);
      oldrec_ := Lock_By_Id___(objid_, objversion_);
      newrec_ := oldrec_;
      
      Calculate_Deal_Price___(deal_price_, 
                              deal_price_incl_tax_, 
                              rec_.base_price, 
                              rec_.base_price_incl_tax, 
                              rec_.percentage_offset, 
                              rec_.amount_offset, 
                              rec_.base_price_site,
                              rec_.catalog_no,
                              use_price_incl_tax_,
                              'FORWARD',
                              rec_.rounding);  
      
      Client_SYS.Add_To_Attr('DEAL_PRICE', deal_price_, attr_);
      Client_SYS.Add_To_Attr('DEAL_PRICE_INCL_TAX', deal_price_incl_tax_, attr_);

     
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
      Update___(objid_, oldrec_, newrec_, attr_, objversion_);
   
   END LOOP;
END Modify_Deal_Prices;


-- Modify_Prices_For_Tax
--   Recalculates price columns depending on the use_price_incl_tax check box.
--   Called when fee_code is modified in Sales Part.
PROCEDURE Modify_Prices_For_Tax (
   base_price_site_    IN    VARCHAR2,
   catalog_no_         IN VARCHAR )
IS
   objid_                 AGREEMENT_SALES_PART_DEAL.objid%TYPE;
   objversion_            AGREEMENT_SALES_PART_DEAL.objversion%TYPE;
   oldrec_                AGREEMENT_SALES_PART_DEAL_TAB%ROWTYPE;
   newrec_                AGREEMENT_SALES_PART_DEAL_TAB%ROWTYPE;
   attr_                  VARCHAR2(2000);  
   base_price_            NUMBER;
   base_price_incl_tax_   NUMBER;   
   deal_price_            NUMBER;
   deal_price_incl_tax_   NUMBER;
   indrec_                Indicator_Rec;
   calc_base_             VARCHAR2(10);
   CURSOR  get_data IS
   SELECT  ca.agreement_id, base_price, base_price_incl_tax, deal_price, deal_price_incl_tax, use_price_incl_tax, min_quantity, valid_from_date, base_price_site, rounding
   FROM    AGREEMENT_SALES_PART_DEAL_TAB cap, CUSTOMER_AGREEMENT_TAB ca
   WHERE   ca.agreement_id = cap.agreement_id
   AND     cap.catalog_no = catalog_no_
   AND     cap.base_price_site = base_price_site_;

BEGIN
   
   FOR rec_ IN get_data LOOP
      Client_SYS.Clear_Attr(attr_);
      
      Get_Id_Version_By_Keys___(objid_, objversion_, rec_.agreement_id, rec_.min_quantity,
                                rec_.valid_from_date, catalog_no_);
      oldrec_ := Lock_By_Id___(objid_, objversion_);
      newrec_ := oldrec_;
      
      base_price_            := rec_.base_price;
      base_price_incl_tax_   := rec_.base_price_incl_tax;
      deal_price_            := rec_.deal_price;
      deal_price_incl_tax_   := rec_.deal_price_incl_tax;
      
      IF (rec_.use_price_incl_tax = 'TRUE') THEN
         calc_base_ := 'GROSS_BASE';
      ELSE         
         calc_base_ := 'NET_BASE';
      END IF;    
      
      Sales_Part_Base_Price_API.Calculate_Part_Prices(base_price_, 
                                                      base_price_incl_tax_, 
                                                      deal_price_, 
                                                      deal_price_incl_tax_, 
                                                      0, 
                                                      0, 
                                                      base_price_site_, 
                                                      catalog_no_, 
                                                      calc_base_, 
                                                      'NO_CALC', 
                                                      oldrec_.rounding, 
                                                      16);
      Client_SYS.Add_To_Attr('BASE_PRICE', base_price_, attr_);
      Client_SYS.Add_To_Attr('BASE_PRICE_INCL_TAX', base_price_incl_tax_, attr_);     
      Client_SYS.Add_To_Attr('DEAL_PRICE', deal_price_, attr_);
      Client_SYS.Add_To_Attr('DEAL_PRICE_INCL_TAX', deal_price_incl_tax_, attr_);
      -- NOTE: Passed 3 to specify the change was done through Modify_Prices_For_Tax which is used when tax code is changed from Sales part.
      Client_SYS.Add_To_Attr('SERVER_DATA_CHANGE', 3, attr_);

      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
      Update___(objid_, oldrec_, newrec_, attr_, objversion_);
   
   END LOOP;
END Modify_Prices_For_Tax;


PROCEDURE Modify_Offset (
   agreement_id_        IN VARCHAR2,
   catalog_no_          IN VARCHAR2,
   min_quantity_        IN NUMBER,
   valid_from_date_     IN DATE,
   percentage_offset_   IN NUMBER,
   amount_offset_       IN NUMBER,
   valid_to_date_       IN DATE,
   deal_price_          IN NUMBER,
   deal_price_incl_tax_ IN NUMBER )
IS
   oldrec_              AGREEMENT_SALES_PART_DEAL_TAB%ROWTYPE;
   newrec_              AGREEMENT_SALES_PART_DEAL_TAB%ROWTYPE;
   objid_               VARCHAR2(2000);
   objversion_          VARCHAR2(2000);
   attr_                VARCHAR2(2000);
   indrec_              Indicator_Rec;
BEGIN
   oldrec_ := Lock_By_Keys___(agreement_id_, min_quantity_, valid_from_date_, catalog_no_);
   newrec_ := oldrec_;
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('PERCENTAGE_OFFSET', percentage_offset_, attr_);
   Client_SYS.Add_To_Attr('AMOUNT_OFFSET', amount_offset_, attr_);
   Client_SYS.Add_To_Attr('DEAL_PRICE', deal_price_,attr_);
   Client_SYS.Add_To_Attr('DEAL_PRICE_INCL_TAX', deal_price_incl_tax_,attr_);
   Client_SYS.Add_To_Attr('SERVER_DATA_CHANGE', 1, attr_);
   Client_SYS.Add_To_Attr('VALID_TO_DATE', valid_to_date_, attr_);
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
    
END Modify_Offset;


-- Remove
--   Removes specified record.
PROCEDURE Remove (
   agreement_id_     IN VARCHAR2,
   catalog_no_       IN VARCHAR2,
   min_quantity_     IN NUMBER,
   valid_from_date_  IN DATE )
IS
   remrec_     AGREEMENT_SALES_PART_DEAL_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, agreement_id_, min_quantity_, valid_from_date_, catalog_no_);
   remrec_ := Lock_By_Id___(objid_, objversion_);
   Check_Delete___(remrec_);
   Delete___(objid_, remrec_);
END Remove;


@UncheckedAccess
FUNCTION Find_And_Check_Exist (
   agreement_id_    IN VARCHAR2,
   min_quantity_    IN NUMBER,
   valid_from_date_ IN DATE,
   catalog_no_      IN VARCHAR2 ) RETURN BOOLEAN
IS
   found_min_quantity_    NUMBER;
   found_valid_from_date_ DATE;
BEGIN
   found_min_quantity_ := min_quantity_;
   found_valid_from_date_ := valid_from_date_;
   Find_Min_Qty_And_Date___(found_min_quantity_, found_valid_from_date_,agreement_id_, catalog_no_);
   RETURN Check_Exist___(agreement_id_, found_min_quantity_, found_valid_from_date_,catalog_no_);
END Find_And_Check_Exist;


-- Discount_Amount_Exist
--   Returns TRUE if there exist discount lines having discount amount.
@UncheckedAccess
FUNCTION Discount_Amount_Exist (
   agreement_id_    IN VARCHAR2,
   min_quantity_    IN NUMBER,
   valid_from_date_ IN DATE,
   catalog_no_      IN VARCHAR2) RETURN VARCHAR2
IS
   found_       VARCHAR2(5) := 'FALSE';
   count_       NUMBER;
   
   CURSOR get_disc_amount IS
      SELECT count(agreement_id)
      FROM AGREEMENT_PART_DISCOUNT_TAB
      WHERE agreement_id    = agreement_id_
      AND   min_quantity    = min_quantity_
      AND   valid_from_date = valid_from_date_
      AND   catalog_no      = catalog_no_
      AND   discount_amount IS NOT NULL;
BEGIN
   OPEN get_disc_amount;
   FETCH get_disc_amount INTO count_;
   CLOSE get_disc_amount;
   
   IF (count_ >= 1) THEN
      found_ := 'TRUE';
   END IF;
   
   RETURN found_;
   
END Discount_Amount_Exist;


-- Copy
--   Copies the selected sales part deal lines.
PROCEDURE Copy (
   to_agreement_id_    IN VARCHAR2,
   attr_               IN VARCHAR2 )
IS
   source_rec_         AGREEMENT_SALES_PART_DEAL_TAB%ROWTYPE;
   new_agree_rec_      CUSTOMER_AGREEMENT_TAB%ROWTYPE;
   source_agree_rec_   CUSTOMER_AGREEMENT_TAB%ROWTYPE;
   ptr_                NUMBER;
   name_               VARCHAR2(30);
   value_              VARCHAR2(2000);
   from_agreement_     VARCHAR2(10);
   currency_rate_      NUMBER;
   currtype_           VARCHAR2(10);
   conv_factor_        NUMBER;
   rate_               NUMBER;
   agr_part_deal_tab_  Agree_Part_Deal_Table;
   row_count_          NUMBER := 0;
   
   CURSOR  get_source(agreement_id_ IN VARCHAR2, min_qty_ IN NUMBER, valid_from_ IN DATE, catalog_no_ IN VARCHAR2) IS
      SELECT *
      FROM AGREEMENT_SALES_PART_DEAL_TAB
      WHERE agreement_id = agreement_id_
      AND   min_quantity = min_qty_
      AND   valid_from_date = valid_from_
      AND   catalog_no = catalog_no_;
   
   CURSOR get_agreement_data(agreement_id_ IN VARCHAR2) IS
      SELECT * 
      FROM CUSTOMER_AGREEMENT_TAB
      WHERE agreement_id = agreement_id_;
   
BEGIN
   
   OPEN get_agreement_data(to_agreement_id_);
   FETCH get_agreement_data INTO new_agree_rec_; 
   CLOSE get_agreement_data;
         
   -- Check if the agreement is of a valid company.
   IF (new_agree_rec_.agreement_id IS NOT NULL) THEN
      Company_Finance_API.Exist(new_agree_rec_.company);
   ELSE
      Error_SYS.Record_General(lu_name_, 'NO_AGREEMENT_EXIST: Customer Agreement :P1 does not exist.', to_agreement_id_);
   END IF;
   
   ptr_ := NULL;
   IF (attr_ IS NOT NULL) THEN
      WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
         IF (name_ = 'AGREEMENT_ID') THEN
            agr_part_deal_tab_(row_count_).agreement_id := value_;
         ELSIF (name_ = 'MIN_QUANTITY') THEN
            agr_part_deal_tab_(row_count_).min_qty := Client_SYS.Attr_Value_To_Number(value_);
         ELSIF (name_ = 'VALID_FROM') THEN
            agr_part_deal_tab_(row_count_).valid_from := Client_SYS.Attr_Value_To_Date(value_);
         ELSIF (name_ = 'CATALOG_NO') THEN
            agr_part_deal_tab_(row_count_).catalog_no := value_;
            row_count_ := row_count_ + 1;
         END IF;
      END LOOP; 
   END IF;
   
   IF (agr_part_deal_tab_.COUNT > 0) THEN
      -- Select index 0 agreement_id due to all lines have one parent.
      IF (Customer_Agreement_Api.Get_Use_Price_Incl_Tax_Db(agr_part_deal_tab_(0).agreement_id) != new_agree_rec_.use_price_incl_tax) THEN
         Error_SYS.Record_General(lu_name_, 'DIF_USE_PRICE_INCL: Destination agreement must have the same price including tax setting as the source agreement.');
      END IF;
      
      FOR index_ IN agr_part_deal_tab_.FIRST..agr_part_deal_tab_.LAST LOOP   
         OPEN get_source(agr_part_deal_tab_(index_).agreement_id, agr_part_deal_tab_(index_).min_qty, agr_part_deal_tab_(index_).valid_from, agr_part_deal_tab_(index_).catalog_no);
         FETCH get_source INTO source_rec_; 
         CLOSE get_source;
      
         OPEN get_agreement_data(source_rec_.agreement_id);
         FETCH get_agreement_data INTO source_agree_rec_; 
         CLOSE get_agreement_data;
      
         IF (source_agree_rec_.currency_code = new_agree_rec_.currency_code) THEN
            currency_rate_ := 1;
         ELSE
            Invoice_Library_API.Get_Currency_Rate_Defaults(currtype_, conv_factor_, rate_, source_agree_rec_.company, source_agree_rec_.currency_code, SYSDATE, 'CUSTOMER', NULL);
            -- Currence rate for Source agreement's currency to base currency
            currency_rate_ := rate_ / conv_factor_;
            Invoice_Library_API.Get_Currency_Rate_Defaults(currtype_, conv_factor_, rate_, source_agree_rec_.company, new_agree_rec_.currency_code, SYSDATE, 'CUSTOMER', NULL);
            -- Currence rate for new agreement's currency from Source agreement's currency
            currency_rate_ := currency_rate_ * conv_factor_ / rate_ ;
         END IF;
      
         from_agreement_ := source_rec_.agreement_id;
         source_rec_.agreement_id := to_agreement_id_;
         
         Copy_Sales_Part_Deal_Line___(source_rec_, from_agreement_, agr_part_deal_tab_(index_).valid_from, currency_rate_, 1, new_agree_rec_.use_price_incl_tax);
      END LOOP;
   END IF;
END Copy;

PROCEDURE Modify_Valid_To_Date (
   agreement_id_      IN VARCHAR2,
   catalog_no_         IN VARCHAR2,
   min_quantity_       IN NUMBER,   
   valid_from_date_    IN DATE,
   valid_to_date_      IN DATE )
IS
   newrec_     AGREEMENT_SALES_PART_DEAL_TAB%ROWTYPE;

BEGIN
   newrec_ := Get_Object_By_Keys___(agreement_id_, min_quantity_, valid_from_date_, catalog_no_);
   newrec_.valid_to_date := valid_to_date_;
   Modify___(newrec_);
END Modify_Valid_To_Date;

@UncheckedAccess
FUNCTION Get_Calculated_sales_price (
   agreement_id_      IN VARCHAR2,
   catalog_no_        IN VARCHAR2,
   min_quantity_      IN NUMBER,   
   valid_from_date_   IN DATE ) RETURN NUMBER
IS
   source_rec_         AGREEMENT_SALES_PART_DEAL_TAB%ROWTYPE;
   use_price_incl_tax_  BOOLEAN;
   sales_price_         NUMBER := 0;
   round_               NUMBER := 0;
   
   CURSOR get_row IS
      SELECT *
      FROM  agreement_sales_part_deal_tab
      WHERE agreement_id = agreement_id_
      AND   min_quantity = min_quantity_
      AND   valid_from_date = valid_from_date_
      AND   catalog_no = catalog_no_;
   
BEGIN
   OPEN get_row;
   FETCH get_row INTO source_rec_;
   CLOSE get_row;
   
   use_price_incl_tax_ := (Customer_Agreement_API.Get_Use_Price_Incl_Tax_Db(agreement_id_) = 'TRUE');
   
   IF use_price_incl_tax_ THEN
      sales_price_ := source_rec_.base_price_incl_tax + source_rec_.amount_offset + (source_rec_.base_price_incl_tax * source_rec_.percentage_offset /100);
   ELSE
      sales_price_ := source_rec_.base_price + source_rec_.amount_offset + (source_rec_.base_price * source_rec_.percentage_offset/100);
   END IF;
   
   IF sales_price_ < 0 THEN
      RETURN NULL;
   ELSE
      IF source_rec_.rounding IS NOT NULL AND source_rec_.rounding < 0 THEN
         round_ := ROUND(-source_rec_.rounding, 0);
         sales_price_ := sales_price_ * POWER(10, -round_); 
         sales_price_ := ROUND(sales_price_, 0) * POWER(10, round_);
      ELSE 
         IF MOD(sales_price_, 1) = 0 THEN
            sales_price_ := ROUND(sales_price_, 0);
         ELSE
            IF source_rec_.rounding IS NOT NULL THEN
               sales_price_ := ROUND(sales_price_, source_rec_.rounding);
            ELSE
               -- TODO : Use IFS currency to round using user profile
               sales_price_ := sales_price_;
            END IF;
         END IF;
      END IF; 
   END IF;
   RETURN sales_price_;
END Get_Calculated_sales_price;
