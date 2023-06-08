-----------------------------------------------------------------------------
--
--  Logical unit: SalesPriceListSite
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210112  MaEelk   SC2020R1-12036, Replaced the Unpack___, check_Insert___ and Insert___ with New___ in Copy_Price_List_Sites__ and New.
--  120113  ChFolk   Added alias to the SALES_PRICE_LIST_SITE view and use it for the sub query as to get correct filteration.
--  111103  ChJalk   Added user allowed company and site filter to the base view SALES_PRICE_LIST_SITE.
--  101224  ShKolk   Restricted deletion of sites by unauthorized users.
--  101210  ShKolk   Renamed company to owning_company in Unpack_Check_Insert___.
--  101109  RaKalk   Modified Unpack_Check_Insert___ function to validate header currency against site company
--  101103  RaKalk  Restricted modifications of price list by unauthorised users.
--  090924  KiSalk  Modified Copy_Price_List_Sites__ to filter for user allowed sites.
--  090827  MaJalk  Added method Copy_Price_List_Sites__.
--  090825  MaJalk  Added error message INVALSITEFORPL to Unpack_Check_Insert___.
--  060112  MiKulk  Modified the PROCEDURE Insert___ according to the new template.
--  040913  HaPulk   Fixed error in View Comment SALES_PRICE_LIST_SITE_LOV.CONTRACT_DESC.
--  --------------------- 13.3.0 --------------------------------------------
--  031013  BhRalk   Added new view  SALES_PRICE_LIST_SITE_LOV.
--  991007  JoEd     Replaced Utility_SYS.Get_User with Fnd_Session_API.Get_Fnd_User.
--  ---------------------- 11.1 ---------------------------------------------
--  990303  RaKu     Added User_Allowed_Site-check.
--  981130  RaKu     Changes to match Design.
--  981022  RaKu     Added function Check_Exist.
--  981021  RaKu     Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Delete___ (
   remrec_ IN SALES_PRICE_LIST_SITE_TAB%ROWTYPE )
IS
BEGIN
   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, remrec_.contract);
   Sales_Price_List_API.Check_Editable(remrec_.price_list_no);

   super(remrec_);
END Check_Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT sales_price_list_site_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS  
   dummy_currtype_     VARCHAR2(10);
   dummy_conv_factor_  NUMBER;
   dummy_rate_         NUMBER;
   site_company_       SITE_TAB.COMPANY%TYPE;
   price_list_rec_     SALES_PRICE_LIST_API.Public_Rec;
BEGIN
   super(newrec_, indrec_, attr_);
   
   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, newrec_.contract);   
   site_company_   := Site_API.Get_Company(newrec_.contract);
   price_list_rec_ := Sales_Price_List_API.Get(newrec_.price_list_no);
   IF site_company_ != price_list_rec_.owning_company THEN
      Invoice_Library_API.Get_Currency_Rate_Defaults(dummy_currtype_,
                                                     dummy_conv_factor_,
                                                     dummy_rate_,
                                                     site_company_,
                                                     price_list_rec_.currency_code,
                                                     SYSDATE,
                                                     'CUSTOMER',
                                                     NULL);
   END IF;
END Check_Insert___;

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     sales_price_list_site_tab%ROWTYPE,
   newrec_ IN OUT sales_price_list_site_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS 
BEGIN
   --Add pre-processing code here
   super(oldrec_, newrec_, indrec_, attr_);
   --Add post-processing code here
   Sales_Price_List_API.Check_Editable(newrec_.price_list_no);
END Check_Common___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Copy_Price_List_Sites__
--   Copies all Valid for Site records from one price list to another.
PROCEDURE Copy_Price_List_Sites__ (
   price_list_no_     IN VARCHAR2,
   to_price_list_no_  IN VARCHAR2 )
IS
   newrec_          SALES_PRICE_LIST_SITE_TAB%ROWTYPE;
   
   CURSOR from_sites_ IS
      SELECT contract
      FROM sales_price_list_site_tab
      WHERE price_list_no = price_list_no_
      AND EXISTS (SELECT 1 FROM user_allowed_site_pub WHERE contract = site);
BEGIN
   -- Copy the lines
   FOR sites_rec_ IN from_sites_ LOOP
      newrec_.contract := sites_rec_.contract;
      newrec_.price_list_no := to_price_list_no_;
      New___(newrec_);
   END LOOP;
END Copy_Price_List_Sites__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Check_Exist
--   Returns TRUE if the specified return exists.
@UncheckedAccess
FUNCTION Check_Exist (
   contract_ IN VARCHAR2,
   price_list_no_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN Check_Exist___(contract_, price_list_no_);
END Check_Exist;

PROCEDURE New (
   info_            OUT VARCHAR2,   
   contract_        IN  VARCHAR2,
   price_list_no_   IN  VARCHAR2)
IS
   newrec_          SALES_PRICE_LIST_SITE_TAB%ROWTYPE;   
BEGIN
   newrec_.contract := contract_;
   newrec_.price_list_no := price_list_no_;
   New___(newrec_);
END;


