-----------------------------------------------------------------------------
--
--  Logical unit: SalesPartBasePrice
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210423  AsZelk  Bug 158429(SCZ-14262), Modified Calculate_Part_Prices() to avoid rounding of base_line_price_ and base_line_price_incl_tax_.
--  201014  RasDlk  SCZ-11778, Modified Start_Update_Base_Price__() by replacing Transaction_SYS.Set_Progress_Info() with Transaction_SYS.Log_Progress_Info()
--  201014          as it may lead to a deadlock situation when the task is run in a Schedule Chain.
--  200324  ThKrLk  Bug 151907(SCZ-8550), Modified Calculate_Part_Prices() method to get new parameter as reset_sales_prices_.
--  200324          And added new condition before calculating base_price_ and base_price_incl_tax_.
--  190530  LaThlk  Bug 142914, Modified Calculate_Base_Price() and Calculate_Base_Price_Incl_Tax() by adding new parameter use_default_pbt_ in order to avoid the base price calculation using price break template when it's FALSE. 
--  190107  MaEelk  SCUXXW4-1446, Add Get_Base_Price_Difference, Calculate_Prices and Fetch_Base_Price_From_Costing.
--  181220  UdGnlk  Bug 145652(SCZ-2143) Removed the retrieval of price break template id from sales part base price in Calculate_Base_Price() and Calculate_Base_Price_Incl_Tax().  
--  180129  MaEelk  STRSC-16288, Modified Check_Update___ and Insert___ and replaced the calls to Get_Objstate() with newrec_.rowstate. 
--  180119  CKumlk  STRSC-15930, Modified Check_Update___ and Insert___ by changing Get_State() to Get_Objstate(). 
--  171122  MaEelk  STRSC-14625, Removed sales_price_type_db_ from the signature of Modify_Prices_For_Tax and fetched the correct value from the cursor.
--  170926  RaVdlk  STRSC-11152,Removed Get_State function, since it is generated from the foundation
--  160809  NWeelk  FINHR-1302, Added method Calculate_Part_Prices to calculate prices in sales part base prices window.
--  150630  BudKlk  Bug 123003, Modified Start_Update_Base_Price__ to increase sizes of base_price_site_, catalog_no_ and 
--  150630          sales_price_group_ to be compatible with Update Base Prices dialog box.
--  140615  BudKlk  Bug 121801, Modified the methods Calculate_Base_Price_Incl_Tax and Calculate_Base_Price() in order to send NULL for price break template when the use price base template is unchecked.
--  150123  NaLrlk  Modified Check_Update___() to update previous_base_price only if base_price update.
--  141103  RoJalk  Modified New and removed the comparison of sales_price_origin_ with a IID value.
--- 140305  SURBLK  Change Site_Discom_Info_API.Get_Use_Price_Incl_Tax_Db in to Site_Discom_Info_API.Get_Use_Price_Incl_Tax_Ord_Db.
--  131203  SeJalk  Bug 114057, Changed Calculate_Base_Price by making parameter used_price_break_template_id as IN OUT.
--  130329  NaLrlk  Modified Is_Valid_Price_Break_Templ to add sales_price_type parameter and return number.
--  130314  NaLrlk  Added validation for price_break_template with sales_price_type in Unpack_Check_Insert___ and Unpack_Check_Update___. 
--  130313  NaLrlk  Modified Update_Base_Price__, Start_Update_Base_Price__ and Update_Base_Price_Batch__ to filter with sales_price_type.
--  130311  NaSalk  Added sales_price_type to SALES_PART_BASE_PRICE_DESC_LOV.
--  130306  NaLrlk  Added sales_price_type key column for extend to rental base price.
--  130708  MaIklk  TIBE-1021, Removed global constant inst_CostSet_ and used conditional compilation instead.
--  130513  jokbse  Bug 108268, Added a new catalog_desc column to view SALES_PART_BASE_PRICE_PARTS.
--  120121  SURBLK  Renamed Modify_Base_Prices as Modify_Prices_For_Tax.
--  120911  SURBLK  Added baseline_price_incl_tax_ parameter to New(). 
--  120905  Jeejlk  Added method Get_Use_Price_Incl_Tax_Db and modified New to calculate prices based on use price incl tax.
--  120904  SURBLK  Modified  New() with adding use_price_incl_tax_ parameter.
--  120828  RuLiLk  Bug 104306, Modified view SALES_PART_BASE_PRICE_SITE_LOV.
--  120724  HimRlk  Added method Calculate_Base_Price_Incl_Tax().
--  120627  ShKolk  Added method Modify_Base_Prices.
--  120606  JeeJlk  Modified Update_Base_Price__ to update baseline_price_incl_tax and base_price_incl_tax when performing Update Base Price RMB option.
--  120601  JeeJlk  Modified Unpack_Check_Insert and Unpack_Check_Update to fire error when tax regime is not VAT.Modified Prepare_Insert___ to
--  120601          set USE_PRICE_INCL_TAX_DB value from site.
--  120528  JeeJlk  Added three new columns BASE_PRICE_INCL_TAX, BASELINE_PRICE_INCL_TAX and USE_PRICE_INCL_TAX.
--  120314  DaZase  Removed last TRUE parameter in Init_Method call inside Is_Valid_Price_Break_Templ.
--  111215  MaMalk  Modified Insert___ to move the setting of objversion_ after Finite_State_Init___.
--  110504  RiLase  Added sales_price_group in where statement in cursor get_lines_to_update_ in update base price.
--  110321  RiLase  Changed call to Get_Base_Price_From_Costing from procedure to function.
--  110315  RiLase  Added methods Update_Base_Price__, Update_Base_Price_Batch__,
--  110315          Start_Update_Base_Price__, Modify_Amount_Offset and Modify_Percentage_Offset.
--  110210  RiLase  Added view PRICE_BREAKS_PER_SALES_PART.
--  110207  RiLase  Added Get_State() and check to show only active base price parts in SALES_PART_BASE_PRICE_DESC_LOV.
--  110204  RiLase  Made Is_Valid_Price_Break_Templ public. Added state machine.
--  110118  NaLrlk  Added procedure Is_Valid_Price_Break_Templ___ and Calculate_Base_Price.
--  110118          Modified the Unpack_Check_Insert___/Unpack_Check_Update___ accordingly.
--  110111  NaLrlk  Added private attribute template_id.
--  101220  RiLase  Added BASELINE_PRICE, PERCENTAGE_OFFSET, AMOUNT_OFFSET to New().
--  101215  RiLase  Added attributes BASELINE_PRICE, PERCENTAGE_OFFSET, AMOUNT_OFFSET and method Modify_Baseline_Price.
--  100514  KRPELK  Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  080310  AmPalk  Modified SALES_PART_BASE_PRICE_SITE_LOV by making catalog_no LOV member.
--  080212  MaJalk  Added view SALES_PART_BASE_PRICE_SITE_LOV.
--  --------------------------------- Nice Price ------------------------------
--  060601  MiErlk  Enlarge Identity - Changed view comments - Description.
--  --------------------------------- 13.4.0 --------------------------------
--  060124  JaJalk  Added Assert safe annotation.
--  060118  JaJalk  Added the returning clause in Insert___ according to the new F1 template.
--  050920  MaEelk  Removed unused variables from the code.
--  050505  MaMalk  Changed the select statement used for view VIEW3_LOV.
--  050228  Cpeilk  Bug 49589, Removed BASE_CURRENCY from attr_ in method Prepare_Insert___.
--  040225  IsWilk  Removed the SUBSTRB from the views for Unicode Changes.
--  ----------------EDGE Package Group 3 Unicode Changes----------------------
--  030804  ChFolk  Performed SP4 Merge. (SP4Only)
--  030320  JaBalk  Bug 36321, Modified Validate_Cost_Set___ by modifying the check for inst_CostSet_ and added 
--  030320          EXECUTE IMMEDIATE statement and removed exception statement.
--  020304  MGUO  Bug 28288, Added check that base_price must greater than 0. 
--  010413  JaBa  Bug Fix 20598,Added new global lu constant inst_CostSet_.
--  000913  FBen  Added UNDEFINED.
--  000425  PaLj  Changed check for installed logical units. A check is made when API is instantiatet.
--                See beginning of api-file.
--  000223  SaMi  CID:32778 Add_to_attr('sales_Price_origin',....) chagend to 
--                add_to_attr ('sales_price_origin_db',....)  in procedure NEW
--  000221  SaMi  CID:32580 check added to Check_Delete___ to prevent the users remove records which 
--                belongs to sites that she dose not have access to
--  000120  SaMi  function Check_Exist added
--  000110  SaMi  New Modified
--  991210  SaMi  Procedure  New is added
--  ---------------------12.0 -----------------------------------------------
--  991007  JoEd  Replaced Utility_SYS.Get_User with Fnd_Session_API.Get_Fnd_User.
--  ---------------------- 11.1 ---------------------------------------------
--  990420  RaKu  Y.Cleanup.
--  990311  RaKu  Added column COST_SET.
--  990309  RaKu  Added User_Allowed_Site_API.Authorized in Insert/Update procedures.
--  990308  RaKu  Call ID 11296. Fixed so prvoius_base_price is updated even
--                if the differance is 0 between previous_base_price and base_price.
--  990119  PaLj  Changed sysdate to Site_API.Get_Site_Date(contract)
--  981130  RaKu  Changes to match Design.
--  981119  RaKu  Added view SALES_PART_BASE_PRICE_PARTS.
--  981117  RaKu  Modifyed view SALES_PART_BASE_PRICE_LOV.
--  981106  RaKu  Added checks in Unpack_Check_Insert___/Update___.
--  981102  RaKu  Added procedure Modify_Base_Price.
--  981027  RaKu  Added 'Unit Based'-check in Unpack_Check_Insert___.
--  981017  RaKu  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

