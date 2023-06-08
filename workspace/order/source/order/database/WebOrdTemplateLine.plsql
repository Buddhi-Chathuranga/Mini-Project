-----------------------------------------------------------------------------
--
--  Logical unit: WebOrdTemplateLine
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  170824  ShPrlk  Bug 136668, Modified Calculate_Part_Price to adjust parameters for the method call Sales_Price_List_API.Get_Valid_Price_List.
--  160907  SudJlk  STRSC-3927, Modified Calculate_Part_Price to pass the new parameter value to Customer_Agreement_API.Get_First_Valid_Agreement
--  151126  PrYaLK  Bug 125684, Made Get_Order_Part_Info(7 parameters) returns conv_factor_ dividing by the Inverted Conversion Factor.
--  150819  PrYaLK  Bug 121587, Added parameters inverted_conv_factor_ and cross_rec_. Modified fetching catalog_no_, part_desc_, conv_factor_
--  150819          and inverted_conv_factor_ calling Sales_Part_Cross_Reference_API.Get(). Added deprecated method Get_Order_Part_Info().
--  140326  KiSalk  Bug 116089, Added method Add_Or_Modify_Line.
--  120213  HaPulk  Wrire dynamic code to MPCCOM (UserAllowedSite) as static
--  111018  MaRalk  Modified method Calculate_Part_Price by adjusting the parameters for the method call Sales_Price_List_API.Get_Valid_Price_List.
--  100513  KRPELK  Merge Rose Method Documentation.
--  090924  MaMalk  Removed constants installed_SalesPart, installed_SalesPartCrossRef,installed_CustomerAgreement and installed_CustomerOrderPricing.
--  -------------------- 14.0.0 --------------------------------------------- 
--  081201  HoInlk  Bug 78456, Moved global LU CONSTANTS defined in specification to implementation.
--  090624  KiSalk  Changed call Customer_Order_Pricing_API.Get_Valid_Price_List to Sales_Price_List_API.Get_Valid_Price_List.
--  090120  DaZase  Added parameters to call Customer_Order_Pricing_API.Get_Valid_Price_List inside method Calculate_Part_Price.
--  060720  RoJalk  Centralized Part Desc - Use Sales_Part_API.Get_Catalog_Desc.
--  060609  RoJalk  Enlarge Description - changed variables definitions, removed 
--  060609          unnessasary dynamic calls to ORDER packages and included methods
--  060609          since the files were moved to ORDER from SCENTR.
--  060606  MiErlk  Enlarge Description - Changed Variables Definitions.
--  --------------------------------- 13.4.0 --------------------------------
--  060125  NiDalk  Rewrote the DBMS_SQL to Native dynamic SQL and added Assert safe annotation. 
--  060112  MiKulk  Modified the PROCEDURE Insert___ according to the new template.
--  050922  NaLrlk  Removed unused variables.
--  040712  KeFelk  Additional changes due to 43255.
--  040513  ThGuLk  Created. File was moved from SCENTR module to ORDER, calls to 'Dynamic_Support_Issue_API.Get_Site_Date' was replaced with 'Site_API.Get_Site_Date
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Get_Default_Site___ RETURN VARCHAR2
IS   
   i_contract_    VARCHAR2(5);
BEGIN
   i_contract_ := User_Allowed_Site_API.Get_Default_Site;   
   RETURN i_contract_;
END Get_Default_Site___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Order_Part_Info
--   This method gets the order part information, depending on existing
--   customer part.
@Deprecated
PROCEDURE Get_Order_Part_Info (
   catalog_no_    OUT VARCHAR2,
   part_desc_     OUT VARCHAR2,
   unit_meas_     OUT VARCHAR2,
   conv_factor_   OUT VARCHAR2,
   contract_      IN  VARCHAR2,
   customer_no_   IN  VARCHAR2,
   part_no_       IN  VARCHAR2 )
