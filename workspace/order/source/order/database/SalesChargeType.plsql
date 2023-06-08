-----------------------------------------------------------------------------
--
--  Logical unit: SalesChargeType
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210126  MaEelk  SC2020R1-11977, Modified Copy_Charge_Type and replaced the calls to Pack___, Check_Insert___ and Insert___ with New___
--  160202  IsSalk  FINHR-647, Redirect method calls to new utility LU TaxHandlingOrderUtil.
--  160118  IsSalk  FINHR-657, Used FndBoolean in taxable attribute in Sales Charge Type.
--  160111  IsSalk  FINHR-581, Renamed column FEE_CODE to TAX_CODE in SALES_CHARGE_TYPE_TAB.
--  151124  IsSalk  FINHR-341, Moved tax fetching logic to Customer_Order_Tax_Util_API.
--  151123  IsSalk  FINHR-344, Moved tax related validations to Tax_Handling_Util_API.
--  150729  DilMlk  Bug 123781, Modified Validate_Tax_Code___ to get an error message for Tax Codes with invalid date ranges.
--- 140305  SURBLK  Change Site_Discom_Info_API.Get_Use_Price_Incl_Tax_Db in to Site_Discom_Info_API.Get_Use_Price_Incl_Tax_Ord_Db.
--  120528  HimRlk  Added new columns charge_amount_incl_tax, use_price_incl_tax.
--  110131  Nekolk  EANE-3744  added where clause to View SALES_CHARGE_TYPE
--  110113  Elarse  DF-553, Modified code in Validate_Tax_Code___().
--  110104  Elarse  Modified Validate_Tax_Code___() and added Validate_Tax___().
--  101222  Elarse  Added new attribute tax_class_id.
--  101005  SudJlk  Bug 93374, Modified view SALES_CHARGE_TYPE to correct invalid column FLAGS in the view columns.
--  100623  SaJjlk  Bug 91384, Added method Sale_Charge_Exist_Posting_Ctrl and modified logic in method Get_Control_Type_Value_Desc.
--  100623          Modified view SALES_CHARGE_TYPE_ACCRUL to add column Contract_Charge. 
--  100514  KRPELK  Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  091014  RILASE  Added check on taxable attribute for charge type category promotion and pack size.
--  091014  UtSwlk  Modified Unpack_Check_Insert___ and Unpack_Check_Update___ to set charge cost 0 if charge cost % and charge cost are null.
--  081001  SuJalk  Bug 74635, Added delivery type to the LU and added method Check_Delivery_Type__.
--  090623  KiSalk  Set charge_amount to 0 if both chargeand charge_amount null in Unpack_Check_Update___ and Unpack_Check_Insert___.
--  090409  RiLase  Added sales promotion validations in Validate_Charge_And_Cost___ and Validate_Tax_Code___.
--  090323  KiSalk  Added charge, charge_cost_percent to Get and added methods Get_Charge and Get_Charge_Cost_Percent
--  090318  KiSalk  Added attributes charge and charge_cost_percent and made charge_cost nullable; added validations.
--  081114  MaHplk  Modified view comment of sales_chg_type_category and added some validation on Unpack_Check_Update___.
--  080826   MaJalk  Added validation to sales_chg_type_category at Unpack_Check_Update___ and
--  080826           set unit charge as TRUE when sales_chg_type_category is Pack Size at Unpack_Check_Insert___.
--  080825  MaJalk  Changed sales_charge_type_category to sales_chg_type_category.
--    080819  MaJalk  Added validations for tax code and unit charge.
--    080816  MaJalk  Modified Check_Exist() to return String. Modified Copy_Charge_Type().
--  080805  MaJalk  Added default values to UNIT_CHARGE_DB and SALES_CHARGE_TYPE_CATEGORY at Prepare_Insert___.
--  080718  MaJalk  Added method Check_Exist and Copy_Charge_Type and attribute sales_charge_type_category.
--  080619  MaJalk  Removed attribute use_auto_freight_calc and function Get_Use_Auto_Freight_Calc.
--  080605  MiKulk  Added the method Get_Unit_Charge_Db and some validations.
--  080603  MiKulk  Added the unit_charge as a public attribute.
--  071207  JeLise  Added use_auto_freight_calc.
--  -------------------Nice Price----------------------------------------------
--  060621  MalLlk  Modified Get to include Intrastat_exempt to the cursor get_attr.
--  060621          Modified Prepare_Insert___
--  060427  KanGlk  Added new new functions Get_Charge_Group_Desc and Get_Currency_Code.
--  ------------------------------- 13.4.0 ------------------------------------
--  060118  JaJalk  Added the returning clause in Insert___ according to the new F1 template.
--  041020  ChJalk  Bug 47056, Added the column 'company' and Modified the WHERE condition in view VIEW_ACCRUL.
--  040225  IsWilk  Removed SUBSTRB from the views for Unicode Changes.
--  ----------------EDGE Package Group 3 Unicode Changes--------------------
--  030911  UdGnlk  Modified Validate_Tax_Code___ for sales tax back to the previous message.
--  030910  UdGnlk  Modified Validate_Tax_Code___ to make error message meaningful for sales tax.
--  030507  ChFolk  Call ID 96789. Modified the inconsistent error messages.
--  030505  ChFolk  Call ID 96247. Modified Validate_Tax_Code___. Used method Get_Order_Fee_Rate instead of Get_Fee_Rate.
--  030403  ChFolk  Modified error texts in Validate_Tax_Code___.
--  030321  ChFolk  Modified PROCEDURE Validate_Tax_Code___ to apply the change of DB values of Tax_Regime_API.
--  030312  ChFolk  Added PROCEDURE Validate_Tax_Code___. Used it in Unpack_Check_Insert___ and Unpack_Check_Update___.
--                  Removed Sales tax/VAT check in Unpack_Check_Insert___ and Unpack_Check_Update___.
--  001115  DaZa  Bugfix 17996, adding warning text when taxable isn't allowed for company.
--  001018  DaZa  Bugfix in Prepare_Insert___ so db values are used for
--                PRINT_CHARGE_TYPE and PRINT_COLLECT_CHARGE.
--  000822  DaZa  Added print_collect_charge to view and methods.
--  ------------------------------ 12.1 -------------------------------------
--  000218  DaZa  Added company to view and methods, also new method Get_Company.
--  000214  JoEd  Changed fetch of "VAT usage" from Company. Added error message NOTAXINFO.
--  000204  JoEd  Added function Get_Taxable_Db. Added taxable vs fee code check
--                on insert and update. Removed mandatory flag from fee_code.
--  000117  DaZa  Added default value for print_charge_type in Unpack_Check_Insert___.
--  991210  DaZa  Added print_charge_type.
--  ------------------------------ 12.0 -------------------------------------
--  991029  DaZa  Added /NOCHECK on view &VIEW_ACCRUL.
--  991021  DaZa  Added methods Get_Control_Type_Value_Desc and Exist(without contract) which
--                are used by ACCRUL. Also added a new view VIEW_ACCRUL for use from ACCRUL.
--                I was also forced to add a nvl check on contract in Get_Charge_Type_Desc because
--                ACCRUL can only handle one of our keys on method Get_Control_Type_Value_Desc.
--  990924  DaZa  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Validate_Charge_And_Cost___
--   Validates the use of charge and cost in amount and percentage forms.
PROCEDURE Validate_Charge_And_Cost___ (
   newrec_ IN SALES_CHARGE_TYPE_TAB%ROWTYPE )
