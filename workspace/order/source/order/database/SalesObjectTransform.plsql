-----------------------------------------------------------------------------
--
--  Logical unit: SalesObjectTransform
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  181203  NiDalk  Bug 145626(SCZCRM-275), Added Transf_Order_Line_To_Opp_Line and Transf_Quote_Line_To_Opp_Line to get the keys of the business opportunity line
--. 181203          to show the the originated opportunity line documents from customer order line and quotation line.
--  130212  IRJALK  Bug 108032, Created. Added new transformation methods for object connection LU transformations,from CustomerOrderLine to 
--  130212          PartRevision, from CustomerOrderLine to EngPartRevision, from SalesPart to PartRevision and from SalesPart to EngPartRevision
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Get_Part_Revision_Key_Ref___ (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   site_date_         DATE;
   eng_chg_level_     VARCHAR2(6);
BEGIN
   site_date_ := Site_API.Get_Site_Date(contract_);
   eng_chg_level_ := Inventory_Part_Revision_API.Get_Eng_Chg_Level(contract_, part_no_, site_date_);
   RETURN  'CONTRACT=' || contract_ ||
           '^ENG_CHG_LEVEL=' || eng_chg_level_ ||
           '^PART_NO=' || part_no_ || '^'; 
END Get_Part_Revision_Key_Ref___;


FUNCTION Get_Eng_Part_Rev_Key_Ref___ (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   site_date_       DATE;
   eng_chg_level_   VARCHAR2(6);
   eng_revision_    VARCHAR2(6);
   source_key_ref_  VARCHAR2(2000);
BEGIN
   $IF Component_Mfgstd_SYS.INSTALLED $THEN
      site_date_ := Site_API.Get_Site_Date(contract_);
      eng_chg_level_ := Inventory_Part_Revision_API.Get_Eng_Chg_Level(contract_, part_no_, site_date_);
   
      eng_revision_:= Part_Revision_API.Get_Eng_Revision(contract_, part_no_, eng_chg_level_);
      source_key_ref_ := 'PART_NO=' || part_no_ ||
                         '^PART_REV=' || eng_revision_ ||'^';                                          
   $END
   RETURN source_key_ref_;
END Get_Eng_Part_Rev_Key_Ref___;   


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Transf_Ord_Line_To_Part_Rev
--   Transform the key ref from lu: CustomerOrderLine to PartRevision.
--   Used for Object Connection LU Transformations
FUNCTION Transf_Ord_Line_To_Part_Rev (
   target_key_ref_   IN VARCHAR2,
   service_name_     IN VARCHAR2 ) RETURN VARCHAR2
IS
   rec_              Customer_Order_Line_API.Public_Rec;
   
BEGIN
   
   rec_ := Customer_Order_Line_API.Get(Client_SYS.Get_Key_Reference_Value(target_key_ref_, 'ORDER_NO'),
                                       Client_SYS.Get_Key_Reference_Value(target_key_ref_, 'LINE_NO'),
                                       Client_SYS.Get_Key_Reference_Value(target_key_ref_, 'REL_NO'),
                                       Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Key_Reference_Value(target_key_ref_, 'LINE_ITEM_NO')));
   RETURN Get_Part_Revision_Key_Ref___(rec_.contract, rec_.part_no);         
END Transf_Ord_Line_To_Part_Rev;


-- Transf_Ord_Line_To_Eng_Part_Rv
--   Transform the key ref from lu: CustomerOrderLine to EngPartRevision.
--   Used for Object Connection LU Transformations
FUNCTION Transf_Ord_Line_To_Eng_Part_Rv (
   target_key_ref_   IN VARCHAR2,
   service_name_     IN VARCHAR2 ) RETURN VARCHAR2
IS
   rec_             Customer_Order_Line_API.Public_Rec;
    
BEGIN
  
   rec_ := Customer_Order_Line_API.Get(Client_SYS.Get_Key_Reference_Value(target_key_ref_, 'ORDER_NO'),
                                       Client_SYS.Get_Key_Reference_Value(target_key_ref_, 'LINE_NO'),
                                       Client_SYS.Get_Key_Reference_Value(target_key_ref_, 'REL_NO'),
                                       Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Key_Reference_Value(target_key_ref_, 'LINE_ITEM_NO')));
   RETURN Get_Eng_Part_Rev_Key_Ref___(rec_.contract, rec_.part_no);      
END Transf_Ord_Line_To_Eng_Part_Rv;   


-- Transf_Sales_Part_To_Part_Rev
--   Transform the key ref from lu: SalesPart to PartRevision.
--   Used for Object Connection LU Transformations
FUNCTION Transf_Sales_Part_To_Part_Rev (
   target_key_ref_   IN VARCHAR2,
   service_name_     IN VARCHAR2 ) RETURN VARCHAR2
IS
   contract_         VARCHAR2(20);
   part_no_          VARCHAR2(100);        
BEGIN
   
   contract_  := Client_SYS.Get_Key_Reference_Value(target_key_ref_, 'CONTRACT');
   part_no_   := Sales_Part_API.Get_Part_No(contract_,
                                            Client_SYS.Get_Key_Reference_Value(target_key_ref_, 'CATALOG_NO'));
   RETURN Get_Part_Revision_Key_Ref___(contract_, part_no_);           
