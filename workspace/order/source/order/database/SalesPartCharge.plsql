-----------------------------------------------------------------------------
--
--  Logical unit: SalesPartCharge
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  150917  JeLise  AFT-4772, Added Check_Customer_No_Ref___ to do the correct exist check.
--  120808  SurBlk  Modified Get_Default_Charges by adding charge_amount_incl_tax into get_charges cursor.
--  120626  HimRlk  Added new public method Modify_Charge_Amounts()
--  120606  ShKolk  Added column charge_amount_incl_tax.
--  130104  CPriLK Added the sales_type for Sales_Part_API.Exis()
--  110706  MaMalk  Added user allowed site filteration to the base view.
--  100609  SaJjlk  Bug 91204, Removed the DECODE statement from the CUSTOMER_NO field in select list of base view.
--  091214  MaRalk  Added reference SalesChargeType to the column charge_type in the view SALES_PART_CHARGE
--  091214          and modified Unpack_Check_Insert___. 
--  090131  MaRalk  Bug 79753, Added column CHARGE_COST to the view SALES_PART_CHARGE.
--  090131          Modified methods Insert___, Update___, Unpack_Check_Insert___ and Unpack_Check_Update___ accordingly.
--  090131          Modified cursor get_charges in Get_Default_Charges method.   
--  090131          Added function Get_Charge_Cost and modified cursor get_attr in function Get.
--  090403  KiSalk   Addded attribute charge and method Validate_Charge_And_Cost___.
--  080903  MaJalk  Added error message INVALCHGTYPE to Unpack_Check_Insert___.
--  080603  MiKulk  Modified the method Get_Default_Charges to include the unit_charge.
--  080603  MiKulk  Added a validation not to enter charged quantity greated tan 1 for the unit charge types.
--  080603  Mikulk  Added the public attribute unit_charge to the LU and modified necessary methods.
--  -------------------------Nice Price--------------------------------------
--  060621  MalLlk  Modified Get to include Intrastat_exempt to the cursor get_attr.
--  060621          Modified Get_Default_Charges to include Intrastat_exempt to the cursor get_charges.
--  060621          Modified Prepare_Insert___
--  060517  RaKalk  Removed the COLLECT field from the LU
--  060503  RaKalk  Modified Unpack_Check_Insert___ to call Exist method of Customer LU
--  060503          only when the customer no  is not null
--  060428  SeNslk  Set the Default values.
--  060428  RaKalk  Added Method Get_Default_Charges
--  060419  SeNslk  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE customer_charge_rec IS RECORD (
   charge_type              SALES_PART_CHARGE_TAB.charge_type%TYPE,
   charge_amount            SALES_PART_CHARGE_TAB.charge_amount%TYPE,
   charge_amount_incl_tax   SALES_PART_CHARGE_TAB.charge_amount%TYPE,
   charge                   SALES_PART_CHARGE_TAB.charge%TYPE,
   charged_qty              SALES_PART_CHARGE_TAB.charged_qty%TYPE,
   print_charge_type        SALES_PART_CHARGE_TAB.print_charge_type%TYPE,
   print_collect_charge     SALES_PART_CHARGE_TAB.print_collect_charge%TYPE,
   intrastat_exempt         SALES_PART_CHARGE_TAB.intrastat_exempt%TYPE,
   unit_charge              SALES_PART_CHARGE_TAB.unit_charge%TYPE,
   charge_cost              SALES_PART_CHARGE_TAB.charge_cost%TYPE,
   charge_cost_percent      SALES_PART_CHARGE_TAB.charge_cost_percent%TYPE);

TYPE Sales_Part_Charge_Table IS TABLE OF customer_charge_rec INDEX BY PLS_INTEGER;


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Validate_Charge_And_Cost___ (
   newrec_ IN SALES_PART_CHARGE_TAB%ROWTYPE )
IS
   use_price_incl_tax_   sales_part_tab.use_price_incl_tax%TYPE;
