-----------------------------------------------------------------------------
--
--  Logical unit: ConfiguredLinePrice
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220131  UTSWLK   Added Set_Config_Price_Combo_Rec___() to use characteristic combunations in the copy price logic.
--  210713  JICESE   MF21R2-1598, Added public method Has_Price_Offset_Lines.
--  171026  Nikplk   STRSC-13817, Renamed Get method to Get_Config_Line_Connected_Info.
--  140903  ShVese   Changed the incorrect variable in the cursor get_price_sums in Get_Pricing_Totals.
--  140725  ChFolk   Added new method Get_Config_Type_Identity which returns Identity and corresponding configuration_type for a given config_price_id.
--  140611  JICE     Added public method Check_Mandatory_Pricing, refactored from Complete_Pricing.
--  140314  RaNhlk   Bug 113021, Modified Modify_Config_Line_Price() to filter the data in cursor get_config_char_price_rec by configuration_id.
--  140226  ChBnlk   Bug 113704, Modified Copy_Pricing__() by removing parameters old_configuration_id_ and attr_. Modifying the dynamic statement to remove 
--  140226           old_configuration_id_  from method call Config_Char_Price_API.Copy_Pricing_Util__().
--  131025  RoJalk   Modified the view CONFIGURED_LINE_PRICE and changed the lengh of identity_no column to be 12.
--  130704  MaIklk   TIBE-956, Removed inst_ConfigSpecValue_ and Inst_BasePartCharact_ global constants and used conditional compilation instead.
--  130315  MaIklk   Implemented to handle configuration part pricing for business opportunity.
--  120928  SuJalk   Added function Check_Exist.
--  120614  SuJalk   MOSXP-548, Modified the Transfer_Pricing__ function to handle scenarios where the config char price record is already existing.
--  111107  ChJalk   Added user allowed site filter to the view CONFIGURED_LINE_PRICE.
--  100512  Ajpelk   Merge rose method documentation
--  100128  SuJalk   Modified the code when handling the copy pricing for completed configurations. 
--  100122  SuJalk   Added a condition to stop the removing of pricing info when editing completed configuration.
--  090925  SuJalk   Added methods Get_Configured_Line_Type_Db and Validate_Mandatory_Prices.
--  090930  MaMalk   Modified Copy_Pricing__ to remove unused code.
--  ------------------------- 14.0.0 -------------------------------------------
--  080515  SuJalk   Bug 70772, Added parameter info_ to methods Copy_Pricing__, Transfer_Pricing__ and changed the calls to those methods to pass the parameter.
--  080515           Also changed the Complete_Pricing method to remove the check_mandatory_ parameter and re-order the parameters. Also removed the check_mandatory_ 
--  080515           from IF condition within the Complete_Pricing method before the dynamic call. Removed method Complete_Pricing_Web.
--  070806  JaBalk   Changed the reference of Identity_ variable from 
--  070806           CONFIGURED_LINE_PRICE_TAB to CUST_ORD_CUSTOMER_PUB in Get_Identity function.
--  060419  IsWilk   Enlarge Customer - Changed variable definitions and view comments.
--  ------------------------- 13.4.0 -------------------------------------------
--  060220  UsRalk   Added new method Transfer_Pricing__.
--  060124  NiDalk   Added Assert safe annotation.
--  060117  SuJalk   Changed the "SELECT into ...." statment in Procedure Insert___ to "RETURNING &OBJID INTO objid".
--  050930  IsAnlk   Added public method Get_Identity.
--  050627  DaZase   Added info_ to Complete_Pricing.
--  050613  RaSilk   Added parameter update_price_ to method Update_Parent_Config_Id. Added method Price_Changed.
--  040426  MaMalk   Bug 37374, Added Modify_Config_Line_Price and Get_Price_Currency.
--  040304  IsWilk   Rewrote the DBMS_SQL to Native dynamic SQL for Unicode modification.
--  040218  IsWilk   Removed SUBSTRB from the view for Unicode Changes.
--  ----------------------------------------13.3.0------------------------------
--  040127  GeKalk   Rewrote the DBMS_SQL to Native dynamic SQL for UNICODE modifications.
--  030729  UdGnlk   Performed SP4 Merge.
--  030320  DhAalk   Bug 36330, Modified the FUNCTION Get.
--  021211  Asawlk   Merged bug fixes in 2002-3 SP3
--  021121  SaRalk   Bug 34279, Changed call to method Config_Char_Price_API.Get_New_Pricing_Info.
--  020815  GaSolk   Bug 29964, Added the calling method Config_Char_Price_API.Get_New_Pricing_Info
--  020815           in the Proc: Copy_Pricing__.
--  010528  JSAnse   Bug fix 21463, Added call to General_SYS.Init_Method for procedures Get_Price, Get_Calc_Price,
--                   Has_Pricing_Lines, Get_Parent_Configuration_Id, Complete_Pricing_Web and Update_Prices_For_Date.
--                   Removed 'TRUE' as last parameter in the mention call in Copy_Pricing___, Copy_Pricing__, Copy_Pricing,
--                   Remove_Pricing, Duplicate, New_Quote_Line_Price, New_Order_Line_Price, New_Unsaved_Order_Line_Price,
--                   Update_Parent_Config_Id and Complete_Pricing.
--  010412  JaBa     Bug Fix 20598,Added new global lu constants and used those in necessary places.
--  010319  LeIsse   Bug fix 20772, Corrected bug in Copy_Pricing__. New records for pricing are based on
--                   new_configuration_id instead of on old_configuration_id_ in Get_Config_Values.
--  001219  JakH     Added Complete_Pricing_Web
--  001211  JakH     Added check for mandatory price in Complete_Pricing.
--  001205  JoAn     CID 56719 Corrected dynamic SQL in Copy_Pricing__
--  001122  JakH     Added Get_Price_Effectivity_Date and Update_Prices_For_Date
--  001121  JakH     Added update of parent when price is copied between two
--                   Configured_line_price_id's
--  001110  JakH     Added Update_Parent_Config_Id made Copy and remove methods public
--  001103  JakH     Made the copy_pricing between pricing_id's private instead of
--                   implementational, in order to support copying of pricing info
--                   when a configuration is copied from another order/quote.
--  001017  JakH     Added condition for copy prices.
--  001010  JakH     Some corrections. Transparent get-methods.
--  001002  JakH     Create
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Get_Con_Configuration___
--   Fetches configuration of attached COL/OQL.
PROCEDURE Get_Con_Configuration___ (
   configuration_id_         OUT VARCHAR2,
   part_no_                  OUT VARCHAR2,
   configured_line_price_id_ IN  NUMBER )
IS
   CURSOR get_connected_line IS
      SELECT configured_line_type, identity_no, line_no, rel_no, line_item_no
      FROM CONFIGURED_LINE_PRICE_TAB
      WHERE configured_line_price_id = configured_line_price_id_;
   conrec_       get_connected_line%ROWTYPE;
   colinerec_    Customer_Order_Line_API.Public_Rec;
   quotelinerec_ Order_Quotation_Line_API.Public_Rec;
BEGIN
   OPEN get_connected_line;
   FETCH get_connected_line INTO conrec_;
   CLOSE get_connected_line;
  
   Trace_Sys.Message('Here is ');
   IF conrec_.line_item_no IS NULL THEN
      Trace_Sys.Field ('No reference to '|| conrec_.configured_line_type || ' for configured line',
                       configured_line_price_id_);
   ELSIF conrec_.configured_line_type = Configured_Line_Type_API.DB_CUSTOMER_ORDER_LINE THEN
      Trace_Sys.Message('order');
      colinerec_ := Customer_Order_Line_API.Get( conrec_.identity_no, conrec_.line_no, conrec_.rel_no, conrec_.line_item_no );
      configuration_id_  := colinerec_.configuration_id ;
      part_no_           := colinerec_.part_no ;
   ELSIF conrec_.configured_line_type = Configured_Line_Type_API.DB_SALES_QUOTATION_LINE THEN
      Trace_Sys.Message('quote');
      quotelinerec_ := Order_Quotation_Line_API.Get( conrec_.identity_no, conrec_.line_no, conrec_.rel_no, conrec_.line_item_no );
      configuration_id_  := quotelinerec_.configuration_id ;      
      part_no_           := quotelinerec_.part_no ;
   ELSIF conrec_.configured_line_type = Configured_Line_Type_API.DB_BUSINESS_OPPORTUNITY_LINE THEN      
      Trace_Sys.Message('opportunity');
      $IF Component_Crm_SYS.INSTALLED $THEN
         configuration_id_  := Business_Opportunity_Line_API.Get_Configuration_Id(conrec_.identity_no, conrec_.rel_no, conrec_.line_no );         
         part_no_           := Sales_Part_API.Get_Part_No(Business_Opportunity_Line_API.Get_Contract(conrec_.identity_no, conrec_.rel_no, conrec_.line_no), Business_Opportunity_Line_API.Get_Catalog_No(conrec_.identity_no, conrec_.rel_no, conrec_.line_no));
      $ELSE
         NULL;
      $END
   ELSE
      Error_SYS.Record_General(lu_name_, 'CONFLINETYPERR: The type of the configured line is not recognized.');
   END IF;