IS
BEGIN
   IF (newrec_.unit_charge = 'TRUE') THEN
      IF (newrec_.sales_chg_type_category = 'PROMOTION') THEN
         Error_SYS.Record_General(lu_name_, 'PROMOUNITCH: Unit charge cannot be used when Charge Type Category is set to Promotion.');
      END IF;
   END IF;
   IF (newrec_.charge_cost IS NULL AND newrec_.charge_cost_percent IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'NULL_COST_ERR: Either Charge Cost or Charge Cost % must have a value.');
   END IF;
   IF (newrec_.charge_cost IS NOT NULL AND newrec_.charge_cost_percent IS NOT NULL) THEN
      Error_SYS.Record_General(lu_name_, 'BOTH_COST_ERR: Both Charge Cost and Charge Cost % cannot have values at the same time.');
   END IF;
   IF (newrec_.charge IS NOT NULL AND newrec_.charge_amount IS NOT NULL) THEN
      Error_SYS.Record_General(lu_name_, 'BOTH_CHARGE_ERR: Both Charge Price and Charge % cannot have values at the same time.');
   END IF;
   IF (newrec_.charge_amount != 0 AND newrec_.sales_chg_type_category = 'PROMOTION') THEN
      Error_SYS.Record_General(lu_name_, 'CHARGEPROMO: Charge Price must be 0 when Charge Type Category is set to Promotion.');
   END IF;
   IF (newrec_.charge_cost != 0 AND newrec_.sales_chg_type_category = 'PROMOTION') THEN
      Error_SYS.Record_General(lu_name_, 'CHARGECOSTPROMO: Charge Cost must be zero when Charge Type Category is set to Promotion.');
   END IF;
   IF (newrec_.charge_cost_percent IS NOT NULL AND newrec_.sales_chg_type_category = 'PROMOTION') THEN
      Error_SYS.Record_General(lu_name_, 'CHARGECOSTPERCPROMO: Charge Cost Percentage must be empty when Charge Type Category is set to Promotion.');
   END IF;
   IF (newrec_.charge IS NOT NULL AND newrec_.sales_chg_type_category = 'PROMOTION') THEN
      Error_SYS.Record_General(lu_name_, 'CHARGEPRICEPERCPROMO: Charge Price Percentage must be empty when Charge Type Category is set to Promotion.');
   END IF;
   IF newrec_.sales_chg_type_category = 'PROMOTION' OR newrec_.sales_chg_type_category = 'PACK_SIZE' THEN
      IF newrec_.taxable = Fnd_Boolean_API.DB_FALSE THEN
         Error_SYS.Record_General(lu_name_, 'PROMOPACKSTAXABLE: IF Sales Charge Type is connected to a group with category Promotion or Pack Size, taxable must be checked.');
      END IF;
   END IF;