BEGIN

   use_price_incl_tax_ := Sales_Part_API.Get_Use_Price_Incl_Tax_Db(newrec_.contract, newrec_.catalog_no);

   IF (newrec_.charge IS NULL AND newrec_.charge_amount IS NULL AND newrec_.charge_amount_incl_tax IS NULL) THEN
      IF use_price_incl_tax_ = 'TRUE' THEN
         Error_SYS.Record_General(lu_name_, 'NULL_CHAR_ERR_INCL_TAX: Either the charge price including tax or the charge percentage must have a value.');
      ELSE  
         Error_SYS.Record_General(lu_name_, 'NULL_CHAR_ERR: Either the charge price or the charge percentage must have a value.');
      END IF;
   END IF;
   IF (newrec_.charge IS NOT NULL AND newrec_.charge_amount IS NOT NULL AND newrec_.charge_amount_incl_tax IS NOT NULL) THEN
      IF use_price_incl_tax_ = 'TRUE' THEN
         Error_SYS.Record_General(lu_name_, 'BOTH_CHARGE_ERR_INCL_TAX: Both the charge price including tax and the charge percentage cannot have values at the same time.');
      ELSE
         Error_SYS.Record_General(lu_name_, 'BOTH_CHARGE_ERR: Both the charge price and the charge percentage cannot have values at the same time.');
      END IF;
   END IF;

   IF (newrec_.charge_cost IS NULL AND newrec_.charge_cost_percent IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'NULL_COST_ERR: Either Charge Cost or Charge Cost % must have a value.');
   END IF;
   IF (newrec_.charge_cost IS NOT NULL AND newrec_.charge_cost_percent IS NOT NULL) THEN
      Error_SYS.Record_General(lu_name_, 'BOTH_COST_ERR: Both Charge Cost and Charge Cost % cannot have values at the same time.');
   END IF;
   IF (newrec_.charged_qty != 1) THEN
      IF (NVL(newrec_.charge, 0) != 0 OR NVL(newrec_.charge_cost_percent, 0) != 0) THEN
         Error_SYS.Record_General(lu_name_, 'MULTIPERCENTUNIERR: Charged quantity should be 1 when charge cost or charge price is entered as a percentage.');
      END IF;
   END IF;
END Validate_Charge_And_Cost___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('CHARGED_QTY', 1, attr_);
   Client_SYS.Add_To_Attr('PRINT_COLLECT_CHARGE_DB', 'NO PRINT', attr_);
   Client_SYS.Add_To_Attr('PRINT_CHARGE_TYPE_DB', 'N', attr_);
   Client_SYS.Add_To_Attr('INTRASTAT_EXEMPT_DB', 'FALSE', attr_);
