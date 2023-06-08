-----------------------------------------------------------------------------
--
--  Logical unit: ConfigCharPrice
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  211215  PAMMLK  MF21R2-5444, Modified Get_New_Pricing_Info___ to include the new level to get the pricing info from configuration based price tab based on configuration family.
--  210526  JICESE  MF21R2-1589, Added public method Set_Price_Offset.
--  180213  Chahlk  STRMF-17215, Modified Update___() to remove madatory pricing check. Logic moved to the client.
--  180129  BudKLK  Bug 139997, Modified the method Get_New_Pricing_Info___() to add a condition to make sure that the newrec_.characteristic_price will be not reassign for the package configurations.
--  171026  Nikplk  STRSC-13817, Renamed Configured_Line_Price_API.Get into Configured_Line_Price_API.Get_Config_Line_Connected_Info.
--  140730  ChFolk  Modified Get_New_Pricing_Info___ to set the option_amount_ based on use_price_incl_tax defined in corresponding configured line type.
--  140725  ChFolk  Modified Get_New_Pricing_Info___ to set the characteristic_amount based on use_price_incl_tax defined in corresponding configured line type.
--  140414  JICE    Set ROWKEY to NULL when inserting from copied records.
--  140226  ChBnlk  Bug 113704, Modified Copy_Pricing_Util__() by removing parameters new_configuration_id_ attr_ and changed it to call Modify() if  
--                  the ConfigCharPrice object exists and to call New() if it doesn't.
--  140210  SuJalk  PBMF-4678, Modified Update___ to set price to Frozen only if the frozen flag remains frozen before and after editing.
--  140123  SuJalk  PBMF-4678, Modified Check_Update___ to set the value to characteristic_price_ only if newrec_.characteristic_price is edited in client (checked the indrec_ value).
--  130827  IsSalk  Bug 112056, Removed method Lock_Record().
--  130703  MaIklk  TIBE-955, Removed inst_ConfigSpecValue_ and Inst_BasePartChar_ global variables which were not used.
--                  Also Closed the lock_record cursor.
--  130523  RaNhlk  Bug 108373, Modified method Get_Calculated_Char_Prices() to add configuration_id as a parameter and used it in the where clause of the cursor. 
--  130508  KiSalk  Bug 106680, Replaced Installed_Component_SYS.<component> with Component_<component>_SYS.<component>.
--  121024  RuLiLk  Bug 106153, Modified Get_New_Pricing_Info___. Moved variable declaration to a DECLARE BEGIN block.
--  120605  Chahlk  MosXp-1096, Modified Get_New_Char_Value_Price() to consider price lists.
--  120814  Chahlk  MOSXP-1051, Modified Get_New_Pricing_Info___,Unpack_Check_Insert___ to set correct package content prices.
--  120712  UdGnlk  Bug 102748, Modified Get_New_Pricing_Info___() to include conversion for characteristic and option amount as sales pricing. 
--  120716  Chahlk  MOSXP-963, Modified Get_New_Pricing_Info___ according to changed package_contetnt value.
--  120620  Chahlk  MOSXP-826, Modified Get_New_Pricing_Info___ and added default values.
--  120606  Chahlk  Modified Get_New_Pricing_Info___ to disable pricing logic for Characateristics of a Package Chatacteristic.Added Conditional Compilation for Dynamic Block.
--  120420  ChJalk  Modified the method Get_New_Char_Value_Price to handle the returned value of char_price if the price free flag is ON.
--  110804  GayDLK  Bug 96730, Removed the unnecessary code, to get the currency rounding_ value and the code used to round the value of  
--  110804          newrec_.calc_char_price from Get_New_Pricing_Info___().
--  100512  Ajpelk  Merge rose method documentation
--  100519  Hasplk  Added method Get_New_Char_Value_Price.
--  100401  KiSalk  Corrected REF parameter order in config_spec_value_id of the base view.
--  090929  SuJalk  Added characteristic value as a parameter to Get_New_Pricing_Info___ and Get_New_Pricing_Info__ methods. Also added lock_record method.
--  090410  SuJalk  Bug 79924, Added price_list_no_ and new_price_effectivity_date as parameters to Get_New_Pricing_Info___. The newly added parameters would be used for calculations within
--  090410          Get_New_Pricing_Info___. Also added function Get_Calculated_Char_Prices.
--  070806  JaBalk  Changed the reference of customer_no_pay_ variable from 
--  070806          CONFIGURED_LINE_PRICE_TAB to CUST_ORD_CUSTOMER_PUB in Get_New_Pricing_Info___ procedure.
--  060124  NiDalk  Added Assert safe annotation. 
--  060117  SuJalk  Changed the "SELECT into ...." statment in Procedure Insert___ to "RETURNING &OBJID INTO objid".
--  050930  IsAnlk  Added customer_no as parameter to customer_Order_Pricing_API.Get_Sales_Price_In_Currency call.
--  050921  SaMelk  Removed Unused Variables.
--  040218  IsWilk  Removed SUBSTRB from the view for Unicode Changes.
--  ----------------------------------13.3.0-----------------------------------   
--  040122  GeKalk  Rewrote DBMS_SQL using Native dynamic SQL for UNICODE modifications.
--  031008  PrJalk  Bug Fix 106224, Changed Wrong General_Sys.Init_Method calls.
--  030729  UdGnlk  Performed SP4 Merge.
--  030417  MaGu    Bug 33755, Added headrec_.catalog_no as a parameter in four function calls in Procedure Get_New_Pricing_Info__.
--  021211  Asawlk  Merged bug fixes in 2002-3 SP3
--  021209  MiKulk  Bug 34683, Removed the new view added by bug 31942, due to errors when installing Order without Cfgchr.
--  021120  SaRalk  Bug 34279, Changed procedure Get_New_Pricing_Info to a private method.
--  021119  JSAnse  Bug 34227, Removed bug correction 32855 due to removal of bug correction 29960.
--  021003  JSAnse  Bug 32855, Changed from newrec_.part_no to headrec_.catalog_no in procedure Get_New_Pricing_Info___.
--  020815  GaSolk  Bug 29964, Added the Proc:Get_New_Pricing_Info.
--  020813  KiSalk  Bug 31942,Added new view CONFIG_CHAR_PRICE_ORDERED.
--  010528  JSAnse  Bug 21463, Added call to General_SYS.Init_Method in procedures Insert__ and Copy_Pricing_Util__.
--  010412  JaBa    Bug Fix 20598,Added new global constants and used those in necessary places.
--  010104  JakH    Cleaned some comments.
--  010102  JakH    Added price effectivity date to price list usage.
--  001213  JakH    Modified sequence for fetching prices from price lists.
--  001127  JakH    Copied price list prices to newrec.
--  001122  JakH    Made currency change only when the prices are fetched from base.
--  001120  JakH    qty_characteristic_ is set to 1 if null before multiplications
--  001120  JakH    Converted amounts fetched from price searches to order/quote
--                  currency before storing.
--  001010  JakH    Made minor corrections to returned values.
--  001002  JakH    Create
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Get_New_Pricing_Info___
--   Procedure that returns the pricing information for a new line.
--   Searches the (agreements) price lists, and the base prices.
PROCEDURE Get_New_Pricing_Info___ (
   newrec_                     IN OUT CONFIG_CHAR_PRICE_TAB%ROWTYPE,
   price_list_no_              IN VARCHAR2,
   new_price_effectivity_date_ IN DATE,
   user_characteristic_value_  IN VARCHAR2 DEFAULT NULL,
   user_qty_characteristic_    IN NUMBER DEFAULT NULL,
   user_contract_              IN VARCHAR2 DEFAULT NULL,
   user_catalog_no_            IN VARCHAR2 DEFAULT NULL,
   user_customer_no_           IN VARCHAR2 DEFAULT NULL,
   user_currency_code_         IN VARCHAR2 DEFAULT NULL,
   user_part_price_            IN NUMBER DEFAULT NULL,
   eval_rec_                   IN Characteristic_Base_Price_API.config_price_comb_rec  DEFAULT NULL)
