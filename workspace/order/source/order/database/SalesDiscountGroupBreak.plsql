-----------------------------------------------------------------------------
--
--  Logical unit: SalesDiscountGroupBreak
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  140423  ShKolk  Added nullable number column order_total_incl_tax.
--  060119  MaHplk  Replace 'SELECT &OBJID INTO....' statement with RETURNING &OBJID INTO objid_.
--  050922  NaLrlk  Removed unused variables.
--  030804  ChFolk  Performed SP4 Merge. (SP4Only)
--  030203  ThJalk  Bug 35536, Called User_Finance_Api.Get_Default_Company in Procedure Insert___
--  981208  JoEd    Changed column comment for order_total.
--  980210  ToOs    Changed format on amount columns
--  971125  TOOS    Upgrade to F1 2.0
--  970312  NABE    Changed Table Name OE_DISCOUNT_TAB to
--                  SALES_DISCOUNT_GROUP_BREAK_TAB
--  970218  RaKu    Changed rowversion (10.3 Project).
--  960213  RAKU    Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('ORDER_TOTAL', 0, attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT SALES_DISCOUNT_GROUP_BREAK_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   company_           VARCHAR2(20);
   currency_code_     VARCHAR2(3);
   currency_rounding_ NUMBER;
BEGIN
   User_Finance_Api.Get_Default_Company(company_);
   currency_code_      := Company_Finance_API.Get_Currency_Code(company_);
   currency_rounding_  := Currency_Code_API.Get_Currency_Rounding(company_, currency_code_);
   newrec_.order_total := ROUND(newrec_.order_total, currency_rounding_);
   super(objid_, objversion_, newrec_, attr_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     SALES_DISCOUNT_GROUP_BREAK_TAB%ROWTYPE,
   newrec_     IN OUT SALES_DISCOUNT_GROUP_BREAK_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   contract_          VARCHAR2(5);
   company_           VARCHAR2(20);
   currency_code_     VARCHAR2(3);
   currency_rounding_ NUMBER;
BEGIN
   contract_           := User_Default_API.Get_Contract;
   company_            := Site_API.Get_Company(contract_);
   currency_code_      := Company_Finance_API.Get_Currency_Code(company_);
   currency_rounding_  := Currency_Code_API.Get_Currency_Rounding(company_, currency_code_);
   newrec_.order_total := ROUND(newrec_.order_total, currency_rounding_);

   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
END Update___;

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     sales_discount_group_break_tab%ROWTYPE,
   newrec_ IN OUT sales_discount_group_break_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN   
   super(oldrec_, newrec_, indrec_, attr_);
   IF (newrec_.discount <= -100) OR (newrec_.discount >= 100) THEN
      Error_SYS.Record_General(lu_name_, 'INVALID_DISCOUNT: Discount must be between -99.99 and 99.99');
   END IF;

   IF (newrec_.order_total < 0) THEN
      Error_SYS.Record_General(lu_name_, 'INVALID_ORDERTOT: The basis minimum value must not be negative.');
   END IF;

   IF (newrec_.order_total_incl_tax < 0) THEN
      Error_SYS.Record_General(lu_name_, 'INVALID_ORDERTOTINCLTAX: The basis minimum value including tax must not be negative.');
   END IF;

   IF (newrec_.order_total > NVL(newrec_.order_total_incl_tax, newrec_.order_total)) THEN
      Error_SYS.Record_General(lu_name_, 'ORDERTOT_GREATERTHAN_INCLTAX: The basis minimum value cannot be greater than the basis minimum value including tax.');
   END IF;
END Check_Common___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