state_separator_   CONSTANT VARCHAR2(1)   := Client_SYS.field_separator_;


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Check_Catalog_No_Ref___ (
   newrec_ IN OUT NOCOPY sales_part_base_price_tab%ROWTYPE )
IS   
BEGIN
   Sales_Part_API.Exist(newrec_.base_price_site, newrec_.catalog_no, Sales_Type_API.DB_SALES_AND_RENTAL);
END Check_Catalog_No_Ref___;



@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
   contract_           VARCHAR2(5);
   use_price_incl_tax_ VARCHAR2(20);
BEGIN
   super(attr_);
   contract_ := User_Default_API.Get_Contract;
   use_price_incl_tax_ := Site_Discom_Info_API.Get_Use_Price_Incl_Tax_Ord_Db(contract_);
   Client_SYS.Add_To_Attr('BASE_PRICE_SITE', User_Default_API.Get_Contract, attr_);
   Client_SYS.Add_To_Attr('SALES_PRICE_ORIGIN_DB', Sales_Price_Origin_API.DB_MANUAL, attr_);
   Client_SYS.Add_To_Attr('PERCENTAGE_OFFSET', 0, attr_);
   Client_SYS.Add_To_Attr('AMOUNT_OFFSET', 0, attr_);
   Client_SYS.Add_To_Attr('USE_PRICE_INCL_TAX_DB', use_price_incl_tax_, attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT SALES_PART_BASE_PRICE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   info_       VARCHAR2(32000);
BEGIN
   newrec_.last_updated := Site_API.Get_Site_Date(User_Default_API.Get_Contract);
   Client_SYS.Add_To_Attr('LAST_UPDATED', newrec_.last_updated, attr_);

   super(objid_, objversion_, newrec_, attr_);

   IF Site_Discom_Info_API.Get_Create_Base_Price_Plan_Db(newrec_.base_price_site) = 'TRUE' THEN
      IF (newrec_.rowstate != DB_PLANNED) THEN
         Plan__(info_, objid_, objversion_, attr_, 'DO');
      END IF;
   ELSE
      IF (newrec_.rowstate != DB_ACTIVE) THEN
         Activate__(info_, objid_, objversion_, attr_, 'DO');
      END IF;
   END IF;

END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     SALES_PART_BASE_PRICE_TAB%ROWTYPE,
   newrec_     IN OUT SALES_PART_BASE_PRICE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   newrec_.last_updated := Site_API.Get_Site_Date(User_Default_API.Get_Contract);
   Client_SYS.Add_To_Attr('LAST_UPDATED', newrec_.last_updated, attr_);

   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);

END Update___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN SALES_PART_BASE_PRICE_TAB%ROWTYPE )
IS
BEGIN
   
   IF User_Allowed_Site_API.Authorized(remrec_.base_price_site)=remrec_.base_price_site THEN
   super(remrec_);
   ELSE
     Error_SYS.Record_General(lu_name_, 'BASE_PRICE_SITE: Site :P1 is not allowed for :P2',
                                             remrec_.base_price_site,Fnd_Session_API.Get_Fnd_User);
   END IF;

END Check_Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT sales_part_base_price_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS   
   sales_part_rec_ Sales_Part_API.Public_Rec;
BEGIN
   newrec_.sales_price_type := NVL(newrec_.sales_price_type, Sales_Price_Type_API.DB_SALES_PRICES);

   super(newrec_, indrec_, attr_);

   sales_part_rec_ := Sales_Part_API.Get(newrec_.base_price_site, newrec_.catalog_no);
   
   IF ((newrec_.sales_price_type = Sales_Price_Type_API.DB_SALES_PRICES  AND sales_part_rec_.sales_type = Sales_Type_API.DB_RENTAL_ONLY) OR
       (newrec_.sales_price_type = Sales_Price_Type_API.DB_RENTAL_PRICES AND sales_part_rec_.sales_type = Sales_Type_API.DB_SALES_ONLY)) THEN
      Client_SYS.Add_Info(lu_name_, 'WARN_SALES_TYPE: Sales part :P1 has sales type :P2.', newrec_.catalog_no, Sales_Type_API.Decode(sales_part_rec_.sales_type));
   END IF;

   IF ((newrec_.sales_price_origin = 'COSTING') AND (sales_part_rec_.catalog_type != 'INV')) THEN
      Error_SYS.Record_General(lu_name_, 'ONLY_PARTS_ALLOWED: Only inventory parts may use price origin from Costing.');
   END IF;

   IF (Sales_Price_Group_API.Get_Sales_Price_Group_Type_Db(sales_part_rec_.sales_price_group_id) = 'UNIT BASED') THEN
      Error_SYS.Record_General(lu_name_, 'NOT_PART_BASED: Sales parts with unit based price groups may not be used for base price definition');
   END IF;

   IF (newrec_.base_price < 0 OR newrec_.baseline_price < 0) THEN
      Error_SYS.Record_General(lu_name_, 'NONE_NEG_PRICE: The price must be greater than 0.');
   END IF;

   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, newrec_.base_price_site);
   IF (newrec_.sales_price_type = Sales_Price_Type_API.DB_RENTAL_PRICES) THEN 
      IF (newrec_.sales_price_origin != Sales_Price_Origin_API.DB_MANUAL) THEN 
         Error_SYS.Record_General(lu_name_, 'INVAL_PRICE_ORIGIN: Rental base prices cannot originate from costing.');
      END  IF;
      IF (newrec_.cost_set IS NOT NULL) THEN
         Error_SYS.Record_General(lu_name_, 'INVAL_COST_SET: Cost set cannot have a value for rental base prices.');
      END IF;
   END IF;   
   
   IF (newrec_.template_id IS NOT NULL) AND (Is_Valid_Price_Break_Templ(newrec_.base_price_site, newrec_.catalog_no, newrec_.template_id, newrec_.sales_price_type) = 0) THEN
      Error_SYS.Record_General(lu_name_, 'INVALTEMPLATE: You are only allowed to enter an active price break template of type :P1 with the price unit of measure :P2.',
                               Sales_Price_Type_API.Decode(newrec_.sales_price_type), sales_part_rec_.price_unit_meas);
   END IF;