END Get_Con_Configuration___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT CONFIGURED_LINE_PRICE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   CURSOR get_next_seq IS
     SELECT Configured_Line_Price_Seq.nextval
       FROM DUAL;
BEGIN
   -- Fetch next ConfiguredLInePriceId from sequence.
   OPEN  get_next_seq ;
   FETCH get_next_seq INTO newrec_.configured_line_price_id;
   CLOSE get_next_seq;
   Client_SYS.Add_To_Attr('CONFIGURED_LINE_PRICE_ID',newrec_.configured_line_price_id, attr_);
   
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT configured_line_price_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   newrec_.contract := Client_SYS.Get_Item_Value('CONTRACT', attr_);

   super(newrec_, indrec_, attr_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;

PROCEDURE Set_Config_Price_Combo_Rec___ (
   eval_rec_                     OUT Characteristic_Base_Price_API.config_price_comb_rec,
   configuration_id_             IN VARCHAR2)
IS   
$IF (Component_Cfgchr_SYS.INSTALLED) $THEN
   CURSOR get_old_lines IS
      SELECT characteristic_id, config_spec_value_id, qty_characteristic
        FROM config_spec_value_tab
       WHERE configuration_id = configuration_id_;
$END    
      num_      NUMBER := 0;
BEGIN
   $IF (Component_Cfgchr_SYS.INSTALLED) $THEN  
      FOR rec_ IN get_old_lines LOOP   
         num_ := num_ + 1;
         eval_rec_.char_id_(num_)    :=  rec_.characteristic_id;
         eval_rec_.char_value_(num_) :=  rec_.config_spec_value_id;
         eval_rec_.char_qty_(num_)   :=  rec_.qty_characteristic; 
      END LOOP;
   $END
   
   eval_rec_.num_chars_        :=  num_;
END Set_Config_Price_Combo_Rec___;
-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Copy_Pricing__
--   Loops over the config spec values of a configuration and copies the price
--   lines for these to the ConfiguredLinePriceId. Assumes that the  configuration
--   is already moved. Copies the pricing lines from one COL/OQL to another.
--   To be called from the quotation handler when a quote is creating an order.
--   No checks on validity of configurations etc.
--   Also called when a configuration is copied from another order to be linked
--   on the order lne/quote line.
--   Loops over the config spec values of a configuration and copies the price
--   lines for these to the ConfiguredLinePriceId. Assumes that the configuration
--   is already moved. Copies the pricing lines from one COL/OQL to another.
--   To be called from the quotation handler when a quote is creating an order.
--   No checks on validity of configurations etc.
--   Also called when a configuration is copied from another order to be linked
--   on the order lne/quote line.
PROCEDURE Copy_Pricing__ (
   info_                         OUT VARCHAR2,
   old_configured_line_price_id_ IN NUMBER,
   new_configured_line_price_id_ IN NUMBER )
IS
BEGIN
   Transfer_Pricing__(info_, old_configured_line_price_id_, new_configured_line_price_id_, TRUE);
END Copy_Pricing__;


-- Copy_Pricing__
--   Loops over the config spec values of a configuration and copies the price
--   lines for these to the ConfiguredLinePriceId. Assumes that the  configuration
--   is already moved. Copies the pricing lines from one COL/OQL to another.
--   To be called from the quotation handler when a quote is creating an order.
--   No checks on validity of configurations etc.
--   Also called when a configuration is copied from another order to be linked
--   on the order lne/quote line.
--   Loops over the config spec values of a configuration and copies the price
--   lines for these to the ConfiguredLinePriceId. Assumes that the configuration
--   is already moved. Copies the pricing lines from one COL/OQL to another.
--   To be called from the quotation handler when a quote is creating an order.
--   No checks on validity of configurations etc.
--   Also called when a configuration is copied from another order to be linked
--   on the order lne/quote line.
PROCEDURE Copy_Pricing__ (
   configured_line_price_id_ IN     NUMBER,
   new_configuration_id_     IN     VARCHAR2 )
IS
   --- assume config values are already copied.
   --- so for all config values at the config copy them
   --- to the new config-usage combination

   rec_           CONFIGURED_LINE_PRICE_TAB%ROWTYPE;
   part_no_       VARCHAR2(25);   
   
   $IF (Component_Cfgchr_SYS.INSTALLED) $THEN
      CURSOR Get_Config_Values (configuration_id_ IN VARCHAR2, part_no_ IN VARCHAR2)IS
      SELECT spec_revision_no, characteristic_id, config_spec_value_id
      FROM   CONFIG_SPEC_VALUE_TAB
      WHERE  Configuration_Id = Configuration_Id_
      AND    Part_No = Part_No_;
   $END
BEGIN
   -- dig out the part no to use
   rec_ := Get_Config_Line_Connected_Info(configured_line_price_id_);
   part_no_ := Nvl(Sales_Part_API.Get_Part_No(rec_.contract, rec_.catalog_no), rec_.catalog_no);
   $IF (Component_Cfgchr_SYS.INSTALLED) $THEN     
      FOR Config_Values_ IN Get_Config_Values( new_configuration_id_, part_no_ ) LOOP
         Config_Char_Price_API.Copy_Pricing_Util__
            ( configured_line_price_id_, part_no_ ,
              new_configuration_id_ , config_values_.spec_revision_no ,
              config_values_.characteristic_id , config_values_.config_spec_value_id);
      END LOOP;        
   $END
END Copy_Pricing__;


-- Transfer_Pricing__
--   Transfers pricing information from one configuration line price id to
--   another and optionally do repricing.
PROCEDURE Transfer_Pricing__ (
   info_                         OUT VARCHAR2,
   old_configured_line_price_id_ IN NUMBER,
   new_configured_line_price_id_ IN NUMBER,
   recalculate_prices_           IN BOOLEAN )
IS
   CURSOR get_old_lines IS
      SELECT *
        FROM CONFIG_CHAR_PRICE_TAB
       WHERE configured_line_price_id = old_configured_line_price_id_;
   attr_             VARCHAR2(2000);
   configuration_id_ VARCHAR2(50) := '*';
   do_no_change_     BOOLEAN := FALSE;
   eval_rec_   Characteristic_Base_Price_API.config_price_comb_rec; 
    
BEGIN
   configuration_id_ :=  Get_Parent_Configuration_Id(old_configured_line_price_id_);

   Set_Config_Price_Combo_Rec___(eval_rec_,  configuration_id_);
   FOR line_rec_ IN get_old_lines LOOP
      -- IF a Config_Char_Price object already exists, do not proceed.
      IF Config_Char_Price_API.Get_Exist(new_configured_line_price_id_, 
                                         line_rec_.part_no, 
                                         configuration_id_,
                                         line_rec_.spec_revision_no,
                                         line_rec_.characteristic_id,
                                         line_rec_.config_spec_value_id) = 'TRUE'  THEN
         do_no_change_ := TRUE;
         EXIT;
      END IF;
      line_rec_.configured_line_price_id := new_configured_line_price_id_ ;
      line_rec_.rowkey := NULL;
      IF ( recalculate_prices_ ) THEN
         Config_Char_Price_API.Get_New_Pricing_Info__(line_rec_, eval_rec_ => eval_rec_);
      END IF;
      Client_Sys.Clear_Attr(attr_);
      Config_Char_Price_API.Insert__(line_rec_, attr_);
      configuration_id_ := line_rec_.configuration_id;
   END LOOP;

   
   -- IF we skipped the copy pricing, then no need to do anything.
   IF NOT do_no_change_ THEN
      IF ( configuration_id_ !='*' ) THEN
         Update_Parent_Config_Id(new_configured_line_price_id_, configuration_id_, 'TRUE');
      ELSE
         Trace_SYS.Field('Configuration copied on a non stored order line', '*');
      END IF;
   
      info_ := Client_Sys.Get_All_Info;
   END IF;
END Transfer_Pricing__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Part_Price (
   configured_line_price_id_ IN NUMBER ) RETURN NUMBER
IS
   CURSOR get_attr IS
      SELECT configured_line_type, identity_no, line_no, rel_no, line_item_no,
             part_price
      FROM   CONFIGURED_LINE_PRICE_TAB
      WHERE  configured_line_price_id = configured_line_price_id_;
   temp_ get_attr%ROWTYPE;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   IF temp_.line_item_no IS NULL THEN
      RETURN temp_.part_price;
   ELSIF temp_.configured_line_type = Configured_Line_Type_API.DB_CUSTOMER_ORDER_LINE THEN
      RETURN Customer_Order_Line_API.Get_Part_Price(temp_.identity_no, temp_.line_no, temp_.rel_no, temp_.line_item_no);
   ELSIF temp_.configured_line_type = Configured_Line_Type_API.DB_SALES_QUOTATION_LINE THEN
      RETURN Order_Quotation_Line_API.Get_Part_Price(temp_.identity_no, temp_.line_no, temp_.rel_no, temp_.line_item_no);
   ELSIF temp_.configured_line_type = Configured_Line_Type_API.DB_BUSINESS_OPPORTUNITY_LINE THEN
      $IF Component_Crm_SYS.INSTALLED $THEN
         RETURN Business_Opportunity_Line_API.Get_Part_Price(temp_.identity_no, temp_.rel_no, temp_.line_no);
      $ELSE
         RETURN NULL;
      $END
   END IF;
   RETURN NULL;
END Get_Part_Price;


@UncheckedAccess
FUNCTION Get_Contract (
   configured_line_price_id_ IN NUMBER ) RETURN VARCHAR2
IS
   CURSOR get_attr IS
      SELECT configured_line_type, identity_no, line_no, rel_no, line_item_no,
             contract
      FROM   CONFIGURED_LINE_PRICE_TAB
      WHERE  configured_line_price_id = configured_line_price_id_;
   temp_ get_attr%ROWTYPE;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   IF temp_.line_item_no IS NULL THEN
      RETURN temp_.contract;
   ELSIF temp_.configured_line_type = Configured_Line_Type_API.DB_CUSTOMER_ORDER_LINE THEN
      RETURN Customer_Order_Line_API.Get_Contract(temp_.identity_no, temp_.line_no, temp_.rel_no, temp_.line_item_no);
   ELSIF temp_.configured_line_type = Configured_Line_Type_API.DB_SALES_QUOTATION_LINE THEN
      RETURN Order_Quotation_Line_API.Get_Contract(temp_.identity_no, temp_.line_no, temp_.rel_no, temp_.line_item_no);
   ELSIF temp_.configured_line_type = Configured_Line_Type_API.DB_BUSINESS_OPPORTUNITY_LINE THEN
      $IF Component_Crm_SYS.INSTALLED $THEN
         RETURN Business_Opportunity_Line_API.Get_Contract(temp_.identity_no, temp_.rel_no, temp_.line_no);
      $ELSE
         RETURN NULL;
      $END
   END IF;
   RETURN NULL;
END Get_Contract;


@UncheckedAccess
FUNCTION Get_Catalog_No (
   configured_line_price_id_ IN NUMBER ) RETURN VARCHAR2
IS
   CURSOR get_attr IS
      SELECT configured_line_type, identity_no, line_no, rel_no, line_item_no,
             catalog_no
      FROM CONFIGURED_LINE_PRICE_TAB
      WHERE configured_line_price_id = configured_line_price_id_;
   temp_ get_attr%ROWTYPE;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   IF temp_.line_item_no IS NULL THEN
      RETURN temp_.catalog_no;
   ELSIF temp_.configured_line_type = Configured_Line_Type_API.DB_CUSTOMER_ORDER_LINE THEN
      RETURN Customer_Order_Line_API.Get_Catalog_No(temp_.identity_no, temp_.line_no, temp_.rel_no, temp_.line_item_no);
   ELSIF temp_.configured_line_type = Configured_Line_Type_API.DB_SALES_QUOTATION_LINE THEN
      RETURN Order_Quotation_Line_API.Get_Catalog_No(temp_.identity_no, temp_.line_no, temp_.rel_no, temp_.line_item_no);
   ELSIF temp_.configured_line_type = Configured_Line_Type_API.DB_BUSINESS_OPPORTUNITY_LINE THEN
      $IF Component_Crm_SYS.INSTALLED $THEN
         RETURN Business_Opportunity_Line_API.Get_Catalog_No(temp_.identity_no, temp_.rel_no, temp_.line_no);
      $ELSE
         RETURN NULL;
      $END
   END IF;
   RETURN NULL;
END Get_Catalog_No;


@UncheckedAccess
FUNCTION Get_Currency_Code (
   configured_line_price_id_ IN NUMBER ) RETURN VARCHAR2
IS
   CURSOR get_attr IS
      SELECT configured_line_type, identity_no, line_item_no,
             currency_code
      FROM CONFIGURED_LINE_PRICE_TAB
      WHERE configured_line_price_id = configured_line_price_id_;
   temp_ get_attr%ROWTYPE;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   IF temp_.line_item_no IS NULL THEN
      RETURN temp_.currency_code;
   ELSIF temp_.configured_line_type = Configured_Line_Type_API.DB_CUSTOMER_ORDER_LINE THEN
      RETURN Customer_Order_API.Get_Currency_Code(temp_.identity_no);
   ELSIF temp_.configured_line_type = Configured_Line_Type_API.DB_SALES_QUOTATION_LINE THEN
      RETURN Order_Quotation_API.Get_Currency_Code(temp_.identity_no);
   ELSIF temp_.configured_line_type = Configured_Line_Type_API.DB_BUSINESS_OPPORTUNITY_LINE THEN
      $IF Component_Crm_SYS.INSTALLED $THEN
         RETURN Business_Opportunity_API.Get_Currency_Code(temp_.identity_no);
      $ELSE
         RETURN NULL;
      $END
   END IF;
   RETURN NULL;
END Get_Currency_Code;


@UncheckedAccess
FUNCTION Get_Price_List_No (
   configured_line_price_id_ IN NUMBER ) RETURN VARCHAR2
IS
   CURSOR get_attr IS
      SELECT configured_line_type, identity_no, line_no, rel_no, line_item_no,
             price_list_no
      FROM   CONFIGURED_LINE_PRICE_TAB
      WHERE configured_line_price_id = configured_line_price_id_;
   temp_ get_attr%ROWTYPE;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   IF temp_.line_item_no IS NULL THEN
      RETURN temp_.price_list_no;
   ELSIF temp_.configured_line_type = Configured_Line_Type_API.DB_CUSTOMER_ORDER_LINE THEN
      RETURN Customer_Order_Line_API.Get_Price_List_No(temp_.identity_no, temp_.line_no, temp_.rel_no, temp_.line_item_no);
   ELSIF temp_.configured_line_type = Configured_Line_Type_API.DB_SALES_QUOTATION_LINE THEN
      RETURN Order_Quotation_Line_API.Get_Price_List_No(temp_.identity_no, temp_.line_no, temp_.rel_no, temp_.line_item_no);
   ELSIF temp_.configured_line_type = Configured_Line_Type_API.DB_BUSINESS_OPPORTUNITY_LINE THEN
      $IF Component_Crm_SYS.INSTALLED $THEN
         RETURN Business_Opportunity_Line_API.Get_Price_List_No(temp_.identity_no, temp_.rel_no, temp_.line_no);
      $ELSE
         RETURN NULL;
      $END
   END IF;
   RETURN NULL;
END Get_Price_List_No;


-- Create_Pricing
--   Procedure for creating  all ConfigCharPriceLines for a certain ConfiguredLInePrice.
--   Call this with a newly created ConfiguredLinePriceId.
PROCEDURE Create_Pricing (
   configured_line_price_id_ IN NUMBER )
IS
   -- Dynamic call
   stmt_                   VARCHAR2(32000);
   TYPE RecordType         IS REF CURSOR;
   get_config_data_        RecordType;

   -- attributes for the ConfigCharPrices
   configuration_id_       CONFIG_CHAR_PRICE_TAB.configuration_id%TYPE;
   part_no_                CONFIG_CHAR_PRICE_TAB.part_no%TYPE;
   spec_revision_no_       CONFIG_CHAR_PRICE_TAB.spec_revision_no%TYPE;
   config_spec_value_id_   CONFIG_CHAR_PRICE_TAB.config_spec_value_id%TYPE;
   characteristic_id_      CONFIG_CHAR_PRICE_TAB.characteristic_id%TYPE;

   attr_    VARCHAR2(2000);
BEGIN
   
   $IF (NOT Component_Cfgchr_SYS.INSTALLED) $THEN   
      Error_SYS.Record_General(lu_name_, 'CFGNOTINST: The handling of configurations is not installed.');
   $END

   -- Get Configuration id
   Get_Con_Configuration___(configuration_id_,part_no_, configured_line_price_id_);
   
   IF Configuration_Id_ != '*' THEN

      Trace_Sys.Field('configuration_id_',configuration_id_);
      Trace_Sys.Field('part_no_',part_no_);

      -- Loop over all characteristic of this configuration
      stmt_ := 'SELECT spec_revision_no, config_spec_value_id, characteristic_id '||
                  'FROM  CONFIG_SPEC_VALUE_TAB ' ||
                  'WHERE configuration_id = :configuration_id ' ||
                  'AND   part_no = :part_no' ;


      @ApproveDynamicStatement(2006-01-24,nidalk)
      OPEN get_config_data_ FOR stmt_ USING configuration_id_, part_no_;
      LOOP
         FETCH get_config_data_ INTO spec_revision_no_, config_spec_value_id_, characteristic_id_ ;
         EXIT WHEN get_config_data_%NOTFOUND;

         Client_SYS.Clear_Attr(attr_);         
         Config_Char_Price_API.New( configured_line_price_id_, part_no_, configuration_id_, spec_revision_no_,
                                    characteristic_id_, config_spec_value_id_, attr_ );
      END LOOP;
      
     
   ELSE
      Trace_SYS.Field('No configuration for configured line price id', configured_line_price_id_);
      Trace_SYS.Field('Part', part_no_);
   END IF;
END Create_Pricing;


-- Copy_Pricing
--   Loops over the pricing lines and just makes copies.
--   Done for the case when the other configuration is already zapped
PROCEDURE Copy_Pricing (
   configured_line_price_id_ IN NUMBER,
   old_configuration_id_     IN VARCHAR2,
   new_configuration_id_     IN VARCHAR2 )
IS
   --- assume that price lines exists for all characteritic values
   --- just do a simple copy of the price lines

   CURSOR Get_Price_Lines IS
      SELECT *
      FROM CONFIG_CHAR_PRICE_TAB
      WHERE configuration_id = old_configuration_id_
      AND   configured_line_price_id = configured_line_price_id_ ;

   attr_ VARCHAR2(2000);

BEGIN
   Trace_Sys.Field('from '||old_configuration_id_||' to '||new_configuration_id_||' for price id', configured_line_price_id_);

   FOR rec_ IN Get_Price_Lines LOOP
      rec_.configuration_id := new_configuration_id_;
      Client_Sys.Clear_Attr(attr_);
      IF (Config_Char_Price_API.Get_Exist(rec_.configured_line_price_id, rec_.part_no, rec_.configuration_id, rec_.spec_revision_no, rec_.characteristic_id, rec_.config_spec_value_id) = 'FALSE') THEN
         Config_Char_Price_API.Insert__(rec_, attr_);
      END IF;
   END LOOP;
END Copy_Pricing;

PROCEDURE Copy_Manual_Pricing (
   configured_line_price_id_ IN NUMBER,
   old_configuration_id_     IN VARCHAR2,
   new_configuration_id_     IN VARCHAR2 )
IS
   $IF (Component_Cfgchr_SYS.INSTALLED) $THEN
   CURSOR Get_Price_Lines IS
      SELECT *
      FROM CONFIG_CHAR_PRICE_TAB
      WHERE configuration_id = old_configuration_id_
      AND   configured_line_price_id = configured_line_price_id_
      AND Configuration_Spec_API.Get_Value_For_Characteristic(part_no, new_configuration_id_, characteristic_id) = Configuration_Spec_API.Get_Value_For_Characteristic(part_no, old_configuration_id_, characteristic_id)
      AND characteristic_price IS NOT NULL;
    
   attr_ VARCHAR2(2000);
   $END

BEGIN
   $IF (Component_Cfgchr_SYS.INSTALLED) $THEN
   FOR rec_ IN Get_Price_Lines LOOP
      Trace_Sys.Field('Copy price from '||old_configuration_id_||' to '||new_configuration_id_||' for price id', configured_line_price_id_   );
      rec_.configuration_id := new_configuration_id_;
      Client_Sys.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('CHARACTERISTIC_PRICE', rec_.characteristic_price, attr_);
      IF (Config_Char_Price_API.Get_Exist(rec_.configured_line_price_id, rec_.part_no, rec_.configuration_id, rec_.spec_revision_no, rec_.characteristic_id, rec_.config_spec_value_id) = 'FALSE') THEN
         Config_Char_Price_API.Insert__(rec_, attr_);
      ELSE
         Config_Char_Price_API.Modify(rec_.configured_line_price_id, rec_.part_no, rec_.configuration_id, rec_.spec_revision_no, rec_.characteristic_id, rec_.config_spec_value_id, attr_);
      END IF;
   END LOOP;
   $ELSE
      NULL;
   $END
END Copy_Manual_Pricing;

PROCEDURE Zero_Mandatory_Pricing (
   num_updated_              OUT NUMBER,
   configured_line_price_id_ IN NUMBER,
   configuration_id_         IN VARCHAR2 )
IS
   $IF (Component_Cfgchr_SYS.INSTALLED) $THEN 
   CURSOR Get_Price_Lines IS
      SELECT *
      FROM CONFIG_CHAR_PRICE_TAB
      WHERE configuration_id = configuration_id_
      AND   configured_line_price_id = configured_line_price_id_
      AND Base_Part_Characteristic_API.Get_Mandatory_Price_Db(part_no, spec_revision_no, characteristic_id) = 'YES' 
      AND characteristic_price IS NULL;
   $END

   attr_ VARCHAR2(2000);
   num_  NUMBER := 0;

BEGIN
   $IF (Component_Cfgchr_SYS.INSTALLED) $THEN
   FOR rec_ IN Get_Price_Lines LOOP
      Client_Sys.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('CHARACTERISTIC_PRICE', 0, attr_);
      Config_Char_Price_API.Modify(rec_.configured_line_price_id, rec_.part_no, rec_.configuration_id, rec_.spec_revision_no, rec_.characteristic_id, rec_.config_spec_value_id, attr_);
      num_ := num_ + 1;
   END LOOP;
   $END

   num_updated_ := num_;
END Zero_Mandatory_Pricing;


-- JICE TEST END

-- Get_Price
--   Sums the characteristic price of the lines for the selected
FUNCTION Get_Price (
   configured_line_price_id_ IN NUMBER ) RETURN NUMBER
IS
   CURSOR Get_Sum_Price( configured_line_price_id_ IN NUMBER ) IS
      SELECT SUM(NVL(characteristic_price,0))
      FROM CONFIG_CHAR_PRICE_TAB
      WHERE configured_line_price_id = configured_line_price_id_;
   sum_  NUMBER;
BEGIN
   OPEN Get_Sum_Price( configured_line_price_id_ );
   FETCH Get_Sum_Price INTO sum_;
   CLOSE Get_Sum_Price;
   RETURN sum_;
END Get_Price;


-- Get_Calc_Price
--   Sums the calculated value of the lines for the selected
FUNCTION Get_Calc_Price (
   configured_line_price_id_ IN NUMBER ) RETURN NUMBER
IS
   CURSOR Get_Calc_Sum_Price( configured_line_price_id_ IN NUMBER ) IS
      SELECT SUM(NVL(calc_char_price,0))
      FROM CONFIG_CHAR_PRICE_TAB
      WHERE configured_line_price_id = configured_line_price_id_;
   sum_  NUMBER;
BEGIN
   OPEN Get_Calc_Sum_Price( configured_line_price_id_ );
   FETCH Get_Calc_Sum_Price INTO sum_;
   CLOSE Get_Calc_Sum_Price;
   RETURN sum_;
END Get_Calc_Price;


-- Get_Pricing_Totals
--   Fetches the sums of the calculated characteristic prices and
--   the possibly modified characteristic prices.
PROCEDURE Get_Pricing_Totals (
   characteristic_price_sum_ OUT NUMBER,
   calc_char_price_sum_      OUT NUMBER,
   configured_line_price_id_ IN  NUMBER,
   configuration_id_         IN  VARCHAR2 )
IS
   CURSOR get_price_sums( configured_line_price_id_ IN NUMBER, configuration_id_ IN VARCHAR2) IS
      SELECT SUM(NVL(characteristic_price, 0)) characteristic_price_sum,
             SUM(NVL(calc_char_price, 0))      calc_char_price_sum
      FROM   CONFIG_CHAR_PRICE_TAB
      WHERE  configuration_id = configuration_id_
      AND    configured_line_price_id = configured_line_price_id_;
   sums_   get_price_sums%ROWTYPE;
BEGIN
   OPEN get_price_sums( configured_line_price_id_, configuration_id_ );
   FETCH get_price_sums INTO sums_;
   CLOSE get_price_sums;
   characteristic_price_sum_ := sums_.characteristic_price_sum;
   calc_char_price_sum_ := sums_.calc_char_price_sum;
END Get_Pricing_Totals;


-- Modify
--   Public method for modifying object.
PROCEDURE Modify (
   configured_line_price_id_ IN     NUMBER,
   attr_                     IN OUT VARCHAR2 )
IS
   oldrec_  CONFIGURED_LINE_PRICE_TAB%ROWTYPE;
   newrec_  CONFIGURED_LINE_PRICE_TAB%ROWTYPE;
   objid_   CONFIGURED_LINE_PRICE.objid%TYPE;
   objver_  CONFIGURED_LINE_PRICE.objversion%TYPE;
   indrec_  Indicator_Rec;
BEGIN
   oldrec_ := Lock_By_Keys___( configured_line_price_id_ );
   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___( objid_, oldrec_, newrec_, attr_, objver_, TRUE );
END Modify;


-- Remove
--   Public method for removing object.
PROCEDURE Remove (
   configured_line_price_id_ IN NUMBER )
IS
   remrec_        CONFIGURED_LINE_PRICE_TAB%ROWTYPE;
   objid_         CONFIGURED_LINE_PRICE.objid%TYPE;
   objversion_    CONFIGURED_LINE_PRICE.objversion%TYPE;
BEGIN
   Get_Id_Version_By_Keys___ ( objid_, objversion_, configured_line_price_id_);
   remrec_ := Lock_By_Keys___( configured_line_price_id_ );
   Check_Delete___(remrec_);
   Delete___(objid_, remrec_);
END Remove;


-- Remove_Pricing
--   Removes the prices for a certain ConfiguredLinePriceId  and
--   configuration ID
PROCEDURE Remove_Pricing (
   configured_line_price_id_ IN NUMBER,
   old_configuration_id_     IN VARCHAR2 )
IS
   CURSOR getrec IS
      SELECT part_no, configuration_id, spec_revision_no,
             characteristic_id, config_spec_value_id
      FROM   CONFIG_CHAR_PRICE_TAB
      WHERE  configuration_id = old_configuration_id_
      AND    configured_line_price_id = configured_line_price_id_;
BEGIN
   Trace_Sys.Field('old cfg '||old_configuration_id_||' from price id' ,configured_line_price_id_);
   IF old_configuration_id_ IS NOT NULL THEN
      FOR rec_ IN getrec LOOP
         Config_Char_Price_API.Remove (configured_line_price_id_,
                                       rec_.part_no, old_configuration_id_, rec_.spec_revision_no,
                                       rec_.characteristic_id, rec_.config_spec_value_id );
      END LOOP;
   END IF;
END Remove_Pricing;


-- Duplicate
--   Creates a new ConfiguredLinePrice and copies old data to the new place.
FUNCTION Duplicate (
   configured_line_price_id_ IN NUMBER ) RETURN NUMBER
IS
   attr_          VARCHAR2(2000);
   newrec_        CONFIGURED_LINE_PRICE_TAB%ROWTYPE;
   oldrec_        CONFIGURED_LINE_PRICE_TAB%ROWTYPE;
   objid_         CONFIGURED_LINE_PRICE.objid%TYPE;
   objversion_    CONFIGURED_LINE_PRICE.objversion%TYPE;
   dummy_info_    VARCHAR2(32000);
BEGIN
   oldrec_ := Get_Object_By_Keys___(configured_line_price_id_);
   newrec_ := oldrec_;
   newrec_.rowkey := NULL;
   Client_SYS.Clear_Attr(attr_);
   Insert___(objid_, objversion_, newrec_, attr_);
   Copy_Pricing__(dummy_info_, oldrec_.configured_line_price_id,newrec_.configured_line_price_id);
   RETURN newrec_.configured_line_price_id;
END Duplicate;


-- New_Quote_Line_Price
--   Called to create a new head. This is to be used when OrderQuotationLines
--   create a head for the pricing. Assumes that the configuration does not
--   yet exist.
FUNCTION New_Quote_Line_Price (
   quotation_no_ IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN NUMBER
IS
   newrec_     CONFIGURED_LINE_PRICE_TAB%ROWTYPE;
   attr_       VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN
   -- since we do have a good back link don't care about fetching attributes
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('CONFIGURED_LINE_TYPE_DB', Configured_Line_Type_API.DB_SALES_QUOTATION_LINE, attr_);
   Client_SYS.Add_To_Attr('IDENTITY_NO', quotation_no_, attr_);
   Client_SYS.Add_To_Attr('LINE_NO', line_no_, attr_);
   Client_SYS.Add_To_Attr('REL_NO', rel_no_, attr_);
   Client_SYS.Add_To_Attr('LINE_ITEM_NO', line_item_no_, attr_);

   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);
   RETURN newrec_.configured_line_price_id;
END New_Quote_Line_Price;


-- New_Order_Line_Price
--   Called to create a new head. This is to be used when CustomerOrderLines
--   create a head for the pricing.
--   Assumes the order line was saved.
--   Assumes that the configuration does not yet exist.
FUNCTION New_Order_Line_Price (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN NUMBER
IS
   newrec_     CONFIGURED_LINE_PRICE_TAB%ROWTYPE;
   attr_       VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN
   -- since we do have a good back link don't care about fetching attributes
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('CONFIGURED_LINE_TYPE_DB', Configured_Line_Type_API.DB_CUSTOMER_ORDER_LINE, attr_);
   Client_SYS.Add_To_Attr('IDENTITY_NO', order_no_, attr_);
   Client_SYS.Add_To_Attr('LINE_NO', line_no_, attr_);
   Client_SYS.Add_To_Attr('REL_NO', rel_no_, attr_);
   Client_SYS.Add_To_Attr('LINE_ITEM_NO', line_item_no_, attr_);

   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);
   RETURN newrec_.configured_line_price_id;
END New_Order_Line_Price;


FUNCTION New_Bo_Line_Price (
   business_opportunity_no_   IN VARCHAR2,
   revision_no_               IN NUMBER,
   line_no_                   IN NUMBER   ) RETURN NUMBER   
IS
   newrec_     CONFIGURED_LINE_PRICE_TAB%ROWTYPE;
   attr_       VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN
   -- since we do have a good back link don't care about fetching attributes
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('CONFIGURED_LINE_TYPE_DB', Configured_Line_Type_API.DB_BUSINESS_OPPORTUNITY_LINE , attr_);
   Client_SYS.Add_To_Attr('IDENTITY_NO', business_opportunity_no_, attr_);
   Client_SYS.Add_To_Attr('LINE_NO', to_char(line_no_), attr_);
   Client_SYS.Add_To_Attr('REL_NO', to_char(revision_no_), attr_);   
   Client_SYS.Add_To_Attr('LINE_ITEM_NO', '0', attr_);
   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);
   RETURN newrec_.configured_line_price_id;