IS
   -- ConfigSpecValue
   characteristic_value_   VARCHAR2(2000);
   config_value_type_      VARCHAR2(20);
   config_data_type_       VARCHAR2(20);
   qty_characteristic_     NUMBER;
   char_value_             NUMBER;
   num_value_ok_           NUMBER;

   -- Price info
   stop_price_search_      VARCHAR2(20);
   price_break_type_       VARCHAR2(20);

   -- Part configuration revision
   char_qty_price_method_  VARCHAR2(20);

   --
   char_price_fetched_     BOOLEAN := FALSE;
   option_price_fetched_   BOOLEAN := FALSE;

   -- Dynamic call

   -- parent  information
   headrec_                CONFIGURED_LINE_PRICE_TAB%ROWTYPE;

   -- searched values (in base currency for base prices)
   characteristic_amount_  NUMBER;
   option_amount_          NUMBER;
   curr_rate_              NUMBER;

   price_effectivity_date_ DATE;
   customer_no_pay_        CUST_ORD_CUSTOMER_PUB.customer_no%TYPE;
   
   --Package Content
   

   price_list_currcode_         VARCHAR2(3);
   base_characteristic_amount_  NUMBER;
   base_option_amount_          NUMBER;

   char_amount_incl_tax_        NUMBER;
   identity_                    VARCHAR2(12);
   use_price_incl_tax_db_       VARCHAR2(20);
   configured_line_type_        VARCHAR2(20);
   option_amount_incl_tax_      NUMBER;
   valid_char_price_list_       BOOLEAN := FALSE;
   valid_option_price_list_     BOOLEAN := FALSE;
   package_content_             VARCHAR2(2000);