END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     sales_part_base_price_tab%ROWTYPE,
   newrec_ IN OUT sales_part_base_price_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS   
   sales_part_rec_ Sales_Part_API.Public_Rec;
BEGIN
   
   Trace_SYS.Field('BASE_PRICE', newrec_.base_price);
   Trace_SYS.Field('OLD_BASE_PRICE', oldrec_.base_price);

   super(oldrec_, newrec_, indrec_, attr_);
   
   sales_part_rec_ := Sales_Part_API.Get(newrec_.base_price_site, newrec_.catalog_no);
   
   IF ((newrec_.sales_price_origin = 'COSTING') AND (sales_part_rec_.catalog_type != 'INV')) THEN
      Error_SYS.Record_General(lu_name_, 'ONLY_PARTS_ALLOWED: Only inventory parts may use price origin from Costing.');
   END IF;

   IF (indrec_.base_price = TRUE AND newrec_.base_price IS NOT NULL) THEN
      newrec_.previous_base_price := oldrec_.base_price;
      Client_SYS.Add_To_Attr('PREVIOUS_BASE_PRICE', newrec_.previous_base_price, attr_);
   END IF;

   IF (newrec_.base_price < 0 OR newrec_.baseline_price < 0) THEN
      Error_SYS.Record_General(lu_name_, 'NONE_NEG_PRICE: The price must be greater than 0.');
   END IF;

   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, newrec_.base_price_site);
   IF (newrec_.sales_price_type = Sales_Price_Type_API.DB_RENTAL_PRICES) THEN 
      IF (newrec_.sales_price_origin != Sales_Price_Origin_API.DB_MANUAL) THEN 
         Error_SYS.Record_General(lu_name_, 'INVAL_PRICE_ORIGIN: Rental base prices cannot originate from costing.');
      END  IF;
      IF (newrec_.cost_set IS NOT NULL) THEN
         Error_SYS.Record_General(lu_name_, 'INVAL_COST_SET: Cost set cannot have a value for rental base prices.');
      END IF;
   END IF;

   
   IF (newrec_.template_id IS NOT NULL) AND (Is_Valid_Price_Break_Templ(newrec_.base_price_site, newrec_.catalog_no, newrec_.template_id, newrec_.sales_price_type) = 0) THEN
      Error_SYS.Record_General(lu_name_, 'INVALTEMPLATE: You are only allowed to enter an active price break template of type :P1 with the price unit of measure :P2.',
                               Sales_Price_Type_API.Decode(newrec_.sales_price_type), sales_part_rec_.price_unit_meas);
   END IF;
   IF (newrec_.rowstate = DB_CLOSED) THEN
      Error_SYS.Record_General(lu_name_, 'NOMODIFYSTATUSCLOSED: You are not allowed to modify when status is closed.');
   END IF;

END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Update_Base_Price__ (
   number_of_updates_      OUT NUMBER,
   base_price_site_        IN  VARCHAR2,
   catalog_no_             IN  VARCHAR2,
   sales_price_group_      IN  VARCHAR2,
   sales_price_origin_db_  IN  VARCHAR2,
   update_sales_prices_    IN  VARCHAR2,
   update_rental_prices_   IN  VARCHAR2,
   update_baseline_prices_ IN  VARCHAR2,
   update_baseline_offset_ IN  NUMBER,
   offset_adjustment_type_ IN  VARCHAR2,
   percentage_offset_      IN  NUMBER,
   amount_offset_          IN  NUMBER)
IS
   new_percentage_offset_      NUMBER;
   new_amount_offset_          NUMBER;
   baseline_price_             NUMBER;
   baseline_price_incl_tax_    NUMBER;
   base_price_                 NUMBER;
   base_price_incl_tax_        NUMBER;
   tax_percentage_             NUMBER;
   sales_part_base_price_rec_  SALES_PART_BASE_PRICE_TAB%ROWTYPE;
   add_number_of_updates_      BOOLEAN := TRUE;
   base_price_updated_         BOOLEAN := FALSE;
   ignore_sales_price_type_    VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;
   sales_price_type_db_        SALES_PART_BASE_PRICE_TAB.sales_price_type%TYPE := NULL;

   CURSOR get_lines_to_update_ IS
      SELECT *
      FROM   SALES_PART_BASE_PRICE_TAB
      WHERE  sales_price_origin = NVL(sales_price_origin_db_, sales_price_origin)
      AND    rowstate IN ('Active', 'Planned')
      AND    Report_SYS.Parse_Parameter(base_price_site, base_price_site_) = 'TRUE'
      AND    Report_SYS.Parse_Parameter(catalog_no, catalog_no_) = 'TRUE'
      AND    (ignore_sales_price_type_ = 'TRUE' OR sales_price_type = sales_price_type_db_)
      AND    Report_SYS.Parse_Parameter(Sales_Part_API.Get_Sales_Price_Group_Id(base_price_site, catalog_no),
                                                                                sales_price_group_) = 'TRUE'
      AND    base_price_site IN (SELECT contract FROM site_public
                                 WHERE EXISTS (SELECT 1 FROM user_allowed_site_pub
                                               WHERE contract = site));