END New_Bo_Line_Price;


FUNCTION New_Test_Configuration_Price RETURN NUMBER
IS
   newrec_     CONFIGURED_LINE_PRICE_TAB%ROWTYPE;
   attr_       VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN
   
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('IDENTITY_NO', '*', attr_);
   Client_SYS.Add_To_Attr('CONFIGURED_LINE_TYPE_DB', 'TESTLINE', attr_);
   
   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   RETURN newrec_.configured_line_price_id;
END New_Test_Configuration_Price;


-- New_Unsaved_Order_Line_Price
--   Called to create a new head. This is to be used when CustomerOrderLines
--   create a head for the pricing.
--   Assumes the order line was NOT saved.
--   (The order line key does not yet exist, and we therefore have to save
--   pricing data on this object) When the order line is saved the backward
--   reference should be updated.
--   Assumes that the configuration does not yet exist.
FUNCTION New_Unsaved_Order_Line_Price (
   order_no_      IN VARCHAR2,
   contract_      IN VARCHAR2,
   currency_code_ IN VARCHAR2,
   catalog_no_    IN VARCHAR2,
   price_list_no_ IN VARCHAR2,
   part_price_    IN NUMBER ) RETURN NUMBER
IS
   newrec_     CONFIGURED_LINE_PRICE_TAB%ROWTYPE;
   indrec_     Indicator_Rec;
   attr_       VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN
   -- this is only called from the client.
   Client_SYS.Add_To_Attr('CONFIGURED_LINE_TYPE_DB', 'CUSTOMERORDER', attr_);
   -- Create a new ConfiguredLinePrice record
   Client_SYS.Add_To_Attr('IDENTITY_NO', order_no_, attr_);
   Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_ );
   Client_SYS.Add_To_Attr('CURRENCY_CODE', currency_code_, attr_ );
   Client_SYS.Add_To_Attr('CATALOG_NO', catalog_no_, attr_ );
   Client_SYS.Add_To_Attr('PRICE_LIST_NO', price_list_no_, attr_ );
   Client_SYS.Add_To_Attr('PART_PRICE', part_price_, attr_ );
   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);
   RETURN newrec_.configured_line_price_id;