BEGIN
 
   Trace_SYS.Field(' ===> Line Price Id', newrec_.configured_line_price_id);
   -- Get Parent information
   headrec_ := Configured_Line_Price_API.Get_Config_Line_Connected_Info(newrec_.configured_line_price_id);

   IF user_contract_ IS NOT NULL THEN
      headrec_.contract := user_contract_;
   END IF;

   IF user_catalog_no_ IS NOT NULL THEN
      headrec_.catalog_no := user_catalog_no_;
   END IF;

   IF user_customer_no_ IS NOT NULL THEN
      customer_no_pay_ := user_customer_no_;
   ELSE
      customer_no_pay_ := Configured_Line_Price_API.Get_Identity(newrec_.configured_line_price_id);
   END IF;
   
   IF user_currency_code_ IS NOT NULL THEN
      headrec_.currency_code := user_currency_code_;
   END IF;
   
   IF user_part_price_ IS NOT NULL THEN
      headrec_.part_price := user_part_price_;
   END IF;
   
   IF (price_list_no_ IS NOT NULL) THEN 
      -- The user has changed the price_list to null
      IF (price_list_no_ = Database_SYS.string_null_) THEN
         headrec_.price_list_no := NULL;
      ELSE
         headrec_.price_list_no := price_list_no_;
      END IF;
   END IF;

   price_effectivity_date_ := NVL(new_price_effectivity_date_, Configured_Line_Price_API.Get_Price_Effectivity_Date(newrec_.configured_line_price_id));

   Trace_SYS.Field(' ===> User Qty_Characteristic', user_qty_characteristic_);
   
   -- Get Identity
   $IF Component_Cfgchr_SYS.INSTALLED $THEN
      DECLARE
         csvrec_      Config_Spec_Value_API.Public_Rec;
         bpcharrec_   Base_Part_Characteristic_API.Public_Rec;
      BEGIN
      -- Get config spec value infos
         csvrec_ := Config_Spec_Value_API.Get(newrec_.configuration_id, newrec_.part_no, newrec_.spec_revision_no,
                                              newrec_.characteristic_id, newrec_.config_spec_value_id);
	 IF user_characteristic_value_ IS NULL AND user_qty_characteristic_ IS NULL THEN
            characteristic_value_ := csvrec_.characteristic_value;
         ELSE
            characteristic_value_ := user_characteristic_value_;
         END IF;
         IF user_qty_characteristic_ IS NULL THEN
            config_data_type_ := csvrec_.config_data_type;
            config_value_type_ := csvrec_.config_value_type;
            qty_characteristic_ := csvrec_.qty_characteristic;
         ELSE
            config_data_type_ := Config_Characteristic_API.Get_Config_Data_Type_Db(newrec_.characteristic_id);
            config_value_type_ := Config_Characteristic_API.Get_Config_Value_Type_Db(newrec_.characteristic_id); 
            qty_characteristic_ := user_qty_characteristic_;
         END IF;
         -- Get config value tab
         config_value_type_ := Config_Characteristic_API.Get_Config_Value_Type_Db(newrec_.characteristic_id);
         -- Get info from BasePartCharacteristic
         bpcharrec_ := Base_Part_Characteristic_API.Get(newrec_.part_no,newrec_.spec_revision_no,newrec_.characteristic_id);
         price_break_type_ := bpcharrec_.price_break_type;
         char_qty_price_method_ := bpcharrec_.char_qty_price_method;
         IF config_data_type_ = 'NUMERIC' THEN
            num_value_ok_ := Config_Manager_API.Check_Numeric_Char_Value(characteristic_value_);
            IF num_value_ok_ = 1 THEN
               char_value_ := To_Number(characteristic_value_);
            END IF;
         END IF;
      END;
   $END


   Trace_SYS.Field(' ===> Characteristic_Value ('|| config_data_type_ || ',' || config_value_type_|| ')', characteristic_value_);
   Trace_SYS.Field(' ===> Qty_Characteristic ('|| price_break_type_ ||')', qty_characteristic_);
   Trace_SYS.Field(' ===> Price_List_No at ' || headrec_.contract || ' in ' ||headrec_.currency_code , headrec_.price_list_no );
   Trace_SYS.Field(' ===> Catalog_No = '|| headrec_.catalog_no, newrec_.spec_revision_no);

   -- Test if exist an agreement
   -- Not done here
   -- Test if price list exist
   IF headrec_.price_list_no IS NOT NULL THEN

      price_list_currcode_ := Sales_Price_List_API.Get_Currency_Code(headrec_.price_list_no);
      -- Check price info in configuration based price tab based on configuration family.
      IF Char_Based_Price_List_API.Is_Valid_Price_List( headrec_.price_list_no, 
                                                            newrec_.characteristic_id,
                                                            headrec_.contract,
                                                            headrec_.currency_code,
                                                            headrec_.catalog_no,
                                                            price_effectivity_date_) = 'TRUE' THEN
         Trace_SYS.Field('characteristic price list ' || headrec_.price_list_no ||' is valid at ',price_effectivity_date_);

         Char_Based_Price_List_API.Get_Price_List_Infos( newrec_.characteristic_percentage,
                                                             characteristic_amount_,
                                                             char_amount_incl_tax_,
                                                             newrec_.char_multiply_by_qty,
                                                             stop_price_search_,
                                                             headrec_.price_list_no,
                                                             newrec_.characteristic_id,
                                                             char_value_,
                                                             qty_characteristic_,
                                                             headrec_.contract,
                                                             headrec_.catalog_no,
                                                             price_effectivity_date_,
                                                             eval_rec_);
                                                             
         use_price_incl_tax_db_ := Sales_Price_List_API.Get_Use_Price_Incl_Tax_Db( headrec_.price_list_no);    
         IF use_price_incl_tax_db_ = 'TRUE' THEN      
            characteristic_amount_ := char_amount_incl_tax_;  
         END IF;
         valid_char_price_list_ := TRUE;         
         
         char_price_fetched_:= stop_price_search_ IS NOT NULL;

         Trace_SYS.Field(' got from price list for Char '||To_Char( newrec_.characteristic_percentage) || '% + ', characteristic_amount_);

         newrec_.characteristic_source := 'PRICELIST';
         newrec_.pricing_ref := headrec_.price_list_no;
      END IF;
      
      -- Note: Manage option value
      Trace_Sys.Field('Looking for option pricing ', characteristic_value_);
      IF Char_Based_Opt_Price_List_API.Is_Valid_Price_List( headrec_.price_list_no,
                                                          newrec_.characteristic_id,
                                                          characteristic_value_,
                                                          headrec_.contract,
                                                          headrec_.currency_code,
                                                          headrec_.catalog_no,
                                                          price_effectivity_date_) = 'TRUE' THEN
         -- Note: Get option value from price list
         Trace_SYS.Field('option price list valid at ', price_effectivity_date_);
         Char_Based_Opt_Price_List_API.Get_Price_List_Infos( newrec_.option_percentage,
                                                           option_amount_,
                                                           option_amount_incl_tax_,
                                                           newrec_.opt_multiply_by_qty,
                                                           headrec_.price_list_no,
                                                           newrec_.characteristic_id,
                                                           characteristic_value_,
                                                           headrec_.contract,
                                                           headrec_.catalog_no,
                                                           price_effectivity_date_);
         valid_option_price_list_ := TRUE;
         option_price_fetched_ := newrec_.opt_multiply_by_qty IS NOT NULL;
         Trace_SYS.Field(' got from price list for option '||To_Char( newrec_.option_percentage) || '% + ', option_amount_);
      ELSE
         Trace_SYS.Message('No valid option price list');
         newrec_.option_percentage := NULL;
         option_amount_ := NULL;
         newrec_.opt_multiply_by_qty := 'NO';
      END IF;
      newrec_.option_source := 'PRICELIST'; -- just set it if are not supposed to get it from the next level at all.

      Trace_Sys.Field ('search on?',stop_price_search_);
      IF char_price_fetched_ AND (NOT option_price_fetched_) AND (stop_price_search_ = 'CONTINUE') THEN
         -- Get option value from configuration prices list 
         Option_Value_Price_List_API.Get_Price_List_Infos( newrec_.option_percentage,
                                                           option_amount_,
                                                           option_amount_incl_tax_,
                                                           newrec_.opt_multiply_by_qty,
                                                           headrec_.price_list_no,
                                                           newrec_.part_no,
                                                           newrec_.spec_revision_no,
                                                           newrec_.characteristic_id,
                                                           characteristic_value_,
                                                           char_value_,
                                                           qty_characteristic_,
                                                           headrec_.contract,
                                                           headrec_.catalog_no,
                                                           price_effectivity_date_);
                                                           
         Trace_SYS.Field(' got from price list for option '||To_Char( newrec_.option_percentage) || '% + ', option_amount_);                                                 
         option_price_fetched_ := newrec_.opt_multiply_by_qty IS NOT NULL;       
         newrec_.option_source := 'PRICELIST';
         
      END IF;
      
      IF char_price_fetched_ AND (NOT option_price_fetched_) AND (stop_price_search_ = 'CONTINUE') THEN
            -- Get option value from base prices
            Option_Value_Base_Price_API.Get_Price_Infos( newrec_.option_percentage,
                                                         option_amount_,
                                                         option_amount_incl_tax_,
                                                         newrec_.opt_multiply_by_qty,
                                                         headrec_.contract,
                                                         headrec_.catalog_no,
                                                         newrec_.part_no,
                                                         newrec_.spec_revision_no,
                                                         newrec_.characteristic_id,
                                                         characteristic_value_,
                                                         price_effectivity_date_ );
                                                         
            Trace_SYS.Field(' got from price list for option '||To_Char( newrec_.option_percentage) || '% + ', option_amount_);                                                    
            newrec_.option_source := 'BASE';
      END IF;
      
      -- move to configuration price list to check for price info
      IF (NOT char_price_fetched_) AND (NOT option_price_fetched_) THEN
         IF Characteristic_Price_List_API.Is_Valid_Price_List( headrec_.price_list_no, 
                                                               newrec_.part_no,
                                                               newrec_.spec_revision_no,
                                                               newrec_.characteristic_id,
                                                               headrec_.contract,
                                                               headrec_.currency_code,
                                                               headrec_.catalog_no,
                                                               price_effectivity_date_) = 'TRUE' THEN
            Trace_SYS.Field('characteristic price list ' || headrec_.price_list_no ||' is valid at ',price_effectivity_date_);

            Characteristic_Price_List_API.Get_Price_List_Infos( newrec_.characteristic_percentage,
                                                                characteristic_amount_,
                                                                char_amount_incl_tax_,
                                                                newrec_.char_multiply_by_qty,
                                                                stop_price_search_,
                                                                headrec_.price_list_no,
                                                                newrec_.part_no,
                                                                newrec_.spec_revision_no,
                                                                newrec_.characteristic_id,
                                                                char_value_,
                                                                qty_characteristic_,
                                                                headrec_.contract,
                                                                price_break_type_,
                                                                headrec_.catalog_no,
                                                                price_effectivity_date_,
                                                                eval_rec_);
            valid_char_price_list_ := TRUE;         

            char_price_fetched_:= stop_price_search_ IS NOT NULL;

            Trace_SYS.Field(' got from price list for Char '||To_Char( newrec_.characteristic_percentage) || '% + ', characteristic_amount_);

            newrec_.characteristic_source := 'PRICELIST';
            newrec_.pricing_ref := headrec_.price_list_no;

         END IF;

         -- Note: Manage option value
         Trace_Sys.Field('Looking for option pricing ', characteristic_value_);
         IF Option_Value_Price_List_API.Is_Valid_Price_List( headrec_.price_list_no,
                                                             newrec_.part_no,
                                                             newrec_.spec_revision_no,
                                                             newrec_.characteristic_id,
                                                             characteristic_value_,
                                                             headrec_.contract,
                                                             headrec_.currency_code,
                                                             headrec_.catalog_no,
                                                             price_effectivity_date_) = 'TRUE' THEN
            -- Note: Get option value from price list
            Trace_SYS.Field('option price list valid at ', price_effectivity_date_);
            Option_Value_Price_List_API.Get_Price_List_Infos( newrec_.option_percentage,
                                                              option_amount_,
                                                              option_amount_incl_tax_,
                                                              newrec_.opt_multiply_by_qty,
                                                              headrec_.price_list_no,
                                                              newrec_.part_no,
                                                              newrec_.spec_revision_no,
                                                              newrec_.characteristic_id,
                                                              characteristic_value_,
                                                              char_value_,
                                                              qty_characteristic_,
                                                              headrec_.contract,
                                                              headrec_.catalog_no,
                                                              price_effectivity_date_);
            valid_option_price_list_ := TRUE;
            option_price_fetched_ := newrec_.opt_multiply_by_qty IS NOT NULL;
            Trace_SYS.Field(' got from price list for option '||To_Char( newrec_.option_percentage) || '% + ', option_amount_);
         ELSE
            Trace_SYS.Message('No valid option price list');
            newrec_.option_percentage := NULL;
            option_amount_ := NULL;
            newrec_.opt_multiply_by_qty := 'NO';
         END IF;
         newrec_.option_source := 'PRICELIST'; -- just set it if are not supposed to get it from the next level at all.

         Trace_Sys.Field ('search on?',stop_price_search_);
         IF char_price_fetched_ AND (NOT option_price_fetched_) AND (stop_price_search_ = 'CONTINUE') THEN
            -- Get option value from base prices
            Option_Value_Base_Price_API.Get_Price_Infos( newrec_.option_percentage,
                                                         option_amount_,
                                                         option_amount_incl_tax_,
                                                         newrec_.opt_multiply_by_qty,
                                                         headrec_.contract,
                                                         headrec_.catalog_no,
                                                         newrec_.part_no,
                                                         newrec_.spec_revision_no,
                                                         newrec_.characteristic_id,
                                                         characteristic_value_,
                                                         price_effectivity_date_ );
            newrec_.option_source := 'BASE';
         END IF;
      END IF;
   END IF;

   IF (NOT char_price_fetched_) AND (NOT option_price_fetched_) THEN
      -- Get base price
      -- Characteristic price
      Trace_SYS.Message('Base price');
      Characteristic_Base_Price_API.Get_Price_Infos( newrec_.characteristic_percentage,
                                                     characteristic_amount_,
                                                     char_amount_incl_tax_,
                                                     newrec_.char_multiply_by_qty,
                                                     headrec_.contract,
                                                     headrec_.catalog_no,
                                                     newrec_.part_no,
                                                     newrec_.spec_revision_no,
                                                     newrec_.characteristic_id,
                                                     char_value_,
                                                     qty_characteristic_,
                                                     price_break_type_,
                                                     price_effectivity_date_,
                                                     eval_rec_);

      newrec_.characteristic_source := 'BASE';
     
      -- Option value price
      Option_Value_Base_Price_API.Get_Price_Infos( newrec_.option_percentage,
                                                   option_amount_,
                                                   option_amount_incl_tax_,
                                                   newrec_.opt_multiply_by_qty,
                                                   headrec_.contract,
                                                   headrec_.catalog_no,
                                                   newrec_.part_no,
                                                   newrec_.spec_revision_no,
                                                   newrec_.characteristic_id,
                                                   characteristic_value_,
                                                   price_effectivity_date_ );

      newrec_.option_source := 'BASE';
   END IF;
   
   Configured_Line_Price_API.Get_Config_Type_Identity(identity_, configured_line_type_, newrec_.configured_line_price_id);
   IF (configured_line_type_ = Configured_Line_Type_API.DB_CUSTOMER_ORDER_LINE) THEN
      use_price_incl_tax_db_ := Customer_order_API.Get_Use_Price_Incl_Tax_Db(identity_);
   ELSIF (configured_line_type_ = Configured_Line_Type_API.DB_SALES_QUOTATION_LINE) THEN
      use_price_incl_tax_db_ := Order_Quotation_API.Get_Use_Price_Incl_Tax_Db(identity_);     
   END IF;

   IF (use_price_incl_tax_db_ = 'TRUE') THEN
      characteristic_amount_ := char_amount_incl_tax_;
      option_amount_ := option_amount_incl_tax_;
   END IF;
   
   IF (headrec_.currency_code != price_list_currcode_) THEN
      IF valid_char_price_list_ THEN
         Customer_Order_Pricing_API.Get_Base_Price_In_Currency( base_characteristic_amount_,
                                                                curr_rate_,
                                                                customer_no_pay_,
                                                                headrec_.contract,
                                                                price_list_currcode_,
                                                                characteristic_amount_);
                                                              
         Customer_Order_Pricing_API.Get_Sales_Price_In_Currency( characteristic_amount_,
                                                                 curr_rate_,
                                                                 customer_no_pay_,
                                                                 headrec_.contract,
                                                                 headrec_.currency_code,
                                                                 base_characteristic_amount_);
      END IF;
      
      IF valid_option_price_list_ THEN
         Customer_Order_Pricing_API.Get_Base_Price_In_Currency(base_option_amount_,
                                                               curr_rate_,
                                                               customer_no_pay_,
                                                               headrec_.contract,
                                                               price_list_currcode_,
                                                               option_amount_);
                                                              
         Customer_Order_Pricing_API.Get_Sales_Price_In_Currency(option_amount_,
                                                                curr_rate_,
                                                                customer_no_pay_,
                                                                headrec_.contract,
                                                                headrec_.currency_code,
                                                                base_option_amount_);
      END IF;
   END IF;      
   -- Convert amounts to order/quotation currency
   IF newrec_.characteristic_source = 'BASE' THEN
      Customer_Order_Pricing_API.Get_Sales_Price_In_Currency(newrec_.characteristic_amount,
                                                             curr_rate_,
                                                             customer_no_pay_,
                                                             headrec_.contract,
                                                             headrec_.currency_code,
                                                             characteristic_amount_);
   ELSE
      newrec_.characteristic_amount := characteristic_amount_;
   END IF;

   IF newrec_.option_source = 'BASE' THEN
       Customer_Order_Pricing_API.Get_Sales_Price_In_Currency(newrec_.option_amount,
                                                              curr_rate_,
                                                              customer_no_pay_,
                                                              headrec_.contract,
                                                              headrec_.currency_code,
                                                              option_amount_);
   ELSE
      newrec_.option_amount := option_amount_;
   END IF;

   -- To get prices for null qty we set it to at least 1
   qty_characteristic_ := Nvl(qty_characteristic_ , 1);

   Trace_SYS.Field(' Gnpi 2 PART_PRICE', headrec_.part_price);
   Trace_SYS.Field(' Gnpi CHARACTERISTIC_PERCENTAGE', newrec_.characteristic_percentage);
   Trace_SYS.Field(' Gnpi CHARACTERISTIC_AMOUNT', newrec_.characteristic_amount);
   Trace_SYS.Field(' Gnpi CHARACTERISTIC_SOURCE', newrec_.characteristic_source);
   Trace_SYS.Field(' Gnpi CHAR_MULTIPLY_BY_QTY', newrec_.char_multiply_by_qty);
   Trace_SYS.Field(' Gnpi OPTION_PERCENTAGE', newrec_.option_percentage);
   Trace_SYS.Field(' Gnpi OPTION_AMOUNT', newrec_.option_amount);
   Trace_SYS.Field(' Gnpi OPT_MULTIPLY_BY_QTY', newrec_.opt_multiply_by_qty);
   Trace_SYS.Field(' Gnpi OPTION_SOURCE', newrec_.option_source);
   
   -- Calculate characteristic price
   newrec_.calc_char_price := NULL;
   IF newrec_.char_multiply_by_qty = 'MULTIPLY' THEN
      newrec_.calc_char_price := (((headrec_.part_price * (NVL(newrec_.characteristic_percentage,0) / 100)) +  NVL(newrec_.characteristic_amount,0)) * qty_characteristic_ );
   ELSE
      newrec_.calc_char_price := ((headrec_.part_price * (NVL(newrec_.characteristic_percentage,0) / 100)) + NVL(newrec_.characteristic_amount,0));
   END IF;

   IF newrec_.opt_multiply_by_qty = 'MULTIPLY' THEN
      newrec_.calc_char_price := newrec_.calc_char_price + (((headrec_.part_price * (NVL(newrec_.option_percentage,0) / 100)) + NVL(newrec_.option_amount,0)) * qty_characteristic_ );
   ELSE
      newrec_.calc_char_price := newrec_.calc_char_price + ((headrec_.part_price * (NVL(newrec_.option_percentage,0) / 100)) +  NVL(newrec_.option_amount,0));
   END IF;

   -- IF all contributions are null so the calculated price is null
   IF newrec_.characteristic_amount IS NULL AND newrec_.characteristic_percentage IS NULL AND newrec_.option_amount IS NULL AND newrec_.option_percentage IS NULL THEN
      newrec_.calc_char_price := NULL;
   END IF;

   Trace_SYS.Field('CALC_CHAR_PRICE', newrec_.calc_char_price);
   
   $IF Component_Cfgchr_SYS.INSTALLED $THEN
   package_content_ := Config_Spec_Value_Api.Get_Package_Content(newrec_.configuration_id, 
                                                                 newrec_.part_no,newrec_.spec_revision_no,
                                                                 newrec_.characteristic_id,                          
                                                                 newrec_.config_spec_value_id);
   $END
   
   IF newrec_.price_freeze = 'FREE' THEN
      IF (package_content_ IS NULL) THEN 
         newrec_.characteristic_price := newrec_.calc_char_price;
      ELSE
         newrec_.characteristic_price := NVL(newrec_.characteristic_price,0);
      END IF;
   END IF;
   Trace_SYS.Field('CHARACTERISTIC_PRICE', newrec_.characteristic_price);

   -- IF no price was fetched
   IF newrec_.calc_char_price IS NULL THEN
      -- Clear sources
      newrec_.characteristic_source := NULL;
      newrec_.option_source := NULL;
   END IF;
   -- Set default value from BasePartCharacteristic is null
   IF newrec_.char_multiply_by_qty IS NULL THEN
      newrec_.char_multiply_by_qty := char_qty_price_method_;
   END IF;
   IF newrec_.opt_multiply_by_qty IS NULL THEN
      newrec_.opt_multiply_by_qty := char_qty_price_method_;
   END IF;