BEGIN
   number_of_updates_ := 0;

   -- IF both update_sales_prices_ and update_rental_prices_ are 'FALSE', non of the records updated.
   IF (update_sales_prices_ = Fnd_Boolean_API.DB_FALSE) AND (update_rental_prices_ = Fnd_Boolean_API.DB_FALSE) THEN
      RETURN;
   END IF;

   IF (update_sales_prices_ = Fnd_Boolean_API.DB_TRUE) AND (update_rental_prices_ = Fnd_Boolean_API.DB_TRUE) THEN
      ignore_sales_price_type_ := Fnd_Boolean_API.DB_TRUE;
   ELSIF (update_sales_prices_ = Fnd_Boolean_API.DB_TRUE) THEN
      sales_price_type_db_ := Sales_Price_Type_API.DB_SALES_PRICES;
   ELSIF (update_rental_prices_ = Fnd_Boolean_API.DB_TRUE) THEN
      sales_price_type_db_ := Sales_Price_Type_API.DB_RENTAL_PRICES;
   END IF;
   -- Loop records to update
   FOR rec_ IN get_lines_to_update_ LOOP
      -- Adjust offsets
      IF (offset_adjustment_type_ = 'ADD') THEN
         new_percentage_offset_ := rec_.percentage_offset + percentage_offset_;
         new_amount_offset_     := rec_.amount_offset + amount_offset_;
      ELSIF (offset_adjustment_type_ = 'ADJUST') THEN
         IF (percentage_offset_ IS NOT NULL AND percentage_offset_ != 0) THEN
            new_percentage_offset_ := rec_.percentage_offset * (1 + percentage_offset_ / 100);
         END IF;
         IF (amount_offset_ IS NOT NULL AND amount_offset_ != 0) THEN
            new_amount_offset_     := rec_.amount_offset * (1  + amount_offset_ / 100);
         END IF;
      ELSIF (offset_adjustment_type_ = 'REPLACE') THEN
         new_percentage_offset_ := percentage_offset_;
         new_amount_offset_     := amount_offset_;
      END IF;
      IF (rec_.percentage_offset != new_percentage_offset_) THEN
         Modify_Percentage_Offset(rec_.base_price_site, rec_.catalog_no, rec_.sales_price_type, new_percentage_offset_);
         number_of_updates_ := number_of_updates_ + 1;
         add_number_of_updates_ := FALSE;
      END IF;
      IF (rec_.amount_offset != new_amount_offset_) THEN
         Modify_Amount_Offset(rec_.base_price_site, rec_.catalog_no, rec_.sales_price_type, new_amount_offset_);
         IF add_number_of_updates_ THEN
            number_of_updates_ := number_of_updates_ + 1;
            add_number_of_updates_ := FALSE;
         END IF;
      END IF;

      sales_part_base_price_rec_ := Get_Object_By_Keys___(rec_.base_price_site, rec_.catalog_no, rec_.sales_price_type);
      tax_percentage_            := NVL(Statutory_Fee_API.Get_Fee_Rate(Site_API.Get_Company(rec_.base_price_site), Sales_Part_API.Get_Tax_Code(rec_.base_price_site, rec_.catalog_no)), 0);

      -- Update the baseline price from costing or with percentage offset from dialog
      IF (update_baseline_prices_ IS NOT NULL) THEN
         IF (update_baseline_prices_ = 'COSTING' AND sales_part_base_price_rec_.sales_price_origin = 'COSTING') THEN
            -- Fetch sales part baseline price from costing (if part has sales price origin COSTING) without considering use_price_incl_tax value.
            baseline_price_ := Customer_Order_Pricing_API.Get_Base_Price_From_Costing(rec_.base_price_site, rec_.catalog_no, rec_.cost_set);
            IF (sales_part_base_price_rec_.use_price_incl_tax = 'TRUE' ) THEN 
               baseline_price_incl_tax_ := baseline_price_ * ((tax_percentage_ /100) + 1);
               base_price_incl_tax_     := baseline_price_incl_tax_ * (1 + sales_part_base_price_rec_.percentage_offset/100) + sales_part_base_price_rec_.amount_offset;
               base_price_              := 100 * base_price_incl_tax_ / (tax_percentage_ + 100 );
            ELSE
               base_price_              := baseline_price_ * (1 + sales_part_base_price_rec_.percentage_offset/100) + sales_part_base_price_rec_.amount_offset;
               base_price_incl_tax_     := base_price_ * ((tax_percentage_ / 100) + 1);
               baseline_price_incl_tax_ := baseline_price_ * ((tax_percentage_ /100) + 1);
            END IF;
            
         -- Calculate sales part baseline price/baseline price incl tax with the percentage offset from dialog
         ELSIF (update_baseline_prices_ = 'OFFSET') THEN
            IF (sales_part_base_price_rec_.use_price_incl_tax = 'TRUE' ) THEN 
               baseline_price_incl_tax_ := sales_part_base_price_rec_.baseline_price_incl_tax * (1 + update_baseline_offset_ / 100);
               base_price_incl_tax_     := baseline_price_incl_tax_ * (1 + sales_part_base_price_rec_.percentage_offset/100) + sales_part_base_price_rec_.amount_offset;
               baseline_price_          := 100 * baseline_price_incl_tax_/ (tax_percentage_ + 100);
               base_price_              := 100 * base_price_incl_tax_ / (tax_percentage_ + 100 );
            ELSE
            baseline_price_ := sales_part_base_price_rec_.baseline_price * (1 + update_baseline_offset_ / 100);
               base_price_              := baseline_price_ * (1 + sales_part_base_price_rec_.percentage_offset/100) + sales_part_base_price_rec_.amount_offset;
               base_price_incl_tax_     := base_price_ * ((tax_percentage_ / 100) + 1);
               baseline_price_incl_tax_ := baseline_price_ * ((tax_percentage_ /100) + 1);
            END IF;
            IF (sales_part_base_price_rec_.sales_price_origin = 'COSTING') THEN
               Modify_Sales_Price_Origin(rec_.base_price_site, rec_.catalog_no, rec_.sales_price_type, 'MANUAL');
            END IF;
         END IF;
         base_price_updated_    := TRUE;
         IF add_number_of_updates_ THEN
            number_of_updates_ := number_of_updates_ + 1;
            add_number_of_updates_ := FALSE;
         END IF;
      END IF;
      --END IF;

      -- Update the base price with the new offsets if the base price hasn't been updated from the price update above.
      IF NOT base_price_updated_ AND offset_adjustment_type_ IS NOT NULL THEN
         IF (sales_part_base_price_rec_.use_price_incl_tax = 'TRUE' ) THEN 
            base_price_incl_tax_ := NVL(baseline_price_incl_tax_, sales_part_base_price_rec_.baseline_price_incl_tax) * (1 + sales_part_base_price_rec_.percentage_offset/100) + sales_part_base_price_rec_.amount_offset;
            base_price_          := 100 * base_price_incl_tax_ / (tax_percentage_ + 100 );
            baseline_price_      := 100 * NVL(baseline_price_incl_tax_, sales_part_base_price_rec_.baseline_price_incl_tax)/ (tax_percentage_ + 100);
         ELSE
         base_price_ := NVL(baseline_price_, sales_part_base_price_rec_.baseline_price) * (1 + sales_part_base_price_rec_.percentage_offset/100) + sales_part_base_price_rec_.amount_offset;
            base_price_incl_tax_     := base_price_ * ((tax_percentage_ / 100) + 1);
            baseline_price_incl_tax_ := NVL(baseline_price_, sales_part_base_price_rec_.baseline_price) * ((tax_percentage_ /100) + 1);
      END IF;
         IF add_number_of_updates_ THEN
            number_of_updates_ := number_of_updates_ + 1;
            add_number_of_updates_ := FALSE;
         END IF;
      END IF;
      IF (baseline_price_ IS NOT NULL ) THEN 
         Sales_Part_Base_Price_API.Modify_Baseline_Price(rec_.base_price_site, rec_.catalog_no, rec_.sales_price_type, baseline_price_);
      END IF;
      IF (baseline_price_incl_tax_ IS NOT NULL) THEN 
         Sales_Part_Base_Price_API.Modify_Baseline_Price_Incl_Tax(rec_.base_price_site, rec_.catalog_no, rec_.sales_price_type, baseline_price_incl_tax_);
      END IF;
      IF (base_price_ IS NOT NULL) THEN 
         Sales_Part_Base_Price_API.Modify_Base_Price(rec_.base_price_site, rec_.catalog_no, rec_.sales_price_type, base_price_);
      END IF;
      IF (base_price_incl_tax_ IS NOT NULL) THEN 
         Sales_Part_Base_Price_API.Modify_Base_Price_Incl_Tax(rec_.base_price_site, rec_.catalog_no, rec_.sales_price_type, base_price_incl_tax_);
      END IF;

      -- Reset variables for next record
      add_number_of_updates_ := TRUE;
      base_price_updated_    := FALSE;
      baseline_price_        := NULL;
      baseline_price_incl_tax_ := NULL;
      base_price_              := NULL;
      base_price_incl_tax_     := NULL;
      tax_percentage_          := NULL;

   END LOOP;
END Update_Base_Price__;


PROCEDURE Update_Base_Price_Batch__ (
   base_price_site_        IN  VARCHAR2,
   catalog_no_             IN  VARCHAR2,
   sales_price_group_      IN  VARCHAR2,
   sales_price_origin_db_  IN  VARCHAR2,
   update_sales_prices_    IN  VARCHAR2,
   update_rental_prices_   IN  VARCHAR2,
   update_baseline_prices_ IN  VARCHAR2,
   update_baseline_offset_ IN  NUMBER,
   offset_adjustment_type_ IN  VARCHAR2,
   percentage_offset_      IN  NUMBER,
   amount_offset_          IN  NUMBER)
IS
   attr_ VARCHAR2(32000);
