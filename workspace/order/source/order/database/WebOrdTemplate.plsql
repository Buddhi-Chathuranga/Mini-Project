-----------------------------------------------------------------------------
--
--  Logical unit: WebOrdTemplate
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  100513  KRPELK  Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  060112  MiKulk  Modified the PROCEDURE Insert___ according to the new template.
--  050922  NaLrlk  Removed u used variables.
--  040712  KeFelk  Additional changes due to 43255.
--  040513  ThGuLk  Created. File was moved from SCENTR module to ORDER, calls to 'Dynamic_Support_Issue_API.Get_Site_Date' was replaced with 'Site_API.Get_Site_Date
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- New
--   Inserts Template Head Data.
PROCEDURE New (
   info_ OUT VARCHAR2,
   customer_no_ IN VARCHAR2,
   template_id_ IN VARCHAR2,
   contract_ IN VARCHAR2,
   user_id_ IN VARCHAR2 )
IS
   attr_          VARCHAR2(2000);
   newrec_        WEB_ORD_TEMPLATE_TAB%ROWTYPE;
   objid_         VARCHAR2(2000);
   objversion_    VARCHAR2(2000);
   site_date_     DATE;
   real_template_ VARCHAR2(20);
   template_      VARCHAR2(20);
BEGIN

   newrec_.customer_no := customer_no_;
   site_date_          := Site_API.Get_Site_Date(contract_);
   newrec_.change_date := site_date_;

   template_ := 'id:'||user_id_ ;
   newrec_.template_id := template_;

   IF (Check_Exist___(customer_no_,template_)) THEN
      IF (nvl(template_id_,'*') != template_) THEN
         Web_Ord_Template_Line_API.Remove_Lines(customer_no_,template_);
      END IF;
   ELSE
      Error_SYS.Check_Not_Null(lu_name_, 'CUSTOMER_NO', newrec_.customer_no);
      Error_SYS.Check_Not_Null(lu_name_, 'TEMPLATE_ID', newrec_.template_id);
      Error_SYS.Check_Not_Null(lu_name_, 'CHANGE_DATE', newrec_.change_date);

      Insert___(objid_, objversion_, newrec_, attr_);
      info_ := Client_SYS.Get_All_Info;
   END IF;
   IF (template_id_ IS NOT NULL ) THEN
      IF (template_id_ != template_) THEN
          real_template_ :=template_id_;
          Web_Ord_Template_Line_API.Copy_Parts(customer_no_,real_template_,contract_,user_id_);
      END IF;
   END IF;
END New;


-- Save_Template
--   Saves Template Data.
PROCEDURE Save_Template (
   info_ OUT VARCHAR2,
   customer_no_ IN VARCHAR2,
   template_id_ IN VARCHAR2,
   contract_ IN VARCHAR2,
   user_id_ IN VARCHAR2 )
IS
   attr_          VARCHAR2(2000);
   newrec_        WEB_ORD_TEMPLATE_TAB%ROWTYPE;
   objid_         VARCHAR2(2000);
   objversion_    VARCHAR2(2000);
   site_date_     DATE;
BEGIN

   newrec_.customer_no := customer_no_;
   site_date_          := Site_API.Get_Site_Date(contract_);
   newrec_.change_date := site_date_;

   newrec_.template_id := template_id_;

   IF (Check_Exist___(customer_no_,template_id_)) THEN
      Web_Ord_Template_Line_API.Remove_Lines(customer_no_,template_id_);
   ELSE
      Error_SYS.Check_Not_Null(lu_name_, 'CUSTOMER_NO', newrec_.customer_no);
      Error_SYS.Check_Not_Null(lu_name_, 'TEMPLATE_ID', newrec_.template_id);
      Error_SYS.Check_Not_Null(lu_name_, 'CHANGE_DATE', newrec_.change_date);

      Insert___(objid_, objversion_, newrec_, attr_);
      info_ := Client_SYS.Get_All_Info;
   END IF;
   Web_Ord_Template_Line_API.Copy_Parts_To_Template(customer_no_,template_id_,contract_,user_id_);
END Save_Template;


-- Remove_Template
--   Removes Template data.
PROCEDURE Remove_Template (
   customer_no_ IN VARCHAR2,
   template_id_ IN VARCHAR2 )
IS
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   info_       VARCHAR2(2000);

BEGIN
   Get_Id_Version_By_Keys___(objid_,objversion_,customer_no_,template_id_);
   Remove__(info_,objid_,objversion_,'DO');
END Remove_Template;



