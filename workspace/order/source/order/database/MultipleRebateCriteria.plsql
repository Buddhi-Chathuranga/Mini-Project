-----------------------------------------------------------------------------
--
--  Logical unit: MultipleRebateCriteria
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210111  RavDlk  SC2020R1-12024,Removed unnecessary packing and unpacking of attrubute string in Set_Default_Values
--  170506  ThImlk  STRMF-11262, Modified Get_Customer_Agr_Selection() to correctly fetch the multiple rebate criteria defined for the company.
--  170506  ThImlk  STRMF-11477, Added Check_Customer_No_Ref___() to avoid errors when entering records to order tab of the customer form for Prospect category customers.
--  170328  ThImlk  LIM-11246, Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
PROCEDURE Check_Customer_No_Ref___ (
   newrec_ IN OUT NOCOPY multiple_rebate_criteria_tab%ROWTYPE )
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
PROCEDURE Set_Default_Values(to_customer_no_ IN VARCHAR2 )
IS
   newrec_       MULTIPLE_REBATE_CRITERIA_TAB%ROWTYPE;
BEGIN
   newrec_.customer_no         := to_customer_no_;
   newrec_.company             := '*';
   newrec_.agreement_selection := Agreement_Selection_API.DB_AGREEMENT_PRIORITY;
   newrec_.rowversion          := sysdate;
   New___(newrec_);

END Set_Default_Values;

FUNCTION Get_Customer_Agr_Selection (
   customer_no_ IN VARCHAR2,
   company_ IN VARCHAR2 ) RETURN multiple_rebate_criteria_tab.agreement_selection%TYPE
IS
   agr_selection_ VARCHAR2(20);
   
   CURSOR get_agreement_selection IS
	   SELECT agreement_selection
   	  FROM  multiple_rebate_criteria_tab
       WHERE customer_no = customer_no_
         AND company = '*';        
BEGIN   
   agr_selection_ := Get_Agreement_Selection_Db(customer_no_, company_);   
   IF (agr_selection_ IS NULL) THEN
      OPEN get_agreement_selection;
      FETCH get_agreement_selection INTO agr_selection_;
      CLOSE get_agreement_selection;
   END IF;
   RETURN agr_selection_;   

END Get_Customer_Agr_Selection;