BEGIN

   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('BASE_PRICE_SITE', base_price_site_, attr_);
   Client_SYS.Add_To_Attr('CATALOG_NO', catalog_no_, attr_);
   Client_SYS.Add_To_Attr('SALES_PRICE_GROUP', sales_price_group_, attr_);
   Client_SYS.Add_To_Attr('SALES_PRICE_ORIGIN_DB', sales_price_origin_db_, attr_);
   Client_SYS.Add_To_Attr('UPDATE_SALES_PRICES', update_sales_prices_, attr_);
   Client_SYS.Add_To_Attr('UPDATE_RENTAL_PRICES', update_rental_prices_, attr_);
   Client_SYS.Add_To_Attr('UPDATE_BASELINE_PRICES', update_baseline_prices_, attr_);
   Client_SYS.Add_To_Attr('UPDATE_BASELINE_OFFSET', update_baseline_offset_, attr_);
   Client_SYS.Add_To_Attr('OFFSET_ADJUSTMENT_TYPE', offset_adjustment_type_, attr_);
   Client_SYS.Add_To_Attr('PERCENTAGE_OFFSET', percentage_offset_, attr_);
   Client_SYS.Add_To_Attr('AMOUNT_OFFSET', amount_offset_, attr_);

   Transaction_SYS.Deferred_Call('Sales_Part_Base_Price_API.Start_Update_Base_Price__', attr_,
   Language_SYS.Translate_Constant(lu_name_, 'UPDATE_BASEPRICE: Update Sales Part Base Price'));
END Update_Base_Price_Batch__;


PROCEDURE Start_Update_Base_Price__ (
   attr_ IN VARCHAR2 )
IS
   base_price_site_        VARCHAR2(100);
   catalog_no_             VARCHAR2(1000);
   sales_price_group_      VARCHAR2(100);
   sales_price_origin_db_  VARCHAR2(8);
   update_baseline_prices_ VARCHAR2(10);
   update_baseline_offset_ NUMBER;
   update_sales_prices_    VARCHAR2(10);
   update_rental_prices_   VARCHAR2(10);
   offset_adjustment_type_ VARCHAR2(10);
   percentage_offset_      NUMBER;
   amount_offset_          NUMBER;
   number_of_updates_      NUMBER;
   info_                   VARCHAR2(2000);
BEGIN

   base_price_site_        := Client_SYS.Get_Item_Value('BASE_PRICE_SITE', attr_);
   catalog_no_             := Client_SYS.Get_Item_Value('CATALOG_NO', attr_);
   sales_price_group_      := Client_SYS.Get_Item_Value('SALES_PRICE_GROUP', attr_);
   sales_price_origin_db_  := Client_SYS.Get_Item_Value('SALES_PRICE_ORIGIN_DB', attr_);
   update_sales_prices_    := Client_SYS.Get_Item_Value('UPDATE_SALES_PRICES', attr_);
   update_rental_prices_   := Client_SYS.Get_Item_Value('UPDATE_RENTAL_PRICES', attr_);
   update_baseline_prices_ := Client_SYS.Get_Item_Value('UPDATE_BASELINE_PRICES', attr_);
   update_baseline_offset_ := Client_SYS.Get_Item_Value('UPDATE_BASELINE_OFFSET', attr_);
   offset_adjustment_type_ := Client_SYS.Get_Item_Value('OFFSET_ADJUSTMENT_TYPE', attr_);
   percentage_offset_      := Client_SYS.Get_Item_Value('PERCENTAGE_OFFSET', attr_);
   amount_offset_          := Client_SYS.Get_Item_Value('AMOUNT_OFFSET', attr_);

   Update_Base_Price__(number_of_updates_,
                       base_price_site_,
                       catalog_no_,
                       sales_price_group_,
                       sales_price_origin_db_,
                       update_sales_prices_,
                       update_rental_prices_,
                       update_baseline_prices_,
                       update_baseline_offset_,
                       offset_adjustment_type_,
                       percentage_offset_,
                       amount_offset_);

   IF (Transaction_SYS.Is_Session_Deferred = TRUE) THEN
      IF (number_of_updates_ > 0) THEN
         info_ := Language_SYS.Translate_Constant(lu_name_, 'NUMBER_OF_UPDATES: Base price updated in :P1 record(s).', NULL, TO_CHAR(number_of_updates_));
      ELSE
         info_ := Language_SYS.Translate_Constant(lu_name_, 'NO_UPDATES: No records were updated.');
      END IF;
      Transaction_SYS.Log_Progress_Info(info_);
   END IF;
END Start_Update_Base_Price__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Modify_Percentage_Offset (
   base_price_site_     IN VARCHAR2,
   catalog_no_          IN VARCHAR2,
   sales_price_type_db_ IN VARCHAR2,
   percentage_offset_   IN VARCHAR2 )
IS
   oldrec_      SALES_PART_BASE_PRICE_TAB%ROWTYPE;
   newrec_      SALES_PART_BASE_PRICE_TAB%ROWTYPE;
   objid_       VARCHAR2(2000);
   objversion_  VARCHAR2(2000);
   attr_        VARCHAR2(2000);
   indrec_      Indicator_Rec;
BEGIN
   oldrec_ := Lock_By_Keys___(base_price_site_, catalog_no_, sales_price_type_db_);
   newrec_ := oldrec_;
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('PERCENTAGE_OFFSET', percentage_offset_, attr_);
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
END Modify_Percentage_Offset;


PROCEDURE Modify_Amount_Offset (
   base_price_site_     IN VARCHAR2,
   catalog_no_          IN VARCHAR2,
   sales_price_type_db_ IN VARCHAR2,
   amount_offset_       IN VARCHAR2 )
IS
   oldrec_      SALES_PART_BASE_PRICE_TAB%ROWTYPE;
   newrec_      SALES_PART_BASE_PRICE_TAB%ROWTYPE;
   objid_       VARCHAR2(2000);
   objversion_  VARCHAR2(2000);
   attr_        VARCHAR2(2000);
   indrec_      Indicator_Rec;
BEGIN
   oldrec_ := Lock_By_Keys___(base_price_site_, catalog_no_, sales_price_type_db_);
   newrec_ := oldrec_;
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('AMOUNT_OFFSET', amount_offset_, attr_);
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
END Modify_Amount_Offset;


-- New
--   Add a new record
PROCEDURE New (
   base_price_site_         IN VARCHAR2,
   catalog_no_              IN VARCHAR2,
   sales_price_type_db_     IN VARCHAR2,
   baseline_price_          IN NUMBER,
   baseline_price_incl_tax_ IN NUMBER,
   sales_price_origin_      IN VARCHAR2,
   cost_set_                IN VARCHAR2,
   percentage_offset_       IN NUMBER,
   amount_offset_           IN NUMBER )
IS
   attr_                        VARCHAR2(2000);
   newrec_                      SALES_PART_BASE_PRICE_TAB%ROWTYPE;
   objid_                       VARCHAR2(2000);
   objversion_                  VARCHAR2(2000);
   base_price_                  NUMBER;
   baseline_price_new_          NUMBER;
   baseline_price_incl_tax_new_ NUMBER;
   use_price_incl_tax_          VARCHAR2(20);
   base_price_incl_tax_         NUMBER;
   tax_percentage_              NUMBER;
   catalog_type_                VARCHAR2(80);
   indrec_                      Indicator_Rec;