IS
BEGIN

   -- check IF part no exist as a Customer Sales Part No
   unit_meas_ := Sales_Part_Cross_Reference_API.Get_Customer_Unit_Meas(customer_no_, contract_, part_no_);

   IF (unit_meas_ IS NULL) THEN
      catalog_no_  := part_no_;
      conv_factor_ := 1;
      part_desc_   := Sales_Part_API.Get_Catalog_Desc(contract_, part_no_);
      unit_meas_   := Sales_Part_API.Get_Sales_Unit_Meas(contract_, part_no_);
   ELSE
      catalog_no_  := Sales_Part_Cross_Reference_API.Get_Catalog_No(customer_no_, contract_, part_no_);
      part_desc_   := Sales_Part_Cross_Reference_API.Get_Catalog_Desc(customer_no_, contract_, part_no_);
      conv_factor_ := Sales_Part_Cross_Reference_API.Get_Conv_Factor(customer_no_, contract_, part_no_) / Sales_Part_Cross_Reference_API.Get_Inverted_Conv_Factor(customer_no_, contract_, part_no_);
   END IF;
END Get_Order_Part_Info;

-- Get_Order_Part_Info
--   This method gets the order part information, depending on existing
--   customer part.
PROCEDURE Get_Order_Part_Info (
   catalog_no_           OUT VARCHAR2,
   part_desc_            OUT VARCHAR2,
   unit_meas_            OUT VARCHAR2,
   conv_factor_          OUT VARCHAR2,
   inverted_conv_factor_ OUT VARCHAR2,
   cross_rec_            OUT Sales_Part_Cross_Reference_API.Public_Rec,
   contract_             IN  VARCHAR2,
   customer_no_          IN  VARCHAR2,
   part_no_              IN  VARCHAR2 )
IS
BEGIN
   -- check IF part no exist as a Customer Sales Part No
   unit_meas_ := Sales_Part_Cross_Reference_API.Get_Customer_Unit_Meas(customer_no_, contract_, part_no_);

   IF (unit_meas_ IS NULL) THEN
      catalog_no_           := part_no_;
      conv_factor_          := 1;
      inverted_conv_factor_ := 1;
      part_desc_            := Sales_Part_API.Get_Catalog_Desc(contract_, part_no_);
      unit_meas_            := Sales_Part_API.Get_Sales_Unit_Meas(contract_, part_no_);    
   ELSE
      cross_rec_            := Sales_Part_Cross_Reference_API.Get(customer_no_, contract_, part_no_);
      catalog_no_           := cross_rec_.catalog_no;
      part_desc_            := cross_rec_.catalog_desc;
      conv_factor_          := cross_rec_.conv_factor;
      inverted_conv_factor_ := cross_rec_.inverted_conv_factor;
   END IF;
END Get_Order_Part_Info;

-- New
--   Inserts Template Head Data.
PROCEDURE New (
   info_ OUT VARCHAR2,
   customer_no_ IN VARCHAR2,
   template_id_ IN VARCHAR2,
   part_no_ IN VARCHAR2,
   contract_ IN VARCHAR2,
   user_id_ IN VARCHAR2,
   quantity_ IN NUMBER )
IS
   attr_          VARCHAR2(2000);
   newrec_        WEB_ORD_TEMPLATE_LINE_TAB%ROWTYPE;
   objid_         VARCHAR2(2000);
   objversion_    VARCHAR2(2000);
   template_      VARCHAR2(20);
   site_date_    DATE;
BEGIN
   newrec_.customer_no := customer_no_;

   IF (template_id_ IS NULL) THEN
       template_ := 'id:'||user_id_ ;
       newrec_.template_id := template_;
   ELSE
       newrec_.template_id := template_id_;
   END IF;
   newrec_.part_no := part_no_;
   newrec_.quantity := quantity_;

   site_date_ := Site_API.Get_Site_Date(contract_);
   newrec_.change_date := site_date_;

   Error_SYS.Check_Not_Null(lu_name_, 'CUSTOMER_NO', newrec_.customer_no);
   Error_SYS.Check_Not_Null(lu_name_, 'TEMPLATE_ID', newrec_.template_id);
   Error_SYS.Check_Not_Null(lu_name_, 'PART_NO', newrec_.part_no);
   Error_SYS.Check_Not_Null(lu_name_, 'CHANGE_DATE', newrec_.change_date);

   Insert___(objid_, objversion_, newrec_, attr_);
   info_ := Client_SYS.Get_All_Info;
END New;