END Get_New_Pricing_Info___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr( 'PRICE_FREEZE_DB', 'FREE', attr_ );
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT CONFIG_CHAR_PRICE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   super(objid_, objversion_, newrec_, attr_);
   Client_SYS.Add_To_Attr('CHARACTERISTIC_PRICE', newrec_.characteristic_price, attr_);
   Client_SYS.Add_To_Attr('CALC_CHAR_PRICE', newrec_.calc_char_price, attr_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     CONFIG_CHAR_PRICE_TAB%ROWTYPE,
   newrec_     IN OUT CONFIG_CHAR_PRICE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   -- IF the price is frozen get it back again
   -- Price should only be Frozen if the frozen flag remains frozen before and after editing.
   
   IF (newrec_.price_freeze = 'FROZEN' AND oldrec_.price_freeze = 'FROZEN') THEN
      newrec_.characteristic_price := oldrec_.characteristic_price;
   END IF;
   
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   Client_SYS.Add_To_Attr('CHARACTERISTIC_PRICE', newrec_.characteristic_price, attr_);
   Client_SYS.Add_To_Attr('CALC_CHAR_PRICE', newrec_.calc_char_price, attr_);
END Update___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT config_char_price_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
   characteristic_price_ NUMBER := NULL;
BEGIN
   characteristic_price_ := newrec_.characteristic_price;

   -- Get pricing information
   Get_New_Pricing_Info___( newrec_, NULL, NULL );

   IF characteristic_price_ IS NOT NULL THEN
      -- manually entered will override calculated
      newrec_.characteristic_price := characteristic_price_;   
   END IF;
   super(newrec_, indrec_, attr_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     config_char_price_tab%ROWTYPE,
   newrec_ IN OUT config_char_price_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
   characteristic_price_ NUMBER := NULL;
   calc_char_price_      NUMBER := NULL;
BEGIN
   IF indrec_.characteristic_price = TRUE THEN
      characteristic_price_ := newrec_.characteristic_price;
   END IF;
   IF indrec_.calc_char_price THEN
      calc_char_price_ := newrec_.calc_char_price;
   END IF;

   IF (indrec_.calc_char_price = TRUE OR indrec_.characteristic_price = TRUE) AND indrec_.char_price_offset = FALSE THEN
      newrec_.char_price_offset := NULL;
   END IF;  
   -- Get pricing information
   Get_New_Pricing_Info___( newrec_, NULL, NULL );

   IF characteristic_price_ IS NOT NULL THEN
      -- manually entered will override calculated, the freeze is checked in update___
      newrec_.characteristic_price := characteristic_price_;
   END IF;
   IF calc_char_price_ IS NOT NULL THEN
      newrec_.calc_char_price := calc_char_price_;
   END IF;
  
   super(oldrec_, newrec_, indrec_, attr_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Insert__
--   Inserts records in the table. Used for copying purposes.
PROCEDURE Insert__ (
   rec_  IN OUT CONFIG_CHAR_PRICE_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   -- assume record is being copied.
   objid_       VARCHAR2(2000);
   objversion_  VARCHAR2(2000);
   newrec_      CONFIG_CHAR_PRICE_TAB%ROWTYPE := rec_;
   temp_        VARCHAR2(2000);
BEGIN
   newrec_.rowkey := NULL;
   Insert___(objid_, objversion_, newrec_, temp_);
END Insert__;


-- Copy_Pricing_Util__
--   Copies the price information for a specified ConfiguredLinePriceId and
--   configuration id to a use with the same ConfiguredLinePriceId and
--   an other configuration id.
PROCEDURE Copy_Pricing_Util__ (
   configured_line_price_id_ IN     NUMBER,
   part_no_                  IN     VARCHAR2,
   configuration_id_         IN     VARCHAR2,
   spec_revision_no_         IN     NUMBER,
   characteristic_id_        IN     VARCHAR2,
   config_spec_value_id_     IN     NUMBER )
IS
   config_exist_ BOOLEAN;
   attr_         VARCHAR2(32000);
BEGIN
   config_exist_ := Check_Exist___ (configured_line_price_id_, part_no_, configuration_id_,
                                 spec_revision_no_, characteristic_id_, config_spec_value_id_);    
   IF config_exist_ THEN            
      Trace_Sys.Field(' CopPU updating',  configuration_id_);
      Modify( configured_line_price_id_ , part_no_ , configuration_id_ ,
                  spec_revision_no_ , characteristic_id_ , config_spec_value_id_ ,
                  attr_ );
   ELSE
      Trace_Sys.Field(' CopPU inserting to',  configuration_id_);
      New( configured_line_price_id_, part_no_, configuration_id_,
              spec_revision_no_, characteristic_id_, config_spec_value_id_,
              attr_ );
   END IF;
   Trace_Sys.Field(' CopPU attr ', attr_);
END Copy_Pricing_Util__;


-- Get_New_Pricing_Info__
--   Procedure that returns the pricing information for a new line.
--   Searches the (agreements) price lists, and the base prices.
--   This is used by other LUs in order to fetch the latest prices.
PROCEDURE Get_New_Pricing_Info__ (
   newrec_               IN OUT CONFIG_CHAR_PRICE_TAB%ROWTYPE,
   characteristic_value_ IN     VARCHAR2 DEFAULT NULL,
   qty_characteristic_   IN     NUMBER DEFAULT NULL,
   eval_rec_                   IN Characteristic_Base_Price_API.config_price_comb_rec  DEFAULT NULL)
IS
BEGIN   
   IF (characteristic_value_ IS NOT NULL) THEN      
      Get_New_Pricing_Info___(newrec_, NULL, NULL, characteristic_value_, qty_characteristic_,eval_rec_ => eval_rec_ );
   ELSE
      Get_New_Pricing_Info___(newrec_, NULL, NULL, eval_rec_ => eval_rec_);
   END IF;
END Get_New_Pricing_Info__;


-- Get_New_Pricing_Info__
--   Procedure that returns the pricing information for a new line.
--   Searches the (agreements) price lists, and the base prices.
--   This is used by other LUs in order to fetch the latest prices.
PROCEDURE Get_New_Pricing_Info__ (
   newrec_                    IN OUT Public_Rec,
   characteristic_value_      IN     VARCHAR2 DEFAULT NULL,
   configured_line_price_id_  IN NUMBER,
   part_no_                   IN VARCHAR2,
   configuration_id_          IN VARCHAR2,
   spec_revision_no_          IN NUMBER,
   characteristic_id_         IN VARCHAR2,
   config_spec_value_id_      IN NUMBER,
   eval_rec_                  IN Characteristic_Base_Price_API.config_price_comb_rec  DEFAULT NULL)
IS
   rec_ CONFIG_CHAR_PRICE_TAB%ROWTYPE;
BEGIN

   --rec_.characteristic_value := characteristic_value_;
   rec_.configured_line_price_id := configured_line_price_id_;
   rec_.part_no := part_no_;
   rec_.configuration_id := configuration_id_;
   rec_.spec_revision_no := spec_revision_no_;
   rec_.characteristic_id := characteristic_id_;
   rec_.config_spec_value_id := config_spec_value_id_;
   rec_.characteristic_amount := newrec_.characteristic_amount;
   rec_.characteristic_percentage := newrec_.characteristic_percentage;
   rec_.option_amount := newrec_.option_amount;
   rec_.option_percentage := newrec_.option_percentage;
   rec_.characteristic_price := newrec_.characteristic_price;
   rec_.calc_char_price := newrec_.calc_char_price;
   rec_.characteristic_source := newrec_.characteristic_source;
   rec_.option_source := newrec_.option_source;
   rec_.opt_multiply_by_qty := newrec_.opt_multiply_by_qty;
   rec_.char_multiply_by_qty := newrec_.char_multiply_by_qty;
   rec_.price_freeze := newrec_.price_freeze;
   rec_.pricing_ref := newrec_.pricing_ref;

   IF (characteristic_value_ IS NOT NULL) THEN      
      Get_New_Pricing_Info___(rec_, NULL, NULL, characteristic_value_, eval_rec_ => eval_rec_ );
   ELSE     
      Get_New_Pricing_Info___(rec_, NULL, NULL, eval_rec_ => eval_rec_ );
   END IF;
END Get_New_Pricing_Info__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- New
--   Public method for creating new object
PROCEDURE New (
   configured_line_price_id_ IN     NUMBER,
   part_no_                  IN     VARCHAR2,
   configuration_id_         IN     VARCHAR2,
   spec_revision_no_         IN     NUMBER,
   characteristic_id_        IN     VARCHAR2,
   config_spec_value_id_     IN     NUMBER,
   attr_                     IN OUT VARCHAR2 )
IS
   newrec_  CONFIG_CHAR_PRICE_TAB%ROWTYPE;
   objid_   CONFIG_CHAR_PRICE.objid%TYPE;
   objver_  CONFIG_CHAR_PRICE.objversion%TYPE;
   defattr_ VARCHAR2(2000);
   indrec_  Indicator_Rec;
BEGIN
   Prepare_Insert___( defattr_ );
   attr_ := defattr_ || attr_;
   Client_SYS.Add_To_Attr( 'CONFIGURED_LINE_PRICE_ID', configured_line_price_id_, attr_ );
   Client_SYS.Add_To_Attr( 'PART_NO', part_no_, attr_ );
   Client_SYS.Add_To_Attr( 'CONFIGURATION_ID', configuration_id_, attr_ );
   Client_SYS.Add_To_Attr( 'SPEC_REVISION_NO', spec_revision_no_, attr_ );
   Client_SYS.Add_To_Attr( 'CHARACTERISTIC_ID', characteristic_id_, attr_ );
   Client_SYS.Add_To_Attr( 'CONFIG_SPEC_VALUE_ID', config_spec_value_id_, attr_ );   
   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___( objid_, objver_, newrec_, attr_ );
END New;


-- Modify
--   Public method for modifying object.
PROCEDURE Modify (
   configured_line_price_id_ IN     NUMBER,
   part_no_                  IN     VARCHAR2,
   configuration_id_         IN     VARCHAR2,
   spec_revision_no_         IN     NUMBER,
   characteristic_id_        IN     VARCHAR2,
   config_spec_value_id_     IN     NUMBER,
   attr_                     IN OUT VARCHAR2 )
IS
   oldrec_  CONFIG_CHAR_PRICE_TAB%ROWTYPE;
   newrec_  CONFIG_CHAR_PRICE_TAB%ROWTYPE;
   objid_   CONFIG_CHAR_PRICE.objid%TYPE;
   objver_  CONFIG_CHAR_PRICE.objversion%TYPE;
   indrec_  Indicator_Rec;
BEGIN
   Trace_Sys.Field('Modifying ' || To_Char(configured_line_price_id_ )||' '|| part_no_ ||' '|| configuration_id_ ||' '|| to_char(spec_revision_no_) ||' '||
                   characteristic_id_  ||' '|| config_spec_value_id_, attr_  );
   oldrec_ := Lock_By_Keys___( configured_line_price_id_, part_no_, configuration_id_, spec_revision_no_,
                               characteristic_id_, config_spec_value_id_ );
   newrec_ := oldrec_;   
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   
   Update___( objid_, oldrec_, newrec_, attr_, objver_, TRUE );
END Modify;


-- Remove
--   Public method for removing object.
PROCEDURE Remove (
   configured_line_price_id_ IN NUMBER,
   part_no_                  IN VARCHAR2,
   configuration_id_         IN VARCHAR2,
   spec_revision_no_         IN NUMBER,
   characteristic_id_        IN VARCHAR2,
   config_spec_value_id_     IN NUMBER )
IS
   remrec_        CONFIG_CHAR_PRICE_TAB%ROWTYPE;
   objid_         CONFIG_CHAR_PRICE.objid%TYPE;
   objversion_    CONFIG_CHAR_PRICE.objversion%TYPE;
BEGIN
   Get_Id_Version_By_Keys___ ( objid_, objversion_,
                               configured_line_price_id_, part_no_, configuration_id_, spec_revision_no_,
                               characteristic_id_, config_spec_value_id_);
   remrec_ := Lock_By_Keys___( configured_line_price_id_, part_no_, configuration_id_, spec_revision_no_,
                               characteristic_id_, config_spec_value_id_ );
   Check_Delete___(remrec_);
   Delete___(objid_, remrec_);
END Remove;


-- Re_Price_Line
--   Calls for getting the price again for a line.
PROCEDURE Re_Price_Line (
   configured_line_price_id_ IN NUMBER,
   part_no_                  IN VARCHAR2,
   configuration_id_         IN VARCHAR2,
   spec_revision_no_         IN NUMBER,
   characteristic_id_        IN VARCHAR2,
   config_spec_value_id_     IN NUMBER )
IS
   oldrec_               CONFIG_CHAR_PRICE_TAB%ROWTYPE;
   newrec_               CONFIG_CHAR_PRICE_TAB%ROWTYPE;
   objid_                VARCHAR2(2000);
   objversion_           VARCHAR2(2000);
   attr_                 VARCHAR2(2000);
   characteristic_price_ NUMBER := NULL;
   calc_char_price_      NUMBER := NULL;
BEGIN
   oldrec_ := Lock_By_Keys___
      (configured_line_price_id_, part_no_,
       configuration_id_, spec_revision_no_,
       characteristic_id_, config_spec_value_id_ );
   newrec_ := oldrec_;
   
   characteristic_price_ := newrec_.characteristic_price;
   calc_char_price_ := newrec_.calc_char_price;
   
   Get_New_Pricing_Info___(newrec_, NULL, NULL);
   newrec_.char_price_offset := NULL;

   IF calc_char_price_ IS NULL AND characteristic_price_ IS NOT NULL THEN
      -- manually entered will override calculated
      newrec_.characteristic_price := characteristic_price_;   
   END IF;
   
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
END Re_Price_Line;

PROCEDURE Set_Price_Offset (
   configured_line_price_id_ IN NUMBER,
   part_no_                  IN VARCHAR2,
   configuration_id_         IN VARCHAR2,
   spec_revision_no_         IN NUMBER,
   characteristic_id_        IN VARCHAR2,
   config_spec_value_id_     IN NUMBER,
   offset_                   IN NUMBER )
IS
   oldrec_               CONFIG_CHAR_PRICE_TAB%ROWTYPE;
   newrec_               CONFIG_CHAR_PRICE_TAB%ROWTYPE;
   objid_                VARCHAR2(2000);
   objversion_           VARCHAR2(2000);
   attr_                 VARCHAR2(2000);
BEGIN
   IF Nvl(offset_, 0) = 0 THEN
      RETURN;
   END IF;
   
   oldrec_ := Lock_By_Keys___(configured_line_price_id_, part_no_, configuration_id_, spec_revision_no_, characteristic_id_, config_spec_value_id_);
   newrec_ := oldrec_;
   newrec_.characteristic_price := newrec_.characteristic_price + offset_;
   newrec_.char_price_offset := Nvl(newrec_.char_price_offset, 0) + offset_;
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
END Set_Price_Offset;

PROCEDURE Clear_Price_Offset (
   configured_line_price_id_ IN NUMBER,
   part_no_                  IN VARCHAR2,
   configuration_id_         IN VARCHAR2,
   spec_revision_no_         IN NUMBER,
   characteristic_id_        IN VARCHAR2,
   config_spec_value_id_     IN NUMBER )
IS
   oldrec_               CONFIG_CHAR_PRICE_TAB%ROWTYPE;
   newrec_               CONFIG_CHAR_PRICE_TAB%ROWTYPE;
   objid_                VARCHAR2(2000);
   objversion_           VARCHAR2(2000);
   attr_                 VARCHAR2(2000);
BEGIN
   oldrec_ := Lock_By_Keys___(configured_line_price_id_, part_no_, configuration_id_, spec_revision_no_, characteristic_id_, config_spec_value_id_);
   newrec_ := oldrec_;
   newrec_.characteristic_price := newrec_.characteristic_price - newrec_.char_price_offset;
   newrec_.char_price_offset := NULL;
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
END Clear_Price_Offset;

-- Get_Calculated_Char_Prices
--   Passes the configured line price id , part no, price list no,
--   and price effectividate to calculate the char prices.
--   The purpose of this function is to show the correct char prices before the user
--   saves the values in the client. The modified price effectivity date or
--   price list no is used when recalculating the char prices.
--   Therfore the calculations are not done using the stored price list
--   no or price effectivity date.
PROCEDURE Get_Calculated_Char_Prices (
   char_price_               OUT NUMBER,
   calc_char_price_          OUT NUMBER,
   configured_line_price_id_ IN  NUMBER,
   part_no_                  IN  VARCHAR2,
   price_list_no_            IN  VARCHAR2,
   configuration_id_         IN  VARCHAR2,
   price_effectivity_date_   IN  DATE )
IS
   newrec_     CONFIG_CHAR_PRICE_TAB%ROWTYPE;

   CURSOR get_config_char_price_rec IS
      SELECT spec_revision_no, characteristic_id, config_spec_value_id
      FROM   CONFIG_CHAR_PRICE_TAB
      WHERE  configured_line_price_id = configured_line_price_id_
      AND    part_no = part_no_
      AND    configuration_id = configuration_id_;
BEGIN
   
   char_price_ := 0;
   calc_char_price_ := 0;
   
   FOR config_char_price_rec_ IN get_config_char_price_rec  LOOP
      newrec_ := Get_Object_By_Keys___ (configured_line_price_id_, 
                                        part_no_,
                                        configuration_id_,
                                        config_char_price_rec_.spec_revision_no,
                                        config_char_price_rec_.characteristic_id, 
                                        config_char_price_rec_.config_spec_value_id );

      Get_New_Pricing_Info___(newrec_, NVL(price_list_no_, Database_SYS.string_null_) , price_effectivity_date_ );
      calc_char_price_ := calc_char_price_ + NVL(newrec_.calc_char_price, 0);
      char_price_ := char_price_ + NVL(newrec_.characteristic_price, 0);
   END LOOP;
END Get_Calculated_Char_Prices;


-- Get_Exist
--   Returns a value depending on whether the specified objects exists in the database.
@UncheckedAccess
FUNCTION Get_Exist (
   configured_line_price_id_ IN NUMBER,
   part_no_                  IN VARCHAR2,
   configuration_id_         IN VARCHAR2,
   spec_revision_no_         IN NUMBER,
   characteristic_id_        IN VARCHAR2,
   config_spec_value_id_     IN NUMBER ) RETURN VARCHAR2
IS
BEGIN
   IF (Check_Exist___(configured_line_price_id_, part_no_, configuration_id_, spec_revision_no_, characteristic_id_, config_spec_value_id_)) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END;


FUNCTION Get_New_Char_Value_Price(
   configured_line_price_id_ IN NUMBER,
   part_no_                  IN VARCHAR2,
   configuration_id_         IN VARCHAR2,
   spec_revision_no_         IN NUMBER,
   characteristic_id_        IN VARCHAR2,
   config_spec_value_id_     IN NUMBER,
   characteristic_value_     IN VARCHAR2,
   qty_characteristic_       IN NUMBER,
   contract_                 IN VARCHAR2 DEFAULT NULL,
   catalog_no_               IN VARCHAR2 DEFAULT NULL,
   customer_no_              IN VARCHAR2 DEFAULT NULL,
   currency_code_            IN VARCHAR2 DEFAULT NULL,
   part_price_               IN NUMBER DEFAULT NULL,
   eval_rec_                 IN Characteristic_Base_Price_API.config_price_comb_rec DEFAULT NULL) RETURN NUMBER
IS
   rec_ CONFIG_CHAR_PRICE_TAB%ROWTYPE;
   price_list_ VARCHAR2(30):=NULL;

   CURSOR get_rec IS
      SELECT *
      FROM CONFIG_CHAR_PRICE_TAB
      WHERE configured_line_price_id = configured_line_price_id_
      AND   part_no = part_no_
      AND   configuration_id = configuration_id_
      AND   spec_revision_no = spec_revision_no_
      AND   characteristic_id = characteristic_id_
      AND   config_spec_value_id = config_spec_value_id_;
BEGIN

   OPEN get_rec;
   FETCH get_rec INTO rec_;
   IF get_rec%NOTFOUND THEN
      rec_.part_no := part_no_;
      rec_.spec_revision_no := spec_revision_no_;
      rec_.characteristic_id := characteristic_id_;
      rec_.configuration_id := configuration_id_;
      rec_.characteristic_amount := qty_characteristic_;
      rec_.configured_line_price_id := configured_line_price_id_;
   END IF;
   CLOSE get_rec;
      
	IF (Nvl(rec_.price_freeze, '-') != 'FROZEN') THEN
		price_list_ := configured_line_price_api.Get_Price_List_No(configured_line_price_id_);
      Get_New_Pricing_Info___(rec_, price_list_, NULL, characteristic_value_, qty_characteristic_,
         contract_, catalog_no_, customer_no_, currency_code_, part_price_,eval_rec_);
      RETURN rec_.calc_char_price;
   ELSE
      RETURN rec_.characteristic_price;
   END IF;
END Get_New_Char_Value_Price;


FUNCTION Get_Total_Calc_Price (
   configured_line_price_id_ IN NUMBER,
   part_no_                  IN VARCHAR2,
   configuration_id_         IN VARCHAR2,
   spec_revision_no_         IN NUMBER,
   config_group_id_          IN VARCHAR2) RETURN NUMBER
IS
   CURSOR get_total_calc_price IS
      SELECT SUM(NVL(calc_char_price,0))
      FROM config_char_price_tab c
      WHERE  configured_line_price_id = configured_line_price_id_
      AND part_no = part_no_
      AND spec_revision_no = spec_revision_no_
      $IF Component_Cfgchr_SYS.INSTALLED $THEN
         AND (config_group_id_ IS NULL OR config_group_id_ = Config_Characteristic_API.Get_Config_Group_Id(characteristic_id))
      $END
      AND configuration_id = configuration_id_;
      
   sum_  NUMBER;
BEGIN
   OPEN get_total_calc_price;
   FETCH get_total_calc_price INTO sum_;
   CLOSE get_total_calc_price;
   
   RETURN sum_;
END Get_Total_Calc_Price;

FUNCTION Get_Price_Combination_Id(
   price_source_        IN VARCHAR2,
   price_list_no_       IN VARCHAR2,
   price_date_          IN DATE,
   characteristic_id_   IN VARCHAR2,
   characteristic_value_ IN VARCHAR2,
   qty_characteristic_  IN NUMBER,
   part_no_             IN VARCHAR2,
   spec_revision_no_    IN VARCHAR2,
   configuration_family_ IN VARCHAR2,
   config_line_price_id_ IN VARCHAR2) RETURN VARCHAR2
IS 
   price_combination_id_    VARCHAR2(24);
   catalog_no_    configured_line_price_tab.catalog_no%TYPE;
   contract_      configured_line_price_tab.contract%TYPE;
BEGIN
   catalog_no_ := Configured_Line_Price_API.Get_Catalog_No(config_line_price_id_);
   contract_   := Configured_Line_Price_API.Get_Contract(config_line_price_id_);

   IF price_source_ = 'PRICELIST' THEN
      IF (Char_Based_Price_List_API.Check_Record_Exist(configuration_family_,
                                                       characteristic_id_,
                                                       price_list_no_)) THEN                                                 
         Char_Based_Price_List_API.Get_Price_Combination_Id (
            price_combination_id_,
            price_list_no_,
            characteristic_id_,
            contract_,
            catalog_no_,
            characteristic_value_,
            qty_characteristic_,
            price_date_);
      ELSIF (Characteristic_Price_List_API.Check_Record_Exist(price_list_no_,
                                                                 part_no_,
                                                                 spec_revision_no_,
                                                                 characteristic_id_) ) THEN 

            Characteristic_Price_List_API.Get_Price_Combination_Id (
               price_combination_id_,
               price_list_no_,
               part_no_,
               spec_revision_no_,
               characteristic_id_,
               catalog_no_,
               characteristic_value_,
               qty_characteristic_,
               price_date_); 
      ELSE
         Characteristic_Base_Price_API.Get_Price_Combination_Id (
            price_combination_id_,
            contract_,
            catalog_no_,
            part_no_,
            spec_revision_no_,
            characteristic_id_,
            characteristic_value_,
            qty_characteristic_,
            price_date_);
      END IF;
   ELSIF price_source_ = 'BASE' THEN
      Characteristic_Base_Price_API.Get_Price_Combination_Id (
          price_combination_id_,
          contract_,
          catalog_no_,
          part_no_,
          spec_revision_no_,
          characteristic_id_,
          characteristic_value_,
          qty_characteristic_,
          price_date_);
   ELSE 
      price_combination_id_ := NULL; 
   END IF; 
    trace_sys.message('**.... price_combination_id_'||price_combination_id_);
   RETURN price_combination_id_;
END Get_Price_Combination_Id;