END Validate_Charge_And_Cost___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
   company_       SALES_CHARGE_TYPE_TAB.company%TYPE;
   contract_      SALES_CHARGE_TYPE_TAB.contract%TYPE;
   tax_code_      SALES_CHARGE_TYPE_TAB.tax_code%TYPE;
   taxable_db_    VARCHAR2(15);
BEGIN
   super(attr_);
   
   contract_      := User_Default_API.Get_Contract;
   company_       := Site_API.Get_Company(contract_);
   
   Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_);
   Client_SYS.Add_To_Attr('COMPANY', company_, attr_);
   Client_SYS.Add_To_Attr('PRINT_CHARGE_TYPE_DB', 'N', attr_);
   Client_SYS.Add_To_Attr('PRINT_COLLECT_CHARGE_DB', 'NO PRINT', attr_);
   Client_SYS.Add_To_Attr('INTRASTAT_EXEMPT_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('UNIT_CHARGE_DB', 'FALSE', attr_);
   
   Tax_Handling_Order_Util_API.Get_Tax_Info_For_Sales_Object(tax_code_, taxable_db_, company_);
   Client_SYS.Add_To_Attr('TAXABLE_DB', taxable_db_, attr_);

   IF (tax_code_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('TAX_CODE', tax_code_, attr_);
   END IF;
   Client_SYS.Add_To_Attr('USE_PRICE_INCL_TAX_DB', Site_Discom_Info_API.Get_Use_Price_Incl_Tax_Ord_Db(contract_),attr_);
END Prepare_Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT sales_charge_type_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS 
   tax_types_event_ VARCHAR2(20):= 'RESTRICTED';
BEGIN
   IF (NOT indrec_.taxable) THEN
      newrec_.taxable              := Fnd_Boolean_API.DB_FALSE;
   END IF;   
   IF (NOT indrec_.print_charge_type) THEN
      newrec_.print_charge_type    := 'N';
   END IF;    
   IF (NOT indrec_.print_collect_charge) THEN
      newrec_.print_collect_charge := 'NO PRINT';
   END IF;
   -- fetch company for old clients that don't have company in them   
   IF (NOT indrec_.company AND newrec_.company IS NULL) THEN      
      newrec_.company := Site_API.Get_Company(newrec_.contract);
   END IF;   
   IF (newrec_.sales_chg_type_category = 'PACK_SIZE') THEN
      newrec_.unit_charge := 'TRUE';
   END IF;

   super(newrec_, indrec_, attr_);

   IF ((newrec_.charge_amount IS NULL OR newrec_.charge_amount_incl_tax IS NULL) AND newrec_.charge IS NULL) THEN
      newrec_.charge_amount          := 0;
      newrec_.charge_amount_incl_tax := 0;
      Client_SYS.Add_To_Attr('CHARGE_AMOUNT',          newrec_.charge_amount,          attr_);
      Client_SYS.Add_To_Attr('CHARGE_AMOUNT_INCL_TAX', newrec_.charge_amount_incl_tax, attr_);
   END IF;
   IF (newrec_.charge_cost IS NULL AND newrec_.charge_cost_percent IS NULL) THEN
      newrec_.charge_cost := 0;
      Client_SYS.Add_To_Attr('CHARGE_COST', newrec_.charge_cost , attr_);
   END IF;
   
   IF (newrec_.charge IS NOT NULL AND newrec_.use_price_incl_tax = 'TRUE') THEN
      Error_SYS.Record_General(lu_name_,'CHARGEPERVALIDATE: You cannot use the price including tax and the charge percentage at the same time.');
   END IF;

   Validate_Charge_And_Cost___(newrec_);
   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, newrec_.contract);

   IF (newrec_.sales_chg_type_category NOT IN ('PACK_SIZE', 'PROMOTION')) THEN
      Tax_Handling_Util_API.Validate_Tax_On_Object(newrec_.company, tax_types_event_, newrec_.tax_code , newrec_.taxable, newrec_.tax_class_id, newrec_.charge_type, SYSDATE, 'CUSTOMER_TAX');
   END IF;   
   Tax_Handling_Order_Util_API.Validate_Tax_For_Charge_Type(newrec_.company, newrec_.tax_code, newrec_.sales_chg_type_category);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     sales_charge_type_tab%ROWTYPE,
   newrec_ IN OUT sales_charge_type_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS 
   tax_types_event_ VARCHAR2(20):= 'RESTRICTED';
BEGIN   
   -- fetch company for old clients that don't have company in them
   IF (NOT indrec_.company AND newrec_.company IS NULL) THEN
      newrec_.company := Site_API.Get_Company(newrec_.contract);
   END IF;

   super(oldrec_, newrec_, indrec_, attr_);
   
   IF (newrec_.unit_charge != oldrec_.unit_charge) THEN
      IF (newrec_.unit_charge = 'TRUE') THEN
         --Unit charge has been activated, but if the charge is already connected to a customer that is not allowed
         IF (Customer_Charge_API.Is_Charge_Type_Assigned(newrec_.contract, newrec_.charge_type) = 'TRUE') THEN
            Error_SYS.Record_General(lu_name_,'USED_BY_CUSTOMER: Unit Charge is not allowed when the charge type is assigned to one or more customers.');
         END IF;
      ELSIF newrec_.sales_chg_type_category = 'PACK_SIZE' THEN
         Error_SYS.Record_General(lu_name_, 'PACK_SIZE_CHG_TYPE: Unit Charge is not allowed to change when the Charge Type Category is Pack Size.');
      END IF;
   END IF;
   
   IF (oldrec_.charge_group != newrec_.charge_group) THEN
      IF (oldrec_.sales_chg_type_category != Sales_Charge_Group_API.Get_Sales_Chg_Type_Category_Db(newrec_.charge_group))THEN
         Error_SYS.Record_General(lu_name_,'CHGCATNOTUPDATE: It is not allowed to change to a Charge Group that belongs to a different Charge Type Category.');
      END IF;
   END IF;
   
   IF ((newrec_.charge_amount IS NULL OR newrec_.charge_amount_incl_tax IS NULL) AND newrec_.charge IS NULL) THEN
      newrec_.charge_amount          := 0;
      newrec_.charge_amount_incl_tax := 0;
      Client_SYS.Add_To_Attr('CHARGE_AMOUNT',          newrec_.charge_amount,          attr_);
      Client_SYS.Add_To_Attr('CHARGE_AMOUNT_INCL_TAX', newrec_.charge_amount_incl_tax, attr_);
   END IF;
   IF (newrec_.charge_cost IS NULL AND newrec_.charge_cost_percent IS NULL) THEN
      newrec_.charge_cost := 0;
      Client_SYS.Add_To_Attr('CHARGE_COST', newrec_.charge_cost , attr_);
   END IF;
   IF (newrec_.charge IS NOT NULL AND newrec_.use_price_incl_tax = 'TRUE') THEN
      Error_SYS.Record_General(lu_name_,'CHARGEPERVALIDATE: You cannot use the price including tax and the charge percentage at the same time.');
   END IF;
   IF (newrec_.tax_code != oldrec_.tax_code) THEN
      Customer_Charge_API.Modify_Charge_Amounts(newrec_.contract, newrec_.charge_type, newrec_.tax_code);
      Sales_Part_Charge_API.Modify_Charge_Amounts(newrec_.contract, newrec_.charge_type, newrec_.tax_code);
   END IF;
   
   Validate_Charge_And_Cost___(newrec_);
   IF (newrec_.sales_chg_type_category NOT IN ('PACK_SIZE', 'PROMOTION')) THEN
      Tax_Handling_Util_API.Validate_Tax_On_Object(newrec_.company, tax_types_event_, newrec_.tax_code, newrec_.taxable, newrec_.tax_class_id, newrec_.charge_type, SYSDATE, 'CUSTOMER_TAX');
   END IF; 
   Tax_Handling_Order_Util_API.Validate_Tax_For_Charge_Type(newrec_.company, newrec_.tax_code, newrec_.sales_chg_type_category);

END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Check_Delivery_Type__
--   Checks if delivery_type exists. If found, print an error message.
--   Used for restricted delete check when removing delivery_type (INVOIC-module).
PROCEDURE Check_Delivery_Type__ (
   key_list_ IN VARCHAR2 )
IS
   company_       VARCHAR2(20);
   delivery_type_ SALES_CHARGE_TYPE_TAB.delivery_type%TYPE;
   found_         NUMBER;
   
   CURSOR exist_control IS
      SELECT 1
      FROM   SALES_CHARGE_TYPE_TAB
      WHERE  Site_API.Get_Company(contract) = company_
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
      Error_SYS.Record_General(lu_name_, 'NO_DEL_TYPE: Delivery Type :P1 exists on one or several Sales Charge Type(s)', delivery_type_ );
   END IF;
END Check_Delivery_Type__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Control_Type_Value_Desc
--   This method is used by ACCRUL
PROCEDURE Get_Control_Type_Value_Desc (
   desc_    OUT VARCHAR2,
   company_ IN  VARCHAR2,
   value_   IN  VARCHAR2 )
IS
   contract_    SALES_CHARGE_TYPE_TAB.contract%TYPE;
   charge_type_ SALES_CHARGE_TYPE_TAB.charge_type%TYPE;
   pos_         NUMBER;
   search_str_  VARCHAR2(3);
BEGIN

   search_str_ := CHR(32)||'|'||CHR(32);
   pos_  := instr(value_, search_str_, 1, 1);
   IF pos_ > 0 THEN
      contract_ := substr(value_, 1, pos_-1);
      charge_type_ := substr(value_, pos_+3);
      IF (contract_ IS NOT NULL AND charge_type_ IS NOT NULL) THEN
         desc_ := Get_Charge_Type_Desc(contract_, charge_type_);
      END IF;
   END IF;
END Get_Control_Type_Value_Desc;


-- Sale_Charge_Exist_Posting_Ctrl
--   This method checks whether the charge type exists for the given site
--   and if so return true. Otherwise an error is raised.
PROCEDURE Sale_Charge_Exist_Posting_Ctrl (
   charge_type_with_contract_ IN VARCHAR2 )
IS
   charge_type_   SALES_CHARGE_TYPE_TAB.charge_type%TYPE;
   contract_      SALES_CHARGE_TYPE_TAB.contract%TYPE;
   pos_           NUMBER;
   search_str_    VARCHAR2(3);
BEGIN
   -- This procedure is called from Posting_Ctrl_Detail_API.
   search_str_ := CHR(32)||'|'||CHR(32);
   pos_  := instr(charge_type_with_contract_, search_str_, 1, 1);
   contract_ := substr(charge_type_with_contract_, 1, pos_-1);
   charge_type_ := substr(charge_type_with_contract_, pos_+3);
   Exist(contract_, charge_type_);
END Sale_Charge_Exist_Posting_Ctrl;


-- Get_Charge_Group_Desc
--   This will return the Charge Group Descriptions
@UncheckedAccess
FUNCTION Get_Charge_Group_Desc (
   contract_    IN VARCHAR2,
   charge_type_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Sales_Charge_Group_API.Get_Charge_Group_Desc(Sales_Charge_Type_API.Get_Charge_Group(contract_, charge_type_));
END Get_Charge_Group_Desc;


-- Get_Currency_Code
--   This will return Company's currency code
@UncheckedAccess
FUNCTION Get_Currency_Code (
   contract_    IN VARCHAR2,
   charge_type_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Company_Finance_API.Get_Currency_Code(Sales_Charge_Type_API.Get_Company(contract_, charge_type_));
END Get_Currency_Code;


-- Check_Exist
--   Returns TRUE if the specified charge exists.
@UncheckedAccess
FUNCTION Check_Exist (
   contract_    IN VARCHAR2,
   charge_type_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (Check_Exist___(contract_, charge_type_)) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Check_Exist;


-- Copy_Charge_Type
--   Copies an Existing Sales Charge Type to a new site.
PROCEDURE Copy_Charge_Type (
   charge_type_      IN VARCHAR2,
   from_contract_    IN VARCHAR2,
   to_contract_      IN VARCHAR2 )
IS
   newrec_                  SALES_CHARGE_TYPE_TAB%ROWTYPE;

   CURSOR get_attr IS
      SELECT *
      FROM SALES_CHARGE_TYPE_TAB
      WHERE charge_type = charge_type_
      AND   contract = from_contract_;

BEGIN

   -- Check whether charge type exist
   IF (NOT Check_Exist___(from_contract_, charge_type_)) THEN
      Error_SYS.Record_General(lu_name_, 'NOCHARGEEXIST: Sales Charge Type :P1 does not exist for site :P2.', charge_type_, from_contract_);
   END IF;

   -- select from Sales Charge Type
   OPEN get_attr;
   FETCH get_attr INTO newrec_;
   CLOSE get_attr;
   
   newrec_.contract := to_contract_;  
   New___(newrec_);

   -- Copy all rows on sales_charge_type_desc_tab.
   Sales_Charge_Type_Desc_API.Copy_Chg_Type_Desc(charge_type_, from_contract_, to_contract_);

END Copy_Charge_Type;


-- Exist
--   Checks if given pointer (e.g. primary key) to an instance of this
--   logical unit exists. If not an exception will be raised.
--   Used by ACCRUL
--   This method is used by ACCRUL
@UncheckedAccess
PROCEDURE Exist (
   charge_type_ IN VARCHAR2 )
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   SALES_CHARGE_TYPE_TAB
      WHERE charge_type = charge_type_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%NOTFOUND) THEN
      CLOSE exist_control;
      Error_SYS.Record_Not_Exist(lu_name_);
   END IF;
   CLOSE exist_control;
END Exist;