-- Modify_Lines
--   Updates the Template lines.
PROCEDURE Modify_Lines (
   info_ OUT VARCHAR2,
   customer_no_ IN VARCHAR2,
   template_id_ IN VARCHAR2,
   part_no_ IN VARCHAR2,
   contract_ IN VARCHAR2,
   user_id_ IN VARCHAR2,
   quantity_ IN NUMBER )
IS
   oldrec_     WEB_ORD_TEMPLATE_LINE_TAB%ROWTYPE;
   newrec_     WEB_ORD_TEMPLATE_LINE_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   attr_       VARCHAR2(2000);
   template_   VARCHAR2(20);

BEGIN

   IF (template_id_ IS NULL) THEN
      template_ := 'id:'||user_id_;
   ELSE
      template_ := template_id_;
   END IF;
   oldrec_ := Lock_By_Keys___(customer_no_,template_,part_no_);
   newrec_ := oldrec_;
   newrec_.quantity := quantity_;
   newrec_.change_date := Site_API.Get_Site_Date(contract_);

   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
   info_ := Client_SYS.Get_All_Info;
END Modify_Lines;


-- Remove_Lines
--   Remove template lines.
PROCEDURE Remove_Lines (
   customer_no_ IN VARCHAR2,
   template_id_ IN VARCHAR2 )
IS
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   info_       VARCHAR2(2000);

   CURSOR get_attr IS
      SELECT part_no
      FROM WEB_ORD_TEMPLATE_LINE_TAB
      WHERE customer_no = customer_no_
      AND   template_id = template_id_;
BEGIN
   FOR get_line_ in get_attr LOOP
      Get_Id_Version_By_Keys___(objid_,objversion_,customer_no_,template_id_,get_line_.part_no);
      Remove__(info_,objid_,objversion_,'DO');
   END LOOP;
END Remove_Lines;


PROCEDURE Copy_Parts (
   customer_no_ IN VARCHAR2,
   template_id_ IN VARCHAR2,
   contract_ IN VARCHAR2,
   user_id_ IN VARCHAR2 )
IS
   info_       VARCHAR2(2000);
   template_   VARCHAR2(25);

   CURSOR get_attr IS
      SELECT part_no,quantity
      FROM WEB_ORD_TEMPLATE_LINE_TAB
      WHERE customer_no = customer_no_
      AND   template_id = template_id_;
BEGIN
   template_ := 'id:'||user_id_;
   FOR get_line_ in get_attr LOOP
      New(info_,customer_no_,template_,get_line_.part_no,contract_,user_id_,get_line_.quantity);
   END LOOP;
END Copy_Parts;


-- Copy_Parts_To_Template
--   Method Copying Parts to Template.
PROCEDURE Copy_Parts_To_Template (
   customer_no_ IN VARCHAR2,
   template_id_ IN VARCHAR2,
   contract_ IN VARCHAR2,
   user_id_ IN VARCHAR2 )
IS
   info_       VARCHAR2(2000);

   CURSOR get_attr IS
      SELECT part_no,quantity
      FROM WEB_ORD_TEMPLATE_LINE_TAB
      WHERE customer_no = customer_no_
      AND   template_id = 'id:'||user_id_;
BEGIN
   FOR get_line_ in get_attr LOOP
      New(info_,customer_no_,template_id_,get_line_.part_no,contract_,user_id_,get_line_.quantity);
   END LOOP;
END Copy_Parts_To_Template;