BEGIN


   IF NOT (Check_Exist___(base_price_site_,catalog_no_, sales_price_type_db_)) THEN
      Client_SYS.Clear_Attr(attr_);
      use_price_incl_tax_          := Site_Discom_Info_API.Get_Use_Price_Incl_Tax_Ord_Db(base_price_site_);
      baseline_price_new_          := baseline_price_;
      baseline_price_incl_tax_new_ := baseline_price_incl_tax_;
      catalog_type_   := Sales_Part_Type_API.encode(Sales_Part_API.Get_Catalog_Type(base_price_site_,catalog_no_));
      tax_percentage_ := NVL(Statutory_Fee_API.Get_Fee_Rate(Site_API.Get_Company(base_price_site_), Sales_Part_API.Get_Tax_Code(base_price_site_, catalog_no_)), 0);
      -- baseline_price_ parameter could be either baseline price or baseline price incl tax depending on use price incl tax in site.
      IF (use_price_incl_tax_ = 'TRUE') THEN
         IF (sales_price_origin_ != 'Costing' OR sales_price_origin_ IS NULL) THEN 
            base_price_incl_tax_ := baseline_price_incl_tax_new_ * (1 + NVL(percentage_offset_, 0)/100) + NVL(amount_offset_, 0);
            baseline_price_new_  := 100 * baseline_price_incl_tax_new_ / (tax_percentage_ + 100);
            base_price_          := 100 * base_price_incl_tax_ / (tax_percentage_ + 100 );
         ELSE
            baseline_price_incl_tax_new_ := baseline_price_new_ * ( 1 + tax_percentage_ / 100);
            base_price_incl_tax_         := baseline_price_incl_tax_new_ * (1 + NVL(percentage_offset_, 0)/100) + NVL(amount_offset_, 0);
            base_price_                  := 100 * base_price_incl_tax_ / (tax_percentage_ + 100 );
         END IF;
      ELSE
         base_price_                  := baseline_price_new_ * (1 + NVL(percentage_offset_, 0)/100) + NVL(amount_offset_, 0);
         baseline_price_incl_tax_new_ := baseline_price_new_ * ( 1 + tax_percentage_ / 100);
         base_price_incl_tax_         := base_price_ * (1 + tax_percentage_ / 100);
      END IF;
      
      Client_SYS.Add_To_Attr('BASE_PRICE', base_price_, attr_);
      Client_SYS.Add_To_Attr('BASE_PRICE_INCL_TAX', base_price_incl_tax_, attr_);
      Client_SYS.Add_To_Attr('BASELINE_PRICE', baseline_price_new_, attr_);
      Client_SYS.Add_To_Attr('BASELINE_PRICE_INCL_TAX', baseline_price_incl_tax_new_, attr_);
      Client_SYS.Add_To_Attr('BASE_PRICE_SITE', base_price_site_, attr_);
      Client_SYS.Add_To_Attr('CATALOG_NO', catalog_no_, attr_);
      Client_SYS.Add_To_Attr('SALES_PRICE_TYPE_DB', sales_price_type_db_, attr_);
      Client_SYS.Add_To_Attr('PERCENTAGE_OFFSET', NVL(percentage_offset_, 0), attr_);
      Client_SYS.Add_To_Attr('AMOUNT_OFFSET', NVL(amount_offset_, 0), attr_);
      Client_SYS.Add_To_Attr('USE_PRICE_INCL_TAX_DB', use_price_incl_tax_, attr_);
      
      -- Only Inventory parts can have costing set as sales price origin
      IF ((sales_price_type_db_ = Sales_Price_Type_API.DB_SALES_PRICES) AND
         (catalog_type_        = Sales_Part_Type_API.DB_INVENTORY_PART) AND 
         (sales_price_origin_  = 'Costing')) THEN
         Client_SYS.Add_To_Attr('SALES_PRICE_ORIGIN_DB', Sales_Price_Origin_API.DB_COSTING, attr_);
         Client_SYS.Add_To_Attr('COST_SET',cost_set_,attr_);
      ELSE
          Client_SYS.Add_To_Attr('SALES_PRICE_ORIGIN_DB', Sales_Price_Origin_API.DB_MANUAL, attr_);
      END IF;
      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);
   END IF;
END New;


-- Is_Valid_Price_Break_Templ
--   Checks whether the given template_id is Active and match the template's
--   Price UoM with the given sales part.
--   Returns TRUE if it is a Active and match the Price UoM value, FALSE otherwise.
@UncheckedAccess
FUNCTION Is_Valid_Price_Break_Templ (
   base_price_site_     IN VARCHAR2,
   catalog_no_          IN VARCHAR2,
   template_id_         IN VARCHAR2,
   sales_price_type_db_ IN VARCHAR2 ) RETURN NUMBER
IS
   valid_template_ NUMBER;
   price_template_rec_ Price_Break_Template_API.Public_Rec;
   price_unit_meas_ VARCHAR2(10);
BEGIN
   price_unit_meas_ := Sales_Part_API.Get_Price_Unit_Meas(base_price_site_, catalog_no_);
   price_template_rec_ := Price_Break_Template_API.Get(template_id_);
   valid_template_ := 0;
   IF (Price_Break_Template_API.Get_Objstate(template_id_) = 'Active') AND
      (price_template_rec_.price_unit_meas = price_unit_meas_) AND
      (price_template_rec_.sales_price_type = sales_price_type_db_) THEN
         valid_template_ := 1;
   END IF;
   RETURN valid_template_;
END Is_Valid_Price_Break_Templ;


PROCEDURE Modify_Sales_Price_Origin (
   base_price_site_     IN VARCHAR2,
   catalog_no_          IN VARCHAR2,
   sales_price_type_db_ IN VARCHAR2,
   sales_price_origin_  IN VARCHAR2 )
IS
   oldrec_      SALES_PART_BASE_PRICE_TAB%ROWTYPE;
   newrec_      SALES_PART_BASE_PRICE_TAB%ROWTYPE;
   objid_       VARCHAR2(2000);
   objversion_  VARCHAR2(2000);
   attr_        VARCHAR2(2000);
   number_null_ NUMBER := NULL;
   indrec_      Indicator_Rec;
   
   CURSOR update_lines_ IS
      SELECT base_price_site, catalog_no
      FROM   SALES_PART_BASE_PRICE_TAB
      WHERE  rowstate IN ('Active', 'Planned')
      AND    base_price_site LIKE base_price_site_
      AND    catalog_no LIKE catalog_no_
      AND    sales_price_type = sales_price_type_db_;
BEGIN
   FOR rec_ IN update_lines_ LOOP
      oldrec_ := Lock_By_Keys___(rec_.base_price_site, rec_.catalog_no, sales_price_type_db_);
      newrec_ := oldrec_;
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('SALES_PRICE_ORIGIN_DB', sales_price_origin_, attr_);
      IF (sales_price_origin_ = 'MANUAL') THEN
         Client_SYS.Add_To_Attr('COST_SET', number_null_, attr_);
      END IF;
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
      Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
   END LOOP;
END Modify_Sales_Price_Origin;


-- Modify_Base_Price
--   Modifyes base price.
PROCEDURE Modify_Base_Price (
   base_price_site_     IN VARCHAR2,
   catalog_no_          IN VARCHAR2,
   sales_price_type_db_ IN VARCHAR2,
   base_price_          IN NUMBER )
IS
   oldrec_     SALES_PART_BASE_PRICE_TAB%ROWTYPE;
   newrec_     SALES_PART_BASE_PRICE_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   attr_       VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN
   oldrec_ := Lock_By_Keys___(base_price_site_, catalog_no_, sales_price_type_db_);
   newrec_ := oldrec_;
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('BASE_PRICE', base_price_, attr_);
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
END Modify_Base_Price;


PROCEDURE Modify_Base_Price_Incl_Tax (
   base_price_site_       IN VARCHAR2,
   catalog_no_            IN VARCHAR2,
   sales_price_type_db_   IN VARCHAR2,
   base_price_incl_tax_   IN NUMBER )
IS
   oldrec_     SALES_PART_BASE_PRICE_TAB%ROWTYPE;
   newrec_     SALES_PART_BASE_PRICE_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   attr_       VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN
   oldrec_ := Lock_By_Keys___(base_price_site_, catalog_no_, sales_price_type_db_);
   newrec_ := oldrec_;
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('BASE_PRICE_INCL_TAX', base_price_incl_tax_, attr_);
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
END Modify_Base_Price_Incl_Tax;


PROCEDURE Modify_Baseline_Price_Incl_Tax (
   base_price_site_         IN VARCHAR2,
   catalog_no_              IN VARCHAR2,
   sales_price_type_db_     IN VARCHAR2,
   baseline_price_incl_tax_ IN NUMBER )