END New_Unsaved_Order_Line_Price;


-- Has_Pricing_Lines
--   Returns 1 if there are ConfigCharPrice lines connected to this
FUNCTION Has_Pricing_Lines (
   configured_line_price_id_ IN NUMBER ) RETURN NUMBER
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   CONFIG_CHAR_PRICE_TAB
      WHERE configured_line_price_id = configured_line_price_id_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN 1;
   END IF;
   CLOSE exist_control;
   RETURN 0;
END Has_Pricing_Lines;


-- Has_Offset_Lines
--   Returns 1 if there are ConfigCharPrice lines with a char_price_offset != 0
FUNCTION Has_Price_Offset_Lines (
   configured_line_price_id_ IN NUMBER ) RETURN NUMBER
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   CONFIG_CHAR_PRICE_TAB
      WHERE configured_line_price_id = configured_line_price_id_
      AND Nvl(char_price_offset, 0) != 0;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN 1;
   END IF;
   CLOSE exist_control;
   RETURN 0;
END Has_Price_Offset_Lines;


-- Get_Catalog_Desc
--   Fetches the description for the catalog no. Either from order,
--   quote or sales part depending on type and if the order line exists or not.
@UncheckedAccess
FUNCTION Get_Catalog_Desc (
   configured_line_price_id_ IN NUMBER ) RETURN VARCHAR2