-- Get_Order_Part_Desc
--   Method returning Order Part Description.
FUNCTION Get_Order_Part_Desc (
   customer_no_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   unit_meas_ VARCHAR2(10);
   part_desc_ SALES_PART_TAB.catalog_desc%TYPE;
   contract_  VARCHAR2(5);
BEGIN
   contract_ := Get_Default_Site___;
   -- check IF part no exist as a Customer Sales Part No
   unit_meas_ := Sales_Part_Cross_Reference_API.Get_Customer_Unit_Meas(customer_no_, contract_, part_no_);

   IF (unit_meas_ IS NULL) THEN
      part_desc_   := Sales_Part_API.Get_Catalog_Desc(contract_,part_no_);
   ELSE
      part_desc_   := Sales_Part_Cross_Reference_API.Get_Catalog_Desc(customer_no_, contract_, part_no_);
   END IF;
   RETURN part_desc_;
END Get_Order_Part_Desc;


-- Get_Order_Part_Unitmeas
--   Method returning Unit of Measure for Order Parts.
FUNCTION Get_Order_Part_Unitmeas (
   customer_no_ IN VARCHAR2,
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   unit_meas_ VARCHAR2(10);
   contract_  VARCHAR2(5);

BEGIN
   contract_ := Get_Default_Site___;
   -- check IF part no exist as a Customer Sales Part No
   unit_meas_ := Sales_Part_Cross_Reference_API.Get_Customer_Unit_Meas(customer_no_, contract_, part_no_);
   
   IF (unit_meas_ IS NULL) THEN
      unit_meas_   := Sales_Part_API.Get_Sales_Unit_Meas(contract_, part_no_);
   END IF;
   RETURN unit_meas_;
END Get_Order_Part_Unitmeas;


-- Remove_Part
--   Removes a part.
PROCEDURE Remove_Part (
   customer_no_ IN VARCHAR2,
   template_id_ IN VARCHAR2,
   part_no_ IN VARCHAR2 )
IS
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   info_       VARCHAR2(2000);

BEGIN
   Get_Id_Version_By_Keys___(objid_,objversion_,customer_no_,template_id_,part_no_);
   Remove__(info_,objid_,objversion_,'DO');

END Remove_Part;


-- Calculate_Part_Price
--   Calculate Customer Part Price
PROCEDURE Calculate_Part_Price (
   sale_unit_price_ OUT NUMBER,
   discount_ OUT NUMBER,
   site_date_ IN DATE,
   contract_ IN VARCHAR2,
   customer_no_ IN VARCHAR2,
   catalog_no_ IN VARCHAR2,
   currency_code_ IN VARCHAR2,
   quantity_ IN NUMBER )
IS

   agreement_id_              VARCHAR2(10);
   price_list_no_             VARCHAR2(10);
   unit_price_incl_tax_       NUMBER;
   base_sale_unit_price_      NUMBER;
   base_unit_price_incl_tax_  NUMBER;
   price_source_              VARCHAR2(2000);
   currency_rate_             NUMBER;
   customer_level_db_         VARCHAR2(30) := NULL;
   customer_level_id_         VARCHAR2(200) := NULL;
   use_price_incl_tax_        VARCHAR2(20) := 'FALSE';
BEGIN
   
   agreement_id_ := Customer_Agreement_API.Get_First_Valid_Agreement(customer_no_ ,
                                                                     contract_ ,
                                                                     currency_code_ ,
                                                                     site_date_,
                                                                     'FALSE');
                    
   Sales_Price_List_API.Get_Valid_Price_List(customer_level_db_, 
                                             customer_level_id_,
                                             price_list_no_,
                                             contract_,
                                             catalog_no_,
                                             customer_no_,
                                             currency_code_,
                                             site_date_,
                                             NULL);

   Customer_Order_Pricing_API.Get_Sales_Part_Price_Info_Web(
      sale_unit_price_ ,
      unit_price_incl_tax_,
      base_sale_unit_price_,
      base_unit_price_incl_tax_,
      currency_rate_,
      discount_ ,
      price_source_,
      contract_,
      customer_no_ ,
      currency_code_ ,
      agreement_id_ ,
      catalog_no_ ,
      quantity_ ,
      price_list_no_ ,
      site_date_,
      use_price_incl_tax_);
      
END Calculate_Part_Price;


-----------------------------------------------------------------------------
-- Add_Or_Modify_Line
--    Updates the Template line if it exists or add as a new record otherwise.
-----------------------------------------------------------------------------
PROCEDURE Add_Or_Modify_Line (
   info_        OUT VARCHAR2,
   customer_no_ IN VARCHAR2,
   template_id_ IN VARCHAR2,
   part_no_     IN VARCHAR2,
   contract_    IN VARCHAR2,
   user_id_     IN VARCHAR2,
   quantity_    IN NUMBER )
IS

BEGIN
   IF (Check_Exist___(customer_no_, template_id_, part_no_)) THEN
      Modify_Lines(info_,
                   customer_no_,
                   template_id_,
                   part_no_,
                   contract_,
                   user_id_,
                   quantity_ );
   ELSE
      New(info_,
          customer_no_,
          template_id_,
          part_no_,
          contract_,
          user_id_,
          quantity_ );
   END IF;
END Add_Or_Modify_Line;

