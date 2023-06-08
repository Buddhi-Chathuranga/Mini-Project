-----------------------------------------------------------------------------
--
--  Logical unit: CustomerCharge
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign     History
--  ------  ------   ---------------------------------------------------------
--  150813  Wahelk  BLU-1192, Modified Copy_Customer method to add new parameter copy_info_
--  141107  MaRalk   PRSC-3112, Removed parameter convert_customer_ from Copy_Customer method.
--  140710  MaIklk   PRSC-1761, Implemented to skip copy records if customer is converting.
--  140415  JanWse   PBSC-8348, Set ROWKEY to NULL before inserting in Copy_Customer
--  140408  MaIklk   PBSC-8044, Added Check_Customer_No_Ref___().
--  140224  SudJlk   Bug 111497, Modified Unpack_Check_Insert___, Unpack_Check_Update___ and Check_Delete___ to check if the record belongs to a user allowed site. 
--  140224           Modified Copy_Customer by selecting records for user allowed sites only to be copied to avoid user allowed restriction error. 
--  120802  SURBLK   Modified Get_Default_Charges() by adding charge_amount_incl_tax and charge_amount_incl_tax_base into 'get_charges' cursor.
--  120626  HImRlk   Added new public method Modify_Charge_Amounts()
--  120622  ShKolk   Added new column charge_amount_incl_tax.
--  110131  Nekolk   EANE-3744  added where clause to View CUSTOMER_CHARGE_ENT.
--  100514  Ajpelk   Merge rose merthod documentation
------------------------------Eagle------------------------------------------
--  090131  MaRalk   Bug 79753, Added column CHARGE_COST to the views CUSTOMER_CHARGE and CUSTOMER_CHARGE_ENT.
--  090131           Modified methods Insert___, Update___, Unpack_Check_Insert___ and Unpack_Check_Update___ accordingly.  
--  090131           Added function Get_Charge_Cost and modified cursor get_attr in function Get.
--  090131           Modified cursor get_charges in Get_Default_Charges method. 
--  ------  ----     -------------------------------------------------------
--  090813  HimRlk   Modified Unpack_Check_Insert___ to give an error message if sales_chg_type_category_db_ is not equal to Other.
--  090406  KiSalk   Addded attributes charge, charge_cost, charge_cost_percent; methods Validate_Charge_And_Cost___, Get_Charge, Get_Charge_Cost, 
--  090406           Get_Charge_Cost_Percent. Also added 3 qttributes to Customer_Charge_Rec.
--  080604  MiKulk   modified the Unpack_Check_Insert___ not to allow adding unit charges.
--  00605            Also added the method FUNCTION Is_Charge_Type_Assigned
--  --------------------Nice Price------------------------------------------
--  060621  MalLlk   Added INTRASTAT_EXEMPT and INTRASTAT_EXEMPT_DB columnns to CUSTOMER_CHARGE_ENT view
--  060621           Modified Get to include Intrastat_exempt to the cursor get_attr.
--  060621           Modified Get_Default_Charges to include Intrastat_exempt to the cursor get_charges.
--  060621           Modified Prepare_Insert___
--  060524  RaKalk   Modified Get_Default_Charges populate the charge_amount_base field in the Customer_Charge_Table
--  060524           removed pragma from Get_Default_Charges and general sys was added.
--  060517  RaKalk   Removed the COLLECT field from the LU
--  060502   KanGlk   Added Method Get_Default_Charges.
--  060427  KanGlk   Added CUSTOMER_CHARGE_ENT. Modified Key Orders, Unpack_Check_Update___, Prepare_Insert___ and Unpack_Check_Insert___.
--  060425   RaKalk   Added method Copy_Customer
--  060418  KanGlk   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE Customer_Charge_Rec IS RECORD (
   charge_type                   CUSTOMER_CHARGE_TAB.charge_type%TYPE,
   charge_amount                 CUSTOMER_CHARGE_TAB.charge_amount%TYPE,
   charge_amount_incl_tax        CUSTOMER_CHARGE_TAB.charge_amount_incl_tax%TYPE,
   charge                        CUSTOMER_CHARGE_TAB.charge%TYPE,
   charge_amount_base            CUSTOMER_CHARGE_TAB.charge_amount%TYPE,
   charge_amt_incl_tax_base      CUSTOMER_CHARGE_TAB.charge_amount%TYPE,
   charged_qty                   CUSTOMER_CHARGE_TAB.charged_qty%TYPE,
   print_charge_type             CUSTOMER_CHARGE_TAB.print_charge_type%TYPE,
   print_collect_charge          CUSTOMER_CHARGE_TAB.print_collect_charge%TYPE,
   intrastat_exempt              CUSTOMER_CHARGE_TAB.intrastat_exempt%TYPE,
   charge_cost                   CUSTOMER_CHARGE_TAB.charge_cost%TYPE,
   charge_cost_percent           CUSTOMER_CHARGE_TAB.charge_cost_percent%TYPE);