IS
   CURSOR get_attr IS
      SELECT configured_line_type, identity_no, line_no, rel_no, line_item_no,
             catalog_no, contract
      FROM CONFIGURED_LINE_PRICE_TAB
      WHERE configured_line_price_id = configured_line_price_id_;
   temp_ get_attr%ROWTYPE;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   IF temp_.line_item_no IS NULL THEN
      RETURN Sales_Part_API.Get_Catalog_Desc(temp_.contract, temp_.catalog_no);
   ELSIF temp_.configured_line_type = Configured_Line_Type_API.DB_CUSTOMER_ORDER_LINE THEN
      RETURN Customer_Order_Line_API.Get_Catalog_Desc(temp_.identity_no, temp_.line_no, temp_.rel_no, temp_.line_item_no);
   ELSIF temp_.configured_line_type = Configured_Line_Type_API.DB_SALES_QUOTATION_LINE THEN
      RETURN Order_Quotation_Line_API.Get_Catalog_Desc(temp_.identity_no, temp_.line_no, temp_.rel_no, temp_.line_item_no);
   END IF;
   RETURN NULL;
END Get_Catalog_Desc;


-- Update_Parent_Config_Id
--   Updates the parent with the new configuration id after the editing of
--   the configuration is done.
PROCEDURE Update_Parent_Config_Id (
   configured_line_price_id_ IN NUMBER,
   new_configuration_id_     IN VARCHAR2,
   update_price_             IN VARCHAR2 )