END Prepare_Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT sales_part_charge_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   sales_chg_type_category_db_ VARCHAR2(20); 
BEGIN
   Sales_Part_API.Exist(newrec_.contract, newrec_.catalog_no, Sales_Type_API.DB_SALES_AND_RENTAL);
   
   IF (newrec_.customer_no IS NULL) THEN
      newrec_.customer_no := '*';
   END IF;

   -- For unit charges can only have 1 charged qty
   IF (newrec_.unit_charge = 'TRUE') AND (newrec_.charged_qty !=1)  THEN
      Error_SYS.Record_General(lu_name_, 'UNIT_CHARGE_SELECTED: Charged quantity should be 1 when unit charge is selected.');
   END IF;

   sales_chg_type_category_db_ := Sales_Charge_Type_API.Get_Sales_Chg_Type_Category_Db(newrec_.contract, newrec_.charge_type);
   IF (sales_chg_type_category_db_ != 'OTHER') THEN
      Error_SYS.Record_General(lu_name_, 'INVALCHGTYPE: Charge Type :P1, with Charge Type Category :P2 can not be assigned to Sales Part.',newrec_.charge_type, Sales_Chg_Type_Category_API.Decode(sales_chg_type_category_db_));
   END IF;

   super(newrec_, indrec_, attr_);
   
   Validate_Charge_And_Cost___(newrec_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     sales_part_charge_tab%ROWTYPE,
   newrec_ IN OUT sales_part_charge_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
    -- For unit charges can only have 1 charged qty
   IF (newrec_.unit_charge = 'TRUE') AND (newrec_.charged_qty !=1)  THEN
      Error_SYS.Record_General(lu_name_, 'UNIT_CHARGE_SELECTED: Charged quantity should be 1 when unit charge is selected.');
   END IF;
   
   super(oldrec_, newrec_, indrec_, attr_);
   
   Validate_Charge_And_Cost___(newrec_);
END Check_Update___;


PROCEDURE Check_Customer_No_Ref___ (
   newrec_ IN OUT sales_part_charge_tab%ROWTYPE )
IS
   customer_category_ CUSTOMER_INFO_TAB.customer_category%TYPE;
BEGIN
   IF (newrec_.customer_no IS NOT NULL) THEN
      customer_category_ := Customer_Info_API.Get_Customer_Category_Db(newrec_.customer_no);
      Cust_Ord_Customer_API.Exist(newrec_.customer_no, customer_category_);
   END IF;
END Check_Customer_No_Ref___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Default_Charges (
   customer_no_   IN VARCHAR2,
   sales_part_no_ IN VARCHAR2,
   contract_      IN VARCHAR2 ) RETURN Sales_Part_Charge_Table
IS
   charge_tab_ Sales_Part_Charge_Table;

   CURSOR get_charges IS
      SELECT charge_type,
             charge_amount,
             charge_amount_incl_tax,
             charge,
             charged_qty,
             print_charge_type,
             print_collect_charge,
             intrastat_exempt,
             unit_charge,
             charge_cost,
             charge_cost_percent
        FROM SALES_PART_CHARGE_TAB
       WHERE catalog_no   = sales_part_no_
         AND contract     = contract_
         AND (customer_no = '*' OR customer_no = customer_no_);
BEGIN
   OPEN  get_charges;
   FETCH get_charges BULK COLLECT INTO charge_tab_;
   CLOSE get_charges;

   RETURN charge_tab_;
END Get_Default_Charges;

@UncheckedAccess
FUNCTION Get_Total_Charge_Base(
   charge_amount_ IN NUMBER,
   charged_qty_   IN NUMBER,
   contract_      IN VARCHAR2 ) RETURN NUMBER
IS
   rounding_ NUMBER;
BEGIN
   rounding_ := Currency_Code_API.Get_Currency_Rounding(Site_API.Get_Company(contract_), Company_Finance_API.Get_Currency_Code(Site_API.Get_Company(contract_))); 
   RETURN ROUND((charge_amount_ * charged_qty_), rounding_);
END Get_Total_Charge_Base;

PROCEDURE Modify_Charge_Amounts (
   contract_    IN VARCHAR2,
   charge_type_ IN VARCHAR2,
   fee_code_    IN VARCHAR2 )
IS
   charge_amount_          NUMBER;
   charge_amount_incl_tax_ NUMBER;
   fee_rate_               NUMBER;
   company_                VARCHAR2(20);
   attr_                   VARCHAR2(32000) := NULL;
   newrec_                 SALES_PART_CHARGE_TAB%ROWTYPE;
   oldrec_                 SALES_PART_CHARGE_TAB%ROWTYPE;
   objid_                  SALES_PART_CHARGE.objid%TYPE;
   objversion_             SALES_PART_CHARGE.objversion%TYPE;
   indrec_                 Indicator_Rec;
   CURSOR  get_data IS
      SELECT t.customer_no, t.catalog_no, t.charge_amount, t.charge_amount_incl_tax, s.use_price_incl_tax  
      FROM  SALES_PART_CHARGE_TAB t , sales_part_tab s 
      WHERE t.contract    = contract_
      AND   t.charge_type = charge_type_
      AND   t.contract    = s.contract
      AND   t.catalog_no  = s.catalog_no;
BEGIN
   company_ := Site_API.Get_Company(contract_);
   fee_rate_ := Statutory_Fee_API.Get_Fee_Rate(company_, fee_code_);
   FOR rec_ IN get_data LOOP
      Client_SYS.Clear_Attr(attr_);
      IF (rec_.use_price_incl_tax = 'TRUE') THEN
         charge_amount_ := rec_.charge_amount_incl_tax / ((NVL(fee_rate_,0)/100)+1);
         Client_SYS.Add_To_Attr('CHARGE_AMOUNT', charge_amount_, attr_);
      ELSE
         charge_amount_incl_tax_ := rec_.charge_amount * ((NVL(fee_rate_,0)/100)+1);
         Client_SYS.Add_To_Attr('CHARGE_AMOUNT_INCL_TAX', charge_amount_incl_tax_, attr_);
      END IF;
      Get_Id_Version_By_Keys___(objid_, objversion_ , contract_, rec_.catalog_no, charge_type_, rec_.customer_no);
      oldrec_ := Lock_By_Id___( objid_, objversion_);
      newrec_ := oldrec_;
      Unpack___(newrec_, indrec_, attr_); 
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
      Update___(objid_, oldrec_, newrec_, attr_, objversion_ );
   END LOOP;
END Modify_Charge_Amounts;