TYPE Customer_Charge_Table IS TABLE OF Customer_Charge_Rec INDEX BY PLS_INTEGER;


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Validate_Charge_And_Cost___ (
   newrec_ IN CUSTOMER_CHARGE_TAB%ROWTYPE )
IS
   use_price_incl_tax_   customer_tax_calc_basis_tab.use_price_incl_tax%TYPE;
BEGIN

   use_price_incl_tax_ := Customer_Tax_Calc_Basis_API.Get_Use_Price_Incl_Tax_Db(newrec_.customer_no, Site_API.Get_Company(newrec_.contract));

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
         Error_SYS.Record_General(lu_name_, 'MULTIPERCENTERR: Charged quantity should be 1 when charge cost or charge price is entered as a percentage.');
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
   newrec_ IN OUT customer_charge_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
   sales_chg_type_category_db_ VARCHAR2(20);
BEGIN
   IF(Client_SYS.Item_Exist('CUSTOMER_ID', attr_)) THEN
      newrec_.customer_no := Client_SYS.Get_Item_Value('CUSTOMER_ID', attr_);      
   END IF;
   IF (Sales_Charge_Type_API.Get_Unit_Charge_Db(newrec_.contract, newrec_.charge_type) = 'TRUE') THEN
      Error_SYS.Record_General(lu_name_, 'UNIT_CHG_NOT_ALLOWED: Charge Type :P1, with Unit Charge can not be assigned to a customer.', newrec_.charge_type);
   END IF;
   sales_chg_type_category_db_ := Sales_Charge_Type_API.Get_Sales_Chg_Type_Category_Db(newrec_.contract, newrec_.charge_type);
   IF (sales_chg_type_category_db_ != 'OTHER') THEN
      Error_SYS.Record_General(lu_name_, 'INVALCHGTYPE: Only charges of the charge type category Other can be entered manually.');
   END IF;
   super(newrec_, indrec_, attr_);
   
   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, newrec_.contract);
   Validate_Charge_And_Cost___(newrec_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     customer_charge_tab%ROWTYPE,
   newrec_ IN OUT customer_charge_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   IF(Client_SYS.Item_Exist('CUSTOMER_ID', attr_)) THEN
      Error_SYS.Item_Update(lu_name_, 'CUSTOMER_NO');
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);
   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, newrec_.contract);
   Validate_Charge_And_Cost___(newrec_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
   END Check_Update___;
   
@Override
PROCEDURE Check_Delete___ (
   remrec_ IN customer_charge_tab%ROWTYPE )
IS
BEGIN
   super(remrec_);
   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, remrec_.contract);
END Check_Delete___;


PROCEDURE Check_Customer_No_Ref___ (
   newrec_ IN OUT customer_charge_tab%ROWTYPE )
IS
   customer_category_         CUSTOMER_INFO_TAB.customer_category%TYPE;
BEGIN
   IF (newrec_.customer_no IS NOT NULL) THEN
      customer_category_  := Customer_Info_API.Get_Customer_Category_Db(newrec_.customer_no);
      Cust_Ord_Customer_API.Exist(newrec_.customer_no, customer_category_);
   END IF;
END Check_Customer_No_Ref___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Copy_Customer
--   Copy the charges of the customer to a new customer
PROCEDURE Copy_Customer (
   customer_no_      IN VARCHAR2,
   new_id_           IN VARCHAR2,
   copy_info_        IN Customer_Info_API.Copy_Param_Info)
IS
   attr_          VARCHAR2(2000);
   objid_         VARCHAR2(100);
   objversion_    VARCHAR2(100);
   indrec_        Indicator_Rec;
   
   CURSOR get_charges IS
      SELECT *
        FROM CUSTOMER_CHARGE_TAB
        WHERE customer_no = customer_no_
        AND EXISTS (SELECT 1 
                    FROM user_allowed_site_pub 
                    WHERE site = contract);
       
BEGIN
  FOR newrec_ IN get_charges LOOP
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('CUSTOMER_NO',new_id_,attr_);
      newrec_.rowkey := NULL;

      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);
   END LOOP;

   Client_SYS.Clear_Info;
END Copy_Customer;


-- Get_Default_Charges
--   This function returns a table of records with all the default
--   charges for a given customer and contract.
FUNCTION Get_Default_Charges (
   customer_no_ IN VARCHAR2,
   contract_    IN VARCHAR2) RETURN Customer_Charge_Table