IS
   rec_              CONFIGURED_LINE_PRICE_TAB%ROWTYPE;
   attr_             VARCHAR2(2000);
   char_price_       NUMBER;
   calc_char_price_  NUMBER;
   info_             VARCHAR2(32000);
BEGIN
   Trace_SYS.Field ('Setting Configuration id at parent', new_configuration_id_);
   rec_ := Get_Object_By_Keys___(configured_line_price_id_);   
   IF (rec_.identity_no IS NOT NULL) AND (rec_.line_no IS NOT NULL) AND (rec_.rel_no IS NOT NULL) AND (rec_.line_item_no IS NOT NULL)
      THEN
      Configured_Line_Price_API.Get_Pricing_Totals ( char_price_, calc_char_price_,
      configured_line_price_id_, new_configuration_id_);
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('CONFIGURATION_ID', new_configuration_id_, attr_);
      IF (update_price_ = 'TRUE') THEN
         Client_SYS.Add_To_Attr('CHAR_PRICE',       char_price_ , attr_);
         Client_SYS.Add_To_Attr('CALC_CHAR_PRICE',  calc_char_price_, attr_);
      END IF;
      IF rec_.configured_line_type = Configured_Line_Type_API.DB_CUSTOMER_ORDER_LINE THEN
         Customer_Order_Line_API.Modify( attr_,  rec_.identity_no, rec_.line_no, rec_.rel_no, rec_.line_item_no);
      ELSIF rec_.configured_line_type = Configured_Line_Type_API.DB_SALES_QUOTATION_LINE THEN
         Order_Quotation_Line_API.Modify( attr_,  rec_.identity_no, rec_.line_no, rec_.rel_no, rec_.line_item_no);
      ELSIF rec_.configured_line_type = Configured_Line_Type_API.DB_BUSINESS_OPPORTUNITY_LINE THEN
         $IF Component_Crm_SYS.INSTALLED $THEN
            Client_SYS.Add_To_Attr('UPDATE_ALLOWED', 'TRUE', attr_);
            Business_Opportunity_Line_API.Modify(info_, attr_, rec_.identity_no, rec_.line_no);
         $ELSE
            NULL;
         $END
      END IF;
   END IF;
END Update_Parent_Config_Id;


-- Get_Parent_Configuration_Id
--   Fetches the configuration id of the parent.
FUNCTION Get_Parent_Configuration_Id (
   configured_line_price_id_ IN NUMBER ) RETURN VARCHAR2
IS
   rec_              CONFIGURED_LINE_PRICE_TAB%ROWTYPE;
BEGIN
   rec_ := Get_Object_By_Keys___(configured_line_price_id_);
   IF (rec_.identity_no IS NOT NULL) AND (rec_.line_no IS NOT NULL) AND (rec_.rel_no IS NOT NULL) AND (rec_.line_item_no IS NOT NULL)
   THEN
      IF rec_.configured_line_type = Configured_Line_Type_API.DB_CUSTOMER_ORDER_LINE THEN
         RETURN Customer_Order_Line_API.Get_Configuration_Id(rec_.identity_no, rec_.line_no, rec_.rel_no, rec_.line_item_no);
      ELSIF rec_.configured_line_type = Configured_Line_Type_API.DB_SALES_QUOTATION_LINE THEN
         RETURN Order_Quotation_Line_API.Get_Configuration_Id( rec_.identity_no, rec_.line_no, rec_.rel_no, rec_.line_item_no);
      ELSIF rec_.configured_line_type = Configured_Line_Type_API.DB_BUSINESS_OPPORTUNITY_LINE THEN
         $IF Component_Crm_SYS.INSTALLED $THEN
            RETURN Business_Opportunity_Line_API.Get_Configuration_Id(rec_.identity_no, rec_.rel_no, rec_.line_no);
         $ELSE
            RETURN '*';
         $END   
      END IF;
   END IF;
   RETURN '*';
END Get_Parent_Configuration_Id;

FUNCTION Check_Mandatory_Pricing(
   missing_price_char_       OUT VARCHAR2,
   configured_line_price_id_ IN NUMBER,
   configuration_id_         IN VARCHAR2 ) RETURN BOOLEAN
IS
   $IF (Component_Cfgchr_SYS.INSTALLED) $THEN
      CURSOR Get_Edited_Without_Price (configured_line_price_id_ IN NUMBER, configuration_id_ VARCHAR2) IS
         SELECT part_no, spec_revision_no, characteristic_id
         FROM CONFIG_CHAR_PRICE_TAB
         WHERE configuration_id = configuration_id_
         AND   configured_line_price_id = configured_line_price_id_
         AND   characteristic_price IS null;
   $END

   price_ok_   BOOLEAN := TRUE;
BEGIN
   $IF (Component_Cfgchr_SYS.INSTALLED) $THEN     
      FOR rec_ IN Get_Edited_Without_Price (configured_line_price_id_, configuration_id_) LOOP
         IF Base_Part_Characteristic_API.Get_Mandatory_Price_Db(rec_.part_no,rec_.spec_revision_no,rec_.characteristic_id) = 'YES' THEN
            missing_price_char_ := rec_.characteristic_id;
            price_ok_ := FALSE;
            EXIT;
         END IF;
      END LOOP;     
   $END
   
   RETURN price_ok_;
END Check_Mandatory_Pricing;

PROCEDURE Complete_Pricing (
   info_                     OUT VARCHAR2,
   mode_                     IN OUT VARCHAR2,
   attr_                     IN OUT VARCHAR2,
   configured_line_price_id_ IN NUMBER,
   old_configuration_id_     IN VARCHAR2,
   edited_configuration_id_  IN VARCHAR2)
IS
   exist_configuration_id_ VARCHAR2(50);
   already_exist_          BOOLEAN;
   local_attr_             VARCHAR2(2000) := attr_;
   old_spec_state_         VARCHAR2(20);      
   update_price_           VARCHAR2(5);
   missing_price_char_     VARCHAR2(24);
   price_ok_               BOOLEAN;
BEGIN
   Trace_SYS.Message('Complete pricing total now: ' || To_Char(Get_Price(configured_line_price_id_)));

   exist_configuration_id_ := Client_SYS.Get_Item_Value('EXIST_CONFIGURATION_ID', local_attr_);
   Trace_Sys.Field ('exist_configuration_id_', exist_configuration_id_);
   already_exist_ := exist_configuration_id_ IS NOT NULL AND exist_configuration_id_ != '*' ;
   update_price_ := Client_SYS.Get_Item_Value('UPDATE_PRICE', local_attr_);
   old_spec_state_ := Client_SYS.Get_Item_Value('OLD_SPEC_STATE', local_attr_);

   price_ok_ := Check_Mandatory_Pricing(missing_price_char_, configured_line_price_id_, edited_configuration_id_);
   IF price_ok_ = FALSE THEN
      Error_SYS.Record_General(lu_name_, 'MANDPRICE: The price is mandatory for characteristic :P1.', missing_price_char_);
   END IF;
   
   IF Mode_ = 'New' THEN
      -- Case where the configuration was already existing: the server send this value back
      IF already_exist_ THEN
         Copy_Pricing  ( configured_line_price_id_, edited_configuration_id_,  exist_configuration_id_);
         Remove_Pricing( configured_line_price_id_, edited_configuration_id_ );
         Update_Parent_Config_Id( configured_line_price_id_, exist_configuration_id_, update_price_ );
      ELSE
         -- Remove pricing is not necessary since this is a new configuration.
         -- So there are no previous prices to delete delete unused pricing
         -- but we need to set the new configuration id on the order or quote anyway.
         Update_Parent_Config_Id( configured_line_price_id_, edited_configuration_id_, update_price_ );
      END IF;

   ELSE -- Case where the config was edited
      IF already_exist_ THEN
         IF old_configuration_id_ = exist_configuration_id_ THEN
            -- same config as before remove old prices
            Remove_Pricing( configured_line_price_id_, old_configuration_id_ ); -- clear the destination
            Copy_Pricing  ( configured_line_price_id_, edited_configuration_id_,  exist_configuration_id_);
            Remove_Pricing( configured_line_price_id_, edited_configuration_id_ ); -- remove temporary prices
         ELSE
            -- not the same config as before
            Copy_Pricing( configured_line_price_id_, edited_configuration_id_,  exist_configuration_id_);
            Remove_Pricing( configured_line_price_id_, old_configuration_id_ ); -- remove old prices
            Remove_Pricing( configured_line_price_id_, edited_configuration_id_ ); -- remove temporary prices
         END IF ;
         Update_Parent_Config_Id( configured_line_price_id_, exist_configuration_id_, update_price_ );
      ELSE
         -- There is no existing configuration id that matches, so keep the edited one and forget the old
        IF (old_spec_state_ != 'Completed') AND (edited_configuration_id_ != old_configuration_id_) THEN
            Remove_Pricing( configured_line_price_id_, old_configuration_id_ ); -- remove old prices
         END IF;
         Update_Parent_Config_Id( configured_line_price_id_, edited_configuration_id_, update_price_ );
      END IF;
   END IF;

   info_ := Client_SYS.Get_All_Info;

