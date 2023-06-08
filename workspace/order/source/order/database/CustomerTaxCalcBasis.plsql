-----------------------------------------------------------------------------
--
--  Logical unit: CustomerTaxCalcBasis
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  170206  KiSalk  Bug 134054, Added annotation DbCheckImplementation "custom" to CustomerNoRef in entity; written the method
--  170206          Check_Customer_No_Ref___ to allow adding records when Customer Category is not "CUSTOMER".
--  160601  MAHPLK  FINHR-2018, Removed Validate_Tax_Calc_Basis___.
--  150813  Wahelk  BLU-1192, Modified Copy_Customer method to add new parameter copy_info_
--  140415  JanWse  PBSC-8348, Set ROWKEY to NULL before inserting in Copy_Customer
--  140228  SURBLK  Changed Company_Distribution_Info_API.Get_Use_Price_Incl_Tax_Db into Company_Order_Info_API.Get_Use_Price_Incl_Tax_Db.
--  131023  ShKolk  Added NVL function to get use_price_incl_tax from Company.
--  130318  HimRlk  Added public New method.
--  120620  ShKolk  Added method Copy_Customer.
--  120612  ShKolk  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Check_Customer_No_Ref___ (
   newrec_ IN OUT NOCOPY customer_tax_calc_basis_tab%ROWTYPE )
IS
   customer_category_ CUSTOMER_INFO_TAB.customer_category%TYPE;
BEGIN
   IF (newrec_.customer_no IS NOT NULL) THEN
      customer_category_ := Customer_Info_API.Get_Customer_Category_Db(newrec_.customer_no);
      IF customer_category_ = Customer_Category_API.DB_CUSTOMER THEN
         Cust_Ord_Customer_API.Exist(newrec_.customer_no);
      ELSE
         Customer_Info_API.Exist(newrec_.customer_no, customer_category_);
      END IF;
   END IF;
END Check_Customer_No_Ref___;
-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@Override
FUNCTION Get_Use_Price_Incl_Tax (
   customer_no_ IN VARCHAR2,
   company_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   --Add pre-processing code here
   RETURN Nvl(super(customer_no_, company_), Fnd_Boolean_API.Decode(Company_Tax_Discom_Info_API.Get_Use_Price_Incl_Tax_Ord_Db(company_)));
END Get_Use_Price_Incl_Tax;


@Override
FUNCTION Get_Use_Price_Incl_Tax_Db (
   customer_no_ IN VARCHAR2,
   company_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   --Add pre-processing code here
   RETURN Nvl(super(customer_no_, company_), Company_Tax_Discom_Info_API.Get_Use_Price_Incl_Tax_Ord_Db(company_));
END Get_Use_Price_Incl_Tax_Db;

-- Copy_Customer
--   The function Copy_Customer Copies the customer information in
--   Customer_Tax_Calc_Basis_Tab to a new customer id
PROCEDURE Copy_Customer (
   customer_no_     IN VARCHAR2,
   new_customer_no_ IN VARCHAR2,
   copy_info_       IN  Customer_Info_API.Copy_Param_Info)
IS
   objid_        VARCHAR2(100);
   objversion_   VARCHAR2(2000);
   attr_         VARCHAR2(32000);
   indrec_       Indicator_Rec;
   
   CURSOR get_attr IS
      SELECT *
      FROM CUSTOMER_TAX_CALC_BASIS_TAB
      WHERE customer_no = customer_no_;
BEGIN

   FOR newrec_ IN get_attr LOOP
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('CUSTOMER_NO', new_customer_no_, attr_);
      newrec_.rowkey := NULL;

      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);
   END LOOP;

   Client_SYS.Clear_Info;
END Copy_Customer;


-- New
--   Public interface for creating a new customer order tax calculation basis.
PROCEDURE New (
   info_ OUT    VARCHAR2,
   attr_ IN OUT VARCHAR2 )
IS
   ptr_        NUMBER := NULL;
   newrec_     CUSTOMER_TAX_CALC_BASIS_TAB%ROWTYPE;
   name_       VARCHAR2(30);
   new_attr_   VARCHAR2(2000);
   value_      VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN
    -- Retrieve default attribute values.
   Prepare_Insert___(new_attr_);
   --Replace the default attribute values with the ones passed in the inparameter string.
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      Client_SYS.Set_Item_Value(name_, value_, new_attr_);
   END LOOP;
   
   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, new_attr_);

   info_ := Client_SYS.Get_All_Info;
   attr_ := new_attr_;
END New;