IS
   oldrec_     SALES_PART_BASE_PRICE_TAB%ROWTYPE;
   newrec_     SALES_PART_BASE_PRICE_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   attr_       VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN
   oldrec_ := Lock_By_Keys___(base_price_site_, catalog_no_, sales_price_type_db_);
   newrec_ := oldrec_;
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('BASELINE_PRICE_INCL_TAX', baseline_price_incl_tax_, attr_);
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
END Modify_Baseline_Price_Incl_Tax;


PROCEDURE Modify_Baseline_Price (
   base_price_site_     IN VARCHAR2,
   catalog_no_          IN VARCHAR2,
   sales_price_type_db_ IN VARCHAR2,
   baseline_price_      IN NUMBER )
IS
   oldrec_     SALES_PART_BASE_PRICE_TAB%ROWTYPE;
   newrec_     SALES_PART_BASE_PRICE_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   attr_       VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN
   oldrec_ := Lock_By_Keys___(base_price_site_, catalog_no_, sales_price_type_db_);
   newrec_ := oldrec_;
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('BASELINE_PRICE', baseline_price_, attr_);
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
END Modify_Baseline_Price;


-- Modify_Prices_For_Tax
--   Recalculates price columns depending on the use_price_incl_tax check box.
--   Called when fee_code is modified in Sales Part.
PROCEDURE Modify_Prices_For_Tax (
   base_price_site_     IN VARCHAR2,
   catalog_no_          IN VARCHAR2,
   fee_code_            IN VARCHAR2 )
IS
   baseline_price_             NUMBER;
   baseline_price_incl_tax_    NUMBER;
   base_price_                 NUMBER;
   base_price_incl_tax_        NUMBER;
   calc_base_                  VARCHAR2(10);
   
   CURSOR get_data IS
      SELECT baseline_price, base_price, baseline_price_incl_tax, base_price_incl_tax, use_price_incl_tax, sales_price_type
      FROM SALES_PART_BASE_PRICE_TAB
      WHERE catalog_no = catalog_no_
      AND   base_price_site = base_price_site_;
BEGIN
   
   FOR rec_ IN get_data LOOP
      IF rec_.use_price_incl_tax = 'TRUE' THEN
         calc_base_ := 'GROSS_BASE';
      ELSE
         calc_base_ := 'NET_BASE';
      END IF;
      baseline_price_          := rec_.baseline_price;
      baseline_price_incl_tax_ := rec_.baseline_price_incl_tax;
      base_price_              := rec_.base_price;
      base_price_incl_tax_     := rec_.base_price_incl_tax;
      
      Calculate_Part_Prices(baseline_price_, 
                            baseline_price_incl_tax_, 
                            base_price_, 
                            base_price_incl_tax_, 
                            0, 
                            0, 
                            base_price_site_, 
                            catalog_no_, 
                            calc_base_, 
                            'NO_CALC', 
                            NULL, 
                            16);
      Modify_Baseline_Price(base_price_site_, catalog_no_, rec_.sales_price_type, baseline_price_);
      Modify_Baseline_Price_Incl_Tax(base_price_site_, catalog_no_, rec_.sales_price_type, baseline_price_incl_tax_);      
      Modify_Base_Price(base_price_site_, catalog_no_, rec_.sales_price_type, base_price_);
      Modify_Base_Price_Incl_Tax(base_price_site_, catalog_no_, rec_.sales_price_type, base_price_incl_tax_);
   END LOOP;
END Modify_Prices_For_Tax;