IS
   charge_tab_    Customer_Charge_Table;
   curr_rate_     NUMBER;
   curr_code_     VARCHAR2(20);
   CURSOR get_charges IS
      SELECT charge_type,
             charge_amount,
             charge_amount_incl_tax,
             charge,
             TO_NUMBER(NULL) charge_amount_base,
             TO_NUMBER(NULL) charge_amount_incl_tax_base,
             charged_qty,
             print_charge_type,
             print_collect_charge,
             intrastat_exempt,
             charge_cost,
             charge_cost_percent
        FROM CUSTOMER_CHARGE_TAB
       WHERE contract     = contract_
         AND customer_no = customer_no_;
BEGIN

   OPEN  get_charges;
   FETCH get_charges BULK COLLECT INTO charge_tab_;
   CLOSE get_charges;

   --Calculate the base price
   IF charge_tab_.COUNT>0 THEN
      curr_code_ := Cust_Ord_Customer_API.Get_Currency_Code(customer_no_);
      FOR i_ IN charge_tab_.FIRST .. charge_tab_.LAST LOOP
        Customer_Order_Pricing_API.Get_Base_Price_In_Currency(charge_tab_(i_).charge_amount_base,
                                                              curr_rate_,
                                                              customer_no_,
                                                              contract_,
                                                              curr_code_,
                                                              charge_tab_(i_).charge_amount);
        
        Customer_Order_Pricing_API.Get_Base_Price_In_Currency(charge_tab_(i_).charge_amt_incl_tax_base,
                                                              curr_rate_,
                                                              customer_no_,
                                                              contract_,
                                                              curr_code_,
                                                              charge_tab_(i_).charge_amount_incl_tax);
      END LOOP;
   END IF;

   RETURN charge_tab_;
END Get_Default_Charges;


-- Is_Charge_Type_Assigned
--   This method will return TRUE if the given charge type is
--   assigned to at least one customer.
@UncheckedAccess
FUNCTION Is_Charge_Type_Assigned (
   contract_ IN VARCHAR2,
   charge_type_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR check_assigned IS
     SELECT 1
     FROM CUSTOMER_CHARGE_TAB
     WHERE contract    = contract_
     AND   charge_type = charge_type_;

  temp_   NUMBER;
  value_  VARCHAR2(5);

BEGIN
   OPEN check_assigned;
   FETCH check_assigned INTO temp_;
   IF check_assigned%FOUND THEN
      value_ := 'TRUE';
   ELSE
      value_ := 'FALSE';
   END IF;
   CLOSE check_assigned;
   RETURN value_;
END Is_Charge_Type_Assigned;


PROCEDURE Modify_Charge_Amounts (
   contract_    IN VARCHAR2,
   charge_type_ IN VARCHAR2,
   fee_code_    IN VARCHAR2)
IS
   charge_amount_          NUMBER;
   charge_amount_incl_tax_ NUMBER;
   fee_rate_               NUMBER;
   use_price_incl_tax_     VARCHAR2(20); 
   company_                VARCHAR2(20);
   attr_                   VARCHAR2(32000) := NULL;
   newrec_                 CUSTOMER_CHARGE_TAB%ROWTYPE;
   oldrec_                 CUSTOMER_CHARGE_TAB%ROWTYPE;
   objid_                  CUSTOMER_CHARGE.objid%TYPE;
   objversion_             CUSTOMER_CHARGE.objversion%TYPE;
   indrec_                 Indicator_Rec;
   CURSOR  get_data IS
      SELECT customer_no, charge_amount, charge_amount_incl_tax 
      FROM  CUSTOMER_CHARGE_TAB 
      WHERE contract    = contract_
      AND   charge_type = charge_type_;
BEGIN
   company_ := Site_API.Get_Company(contract_);
   fee_rate_ := Statutory_Fee_API.Get_Fee_Rate(company_, fee_code_);
   FOR rec_ IN get_data LOOP
      Client_SYS.Clear_Attr(attr_);
      use_price_incl_tax_ := NVL(Customer_Tax_Calc_Basis_API.Get_Use_Price_Incl_Tax_Db(rec_.customer_no, company_),'FALSE');
      IF (use_price_incl_tax_ = 'TRUE') THEN
         charge_amount_ := rec_.charge_amount_incl_tax / ((NVL(fee_rate_,0)/100)+1);
         Client_SYS.Add_To_Attr('CHARGE_AMOUNT', charge_amount_, attr_);
      ELSE
         charge_amount_incl_tax_ := rec_.charge_amount * ((NVL(fee_rate_,0)/100)+1);
         Client_SYS.Add_To_Attr('CHARGE_AMOUNT_INCL_TAX', charge_amount_incl_tax_, attr_);
      END IF;
      Get_Id_Version_By_Keys___(objid_, objversion_ , rec_.customer_no, contract_, charge_type_);
      oldrec_ := Lock_By_Id___( objid_, objversion_);
      newrec_ := oldrec_;
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
      Update___(objid_, oldrec_, newrec_, attr_, objversion_ );
   END LOOP;
END Modify_Charge_Amounts;