END Complete_Pricing;


-- Get_Price_Effectivity_Date
--   Returns the price effektivity date of the parent
--   (Sales quotatation or customer order line)
@UncheckedAccess
FUNCTION Get_Price_Effectivity_Date (
   configured_line_price_id_ IN NUMBER ) RETURN DATE
IS
   CURSOR get_attr IS
      SELECT configured_line_type, identity_no, line_no, rel_no, line_item_no, contract
      FROM CONFIGURED_LINE_PRICE_TAB
      WHERE configured_line_price_id = configured_line_price_id_;
   temp_ get_attr%ROWTYPE;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   IF temp_.line_item_no IS NULL THEN
      RETURN Trunc(Site_API.Get_Site_Date(temp_.contract)); -- here we actually have a contract since the order line does not yet exist
   ELSIF temp_.configured_line_type = Configured_Line_Type_API.DB_CUSTOMER_ORDER_LINE THEN
      RETURN Customer_Order_Line_API.Get_Price_Effectivity_Date(temp_.identity_no, temp_.line_no,
                                                                                    temp_.rel_no, temp_.line_item_no);
   ELSIF temp_.configured_line_type = Configured_Line_Type_API.DB_SALES_QUOTATION_LINE THEN
      RETURN Order_Quotation_API.Get_Price_Effectivity_Date(temp_.identity_no);  
   ELSIF temp_.configured_line_type = Configured_Line_Type_API.DB_BUSINESS_OPPORTUNITY_LINE THEN
      $IF Component_Crm_SYS.INSTALLED $THEN
         RETURN Business_Opportunity_API.Get_Price_Effective_Date(temp_.identity_no);
      $ELSE
         RETURN NULL;
      $END
   END IF;
   RETURN NULL; -- this is actually an error.
END Get_Price_Effectivity_Date;


-- Update_Prices_For_Date
--   Takes a new PriceEffectivityDate and recalculates the prices.
--   Ends with an update of the parent.
PROCEDURE Update_Prices_For_Date (
   configured_line_price_id_ IN NUMBER,
   price_effectivity_date_   IN DATE )
IS
   CURSOR Get_Price_Lines (configuration_id_ IN VARCHAR2) IS
      SELECT part_no, spec_revision_no, characteristic_id, config_spec_value_id
      FROM  CONFIG_CHAR_PRICE_TAB
      WHERE configured_line_price_id = configured_line_price_id_
      AND   configuration_id = configuration_id_;
   configuration_id_ VARCHAR2(50);
BEGIN
   configuration_id_ := Get_Parent_Configuration_Id (configured_line_price_id_);
   FOR rec_ IN Get_Price_Lines(configuration_id_) LOOP
      Config_Char_Price_API.Re_Price_Line( configured_line_price_id_ ,
                                           rec_.part_no , configuration_id_ ,
                                           rec_.spec_revision_no, rec_.characteristic_id ,
                                           rec_.config_spec_value_id );
   END LOOP;
   Update_Parent_Config_Id ( configured_line_price_id_, configuration_id_, 'TRUE' );
END Update_Prices_For_Date;


-- Modify_Config_Line_Price
--   This method will automatically reprice the configuration details,
--   if any changes happened to order line or quotation line
PROCEDURE Modify_Config_Line_Price (
   char_price_               OUT NUMBER,
   calc_char_price_          OUT NUMBER,
   configuration_id_         IN  NUMBER,
   configured_line_price_id_ IN  NUMBER,
   part_no_                  IN  VARCHAR2 )
IS
   CURSOR get_config_char_price_rec IS
      SELECT spec_revision_no,characteristic_id,config_spec_value_id
      FROM   CONFIG_CHAR_PRICE_TAB
      WHERE  configured_line_price_id = configured_line_price_id_
      AND    part_no                  = part_no_
      AND    configuration_id         = configuration_id_;
BEGIN
   FOR config_char_price_rec_ IN get_config_char_price_rec  LOOP
      Config_Char_price_API.Re_Price_Line(configured_line_price_id_,
                                          part_no_,
                                          configuration_id_,
                                          config_char_price_rec_.spec_revision_no,
                                          config_char_price_rec_.characteristic_id,
                                          config_char_price_rec_.config_spec_value_id);
   END LOOP;
   Configured_Line_Price_API.Get_Pricing_Totals ( char_price_, calc_char_price_, configured_line_price_id_, configuration_id_);
END Modify_Config_Line_Price;


-- Get_Price_Currency
--   This method will get the price currency if the freeze flag of order or
--   the quotation line is frozen
PROCEDURE Get_Price_Currency (
   freeze_flag_              OUT VARCHAR2,
   price_currency_           OUT NUMBER,
   configured_line_price_id_ IN  NUMBER )
IS
   configured_line_type_ CONFIGURED_LINE_PRICE_TAB.configured_line_type%TYPE;
   identity_no_          CONFIGURED_LINE_PRICE_TAB.identity_no%TYPE;
   line_no_              CONFIGURED_LINE_PRICE_TAB.line_no%TYPE;
   rel_no_               CONFIGURED_LINE_PRICE_TAB.rel_no%TYPE;
   line_item_no_         CONFIGURED_LINE_PRICE_TAB.line_item_no%TYPE;
   colinerec_            Customer_Order_Line_API.Public_Rec;
   quotelinerec_         Order_Quotation_Line_API.Public_Rec;

   CURSOR get_connected_line IS
      SELECT configured_line_type, identity_no, line_no, rel_no, line_item_no
      FROM   CONFIGURED_LINE_PRICE_TAB
      WHERE  configured_line_price_id = configured_line_price_id_;
BEGIN

   OPEN get_connected_line;
   FETCH get_connected_line INTO configured_line_type_, identity_no_, line_no_, rel_no_, line_item_no_;
   CLOSE get_connected_line;

   IF configured_line_type_ = Configured_Line_Type_API.DB_CUSTOMER_ORDER_LINE THEN
      colinerec_ := Customer_Order_Line_API.Get( identity_no_, line_no_, rel_no_, line_item_no_ );
      freeze_flag_ := colinerec_.price_freeze;
      IF (freeze_flag_ = 'FROZEN') THEN
         price_currency_ := colinerec_.sale_unit_price;
      END IF;
   ELSIF configured_line_type_ = Configured_Line_Type_API.DB_SALES_QUOTATION_LINE THEN
      quotelinerec_ := Order_Quotation_Line_API.Get( identity_no_, line_no_, rel_no_, line_item_no_ );
      freeze_flag_ := quotelinerec_.price_freeze;
      IF (freeze_flag_ = 'FROZEN') THEN
         price_currency_ := quotelinerec_.sale_unit_price;
      END IF;
   END IF;
END Get_Price_Currency;


-- Price_Changed
--   Returns 'TRUE' if the new configuration price is different from the
--   Customer Order Line/Quotation Line.
FUNCTION Price_Changed (
   configured_line_price_id_ IN NUMBER,
   configuration_id_         IN VARCHAR2,
   usage_type_               IN VARCHAR2,
   identity_no_              IN VARCHAR2,
   line_no_                  IN VARCHAR2,
   rel_no_                   IN VARCHAR2,
   line_item_no_             IN NUMBER ) RETURN VARCHAR2
IS
   characteristic_price_sum_ NUMBER;
   calc_char_price_sum_      NUMBER;
   characteristic_price_     NUMBER;
BEGIN
   Get_Pricing_Totals(characteristic_price_sum_, calc_char_price_sum_, configured_line_price_id_, configuration_id_);
   IF (usage_type_ = Configured_Line_Type_API.DB_CUSTOMER_ORDER_LINE) THEN
      characteristic_price_ := Customer_Order_Line_API.Get_Char_Price(identity_no_, line_no_, rel_no_, line_item_no_);
   ELSIF (usage_type_ = Configured_Line_Type_API.DB_SALES_QUOTATION_LINE) THEN
      characteristic_price_ := Order_Quotation_Line_API.Get_Char_Price(identity_no_, line_no_, rel_no_, line_item_no_);
   ELSIF usage_type_ = Configured_Line_Type_API.DB_BUSINESS_OPPORTUNITY_LINE THEN
      $IF Component_Crm_SYS.INSTALLED $THEN
         characteristic_price_ := Business_Opportunity_Line_API.Get_Char_Price(identity_no_, rel_no_, line_no_);  
      $ELSE
         NULL;
      $END
   END IF;
   IF (characteristic_price_ != characteristic_price_sum_) THEN
      RETURN 'TRUE';
   END IF;
   RETURN 'FALSE';