@UncheckedAccess
FUNCTION Get_Use_Price_Incl_Tax_Db (
   base_price_site_ IN VARCHAR2,
   catalog_no_      IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ SALES_PART_BASE_PRICE_TAB.use_price_incl_tax%TYPE;
   CURSOR get_attr IS
      SELECT use_price_incl_tax
      FROM SALES_PART_BASE_PRICE_TAB
      WHERE base_price_site = base_price_site_
      AND   catalog_no = catalog_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Use_Price_Incl_Tax_Db;


FUNCTION Check_Exist (
   base_price_site_     IN VARCHAR2,
   catalog_no_          IN VARCHAR2,
   sales_price_type_db_ IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN

   IF NOT (Check_Exist___(base_price_site_, catalog_no_, sales_price_type_db_))  THEN
      RETURN(0);
   ELSE
      RETURN(1);
   END IF;
END Check_Exist;

-- Added the parameter use_default_pbt_ to indicate the usage of default price break template when calculating the base price.
-- Calculate_Base_Price
--   Calculate the base price for given minimum quantity when use price break template.
--   Otherwise returns the base price.
PROCEDURE Calculate_Base_Price (
   used_price_break_template_id_ IN OUT VARCHAR2,
   base_price_                   OUT NUMBER,
   base_price_site_              IN  VARCHAR2,
   catalog_no_                   IN  VARCHAR2,
   sales_price_type_db_          IN  VARCHAR2,
   min_quantity_                 IN  NUMBER,
   use_price_break_templates_    IN  VARCHAR2,
   min_duration_                 IN  NUMBER DEFAULT -1,
   use_default_pbt_              IN  VARCHAR2 DEFAULT 'TRUE' )
IS
   sp_base_price_rec_   SALES_PART_BASE_PRICE_TAB%ROWTYPE;
   template_line_rec_   Price_Break_Template_Line_API.Public_Rec;
BEGIN
   sp_base_price_rec_ := Get_Object_By_Keys___(base_price_site_, catalog_no_, sales_price_type_db_);
   base_price_ := sp_base_price_rec_.base_price;
   
   IF used_price_break_template_id_ IS NULL THEN
      used_price_break_template_id_ := sp_base_price_rec_.template_id;
   END IF;
   
   -- Added new condition to check the value of use_default_pbt_ before calculating the base_price using price break template
   IF (used_price_break_template_id_ IS NOT NULL) AND (use_price_break_templates_ = Fnd_Boolean_API.DB_TRUE) AND (use_default_pbt_ = Fnd_Boolean_API.DB_TRUE) AND
      (Is_Valid_Price_Break_Templ(base_price_site_, catalog_no_, used_price_break_template_id_, sales_price_type_db_) = 1) THEN
      IF Price_Break_Template_Line_API.Check_Exist(used_price_break_template_id_, min_quantity_, min_duration_) THEN         
         template_line_rec_ := Price_Break_Template_Line_API.Get(used_price_break_template_id_, min_quantity_, min_duration_);
         base_price_ := base_price_ * (1 + (template_line_rec_.percentage_offset / 100));
      ELSE
         used_price_break_template_id_ := NULL;
      END IF;
   ELSE
      used_price_break_template_id_ := NULL;    
   END IF;
END Calculate_Base_Price;

-- Added the parameter use_default_pbt_ to indicate the usage of default price break template when calculating the base price.
-- Calculate_Base_Price_Incl_Tax
--   Calculate the base price including tax for given minimum quantity when use price break template.
--   Otherwise returns the base price including tax.
PROCEDURE Calculate_Base_Price_Incl_Tax (
   used_price_break_template_id_ IN OUT VARCHAR2,
   base_price_incl_tax_          OUT NUMBER,
   base_price_site_              IN  VARCHAR2,   
   catalog_no_                   IN  VARCHAR2,
   sales_price_type_db_          IN  VARCHAR2,
   min_quantity_                 IN  NUMBER,
   use_price_break_templates_    IN  VARCHAR2,
   min_duration_                 IN  NUMBER DEFAULT -1,
   use_default_pbt_              IN  VARCHAR2 DEFAULT 'TRUE' )
IS
   sp_base_price_rec_   SALES_PART_BASE_PRICE_API.Public_Rec;
   template_line_rec_   Price_Break_Template_Line_API.Public_Rec;
BEGIN

   sp_base_price_rec_ := Get(base_price_site_, catalog_no_, sales_price_type_db_);
   base_price_incl_tax_ := sp_base_price_rec_.base_price_incl_tax;
   
   IF used_price_break_template_id_ IS NULL THEN      
      used_price_break_template_id_ := sp_base_price_rec_.template_id;
   END IF;
   
   IF (used_price_break_template_id_ IS NOT NULL) AND (use_price_break_templates_ = Fnd_Boolean_API.db_true) AND (use_default_pbt_ = Fnd_Boolean_API.DB_TRUE) AND
      (Is_Valid_Price_Break_Templ(base_price_site_, catalog_no_, used_price_break_template_id_, sales_price_type_db_) = 1) THEN

      IF Price_Break_Template_Line_API.Check_Exist(used_price_break_template_id_, min_quantity_, min_duration_) THEN         
         template_line_rec_ := Price_Break_Template_Line_API.Get(used_price_break_template_id_, min_quantity_, min_duration_);
         base_price_incl_tax_ := base_price_incl_tax_ * (1 + (template_line_rec_.percentage_offset / 100));
      ELSE
         used_price_break_template_id_ := NULL;
      END IF;
   ELSE
      used_price_break_template_id_ := NULL;    
   END IF;
END Calculate_Base_Price_Incl_Tax;

-- Calculate_Part_Prices
-- This is called from sales part base prices to calculate base prices and base line prices.
PROCEDURE Calculate_Part_Prices (
   base_line_price_          IN OUT NUMBER,
   base_line_price_incl_tax_ IN OUT NUMBER,
   base_price_               IN OUT NUMBER,
   base_price_incl_tax_      IN OUT NUMBER,
   perc_offset_              IN     NUMBER,
   amount_offset_            IN     NUMBER,
   contract_                 IN     VARCHAR2,
   catalog_no_               IN     VARCHAR2,
   calc_base_                IN     VARCHAR2,
   calc_direction_           IN     VARCHAR2,
   rounding_                 IN     NUMBER,
   ifs_curr_rounding_        IN     NUMBER,
   reset_sales_prices_       IN     BOOLEAN   DEFAULT TRUE)
IS
   
BEGIN
   -- Base prices entered.. need to back calculate the line prices.
   IF calc_direction_ = 'BACKWARD' THEN
      IF calc_base_ = 'NET_BASE' THEN
         base_line_price_          := (base_price_ -  amount_offset_ )/(1 + (perc_offset_/100));         
      ELSE
         base_line_price_incl_tax_ := (base_price_incl_tax_ -  amount_offset_ )/(1 + (perc_offset_/100));
      END IF;      
   END IF;
   -- Base line price should not be rounded based on the data setup.   
   Tax_Handling_Order_Util_API.Calc_Price_Source_Prices(base_line_price_,
                                                        base_line_price_incl_tax_, 
                                                        contract_,  
                                                        catalog_no_,
                                                        calc_base_, 
                                                        NVL(ifs_curr_rounding_, 20));
   -- Line prices entered.. need to calculate the base prices.
   IF calc_direction_ = 'FORWARD' THEN
      IF calc_base_ = 'NET_BASE' THEN
         IF (reset_sales_prices_) THEN
            base_price_          := (base_line_price_ * (1 + perc_offset_/100) + amount_offset_);
         END IF;
      ELSE
         IF (reset_sales_prices_) THEN
            base_price_incl_tax_ := (base_line_price_incl_tax_ * (1 + perc_offset_/100) + amount_offset_);
         END IF;
      END IF;
   END IF;
   
   Tax_Handling_Order_Util_API.Calc_Price_Source_Prices(base_price_,
                                                        base_price_incl_tax_, 
                                                        contract_,  
                                                        catalog_no_,
                                                        calc_base_, 
                                                        NVL(rounding_, ifs_curr_rounding_));   
END Calculate_Part_Prices;

FUNCTION Get_Base_Price_Difference (
   base_price_          IN NUMBER,
   previous_base_price_ IN NUMBER ) RETURN NUMBER
IS
   base_price_difference_ NUMBER;
BEGIN
   IF ((previous_base_price_ IS NULL) OR (previous_base_price_ = 0)) THEN
      base_price_difference_ := 0;
   ELSE
      base_price_difference_ := ((base_price_/previous_base_price_) - 1) * 100;
   END IF;
   RETURN base_price_difference_;
END Get_Base_Price_Difference;

PROCEDURE Calculate_Prices (
   base_line_price_              IN OUT NUMBER,
   base_line_price_incl_tax_     IN OUT NUMBER,
   base_price_                   IN OUT NUMBER,
   base_price_incl_tax_          IN OUT NUMBER,
   percentage_offset_            IN     NUMBER,
   amount_offset_                IN     NUMBER,
   base_price_site_              IN     VARCHAR2,
   catalog_no_                   IN     VARCHAR2,
   use_price_incl_tax_db_        IN     VARCHAR2,
   direction_                    IN     VARCHAR2,
   ifs_curr_rounding_            IN     NUMBER)
IS
   calc_base_             VARCHAR2(10);
   calc_prices_           BOOLEAN := TRUE;
   calc_direction_        VARCHAR2(20);
   
BEGIN
   IF (use_price_incl_tax_db_ = 'TRUE') THEN
      calc_base_ := 'GROSS_BASE';
      IF ((base_line_price_incl_tax_ IS NULL) AND (base_price_incl_tax_ IS NULL)) THEN
         base_line_price_ := base_line_price_incl_tax_;
         base_price_ := base_price_incl_tax_;         
         calc_prices_ := FALSE;
      END IF;
   ELSE
      calc_base_ := 'NET_BASE';
      IF ((base_line_price_ IS NULL) AND (base_price_ IS NULL)) THEN
         base_line_price_incl_tax_ := base_line_price_;         
         base_price_incl_tax_ := base_price_;
         calc_prices_ := FALSE;
      END IF;
   END IF;
   
   IF (calc_prices_) THEN 
      calc_direction_ := direction_;      
      Calculate_Part_Prices(base_line_price_,
                           base_line_price_incl_tax_,
                           base_price_, 
                           base_price_incl_tax_, 
                           percentage_offset_, 
                           amount_offset_, 
                           base_price_site_, 
                           catalog_no_, 
                           calc_base_, 
                           calc_direction_, 
                           NULL, 
                           NVL(ifs_curr_rounding_,20));
   END IF;                                               
   
END Calculate_Prices;

PROCEDURE Fetch_Base_Price_From_Costing (
   base_line_price_              IN OUT NUMBER,
   base_line_price_incl_tax_     IN OUT NUMBER,
   base_price_                   IN OUT NUMBER,
   base_price_incl_tax_          IN OUT NUMBER, 
   percentage_offset_            IN     NUMBER,
   amount_offset_                IN     NUMBER,
   base_price_site_              IN     VARCHAR2,
   catalog_no_                   IN     VARCHAR2,
   cost_set_                     IN     NUMBER,
   use_price_incl_tax_db_        IN     VARCHAR2,
   ifs_curr_rounding_            IN     NUMBER
)
IS
   base_price_from_costing_ NUMBER;
BEGIN
   IF ((base_price_site_ IS NOT NULL) AND (catalog_no_ IS NOT NULL)) THEN
      base_price_from_costing_ := Customer_Order_Pricing_API.Get_Base_Price_From_Costing( base_price_site_, catalog_no_, cost_set_);
      IF (base_price_from_costing_ IS NOT NULL) THEN
         base_line_price_ := base_price_from_costing_; 
         Tax_Handling_Order_Util_API.Calc_Price_Source_Prices(base_line_price_, 
                                                              base_line_price_incl_tax_,                                                                                      
                                                              base_price_site_,
                                                              catalog_no_, 
                                                              'NET_BASE',
                                                              ifs_curr_rounding_);
      END IF;
      Calculate_Prices(base_line_price_,
                     base_line_price_incl_tax_,
                     base_price_,
                     base_price_incl_tax_,
                     percentage_offset_,
                     amount_offset_,
                     base_price_site_,
                     catalog_no_,
                     use_price_incl_tax_db_,
                     'FORWARD',
                     ifs_curr_rounding_);
   END IF;
END Fetch_Base_Price_From_Costing;