END Transf_Sales_Part_To_Part_Rev;


-- Transf_Sales_To_Eng_Part_Rev
--   Transform the key ref from lu: SalesPart to EngPartRevision.
--   Used for Object Connection LU Transformations
FUNCTION Transf_Sales_To_Eng_Part_Rev (
   target_key_ref_   IN VARCHAR2,
   service_name_     IN VARCHAR2 ) RETURN VARCHAR2
IS
   contract_       VARCHAR2(20);
   part_no_        VARCHAR2(100);   
BEGIN
   
   contract_      := Client_SYS.Get_Key_Reference_Value(target_key_ref_, 'CONTRACT');
   part_no_       := Sales_Part_API.Get_Part_No(contract_,
                                                Client_SYS.Get_Key_Reference_Value(target_key_ref_, 'CATALOG_NO'));
   RETURN Get_Eng_Part_Rev_Key_Ref___(contract_, part_no_);    
END Transf_Sales_To_Eng_Part_Rev;

------------------------------------------------------------------------------------------
-- Transf_Opp_Line_To_Order_Line
--    Returns keys of originated business opportunity line record to fetch documents of opportunity line
--    from customer order line.
------------------------------------------------------------------------------------------
FUNCTION Transf_Order_Line_To_Opp_Line (
   target_key_ref_   IN VARCHAR2,
   service_name_     IN VARCHAR2 ) RETURN VARCHAR2
IS
   source_key_ref_   VARCHAR2(100) := NULL;
   $IF Component_Crm_SYS.INSTALLED $THEN
      opportunity_no_   BUSINESS_OPPORTUNITY_LINE_TAB.opportunity_no%TYPE;
      opp_line_no_      BUSINESS_OPPORTUNITY_LINE_TAB.line_no%TYPE;
      revision_no_      BUSINESS_OPPORTUNITY_LINE_TAB.revision_no%TYPE;
   $END
BEGIN
   $IF Component_Crm_SYS.INSTALLED $THEN
      Business_Opportunity_Line_API.Get_Opp_Line_From_Conn_Obj(opportunity_no_,
                                                               opp_line_no_,
                                                               revision_no_,
                                                               Business_Object_Type_API.DB_CUSTOMER_ORDER,
                                                               Client_SYS.Get_Key_Reference_Value(target_key_ref_, 'ORDER_NO'),
                                                               Client_SYS.Get_Key_Reference_Value(target_key_ref_, 'LINE_NO'), 
                                                               Client_SYS.Get_Key_Reference_Value(target_key_ref_, 'REL_NO'), 
                                                               Client_SYS.Get_Key_Reference_Value(target_key_ref_, 'LINE_ITEM_NO'));
      source_key_ref_ :=  'LINE_NO='|| opp_line_no_ || '^OPPORTUNITY_NO=' || opportunity_no_ || '^REVISION_NO=' || revision_no_ || '^';
   $END
   RETURN source_key_ref_;
END Transf_Order_Line_To_Opp_Line;

------------------------------------------------------------------------------------------
-- Transf_Opp_Line_To_Quote_Line
--    Returns keys of originated business opportunity line record to fetch documents of opportunity line
--    from quotation line.
------------------------------------------------------------------------------------------
FUNCTION Transf_Quote_Line_To_Opp_Line (
   target_key_ref_   IN VARCHAR2,
   service_name_     IN VARCHAR2 ) RETURN VARCHAR2
IS
   source_key_ref_   VARCHAR2(100) := NULL;
   $IF Component_Crm_SYS.INSTALLED $THEN
      opportunity_no_   BUSINESS_OPPORTUNITY_LINE_TAB.opportunity_no%TYPE;
      opp_line_no_      BUSINESS_OPPORTUNITY_LINE_TAB.line_no%TYPE;
      revision_no_      BUSINESS_OPPORTUNITY_LINE_TAB.revision_no%TYPE;
   $END

BEGIN
   $IF Component_Crm_SYS.INSTALLED $THEN
      Business_Opportunity_Line_API.Get_Opp_Line_From_Conn_Obj(opportunity_no_,
                                                               opp_line_no_,
                                                               revision_no_,
                                                               Business_Object_Type_API.DB_SALES_QUOTATION,
                                                               Client_SYS.Get_Key_Reference_Value(target_key_ref_, 'QUOTATION_NO'),
                                                               Client_SYS.Get_Key_Reference_Value(target_key_ref_, 'LINE_NO'), 
                                                               Client_SYS.Get_Key_Reference_Value(target_key_ref_, 'REL_NO'), 
                                                               Client_SYS.Get_Key_Reference_Value(target_key_ref_, 'LINE_ITEM_NO'));

      source_key_ref_ :=  'LINE_NO='|| opp_line_no_ || '^OPPORTUNITY_NO=' || opportunity_no_ || '^REVISION_NO=' || revision_no_ || '^';
   $END
   RETURN source_key_ref_;
END Transf_Quote_Line_To_Opp_Line;