END Price_Changed;


-- Get_Identity
--   Returns the identity
@UncheckedAccess
FUNCTION Get_Identity (
   configured_line_price_id_ IN NUMBER ) RETURN VARCHAR2
IS
   identity_ CUST_ORD_CUSTOMER_PUB.customer_no%TYPE;

   CURSOR get_attr IS
      SELECT configured_line_type, identity_no
      FROM   CONFIGURED_LINE_PRICE_TAB
      WHERE  configured_line_price_id = configured_line_price_id_;
   temp_     get_attr%ROWTYPE;

BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;

   IF (temp_.configured_line_type = Configured_Line_Type_API.DB_CUSTOMER_ORDER_LINE) THEN
      identity_ := Customer_Order_API.Get_Customer_No_Pay(temp_.identity_no);
      IF (identity_  IS NULL) THEN
         identity_ := Customer_Order_API.Get_Customer_No(temp_.identity_no);
      END IF;
   ELSIF (temp_.configured_line_type = Configured_Line_Type_API.DB_SALES_QUOTATION_LINE) THEN
      identity_ := Order_Quotation_API.Get_Customer_No_Pay(temp_.identity_no);
      IF (identity_  IS NULL) THEN
         identity_ := Order_Quotation_API.Get_Customer_No(temp_.identity_no);
      END IF;
   ELSIF temp_.configured_line_type = Configured_Line_Type_API.DB_BUSINESS_OPPORTUNITY_LINE THEN
      $IF Component_Crm_SYS.INSTALLED $THEN
         identity_ :=  Business_Opportunity_API.Get_Customer_Id(temp_.identity_no); 
      $ELSE
         NULL;
      $END
   END IF;
   RETURN identity_;
END Get_Identity;


FUNCTION Validate_Mandatory_Prices (
   configured_line_price_id_ IN NUMBER,
   configuration_id_         IN VARCHAR2 ) RETURN VARCHAR2
IS   
   missing_char_  VARCHAR2(24);
   $IF (Component_Cfgchr_SYS.INSTALLED) $THEN 
      CURSOR Get_Edited_Without_Price (configured_line_price_id_ IN NUMBER, configuration_id_ VARCHAR2) IS
         SELECT part_no, spec_revision_no, characteristic_id
         FROM CONFIG_CHAR_PRICE_TAB
         WHERE configuration_id = configuration_id_
         AND   configured_line_price_id = configured_line_price_id_
         AND   characteristic_price IS null;
   $END
BEGIN
   missing_char_ := NULL;
   $IF (Component_Cfgchr_SYS.INSTALLED) $THEN     
      FOR rec_ IN Get_Edited_Without_Price (configured_line_price_id_, configuration_id_) LOOP
         IF Base_Part_Characteristic_API.Get_Mandatory_Price_Db(rec_.part_no,rec_.spec_revision_no,rec_.characteristic_id) = 'YES' THEN
            missing_char_ := rec_.characteristic_id;
            EXIT;
         END IF;
      END LOOP;     
   $END

   RETURN missing_char_;
END Validate_Mandatory_Prices;


@UncheckedAccess
FUNCTION Get_Configured_Line_Type_Db (
   configured_line_price_id_ IN NUMBER ) RETURN VARCHAR2
IS
   CURSOR Get_Configured_Line_Type IS
      SELECT configured_line_type
      FROM CONFIGURED_LINE_PRICE_TAB
      WHERE configured_line_price_id = configured_line_price_id_;

   temp_  CONFIGURED_LINE_PRICE_TAB.Configured_Line_Type%TYPE;
BEGIN
   OPEN get_configured_line_type;
   FETCH get_configured_line_type INTO temp_;
   CLOSE get_configured_line_type;

   RETURN temp_;
END Get_Configured_Line_Type_Db;


@UncheckedAccess
FUNCTION Get_Config_Line_Connected_Info (
   configured_line_price_id_ IN NUMBER ) RETURN CONFIGURED_LINE_PRICE_TAB%ROWTYPE
IS
   temp_ CONFIGURED_LINE_PRICE_TAB%ROWTYPE;
   CURSOR get_attr IS
      SELECT *
      FROM CONFIGURED_LINE_PRICE_TAB
      WHERE configured_line_price_id = configured_line_price_id_;

   CURSOR get_connected_line IS
      SELECT configured_line_type, identity_no, line_no, rel_no, line_item_no
      FROM CONFIGURED_LINE_PRICE_TAB
      WHERE configured_line_price_id = configured_line_price_id_;

   conrec_ get_connected_line%ROWTYPE;

   -- Customer Order and order quotation head and line
   coheadrec_              Customer_Order_API.Public_Rec;
   colinerec_              Customer_Order_Line_API.Public_Rec;
   quoteheadrec_           Order_Quotation_API.Public_Rec;
   quotelinerec_           Order_Quotation_Line_API.Public_Rec;
BEGIN
   OPEN get_connected_line;
   FETCH get_connected_line INTO conrec_;
   CLOSE get_connected_line;

   IF conrec_.configured_line_type = Configured_Line_Type_API.DB_CUSTOMER_ORDER_LINE THEN
      IF conrec_.line_no IS NULL THEN
         -- only the customer order may have its stuff stored here really.
         OPEN get_attr;
         FETCH get_attr INTO temp_;
         CLOSE get_attr;
      ELSE
         -- fetch actual data from customer order
         coheadrec_ := Customer_Order_API.Get( conrec_.identity_no );
         temp_.contract         := coheadrec_.contract;
         temp_.currency_code    := coheadrec_.currency_code;
         colinerec_ := Customer_Order_Line_API.Get( conrec_.identity_no, conrec_.line_no, conrec_.rel_no, conrec_.line_item_no );
         temp_.catalog_no       := colinerec_.catalog_no;
         temp_.price_list_no    := colinerec_.price_list_no;
         temp_.part_price       := colinerec_.part_price;
      END IF;
   ELSIF conrec_.configured_line_type = Configured_Line_Type_API.DB_SALES_QUOTATION_LINE THEN
      -- fetch actual data from order quotation
      quoteheadrec_ := Order_Quotation_API.Get( conrec_.identity_no );
      temp_.contract         := quoteheadrec_.contract;
      temp_.currency_code    := quoteheadrec_.currency_code;

      quotelinerec_ := Order_Quotation_Line_API.Get( conrec_.identity_no, conrec_.line_no, conrec_.rel_no, conrec_.line_item_no );
      temp_.catalog_no       := quotelinerec_.catalog_no;

      temp_.price_list_no    := quotelinerec_.price_list_no;
      temp_.part_price       := quotelinerec_.part_price;  
   ELSIF conrec_.configured_line_type = Configured_Line_Type_API.DB_BUSINESS_OPPORTUNITY_LINE THEN
      -- fetch actual data from business opportunity
      $IF Component_Crm_SYS.INSTALLED $THEN
         quoteheadrec_ := Order_Quotation_API.Get( conrec_.identity_no );
         temp_.contract         := Business_Opportunity_Line_API.Get_Contract(conrec_.identity_no, conrec_.rel_no, conrec_.line_no);
         temp_.currency_code    := Business_Opportunity_API.Get_Currency_Code(conrec_.identity_no);
         temp_.catalog_no       := Business_Opportunity_Line_API.Get_Catalog_No(conrec_.identity_no, conrec_.rel_no, conrec_.line_no);
         temp_.price_list_no    := Business_Opportunity_Line_API.Get_Price_List_No(conrec_.identity_no, conrec_.rel_no, conrec_.line_no);
         temp_.part_price       := Business_Opportunity_Line_API.Get_Part_Price(conrec_.identity_no, conrec_.rel_no, conrec_.line_no);
      $ELSE
         NULL;
      $END
   END IF;
   RETURN temp_;
END Get_Config_Line_Connected_Info;

@UncheckedAccess
PROCEDURE Get_Config_Type_Identity (
   identity_no_          OUT VARCHAR2,
   config_type_          OUT VARCHAR2,
   config_line_price_id_ IN NUMBER )
IS
   CURSOR get_identity_no IS
      SELECT identity_no, configured_line_type
      FROM CONFIGURED_LINE_PRICE_TAB
      WHERE configured_line_price_id = config_line_price_id_;
BEGIN
   OPEN get_identity_no;
   FETCH get_identity_no INTO identity_no_, config_type_;
   CLOSE get_identity_no;
   
END Get_Config_Type_Identity;


@UncheckedAccess
FUNCTION Check_Exist (
   configured_line_price_id_ IN NUMBER ) RETURN VARCHAR2
IS
BEGIN
   IF (Check_Exist___(configured_line_price_id_)) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Check_Exist;



